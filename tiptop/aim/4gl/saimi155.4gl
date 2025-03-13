# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: saimi155.4gl
# Descriptions...: 料件申請資料維護作業-成本資料
# Date & Author..: No.FUN-670033 06/08/31 By Mandy
# Modify.........: No.FUN-690026 06/09/14 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time改為g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.TQC-750007 07/05/03 By Mandy #狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: No.MOD-780100 07/08/17 By kim 輸入和action的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.TQC-B30009 11/03/02 By destiny 新增時orig,oriu未顯示
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE
    g_argv1             LIKE imaa_file.imaano,
    g_imaa              RECORD LIKE imaa_file.*,
    g_imaa_t            RECORD LIKE imaa_file.*,
    g_imaa_o            RECORD LIKE imaa_file.*,
    g_imaa01_t          LIKE imaa_file.imaa01,
    g_imaano_t          LIKE imaa_file.imaano,
    g_cmd               LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(60)
    g_s                 LIKE type_file.chr1,    #料件處理狀況  #No.FUN-690026 VARCHAR(1)
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_sql          STRING                  #TQC-630166
 
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr1              LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr2              LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr3              LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
FUNCTION aimi155(p_argv1)
    DEFINE  p_argv1         LIKE imaa_file.imaano

    WHENEVER ERROR CALL cl_err_msg_log
 
    INITIALIZE g_imaa.* TO NULL
    INITIALIZE g_imaa_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imaa_file WHERE imaano = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi155_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_argv1 = p_argv1
 
    OPEN WINDOW aimi155_w WITH FORM "aim/42f/aimi155"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN CALL aimi155_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi155_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi155_w
END FUNCTION
 
FUNCTION aimi155_curs()
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
       INITIALIZE g_imaa.* TO NULL  
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           imaa00  ,imaano  ,imaa01  ,imaa02  ,imaa08 ,
           imaa25  ,imaa03  ,imaa1010,imaa92  ,imaa34 ,
           imaa39  ,imaa12  ,imaa87  ,imaa871 ,imaa872,
           imaa873 ,imaa874 ,
           imaauser,imaagrup,imaamodu,imaadate,imaaacti
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION CONTROLP
             CASE
               WHEN INFIELD(imaa34) #成本中心
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"   
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_imaa.imaa34
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa34
                    NEXT FIELD imaa34
               WHEN INFIELD(imaa39) #會計科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_imaa.imaa39
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa39
                    NEXT FIELD imaa39
               WHEN INFIELD(imaa12) #其他分群碼四
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azf"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_imaa.imaa12
                    LET g_qryparam.arg1 = "G"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa12
                    NEXT FIELD imaa12
               WHEN INFIELD(imaa87)                       # 成本項目 (imaa86)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smg"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_imaa.imaa87
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa87
                    CALL aimi155_imaa87('d')
                    NEXT FIELD imaa87
               WHEN INFIELD(imaa872)           #材料製造費用成本項目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smg"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_imaa.imaa872
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa872
                    CALL aimi155_imaa872('d')
                    NEXT FIELD imaa872
               WHEN INFIELD(imaa874)           #人工製造費用成本項目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smg"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_imaa.imaa874
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa874
                    CALL aimi155_imaa874('d')
                    NEXT FIELD imaa874
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
 
      #LET g_s=NULL
      #INPUT g_s   WITHOUT DEFAULTS FROM s
      #   AFTER FIELD s  #資料處理狀況
      #      IF g_s NOT MATCHES '[YN]' THEN
      #         NEXT FIELD s
      #      END IF
 
      #   ON IDLE g_idle_seconds
      #      CALL cl_on_idle()
      #      CONTINUE INPUT
 
      #   ON ACTION about         #MOD-4C0121
      #      CALL cl_about()      #MOD-4C0121
     
      #   ON ACTION help          #MOD-4C0121
      #      CALL cl_show_help()  #MOD-4C0121
     
      #   ON ACTION controlg      #MOD-4C0121
      #      CALL cl_cmdask()     #MOD-4C0121
 
      #END INPUT
      #IF INT_FLAG THEN RETURN END IF
      #IF g_s IS NOT NULL THEN
      #   LET g_wc=g_wc CLIPPED," AND imaa93[5,5] matches '",g_s,"' "
      #END IF
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
    PREPARE aimi155_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE aimi155_curs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi155_prepare
    LET g_sql="SELECT COUNT(*) FROM imaa_file WHERE ",g_wc CLIPPED
    PREPARE aimi155_precount FROM g_sql
    DECLARE aimi155_count CURSOR FOR aimi155_precount
