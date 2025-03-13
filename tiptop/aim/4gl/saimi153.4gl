# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: saimi153.4gl
# Descriptions...: 料件申請資料維護作業-採購資料
# Date & Author..: No.FUN-670033 06/08/30 By Mandy
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time改為g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750007 07/05/03 By Mandy #狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: No.MOD-790172 07/09/29 By Pengu 按右邊的[料件單位換算]action 出現無此程式代號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A90118 10/09/17 By Summer imaa52是No Use欄位,程式段應該mark 
# Modify.........: No.TQC-B30009 11/03/02 By destiny 新增時orig,oriu未顯示
# Modify.........: No:FUN-BB0083 11/12/01 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:CHI-C50068 12/11/07 By bart 增加imaa721欄位
# Modify.........: No.CHI-D30005 13/04/09 By Elise 串查apmi600第一個參數g_argv1為廠商代號,第二個g_argv2為執行功能

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
DEFINE
    g_iml01         LIKE iml_file.iml01    #類別代號 (假單頭)
END GLOBALS
 
  DEFINE
    g_argv1             LIKE imaa_file.imaano,
    g_imaa              RECORD LIKE imaa_file.*,
    g_imaa_t            RECORD LIKE imaa_file.*,
    g_imaa_o            RECORD LIKE imaa_file.*,
    g_imaa01_t          LIKE imaa_file.imaa01,
    g_imaano_t          LIKE imaa_file.imaano,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_s                 LIKE type_file.chr1,    #料件處理狀況  #No.FUN-690026 VARCHAR(1)
    g_sta               LIKE ze_file.ze03,      #補貨策略碼的說明 #No.FUN-690026 VARCHAR(10)
    g_flag1             LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc                STRING,
    g_sql               STRING  
 
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_rec_b             LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_geu02             LIKE geu_file.geu02    #No.FUN-630040
DEFINE g_chr1              LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr2              LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr3              LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_imaa44_t          LIKE imaa_file.imaa44  #FUN-BB0083 add
 
FUNCTION aimi153(p_argv1,p_cmd)
  DEFINE  p_cmd         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          p_argv1       LIKE imaa_file.imaano

   WHENEVER ERROR CALL cl_err_msg_log
 
   INITIALIZE g_imaa.* TO NULL
   INITIALIZE g_imaa_t.* TO NULL
 
   LET g_flag1 = p_cmd
   LET g_forupd_sql ="SELECT * FROM imaa_file  WHERE imaano = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aimi153_curl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET g_argv1 = p_argv1
 
   OPEN WINDOW aimi153_w WITH FORM "aim/42f/aimi153"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("imaa908",g_sma.sma116 MATCHES '[123]')
 
   IF g_argv1 IS NOT NULL AND g_argv1 !=' ' THEN
      CALL aimi153_q()
   END IF
 
   WHILE TRUE
      LET g_action_choice=""
 
      CALL aimi153_menu()
 
      IF g_action_choice = "exit" THEN 
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW aimi153_w
END FUNCTION
 
