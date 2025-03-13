# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amri103.4gl
# Descriptions...: 不納入MRP計算訂單別維護作業
# Date & Author..: 00/08/02 By Byron
# Modify.........: No.FUN-4C0042 04/12/07 By pengu Data and Group權限控管
# MOdify.........: No.FUN-550055 05/05/27 By ice q_oay開窗查詢錯誤修改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660028 06/06/08 By Claire 新增INSERT功能異常
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0041 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790152 07/09/28 By Pengu FUNCTION i103_msi01()中的SQL語法錯誤
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.TQC-970253 09/07/23 By dxfwo  action的第一筆，最后一筆，任意筆 呈現反白，無法點選
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_msi   RECORD LIKE msi_file.*,
    g_msi_t RECORD LIKE msi_file.*,
    g_msi01_t LIKE msi_file.msi01,
    g_wc,g_sql         STRING,                  #No.FUN-580092 HCN   
    g_oaydesc          LIKE oay_file.oaydesc    #No.FUN-680082 VARCHAR(24)
DEFINE g_forupd_sql    STRING                   #SELECT ... FOR UPDATE SQL        
DEFINE g_chr           LIKE type_file.chr1      #No.FUN-680082 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680082 INTEGER
DEFINE g_msg           LIKE type_file.chr1000   #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10     #No.FUN-680082 INTEGER
DEFINE g_curs_index    LIKE type_file.num10     #No.FUN-680082 INTEGER
DEFINE g_jump          LIKE type_file.num10     #No.FUN-680082 INTEGER
DEFINE g_no_ask       LIKE type_file.num5      #No.FUN-680082 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    INITIALIZE g_msi.* TO NULL
    INITIALIZE g_msi_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM msi_file WHERE msi01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i103_w WITH FORM "amr/42f/amri103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL i103_menu()
 
    CLOSE WINDOW i103_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i103_cs()
    CLEAR FORM
   INITIALIZE g_msi.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        msi01,
        msiuser,msigrup,msimodu,msidate,msiacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 查詢其他主檔資料
 
            IF INFIELD(msi01) THEN  #請購單別
#No.FUN-550055 --start--
#               CALL q_oay(0,0,g_msi.msi01,'3*') RETURNING g_msi.msi01
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_oay"
#               LET g_qryparam.state = "c"
#               LET g_qryparam.where = " oaytype matches '3*'"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               LET g_qryparam.default1 = g_msi.msi01
               #CALL q_oay(TRUE,TRUE,g_msi.msi01,'','') RETURNING g_msi.msi01     #TQC-670008
                CALL q_oay(TRUE,TRUE,g_msi.msi01,'','axm') RETURNING g_msi.msi01  #TQC-670008   #FUN-A70130
#No.FUN-550055 --end--
                DISPLAY g_msi.msi01 TO msi01
                NEXT FIELD msi01
           END IF
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
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND gebuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND gebgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND gebgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gebuser', 'gebgrup')
    #End:FUN-980030
 
 LET g_sql="SELECT msi01 FROM msi_file ",
       # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY msi01  "
    PREPARE i103_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i103_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i103_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM msi_file WHERE ",g_wc CLIPPED
    PREPARE i103_precount FROM g_sql
    DECLARE i103_count CURSOR FOR i103_precount
END FUNCTION
 
FUNCTION i103_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"      #TQC-660028 add r
            IF cl_chk_act_auth() THEN
                 CALL i103_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i103_q()
            END IF
        ON ACTION next
            CALL i103_fetch('N')
        ON ACTION previous
            CALL i103_fetch('P')
#No.TQC-970253--begin--                                                                                                             
        ON ACTION jump                                                                                                              
            CALL i103_fetch('/')                                                                                                    
        ON ACTION first                                                                                                             
            CALL i103_fetch('F')                                                                                                    
        ON ACTION last                                                                                                              
            CALL i103_fetch('L')                                                                                                    
#No.TQC-970253 --end--
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i103_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i103_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i103_r()
            END IF
