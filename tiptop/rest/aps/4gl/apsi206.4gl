# Prog. Version..: '5.10.05-08.12.18(00000)'     #
# Pattern name...: apsi206.4gl
# Descriptions...: 倉庫資料維護作業
# Date & Author..: 04/11/10 By Nicola
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680048 06/08/15 By Joe 修改程式由aimi200 & aimi201串過來
# Modify.........: No:FUN-6A0163 06/11/07 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-720043 07/03/20 By Mandy APS相關修正
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_aps_imd   RECORD                                   #FUN-720043
                wh_id            LIKE aps_imd.wh_id,
                immove           LIKE aps_imd.immove,
                is_main          LIKE aps_imd.is_main
                END RECORD,
    g_aps_imd_t RECORD
                wh_id            LIKE aps_imd.wh_id,
                immove           LIKE aps_imd.immove,
                is_main          LIKE aps_imd.is_main
                END RECORD,
    g_aps_imd_rowid    LIKE type_file.chr18,  # NO.FUN-690010 INT,		#ROWID
    g_wc,g_sql          STRING  

DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt          LIKE type_file.num10  # NO.FUN-690010 INTEGER   
DEFINE   g_msg          LIKE ze_file.ze03     # NO.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10  # NO.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10  # NO.FUN-690010 INTEGER
DEFINE   g_flag         LIKE type_file.chr1   #FUN-680048  # NO.FUN-690010 VARCHAR(1)

MAIN
   DEFINE l_time        LIKE type_file.chr8   # NO.FUN-690010 VARCHAR(8) 	#計算被使用時間
   DEFINE p_row,p_col   LIKE type_file.num5   # NO.FUN-690010 SMALLINT

   OPTIONS					#改變一些系統預設值
       FORM LINE     FIRST + 2,		#畫面開始的位置
       MESSAGE LINE  LAST,			#訊息顯示的位置
       PROMPT LINE   LAST,			#提示訊息的位置
       INPUT NO WRAP				#輸入的方式: 不打轉
       					
   DEFER INTERRUPT				#擷取中斷鍵,由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,l_time,1) RETURNING l_time  #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818

   LET g_forupd_sql = "SELECT * FROM aps_imd WHERE ROWID = ? FOR UPDATE NOWAIT"
   DECLARE i206_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR

   LET p_row = 2 LET p_col = 3 

   OPEN WINDOW i206_w AT p_row,p_col
     WITH FORM "aps/42f/apsi206"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
   
   CALL cl_ui_init()

   #FUN-680048
   LET g_aps_imd.wh_id = ARG_VAL(1)
   IF g_aps_imd.wh_id IS NOT NULL AND g_aps_imd.wh_id != ' ' THEN
      LET g_flag = 'Y'
      CALL i206_q()
   ELSE
      LET g_flag = 'N'
   END IF

   WHILE TRUE
      LET g_action_choice=""
      CALL i206_menu()
      IF g_action_choice="exit" THEN 
         EXIT WHILE 
      END IF
   END WHILE
   #FUN-680048

   CLOSE WINDOW i206_w
   CALL cl_used(g_prog,l_time,2) RETURNING l_time #No:MOD-580088  HCN 20050818

END MAIN

FUNCTION i206_cs()

   CLEAR FORM

   IF g_flag = 'Y' THEN          #FUN-680048
      LET g_wc = " wh_id='",g_aps_imd.wh_id,"'"
   ELSE
   INITIALIZE g_aps_imd.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON wh_id,immove,is_main
                   
                 #No:FUN-580031 --start--     HCN
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
                 #No:FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
      
           	#No:FUN-580031 --start--     HCN
                    ON ACTION qbe_select
            	   CALL cl_qbe_select() 
                    ON ACTION qbe_save
           	   CALL cl_qbe_save()
           	#No:FUN-580031 --end--       HCN
      END CONSTRUCT
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT ROWID,wh_id FROM aps_imd ",   # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY wh_id"
   PREPARE i206_prepare FROM g_sql                     # RUNTIME 編譯
   DECLARE i206_cs                                     # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i206_prepare

   LET g_sql= "SELECT COUNT(*) FROM aps_imd WHERE ",g_wc CLIPPED
   PREPARE i206_precount FROM g_sql
   DECLARE i206_count CURSOR FOR i206_precount

END FUNCTION

