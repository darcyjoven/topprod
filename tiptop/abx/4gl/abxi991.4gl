# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxi991.4gl
# Descriptions...: 保稅料件替代維護作業
# Date & Author..: 98/03/31 BY CHIAYI
# Modify.........: No.FUN-530025 05/03/17 By kim 報表轉XML功能  
# Modify.........: No.MOD-580323 05/09/02 By jackie 將程序中寫死為中文的錯誤
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0046 06/10/19 By jamie 1.FUNCTION i991()_q 一開始應清空g_mea.*的值
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770005 07/07/11 By ve 報表改為使用crystal report 
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.TQC-910025 09/01/16 BY ve007 錄入和copy 欄位mea02的check的BUG 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-990116 09/10/12 By lilingyu 增加控管:非保稅料號不可維護資料
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_mea   RECORD LIKE mea_file.*,
    g_mea_t RECORD LIKE mea_file.*,
    g_mea01_t LIKE mea_file.mea01,
    g_mea02_t LIKE mea_file.mea02,
    g_mea03_t LIKE mea_file.mea03,
    g_mea04_t LIKE mea_file.mea04,
    g_mea05_t LIKE mea_file.mea05,
    g_mea06_t LIKE mea_file.mea06,
    g_wc,g_sql          STRING   #No.FUN-580092 HCN  
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING  
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680062  INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680062 CHAAR(72) 
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE g_no_ask        LIKE type_file.num5          #No.FUN-680062 SMALLINT
DEFINE l_table         STRING                       #No.FUN-770005
DEFINE g_str           STRING                       #No.FUN-770005
 
MAIN
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
#No.FUN-770005--begin--
    LET g_sql=" mea01.mea_file.mea01,",
              " mea02.mea_file.mea02,",
              "	ima02.ima_file.ima02,",
              " ima021.ima_file.ima021,",
              " mea03.mea_file.mea03,",
              " mea04.mea_file.mea04,",
              " mea05.mea_file.mea05"
    LET l_table=cl_prt_temptable('abxi991',g_sql) CLIPPED
    IF  l_table =-1 THEN EXIT PROGRAM END IF
#   LET g_sql=" INSERT INTO ds_report.",l_table CLIPPED,             # TQC-780054
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    # TQC-780054 
              " VALUES(?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#No.FUN-770005--end--
 
    INITIALIZE g_mea.* TO NULL
    INITIALIZE g_mea_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM mea_file WHERE mea01 = ? AND mea02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i991_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i991_w WITH FORM "abx/42f/abxi991" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    CALL i991_menu()
 
    CLOSE WINDOW i991_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i991cs()
    CLEAR FORM
    INITIALIZE g_mea.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
	mea02,ima02,mea01,mea03,mea04,mea05,mea06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp 
	   IF INFIELD(mea02) THEN #item 
#            CALL q_ima(10,2,g_mea.mea02) RETURNING g_mea.mea02
             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_ima"    #TQC-990116
              LET g_qryparam.form = "q_mea1"    #TQC-990116
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
	     DISPLAY g_qryparam.multiret TO mea02 
	     NEXT FIELD mea02
	   END IF
 
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
 
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT mea01,mea02 FROM mea_file ", # 組合出 SQL 指令
	" WHERE ",g_wc CLIPPED, " ORDER BY mea02"
 
    PREPARE i991_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i991cs                         # SCROLL CURSOR
	SCROLL CURSOR WITH HOLD FOR i991_prepare
    LET g_sql=
	"SELECT COUNT(*) FROM mea_file WHERE ",g_wc CLIPPED
    PREPARE i991_precount FROM g_sql
    DECLARE i991_count CURSOR FOR i991_precount
END FUNCTION
 
