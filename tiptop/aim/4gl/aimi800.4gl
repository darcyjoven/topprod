# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimi800.4gl
# Descriptions...: 盤點標籤別維護作業
# Date & Author..: 93/04/13 By Apple
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520028 05/03/14 By ching add 單別檢查
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 將s_mfgslip處理段取消
# Modify.........: No.MOD-640393 06/04/12 By kim 修改標籤別時要check與(aoos010)單據編碼長度一致
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730117 07/03/30 By Judy 開啟無效功能
# Modify.........: No.MOD-830027 08/03/19 By Pengu 新增盤點標籤別時,會出現長度不符設定錯誤訊息
# Modify.........: No.MOD-860128 08/06/12 By claire 標籤別要於單據性質檔建檔否則警告
# Modify.........: No.MOD-850149 08/07/17 By liuxqa 錄入時，把流水號的default值改為十碼
# Modify.........: No.MOD-870171 08/07/14 By claire 語法修改
# Modify.........: No.FUN-8A0034 08/10/20 By jan 流水號依aza42的碼別長度設定
# Modify.........: No.FUN-8A0036 08/10/28 By jan 控管若單別不存在于asmi300，則警告到不可新增！
# Modify.........: No.MOD-920225 09/02/18 By claire 修改時若出現aim-200會造成LOOP
# Modify.........: No.MOD-930114 09/03/11 By shiwuying mark i800_cs()FUNCTION中INSERT INTO pib_file的程式段
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別產生方式
# Modify.........: No.TQC-970386 09/07/30 By sherry 無效資料不可以刪除    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pib               RECORD LIKE pib_file.*,
    g_pib_t             RECORD LIKE pib_file.*,
    g_pib_o             RECORD LIKE pib_file.*,
    g_pib01_t           LIKE pib_file.pib01,
    g_pib03_t           LIKE pib_file.pib03,
    g_wc,g_sql          STRING                  #No.FUN-580092 HCN
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #TQC-730117
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 
    INITIALIZE g_pib.* TO NULL
    INITIALIZE g_pib_t.* TO NULL
    INITIALIZE g_pib_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM pib_file WHERE pib01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i800_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 5 LET p_col = 10
 
    OPEN WINDOW i800_w AT p_row,p_col
         WITH FORM "aim/42f/aimi800" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    SELECT aza42 INTO g_aza.aza42 FROM aza_file  #No.FUN-8A0034
 
    CALL i800_q('q')
 
    WHILE TRUE
       LET g_action_choice=""
       CALL i800_menu()
       IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i800_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION i800_cs(p_code)
 DEFINE  p_code  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CLEAR FORM
    IF p_code != 'q' OR p_code IS NULL THEN 
       INITIALIZE g_pib.* TO NULL  #FUN-640213 add
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                         pib01,pib02,pib03,pib04,pib05,                     #FUN-930122 add pib05
                         pibuser,pibgrup,pibmodu,pibdate,pibacti
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pibuser', 'pibgrup') #FUN-980030
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    ELSE 
    #  #No.MOD-930114 start ------
    #  INSERT INTO pib_file(pib01,pib02,pib03,pib04,pibacti,pibuser,  #No.MOD-470041
    #                       pibgrup,pibmodu,pibdate)
    #       VALUES('STK','現有庫存盤點標籤別(系統自動產生)',
    #              '000000','1','Y',g_user,g_grup,' ',g_today)
    #  INSERT INTO pib_file(pib01,pib02,pib03,pib04,pibacti,pibuser,  #No.MOD-470041
    #                       pibgrup,pibmodu,pibdate)
    #       VALUES('WIP','在製工單盤點標籤別(系統自動產生)',
    #              '000000','1','Y',g_user,g_grup,' ',g_today)
    #No.MOD-930114 end -------
       LET g_wc = ' 1=1'
    END IF
    LET g_sql="SELECT pib01 FROM pib_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, 
              " ORDER BY pib01"
    PREPARE i800_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i800_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i800_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pib_file WHERE ",g_wc CLIPPED
    PREPARE i800_precount FROM g_sql
    DECLARE i800_count CURSOR FOR i800_precount
