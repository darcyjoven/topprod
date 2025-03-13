# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cecp200.4gl
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

define g_ecu01      string
define g_ecu02      string
define tm record
    bom         like type_file.chr1,
    bom_exp     like type_file.chr1
    end record
define g_ecu dynamic array of record
        ecu01       like ecu_file.ecu01,
        ecu02       like ecu_file.ecu02,
        sts         like type_file.chr1
    end record
define g_bmb dynamic array of record
        bmb01       like bmb_file.bmb01,
        sts         like type_file.chr1
    end record
 
MAIN
   DEFINE l_time  	LIKE type_file.chr8    #No.FUN-690028 VARCHAR(8)
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL 
   let g_ecu01       = ARG_VAL(1)
   let g_ecu02       = ARG_VAL(2)
   let tm.bom        = ARG_VAL(3)
   let tm.bom_exp    = ARG_VAL(4)
   LET g_bgjob       = ARG_VAL(5)
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
         CALL p200()
         IF cl_sure(0,0) THEN
            LET g_success = 'Y'
            call s_cbmp600_crt_temp() # 表建立和删除需要放在事务外面
            call s_showmsg_init()
            BEGIN WORK
            CALL p200_process()
            IF g_success = 'Y' THEN
                COMMIT WORK
                # rollback work #方便测试，不允许提交
                # BOM 邮件通知
                call s_cbmp600_mail()
                call p200_ecu_msg()
                call s_showmsg()
                CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               call s_showmsg()
               CALL cl_end2(2) RETURNING l_flag
            END IF 
            
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p200_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p200_process()
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
 
FUNCTION p200()
  #DEFINE   l_flag    LIKE type_file.num5        #No.FUN-570112  #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(500)   #No.FUN-570112
   DEFINE   p_row,p_col   LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT
 
 
   LET g_action_choice = ""
#->No.FUN-570112 --start--
   OPEN WINDOW p200_w AT p_row,p_col WITH FORM "cec/42f/cecp200"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init() 
 
   CLEAR FORM 
   let g_bgjob = "N"
   let tm.bom = 'Y'
   let tm.bom_exp = 'Y'

   dialog
        construct g_wc on ecu01,ecu02 from ecu01,ecu02
            before construct
                message ''
                display g_ecu01 to ecu01
                display g_ecu02 to ecu02

        end construct
        input by name tm.* ATTRIBUTES( WITHOUT DEFAULTS)
            before input
                message ''
        end input

        on action controlp

        on action accept
            let g_action_choice="accept"
            exit dialog

        on action cancel
            let g_action_choice="exit"
            exit dialog

        on action exit
            let g_action_choice="exit"
            exit dialog
        
        on action qbe_select
            call cl_qbe_select()

        on action qbe_save
            call cl_qbe_save()
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        
        on action about
            call cl_about()
        
        on action controlg
            call cl_cmdask()
        
        on action help
            call cl_show_help()

   end dialog

    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        close window p200_w
        call  cl_used(g_prog,g_time,2) returning g_time
        exit program
    end if
    if g_wc = ' 1=1' then
        call cl_err('此作业必须录入条件','!',1)
        call p200()
    end if
end function
 
function p200_process()
    define sr record
        ecu01       like ecu_file.ecu01,
        ecu02       like ecu_file.ecu02
        end record
    define l_cnt    integer

    let g_success = 'Y'

    let g_sql = "select ecu01,ecu02 from ecu_file where ",g_wc
    prepare p200_ecu_pb from g_sql
    declare p200_ecu_cl cursor for p200_ecu_pb
     
    initialize sr.* to null
    foreach p200_ecu_cl into sr.*
        if sqlca.sqlcode then
            call cl_err('p200_ecu_cl',sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
        end if 
        # 2. 审核,发放
        call p200_aeci100(sr.ecu01,sr.ecu02)
        if g_success = 'N' then
            exit foreach
        end if
        # 3. BOM审核发放
        call s_cbmp600(" 1=1 AND bma01 ='"||sr.ecu01||"' AND bma06 =' '",true)
        if g_success = 'N' then
            exit foreach
        end if
        # 4. 遍历BOM
        if tm.bom_exp = 'Y' then
            call p200_bom(sr.ecu01,sr.ecu02)
            if g_success = 'N' then
                exit foreach
            end if
        end if
    end foreach
end function

function p200_bom(p_bmb01,p_ecu02)
    define p_bmb01      like bmb_file.bmb01
    define p_ecu02      like ecu_file.ecu02
    define l_bmb    dynamic array of record
            bmb01       like bmb_file.bmb01,
            bmb03       like bmb_file.bmb03
        end record
    define l_sql        string
    define l_index,l_cnt      integer
    
    let l_sql = "select bmb01,bmb03 from bmb_file where bmb01 = ? ",
                " and bmb04 <= ? and (bmb05 is null or bmb05 > ? )"
    prepare p200_bom_bp from l_sql
    declare p200_bom_cl cursor for p200_bom_bp

    let l_index = 1
    foreach p200_bom_cl using p_bmb01,g_today,g_today
       into l_bmb[l_index].*
       if sqlca.sqlcode then
            call cl_err('p200_bom_cl',sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
        end if
        let l_index = l_index + 1
    end foreach
    call l_bmb.deleteElement(l_index)

    for l_index = 1 to l_bmb.getlength()
        # 1. 有ecu资料
        select count(1) into l_cnt from ecu_file where ecu01 = l_bmb[l_index].bmb03 and ecu02 = p_ecu02
        if l_cnt > 0 then
            call p200_aeci100(l_bmb[l_index].bmb03,p_ecu02)
            if g_success = 'N' then
                return
            end if
        end if
        # 2. 有bma资料
        select count(1) into l_cnt from bma_file where bma01 = l_bmb[l_index].bmb03
        if l_cnt > 0 then
            call p200_bom(l_bmb[l_index].bmb03,p_ecu02)
            if g_success = 'N' then
                return
            end if
        end if
    end for
end function

function p200_aeci100(p_ecu01,p_ecu02)
    define p_ecu01      like ecu_file.ecu01
    define p_ecu02      like ecu_file.ecu02
    define l_cnt        integer

    define l_ecu10      like ecu_file.ecu10
    define l_ecuud02    like ecu_file.ecuud02

    let g_success = 'Y' 
    select ecu10,ecuud02 into l_ecu10,l_ecuud02 from ecu_file where ecu01 = p_ecu01 and ecu02 = p_ecu02
 
    # 已审核或者已发放不需要报错，跳过

    if l_ecuud02 = 'N' then
        call i100sub_y_chk(p_ecu01,p_ecu02)
        if g_success = 'Y' then
            call i100sub_y_upd(p_ecu01,p_ecu02,true)
        end if
    end if
    if g_success ='Y' and l_ecu10 = 'N' then
        call i100sub_release(p_ecu01,p_ecu02,true)
    end if
    call p200_ecu_ins(p_ecu01,p_ecu02)

end function

function p200_ecu_ins(p_ecu01,p_ecu02)
    define p_ecu01  like ecu_file.ecu01
    define p_ecu02  like ecu_file.ecu02
    define l_cnt    integer

    let l_cnt = g_ecu.getlength()

    let g_ecu[l_cnt+1].ecu01 = p_ecu01
    let g_ecu[l_cnt+1].ecu02 = p_ecu02
    let g_ecu[l_cnt+1].sts = 'Y'

end function

function p200_bmb_ins(p_bmb01)
    define p_bmb01      like bmb_file.bmb01
    define l_cnt        integer

    let l_cnt = g_bmb.getlength()

    let g_bmb[l_cnt+1].bmb01 = p_bmb01
    let g_bmb[l_cnt+1].sts = 'Y'
end function

function p200_ecu_msg()
    define l_i  integer

    for l_i = 1 to g_ecu.getlength()
        call s_errmsg('ecu01,ecu02',g_ecu[l_i].ecu01||','||g_ecu[l_i].ecu02,'','cec-046',-1)
    end for
end function
