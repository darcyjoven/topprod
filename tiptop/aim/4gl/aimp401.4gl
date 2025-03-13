# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp401 (aim.4gl)
# Descriptions...: 倉庫間調撥-撥入確認作業
# Date & Author..: 92/05/07 By Jones
# Modify ........: 92/06/09 By Lin 修改數量的更新
# Modify ........: 92/06/26 By MAY 修改數量的更新
# Modify ........: 93/07/31 By Apple
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 rowid
# Modify.........: No.TQC-930155 09/04/07 By dongbg 事務修改
# Modify.........: No.TQC-940045 09/04/15 By destiny 1.SQLCA.SQLERRD[3]始終為0,導致程序抓的筆數一直為0                              
#                                                    2.查詢的sql語句有錯誤，缺少and   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AB0058 10/11/08 By yinhy 审核段增加倉庫權限控管
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
# Modify.........: No.FUN-BB0084 11/12/07 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 抓ime_file資料添加imeacti='Y'條件
# Modify.........: No.TQC-DB0062 13/11/25 By wangrr "調撥單號""料號"欄位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_go            LIKE type_file.chr1,         #是否通過密碼檢查  #No.FUN-690026 VARCHAR(1)
    g_wc,g_sql      string,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_pass          LIKE imn_file.imn25,         #確認人員  #FUN-660078
    g_imn           RECORD LIKE imn_file.*,      #庫存調撥單單身檔
    g_pp            RECORD
                    dummy LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
                    pass  LIKE azb_file.azb02,
                    cdate LIKE type_file.dat     #No.FUN-690026 DATE
                    END RECORD,
    g_imm           RECORD LIKE imm_file.*,
    g_img           RECORD LIKE img_file.*,
    g_ima100        LIKE ima_file.ima100,        #在途量
    g_imn01         LIKE imn_file.imn01,         #調撥單號
    g_imn02         LIKE imn_file.imn02,         #項次
    g_imn23         LIKE imn_file.imn23          #實撥數量
 
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
 
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
 
    IF (NOT cl_user()) THEN EXIT PROGRAM  END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AIM")) THEN EXIT PROGRAM  END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
 
    IF g_sma.sma12 MATCHES '[nN]' THEN   #單倉
       CALL cl_err('',9037,2)
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
    OPEN WINDOW p401_w AT p_row,p_col
         WITH FORM "aim/42f/aimp401"
        #WITH FORM "/u2/usr/ching/gnr/9326/inf/42f/aimp401"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL p401_pass()
    IF g_go='N' THEN EXIT PROGRAM END IF
 
    CALL p401_q()
 
    WHILE TRUE
     LET g_action_choice = ""
     CALL p401_menu()
     IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW p401_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p401_cs()
    WHILE TRUE
     #將查詢條件輸入
      INITIALIZE g_imn01 TO NULL  #FUN-640213 add
      INITIALIZE g_imn02 TO NULL  #FUN-640213 add
      CONSTRUCT g_wc ON imm01,imn02,imn03
				   FROM imm01,imn02,imn03   # 螢幕上取單頭條件
                   HELP 1
      #TQC-DB0062--add--str--
      ON ACTION controlp
         CASE
            WHEN INFIELD(imm01)
               CALL cl_init_qry_var()
               LET g_qryparam.state  ='c'
               LET g_qryparam.form = "q_imm106"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imm01
               NEXT FIELD imm01
            WHEN INFIELD(imn03)
               CALL cl_init_qry_var()
               LET g_qryparam.state  ='c'
               LET g_qryparam.form = "q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imn03
               NEXT FIELD imn03
         END CASE
      #TQC-DB0062--add--end
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup') #FUN-980030
      #-----END TQC-860018----- 
     	IF INT_FLAG THEN EXIT WHILE END IF
 
      LET g_sql=" SELECT UNIQUE imn01,imn02 ",
	   		    " FROM imm_file,imn_file ",
                " WHERE imm01=imn01 AND ",
                " imn12 IN ('Y','y') ",
                " AND imn24 IN ('N','n') ",
                " AND imm10 = '2' AND ",
                 g_wc CLIPPED,
                " ORDER BY imn01,imn02"
 
      PREPARE p401_prepare FROM g_sql
       DECLARE p401_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR p401_prepare
 
      # 取合乎條件筆數
      #若使用組合鍵值, 則可以使用本方法去得到筆數值
      LET g_sql=" SELECT UNIQUE imn01,imn02 ",
	   		   " FROM imm_file,imn_file ",
               " WHERE imn01=imm01 AND ",
               " imn12 IN ('Y','y') ",
               " AND imn24 IN ('N','n') ",
              #" AND imm10 = '2' ",                          #No.TQC-940045 
               " AND imm10 = '2' AND  ",                     #No.TQC-940045
               g_wc CLIPPED,
               " ORDER BY imn01,imn02"
      PREPARE p401_pp  FROM g_sql
      DECLARE p401_cnt   CURSOR FOR p401_pp
	  EXIT WHILE
    END WHILE
