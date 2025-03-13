# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi329.4gl
# Descriptions...: APS工模具主檔維護作業
# Date & Author..: NO.FUN-880102 08/09/22 BY Duke
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0076 09/10/26 By lilingyu 改寫Sql的標準寫法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vnj   RECORD                                   
                vnj01         LIKE vnj_file.vnj01,   
                vnj02         LIKE vnj_file.vnj02,   
                vnj03         LIKE vnj_file.vnj03   
                END RECORD,
    g_vnj_t RECORD
                vnj01         LIKE vnj_file.vnj01,
                vnj02         LIKE vnj_file.vnj02,  
                vnj03         LIKE vnj_file.vnj03  
                END RECORD,
    g_wc,g_sql          STRING  
 
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10     
DEFINE   g_msg          LIKE ze_file.ze03     
DEFINE   g_row_count    LIKE type_file.num10  
DEFINE   g_curs_index   LIKE type_file.num10  
DEFINE   g_flag         LIKE type_file.chr1   
 
MAIN
   DEFINE l_time        LIKE type_file.chr8   
   DEFINE p_row,p_col   LIKE type_file.num5   
 
   OPTIONS					#改變一些系統預設值
       					
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,l_time,1) RETURNING l_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
 
  # LET g_forupd_sql = "SELECT vnj01,vnj02,vnj03 FROM vnj_file WHERE rowi= ? FOR UPDATE"   #FUN-9A0076
   LET g_forupd_sql = "SELECT vnj01,vnj02,vnj03 FROM vnj_file WHERE vnj01 = ? FOR UPDATE"  #FUN-9A0076
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i329_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
   LET p_row = 2 LET p_col = 3 
 
   OPEN WINDOW i329_w AT p_row,p_col
     WITH FORM "aps/42f/apsi329"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   #FUN-680048
   LET g_vnj.vnj01 = ARG_VAL(1)
 
   DISPLAY 'g_vnj.vnj01=',g_vnj.vnj01 
 
   IF g_vnj.vnj01 IS NOT NULL AND g_vnj.vnj01 != ' ' THEN
      LET g_flag = 'Y'
      CALL i329_q()
   ELSE
      LET g_flag = 'N'
   END IF
 
   WHILE TRUE
      LET g_action_choice=""
      CALL i329_menu()
      IF g_action_choice="exit" THEN 
         EXIT WHILE 
      END IF
   END WHILE
 
   CLOSE WINDOW i329_w
   CALL cl_used(g_prog,l_time,2) RETURNING l_time 
 
END MAIN
 
FUNCTION i329_cs()
 
   CLEAR FORM
 
   IF g_flag = 'Y' THEN          
      LET g_wc = " vnj01='",g_vnj.vnj01,"' "
   ELSE
   INITIALIZE g_vnj.* TO NULL    
      CONSTRUCT BY NAME g_wc ON vnj01
                   
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
 
         #FUN-880102  add  開窗查詢工模具編號
   ON ACTION controlp
   CASE
      WHEN INFIELD(vnj01)
           CALL cl_init_qry_var()
           LET g_qryparam.form     = "q_vnj01"
           LET g_qryparam.default1 = g_vnj.vnj01
           CALL cl_create_qry() RETURNING g_vnj.vnj01
           DISPLAY BY NAME g_vnj.vnj01
           NEXT FIELD vnj01
   END CASE    
      
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
   LET g_sql = "SELECT vnj01 FROM vnj_file ",   # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY vnj01"
   PREPARE i329_prepare FROM g_sql                     # RUNTIME 編譯
   DECLARE i329_cs                                     # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i329_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM vnj_file WHERE ",g_wc CLIPPED
   PREPARE i329_precount FROM g_sql
   DECLARE i329_count CURSOR FOR i329_precount
 
END FUNCTION
 
FUNCTION i329_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i329_q()
         END IF
 
      ON ACTION next 
         CALL i329_fetch('N') 
      ON ACTION previous 
         CALL i329_fetch('P')
      ON ACTION modify 
         CALL i329_u()
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i329_fetch('/')
      ON ACTION first
         CALL i329_fetch('F')
      ON ACTION last
         CALL i329_fetch('L')
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
 
   CLOSE i329_cs
 
END FUNCTION
 
