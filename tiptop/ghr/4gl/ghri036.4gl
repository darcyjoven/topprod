# Prog. Version..: '5.25.13-13.04.12(00000)'     #
#
# Pattern name...: ghri036.4gl
# Descriptions...: 维护考勤机信息资料
# Date & Author..: 13/05/02 By lifang
# Modify.........: 92/05/05 By David
# Modify.........: No.MOD-470400 04/07/22 By Nicola 進入程式,右邊有一個放棄的butoom
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4C0044 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510027 05/01/13 By pengu 報表轉XML
# Modify.........: No.MOD-530117 05/03/16 By pengu CALL cl_prt()時參數傳錯造成無法執行列印
# Modify.........: No.FUN-4A0089 05/04/22 By saki 試做筆數顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-640199 06/04/19 By saki 新訊息顯示範例
# Modify.........: No.TQC-640187 06/04/26 By Claire Display 修改
# Modify.........: No.FUN-650190 06/06/07 By Pengu RING MENU處有一個退出的BUTTON,與PACKAGE的STYLE不符,建議去掉
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0066 06/10/20 By atsea 將g_no_ask修改為g_no_ask
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/06/28 By mike 報表格式修改為p_query
# Modify.........: No.TQC-780042 07/08/15 By jamie 修改時出現-201的錯誤，將FOR UPDATE ->FOR UPDATE
# Modify.........: No.MOD-820166 08/02/27 By Smapmin 重新過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60372 11/06/30 By yinhy 去除rowid寫法
# Modify.........: No.MOD-BB0113 11/11/10 By Vampire 在_u()時update的條件是WHERE hrbv01 = g_hrbv.hrbv01，是不是應該改成_t，因為KEY有機會被改
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義
 
