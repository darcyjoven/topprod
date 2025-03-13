# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afai200.4gl
# Descriptions...: 量測儀器資料維護作業
# Date & Author..: 00/03/17 By Iceman
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-5A0074 05/10/20 By Sarah 增加顯示"存放位置"的名稱(faf02)、"存放工廠"的名稱(azp02)
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690024 06/09/19 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i200_q()一開始應清空g_fga.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740116 07/04/22 By rainy 整合測試
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-810004 08/01/08 By Smapmin 校正別多一免校選項
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-850068 08/05/14 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.FUN-860092 08/07/21 by sherry 修改財篇及附號不用輸入
# Modify.........: No.MOD-930184 09/03/19 by Sarah 若已有校驗記錄(fgc_file),不可刪除afai200資料
# Modify.........: No.TQC-960325 09/06/24 by destiny 復制時會報-6372的錯
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B20111 11/02/21 By yinhy 複製時，增加對財產附號的控管
# Modify.........: No.TQC-B20113 11/02/21 By yinhy 增加AFTER FIELD fga22控管
# Modify.........: No.TQC-B20150 11/02/22 By yinhy "fga21"=3 免檢狀態時，fga20/fga22/fga23/fga24/fga25應該不允許輸入，不需要輸入值。
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C50041 12/05/07 By xuxz 當afat200已經有校正記錄維護時，fga22“最近送校日”、fga23“下次校驗日期”不可任意修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-D20031 13/02/06 By Polly 增加控卡，資產狀態不可為出售、報廢、銷帳

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fga               RECORD LIKE fga_file.*,
    g_fga_t             RECORD LIKE fga_file.*,
    g_fga_o             RECORD LIKE fga_file.*,
    g_fga01_t           LIKE fga_file.fga01,
    g_b1                LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
    g_d1                LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
     g_wc,g_sql          string  #No.FUN-580092 HCN
    #g_desc              LIKE type_file.chr4,         #No.FUN-680070 VARCHAR(4)   #MOD-810004
    #g_resu              LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)   #MOD-810004
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_argv1     LIKE fga_file.fga01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
MAIN
#    DEFINE l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
    DEFINE p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
    INITIALIZE g_fga.* TO NULL
    INITIALIZE g_fga_t.* TO NULL
    INITIALIZE g_fga_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM fga_file WHERE fga01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_cl CURSOR  FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW i200_w AT p_row,p_col
         WITH FORM "afa/42f/afai200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i200_a()
            END IF
         OTHERWISE        
            CALL i200_q() 
      END CASE
   END IF
   #--
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i200_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
END MAIN
 
FUNCTION i200_cs()
    CLEAR FORM
 
   INITIALIZE g_fga.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" fga01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        fga01,fga02,fga03,fga031,fga04,fga06,fga061,fga07,fga071,fga08,fga09,
        fga10,fga11,fga12,fga13,fga14,fga15,fga16,fga20,fga21,fga22,fga23,
        fga24,fga25,
        fgauser,fgagrup,fgamodu,fgadate,fgaacti
        #FUN-850068   ---start---
        ,fgaud01,fgaud02,fgaud03,fgaud04,fgaud05,
        fgaud06,fgaud07,fgaud08,fgaud09,fgaud10,
        fgaud11,fgaud12,fgaud13,fgaud14,fgaud15
        #FUN-850068    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fga03)   #財產編號附號
#                CALL q_faj2(10,3,g_fga.fga03,g_fga.fga031)
#                     RETURNING g_fga.fga03,g_fga.fga031,g_fga.fga04
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faj2"
                 LET g_qryparam.default1 = g_fga.fga03
                 LET g_qryparam.default2 = g_fga.fga031
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga03
                 NEXT FIELD fga03
              WHEN INFIELD(fga10)   #廠商編號
#                CALL q_pmc(0,0,g_fga.fga10) RETURNING g_fga.fga10
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fga.fga10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga10
                 NEXT FIELD fga10
              WHEN INFIELD(fga11)   #製造廠商
#                CALL q_pmc(0,0,g_fga.fga11) RETURNING g_fga.fga11
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fga.fga11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga11
                 NEXT FIELD fga11
              WHEN INFIELD(fga12)   #保管人
#                CALL q_gen(10,3,g_fga.fga12) RETURNING g_fga.fga12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fga.fga12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga12
                 NEXT FIELD fga12
              WHEN INFIELD(fga13)   #保管部門
#                CALL q_gem(10,3,g_fga.fga13) RETURNING g_fga.fga13
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fga.fga13
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga13
                 NEXT FIELD fga13
              WHEN INFIELD(fga14)   #存放位置
#                CALL q_faf(10,3,g_fga.fga14) RETURNING g_fga.fga14
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_fga.fga14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga14
                 NEXT FIELD fga14
              WHEN INFIELD(fga15)   #存放工廠
#                CALL q_azp(6,33,g_fga.fga15) RETURNING g_fga.fga15
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 #LET g_qryparam.form = "q_azp"    #FUN-990031 mark
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add 
                 LET g_qryparam.default1 = g_fga.fga15
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga15
                 NEXT FIELD fga15
              WHEN INFIELD(fga25)   #校正人員
