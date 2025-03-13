# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_addmailw.4gl                                                                                                        
# Descriptions...: 視圖維護作業                                                                                            
# Date & Author..: 06/12/23 shine
# Modify.........: No.TQC-860017 08/06/11 by jerry 補ON IDLE段
# Modify.........: No.TQC-880048 08/08/26 by jerry 將原本變數"宣告成固定長度"的部份修正為"參照至type_file內的欄位"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-A10090 10/01/15 By baofei 10/01/15 By baofei改ROWID 為KEY 值 
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新料號畫面

DATABASE ds     # FUN-770026
 
GLOBALS "../../config/top.global" # FUN-770026

type mail record
   mail         varchar(100),
   subject      varchar(4000),
   todaycheck   varchar(1),
   mailto       varchar(4000),
   mailcc       varchar(4000),
   mailbcc      varchar(4000),
   body_type    varchar(40),
   body_content varchar(4000),
   tables       varchar(4000),
   crontab      varchar(4000),
   cronstatus   varchar(1),
   crtuser      varchar(40),
   crtdate      datetime year to fraction(3),
   moduser      varchar(40),
   moddate      datetime year to fraction(3),
   crontabstr   varchar(4000),
   id           like type_file.num5,
   object_emp   varchar(200),
   procedures   varchar(4000)
   end record

DEFINE g_mail       mail,
       g_mail_t     mail,  #備份舊值
       g_mail_id_t   varchar(100),     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件  #No.FUN-580092 HCN
       g_sql       STRING                  #組 sql 用
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5       #判斷是否已執行 Before Input指令
DEFINE g_chr                 LIKE type_file.chr1
DEFINE g_cnt                 LIKE type_file.num5
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000 #TQC-880048
DEFINE g_curs_index         LIKE type_file.num5
DEFINE g_row_count          LIKE type_file.num5        #總筆數
DEFINE g_jump               LIKE type_file.num5        #查詢指定的筆數
DEFINE g_no_ask             LIKE type_file.num5       #是否開啟指定筆視窗
DEFINE g_cmd                STRING
DEFINE g_alldbs             STRING
DEFINE g_succeed            LIKE type_file.chr1 #TQC-880048
DEFINE g_db_type            LIKE type_file.chr3 #TQC-880048
DEFINE g_flag               LIKE type_file.chr1 #TQC-880048

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_db_type=cl_db_get_database_type()

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818

   INITIALIZE g_mail.* TO NULL
   LET g_forupd_sql = "SELECT * FROM darcy_fastmail WHERE mail = ?  FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_mailw_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p_addmailw_w WITH FORM "azz/42f/p_cronmail"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""

   CALL p_mailw_alldbs()
   CALL p_mailw_check()
   CALL p_mailw_menu()
 
   CLOSE WINDOW p_mailw_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION p_mailw_curs()
DEFINE ls STRING
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        mail,subject,body_type,body_content,mailto,mailcc,
        mailbcc,todaycheck,crontab,crtuser,crtdate,moduser,moddate,id
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
  
 
    LET g_sql="SELECT mail FROM darcy_fastmail ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY id"
    PREPARE p_mailw_prepare FROM g_sql
    DECLARE p_mailw_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p_mailw_prepare

    LET g_sql= "SELECT COUNT(*) FROM darcy_fastmail WHERE ",g_wc CLIPPED
    PREPARE p_mailw_precount FROM g_sql
    DECLARE p_mailw_count CURSOR FOR p_mailw_precount
END FUNCTION
 
