# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: aimp400
# Descriptions...: 倉庫間調撥-撥出確認作業
# Date & Author..: 92/05/07 By Wu
#        MODIFY..: 92/06/30 By MAY
#        MODIFY..: 93/06/25 By STone 庫存不足,不能調撥
#        MODIFY..: 93/07/31 BY Apple
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No:FIN-660078 06/06/13 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 
# Modify.........: No.TQC-930155 09/04/07 By dongbg 事務修改
# Modify.........: No.TQC-940045 09/04/15 By destiny SQLCA.SQLERRD[3]始終為0,導致程序抓的筆數一直為0
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AB0058 10/11/08 By yinhy 审核段增加倉庫權限控管
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
# Modify.........: No.FUN-BB0084 11/12/07 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:TQC-D70050 13/07/22 By qirl 調撥單號，料件編號欄位增加開窗 料件名稱欄位下面把料件的規格值取出來顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_imm           RECORD LIKE imm_file.*,
    g_go            LIKE type_file.chr1,          #是否通過密碼檢查 #No.FUN-690026 VARCHAR(1)
    g_wc,g_sql      string,                       #WHERE CONDITION  #No.FUN-580092 HCN
    g_pass          LIKE gen_file.gen01,          #確認人員 #FUN-660078
    g_pp            RECORD
                    dummy LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                    pass LIKE azb_file.azb02,
                    cdate LIKE type_file.dat      #No.FUN-690026 DATE
                    END RECORD,
    g_img           RECORD LIKE img_file.*,
    g_imn           RECORD LIKE imn_file.*,
    g_imn01         LIKE imn_file.imn01,
    g_imn02         LIKE imn_file.imn02,
    g_imn11         LIKE imn_file.imn11
 
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10,  #No.FUN-690026 INTEGER
       mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
 
MAIN
 
DEFINE
    l_n             LIKE type_file.num10,  #No.FUN-690026 INTEGER
    l_go            LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    OPTIONS
        FORM        LINE FIRST + 2,
        MESSAGE     LINE LAST,
        PROMPT      LINE LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN EXIT PROGRAM END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AIM")) THEN EXIT PROGRAM END IF
    
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
    IF g_sma.sma12 MATCHES '[nN]' THEN   #單倉
       CALL cl_err('','mfg1305',2)
       EXIT PROGRAM
    END IF
    LET l_go='N'
    IF NUM_ARGS() > 0 THEN
        LET l_n = ARG_VAL(1)
        LET l_go='Y'
    END IF
    IF l_go='Y' THEN
        IF l_n <0 OR l_n > 1 THEN
           LET l_n=NULL
           LET l_go='N'
        END IF
    END IF
 
 
    LET p_row = 2 LET p_col = 5
    OPEN WINDOW p400_w  AT p_row,p_col
        WITH FORM "aim/42f/aimp400"
       #WITH FORM "/u2/usr/ching/gnr/9326/inf/42f/aimp400"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL p400_pass()
    IF g_go='N' THEN
        EXIT PROGRAM
    END IF
