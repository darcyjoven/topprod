# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxi010.4gl
# Descriptions...: 保稅系統單據性質資料維護作業
# Date & Author..: 96/07/18 By Star
# Modify.........: No.MOD-530451 05/03/26 By kim 設定Default值
# Modify.........: No.FUN-550033 05/05/11 By ice 編號方法增加3.依年周
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-580176 05/09/07 By Nicola 若勾選自動編號則"編號方式"應不可空白
# Modify.........: NO.FUN-590002 05/12/27 By Monster radio type 應都要給預設值
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/12 By ice cl_err3訊息修改
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換
# Modify.........: No.FUN-6A0007 06/10/12 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0046 06/10/18 By jamie 1.FUNCTION i010()_q 一開始應清空g_bna.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770005 07/07/06 By ve  報表改為使用crystal report
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消bna04/combobx改為動態
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30059 10/03/17 by rainy 單據性質 1.放行單，改成 F.放行單 
# Modify.........: No:MOD-A20074 10/03/26 By Smapmin 按U[修改]後，就變成無窮迴圈
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50039 11/07/05 By xianghui 增加自訂欄位
# Modify.........: No.MOD-B80273 12/01/16 By Vampire 資料筆數和實際顯示在畫面上的筆數不一致

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
#      g_bna                RECORD LIKE bna_file.*,
       g_bna_t              RECORD LIKE bna_file.*,
       g_bna01_t            LIKE bna_file.bna01,
       g_bna02_t            LIKE bna_file.bna02,
       g_wc,g_sql           STRING                 #No.FUN-580092 HCN
 
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  STRING
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680062 INTEGER
DEFINE g_msg                LIKE type_file.chr1000  #No.FUN-680062 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10    #No.FUN-680062 INTEGER
DEFINE g_curs_index         LIKE type_file.num10    #No.FUN-680062 INTEGER
DEFINE g_jump               LIKE type_file.num10    #No.FUN-680062 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5     #No.FUN-680062 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col         LIKE type_file.num5     #No.FUN-680062 SMALLINT
#       l_time              LIKE type_file.chr8     #No.FUN-6A0062

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
    INITIALIZE g_bna.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bna_file WHERE bna01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_cl CURSOR FROM g_forupd_sql         # LOCK CURSOR
 
    LET p_row = 5 LET p_col = 10
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "abx/42f/abxi010"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i010_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION i010_curs()
    CLEAR FORM
   INITIALIZE g_bna.* TO NULL    #No.FUN-750051

    CALL s_getgee(g_prog,g_lang,'bna05') #AFUN-10109 TSD.zeak
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        bna01,bna02,bna03,#bna04, #FUN-A10109 TSD.zeak
        bna05,bna06,
        bnaud01,bnaud02,bnaud03,bnaud04,bnaud05,      #FUN-B50039
        bnaud06,bnaud07,bnaud08,bnaud09,bnaud10,      #FUN-B50039
        bnaud11,bnaud12,bnaud13,bnaud14,bnaud15       #FUN-B50039
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
    #        LET g_wc = g_wc clipped," AND gebuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND gebgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND gebgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gebuser', 'gebgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT bna01 FROM bna_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, 
              "   AND bna05 IN ( SELECT DISTINCT gee02 FROM gee_file WHERE gee01 = 'ABX' AND gee04 = 'abxi010') ",  #FUN-A30059
              " ORDER BY bna01 "

    PREPARE i010_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i010_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i010_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM bna_file WHERE ",g_wc CLIPPED,
        "   AND bna05 IN ( SELECT DISTINCT gee02 FROM gee_file WHERE gee01 = 'ABX' AND gee04 = 'abxi010') "        #MOD-B80273 add
    PREPARE i010_cntpre FROM g_sql
    DECLARE i010_count CURSOR FOR i010_cntpre
END FUNCTION
 