END FUNCTION
 
#中文的MENU
FUNCTION p401_menu()
      MENU ""
 
        BEFORE MENU
           MESSAGE ''
           CALL ui.Interface.refresh()
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION Query
           LET g_action_choice="Query"
           IF cl_chk_act_auth() THEN
		CALL p401_q()
	   END IF
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
 
      ON ACTION first
         CALL p401_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION previous
         CALL p401_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION jump
         CALL p401_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION next
         CALL p401_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
 
      ON ACTION last
         CALL p401_fetch('L')
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
           CALL p401_con()
     END MENU
END FUNCTION
 
#確認動作
FUNCTION p401_con()
  DEFINE  l_number   LIKE imn_file.imn23,    #調撥數量-實際 #MOD-530179
          l_cdate    LIKE type_file.dat,     #確認日期  #No.FUN-690026 DATE
          l_cmd      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(200)
          l_str      LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(80)
          l_msg      LIKE type_file.chr1000,  #No.FUN-690026 VARCHAR(60)
          l_imn01    LIKE imn_file.imn01,   #No.FUN-AB0058 add
          l_imn04    LIKE imn_file.imn04,   #No.FUN-AB0058 add
          l_imm08    LIKE imm_file.imm08    #No.FUN-AB0058 add

#No.FUN-AB0058  --Begin  
    SELECT imn01,imn04,imm08 INTO l_imn01,l_imn04,l_imm08 
                             FROM imn_file,imm_file
                            WHERE imn01=g_imn01
                              AND imn02=g_imn02
                              AND imn01=imm01
                              AND imn12 IN ('Y','y')
                              AND imn24 IN ('N','n')
   IF status THEN RETURN END IF
WHILE TRUE
    IF NOT s_chk_ware(l_imn04) THEN RETURN END IF
    IF NOT s_chk_ware(l_imm08) THEN RETURN END IF
