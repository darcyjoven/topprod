# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axci010.4gl
# Descriptions...: 單別成會分類設定作業
# Date & Author..: 96/02/15  By  Felicity Tseng
# Modify         : No:8741 03/11/25 By Melody asf系統,性質'4'時, 應default成會分類='3'
# Modify ........: No.MOD-490371 04/09/22 By Melody controlp ...display修改
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0099 05/01/06 By kim 報表轉XML功能
# Modify.........: No.FUN-510041 05/01/31 By Carol 設定雜項異動單據的理由碼所對應的科目( 非存貨科目)
# Modify.........: No.MOD-590048 05/09/05 By Rosayu 按複製按鈕後選擇放棄程式會整個跳出
# Modify.........: No.MOD-610002 06/01/03 By pengu 單別的資料有效碼為"N",查詢出資料後再按U程式會當掉
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680086 06/08/23 By Elva 兩套帳內容修改,新增cxg051,aag021
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730057 07/03/28 By arman 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By arman 使用多功能帳套控制科目二
# Modify.........: NO.TQC-750103 07/05/21 BY yiting 當 aza63='N' ,科目二不應該出現
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770105 07/07/20 By Rayven 數據修改后,查詢資料所有者,資料更改者和最近更改日其值均為NULL值
# Modify.........: No.FUN-840021 08/04/08 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.TQC-970156 09/07/21 By destiny 管控借方明細和貸方明細在借方種類來源選'0'和'4'時只能新增一筆單身資料           
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:CHI-B10041 11/02/08 By sabrina 在畫面上新增單據性質欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_smy_t         RECORD LIKE smy_file.*,
        g_cxg03         LIKE cxg_file.cxg03,
        g_cxg03c        LIKE cxg_file.cxg03,
        g_cxg03_t       LIKE cxg_file.cxg03,
        g_cxg03c_t      LIKE cxg_file.cxg03,
        g_cxg           DYNAMIC ARRAY OF RECORD	#程式變數(Program Variables)
		cxg04		LIKE cxg_file.cxg04,
		azf03		LIKE azf_file.azf03,
		cxg05		LIKE cxg_file.cxg05,
                aag02           LIKE aag_file.aag02,
		cxg051   	LIKE cxg_file.cxg051,  #FUN-680086 add
                aag021          LIKE aag_file.aag02    #FUN-680086 add  
		END RECORD,
        g_cxgc         DYNAMIC ARRAY OF RECORD	#程式變數(Program Variables)
		cxg04c          LIKE cxg_file.cxg04,
		azf03c          LIKE azf_file.azf03,
		cxg05c          LIKE cxg_file.cxg05,
                aag02c          LIKE aag_file.aag02,
		cxg051c  	LIKE cxg_file.cxg051,  #FUN-680086 add
                aag021c         LIKE aag_file.aag02    #FUN-680086 add  
		END RECORD,
	g_cxg_t		RECORD			#程式變數 (舊值)
		cxg04		LIKE cxg_file.cxg04,
		azf03		LIKE azf_file.azf03,
		cxg05		LIKE cxg_file.cxg05,
                aag02           LIKE aag_file.aag02,
		cxg051   	LIKE cxg_file.cxg051,  #FUN-680086 add
                aag021          LIKE aag_file.aag02    #FUN-680086 add  
		END RECORD,
	g_cxgc_t                RECORD			#程式變數 (舊值)
		cxg04c          LIKE cxg_file.cxg04,
		azf03c          LIKE azf_file.azf03,
		cxg05c          LIKE cxg_file.cxg05,
                aag02c          LIKE aag_file.aag02,
		cxg051c  	LIKE cxg_file.cxg051,  #FUN-680086 add
                aag021c         LIKE aag_file.aag02    #FUN-680086 add  
		END RECORD,
#	g_wc,g_wc2,g_sql VARCHAR(600),  #NO.TQC-630166 MARK
	g_wc,g_wc2,g_sql STRING,     #NO.TQC-630166
	g_argv1		LIKE smy_file.smyslip,
        g_gem02         LIKE gem_file.gem02,
	g_rec_b		LIKE type_file.num5,     #No.FUN-680122 SMALLINT,		#單身筆數
	g_rec_b2        LIKE type_file.num5,     #No.FUN-680122 SMALLINT,		#單身筆數
	i		LIKE type_file.num5,     #No.FUN-680122 SMALLINT,		#單身筆數
	l_ac		LIKE type_file.num5      #No.FUN-680122 SMALLINT 		#目前處理的ARRAY CNT
DEFINE  g_cnt          LIKE type_file.num10     #No.FUN-680122 INTEGER
DEFINE  g_i            LIKE type_file.num5      #No.FUN-680122 SMALLINT   #count/index for any purpose
DEFINE  g_msg          LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(72)
DEFINE  g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_row_count    LIKE type_file.num10     #No.FUN-680122 INTEGER
DEFINE  g_curs_index   LIKE type_file.num10     #No.FUN-680122 INTEGER
DEFINE  g_jump         LIKE type_file.num10     #No.FUN-680122 INTEGER
DEFINE  mi_no_ask      LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE  g_before_input_done   STRING
DEFINE  l_table        STRING,                  ### FUN-840021 ###                                                          
        g_str          STRING,                  ### FUN-840021 ###
        g_zemsg        DYNAMIC ARRAY OF STRING  #CHI-B10041 add
DEFINE  g_abm_str      LIKE type_file.num5      #CHI-B10041 add
DEFINE  g_abm_end      LIKE type_file.num5      #CHI-B10041 add
DEFINE  g_aim_str      LIKE type_file.num5      #CHI-B10041 add
DEFINE  g_aim_end      LIKE type_file.num5      #CHI-B10041 add
DEFINE  g_apm_str      LIKE type_file.num5      #CHI-B10041 add
DEFINE  g_apm_end      LIKE type_file.num5      #CHI-B10041 add
DEFINE  g_asf_str      LIKE type_file.num5      #CHI-B10041 add
DEFINE  g_asf_end      LIKE type_file.num5      #CHI-B10041 add
 
MAIN
#     DEFINEl_time LIKE type_file.chr8		    #No.FUN-6A0146
DEFINE p_row,p_col      LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE l_sql            STRING                   #CHI-B10041 add

       OPTIONS				#改變一些系統預設值
       INPUT NO WRAP
       DEFER INTERRUPT			#擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_argv1=ARG_VAL(1)
 
     CALL  cl_used(g_prog,g_time,1)	#計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
 
### *** FUN-840021 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "cxg01.cxg_file.cxg01,",
                "smydesc.smy_file.smydesc,",
                "smydmy1.smy_file.smydmy1,",
                "smydmy2.smy_file.smydmy2,",
                "smy60.smy_file.smy60,",
                "gem02.gem_file.gem02,",
                "cxg02.cxg_file.cxg02,",
                "cxg03.cxg_file.cxg03,",
                "cxg04.cxg_file.cxg04,",
                "azf03.azf_file.azf03,",
                "cxg05.cxg_file.cxg05,",
                "aag02.aag_file.aag02"
    LET l_table = cl_prt_temptable('axci010',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED,       
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
                " VALUES(?, ?, ?, ?, ?, ?,                                                                                             
                         ?, ?, ?, ?, ?, ?)"                                                                                            
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
  #CHI-B10041---add---start---
  #abm
   IF NOT s_industry('slk') THEN
     LET l_sql=
         "SELECT ze03 FROM ze_file ",
         " WHERE ze01 IN ('asm-024','asm-025')",
         "  AND ze02 = '",g_lang,"'",
         " ORDER By ze01 "   
   ELSE  
     LET l_sql=
         "SELECT ze03 FROM ze_file ",
         " WHERE ze01 IN ('asm-024','asm-025','asm-082','asm-083')",
         "  AND ze02 = '",g_lang,"'",
         " ORDER By ze01 "   
   END IF 
   PREPARE i010_ze_abm_pre FROM l_sql
   DECLARE i010_ze_abm_cur CURSOR FOR i010_ze_abm_pre      
   LET g_i = 1
   LET g_abm_str = g_i
   FOREACH i010_ze_abm_cur INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
   END FOREACH
   LET g_abm_end = g_i - 1

  #aim=>
   DECLARE i010_ze_aim_cur CURSOR FOR
       SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-023',
                       'asm-026','asm-027','asm-028','asm-029','asm-030',
                       'asm-031','asm-032','asm-033','asm-034','asm-035',
                       'asm-036','asm-037','asm-038','asm-039',
                       'asm-073','asm-074','asm-081','asm-101')   
          AND ze02 = g_lang
        ORDER By ze01
   LET g_aim_str = g_i
   FOREACH i010_ze_aim_cur INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
   END FOREACH
   LET g_aim_end = g_i - 1

  #apm=>
   DECLARE i010_ze_apm_cur CURSOR FOR
       SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-040','asm-041','asm-042','asm-043','asm-044','asm-045',
                       'asm-046','asm-047','asm-048','asm-049')  
          AND ze02 = g_lang
        ORDER By ze01
   LET g_apm_str = g_i
   FOREACH i010_ze_apm_cur INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
   END FOREACH
   LET g_apm_end = g_i - 1
   
  #asf=>
   IF NOT s_industry('slk') THEN 
     LET l_sql =
         "SELECT ze03 FROM ze_file ",
         " WHERE ze01 IN ('asm-050','asm-051','asm-052','asm-053','asm-054','asm-055',",
         "                'asm-056','asm-057','asm-058','asm-059','asm-060',",
         "                'asm-061','asm-062','asm-063','asm-064','asm-065',",
         "                'asm-066','asm-067','asm-077',",  
         "                'asm-079','asm-080','asm-084',",           
         "                'asm-085','asm-086'",
         "               )    ",
         "  AND ze02 ='", g_lang,"'",
         "  ORDER By ze01"
   ELSE
   	LET l_sql = 
        "SELECT ze03 FROM ze_file ",
         " WHERE ze01 IN ('asm-050','asm-051','asm-052','asm-053','asm-054','asm-055',",
         "                'asm-056','asm-057','asm-058','asm-059','asm-060',",
         "                'asm-061','asm-062','asm-063','asm-064','asm-065',",
         "                'asm-066','asm-067','asm-077',",  
         "                'asm-079','asm-080', ",           
         "                'asm-084','asm-085','asm-086','asm-087','asm-088','asm-089','asm-090'",  
         "               )    ",
         "  AND ze02 ='", g_lang,"'",
         "  ORDER By ze01"
   END IF
   PREPARE i010_ze_asf_pre FROM l_sql
   DECLARE i010_ze_asf_cur CURSOR FOR i010_ze_asf_pre               
   LET g_asf_str = g_i
   FOREACH i010_ze_asf_cur INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
   END FOREACH
   LET g_asf_end = g_i - 1
  #CHI-B10041---add---end---
 
   LET p_row = 4 LET p_col = 26
   OPEN WINDOW i010_w AT p_row,p_col		#顯示畫面
     WITH FORM "axc/42f/axci010"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-680086  --begin
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("cxg051,aag021,cxg051c,aag021c",FALSE) #FUN-680086
    END IF
       CALL cl_set_comp_visible("imaa391",g_aza.aza63='Y')  #NO.TQC-740093
    #FUN-680086  --end
 
    LET g_forupd_sql = "SELECT * FROM smy_file WHERE smyslip =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    IF NOT cl_null(g_argv1) THEN CALL i010_q() END IF
 
    CALL i010_menu()
 
   CLOSE WINDOW i010_w			#結束畫面
     CALL  cl_used(g_prog,g_time,2)	#計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
