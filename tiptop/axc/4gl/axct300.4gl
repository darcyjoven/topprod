# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axct300.4gl
# Descriptions...: 每月人工製費工時維護作業
# Date & Author..: 96/01/18 By Roger
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: NO.TQC-630248 06/03/27 BY yiting 成本中心無控管
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
#
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770091 07/07/18 By Carol 成本中心加上[說明]欄位顯示
# Modify.........: No.MOD-780096 07/08/17 By Carol 調整欄位set_entry/no_entry ==>before field cck03-> set_no_entry
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990022 09/09/09 By liuxqa 非負控管。
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-950046 10/03/05 By wuxj   新增列印功能
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模组table重新分类
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cck   RECORD LIKE cck_file.*,
    g_cck_t RECORD LIKE cck_file.*,
    g_cck01_t LIKE cck_file.cck01,
    g_cck02_t LIKE cck_file.cck02,
    g_cck_w_t LIKE cck_file.cck_w,
    g_cck03_t LIKE cck_file.cck03,
    g_cck_w_desc         LIKE gem_file.gem02,    #MOD-770091 add
     g_wc,g_sql          string  #No.FUN-580092 HCN
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680122 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680122 SMALLINT
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0146
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cck.* TO NULL
    INITIALIZE g_cck_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cck_file WHERE cck01 = ? AND cck02 = ? AND cck_w = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 5 LET p_col = 14
    OPEN WINDOW t300_w AT p_row,p_col
        WITH FORM "axc/42f/axct300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t300_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t300_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t300_cs()
    CLEAR FORM
   INITIALIZE g_cck.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cck01,cck02,cck_w,cck03,cck04,cck05,cck06,cck07,
        cckuser,cckgrup,cckmodu,cckdate
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
#NO.TQC-630248 start--
        ON ACTION controlp
            CASE
                 WHEN INFIELD(cck_w) # Dept CODE
#MOD-770091-modify 
#依參數設定查詢相關資料
                    CALL cl_init_qry_var()
                    CASE g_ccz.ccz06
                         WHEN '4'
                              LET g_qryparam.form  = "q_eca1"
                         WHEN '3'
                              LET g_qryparam.form  = "q_ecd3"
                         OTHERWISE
                              LET g_qryparam.form  = "q_gem"
                    END CASE
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cck_w
                 OTHERWISE EXIT CASE
            END CASE
#MOD-770091-modify-end
#NO.TQC-630248 end--
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cckuser', 'cckgrup') #FUN-980030
 
    LET g_sql="SELECT cck01,cck02,cck_w FROM cck_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY cck01,cck02,cck_w"
    PREPARE t300_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t300_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t300_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cck_file WHERE ",g_wc CLIPPED
    PREPARE t300_precount FROM g_sql
    DECLARE t300_count CURSOR FOR t300_precount
END FUNCTION
 
FUNCTION t300_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t300_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t300_q()
            END IF
        ON ACTION next
            CALL t300_fetch('N')
        ON ACTION previous
            CALL t300_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t300_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t300_r()
            END IF
        ON ACTION help
                     CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
      #FUN-950046  --- add--- begin
        ON ACTION output
           LET g_action_choice = "output"
           IF cl_chk_act_auth() THEN
              CALL t300_out()
           END IF
      #FUN-950046  --- add---  end 
        ON ACTION jump
            CALL t300_fetch('/')
        ON ACTION first
            CALL t300_fetch('F')
        ON ACTION last
            CALL t300_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0019-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_cck.cck01 IS NOT NULL THEN
                  LET g_doc.column1 = "cck01"
                  LET g_doc.value1 = g_cck.cck01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0019-------add--------end----
 
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
    CLOSE t300_cs