#No.FUN-AB0058  --End
    LET l_cdate = g_today
    INPUT l_number,l_cdate  WITHOUT DEFAULTS
                FROM number,cdate
 
        BEFORE FIELD number    #調撥數量-實際
			LET l_number = g_imn23
			DISPLAY l_number TO number
 
        AFTER FIELD number
	   IF l_number IS NULL OR l_number = ' ' THEN
	       LET l_number = g_imn23
	       DISPLAY l_number TO number
	   	NEXT FIELD number
	   END IF
           LET l_number = s_digqty(l_number,g_imn.imn20)    #FUN-BB0084
           DISPLAY l_number TO number                       #FUN-BB0084
           #----MODIFY 98/10/20 NO:2563---#
           IF l_number > g_imn.imn11 THEN
              NEXT FIELD number
           END IF
           #------------------------------#
 
        BEFORE FIELD cdate    #確認日期
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CALL cl_err('',9001,0)
       EXIT WHILE
    END IF
    BEGIN WORK
    IF cl_sure(0,0) THEN
       IF p401_cur() THEN
          CALL cl_err('',g_errno,1)
          EXIT WHILE
       END IF
       LET g_success = 'Y'
       #---->更新相關資料
       IF p401_update(l_number,l_cdate) THEN
          #CALL cl_err('','mfg0073',0)  #No.+052 010404 by plum
           LET g_msg='date: ',l_cdate,' number:',l_number
           CALL cl_err(g_msg,'9050',0)
       END IF
 
       IF g_success = 'Y' THEN
           CALL cl_cmmsg(1) COMMIT WORK
           DISPLAY 'Y' TO FORMONLY.x
       ELSE
           CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
 
       #---->則需再執行"倉庫間調撥-調撥調整作業
       IF l_number != g_imn.imn11 AND g_success ='Y' THEN
          CALL cl_getmsg('mfg3487',g_lang) RETURNING l_str
          IF cl_prompt(16,11,l_str) THEN
             LET l_cmd = "aimt310 '",g_imn01,"' '",
                          l_cdate,"' '",g_imn.imn03,"'",
                          " '",g_imn.imn04,"' '",g_imn.imn05,"' '",
                          g_imn.imn06,"'"," '",g_imn.imn20,"' ",
                          g_imn.imn11," ",l_number/g_imn.imn21,""
             #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
             CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
          END IF
       END IF
    END IF
	LET l_number = ' '
	LET l_cdate  = ' '
    EXIT WHILE
 END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION p401_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
	CALL cl_opmsg('q')
	MESSAGE ""
        CALL ui.Interface.refresh()
	CLEAR FORM
        INITIALIZE g_imm.* TO NULL
	DISPLAY '   ' TO FORMONLY.cnt
	CALL p401_cs()
	IF INT_FLAG THEN
	   LET INT_FLAG = 0
           CLEAR FORM
           INITIALIZE g_imm.* TO NULL
	   RETURN
	END IF
	OPEN p401_cs
	IF SQLCA.sqlcode THEN
		CALL cl_err('',SQLCA.sqlcode,0)
		RETURN
	END IF
	FOREACH p401_cnt INTO g_imn01,g_imn02
        #No.TQC-940045--begin                                                                                                       
           IF SQLCA.sqlcode != 0 THEN                                                                                               
              CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                               
              EXIT FOREACH                                                                                                          
           END IF                                                                                                                   
           LET g_row_count=g_row_count+1  
#	   LET g_row_count=SQLCA.SQLERRD[3]    #The numbers of row processed
#	   EXIT FOREACH
        #No.TQC-940045--end
	END FOREACH
#    OPEN p401_cnt                                  #No.TQC-940045
#    FETCH p401_cnt INTO g_row_count                #No.TQC-940045
    DISPLAY g_row_count TO FORMONLY.cnt
	CALL p401_fetch('F')					#讀出TEMP第一筆並顯示
END FUNCTION
 
