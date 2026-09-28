# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cqcp100.4gl
# Descriptions...: IQC整批录入
# Date & Author..:darcy:2022/11/15

database ds

globals "../../../tiptop/config/top.global"

type new record
    checkqcs    like type_file.chr1  ,
    qcs00       like qcs_file.qcs00  ,
    qcs01       like qcs_file.qcs01  ,
    qcs02       like qcs_file.qcs02  ,
    qcs05       like qcs_file.qcs05  ,
    qcs021      like qcs_file.qcs021 ,
    ima02       like ima_file.ima02  ,
    ima021      like ima_file.ima021 ,
    qcs03       like qcs_file.qcs03  ,
    pmc03       like pmc_file.pmc03  ,
    qcs14       like qcs_file.qcs14  ,
    qcs21       like qcs_file.qcs21  ,
    qcs04       like qcs_file.qcs04  ,
    qcs041      like qcs_file.qcs041 ,
    qcsud07     like qcs_file.qcsud07,
    qcs22       like qcs_file.qcs22  ,
    qcs091      like qcs_file.qcs091 ,
    qcs09       like qcs_file.qcs09  ,
    des01       like gen_file.gen02  ,
    qcs13       like qcs_file.qcs13  ,
    des02       like gen_file.gen02  ,
    qcsud01			like qcs_file.qcsud01,
    qcsud03     like qcs_file.qcsud03,
    qcsud04			like qcs_file.qcsud04,
    qcsud05			like qcs_file.qcsud05,
    qcsud06			like qcs_file.qcsud06,
    qcsud14			like qcs_file.qcsud14
end record

type qcs record like qcs_file.*

define g_new dynamic array of new
define g_qcs qcs
define l_rva         RECORD LIKE rva_file.*,
       l_rvb         RECORD LIKE rvb_file.*,
       l_rvbs        RECORD LIKE rvbs_file.*,
       l_qcs         RECORD LIKE qcs_file.*,
       l_qcd         RECORD LIKE qcd_file.*,
       l_pmm         RECORD LIKE pmm_file.*,
       l_pmn         RECORD LIKE pmn_file.*
define l_ac integer
define g_ima101  like ima_file.ima101
define l_ecm04      like ecm_file.ecm04
define l_type       like type_file.chr20
define l_qcs22      like qcs_file.qcs22
define l_flag       like type_file.chr1
define l_qcs021     like qcs_file.qcs021
define l_qcd03      like qcd_file.qcd03
define l_qcd05      like qcd_file.qcd05
define l_qdf02      like qdf_file.qdf02
define l_k          like type_file.num5
define g_cnt          like type_file.num5

main
    define   p_row,p_col   like type_file.num5
    options
        input no wrap
    defer interrupt

    if (not cl_user()) then
        exit program
    end if

    whenever error call cl_err_msg_log

    if (not cl_setup("CQC")) then
        exit program
    end if

    call cl_used(g_prog,g_time,1) returning g_time
    open window cqcp100_w at p_row,p_col with form "cqc/42f/cqcp100"
            attribute (style = g_win_style clipped)

    call cl_ui_init()

    call p100_crt_tmp()
    call p100_init()

    call p100_menu()

    close window cqcp100_w
    call  cl_used(g_prog,g_time,2) returning g_time
end main

function p100_menu()
    while true
        call p100_b()
        case g_action_choice
            when "insert"
                call p100_insert()
            when "help"
                call cl_show_help()
            when "exit"
                exit while
            when "controlg"
                call cl_cmdask()
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_new),'','')
                end if
            when "restart"
                call p100_init()
            when "accept"
                call p100_done()
            when "updqcsud03"
                call p100_updqcsud03()
        end case
    end while
end function
function p100_b()
    define l_index integer
    define qcs01_t like qcs_file.qcs01

    # call cl_set_act_visible("accept,cancel", false)

    if g_action_choice = "accept" then
        if cl_confirm("cqc-006") then
            call p100_restart()
        else
            let g_action_choice = 'exit'
            return
        end if
    end if

    input array g_new without defaults from s_new.*
        attribute(maxcount=g_max_rec,unbuffered,
        insert row=true,delete row=true,append row=false)

        before row
            let l_ac = arr_curr()
            let qcs01_t = g_new[l_ac].qcs01
        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'exit'
            exit input
        on action cancel
            let g_action_choice = 'exit'
            exit input
        on action accept
            let g_action_choice = 'accept'
            exit input

        on row change

        on change qcs01
             let g_new[l_ac].qcs01 = qcs01_t
             call cl_err("不可修改此字段","!",0)
             next field qcs01

        before delete
            #删除单号
            begin work
            delete from p100_qry_tmp where qcs01 = g_new[l_ac].qcs01 and qcs02 = g_new[l_ac].qcs02
            if status then
                call cl_err("del p100_qry_tmp",status,1)
                rollback work
                cancel delete
            end if
            delete from p100_qcs_tmp where qcs01 = g_new[l_ac].qcs01 and qcs02 = g_new[l_ac].qcs02
            if status then
                call cl_err("del p100_qry_tmp",status,1)
                rollback work
                cancel delete
            end if
            delete from p100_qct_tmp where qct01 = g_new[l_ac].qcs01 and qct02 = g_new[l_ac].qcs02
            if status then
                call cl_err("del p100_qry_tmp",status,1)
                rollback work
                cancel delete
            end if
            commit work
            message "删除成功!"

        on change qcsud03
            if not cl_null(g_new[l_ac].qcsud03) then
                update p100_qcs_tmp set qcsud03 = g_new[l_ac].qcsud03
                 where qcs01 = g_new[l_ac].qcs01 and qcs02 = g_new[l_ac].qcs02
                if status then
                    call cl_err('upd p100_qcs_tmp',status,1)
                end if
            end if

        on action controlp
            case
                when infield(qcs01)
                    call cq_qcs()
                    let g_action_choice = 'insert'
                    exit input
            end case

        on action checkall
            for l_index = 1 to g_new.getLength()
                let g_new[l_index].checkqcs = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_new.getLength()
                if g_new[l_index].checkqcs = 'Y' then
                    let g_new[l_index].checkqcs = 'N'
                else
                    let g_new[l_index].checkqcs = 'Y'
                end if
            end for

        on action updqcsud03
            let g_action_choice = "updqcsud03"
            exit input

    end input
    # call cl_set_act_visible("accept,cancel", true)
end function

