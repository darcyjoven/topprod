# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimi154.4gl
# Descriptions...: 料件申請資料維護作業-生管資料
# Date & Author..: No.FUN-670033 06/08/30 By Mandy
# Modify.........: No.FUN-690026 06/09/14 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time改為g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750007 07/05/03 By Mandy #狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: No.MOD-880027 08/08/05 By Pengu 未對imaa93做處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0246 09/12/19 By sherry 當預測料號/預設製程料號與申請料號一樣時就不檢查是否存在ima_file中
# Modify.........: No:MOD-9C0247 09/12/22 By Pengu 加上變動前製時間批量
# Modify.........: No:MOD-A50113 10/05/18 By Sarah 若imaa571有值,imaa94開窗用q_ecu101;若imaa571沒值,imaa94開窗用q_ecu1
# Modify.........: No.TQC-B30009 11/03/02 By destiny 新增時orig,oriu未顯示
# Modify.........: No.FUN-9C0141 11/04/28 By shenyang 新增欄位imaa153
# Modify.........: No:FUN-BB0083 11/12/06 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE
    g_argv1              LIKE imaa_file.imaano,
    g_imaa        RECORD LIKE imaa_file.*,
    g_imaa_t      RECORD LIKE imaa_file.*,
    g_imaa_o      RECORD LIKE imaa_file.*,
    g_imaa01_t           LIKE imaa_file.imaa01,
    g_imaano_t           LIKE imaa_file.imaano,
    g_sw                 LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_sql           STRING,                 #TQC-630166
    g_s                  LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5    #FUN-570110  #No.FUN-690026 SMALLINT
DEFINE g_chr1               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr2               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr3               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_imaa55_t           LIKE imaa_file.imaa55  #FUN-BB0083 add
DEFINE g_imaa63_t           LIKE imaa_file.imaa63  #FUN-BB0083 add
 
FUNCTION aimi154(p_argv1)
    DEFINE p_argv1         LIKE imaa_file.imaano

    WHENEVER ERROR CALL cl_err_msg_log
 
    INITIALIZE g_imaa.* TO NULL
    INITIALIZE g_imaa_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imaa_file WHERE imaano = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi154_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_argv1 = p_argv1
#   IF g_argv1 IS NULL OR g_argv1= ' ' THEN  LET l_row=2 END IF   #wujie 091020

    OPEN WINDOW aimi154_w WITH FORM "aim/42f/aimi154"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN CALL aimi154_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi154_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi154_w
END FUNCTION
 