#    CALL p400_q()
    WHILE TRUE
      LET g_action_choice = ""
      CALL p400_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW p400_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p400_cs()
    WHILE TRUE
     #將查詢條件輸入
      INITIALIZE g_imn01 TO NULL  #FUN-640213 add
      INITIALIZE g_imn02 TO NULL  #FUN-640213 add
      CONSTRUCT g_wc ON imn01,imn02,imn03
				   FROM imn01,imn02,imn03   # 螢幕上取單頭條件
					HELP 1  	
   #TQC-D70050--add--start
      ON ACTION CONTROLP
         IF INFIELD (imn01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_imn01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imn01
            NEXT FIELD imn01
         END IF
         IF INFIELD (imn03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_imn03"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imn03
            NEXT FIELD imn03
         END IF
   #TQC-D70050--add--end
      #-----TQC-860018---------
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      #-----END TQC-860018----- 
     	IF INT_FLAG THEN EXIT WHILE END IF
 
      LET g_sql=" SELECT UNIQUE imn01,imn02 ",
	        " FROM imn_file,imm_file ",
                " WHERE imn12 IN ('N','n') AND ",g_wc CLIPPED,
                " AND imm10 = '2' ",
                " AND imm01 = imn01 ",
                " ORDER BY imn01,imn02"
      PREPARE p400_prepare FROM g_sql
      DECLARE p400_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR p400_prepare
 
      # 取合乎條件筆數
      #若使用組合鍵值, 則可以使用本方法去得到筆數值
      PREPARE p400_pp  FROM g_sql
      DECLARE p400_cnt   CURSOR FOR p400_pp
      EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION p400_menu()
      MENU ""
 
        BEFORE MENU
           MESSAGE ''
           CALL ui.Interface.refresh()
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION Query
           LET g_action_choice="Query"
           IF cl_chk_act_auth() THEN
		CALL p400_q()
	   END IF
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
 
      ON ACTION first
         CALL p400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION previous
         CALL p400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION jump
         CALL p400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION next
         CALL p400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION last
         CALL p400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION exit
           LET g_action_choice='exit'
           EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION Confirm
	   CALL p400_con()
	END MENU
END FUNCTION
 
#確認動作
FUNCTION p400_con()
  DEFINE l_number   LIKE imn_file.imn11,    #MOD-530179
         l_cdate    LIKE type_file.dat,     #No.FUN-690026 DATE
         l_ans      LIKE type_file.num5,     #No.FUN-690026 SMALLINT
         l_imn01      LIKE imn_file.imn01,   #No.FUN-AB0058 add
         l_imn04      LIKE imn_file.imn04,   #No.FUN-AB0058 add
         l_imm08      LIKE imm_file.imm08    #No.FUN-AB0058 add
   # SELECT imn01 FROM imn_file where imn01=g_imn01
   #                               and imn02=g_imn02
   #                               and imn12 IN ( 'n','N')
#No.FUN-AB0058  --Begin 
    SELECT imn01,imn04,imm08 INTO l_imn01,l_imn04,l_imm08
                             FROM imn_file,imm_file
                            WHERE imn01=g_imn01
                              AND imn01=imm01
                              AND imn02=g_imn02
                              AND imn12 IN ( 'n','N')
    IF status THEN RETURN END IF
WHILE TRUE
    IF NOT s_chk_ware(l_imn04) THEN RETURN END IF
    IF NOT s_chk_ware(l_imm08) THEN RETURN END IF
#No.FUN-AB0058  --End

    LET l_cdate = g_today
    INPUT l_number,l_cdate  WITHOUT DEFAULTS FROM number,cdate HELP 1
 
        BEFORE FIELD number
			LET l_number = g_imn11
			DISPLAY l_number TO number
 
        AFTER FIELD number
			IF l_number IS NULL OR l_number = ' ' THEN
				NEXT FIELD number
			END IF
            LET l_number = s_digqty(l_number,g_imn.imn09)     #FUN-BB0084
            DISPLAY l_number TO number                        #FUN-BB0084   
            CALL p400_ckqty(l_number) RETURNING l_ans
            IF l_ans = 0 THEN EXIT WHILE END IF
 
        BEFORE FIELD cdate
			LET l_cdate = g_pp.cdate
			DISPLAY l_cdate TO cdate
 
        AFTER FIELD cdate
			IF l_cdate IS NULL OR l_cdate= ' ' THEN
				NEXT FIELD cdate
			END IF
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         #-----TQC-860018---------
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
         #-----END TQC-860018----- 
    END INPUT
    IF INT_FLAG THEN                         # 若按了DEL鍵
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
         EXIT WHILE
    ELSE
       IF cl_sure(0,0) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            IF p400_t(l_cdate,l_number) THEN
    	    	#CALL cl_err('','mfg0073',0) #No.052 010404 by plum
                LET g_msg='date: ',l_cdate,' number:',l_number
    	    	CALL cl_err(g_msg,'9050',0)
                EXIT WHILE
            END IF
            CALL p400_free()
            IF g_success = 'Y'
            THEN CALL cl_cmmsg(1) COMMIT WORK
                 DISPLAY 'Y' TO FORMONLY.x
             ELSE CALL cl_rbmsg(1) ROLLBACK WORK
             END IF
         END IF
    END IF
    EXIT WHILE
	LET l_number = ' '
	LET l_cdate  = ' '
 END WHILE
END FUNCTION
 
FUNCTION p400_ckqty(p_number)
   DEFINE l_chr	    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_msg     LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(80)
          p_number  LIKE img_file.img10,    #撥出數量
          l_img10   LIKE img_file.img10     #庫存數量
 
#  WHENEVER ERROR CONTINUE
   SELECT img10 INTO l_img10
     FROM img_file
    WHERE img01=g_imn.imn03 AND img02=g_imn.imn04
          AND img03=g_imn.imn05 AND img04=g_imn.imn06
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_imn.imn03,'mfg6142',1) #No.FUN-660156
      CALL cl_err3("sel","img_file",g_imn.imn03,"","mfg6142","","",1)  #No.FUN-660156
      RETURN 0
   END IF
   IF l_img10 < p_number  THEN
      OPEN WINDOW ckqty_w AT 19,10 WITH 3 ROWS, 60 COLUMNS
      CALL cl_getmsg('mfg6141',g_lang) RETURNING l_msg
      WHILE TRUE
         PROMPT l_msg CLIPPED  FOR CHAR l_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         END PROMPT
         IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE  END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 LET l_chr = "N" END IF
         CLOSE WINDOW ckqty_w RETURN 0
      END WHILE
   ELSE
      RETURN 1
   END IF
END FUNCTION
 
#Query 查詢
FUNCTION p400_q()
DEFINE    l_sw   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
	CALL cl_opmsg('q')
	MESSAGE ""
        CALL ui.Interface.refresh()
	CLEAR FORM
        INITIALIZE g_imm.* TO NULL
	DISPLAY '   ' TO FORMONLY.cnt
	CALL p400_cs()
	IF INT_FLAG THEN
	   LET INT_FLAG = 0
	   CLEAR FORM
           INITIALIZE g_imm.* TO NULL
           RETURN
	END IF
	OPEN p400_cs
	IF SQLCA.sqlcode THEN
	   CALL cl_err('',SQLCA.sqlcode,0)
	   RETURN
	END IF
        LET l_sw = ' '
	FOREACH p400_cnt INTO g_imn01,g_imn02
        #No.TQC-940045--begin
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
#              LET g_row_count=SQLCA.SQLERRD[3]
	      EXIT FOREACH
            END IF 
            LET g_row_count=g_row_count+1 
            LET l_sw = 'N'   #若抓不到資料時不會走FOREACH故多加判斷
        #No.TQC-940045--end
	END FOREACH
        IF l_sw != 'N' THEN
           LET g_row_count = 0
        END IF
	DISPLAY g_row_count TO FORMONLY.cnt
	CALL p400_fetch('F')	#讀出TEMP第一筆並顯示
END FUNCTION
 
#處理資料的讀取
FUNCTION p400_fetch(p_flag)
DEFINE
	p_flag	LIKE type_file.chr1,    #處理方式  #No.FUN-690026 VARCHAR(1)
	l_msg   LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(50)
	l_abso	LIKE type_file.num10    #絕對的筆數  #No.FUN-690026 INTEGER
 
	CASE p_flag
		WHEN 'N' FETCH NEXT     p400_cs INTO g_imn01,g_imn02
		WHEN 'P' FETCH PREVIOUS p400_cs INTO g_imn01,g_imn02
		WHEN 'F' FETCH FIRST    p400_cs INTO g_imn01,g_imn02
		WHEN 'L' FETCH LAST     p400_cs INTO g_imn01,g_imn02
		WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
            FETCH ABSOLUTE g_jump p400_cs INTO g_imn01,g_imn02 --改g_jump
            LET mi_no_ask = FALSE
	END CASE
 
       IF SQLCA.sqlcode THEN
        	LET l_msg = g_imn01,'+',g_imn02 clipped
		CALL cl_err(l_msg,SQLCA.SQLCODE,0)
		INITIALIZE g_imn.* TO NULL  #TQC-6B0105
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
 
       LET g_imn11 = 0
       CALL p400_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p400_show()
 DEFINE
		l_gen02  LIKE   gen_file.gen02,
		l_gen03  LIKE   gen_file.gen03,
		l_gem02  LIKE   gem_file.gem02,
		l_ima02  LIKE   ima_file.ima02,
                l_ima021 LIKE   ima_file.ima021,  #TQC-D70050 add
		l_ima05  LIKE   ima_file.ima05,
		l_ima08  LIKE   ima_file.ima08
 
    SELECT imm_file.*,gen02,gen03 INTO g_imm.*,l_gen02,l_gen03
      FROM  imm_file , OUTER gen_file
     WHERE imm01 = g_imn01 AND imm_file.imm09 = gen_file.gen01
 
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_gen03
 
     SELECT imn_file.*,ima02,ima021,ima05,ima08 #,ima86 #FUN-560183  #TQC-D70050 add ima021
       INTO g_imn.*,l_ima02,l_ima021,l_ima05,l_ima08  #g_ima86 #FUN-560183 #TQC-D70050 add ima021
       FROM imn_file ,ima_file
      WHERE imn01 = g_imn01  AND imn02 = g_imn02
        AND imn03 = ima01
    DISPLAY l_gen02 TO  gen02
    DISPLAY l_gen03 TO  gen03
    DISPLAY l_gem02 TO  gem02
    DISPLAY l_ima02 TO  ima02
    DISPLAY l_ima021 TO ima021    #TQC-D70050 add ima021
    DISPLAY l_ima05 TO  ima05
    DISPLAY l_ima08 TO  ima08
 
    DISPLAY BY NAME g_imm.imm02,g_imm.imm09,
                    g_imm.imm07,g_imm.imm08
 
    DISPLAY BY NAME g_imn.imn01,g_imn.imn02,g_imn.imn03,g_imn.imn04,
					g_imn.imn05,g_imn.imn06,g_imn.imn07,
					g_imn.imn08,g_imn.imn09,g_imn.imn10
    DISPLAY 'N' TO FORMONLY.x
    LET g_imn11 = g_imn.imn10
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#檢查密碼
FUNCTION p400_pass()
DEFINE
    l_azb02         LIKE azb_file.azb02,
    l_gen02         LIKE gen_file.gen02
 
    LET g_go='N'
    OPEN WINDOW cl_pass_w WITH FORM "aim/42f/aimp4001"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("aimp4001")
 
    LET g_pp.pass=NULL
    LET g_cnt=1
	LET g_pp.cdate = g_today
    WHILE TRUE
        INPUT g_pass,g_pp.cdate,g_pp.pass WITHOUT DEFAULTS
            FROM u,cdate,pass
            AFTER FIELD u
                IF g_pass IS NULL THEN
                    NEXT FIELD u
                END IF
                SELECT azb02
                    INTO l_azb02
                    FROM azb_file
                    WHERE azb01=g_pass
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pass,'aoo-001',0) #No.FUN-660156
                   CALL cl_err3("sel","azb_file",g_pass,"","aoo-001","","",0)  #No.FUN-660156
                   NEXT FIELD u
                END IF
		SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_pass
                DISPLAY l_gen02 TO gen02
            AFTER FIELD cdate
                IF g_pp.cdate IS NULL OR g_pp.cdate = ' '
                THEN NEXT FIELD cdate
                END IF
                IF l_azb02 IS NULL OR l_azb02=' ' THEN   #沒有設定密碼
                     LET g_go='Y'
                     EXIT INPUT
                END IF
            BEFORE FIELD pass
                CALL cl_getmsg('aoo-002',g_lang) RETURNING g_msg
               #DISPLAY g_msg AT 1,12   #CHI-A70049 mark
                DISPLAY BY NAME g_pp.pass
            AFTER FIELD pass
                IF g_pp.pass IS NULL THEN
                    NEXT FIELD pass
                END IF
                IF g_pp.pass != l_azb02 THEN
                    CALL cl_err(g_cnt,'aoo-003',0)
                    LET g_cnt=g_cnt+1
                    LET g_pp.pass=NULL
                    IF g_cnt > 3 THEN
                        SLEEP 2
                        EXIT INPUT
                    ELSE
                        NEXT FIELD pass
                    END IF
                ELSE
                    LET g_go='Y'
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
             LET INT_FLAG=0
             EXIT WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE WINDOW cl_pass_w
