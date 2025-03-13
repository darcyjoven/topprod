# Prog. Version..: '5.10.05-08.12.18(00000)'     #
# Pattern name...: apsi207.4gl
# Descriptions...: 儲位資料維護作業
# Date & Author..: 04/11/10 By Nicola
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-680048 06/10/13 By Joe 修改程式由aimi201串過來
# Modify.........: No:FUN-6A0163 06/11/07 By jamie 新增action"相關文件"
# Modify.........: No:FUN-6B0079 06/12/15 By jamie FUNCTION _fetch() 清空key值
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_aps_ime   RECORD            
                wh_id            LIKE aps_ime.wh_id,
                stk_loc          LIKE aps_ime.stk_loc,
                is_cnsn          LIKE aps_ime.is_cnsn
                END RECORD,
    g_aps_ime_t RECORD
                wh_id            LIKE aps_ime.wh_id,
                stk_loc          LIKE aps_ime.stk_loc,
                is_cnsn          LIKE aps_ime.is_cnsn
                END RECORD,
    g_aps_ime_rowid     LIKE type_file.chr18, 		#ROWID  #No.FUN-690010 INT
    g_wc,g_sql          STRING  

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_flag          LIKE type_file.chr1    #FUN-680048

MAIN
   DEFINE l_time          LIKE type_file.chr8   	#計算被使用時間  #No.FUN-690010 VARCHAR(8)
   DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690010 SMALLINT

   OPTIONS			                #改變一些系統預設值
      FORM LINE     FIRST + 2,                  #畫面開始的位置
      MESSAGE LINE  LAST,	                #訊息顯示的位置
      PROMPT LINE   LAST,	                #提示訊息的位置
      INPUT NO WRAP		                #輸入的方式: 不打轉
       				        
   DEFER INTERRUPT		                #擷取中斷鍵,由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used("apsi207",l_time,1) RETURNING l_time  #計算使用時間 (進入時間)

   LET g_forupd_sql = "SELECT * FROM aps_ime WHERE ROWID = ? FOR UPDATE NOWAIT"
   DECLARE i207_cl CURSOR FROM g_forupd_sql

   LET p_row = 2
   LET p_col = 3 

   OPEN WINDOW i207_w AT p_row,p_col
     WITH FORM "aps/42f/apsi207" ATTRIBUTE(STYLE = g_win_style)
   
   CALL cl_ui_init()

   #FUN-680048
   LET g_aps_ime.wh_id   = ARG_VAL(1)
   LET g_aps_ime.stk_loc = ARG_VAL(2)
   IF g_aps_ime.wh_id IS NOT NULL AND g_aps_ime.wh_id != ' ' THEN
      LET g_flag = 'Y'
      CALL i207_q()
   ELSE
      LET g_flag = 'N'
   END IF

   WHILE TRUE
      LET g_action_choice=""
      CALL i207_menu()
      IF g_action_choice="exit" THEN 
         EXIT WHILE 
      END IF
   END WHILE
   #FUN-680048

   CLOSE WINDOW i207_w
   CALL cl_used("apsi207",l_time,2) RETURNING l_time

END MAIN

FUNCTION i207_cs()

   CLEAR FORM

   IF g_flag = 'Y' THEN          #FUN-680048
      LET g_wc = " wh_id='",g_aps_ime.wh_id,"' AND stk_loc='",g_aps_ime.stk_loc,"'"
   ELSE
   INITIALIZE g_aps_ime.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON wh_id,stk_loc,is_cnsn
                   
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

   LET g_sql = "SELECT ROWID,wh_id,stk_loc FROM aps_ime ",   # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY wh_id,stk_loc"
   PREPARE i207_prepare FROM g_sql                     # RUNTIME 編譯
   DECLARE i207_cs                                     # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i207_prepare

   LET g_sql= "SELECT COUNT(*) FROM aps_ime WHERE ",g_wc CLIPPED
   PREPARE i207_precount FROM g_sql
   DECLARE i207_count CURSOR FOR i207_precount

END FUNCTION

FUNCTION i207_menu()

   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i207_q()
         END IF
      ON ACTION next 
         CALL i207_fetch("N") 
      ON ACTION previous 
         CALL i207_fetch("P")
      ON ACTION modify 
         CALL i207_u()
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i207_fetch("/")
      ON ACTION first
         CALL i207_fetch("F")
      ON ACTION last
         CALL i207_fetch("L")
      ON ACTION CONTROLG    
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No:FUN-6A0163-------add--------str----
      ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
         IF cl_chk_act_auth() THEN                     
             IF g_aps_ime.wh_id IS NOT NULL THEN            
                LET g_doc.column1 = "wh_id"               
                LET g_doc.column2 = "stk_loc"               
                LET g_doc.value1 = g_aps_ime.wh_id            
                LET g_doc.value2 = g_aps_ime.stk_loc           
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

   CLOSE i207_cs

