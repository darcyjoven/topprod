# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri027.4gl
# Descriptions...: 人员兼职维护作业
# Date & Author..: 13/04/16 By yangjian

DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義

DEFINE tm                    RECORD 
            wc       STRING
                END  RECORD
DEFINE g_hrbj                RECORD LIKE hrbj_file.*
DEFINE g_hrbj_t              RECORD LIKE hrbj_file.*
DEFINE g_hrag                RECORD LIKE hrag_file.*
DEFINE g_rec_b                LIKE type_file.num10
DEFINE l_ac                   LIKE type_file.num5
DEFINE g_hrat01              LIKE hrat_file.hrat01
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE hrbj_file.hrbjacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE g_bp_flag           LIKE type_file.chr10
DEFINE g_hrbj_1                DYNAMIC ARRAY OF RECORD
                hrbj01       LIKE hrbj_file.hrbj01,
                hrbj02       LIKE hrbj_file.hrbj02,
                hrbj03       LIKE hrbj_file.hrbj03,
                hrat03       LIKE hrao_file.hrao02,
                hrat04       LIKE hrao_file.hrao02,
                hrat05       LIKE hrap_file.hrap06,
                hrbj04       LIKE hrbj_file.hrbj04,
                hrbj05       LIKE hrbj_file.hrbj05,
                hrbj06       LIKE hrbj_file.hrbj06,
                hrbj07       LIKE hrbj_file.hrbj07,
                hrbj08       LIKE hrbj_file.hrbj08,
                hrbj09       LIKE hrbj_file.hrbj09,
                hrbj10       LIKE hrbj_file.hrbj10,
                hrbj11       LIKE hrbj_file.hrbj11,
                hrbj12       LIKE hrbj_file.hrbj12,
                hrbj13       LIKE hrbj_file.hrbj13,
                hrbj14       LIKE hrbj_file.hrbj14,
                hrbj15       LIKE hrbj_file.hrbj15,
                hrbj16       LIKE hrbj_file.hrbj16,
                hrbj17       LIKE hrbj_file.hrbj17,
                hrad03       LIKE hrad_file.hrad03,
                hrbh02       LIKE hrbh_file.hrbh02,
                lzyy         LIKE hrag_file.hrag07                            
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
   INITIALIZE g_hrbj.* TO NULL
   INITIALIZE g_hrat01 TO NULL
 
   LET g_forupd_sql = "SELECT * FROM hrbj_file WHERE hrbj01 = ? ",
                      "   FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i027_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i027_w WITH FORM "ghr/42f/ghri027"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊
  
   CALL cl_set_comp_visible("hrbj02",FALSE)
 
   LET g_action_choice = ""
   CALL i027_menu()                                         #進入選單 Menu
 
   CLOSE WINDOW i027_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i027_curs()

    CLEAR FORM
    INITIALIZE g_hrbj.* TO NULL   
    INITIALIZE g_hrat01  TO NULL
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hrbj01,g_hrat01,hrbj02,hrbj03,hrbj04,hrbj05,hrbj06,
        hrbj07,hrbj08,hrbj09,hrbj10,hrbj11,hrbj12,hrbj13, 
        hrbj14,hrbj15,hrbj16,
        hrbj17,hrbj18,             #add by zhangbo130904
        hrbjuser,hrbjgrup,hrbjmodu,hrbjdate,hrbjacti,hrbjoriu,hrbjorig,
        hrbjud02,hrbjud03,hrbjud04,hrbjud05,hrbjud06,hrbjud07,hrbjud08,
        hrbjud09,hrbjud10,hrbjud11,hrbjud12,hrbjud13,hrbjud14,hrbjud15,hrbjud01   # add by hourf   13/05/16    
        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(g_hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO g_hrat01
                 NEXT FIELD g_hrat01
              WHEN INFIELD(hrbj01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbj01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbj01
                 NEXT FIELD hrbj01 
              WHEN INFIELD(hrbj07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbj07
                 NEXT FIELD hrbj07 
              WHEN INFIELD(hrbj04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '314'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbj04
                 NEXT FIELD hrbj04 
              WHEN INFIELD(hrbj08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '301'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbj08
                 NEXT FIELD hrbj08
              WHEN INFIELD(hrbj09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '334'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbj09
                 NEXT FIELD hrbj09 
              WHEN INFIELD(hrbj15)
                 CALL cl_init_qry_var()              
                 LET g_qryparam.arg1 = '317'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbj15
                 NEXT FIELD hrbj15                                                                                                      
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbjuser', 'hrbjgrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位
    LET g_wc = cl_replace_str(g_wc,"g_hrat01","hrat01")

    LET g_sql = "SELECT DISTINCT hrbj01 FROM hrbj_file ",
                " LEFT OUTER JOIN hrat_file ON hrbj02 = hratid ",
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY hrbj01"
    PREPARE i027_prepare FROM g_sql
    DECLARE i027_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i027_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrbj01) FROM hrbj_file ",
                "  LEFT OUTER JOIN hrat_file ON hrbj02 = hratid ",
                " WHERE ",g_wc CLIPPED 
    PREPARE i027_precount FROM g_sql
    DECLARE i027_count CURSOR FOR i027_precount
END FUNCTION
 

FUNCTION i027_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
         LET g_action_choice = "" 
         CALL i027_b_menu()  
         IF g_action_choice = "exit" THEN  
            EXIT MENU  
         END IF   
         
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i027_a()
            END IF
        
        ON ACTION import
            LET g_action_choice="import"
            IF cl_chk_act_auth() THEN
                 CALL i027_import()
            END IF
        
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i027_q()
            END IF

        ON ACTION next
            CALL i027_fetch('N')

        ON ACTION previous
            CALL i027_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i027_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i027_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i027_r()
            END IF
 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i027_fetch('/')

        ON ACTION first
            CALL i027_fetch('F')

        ON ACTION last
            CALL i027_fetch('L')

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
           
#        ON ACTION ghri027_a
#           LET g_action_choice = "ghri027_a"
#           IF cl_chk_act_auth() THEN 
#              CALL i027_batch_invalid()
#           END IF 
#           
#        ON ACTION ghri027_b
#           LET g_action_choice = "ghri027_b"
#           IF cl_chk_act_auth() THEN 
#              CALL i027_batch_valid()
#           END IF 
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrbj.hrbj01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrbj01"
                 LET g_doc.value1 = g_hrbj.hrbj01
                 CALL cl_doc()
              END IF
           END IF

         &include "qry_string.4gl"
    END MENU
    CLOSE i027_cs
END FUNCTION
 
 
FUNCTION i027_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hrbj.* LIKE hrbj_file.*
    INITIALIZE g_hrat01 TO NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbj.hrbj17 = g_today       #add by zhangbo130904
        LET g_hrbj.hrbjuser = g_user
        LET g_hrbj.hrbjoriu = g_user 
        LET g_hrbj.hrbjorig = g_grup 
        LET g_hrbj.hrbjgrup = g_grup               #使用者所屬群
        LET g_hrbj.hrbjdate = g_today
        LET g_hrbj.hrbjacti = 'Y'
        SELECT TO_CHAR(MAX(hrbj01)+1,'fm999999999999') INTO g_hrbj.hrbj01 FROM hrbj_file 
         WHERE substr(hrbj01,1,8) LIKE to_char(sysdate,'yyyyMMdd')
        IF g_hrbj.hrbj01 IS NULL THEN 
        	 LET g_hrbj.hrbj01 = g_today USING "yyyymmdd"||'0001'
        END IF 
        CALL i027_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hrbj.* TO NULL
            INITIALIZE g_hrat01 TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrbj.hrbj01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO hrbj_file VALUES(g_hrbj.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbj_file",g_hrbj.hrbj01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660151
            CONTINUE WHILE
        ELSE
            SELECT hrbj01 INTO g_hrbj.hrbj01 FROM hrbj_file WHERE hrbj01 = g_hrbj.hrbj01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i027_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_hrat01,
      g_hrbj.hrbj01,g_hrbj.hrbj02,g_hrbj.hrbj03,g_hrbj.hrbj04,g_hrbj.hrbj05,g_hrbj.hrbj06,
      g_hrbj.hrbj07,g_hrbj.hrbj08,g_hrbj.hrbj09,g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,
      g_hrbj.hrbj13,g_hrbj.hrbj14,g_hrbj.hrbj15,g_hrbj.hrbj16,
      g_hrbj.hrbj17,g_hrbj.hrbj18,                                            #add by zhangbo130904
      g_hrbj.hrbjuser,g_hrbj.hrbjgrup,g_hrbj.hrbjmodu,g_hrbj.hrbjdate,g_hrbj.hrbjacti,
      g_hrbj.hrbjoriu,g_hrbj.hrbjorig,
      g_hrbj.hrbjud02,g_hrbj.hrbjud03,g_hrbj.hrbjud04,g_hrbj.hrbjud05,g_hrbj.hrbjud06,
      g_hrbj.hrbjud07,g_hrbj.hrbjud08,g_hrbj.hrbjud09,g_hrbj.hrbjud10,g_hrbj.hrbjud11,
      g_hrbj.hrbjud12,g_hrbj.hrbjud13,g_hrbj.hrbjud14,g_hrbj.hrbjud15,g_hrbj.hrbjud01     # add by hourf   13/05/16
 
   INPUT BY NAME
      g_hrbj.hrbj01,g_hrat01,g_hrbj.hrbj02,g_hrbj.hrbj03,g_hrbj.hrbj07,g_hrbj.hrbj06,g_hrbj.hrbj04,
      g_hrbj.hrbj05,g_hrbj.hrbj08,g_hrbj.hrbj09,g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,
      g_hrbj.hrbj13,g_hrbj.hrbj14,g_hrbj.hrbj15,g_hrbj.hrbj16,
      g_hrbj.hrbj17,g_hrbj.hrbj18,                                            #add by zhangbo130904
      g_hrbj.hrbjud02,g_hrbj.hrbjud03,g_hrbj.hrbjud04,g_hrbj.hrbjud05,g_hrbj.hrbjud06,
      g_hrbj.hrbjud07,g_hrbj.hrbjud08,g_hrbj.hrbjud09,g_hrbj.hrbjud10,g_hrbj.hrbjud11,
      g_hrbj.hrbjud12,g_hrbj.hrbjud13,g_hrbj.hrbjud14,g_hrbj.hrbjud15,g_hrbj.hrbjud01     # add by hourf   13/05/16
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i027_set_entry(p_cmd)
          CALL i027_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD g_hrat01
         IF g_hrat01 IS NOT NULL THEN
            CALL i027_hrat01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('hrbj01:',g_errno,1)
               LET g_hrbj.hrbj02 = NULL
               LET g_hrat01 = NULL
               DISPLAY BY NAME g_hrbj.hrbj02,g_hrat01
               NEXT FIELD g_hrat01
            END IF
         END IF

    #证件类型
      AFTER FIELD hrbj04
         IF NOT cl_null(g_hrbj.hrbj04) THEN
           	CALL s_code('314',g_hrbj.hrbj04) RETURNING g_hrag.*
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD hrbj04  
            END IF
              DISPLAY g_hrag.hrag07 TO hrbj04_name
              IF g_hrag.hrag07 = '大陆身份证' OR g_hrag.hrag07 = '大陸身份證' THEN
              	  CALL cl_set_comp_required('hrbj05',TRUE)
              ELSE
              	  CALL cl_set_comp_required('hrbj05',FALSE)
              END IF	  
         END IF
         
    #性别
      AFTER FIELD hrbj07
         IF NOT cl_null(g_hrbj.hrbj07) THEN 
   	        CALL s_code('333',g_hrbj.hrbj07) RETURNING g_hrag.*
            IF NOT cl_null(g_errno) THEN
            	 CALL cl_err('',g_errno,0)
            	 NEXT FIELD hrbj07
            END IF
           DISPLAY g_hrag.hrag07 TO hrbj07_name
         END IF 

    #民族
      AFTER FIELD hrbj08
         IF NOT cl_null(g_hrbj.hrbj08) THEN 
   	        CALL s_code('301',g_hrbj.hrbj08) RETURNING g_hrag.*
            IF NOT cl_null(g_errno) THEN
             	 CALL cl_err('',g_errno,0)
            	 NEXT FIELD hrbj08          	
            END IF
            DISPLAY g_hrag.hrag07 TO hrbj08_name
         END IF 
         
    #婚姻
      AFTER FIELD hrbj09
         IF NOT cl_null(g_hrbj.hrbj09) THEN 
   	        CALL s_code('334',g_hrbj.hrbj09) RETURNING g_hrag.*
            IF NOT cl_null(g_errno) THEN
            	 CALL cl_err('',g_errno,0)
            	 NEXT FIELD hrbj09
            END IF
           DISPLAY g_hrag.hrag07 TO hrbj09_name
         END IF 
         
    #学历
      AFTER FIELD hrbj15
         IF NOT cl_null(g_hrbj.hrbj15) THEN 
   	        CALL s_code('317',g_hrbj.hrbj15) RETURNING g_hrag.*
            IF NOT cl_null(g_errno) THEN
            	 CALL cl_err('',g_errno,0)
            	 NEXT FIELD hrbj15
            END IF
           DISPLAY g_hrag.hrag07 TO hrbj15_name
         END IF                   
 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

 
     ON ACTION controlp
        CASE
              WHEN INFIELD(g_hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.default1 = g_hrat01
                 CALL cl_create_qry() RETURNING g_hrat01
                 DISPLAY g_hrat01 TO g_hrat01
                 NEXT FIELD g_hrat01
              WHEN INFIELD(hrbj07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.default1 = g_hrbj.hrbj07
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbj.hrbj07
                 DISPLAY g_hrbj.hrbj07 TO hrbj07
                 NEXT FIELD hrbj07 
              WHEN INFIELD(hrbj04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '314'
                 LET g_qryparam.default1 = g_hrbj.hrbj04
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbj.hrbj04
                 DISPLAY g_hrbj.hrbj04 TO hrbj04
                 NEXT FIELD hrbj04 
              WHEN INFIELD(hrbj08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '301'
                 LET g_qryparam.default1 = g_hrbj.hrbj08
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbj.hrbj08
                 DISPLAY g_hrbj.hrbj08 TO hrbj08
                 NEXT FIELD hrbj08
              WHEN INFIELD(hrbj09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '334'
                 LET g_qryparam.default1 = g_hrbj.hrbj09
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbj.hrbj09
                 DISPLAY g_hrbj.hrbj09 TO hrbj09
                 NEXT FIELD hrbj09 
              WHEN INFIELD(hrbj15)
                 CALL cl_init_qry_var()              
                 LET g_qryparam.arg1 = '317'
                 LET g_qryparam.default1 = g_hrbj.hrbj15
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbj.hrbj15
                 DISPLAY g_hrbj.hrbj15 TO hrbj15
                 NEXT FIELD hrbj15  
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
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 


FUNCTION i027_hrat01(p_cmd)

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrat02   LIKE hrat_file.hrat02
   DEFINE l_hrat03   LIKE hrat_file.hrat04
   DEFINE l_hrat04   LIKE hrat_file.hrat04
   DEFINE l_hrat05   LIKE hrat_file.hrat05
   DEFINE l_hrat03_name   LIKE type_file.chr100
   DEFINE l_hrat04_name   LIKE type_file.chr100
   DEFINE l_hrat05_name   LIKE type_file.chr100
   DEFINE l_hrat42s  LIKE hrat_file.hrat42
   DEFINE l_hrat25   LIKE hrat_file.hrat25
   DEFINE l_hratacti LIKE hrat_file.hratacti
   DEFINE l_hratid   LIKE hrat_file.hratid
   #带出员工状态和离退原因离退类型add by wangwy 20170214
   DEFINE l_hrad03   LIKE hrad_file.hrad03
   DEFINE l_hrbh02   LIKE hrbh_file.hrbh02
   DEFINE l_hrbh05   LIKE hrbh_file.hrbh05
   DEFINE l_lzyy     LIKE hrag_file.hrag07
   #end
 
   LET g_errno=''
   CASE p_cmd 
      WHEN 'd' 
         SELECT hrat03,hrat04,hrat05,hratacti,
                hratid
           INTO l_hrat03,l_hrat04,l_hrat05,l_hratacti,
                g_hrbj.hrbj02
           FROM hrat_file
          WHERE hrat01 = g_hrat01
            AND hratconf = 'Y'
            AND ROWNUM = 1
      WHEN 'a' 
         SELECT hrat03,hrat04,hrat05,hratacti,
                hratid,hrat02,
                hrat17,hrat15,hrat12,hrat13,
                hrat29,hrat24,hrat18,hrat45,
                hrat46,hrat49,hrat51,hrat22,
                hrat23
           INTO l_hrat03,l_hrat04,l_hrat05,l_hratacti,
                g_hrbj.hrbj02,g_hrbj.hrbj03,
                g_hrbj.hrbj07,g_hrbj.hrbj06,g_hrbj.hrbj04,
                g_hrbj.hrbj05,g_hrbj.hrbj08,g_hrbj.hrbj09,
                g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,
                g_hrbj.hrbj13,g_hrbj.hrbj14,g_hrbj.hrbj15,
                g_hrbj.hrbj16
           FROM hrat_file
          WHERE hrat01 = g_hrat01
            AND hratconf = 'Y'
            AND ROWNUM = 1
   END CASE
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-031'
                                LET l_hrat02=NULL  LET l_hrat04=NULL  LET l_hrat05=NULL
       WHEN l_hratacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      CALL i027_hrat03(l_hrat03) RETURNING l_hrat03_name
      CALL i027_hrat04(l_hrat04) RETURNING l_hrat04_name
      CALL i027_hrat05(l_hrat04,l_hrat05) RETURNING l_hrat05_name
      #带出员工状态和离退原因离退类型add by wangwy 20170214
      SELECT hrad03 INTO l_hrad03 FROM hrat_file LEFT join hrad_file ON hrat19=hrad02 WHERE hrat01=g_hrat01
      SELECT hrbh02,hrbh05 INTO l_hrbh02,l_hrbh05 FROM (SELECT * FROM hrbh_file WHERE hrbh01=g_hrbj.hrbj02 ORDER BY hrbh03 desc ) WHERE rownum = 1  #多笔离职资料取最新一笔
      SELECT hrag07 INTO l_lzyy FROM hrag_file WHERE hrag01='310' AND hrag06=l_hrbh05
      #end
      DISPLAY BY NAME g_hrbj.hrbj02,g_hrbj.hrbj03,g_hrbj.hrbj04,g_hrbj.hrbj05,
                      g_hrbj.hrbj06,g_hrbj.hrbj07,g_hrbj.hrbj08,g_hrbj.hrbj09,
                      g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,g_hrbj.hrbj13,
                      g_hrbj.hrbj14,g_hrbj.hrbj15,g_hrbj.hrbj16
      DISPLAY l_hrat03 TO FORMONLY.hrat03
      DISPLAY l_hrat04 TO FORMONLY.hrat04
      DISPLAY l_hrat05 TO FORMONLY.hrat05
      DISPLAY l_hrat03_name TO FORMONLY.hrat03_name
      DISPLAY l_hrat04_name TO FORMONLY.hrat04_name
      DISPLAY l_hrat05_name TO FORMONLY.hrat05_name
      #带出员工状态和离退原因离退类型add by wangwy 20170214
      DISPLAY l_hrad03 TO FORMONLY.hrad03
      DISPLAY l_hrbh02 TO FORMONLY.hrbh02
      DISPLAY l_lzyy TO FORMONLY.lzyy
      #end
   END IF
END FUNCTION


FUNCTION i027_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrbj.* TO NULL    
    INITIALIZE g_hrat01 TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i027_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i027_count
    FETCH i027_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i027_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbj.hrbj01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbj.* TO NULL
        INITIALIZE g_hrat01 TO NULL
    ELSE
        CALL i027_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i027_fetch(p_flhrbj)
    DEFINE p_flhrbj         LIKE type_file.chr1
 
    CASE p_flhrbj
        WHEN 'N' FETCH NEXT     i027_cs INTO g_hrbj.hrbj01
        WHEN 'P' FETCH PREVIOUS i027_cs INTO g_hrbj.hrbj01
        WHEN 'F' FETCH FIRST    i027_cs INTO g_hrbj.hrbj01
        WHEN 'L' FETCH LAST     i027_cs INTO g_hrbj.hrbj01
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
            FETCH ABSOLUTE g_jump i027_cs INTO g_hrbj.hrbj01
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbj.hrbj01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbj.* TO NULL  
        INITIALIZE g_hrat01 TO NULL
        LET g_hrbj.hrbj01 = NULL   LET g_hrat01 = NULL      
        LET g_hrbj.hrbj02 = NULL   LET g_hrbj.hrbj03 = NULL
        RETURN
    ELSE
      CASE p_flhrbj
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_hrbj.* FROM hrbj_file    # 重讀DB,因TEMP有不被更新特性
     WHERE hrbj01 = g_hrbj.hrbj01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbj_file",g_hrbj.hrbj01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_hrbj.hrbjuser           #FUN-4C0044權限控管
        LET g_data_group=g_hrbj.hrbjgrup
        CALL i027_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i027_show()

    LET g_hrbj_t.* = g_hrbj.*
    SELECT hrat01 INTO g_hrat01 FROM hrat_file WHERE hratid = g_hrbj.hrbj02
    DISPLAY BY NAME g_hrat01,
                    g_hrbj.hrbj01,g_hrbj.hrbj02,g_hrbj.hrbj03,g_hrbj.hrbj04,g_hrbj.hrbj05,g_hrbj.hrbj06,
                    g_hrbj.hrbj07,g_hrbj.hrbj08,g_hrbj.hrbj09,g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,
                    g_hrbj.hrbj13,g_hrbj.hrbj14,g_hrbj.hrbj15,g_hrbj.hrbj16,
                    g_hrbj.hrbj17,g_hrbj.hrbj18,                                            #add by zhangbo130904
                    g_hrbj.hrbjuser,g_hrbj.hrbjgrup,g_hrbj.hrbjmodu,
                    g_hrbj.hrbjdate,g_hrbj.hrbjacti,g_hrbj.hrbjorig,g_hrbj.hrbjoriu,
                    g_hrbj.hrbjud02,g_hrbj.hrbjud03,g_hrbj.hrbjud04,g_hrbj.hrbjud05,g_hrbj.hrbjud06,
                    g_hrbj.hrbjud07,g_hrbj.hrbjud08,g_hrbj.hrbjud09,g_hrbj.hrbjud10,g_hrbj.hrbjud11,
                    g_hrbj.hrbjud12,g_hrbj.hrbjud13,g_hrbj.hrbjud14,g_hrbj.hrbjud15,g_hrbj.hrbjud01    # add by hourf   13/05/16
    CALL i027_hrat01('d')
    CALL s_code('314',g_hrbj.hrbj04) RETURNING g_hrag.*
    DISPLAY g_hrag.hrag07 TO hrbj04_name 
    CALL s_code('333',g_hrbj.hrbj07) RETURNING g_hrag.*
    DISPLAY g_hrag.hrag07 TO hrbj07_name 
    CALL s_code('301',g_hrbj.hrbj08) RETURNING g_hrag.*
    DISPLAY g_hrag.hrag07 TO hrbj08_name 
    CALL s_code('334',g_hrbj.hrbj09) RETURNING g_hrag.*
    DISPLAY g_hrag.hrag07 TO hrbj09_name 
    CALL s_code('317',g_hrbj.hrbj15) RETURNING g_hrag.*
    DISPLAY g_hrag.hrag07 TO hrbj15_name 
    
    CALL i027_list_fill() 
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i027_u()
    IF g_hrbj.hrbj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrbj.* FROM hrbj_file WHERE hrbj01=g_hrbj.hrbj01
       
    IF g_hrbj.hrbjacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
   
    BEGIN WORK
 
    OPEN i027_cl USING g_hrbj.hrbj01
    IF STATUS THEN
       CALL cl_err("OPEN i027_cl:", STATUS, 1)
       CLOSE i027_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i027_cl INTO g_hrbj.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbj.hrbj01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrbj.hrbjmodu=g_user                  #修改者
    LET g_hrbj.hrbjdate = g_today               #修改日期
    CALL i027_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i027_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET g_hrbj_t.* = g_hrbj.*
            LET INT_FLAG = 0
            CALL i027_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrbj_file SET hrbj_file.* = g_hrbj.*    # 更新DB
            WHERE hrbj01 = g_hrbj_t.hrbj01     
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrbj_file",g_hrbj.hrbj01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660151
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i027_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i027_x()
    IF g_hrbj.hrbj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i027_cl USING g_hrbj.hrbj01
    IF STATUS THEN
       CALL cl_err("OPEN i027_cl:", STATUS, 1)
       CLOSE i027_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i027_cl INTO g_hrbj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbj.hrbj01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i027_show()
    IF cl_exp(0,0,g_hrbj.hrbjacti) THEN
        LET g_chr = g_hrbj.hrbjacti
        IF g_hrbj.hrbjacti='Y' THEN
            LET g_hrbj.hrbjacti='N'
        ELSE
            LET g_hrbj.hrbjacti='Y'
        END IF
        UPDATE hrbj_file
            SET hrbjacti=g_hrbj.hrbjacti
            WHERE hrbj01=g_hrbj.hrbj01 
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrbj.hrbj01,SQLCA.sqlcode,0)
            LET g_hrbj.hrbjacti = g_chr
        END IF
        DISPLAY BY NAME g_hrbj.hrbjacti
    END IF
    CLOSE i027_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i027_r()
    IF g_hrbj.hrbj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i027_cl USING g_hrbj.hrbj01
    IF STATUS THEN
       CALL cl_err("OPEN i027_cl:", STATUS, 0)
       CLOSE i027_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i027_cl INTO g_hrbj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbj.hrbj01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i027_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrbj01"   
       LET g_doc.value1 = g_hrbj.hrbj01 

       CALL cl_del_doc()
       DELETE FROM hrbj_file WHERE hrbj01 = g_hrbj.hrbj01

       CLEAR FORM
       OPEN i027_count
       IF STATUS THEN
          CLOSE i027_cl
          CLOSE i027_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i027_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i027_cl
          CLOSE i027_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i027_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i027_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i027_fetch('/')
       END IF
    END IF
    CLOSE i027_cl
    COMMIT WORK
END FUNCTION

 
FUNCTION i027_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
   END IF
END FUNCTION

 
FUNCTION i027_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
   END IF
END FUNCTION

FUNCTION i027_hrat03(p_hrat03) 
 DEFINE p_hrat03      LIKE hrat_file.hrat03
   DEFINE l_hraa02    LIKE hraa_file.hraa02 
   DEFINE l_hraaacti  LIKE hraa_file.hraaacti 

   SELECT hraa02,hraaacti INTO l_hraa02,l_hraaacti FROM hraa_file
    WHERE hraa01=p_hrat03
#   CASE
#       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
#                                LET l_hraa02=NULL
#  
#       WHEN l_hraaacti='N'      LET g_errno='9028'
#       OTHERWISE
#            LET g_errno=SQLCA.sqlcode USING '------'
#   END CASE
    RETURN l_hraa02
END FUNCTION

FUNCTION i027_hrat04(p_hrat04)
   DEFINE p_hrat04    LIKE hrat_file.hrat04
   DEFINE l_hrao02    LIKE hrao_file.hrao02
   DEFINE l_hraoacti  LIKE hrao_file.hraoacti

   LET g_errno=''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti FROM hrao_file
    WHERE hrao01=p_hrat04 
  #CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='ghr-009'
  #                             LET l_hrao02=NULL

  #    WHEN l_hraoacti='N'       LET g_errno='9028'
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  #END CASE
   RETURN l_hrao02
END FUNCTION


FUNCTION i027_hrat05(p_hrat04,p_hrat05)
   DEFINE p_hrat04    LIKE hrat_file.hrat04
   DEFINE p_hrat05    LIKE hrat_file.hrat05
   DEFINE l_hrap06    LIKE hrap_file.hrap06
   DEFINE l_hrapacti  LIKE hrap_file.hrapacti

   LET g_errno=''
   SELECT hrap06,hrapacti INTO l_hrap06,l_hrapacti FROM hrap_file
    WHERE hrap05=p_hrat05 AND hrap01 = p_hrat04
  #CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='ghr-010'
  #                             LET l_hrap06=NULL

  #    WHEN l_hrapacti='N'       LET g_errno='9028'
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  #END CASE
   RETURN l_hrap06 
END FUNCTION


FUNCTION i027_batch_invalid()
   CALL i027_batch('invalid')
END FUNCTION

FUNCTION i027_batch_valid()
   CALL i027_batch('valid')
END FUNCTION

FUNCTION i027_batch(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr100
 DEFINE l_hrbjacti  LIKE hrbj_file.hrbjacti
 DEFINE l_flag      LIKE type_file.chr1      #add by zhangbo130903
   
   #add by zhangbo130903---begin
   IF p_cmd = 'valid' THEN
      LET l_flag = 'N'
   ELSE
      LET l_flag = 'Y'
   END IF
   #add by zhangbo130903---end
 
   IF NOT cl_confirm('abx-080') THEN RETURN END IF 
   
   OPEN WINDOW i027_w1 WITH FORM "ghr/42f/ghri027_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()  
   
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON hrbj01  
        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbj01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbj01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " hrbjacti='",l_flag,"' "    #add by zhangbo130903
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbj01
                 NEXT FIELD hrbj01 
            END CASE 
            
        ON ACTION locale
              #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT CONSTRUCT
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
       
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
       
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
      END CONSTRUCT  
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW i027_w1 
         RETURN
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF   
      EXIT WHILE  
   END WHILE
   CLOSE WINDOW i027_w1
   
   CASE p_cmd
      WHEN 'invalid'
         LET l_hrbjacti = 'N'
      WHEN 'valid'    
         LET l_hrbjacti = 'Y'
      OTHERWISE
         LET l_hrbjacti = NULL
   END CASE 
   
   LET g_sql = "UPDATE hrbj_file SET hrbjacti = '",l_hrbjacti,"', ",
               "                     hrbjmodu = '",g_user,"', ",
               "                     hrbjdate = '",g_today,"' ",
               " WHERE 1=1 ",
               "   AND ",tm.wc CLIPPED
   PREPARE i027_batch FROM g_sql
   EXECUTE i027_batch 
   IF SQLCA.sqlcode THEN 
   	  CALL cl_err('',SQLCA.sqlcode,0)
   	  CALL cl_err('','abm-020',1)
   ELSE 
      CALL cl_err('','abm-019',1)
   END IF
END FUNCTION

FUNCTION i027_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       l_hrbj10 LIKE hrbj_file.hrbj10,
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrbj01  LIKE hrbj_file.hrbj01,
         hrbj02  LIKE hrbj_file.hrbj02,
         hrbj03  LIKE hrbj_file.hrbj03,
         hrbj04  LIKE hrbj_file.hrbj04,
         hrbj05  LIKE hrbj_file.hrbj05,
         hrbj06  LIKE hrbj_file.hrbj06,
         hrbj07  LIKE hrbj_file.hrbj07,
         hrbj08  LIKE hrbj_file.hrbj08,
         hrbj09  LIKE hrbj_file.hrbj09,
         hrbj10  LIKE hrbj_file.hrbj10,
         hrbj11  LIKE hrbj_file.hrbj11,
         hrbj12  LIKE hrbj_file.hrbj12,
         hrbj13  LIKE hrbj_file.hrbj13,
         hrbj14  LIKE hrbj_file.hrbj14,
         hrbj15  LIKE hrbj_file.hrbj15,
         hrbj16  LIKE hrbj_file.hrbj16,
         hrbj17  LIKE hrbj_file.hrbj17,
         hrbj18  LIKE hrbj_file.hrbj18
         
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
DEFINE   l_hrbj  RECORD  LIKE hrbj_file.*


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
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrbj02])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hrbj03])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrbj04])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrbj05])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrbj06])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrbj07])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrbj08])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrbj09])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrbj10])  
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[sr.hrbj11]) 
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrbj12]) 
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[sr.hrbj13]) 
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',13).Value'],[sr.hrbj14]) 
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',14).Value'],[sr.hrbj15]) 
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',15).Value'],[sr.hrbj16]) 
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',16).Value'],[sr.hrbj17]) 
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',17).Value'],[sr.hrbj18]) 
                 
                IF NOT cl_null(sr.hrbj02) AND NOT cl_null(sr.hrbj05) AND NOT cl_null(sr.hrbj04) AND NOT cl_null(sr.hrbj17) THEN
                   SELECT hratid INTO sr.hrbj01 FROM hrat_file WHERE hrat01=sr.hrbj01
                   SELECT TO_CHAR(MAX(hrbj01)+1,'fm999999999999') INTO sr.hrbj01 FROM hrbj_file 
                    WHERE substr(hrbj01,1,8) LIKE to_char(sysdate,'yyyyMMdd')
                   IF sr.hrbj01 IS NULL THEN 
                   	 LET sr.hrbj01 = g_today USING "yyyymmdd"||'0001'
                   END IF 
                   IF i > 1 THEN
                    INSERT INTO hrbj_file(hrbj01,hrbj02,hrbj03,hrbj04,hrbj05,hrbj06,hrbj07,hrbj08,hrbj09,hrbj10,hrbj11,hrbj12,
                                          hrbj13,hrbj14,hrbj15,hrbj16,hrbj17,hrbj18,hrbjacti,hrbjuser,hrbjgrup,hrbjdate,hrbjorig,hrbjoriu)
                      VALUES (sr.hrbj01,sr.hrbj02,sr.hrbj03,sr.hrbj04,sr.hrbj05,sr.hrbj06,sr.hrbj07,sr.hrbj08,sr.hrbj09,sr.hrbj10,sr.hrbj11,sr.hrbj12,
                             sr.hrbj13,sr.hrbj14,sr.hrbj15,sr.hrbj16,sr.hrbj17,sr.hrbj18,'Y',g_user,g_grup,g_today,g_grup,g_user)
                     
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrbj_file",sr.hrbj01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 
                   END IF 
                END IF 
                   #LET i = i + 1
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
              CALL cl_err( '打开工作簿失败','!', 1 )
          END IF
       ELSE
           DISPLAY 'NO EXCEL'
           CALL cl_err( '打开文件失败','!', 1 )
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
#       SELECT * INTO g_hrbj.* FROM hrbj_file
#       WHERE hrbjid=l_hrbjid
#       
#       CALL i044_show()
   END IF 

END FUNCTION 

FUNCTION i027_b_menu()
   WHILE TRUE

      CALL i027_bp("G")  

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrbj_file.* 
           INTO g_hrbj.* 
           FROM hrbj_file 
          WHERE hrbj01=g_hrbj_1[l_ac].hrbj01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'pg'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i027_fetch('/')
         END IF
      END IF

      CASE g_action_choice
           WHEN "insert"
               IF cl_chk_act_auth() THEN   
                  CALL i027_a()
               END IF
               EXIT WHILE

           WHEN "import"
               IF cl_chk_act_auth() THEN
                   CALL i027_import()
               END IF

           WHEN "query"
               IF cl_chk_act_auth() THEN  
                    CALL i027_q()
               END IF
               EXIT WHILE
           
           WHEN "modify"
               IF cl_chk_act_auth() THEN   
                  LET g_curs_index = ARR_CURR()
                  CALL i027_u()
               END IF
               EXIT WHILE
           
           WHEN "exporttoexcel"
              IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbj_1),'','')
              END IF
           
           WHEN "delete"
               IF cl_chk_act_auth() THEN   
                  CALL i027_r()
               END IF
           
           WHEN "help"
               CALL cl_show_help()
           
           WHEN "locale"
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()                 

           WHEN "exit"
              EXIT WHILE
           
           WHEN "g_idle_seconds"
              CALL cl_on_idle()
           
           WHEN "about"
              CALL cl_about()      
           
           WHEN "controlg"     
              CALL cl_cmdask()     
           
           OTHERWISE 
               EXIT WHILE
      END CASE
   END WHILE

END FUNCTION 


FUNCTION i027_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbj_1 TO s_hrbj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
   BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i027_fetch('/')
         CALL cl_set_comp_visible("Page2,Page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2,Page4", TRUE)
         EXIT DISPLAY
 
      ON ACTION next
         CALL i027_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION previous
         CALL i027_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION jump
         CALL i027_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION first
         CALL i027_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION last
         CALL i027_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"   #MOD-A70076
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"
         EXIT DISPLAY

      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY 
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
   IF INT_FLAG THEN
      CALL cl_set_comp_visible("Page2", FALSE)
      CALL cl_set_comp_visible("Page1", FALSE)
      CALL cl_set_comp_visible("Page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("Page2", TRUE)
      CALL cl_set_comp_visible("Page1", TRUE)
      CALL cl_set_comp_visible("Page3", TRUE)
      LET INT_FLAG = 0
   END IF
END FUNCTION

FUNCTION i027_list_fill()
  DEFINE l_hrbh01         LIKE hrbh_file.hrbh01,
         l_hrbh03         LIKE hrbh_file.hrbh03
  DEFINE l_i              LIKE type_file.num10
  DEFINE l_hratid         LIKE hrat_file.hratid
  DEFINE l_bh05           LIKE hrbh_file.hrbh05
  
  CALL g_hrbj_1.clear()
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbhuser', 'hrbhgrup')
   IF cl_null(g_wc) THEN 
      LET g_wc=" 1=1"
   END IF 

   LET g_sql = "SELECT hrbj01,hrat01,hrbj03,hraa02,hrao02,hrap06,hrbj04,
                       hrbj05,hrbj06,hrbj07,hrbj08,hrbj09,hrbj10,hrbj11,
                       hrbj12,hrbj13,hrbj14,hrbj15,hrbj16,hrbj17,hrad03,'',''
                        FROM hrbj_file
                left join hrat_file on hratid=hrbj02
                left join hraa_file on hrat03=hraa01
                left join hrao_file on hrao01=hrat04
                left join hrap_file on hrap05=hrat05 and hrap01=hrat04
                left join hrad_file on hrat19=hrad02
                WHERE ",g_wc CLIPPED,
                "ORDER BY hrbj01 " 
               
   PREPARE i027sub_prepare FROM g_sql


   DECLARE i027sub_list_cur CURSOR FOR i027sub_prepare  
   
   
    LET l_i = 1
    FOREACH i027sub_list_cur INTO g_hrbj_1[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
         IF NOT cl_null(g_hrbj_1[l_i].hrbj04) THEN 
          CALL s_code('314',g_hrbj_1[l_i].hrbj04) RETURNING g_hrag.*
            IF NOT cl_null(g_hrag.hrag07) THEN LET 	g_hrbj_1[l_i].hrbj04=g_hrag.hrag07 
            END IF 
         END IF
         
    #性别
         IF NOT cl_null(g_hrbj_1[l_i].hrbj07) THEN 
   	        CALL s_code('333',g_hrbj.hrbj07) RETURNING g_hrag.*
            IF NOT cl_null(g_hrag.hrag07) THEN LET g_hrbj_1[l_i].hrbj07=g_hrag.hrag07 
            END IF
         END IF 

    #民族
         IF NOT cl_null(g_hrbj_1[l_i].hrbj08) THEN 
   	        CALL s_code('301',g_hrbj.hrbj08) RETURNING g_hrag.*
            IF NOT cl_null(g_hrag.hrag07) THEN LET g_hrbj_1[l_i].hrbj08=g_hrag.hrag07 
            END IF
         END IF 
         
    #婚姻
         IF NOT cl_null(g_hrbj_1[l_i].hrbj09) THEN 
   	        CALL s_code('334',g_hrbj.hrbj09) RETURNING g_hrag.*
            IF NOT cl_null(g_hrag.hrag07) THEN LET g_hrbj_1[l_i].hrbj09=g_hrag.hrag07 
            END IF
         END IF 
         
    #学历
         IF NOT cl_null(g_hrbj_1[l_i].hrbj15) THEN 
   	        CALL s_code('317',g_hrbj.hrbj15) RETURNING g_hrag.*
            IF NOT cl_null(g_hrag.hrag07) THEN LET g_hrbj_1[l_i].hrbj15=g_hrag.hrag07 
            END IF
         END IF                   
         #离职信息
         SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbj_1[l_i].hrbj02
         SELECT hrbh02,hrbh05 INTO g_hrbj_1[l_i].hrbh02,l_bh05
          FROM (SELECT * FROM hrbh_file WHERE hrbh01=l_hratid ORDER BY hrbh03 desc ) 
           WHERE rownum = 1  #多笔离职资料取最新一笔
         SELECT hrag07 INTO g_hrbj_1[l_i].lzyy FROM hrag_file WHERE hrag01='310' AND hrag06=l_bh05
         #end

        LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
     CALL g_hrbj_1.deleteElement(l_i)
   # LET g_rec_b = l_i - 1
    DISPLAY ARRAY g_hrbj_1 TO s_hrbj.* #ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
          
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY   
    END DISPLAY
END FUNCTION
