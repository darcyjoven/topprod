# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi333.4gl
# Descriptions...: APS工模具產能型態維護作業
# Date & Author..: NO.FUN-880102 08/09/25 BY Duke
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0082 09/10/26 By wujie 5.2转SQL标准语法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vno   RECORD                                   
                vno01         LIKE vno_file.vno01,   
                vno02         LIKE vno_file.vno02   
                END RECORD,
    g_vno_t RECORD
                vno01         LIKE vno_file.vno01,
                vno02         LIKE vno_file.vno02  
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
       					
       INPUT NO WRAP
   DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,l_time,1) RETURNING l_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
 
#  LET g_forupd_sql = "SELECT vno01,vno02 FROM vno_file WHERE rowid = ? FOR UPDATE"
   LET g_forupd_sql = "SELECT vno01,vno02 FROM vno_file WHERE vno01 = ? FOR UPDATE"    #No.FUN-9A0082
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i333_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
   LET p_row = 2 LET p_col = 3 
 
   OPEN WINDOW i333_w AT p_row,p_col
     WITH FORM "aps/42f/apsi333"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   #FUN-680048
   LET g_vno.vno01 = ARG_VAL(1)
 
   DISPLAY 'g_vno.vno01=',g_vno.vno01 
 
   IF g_vno.vno01 IS NOT NULL AND g_vno.vno01 != ' ' THEN
      LET g_flag = 'Y'
      CALL i333_q()
   ELSE
      LET g_flag = 'N'
   END IF
 
   WHILE TRUE
      LET g_action_choice=""
      CALL i333_menu()
      IF g_action_choice="exit" THEN 
         EXIT WHILE 
      END IF
   END WHILE
 
   CLOSE WINDOW i333_w
   CALL cl_used(g_prog,l_time,2) RETURNING l_time 
 
END MAIN
 
FUNCTION i333_cs()
 
   CLEAR FORM
 
   IF g_flag = 'Y' THEN          
      LET g_wc = " vno01='",g_vno.vno01,"' "
   ELSE
   INITIALIZE g_vno.* TO NULL    
      CONSTRUCT BY NAME g_wc ON vno01
                   
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
      WHEN INFIELD(vno01)
           CALL cl_init_qry_var()
           LET g_qryparam.form     = "q_vno01"
           LET g_qryparam.default1 = g_vno.vno01
           CALL cl_create_qry() RETURNING g_vno.vno01
           DISPLAY BY NAME g_vno.vno01
           NEXT FIELD vno01
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
   LET g_sql = "SELECT vno01 FROM vno_file ",   # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY vno01"
   PREPARE i333_prepare FROM g_sql                     # RUNTIME 編譯
   DECLARE i333_cs                                     # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i333_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM vno_file WHERE ",g_wc CLIPPED
   PREPARE i333_precount FROM g_sql
   DECLARE i333_count CURSOR FOR i333_precount
 
END FUNCTION
 
FUNCTION i333_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i333_q()
         END IF
 
      ON ACTION next 
         CALL i333_fetch('N') 
      ON ACTION previous 
         CALL i333_fetch('P')
      ON ACTION modify 
         CALL i333_u()
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i333_fetch('/')
      ON ACTION first
         CALL i333_fetch('F')
      ON ACTION last
         CALL i333_fetch('L')
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
 
   CLOSE i333_cs
 
END FUNCTION
 
FUNCTION i333_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1   # NO.FUN-690010       VARCHAR(1) 
 
   #FUN-860060
   DISPLAY BY NAME g_vno.vno01,g_vno.vno02  
 
   INPUT BY NAME g_vno.vno01,g_vno.vno02 WITHOUT DEFAULTS 
 
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
                   
FUNCTION i333_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt 
 
   CALL i333_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_vno.* TO NULL
      RETURN
   END IF
 
   OPEN i333_count
   FETCH i333_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
 
   OPEN i333_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vno.vno01,SQLCA.sqlcode,0)
      INITIALIZE g_vno.* TO NULL
   ELSE
      CALL i333_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i333_fetch(p_flpme)
   DEFINE
       p_flpme     LIKE type_file.chr1,   # NO.FUN-690010        VARCHAR(1),
       l_abso      LIKE type_file.num10   # NO.FUN-690010    INTEGER
 
   CASE p_flpme
      WHEN 'N' FETCH NEXT     i333_cs INTO g_vno.vno01
      WHEN 'P' FETCH PREVIOUS i333_cs INTO g_vno.vno01
      WHEN 'F' FETCH FIRST    i333_cs INTO g_vno.vno01
      WHEN 'L' FETCH LAST     i333_cs INTO g_vno.vno01
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
          FETCH ABSOLUTE l_abso i333_cs INTO g_vno.vno01
   END CASE
 
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vno.vno01 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_vno.* TO NULL          
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
 
SELECT vno01,vno02 INTO g_vno.* FROM vno_file            
WHERE vno01 = g_vno.vno01
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vno.vno01 CLIPPED
       CALL cl_err3("sel","vno_file",g_vno.vno01,"",SQLCA.sqlcode,"","",1) # FUN-660095
       INITIALIZE g_vno.* TO NULL          #No.FUN-6A0163
   ELSE
      CALL i333_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i333_show()
 
   LET g_vno_t.* = g_vno.*
   DISPLAY BY NAME g_vno.vno01,g_vno.vno02
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i333_u()
 
   IF (g_vno.vno01 IS NULL)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   LET g_vno_t.*=g_vno.*  
 
   OPEN i333_cl USING g_vno.vno01
   IF STATUS THEN
      CALL cl_err("OPEN i333_cl:", STATUS, 1)
      CLOSE i333_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i333_cl INTO g_vno.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vno.vno01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i333_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i333_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_vno.* = g_vno_t.*
         CALL i333_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      UPDATE vno_file SET  vno02 = g_vno.vno02
       WHERE vno01 = g_vno_t.vno01                # COLAUTH?
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         LET g_msg = g_vno.vno01 CLIPPED
          CALL cl_err3("upd","vno_file",g_vno_t.vno01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         CONTINUE WHILE
      ELSE 
         LET g_vno_t.* = g_vno.*# 保存上筆資料
         SELECT vno01 INTO g_vno.vno01 FROM vno_file
          WHERE vno01 = g_vno.vno01
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i333_cl
   COMMIT WORK
END FUNCTION
 