FUNCTION aimi153_curs()
 
   CLEAR FORM
 
   IF g_argv1 IS NULL OR g_argv1 = " " THEN
      
      INITIALIZE g_imaa.* TO NULL   
 
      CONSTRUCT BY NAME g_wc ON 
                               imaa00 ,imaano ,imaa01    ,imaa02  ,imaa021,
                               imaa08 ,imaa25 ,imaa03    ,imaa1010,imaa92 ,
                               imaa43 ,imaa44 ,imaa44_fac,imaa45  ,imaa46 ,
                               imaa51 ,imaa47 ,imaa54    ,imaa908 ,imaa104,
                               imaa531,imaa50 ,imaa48    ,imaa49  ,imaa491,   
                               imaa72 ,imaa721,imaa103,imaa37    ,imaa27  ,imaa38 ,  #CHI-C50068
                               imaa99 ,imaa88 ,imaa89    ,imaa90  ,imaa24 ,
                               imaa100,imaa101,imaa102   ,imaa913 ,imaa914,
                               imaauser,imaagrup   ,imaamodu,imaadate,imaaacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
              #### No.FUN-4A0041
               WHEN INFIELD(imaa01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imaa"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imaa01
                NEXT FIELD imaa01
               ### END  No.FUN-4A0041
 
               WHEN INFIELD(imaa54)                       #供應商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imaa.imaa54
                 #CALL cl_create_qry() RETURNING g_imaa.imaa54
                 #DISPLAY BY NAME g_imaa.imaa54
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa54
                  CALL aimi153_imaa54('d')
                  NEXT FIELD imaa54
               WHEN INFIELD(imaa43)                       #採購員(imaa43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imaa.imaa43
                 #CALL cl_create_qry() RETURNING g_imaa.imaa43
                 #DISPLAY BY NAME g_imaa.imaa43
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa43
                  CALL aimi153_peo(g_imaa.imaa43,'d')
                  NEXT FIELD imaa43
               WHEN INFIELD(imaa44)                       #採購單位(imaa44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imaa.imaa44
                 #CALL cl_create_qry() RETURNING g_imaa.imaa44
                 #DISPLAY BY NAME g_imaa.imaa44
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa44
                  NEXT FIELD imaa44
               WHEN INFIELD(imaa914)   #No.FUN-630040
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imaa914
                 NEXT FIELD imaa914
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
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      LET g_s=NULL
 
      INPUT g_s WITHOUT DEFAULTS FROM s
 
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
 
      MESSAGE ' WAIT '
 
      IF g_s IS NOT NULL THEN
         LET g_wc=g_wc CLIPPED," AND imaa93[3,3] matches '",g_s,"' "
      END IF
   ELSE
      LET g_wc = " imaano = '",g_argv1,"'"
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND imaauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND imaagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND imaagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('maauser', 'maagrup')
   #End:FUN-980030
 
   LET g_sql="SELECT imaano FROM imaa_file ",
             " WHERE ",g_wc CLIPPED, " ORDER BY imaano"
   PREPARE aimi153_prepare FROM g_sql
   DECLARE aimi153_curs SCROLL CURSOR WITH HOLD FOR aimi153_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM imaa_file WHERE ",g_wc CLIPPED
   PREPARE aimi153_precount FROM g_sql
   DECLARE aimi153_count CURSOR FOR aimi153_precount
 
END FUNCTION
 
FUNCTION aimi153_menu()
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi153_q()
            END IF
        ON ACTION next
            CALL aimi153_fetch('N')
        ON ACTION previous
            CALL aimi153_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi153_u()
            END IF
      # #@ON ACTION 料件/供應商查詢
      # ON ACTION qry_item_vender
      # 	LET l_cmd="apmq210 ",g_imaa.imaa01
      #     CALL cl_cmdrun(l_cmd CLIPPED)
      #ON ACTION output
      #     LET g_action_choice="output"
      #     IF cl_chk_act_auth()
      #        THEN #CALL aimi153_out()
      #     END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL aimi153_fetch('/')
        ON ACTION first
            CALL aimi153_fetch('F')
        ON ACTION last
            CALL aimi153_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
           CALL i153_show_pic() #圖形顯示
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         
          CALL cl_about()      
 
            LET g_action_choice = "exit"
          CONTINUE MENU
     
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
    CLOSE aimi153_curs
END FUNCTION
 
FUNCTION aimi153_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_imaa08        LIKE imaa_file.imaa08,
          l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct2       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct3       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct4       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_imaa46        LIKE imaa_file.imaa46,
          l_flag          LIKE type_file.chr1,    #是否必要欄位有輸入  #No.FUN-690026 VARCHAR(1)
          l_case          STRING                  #FUN-BB0083 add
   DEFINE l_cmd           LIKE type_file.chr1000  #CHI-D30005 add
 
   DISPLAY BY NAME g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaadate,g_imaa.imaaacti,
                   g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
   DISPLAY g_s TO FORMONLY.s
 
   INPUT BY NAME 
              g_imaa.imaa00 ,g_imaa.imaano ,g_imaa.imaa01    ,g_imaa.imaa02  ,g_imaa.imaa021,
              g_imaa.imaa08 ,g_imaa.imaa25 ,g_imaa.imaa03    ,g_imaa.imaa1010,g_imaa.imaa92 ,
              g_imaa.imaa43 ,g_imaa.imaa44 ,g_imaa.imaa44_fac,g_imaa.imaa45  ,g_imaa.imaa46 ,
              g_imaa.imaa51 ,g_imaa.imaa47 ,g_imaa.imaa54    ,g_imaa.imaa908 ,g_imaa.imaa104,
              g_imaa.imaa531,g_imaa.imaa50 ,g_imaa.imaa48    ,g_imaa.imaa49  ,g_imaa.imaa491,   
              g_imaa.imaa72 ,g_imaa.imaa721,g_imaa.imaa103,g_imaa.imaa37    ,g_imaa.imaa27  ,g_imaa.imaa38 ,  #CHI-C50068
              g_imaa.imaa99 ,g_imaa.imaa88 ,g_imaa.imaa89    ,g_imaa.imaa90  ,g_imaa.imaa24 ,
              g_imaa.imaa100,g_imaa.imaa101,g_imaa.imaa102   ,g_imaa.imaa913 ,g_imaa.imaa914,
              g_imaa.imaauser, g_imaa.imaagrup, g_imaa.imaamodu,g_imaa.imaadate, g_imaa.imaaacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i153_set_entry(p_cmd)
         CALL i153_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         #FUN-BB0083---add---str
         IF p_cmd = 'u' THEN
            LET g_imaa44_t = g_imaa.imaa44
         END IF
         IF p_cmd = 'a' THEN
            LET g_imaa44_t = NULL
         END IF
         #FUN-BB0083---add---end
 
      BEFORE FIELD imaa37
         CALL i153_set_entry(p_cmd)
 
      AFTER FIELD imaa37  #補貨策略碼
         IF g_imaa.imaa37 NOT MATCHES "[012345]" THEN
            CALL cl_err(g_imaa.imaa37,'mfg1003',0)
            LET g_imaa.imaa37 = g_imaa_o.imaa37
            DISPLAY BY NAME g_imaa.imaa37
            NEXT FIELD imaa37
         END IF
         CALL s_opc(g_imaa.imaa37) RETURNING g_sta
         #來源碼不為採購料件時, 補貨策略碼不可為'0' (再訂購點)
         # 96-07-11
         IF g_imaa.imaa37='0' AND g_imaa.imaa08 NOT MATCHES '[MPVZ]' THEN
            CALL cl_err(g_imaa.imaa37,'mfg3201',0)
            LET g_imaa.imaa37 = g_imaa_o.imaa37
            DISPLAY BY NAME g_imaa.imaa37
            NEXT FIELD imaa37
         END IF
         LET g_imaa_o.imaa37 = g_imaa.imaa37
         CALL i153_set_no_entry(p_cmd)
 
      AFTER FIELD imaa103  #購料特性
        #IF g_imaa.imaa103 IS NULL OR g_imaa.imaa103 not matches'[012]'
         IF g_imaa.imaa103 not matches'[012]' THEN
            NEXT FIELD imaa103
         END IF
 
      AFTER FIELD imaa43            #採購員
         IF (g_imaa_o.imaa43 IS NULL) OR (g_imaa.imaa43 != g_imaa_o.imaa43)
            OR (g_imaa_o.imaa43 IS NOT NULL AND g_imaa.imaa43 IS NULL) THEN
            CALL aimi153_peo(g_imaa.imaa43,'a')
            IF g_chr = 'E' THEN
               CALL cl_err(g_imaa.imaa43,'mfg1312',0)
               LET g_imaa.imaa43 = g_imaa_o.imaa43
               DISPLAY BY NAME g_imaa.imaa43
               NEXT FIELD imaa43
            END IF
         END IF
         LET g_imaa_o.imaa43 = g_imaa.imaa43
 
      BEFORE FIELD imaa44
         CALL i153_set_entry(p_cmd)
         IF g_imaa_o.imaa44 IS NULL AND g_imaa.imaa44 IS NULL THEN
            LET g_imaa.imaa44=g_imaa.imaa25
            LET g_imaa_o.imaa44=g_imaa.imaa25
            DISPLAY BY NAME g_imaa.imaa44
         END IF
 
      AFTER FIELD imaa44           #採購單位
         IF g_imaa.imaa44 IS NULL THEN
            LET g_imaa.imaa44=g_imaa.imaa25
            DISPLAY BY NAME g_imaa.imaa44
         END IF
         IF g_imaa.imaa08 matches'[PVZ]' AND (g_imaa.imaa44 IS NULL
                                            OR g_imaa.imaa44 = ' ') THEN
            LET g_imaa.imaa44 = g_imaa_o.imaa44
            DISPLAY BY NAME g_imaa.imaa44
            NEXT FIELD imaa44
         END IF
         IF g_imaa.imaa44 = g_imaa.imaa25 THEN
            LET g_imaa.imaa44_fac = 1
            DISPLAY BY NAME g_imaa.imaa44_fac
            LET g_imaa_o.imaa44 = g_imaa.imaa44
            LET g_imaa_o.imaa44_fac = g_imaa.imaa44_fac
           #NEXT FIELD imaa44_fac genero
         END IF
         IF g_imaa.imaa44 IS NOT NULL THEN
            IF (g_imaa_o.imaa44 IS NULL) OR (g_imaa.imaa44 != g_imaa_o.imaa44) THEN
               SELECT gfe01 FROM gfe_file
                WHERE gfe01 = g_imaa.imaa44
                  AND gfeacti in ('y','Y')
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","gfe_file",g_imaa.imaa44,"",
                               "mfg1006","","",1)  
                  LET g_imaa.imaa44 = g_imaa_o.imaa44
                  DISPLAY BY NAME  g_imaa.imaa44
                  NEXT FIELD imaa44
               ELSE
                  IF g_imaa.imaa44 = g_imaa.imaa25 THEN
                     LET g_imaa.imaa44_fac = 1
                  ELSE
                     CALL s_umfchk(g_imaa.imaa01,g_imaa.imaa44,g_imaa.imaa25)
                         RETURNING g_sw,g_imaa.imaa44_fac
                     IF g_sw = '1' THEN
                        CALL cl_err(g_imaa.imaa25,'mfg1206',0)
                        LET g_imaa.imaa44 = g_imaa_o.imaa44
                        DISPLAY BY NAME g_imaa.imaa44
                        LET g_imaa.imaa44_fac = g_imaa_o.imaa44_fac
                        DISPLAY BY NAME g_imaa.imaa44_fac
                        NEXT FIELD imaa44
                     END IF
                  END IF
               END IF
               DISPLAY BY NAME g_imaa.imaa44_fac
            END IF
         END IF
         LET g_imaa_o.imaa44 = g_imaa.imaa44
         LET g_imaa_o.imaa44_fac = g_imaa.imaa44_fac
         CALL i153_set_no_entry(p_cmd)
         #FUN-BB0083---add---str
         LET l_case = ''
         IF g_imaa.imaa37 != '0' THEN
            LET g_imaa.imaa99 = s_digqty(g_imaa.imaa99,g_imaa.imaa44)
            DISPLAY BY NAME g_imaa.imaa99
         ELSE
            IF NOT cl_null(g_imaa.imaa99) AND g_imaa.imaa99<>0 THEN
               IF NOT i153_imaa99_check() THEN
                  LET l_case = "imaa99"
               END IF
            END IF
         END IF
         IF g_imaa.imaa37 != '5' THEN
            LET g_imaa.imaa88 = s_digqty(g_imaa.imaa88,g_imaa.imaa44)
                DISPLAY BY NAME g_imaa.imaa88
         ELSE
            IF NOT cl_null(g_imaa.imaa88) AND g_imaa.imaa88<>0 THEN
               IF NOT i153_imaa88_check() THEN
                  LET l_case = "imaa88"
               END IF
            END IF
         END IF
 
         IF NOT cl_null(g_imaa.imaa45) AND g_imaa.imaa45<>0 THEN
            IF NOT i153_imaa45_check() THEN
               LET l_case = "imaa45"
            END IF
         END IF
         IF NOT cl_null(g_imaa.imaa46) AND g_imaa.imaa46<>0 THEN
            IF NOT i153_imaa46_check() THEN
               LET l_case = "imaa46"
            END IF
         END IF
         IF NOT cl_null(g_imaa.imaa51) AND g_imaa.imaa51<>0 THEN
            IF NOT i153_imaa51_check() THEN
               LET l_case = "imaa51"
            END IF
         END IF
         LET g_imaa44_t = g_imaa.imaa44
         CASE l_case
            WHEN "imaa99"
               NEXT FIELD imaa99
            WHEN "imaa88"
               NEXT FIELD imaa88
            WHEN "imaa51"
               NEXT FIELD imaa51
            WHEN "imaa46"
               NEXT FIELD imaa46
            WHEN "imaa45"
               NEXT FIELD imaa45
            OTHERWISE EXIT CASE
         END CASE
         #FUN-BB0083---add---end
 
       AFTER FIELD imaa54                  #主要供應商
           IF (g_imaa_o.imaa54 IS NULL) OR (g_imaa.imaa54 != g_imaa_o.imaa54)
               OR (g_imaa_o.imaa54 IS NOT NULL AND g_imaa.imaa54 IS NULL)
             THEN CALL aimi153_imaa54('a')
                  IF g_chr='E' THEN
                     CALL cl_err(g_imaa.imaa54,'mfg3001',0)
                     LET g_imaa.imaa54 = g_imaa_o.imaa54
                     DISPLAY BY NAME  g_imaa.imaa54
                     NEXT FIELD imaa54
                  END IF
            END IF
            LET g_imaa_o.imaa54 = g_imaa.imaa54
 
       AFTER FIELD imaa104        #廠商分配限量
          IF g_imaa.imaa104 IS NULL OR g_imaa.imaa104 < 0
          THEN LET g_imaa.imaa104 = 0
               DISPLAY BY NAME g_imaa.imaa104
          END IF
 
    #AFTER FIELD imaa53          #最近採購單價
    #    IF (g_imaa.imaa53 < 0) #genero
    #    THEN CALL cl_err(g_imaa.imaa53,'mfg3331',0)
    #         LET g_imaa.imaa53 = g_imaa_o.imaa53
    #         DISPLAY BY NAME g_imaa.imaa53
    #         NEXT FIELD imaa53
    #    END IF
    #    LET g_imaa_o.imaa53 = g_imaa.imaa53
    #    LET l_direct = 'D'
 
   #AFTER FIELD imaa91          #平均採購單價
   #   #IF g_imaa.imaa91 IS NULL OR g_imaa.imaa91 = ' '
   #    IF g_imaa.imaa91 <= 0  #genero
   #    THEN CALL cl_err(g_imaa.imaa91,'mfg1322',0)
   #         LET g_imaa.imaa91 = g_imaa_o.imaa91
   #         DISPLAY BY NAME g_imaa.imaa91
   #         NEXT FIELD imaa91
   #    END IF
   #    LET g_imaa_o.imaa91 = g_imaa.imaa91
 
       BEFORE FIELD imaa531         #市價
          IF g_flag1 ='a' THEN
             LET g_imaa.imaa53 = g_imaa.imaa531
             DISPLAY BY NAME g_imaa.imaa53
          END IF
 
      AFTER FIELD imaa531         #市價
       # IF g_imaa.imaa531 IS NULL OR g_imaa.imaa531 = ' '
         IF g_imaa.imaa531 <  0  #genero
               THEN CALL cl_err(g_imaa.imaa531,'mfg1322',0)
			   NEXT FIELD imaa531
         END IF
         LET g_imaa_o.imaa531 = g_imaa.imaa531
 
     #AFTER FIELD imaa532
     #   LET l_direct2='D'
     #   LET l_direct3='D'
 
 
        #再補貨點
        AFTER FIELD imaa38
           #IF g_imaa.imaa38 IS NULL OR g_imaa.imaa38 = ' ' OR
            IF g_imaa.imaa38 <= 0 #genero
               THEN CALL cl_err(g_imaa.imaa38,'mfg1322',0)
                    LET g_imaa.imaa38 = g_imaa_o.imaa38
                    DISPLAY BY NAME g_imaa.imaa38
                    NEXT FIELD imaa38
            END IF
            LET g_imaa_o.imaa38 = g_imaa.imaa38
            LET l_direct2='U'
 
        AFTER FIELD imaa99
           IF NOT i153_imaa99_check() THEN NEXT FIELD imaa99 END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str
           # IF g_imaa.imaa99 <= 0
           #    THEN CALL cl_err(g_imaa.imaa99,'mfg1322',0)
           #         LET g_imaa.imaa99 = g_imaa_o.imaa99
           #         DISPLAY BY NAME g_imaa.imaa99
           #         NEXT FIELD imaa99
           # END IF
           # LET g_imaa_o.imaa99 = g_imaa.imaa99
           #FUN-BB0083---mark---end
        AFTER FIELD imaa88
           IF NOT i153_imaa88_check() THEN NEXT FIELD imaa88 END IF #FUN-BB0083 add
            #FUN-BB0083---mark---str
            # IF g_imaa.imaa88 <= 0 #genero
            #    THEN  CALL cl_err(g_imaa.imaa88,'mfg1322',0)
            #          LET g_imaa.imaa88 = g_imaa_o.imaa88
            #          DISPLAY BY NAME g_imaa.imaa88
            #          NEXT FIELD imaa88
            # END IF
            # LET g_imaa_o.imaa88 = g_imaa.imaa88
            # LET l_direct2='U'
            # LET l_direct3='U'
            #FUN-BB0083---mark---end  
        AFTER FIELD imaa89
                      IF g_imaa.imaa89 < 0 THEN
                         CALL cl_err(g_imaa.imaa89,'mfg0013',0)
                         LET g_imaa.imaa89 = g_imaa_o.imaa89
                         DISPLAY BY NAME g_imaa.imaa89
                         NEXT FIELD imaa89
                      END IF
             LET g_imaa_o.imaa89 = g_imaa.imaa89
 
        AFTER FIELD imaa90
             IF g_imaa.imaa90 < 0 THEN
                CALL cl_err(g_imaa.imaa90,'mfg0013',0)
                NEXT FIELD imaa90
             END IF
             IF g_imaa.imaa37='5' THEN
                IF g_imaa.imaa89 =0 AND g_imaa.imaa90=0
                   THEN CALL cl_err(g_imaa.imaa37,'mfg9221',0)
                        NEXT FIELD imaa89
                END IF
             END IF
 
        AFTER FIELD imaa51          #經濟訂購量
           IF NOT i153_imaa51_check() THEN NEXT FIELD imaa51 END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str 
           ##IF g_imaa.imaa51 IS NULL OR g_imaa.imaa51 = ' '
           #  IF g_imaa.imaa51 <= 0  #genero
           #     THEN  CALL cl_err(g_imaa.imaa51,'mfg1322',0)
           #           LET g_imaa.imaa51 = g_imaa_o.imaa51
           #           DISPLAY BY NAME g_imaa.imaa51
           #           NEXT FIELD imaa51
           #  END IF
           #  LET g_imaa_o.imaa51 = g_imaa.imaa51
           #  LET l_direct2='U'
           #  LET l_direct3='U'
           #FUN-BB0083---mark---end 
       #AFTER FIELD imaa52          #平均訂購量
       #    #IF g_imaa.imaa52 IS NULL OR g_imaa.imaa52 = ' '
       #     IF g_imaa.imaa52 <= 0  #genero
       #        THEN  CALL cl_err(g_imaa.imaa52,'mfg1322',0)
       #              LET g_imaa.imaa52 = g_imaa_o.imaa52
       #              DISPLAY BY NAME g_imaa.imaa52
       #              NEXT FIELD imaa52
       #     END IF
       #     LET g_imaa_o.imaa52 = g_imaa.imaa52
       #     LET l_direct4='D'
 
        AFTER FIELD imaa45          #採購單位批量
           IF NOT i153_imaa45_check() THEN NEXT FIELD imaa45 END IF #FUN-BB0083 add
            #FUN-BB0083---mark---str 
            #IF g_imaa.imaa45 IS NULL OR g_imaa.imaa45 = ' '
            # IF g_imaa.imaa45 < 0 #genero
            #    THEN CALL cl_err(g_imaa.imaa45,'mfg0013',0)
            #         LET g_imaa.imaa45 = g_imaa_o.imaa45
            #         DISPLAY BY NAME g_imaa.imaa45
            #        NEXT FIELD imaa45
            # END IF
            # LET g_imaa_o.imaa45 = g_imaa.imaa45
            #FUN-BB0083---mark---end
 
 
        AFTER FIELD imaa48          #採購安全期
            #IF g_imaa.imaa48 IS NULL OR g_imaa.imaa48 = ' '
             IF g_imaa.imaa48 < 0 #genero
                THEN  CALL cl_err(g_imaa.imaa48,'mfg0013',0)
                      LET g_imaa.imaa48 = g_imaa_o.imaa48
                      DISPLAY BY NAME  g_imaa.imaa48
                      NEXT FIELD imaa48
             END IF
             LET g_imaa_o.imaa48 = g_imaa.imaa48
             LET l_direct4='U'
 
        AFTER FIELD imaa50          #請購安全期
             IF g_imaa.imaa50 IS NULL OR g_imaa.imaa50 = ' '
                 OR g_imaa.imaa50 < 0
                THEN  CALL cl_err(g_imaa.imaa50,'mfg0013',0)
                      LET g_imaa.imaa50 = g_imaa_o.imaa50
                      DISPLAY BY NAME g_imaa.imaa50
                      NEXT FIELD imaa50
             END IF
             LET g_imaa_o.imaa50 = g_imaa.imaa50
 
        AFTER FIELD imaa49          #到廠前置期
             IF g_imaa.imaa49 IS NULL OR g_imaa.imaa49 = ' '
                 OR g_imaa.imaa49 < 0
                THEN  CALL cl_err(g_imaa.imaa49,'mfg0013',0)
                      LET g_imaa.imaa49 = g_imaa_o.imaa49
                      DISPLAY BY NAME g_imaa.imaa49
                      NEXT FIELD imaa49
             END IF
             LET g_imaa_o.imaa49 = g_imaa.imaa49
 
        AFTER FIELD imaa491          #入庫前置期
             IF g_imaa.imaa491 IS NULL OR g_imaa.imaa491 = ' '
                 OR g_imaa.imaa491 < 0
                THEN  CALL cl_err(g_imaa.imaa491,'mfg0013',0)
                      LET g_imaa.imaa491 = g_imaa_o.imaa491
                      DISPLAY BY NAME g_imaa.imaa491
                      NEXT FIELD imaa491
             END IF
             LET g_imaa_o.imaa491 = g_imaa.imaa491
 
        AFTER FIELD imaa46          #最少採購數量
           IF NOT i153_imaa46_check() THEN NEXT FIELD imaa46 END IF #FUN-BB0083 add
             #FUN-BB0083---mark---str
             #IF g_imaa.imaa46 IS NULL OR g_imaa.imaa46 = ' '
             #    OR g_imaa.imaa46 < 0
             #   THEN
             #        CALL cl_err(g_imaa.imaa46,'mfg0013',0)
             #        LET g_imaa.imaa46 = g_imaa_o.imaa46
             #        DISPLAY BY NAME g_imaa.imaa46
             #        NEXT FIELD imaa46
             #END IF
             #IF g_imaa_o.imaa46 IS NULL OR (g_imaa.imaa46 != g_imaa_o.imaa46) THEN
             #   IF g_imaa.imaa45 >1 THEN  #採購批量<1時,不控制
             #     IF (g_imaa.imaa46 mod g_imaa.imaa45) != 0 THEN
             #        CALL aimi153_size()
             #     END IF
             #   END IF
             #END IF
             #LET g_imaa_o.imaa46 = g_imaa.imaa46
             #FUN-BB0083---mark---end
 
        AFTER FIELD imaa47          #採購損耗率
             IF g_imaa.imaa47 IS NULL OR g_imaa.imaa47 = ' '
                 OR g_imaa.imaa47 < 0  OR g_imaa.imaa47 > 100
                THEN CALL cl_err(g_imaa.imaa47,'mfg1332',0)
                     LET g_imaa.imaa47 = g_imaa_o.imaa47
                     DISPLAY BY NAME g_imaa.imaa47
                     NEXT FIELD imaa47
             END IF
             LET g_imaa_o.imaa47 = g_imaa.imaa47
 
        AFTER FIELD imaa100
             IF g_imaa.imaa100 IS NULL OR g_imaa.imaa100 = ' '
                 OR g_imaa.imaa100 NOT MATCHES '[NTR]' THEN
                 LET g_imaa.imaa100 = g_imaa_o.imaa100
                 DISPLAY BY NAME g_imaa.imaa100
                 NEXT FIELD imaa100
             END IF
             LET g_imaa_o.imaa100 = g_imaa.imaa100
 
        AFTER FIELD imaa101
             IF g_imaa.imaa101 IS NULL OR g_imaa.imaa101 = ' '
                 OR g_imaa.imaa101 NOT MATCHES '[12]' THEN
                 LET g_imaa.imaa101 = g_imaa_o.imaa101
                 DISPLAY BY NAME g_imaa.imaa101
                 NEXT FIELD imaa101
             END IF
             LET g_imaa_o.imaa101 = g_imaa.imaa101
 
        AFTER FIELD imaa102
             IF g_imaa.imaa102 IS NULL OR g_imaa.imaa102 = ' ' THEN
                 LET g_imaa.imaa102 = g_imaa_o.imaa102
                 DISPLAY BY NAME g_imaa.imaa102
                 NEXT FIELD imaa102
             END IF
             IF g_imaa.imaa101='1' AND g_imaa.imaa102 NOT MATCHES '[123]' THEN
                 LET g_imaa.imaa102 = g_imaa_o.imaa102
                 DISPLAY BY NAME g_imaa.imaa102
                 NEXT FIELD imaa102
             END IF
             IF g_imaa.imaa101='2' AND g_imaa.imaa102 NOT MATCHES '[1234]' THEN
                 LET g_imaa.imaa102 = g_imaa_o.imaa102
                 DISPLAY BY NAME g_imaa.imaa102
                 NEXT FIELD imaa102
             END IF
             LET g_imaa_o.imaa102 = g_imaa.imaa102
 
        BEFORE FIELD imaa913
           CALL i153_set_entry(p_cmd)
 
        AFTER FIELD imaa913
           IF g_imaa.imaa913 = "N" THEN
              LET g_imaa.imaa914 = ""
              LET g_geu02 = ""
              DISPLAY g_imaa.imaa914,g_geu02 TO imaa914,geu02
           END IF
           CALL i153_set_no_entry(p_cmd)
           
        AFTER FIELD imaa914
           IF NOT cl_null(g_imaa.imaa914) THEN
              IF g_imaa.imaa914 != g_imaa_o.imaa914 OR cl_null(g_imaa_o.imaa914) THEN   #No.MOD-640061
                 SELECT geu02 INTO g_geu02 FROM geu_file
                  WHERE geu01 = g_imaa.imaa914
                    AND geu00 = "4"
                 IF STATUS THEN
                    CALL cl_err3("sel","geu_file",g_imaa.imaa914,"",
                                 "anm-027","","",1)
                    NEXT FIELD imaa914
                 ELSE
                    DISPLAY g_geu02 TO geu02
                 END IF
              END IF
           END IF
 
        AFTER INPUT
           LET g_imaa.imaauser = s_get_data_owner("imaa_file") #FUN-C10039
           LET g_imaa.imaagrup = s_get_data_group("imaa_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_imaa.imaa37 NOT MATCHES "[012345]"  OR
                   g_imaa.imaa37 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa37
            END IF
            #來源碼不為採購料件時, 補貨策略碼不可為'0' (再訂購點)
            IF g_imaa.imaa37='0' AND g_imaa.imaa08 NOT MATCHES '[MPVZ]' THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa37
            END IF
            IF cl_null(g_imaa.imaa103) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa103
            END IF
            IF cl_null(g_imaa.imaa44) THEN
               LET g_imaa.imaa44=g_imaa.imaa25
               DISPLAY BY NAME g_imaa.imaa44
            END IF
            IF g_imaa.imaa44_fac IS NULL OR g_imaa.imaa44_fac<=0 THEN
               LET l_flag='Y'     #採購單位轉換因子
               DISPLAY BY NAME g_imaa.imaa44_fac
            END IF
            IF cl_null(g_imaa.imaa27) OR g_imaa.imaa27 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa27
            END IF
            IF cl_null(g_imaa.imaa104) OR g_imaa.imaa104 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa104
            END IF
            IF cl_null(g_imaa.imaa100) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa100
            END IF
            IF cl_null(g_imaa.imaa101) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa101
            END IF
            IF cl_null(g_imaa.imaa102) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa102
            END IF
            IF cl_null(g_imaa.imaa53) OR g_imaa.imaa53 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa53
            END IF
            IF cl_null(g_imaa.imaa531) OR g_imaa.imaa531 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa531
            END IF
            IF cl_null(g_imaa.imaa48) OR g_imaa.imaa48 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa48
            END IF
            IF g_imaa.imaa50 IS NULL OR g_imaa.imaa50 = ' '
                 OR g_imaa.imaa50 < 0 THEN   #請購安全期
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa50
            END IF
            IF g_imaa.imaa49 IS NULL OR g_imaa.imaa49 = ' '
                 OR g_imaa.imaa49 < 0 THEN   #到廠前置期
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa49
            END IF
            IF g_imaa.imaa491 IS NULL OR g_imaa.imaa491 = ' '
                 OR g_imaa.imaa491 < 0 THEN  #入庫前置期
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa491
            END IF
            IF g_imaa.imaa37='0' AND
	     ((g_imaa.imaa38 IS NULL OR g_imaa.imaa38 = ' ' OR g_imaa.imaa38 < 0) OR
	      (g_imaa.imaa99 IS NULL OR g_imaa.imaa99=' ' OR g_imaa.imaa99<0))
	      THEN   #再補貨點及再補貨量
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa38
            END IF
            IF g_imaa.imaa37 = '5' AND (g_imaa.imaa88 IS NULL OR
                   g_imaa.imaa88 = ' ' OR g_imaa.imaa88 <= 0 ) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa88
            END IF
            IF g_imaa.imaa37 = '5' AND (g_imaa.imaa89 IS NULL OR
                g_imaa.imaa89 = ' ') AND
                (g_imaa.imaa90 IS NULL OR g_imaa.imaa90 = ' ') THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa89
            END IF
            IF g_imaa.imaa51 IS NULL OR g_imaa.imaa51 = ' '
                 OR g_imaa.imaa51 <= 0 THEN  #經濟訂購量
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa51
            END IF
            #MOD-A90118 mark --start--
            #IF g_imaa.imaa52 IS NULL OR g_imaa.imaa52 = ' '
            #     OR g_imaa.imaa52 <= 0 THEN #平均訂購量
            #   LET l_flag='Y'
            #   DISPLAY BY NAME g_imaa.imaa52
            #END IF
            #MOD-A90118 mark --end--
            IF  g_imaa.imaa08 matches'[PVZ]' AND  #採購單位
                 (g_imaa.imaa44 IS NULL  OR g_imaa.imaa44 = ' ') THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa44
            END IF
            IF g_imaa.imaa45 IS NULL OR g_imaa.imaa45 = ' '
                OR g_imaa.imaa45 < 0 THEN  #採購單位批量
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa45
            END IF
            IF g_imaa.imaa46 IS NULL OR g_imaa.imaa46 = ' '
                 OR g_imaa.imaa46 < 0 THEN  #最少採購數量
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa46
            END IF
            IF g_imaa.imaa47 IS NULL OR g_imaa.imaa47 = ' '
                 OR g_imaa.imaa47 < 0 THEN #採購損耗率
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa47
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imaa37
            END IF
 
        ON ACTION create_unit
           CALL cl_cmdrun("aooi101 ")
 
        ON ACTION create_supplier
           LET l_cmd = "apmi600 '",g_imaa.imaa54,"' " CLIPPED  #CHI-D30005 add
           CALL cl_cmdrun(l_cmd)                               #CHI-D30005 add
          #CALL cl_cmdrun("apmi600 ")                          #CHI-D30005 mark
 
        ON ACTION create_item
           CALL cl_cmdrun("aooi103 ")     #No.MOD-790172 modify
 
        ON ACTION unit_conversion
           CALL cl_cmdrun("aooi102 ")
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imaa54)                       #供應商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.default1 = g_imaa.imaa54
                 CALL cl_create_qry() RETURNING g_imaa.imaa54
                 DISPLAY BY NAME g_imaa.imaa54
                 CALL aimi153_imaa54('d')
                 NEXT FIELD imaa54
               WHEN INFIELD(imaa43)                       #採購員(imaa43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_imaa.imaa43
                 CALL cl_create_qry() RETURNING g_imaa.imaa43
                 DISPLAY BY NAME g_imaa.imaa43
                 CALL aimi153_peo(g_imaa.imaa43,'d')
                 NEXT FIELD imaa43
               WHEN INFIELD(imaa44)                       #採購單位(imaa44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imaa.imaa44
                 CALL cl_create_qry() RETURNING g_imaa.imaa44
                 DISPLAY BY NAME g_imaa.imaa44
                 NEXT FIELD imaa44
               WHEN INFIELD(imaa914)     
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_geu"
                  LET g_qryparam.arg1 ="4"
                  LET g_qryparam.default1 = g_imaa.imaa914
                  CALL cl_create_qry() RETURNING g_imaa.imaa914
                  DISPLAY BY NAME g_imaa.imaa914
                  NEXT FIELD imaa914
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
     #ON ACTION update
     #   IF NOT cl_null(g_imaa.imaa01) THEN
     #      LET g_doc.column1 = "imaa01"
     #      LET g_doc.value1 = g_imaa.imaa01
     #      CALL cl_fld_doc("imaa04")
     #   END IF
 
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
 