END FUNCTION
 
FUNCTION i800_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i800_a()
           END IF
        ON ACTION query 
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i800_q('Q')
           END IF
        ON ACTION modify 
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i800_u()
           END IF
#TQC-730117.....begin                                                           
        ON ACTION invalid                                                       
           LET g_action_choice="invalid"                                        
           IF cl_chk_act_auth() THEN                                            
              CALL i800_x()                                                     
           END IF                                                               
#TQC-730117.....end
        ON ACTION delete 
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
                CALL i800_r()
           END IF
        ON ACTION help 
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION first 
           CALL i800_fetch('F')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
                              
        ON ACTION previous
           CALL i800_fetch('P')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
                              
        ON ACTION jump 
           CALL i800_fetch('/')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
                                
        ON ACTION next
           CALL i800_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
                                
        ON ACTION last 
           CALL i800_fetch('L')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
        COMMAND KEY(CONTROL-G)
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
           LET g_action_choice = "exit"
           CONTINUE MENU
       
        #No.FUN-680046-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
               IF cl_chk_act_auth() THEN
                  IF g_pib.pib01 IS NOT NULL THEN
                     LET g_doc.column1 = "pib01"
                     LET g_doc.value1 = g_pib.pib01
                     CALL cl_doc()
                  END IF
                END IF
        #No.FUN-680046-------add--------end----       
        
        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i800_cs
END FUNCTION
 
 
FUNCTION i800_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_pib.* LIKE pib_file.*
    LET g_pib01_t = NULL
    LET g_pib03_t = NULL
    #No.FUN-8A0034--BEGIN
    CASE g_aza.aza42
    WHEN '1'
         LET g_pib.pib03 = '00000000'
    WHEN '2'
         LET g_pib.pib03 = '000000000'
    WHEN '3'
         LET g_pib.pib03 = '0000000000'
    OTHERWISE
         LET g_pib.pib03 = '00000000'
    END CASE
    #No.FUN-8A0034--END--
#   LET g_pib.pib03 = '0000000000'   #No.MOD-850149 modify by liuxqa #No.FUN-8A0034
    LET g_pib.pib04 = '2'
    LET g_pib.pib05 = '1'            #FUN-930122
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_pib.pibacti ='Y'                   #有效的資料
        LET g_pib.pibuser = g_user
        LET g_pib.piboriu = g_user #FUN-980030
        LET g_pib.piborig = g_grup #FUN-980030
        LET g_pib.pibgrup = g_grup               #使用者所屬群
        LET g_pib.pibdate = g_today
        CALL i800_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_pib.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_pib.pib01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO pib_file VALUES(g_pib.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0) #No.FUN-660156 
           CALL cl_err3("ins","pib_file",g_pib.pib01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        ELSE
            LET g_pib_t.* = g_pib.*                # 保存上筆資料
            SELECT pib01 INTO g_pib.pib01 FROM pib_file
                WHERE pib01 = g_pib.pib01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i800_i(p_cmd)
  DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_flag       LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
         l_cnt        LIKE type_file.num10,   #No.FUN-690026 INTEGER
         l_str        LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(66)
         l_len        LIKE type_file.num10,   #MOD-870171
         l_n          LIKE type_file.num5     #No.FUN-690026 SMALLINT
  DEFINE li_result    LIKE type_file.num5     #No.FUN-560060 #No.FUN-690026 SMALLINT
  DEFINE l_t1         STRING #MOD-640393
  DEFINE l_t2         LIKE type_file.num5    #FUN-8A0034
  DEFINE l_t3         STRING                 #FUN-8A0034
  DEFINE ls_sql       STRING                 #FUN-8A0034
 
  INPUT BY NAME
        g_pib.pib01,g_pib.pib02, g_pib.pib03,g_pib.pib04,g_pib.pib05,    #FUN-930122 ADD pib05
        g_pib.pibuser,g_pib.pibgrup,g_pib.pibmodu,
        g_pib.pibdate,g_pib.pibacti
        WITHOUT DEFAULTS  
 
     BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i800_set_entry(p_cmd)
         CALL i800_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_doctype_format("pib01")   #FUN-5A0199
#genero
{
     BEFORE FIELD pib01
         IF p_cmd='u' AND g_chkey = 'N' THEN NEXT FIELD pib02 END IF
}
 
     AFTER FIELD pib01
         IF g_pib.pib01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_pib.pib01 != g_pib01_t) THEN
               SELECT count(*) INTO l_n FROM pib_file
                WHERE pib01 = g_pib.pib01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_pib.pib01,-239,0)
                  LET g_pib.pib01 = g_pib01_t
                  DISPLAY BY NAME g_pib.pib01 
                  NEXT FIELD pib01
               END IF
            #END IF   #MOD-920225 mark
           #start FUN-5A0199 mark
           ##MOD-520028
           #LET g_t1=g_pib.pib01[1,3]
           #CALL s_mfgslip(g_t1,'aim','5')  #檢查單別
           #
           #IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
           #   CALL cl_err(g_t1,g_errno,0)
           #   IF p_cmd='a' THEN
           #      NEXT FIELD pib01
           #   END IF
           #END IF
           ##--
           #end FUN-5A0199 mark
 
           #MOD-640393...............begin
           LET l_t1=g_pib.pib01 CLIPPED       #No.MOD-830027 add clipped
           IF l_t1.getlength()<>g_doc_len THEN
              CALL cl_err('','aim-121',1)
              NEXT FIELD pib01
           END IF
           #MOD-640393...............end
           #MOD-860128-add
           LET g_cnt = 0 
            SELECT COUNT(*) INTO g_cnt FROM smy_file
             WHERE smyslip = g_pib.pib01
               AND smykind = '5'
               AND smysys = 'aim' 
            IF g_cnt = 0 THEN
              CALL cl_err(g_pib.pib01,'aim-200',1)
              NEXT FIELD pib01                     #No.FUN-8A0036
            END IF 
           #MOD-860128-add
            END IF   #MOD-920225 
         END IF
 
     AFTER FIELD pib03
