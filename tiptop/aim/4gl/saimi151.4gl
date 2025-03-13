# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimi151.4gl
# Descriptions...: 料件申請資料維護作業-庫存資料
# Date & Author..: No.FUN-670033 06/08/30 By Mandy
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750007 07/05/03 By Mandy #狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B30009 11/03/02 By destiny 新增時orig,oriu未顯示
# Modify.........: No:FUN-BB0083 11/12/01 By xujing 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-CB0052 12/11/19 By xianghui 發票倉庫控管改善

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
         g_imaa       RECORD LIKE imaa_file.*,
         g_imb        RECORD LIKE imb_file.*,
         g_imaa_t     RECORD LIKE imaa_file.*,
         g_imaa_o     RECORD LIKE imaa_file.*,
         g_imaa01_t          LIKE imaa_file.imaa01,
         g_imaano_t          LIKE imaa_file.imaano,
         g_d2               LIKE imaa_file.imaa26,
         g_s                LIKE type_file.chr1,     #料件處理狀況  #No.FUN-690026 VARCHAR(1)
         g_sw               LIKE type_file.num5,     #單位是否可轉換  #No.FUN-690026 SMALLINT
         g_wc,g_sql         STRING, 
         g_argv1            LIKE imaa_file.imaano,
         l_azp03            LIKE azp_file.azp03,
         l_dbs              LIKE azp_file.azp03,
         l_zx07             LIKE zx_file.zx07,
         l_zx08             LIKE zx_file.zx08  
 
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask             LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr1                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr2                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr3                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_imaa25_t            LIKE imaa_file.imaa25  #FUN-BB0083 add
DEFINE g_imaa63_t            LIKE imaa_file.imaa63  #FUN-BB0083 add
 
FUNCTION aimi151(p_argv1)
    DEFINE p_argv1         LIKE imaa_file.imaano

    WHENEVER ERROR CALL cl_err_msg_log
 
    INITIALIZE g_imaa.* TO NULL
    INITIALIZE g_imaa_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imaa_file WHERE imaano = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi151_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_argv1 = p_argv1
 
    OPEN WINDOW aimi151_w WITH FORM "aim/42f/aimi151"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    SELECT zx07,zx08,azp03 INTO l_zx07,l_zx08,l_dbs FROM zx_file,azp_file
      WHERE zx01 = g_user AND azp01 = zx08              #MOD-530276
    IF SQLCA.sqlcode THEN LET l_zx07 = 'N' END IF
 
    IF NOT cl_null(g_argv1) THEN
       CALL aimi151_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi151_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi151_w
END FUNCTION
 