#                CALL q_gen(10,3,g_fga.fga25) RETURNING g_fga.fga25
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fga.fga25
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fga25
                 NEXT FIELD fga25
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
   END IF  #FUN-7C0050
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND fgauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND fgagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND fgagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fgauser', 'fgagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT fga01 FROM fga_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY fga01"
    PREPARE i200_prepare FROM g_sql           # RUNTIME 編譯
        IF STATUS THEN CALL cl_err('prepare:',STATUS,0) RETURN END IF
    DECLARE i200_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i200_prepare
    LET g_sql= "SELECT COUNT(*) FROM fga_file ",
               " WHERE ",g_wc CLIPPED
    PREPARE i200_count_pre    FROM g_sql
    DECLARE i200_count CURSOR FOR i200_count_pre #CKP
END FUNCTION
 
FUNCTION i200_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i200_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i200_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i200_fetch('N')
        ON ACTION previous
            CALL i200_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i200_u()
            END IF
            NEXT OPTION "next"
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i200_x()
            END IF
            NEXT OPTION "next"
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i200_r()
            END IF
            NEXT OPTION "next"
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i200_copy()
            END IF
        ON ACTION calibrat_items
            CALL i200_1()
        ON ACTION qry_calibrat_log
            CALL i200_2()
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION jump
             CALL i200_fetch('/')
         ON ACTION first
             CALL i200_fetch('F')
         ON ACTION last
             CALL i200_fetch('L')
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_fga.fga01 IS NOT NULL THEN
                 LET g_doc.column1 = "fga01"
                 LET g_doc.value1 = g_fga.fga01
                 CALL cl_doc()
              END IF
           END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      #FUN-7C0050
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i200_cs
END FUNCTION
 
 
FUNCTION i200_1()
   DEFINE l_cmd		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
 
   IF g_fga.fga01 IS NULL THEN RETURN END IF
   LET l_cmd = "afai201 '",g_fga.fga01,"'"  # 儀器編號
   CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION i200_2()
   DEFINE l_cmd		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
 
   IF g_fga.fga01 IS NULL THEN RETURN END IF
   LET l_cmd = "afaq250 '",g_fga.fga01,"'"  # 儀器編號
   CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION i200_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_fga.* LIKE fga_file.*
    LET g_fga01_t        = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fga.fga21 ='1'                     #校正別
        LET g_fga.fga22 = g_today                #最近送交日
        LET g_fga.fga24 ='0'                     #校正結果
        LET g_fga.fgaacti ='Y'                   #有效的資料
        LET g_fga.fgauser = g_user               #使用者
        LET g_fga.fgaoriu = g_user #FUN-980030
        LET g_fga.fgaorig = g_grup #FUN-980030
        LET g_fga.fgagrup = g_grup               #使用者所屬群
        LET g_fga.fgadate = g_today
        #-----MOD-810004--------- 
        #CALL i200_fga24(g_fga.fga24) RETURNING g_resu
        #    DISPLAY g_resu TO FORMONLY.resu
        #CALL i200_fga21(g_fga.fga21) RETURNING g_desc
        #    DISPLAY g_desc TO FORMONLY.desc
        #-----END MOD-810004----- 
        CALL i200_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_fga.*  TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_fga.fga01) THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO fga_file VALUES(g_fga.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("ins","fga_file",g_fga.fga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        ELSE
            LET g_fga_t.* = g_fga.*                # 保存上筆資料
            SELECT fga01 INTO g_fga.fga01 FROM fga_file
             WHERE fga01 = g_fga.fga01
             INSERT INTO fgc_file(fgc01,fgc011,fgc02,fgc03,fgc04,fgc05,  #No.MOD-470041
                                 fgc06,fgc07)
                 VALUES(g_fga.fga01,0,g_fga.fga22,' ',g_fga.fga25,' ',
                        g_fga.fga24,g_fga.fga23)
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i200_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
        l_modify_flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_lock_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_exit_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_n             LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    INPUT BY NAME g_fga.fga01,g_fga.fga02,g_fga.fga03,g_fga.fga031,g_fga.fga04, g_fga.fgaoriu,g_fga.fgaorig,
                  g_fga.fga06,g_fga.fga061,g_fga.fga07,g_fga.fga071,g_fga.fga08,
                  g_fga.fga09,g_fga.fga10,g_fga.fga11,g_fga.fga12,g_fga.fga13,
                  g_fga.fga14,g_fga.fga15,g_fga.fga16,g_fga.fga20,g_fga.fga21,
                  g_fga.fga22,g_fga.fga23,g_fga.fga24,g_fga.fga25,
                  g_fga.fgauser,g_fga.fgagrup,g_fga.fgamodu,g_fga.fgadate,
                  g_fga.fgaacti
                  #FUN-850068     ---start---
                  ,g_fga.fgaud01,g_fga.fgaud02,g_fga.fgaud03,g_fga.fgaud04,
                  g_fga.fgaud05,g_fga.fgaud06,g_fga.fgaud07,g_fga.fgaud08,
                  g_fga.fgaud09,g_fga.fgaud10,g_fga.fgaud11,g_fga.fgaud12,
                  g_fga.fgaud13,g_fga.fgaud14,g_fga.fgaud15 
                  #FUN-850068     ----end----
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i200_set_entry(p_cmd)
            CALL i200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD fga01
            IF NOT cl_null(g_fga.fga01) THEN      #不可空白
               IF p_cmd = 'a' OR (p_cmd = 'u' AND
                  g_fga.fga01 != g_fga_t.fga01 ) THEN  #check 編號是否重複
                   SELECT count(*) INTO l_n FROM fga_file
                       WHERE fga01 = g_fga.fga01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fga.fga01 = g_fga_t.fga01
                       DISPLAY BY NAME g_fga.fga01
                       NEXT FIELD fga01
                   END IF
               END IF
            END IF
 
        BEFORE FIELD fga02
            LET l_modify_flag = 'Y'
            IF (l_lock_sw = 'Y') THEN            #已鎖住
                LET l_modify_flag = 'N'
            END IF
            IF (l_modify_flag = 'N') THEN
                LET g_fga.fga01 = g_fga_t.fga01
                DISPLAY BY NAME g_fga.fga01
                NEXT FIELD fga01
            END IF
 
        BEFORE FIELD fga03
            CALL i200_set_entry(p_cmd)
 
        AFTER FIELD fga03
            IF NOT cl_null(g_fga.fga03) THEN
               SELECT COUNT(*) INTO l_n FROM faj_file
                WHERE faj02=g_fga.fga03
                IF l_n=0
                   THEN CALL cl_err('','afa-400',1) NEXT FIELD fga03
                END IF
            END IF
            CALL i200_set_no_entry(p_cmd) 
 
        AFTER FIELD fga031
           IF cl_null(g_fga.fga031) THEN LET g_fga.fga031=' ' END IF
              IF NOT cl_null(g_fga.fga031) THEN         #No.FUN-860092
                 SELECT COUNT(*) INTO l_n FROM faj_file
                  WHERE faj02=g_fga.fga03
                    AND faj022=g_fga.fga031
                    AND faj43 NOT IN ('5','6')
                 IF l_n = 0 THEN
                    CALL cl_err('','afa-911',0)
                    #NEXT FIELD fga031   #MOD-740116
                    NEXT FIELD fga03     #MOD-740116
                 END IF
                 #-----No:FUN-AB0088-----
                 IF g_faa.faa31 = 'Y' THEN
                    SELECT COUNT(*) INTO l_n FROM faj_file
                     WHERE faj02=g_fga.fga03
                       AND faj022=g_fga.fga031
                       AND faj432 NOT MATCHES '[56]'
                    IF l_n = 0 THEN
                       CALL cl_err('','afa-911',0)
                       NEXT FIELD fga03
                    END IF
                 END IF
                 #-----No:FUN-AB0088 END-----
              END IF                                     #No.FUN-860092        
            #bugno:5385
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
                g_fga.fga03 != g_fga_t.fga03 OR g_fga.fga031!=g_fga_t.fga031 ) THEN
 
                SELECT COUNT(*) INTO l_n FROM fga_file
                WHERE fga03 =g_fga.fga03
                  AND fga031=g_fga.fga031
                  IF l_n > 0 THEN
                      CALL cl_err('','afa-914',0)
                      NEXT FIELD fga03
                  END IF
              #-------------MOD-D20031---------------(S)
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM faj_file
                WHERE faj02 = g_fga.fga03
                  AND faj022 = g_fga.fga031
                  AND faj43 IN ('5','6')
               IF l_n > 0 THEN
                  CALL cl_err('','afa-208',1)
                  NEXT FIELD fga03
               END IF
              #-------------MOD-D20031---------------(E)
            END IF
            #bugno:5385
            #bugno6388:
            SELECT faj01 INTO g_fga.fga04 FROM faj_file
            WHERE  faj02=g_fga.fga03
              AND faj022=g_fga.fga031
            DISPLAY BY NAME g_fga.fga04
            #bugno6388:
            IF p_cmd='a' OR g_fga_t.fga03!=g_fga.fga03 OR
                g_fga_t.fga031!=g_fga.fga031 THEN
                CALL i200_fga06('a',g_fga.fga04,g_fga.fga03,g_fga.fga031)
            END IF
 
        AFTER FIELD fga10
            IF NOT cl_null(g_fga.fga10) THEN
               CALL i200_fga10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fga.fga10,g_errno,0)
                  LET g_fga.fga10 = g_fga_t.fga10
                  DISPLAY BY NAME g_fga.fga10
                  NEXT FIELD fga10
               END IF
            END IF
 
        AFTER FIELD fga11
              IF NOT cl_null(g_fga.fga11) THEN
                 CALL i200_fga11('a')
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fga.fga11,g_errno,0)
                    LET g_fga.fga11 = g_fga_t.fga11
                    DISPLAY BY NAME g_fga.fga11
                     NEXT FIELD fga11
                   END IF
              END IF
 
        AFTER FIELD fga12
               IF NOT cl_null(g_fga.fga12) THEN
                  CALL i200_fga12('a')
                  IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fga.fga12,g_errno,0)
                    LET g_fga.fga12 = g_fga_t.fga12
                    DISPLAY BY NAME g_fga.fga12
                    NEXT FIELD fga12
                  END IF
               END IF
 
        AFTER FIELD fga13
               IF NOT cl_null(g_fga.fga13) THEN
                 CALL i200_fga13('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fga.fga13,g_errno,0)
                    LET g_fga.fga13 = g_fga_t.fga13
                    DISPLAY BY NAME g_fga.fga13
                    NEXT FIELD fga13
                 END IF
               END IF
 
        AFTER FIELD fga14
               IF NOT cl_null(g_fga.fga14) THEN
                  CALL i200_fga14('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fga.fga14,g_errno,0)
                    LET g_fga.fga14 = g_fga_t.fga14
                    DISPLAY BY NAME g_fga.fga14
                    NEXT FIELD fga14
                 END IF
               END IF
 
       #start FUN-5A0074
        AFTER FIELD fga15
           IF NOT cl_null(g_fga.fga15) THEN
              CALL i200_fga15('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fga.fga15,g_errno,0)
                 LET g_fga.fga15 = g_fga_t.fga15
                 DISPLAY BY NAME g_fga.fga15
                 NEXT FIELD fga15
              END IF
           END IF
       #end FUN-5A0074
 
        AFTER FIELD fga20
            IF g_fga.fga20 != g_fga_t.fga20 OR  g_fga_t.fga20 IS NULL
               THEN
                   LET g_fga.fga23=g_fga.fga20+g_fga.fga22
                    DISPLAY BY NAME g_fga.fga23
            END IF
            
        #No.TQC-B20113  --Begin
        AFTER FIELD fga22
            IF g_fga.fga22 != g_fga_t.fga22 OR  g_fga_t.fga22 IS NULL
               THEN
                   LET g_fga.fga23=g_fga.fga20+g_fga.fga22
                    DISPLAY BY NAME g_fga.fga23
            END IF
        #No.TQC-B20113  --End
 
        AFTER FIELD fga21
            IF NOT cl_null(g_fga.fga21) THEN
               #IF g_fga.fga21 NOT MATCHES'[12]' THEN NEXT FIELD fga21 END IF   #MOD-810004
               IF g_fga.fga21 NOT MATCHES'[123]' THEN NEXT FIELD fga21 END IF   #MOD-810004
               #CALL i200_fga21(g_fga.fga21) RETURNING g_desc   #MOD-810004
               #DISPLAY g_desc TO FORMONLY.desc   #MOD-810004
            END IF
        #No.TQC-B20150  --Begin
        ON CHANGE fga21
            IF NOT cl_null(g_fga.fga21) THEN
               IF g_fga.fga21 = '3' THEN
                  CALL cl_set_comp_entry("fga20,fga22,fga23,fga24,fga25",FALSE)
                  LET g_fga.fga20 = NULL
                  LET g_fga.fga22 = NULL
                  LET g_fga.fga23 = NULL
                  LET g_fga.fga24 = NULL
                  LET g_fga.fga25 = NULL
               ELSE
                  CALL cl_set_comp_entry("fga20,fga22,fga23,fga24,fga25",TRUE)
               END IF
               DISPLAY BY NAME g_fga.fga20,g_fga.fga21,g_fga.fga22,g_fga.fga23,g_fga.fga24,g_fga.fga25
            END IF
        #No.TQC-B20150  --End

        AFTER FIELD fga24
            IF NOT cl_null(g_fga.fga24) THEN
               IF g_fga.fga24 NOT MATCHES'[01234]' THEN NEXT FIELD fga24 END IF
               #CALL i200_fga24(g_fga.fga24) RETURNING g_resu   #MOD-810004
               #DISPLAY g_resu TO FORMONLY.resu   #MOD-810004
            END IF
 
        AFTER FIELD fga25
            IF NOT cl_null(g_fga.fga25) THEN
               CALL i200_fga25('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fga.fga25,g_errno,0)
                  LET g_fga.fga25 = g_fga_t.fga25
                  DISPLAY BY NAME g_fga.fga14
                  NEXT FIELD fga25
               END IF
            END IF
 
        #FUN-850068     ---start---
        AFTER FIELD fgaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
        AFTER INPUT  #
           LET g_fga.fgauser = s_get_data_owner("fga_file") #FUN-C10039
           LET g_fga.fgagrup = s_get_data_group("fga_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(fga01) THEN
       #         LET g_fga.* = g_fga_t.*
       #         DISPLAY BY NAME g_fga.*
       #         NEXT FIELD fga01
       #     END IF
        #MOD-650015 --start 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fga03)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj2"
                 LET g_qryparam.default1 = g_fga.fga03
                 LET g_qryparam.default2 = g_fga.fga031
                 CALL cl_create_qry() RETURNING g_fga.fga03,g_fga.fga031,g_fga.fga04
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga031 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga04 )
#                 CALL q_faj2(10,3,g_fga.fga03,g_fga.fga031)
#                       RETURNING g_fga.fga03,g_fga.fga031,g_fga.fga04
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga031 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga04 )
                 DISPLAY BY NAME g_fga.fga03,g_fga.fga031,g_fga.fga04
                 NEXT FIELD fga03
              WHEN INFIELD(fga10)   #廠商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fga.fga10
                 CALL cl_create_qry() RETURNING g_fga.fga10
#                 CALL q_pmc(0,0,g_fga.fga10) RETURNING g_fga.fga10
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga10 )
                 DISPLAY BY NAME g_fga.fga10
                 NEXT FIELD fga10
              WHEN INFIELD(fga11)   #製造廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fga.fga11
                 CALL cl_create_qry() RETURNING g_fga.fga11
#                 CALL q_pmc(0,0,g_fga.fga11) RETURNING g_fga.fga11
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga11 )
                 DISPLAY BY NAME g_fga.fga11
                 NEXT FIELD fga11
              WHEN INFIELD(fga12)   #保管人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fga.fga12
                 CALL cl_create_qry() RETURNING g_fga.fga12
#                 CALL q_gen(10,3,g_fga.fga12) RETURNING g_fga.fga12
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga12 )
                 DISPLAY BY NAME g_fga.fga12
                 NEXT FIELD fga12
              WHEN INFIELD(fga13)   #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fga.fga13
                 CALL cl_create_qry() RETURNING g_fga.fga13