function p100_crt_tmp()
    drop table p100_qry_tmp
    drop table p100_qcs_tmp
    drop table p100_qct_tmp
    drop table p100_rvbs_tmp
    create temp table p100_qry_tmp (
        qcs01 varchar(20),
        qcs02 integer
    )
    create temp table p100_qcs_tmp (
        qcs00    VARCHAR(1),
        qcs01    VARCHAR(20),
        qcs02    integer,
        qcs021   VARCHAR(40),
        qcs03    VARCHAR(10),
        qcs04    DATE,
        qcs041   VARCHAR(8),
        qcs05    integer,
        qcs06    DECIMAL(15,3),
        qcs061   DECIMAL(12,3),
        qcs062   VARCHAR(4),
        qcs071   DECIMAL(12,3),
        qcs072   VARCHAR(4),
        qcs081   DECIMAL(12,3),
        qcs082   VARCHAR(4),
        qcs09    VARCHAR(1),
        qcs091   DECIMAL(15,3),
        qcs10    VARCHAR(10),
        qcs101   integer,
        qcs11    VARCHAR(1),
        qcs12    VARCHAR(255),
        qcs13    VARCHAR(10),
        qcs14    VARCHAR(1),
        qcs15    DATE,
        qcs16    VARCHAR(1),
        qcs17    VARCHAR(1),
        qcs18    DATE,
        qcs19    VARCHAR(8),
        qcs20    VARCHAR(30),
        qcs21    VARCHAR(1),
        qcs22    DECIMAL(15,3),
        qcsprno  integer,
        qcsacti  VARCHAR(1),
        qcsuser  VARCHAR(10),
        qcsgrup  VARCHAR(10),
        qcsmodu  VARCHAR(10),
        qcsdate  DATE,
        qcs30    VARCHAR(4),
        qcs31    DECIMAL(20,8),
        qcs32    DECIMAL(15,3),
        qcs33    VARCHAR(4),
        qcs34    DECIMAL(20,8),
        qcs35    DECIMAL(15,3),
        qcs36    VARCHAR(4),
        qcs37    DECIMAL(20,8),
        qcs38    DECIMAL(15,3),
        qcs39    VARCHAR(4),
        qcs40    DECIMAL(20,8),
        qcs41    DECIMAL(15,3),
        qcsspc   VARCHAR(1),
        qcsud01  VARCHAR(255),
        qcsud02  VARCHAR(40),
        qcsud03  VARCHAR(40),
        qcsud04  VARCHAR(40),
        qcsud05  VARCHAR(40),
        qcsud06  VARCHAR(40),
        qcsud07  DECIMAL(15,3),
        qcsud08  VARCHAR(1800),
        qcsud09  DECIMAL(15,3),
        qcsud10  integer,
        qcsud11  VARCHAR(1800),
        qcsud12  VARCHAR(1800),
        qcsud13  DATE,
        qcsud14  DATE,
        qcsud15  DATE,
        qcsplant VARCHAR(10),
        qcslegal VARCHAR(10),
        qcsoriu  VARCHAR(10),
        qcsorig  VARCHAR(10)
    )
    create temp table p100_rvbs_tmp(
        rvbs00    VARCHAR(10),
        rvbs01    VARCHAR(20),
        rvbs02    integer,
        rvbs03    VARCHAR(30),
        rvbs04    VARCHAR(30),
        rvbs05    DATE,
        rvbs06    DECIMAL(15,3),
        rvbs07    VARCHAR(1),
        rvbs08    VARCHAR(20),
        rvbs021   VARCHAR(40),
        rvbs022   integer default 0,
        rvbs09    integer,
        rvbs10    DECIMAL(15,3),
        rvbs11    DECIMAL(15,3),
        rvbs12    DECIMAL(15,3),
        rvbs13    integer,
        rvbsplant VARCHAR(10),
        rvbslegal VARCHAR(10)
    )
    create temp table p100_qct_tmp(
        qct01    VARCHAR(20),
        qct02    integer,
        qct021   integer,
        qct03    integer,
        qct04    VARCHAR(40),
        qct05    VARCHAR(1),
        qct06    decimal(7,3),
        qct07    DECIMAL(15,3),
        qct08    VARCHAR(1),
        qct09    integer,
        qct10    integer,
        qct11    DECIMAL(15,3),
        qct12    VARCHAR(1),
        qct131   DECIMAL(15,3),
        qct132   DECIMAL(15,3),
        qctud01  VARCHAR(255),
        qctud02  VARCHAR(40),
        qctud03  VARCHAR(40),
        qctud04  VARCHAR(40),
        qctud05  VARCHAR(40),
        qctud06  VARCHAR(40),
        qctud07  DECIMAL(15,3),
        qctud08  DECIMAL(15,3),
        qctud09  DECIMAL(15,3),
        qctud10  integer,
        qctud11  integer,
        qctud12  integer,
        qctud13  DATE,
        qctud14  DATE,
        qctud15  DATE,
        qctplant VARCHAR(10),
        qctlegal VARCHAR(10),
        qct14    decimal(8,4),
        qct15    decimal(8,4)
    )
end function

function p100_init()
    # 删除临时表
    delete from p100_qry_tmp
    delete from p100_qcs_tmp
    delete from p100_qct_tmp
    delete from p100_rvbs_tmp
    # 删除临时表
    call g_new.clear()
    initialize g_qcs.* to null

    clear form

end function

function p100_insert()
    call p100_chk()
    call p100_b_fill()
end function