FUNCTION aimi151_curs()
 
    CLEAR FORM
    IF cl_null(g_argv1) THEN
    INITIALIZE g_imaa.* TO NULL   #FUN-640213 add
     
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
         imaa00  ,imaano     ,imaa01  ,imaa02  ,imaa021 ,
         imaa08  ,imaa25     ,imaa03  ,imaa1010,imaa92  ,
         imaa07  ,imaa15     ,imaa70  ,imaa23  ,imaa35  ,
         imaa36  ,imaa71     ,imaa271 ,imaa27  ,imaa28  ,
         imaa63  ,imaa63_fac ,imaa64  ,imaa641 ,
         imaauser,imaagrup   ,imaamodu,imaadate,imaaacti
 
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
 
               WHEN INFIELD(imaa23) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imaa.imaa23
                 #CALL cl_create_qry() RETURNING g_imaa.imaa23
                 #DISPLAY BY NAME g_imaa.imaa23
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa23
                  CALL aimi151_peo(g_imaa.imaa23,'d')
                  NEXT FIELD imaa23
               WHEN INFIELD(imaa25) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imaa.imaa25
                 #CALL cl_create_qry() RETURNING g_imaa.imaa25
                 #DISPLAY BY NAME g_imaa.imaa25
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa25
                  NEXT FIELD imaa25
               WHEN INFIELD (imaa35) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imd"
                 LET g_qryparam.state = "c"
                #LET g_qryparam.default1 = g_imaa.imaa35,"A"
                  LET g_qryparam.default1 = g_imaa.imaa35 #MOD-4A0213
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING g_imaa.imaa35
                 #DISPLAY BY NAME g_imaa.imaa35
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa35
                  NEXT FIELD imaa35
               WHEN INFIELD (imaa36) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ime"
                 LET g_qryparam.state = "c"
                 #LET g_qryparam.default1 = g_imaa.imaa36,g_imaa.imaa35,"A" #MOD-4A0063
                 #CALL cl_create_qry() RETURNING g_imaa.imaa36
                 #DISPLAY BY NAME g_imaa.imaa36
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa36
                  NEXT FIELD imaa36
               WHEN INFIELD(imaa63)                       #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imaa.imaa63
                 #CALL cl_create_qry() RETURNING g_imaa.imaa63
                 #DISPLAY BY NAME g_imaa.imaa63
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa63
                  NEXT FIELD imaa63
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
    LET g_s=NULL
    INPUT g_s   WITHOUT DEFAULTS FROM s
        AFTER FIELD s  #資料處理狀況
            IF g_s NOT MATCHES '[YN]' THEN
               NEXT FIELD s
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
    END INPUT
    IF INT_FLAG THEN RETURN END IF
    IF g_s IS NOT NULL THEN
       LET g_wc=g_wc CLIPPED," AND imaa93[1,1] matches '",g_s,"' "
    END IF
  ELSE
      LET g_wc = " imaano = '",g_argv1,"'"
  END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imaauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imaagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imaagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('maauser', 'maagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT imaano FROM imaa_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY imaano"
    PREPARE aimi151_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE aimi151_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi151_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM imaa_file WHERE ",g_wc CLIPPED
    PREPARE aimi151_precount FROM g_sql
    DECLARE aimi151_count CURSOR FOR aimi151_precount
END FUNCTION
 
FUNCTION aimi151_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi151_q()
            END IF
        ON ACTION next
            CALL aimi151_fetch('N')
        ON ACTION previous
            CALL aimi151_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi151_u()
            END IF
 
       #ON ACTION output
       #    LET g_action_choice="output"
       #    IF cl_chk_act_auth()
       #      THEN #CALL aimi151_out()
       #    END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
           CALL i151_show_pic() #圖形顯示
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL aimi151_fetch('/')
        ON ACTION first
            CALL aimi151_fetch('F')
        ON ACTION last
            CALL aimi151_fetch('L')
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE aimi151_cs
END FUNCTION
 
FUNCTION aimi151_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  	#是否必要欄位有輸入  #No.FUN-690026 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(80)
        l_gen02         LIKE gen_file.gen02,
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_case          STRING                  #FUN-BB0083
    DEFINE l_imd10      LIKE imd_file.imd10     #FUN-CB0052
 
    IF s_shut(0) THEN RETURN END IF
    DISPLAY BY NAME g_imaa.imaauser,g_imaa.imaagrup,
        g_imaa.imaadate, g_imaa.imaaacti,
        g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
    LET g_d2=g_imaa.imaa262-g_imaa.imaa26
    DISPLAY g_d2 TO FORMONLY.d2
    DISPLAY g_s TO FORMONLY.s
    INPUT BY NAME
     g_imaa.imaa00  ,g_imaa.imaano     ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa021 ,
     g_imaa.imaa08  ,g_imaa.imaa25     ,g_imaa.imaa03  ,g_imaa.imaa1010,g_imaa.imaa92  ,
     g_imaa.imaa07  ,g_imaa.imaa15     ,g_imaa.imaa70  ,g_imaa.imaa23  ,g_imaa.imaa35  ,
     g_imaa.imaa36  ,g_imaa.imaa71     ,g_imaa.imaa271 ,g_imaa.imaa27  ,g_imaa.imaa28  ,
     g_imaa.imaa63  ,g_imaa.imaa63_fac ,g_imaa.imaa64  ,g_imaa.imaa641 ,
     g_imaa.imaauser,g_imaa.imaagrup   ,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti
    
        WITHOUT DEFAULTS
 
        BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL i151_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
             #FUN-BB0083---add---str
             IF p_cmd = 'u' THEN
                LET g_imaa25_t = g_imaa.imaa25 
                LET g_imaa63_t = g_imaa.imaa63  
             END IF
             IF p_cmd = 'a' THEN
                LET g_imaa25_t = NULL
                LET g_imaa63_t = NULL
             END IF
             #FUN-BB0083---add---end
      
        AFTER FIELD imaa07  #ABC碼
            IF g_imaa.imaa07 NOT MATCHES "[ABC]" THEN #genero
               CALL cl_err(g_imaa.imaa07,'mfg1002',0)
               LET g_imaa.imaa07 = g_imaa_o.imaa07
               DISPLAY BY NAME g_imaa.imaa07
               NEXT FIELD imaa07
            END IF
            LET g_imaa_o.imaa07 = g_imaa.imaa07
 
        AFTER FIELD imaa15  #保稅料件
            IF g_imaa.imaa15 NOT MATCHES "[YN]" THEN #genero
               CALL cl_err(g_imaa.imaa15,'mfg1002',0)
               LET g_imaa.imaa15 = g_imaa_o.imaa15
               DISPLAY BY NAME g_imaa.imaa15
               NEXT FIELD imaa15
            END IF
            LET g_imaa_o.imaa15 = g_imaa.imaa15
 
#@@@@@可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#@@@@@                 2.使用製程(sma54 = 'y')
        AFTER FIELD imaa70  #消耗料件
           #IF g_imaa.imaa70 NOT MATCHES "[YN]" OR g_imaa.imaa70 IS NULL THEN
            IF g_imaa.imaa70 NOT MATCHES "[YN]" THEN #genero
               CALL cl_err(g_imaa.imaa70,'mfg1002',0)
               LET g_imaa.imaa70 = g_imaa_o.imaa70
               DISPLAY BY NAME g_imaa.imaa70
               NEXT FIELD imaa70
            END IF
            IF (g_imaa_o.imaa70 IS NULL) OR (g_imaa_t.imaa70 IS NULL)
                  OR (g_imaa.imaa70 != g_imaa_o.imaa70)
              THEN IF g_imaa.imaa70 NOT MATCHES "[YN]" THEN #genero
                                   #OR g_imaa.imaa70 IS NULL THEN
                        CALL cl_err(g_imaa.imaa70,'mfg1002',0)
                        LET g_imaa.imaa70 = g_imaa_o.imaa70
                        DISPLAY BY NAME g_imaa.imaa70
                        NEXT FIELD imaa70
                    END IF
            END IF
            LET g_imaa_o.imaa70 = g_imaa.imaa70
 
        AFTER FIELD imaa25            #庫存單位
            IF  NOT cl_null(g_imaa.imaa25) THEN
                IF (g_imaa_o.imaa25 IS NULL) OR (g_imaa_o.imaa25 != g_imaa.imaa25)
                     THEN SELECT gfe01 FROM gfe_file
                           WHERE gfe01=g_imaa.imaa25 AND gfeacti in ('y','Y')
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("sel","gfe_file",g_imaa.imaa25,"",
                                     "mfg1200","","",1)  #No.FUN-660156
                        LET g_imaa.imaa25 = g_imaa_o.imaa25
                        DISPLAY BY NAME g_imaa.imaa25
                        NEXT FIELD imaa25
                     END IF
                 END IF
            END IF
            LET g_imaa_o.imaa25 = g_imaa.imaa25
           #FUN-BB0083---add---str
               LET l_case = ''
               IF NOT i151_imaa27_check() THEN 
                  LET l_case = "imaa27"
               END IF
               IF NOT i151_imaa271_check() THEN
                   LET l_case = "imaa271"
               END IF
               LET g_imaa25_t = g_imaa.imaa25
               CASE l_case
                  WHEN "imaa271"
                     NEXT FIELD imaa271
                  WHEN "imaa27"
                     NEXT FIELD imaa27
                   OTHERWISE EXIT CASE
               END CASE
           #FUN-BB0083---add---end
 
        AFTER FIELD imaa23            #倉管員
            IF g_imaa.imaa23 IS NOT NULL THEN
               IF (g_imaa_o.imaa23 IS NULL) or (g_imaa.imaa23 != g_imaa_o.imaa23) THEN
                  CALL aimi151_peo(g_imaa.imaa23,'a')
                  IF g_chr = 'E' THEN
                     CALL cl_err(g_imaa.imaa23,'mfg3096',0)
                     LET g_imaa.imaa23 = g_imaa_o.imaa23
                     DISPLAY BY NAME g_imaa.imaa23
                     NEXT FIELD imaa23
                  END IF
               END IF
            ELSE LET l_gen02 = NULL
                 DISPLAY l_gen02 TO gen02
            END IF
            LET g_imaa_o.imaa23 = g_imaa.imaa23
 
        #倉庫別與儲位別在 AFTER INPUT 時,才判斷是否為NULL
        #因為若此倉庫無儲位時,必須讓使用者可以回到倉庫別輸入,而不一定得
        #打一個無用的儲位
        AFTER FIELD imaa35  #倉庫別
        IF g_imaa.imaa35 IS NULL OR g_imaa.imaa35 = ' ' THEN
           LET  g_imaa.imaa35  = ' '
           LET g_imaa.imaa36 = ' '
           DISPLAY BY NAME g_imaa.imaa36
        ELSE
            IF g_imaa.imaa35 IS NOT NULL THEN
               IF (g_imaa_o.imaa35 IS NULL OR g_imaa_o.imaa35 = ' ')
                  OR (g_imaa.imaa35 != g_imaa_o.imaa35)
                   THEN
                      IF NOT s_stkchk(g_imaa.imaa35,'A') THEN
                          CALL cl_err(g_imaa.imaa35,'mfg1100',0)
                          LET g_imaa.imaa35 = g_imaa_o.imaa35
                          DISPLAY BY NAME g_imaa.imaa35
                          NEXT FIELD imaa35
                      END IF
               END IF
               #FUN-CB0052--add--str--
               SELECT imd10 INTO l_imd10 FROM imd_file
                WHERE imd01 = g_imaa.imaa35 AND imdacti='Y'
               IF l_imd10 MATCHES '[Ii]' THEN
                  CALL cl_err(l_imd10,'axm-693',0)
                  NEXT FIELD imaa35
               END IF
               #FUN-CB0052--add--end--
            END IF
            LET g_imaa_o.imaa35 = g_imaa.imaa35
          END IF
 
        AFTER FIELD imaa36  #儲位別
{&}     IF g_imaa.imaa36 IS NULL THEN LET  g_imaa.imaa36  = ' '  END IF
            IF  g_imaa.imaa36 IS NOT NULL and g_imaa.imaa36 !=' '  THEN
               IF (g_imaa_o.imaa36 IS NULL OR g_imaa_o.imaa36 = ' ')
                  OR (g_imaa.imaa36 != g_imaa_o.imaa36)
                     THEN
                        CALL s_prechk(g_imaa.imaa01,g_imaa.imaa35,g_imaa.imaa36)
                                            RETURNING g_cnt,g_chr
                        IF NOT g_cnt THEN
                            CALL cl_err(g_imaa.imaa36,'mfg1102',0)
                            NEXT FIELD imaa35
                        END IF
               END IF
            END IF
           
            LET g_imaa_o.imaa36 = g_imaa.imaa36
 
        AFTER FIELD imaa71 #儲存有效天數
           #IF g_imaa.imaa71 IS NULL OR g_imaa.imaa71 = ' ' OR
            IF g_imaa.imaa71 < 0 #genero
               THEN CALL cl_err(g_imaa.imaa71,'mfg0013',0)
                    LET g_imaa.imaa71 = g_imaa_o.imaa71
                    DISPLAY BY NAME g_imaa.imaa71
                    NEXT FIELD imaa71
            END IF
            LET g_imaa_o.imaa71 = g_imaa.imaa71
 
        AFTER FIELD imaa271
           IF NOT i151_imaa271_check() THEN NEXT FIELD imaa271 END IF #FUN-BB0083 add
            #FUN-BB0083---mark---str
            #IF g_imaa.imaa271 < 0 #genero
            #THEN
            #   CALL cl_err(g_imaa.imaa271,'mfg0013',0)
            #   LET g_imaa.imaa271 = g_imaa_o.imaa271
            #   DISPLAY BY NAME g_imaa.imaa271
            #   NEXT FIELD imaa271
            #END IF
            #FUN-BB0083---mark---end
 
        AFTER FIELD imaa27
           IF NOT i151_imaa27_check() THEN NEXT FIELD imaa27 END IF #FUN-BB0083 add
            #FUN-BB0083---mark---str
            #IF g_imaa.imaa27 < 0 #genero
            #   THEN  CALL cl_err(g_imaa.imaa27,'mfg0013',0)
            #         LET g_imaa.imaa27 = g_imaa_o.imaa27
            #         DISPLAY BY NAME g_imaa.imaa27
            #         NEXT FIELD imaa27
            #END IF
            #LET g_imaa_o.imaa27 = g_imaa.imaa27
            #FUN-BB0083---mark---end
 
        AFTER FIELD imaa28
            IF g_imaa.imaa28 < 0 #genero
               THEN CALL cl_err(g_imaa.imaa28,'mfg0013',0)
                     LET g_imaa.imaa28 = g_imaa_o.imaa28
                     DISPLAY BY NAME g_imaa.imaa28
                    NEXT FIELD imaa28
            END IF
            LET g_imaa_o.imaa28 = g_imaa.imaa28
 
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
                    DISPLAY BY NAME g_imaa.imaa63
            END IF
            IF  g_imaa.imaa63 IS NULL
              THEN LET g_imaa.imaa63 = g_imaa_o.imaa63
                   DISPLAY BY NAME g_imaa.imaa63
                 # NEXT FIELD imaa63 #genero
            END IF
            IF (g_imaa.imaa63 != g_imaa_o.imaa63) #genero
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
               IF NOT i151_imaa64_check() THEN
                  LET l_case = "imaa64"
               END IF
               IF NOT i151_imaa641_check() THEN
                  LET l_case = "imaa641"
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
           #IF g_imaa.imaa63_fac IS NULL OR g_imaa.imaa63_fac = ' '
            IF g_imaa.imaa63_fac <= 0 THEN #genero
                CALL cl_err(g_imaa.imaa63_fac,'mfg1322',0)
                LET g_imaa.imaa63_fac = g_imaa_o.imaa63_fac
                DISPLAY BY NAME g_imaa.imaa63_fac
                NEXT FIELD imaa63_fac
            END IF
            LET g_imaa_o.imaa63_fac = g_imaa.imaa63_fac
 
        AFTER FIELD imaa64          #發料單位批數
           IF NOT i151_imaa64_check() THEN NEXT FIELD imaa64 END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str
           ##IF g_imaa.imaa64 IS NULL OR g_imaa.imaa64 = ' '
           #  IF g_imaa.imaa64 < 0 #genero
           #     THEN CALL cl_err(g_imaa.imaa64,'mfg0013',0)
           #        # CALL cl_err(g_imaa.imaa64,'mfg1322',0)
           #          LET g_imaa.imaa64 = g_imaa_o.imaa64
           #          DISPLAY BY NAME g_imaa.imaa64
           #          NEXT FIELD imaa64
           #  END IF
           # LET g_imaa_o.imaa64 = g_imaa.imaa64
           #FUN-BB0083---mark---end
 
        AFTER FIELD imaa641          #最少發料數量
           IF NOT i151_imaa641_check() THEN NEXT FIELD imaa641 END IF #FUN-BB0083 add
             #FUN-BB0083---mark---str
             #IF g_imaa.imaa641 IS NULL OR g_imaa.imaa641 = ' '
             #   THEN LET g_imaa.imaa641=0
             #END IF
             #IF  g_imaa.imaa641 < 0
             #   THEN CALL cl_err(g_imaa.imaa641,'mfg0013',0)
             #        LET g_imaa.imaa641 = g_imaa_o.imaa641
             #        DISPLAY BY NAME g_imaa.imaa641
             #        NEXT FIELD imaa641
             #END IF
             #IF g_imaa.imaa64 >1 AND  g_imaa.imaa641 >0
             #   THEN
             #       IF (g_imaa.imaa641 mod g_imaa.imaa64) != 0 THEN
             #                 CALL aimi151_size()
             #       END IF
             #END IF
             #FUN-BB0083---mark---end
 
            LET g_imaa_o.imaa641 = g_imaa.imaa641
 
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
            IF g_imaa.imaa15 NOT MATCHES "[YN]" OR g_imaa.imaa15 IS NULL THEN
               LET l_flag='Y'   #保稅料件
               DISPLAY BY NAME g_imaa.imaa14
            END IF
            IF g_imaa.imaa25 IS NULL THEN  #庫存單位
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa25
            END IF
            IF g_imaa.imaa271 IS NULL THEN
               LET l_flag='Y'  #最高儲存數量
               DISPLAY BY NAME g_imaa.imaa271
            END IF
            IF g_imaa.imaa27 IS NULL THEN
               LET l_flag='Y'  #安全存量
               DISPLAY BY NAME g_imaa.imaa27
            END IF
            IF g_imaa.imaa28 IS NULL THEN
               LET l_flag='Y'  #安全期間
               DISPLAY BY NAME g_imaa.imaa28
            END IF
            IF g_imaa.imaa63 IS NULL THEN  #發料單位
               LET g_imaa.imaa63=g_imaa.imaa25
               DISPLAY BY NAME g_imaa.imaa63
               #FUN-BB0083---add---str
               LET g_imaa.imaa64 = s_digqty(g_imaa.imaa64,g_imaa.imaa63)
               LET g_imaa.imaa641= s_digqty(g_imaa.imaa641,g_imaa.imaa63)
              #FUN-BB0083---add---end
            END IF
            IF g_imaa.imaa63_fac IS NULL OR g_imaa.imaa63_fac <=0  THEN  #發料批量
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
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imaa15
            END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(imaa23) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_imaa.imaa23
                 CALL cl_create_qry() RETURNING g_imaa.imaa23
                 DISPLAY BY NAME g_imaa.imaa23
                 CALL aimi151_peo(g_imaa.imaa23,'d')
                 NEXT FIELD imaa23
               WHEN INFIELD(imaa25) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imaa.imaa25
                 CALL cl_create_qry() RETURNING g_imaa.imaa25
                 DISPLAY BY NAME g_imaa.imaa25
                 NEXT FIELD imaa25
               WHEN INFIELD (imaa35) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imd"
                 LET g_qryparam.default1 = g_imaa.imaa35 
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 
                 CALL cl_create_qry() RETURNING g_imaa.imaa35
                 DISPLAY BY NAME g_imaa.imaa35
                 NEXT FIELD imaa35
               WHEN INFIELD (imaa36) #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ime"
                 LET g_qryparam.default1 = g_imaa.imaa36 
                 LET g_qryparam.arg1     = g_imaa.imaa35 #倉庫編號 
                 LET g_qryparam.arg2     = 'SW'          #倉庫類別 
                 CALL cl_create_qry() RETURNING g_imaa.imaa36
                 DISPLAY BY NAME g_imaa.imaa36
                 NEXT FIELD imaa36
               WHEN INFIELD(imaa63)                       #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imaa.imaa63
                 CALL cl_create_qry() RETURNING g_imaa.imaa63
                 DISPLAY BY NAME g_imaa.imaa63
                 NEXT FIELD imaa63
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION create_unit
           CALL cl_cmdrun("aooi151 ")
 
        ON ACTION create_warehouse
           LET l_cmd = 'aimi200'
           CALL cl_cmdrun(l_cmd)
 
        ON ACTION create_location
           LET l_cmd = "aimi201 '",g_imaa.imaa35,"'" #BugNo:6598
           CALL cl_cmdrun(l_cmd)
 
        ON ACTION unit_conversion
           CALL cl_cmdrun("aooi102 ")
 
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
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
    END INPUT
END FUNCTION
 
#--->1992/10/21 by pin add
FUNCTION aimi151_size()  #檢查發料數量是否為發料批量之倍數及建議發料數量
DEFINE
        l_count           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_imaa641         LIKE imaa_file.imaa641
      LET l_count = g_imaa.imaa641 MOD g_imaa.imaa64
      IF l_count != 0 THEN
        LET l_count = g_imaa.imaa641/ g_imaa.imaa64
        LET l_imaa641 = ( l_count + 1 ) * g_imaa.imaa64
        CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
        WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg CLIPPED,'(',l_imaa641,')',':' FOR g_chr
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
 
FUNCTION aimi151_peo(p_key,p_cmd)    #人員
    DEFINE p_key     LIKE gen_file.gen01,
           p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_gen02=NULL
        LET g_chr = 'E'
    ELSE SELECT gen02,genacti INTO l_gen02,l_genacti
           FROM gen_file
               WHERE gen01 = p_key
            IF SQLCA.sqlcode THEN
                LET g_chr = 'E'
                LET l_gen02 = NULL
            ELSE
                IF l_genacti matches'[Nn]' THEN
                    LET g_chr = 'E'
                END IF
            END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_gen02 TO gen02
  END IF
END FUNCTION
 
FUNCTION aimi151_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi151_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi151_count
    FETCH aimi151_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi151_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        INITIALIZE g_imaa.* TO NULL
    ELSE
        CALL aimi151_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi151_fetch(p_flimaa)
    DEFINE
        p_flimaa          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimaa
        WHEN 'N' FETCH NEXT     aimi151_cs INTO g_imaa.imaano
        WHEN 'P' FETCH PREVIOUS aimi151_cs INTO g_imaa.imaano
        WHEN 'F' FETCH FIRST    aimi151_cs INTO g_imaa.imaano
        WHEN 'L' FETCH LAST     aimi151_cs INTO g_imaa.imaano
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
            FETCH ABSOLUTE g_jump aimi151_cs INTO g_imaa.imaano
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
        CALL aimi151_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi151_show()
    LET g_imaa_t.* = g_imaa.*
    LET g_d2=g_imaa.imaa262-g_imaa.imaa26
    LET g_s=g_imaa.imaa93[1,1]
    DISPLAY g_d2 TO FORMONLY.d2
    DISPLAY g_s TO FORMONLY.s
    DISPLAY BY NAME
     g_imaa.imaa00  ,g_imaa.imaano     ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa021 ,
     g_imaa.imaa08  ,g_imaa.imaa25     ,g_imaa.imaa03  ,g_imaa.imaa1010,g_imaa.imaa92  ,
     g_imaa.imaa07  ,g_imaa.imaa15     ,g_imaa.imaa70  ,g_imaa.imaa23  ,g_imaa.imaa35  ,
     g_imaa.imaa36  ,g_imaa.imaa71     ,g_imaa.imaa271 ,g_imaa.imaa27  ,g_imaa.imaa28  ,
     g_imaa.imaa63  ,g_imaa.imaa63_fac ,g_imaa.imaa64  ,g_imaa.imaa641 ,
     g_imaa.imaauser,g_imaa.imaagrup   ,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti,
     g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
        CALL aimi151_peo(g_imaa.imaa23,'d')
        #圖形顯示
        LET g_doc.column1 = "imaa01"
        LET g_doc.value1 = g_imaa.imaa01
        CALL cl_get_fld_doc("imaa04")
        CALL i151_show_pic() #圖形顯示
        CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION aimi151_u()
 
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
 
    OPEN aimi151_curl USING g_imaa.imaano
    IF STATUS THEN
       CALL cl_err("OPEN aimi151_curl:", STATUS, 1)
       CLOSE aimi151_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi151_curl INTO g_imaa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imaa.imaamodu=g_user                     #修改者
    LET g_imaa.imaadate = g_today                  #修改日期
    CALL aimi151_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi151_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imaa.*=g_imaa_t.*
            CALL aimi151_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_imaa.imaa93[1,1] = 'Y'
{&}     IF g_imaa.imaa35 IS NULL THEN LET  g_imaa.imaa35  = ' '  END IF
{&}     IF g_imaa.imaa36 IS NULL THEN LET  g_imaa.imaa36  = ' '  END IF
        #No.B018 010322 by plum
        IF cl_null(g_imaa.imaa25) THEN CONTINUE WHILE END IF
        IF cl_null(g_imaa.imaa63) THEN
           LET g_imaa.imaa63=g_imaa.imaa25
           LET g_imaa.imaa63_fac=1
        END IF
        IF cl_null(g_imaa.imaa26)  THEN LET g_imaa.imaa26=0  END IF
        IF cl_null(g_imaa.imaa261) THEN LET g_imaa.imaa261=0 END IF
        IF cl_null(g_imaa.imaa262) THEN LET g_imaa.imaa262=0 END IF
        IF cl_null(g_imaa.imaa27)  THEN LET g_imaa.imaa27=0  END IF
        IF cl_null(g_imaa.imaa271) THEN LET g_imaa.imaa271=0 END IF
        IF cl_null(g_imaa.imaa28)  THEN LET g_imaa.imaa28=0  END IF
        IF cl_null(g_imaa.imaa64)  THEN LET g_imaa.imaa64=0  END IF
        IF cl_null(g_imaa.imaa641) THEN LET g_imaa.imaa641=0 END IF
       #TQC-750007----add---str--
        IF g_imaa.imaa1010 MATCHES '[RW]' THEN
            LET g_imaa.imaa1010 = '0' #開立
        END IF
       #TQC-750007----add---end--
        UPDATE imaa_file SET imaa_file.* = g_imaa.*    # 更新DB
         WHERE imaano = g_imaano_t                  # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","imaa_file",g_imaano_t,"",
                         SQLCA.sqlcode,"","",1)  
           CONTINUE WHILE
        ELSE 
           #IF g_imaa01_t != g_imaa.imaa01 THEN
           #    UPDATE imb_file SET imb_file.imb01 = g_imaa.imaa01    # 更新DB
           #         WHERE imb01=g_imaa01_t                          # COLAUTH?
           #     IF SQLCA.sqlcode THEN
           #        CALL cl_err3("upd","imb_file",g_imaa01_t,"",
           #                      SQLCA.sqlcode,"","",1)  
           #     END IF
           #END IF
             display 'Y' TO formonly.s
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi151_curl
    COMMIT WORK   #No.+205 mark 拿掉
    #TQC-750007---add---str--
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
    CALL aimi151_show()                                            
    #TQC-750007---add---end--