#       ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            IF cl_chk_act_auth() THEN
#                 CALL i103_copy()
#            END IF}
#       ON ACTION output
#            LET g_action_choice="output"
#            IF cl_chk_act_auth()
#               THEN CALL i103_out()
#            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
#       ON ACTION jump
#           CALL i103_fetch('/')
#       ON ACTION first
#           CALL i103_fetch('F')
#       ON ACTION last
#           CALL i103_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_msi.msi01 IS NOT NULL THEN
                 LET g_doc.column1 = "msi01"
                 LET g_doc.value1 = g_msi.msi01
                 CALL cl_doc()
              END IF
          END IF
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i103_cs
END FUNCTION
 
 
FUNCTION i103_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_msi.* LIKE msi_file.*
    LET g_msi01_t = NULL                         #預設欄位值
    LET g_msi_t.*=g_msi.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_msi.msiuser = g_user
        LET g_msi.msioriu = g_user #FUN-980030
        LET g_msi.msiorig = g_grup #FUN-980030
        LET g_msi.msigrup = g_grup               #使用者所屬群
        LET g_msi.msidate = g_today
        LET g_msi.msiacti = 'Y'
        CALL i103_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_msi.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_msi.msi01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO msi_file VALUES(g_msi.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            CONTINUE WHILE
        ELSE
            LET g_msi_t.* = g_msi.*                # 保存上筆資料
            SELECT msi01 INTO g_msi.msi01 FROM msi_file
                WHERE msi01 = g_msi.msi01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i103_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,      #No.FUN-680082 VARCHAR(1)
        l_flag          LIKE type_file.chr1,      #判斷必要欄位是否有輸入 #No.FUN-680082 VARCHAR(1)
        l_n             LIKE type_file.num5       #No.FUN-680082 SMALLINT
    DISPLAY BY NAME g_msi.msiuser,g_msi.msigrup,
        g_msi.msidate,g_msi.msiacti,g_msi.msimodu
    INPUT BY NAME g_msi.msioriu,g_msi.msiorig,
        g_msi.msi01
        WITHOUT DEFAULTS
 
     #  BEFORE FIELD msi01    #判斷是否可更改KEY值
      #      IF p_cmd='u' AND g_chkey='N' THEN NEXT FIELD msi01 END IF
        AFTER FIELD msi01
         IF NOT cl_null(g_msi.msi01) THEN
          CALL i103_msi01()
          IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_msi.msi01,g_errno,0)
            NEXT FIELD msi01
          END IF
          IF p_cmd = "a" OR # 若輸入或更改且改KEY
            (p_cmd = "u" AND ( g_msi.msi01!=g_msi01_t))  THEN
             SELECT count(*) INTO l_n FROM msi_file
             WHERE msi01 = g_msi.msi01
             IF l_n > 0 THEN# Duploayted
               CALL cl_err('',-239,0)
               LET g_msi.msi01 = g_msi01_t
               IF g_msi.msi01 IS NULL THEN
                 Let g_oaydesc=''
                 DISPLAY g_oaydesc TO FORMONLY.oaydesc
               ELSE
                 CALL i103_msi01()
               END IF
             DISPLAY BY NAME g_msi.msi01
             NEXT FIELD msi01
           END IF
          END IF
         END IF
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(msi01) THEN
        #        LET g_msi.* = g_msi_t.*
        #        DISPLAY BY NAME g_msi.*
        #        NEXT FIELD msi01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                        # 查詢其他主檔資料
 
            IF INFIELD(msi01) THEN  #請購單別
#               CALL q_oay(0,0,g_msi.msi01,'3*') RETURNING g_msi.msi01
#               CALL FGL_DIALOG_SETBUFFER( g_msi.msi01 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oay"
                LET g_qryparam.default1 = g_msi.msi01
                LET g_qryparam.arg1 = 'axm'                    #FUN-A70130
                LET g_qryparam.where = " oaytype matches '3*'"
                CALL cl_create_qry() RETURNING g_msi.msi01
#                CALL FGL_DIALOG_SETBUFFER( g_msi.msi01 )
                DISPLAY BY NAME g_msi.msi01
                NEXT FIELD msi01
            END IF
 
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
 