DEFINE g_hrbv                 RECORD LIKE hrbv_file.*
DEFINE g_hrbv_t               RECORD LIKE hrbv_file.*      #備份舊值
DEFINE g_hrbv01_t             LIKE hrbv_file.hrbv01         #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE hrbv_file.hrbvacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 

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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_hrbv.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM hrbv_file WHERE hrbv01 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i036_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i036_w WITH FORM "ghr/42f/ghri036"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊


   LET g_action_choice = ""
   CALL i036_menu()                                         #進入選單 Menu

   CLOSE WINDOW i036_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i036_curs()

    CLEAR FORM
    INITIALIZE g_hrbv.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hrbv01,hrbv02,hrbv03,hrbv04,hrbv05,
        hrbv06,hrbv07,hrbv08,hrbv09.hrbv10,
        hrbv11,hrbvuser,hrbvgrup,hrbvmodu,
        hrbvdate,hrbvacti

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbv01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbv01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbv.hrbv01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbv01
                 NEXT FIELD hrbv01
              WHEN INFIELD(hrbv05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbv05"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbv.hrbv05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbv05
                 NEXT FIELD hrbv05
              WHEN INFIELD(hrbv11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbv11"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbv.hrbv11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbv11
                 NEXT FIELD hrbv11
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbvuser', 'hrbvgrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位

    LET g_sql = "SELECT hrbv01 FROM hrbv_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY hrbv01"
    PREPARE i036_prepare FROM g_sql
    DECLARE i036_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i036_prepare

    LET g_sql = "SELECT COUNT(*) FROM hrbv_file WHERE ",g_wc CLIPPED
    PREPARE i036_precount FROM g_sql
    DECLARE i036_count CURSOR FOR i036_precount
END FUNCTION
 

FUNCTION i036_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i036_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i036_q()
            END IF

        ON ACTION next
            CALL i036_fetch('N')

        ON ACTION previous
            CALL i036_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i036_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i036_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i036_r()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i036_copy()
            END IF

      # ON ACTION output
      #      LET g_action_choice="output"
      #      IF cl_chk_act_auth() THEN 
      #         IF cl_null(g_wc) THEN LET g_wc='1=1' END IF
      #         LET l_cmd = 'p_query "ghri036" "',g_wc CLIPPED,'"'
      #         CALL cl_cmdrun(l_cmd)                             
      #      END IF
 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i036_fetch('/')

        ON ACTION first
            CALL i036_fetch('F')

        ON ACTION last
            CALL i036_fetch('L')

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
              IF g_hrbv.hrbv01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrbv01"
                 LET g_doc.value1 = g_hrbv.hrbv01
                 CALL cl_doc()
              END IF
           END IF
    
	ON ACTION ghri036_a
		CALL i036_syn()

	ON ACTION ghri036_b
		CALL i036_down()

        ON ACTION ghri036_c
                CALL i036_init()
	
	END MENU
    CLOSE i036_cs
END FUNCTION
 
 
FUNCTION i036_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hrbv.* LIKE hrbv_file.*
    LET g_hrbv01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbv.hrbvuser = g_user
        LET g_hrbv.hrbvoriu = g_user 
        LET g_hrbv.hrbvorig = g_grup 
        LET g_hrbv.hrbvgrup = g_grup               #使用者所屬群
        LET g_hrbv.hrbvdate = g_today
        LET g_hrbv.hrbvacti = 'Y'
        LET g_hrbv.hrbv04=1
        DISPLAY BY NAME g_hrbv.hrbvacti
        CALL i036_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hrbv.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrbv.hrbv01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO hrbv_file VALUES(g_hrbv.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbv_file",g_hrbv.hrbv01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrbv01 INTO g_hrbv.hrbv01 FROM hrbv_file WHERE hrbv01 = g_hrbv.hrbv01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i036_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
 #  DEFINE l_gen02       LIKE gen_file.gen02
 #  DEFINE l_gen03       LIKE gen_file.gen03
 #  DEFINE l_gen04       LIKE gen_file.gen04
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_hrbv.hrbv01,g_hrbv.hrbv02,g_hrbv.hrbv03,g_hrbv.hrbv04,g_hrbv.hrbv05,
      g_hrbv.hrbv06,g_hrbv.hrbv07,g_hrbv.hrbv08,g_hrbv.hrbv09,g_hrbv.hrbv10,
      g_hrbv.hrbv11,g_hrbv.hrbv12,g_hrbv.hrbvacti
      ,g_hrbv.hrbvuser,g_hrbv.hrbvgrup,g_hrbv.hrbvmodu,g_hrbv.hrbvdate,g_hrbv.hrbvorig,g_hrbv.hrbvoriu
 
   INPUT BY NAME
      g_hrbv.hrbv01,g_hrbv.hrbv02,g_hrbv.hrbv03,g_hrbv.hrbv04,g_hrbv.hrbv05,
      g_hrbv.hrbv06,g_hrbv.hrbv07,g_hrbv.hrbv08,g_hrbv.hrbv09,g_hrbv.hrbv10,
      g_hrbv.hrbv11,g_hrbv.hrbv12
      #,g_hrbv.hrbvacti,g_hrbv.hrbvuser,g_hrbv.hrbvgrup,g_hrbv.hrbvmodu,g_hrbv.hrbvdate,g_hrbv.hrbvorig,g_hrbv.hrbvoriu
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i036_set_entry(p_cmd)
          CALL i036_set_no_entry(p_cmd)
          CALL i036_set_required()
          LET g_before_input_done = TRUE          
 
       AFTER FIELD hrbv01
         IF g_hrbv.hrbv01 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hrbv.hrbv01 != g_hrbv01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hrbv_file WHERE hrbv01 = g_hrbv.hrbv01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hrbv.hrbv01,-239,1)
                  LET g_hrbv.hrbv01 = g_hrbv01_t
                  DISPLAY BY NAME g_hrbv.hrbv01
                  NEXT FIELD hrbv01
               END IF
            #   CALL i036_hrbv01('a')
            #   IF NOT cl_null(g_errno) THEN
            #      CALL cl_err('hrbv01:',g_errno,1)
            #      LET g_hrbv.hrbv01 = g_hrbv01_t
            #      DISPLAY BY NAME g_hrbv.hrbv01
            #      NEXT FIELD hrbv01
            #   END IF
            END IF
            DISPLAY BY NAME g_hrbv.hrbv01
         END IF
     
       AFTER FIELD hrbv02
         IF g_hrbv.hrbv02 IS NOT NULL THEN
            DISPLAY BY NAME g_hrbv.hrbv02	
         END IF
     
       AFTER FIELD hrbv04
         IF g_hrbv.hrbv04 IS NOT NULL THEN
            DISPLAY BY NAME g_hrbv.hrbv04
         END IF    	
     
       AFTER FIELD hrbv05
         IF g_hrbv.hrbv05 IS NOT NULL THEN
             CALL i036_display()
             DISPLAY BY NAME g_hrbv.hrbv05
         END IF    	
     
       AFTER FIELD hrbv11
         IF g_hrbv.hrbv11 IS NOT NULL THEN 
         	   CALL i036_display()   
             DISPLAY BY NAME g_hrbv.hrbv11
         END IF
       
                                 	 
       AFTER INPUT
         LET g_hrbv.hrbvuser = s_get_data_owner("hrbv_file") #FUN-C10039
         LET g_hrbv.hrbvgrup = s_get_data_group("hrbv_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_hrbv.hrbv01 IS NULL THEN
               DISPLAY BY NAME g_hrbv.hrbv01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrbv01
            END IF
            
            IF g_hrbv.hrbv02 IS NULL THEN
               DISPLAY BY NAME g_hrbv.hrbv02
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrbv02
            END IF
            
            IF g_hrbv.hrbv04 IS NULL THEN
               DISPLAY BY NAME g_hrbv.hrbv04
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrbv04
            END IF
            
            IF g_hrbv.hrbv05 IS NULL THEN
               DISPLAY BY NAME g_hrbv.hrbv05
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrbv05
            END IF
            
            IF g_hrbv.hrbv11 IS NULL THEN
               DISPLAY BY NAME g_hrbv.hrbv11
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrbv11
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(hrbv01) THEN
            LET g_hrbv.* = g_hrbv_t.*
            CALL i036_show()
            NEXT FIELD hrbv01
         END IF
 
     ON ACTION controlp
        CASE        
           WHEN INFIELD(hrbv05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbv05"
              LET g_qryparam.default1 = g_hrbv.hrbv05
              CALL cl_create_qry() RETURNING g_hrbv.hrbv05
              DISPLAY BY NAME g_hrbv.hrbv05
              NEXT FIELD hrbv05
          WHEN INFIELD(hrbv11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbv11"
              LET g_qryparam.default1 = g_hrbv.hrbv11
              CALL cl_create_qry() RETURNING g_hrbv.hrbv11
              DISPLAY BY NAME g_hrbv.hrbv11
              NEXT FIELD hrbv11
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLZ
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
 


FUNCTION i036_display()

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrbu02      LIKE hrbu_file.hrbu02
   DEFINE l_hraa02      LIKE hraa_file.hraa02

   SELECT hraa02 INTO l_hraa02 FROM hraa_file WHERE hraa01= g_hrbv.hrbv11
   DISPLAY l_hraa02 TO FORMONLY.hraa02
   
   SELECT hrbu02 INTO l_hrbu02 FROM hrbu_file WHERE hrbu01=g_hrbv.hrbv05
   DISPLAY l_hrbu02 TO FORMONLY.hrbu02
   
END FUNCTION

 


FUNCTION i036_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrbv.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i036_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i036_count
    FETCH i036_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i036_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbv.hrbv01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbv.* TO NULL
    ELSE
        CALL i036_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i036_fetch(p_flhrbv)
    DEFINE p_flhrbv         LIKE type_file.chr1
 
    CASE p_flhrbv
        WHEN 'N' FETCH NEXT     i036_cs INTO g_hrbv.hrbv01
        WHEN 'P' FETCH PREVIOUS i036_cs INTO g_hrbv.hrbv01
        WHEN 'F' FETCH FIRST    i036_cs INTO g_hrbv.hrbv01
        WHEN 'L' FETCH LAST     i036_cs INTO g_hrbv.hrbv01
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
            FETCH ABSOLUTE g_jump i036_cs INTO g_hrbv.hrbv01
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbv.hrbv01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbv.* TO NULL  
        LET g_hrbv.hrbv01 = NULL      
        RETURN
    ELSE
      CASE p_flhrbv
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_hrbv.* FROM hrbv_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hrbv01 = g_hrbv.hrbv01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbv_file",g_hrbv.hrbv01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_hrbv.hrbvuser           #FUN-4C0044權限控管
        LET g_data_group=g_hrbv.hrbvgrup
        CALL i036_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i036_show()
    LET g_hrbv_t.* = g_hrbv.*
    DISPLAY BY NAME 
      g_hrbv.hrbv01,g_hrbv.hrbv02,g_hrbv.hrbv03,g_hrbv.hrbv04,g_hrbv.hrbv05,
      g_hrbv.hrbv06,g_hrbv.hrbv07,g_hrbv.hrbv08,g_hrbv.hrbv09,g_hrbv.hrbv10,
      g_hrbv.hrbv11,g_hrbv.hrbv12,g_hrbv.hrbvacti,
      g_hrbv.hrbvuser,g_hrbv.hrbvgrup,g_hrbv.hrbvmodu,g_hrbv.hrbvdate,g_hrbv.hrbvorig,g_hrbv.hrbvoriu
      CALL i036_display()
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i036_u()
    IF g_hrbv.hrbv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrbv.* FROM hrbv_file WHERE hrbv01=g_hrbv.hrbv01
    IF g_hrbv.hrbvacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_hrbv01_t = g_hrbv.hrbv01
    BEGIN WORK
 
    OPEN i036_cl USING g_hrbv.hrbv01
    IF STATUS THEN
       CALL cl_err("OPEN i036_cl:", STATUS, 1)
       CLOSE i036_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i036_cl INTO g_hrbv.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbv.hrbv01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrbv.hrbvmodu=g_user                  #修改者
    LET g_hrbv.hrbvdate = g_today               #修改日期
    CALL i036_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i036_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrbv.*=g_hrbv_t.*
            CALL i036_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrbv_file SET hrbv_file.* = g_hrbv.*    # 更新DB
            #WHERE hrbv01 = g_hrbv.hrbv01     #MOD-BB0113 mark
            WHERE hrbv01 = g_hrbv_t.hrbv01    #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrbv_file",g_hrbv.hrbv01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i036_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i036_x()
    IF g_hrbv.hrbv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i036_cl USING g_hrbv.hrbv01
    IF STATUS THEN
       CALL cl_err("OPEN i036_cl:", STATUS, 1)
       CLOSE i036_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i036_cl INTO g_hrbv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbv.hrbv01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i036_show()
    IF cl_exp(0,0,g_hrbv.hrbvacti) THEN
        LET g_chr = g_hrbv.hrbvacti
        IF g_hrbv.hrbvacti='Y' THEN
            LET g_hrbv.hrbvacti='N'
        ELSE
            LET g_hrbv.hrbvacti='Y'
        END IF
        UPDATE hrbv_file
            SET hrbvacti=g_hrbv.hrbvacti
            WHERE hrbv01=g_hrbv.hrbv01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrbv.hrbv01,SQLCA.sqlcode,0)
            LET g_hrbv.hrbvacti = g_chr
        END IF
        DISPLAY BY NAME g_hrbv.hrbvacti
    END IF
    CLOSE i036_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i036_r()
    IF g_hrbv.hrbv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i036_cl USING g_hrbv.hrbv01
    IF STATUS THEN
       CALL cl_err("OPEN i036_cl:", STATUS, 0)
       CLOSE i036_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i036_cl INTO g_hrbv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbv.hrbv01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i036_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrbv01"   
       LET g_doc.value1 = g_hrbv.hrbv01 

       CALL cl_del_doc()
       DELETE FROM hrbv_file WHERE hrbv01 = g_hrbv.hrbv01

       CLEAR FORM
       OPEN i036_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i036_cl
          CLOSE i036_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH i036_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i036_cl
          CLOSE i036_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i036_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i036_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i036_fetch('/')
       END IF
    END IF
    CLOSE i036_cl
    COMMIT WORK
END FUNCTION
 


FUNCTION i036_copy()

    DEFINE l_newno         LIKE hrbv_file.hrbv01
    DEFINE l_oldno         LIKE hrbv_file.hrbv01
    DEFINE p_cmd           LIKE type_file.chr1
    DEFINE l_input         LIKE type_file.chr1 
 
    IF g_hrbv.hrbv01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i036_set_entry('a')
    LET g_before_input_done = TRUE

    INPUT l_newno FROM hrbv01
 
        AFTER FIELD hrbv01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM hrbv_file WHERE hrbv01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD hrbv01
              END IF

             # SELECT gen01 FROM gen_file WHERE gen01= l_newno
             # IF SQLCA.sqlcode THEN
             #     DISPLAY BY NAME g_hrbv.hrbv01
             #     LET l_newno = NULL
             #     NEXT FIELD hrbv01
             # END IF
           END IF
 
        ON ACTION controlp                        # 沿用所有欄位
           IF INFIELD(hrbv01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbv01"
              LET g_qryparam.default1 = g_hrbv.hrbv01
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO hrbv01

          #    SELECT gen01 FROM gen_file WHERE gen01= l_newno
          #    IF SQLCA.sqlcode THEN
          #       DISPLAY BY NAME g_hrbv.hrbv01
          #       LET l_newno = NULL
          #       NEXT FIELD hrbv01
          #    END IF
          #    NEXT FIELD hrbv01
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
        DISPLAY BY NAME g_hrbv.hrbv01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hrbv_file
        WHERE hrbv01=g_hrbv.hrbv01
        INTO TEMP x
    UPDATE x
        SET hrbv01=l_newno,    #資料鍵值
            hrbvacti='Y',      #資料有效碼
            hrbvuser=g_user,   #資料所有者
            hrbvgrup=g_grup,   #資料所有者所屬群
            hrbvmodu=NULL,     #資料修改日期
            hrbvdate=g_today   #資料建立日期

    INSERT INTO hrbv_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hrbv_file",g_hrbv.hrbv01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_hrbv.hrbv01
        LET g_hrbv.hrbv01 = l_newno
        SELECT hrbv_file.* INTO g_hrbv.* FROM hrbv_file
               WHERE hrbv01 = l_newno
        CALL i036_u()
        SELECT hrbv_file.* INTO g_hrbv.* FROM hrbv_file
               WHERE hrbv01 = l_oldno
    END IF
    LET g_hrbv.hrbv01 = l_oldno
    CALL i036_show()
END FUNCTION

 
PRIVATE FUNCTION i036_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrbv01",TRUE)
   END IF
END FUNCTION

 
PRIVATE FUNCTION i036_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("hrbv01",FALSE)
   END IF
#SELECT rowid FROM zz_file WhERE zz01=g_zz01        #No.TQC-B60372
END FUNCTION

FUNCTION i036_set_required()

    CALL cl_set_comp_required("hrbv01,hrbv02,hrbv04,hrbv05,hrbv11",TRUE)
END FUNCTION

FUNCTION i036_syn()
	#DEFINE ls_str STRING
	DEFINE li_status    SMALLINT
	DEFINE ls_cmd       STRING
	CALL ui.interface.frontCall('standard','cbset',[g_hrbv.hrbv01],[li_status])
	LET ls_cmd="\"D:\\Integration\\SynUser\\RegisterUser.exe\""
	#CALL cl_err(ls_cmd,'9001',1)
	CALL ui.Interface.frontCall( "standard", "shellexec", [ls_cmd], [li_status])
	#CALL cl_err(li_status,'9001',1)
	#CALL ui.interface.frontCall('standard','cbget',[],[ls_str])
	#CALL cl_err('ls_str','!',1)
END FUNCTION

FUNCTION i036_down()
        #DEFINE ls_str STRING
        DEFINE li_status    SMALLINT
        DEFINE ls_cmd       STRING
        CALL ui.interface.frontCall('standard','cbset',[g_hrbv.hrbv01],[li_status])
        LET ls_cmd="\"D:\\Integration\\DownAt\\ATTData.exe\""
        CALL ui.Interface.frontCall( "standard", "shellexec", [ls_cmd], [li_status])
        #CALL ui.interface.frontCall('standard','cbget',[],[ls_str])
END FUNCTION


FUNCTION i036_init()
        #DEFINE ls_str STRING
        DEFINE li_status    SMALLINT
        DEFINE ls_cmd       STRING
        CALL ui.interface.frontCall('standard','cbset',[g_hrbv.hrbv01],[li_status])
        LET ls_cmd="\"D:\\Integration\\DownLoadUser\\DownLoadUser.exe\""
        CALL ui.Interface.frontCall( "standard", "shellexec", [ls_cmd], [li_status])
        #CALL ui.interface.frontCall('standard','cbget',[],[ls_str])
END FUNCTION