#No.FUN-8A0034--BEGIN--
#         LET ls_sql = "SELECT aza42 FROM aza_file"
#         PREPARE aza_cur FROM ls_sql
#         EXECUTE aza_cur INTO g_aza.aza42 
         CASE g_aza.aza42
           WHEN '1'
                LET l_t2 = 8
           WHEN '2'
                LET l_t2 = 9
           WHEN '3'
                LET l_t2 = 10
          OTHERWISE
                LET l_t2 = 8
         END CASE
     IF NOT cl_null(g_pib.pib03) THEN
        IF cl_null(g_pib03_t) OR g_pib.pib03 != g_pib03_t THEN
         LET l_t3=g_pib.pib03 CLIPPED 
         IF l_t3.getlength()<>l_t2 THEN
              CALL cl_err('','aim-015',1)
              NEXT FIELD pib03
         END IF
        END IF
     END IF
#No.FUN-8A0034--END--
         IF p_cmd = 'u' AND g_pib.pib03 != g_pib03_t THEN
           #MOD-870171-begin-modify
           # SELECT count(*) INTO l_cnt FROM pia_file 
           ## WHERE pia01[1,3] matches g_pib.pib01
           #  WHERE s_get_doc_no(pia01) matches g_pib.pib01    #No.FUN-560060
           
           LET l_len=0
           LET l_len=Length(g_pib.pib01)
           LET g_sql = "SELECT COUNT(*) FROM pia_file ",
                       " WHERE Substr(pia01,1,",l_len,") = '",g_pib.pib01,"'" 
           PREPARE i800_pre5 FROM g_sql
           DECLARE i800_cur5 CURSOR FOR i800_pre5
           OPEN i800_cur5
           FETCH i800_cur5 INTO l_cnt
           #MOD-870171-end-modify
            IF l_cnt = 0 then 
               #MOD-870171-begin-modify
               #SELECT count(*) INTO l_cnt FROM pid_file 
           #   # WHERE pid01[1,3] matches g_pib.pib01
               # WHERE s_get_doc_no(pid01) matches g_pib.pib01    #No.FUN-560060
                LET g_sql = "SELECT COUNT(*) FROM pid_file ",
                            " WHERE Substr(pid01,1,",l_len,") = '",g_pib.pib01,"'" 
                PREPARE i800_pre6 FROM g_sql
                DECLARE i800_cur6 CURSOR FOR i800_pre6
                OPEN i800_cur6
                FETCH i800_cur6 INTO l_cnt
               #MOD-870171-end-modify
            END IF
            IF l_cnt > 0 THEN 
               CALL cl_getmsg('mfg0106',g_lang) RETURNING l_str
               IF NOT cl_prompt(0,0,l_str) THEN
                  LET g_pib.pib03 = g_pib03_t
                  DISPLAY BY NAME g_pib.pib03
               END IF
            END IF
         END IF
         IF g_pib.pib03 IS NULL OR g_pib.pib03 = ' ' THEN 
            #No.FUN-8A0034--BEGIN--
            CASE l_t2
              WHEN '8'
                   LET g_pib.pib03 = '00000000'
              WHEN '9'
                   LET g_pib.pib03 = '000000000'
              WHEN '10'
                   LET g_pib.pib03 = '0000000000'
             OTHERWISE
                   LET g_pib.pib03 = '00000000'
            END CASE
            #No.FUN-8A0034--END--