END FUNCTION
 
FUNCTION p400_t(p_cdate,p_number)
DEFINE  l_qty       LIKE imn_file.imn11,
        l_sql       LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(200)
        p_cdate     LIKE type_file.dat,     #No.FUN-690026 DATE
        p_number    LIKE imn_file.imn11
 
    IF p_number IS NULL THEN RETURN 1 END IF
    #TQC-930155 begin 
   #LET l_sql=" SELECT * FROM img_file ", #TQC-870018
    LET l_sql=" SELECT img_file.* FROM img_file ", #TQC-870018
    #TQC-930155 end 
              "       WHERE img01 = '",g_imn.imn03,"' AND ",
              "             img02 = '",g_imn.imn04,"'"
    IF g_imn.imn05 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED," AND img03='",g_imn.imn05,"' "
    ELSE
         LET l_sql=l_sql CLIPPED," AND img03 IS NULL "
    END IF
    IF g_imn.imn06 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED," AND img04='",g_imn.imn06,"' "
    ELSE
         LET l_sql=l_sql CLIPPED," AND img04 IS NULL "
    END IF
    PREPARE p400_pre2 FROM l_sql
    DECLARE p400_img_lock SCROLL CURSOR WITH HOLD FOR p400_pre2
    OPEN p400_img_lock
    #TQC-930155 begin
    IF SQLCA.sqlcode THEN
       #---->已被別的使用者鎖住
       IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
          CALL cl_err('','mfg3465',1)
          RETURN 1
       ELSE
          CALL cl_err('','mfg3466',1)
          RETURN 1
       END IF
    END IF
    #TQC-930155 end
    FETCH p400_img_lock INTO g_img.* #TQC-870018
       IF SQLCA.sqlcode THEN
           #---->已被別的使用者鎖住
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               CALL cl_err('','mfg3465',1)
               RETURN 1
           ELSE
               CALL cl_err('','mfg3466',1)
               RETURN 1
           END IF
       END IF
 
    LET l_qty = p_number*g_img.img21
 
    #FUN-550011................begin
    IF NOT s_stkminus(g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06,
                     #g_imn.imn10,1,g_imm.imm02,g_sma.sma894[4,4]) THEN #FUN-D30024--mark
                      g_imn.imn10,1,g_imm.imm02) THEN                   #FUN-D30024--add
       LET g_success='N'
       RETURN
    END IF
    #FUN-550011................end
 
   