FUNCTION p_mailw_menu()

    MENU ""
        BEFORE MENU
          CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            message ""
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL p_mailw_a()
            END IF
        on action send_mail
            message ""
            call p_cron_send()
        ON ACTION create_cron
            message ""
              CALL p_cron_create("n")
        ON ACTION drop_cron
            message ""
              CALL p_cron_drop("n")

        ON ACTION query
            message ""
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL p_mailw_q()
            END IF
        ON ACTION next
            message ""
            CALL p_mailw_fetch('N')
        ON ACTION previous
            message ""
            CALL p_mailw_fetch('P')
        ON ACTION modify
            message ""
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL p_mailw_u()
            END IF
        ON ACTION invalid
            message ""
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL p_mailw_x()
            END IF
        ON ACTION delete
            message ""
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL p_mailw_r()
            END IF
       ON ACTION reproduce
            message ""
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL p_mailw_copy()
            END IF

        ON ACTION help
            message ""
            CALL cl_show_help()
        ON ACTION exit
            message ""
            LET g_action_choice = "exit"
            EXIT MENU
        on action azzq001
            call cl_cmdrun_wait("azzq001")

        ON ACTION jump
            message ""
            CALL p_mailw_fetch('/')
        ON ACTION first
            message ""
            CALL p_mailw_fetch('F')
        ON ACTION last
            message ""
            CALL p_mailw_fetch('L')
        ON ACTION controlg
            message ""
            CALL cl_cmdask()
        ON ACTION locale
            message ""
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
      #darcy:2024/07/26 add s---
      on action address_replace
         call p_mail_replace()
      #darcy:2024/07/26 add e---
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT PROGRAM 
           EXIT MENU
 
    END MENU
    CLOSE p_mailw_cs
