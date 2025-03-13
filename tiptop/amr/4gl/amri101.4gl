# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: amri101.4gl
# Descriptions...: 不納入MRP計算採購單別維護作業
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
# Modify.........: No.MOD-790151 07/09/27 By Pengu 不應該有geb_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-950068 10/03/10 by huangrh 畫面上FORMONLY.smydesc清空
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    b_msg   RECORD LIKE msg_file.*,  #改成b_msg因g_msg其他程式已用
    b_msg_t RECORD LIKE msg_file.*,
    b_msg01_t LIKE msg_file.msg01,
     g_wc,g_sql         STRING, #No.FUN-580092 HCN    
     g_smydesc          LIKE smy_file.smydesc #MOD-4C0010
 
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680082 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680082 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680082 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680082 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680082 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680082 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680082 SMALLINT
#       l_time        LIKE type_file.chr8           #No.FUN-6A0076
 
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
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
    IF p_row = 0 OR p_row IS NULL THEN           # 螢墓位置
        LET p_row = 8
        LET p_col = 30
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    INITIALIZE b_msg.* TO NULL
    INITIALIZE b_msg_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM msg_file WHERE msg01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i101_w AT p_row,p_col
      WITH FORM "amr/42f/amri101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i101_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i101_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i101_cs()
    CLEAR FORM
   INITIALIZE b_msg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        msg01,
        msguser,msggrup,msgmodu,msgdate,msgacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 查詢其他主檔資料
            IF INFIELD(msg01) THEN  #請購單別
#               CALL q_smy(10,3,b_msg.msg01,'APM','2') RETURNING b_msg.msg01 #TQC-670008
                CALL q_smy(TRUE, FALSE,b_msg.msg01,'APM','2')   #TQC-670008
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO msg01
                NEXT FIELD msg01
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
    #        LET g_wc = g_wc clipped," AND msguser = '",g_user,"'"      #No.MOD-790151 modify
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND msggrup MATCHES '",g_grup CLIPPED,"*'"   #No.MOD-790151 modify
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND msggrup IN ",cl_chk_tgrup_list()   #No.MOD-790151 modify
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('msguser', 'msggrup')
    #End:FUN-980030
 
    LET g_sql="SELECT msg01 FROM msg_file ",
       # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY msg01  "
    PREPARE i101_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i101_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i101_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM msg_file WHERE ",g_wc CLIPPED
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
END FUNCTION
 
FUNCTION i101_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i101_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i101_q()
            END IF
        ON ACTION next
            CALL i101_fetch('N')
        ON ACTION previous
            CALL i101_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i101_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i101_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i101_r()
            END IF
    {   ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i101_copy()
            END IF}
    {    ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i101_out()
            END IF }
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i101_fetch('/')
        ON ACTION first
            CALL i101_fetch('F')
        ON ACTION last
            CALL i101_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
     
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-6B0041-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF b_msg.msg01 IS NOT NULL THEN
                 LET g_doc.column1 = "msg01"
                 LET g_doc.value1 = b_msg.msg01
                 CALL cl_doc()
              END IF
          END IF
       #No.FUN-6B0041-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i101_cs
