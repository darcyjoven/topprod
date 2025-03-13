# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cecp300.4gl
# Descriptions...: ABMI600,AECI100整批审核，发放
# Date & Author..:darcy:2023/04/13 add

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    yy              LIKE type_file.num10,       # No.FUN-690028 INTEGER
    g_a             LIKE type_file.chr1,        #No.MOD-740358 
    g_change_lang   LIKE type_file.chr1,        #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
    g_wc,g_sql      string,  #No.FUN-580092 HCN
    l_flag          LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT

define g_bma01      string
define g_new_no      string
define tm record
    bma01       varchar(40),
    new_no      varchar(40),
    bom_exp     like type_file.chr1
    end record
define g_tot_success    varchar(1)
 
MAIN
   DEFINE l_time  	LIKE type_file.chr8    #No.FUN-690028 VARCHAR(8)
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL 
   let tm.bma01     = ARG_VAL(1)
   let tm.new_no    = ARG_VAL(2)
   let tm.bom_exp   = ARG_VAL(3)
   LET g_bgjob       = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p300()
         IF cl_sure(0,0) THEN
            LET g_success = 'Y'
            call s_showmsg_init()
            call p300_crt_temp()
            BEGIN WORK
            CALL p300_process()
            call s_showmsg()
            IF g_success = 'Y' THEN
                COMMIT WORK
                CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p300_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p300_process()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570112 END--------------
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   #IF INT_FLAG THEN LET INT_FLAG = 0 END IF  NO.FUN-570112 MARK
END MAIN
 
FUNCTION p300()
  #DEFINE   l_flag    LIKE type_file.num5        #No.FUN-570112  #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(500)   #No.FUN-570112
   DEFINE   p_row,p_col,l_cnt   LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT
   define l_temp string
 
   LET g_action_choice = ""
#->No.FUN-570112 --start--
   OPEN WINDOW p300_w AT p_row,p_col WITH FORM "cec/42f/cecp300"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init() 
 
   CLEAR FORM 
   let g_bgjob = "N"
   let tm.bom_exp = 'Y'

#    dialog
    input by name tm.* ATTRIBUTES( WITHOUT DEFAULTS)
        before input
            message ''
        
        after field bma01
            if not cl_null(tm.bma01) then
                let l_cnt = 0
                select count(1) into l_cnt from bma_file where bma01 = tm.bma01
                if l_cnt = 0 then
                    call cl_err(tm.bma01,"cbm-024",1)
                    next field bma01
                end if
            end if

        after field new_no
            if not cl_null(tm.new_no) then
                # 已存在料件基础资料
                let l_cnt = 0
                select (1) into l_cnt from ima_file where ima01 = tm.new_no
                if l_cnt > 0 then
                    call cl_err(tm.new_no,"cbm-025",0)
                end if
                let l_temp = tm.new_no
                if l_temp.getlength() != 10 then
                    call cl_err(l_temp,"cbm-027",1)
                    next field new_no
                end if
            end if

        on action controlp

        on action accept
            let g_action_choice="accept"
            accept input

        on action cancel
            let g_action_choice="exit"
            exit input

        on action exit
            let g_action_choice="exit"
            exit input
        
        on action qbe_select
            call cl_qbe_select()

        on action qbe_save
            call cl_qbe_save()
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        
        on action about
            call cl_about()
        
        on action controlg
            call cl_cmdask()
        
        on action help
            call cl_show_help()
    end input

        

#    end dialog

    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        close window p300_w
        call  cl_used(g_prog,g_time,2) returning g_time
        exit program
    end if
    #darcy:2023/07/15 add s---
    # 检查bma01 和 new_no 是否正确
    if cl_null(tm.bma01) or cl_null(tm.new_no) then
        call cl_err('',"cbm-026",1)
        call p300()
    end if
    #darcy:2023/07/15 add e---
end function
 
function p300_process()
    define l_cnt    integer

    let g_success = 'Y'
    let g_tot_success = 'Y'

    call p300_copy(tm.bma01,tm.new_no)
    if tm.bom_exp = 'Y' then
        call p300_bom(tm.bma01," ")
    end if
end function