#QBE 查詢資料
FUNCTION i010_cs()
 
    IF cl_null(g_argv1) THEN
       CLEAR FORM                             #清除畫面
       CALL g_cxg.clear()
 
   INITIALIZE g_smy.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
                 smyslip,smydesc,smysys,smykind,smydmy1,smydmy2,smy60,            #CHI-B10041 add smykind
                 smyuser,smygrup,smymodu,smydate   #No.TQC-770105
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION controlp
 
             CASE WHEN INFIELD(smyslip)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state    = "c"
                       LET g_qryparam.form     = "q_smy1"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO smyslip
                       NEXT FIELD smyslip
 
                  WHEN INFIELD(smy60)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state    = "c"
                       LET g_qryparam.form     = "q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO smy60
                       NEXT FIELD smy60
             END CASE
		#No.FUN-580031 --start--     HCN
		ON ACTION qbe_select
         	   CALL cl_qbe_select()
		ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
 
       IF INT_FLAG THEN
          RETURN
       END IF
 
       LET g_wc2 = ' 1=1'
 
    ELSE
       LET g_wc=" smyslip='",g_argv1,"'"
       LET g_wc2=' 1=1'
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND smyuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND smygrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND smygrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('smyuser', 'smygrup')
    #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT smyslip FROM smy_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY smyslip"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE smyslip ",
                   "  FROM smy_file, cxg_file ",
                   " WHERE smyslip = cxg01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY smyslip"
    END IF
 
    PREPARE i010_prepare FROM g_sql
    DECLARE i010_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i010_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM smy_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT smyslip)",
                  " FROM smy_file,cxg_file WHERE ",
                  "cxg01=smyslip AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i010_precount FROM g_sql
    DECLARE i010_count CURSOR FOR i010_precount
 
END FUNCTION
 
FUNCTION i010_menu()
 
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i010_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i010_copy()
            END IF
         WHEN "dr_detail"
            IF cl_chk_act_auth() THEN
               CALL i010_dr_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "cr_detail"
            IF cl_chk_act_auth() THEN
               CALL i010_cr_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i010_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_smy.smyslip IS NOT NULL THEN
                  LET g_doc.column1 = "smyslip"
                  LET g_doc.value1 = g_smy.smyslip
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cxg),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i010_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_smy.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i010_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i010_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_smy.* TO NULL
    ELSE
       OPEN i010_count
       FETCH i010_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i010_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i010_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),               #處理方式
    l_abso          LIKE type_file.num10     #No.FUN-680122 INTEGER                #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i010_cs INTO g_smy.smyslip
        WHEN 'P' FETCH PREVIOUS i010_cs INTO g_smy.smyslip
        WHEN 'F' FETCH FIRST    i010_cs INTO g_smy.smyslip
        WHEN 'L' FETCH LAST     i010_cs INTO g_smy.smyslip
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
            FETCH ABSOLUTE g_jump i010_cs INTO g_smy.smyslip
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)
       INITIALIZE g_smy.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_smy.* FROM smy_file WHERE smyslip = g_smy.smyslip
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)   #No.FUN-660127
       CALL cl_err3("sel","smy_file",g_smy.smyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
       INITIALIZE g_smy.* TO NULL
       RETURN
    END IF
 
    CALL i010_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i010_show()
   LET g_smy_t.* = g_smy.*                #保存單頭舊值
 
   DISPLAY BY NAME                        #顯示單頭值
       g_smy.smyslip,g_smy.smydesc,g_smy.smysys,g_smy.smykind,g_smy.smydmy1,g_smy.smydmy2,         #CHI-B10041 add smykind
       g_smy.smy60,
       g_smy.smyuser,g_smy.smygrup,g_smy.smymodu,g_smy.smydate #No.TQC-770105
  
   CALL i010_kind('d')                     #CHI-B10041 add 
   LET g_gem02 = i010_gem02(g_smy.smy60)
   DISPLAY g_gem02 TO FORMONLY.gem02
   CALL i010_b_fill(g_wc2,'1','d')         #Dr單身
   CALL i010_b_fill(g_wc2,'2','d')         #Cr單身
   DISPLAY g_cxg03 TO cxg03
   DISPLAY g_cxg03c TO FORMONLY.cxg03c
   DISPLAY ARRAY g_cxg TO s_cxg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
         #MOD-860081------add-----str---
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION controlg      
             CALL cl_cmdask()     
          
          ON ACTION help          
             CALL cl_show_help()  
         #MOD-860081------add-----end---
 
   END DISPLAY
   DISPLAY ARRAY g_cxgc TO s_cxgc.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
         #MOD-860081------add-----str---
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION controlg      
             CALL cl_cmdask()     
          
          ON ACTION help          
             CALL cl_show_help()  
         #MOD-860081------add-----end---
 
   END DISPLAY
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i010_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_smy.smyslip IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_smy_t.* = g_smy.*
    LET g_success = 'Y'
 
    BEGIN WORK
 
    OPEN i010_cl USING g_smy.smyslip
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_smy.*          #鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)      #資料被他人LOCK
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i010_show()
    WHILE TRUE
#       LET g_smy.smymodu=g_user    #No.TQC-770105 mark
#       LET g_smy.smydate=g_today   #No.TQC-770105 mark
        CALL i010_i("u")                             #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_smy.*=g_smy_t.*
           CALL i010_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        LET g_smy.smymodu=g_user    #No.TQC-770105
        LET g_smy.smydate=g_today   #No.TQC-770105
        UPDATE smy_file SET * = g_smy.*
         WHERE smyslip=g_smy_t.smyslip
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)   #No.FUN-660127
           CALL cl_err3("upd","smy_file",g_smy_t.smyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
           CONTINUE WHILE
           LET g_success='N'
        END IF
        DISPLAY BY NAME g_smy.smymodu   #No.TQC-770105
        DISPLAY BY NAME g_smy.smydate   #No.TQC-770105
        EXIT WHILE
    END WHILE
    CLOSE i010_cl
    COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i010_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(1),               #判斷必要欄位是否有輸入
    l_count         LIKE type_file.num5,      #No.FUN-680122 SMALLINT,
    l_n1            LIKE type_file.num5,      #No.FUN-680122 SMALLINT,
    p_cmd           LIKE type_file.chr1       #No.FUN-680122 VARCHAR(1)                #a:輸入 u:更改
 
    DISPLAY BY NAME g_smy.smyslip,g_smy.smydesc,g_smy.smysys,g_smy.smykind,            #CHI-B10041 add smykind
                    g_smy.smydmy1,g_smy.smydmy2,g_smy.smy60
 
    INPUT BY NAME
          g_smy.smyslip,g_smy.smydmy1,g_smy.smydmy2,g_smy.smy60
          WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        AFTER FIELD smyslip
           IF NOT cl_null(g_smy.smyslip) THEN
              CALL i010_smy('a',g_smy.smyslip)
              IF NOT cl_null(g_errno) THEN
               #-------No.MOD-610002 add
                 IF g_errno MATCHES '9028' THEN
                    IF (cl_confirm("axc-523")) THEN
                       NEXT FIELD smydmy1
                    ELSE
                        CALL cl_err('',g_errno,0)
                        EXIT INPUT
                    END IF
                 ELSE
                    CALL cl_err('',g_errno,0)
                    #NEXT FIELD smyslip
                    EXIT INPUT
                 END IF
              #------No.MOD-610002 end
              END IF
           END IF
 
        AFTER FIELD smydmy1
          IF NOT cl_null(g_smy.smydmy1) THEN
             IF g_smy.smydmy1 NOT MATCHES '[YN]' THEN
                NEXT FIELD smydmy1
             END IF
          END IF
 
        BEFORE FIELD smydmy2
           IF g_smy.smysys='asf' AND g_smy.smykind='4' THEN
               LET g_smy.smydmy2 = '3'
               DISPLAY BY NAME g_smy.smydmy2
           END IF
 
        AFTER FIELD smydmy2
            IF NOT cl_null(g_smy.smydmy2) THEN
               IF g_smy.smydmy2 NOT MATCHES '[12345X]'  THEN
                  NEXT FIELD smydmy2
               END IF
               IF g_smy.smydmy1 = 'Y' AND g_smy.smydmy2 = 'X' THEN
                  CALL cl_err(g_smy.smydmy1,'mfg0180',1)
                  NEXT FIELD smydmy1
               END IF
            END IF
 
        AFTER FIELD smy60
            IF NOT cl_null(g_smy.smy60) THEN
               LET g_gem02 = i010_gem02(g_smy.smy60)
               DISPLAY g_gem02 TO FORMONLY.gem02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_smy.smy60,g_errno,1)
                  NEXT FIELD smy60
               END IF
            END IF
 
        ON ACTION controlp
           CASE
              WHEN  INFIELD(smyslip)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_smy1"
                    LET g_qryparam.default1 = g_smy.smyslip
                    CALL cl_create_qry() RETURNING g_smy.smyslip
                    DISPLAY BY NAME g_smy.smyslip
                    NEXT FIELD smyslip
              WHEN  INFIELD(smy60)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_gem"
                    LET g_qryparam.default1 = g_smy.smy60
                    CALL cl_create_qry() RETURNING g_smy.smy60
                    DISPLAY BY NAME g_smy.smy60
                    NEXT FIELD smy60
           END CASE
       #MOD-860081------add-----str---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
        
        ON ACTION help          
           CALL cl_show_help()  
       #MOD-860081------add-----end---
 
    END INPUT
 
