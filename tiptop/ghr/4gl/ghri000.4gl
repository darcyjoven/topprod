# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri000.4gl
# Descriptions...: 集团基本资料维护作业
# Date & Author..: 2013-02-27 by sr
# Modify ........: by zhuzw 20130228 增加背景运行逻辑
# Modify ........: by hourf 20130516 增加15个自定义栏位
IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義

 
DEFINE g_hraa                 RECORD LIKE hraa_file.*
DEFINE g_hraa_t               RECORD LIKE hraa_file.*      #備份舊值
DEFINE g_hraa01_t             LIKE hraa_file.hraa01         #Key值備份
DEFINE g_hraa12_t             LIKE hraa_file.hraa12         #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE hraa_file.hraaacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE g_hraa01              LIKE hraa_file.hraa01 #add by zhuzw 20130228  


MAIN
    OPTIONS
#       FIELD ORDER FORM,                      #依照FORM上面的順序定義做欄位跳動 (預設為依指令順序)
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("GHR")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF
   #add by zhuzw 20130228 start
   LET g_hraa01 = ARG_VAL(1)
   LET g_bgjob  = ARG_VAL(2)
   #add by zhuzw 20130228 end 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_hraa.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM hraa_file WHERE hraa01 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i000_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i000_w WITH FORM "ghr/42f/ghri000"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊 
   CALL cl_set_label_justify("i000_w","right")
   LET g_action_choice = ""
  #add by zhuzw 20130228 start
   IF g_bgjob = 'Y' THEN 
      SELECT * INTO g_hraa.* FROM hraa_file
       WHERE hraa01 = g_hraa01
      CALL i000_show()  
   END IF 
  #add by zhuzw 20130228 end 
   CALL i000_menu()                                         #進入選單 Menu
   
   CLOSE WINDOW i000_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i000_curs()
    
    CLEAR FORM
    INITIALIZE g_hraa.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hraa01,hraa02,hraa03,hraa04,hraa05,hraa07,hraa10,hraa12,
        hraa15,hraa16,hraa18,hraa31,hraa32,hraa33,
        hraaud01,hraaud02,hraaud03,hraaud04,hraaud05,hraaud06,hraaud07,hraaud08,  #add by hrf 13/05/15
        hraaud09,hraaud10,hraaud11,hraaud12,hraaud13,hraaud14,hraaud15,           #add by hrf 13/05/15
        hraauser,hraagrup,hraamodu,hraadate,hraaacti

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
           	   WHEN INFIELD(hraa10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa10_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hraa.hraa10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraa10
                 NEXT FIELD hraa10
              WHEN INFIELD(hraa31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hraa.hraa31
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraa31
                 NEXT FIELD hraa31
# add by shenran start
#               WHEN INFIELD(hraa18)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_hraf01"
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.default1 = g_hraa.hraa18
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hraa18
#                 NEXT FIELD hraa18
              WHEN INFIELD(hraa18)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hraa.hraa18
                 LET g_qryparam.arg1='302'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraa18
                 NEXT FIELD hraa18
#add by shenran end                 
              WHEN INFIELD(hraa05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_hrag06"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hraa.hraa05
                 LET g_qryparam.arg1='201'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraa05
                 NEXT FIELD hraa05
             OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  

      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hraauser', 'hraagrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位

    LET g_sql = "SELECT hraa01 FROM hraa_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY hraa01"
    PREPARE i000_prepare FROM g_sql
    DECLARE i000_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i000_prepare

    LET g_sql = "SELECT COUNT(*) FROM hraa_file WHERE ",g_wc CLIPPED
    PREPARE i000_precount FROM g_sql
    DECLARE i000_count CURSOR FOR i000_precount
END FUNCTION
 

FUNCTION i000_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i000_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i000_q()
            END IF

        ON ACTION next
            CALL i000_fetch('N')

        ON ACTION previous
            CALL i000_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i000_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i000_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i000_r()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i000_copy()
            END IF

       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN 
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF
               LET l_cmd = 'p_query "aooi000" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)                             
            END IF
         ON ACTION ghri000_a
          LET g_action_choice = "ghri000_a"
          IF cl_chk_act_auth() THEN
             CALL i000_feature_maintain(g_hraa.hraa01)
          END IF
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i000_fetch('/')

        ON ACTION first
            CALL i000_fetch('F')

        ON ACTION last
            CALL i000_fetch('L')

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
 
        ON ACTION close 
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hraa.hraa01 IS NOT NULL THEN
                 LET g_doc.column1 = "hraa01"
                 LET g_doc.value1 = g_hraa.hraa01
                 CALL cl_doc()
              END IF
           END IF
        ON ACTION ghr_import
            LET g_action_choice="ghr_import"
            IF cl_chk_act_auth() THEN
                 CALL i000_import()
            END IF
       ON ACTION ghri000_b
            LET g_action_choice="ghri000_b"
            IF cl_chk_act_auth() THEN
               LET g_msg = "ghrq000 " 
               CALL cl_cmdrun(g_msg)
            END IF

       
    END MENU
    CLOSE i000_cs
END FUNCTION
 
 
FUNCTION i000_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hraa.* LIKE hraa_file.*
    LET g_hraa01_t = NULL
    LET g_hraa12_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hraa.hraauser = g_user
        LET g_hraa.hraaoriu = g_user 
        LET g_hraa.hraaorig = g_grup 
        LET g_hraa.hraagrup = g_grup               #使用者所屬群
        LET g_hraa.hraadate = g_today
        LET g_hraa.hraaacti = 'Y'
        LET g_hraa.hraa07 = 'N'
        LET g_hraa.hraa16 = 'N'
        CALL cl_set_comp_entry("hraa10",TRUE)
        CALL cl_set_comp_entry("hraa19,hraa20,hraa21,hraa22,hraa23,hraa24,hraa25,hraa26",FALSE )
        CALL i000_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hraa.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hraa.hraa01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO hraa_file VALUES(g_hraa.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hraa_file",g_hraa.hraa01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hraa01 INTO g_hraa.hraa01 FROM hraa_file WHERE hraa01 = g_hraa.hraa01
        END IF
        IF NOT cl_null(g_hraa.hraa33) THEN
           INSERT INTO hral_file VALUES(g_hraa.hraa33,g_hraa.hraa12,g_hraa.hraa02,"",g_hraa.hraaacti,g_hraa.hraauser,g_hraa.hraagrup,g_hraa.hraamodu,g_hraa.hraadate,g_hraa.hraaoriu,g_hraa.hraaorig)
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i000_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_gen02       LIKE gen_file.gen02
   DEFINE l_gen03       LIKE gen_file.gen03
   DEFINE l_gen04       LIKE gen_file.gen04
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
   DEFINE l_geb02       LIKE geb_file.geb02
   DEFINE l_hraa12      LIKE hraa_file.hraa12
   DEFINE l_hrag07      LIKE hrag_file.hrag07
   DEFINE l_hraf02      LIKE hraf_file.hraf02
 
   DISPLAY BY NAME
      g_hraa.hraa01,g_hraa.hraa02,g_hraa.hraa12,g_hraa.hraa03,g_hraa.hraa10,g_hraa.hraa05,g_hraa.hraa07,g_hraa.hraa04,
      g_hraa.hraa15,g_hraa.hraa18,g_hraa.hraa31,g_hraa.hraa32,g_hraa.hraa16,g_hraa.hraa33,
      g_hraa.hraa19,g_hraa.hraa20,g_hraa.hraa21,g_hraa.hraa22,g_hraa.hraa23,g_hraa.hraa24,g_hraa.hraa25,g_hraa.hraa26,
      g_hraa.hraa06,
      g_hraa.hraaud01,g_hraa.hraaud02,g_hraa.hraaud03,g_hraa.hraaud04,g_hraa.hraaud05,g_hraa.hraaud06,g_hraa.hraaud07,
      g_hraa.hraaud08,g_hraa.hraaud09,g_hraa.hraaud10,g_hraa.hraaud11,g_hraa.hraaud12,g_hraa.hraaud13,g_hraa.hraaud14,
      g_hraa.hraaud15,
      g_hraa.hraauser,g_hraa.hraagrup,g_hraa.hraamodu,g_hraa.hraadate,g_hraa.hraaacti,g_hraa.hraaoriu,g_hraa.hraaorig
 
   INPUT BY NAME
      g_hraa.hraa01,g_hraa.hraa02,g_hraa.hraa12,g_hraa.hraa03,g_hraa.hraa10,g_hraa.hraa05,g_hraa.hraa04,
      g_hraa.hraa15,g_hraa.hraa18,g_hraa.hraa31,g_hraa.hraa32,g_hraa.hraa33,g_hraa.hraa06,g_hraa.hraa07,g_hraa.hraa16,
      g_hraa.hraa19,g_hraa.hraa20,g_hraa.hraa21,g_hraa.hraa22,g_hraa.hraa23,g_hraa.hraa24,g_hraa.hraa25,g_hraa.hraa26,
      g_hraa.hraauser,g_hraa.hraagrup,g_hraa.hraamodu,g_hraa.hraadate,g_hraa.hraaacti,g_hraa.hraaoriu,
      g_hraa.hraaorig,
      g_hraa.hraaud02,g_hraa.hraaud03,g_hraa.hraaud04,g_hraa.hraaud05,g_hraa.hraaud06,g_hraa.hraaud07,
      g_hraa.hraaud08,g_hraa.hraaud09,g_hraa.hraaud10,g_hraa.hraaud11,g_hraa.hraaud12,g_hraa.hraaud13,g_hraa.hraaud14,
      g_hraa.hraaud15,g_hraa.hraaud01
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i000_set_entry(p_cmd)
          CALL i000_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          
      AFTER FIELD hraa01
         IF g_hraa.hraa01 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hraa.hraa01 != g_hraa01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hraa_file WHERE hraa01 = g_hraa.hraa01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hraa.hraa01,-239,1)
                  LET g_hraa.hraa01 = g_hraa01_t
                  DISPLAY BY NAME g_hraa.hraa01
                  NEXT FIELD hraa01
               END IF

            END IF
         END IF
      AFTER FIELD hraa12
         IF g_hraa.hraa12 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hraa.hraa12 != g_hraa12_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hraa_file WHERE hraa12 = g_hraa.hraa12
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hraa.hraa12,-239,1)
                  LET g_hraa.hraa12 = g_hraa12_t
                  DISPLAY BY NAME g_hraa.hraa12
                  NEXT FIELD hraa12
               END IF

            END IF
         END IF
      BEFORE FIELD hraa10 
         IF g_hraa.hraa01='0000' THEN 
           	CALL cl_set_comp_entry("hraa10",FALSE)
           ELSE 
           	CALL cl_set_comp_entry("hraa10",TRUE)
         END IF 
      AFTER INPUT
         LET g_hraa.hraauser = s_get_data_owner("hraa_file") #FUN-C10039
         LET g_hraa.hraagrup = s_get_data_group("hraa_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_hraa.hraa01 IS NULL THEN
               DISPLAY BY NAME g_hraa.hraa01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hraa01
            END IF
      AFTER FIELD hraa18
         IF g_hraa.hraa18 IS NOT NULL THEN
#         	  SELECT geb02 INTO l_geb02 FROM geb_file 
#            WHERE geb01=g_hraa.hraa18
#            DISPLAY l_geb02 TO hraa18_1
         	  IF g_hraa.hraa18='002' THEN
         	    CALL cl_set_comp_entry("hraa19,hraa20,hraa21,hraa22,hraa23,hraa24,hraa25,hraa26",TRUE)
         	 	ELSE 
         	  	CALL cl_set_comp_entry("hraa19,hraa20,hraa21,hraa22,hraa23,hraa24,hraa25,hraa26",FALSE )
         	  END IF  
         END IF 
      AFTER FIELD hraa10
         IF g_hraa.hraa10 IS NOT NULL THEN
         	SELECT hraa12 INTO l_hraa12 FROM hraa_file 
          WHERE hraa01=g_hraa.hraa10
          DISPLAY l_hraa12 TO hraa10_1
         END IF 
      AFTER FIELD hraa31
         IF g_hraa.hraa31 IS NOT NULL THEN
         	 SELECT gen02 INTO l_gen02 FROM gen_file 
           WHERE gen01=g_hraa.hraa31
           DISPLAY l_gen02 TO hraa31_1
         END IF 
      #add by zhuzw 20150429 str   
      AFTER FIELD hraa33
         IF NOT cl_null(g_hraa.hraa33) THEN 
            SELECT COUNT(*) INTO l_n FROM hraa_file 
             WHERE hraa33 =g_hraa.hraa33
               AND hraa01 !=g_hraa.hraa01
            IF l_n >0 THEN
               CALL cl_err('ERP数据库重复，请检查','!',0)
               NEXT FIELD hraa33 
            END IF     
         END IF 
       #add by zhuzw 20150429 end  
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(hraa01) THEN
            LET g_hraa.* = g_hraa_t.*
            CALL i000_show()
            NEXT FIELD hraa01
         END IF
 
     ON ACTION controlp
        CASE
        	 WHEN INFIELD(hraa10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa10"
              LET g_qryparam.default1 = g_hraa.hraa10
              CALL cl_create_qry() RETURNING g_hraa.hraa10
              SELECT hraa12 INTO l_hraa12 FROM hraa_file 
              WHERE hraa01=g_hraa.hraa10
              DISPLAY l_hraa12 TO hraa10_1
              DISPLAY BY NAME g_hraa.hraa10
              NEXT FIELD hraa10
           WHEN INFIELD(hraa31)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_hraa.hraa31
              CALL cl_create_qry() RETURNING g_hraa.hraa31
              SELECT gen02 INTO l_gen02 FROM gen_file 
              WHERE gen01=g_hraa.hraa31
              DISPLAY l_gen02 TO hraa31_1
              DISPLAY BY NAME g_hraa.hraa31
              NEXT FIELD hraa31
#          WHEN INFIELD(hraa18)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_hraf01"
#              LET g_qryparam.default1 = g_hraa.hraa18
#              CALL cl_create_qry() RETURNING g_hraa.hraa18
#              SELECT hraf02 INTO l_hraf02 FROM hraf_file 
#              WHERE hraf01=g_hraa.hraa18
#              DISPLAY l_hraf02 TO hraa18_1
#              DISPLAY BY NAME g_hraa.hraa18
#              NEXT FIELD hraa18
#add by shenran start
           WHEN INFIELD(hraa18)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag"
              LET g_qryparam.default1 = g_hraa.hraa18
              LET g_qryparam.arg1='302'
              CALL cl_create_qry() RETURNING g_hraa.hraa18
              SELECT hrag07 INTO l_hrag07 FROM hrag_file 
              WHERE hrag01='302'
              AND  hrag06=g_hraa.hraa18
              DISPLAY l_hrag07 TO hraa18_1
              DISPLAY BY NAME g_hraa.hraa18
              NEXT FIELD hraa18
#add by shenran end
          WHEN INFIELD(hraa05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_hrag06"
              LET g_qryparam.default1 = g_hraa.hraa05
              LET g_qryparam.arg1='201'
              CALL cl_create_qry() RETURNING g_hraa.hraa05
              SELECT hrag07 INTO l_hrag07 FROM hrag_file 
              WHERE hrag01='201'
              AND  hrag06=g_hraa.hraa05
              DISPLAY l_hrag07 TO hraa05_1
              DISPLAY BY NAME g_hraa.hraa05
              NEXT FIELD hraa05
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
         
      ON ACTION update1
           IF NOT cl_null(g_hraa.hraa01) THEN
              LET g_doc.column1 = "hraa01"
              LET g_doc.value1 = g_hraa.hraa01
              CALL cl_fld_doc("hraa08")
            END IF
        ON ACTION UPDATE2
        
           IF NOT cl_null(g_hraa.hraa01) THEN
              LET g_doc.column1 = "hraa01"
              LET g_doc.value1 = g_hraa.hraa01
              CALL cl_fld_doc("hraa09")
            END IF
            	
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 


#FUNCTION i000_hraa01(p_cmd)
#
#   DEFINE p_cmd      LIKE type_file.chr1
#   DEFINE l_gen02    LIKE gen_file.gen02
#   DEFINE l_gen03    LIKE gen_file.gen03
#   DEFINE l_gen04    LIKE gen_file.gen04
#   DEFINE l_genacti  LIKE gen_file.genacti
#   DEFINE l_gem02    LIKE gem_file.gem02
# 
#   LET g_errno=''
#   SELECT gen02,gen03,gen04,genacti INTO l_gen02,l_gen03,l_gen04,l_genacti FROM gen_file
#    WHERE gen01=g_hraa.hraa01
#   CASE
#       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
#                                LET l_gen02=NULL
#                                LET l_gen03=NULL
#                                LET l_gen04=NULL
#       WHEN l_genacti='N'       LET g_errno='9028'
#       OTHERWISE
#            LET g_errno=SQLCA.sqlcode USING '------'
#   END CASE
#   IF p_cmd='d' OR cl_null(g_errno)THEN
#      DISPLAY l_gen02 TO FORMONLY.gen02
#      DISPLAY l_gen03 TO FORMONLY.gen03
#      DISPLAY l_gen04 TO FORMONLY.gen04
#
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_gen03
#      IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
#      DISPLAY l_gem02 TO gem02
#   END IF
#END FUNCTION
 


FUNCTION i000_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hraa.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i000_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i000_count
    FETCH i000_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i000_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hraa.hraa01,SQLCA.sqlcode,0)
        INITIALIZE g_hraa.* TO NULL
    ELSE
        CALL i000_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i000_fetch(p_flhraa)
    DEFINE p_flhraa         LIKE type_file.chr1
 
    CASE p_flhraa
        WHEN 'N' FETCH NEXT     i000_cs INTO g_hraa.hraa01
        WHEN 'P' FETCH PREVIOUS i000_cs INTO g_hraa.hraa01
        WHEN 'F' FETCH FIRST    i000_cs INTO g_hraa.hraa01
        WHEN 'L' FETCH LAST     i000_cs INTO g_hraa.hraa01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about       
                     CALL cl_about()    

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
            FETCH ABSOLUTE g_jump i000_cs INTO g_hraa.hraa01
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hraa.hraa01,SQLCA.sqlcode,0)
        INITIALIZE g_hraa.* TO NULL  
        LET g_hraa.hraa01 = NULL      
        RETURN
    ELSE
      CASE p_flhraa
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_hraa.* FROM hraa_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hraa01 = g_hraa.hraa01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hraa_file",g_hraa.hraa01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_hraa.hraauser           #FUN-4C0044權限控管
        LET g_data_group=g_hraa.hraagrup
        CALL i000_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i000_show()
	  DEFINE l_gen02  LIKE gen_file.gen02
	  DEFINE l_geb02  LIKE geb_file.geb02
	  DEFINE l_hraa12 LIKE hraa_file.hraa12
    DEFINE l_hrag07      LIKE hrag_file.hrag07
    DEFINE l_hraf02      LIKE hraf_file.hraf02
    LET g_hraa_t.* = g_hraa.*
    DISPLAY BY NAME g_hraa.hraa01,g_hraa.hraa02,g_hraa.hraa03,g_hraa.hraa04,g_hraa.hraa05,g_hraa.hraa06,
      g_hraa.hraa07,g_hraa.hraa10,g_hraa.hraa12,g_hraa.hraa15,g_hraa.hraa16,g_hraa.hraa18,
      g_hraa.hraa19,g_hraa.hraa20,g_hraa.hraa21,g_hraa.hraa22,g_hraa.hraa23,g_hraa.hraa24,
      g_hraa.hraa25,g_hraa.hraa26,g_hraa.hraa31,g_hraa.hraa32,g_hraa.hraa33,
      g_hraa.hraaud01,g_hraa.hraaud02,g_hraa.hraaud03,g_hraa.hraaud04,g_hraa.hraaud05,g_hraa.hraaud06,g_hraa.hraaud07,
      g_hraa.hraaud08,g_hraa.hraaud09,g_hraa.hraaud10,g_hraa.hraaud11,g_hraa.hraaud12,g_hraa.hraaud13,g_hraa.hraaud14,
      g_hraa.hraaud15,
      g_hraa.hraauser,g_hraa.hraagrup,g_hraa.hraamodu,g_hraa.hraadate,g_hraa.hraaacti,g_hraa.hraaoriu,
      g_hraa.hraaorig
#    CALL i000_hraa01('d')
     SELECT gen02 INTO l_gen02 FROM gen_file 
     WHERE gen01=g_hraa.hraa31
     DISPLAY l_gen02 TO hraa31_1
#     SELECT hraf02 INTO l_hraf02 FROM hraf_file 
#     WHERE hraf01=g_hraa.hraa18
#     DISPLAY l_hraf02 TO hraa18_1
     SELECT hrag07 INTO l_hrag07 FROM hrag_file 
     WHERE hrag01='302'
     AND  hrag06=g_hraa.hraa18
     DISPLAY l_hrag07 TO hraa18_1     
     SELECT hraa12 INTO l_hraa12 FROM hraa_file 
     WHERE hraa01=g_hraa.hraa10
     DISPLAY l_hraa12 TO hraa10_1
     SELECT hrag07 INTO l_hrag07 FROM hrag_file 
     WHERE hrag01='201'
     AND  hrag06=g_hraa.hraa05
     DISPLAY l_hrag07 TO hraa05_1     
    LET g_doc.column1 = "hraa01"
    LET g_doc.value1 = g_hraa.hraa01
    CALL cl_get_fld_doc("hraa08")
    CALL cl_get_fld_doc("hraa09")
    CALL cl_show_fld_cont()
    CALL cl_set_comments("hraa12","leotest")  #add by leo for test
END FUNCTION
 


FUNCTION i000_u()
    IF g_hraa.hraa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hraa.* FROM hraa_file WHERE hraa01=g_hraa.hraa01
    IF g_hraa.hraaacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_hraa01_t = g_hraa.hraa01
    BEGIN WORK
 
    OPEN i000_cl USING g_hraa.hraa01
    IF STATUS THEN
       CALL cl_err("OPEN i000_cl:", STATUS, 1)
       CLOSE i000_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i000_cl INTO g_hraa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hraa.hraa01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hraa.hraamodu=g_user                  #修改者
    LET g_hraa.hraadate = g_today               #修改日期
    CALL i000_show()                          # 顯示最新資料
    WHILE TRUE
        IF g_hraa.hraa18<>'TW' THEN  
           CALL cl_set_comp_entry("hraa19,hraa20,hraa21,hraa22,hraa23,hraa24,hraa25,hraa26",FALSE)
          ELSE    	  
           CALL cl_set_comp_entry("hraa19,hraa20,hraa21,hraa22,hraa23,hraa24,hraa25,hraa26",TRUE)
        END IF 
        IF g_hraa.hraa01='0000' THEN 
           	CALL cl_set_comp_entry("hraa10",FALSE)
           ELSE 
           	CALL cl_set_comp_entry("hraa10",TRUE)
         END IF 
        CALL i000_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hraa.*=g_hraa_t.*
            CALL i000_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hraa_file SET hraa_file.* = g_hraa.*    # 更新DB
            #WHERE hraa01 = g_hraa.hraa01     #MOD-BB0113 mark
            WHERE hraa01 = g_hraa_t.hraa01    #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hraa_file",g_hraa.hraa01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        ELSE 
        	 #add by zhuzw 20150429 start
        	 IF g_hraa_t.hraa33 != g_hraa.hraa33 THEN 
        	    DELETE FROM hral_file WHERE hral01 = g_hraa_t.hraa33
        	    INSERT INTO hral_file VALUES(g_hraa.hraa33,g_hraa.hraa12,g_hraa.hraa02,"",g_hraa.hraaacti,g_hraa.hraauser,g_hraa.hraagrup,g_hraa.hraamodu,g_hraa.hraadate,g_hraa.hraaoriu,g_hraa.hraaorig) 
           ELSE 
           	  IF g_hraa_t.hraa12 != g_hraa.hraa12 THEN 
           	     UPDATE hral_file
           	        SET hral02 = g_hraa.hraa12
           	     WHERE  hral01 = g_hraa_t.hraa33           	       
           	  END IF 
           	  IF g_hraa_t.hraa02 != g_hraa.hraa02 THEN 
           	     UPDATE hral_file
           	        SET hral03 = g_hraa.hraa02
           	     WHERE  hral01 = g_hraa_t.hraa33           	       
           	  END IF 
        	 END IF 
        	 #add by zhuzw 20150429 end      
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i000_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i000_x()
	  DEFINE l_sr  LIKE type_file.num10  
    IF g_hraa.hraa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i000_cl USING g_hraa.hraa01
    IF STATUS THEN
       CALL cl_err("OPEN i000_cl:", STATUS, 1)
       CLOSE i000_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i000_cl INTO g_hraa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hraa.hraa01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i000_show()
    SELECT COUNT(*) INTO l_sr FROM hraa_file 
    WHERE hraa01=g_hraa.hraa01 
    AND hraa01 IN (SELECT hraa10 FROM hraa_file WHERE hraaacti='Y')
    AND hraa10 is NOT NULL 
    IF (l_sr > '0' OR g_hraa.hraa10 is NULL) AND g_hraa.hraaacti='Y' THEN  
    	 CALL cl_err('存在子公司不能无效','!',1)
    	ELSE 
      IF cl_exp(0,0,g_hraa.hraaacti) THEN
         LET g_chr = g_hraa.hraaacti
         IF g_hraa.hraaacti='Y' THEN
             LET g_hraa.hraaacti='N'
         ELSE
             LET g_hraa.hraaacti='Y'
         END IF
         UPDATE hraa_file
             SET hraaacti=g_hraa.hraaacti
             WHERE hraa01=g_hraa.hraa01
         IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err(g_hraa.hraa01,SQLCA.sqlcode,0)
             LET g_hraa.hraaacti = g_chr
         ELSE 
         	#add by zhuzw 20150429 start
            UPDATE hral_file
               SET hralacti=g_hraa.hraaacti
             WHERE hral01=g_hraa.hraa33       	      
         END IF
         #add by zhuzw 20150429 end 
         DISPLAY BY NAME g_hraa.hraaacti
      END IF
    END IF 
    CLOSE i000_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i000_r()
    IF g_hraa.hraa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i000_cl USING g_hraa.hraa01
    IF STATUS THEN
       CALL cl_err("OPEN i000_cl:", STATUS, 0)
       CLOSE i000_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i000_cl INTO g_hraa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hraa.hraa01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i000_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hraa01"   
       LET g_doc.value1 = g_hraa.hraa01 

       CALL cl_del_doc()
       DELETE FROM hraa_file WHERE hraa01 = g_hraa.hraa01
       DELETE FROM hral_file WHERE hral01= g_hraa.hraa33 #add by zhuzw 20150429
       CLEAR FORM
       OPEN i000_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i000_cl
          CLOSE i000_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH i000_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i000_cl
          CLOSE i000_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i000_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i000_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i000_fetch('/')
       END IF
    END IF
    CLOSE i000_cl
    COMMIT WORK
END FUNCTION
 


FUNCTION i000_copy()

    DEFINE l_newno         LIKE hraa_file.hraa01
    DEFINE l_oldno         LIKE hraa_file.hraa01
    DEFINE p_cmd           LIKE type_file.chr1
    DEFINE l_input         LIKE type_file.chr1 
 
    IF g_hraa.hraa01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i000_set_entry('a')
    LET g_before_input_done = TRUE

    INPUT l_newno FROM hraa01
 
        AFTER FIELD hraa01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM hraa_file WHERE hraa01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD hraa01
              END IF
           END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()  
 
      ON ACTION help      
         CALL cl_show_help() 
 
      ON ACTION controlg  
         CALL cl_cmdask() 
    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_hraa.hraa01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hraa_file
        WHERE hraa01=g_hraa.hraa01
        INTO TEMP x
    UPDATE x
        SET hraa01=l_newno,    #資料鍵值
            hraaacti='Y',      #資料有效碼
            hraauser=g_user,   #資料所有者
            hraagrup=g_grup,   #資料所有者所屬群
            hraamodu=NULL,     #資料修改日期
            hraadate=g_today   #資料建立日期

    INSERT INTO hraa_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hraa_file",g_hraa.hraa01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_hraa.hraa01
        LET g_hraa.hraa01 = l_newno
        SELECT hraa_file.* INTO g_hraa.* FROM hraa_file
               WHERE hraa01 = l_newno
        CALL i000_u()
        SELECT hraa_file.* INTO g_hraa.* FROM hraa_file
               WHERE hraa01 = l_oldno
    END IF
    LET g_hraa.hraa01 = l_oldno
    CALL i000_show()
END FUNCTION

 
PRIVATE FUNCTION i000_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hraa01",TRUE)
   END IF
END FUNCTION

 
PRIVATE FUNCTION i000_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("hraa01",FALSE)
   END IF
   
#SELECT rowid FROM zz_file WhERE zz01=g_zz01        #No.TQC-B60372
END FUNCTION
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i000_browse()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 10/08/23 By yangjian 
#=================================================================#
FUNCTION i000_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hraa01  LIKE hraa_file.hraa01,
         hraa02  LIKE hraa_file.hraa02,
         hraa12  LIKE hraa_file.hraa12,
         hraa03  LIKE hraa_file.hraa03,
         hraa05  LIKE hraa_file.hraa05,
         hraa06  LIKE hraa_file.hraa06,
         hraa10  LIKE hraa_file.hraa10
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow             
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hraa01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hraa02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hraa12])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hraa03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hraa05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hraa06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hraa10])
                 
                IF NOT cl_null(sr.hraa01) AND NOT cl_null(sr.hraa02) 
                	 AND NOT cl_null(sr.hraa12) AND NOT cl_null(sr.hraa10) THEN 
                	IF i > 1 THEN
                    INSERT INTO hraa_file(hraa01,hraa02,hraa12,hraa03,hraa05,hraa06,hraa10,hraaacti,hraauser,hraagrup,hraadate,hraaorig,hraaoriu)
                      VALUES (sr.hraa01,sr.hraa02,sr.hraa12,sr.hraa03,sr.hraa05,sr.hraa06,sr.hraa10,'Y',g_user,g_grup,g_today,g_grup,g_user)
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hraa_file",sr.hraa01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 
                  END IF 
                END IF 
                  # LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
       SELECT * INTO g_hraa.* FROM hraa_file
       WHERE hraa01=sr.hraa01
       
       CALL i000_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------


