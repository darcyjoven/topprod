# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: abmi605.4gl
# Descriptions...: 產品結構元件資料維護作業
# Date & Author..: 91/08/10 By Wu
# Modify         : 92/05/04 By DAVID
# Modify.........: 92/10/30 By Apple
# 1993/01/11(Lee): 在bmb05允許按^O執行abmi650
#                : By Lynn 1.default 工程圖號(bmb11) 為ima_file (ima04)
#                :         2.消耗料件不須判斷製程管理(sma54),多倉(sma12)
#                :         3.作業序號不須判斷製程管理(sma54)
#                :         4.銷單上排列順序(bmb20),銷單列印否(bmb19),
#                :           銷單列印成本否(bmb21),銷單列印單價否(bmb22)
#                :           四欄位拿掉
# Modify.........: No:7866 03/08/22 By Mandy 若BOM已發放後不得修改為Y ,就不應可以新增項次(sma101)
# Modify.........: No:7883 03/08/22 By Mandy bmbmodu/bmbdate 欄位未更新
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-550093 05/05/30 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/07 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560107 05/06/18 By kim abmi600外部呼叫,加一參數,傳特性代碼
# Modify.........: No.MOD-5C0034 05/12/09 By kim "發料單位"改變，"轉換率（發料/料件成本）"不會跟著變
# Modify.........: No.MOD-610014 06/01/05 By Claire sma101 考慮 S
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-640208 06/09/05 By kim if bmb15 <> ima70 then warning
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.MOD-6B0129 06/12/08 By Claire 取消新增及開窗改開bma_file
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750225 07/05/28 By arman 狀態Page無法下條件查詢
# Modify.........: No.MOD-780015 07/08/06 By pengu 點選 [明細單身]依照所選之下階料號帶出資料
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33賦值
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.TQC-890018 08/10/03 By claire 更新bma_file,bmamodu,bmadate
# Modify.........: No.MOD-8C0097 08/12/10 By claire 修改時,程式會在AFTER FIELD bmb01 LOOP
# Modify.........: No.FUN-910053 09/02/12 By jan bmb14 欄位加上2，3 選項
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0084 09/10/21 By Smapmin 將CALL abmi604中,update bmb_file的動作,移到CALL abmi604之後才做
# Modify.........: No:TQC-A10054 10/01/07 By sherry 投料時距沒有做負數控管
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/26 By lilingyu bmb16欄位增加"7.可規格替代"選項 
# Modify.........: No.FUN-A40058 10/04/26 By lilingyu bmb16欄位增加規格替代的相關邏輯
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 規通料件整合(3)全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.MOD-AC0379 10/12/29 By vealxu bmb18為正時會延後發料，為負時會提前發料，所以abmi605.bmb18不可控卡為負
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-CC0097 12/12/14 By suncx 調整存儲位置開窗
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmb   RECORD LIKE bmb_file.*,
    g_bmb_t RECORD LIKE bmb_file.*,
    g_bmb_o RECORD LIKE bmb_file.*,
    g_bmb01_t LIKE bmb_file.bmb01,
    g_bmb02_t LIKE bmb_file.bmb02,
    g_bmb03_t LIKE bmb_file.bmb03,
    g_bmb04_t LIKE bmb_file.bmb04,
    g_bmb29_t LIKE bmb_file.bmb29, #FUN-550093
    g_bmb10_t LIKE bmb_file.bmb10,
    g_bmb25_t LIKE bmb_file.bmb25,
    g_bmb26_t LIKE bmb_file.bmb26,
    g_ima08_h LIKE ima_file.ima08,
    g_ima37_h LIKE ima_file.ima37,
    g_ima70_h LIKE ima_file.ima70,
    g_ima08_b LIKE ima_file.ima08,
    g_ima37_b LIKE ima_file.ima37,
    g_ima70_b LIKE ima_file.ima70,
    g_ima25_b LIKE ima_file.ima25,
    g_ima63_b LIKE ima_file.ima63,
    g_ima86_b LIKE ima_file.ima86,
    g_ima63_fac LIKE ima_file.ima63_fac,
    g_argv1     LIKE bmb_file.bmb01,     #No.MOD-490217
    g_argv2     LIKE type_file.dat,      #No.FUN-680096 DATE
    g_argv3     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(300)
    g_argv4     LIKE bmb_file.bmb29,     #FUN-560107
    g_argv5     LIKE bmb_file.bmb03,  #No.MOD-780015 add
    g_sw        LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    g_ecd03     LIKE ecd_file.ecd03,
    g_factor    LIKE pml_file.pml09,     #No.FUN-680096 DEC(16,8)
    g_wc,g_sql  string,                  #No.FUN-580092 HCN
    g_bma05     LIKE bma_file.bma05,
    g_ima08     LIKE ima_file.ima08,
    g_ima70     LIKE ima_file.ima70      #FUN-640208
DEFINE g_forupd_sql          STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_bmb.* TO NULL
    INITIALIZE g_bmb_t.* TO NULL
    INITIALIZE g_bmb_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bmb_file WHERE bmb01 = ? AND bmb02 = ? AND bmb03 = ? AND bmb04 = ? AND bmb29 =? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i605_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL s_decl_bmb()
 
    OPEN WINDOW i605_w WITH FORM "abm/42f/abmi605"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv4 = ARG_VAL(3) #FUN-560107
    LET g_argv5 = ARG_VAL(4) #No.MOD-780015 add
 
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL i605_q()
    END IF
 
      LET g_action_choice=""
      CALL i605_menu()
 
    CLOSE WINDOW i605_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i605_curs()
DEFINE  l_cmd     LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(100)
    CLEAR FORM
    DISPLAY BY NAME  g_bmb.bmb01
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql="SELECT bmb01,bmb02,bmb03,bmb04,bmb13,bmb29 ", #FUN-550093
                      " FROM bmb_file ",                      # 組合出 SQL 指令
                      " WHERE bmb01 ='",g_argv1,"'",
                      " AND  bmb29='",g_argv4,"'", #FUN-560107
                      " AND  bmb03='",g_argv5,"'"      #No.MOD-780015 add
            IF g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
               LET  g_sql = g_sql  CLIPPED,
                         " AND (bmb04 <='", g_argv2,"'"," OR bmb04 IS NULL )",
                         " AND (bmb05 > '",g_argv2,"'"," OR bmb05 IS NULL )"
            END IF
          # IF not cl_null(g_argv3) THEN
          #    LET g_sql = g_sql clipped," AND ","'",g_argv3 CLIPPED,"'"
          # END IF
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb02,bmb03,bmb04,bmb29" #FUN-550093
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb03,bmb02,bmb04,bmb29" #FUN-550093
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb13,bmb02,bmb03,bmb04,bmb29" #FUN-550093
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb02,bmb03,bmb04, bmb29" #FUN-550093
            END CASE
       ELSE
   INITIALIZE g_bmb.* TO NULL    #No.FUN-750051
            CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              bmb01,bmb02,bmb29,bmb03,bmb04,bmb05,bmb10,bmb10_fac, #FUN-550093
              bmb10_fac2, bmb06,bmb07,bmb08,bmb23,bmb11,bmb13,bmb16,
              bmb27,bmb15,bmb09,bmb18,bmb28,bmb19,bmb14,bmb25,bmb26,bmb24,
              bmbmodu,bmbdate,bmbcomm    #NO.TQC-750225
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION controlp
               CASE
                  WHEN INFIELD(bmb01) #料件主檔
#                    CALL q_ima(3,2,g_bmb.bmb01) RETURNING g_bmb.bmb01
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bma2"   #MOD-6B0129 modify ima"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_bmb.bmb01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmb01
                     NEXT FIELD bmb01
                  WHEN INFIELD(bmb03) #料件主檔
