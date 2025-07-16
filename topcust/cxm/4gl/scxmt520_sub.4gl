# Prog. Version..:
#
# Pattern name...: scxmt520_sub.4gl
# Descriptions...: cxmt520 核价单功能函数
# Date & Author..: darcy:2025/06/09 add

database ds

GLOBALS "../../../tiptop/config/top.global"

type tc_xmg record
    tc_xmg02    like tc_xmg_file.tc_xmg02,
    tc_xmg03    like tc_xmg_file.tc_xmg03,
    tc_xmg04    like tc_xmg_file.tc_xmg04,
    ima02_1     like ima_file.ima02,
    ima021_1    like ima_file.ima021,
    tc_xmg05    like tc_xmg_file.tc_xmg05,
    tc_xmg06    like tc_xmg_file.tc_xmg06,
    tc_xmg07    like tc_xmg_file.tc_xmg07,
    tc_xmg08    like tc_xmg_file.tc_xmg08
end record

define g_tc_xmg dynamic array of tc_xmg
define g_tc_xmg_o,g_tc_xmg_t tc_xmg
define g_rec_b ,g_max_rec integer

function scxmt520_input(p_tc_xmf00,p_tc_xmf01)
    define p_tc_xmf00   like tc_xmf_file.tc_xmf00
    define p_tc_xmf01   like tc_xmf_file.tc_xmf01

    let g_max_rec = 10000
    call scxmt520_b_fill(p_tc_xmf00,p_tc_xmf01)

    call scxmt520_b(p_tc_xmf00,p_tc_xmf01) 

    return scxmt520_b_remark(p_tc_xmf00,p_tc_xmf01)
end function