function p100_chk()
    define l_ima906  like ima_file.ima906
    define l_yn      like type_file.num5
    define l_cnt     like type_file.num5
    define l_ac_num  like type_file.num5
    define l_re_num  like type_file.num5
    define l_qct11   like qct_file.qct11
    define l_qct14   like qct_file.qct14
    define l_qct15   like qct_file.qct15
    define l_q       like qcs_file.qcs22
    define l_qcs03_t  like qcs_file.qcs03
    define seq        like qct_file.qct07
    define l_s        like type_file.chr1
    define l_n        like type_file.chr1
    define l_m        like type_file.chr1
    define l_t        like type_file.chr1
    define l_ima918   like ima_file.ima918
    define l_ima921   like ima_file.ima921
    define l_rvbs04   like rvbs_file.rvbs04
    define l_rvbs06   like rvbs_file.rvbs06
    define l_rvbs06s  like rvbs_file.rvbs06
    define l_qcs22s   like qcs_file.qcs22
    define l_ima44    like ima_file.ima44
    define l_str,l_sql,l_sql1      string


   LET l_sql1 ="SELECT * FROM rvb_file  ",
              " WHERE rvb19='1' AND rvb39='N' ",
              " and (rvb01,rvb02) in (select qcs01,qcs02 from p100_qry_tmp) ",
              " and (rvb01,rvb02) not in (select qcs01,qcs02 from p100_qcs_tmp)"
   PREPARE p001_p11 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_c11 CURSOR FOR p001_p11

   LET l_sql1 ="SELECT * FROM rvbs_file  ",
               " WHERE  rvbs01 = ? AND rvbs02=? AND rvbs09=1 ",   #TQC-C30012 modify and -> where
               "   AND rvbs13 = 0 AND rvbs00[1,7] <>'aqct110' "
   PREPARE p001_p11a FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11a error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs CURSOR FOR p001_p11a

   LET l_sql1 ="SELECT rvbs04,SUM(rvbs06) FROM rvbs_file  ",
               " WHERE rvbs01 = ? AND rvbs02=? AND rvbs09=1 AND rvbs13 = 0 ",  #TQC-C30012 modify and -> where
               "   AND rvbs00[1,7] <>'aqct110'  GROUP BY rvbs04"
   PREPARE p001_p11b FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11b error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs1 CURSOR FOR p001_p11b

   LET l_sql1 ="SELECT * FROM rvbs_file  ",
               " WHERE  rvbs01 = ? AND rvbs02=? AND rvbs04=? AND rvbs09=1 ",   #TQC-C30012 modify and -> where
               "   AND rvbs13 = 0 AND rvbs00[1,7] <>'aqct110' "
   PREPARE p001_p11c FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11c error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs2 CURSOR FOR p001_p11c

   LET g_success = 'Y'
   CALL s_showmsg_init()

   LET l_s = 'N'
   LET l_str = NULL  #FUN-C30064
    FOREACH p001_c11 into l_rvb.*

    #
    select * into l_rva.*  from rva_file where rva01 = l_rvb.rvb01
    #
    #產生QC單頭資料
            LET l_m = 'Y'
            LET l_s = 'Y'
            LET l_qcs.qcs00 = '2'
            LET l_qcs.qcs01 = l_rvb.rvb01
            LET l_qcs.qcs02 = l_rvb.rvb02
            LET l_qcs.qcs021 =l_rvb.rvb05
            LET l_qcs.qcs03 = l_rva.rva05
            LET l_qcs.qcs04 = g_today
            LET l_qcs.qcs041 = TIME

            SELECT pmm_file.*,pmn_file.* INTO l_pmm.*,l_pmn.*
            FROM pmm_file,pmn_file
            WHERE pmm01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03
            AND pmm01=pmn01  #MOD-C90134 add

            LET l_ecm04=' '     #MOD-C70225 add
            LET l_type='1'      #MOD-C70225 add

            IF l_pmm.pmm02='SUB' THEN
            LET l_type = '2'
            IF cl_null(l_pmn.pmn43) OR l_pmn.pmn43=0 THEN
                LET  l_ecm04=' '
            ELSE
                SELECT ecm04 INTO l_ecm04 FROM ecm_file
                WHERE ecm01=l_pmn.pmn41 AND ecm03=l_pmn.pmn43 AND ecm012=l_pmn.pmn012
            END IF
            END IF

            SELECT bmj10 INTO l_qcs.qcs10
            FROM bmj_file
            WHERE bmj01=l_qcs.qcs021
            AND (bmj02 IS NULL OR bmj02=l_pmn.pmn123 OR bmj02=' ')
            AND bmj03=l_qcs.qcs03
            AND (bmj10 IS NOT NULL AND bmj10<>' ')

            SELECT pmn63 INTO l_qcs.qcs16
            FROM pmn_file
            WHERE pmn01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03

            SELECT pmh16 INTO l_qcs.qcs17
            FROM pmh_file
            WHERE pmh01=l_qcs.qcs021
            AND pmh02=l_qcs.qcs03
            AND pmh21=l_ecm04
            AND pmh22=l_type
            AND pmh23=' '

            SELECT pmh09 INTO l_qcs.qcs21
            FROM pmh_file
            WHERE pmh01=l_qcs.qcs021
            AND pmh02=l_qcs.qcs03
            AND pmh21=l_ecm04
            AND pmh22=l_type
            AND pmh23=' '
            #MOD-BA0036 add --start--
            IF STATUS=100 OR cl_null(l_qcs.qcs21) OR cl_null(l_qcs.qcs17) THEN
            SELECT pmc906,pmc907 INTO l_qcs.qcs21,l_qcs.qcs17
            FROM pmc_file
            WHERE pmc01 = l_qcs.qcs03

            IF STATUS=100 OR cl_null(l_qcs.qcs21) OR cl_null(l_qcs.qcs17) THEN
                SELECT ima100,ima102 INTO l_qcs.qcs21,l_qcs.qcs17
                    FROM ima_file WHERE ima01=l_qcs.qcs021
                IF STATUS THEN
                    LET l_qcs.qcs21=' '
                    LET l_qcs.qcs17=' '
                END IF
            END IF
            END IF
            #MOD-BA0036 add --end--

            LET l_qcs.qcs13 = g_user
            LET l_qcs.qcs14 = 'N'
    #No.TQC-B90236----mark---begin-----
            #LET l_qcs.qcs22 = l_rvb.rvb07 - l_qcs22
            #IF l_qcs.qcs22 = 0 THEN
            #    LET l_s = 'N'
            #    CONTINUE FOREACH
            #END IF

            #LET l_qcs22 = l_qcs.qcs06 #MOD-B70290 add
            #LET l_qcs.qcs30 = l_rvb.rvb80
            #LET l_qcs.qcs31 = l_rvb.rvb81
            #LET l_qcs.qcs32 = l_rvb.rvb82
            #LET l_qcs.qcs33 = l_rvb.rvb83
            #LET l_qcs.qcs34 = l_rvb.rvb84
            #LET l_qcs.qcs35 = l_rvb.rvb85

            #SELECT ima906 INTO l_ima906
            #  FROM ima_file
            # WHERE ima01 = l_qcs.qcs021

            #IF g_sma.sma115 = 'Y' AND l_qcs22 <> 0 THEN
            #   IF l_ima906 = '3' THEN
            #      LET l_qcs.qcs32 = l_qcs.qcs22
            #      IF l_qcs.qcs34 <> 0 THEN
            #         LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34
            #      ELSE
            #         LET l_qcs.qcs35 = 0
            #      END IF
            #   ELSE
            #      LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34
            #      LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34
            #   END IF
            #END IF
            #LET l_qcs.qcs09 = '1'
            #LET l_qcs.qcs091 = l_qcs.qcs22
            #LET l_qcs.qcs36 = l_qcs.qcs30
            #LET l_qcs.qcs37 = l_qcs.qcs31
            #LET l_qcs.qcs38 = l_qcs.qcs32
            #LET l_qcs.qcs39 = l_qcs.qcs33
            #LET l_qcs.qcs40 = l_qcs.qcs34
            #LET l_qcs.qcs41 = l_qcs.qcs35
    #No.TQC-B90236----mark---end----------
            LET l_qcs.qcsspc ='0'
            LET l_qcs.qcsprno = 0
            LET l_qcs.qcsacti = 'Y'
            LET l_qcs.qcsuser = g_user
            LET l_qcs.qcsgrup = g_grup
            LET l_qcs.qcsdate = g_today
            LET l_qcs.qcsplant = g_plant
            LET l_qcs.qcslegal = g_legal
            LET l_qcs.qcsoriu = g_user
            LET l_qcs.qcsorig = g_grup
            LET l_qcs.qcs15 = ''                       #MOD-B70274 add
    #No.TQC-B90236----add---begin-------
            SELECT ima918 INTO l_ima918 FROM ima_file
            WHERE ima01 = l_qcs.qcs021

            SELECT MAX(qcs05)+1 INTO l_qcs.qcs05 FROM qcs_file
                WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02
            IF cl_null(l_qcs.qcs05) THEN LET l_qcs.qcs05=1 END IF

            SELECT SUM(qcs22) INTO l_qcs22s FROM qcs_file
                WHERE qcs00='2' AND qcs01= l_rva.rva01
                AND qcs02 = l_rvb.rvb02 AND qcs14 <>'X'
            IF cl_null(l_qcs22s) THEN LET l_qcs22s = 0 END IF
            LET l_qcs.qcs22 = l_rvb.rvb07 - l_qcs22s
            IF l_qcs.qcs22 = 0 THEN
                LET l_s = 'N'
                CONTINUE FOREACH
            END IF

            LET l_qcs22 = l_qcs.qcs22
            LET l_qcs.qcs30 = l_rvb.rvb80
            LET l_qcs.qcs31 = l_rvb.rvb81
            LET l_qcs.qcs32 = l_rvb.rvb82
            LET l_qcs.qcs33 = l_rvb.rvb83
            LET l_qcs.qcs34 = l_rvb.rvb84
            LET l_qcs.qcs35 = l_rvb.rvb85

            SELECT ima906,ima44 INTO l_ima906,l_ima44 FROM ima_file     #FUN-BB0085 add ima44
                WHERE ima01 = l_qcs.qcs021

            IF g_sma.sma115 = 'Y' AND l_qcs22s <> 0 THEN
                IF l_ima906 = '3' THEN
                    LET l_qcs.qcs32 = l_qcs.qcs22
                    IF l_qcs.qcs34 <> 0 THEN
                        LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34
                    ELSE
                        LET l_qcs.qcs35 = 0
                    END IF
                ELSE
                    IF l_ima906 = '2' AND NOT cl_null(l_qcs.qcs34) AND l_qcs.qcs34 <>0 THEN   #No.MOD-CC0009
                        LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34
                        LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34
                    END IF                                                                    #No.MOD-CC0009
                END IF
            END IF
            LET l_qcs.qcs09 = '1'
            LET l_qcs.qcs091 = l_qcs.qcs22
            LET l_qcs.qcs36 = l_qcs.qcs30
            LET l_qcs.qcs37 = l_qcs.qcs31
            LET l_qcs.qcs38 = l_qcs.qcs32
            LET l_qcs.qcs39 = l_qcs.qcs33
            LET l_qcs.qcs40 = l_qcs.qcs34
            LET l_qcs.qcs41 = l_qcs.qcs35
            #FUN-BB0085-add-str--
            LET l_qcs.qcs091= s_digqty(l_qcs.qcs091,l_ima44)
            LET l_qcs.qcs22 = s_digqty(l_qcs.qcs22,l_ima44)
            LET l_qcs.qcs32 = s_digqty(l_qcs.qcs32,l_qcs.qcs30)
            LET l_qcs.qcs35 = s_digqty(l_qcs.qcs35,l_qcs.qcs33)
            LET l_qcs.qcs38 = s_digqty(l_qcs.qcs38,l_qcs.qcs36)
            LET l_qcs.qcs41 = s_digqty(l_qcs.qcs41,l_qcs.qcs39)
            #FUN-BB0085-add-end--
    #             END IF      #TQC-C30012
            SELECT COUNT(*) INTO l_n
                FROM qcs_file WHERE qcs01 = g_argv1
                                AND qcs14 != 'X'              #MOD-C30382 add
            SELECT SUM(qcs22) INTO l_q FROM qcs_file
                WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02
                AND qcs14 != 'X'                             #MOD-C30382 add

            IF l_q >=l_rvb.rvb07 AND l_n >=1 THEN
                CALL cl_err('','aqc-335',1)
                LET l_t = 'N'
                EXIT FOREACH
            ELSE
                LET l_t = 'Y'
            END IF
            #darcy:2025/01/14 add s---
            let l_qcs.qcsud08 = 0
            let l_qcs.qcsud10 = 0
            #darcy:2025/01/14 add e---
            INSERT INTO p100_qcs_tmp VALUES (l_qcs.*)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("","","","",SQLCA.SQLCODE,"","",1)
                LET g_success = 'N'
                EXIT FOREACH
            END IF
            SELECT ima921 INTO l_ima921 FROM ima_file
                WHERE ima01 = l_qcs.qcs021
            IF l_ima918="Y" OR l_ima921="Y" THEN
                FOREACH p001_rvbs USING l_qcs.qcs01,l_qcs.qcs02 INTO l_rvbs.*  #抓取批序號資料
                    #抓取已產生的資料
                    SELECT SUM(rvbs06) INTO l_rvbs06s FROM rvbs_file,qcs_file
                    WHERE qcs01 =l_qcs.qcs01
                        AND qcs02 =l_qcs.qcs02
                        AND rvbs13=qcs05
                        AND qcs01 = rvbs01
                        AND qcs02 = rvbs02
                        AND rvbs03 = l_rvbs.rvbs03
                        AND rvbs04 = l_rvbs.rvbs04
                        AND rvbs08 = l_rvbs.rvbs08
                        AND rvbs00[1,7] = 'aqct110'
                        AND qcs14 !='X'
                        AND qcs00 = '2'
                        AND rvbs09 = 1
                    IF cl_null(l_rvbs06s) THEN
                        LET l_rvbs06s=0
                    END IF

                    LET l_rvbs.rvbs00 = 'aqct110'
                    LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs06s
                    LET l_rvbs.rvbs10 = 0
                    LET l_rvbs.rvbs11 = 0
                    LET l_rvbs.rvbs12 = 0
                    LET l_rvbs.rvbs13 = l_qcs.qcs05
                    LET l_rvbs.rvbsplant = g_plant
                    LET l_rvbs.rvbslegal = g_legal

                    INSERT INTO p100_rvbs_tmp VALUES (l_rvbs.*)
                END FOREACH
            END IF
    #No.TQC-B90236----add---end---------

    #產生QC單身資料

            LET l_s = 'Y'
            LET l_flag = ' '

            LET l_yn = 0   #MOD-BB0073 add

            SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn
            FROM qcc_file,ecm_file,rvb_file,pmn_file
            WHERE rvb01 = l_qcs.qcs01
            AND rvb02 = l_qcs.qcs02
            AND rvb04 = pmn01
            AND rvb03 = pmn02
            AND pmn41 = ecm01
            AND pmn46 = ecm03
            AND qcc01 = l_qcs.qcs021
            AND qcc011 = ecm04
            AND qcc08 IN ('1','9')
            AND ecm012 = pmn012
            GROUP BY ecm04
        #SELECT ima101 INTO l_ima101 #MOD-D20123 mark
            SELECT ima101 INTO g_ima101 #MOD-D20123 add
            FROM ima_file
            #WHERE ima01 = l_qcs021     #MOD-D20123 mark
            WHERE ima01 = l_qcs.qcs021 #MOD-D20123 add

            IF cl_null(l_yn) OR l_yn<=0 THEN
            SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn
                FROM qcc_file,ecm_file,rvb_file,pmn_file
                WHERE rvb01 = l_qcs.qcs01
                AND rvb02 = l_qcs.qcs02
                AND rvb04 = pmn01
                AND rvb03 = pmn02
                AND pmn41 = ecm01
                AND pmn46 = ecm03
                AND qcc01 = '*'
                AND qcc011 = ecm04
                AND qcc08 IN ('1','9')
                AND ecm012 = pmn012
                GROUP BY ecm04

                IF cl_null(l_yn) OR l_yn<=0 THEN
                SELECT sgm04,COUNT(*) INTO l_ecm04,l_yn
                    FROM qcc_file,sgm_file,rvb_file,pmn_file
                    WHERE rvb01=l_qcs.qcs01
                    AND rvb02=l_qcs.qcs02
                    AND rvb04=pmn01
                    AND rvb03=pmn02
                    AND pmn41=sgm02
                    AND pmn32=sgm03
                    AND sgm012 = pmn012
                    AND qcc01=l_qcs.qcs021
                    AND qcc011=sgm04
                    AND qcc08 IN ('1','9')
                    GROUP BY sgm04
            END IF
            END IF

            IF l_yn > 0 THEN
            LET l_flag = '1'          #--製程委外抓站別檢驗項目
            ELSE
            LET l_sql = " SELECT COUNT(*) FROM qcd_file ",
                        " WHERE qcd01 = ? ",
                        " AND qcd08 in ('1','9') "
            PREPARE qcd_sel FROM l_sql
            EXECUTE qcd_sel USING l_qcs.qcs021 INTO l_yn

            IF l_yn > 0 THEN          #--- 料件檢驗項目
                LET l_flag = '2'
            ELSE
                LET l_flag = '3'       #--- 材料類別檢驗項目
            END IF
            END IF

            CASE l_flag
            WHEN '1'
                LET l_sql = "SELECT qcc01,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062, ",
                            "       qccacti,qccuser,qccgrup,qccmodu,qccdate ",
                            "  FROM qcc_file ",
                            " WHERE qcc01 = ? ",
                            "   AND qcc011 = ? ",
                            "   AND qcc08 IN ('1','9') ",
                            " ORDER BY qcc02"
                PREPARE qcc_cur1 FROM l_sql
                DECLARE qcc_cur CURSOR FOR qcc_cur1
                DECLARE qcc_cur2 SCROLL CURSOR FOR qcc_cur1

                OPEN qcc_cur2 USING l_qcs.qcs021,l_ecm04
                FETCH FIRST qcc_cur2 INTO l_qcd.*
                IF SQLCA.sqlcode = 100 THEN
                    LET l_qcs021 = '*'
                ELSE
                    LET l_qcs021 = l_qcs.qcs021
                END IF

                LET seq = 1                 #MOD-AC0311
                FOREACH qcc_cur USING l_qcs021,l_ecm04 INTO l_qcd.*
                    CASE l_qcd.qcd05
                    WHEN "1"   #一般
                        CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)
                            RETURNING l_ac_num,l_re_num
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN '2'     #特殊
                        LET l_ac_num = 0
                        LET l_re_num = 1
                        SELECT qcj05 INTO l_qct11
                        FROM qcj_file
                        WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                        AND qcj03 = l_qcd.qcd04
                        AND qcj04 = l_qcs.qcs17
                        IF STATUS THEN
                        LET l_qct11 = 0
                        END IF
                        IF l_qcs22 = 1 THEN
                        LET l_qct11 = 1
                        END IF
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN "3"    #1916 計數
                        LET l_ac_num = 0
                        LET l_re_num = 1
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN "4"    #1916 計量
                        LET l_ac_num = ''
                        LET l_re_num = ''
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11
                        SELECT qdf02 INTO l_qdf02
                        FROM qdf_file
                        WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04)
                        AND qdf01 = l_qcd.qcd03
                        SELECT qdg05,qdg06 INTO l_qct14,l_qct15
                        FROM qdg_file
                        #WHERE qdg01 =單頭.ima101  #MOD-BA0036 mark
                        #WHERE qdg01 =l_ima101     #MOD-BA0036 #MOD-D20123 mark
                        WHERE qdg01 =g_ima101     #MOD-D20123 add
                        AND qdg02 = l_qcd.qcd03
                        AND qdg03 = l_qdf02
                        IF STATUS THEN
                        LET l_qct14 =0
                        LET l_qct15 =0
                        END IF
                    END CASE

                    IF l_qct11 > l_qcs.qcs22 THEN
                        LET l_qct11 = l_qcs.qcs22
                    END IF

                    IF cl_null(l_qct11) THEN
                        LET l_qct11 = 0
                    END IF

                    INSERT INTO p100_qct_tmp (qct01,qct02,qct021,qct03,qct04,qct05,
                                        qct06,qct07,qct08,qct09,qct10,qct11,
                                        qct12,qct131,qct132,qct14,qct15,
                                        qctplant,qctlegal)
                        VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,
                            l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                            0,'1',l_ac_num,l_re_num,l_qct11,
                            l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,
                            l_qct14,l_qct15,
                            g_plant,g_legal)
                    LET seq = seq + 1
                END FOREACH
            WHEN '2'
                LET l_sql = "  SELECT qcd01,qcd02,qcd03,qcd04,qcd05,qcd061,qcd062,qcd07,qcdacti,",
                            "         qcduser,qcdgrup,qcdmodu,qcddate,qcd08,qcdorig,qcdoriu,qcd09,qcdud01 ",
                            "    FROM qcd_file",
                            "  WHERE qcd01 = ? ",
                            "    AND qcd08 IN ('1','9') ",
                            "   ORDER BY qcd02"
                PREPARE qcd_cur1 FROM l_sql
                DECLARE qcd_cur CURSOR FOR qcd_cur1

                LET seq = 1            #MOD-AC0311
                FOREACH qcd_cur USING l_qcs.qcs021 INTO l_qcd.*
                    CASE l_qcd.qcd05
                    WHEN "1"   #一般
                        CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)
                            RETURNING l_ac_num,l_re_num
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN '2'     #特殊
                        LET l_ac_num = 0
                        LET l_re_num = 1
                        SELECT qcj05 INTO l_qct11
                        FROM qcj_file
                        WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                        AND qcj03 = l_qcd.qcd04
                        AND qcj04 = l_qcs.qcs17
                        IF STATUS THEN
                        LET l_qct11 = 0
                        END IF
                        IF l_qcs22 = 1 THEN
                        LET l_qct11 = 1
                        END IF
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN "3"    #1916 計數
                        LET l_ac_num = 0
                        LET l_re_num = 1
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN "4"    #1916 計量
                        LET l_ac_num = ''
                        LET l_re_num = ''
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11
                        SELECT qdf02 INTO l_qdf02
                        FROM qdf_file
                        WHERE qdf03 <= l_qcs.qcs22
                        AND qdf04 >= l_qcs.qcs22
                        AND qdf01 = l_qcd.qcd03
                        SELECT qdg05,qdg06 INTO l_qct14,l_qct15
                        FROM qdg_file
                        #WHERE qdg01 = l_ima101 #MOD-D20123 mark
                        WHERE qdg01 = g_ima101 #MOD-D20123 add
                        AND qdg02 = l_qcd.qcd03
                        AND qdg03 = l_qdf02
                        IF STATUS THEN
                        LET l_qct14 =0
                        LET l_qct15 =0
                        END IF
                    END CASE

                    IF l_qct11 > l_qcs.qcs22 THEN
                        LET l_qct11 = l_qcs.qcs22
                    END IF

                    IF cl_null(l_qct11) THEN
                        LET l_qct11 = 0
                    END IF

                    INSERT INTO p100_qct_tmp (qct01,qct02,qct021,qct03,qct04,qct05,
                                        qct06,qct07,qct08,qct09,qct10,qct11,
                                        qct12,qct131,qct132,qct14,qct15,
                                        qctplant,qctlegal,qctud02)
                                #VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,seq,	#MOD-AC0311
                                    VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,    #MOD-AC0311
                                        l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                                        0,'1',l_ac_num,l_re_num,l_qct11,
                                        l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,
                                        l_qct14,l_qct15,
                                        g_plant,g_legal,l_qcd.qcdud01)
                    LET seq = seq + 1
                END FOREACH
            WHEN '3'      #--- 材料類別檢驗項目
                LET l_sql = " SELECT qck_file.* FROM qck_file,ima_file ",
                            "  WHERE qck01 = ima109 AND ima01 = ?",
                            "    AND qck08 IN ('1','9') ",
                            "  ORDER BY qck02"
                PREPARE qck_cur1 FROM l_sql
                DECLARE qck_cur CURSOR FOR qck_cur1

                LET seq = 1         #MOD-AC0311
                FOREACH qck_cur USING l_qcs.qcs021 INTO l_qcd.*
                    CASE l_qcd.qcd05
                    WHEN "1"   #一般
                        CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)
                            RETURNING l_ac_num,l_re_num
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN '2'     #特殊
                        LET l_ac_num=0 LET l_re_num=1
                        SELECT qcj05 INTO l_qct11
                        FROM qcj_file
                        WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                        AND qcj03=l_qcd.qcd04
                        AND qcj04 = l_qcs.qcs17
                        IF STATUS THEN LET l_qct11=0 END IF
                        IF l_qcs22 = 1 THEN
                        LET l_qct11 = 1
                        END IF
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN "3"    #1916 計數
                        LET l_ac_num = 0
                        LET l_re_num = 1
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11
                        LET l_qct14 = ''
                        LET l_qct15 = ''
                    WHEN "4"    #1916 計量
                        LET l_ac_num = ''
                        LET l_re_num = ''
                        CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11
                        SELECT qdf02 INTO l_qdf02
                        FROM qdf_file
                        WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04)
                        AND qdf01 = l_qcd.qcd03
                        SELECT qdg05,qdg06 INTO l_qct14,l_qct15
                        FROM qdg_file
                        #WHERE qdg01 = l_ima101 #MOD-D20123 mark
                        WHERE qdg01 = g_ima101 #MOD-D20123 add
                        AND qdg02 = l_qcd.qcd03
                        AND qdg03 = l_qdf02
                        IF STATUS THEN
                        LET l_qct14 =0
                        LET l_qct15 =0
                        END IF
                    END CASE
                    IF l_qct11 > l_qcs.qcs22 THEN
                        LET l_qct11=l_qcs.qcs22
                    END IF
                    IF cl_null(l_qct11) THEN
                        LET l_qct11=0
                    END IF
                    INSERT INTO p100_qct_tmp (qct01,qct02,qct021,qct03,qct04,qct05,
                                        qct06,qct07,qct08,qct09,qct10,qct11,
                                        qct12,qct131,qct132,qct14,qct15,
                                        qctplant,qctlegal)
                                    VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,
                                        l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                                        0,'1',l_ac_num,l_re_num,l_qct11,
                                        l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,
                                        l_qct14,l_qct15,
                                        g_plant,g_legal)
                    LET seq=seq+1
                END FOREACH
            END CASE
        END FOREACH

      IF l_m = 'Y' THEN
         IF g_success = 'Y'AND l_s = 'Y' THEN
            LET l_k = 1
         ELSE
            IF l_s = 'N' THEN
               CALL cl_err('','aqc-046',1)
            ELSE
               CALL cl_err('','mfg1608',1)
            END IF
            LET l_k = 2
         END IF
      ELSE
         CALL cl_err('','aqc-337',1)
         LET l_k = 2
      END IF