FUNCTION aimi154_curs()
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
       
       INITIALIZE g_imaa.* TO NULL    
       
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              imaa00  ,imaano    ,imaa01    ,imaa02  ,imaa021,
              imaa08  ,imaa25    ,imaa03    ,imaa1010,imaa92 ,
              imaa70  ,imaa55    ,imaa55_fac,imaa110 ,imaa56 ,
              imaa561 ,imaa562   ,imaa909   ,imaa153 ,imaa59  ,imaa60 ,  #FUN-9C0141
              imaa601,                                         #No:MOD-9C0247 add
              imaa61  ,imaa62    ,imaa58    ,imaa912 ,imaa571,
              imaa94  ,imaa111   ,imaa67    ,imaa68  ,imaa69 ,
              imaa63  ,imaa63_fac,imaa108   ,imaa136 ,imaa137,
              imaa64  ,imaa641   ,    
              imaauser,imaagrup  ,imaamodu  ,imaadate,imaaacti
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
           ON ACTION controlp
               CASE
                  WHEN INFIELD(imaa01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_imaa"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imaa01
                   NEXT FIELD imaa01
 
                  WHEN INFIELD(imaa111)                       #預設工單單別
                     CALL q_smy(TRUE,TRUE,' ','ASF','1') RETURNING g_qryparam.multiret #TQC-670008
                     DISPLAY g_qryparam.multiret TO imaa111
                     NEXT FIELD imaa111
                  WHEN INFIELD(imaa67)                         #采購員(imaa67)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_imaa.imaa67
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imaa67
                     CALL aimi154_peo(g_imaa.imaa67,'d')
                     NEXT FIELD imaa67
                  WHEN INFIELD(imaa55)                       # 生產單位 (imaa55)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imaa.imaa55
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imaa55
                     NEXT FIELD imaa55
                  WHEN INFIELD(imaa63)                       # 發料單位 (imaa63)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imaa.imaa63
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imaa63
                     NEXT FIELD imaa63
                  WHEN INFIELD(imaa136)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_imd"
                     LET g_qryparam.default1 = g_imaa.imaa136 #MOD-4A0213
                     LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imaa136
                     NEXT FIELD imaa136
                  WHEN INFIELD(imaa137)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_ime"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imaa137
                     NEXT FIELD imaa137
                  WHEN INFIELD(imaa571)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_ecu1"
                     LET g_qryparam.default1 = g_imaa.imaa571
                     LET g_qryparam.multiret_index = 1
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imaa571
                     NEXT FIELD imaa571
                  WHEN INFIELD(imaa94)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form ="q_ecu1"
                     LET g_qryparam.default1 = g_imaa.imaa571
                     LET g_qryparam.default2 = g_imaa.imaa94
                     LET g_qryparam.multiret_index = 2
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imaa94
                     NEXT FIELD imaa94
                  OTHERWISE EXIT CASE
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
 
           ON ACTION qbe_select
             CALL cl_qbe_select()
           ON ACTION qbe_save
	     CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
      LET g_wc = " imaano = '",g_argv1,"'"
    END IF
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #          LET g_wc = g_wc clipped," AND imaauser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #          LET g_wc = g_wc clipped," AND imaagrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #          LET g_wc = g_wc clipped," AND imaagrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('maauser', 'maagrup')
      #End:FUN-980030
 
    LET g_sql="SELECT imaano FROM imaa_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY imaano"
    PREPARE aimi154_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE aimi154_curs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi154_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM imaa_file WHERE ",g_wc CLIPPED
    PREPARE aimi154_precount FROM g_sql
    DECLARE aimi154_count CURSOR FOR aimi154_precount
END FUNCTION
 
FUNCTION aimi154_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi154_q()
            END IF
        ON ACTION next
            CALL aimi154_fetch('N')
        ON ACTION previous
            CALL aimi154_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi154_u()
            END IF
      #ON ACTION output
      #     LET g_action_choice="output"
      #     IF cl_chk_act_auth()
      #        THEN #CALL aimi154_out()
      #     END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #圖形顯示
           CALL i154_show_pic()
           CALL cl_show_fld_cont()   #FUN-550077
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL aimi154_fetch('/')
        ON ACTION first
            CALL aimi154_fetch('F')
        ON ACTION last
            CALL aimi154_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        #相關文件"
        ON ACTION related_document                          #No.FUN-680046
           LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_imaa.imaano IS NOT NULL THEN
                  LET g_doc.column1 = "imaano"
                  LET g_doc.value1 = g_imaa.imaano
                  CALL cl_doc()
              END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE aimi154_curs
END FUNCTION
 
 
FUNCTION aimi154_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_cont          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_imaa08        LIKE imaa_file.imaa08,
        l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct2       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #是否必要欄位有輸入  #No.FUN-690026 VARCHAR(1)
        l_cnt           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_case          STRING                  #FUN-BB0083 add
 
    DISPLAY BY NAME g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaadate,
                    g_imaa.imaaacti,
                    g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
 
    INPUT BY NAME
             g_imaa.imaa00  ,g_imaa.imaano    ,g_imaa.imaa01    ,g_imaa.imaa02  ,g_imaa.imaa021,
             g_imaa.imaa08  ,g_imaa.imaa25    ,g_imaa.imaa03    ,g_imaa.imaa1010,g_imaa.imaa92 ,
             g_imaa.imaa70  ,g_imaa.imaa55    ,g_imaa.imaa55_fac,g_imaa.imaa110 ,g_imaa.imaa56 ,
             g_imaa.imaa561 ,g_imaa.imaa562   ,g_imaa.imaa909   ,g_imaa.imaa153 ,g_imaa.imaa59  ,g_imaa.imaa60 ,  #FUN-9C141
             g_imaa.imaa601,                                                                         #No:MOD-9C0247 add
             g_imaa.imaa61  ,g_imaa.imaa62    ,g_imaa.imaa58    ,g_imaa.imaa912 ,g_imaa.imaa571,
             g_imaa.imaa94  ,g_imaa.imaa111   ,g_imaa.imaa67    ,g_imaa.imaa68  ,g_imaa.imaa69 ,
             g_imaa.imaa63  ,g_imaa.imaa63_fac,g_imaa.imaa108   ,g_imaa.imaa136 ,g_imaa.imaa137,
             g_imaa.imaa64  ,g_imaa.imaa641   ,
             g_imaa.imaauser,g_imaa.imaagrup  ,g_imaa.imaamodu  ,g_imaa.imaadate,g_imaa.imaaacti
      WITHOUT DEFAULTS
 
        BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL i154_set_entry(p_cmd)
             CALL i154_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
             #FUN-BB0083---add---str
             IF p_cmd = 'u' THEN
                LET g_imaa55_t = g_imaa.imaa55   
                LET g_imaa63_t = g_imaa.imaa63  
             END IF 
             IF p_cmd = 'a' THEN
                LET g_imaa55_t = NULL
                LET g_imaa63_t = NULL
             END IF
             #FUN-BB0083---add---end

#@@@@@可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#@@@@@                 2.使用製程(sma54 = 'y')
        AFTER FIELD imaa70  #消耗料件
            IF g_imaa.imaa70 IS NOT NULL THEN
               IF g_imaa.imaa70 NOT MATCHES '[YN]'
                  THEN NEXT FIELD imaa70
               END IF
               IF (g_imaa_o.imaa70 IS NULL) OR (g_imaa_t.imaa70 IS NULL)
                     OR (g_imaa.imaa70 != g_imaa_o.imaa70)
                 THEN IF g_imaa.imaa70 NOT MATCHES "[YN]"
                         OR g_imaa.imaa70 IS NULL THEN
                           CALL cl_err(g_imaa.imaa70,'mfg1002',0)
                           LET g_imaa.imaa70 = g_imaa_o.imaa70
                           DISPLAY BY NAME g_imaa.imaa70
                           NEXT FIELD imaa70
                       END IF
               END IF
               LET g_imaa_o.imaa70 = g_imaa.imaa70
            END IF
 
        AFTER FIELD imaa110
            IF cl_null(g_imaa.imaa110) OR g_imaa.imaa110 not matches '[1234]'
            THEN LET g_imaa.imaa110 = g_imaa_o.imaa110
                 DISPLAY BY NAME g_imaa.imaa110
                 NEXT FIELD imaa110
            END IF
 
        BEFORE FIELD imaa55           #生產單位=NULL時, Default 庫存單位
            IF g_imaa_o.imaa55 IS NULL AND g_imaa.imaa55 IS NULL THEN
               LET g_imaa.imaa55=g_imaa.imaa25
               LET g_imaa_o.imaa55=g_imaa.imaa25
               DISPLAY BY NAME g_imaa.imaa55
            END IF
        AFTER FIELD imaa55           #生產單位
            IF g_imaa.imaa55 IS NULL
               THEN LET g_imaa.imaa55=g_imaa.imaa25
                    DISPLAY BY NAME g_imaa.imaa55
            END IF
            IF  g_imaa.imaa55 IS NULL
               THEN LET g_imaa.imaa55 = g_imaa_o.imaa55
                    DISPLAY BY NAME g_imaa.imaa55
                    NEXT FIELD imaa55
            END IF
            IF g_imaa.imaa55 IS NOT NULL
               THEN IF (g_imaa_o.imaa55 IS NULL) OR (g_imaa.imaa55 != g_imaa_o.imaa55)
                       THEN SELECT gfe01
                              FROM gfe_file WHERE gfe01=g_imaa.imaa55 AND
                                                  gfeacti in ('y','Y')
                            IF SQLCA.sqlcode  THEN
                               CALL cl_err3("sel","gfe_file",g_imaa.imaa55,"",
                                            "mfg1325","","",1)  
                               LET g_imaa.imaa55 = g_imaa_o.imaa55
                               DISPLAY BY NAME g_imaa.imaa55
                               NEXT FIELD imaa55
#若料件生產單位與料件庫存單位相同，則轉換因子應為 1，不需輸入。
                            ELSE IF g_imaa.imaa55 = g_imaa.imaa25
                                 THEN LET g_imaa.imaa55_fac = 1
                                 ELSE CALL s_umfchk(g_imaa.imaa01,g_imaa.imaa55,
                                                    g_imaa.imaa25)
                                      RETURNING g_sw,g_imaa.imaa55_fac
                                      IF g_sw = '1' THEN
                                         CALL cl_err(g_imaa.imaa25,'mfg1206',0)
                                         LET g_imaa.imaa55 = g_imaa_o.imaa55
                                         DISPLAY BY NAME g_imaa.imaa55
                                         LET g_imaa.imaa55_fac = g_imaa_o.imaa55_fac
                                         DISPLAY BY NAME g_imaa.imaa55_fac
                                         NEXT FIELD imaa55
                                      END IF
                                 END IF
                            END IF
                        #MOD-560085-add
                        LET l_cnt = 0
                        SELECT COUNT(*) INTO l_cnt FROM bma_file
                         WHERE bma01 = g_imaa.imaa01
                           AND bmaacti = 'Y'
                        IF l_cnt > 0 THEN
                           CALL cl_err('','aim-134',1)
                        END IF
                        #MOD-560085-end
                        DISPLAY BY NAME g_imaa.imaa55_fac
                  END IF
            END IF
            LET g_imaa_o.imaa55 = g_imaa.imaa55
            LET g_imaa_o.imaa55_fac = g_imaa.imaa55_fac
            LET l_direct2='U'
            #FUN-BB0083---add---str
            LET l_case = ''
            IF NOT cl_null(g_imaa.imaa56) AND g_imaa.imaa56<>0 THEN
               IF NOT i154_imaa56_check() THEN
                  LET l_case = "imaa56"
               END IF
            END IF
            IF NOT cl_null(g_imaa.imaa561) AND g_imaa.imaa561<>0 THEN
               IF NOT i154_imaa561_check() THEN
                  LET l_case = "imaa561"
               END IF
            END IF
            LET g_imaa55_t = g_imaa.imaa55
            CASE l_case
               WHEN "imaa561"
                  NEXT FIELD imaa561
               WHEN "imaa56"
                  NEXT FIELD imaa56
               OTHERWISE EXIT CASE
            END CASE
            #FUN-BB0083---add---end
 
#為防本來已有生產單位與單位相同,而轉換率尚無值 MAY
        BEFORE FIELD imaa55_fac
            IF g_imaa.imaa25 = g_imaa.imaa55 THEN LET g_imaa.imaa55_fac = 1 END IF
        AFTER FIELD imaa55_fac
            IF g_imaa.imaa55_fac IS NULL OR g_imaa.imaa55_fac = ' '
               OR g_imaa.imaa55_fac <= 0
            THEN CALL cl_err(g_imaa.imaa55_fac,'mfg1322',0)
                 LET  g_imaa.imaa55_fac = g_imaa_o.imaa55_fac
                 DISPLAY BY NAME g_imaa.imaa55_fac
                 NEXT FIELD imaa55_fac
            END IF
            LET g_imaa_o.imaa55_fac = g_imaa.imaa55_fac
 
        BEFORE FIELD imaa56
             IF g_imaa.imaa56 IS NULL THEN LET g_imaa.imaa56 = 1 END IF
 
        AFTER FIELD imaa56          #生產單位批數
           IF NOT i154_imaa56_check() THEN NEXT FIELD imaa56 END IF #FUN-BB0083  add            
        #FUN-BB0083---mark---str
        #  #若輸入為零表示不作控制，系統自動轉為  1。
        #  #  IF g_imaa.imaa56 = 0 THEN LET g_imaa.imaa56 = 1 END IF
        #     IF g_imaa.imaa56 IS NULL OR g_imaa.imaa56 = ' '
        #       OR g_imaa.imaa56 < 0
        #       THEN
        #            CALL cl_err(g_imaa.imaa56,'mfg0013',0)
        #            LET g_imaa.imaa56 = g_imaa_o.imaa56
        #            DISPLAY BY NAME g_imaa.imaa56
        #            NEXT FIELD imaa56
        #     END IF
        #    LET g_imaa_o.imaa56 = g_imaa.imaa56
        #FUN-BB0083---mark---end
        BEFORE FIELD imaa561
             IF g_imaa.imaa561 IS NULL THEN LET g_imaa.imaa561= 0 END IF
 
        AFTER FIELD imaa561          #最少生產數量
#輸入之數量應為前述生產單位批量的倍數    MAY
          IF NOT i154_imaa561_check() THEN NEXT FIELD imaa561 END IF #FUN-BB0083 add
          #FUN-BB0083---mark---str
          #IF  g_imaa.imaa561 >1 AND g_imaa.imaa56 >0
          #    THEN
          #    IF (g_imaa.imaa56 mod g_imaa.imaa561) != 0 THEN
          #       CALL aimi154_size()
          #    END IF
          #END IF
          #  IF g_imaa.imaa561 IS NULL OR g_imaa.imaa561 = ' '
          #      OR g_imaa.imaa561 < 0
          #     THEN CALL cl_err(g_imaa.imaa561,'mfg0013',0)
          #           LET g_imaa.imaa561 = g_imaa_o.imaa561
          #           DISPLAY BY NAME g_imaa.imaa561
          #           NEXT FIELD imaa561
          #   END IF
          #  LET g_imaa_o.imaa561 = g_imaa.imaa561
          #FUN-BB0083---mark---end
          
        AFTER FIELD imaa562          #生產時損耗率
             IF g_imaa.imaa562 IS NULL OR g_imaa.imaa562 = ' '
               OR g_imaa.imaa562 < 0 OR g_imaa.imaa562 > 100
                THEN CALL cl_err(g_imaa.imaa62,'mfg1332',0)
                     LET g_imaa.imaa562 = g_imaa_o.imaa562
                     DISPLAY BY NAME g_imaa.imaa562
                     NEXT FIELD imaa562
             END IF
            LET g_imaa_o.imaa562 = g_imaa.imaa562
#FUN-9C0141--add--begin
        AFTER FIELD imaa153
          IF g_imaa.imaa153 < 0 THEN
             CALL cl_err('','aec-020',0)
             NEXT FIELD imaa153
          END IF
#FUN-9C0141--add--end 
        AFTER FIELD imaa67            #計劃員
           IF (g_imaa_o.imaa67 IS NULL ) OR (g_imaa.imaa67 != g_imaa_o.imaa67)
               OR (g_imaa_o.imaa67 IS NOT NULL AND g_imaa.imaa67 IS NULL)
              THEN CALL aimi154_peo(g_imaa.imaa67,'a')
                   IF g_chr = 'E' THEN
                      CALL cl_err(g_imaa.imaa67,'mfg1312',0)
                      LET g_imaa.imaa67 = g_imaa_o.imaa67
                      DISPLAY BY NAME g_imaa.imaa67
                      NEXT FIELD imaa67
                   END IF
            END IF
            LET g_imaa_o.imaa67 = g_imaa.imaa67
            LET l_direct = 'U'
 
        AFTER FIELD imaa68          #需求時距
             IF g_imaa.imaa68 IS NULL OR g_imaa.imaa68 = ' '
                 OR g_imaa.imaa68 < 0
                THEN CALL cl_err(g_imaa.imaa68,'mfg0013',0)
                     LET g_imaa.imaa68 = g_imaa_o.imaa68
                     DISPLAY BY NAME g_imaa.imaa68
                     NEXT FIELD imaa68
             END IF
            LET g_imaa_o.imaa68 = g_imaa.imaa68
 
        AFTER FIELD imaa69          #計劃時距
             IF g_imaa.imaa69 IS NULL OR g_imaa.imaa69 = ' '
                 OR g_imaa.imaa69 < 0
                THEN CALL cl_err(g_imaa.imaa69,'mfg0013',0)
                     LET g_imaa.imaa69 = g_imaa_o.imaa69
                     DISPLAY BY NAME g_imaa.imaa69
                     NEXT FIELD imaa69
             END IF
            LET g_imaa_o.imaa69 = g_imaa.imaa69
        AFTER FIELD imaa571
          IF NOT cl_null(g_imaa.imaa571) THEN
             SELECT COUNT(*) INTO g_cnt FROM ecu_file WHERE ecu01=g_imaa.imaa571
                AND ecuacti = 'Y'  #CHI-C90006
             #IF g_cnt =0 THEN #MOD-9C0246
             IF g_cnt =0 AND g_imaa.imaa01 <> g_imaa.imaa571 THEN  #MOD-9C0246
                CALL cl_err(g_imaa.imaa571,'aec-014',0)
                LET g_imaa.imaa571 = g_imaa_o.imaa571
                DISPLAY BY NAME g_imaa.imaa571
                NEXT FIELD imaa571
             END IF
          END IF
 
        AFTER FIELD imaa94
            LET g_msg=NULL
            IF g_imaa.imaa94 IS NOT NULL THEN
               IF NOT cl_null(g_imaa.imaa571) THEN
                  SELECT ecu03 INTO g_msg FROM ecu_file
                   WHERE ecu01=g_imaa.imaa571 AND ecu02=g_imaa.imaa94
                     AND ecuacti = 'Y'  #CHI-C90006
               ELSE
                  SELECT unique ecu03 INTO g_msg FROM ecu_file
                   WHERE ecu02=g_imaa.imaa94
                     AND ecuacti = 'Y'  #CHI-C90006
               END IF
               IF STATUS=100         THEN #No.7926
                  CALL cl_err(g_imaa.imaa94,'aec-014',0)
                  LET g_imaa.imaa94 = g_imaa_o.imaa94
                  DISPLAY BY NAME g_imaa.imaa94
                  NEXT FIELD imaa94
               END IF
             END IF
             DISPLAY g_msg TO ecu03
 
        AFTER FIELD imaa58          #標準人工工時
             IF g_imaa.imaa58 IS NULL OR g_imaa.imaa58 = ' '
                OR g_imaa.imaa58 < 0
                THEN CALL cl_err(g_imaa.imaa58,'mfg0013',0)
                     LET g_imaa.imaa58 = g_imaa_o.imaa58
                     DISPLAY BY NAME g_imaa.imaa58
                     NEXT FIELD imaa58
             END IF
             LET g_imaa_o.imaa58 = g_imaa.imaa58
 
        AFTER FIELD imaa912         #標準機器工時
             IF g_imaa.imaa912 IS NULL OR g_imaa.imaa912 = ' '
                OR g_imaa.imaa912 < 0
                THEN CALL cl_err(g_imaa.imaa912,'mfg1322',0)  #不可空白，且輸入之值必須大於零
                     LET g_imaa.imaa912 = g_imaa_o.imaa912
                     DISPLAY BY NAME g_imaa.imaa912
                     NEXT FIELD imaa912
             END IF
             LET g_imaa_o.imaa912 = g_imaa.imaa912
 
        AFTER FIELD imaa59          #固定前置時間
             IF g_imaa.imaa59 IS NULL OR g_imaa.imaa59 = ' '
                OR g_imaa.imaa59 < 0
                THEN CALL cl_err(g_imaa.imaa59,'mfg0013',0)
                     LET g_imaa.imaa59 = g_imaa_o.imaa59
                     DISPLAY BY NAME g_imaa.imaa59
                     NEXT FIELD imaa59
             END IF
             LET g_imaa_o.imaa59 = g_imaa.imaa59
 
        AFTER FIELD imaa60          #變動前置時間
             IF g_imaa.imaa60 IS NULL OR g_imaa.imaa60 = ' '
                OR g_imaa.imaa60 < 0
                THEN CALL cl_err(g_imaa.imaa60,'mfg0013',0)
                     LET g_imaa.imaa60 = g_imaa_o.imaa60
                     DISPLAY BY NAME g_imaa.imaa60
                     NEXT FIELD imaa60
             END IF
            LET g_imaa_o.imaa60 = g_imaa.imaa60
  
       #------------------No:MOD-9C0247 add
        AFTER FIELD imaa601          #變動前置時間批量
             IF g_imaa.imaa601 IS NULL OR g_imaa.imaa601 = ' '
                OR g_imaa.imaa601 <= 0
                THEN CALL cl_err(g_imaa.imaa601,'mfg9243',0)
                     LET g_imaa.imaa601 = g_imaa_o.imaa601
                     DISPLAY BY NAME g_imaa.imaa601
                     NEXT FIELD imaa601
             END IF
            LET g_imaa_o.imaa601 = g_imaa.imaa601
       #------------------No:MOD-9C0247 add
 
        AFTER FIELD imaa61          #QC前置時間
             IF g_imaa.imaa61 IS NULL OR g_imaa.imaa61 = ' '
                OR g_imaa.imaa61 < 0
                THEN CALL cl_err(g_imaa.imaa61,'mfg0013',0)
                     LET g_imaa.imaa61 = g_imaa_o.imaa61
                     DISPLAY BY NAME g_imaa.imaa61
                     NEXT FIELD imaa61
             END IF
            LET g_imaa_o.imaa61 = g_imaa.imaa61
 
        AFTER FIELD imaa62          #累計前置時間
             IF g_imaa.imaa62 IS NULL OR g_imaa.imaa62 = ' '
                OR g_imaa.imaa62 < 0
                THEN CALL cl_err(g_imaa.imaa62,'mfg0013',0)
                     LET g_imaa.imaa62 = g_imaa_o.imaa62
                     DISPLAY BY NAME g_imaa.imaa62
                     NEXT FIELD imaa62
             END IF
            LET g_imaa_o.imaa62 = g_imaa.imaa62
 
        AFTER FIELD imaa111
          IF NOT cl_null(g_imaa.imaa111) THEN
             SELECT COUNT(*) INTO l_cnt FROM smy_file
              WHERE smyslip=g_imaa.imaa111 AND smysys='asf'
             IF l_cnt=0 THEN
                CALL cl_err(g_imaa.imaa111,'mfg0014',2)
                NEXT FIELD imaa111
             END IF
          END IF
          LET l_direct='U'
 
        BEFORE FIELD imaa63           #發料單位=NULL時, Default 庫存單位
            IF g_imaa_o.imaa63 IS NULL AND g_imaa.imaa63 IS NULL THEN
               LET g_imaa.imaa63=g_imaa.imaa25
               LET g_imaa_o.imaa63=g_imaa.imaa25
               DISPLAY BY NAME g_imaa.imaa63
            END IF
 
        AFTER FIELD imaa63           #發料單位
#輸入時，若為空白，則預設值為庫存單位。
            IF g_imaa.imaa63 IS NULL
               THEN LET g_imaa.imaa63=g_imaa.imaa25
                    DISPLAY  BY NAME g_imaa.imaa63
            END IF
            IF  g_imaa.imaa63 IS NULL
              THEN LET g_imaa.imaa63 = g_imaa_o.imaa63
                   DISPLAY BY NAME g_imaa.imaa63
                   NEXT FIELD imaa63
            END IF
            IF (g_imaa_o.imaa63 IS NULL) OR (g_imaa.imaa63 != g_imaa_o.imaa63)
              THEN SELECT gfe01
                     FROM gfe_file WHERE gfe01=g_imaa.imaa63 AND
                                         gfeacti in ('y','Y')
                   IF SQLCA.sqlcode  THEN
                      CALL cl_err3("sel","gfe_file",g_imaa.imaa63,"",
                                   "mfg1326","","",1)
                      LET g_imaa.imaa63 = g_imaa_o.imaa63
                      DISPLAY BY NAME g_imaa.imaa63
                      NEXT FIELD imaa63
                   ELSE IF g_imaa.imaa63 = g_imaa.imaa25
                        THEN LET g_imaa.imaa63_fac = 1
                        ELSE CALL s_umfchk(g_imaa.imaa01,g_imaa.imaa63,
                                           g_imaa.imaa25)
                             RETURNING g_sw,g_imaa.imaa63_fac
                             IF g_sw = '1' THEN
                                CALL cl_err(g_imaa.imaa63,'mfg1206',0)
                                LET g_imaa.imaa63 = g_imaa_o.imaa63
                                DISPLAY BY NAME g_imaa.imaa63
                                LET g_imaa.imaa63_fac = g_imaa_o.imaa63_fac
                                DISPLAY BY NAME g_imaa.imaa63_fac
                                NEXT FIELD imaa63
                             END IF
                            END IF
                       DISPLAY BY NAME g_imaa.imaa63_fac
                  END IF
            END IF
            LET g_imaa_o.imaa63 = g_imaa.imaa63
            LET g_imaa_o.imaa63_fac = g_imaa.imaa63_fac
            #FUN-BB0083---add---str
            LET l_case = ''
            IF NOT cl_null(g_imaa.imaa641) AND g_imaa.imaa641<>0 THEN
               CALL i154_imaa641_check() RETURNING l_case
            END IF
            IF NOT cl_null(g_imaa.imaa64) AND g_imaa.imaa64<>0 THEN
               IF NOT i154_imaa64_check() THEN LET l_case = "imaa64" END IF
            END IF
            LET g_imaa63_t = g_imaa.imaa63
            CASE l_case
               WHEN "imaa641"
                  NEXT FIELD imaa641
               WHEN "imaa64"
                  NEXT FIELD imaa64
               OTHERWISE EXIT CASE
            END CASE
            #FUN-BB0083---add---end
 
        BEFORE FIELD imaa63_fac
#為防本來已有生產單位與單位相同,而轉換率尚無值 MAY
            IF g_imaa.imaa25 = g_imaa.imaa63 THEN
               LET g_imaa.imaa63_fac = 1
            END IF
 
        AFTER FIELD imaa63_fac
            IF g_imaa.imaa63_fac IS NULL OR g_imaa.imaa63_fac = ' '
               OR g_imaa.imaa63_fac <= 0
            THEN CALL cl_err(g_imaa.imaa63_fac,'mfg1322',0)
                 LET g_imaa.imaa63_fac = g_imaa_o.imaa63_fac
                 DISPLAY BY NAME g_imaa.imaa63_fac
                 NEXT FIELD imaa63_fac
            END IF
            LET g_imaa_o.imaa63_fac = g_imaa.imaa63_fac
 
 
        AFTER FIELD imaa64          #發料單位批數
             #FUN-BB0083---add---str
             IF NOT i154_imaa64_check() THEN LET l_case = "imaa64" END IF
             #FUN-BB0083---add---end
             #FUN-BB0083---mark---str
             #IF g_imaa.imaa64 IS NULL OR g_imaa.imaa64 = ' '
             #  OR g_imaa.imaa64 < 0
             #   THEN CALL cl_err(g_imaa.imaa64,'mfg0013',0)
             #        LET g_imaa.imaa64 = g_imaa_o.imaa64
             #        DISPLAY BY NAME g_imaa.imaa64
             #        NEXT FIELD imaa64
             #END IF
             #LET g_imaa_o.imaa64 = g_imaa.imaa64
             #FUN-BB0083---mark---end
        AFTER FIELD imaa641          #最少發料數量
           CALL i154_imaa641_check() RETURNING l_case
             CASE l_case
                WHEN "imaa641"
                   NEXT FIELD imaa641
                WHEN "imaa64"
                   NEXT FIELD imaa64
                OTHERWISE EXIT CASE
             END CASE
             #FUN-BB0083---mark---str        
             #IF g_imaa.imaa641 IS NULL OR g_imaa.imaa641 = ' '
             #  OR g_imaa.imaa641 < 0
             #   THEN CALL cl_err(g_imaa.imaa641,'mfg0013',0)
             #        LET g_imaa.imaa641 = g_imaa_o.imaa641
             #        DISPLAY BY NAME g_imaa.imaa641
             #        NEXT FIELD imaa641
             #END IF
             #IF g_imaa.imaa64 >1 AND  g_imaa.imaa641 >0 THEN
             #   IF (g_imaa.imaa641 mod g_imaa.imaa64) != 0 THEN
             #      CALL aimi154_size1()
             #   END IF
             #   IF g_imaa.imaa641 mod g_imaa.imaa64 <> 0 THEN
             #      CALL cl_err('','aim-402',0)
             #      NEXT FIELD imaa64
             #   END IF
             #END IF
             #LET g_imaa_o.imaa641 = g_imaa.imaa641
             #LET l_direct = 'D'
             #FUN-BB0083---mark---end
             
        AFTER FIELD imaa108
            IF NOT cl_null(g_imaa.imaa108) THEN
               IF NOT cl_null(g_imaa.imaa108) THEN
                  IF g_imaa.imaa108 NOT MATCHES "[YN]" THEN NEXT FIELD imaa108 END IF
               END IF
               LET g_imaa_o.imaa108 = g_imaa.imaa108
            END IF
 
        AFTER FIELD imaa136
            IF g_imaa.imaa136 !=' ' AND g_imaa.imaa136 IS NOT NULL THEN
               SELECT * FROM imd_file WHERE imd01=g_imaa.imaa136 AND imdacti='Y'
               IF SQLCA.SQLCODE THEN  #No.7926
                  CALL cl_err3("sel","imd_file",g_imaa.imaa136,"",
                               "mfg1100","","",1)
                  LET g_imaa.imaa136 = g_imaa_o.imaa136
                  DISPLAY BY NAME g_imaa.imaa136
                  NEXT FIELD imaa136
               END IF
            END IF
	 IF NOT s_imechk(g_imaa.imaa136,g_imaa.imaa137) THEN NEXT FIELD imaa137 END IF  #FUN-D40103 add
 
        AFTER FIELD imaa137
	#FUN-D40103--mark--str--
        #    IF g_imaa.imaa137 !=' ' AND g_imaa.imaa137 IS NOT NULL THEN
        #       SELECT * FROM ime_file WHERE ime01=g_imaa.imaa136
        #                                AND ime02=g_imaa.imaa137
        #       IF SQLCA.SQLCODE THEN  #No.7926
        #          CALL cl_err3("sel","ime_file",g_imaa.imaa136,g_imaa.imaa137,
        #                       "mfg1101","","",1)  
        #          LET g_imaa.imaa137 = g_imaa_o.imaa137
         #         DISPLAY BY NAME g_imaa.imaa137
        #          NEXT FIELD imaa137
        #       END IF
        #    END IF
 	#FUN-D40103--mark--end--
            #FUN-D40103--add--str--
            IF cl_null(g_imaa.imaa137) THEN LET g_imaa.imaa137 = ' ' END IF 
            IF NOT s_imechk(g_imaa.imaa136,g_imaa.imaa137) THEN 
               LET g_imaa.imaa137 = g_imaa_o.imaa137
               DISPLAY BY NAME g_imaa.imaa137
               NEXT FIELD imaa137
            END IF 
            #FUN-D40103--add--end--

        AFTER INPUT
           LET g_imaa.imaauser = s_get_data_owner("imaa_file") #FUN-C10039
           LET g_imaa.imaagrup = s_get_data_group("imaa_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_imaa.imaa01 IS NULL THEN  #料件編號
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa01
            END IF
            IF g_imaa.imaa70 NOT MATCHES "[YN]" OR g_imaa.imaa70 IS NULL THEN
               LET l_flag='Y'   #消耗料件
               DISPLAY BY NAME g_imaa.imaa70
            END IF
            IF g_imaa.imaa56 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa56
            END IF
            IF g_imaa.imaa561 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa561
            END IF
            IF g_imaa.imaa562 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa562
            END IF
            IF g_imaa.imaa58 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa58
            END IF
            IF g_imaa.imaa59 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa59
            END IF
            IF g_imaa.imaa60 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa60
            END IF
            IF g_imaa.imaa61 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa61
            END IF
            IF g_imaa.imaa62 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa62
 
            END IF
            IF g_imaa.imaa55 IS NULL THEN  #生產單位
               LET g_imaa.imaa55=g_imaa.imaa25
               DISPLAY BY NAME g_imaa.imaa55
            END IF
            IF g_imaa.imaa55_fac IS NULL OR g_imaa.imaa55_fac<=0 THEN
               LET l_flag='Y'     #生產單位轉換因子
               DISPLAY BY NAME g_imaa.imaa55_fac
            END IF
            IF g_imaa.imaa63 IS NULL THEN  #發料單位
               LET g_imaa.imaa63=g_imaa.imaa25
               DISPLAY BY NAME g_imaa.imaa63
               #FUN-BB0083---add---str
               LET g_imaa.imaa64 = s_digqty(g_imaa.imaa64,g_imaa.imaa63)
               LET g_imaa.imaa641= s_digqty(g_imaa.imaa641,g_imaa.imaa63)
               #FUN-BB0083---add---end
            END IF
            IF g_imaa.imaa63_fac IS NULL  OR g_imaa.imaa63_fac<=0 THEN #發料批量
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa63_fac
            END IF
            IF g_imaa.imaa64 IS NULL  THEN  #發料批量
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa64
            END IF
            IF g_imaa.imaa641 IS NULL THEN  #發料數量
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa641
            END IF
            IF g_imaa.imaa68 IS NULL  THEN  #需求時距
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa68
            END IF
            IF g_imaa.imaa69 IS NULL  THEN  #計劃時距
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa69
            END IF
            IF g_imaa.imaa110 IS NULL OR g_imaa.imaa110 NOT MATCHES "[1234]" THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa110
            END IF
            #發料前調撥否
            IF g_imaa.imaa108 IS NULL OR g_imaa.imaa108 NOT MATCHES "[YN]" THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa108
            END IF
            IF g_imaa.imaa912 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa912
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imaa70
            END IF
            IF g_imaa.imaa641>1 AND g_imaa.imaa64!=0 THEN
               IF g_imaa.imaa641 mod g_imaa.imaa64 <> 0 THEN
                  DISPLAY BY NAME g_imaa.imaa64
                  DISPLAY BY NAME g_imaa.imaa641
                  CALL cl_err('','aim-402',0)
                  NEXT FIELD imaa64
               END IF
            END IF
 
        ON ACTION create_unit
           CALL cl_cmdrun("aooi101 ")
 
        ON ACTION create_item
           CALL cl_cmdrun("aooi103 ")
 
        ON ACTION unit_conversion
           CALL cl_cmdrun("aooi102 ")
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(imaa111)                       #預設工單單別
                  CALL q_smy(FALSE,FALSE,' ','ASF','1') RETURNING g_imaa.imaa111 #TQC-670008
                  DISPLAY  BY NAME g_imaa.imaa111
                  NEXT FIELD imaa111
               WHEN INFIELD(imaa67)                         #采購員(imaa67)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gen"
                  LET g_qryparam.default1 = g_imaa.imaa67
                  CALL cl_create_qry() RETURNING g_imaa.imaa67
                  DISPLAY BY NAME g_imaa.imaa67
                  CALL aimi154_peo(g_imaa.imaa67,'d')
                  NEXT FIELD imaa67
               WHEN INFIELD(imaa55)                       # 生產單位 (imaa55)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa55
                  CALL cl_create_qry() RETURNING g_imaa.imaa55
                  DISPLAY BY NAME g_imaa.imaa55
                  NEXT FIELD imaa55
               WHEN INFIELD(imaa63)                       # 發料單位 (imaa63)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa63
                  CALL cl_create_qry() RETURNING g_imaa.imaa63
                  DISPLAY BY NAME g_imaa.imaa63
                  NEXT FIELD imaa63
               WHEN INFIELD(imaa136)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imd"
                  LET g_qryparam.default1 = g_imaa.imaa136 #MOD-4A0213
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                  CALL cl_create_qry() RETURNING g_imaa.imaa136
                  DISPLAY BY NAME g_imaa.imaa136
                  NEXT FIELD imaa136
               WHEN INFIELD(imaa137)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ime"
                  LET g_qryparam.default1 = g_imaa.imaa137 #MOD-4A0063
                  LET g_qryparam.arg1     = g_imaa.imaa136 #倉庫編號 #MOD-4A0063
                  LET g_qryparam.arg2     = 'SW'         #倉庫類別 #MOD-4A0063
                  CALL cl_create_qry() RETURNING g_imaa.imaa137
                  DISPLAY BY NAME g_imaa.imaa137
                  NEXT FIELD imaa137
               WHEN INFIELD(imaa571)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ecu1"
                  LET g_qryparam.default1 = g_imaa.imaa571
                  CALL cl_create_qry() RETURNING g_imaa.imaa571,g_imaa.imaa94
                  DISPLAY BY NAME g_imaa.imaa571,g_imaa.imaa571
                  NEXT FIELD imaa571
               WHEN INFIELD(imaa94)
                  CALL cl_init_qry_var()
                 #str MOD-A50113 mod
                 #LET g_qryparam.form ="q_ecu1"
                  IF NOT cl_null(g_imaa.imaa571) THEN
                     LET g_qryparam.form ="q_ecu101"
                  ELSE
                     LET g_qryparam.form ="q_ecu1"
                  END IF
                 #end MOD-A50113 mod
                  LET g_qryparam.default1 = g_imaa.imaa571
                  LET g_qryparam.default2 = g_imaa.imaa94
                 #str MOD-A50113 add
                  IF NOT cl_null(g_imaa.imaa571) THEN
                     LET g_qryparam.arg1 = g_imaa.imaa571
                  END IF
                 #end MOD-A50113 mod
                  CALL cl_create_qry() RETURNING g_imaa.imaa571,g_imaa.imaa94
                  DISPLAY BY NAME g_imaa.imaa571,g_imaa.imaa94
                  NEXT FIELD imaa94
               OTHERWISE EXIT CASE
            END CASE
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
    END INPUT
END FUNCTION
 
 
FUNCTION aimi154_size()
DEFINE l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_imaa561       LIKE imaa_file.imaa561
 
      LET l_count = g_imaa.imaa561 MOD g_imaa.imaa56
      IF l_count != 0 THEN
         LET l_count = g_imaa.imaa561/ g_imaa.imaa56
         LET l_imaa561 = ( l_count + 1 ) * g_imaa.imaa56
         CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
         WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg CLIPPED,'(',l_imaa561,')',':' FOR g_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
              ON ACTION about         
                 CALL cl_about()      
              
              ON ACTION help          
                 CALL cl_show_help()  
              
              ON ACTION controlg      
                 CALL cl_cmdask()     
 
 
           END PROMPT
           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         END WHILE
         IF g_chr ='Y' OR g_chr = 'y'  THEN
            LET g_imaa.imaa561 = l_imaa561
         END IF
         DISPLAY BY NAME g_imaa.imaa561
      END IF
      LET g_chr = NULL
END FUNCTION
 
FUNCTION aimi154_size1()  #檢查發料數量是否為發料批量之倍數及建議發料數量
DEFINE l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_imaa641       LIKE imaa_file.imaa641
 
      LET l_count = g_imaa.imaa641 MOD g_imaa.imaa64
      IF l_count != 0 THEN
         LET l_count = g_imaa.imaa641/ g_imaa.imaa64
         LET l_imaa641 = ( l_count + 1 ) * g_imaa.imaa64
         CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
         WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg FOR g_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
              ON ACTION about         
                 CALL cl_about()      
              
              ON ACTION help          
                 CALL cl_show_help()  
              
              ON ACTION controlg      
                 CALL cl_cmdask()     
 
 
           END PROMPT
           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         END WHILE
         IF g_chr ='Y' OR g_chr = 'y'  THEN
           LET g_imaa.imaa641 = l_imaa641
         END IF
         DISPLAY BY NAME g_imaa.imaa641
      END IF
      LET g_chr = NULL
END FUNCTION
 
 
FUNCTION aimi154_peo(p_key,p_cmd)    #人員
    DEFINE p_key     LIKE gen_file.gen01,
           p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02   LIKE gen_file.gen02
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_gen02=NULL
    ELSE
        SELECT gen02,genacti INTO l_gen02,l_genacti
          FROM gen_file
           WHERE gen01 = p_key
         IF SQLCA.sqlcode
           THEN LET l_gen02 = NULL
                LET g_chr = 'E'
           ELSE
             IF l_genacti='N' THEN
                LET g_chr = 'E'
             END IF
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_gen02 TO gen02
    END IF
END FUNCTION
 
FUNCTION aimi154_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi154_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi154_count
    FETCH aimi154_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi154_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        INITIALIZE g_imaa.* TO NULL
    ELSE
        CALL aimi154_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi154_fetch(p_flimaa)
    DEFINE
        p_flimaa          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimaa
        WHEN 'N' FETCH NEXT     aimi154_curs INTO g_imaa.imaano
        WHEN 'P' FETCH PREVIOUS aimi154_curs INTO g_imaa.imaano
        WHEN 'F' FETCH FIRST    aimi154_curs INTO g_imaa.imaano
        WHEN 'L' FETCH LAST     aimi154_curs INTO g_imaa.imaano
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         
                      CALL cl_about()      
                   
                   ON ACTION help          
                      CALL cl_show_help()  
                   
                   ON ACTION controlg      
                      CALL cl_cmdask()     
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump aimi154_curs INTO g_imaa.imaano
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        INITIALIZE g_imaa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flimaa
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_imaa.* FROM imaa_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imaano = g_imaa.imaano
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","imaa_file",g_imaa.imaano,"",
                     SQLCA.sqlcode,"","",1)  
    ELSE
        LET g_data_owner = g_imaa.imaauser 
        LET g_data_group = g_imaa.imaagrup
        CALL aimi154_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi154_show()
    LET g_imaa_t.* = g_imaa.*
    DISPLAY BY NAME
             g_imaa.imaa00  ,g_imaa.imaano    ,g_imaa.imaa01    ,g_imaa.imaa02  ,g_imaa.imaa021,
             g_imaa.imaa08  ,g_imaa.imaa25    ,g_imaa.imaa03    ,g_imaa.imaa1010,g_imaa.imaa92 ,
             g_imaa.imaa70  ,g_imaa.imaa55    ,g_imaa.imaa55_fac,g_imaa.imaa110 ,g_imaa.imaa56 ,
             g_imaa.imaa561 ,g_imaa.imaa562   ,g_imaa.imaa909   ,g_imaa.imaa153, g_imaa.imaa59  ,g_imaa.imaa60 ,  #FUN-9C0141
             g_imaa.imaa601,                                                                         #No:MOD-9C0247 add
             g_imaa.imaa61  ,g_imaa.imaa62    ,g_imaa.imaa58    ,g_imaa.imaa912 ,g_imaa.imaa571,
             g_imaa.imaa94  ,g_imaa.imaa111   ,g_imaa.imaa67    ,g_imaa.imaa68  ,g_imaa.imaa69 ,
             g_imaa.imaa63  ,g_imaa.imaa63_fac,g_imaa.imaa108   ,g_imaa.imaa136 ,g_imaa.imaa137,
             g_imaa.imaa64  ,g_imaa.imaa641   ,
             g_imaa.imaauser,g_imaa.imaagrup  ,g_imaa.imaamodu  ,g_imaa.imaadate,g_imaa.imaaacti,
             g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
               
    CALL aimi154_peo(g_imaa.imaa67,'d')
    LET g_msg=NULL
    IF g_imaa.imaa94 IS NOT NULL THEN
       IF g_imaa.imaa571 IS NULL THEN LET g_imaa.imaa571=' ' END IF
       SELECT ecu03 INTO g_msg FROM ecu_file
                WHERE ecu01=g_imaa.imaa571 AND ecu02=g_imaa.imaa94
    END IF
    DISPLAY g_msg TO ecu03
    #圖形顯示
    LET g_doc.column1 = "imaa01"
    LET g_doc.value1 = g_imaa.imaa01
    CALL cl_get_fld_doc("imaa04")
    CALL i154_show_pic()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi154_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_imaa.imaa00 = 'U' THEN
        #只有申請類別為'新增'時才能做!
        CALL cl_err(g_imaa.imaano,'aim-151',1)
        RETURN
    END IF
    IF g_imaa.imaaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imaa.imaano,'mfg1000',0)
        RETURN
    END IF
    #非開立狀態，不可異動！
   #TQC-750007-----mod----str---
   #IF g_imaa.imaa1010!='0' THEN CALL cl_err('','atm-046',1) RETURN END IF 
   #狀況=>R:送簽退回,W:抽單 也要可以修改
    IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN CALL cl_err('','atm-046',1) RETURN END IF 
   #TQC-750007-----mod----end---
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imaa01_t = g_imaa.imaa01
    LET g_imaano_t = g_imaa.imaano
    LET g_imaa_o.* = g_imaa.*
    BEGIN WORK   
 
    OPEN aimi154_curl USING g_imaa.imaano
    IF STATUS THEN
       CALL cl_err("OPEN aimi154_curl:", STATUS, 1)
       CLOSE aimi154_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi154_curl INTO g_imaa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imaa.imaamodu = g_user                   #修改者
    LET g_imaa.imaadate = g_today                  #修改日期
    CALL aimi154_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi154_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imaa.*=g_imaa_t.*
            CALL aimi154_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_imaa.imaa93[4,4] = 'Y'     #No.MOD-880027 add
       #TQC-750007----add---str--
        IF g_imaa.imaa1010 MATCHES '[RW]' THEN
            LET g_imaa.imaa1010 = '0' #開立
        END IF
       #TQC-750007----add---end--
        UPDATE imaa_file SET imaa_file.* = g_imaa.*    # 更新DB
            WHERE imaano = g_imaano_t               # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","imaa_file",g_imaano_t,"",
                         SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi154_curl
    COMMIT WORK  
    #TQC-750007---add---str--
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
    CALL aimi154_show()                                            
    #TQC-750007---add---end--