FUNCTION aimi153_size()  #供應廠商
   DEFINE l_count    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_imaa46   LIKE imaa_file.imaa46
 
   LET l_count = g_imaa.imaa46 MOD g_imaa.imaa45
   IF l_count != 0 THEN
      LET l_count = g_imaa.imaa46/ g_imaa.imaa45
      LET l_imaa46 = ( l_count + 1 ) * g_imaa.imaa45
      CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
 
      WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
         LET INT_FLAG = 0  ######add for prompt bug
         PROMPT g_msg CLIPPED,'(',l_imaa46,')',':' FOR g_chr
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
            EXIT WHILE
         END IF
      END WHILE
 
     #IF g_chr ='Y' OR g_chr = 'y'  THEN
     #   LET g_imaa.imaa46 = l_imaa46
     #END IF
 
     #DISPLAY BY NAME g_imaa.imaa46
     DISPLAY BY NAME g_imaa.imaa45   #FUN-BB0083 add
     DISPLAY BY NAME g_imaa.imaa46   #FUN-BB0083 add
   END IF
 
   LET g_chr = NULL
 
END FUNCTION
 
FUNCTION aimi153_imaa54(p_cmd)  #供應廠商
   DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_pmc03   LIKE pmc_file.pmc03,
          l_pmcacti LIKE pmc_file.pmcacti
 
   LET g_chr = ' '
   IF g_imaa.imaa54 IS NULL THEN
      LET l_pmc03=NULL
   ELSE
      SELECT pmc03,pmcacti
        INTO l_pmc03,l_pmcacti
        FROM pmc_file
       WHERE pmc01 = g_imaa.imaa54
      IF SQLCA.sqlcode THEN
         LET g_chr = 'E'
         LET l_pmc03 = NULL
      ELSE
         IF l_pmcacti='N' THEN
            LET g_chr = 'E'
         END IF
      END IF
   END IF
 
   IF g_chr = ' ' OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO pmc03
   END IF
 