end function
FUNCTION p001_defqty(l_def,l_rate,l_qcd03,l_qcd05)
#DEFINE      l_ima915  LIKE ima_file.ima915   #MOD-C70226 mark
DEFINE      l_pmh09   LIKE pmh_file.pmh09
DEFINE      l_pmh15   LIKE pmh_file.pmh15
DEFINE      l_pmh16   LIKE pmh_file.pmh16
DEFINE      l_qcb04   LIKE qcb_file.qcb04
DEFINE      l_qca03   LIKE qca_file.qca03
DEFINE      l_qca04   LIKE qca_file.qca04
DEFINE      l_qca05   LIKE qca_file.qca05
DEFINE      l_qca06   LIKE qca_file.qca06
DEFINE      l_qdg04   LIKE qdg_file.qdg04
DEFINE      l_def     LIKE type_file.num5
#DEFINE      l_rate    LIKE type_file.num5
DEFINE      l_rate    LIKE qcd_file.qcd04   #MOD-B70290
DEFINE      l_qcd03   LIKE qcd_file.qcd03
DEFINE      l_qcd05   LIKE qcd_file.qcd05
define l_qty          like qcs_file.qcs22
define l_sql string

   LET l_qty = l_qcs22
   LET l_qcs22 = l_qty
  #MOD-C70226 str mark-----
  #LET l_ima915 = ''
  #SELECT ima915 INTO l_ima915 FROM ima_file
  # WHERE ima01=l_qcs.qcs021
  #IF cl_null(l_ima915) THEN
  #   LET l_ima915 = '0'
  #END IF
  #MOD-C70226 end mark-----

   LET l_sql="SELECT pmh09,pmh15,pmh16 FROM pmh_file",
             " WHERE pmh01 ='", l_qcs.qcs021,"'",
             "   AND pmh02 ='", l_qcs.qcs03,"'",
             "   AND pmh21 ='", l_ecm04,"'",
             "   AND pmh22 ='", l_type,"'",
             "   AND pmh23 = ' ' "
   PREPARE pmh_cur2_pre FROM l_sql
   DECLARE pmh_cur2 CURSOR FOR pmh_cur2_pre

   OPEN pmh_cur2
   FETCH pmh_cur2 INTO l_pmh09,l_pmh15,l_pmh16
  #IF STATUS OR l_ima915 = '0' THEN           #MOD-C70226 mark
   IF STATUS THEN                             #MOD-C70226 add
      SELECT pmc906,pmc905,pmc907
        INTO l_pmh09,l_pmh15,l_pmh16
        FROM pmc_file
       WHERE pmc01 = l_qcs.qcs03
      IF STATUS OR cl_null(l_pmh09) OR cl_null(l_pmh15)
         OR cl_null(l_pmh16) THEN
         SELECT ima100,ima101,ima102
           INTO l_pmh09,l_pmh15,l_pmh16
           FROM ima_file
          WHERE ima01 = l_qcs.qcs021
         IF STATUS THEN
            LET l_pmh09=''
            LET l_pmh15=''
            LET l_pmh16=''
            RETURN 0
         END IF
      END IF
   END IF

   LET l_qcs.qcs17 = l_pmh16
   IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0 END IF
   IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0 END IF
   IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0 END IF

   IF l_pmh15='1' THEN
      SELECT qcb04
        INTO l_qcb04
        FROM qca_file,qcb_file
       WHERE (l_qcs22 BETWEEN qca01 AND qca02)
         AND qcb02 = l_rate
         AND qca03 = qcb03
         AND qca07 = l_qcs.qcs17
         AND qcb01 = l_qcs.qcs21

      IF NOT cl_null(l_qcb04) THEN
         SELECT UNIQUE qca03,qca04,qca05,qca06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qca_file
          WHERE qca03=l_qcb04
         IF STATUS THEN
            LET l_qca03 = 0
            LET l_qca04 = 0
            LET l_qca05 = 0
            LET l_qca06 = 0
         END IF
      END IF
   END IF

   IF l_pmh15 = '2' THEN
      SELECT qcb04 INTO l_qcb04
        FROM qch_file,qcb_file
       WHERE (l_qcs22 BETWEEN qch01 AND qch02)
         AND qcb02 = l_rate
         AND qch03 = qcb03
         AND qch07 = l_qcs.qcs17
         AND qcb01 = l_qcs.qcs21

      IF NOT cl_null(l_qcb04) THEN
         SELECT UNIQUE qch03,qch04,qch05,qch06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qch_file
          WHERE qch03=l_qcb04
         IF STATUS THEN
            LET l_qca03 = 0
            LET l_qca04 = 0
            LET l_qca05 = 0
            LET l_qca06 = 0
         END IF
      END IF
   END IF

   IF l_qcs22 = 1 THEN
      LET l_qca04 = 1
      LET l_qca05 = 1
      LET l_qca06 = 1
   END IF

     CASE l_qcd.qcd05

        WHEN '1'
           CASE l_pmh09
              WHEN 'N'
                 RETURN l_qca04
              WHEN 'T'
                 RETURN l_qca05
              WHEN 'R'
                 RETURN l_qca06
              OTHERWISE
                 RETURN 0
           END CASE
        WHEN '2'
           CASE l_pmh09
              WHEN 'N'
                 RETURN l_qca04
              WHEN 'T'
                 RETURN l_qca05
              WHEN 'R'
                 RETURN l_qca06
              OTHERWISE
                 RETURN 0
           END CASE
        WHEN '3'
           CASE l_pmh09
              WHEN 'N'
                 LET l_qcd03 = l_qcd.qcd03
              WHEN 'T'
                 LET l_qcd03 = l_qcd.qcd03+1
                 IF l_qcd03 = 8 THEN
                    LET l_qcd03 = 'T'
                 END IF
              WHEN 'R'
                 LET l_qcd03 = l_qcd.qcd03-1
                 IF l_qcd03 = 0 THEN
                    LET l_qcd03 = 'R'
                 END IF
              OTHERWISE
                 RETURN 0
           END CASE
           SELECT qdf02 INTO l_qdf02
             FROM qdf_file
           #WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 mark
            WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 add
              AND qdf01 = l_qcd03
           SELECT qdg04 INTO l_qdg04
             FROM qdg_file
           #WHERE qdg01 = l_ima101 #MOD-D20123 mark
            WHERE qdg01 = g_ima101 #MOD-D20123 add
              AND qdg02 = l_qcd03
              AND qdg03 = l_qdf02
           IF STATUS THEN
              LET l_qdg04 = 0
           END IF
           RETURN l_qdg04
        WHEN '4'
           CASE l_pmh09
              WHEN 'N'
                 LET l_qcd03 = l_qcd.qcd03
              WHEN 'T'
                 LET l_qcd03 = l_qcd.qcd03+1
                 IF l_qcd03 = 8 THEN
                    LET l_qcd03 = 'T'
                 END IF
              WHEN 'R'
                 LET l_qcd03 = l_qcd.qcd03-1
                 IF l_qcd03 = 0 THEN
                    LET l_qcd03 = 'R'
                 END IF
              OTHERWISE
                 RETURN 0
           END CASE
