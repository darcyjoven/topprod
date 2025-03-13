# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsi325.4gl
# Descriptions...: 倉庫資料維護作業
# Date & Author..: NO.FUN-860060 08/06/24 BY Duke
# Modify.........: NO.TQC-940088 09/04/16 BY destiny 1.select rowi 時,where缺少2個KEY
#                                                    2.select rowi時增加兩個KEY以便在msv內使用 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0076 09/10/26 By lilingyu 改寫Sql標準寫法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmq   RECORD                                   
                vmq01         LIKE vmq_file.vmq01,   
                vmq02         LIKE vmq_file.vmq02,   
                vmq03         LIKE vmq_file.vmq03,   
                vmq11          LIKE vmq_file.vmq11    
                END RECORD,
    g_vmq_t RECORD
                vmq01         LIKE vmq_file.vmq01,
                vmq02         LIKE vmq_file.vmq02,  
                vmq03         LIKE vmq_file.vmq03,  
                vmq11          LIKE vmq_file.vmq11   
                END RECORD,
    g_wc,g_sql          STRING  
 
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10     
DEFINE   g_msg          LIKE ze_file.ze03     
DEFINE   g_row_count    LIKE type_file.num10  
DEFINE   g_curs_index   LIKE type_file.num10  
DEFINE   g_flag         LIKE type_file.chr1   
 
MAIN
   OPTIONS					#改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
 
   LET g_forupd_sql = "SELECT vmq01,vmq02,vmq03,vmq11 FROM vmq_file WHERE vmq01 = ? AND vmq02=? AND vmq03=? FOR UPDATE"  #FUN-9A0076
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i325_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
   OPEN WINDOW i325_w WITH FORM "aps/42f/apsi325"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET g_vmq.vmq01 = ARG_VAL(1)
   LET g_vmq.vmq02 = ARG_VAL(2)
   LET g_vmq.vmq03 = ARG_VAL(3)
 
   DISPLAY 'G_VMQ.VMQ01=',g_vmq.vmq01 
 
   IF g_vmq.vmq01 IS NOT NULL AND g_vmq.vmq01 != ' ' THEN
      LET g_flag = 'Y'
      CALL i325_q()
   ELSE
      LET g_flag = 'N'
   END IF
 
      LET g_action_choice=""
      CALL i325_menu()
 
   CLOSE WINDOW i325_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i325_cs()
 
   CLEAR FORM
 
   IF g_flag = 'Y' THEN          
      LET g_wc = " vmq01='",g_vmq.vmq01,"' and vmq02='",g_vmq.vmq02,"' and vmq03='",g_vmq.vmq03,"' "
   ELSE
   INITIALIZE g_vmq.* TO NULL    
      CONSTRUCT BY NAME g_wc ON vmq01,vmq02,vmq03
                   
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
      
         ON ACTION qbe_select
           CALL cl_qbe_select() 
         ON ACTION qbe_save
       	   CALL cl_qbe_save()
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF
  #LET g_sql = "SELECT vmq01 FROM vmq_file ",   # 組合出 SQL 指令                        #No.TQC-940088
   LET g_sql = "SELECT vmq01,vmq02,vmq03 FROM vmq_file ",   # 組合出 SQL 指令            #No.TQC-940088
               " WHERE ",g_wc CLIPPED, " ORDER BY vmq01"
   PREPARE i325_prepare FROM g_sql                     # RUNTIME 編譯
   DECLARE i325_cs                                     # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i325_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM vmq_file WHERE ",g_wc CLIPPED
   PREPARE i325_precount FROM g_sql
   DECLARE i325_count CURSOR FOR i325_precount
 
END FUNCTION
 
FUNCTION i325_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i325_q()
         END IF
 
      ON ACTION next 
         CALL i325_fetch('N') 
      ON ACTION previous 
         CALL i325_fetch('P')
      ON ACTION modify 
         CALL i325_u()
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i325_fetch('/')
      ON ACTION first
         CALL i325_fetch('F')
      ON ACTION last
         CALL i325_fetch('L')
      ON ACTION CONTROLG    
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
         LET g_action_choice = "exit"
         CONTINUE MENU
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
   END MENU
 
   CLOSE i325_cs
 