END FUNCTION
 
 
FUNCTION t300_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cck.* TO NULL
    LET g_cck.cck03=0
    LET g_cck.cck04=0
    LET g_cck.cck05=0
    LET g_cck.cck06=0
    LET g_cck.cck07=0
    LET g_cck01_t = NULL
    LET g_cck02_t = NULL
    LET g_cck_w_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cck.cckacti ='Y'                   # 有效的資料
        LET g_cck.cckuser = g_user
        LET g_cck.cckoriu = g_user #FUN-980030
        LET g_cck.cckorig = g_grup #FUN-980030
        LET g_cck.cckgrup = g_grup               # 使用者所屬群
        LET g_cck.cckdate = g_today
        CALL t300_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_cck.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cck.cck01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_cck.ccklegal = g_legal   #FUN-A50075
        INSERT INTO cck_file VALUES(g_cck.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins cck:',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cck_file",g_cck.cck01,g_cck.cck02,SQLCA.sqlcode,"","ins cck:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_cck_t.* = g_cck.*                # 保存上筆資料
            SELECT cck01,cck02,cck_w INTO g_cck.cck01,g_cck.cck02,g_cck.cck_w FROM cck_file
                WHERE cck01 = g_cck.cck01
                  AND cck02 = g_cck.cck02
                  AND cck_w = g_cck.cck_w
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t300_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_cnt           LIKE type_file.num5     #NO.TQC-630248        #No.FUN-680122 SMALLINT
 
    INPUT BY NAME g_cck.cckoriu,g_cck.cckorig,
        g_cck.cck01,g_cck.cck02,g_cck.cck_w,
        g_cck.cck03,g_cck.cck04,g_cck.cck05,
        g_cck.cck06,g_cck.cck07,
        g_cck.cckuser,g_cck.cckgrup,g_cck.cckmodu,g_cck.cckdate
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t300_set_entry(p_cmd)
          CALL t300_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
#No.TQC-990022 add --begin
        AFTER FIELD cck01 
            IF NOT cl_null(g_cck.cck01) THEN
               IF g_cck.cck01 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD cck01
               END IF
             END IF
#No.TQC-990022 add --end
 
 
        AFTER FIELD cck02
#No.TQC-990022 add --begin
            IF NOT cl_null(g_cck.cck02) THEN
               IF g_cck.cck02 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD cck02
               END IF
             END IF
#No.TQC-990022 add --end
            IF g_ccz.ccz06 = '1' THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND
                  (g_cck.cck01 != g_cck01_t OR
                   g_cck.cck02 != g_cck02_t )) THEN
                   SELECT count(*) INTO l_n FROM cck_file
                       WHERE cck01 = g_cck.cck01
                         AND cck02 = g_cck.cck02
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err('count:',-239,0)
                       NEXT FIELD cck01
                   END IF
               END IF
            END IF
 
        BEFORE FIELD cck_w
            IF g_ccz.ccz06 = '1' THEN NEXT FIELD cck03 END IF
 
        AFTER FIELD cck_w
#MOD-770091-modify
          IF g_cck.cck_w IS NOT NULL THEN
#             #NO.TQC-630248 start---
#             SELECT COUNT(*) INTO l_cnt 
#               FROM gem_file WHERE gem01=g_cck.cck_w
#                AND gemacti='Y'
#             IF l_cnt = 0 THEN 
#                 CALL cl_err('','mfg1318',0) 
#                 NEXT FIELD cck_w
#             END IF
#             #NO.TQC-630248 end---
#MOD-770091-modify-end
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
               (g_cck.cck01 != g_cck01_t OR
                g_cck.cck02 != g_cck02_t OR
                g_cck.cck_w != g_cck_w_t )) THEN
                SELECT count(*) INTO l_n FROM cck_file
                    WHERE cck01 = g_cck.cck01
                      AND cck02 = g_cck.cck02
                      AND cck_w = g_cck.cck_w
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD cck01
                END IF
            END IF
#MOD-770091-add
            CALL t300_cck_w('a',g_cck.cck_w)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('cck_w',g_errno,1)
               NEXT FIELD cck_w
            END IF  
#MOD-770091-add-end
          END IF
 
#MOD-780096-modify
            CALL t300_set_entry(p_cmd)
 
        BEFORE FIELD cck03
#           CALL t300_set_entry(p_cmd)
            CALL t300_set_no_entry(p_cmd)
#MOD-780096-modify-end
 
        AFTER FIELD cck03,cck04,cck05
 
#No.TQC-990022 add --begin
            IF NOT cl_null(g_cck.cck03) THEN
               IF g_cck.cck03 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD cck03
               END IF
             END IF
            IF NOT cl_null(g_cck.cck04) THEN
               IF g_cck.cck04 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD cck04
               END IF
             END IF
            IF NOT cl_null(g_cck.cck05) THEN
               IF g_cck.cck05 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD cck05
               END IF
             END IF
