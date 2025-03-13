# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: acoi510.4gl
# Descriptions...: 材料/成品明細資料維護作業(內部)
# Date & Author..: 05/01/18 By wujie
# Modify.........: 05/02/25 MOD-490398 By Carrier 1.cor14調整  2.去掉"確認"功能
# Modify.........: No.FUN-550036 05/05/23 By Trisy 單據編號加大
# MOdify.........: No.FUN-570109 05/07/13 By day   修正建檔程式key值是否可更改
# MOdify.........: No.TQC-660045 06/06/13 BY hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/09 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cor   RECORD LIKE cor_file.*,
    g_cor_t RECORD LIKE cor_file.*,
    g_cor01_t LIKE cor_file.cor01,
    g_cor02_t LIKE cor_file.cor02,
    l_ac                LIKE type_file.num5,          #No.FUN-680069 SMALLINT
     g_wc,g_wc2,g_sql    STRING  #No.FUN-580092 HCN        #No.FUN-680069
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_before_input_done   STRING     #No.FUN-680069
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0063
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    INITIALIZE g_cor.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM cor_file WHERE  cor01 = ? AND cor02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i510_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i510_w AT p_row,p_col WITH FORM "aco/42f/acoi510"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i510_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i510_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i510_curs()
    CLEAR FORM
    INITIALIZE g_cor.* TO NULL    #No.FUN-750051
    INPUT BY NAME g_cor.cor00 WITHOUT DEFAULTS
       AFTER FIELD cor00
          IF cl_null(g_cor.cor00) THEN
             NEXT FIELD cor00
          ELSE
             CALL i510_cor14()
          END IF
 
       ON ACTION controlg       #TQC-860021
          CALL cl_cmdask()      #TQC-860021
 
       ON IDLE g_idle_seconds   #TQC-860021
          CALL cl_on_idle()     #TQC-860021
          CONTINUE INPUT        #TQC-860021
 
       ON ACTION about          #TQC-860021
          CALL cl_about()       #TQC-860021
 
       ON ACTION help           #TQC-860021
          CALL cl_show_help()   #TQC-860021
    END INPUT
    CONSTRUCT BY NAME g_wc ON                      # 螢幕上取條件
        cor01,cor02,cor03,cor07,cor08,cor04,cor09,cor10,cor12,cor13,cor11,cor05,cor14,
        cor06,cor15,
        coruser,corgrup,cormodu,cordate,coracti,
       #FUN-840202   ---start---
        corud01,corud02,corud03,corud04,corud05,
        corud06,corud07,corud08,corud09,corud10,
        corud11,corud12,corud13,corud14,corud15
       #FUN-840202    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(cor05)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_cob"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cor05
              WHEN INFIELD(cor06)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_cna"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cor06
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
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND coruser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND corgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND corgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('coruser', 'corgrup')
    #End:FUN-980030
 
 
 
    LET g_sql="SELECT cor01,cor02 FROM cor_file ", # 組合出 SQL 指令
              " WHERE cor00 = '",g_cor.cor00,"'",
              "   AND ",g_wc CLIPPED,
              " ORDER BY cor01,cor02"
    PREPARE i510_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i510_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i510_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cor_file WHERE cor00 = '",g_cor.cor00,"'",
        "   AND ",g_wc CLIPPED
    PREPARE i510_precount FROM g_sql
    DECLARE i510_count
        SCROLL CURSOR WITH HOLD FOR i510_precount
END FUNCTION
 
