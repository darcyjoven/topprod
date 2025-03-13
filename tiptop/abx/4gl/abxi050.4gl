# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abxi050.4gl
# Descriptions...: 保稅料件月統計檔維護作業
# Date & Author..: 96/11/04 By Star
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0046 06/10/18 By jamie 1.FUNCTION i050()_q 一開始應清空g_bnf.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/06 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bnf   RECORD LIKE bnf_file.*,
    g_bnf_t RECORD LIKE bnf_file.*,
    g_bnf01_t LIKE bnf_file.bnf01,
    g_bnf02_t LIKE bnf_file.bnf02,
    g_bnf03_t LIKE bnf_file.bnf03,
    g_bnf04_t LIKE bnf_file.bnf04,
    g_wc,g_sql          STRING   #No.FUN-580092 HCN          
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  STRING
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680062 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col      LIKE type_file.num5          #No.FUN-680062 SMALLINT
#       l_time           LIKE type_file.chr8          #No.FUN-6A0062
 
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
   INITIALIZE g_bnf.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM bnf_file WHERE bnf01 = ? AND bnf02 = ? AND bnf03 = ? AND bnf04 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i050_cl CURSOR FROM g_forupd_sql          # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW i050_w AT p_row,p_col WITH FORM "abx/42f/abxi050"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i050_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
   #END WHILE    ####040512
 
   CLOSE WINDOW i050_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
