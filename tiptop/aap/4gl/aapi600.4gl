# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Descriptions...: 雜項廠商基本資料維護作業
# Date & Author..: 92/12/28 By Keith
#        Modify  : 93/01/17 By David
#                  (廠商若為EMPL或MISC時可不輸入統一編號)
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0097 04/12/22 By Nicola 報表架構修改
# Modify.........: No.FUN-570158 05/08/09 By Sarah 在複製裡增加set_entry段
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690058 06/09/18 By Mandy 廠商申請相關修正
# Modify.........: No.FUN-680046 06/09/29 By jamie 1.FUNCTION i600_q() 一開始應清空g_pmc.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6A0088 06/11/08 By baogui 結束位置調整
# Modify.........: No.MOD-6A0093 06/12/13 By Smapmin 調整開窗資料
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-910005 09/01/05 By chenl   對pmc1920賦值為g_plant
# Modify.........: No.TQC-940038 09/04/05 By dxfwo   MSV bug 處理
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60056 10/06/18 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.TQC-A90128 10/09/27 By Carrier construct时加入oriu/orig字段
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1       LIKE pmc_file.pmc14,  #1.採購廠商(由採購部門維護)  #No.FUN-690028 VARCHAR(1)
                              #          (廠商編號循編號原則)
                              #          (維護程式:aapi6001)
                              #2.雜項廠商(由請款人員維護)(僅用於AP系統)
                              #          (廠商編號建議使用統一編號)
                              #          (維護程式:aapi6002)
                              #3.員工    (由人事系統轉入或臨時輸入)
                              #          (廠商編號建議使用員工編號)
                              #          (維護程式:aapi6003)
    g_pmc   RECORD LIKE pmc_file.*,
    g_pmc_t RECORD LIKE pmc_file.*,
    g_pmc_o RECORD LIKE pmc_file.*,
    g_pmc01_t LIKE pmc_file.pmc01,   #供應廠商編號
    g_pmc24_t LIKE pmc_file.pmc24,   #供應廠商統一編號
    g_choice            LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01)
    g_wc,g_sql          STRING    #TQC-630166