END FUNCTION
 
 
FUNCTION p_mailw_a()
   DEFINE 
   li_cnt          LIKE ze_file.ze03,                                                                                              
   li_bnt          LIKE ze_file.ze03,                                                                                              
   l_i             LIKE type_file.num5,
   l_id            like type_file.num5
   
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_mail.* to null 
    LET g_mail_id_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_mail.crtuser = g_user
        LET g_mail.moduser = g_user #FUN-980030 
        LET g_mail.crtdate = current
        LET g_mail.moddate = current

        CALL p_mailw_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_mail.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_mail.mail IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        select max(id)+1 into g_mail.id from darcy_fastmail 
        INSERT INTO darcy_fastmail (
         MAIL,SUBJECT,TODAYCHECK,MAILTO,MAILCC,MAILBCC,BODY_TYPE,BODY_CONTENT,
         TABLES,CRONTAB,CRONSTATUS,CRTUSER,CRTDATE,MODUSER,MODDATE,CRONTABSTR,
         id,object_emp,procedures
        ) VALUES(
         g_mail.mail,g_mail.subject,g_mail.todaycheck,g_mail.mailto,g_mail.mailcc,
         g_mail.mailbcc,g_mail.body_type,g_mail.body_content,g_mail.tables,g_mail.crontab,
         g_mail.cronstatus,g_mail.crtuser,g_mail.crtdate,g_mail.moduser,g_mail.moddate,g_mail.crontabstr,
         g_mail.id,g_mail.object_emp,g_mail.procedures
        )     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_mail.mail,SQLCA.sqlcode,0)    #No.FUN-660131
            CALL cl_err3("ins","darcy_fastmail",g_mail.mail,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
           # SELECT ROWID INTO g_mail_rowid FROM darcy_fastmail   #FUN-A10090
           SELECT mail  INTO g_mail.mail FROM darcy_fastmail   #FUN-A10090
                     WHERE mail = g_mail.mail
           CALL cl_getmsg('czz-001',g_lang) RETURNING li_cnt 
           CALL cl_getmsg('lib-042',g_lang) RETURNING li_bnt                                                               
           MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                    
           ON ACTION immediately                                                                                              
              LET l_i = TRUE                                                                                             
              CALL p_cron_create("a")
              EXIT MENU
                                                                                                              
           ON ACTION lateon                                                                                                
              RETURN                                                                                                      
              EXIT MENU                                                                                                   
#TQC-860017 start
  
           ON ACTION about         
              CALL cl_about()      
 
           ON ACTION controlg      
              CALL cl_cmdask()     
 
           ON ACTION help          
              CALL cl_show_help()
  
           ON IDLE g_idle_seconds 
              CALL cl_on_idle() 
             CONTINUE MENU
#TQC-860017 end
          END MENU           
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION p_mailw_i(p_cmd)
   DEFINE  p_cmd     LIKE type_file.chr1, #TQC-880048
           l_gen02   LIKE gen_file.gen02,
           l_gen03   LIKE gen_file.gen03,
           l_gen04   LIKE gen_file.gen04,
           l_gem02   LIKE gem_file.gem02,
           l_input   LIKE type_file.chr1, #TQC-880048
           l_n       LIKE type_file.num5,
           l_zai01   LIKE type_file.num5 
   
   DISPLAY BY NAME
      g_mail.mail,g_mail.subject,g_mail.body_type,g_mail.body_content,g_mail.mailto,
      g_mail.mailcc,g_mail.mailbcc,g_mail.todaycheck,g_mail.cronstatus,g_mail.crontab,
      g_mail.crtuser,g_mail.crtdate,g_mail.moduser,g_mail.moddate
      ,g_mail.id,g_mail.object_emp,g_mail.procedures #darcy:2023/03/31 add
      if p_cmd = 'a' then
         let g_mail.cronstatus = 'N'
         let g_mail.todaycheck ='N'
         let g_mail.body_type = "text"
         select max(id)+1 into g_mail.id from darcy_fastmail
         display by name g_mail.cronstatus,g_mail.todaycheck,g_mail.body_type,g_mail.id
         display g_mail.body_type to body_type
      end if
 
   INPUT BY NAME
      g_mail.mail,g_mail.subject,g_mail.body_type,g_mail.body_content,g_mail.mailto,
      g_mail.mailcc,g_mail.mailbcc,g_mail.todaycheck,g_mail.crontab,g_mail.tables
      ,g_mail.id,g_mail.object_emp,g_mail.procedures #darcy:2023/03/31 add
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL p_mailw_set_entry(p_cmd)
          CALL p_mailw_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD mail
         IF g_mail.mail IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_mail.mail != g_mail_id_t) THEN
               SELECT count(*) INTO l_n FROM darcy_fastmail WHERE mail = g_mail.mail
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_mail.mail,-239,1)
                  LET g_mail.mail = g_mail_id_t
                  DISPLAY BY NAME g_mail.mail
                  NEXT FIELD mail
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('mail:',g_errno,1)
                  LET g_mail.mail = g_mail_id_t
                  DISPLAY BY NAME g_mail.mail
                  NEXT FIELD mail
               END IF
            END IF
         END IF
      after field object_emp
      # 按钮
      on action addto
         call cl_init_qry_var()
         let g_qryparam.state = "c"   
         let g_qryparam.form = "q_gen06"
         let g_qryparam.arg1 = g_lang CLIPPED
         call cl_create_qry() RETURNING g_qryparam.multiret
         let g_mail.mailto = g_mail.mailto,",",cl_replace_str(g_qryparam.multiret,"|",",")
         display g_mail.mailto TO mailto
         next field mailto
      on action addcc
         call cl_init_qry_var()
         let g_qryparam.state = "c"   
         let g_qryparam.form = "q_gen06"
         let g_qryparam.arg1 = g_lang CLIPPED
         call cl_create_qry() RETURNING g_qryparam.multiret
         let g_mail.mailcc = g_mail.mailcc,",",cl_replace_str(g_qryparam.multiret,"|",",")
         display g_qryparam.multiret TO mailcc
      on action addbcc
         call cl_init_qry_var()
         let g_qryparam.state = "c"   
         let g_qryparam.form = "q_gen06"
         let g_qryparam.arg1 = g_lang CLIPPED
         call cl_create_qry() RETURNING g_qryparam.multiret
         let g_mail.mailbcc = g_mail.mailbcc,",",cl_replace_str(g_qryparam.multiret,"|",",")
         display g_mail.mailbcc TO mailbcc
      # 开窗
      on action controlp
         case
            when infield(mailto)
               call cl_init_qry_var()
               let g_qryparam.state = "c"   
               let g_qryparam.form = "q_gen06"
               let g_qryparam.arg1 = g_lang CLIPPED
               call cl_create_qry() RETURNING g_qryparam.multiret
               let g_mail.mailto = cl_replace_str(g_qryparam.multiret,"|",",")
               display g_mail.mailto TO mailto
               next field mailto
            when infield(mailcc)
               call cl_init_qry_var()
               let g_qryparam.state = "c"   
               let g_qryparam.form = "q_gen06"
               let g_qryparam.arg1 = g_lang CLIPPED
               call cl_create_qry() RETURNING g_qryparam.multiret
               let g_mail.mailcc = cl_replace_str(g_qryparam.multiret,"|",",")
               display g_mail.mailcc TO mailto
               next field mailcc
            when infield(mailbcc)
               call cl_init_qry_var()
               let g_qryparam.state = "c"   
               let g_qryparam.form = "q_gen06"
               let g_qryparam.arg1 = g_lang CLIPPED
               call cl_create_qry() RETURNING g_qryparam.multiret
               let g_mail.mailbcc = cl_replace_str(g_qryparam.multiret,"|",",")
               display g_mail.mailbcc TO mailbcc
               next field mailbcc 
            when infield(tables)
               call cl_init_qry_var()
               let g_qryparam.state = "c"   
               let g_qryparam.form = "p_zai01"
               let g_qryparam.arg1 = g_lang CLIPPED
               call cl_create_qry() RETURNING g_qryparam.multiret
               let g_mail.tables = cl_replace_str(g_qryparam.multiret,"|",",")
               display g_mail.tables TO tables
               next field tables 
         end case

      AFTER INPUT
         
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_mail.mail IS NULL THEN
               DISPLAY BY NAME g_mail.mail
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD mail
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(mail) THEN
            LET g_mail.* = g_mail_t.*
            CALL p_mailw_show()
            NEXT FIELD mail
         END IF
   
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
FUNCTION p_mailw_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL p_mailw_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN p_mailw_count
    FETCH p_mailw_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN p_mailw_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mail.mail,SQLCA.sqlcode,0)
        INITIALIZE g_mail.* TO NULL
    ELSE
        CALL p_mailw_fetch('F')              # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