#處理資料的讀取
FUNCTION p401_fetch(p_flag)
DEFINE
	p_flag	LIKE type_file.chr1,    #處理方式   #No.FUN-690026 VARCHAR(1)
	l_msg   LIKE type_file.chr1000, #顯示訊息   #No.FUN-690026 VARCHAR(50)
	l_abso	LIKE type_file.num10    #絕對的筆數 #No.FUN-690026 INTEGER
 
	CASE p_flag
		WHEN 'N' FETCH NEXT     p401_cs INTO g_imn01,g_imn02
		WHEN 'P' FETCH PREVIOUS p401_cs INTO g_imn01,g_imn02
		WHEN 'F' FETCH FIRST    p401_cs INTO g_imn01,g_imn02
		WHEN 'L' FETCH LAST     p401_cs INTO g_imn01,g_imn02
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
            FETCH ABSOLUTE g_jump p401_cs INTO g_imn01,g_imn02 --改g_jump
            LET mi_no_ask = FALSE
	END CASE
 
	IF SQLCA.sqlcode THEN
		LET l_msg = g_imn01,'+',g_imn02 clipped
		CALL cl_err(l_msg,SQLCA.sqlcode,0)
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
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
        CALL cl_navigator_setting(g_curs_index, g_row_count)
	LET g_imn23 = 0
	CALL p401_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p401_show()
 DEFINE l_imm    RECORD LIKE imm_file.*,#庫存調撥單單頭檔
	l_gen02  LIKE   gen_file.gen02, #員工姓名
	l_gen03  LIKE   gen_file.gen03, #所屬部門編號
	l_gem02  LIKE   gem_file.gem02, #部門名稱
	l_ima02  LIKE   ima_file.ima02, #品名規格
	l_ima05  LIKE   ima_file.ima05, #目前使用版本
	l_ima08  LIKE   ima_file.ima08  #來源碼
 
    #---->抓出員工姓名及部門編號
    SELECT imm_file.*,gen02,gen03
	   INTO g_imm.*,l_gen02,l_gen03
	   FROM  imm_file , OUTER gen_file
    	WHERE imm01 = g_imn01 AND imm_file.imm09 = gen_file.gen01
 
    #---->抓出部門名稱
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_gen03
 
    #---->抓出品名規格及版本及來源碼
    SELECT imn_file.*,ima02,ima05,ima08
	INTO g_imn.*,l_ima02,l_ima05,l_ima08
	FROM imn_file , OUTER ima_file
       WHERE imn01 = g_imn01
         AND imn02 = g_imn02
         AND imn_file.imn03 = ima_file.ima01
 
    DISPLAY l_gen02 TO gen02
    DISPLAY l_gen03 TO gen03
    DISPLAY l_gem02 TO gem02
    DISPLAY l_ima02 TO ima02
    DISPLAY l_ima05 TO ima05
    DISPLAY l_ima08 TO ima08
 
    DISPLAY BY NAME g_imm.imm02,g_imm.imm09,g_imm.imm07,g_imm.imm08
 
    DISPLAY BY NAME g_imm.imm01,g_imn.imn02,g_imn.imn03,g_imn.imn04,
			g_imn.imn05,g_imn.imn06,g_imn.imn07,
			g_imn.imn08,g_imn.imn09,g_imn.imn10,
			g_imn.imn11,g_imn.imn14,g_imn.imn15,g_imn.imn16,
			g_imn.imn17,g_imn.imn18,g_imn.imn19,
			g_imn.imn20,g_imn.imn21,g_imn.imn22
    DISPLAY 'N' TO FORMONLY.x
    LET g_imn23 = g_imn.imn11*g_imn.imn21
    LET g_imn23 = s_digqty(g_imn23,g_imn.imn20)  #FUN-BB0084
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#檢查密碼
FUNCTION p401_pass()
DEFINE
    l_azb02         LIKE azb_file.azb02,
    l_gen02         LIKE gen_file.gen02
 
    LET g_go='N'
    OPEN WINDOW cl_pass_w WITH FORM "aim/42f/aimp4011"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
     CALL cl_ui_locale("aimp4011")
 
    LET g_pp.pass=NULL
    LET g_cnt=1
	LET g_pp.cdate = g_today
    WHILE TRUE
        INPUT g_pass,g_pp.cdate,g_pp.pass WITHOUT DEFAULTS
            FROM u,cdate,pass
            AFTER FIELD u
                IF g_pass IS NULL THEN
                    NEXT FIELD u   #人員代號不可為空白
                END IF
                SELECT azb02
                    INTO l_azb02   #密碼
                    FROM azb_file
                    WHERE azb01=g_pass
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_pass,'aoo-001',0)  #No.FUN-660156 MARK
                    CALL cl_err3("sel","azb_file",g_pass,"","aoo-001","","",0)  #No.FUN-660156
                    NEXT FIELD u
                END IF
				SELECT gen02 INTO l_gen02 FROM gen_file
							 WHERE gen01 = g_pass   #抓出人員姓名
                DISPLAY l_gen02 TO gen02
            AFTER FIELD cdate
                IF g_pp.cdate IS NULL OR g_pp.cdate = ' '
                THEN NEXT FIELD cdate
                END IF
                IF l_azb02 IS NULL OR l_azb02=' ' THEN   #沒有設定密碼
                     LET g_go='Y'
                     EXIT INPUT
                END IF
            BEFORE FIELD pass     #密碼
                CALL cl_getmsg('aoo-002',g_lang) RETURNING g_msg
               #DISPLAY g_msg AT 1,8   #CHI-A70049 mark
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
 