#                    CALL q_ima(3,2,g_bmb.bmb03) RETURNING g_bmb.bmb03
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.state = "c"
                   #  LET g_qryparam.default1 = g_bmb.bmb03
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","",g_bmb.bmb03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmb03
                     NEXT FIELD bmb03
                  WHEN INFIELD(bmb09) #作業主檔
                     CALL q_ecd(TRUE,TRUE,g_bmb.bmb09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmb09
                     NEXT FIELD bmb09
                  WHEN INFIELD(bmb10) #單位檔
#                    CALL q_gfe(3,2,g_bmb.bmb10) RETURNING g_bmb.bmb10
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_bmb.bmb10
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmb10
                     NEXT FIELD bmb10
                  WHEN INFIELD(bmb25) #倉庫
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imfd"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_bmb.bmb25
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmb25
                     NEXT FIELD bmb25
                  #MOD-CC0097 mark begin----------------------------------------
                  #WHEN INFIELD(bmb26) #儲位
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_imfe"
                  #   LET g_qryparam.state = "c"
                  #   LET g_qryparam.default1 = g_bmb.bmb26
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #   DISPLAY g_qryparam.multiret TO bmb26
                  #   NEXT FIELD bmb26
                  #MOD-CC0097 mark end------------------------------------------
                  WHEN INFIELD(bmb05)
                     IF g_bmb_t.bmb02 IS NOT NULL
                        THEN LET l_cmd = "abmi603 '",g_bmb.bmb01,"'",
                                          " '",g_bmb.bmb02,"' '",  #No.B062
                                          g_bmb.bmb03,"' '",
                                          g_bmb.bmb04,"' '",
                                          g_bmb.bmb29,"'" CLIPPED #FUN-550093
                             CALL cl_cmdrun(l_cmd)
                     END IF
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
 
             LET g_sql="SELECT bmb01,bmb02,bmb03,bmb04,bmb13,bmb29 ", #FUN-550093
                       " FROM bmb_file ",                      # 組合出 SQL 指令
                       " WHERE ",g_wc CLIPPED
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb02,bmb03,bmb04,bmb29" #FUN-550093
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb03,bmb02,bmb04,bmb29" #FUN-550093
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb13,bmb02,bmb03,bmb04,bmb29" #FUN-550093
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY bmb01,bmb02,bmb03,bmb04,bmb29" #FUN-550093
            END CASE
    END IF
 
    PREPARE i605_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i605_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i605_prepare
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql =
                "SELECT COUNT(*) FROM bmb_file WHERE bmb01 ='",g_argv1,"'",
                                               " AND bmb29 ='",g_argv4,"'",#FUN-560107
                                               " AND bmb03 ='",g_argv5,"'"  #No.MOD-780015 add
       ELSE LET g_sql=
                "SELECT COUNT(*) FROM bmb_file WHERE ",g_wc CLIPPED
    END IF
    PREPARE i605_precount FROM g_sql
    DECLARE i605_count CURSOR FOR i605_precount
END FUNCTION
 
FUNCTION i605_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
       #MOD-6B0129-begin-add
        #ON ACTION insert
        #    LET g_action_choice="insert"
        #    IF cl_chk_act_auth() THEN
        #         CALL i605_a()
        #    END IF
       #MOD-6B0129-end-add
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i605_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i605_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i605_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i605_copy()
            END IF
        ON ACTION gen_group_link
           IF g_ima08_h = 'A' AND g_bmb.bmb01 IS NOT NULL THEN
              CALL p500_tm(0,0,g_bmb.bmb01)
           ELSE
              CALL cl_err(g_bmb.bmb01,'mfg2634',0)
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
 
         ON ACTION first
            CALL i605_fetch('F')
         ON ACTION next
            CALL i605_fetch('N')
         ON ACTION jump
            CALL i605_fetch('/')
         ON ACTION previous
            CALL i605_fetch('P')
         ON ACTION last
            CALL i605_fetch('L')
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
 
          ON ACTION related_document                  #MOD-470051
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_bmb.bmb01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmb01"
                  LET g_doc.value1  = g_bmb.bmb01
                  LET g_doc.column2 = "bmb02"
                  LET g_doc.value2  = g_bmb.bmb02
                  LET g_doc.column3 = "bmb03"
                  LET g_doc.value3  = g_bmb.bmb03
                  LET g_doc.column4 = "bmb04"
                  LET g_doc.value4  = g_bmb.bmb04
                  LET g_doc.column5 = "bmb29" #FUN-550093
                  LET g_doc.value5  = g_bmb.bmb29 #FUN-550093
                  CALL cl_doc()
               END IF
            END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i605_curs
END FUNCTION
 
 
FUNCTION i605_a()
    #No:7866
    #BOM表發放後是否可以修改單身
    IF g_sma.sma101='N' THEN
       #參數(sma101)設定BOM表發放後不可以修改單身,所以不能做新增
       CALL cl_err('','abm-605',0)
       RETURN
    END IF
    #No:7866(end)
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bmb.* LIKE bmb_file.*
    LET g_bmb01_t = NULL
    LET g_bmb02_t = NULL
    LET g_bmb03_t = NULL
    LET g_bmb04_t = NULL
    LET g_bmb29_t = NULL #FUN-550093
    LET g_bmb_t.*=g_bmb.*
    LET g_bmb_o.*=g_bmb.*
    LET g_bmb.bmb01 = ARG_VAL(1)
    LET g_bmb.bmb04 = g_today
    LET g_bmb.bmb06 = 1
    LET g_bmb.bmb07 = 1
    LET g_bmb.bmb08 = 0
    LET g_bmb.bmb09 = ''
    LET g_bmb.bmb10_fac = 1
    LET g_bmb.bmb10_fac2 = 1
    LET g_bmb.bmb14 = '0'
    LET g_bmb.bmb15 = 'N'
    LET g_bmb.bmb17 = 'N'
    LET g_bmb.bmb16 = '0'
    LET g_bmb.bmb18 =  0
    LET g_bmb.bmb23 = 0
    LET g_bmb.bmb25 =  NULL
    LET g_bmb.bmb26 =  NULL
    LET g_bmb.bmb29 = ' ' #FUN-550093
   #No.+114
    IF cl_null(g_bmb.bmb28) THEN
       LET g_bmb.bmb28 = 0
    END IF
   #No.+114
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i605_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_bmb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_bmb.bmb01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
       #No.+114
        IF cl_null(g_bmb.bmb28) THEN
           LET g_bmb.bmb28 = 0
        END IF
       #No.+114
 
        #MOD-790002.................begin
        IF cl_null(g_bmb.bmb02)  THEN
           LET g_bmb.bmb02=' '
        END IF
        #MOD-790002.................end
 
        #No.FUN-830116--BEGIN--
        LET g_bmb.bmb33 = 0
        #No.FUN-830116--END--
        INSERT INTO bmb_file VALUES(g_bmb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                      CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
                      '+',g_bmb.bmb29  #FUN-550093
 #           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
             CALL cl_err3("ins","bmb_file",g_bmb.bmb01,g_bmb.bmb02,SQLCA.sqlcode,"",g_msg,1)   #TQC-660046   
            CONTINUE WHILE
        ELSE
            #--->上筆生效日之處理/BOM 說明檔(bmc_file) unique key
            CALL i605_update('a')
            IF g_sma.sma845='Y'   #低階碼可否部份重計
               THEN
               LET g_success='Y'
               #CALL s_uima146(g_bmb.bmb03)  #CHI-D10044
               CALL s_uima146(g_bmb.bmb03,0)  #CHI-D10044
               MESSAGE "" 
            END IF
 
            #--->新增料件時系統參數(sma18 低階碼是重新計算)
            UPDATE sma_file SET sma18 = 'Y' WHERE sma00 = '0'
            IF SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('cannot update sma_file',SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)   #TQC-660046
            END IF
            IF g_ima08_h = 'A' THEN      #主件為family 時
               CALL p500_tm(0,0,g_bmb.bmb01)
            END IF
            LET g_bmb_t.* = g_bmb.*                # 保存上筆資料
            LET g_bmb_o.* = g_bmb.*                # 保存上筆資料
            SELECT bmb01,bmb02,bmb03,bmb04,bmb29 INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29 FROM bmb_file
                WHERE bmb01 = g_bmb.bmb01 AND bmb02 = g_bmb.bmb02 AND
                      bmb03 = g_bmb.bmb03 AND bmb04 = g_bmb.bmb04
                      AND bmb29 = g_bmb.bmb29 #FUN-550093
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i605_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(100)
        l_dir1          LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-680096 SMALLINT
        l_ima08         LIKE ima_file.ima08,
        l_bmb01         LIKE bmb_file.bmb01,
        l_ime09         LIKE ime_file.ime09,
        l_qpa           LIKE bmb_file.bmb06,
        l_code          LIKE type_file.num5,    #No.FUN-680096 SMALLINT
        l_flag          LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        l_cnt           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
        l_bmd02  LIKE bmd_file.bmd02   #MOD-9A0084
    #No:7883
    DISPLAY BY NAME
      g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb29,g_bmb.bmb03,g_bmb.bmb04, #FUN-550093
      g_bmb.bmb05,g_bmb.bmb10,g_bmb.bmb10_fac,g_bmb.bmb10_fac2,
      g_bmb.bmb06,g_bmb.bmb07,g_bmb.bmb08,g_bmb.bmb23,
      g_bmb.bmb11,g_bmb.bmb13,g_bmb.bmb16,g_bmb.bmb27,
      g_bmb.bmb15,g_bmb.bmb09,g_bmb.bmb18,
      g_bmb.bmb28,g_bmb.bmb19,g_bmb.bmb14,g_bmb.bmb25,g_bmb.bmb26,g_bmb.bmb24,
      g_bmb.bmbmodu,g_bmb.bmbdate,g_bmb.bmbcomm
    #No:7883(end)
 
    INPUT BY NAME
      g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb29,g_bmb.bmb03,g_bmb.bmb04, #FUN-550093
      g_bmb.bmb05,g_bmb.bmb10,g_bmb.bmb10_fac,g_bmb.bmb10_fac2,
      g_bmb.bmb06,g_bmb.bmb07,g_bmb.bmb08,g_bmb.bmb23,
      g_bmb.bmb11,g_bmb.bmb13,g_bmb.bmb16,g_bmb.bmb27,
      g_bmb.bmb15,g_bmb.bmb09,g_bmb.bmb18,
      g_bmb.bmb28,g_bmb.bmb19,g_bmb.bmb14,g_bmb.bmb25,g_bmb.bmb26,g_bmb.bmb24,
      g_bmb.bmbmodu,g_bmb.bmbdate,g_bmb.bmbcomm
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i605_set_entry(p_cmd)
            CALL i605_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
       BEFORE FIELD bmb01
      	   IF g_sma.sma60 = 'Y'		# 若須分段輸入
	      THEN CALL s_inp5(7,15,g_bmb.bmb01) RETURNING g_bmb.bmb01
	           DISPLAY BY NAME g_bmb.bmb01
	   END IF
 
        AFTER FIELD bmb01                  #主件料號
            IF g_argv1 IS NOT NULL AND g_argv1 != ' '
                  AND g_bmb.bmb01 != g_bmb_t.bmb01
               THEN CALL cl_err('','mfg2627',0)
                    NEXT FIELD bmb01
            END IF
            IF NOT cl_null(g_bmb.bmb01) THEN
             #FUN-AA0059 --------------------add start-------------------------
              IF NOT s_chk_item_no(g_bmb.bmb01,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_bmb.bmb01 = g_bmb_o.bmb01
                 DISPLAY BY NAME g_bmb.bmb01
                 NEXT FIELD bmb01
              END IF 
             #FUN-AA0059 --------------------add end------------------------------ 
              IF p_cmd = "a" OR                    # 若輸入或更改且改KEY  #MOD-8C0097 
                 (p_cmd = "u" AND g_bmb.bmb01 != g_bmb_t.bmb01) THEN    #MOD-8C0097 
               CALL i605_bmb01('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bmb.bmb01,g_errno,0)
                   LET g_bmb.bmb01 = g_bmb_o.bmb01
                  DISPLAY BY NAME g_bmb.bmb01
                  NEXT FIELD bmb01
               END IF
              END IF  #MOD-8C0097 add
            END IF
 
        BEFORE FIELD bmb02                        #default 項次
            IF g_bmb.bmb02 IS NULL OR
               g_bmb.bmb02 = 0 THEN
                SELECT max(bmb02)+1
                   INTO g_bmb.bmb02
                   FROM bmb_file
                   WHERE bmb01 = g_bmb.bmb01
                IF g_bmb.bmb02 IS NULL
                   THEN LET g_bmb.bmb02 = 1
                END IF
                DISPLAY BY NAME g_bmb.bmb02
            END IF
 
        BEFORE FIELD bmb03
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(10,15,g_bmb.bmb03) RETURNING g_bmb.bmb03
	            DISPLAY BY NAME g_bmb.bmb03
	    END IF
            LET g_bmb03_t = g_bmb.bmb03
 
        AFTER FIELD bmb03                  #元件料號
            IF NOT cl_null(g_bmb.bmb03) THEN
              #FUN-AA0059 -------------------------add start-------------------
               IF NOT s_chk_item_no(g_bmb.bmb03,'') THEN
                  CALL 	cl_err('',g_errno,1)
                  LET g_bmb.bmb03=g_bmb_t.bmb03
                  DISPLAY BY NAME g_bmb.bmb03
                  NEXT FIELD bmb03
               END IF 
              #FUN-AA0059 ------------------------add end------------------------   
               CALL i605_bmb03(p_cmd)   #必需讀取料件主檔
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bmb.bmb03,g_errno,0) 
                  LET g_bmb.bmb03=g_bmb_t.bmb03
                  DISPLAY BY NAME g_bmb.bmb03
                  NEXT FIELD bmb03
               END IF
               IF s_bomchk(g_bmb.bmb01,g_bmb.bmb03,g_ima08_h,g_ima08_b)
                THEN NEXT FIELD bmb03
               END IF
            END IF
 
        AFTER FIELD bmb04                        #check 是否重複
            IF NOT cl_null(g_bmb.bmb04) THEN
               IF g_bmb.bmb01 != g_bmb01_t OR g_bmb01_t IS NULL
                  OR g_bmb.bmb02 != g_bmb02_t OR g_bmb02_t IS NULL
                  OR g_bmb.bmb03 != g_bmb03_t OR g_bmb03_t IS NULL
                  OR g_bmb.bmb04 != g_bmb04_t OR g_bmb04_t IS NULL
                  OR g_bmb.bmb29 != g_bmb29_t  THEN  #FUN-550093 #TQC-5C0052 04->29
                   SELECT count(*) INTO g_cnt FROM bmb_file
                       WHERE bmb01 = g_bmb.bmb01 AND bmb02 = g_bmb.bmb02
                         AND bmb03 = g_bmb.bmb03 AND bmb04 = g_bmb.bmb04
                         AND bmb29 = g_bmb.bmb29  #FUN-550093
                   IF g_cnt > 0 THEN   #資料重複
                       LET g_msg = g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                                   CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',
                                   g_bmb.bmb04,'+',g_bmb.bmb29 #FUN-550093
                       CALL cl_err(g_msg,-239,0)
                       LET g_bmb.bmb02 = g_bmb02_t
                       LET g_bmb.bmb03 = g_bmb03_t
                       LET g_bmb.bmb04 = g_bmb04_t
                       LET g_bmb.bmb29 = g_bmb29_t #FUN-550093
                       DISPLAY BY NAME g_bmb.bmb01
                       DISPLAY BY NAME g_bmb.bmb02
                       DISPLAY BY NAME g_bmb.bmb03
                       DISPLAY BY NAME g_bmb.bmb04
                       DISPLAY BY NAME g_bmb.bmb29 #FUN-550093
                       NEXT FIELD bmb01
                   END IF
               END IF
               CALL i605_bdate(p_cmd)     #生效日
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bmb.bmb04,g_errno,0)
                  LET g_bmb.bmb04 = g_bmb_t.bmb04
                  DISPLAY BY NAME g_bmb.bmb04
                  NEXT FIELD bmb04
               END IF
            END IF
 
        AFTER FIELD bmb05   #check失效日小於生效日
            IF NOT cl_null(g_bmb.bmb05)
               THEN IF g_bmb.bmb05 < g_bmb.bmb04
                       THEN CALL cl_err(g_bmb.bmb05,'mfg2604',0)
                       NEXT FIELD bmb04
                    END IF
            END IF
            CALL i605_edate(p_cmd)     #生效日
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bmb.bmb05,g_errno,0)
               LET g_bmb.bmb05 = g_bmb_t.bmb05
               DISPLAY BY NAME g_bmb.bmb05
               NEXT FIELD bmb04
            END IF
 
        AFTER FIELD bmb06    #組成用量不可小於零
           IF g_bmb.bmb06 <= 0
              THEN CALL cl_err(g_bmb.bmb06,'mfg2614',0)
                   LET g_bmb.bmb06 = g_bmb_o.bmb06
                   DISPLAY BY NAME g_bmb.bmb06
                   NEXT FIELD bmb06
           END IF
           LET g_bmb_o.bmb06 = g_bmb.bmb06
 
        AFTER FIELD bmb07    #底數不可小於等於零
            IF g_bmb.bmb07 <= 0  THEN
               CALL cl_err(g_bmb.bmb07,'mfg2615',0)
               LET g_bmb.bmb07 = g_bmb_o.bmb07
               DISPLAY BY NAME g_bmb.bmb07
               NEXT FIELD bmb07
            END IF
            LET g_bmb_o.bmb07 = g_bmb.bmb07
 
        AFTER FIELD bmb08    #損耗率
            IF g_bmb.bmb08 < 0 OR g_bmb.bmb08 > 100
               THEN CALL cl_err(g_bmb.bmb08,'mfg0013',0)
                    LET g_bmb.bmb08 = g_bmb_o.bmb08
                    DISPLAY BY NAME g_bmb.bmb08
                    NEXT FIELD bmb08
            END IF
            LET g_bmb_o.bmb08 = g_bmb.bmb08
 
        AFTER FIELD bmb10   #發料單位
          IF NOT cl_null(g_bmb.bmb10) THEN
             IF (g_bmb_o.bmb10 IS NULL) OR (g_bmb.bmb10 != g_bmb_o.bmb10)
             THEN SELECT gfe01 FROM gfe_file
                   WHERE gfe01 = g_bmb.bmb10 AND
                        #gfeacti IN ('Y','y') #MOD-5C0034
                         gfeacti IN ('Y','y')  #MOD-5C0034
                   IF SQLCA.sqlcode != 0 THEN
#                      CALL cl_err(g_bmb.bmb10,'mfg2605',0) #No.TQC-660046
                      CALL cl_err3("sel","gfe_file",g_bmb.bmb10,"","mfg2605","","",1)   #TQC-660046
                      LET g_bmb.bmb10 = g_bmb_o.bmb10
                      DISPLAY BY NAME g_bmb.bmb10
                      #MOD-5C0034...............begin
                      LET g_bmb.bmb10_fac = g_bmb_o.bmb10_fac
                      DISPLAY BY NAME g_bmb.bmb10_fac
                      LET g_bmb.bmb10_fac2= g_bmb_o.bmb10_fac2
                      DISPLAY BY NAME g_bmb.bmb10_fac2
                      #MOD-5C0034...............end
                      NEXT FIELD bmb10
                   ELSE IF g_bmb.bmb10 != g_ima25_b
                        THEN CALL s_umfchk(g_bmb.bmb03,g_bmb.bmb10,
                                            g_ima25_b)
                              RETURNING g_sw,g_bmb.bmb10_fac #發料/庫存單位
                              IF g_sw = '1' THEN
                                 CALL cl_err(g_bmb.bmb10,'mfg2721',0)
                                 LET g_bmb.bmb10 = g_bmb_o.bmb10
                                 DISPLAY BY NAME g_bmb.bmb10
                                 LET g_bmb.bmb10_fac = g_bmb_o.bmb10_fac
                                 DISPLAY BY NAME g_bmb.bmb10_fac
                                 #MOD-5C0034...............begin
                                 LET g_bmb.bmb10_fac2= g_bmb_o.bmb10_fac2
                                 DISPLAY BY NAME g_bmb.bmb10_fac2
                                 #MOD-5C0034...............end
                                 NEXT FIELD bmb10
                              END IF
                        ELSE LET g_bmb.bmb10_fac  = 1
                        END  IF
                        IF g_bmb.bmb10 != g_ima86_b  #發料/成本單位
                        THEN CALL s_umfchk(g_bmb.bmb03,g_bmb.bmb10,
                                             g_ima86_b)
                             RETURNING g_sw,g_bmb.bmb10_fac2
                             IF g_sw = '1' THEN
                                CALL cl_err(g_bmb.bmb03,'mfg2722',0)
                                LET g_bmb.bmb10 = g_bmb_o.bmb10
                                DISPLAY BY NAME g_bmb.bmb10
                                #MOD-5C0034...............begin
                                LET g_bmb.bmb10_fac = g_bmb_o.bmb10_fac
                                DISPLAY BY NAME g_bmb.bmb10_fac
                                #MOD-5C0034...............end
                                LET g_bmb.bmb10_fac2 = g_bmb_o.bmb10_fac2
                                DISPLAY BY NAME g_bmb.bmb10_fac2
                                NEXT FIELD bmb10
                             END IF
                        ELSE LET g_bmb.bmb10_fac2 = 1
                        END IF
                   END IF
             END IF
          END IF
          DISPLAY BY NAME g_bmb.bmb10_fac  #MOD-5C0034 add
          DISPLAY BY NAME g_bmb.bmb10_fac2 #MOD-5C0034 add
          LET g_bmb_o.bmb10 = g_bmb.bmb10
          LET g_bmb_o.bmb10_fac = g_bmb.bmb10_fac
          LET g_bmb_o.bmb10_fac2 = g_bmb.bmb10_fac2
 
        AFTER FIELD bmb10_fac   #發料/料件庫存轉換率
            IF g_bmb.bmb10_fac <= 0
               THEN CALL cl_err(g_bmb.bmb10_fac,'mfg1322',0)
                    LET g_bmb.bmb10_fac = g_bmb_o.bmb10_fac
                    DISPLAY BY NAME g_bmb.bmb10_fac
                    NEXT FIELD bmb10_fac
            END IF
            LET g_bmb_o.bmb10_fac = g_bmb.bmb10_fac
 
        AFTER FIELD bmb10_fac2   #發料/料件成本轉換率
            IF g_bmb.bmb10_fac2 <= 0
               THEN CALL cl_err(g_bmb.bmb10_fac2,'mfg1322',0)
                    LET g_bmb.bmb10_fac2 = g_bmb_o.bmb10_fac2
                    DISPLAY BY NAME g_bmb.bmb10_fac2
                    NEXT FIELD bmb10_fac2
            END IF
            LET g_bmb_o.bmb10_fac2 = g_bmb.bmb10_fac2
 
        AFTER FIELD bmb09    #作業編號
             #有使用製程(sma54='Y')
             IF NOT cl_null(g_bmb.bmb09) THEN
                SELECT COUNT(*) INTO g_cnt FROM ecd_file
                 WHERE ecd01=g_bmb.bmb09
                IF g_cnt=0 THEN
                   CALL cl_err('sel ecd_file',100,0)
                   NEXT FIELD bmb09
                END IF
             END IF
 
        AFTER FIELD bmb14     #使用特性
             IF g_bmb.bmb14 NOT MATCHES'[0123]'   #FUN-910053 add 23
                THEN NEXT FIELD bmb14
             END IF
 
        AFTER FIELD bmb27  #軟體物件
            LET g_bmb_o.bmb27 = g_bmb.bmb27
 
#可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#                 2.使用製程(sma54 = 'y')
        AFTER FIELD bmb15  #消耗料件
            LET g_bmb_o.bmb15 = g_bmb.bmb15
	    LET l_dir1='D'
            #FUN-640208...............begin
            IF (NOT cl_null(g_bmb.bmb15)) AND (g_bmb.bmb15<>g_ima70) THEN
               CALL cl_err('','abm-209',1)
            END IF
            #FUN-640208...............end
 
          AFTER FIELD bmb16  #替代特性
             IF g_bmb.bmb16 NOT MATCHES '[01257]' #bugno:7111 add 5   #FUN-A20037 add '7'
               THEN NEXT FIELD bmb16
                    LET g_bmb.bmb16 = g_bmb_o.bmb16
                    DISPLAY BY NAME g_bmb.bmb16
                    NEXT FIELD bmb16
             END IF
             IF g_bmb.bmb16 != '0' AND (g_bmb.bmb16 != g_bmb_o.bmb16)
                THEN CALL i605_prompt()   #詢問是否輸入取代或替代料件
             END IF
             LET g_bmb_o.bmb16 = g_bmb.bmb16
 
          AFTER FIELD bmb18     #投料時距
             LET l_dir1 = 'U'
            #MOD-AC0379 ----------mark start---------------- 
            ##TQC-A10054---Begin
            #IF g_bmb.bmb18 < 0 THEN
            #   CALL cl_err(g_bmb.bmb18,'aim-223',0)
            #   NEXT FIELD bmb18
            #END IF
            ##TQC-A10054---End
            #MOD-AC0379 ---------mark end------------------
             IF cl_null(g_bmb.bmb18)
             THEN LET g_bmb.bmb18 = 0
                  DISPLAY BY NAME g_bmb.bmb18
             END IF
 
        AFTER FIELD bmb23    #選中率
            IF g_bmb.bmb23 < 0 OR g_bmb.bmb23 > 100
               THEN CALL cl_err(g_bmb.bmb23,'mfg0013',0)
                    LET g_bmb.bmb23 = g_bmb_o.bmb23
                    DISPLAY BY NAME g_bmb.bmb23
                    NEXT FIELD bmb23
            END IF
            LET g_bmb_o.bmb23 = g_bmb.bmb23
 
       AFTER FIELD bmb28
            IF g_bmb.bmb28 < 0 OR g_bmb.bmb28 > 100
               THEN CALL cl_err(g_bmb.bmb28,'mfg0013',0)
                    LET g_bmb.bmb28 = g_bmb_o.bmb28
                    DISPLAY BY NAME g_bmb.bmb28
                    NEXT FIELD bmb28
            END IF
            LET g_bmb_o.bmb28 = g_bmb.bmb28
 
       AFTER FIELD bmb19
            IF g_bmb.bmb19 not matches '[1234]'
            THEN  LET g_bmb.bmb19 = g_bmb_o.bmb19
                  DISPLAY BY NAME g_bmb.bmb19
                  NEXT FIELD bmb19
            END IF
            LET g_bmb_o.bmb19 = g_bmb.bmb19
 
          AFTER FIELD bmb25     # Warehouse
            IF NOT cl_null(g_bmb.bmb25) THEN
                 CALL i605_bmb25('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bmb.bmb25,g_errno,0)
                    LET g_bmb.bmb25 = g_bmb_o.bmb25
                    DISPLAY BY NAME g_bmb.bmb25
                    NEXT FIELD bmb25
                 END IF
 #------>check-1
                 IF NOT s_imfchk1(g_bmb.bmb03,g_bmb.bmb25)
                    THEN CALL cl_err(g_bmb.bmb25,'mfg9036',0)
                         NEXT FIELD bmb25
                 END IF
 #------>check-2
                 CALL s_stkchk(g_bmb.bmb25,'A') RETURNING l_code
                 IF NOT l_code THEN
                     CALL cl_err(g_bmb.bmb25,'mfg1100',0)
                     NEXT FIELD bmb25
                 END IF
            END IF
 
          AFTER FIELD bmb26     # Location
            IF g_bmb.bmb26 IS NOT NULL AND g_bmb.bmb26 != ' ' THEN
#------>chk-1
               IF NOT s_imfchk(g_bmb.bmb03,g_bmb.bmb25,g_bmb.bmb26)
                 THEN CALL cl_err(g_bmb.bmb26,'mfg6095',0)
                      NEXT FIELD bmb26
               END IF
            END IF
            IF g_bmb.bmb26 IS NULL THEN LET g_bmb.bmb26 = ' ' END IF
 
        AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF cl_null(g_bmb.bmb05)
               THEN IF g_bmb.bmb05 < g_bmb.bmb04
                       THEN CALL cl_err(g_bmb.bmb05,'mfg2604',0)
                            LET l_flag = 'Y'
                    END IF
            END IF
            IF cl_null(g_bmb.bmb10_fac) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb10_fac
            END IF
            IF cl_null(g_bmb.bmb10_fac2) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb10_fac2
            END IF
            IF cl_null(g_bmb.bmb14) OR g_bmb.bmb14 NOT MATCHES'[0123]' THEN  #FUN-910053 add 23
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb14
            END IF
            IF cl_null(g_bmb.bmb15) OR g_bmb.bmb15 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb15
            END IF
            IF cl_null(g_bmb.bmb27) OR g_bmb.bmb27 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb27
            END IF
            IF cl_null(g_bmb.bmb16) OR g_bmb.bmb16 NOT MATCHES'[0127]' THEN   #FUN-A40058 add '7'
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb16
            END IF
            IF cl_null(g_bmb.bmb18) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb18
            END IF
           {
            IF cl_null(g_bmb.bmb19) OR g_bmb.bmb19 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb19
            END IF
            IF cl_null(g_bmb.bmb20) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb19
            END IF
            IF cl_null(g_bmb.bmb21) OR g_bmb.bmb21 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb21
            END IF
            IF cl_null(g_bmb.bmb22) OR g_bmb.bmb22 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb22
            END IF
            }
            IF cl_null(g_bmb.bmb23) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmb.bmb23
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD  bmb01
            END IF
		 ON KEY(F1)
			NEXT FIELD bmb01
		 ON KEY(F2)
			NEXT FIELD bmb06
			NEXT FIELD bmb13
			NEXT FIELD bmb25
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(bmb01) #料件主檔
#                 CALL q_ima(3,2,g_bmb.bmb01) RETURNING g_bmb.bmb01
#                 CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bma2"   #MOD-6B0129 modify ima"
                  LET g_qryparam.default1 = g_bmb.bmb01
                  CALL cl_create_qry() RETURNING g_bmb.bmb01
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb01 )
                  DISPLAY BY NAME g_bmb.bmb01
                  NEXT FIELD bmb01
               WHEN INFIELD(bmb03) #料件主檔
#                 CALL q_ima(3,2,g_bmb.bmb03) RETURNING g_bmb.bmb03
#                 CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb03 )
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.default1 = g_bmb.bmb03
                #  CALL cl_create_qry() RETURNING g_bmb.bmb03
                   CALL q_sel_ima(FALSE, "q_ima", "", g_bmb.bmb03, "", "", "", "" ,"",'' )  RETURNING g_bmb.bmb03
#FUN-AA0059 --End--
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb03 )
                  DISPLAY BY NAME g_bmb.bmb03
                  NEXT FIELD bmb03
               WHEN INFIELD(bmb09) #作業主檔
                  CALL q_ecd(FALSE,TRUE,g_bmb.bmb09)
                       RETURNING g_bmb.bmb09
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb09 )
                  DISPLAY BY NAME g_bmb.bmb09
                  NEXT FIELD bmb09
               WHEN INFIELD(bmb10) #單位檔
