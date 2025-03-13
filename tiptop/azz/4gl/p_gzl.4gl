# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_gzl.4gl
# Descriptions...: 軟體代工開發記錄維護程式
# Date & Author..: 05/01/06 by saki
# Modify.........: No.TQC-5B0190 05/12/01 By saki 自動塞入gzln_file的資料問題
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制         
# Modify.........: No.FUN-590083 06/03/30 By Alexstar 多語言顯示功能         
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.MOD-6B0039 06/11/13 By Smapmin 執行打包檔案修改記錄時,RETURN前要先CLOSE WINDOW
# Modify.........: No.FUN-710051 07/01/29 By flowld  在“修改清單”中，自動判斷檔案是不是在所填寫的路徑下
# Modify.........: No.FUN-710052 07/01/29 By flowld  在“資料清單”中，自動判斷輸入的KEY值，在不在對應的表中
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.CHI-750028 07/05/21 By saki 修改抓資料問題，及清單填寫的問題
# Modify.........: No.TQC-7A0101 07/10/26 By saki 增加資料同步選項p_zaw及4fd,per打包
# Modify.........: No.FUN-780083 07/12/10 By saki 訊息更動
# Modify.........: No.TQC-7C0159 07/12/21 By saki 訊息更動
# Modify.........: No.FUN-820068 08/02/27 By alexstar 服務反應捆一包功能打包共用資料選項不應預設為Y
# Modify.........: No.FUN-830042 08/03/19 By saki 軟代確認成功後, 更改booking檔案的權限為775
# Modify.........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.TQC-890002 08/09/01 By saki 若p_link資料輸入共用程式代碼時，要求輸入第二個Key值
 
IMPORT os         #No.FUN-830042
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
 
DEFINE   g_forupd_sql   STRING
DEFINE   g_gzl          RECORD LIKE gzl_file.*
DEFINE   g_gzl_t        RECORD LIKE gzl_file.*
DEFINE   g_gzl00_t      LIKE gzl_file.gzl00
DEFINE   g_gzl01_t      LIKE gzl_file.gzl01
DEFINE   g_gzl17_t      LIKE gzl_file.gzl17
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_wc,g_sql     LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(1600)
DEFINE   g_msg          LIKE type_file.chr1000       #FUN-680135    VARCHAR(27)
DEFINE   g_gzln         DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
            gzln02      LIKE gzln_file.gzln02,
            gzln03      LIKE gzln_file.gzln03,
            gzln04      LIKE gzln_file.gzln04,
            gzln05      LIKE gzln_file.gzln05,
            gzln06      LIKE gzln_file.gzln06
                        END RECORD,
         g_gzln_t       RECORD                    #程式變數(Program Variables)
            gzln02      LIKE gzln_file.gzln02,
            gzln03      LIKE gzln_file.gzln03,
            gzln04      LIKE gzln_file.gzln04,
            gzln05      LIKE gzln_file.gzln05,
            gzln06      LIKE gzln_file.gzln06
                        END RECORD
DEFINE   g_gsyc         DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
            gsyc02      LIKE gsyc_file.gsyc02,
            gsyc04      LIKE gsyc_file.gsyc04,
            gsyc06      LIKE gsyc_file.gsyc06,
            gsyc07      LIKE gsyc_file.gsyc07
                        END RECORD,
         g_gsyc_t       RECORD                    #程式變數(Program Variables)
            gsyc02      LIKE gsyc_file.gsyc02,
            gsyc04      LIKE gsyc_file.gsyc04,
            gsyc06      LIKE gsyc_file.gsyc06,
            gsyc07      LIKE gsyc_file.gsyc07
                        END RECORD
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_rec_b_k      LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   l_ac_k         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_rec_b_s      LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   l_ac_s         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5     #判斷是否已執行 Before Input指令        #No.FUN-680135 SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log 
   
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_forupd_sql = 
       "  SELECT * FROM gzl_file      ",
       "  WHERE gzl00=? AND gzl01=? AND gzl17=?  ",
       "  FOR UPDATE                 "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gzl_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   OPEN WINDOW p_gzl_w AT 2,5
     WITH FORM "azz/42f/p_gzl"
     ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
 
   CALL p_gzl_menu()
   CLOSE WINDOW p_gzl_w
END MAIN
 
FUNCTION p_gzl_menu()
   DEFINE   l_cmd     STRING
   DEFINE   l_result  LIKE type_file.num5     #FUN-680135 SMALLINT
    
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert 
         LET g_action_choice="insert" 
         IF cl_chk_act_auth() THEN
              CALL p_gzl_a()
         END IF
 
      ON ACTION query 
         LET g_action_choice="query"  
         IF cl_chk_act_auth() THEN
              CALL p_gzl_q()
         END IF
 
      ON ACTION next 
         CALL p_gzl_fetch('N') 
 
      ON ACTION previous 
         CALL p_gzl_fetch('P')
 
      ON ACTION jump
         CALL p_gzl_fetch('/')
 
      ON ACTION first
         CALL p_gzl_fetch('F')
 
      ON ACTION last
         CALL p_gzl_fetch('L')
 
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL p_gzl_u()
         END IF
 
      ON ACTION delete 
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN  
            CALL p_gzl_r()
         END IF
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()            #No.FUN-590083
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         LET g_action_choice = "exit"
         CONTINUE MENU
   
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION mntn_modi_list  #K.修改清單  (GP)
         CALL p_gzl_k()
 
      ON ACTION mntn_data_sync  #Z.訊息資料同步 (GP)
         CALL p_gzl_s()
 
      ON ACTION mntn_tab_modi    #檔案修改
         CALL p_gzl_w()
 
      ON ACTION mntn_tab_zs      #檔案修改記錄
         CALL p_gzl_zs()
 
      ON ACTION tsd_confirm
         LET g_action_choice = "tsd_confirm"
         IF cl_chk_act_auth() THEN
            CALL p_gzl_confirm("tsd")
         END IF
 
      ON ACTION tsd_undo_confirm
         LET g_action_choice = "tsd_undo_confirm"
         IF cl_chk_act_auth() THEN
            CALL p_gzl_undo_confirm("tsd")
         END IF
 
      ON ACTION sc_confirm
         LET g_action_choice = "sc_confirm"
         IF cl_chk_act_auth() THEN
            CALL p_gzl_confirm("sc")
         END IF
 
      ON ACTION sc_undo_confirm
         LET g_action_choice = "sc_undo_confirm"
         IF cl_chk_act_auth() THEN
            CALL p_gzl_undo_confirm("sc")
         END IF
 
      ON ACTION pack             # FUN-4C0043
         CALL p_gzl_pack()
 
      ON ACTION mntn_tab_pack_zs #打包檔案修改記錄
         CALL p_gzl_pack_zs()
 
   END MENU
 
END FUNCTION
 
FUNCTION p_gzl_cs()
   CLEAR FORM
 
   CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
      gzl00,gzl01,gzl17,gzl02,gzl04,gzl06,gzl09,gzl07,gzl08,
      gzl05,gzl18,gzl11,gzl10,gzl12,gzl16,gzl13,gzl15,gzl14,
      gzl19,gzl20
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND gzl11 = '",g_user,"'"
   #   END IF
 
   LET g_sql="SELECT gzl00,gzl01,gzl17 FROM gzl_file ", # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED," ORDER BY gzl00,gzl01,gzl17"
 
   PREPARE p_gzl_prepare FROM g_sql         # RUNTIME 編譯
   DECLARE p_gzl_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p_gzl_prepare
   LET g_sql=
       "SELECT COUNT(*) FROM gzl_file WHERE ",g_wc CLIPPED
   PREPARE p_gzl_precount FROM g_sql
   DECLARE p_gzl_count CURSOR FOR p_gzl_precount 
END FUNCTION
 
FUNCTION p_gzl_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt  
   CALL p_gzl_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN p_gzl_count
   FETCH p_gzl_count INTO g_row_count 
   DISPLAY g_row_count TO FORMONLY.cnt 
   OPEN p_gzl_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)
      INITIALIZE g_gzl.* TO NULL
   ELSE
       CALL p_gzl_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION p_gzl_fetch(p_flzl)
   DEFINE   p_flzl   LIKE type_file.chr1,     #FUN-680135 VARCHAR(1)
            l_abso   LIKE type_file.num10     #No.FUN-680135 INTEGER
 
   CASE p_flzl
      WHEN 'N' FETCH NEXT     p_gzl_cs INTO g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17
      WHEN 'P' FETCH PREVIOUS p_gzl_cs INTO g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17
      WHEN 'F' FETCH FIRST    p_gzl_cs INTO g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17
      WHEN 'L' FETCH LAST     p_gzl_cs INTO g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17
      WHEN '/'
         IF (NOT mi_no_ask) THEN         #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            PROMPT g_msg CLIPPED,': ' FOR g_jump 
#TQC-860017 start
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
            END PROMPT
#TQC-860017 end
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_gzl_cs INTO g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17
         LET mi_no_ask = FALSE        #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)
      INITIALIZE g_gzl.* TO NULL  #TQC-6B0105
      LET g_gzl.gzl00 = NULL LET g_gzl.gzl01 = NULL LET g_gzl.gzl17 = NULL      #TQC-6B0105
      RETURN
   ELSE
      CASE p_flzl
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_gzl.* FROM gzl_file            # 重讀DB,因TEMP有不被更新特性
      WHERE gzl00=g_gzl.gzl00 AND gzl01=g_gzl.gzl01 AND gzl17=g_gzl.gzl17
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("sel","gzl_file",g_gzl.gzl00,g_gzl.gzl01,SQLCA.sqlcode,"","",0)   #No.FUN-660081
   ELSE
      CALL p_gzl_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION p_gzl_show()
   LET g_gzl_t.* = g_gzl.*
 
   DISPLAY BY NAME 
      g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl02,g_gzl.gzl04,g_gzl.gzl05,
      g_gzl.gzl06,g_gzl.gzl07,g_gzl.gzl08,g_gzl.gzl09,g_gzl.gzl10,
      g_gzl.gzl11,g_gzl.gzl12,g_gzl.gzl13,g_gzl.gzl14,g_gzl.gzl15,
      g_gzl.gzl16,g_gzl.gzl17,g_gzl.gzl18,g_gzl.gzl19,g_gzl.gzl20
 
   CALL p_gzl_gzl05()
   CALL p_gzl_zx01('a',g_gzl.gzl11,'1')
   CALL p_gzl_zx01('a',g_gzl.gzl13,'2')
   CALL p_gzl_zx01('a',g_gzl.gzl19,'3')
   CALL cl_show_fld_cont()               #No.FUN-590083
END FUNCTION
 