FUNCTION i991_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert" 
	    IF cl_chk_act_auth() THEN
		 CALL i991_a()
	    END IF
 
        ON ACTION query 
            LET g_action_choice="query"
	    IF cl_chk_act_auth() THEN
		 CALL i991_q()
	    END IF
 
        ON ACTION next 
	    CALL i991_fetch('N') 
 
        ON ACTION previous 
	    CALL i991_fetch('P')
 
        ON ACTION modify 
            LET g_action_choice="modify"
	    IF cl_chk_act_auth() THEN
		 CALL i991_u()
	    END IF
 
        ON ACTION delete 
            LET g_action_choice="delete"
	    IF cl_chk_act_auth() THEN
		 CALL i991_r()
	    END IF
       ON ACTION reproduce 
            LET g_action_choice="reproduce"
	    IF cl_chk_act_auth() THEN
		 CALL i991_copy()
	    END IF
       ON ACTION output 
            LET g_action_choice="output"
	    IF cl_chk_act_auth()
	       THEN CALL i991_out()
	    END IF
       ON ACTION help 
            CALL cl_show_help()
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#	  EXIT MENU
       ON ACTION exit
          LET g_action_choice = "exit"
	  EXIT MENU
 
       ON ACTION jump
          CALL i991_fetch('/')
       ON ACTION first
          CALL i991_fetch('F')
       ON ACTION last
          CALL i991_fetch('L')
 
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
              IF g_mea.mea02 IS NOT NULL THEN
                 LET g_doc.column1 = "mea02"
                 LET g_doc.value1 = g_mea.mea02
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
    CLOSE i991cs
END FUNCTION
 
 
FUNCTION i991_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_mea.* LIKE mea_file.*
    LET g_mea01_t = NULL                         #預設欄位值
    LET g_mea02_t = NULL                         #預設欄位值
    LET g_mea.mea03=today
    LET g_mea.mea04=today
    LET g_mea.mea05=""
    LET g_mea.mea06=today
    LET g_mea_t.*=g_mea.*
    CALL cl_opmsg('a')
    WHILE TRUE
	CALL i991_i("a")                      # 各欄位輸入
	IF INT_FLAG THEN                         # 若按了DEL鍵
	    LET INT_FLAG = 0
	    CALL cl_err('',9001,0)
	    CLEAR FORM
	    EXIT WHILE
	END IF
	IF g_mea.mea02 IS NULL THEN                # KEY 不可空白
	    CONTINUE WHILE
	END IF
	INSERT INTO mea_file VALUES(g_mea.*)       # DISK WRITE
	IF SQLCA.sqlcode THEN
#          CALL cl_err(g_mea.mea02,SQLCA.sqlcode,0) #No.FUN-660052
           CALL cl_err3("ins","mea_file",g_mea.mea01,g_mea.mea02,SQLCA.sqlcode,"","",1)
	   CONTINUE WHILE
	ELSE
	    LET g_mea_t.* = g_mea.*                # 保存上筆資料
	    SELECT mea01 INTO g_mea.mea01 FROM mea_file
		WHERE mea02 = g_mea.mea02
	END IF
	EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i991_i(p_cmd)
    DEFINE
	p_cmd           LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
	l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680062 VARCHAR(1)
	l_n             LIKE type_file.num5,          #No.FUN-680062 SMALLINT
        l_n1            LIKE type_file.num5           #No.TQC-910025