#                 CALL q_gfe(3,2,g_bmb.bmb10) RETURNING g_bmb.bmb10
#                 CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb10 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bmb.bmb10
                  CALL cl_create_qry() RETURNING g_bmb.bmb10
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb10 )
                  DISPLAY BY NAME g_bmb.bmb10
                  NEXT FIELD bmb10
               WHEN INFIELD(bmb25) #倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfd"
                  LET g_qryparam.default1 = g_bmb.bmb25
                  CALL cl_create_qry() RETURNING g_bmb.bmb25
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb25 )
                  DISPLAY BY NAME g_bmb.bmb25
                  NEXT FIELD bmb25
               WHEN INFIELD(bmb26) #儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfe"
                  LET g_qryparam.default1 = g_bmb.bmb26
                  LET g_qryparam.arg1 = g_bmb.bmb25         #MOD-CC0097 add
                  CALL cl_create_qry() RETURNING g_bmb.bmb26
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb.bmb26 )
                  DISPLAY BY NAME g_bmb.bmb26
                  NEXT FIELD bmb26
            END CASE
        ON ACTION bom_description
                  IF g_bmb_t.bmb02 IS NOT NULL
                     THEN LET l_cmd = "abmi603 '",g_bmb.bmb01,"'",
                                      " '",g_bmb.bmb02,"' '",  #No.B062
                                      g_bmb.bmb03,"' '",
                                      g_bmb.bmb04,"' '",
                                      g_bmb.bmb29,"'" CLIPPED #FUN-550093
                             CALL cl_cmdrun(l_cmd)
                  END IF
 
 
        ON ACTION mntn_insert_loc      #建立插件位置
                   IF g_bmb_t.bmb03 IS NOT NULL AND g_bmb_t.bmb03 != ' '
                   THEN LET l_qpa = g_bmb.bmb06/g_bmb.bmb07
                        CALL i200(g_bmb.bmb01,g_bmb.bmb02,
                                   g_bmb.bmb03,g_bmb.bmb04,'u',l_qpa,g_bmb.bmb29) #FUN-550093
                   END IF
 
        ON ACTION mntn_item_brand
              LET l_cmd="abmi650 '",g_bmb.bmb03,"' '",g_bmb.bmb01,"'"
	      CALL cl_cmdrun(l_cmd)
              NEXT FIELD bmb03
 
        ON ACTION mntn_rep_sub
                IF g_bmb.bmb16 matches'[12]' THEN
                   LET l_cmd = "abmi604 '",g_bmb.bmb03,"' ",
                                       "'",g_bmb.bmb01,"' ",
                                       "'",g_bmb.bmb16,"' "
                   #-----MOD-9A0084---------
                   #CALL cl_cmdrun(l_cmd)   
                   CALL cl_cmdrun_wait(l_cmd)  
                   
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM bmd_file 
                    WHERE bmd01=g_bmb.bmb03  
                      AND bmdacti = 'Y'               
                   IF l_n = 0 THEN
                      UPDATE bmb_file SET bmb16 = '0',
                                          bmbdate=g_today     #FUN-C40007 add
                       WHERE bmb01=g_bmb.bmb01 AND bmb03=g_bmb.bmb03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmb_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",0)
                       END IF
                   ELSE 
                      LET l_bmd02 = ''
                      SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                         WHERE bmd01=g_bmb.bmb03 AND bmd08 = g_bmb.bmb01 
                           AND bmdacti = 'Y' 
                      IF NOT cl_null(l_bmd02) THEN
                         UPDATE bmb_file SET bmb16 = l_bmd02,
                                             bmbdate=g_today     #FUN-C40007 add 
                          WHERE bmb01=g_bmb.bmb01 AND bmb03=g_bmb.bmb03
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","bmb_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",0)
                         END IF
                      ELSE
                         LET l_bmd02 = ''
                         SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                            WHERE bmd01=g_bmb.bmb03 AND bmd08 = 'ALL' 
                              AND bmdacti = 'Y' 
                         IF NOT cl_null(l_bmd02) THEN
                            UPDATE bmb_file SET bmb16 = l_bmd02,
                                                bmbdate=g_today     #FUN-C40007 add 
                             WHERE bmb01=g_bmb.bmb01 AND bmb03=g_bmb.bmb03
                            IF SQLCA.sqlcode THEN
                               CALL cl_err3("upd","bmb_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",0)
                            END IF
                         END IF
                      END IF  
                   END IF 
                   SELECT bmb16 INTO g_bmb.bmb16 FROM bmb_file
                     WHERE bmb01 = g_bmb.bmb01 
                       AND bmb29 = g_bmb.bmb29
                       AND bmb02 = g_bmb.bmb02
                       AND bmb03 = g_bmb.bmb03
                       AND bmb04 = g_bmb.bmb04
                   DISPLAY BY NAME g_bmb.bmb16
                   #-----END MOD-9A0084-----
                END IF