END FUNCTION
 
FUNCTION aimi155_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi155_q()
            END IF
        ON ACTION next
            CALL aimi155_fetch('N')
        ON ACTION previous
            CALL aimi155_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi155_u()
            END IF
       #ON ACTION cost_element
       #    LET g_action_choice="cost_element"
       #    IF cl_chk_act_auth() AND g_imaa.imaa01 IS NOT NULL
       #       THEN LET g_cmd = "aimi106 ",g_imaa.imaa01
       #            CALL  cl_cmdrun(g_cmd)
       #    END IF
       #ON ACTION cost_artical
       #    LET g_action_choice="cost_artical"
       #    IF cl_chk_act_auth() AND g_imaa.imaa01 IS NOT NULL
       #       THEN LET g_cmd = "aimi107 ",g_imaa.imaa01
       #            CALL  cl_cmdrun(g_cmd)
       #    END IF
       #ON ACTION output
       #    LET g_action_choice="output"
       #    IF cl_chk_act_auth()
       #       THEN #CALL aimi155_out()
       #    END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   
            CALL i155_show_pic() #圖形顯示
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL aimi155_fetch('/')
        ON ACTION first
            CALL aimi155_fetch('F')
        ON ACTION last
            CALL aimi155_fetch('L')
 
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
    CLOSE aimi155_curs
