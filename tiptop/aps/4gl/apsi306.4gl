# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsi306.4gl
# Descriptions...: 儲位資料維護作業
# Date & Author..: NO.FUN-850114 07/12/27 BY Yiting
# Modify.........: NO.FUN-910005 09/01/05 By Duke 增加是否受供給法則限制, 0;否 1:是
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0076 09/10/26 By lilingyu 改寫Sql寫法
# Modify.........: No.FUN-B50004 11/05/06 By Abby GP5.25追版 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmg   RECORD            
                vmg01            LIKE vmg_file.vmg01,   #FUN-850114
                vmg02            LIKE vmg_file.vmg02,
                vmg05            LIKE vmg_file.vmg05,
                vmg06            LIKE vmg_file.vmg06    #FUN-910005 ADD
                END RECORD,
    g_vmg_t RECORD
                vmg01            LIKE vmg_file.vmg01,
                vmg02            LIKE vmg_file.vmg02,
                vmg05            LIKE vmg_file.vmg05,
                vmg06            LIKE vmg_file.vmg06    #FUN-910005 ADD
                END RECORD,
    g_wc,g_sql          STRING  
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_flag          LIKE type_file.chr1    #FUN-680048
 
MAIN
   OPTIONS			                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT		                #擷取中斷鍵,由程式處理
 
   LET g_vmg.vmg01   = ARG_VAL(1)
   LET g_vmg.vmg02 = ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)
 
   LET g_forupd_sql = "SELECT * FROM vmg_file WHERE vmg01 = ? AND vmg02= ? FOR UPDATE"  #FUN-9A0076
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i306_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i306_w WITH FORM "aps/42f/apsi306"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   #FUN-680048
   IF g_vmg.vmg01 IS NOT NULL AND g_vmg.vmg01 != ' ' THEN
      LET g_flag = 'Y'
      CALL i306_q()
   ELSE
      LET g_flag = 'N'
   END IF
 
   WHILE TRUE
      LET g_action_choice=""
      CALL i306_menu()
      IF g_action_choice="exit" THEN 
         EXIT WHILE 
      END IF
   END WHILE
   #FUN-680048
 
   CLOSE WINDOW i306_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i306_cs()
 
   CLEAR FORM
 
   IF g_flag = 'Y' THEN          #FUN-680048
      LET g_wc = " vmg01='",g_vmg.vmg01,"' AND vmg02='",g_vmg.vmg02,"'"
   ELSE
   INITIALIZE g_vmg.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON vmg01,vmg02,vmg05,vmg06   #FUN-910005 ADD vmg06
 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_sql = "SELECT vmg01,vmg02 FROM vmg_file ",   # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY vmg01,vmg02"
   PREPARE i306_prepare FROM g_sql                     # RUNTIME 編譯
   DECLARE i306_cs                                     # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i306_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM vmg_file WHERE ",g_wc CLIPPED
   PREPARE i306_precount FROM g_sql
   DECLARE i306_count CURSOR FOR i306_precount
 
END FUNCTION
 
FUNCTION i306_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i306_q()
         END IF
      ON ACTION next 
         CALL i306_fetch("N") 
      ON ACTION previous 
         CALL i306_fetch("P")
      ON ACTION last
         CALL i306_fetch('L')
      ON ACTION modify 
         CALL i306_u()
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i306_fetch("/")
      ON ACTION first
         CALL i306_fetch("F")
      ON ACTION CONTROLG    
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.FUN-6A0163-------add--------str----
      ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
         IF cl_chk_act_auth() THEN                     
             IF g_vmg.vmg01 IS NOT NULL THEN            
                LET g_doc.column1 = "vmg01"               
                LET g_doc.column2 = "vmg02"               
                LET g_doc.value1 = g_vmg.vmg01            
                LET g_doc.value2 = g_vmg.vmg02           
                CALL cl_doc()                             
             END IF                                        
         END IF                                           
      #No.FUN-6A0163-------add--------end----
 
         LET g_action_choice = "exit"
         CONTINUE MENU
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
   END MENU
 
   CLOSE i306_cs
 
END FUNCTION
 
FUNCTION i306_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
 
   DISPLAY BY NAME g_vmg.vmg01,g_vmg.vmg02,g_vmg.vmg05,g_vmg.vmg06  #FUN-910005 ADD vmg06  
 
   INPUT BY NAME g_vmg.vmg01,g_vmg.vmg02,g_vmg.vmg05,g_vmg.vmg06 WITHOUT DEFAULTS #FUN-910005 ADD vmg06
 
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
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
                   