#FUN-A40058 --begin--
       IF g_bmb.bmb16 matches'[7]' THEN
          LET l_cmd = "abmi6043  "                               
          CALL cl_cmdrun_wait(l_cmd)                  
       END IF
#FUN-A40058 --end--                
 
        ON ACTION CONTROLF                    # 欄位說明
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
 
FUNCTION i605_prompt()
    DEFINE l_cmd    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1)
    DEFINE l_n      LIKE type_file.num5   #MOD-9A0084
    DEFINE l_bmd02  LIKE bmd_file.bmd02   #MOD-9A0084
 
  IF g_bmb.bmb16 = '5' THEN RETURN END IF    #bugno:7111 add
  IF g_bmb.bmb16 = '1' THEN
     CALL cl_getmsg('mfg2629',g_lang) RETURNING g_msg
  ELSE
     CALL cl_getmsg('mfg2716',g_lang) RETURNING g_msg
  END IF
  WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
    PROMPT g_msg CLIPPED FOR g_chr
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
#          CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END PROMPT
    IF g_chr  MATCHES'[YyNn]' THEN EXIT WHILE END IF
    IF INT_FLAG THEN LET INT_FLAG = 0 END IF
  END WHILE
  IF g_chr MATCHES '[Yy]'
     THEN  IF g_bmb.bmb16 MATCHES '[12]' THEN
                   LET l_cmd = "abmi604 '",g_bmb.bmb03,"' ",
                                       "'",g_bmb.bmb01,"' ",
                                       "'",g_bmb.bmb16,"' "
                   #-----MOD-9A0084---------
                   #CALL cl_cmdrun(l_cmd)   
                   CALL cl_cmdrun_wait(l_cmd)  
                   
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM bmd_file 
                    WHERE bmd01=g_bmb.bmb03  
                      AND bmdacti = 'Y'               
                   IF l_n = 0 THEN
                      UPDATE bmb_file SET bmb16 = '0',
                                          bmbdate=g_today     #FUN-C40007 add
                       WHERE bmb01=g_bmb.bmb01 AND bmb03=g_bmb.bmb03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmb_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",0)
                       END IF
                   ELSE 
                      LET l_bmd02 = ''
                      SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                         WHERE bmd01=g_bmb.bmb03 AND bmd08 = g_bmb.bmb01 
                           AND bmdacti = 'Y' 
                      IF NOT cl_null(l_bmd02) THEN
                         UPDATE bmb_file SET bmb16 = l_bmd02,
                                             bmbdate=g_today     #FUN-C40007 add 
                          WHERE bmb01=g_bmb.bmb01 AND bmb03=g_bmb.bmb03
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","bmb_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",0)
                         END IF
                      ELSE
                         LET l_bmd02 = ''
                         SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                            WHERE bmd01=g_bmb.bmb03 AND bmd08 = 'ALL' 
                              AND bmdacti = 'Y' 
                         IF NOT cl_null(l_bmd02) THEN
                            UPDATE bmb_file SET bmb16 = l_bmd02,
                                                bmbdate=g_today     #FUN-C40007 add 
                             WHERE bmb01=g_bmb.bmb01 AND bmb03=g_bmb.bmb03
                            IF SQLCA.sqlcode THEN
                               CALL cl_err3("upd","bmb_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",0)
                            END IF
                         END IF
                      END IF  
                   END IF 
                   SELECT bmb16 INTO g_bmb.bmb16 FROM bmb_file
                     WHERE bmb01 = g_bmb.bmb01 
                       AND bmb29 = g_bmb.bmb29
                       AND bmb02 = g_bmb.bmb02
                       AND bmb03 = g_bmb.bmb03
                       AND bmb04 = g_bmb.bmb04
                   DISPLAY BY NAME g_bmb.bmb16
                   #-----END MOD-9A0084-----
           END IF