#FUN-6A0007 多轉入參數p_cmd判斷是一般查詢(1)或保稅代碼查詢(2) --(S)
#FUNCTION i050_curs()
FUNCTION i050_curs(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1
    IF NOT cl_null(p_cmd) AND p_cmd = '1' THEN
#FUN-6A0007 ----------------------------------------------------(E)
    CLEAR FORM
   INITIALIZE g_bnf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        bnf01,bnf02, bnf03,bnf04, bnf05,bnf06, bnf07,bnf08,
        bnf09,bnf10, bnf11,bnf12 
          #FUN-6A0007-------------------------------------------(S)
          ,bnf21,bnf22,bnf23,bnf24,bnf25,bnf26,
           bnf27,bnf28,bnf29,bnf30,bnf31
          #FUN-6A0007-------------------------------------------(E)
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
               WHEN INFIELD(bnf01)
#               CALL q_ima(10,4,g_bnf.bnf01) RETURNING g_bnf.bnf01
#FUN-AA0059--
           #     CALL cl_init_qry_var()
           #     LET g_qryparam.form = "q_ima"
           #     LET g_qryparam.state = "c"
           #     LET g_qryparam.default1 = g_bnf.bnf01
           #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","",g_bnf.bnf01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO bnf01
                NEXT FIELD bnf01
               WHEN INFIELD(bnf02)
#               CALL q_imd(11,4,g_bnf.bnf02,'A') RETURNING g_bnf.bnf02
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_bnf.bnf02
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bnf02
                NEXT FIELD bnf02
               OTHERWISE
                EXIT CASE
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
    END IF   #FUN-6A0007 
 
    # 組合出 SQL 指令
    #FUN-6A0007 判斷是一般查詢(1)或保稅代碼查詢(2)--(S)
    #LET g_sql="SELECT bnf01,bnf02,bnf03,bnf04 FROM bnf_file ",
    #          " WHERE ",g_wc CLIPPED, " ORDER BY bnf01,bnf02,bnf03,bnf04 "
    IF p_cmd = '1' THEN
    LET g_sql="SELECT bnf01,bnf02,bnf03,bnf04 FROM bnf_file ",
              " WHERE ",g_wc CLIPPED, " ORDER BY bnf01,bnf02,bnf03,bnf04 "
    ELSE
       LET g_sql="SELECT bnf_file.bnf01,bnf02,bnf03,bnf04 ",
                 "  FROM bnf_file,ima_file,bxe_file ",
                 " WHERE bnf01 = ima01 AND ima1916 = bxe01 ",
                 "   AND ",g_wc CLIPPED, 
                 " ORDER BY bnf01,bnf02,bnf03,bnf04 "
    END IF
    #FUN-6A0007 判斷是一般查詢(1)或保稅代碼查詢(2)--(E)
 
    PREPARE i050_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i050_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i050_prepare
 
    #FUN-6A0007 判斷是一般查詢(1)或保稅代碼查詢(2)--(S)
    #LET g_sql= "SELECT COUNT(*) FROM bnf_file WHERE ",g_wc CLIPPED
    IF p_cmd = 1 THEN
       LET g_sql= "SELECT COUNT(*) FROM bnf_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql= "SELECT COUNT(*) FROM bnf_file,ima_file,bxe_file ",
                  " WHERE bnf01 = ima01 AND ima1916 = bxe01 ",
                  "   AND ",g_wc CLIPPED
    END IF
    #FUN-6A0007 判斷是一般查詢(1)或保稅代碼查詢(2)--(E)
 
    PREPARE i050_cntpre FROM g_sql
    DECLARE i050_count CURSOR FOR i050_cntpre
END FUNCTION
 
FUNCTION i050_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i050_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i050_q()
            END IF
        ON ACTION next
            CALL i050_fetch('N')
        ON ACTION previous
            CALL i050_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i050_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i050_r()
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
 
        ON ACTION jump
            CALL i050_fetch('/')
        ON ACTION first
            CALL i050_fetch('F')
        ON ACTION last
            CALL i050_fetch('L')
 
        #FUN-6A0007 --(S)
        ON ACTION Bond_Qry #「保稅群組代碼查詢」
           LET g_action_choice="bond_qry"
           IF cl_chk_act_auth() THEN
              CALL i050_bond_q()
           END IF
        #FUN-6A0007 --(E)
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       #No.FUN-6A0046-------add--------str----
       ON ACTION related_document             #相關文件"                        
        LET g_action_choice="related_document"           
           IF cl_chk_act_auth() THEN                     
              IF g_bnf.bnf01 IS NOT NULL THEN            
                 LET g_doc.column1 = "bnf01"               
                 LET g_doc.column2 = "bnf02" 
                 LET g_doc.column3 = "bnf03"
                 LET g_doc.column4 = "bnf04"              
                 LET g_doc.value1 = g_bnf.bnf01            
                 LET g_doc.value2 = g_bnf.bnf02
                 LET g_doc.value3 = g_bnf.bnf03
                 LET g_doc.value4 = g_bnf.bnf04            
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
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i050_cs
END FUNCTION
 
 
FUNCTION i050_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bnf.* LIKE bnf_file.*
    LET g_bnf01_t = NULL
    LET g_bnf02_t = NULL
    LET g_bnf03_t = NULL
    LET g_bnf04_t = NULL
   #FUN-6A0007-----------------------------(S)
    LET g_bnf.bnf21 = 0
    LET g_bnf.bnf22 = 0
    LET g_bnf.bnf23 = 0
    LET g_bnf.bnf24 = 0
    LET g_bnf.bnf25 = 0
    LET g_bnf.bnf26 = 0
    LET g_bnf.bnf27 = 0
    LET g_bnf.bnf28 = 0
    LET g_bnf.bnf29 = 0
    LET g_bnf.bnf30 = 0
    LET g_bnf.bnf31 = 0
   #FUN-6A0007-----------------------------(E)
 
    LET g_bnf.bnfplant = g_plant #FUN-980001 add
    LET g_bnf.bnflegal = g_legal #FUN-980001 add
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i050_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_bnf.bnf02 IS NULL THEN LET g_bnf.bnf02=' ' END IF
        IF g_bnf.bnf01 IS NULL OR g_bnf.bnf02 IS NULL OR
           g_bnf.bnf03 IS NULL OR g_bnf.bnf04 IS NULL THEN  # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO bnf_file VALUES(g_bnf.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0)  #No.FUN-660052
            CALL cl_err3("ins","bnf_file",g_bnf.bnf01,g_bnf.bnf02,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        ELSE
            LET g_bnf_t.* = g_bnf.*                # 保存上筆資料
            SELECT bnf01,bnf02,bnf03,bnf04 INTO g_bnf.bnf01,g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04 FROM bnf_file
                WHERE bnf01 = g_bnf.bnf01 AND bnf02 = g_bnf.bnf02
                  AND bnf03 = g_bnf.bnf03 AND bnf04 = g_bnf.bnf04
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i050_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680062 SMALLINT
 
    DISPLAY BY NAME
       g_bnf.bnf01,g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04,g_bnf.bnf05,g_bnf.bnf06,
       g_bnf.bnf07,g_bnf.bnf08,g_bnf.bnf09,g_bnf.bnf10,g_bnf.bnf11,g_bnf.bnf12
      #FUN-6A0007--------------------------------------------------(S) 
      ,g_bnf.bnf21,g_bnf.bnf22,g_bnf.bnf23,g_bnf.bnf24,
       g_bnf.bnf25,g_bnf.bnf26,g_bnf.bnf27,g_bnf.bnf28,
       g_bnf.bnf29,g_bnf.bnf30,g_bnf.bnf31
      #FUN-6A0007--------------------------------------------------(E) 
 
    INPUT BY NAME
       g_bnf.bnf01,g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04,g_bnf.bnf05,g_bnf.bnf06,
       g_bnf.bnf07,g_bnf.bnf08,g_bnf.bnf09,g_bnf.bnf10,g_bnf.bnf11,g_bnf.bnf12
      #FUN-6A0007--------------------------------------------------(S) 
      ,g_bnf.bnf21,g_bnf.bnf22,g_bnf.bnf23,g_bnf.bnf24,
       g_bnf.bnf25,g_bnf.bnf26,g_bnf.bnf27,g_bnf.bnf28,
       g_bnf.bnf29,g_bnf.bnf30,g_bnf.bnf31
      #FUN-6A0007--------------------------------------------------(E) 
       WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i050_set_entry(p_cmd)
           CALL i050_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        #FUN-6A0007 --(S)
        AFTER FIELD bnf01
           IF NOT cl_null(g_bnf.bnf01) THEN
              #FUN-AA0059 -----------------------------add start---------------------
              IF NOT s_chk_item_no(g_bnf.bnf01,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD bnf01
              END IF 
              #FUN-AA0059 -----------------------------add start---------------------- 
              SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = g_bnf.bnf01
              IF l_n < 1 THEN
                 CALL cl_err(g_bnf.bnf01,STATUS,0)
                 NEXT FIELD bnf01
              END IF
           END IF
        # 畫面新增display欄位 ima02,ima021,bxe01,bxe02,bxe03
        CALL i050_bnf01()
        #FUN-6A0007 --(E)
 
        BEFORE FIELD bnf02
         IF NOT cl_null(g_bnf.bnf01) THEN
            SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = g_bnf.bnf01
            IF l_n < 1 THEN
               CALL cl_err(g_bnf.bnf01,STATUS,0)
               NEXT FIELD bnf01
            END IF
         END IF
 
        BEFORE FIELD bnf03
            IF NOT cl_null(g_bnf.bnf02) THEN
               SELECT COUNT(*) INTO l_n FROM imd_file WHERE imd01 = g_bnf.bnf02
                                                         AND imdacti = 'Y' #MOD-4B0169
               IF l_n = 0 THEN
                  CALL cl_err(g_bnf.bnf02,'mfg0094',0)
                  NEXT FIELD bnf02
               END IF
            ELSE
               LET g_bnf.bnf02=' '
            END IF
 
        BEFORE FIELD bnf05
         IF NOT cl_null(g_bnf.bnf04) THEN
            IF g_bnf.bnf01 IS NULL OR
               g_bnf.bnf02 IS NULL OR
               g_bnf.bnf03 IS NULL OR
               g_bnf.bnf04 IS NULL THEN
               NEXT FIELD bnf01
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
              (g_bnf.bnf01 !=g_bnf01_t)  OR
              (g_bnf.bnf02 !=g_bnf02_t)  OR
              (g_bnf.bnf03 !=g_bnf03_t)  OR
              (g_bnf.bnf04 !=g_bnf04_t)) THEN
                SELECT count(*) INTO l_n FROM bnf_file
                 WHERE bnf01 = g_bnf.bnf01
                   AND bnf02 = g_bnf.bnf02
                   AND bnf03 = g_bnf.bnf03
                   AND bnf04 = g_bnf.bnf04
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_bnf.bnf02,-239,0)
                    LET g_bnf.bnf01 = g_bnf01_t
                    LET g_bnf.bnf02 = g_bnf02_t
                    LET g_bnf.bnf03 = g_bnf03_t
                    LET g_bnf.bnf04 = g_bnf04_t
                    DISPLAY BY NAME g_bnf.bnf01
                    DISPLAY BY NAME g_bnf.bnf02
                    DISPLAY BY NAME g_bnf.bnf03
                    DISPLAY BY NAME g_bnf.bnf04
                    NEXT FIELD bnf01
                END IF
            END IF
          END IF
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
               WHEN INFIELD(bnf01)
#               CALL q_ima(10,4,g_bnf.bnf01) RETURNING g_bnf.bnf01
#               CALL FGL_DIALOG_SETBUFFER( g_bnf.bnf01 )
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_ima"
              #  LET g_qryparam.default1 = g_bnf.bnf01
              #  CALL cl_create_qry() RETURNING g_bnf.bnf01
                 CALL q_sel_ima(FALSE, "q_ima","",g_bnf.bnf01,"","","","","",'')  RETURNING g_bnf.bnf01 
#FUN-AA0059 --End--
                DISPLAY BY NAME g_bnf.bnf01
                NEXT FIELD bnf01
               WHEN INFIELD(bnf02)
#               CALL q_imd(11,4,g_bnf.bnf02,'A') RETURNING g_bnf.bnf02
#               CALL FGL_DIALOG_SETBUFFER( g_bnf.bnf02 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd"
                LET g_qryparam.default1 = g_bnf.bnf02
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                CALL cl_create_qry() RETURNING g_bnf.bnf02
#                CALL FGL_DIALOG_SETBUFFER( g_bnf.bnf02 )
                DISPLAY BY NAME g_bnf.bnf02
                NEXT FIELD bnf02
               OTHERWISE
                EXIT CASE
            END CASE
        
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bnf01) THEN
        #        LET g_bnf.* = g_bnf_t.*
        #        CALL i050_show()
        #        NEXT FIELD bnf01
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
 
