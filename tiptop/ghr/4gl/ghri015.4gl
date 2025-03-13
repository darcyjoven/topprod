# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri015.4gl
# Descriptions...: 人员兼职维护作业
# Date & Author..: 13/04/16 By yangjian
# Modify ........: 13/05/16 By hourf   增加15个自订栏位
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義
 
DEFINE g_hraw                RECORD LIKE hraw_file.*
DEFINE g_hraw_t              RECORD LIKE hraw_file.*
DEFINE g_list                DYNAMIC ARRAY OF RECORD
            list_hraw01   LIKE hraw_file.hraw01,
            list_hrat01   LIKE hrat_file.hrat01,
            list_hrat02   LIKE type_file.chr100,
            list_hrat04   LIKE type_file.chr100,
            list_hrat05   LIKE type_file.chr100,
            list_hraw02   LIKE type_file.chr100,
            list_hraw02_name   LIKE type_file.chr100,
            list_hraw03   LIKE type_file.chr100,
            list_hraw03_name   LIKE type_file.chr100,
            list_hraw04   LIKE type_file.dat,
            list_hraw05   LIKE type_file.dat,
            list_hraw06   LIKE hraw_file.hraw06,
            list_hraw07   LIKE hraw_file.hraw07
              END  RECORD
DEFINE g_hrat01              LIKE hrat_file.hrat01
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE hraw_file.hrawacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE l_ac                  LIKE type_file.num5
DEFINE g_rec_b               LIKE type_file.num10
DEFINE g_bp_flag             LIKE type_file.chr10
 
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
   INITIALIZE g_hraw.* TO NULL
   INITIALIZE g_hrat01 TO NULL
 
   LET g_forupd_sql = "SELECT * FROM hraw_file WHERE hraw01 = ? ",
                      "   AND hraw02 = ? ",
                      "   AND hraw03 = ?  FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i015_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i015_w WITH FORM "ghr/42f/ghri015"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊
   CALL cl_set_label_justify("i015_w","right")
   CALL cl_set_comp_visible("hraw01",FALSE)
 
   LET g_action_choice = ""
   CALL i015_menu()                                         #進入選單 Menu
 
   CLOSE WINDOW i015_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 