#FUN-A40058 --begin--
       IF g_bmb.bmb16 matches'[7]' THEN
          LET l_cmd = "abmi6043  "                               
          CALL cl_cmdrun_wait(l_cmd)                  
       END IF
#FUN-A40058 --end--            
  END IF
END FUNCTION
 
FUNCTION i605_bmb01(p_cmd)  #主件料件
    DEFINE  l_ima02   LIKE ima_file.ima02,
            l_ima021  LIKE ima_file.ima021,
            l_imaacti LIKE ima_file.imaacti,
            p_cmd     LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima37,ima08,ima70,imaacti
      INTO l_ima02,l_ima021,g_ima37_h,g_ima08_h,g_ima70_h,l_imaacti
       FROM ima_file WHERE ima01 = g_bmb.bmb01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02   = NULL
                            LET l_ima021  = NULL
                            LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
      #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    #no.6845
    SELECT bma05 INTO g_bma05 FROM bma_file WHERE bma01 = g_bmb.bmb01
    IF STATUS = 0 AND p_cmd = 'a' THEN
       IF NOT cl_null(g_bma05) AND g_sma.sma101 = 'N' THEN
         #MOD-610014-begin-add S
         #IF g_ima08_h MATCHES '[MPXT]' THEN LET g_errno = 'abm-120' END IF
          IF g_ima08_h MATCHES '[MPXTS]' THEN LET g_errno = 'abm-120' END IF
         #MOD-610014-end
       END IF
    END IF
    #no.6845(end)
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h1
       DISPLAY l_ima021 TO FORMONLY.ima021_h1
       DISPLAY g_ima08_h TO FORMONLY.ima08_1
    END IF