FUNCTION i050_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bnf.* TO NULL                #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    #FUN-6A0007 多傳入參數(1)，告知為一般查詢 --(S)
    #CALL i050_curs()                          # 宣告 SCROLL CURSOR
    CALL i050_curs(1)                          # 宣告 SCROLL CURSOR
    #FUN-6A0007 --(E)
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i050_count
    FETCH i050_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i050_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0)
        INITIALIZE g_bnf.* TO NULL
    ELSE
        CALL i050_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i050_fetch(p_flbnf)
    DEFINE
        p_flbnf         LIKE type_file.chr1,         #No.FUN-680062 VARCHAR(1) 
        l_abso          LIKE type_file.num10         #No.FUN-680062 INTEGER
 
    CASE p_flbnf
        WHEN 'N' FETCH NEXT     i050_cs INTO g_bnf.bnf01,
                                            g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04
        WHEN 'P' FETCH PREVIOUS i050_cs INTO g_bnf.bnf01,
                                            g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04
        WHEN 'F' FETCH FIRST    i050_cs INTO g_bnf.bnf01,
                                            g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04
        WHEN 'L' FETCH LAST     i050_cs INTO g_bnf.bnf01,
                                            g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04
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
            FETCH ABSOLUTE g_jump i050_cs INTO g_bnf.bnf01,
                                            g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0)
        INITIALIZE g_bnf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbnf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bnf.* FROM bnf_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bnf01 = g_bnf.bnf01 AND bnf02 = g_bnf.bnf02 AND bnf03 = g_bnf.bnf03 AND bnf04 = g_bnf.bnf04
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0)    #No.FUN-660052
       CALL cl_err3("sel","bnf_file",g_bnf.bnf01,g_bnf.bnf02,SQLCA.sqlcode,"","",1)
    ELSE
 
        CALL i050_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i050_show()
    LET g_bnf_t.* = g_bnf.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_bnf.*
    DISPLAY BY NAME  g_bnf.bnf01,g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04,g_bnf.bnf05,g_bnf.bnf06,
                     g_bnf.bnf07,g_bnf.bnf08,g_bnf.bnf09,g_bnf.bnf10,g_bnf.bnf11,g_bnf.bnf12
                     ,g_bnf.bnf21,g_bnf.bnf22,g_bnf.bnf23,g_bnf.bnf24,
                     g_bnf.bnf25,g_bnf.bnf26,g_bnf.bnf27,g_bnf.bnf28,
                     g_bnf.bnf29,g_bnf.bnf30,g_bnf.bnf31
    #No.FUN-9A0024--end
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #FUN-6A0007 --(S)
    # 畫面新增display欄位 ima02,ima021,bxe01,bxe02,bxe03
    CALL i050_bnf01()
    #FUN-6A0007 --(E)