FUNCTION p_mailw_fetch(p_flmail)
    DEFINE p_flmail          LIKE type_file.chr1 #TQC-880048          
 
    CASE p_flmail
        WHEN 'N' FETCH NEXT     p_mailw_cs INTO g_mail.mail  #FUN-A10090
        WHEN 'P' FETCH PREVIOUS p_mailw_cs INTO g_mail.mail  #FUN-A10090
        WHEN 'F' FETCH FIRST    p_mailw_cs INTO g_mail.mail  #FUN-A10090
        WHEN 'L' FETCH LAST     p_mailw_cs INTO g_mail.mail  #FUN-A10090

        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump p_mailw_cs INTO g_mail.mail     #FUN-A10090
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mail.mail,SQLCA.sqlcode,0)
        RETURN
    ELSE
      CASE p_flmail
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_mail.* FROM darcy_fastmail    # 重讀DB,因TEMP有不被更新特性
       WHERE mail = g_mail.mail    #FUN-A10090
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","darcy_fastmail",g_mail.mail,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        LET g_data_owner=g_mail.crtuser           #FUN-4C0044權限控管
        LET g_data_group=g_grup
        CALL p_mailw_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION p_mailw_show()
    define l_cmd string
    define success like type_file.chr1
    select *  into g_mail.* from darcy_fastmail  where mail = g_mail.mail
    LET g_mail_t.* = g_mail.*
    DISPLAY BY NAME g_mail.mail,
                    g_mail.subject,
                    g_mail.body_type,
                    g_mail.body_content,
                    g_mail.mailto,
                    g_mail.mailcc,
                    g_mail.mailbcc,
                    g_mail.todaycheck,
                    g_mail.crontab,
                    g_mail.crtuser,
                    g_mail.crtdate,
                    g_mail.moduser,
                    g_mail.moddate,
                    g_mail.tables,
                    g_mail.id, #darcy:2023/03/31
                    g_mail.object_emp,
                    g_mail.procedures
    if g_mail.cronstatus ='Y' then
      call cl_set_comp_lab_text("cronstatus","已建立背景执行")
    else
      call cl_set_comp_lab_text("cronstatus","未建立背景执行")
    end if
    if not cl_null(g_mail.crontabstr) then
      let l_cmd = g_mail.crontabstr
      let success = true
    else
      call p_cron_getcmd() returning success,l_cmd
    end if
    if success then
      let l_cmd = cs_darcy_get_cron(l_cmd)
      if cl_null(l_cmd) then
         let l_cmd = "未建立背景执行"
      end if
      # call cl_set_comp_lab_text("conrablable",l_cmd)
      display l_cmd to conrablable
    else
      display "未能组成cmd" to conrablable
    end if
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_mailw_u()
   define li_cnt          like ze_file.ze03
   define li_bnt          like ze_file.ze03
   define l_i             like type_file.num10
    IF g_mail.mail IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
        
    SELECT * INTO g_mail.* FROM darcy_fastmail WHERE mail=g_mail.mail 
    CALL cl_opmsg('u')
    LET g_mail_id_t = g_mail.mail
    BEGIN WORK
 
    OPEN p_mailw_cl USING g_mail.mail   #FUN-A10090
    IF STATUS THEN
       CALL cl_err("OPEN p_mailw_cl:", STATUS, 1)
       CLOSE p_mailw_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_mailw_cl INTO g_mail.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mail.mail,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_mail.moduser=g_user                  #修改者
    LET g_mail.moddate = current               #修改日期
    CALL p_mailw_show()                          # 顯示最新資料
    WHILE TRUE
        CALL p_mailw_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_mail.*=g_mail_t.*
            CALL p_mailw_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        let g_mail.moddate =  current  #更新修改日期
        UPDATE darcy_fastmail 
           SET mail = g_mail.mail,
               subject = g_mail.subject,
               body_type = g_mail.body_type,
               body_content = g_mail.body_content,
               mailto = g_mail.mailto,
               mailcc = g_mail.mailcc,
               mailbcc = g_mail.mailbcc,
               todaycheck = g_mail.todaycheck,
               cronstatus = g_mail.cronstatus,
               crontab = g_mail.crontab,
               crtuser = g_mail.crtuser,
               crtdate = g_mail.crtdate,
               moduser = g_mail.moduser,
               moddate = g_mail.moddate,
               tables = g_mail.tables,
               object_emp = g_mail.object_emp,
               procedures = g_mail.procedures
            WHERE mail = g_mail_id_t     #FUN-A10090
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","darcy_fastmail",g_mail.mail,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CLOSE p_mailw_cl
        COMMIT WORK
         CALL cl_getmsg('czz-002',g_lang) RETURNING li_cnt
         CALL cl_getmsg('lib-042',g_lang) RETURNING li_bnt

         MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                 
         ON ACTION immediately                                                                                              
            LET l_i = TRUE                                                                                             
            CALL p_cron_create("u")
            EXIT MENU
                                                                                                            
         ON ACTION lateon                                                                                                
            RETURN                                                                                                      
            EXIT MENU                                                                                                   