FUNCTION p_gzl_a()
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_gzl.* TO NULL
   LET g_gzl00_t = NULL
   LET g_gzl01_t = NULL
   LET g_gzl17_t = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_gzl.gzl02 = NULL
      LET g_gzl.gzl11 = g_user
      LET g_gzl.gzl18 = "1"
 
      CALL p_gzl_i("a")                      # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
      END IF
      
      IF cl_null(g_gzl.gzl00) THEN
         CALL cl_err(g_gzl.gzl00,STATUS,1)
         EXIT WHILE
      END IF
      DISPLAY BY NAME g_gzl.gzl00
 
      IF (g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
         (g_gzl.gzl17 IS NULL) THEN   # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO gzl_file VALUES(g_gzl.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("ins","gzl_file",g_gzl.gzl00,g_gzl.gzl01,SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      ELSE
         LET g_gzl_t.* = g_gzl.*                # 保存上筆資料
         SELECT gzl00,gzl01,gzl17 INTO g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17 FROM gzl_file
          WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
            AND gzl17 = g_gzl.gzl17
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_gzl_i(p_cmd)
   DEFINE   p_cmd           LIKE type_file.chr1,     #No.FUN-680135 VARCHAR(1)
            l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入  #No.FUN-680135 VARCHAR(1) 
            l_n             LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            l_sql           STRING
 
 
   #No.TQC-7C0159 --start--
   DISPLAY BY NAME 
      g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl02,g_gzl.gzl04,g_gzl.gzl05,
      g_gzl.gzl06,g_gzl.gzl07,g_gzl.gzl08,g_gzl.gzl09,g_gzl.gzl10,
      g_gzl.gzl11,g_gzl.gzl12,g_gzl.gzl13,g_gzl.gzl14,g_gzl.gzl15,
      g_gzl.gzl16,g_gzl.gzl17,g_gzl.gzl18,g_gzl.gzl19,g_gzl.gzl20
   #No.TQC-7C0159 ---end---
 
   INPUT BY NAME 
      g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl02,g_gzl.gzl04,g_gzl.gzl06,
      g_gzl.gzl09,g_gzl.gzl07,g_gzl.gzl08,g_gzl.gzl05,g_gzl.gzl11,g_gzl.gzl10,
      g_gzl.gzl12,g_gzl.gzl16,g_gzl.gzl14
      WITHOUT DEFAULTS HELP 1
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL p_gzl_set_entry(p_cmd)
          CALL p_gzl_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD gzl00
         IF (g_gzl.gzl00 IS NOT NULL) AND (g_gzl.gzl01 IS NOT NULL) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_gzl.gzl00 != g_gzl00_t) THEN
               SELECT MAX(gzl17) INTO g_gzl.gzl17 FROM gzl_file
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
               IF cl_null(g_gzl.gzl17) THEN
                  LET g_gzl.gzl17 = 0
               ELSE
                  LET g_gzl.gzl17 = g_gzl.gzl17 + 1
               END IF
               DISPLAY g_gzl.gzl17 TO gzl17
            END IF
         END IF
 
         IF ((g_gzl.gzl00 IS NOT NULL) AND (g_gzl.gzl01 IS NOT NULL) AND
             (g_gzl.gzl17 IS NOT NULL)) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_gzl.gzl00 != g_gzl00_t) THEN
               SELECT count(*) INTO l_n FROM gzl_file
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
                  AND gzl17 = g_gzl.gzl17
               IF l_n > 0 THEN
                  CALL cl_err(g_gzl.gzl00,-239,1)
                  LET g_gzl.gzl00 = g_gzl00_t
                  DISPLAY BY NAME g_gzl.gzl00
                  NEXT FIELD gzl00
               END IF
            END IF
         END IF
 
      AFTER FIELD gzl01
         IF (g_gzl.gzl00 IS NOT NULL) AND (g_gzl.gzl01 IS NOT NULL) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_gzl.gzl00 != g_gzl00_t) THEN
               SELECT MAX(gzl17) INTO g_gzl.gzl17 FROM gzl_file
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
               IF cl_null(g_gzl.gzl17) THEN
                  LET g_gzl.gzl17 = 0
               ELSE
                  LET g_gzl.gzl17 = g_gzl.gzl17 + 1
               END IF
               DISPLAY g_gzl.gzl17 TO gzl17
            END IF
         END IF
 
         IF ((g_gzl.gzl00 IS NOT NULL) AND (g_gzl.gzl01 IS NOT NULL) AND
             (g_gzl.gzl17 IS NOT NULL)) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_gzl.gzl01 != g_gzl01_t) THEN
               SELECT count(*) INTO l_n FROM gzl_file
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
                  AND gzl17 = g_gzl.gzl17
               IF l_n > 0 THEN
                  CALL cl_err(g_gzl.gzl01,-239,1)
                  LET g_gzl.gzl01 = g_gzl01_t
                  DISPLAY BY NAME g_gzl.gzl01
                  NEXT FIELD gzl01
               END IF
            END IF
         END IF
 
      AFTER FIELD gzl05
         IF (g_gzl.gzl05 IS NOT NULL) THEN
            LET l_sql = "SELECT COUNT(*) FROM zz_file",
                        " WHERE zz01 = '",g_gzl.gzl05,"'"
            PREPARE cnt_pre FROM l_sql
            EXECUTE cnt_pre INTO l_n
            IF l_n > 0 THEN
               CALL p_gzl_gzl05()
            ELSE
               DISPLAY NULL TO FORMONLY.zz02
            END IF
         END IF
 
      BEFORE FIELD gzl11
         DISPLAY g_user TO gzl11
 
      AFTER FIELD gzl11
         IF (g_gzl.gzl11 IS NOT NULL) THEN
            CALL p_gzl_zx01('a',g_gzl.gzl11,'1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gzl.gzl11,g_errno,0)
               NEXT FIELD gzl11
            END IF
         END IF
 
      AFTER INPUT 
         IF INT_FLAG THEN                         # 若按了DEL鍵
            RETURN
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gzl05) #程式代號
               CALL cl_qzz(FALSE,TRUE,g_gzl.gzl05) RETURNING g_gzl.gzl05
               DISPLAY BY NAME g_gzl.gzl05
               CALL p_gzl_gzl05()
               NEXT FIELD gzl05
 
            WHEN INFIELD(gzl11) #程式人員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1 = g_gzl.gzl11
               CALL cl_create_qry() RETURNING g_gzl.gzl11
               CALL p_gzl_zx01('d',g_gzl.gzl11,'1')
               NEXT FIELD gzl11
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE INPUT
#TQC-860017 end        
   END INPUT
END FUNCTION
 
