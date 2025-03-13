# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amsi620.4gl
# Descriptions...: 工單日期調整作業
# Date & Author..: 00/08/09 By Mandy
# Modify.........: No.FUN-4C0041 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-550056 05/05/23 By Trisy 單據編號加大
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0150 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/17 By dxfwo "更改"按鈕無法使用,刪除"按鈕無法使用
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750229 07/05/29 By Judy 新增時資料有效碼為"N"，應是"Y"
# Modify.........: No.FUN-980005 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_mpu   RECORD LIKE mpu_file.*,
    g_mpu_t RECORD LIKE mpu_file.*,
    g_mpu_o RECORD LIKE mpu_file.*,
    g_mpu_v_t      LIKE mpu_file.mpu_v,
    g_mpu01_t      LIKE mpu_file.mpu01,
    g_wc,g_sql     string,                 #No.FUN-580092 HCN
    g_cmd          LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(01)
 
DEFINE g_forupd_sql          STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt               LIKE type_file.num10      #NO.FUN-680101 INTEGER
DEFINE   g_msg               LIKE type_file.chr1000    #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count         LIKE type_file.num10      #NO.FUN-680101 INTEGER
DEFINE   g_curs_index        LIKE type_file.num10      #NO.FUN-680101 INTEGER
DEFINE   g_jump              LIKE type_file.num10      #NO.FUN-680101 INTEGER
DEFINE   mi_no_ask           LIKE type_file.num5       #NO.FUN-680101 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0081
    DEFINE p_row,p_col     LIKE type_file.num5         #NO.FUN-680101 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
 
 
    INITIALIZE g_mpu.* TO NULL
    INITIALIZE g_mpu_t.* TO NULL
    INITIALIZE g_mpu_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM mpu_file WHERE mpu_v = ? AND mpu01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i620_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i620_w AT p_row,p_col
      WITH FORM "ams/42f/amsi620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i620_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i620_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION i620_cs()
    CLEAR FORM
   INITIALIZE g_mpu.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        mpu_v,mpu01,mpu02,mpu03,
        mpuuser,mpugrup,mpumodu,mpudate,mpuacti
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND mpuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND mpugrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND mpugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mpuuser', 'mpugrup')
    #End:FUN-980030
 
    LET g_sql="SELECT mpu_v,mpu01 FROM mpu_file ", # 組合出 SQL 指令
         " WHERE ",g_wc CLIPPED, " ORDER BY mpu_v,mpu01"
    PREPARE i620_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i620_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i620_prepare
    LET g_sql = "SELECT COUNT(*) FROM mpu_file WHERE ",g_wc CLIPPED
    PREPARE i620_precount FROM g_sql
    DECLARE i620_count CURSOR FOR i620_precount
END FUNCTION
 
FUNCTION i620_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i620_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i620_q()
            END IF
        ON ACTION next
            CALL i620_fetch('N')
        ON ACTION previous
            CALL i620_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i620_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i620_r()
            END IF
 
         #MOD-480114
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               IF g_mpu.mpuacti = 'N' THEN
                  CALL i620_firm1()
               ELSE
                  CALL i620_firm2()
               END IF
            END IF
            CALL cl_set_field_pic("","","","","",g_mpu.mpuacti)
        #--
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_mpu.mpuacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i620_fetch('/')
        ON ACTION first
            CALL i620_fetch('F')
        ON ACTION last
            CALL i620_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
      
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-6A0150-------add--------str----
       ON ACTION related_document             #相關文件"                        
        LET g_action_choice="related_document"           
           IF cl_chk_act_auth() THEN                     
              IF g_mpu.mpu_v IS NOT NULL THEN            
                 LET g_doc.column1 = "mpu_v"               
                 LET g_doc.column2 = "mpu01"               
                 LET g_doc.value1 = g_mpu.mpu_v            
                 LET g_doc.value2 = g_mpu.mpu01           
                 CALL cl_doc()                             
              END IF                                        
           END IF                                           
        #No.FUN-6A0150-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i620_cs
END FUNCTION
 
 
FUNCTION i620_a()
DEFINE   l_sta    LIKE type_file.chr4    #NO.FUN-680101 VARCHAR(04) 
#       l_time         LIKE type_file.chr8       #No.FUN-6A0081
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                               # 清螢幕欄位內容
    INITIALIZE g_mpu.* LIKE mpu_file.*
    LET g_mpu_t.*     = g_mpu.*
    LET g_mpu_v_t     = NULL                 #模擬版本
    LET g_mpu01_t     = NULL                 #工單編號
    LET g_mpu.mpuuser = g_user               #資料所有者
    LET g_mpu.mpuoriu = g_user #FUN-980030
    LET g_mpu.mpuorig = g_grup #FUN-980030
    LET g_data_plant = g_plant #FUN-980030
    LET g_mpu.mpugrup = g_grup               #資料所有群
    LET g_mpu.mpudate = g_today              #最近修改日
    LET g_mpu.mpu02   = g_today              #開工日期