END FUNCTION
 
FUNCTION i010_smy(p_cmd,p_code)
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(01),
    p_code          LIKE smy_file.smyslip,
    l_smyacti       LIKE smy_file.smyacti
 
    LET l_smyacti = ''
    LET g_errno = ''
 
    IF p_cmd = 'a' THEN
       SELECT smy_file.*,smyacti  INTO g_smy.*, l_smyacti FROM smy_file
        WHERE smyslip = p_code
    ELSE
       SELECT smyacti  INTO l_smyacti FROM smy_file
        WHERE smyslip = p_code
    END IF
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'
                                   LET l_smyacti = NULL
         WHEN l_smyacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' THEN
       DISPLAY BY NAME g_smy.smydmy1,g_smy.smydmy2,g_smy.smy60
    END IF
 
END FUNCTION
 
FUNCTION i010_gem02(p_code)
DEFINE
    p_code          LIKE gem_file.gem01,
    l_gem02         LIKE gem_file.gem02,
    l_gemacti       LIKE gem_file.gemacti
 
    LET l_gem02 = ''
    LET g_errno = ''
 
    SELECT gem02,gemacti  INTO l_gem02,l_gemacti FROM gem_file
     WHERE gem01 = p_code
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1318'
                                   LET l_gem02 = NULL
                                   LET l_gemacti = NULL
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    RETURN l_gem02
 
END FUNCTION
 
FUNCTION i010_chk_cxg(p_code,p_cxg03_t,p_cxg03)
   DEFINE p_code     LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01),   #1:Dr    2:Cr
          p_cxg03_t  LIKE cxg_file.cxg03,
          p_cxg03    LIKE cxg_file.cxg03
 
   IF p_cxg03 MATCHES '[04]' THEN
      DELETE FROM cxg_file
       WHERE cxg01 = g_smy.smyslip
         AND cxg02 = p_code
         AND cxg03 = p_cxg03_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err('delete cxg',SQLCA.sqlcode,0)   #No.FUN-660127
         CALL cl_err3("del","cxg_file",g_smy.smyslip,p_code,SQLCA.sqlcode,"","delete cxg",1)  #No.FUN-660127
      ELSE
         INSERT INTO cxg_file (cxg01,cxg02,cxg03,cxg04,cxg05,cxg051) #FUN-680086 add  
                       VALUES (g_smy.smyslip,p_code,p_cxg03,'XXXXX','','') #FUN-680086 add  
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cxg[l_ac].cxg04,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cxg_file",g_smy.smyslip,p_code,SQLCA.sqlcode,"","",1)  #No.FUN-660127
         ELSE
            MESSAGE 'INSERT O.K'
         END IF
      END IF
   ELSE
      IF p_cxg03_t != p_cxg03 AND NOT cl_null(p_cxg03_t) THEN
         DELETE FROM cxg_file
          WHERE cxg01 = g_smy.smyslip
            AND cxg02 = p_code
            AND cxg03 = p_cxg03_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('delete cxg',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("del","cxg_file",g_smy.smyslip,p_code,SQLCA.sqlcode,"","delete cxg",1)  #No.FUN-660127
         END IF
      END IF
   END IF
 
END FUNCTION
 
#Dr單身
FUNCTION i010_dr_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #No.FUN-680122 SMALLINT,              #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,     #No.FUN-680122 SMALLINT,              #檢查重複用
   l_lock_sw       LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),               #單身鎖住否
   p_cmd           LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),               #處理狀態
   acti_tm         LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),               #
   l_sw            LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01),              #可更改否 (含取消)
   sw              LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01),              #可更改否 (含取消)
   l_allow_insert  LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01),              #可新增否
   l_allow_delete  LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_smy.smyslip IS NULL
      THEN RETURN
   END IF
   SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_smy.smyslip
   IF g_smy.smyacti ='N' THEN
      CALL cl_err(g_smy.smyslip,'mfg1000',0)     #檢查資料是否為無效
      RETURN
   END IF
 
   LET g_cxg03_t = g_cxg03      #BACKUP
 
   DISPLAY g_cxg03 TO cxg03
 
   INPUT g_cxg03 WITHOUT DEFAULTS FROM cxg03
 
        AFTER FIELD cxg03
            IF NOT cl_null(g_cxg03) THEN
               IF g_cxg03 NOT MATCHES '[01234]' THEN
                  NEXT FIELD cxg03
               END IF
            END IF
        EXIT INPUT
 
       #MOD-860081------add-----str---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
        
        ON ACTION help          
           CALL cl_show_help()  
       #MOD-860081------add-----end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_cxg03 = g_cxg03_t
      RETURN
   END IF
 
   CALL i010_chk_cxg('1',g_cxg03_t,g_cxg03)
   CALL i010_b_fill(' 1=1','1','a')
#NO.TQC-750103 start--
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("cxg051,aag021,cxg051c,aag021c",FALSE)
   END IF
