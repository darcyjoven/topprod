# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asdi180.4gl
# Descriptions...: LCM巿價維護作業
# Date & Author..: 99/10/10
# Modify.........: 00/01/17 by Echi    修正欄位時能自動計算
# Modify.........: No.MOD-4B0258 04/11/25 By Mandy 幣別加開窗功能
# Modify.........: No.FUN-4B0065 04/11/25 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0081 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760197 07/06/28 By Sarah 出貨區點測查詢時程式當出,重過程式
# Modify.........: No.TQC-770126 07/07/31 By Nicola 重過程式
# Modify.........: No.MOD-960141 09/07/07 By Smapmin 修改ora檔
# Modify.........: No.TQC-960343 09/06/23 By hongmei mark NEXT OPTION "next"
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu 取消料件的管控	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_stp   RECORD LIKE stp1_file.*,
    g_gem   RECORD LIKE gem_file.*,
    g_stp_t RECORD LIKE stp1_file.*,
    l_stp07   LIKE stp_file.stp07,
    g_stp02_t LIKE stp1_file.stp02,
    g_wc,g_sql          string  #No.FUN-580092 HCN
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5     #No.FUN-690010 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0089
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ASD")) THEN
       EXIT PROGRAM
    END IF
    LET p_row = ARG_VAL(1)
 
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
    INITIALIZE g_stp.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM stp1_file WHERE stp02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i180_cl CURSOR FROM g_forupd_sql  # LOCK CURSOR
    LET p_row = 3 LET p_col = 12
    OPEN WINDOW i180_w AT p_row,p_col
        WITH FORM "asd/42f/asdi180" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i180_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i180_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END MAIN
 
FUNCTION i180_curs()
    CLEAR FORM
   INITIALIZE g_stp.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        stp02,stp021,stp01,stp03,stp04,stp05,stp06,stp07,stp08,stp09,stp10,
        stp11,stp12,stp13,stp14,stp15,stp16,stp17,stp18,stp19
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION controlp                        # 查詢其他主檔資料
           CASE
            WHEN INFIELD(stp02)   #料號
#FUN-AA0059---------mod------------str-----------------            
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.state="c"
#                 LET g_qryparam.default1 = g_stp.stp02
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","",g_stp.stp02,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO stp02
                 NEXT FIELD stp02
             #MOD-4B0258
            WHEN INFIELD(stp12) #幣別開窗
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state="c"
                 LET g_qryparam.default1 = g_stp.stp12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO stp12
                 NEXT FIELD stp12
             #MOD-4B0258(end)
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    LET g_sql="SELECT stp02 FROM stp1_file ",
              " WHERE ",g_wc CLIPPED, " ORDER BY stp02 "
    PREPARE i180_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i180_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i180_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM stp1_file WHERE ",g_wc CLIPPED
    PREPARE i180_cnt FROM g_sql
    DECLARE i180_count
        SCROLL CURSOR WITH HOLD FOR i180_cnt
 
END FUNCTION
 
FUNCTION i180_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i180_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i180_q()
            END IF
        #   NEXT OPTION "next"   #TQC-960343 mark
        ON ACTION next 
            CALL i180_fetch('N')
        ON ACTION previous 
            CALL i180_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i180_u()
            END IF
        #   NEXT OPTION "next"   #TQC-960343 mark
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i180_r()
            END IF
        #   NEXT OPTION "next"   #TQC-960343 mark
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i180_fetch('/')
        ON ACTION first
            CALL i180_fetch('F')
        ON ACTION last
            CALL i180_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0150-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_stp.stp02 IS NOT NULL THEN
                  LET g_doc.column1 = "stp02"
                  LET g_doc.value1 = g_stp.stp02
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
    CLOSE i180_cs
END FUNCTION
 