FUNCTION i510_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i510_q()
            END IF
        ON ACTION next
            CALL i510_fetch('N')
        ON ACTION previous
            CALL i510_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i510_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i510_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i510_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
         #No.MOD-490398  --begin
        #ON ACTION confirm
        #    LET g_action_choice="confirm"
        #    IF cl_chk_act_auth() THEN
        #       CALL i510_y()
        #    END IF
        #ON ACTION undo_confirm
        #    LET g_action_choice="undo_confirm"
        #    IF cl_chk_act_auth() THEN
        #       CALL i510_z()
        #    END IF
         #No.MOD-490398  --end
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL i510_fetch('/')
        ON ACTION first
            CALL i510_fetch('F')
        ON ACTION last
            CALL i510_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         #No.FUN-6A0168-------add--------str----
         ON ACTION related_document             #相關文件"                        
          LET g_action_choice="related_document"           
             IF cl_chk_act_auth() THEN                     
                IF g_cor.cor01 IS NOT NULL THEN            
                   LET g_doc.column1 = "cor01"               
                   LET g_doc.column2 = "cor02"               
                   LET g_doc.value1 = g_cor.cor01            
                   LET g_doc.value2 = g_cor.cor02           
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
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i510_cs
END FUNCTION
 
FUNCTION i510_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    INPUT BY NAME
        g_cor.cor01,g_cor.cor02,   #No.FUN-570109
        g_cor.cor05,g_cor.cor14,g_cor.cor06,g_cor.cor15,
      #FUN-840202     ---start---
        g_cor.corud01,g_cor.corud02,g_cor.corud03,g_cor.corud04,
        g_cor.corud05,g_cor.corud06,g_cor.corud07,g_cor.corud08,
        g_cor.corud09,g_cor.corud10,g_cor.corud11,g_cor.corud12,
        g_cor.corud13,g_cor.corud14,g_cor.corud15 
      #FUN-840202     ----end----
        WITHOUT DEFAULTS
    #No.FUN-550036 --start--
    BEFORE INPUT
         CALL cl_set_docno_format("cor01")
    #No.FUN-550036 ---end---
 
#No.FUN-570109-begin
        LET g_before_input_done = FALSE
        CALL i510_set_entry(p_cmd)
        CALL i510_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