#NO.TQC-750103 end----
   DISPLAY ARRAY g_cxg TO s_cxg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
         #MOD-860081------add-----str---
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY 
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION controlg      
             CALL cl_cmdask()     
          
          ON ACTION help          
             CALL cl_show_help()  
         #MOD-860081------add-----end---   
   END DISPLAY
 
   LET g_cxg03_t = g_cxg03    #因為單身明細資料已根據輸入的條件清除了,so要給舊值=新值
                              #UPDATE/DELETE 才不會有問題
 
   IF g_cxg03 = '4' THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cxg04,'',cxg05,'',cxg051,''", #FUN-680086 add  
                      "  FROM cxg_file  WHERE cxg01=? AND cxg02=? AND cxg03=? ",
                      "   AND cxg04 = ? ",
                      "  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_cxg WITHOUT DEFAULTS FROM s_cxg.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         CALL i010_set_entry_b_dr('a')
         CALL i010_set_no_entry_b_dr('a')
         LET g_before_input_done = TRUE
 
      BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          OPEN i010_cl USING g_smy.smyslip
          IF SQLCA.sqlcode
             THEN CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)
             CLOSE i010_cl
             ROLLBACK WORK
             RETURN
          ELSE
             FETCH i010_cl INTO g_smy.*
             IF SQLCA.sqlcode
                THEN CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)
                CLOSE i010_cl
                ROLLBACK WORK
                RETURN
              END IF
          END IF
          #No.TQC-970156--begin
          IF g_cxg03 MATCHES '[04]' AND l_ac>1 THEN 
             CALL cl_err('','axc-215',1)
             RETURN 
          END IF 
          #No.TQC-970156--end
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_cxg_t.* = g_cxg[l_ac].*  #BACKUP
             OPEN i010_bcl USING g_smy.smyslip,'1',g_cxg03,g_cxg_t.cxg04
 
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cxg_t.cxg04,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i010_bcl INTO g_cxg[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_cxg_t.cxg04,SQLCA.sqlcode,1)
                   LET l_lock_sw="Y"
                ELSE
                   LET g_cxg[l_ac].azf03 = i010_azf03(g_cxg03,g_cxg[l_ac].cxg04)
                   LET g_cxg[l_ac].aag02 = i010_aag02(g_cxg[l_ac].cxg05,g_aza.aza81)    #NO.FUN-730057
                   LET g_cxg[l_ac].aag021= i010_aag02(g_cxg[l_ac].cxg051,g_aza.aza82) #FUN-680086 add  #NO.FUN-730057
                   DISPLAY g_cxg[l_ac].azf03 TO FORMONLY.azf03
                   DISPLAY g_cxg[l_ac].aag02 TO FORMONLY.aag02
                   LET g_before_input_done = FALSE
                   CALL i010_set_entry_b_dr(p_cmd)
                   CALL i010_set_no_entry_b_dr(p_cmd)
                   LET g_before_input_done = TRUE
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_cxg[l_ac].* TO NULL
         LET g_cxg_t.* = g_cxg[l_ac].*
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD cxg04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO cxg_file (cxg01,cxg02,cxg03,cxg04,cxg05,cxg051) #FUN-680086 
                       VALUES (g_smy.smyslip,'1',g_cxg03,
                               g_cxg[l_ac].cxg04,g_cxg[l_ac].cxg05,g_cxg[l_ac].cxg051) #FUN-680086
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cxg[l_ac].cxg04,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cxg_file",g_smy.smyslip,g_cxg03,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD cxg04
         CALL i010_set_entry_b_dr(p_cmd)
 
      AFTER FIELD cxg04
        IF NOT cl_null(g_cxg[l_ac].cxg04) THEN
           IF g_cxg[l_ac].cxg04 != g_cxg_t.cxg04 OR g_cxg_t.cxg04 IS NULL THEN
              #檢查資料是否重覆
               SELECT COUNT(*) INTO g_cnt FROM cxg_file
                WHERE cxg01=g_smy.smyslip
                  AND cxg02='1'
                  AND cxg03=g_cxg03
                  AND cxg04=g_cxg[l_ac].cxg04
               IF g_cnt > 0 THEN
                  CALL cl_err(g_cxg[l_ac].cxg04,-239,0)
                  LET g_cxg[l_ac].cxg04 = g_cxg_t.cxg04
                  NEXT FIELD cxg04
               END IF
           END IF
           LET g_cxg[l_ac].azf03 = i010_azf03(g_cxg03,g_cxg[l_ac].cxg04)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_cxg[l_ac].cxg04,g_errno,0)
              LET g_cxg[l_ac].cxg04 = g_cxg_t.cxg04
              NEXT FIELD cxg04
           END IF
        END IF
         CALL i010_set_no_entry_b_dr(p_cmd)

      AFTER FIELD cxg05
        IF NOT cl_null(g_cxg[l_ac].cxg05) THEN
           LET g_cxg[l_ac].aag02 = i010_aag02(g_cxg[l_ac].cxg05,g_aza.aza81)         #NO.FUN-730057
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_cxg[l_ac].cxg05,g_errno,0)
#FUN-B10052 --begin--              
#              LET g_cxg[l_ac].cxg05 = g_cxg_t.cxg05
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza81
               LET g_qryparam.construct = 'N'    
               LET g_qryparam.default1 = g_cxg[l_ac].cxg05
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_cxg[l_ac].cxg05 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_cxg[l_ac].cxg05
               DISPLAY BY NAME g_cxg[l_ac].cxg05
               LET g_cxg[l_ac].aag02 = i010_aag02(g_cxg[l_ac].cxg05,g_aza.aza81) 
               DISPLAY BY NAME g_cxg[l_ac].aag02
#FUN-B10052 --end--
              NEXT FIELD cxg05
           END IF
        END IF
 
      #FUN-680086  --begin
      AFTER FIELD cxg051
        IF NOT cl_null(g_cxg[l_ac].cxg051) THEN
           LET g_cxg[l_ac].aag021= i010_aag02(g_cxg[l_ac].cxg051,g_aza.aza82)       #NO.FUN-730057
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_cxg[l_ac].cxg051,g_errno,0)
#FUN-B10052 --begin--
#              LET g_cxg[l_ac].cxg051 = g_cxg_t.cxg051         
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza82    
               LET g_qryparam.default1 = g_cxg[l_ac].cxg051
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_cxg[l_ac].cxg051 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_cxg[l_ac].cxg051
               DISPLAY BY NAME g_cxg[l_ac].cxg051
               LET g_cxg[l_ac].aag021= i010_aag02(g_cxg[l_ac].cxg051,g_aza.aza82) 
               DISPLAY BY NAME g_cxg[l_ac].aag021