END FUNCTION
 
FUNCTION i605_bmb03(p_cmd)  #元件料件
    DEFINE p_cmd     LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima04   LIKE ima_file.ima04,
           l_ima105  LIKE ima_file.ima105,
           l_ima110  LIKE ima_file.ima110,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima04,ima25,ima63,ima37,ima08,ima70,ima105,
           ima110,imaacti,ima86,ima70 #MOD-5C0034 add ima86 #FUN-640208
      INTO l_ima02,l_ima021,l_ima04,g_ima25_b,g_ima63_b,g_ima37_b,
           g_ima08_b,g_ima70_b,l_ima105,l_ima110,l_imaacti,g_ima86_b,g_ima70  #MOD-5C0034 #FUN-640208
      FROM ima_file WHERE ima01 = g_bmb.bmb03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL LET l_ima021= NULL
                                   LET l_ima105= NULL LET l_ima110= NULL
                                   LET l_imaacti = NULL
                                   LET g_ima70=NULL #FUN-640208
         WHEN l_imaacti='N' LET g_errno = '9028'
         
      #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima08_b = 'D' THEN LET g_bmb.bmb17 = 'Y'      #元件為feature flag
                       ELSE LET g_bmb.bmb17 = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z' THEN LET g_errno = 'mfg2752' RETURN END IF
    IF p_cmd = 'a' THEN
      LET g_bmb.bmb10 = g_ima63_b
      LET g_bmb.bmb15 = g_ima70_b
      LET g_bmb.bmb27 = l_ima105
      LET g_bmb.bmb19 = l_ima110
      #96-09-10 Modify By Lynn
      LET g_bmb.bmb11 = l_ima04
      DISPLAY BY NAME g_bmb.bmb10
      DISPLAY BY NAME g_bmb.bmb19
      DISPLAY BY NAME g_bmb.bmb15
      DISPLAY BY NAME g_bmb.bmb27
      DISPLAY BY NAME g_bmb.bmb11
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h2
       DISPLAY l_ima021 TO FORMONLY.ima021_h2
       DISPLAY g_ima08_b TO FORMONLY.ima08_2
    END IF
END FUNCTION
 
FUNCTION  i605_bdate(p_cmd)
  DEFINE   l_bmb04_a,l_bmb04_i LIKE bmb_file.bmb04,
           l_bmb05_a,l_bmb05_i LIKE bmb_file.bmb05,
           p_cmd   LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
           l_n     LIKE type_file.num10      #No.FUN-680096 INTEGER
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM bmb_file
                            WHERE bmb01 = g_bmb.bmb01         #主件
                             AND  bmb02 = g_bmb.bmb02   #項次
                             AND  bmb04 = g_bmb.bmb04
                             AND  bmb29 = g_bmb.bmb29 #FUN-550093
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    SELECT MAX(bmb04),MAX(bmb05) INTO l_bmb04_a,l_bmb05_a
                       FROM bmb_file
                      WHERE bmb01 = g_bmb.bmb01         #主件
                       AND  bmb02 = g_bmb.bmb02         #項次
                       AND  bmb04 < g_bmb.bmb04         #生效日
                       AND  bmb29 = g_bmb.bmb29 #FUN-550093
    IF g_bmb.bmb04 <  l_bmb04_a THEN LET g_errno = 'mfg2737' END IF
#   IF g_bmb.bmb04 <  l_bmb05_a THEN LET g_errno = 'mfg2737' END IF
 
    SELECT MIN(bmb04),MIN(bmb05) INTO l_bmb04_i,l_bmb05_i
                       FROM bmb_file
                      WHERE bmb01 = g_bmb.bmb01         #主件
                       AND  bmb02 = g_bmb.bmb02         #項次
                       AND  bmb04 > g_bmb.bmb04         #生效日
                       AND  bmb29 = g_bmb.bmb29 #FUN-550093
 
    IF l_bmb04_i IS NULL AND l_bmb05_i IS NULL THEN RETURN END IF
    IF l_bmb04_a IS NULL AND l_bmb05_a IS NULL THEN
       IF g_bmb.bmb04 < l_bmb04_i THEN LET g_errno = 'mfg2737' END IF
    END IF
    IF g_bmb.bmb04 > l_bmb04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
 
FUNCTION  i605_edate(p_cmd)
  DEFINE   l_bmb04_i   LIKE bmb_file.bmb04,
           l_bmb04_a   LIKE bmb_file.bmb04,
           p_cmd       LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
           l_n         LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM bmb_file
                      WHERE bmb01 = g_bmb.bmb01         #主件
                        AND bmb02 = g_bmb.bmb02   #項次
                       AND  bmb29 = g_bmb.bmb29 #FUN-550093
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(bmb04) INTO l_bmb04_i
                       FROM bmb_file
                      WHERE bmb01 = g_bmb.bmb01         #主件
                       AND  bmb02 = g_bmb.bmb02         #項次
                       AND  bmb04 > g_bmb.bmb04         #生效日
                       AND  bmb29 = g_bmb.bmb29 #FUN-550093
   SELECT MAX(bmb04) INTO l_bmb04_a
                       FROM bmb_file
                      WHERE bmb01 = g_bmb.bmb01         #主件
                       AND  bmb02 = g_bmb.bmb02         #項次
                       AND  bmb04 > g_bmb.bmb04         #生效日
                       AND  bmb29 = g_bmb.bmb29 #FUN-550093
   IF l_bmb04_i IS NULL THEN RETURN END IF
   IF g_bmb.bmb05 > l_bmb04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION
 
