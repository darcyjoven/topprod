# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi305.4gl
# Descriptions...: 倉庫資料維護作業
# Date & Author..: NO.FUN-850114 08/01/08 BY yiting
# Modify.........: No.FUN-860060 08/06/23 BY DUKE
# Modify.........: No.FUN-910005 09/01/05 BY DUKE 增加是否受供給法則限制, 0;否 1:是
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0082 09/10/26 By wujie 5.2转SQL标准语法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmf   RECORD                                   #FUN-720043
                vmf01         LIKE vmf_file.vmf01,   #FUN-850114
                #vmf04         LIKE vmf_file.vmf04,   #FUN-860060
                #vmf05         LIKE vmf_file.vmf05,   #FUN-860060
                vmf06          LIKE vmf_file.vmf06,    #FUN-860060
                vmf07          LIKE vmf_file.vmf07    #FUN-910005 ADD
                END RECORD,
    g_vmf_t RECORD
                vmf01         LIKE vmf_file.vmf01,
                #vmf04         LIKE vmf_file.vmf04,  #FUN-860060
                #vmf05         LIKE vmf_file.vmf05,  #FUN-860060
                vmf06          LIKE vmf_file.vmf06,   #FUN-860060
                vmf07          LIKE vmf_file.vmf07   #FUN-910005 ADD
                END RECORD,
    g_wc,g_sql          STRING  
 
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10  # NO.FUN-690010 INTEGER   
DEFINE   g_msg          LIKE ze_file.ze03     # NO.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10  # NO.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10  # NO.FUN-690010 INTEGER
DEFINE   g_flag         LIKE type_file.chr1   #FUN-680048  # NO.FUN-690010 VARCHAR(1)
 
MAIN
   DEFINE l_time        LIKE type_file.chr8   # NO.FUN-690010 VARCHAR(8) 	#計算被使用時間
   DEFINE p_row,p_col   LIKE type_file.num5   # NO.FUN-690010 SMALLINT
 
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
 
#  LET g_forupd_sql = "SELECT vmf01,vmf06,vmf07 FROM vmf_file WHERE rowid = ? FOR UPDATE"   #FUN-910005 ADD vmf07
   LET g_forupd_sql = "SELECT vmf01,vmf06,vmf07 FROM vmf_file WHERE vmf01 = ? FOR UPDATE"   #No.FUN-9A0082
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i305_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
   LET p_row = 2 LET p_col = 3 
 
   OPEN WINDOW i305_w AT p_row,p_col
     WITH FORM "aps/42f/apsi305"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   #FUN-680048
   LET g_vmf.vmf01 = ARG_VAL(1)
   IF g_vmf.vmf01 IS NOT NULL AND g_vmf.vmf01 != ' ' THEN
      LET g_flag = 'Y'
      CALL i305_q()
   ELSE
      LET g_flag = 'N'
   END IF
 
   WHILE TRUE
      LET g_action_choice=""
      CALL i305_menu()
      IF g_action_choice="exit" THEN 
         EXIT WHILE 
      END IF
   END WHILE
   #FUN-680048
 
   CLOSE WINDOW i305_w
   CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
 
END MAIN
 
FUNCTION i305_cs()
 
   CLEAR FORM
 
   IF g_flag = 'Y' THEN          #FUN-680048
      LET g_wc = " vmf01='",g_vmf.vmf01,"'"
   ELSE
   INITIALIZE g_vmf.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON vmf01,vmf06,vmf07   #FUN-910005 ADD
                   
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
 
   LET g_sql = "SELECT vmf01 FROM vmf_file ",   # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY vmf01"
   PREPARE i305_prepare FROM g_sql                     # RUNTIME 編譯
   DECLARE i305_cs                                     # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i305_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM vmf_file WHERE ",g_wc CLIPPED
   PREPARE i305_precount FROM g_sql
   DECLARE i305_count CURSOR FOR i305_precount
 
END FUNCTION
 