function p300_bom(p_bmb01,p_bma06)
    define p_bmb01      like bmb_file.bmb01
    define p_bma06      like bma_file.bma06
    define l_bmb    dynamic array of record
            bmb01       like bmb_file.bmb01,
            bmb03       like bmb_file.bmb03,
            bmb29       like bmb_file.bmb29
        end record
    define l_new_no     varchar(40)
    define l_sql        string
    define l_index,l_cnt,i,j      integer

    
    let l_sql = "select bmb01,bmb03,bmb29 from bmb_file where bmb01 = ? and bmb29 =? ",
                " and bmb04 <= ? and (bmb05 is null or bmb05 > ? )"
    prepare p300_bom_bp from l_sql
    declare p300_bom_cl cursor for p300_bom_bp

    let l_index = 1
    foreach p300_bom_cl using p_bmb01,p_bma06,g_today,g_today
       into l_bmb[l_index].*
       if sqlca.sqlcode then
            call cl_err('p300_bom_cl',sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
        end if
        let l_index = l_index + 1
    end foreach
    call l_bmb.deleteElement(l_index)

    for i = 1 to l_bmb.getlength()

        # 如果下阶料，继续遍历下阶料
        select count(*) into l_cnt from bmb_file where bmb01 = l_bmb[i].bmb03
        if l_cnt > 0 then
            let l_new_no = p300_get_new_no(l_bmb[i].bmb03)
            if g_success = 'Y' then
                call p300_copy(
                    l_bmb[i].bmb03,
                    l_new_no
                )
                if g_success = 'N' then
                    let g_tot_success = 'N'
                end if
            else
                let g_tot_success = 'N'
            end if
            call p300_bom(l_bmb[i].bmb03,l_bmb[i].bmb29)
        end if
    end for
end function

function p300_copy(p_from,p_dst)
    define p_from,p_dst varchar(40)
    define l_cnt integer
    define l_ima02  like ima_file.ima02
    define c_ima,l_ima record like ima_file.*
    # 从p_from复制到p_dst
    # 1.如果p_from 有下阶料才序号复制，
    # 2.如果已经存在料号，直接跳过，# TODO: 是否需要提示？
    # 3.产生成功后加入到报错列表中
    # 4.复制过程中报错加入到报错列表，设置g_tot_success = 'N'，后继续处理下一个
    # 5.一个料号，保证只有一笔报错

    let g_success = 'Y'
    let l_cnt = 0
    select count(1) into l_cnt from bmb_file where bmb01 = p_from
    if l_cnt = 0 then
        return
    end if

    let l_cnt = 0 
    select count(1) from ima_file where ima01 = p_dst
    if l_cnt > 0 then
        return
    end if
    # ima_file 料件基础资料
    call p300_ins_ima(p_from,p_dst)

    if g_success = 'N' then
        let g_tot_success = 'N'
        return
    end if
    # 料件单位转化资料
    call p300_ins_smd(p_from,p_dst)
    
    if g_success = 'N' then
        let g_tot_success = 'N'
        return
    end if

    CALL s_zero(p_dst)

    call  p300_ins_imt(p_from,p_dst)

    if g_success = 'N' then
        let g_tot_success = 'N'
        return
    end if

    if g_success = 'Y' then
        CALL s_errmsg("ima01,new_no",p_from||"|"||p_dst,"复制资料成功",'!',1)
    end if

end function

function p300_get_new_no(p_item)
    define p_item   string
    define r_item   varchar(40)

    if p_item.getIndexOf(tm.bma01,1) <=0 then
        CALL s_errmsg("ima01,old_no",p_item||"|"||tm.bma01,"料件编码错误",'!',1)
        let g_success = 'N'
        return ""
    end if

    let r_item =  cl_replace_str(p_item,tm.bma01,tm.new_no)

    return r_item
end function

function p300_crt_temp()
    drop table p300_ima
    select * from ima_file where 1=2 into temp p300_ima
    drop table p300_smd
    select * from smd_file where 1=2 into temp p300_smd
end function

# ima_file
function p300_ins_ima(p_from,p_dst)
    define  p_from,p_dst    varchar(40)
    define l_ima02  varchar(800)
    define l_ima,c_ima  record like ima_file.*

    let g_success = 'Y'

    SELECT * INTO c_ima.* FROM ima_file WHERE ima01 = p_from     #MOD-B90017 add
    let l_ima02 = cl_replace_str(c_ima.ima02,tm.bma01,tm.new_no)
   
    LET l_ima.* = c_ima.*       #MOD-B90017 add
    LET l_ima.ima01  =p_dst   #資料鍵值
    LET l_ima.ima02  =l_ima02                 #MOD-B40111 add
    LET l_ima.ima05  =NULL      #目前使用版本
    LET l_ima.ima18  =0
    LET l_ima.ima16  =99
    LET l_ima.ima29  =NULL      #最近易動日期
    LET l_ima.ima30  =NULL      #最近盤點日期
    LET l_ima.ima32  =0         #標準售價
    LET l_ima.ima33  =0         #最近售價
    LET l_ima.ima40  =0         #累計使用數量 期間
    LET l_ima.ima41  =0         #累計使用數量 年度
    LET l_ima.ima47  =0         #採購損耗率
    LET l_ima.ima52  =1         #平均訂購量
    LET l_ima.ima140 ='N'       #phase out
    LET l_ima.ima53  =0         #最近採購單價
    LET l_ima.ima531 =0         #市價
    LET l_ima.ima532 =NULL      #市價最近異動日期
    LET l_ima.ima562 =0         #生產損耗率
    LET l_ima.ima73  =NULL      #最近入庫日期
    LET l_ima.ima74  =NULL      #最近出庫日期
    LET l_ima.ima75  =''        #海關編號
    LET l_ima.ima76  =''        #商品類別
    LET l_ima.ima77  =0         #在途量
    LET l_ima.ima78  =0         #在驗量
    LET l_ima.ima80  =0         #未耗預測量
    LET l_ima.ima81  =0         #確認生產量
    LET l_ima.ima82  =0         #計劃量
    LET l_ima.ima83  =0         #MRP需求量
    LET l_ima.ima84  =0         #OM 銷單備置量
    LET l_ima.ima85  =0         #MFP銷單備置量
    LET l_ima.ima881 =NULL      #期間採購最近採購日期
    LET l_ima.ima91  =0         #平均採購單價
    LET l_ima.ima92  ='N'       #net change status
    LET l_ima.ima93  ='NNNNNNNN'#new parts status
    LET l_ima.ima94  =''        #
    LET l_ima.ima95  =0         #
    LET l_ima.ima96  =0         #A. T. P. 量
    LET l_ima.ima97  =0         #MFG 接單量
    LET l_ima.ima98  =0         #OM 接單量
    LET l_ima.ima104 =0         #廠商分配起始量
    LET l_ima.ima901 = g_today  #料件建檔日期
    LET l_ima.ima902 = NULL     #NO:6973
    LET l_ima.ima9021 = NULL    #No.FUN-8C0131
    LET l_ima.ima121 = 0        #單位材料成本
    LET l_ima.ima122 = 0        #單位人工成本
    LET l_ima.ima123 = 0        #單位製造費用
    LET l_ima.ima124 = 0        #單位管銷成本
    LET l_ima.ima125 = 0        #單位成本
    LET l_ima.ima126 = 0        #單位利潤率
    LET l_ima.ima127 = 0        #未稅訂價(本幣)
    LET l_ima.ima128 = 0        #含稅訂價(本幣)
    LET l_ima.ima132 = NULL     #費用科目編號
    LET l_ima.ima133 = NULL     #產品預測料號
    LET l_ima.ima134 = NULL     #主要包裝方式編號
    LET l_ima.ima135 = NULL     #產品條碼編號
    LET l_ima.ima139 = 'N'
    LET l_ima.ima913 = 'N'      #No.MOD-640061
    LET l_ima.ima1010 = '0'                    #FUN-690060
    LET l_ima.imauser=g_user    #資料所有者
    LET l_ima.imagrup=g_grup    #資料所有者所屬群
    LET l_ima.imamodu=NULL      #資料修改日期
    LET l_ima.imadate=g_today   #資料建立日期
    LET l_ima.imaacti='P'       #有效資料 #FUN-690060
 
    IF l_ima.ima06 IS NULL THEN
       LET l_ima.ima871 =0         #間接物料分攤率
       LET l_ima.ima872 =''        #材料製造費用成本項目
       LET l_ima.ima873 =0         #間接人工分攤率
       LET l_ima.ima874 =''        #人工製造費用成本項目
       LET l_ima.ima88  =0         #期間採購數量
       LET l_ima.ima89  =0         #期間採購使用的期間(月)
       LET l_ima.ima90  =0         #期間採購使用的期間(日)
    END IF
    IF l_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
        LET l_ima.ima08='Z'
    END IF
    IF l_ima.ima35 is null then let l_ima.ima35=' ' end if
    IF l_ima.ima36 is null then let l_ima.ima36=' ' end if
    IF cl_null(l_ima.ima903) THEN LET l_ima.ima903 = 'N' END IF #NO:6872
    IF cl_null(l_ima.ima905) THEN LET l_ima.ima905 = 'N' END IF
    IF cl_null(l_ima.ima910) THEN LET l_ima.ima910 = ' ' END IF #FUN-550014 add
    LET l_ima.ima916 = g_plant
    LET l_ima.ima917 = 0
    IF l_ima.ima131 IS NULL THEN LET l_ima.ima131 = ' ' END IF  #No.FUN-880032
    IF l_ima.ima926 IS NULL THEN LET l_ima.ima926 = 'N' END IF  #No.FUN-9B0099
    LET l_ima.ima1001 = NULL    #No.FUN-640010
    LET l_ima.ima1002 = NULL    #No.FUN-640010
    LET l_ima.ima120 = '1'      #No.FUN-A90049

    IF l_ima.ima01[1,4]='MISC' THEN
       LET l_ima.ima130='2'
    END IF

    LET l_ima.ima154 = 'N'      #FUN-870100 ADD
    LET l_ima.ima155 = 'N'      #FUN-870100 ADD 
    LET l_ima.ima571 = p_dst  #TQC-9A0185    
    LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
    LET l_ima.ima120 = '1'          #No.FUN-A90049 add

    IF cl_null(l_ima.ima156) THEN LET l_ima.ima156 ='N' END IF  #FUN-A80102
    IF cl_null(l_ima.ima157) THEN LET l_ima.ima157 =' ' END IF  #FUN-A80102
    IF cl_null(l_ima.ima158) THEN LET l_ima.ima158 ='N' END IF  #FUN-A80102
    LET l_ima.ima927='N'   #No:FUN-AA0014
    IF cl_null(l_ima.ima912) THEN LET l_ima.ima912 = 0 END IF   #TQC-B20161
    IF cl_null(l_ima.ima159) THEN LET l_ima.ima159 = '3' END IF #FUN-B90035
    IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF #TQC-C20131  add
   #TQC-C20278--add--begin
    IF cl_null(l_ima.ima918) THEN LET l_ima.ima918 = 'N' END IF
    IF cl_null(l_ima.ima919) THEN LET l_ima.ima919 = 'N' END IF
    IF cl_null(l_ima.ima921) THEN LET l_ima.ima921 = 'N' END IF
    IF cl_null(l_ima.ima922) THEN LET l_ima.ima922 = 'N' END IF
    IF cl_null(l_ima.ima924) THEN LET l_ima.ima924 = 'N' END IF
    IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF

    insert into ima_file values (l_ima.*)
    if sqlca.sqlcode then
        call s_errmsg("ima01,new_no",p_from||"|"||p_dst,"",sqlca.sqlcode,1)
        let g_success = 'N'
    end if
end function

# smd_file
function p300_ins_smd(p_from,p_dst)
    define  p_from,p_dst    varchar(40)
    let g_success = 'Y'
    
    delete from p300_smd

    insert into p300_smd select * from smd_file where smd01 = p_from
    if sqlca.sqlcode then
        CALL s_errmsg("ima01,new_no",p_from||"|"||p_dst,"x",SQLCA.sqlcode,1)
        let g_success = 'N'
        return
    end if

    UPDATE p300_smd SET smd01=p_dst,smdacti='Y',smddate=g_today

    INSERT INTO smd_file SELECT * FROM p300_smd
    IF SQLCA.sqlcode THEN
       CALL s_errmsg("ima01,new_no",p_from||"|"||p_dst,"ins smd_file",SQLCA.sqlcode,1)
       let g_success = 'N'
        return
    END IF

end function

# imt_file
function p300_ins_imt(p_from,p_dst)
    define  p_from,p_dst    varchar(40)
    define l_imt  record like imt_file.*

    DECLARE imt_cur CURSOR FOR
    SELECT * FROM imt_file WHERE imt01=p_from
    FOREACH imt_cur INTO l_imt.*
        LET l_imt.imt01 = p_dst
        INSERT INTO imt_file VALUES(l_imt.*)
        IF SQLCA.SQLCODE THEN
            CALL s_errmsg("ima01,new_no",p_from||"|"||p_dst,"ins imt_file",SQLCA.sqlcode,1)
            let g_success = 'N'
            RETURN 
        ELSE
            MESSAGE 'INSERT imt...'
        END IF
    END FOREACH
end function