#---->更新倉庫庫存明細資料
    #             1          2    3        4
    #No.FUN-8C0084--BEGIN--
    IF g_imn.imn05 IS NULL THEN  LET g_imn.imn05 = '' END IF
    IF g_imn.imn06 IS NULL THEN  LET g_imn.imn06 = '' END IF
   #No.FUN-8C0084--END--
    #  CALL s_upimg(' ',-1,p_number,g_imm.imm02,     #FUN-8C0084  
       CALL s_upimg(g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06,-1,p_number,g_imm.imm02, #FUN-8C0084
       #   5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22
        g_img.img01,g_img.img02,g_img.img03,g_img.img04,'','','','','','','','','','','','','','')
    IF g_success = 'N' THEN RETURN 1 END IF
 
#---->若庫存異動後其庫存量小於等於零時將該筆資料刪除
      CALL s_delimg(g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06) #FUN-8C0083
 
#---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    IF s_udima(g_imn.imn03,            #料件編號
			   g_img.img23,            #是否可用倉儲
			   g_img.img24,            #是否為MRP可用倉儲
			   l_qty,                  #撥出數量(換算為庫存單位)
			   p_cdate,                #最近一次撥出日期
			   -1)                     #表撥出
    	THEN RETURN 1
	END IF
    IF g_success = 'N' THEN RETURN 1 END IF
 