#TQC-860017 start

         ON ACTION about         
            CALL cl_about()      

         ON ACTION controlg      
            CALL cl_cmdask()     

         ON ACTION help          
            CALL cl_show_help()

         ON IDLE g_idle_seconds 
            CALL cl_on_idle() 
            CONTINUE MENU
#TQC-860017 end
         END MENU
        EXIT WHILE
    END WHILE
    
END FUNCTION
 
FUNCTION p_mailw_x()

END FUNCTION
 
FUNCTION p_mailw_r()
DEFINE 
   li_cnt          LIKE ze_file.ze03,                                                                                              
   li_bnt          LIKE ze_file.ze03,                                                                                              
   l_i             LIKE type_file.num5
   
    IF g_mail.mail IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN p_mailw_cl USING g_mail.mail   #FUN-A10090
    IF STATUS THEN
       CALL cl_err("OPEN p_mailw_cl:", STATUS, 0)
       CLOSE p_mailw_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_mailw_cl INTO g_mail.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mail.mail,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL p_mailw_show()
    IF cl_delete() THEN
       CALL cl_getmsg('czz-003',g_lang) RETURNING li_cnt                                                               
       CALL cl_getmsg('lib-042',g_lang) RETURNING li_bnt   
           MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                    
           ON ACTION yes                                                                                              
              LET l_i = TRUE   
            #   DROP mailW g_mail.mail                                                                                          
              DELETE FROM darcy_fastmail WHERE mail = g_mail.mail

              call p_cron_drop("d")

              CLEAR FORM
              OPEN p_mailw_count
              #FUN-B50065-add-start--
              IF STATUS THEN
                 CLOSE p_mailw_cl
                 CLOSE p_mailw_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50065-add-end-- 
              FETCH p_mailw_count INTO g_row_count
              #FUN-B50065-add-start--
              IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                 CLOSE p_mailw_cl
                 CLOSE p_mailw_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50065-add-end-- 
              DISPLAY g_row_count TO FORMONLY.cnt
              OPEN p_mailw_cs
              EXIT MENU
                                                                                                                                    
           ON ACTION NO                                                                                                
              RETURN                                                                                                      
              EXIT MENU