END FUNCTION
 
FUNCTION i050_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bnf.bnf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bnf01_t = g_bnf.bnf01
    LET g_bnf02_t = g_bnf.bnf02
    LET g_bnf03_t = g_bnf.bnf03
    LET g_bnf04_t = g_bnf.bnf04
    BEGIN WORK
 
    OPEN i050_cl USING g_bnf.bnf01,g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04
    IF STATUS THEN
       CALL cl_err("OPEN i050_cl:", STATUS, 1)
       CLOSE i050_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i050_cl INTO g_bnf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i050_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i050_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bnf.*=g_bnf_t.*
            CALL i050_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bnf_file SET bnf_file.* = g_bnf.*    # 更新DB
            WHERE   bnf01 = g_bnf01_t AND bnf02 = g_bnf02_t
              AND bnf03 = g_bnf03_t AND bnf04 = g_bnf04_t           # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0) #No.FUN-660052
           CALL cl_err3("upd","bnf_file",g_bnf01_t,g_bnf02_t,SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i050_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i050_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_bnf.bnf01 IS NULL OR
       g_bnf.bnf02 IS NULL OR
       g_bnf.bnf03 IS NULL OR
       g_bnf.bnf04 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i050_cl USING g_bnf.bnf01,g_bnf.bnf02,g_bnf.bnf03,g_bnf.bnf04
    IF STATUS THEN
       CALL cl_err("OPEN i050_cl:", STATUS, 1)
       CLOSE i050_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i050_cl INTO g_bnf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i050_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bnf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bnf02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bnf03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bnf04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bnf.bnf01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bnf.bnf02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bnf.bnf03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_bnf.bnf04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bnf_file WHERE bnf01=g_bnf.bnf01 AND bnf02=g_bnf.bnf02
                              AND bnf03=g_bnf.bnf03 AND bnf04=g_bnf.bnf04
       CLEAR FORM
       OPEN i050_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i050_cs
          CLOSE i050_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i050_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i050_cs
          CLOSE i050_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i050_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i050_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i050_fetch('/')
       END IF
    END IF
    CLOSE i050_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i050_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bnf01,bnf02,bnf03,bnf04",TRUE)
   END IF
END FUNCTION
 
FUNCTION i050_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bnf01,bnf02,bnf03,bnf04",FALSE)
   END IF
END FUNCTION
 
#FUN-6A0007 --(S)
# 畫面新增display欄位 ima02,ima021,bxe01,bxe02,bxe03
FUNCTION i050_bnf01()
    DEFINE l_ima02     LIKE ima_file.ima02,
           l_ima021    LIKE ima_file.ima021,
           l_bxe01 LIKE bxe_file.bxe01,
           l_bxe02 LIKE bxe_file.bxe02,
           l_bxe03 LIKE bxe_file.bxe03
 
   IF cl_null(g_bnf.bnf01) THEN
      DISPLAY ' ' TO FORMONLY.ima02
      DISPLAY ' ' TO FORMONLY.ima021
      DISPLAY ' ' TO FORMONLY.bxe01
      DISPLAY ' ' TO FORMONLY.bxe02
      DISPLAY ' ' TO FORMONLY.bxe03
   ELSE
      SELECT ima02,ima021,bxe01,bxe02,bxe03
        INTO l_ima02,l_ima021,l_bxe01,l_bxe02,l_bxe03
        FROM ima_file,OUTER bxe_file
       WHERE ima01 = g_bnf.bnf01
         AND ima_file.ima1916 = bxe_file.bxe01
      
      DISPLAY l_ima02     TO FORMONLY.ima02
      DISPLAY l_ima021    TO FORMONLY.ima021
      DISPLAY l_bxe01 TO FORMONLY.bxe01
      DISPLAY l_bxe02 TO FORMONLY.bxe02
      DISPLAY l_bxe03 TO FORMONLY.bxe03
   END IF
END FUNCTION
 
#保稅群組代碼查詢
FUNCTION i050_bond_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    OPEN WINDOW i050_w2 AT 8,20 WITH FORM "abx/42f/abxi051_x"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("abxi051_x")
    CALL i050_bond_curs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW i050_w2
       RETURN
    END IF
    CALL i050_curs('2')                          # 宣告 SCROLL CURSOR
    CLOSE WINDOW i050_w2
    OPEN i050_count
    FETCH i050_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i050_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bnf.bnf01,SQLCA.sqlcode,0)
        INITIALIZE g_bnf.* TO NULL
    ELSE
        CALL i050_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i050_bond_curs()                          # 宣告 SCROLL CURSOR
    CLEAR FORM
   INITIALIZE g_bnf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON bxe01,bxe02,bxe03  # 螢幕上取條件
        ON ACTION controlp 
            CASE
               WHEN INFIELD(bxe01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_bxe01"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bxe01
                NEXT FIELD bxe01
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about      
          CALL cl_about()  
      
       ON ACTION help     
          CALL cl_show_help()
      
       ON ACTION controlg   
          CALL cl_cmdask() 
    END CONSTRUCT
END FUNCTION
#FUN-6A0007 --(E)
 
#Patch....NO.TQC-610035 <001> #