FUNCTION i180_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_stp.* LIKE stp1_file.*
    LET g_stp02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_stp.stp01 = '3'
        LET g_stp.stp1plant = g_plant #FUN-980008 add
        LET g_stp.stp1legal = g_legal #FUN-980008 add
        CALL i180_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_stp.stp02 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO stp1_file VALUES(g_stp.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_stp.stp02,SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("ins","stp1_file",g_stp.stp02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660120
            CONTINUE WHILE
        ELSE
            LET g_stp_t.* = g_stp.*                # 保存上筆資料
            SELECT stp02 INTO g_stp.stp02 FROM stp1_file
                WHERE stp02 = g_stp.stp02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i180_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
        l_sfb05 LIKE sfb_file.sfb05,
        l_sfb82 LIKE sfb_file.sfb82,
        l_sto05 LIKE sto_file.sto05,
        l_ima09 LIKE ima_file.ima09
 
    DISPLAY BY NAME
        g_stp.stp02,g_stp.stp021,g_stp.stp01, g_stp.stp03, g_stp.stp04, g_stp.stp05,
        g_stp.stp06, g_stp.stp07, g_stp.stp08, g_stp.stp09, g_stp.stp10,
        g_stp.stp11, g_stp.stp12, g_stp.stp13, g_stp.stp14, g_stp.stp15,
        g_stp.stp16, g_stp.stp17, g_stp.stp18, g_stp.stp19
        
    INPUT BY NAME
        g_stp.stp02,g_stp.stp021,g_stp.stp01, g_stp.stp03, g_stp.stp04, g_stp.stp05,
        g_stp.stp06, g_stp.stp07, g_stp.stp08, g_stp.stp09, g_stp.stp10,
        g_stp.stp11, g_stp.stp12, g_stp.stp13, g_stp.stp14, g_stp.stp15,
        g_stp.stp16, g_stp.stp17, g_stp.stp18, g_stp.stp19
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i180_set_entry(p_cmd)
          CALL i180_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        #FUN-4C0081
        AFTER FIELD stp14    #匯率             
           IF g_stp.stp12 =g_aza.aza17 THEN
              LET g_stp.stp14=1
              DISPLAY BY NAME g_stp.stp14
           END IF
        #--END
 
        AFTER FIELD stp02
            IF g_stp.stp02 IS NOT NULL THEN 
#FUN-AB0025 -----------mark start------------
#             #FUN-AA0059 ---------------------add tart-------------
#              IF NOT s_chk_item_no(g_stp.stp02,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 NEXT FIELD stp02
#              END IF
#             #FUN-AA0059 --------------------add end--------------- 
#FUN-AB0025 ----------mark end-------------
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_stp.stp02 != g_stp02_t ) THEN
                  SELECT count(*) INTO l_n FROM stp1_file
                   WHERE stp02 = g_stp.stp02
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_stp.stp02,-239,0)
                     NEXT FIELD stp02
                  END IF
               END IF
            END IF
 
        BEFORE FIELD stp07		## echihu 000117
            LET  l_stp07 = g_stp.stp07
 
        AFTER  FIELD stp07		## echihu 000117
            IF l_stp07 <> g_stp.stp07 THEN
               SELECT sto05 INTO l_sto05 FROM sto_file
               LET g_stp.stp08 = ((g_stp.stp07*g_stp.stp03)*(100- l_sto05)/100)
                                 -g_stp.stp19
               # 採變現價值 = 成品單位售價 * 期末數量 )  (推銷費用率%) 
               #              - 預計投入成本
               IF g_stp.stp05+g_stp.stp06> g_stp.stp08 THEN
                  LET  g_stp.stp15 = g_stp.stp08
               ELSE
                  LET  g_stp.stp15 = g_stp.stp05+g_stp.stp06
               END IF
            END IF
         ON ACTION controlp  # 查詢其他主檔資料
         CASE
             WHEN INFIELD(stp02)  #料號
#FUN-AA0059---------mod------------str-----------------             
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_stp.stp02
#                  CALL cl_create_qry() RETURNING g_stp.stp02
                   CALL q_sel_ima(FALSE, "q_ima","",g_stp.stp02,"","","","","",'' ) 
                       RETURNING  g_stp.stp02

#FUN-AA0059---------mod------------end----------------- 
#                  CALL FGL_DIALOG_SETBUFFER( g_stp.stp02 )
                  DISPLAY BY NAME g_stp.stp02
                  NEXT FIELD stp02
               #MOD-4B0258
              WHEN INFIELD(stp12) #幣別開窗
#               CALL q_azi(05,11,g_stp.stp12) RETURNING g_stp.stp12
#               CALL FGL_DIALOG_SETBUFFER( g_stp.stp12 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.default1 = g_stp.stp12
                CALL cl_create_qry() RETURNING g_stp.stp12