FUNCTION i206_menu()

   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i206_q()
         END IF
      ON ACTION next 
         CALL i206_fetch('N') 
      ON ACTION previous 
         CALL i206_fetch('P')
      ON ACTION modify 
         CALL i206_u()
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i206_fetch('/')
      ON ACTION first
         CALL i206_fetch('F')
      ON ACTION last
         CALL i206_fetch('L')
      ON ACTION CONTROLG    
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      #No:FUN-6A0163-------add--------str----
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_aps_imd.wh_id IS NOT NULL THEN
                LET g_doc.column1 = "wh_id"
                LET g_doc.value1 = g_aps_imd.wh_id
                CALL cl_doc()
             END IF
         END IF
      #No:FUN-6A0163-------add--------end----

         LET g_action_choice = "exit"
         CONTINUE MENU

      -- for Windows close event trapped
      COMMAND KEY(INTERRUPT)
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
   END MENU

   CLOSE i206_cs

END FUNCTION

FUNCTION i206_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1   # NO.FUN-690010       VARCHAR(1) 

   DISPLAY BY NAME g_aps_imd.wh_id,g_aps_imd.immove,g_aps_imd.is_main  

   INPUT BY NAME g_aps_imd.wh_id,g_aps_imd.immove,g_aps_imd.is_main WITHOUT DEFAULTS 

      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION CONTROLZ
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
                   
FUNCTION i206_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt 

   CALL i206_cs()                          # 宣告 SCROLL CURSOR

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_aps_imd.* TO NULL
      RETURN
   END IF

   OPEN i206_count
   FETCH i206_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  

   OPEN i206_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aps_imd.wh_id,SQLCA.sqlcode,0)
      INITIALIZE g_aps_imd.* TO NULL
   ELSE
      CALL i206_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION i206_fetch(p_flpme)
   DEFINE
       p_flpme     LIKE type_file.chr1,   # NO.FUN-690010        VARCHAR(1),
       l_abso      LIKE type_file.num10   # NO.FUN-690010    INTEGER

   CASE p_flpme
      WHEN 'N' FETCH NEXT     i206_cs INTO g_aps_imd_rowid,g_aps_imd.wh_id
      WHEN 'P' FETCH PREVIOUS i206_cs INTO g_aps_imd_rowid,g_aps_imd.wh_id
      WHEN 'F' FETCH FIRST    i206_cs INTO g_aps_imd_rowid,g_aps_imd.wh_id
      WHEN 'L' FETCH LAST     i206_cs INTO g_aps_imd_rowid,g_aps_imd.wh_id
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
          FETCH ABSOLUTE l_abso i206_cs INTO g_aps_imd_rowid,g_aps_imd.wh_id
   END CASE

   IF SQLCA.sqlcode THEN
      LET g_msg = g_aps_imd.wh_id CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_aps_imd.* TO NULL          #No.FUN-6A0163
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

   SELECT * INTO g_aps_imd.* FROM aps_imd            # 重讀DB,因TEMP有不被更新特性
    WHERE ROWID = g_aps_imd_rowid
   IF SQLCA.sqlcode THEN
      LET g_msg = g_aps_imd.wh_id CLIPPED
 #     CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
       CALL cl_err3("sel","aps_imd",g_aps_imd.wh_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
       INITIALIZE g_aps_imd.* TO NULL          #No.FUN-6A0163
   ELSE
      CALL i206_show()                      # 重新顯示
   END IF

END FUNCTION

FUNCTION i206_show()

   LET g_aps_imd_t.* = g_aps_imd.*
   DISPLAY BY NAME g_aps_imd.* 

   CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i206_u()

   IF g_aps_imd.wh_id IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   LET g_aps_imd_t.*=g_aps_imd.*  #No.FUN-660095

   OPEN i206_cl USING g_aps_imd_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i206_cl:", STATUS, 1)
      CLOSE i206_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i206_cl INTO g_aps_imd.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aps_imd.wh_id,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL i206_show()                          # 顯示最新資料

   WHILE TRUE
      CALL i206_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_aps_imd.* = g_aps_imd_t.*
         CALL i206_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE aps_imd SET aps_imd.* = g_aps_imd.*    # 更新DB
       WHERE ROWID = g_aps_imd_rowid                # COLAUTH?
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         LET g_msg = g_aps_imd.wh_id CLIPPED
 #        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
          CALL cl_err3("upd","aps_imd",g_aps_imd_t.wh_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
         CONTINUE WHILE
      ELSE 
         LET g_aps_imd_t.* = g_aps_imd.*# 保存上筆資料
         SELECT ROWID INTO g_aps_imd_rowid FROM aps_imd
          WHERE wh_id = g_aps_imd.wh_id
      END IF

      EXIT WHILE
   END WHILE

   CLOSE i206_cl
   COMMIT WORK
END FUNCTION