FUNCTION i010_menu()
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
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
        #FUN-6A0007...............begin
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                 CALL i010_out()
            END IF
        #FUN-6A0007...............end
        ON ACTION next
            CALL i010_fetch('N')
        ON ACTION previous
            CALL i010_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i010_u()
            END IF
        ON ACTION authorization     #NO:6842
            IF NOT cl_null(g_bna.bna01) THEN
               LET g_action_choice="authorization"
               IF cl_chk_act_auth() THEN
                 #CALL s_smu(g_bna.bna01,g_sys) #TQC-660133 remark
                  CALL s_smu(g_bna.bna01,"ABX") #TQC-660133
               END IF
              #LET g_msg = s_smu_d(g_bna.bna01,g_sys) #TQC-660133 remark
               LET g_msg = s_smu_d(g_bna.bna01,"ABX") #TQC-660133
               DISPLAY g_msg TO smu02_display
            ELSE
               CALL cl_err('','-400',0)
            END IF
        ON ACTION dept_authorization                 #NO:6842
            IF NOT cl_null(g_bna.bna01) THEN
               LET g_action_choice="dept_authorization"
               IF cl_chk_act_auth() THEN
                 #CALL s_smv(g_bna.bna01,g_sys) #TQC-660133 remark
                  CALL s_smv(g_bna.bna01,"ABX") #TQC-660133
               END IF
              #LET g_msg = s_smv_d(g_bna.bna01,g_sys) #TQC-660133 remark
               LET g_msg = s_smv_d(g_bna.bna01,"ABX") #TQC-660133
               DISPLAY g_msg TO smv02_display
            ELSE
               CALL cl_err('','-400',0)
            END IF
 
#       ON ACTION invalid
#          #IF cl_chk_act_auth() THEN
#           IF cl_chk_act_auth() THEN
#                CALL i010_x()
#           END IF
 
        ON ACTION delete
           #IF cl_chk_act_auth() THEN
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i010_r()
            END IF
#       ON ACTION reproduce
#           IF cl_chk_act_auth() THEN
#                CALL i010_copy()
#           END IF
 
#       ON ACTION output
#           IF cl_chk_act_auth()
#              THEN CALL i010_out()
#           END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL s_getgee(g_prog,g_lang,'bna05') #AFUN-10109 TSD.zeak
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
            CALL i010_fetch('/')
        ON ACTION first
            CALL i010_fetch('F')
        ON ACTION last
            CALL i010_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        #No.FUN-6A0046-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_bna.bna01 IS NOT NULL THEN
                  LET g_doc.column1 = "bna01"
                  LET g_doc.value1 = g_bna.bna01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0046-------add--------end---- 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i010_cs