#---->更新調撥單單身 {ckp#2}
    UPDATE imn_file SET imn11 = p_number,    #累計撥出數量
					    imn12 = 'Y',         #撥出確認
					    imn13 = g_pass,      #確認人員
				    	imn14 = p_cdate      #確認日期
          WHERE imn01 = g_imn01
            AND imn02 = g_imn02
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       LET g_success='N'
#      CALL cl_err('(p400_t:ckp#2)',SQLCA.sqlcode,1) #No.FUN-660156
       CALL cl_err3("upd","imn_file",g_imn01,g_imn02,SQLCA.sqlcode,"","",1)  #No.FUN-660156
       RETURN 1
    END IF
 
#---->產生異動記錄資料
    CALL p400_log(1,0,'',g_imn.imn03,p_number)
    IF g_success = 'N' THEN RETURN 1 END IF
    RETURN 0
END FUNCTION
 
FUNCTION p400_free()
    CLOSE p400_img_lock
END FUNCTION
 
#--------------------------------------------------------------------
#處理異動記錄
FUNCTION p400_log(p_stdc,p_reason,p_code,p_item,p_qty)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02 , #採購單性質
    p_stdc          LIKE type_file.num5,  #是否需取得標準成本 #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,  #是否需取得異動原因 #No.FUN-690026 SMALLINT
    p_code          LIKE ze_file.ze03,    #No.FUN-690026 VARCHAR(04)
    p_item          LIKE imn_file.imn03,  #FUN-660078
    p_qty           LIKE tlf_file.tlf10	  #異動數量 #MOD-530179
 