DEFINE g_before_input_done    STRING
DEFINE g_forupd_sql           STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
MAIN
   OPTIONS                                	#改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT				#擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_pmc.* TO NULL
   INITIALIZE g_pmc_t.* TO NULL
   INITIALIZE g_pmc_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM pmc_file  WHERE pmc01 = ?  FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW i600_w WITH FORM "aap/42f/aapi600"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET g_action_choice=""
   CALL i600_menu()
 
   CLOSE WINDOW i600_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i600_cs()
    CLEAR FORM
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        pmc01, pmc24, pmc03, pmc14,pmc05, pmc081,pmc082, #FUN-690058 add pmc05
        pmc17, pmc22, pmc47,
        pmc091,pmc092,pmc093, pmc56,
        pmcuser,pmcgrup,pmcoriu,pmcorig,pmcmodu,pmcdate,pmcacti  #No.TQC-A90128
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
    ON ACTION controlp
       CASE
          #-----MOD-6A0093---------
          #WHEN INFIELD(pmc01) OR INFIELD(pmc24) OR INFIELD(pmc03)
          #     CALL cl_init_qry_var()
          #     LET g_qryparam.state = "c"
          #     LET g_qryparam.form ="q_pmc4"
          #     LET g_qryparam.arg1 = '2'
          #     CALL cl_create_qry() RETURNING g_qryparam.multiret
          #     DISPLAY g_qryparam.multiret TO pmc01
          WHEN INFIELD(pmc01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc4"
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.multiret_index = '1'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc01
          WHEN INFIELD(pmc03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc4"
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.multiret_index = '2'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc03
          #-----END MOD-6A0093-----
 
          WHEN INFIELD(pmc17) #查詢付款條件資料檔(pma_file)
#              CALL q_pma(10,3,g_pmc.pmc17) RETURNING g_pmc.pmc17
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pma"
               LET g_qryparam.default1 = g_pmc.pmc17
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc17
               CALL i600_pmc17(g_pmc.pmc17)
               NEXT FIELD pmc17
          WHEN INFIELD(pmc47) #稅別
#            CALL q_gec(8,7,g_pmc.pmc47,'1') RETURNING g_pmc.pmc47
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gec"
             LET g_qryparam.default1 = g_pmc.pmc47
             LET g_qryparam.arg1 = '1'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmc47
             NEXT FIELD pmc47
          WHEN INFIELD(pmc22) #查詢幣別資料檔
#            CALL q_azi(10,3,g_pmc.pmc22) RETURNING g_pmc.pmc22
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azi"
             LET g_qryparam.default1 = g_pmc.pmc22
             #CALL cl_create_qry() RETURNING g_pmc.pmc22
             #DISPLAY BY NAME g_pmc.pmc22
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmc22
             NEXT FIELD pmc22
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
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc=g_wc clipped," AND pmcuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc=g_wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc=g_wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
    #End:FUN-980030
 
   #IF NOT cl_null(g_argv1) THEN
   #   LET g_wc=g_wc clipped," AND pmc14 = '",g_argv1,"'"
   #END IF
    LET g_sql="SELECT pmc01 FROM pmc_file ", # 組合出 SQL 指令
        " WHERE pmc14 = '2' AND ",g_wc CLIPPED, " ORDER BY pmc01 "
    PREPARE i600_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE i600_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i600_prepare
    LET g_sql =
        "SELECT COUNT(*) FROM pmc_file WHERE pmc14 = '2' AND ",g_wc CLIPPED
    PREPARE i600_precount FROM g_sql
    DECLARE i600_count CURSOR FOR i600_precount
END FUNCTION
 
FUNCTION i600_menu()
  DEFINE      l_cmd    LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(30)
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            #FUN-690058--------mod------
            IF g_aza.aza62 = 'N' THEN #不使用廠商申請作業時,才可按新增! 
                IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
                     CALL i600_a()
                END IF
            ELSE
                CALL cl_err('','axm-231',1)
                #不使用廠商申請作業時,才可按新增!
            END IF
            #FUN-690058--------mod-end--
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i600_q()
            END IF
        ON ACTION next
            CALL i600_fetch('N')
        ON ACTION previous
            CALL i600_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i600_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i600_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i600_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i600_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i600_out()
            END IF
      #@ON ACTION 相關查詢
        ON ACTION related_query
           CALL s_pmcqry(g_pmc.pmc01)
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL i600_fetch('/')
        ON ACTION first
            CALL i600_fetch('F')
        ON ACTION last
            CALL i600_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
        #No.FUN-680046-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_pmc.pmc01 IS NOT NULL THEN
                  LET g_doc.column1 = "pmc01"
                  LET g_doc.value1 = g_pmc.pmc01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-680046-------add--------end---- 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i600_cs
END FUNCTION
 
 
FUNCTION i600_a()
   DEFINE l_pmc22         LIKE aza_file.aza17
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM                                  # 清螢墓欄位內容
    INITIALIZE g_pmc.* LIKE pmc_file.*
    LET g_pmc01_t = NULL
    LET g_pmc24_t = NULL
    LET g_pmc_t.* = g_pmc.*			# 保留舊值
    LET g_pmc_o.* = g_pmc.*		  	# 保留舊值
    LET g_pmc.pmc05 = '0'		  	# 目前狀況
    LET g_pmc.pmc14 = '2'                       # 資料性質
    IF cl_null(g_pmc.pmc14) THEN LET g_pmc.pmc14 = '1' END IF
    LET g_pmc.pmc22 = g_aza.aza17   # 幣別
    LET g_pmc.pmc27 = '1'           # 寄領方式
    LET g_pmc.pmc30 = '3'           # 廠商性質預設為兩者
    LET g_pmc.pmc45 =  0  		    # AP AMT
    LET g_pmc.pmc46 =  0  		    # AP AMT
    LET g_pmc.pmc48 =  'Y'   	    # 禁止背書
    LET g_pmc.pmc54 =  'Y'   	    # 是否轉拋轉為 "本幣應收帳款"
    CALL cl_opmsg('a')
    WHILE TRUE
       #LET g_pmc.pmcacti = 'Y'                 # 有效的資料
        LET g_pmc.pmcacti = 'P'                 # 有效的資料 #FUN-690058
        LET g_pmc.pmcuser = g_user		# 使用者
        LET g_pmc.pmcoriu = g_user #FUN-980030
        LET g_pmc.pmcorig = g_grup #FUN-980030
        LET g_pmc.pmcgrup = g_grup              # 使用者所屬群
        LET g_pmc.pmcdate = g_today		# 更改日期
        LET g_pmc.pmc1920 = g_plant             #資料來源    #No.CHI-910005
        CALL i600_i("a")                     # 各欄位輸入
        IF INT_FLAG THEN                        # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_pmc.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_pmc.pmc01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO pmc_file VALUES(g_pmc.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("ins","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        ELSE
            LET g_pmc_t.* = g_pmc.*              # 保存上筆資料
            SELECT pmc01 INTO g_pmc.pmc01 FROM pmc_file
                WHERE pmc01 = g_pmc.pmc01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i600_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,  		 #狀態  #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690028 VARCHAR(1)
        l_direct        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)		 #INPUT的方向
        l_cmd           LIKE type_file.chr1000,     #No.FUN-690028 VARCHAR(30)
        g_msg           LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(80)
        l_msg           LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(80)
        l_pmc22         LIKE aza_file.aza17,	 #幣別
        l_pmc03         LIKE pmc_file.pmc03,	 #簡稱
        l_pmc06         LIKE pmc_file.pmc06,	 #區域代號
        #x1,x2	 VARCHAR(10),                #FUN-660117 remark
        x1              LIKE pmc_file.pmc01,     #FUN-660117
        x2		LIKE pmc_file.pmc03,     #FUN-660117
        l_n,l_cnt       LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    INPUT BY NAME g_pmc.pmcoriu,g_pmc.pmcorig,
      g_pmc.pmc01, g_pmc.pmc24, g_pmc.pmc03, g_pmc.pmc14,
      g_pmc.pmc081,g_pmc.pmc082,
      g_pmc.pmc17, g_pmc.pmc22, g_pmc.pmc47,
      g_pmc.pmc091,g_pmc.pmc092,g_pmc.pmc093,g_pmc.pmc56,
      g_pmc.pmcuser,g_pmc.pmcgrup,g_pmc.pmcmodu,g_pmc.pmcdate,g_pmc.pmcacti
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
        AFTER FIELD pmc01
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_pmc.pmc01 != g_pmc01_t) THEN
                SELECT COUNT(*) INTO l_n FROM pmc_file      --> FOR pmc_file
                    WHERE pmc01 = g_pmc.pmc01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_pmc.pmc01,-239,0)
                    LET g_pmc.pmc01 = g_pmc01_t
                    DISPLAY BY NAME g_pmc.pmc01
                    NEXT FIELD pmc01
                ELSE
                    IF g_pmc.pmc30='3' THEN
                       LET g_pmc.pmc04=g_pmc.pmc01
                    END IF
                END IF
            END IF
            IF g_argv1='2' AND g_pmc.pmc24 IS NULL THEN
               LET g_pmc.pmc24=g_pmc.pmc01
               DISPLAY BY NAME g_pmc.pmc24
            END IF
 
        AFTER FIELD pmc03
            IF cl_null(g_pmc.pmc081)  THEN
               LET g_pmc.pmc081=g_pmc.pmc03
               DISPLAY BY NAME g_pmc.pmc081
            END IF
 
        BEFORE FIELD pmc14                       #資料性質
          IF NOT cl_null(g_argv1) THEN