FUNCTION i306_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   CALL cl_opmsg("q")
   MESSAGE ""
   DISPLAY "   " TO FORMONLY.cnt 
 
   CALL i306_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_vmg.* TO NULL
      RETURN
   END IF
 
   OPEN i306_count
   FETCH i306_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
 
   OPEN i306_cs                             # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vmg.vmg01,SQLCA.sqlcode,0)
      INITIALIZE g_vmg.* TO NULL
   ELSE
      CALL i306_fetch("F")                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i306_fetch(p_flpme)
   DEFINE p_flpme          LIKE type_file.chr1,    #No.FUN-690010  VARCHAR(1),
          l_abso           LIKE type_file.num10   #No.FUN-690010 INTEGER
 
   CASE p_flpme
      WHEN "N" FETCH NEXT     i306_cs INTO g_vmg.vmg01,g_vmg.vmg02
      WHEN "P" FETCH PREVIOUS i306_cs INTO g_vmg.vmg01,g_vmg.vmg02
      WHEN "F" FETCH FIRST    i306_cs INTO g_vmg.vmg01,g_vmg.vmg02
      WHEN "L" FETCH LAST     i306_cs INTO g_vmg.vmg01,g_vmg.vmg02
      WHEN "/"
         CALL cl_getmsg("fetch",g_lang) RETURNING g_msg
         LET INT_FLAG = 0
 
         PROMPT g_msg CLIPPED,": " FOR l_abso
 
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
 
         FETCH ABSOLUTE l_abso i306_cs INTO g_vmg.vmg01,g_vmg.vmg02
 
   END CASE
 
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vmg.vmg01 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_vmg.* TO NULL           #No.FUN-6B0079 
      RETURN
   ELSE
      CASE p_flpme
         WHEN "F" LET g_curs_index = 1
         WHEN "P" LET g_curs_index = g_curs_index - 1
         WHEN "N" LET g_curs_index = g_curs_index + 1
         WHEN "L" LET g_curs_index = g_row_count
         WHEN "/" LET g_curs_index = l_abso
      END CASE
   
      CALL cl_navigator_setting(g_curs_index,g_row_count)
   END IF
 
SELECT * INTO g_vmg.* FROM vmg_file
WHERE vmg01 = g_vmg.vmg01 AND vmg02 = g_vmg.vmg02
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vmg.vmg01 CLIPPED
 #    CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
      CALL cl_err3("sel","vmg_file",g_vmg.vmg01,g_vmg.vmg02,SQLCA.sqlcode,"","",1) # FUN-660095
      INITIALIZE g_vmg.* TO NULL           #No.FUN-6B0079 
   ELSE
      CALL i306_show()
   END IF
 
END FUNCTION
 
FUNCTION i306_show()
 
   LET g_vmg_t.* = g_vmg.*
   DISPLAY BY NAME g_vmg.vmg01,g_vmg.vmg02,g_vmg.vmg05,g_vmg.vmg06  #FUN-910005 ADD vmg06
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i306_u()
 
   IF g_vmg.vmg01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   LET g_vmg_t.* = g_vmg.*  #No.FUN-660095
   MESSAGE ""
   CALL cl_opmsg("u")
   BEGIN WORK
 
   OPEN i306_cl USING g_vmg.vmg01,g_vmg.vmg02
   IF STATUS THEN
      CALL cl_err("OPEN i306_cl:",STATUS,1)
      CLOSE i306_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i306_cl INTO g_vmg.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vmg.vmg01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i306_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i306_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_vmg.* = g_vmg_t.*
         CALL i306_show()
         CALL cl_err("",9001,0)
         EXIT WHILE
      END IF
 
UPDATE vmg_file SET vmg01 = g_vmg.vmg01, vmg02 = g_vmg.vmg02, vmg05 = g_vmg.vmg05, vmg06 = g_vmg.vmg06  #FUN-B50004 vmg06 add
WHERE vmg01 = g_vmg_t.vmg01 AND vmg02 = g_vmg_t.vmg02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_msg = g_vmg.vmg01 CLIPPED
 #        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
         CALL cl_err3("upd","vmg_file",g_vmg_t.vmg01,g_vmg.vmg02,SQLCA.sqlcode,"","",1) # FUN-660095
         CONTINUE WHILE
      ELSE 
         LET g_vmg_t.* = g_vmg.*       # 保存上筆資料
         SELECT vmg01 INTO g_vmg.vmg01 FROM vmg_file
          WHERE vmg01 = g_vmg.vmg01
            AND vmg02 = g_vmg.vmg02
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i306_cl
   COMMIT WORK
END FUNCTION
 