END FUNCTION
 
 
FUNCTION aimi155_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct1       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct2       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct3       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #是否必要欄位有輸入  #No.FUN-690026 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(80)
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    DISPLAY BY NAME g_imaa.imaauser,g_imaa.imaagrup,
      g_imaa.imaadate, g_imaa.imaaacti,
      g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
    DISPLAY g_s TO FORMONLY.s
    INPUT BY NAME
         g_imaa.imaa00  ,g_imaa.imaano  ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa08 ,
         g_imaa.imaa25  ,g_imaa.imaa03  ,g_imaa.imaa1010,g_imaa.imaa92  ,g_imaa.imaa34 ,
         g_imaa.imaa39  ,g_imaa.imaa12  ,g_imaa.imaa87  ,g_imaa.imaa871 ,g_imaa.imaa872,
         g_imaa.imaa873 ,g_imaa.imaa874 ,
         g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti
 
      WITHOUT DEFAULTS
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i155_set_entry(p_cmd)                #No.FUN-570110
          CALL i155_set_no_entry(p_cmd)                #No.FUN-570110
          LET g_before_input_done = TRUE
 
       AFTER FIELD imaa34     #成本中心
           IF g_imaa.imaa34 IS NOT NULL THEN
              IF (g_imaa_o.imaa34 IS NULL) OR (g_imaa_o.imaa34 != g_imaa.imaa34) THEN
                 CALL aimi155_imaa34('a')
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err(g_imaa.imaa34,'mfg1318',0)
                    LET g_imaa.imaa34 = g_imaa_o.imaa34
                    DISPLAY BY NAME g_imaa.imaa34
                    NEXT FIELD imaa34
                 END IF
              END IF
           ELSE
              DISPLAY NULL TO FORMONLY.gem02 #MOD-780100
           END IF
           LET g_imaa_o.imaa34 = g_imaa.imaa34
           LET l_direct = 'U'
 
        AFTER FIELD imaa39  #會計科目, 可空白, 須存在
            IF g_imaa.imaa39 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_imaa.imaa39,g_aza.aza81) THEN  #No.FUN-730033
                    CALL cl_err(g_imaa.imaa39,'mfg0018',0)
                    #FUN-B10049--begin
                    CALL cl_init_qry_var()                                         
                    LET g_qryparam.form ="q_aag"                                   
                    LET g_qryparam.default1 = g_imaa.imaa39 
                    LET g_qryparam.construct = 'N'                
                    LET g_qryparam.arg1 = g_aza.aza81  
                    LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imaa.imaa39 CLIPPED,"%' "                                                                        
                    CALL cl_create_qry() RETURNING g_imaa.imaa39
                    DISPLAY BY NAME g_imaa.imaa39  
                    #FUN-B10049--end                            
                    NEXT FIELD imaa39
                END IF
               END IF
            END IF
            LET g_imaa_o.imaa39 = g_imaa.imaa39
            LET l_direct = 'U'
            LET l_direct1 = 'D'
 
        AFTER FIELD imaa12                     #其他分群碼四
             IF NOT cl_null(g_imaa.imaa12) THEN
                 IF (g_imaa_o.imaa12 IS NULL) OR
                    (g_imaa_o.imaa12 != g_imaa.imaa12) THEN
                      SELECT azf01 FROM azf_file
                       WHERE azf01=g_imaa.imaa12 AND azf02='G' #6818
                         AND azfacti='Y'
                      IF SQLCA.sqlcode  THEN
                         CALL cl_err3("sel","azf_file",g_imaa.imaa12,"",
                                      "mfg1306","","",1)
                          LET g_imaa.imaa12 = g_imaa_o.imaa12
                          DISPLAY BY NAME g_imaa.imaa12
                          NEXT FIELD imaa12
                      END IF
                 END IF
             END IF
             LET g_imaa_o.imaa12 = g_imaa.imaa12
 
        AFTER FIELD imaa87          #成本項目
             IF g_imaa.imaa87 IS NOT NULL  AND g_imaa.imaa87 != ' '
                THEN IF (g_imaa_o.imaa87 IS NULL) OR
                             (g_imaa.imaa87 != g_imaa_o.imaa87)
                        THEN CALL aimi155_imaa87('a')
                             IF g_chr = 'E'
                               THEN CALL cl_err(g_imaa.imaa87,'mfg1313',0)
                                    LET g_imaa.imaa87 = g_imaa_o.imaa87
                                    DISPLAY BY NAME g_imaa.imaa87
                                    NEXT FIELD imaa87
                             END IF
                     END IF
             ELSE
                DISPLAY NULL TO FORMONLY.smg02_1 #MOD-780100
             END IF
            LET g_imaa_o.imaa87 = g_imaa.imaa87
            LET l_direct1 = 'U'
 
        AFTER FIELD imaa871      #材料造費用分攤率
             IF g_imaa.imaa871 < 0
                THEN CALL cl_err(g_imaa.imaa871,'mfg0013',0)
                     LET g_imaa.imaa871 = g_imaa_o.imaa871
                     DISPLAY BY NAME g_imaa.imaa871
                     NEXT FIELD imaa871
             END IF
            LET g_imaa_o.imaa871 = g_imaa.imaa871
            LET l_direct1 = 'U'
            LET l_direct2 = 'D'
 
        AFTER FIELD imaa872          #材料製造費用成本項目
            IF (g_imaa_o.imaa872 IS NULL) OR #genero
               (g_imaa.imaa872 != g_imaa_o.imaa872) THEN
                 CALL aimi155_imaa872('a')
                 IF g_chr = 'E' THEN
                     CALL cl_err(g_imaa.imaa872,'mfg1313',0)
                     LET g_imaa.imaa872 = g_imaa_o.imaa872
                     DISPLAY BY NAME g_imaa.imaa872
                     NEXT FIELD imaa872
                 END IF
            ELSE
               DISPLAY NULL TO FORMONLY.smg02_2 #MOD-780100
            END IF
            LET g_imaa_o.imaa872 = g_imaa.imaa872
            LET l_direct2 = 'U'
 
        AFTER FIELD imaa873
             IF g_imaa.imaa873 < 0
                THEN CALL cl_err(g_imaa.imaa873,'mfg0013',0)
                     LET g_imaa.imaa873 = g_imaa_o.imaa873
                     DISPLAY BY NAME g_imaa.imaa873
                     NEXT FIELD imaa873
             END IF
            LET g_imaa_o.imaa873 = g_imaa.imaa873
            LET l_direct2 = 'U'
            LET l_direct3 = 'D'
 
        AFTER FIELD imaa874          #人工製造費用成本項目
             IF (g_imaa_o.imaa874 IS NULL) OR
                (g_imaa.imaa874 != g_imaa_o.imaa874) THEN
                 CALL aimi155_imaa874('a')
                 IF g_chr = 'E' THEN
                     CALL cl_err(g_imaa.imaa874,'mfg1313',0)
                     LET g_imaa.imaa874 = g_imaa_o.imaa874
                     DISPLAY BY NAME g_imaa.imaa874
                     NEXT FIELD imaa874
                 END IF
             ELSE
                DISPLAY NULL TO FORMONLY.smg02_3 #MOD-780100
             END IF
            LET g_imaa_o.imaa874 = g_imaa.imaa874
            LET l_direct = 'U'
 
        AFTER INPUT
           LET g_imaa.imaauser = s_get_data_owner("imaa_file") #FUN-C10039
           LET g_imaa.imaagrup = s_get_data_group("imaa_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_imaa.imaa01 IS NULL THEN  #料件編號
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa01
            END IF
            IF g_imaa.imaa871 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa871
            END IF
            IF g_imaa.imaa873 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imaa.imaa873
            END IF
           #MOD-780100 mark begin
           #IF g_sma.sma58 = 'Y' AND g_imaa.imaa87 IS NULL  THEN
           #   LET l_flag='Y'
           #   DISPLAY BY NAME g_imaa.imaa87
           #END IF
           #IF g_sma.sma58 = 'Y' AND g_imaa.imaa871>0 AND
           #   g_imaa.imaa872 IS NULL  THEN LET l_flag='Y'
           #   DISPLAY BY NAME g_imaa.imaa872
           #END IF
 
           #IF g_sma.sma58 = 'Y' AND g_imaa.imaa873 >0 AND
           #   g_imaa.imaa874  IS NULL THEN
           #   LET l_flag='Y'
           #   DISPLAY BY NAME g_imaa.imaa874
           #END IF
           #MOD-780100 mark end
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imaa87
            END IF
 
       #MOD-780100 mark
       #ON ACTION mntn_cost_center
       #            CALL cl_cmdrun("acsi400 ")
 
        ON ACTION mntn_cost_item
                    CALL cl_cmdrun("asms150 ")
 
        ON ACTION mntn_group_code
                    LET l_cmd="aooi312 "
                    CALL cl_cmdrun(l_cmd CLIPPED)
 
       #ON ACTION prt_item_group_code
       #   LET g_msg = 'imaa01="',g_imaa.imaa01,'" '
       #   LET g_msg = "aimr182 '",g_today,"' '",g_user,"' '",g_lang,"' ",
       #               " 'Y' ' ' '1' ", 
       #               " '",g_msg,"' "
       #   CALL cl_cmdrun(g_msg)
       #  #TQC-610072-end
 
        ON ACTION mntn_unit
                    CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
                    CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv
                    CALL cl_cmdrun("aooi103 ")
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imaa34) #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"   
                  LET g_qryparam.default1 = g_imaa.imaa34
                  CALL cl_create_qry() RETURNING g_imaa.imaa34
                  DISPLAY BY NAME g_imaa.imaa34
                  NEXT FIELD imaa34
               WHEN INFIELD(imaa39) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa39
                  LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_imaa.imaa39
                  DISPLAY BY NAME g_imaa.imaa39
                  NEXT FIELD imaa39
               WHEN INFIELD(imaa12) #其他分群碼四
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa12
                  LET g_qryparam.arg1 = "G"
                  CALL cl_create_qry() RETURNING g_imaa.imaa12
                  DISPLAY BY NAME g_imaa.imaa12
                  NEXT FIELD imaa12
               WHEN INFIELD(imaa87)                       # 成本項目 (imaa86)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smg"
                  LET g_qryparam.default1 = g_imaa.imaa87
                  CALL cl_create_qry() RETURNING g_imaa.imaa87
                  DISPLAY BY NAME g_imaa.imaa87
                 CALL aimi155_imaa87('d')
                 NEXT FIELD imaa87
               WHEN INFIELD(imaa872)           #材料製造費用成本項目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_smg"
                 LET g_qryparam.default1 = g_imaa.imaa872
                 CALL cl_create_qry() RETURNING g_imaa.imaa872
                 DISPLAY BY NAME g_imaa.imaa872
                 CALL aimi155_imaa872('d')
                 NEXT FIELD imaa872
               WHEN INFIELD(imaa874)           #人工製造費用成本項目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_smg"
                 LET g_qryparam.default1 = g_imaa.imaa874
                 CALL cl_create_qry() RETURNING g_imaa.imaa874
                 DISPLAY BY NAME g_imaa.imaa874
                 CALL aimi155_imaa874('d')
                 NEXT FIELD imaa874
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
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
 
    END INPUT