FUNCTION i605_bmb25(p_cmd)  # Warehouse
    DEFINE p_cmd     LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
           l_imd02   LIKE imd_file.imd02,
           l_imdacti LIKE imd_file.imdacti
 
    LET g_errno = ' '
    SELECT  imd02,imdacti INTO l_imd02,l_imdacti FROM imd_file
            WHERE imd01 = g_bmb.bmb25
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
                            LET l_imd02 = NULL
                            LET l_imdacti= NULL
         WHEN l_imdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i605_update(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
         l_bmb02   LIKE bmb_file.bmb02,
         l_bmb03   LIKE bmb_file.bmb03,
         l_bmb04   LIKE bmb_file.bmb04,
         l_bmb29   LIKE bmb_file.bmb29 #FUN-550093
 
    IF p_cmd ='u' THEN
       #--->更新BOM說明檔(bmc_file)的index key
       UPDATE bmc_file SET bmc02  = g_bmb.bmb02,
                           bmc021 = g_bmb.bmb03,
                           bmc03  = g_bmb.bmb04,
                           bmc06  = g_bmb.bmb29 #FUN-550093
                       WHERE bmc01 = g_bmb.bmb01
                         AND bmc02 = g_bmb_t.bmb02
                         AND bmc021= g_bmb_t.bmb03
                         AND bmc03 = g_bmb_t.bmb04
                         AND bmc06 = g_bmb_t.bmb29 #FUN-550093
    END IF
    DECLARE i605_update SCROLL CURSOR  FOR
            SELECT bmb02,bmb03,bmb04,bmb29 FROM bmb_file #FUN-550093
                   WHERE bmb01 = g_bmb.bmb01 AND
                         bmb02 = g_bmb.bmb02 AND
                         (bmb04 < g_bmb.bmb04)       #生效日
                         AND  bmb29 = g_bmb.bmb29 #FUN-550093
                   ORDER BY bmb04
    OPEN i605_update
    FETCH LAST i605_update INTO l_bmb02,l_bmb03,l_bmb04,l_bmb29 #FUN-550093
    IF SQLCA.sqlcode = 0
       THEN UPDATE bmb_file SET bmb05 = g_bmb.bmb04,
                                bmbmodu = g_user,    #No:7883
                                bmbdate = g_today,   #No:7883
                                bmbcomm = "abmi605", #No:7883
                                bmbdate=g_today      #FUN-C40007 add 
                          WHERE bmb01 = g_bmb.bmb01 AND
                                bmb02 = l_bmb02 AND
                                bmb03 = l_bmb03 AND
                                bmb04 = l_bmb04 AND
                                bmb29 = l_bmb29 #FUN-550093
           IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err('','mfg2635',0) #No.TQC-660046
              CALL cl_err3("upd","bmb_file",g_bmb.bmb01,l_bmb02,"mfg2635","","",1)  #TQC-660046
           END IF
         #TQC-890018-begin-add
          UPDATE bma_file SET bmamodu = g_user,
                                bmadate = g_today  
                          WHERE bma01 = g_bmb.bmb01 AND
                                bma06 = l_bmb29 
           IF SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","bma_file",g_bmb.bmb01,"","aap-161","","",1)  
           END IF
         #TQC-890018-end-add
    END IF
    CLOSE i605_update
END FUNCTION
 
FUNCTION i605_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmb.* TO NULL                #No.FUN-6A0002 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i605_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmb.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i605_count
    FETCH i605_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i605_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
                  '+',g_bmb.bmb29  #FUN-550093
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL
    ELSE
        CALL i605_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i605_fetch(p_flbmb)
    DEFINE
        p_flbmb      LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
 
    CASE p_flbmb
        WHEN 'N' FETCH NEXT     i605_curs INTO g_bmb.bmb01,
                                               g_bmb.bmb02,
                                               g_bmb.bmb03,
                                               g_bmb.bmb04,
                                               g_bmb.bmb13,
                                               
                                               g_bmb.bmb29 #FUN-550093
        WHEN 'P' FETCH PREVIOUS i605_curs INTO g_bmb.bmb01,
                                               g_bmb.bmb02,
                                               g_bmb.bmb03,
                                               g_bmb.bmb04,
                                               g_bmb.bmb13,
                                               
                                               g_bmb.bmb29 #FUN-550093
        WHEN 'F' FETCH FIRST    i605_curs INTO g_bmb.bmb01,
                                               g_bmb.bmb02,
                                               g_bmb.bmb03,
                                               g_bmb.bmb04,
                                               g_bmb.bmb13,
                                               
                                               g_bmb.bmb29 #FUN-550093
        WHEN 'L' FETCH LAST     i605_curs INTO g_bmb.bmb01,
                                               g_bmb.bmb02,
                                               g_bmb.bmb03,
                                               g_bmb.bmb04,
                                               g_bmb.bmb13,
                                               
                                               g_bmb.bmb29 #FUN-550093
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i605_curs INTO g_bmb.bmb01,
                                               g_bmb.bmb02,
                                               g_bmb.bmb03,
                                               g_bmb.bmb04,
                                               g_bmb.bmb13,
                                               
                                               g_bmb.bmb29 #FUN-550093
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
                  '+',g_bmb.bmb29  #FUN-550093
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL  #TQC-6B0105
              #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbmb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bmb.* FROM bmb_file            # 重讀DB,因TEMP有不被更新特性
     WHERE bmb01=g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
                  '+',g_bmb.bmb29  #FUN-550093
 #       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bmb_file",g_msg,"",SQLCA.sqlcode,"","",1)  #TQC-660046
    ELSE
        CALL i605_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i605_show()
    LET g_bmb_t.* = g_bmb.*
    LET g_bmb_o.* = g_bmb.*
    DISPLAY BY NAME g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb29,g_bmb.bmb03,g_bmb.bmb04, #FUN-550093
                    g_bmb.bmb05,g_bmb.bmb10,g_bmb.bmb10_fac,
                    g_bmb.bmb10_fac2,g_bmb.bmb06,g_bmb.bmb07,
                    g_bmb.bmb08,g_bmb.bmb23,g_bmb.bmb11,g_bmb.bmb13,
                    g_bmb.bmb16,g_bmb.bmb09,g_bmb.bmb18,
                    g_bmb.bmb27,g_bmb.bmb15,g_bmb.bmb14,
                    #g_bmb.bmb20,g_bmb.bmb19,g_bmb.bmb21,g_bmb.bmb22,
                    g_bmb.bmb19,g_bmb.bmb28, #No.+004 & No.+114 010321 linda add
                    g_bmb.bmb25,g_bmb.bmb26,g_bmb.bmb24,
                    g_bmb.bmbmodu,g_bmb.bmbdate,g_bmb.bmbcomm
   #
    CALL i605_bmb01('d')
    CALL i605_bmb03('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i605_u()
 
    IF cl_null(g_bmb.bmb01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmb01_t = g_bmb.bmb01
    LET g_bmb02_t = g_bmb.bmb02
    LET g_bmb03_t = g_bmb.bmb03
    LET g_bmb04_t = g_bmb.bmb04
    LET g_bmb29_t = g_bmb.bmb29
    LET g_bmb_o.* = g_bmb.*
 
    BEGIN WORK
 
 
    OPEN i605_curl USING g_bmb.bmb01, g_bmb.bmb02, g_bmb.bmb03, g_bmb.bmb04, g_bmb.bmb29
 
    IF STATUS THEN
       CALL cl_err("OPEN i605_curl:", STATUS, 1)
       CLOSE i605_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i605_curl INTO g_bmb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
                  '+',g_bmb.bmb29 #FUN-550093
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i605_show()                          # 顯示最新資料
    WHILE TRUE
#bugno:6845 add.....................................
    #modify需考慮參數sma101:『 BOM表發放後是否可以修改單身』
        SELECT ima08 INTO g_ima08 FROM ima_file WHERE ima01 = g_bmb.bmb01
        SELECT bma05 INTO g_bma05 FROM bma_file WHERE bma01 = g_bmb.bmb01
        IF NOT cl_null(g_bma05) AND g_sma.sma101 = 'N' THEN
          #MOD-610014-begin-add S
          #IF g_ima08 MATCHES '[MPXT]' THEN
           IF g_ima08 MATCHES '[MPXTS]' THEN
          #MOD-610014-end
              CALL cl_err('','abm-120',0)
              RETURN
           END IF
        END IF
#bugno:6845 end.....................................
        LET g_bmb.bmbmodu = g_user    #No:7883
        LET g_bmb.bmbdate = g_today   #No:7883
        LET g_bmb.bmbcomm = 'abmi605' #No:7883
        CALL i605_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bmb.*=g_bmb_t.*
            CALL i605_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bmb_file SET bmb_file.* = g_bmb.*    # 更新DB
         WHERE bmb01=g_bmb01_t AND bmb02=g_bmb02_t AND bmb03=g_bmb03_t AND bmb04=g_bmb04_t AND bmb29=g_bmb29_t  
        IF SQLCA.SQLERRD[3] = 0 THEN
            LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
                  '+',g_bmb.bmb29  #FUN-550093
  #          CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
             CALL cl_err3("upd","bmb_file",g_bmb01_t,g_bmb02_t,SQLCA.sqlcode,"",g_msg,1)   #TQC-660046
            CONTINUE WHILE
        END IF
        #--->上筆生效日之處理/BOM 說明檔(bmc_file) unique key
        CALL i605_update('u')
        IF g_ima08_h = 'A' THEN      #主件為family 時
           CALL p500_tm(0,0,g_bmb.bmb01)
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i605_curl
	COMMIT WORK
END FUNCTION
 
FUNCTION i605_r()
    DEFINE
        l_chr    LIKE type_file.chr1       #No.FUN-680096  VARCHAR(1)
 
    IF cl_null(g_bmb.bmb01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
#bugno:6845 add.....................................
    #modify需考慮參數sma101:『 BOM表發放後是否可以修改單身』
        SELECT ima08 INTO g_ima08 FROM ima_file WHERE ima01 = g_bmb.bmb01
        SELECT bma05 INTO g_bma05 FROM bma_file WHERE bma01 = g_bmb.bmb01
        IF NOT cl_null(g_bma05) AND g_sma.sma101 = 'N' THEN
          #MOD-610014-begin-add S
          #IF g_ima08 MATCHES '[MPXT]' THEN
           IF g_ima08 MATCHES '[MPXTS]' THEN
          #MOD-610014-end
              CALL cl_err('','abm-120',0)
              RETURN
           END IF
        END IF
#bugno:6845 end.....................................
 
    BEGIN WORK
 
 
    OPEN i605_curl USING g_bmb.bmb01, g_bmb.bmb02, g_bmb.bmb03, g_bmb.bmb04, g_bmb.bmb29
 
    IF STATUS THEN
       CALL cl_err("OPEN i605_curl:", STATUS, 1)
       CLOSE i605_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i605_curl INTO g_bmb.*
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
                  '+',g_bmb.bmb29  #FUN-550093
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i605_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmb01"           #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bmb.bmb01       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bmb02"           #No.FUN-9B0098 10/02/24
        LET g_doc.value2  = g_bmb.bmb02       #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bmb03"           #No.FUN-9B0098 10/02/24
        LET g_doc.value3  = g_bmb.bmb03       #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bmb04"           #No.FUN-9B0098 10/02/24
        LET g_doc.value4  = g_bmb.bmb04       #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "bmb29"           #No.FUN-9B0098 10/02/24
        LET g_doc.value5  = g_bmb.bmb29       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
       IF g_sma.sma845='Y'   #低階碼可否部份重計
          THEN
          LET g_success='Y'
          #CALL s_uima146(g_bmb.bmb03)  #CHI-D10044
          CALL s_uima146(g_bmb.bmb03,0)  #CHI-D10044
          MESSAGE ""
       END IF
 
       DELETE FROM bmb_file WHERE bmb01 = g_bmb.bmb01
                               AND bmb02 = g_bmb.bmb02
                               AND bmb03 = g_bmb.bmb03
                               AND bmb04 = g_bmb.bmb04
                               AND bmb29 = g_bmb.bmb29 #FUN-550093
       #BugNo:4321
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980001 add plant & legal
           VALUES ('abmi605',g_user,g_today,g_msg,g_bmb.bmb01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
 
       LET g_bmb.bmb01 = NULL LET g_bmb.bmb02 = NULL
       LET g_bmb.bmb03 = NULL LET g_bmb.bmb04 = NULL
       LET g_bmb.bmb29 = NULL
       INITIALIZE g_bmb.* TO NULL
       CLEAR FORM
       OPEN i605_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i605_curl
          CLOSE i605_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i605_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i605_curl
          CLOSE i605_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i605_curs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i605_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i605_fetch('/')
       END IF
 
       LET g_msg=TIME
    END IF
    CLOSE i605_curl
	COMMIT WORK
END FUNCTION
 
FUNCTION i605_copy()
    DEFINE
        l_n               LIKE type_file.num5,       #No.FUN-680096 SMALLINT
        l_bmb RECORD LIKE bmb_file.*, #FUN-550093
        l_newno1,l_oldno1 LIKE bmb_file.bmb01,
        l_newno2,l_oldno2 LIKE bmb_file.bmb02,
        l_newno3,l_oldno3 LIKE bmb_file.bmb03,
        l_newno4,l_oldno4 LIKE bmb_file.bmb04,
        l_newno5,l_oldno5 LIKE bmb_file.bmb29 #FUN-550093
 
    IF g_bmb.bmb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_newno1  = NULL  LET l_newno2 = NULL
    LET l_newno3  = NULL  LET l_newno4 = NULL
    LET l_newno5  = NULL  LET l_newno5 = NULL #FUN-550093
 
    LET g_before_input_done = FALSE
    CALL i605_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno5 WITHOUT DEFAULTS #FUN-550093
       FROM bmb01,bmb02,bmb03,bmb04,bmb29 #FUN-550093
 
        BEFORE FIELD bmb01
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(7,15,l_newno1) RETURNING l_newno1
	            DISPLAY l_newno1 TO bmb01
	    END IF
 
        AFTER FIELD bmb01
            IF l_newno1 IS NOT NULL THEN
              #FUN-AA0059 ----------------------------add start----------------------
               IF NOT s_chk_item_no(l_newno1,'') THEN
                  CALL cl_err('',g_errno,1) 
                  NEXT FIELD bmb01
               END IF 
              #FUN-AA0059 ----------------------------add end----------------------
               SELECT ima08 INTO g_ima08 FROM ima_file WHERE ima01 = l_newno1
               IF SQLCA.sqlcode THEN #CALL cl_err(l_newno1,'mfg2717',0) #No.TQC-660046
                                      CALL cl_err3("sel","ima_file",l_newno1,"","mfg2717","","",1)   #TQC-660046
                  NEXT FIELD bmb01
               END IF
               #no.6845
               SELECT bma05 INTO g_bma05 FROM bma_file
                WHERE bma01 = g_bmb.bmb01
               IF STATUS = 0 THEN
                  IF NOT cl_null(g_bma05) AND g_sma.sma101 = 'N' THEN
                    #MOD-610014-begin-add S
                    #IF g_ima08_h MATCHES '[MPXT]' THEN
                     IF g_ima08_h MATCHES '[MPXTS]' THEN
                    #MOD-610014-end
                         CALL cl_err(l_newno1,'abm-120',1) NEXT FIELD bmb01
                     END IF
                  END IF
               END IF
               #no.6845(end)
            END IF
 
        BEFORE FIELD bmb03
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(10,15,l_newno3) RETURNING l_newno3
	                DISPLAY l_newno3 TO bmb03
	        END IF
 
        AFTER FIELD bmb03
            IF l_newno3 IS NOT NULL THEN
              #FUN-AA0059 -----------------------add start----------------------
               IF NOT s_chk_item_no(l_newno3,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bmb03
               END IF 
              #FUN-AA0059 -----------------------add end------------------------    
               IF l_newno1=l_newno3 THEN
                  NEXT FIELD bmb03
               ELSE
                 SELECT ima01 FROM ima_file WHERE ima01 = l_newno3
                    IF SQLCA.sqlcode THEN # CALL cl_err(l_newno3,'mfg2717',0) #No.TQC-660046
                                            CALL cl_err3("sel","ima_file",l_newno3,"","mfg2717","","",1)   #TQC-660046
                                 NEXT FIELD bmb03
                    END IF
               END IF
            END IF
 
        AFTER FIELD bmb04
            IF l_newno4 IS NOT NULL THEN
               SELECT count(*) INTO g_cnt FROM bmb_file
                   WHERE bmb01 = l_newno1 AND bmb02 = l_newno2
                     AND bmb03 = l_newno3 AND bmb04 = l_newno4
               IF g_cnt > 0 THEN
                   LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',
                             l_newno3 CLIPPED,'+',l_newno4
                   CALL cl_err(g_msg,-239,0)
                   NEXT FIELD bmb01
               END IF
            END IF
        AFTER INPUT
         ON ACTION controlp
            CASE
               WHEN INFIELD(bmb01) #料件主檔
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.default1 = l_newno1
                #  CALL cl_create_qry() RETURNING l_newno1
                   CALL q_sel_ima(FALSE, "q_ima", "", l_newno1, "", "", "", "" ,"",'' )  RETURNING l_newno1
#FUN-AA0059 --End--
#                  CALL FGL_DIALOG_SETBUFFER( l_newno1)
                   DISPLAY l_newno1 TO bmb01            #No.MOD-490371
                  NEXT FIELD bmb01
               WHEN INFIELD(bmb03) #料件主檔
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_ima"
               #   LET g_qryparam.default1 = l_newno3
               #   CALL cl_create_qry() RETURNING l_newno3
                   CALL q_sel_ima(FALSE, "q_ima", "", l_newno3, "", "", "", "" ,"",'' )  RETURNING l_newno3
#FUN-AA0059 --End--
#                  CALL FGL_DIALOG_SETBUFFER( l_newno3)
                   DISPLAY l_newno3 TO bmb03            #No.MOD-490371
                  NEXT FIELD bmb03
            END CASE
 
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_bmb.bmb01
        DISPLAY BY NAME g_bmb.bmb02
        DISPLAY BY NAME g_bmb.bmb03
        DISPLAY BY NAME g_bmb.bmb04
        DISPLAY BY NAME g_bmb.bmb29 #FUN-550093
        RETURN
    END IF
    IF l_newno5 IS NULL THEN LET l_newno5=' ' END IF
    DROP TABLE x
    SELECT * FROM bmb_file
        WHERE bmb01=g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29
        INTO TEMP x
    UPDATE x
        SET bmb01=l_newno1,   #資料鍵值-1
            bmb02=l_newno2,   #資料鍵值-2
            bmb03=l_newno3,   #資料鍵值-3
            bmb04=l_newno4,   #資料鍵值-4
            bmb29=l_newno5,   #FUN-550093
            bmb24=NULL        #工程變異單號ECN
    INSERT INTO bmb_file
        SELECT * FROM x
   #SELECT * INTO l_bmb.* FROM bmb_file WHERE bmb01=g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29
   #LET l_bmb.bmb01=l_newno1    #資料鍵值-1
   #LET l_bmb.bmb02=l_newno2    #資料鍵值-2
   #LET l_bmb.bmb03=l_newno3    #資料鍵值-3
   #LET l_bmb.bmb04=l_newno4    #資料鍵值-4
   #LET l_bmb.bmb29=l_newno5    #FUN-550093
   #LET l_bmb.bmb24=NULL        #工程變異單號ECN
   #IF l_bmb.bmb29 IS NULL THEN LET l_bmb.bmb29=' ' END IF
   #INSERT INTO bmb_file VALUES (l_bmb.*)
    #FUN-550093................end
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
              CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
              '+',g_bmb.bmb29  #FUN-550093
  #      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
         CALL cl_err3("ins","bmb_file",g_bmb.bmb01,g_bmb.bmb02,SQLCA.sqlcode,"",g_msg,1)   #TQC-660046
    ELSE
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
              CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04,
              '+',g_bmb.bmb29 #FUN-550093
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno1 = g_bmb.bmb01
        LET l_oldno2 = g_bmb.bmb02
        LET l_oldno3 = g_bmb.bmb03
        LET l_oldno4 = g_bmb.bmb04
        LET l_oldno5 = g_bmb.bmb29 #FUN-550093
        SELECT bmb_file.* INTO g_bmb.*
                FROM bmb_file WHERE bmb01 = l_newno1 AND
                     bmb02=l_newno2  AND bmb03=l_newno3
                     AND bmb04=l_newno4
                     AND bmb29=l_newno5 #FUN-550093
        CALL i605_u()
        #FUN-C30027---begin
        #SELECT bmb_file.* INTO g_bmb.*
        #        FROM bmb_file WHERE bmb01 = l_oldno1 AND
        #             bmb02=l_oldno2  AND bmb03=l_oldno3
        #             AND bmb04=l_oldno4 AND bmb29=l_oldno5 #FUN-550093
        #CALL i605_show()
        #FUN-C30027---end
        IF g_sma.sma845='Y'   #低階碼可否部份重計
           THEN
           LET g_success='Y'
           #CALL s_uima146(l_newno3)   #CHI-D10044
           CALL s_uima146(l_newno3,0)  #CHI-D10044
           MESSAGE ""
        END IF
    END IF
    DISPLAY BY NAME g_bmb.bmb01
    DISPLAY BY NAME g_bmb.bmb02
    DISPLAY BY NAME g_bmb.bmb03
    DISPLAY BY NAME g_bmb.bmb04
    DISPLAY BY NAME g_bmb.bmb29 #FUN-550093
END FUNCTION
 
FUNCTION i605_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmb01,bmb02,bmb03,bmb04",TRUE)
      #FUN-550093................begin
      IF g_sma.sma118='Y' THEN
         CALL cl_set_comp_entry("bmb29",TRUE)
      END IF
      #FUN-550093................end
   END IF
END FUNCTION
 
FUNCTION i605_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmb01,bmb02,bmb03,bmb04,bmb29",FALSE) #FUN-550093
   END IF
   IF NOT cl_null(g_argv1) AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmb01",FALSE)
   END IF
   IF g_sma.sma12 = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmb26",FALSE)
   END IF
   #FUN-550093................begin
   IF NOT (g_sma.sma118='Y') THEN
      CALL cl_set_comp_entry("bmb29",FALSE)
   END IF
   #FUN-550093................end
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