#MOD-AC0311 --------------End------------------
           SELECT qdf02 INTO l_qdf02
             FROM qdf_file
           #WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04)	#MOD-D20123 mark
            WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 add
              AND qdf01 = l_qcd03
           SELECT qdg04 INTO l_qdg04
             FROM qdg_file
           #WHERE qdg01 = l_ima101 #MOD-D20123 mark
            WHERE qdg01 = g_ima101 #MOD-D20123 add
              AND qdg02 = l_qcd03
              AND qdg03 = l_qdf02
           IF STATUS THEN
              LET l_qdg04 = 0
           END IF
           RETURN l_qdg04
     END CASE
 END FUNCTION

function p100_b_fill()
    define l_sql string
    let l_sql = "SELECT 'Y',qcs00,qcs01,qcs02,qcs05,qcs021,ima02,ima021,",
                " qcs03,pmc03,qcs14,qcs21,qcs04,qcs041,qcsud07,qcs22,",
                " qcs091,qcs09,CASE qcs09 WHEN '1' THEN '合格' WHEN '2' THEN '验退' WHEN '3' THEN '特采' END,",
                " qcs13,gen02,qcsud01,qcsud03,qcsud04,qcsud05,qcsud06,qcsud14 FROM p100_qcs_tmp, ima_file, pmc_file, gen_file",
                " WHERE qcs021 = ima01 AND pmc01 = qcs03 AND gen01 = qcs13"
    prepare p100_fill_p from l_sql
    declare p100_fill_c cursor for p100_fill_p

    call g_new.clear()
    let g_cnt = 1
    foreach p100_fill_c into g_new[g_cnt].*
        if status then
            call cl_err('p100_fill_c',status,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_new.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
end function

function p100_done()
    define l_index integer
    define l_str   string

    let g_success ='Y'

    begin work
    for l_index = 1 to g_new.getlength()
        if g_new[l_index].checkqcs = 'Y' then
            insert into qcs_file
             select * from p100_qcs_tmp where qcs01 = g_new[l_index].qcs01 and qcs02 = g_new[l_index].qcs02
            if status then
                call cl_err('ins qcs_file',status,1)
                let g_success ='N'
                exit for
            end if

            insert into qct_file
                select * from p100_qct_tmp where qct01 = g_new[l_index].qcs01 and qct02 = g_new[l_index].qcs02
            if status then
                call cl_err('ins qct_file',status,1)
                let g_success ='N'
                exit for
            end if
            let l_str = l_str,"收货单:",g_new[l_index].qcs01," 项次:",g_new[l_index].qcs02,";"
        end if
    end for
    if g_success = 'Y' then
        CALL cl_err(l_str,'aqc-336',1)
        commit work
    else
        rollback work
    end if
end function

function p100_updqcsud03()
    define l_index integer
    define l_qcsud01 like qcs_file.qcsud01
    define l_qcsud03 like qcs_file.qcsud03
    define l_qcsud04 like qcs_file.qcsud04
    define l_qcsud05 like qcs_file.qcsud05
    define l_qcsud06 like qcs_file.qcsud06
    define l_qcsud14 like qcs_file.qcsud14

    define   p_row,p_col   like type_file.num5
    define l_flag  like type_file.chr1

    let g_success = 'Y'
    let l_flag = 'Y'

    open window cqcp100_w_1 at p_row,p_col with form "cqc/42f/cqcp100_1"
            attribute (style = g_win_style clipped)
    call cl_ui_init()

    input l_qcsud01,l_qcsud03,l_qcsud04,l_qcsud05,l_qcsud06,l_qcsud14 from qcsud01_1,qcsud03_1,qcsud04_1,qcsud05_1,qcsud06_1,qcsud14_1
        after input
            exit input
        on action cancel
            let l_flag = 'N'
            exit input
    end input

    if l_flag = 'Y' then
        # 更新料件批号
        begin work
        for l_index = 1 to g_new.getlength()
            if g_new[l_index].checkqcs = 'Y' then
                update p100_qcs_tmp
                set qcsud01 = l_qcsud01,
                		qcsud03 = l_qcsud03,
                		qcsud04 = l_qcsud04,
                		qcsud05 = l_qcsud05,
                		qcsud06 = l_qcsud06,
                		qcsud14 = l_qcsud14
                where qcs01 = g_new[l_index].qcs01 and qcs02 = g_new[l_index].qcs02
                if status then
                    call cl_err("upd p100_qcs_tmp",status,1)
                    let g_success = 'N'
                    rollback work
                    exit for
                end if
            end if
        end for
        if g_success = 'Y' then
            commit work
            for l_index = 1 to g_new.getlength()
                if g_new[l_index].checkqcs = 'Y' then
                		let g_new[l_index].qcsud01 = l_qcsud01
                    let g_new[l_index].qcsud03 = l_qcsud03
                    let g_new[l_index].qcsud04 = l_qcsud04
                    let g_new[l_index].qcsud05 = l_qcsud05
                    let g_new[l_index].qcsud06 = l_qcsud06
                    let g_new[l_index].qcsud14 = l_qcsud14
                end if
            end for
        else
            rollback work
        end if
    end if
    close window cqcp100_w_1

end function

function p100_restart()
# 将勾选的单据从临时表中删除,并重新查询
    define l_index integer

    let g_success = 'Y'
    begin work
    for l_index = 1 to g_new.getlength()
        if g_new[l_index].checkqcs = 'Y' then
        delete from p100_qry_tmp where qcs01 = g_new[l_index].qcs01 and qcs02 = g_new[l_index].qcs02
        if status then
            call cl_err("del p100_qry_tmp",status,1)
            let g_success = 'N'
            exit for
        end if
        delete from p100_qcs_tmp where qcs01 = g_new[l_index].qcs01 and qcs02 = g_new[l_index].qcs02
        if status then
            call cl_err("del p100_qry_tmp",status,1)
            let g_success = 'N'
            exit for
        end if
        delete from p100_qct_tmp where qct01 = g_new[l_index].qcs01 and qct02 = g_new[l_index].qcs02
        if status then
            call cl_err("del p100_qry_tmp",status,1)
            let g_success = 'N'
            exit for
        end if
        end if
    end for
    if g_success = 'Y' then
        commit work
    else
        rollback work
    end if

    call p100_b_fill()

end function