#                 CALL q_gem(10,3,g_fga.fga13) RETURNING g_fga.fga13
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga13 )
                 DISPLAY BY NAME g_fga.fga13
                 NEXT FIELD fga13
              WHEN INFIELD(fga14)   #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_fga.fga14
                 CALL cl_create_qry() RETURNING g_fga.fga14
#                 CALL q_faf(10,3,g_fga.fga14) RETURNING g_fga.fga14
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga14 )
                 DISPLAY BY NAME g_fga.fga14
                 NEXT FIELD fga14
              WHEN INFIELD(fga15)   #存放工廠
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azp"    #FUN-990031 mark
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add 
                 LET g_qryparam.default1 = g_fga.fga15
                 CALL cl_create_qry() RETURNING g_fga.fga15
#                 CALL q_azp(6,33,g_fga.fga15) RETURNING g_fga.fga15
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga15 )
                 DISPLAY BY NAME g_fga.fga15
                 NEXT FIELD fga15
              WHEN INFIELD(fga25)   #校正人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fga.fga25
                 CALL cl_create_qry() RETURNING g_fga.fga25
#                 CALL q_gen(10,3,g_fga.fga25) RETURNING g_fga.fga25
#                 CALL FGL_DIALOG_SETBUFFER( g_fga.fga25 )
                 DISPLAY BY NAME g_fga.fga25
                 CALL i200_fga25('d')   #MOD-740116
                 NEXT FIELD fga25
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
 