#FUN-B10052 --end--
              NEXT FIELD cxg051
           END IF
        END IF
      #FUN-680086  --end
 
      BEFORE DELETE                            #是否取消單身
        IF g_cxg_t.cxg04 != ' ' AND g_cxg_t.cxg04 IS NOT NULL THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM cxg_file
            WHERE cxg01 = g_smy.smyslip
              AND cxg02 = '1'
              AND cxg03 = g_cxg03
              AND cxg04 = g_cxg[l_ac].cxg04
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_cxg_t.cxg04,SQLCA.sqlcode,0)   #No.FUN-660127
              CALL cl_err3("del","cxg_file",g_smy.smyslip,g_cxg03,SQLCA.sqlcode,"","",1)  #No.FUN-660127
              CLOSE i010_bcl
              ROLLBACK WORK
              CANCEL DELETE
           ELSE
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE "Delete Ok"
              CLOSE i010_bcl
              COMMIT WORK
           END IF
        END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cxg[l_ac].* = g_cxg_t.*
            CLOSE i010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cxg[l_ac].cxg04,-263,1)
            LET g_cxg[l_ac].* = g_cxg_t.*
         ELSE
            UPDATE cxg_file SET cxg04=g_cxg[l_ac].cxg04,
                                cxg05=g_cxg[l_ac].cxg05,
                                cxg051=g_cxg[l_ac].cxg051 #FUN-680086
             WHERE cxg01=g_smy.smyslip
               AND cxg02='1'
               AND cxg03=g_cxg03_t
               AND cxg04=g_cxg_t.cxg04
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cxg[l_ac].cxg04,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("upd","cxg_file",g_smy.smyslip,g_cxg03_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               LET g_cxg[l_ac].* = g_cxg_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_cxg[l_ac].* = g_cxg_t.*
             END IF
             CLOSE i010_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE i010_bcl
          COMMIT WORK
 
#     ON ACTION CONTROLN
#         CALL i010_b_askkey()
#         EXIT INPUT
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cxg04) AND g_cxg03 MATCHES '[123]'
               CALL cl_init_qry_var()
               CASE g_cxg03
                    WHEN '1'
                         LET g_qryparam.form     = "q_azf"
                         LET g_qryparam.arg1     = "G"
                    WHEN '2'
                         LET g_qryparam.form     = "q_imz"
                    WHEN '3'
                         LET g_qryparam.form     = "q_oba"
               END CASE
               LET g_qryparam.default1 = g_cxg[l_ac].cxg04
               CALL cl_create_qry() RETURNING g_cxg[l_ac].cxg04
               DISPLAY g_cxg[l_ac].cxg04 TO cxg04
               LET g_cxg[l_ac].azf03 = i010_azf03(g_cxg03,g_cxg[l_ac].cxg04)
               DISPLAY BY NAME g_cxg[l_ac].azf03
               NEXT FIELD cxg04
 
            WHEN INFIELD(cxg05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza81    #NO.FUN-730057
               LET g_qryparam.default1 = g_cxg[l_ac].cxg05
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
               CALL cl_create_qry() RETURNING g_cxg[l_ac].cxg05
               DISPLAY BY NAME g_cxg[l_ac].cxg05
               LET g_cxg[l_ac].aag02 = i010_aag02(g_cxg[l_ac].cxg05,g_aza.aza81)      #NO.FUN-730057
               DISPLAY BY NAME g_cxg[l_ac].aag02
               NEXT FIELD cxg05
            #FUN-680086  --begin
            WHEN INFIELD(cxg051)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza82    #NO.FUN-730057
               LET g_qryparam.default1 = g_cxg[l_ac].cxg051
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
               CALL cl_create_qry() RETURNING g_cxg[l_ac].cxg051
               DISPLAY BY NAME g_cxg[l_ac].cxg051
               LET g_cxg[l_ac].aag021= i010_aag02(g_cxg[l_ac].cxg051,g_aza.aza82)          #NO.FUN-730057
               DISPLAY BY NAME g_cxg[l_ac].aag021
               NEXT FIELD cxg051
            #FUN-680086  --end
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
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
 
   CLOSE i010_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i010_set_entry_b_dr(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680122 VARCHAR(01)
 
    IF p_cmd = 'a' OR INFIELD(cxg04) OR ( NOT g_before_input_done ) THEN
       CASE g_cxg03
            WHEN '0'     CALL cl_set_comp_entry("cxg04",FALSE)
                         IF g_aza.aza63 = 'Y' THEN   #no.TQC-750103
                             CALL cl_set_comp_entry("cxg05,cxg051",TRUE) #FUN-680086  
                             CALL cl_set_comp_required("cxg05,cxg051",TRUE) #FUN-680086 
                         END IF                      #NO.TQC-750103
            OTHERWISE
#NO.TQC-750103 start----
                         #CALL cl_set_comp_entry("cxg04,cxg05,cxg051",TRUE) #FUN-680086
                         #CALL cl_set_comp_entry("cxg04,cxg05,cxg051",TRUE) #FUN-680086
                         CALL cl_set_comp_entry("cxg04",TRUE) #FUN-680086
                         IF g_aza.aza63 = 'Y' THEN   #no.TQC-750103
                             CALL cl_set_comp_entry("cxg05,cxg051",TRUE) #FUN-680086
                             CALL cl_set_comp_entry("cxg05,cxg051",TRUE) #FUN-680086
                         END IF
#NO.TQC-750103 end------
       END CASE
    END IF
 
END FUNCTION
 
FUNCTION i010_set_no_entry_b_dr(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
  DEFINE p_chk   LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
 
    IF INFIELD(cxg04) OR ( NOT g_before_input_done ) THEN
       CASE g_cxg03
            WHEN '0'     CALL cl_set_comp_entry("cxg04",FALSE)
#NO.TQC-750103 mark--
#                         CALL cl_set_comp_entry("cxg05,cxg051",TRUE) #FUN-680086
#                         CALL cl_set_comp_required("cxg05,cxg051",TRUE) #FUN-680086
#NO.TQC-750103 mark--
            OTHERWISE
#NO.TQC-750103 start----
                         #CALL cl_set_comp_entry("cxg04,cxg05,cxg051",TRUE)  #FUN-680086
                         #CALL cl_set_comp_required("cxg04,cxg05,cxg051",TRUE)  #FUN-680086
                         CALL cl_set_comp_entry("cxg04",TRUE)  #FUN-680086
                         CALL cl_set_comp_required("cxg04",TRUE)  #FUN-680086
#NO.TQC-750103 end------
       END CASE
    END IF
 
END FUNCTION
 
#Cr單身
FUNCTION i010_cr_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #No.FUN-680122 SMALLINT,              #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,     #No.FUN-680122 SMALLINT,              #檢查重複用
   l_lock_sw       LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),               #單身鎖住否
   p_cmd           LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),               #處理狀態
   l_sw            LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01),              #可更改否 (含取消)
   l_allow_insert  LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01),              #可新增否
   l_allow_delete  LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_smy.smyslip IS NULL
      THEN RETURN
   END IF
   SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_smy.smyslip
   IF g_smy.smyacti ='N' THEN
      CALL cl_err(g_smy.smyslip,'mfg1000',0)     #檢查資料是否為無效
      RETURN
   END IF
 
   LET g_cxg03c_t = g_cxg03c      #BACKUP
 
   DISPLAY g_cxg03c TO cxg03c
 
   INPUT g_cxg03c WITHOUT DEFAULTS FROM cxg03c
 
        AFTER FIELD cxg03c
            IF NOT cl_null(g_cxg03c) THEN
               IF g_cxg03c NOT MATCHES '[01234]' THEN
                  NEXT FIELD cxg03c
               END IF
            END IF
 
       #MOD-860081------add-----str---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
        
        ON ACTION help          
           CALL cl_show_help()  
       #MOD-860081------add-----end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_cxg03c = g_cxg03c_t
      RETURN
   END IF
 
   CALL i010_chk_cxg('2',g_cxg03c_t,g_cxg03c)
   CALL i010_b_fill(' 1=1','2','a')
   DISPLAY ARRAY g_cxgc TO s_cxgc.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
        #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
        #MOD-860081------add-----end---
 
   END DISPLAY
 
   LET g_cxg03c_t = g_cxg03c    #因為單身明細資料已根據輸入的清除了,so要給舊值=新值
                                #UPDATE/DELETE 才不會有問題
 
   IF g_cxg03c = '4' THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cxg04,'',cxg05,'',cxg051,''", #FUN-680086
                      "  FROM cxg_file  WHERE cxg01=? AND cxg02=? AND cxg03=? ",
                      "   AND cxg04 = ? ",
                      "  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_cbcl CURSOR FROM g_forupd_sql    #LOCK CURSOR
 
   INPUT ARRAY g_cxgc WITHOUT DEFAULTS FROM s_cxgc.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         CALL i010_set_entry_b_cr('a')
         CALL i010_set_no_entry_b_cr('a')
         LET g_before_input_done = TRUE
 
      BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          OPEN i010_cl USING g_smy.smyslip
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)
             CLOSE i010_cl
             ROLLBACK WORK
             RETURN
          ELSE
             FETCH i010_cl INTO g_smy.*
             IF SQLCA.sqlcode
                THEN CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)
                CLOSE i010_cl
                ROLLBACK WORK
                RETURN
              END IF
          END IF
          #No.TQC-970156--begin
          IF g_cxg03c MATCHES '[04]' AND l_ac>1 THEN 
             CALL cl_err('','axc-215',1)
             RETURN 
          END IF 
          #No.TQC-970156--end
          IF g_rec_b2 >= l_ac THEN
             LET p_cmd='u'
             LET g_cxgc_t.* = g_cxgc[l_ac].*  #BACKUP
             OPEN i010_cbcl USING g_smy.smyslip,'2',g_cxg03c,g_cxgc_t.cxg04c
 
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cxgc_t.cxg04c,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i010_cbcl INTO g_cxgc[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_cxgc_t.cxg04c,SQLCA.sqlcode,1)
                   LET l_lock_sw="Y"
                ELSE
                   LET g_cxgc[l_ac].azf03c = i010_azf03(g_cxg03c,g_cxgc[l_ac].cxg04c)
                   LET g_cxgc[l_ac].aag02c = i010_aag02(g_cxgc[l_ac].cxg05c,g_aza.aza81)  #NO.FUN-730057
                   LET g_cxgc[l_ac].aag021c = i010_aag02(g_cxgc[l_ac].cxg051c,g_aza.aza82) #FUN-680086   #NO.FUN-730057
                   DISPLAY g_cxgc[l_ac].azf03c TO FORMONLY.azf03c
                   DISPLAY g_cxgc[l_ac].aag02c TO FORMONLY.aag02c
                   DISPLAY g_cxgc[l_ac].aag021c TO FORMONLY.aag021c  #FUN-680086
                   LET g_before_input_done = FALSE
                   CALL i010_set_entry_b_cr(p_cmd)
                   CALL i010_set_no_entry_b_cr(p_cmd)
                   LET g_before_input_done = TRUE
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_cxgc[l_ac].* TO NULL
          LET g_cxgc_t.* = g_cxgc[l_ac].*
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD cxg04c
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO cxg_file (cxg01,cxg02,cxg03,cxg04,cxg05,cxg051) #FUN-680086
                       VALUES (g_smy.smyslip,'2',g_cxg03c,
                               g_cxgc[l_ac].cxg04c,g_cxgc[l_ac].cxg05c,g_cxgc[l_ac].cxg051c) #FUN-680086
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cxgc[l_ac].cxg04c,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cxg_file",g_smy.smyslip,g_cxg03c,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b2=g_rec_b2+1
            DISPLAY g_rec_b2 TO FORMONLY.cn4
         END IF
 
      BEFORE FIELD cxg04c
        CALL i010_set_entry_b_cr(p_cmd)
 
      AFTER FIELD cxg04c
        IF NOT cl_null(g_cxgc[l_ac].cxg04c) THEN
           IF g_cxgc[l_ac].cxg04c != g_cxgc_t.cxg04c OR g_cxgc_t.cxg04c IS NULL THEN
              #檢查資料是否重覆
               SELECT COUNT(*) INTO g_cnt FROM cxg_file
                WHERE cxg01=g_smy.smyslip
                  AND cxg02='2'
                  AND cxg03=g_cxg03c
                  AND cxg04c=g_cxgc[l_ac].cxg04c
               IF g_cnt > 0 THEN
                  CALL cl_err(g_cxgc[l_ac].cxg04c,-239,0)
                  LET g_cxgc[l_ac].cxg04c = g_cxgc_t.cxg04c
                  NEXT FIELD cxg04c
               END IF
           END IF
           LET g_cxgc[l_ac].azf03c = i010_azf03(g_cxg03c,g_cxgc[l_ac].cxg04c)
           DISPLAY g_cxgc[l_ac].azf03c  TO FORMONLY.azf03c
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_cxgc[l_ac].cxg04c,g_errno,0)
              LET g_cxgc[l_ac].cxg04c = g_cxgc_t.cxg04c
              NEXT FIELD cxg04c
           END IF
        END IF
        CALL i010_set_no_entry_b_cr(p_cmd)

      AFTER FIELD cxg05c
        IF NOT cl_null(g_cxgc[l_ac].cxg05c) THEN
           LET g_cxgc[l_ac].aag02c = i010_aag02(g_cxgc[l_ac].cxg05c,g_aza.aza81)     #NO.FUN-730057
           DISPLAY g_cxgc[l_ac].aag02c  TO FORMONLY.aag02c
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_cxgc[l_ac].cxg05c,g_errno,0)
#FUN-B10052 --begin--
#             LET g_cxgc[l_ac].cxg05c = g_cxgc_t.cxg05c
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza81   
               LET g_qryparam.default1 = g_cxgc[l_ac].cxg05c
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_cxgc[l_ac].cxg05c CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_cxgc[l_ac].cxg05c
               DISPLAY BY NAME g_cxgc[l_ac].cxg05c
               LET g_cxgc[l_ac].aag02c = i010_aag02(g_cxgc[l_ac].cxg05c,g_aza.aza81)    
               DISPLAY BY NAME g_cxgc[l_ac].aag02c
