# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: acot701.4gl
# Descriptions...: 加工合同核銷作業
# Date & Author..: 01/03/14 Wiky
# Modify.........: No.MOD-490398 04/12/24 By Danny   拿掉coc03
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.修改action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cns   RECORD LIKE cns_file.*,		#海關基本資料檔
    g_cns_t RECORD LIKE cns_file.*,		#海關基本資料檔
    g_cns01_t      LIKE cns_file.cns01,         #手冊編號
     g_wc,g_sql    STRING  #No.FUN-580092 HCN   #No.FUN-680069
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    #No.FUN-680069
DEFINE   g_before_input_done  STRING                 #No.FUN-680069  STRING
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(72)
 
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0063
      DEFINE    p_row,p_col         LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    OPTIONS					#改變一些系統預設值
						
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    INITIALIZE g_cns.* TO NULL
    INITIALIZE g_cns_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM cns_file WHERE cns00 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t701_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 5 LET p_col = 10
    OPEN WINDOW t701_w AT p_row,p_col WITH FORM "aco/42f/acot701"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL t701_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t701_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION t701_cs()
    CLEAR FORM
   INITIALIZE g_cns.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cns01,cns03,cnsuser,cnsgrup,cnsmodu,cnsdate,cnsacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION controlp  # 沿用所有欄位
          CASE
             #No.MOD-490398
            WHEN INFIELD(cns01)         #手冊編號
              CALL q_coc2(TRUE,TRUE,g_cns.cns01,'','','','','')
                   RETURNING g_cns.cns01
              DISPLAY BY NAME g_cns.cns01
              NEXT FIELD cns01
             #No.MOD-490398 end
          OTHERWISE EXIT CASE
          END CASE
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
    #        LET g_wc = g_wc clipped," AND cnsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cnsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cnsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnsuser', 'cnsgrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT cns00,cns01 FROM cns_file ", # 組合出 SQL 指令
                " WHERE cns04 !='1'",
                "  AND ",g_wc CLIPPED," ORDER BY cns01"
    PREPARE t701_prepare FROM g_sql         # RUNTIME 編譯
    DECLARE t701_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t701_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cns_file WHERE cns04 !='1' AND ",g_wc CLIPPED
    PREPARE t701_precount FROM g_sql
    DECLARE t701_count CURSOR FOR t701_precount
END FUNCTION
 