FUNCTION i200_fga06(p_cmd,l_faj01,l_faj02,l_faj022)
DEFINE p_cmd   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_faj01    LIKE faj_file.faj01,
       l_faj02    LIKE faj_file.faj02,
       l_faj022   LIKE faj_file.faj022
 
    IF l_faj022 IS NULL THEN LET l_faj022= ' ' END IF
    SELECT faj06,faj061,faj07,faj071,faj08,faj10,faj11,faj19,faj20,
          #faj21,faj25             #FUN-5A0074 mark
           faj21,faj22,faj25       #FUN-5A0074
    INTO g_fga.fga06,g_fga.fga061,g_fga.fga07,g_fga.fga071,g_fga.fga08,
         g_fga.fga10,g_fga.fga11,g_fga.fga12,g_fga.fga13,g_fga.fga14,
        #g_fga.fga16               #FUN-5A0074 mark
         g_fga.fga15,g_fga.fga16   #FUN-5A0074
      FROM faj_file
     WHERE faj01=l_faj01
       AND faj02=l_faj02
       AND faj022=l_faj022
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
             LET g_fga.fga06 ='' LET g_fga.fga061 ='' LET g_fga.fga07 =''
             LET g_fga.fga071='' LET g_fga.fga08 ='' LET g_fga.fga10 =''
             LET g_fga.fga11 ='' LET g_fga.fga12 ='' LET g_fga.fga13 =''
             LET g_fga.fga14 ='' LET g_fga.fga16 =''
         DISPLAY g_fga.fga06  TO fga06  #
         DISPLAY g_fga.fga061 TO fga061 #
         DISPLAY g_fga.fga07  TO fga07  #
         DISPLAY g_fga.fga071 TO fga071 #
         DISPLAY g_fga.fga08  TO fga08  #
         DISPLAY g_fga.fga10  TO fga10  #
         DISPLAY g_fga.fga11  TO fga11  #
         DISPLAY g_fga.fga12  TO fga12  #
         DISPLAY g_fga.fga13  TO fga13  #
         DISPLAY g_fga.fga14  TO fga14  #
         DISPLAY g_fga.fga15  TO fga15  #FUN-5A0074
         DISPLAY g_fga.fga16  TO fga16  #
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY g_fga.fga06  TO fga06  #
         DISPLAY g_fga.fga061 TO fga061 #
         DISPLAY g_fga.fga07  TO fga07  #
         DISPLAY g_fga.fga071 TO fga071 #
         DISPLAY g_fga.fga08  TO fga08  #
         DISPLAY g_fga.fga10  TO fga10  #
         DISPLAY g_fga.fga11  TO fga11  #
         DISPLAY g_fga.fga12  TO fga12  #
         DISPLAY g_fga.fga13  TO fga13  #
         DISPLAY g_fga.fga14  TO fga14  #
         DISPLAY g_fga.fga15  TO fga15  #FUN-5A0074
         DISPLAY g_fga.fga16  TO fga16  #
    END IF
    CALL i200_fga10('d')
    CALL i200_fga11('d')
    CALL i200_fga12('d')
    CALL i200_fga13('d')
    CALL i200_fga14('d')
    CALL i200_fga15('d')   #FUN-5A0074