#   LET g_mpu.mpuacti = 'N'                  #資料有效碼   #TQC-750229 mark
    LET g_mpu.mpuacti = 'Y'                  #資料有效碼   #TQC-750229
    LET g_mpu.mpuplant = g_plant             #FUN-980005
    LET g_mpu.mpulegal = g_legal             #FUN-980005
    CALL cl_opmsg('a')
    WHILE TRUE
        BEGIN WORK
        CALL i620_i("a")                       # 各欄位輸入
        IF INT_FLAG THEN                       # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_mpu.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_mpu.mpu_v) THEN        # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_mpu.mpu01) THEN        # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO mpu_file VALUES (g_mpu.*)
        IF SQLCA.sqlcode THEN
   #        CALL cl_err('i620_ins_mpu:',SQLCA.sqlcode,1) #No.FUN-660108
            CALL cl_err3("ins","mpu_file",g_mpu.mpu01,g_mpu.mpu_v,SQLCA.sqlcode,"","i620_ins_mpu",1)   #No.FUN-660108
            LET g_success = 'N' RETURN
        END IF
        COMMIT WORK
        SELECT mpu_v,mpu01 INTO g_mpu.mpu_v,g_mpu.mpu01 FROM mpu_file WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01
        LET g_mpu_t.* = g_mpu.*
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i620_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1) 
        l_flag          LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)   #判斷必要欄位是否有輸入
        l_n             LIKE type_file.num5     #NO.FUN-680101 SMALLINT  #判斷資料是否重覆的變數
   DEFINE   li_result   LIKE type_file.num5     #No.FUN-550056   #NO.FUN-680101 SMALLINT
    INPUT BY NAME g_mpu.mpuoriu,g_mpu.mpuorig,
        g_mpu.mpu_v,g_mpu.mpu01,g_mpu.mpu02,g_mpu.mpu03,
        g_mpu.mpuuser,g_mpu.mpugrup,g_mpu.mpumodu,g_mpu.mpudate,g_mpu.mpuacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i620_set_entry(p_cmd)
           CALL i620_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
         #No.FUN-550056 --start--
         CALL cl_set_docno_format("mpu01")
         #No.FUN-550056 ---end---
 
        AFTER FIELD mpu_v
          IF NOT cl_null(g_mpu.mpu_v) THEN
            SELECT COUNT(*) INTO l_n FROM mpt_file
                WHERE mpt_v = g_mpu.mpu_v
            IF l_n <= 0 THEN
                NEXT FIELD mpu_v
            END IF
          END IF
 
        AFTER FIELD mpu01
         #No.FUN-550056 --start--
#        IF NOT cl_null(g_mpu.mpu01) THEN
#           CALL s_check_no("ams",g_mpu.mpu01,g_mpu01_t,"*","mpu_file","mpu01","")
#           RETURNING li_result,g_mpu.mpu01
#           DISPLAY BY NAME g_mpu.mpu01
#           IF (NOT li_result) THEN
#              LET g_mpu.mpu01=g_mpu_o.mpu01
#              NEXT FIELD mpu01
#           END IF
#           DISPLAY g_smy.smydesc TO smydesc
#        END IF
         #No.FUN-550056 ---end---
          IF NOT cl_null(g_mpu.mpu01) THEN
            SELECT COUNT(*) INTO l_n FROM mpu_file
                WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01
            IF l_n >= 1 THEN
                DISPLAY g_today,'' TO mpu02,mpu03
                CALL cl_err('',-239,1)
                NEXT FIELD mpu_v
            END IF
            SELECT sfb13,sfb15 INTO g_mpu.mpu02,g_mpu.mpu03 FROM sfb_file
                WHERE sfb01 = g_mpu.mpu01 AND sfb87!='X'
            IF STATUS THEN
                NEXT FIELD mpu01
            END IF
            DISPLAY BY NAME g_mpu.mpu02,g_mpu.mpu03
          END IF
 
        AFTER FIELD mpu03
          IF NOT cl_null(g_mpu.mpu03) THEN
            IF g_mpu.mpu03 < g_mpu.mpu02 THEN
                NEXT FIELD mpu03
            END IF
          END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_mpu.mpuuser = s_get_data_owner("mpu_file") #FUN-C10039
           LET g_mpu.mpugrup = s_get_data_group("mpu_file") #FUN-C10039
            LET l_flag = 'N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF  cl_null(g_mpu.mpu_v) THEN
                 LET l_flag = 'Y'
                 DISPLAY BY NAME g_mpu.mpu_v
            END IF
            IF  cl_null(g_mpu.mpu01) THEN
                 LET l_flag = 'Y'
                 DISPLAY BY NAME g_mpu.mpu01
            END IF
            IF  cl_null(g_mpu.mpu02) THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME g_mpu.mpu02
            END IF
            IF  cl_null(g_mpu.mpu03) THEN
                 LET l_flag='Y'
                 DISPLAY BY NAME g_mpu.mpu03
            END IF
            IF l_flag = 'Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD mpu_v
            END IF
 
 
 
         #MOD-480114
{
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(mpu_v) THEN
                LET g_mpu.* = g_mpu_t.*
                DISPLAY BY NAME g_mpu.*
                NEXT FIELD mpu_v
            END IF
}
       #--
 
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
 