END FUNCTION
 
FUNCTION aimi153_peo(p_key,p_cmd)    #人員
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
      IF SQLCA.sqlcode THEN
         LET l_gen02 = NULL
         LET g_chr = 'E'
      ELSE
         IF l_genacti='N' THEN
            LET g_chr = 'E'
         END IF
      END IF
   END IF
 
   IF g_chr = ' ' OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO gen02
   END IF
 
END FUNCTION
 
FUNCTION aimi153_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL aimi153_curs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN aimi153_count
   FETCH aimi153_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN aimi153_curs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       INITIALIZE g_imaa.* TO NULL
   ELSE
       CALL aimi153_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION aimi153_fetch(p_flimaa)
    DEFINE
        p_flimaa          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimaa
        WHEN 'N' FETCH NEXT     aimi153_curs INTO g_imaa.imaano
        WHEN 'P' FETCH PREVIOUS aimi153_curs INTO g_imaa.imaano
        WHEN 'F' FETCH FIRST    aimi153_curs INTO g_imaa.imaano
        WHEN 'L' FETCH LAST     aimi153_curs INTO g_imaa.imaano
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
            FETCH ABSOLUTE g_jump aimi153_curs INTO g_imaa.imaano
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
        CALL aimi153_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi153_show()
    DEFINE ls_imaa04      STRING
    DEFINE ls_pic_url     STRING
 
    LET g_geu02=""  
    LET g_imaa_t.* = g_imaa.*
    LET g_s=g_imaa.imaa93[3,3]
	MESSAGE ''
    DISPLAY g_s TO FORMONLY.s
    DISPLAY BY NAME
              g_imaa.imaa00 ,g_imaa.imaano ,g_imaa.imaa01    ,g_imaa.imaa02  ,g_imaa.imaa021,
              g_imaa.imaa08 ,g_imaa.imaa25 ,g_imaa.imaa03    ,g_imaa.imaa1010,g_imaa.imaa92 ,
              g_imaa.imaa43 ,g_imaa.imaa44 ,g_imaa.imaa44_fac,g_imaa.imaa45  ,g_imaa.imaa46 ,
              g_imaa.imaa51 ,g_imaa.imaa47 ,g_imaa.imaa54    ,g_imaa.imaa908 ,g_imaa.imaa104,
              g_imaa.imaa531,g_imaa.imaa50 ,g_imaa.imaa48    ,g_imaa.imaa49  ,g_imaa.imaa491,   
              g_imaa.imaa72 ,g_imaa.imaa721,g_imaa.imaa103,g_imaa.imaa37    ,g_imaa.imaa27  ,g_imaa.imaa38 , #CHI-C50068
              g_imaa.imaa99 ,g_imaa.imaa88 ,g_imaa.imaa89    ,g_imaa.imaa90  ,g_imaa.imaa24 ,
              g_imaa.imaa100,g_imaa.imaa101,g_imaa.imaa102   ,g_imaa.imaa913 ,g_imaa.imaa914,
              g_imaa.imaauser, g_imaa.imaagrup, g_imaa.imaamodu,g_imaa.imaadate, g_imaa.imaaacti,
              g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
 
   SELECT geu02 INTO g_geu02 FROM geu_file
    WHERE geu01 = g_imaa.imaa914
 
   DISPLAY g_geu02 TO geu02
 
    CALL s_opc(g_imaa.imaa37) RETURNING g_sta
    CALL aimi153_imaa54('d')
    CALL aimi153_peo(g_imaa.imaa43,'d')
 
   CALL i153_show_pic() #圖形顯示
 
   LET g_doc.column1 = "imaa01"
   LET g_doc.value1 = g_imaa.imaa01
   CALL cl_get_fld_doc("imaa04")
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION aimi153_u()
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
 
    OPEN aimi153_curl USING g_imaa.imaano
    IF STATUS THEN
       CALL cl_err("OPEN aimi153_curl:", STATUS, 1)
       CLOSE aimi153_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi153_curl INTO g_imaa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imaa.imaamodu = g_user                   #修改者
    LET g_imaa.imaadate = g_today                  #修改日期
    CALL aimi153_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi153_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imaa.*=g_imaa_t.*
            CALL aimi153_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_imaa.imaa93[3,3] = 'Y'
       #TQC-750007----add---str--
        IF g_imaa.imaa1010 MATCHES '[RW]' THEN
            LET g_imaa.imaa1010 = '0' #開立
        END IF
       #TQC-750007----add---end--
        UPDATE imaa_file SET imaa_file.* = g_imaa.*    # 更新DB
            WHERE imaano = g_imaa.imaano               # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","imaa_file",g_imaano_t,"",
                         SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
       ##更新 [料件/供應商檔](pmh_file).....  92/01/23 BY Lin
       #IF g_imaa.imaa54 IS NOT NULL THEN
       #   SELECT pmh01 FROM pmh_file   #新的
       #         WHERE pmh01=g_imaa.imaa01 AND pmh02=g_imaa.imaa54
       #           AND pmh13=g_aza.aza17
       #   IF SQLCA.sqlcode THEN    #新的不存在,將舊的供應商直接改成新的供應商
       #      IF g_imaa_t.imaa54 IS NOT NULL THEN
       #         UPDATE pmh_file SET pmh02 = g_imaa.imaa54,
       #                             pmh03 = 'Y',
       #                             pmhacti = 'Y',
       #                             pmhmodu = g_user,
       #                             pmhdate = g_today
       #          WHERE pmh01 = g_imaa.imaa01
       #            AND pmh02 = g_imaa_t.imaa54
       #            AND pmh13 = g_aza.aza17
       #      ELSE
       #          INSERT INTO pmh_file(pmh01,pmh02,pmh03,pmh04,pmh05,  #No.MOD-470041    #舊的也不存在,則新增一筆
       #                              pmh06,pmh07,pmh08,pmh09,pmh10,
       #                              pmh11,pmh12,pmh13,pmh14,pmh15,
       #                              pmh16,pmhacti,pmhuser,pmhgrup,
       #                              pmhmodu,pmhdate)
       #              VALUES(g_imaa.imaa01,g_imaa.imaa54,'Y','','0',g_today,
       #                     '','N','  ','',100,0,g_aza.aza17,1,'','',
       #                     'Y',g_user,g_grup,'',g_today)
       #      END IF
       #   ELSE
       #      UPDATE pmh_file SET pmh03='Y',
       #                          pmhacti='Y',
       #                          pmhmodu=g_user,
       #                          pmhdate=g_today
       #       WHERE pmh01=g_imaa.imaa01
       #         AND pmh02=g_imaa.imaa54
       #         AND pmh13=g_aza.aza17
       #     IF g_imaa_t.imaa54 IS NOT NULL THEN #新的為NULL時,將原來的
       #        UPDATE pmh_file                #主要供應商之值改成'N'
       #           SET pmh03='N',
       #               pmhmodu=g_user,  pmhdate=g_today
       #         WHERE pmh01=g_imaa.imaa01 AND pmh02=g_imaa_t.imaa54
       #           AND pmh13=g_aza.aza17
       #     END IF
       #   END IF
       #ELSE
       #   IF g_imaa_t.imaa54 IS NOT NULL THEN #新的為NULL時,將原來的
       #      UPDATE pmh_file                #供應商之值改成無效
       #         SET pmhacti='N',
       #             pmhmodu=g_user,  pmhdate=g_today
       #         WHERE pmh01=g_imaa.imaa01 AND pmh02=g_imaa_t.imaa54
       #           AND pmh13=g_aza.aza17
       #   END IF
       #END IF
{
        #更新 [料件分群/供應商檔](pmi_file) ..... 92/01/23 BY Lin
        #[註]:此檔案不做舊資料的更新動作,只做新資料insert的動作
        IF g_imaa.imaa06 IS NOT NULL AND g_imaa.imaa54 IS NOT NULL THEN
           SELECT pmi01 FROM pmi_file   #新的
                 WHERE pmi01=g_imaa.imaa06 AND pmi02=g_imaa.imaa54
           IF SQLCA.sqlcode THEN    #新的不存在,則新增一筆
                 INSERT INTO pmi_file
                     VALUES(g_imaa.imaa06,g_imaa.imaa54,'Y','','Y',g_user,
                            g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           ELSE
              UPDATE pmi_file  #新的若存在,則將主要供應商='Y'
                 SET pmi03='Y',       pmiacti='Y',
                     pmimodu=g_user,  pmidate=g_today
                 WHERE pmi01=g_imaa.imaa06 AND pmi02=g_imaa.imaa54
           END IF
        END IF
}
        DISPLAY 'Y' TO FORMONLY.s
        EXIT WHILE
    END WHILE
    CLOSE aimi153_curl
    COMMIT WORK  
    #TQC-750007---add---str--
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
    CALL aimi153_show()                                            
    #TQC-750007---add---end--
END FUNCTION
 
 
{
FUNCTION aimi153_out()
    DEFINE
        sr              RECORD LIKE imaa_file.*,
        sr2             RECORD
                          pmc03   LIKE pmc_file.pmc03,
                          gen02   LIKE gen_file.gen02
                        END RECORD,
        l_i             LIKE type_file.num5,   #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05          LIKE za_file.za05,     #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   LET l_name = 'aimi153.out'
    CALL cl_outnam('aimi153') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT imaa_file.* ,pmc03,gen02 FROM imaa_file,OUTER pmc_file,OUTER gen_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              "   AND ima_file.imaa54 = pmc_file.pmc01 ",
              "   AND ima_file.imaa43 = gen_file.gen01 "
    PREPARE aimi153_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi153_curo                         # CURSOR
        CURSOR FOR aimi153_p1
 
    START REPORT aimi153_rep TO l_name
 
    FOREACH aimi153_curo INTO sr.*,sr2.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT aimi153_rep(sr.*,sr2.*)
    END FOREACH
 
    FINISH REPORT aimi153_rep
 
    CLOSE aimi153_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT aimi153_rep(sr,sr2)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        sr              RECORD LIKE imaa_file.*,
        sr2             RECORD
                          pmc03   LIKE pmc_file.pmc03,
                          gen02   LIKE gen_file.gen02
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
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
            PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
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
                           COLUMN g_c[34],cl_numfor(sr.imaa45,34,3),
                           COLUMN g_c[35],cl_numfor(sr.imaa47,35,3),
                           COLUMN g_c[36],cl_numfor(sr.imaa51,36,3),
                           COLUMN g_c[37],sr.imaa54,
                           COLUMN g_c[38],sr2.pmc03,
                           COLUMN g_c[39],sr.imaa44
 
            PRINTX name=D2 COLUMN g_c[40],' ',
                           COLUMN g_c[41],sr.imaa06,
                           COLUMN g_c[42],sr.imaa021,
                           COLUMN g_c[43],cl_numfor(sr.imaa46,43,3),
                           COLUMN g_c[44],cl_numfor(sr.imaa48,44,3),
                           COLUMN g_c[45],cl_numfor(sr.imaa52,45,3),
                           COLUMN g_c[46],sr.imaa43,
                           COLUMN g_c[47],sr2.gen02
 
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
 
 
FUNCTION i153_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF INFIELD(imaa37) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imaa38,imaa99,imaa88,imaa89,imaa90",TRUE)
   END IF
 
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("imaa50",TRUE)
   END IF
 
   IF INFIELD(imaa913) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imaa914",TRUE)
      CALL cl_set_comp_required("imaa914",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i153_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF INFIELD(imaa37) OR (NOT g_before_input_done) THEN
      IF g_imaa.imaa37 != '0' THEN
         IF g_imaa.imaa37='5' THEN
            CALL cl_set_comp_entry("imaa38,imaa99",FALSE)
         ELSE
            CALL cl_set_comp_entry("imaa38,imaa99,imaa88,imaa89,imaa90",FALSE)
         END IF
      ELSE
         CALL cl_set_comp_entry("imaa88,imaa89,imaa90",FALSE)
      END IF
   END IF
 
   IF NOT g_before_input_done THEN
      IF g_sma.sma31='N' THEN
         CALL cl_set_comp_entry("imaa50",FALSE)
      END IF
   END IF
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("imaa01",FALSE)
   END IF
 
   IF g_imaa.imaa913 = "N" THEN
      CALL cl_set_comp_entry("imaa914",FALSE)
      CALL cl_set_comp_required("imaa914",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i153_show_pic()
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
FUNCTION i153_imaa45_check()
#imaa45 的單位 imaa44
   IF NOT cl_null(g_imaa.imaa44) AND NOT cl_null(g_imaa.imaa45) THEN
      IF cl_null(g_imaa_t.imaa45) OR cl_null(g_imaa44_t) OR g_imaa_t.imaa45 != g_imaa.imaa45 OR g_imaa44_t != g_imaa.imaa44 THEN 
         LET g_imaa.imaa45=s_digqty(g_imaa.imaa45,g_imaa.imaa44)
         DISPLAY BY NAME g_imaa.imaa45  
      END IF  
   END IF
   IF g_imaa.imaa45 < 0 THEN 
      CALL cl_err(g_imaa.imaa45,'mfg0013',0)
      LET g_imaa.imaa45 = g_imaa_o.imaa45
      DISPLAY BY NAME g_imaa.imaa45
      RETURN FALSE
   END IF
   LET g_imaa_o.imaa45 = g_imaa.imaa45
    
RETURN TRUE
END FUNCTION

FUNCTION i153_imaa46_check()
#imaa46 的單位 imaa44
   IF NOT cl_null(g_imaa.imaa44) AND NOT cl_null(g_imaa.imaa46) THEN
      IF cl_null(g_imaa_t.imaa46) OR cl_null(g_imaa44_t) OR g_imaa_t.imaa46 != g_imaa.imaa46 OR g_imaa44_t != g_imaa.imaa44 THEN 
         LET g_imaa.imaa46=s_digqty(g_imaa.imaa46,g_imaa.imaa44)
         DISPLAY BY NAME g_imaa.imaa46  
      END IF  
   END IF
   IF g_imaa.imaa46 IS NULL OR g_imaa.imaa46 = ' ' OR g_imaa.imaa46 < 0 THEN
      CALL cl_err(g_imaa.imaa46,'mfg0013',0)
      LET g_imaa.imaa46 = g_imaa_o.imaa46
      DISPLAY BY NAME g_imaa.imaa46
      RETURN FALSE
   END IF
   IF g_imaa_o.imaa46 IS NULL OR (g_imaa.imaa46 != g_imaa_o.imaa46) THEN
      IF g_imaa.imaa45 >1 THEN  #採購批量<1時,不控制
         IF (g_imaa.imaa46 mod g_imaa.imaa45) != 0 THEN
             CALL aimi153_size()
         END IF
      END IF
   END IF
   LET g_imaa_o.imaa46 = g_imaa.imaa46
   
RETURN TRUE
END FUNCTION
   
FUNCTION i153_imaa51_check()
#imaa51 的單位 imaa44
DEFINE l_direct2       LIKE type_file.chr1,
       l_direct3       LIKE type_file.chr1
   IF NOT cl_null(g_imaa.imaa44) AND NOT cl_null(g_imaa.imaa51) THEN
      IF cl_null(g_imaa_t.imaa51) OR cl_null(g_imaa44_t) OR g_imaa_t.imaa51 != g_imaa.imaa51 OR g_imaa44_t != g_imaa.imaa44 THEN 
         LET g_imaa.imaa51=s_digqty(g_imaa.imaa51,g_imaa.imaa44)
         DISPLAY BY NAME g_imaa.imaa51  
      END IF  
   END IF
   IF g_imaa.imaa51 <= 0 THEN  
      CALL cl_err(g_imaa.imaa51,'mfg1322',0)
      LET g_imaa.imaa51 = g_imaa_o.imaa51
      DISPLAY BY NAME g_imaa.imaa51
      RETURN FALSE
   END IF
   LET g_imaa_o.imaa51 = g_imaa.imaa51
   LET l_direct2='U'
   LET l_direct3='U'
     
RETURN TRUE
END FUNCTION

FUNCTION i153_imaa88_check()
#imaa88 的單位 imaa44
DEFINE l_direct2       LIKE type_file.chr1,
       l_direct3       LIKE type_file.chr1
   IF NOT cl_null(g_imaa.imaa44) AND NOT cl_null(g_imaa.imaa88) THEN
      IF cl_null(g_imaa_t.imaa88) OR cl_null(g_imaa44_t) OR g_imaa_t.imaa88 != g_imaa.imaa88 OR g_imaa44_t != g_imaa.imaa44 THEN 
         LET g_imaa.imaa88=s_digqty(g_imaa.imaa88,g_imaa.imaa44)
         DISPLAY BY NAME g_imaa.imaa88  
      END IF  
   END IF
   IF g_imaa.imaa88 <= 0 THEN  
      CALL cl_err(g_imaa.imaa88,'mfg1322',0)
      LET g_imaa.imaa88 = g_imaa_o.imaa88
      DISPLAY BY NAME g_imaa.imaa88
      RETURN FALSE
   END IF
   LET g_imaa_o.imaa88 = g_imaa.imaa88
   LET l_direct2='U'
   LET l_direct3='U'
   
RETURN TRUE   
END FUNCTION

FUNCTION i153_imaa99_check()
#imaa99 的單位 imaa44
   IF NOT cl_null(g_imaa.imaa44) AND NOT cl_null(g_imaa.imaa99) THEN
      IF cl_null(g_imaa_t.imaa99) OR cl_null(g_imaa44_t) OR g_imaa_t.imaa99 != g_imaa.imaa99 OR g_imaa44_t != g_imaa.imaa44 THEN 
         LET g_imaa.imaa99=s_digqty(g_imaa.imaa99,g_imaa.imaa44)
         DISPLAY BY NAME g_imaa.imaa99  
      END IF  
   END IF
   IF g_imaa.imaa99 <= 0 THEN 
      CALL cl_err(g_imaa.imaa99,'mfg1322',0)
      LET g_imaa.imaa99 = g_imaa_o.imaa99
      DISPLAY BY NAME g_imaa.imaa99
      RETURN FALSE 
   END IF
   LET g_imaa_o.imaa99 = g_imaa.imaa99
   
RETURN TRUE   
   
END FUNCTION 
#FUN-BB0083---add---end

