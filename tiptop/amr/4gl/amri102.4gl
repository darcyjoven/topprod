# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: amri102.4gl
# Descriptions...: 不納入MRP計算工單別維護作業
# Date & Author..: 00/08/02 By Byron
# Modify.........: No.MOD-4C0010 By Mandy DEFINE smydesc欄位,改成用LIKE 方式
# Modify.........: No.FUN-4C0042 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0041 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-950068 10/03/10 by huangrh 畫面當上FORMONLY.smydesc清空
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_msh   RECORD LIKE msh_file.*,
    g_msh_t RECORD LIKE msh_file.*,
    g_msh01_t           LIKE msh_file.msh01,
    g_wc,g_sql          STRING,  #No.FUN-580092 HCN   
    g_smydesc           LIKE smy_file.smydesc #MOD-4C0010
 
DEFINE g_forupd_sql     STRING 
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-680082 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680082 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5    #No.FUN-680082 SMALLINT
 
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
    INITIALIZE g_msh.* TO NULL
    INITIALIZE g_msh_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM msh_file WHERE msh01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i102_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i102_w WITH FORM "amr/42f/amri102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL i102_menu()
 
    CLOSE WINDOW i102_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i102_cs() CLEAR FORM
   INITIALIZE g_msh.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        msh01, mshuser,mshgrup,mshmodu,mshdate,mshacti
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp                        # 查詢其他主檔資料
            IF INFIELD(msh01) THEN  #工單別
                CALL q_smy(TRUE, FALSE,g_msh.msh01,'ASF','1') #TQC-670008
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO msh01
                NEXT FIELD msh01
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
 
    LET g_sql="SELECT msh01 FROM msh_file ",
       # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY msh01  "
    PREPARE i102_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i102_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i102_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM msh_file WHERE ",g_wc CLIPPED
    PREPARE i102_precount FROM g_sql
    DECLARE i102_count CURSOR FOR i102_precount
END FUNCTION
 
FUNCTION i102_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i102_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i102_q()
            END IF
        ON ACTION next
            CALL i102_fetch('N')
        ON ACTION previous
            CALL i102_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i102_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i102_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i102_r()
            END IF
    {   ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i102_copy()
            END IF}
    {    ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i102_out()
            END IF }
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i102_fetch('/')
        ON ACTION first
            CALL i102_fetch('F')
        ON ACTION last
            CALL i102_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_msh.msh01 IS NOT NULL THEN
                 LET g_doc.column1 = "msh01"
                 LET g_doc.value1 = g_msh.msh01
                 CALL cl_doc()
              END IF
          END IF
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i102_cs
END FUNCTION
 
 
FUNCTION i102_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_msh.* LIKE msh_file.*
    LET g_msh01_t = NULL                         #預設欄位值
    LET g_msh_t.*=g_msh.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_msh.mshuser = g_user
        LET g_msh.mshoriu = g_user #FUN-980030
        LET g_msh.mshorig = g_grup #FUN-980030
        LET g_msh.mshgrup = g_grup               #使用者所屬群
        LET g_msh.mshdate = g_today
        LET g_msh.mshacti = 'Y'
        CALL i102_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_msh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_msh.msh01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO msh_file VALUES(g_msh.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#            CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("ins","msh_file",g_msh.msh01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        ELSE
            LET g_msh_t.* = g_msh.*                # 保存上筆資料
            SELECT msh01 INTO g_msh.msh01 FROM msh_file
                WHERE msh01 = g_msh.msh01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i102_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入  #No.FUN-680082 VARCHAR(1)
        l_n             LIKE type_file.num5      #No.FUN-680082 SMALLINT
    DISPLAY BY NAME g_msh.mshuser,g_msh.mshgrup,
        g_msh.mshdate,g_msh.mshacti,g_msh.mshmodu
    INPUT BY NAME g_msh.mshoriu,g_msh.mshorig,
        g_msh.msh01
        WITHOUT DEFAULTS
 
     #  BEFORE FIELD msh01    #判斷是否可更改KEY值
      #      IF p_cmd='u' AND g_chkey='N' THEN NEXT FIELD msh01 END IF
        AFTER FIELD msh01
         IF NOT cl_null(g_msh.msh01) THEN
          CALL i102_msh01()
          IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_msh.msh01,g_errno,0)
            NEXT FIELD msh01
          END IF
          IF p_cmd = "a" OR # 若輸入或更改且改KEY
            (p_cmd = "u" AND ( g_msh.msh01!=g_msh01_t))  THEN
             SELECT count(*) INTO l_n FROM msh_file
             WHERE msh01 = g_msh.msh01
             IF l_n > 0 THEN# Duplsmyted
               CALL cl_err('',-239,0)
               LET g_msh.msh01 = g_msh01_t
               IF g_msh.msh01 IS NULL THEN
                 Let g_smydesc=''
                 DISPLAY g_smydesc TO FORMONLY.smydesc
               ELSE
                 CALL i102_msh01()
               END IF
             DISPLAY BY NAME g_msh.msh01
             NEXT FIELD msh01
           END IF
          END IF
         END IF
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(msh01) THEN
        #        LET g_msh.* = g_msh_t.*
        #        DISPLAY BY NAME g_msh.*
        #        NEXT FIELD msh01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                        # 查詢其他主檔資料
 
            IF INFIELD(msh01) THEN  #工單別