END FUNCTION
 
 
{
FUNCTION aimi154_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        sr              RECORD LIKE imaa_file.*,
        sr2             RECORD
                          gen02    LIKE gen_file.gen02
                        END RECORD,
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
    CALL cl_wait()
#   LET l_name = 'aimi154.out'
    CALL cl_outnam('aimi154') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT imaa_file.*,gen02 FROM imaa_file,OUTER gen_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              "   AND imaa_file.imaa67 = gen_file.gen01 "
    PREPARE aimi154_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi154_curo                         # CURSOR
        CURSOR FOR aimi154_p1
 
    START REPORT aimi154_rep TO l_name
 
    FOREACH aimi154_curo INTO sr.*,sr2.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT aimi154_rep(sr.*,sr2.*)
    END FOREACH
 
    FINISH REPORT aimi154_rep
 
    CLOSE aimi154_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT aimi154_rep(sr,sr2)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        sr              RECORD LIKE imaa_file.*,
        sr2             RECORD
                          gen02    LIKE gen_file.gen02
                        END RECORD,
        l_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.imaa01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
            PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
            PRINTX name=H3 g_x[44],g_x[45],g_x[46],g_x[47]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            IF sr.imaaacti = 'N' THEN
                PRINTX name=D1 COLUMN g_c[31],'*';
            ELSE
                PRINTX name=D1 COLUMN g_c[31],' ';
            END IF
            PRINTX name=D1 COLUMN g_c[32],sr.imaa01,
                           COLUMN g_c[33],sr.imaa02,
                           COLUMN g_c[34],sr.imaa55,
                           COLUMN g_c[35],cl_numfor(sr.imaa56,35,3),
                           COLUMN g_c[36],cl_numfor(g_imaa.imaa55_fac,36,6),
                           COLUMN g_c[37],cl_numfor(sr.imaa68,37,3)
 
            PRINTX name=D2 COLUMN g_c[38],' ',
                           COLUMN g_c[39],sr.imaa021,
                           COLUMN g_c[40],sr.imaa63,
                           COLUMN g_c[41],cl_numfor(sr.imaa64,41,3),
                           COLUMN g_c[42],cl_numfor(g_imaa.imaa63_fac,42,6),
                           COLUMN g_c[43],cl_numfor(sr.imaa69,43,3)
 
            PRINTX name=D3 COLUMN g_c[44],' ',
                           COLUMN g_c[45],sr.imaa67,
                           COLUMN g_c[46],sr2.gen02,
                           COLUMN g_c[47],sr.imaa57
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
 
FUNCTION i154_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("imaa01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i154_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("imaa01",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i154_show_pic()
     SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano
     IF g_imaa.imaa1010 MATCHES '[12]' THEN 
         LET g_chr1='Y' 
         LET g_chr2='Y' 
     ELSE 
         LET g_chr1='N' 
         LET g_chr2='N' 
     END IF
     CALL cl_set_field_pic(g_chr1,g_chr2,"","","",g_imaa.imaaacti)
# Memo        	: ps_confirm 確認碼, ps_approve 核准碼, ps_post 過帳碼
#               : ps_close 結案碼, ps_void 作廢碼, ps_valid 有效碼
END FUNCTION

#FUN-BB0083---add---str
FUNCTION i154_imaa56_check()
#imaa56 的單位 imaa55
   IF NOT cl_null(g_imaa.imaa55) AND NOT cl_null(g_imaa.imaa56) THEN
      IF cl_null(g_imaa_t.imaa56) OR cl_null(g_imaa55_t) OR g_imaa_t.imaa56 != g_imaa.imaa56 OR g_imaa55_t != g_imaa.imaa55 THEN 
         LET g_imaa.imaa56=s_digqty(g_imaa.imaa56, g_imaa.imaa55)
         DISPLAY BY NAME g_imaa.imaa56  
      END IF  
   END IF
   IF g_imaa.imaa56 IS NULL OR g_imaa.imaa56 = ' ' OR g_imaa.imaa56 < 0 THEN
      CALL cl_err(g_imaa.imaa56,'mfg0013',0)
      LET g_imaa.imaa56 = g_imaa_o.imaa56
      DISPLAY BY NAME g_imaa.imaa56
      RETURN FALSE
   END IF
   LET g_imaa_o.imaa56 = g_imaa.imaa56
   
RETURN TRUE
END FUNCTION

FUNCTION i154_imaa561_check()
#imaa561 的單位 imaa55
   IF NOT cl_null(g_imaa.imaa55) AND NOT cl_null(g_imaa.imaa561) THEN
      IF cl_null(g_imaa_t.imaa561) OR cl_null(g_imaa55_t) OR g_imaa_t.imaa561 != g_imaa.imaa561 OR g_imaa55_t != g_imaa.imaa55 THEN 
         LET g_imaa.imaa561=s_digqty(g_imaa.imaa561, g_imaa.imaa55)
         DISPLAY BY NAME g_imaa.imaa561  
      END IF  
   END IF
   IF  g_imaa.imaa561 >1 AND g_imaa.imaa56 >0 THEN
       IF (g_imaa.imaa56 mod g_imaa.imaa561) != 0 THEN
           CALL aimi154_size()
       END IF
   END IF
   IF g_imaa.imaa561 IS NULL OR g_imaa.imaa561 = ' ' OR g_imaa.imaa561 < 0 THEN 
      CALL cl_err(g_imaa.imaa561,'mfg0013',0)
      LET g_imaa.imaa561 = g_imaa_o.imaa561
      DISPLAY BY NAME g_imaa.imaa561
      RETURN FALSE
   END IF
   LET g_imaa_o.imaa561 = g_imaa.imaa561
   
RETURN TRUE
END FUNCTION

FUNCTION i154_imaa64_check()
#imaa64 的單位 imaa63
   IF NOT cl_null(g_imaa.imaa63) AND NOT cl_null(g_imaa.imaa64) THEN
      IF cl_null(g_imaa_t.imaa64) OR cl_null(g_imaa63_t) OR g_imaa_t.imaa64 != g_imaa.imaa64 OR g_imaa63_t != g_imaa.imaa63 THEN 
         LET g_imaa.imaa64=s_digqty(g_imaa.imaa64, g_imaa.imaa63)
         DISPLAY BY NAME g_imaa.imaa64  
      END IF  
   END IF
   IF g_imaa.imaa64 IS NULL OR g_imaa.imaa64 = ' ' OR g_imaa.imaa64 < 0 THEN 
      CALL cl_err(g_imaa.imaa64,'mfg0013',0)
      LET g_imaa.imaa64 = g_imaa_o.imaa64
      DISPLAY BY NAME g_imaa.imaa64
      RETURN FALSE
   END IF
   LET g_imaa_o.imaa64 = g_imaa.imaa64

RETURN TRUE 
END FUNCTION

FUNCTION i154_imaa641_check()
DEFINE l_direct LIKE type_file.chr1 
#imaa641 的單位 imaa63
   IF NOT cl_null(g_imaa.imaa63) AND NOT cl_null(g_imaa.imaa641) THEN
      IF cl_null(g_imaa_t.imaa641) OR cl_null(g_imaa63_t) OR g_imaa_t.imaa641 != g_imaa.imaa641 OR g_imaa63_t != g_imaa.imaa63 THEN 
         LET g_imaa.imaa641=s_digqty(g_imaa.imaa641, g_imaa.imaa63)
         DISPLAY BY NAME g_imaa.imaa641  
      END IF  
   END IF
   IF g_imaa.imaa641 IS NULL OR g_imaa.imaa641 = ' ' OR g_imaa.imaa641 < 0 THEN 
      CALL cl_err(g_imaa.imaa641,'mfg0013',0)
      LET g_imaa.imaa641 = g_imaa_o.imaa641
      RETURN "imaa641"
   END IF
   IF g_imaa.imaa64 >1 AND g_imaa.imaa641 >0 THEN
      IF (g_imaa.imaa641 mod g_imaa.imaa64) != 0 THEN
          CALL aimi154_size1()
      END IF
      IF g_imaa.imaa641 mod g_imaa.imaa64 <> 0 THEN
         CALL cl_err('','aim-402',0)
         RETURN "imaa64"
      END IF
   END IF
   LET g_imaa_o.imaa641 = g_imaa.imaa641
   LET l_direct = 'D'
   
RETURN ''  
END FUNCTION
   
#FUN-BB0083---add---end