FUNCTION i103_msi01()
# DEFINE l_oaydesc  VARCHAR(10)
DEFINE   l_oaydesc  LIKE oay_file.oaydesc  #No.FUN-680082 VARCHAR(10)
   Let g_errno=''
   Let g_oaydesc=''
   SELECT oaydesc INTO g_oaydesc FROM oay_file
      WHERE oayslip = g_msi.msi01
        AND oaytype matches '3*'     #No.MOD-790152 modify
   If g_oaydesc IS NULL then
      Let g_errno='amr-914'
   else
      DISPLAY g_oaydesc To FORMONLY.oaydesc
   END IF
END FUNCTION
 
FUNCTION i103_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msi.* TO NULL              #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i103_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i103_count
    FETCH i103_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i103_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msi.* TO NULL
    ELSE
        CALL i103_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i103_fetch(p_flmsi)
    DEFINE
      # p_flmsi          VARCHAR(1),
        p_flmsi         LIKE type_file.chr1,   #No.FUN-680082 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680082 INTEGER
 
    CASE p_flmsi
      WHEN 'N' FETCH NEXT     i103_cs INTO g_msi.msi01
      WHEN 'P' FETCH PREVIOUS i103_cs INTO g_msi.msi01
      WHEN 'F' FETCH FIRST    i103_cs INTO g_msi.msi01
      WHEN 'L' FETCH LAST     i103_cs INTO g_msi.msi01
      WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i103_cs INTO g_msi.msi01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msi.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmsi
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_msi.* FROM msi_file            # 重讀DB,因TEMP有不被更新特性
       WHERE msi01 = g_msi.msi01
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE                                       #FUN-4C0042權限控管
       LET g_data_owner = g_msi.msiuser
       LET g_data_group = g_msi.msigrup
        CALL i103_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i103_show()
    LET g_msi_t.* = g_msi.*
 #  DISPLAY BY NAME g_msi.*
    DISPLAY BY NAME g_msi.msi01, g_msi.msioriu,g_msi.msiorig,
                    g_msi.msiuser,g_msi.msigrup,g_msi.msimodu,g_msi.msidate,
                    g_msi.msiacti
    IF status THEN
       CALL cl_err('',status,0)
    END IF
    CALL i103_msi01()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i103_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_msi.msi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_msi.* FROM msi_file WHERE msi01=g_msi.msi01
 
    IF g_msi.msiacti ='N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_msi01_t = g_msi.msi01  #key值備份
    BEGIN WORK
 
    OPEN i103_cl USING g_msi.msi01
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i103_cl INTO g_msi.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msi.msi01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_msi.msimodu=g_user                     #修改者
    LET g_msi.msidate = g_today                  #修改日期
    CALL i103_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i103_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_msi.*=g_msi_t.*
            CALL i103_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE msi_file SET msi_file.* = g_msi.*    # 更新DB
            WHERE msi01 = g_msi.msi01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_msi.msi01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_msi.msi01 IS NULL THEN  #使用者是否已做查詢的動作
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i103_cl USING g_msi.msi01
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i103_cl INTO g_msi.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msi.msi01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i103_show()
    IF cl_exp(0,0,g_msi.msiacti) THEN
        LET g_chr=g_msi.msiacti
        IF g_msi.msiacti='Y' THEN
            LET g_msi.msiacti='N'
        ELSE
            LET g_msi.msiacti='Y'
        END IF
        UPDATE msi_file
            SET msiacti=g_msi.msiacti
            WHERE msi01 = g_msi.msi01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_msi.msi01,SQLCA.sqlcode,0)
            LET g_msi.msiacti=g_chr
        END IF
        DISPLAY BY NAME g_msi.msiacti
    END IF
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_msi.msi01 IS NULL THEN   #是否已查詢
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i103_cl USING g_msi.msi01
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i103_cl INTO g_msi.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msi.msi01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i103_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msi01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msi.msi01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM msi_file WHERE msi01 = g_msi.msi01
       CLEAR FORM
       OPEN i103_count
       FETCH i103_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i103_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i103_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i103_fetch('/')
       END IF
 
    END IF
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#TQC-790177