FUNCTION i015_curs()

    CLEAR FORM
    INITIALIZE g_hraw.* TO NULL   
    INITIALIZE g_hrat01  TO NULL
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hraw01,g_hrat01,hraw02,hraw03,hraw07,hraw04,hraw05,hraw06,  
        hrawuser,hrawgrup,hrawmodu,hrawdate,hrawacti,hraworiu,hraworig,
        hrawud02,hrawud03,hrawud04,hrawud05,hrawud06,hrawud07,hrawud08,
        hrawud09,hrawud10,hrawud11,hrawud12,hrawud13,hrawud14,hrawud15,hrawud01

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
              WHEN INFIELD(hraw02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraw02
                 NEXT FIELD hraw02 
              WHEN INFIELD(hraw03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraw03
                 NEXT FIELD hraw03                  
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrawuser', 'hrawgrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位
    LET g_wc = cl_replace_str(g_wc,"g_hrat01","hrat01")

    LET g_sql = "SELECT hraw01,hraw02,hraw03 FROM hraw_file ",
                " LEFT OUTER JOIN hrat_file ON hraw01 = hratid ",
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY hraw01,hraw02,hraw03"
    PREPARE i015_prepare FROM g_sql
    DECLARE i015_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i015_prepare

    LET g_sql = "SELECT COUNT(*) FROM hraw_file ",
                "  LEFT OUTER JOIN hrat_file ON hraw01 = hratid ",
                " WHERE ",g_wc CLIPPED 
    PREPARE i015_precount FROM g_sql
    DECLARE i015_count CURSOR FOR i015_precount
END FUNCTION
 

FUNCTION i015_menu()
    DEFINE l_cmd    STRING 
    
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i015_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i015_q()
            END IF

        ON ACTION next
            CALL i015_fetch('N')

        ON ACTION previous
            CALL i015_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i015_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i015_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i015_r()
            END IF
 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i015_fetch('/')

        ON ACTION first
            CALL i015_fetch('F')

        ON ACTION last
            CALL i015_fetch('L')

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
 
        ON ACTION list
           LET g_action_choice="list"
           IF cl_chk_act_auth() THEN
           	  LET g_action_choice = ""    #MOD-A70076
           	  CALL i015_b_menu()
           	  LET g_action_choice = ""    #MOD-A70076
           END IF 

         &include "qry_string.4gl"
    END MENU
    CLOSE i015_cs
END FUNCTION
 
 
FUNCTION i015_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hraw.* LIKE hraw_file.*
    INITIALIZE g_hrat01 TO NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hraw.hrawuser = g_user
        LET g_hraw.hraworiu = g_user 
        LET g_hraw.hraworig = g_grup 
        LET g_hraw.hrawgrup = g_grup               #使用者所屬群
        LET g_hraw.hrawdate = g_today
        LET g_hraw.hrawacti = 'Y'
        LET g_hraw.hraw04 = g_today
        LET g_hraw.hraw07 = 'N'
        
        CALL i015_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hraw.* TO NULL
            INITIALIZE g_hrat01 TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hraw.hraw01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO hraw_file VALUES(g_hraw.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hraw_file",g_hraw.hraw01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660151
            CONTINUE WHILE
        ELSE
            SELECT hraw01 INTO g_hraw.hraw01 FROM hraw_file WHERE hraw01 = g_hraw.hraw01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i015_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
   DEFINE l_s           LIKE type_file.num5 
   DEFINE l_hrao02      LIKE hrao_file.hrao02
   DEFINE l_hrat01      LIKE hrat_file.hrat01
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hraw01      LIKE hraw_file.hraw01
   DEFINE l_sr          STRING
   
 
   DISPLAY BY NAME
      g_hrat01,
      g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03,g_hraw.hraw07,g_hraw.hraw04,g_hraw.hraw05,g_hraw.hraw06,
      g_hraw.hrawuser,g_hraw.hrawgrup,g_hraw.hrawmodu,g_hraw.hrawdate,g_hraw.hrawacti,
      g_hraw.hraworiu,g_hraw.hraworig,
      g_hraw.hrawud02,g_hraw.hrawud03,g_hraw.hrawud04,g_hraw.hrawud05,g_hraw.hrawud06,g_hraw.hrawud07,
      g_hraw.hrawud08,g_hraw.hrawud09,g_hraw.hrawud10,g_hraw.hrawud11,g_hraw.hrawud12,g_hraw.hrawud13,
      g_hraw.hrawud14,g_hraw.hrawud15,g_hraw.hrawud01                                                   #add by hourf  13/05/16
   INPUT BY NAME
      g_hrat01,g_hraw.hraw02,g_hraw.hraw03,g_hraw.hraw07,g_hraw.hraw04,g_hraw.hraw05,g_hraw.hraw06,
      g_hraw.hrawacti,
      g_hraw.hrawud02,g_hraw.hrawud03,g_hraw.hrawud04,g_hraw.hrawud05,g_hraw.hrawud06,g_hraw.hrawud07,
      g_hraw.hrawud08,g_hraw.hrawud09,g_hraw.hrawud10,g_hraw.hrawud11,g_hraw.hrawud12,g_hraw.hrawud13,   
      g_hraw.hrawud14,g_hraw.hrawud15,g_hraw.hrawud01                                                   #add by hourf  13/05/16
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i015_set_entry(p_cmd)
          CALL i015_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF p_cmd='a' THEN
            SELECT to_date('20991231','yyyymmdd') INTO g_hraw.hraw05 FROM dual
            DISPLAY BY NAME g_hraw.hraw05
         END IF 
 
      AFTER FIELD g_hrat01
         IF g_hrat01 IS NOT NULL AND p_cmd = 'a' THEN
            CALL i015_hrat01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('hraw01:',g_errno,1)
               LET g_hraw.hraw01 = NULL
               LET g_hrat01 = NULL
               DISPLAY BY NAME g_hraw.hraw01,g_hrat01
               NEXT FIELD g_hrat01
            END IF
            SELECT COUNT(*) INTO l_n FROM hraw_file  
             WHERE hraw01 = g_hraw.hraw01 
               AND hraw02 = g_hraw.hraw02
               AND hraw03 = g_hraw.hraw03
            IF l_n > 0 THEN 
               CALL cl_err('',-239,0)
               LET g_hraw.hraw01 = NULL  
               LET g_hrat01 = NULL
               DISPLAY BY NAME g_hraw.hraw01 ,g_hrat01
               NEXT FIELD g_hrat01
            END IF 
         END IF

      AFTER FIELD hraw02
         IF NOT cl_null(g_hraw.hraw02) THEN 
            CALL i015_hraw02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('hraw02:',g_errno,1)
               LET g_hraw.hraw02 = NULL
               DISPLAY BY NAME g_hraw.hraw02
               NEXT FIELD hraw02
            END IF
          #兼职部门，职位不可以是员工的主部门与职位
            SELECT COUNT(*) INTO l_n FROM hrat_file
             WHERE hrat01 = g_hrat01
               AND hrat04 = g_hraw.hraw02
               AND hrat05 = g_hraw.hraw03
            IF l_n > 0 THEN 
               CALL cl_err('','ghr-041',0)
               LET g_hraw.hraw03 = NULL
               DISPLAY BY NAME g_hraw.hraw03
               NEXT FIELD hraw03
            END IF 
          #更改时不可重复
            IF p_cmd = 'a' OR 
              (p_cmd = 'u' AND g_hraw.hraw02 != g_hraw_t.hraw02) THEN 
               SELECT COUNT(*) INTO l_n FROM hraw_file 
                WHERE hraw01 = g_hraw.hraw01
                  AND hraw02 = g_hraw.hraw02
                  AND hraw03 = g_hraw.hraw03
               IF l_n > 0 THEN 
                  CALL cl_err('',-239,0)
                  LET g_hraw.hraw02 = g_hraw_t.hraw02
                  DISPLAY BY NAME g_hraw.hraw02
                  NEXT FIELD hraw02
               END IF 
            END IF 
         END IF 

      AFTER FIELD hraw03
         IF NOT cl_null(g_hraw.hraw03) THEN
            CALL i015_hraw03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('hraw03:',g_errno,1)
               LET g_hraw.hraw03 = NULL
               DISPLAY BY NAME g_hraw.hraw03
               NEXT FIELD hraw03
            END IF
          #职位必须是部门职位配置作业里面维护的
            SELECT COUNT(*) INTO l_n FROM hrap_file
             WHERE hrap01 = g_hraw.hraw02
               AND hrap05 = g_hraw.hraw03
            IF l_n =0 THEN 
               CALL cl_err('','ghr-042',0)
               LET g_hraw.hraw03 = NULL
               DISPLAY BY NAME g_hraw.hraw03
               NEXT FIELD hraw03
            END IF 
          #兼职部门，职位不可以是员工的主部门与职位
            SELECT COUNT(*) INTO l_n FROM hrat_file
             WHERE hrat01 = g_hrat01
               AND hrat04 = g_hraw.hraw02
               AND hrat05 = g_hraw.hraw03
            IF l_n > 0 THEN 
               CALL cl_err('','ghr-041',0)
               LET g_hraw.hraw03 = NULL
               DISPLAY BY NAME g_hraw.hraw03
               NEXT FIELD hraw03
            END IF 
          #更改时不可重复
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_hraw.hraw03 != g_hraw_t.hraw03) THEN 
               SELECT COUNT(*) INTO l_n FROM hraw_file 
                WHERE hraw01 = g_hraw.hraw01
                  AND hraw02 = g_hraw.hraw02
                  AND hraw03 = g_hraw.hraw03
               IF l_n > 0 THEN 
                  CALL cl_err('',-239,0)
                  LET g_hraw.hraw03 = g_hraw_t.hraw03
                  DISPLAY BY NAME g_hraw.hraw03
                  NEXT FIELD hraw03
               END IF 
            END IF 
         END IF

      AFTER FIELD hraw04
         IF NOT cl_null(g_hraw.hraw04) AND NOT cl_null(g_hraw.hraw05) THEN 
            IF g_hraw.hraw04 > g_hraw.hraw05 THEN 
               CALL cl_err('','ghr-043',0)
               NEXT FIELD hraw04
            END IF  
         END IF 

      AFTER FIELD hraw05
         IF NOT cl_null(g_hraw.hraw04) AND NOT cl_null(g_hraw.hraw05) THEN 
            IF g_hraw.hraw04 > g_hraw.hraw05 THEN 
               CALL cl_err('','ghr-043',0)
               NEXT FIELD hraw05
            END IF  
         END IF 

 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET l_s='0'
            LET l_sr=' '
            IF g_hraw.hraw07='Y' THEN 
#add by yinbq 20141201 for 添加在职且过滤当前记录的控制
#            	 SELECT COUNT(*) INTO l_s FROM hraw_file WHERE hraw02=g_hraw.hraw02 AND hraw07='Y'
                 SELECT COUNT(*) INTO l_s FROM hraw_file
                  LEFT JOIN hrat_file ON hratid = hraw01
                  LEFT JOIN hrad_file ON hrad02=hrat19
                  LEFT JOIN hrao_file ON hrao01=hraw02
                 WHERE hraw_file.hrawacti = 'Y' AND hrad01<>'003' AND hraw01!=g_hraw.hraw01 AND hraw02=g_hraw.hraw02 AND hraw07='Y' AND hraw04<g_hraw.hraw05 AND hraw05>g_hraw.hraw04
            	 IF l_s >'0'THEN 
#            	 	SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = g_hraw.hraw02
#            	 	SELECT hraw01 INTO l_hraw01 FROM hraw_file WHERE hraw02= g_hraw.hraw02 AND hraw07='Y'
#            	 	SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid=l_hraw01
                 SELECT hrao02,hrat02,hrat01 INTO l_hrao02,l_hrat02,l_hrat01 FROM hraw_file
                  LEFT JOIN hrat_file ON hratid = hraw01
                  LEFT JOIN hrad_file ON hrad02=hrat19
                  LEFT JOIN hrao_file ON hrao01=hraw02
                 WHERE hraw_file.hrawacti = 'Y' AND hrad01<>'003' AND hraw01!=g_hraw.hraw01 AND hraw02=g_hraw.hraw02 AND hraw07='Y' AND hraw04<g_hraw.hraw05 AND hraw05>g_hraw.hraw04
            	 	LET l_sr=l_hrao02,"部门主管(兼任)已指定为",l_hrat01,l_hrat02
            	 END IF 
#add by yinbq 20141201 for 添加在职且过滤当前记录的控制
#            	 SELECT COUNT(*) INTO l_s FROM hrat_file WHERE hrat04=g_hraw.hraw02 AND hrat07='Y'
                  SELECT COUNT(*) INTO l_s FROM hrat_file
                  LEFT JOIN hrad_file ON hrad02=hrat19
                  WHERE hrad01<>'003' AND hrat04=g_hraw.hraw02 AND hrat07='Y'
#add by yinbq 20141201 for 添加在职且过滤当前记录的控制
            	 IF l_s >'0'THEN
#            	 	SELECT hrat01,hrat02,hrat04 INTO l_hrat01,l_hrat02,l_hrat04 FROM hrat_file WHERE hrat04=g_hraw.hraw02 AND hrat07='Y'
            	 	SELECT hrat01,hrat02,hrat04 INTO l_hrat01,l_hrat02,l_hrat04 FROM hrat_file
                  LEFT JOIN hrad_file ON hrad02=hrat19
                  WHERE hrad01<>'003' AND hrat04=g_hraw.hraw02 AND hrat07='Y'
            	 		LET l_sr=l_sr,l_hrat04,"部门主管已指定为",l_hrat01,l_hrat02
            	 END IF 
            	 IF NOT cl_null(l_sr) THEN 
            	 	CALL cl_err(l_sr,'!',0)
            	 	NEXT FIELD hraw07
            	 END IF 
            END IF 

     ON ACTION controlp
        CASE
           WHEN INFIELD(g_hrat01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.state = "i"
              CALL cl_create_qry() RETURNING g_hrat01
              DISPLAY g_hrat01 TO g_hrat01
              CALL i015_hrat01('d')
              NEXT FIELD g_hrat01
           WHEN INFIELD(hraw02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01_1"
              LET g_qryparam.state = "i"
              CALL cl_create_qry() RETURNING g_hraw.hraw02
              DISPLAY g_hraw.hraw02 TO hraw02
              CALL i015_hraw02('d')
              NEXT FIELD hraw02 
           WHEN INFIELD(hraw03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrap01"
              LET g_qryparam.state = "i"
              LET g_qryparam.default1 = g_hraw.hraw03
              LET g_qryparam.arg1 = g_hraw.hraw02
              CALL cl_create_qry() RETURNING g_hraw.hraw03
              DISPLAY g_hraw.hraw03 TO hraw03
              CALL i015_hraw03('d')
              NEXT FIELD hraw03  
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
 


FUNCTION i015_hrat01(p_cmd)

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrat02   LIKE hrat_file.hrat02
   DEFINE l_hrat04   LIKE hrat_file.hrat04
   DEFINE l_hrat05   LIKE hrat_file.hrat05
   DEFINE l_hrat06   LIKE hrat_file.hrat06
   DEFINE l_hrat17   LIKE hrat_file.hrat17
   DEFINE l_hrat22   LIKE hrat_file.hrat22
   DEFINE l_hrat42   LIKE hrat_file.hrat42
   DEFINE l_hrat04s  LIKE hrat_file.hrat04
   DEFINE l_hrat05s  LIKE hrat_file.hrat05
   DEFINE l_hrat06s  LIKE hrat_file.hrat06
   DEFINE l_hrat17s  RECORD LIKE hrag_file.*
   DEFINE l_hrat22s  RECORD LIKE hrag_file.*
   DEFINE l_hrat42s  LIKE hrat_file.hrat42
   DEFINE l_hrat25   LIKE hrat_file.hrat25
   DEFINE l_hratacti LIKE hrat_file.hratacti
   DEFINE l_hratid   LIKE hrat_file.hratid
 
   LET g_errno=''
   SELECT hrat02,hrat17,hrat04,hrat05,hrat22,hrat42,hrat06,hrat25,hratacti,
          hratid
     INTO l_hrat02,l_hrat17,l_hrat04,l_hrat05,l_hrat22,l_hrat42,l_hrat06,l_hrat25,l_hratacti,
          g_hraw.hraw01
     FROM hrat_file
    WHERE hrat01 = g_hrat01
      AND hratconf = 'Y'
      AND ROWNUM = 1
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-031'
                                LET l_hrat02=NULL  LET l_hrat17=NULL  LET l_hrat04=NULL  LET l_hrat05=NULL
                                LET l_hrat22=NULL  LET l_hrat42=NULL  LET l_hrat06=NULL  LET l_hrat25=NULL
       WHEN l_hratacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      CALL i015_hrat04(l_hrat04) RETURNING l_hrat04s
      CALL i015_hrat05(l_hrat04,l_hrat05) RETURNING l_hrat05s
      CALL i015_hrat06(l_hrat06) RETURNING l_hrat06s
      CALL i015_hrat42(l_hrat42) RETURNING l_hrat42s
      CALL s_code('333',l_hrat17) RETURNING l_hrat17s.*
      CALL s_code('317',l_hrat22) RETURNING l_hrat22s.*
      DISPLAY g_hraw.hraw01 TO hraw01
      DISPLAY l_hrat02 TO FORMONLY.hrat02
      DISPLAY l_hrat04s TO FORMONLY.hrat04
      DISPLAY l_hrat05s TO FORMONLY.hrat05
      DISPLAY l_hrat06s TO FORMONLY.hrat06
      DISPLAY l_hrat42s TO FORMONLY.hrat42
      DISPLAY l_hrat17s.hrag07 TO FORMONLY.hrat17
      DISPLAY l_hrat22s.hrag07 TO FORMONLY.hrat22
      DISPLAY l_hrat25 TO FORMONLY.hrat25
   END IF
END FUNCTION
 
FUNCTION i015_hraw02(p_cmd)

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrao00   LIKE hrao_file.hrao00
   DEFINE l_hrao02   LIKE hrao_file.hrao02
   DEFINE l_hraa12   LIKE hraa_file.hraa12
   DEFINE l_hraoacti LIKE hrao_file.hraoacti
 
   LET g_errno=''
   SELECT hrao00,hrao02,hraoacti
     INTO l_hrao00,l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01 = g_hraw.hraw02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-009'
                                LET l_hrao02=NULL  LET l_hrao00=NULL  
       WHEN l_hraoacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      SELECT hraa12 INTO l_hraa12 FROM hraa_file 
       WHERE hraa01 = l_hrao00
      DISPLAY l_hrao02 TO FORMONLY.hrao02
      DISPLAY l_hraa12 TO FORMONLY.hraa12
      DISPLAY l_hrao00 TO FORMONLY.hrao00
   END IF
END FUNCTION

FUNCTION i015_hraw03(p_cmd)

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hras04   LIKE hras_file.hras04
   DEFINE l_hrasacti LIKE hras_file.hrasacti
 
   LET g_errno=''
   SELECT hras04,hrasacti
     INTO l_hras04,l_hrasacti
     FROM hras_file
    WHERE hras01 = g_hraw.hraw03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-010'
                                LET l_hras04=NULL
       WHEN l_hrasacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_hras04 TO FORMONLY.hras04
   END IF
END FUNCTION


FUNCTION i015_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hraw.* TO NULL    
    INITIALIZE g_hrat01 TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i015_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i015_count
    FETCH i015_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i015_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hraw.hraw01,SQLCA.sqlcode,0)
        INITIALIZE g_hraw.* TO NULL
        INITIALIZE g_hrat01 TO NULL
    ELSE
        CALL i015_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i015_fetch(p_flhraw)
    DEFINE p_flhraw         LIKE type_file.chr1
 
    CASE p_flhraw
        WHEN 'N' FETCH NEXT     i015_cs INTO g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
        WHEN 'P' FETCH PREVIOUS i015_cs INTO g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
        WHEN 'F' FETCH FIRST    i015_cs INTO g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
        WHEN 'L' FETCH LAST     i015_cs INTO g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
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
            FETCH ABSOLUTE g_jump i015_cs INTO g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hraw.hraw01,SQLCA.sqlcode,0)
        INITIALIZE g_hraw.* TO NULL  
        INITIALIZE g_hrat01 TO NULL
        LET g_hraw.hraw01 = NULL   LET g_hrat01 = NULL      
        LET g_hraw.hraw02 = NULL   LET g_hraw.hraw03 = NULL
        RETURN
    ELSE
      CASE p_flhraw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_hraw.* FROM hraw_file    # 重讀DB,因TEMP有不被更新特性
     WHERE hraw01 = g_hraw.hraw01
       AND hraw02 = g_hraw.hraw02
       AND hraw03 = g_hraw.hraw03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hraw_file",g_hraw.hraw01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_hraw.hrawuser           #FUN-4C0044權限控管
        LET g_data_group=g_hraw.hrawgrup
        CALL i015_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i015_show()

    LET g_hraw_t.* = g_hraw.*
    SELECT hrat01 INTO g_hrat01 FROM hrat_file WHERE hratid = g_hraw.hraw01
    DISPLAY BY NAME g_hrat01,
                    g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03,g_hraw.hraw07,g_hraw.hraw04,g_hraw.hraw05,g_hraw.hraw06,
                    g_hraw.hrawuser,g_hraw.hrawgrup,g_hraw.hrawmodu,
                    g_hraw.hrawdate,g_hraw.hrawacti,g_hraw.hraworig,g_hraw.hraworiu,
                    g_hraw.hrawud02,g_hraw.hrawud03,g_hraw.hrawud04,g_hraw.hrawud05,g_hraw.hrawud06,g_hraw.hrawud07,
                    g_hraw.hrawud08,g_hraw.hrawud09,g_hraw.hrawud10,g_hraw.hrawud11,g_hraw.hrawud12,g_hraw.hrawud13, 
                    g_hraw.hrawud14,g_hraw.hrawud15,g_hraw.hrawud01                                         #add by hourf  13/05/16
    CALL i015_hrat01('d')
    CALL i015_hraw02('d')
    CALL i015_hraw03('d')
    CALL i015_list_fill()
    
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i015_u()
    IF g_hraw.hraw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hraw.* FROM hraw_file WHERE hraw01=g_hraw.hraw01
       AND hraw02 = g_hraw.hraw02
       AND hraw03 = g_hraw.hraw03
       
    IF g_hraw.hrawacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
   
    BEGIN WORK
 
    OPEN i015_cl USING g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
    IF STATUS THEN
       CALL cl_err("OPEN i015_cl:", STATUS, 1)
       CLOSE i015_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i015_cl INTO g_hraw.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hraw.hraw01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hraw.hrawmodu=g_user                  #修改者
    LET g_hraw.hrawdate = g_today               #修改日期
    CALL i015_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i015_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET g_hraw_t.* = g_hraw.*
            LET INT_FLAG = 0
            CALL i015_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hraw_file SET hraw_file.* = g_hraw.*    # 更新DB
            WHERE hraw01 = g_hraw_t.hraw01     
              AND hraw02 = g_hraw_t.hraw02
              AND hraw03 = g_hraw_t.hraw03
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hraw_file",g_hraw.hraw01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660151
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i015_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i015_x()
    IF g_hraw.hraw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i015_cl USING g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
    IF STATUS THEN
       CALL cl_err("OPEN i015_cl:", STATUS, 1)
       CLOSE i015_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i015_cl INTO g_hraw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hraw.hraw01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i015_show()
    IF cl_exp(0,0,g_hraw.hrawacti) THEN
        LET g_chr = g_hraw.hrawacti
        IF g_hraw.hrawacti='Y' THEN
            LET g_hraw.hrawacti='N'
        ELSE
            LET g_hraw.hrawacti='Y'
        END IF
        UPDATE hraw_file
            SET hrawacti=g_hraw.hrawacti
            WHERE hraw01=g_hraw.hraw01 
              AND hraw02=g_hraw.hraw02
              AND hraw03=g_hraw.hraw03
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hraw.hraw01,SQLCA.sqlcode,0)
            LET g_hraw.hrawacti = g_chr
        END IF
        DISPLAY BY NAME g_hraw.hrawacti
    END IF
    CLOSE i015_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i015_r()
    IF g_hraw.hraw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i015_cl USING g_hraw.hraw01,g_hraw.hraw02,g_hraw.hraw03
    IF STATUS THEN
       CALL cl_err("OPEN i015_cl:", STATUS, 0)
       CLOSE i015_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i015_cl INTO g_hraw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hraw.hraw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i015_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hraw01"   
       LET g_doc.value1 = g_hraw.hraw01 

       CALL cl_del_doc()
       DELETE FROM hraw_file WHERE hraw01 = g_hraw.hraw01
          AND hraw02 = g_hraw.hraw02
          AND hraw03 = g_hraw.hraw03

       CLEAR FORM
       OPEN i015_count
       IF STATUS THEN
          CLOSE i015_cl
          CLOSE i015_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i015_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i015_cl
          CLOSE i015_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i015_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i015_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i015_fetch('/')
       END IF
    END IF
    CLOSE i015_cl
    COMMIT WORK
END FUNCTION

 
FUNCTION i015_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
     #CALL cl_set_comp_entry("hraw01,hraw02,hraw03,g_hrat01",TRUE)
      CALL cl_set_comp_entry("hraw01,g_hrat01",TRUE)
   END IF
END FUNCTION

 
FUNCTION i015_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
     #CALL cl_set_comp_entry("hraw01,hraw02,hraw03,g_hrat01",FALSE)
      CALL cl_set_comp_entry("hraw01,g_hrat01",FALSE)
   END IF
END FUNCTION


FUNCTION i015_hrat04(p_hrat04)
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


FUNCTION i015_hrat05(p_hrat04,p_hrat05)
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


FUNCTION i015_hrat42(p_hrat42)
   DEFINE p_hrat42    LIKE hrat_file.hrat42
   DEFINE l_azp02    LIKE azp_file.azp02

   LET g_errno=''
   SELECT azp02 INTO l_azp02 FROM azp_file
    WHERE azp01=p_hrat42
  #CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='ghr-006'
  #                             LET l_azp02=NULL
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  #END CASE
   RETURN l_azp02
END FUNCTION


FUNCTION i015_hrat06(p_hrat06)
   DEFINE p_hrat06    LIKE hrat_file.hrat06
   DEFINE l_hrat02    LIKE hrat_file.hrat02
   DEFINE l_hratacti  LIKE hrat_file.hratacti

   LET g_errno=''
   SELECT hrat02,hratacti INTO l_hrat02,l_hratacti FROM hrat_file
    WHERE hrat01=p_hrat06 AND hrat07 = 'Y'
  #CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='ghr-031'
  #                             LET l_hrat02=NULL

  #    WHEN l_hratacti='N'       LET g_errno='9028'
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  #END CASE
   RETURN l_hrat02
END FUNCTION

FUNCTION i015_list_fill()

   CALL g_list.clear()
   
   LET g_cnt = 1 
   LET g_sql = "SELECT hraw01,hrat01,hrat02,hrat04,hrat05, ",
               "       hraw02,hrao02,hraw03,hrap06,hraw04,hraw05,hraw06,hraw07 ",
               "  FROM hraw_file,hrat_file,hrao_file,hrap_file ",
               " WHERE hraw01 = hratid ",
               "   AND hraw02 = hrao01(+) ",
               "   AND hraw02 = hrap01(+) ",
               "   AND hraw03 = hrap05(+) ",
               " ORDER BY hraw01,hraw02,hraw03 "
   PREPARE i015_list_prep FROM g_sql
   DECLARE i015_list_cs CURSOR FOR i015_list_prep
   FOREACH i015_list_cs INTO g_list[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
   END FOREACH 
   CALL g_list.deleteElement(g_cnt)
   
   DISPLAY ARRAY g_list TO s_list.* 
       BEFORE DISPLAY 
          EXIT DISPLAY 
          
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
    END DISPLAY 
             
END FUNCTION 

FUNCTION i015_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000

   WHILE TRUE

      CALL i015_bp("G")  

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hraw_file.* 
           INTO g_hraw.* 
           FROM hraw_file 
          WHERE hraw01=g_list[l_ac].list_hraw01
            AND hraw02=g_list[l_ac].list_hraw02
            AND hraw03=g_list[l_ac].list_hraw03
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'pg'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i015_fetch('/')
         END IF
      END IF

      CASE g_action_choice
           WHEN "insert"
               IF cl_chk_act_auth() THEN   
                  CALL i015_a()
               END IF
               EXIT WHILE

           WHEN "query"
               IF cl_chk_act_auth() THEN  
                    CALL i015_q()
               END IF
               EXIT WHILE
           
           WHEN "modify"
               IF cl_chk_act_auth() THEN   
                  LET g_curs_index = ARR_CURR()
                  CALL i015_u()
               END IF
               EXIT WHILE
           
          #No.FUN-9C0089 add begin------------------
           WHEN "exporttoexcel"
              IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_list),'','')
              END IF
          #No.FUN-9C0089 add -end-------------------
           
           WHEN "invalid"
               IF cl_chk_act_auth() THEN    
                  CALL i015_x()
               END IF
           
           WHEN "delete"
               IF cl_chk_act_auth() THEN   
                  CALL i015_r()
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

FUNCTION i015_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_list TO s_list.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION pg
         LET g_bp_flag = 'pg'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i015_fetch('/')
         END IF
         CALL ui.interface.refresh()
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i015_fetch('/')
         CALL cl_set_comp_visible("Page2,Page3,Page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2,Page3,Page4", TRUE)
         EXIT DISPLAY
 
      ON ACTION next
         CALL i015_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION previous
         CALL i015_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION jump
         CALL i015_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION first
         CALL i015_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION last
         CALL i015_fetch('L')
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

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
END FUNCTION