#               CALL q_smy(10,3,g_msh.msh01,'asf','1') RETURNING g_msh.msh01
#                CALL FGL_DIALOG_SETBUFFER( g_msh.msh01 )
                CALL q_smy(FALSE, FALSE,g_msh.msh01,'ASF','1') #TQC-670008
                     RETURNING g_msh.msh01
#                CALL FGL_DIALOG_SETBUFFER( g_msh.msh01 )
                DISPLAY BY NAME g_msh.msh01
                NEXT FIELD msh01
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
 
FUNCTION i102_msh01()
 DEFINE l_smydesc  LIKE smy_file.smydesc #MOD-4C0010
   Let g_errno=''
   Let g_smydesc=''
   SELECT smydesc INTO g_smydesc FROM smy_file
      WHERE smyslip = g_msh.msh01
            And smysys='asf' and smykind='1'
   If g_smydesc IS NULL then
      Let g_errno='amr-914'
#  else                                        #TQC-950068
#     DISPLAY g_smydesc To FORMONLY.smydesc    #TQC-950068
   END IF
   DISPLAY g_smydesc To FORMONLY.smydesc       #TQC-950068
END FUNCTION
 
 
FUNCTION i102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msh.* TO NULL              #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i102_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i102_count
    FETCH i102_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msh.* TO NULL
    ELSE
        CALL i102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i102_fetch(p_flmsh)
    DEFINE
      # p_flmsh          VARCHAR(1),
        p_flmsh         LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
        l_abso          LIKE type_file.num10    #No.FUN-680082 INTEGER
 
    CASE p_flmsh
      WHEN 'N' FETCH NEXT     i102_cs INTO g_msh.msh01
      WHEN 'P' FETCH PREVIOUS i102_cs INTO g_msh.msh01
      WHEN 'F' FETCH FIRST    i102_cs INTO g_msh.msh01
      WHEN 'L' FETCH LAST     i102_cs INTO g_msh.msh01
      WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
            FETCH ABSOLUTE g_jump i102_cs INTO g_msh.msh01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmsh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_msh.* FROM msh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE msh01 = g_msh.msh01
    IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660107
         CALL cl_err3("sel","msh_file",g_msh.msh01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
    ELSE                                       #FUN-4C0042權限控管
       LET g_data_owner = g_msh.mshuser
       LET g_data_group = g_msh.mshgrup
        CALL i102_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i102_show()
    LET g_msh_t.* = g_msh.*
 #  DISPLAY BY NAME g_msh.*
    DISPLAY BY NAME g_msh.msh01, g_msh.mshoriu,g_msh.mshorig,
                    g_msh.mshuser,g_msh.mshgrup,g_msh.mshmodu,g_msh.mshdate,
                    g_msh.mshacti
    IF status THEN
       CALL cl_err('',status,0)
    END IF
    CALL i102_msh01()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i102_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_msh.msh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_msh.* FROM msh_file WHERE msh01=g_msh.msh01
 
    IF g_msh.mshacti ='N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_msh01_t = g_msh.msh01  #key值備份
    BEGIN WORK
 
    OPEN i102_cl USING g_msh.msh01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_msh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msh.msh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_msh.mshmodu=g_user                     #修改者
    LET g_msh.mshdate = g_today                  #修改日期
    CALL i102_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i102_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_msh.*=g_msh_t.*
            CALL i102_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE msh_file SET msh_file.* = g_msh.*    # 更新DB
            WHERE msh01 = g_msh.msh01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_msh.msh01,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("upd","msh_file",g_msh01_t,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_msh.msh01 IS NULL THEN  #使用者是否已做查詢的動作
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i102_cl USING g_msh.msh01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_msh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msh.msh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i102_show()
    IF cl_exp(0,0,g_msh.mshacti) THEN
        LET g_chr=g_msh.mshacti
        IF g_msh.mshacti='Y' THEN
            LET g_msh.mshacti='N'
        ELSE
            LET g_msh.mshacti='Y'
        END IF
        UPDATE msh_file
            SET mshacti=g_msh.mshacti
            WHERE msh01 = g_msh.msh01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_msh.msh01,SQLCA.sqlcode,0) #No.FUN-660107
              CALL cl_err3("upd","msh_file",g_msh.msh01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            LET g_msh.mshacti=g_chr
        END IF
        DISPLAY BY NAME g_msh.mshacti
    END IF
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_msh.msh01 IS NULL THEN   #是否已查詢
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i102_cl USING g_msh.msh01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_msh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msh.msh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i102_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msh.msh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM msh_file WHERE msh01 = g_msh.msh01
       CLEAR FORM
       OPEN i102_count
       FETCH i102_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i102_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i102_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i102_fetch('/')
       END IF
    END IF
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION
#Patch....NO.TQC-610035 <001> #