FUNCTION p_gzl_u()
   IF (g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
      (g_gzl.gzl17 IS NULL) THEN
      CALL cl_err('Serial No. Null','!',1)
      RETURN
   END IF
   IF (g_gzl.gzl18 != "1") THEN
      CALL cl_err('','9003',1)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gzl00_t = g_gzl.gzl00
   LET g_gzl01_t = g_gzl.gzl01
   LET g_gzl17_t = g_gzl.gzl17
   BEGIN WORK
   
   OPEN p_gzl_cl USING g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17
   IF STATUS THEN
      CALL cl_err("OPEN gzl_cl:", STATUS, 1)
      CLOSE p_gzl_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p_gzl_cl INTO g_gzl.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL p_gzl_show()                           # 顯示最新資料
   WHILE TRUE
      CALL p_gzl_i("u")                        # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gzl.*=g_gzl_t.*
         CALL p_gzl_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gzl_file SET gzl_file.* = g_gzl.*    # 更新DB
          WHERE gzl00=g_gzl.gzl00 AND gzl01=g_gzl.gzl01 AND gzl17=g_gzl.gzl17
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gzl_file",g_gzl00_t,g_gzl01_t,SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE p_gzl_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_gzl_r()
   DEFINE   l_chr   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF ((g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
       (g_gzl.gzl17 IS NULL)) THEN
      CALL cl_err('Serial No. Null','!',1)
      RETURN
   END IF
 
   #No.TQC-5B0190 --start--
   IF (g_gzl.gzl18 != "1") THEN
      CALL cl_err(g_gzl.gzl18,'9003',1)
      RETURN
   END IF
   #No.TQC-5B0190 ---end---
 
   BEGIN WORK
   OPEN p_gzl_cl USING g_gzl.gzl00,g_gzl.gzl01,g_gzl.gzl17
   IF STATUS THEN
      CALL cl_err("OPEN gzl_cl:", STATUS, 1)
      CLOSE p_gzl_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p_gzl_cl INTO g_gzl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL p_gzl_show()
   IF cl_delete() THEN 
      DELETE FROM gzl_file
       WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
         AND gzl17 = g_gzl.gzl17
      IF SQLCA.SQLERRD[3] = 0 THEN
         #CALL cl_err(g_gzl.gzl00,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gzl_file",g_gzl.gzl00,g_gzl.gzl01,SQLCA.sqlcode,"","",0)   #No.FUN-660081
      ELSE
         DELETE FROM gzln_file
          WHERE gzln00 = g_gzl.gzl00 AND gzln01 = g_gzl.gzl01
            AND gzln07 = g_gzl.gzl17
         DELETE FROM gsyc_file
          WHERE gsyc00 = g_gzl.gzl00 AND gsyc01 = g_gzl.gzl01
            AND gsyc08 = g_gzl.gzl17
      END IF
      CLEAR FORM
       
      OPEN p_gzl_count
      FETCH p_gzl_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN p_gzl_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL p_gzl_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE             #No.FUN-6A0080
         CALL p_gzl_fetch('/')
      END IF
   END IF
   CLOSE p_gzl_cl
   COMMIT WORK 
END FUNCTION
 
FUNCTION p_gzl_k()
   IF ((g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
       (g_gzl.gzl17 IS NULL)) THEN
      CALL cl_err('Mod No. Null','!',1)
      RETURN
   END IF
 
   OPEN WINDOW p_gzln_w AT 3,14
      WITH FORM "azz/42f/p_gzln" 
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_locale("p_gzln")
   CALL p_gzln_b_fill()
 
   CALL cl_set_act_visible("accept",FALSE)
   DISPLAY ARRAY g_gzln TO s_gzln.* ATTRIBUTE(COUNT=g_rec_b_k,UNBUFFERED)
 
      ON ACTION detail
         LET l_ac_k = 1
         CALL cl_set_act_visible("accept",TRUE)
         IF (g_gzl.gzl18 = '1') THEN
            CALL p_gzln_b()
         END IF
	 CALL cl_set_act_visible("accept",FALSE)
 
      ON ACTION accept
         LET l_ac_k = ARR_CURR()
         CALL cl_set_act_visible("accept",TRUE)
         IF (g_gzl.gzl18 = '1') THEN
            CALL p_gzln_b()
         END IF
	 CALL cl_set_act_visible("accept",FALSE)
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel
          (ui.Interface.getRootNode(),base.TypeInfo.create(g_gzln),'','')
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE DISPLAY
#TQC-860017 end
   END DISPLAY
   CALL cl_set_act_visible("accept",TRUE)
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_gzln_w
   END IF
END FUNCTION
 
FUNCTION p_gzln_b_fill()
   LET g_sql =
      "SELECT gzln02,gzln03,gzln04,gzln05,gzln06",
      " FROM gzln_file ",
      " WHERE gzln00 = '",g_gzl.gzl00,"'",
      "   AND gzln01 = '",g_gzl.gzl01,"'",
      "   AND gzln07 = '",g_gzl.gzl17,"'",
      " ORDER BY gzln02,gzln03,gzln04,gzln05"
   PREPARE p_gzln_prepare FROM g_sql      #預備一下
   DECLARE p_gzln_curs CURSOR FOR p_gzln_prepare
   CALL g_gzln.clear()
   LET g_cnt = 1
   FOREACH p_gzln_curs INTO g_gzln[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         #TQC-630107---add---
         CALL cl_err( '', 9035, 0 )
         #TQC-630107---end---
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_gzln.deleteElement(g_cnt)
   LET g_rec_b_k = g_cnt - 1
   DISPLAY g_rec_b_k TO FORMONLY.cn2
END FUNCTION
 
FUNCTION p_gzln_b()
   DEFINE   l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,   #檢查重複用     #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   #單身鎖住否     #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1    #處理狀態       #No.FUN-680135 VARCHAR(1)
   DEFINE   l_allow_insert  LIKE type_file.num5    #可新增否       #No.FUN-680135 SMALLINT
   DEFINE   l_allow_delete  LIKE type_file.num5    #可刪除否       #No.FUN-680135 SMALLINT
   DEFINE   lc_sys          STRING                 #系統別
   DEFINE   l_cmd           STRING                 #No.FUN-710051
   DEFINE   l_ora_test      STRING                 #No.FUN-710051
   DEFINE   l_down          STRING                 #No.FUN-710051
   DEFINE   l_up            STRING                 #No.FUN-710051
   DEFINE   l_str           STRING                 #No.FUN-710051
 
   MESSAGE ""
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = 
        "SELECT gzln02,gzln03,gzln04,gzln05,gzln06",
        "  FROM gzln_file    ",
        " WHERE gzln00 = ? AND gzln01 = ? AND gzln02 = ? AND gzln07 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gzln_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   
   IF g_rec_b_k = 0 THEN
      CALL g_gzln.clear()
      #沒有資料按下B單身時，自動加4gl跟4fd檔的資料    #No.TQC-7A0101
      IF (g_gzl.gzl18 = "1") THEN
         #No.CHI-750028 --start--
         CASE
            WHEN g_gzl.gzl05[1,2] = "p_"
               LET lc_sys = "zz"
            WHEN g_gzl.gzl05[1,2] = "s_"
               LET lc_sys = "sub"
            WHEN g_gzl.gzl05[1,2] = "q_"
               LET lc_sys = "qry"
            WHEN g_gzl.gzl05[1,3] = "cl_"
               LET lc_sys = "lib"
            OTHERWISE
               LET lc_sys = g_gzl.gzl05[2,3]         #No.TQC-5B0190
         END CASE
         #No.CHI-750028 ---end---
         LET g_gzln[1].gzln02 = 1
         LET g_gzln[1].gzln03 = "c",lc_sys     #No.TQC-5B0190
         LET g_gzln[1].gzln04 = "4gl"
         LET g_gzln[1].gzln05 = g_gzl.gzl05 CLIPPED,".4gl"
         INSERT INTO gzln_file(gzln00,gzln01,gzln02,gzln03,gzln04,gzln05,gzln06,gzln07)
                        VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gzln[1].gzln02,
                               g_gzln[1].gzln03,g_gzln[1].gzln04,
                               g_gzln[1].gzln05,g_gzln[1].gzln06,
                               g_gzl.gzl17)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gzln[1].gzln02,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gzln_file",g_gzl.gzl00,g_gzln[1].gzln02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
         ELSE
            LET g_rec_b_k = g_rec_b_k + 1
         END IF
         LET g_gzln[2].gzln02 = 2
         LET g_gzln[2].gzln03 = "c",lc_sys     #No.TQC-5B0190
         LET g_gzln[2].gzln04 = "4fd"          #No.TQC-7A0101
         LET g_gzln[2].gzln05 = g_gzl.gzl05 CLIPPED,".4fd"     #No.TQC-7A0101
         INSERT INTO gzln_file(gzln00,gzln01,gzln02,gzln03,gzln04,gzln05,gzln06,gzln07)
                        VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gzln[2].gzln02,
                               g_gzln[2].gzln03,g_gzln[2].gzln04,
                               g_gzln[2].gzln05,g_gzln[2].gzln06,
                               g_gzl.gzl17)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gzln[2].gzln02,SQLCA.sqlcode,0)
            CALL cl_err3("ins","gzln_file",g_gzl.gzl00,g_gzln[2].gzln02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
         ELSE
            LET g_rec_b_k = g_rec_b_k + 1
         END IF
      END IF
   END IF
 
   LET l_ac_t = 0
   INPUT ARRAY g_gzln WITHOUT DEFAULTS FROM s_gzln.* 
      ATTRIBUTE (COUNT=g_rec_b_k,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
                 APPEND ROW = l_allow_insert) 
 
      BEFORE INPUT
         IF g_rec_b_k != 0 THEN
            CALL fgl_set_arr_curr(l_ac_k)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac_k = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b_k >= l_ac_k  THEN
            LET p_cmd='u'
            LET g_gzln_t.* = g_gzln[l_ac_k].*  #BACKUP
            OPEN p_gzln_bcl USING g_gzl.gzl00,g_gzl.gzl01,g_gzln_t.gzln02,g_gzl.gzl17
            IF STATUS THEN
               CALL cl_err("OPEN p_gzln_bcl", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gzln_bcl INTO g_gzln[l_ac_k].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gzln_t.gzln02,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               ELSE
                  LET g_gzln_t.*=g_gzln[l_ac_k].*
               END IF
            END IF
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gzln[l_ac_k].* TO NULL
         LET g_gzln_t.* = g_gzln[l_ac_k].*
         NEXT FIELD gzln02
 
       
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF g_gzln[l_ac_k].gzln02 IS NULL OR    #重要欄位空白,無效
            g_gzln[l_ac_k].gzln03 IS NULL OR    #
            g_gzln[l_ac_k].gzln04 IS NULL OR    #
            g_gzln[l_ac_k].gzln05 IS NULL THEN  #
            INITIALIZE g_gzln[l_ac_k].* TO NULL
            CANCEL INSERT
         END IF
#No.FUN-710051 --start--                                                                                                            
      # 檢查系統別抓取相應的路徑                                                                                                    
       IF g_gzln[l_ac_k].gzln03[1,1] = "c" THEN                                                                                     
          LET l_ora_test = FGL_GETENV("CUST")                                                                                       
       ELSE                                                                                                                         
          LET l_ora_test = FGL_GETENV("TOP")                                                                                        
       END IF                                                                                                                       
         #檢查有沒有重復                                                                                                            
         IF (g_gzln[l_ac_k].gzln03 != g_gzln_t.gzln03) OR                                                                           
            (g_gzln[l_ac_k].gzln04 != g_gzln_t.gzln04) OR                                                                           
            (g_gzln[l_ac_k].gzln05 != g_gzln_t.gzln05) OR                                                                           
            cl_null(g_gzln_t.gzln03) OR                                                                                             
            cl_null(g_gzln_t.gzln04) OR                                                                                             
            cl_null(g_gzln_t.gzln05) THEN
 
            IF NOT cl_null(g_gzln[l_ac_k].gzln05) AND NOT cl_null(g_gzln[l_ac_k].gzln04) AND                                        
               NOT cl_null(g_gzln[l_ac_k].gzln03) THEN                                                                              
               SELECT COUNT(*) INTO l_n FROM gzln_file                                                                              
                WHERE gzln07 = g_gzl.gzl17 AND gzln00 = g_gzl.gzl00                                                                 
                  AND gzln03 = g_gzln[l_ac_k].gzln03 AND gzln04 = g_gzln[l_ac_k].gzln04                                             
                  AND gzln05 = g_gzln[l_ac_k].gzln05                                                                                
               IF l_n > 0 THEN                                                                                                      
                  CALL cl_err('',-239,0)                                                                                            
                  NEXT FIELD gzln05                                                                                                 
               END IF                                                                                                               
            END IF                                                                                                                  
          END IF
         #檢查輸入的檔案有沒有存在，以ORA測試區為主                                                                                 
         IF g_gzln[l_ac_k].gzln04 = 'ora'  OR g_gzln[l_ac_k].gzln04 = '4gl'  OR                                                     
            g_gzln[l_ac_k].gzln04 = 'per'  OR g_gzln[l_ac_k].gzln04 = 'sql'  OR                                                     
            g_gzln[l_ac_k].gzln04 = 'za'   OR g_gzln[l_ac_k].gzln04 = '4fd' THEN    #No.TQC-7A0101
            LET l_cmd = "test -e ",l_ora_test,"/",g_gzln[l_ac_k].gzln03 CLIPPED,'/',                                                
                        g_gzln[l_ac_k].gzln04 CLIPPED,'/',g_gzln[l_ac_k].gzln05 CLIPPED                                             
            RUN l_cmd RETURNING g_cnt                                                                                               
            IF g_cnt THEN                                                                                                           
               CALL cl_err(l_cmd,'!',1)                                                                                             
               NEXT FIELD gzln05                                                                                                    
            END IF                                                                                                                  
         END IF                                                                                                                     
#No.FUN-710051 ---end---
         INSERT INTO gzln_file(gzln00,gzln01,gzln02,gzln03,gzln04,gzln05,gzln06,gzln07)
                        VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gzln[l_ac_k].gzln02,
                               g_gzln[l_ac_k].gzln03,g_gzln[l_ac_k].gzln04,
                               g_gzln[l_ac_k].gzln05,g_gzln[l_ac_k].gzln06,
                               g_gzl.gzl17)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gzln[l_ac_k].gzln02,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gzln_file",g_gzl.gzl00,g_gzln[l_ac_k].gzln02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            ROLLBACK WORK
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK 
            LET g_rec_b_k = g_rec_b_k + 1
            DISPLAY g_rec_b_k TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD gzln02
         IF cl_null(g_gzln[l_ac_k].gzln02) OR g_gzln[l_ac_k].gzln02 = 0 THEN
            SELECT MAX(gzln02)+1 INTO g_gzln[l_ac_k].gzln02 FROM gzln_file
             WHERE gzln00 = g_gzl.gzl00 AND gzln01 = g_gzl.gzl01
               AND gzln07 = g_gzl.gzl17
            IF cl_null(g_gzln[l_ac_k].gzln02) THEN
               LET g_gzln[l_ac_k].gzln02 = 1
            END IF
         END IF
 
      AFTER FIELD gzln02
         IF g_gzln[l_ac_k].gzln02 IS NOT NULL AND
            (g_gzln[l_ac_k].gzln02 != g_gzln_t.gzln02 OR
             g_gzln_t.gzln02 IS NULL) THEN
            SELECT count(*) INTO l_n FROM gzln_file
             WHERE gzln00 = g_gzl.gzl00
               AND gzln01 = g_gzl.gzl01 
               AND gzln02 = g_gzln[l_ac_k].gzln02
               AND gzln07 = g_gzl.gzl17
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_gzln[l_ac_k].gzln02 = g_gzln_t.gzln02
               NEXT FIELD gzln02
            END IF
         END IF
 
#No.FUN-710051 --start--                                                                                                            
      AFTER FIELD gzln05                                                                                                            
      # 檢查系統別抓取相應的路徑                                                                                                    
       IF g_gzln[l_ac_k].gzln03[1,1] = "c" THEN                                                                                     
          LET l_ora_test = FGL_GETENV("CUST")                                                                                       
       ELSE                                                                                                                         
          LET l_ora_test = FGL_GETENV("TOP")                                                                                        
       END IF
 
         #檢查有沒有重復                                                                                                            
         IF (g_gzln[l_ac_k].gzln03 != g_gzln_t.gzln03) OR
            (g_gzln[l_ac_k].gzln04 != g_gzln_t.gzln04) OR
            (g_gzln[l_ac_k].gzln05 != g_gzln_t.gzln05) OR
            cl_null(g_gzln_t.gzln03) OR
            cl_null(g_gzln_t.gzln04) OR
            cl_null(g_gzln_t.gzln05) THEN
 
          IF NOT cl_null(g_gzln[l_ac_k].gzln05) AND NOT cl_null(g_gzln[l_ac_k].gzln04) AND
               NOT cl_null(g_gzln[l_ac_k].gzln03) THEN
               SELECT COUNT(*) INTO l_n FROM gzln_file
                WHERE gzln07 = g_gzl.gzl17 AND gzln00 = g_gzl.gzl00
                  AND gzln03 = g_gzln[l_ac_k].gzln03 AND gzln04 = g_gzln[l_ac_k].gzln04
                  AND gzln05 = g_gzln[l_ac_k].gzln05
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD gzln05
               END IF
            END IF
         END IF
         #檢查輸入的檔案有沒有存在，以ORA測試區為主
         IF g_gzln[l_ac_k].gzln04 = 'ora'  OR g_gzln[l_ac_k].gzln04 = '4gl'  OR
            g_gzln[l_ac_k].gzln04 = 'per'  OR g_gzln[l_ac_k].gzln04 = 'sql'  OR
            g_gzln[l_ac_k].gzln04 = 'za'   OR g_gzln[l_ac_k].gzln04 = '4fd' THEN   #No.TQC-7A0101
            LET l_cmd = "test -e ",l_ora_test,"/",g_gzln[l_ac_k].gzln03 CLIPPED,'/',
                        g_gzln[l_ac_k].gzln04 CLIPPED,'/',g_gzln[l_ac_k].gzln05 CLIPPED
            RUN l_cmd RETURNING g_cnt
            IF g_cnt THEN
               CALL cl_err(l_cmd,'!',1)
               NEXT FIELD gzln05
            END IF
         END IF
#No.FUN-710051 ---end---
 
      BEFORE DELETE                            #是否取消單身
         IF g_gzln_t.gzln02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            
            IF l_lock_sw = 'Y' THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gzln_file
             WHERE gzln00 = g_gzl.gzl00
               AND gzln01 = g_gzl.gzl01
               AND gzln02 = g_gzln_t.gzln02
               AND gzln07 = g_gzl.gzl17
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gzln_t.gzln02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gzln_file",g_gzl.gzl00,g_gzln_t.gzln02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            ELSE     
               LET g_rec_b_k = g_rec_b_k - 1
               DISPLAY g_rec_b_k TO FORMONLY.cn2
               MESSAGE 'Delete ok!'
               COMMIT WORK
            END IF
         END IF
 
        
      ON ROW CHANGE
#No.FUN-710051 --start--                                                                                                            
      # 檢查系統別抓取相應的路徑                                                                                                    
       IF g_gzln[l_ac_k].gzln03[1,1] = "c" THEN                                                                                     
          LET l_ora_test = FGL_GETENV("CUST")                                                                                       
       ELSE                                                                                                                         
          LET l_ora_test = FGL_GETENV("TOP")                                                                                        
       END IF                                                                                                                       
                                                                                                                                    
         #檢查輸入的檔案有沒有存在，以ORA測試區為主                                                                                 
         IF g_gzln[l_ac_k].gzln04 = 'ora'  OR g_gzln[l_ac_k].gzln04 = '4gl'  OR                                                     
            g_gzln[l_ac_k].gzln04 = 'per'  OR g_gzln[l_ac_k].gzln04 = 'sql'  OR                                                     
            g_gzln[l_ac_k].gzln04 = 'za'   OR g_gzln[l_ac_k].gzln04 = '4fd' THEN   #No.TQC-7A0101
            LET l_cmd = "test -e ",l_ora_test,"/",g_gzln[l_ac_k].gzln03 CLIPPED,'/',                                                
                        g_gzln[l_ac_k].gzln04 CLIPPED,'/',g_gzln[l_ac_k].gzln05 CLIPPED                                             
            RUN l_cmd RETURNING g_cnt                                                                                               
            IF g_cnt THEN                                                                                                           
               CALL cl_err(l_cmd,'!',1)                                                                                             
               NEXT FIELD gzln05                                                                                                    
            END IF
         END IF                                                                                                                     
#No.FUN-710051 ---end---
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gzln[l_ac_k].* = g_gzln_t.*
            CLOSE p_gzln_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err('lock err',-263,1)
            LET g_gzln[l_ac_k].* = g_gzln_t.*
         ELSE
            UPDATE gzln_file 
               SET gzln02=g_gzln[l_ac_k].gzln02,
                   gzln03=g_gzln[l_ac_k].gzln03,
                   gzln04=g_gzln[l_ac_k].gzln04,
                   gzln05=g_gzln[l_ac_k].gzln05,
                   gzln06=g_gzln[l_ac_k].gzln06
             WHERE gzln00 = g_gzl.gzl00 AND gzln01 = g_gzl.gzl01
               AND gzln02 = g_gzln_t.gzln02 AND gzln07 = g_gzl.gzl17
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gzln[l_ac_k].gzln02,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("upd","gzln_file",g_gzl.gzl00,g_gzln_t.gzln02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                LET g_gzln[l_ac_k].* = g_gzln_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
         END IF
 
      AFTER ROW
         #No.CHI-750028 --start-- 調整位置
         LET l_ac_k = ARR_CURR()
         LET l_ac_t = l_ac_k
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gzln[l_ac_k].* = g_gzln_t.*   
            END IF
            CLOSE p_gzln_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         #No.CHI-750028 ---end---
         CLOSE p_gzln_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gzln02) AND l_ac_k > 1 THEN
            LET g_gzln[l_ac_k].* = g_gzln[l_ac_k - 1].*
            DISPLAY BY NAME g_gzln[l_ac_k].*
            NEXT FIELD gzln02
         END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
       
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   CLOSE p_gzln_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_gzl_s()
   IF ((g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
       (g_gzl.gzl17 IS NULL)) THEN
      CALL cl_err('Mod No. Null','!',1)
      RETURN
   END IF
 
   OPEN WINDOW p_gsyc_w AT 3,18
       WITH FORM "azz/42f/p_gsyc" 
       ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_locale("p_gsyc")
   CALL p_gsyc_b_fill()
 
   CALL cl_set_act_visible("accept",FALSE)
   DISPLAY ARRAY g_gsyc TO s_gsyc.* ATTRIBUTE(COUNT=g_rec_b_s,UNBUFFERED)
 
      ON ACTION detail
         LET INT_FLAG=0
         CALL cl_set_act_visible("accept",TRUE)
         IF (g_gzl.gzl18 = '1') THEN
            CALL p_gsyc_b()
         END IF
         CALL cl_set_act_visible("accept",FALSE)
 
      ON ACTION accept
         LET l_ac_s = ARR_CURR()
         CALL cl_set_act_visible("accept",TRUE)
         IF (g_gzl.gzl18 = '1') THEN
            CALL p_gsyc_b()
         END IF
         CALL cl_set_act_visible("accept",FALSE)
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel
          (ui.Interface.getRootNode(),base.TypeInfo.create(g_gsyc),'','')
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DISPLAY
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE DISPLAY
#TQC-860017 end
   END DISPLAY
   CALL cl_set_act_visible("accept",TRUE)
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_gsyc_w
   END IF
END FUNCTION
 
FUNCTION p_gsyc_b_fill()
   LET g_sql =
      "SELECT gsyc02,gsyc04,gsyc06,gsyc07",
      "  FROM gsyc_file ",
      " WHERE gsyc00 = '",g_gzl.gzl00,"'",
      "   AND gsyc01 = '",g_gzl.gzl01,"'",
      "   AND gsyc08 = '",g_gzl.gzl17,"'",
      " ORDER BY gsyc02,gsyc04"
 
   PREPARE p_gsyc_prepare FROM g_sql      #預備一下
   DECLARE p_gsyc_curs CURSOR FOR p_gsyc_prepare
   CALL g_gsyc.clear()
   LET g_cnt = 1
   FOREACH p_gsyc_curs INTO g_gsyc[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         #TQC-630107---add---
         CALL cl_err( '', 9035, 0 )
         #TQC-630107---end---
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gsyc.deleteElement(g_cnt)
 
   MESSAGE ""
   LET g_rec_b_s = g_cnt-1
   DISPLAY g_rec_b_s TO FORMONLY.cn2
END FUNCTION
 
FUNCTION p_gsyc_b()
   DEFINE   l_allow_insert  LIKE type_file.num5      #可新增否          #No.FUN-680135 SMALLINT
   DEFINE   l_allow_delete  LIKE type_file.num5      #可刪除否          #No.FUN-680135 SMALLINT
   DEFINE   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680135 VARCHAR(1)
            l_sql           LIKE type_file.chr1000,  #No.FUN-680135 VARCHAR(500)
            l_gsyc05        LIKE gsyc_file.gsyc05,   #FUN-680135    VARCHAR(10)
            l_ze            RECORD LIKE ze_file.*,
            l_zz            RECORD LIKE zz_file.*,
            l_zm            RECORD LIKE zm_file.*
   DEFINE   li_cnt          LIKE type_file.num5      #FUN-680135 SMALLINT
   DEFINE   l_key1          LIKE type_file.chr6      #存放各表的KEY值1   #No.FUN-710052
   DEFINE   l_key2          LIKE type_file.chr6      #存放各表的KEY值2   #No.FUN-710052   
   DEFINE   l_str           LIKE type_file.chr1000   #No.FUN-710052   
   DEFINE   l_down          STRING                   #No.FUN-710052
   DEFINE   l_up            STRING                   #No.FUN-710052
 
   MESSAGE ""
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
        "SELECT gsyc02,gsyc04,gsyc06,gsyc07 ",
        "  FROM gsyc_file     ",
        " WHERE gsyc00 = ? ",
        "   AND gsyc01 = ? ",
        "   AND gsyc02 = ? ",
        "   AND gsyc08 = ? ",
        "  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gsyc_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
   LET g_action_choice = ""
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   
   IF g_rec_b_s = 0 THEN
      CALL g_gsyc.clear()
      #沒有資料按下B單身時，自動加2,8,9選項的資料
      IF (g_gzl.gzl18 = "1") THEN
         LET g_gsyc[1].gsyc02 = 1
         LET g_gsyc[1].gsyc04 = "2"
         LET l_gsyc05 = "zz_file"
         LET g_gsyc[1].gsyc06 = g_gzl.gzl05 CLIPPED
         INSERT INTO gsyc_file(gsyc00,gsyc01,gsyc02,gsyc04,gsyc05,gsyc06,gsyc07,gsyc08)
                        VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gsyc[1].gsyc02,
                               g_gsyc[1].gsyc04,l_gsyc05,
                               g_gsyc[1].gsyc06,g_gsyc[1].gsyc07,g_gzl.gzl17)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gsyc[1].gsyc02,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gsyc_file",g_gzl.gzl00,g_gsyc[1].gsyc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
         ELSE
            LET g_rec_b_s = g_rec_b_s + 1
         END IF
 
         SELECT COUNT(*) INTO li_cnt FROM gsyc_file WHERE gsyc04 = "8" AND gsyc06 = g_gzl.gzl05
         IF li_cnt > 0 THEN
            CALL cl_err(g_gzl.gzl05,"azz-727",1)
 
            LET g_gsyc[2].gsyc02 = 2
            LET g_gsyc[2].gsyc04 = "9"
            LET l_gsyc05 = "gak_file"
            LET g_gsyc[2].gsyc06 = g_gzl.gzl05 CLIPPED
            INSERT INTO gsyc_file(gsyc00,gsyc01,gsyc02,gsyc04,gsyc05,gsyc06,gsyc07,gsyc08)
                           VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gsyc[2].gsyc02,
                                  g_gsyc[2].gsyc04,l_gsyc05,
                                  g_gsyc[2].gsyc06,g_gsyc[2].gsyc07,g_gzl.gzl17)
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gsyc[2].gsyc02,SQLCA.sqlcode,0)
               CALL cl_err3("ins","gsyc_file",g_gzl.gzl00,g_gsyc[2].gsyc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            ELSE
               LET g_rec_b_s = g_rec_b_s + 1
            END IF
         ELSE
            LET g_gsyc[2].gsyc02 = 2
            LET g_gsyc[2].gsyc04 = "8"
            LET l_gsyc05 = "gae_file"
            LET g_gsyc[2].gsyc06 = g_gzl.gzl05 CLIPPED
            INSERT INTO gsyc_file(gsyc00,gsyc01,gsyc02,gsyc04,gsyc05,gsyc06,gsyc07,gsyc08)
                           VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gsyc[2].gsyc02,
                                  g_gsyc[2].gsyc04,l_gsyc05,
                                  g_gsyc[2].gsyc06,g_gsyc[2].gsyc07,g_gzl.gzl17)
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gsyc[2].gsyc02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("ins","gsyc_file",g_gzl.gzl00,g_gsyc[2].gsyc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            ELSE
               LET g_rec_b_s = g_rec_b_s + 1
            END IF
 
            LET g_gsyc[3].gsyc02 = 3
            LET g_gsyc[3].gsyc04 = "9"
            LET l_gsyc05 = "gak_file"
            LET g_gsyc[3].gsyc06 = g_gzl.gzl05 CLIPPED
            INSERT INTO gsyc_file(gsyc00,gsyc01,gsyc02,gsyc04,gsyc05,gsyc06,gsyc07,gsyc08)
                           VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gsyc[3].gsyc02,
                                  g_gsyc[3].gsyc04,l_gsyc05,
                                  g_gsyc[3].gsyc06,g_gsyc[3].gsyc07,g_gzl.gzl17)
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gsyc[3].gsyc02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("ins","gsyc_file",g_gzl.gzl00,g_gsyc[3].gsyc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            ELSE
               LET g_rec_b_s = g_rec_b_s + 1
            END IF
         END IF
      END IF
   END IF
 
   LET l_ac_t = 0
   INPUT ARRAY g_gsyc WITHOUT DEFAULTS FROM s_gsyc.* 
      ATTRIBUTE (COUNT=g_rec_b_s,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
                 APPEND ROW = l_allow_insert) 
 
      BEFORE INPUT
         IF g_rec_b_s != 0 THEN
            CALL fgl_set_arr_curr(l_ac_s)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac_s = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b_s >= l_ac_s THEN
            LET p_cmd='u'
            LET g_gsyc_t.* = g_gsyc[l_ac_s].*  #BACKUP
            OPEN p_gsyc_bcl USING g_gzl.gzl00,g_gzl.gzl01,g_gsyc_t.gsyc02,g_gzl.gzl17
            IF STATUS THEN
               CALL cl_err("OPEN p_gsyc_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gsyc_bcl INTO g_gsyc[l_ac_s].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gsyc_t.gsyc02,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               ELSE
                  LET g_gsyc_t.*=g_gsyc[l_ac_s].*
               END IF
               CALL p_gzl_set_required()   #No.TQC-890002
            END IF
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gsyc[l_ac_s].* TO NULL      #900423
         LET g_gsyc_t.* = g_gsyc[l_ac_s].*         #新輸入資料
         NEXT FIELD gsyc02
       
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         CASE g_gsyc[l_ac_s].gsyc04
              WHEN '2' LET l_gsyc05='zz_file'
              WHEN '6' LET l_gsyc05='gao_file'
              WHEN '7' LET l_gsyc05='gae_file'
              WHEN '8' LET l_gsyc05='gae_file'
              WHEN '9' LET l_gsyc05='gak_file'
              WHEN 'A' LET l_gsyc05='gaq_file'
              WHEN 'G' LET l_gsyc05='gat_file'
              WHEN 'H' LET l_gsyc05='wsa_file'
              WHEN 'I' LET l_gsyc05='zaa_file'
              WHEN 'P' LET l_gsyc05='zaw_file'
              WHEN 'Q' LET l_gsyc05='zai_file'
              OTHERWISE CANCEL INSERT
         END CASE
         INSERT INTO gsyc_file(gsyc00,gsyc01,gsyc02,gsyc04,gsyc05,gsyc06,gsyc07,gsyc08)
                        VALUES(g_gzl.gzl00,g_gzl.gzl01,g_gsyc[l_ac_s].gsyc02,
                               g_gsyc[l_ac_s].gsyc04,l_gsyc05,
                               g_gsyc[l_ac_s].gsyc06,g_gsyc[l_ac_s].gsyc07,g_gzl.gzl17)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gsyc[l_ac_s].gsyc02,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gsyc_file",g_gzl.gzl00,g_gsyc[l_ac_s].gsyc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            ROLLBACK WORK
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b_s = g_rec_b_s + 1
            DISPLAY g_rec_b_s TO FORMONLY.cn2
         END IF
 
         BEFORE FIELD gsyc02
            IF cl_null(g_gsyc[l_ac_s].gsyc02) OR g_gsyc[l_ac_s].gsyc02 = 0 THEN
               SELECT MAX(gsyc02)+1 INTO g_gsyc[l_ac_s].gsyc02 FROM gsyc_file
                WHERE gsyc00 = g_gzl.gzl00 AND gsyc01 = g_gzl.gzl01
                  AND gsyc08 = g_gzl.gzl17
                IF cl_null(g_gsyc[l_ac_s].gsyc02) THEN
                   LET g_gsyc[l_ac_s].gsyc02 = 1
                END IF
            END IF
 
         AFTER FIELD gsyc02
            IF g_gsyc[l_ac_s].gsyc02 IS NOT NULL AND
               (g_gsyc[l_ac_s].gsyc02 != g_gsyc_t.gsyc02 OR
                g_gsyc_t.gsyc02 IS NULL) THEN
               SELECT count(*) INTO l_n FROM gsyc_file
                WHERE gsyc00 = g_gzl.gzl00
                  AND gsyc01 = g_gzl.gzl01
                  AND gsyc02 = g_gsyc[l_ac_s].gsyc02
                  AND gsyc08 = g_gzl.gzl17
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gsyc[l_ac_s].gsyc02 = g_gsyc_t.gsyc02
                  NEXT FIELD gsyc02
               END IF
            END IF
 
         BEFORE FIELD gsyc04
            CALL cl_set_comp_entry("gsyc07",TRUE)
            CALL cl_set_comp_required("gsyc07",FALSE)
 
         AFTER FIELD gsyc04
          IF g_gsyc[l_ac_s].gsyc04 IS NOT NULL THEN
            IF g_gsyc[l_ac_s].gsyc04 MATCHES "[268AGHIPQ]" OR    #No.TQC-890002 No.9 cancel
               (g_gsyc[l_ac_s].gsyc04 = "9" AND g_gsyc[l_ac_s].gsyc06 != "lib" AND        #No.TQC-890002 modify condition
                g_gsyc[l_ac_s].gsyc06 != "sub" AND g_gsyc[l_ac_s].gsyc06 != "qry") THEN   #No.TQC-890002 modify condition
               CALL cl_set_comp_entry("gsyc07",FALSE)
            ELSE
               CALL cl_set_comp_required("gsyc07",TRUE)
            END IF
          END IF
#No.FUN-710052 --start--
      IF g_gsyc[l_ac_s].gsyc04 IS NOT NULL THEN
         CASE g_gsyc[l_ac_s].gsyc04                                                                                                 
              WHEN '2' LET l_gsyc05='zz_file'
                       LET l_key1 = 'zz01'
              WHEN '6' LET l_gsyc05='gao_file'
                       LET l_key1 = 'gao01'
              WHEN '7' LET l_gsyc05='gae_file'
                       LET l_key1 = 'gae01'
                       LET l_key2 = 'gae02'
              WHEN '8' LET l_gsyc05='gae_file'
                       LET l_key1 = 'gae01'
              WHEN '9' LET l_gsyc05='gak_file'
                       LET l_key1 = 'gak01'
              WHEN 'A' LET l_gsyc05='gaq_file'
                       LET l_key1 = 'gaq01'
              WHEN 'G' LET l_gsyc05='gat_file'
                       LET l_key1 = 'gat01'
              WHEN 'H' LET l_gsyc05='wsa_file'
                       LET l_key1 = 'wsa01'
              WHEN 'I' LET l_gsyc05='zaa_file'
                       LET l_key1 = 'zaa01'
              WHEN 'P' LET l_gsyc05='zaw_file'
                       LET l_key1 = 'zaw01'
              WHEN 'Q' LET l_gsyc05='zai_file'
                       LET l_key1 = 'zai01'
              OTHERWISE NEXT FIELD gsyc04
         END CASE
       END IF
 
         AFTER FIELD gsyc06
         IF g_gsyc[l_ac_s].gsyc06 IS NOT NULL AND
            (g_gsyc[l_ac_s].gsyc06 != g_gsyc_t.gsyc06 OR
             g_gsyc_t.gsyc06 IS NULL) THEN
            IF g_gsyc[l_ac_s].gsyc04 = "6"  THEN
               LET l_down = g_gsyc[l_ac_s].gsyc06
               LET l_up  = UPSHIFT(l_down)
               LET g_gsyc[l_ac_s].gsyc06 = l_up
            END IF
            LET l_str = " SELECT COUNT(*) FROM ", l_gsyc05 CLIPPED,
                        " WHERE ",l_key1 CLIPPED ," = '", g_gsyc[l_ac_s].gsyc06 CLIPPED,"'"
                 PREPARE l_select0  FROM l_str
                 EXECUTE l_select0  INTO l_n
             IF l_n = 0 THEN
                CALL cl_err('','gzl-001',1)
                ROLLBACK WORK
                LET g_gsyc[l_ac_s].gsyc06 = g_gsyc_t.gsyc06
                NEXT FIELD gsyc06
             END IF
            CALL p_gzl_set_required()   #No.TQC-890002
         END IF
 
       AFTER FIELD gsyc07
         #No.TQC-890002 --start-- modify condition
#        IF g_gsyc[l_ac_s].gsyc04 = "7" AND g_gsyc[l_ac_s].gsyc07 IS NOT NULL THEN
         IF g_gsyc[l_ac_s].gsyc07 IS NOT NULL AND
            (g_gsyc[l_ac_s].gsyc07 != g_gsyc_t.gsyc07 OR g_gsyc_t.gsyc07 IS NULL) THEN
            IF g_gsyc[l_ac_s].gsyc04 = "9" AND (g_gsyc[l_ac_s].gsyc06 = "lib" OR
               g_gsyc[l_ac_s].gsyc06 = "sub" OR g_gsyc[l_ac_s].gsyc06 = "qry") THEN
               LET l_str = "SELECT COUNT(*) FROM gal_file",
                           " WHERE gal01 = '",g_gsyc[l_ac_s].gsyc06 CLIPPED,"'",
                           "   AND gal03 = '",g_gsyc[l_ac_s].gsyc07 CLIPPED,"'"
               PREPARE l_galcheck FROM l_str
               EXECUTE l_galcheck INTO l_n
            ELSE
         #No.TQC-890002 ---end---
               LET  l_str = " SELECT COUNT(*) FROM ",l_gsyc05 CLIPPED,                                                                 
                            " WHERE ",l_key1 CLIPPED ," = '", g_gsyc[l_ac_s].gsyc06 CLIPPED,"'",                                       
                            " AND ",  l_key2 CLIPPED ," = '", g_gsyc[l_ac_s].gsyc07 CLIPPED,"'"                                        
                                                                                                                                       
                    PREPARE l_select1  FROM l_str                                                                                      
                    EXECUTE l_select1  INTO l_n                                                                                        
            END IF   #No.TQC-890002
            IF l_n = 0 THEN                                                                                                        
               ROLLBACK WORK                                                                                                       
               CALL cl_err('','gzl-001',1)                                                                                         
               LET g_gsyc[l_ac_s].gsyc07 = g_gsyc_t.gsyc07                                                                         
               NEXT FIELD gsyc07                                                                                                   
            END IF                                                                                                                 
         END IF
#No.FUN-710052 ---end---
 
         BEFORE DELETE                            #是否取消單身
            IF g_gsyc_t.gsyc02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               
               IF l_lock_sw = 'Y' THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM gsyc_file
                   WHERE gsyc00 = g_gzl.gzl00
                     AND gsyc01 = g_gzl.gzl01
                     AND gsyc02 = g_gsyc_t.gsyc02
                     AND gsyc08 = g_gzl.gzl17
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_gsyc_t.gsyc02,SQLCA.sqlcode,0)  #No.FUN-660081
                  CALL cl_err3("del","gsyc_file",g_gzl.gzl00,g_gsyc_t.gsyc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE     
                  LET g_rec_b_s = g_rec_b_s-1
                  DISPLAY g_rec_b_s TO FORMONLY.cn2
                  MESSAGE 'Delete ok!'
                  COMMIT WORK
               END IF
            END IF
 
         ON ROW CHANGE
#No.FUN-710052 --start--                                                                                                            
         CASE g_gsyc[l_ac_s].gsyc04                                                                                                 
              WHEN '2' LET l_gsyc05='zz_file'                                                                                       
                       LET l_key1 = 'zz01'                                                                                          
              WHEN '6' LET l_gsyc05='gao_file'                                                                                      
                       LET l_key1 = 'gao01'                                                                                         
              WHEN '7' LET l_gsyc05='gae_file'                                                                                      
                       LET l_key1 = 'gae01'                                                                                         
                       LET l_key2 = 'gae02'                                                                                         
              WHEN '8' LET l_gsyc05='gae_file'                                                                                      
                       LET l_key1 = 'gae01'                                                                                         
              WHEN '9' LET l_gsyc05='gak_file'                                                                                      
                       LET l_key1 = 'gak01'                                                                                         
              WHEN 'A' LET l_gsyc05='gaq_file'                                                                                      
                       LET l_key1 = 'gaq01'                                                                                         
              WHEN 'G' LET l_gsyc05='gat_file'                                                                                      
                       LET l_key1 = 'gat01'                                                                                         
              WHEN 'H' LET l_gsyc05='wsa_file'
                       LET l_key1 = 'wsa01'
              WHEN 'I' LET l_gsyc05='zaa_file'                                                                                      
                       LET l_key1 = 'zaa01'                                                                                         
              WHEN 'P' LET l_gsyc05='zaw_file'                                                                                      
                       LET l_key1 = 'zaw01'                                                                                         
              WHEN 'Q' LET l_gsyc05='zai_file'                                                                                      
                       LET l_key1 = 'zai01'                                                                                         
              OTHERWISE NEXT FIELD gsyc04                                                                                           
         END CASE                                                                                                                   
          IF g_gsyc[l_ac_s].gsyc07 IS NULL THEN                                                                                     
             LET l_str = " SELECT COUNT(*) FROM ", l_gsyc05 CLIPPED,                                                                
                         " WHERE ",l_key1 CLIPPED ," = '", g_gsyc[l_ac_s].gsyc06 CLIPPED,"'"                                        
          ELSE                                                                                                                      
            LET  l_str = " SELECT COUNT(*) FROM ",l_gsyc05 CLIPPED,                                                                 
                         " WHERE ",l_key1 CLIPPED ," = '", g_gsyc[l_ac_s].gsyc06 CLIPPED,"'",                                       
                         " AND ",  l_key2 CLIPPED ," = '", g_gsyc[l_ac_s].gsyc07 CLIPPED,"'"                                        
          END IF                                                                                                                    
          PREPARE l_select5 FROM l_str                                                                                              
          EXECUTE l_select5 INTO l_n
             IF l_n = 0 THEN                                                                                                        
                CALL cl_err('','gzl-001',1)                                                                                         
                ROLLBACK WORK                                                                                                       
                LET g_gsyc[l_ac_s].gsyc06 = g_gsyc_t.gsyc06                                                                         
                NEXT FIELD gsyc06                                                                                                   
             END IF                                                                                                                 
                                                                                                                                    
#No.FUN-710052 ---end---
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gsyc[l_ac_s].* = g_gsyc_t.*
               CLOSE p_gsyc_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err('lock err',-263,1)
               LET g_gsyc[l_ac_s].* = g_gsyc_t.*
            ELSE
               #No.TQC-890002 --start-- modify condition
#              IF g_gsyc[l_ac_s].gsyc04 MATCHES '[47]' THEN
               IF g_gsyc[l_ac_s].gsyc04 MATCHES '[47]' OR
                  (g_gsyc[l_ac_s].gsyc04 = "9" AND (g_gsyc[l_ac_s].gsyc06 = "lib" OR
                   g_gsyc[l_ac_s].gsyc06 = "sub" OR g_gsyc[l_ac_s].gsyc06 = "qry")) THEN
               #No.TQC-890002 ---end---
                  IF cl_null(g_gsyc[l_ac_s].gsyc06) OR
                     cl_null(g_gsyc[l_ac_s].gsyc07) THEN
                     CALL cl_err('Both two key value columns required','!',1)
                     ROLLBACK WORK
                     LET g_gsyc[l_ac_s].* = g_gsyc_t.*
                     CONTINUE INPUT
                  END IF
               ELSE
                  IF cl_null(g_gsyc[l_ac_s].gsyc06) THEN
                     CALL cl_err('first key value column required','!',1)
                     ROLLBACK WORK
                     LET g_gsyc[l_ac_s].* = g_gsyc_t.*
                     CONTINUE INPUT
                  END IF
                  IF NOT cl_null(g_gsyc[l_ac_s].gsyc07) THEN
                     CALL cl_err('second key value column is not required','!',1)
                     ROLLBACK WORK
                     LET g_gsyc[l_ac_s].* = g_gsyc_t.*
                     CONTINUE INPUT
                  END IF
               END IF
 
               CASE g_gsyc[l_ac_s].gsyc04
                    WHEN '2' LET l_gsyc05='zz_file'
                    WHEN '6' LET l_gsyc05='gao_file'
                    WHEN '7' LET l_gsyc05='gae_file'
                    WHEN '8' LET l_gsyc05='gae_file'
                    WHEN '9' LET l_gsyc05='gak_file'
                    WHEN 'A' LET l_gsyc05='gaq_file'
                    WHEN 'G' LET l_gsyc05='gat_file'
                    WHEN 'H' LET l_gsyc05='wsa_file'
                    WHEN 'I' LET l_gsyc05='zaa_file'
                    WHEN 'P' LET l_gsyc05='zaw_file'
                    WHEN 'Q' LET l_gsyc05='zai_file'
                    OTHERWISE ROLLBACK WORK
                              EXIT INPUT
               END CASE
               UPDATE gsyc_file 
                  SET gsyc02= g_gsyc[l_ac_s].gsyc02,
                      gsyc04= g_gsyc[l_ac_s].gsyc04,
                      gsyc05= l_gsyc05,
                      gsyc06= g_gsyc[l_ac_s].gsyc06,
                      gsyc07= g_gsyc[l_ac_s].gsyc07
                WHERE gsyc00 = g_gzl.gzl00 AND gsyc01 = g_gzl.gzl01
                  AND gsyc02 = g_gsyc_t.gsyc02 AND gsyc08 = g_gzl.gzl17
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_gsyc[l_ac_s].gsyc02,SQLCA.sqlcode,0)  #No.FUN-660081
                  CALL cl_err3("upd","gsyc_file",g_gzl.gzl00,g_gsyc_t.gsyc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                  LET g_gsyc[l_ac_s].* = g_gsyc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
         AFTER ROW
            LET l_ac_s = ARR_CURR()
            LET l_ac_t = l_ac_s
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_gsyc[l_ac_s].* = g_gsyc_t.*   
                END IF
               CLOSE p_gsyc_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p_gsyc_bcl
            COMMIT WORK
 
         ON ACTION  CONTROLO                        #沿用所有欄位
            IF INFIELD(gsyc02) AND l_ac_s > 1 THEN
                LET g_gsyc[l_ac_s].* = g_gsyc[l_ac_s-1].*
                DISPLAY g_gsyc[l_ac_s].* TO s_gsyc[l_ac_s].* 
                NEXT FIELD gsyc02
            END IF
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
       
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
   END INPUT
 
   CLOSE p_gsyc_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_gzl_pack()
   DEFINE   l_cmd          STRING
   DEFINE   l_result       LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE   l_result2      LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE   l_wc           STRING
   DEFINE   l_path         STRING
   DEFINE   l_select       LIKE type_file.chr1     #FUN-680135 VARCHAR(1)
   DEFINE   ls_tempdir     STRING
   DEFINE   lr_item        DYNAMIC ARRAY OF RECORD
               bugno       LIKE gzl_file.gzl00,
               item        LIKE gzl_file.gzl01,
               ver         LIKE gzl_file.gzl17
                           END RECORD
   DEFINE   ls_sql         STRING
   DEFINE   li_cnt         LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE   l_date         LIKE type_file.chr20    #FUN-680135 VARCHAR(12)
   DEFINE   li_i           LIKE type_file.num5     #FUN-680135 SMALLINT
 
   # 傳入要打包的名稱，因為pack回來的check只能依照擋案有無產生判斷成不成功
   # 又因為gzl的打包方式要用日期加時間，所以必須先傳好檔名
   LET l_date = TODAY USING "yymmdd",cl_replace_str(TIME,":","")
 
   OPEN WINDOW p_gzl_pack_w AT 10,10 WITH FORM "azz/42f/p_gzl_pack"
    ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("p_gzl_pack")
 
   # 打包的條件要自己下，且傳入pack的是條件而不是單號
   CONSTRUCT l_wc ON gzl00,gzl01 FROM gzl00,gzl01 
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE CONSTRUCT
#TQC-860017 end
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_gzl_pack_w
      RETURN
   END IF
 
   # 打包的路徑，是否打包共用資料
   WHILE TRUE
      LET g_action_choice = ""
      INPUT l_path,l_select WITHOUT DEFAULTS FROM FORMONLY.path,FORMONLY.com_dt
         BEFORE INPUT
            LET l_path = FGL_GETENV("CUST")
            DISPLAY l_path TO FORMONLY.path
           #LET l_select = "Y"
            LET l_select = "N"    #FUN-820068
            DISPLAY l_select TO FORMONLY.com_dt
   
         AFTER INPUT
            CALL GET_FLDBUF(FORMONLY.path) RETURNING l_path
            CALL GET_FLDBUF(FORMONLY.com_dt) RETURNING l_select
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT INPUT
   
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION view_list
            LET g_action_choice = "view_list"
            EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      # 依照輸入條件找出目前可打包的東西
      LET ls_sql = "SELECT gzl00,gzl01,gzl17 FROM gzl_file",
                   " WHERE ",l_wc," AND gzl18 = '3'",
                   " ORDER BY gzl00,gzl01,gzl17"
      PREPARE item_pre FROM ls_sql
      DECLARE item_curs CURSOR FOR item_pre
      
      LET li_cnt = 1
      FOREACH item_curs INTO lr_item[li_cnt].*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL lr_item.deleteElement(li_cnt)
 
      # 如果按下查看清單就把清單show出來，沒有按就離開
      IF g_action_choice = "view_list" THEN
         DISPLAY ARRAY lr_item TO s_item.* ATTRIBUTE(COUNT=li_cnt-1,UNBUFFERED)
            ON ACTION cancel
               LET INT_FLAG = 1
               EXIT DISPLAY
            ON ACTION exit
               LET INT_FLAG = 1
               EXIT DISPLAY
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE DISPLAY
#TQC-860017 end        
         END DISPLAY
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      # 清單內有東西才進打包程式，沒有就show沒有東西可打包
      IF lr_item.getLength() > 0 THEN
   display 'l_wc=',l_wc
#        LET l_cmd = "$FGLRUN $DS4GL/bin/pack_cust.42r '",l_path,"' '",cl_replace_str(l_wc,"'","\""),"' '",l_select,"' '",l_date,"'"    #No.CHI-750028
         LET l_cmd = '$FGLRUN $DS4GL/bin/pack_cust.42r "',l_path,'" "',l_wc,'" "',l_select,'" "',l_date,'"'    #No.CHI-750028
   display 'l_cmd=',l_cmd
         RUN l_cmd
         LET l_cmd = "ls $TEMPDIR/patch_",l_date CLIPPED,".tar"
         RUN l_cmd RETURNING l_result
         IF l_result THEN
            CALL cl_err(l_cmd,"azz-725",1)
            CLOSE WINDOW p_gzl_pack_w
            RETURN
         ELSE
            #No.CHI-750028 --start-- 改地方
            FOR li_i = 1 TO lr_item.getLength()
               UPDATE gzl_file SET gzl18 = "4"
                WHERE gzl00 = lr_item[li_i].bugno AND gzl01 = lr_item[li_i].item AND gzl17 = lr_item[li_i].ver
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gzl.gzl00,"azz-711",0)  #No.TQC-7C0159
               END IF
            END FOR
            #No.CHI-750028 ---end---
         END IF
         LET ls_tempdir = FGL_GETENV("TEMPDIR")
         #下載.sh的檔案
         CALL cl_download_file(ls_tempdir || "/patch_" || l_date CLIPPED || ".sh","C:/gppatch/patch_" || l_date CLIPPED || ".sh") RETURNING l_result
         #下載.tar的檔案
         CALL cl_download_file(ls_tempdir || "/patch_" || l_date CLIPPED || ".tar","C:/gppatch/patch_" || l_date CLIPPED || ".tar") RETURNING l_result2
         IF l_result AND l_result2 THEN
            CALL cl_err_msg("Download Success","azz-709", l_date CLIPPED || "|" || l_date CLIPPED || "|C:/gppatch",1)   #No.FUN-780083
         ELSE
            CALL cl_err_msg("Download Failed","azz-708", l_date CLIPPED || "|" || l_date CLIPPED || "|C:/gppatch",1)    #No.FUN-780083
         END IF
      ELSE
         CALL cl_err("","azz-718",1)
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE WINDOW p_gzl_pack_w
 
END FUNCTION
 
FUNCTION p_gzl_pack_zs()
   DEFINE   l_cmd          STRING
   DEFINE   l_result       LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE   l_result2      LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE   l_wc           STRING
   DEFINE   l_path         STRING
   DEFINE   l_select       LIKE type_file.chr1     #FUN-680135 VARCHAR(1)
   DEFINE   ls_tempdir     STRING
   DEFINE   lr_item        DYNAMIC ARRAY OF RECORD
               bugno       LIKE gzl_file.gzl00,
               item        LIKE gzl_file.gzl01,
               ver         LIKE gzl_file.gzl17
                           END RECORD
   DEFINE   ls_sql         STRING
   DEFINE   li_cnt         LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE   l_date         LIKE type_file.chr20    #FUN-680135 VARCHAR(12)
   DEFINE   li_i           LIKE type_file.num5     #FUN-680135 SMALLINT
 
 
   LET l_date = TODAY USING "yymmdd",cl_replace_str(TIME,":","")
 
   OPEN WINDOW p_gzl_pack_w AT 10,10 WITH FORM "azz/42f/p_gzl_pack"
    ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("p_gzl_pack")
 
   # 打包的條件要自己下，且傳入pack的是條件而不是單號
   CONSTRUCT l_wc ON gzl00,gzl01 FROM gzl00,gzl01
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE CONSTRUCT
#TQC-860017 end
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_gzl_pack_w
      RETURN
   END IF
 
   WHILE TRUE
      LET g_action_choice = ""
      INPUT l_path,l_select WITHOUT DEFAULTS FROM FORMONLY.path,FORMONLY.com_dt
         BEFORE INPUT
            LET l_path = FGL_GETENV("CUST")
            DISPLAY l_path TO FORMONLY.path
            LET l_select = "Y"
            DISPLAY l_select TO FORMONLY.com_dt
 
         AFTER INPUT
            CALL GET_FLDBUF(FORMONLY.path) RETURNING l_path
            CALL GET_FLDBUF(FORMONLY.com_dt) RETURNING l_select
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION view_list
            LET g_action_choice = "view_list"
            EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
       
       LET ls_sql = "SELECT gzl00,gzl01,gzl17 FROM gzl_file",
                    " WHERE ",l_wc," AND gzl18 = '3'",
                    " ORDER BY gzl00,gzl01,gzl17"
       PREPARE item_pre1 FROM ls_sql
       DECLARE item_curs1 CURSOR FOR item_pre1
       
       LET li_cnt = 1
       FOREACH item_curs1 INTO lr_item[li_cnt].*
          IF SQLCA.sqlcode THEN
             EXIT FOREACH
          END IF
          LET li_cnt = li_cnt + 1
          #TQC-630107---add---
          IF li_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
          END IF
          #TQC-630107---end---
       END FOREACH
       CALL lr_item.deleteElement(li_cnt)
 
      IF g_action_choice = "view_list" THEN
         DISPLAY ARRAY lr_item TO s_item.* ATTRIBUTE(COUNT=li_cnt-1,UNBUFFERED)
            ON ACTION cancel
               LET INT_FLAG = 1
               EXIT DISPLAY
            ON ACTION exit
               LET INT_FLAG = 1
               EXIT DISPLAY
 #TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE DISPLAY
#TQC-860017 end        
         END DISPLAY
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
 
#   CALL cl_set_comp_visible("com_dt,gzl00,gzl01",0)
#       CALL cl_set_comp_visible("com_dt,path",0)
 
 
      IF lr_item.getLength() > 0 THEN
#        LET l_cmd = "$FGLRUN $DS4GL/bin/pack_cust.42r '",l_path,"' '",cl_replace_str(l_wc,"'","\""),"' '",l_select,"' '",l_date,"' 'Y'"     #No.CHI-750028
         LET l_cmd = '$FGLRUN $DS4GL/bin/pack_cust.42r "',l_path,'" "',l_wc,'" "',l_select,'" "',l_date,'" "Y"'     #No.CHI-750028
display l_cmd
          RUN l_cmd
          LET l_cmd = "ls $TEMPDIR/patch_",l_date CLIPPED,"_tab.tar"
          RUN l_cmd RETURNING l_result
          IF l_result THEN
             #MESSAGE 'make file error'   #MOD-6B0039
             CALL cl_err(l_cmd,"azz-725",1)   #MOD-6B0039
             CLOSE WINDOW p_gzl_pack_w   #MOD-6B0039
             RETURN
          END IF
          LET ls_tempdir = FGL_GETENV("TEMPDIR")
          CALL cl_download_file(ls_tempdir || "/patch_" || l_date CLIPPED || "_tab.tar","C:/gppatch/patch_" || l_date CLIPPED || "_tab.tar") RETURNING l_result
          CALL cl_download_file(ls_tempdir || "/patch_" || l_date CLIPPED || "_tab.sh","C:/gppatch/patch_" || l_date CLIPPED || "_tab.sh") RETURNING l_result2
          IF l_result AND l_result2 THEN
             CALL cl_err_msg("Download Success","azz-709", l_date CLIPPED || "_tab" || "|" || l_date CLIPPED || "_tab" || "|C:/gppatch",1)  #No.FUN-780083
          ELSE
             CALL cl_err_msg("Download Failed","azz-708",l_date CLIPPED || "_tab" || "|" || l_date CLIPPED || "_tab" || "|C:/gppatch",1)    #No.FUN-780083
          END IF
 
#      FOR li_i = 1 TO lr_item.getLength()
#         UPDATE gzl_file SET gzl18 = "4"
#          WHERE gzl00 = g_gzl.gzl00 AND gzl01 = lr_item[li_i].item AND gzl17 = lr_item[li_i].ver
#         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_gzl.gzl00,"azz-711",0)
#         END IF
#      END FOR
--      SELECT * INTO g_gzl.* FROM gzl_file
--       WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01 AND gzl17 = g_gzl.gzl17
--      CALL p_gzl_show()
       ELSE
          CALL cl_err("","azz-718",1)
       END IF
       EXIT WHILE
   END WHILE
   CLOSE WINDOW p_gzl_pack_w
END FUNCTION
 
FUNCTION p_gzl_zs()
DEFINE l_cmd STRING,
       l_num STRING,
       l_ver STRING
 
   IF ((g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
       (g_gzl.gzl17 IS NULL)) THEN
      CALL cl_err('Mod No. Null','!',1)
      RETURN
   END IF
   LET l_num=g_gzl.gzl01
   LET l_ver=g_gzl.gzl17
   LET l_cmd = "p_zs '' '' '",g_gzl.gzl00 CLIPPED,"-",l_num,"-",l_ver,"'"
display l_cmd
   CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION p_gzl_w()
DEFINE l_cmd STRING,
       l_num STRING,
       l_ver STRING
 
   IF ((g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
       (g_gzl.gzl17 IS NULL)) THEN
      CALL cl_err('Mod No. Null','!',1)
      RETURN
   END IF
   LET l_num=g_gzl.gzl01 clipped
   LET l_ver=g_gzl.gzl17 clipped
   LET l_cmd = 'cd $AZZ/4gl;r.r2 p_zta ',"'",g_gzl.gzl00 CLIPPED,"-",
                                             l_num,"-",
                                             l_ver,"'" 
display l_cmd
   RUN l_cmd 
END FUNCTION
 
FUNCTION p_gzl_confirm(p_dept)
   DEFINE   p_dept     STRING
   DEFINE   li_result  LIKE type_file.num5          #No.FUN-680135 SMALLINT
 
 
   IF ((g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
       (g_gzl.gzl17 IS NULL)) THEN
      CALL cl_err('Mod No. Null','!',1)
      RETURN
   END IF
 
   LET p_dept = p_dept.toUpperCase()
 
   CASE p_dept
      WHEN "TSD"
         IF (g_gzl.gzl18 != "3" AND g_gzl.gzl18 != "4") THEN
            CALL cl_confirm("azz-713") RETURNING li_result
            IF li_result THEN
               UPDATE gzl_file SET gzl18 = "2",gzl13 = g_user,gzl15 = TODAY
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
                  AND gzl17 = g_gzl.gzl17
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gzl.gzl00,"azz-711",0)  #No.TQC-7C0159
               #No.FUN-830042 --start--
               ELSE
                  CALL p_gzl_file_chmod()
               #No.FUN-830042 ---end---
               END IF
            END IF
         ELSE
            CALL cl_err(g_gzl.gzl18,"azz-712",0)
         END IF
      WHEN "SC"
         IF (g_gzl.gzl18 != "1" AND g_gzl.gzl18 != "4") THEN
            CALL cl_confirm("azz-713") RETURNING li_result
            IF li_result THEN
               UPDATE gzl_file SET gzl18 = "3",gzl19 = g_user,gzl20 = TODAY
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
                  AND gzl17 = g_gzl.gzl17
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gzl.gzl00,"azz-711",0)  #No.TQC-7C0159
               END IF
            END IF
         ELSE
            CALL cl_err(g_gzl.gzl18,"azz-712",0)
         END IF
   END CASE
   SELECT * INTO g_gzl.* FROM gzl_file
    WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01 AND gzl17 = g_gzl.gzl17
   CALL p_gzl_show()
END FUNCTION
 
FUNCTION p_gzl_undo_confirm(p_dept)
   DEFINE   p_dept     STRING
   DEFINE   li_result  LIKE type_file.num5          #No.FUN-680135 SMALLINT
 
 
   IF ((g_gzl.gzl00 IS NULL) OR (g_gzl.gzl01 IS NULL) OR
       (g_gzl.gzl17 IS NULL)) THEN
      CALL cl_err('Mod No. Null','!',1)
      RETURN
   END IF
 
   LET p_dept = p_dept.toUpperCase()
 
   CASE p_dept
      WHEN "TSD"
         IF (g_gzl.gzl18 != "3" AND g_gzl.gzl18 != "4") THEN
            CALL cl_confirm("aim-304") RETURNING li_result   #No.TQC-7C0159
            IF li_result THEN
               UPDATE gzl_file SET gzl18 = "1"
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
                  AND gzl17 = g_gzl.gzl17
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gzl.gzl00,"azz-711",0)  #No.TQC-7C0159
               END IF
            END IF
         ELSE
            CALL cl_err(g_gzl.gzl18,"azz-712",0)
         END IF
      WHEN "SC"
         IF (g_gzl.gzl18 != "1" AND g_gzl.gzl18 != "2" AND g_gzl.gzl18 != "4") THEN
            CALL cl_confirm("aim-304") RETURNING li_result   #No.TQC-7C0159
            IF li_result THEN
               UPDATE gzl_file SET gzl18 = "2"
                WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01
                  AND gzl17 = g_gzl.gzl17
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gzl.gzl00,"azz-711",0)  #No.TQC-7C0159
               END IF
            END IF
         ELSE
            CALL cl_err(g_gzl.gzl18,"azz-712",0)
         END IF
   END CASE
   SELECT * INTO g_gzl.* FROM gzl_file
    WHERE gzl00 = g_gzl.gzl00 AND gzl01 = g_gzl.gzl01 AND gzl17 = g_gzl.gzl17
   CALL p_gzl_show()
END FUNCTION
 
FUNCTION p_gzl_gzl05()                # 程式名稱直接抓客製
   DEFINE   l_gaz03      LIKE gaz_file.gaz03
 
   SELECT gaz03 INTO l_gaz03 FROM gaz_file
    WHERE gaz01 = g_gzl.gzl05 AND gaz02 = g_lang AND gaz05 = "Y"
 
   IF l_gaz03 IS NULL THEN
      SELECT gaz03 INTO l_gaz03 FROM gaz_file
       WHERE gaz01 = g_gzl.gzl05 AND gaz02 = g_lang AND gaz05 = "N"
   END IF
 
   IF SQLCA.sqlcode THEN
      LET l_gaz03 = ''
      RETURN
   END IF
 
   DISPLAY l_gaz03 TO FORMONLY.zz02
END FUNCTION
 
FUNCTION p_gzl_zx01(p_cmd,p_code,p_seq)
   DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
          p_code       LIKE zx_file.zx01,
          p_seq        LIKE type_file.chr1,          #FUN-680135 VARCHAR(1)
          l_zx02       LIKE zx_file.zx02
 
   LET g_errno = ' '
   SELECT zx02 INTO l_zx02 FROM zx_file
    WHERE zx01 = p_code    
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                  LET l_zx02  = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      CASE 
         WHEN p_seq = '1'   DISPLAY l_zx02 TO FORMONLY.zx02
         WHEN p_seq = '2'   DISPLAY l_zx02 TO FORMONLY.zx02_2
      END CASE
   ELSE
      CASE 
         WHEN p_seq = '1'   DISPLAY NULL TO FORMONLY.zx02
         WHEN p_seq = '2'   DISPLAY NULL TO FORMONLY.zx02_2
      END CASE
   END IF  
END FUNCTION
 
FUNCTION p_gzl_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1           #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = "a"  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gzl00,gzl01,gzl17",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_gzl_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1           #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = "u"  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gzl00,gzl01,gzl17",FALSE)
   END IF
END FUNCTION
 
#No.FUN-830042 --start--
FUNCTION p_gzl_file_chmod()
   DEFINE ls_topcust   STRING
   DEFINE ls_cm_tool   STRING
   DEFINE li_cnt       LIKE type_file.num5
   DEFINE ls_cmd       STRING
   DEFINE ls_file      STRING
 
   LET ls_topcust = FGL_GETENV("CUST")
   LET ls_cm_tool = FGL_GETENV("TOP"),"/bin/sbin/ch_file_mode_gp"
   CALL p_gzln_b_fill()
   FOR li_cnt = 1 TO g_gzln.getLength()
       CASE g_gzln[li_cnt].gzln04
          WHEN "4gl"
             LET ls_cmd = ls_cm_tool," ",ls_topcust,os.Path.separator(),
                          g_gzln[li_cnt].gzln03 CLIPPED,os.Path.separator(),
                          g_gzln[li_cnt].gzln04 CLIPPED,os.Path.separator(),
                          g_gzln[li_cnt].gzln05 CLIPPED," to_tiptop_per"
             RUN ls_cmd
          WHEN "4fd"
             LET ls_file = g_gzln[li_cnt].gzln05
             LET ls_file = ls_file.subString(1,ls_file.getIndexOf(".4fd",1)-1)
             LET ls_cmd = ls_cm_tool," ",ls_topcust,os.Path.separator(),
                          g_gzln[li_cnt].gzln03 CLIPPED,os.Path.separator(),
                          g_gzln[li_cnt].gzln04 CLIPPED,os.Path.separator(),
                          g_gzln[li_cnt].gzln05 CLIPPED," to_tiptop_per"
             RUN ls_cmd
             LET ls_cmd = ls_cm_tool," ",ls_topcust,os.Path.separator(),
                          g_gzln[li_cnt].gzln03 CLIPPED,os.Path.separator(),
                          "per",os.Path.separator(),ls_file,".per to_tiptop_per"
             RUN ls_cmd
             LET ls_cmd = ls_cm_tool," ",ls_topcust,os.Path.separator(),
                          g_gzln[li_cnt].gzln03 CLIPPED,os.Path.separator(),
                          "sdd",os.Path.separator(),ls_file,".sdd to_tiptop_per"
             RUN ls_cmd
       END CASE
   END FOR
END FUNCTION
#No.FUN-830042 ---end---
 
#No.TQC-890002 --start--
FUNCTION p_gzl_set_required()
   CALL cl_set_comp_entry("gsyc07",TRUE)
   CALL cl_set_comp_required("gsyc07",FALSE)
   IF g_gsyc[l_ac_s].gsyc04 MATCHES "[268AGHIPQ]" OR
      (g_gsyc[l_ac_s].gsyc04 = "9" AND g_gsyc[l_ac_s].gsyc06 != "lib" AND        #No.TQC-890002 modify condition
       g_gsyc[l_ac_s].gsyc06 != "sub" AND g_gsyc[l_ac_s].gsyc06 != "qry") THEN   #No.TQC-890002 modify condition
      CALL cl_set_comp_entry("gsyc07",FALSE)
   END IF
   IF g_gsyc[l_ac_s].gsyc04 = "9" AND (g_gsyc[l_ac_s].gsyc06 = "lib" OR
      g_gsyc[l_ac_s].gsyc06 = "qry" OR g_gsyc[l_ac_s].gsyc06 = "sub") THEN
      CALL cl_set_comp_required("gsyc07",TRUE)
   END IF
END FUNCTION
#No.TQC-890002 ---end---