function scxmt520_b_fill(p_tc_xmf00,p_tc_xmf01)
    define p_tc_xmf00   like tc_xmf_file.tc_xmf00
    define p_tc_xmf01   like tc_xmf_file.tc_xmf01

    define l_sql  string
    define i integer

    let l_sql = "select tc_xmg02,tc_xmg03,tc_xmg04,ima02,ima021,tc_xmg05,tc_xmg06,tc_xmg07,tc_xmg08",
                "  from tc_xmg_file left join ima_file on ima01 = tc_xmg04 ",
                " where tc_xmg01 = '",p_tc_xmf00,
                "' and tc_xmg02 = ",p_tc_xmf01, 
                " order by tc_xmg02, tc_xmg03"
    prepare scxmt520_b_p from l_sql
    declare scxmt520_b_cur cursor for scxmt520_b_p

    let i = 1
    call g_tc_xmg.clear()
    foreach scxmt520_b_cur into g_tc_xmg[i].*
        if sqlca.sqlcode then
            call cl_err('scxmt520_b_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i+1 
    end foreach
    call g_tc_xmg.deleteElement(i)
    let g_rec_b = i - 1

end function

function scxmt520_b(p_tc_xmf00,p_tc_xmf01)
    define p_tc_xmf00   like tc_xmf_file.tc_xmf00
    define p_tc_xmf01   like tc_xmf_file.tc_xmf01
    
    define l_allow_insert,l_allow_delete boolean
    define l_ac,l_ac_t,l_cnt  integer
    define l_sql    string
    define l_lock_sw    varchar(1) 
    define p_cmd varchar(1)

    define l_pmj07  like pmj_file.pmj07,
           l_pmj09  like pmj_file.pmj09
    define l_tc_xmf03   like tc_xmf_file.tc_xmf03

    WHENEVER ERROR CONTINUE

    let l_sql = "select pmj07, pmj09 from (select pmj03, pmj07, pmj09
                        from (select pmj03, pmj07, pmj09,
                                    row_number() over (partition by pmj07 order by pmj09) as rn
                                from pmi_file, pmj_file
                                where pmi01 = pmj01
                                and pmiconf = 'Y'
                                and pmj03 = ? ) t
                        where rn = 1  
                        order by pmj09 desc)
                 where rownum <= 2"
    prepare scxmt520_pmi_p from l_sql
    declare scxmt520_pmi_cur cursor for scxmt520_pmi_p

    let l_sql =
     "select tc_xmg02,tc_xmg03,tc_xmg04,'' ima02,'' ima021,tc_xmg05,tc_xmg06,tc_xmg07,tc_xmg08 ", 
     "  from tc_xmg_file",
     " where tc_xmg01 = ? ",
     "   and tc_xmg02 = ? ", 
     "   and tc_xmg03 = ? ", 
     " for update "
    let l_sql = cl_forupd_sql(l_sql)
    declare scxmt520_bcl cursor from l_sql 

    OPEN WINDOW scxmt520_w AT 1,1
     WITH FORM "cxm/42f/scxmt520_1" ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()

    let l_ac_t = 0
    let l_allow_insert = cl_detail_input_auth("insert")
    let l_allow_delete = cl_detail_input_auth("delete")

    input array g_tc_xmg without defaults from s_tc_xmg.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
            insert row=l_allow_insert,delete row=l_allow_delete,
            append row=l_allow_insert)
        
        before input
            if g_rec_b != 0 then
                call fgl_set_arr_curr(l_ac)
            end if
        
        before row
            let l_ac = arr_curr()
            let l_lock_sw = 'N'            
            let g_success = 'Y'
        
            if g_rec_b >= l_ac then
                let p_cmd='u'
                let g_tc_xmg_t.* = g_tc_xmg[l_ac].*  #backup
                let g_tc_xmg_o.* = g_tc_xmg[l_ac].*  #backup
                begin work
                -- 锁定单身
                open scxmt520_bcl using p_tc_xmf00,g_tc_xmg_t.tc_xmg02,g_tc_xmg_t.tc_xmg03
                if status then
                    call cl_err('open scxmt520_bcl:', status, 1)
                    let l_lock_sw = 'Y'
                else
                    -- 重新显示单身资料
                    fetch scxmt520_bcl into g_tc_xmg[l_ac].*
                    if sqlca.sqlcode then
                        call cl_err(g_tc_xmg_t.tc_xmg03,sqlca.sqlcode,1)
                        return
                        let l_lock_sw = 'Y'
                    end if
                    select ima02 ,ima021 into g_tc_xmg[l_ac].ima02_1,g_tc_xmg[l_ac].ima021_1
                       from ima_file where ima01 = g_tc_xmg[l_ac].tc_xmg04
                end if
                call cl_show_fld_cont()     #fun-550037(smin)
            end if
        
        after insert
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                cancel insert
            end if
            -- 插入资料
            if cl_null(p_tc_xmf00) then let p_tc_xmf00=' ' end if
            -- 料号备注至少录入一个
            if cl_null(g_tc_xmg[l_ac].tc_xmg04) and cl_null(g_tc_xmg[l_ac].tc_xmg08) then
                call cl_err('料号和备注至少录入一个','!',1)
                cancel insert
                let g_success = 'N'
            end if
            insert into tc_xmg_file (tc_xmg01,tc_xmg02,tc_xmg03,tc_xmg04,tc_xmg05,tc_xmg06,
                                    tc_xmg07,tc_xmg08)  
                        values(p_tc_xmf00, g_tc_xmg[l_ac].tc_xmg02,
                               g_tc_xmg[l_ac].tc_xmg03,g_tc_xmg[l_ac].tc_xmg04,
                               g_tc_xmg[l_ac].tc_xmg05,g_tc_xmg[l_ac].tc_xmg06,
                               g_tc_xmg[l_ac].tc_xmg07,g_tc_xmg[l_ac].tc_xmg08)
            if sqlca.sqlcode then 
                call cl_err3('ins','tc_xmg_file',p_tc_xmf00,'',sqlca.sqlcode,'','',1) 
                cancel insert
                let g_success = 'N'
            else
                message 'insert o.k'
                -- if g_success = 'Y' then
                --     commit work
                -- end if
                let g_rec_b=g_rec_b+1
                -- display g_rec_b to formonly.cn2
            end if
        
        before insert 
            let p_cmd='a'
            initialize g_tc_xmg[l_ac].* to null
            let g_tc_xmg_t.* = g_tc_xmg[l_ac].*
            let g_tc_xmg_o.* = g_tc_xmg[l_ac].* 
            let g_tc_xmg[l_ac].tc_xmg02 = p_tc_xmf01
            call cl_show_fld_cont()
            next field tc_xmg03

        -- 自动增加项次
        before field tc_xmg03
            IF p_cmd = 'a' THEN
                select max(tc_xmg03) +1 into g_tc_xmg[l_ac].tc_xmg03 from tc_xmg_file
                 where tc_xmg01 = p_tc_xmf00 and tc_xmg02 = p_tc_xmf01
            
                if cl_null(g_tc_xmg[l_ac].tc_xmg03) then
                    let g_tc_xmg[l_ac].tc_xmg03 = 1
                end if
            end if
            
        -- 检查项次重复
        after field tc_xmg03
            if not cl_null(g_tc_xmg[l_ac].tc_xmg03) then
                IF p_cmd = 'a' OR (p_cmd = 'u' AND g_tc_xmg_t.tc_xmg03 != g_tc_xmg[l_ac].tc_xmg03) THEN
                    if g_tc_xmg[l_ac].tc_xmg03 <=0 then
                        call cl_err('','aec-994',0)
                        let g_tc_xmg[l_ac].tc_xmg03 = g_tc_xmg_t.tc_xmg03
                        next field tc_xmg03
                    end if
                    if g_tc_xmg[l_ac].tc_xmg03 != g_tc_xmg_t.tc_xmg03 or g_tc_xmg_t.tc_xmg03 is null then
                        select count(*) into l_cnt from tc_xmg_file
                        where tc_xmg01 = p_tc_xmf00
                            and tc_xmg02 = p_tc_xmf01
                            and tc_xmg03 = g_tc_xmg[l_ac].tc_xmg03
                        if l_cnt > 0 then     -- l_cnt>0  则有重复
                            call cl_err('',-239,0)
                            let g_tc_xmg[l_ac].tc_xmg03 = g_tc_xmg_t.tc_xmg03
                            next field tc_xmg03
                        end if
                    end if
                end if
            end if

        after field tc_xmg04 
            -- 带出料号的核价信息
            if not cl_null(g_tc_xmg[l_ac].tc_xmg04) then
                let l_cnt = 1
                let g_tc_xmg[l_ac].tc_xmg05 = null
                let g_tc_xmg[l_ac].tc_xmg06 = null
                let g_tc_xmg[l_ac].tc_xmg07 = null
                foreach scxmt520_pmi_cur using g_tc_xmg[l_ac].tc_xmg04
                        into l_pmj07,l_pmj09
                    if sqlca.sqlcode then
                        call cl_err('scxmt520_pmi_cur',sqlca.sqlcode,1)
                        exit foreach
                    end if
                    if l_cnt = 1 then
                        let g_tc_xmg[l_ac].tc_xmg07 = l_pmj09
                        let g_tc_xmg[l_ac].tc_xmg06 = l_pmj07
                    end if
                    if l_cnt = 2 then
                        if l_pmj07 > g_tc_xmg[l_ac].tc_xmg06 then
                            let g_tc_xmg[l_ac].tc_xmg05 = '降价'
                            let g_tc_xmg[l_ac].tc_xmg06 = l_pmj07 - g_tc_xmg[l_ac].tc_xmg06
                        else
                            let g_tc_xmg[l_ac].tc_xmg05 = '涨价'
                            let g_tc_xmg[l_ac].tc_xmg06 =  g_tc_xmg[l_ac].tc_xmg06 - l_pmj07
                        end if
                    end if
                    let l_cnt = l_cnt + 1
                end foreach
                if l_cnt = 1 then 
                    if  cl_null(g_tc_xmg[l_ac].tc_xmg06) then
                        -- 没有核价信息
                        call cl_err(sfmt('%1料号没有核价信息',g_tc_xmg[l_ac].tc_xmg04),'!',1)
                        next field tc_xmg04 
                    end if
                end if
                if l_cnt = 2 then
                    let g_tc_xmg[l_ac].tc_xmg05 = '仅核价一次'
                end if
                select ima02 ,ima021 into g_tc_xmg[l_ac].ima02_1,g_tc_xmg[l_ac].ima021_1
                  from ima_file where ima01 = g_tc_xmg[l_ac].tc_xmg04
            end if

        on row change
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                let g_tc_xmg[l_ac].* = g_tc_xmg_t.*
                close scxmt520_bcl
                rollback work
                exit input
            end if
        
            if l_lock_sw = 'Y' then
                call cl_err(g_tc_xmg[l_ac].tc_xmg03,-263,1)
                let g_tc_xmg[l_ac].* = g_tc_xmg_t.*
            else
                -- 更新资料
                update tc_xmg_file set  tc_xmg04=g_tc_xmg[l_ac].tc_xmg04,
                                        tc_xmg05=g_tc_xmg[l_ac].tc_xmg05,
                                        tc_xmg06=g_tc_xmg[l_ac].tc_xmg06,
                                        tc_xmg07=g_tc_xmg[l_ac].tc_xmg07,
                                        tc_xmg08=g_tc_xmg[l_ac].tc_xmg08
                 where tc_xmg01 = p_tc_xmf00
                   and tc_xmg02 = g_tc_xmg_t.tc_xmg02
                   and tc_xmg03 = g_tc_xmg_t.tc_xmg03
        
                if sqlca.sqlcode then 
                    call cl_err3('upd','tc_xmg_file',p_tc_xmf00,'',sqlca.sqlcode,'','',1) 
                    let g_tc_xmg[l_ac].* = g_tc_xmg_t.*
                    let g_success = 'N'
                else
                    message 'update o.k'
                    if g_success = 'Y' then commit work end if
                end if
            end if
        
        after row
            let l_ac = arr_curr() 
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                if p_cmd = 'u' then
                    let g_tc_xmg[l_ac].* = g_tc_xmg_t.* 
                else
                    call g_tc_xmg.deleteelement(l_ac)
                    if g_rec_b != 0 then 
                        let l_ac = l_ac_t
                    end if 
                end if 
                exit input
            end if
            let l_ac_t = l_ac
            commit work
        
        on action controlp
            -- 开窗
            case 
                when infield(tc_xmg04)
                    -- 需要查询成品料号 
                    select tc_xmf03 into l_tc_xmf03 from tc_xmf_file 
                     where tc_xmf00 = p_tc_xmf00 and tc_xmf01 = p_tc_xmf01
                    call cl_init_qry_var()
                    let g_qryparam.form = "cq_bmb03"
                    let g_qryparam.arg1 = l_tc_xmf03
                    call cl_create_qry() returning g_tc_xmg[l_ac].tc_xmg04
                    display by name g_tc_xmg[l_ac].tc_xmg04
                    next field tc_xmg04
                otherwise
                    exit case
            end case
        BEFORE DELETE                            #是否取消單身
            if  not cl_null(g_tc_xmg_t.tc_xmg02) and not cl_null(g_tc_xmg_t.tc_xmg03) then
                if not cl_delete() then
                    cancel delete
                end if
                if l_lock_sw = "Y" then
                    call cl_err("", -263, 1)
                    cancel delete
                end if
                delete from tc_xmg_file                 #刪除單身
                 where tc_xmg01 = p_tc_xmf00 and tc_xmg02 = p_tc_xmf01
                   and tc_xmg03 = g_tc_xmg[l_ac].tc_xmg03
                if sqlca.sqlcode then
                    call cl_err3("del","tc_xmg_file",p_tc_xmf00,"",sqlca.sqlcode,"","",1)  #no.fun-660167
                    rollback work
                    cancel delete
                end if 
                let g_rec_b=g_rec_b-1
            end if
            if g_success ='y' then commit work end if
        
        on action controls
            call cl_set_head_visible('','auto')
        
        on action controlo
            if infield(tc_xmg03) and l_ac > 1 then
                let g_tc_xmg[l_ac].* = g_tc_xmg[l_ac-1].*
                next field tc_xmg03
            end if
        
        on action controlr
            call cl_show_req_fields()
        
        on action controlg
            call cl_cmdask()
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        
        on action about
            call cl_about()
        
        on action help
            call cl_show_help()
        
    end input
    
    close WINDOW scxmt520_w