END FUNCTION
 
FUNCTION i200_fga10(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
           FROM pmc_file WHERE pmc01 = g_fga.fga10
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
    #FUN-690024------mod-------
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690024------mod-------         
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_pmc03 TO FORMONLY.pmc03 #
    END IF
END FUNCTION
 
FUNCTION i200_fga11(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_pmc03_2   LIKE pmc_file.pmc03
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmcacti INTO l_pmc03_2,l_pmcacti
           FROM pmc_file WHERE pmc01 = g_fga.fga11
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
    #FUN-690024------mod-------
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690024------mod-------         
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_pmc03_2 TO FORMONLY.pmc03_2 #
    END IF
END FUNCTION
 
FUNCTION i200_fga12(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
      FROM gen_file
     WHERE gen01 = g_fga.fga12
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02_1 #
    END IF
END FUNCTION
 
FUNCTION i200_fga13(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gem02    LIKE gem_file.gem02,
       l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fga.fga13
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem02 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gem02 TO FORMONLY.gem02 #
    END IF
END FUNCTION
 
FUNCTION i200_fga14(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_faf02    LIKE faf_file.faf02,
       l_fafacti  LIKE faf_file.fafacti
 
    LET g_errno = ' '
    SELECT faf02,fafacti INTO l_faf02,l_fafacti
      FROM faf_file
     WHERE faf01 = g_fga.fga14
    CASE
      #WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'   #FUN-5A0074 mark
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9089'   #FUN-5A0074
                                LET l_faf02 = NULL
                                LET l_fafacti = NULL
       WHEN l_fafacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #start FUN-5A0074
      #LET g_fga.fga15 = l_faf02
      #DISPLAY BY NAME g_fga.fga15
       DISPLAY l_faf02 TO FORMONLY.faf02
      #end FUN-5A0074
    END IF
END FUNCTION
 
#start FUN-5A0074
FUNCTION i200_fga15(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_azp02    LIKE azp_file.azp02
 
   LET g_errno = ' '
   #FUN-990031--mod--str--營運中心控制在當前法人下
   #SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_fga.fga15  
   SELECT azp02 INTO l_azp02 FROM azp_file,azw_file 
    WHERE azp01 = azw01
      AND azw01 = g_fga.fga15
      AND azw02 = g_legal
    #FUN-990031--mod--end
   CASE
      WHEN SQLCA.SQLCODE = 100 #LET g_errno = 'aap-025'    #FUN-990031 mark
                               LET g_errno = 'agl-171'     #FUN-990031 add
                               LET l_azp02 = NULL
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.azp02
   END IF
END FUNCTION
#end FUN-5A0074
 
#-----MOD-810004---------
{
FUNCTION i200_fga21(l_fga21)
DEFINE
      l_fga21   LIKE fga_file.fga21,
      l_bn      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
 
     CASE l_fga21
         WHEN '1'
            CALL cl_getmsg('afa-402',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-403',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION i200_fga24(l_fga24)
DEFINE
      l_fga24   LIKE fga_file.fga24,
      l_bn      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
 
#－0:未校 1:正常 2:停用 3.退修 4.報廢
     CASE l_fga24
         WHEN '0'
            CALL cl_getmsg('afa-404',g_lang) RETURNING l_bn
         WHEN '1'
            CALL cl_getmsg('afa-405',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-406',g_lang) RETURNING l_bn
         WHEN '3'
            CALL cl_getmsg('afa-407',g_lang) RETURNING l_bn
         WHEN '4'
            CALL cl_getmsg('afa-408',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
}
#-----END MOD-810004-----
 
FUNCTION i200_fga25(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
      FROM gen_file
     WHERE gen01 = g_fga.fga25
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02_2 #
    END IF
END FUNCTION
 
FUNCTION i200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fga.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i200_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i200_count
    FETCH i200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)
        INITIALIZE g_fga.* TO NULL
    ELSE
        CALL i200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i200_fetch(p_flfga)
    DEFINE
        p_flfga          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfga
        WHEN 'N' FETCH NEXT     i200_cs INTO g_fga.fga01
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_fga.fga01
        WHEN 'F' FETCH FIRST    i200_cs INTO g_fga.fga01
        WHEN 'L' FETCH LAST     i200_cs INTO g_fga.fga01
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
         FETCH ABSOLUTE g_jump i200_cs INTO g_fga.fga01
         LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)
        INITIALIZE g_fga.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flfga
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fga.* FROM fga_file        # 重讀DB,因TEMP有不被更新特性
       WHERE fga01 = g_fga.fga01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fga_file",g_fga.fga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        LET g_data_owner = g_fga.fgauser   #FUN-4C0059
        LET g_data_group = g_fga.fgagrup   #FUN-4C0059
        CALL i200_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i200_show()
    LET g_fga_t.* = g_fga.*
    LET g_fga_o.*=g_fga.*
    DISPLAY BY NAME g_fga.fga01,g_fga.fga02,g_fga.fga03,g_fga.fga031, g_fga.fgaoriu,g_fga.fgaorig,
                    g_fga.fga04,g_fga.fga06,g_fga.fga061,g_fga.fga07,
                    g_fga.fga071,g_fga.fga08,g_fga.fga09,g_fga.fga10,
                    g_fga.fga11,g_fga.fga12,g_fga.fga13,g_fga.fga14,
                    g_fga.fga15,g_fga.fga16,g_fga.fga20,g_fga.fga21,
                    g_fga.fga22,g_fga.fga23,g_fga.fga24,g_fga.fga25,
                    g_fga.fgauser,g_fga.fgagrup,g_fga.fgamodu,g_fga.fgadate,
                    g_fga.fgaacti
                    #FUN-850068     ---start---
                    ,g_fga.fgaud01,g_fga.fgaud02,g_fga.fgaud03,g_fga.fgaud04,
                    g_fga.fgaud05,g_fga.fgaud06,g_fga.fgaud07,g_fga.fgaud08,
                    g_fga.fgaud09,g_fga.fgaud10,g_fga.fgaud11,g_fga.fgaud12,
                    g_fga.fgaud13,g_fga.fgaud14,g_fga.fgaud15 
                    #FUN-850068     ----end----
           #
    CALL i200_fga10('d')
    CALL i200_fga11('d')
    CALL i200_fga12('d')
    CALL i200_fga13('d')
    CALL i200_fga14('d')
    CALL i200_fga15('d')   #FUN-5A0074
    #CALL i200_fga21(g_fga.fga21) RETURNING g_desc   #MOD-810004
    #DISPLAY g_desc TO FORMONLY.desc #   #MOD-810004
    CALL i200_fga25('d')
    #CALL i200_fga24(g_fga.fga24) RETURNING g_resu   #MOD-810004
    #DISPLAY g_resu TO FORMONLY.resu #   #MOD-810004
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fga.fga01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_fga.* FROM fga_file WHERE fga01 = g_fga.fga01
    IF g_fga.fgaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fga.fga01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fga01_t = g_fga.fga01
    BEGIN WORK
 
    OPEN i200_cl USING g_fga.fga01
 
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_fga.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_fga.fgamodu=g_user                     #修改者
    LET g_fga.fgadate = g_today                  #修改日期
    CALL i200_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i200_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fga.*=g_fga_t.*
            CALL i200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE fga_file SET fga_file.* = g_fga.*    # 更新DB
            WHERE fga01 = g_fga.fga01               # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fga_file",g_fga01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        UPDATE fgc_file SET *= (g_fga.fga01,0,g_fga.fga22,' ',
                                g_fga.fga25,' ',g_fga.fga24,g_fga.fga23)
            WHERE fgc01=g_fga.fga01 AND fgc011=0
        EXIT WHILE
    END WHILE
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_x()
    DEFINE
        l_chr LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fga.fga01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i200_cl USING g_fga.fga01
 
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_fga.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i200_show()
    IF cl_exp(15,21,g_fga.fgaacti) THEN
        LET g_chr=g_fga.fgaacti
        IF g_fga.fgaacti='Y' THEN
            LET g_fga.fgaacti='N'
        ELSE
            LET g_fga.fgaacti='Y'
        END IF
        UPDATE fga_file
            SET fgaacti=g_fga.fgaacti,
                fgamodu=g_user, fgadate=g_today
            WHERE fga01=g_fga.fga01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fga_file",g_fga.fga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            LET g_fga.fgaacti=g_chr
        END IF
        DISPLAY BY NAME g_fga.fgaacti
    END IF
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_r()
    DEFINE l_chr   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_cnt   LIKE type_file.num5         #MOD-930184 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fga.fga01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #str MOD-930184 add
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM fgc_file
     WHERE fgc01=g_fga.fga01 AND fgc011>0
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-194',0)
       RETURN
    END IF
   #end MOD-930184 add
    BEGIN WORK
 
    OPEN i200_cl USING g_fga.fga01
 
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_fga.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i200_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fga01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fga.fga01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM fga_file WHERE fga01 = g_fga.fga01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_fga.fga01,SQLCA.sqlcode,0)   #No.FUN-660136
          CALL cl_err3("del","fga_file",g_fga.fga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
       ELSE CLEAR FORM
         #CKP3
         OPEN i200_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i200_cs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i200_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i200_cs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i200_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i200_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i200_fetch('/')
         END IF
       END IF
    END IF
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_copy()
   DEFINE l_fga           RECORD LIKE fga_file.*,
          l_oldno,l_newno LIKE fga_file.fga01,
          l_oldno1,l_newno1 LIKE fga_file.fga03,
          l_oldno2,l_newno2 LIKE fga_file.fga031,
          l_fga04           LIKE fga_file.fga04,
          l_n               LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fga.fga01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i200_set_entry('a')
    LET g_before_input_done = TRUE
#   INPUT l_newno,l_newno1,l_newno2 FROM fga01,fga03,fga03        #No.TQC-960325 
    INPUT l_newno,l_newno1,l_newno2 FROM fga01,fga03,fga031       #No.TQC-960325 
        AFTER FIELD fga01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM fga_file
                   WHERE fga01 = l_newno
               IF g_cnt > 0 THEN
                  LET g_msg = l_newno CLIPPED
                  CALL cl_err(g_msg,-239,0)
                  NEXT FIELD fga01
               END IF
            END IF
         AFTER FIELD fga03
            IF NOT cl_null(l_newno1) THEN
               SELECT COUNT(*) INTO l_n FROM faj_file
                WHERE faj02=l_newno1
                IF l_n=0
                   THEN CALL cl_err('','afa-400',1) NEXT FIELD fga03
                END IF
            END IF
        AFTER FIELD fga031
            IF cl_null(l_newno2) THEN LET l_newno2=' ' END IF
            IF NOT cl_null(l_newno2) THEN       #No.FUN-860092  
               SELECT COUNT(*) INTO l_n FROM faj_file
                WHERE faj02=l_newno1
                  AND faj022=l_newno2
                  AND faj43 NOT IN ('5','6')
               IF l_n = 0 THEN
                  CALL cl_err('','afa-911',0)
                  #NEXT FIELD fga031    #MOD-740116
                  NEXT FIELD fga03      #MOD-740116
               END IF
               #-----No:FUN-AB0088-----
               IF g_faa.faa31 = 'Y' THEN
                  SELECT COUNT(*) INTO l_n FROM faj_file
                   WHERE faj02=g_fga.fga03
                     AND faj022=g_fga.fga031
                     AND faj432 NOT MATCHES '[56]'
                  IF l_n = 0 THEN
                     CALL cl_err('','afa-911',0)
                     NEXT FIELD fga03
                  END IF
               END IF
               #-----No:FUN-AB0088 END-----
            END IF                       #TQC-B20111
            SELECT COUNT(*) INTO l_n FROM fga_file   #bugno:5385
             WHERE fga03 =l_newno1
               AND fga031=l_newno2
            IF l_n > 0 THEN
               CALL cl_err('','afa-914',0)
               NEXT FIELD fga03
            END IF
           #-------------MOD-D20031---------------(S)
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM faj_file
             WHERE faj02 = l_newno1
               AND faj022 = l_newno2
               AND faj43 IN ('5','6')
            IF l_n > 0 THEN
               CALL cl_err('','afa-208',1)
               NEXT FIELD fga03
            END IF
           #-------------MOD-D20031---------------(E)
            #   END IF                             #No.FUN-860092  #No.TQC-B20111 mark
            #No.TQC-B20111  --Begin  
            SELECT faj01 INTO l_fga04 FROM faj_file
            WHERE  faj02=l_newno1
              AND  faj022=l_newno2
            DISPLAY BY NAME l_fga04 
            CALL i200_fga06('a',l_fga04,l_newno1,l_newno2)
            #No.TQC-B20111  --End          
        ON ACTION controlp
           CASE
              WHEN INFIELD(fga03)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj2"
                 LET g_qryparam.default1 = l_newno1
                 LET g_qryparam.default2 = l_newno2
                 CALL cl_create_qry() RETURNING l_newno1,l_newno2,l_fga04
#                 CALL FGL_DIALOG_SETBUFFER( l_newno1 )
#                 CALL FGL_DIALOG_SETBUFFER( l_newno2 )
#                 CALL FGL_DIALOG_SETBUFFER( l_fga04 )
#                 CALL q_faj2(10,3,l_newno1,l_newno2)
#                       RETURNING l_newno1,l_newno2,l_fga04
#                 CALL FGL_DIALOG_SETBUFFER( l_newno1 )
#                 CALL FGL_DIALOG_SETBUFFER( l_newno2 )
#                 CALL FGL_DIALOG_SETBUFFER( l_fga04 )
                 DISPLAY l_newno1,l_newno2,l_fga04  TO fga03,fga031,fga04
                 CALL i200_fga06('a',l_fga04,l_newno1,l_newno2)
                 NEXT FIELD fga03
           END CASE
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_fga.fga01 #
        RETURN
    END IF
    LET l_fga.* = g_fga.*
    LET l_fga.fga01  =l_newno  #資料鍵值
    LET l_fga.fga03  =l_newno1  #資料鍵值
    LET l_fga.fga031 =l_newno2  #資料鍵值
    LET l_fga.fga04  =l_fga04   #
    LET l_fga.fgauser=g_user    #資料所有者
    LET l_fga.fgagrup=g_grup    #資料所有者所屬群
    LET l_fga.fgamodu=NULL      #資料修改日期
    LET l_fga.fgadate=g_today   #資料建立日期
    LET l_fga.fgaacti='Y'       #有效資料
    LET l_fga.fgaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_fga.fgaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO fga_file VALUES (l_fga.*)
        LET g_msg = l_newno CLIPPED
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("ins","fga_file",l_fga.fga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        MESSAGE 'ROW(',g_msg,') O.K'
        SLEEP 2
        LET l_oldno = g_fga.fga01
        LET g_fga.fga01 = l_newno
        LET g_fga.fga03 = l_newno1
        LET g_fga.fga031 = l_newno2
 SELECT fga_file.* INTO g_fga.* FROM fga_file
                       WHERE fga01 = l_newno
        CALL i200_u()
 #SELECT fga_file.* INTO g_fga.* FROM fga_file  #FUN-C30027
 #                      WHERE fga01 = l_oldno   #FUN-C30027
    END IF
    CALL i200_show()
END FUNCTION
 
FUNCTION i200_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fga01",TRUE)
   END IF
   IF INFIELD(fga03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fga22,fga23",TRUE)
   END IF
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_n     LIKE type_file.num10        #No.FUN-680070 INTEGER
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fga01",FALSE)
   END IF
   IF INFIELD(fga03) OR (NOT g_before_input_done) THEN
      IF p_cmd = 'u' THEN
         SELECT COUNT(*) INTO l_n FROM fgc_file
          WHERE fgc01 = g_fga.fga01 #TQC-C50041 mod fga03--->fga01
            AND fgc011 !='0'
         IF l_n > 0 THEN
            CALL cl_set_comp_entry("fga22,fga23",FALSE)
         END IF
      END IF
  END IF
END FUNCTION