END FUNCTION
 
 
FUNCTION i010_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bna.* LIKE bna_file.*
    LET g_bna01_t = NULL
    LET g_bna02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
       #No.FUN-590002 START------
       #LET g_bna.bna04 = '1' #FUN-A10109 TSD.zeak
       #LET g_bna.bna05 = '1'    #FUN-A30059
       LET g_bna.bna05 = 'F'     #FUN-A30059
       LET g_bna.bna06 = '1'
       #No.FUN-590002 END--------
        LET g_bna.bna03 = 'Y'
     #  LET g_bna.bna04 = '000000'   #No.FUN-580176
        #LET g_bna.bna05 = '1'    #FUN-A30059
        LET g_bna.bna07 = 'N'     #FUN-A30059
        {
        LET g_bna.bnauser = g_user
        LET g_bna.bnaoriu = g_user #FUN-980030
        LET g_bna.bnaorig = g_grup #FUN-980030
        LET g_bna.bnagrup = g_grup               #使用者所屬群
        LET g_bna.bnadate = g_today
        LET g_bna.bnaacti = 'Y'
        }
        CALL i010_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_bna.bna01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO bna_file VALUES(g_bna.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)   #No.FUN-660052
            CALL cl_err3("ins","bna_file",g_bna.bna01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        ELSE
            LET g_bna_t.* = g_bna.*                # 保存上筆資料
            SELECT bna01 INTO g_bna.bna01 FROM bna_file
                WHERE bna01 = g_bna.bna01
            #FUN-A10109  ===S===
            CALL s_access_doc('a',g_bna.bna03,g_bna.bna05,g_bna.bna01,'ABX','Y')
            #FUN-A10109  ===E===
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i010_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680062 VARCHAR(1)
        l_n             LIKE type_file.num5      #No.FUN-680062 SMALLINT
    DEFINE l_i          LIKE type_file.num5      #No.FUN-680062 SMALLINT   #No.FUN-560150
 
    INPUT BY NAME
        g_bna.bna01,g_bna.bna02,g_bna.bna03,
        #g_bna.bna04, #FUN-A10109 TSD.zeak
        g_bna.bna05,g_bna.bna06,
        g_bna.bnaud01,g_bna.bnaud02,g_bna.bnaud03,g_bna.bnaud04,g_bna.bnaud05,   #FUN-B50039
        g_bna.bnaud06,g_bna.bnaud07,g_bna.bnaud08,g_bna.bnaud09,g_bna.bnaud10,   #FUN-B50039
        g_bna.bnaud11,g_bna.bnaud12,g_bna.bnaud13,g_bna.bnaud14,g_bna.bnaud15    #FUN-B50039        
     #  g_bna.bnauser,g_bna.bnagrup,g_bna.bnamodu,g_bna.bnadate,g_bna.bnaacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i010_set_entry(p_cmd)
           CALL i010_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           #NO.FUN-560150 --start--
           CALL cl_set_doctype_format("bna01")
           #NO.FUN-560150 --end--
 
        #FUN-A10109 TSD.zeak ===S===
        BEFORE FIELD bna05
           CALL s_getgee(g_prog,g_lang,'bna05') #AFUN-10109 TSD.zeak
        #FUN-A10109 TSD.zeak ===E===

        AFTER FIELD bna01
          IF NOT cl_null(g_bna.bna01) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
              ( g_bna.bna01 !=g_bna01_t)) THEN
                SELECT count(*) INTO l_n FROM bna_file
                 WHERE bna01 = g_bna.bna01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_bna.bna01,-239,0)
                    LET g_bna.bna01 = g_bna01_t
                    DISPLAY BY NAME g_bna.bna01
                    NEXT FIELD bna01
                END IF
            #END IF   #MOD-A20074
                #NO.FUN-560150 --start-- #FUN-6A0007
                FOR l_i = 1 TO g_doc_len
                   IF cl_null(g_bna.bna01[l_i,l_i]) THEN
                      CALL cl_err('','sub-146',0)
                      LET g_bna.bna01 = g_bna01_t
                      NEXT FIELD bna01
                   END IF
                END FOR
                #NO.FUN-560150 --end--
            END IF   #MOD-A20074
          END IF
 
        #-----No.FUN-580176-----
        AFTER FIELD bna03
 
        #FUN-A10109 TSD.zeak mark ===S===
        #IF g_bna.bna03 = "Y" THEN
        #   CALL cl_set_comp_entry("bna04",TRUE)
        #ELSE
        #   CALL cl_set_comp_entry("bna04",FALSE)
        #END IF
        #FUN-A10109 TSD.zeak mark ===E===
        #-----No.FUN-580176 END-----
 
#       AFTER FIELD bna04                        #No.FUN-550033
#           IF g_bna.bna04 NOT MATCHES '[12]' THEN
#              NEXT FIELD bna04
#           END IF
 
        AFTER FIELD bna05
           #IF g_bna.bna05 NOT MATCHES '[1]' THEN #FUN-6A0007
           #AFUN-10109    START 
           #IF g_bna.bna05 NOT MATCHES '[1ABCDE]' THEN #FUN-6A0007
           #   CALL cl_err('err bna05 ',STATUS,0)
           #   NEXT FIELD bna05
           #END IF
           #AFUN-10109    END
 
        AFTER FIELD bna06
            IF g_bna.bna06 NOT MATCHES '[1-3]' THEN
               CALL cl_err('err bna06 ',STATUS,0)
               NEXT FIELD bna06
            END IF

        #FUN-B50039-add-str--
        AFTER FIELD bnaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-B50039-add-end--

{
        ON ACTION CONTROLP                        # 沿用所有欄位
            CASE
               OTHERWISE
                    EXIT CASE
            END CASE}
 
        #MOD-650015 --sart
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bna01) THEN
        #        LET g_bna.* = g_bna_t.*
        #        CALL i010_show()
        #        NEXT FIELD bna01
        #    END IF
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
 
FUNCTION i010_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bna.* TO NULL                #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i010_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i010_count
    FETCH i010_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i010_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
        INITIALIZE g_bna.* TO NULL
    ELSE
        CALL i010_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i010_fetch(p_flbna)
    DEFINE
        p_flbna        LIKE type_file.chr1,     #No.FUN-680062 VARCHAR(1)
        l_abso         LIKE type_file.num10     #No.FUN-680062 INTEGER
 
    CASE p_flbna
        WHEN 'N' FETCH NEXT     i010_cs INTO g_bna.bna01
        WHEN 'P' FETCH PREVIOUS i010_cs INTO g_bna.bna01
        WHEN 'F' FETCH FIRST    i010_cs INTO g_bna.bna01
        WHEN 'L' FETCH LAST     i010_cs INTO g_bna.bna01
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
            FETCH ABSOLUTE g_jump i010_cs INTO g_bna.bna01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
        INITIALIZE g_bna.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbna
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bna.* FROM bna_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bna01 = g_bna.bna01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)   #No.FUN-660052
        CALL cl_err3("sel","bna_file",g_bna.bna01,"",SQLCA.sqlcode,"","",1)
    ELSE
