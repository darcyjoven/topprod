# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri052.4gl
# Descriptions...: 员工加班计划处理参数维护
# Date & Author..: 13/05/23 By Yeap1

IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義
 
DEFINE g_hrcl                 RECORD LIKE hrcl_file.*
DEFINE g_hrcl_t               RECORD LIKE hrcl_file.*      #備份舊值
DEFINE g_hrcl01_t             LIKE hrcl_file.hrcl01         #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE g_rec_b,l_ac          LIKE type_file.num5
DEFINE g_bp_flag             LIKE type_file.chr10
DEFINE g_hrcl_1    DYNAMIC ARRAY OF RECORD 
         hrcl01     LIKE hrcl_file.hrcl01,
         hrcl02     LIKE hrcl_file.hrcl02,
         hrcl03     LIKE hrcl_file.hrcl03,
         hrcl04     LIKE hrcl_file.hrcl04,
         hrcl26     LIKE hrcl_file.hrcl26
                   END RECORD 
 
MAIN
    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("GHR")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_hrcl.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM hrcl_file WHERE hrcl01 = ?  FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i052_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i052_w WITH FORM "ghr/42f/ghri052"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊
 
   LET g_action_choice = ""
   CALL cl_set_act_visible("hrcl01", FALSE)
   CALL i052_menu()                                         #進入選單 Menu
 
   CLOSE WINDOW i052_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i052_curs()

    CLEAR FORM
    INITIALIZE g_hrcl.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hrcl02,hrcl03,hrcl04,hrcluser,hrclgrup,hrclmodu,hrcldate,hrclorig,hrcloriu

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrcl02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrcl.hrcl02
                 CALl cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcl02
                 NEXT FIELD hrcl02
 
              WHEN INFIELD(hrcl03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                  IF g_hrcl.hrcl02 is NULL THEN 
                     LET g_qryparam.state = "c"
                  ELSE 
                     LET g_qryparam.arg1 = g_hrcl.hrcl02
                  END IF
                 LET g_qryparam.default1 = g_hrcl.hrcl03
                 CALl cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcl03
                 NEXT FIELD hrcl03
 
              WHEN INFIELD(hrcl04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                # LET g_qryparam.state = "c" marked by yeap NO.130718
                 LET g_qryparam.arg1 = "008"
                 LET g_qryparam.default1 = g_hrcl.hrcl04
                 CALl cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcl04
                 NEXT FIELD hrcl04
 
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  

      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT
 
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcluser', 'hrclgrup')                                                               #若本table無此欄位

    LET g_sql = "SELECT hrcl01 FROM hrcl_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY hrcl01"
    PREPARE i052_prepare FROM g_sql
    DECLARE i052_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i052_prepare

    LET g_sql = "SELECT COUNT(*) FROM hrcl_file WHERE ",g_wc CLIPPED
    PREPARE i052_precount FROM g_sql
    DECLARE i052_count CURSOR FOR i052_precount
END FUNCTION
 

FUNCTION i052_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
	#---------------added BY yeap NO.130829---------STR-----------
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i052_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add 
	#---------------added BY yeap NO.130829---------END-----------      
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i052_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i052_q()
            END IF

        ON ACTION next
            CLEAR FORM 
            CALL i052_fetch('N')

        ON ACTION previous
            CLEAR FORM 
            CALL i052_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i052_u()
            END IF

        ON ACTION invalid

        
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i052_r()
            END IF


       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN 
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF
               LET l_cmd = 'p_query "ghri052" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)                             
            END IF
 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i052_fetch('/')

        ON ACTION first
            CALL i052_fetch('F')

        ON ACTION last
            CALL i052_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about      
           CALL cl_about() 
 
        ON ACTION generate_link
           CALL cl_generate_shortcut()
 
        ON ACTION close 
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrcl.hrcl01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrcl01"
                 LET g_doc.value1 = g_hrcl.hrcl01
                 CALL cl_doc()
              END IF
           END IF

         &include "qry_string.4gl"
    END MENU
    CLOSE i052_cs
END FUNCTION
 
 
FUNCTION i052_a()


    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hrcl.* LIKE hrcl_file.*
    LET g_hrcl01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrcl.hrcl05 = 'N'
        LET g_hrcl.hrcl06 = 'Y'
        LET g_hrcl.hrcl07 = '30'
        LET g_hrcl.hrcl08 = 'Y'
        LET g_hrcl.hrcl09 = '30'
        LET g_hrcl.hrcl10 = 'N'
        LET g_hrcl.hrcl11 = '1'
        LET g_hrcl.hrcl12 = 'N'
        LET g_hrcl.hrcl13 = '1'
        LET g_hrcl.hrcl14 = 'N'
        LET g_hrcl.hrcl15 = 'N'
        LET g_hrcl.hrcl16 = '1'
        LET g_hrcl.hrcl17 = 'N'
        LET g_hrcl.hrcl18 = '1'
        LET g_hrcl.hrcl19 = '60'
        LET g_hrcl.hrcl20 = '30'
        LET g_hrcl.hrcl21 = 'Y'
        LET g_hrcl.hrcl22 = 'Y'
        LET g_hrcl.hrcl23 = 'Y'
        LET g_hrcl.hrcl24 = 'N'
        LET g_hrcl.hrcl25 = 'N'
        LET g_hrcl.hrcl27 = 'Y'
        LET g_hrcl.hrcluser = g_user
        LET g_hrcl.hrcloriu = g_user 
        LET g_hrcl.hrclorig = g_grup 
        LET g_hrcl.hrclgrup = g_grup               #使用者所屬群
        LET g_hrcl.hrcldate = g_today
        CALL i052_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hrcl.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF

        IF cl_null(g_hrcl.hrcl01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
      


      
        INSERT INTO hrcl_file VALUES(g_hrcl.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcl_file",g_hrcl.hrcl01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrcl01 INTO g_hrcl.hrcl01
              FROM hrcl_file 
             WHERE hrcl01 = g_hrcl.hrcl01
             CALL i052_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i052_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
   DEFINE l_s         VARCHAR(20)
   DEFINE l_dd        VARCHAR(20)
   DEFINE l_sql       STRING
   DEFINE l_hrcl02      LIKE hrcl_file.hrcl02
 
   DISPLAY BY NAME
      g_hrcl.hrcl02,g_hrcl.hrcl03,g_hrcl.hrcl04,g_hrcl.hrcl05,
      g_hrcl.hrcl06,g_hrcl.hrcl07,g_hrcl.hrcl08,g_hrcl.hrcl09,
      g_hrcl.hrcl10,g_hrcl.hrcl11,g_hrcl.hrcl12,g_hrcl.hrcl13,
      g_hrcl.hrcl14,g_hrcl.hrcl15,g_hrcl.hrcl16,g_hrcl.hrcl17,
      g_hrcl.hrcl18,g_hrcl.hrcl19,g_hrcl.hrcl20,g_hrcl.hrcl21,
      g_hrcl.hrcl22,g_hrcl.hrcl23,g_hrcl.hrcl24,g_hrcl.hrcl25,
      g_hrcl.hrcl26,g_hrcl.hrcl27,
      g_hrcl.hrcluser,g_hrcl.hrclgrup,g_hrcl.hrclmodu,g_hrcl.hrcldate,g_hrcl.hrcloriu,g_hrcl.hrclorig
 
   INPUT BY NAME
      g_hrcl.hrcl02,g_hrcl.hrcl03,g_hrcl.hrcl04,g_hrcl.hrcl05,
      g_hrcl.hrcl06,g_hrcl.hrcl07,g_hrcl.hrcl08,g_hrcl.hrcl09,
      g_hrcl.hrcl10,g_hrcl.hrcl11,g_hrcl.hrcl12,g_hrcl.hrcl13,
      g_hrcl.hrcl14,g_hrcl.hrcl15,g_hrcl.hrcl16,g_hrcl.hrcl17,
      g_hrcl.hrcl18,g_hrcl.hrcl19,g_hrcl.hrcl20,g_hrcl.hrcl21,
      g_hrcl.hrcl22,g_hrcl.hrcl23,g_hrcl.hrcl24,g_hrcl.hrcl25,
      g_hrcl.hrcl26,g_hrcl.hrcl27 #NO.1307027
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i052_set_entry(p_cmd)
          CALL i052_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
     
      AFTER FIELD hrcl02
         IF g_hrcl.hrcl02 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hrcl.hrcl01 != g_hrcl01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hrcl_file
                WHERE hrcl02 = g_hrcl.hrcl02
                  AND hrcl03 = g_hrcl.hrcl03 
                  AND hrcl04 = g_hrcl.hrcl04

               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hrcl.hrcl01,-239,1)
                  LET g_hrcl.hrcl01 = g_hrcl01_t
                  DISPLAY BY NAME g_hrcl.hrcl02
                  NEXT FIELD hrcl02
               END IF
               CALL i052_hrcl02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('hrcl01:',g_errno,1)
                  LET g_hrcl.hrcl01 = g_hrcl01_t
                  DISPLAY BY NAME g_hrcl.hrcl02
                  NEXT FIELD hrcl02
               END IF
            END IF
            #add NO.130708
            IF g_hrcl.hrcl03 IS NOT NULL THEN 
            	 SELECT hrao00 INTO l_hrcl02 FROM hrao_file WHERE hrao01 = g_hrcl.hrcl03
            	 IF NOT (g_hrcl.hrcl02 = l_hrcl02) THEN 
            	 	  LET g_hrcl.hrcl03 = NULL
            	 	  DISPLAY BY NAME g_hrcl.hrcl03 
            	 	  CALL i052_hrcl03('a')
            	 END IF 
            END IF 
         ELSE 
         	CALL i052_hrcl02('a')
         	  IF g_hrcl.hrcl03 is NOT NULL THEN 
         	     SELECT hrao00 INTO g_hrcl.hrcl02 FROM hrao_file WHERE hrao01 = g_hrcl.hrcl03
         		   DISPLAY BY NAME g_hrcl.hrcl02 
         		   CALL i052_hrcl02('a')
         	  END IF 
         END IF
         
       AFTER FIELD hrcl03
         IF g_hrcl.hrcl03 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hrcl.hrcl01 != g_hrcl01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hrcl_file 
                WHERE hrcl02 = g_hrcl.hrcl02 
                  AND hrcl03 = g_hrcl.hrcl03
                  AND hrcl03 = g_hrcl.hrcl04

               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hrcl.hrcl01,-239,1)
                  LET g_hrcl.hrcl01 = g_hrcl01_t
                  DISPLAY BY NAME g_hrcl.hrcl03
                  NEXT FIELD hrcl03
               END IF
               CALL i052_hrcl03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('hrcl01:',g_errno,1)
                  LET g_hrcl.hrcl01 = g_hrcl01_t
                  DISPLAY BY NAME g_hrcl.hrcl03
                  NEXT FIELD hrcl03
               END IF
            END IF
            IF g_hrcl.hrcl02 is NULL THEN 
            	 SELECT hrao00 INTO g_hrcl.hrcl02 FROM hrao_file WHERE hrao01 = g_hrcl.hrcl03 
         	     DISPLAY BY NAME g_hrcl.hrcl02 
         	     CALL i052_hrcl02('a')
            END IF
         ELSE 
         	 CALL i052_hrcl03('a')
         END IF

        AFTER FIELD hrcl04
         IF g_hrcl.hrcl04 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hrcl.hrcl01 != g_hrcl01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hrcl_file
                WHERE hrcl02 = g_hrcl.hrcl02 
                  AND hrcl03 = g_hrcl.hrcl03
                  AND hrcl04 = g_hrcl.hrcl04


               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hrcl.hrcl01,-239,1)
                  LET g_hrcl.hrcl01 = g_hrcl01_t
                  DISPLAY BY NAME g_hrcl.hrcl04
                  NEXT FIELD hrcl04
               END IF
               CALL i052_hrcl04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('hrcl01:',g_errno,1)
                  LET g_hrcl.hrcl01 = g_hrcl01_t
                  DISPLAY BY NAME g_hrcl.hrcl04
                  NEXT FIELD hrcl04
               END IF
            END IF
         ELSE 
           CALL i052_hrcl04('a')
         END IF
         	
         	

         ON CHANGE hrcl05
                LET p_cmd = "A"
            IF g_hrcl.hrcl05 = 'Y' THEN
                LET g_hrcl.hrcl06 = 'N'
                LET g_hrcl.hrcl08 = 'N'
                LET g_hrcl.hrcl07 = '0'
                LET g_hrcl.hrcl09 = '0'
                CALL i052_set_no_entry(p_cmd)
             ELSE 
                LET p_cmd = "A"
                LET g_hrcl.hrcl06 = 'Y'
                LET g_hrcl.hrcl08 = 'Y'
                LET g_hrcl.hrcl07 = '30'
                LET g_hrcl.hrcl09 = '30'
                CALL i052_set_entry(p_cmd)
             END IF
                CALL i052_show()

         ON CHANGE hrcl06
           LET  p_cmd = "B"
            IF g_hrcl.hrcl06 = 'Y' THEN
                CALL i052_set_entry(p_cmd)
             END IF
                CALL i052_show()
                
         ON CHANGE hrcl08
           LET  p_cmd = "C"
            IF g_hrcl.hrcl08 = 'Y' THEN
                CALL i052_set_entry(p_cmd)
            END IF
                CALL i052_show()
            
         ON CHANGE hrcl10
           LET  p_cmd = "D"
            IF g_hrcl.hrcl10 = 'Y' THEN
                CALL i052_set_entry(p_cmd)
            ELSE
                CALL i052_set_no_entry(p_cmd)
            END IF
                CALL i052_show()

         ON CHANGE hrcl12
           LET  p_cmd = "E"
            IF g_hrcl.hrcl12 = 'Y' THEN
                CALL i052_set_entry(p_cmd)
            ELSE
                CALL i052_set_no_entry(p_cmd)
            END IF
                CALL i052_show()
         
         ON CHANGE hrcl14
            LET  p_cmd = "F"
            IF g_hrcl.hrcl14 = 'Y' THEN
                CALL i052_set_entry(p_cmd)
             ELSE
                CALL i052_set_no_entry(p_cmd)
            END IF
                CALL i052_show()

         ON CHANGE hrcl23
           LET  p_cmd = "G"
            IF g_hrcl.hrcl23 = 'Y' THEN
                LET  g_hrcl.hrcl24 = 'N'
                CALL i052_set_no_entry(p_cmd)
             ELSE
                CALL i052_set_entry(p_cmd)
            END IF
                CALL i052_show()

       
      AFTER INPUT
         LET g_hrcl.hrcluser = s_get_data_owner("hrcl_file") 
         LET g_hrcl.hrclgrup = s_get_data_group("hrcl_file") 

           #自动为key值获取不可重复流水号
      SELECT (max(hrcl01)+1) INTO g_hrcl.hrcl01 FROM hrcl_file
               IF cl_null(g_hrcl.hrcl01) THEN
                      LET g_hrcl.hrcl01 =  '0000000001'
               END IF

      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         CALL cl_err3("ins","hrcl_file",g_hrcl.hrcl01,"",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
      ELSE
         CALL cl_flow_notify(g_hrcl.hrcl01,'I')           #則增加訊息到udm7主畫面上或使用者信箱
      END IF  
         
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_hrcl.hrcl01 IS NULL THEN
               DISPLAY BY NAME g_hrcl.hrcl02,g_hrcl.hrcl03,g_hrcl.hrcl04
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrcl02
            END IF

 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(hrcl01) THEN
            LET g_hrcl.* = g_hrcl_t.*
            CALL i052_show()
            NEXT FIELD hrcl01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(hrcl02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrcl.hrcl02
              CALL cl_create_qry() RETURNING g_hrcl.hrcl02
              DISPLAY BY NAME g_hrcl.hrcl02
              NEXT FIELD hrcl02

           WHEN INFIELD(hrcl03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              IF g_hrcl.hrcl02 is NULL THEN 
                 LET g_qryparam.state = "c"
              ELSE 
                 LET g_qryparam.arg1 = g_hrcl.hrcl02
              END IF 
              LET g_qryparam.default1 = g_hrcl.hrcl03
              CALL cl_create_qry() RETURNING g_hrcl.hrcl03
              DISPLAY BY NAME g_hrcl.hrcl03
              NEXT FIELD hrcl03

           WHEN INFIELD(hrcl04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbm03"
             # LET g_qryparam.state = "c" marked by yeap1 NO.130718
              LET g_qryparam.arg1 = "008"
              LET g_qryparam.default1 = g_hrcl.hrcl04
              CALL cl_create_qry() RETURNING g_hrcl.hrcl04
              DISPLAY BY NAME g_hrcl.hrcl04
              NEXT FIELD hrcl04

           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 


FUNCTION i052_hrcl02(p_cmd) 

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hraa12    LIKE hraa_file.hraa12
   DEFINE l_hraaacti  LIKE hraa_file.hraaacti
 
   LET g_errno=''
   SELECT hraa12,hraaacti INTO l_hraa12,l_hraaacti FROM hraa_file
    WHERE hraa01=g_hrcl.hrcl02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                LET l_hraa12=NULL
       WHEN l_hraaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='a' OR cl_null(g_errno)THEN
      DISPLAY l_hraa12 TO hraa12
   END IF
END FUNCTION

FUNCTION i052_hrcl03(p_cmd) 

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrao02    LIKE hrao_file.hrao02
   DEFINE l_hraoacti  LIKE hrao_file.hraoacti
 
   LET g_errno=''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti FROM hrao_file
    WHERE hrao01=g_hrcl.hrcl03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-009'
                                LET l_hrao02=NULL
       WHEN l_hraoacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='a' OR cl_null(g_errno)THEN
      DISPLAY l_hrao02 TO hrao02
   END IF
END FUNCTION

FUNCTION i052_hrcl04(p_cmd) 

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrbm04    LIKE hrbm_file.hrbm04
 
   LET g_errno=''
   SELECT hrbm04 INTO l_hrbm04 FROM hrbm_file
    WHERE hrbm03=g_hrcl.hrcl04
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-072'
                                LET l_hrbm04=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='a' OR cl_null(g_errno)THEN
      DISPLAY l_hrbm04 TO hrbm04
   END IF
END FUNCTION

 


FUNCTION i052_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrcl.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i052_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i052_count
    FETCH i052_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i052_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcl.hrcl01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcl.* TO NULL
    ELSE
        CALL i052_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i052_b_fill(g_wc)
    END IF
END FUNCTION


 
FUNCTION i052_fetch(p_flhrcl)
    DEFINE p_flhrcl         LIKE type_file.chr1
 
    CASE p_flhrcl
        WHEN 'N' FETCH NEXT     i052_cs INTO g_hrcl.hrcl01
        WHEN 'P' FETCH PREVIOUS i052_cs INTO g_hrcl.hrcl01
        WHEN 'F' FETCH FIRST    i052_cs INTO g_hrcl.hrcl01
        WHEN 'L' FETCH LAST     i052_cs INTO g_hrcl.hrcl01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about       
                     CALL cl_about()    
 
                  ON ACTION generate_link
                     CALL cl_generate_shortcut()
 
                  ON ACTION help        
                     CALL cl_show_help()
 
                  ON ACTION controlg    
                     CALL cl_cmdask()   
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i052_cs INTO g_hrcl.hrcl01
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcl.hrcl01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcl.* TO NULL  
        LET g_hrcl.hrcl01 = NULL      
        RETURN
    ELSE
      CASE p_flhrcl
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx    
    END IF
 
    SELECT * INTO g_hrcl.* FROM hrcl_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hrcl01 = g_hrcl.hrcl01

    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrcl_file",g_hrcl.hrcl01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_hrcl.hrcluser           #FUN-4C0044權限控管
        LET g_data_group=g_hrcl.hrclgrup
        CALL i052_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i052_show()
    LET g_hrcl_t.* = g_hrcl.*
    DISPLAY BY NAME g_hrcl.hrcl02,g_hrcl.hrcl03,g_hrcl.hrcl04,g_hrcl.hrcl05,
                    g_hrcl.hrcl06,g_hrcl.hrcl07,g_hrcl.hrcl08,g_hrcl.hrcl09,
                    g_hrcl.hrcl10,g_hrcl.hrcl11,g_hrcl.hrcl12,g_hrcl.hrcl13,
                    g_hrcl.hrcl14,g_hrcl.hrcl15,g_hrcl.hrcl16,g_hrcl.hrcl17,
                    g_hrcl.hrcl18,g_hrcl.hrcl19,g_hrcl.hrcl20,g_hrcl.hrcl21,
                    g_hrcl.hrcl22,g_hrcl.hrcl23,g_hrcl.hrcl24,g_hrcl.hrcl25,
                    g_hrcl.hrcl26,g_hrcl.hrcl27,g_hrcl.hrcluser,g_hrcl.hrclgrup,
                    g_hrcl.hrclmodu,g_hrcl.hrcldate,g_hrcl.hrcloriu,g_hrcl.hrclorig
    CALL i052_hrcl02('d')
    CALL i052_hrcl03('d')
    CALL i052_hrcl04('d')
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i052_u()

    SELECT * INTO g_hrcl.* 
      FROM hrcl_file 
     WHERE hrcl02=g_hrcl.hrcl02
       AND hrcl03=g_hrcl.hrcl03
       AND hrcl04=g_hrcl.hrcl04

    CALL cl_opmsg('u')
    LET g_hrcl01_t = g_hrcl.hrcl01
    
    BEGIN WORK
 
    OPEN i052_cl USING g_hrcl.hrcl01
    IF STATUS THEN
       CALL cl_err("OPEN i052_cl:", STATUS, 1)
       CLOSE i052_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i052_cl INTO g_hrcl.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcl.hrcl01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrcl.hrclmodu=g_user                  #修改者
    LET g_hrcl.hrcldate = g_today               #修改日期
    CALL i052_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i052_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrcl.*=g_hrcl_t.*
            CALL i052_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrcl_file SET hrcl_file.* = g_hrcl.*    # 更新DB
            WHERE hrcl01 = g_hrcl_t.hrcl01

        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrcl_file",g_hrcl.hrcl01,'',SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i052_cl
    COMMIT WORK
    CALL i052_b_fill(g_wc)
    
END FUNCTION


 
 
#FUNCTION i052_x()
#    IF g_hrcl.hrcl01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    BEGIN WORK
# 
#    OPEN i052_cl USING g_hrcl.hrcl01
#    IF STATUS THEN
#       CALL cl_err("OPEN i052_cl:", STATUS, 1)
#       CLOSE i052_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH i052_cl INTO g_hrcl.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_hrcl.hrcl01,SQLCA.sqlcode,1)
#       RETURN
#    END IF
#    CALL i052_show()
#    IF cl_exp(0,0,g_hrcl.hrclacti) THEN
#        LET g_chr = g_hrcl.hrclacti
#        IF g_hrcl.hrclacti='Y' THEN
#            LET g_hrcl.hrclacti='N'
#        ELSE
#            LET g_hrcl.hrclacti='Y'
#        END IF
#        UPDATE hrcl_file
#            SET hrclacti=g_hrcl.hrclacti
#            WHERE hrcl01=g_hrcl.hrcl01
#              AND hrcl02=g_hrcl.hrcl02
#              AND hrcl03=g_hrcl.hrcl03
#        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_hrcl.hrcl01,SQLCA.sqlcode,0)
#            LET g_hrcl.hrclacti = g_chr
#        END IF
#        DISPLAY BY NAME g_hrcl.hrclacti
#    END IF
#    CLOSE i052_cl
#    COMMIT WORK
#END FUNCTION
 
FUNCTION i052_r()
    IF g_hrcl.hrcl01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i052_cl USING g_hrcl.hrcl01
    IF STATUS THEN
       CALL cl_err("OPEN i052_cl:", STATUS, 0)
       CLOSE i052_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i052_cl INTO g_hrcl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcl.hrcl01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i052_show()
    IF cl_delete() THEN
                 LET g_doc.column1 = "hrcl01"
                 LET g_doc.value1 = g_hrcl.hrcl01


       CALL cl_del_doc()
       DELETE FROM hrcl_file 
        WHERE hrcl01 = g_hrcl.hrcl01


       CLEAR FORM
       OPEN i052_count
       IF STATUS THEN
          CLOSE i052_cl
          CLOSE i052_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i052_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i052_cl
          CLOSE i052_count
          COMMIT WORK
          CALL i052_b_fill(g_wc)
          RETURN
       END IF
       
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i052_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i052_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i052_fetch('/')
       END IF
    END IF
    CLOSE i052_cl
    COMMIT WORK
    CALL i052_b_fill(g_wc)
END FUNCTION
 


 
PRIVATE FUNCTION i052_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("hrcl02,hrcl03,hrcl04",TRUE)
    END IF
   IF p_cmd = 'A' THEN
        CALL cl_set_comp_entry("hrcl06,hrcl07,hrcl08,hrcl09",TRUE)
     END IF
   IF p_cmd = 'B' THEN
       CALL cl_set_comp_entry("hrcl07",TRUE)
    END IF
   IF p_cmd = 'C' THEN
       CALL cl_set_comp_entry("hrcl09",TRUE)
    END IF
   IF p_cmd = 'D' THEN
       CALL cl_set_comp_entry("hrcl11",TRUE)
   END IF
   IF p_cmd = 'E' THEN
       CALL cl_set_comp_entry("hrcl13",TRUE)
   END IF
   IF p_cmd = 'F' THEN
       CALL cl_set_comp_entry("hrcl15,hrcL16,hrcl17,hrcl18",TRUE)
    END IF
    IF p_cmd = 'G' THEN
        CALL cl_set_comp_entry("hrcl24",TRUE)
     END IF
END FUNCTION

 
PRIVATE FUNCTION i052_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("hrcl11,hrcl13,hrcl15,hrcl16,hrcl17,hrcl18,hrcl24",FALSE)
    END IF
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
        CALL cl_set_comp_entry("hrcl02,hrcl03,hrcl04",FALSE)
     END IF
    IF p_cmd = 'A' THEN
        CALL cl_set_comp_entry("hrcl06,hrcl07,hrcl08,hrcl09",FALSE)
     END IF
   IF p_cmd = 'D' THEN
       CALL cl_set_comp_entry("hrcl11",FALSE)
     END IF
   IF p_cmd = 'E' THEN
       CALL cl_set_comp_entry("hrcl13",FALSE)
   END IF
    IF p_cmd = 'G' THEN
        CALL cl_set_comp_entry("hrcl24",FALSE)
     END IF
    IF p_cmd = 'F' THEN
        CALL cl_set_comp_entry("hrcl15,hrcL16,hrcl17,hrcl18",FALSE)
     END IF
END FUNCTION
	
#---------------added BY yeap NO.130829---------STR-----------
FUNCTION i052_b_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000

   WHILE TRUE

      CALL i052_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrcl_file.*
           INTO g_hrcl.*
           FROM hrcl_file
          WHERE hrcl01=g_hrcl_1[l_ac].hrcl01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page4'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i052_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page5", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page5", TRUE)
       END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
               CALL i052_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i052_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i052_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i052_u()
            END IF
            EXIT WHILE  	 	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcl_1),'','')
           END IF
        
        WHEN "help"
            CALL cl_show_help()

        WHEN "controlg"
            CALL cl_cmdask()

        WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        WHEN "exit"
            EXIT WHILE

        WHEN "g_idle_seconds"
            CALL cl_on_idle()

        WHEN "about"
            CALL cl_about()

        OTHERWISE
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
	
	

FUNCTION i052_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcl_1 TO s_hrcl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION item
         LET g_bp_flag = 'Page4'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i052_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page5", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page5", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i052_fetch('/')
         CALL cl_set_comp_visible("Page5", FALSE)
         CALL ui.interface.refresh()              
         CALL cl_set_comp_visible("Page5", TRUE)
         EXIT DISPLAY

      ON ACTION first
         CALL i052_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i052_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i052_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i052_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i052_fetch('L')
         CONTINUE DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-8A0193
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"  #MOD-8A0193 add
         EXIT DISPLAY                 #MOD-8A0193 add

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #No.FUN-9C0089 add -end-----------------
   
      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i052_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrcl_1.clear()
        
        LET l_sql=" SELECT hrcl01,hrcl02,hrcl03,hrcl04,hrcl26 ",
                  "   FROM hrcl_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY hrcl01 "
                  
        PREPARE i052_b_pre FROM l_sql
        DECLARE i052_b_cs CURSOR FOR i052_b_pre
        
        LET l_i=1
        
        FOREACH i052_b_cs INTO g_hrcl_1[l_i].*
        
           SELECT hraa12 INTO g_hrcl_1[l_i].hrcl02 FROM hraa_file
            WHERE hraa01=g_hrcl_1[l_i].hrcl02
           SELECT hrao02 INTO g_hrcl_1[l_i].hrcl03 FROM hrao_file
            WHERE hrao01=g_hrcl_1[l_i].hrcl03
           SELECT hrbm04 INTO g_hrcl_1[l_i].hrcl04 FROM hrbm_file
            WHERE hrbm03=g_hrcl_1[l_i].hrcl04
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrcl_1.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrcl_1 TO s_hrcl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY
        
   CALL cl_set_act_visible("hrcl01", FALSE)

END FUNCTION
	#---------------added BY yeap NO.130829---------END-----------