FUNCTION t701_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t701_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t701_q()
            END IF
        ON ACTION next
            CALL t701_fetch('N')
        ON ACTION previous
            CALL t701_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t701_u()
            END IF
     #   ON ACTION invalid
     #       LET g_action_choice="invalid"
     #       IF cl_chk_act_auth() THEN
     #            CALL t701_x()
     #       END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t701_r()
           END IF
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t701_y()
            END IF
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t701_z()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic(g_cns.cnsconf,"","","","","")
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL t701_fetch('/')
        ON ACTION first
            CALL t701_fetch('F')
        ON ACTION last
            CALL t701_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
         #No.FUN-6A0168-------add--------str----
         ON ACTION related_document       #相關文件
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
                IF g_cns.cns01 IS NOT NULL THEN
                   LET g_doc.column1 = "cns01"
                   LET g_doc.value1 = g_cns.cns01
                   CALL cl_doc()
                END IF
            END IF
         #No.FUN-6A0168-------add--------end----
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t701_cs
END FUNCTION
 
 
FUNCTION t701_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM                                     #清螢幕欄位內容
    INITIALIZE g_cns.* LIKE cns_file.*
    LET g_cns01_t = NULL
    LET g_cns_t.*=g_cns.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cns.cnsacti = 'Y'                  #有效的資料
        LET g_cns.cnsuser = g_user		 #用戶
        LET g_cns.cnsoriu = g_user #FUN-980030
        LET g_cns.cnsorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_cns.cnsgrup = g_grup               #用戶所屬群
        LET g_cns.cnsdate = g_today		 #更改日期
        LET g_cns.cnsconf = 'N'		         #審核
        LET g_cns.cns03 = g_today           	 #核銷日期
        LET g_cns.cns04 = '2'            		 #來源 1.核銷轉入2.核銷
        LET g_cns.cnsplant = g_plant  #FUN-980002
        LET g_cns.cnslegal = g_legal  #FUN-980002
 
        CALL t701_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_cns.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cns.cns01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO cns_file VALUES(g_cns.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("ins","cns_file",g_cns.cns00,g_cns.cns01,SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            CONTINUE WHILE
        ELSE
            LET g_cns_t.* = g_cns.*                # 保存上筆資料
            SELECT cns00 INTO g_cns.cns00 FROM cns_file
             WHERE cns01 = g_cns.cns01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t701_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入        #No.FUN-680069 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_coc04         LIKE coc_file.coc04
 
    DISPLAY BY NAME g_cns.cnsuser,g_cns.cnsgrup,
        g_cns.cnsdate, g_cns.cnsacti,g_cns.cnsconf
    INPUT BY NAME g_cns.cnsoriu,g_cns.cnsorig,
        g_cns.cns01,g_cns.cns03
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t701_set_entry(p_cmd)
           CALL t701_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD cns01	
          IF g_cns.cns01 IS NOT NULL THEN
            IF g_cns.cns01 != g_cns01_t OR g_cns01_t IS NULL THEN
                SELECT count(*) INTO l_n FROM cns_file
                WHERE cns01 = g_cns.cns01
              IF l_n > 0 THEN   #單據編號重複
                 CALL cl_err(g_cns.cns01,-239,0)
                 LET g_cns.cns01 = g_cns01_t
                 DISPLAY BY NAME g_cns.cns01
                 NEXT FIELD cns01
              END IF
              CALL t701_cns01('a')
              IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_cns.cns01,g_errno,0)
                  NEXT FIELD cns01
                  LET g_cns.cns01 = g_cns_t.cns01
                  DISPLAY BY NAME g_cns.cns01
              END IF
            END IF
          END IF
 
 
    AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF cl_null(g_cns.cns01) THEN  #廠商編號
           LET l_flag='Y'
           DISPLAY BY NAME g_cns.cns01
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD cns01
       END IF
 
       #MOD-650015 --start 
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #   IF INFIELD(cns01) THEN
       #      LET g_cns.* = g_cns_t.*
       #      DISPLAY BY NAME g_cns.*
       #      NEXT FIELD cns01
       #   END IF
       #MOD-650015 --end
 
       ON ACTION controlp # 沿用所有欄位
          CASE
             #No.MOD-490398
            WHEN INFIELD(cns01)         #手冊編號
              CALL q_coc2(FALSE,TRUE,g_cns.cns01,'','','','','')
                   RETURNING g_cns.cns01,l_coc04
              DISPLAY BY NAME g_cns.cns01
              NEXT FIELD cns01
             #No.MOD-490398 end
          OTHERWISE EXIT CASE
          END CASE
 
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
 
 #No.MOD-490398
FUNCTION t701_cns01(p_cmd)  #手冊編號
   DEFINE l_coc02   LIKE coc_file.coc02,
          l_coc05   LIKE coc_file.coc05,
          l_coc07   LIKE coc_file.coc07,
          l_coc10   LIKE coc_file.coc10,
          l_cocacti LIKE coc_file.cocacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT coc02,coc10,coc05,coc07,cocacti
      INTO l_coc02,l_coc10,l_coc05,l_coc07,l_cocacti
      FROM coc_file WHERE coc03 = g_cns.cns01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-062'
                                   LET l_coc02 = NULL
                                   LET l_coc10 = NULL
                                   LET l_coc05 = NULL
                                   LET l_coc07 = NULL
  WHEN l_cocacti='N' LET g_errno = '9028'
       # WHEN l_coc05 < g_today    LET g_errno = 'aco-056'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(l_coc07) AND l_coc07 < g_today THEN
       LET g_errno='aco-057'
    END IF
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_coc02 TO FORMONLY.coc02
       DISPLAY l_coc10 TO FORMONLY.coc10
       DISPLAY l_coc05 TO FORMONLY.coc05
    END IF
END FUNCTION
 #No.MOD-490398  end
 
FUNCTION t701_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cns.* TO NULL             #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t701_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_cns.* TO NULL
        RETURN
    END IF
    OPEN t701_count
    FETCH t701_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t701_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0)
        INITIALIZE g_cns.* TO NULL
    ELSE
        CALL t701_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t701_fetch(p_flcns)
    DEFINE
        p_flcns         LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680069 INTEGER
 
    CASE p_flcns
        WHEN 'N' FETCH NEXT     t701_cs INTO g_cns.cns00, g_cns.cns01
        WHEN 'P' FETCH PREVIOUS t701_cs INTO g_cns.cns00, g_cns.cns01
        WHEN 'F' FETCH FIRST    t701_cs INTO g_cns.cns00, g_cns.cns01
        WHEN 'L' FETCH LAST     t701_cs INTO g_cns.cns00, g_cns.cns01
        WHEN '/'
 
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump t701_cs INTO g_cns.cns00 ,g_cns.cns01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cns.cns01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cns.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcns
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cns.* FROM cns_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cns00 = g_cns.cns00
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cns.cns01 CLIPPED
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cns_file",g_msg,"",SQLCA.SQLCODE,"","",1) #No.TQC-660045
    ELSE