#No.TQC-990022 add --end
            IF g_cck.cck05>0
               THEN LET g_cck.cck06=g_cck.cck03/g_cck.cck05
                    LET g_cck.cck07=g_cck.cck04/g_cck.cck05
               ELSE LET g_cck.cck06=0
                    LET g_cck.cck07=0
            END IF
            DISPLAY BY NAME g_cck.cck06,g_cck.cck07
            CALL t300_set_no_entry(p_cmd)
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_cck.cckuser = s_get_data_owner("cck_file") #FUN-C10039
           LET g_cck.cckgrup = s_get_data_group("cck_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_cck.cck_w) THEN LET g_cck.cck_w = ' ' END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD cck01
            END IF
 
#NO.TQC-630248 start--
        ON ACTION controlp
            CASE
                 WHEN INFIELD(cck_w) # Dept CODE
#MOD-770091-modify
                    CALL cl_init_qry_var()
                    CASE g_ccz.ccz06
                    WHEN '4'
                         LET g_qryparam.form     = "q_eca1"
                    WHEN '3'
                         LET g_qryparam.form     = "q_ecd3"
                    OTHERWISE 
                         LET g_qryparam.form     = "q_gem"
                    END CASE
                    LET g_qryparam.default1 = g_cck.cck_w
                    CALL cl_create_qry() RETURNING g_cck.cck_w
                    DISPLAY BY NAME g_cck.cck_w
                    NEXT FIELD cck_w
#MOD-770091-modify-end
                 OTHERWISE EXIT CASE
            END CASE
#NO.TQC-630248 end--
      #MOD-650015 --start
      #   ON ACTION CONTROLO                        # 沿用所有欄位
      #       IF INFIELD(cck01) THEN
      #           LET g_cck.* = g_cck_t.*
      #           DISPLAY BY NAME g_cck.*
      #           NEXT FIELD cck01
      #       END IF
      #MOD-650015 --end
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
 
FUNCTION t300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cck.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t300_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t300_count
    FETCH t300_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t300_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cck.* TO NULL
    ELSE
        CALL t300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t300_fetch(p_flcck)
    DEFINE
        p_flcck          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flcck
        WHEN 'N' FETCH NEXT     t300_cs INTO g_cck.cck01,g_cck.cck02,g_cck.cck_w
        WHEN 'P' FETCH PREVIOUS t300_cs INTO g_cck.cck01,g_cck.cck02,g_cck.cck_w
        WHEN 'F' FETCH FIRST    t300_cs INTO g_cck.cck01,g_cck.cck02,g_cck.cck_w
        WHEN 'L' FETCH LAST     t300_cs INTO g_cck.cck01,g_cck.cck02,g_cck.cck_w
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
            FETCH ABSOLUTE g_jump t300_cs INTO g_cck.cck01,g_cck.cck02,g_cck.cck_w
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cck.cck01,SQLCA.sqlcode,0)
        INITIALIZE g_cck.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcck
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cck.* FROM cck_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cck01 = g_cck.cck01 AND cck02 = g_cck.cck02 AND cck_w = g_cck.cck_w
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cck.cck01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","cck_file",g_cck.cck01,g_cck.cck02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
        LET g_data_owner=g_cck.cckuser           #FUN-4C0061權限控管
        LET g_data_group=g_cck.cckgrup
        CALL t300_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t300_show()
    LET g_cck_t.* = g_cck.*
    DISPLAY BY NAME g_cck.cckoriu,g_cck.cckorig,
        g_cck.cck01,g_cck.cck02,g_cck.cck_w,
        g_cck.cck03,g_cck.cck04,g_cck.cck05,
        g_cck.cck06,g_cck.cck07,
        g_cck.cckuser,g_cck.cckgrup,g_cck.cckmodu,g_cck.cckdate
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    CALL t300_cck_w('d',g_cck.cck_w)          #MOD-770091 add
END FUNCTION
 
#MOD-770091-add
FUNCTION t300_cck_w(p_cmd,p_cck_w)
    DEFINE p_cmd     LIKE type_file.chr1, 
           p_cck_w   LIKE cck_file.cck_w,
           l_acti    LIKE gem_file.gemacti,
           l_desc    LIKE gem_file.gem02
 
    LET g_errno = ' '
    CASE g_ccz.ccz06
    WHEN '4' 
         SELECT eca02,ecaacti INTO l_desc,l_acti FROM eca_file
          WHERE eca01 = p_cck_w
    WHEN '3' 
         SELECT ecd02,ecdacti INTO l_desc,l_acti FROM ecd_file
          WHERE ecd01 = p_cck_w
    WHEN '2' 
         SELECT gem02,gemacti INTO l_desc,l_acti FROM gem_file
          WHERE gem01 = p_cck_w
    WHEN '1'
      LET l_desc = '' 
    END CASE
    CASE WHEN SQLCA.SQLCODE = 100 
              CASE g_ccz.ccz06
                   WHEN '4' LET g_errno = 'mfg4011'
                   WHEN '3' LET g_errno = 'aec-015'
                   WHEN '2' LET g_errno = 'mfg4001'
              END CASE
              LET l_desc = NULL
              LET l_acti = NULL
         WHEN l_acti='N' 
              LET g_errno = '9028'
         OTHERWISE    
              LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_desc   TO FORMONLY.desc
    END IF
 