END FUNCTION
 
 
{
FUNCTION aimi151_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        sr              RECORD LIKE imaa_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
        LET g_wc=" imaa01='",g_imaa.imaa01,"'"
    END IF
    CALL cl_wait()
#   LET l_name = 'aimi151.out'
    CALL cl_outnam('aimi151') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM imaa_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE aimi151_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi151_curo                         # CURSOR
        CURSOR FOR aimi151_p1
 
    START REPORT aimi151_rep TO l_name
 
    FOREACH aimi151_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT aimi151_rep(sr.*)
    END FOREACH
 
    FINISH REPORT aimi151_rep
 
    CLOSE aimi151_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
REPORT aimi151_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        sr              RECORD LIKE imaa_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
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
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINTX name=H2 g_x[37],g_x[38]
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
                           COLUMN g_c[34],sr.imaa05,
                           COLUMN g_c[35],sr.imaa08,
                           COLUMN g_c[36],sr.imaa25
            PRINTX name=D2 COLUMN g_c[37],' ',
                           COLUMN g_c[38],sr.imaa021
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
 
FUNCTION i151_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  DEFINE l_errno STRING
    IF p_cmd='a' THEN
      CALL cl_set_comp_entry("imaa25",TRUE)
    END IF
 
    IF p_cmd='u' THEN
        CALL s_chkitmdel(g_imaa.imaa01) RETURNING l_errno
        CALL cl_set_comp_entry("imaa25",cl_null(l_errno))  #有errmsg表示庫存單位不可修改
    END IF
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
        CALL cl_set_comp_entry("imaa01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i151_show_pic()
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
#TQC-790177
#FUN-BB0083---add---str
FUNCTION i151_imaa27_check()
#imaa27 的單位 imaa25
   IF NOT cl_null(g_imaa.imaa25) AND NOT cl_null(g_imaa.imaa27) THEN
      IF cl_null(g_imaa_t.imaa27) OR cl_null(g_imaa25_t) OR g_imaa_t.imaa27 != g_imaa.imaa27 OR g_imaa25_t != g_imaa.imaa25 THEN 
         LET g_imaa.imaa27=s_digqty(g_imaa.imaa27, g_imaa.imaa25)
         DISPLAY BY NAME g_imaa.imaa27  
      END IF  
   END IF
   IF g_imaa.imaa27 < 0 THEN 
      CALL cl_err(g_imaa.imaa27,'mfg0013',0)
      LET g_imaa.imaa27 = g_imaa_o.imaa27
      DISPLAY BY NAME g_imaa.imaa27
      RETURN FALSE
   END IF
   LET g_imaa_o.imaa27 = g_imaa.imaa27  
RETURN TRUE
END FUNCTION

FUNCTION i151_imaa271_check()
#imaa271 的單位 imaa25
   IF NOT cl_null(g_imaa.imaa25) AND NOT cl_null(g_imaa.imaa271) THEN
      IF cl_null(g_imaa_t.imaa271) OR cl_null(g_imaa25_t) OR g_imaa_t.imaa271 != g_imaa.imaa271 OR g_imaa25_t != g_imaa.imaa25 THEN 
         LET g_imaa.imaa271=s_digqty(g_imaa.imaa271, g_imaa.imaa25)
         DISPLAY BY NAME g_imaa.imaa271  
      END IF  
   END IF
   IF g_imaa.imaa271 < 0 THEN
      CALL cl_err(g_imaa.imaa271,'mfg0013',0)
      LET g_imaa.imaa271 = g_imaa_o.imaa271
      DISPLAY BY NAME g_imaa.imaa271
      RETURN FALSE
   END IF
RETURN TRUE
END FUNCTION
   
FUNCTION i151_imaa64_check()
#imaa64 的單位 imaa63
   IF NOT cl_null(g_imaa.imaa63) AND NOT cl_null(g_imaa.imaa64) THEN
      IF cl_null(g_imaa_t.imaa64) OR cl_null(g_imaa63_t) OR g_imaa_t.imaa64 != g_imaa.imaa64 OR g_imaa63_t != g_imaa.imaa63 THEN 
         LET g_imaa.imaa64=s_digqty(g_imaa.imaa64, g_imaa.imaa63)
         DISPLAY BY NAME g_imaa.imaa64  
      END IF  
   END IF
   IF g_imaa.imaa64 < 0 THEN 
      CALL cl_err(g_imaa.imaa64,'mfg0013',0)
      LET g_imaa.imaa64 = g_imaa_o.imaa64
      DISPLAY BY NAME g_imaa.imaa64
      RETURN FALSE 
   END IF
   LET g_imaa_o.imaa64 = g_imaa.imaa64   
RETURN TRUE
END FUNCTION

FUNCTION i151_imaa641_check()
#imaa641 的單位 imaa63
   IF NOT cl_null(g_imaa.imaa63) AND NOT cl_null(g_imaa.imaa641) THEN
      IF cl_null(g_imaa_t.imaa641) OR cl_null(g_imaa63_t) OR g_imaa_t.imaa641 != g_imaa.imaa641 OR g_imaa63_t != g_imaa.imaa63 THEN 
         LET g_imaa.imaa641=s_digqty(g_imaa.imaa641, g_imaa.imaa63)
         DISPLAY BY NAME g_imaa.imaa641  
      END IF  
   END IF
   IF g_imaa.imaa641 IS NULL OR g_imaa.imaa641 = ' ' THEN 
      LET g_imaa.imaa641=0
   END IF
   IF  g_imaa.imaa641 < 0 THEN 
       CALL cl_err(g_imaa.imaa641,'mfg0013',0)
       LET g_imaa.imaa641 = g_imaa_o.imaa641
       DISPLAY BY NAME g_imaa.imaa641
       RETURN FALSE 
   END IF
   IF g_imaa.imaa64 >1 AND  g_imaa.imaa641 >0 THEN
      IF (g_imaa.imaa641 mod g_imaa.imaa64) != 0 THEN
          CALL aimi151_size()
      END IF
   END IF
   LET g_imaa_o.imaa641 = g_imaa.imaa641
RETURN TRUE   
END FUNCTION
#FUN-BB0083---add---end