FUNCTION i329_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1   # NO.FUN-690010       VARCHAR(1) 
 
   #FUN-860060
   DISPLAY BY NAME g_vnj.vnj01,g_vnj.vnj02,g_vnj.vnj03  
 
   INPUT BY NAME g_vnj.vnj01,g_vnj.vnj02,g_vnj.vnj03 WITHOUT DEFAULTS 
 
      #FUN-880102
      AFTER FIELD vnj02
         IF NOT cl_null(g_vnj.vnj03) and g_vnj.vnj02>g_vnj.vnj03 THEN
            CALL cl_err('','abm-828',0)
            NEXT FIELD vnj02
         END IF
 
     AFTER FIELD vnj03
        IF NOT cl_null(g_vnj.vnj03) and g_vnj.vnj02>g_vnj.vnj03 THEN
           CALL cl_err('','abm-828',0)
           NEXT FIELD vnj03
        END IF
 
 
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
                   
FUNCTION i329_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt 
 
   CALL i329_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_vnj.* TO NULL
      RETURN
   END IF
 
   OPEN i329_count
   FETCH i329_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
 
   OPEN i329_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vnj.vnj01,SQLCA.sqlcode,0)
      INITIALIZE g_vnj.* TO NULL
   ELSE
      CALL i329_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i329_fetch(p_flpme)
   DEFINE
       p_flpme     LIKE type_file.chr1,   # NO.FUN-690010        VARCHAR(1),
       l_abso      LIKE type_file.num10   # NO.FUN-690010    INTEGER
 
   CASE p_flpme
      WHEN 'N' FETCH NEXT     i329_cs INTO g_vnj.vnj01
      WHEN 'P' FETCH PREVIOUS i329_cs INTO g_vnj.vnj01
      WHEN 'F' FETCH FIRST    i329_cs INTO g_vnj.vnj01
      WHEN 'L' FETCH LAST     i329_cs INTO g_vnj.vnj01
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
          FETCH ABSOLUTE l_abso i329_cs INTO g_vnj.vnj01
   END CASE
 
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vnj.vnj01 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_vnj.* TO NULL          
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
 
SELECT vnj01,vnj02,vnj03 INTO g_vnj.* FROM vnj_file            
WHERE vnj01 = g_vnj.vnj01
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vnj.vnj01 CLIPPED
       CALL cl_err3("sel","vnj_file",g_vnj.vnj01,"",SQLCA.sqlcode,"","",1) # FUN-660095
       INITIALIZE g_vnj.* TO NULL          #No.FUN-6A0163
   ELSE
      CALL i329_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i329_show()
 
   LET g_vnj_t.* = g_vnj.*
   DISPLAY BY NAME g_vnj.vnj01,g_vnj.vnj02,g_vnj.vnj03
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i329_u()
 
   IF (g_vnj.vnj01 IS NULL)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   LET g_vnj_t.*=g_vnj.*  
 
   OPEN i329_cl USING g_vnj.vnj01
   IF STATUS THEN
      CALL cl_err("OPEN i329_cl:", STATUS, 1)
      CLOSE i329_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i329_cl INTO g_vnj.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vnj.vnj01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i329_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i329_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_vnj.* = g_vnj_t.*
         CALL i329_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      #FUN-880102 生效日不得大於失效日
      IF (NOT cl_null(g_vnj.vnj02)) and (NOT cl_null(g_vnj.vnj03)) and
         (g_vnj.vnj02 > g_vnj.vnj03) THEN
         CALL cl_err('','abm-828',1)
         RETURN
      END IF
    
      UPDATE vnj_file SET  vnj02 = g_vnj.vnj02, vnj03 = g_vnj.vnj03
       WHERE vnj01 = g_vnj_t.vnj01                # COLAUTH?i
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         LET g_msg = g_vnj.vnj01 CLIPPED
          CALL cl_err3("upd","vnj_file",g_vnj_t.vnj01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         CONTINUE WHILE
      ELSE 
         LET g_vnj_t.* = g_vnj.*# 保存上筆資料
         SELECT vnj01 INTO g_vnj.vnj01 FROM vnj_file
          WHERE vnj01 = g_vnj.vnj01
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i329_cl
   COMMIT WORK
END FUNCTION
 