#       LET g_data_owner = g_bna.bnauser
#       LET g_data_group = g_bna.bnagrup
        CALL i010_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i010_show()
    LET g_bna_t.* = g_bna.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_bna.*
    DISPLAY BY NAME g_bna.bna01,g_bna.bna02,g_bna.bna03,
                    #g_bna.bna04, #FUN-A10109 TSD.zeak 
                    g_bna.bna05,g_bna.bna06,
                    g_bna.bnaud01,g_bna.bnaud02,g_bna.bnaud03,g_bna.bnaud04,g_bna.bnaud05,   #FUN-B50039
                    g_bna.bnaud06,g_bna.bnaud07,g_bna.bnaud08,g_bna.bnaud09,g_bna.bnaud10,   #FUN-B50039
                    g_bna.bnaud11,g_bna.bnaud12,g_bna.bnaud13,g_bna.bnaud14,g_bna.bnaud15    #FUN-B50039
    #No.FUN-9A0024--end 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i010_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bna.bna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    {
    IF g_bna.bnaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    }
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bna01_t = g_bna.bna01
    LET g_bna02_t = g_bna.bna02
    BEGIN WORK
 
    OPEN i010_cl USING g_bna.bna01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_bna.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
        RETURN
    END IF
  # LET g_bna.bnamodu=g_user                     #修改者
  # LET g_bna.bnadate = g_today                  #修改日期
    CALL i010_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i010_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bna.*=g_bna_t.*
            CALL i010_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
         UPDATE bna_file SET bna_file.* = g_bna.*      # 更新DB
          WHERE bna01 = g_bna01_t                # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)  #No.FUN-660052
            CALL cl_err3("upd","bna_file",g_bna01_t,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        #FUN-A10109  ===S===
        CALL s_access_doc('u',g_bna.bna03,g_bna.bna05,g_bna01_t,'ABX','Y')
        #FUN-A10109  ===E===
        EXIT WHILE
    END WHILE
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
{
FUNCTION i010_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_bna.bna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i010_cl USING g_bna.bna01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_bna.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i010_show()
    IF cl_exp(0,0,g_bna.bnaacti) THEN
        LET g_chr=g_bna.bnaacti
        IF g_bna.bnaacti='Y' THEN
            LET g_bna.bnaacti='N'
        ELSE
            LET g_bna.bnaacti='Y'
        END IF
        UPDATE bna_file
            SET bnaacti=g_bna.bnaacti
            WHERE bna01 = g_bna.bna01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
            LET g_bna.bnaacti=g_chr
        END IF
        #FUN-A10109  ===S===
        CALL s_access_doc('u',g_bna.bna03,g_bna.bna05,g_bna01,'ABX','Y')
        #FUN-A10109  ===E===
        DISPLAY BY NAME g_bna.bnaacti
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
}
 
FUNCTION i010_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_bna.bna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i010_cl USING g_bna.bna01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_bna.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i010_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bna01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bna.bna01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bna_file WHERE bna01=g_bna.bna01
      #DELETE FROM smv_file WHERE smv01 = g_bna.bna01 AND smv03=g_sys  #NO:6842  #TQC-670008 remark
       DELETE FROM smv_file WHERE smv01 = g_bna.bna01 AND upper(smv03)='ABX'     #TQC-670008
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('smv_file',SQLCA.sqlcode,0)  #No.FUN-660052
          CALL cl_err3("del","smv_file",g_bna.bna01,g_sys,SQLCA.sqlcode,"","smv_file",1)
       END IF
      #DELETE FROM smu_file WHERE smu01 = g_bna.bna01 AND smu03=g_sys  #NO:6842   #TQC-670008 remark
       DELETE FROM smu_file WHERE smu01 = g_bna.bna01 AND upper(smu03)='ABX'      #TQC-670008
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('smu_file',SQLCA.sqlcode,0)  #No.FUN-660052
          CALL cl_err3("del","smu_file",g_bna.bna01,g_sys,SQLCA.sqlcode,"","smu_file",1)
       END IF
       #FUN-A10109  ===S===
       CALL s_access_doc('r','','',g_bna.bna01,'ABX','Y')
       #FUN-A10109  ===E===
       CLEAR FORM
       OPEN i010_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i010_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i010_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i010_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i010_fetch('/')
       END IF
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bna01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bna01",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
 
FUNCTION i010_out()
DEFINE sr RECORD LIKE bna_file.*,
       l_name LIKE type_file.chr20    # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
 
   IF g_bna.bna01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
 
   IF cl_null(g_wc) THEN
      LET g_wc=" bna01='",g_bna.bna01,"'"
   END IF
 
   CALL cl_wait()
   CALL cl_outnam('abxi010') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT * FROM bna_file ",
           " WHERE ",g_wc CLIPPED
#FUN-770005--begin--
{
   PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i010_co                           # SCROLL CURSOR
            CURSOR FOR i010_p1
 
   START REPORT i010_rep TO l_name
 
   FOREACH i010_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT i010_rep(sr.*)
   END FOREACH
 
   FINISH REPORT i010_rep
 
   CLOSE i010_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
}
#FUN-770005--end--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF g_zz05 = 'Y' THEN
      #FUN-A10109 TSD.zeak ===S===
      #CALL cl_wcchp(g_wc,'bna01,bna02,bna03,bna04,bna05,bna06') 
      CALL cl_wcchp(g_wc,'bna01,bna02,bna03,bna05,bna06')
      #FUN-A10109 TSD.zeak ===E===
           RETURNING g_wc
   END IF
   CALL cl_prt_cs1("abxi010","abxi010",g_sql,g_wc)
END FUNCTION
#FUN-770005--begin--
{
REPORT i010_rep(sr)
DEFINE
        l_last_sw  LIKE type_file.chr1,          #No.FUN-690010 VARCHAR(1),
        sr RECORD LIKE bna_file.*,
        l_str     STRING
 
        OUTPUT
                TOP MARGIN g_top_margin
                LEFT MARGIN g_left_margin
                BOTTOM MARGIN g_bottom_margin
                PAGE LENGTH g_page_line
 
        ORDER BY sr.bna01
 
        FORMAT
                PAGE HEADER
                        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
                        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
                        LET g_pageno=g_pageno+1
                        LET pageno_total=PAGENO USING '<<<',"/pageno"
                        PRINT g_head CLIPPED,pageno_total
                        PRINT g_dash
                        PRINT g_x[31],g_x[32],g_x[33],g_x[34],
                              g_x[35],g_x[36]
                        PRINT g_dash1
                        LET l_last_sw = 'y'
 
                ON EVERY ROW
                  PRINT COLUMN g_c[31],sr.bna01,
                        COLUMN g_c[32],sr.bna02,
                        COLUMN g_c[33],sr.bna03,
                        COLUMN g_c[34],sr.bna04;
                        CASE sr.bna05
                           WHEN "1"
                              LET l_str=sr.bna05,":",g_x[11]
                           WHEN "A"
                              LET l_str=sr.bna05,":",g_x[12]
                           WHEN "B"
                              LET l_str=sr.bna05,":",g_x[13]
                           WHEN "C"
                              LET l_str=sr.bna05,":",g_x[14]
                           WHEN "D"
                              LET l_str=sr.bna05,":",g_x[15]
                           WHEN "E"
                              LET l_str=sr.bna05,":",g_x[16]
                           OTHERWISE
                              LET l_str=NULL
                        END CASE
                  PRINT COLUMN g_c[35],l_str; 
                        CASE sr.bna06
                           WHEN "1"
                              LET l_str=sr.bna06,":",g_x[17]
                           WHEN "2"
                              LET l_str=sr.bna06,":",g_x[18]
                           WHEN "3"
                              LET l_str=sr.bna06,":",g_x[19]
                           OTHERWISE
                              LET l_str=NULL
                        END CASE
                  PRINT COLUMN g_c[36],l_str
 
                ON LAST ROW
                  IF g_zz05 = 'Y' THEN PRINT g_dash
                     CALL cl_prt_pos_wc(g_wc)
                  END IF
                  PRINT g_dash
                  LET l_last_sw = 'n'
                  PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_last_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#FUN-770005--end--