#TQC-860017 start
 
           ON ACTION about
             CALL cl_about()
 
           ON ACTION controlg
             CALL cl_cmdask()
 
           ON ACTION help
             CALL cl_show_help()
 
           ON IDLE g_idle_seconds
             CALL cl_on_idle()
            CONTINUE MENU
#TQC-860017 end
          END MENU           
       
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL p_mailw_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL p_mailw_fetch('/')
       END IF
    END IF
    CLOSE p_mailw_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_mailw_copy()
    DEFINE
        l_newno         varchar(40),
        l_oldno         varchar(40),
        p_cmd     LIKE type_file.chr1,
        l_input   LIKE type_file.chr1
    define l_newid integer

    IF g_mail.mail IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL p_mailw_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM mail
 
        AFTER FIELD mail
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM darcy_fastmail
                  WHERE mail = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD mail
              END IF
           END IF
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_mail.mail
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM darcy_fastmail
        WHERE mail = g_mail.mail  #FUN-A10090
        INTO TEMP x
    select max(id)+1  into l_newid from darcy_fastmail
    UPDATE x
        SET mail=l_newno,    #資料鍵值
            id=l_newid,
            crtuser=g_user,   #資料所有者
            moduser=g_user,   #資料所有者所屬群
            crtdate = g_today,
            moddate = g_today
    
    INSERT INTO darcy_fastmail
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","darcy_fastmail",g_mail.mail,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_mail.mail
        LET g_mail.mail = l_newno
        SELECT * INTO g_mail.* FROM darcy_fastmail    #FUN-A10090
               WHERE mail = l_newno
        CALL p_mailw_u()
        #SELECT darcy_fastmail.* INTO g_mail.* FROM darcy_fastmail   #FUN-A10090  #FUN-C30027
        #       WHERE mail = l_oldno  #FUN-C30027
    END IF
    #LET g_mail.mail = l_oldno  #FUN-C30027
    CALL p_mailw_show()