end function


function scxmt520_b_remark(p_tc_xmf00,p_tc_xmf01)
    define p_tc_xmf00   like tc_xmf_file.tc_xmf00
    define p_tc_xmf01   like tc_xmf_file.tc_xmf01

    define l_remark string
    define i   integer

    call scxmt520_b_fill(p_tc_xmf00,p_tc_xmf01)

    for i = 1 to g_tc_xmg.getlength()
        if not cl_null(g_tc_xmg[i].tc_xmg04) then
            let l_remark = l_remark , sfmt("%1:%2 %3%4 %5;",g_tc_xmg[i].tc_xmg04,g_tc_xmg[i].tc_xmg07,
                                           g_tc_xmg[i].tc_xmg05,g_tc_xmg[i].tc_xmg06,g_tc_xmg[i].tc_xmg08)
        else
            let l_remark = l_remark,"备注:",g_tc_xmg[i].tc_xmg08,";"
        end if
    end for
    
    return l_remark
end function

function t520sub_lock_cl()
    define l_forupd_sql string
 
    let l_forupd_sql = "select * from tc_xme_file where tc_xme00 = ? for update"
    let l_forupd_sql = cl_forupd_sql(l_forupd_sql)

    declare t520sub_cl cursor from l_forupd_sql
    # let l_forupd_sql = "select * from occ_file where occ01 = ? for update"
    # let l_forupd_sql = cl_forupd_sql(l_forupd_sql)

    # declare t400sub_cl2 cursor from l_forupd_sql