END FUNCTION
 
FUNCTION i325_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1   # NO.FUN-690010       VARCHAR(1) 
 
   #FUN-860060
   DISPLAY BY NAME g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03,g_vmq.vmq11  
 
   INPUT BY NAME g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03,g_vmq.vmq11 WITHOUT DEFAULTS 
 
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
                   
FUNCTION i325_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt 
 
   CALL i325_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_vmq.* TO NULL
      RETURN
   END IF
 
   OPEN i325_count
   FETCH i325_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
 
   OPEN i325_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vmq.vmq01,SQLCA.sqlcode,0)
      INITIALIZE g_vmq.* TO NULL
   ELSE
      CALL i325_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i325_fetch(p_flpme)
   DEFINE
       p_flpme     LIKE type_file.chr1,   # NO.FUN-690010        VARCHAR(1),
       l_abso      LIKE type_file.num10   # NO.FUN-690010    INTEGER
 
   CASE p_flpme
      WHEN 'N' FETCH NEXT     i325_cs INTO g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03
      WHEN 'P' FETCH PREVIOUS i325_cs INTO g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03
      WHEN 'F' FETCH FIRST    i325_cs INTO g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03
      WHEN 'L' FETCH LAST     i325_cs INTO g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03
      WHEN '/'
          CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
          LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED,': ' FOR l_abso
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
          FETCH ABSOLUTE l_abso i325_cs INTO g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03
   END CASE
 
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vmq.vmq01 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_vmq.* TO NULL          
      RETURN
   ELSE
      CASE p_flpme
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
   
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
SELECT vmq01,vmq02,vmq03,vmq11 INTO g_vmq.* FROM vmq_file            
WHERE vmq01 = g_vmq.vmq01 AND vmq02 = g_vmq.vmq02 AND vmq03 = g_vmq.vmq03
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vmq.vmq01 CLIPPED
       CALL cl_err3("sel","vmq_file",g_vmq.vmq01,"",SQLCA.sqlcode,"","",1) # FUN-660095
       INITIALIZE g_vmq.* TO NULL          #No.FUN-6A0163
   ELSE
      CALL i325_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i325_show()
 
   LET g_vmq_t.* = g_vmq.*
   DISPLAY BY NAME g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03,g_vmq.vmq11
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i325_u()
 
   IF (g_vmq.vmq01 IS NULL) or (g_vmq.vmq02 is null) or (g_vmq.vmq03 is null) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   LET g_vmq_t.*=g_vmq.*  
 
   OPEN i325_cl USING g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03
   IF STATUS THEN
      CALL cl_err("OPEN i325_cl:", STATUS, 1)
      CLOSE i325_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i325_cl INTO g_vmq.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vmq.vmq01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i325_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i325_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_vmq.* = g_vmq_t.*
         CALL i325_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE vmq_file SET vmq01 = g_vmq.vmq01, vmq02 = g_vmq.vmq02, vmq03 = g_vmq.vmq03, vmq11 = g_vmq.vmq11
       WHERE vmq01 = g_vmq_t.vmq01 AND vmq02 = g_vmq_t.vmq02 AND vmq03 = g_vmq_t.vmq03               # COLAUTH?
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         LET g_msg = g_vmq.vmq01 CLIPPED
          CALL cl_err3("upd","vmq_file",g_vmq_t.vmq01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         CONTINUE WHILE
      ELSE 
         LET g_vmq_t.* = g_vmq.*# 保存上筆資料
         SELECT vmq01,vmq02,vmq03 INTO g_vmq.vmq01,g_vmq.vmq02,g_vmq.vmq03 FROM vmq_file
          WHERE vmq01 = g_vmq.vmq01       
            AND vmq02 = g_vmq.vmq02                                             #No.TQC-940088        
            AND vmq03 = g_vmq.vmq03                                             #No.TQC-940088        
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i325_cl
   COMMIT WORK
END FUNCTION
 