END FUNCTION
 
 
FUNCTION p_mailw_set_entry(p_cmd)
   DEFINE  p_cmd     LIKE type_file.chr1 #TQC-880048 
         # p_cmd     VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("mail",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION p_mailw_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1 
    
    IF p_cmd = 'u'  THEN
       CALL cl_set_comp_entry("mail",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION p_cron_create(action)
   define action like type_file.chr1
   define l_cmd string
   define l_success varchar(1)
   define l_str  varchar(4000)

   call p_cron_getcmd() returning l_success,l_cmd
   if not l_success then
      call cl_err("获取脚本失败","!",1)
      return 
   end if
   let l_cmd = g_mail.crontab clipped," ",l_cmd 
   # let l_cmd = l_cmd,"    #p_cronmail add ", current year to second -- 增加备注
   # let l_cmd = l_cmd," >> /u1/out/darcy.log 2>&1" #darcy add
   if cs_darcy_cron(l_cmd,true) then
      message "建立成功" attribute(blink,bold)
   else
      message "建立失败" attribute(blink,bold,red)
      return
   end if
   # 更新状态
   let l_str = l_cmd
   update darcy_fastmail
      set crontabstr = l_str,
          cronstatus ='Y'
    where mail = g_mail.mail
   if sqlca.sqlcode then
      message "更新状态失败,"||sqlca.sqlcode attribute(blink,red)
      if action = "u" then
         select crontabstr into l_str from darcy_fastmail where mail = g_mail.mail
         let l_cmd = l_str
         if not cs_darcy_cron(l_cmd,true) then
            message "还原失败" attribute(red,blink,bold)
         end if
      else
         call p_cron_drop("r")
      end if
   end if
   call p_mailw_show()
END FUNCTION 
 
FUNCTION p_cron_drop(action)
   define action like type_file.chr1
   define l_cmd string
   define l_success varchar(1)
   define l_str varchar(4000)

   select crontabstr into l_str from darcy_fastmail where mail = g_mail.mail
   let l_cmd = l_str
   if cl_null(l_str) then
      message "无背景执行资料，已忽略"
   end if

   if not l_success then
      call cl_err("获取脚本失败","!",1)
      return 
   end if
   if cs_darcy_cron(l_cmd,false) then
      message "作废成功" attribute(blink,bold)
   end if
   # 更新状态
   update darcy_fastmail
      set crontabstr = "",
          cronstatus ='N'
    where mail = g_mail.mail
   if sqlca.sqlcode then
      message "更新状态失败,"||sqlca.sqlcode attribute(blink,red)
      call p_cron_create("r")
      return
   end if

   call p_mailw_show()
END FUNCTION 
 
FUNCTION p_mailw_qry()
   DEFINE l_str       STRING
     
   #  CALL cl_query_dbqry(g_mail.mail,"N",g_mail.mail03)
    
    CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION 
 
FUNCTION p_mailw_put()
    
END FUNCTION 
 
 
FUNCTION p_mailw_alldbs()
   DEFINE   l_azp03   LIKE azp_file.azp03
 
   DECLARE l_select CURSOR FOR SELECT azp03 FROM azp_file
   FOREACH l_select INTO l_azp03
      IF cl_null(g_alldbs) THEN 
         LET g_alldbs = l_azp03
      ELSE
         LET g_alldbs = g_alldbs,",",l_azp03
      END IF 
   END FOREACH
END FUNCTION  
 
FUNCTION p_create()
   
   
END FUNCTION 
   
FUNCTION p_drop()
   
   
END FUNCTION 
   
FUNCTION p_mailw_check()
   
   
END FUNCTION 

function p_cron_send()
   define l_cmd string
   define l_success varchar(1)
   define result like type_file.num5

   call p_cron_getcmd() returning l_success,l_cmd
   if l_success then
      call runBatch(l_cmd,true) returning result
      if result ==0 then
         message "邮件发送成功" attribute(blink)
      else
         message "邮件发送失败，错误代码"||result attribute(blink,bold,red)
      end if
   end if
end function 

function p_cron_getcmd()
   define l_cmd  string #cmd命令
   define l_sql  string
   define l_cnt integer

   # mail 非空才能处理
   if cl_null(g_mail.mail) then
      call cl_err('',-400,1)
      return false,""
   end if

   select * into g_mail.* from darcy_fastmail where mail=g_mail.mail 
   # 检查tables
   if cl_null(g_mail.tables) then
      message "需指定视图或者表" attribute(red,blink,bold)
      return false,""
   end if
   # 检查mailto
   if cl_null(g_mail.mailto) then
      message "收件人不可为空" attribute(red,blink,bold)
      return false,""
   end if
   #crontab 需要指定
   if cl_null(g_mail.crontab) then
      message "背景执行需指定运行周期" attribute(red,blink,bold)
      return false,""
   end if
   
   # 重新查询资料
   select * into g_mail.* from darcy_fastmail
    where mail = g_mail.mail
   
   # 组成 crontab脚本 
   let l_cmd = "/u1/usr/tiptop/fast/mail"
   let l_cmd = l_cmd," --config /u1/usr/tiptop/fast/config.mail.json"
   let l_cmd = l_cmd," --mail ",g_mail.mail
   let l_cmd = l_cmd," --excel  /u1/out/",g_mail.mail,".xlsx"
   let l_cmd = l_cmd, " --style"
   return true,l_cmd
end function


function p_mail_replace()
   define l_address,l_address_replace VARCHAR(4000)
   define l_id integer,
          l_mailto VARCHAR(4000),
          l_mailcc VARCHAR(4000),
          l_mailbcc VARCHAR(4000)
   

   let l_address = ""
   let l_address_replace = ""
   prompt "输入你要修改的邮箱地址：" FOR l_address 
      attributes(without defaults)
        on action replace
           prompt "输入修改后的邮箱地址：" for l_address_replace 
   end prompt

   if cl_null(l_address) then
      call cl_err("无资料需要处理","!",1)
      return
   end if

   if l_address not matches '*@forewin-sz.com.cn,' then
      call cl_err(sfmt("输入的地址格式错误,希望是%1,你输入的是%2",'"*@forewin-sz.com.cn,"',l_address),"!",1)
      return 
   end if

   if not cl_null(l_address_replace) and l_address_replace not matches '*@forewin-sz.com.cn,' then
      call cl_err(sfmt("输入的地址格式错误,希望是%1,你输入的是%2",'"*@forewin-sz.com.cn",',l_address_replace),"!",1)
      return 
   end if

   declare p_mail_repalce_cur cursor for 
      select id,mailto,mailcc,mailbcc from darcy_fastmail
       where mailto like '%'||l_address||'%' or 
         mailcc like '%'||l_address||'%' or 
         mailbcc like '%'||l_address||'%'
   begin work
   let g_success = 'Y'
   foreach p_mail_repalce_cur
      into l_id,l_mailto,l_mailcc,l_mailbcc
      if sqlca.sqlcode then
         call cl_err("p_mail_repalce_cur",sqlca.sqlcode,1)
         rollback work
         let g_success = 'N'
         exit foreach
      end if

      let l_mailto = cl_replace_str(l_mailto,l_address,l_address_replace)
      let l_mailcc = cl_replace_str(l_mailcc,l_address,l_address_replace)
      let l_mailbcc = cl_replace_str(l_mailbcc,l_address,l_address_replace)
      
      update darcy_fastmail set mailto=l_mailto,mailcc=l_mailcc,mailbcc=l_mailbcc
       where id = l_id
      if sqlca.sqlcode then
         call cl_err("upd darcy_fastmail",sqlca.sqlcode,1)
         rollback work
         let g_success = 'N'
         exit foreach
      end if
   end foreach
   if g_success = 'Y' then
      commit work
      message "update ok"
   else
      rollback work
      message "update failed"
   end if
end function