end function

function t520sub_y_chk(p_tc_xme00)
    define p_tc_xme00   like tc_xme_file.tc_xme00
    define l_tc_xme     record like tc_xme_file.*

    whenever error continue

    let g_success = 'Y'
    
    if cl_null(p_tc_xme00) then
        call cl_err('',-400,0)
        # run "echo '"||p_tc_xme00||" -400 \n"||"' >> /u1/out/darcy.txt"
        let g_success ='N'
        return
    end if

    select * into l_tc_xme.* from tc_xme_file where tc_xme00 = p_tc_xme00
    if l_tc_xme.tc_xmeconf = 'Y' then
        call cl_err('',9023,0)
        # run "echo '"||p_tc_xme00||" 9023 \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'
        return
    end if

    if l_tc_xme.tc_xmeconf = 'X' then
        call cl_err('',9024,0)
        # run "echo '"||p_tc_xme00||" 9024 \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'   #fun-580155
        return
    end if

    if g_action_choice clipped = "confirm" or
        g_action_choice clipped = "insert" then
        # run "echo '"||p_tc_xme00||" confirm \n"||"' >> /u1/out/darcy.txt"
        if not cl_confirm("axm-108") then
            let g_success = 'N'
            return
        end if
    end if
end function

function t520sub_y_upd(p_tc_xme00,p_inTransaction)
    define p_tc_xme00   like tc_xme_file.tc_xme00
    define l_tc_xme     record like tc_xme_file.*
    define p_inTransaction like type_file.num5 
    if not p_inTransaction then
        begin work
    end if
    
    call t520sub_lock_cl()
    open t520sub_cl using p_tc_xme00
    if status then
        call cl_err("open t520sub_cl:", status, 1)
        # run "echo '"||p_tc_xme00||" open t520sub_cl \n"||"' >> /u1/out/darcy.txt"
        close t520sub_cl
        rollback work
        let g_success = 'N'                                #chi-b80050
        return
    end if

    fetch t520sub_cl into l_tc_xme.*
    if sqlca.sqlcode then
        call cl_err(l_tc_xme.tc_xme00,sqlca.sqlcode,0)     # 資料被他人lock
        rollback work
        # run "echo '"||p_tc_xme00||sqlca.sqlcode||" \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'
        return
    end if

    let g_success = 'Y'

    if g_action_choice clipped = "confirm" or
        g_action_choice clipped = "insert" then
        if l_tc_xme.tc_xme07 = 'Y' then
            if l_tc_xme.tc_xmeacti !='1' then
                call cl_err('','aws-078',1)
                # run "echo '"||p_tc_xme00||" aws-078 \n"||"' >> /u1/out/darcy.txt"
                let g_success = 'N'
                rollback work
                return
            end if
        end if
    end if

    if g_success ='Y' then
        call t520sub_ins(p_tc_xme00)
    end if

    call t520sub_ins_ims(p_tc_xme00)

    update tc_xme_file 
       set tc_xmeconf = 'Y',
           tc_xmemodu = g_user,
           tc_xmedate=g_today 
     where tc_xme00 = l_tc_xme.tc_xme00
    if sqlca.sqlcode or sqlca.sqlerrd[3] = 0 then 
        # CALL cl_err3("upd","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",0)
        call cl_err('upd tc_xme_file',sqlca.sqlcode,1)
        # run "echo '"||p_tc_xme00||" upd tc_xme_file \n"||"' >> /u1/out/darcy.txt"
        let g_success = 'N'
        return
    end if 

    if g_success ='Y' then
        if not p_inTransaction then
            commit work
        end if
    else
        rollback work
    end if