END FUNCTION
#MOD-770091-add-end
 
FUNCTION t300_u()
    IF g_cck.cck01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cck01_t = g_cck.cck01
    LET g_cck02_t = g_cck.cck02
    LET g_cck_w_t = g_cck.cck_w
    BEGIN WORK
 
    OPEN t300_cl USING g_cck.cck01,g_cck.cck02,g_cck.cck_w
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_cck.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
                   # 有效的資料
    IF cl_null(g_cck.cckacti) THEN LET g_cck.cckacti ='Y'  END IF
    IF cl_null(g_cck.cckuser) THEN LET g_cck.cckuser = g_user END IF
             # 使用者所屬群
    IF cl_null(g_cck.cckgrup) THEN LET g_cck.cckgrup = g_grup END IF
    LET g_cck.cckmodu=g_user                     #修改者
    LET g_cck.cckdate = g_today                  #修改日期
    CALL t300_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t300_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cck.*=g_cck_t.*
            CALL t300_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cck_file SET cck_file.* = g_cck.*    # 更新DB
            WHERE cck01 = g_cck_t.cck01 AND cck02 = g_cck_t.cck02 AND cck_w = g_cck_t.cck_w             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cck.cck01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("upd","cck_file",g_cck01_t,g_cck02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t300_r()
    IF g_cck.cck01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t300_cl USING g_cck.cck01,g_cck.cck02,g_cck.cck_w
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_cck.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cck.cck01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t300_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cck01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cck.cck01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cck_file WHERE cck01 = g_cck.cck01
                              AND cck02 = g_cck.cck02
                              AND cck_w = g_cck.cck_w
       CLEAR FORM
       OPEN t300_count
       FETCH t300_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t300_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t300_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t300_fetch('/')
       END IF
    END IF
    CLOSE t300_cl
    COMMIT WORK
END FUNCTION

#FUN-950046  ----begin--- 
FUNCTION t300_out()
  DEFINE l_sql    STRING
  DEFINE l_wc     STRING
  DEFINE l_desc   LIKE eca_file.eca02

    IF cl_null(g_wc) AND NOT cl_null(g_cck.cck01) THEN
        LET g_wc=" cck01='",g_cck.cck01,"' AND cck02 = '",g_cck.cck02,"'",
                 " AND cck_w ='",g_cck.cck_w,"'"
    END IF
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    LET l_wc = g_wc

    CASE g_ccz.ccz06
    WHEN '4'
       LET l_sql = " SELECT cck01,cck02,cck_w,eca02 a,cck03,cck04,cck05,cck06,cck07 ",
                   " FROM cck_file LEFT OUTER JOIN eca_file ON cck_w = eca01",
                   " WHERE ",l_wc CLIPPED
    WHEN '3'
       LET l_sql = " SELECT cck01,cck02,cck_w,ecd02 a,cck03,cck04,cck05,cck06,cck07 ",
                   " FROM cck_file LEFT OUTER JOIN ecd_file ON cck_w = ecd01",
                   " WHERE ",l_wc CLIPPED
    WHEN '2'
       LET l_sql = " SELECT cck01,cck02,cck_w,gem02 a,cck03,cck04,cck05,cck06,cck07 ",
                   " FROM cck_file LEFT OUTER JOIN gem_file ON cck_w = gem01",
                   " WHERE ",l_wc CLIPPED
    WHEN '1'
       LET l_sql = " SELECT cck01,cck02,cck_w,cck03,cck04,cck05,cck06,cck07 FROM cck_file ",
                   " WHERE ",l_wc CLIPPED
    END CASE
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(l_wc,'cck01,cck02,cck_w,cck03,cck04,cck05,cck06,cck07')
            RETURNING l_wc
    ELSE
       LET l_wc = ''
    END IF

    CALL cl_prt_cs1('axct300','axct300',l_sql,l_wc)
END FUNCTION
#FUN-950046   ----end---

FUNCTION t300_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cck01,cck02,cck_w",TRUE)
  END IF
 
  IF INFIELD(cck03) OR  (NOT g_before_input_done) THEN
     IF g_ccz.ccz06 = '1' THEN
        CALL cl_set_comp_entry("cck_w",TRUE)
     END IF
  END IF
END FUNCTION
 
FUNCTION t300_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cck01,cck02,cck_w",FALSE)
  END IF
 
  IF INFIELD(cck03) OR  (NOT g_before_input_done) THEN
     IF g_ccz.ccz06 = '1' THEN
        CALL cl_set_comp_entry("cck_w",FALSE)
     END IF
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