END FUNCTION
 
 
FUNCTION i101_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE b_msg.* LIKE msg_file.*
    LET b_msg01_t = NULL                         #預設欄位值
    LET b_msg_t.*=b_msg.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET b_msg.msguser = g_user
        LET b_msg.msggrup = g_grup               #使用者所屬群
        LET b_msg.msgdate = g_today
        LET b_msg.msgacti = 'Y'
        CALL i101_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE b_msg.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF b_msg.msg01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET b_msg.msgoriu = g_user      #No.FUN-980030 10/01/04
        LET b_msg.msgorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO msg_file VALUES(b_msg.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#            CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("ins","msg_file",b_msg.msg01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        ELSE
            LET b_msg_t.* = b_msg.*                # 保存上筆資料
            SELECT msg01 INTO b_msg.msg01 FROM msg_file
                WHERE msg01 = b_msg.msg01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i101_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入   #No.FUN-680082 VARCHAR(1)
        l_n             LIKE type_file.num5      #No.FUN-680082 SMALLINT 
    DISPLAY BY NAME b_msg.msguser,b_msg.msggrup,
        b_msg.msgdate,b_msg.msgacti,b_msg.msgmodu
    INPUT BY NAME
        b_msg.msg01
        WITHOUT DEFAULTS
 
     #  BEFORE FIELD msg01    #判斷是否可更改KEY值
      #      IF p_cmd='u' AND g_chkey='N' THEN NEXT FIELD msg01 END IF
        AFTER FIELD msg01
         IF NOT cl_null(b_msg.msg01) THEN
          CALL i101_msg01()
          IF NOT cl_null(g_errno) THEN
            CALL cl_err(b_msg.msg01,g_errno,0)
            NEXT FIELD msg01
          END IF
          IF p_cmd = "a" OR # 若輸入或更改且改KEY
            (p_cmd = "u" AND ( b_msg.msg01!=b_msg01_t))  THEN
             SELECT count(*) INTO l_n FROM msg_file
             WHERE msg01 = b_msg.msg01
             IF l_n > 0 THEN# Duplsmyted
               CALL cl_err('',-239,0)
               LET b_msg.msg01 = b_msg01_t
               IF b_msg.msg01 IS NULL THEN
                 Let g_smydesc=''
                 DISPLAY g_smydesc TO FORMONLY.smydesc
               ELSE
                 CALL i101_msg01()
               END IF
             DISPLAY BY NAME b_msg.msg01
             NEXT FIELD msg01
           END IF
          END IF
         END IF
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(msg01) THEN
        #        LET b_msg.* = b_msg_t.*
        #        DISPLAY BY NAME b_msg.*
        #        NEXT FIELD msg01
        #    END IF
        #MOD-650015 --end 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                        # 查詢其他主檔資料
 
            IF INFIELD(msg01) THEN  #請購單別
#               CALL q_smy(10,3,g_msg.msg01,'apm','2') RETURNING b_msg.msg01
#                CALL FGL_DIALOG_SETBUFFER( b_msg.msg01 )
                CALL q_smy(FALSE, FALSE,b_msg.msg01,'APM','2') #TQC-670008
                     RETURNING b_msg.msg01
#                CALL FGL_DIALOG_SETBUFFER( b_msg.msg01 )
                DISPLAY BY NAME b_msg.msg01
                NEXT FIELD msg01
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
 
FUNCTION i101_msg01()
 DEFINE l_smydesc  LIKE smy_file.smydesc #MOD-4C0010
   Let g_errno=''
   Let g_smydesc=''
   SELECT smydesc INTO g_smydesc FROM smy_file
      WHERE smyslip = b_msg.msg01
            And smysys='apm' and smykind='2'
   If g_smydesc IS NULL then
      Let g_errno='amr-914'
 # else                                        #TQC-950068
 #    DISPLAY g_smydesc To FORMONLY.smydesc    #TQC-950068
   END IF
   DISPLAY g_smydesc To FORMONLY.smydesc       #TQC-950068
END FUNCTION
 
 
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE b_msg.* TO NULL              #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i101_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i101_count
    FETCH i101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE b_msg.* TO NULL
    ELSE
        CALL i101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i101_fetch(p_flmsg)
    DEFINE
      # p_flmsg          VARCHAR(1),
        p_flmsg         LIKE type_file.chr1,   #No.FUN-680082 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680082 INTEGER 
 
    CASE p_flmsg
      WHEN 'N' FETCH NEXT     i101_cs INTO b_msg.msg01
      WHEN 'P' FETCH PREVIOUS i101_cs INTO b_msg.msg01
      WHEN 'F' FETCH FIRST    i101_cs INTO b_msg.msg01
      WHEN 'L' FETCH LAST     i101_cs INTO b_msg.msg01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i101_cs INTO b_msg.msg01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE b_msg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmsg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO b_msg.* FROM msg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE msg01 = b_msg.msg01
    IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660107
         CALL cl_err3("sel","msg_file",b_msg.msg01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
    ELSE                                      #FUN-4C0042權限控管
       LET g_data_owner = b_msg.msguser
       LET g_data_group = b_msg.msggrup
        CALL i101_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i101_show()
    LET b_msg_t.* = b_msg.*
 #  DISPLAY BY NAME b_msg.*
    DISPLAY BY NAME b_msg.msg01,
                    b_msg.msguser,b_msg.msggrup,b_msg.msgmodu,b_msg.msgdate,
                    b_msg.msgacti
    IF status THEN
       CALL cl_err('',status,0)
    END IF
    CALL i101_msg01()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_u()
    IF s_shut(0) THEN RETURN END IF
    IF b_msg.msg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO b_msg.* FROM msg_file WHERE msg01=b_msg.msg01
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET b_msg01_t = b_msg.msg01  #key值備份
    BEGIN WORK
 
    OPEN i101_cl USING b_msg.msg01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO b_msg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(b_msg.msg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET b_msg.msgmodu=g_user                     #修改者
    LET b_msg.msgdate = g_today                  #修改日期
    CALL i101_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i101_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET b_msg.*=b_msg_t.*
            CALL i101_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE msg_file SET msg_file.* = b_msg.*    # 更新DB
            WHERE msg01 = b_msg.msg01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#            CALL cl_err(b_msg.msg01,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("upd","msg_file",b_msg01_t,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_x()
    IF s_shut(0) THEN RETURN END IF
    IF b_msg.msg01 IS NULL THEN  #使用者是否已做查詢的動作
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i101_cl USING b_msg.msg01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO b_msg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(b_msg.msg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i101_show()
    IF cl_exp(0,0,b_msg.msgacti) THEN
        LET g_chr=b_msg.msgacti
        IF b_msg.msgacti='Y' THEN
            LET b_msg.msgacti='N'
        ELSE
            LET b_msg.msgacti='Y'
        END IF
        UPDATE msg_file
            SET msgacti=b_msg.msgacti
            WHERE msg01 = b_msg.msg01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(b_msg.msg01,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("upd","msg_file",b_msg.msg01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            LET b_msg.msgacti=g_chr
        END IF
        DISPLAY BY NAME b_msg.msgacti
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_r()
    IF s_shut(0) THEN RETURN END IF
    IF b_msg.msg01 IS NULL THEN   #是否已查詢
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i101_cl USING b_msg.msg01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO b_msg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(b_msg.msg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i101_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = b_msg.msg01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM msg_file WHERE msg01 = b_msg.msg01
       CLEAR FORM
       OPEN i101_count
       FETCH i101_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i101_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i101_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i101_fetch('/')
       END IF
 
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
#Patch....NO.TQC-610035 <001> #