FUNCTION i620_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_mpu.* TO NULL              #No.FUN-6A0150
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i620_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i620_count
    FETCH i620_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i620_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mpu.mpu01,SQLCA.sqlcode,0)
        INITIALIZE g_mpu.* TO NULL
    ELSE
        CALL i620_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i620_fetch(p_flmpu)
    DEFINE
        p_flmpu          LIKE type_file.chr1,     #NO.FUN-680101 VARCHAR(1)   #處理的方式
        l_abso           LIKE type_file.num10     #NO.FUN-680101 INTEGER   #絕對的筆數
 
    CASE p_flmpu
        WHEN 'N' FETCH NEXT     i620_cs INTO g_mpu.mpu_v,g_mpu.mpu01
        WHEN 'P' FETCH PREVIOUS i620_cs INTO g_mpu.mpu_v,g_mpu.mpu01
        WHEN 'F' FETCH FIRST    i620_cs INTO g_mpu.mpu_v,g_mpu.mpu01
        WHEN 'L' FETCH LAST     i620_cs INTO g_mpu.mpu_v,g_mpu.mpu01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i620_cs INTO g_mpu.mpu_v,g_mpu.mpu01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mpu.mpu01,SQLCA.sqlcode,0)
        INITIALIZE g_mpu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmpu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_mpu.* FROM mpu_file    # 重讀DB,因TEMP有不被更新特性
        WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01 
    IF SQLCA.sqlcode THEN
 #      CALL cl_err(g_mpu.mpu01,SQLCA.sqlcode,0) #No.FUN-660108
        CALL cl_err3("sel","mpu_file",g_mpu.mpu01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
    ELSE                                      #FUN-4C0041權限控管
       LET g_data_owner = g_mpu.mpuuser
       LET g_data_group = g_mpu.mpugrup
       LET g_data_plant = g_mpu.mpuplant #FUN-980030
        CALL i620_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i620_show()
 
    LET g_mpu_t.* = g_mpu.*
    DISPLAY BY NAME g_mpu.mpuoriu,g_mpu.mpuorig,
        g_mpu.mpu_v,g_mpu.mpu01,g_mpu.mpu02,g_mpu.mpu03,
        g_mpu.mpuuser,g_mpu.mpugrup,g_mpu.mpumodu,g_mpu.mpudate,g_mpu.mpuacti
 
    CALL cl_set_field_pic("","","","","",g_mpu.mpuacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i620_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_mpu.mpu_v IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_mpu.mpu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_mpu.* FROM mpu_file WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01 
#   IF g_mpu.mpuacti = 'Y' THEN    #No.TQC-750041
#       RETURN                     #No.TQC-750041
#   END IF                         #No.TQC-750041    
    IF g_mpu.mpuacti = 'N' THEN    #No.TQC-750041
      CALL cl_err('',9027,0)       #No.TQC-750041
    RETURN                         #No.TQC-750041
    END  IF                        #No.TQC-750041
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_mpu_v_t = g_mpu.mpu_v
    LET g_mpu01_t = g_mpu.mpu01
    LET g_mpu_o.* = g_mpu.*
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN i620_cl USING g_mpu.mpu_v,g_mpu.mpu01
    IF STATUS THEN
       CALL cl_err("OPEN i620_cl:", STATUS, 1)
       CLOSE i620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i620_cl INTO g_mpu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mpu.mpu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_mpu.mpumodu = g_user                #修改者
    LET g_mpu.mpudate = g_today               #修改日期
    CALL i620_show()                          #顯示最新資料
    WHILE TRUE
        CALL i620_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0 LET g_success = 'N'
            LET g_mpu.*  = g_mpu_t.*
            CALL i620_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE mpu_file SET mpu_file.* = g_mpu.*    # 更新DB
            WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01              # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
     #      CALL cl_err('(i620_u:mpu)',SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("upd","mpu_file",g_mpu_t.mpu01,"",SQLCA.sqlcode,"","(i620_u:mpu)",1)   #No.FUN-660108
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i620_cl
    IF g_success = 'Y'THEN
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION i620_firm1()
 
     IF cl_null(g_mpu.mpu_v) THEN RETURN END IF  #MOD-480114
 
    LET g_success   = 'Y'
 
    BEGIN WORK
        IF g_mpu.mpuacti = 'Y' THEN RETURN END IF
        IF NOT cl_sure(20,20) THEN RETURN END IF
        UPDATE mpu_file SET mpuacti = 'Y' WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
   #        CALL cl_err('upd mpuacti',STATUS,1) #No.FUN-660108
            CALL cl_err3("upd","mpu_file",g_mpu.mpu_v,g_mpu.mpu01,STATUS,"","upd mpuacti",1)   #No.FUN-660108
            LET g_success = 'N'
        END IF
        IF g_success='N' THEN
            LET g_mpu.mpuacti = 'N'
            ROLLBACK WORK
        ELSE
            LET g_mpu.mpuacti = 'Y'
            COMMIT WORK
            CALL cl_cmmsg(1)
        END IF
        DISPLAY g_mpu.mpuacti TO mpuacti
END FUNCTION
 
FUNCTION i620_firm2()
 
     IF cl_null(g_mpu.mpu_v) THEN RETURN END IF  #MOD-480114
 
    LET g_success='Y'
    BEGIN WORK
        IF g_mpu.mpuacti = 'N' THEN RETURN END IF
        IF NOT cl_sure(20,20) THEN RETURN END IF
        UPDATE mpu_file SET mpuacti = 'N' WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
   #        CALL cl_err('upd mpuacti',STATUS,1) #No.FUN-660108
            CALL cl_err3("upd","mpu_file",g_mpu.mpu_v,g_mpu.mpu01,STATUS,"","upd mpuacti",1)   #No.FUN-660108
            LET g_success = 'N'
        END IF
        IF g_success='N' THEN
            LET g_mpu.mpuacti = 'Y'
            ROLLBACK WORK
        ELSE
            LET g_mpu.mpuacti = 'N'
            COMMIT WORK
            CALL cl_cmmsg(1)
        END IF
        DISPLAY g_mpu.mpuacti TO mpuacti
END FUNCTION
 
FUNCTION i620_r()
    DEFINE
        l_chr   LIKE type_file.chr1         #NO.FUN-680101 VARCHAR(1) 
#       l_time        LIKE type_file.chr8      #No.FUN-6A0081
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_mpu.mpu_v) OR cl_null(g_mpu.mpu01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT * INTO g_mpu.* FROM mpu_file WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01 
#   IF g_mpu.mpuacti = 'Y' THEN RETURN END IF    #No.TQC-750041
#   LET g_success = 'Y'                          #No.TQC-750041     
#   BEGIN WORK                                   #No.TQC-750041     
    IF g_mpu.mpuacti = 'N' THEN                  #No.TQC-750041   
      CALL cl_err('',9027,0)                     #No.TQC-750041 
    RETURN                                       #No.TQC-750041
    END  IF                                      #No.TQC-750041 
 
    OPEN i620_cl USING g_mpu.mpu_v,g_mpu.mpu01
    IF STATUS THEN
       CALL cl_err("OPEN i620_cl:", STATUS, 1)
       CLOSE i620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i620_cl INTO g_mpu.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mpu.mpu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i620_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "mpu_v"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "mpu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_mpu.mpu_v      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_mpu.mpu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM mpu_file
            WHERE mpu_v = g_mpu.mpu_v AND mpu01 = g_mpu.mpu01 
        IF SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
    #       CALL cl_err('i620_r:mpu',SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("del","mpu_file",g_mpu.mpu_v,g_mpu.mpu01,SQLCA.sqlcode,"","i620_r:mpu",1)   #No.FUN-660108
        END IF
        IF g_success = 'Y' THEN CLEAR FORM END IF
        OPEN i620_count
        FETCH i620_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i620_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i620_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i620_fetch('/')
        END IF
 
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980005 add azoplant,azolegal
                VALUES ('amsi620',g_user,g_today,g_msg,g_mpu.mpu01,'Delete',g_plant,g_legal) #FUN-980005 add g_plant,g_legal
    END IF
    CLOSE i620_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION i620_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #NO.FUN-680101 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("mpu_v,mpu01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i620_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #NO.FUN-680101 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("mpu_v,mpu01",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #

