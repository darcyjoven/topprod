# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cecp100.4gl
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
define g_sfa  record
        sfa01       like sfa_file.sfa01,
        sfa08       like sfa_file.sfa08
    end record
 
 
MAIN
   DEFINE l_time  	LIKE type_file.chr8    #No.FUN-690028 VARCHAR(8)
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
 
   WHILE TRUE
      IF g_bgjob = "N" or cl_null(g_bgjob) THEN
         CALL p100()
         IF cl_sure(0,0) THEN
            LET g_success = 'Y'
            call s_cbmp600_crt_temp() # 表建立和删除需要放在事务外面
            call s_showmsg_init()
            BEGIN WORK
            CALL p100_process()
            IF g_success = 'Y' THEN
                COMMIT WORK
                # rollback work #方便测试，不允许提交
                # BOM 邮件通知
                # call s_cbmp600_mail() 
                # call s_showmsg()
                CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               call s_showmsg()
               CALL cl_end2(2) RETURNING l_flag
            END IF 
            
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p100_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p100_process()
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
 
FUNCTION p100()
  #DEFINE   l_flag    LIKE type_file.num5        #No.FUN-570112  #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(500)   #No.FUN-570112
   DEFINE   p_row,p_col   LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT
 
 
   LET g_action_choice = ""
#->No.FUN-570112 --start--
   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "cbm/42f/cbmp100"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init() 
 
   CLEAR FORM 
   let g_bgjob = "N" 


    input by name g_sfa.* ATTRIBUTES(UNBUFFERED,without defaults)

    on action controlp
        case 
            when infield(sfa01) 
                call cl_init_qry_var() 
                let g_qryparam.form     = "cq_sfb01_1"
                let g_qryparam.state    = "i"
                call cl_create_qry() returning g_sfa.sfa01
                display g_sfa.sfa01 to sfa01
                next field sfa01
            when infield(sfa08)
                call cl_init_qry_var() 
                let g_qryparam.form     = "q_sfa08"
                let g_qryparam.state    = "i"
                call cl_create_qry() returning g_sfa.sfa08
                display g_sfa.sfa08 to sfa08
                next field sfa08
        end case
    on action accept
        let g_action_choice="accept"
        exit input

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

    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        close window p100_w
        call  cl_used(g_prog,g_time,2) returning g_time
        exit program
    end if
    if g_wc = ' 1=1' then
        call cl_err('此作业必须录入条件','!',1)
        call p100()
    end if
end function
 
function p100_process()
    define l_bma01      like bma_file.bma01
    define l_ok         boolean

    call cs_asf_gen_offine(g_sfa.sfa01,g_sfa.sfa08,true) returning l_bma01,l_ok
    if not l_ok then
        let g_success = 'N'
    end if
end function