END FUNCTION

FUNCTION i207_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)

   DISPLAY BY NAME g_aps_ime.wh_id,g_aps_ime.stk_loc,g_aps_ime.is_cnsn  

   INPUT BY NAME g_aps_ime.wh_id,g_aps_ime.stk_loc,g_aps_ime.is_cnsn WITHOUT DEFAULTS 

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
                   
FUNCTION i207_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   CALL cl_opmsg("q")
   MESSAGE ""
   DISPLAY "   " TO FORMONLY.cnt 

   CALL i207_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_aps_ime.* TO NULL
      RETURN
   END IF

   OPEN i207_count
   FETCH i207_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  

   OPEN i207_cs                             # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aps_ime.wh_id,SQLCA.sqlcode,0)
      INITIALIZE g_aps_ime.* TO NULL
   ELSE
      CALL i207_fetch("F")                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION i207_fetch(p_flpme)
   DEFINE p_flpme          LIKE type_file.chr1,    #No.FUN-690010  VARCHAR(1),
          l_abso           LIKE type_file.num10   #No.FUN-690010 INTEGER

   CASE p_flpme
      WHEN "N" FETCH NEXT     i207_cs INTO g_aps_ime_rowid,g_aps_ime.wh_id,g_aps_ime.stk_loc
      WHEN "P" FETCH PREVIOUS i207_cs INTO g_aps_ime_rowid,g_aps_ime.wh_id,g_aps_ime.stk_loc
      WHEN "F" FETCH FIRST    i207_cs INTO g_aps_ime_rowid,g_aps_ime.wh_id,g_aps_ime.stk_loc
      WHEN "L" FETCH LAST     i207_cs INTO g_aps_ime_rowid,g_aps_ime.wh_id,g_aps_ime.stk_loc
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

         FETCH ABSOLUTE l_abso i207_cs INTO g_aps_ime_rowid,g_aps_ime.wh_id,g_aps_ime.stk_loc

   END CASE

   IF SQLCA.sqlcode THEN
      LET g_msg = g_aps_ime.wh_id CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_aps_ime.* TO NULL           #No:FUN-6B0079 
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

   SELECT * INTO g_aps_ime.* FROM aps_ime
    WHERE ROWID = g_aps_ime_rowid
   IF SQLCA.sqlcode THEN
      LET g_msg = g_aps_ime.wh_id CLIPPED
 #    CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
      CALL cl_err3("sel","aps_ime",g_aps_ime.wh_id,g_aps_ime.stk_loc,SQLCA.sqlcode,"","",1) # FUN-660095
      INITIALIZE g_aps_ime.* TO NULL           #No:FUN-6B0079 
   ELSE
      CALL i207_show()
   END IF

END FUNCTION

FUNCTION i207_show()

   LET g_aps_ime_t.* = g_aps_ime.*
   DISPLAY BY NAME g_aps_ime.*

    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i207_u()

   IF g_aps_ime.wh_id IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   LET g_aps_ime_t.* = g_aps_ime.*  #No.FUN-660095
   MESSAGE ""
   CALL cl_opmsg("u")
   BEGIN WORK

   OPEN i207_cl USING g_aps_ime_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i207_cl:",STATUS,1)
      CLOSE i207_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i207_cl INTO g_aps_ime.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aps_ime.wh_id,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL i207_show()                          # 顯示最新資料

   WHILE TRUE
      CALL i207_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_aps_ime.* = g_aps_ime_t.*
         CALL i207_show()
         CALL cl_err("",9001,0)
         EXIT WHILE
      END IF

      UPDATE aps_ime SET aps_ime.* = g_aps_ime.*
       WHERE ROWID = g_aps_ime_rowid
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_msg = g_aps_ime.wh_id CLIPPED
 #        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
         CALL cl_err3("upd","aps_ime",g_aps_ime_t.wh_id,g_aps_ime.stk_loc,SQLCA.sqlcode,"","",1) # FUN-660095
         CONTINUE WHILE
      ELSE 
         LET g_aps_ime_t.* = g_aps_ime.*       # 保存上筆資料
         SELECT ROWID INTO g_aps_ime_rowid FROM aps_ime
          WHERE wh_id = g_aps_ime.wh_id
            AND stk_loc = g_aps_ime.stk_loc
      END IF

      EXIT WHILE
   END WHILE

   CLOSE i207_cl
   COMMIT WORK
END FUNCTION