FUNCTION p401_cur()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
 
   #---->先鎖住庫存明細檔並且讀取相關資料
    LET g_sql=
        "SELECT ' ',img_file.* ",
        "  FROM img_file  ",
        " WHERE img01='",g_imn.imn03,"'"
 
    #撥入倉庫
    IF g_imn.imn15 IS NOT NULL THEN
        LET g_sql=g_sql CLIPPED," AND img02='", g_imn.imn15,"'"
    ELSE
        LET g_sql=g_sql CLIPPED," AND img02 IS NULL"
    END IF
    #撥入儲位
    IF g_imn.imn16 IS NOT NULL THEN
        LET g_sql=g_sql CLIPPED," AND img03='", g_imn.imn16,"'"
    ELSE
        LET g_sql=g_sql CLIPPED," AND img03 IS NULL"
    END IF
    #撥入批號
    IF g_imn.imn17 IS NOT NULL THEN
        LET g_sql=g_sql CLIPPED," AND img04='", g_imn.imn17,"'"
    ELSE
        LET g_sql=g_sql CLIPPED," AND img04 IS NULL"
    END IF
    LET g_sql=g_sql CLIPPED," FOR UPDATE"
    LET g_sql=cl_forupd_sql(g_sql) 

    PREPARE img_p FROM g_sql
    DECLARE img_lock CURSOR FOR img_p
    OPEN img_lock
     IF STATUS THEN 
         CALL cl_err('OPEN img_lock',STATUS,1) 
         RETURN 1
     END IF
       #TQC-930155 begin
       IF SQLCA.sqlcode THEN
           IF SQLCA.sqlcode=-246 OR status=-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno ='aoo-060'
               RETURN 1
           ELSE
               LET g_img.img10= 0
               SELECT ime05,ime06,ime10,ime11
                 INTO g_img.img23,g_img.img24,g_img.img27,g_img.img28
                 FROM ime_file
                WHERE ime01=g_imn.imn15
                  AND ime02=g_imn.imn16
		 AND imeacti='Y'  #FUN-D40103 add
               IF SQLCA.sqlcode THEN
                  LET g_img.img23 = 'Y'
                  LET g_img.img24 = 'Y'
               END IF
           END IF
       END IF
       #TQC-930155 end
    FETCH img_lock
        INTO g_img.*
       IF SQLCA.sqlcode THEN
           IF SQLCA.sqlcode=-246 OR status=-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno ='aoo-060'
               RETURN 1
           ELSE
               LET g_img.img10= 0
               SELECT ime05,ime06,ime10,ime11
                 INTO g_img.img23,g_img.img24,g_img.img27,g_img.img28
                 FROM ime_file
                WHERE ime01=g_imn.imn15
                  AND ime02=g_imn.imn16
		AND imeacti='Y'  #FUN-D40103 add
               IF SQLCA.sqlcode THEN
                  LET g_img.img23 = 'Y'
                  LET g_img.img24 = 'Y'
               END IF
           END IF
       END IF
 
    #---->鎖位料件主檔並讀取料件資料
    LET l_sql=
        "SELECT ima100 ", #FUN-560183 拿掉ima86
        "  FROM ima_file  ",
        " WHERE  ima01= '",g_imn.imn03,"'",
        "   FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE ima_p FROM l_sql
    DECLARE ima_lock CURSOR FOR ima_p
    OPEN ima_lock
    IF SQLCA.sqlcode THEN RETURN 1 END IF
    FETCH ima_lock
     #  INTO g_ima100,g_ima86,g_ima100        #NO:2561
        INTO g_ima100  #,g_ima86 #FUN-560183
  RETURN 0
END FUNCTION
 
FUNCTION p401_update(p_number,p_cdate)
  DEFINE p_number   LIKE imn_file.imn23,   #調撥數量-實際 #MOD-530179
         p_cdate    LIKE type_file.dat,    #確認日期  #No.FUN-690026 DATE
#        l_qty      LIKE ima_file.ima262   #數量      #No.FUN-A20044
         l_qty      LIKE type_file.num15_3            #No.FUN-A20044
 
       IF g_img.img21 IS NULL THEN LET g_img.img21 = 1 END IF
       LET l_qty = p_number * g_img.img21
       IF l_qty IS NULL THEN LET g_success = 'N' RETURN 1 END IF
 
#---->更新庫存明細資料檔(撥入倉庫)
#                  1            2  3       4
#     CALL s_upimg(+1,p_number,g_imm.imm02,  #FUN-8C0084
      CALL s_upimg(g_imn.imn03,g_imn.imn15,g_imn.imn16,g_imn.imn17,+1,p_number,g_imm.imm02, #FUN-8C0084
#       5           6           7           8           9
        g_imn.imn03,g_imn.imn15,g_imn.imn16,g_imn.imn17,g_imn.imn01,
#       10          11          12       13
        g_imn.imn02,g_imn.imn20,p_number,g_imn.imn20,
#       14  15          16          17          18
        1,  g_img.img21,g_img.img34,g_imn.imn18,g_imn.imn19,
#       19          20          21           22
        g_img.img27,g_img.img28,g_imn.imn091,g_imn.imn092)
 
        IF g_success = 'N' THEN RETURN 1 END IF
 