DEFINE l_ima15    LIKE ima_file.ima15     #TQC-990116
 
    INPUT BY NAME
	g_mea.mea02,g_mea.mea01, g_mea.mea03,g_mea.mea04,
	g_mea.mea05,g_mea.mea06
	WITHOUT DEFAULTS 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i991_set_entry(p_cmd)
           CALL i991_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
	AFTER FIELD mea02
          IF g_mea.mea02 IS NOT NULL THEN
            #FUN-AA0059 -----------------------------add start-------------------------
            IF NOT s_chk_item_no(g_mea.mea02,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD mea02
            END IF 
            #FUN-AA0059 -----------------------------add end-----------------------------
	    IF p_cmd = "a" THEN  # 若輸入或更改且改KEY
#		SELECT mea02 FROM mea_file WHERE mea02 = g_mea.mea02 
#		  IF SQLCA.sqlcode THEN        #TQC-910025 --MARK--
                  #TQC-910025 --begin--
                    SELECT COUNT(*) INTO l_n1 FROM mea_file 
                     WHERE mea02 = g_mea.mea02
                    IF l_n1 > 0 THEN
                       CALL cl_err('','-9914',1) 
                       NEXT FIELD mea02
                    END IF
                  #TQC-910025 --end--
		    SELECT ima01 FROM ima_file WHERE ima01 = g_mea.mea02 
		    IF SQLCA.sqlcode THEN
                       CALL cl_err('','-9911',1) 
		       LET g_mea.mea02=g_mea_t.mea02
                       NEXT FIELD mea02   #mea01         #TQC-910025 
		    END IF
#TQC-990116 --begin--
       SELECT ima15 INTO l_ima15 FROM ima_file
        WHERE ima01 = g_mea.mea02
       IF cl_null(l_ima15) OR l_ima15 = 'N' THEN 
          CALL cl_err('','abx-009',0)
          NEXT FIELD mea02
       END IF  
#TQC-990116 --end--				    
#		  END IF                                 #TQC-910025 --MARK--
            END IF
	    IF (p_cmd = "u" AND (g_mea02_t IS NOT NULL AND 
                g_mea.mea02 != g_mea02_t)) THEN 
		SELECT mea02 FROM mea_file        #檢查保稅料件BOM替代檔
                 WHERE mea02=g_mea.mea02 
		IF SQLCA.sqlcode THEN
                    CALL cl_err('','-9912',1)
		    LET g_mea.mea02=g_mea_t.mea02
		    NEXT FIELD mea02
		END IF
	    END IF
	    CALL i991_mea02('a')
	  END IF
 
	AFTER FIELD mea01   #流用代號
	    IF g_mea.mea01 <= 0 THEN
		LET g_mea.mea01=g_mea_t.mea01
		NEXT FIELD mea01
	    ELSE 
		LET g_mea.mea01 = g_mea.mea01 USING "&&&&&"
		DISPLAY g_mea.mea01 TO mea01 
	    END IF
 
        BEFORE FIELD mea03 
            IF p_cmd = "u" THEN
               LET g_mea_t.mea03=g_mea.mea03
            END IF
 
	AFTER FIELD mea03   #生效日
            LET l_n = 0 
#           IF g_mea.mea03 <> g_mea03_t THEN
#              SELECT count(*) INTO l_n FROM mea_file 
#               WHERE mea01 = g_mea.mea01 
#                 AND mea03 = g_mea.mea03 
#              IF l_n > 0 THEN
#                 ERROR "料號+生效日重覆"
#                 IF p_cmd = "u" THEN
#                    LET g_mea.mea03=g_mea03_t
#                 END IF
#                 NEXT FIELD mea03
#              END IF
#           END IF
	    LET g_mea03_t=g_mea.mea03
 
        AFTER FIELD mea04   #失效日
	  IF NOT cl_null(g_mea.mea04) THEN
	    IF g_mea.mea04 < g_mea.mea03 THEN
               CALL cl_err('','-9913',1)
               LET g_mea.mea04=g_mea04_t
               NEXT FIELD mea03
	    END IF
	    LET g_mea04_t=g_mea.mea04
	  END IF
 
	AFTER FIELD mea05   #核准文號 
#          IF cl_null(g_mea.mea05) THEN    
#              LET g_mea.mea05=g_mea05_t 
#              NEXT FIELD mea05
#          END IF
#          LET g_mea05_t=g_mea.mea05
 
	AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
	    LET l_flag='N'
	    IF INT_FLAG THEN
		EXIT INPUT  
	    END IF
	    IF g_mea.mea02 IS NULL THEN
	       LET l_flag='Y'
	       DISPLAY BY NAME g_mea.mea02 
	    END IF
	    IF (g_mea.mea01 IS NULL) OR (g_mea.mea01 <=0) THEN
	       LET l_flag='Y'
	       DISPLAY BY NAME g_mea.mea01 
	    END IF
	    IF cl_null(g_mea.mea03) THEN       
	       LET l_flag='Y'
	       DISPLAY BY NAME g_mea.mea03 
	    END IF
	    IF cl_null(g_mea.mea04) OR (g_mea.mea03 > g_mea.mea04) THEN       
	       LET l_flag='Y'
	       DISPLAY BY NAME g_mea.mea04 
	    END IF
	#   IF cl_null(g_mea.mea05) THEN
	#      LET l_flag='Y'
	#      DISPLAY BY NAME g_mea.mea05 
	#   END IF
	    IF cl_null(g_mea.mea06) THEN       
	       LET l_flag='Y'
	       DISPLAY BY NAME g_mea.mea06 
	    END IF
	    IF l_flag='Y' THEN
		 CALL cl_err('','9033',0)
		 NEXT FIELD mea01
	    END IF
        
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
	#    IF INFIELD(mea02) THEN
	#	LET g_mea.* = g_mea_t.*
	#	DISPLAY BY NAME g_mea.* 
	#	NEXT FIELD mea02
	#    END IF
        #MOD-650015 --end
 
        ON ACTION controlp 
	   CASE
              WHEN INFIELD(mea02) 
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
     #        #    LET g_qryparam.form = "q_ima"    #TQC-990116
              #    LET g_qryparam.form = "q_ima991"    #TQC-990116   
              #   LET g_qryparam.default1 = g_mea.mea02
              #   CALL cl_create_qry() RETURNING g_mea.mea02
                 CALL q_sel_ima(FALSE, "q_ima991", "",g_mea.mea02, "", "", "", "" ,"",'' )  RETURNING g_mea.mea02
#FUN-AA0059 --End--
	         DISPLAY BY NAME g_mea.mea02 
	         NEXT FIELD mea02
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
END FUNCTION
 
FUNCTION i991_mea02(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
   l_ima02         LIKE ima_file.ima02 
   select ima02 INTO l_ima02 FROM ima_file 
   where ima01 = g_mea.mea02 
   DISPLAY l_ima02  TO ima02 
END FUNCTION
 
 
FUNCTION i991_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_mea.* TO NULL             #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL i991cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
	LET INT_FLAG = 0
	CLEAR FORM
	RETURN
    END IF
    OPEN i991_count
    FETCH i991_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
    OPEN i991cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
	CALL cl_err(g_mea.mea02,SQLCA.sqlcode,0)
	INITIALIZE g_mea.* TO NULL
    ELSE
	CALL i991_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i991_fetch(p_flmea)
    DEFINE
        p_flmea         LIKE type_file.chr1,          #No.FUN-680062    VARCHAR(1(1) 
	l_abso          LIKE type_file.num10          #No.FUN-680062    INTEGER
 
    CASE p_flmea
	WHEN 'N' FETCH NEXT     i991cs INTO g_mea.mea01,g_mea.mea02
	WHEN 'P' FETCH PREVIOUS i991cs INTO g_mea.mea01,g_mea.mea02
	WHEN 'F' FETCH FIRST    i991cs INTO g_mea.mea01,g_mea.mea02
	WHEN 'L' FETCH LAST     i991cs INTO g_mea.mea01,g_mea.mea02
	WHEN '/'
            IF (NOT g_no_ask) THEN
	       CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
	       PROMPT g_msg CLIPPED,': ' FOR g_jump
	          ON IDLE g_idle_seconds
	             CALL cl_on_idle()
#	             CONTINUE PROMPT
 
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
	    FETCH ABSOLUTE g_jump i991cs INTO g_mea.mea01,g_mea.mea02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
	CALL cl_err(g_mea.mea02,SQLCA.sqlcode,0)
	INITIALIZE g_mea.* TO NULL  #TQC-6B0105
	RETURN
    ELSE
       CASE p_flmea
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_mea.* FROM mea_file            # 重讀DB,因TEMP有不被更新特性
       WHERE mea01 = g_mea.mea01 AND mea02 = g_mea.mea02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_mea.mea02,SQLCA.sqlcode,0)    #No.FUN-660052
       CALL cl_err3("sel","mea_file",g_mea.mea02,"",SQLCA.sqlcode,"","",1)
    ELSE
 
	CALL i991_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i991_show()
    LET g_mea_t.* = g_mea.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_mea.*
    DISPLAY BY NAME g_mea.mea02,g_mea.mea01,g_mea.mea03,g_mea.mea04,
                    g_mea.mea05,g_mea.mea06
    #No.FUN-9A0024--end  
    CALL i991_mea02('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i991_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_mea.mea02 IS NULL THEN
	CALL cl_err('',-400,0)
	RETURN
    END IF
    SELECT * INTO g_mea.* FROM mea_file WHERE mea02=g_mea.mea02 
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_mea01_t = g_mea.mea01
    LET g_mea02_t = g_mea.mea02
    LET g_mea03_t = g_mea.mea03
    LET g_mea04_t = g_mea.mea04
    LET g_mea05_t = g_mea.mea05
    LET g_mea06_t = g_mea.mea06
    BEGIN WORK
 
    OPEN i991_cl USING g_mea.mea01,g_mea.mea02
    IF STATUS THEN
       CALL cl_err("OPEN i991_cl:", STATUS, 1)
       CLOSE i991_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i991_cl INTO g_mea.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
	CALL cl_err(g_mea.mea02,SQLCA.sqlcode,0)
	RETURN
    END IF
    CALL i991_show()                          # 顯示最新資料
    WHILE TRUE
	CALL i991_i("u")                      # 欄位更改
	IF INT_FLAG THEN
	    LET INT_FLAG = 0
	    LET g_mea.*=g_mea_t.*
	    CALL i991_show()
	    CALL cl_err('',9001,0)
	    EXIT WHILE
	END IF
     UPDATE mea_file SET mea_file.* = g_mea.*           # 更新DB
      WHERE mea01 = g_mea01_t AND mea02 = g_mea02_t     # COLAUTH?       
	IF SQLCA.sqlcode THEN
#          CALL cl_err(g_mea.mea02,SQLCA.sqlcode,0)  #No.FUN-660052
           CALL cl_err3("sel","mea_file",g_mea01_t,g_mea02_t,SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
	END IF
	EXIT WHILE
    END WHILE
    CLOSE i991_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i991_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_mea.mea02 IS NULL THEN
	CALL cl_err('',-400,0)
	RETURN
    END IF
    BEGIN WORK
 
    OPEN i991_cl USING g_mea.mea01,g_mea.mea02
    IF STATUS THEN
       CALL cl_err("OPEN i991_cl:", STATUS, 1)
       CLOSE i991_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i991_cl INTO g_mea.*
    IF SQLCA.sqlcode THEN
	CALL cl_err(g_mea.mea02,SQLCA.sqlcode,0)
	RETURN
    END IF
    CALL i991_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "mea02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_mea.mea02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM mea_file WHERE mea01 = g_mea.mea01 AND mea02 = g_mea.mea02  
       CLEAR FORM
       OPEN i991_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i991cs
          CLOSE i991_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i991_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i991cs
          CLOSE i991_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i991cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i991_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i991_fetch('/')
       END IF
 
    END IF
    CLOSE i991_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i991_copy()
    DEFINE
	l_mea           RECORD LIKE mea_file.*,
	l_newno,l_oldno        LIKE mea_file.mea02
    DEFINE l_n    LIKE type_file.num5    #TQC-910025
    DEFINE l_ima15           LIKE ima_file.ima15    #TQC-990116
 
    IF s_shut(0) THEN RETURN END IF
    IF g_mea.mea02 IS NULL THEN
	CALL cl_err('',-400,0)
	RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i991_set_entry('a')
    CALL i991_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM mea02
	AFTER FIELD mea02
          IF l_newno IS NOT NULL THEN
          #FUN-AA0059 ------------------------------add start----------------------
          IF NOT s_chk_item_no(l_newno,'')  THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD mea02
          END IF 
          #FUN-AA0059 ------------------------------ add end-----------------------    
#TQC-910025 --BEGIN--
#	    SELECT mea02            #保稅BOM替代檔
#		FROM mea_file
#		WHERE mea02=l_newno
#	    IF SQLCA.sqlcode THEN
             SELECT COUNT(*) INTO l_n            #保稅BOM替代檔                                                                                  
               FROM mea_file                                                                                                       
               WHERE mea02=l_newno
            IF l_n >0 THEN
                CALL cl_err('','-9914',1)
		NEXT FIELD mea02
	    END IF
#TQC-990116 --begin--
		   SELECT ima01 FROM ima_file WHERE ima01 = l_newno 
		   IF SQLCA.sqlcode THEN
           CALL cl_err('','-9911',1) 
           NEXT FIELD mea02   
		   END IF
       SELECT ima15 INTO l_ima15 FROM ima_file
        WHERE ima01 = l_newno
       IF cl_null(l_ima15) OR l_ima15 = 'N' THEN 
          CALL cl_err('','abx-009',0)
          NEXT FIELD mea02
       END IF  
#TQC-990116 --end--			    
	  END IF
 
        ON ACTION controlp 
	   CASE
              WHEN INFIELD(mea02) 
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
      #        #  LET g_qryparam.form = "q_ima"   #TQC-990116
               #  LET g_qryparam.form = "q_ima991"    #TQC-990116  
               #  LET g_qryparam.default1 = l_newno
               #  CALL cl_create_qry() RETURNING l_newno
                 CALL q_sel_ima(FALSE, "q_ima991", "", l_newno, "", "", "", "" ,"",'' )  RETURNING l_newno    
#FUN-AA0059 --End-- 
	         DISPLAY BY NAME l_newno 
	         NEXT FIELD mea02
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
	RETURN
    END IF
    LET l_mea.* = g_mea.*
    LET l_mea.mea02  =l_newno   #新的鍵值
    INSERT INTO mea_file VALUES (l_mea.*)
    IF SQLCA.sqlcode THEN
#      CALL cl_err('mea:',SQLCA.sqlcode,0)    #No.FUN-660052
       CALL cl_err3("ins","mea_file",l_mea.mea01,g_mea.mea02,SQLCA.sqlcode,"","mea:",1)
    ELSE
	MESSAGE 'COPY ROW(',l_newno,') O.K' 
	LET l_oldno = g_mea.mea02
	SELECT mea01,mea_file.* INTO g_mea.mea01,g_mea.* FROM mea_file
		       WHERE mea02 = l_newno 
	CALL i991_u()
	#SELECT mea01,mea_file.* INTO g_mea.mea01,g_mea.* FROM mea_file #FUN-C30027
	#	       WHERE mea02 = l_oldno #FUN-C30027
    END IF
    CALL i991_show()
END FUNCTION
 
FUNCTION i991_out()
    DEFINE
	l_i             LIKE type_file.num5,          #No.FUN-680062 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680062 VARCHAR(20)
        l_za05          LIKE za_file.za05,            #No.FUN-680062 VARCHAR(40)
	sr RECORD LIKE mea_file.*,
        l_ima02   like ima_file.ima02,                #No.FUN-770005                                                                       
        l_ima021   like ima_file.ima021               #No,FUN-770005
    CALL cl_del_data(l_table)
    IF g_wc IS NULL THEN
	CALL cl_err('',9057,0)
	RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('abxi991') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    LET g_sql="SELECT * FROM mea_file ",          # 組合出 SQL 指令
	      " WHERE ",g_wc CLIPPED
    PREPARE i991_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i991_co                         # SCROLL CURSOR
	 CURSOR FOR i991_p1
#No.FUN-770005--begin--
#   START REPORT i991_rep TO l_name
 
    FOREACH i991_co INTO sr.*
	IF SQLCA.sqlcode THEN
	    CALL cl_err('foreach:',SQLCA.sqlcode,1)
	    EXIT FOREACH
	    END IF
            MESSAGE g_x[9],sr.mea02,' ',g_x[10],sr.mea01
#	OUTPUT TO REPORT i991_rep(sr.*)
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                                                                  
               WHERE ima01=sr.mea02                                                                                                 
           IF SQLCA.sqlcode THEN                                                                                                    
               LET l_ima02 = NULL                                                                                                   
               LET l_ima021 = NULL                                                                                                  
           END IF    
    let sr.mea05 = ""                                                                                                        
          declare selme cursor for                                                                                                 
              select bnd04 from bnd_file                                                                                            
          where bnd01 = sr.mea02                                                                                                   
          order by bnd02 desc                                                                                                      
          foreach selme into sr.mea05                                                                                              
              exit foreach                                                                                                         
          end foreach   
     EXECUTE insert_prep USING 
            sr.mea01,sr.mea02,l_ima02,l_ima021,sr.mea03,sr.mea04,sr.mea05   
    END FOREACH
#No.FUN-770005 --mark--
{   FINISH REPORT i991_rep
 
    CLOSE i991_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
}
#No.FUN-770005 --end--
#No.FUN-770005 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'mea02,ima02,mea01,mea03,mea04,mea05,mea06')
            RETURNING g_wc
       LET g_str = g_wc
    END IF
    LET g_str=g_wc
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('abxi991','abxi991',g_sql,g_str)
#No.FUN-770005 --end--
END FUNCTION
#No.FUN-770005 --start--
{
REPORT i991_rep(sr)
    DEFINE
        l_trailer_sw   LIKE  type_file.chr1,          #No.FUN-680062 VARCHAR(1)
	sr RECORD LIKE mea_file.*,
               l_ima02   like ima_file.ima02,
               l_ima021   like ima_file.ima021
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.mea01
 
    FORMAT
	PAGE HEADER
           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
           LET g_pageno=g_pageno+1
           LET pageno_total=PAGENO USING '<<<','/pageno'
           PRINT g_head CLIPPED,pageno_total
           PRINT 
           PRINT g_dash
           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
           PRINT g_dash1
           LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.mea01
           LET l_trailer_sw = 'y'
           PRINT COLUMN g_c[31],g_x[11],sr.mea01  
 
        AFTER GROUP OF sr.mea01
              SKIP 2 LINES
 
        ON EVERY ROW
           SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
               WHERE ima01=sr.mea02
           IF SQLCA.sqlcode THEN 
               LET l_ima02 = NULL 
               LET l_ima021 = NULL 
           END IF
           let sr.mea05 = ""
           declare selme cursor for 
              select bnd04 from bnd_file 
           where bnd01 = sr.mea02 
           order by bnd02 desc 
           foreach selme into sr.mea05 
               exit foreach 
           end foreach 
           PRINT COLUMN g_c[31],sr.mea02,
                 COLUMN g_c[32],l_ima02,
                 COLUMN g_c[33],l_ima021,
                 COLUMN g_c[34],sr.mea03 USING "YYYYMMDD",
                 COLUMN g_c[35],sr.mea04 USING "YYYYMMDD",
                 COLUMN g_c[36],sr.mea05                  
 
         ON LAST ROW
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
#No.FUN-770005--end--
FUNCTION i991_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("mea01,mea02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i991_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("mea01,mea02",FALSE)
   END IF
END FUNCTION
#No.FUN-770005 --end--