#No.FUN-570109-end
 
        BEFORE FIELD cor14
            IF  cl_null(g_cor.cor00) THEN
               NEXT FIELD cor00
            END IF
        AFTER FIELD cor14
            IF cl_null(g_cor.cor14) THEN
               NEXT FIELD cor14
            END IF
        AFTER FIELD cor15
            IF cl_null(g_cor.cor15) THEN
               NEXT FIELD cor15
            END IF
        AFTER FIELD cor05
            IF cl_null(g_cor.cor05) THEN
               NEXT FIELD cor05
            ELSE
               SELECT COUNT(*) INTO l_n FROM cob_file
                WHERE cob01 = g_cor.cor05
               IF l_n <= 0 THEN
                LET g_cor.cor05 = null
                NEXT FIELD cor05
               END IF
            END IF
        AFTER FIELD cor06
            IF cl_null(g_cor.cor06) THEN
               NEXT FIELD cor06
            ELSE
               SELECT COUNT(*) INTO l_n FROM cna_file
                WHERE cna01 = g_cor.cor06
               IF l_n <= 0 THEN
                LET g_cor.cor06 = null
                NEXT FIELD cor06
               END IF
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD corud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD corud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(cor05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cob"
                LET g_qryparam.default1 = g_cor.cor05
                CALL cl_create_qry() RETURNING g_cor.cor05
                DISPLAY BY NAME g_cor.cor05
              WHEN INFIELD(cor06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_cor.cor06
                CALL cl_create_qry() RETURNING g_cor.cor06
                DISPLAY BY NAME g_cor.cor06
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
 
 
FUNCTION i510_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cor.* TO NULL                #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i510_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i510_count
    FETCH i510_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i510_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0)
        INITIALIZE g_cor.* TO NULL
    ELSE
        CALL i510_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i510_fetch(p_flcop)
    DEFINE
        p_flcop          LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_abso           LIKE type_file.num10         #No.FUN-680069 INTEGER
 
    CASE p_flcop
        WHEN 'N' FETCH NEXT     i510_cs INTO g_cor.cor01,g_cor.cor02
        WHEN 'P' FETCH PREVIOUS i510_cs INTO g_cor.cor01,g_cor.cor02
        WHEN 'F' FETCH FIRST    i510_cs INTO g_cor.cor01,g_cor.cor02
        WHEN 'L' FETCH LAST     i510_cs INTO g_cor.cor01,g_cor.cor02
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i510_cs INTO g_cor.cor01,g_cor.cor02
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0)
        INITIALIZE g_cor.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcop
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cor.* FROM cor_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cor01 = g_cor.cor01 AND cor02 = g_cor.cor02 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cor_file",g_cor.cor01,g_cor.cor02,SQLCA.sqlcode,"","",1) #TQC-660045
    ELSE
        CALL i510_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i510_show()
    LET g_cor_t.* = g_cor.*
    DISPLAY BY NAME
        g_cor.cor00,g_cor.cor01,g_cor.cor02,g_cor.cor03,g_cor.cor07,
        g_cor.cor04,g_cor.cor05,g_cor.cor09,g_cor.cor12,g_cor.cor14,g_cor.cor10,
        g_cor.cor13,g_cor.cor08,g_cor.cor06,g_cor.cor11,g_cor.cor15,
        g_cor.coruser,g_cor.corgrup,g_cor.cormodu,
        g_cor.cordate,g_cor.coracti,
       #FUN-840202     ---start---
        g_cor.corud01,g_cor.corud02,g_cor.corud03,g_cor.corud04,
        g_cor.corud05,g_cor.corud06,g_cor.corud07,g_cor.corud08,
        g_cor.corud09,g_cor.corud10,g_cor.corud11,g_cor.corud12,
        g_cor.corud13,g_cor.corud14,g_cor.corud15 
       #FUN-840202     ----end----
 
    CALL i510_cor04('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i510_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cor.cor01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cor.* FROM cor_file
     WHERE cor01=g_cor.cor01 AND cor02=g_cor.cor02
    IF g_cor.coracti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cor.corconf='Y' THEN
        CALL cl_err('','9022',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cor01_t = g_cor.cor01
    LET g_cor02_t = g_cor.cor02
    BEGIN WORK
 
    OPEN i510_cl USING g_cor.cor01,g_cor.cor02
    IF STATUS THEN
       CALL cl_err("OPEN i510_cl:", STATUS, 1)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i510_cl INTO g_cor.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cor.cormodu=g_user                     #更改者
    LET g_cor.cordate = g_today                  #更改日期
    CALL i510_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i510_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cor.*=g_cor_t.*
            CALL i510_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cor_file SET
                            cor_file.cor05 = g_cor.cor05,
                            cor_file.cor14 = g_cor.cor14,
                            cor_file.cor06 = g_cor.cor06,
                            cor_file.cor15 = g_cor.cor15,
                                  #FUN-840202 --start--
                            cor_file.corud01 = g_cor.corud01,
                            cor_file.corud02 = g_cor.corud02,
                            cor_file.corud03 = g_cor.corud03,
                            cor_file.corud04 = g_cor.corud04,
                            cor_file.corud05 = g_cor.corud05,
                            cor_file.corud06 = g_cor.corud06,
                            cor_file.corud07 = g_cor.corud07,
                            cor_file.corud08 = g_cor.corud08,
                            cor_file.corud09 = g_cor.corud09,
                            cor_file.corud10 = g_cor.corud10,
                            cor_file.corud11 = g_cor.corud11,
                            cor_file.corud12 = g_cor.corud12,
                            cor_file.corud13 = g_cor.corud13,
                            cor_file.corud14 = g_cor.corud14,
                            cor_file.corud15 = g_cor.corud15 
                                  #FUN-840202 --end--
            WHERE cor01 = g_cor.cor01 AND cor02 = g_cor.cor02              # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cor_file",g_cor01_t,g_cor02_t,SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i510_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i510_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cor.cor01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cor.corconf='Y' THEN RETURN END IF
    BEGIN WORK
 
    OPEN i510_cl USING g_cor.cor01,g_cor.cor02
    IF STATUS THEN
       CALL cl_err("OPEN i510_cl:", STATUS, 1)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i510_cl INTO g_cor.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i510_show()
    IF cl_exp(0,0,g_cor.coracti) THEN
        LET g_chr=g_cor.coracti
        IF g_cor.coracti='Y' THEN
            LET g_cor.coracti='N'
        ELSE
            LET g_cor.coracti='Y'
        END IF
        UPDATE cor_file
            SET coracti=g_cor.coracti
            WHERE cor01 = g_cor.cor01 AND cor02 = g_cor.cor02 
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cor_file",g_cor.cor01,g_cor.cor02,SQLCA.sqlcode,"","",1) #TQC-660045
            LET g_cor.coracti=g_chr
        END IF
        DISPLAY BY NAME g_cor.coracti
    END IF
    CLOSE i510_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i510_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cor.cor01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cor.coracti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cor.corconf='Y' THEN RETURN END IF
    BEGIN WORK
 
    OPEN i510_cl USING g_cor.cor01,g_cor.cor02
    IF STATUS THEN
       CALL cl_err("OPEN i510_cl:", STATUS, 1)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i510_cl INTO g_cor.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i510_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cor01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cor02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cor.cor01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cor.cor02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cor_file WHERE cor01 = g_cor.cor01 AND cor02=g_cor.cor02
       IF STATUS THEN
#         CALL cl_err('del cor:',STATUS,1) #No.TQC-660045
          CALL cl_err3("del","cor_file",g_cor.cor01,g_cor.cor02,STATUS,"","del cor:",1) #TQC-660045
          ROLLBACK WORK CLOSE i510_cl RETURN
       END IF
        #No.MOD-490398  --begin
       #MESSAGE "update tlf910 ..."
       #IF SQLCA.SQLCODE THEN
       #   CALL cl_err('upd tlf910:',STATUS,1)
       #   ROLLBACK WORK CLOSE i510_cl RETURN
       #END IF
        #No.MOD-490398  --end
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980002 add azoplant,azolegal
          VALUES ('acoi510',g_user,g_today,g_msg,g_cor.cor01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
       CLEAR FORM
       OPEN i510_count
       FETCH i510_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i510_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i510_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i510_fetch('/')
       END IF
    END IF
    CLOSE i510_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i510_cor04(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02
 
    LET g_errno = ' '
    SELECT ima02 INTO l_ima02
           FROM ima_file WHERE ima01 = g_cor.cor04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4106'
                                   LET l_ima02 = ' '
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_ima02 TO FORMONLY.ima02
    END IF
END FUNCTION
 
 
FUNCTION i510_y()
 DEFINE l_cor    RECORD LIKE cor_file.*
 DEFINE only_one LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
 DEFINE l_sum    LIKE cod_file.cod05
 DEFINE l_qty    LIKE cod_file.cod09
 DEFINE l_tot    LIKE cop_file.cop16
 DEFINE l_tot2   LIKE cop_file.cop16
 DEFINE l_seq    LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_cop16  LIKE cop_file.cop16
 DEFINE l_coc01  LIKE coc_file.coc01
 
   IF g_cor.cor01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cor.* FROM cor_file
     WHERE cor01=g_cor.cor01 AND cor02=g_cor.cor02
   IF g_cor.corconf='Y' THEN RETURN END IF
   IF g_cor.coracti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
   END IF
   #開窗整批審核....
   OPEN WINDOW i510_y AT 9,29 WITH FORM "aco/42f/acoi510_y"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("acoi510_y")
 
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF only_one IS NULL THEN NEXT FIELD only_one END IF
      IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i510_y RETURN END IF
   IF only_one = '1'
      THEN LET g_wc = " cor01 = '",g_cor.cor01,"' ",
                      "  AND cor02 =",g_cor.cor02
   ELSE
      CONSTRUCT BY NAME g_wc ON
        cor01,cor03,cor07,cor06
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
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i510_y RETURN END IF
   END IF
 
   IF NOT cl_confirm('aap-222') THEN CLOSE WINDOW i510_y RETURN END IF
 
   LET g_sql = " SELECT * FROM cor_file" ,
               "  WHERE corconf='N' ",
               "    AND ",g_wc CLIPPED
   PREPARE firm_pre FROM g_sql
   DECLARE firm_cs CURSOR FOR firm_pre
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i510_cl USING g_cor.cor01,g_cor.cor02
   IF STATUS THEN
      CALL cl_err("OPEN i510_cl:", STATUS, 1)
      CLOSE i510_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i510_cl INTO g_cor.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   LET g_cnt = 0
   FOREACH firm_cs INTO l_cor.*
      IF STATUS THEN LET g_success='N' EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      UPDATE cor_file SET corconf='Y'
       WHERE cor01 = l_cor.cor01
         AND cor02 = l_cor.cor02
      IF STATUS THEN
#        CALL cl_err('upd corconf',STATUS,0) #No.TQC-660045
         CALL cl_err3("upd","cor_file",l_cor.cor01,l_cor.cor02,STATUS,"","upd corconf",1) #TQC-660045
         LET g_success='N'
      END IF
   END FOREACH
   CLOSE WINDOW i510_y
   IF g_cnt = 0 THEN LET g_success='N' END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT corconf INTO g_cor.corconf FROM cor_file
    WHERE cor01 = g_cor.cor01 AND cor02=g_cor.cor02
   DISPLAY BY NAME g_cor.corconf
END FUNCTION
 
FUNCTION i510_z()
   DEFINE l_cnt  LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   IF g_cor.cor01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cor.* FROM cor_file WHERE cor01=g_cor.cor01
   IF g_cor.corconf='N' THEN RETURN END IF
   IF g_cor.coracti = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i510_cl USING g_cor.cor01,g_cor.cor02
   IF STATUS THEN
      CALL cl_err("OPEN i510_cl:", STATUS, 1)
      CLOSE i510_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i510_cl INTO g_cor.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cor.cor01,SQLCA.sqlcode,0)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   UPDATE cor_file SET corconf='N'
    WHERE cor01 = g_cor.cor01
      AND cor02 = g_cor.cor02
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","cor_file",g_cor.cor01,g_cor.cor02,STATUS,"","upd cofconf",1) #TQC-660045
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT corconf INTO g_cor.corconf FROM cor_file
    WHERE cor01 = g_cor.cor01 AND cor02 = g_cor.cor02
   DISPLAY BY NAME g_cor.corconf
END FUNCTION
 
 
FUNCTION i510_cor14()
DEFINE   lsb_item   base.StringBuffer,
         lsb_value  base.StringBuffer,
         l_item     LIKE cor_file.cor08,         #No.FUN-680069 VARCHAR(20)
         l_value    LIKE ze_file.ze03            #No.FUN-680069 VARCHAR(40)
   IF cl_null(g_cor.cor00) THEN
      RETURN
   END IF
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET lsb_item  = base.StringBuffer.create()
   LET lsb_value = base.StringBuffer.create()
   CASE g_cor.cor00
      WHEN '1'
        LET l_item = '1,2,3'
        CALL cl_getmsg('aco-208',g_lang) RETURNING l_value
        CALL lsb_value.append(l_value CLIPPED || ",")
        CALL lsb_item.append(l_item CLIPPED || ",")
      WHEN '2'
         LET l_item = '1,2,3,4'        #No.MOD-490398
        CALL cl_getmsg('aco-209',g_lang) RETURNING l_value
        CALL lsb_value.append(l_value CLIPPED || ",")
        CALL lsb_item.append(l_item CLIPPED || ",")
      OTHERWISE
        EXIT CASE
   END CASE
   CALL cl_set_combo_items('cor14',lsb_item.toString(),lsb_value.toString())
END FUNCTION
#No.FUN-570109-begin
FUNCTION i510_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("cor01,cor02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i510_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("cor01,cor02",FALSE)
   END IF
END FUNCTION
#No.FUN-570109-end
#Patch....NO.TQC-610035 <001> #