#           LET g_pib.pib03 = '0000000000' #No.MOD-850149 modify by liuxqa #No.FUN-8A0034
            DISPLAY BY NAME g_pib.pib03
         END IF
## No:2733 modify 1998/11/06 -----------------------
         IF NOT cl_numchk(g_pib.pib03,6) THEN
            CALL cl_err(g_pib.pib03,'aar-160',0)
            NEXT FIELD pib03
         END IF 
## -------------------------------------------------
 
     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
        LET g_pib.pibuser = s_get_data_owner("pib_file") #FUN-C10039
        LET g_pib.pibgrup = s_get_data_group("pib_file") #FUN-C10039
         IF INT_FLAG THEN EXIT INPUT END IF
         IF g_pib.pib01 IS NULL THEN NEXT FIELD pib01 END IF
 
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
   
FUNCTION i800_q(p_code)
 DEFINE  p_code  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    IF p_code !='q' THEN 
      CALL cl_opmsg('q')
    END IF
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i800_cs(p_code)                         # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN i800_count
    FETCH i800_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i800_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0)
        INITIALIZE g_pib.* TO NULL
    ELSE
        CALL i800_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i800_fetch(p_flpib)
    DEFINE
        p_flpib         LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    CASE p_flpib
        WHEN 'N' FETCH NEXT     i800_cs INTO g_pib.pib01
        WHEN 'P' FETCH PREVIOUS i800_cs INTO g_pib.pib01
        WHEN 'F' FETCH FIRST    i800_cs INTO g_pib.pib01
        WHEN 'L' FETCH LAST     i800_cs INTO g_pib.pib01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
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
            END IF
            FETCH ABSOLUTE g_jump i800_cs INTO g_pib.pib01 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0)
        INITIALIZE g_pib.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flpib
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_pib.* FROM pib_file    # 重讀DB,因TEMP有不被更新特性
       WHERE pib01 = g_pib.pib01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","pib_file",g_pib.pib01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_pib.pibuser #FUN-4C0053
        LET g_data_group = g_pib.pibgrup #FUN-4C0053
        CALL i800_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i800_show()
    LET g_pib_t.* = g_pib.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_pib.*
    DISPLAY BY NAME g_pib.pib01,g_pib.pib02, g_pib.pib03,g_pib.pib04,g_pib.pib05,
                    g_pib.pibuser,g_pib.pibgrup,g_pib.pibmodu,g_pib.pibdate,
                    g_pib.pibacti,g_pib.piborig,g_pib.piboriu
    #No.FUN-9A0024--end  
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i800_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pib.pib01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_pib.* FROM pib_file WHERE pib01=g_pib.pib01
    IF g_pib.pibacti ='N' THEN               #檢查資料是否為無效
        CALL cl_err(g_pib.pib01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN i800_cl USING g_pib.pib01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i800_cl:", STATUS, 1)
       CLOSE i800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i800_cl INTO g_pib.*               #對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pib.pib01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_pib01_t = g_pib.pib01
    LET g_pib03_t = g_pib.pib03
    LET g_pib_o.*=g_pib.*   
    LET g_pib.pibmodu=g_user                     #修改者
    LET g_pib.pibdate = g_today                  #修改日期
    CALL i800_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i800_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pib.*=g_pib_t.*
            CALL i800_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pib_file SET pib_file.* = g_pib.*    # 更新DB
            WHERE pib01 = g_pib01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","pib_file",g_pib_t.pib01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i800_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i800_r()
    DEFINE l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_str LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(60)
           l_len LIKE type_file.num10,   #MOD-870171
           l_cnt LIKE type_file.num10    #No.FUN-690026 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pib.pib01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    #TQC-970386---Begin                                                                                                             
    IF g_pib.pibacti = 'N' THEN                                                                                                     
       CALL cl_err('','abm-033',0)   
       RETURN                                                                                                                       
    END IF                                                                                                                          
    #TQC-970386---End      
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN i800_cl USING g_pib.pib01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i800_cl:", STATUS, 1)
       CLOSE i800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i800_cl INTO g_pib.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0) RETURN 
    END IF
    CALL i800_show()
    #MOD-870171-begin-modify
    #檢查該標籤別的盤點明細是否存在
    #SELECT count(*) INTO l_cnt FROM pia_file 
    #                     #     WHERE pia01[1,3] matches g_pib.pib01
    #                           WHERE s_get_doc_no(pia01) matches g_pib.pib01   #No.FUN-560060
    #                            AND (pia19 IS NULL OR pia19 ='N')
    LET l_len=0
    LET l_len=Length(g_pib.pib01)
    LET g_sql = "SELECT COUNT(*) FROM pia_file ",
                " WHERE Substr(pia01,1,",l_len,") = '",g_pib.pib01,"'", 
                "   AND (pia19 IS NULL OR pia19 = 'N')"
    PREPARE i800_pre FROM g_sql
    DECLARE i800_cur1 CURSOR FOR i800_pre
    OPEN i800_cur1
    FETCH i800_cur1 INTO l_cnt
    #MOD-870171-end-modify
    IF l_cnt = 0 OR l_cnt IS NULL THEN 
       #MOD-870171-begin-modify
       #SELECT count(*) INTO l_cnt FROM pie_file 
       #                  #     WHERE pie01[1,3] matches g_pib.pib01
       #                       WHERE s_get_doc_no(pie01) matches g_pib.pib01   #No.FUN-560060
       #                         AND (pie16 IS NULL OR pie16 ='N')
       LET g_sql = "SELECT COUNT(*) FROM pie_file ",
                   " WHERE Substr(pie01,1,",l_len,") = '",g_pib.pib01,"'",  
                   "   AND (pie16 IS NULL OR pie16 ='N')"
       PREPARE i800_pre1 FROM g_sql
       DECLARE i800_cur2 CURSOR FOR i800_pre1
       OPEN i800_cur2
       FETCH i800_cur2 INTO l_cnt
       #MOD-870171-end-modify
    END IF
    #--->有未盤點資料不可刪除
    IF l_cnt > 0 THEN 
       CALL cl_getmsg('mfg0105',g_lang) RETURNING l_str
       CALL cl_msgany(17,16,l_str)
    ELSE 
       #--->有未盤點資料不可刪除
       #MOD-870171-begin-modify
       #SELECT count(*) INTO l_cnt FROM pia_file 
       ##     WHERE pia01[1,3] matches g_pib.pib01
       #               WHERE s_get_doc_no(pia01) matches g_pib.pib01     #No.FUN-560060
       LET g_sql = "SELECT COUNT(*) FROM pia_file ",
                   " WHERE Substr(pia01,1,",l_len,") = '",g_pib.pib01,"'"  
       PREPARE i800_pre2 FROM g_sql
       DECLARE i800_cur3 CURSOR FOR i800_pre2
       OPEN i800_cur3
       FETCH i800_cur3 INTO l_cnt
       #MOD-870171-end-modify
       IF l_cnt = 0 OR l_cnt IS NULL THEN 
       #MOD-870171-begin-modify
       #   SELECT count(*) INTO l_cnt FROM pid_file 
       #                   #    WHERE pid01[1,3] matches g_pib.pib01
       #                       WHERE s_get_doc_no(pid01)matches g_pib.pib01   #No.FUN-560060
       LET g_sql = "SELECT COUNT(*) FROM pid_file ",
                   " WHERE Substr(pid01,1,",l_len,") = '",g_pib.pib01,"'"  
       PREPARE i800_pre4 FROM g_sql
       DECLARE i800_cur4 CURSOR FOR i800_pre4
       OPEN i800_cur4
       FETCH i800_cur4 INTO l_cnt
       #MOD-870171-end-modify
       END IF
       IF l_cnt > 0 THEN 
          CALL cl_getmsg('mfg0116',g_lang) RETURNING l_str
          IF cl_prompt(17,16,l_str) THEN 
             DELETE FROM pib_file WHERE pib01=g_pib.pib01
             IF SQLCA.SQLERRD[3]=0
                THEN # CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0) #No.FUN-660156
                       CALL cl_err3("del","pib_file",g_pib.pib01,"",
                                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
                ELSE CLEAR FORM
                     INITIALIZE g_pib.* TO NULL
             END IF
          END IF
       ELSE 
          IF cl_delete() THEN
              DELETE FROM pib_file WHERE pib01=g_pib.pib01
              IF SQLCA.SQLERRD[3]=0
                 THEN #CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0) #No.FUN-660156
                       CALL cl_err3("del","pib_file",g_pib.pib01,"",
                                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 ELSE CLEAR FORM
                      INITIALIZE g_pib.* TO NULL
         OPEN i800_count
         FETCH i800_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i800_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i800_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i800_fetch('/')
         END IF
              END IF
          END IF
       END IF
    END IF
    CLOSE i800_cl
    COMMIT WORK
END FUNCTION
 
#TQC-730117.....begin                                                           
FUNCTION i800_x()                                                               
   IF g_pib.pib01 IS NULL THEN                                                  
      CALL cl_err(g_pib.pib01,'-400',0)                                         
      RETURN                                                                    
   END IF                                                                       
                                                                                
   BEGIN WORK                                                                   
   OPEN i800_cl USING g_pib.pib01                                               
   IF STATUS THEN                                                               
      CALL cl_err("OPEN i800_cl:",STATUS,1)                                     
      CLOSE i800_cl
      ROLLBACK WORK                                                             
      RETURN                                                                    
   END IF                                                                       
   FETCH i800_cl INTO g_pib.*                                                   
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_pib.pib01,SQLCA.sqlcode,1)                                  
      RETURN                                                                    
   END IF                                                                       
                                                                                
   CALL i800_show()                                                             
                                                                                
   IF cl_exp(0,0,g_pib.pibacti) THEN                                            
      LET g_chr=g_pib.pibacti                                                   
      IF g_pib.pibacti = 'Y' THEN                                               
         LET g_pib.pibacti='N'                                                  
      ELSE                                                                      
         LET g_pib.pibacti='Y'                                                  
      END IF                                                                    
                                                                                
      UPDATE pib_file
         SET pibacti=g_pib.pibacti                                              
         WHERE pib01=g_pib.pib01                                                
      IF SQLCA.SQLERRD[3]=0 THEN                                                
         CALL cl_err(g_pib.pib01,SQLCA.sqlcode,0)                               
         LET g_pib.pibacti=g_chr                                                
      END IF                                                                    
      DISPLAY BY NAME g_pib.pibacti                                             
   END IF                                                                       
   CLOSE i800_cl                                                                
   COMMIT WORK                                                                  
END FUNCTION
 
#genero
FUNCTION i800_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pib01",FALSE)
   END IF 
 
END FUNCTION
 
FUNCTION i800_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pib01",TRUE)
   END IF
 
END FUNCTION 

