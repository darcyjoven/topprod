# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aooi010.4gl
# Descriptions...: 簽核人員
# Date & Author..: 91/04/11 By Lee
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
# Modify.........: No.MOD-BB0113 11/11/21 By Vampire 在_u()時update的條件是WHERE azb01 = g_azb.azb01，是不是應該改成_t，因為KEY有機會被改
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義
#GLOBALS "../4gl/aooi010.global"                         #若global變數很多可以獨立拉出  此處不適用
#GLOBALS "../../sub/4gl/s_data_center.global"            #資料中心功能  此處不適用
 
DEFINE g_azb                 RECORD LIKE azb_file.*
DEFINE g_azb_t               RECORD LIKE azb_file.*      #備份舊值
DEFINE g_azb01_t             LIKE azb_file.azb01         #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE azb_file.azbacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE g_all                 SMALLINT
 
MAIN
    OPTIONS
#       FIELD ORDER FORM,                      #依照FORM上面的順序定義做欄位跳動 (預設為依指令順序)
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("AOO")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_azb.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM azb_file WHERE azb01 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i010_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i010_w WITH FORM "aoo/42f/aooi010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_action_choice = ""
   CALL i010_menu()                                         #進入選單 Menu
 
   CLOSE WINDOW i010_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i010_curs()

    CLEAR FORM
    INITIALIZE g_azb.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        azb01,azb02,azb06,  
        azbuser,azbgrup,azbmodu,azbdate,azbacti

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(azb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azb.azb01

                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azb01
                 NEXT FIELD azb01
 
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('azbuser', 'azbgrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位

    LET g_sql = "SELECT azb01 FROM azb_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY azb01"
    PREPARE i010_prepare FROM g_sql
    DECLARE i010_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i010_prepare

    LET g_sql = "SELECT COUNT(*) FROM azb_file WHERE ",g_wc CLIPPED
    PREPARE i010_precount FROM g_sql
    DECLARE i010_count CURSOR FOR i010_precount
END FUNCTION
 

FUNCTION i010_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i010_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i010_q()
            END IF

        ON ACTION next
            CALL i010_fetch('N')

        ON ACTION previous
            CALL i010_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i010_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i010_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i010_r()
            END IF
       ON ACTION m
            LET g_action_choice="m"
            IF cl_chk_act_auth() THEN
                 #CALL p310_chg()
                 #CALL l_aa()
                 #CALL l_cc()
                 #CALL l_dd()
                 #CALL l_ee()
                 #CALL l_ff()
                 #CALL l_gg()
                 #CALL l_hh()
                 #CALL l_ii()
                 #CALL l_jj()
                 #CALL l_kk()
                 #CALL l_ll()
                 #CALL l_ll_imk()
                 #CALL l_ll_zzc()
                 CALL l_mm()
                 #CALL l_nn()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i010_copy()
            END IF

       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN 
               #IF cl_null(g_wc) THEN LET g_wc='1=1' END IF
               IF NOT cl_null(g_azb.azb01) THEN 
                  LET g_wc="azb01='",g_azb.azb01 CLIPPED,"' "
                  #LET l_cmd = '"coor010" "',g_azb.azb01 CLIPPED,'" "Y" '
                  LET l_cmd = "coor010",
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'N' '1' '1'",
                  " '",g_wc CLIPPED,"' 'N' 'N' '0' 'N'"
#FUN-B60074-add-end--
      CALL cl_cmdrun(l_cmd)
                  CALL cl_cmdrun(l_cmd)
               END IF               
            END IF
 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i010_fetch('/')

        ON ACTION first
            CALL i010_fetch('F')

        ON ACTION last
            CALL i010_fetch('L')

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
              IF g_azb.azb01 IS NOT NULL THEN
                 LET g_doc.column1 = "azb01"
                 LET g_doc.value1 = g_azb.azb01
                 CALL cl_doc()
              END IF
           END IF

         &include "qry_string.4gl"
    END MENU
    CLOSE i010_cs
END FUNCTION
 
 
FUNCTION i010_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_azb.* LIKE azb_file.*
    LET g_azb01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_azb.azbuser = g_user
        LET g_azb.azboriu = g_user 
        LET g_azb.azborig = g_grup 
        LET g_azb.azbgrup = g_grup               #使用者所屬群
        LET g_azb.azbdate = g_today
        LET g_azb.azbacti = 'Y'
        CALL i010_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_azb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_azb.azb01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO azb_file VALUES(g_azb.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT azb01 INTO g_azb.azb01 FROM azb_file WHERE azb01 = g_azb.azb01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i010_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_gen02       LIKE gen_file.gen02
   DEFINE l_gen03       LIKE gen_file.gen03
   DEFINE l_gen04       LIKE gen_file.gen04
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_azb.azb01,g_azb.azb02,g_azb.azb06,
      g_azb.azbuser,g_azb.azbgrup,g_azb.azbmodu,g_azb.azbdate,g_azb.azbacti
 
   INPUT BY NAME
      g_azb.azb01,g_azb.azb02,g_azb.azb06,
      g_azb.azbuser,g_azb.azbgrup,g_azb.azbmodu,g_azb.azbdate,g_azb.azbacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i010_set_entry(p_cmd)
          CALL i010_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD azb01
         IF g_azb.azb01 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_azb.azb01 != g_azb01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM azb_file WHERE azb01 = g_azb.azb01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_azb.azb01,-239,1)
                  LET g_azb.azb01 = g_azb01_t
                  DISPLAY BY NAME g_azb.azb01
                  NEXT FIELD azb01
               END IF
               CALL i010_azb01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('azb01:',g_errno,1)
                  LET g_azb.azb01 = g_azb01_t
                  DISPLAY BY NAME g_azb.azb01
                  NEXT FIELD azb01
               END IF
            END IF
         END IF
 
      AFTER INPUT
         LET g_azb.azbuser = s_get_data_owner("azb_file") #FUN-C10039
         LET g_azb.azbgrup = s_get_data_group("azb_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_azb.azb01 IS NULL THEN
               DISPLAY BY NAME g_azb.azb01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD azb01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(azb01) THEN
            LET g_azb.* = g_azb_t.*
            CALL i010_show()
            NEXT FIELD azb01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(azb01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_azb.azb01
              CALL cl_create_qry() RETURNING g_azb.azb01
              DISPLAY BY NAME g_azb.azb01
              NEXT FIELD azb01
 
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
 


FUNCTION i010_azb01(p_cmd)

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gen03    LIKE gen_file.gen03
   DEFINE l_gen04    LIKE gen_file.gen04
   DEFINE l_genacti  LIKE gen_file.genacti
   DEFINE l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT gen02,gen03,gen04,genacti INTO l_gen02,l_gen03,l_gen04,l_genacti FROM gen_file
    WHERE gen01=g_azb.azb01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_gen02=NULL
                                LET l_gen03=NULL
                                LET l_gen04=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gen03 TO FORMONLY.gen03
      DISPLAY l_gen04 TO FORMONLY.gen04

      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_gen03
      IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
      DISPLAY l_gem02 TO gem02
   END IF
END FUNCTION
 


FUNCTION i010_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_azb.* TO NULL    
    MESSAGE "123"
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i010_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i010_count
    FETCH i010_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i010_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
        INITIALIZE g_azb.* TO NULL
    ELSE
        CALL i010_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i010_fetch(p_flazb)
    DEFINE p_flazb         LIKE type_file.chr1
 
    CASE p_flazb
        WHEN 'N' FETCH NEXT     i010_cs INTO g_azb.azb01
        WHEN 'P' FETCH PREVIOUS i010_cs INTO g_azb.azb01
        WHEN 'F' FETCH FIRST    i010_cs INTO g_azb.azb01
        WHEN 'L' FETCH LAST     i010_cs INTO g_azb.azb01
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
            FETCH ABSOLUTE g_jump i010_cs INTO g_azb.azb01
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
        INITIALIZE g_azb.* TO NULL  
        LET g_azb.azb01 = NULL      
        RETURN
    ELSE
      CASE p_flazb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_azb.* FROM azb_file    # 重讀DB,因TEMP有不被更新特性
       WHERE azb01 = g_azb.azb01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_azb.azbuser           #FUN-4C0044權限控管
        LET g_data_group=g_azb.azbgrup
        CALL i010_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i010_show()
    LET g_azb_t.* = g_azb.*
    DISPLAY BY NAME g_azb.azb01,g_azb.azb02,g_azb.azb06,g_azb.azbuser,g_azb.azbgrup,g_azb.azbmodu,
                   g_azb.azbdate,g_azb.azbacti,g_azb.azborig,g_azb.azboriu
    CALL i010_azb01('d')
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i010_u()
    IF g_azb.azb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_azb.* FROM azb_file WHERE azb01=g_azb.azb01
    IF g_azb.azbacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_azb01_t = g_azb.azb01
    BEGIN WORK
 
    OPEN i010_cl USING g_azb.azb01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_azb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_azb.azb01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_azb.azbmodu=g_user                  #修改者
    LET g_azb.azbdate = g_today               #修改日期
    CALL i010_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i010_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_azb.*=g_azb_t.*
            CALL i010_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE azb_file SET azb_file.* = g_azb.*    # 更新DB
            #WHERE azb01 = g_azb.azb01     #MOD-BB0113 mark
            WHERE azb01 = g_azb_t.azb01    #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i010_x()
    IF g_azb.azb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i010_cl USING g_azb.azb01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_azb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_azb.azb01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i010_show()
    IF cl_exp(0,0,g_azb.azbacti) THEN
        LET g_chr = g_azb.azbacti
        IF g_azb.azbacti='Y' THEN
            LET g_azb.azbacti='N'
        ELSE
            LET g_azb.azbacti='Y'
        END IF
        UPDATE azb_file
            SET azbacti=g_azb.azbacti
            WHERE azb01=g_azb.azb01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
            LET g_azb.azbacti = g_chr
        END IF
        DISPLAY BY NAME g_azb.azbacti
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_r()
    IF g_azb.azb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i010_cl USING g_azb.azb01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 0)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_azb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i010_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "azb01"   
       LET g_doc.value1 = g_azb.azb01 

       CALL cl_del_doc()
       DELETE FROM azb_file WHERE azb01 = g_azb.azb01

       CLEAR FORM
       OPEN i010_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i010_cl
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH i010_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i010_cl
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i010_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i010_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i010_fetch('/')
       END IF
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 


FUNCTION i010_copy()

    DEFINE l_newno         LIKE azb_file.azb01
    DEFINE l_oldno         LIKE azb_file.azb01
    DEFINE p_cmd           LIKE type_file.chr1
    DEFINE l_input         LIKE type_file.chr1 
 
    IF g_azb.azb01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i010_set_entry('a')
    LET g_before_input_done = TRUE

    INPUT l_newno FROM azb01
 
        AFTER FIELD azb01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM azb_file WHERE azb01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD azb01
              END IF

              SELECT gen01 FROM gen_file WHERE gen01= l_newno
              IF SQLCA.sqlcode THEN
                  DISPLAY BY NAME g_azb.azb01
                  LET l_newno = NULL
                  NEXT FIELD azb01
              END IF
           END IF
 
        ON ACTION controlp                        # 沿用所有欄位
           IF INFIELD(azb01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_azb.azb01
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO azb01

              SELECT gen01 FROM gen_file WHERE gen01= l_newno
              IF SQLCA.sqlcode THEN
                 DISPLAY BY NAME g_azb.azb01
                 LET l_newno = NULL
                 NEXT FIELD azb01
              END IF
              NEXT FIELD azb01
           END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()  
 
      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help      
         CALL cl_show_help() 
 
      ON ACTION controlg  
         CALL cl_cmdask() 
    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_azb.azb01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM azb_file
        WHERE azb01=g_azb.azb01
        INTO TEMP x
    UPDATE x
        SET azb01=l_newno,    #資料鍵值
            azbacti='Y',      #資料有效碼
            azbuser=g_user,   #資料所有者
            azbgrup=g_grup,   #資料所有者所屬群
            azbmodu=NULL,     #資料修改日期
            azbdate=g_today   #資料建立日期

    INSERT INTO azb_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_azb.azb01
        LET g_azb.azb01 = l_newno
        SELECT azb_file.* INTO g_azb.* FROM azb_file
               WHERE azb01 = l_newno
        CALL i010_u()
        #SELECT azb_file.* INTO g_azb.* FROM azb_file  #FUN-C80046
        #       WHERE azb01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_azb.azb01 = l_oldno                         #FUN-C80046
    CALL i010_show()
END FUNCTION

 
PRIVATE FUNCTION i010_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("azb01",TRUE)
   END IF
END FUNCTION

 
PRIVATE FUNCTION i010_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("azb01",FALSE)
   END IF
#SELECT rowid FROM zz_file WhERE zz01=g_zz01        #No.TQC-B60372
END FUNCTION

FUNCTION p310_chg()
   #批处理时: tc_data01:旧run-card单单号
   #        tc_data02:新run-card单单号
   #        tc_data03：作业编码
   #        tc_data08:当站数量
   #        tc_data04:更新失败原因
   DEFINE  l_shm01      LIKE shm_file.shm01
   DEFINE  l_sgm04      LIKE sgm_file.sgm04
   DEFINE  l_shm08      LIKE shm_file.shm08
   DEFINE  l_sql        STRING
   DEFINE  l_msg        STRING
   DEFINE  l_end        CHAR(1)
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE l_imaud07       LIKE ima_file.imaud07
   DEFINE  l_n          SMALLINT
   DEFINE l_max         SMALLINT
   DEFINE  l_tmp        RECORD
             tc_data01  LIKE tc_data_file.tc_data01,
             tc_data02  LIKE tc_data_file.tc_data02,
             tc_data03  LIKE tc_data_file.tc_data03,             
             tc_data08  LIKE tc_data_file.tc_data08
           END RECORD
   LET l_max= 1 
   IF cl_null(l_shm01) THEN   
     LET l_sql = "SELECT tc_data01,tc_data02,tc_data03,tc_data08 FROM tc_data_file"
     PREPARE p310_chg_pre FROM l_sql
     DECLARE p310_chg_cs CURSOR FOR p310_chg_pre
     FOREACH p310_chg_cs INTO l_tmp.*
       DISPLAY l_max
       LET l_sql = "SELECT sgm01,sgm04,shm08 FROM shm_file,sgm_file WHERE sgm01='",l_tmp.tc_data02,
                   "' and sgm01=shm01 and sgm04='",l_tmp.tc_data03,"'"
       PREPARE p310_chg_pre1 FROM l_sql
       DECLARE p310_chg_cs1 CURSOR FOR p310_chg_pre1
       FOREACH p310_chg_cs1 INTO l_shm01,l_sgm04,l_shm08
         LET l_n = 0        
         SELECT COUNT(*) INTO l_n FROM sgm_file WHERE sgm01=l_shm01 AND sgm04=l_sgm04
         IF l_n = 0 THEN 
            CONTINUE FOREACH 
         END IF #说明没有这一栏
         IF l_n > 1 THEN
           LET l_msg = 'Run-Card单：',l_shm01 CLIPPED,'作业编号:',l_sgm04 CLIPPED,'重复'
           DISPLAY l_msg 
           CONTINUE FOREACH 
         END IF
         IF l_tmp.tc_data08 != l_shm08 THEN
            SELECT sgm03_par INTO l_ima01 FROM sgm_file WHERE sgm01=l_shm01 AND sgm04=l_sgm04
            SELECT imaud07 INTO l_imaud07 FROM ima_file WHERE ima01=l_ima01
            IF cl_null(l_imaud07) THEN LET l_imaud07 = 1 END IF
            LET l_tmp.tc_data08 = l_tmp.tc_data08 * l_imaud07
         END IF 
         CALL p310_turn(l_shm01,l_tmp.tc_data01,l_sgm04,l_tmp.tc_data08,l_shm08) RETURNING l_end
         IF l_end ='Y' THEN EXIT FOREACH END IF
         
       END FOREACH
       LET l_max = l_max + 1
     END FOREACH
   END IF

END FUNCTION

#l_shm01:新系统run-card单号
#l_shm01_o旧系统run-card单号
#l_sgm04:作业编码
#l_sgm65:报工数量
FUNCTION p310_turn(l_shm01,l_shm01_o,l_sgm04,l_sgm65,l_sgm65_n)
    DEFINE l_shm01           LIKE shm_file.shm01
    DEFINE l_shm01_o         LIKE shm_file.shm01 
    DEFINE l_sgm04           LIKE sgm_file.sgm04
    DEFINE l_sgm65           LIKE sgm_file.sgm65
    DEFINE l_sgm65_n         LIKE sgm_file.sgm65
    DEFINE l_sgm03           LIKE sgm_file.sgm03
    DEFINE l_sgm03_m         LIKE sgm_file.sgm03
    DEFINE l_sql             STRING
    DEFINE l_e               CHAR(1)

    #BEGIN WORK
    LET l_e = 'Y'
    IF l_sgm65 != l_sgm65_n THEN 
       UPDATE tc_data_file SET tc_data04='生产数量不一致' WHERE tc_data01=l_shm01_o AND tc_data02=l_shm01 AND tc_data03=l_sgm04
       RETURN 'Y'
    END IF
    SELECT sgm03 INTO l_sgm03 FROM sgm_file WHERE sgm01=l_shm01 AND sgm04=l_sgm04
    LET l_sql = "select sgm03 from sgm_file where sgm01='",l_shm01 CLIPPED,"' and sgm03<",l_sgm03," order by sgm03"
    PREPARE p310_turn_pre FROM l_sql
    DECLARE p310_turn_cs CURSOR FOR p310_turn_pre
    FOREACH p310_turn_cs INTO l_sgm03_m
       UPDATE sgm_file SET sgm301=l_sgm65,sgm311=l_sgm65 WHERE sgm01=l_shm01 AND sgm03=l_sgm03_m
       IF STATUS THEN
          LET l_e='N'
          EXIT FOREACH
       END IF
    END FOREACH
    IF l_e = 'Y' THEN
       UPDATE sgm_file SET sgm301=l_sgm65 WHERE sgm01=l_shm01 AND sgm03=l_sgm03
       IF STATUS THEN
          LET l_e='N'
       END IF
    END IF
    IF l_e = 'Y' THEN
       UPDATE tc_data_file SET tc_data05=l_shm01 WHERE tc_data01=l_shm01_o AND tc_data02=l_shm01 AND tc_data03=l_sgm04
       IF STATUS THEN
          LET l_e='N'
       END IF
    END IF
    #IF l_e = 'Y' THEN
    #   COMMIT WORK
    #ELSE
    #   ROLLBACK WORK
    #END IF
    RETURN l_e
END FUNCTION

FUNCTION l_aa()
  DEFINE l_sfs01   LIKE sfs_file.sfs01
  DEFINE l_sfs02   LIKE sfs_file.sfs02
  DEFINE l_sfs05   LIKE sfs_file.sfs05
  DEFINE l_sfs05_n LIKE sfs_file.sfs05
  DEFINE l_sql     STRING
  DEFINE l_m       SMALLINT

  LET l_m = 1
  LET l_sql="SELECT sfs01,sfs02,sfs05,sfa05-sfa06 FROM sfs_file,sfa_file",
            " WHERE sfs01='WMT-1612310001' AND sfa01=sfs03 AND sfa27=sfs27 AND sfs10=sfa08",
            " AND sfa05-sfa06 < sfs05"
   PREPARE l_aa_pre FROM l_sql
   DECLARE l_aa_cs CURSOR FOR l_aa_pre
   FOREACH l_aa_cs INTO l_sfs01,l_sfs02,l_sfs05,l_sfs05_n
      IF l_sfs05 > l_sfs05_n THEN      
         DISPLAY l_m
         UPDATE sfs_file SET sfs05=l_sfs05_n WHERE sfs01='WMT-1612310001' AND sfs02=l_sfs02
         LET l_m = l_m + 1
      END IF
   END FOREACH
END FUNCTION

FUNCTION l_bb()
  DEFINE l_sfa01    LIKE sfa_file.sfa01,
         l_sfa27    LIKE sfa_file.sfa01,
         l_sfa06    LIKE sfa_file.sfa01,
         l_sfa06_n  LIKE sfa_file.sfa01,
         l_sfa05    LIKE sfa_file.sfa01,
         l_sfa08    LIKE sfa_file.sfa01,
         l_sfb08    LIKE sfb_file.sfb08,
         l_u        LIKE sfa_file.sfa05
  DEFINE l_sql     STRING
  DEFINE l_m       SMALLINT
  LET l_m = 1
  LET l_sql="SELECT sfa01,sfa27,sfa06,(sfb08*sfa16),sfa05,sfa08 FROM sfb_file,sfa_file,ima_file where sfa01=sfb01 ",
            "AND sfa11!='E' AND sfa27=ima01 AND ima63 IN(SELECT gfe01 FROM gfe_file WHERE gfe03 > 0)"          
  PREPARE l_bb_pre FROM l_sql
  DECLARE l_bb_cs CURSOR FOR l_bb_pre
  FOREACH l_bb_cs INTO l_sfa01,l_sfa27,l_sfa06,l_sfa06_n,l_sfa05,l_sfa08
     DISPLAY l_m
     IF l_sfa06_n < l_sfa05 THEN
        IF l_sfa06_n < l_sfa06 THEN 
           LET l_u = l_sfa06
        ELSE
           LET l_u = l_sfa06_n
        END IF
        SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01=l_sfa01
        UPDATE sfa_file SET sfa05=l_u,sfa161=l_u/l_sfb08 WHERE 
        sfa01=l_sfa01 AND sfa27=l_sfa27 AND sfa08=l_sfa08                
     END IF
    LET l_m = l_m + 1
  END FOREACH
END FUNCTION

FUNCTION l_cc()
DEFINE l_sfq        RECORD   LIKE sfq_file.*
DEFINE l_sfq01      LIKE sfq_file.sfq01
DEFINE l_sfq02      LIKE sfq_file.sfq02
DEFINE l_sfp06      LIKE sfp_file.sfp06
DEFINE l_sfe01      LIKE sfe_file.sfe01
DEFINE l_sfe02      LIKE sfe_file.sfe02
DEFINE l_sfe14      LIKE sfe_file.sfe14
DEFINE l_sfb08      LIKE sfb_file.sfb08
DEFINE l_sfb081     LIKE sfb_file.sfb081
DEFINE l_sql        STRING
DEFINE l_m          SMALLINT

  LET l_m = 1
  LET l_sql="SELECT distinct sfq01,sfq02 FROM sfq_file,sfp_file WHERE ",
            " sfq02 IN (SELECT sfb01 FROM sfb_file WHERE sfb081=0) AND sfq01=sfp01 AND sfp04='Y' "          
  PREPARE l_cc_pre FROM l_sql
  DECLARE l_cc_cs CURSOR FOR l_cc_pre
  FOREACH l_cc_cs INTO l_sfq01,l_sfq02
     DISPLAY l_m
     SELECT sfp06 INTO l_sfp06 FROM sfp_file WHERE sfp01=l_sfq01
     IF l_sfp06='2' THEN CONTINUE FOREACH END IF
     DELETE FROM sfq_file WHERE sfq01=l_sfq01 AND sfq02=l_sfq02
     LET l_sql="SELECT distinct sfe01,sfe02,sfe14 FROM sfe_file WHERE sfe01='",l_sfq02,"' and sfe02='",l_sfq01,"'"               
     PREPARE l_cc_pre2 FROM l_sql
     DECLARE l_cc_cs2 CURSOR FOR l_cc_pre2
     FOREACH l_cc_cs2 INTO  l_sfe01,l_sfe02,l_sfe14
       LET l_sfq.sfq01=l_sfe02
       LET l_sfq.sfq02=l_sfe01
       IF l_sfp06 = '1' THEN 
          SELECT sfb08 INTO l_sfq.sfq03 FROM sfb_file WHERE sfb01=l_sfq02
       ELSE 
        LET l_sfq.sfq03 = 0
       END IF
       LET l_sfq.sfq04=l_sfe14
       LET l_sfq.sfq05='16/12/31'
       LET l_sfq.sfq06='0'
       LET l_sfq.sfq07=' '
       LET l_sfq.sfq08=l_sfq.sfq03
       LET l_sfq.sfqplant='CH'
       LET l_sfq.sfqlegal='CH'
       LET l_sfq.sfq012=' '
       LET l_sfq.sfq014=' '
       INSERT INTO sfq_file VALUES(l_sfq.*)       
     END FOREACH     
     SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 FROM sfb_file WHERE sfb01=l_sfq02
     IF l_sfb081=0 THEN 
        UPDATE sfb_file SET sfb081 = l_sfb08 WHERE sfb01=l_sfq02
     END IF
     LET l_m = l_m + 1
  END FOREACH

END FUNCTION

FUNCTION l_dd()
DEFINE g_pmm RECORD LIKE pmm_file.*,
       g_pmn RECORD LIKE pmn_file.*,
       g_rvv RECORD LIKE rvv_file.*,
       g_rvb RECORD LIKE rvb_file.*,
       l_pmm40      LIKE pmm_file.pmm40,
       l_pmm40t     LIKE pmm_file.pmm40t,
       l_pmn88,l_pmn88t LIKE pmn_file.pmn88,
       l_cnt        LIKE type_file.num5,
       t_azi04      LIKE azi_file.azi04,
       t_azi03      LIKE azi_file.azi03,
       g_gec07      LIKE gec_File.gec07,
       g_gec05      LIKE gec_file.gec05,
       l_pmn31      LIKE pmn_file.pmn31,
       l_pmn31t     LIKE pmn_file.pmn31t,
       l_pmn73      LIKE pmn_file.pmn73,
       l_pmn74      LIKE pmn_file.pmn74,
       l_all        SMALLINT


       LET l_all = 1
  DECLARE sel_pmn_cur1 CURSOR FOR
    SELECT DISTINCT pmm_file.* FROM  pmm_file,pmn_file WHERE 
     pmm18!='X' AND pmm02='SUB' AND pmn07 !='PCS' AND pmm01=pmn01
     AND pmm01='OPO-1701090034' AND pmn02=6
   
   FOREACH sel_pmn_cur1 INTO g_pmm.*  
          DISPLAY l_all
          LET l_all = l_all + 1 
          SELECT azi03,azi04 INTO t_azi03,t_azi04
            FROM azi_file
           WHERE azi01=g_pmm.pmm22    
        SELECT gec07,gec05 INTO g_gec07,g_gec05  #No:FUN-550019   #CHI-AC0016 add gec05
            FROM gec_file
           WHERE gec01 = g_pmm.pmm21
             AND gec011='1'     
        SELECT azi04 INTO t_azi04 FROM azi_file  #No.CHI-6A0004
         WHERE azi01=g_pmm.pmm22 AND aziacti ='Y'      
     DECLARE sel_pmn_cur CURSOR FOR
       SELECT pmn_file.* FROM pmn_file WHERE pmn01=g_pmm.pmm01 ORDER BY pmn01,pmn02        
       FOREACH  sel_pmn_cur INTO g_pmn.*
           CALL s_defprice_new(g_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_today,
                               g_pmn.pmn87,g_pmn.pmn78,g_pmm.pmm21,g_pmm.pmm43,'2',
                               g_pmn.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                                RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74
                  #LET g_pmn.pmn31 = 0.017669
                  #LET g_pmn.pmn31t = 0.017669
           IF cl_null(l_pmn31t) THEN LET l_pmn31t = 0 END IF
           #IF l_pmn31t = g_pmn.pmn31t THEN  CONTINUE FOREACH END IF
              
           
                  LET g_pmn.pmn82 = g_pmn.pmn20 
                  LET g_pmn.pmn87 = g_pmn.pmn20 
                  LET g_pmn.pmn31 = l_pmn31
                  LET g_pmn.pmn31t = l_pmn31t
                  UPDATE pmn_file SET pmn31 = g_pmn.pmn31,pmn31t=g_pmn.pmn31t
                  WHERE pmn01=g_pmn.pmn01 AND pmn02=g_pmn.pmn02
                  
                  UPDATE pmn_file SET pmn82 = g_pmn.pmn82,pmn87=g_pmn.pmn87 
                     WHERE pmn01=g_pmn.pmn01 AND pmn02=g_pmn.pmn02
           
                 LET g_pmn.pmn88=g_pmn.pmn20*g_pmn.pmn31
                 LET g_pmn.pmn88t=g_pmn.pmn20*g_pmn.pmn31t
                 CALL cl_digcut(g_pmn.pmn88,t_azi04) RETURNING g_pmn.pmn88
                 CALL cl_digcut(g_pmn.pmn88t,t_azi04) RETURNING g_pmn.pmn88t
                 UPDATE pmn_file SET pmn88=g_pmn.pmn88,pmn88t=g_pmn.pmn88t
                 WHERE pmn01=g_pmn.pmn01 AND pmn02=g_pmn.pmn02
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM rvb_file WHERE rvb04=g_pmn.pmn01 AND rvb03=g_pmn.pmn02
            IF l_cnt > 0 THEN
               DECLARE sel_rvb_cur CURSOR FOR
                    SELECT rvb_file.* FROM rvb_file WHERE rvb04=g_pmn.pmn01 AND rvb03=g_pmn.pmn02     
               FOREACH  sel_rvb_cur INTO g_rvb.*
                  LET g_rvb.rvb10= g_pmn.pmn31
                  LET g_rvb.rvb10t= g_pmn.pmn31t
                  LET g_rvb.rvb88=g_rvb.rvb10*g_rvb.rvb87
                  LET g_rvb.rvb88t=g_rvb.rvb10t*g_rvb.rvb87
                  CALL cl_digcut(g_rvb.rvb88,t_azi04) RETURNING g_rvb.rvb88
                  CALL cl_digcut(g_rvb.rvb88t,t_azi04) RETURNING g_rvb.rvb88t 
                  UPDATE rvb_file SET rvb10=g_rvb.rvb10,rvb10t=g_rvb.rvb10t,rvb88=g_rvb.rvb88,rvb88t=g_rvb.rvb88t
                  WHERE rvb01=g_rvb.rvb01 AND rvb02=g_rvb.rvb02

               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM rvv_file WHERE rvv04=g_rvb.rvb01 AND rvv05=g_rvb.rvb02
               IF l_cnt > 0 THEN
                  DECLARE sel_rvv_cur CURSOR FOR
                     SELECT rvv_file.* FROM rvv_file WHERE rvv04=g_rvb.rvb01 AND rvv05=g_rvb.rvb02
                  FOREACH  sel_rvv_cur INTO g_rvv.*
                     LET g_rvv.rvv38=g_rvb.rvb10
                     LET g_rvv.rvv38t=g_rvb.rvb10t
                     LET g_rvv.rvv39=g_rvv.rvv17 * g_rvv.rvv38
                     LET g_rvv.rvv39t=g_rvv.rvv17 * g_rvv.rvv38t
                     CALL cl_digcut(g_rvv.rvv39,t_azi04) RETURNING g_rvv.rvv39
                     CALL cl_digcut(g_rvv.rvv39t,t_azi04) RETURNING g_rvv.rvv39t
                     UPDATE rvv_file SET rvv38=g_rvv.rvv38,rvv38t=g_rvv.rvv38t,rvv39=g_rvv.rvv39,rvv39t=g_rvv.rvv39t
                  WHERE rvv01=g_rvv.rvv01 AND rvv02=g_rvv.rvv02
                  END FOREACH
               END IF                  
               END FOREACH
            END IF
       END FOREACH 

        LET l_pmm40  = 0 
        LET l_pmm40t = 0
         SELECT SUM(pmn88),SUM(pmn88t)   
         INTO l_pmm40,l_pmm40t     
         FROM pmn_file
         WHERE pmn01 = g_pmm.pmm01
         IF SQLCA.sqlcode OR l_pmm40 IS NULL THEN
            LET l_pmm40 = 0
            LET l_pmm40t= 0   #No.FUN-610018
         END IF
         SELECT azi04 INTO t_azi04 FROM azi_file  #No.CHI-6A0004
         WHERE azi01=g_pmm.pmm22 AND aziacti ='Y'
         CALL cl_digcut(l_pmm40,t_azi04) RETURNING l_pmm40  #No.CHI-6A0004
         CALL cl_digcut(l_pmm40t,t_azi04) RETURNING l_pmm40t  #No.FUN-610018  #No.CHI-6A0004

         UPDATE pmm_file SET pmm40 = l_pmm40,  #未稅總金額
                             pmm40t= l_pmm40t  #FUN-610018 含稅總金額
         WHERE pmm01 = g_pmm.pmm01

         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","update pmm40 fail :",1)  #No.FUN-660129
         END IF
   END FOREACH   
END FUNCTION

FUNCTION l_ee()
    DEFINE l_imaud07  LIKE ima_file.imaud07
    DEFINE l_sql     STRING 
    DEFINE l_qcm  RECORD LIKE qcm_file.*
    DEFINE l_m    SMALLINT

    LET l_m = 1 
     LET l_sql ="SELECT * FROM qcm_file", 
                " WHERE qcmud02||qcmud10 IN (SELECT rvb01||rvb02 FROM qcm_file,rva_file LEFT JOIN pmc_file ON rva05=pmc01,",
                " rvb_file LEFT JOIN ima_file ON rvb05=ima01 ",
                "WHERE qcmud02=rva01 AND rva01=rvb01 AND rvb01=qcmud02 AND rvb02=qcmud10 AND rva10='SUB'",
                "AND rvb90='PNL' AND rvb07 <> rvb30 AND rvb30 !=0 AND rvb01 != 'ORA-1701090037')"
    PREPARE l_ee_pre FROM l_sql
    DECLARE l_ee_cs CURSOR FOR l_ee_pre
    FOREACH l_ee_cs INTO l_qcm.*
        DISPLAY l_m         
        SELECT imaud07 INTO l_imaud07 FROM ima_file WHERE ima01=l_qcm.qcm021
        IF cl_null(l_imaud07) THEN LET l_imaud07 = 1 END IF
        UPDATE qcm_file SET qcm22=qcm22 * l_imaud07,qcm091=qcm091 * l_imaud07
        WHERE qcm01=l_qcm.qcm01
        LET l_m = l_m + 1
    END FOREACH
  
END FUNCTION
{
FUNCTION l_gg()
DEFINE l_tc_data02    LIKE tc_data_file.tc_data02
DEFINE l_tc_data06    LIKE tc_data_file.tc_data06
DEFINE l_d1           LIKE tc_data_file.tc_data01
DEFINE l_d2           LIKE tc_data_file.tc_data02
DEFINE l_d6           LIKE tc_data_file.tc_data06
DEFINE l_d8           LIKE tc_data_file.tc_data08
DEFINE l_cnt          SMALLINT
DEFINE l_j            SMALLINT
DEFINE l_m            SMALLINT
DEFINE l_sql          STRING
DEFINE l_tc_datf      RECORD LIKE tc_datf_file.*
DEFINE l_e1           LIKE tc_date_file.tc_date01
DEFINE l_e2           LIKE tc_date_file.tc_date02
DEFINE l_e7           LIKE tc_date_file.tc_date07
DEFINE l_e8           LIKE tc_date_file.tc_date08
DEFINE l_e9           LIKE tc_date_file.tc_date09
DEFINE l_e10          LIKE tc_date_file.tc_date10
DEFINE l_e11          LIKE tc_date_file.tc_date11

DEFINE l_e7a          LIKE tc_date_file.tc_date07
DEFINE l_e8a          LIKE tc_date_file.tc_date08
DEFINE l_e9a          LIKE tc_date_file.tc_date09
DEFINE l_e10a         LIKE tc_date_file.tc_date10
DEFINE l_e11a         LIKE tc_date_file.tc_date11
            

   LET l_sql ="SELECT tc_data02,sum(tc_data06) FROM tc_data_file group by tc_data02"
   PREPARE l_gg_pre FROM l_sql
   DECLARE l_gg_cs CURSOR FOR l_gg_pre
   FOREACH l_gg_cs INTO l_tc_data02,l_tc_data06
     SELECT COUNT(*) INTO l_cnt FROM tc_data_file WHERE tc_data02 = l_tc_data02
     LET l_sql ="SELECT tc_data01,tc_data02,tc_data06 FROM tc_data_file WHERE  tc_data02 ='",l_tc_data02 CLIPPED,"'"
     PREPARE l_gg_pre1 FROM l_sql
     DECLARE l_gg_cs1 CURSOR FOR l_gg_pre1
     FOREACH l_gg_cs1 INTO l_d1,l_d2,l_d6
       LET l_d8 = l_d6 / l_tc_data06
       UPDATE tc_data_file SET tc_data08=l_d8 WHERE tc_data01=l_d1 AND tc_data02=l_d2 AND tc_data06=l_d6
     END FOREACH
   END FOREACH

   LET l_sql ="SELECT distinct tc_data02 FROM tc_data_file "
   PREPARE l_gg_pre2 FROM l_sql
   DECLARE l_gg_cs2 CURSOR FOR l_gg_pre2
   FOREACH l_gg_cs2 INTO l_tc_data02
      DISPLAY l_tc_data02
      LET l_e7a = 0
      LET l_e8a = 0
      LET l_e9a = 0
      LET l_e10a = 0
      LET l_e11a = 0
      SELECT COUNT(*) INTO l_m FROM tc_date_file WHERE  tc_date02 = l_tc_data02
      IF l_m = 1  THEN 
         SELECT tc_date01,tc_date02,tc_date07,tc_date08,tc_date09,tc_date10,tc_date11
            INTO l_e1,l_e2,l_e7,l_e8,l_e9,l_e10,l_e11 
             FROM tc_date_file WHERE  tc_date02 = l_tc_data02
         LET l_j = 1
         SELECT COUNT(*) INTO l_cnt FROM tc_data_file WHERE tc_data02 = l_tc_data02
         LET l_sql ="SELECT tc_data01,tc_data02,tc_data06,tc_data08 FROM tc_data_file WHERE  tc_data02 ='",l_tc_data02 CLIPPED,"'"
         PREPARE l_gg_pre3 FROM l_sql
         DECLARE l_gg_cs3 CURSOR FOR l_gg_pre3
         FOREACH l_gg_cs3 INTO l_d1,l_d2,l_d6,l_d8            
            IF l_j = l_cnt THEN
               LET l_tc_datf.tc_datf01 = l_e1
               LET l_tc_datf.tc_datf02 = l_d1
               LET l_tc_datf.tc_datf03 = l_d2
               LET l_tc_datf.tc_datf12 = l_d6
               LET l_tc_datf.tc_datf13 = l_d8
               LET l_tc_datf.tc_datf07 = l_e7 - l_e7a
               LET l_tc_datf.tc_datf08 = l_e8 - l_e8a
               LET l_tc_datf.tc_datf09 = l_e9 - l_e9a
               LET l_tc_datf.tc_datf10 = l_e10 - l_e10a
               LET l_tc_datf.tc_datf11 = l_e11 - l_e11a
            ELSE 
               LET l_tc_datf.tc_datf01 = l_e1
               LET l_tc_datf.tc_datf02 = l_d1
               LET l_tc_datf.tc_datf03 = l_d2
               LET l_tc_datf.tc_datf12 = l_d6
               LET l_tc_datf.tc_datf13 = l_d8
               LET l_tc_datf.tc_datf07 = l_e7 * l_d8
               LET l_tc_datf.tc_datf08 = l_e8 * l_d8
               LET l_tc_datf.tc_datf09 = l_e9 * l_d8
               LET l_tc_datf.tc_datf10 = l_e10 * l_d8
               LET l_tc_datf.tc_datf11 = l_e11 * l_d8
               
               LET l_e7a = l_e7a + l_tc_datf.tc_datf07
               LET l_e8a = l_e8a + l_tc_datf.tc_datf08
               LET l_e9a = l_e9a + l_tc_datf.tc_datf09
               LET l_e10a = l_e10a + l_tc_datf.tc_datf10
               LET l_e11a = l_e11a + l_tc_datf.tc_datf11
            END IF
            INSERT INTO tc_datf_file VALUES(l_tc_datf.*)
         END FOREACH
       END IF 
   END FOREACH
   
END FUNCTION
}
{
FUNCTION l_hh()
DEFINE l_sql STRING 
DEFINE l_cnt SMALLINT
DEFINE l_j   SMALLINT
DEFINE l_tc_date01    LIKE tc_date_file.tc_date01
DEFINE l_tc_data09    LIKE tc_data_file.tc_data09
DEFINE l_e1           LIKE tc_date_file.tc_date01
DEFINE l_e2           LIKE tc_date_file.tc_date02
DEFINE l_e3           LIKE tc_date_file.tc_date03
DEFINE l_e7           LIKE tc_date_file.tc_date07
DEFINE l_e8           LIKE tc_date_file.tc_date08
DEFINE l_e9           LIKE tc_date_file.tc_date09
DEFINE l_e10          LIKE tc_date_file.tc_date10
DEFINE l_e10a         LIKE tc_date_file.tc_date10


   LET l_sql = "SELECT DISTINCT tc_date01 FROM tc_date_file"
   PREPARE l_hh_pre FROM l_sql
   DECLARE l_hh_cs CURSOR FOR l_hh_pre
   FOREACH l_hh_cs INTO l_tc_date01
      DISPLAY l_tc_date01
      SELECT COUNT(*) INTO l_cnt FROM tc_date_file WHERE tc_date01 = l_tc_date01
      LET l_j = 1
      LET l_e10a = 0
      SELECT tc_data09 INTO l_tc_data09 FROM tc_data_file WHERE tc_data01=l_tc_date01   
      LET l_sql = "SELECT tc_date01,tc_date02,tc_date03,tc_date07,tc_date08,tc_date09 FROM tc_date_file WHERE tc_date01='",l_tc_date01 CLIPPED,"' order by tc_date09 DESC"
      PREPARE l_hh1_pre FROM l_sql
      DECLARE l_hh1_cs CURSOR FOR l_hh1_pre
      FOREACH l_hh1_cs INTO l_e1,l_e2,l_e3,l_e7,l_e8,l_e9
         IF l_j = l_cnt THEN
            LET l_e10 = l_tc_data09 - l_e10a
         ELSE
            LET l_e10 = l_tc_data09 * l_e9
            LET l_e10a = l_e10a + l_e10
         END IF
         UPDATE tc_date_file SET tc_date10 = l_e10 WHERE tc_date01=l_e1 AND tc_date03=l_e3
         LET l_j = l_j + 1
      END FOREACH
   END FOREACH
END FUNCTION

FUNCTION l_ii()
   DEFINE l_sql STRING 
   DEFINE l_n   SMALLINT
   DEFINE l_ccg01   LIKE ccg_file.ccg01,
          l_ccg02   LIKE ccg_file.ccg02,
          l_ccg03   LIKE ccg_file.ccg03,
          l_ccg11   LIKE ccg_file.ccg04,
          l_ccg31   LIKE ccg_file.ccg31,
          l_ccg91   LIKE ccg_file.ccg91,
          l_ccg91_1 LIKE ccg_file.ccg91,
          l_ccg91_2 LIKE ccg_file.ccg92

   LET l_n = 0
   LET l_sql = "SELECT ccg01 FROM ccg_file WHERE ccg03=2 AND ccg11 < 0 "
   PREPARE l_ii_pre FROM l_sql
   DECLARE l_ii_cs CURSOR FOR l_ii_pre
   FOREACH l_ii_cs INTO l_ccg01       
       LET l_ccg02 = 2016
       LET l_ccg03 =12
       LET l_ccg11 = 0
       LET l_ccg31=0
       LET l_ccg91 = 0
       LET l_ccg91_1 = 0
       LET l_ccg91_2 = 0
       LET l_n = l_n + 1
       DISPLAY l_n
       LET l_sql = "SELECT ccg01,ccg02,ccg03,ccg11,ccg31,ccg91 FROM ccg_file WHERE ccg01='",l_ccg01,"' order by ccg02,ccg03"
       PREPARE l_ii_pre1 FROM l_sql
       DECLARE l_ii_cs2 CURSOR FOR l_ii_pre1
       FOREACH l_ii_cs2 INTO l_ccg01,l_ccg02,l_ccg03,l_ccg11,l_ccg31,l_ccg91
          IF l_ccg02 = 2016 AND l_ccg03=12 THEN 
             LET l_ccg91_1 = l_ccg91
          END IF
          IF l_ccg02 = 2017 AND l_ccg03=1 THEN 
             LET l_ccg11 = l_ccg91_1
             LET l_ccg91 = l_ccg11 + l_ccg31
             LET l_ccg91_2 = l_ccg91
             UPDATE ccg_file SET ccg11 = l_ccg11,ccg91 = l_ccg91 
             WHERE ccg01=l_ccg01 AND ccg02=l_ccg02 AND ccg03=l_ccg03
          END IF
          IF l_ccg02 = 2017 AND l_ccg03=2 THEN 
             LET l_ccg11 = l_ccg91_2
             LET l_ccg91 = l_ccg11 + l_ccg31      
             UPDATE ccg_file SET ccg11 = l_ccg11,ccg91 = l_ccg91 
                WHERE ccg01=l_ccg01 AND ccg02=l_ccg02 AND ccg03=l_ccg03      
          END IF
       END FOREACH
   END FOREACH
   
END FUNCTION
}
FUNCTION l_jj()
   DEFINE l_sql     STRING 
   DEFINE l_n       SMALLINT
   DEFINE l_sfb05   LIKE sfb_file.sfb05   

   LET g_all = 1
   LET l_sql ="SELECT DISTINCT sfb05 FROM sfp_file,sfq_file,sfb_file WHERE sfp01=sfq01 AND sfq02=sfb01 ",
              " AND sfp03 BETWEEN to_date('16/11/01','YY/MM/DD') AND to_date('16/12/31','YY/MM/DD') ",
              " AND sfb05 NOT LIKE '%-%' UNION ",
              " SELECT DISTINCT sfv04 FROM sfu_file,sfv_file WHERE sfv01=sfu01 ",
              " AND sfu02 BETWEEN to_date('16/11/01','YY/MM/DD') AND to_date('16/12/31','YY/MM/DD') ",
              " AND sfv04 NOT LIKE '%-%'"
   PREPARE l_jj_pre FROM l_sql
   DECLARE l_jj_cs CURSOR FOR l_jj_pre
   FOREACH l_jj_cs INTO l_sfb05       
         LET g_all = g_all + 1        
         CALL jj_bom(l_sfb05,l_sfb05,1)
         DISPLAY g_all
   END FOREACH
END FUNCTION

FUNCTION jj_bom(l_bma01,l_bmb01,l_bmb06)
     DEFINE ll_bmb    RECORD
      bmb01         LIKE bmb_file.bmb01,
      ima02         LIKE ima_file.ima02,
      ima021        LIKE ima_file.ima021,
      bmb03         LIKE bmb_file.bmb03,
      bmb06         LIKE bmb_file.bmb06,
      bmb10         LIKE bmb_file.bmb10,
      ima63_fac     LIKE ima_file.ima63_fac
      END RECORD
      
  DEFINE sr  DYNAMIC ARRAY OF RECORD
      bmb02         LIKE bmb_file.bmb02,
      bmb01         LIKE bmb_file.bmb01,
      ima02         LIKE ima_file.ima02,
      ima021        LIKE ima_file.ima021,
      bmb03         LIKE bmb_file.bmb03,
      bmb06         LIKE bmb_file.bmb06,
      bmb10         LIKE bmb_file.bmb10,
      ima63_fac     LIKE ima_file.ima63_fac
      END RECORD
  
  DEFINE l_bma01    LIKE bma_file.bma01
  DEFINE l_bmb01    LIKE bmb_file.bmb01
  DEFINE l_bmb06    LIKE bmb_file.bmb06
  DEFINE l_sql      STRING
  DEFINE l_bmb03    STRING
  DEFINE l_n        SMALLINT
  DEFINE l_i        SMALLINT
  DEFINE l_bma01_t  LIKE bma_file.bma01

  
  IF l_bma01 != l_bma01_t OR cl_null(l_bma01_t) THEN 
     CALL sr.clear()
     LET l_n =1     
  END IF
  LET l_sql ="SELECT 0,bmb01,ima02,ima021,bmb03,bmb06/bmb07 bmb06,bmb10,0 FROM bmb_file,ima_file ",
             " WHERE bmb01=ima01 AND bmb04<=to_date('2016/12/31','yyyy/mm/dd') ",
             " AND (bmb05 is null or bmb05 >=to_date('2016/12/31','yyyy/mm/dd') ) ",
             " AND bmb01 = '",l_bmb01 CLIPPED,"'"
  PREPARE l_jj1_pre FROM l_sql
  DECLARE l_jj1_cs CURSOR FOR l_jj1_pre
  FOREACH l_jj1_cs INTO sr[l_n].*
    LET l_n = l_n + 1
  END FOREACH  
  FOR l_i = 1 TO l_n
     IF cl_null(sr[l_i].bmb01) THEN CONTINUE FOR END IF
     LET l_bmb03=sr[l_i].bmb03
     IF l_bmb03.getIndexOf('-',1) THEN
       CALL jj_bom(l_bma01,sr[l_i].bmb03,sr[l_i].bmb06)
     ELSE
       IF cl_null(l_bmb06) THEN LET l_bmb06 = 1 END IF
       LET sr[l_i].bmb01 = l_bma01
       LET sr[l_i].bmb06 = sr[l_i].bmb06 * l_bmb06
       LET sr[l_i].bmb02 = g_all
       INSERT INTO bmb_dhy2 VALUES(sr[l_i].*)
    END IF
  END FOR
  LET l_bma01_t  = l_bma01
  
END FUNCTION

FUNCTION l_kk()
  DEFINE l_sql      STRING
  DEFINE l_tlf01    STRING
  DEFINE l_tlf905   LIKE tlf_file.tlf905
  DEFINE l_tlf01_o  LIKE tlf_file.tlf01
  DEFINE l_bmb031   LIKE bmb_file.bmb03
  DEFINE l_bmb061   LIKE bmb_file.bmb06
  DEFINE l_bmb032   LIKE bmb_file.bmb03
  DEFINE l_bmb062   LIKE bmb_file.bmb06
  DEFINE l_n        SMALLINT
  DEFINE l_tlf      RECORD
            tlf01   LIKE tlf_file.tlf01,
            tlf06   LIKE tlf_file.tlf06,
            tlf905  LIKE tlf_file.tlf905,
            tlf906  LIKE tlf_file.tlf906,
            tlf907  LIKE tlf_file.tlf907,
            tlf10a  LIKE tlf_file.tlf10,
            tlf21a  LIKE tlf_file.tlf21,
            tlf10b  LIKE tlf_file.tlf10,
            tlf21b  LIKE tlf_file.tlf21,
            tlf11   LIKE tlf_file.tlf11,
            tlf13   LIKE tlf_file.tlf13
         END RECORD
  DEFINE l_tlf_a    RECORD
            tlf01   LIKE tlf_file.tlf01,
            tlf06   LIKE tlf_file.tlf06,
            tlf905  LIKE tlf_file.tlf905,
            tlf906  LIKE tlf_file.tlf906,
            tlf907  LIKE tlf_file.tlf907,
            tlf10a  LIKE tlf_file.tlf10,
            tlf21a  LIKE tlf_file.tlf21,
            tlf10b  LIKE tlf_file.tlf10,
            tlf21b  LIKE tlf_file.tlf21,
            tlf11   LIKE tlf_file.tlf11,
            tlf13   LIKE tlf_file.tlf13
         END RECORD

  LET l_sql ="SELECT tlf01,tlf06,tlf905,tlf906,tlf907,tlf10,tlf21,tlf10,tlf21,tlf11,tlf13 FROM tlf_file  ",
             " WHERE tlf06 BETWEEN to_date('16/11/01','YY/MM/DD') ",
             " AND to_date('16/11/30','YY/MM/DD') ",
             " AND tlf13 IN ('aimt301','aimt302','axmt620','axmt650','aomt800','apmt150',",
             " 'asfi513','asfi514','asfi526','asfi527','asfi528','asfi529','asft6201',",
             " 'apmt1072','asfi511','asfi512','asft6231','aimt312','aimt313','aimt311','aimt303') ",
             --" AND (tlf01='AA0016A4GR' or tlf01='AA0021F2CR' or tlf01='AA0100F2DR' or tlf01='AB0135F2MR') ",
             " ORDER BY tlf01,tlf06"
  PREPARE l_kk_pre FROM l_sql
  DECLARE l_kk_cs CURSOR FOR l_kk_pre
  FOREACH l_kk_cs INTO l_tlf.*
    LET l_n = l_n + 1
    DISPLAY l_n
    IF l_tlf01_o != l_tlf.tlf01 OR cl_null(l_tlf01_o) THEN
       IF NOT cl_null(l_tlf_a.tlf01) THEN 
          INSERT INTO tlf_dhy VALUES(l_tlf_a.*)
       END IF
       LET l_tlf_a.* = l_tlf.*
       LET l_tlf_a.tlf06='16/12/31'
       LET l_tlf_a.tlf905='总计'
       LET l_tlf_a.tlf906=0
       LET l_tlf_a.tlf907=0
       LET l_tlf_a.tlf10a=0
       LET l_tlf_a.tlf10b=0
       LET l_tlf_a.tlf21a=0
       LET l_tlf_a.tlf21b=0
       LET l_tlf_a.tlf13='总计'
    END IF
    LET l_tlf905 = l_tlf.tlf905
    IF l_tlf905[1,3] ='PRG' AND l_tlf.tlf13 = 'asft6201' THEN 
       CONTINUE FOREACH
    END IF
    LET l_tlf.tlf21a = 0
    LET l_tlf.tlf21b = 0
    IF l_tlf.tlf13 = 'apmt150'  THEN
       SELECT rvv38 INTO l_tlf.tlf21a FROM rvv_file 
          WHERE rvv01 = l_tlf.tlf905 AND rvv02 = l_tlf.tlf906
    END IF
    IF l_tlf.tlf13 = 'axmt620'  THEN
       SELECT ogb13 INTO l_tlf.tlf21b FROM ogb_file 
          WHERE ogb01 = l_tlf.tlf905 AND ogb03 = l_tlf.tlf906
    END IF
    LET l_tlf.tlf10a = l_tlf.tlf10a * l_tlf.tlf907
    LET l_tlf.tlf10b = l_tlf.tlf10b * l_tlf.tlf907
    IF l_tlf.tlf907 = '-1' THEN 
       LET l_tlf.tlf10a = 0 
       LET l_tlf.tlf21a = 0
    ELSE
       LET l_tlf.tlf10b = 0 
       LET l_tlf.tlf21b = 0
    END IF
    LET l_tlf01 = l_tlf.tlf01
    IF l_tlf01.getIndexOf('-',1) THEN
       LET l_sql ="SELECT bmb03,bmb06/bmb07 FROM bmb_file WHERE bmb01='",l_tlf.tlf01 CLIPPED,"' ",
                  " AND bmb04<=to_date('2017/03/18','yyyy/mm/dd') ",
                  " AND (bmb05 is null or bmb05 >=to_date('2017/03/18','yyyy/mm/dd') )"
       PREPARE l_kk_pre2 FROM l_sql
       DECLARE l_kk_cs2 CURSOR FOR l_kk_pre2
       FOREACH l_kk_cs2 INTO l_bmb031,l_bmb061
          #LET l_tlf01_bak = l_tlf.tlf01
          LET l_tlf.tlf01 = l_bmb031
          LET l_tlf.tlf10a = l_tlf.tlf10a * l_bmb061
          LET l_tlf.tlf10b = l_tlf.tlf10a * l_bmb061
          LET l_tlf01 = l_tlf.tlf01
          IF l_tlf01.getIndexOf('-',1) THEN
             LET l_sql ="SELECT bmb03,bmb06/bmb07 FROM bmb_file WHERE bmb01='",l_tlf01 CLIPPED,"' ",
                        " AND bmb04<=to_date('2017/03/18','yyyy/mm/dd') ",
                        " AND (bmb05 is null or bmb05 >=to_date('2017/03/18','yyyy/mm/dd') )"
             PREPARE l_kk_pre3 FROM l_sql
             DECLARE l_kk_cs3 CURSOR FOR l_kk_pre3
             FOREACH l_kk_cs3 INTO l_bmb032,l_bmb062               
               LET l_tlf.tlf01 = l_bmb032
               LET l_tlf.tlf10a = l_tlf.tlf10a * l_bmb062
               LET l_tlf.tlf10b = l_tlf.tlf10a * l_bmb062
               LET l_tlf_a.tlf10a = l_tlf_a.tlf10a + l_tlf.tlf10a
               LET l_tlf_a.tlf21a = l_tlf_a.tlf21a + (l_tlf.tlf10a * l_tlf.tlf21a)
               LET l_tlf_a.tlf10b = l_tlf_a.tlf10b + l_tlf.tlf10b
               LET l_tlf_a.tlf21b = l_tlf_a.tlf21b + (l_tlf.tlf10b * l_tlf.tlf21b)
               INSERT INTO tlf_dhy VALUES(l_tlf.*)               
             END FOREACH
         ELSE
             LET l_tlf_a.tlf10a = l_tlf_a.tlf10a + l_tlf.tlf10a
             LET l_tlf_a.tlf21a = l_tlf_a.tlf21a + (l_tlf.tlf10a * l_tlf.tlf21a)
             LET l_tlf_a.tlf10b = l_tlf_a.tlf10b + l_tlf.tlf10b
             LET l_tlf_a.tlf21b = l_tlf_a.tlf21b + (l_tlf.tlf10b * l_tlf.tlf21b)
             INSERT INTO tlf_dhy VALUES(l_tlf.*)             
         END IF
         #LET l_tlf.tlf01 = l_tlf01_bak
       END FOREACH       
    ELSE
       LET l_tlf_a.tlf10a = l_tlf_a.tlf10a + l_tlf.tlf10a
       LET l_tlf_a.tlf21a = l_tlf_a.tlf21a + (l_tlf.tlf10a * l_tlf.tlf21a)
       LET l_tlf_a.tlf10b = l_tlf_a.tlf10b + l_tlf.tlf10b
       LET l_tlf_a.tlf21b = l_tlf_a.tlf21b + (l_tlf.tlf10b * l_tlf.tlf21b)
       INSERT INTO tlf_dhy VALUES(l_tlf.*)
    END IF    
    LET l_tlf01_o = l_tlf.tlf01
  END FOREACH
  
END FUNCTION

FUNCTION l_ll()
   DEFINE l_sql      STRING
   DEFINE l_cnt      SMALLINT
   DEFINE l_ecu02    LIKE ecu_file.ecu02
   DEFINE l_ecb03    LIKE ecb_file.ecb03
   DEFINE l_ecb06    LIKE ecb_file.ecb06
   DEFINE l_mm       SMALLINT
   
   DEFINE sr  RECORD
      ecb01        LIKE ecb_file.ecb01,
      ecb06        LIKE ecb_file.ecb06,
      num          LIKE bmb_file.bmb06
   END RECORD

   LET l_mm = 1
   LET l_sql = "SELECT tc_data01,tc_data02,tc_data09 FROM tc_data_file where tc_data04='2016' and tc_data05='12' "
        
   PREPARE l_ll_pre FROM l_sql
   DECLARE l_ll_cs CURSOR FOR l_ll_pre
   FOREACH l_ll_cs INTO sr.*
      DISPLAY l_mm
      LET l_mm =l_mm + 1
      SELECT COUNT(*) INTO l_cnt FROM ecu_file,ecb_file WHERE ecu01=ecb01 AND ecu02=ecb02 
        AND ecb01=sr.ecb01 AND ecb06=sr.ecb06
      IF l_cnt = 0 THEN 
         CONTINUE FOREACH
      END IF
      IF l_cnt = 1 THEN
         SELECT ecu02,ecb03 INTO l_ecu02,l_ecb03 FROM ecb_file,ecu_file WHERE ecu01=ecb01 AND ecu02=ecb02
            AND ecb01=sr.ecb01 AND ecb06=sr.ecb06
      END IF
      IF l_cnt > 1 THEN
         LET l_sql = "SELECT ecu02 FROM ecu_file,ecb_file WHERE ecu01=ecb01 AND ecu02=ecb02 ",
             " AND ecu01='",sr.ecb01,"' AND ecb06='",sr.ecb06,"' ORDER BY ecu02 DESC"
         PREPARE l_ll1_pre FROM l_sql
         DECLARE l_ll1_cs CURSOR FOR l_ll1_pre
         FOREACH l_ll1_cs INTO l_ecu02
            SELECT ecu02,ecb03 INTO l_ecu02,l_ecb03 FROM ecb_file,ecu_file WHERE ecb01=ecu01 
              AND ecb01=sr.ecb01 AND ecb06=sr.ecb06 AND ecu02=l_ecu02
            EXIT FOREACH
         END FOREACH
      END IF
      LET l_sql = "SELECT ecb06 FROM ecb_file,ecu_file WHERE ecu01=ecb01 AND ecu02=ecb02 ",
      " AND ecb01='",sr.ecb01,"' and ecu02='",l_ecu02,"' and ecb03 <=",l_ecb03," order by ecb03"      
      PREPARE l_ll2_pre FROM l_sql
      DECLARE l_ll2_cs CURSOR FOR l_ll2_pre
      FOREACH l_ll2_cs INTO l_ecb06
         CALL ll_bom(sr.ecb01,sr.ecb01,l_ecb06,sr.num)
      END FOREACH
   END FOREACH
END FUNCTION
FUNCTION ll_bom(l_bma01,l_bmb01,l_bmb09,l_num)
   DEFINE l_bma01       LIKE bma_file.bma01
   DEFINE l_bmb01       LIKE bmb_file.bmb01
   DEFINE l_bmb09       LIKE bmb_file.bmb09
   DEFINE l_num         LIKE bmb_file.bmb06
   DEFINE l_num2        LIKE bmb_file.bmb06
   DEFINE l_n           SMALLINT
   DEFINE li            SMALLINT
   DEFINE l_bmb03       STRING
   DEFINE l_sql         STRING
   DEFINE l_cnt         SMALLINT
   
   DEFINE l_rec      RECORD
             bmb01      LIKE bmb_file.bmb01,
             bmb03      LIKE bmb_file.bmb03,
             bmb06      LIKE bmb_file.bmb06,
             ima25      LIKE ima_file.ima25,
             ima63      LIKE ima_file.ima63,
             ima63_fac  LIKE ima_file.ima63_fac,
             rec01      CHAR(40),
             rec02      CHAR(40)
          END RECORD
   DEFINE sm  DYNAMIC ARRAY OF RECORD
             bmb03         LIKE bmb_file.bmb03,
             bmb06         LIKE bmb_file.bmb06
          END RECORD 

   LET l_n = 1
   LET li = 1
   IF NOT cl_null(l_bmb09) THEN 
      SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01=l_bmb01 AND bmb09=l_bmb09 
         AND bmb04<=g_today AND (bmb05 IS NULL OR bmb05 >=g_today)
      IF l_cnt = 0 THEN RETURN END IF      
   END IF

   IF NOT cl_null(l_bmb09) THEN
      LET l_sql = "SELECT bmb03,bmb06/bmb07 FROM bmb_file WHERE bmb01='",l_bmb01,"' AND bmb09='",l_bmb09,"'",
                  " AND bmb04<=to_date('2017/03/18','yyyy/mm/dd') and (bmb05 is null or bmb05 >=to_date('2017/03/18','yyyy/mm/dd') )"       
   ELSE
      LET l_sql = "SELECT bmb03,bmb06/bmb07 FROM bmb_file WHERE bmb01='",l_bmb01,"' AND bmb04<=to_date('2017/03/18','yyyy/mm/dd') ",
                  " and (bmb05 is null or bmb05 >=to_date('2017/03/18','yyyy/mm/dd') )"       
   END IF
   PREPARE l_ll3_pre FROM l_sql
   DECLARE l_ll3_cs CURSOR FOR l_ll3_pre
   FOREACH l_ll3_cs INTO sm[l_n].bmb03,sm[l_n].bmb06
     LET l_n = l_n + 1
   END FOREACH
   LET l_n = l_n - 1
   FOR li = 1 TO l_n
      LET l_bmb03 = sm[li].bmb03
      IF l_bmb03.getIndexOf('-',1) THEN
         LET l_num2 = l_num * sm[li].bmb06
         CALL ll_bom(l_bma01,sm[li].bmb03,'',l_num2)
      ELSE
        LET l_rec.bmb01 = l_bma01
        LET l_rec.bmb03 = sm[li].bmb03
        LET l_rec.bmb06 = l_num * sm[li].bmb06
        SELECT ima25,ima63,ima63_fac INTO l_rec.ima25,l_rec.ima63,l_rec.ima63_fac
           FROM ima_file WHERE ima01=l_rec.bmb03
        IF cl_null(l_rec.ima63_fac) THEN LET l_rec.ima63_fac = 1 END IF
        LET l_rec.rec01='2016'
        LET l_rec.rec02='12'
        INSERT INTO rec_dhy VALUES(l_rec.*)
      END IF
   END FOR
   
END FUNCTION

#线边仓库存转换成在制资料
FUNCTION l_ll_imk()
  DEFINE l_sql    STRING
  DEFINE l_n      SMALLINT
      DEFINE l_rec      RECORD
             bmb01      LIKE bmb_file.bmb01,
             bmb03      LIKE bmb_file.bmb03,
             bmb06      LIKE bmb_file.bmb06,
             ima25      LIKE ima_file.ima25,
             ima63      LIKE ima_file.ima63,
             ima63_fac  LIKE ima_file.ima63_fac,
             rec01      CHAR(40),
             rec02      CHAR(40)
          END RECORD

   LET l_n = 0
   LET l_sql = "SELECT IMK01,SUM(imk09) FROM imk_file WHERE imk06='12'  ",
               "  AND imk02 NOT  IN (SELECT jce02 FROM jce_file) ",
               " AND imk02 IN (SELECT imd01 FROM imd_file WHERE imd10='W') ",
               " GROUP BY imk01 HAVING SUM(imk09) > 0 "  
   PREPARE l_llimk_pre FROM l_sql
   DECLARE l_llimk_cs CURSOR FOR l_llimk_pre
   FOREACH l_llimk_cs INTO l_rec.bmb03,l_rec.bmb06
      LET l_n = l_n + 1
      DISPLAY l_n
      LET l_rec.bmb01 = 'imk-12'
      SELECT ima25,ima63,ima63_fac INTO l_rec.ima25,l_rec.ima63,l_rec.ima63_fac
      FROM ima_file WHERE ima01=l_rec.bmb03
      LET l_rec.rec01 = '2016'
      LET l_rec.rec02 = '12'
      INSERT INTO rec_dhy VALUES(l_rec.*)
   END FOREACH
END FUNCTION

#中转仓库资料转换成原材料在制
#tc_data01:半成品料号 带-
#tc_data08:半成品中转仓剩余数量
FUNCTION l_ll_zzc()
  DEFINE l_n        SMALLINT
  DEFINE li         SMALLINT
  DEFINE l_bmb03    STRING
  DEFINE l_sql      STRING
  DEFINE l_bma01 LIKE bma_file.bma01

  DEFINE sm  DYNAMIC ARRAY OF RECORD           
             bmb03         LIKE bmb_file.bmb03,
             bmb06         LIKE bmb_file.bmb06
  END RECORD 
          
   LET l_n = 1
   #LET l_sql = "SELECT tc_data01,tc_data08 FROM tc_data_file" 
   LET l_sql = "SELECT bmb03,bmb06 FROM rec_dhy where rec02='12' and  bmb03 LIKE '%-%' "     
   PREPARE l_llzzc_pre FROM l_sql
   DECLARE l_llzzc_cs CURSOR FOR l_llzzc_pre
   FOREACH l_llzzc_cs INTO sm[l_n].bmb03,sm[l_n].bmb06
      LET l_n = l_n + 1
   END FOREACH
   LET l_n = l_n - 1
   FOR li = 1 TO l_n
      DISPLAY li
      LET l_bmb03 = sm[li].bmb03
      IF l_bmb03.getIndexOf('-',1) THEN
         #LET l_bma01 =sm[li].bmb03 CLIPPED,'-zzc12' 
         LET l_bma01 = 'imk-12'
         CALL ll_bom(l_bma01,sm[li].bmb03,'',sm[li].bmb06)
      END IF
   END FOR
   
END FUNCTION

FUNCTION l_mm()
  DEFINE l_sql      STRING
  DEFINE l_tlf905   LIKE tlf_file.tlf905
  DEFINE l_imd10    LIKE imd_file.imd10
  DEFINE l_tlf902   LIKE tlf_file.tlf902
  DEFINE l_tlf01    LIKE tlf_file.tlf01
  DEFINE l_bmb031   LIKE bmb_file.bmb03
  DEFINE l_bmb061   LIKE bmb_file.bmb06
  DEFINE l_bmb032   LIKE bmb_file.bmb03
  DEFINE l_sfb02    LIKE sfb_file.sfb02
  DEFINE l_bmb062   LIKE bmb_file.bmb06
  DEFINE l_n        SMALLINT
  DEFINE l_msg      LIKE ima_file.ima01
  DEFINE l_tlf      RECORD
            ccc02   LIKE ccc_file.ccc02,
            ccc03   LIKE ccc_file.ccc03,
            tlf01   LIKE tlf_file.tlf01,
            tlf06   LIKE tlf_file.tlf06,
            tlf905  LIKE tlf_file.tlf905,
            tlf906  LIKE tlf_file.tlf906,
            tlf907  LIKE tlf_file.tlf907,
            tlf10a  LIKE tlf_file.tlf10,
            tlf21a  LIKE tlf_file.tlf21,
            tlf10b  LIKE tlf_file.tlf10,
            tlf21b  LIKE tlf_file.tlf21,
            tlf11   LIKE tlf_file.tlf11,
            tlf13   LIKE tlf_file.tlf13,
            tlf62   LIKE tlf_file.tlf62,
            tlf14   LIKE tlf_file.tlf14,
            tlf12   LIKE tlf_file.tlf12
         END RECORD


  LET l_sql ="SELECT '2016','12',tlf01,tlf06,tlf905,tlf906,tlf907,tlf10,tlf21,tlf10,tlf21,tlf11,tlf13,tlf62,tlf14,tlf12,tlf902 FROM tlf_file  ",
             " WHERE tlf06 BETWEEN to_date('16/12/01','YY/MM/DD') ",
             " AND to_date('16/12/31','YY/MM/DD') ",
             " AND tlf13 IN ('aimt301','aimt302','aimt303','axmt620','axmt650','aomt800','apmt150',",
             " 'asfi511','asfi512','asfi513','asfi514','asfi526','asfi527','asfi528','asfi529','asft6201',",
             " 'apmt1072','asft6231','aimt311','aimt312') AND tlf01 NOT LIKE '%-%' AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ",
             --" AND tlf01='E.DD.0024R' ",
             " ORDER BY tlf01,tlf06"
  PREPARE l_mm_pre FROM l_sql
  DECLARE l_mm_cs CURSOR FOR l_mm_pre
  FOREACH l_mm_cs INTO l_tlf.*,l_tlf902
    LET l_n = l_n + 1
    LET l_msg = 'a',l_n    
    DISPLAY l_msg

    LET l_tlf.ccc02 = '2016'
    LET l_tlf.ccc03 = '12'
    LET l_tlf905 = l_tlf.tlf905
    IF l_tlf905[1,3] ='PRG' AND l_tlf.tlf13 = 'asft6201' THEN 
       CONTINUE FOREACH
    END IF
    IF l_tlf.tlf13 = 'asfi511' OR l_tlf.tlf13 = 'asfi512' OR l_tlf.tlf13 = 'asfi513' OR l_tlf.tlf13 = 'asfi514' OR
       l_tlf.tlf13 = 'asfi526' OR l_tlf.tlf13 = 'asfi527' OR l_tlf.tlf13 = 'asfi528' OR l_tlf.tlf13 = 'asfi529' THEN 
       SELECT imd10 INTO l_imd10 FROM imd_file WHERE imd01=l_tlf902
       IF l_imd10 !='S'  THEN
          IF l_tlf902 != '100' THEN 
             CONTINUE FOREACH
          END IF
       END IF
    END IF
    IF l_tlf.tlf13 = 'asft6201' OR  l_tlf.tlf13 = 'asft6231' THEN
        SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01=l_tlf.tlf62
        LET l_tlf.tlf62 = l_sfb02
    ELSE
       LET l_tlf.tlf62 = ''
    END IF
    LET l_tlf.tlf21a = 0
    LET l_tlf.tlf21b = 0
    IF l_tlf.tlf13 = 'apmt150' OR l_tlf.tlf13 = 'apmt1072' THEN
       SELECT rvv38 INTO l_tlf.tlf21a FROM rvv_file 
          WHERE rvv01 = l_tlf.tlf905 AND rvv02 = l_tlf.tlf906
    END IF
    IF l_tlf.tlf13 = 'axmt620'  THEN
       SELECT ogb13 INTO l_tlf.tlf21b FROM ogb_file 
          WHERE ogb01 = l_tlf.tlf905 AND ogb03 = l_tlf.tlf906
    END IF
    IF l_tlf.tlf13 = 'aimt311' OR l_tlf.tlf13 = 'aimt312'  THEN      
       IF l_tlf902 ='100' THEN        
       ELSE
         CONTINUE FOREACH 
       END IF       
    END IF
    
    LET l_tlf.tlf10a = l_tlf.tlf10a * l_tlf.tlf907
    LET l_tlf.tlf10b = l_tlf.tlf10b * l_tlf.tlf907
    IF l_tlf.tlf907 = '-1' THEN 
       LET l_tlf.tlf10a = 0 
       LET l_tlf.tlf21a = 0
    ELSE
       LET l_tlf.tlf10b = 0 
       LET l_tlf.tlf21b = 0
    END IF    
    INSERT INTO tlf_dhy VALUES(l_tlf.*)
   
  END FOREACH
  CALL l_mm_1()
  CALL l_mm_2()
  CALL l_mm2()
  
  
END FUNCTION

FUNCTION l_mm_1()
  DEFINE l_imn04    LIKE imn_file.imn04
  DEFINE l_imn15    LIKE imn_file.imn15
  DEFINE l_sql      STRING
  DEFINE l_imd10_r  LIKE imd_file.imd10
  DEFINE l_imd10_c  LIKE imd_file.imd10
  DEFINE l_n        SMALLINT
  DEFINE l_msg      LIKE ima_file.ima01
  DEFINE l_tlf      RECORD
            ccc02   LIKE ccc_file.ccc02,     #年度
            ccc03   LIKE ccc_file.ccc03,     #期别 
            tlf01   LIKE tlf_file.tlf01,     #料号
            tlf06   LIKE tlf_file.tlf06,     #日期
            tlf905  LIKE tlf_file.tlf905,    #单据编号
            tlf906  LIKE tlf_file.tlf906,    #单据项次
            tlf907  LIKE tlf_file.tlf907,    #异动出入库指令
            tlf10a  LIKE tlf_file.tlf10,     #入库量
            tlf21a  LIKE tlf_file.tlf21,     #入库金额
            tlf10b  LIKE tlf_file.tlf10,     #出库量
            tlf21b  LIKE tlf_file.tlf21,     #出库金额
            tlf11   LIKE tlf_file.tlf11,     #异动单位
            tlf13   LIKE tlf_file.tlf13,     #异动代号指令
            tlf62   LIKE tlf_file.tlf62,
            tlf14   LIKE tlf_file.tlf14,
            tlf12   LIKE tlf_file.tlf12
         END RECORD

   LET l_n = 0
   LET l_sql = " SELECT '2016','12',imn03,imm17,imn01,imn02,'',imn22,0,imn22,0,imn20,'','','','1',imn04,imn15",
               " FROM imn_file,imm_file ",
               " WHERE imm01=imn01 AND imm17 BETWEEN to_date('16/12/01','YY/MM/DD')",
               " AND to_date('16/12/31','YY/MM/DD') AND imm03='Y' ",
               --" AND imn03='E.DD.0024R' ",
               " AND imn03 NOT LIKE '%-%' AND imn04 NOT IN (SELECT jce02 FROM jce_file)"
  PREPARE l_mm1_pre FROM l_sql
  DECLARE l_mm1_cs CURSOR FOR l_mm1_pre
  FOREACH l_mm1_cs INTO l_tlf.*,l_imn04,l_imn15
    LET l_n = l_n + 1
    LET l_msg = 'b',l_n    
    DISPLAY l_msg
    SELECT imd10 INTO l_imd10_r FROM imd_file WHERE imd01=l_imn15
    SELECT imd10 INTO l_imd10_c FROM imd_file WHERE imd01=l_imn04
    IF l_imd10_r = l_imd10_c THEN
       IF l_imn04 != '100' THEN 
          CONTINUE FOREACH
       END IF
    END IF
    IF l_imd10_c = 'S' OR l_imn04 = '100' THEN #表示调拨出
       LET l_tlf.tlf10b = l_tlf.tlf10b * -1
       LET l_tlf.tlf907 = '-1'
       LET l_tlf.tlf13  = 'aimt323'
       LET l_tlf.tlf10a = 0
    ELSE
    #表示调拨入
       LET l_tlf.tlf907 = '1'
       LET l_tlf.tlf13  = 'aimt324'
       LET l_tlf.tlf10b = 0
    END IF
    INSERT INTO tlf_dhy VALUES(l_tlf.*)
  END FOREACH
  
END FUNCTION

#客制csft511的调拨处理
FUNCTION l_mm_2()
  DEFINE l_imn04    LIKE imn_file.imn04
  DEFINE l_imn15    LIKE imn_file.imn15
  DEFINE l_sql      STRING
  DEFINE l_imd10_r  LIKE imd_file.imd10
  DEFINE l_imd10_c  LIKE imd_file.imd10
  DEFINE l_n        SMALLINT
  DEFINE l_msg      LIKE ima_file.ima01
  DEFINE l_tlf      RECORD
            ccc02   LIKE ccc_file.ccc02,     #年度
            ccc03   LIKE ccc_file.ccc03,     #期别 
            tlf01   LIKE tlf_file.tlf01,     #料号
            tlf06   LIKE tlf_file.tlf06,     #日期
            tlf905  LIKE tlf_file.tlf905,    #单据编号
            tlf906  LIKE tlf_file.tlf906,    #单据项次
            tlf907  LIKE tlf_file.tlf907,    #异动出入库指令
            tlf10a  LIKE tlf_file.tlf10,     #入库量
            tlf21a  LIKE tlf_file.tlf21,     #入库金额
            tlf10b  LIKE tlf_file.tlf10,     #出库量
            tlf21b  LIKE tlf_file.tlf21,     #出库金额
            tlf11   LIKE tlf_file.tlf11,     #异动单位
            tlf13   LIKE tlf_file.tlf13,     #异动代号指令
            tlf62   LIKE tlf_file.tlf62,
            tlf14   LIKE tlf_file.tlf14,
            tlf12   LIKE tlf_file.tlf12
         END RECORD

   LET l_n = 0
   LET l_sql = " SELECT '2016','12',tc_imq05,tc_immud13,tc_imq01,tc_imq02,'',tc_imq14,0,tc_imq14,0,tc_imq09,'','','','1',tc_imq06,tc_imq10",
               " FROM tc_imm_file,tc_imq_file ",
               " WHERE tc_imm01=tc_imq01 AND tc_immud13 BETWEEN to_date('16/12/01','YY/MM/DD')",
               " AND to_date('16/12/31','YY/MM/DD') AND tc_imm03='Y'",
               --" AND imn03='E.DD.0024R' ",
               " AND tc_imq05 NOT LIKE '%-%' AND tc_imq06 NOT IN (SELECT jce02 FROM jce_file) "
  PREPARE l_mm4_pre FROM l_sql
  DECLARE l_mm4_cs CURSOR FOR l_mm4_pre
  FOREACH l_mm4_cs INTO l_tlf.*,l_imn04,l_imn15
    LET l_n = l_n + 1
    LET l_msg = 'b',l_n
    DISPLAY l_msg
    SELECT imd10 INTO l_imd10_r FROM imd_file WHERE imd01=l_imn15
    SELECT imd10 INTO l_imd10_c FROM imd_file WHERE imd01=l_imn04
    IF l_imd10_r = l_imd10_c THEN CONTINUE FOREACH END IF
    IF l_imd10_c = 'S' THEN #表示调拨出
        LET l_tlf.tlf10b = l_tlf.tlf10b * -1
        LET l_tlf.tlf907 = '-1'
        LET l_tlf.tlf13  = 'csft511'
        LET l_tlf.tlf10a = 0
     ELSE
     #表示调拨入
        LET l_tlf.tlf907 = '1'
        LET l_tlf.tlf13  = 'csft512'
        LET l_tlf.tlf10b = 0
     END IF
     INSERT INTO tlf_dhy VALUES(l_tlf.*)
  END FOREACH
  
END FUNCTION


#期初期末资料汇总
FUNCTION l_mm2()
 DEFINE l_tlh01    LIKE tlf_file.tlf01
 DEFINE l_n        SMALLINT
 DEFINE l_cnt      SMALLINT
 DEFINE l_fac      LIKE ima_file.ima63_fac
 DEFINE l_msg      LIKE ima_file.ima01
 DEFINE l_sql      STRING
 DEFINE l_tlf      RECORD
            ccc02   LIKE ccc_file.ccc02,     #年度
            ccc03   LIKE ccc_file.ccc03,     #期别 
            tlf01   LIKE tlf_file.tlf01,     #料号
            tlf06   LIKE tlf_file.tlf06,     #日期
            tlf905  LIKE tlf_file.tlf905,    #单据编号
            tlf906  LIKE tlf_file.tlf906,    #单据项次
            tlf907  LIKE tlf_file.tlf907,    #异动出入库指令
            tlf10a  LIKE tlf_file.tlf10,     #入库量
            tlf21a  LIKE tlf_file.tlf21,     #入库金额
            tlf10b  LIKE tlf_file.tlf10,     #出库量
            tlf21b  LIKE tlf_file.tlf21,     #出库金额
            tlf11   LIKE tlf_file.tlf11,     #异动单位
            tlf13   LIKE tlf_file.tlf13,     #异动代号指令
            tlf62   LIKE tlf_file.tlf62,
            tlf14   LIKE tlf_file.tlf14,
            tlf12   LIKE tlf_file.tlf12
         END RECORD
   DEFINE l_tlh      RECORD
            ccc02   LIKE ccc_file.ccc02,     #年度
            ccc03   LIKE ccc_file.ccc03,     #期别 
            tlh01   LIKE tlf_file.tlf01,     #料号
            tlh02   LIKE ima_file.ima25,     #单位
            tlh03   LIKE ima_file.ima63_fac, #转换率
            tlh04   LIKE ccc_file.ccc11,     #期初
            tlh05   LIKE ccc_file.ccc11,     #采购入库量
            tlh06   LIKE ccc_file.ccc12,     #采购入库金额
            tlh07   LIKE ccc_file.ccc11,     #返工入库
            tlh08   LIKE ccc_file.ccc11,     #工单入库
            tlh09   LIKE ccc_file.ccc11,     #产线退料入库
            tlh10   LIKE ccc_file.ccc11,     #产线出库
            tlh11   LIKE ccc_file.ccc11,     #杂收入库
            tlh12   LIKE ccc_file.ccc11,     #杂发出库
            tlh13   LIKE ccc_file.ccc11,     #成品出货
            tlh14   LIKE ccc_file.ccc11      #期末结存
         END RECORD
         
  #LET l_sql = "SELECT distinct tlf01 FROM tlf_dhy WHERE ccc03='11' "," UNION ",
  #            "SELECT DISTINCT imk01 FROM imk_file WHERE imk06='10' AND imk01 NOT LIKE '%-%' ",
  #            "AND imk02 NOT IN (SELECT jce02 FROM jce_file) AND imk02 NOT IN (SELECT imd01 FROM imd_file WHERE imd10 = 'W')"
  LET l_sql = "SELECT distinct tlf01 FROM tlf_dhy WHERE ccc03='12' UNION ",
              "SELECT DISTINCT tlh01 FROM tlh_dhy WHERE ccc03='11' "
  PREPARE l_mm2_pre FROM l_sql
  DECLARE l_mm2_cs CURSOR FOR l_mm2_pre
  FOREACH l_mm2_cs INTO l_tlh01
      #取期初库存
      LET l_n = l_n + 1
      LET l_msg = 'c',l_n    
      DISPLAY l_msg
      
      INITIALIZE l_tlh.* TO NULL
      #SELECT SUM(imk09) INTO l_tlh.tlh04 FROM imk_file WHERE imk06='10'
      #    AND imk02 NOT IN (SELECT jce02 FROM jce_file) 
      #    AND imk02 NOT IN (SELECT imd01 FROM imd_file WHERE imd10 = 'W')
      #    AND imk01 = l_tlh01
      SELECT tlh14 INTO l_tlh.tlh04 FROM tlh_dhy WHERE ccc03='11' AND tlh01 = l_tlh01
      IF cl_null(l_tlh.tlh04) THEN LET l_tlh.tlh04 = 0 END IF
      SELECT ima25,ima63_fac INTO l_tlh.tlh02,l_tlh.tlh03 FROM ima_file WHERE ima01=l_tlh01
      LET l_tlh.tlh05 = 0 
      LET l_tlh.tlh06 = 0
      LET l_tlh.tlh07 = 0
      LET l_tlh.tlh08 = 0
      LET l_tlh.tlh09 = 0
      LET l_tlh.tlh10 = 0
      LET l_tlh.tlh11 = 0
      LET l_tlh.tlh12 = 0
      LET l_tlh.tlh13 = 0
      LET l_tlh.tlh14 = 0
      LET l_tlh.tlh01 = l_tlh01
      LET l_sql = "SELECT * FROM tlf_dhy WHERE ccc03='12' and tlf01='",l_tlh01,"'"
      PREPARE l_mm3_pre FROM l_sql
      DECLARE l_mm3_cs CURSOR FOR l_mm3_pre
      FOREACH l_mm3_cs INTO l_tlf.*
         IF cl_null(l_tlf.tlf12) THEN LET l_tlf.tlf12 = 1 END IF
         IF l_tlf.tlf12 = 0 THEN LET l_tlf.tlf12 = 1 END IF
         IF l_tlf.tlf13 = 'apmt150' THEN
            LET l_tlh.tlh05=l_tlh.tlh05 + (l_tlf.tlf10a * l_tlf.tlf12)
            LET l_tlh.tlh06=l_tlh.tlh06 + (l_tlf.tlf10a * l_tlf.tlf21a) 
         END IF
         
         IF l_tlf.tlf13 = 'apmt1072' THEN
            LET l_tlh.tlh05=l_tlh.tlh05 + (l_tlf.tlf10b * l_tlf.tlf12)
            LET l_tlh.tlh06=l_tlh.tlh06 - l_tlf.tlf21a
         END IF
         
         IF l_tlf.tlf13 = 'asft6231' OR l_tlf.tlf13 = 'asft6201' THEN
            IF l_tlf.tlf62 = '5' THEN
               LET l_tlh.tlh07 = l_tlh.tlh07 + (l_tlf.tlf10a * l_tlf.tlf12)
            ELSE
               LET l_tlh.tlh08 = l_tlh.tlh08 + (l_tlf.tlf10a * l_tlf.tlf12)
            END IF
         END IF
         
         IF l_tlf.tlf13 = 'aimt324' THEN
            LET l_tlh.tlh09=l_tlh.tlh09 + (l_tlf.tlf10a * l_tlf.tlf12) 
         END IF
         IF l_tlf.tlf13 = 'csft512' THEN
            LET l_tlh.tlh09=l_tlh.tlh09 + (l_tlf.tlf10a * l_tlf.tlf12) 
         END IF
         IF l_tlf.tlf13 = 'asfi528' THEN
            LET l_tlh.tlh09=l_tlh.tlh09 + (l_tlf.tlf10a * l_tlf.tlf12)           
         END IF
         IF l_tlf.tlf13 = 'asfi526' THEN
            LET l_tlh.tlh09=l_tlh.tlh09 + (l_tlf.tlf10a * l_tlf.tlf12)            
         END IF
         
         IF l_tlf.tlf13 = 'aimt323' OR l_tlf.tlf13 = 'asfi511' OR l_tlf.tlf13 = 'asfi513' OR l_tlf.tlf13 = 'asfi512' THEN
            LET l_tlh.tlh10=l_tlh.tlh10 + (l_tlf.tlf10b * l_tlf.tlf12)            
         END IF
         
         IF l_tlf.tlf13 = 'csft511' THEN
            LET l_tlh.tlh10=l_tlh.tlh10 + (l_tlf.tlf10b * l_tlf.tlf12)            
         END IF
         
         IF l_tlf.tlf13 = 'aimt302' OR l_tlf.tlf13 = 'aimt312' THEN
            LET l_tlh.tlh11=l_tlh.tlh11 + (l_tlf.tlf10a * l_tlf.tlf12)            
         END IF

         IF l_tlf.tlf13 = 'aimt301' OR l_tlf.tlf13 = 'aimt303' OR l_tlf.tlf13 = 'aimt311' THEN
            LET l_tlh.tlh12=l_tlh.tlh12 + (l_tlf.tlf10b * l_tlf.tlf12)            
         END IF

         IF l_tlf.tlf13 = 'axmt620' THEN
            LET l_tlh.tlh13=l_tlh.tlh13 + (l_tlf.tlf10b * l_tlf.tlf12)           
         END IF
         IF l_tlf.tlf13 = 'aomt800' THEN
            LET l_tlh.tlh13=l_tlh.tlh13 + (l_tlf.tlf10a * l_tlf.tlf12)          
         END IF  
     END FOREACH
     #LET l_tlh.tlh10 = l_tlh.tlh10 * -1
     #LET l_tlh.tlh12 = l_tlh.tlh12 * -1
     #LET l_tlh.tlh13 = l_tlh.tlh13 * -1
     LET l_tlh.tlh14 = l_tlh.tlh04 + l_tlh.tlh05 + l_tlh.tlh07 + l_tlh.tlh08 + l_tlh.tlh09 + l_tlh.tlh10 + l_tlh.tlh11 + l_tlh.tlh12 + l_tlh.tlh13
     LET l_tlh.ccc02 = '2016'
     LET l_tlh.ccc03 = '12'
     INSERT INTO tlh_dhy VALUES (l_tlh.*)
  END FOREACH
         
  
  
END FUNCTION

FUNCTION l_nn()
  DEFINE l_tc_data01    LIKE tc_data_file.tc_data01
  DEFINE l_oeaud02      LIKE oea_file.oeaud02
  DEFINE l_str          LIKE tc_data_file.tc_data02
  LET g_sql = "SELECT tc_data01 FROM tc_data_file WHERE tc_data02 IS NULL"
  PREPARE l_nn_pre FROM g_sql
  DECLARE l_nn_cs CURSOR FOR l_nn_pre
  FOREACH l_nn_cs INTO l_tc_data01
     LET l_str='光板成品'
     LET g_sql = "SELECT DISTINCT oeaud02 FROM oea_file,oeb_file ",
                 " WHERE oea01=oeb01 AND oeb04='",l_tc_data01 CLIPPED,"'"
     PREPARE l_nn1_pre FROM g_sql
     DECLARE l_nn1_cs CURSOR FOR l_nn1_pre
     FOREACH l_nn1_cs INTO l_oeaud02
       IF l_oeaud02 = 'Y' THEN 
          LET l_str='光板半成品'
          EXIT FOREACH
       END IF
     END FOREACH  
     UPDATE tc_data_file SET tc_data02 = l_str  WHERE tc_data01=l_tc_data01
  END FOREACH
END FUNCTION