end function

# 方便调用,和t520_ins()逻辑一样
FUNCTION t520sub_ins(p_tc_xme00)
    define p_tc_xme00   like tc_xme_file.tc_xme00
    define l_xme        record like xme_file.*
    define l_tc_xme     record like tc_xme_file.*
    define l_x,l_i      like type_file.num5
    define l_sql        string 
    define l_tc_xmf     record like tc_xmf_file.*
    define l_xmf        record like xmf_file.*


    select * into l_tc_xme.* from tc_xme_file where tc_xme00 = p_tc_xme00

     SELECT COUNT(*) INTO l_x FROM xme_file WHERE xme01 = l_tc_xme.tc_xme01 AND xme02 = l_tc_xme.tc_xme02 AND xme00='1'  AND ta_xme01 = l_tc_xme.tc_xme06
     IF l_x >0 THEN 
        LET l_sql = "SELECT * FROM tc_xmf_file WHERE tc_xmf00 = '",l_tc_xme.tc_xme00,"'"
        PREPARE t520_tc_xmf_prepare1 FROM l_sql
        IF STATUS THEN
           CALL cl_err('pre',STATUS,1)
        #    run "echo '"||p_tc_xme00||" pre \n"||"' >> /u1/out/darcy.txt"
           LET g_success = 'N'
           RETURN
        END IF
        DECLARE t520_tc_xmf_cs1 CURSOR FOR t520_tc_xmf_prepare1 
        LET l_i = 1
        INITIALIZE l_tc_xmf.* TO NULL
        INITIALIZE l_xmf.* TO NULL
        FOREACH t520_tc_xmf_cs1 INTO l_tc_xmf.*
           SELECT COUNT(*) INTO l_i FROM xmf_file 
            WHERE xmf01 = l_tc_xme.tc_xme01 
              AND xmf02 = l_tc_xme.tc_xme02 
              AND xmf03 = l_tc_xmf.tc_xmf03
              AND xmf04 = l_tc_xmf.tc_xmf04
              AND xmf05 = g_today
              AND ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
           IF l_i > 0 THEN 
              UPDATE xmf_file SET xmf07 = l_tc_xmf.tc_xmf05
                                  ,ta_xmf03 = l_tc_xmf.tc_xmf06  #darcy:2023/04/04 add 应该是更新，而不是作为条件查询。
                               WHERE xmf01 = l_tc_xme.tc_xme01 
                                 AND xmf02 = l_tc_xme.tc_xme02 
                                 AND xmf03 = l_tc_xmf.tc_xmf03
                                 AND xmf04 = l_tc_xmf.tc_xmf04
                                 AND xmf05 = g_today
                                 AND ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
                                #  AND ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715 #darcy:2023/04/04 mark
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
                 CALL cl_err3("upd","xmf_file",l_tc_xme.tc_xme01,l_tc_xme.tc_xme02,SQLCA.sqlcode,"","",0)
                #  run "echo '"||p_tc_xme00||" upd xmf_file \n"||"' >> /u1/out/darcy.txt"
                 LET g_success = 'N'
                 EXIT FOREACH 
              END IF
           ELSE 
              LET l_xmf.xmf01 = l_tc_xme.tc_xme01
              LET l_xmf.xmf02 = l_tc_xme.tc_xme02
              LET l_xmf.xmf03 = l_tc_xmf.tc_xmf03
              LET l_xmf.xmf04 = l_tc_xmf.tc_xmf04
              LET l_xmf.xmf05 = g_today
              LET l_xmf.xmf07 = l_tc_xmf.tc_xmf05
              LET l_xmf.xmf08 = 100
              LET l_xmf.ta_xmf01 = l_tc_xme.tc_xme03    #str—add by huanglf 160707
              LET l_xmf.ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
              LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
              LET l_xmf.ta_xmf04 = l_tc_xmf.tc_xmf07   #add by huanglf170317  
              LET l_xmf.ta_xmf05 = l_tc_xmf.tc_xmf08   #add by huanglf170317
              INSERT INTO xmf_file VALUES l_xmf.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","xmf_file",l_xmf.xmf01,l_xmf.xmf02,SQLCA.sqlcode,"","",1) 
                #  run "echo '"||p_tc_xme00||" ins xmf_file \n"||"' >> /u1/out/darcy.txt"
                 LET g_success = 'N'
                 EXIT FOREACH 
              END IF
           END IF  
        END FOREACH 
     ELSE 
        INITIALIZE l_xme.* TO NULL
        LET l_xme.xme00 = '1'
        LET l_xme.xme01 = l_tc_xme.tc_xme01
        LET l_xme.xme02 = l_tc_xme.tc_xme02
        LET l_xme.xmeuser=g_user
        LET l_xme.xmeoriu = g_user #FUN-980030
        LET l_xme.xmeorig = g_grup #FUN-980030
        LET l_xme.xmegrup=g_grup
        LET l_xme.xmedate=g_today  
        LET l_xme.ta_xme01 = l_tc_xme.tc_xme06  #add by guanyao161711
        LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
        INSERT INTO xme_file VALUES (l_xme.*)
        IF SQLCA.sqlcode THEN                         
           CALL cl_err3("ins","xme_file",l_tc_xme.tc_xme01,l_tc_xme.tc_xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
           LET g_success = 'N'
        #    run "echo '"||p_tc_xme00||" ins xme_file \n"||"' >> /u1/out/darcy.txt"
           RETURN 
        END IF
        LET l_sql = "SELECT * FROM tc_xmf_file WHERE tc_xmf00 = '",l_tc_xme.tc_xme00,"'"
        PREPARE t520_tc_xmf_prepare FROM l_sql
        IF STATUS THEN
           CALL cl_err('pre',STATUS,1)
        #    run "echo '"||p_tc_xme00||" pre 231 \n"||"' >> /u1/out/darcy.txt"
           LET g_success = 'N'
           RETURN
        END IF
        DECLARE t520_tc_xmf_cs CURSOR FOR t520_tc_xmf_prepare 
        LET l_i = 1
        INITIALIZE l_tc_xmf.* TO NULL
        INITIALIZE l_xmf.* TO NULL
        FOREACH t520_tc_xmf_cs INTO l_tc_xmf.*
           LET l_xmf.xmf01 = l_tc_xme.tc_xme01
           LET l_xmf.xmf02 = l_tc_xme.tc_xme02
           LET l_xmf.xmf03 = l_tc_xmf.tc_xmf03
           LET l_xmf.xmf04 = l_tc_xmf.tc_xmf04
           LET l_xmf.xmf05 = g_today
           LET l_xmf.xmf07 = l_tc_xmf.tc_xmf05
           LET l_xmf.xmf08 = 100
           LET l_xmf.ta_xmf01 = l_tc_xme.tc_xme03    #str—add by huanglf 160707
           LET l_xmf.ta_xmf02 = l_tc_xme.tc_xme06   #add by guanyao160711
           LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
           INSERT INTO xmf_file VALUES l_xmf.*
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","xmf_file",l_xmf.xmf01,l_xmf.xmf02,SQLCA.sqlcode,"","",1) 
            #   run "echo '"||p_tc_xme00||" 253 ins xmf_file \n"||"' >> /u1/out/darcy.txt"
              LET g_success = 'N'
              EXIT FOREACH 
           END IF 
        END FOREACH 
     END IF 
END FUNCTION 

function t520sub_ins_ims(p_tc_xme00)
    define p_tc_xme00  like tc_xme_file.tc_xme00
    define l_sql    string
    define l_ac,l_num         like type_file.num5
    define l_tc_xmf  dynamic array of record like tc_xmf_file.*

    let l_sql = " SELECT * FROM tc_xmf_file ",
              " WHERE tc_xmf00 = '",p_tc_xme00,"'" 
    prepare t520sub_pb1 from l_sql
    declare t520sub_bcs1 cursor with hold for t520sub_pb1
    let l_ac = 1
    foreach t520sub_bcs1 into l_tc_xmf[l_ac].* 

        if cl_null(l_tc_xmf[l_ac].tc_xmf09) then
                continue foreach 
        end if 
        select count(*) into l_num from tc_ims_file where tc_ims01 = l_tc_xmf[l_ac].tc_xmf03
            if l_num >0 then 
                update tc_ims_file set tc_ims02 = l_tc_xmf[l_ac].tc_xmf09 
                where tc_ims01 = l_tc_xmf[l_ac].tc_xmf03 
            else 
                insert into tc_ims_file (tc_ims01,tc_ims02) 
                values (l_tc_xmf[l_ac].tc_xmf03,l_tc_xmf[l_ac].tc_xmf09)
            end if
        let l_ac = l_ac + 1
    end foreach 
end function