#FUN-B10052 --end--
              NEXT FIELD cxg05c
           END IF
        END IF
 
      #FUN-680086 --begin
      AFTER FIELD cxg051c
        IF NOT cl_null(g_cxgc[l_ac].cxg051c) THEN
           LET g_cxgc[l_ac].aag021c = i010_aag02(g_cxgc[l_ac].cxg051c,g_aza.aza82)     #NO.FUN-730057
           DISPLAY g_cxgc[l_ac].aag021c  TO FORMONLY.aag021c
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_cxgc[l_ac].cxg051c,g_errno,0)
#FUN-B10052 --begin--
#              LET g_cxgc[l_ac].cxg051c = g_cxgc_t.cxg051c
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza82   
               LET g_qryparam.default1 = g_cxgc[l_ac].cxg051c
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_cxgc[l_ac].cxg051c CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_cxgc[l_ac].cxg051c
               DISPLAY BY NAME g_cxgc[l_ac].cxg051c
               LET g_cxgc[l_ac].aag021c = i010_aag02(g_cxgc[l_ac].cxg051c,g_aza.aza82)   
               DISPLAY BY NAME g_cxgc[l_ac].aag021c
#FUN-B10052 --end--
              NEXT FIELD cxg051c
           END IF
        END IF
      #FUN-680086 --end
 
      BEFORE DELETE                            #是否取消單身
        IF g_cxgc_t.cxg04c != ' ' AND g_cxgc_t.cxg04c IS NOT NULL THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM cxg_file
            WHERE cxg01 = g_smy.smyslip
              AND cxg02 = '2'
              AND cxg03 = g_cxg03c
              AND cxg04 = g_cxgc[l_ac].cxg04c
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_cxgc_t.cxg04c,SQLCA.sqlcode,0)   #No.FUN-660127
              CALL cl_err3("del","cxg_file",g_smy.smyslip,g_cxg03c,SQLCA.sqlcode,"","",1)  #No.FUN-660127
              CLOSE i010_cbcl
              ROLLBACK WORK
              CANCEL DELETE
           ELSE
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              MESSAGE "Delete Ok"
              CLOSE i010_cbcl
              COMMIT WORK
           END IF
        END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cxgc[l_ac].* = g_cxgc_t.*
            CLOSE i010_cbcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cxgc[l_ac].cxg04c,-263,1)
            LET g_cxgc[l_ac].* = g_cxgc_t.*
         ELSE
            UPDATE cxg_file SET cxg04=g_cxgc[l_ac].cxg04c,
                                cxg05=g_cxgc[l_ac].cxg05c,
                                cxg051=g_cxgc[l_ac].cxg051c #FUN-680086
             WHERE cxg01=g_smy.smyslip
               AND cxg02='2'
               AND cxg03=g_cxg03c_t
               AND cxg04=g_cxgc_t.cxg04c
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cxgc[l_ac].cxg04c,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("upd","cxg_file",g_smy.smyslip,g_cxg03c_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               LET g_cxgc[l_ac].* = g_cxgc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_cxgc[l_ac].* = g_cxgc_t.*
             END IF
             CLOSE i010_cbcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE i010_cbcl
          COMMIT WORK
 
#     ON ACTION CONTROLN
#         CALL i010_b_askkey()
#         EXIT INPUT
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cxg04c) AND g_cxg03c MATCHES '[123]'
               CALL cl_init_qry_var()
               CASE g_cxg03c
                    WHEN '1'
                         LET g_qryparam.form     = "q_azf"
                         LET g_qryparam.arg1     = "G"
                    WHEN '2'
                         LET g_qryparam.form     = "q_imz"
                    WHEN '3'
                         LET g_qryparam.form     = "q_oba"
               END CASE
               LET g_qryparam.default1 = g_cxgc[l_ac].cxg04c
               CALL cl_create_qry() RETURNING g_cxgc[l_ac].cxg04c
               DISPLAY g_cxgc[l_ac].cxg04c TO cxg04c
               LET g_cxgc[l_ac].azf03c = i010_azf03(g_cxg03c,g_cxgc[l_ac].cxg04c)
               DISPLAY BY NAME g_cxgc[l_ac].azf03c
               NEXT FIELD cxg04c
 
            WHEN INFIELD(cxg05c)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza81    #NO.FUN-730057
               LET g_qryparam.default1 = g_cxgc[l_ac].cxg05c
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
               CALL cl_create_qry() RETURNING g_cxgc[l_ac].cxg05c
               DISPLAY BY NAME g_cxgc[l_ac].cxg05c
               LET g_cxgc[l_ac].aag02c = i010_aag02(g_cxgc[l_ac].cxg05c,g_aza.aza81)     #NO.FUN-730057
               DISPLAY BY NAME g_cxgc[l_ac].aag02c
               NEXT FIELD cxg05c
            #FUN-680086  --begin
            WHEN INFIELD(cxg051c)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.arg1 = g_aza.aza82    #NO.FUN-730057
               LET g_qryparam.default1 = g_cxgc[l_ac].cxg051c
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
               CALL cl_create_qry() RETURNING g_cxgc[l_ac].cxg051c
               DISPLAY BY NAME g_cxgc[l_ac].cxg051c
               LET g_cxgc[l_ac].aag021c = i010_aag02(g_cxgc[l_ac].cxg051c,g_aza.aza82)   #NO.FUN-730057
               DISPLAY BY NAME g_cxgc[l_ac].aag021c
               NEXT FIELD cxg051c
            #FUN-680086  --end
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
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
 
   CLOSE i010_cbcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i010_set_entry_b_cr(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680122 VARCHAR(01)
 
    IF p_cmd = 'a' OR INFIELD(cxg04c) OR ( NOT g_before_input_done ) THEN
       CASE g_cxg03c
            WHEN '0'
                         CALL cl_set_comp_entry("cxg04c",FALSE)
                         IF g_aza.aza63 = 'Y' THEN   #no.TQC-750103
                             CALL cl_set_comp_entry("cxg05c,cxg051c",TRUE) #FUN-680086
                             CALL cl_set_comp_required("cxg05c,cxg051c",TRUE) #FUN-680086
                         END IF                      #NO.TQC-750103
            OTHERWISE
#NO.TQC-750103 mark---
#                         CALL cl_set_comp_entry("cxg04c,cxg05c,cxg051c",TRUE) #FUN-680086
#                         CALL cl_set_comp_required("cxg04c,cxg05c,cxg051c",TRUE) #FUN-680086
                          CALL cl_set_comp_entry("cxg04c",TRUE) #FUN-680086
                          IF g_aza.aza63 = 'Y' THEN 
                              CALL cl_set_comp_entry("cxg05c,cxg051c",TRUE) #FUN-680086
                              CALL cl_set_comp_required("cxg05c,cxg051c",TRUE) #FUN-680086
                          END IF
#NO.TQC-750103 end-----
       END CASE
 
    END IF
 
END FUNCTION
 
FUNCTION i010_set_no_entry_b_cr(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680122 VARCHAR(01)
  DEFINE p_chk   LIKE type_file.chr1     #No.FUN-680122 VARCHAR(01)
 
    IF INFIELD(cxg04c) OR ( NOT g_before_input_done ) THEN
       CASE g_cxg03c
            WHEN '0'
                         CALL cl_set_comp_entry("cxg04c",FALSE) 
                         IF g_aza.aza63 = 'Y' THEN   #no.TQC-750103
                             CALL cl_set_comp_entry("cxg05c,cxg051c",TRUE) #FUN-680086
                             CALL cl_set_comp_required("cxg05c,cxg051c",TRUE) #FUN-680086
                         END IF                      #NO.TQC-750103
            OTHERWISE
#NO.TQC-750103 mark---
#                        CALL cl_set_comp_entry("cxg04c,cxg05c,cxg051c",TRUE) #FUN-680086
#                        CALL cl_set_comp_required("cxg04c,cxg05c,cxg051c",TRUE) #FUN-680086
                         CALL cl_set_comp_entry("cxg04c",TRUE) #FUN-680086
                         IF g_aza.aza63 = 'Y' THEN 
                             CALL cl_set_comp_entry("cxg05c,cxg051c",TRUE) #FUN-680086
                             CALL cl_set_comp_required("cxg05c,cxg051c",TRUE) #FUN-680086
                         END IF
#NO.TQC-750103 mark---
       END CASE
 
    END IF
 
END FUNCTION
 
FUNCTION i010_azf03(p_type,p_code)
  DEFINE p_type     LIKE cxg_file.cxg03
  DEFINE p_code     LIKE oba_file.oba01
  DEFINE l_azfacti  LIKE azf_file.azfacti
  DEFINE l_azf03    LIKE azf_file.azf03
  DEFINE l_msg      LIKE azf_file.azf03
 
   LET l_azf03 = ''
   LET l_msg = ''
   LET l_azfacti = ''
   LET g_errno = ''
 
   CASE p_type
        WHEN '0'
             LET l_azf03 = ''
        WHEN '1'
             SELECT azf03,azfacti INTO l_azf03,l_azfacti FROM azf_file
              WHERE azf01 = p_code
                AND azf02 = 'G'
 
             CASE WHEN STATUS=100         LET g_errno='mfg3088'
                  WHEN l_azfacti='N'      LET g_errno='9028'
                  OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
             END CASE
        WHEN '2'
             SELECT imz02,imzacti INTO l_azf03,l_azfacti FROM imz_file
              WHERE imz01 = p_code
 
             CASE WHEN STATUS=100         LET g_errno='mfg3179'
                  WHEN l_azfacti='N'      LET g_errno='9028'
                  OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
             END CASE
        WHEN '3'
             SELECT oba02 INTO l_azf03 FROM oba_file
              WHERE oba01 = p_code
 
             CASE WHEN STATUS=100         LET g_errno='mfg3160'
                  OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
             END CASE
        OTHERWISE
             CASE g_ccz.ccz07
                  WHEN '1'    LET l_msg = 'axc-030'
                  WHEN '2'    LET l_msg = 'axc-031'
                  WHEN '3'    LET l_msg = 'axc-032'
                  WHEN '4'    LET l_msg = 'axc-033'
             END CASE
             LET l_azf03 = cl_getmsg(l_msg,g_lang) CLIPPED
   END CASE
 
   RETURN l_azf03
 
END FUNCTION
 
FUNCTION i010_aag02(p_code,p_bookno)        #NO.FUN-730057
  DEFINE p_code     LIKE aag_file.aag01
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07
  DEFINE l_aag09    LIKE aag_file.aag09
  DEFINE l_aag02    LIKE aag_file.aag02
  DEFINE p_bookno   LIKE aag_file.aag00     #NO.FUN-730057
 
   LET l_aag02 = ''
   LET l_aag07 = ''
   LET l_aag09 = ''
   LET l_aagacti = ''
   LET g_errno = ''
   SELECT aag02,aag07,aag09,aagacti
     INTO l_aag02,l_aag07,l_aag09,l_aagacti
     FROM aag_file
    WHERE aag01=p_code
      AND aag00=p_bookno                     #NO.FUN-730057
 
   CASE WHEN STATUS=100         LET g_errno='agl-001'
        WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        WHEN l_aag09  = 'N'     LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
 
   RETURN l_aag02
 
END FUNCTION
 
FUNCTION i010_b_askkey()
DEFINE
    l_wc2   LIKE type_file.chr1000  #No.FUN-680122 VARCHAR(600)
 
    CONSTRUCT l_wc2 ON cxg04,cxg05,cxg051 #FUN-680086
         FROM s_cxg[1].cxg04,s_cxg[1].cxg05,s_cxg[1].cxg051 #FUN-680086
 
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i010_b_fill(l_wc2,'1','d')
    CALL i010_b_fill(l_wc2,'2','d')
 
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2,p_code,p_type)         #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(600),
    p_code          LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
    p_type          LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
    l_cxg02         LIKE cxg_file.cxg02,
    l_cxg03         LIKE cxg_file.cxg03,
    l_cxg           RECORD
	cxg04       LIKE cxg_file.cxg04,
	azf03       LIKE azf_file.azf03,
	cxg05       LIKE cxg_file.cxg05,
        aag02       LIKE aag_file.aag02,
	cxg051      LIKE cxg_file.cxg051, #FUN-680086
        aag021      LIKE aag_file.aag02   #FUN-680086
                    END RECORD
 
    LET g_sql = "SELECT cxg03,cxg04,'',cxg05,'',cxg051,'' FROM cxg_file ", #FUN-680086
                " WHERE cxg01 ='",g_smy.smyslip,"' AND ",p_wc2 CLIPPED,
                "   AND cxg02 = '",p_code CLIPPED,"' ",
                " ORDER BY cxg03 "
    PREPARE i010_pb FROM g_sql
    DECLARE cxg_cs                      #SCROLL CURSOR
        CURSOR FOR i010_pb
 
    IF p_code = '1' THEN
       CALL g_cxg.clear()
       LET g_rec_b = 0
       IF p_type = 'd' THEN
          LET g_cxg03 = ''
       END IF
    ELSE
       CALL g_cxgc.clear()
       LET g_rec_b2= 0
       IF p_type = 'd' THEN
          LET g_cxg03c= ''
       END IF
    END IF
 
    LET g_cnt = 1
    FOREACH cxg_cs INTO l_cxg03,l_cxg.*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_cxg.aag02 = i010_aag02(l_cxg.cxg05,g_aza.aza81)    #NO.FUN-730057
      LET l_cxg.aag021= i010_aag02(l_cxg.cxg051,g_aza.aza82) #FUN-680086  #NO.FUN-730057
      LET l_cxg.azf03 = i010_azf03(l_cxg03,l_cxg.cxg04)
 
      CASE p_code
           WHEN '1'    IF g_cnt = 1 THEN
                          LET g_cxg03 = l_cxg03
                       END IF
                       LET g_cxg[g_cnt].* = l_cxg.*
 
           WHEN '2'    IF g_cnt = 1 THEN
                          LET g_cxg03c = l_cxg03
                       END IF
                       LET g_cxgc[g_cnt].* = l_cxg.*
      END CASE
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '',9035,0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
    END IF
 
    CASE p_code
         WHEN '1'  CALL g_cxg.deleteElement(g_cnt)
                   LET g_rec_b = g_cnt - 1
                   DISPLAY g_rec_b TO FORMONLY.cn2
 
         WHEN '2'  CALL g_cxgc.deleteElement(g_cnt)
                   LET g_rec_b2 = g_cnt - 1
                   DISPLAY g_rec_b2 TO FORMONLY.cn4
    END CASE
 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_cxg TO s_cxg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
     #MOD-860081------add-----str---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      
      ON ACTION help          
         CALL cl_show_help()  
     #MOD-860081------add-----end---
 
   END DISPLAY
 
   DISPLAY ARRAY g_cxgc TO s_cxgc.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i010_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i010_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i010_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i010_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i010_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION dr_detail
         LET g_action_choice="dr_detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION cr_detail
         LET g_action_choice="cr_detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="cr_detail"                                           
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i010_copy()
    DEFINE l_cnt,l_i        LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
           l_rec_b          LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
           l_oldno          LIKE smy_file.smyslip,
           l_newno          DYNAMIC ARRAY OF RECORD
             newno          LIKE smy_file.smyslip
                            END RECORD,
           l_ac             LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
           l_allow_insert   LIKE type_file.num5,     #No.FUN-680122 SMALLINT,              #可新增否
           l_allow_delete   LIKE type_file.num5      #No.FUN-680122 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_smy.smyslip IS NULL  THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    OPEN WINDOW i010_c AT 4,4 WITH FORM "axc/42f/axci010c"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axci010c")
 
    LET l_oldno = g_smy.smyslip
 
    DISPLAY l_oldno TO FORMONLY.oldno
 
    LET l_allow_insert = TRUE
    LET l_allow_delete = TRUE
 
    CALL l_newno.clear()
    LET l_ac = 1
    LET l_rec_b = 0
    INPUT ARRAY l_newno WITHOUT DEFAULTS FROM s_newno.*
       ATTRIBUTE (COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_rec_b = ARR_COUNT()
          CALL cl_show_fld_cont()     #FUN-550037(smin)
 
       AFTER FIELD newno
          IF NOT cl_null(l_newno[l_ac].newno) THEN
             IF l_newno[l_ac].newno = l_oldno THEN
                CALL cl_err(l_newno[l_ac].newno,'axm-298',0)
                NEXT FIELD newno
             END IF
             CALL i010_smy('c',l_newno[l_ac].newno)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(l_newno[l_ac].newno,g_errno,0)
             END IF
          END IF
 
       AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
       ON ACTION controlp
          CASE
             WHEN  INFIELD(newno)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_smy1"
                   LET g_qryparam.default1 = l_newno[l_ac].newno
                   CALL cl_create_qry() RETURNING l_newno[l_ac].newno
                   DISPLAY BY NAME l_newno[l_ac].newno
                   NEXT FIELD newno
          END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_smy.smyslip
       CLOSE WINDOW i010_c  #MOD-590048
       RETURN
    END IF
 
    IF NOT cl_sure(20,20) THEN
       CLOSE WINDOW i010_c
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM cxg_file         #單身複製
        WHERE cxg01=g_smy.smyslip
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)   #No.FUN-660127
       CALL cl_err3("ins","x",g_smy.smyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
       RETURN
    END IF
 
    FOR l_i = 1 TO l_newno.getLength()
        IF NOT cl_null(l_newno[l_i].newno) THEN
           UPDATE x SET cxg01=l_newno[l_i].newno       #有效資料
           INSERT INTO cxg_file SELECT * FROM x
           IF SQLCA.sqlcode THEN
#             CALL cl_err(l_newno[l_i].newno,SQLCA.sqlcode,0)   #No.FUN-660127
              CALL cl_err3("ins","cxg_file",l_newno[l_i].newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
              CLOSE WINDOW i010_c
              RETURN
           ELSE
              LET g_cnt=SQLCA.SQLERRD[3]
              MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno[l_i].newno,') O.K'
           END IF
        END IF
    END FOR
    CALL cl_end(20,20)
    CLOSE WINDOW i010_c
    DISPLAY BY NAME g_smy.smyslip
    SELECT smy_file.* INTO g_smy.* FROM smy_file WHERE smyslip = l_oldno
    CALL i010_show()
 
END FUNCTION
 
FUNCTION i010_out()
DEFINE
    l_i             LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
    sr              RECORD
        cxg01       LIKE cxg_file.cxg01,
        smydesc     LIKE smy_file.smydesc,
        smydmy1     LIKE smy_file.smydmy1,
        smydmy2     LIKE smy_file.smydmy2,
        smy60       LIKE smy_file.smy60,
        gem02       LIKE gem_file.gem02,
        cxg02       LIKE cxg_file.cxg02,
        cxg03       LIKE cxg_file.cxg03,
        cxg04       LIKE cxg_file.cxg04,
        azf03       LIKE azf_file.azf03,
        cxg05       LIKE cxg_file.cxg05,
        aag02       LIKE aag_file.aag02
                    END RECORD,
    l_name          LIKE type_file.chr20     #No.FUN-680122 VARCHAR(20)               #External(Disk) file name
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
 
    CALL cl_wait()
#   CALL cl_outnam('axci010') RETURNING l_name                                     #FUN-840021 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-840021 *** ##                                                      
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           #FUN-840021                                   
   #------------------------------ CR (2) ------------------------------#
 
    LET g_sql="SELECT cxg01,smydesc,smydmy1,smydmy2,smy60,'',",
              " cxg02,cxg03,cxg04,'',cxg05,'' ",
              " FROM cxg_file,smy_file",
              " WHERE smyslip=cxg01 AND ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED
    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i010_co                         # SCROLL CURSOR
        CURSOR FOR i010_p1
 
    LET g_rlang = g_lang                               #FUN-4C0096 add
#   START REPORT i010_rep TO l_name                                                 #FUN-840021 mark
 
    FOREACH i010_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        LET sr.gem02 = i010_gem02(sr.smy60)
        LET sr.azf03 = i010_azf03(sr.cxg03,sr.cxg04)
        LET sr.aag02 = i010_aag02(sr.cxg05,g_aza.aza81)    #NO.FUN-730057
#       OUTPUT TO REPORT i010_rep(sr.*)                                             #FUN-840021 mark
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-840021 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 sr.cxg01,sr.smydesc,sr.smydmy1,sr.smydmy2,sr.smy60,sr.gem02,
                 sr.cxg02,sr.cxg03,sr.cxg04,sr.azf03,sr.cxg05,sr.aag02
     #------------------------------ CR (3) ------------------------------#
    END FOREACH
 
#   FINISH REPORT i010_rep                                                          #FUN-840021 mark
 
    CLOSE i010_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)                                               #FUN-840021 mark
 
#No.FUN-840021--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(g_wc,'smyslip,smydesc,smysys,smydmy1,smydmy2,smy60,smyuser,smygrup,smymodu,smydate')                                                                      
              RETURNING g_wc                                                                                                        
      END IF                                                                                                                        
#No.FUN-840021--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-840021 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = g_wc                                                                                                    
    CALL cl_prt_cs3('axci010','axci010',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#NO.FUN-840021 -Mark--Begin--#
#REPORT i010_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),
#   l_i             LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
#   l_str1          LIKE zaa_file.zaa08,    #No.FUN-680122 VARCHAR(40),
#   l_str2          LIKE zaa_file.zaa08,    #No.FUN-680122 VARCHAR(40),
#   l_str3          LIKE zaa_file.zaa08,    #No.FUN-680122 VARCHAR(40),
#   sr              RECORD
#       cxg01       LIKE cxg_file.cxg01,
#       smydesc     LIKE smy_file.smydesc,
#       smydmy1     LIKE smy_file.smydmy1,
#       smydmy2     LIKE smy_file.smydmy2,
#       smy60       LIKE smy_file.smy60,
#       gem02       LIKE gem_file.gem02,
#       cxg02       LIKE cxg_file.cxg02,
#       cxg03       LIKE cxg_file.cxg03,
#       cxg04       LIKE cxg_file.cxg04,
#       azf03       LIKE azf_file.azf03,
#       cxg05       LIKE cxg_file.cxg05,
#       aag02       LIKE aag_file.aag02
#                   END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.cxg01,sr.cxg02,sr.cxg03,sr.cxg04
 
#   FORMAT
#       PAGE HEADER
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#          LET g_pageno = g_pageno + 1
#          LET pageno_total = PAGENO USING '<<<',"/pageno"
#          PRINT g_head CLIPPED,pageno_total
#          PRINT
#          PRINT g_dash
#          PRINT g_x[31],
#                g_x[32],
#                g_x[33],
#                g_x[34],
#                g_x[35],
#                g_x[36],
#                g_x[37],
#                g_x[38],
#                g_x[39],
#                g_x[40],
#                g_x[41],
#                g_x[42]
#          PRINT g_dash1
#          LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.cxg01
#          CASE sr.smydmy2
#               WHEN '1'   LET l_str3 = g_x[16]
#               WHEN '2'   LET l_str3 = g_x[17]
#               WHEN '3'   LET l_str3 = g_x[18]
#               WHEN '4'   LET l_str3 = g_x[19]
#               WHEN '5'   LET l_str3 = g_x[20]
#               WHEN 'X'   LET l_str3 = g_x[21]
#          END CASE
#          PRINT COLUMN g_c[31],sr.cxg01 CLIPPED,
#                COLUMN g_c[32],sr.smydesc CLIPPED,
#                COLUMN g_c[33],sr.smydmy1 CLIPPED,
#                COLUMN g_c[34],l_str3     CLIPPED,
#                COLUMN g_c[35],sr.smy60,
#                COLUMN g_c[36],sr.gem02 CLIPPED;
 
#       BEFORE GROUP OF sr.cxg02
#          CASE sr.cxg02
#               WHEN '1'   LET l_str1 = g_x[09]
#               WHEN '2'   LET l_str1 = g_x[10]
#          END CASE
#          CASE sr.cxg03
#               WHEN '0'   LET l_str2 = g_x[11]
#               WHEN '1'   LET l_str2 = g_x[12]
#               WHEN '2'   LET l_str2 = g_x[13]
#               WHEN '3'   LET l_str2 = g_x[14]
#               WHEN '4'   LET l_str2 = g_x[15]
#          END CASE
 
#          PRINT COLUMN g_c[37],l_str1 CLIPPED,
#                COLUMN g_c[38],l_str2 CLIPPED;
 
#       ON EVERY ROW
#          PRINT COLUMN g_c[39],sr.cxg04,
#                COLUMN g_c[40],sr.azf03,
#                COLUMN g_c[41],sr.cxg05,
#                COLUMN g_c[42],sr.aag02 CLIPPED
 
#       ON LAST ROW
#           PRINT g_dash
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN 
#NO.TQC-630166 start--
#                    IF g_wc[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                     CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
#                   PRINT g_dash
#           END IF
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-840021 -Mark--End--#
#Patch....NO.TQC-610037 <> #
#CHI-B10041---add---start---
FUNCTION i010_kind(p_cmd)
DEFINE
        p_cmd         LIKE type_file.chr1,    
        l_desc        LIKE type_file.chr1000, 
        l_c30         LIKE smy_file.smydesc, 
        l_kind        LIKE type_file.chr1,   
        l_n,l_inx,l_inx1,l_str,l_end LIKE type_file.num5    

    LET g_errno = ' '

    CASE g_smy.smysys
         WHEN 'abm'  LET l_inx = 1
                     LET l_str = g_abm_str
                     LET l_end = g_abm_end

         WHEN 'aim'  LET l_inx = 2
                     LET l_str = g_aim_str
                     LET l_end = g_aim_end

         WHEN 'apm'  LET l_inx = 3
                     LET l_str = g_apm_str
                     LET l_end = g_apm_end

         WHEN 'asf'  LET l_inx = 4
                     LET l_str = g_asf_str
                     LET l_end = g_asf_end
    END CASE

    IF l_inx=0 THEN
       LET g_errno='mfg0070'
    ELSE
       FOR l_n= l_str TO l_end
           LET l_kind = g_zemsg[l_n].subString(1,1)
           IF g_smy.smykind= l_kind THEN
              LET l_desc=g_zemsg[l_n]
              LET l_c30=l_desc[2,40] 
              LET l_inx1=l_n            #check 所輸入是否已定義好
           END IF
       END FOR
       IF l_inx1=0 THEN LET g_errno='mfg0071' END IF
   END IF

   IF cl_null(g_errno)  OR p_cmd = 'd' THEN
      DISPLAY l_c30 TO FORMONLY.ename0
   END IF

END FUNCTION
#CHI-B10041---add---end---