#---->更新料件主檔
     IF s_udima(g_imn.imn03,g_img.img23,g_img.img24,l_qty,p_cdate,+1)
       THEN RETURN 1
     END IF
 
#---->更新[調撥單單身檔] {ckp#1}
     UPDATE imn_file SET imn23 = p_number,     #累計實撥數量
                         imn24 = 'Y',          #確認碼
                         imn25 = g_pass,       #確認人
                         imn26 = p_cdate       #確認日期
              WHERE imn01 = g_imn01
                AND imn02 = g_imn02
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err3("upd","imn_file",g_imn01,g_imn02,SQLCA.sqlcode,"","(p410_update:ckp#1)",1)   #NO.FUN-640266 #No.FUN-660156
        RETURN 1
     END IF
 
     CALL p401_log(1,0,'',p_number)
     IF g_success = 'N' THEN RETURN 1 END IF
     RETURN 0
END FUNCTION
 
#處理異動記錄
FUNCTION p401_log(p_stdc,p_reason,p_code,p_number)
DEFINE
    p_number        LIKE imn_file.imn23,    #實際撥入數量
    p_stdc          LIKE type_file.num5,    #是否需取得標準成本 #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,    #是否需取得異動原因 #No.FUN-690026 SMALLINT
    p_code          LIKE ze_file.ze03       #No.FUN-690026 VARCHAR(04)
 
#----來源----
    LET g_tlf.tlf01=g_imn.imn03      	 #異動料件編號
    LET g_tlf.tlf02=56           	 	 #資料來源為倉庫
    LET g_tlf.tlf020=' '                 #工廠別
    LET g_tlf.tlf021=' '             	 #倉庫別
    LET g_tlf.tlf022=' '            	 #儲位別
    LET g_tlf.tlf023=' '        	     #批號
    LET g_tlf.tlf024=' '                 #異動後庫存數量
    LET g_tlf.tlf025=' '                 #庫存單位
    LET g_tlf.tlf026=' '                 #單據編號
    LET g_tlf.tlf027=' '                 #項次
#----目的----
    LET g_tlf.tlf03=50         	
    LET g_tlf.tlf030=g_plant             #工廠別
    LET g_tlf.tlf031=g_imn.imn15       	 #倉庫別
    LET g_tlf.tlf032=g_imn.imn16       	 #儲位別
    LET g_tlf.tlf033=g_imn.imn17       	 #入庫批號
    LET g_tlf.tlf034=g_img.img10 + p_number  #異動後庫存數量
    LET g_tlf.tlf035=g_imn.imn20  	     #庫存單位
	LET g_tlf.tlf036=g_imn.imn01         #調撥單號
	LET g_tlf.tlf037=g_imn.imn02         #調撥項次
#--->異動數量
    LET g_tlf.tlf04=' '                  #工作站
    LET g_tlf.tlf05=' '                  #作業序號
    LET g_tlf.tlf06=g_imm.imm02          #異動日期
	LET g_tlf.tlf07=g_today              #異動資料產生日期
	LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
	LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=p_number             #異動數量
	LET g_tlf.tlf11=g_imn.imn20          #異動數量單位
	LET g_tlf.tlf12=1
	LET g_tlf.tlf13='aimp401'            #異動命令代號
	LET g_tlf.tlf14=' '                  #異動原因
	LET g_tlf.tlf15=g_imn.imn18          #借方會計科目
	LET g_tlf.tlf16=' '                  #貸方會計科目
	LET g_tlf.tlf17=' '                  #非庫存性料件編號
    CALL s_imaQOH(g_imn.imn03)
         RETURNING g_tlf.tlf18           #異動後總庫存量
	LET g_tlf.tlf19= ' '                 #異動廠商/客戶編號
	LET g_tlf.tlf20= g_imn.imn19         #project no.
   #LET g_tlf.tlf61= g_ima86             #成本單位 #FUN-560183
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
 
 
#Patch....NO.TQC-610036 <001> #