#         IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
          END IF
        AFTER FIELD pmc14                       #資料性質
          CALL s_datype(g_pmc.pmc14) RETURNING l_msg
          DISPLAY l_msg TO FORMONLY.desc3
 
        AFTER FIELD pmc24
           #--------------------------------------- 統編不可重複 (970710 roger)
           IF g_pmc.pmc24 IS NOT NULL THEN
             IF g_pmc_o.pmc24 IS NULL OR g_pmc_o.pmc24 <> g_pmc.pmc24 THEN
                SELECT pmc01,pmc03 INTO x1,x2 FROM pmc_file
                       WHERE pmc24=g_pmc.pmc24 AND pmc01<>g_pmc.pmc01
                CASE WHEN SQLCA.SQLCODE=0
 #No.MOD-580325-begin
#                         CALL cl_err(x1,'aap-994',1)  #No.FUN-660122
                          CALL cl_err3("sel","pmc_file",g_pmc.pmc24,"","aap-994","","",1)  #No.FUN-660122
#                         ERROR "該統一編號的廠商資料已存在,廠商編號:",x1,x2
 #No.MOD-580325-end
                          NEXT FIELD pmc24
                     WHEN SQLCA.SQLCODE=100
                     OTHERWISE
#                         CALL cl_err('sel pmc24:',SQLCA.SQLCODE,0)
                          CALL cl_err3("sel","pmc_file",g_pmc.pmc24,"",SQLCA.sqlcode,"","sel pmc24",1)  #No.FUN-660122
                          NEXT FIELD pmc24
                END CASE
             END IF
           END IF
           #-------------------------------------------------------
           IF g_pmc.pmc01!='EMPL' AND g_pmc.pmc01!='MISC' THEN    #85-09-23
            IF g_aza.aza21 = 'Y' AND cl_numchk(g_pmc.pmc24,8) THEN
               IF NOT s_chkban(g_pmc.pmc24) THEN
                  CALL cl_err(g_pmc.pmc24,'aoo-080',0) NEXT FIELD pmc24
               END IF
            END IF
           END IF
           LET g_pmc_o.pmc24 = g_pmc.pmc24
 
        AFTER FIELD pmc091
           IF cl_null(g_pmc.pmc52) THEN LET g_pmc.pmc52 = g_pmc.pmc091 END IF
           IF cl_null(g_pmc.pmc53) THEN LET g_pmc.pmc53 = g_pmc.pmc091 END IF
        AFTER FIELD pmc22  		        #幣別
           IF NOT cl_null(g_pmc.pmc22) THEN
              IF cl_null(g_pmc_o.pmc22) OR cl_null(g_pmc_t.pmc22)
                 OR  (g_pmc.pmc22 != g_pmc_o.pmc22 OR g_pmc.pmc22 = ' ' )
              THEN CALL i600_pmc22(g_pmc.pmc22)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_pmc.pmc22,g_errno,0)
                      LET g_pmc.pmc22 = g_pmc_o.pmc22
                      DISPLAY BY NAME g_pmc.pmc22
                      NEXT FIELD pmc22
                   END IF
              END IF
            END IF
            LET l_direct = "U"
            LET g_pmc_o.pmc22 = g_pmc.pmc22
 
        AFTER FIELD pmc47  		        #稅別
           IF NOT cl_null(g_pmc.pmc47) THEN
              IF cl_null(g_pmc_o.pmc47) OR cl_null(g_pmc_t.pmc47)
                 OR  (g_pmc.pmc47 != g_pmc_o.pmc47 OR g_pmc.pmc47 = ' ' )
              THEN CALL i600_pmc47(g_pmc.pmc47)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_pmc.pmc47,g_errno,0)
                      LET g_pmc.pmc47 = g_pmc_o.pmc47
                      DISPLAY BY NAME g_pmc.pmc47
                      NEXT FIELD pmc47
                   END IF
              END IF
            END IF
            LET g_pmc_o.pmc47 = g_pmc.pmc47
 
        AFTER FIELD pmc17                       #付款條件
           IF g_pmc.pmc05='0' OR NOT cl_null(g_pmc.pmc17) THEN
            # IF (g_pmc_o.pmc17 IS NULL) OR (g_pmc.pmc17 != g_pmc_o.pmc17) THEN
                 CALL i600_pmc17(g_pmc.pmc17)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pmc.pmc17,g_errno,0)
                    LET g_pmc.pmc17 = g_pmc_o.pmc17
                    DISPLAY BY NAME g_pmc.pmc17
                    NEXT FIELD pmc17
                 END IF
          #   END IF
              LET g_pmc_o.pmc17 = g_pmc.pmc17
           END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_pmc.pmcuser = s_get_data_owner("pmc_file") #FUN-C10039
           LET g_pmc.pmcgrup = s_get_data_group("pmc_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_pmc.pmc01) THEN  #廠商編號
                LET l_flag='Y'
                DISPLAY BY NAME g_pmc.pmc01
            END IF
            IF cl_null(g_pmc.pmc03) THEN  #簡稱
                LET l_flag = 'Y'
                DISPLAY BY NAME g_pmc.pmc03
            END IF
            IF cl_null(g_pmc.pmc14) THEN  #
                LET l_flag = 'Y'
                DISPLAY BY NAME g_pmc.pmc14
            END IF
            IF cl_null(g_pmc.pmc22) THEN  #幣別
                LET l_flag = 'Y'
                DISPLAY BY NAME g_pmc.pmc22
            END IF
            IF cl_null(g_pmc.pmc47) THEN  #稅別
                LET l_flag = 'Y'
                DISPLAY BY NAME g_pmc.pmc47
            END IF
            IF cl_null(g_pmc.pmc17) AND g_pmc.pmc05 ='0' THEN  #VAT 特性
                LET l_flag = 'Y'
                DISPLAY BY NAME g_pmc.pmc17
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD pmc01
            END IF
 
 		ON KEY(F1) NEXT FIELD pmc01
 		ON KEY(F2) NEXT FIELD pmc091
 
        #-----FUN-630081---------
        #ON ACTION CONTROLO
        #    IF INFIELD(pmc01) THEN
        #        LET g_pmc.* = g_pmc_t.*
        #        CALL i600_show()
        #        NEXT FIELD pmc01
        #    END IF
        #-----END FUN-630081-----
 
        ON ACTION controlp
           CASE
              #-----MOD-6A0093---------
              #WHEN INFIELD(pmc01) OR INFIELD(pmc24) OR INFIELD(pmc03)
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form ="q_pmc4"
              #     LET g_qryparam.default1 = ''
              #     LET g_qryparam.arg1 = '2'
              #     CALL cl_create_qry() RETURNING g_pmc.pmc01
#             #      CALL FGL_DIALOG_SETBUFFER( g_pmc.pmc01 )
              #     DISPLAY BY NAME g_pmc.pmc01
              #     NEXT FIELD pmc01
              WHEN INFIELD(pmc01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pmc4"
                   LET g_qryparam.default1 = g_pmc.pmc01
                   LET g_qryparam.default2 = g_pmc.pmc03
                   LET g_qryparam.arg1 = '2'
                   CALL cl_create_qry() RETURNING g_pmc.pmc01,g_pmc.pmc03
                   DISPLAY BY NAME g_pmc.pmc01,g_pmc.pmc03
                   NEXT FIELD pmc01
              WHEN INFIELD(pmc03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pmc4"
                   LET g_qryparam.default1 = g_pmc.pmc01
                   LET g_qryparam.default2 = g_pmc.pmc03
                   LET g_qryparam.arg1 = '2'
                   CALL cl_create_qry() RETURNING g_pmc.pmc01,g_pmc.pmc03
                   DISPLAY BY NAME g_pmc.pmc01,g_pmc.pmc03
                   NEXT FIELD pmc03
              #-----END MOD-6A0093-----
 
              WHEN INFIELD(pmc17) #查詢付款條件資料檔(pma_file)
#                CALL q_pma(10,3,g_pmc.pmc17) RETURNING g_pmc.pmc17
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pma"
                 LET g_qryparam.default1 = g_pmc.pmc17
                 CALL cl_create_qry() RETURNING g_pmc.pmc17
#                 CALL FGL_DIALOG_SETBUFFER( g_pmc.pmc17 )
                 DISPLAY BY NAME g_pmc.pmc17
                 CALL i600_pmc17(g_pmc.pmc17)
                 NEXT FIELD pmc17
              WHEN INFIELD(pmc47) #稅別
#                CALL q_gec(8,7,g_pmc.pmc47,'1') RETURNING g_pmc.pmc47
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gec"
                 LET g_qryparam.default1 = g_pmc.pmc47
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_pmc.pmc47
#                 CALL FGL_DIALOG_SETBUFFER( g_pmc.pmc47 )
                 DISPLAY BY NAME g_pmc.pmc47
                 NEXT FIELD pmc47
              WHEN INFIELD(pmc22) #查詢幣別資料檔
#                CALL q_azi(10,3,g_pmc.pmc22) RETURNING g_pmc.pmc22
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_pmc.pmc22
                 CALL cl_create_qry() RETURNING g_pmc.pmc22
#                 CALL FGL_DIALOG_SETBUFFER( g_pmc.pmc22 )
                 DISPLAY BY NAME g_pmc.pmc22
                 NEXT FIELD pmc22
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
 
FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmc01",TRUE)
   END IF
   #FUN-690058------add-----
   CALL cl_set_comp_entry("pmc03",TRUE)
   #FUN-690058------end-----
 
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmc01",FALSE)
   END IF
   #FUN-690058------add-----
   #已確認則不能修改廠商簡稱
   IF g_pmc.pmcacti = 'Y' THEN
       CALL cl_set_comp_entry("pmc03",FALSE)
   END IF
   #當參數設定使用廠商申請作業時,修改時不可更改簡稱
   IF g_aza.aza62='Y' AND p_cmd = 'u' THEN
       CALL cl_set_comp_entry("pmc03,pmc081,pmc082",FALSE)
   END IF
   #FUN-690058------end-----
END FUNCTION
 
FUNCTION i600_pmc17(p_cmd)  #付款方式
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_pma02      LIKE pma_file.pma02,
           l_pmaacti LIKE pma_file.pmaacti
 
    LET g_errno = ' '
    SELECT pma02,pmaacti
           INTO l_pma02,l_pmaacti
           FROM pma_file WHERE pma01 = g_pmc.pmc17
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                            LET l_pmaacti = NULL  LET l_pma02=NULL
         WHEN l_pmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_pma02 TO FORMONLY.pma02
END FUNCTION
 
FUNCTION i600_pmc22(p_cmd)  #幣別
 DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
       l_aziacti LIKE azi_file.aziacti
 
LET g_errno = ' '
SELECT aziacti
  INTO l_aziacti
  FROM azi_file WHERE azi01=g_pmc.pmc22
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                            LET l_aziacti = NULL
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i600_pmc47(p_cmd)  #幣別
 DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
       l_gecacti LIKE gec_file.gecacti
 
LET g_errno = ' '
SELECT gecacti
  INTO l_gecacti
  FROM gec_file WHERE gec01=g_pmc.pmc47
                  AND gec011='1'  #進項
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                            LET l_gecacti = NULL
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pmc.* TO NULL             #No.FUN-680046 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i600_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_pmc.* TO NULL
        RETURN
    END IF
    OPEN i600_count
    FETCH i600_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        INITIALIZE g_pmc.* TO NULL
    ELSE
        CALL i600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i600_fetch(p_flpmc)
    DEFINE
        p_flpmc          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flpmc
        WHEN 'N' FETCH NEXT     i600_cs INTO g_pmc.pmc01
        WHEN 'P' FETCH PREVIOUS i600_cs INTO g_pmc.pmc01
        WHEN 'F' FETCH FIRST    i600_cs INTO g_pmc.pmc01
        WHEN 'L' FETCH LAST     i600_cs INTO g_pmc.pmc01
        WHEN '/'
            IF NOT g_no_ask THEN
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
            FETCH ABSOLUTE g_jump i600_cs INTO g_pmc.pmc01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        INITIALIZE g_pmc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flpmc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_pmc.* FROM pmc_file          # 重讀DB,因TEMP有不被更新特性
       WHERE pmc01 = g_pmc.pmc01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660122
       CALL cl_err3("sel","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
       LET g_data_owner = g_pmc.pmcuser     #No.FUN-4C0047
       LET g_data_group = g_pmc.pmcgrup     #No.FUN-4C0047
       CALL i600_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i600_show()
    DEFINE l_msg   LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(30)
    LET g_pmc_t.* = g_pmc.*
    LET g_pmc_o.* = g_pmc.*
    DISPLAY BY NAME g_pmc.pmcoriu,g_pmc.pmcorig,
      g_pmc.pmc01, g_pmc.pmc24, g_pmc.pmc03, g_pmc.pmc14,g_pmc.pmc05,#FUN-690058 add pmc05
      g_pmc.pmc081,g_pmc.pmc081,
      g_pmc.pmc17, g_pmc.pmc22, g_pmc.pmc47,
      g_pmc.pmc091,g_pmc.pmc092,g_pmc.pmc093,g_pmc.pmc56,
      g_pmc.pmcuser,g_pmc.pmcgrup,g_pmc.pmcmodu,g_pmc.pmcdate,g_pmc.pmcacti
      CALL s_datype(g_pmc.pmc14) RETURNING l_msg
      DISPLAY l_msg TO FORMONLY.desc3
    CALL i600_pmc17(g_pmc.pmc17)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s_datype(p_code)
    DEFINE p_code	LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
    DEFINE l_msg	LIKE ze_file.ze03       # No.FUN-690028 VARCHAR(10)
    CASE g_lang
         WHEN '0'
              CASE WHEN p_code='1' LET l_msg='廠商'
                   WHEN p_code='2' LET l_msg='雜項'
                   WHEN p_code='3' LET l_msg='員工'
              END CASE
         WHEN '2'
              CASE WHEN p_code='1' LET l_msg='廠商'
                   WHEN p_code='2' LET l_msg='雜項'
                   WHEN p_code='3' LET l_msg='員工'
              END CASE
         OTHERWISE
              CASE WHEN p_code='1' LET l_msg='VEN.'
                   WHEN p_code='2' LET l_msg='MISC'
                   WHEN p_code='3' LET l_msg='EMPL'
              END CASE
    END CASE
    RETURN l_msg
END FUNCTION
 
FUNCTION i600_u()
	IF s_shut(0) THEN RETURN END IF                #檢查權限
	IF g_pmc.pmc01 IS NULL THEN
	  	CALL cl_err('',-400,0)
	  	RETURN
    END IF
    SELECT * INTO g_pmc.* FROM pmc_file
     WHERE pmc01=g_pmc.pmc01
    IF g_pmc.pmcacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pmc.pmc01,'mfg1000',0)
        RETURN
    END IF
   #FUN-690058-------add-------
    IF g_pmc.pmcacti = 'H' THEN
        #已留置或停止交易,則不能做任何修改!
        CALL cl_err('','axm-223',1)
        RETURN
    END IF
   #FUN-690058-------add-end---
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pmc01_t = g_pmc.pmc01
    LET g_pmc24_t = g_pmc.pmc24
    BEGIN WORK
 
    OPEN i600_cl USING g_pmc.pmc01
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_pmc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_pmc.pmcmodu = g_user                   #修改者
    LET g_pmc.pmcdate = g_today                  #修改日期
    CALL i600_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i600_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pmc.* = g_pmc_t.*
            CALL i600_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pmc_file SET pmc_file.* = g_pmc.*    # 更新DB
            WHERE pmc01 = g_pmc01_t               # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","pmc_file",g_pmc01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        IF g_pmc01_t != g_pmc.pmc01 THEN
           UPDATE pmg_file SET pmg01=g_pmc.pmc01   # 更新供應商備註檔之KEY值
               WHERE pmg01=g_pmc01_t
           IF SQLCA.sqlcode !=0 AND SQLCA.sqlcode != 100 THEN
#              CALL cl_err("pmg",SQLCA.sqlcode,0)   #No.FUN-660122
               CALL cl_err3("upd","pmg_file",g_pmc01_t,"",SQLCA.sqlcode,"","pmg",1)  #No.FUN-660122
               CONTINUE WHILE
           END IF
           UPDATE pmd_file SET pmd01=g_pmc.pmc01 #更新供應商聯絡人資料檔之KEY值
               WHERE pmd01=g_pmc01_t
           IF SQLCA.sqlcode !=0 AND SQLCA.sqlcode != 100 THEN
#              CALL cl_err("pmd",SQLCA.sqlcode,0)   #No.FUN-660122
               CALL cl_err3("upd","pmd_file",g_pmc01_t,"",SQLCA.sqlcode,"","pmd",1)  #No.FUN-660122
               CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_x()
    DEFINE
        l_cnt LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pmc.pmc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i600_cl USING g_pmc.pmc01
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_pmc.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
   #FUN-A60056--mod--str--
   #DECLARE qq CURSOR FOR SELECT COUNT(*) FROM pmm_file
   #           WHERE pmm09 = g_pmc.pmc01 AND pmm25 IN ('X','0','1','2')
   #OPEN qq
   #FETCH qq INTO l_cnt
    LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant,'pmm_file'),
                " WHERE pmm09 = '",g_pmc.pmc01,"'",
                "   AND pmm25 IN ('X','0','1','2')"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    PREPARE sel_pmm_pre1 FROM g_sql
    EXECUTE sel_pmm_pre1 INTO l_cnt
   #FUN-A60056--mod--end
    IF l_cnt > 0 AND g_pmc.pmcacti = "Y" THEN
       CALL cl_err('','mfg3380',0)
       RETURN
    END IF
   #CLOSE qq    #FUN-A60056
 
    CALL i600_show()
    IF cl_exp(0,0,g_pmc.pmcacti) THEN
        LET g_chr = g_pmc.pmcacti
        IF g_pmc.pmcacti = 'Y' THEN
           SELECT COUNT(*) INTO l_cnt FROM pmc_file WHERE pmc04 = g_pmc.pmc01
           IF l_cnt > 0 THEN
              CALL cl_err(g_pmc.pmc01,'mfg3286',0)
              RETURN
           ELSE
              LET g_pmc.pmcacti = 'N'
           END IF
        ELSE
            LET g_pmc.pmcacti = 'Y'
        END IF
        UPDATE pmc_file
            SET pmcacti = g_pmc.pmcacti,
               pmcmodu = g_user, pmcdate = g_today
            WHERE pmc01 = g_pmc.pmc01
        IF SQLCA.SQLERRD[3] = 0 THEN
#           CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            LET g_pmc.pmcacti = g_chr
        END IF
        DISPLAY BY NAME g_pmc.pmcacti
    END IF
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_r()
    DEFINE
        l_cnt LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pmc.pmc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_pmc.* FROM pmc_file
     WHERE pmc01=g_pmc.pmc01
 
   #FUN-A60056--mod--str--
   #DECLARE rr CURSOR FOR SELECT COUNT(*) FROM pmm_file
   #           WHERE pmm09 = g_pmc.pmc01 AND pmm25 IN ('X','0','1','2')
   #OPEN rr
   #FETCH rr INTO l_cnt
    LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant,'pmm_file'),
                " WHERE pmm09 = '",g_pmc.pmc01,"'",
                "   AND pmm25 IN ('X','0','1','2')"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    PREPARE sel_pmm_cou FROM g_sql
    EXECUTE sel_pmm_cou INTO l_cnt
   #FUN-A60056--mod--end
    IF l_cnt > 0 AND g_pmc.pmcacti = "Y" THEN
       CALL cl_err('','mfg3381',0)
       RETURN
    END IF
   #CLOSE rr   #FUN-A60056
    BEGIN WORK
 
    OPEN i600_cl USING g_pmc.pmc01
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_pmc.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i600_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pmc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pmc.pmc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM pmc_file WHERE pmc01 = g_pmc.pmc01
       LET g_msg=TIME
       #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
       #  VALUES ('aapi600',g_user,g_today,g_msg,g_pmc.pmc01,'delete') #FUN-980001 mark
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
         VALUES ('aapi600',g_user,g_today,g_msg,g_pmc.pmc01,'delete',g_plant,g_legal) #FUN-980001 add 
       CLEAR FORM
       OPEN i600_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i600_cl
          CLOSE i600_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i600_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i600_cl
          CLOSE i600_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i600_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i600_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i600_fetch('/')
       END IF
    END IF
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_copy()
    DEFINE
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_pmc   RECORD LIKE pmc_file.*,
        l_newno,l_oldno LIKE pmc_file.pmc01
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pmc.pmc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-570158
    CALL i110_set_entry('a')          #FUN-570158
    LET g_before_input_done = TRUE    #FUN-570158
   #DISPLAY "" AT 1,1
    LET l_pmc.*=g_pmc.*
    INPUT l_newno FROM pmc01
        AFTER FIELD pmc01
            IF l_newno IS NULL THEN
                NEXT FIELD pmc01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM pmc_file
                WHERE pmc01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD pmc01
            END IF
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
        DISPLAY BY NAME g_pmc.pmc01
        RETURN
    END IF
    LET l_pmc.pmc01=l_newno     #資料鍵值
    LET l_pmc.pmcuser=g_user    #資料所有者
    LET l_pmc.pmcgrup=g_grup    #資料所有者所屬群
    LET l_pmc.pmcmodu=NULL      #資料修改日期
    LET l_pmc.pmcdate=g_today   #資料建立日期
    LET l_pmc.pmcacti='Y'       #有效資料
    LET l_pmc.pmcoriu = g_user      #No.FUN-980030 10/01/04
    LET l_pmc.pmcorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO pmc_file VALUES(l_pmc.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("ins","pmc_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_pmc.pmc01
        SELECT pmc_file.* INTO g_pmc.* FROM pmc_file
                       WHERE pmc01 = l_newno
        CALL i600_u()
        #SELECT pmc_file.* INTO g_pmc.* FROM pmc_file  #FUN-C30027
        #               WHERE pmc01 = l_oldno          #FUN-C30027
    END IF
    CALL i600_show()
END FUNCTION
 
FUNCTION i600_out()
   DEFINE
      l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
      sr RECORD LIKE pmc_file.*,
      l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
      l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   LET g_choice = 'N'
#No.TQC-940038 --begin-- 
 
#  OPEN WINDOW i600_ww AT 9,20
#    WITH FORM "aap/42f/aapi600w"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#  CALL cl_ui_locale("aapi600w")
 
#  INPUT g_choice FROM choice
#     AFTER FIELD choice
#        IF cl_null(g_choice) OR g_choice NOT MATCHES '[YN]' THEN
#           NEXT FIELD choice
#        END IF
 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
#
#  END INPUT
 
#  CLOSE WINDOW i600_ww
#No.TQC-940038 --end-- 
 
   CALL cl_wait()
   CALL cl_outnam('aapi600') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql = "SELECT * FROM pmc_file ",         # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED
   PREPARE i600_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i600_co CURSOR FOR i600_p1
 
   START REPORT i600_rep TO l_name
 
   FOREACH i600_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT i600_rep(sr.*)
   END FOREACH
 
   FINISH REPORT i600_rep
 
   CLOSE i600_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
REPORT i600_rep(sr)
   DEFINE
      l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      sr RECORD LIKE pmc_file.*,
      l_pmc03   LIKE pmc_file.pmc03,
      l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.pmc01,sr.pmc04
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT ' '
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         IF sr.pmcacti = 'N' THEN
            PRINT '*';
         END IF
         PRINT COLUMN g_c[31],sr.pmc01,
               COLUMN g_c[32],sr.pmc03,
               COLUMN g_c[33],sr.pmc30,
               COLUMN g_c[34],sr.pmc06,
               COLUMN g_c[35],sr.pmc07,
               COLUMN g_c[36],sr.pmc10,
               COLUMN g_c[37],sr.pmc11
         IF g_choice = 'Y' THEN
            WHILE TRUE
               IF NOT cl_null(sr.pmc091) THEN
                  PRINT COLUMN g_c[32],sr.pmc091;
               ELSE
                  EXIT WHILE
               END IF
               IF NOT cl_null(sr.pmc092) THEN
                  PRINT COLUMN g_c[36],sr.pmc092
               ELSE
                  SKIP 1 LINE
                  EXIT WHILE
               END IF
               IF NOT cl_null(sr.pmc093) THEN
                  PRINT COLUMN g_c[32],sr.pmc093;
               ELSE
                  EXIT WHILE
               END IF
               IF NOT cl_null(sr.pmc094) THEN
                  PRINT COLUMN g_c[36],sr.pmc094
               ELSE
                  SKIP 1 LINE
                  EXIT WHILE
               END IF
               IF NOT cl_null(sr.pmc095) THEN
                  PRINT COLUMN g_c[32],sr.pmc095
               ELSE
                  EXIT WHILE
               END IF
               EXIT WHILE
            END WHILE
            SKIP 1 LINE
         END IF
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN          # 80:70,140,210      132:120,240
            PRINT g_dash[1,g_len]
           #IF g_wc[001,070] > ' ' THEN
      	   #   PRINT COLUMN g_x[31],g_x[8] CLIPPED,
           #         COLUMN g_x[32],g_wc[001,070] CLIPPED
           #END IF
           #IF g_wc[071,140] > ' ' THEN
      	   #   PRINT COLUMN g_x[32],g_wc[071,140] CLIPPED
           #END IF
           #IF g_wc[141,210] > ' ' THEN
      	   #   PRINT COLUMN g_x[32],g_wc[141,210] CLIPPED
           #END IF
            CALL cl_prt_pos_wc(g_wc) #TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
     #   PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[37],g_x[7] CLIPPED     #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9,g_x[7] CLIPPED     #TQC-6A0088
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
         #  PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[6] CLIPPED  #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED  #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
END REPORT
 
 