END FUNCTION
 
FUNCTION aimi155_imaa34(p_cmd)    #成本中心
    DEFINE  p_cmd     LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
    DEFINE  l_gem02   LIKE gem_file.gem02 
    DEFINE  l_gemacti LIKE gem_file.gemacti
 
    LET g_chr = ' '
    IF g_imaa.imaa34 IS NULL THEN
      #LET g_chr = 'E' #MOD-780100
       LET g_chr = ' ' #MOD-780100
       LET l_gem02 = NULL   
    ELSE 
       SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
        WHERE gem01 = g_imaa.imaa34
       IF SQLCA.sqlcode THEN
          LET l_gem02 = NULL   #FUN-570015
          LET g_chr = 'E'
       ELSE 
          IF l_gemacti matches'[Nn]' THEN LET g_chr = 'E' END IF   #FUN-570015
       END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO gem02   #FUN-570015 
    END IF
 
END FUNCTION
 
FUNCTION aimi155_imaa87(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_imaa.imaa87 IS NULL
      THEN #LET g_chr = 'E' #MOD-780100
           LET g_chr=' ' #MOD-780100
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_imaa.imaa87
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_1
    END IF
END FUNCTION
 
FUNCTION aimi155_imaa872(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_imaa.imaa872 IS NULL
      THEN #LET g_chr = 'E' #MOD-780100
           LET g_chr=' ' #MOD-780100
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_imaa.imaa872
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_2
    END IF
END FUNCTION
 
FUNCTION aimi155_imaa874(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_imaa.imaa874 IS NULL
      THEN #LET g_chr = 'E' #MOD-780100
           LET g_chr=' ' #MOD-780100
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_imaa.imaa874
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_3
    END IF
END FUNCTION
 
FUNCTION aimi155_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi155_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi155_count
    FETCH aimi155_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi155_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        INITIALIZE g_imaa.* TO NULL
    ELSE
        CALL aimi155_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi155_fetch(p_flimaa)
    DEFINE
        p_flimaa          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimaa
        WHEN 'N' FETCH NEXT     aimi155_curs INTO g_imaa.imaano
        WHEN 'P' FETCH PREVIOUS aimi155_curs INTO g_imaa.imaano
        WHEN 'F' FETCH FIRST    aimi155_curs INTO g_imaa.imaano
        WHEN 'L' FETCH LAST     aimi155_curs INTO g_imaa.imaano
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
            FETCH ABSOLUTE g_jump aimi155_curs INTO g_imaa.imaano
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
        CALL aimi155_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi155_show()
 
    LET g_imaa_t.* = g_imaa.*
    LET g_s=g_imaa.imaa93[5,5]
    DISPLAY g_s TO FORMONLY.s
    DISPLAY BY NAME
         g_imaa.imaa00  ,g_imaa.imaano  ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa08 ,
         g_imaa.imaa25  ,g_imaa.imaa03  ,g_imaa.imaa1010,g_imaa.imaa92  ,g_imaa.imaa34 ,
         g_imaa.imaa39  ,g_imaa.imaa12  ,g_imaa.imaa87  ,g_imaa.imaa871 ,g_imaa.imaa872,
         g_imaa.imaa873 ,g_imaa.imaa874 ,
         g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti,
         g_imaa.imaaoriu,g_imaa.imaaorig   #TQC-B30009
 
    CALL aimi155_imaa34('d')
    CALL aimi155_imaa87('d')
    CALL aimi155_imaa872('d')
    CALL aimi155_imaa874('d')
    CALL cl_show_fld_cont()                   
    CALL i155_show_pic() #圖形顯示
END FUNCTION
 
FUNCTION aimi155_u()
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
 
    OPEN aimi155_curl USING g_imaa.imaano
    IF STATUS THEN
       CALL cl_err("OPEN aimi155_curl:", STATUS, 1)
       CLOSE aimi155_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi155_curl INTO g_imaa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imaa.imaamodu = g_user                   #修改者
    LET g_imaa.imaadate = g_today                  #修改日期
    CALL aimi155_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi155_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imaa.*=g_imaa_t.*
            CALL aimi155_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_imaa.imaa93[5,5] = 'Y'
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
        DISPLAY 'Y' TO FORMONLY.s
        EXIT WHILE
    END WHILE
    CLOSE aimi155_curl
    COMMIT WORK  
    #TQC-750007---add---str--
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
    CALL aimi155_show()                                            
    #TQC-750007---add---end--
END FUNCTION
 
{
FUNCTION aimi155_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        sr              RECORD LIKE imaa_file.*,
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
        LET g_wc=" imaa01='",g_imaa.imaa01,"'"
    END IF
    CALL cl_wait()
    CALL cl_outnam('aimi155') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM imaa_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE aimi155_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi155_curo                         # CURSOR
        CURSOR FOR aimi155_p1
 
    START REPORT aimi155_rep TO l_name
 
    FOREACH aimi155_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT aimi155_rep(sr.*)
    END FOREACH
 
    FINISH REPORT aimi155_rep
 
    CLOSE aimi155_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT aimi155_rep(sr)
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
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[37] #FUN-560183 del ,g_x[36]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            IF sr.imaaacti = 'N' THEN
                PRINT COLUMN g_c[31],'*';
            ELSE
                PRINT COLUMN g_c[31],' ';
            END IF
            PRINT COLUMN g_c[32],sr.imaa01,
                  COLUMN g_c[33],sr.imaa02,
                  COLUMN g_c[34],sr.imaa021,
                  COLUMN g_c[35],sr.imaa87,
                 #COLUMN g_c[36],sr.imaa86,
                  COLUMN g_c[37],sr.imaa12
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash2
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[37], g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash2
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[37], g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
 
FUNCTION i155_set_no_entry(p_cmd)
DEFINE    p_cmd    LIKE type_file.chr1          #No.FUN-690026 VARCHAR(1)
   CASE
       WHEN NOT g_before_input_done
              IF g_sma.sma23 not matches'[13]'  THEN
                  CALL cl_set_comp_entry("imaa34",FALSE)
              END IF
              IF g_sma.sma58 = 'N'  THEN
                  CALL cl_set_comp_entry("imaa87,imaa872,imaa874",FALSE)
              END IF
              IF p_cmd = 'u' AND g_chkey = 'N' THEN
                  CALL cl_set_comp_entry("imaa01",FALSE)
              END IF
   END CASE
END FUNCTION
 
FUNCTION i155_set_entry(p_cmd)
DEFINE    p_cmd    LIKE type_file.chr1          #No.FUN-690026 VARCHAR(1)
   CASE
       WHEN NOT g_before_input_done
            CALL cl_set_comp_entry("imaa34,imaa87,imaa872,imaa874",TRUE)
              IF p_cmd = 'a' THEN
                  CALL cl_set_comp_entry("imaa01",TRUE)
              END IF
   END CASE
END FUNCTION
 
FUNCTION i155_show_pic()
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
 