#       LET g_data_owner = g_cns.cnsuser
#       LET g_data_group = g_cns.cnsgrup
        CALL t701_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t701_show()
    LET g_cns_t.* = g_cns.*
    DISPLAY BY NAME g_cns.cns01,g_cns.cns03, g_cns.cnsoriu,g_cns.cnsorig,
 
                    g_cns.cnsuser,g_cns.cnsgrup,g_cns.cnsdate,
                    g_cns.cnsacti,g_cns.cnsmodu,g_cns.cnsconf
 
    CALL cl_set_field_pic(g_cns.cnsconf,"","","","","")
 
    CALL t701_cns01('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t701_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cns.cns01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cns.cnsconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_cns.cnsconf='Y' THEN RETURN END IF
    IF g_cns.cnsacti ='N' THEN                     #檢查資料是否為無效
        CALL cl_err(g_cns.cns01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cns01_t = g_cns.cns01
    BEGIN WORK
 
    OPEN t701_cl USING g_cns.cns00
    IF STATUS THEN
       CALL cl_err("OPEN t701_cl:", STATUS, 1)
       CLOSE t701_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t701_cl INTO g_cns.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cns.cnsmodu = g_user                #更改者
    LET g_cns.cnsdate = g_today               #更改日期
    CALL t701_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t701_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cns.* = g_cns_t.*
            CALL t701_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cns_file SET cns_file.* = g_cns.*    # 更新DB
            WHERE cns00 = g_cns.cns00               # COLAUTH?
        IF SQLCA.sqlcode THEN
           LET g_msg = g_cns.cns01 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cns_file",g_cns01_t,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t701_cl
    COMMIT WORK
END FUNCTION
 {
FUNCTION t701_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cns.cns01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t701_cl USING g_cns.cns00
    IF STATUS THEN
       CALL cl_err("OPEN t701_cl:", STATUS, 1)
       CLOSE t701_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t701_cl INTO g_cns.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t701_show()
    IF cl_exp(0,0,g_cns.cnsacti) THEN
        LET g_chr = g_cns.cnsacti
        IF g_cns.cnsacti = 'Y' THEN
           LET g_cns.cnsacti = 'N'
        ELSE
           LET g_cns.cnsacti = 'Y'
        END IF
        UPDATE cns_file
            SET cnsacti = g_cns.cnsacti,
                cnsmodu = g_user, cnsdate = g_today
            WHERE cns00 = g_cns.cns00
        IF SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0)
            LET g_cns.cnsacti = g_chr
        END IF
        DISPLAY BY NAME g_cns.cnsacti
    END IF
    CLOSE t701_cl
    COMMIT WORK
    CALL cl_set_field_pic(g_cns.cnsconf,"","","","","")
 
 
END FUNCTION
 }
 
FUNCTION t701_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cns.cns01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cns.cnsconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_cns.cnsconf='Y' THEN RETURN END IF
    BEGIN WORK
 
    OPEN t701_cl USING g_cns.cns00
    IF STATUS THEN
       CALL cl_err("OPEN t701_cl:", STATUS, 1)
       CLOSE t701_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t701_cl INTO g_cns.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t701_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cns01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cns.cns01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cns_file WHERE cns00 = g_cns.cns00
       CLEAR FORM
 
         OPEN t701_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t701_cs
             CLOSE t701_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH t701_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t701_cs
             CLOSE t701_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t701_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t701_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t701_fetch('/')
         END IF
    END IF
    CLOSE t701_cl
    INITIALIZE g_cns.* TO NULL
    COMMIT WORK
END FUNCTION
 
FUNCTION t701_y()
  DEFINE s_coc01    LIKE coc_file.coc01
  DEFINE t_coc01    LIKE coc_file.coc01
  DEFINE l_cnt02    LIKE cnt_file.cnt02
  DEFINE l_cnt05    LIKE cnt_file.cnt05
  DEFINE l_cnt10    LIKE cnt_file.cnt10
   IF g_cns.cns01 IS NULL THEN RETURN END IF
 
   SELECT * INTO g_cns.* FROM cns_file WHERE cns01=g_cns.cns01
   IF g_cns.cnsconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_cns.cnsconf='Y' THEN RETURN END IF
{
   #no.7377
   SELECT COUNT(*) INTO g_cnt FROM cnt_file
    WHERE cnt01 = g_cns.cns01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #no.7377(end)
}
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
 
   SELECT coc01 INTO t_coc01 FROM coc_file
    WHERE coc04 = g_cns.cns01
      AND cocacti !='N' #010807增
   IF cl_null(t_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t701_cl USING g_cns.cns00
   IF STATUS THEN
      CALL cl_err("OPEN t701_cl:", STATUS, 1)
      CLOSE t701_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t701_cl INTO g_cns.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0)
       CLOSE t701_cl
       ROLLBACK WORK
       RETURN
   END IF
 
    #更新核銷日期
   UPDATE coc_file SET coc07 = g_cns.cns03
    WHERE coc01 = t_coc01
   IF STATUS THEN
#      CALL cl_err('upd coc:',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","coc_file",t_coc01,"",STATUS,"","upd coc:",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
   UPDATE cns_file SET cnsconf='Y'
    WHERE cns01 = g_cns.cns01
   IF STATUS THEN
#      CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","cns_file",g_cns.cns00,g_cns.cns01,STATUS,"","upd cofconf",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM cng_file
    WHERE cng04 = g_cns.cns01
   IF g_cnt > 0 THEN
      UPDATE cng_file SET (cng07) = (g_cns.cns03)
       WHERE cng04 = g_cns.cns01
      IF SQLCA.sqlcode THEN
 #        CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0) #No.TQC-660045
          CALL cl_err3("upd","cng_file",g_cns.cns01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
         LET g_success = 'N'
      END IF
   END IF
   #####
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
  SELECT cnsconf INTO g_cns.cnsconf FROM cns_file
    WHERE cns01 = g_cns.cns01
   DISPLAY BY NAME g_cns.cnsconf
  CALL cl_set_field_pic(g_cns.cnsconf,"","","","","")
END FUNCTION
 
FUNCTION t701_z()
 DEFINE s_coc01    LIKE coc_file.coc01
 DEFINE t_coc01    LIKE coc_file.coc01
 DEFINE l_cnt05    LIKE cnt_file.cnt05
 DEFINE l_cnt02    LIKE cnt_file.cnt02
 DEFINE l_cnt10    LIKE cnt_file.cnt10
   IF g_cns.cns01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cns.* FROM cns_file WHERE cns01=g_cns.cns01
   IF g_cns.cnsconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_cns.cnsconf='N' THEN RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
  #找出原始的申請編號
    SELECT coc01 INTO t_coc01 FROM coc_file
        WHERE coc04 = g_cns.cns01
          AND cocacti !='N' #010807 增
   IF cl_null(t_coc01) THEN
       CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t701_cl USING g_cns.cns00
   IF STATUS THEN
      CALL cl_err("OPEN t701_cl:", STATUS, 1)
      CLOSE t701_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t701_cl INTO g_cns.*# 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0)
      CLOSE t701_cl
   ROLLBACK WORK
     RETURN
   END IF
 
   #更新核銷日期
   UPDATE coc_file SET coc07 = null
    WHERE coc01 = t_coc01
   IF STATUS THEN
#      CALL cl_err('upd coc:',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","coc_file",t_coc01,"",STATUS,"","upd coc:",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
   UPDATE cns_file SET cnsconf='N'
    WHERE cns01 = g_cns.cns01
   IF STATUS THEN
#      CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","cns_file",g_cns.cns01,"",STATUS,"","upd cofconf",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM cng_file
    WHERE cng04 = g_cns.cns01
   IF g_cnt > 0 THEN
      UPDATE cng_file SET cng07 = null
       WHERE cng04 = g_cns.cns01
      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_cns.cns01,SQLCA.sqlcode,0) #No.TQC-660045
          CALL cl_err3("upd","cng_file",g_cns.cns01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
         LET g_success = 'N'
      END IF
   END IF
   #####
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cnsconf INTO g_cns.cnsconf FROM cns_file
    WHERE cns01 = g_cns.cns01
   DISPLAY BY NAME g_cns.cnsconf
   CALL cl_set_field_pic(g_cns.cnsconf,"","","","","")
END FUNCTION
 
FUNCTION t701_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cns01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t701_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cns01",FALSE)
 
   END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <> #