#               CALL FGL_DIALOG_SETBUFFER( g_stp.stp12 )
                DISPLAY BY NAME g_stp.stp12
                NEXT FIELD stp12
               #MOD-4B0258(end)
 
              #FUN-4B0065
              WHEN INFIELD(stp14) #匯率開窗
                 CALL s_rate(g_stp.stp12,g_stp.stp14) RETURNING g_stp.stp14
                 DISPLAY BY NAME g_stp.stp14
                 NEXT FIELD stp14
              #FUN-4B0065(end)
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
 
FUNCTION i180_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_stp.* TO NULL                #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i180_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i180_count
    FETCH i180_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i180_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stp.stp01,SQLCA.sqlcode,0)
        INITIALIZE g_stp.* TO NULL
    ELSE
        CALL i180_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i180_fetch(p_flstp)
    DEFINE
        p_flstp         LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flstp
        WHEN 'N' FETCH NEXT     i180_cs INTO g_stp.stp02
        WHEN 'P' FETCH PREVIOUS i180_cs INTO g_stp.stp02
        WHEN 'F' FETCH FIRST    i180_cs INTO g_stp.stp02
        WHEN 'L' FETCH LAST     i180_cs INTO g_stp.stp02
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
            FETCH ABSOLUTE g_jump i180_cs INTO g_stp.stp02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stp.stp01,SQLCA.sqlcode,0)
        INITIALIZE g_stp.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flstp
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_stp.* FROM stp1_file        # 重讀DB,因TEMP有不被更新特性
       WHERE stp02=g_stp.stp02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_stp.stp01,SQLCA.sqlcode,0)   #No.FUN-660120
        CALL cl_err3("sel","stp1_file",g_stp.stp02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660120
    ELSE
        CALL i180_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i180_show()
    LET g_stp_t.* = g_stp.*
#   DISPLAY BY NAME g_stp.* #FUN-980008 mod
    DISPLAY BY NAME g_stp.stp01,g_stp.stp02,g_stp.stp021,g_stp.stp03,
      g_stp.stp04,g_stp.stp05,g_stp.stp06,g_stp.stp07,g_stp.stp08,g_stp.stp09,
      g_stp.stp10,g_stp.stp11,g_stp.stp12,g_stp.stp13,g_stp.stp14,g_stp.stp15,
      g_stp.stp16,g_stp.stp17,g_stp.stp18,g_stp.stp19 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i180_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_stp.stp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_stp02_t = g_stp.stp02
    BEGIN WORK 
    OPEN i180_cl USING g_stp.stp02
    IF STATUS THEN
       CALL cl_err("OPEN i180_cl:", STATUS, 1)
       CLOSE i180_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i180_cl INTO g_stp.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stp.stp01,SQLCA.sqlcode,0)
        ROLLBACK WORK 
        RETURN
    END IF
    CALL i180_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i180_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_stp.*=g_stp_t.*
            CALL i180_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK 
            EXIT WHILE
        END IF
        UPDATE stp1_file SET stp1_file.* = g_stp.*    # 更新DB
            WHERE stp02=g_stp.stp02             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_stp.stp01,SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("upd","stp1_file",g_stp_t.stp02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660120
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i180_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i180_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_stp.stp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i180_cl USING g_stp.stp02
    IF STATUS THEN
       CALL cl_err("OPEN i180_cl:", STATUS, 1)
       CLOSE i180_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i180_cl INTO g_stp.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_stp.stp01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       CLOSE i180_cl
       RETURN
    END IF
    CALL i180_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "stp02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_stp.stp02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM stp1_file WHERE stp02=g_stp.stp02
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('',SQLCA.SQLCODE,0)   #No.FUN-660120
          CALL cl_err3("del","stp1_file",g_stp.stp02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660120
          ROLLBACK WORK
          CLOSE i180_cl
          RETURN
       ELSE
          CLEAR FORM
          OPEN i180_count
          FETCH i180_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i180_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i180_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i180_fetch('/')
          END IF
       END IF 
    END IF
    CLOSE i180_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i180_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("stp02,stp021",TRUE)
  END IF
END FUNCTION
 
FUNCTION i180_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("stp02,stp021",FALSE)
  END IF
END FUNCTION
#TQC-760197
#No.TQC-770126
#MOD-960141