FUNCTION i305_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i305_q()
         END IF
 
      ON ACTION next 
         CALL i305_fetch('N') 
      ON ACTION previous 
         CALL i305_fetch('P')
      ON ACTION modify 
         CALL i305_u()
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i305_fetch('/')
      ON ACTION first
         CALL i305_fetch('F')
      ON ACTION last
         CALL i305_fetch('L')
      ON ACTION CONTROLG    
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.FUN-6A0163-------add--------str----
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_vmf.vmf01 IS NOT NULL THEN
                LET g_doc.column1 = "vmf01"
                LET g_doc.value1 = g_vmf.vmf01
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
 
   CLOSE i305_cs
 
END FUNCTION
 
FUNCTION i305_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1   # NO.FUN-690010       VARCHAR(1) 
 
   DISPLAY BY NAME g_vmf.vmf01,g_vmf.vmf06 ,g_vmf.vmf07   #FUN-910005 ADD 
 
   INPUT BY NAME g_vmf.vmf01,g_vmf.vmf06,g_vmf.vmf07 WITHOUT DEFAULTS  #FUN-910005 ADD
 
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
                   
FUNCTION i305_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt 
 
   CALL i305_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_vmf.* TO NULL
      RETURN
   END IF
 
   OPEN i305_count
   FETCH i305_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
 
   OPEN i305_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vmf.vmf01,SQLCA.sqlcode,0)
      INITIALIZE g_vmf.* TO NULL
   ELSE
      CALL i305_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i305_fetch(p_flpme)
   DEFINE
       p_flpme     LIKE type_file.chr1,   # NO.FUN-690010        VARCHAR(1),
       l_abso      LIKE type_file.num10   # NO.FUN-690010    INTEGER
 
   CASE p_flpme
      WHEN 'N' FETCH NEXT     i305_cs INTO g_vmf.vmf01
      WHEN 'P' FETCH PREVIOUS i305_cs INTO g_vmf.vmf01
      WHEN 'F' FETCH FIRST    i305_cs INTO g_vmf.vmf01
      WHEN 'L' FETCH LAST     i305_cs INTO g_vmf.vmf01
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
          FETCH ABSOLUTE l_abso i305_cs INTO g_vmf.vmf01
   END CASE
 
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vmf.vmf01 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_vmf.* TO NULL          #No.FUN-6A0163
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
 
   SELECT vmf01,vmf06,vmf07 INTO g_vmf.* FROM vmf_file            # 重讀DB,因TEMP有不被更新特性  #FUN-910005 ADD
    WHERE vmf01 = g_vmf.vmf01
   IF SQLCA.sqlcode THEN
      LET g_msg = g_vmf.vmf01 CLIPPED
 #     CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
       CALL cl_err3("sel","vmf_file",g_vmf.vmf01,"",SQLCA.sqlcode,"","",1) # FUN-660095
       INITIALIZE g_vmf.* TO NULL          #No.FUN-6A0163
   ELSE
      CALL i305_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i305_show()
 
   LET g_vmf_t.* = g_vmf.*
   DISPLAY BY NAME g_vmf.vmf01,g_vmf.vmf06,g_vmf.vmf07  #FUN-910005 ADD
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i305_u()
 
   IF g_vmf.vmf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   LET g_vmf_t.*=g_vmf.*  #No.FUN-660095
 
   OPEN i305_cl USING g_vmf.vmf01
   IF STATUS THEN
      CALL cl_err("OPEN i305_cl:", STATUS, 1)
      CLOSE i305_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i305_cl INTO g_vmf.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vmf.vmf01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i305_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i305_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_vmf.* = g_vmf_t.*
         CALL i305_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE vmf_file SET vmf01 = g_vmf.vmf01, vmf06 = g_vmf.vmf06,
                          vmf07 = g_vmf.vmf07  #FUN-910005 ADD
       WHERE vmf01 = g_vmf_t.vmf01                # COLAUTH?
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         LET g_msg = g_vmf.vmf01 CLIPPED
 #        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
          CALL cl_err3("upd","vmf_file",g_vmf_t.vmf01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         CONTINUE WHILE
      ELSE 
         LET g_vmf_t.* = g_vmf.*# 保存上筆資料
         SELECT vmf01 INTO g_vmf.vmf01 FROM vmf_file
          WHERE vmf01 = g_vmf.vmf01
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i305_cl
   COMMIT WORK
END FUNCTION
 