#----來源----
#-----modify by may 1992/06/30
    LET g_tlf.tlf01=p_item      	 #異動料件編號
    LET g_tlf.tlf02=50         	 	 #資料來源為倉庫
    LET g_tlf.tlf020=g_plant         #工廠別
    LET g_tlf.tlf021=g_img.img02   	 #倉庫別
    LET g_tlf.tlf022=g_img.img03	 #儲位別
    LET g_tlf.tlf023=g_img.img04     #批號
    LET g_tlf.tlf024=g_img.img10 - p_qty  #異動後庫存數量
	LET g_tlf.tlf025=g_img.img09     #庫存單位img_file
	LET g_tlf.tlf026=g_imn.imn01     #調撥單號
	LET g_tlf.tlf027=g_imn.imn02     #調撥項次
#----目的---
    LET g_tlf.tlf03=56         	     #資料目的(兩階段調撥)
    LET g_tlf.tlf030=g_plant         #工廠別
    LET g_tlf.tlf031=' '          	 #倉庫別
    LET g_tlf.tlf032=' '          	 #儲位別
    LET g_tlf.tlf033=' '          	 #入庫批號
    LET g_tlf.tlf034=' '          	 #異動後庫存數量
    LET g_tlf.tlf035=' '          	 #庫存單位(ima_file or img_file)
    LET g_tlf.tlf036=' '             #
	LET g_tlf.tlf037=''              #
#--->異動數量
    LET g_tlf.tlf04=' '              #工作站
    LET g_tlf.tlf05=' '              #作業序號
    LET g_tlf.tlf06=g_imm.imm02      #調撥日期
	LET g_tlf.tlf07=g_today          #異動資料產生日期
	LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
	LET g_tlf.tlf09=g_user           #產生人
	LET g_tlf.tlf10=p_qty            #撥出數量
	LET g_tlf.tlf11=g_img.img09      #撥出單位(img_file)
    LET g_tlf.tlf12=g_imn.imn21
	LET g_tlf.tlf13='aimp400'        #異動命令代號
	LET g_tlf.tlf14=' '              #異動原因
	LET g_tlf.tlf15=' '              #借方會計科目
	LET g_tlf.tlf16=g_imn.imn07      #貸方會計科目
	LET g_tlf.tlf17=' '              #非庫存性料件編號
    CALL s_imaQOH(g_imn.imn03)
         RETURNING g_tlf.tlf18       #異動後總庫存量
	LET g_tlf.tlf19= ' '             #異動廠商/客戶編號
	LET g_tlf.tlf20= g_img.img35     #project no.
   #LET g_tlf.tlf61= g_ima86         #成本單位 #FUN-560183
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
#Patch....NO.TQC-610036 <001> #
