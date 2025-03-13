# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afaq100.4gl
# Descriptions...: 固定資產歷史記錄查詢
# Date & Author..: 96/06/11 by Lynn  
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm_wc       LIKE type_file.chr1000,		# Head Where condition       #No.FUN-680070 VARCHAR(300)
      l_chr       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
      g_fap       RECORD
			fap01  LIKE fap_file.fap01,
			fap02  LIKE fap_file.fap02,
			fap021 LIKE fap_file.fap021,
			fap03  LIKE fap_file.fap03,
			fap04  LIKE fap_file.fap04,
			fap50  LIKE fap_file.fap50,
			fap501 LIKE fap_file.fap501,
                        fap05  LIKE fap_file.fap05,
                        fap06  LIKE fap_file.fap06,
                        fap20  LIKE fap_file.fap20,
                        fap09  LIKE fap_file.fap09,
                        fap10  LIKE fap_file.fap10,
                        fap11  LIKE fap_file.fap11,
                        fap101 LIKE fap_file.fap101,
                        fap08  LIKE fap_file.fap08,
                        fap21  LIKE fap_file.fap21,
                        fap22  LIKE fap_file.fap22,
                        fap23  LIKE fap_file.fap23,
                        fap07  LIKE fap_file.fap07,
                        fap17  LIKE fap_file.fap17,
                        fap18  LIKE fap_file.fap18,
                        fap12  LIKE fap_file.fap12,
                        fap13  LIKE fap_file.fap13,
                        fap15  LIKE fap_file.fap15,
                        fap16  LIKE fap_file.fap16,
                        fap14  LIKE fap_file.fap14
             END RECORD,
          g_sql   string,  #No.FUN-580092 HCN
      g_argv11   LIKE faq_file.faq01       #No.FUN-680070 VARCHAR(15)
 
DEFINE g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
FUNCTION afaq100(p_argv1)
   DEFINE p_argv1     LIKE faq_file.faq01        #No.FUN-680070 VARCHAR(15)

   WHENEVER ERROR CONTINUE 
 
    LET g_argv11 =p_argv1    #序號參數
 
    IF NOT afa_stup("afaq100") THEN        #啟動程式: 預設必要值及檢查權限
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
       EXIT PROGRAM
    END IF

    OPEN WINDOW q100_w WITH FORM "afa/42f/afaq100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afaq100")
 
    CALL cl_shwtit(3,70,'afaq100')

  IF NOT cl_null(g_argv11) THEN 
      CALL q100_q() 
  END IF  
 
      LET g_action_choice=""
    CALL q100_menu()
 
    CLOSE WINDOW q100_w
END FUNCTION 
 
#QBE 查詢資料
FUNCTION q100_cs()
   DEFINE   l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
	CLEAR FORM
	INITIALIZE g_fap.* TO NULL 
  IF  cl_null(g_argv11)  THEN  
   INITIALIZE g_fap.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm_wc ON fap01,fap02,fap021,fap03,fap04,fap50,
		 fap501,fap05,fap06,fap20,fap09,fap10,
		 fap11,fap101,fap08,fap21,fap22,fap23,
                 fap07,fap17,fap18,fap12,fap13,fap15,fap16,fap14
 
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
      LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
  ELSE  
     LET tm_wc="fap01='",g_argv11,"'"
  END IF 
   IF SQLCA.SQLCODE THEN CALL cl_err('construct',SQLCA.SQLCODE,1)
                         RETURN      
   END IF 
   IF INT_FLAG THEN RETURN END IF
      MESSAGE ' WAIT ' 
    LET g_sql=" SELECT fap02,fap03,fap04,fap021 FROM fap_file ",
             " WHERE ",tm_wc CLIPPED 
   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q100_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(*) FROM fap_file ",
              " WHERE ",tm_wc CLIPPED
   PREPARE q100_pp  FROM g_sql
   DECLARE q100_cnt   CURSOR FOR q100_pp
END FUNCTION
 
#中文的MENU
FUNCTION q100_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q100_q()
            END IF
            NEXT OPTION "next資料"
        ON ACTION next 
            CALL q100_fetch('N')
        ON ACTION previous 
            CALL q100_fetch('P')
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL q100_fetch('/')
        ON ACTION first
            CALL q100_fetch('F')
        ON ACTION last
            CALL q100_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
FUNCTION q100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   '  TO FORMONLY.cnt
    CALL q100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN q100_cnt
    FETCH q100_cnt INTO g_row_count
    DISPLAY  g_row_count TO FORMONLY.cnt  
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q100_cs INTO g_fap.fap02, g_fap.fap03, g_fap.fap04, g_fap.fap021
       WHEN 'P' FETCH PREVIOUS q100_cs INTO g_fap.fap02, g_fap.fap03, g_fap.fap04, g_fap.fap021
       WHEN 'F' FETCH FIRST    q100_cs INTO g_fap.fap02, g_fap.fap03, g_fap.fap04, g_fap.fap021
       WHEN 'L' FETCH LAST     q100_cs INTO g_fap.fap02, g_fap.fap03, g_fap.fap04, g_fap.fap021
       WHEN '/'
          IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
#                    CONTINUE PROMPT
 
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
         FETCH ABSOLUTE g_jump q100_cs INTO g_fap.fap02, g_fap.fap03, g_fap.fap04, g_fap.fap021
         LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fap.fap01,SQLCA.sqlcode,0)
        INITIALIZE g_fap.* TO NULL  #TQC-6B0105
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
    SELECT  fap01, fap02, fap021, fap03, fap04, fap50,
	    fap501, fap05, fap06, fap20, fap09, fap10,
	    fap11, fap101, fap08, fap21, fap22, fap23,
            fap07, fap17, fap18, fap12, fap13, fap15,fap16,fap14
       INTO g_fap.* FROM fap_file WHERE fap02 = g_fap.fap02 AND fap03 = g_fap.fap03 AND fap04 = g_fap.fap04 AND fap021 = g_fap.fap021 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fap.fap01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fap_file",g_fap.fap01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660136
        RETURN
    END IF
 
    CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
 DEFINE fap03_disp   LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
 DEFINE fap06_disp   LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 DEFINE l_gem02      LIKE gem_file.gem02
 
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_fap.*  
   DISPLAY BY NAME g_fap.fap01,g_fap.fap02,g_fap.fap021,g_fap.fap03,g_fap.fap04,g_fap.fap50,
                   g_fap.fap501,g_fap.fap05,g_fap.fap06,g_fap.fap20,g_fap.fap09,g_fap.fap10,
                   g_fap.fap11,g_fap.fap101,g_fap.fap08,g_fap.fap21,g_fap.fap22,g_fap.fap23,
                   g_fap.fap07,g_fap.fap17,g_fap.fap18,g_fap.fap12,g_fap.fap13,g_fap.fap15,
                   g_fap.fap16,g_fap.fap14
   #No.FUN-9A0024--end     
    CALL q100_fap03(g_fap.fap03) RETURNING fap03_disp
    CALL q100_fap06(g_fap.fap06) RETURNING fap06_disp
    DISPLAY fap03_disp TO FORMONLY.fap03_disp 
    DISPLAY fap06_disp TO FORMONLY.fap06_disp 
    SELECT gem02 INTO l_gem02 FROM gem_file 
              WHERE gem01 = g_fap.fap17 AND gemacti = 'Y'
    DISPLAY l_gem02 TO FORMONLY.gem02 
   OPEN q100_cnt 
   FETCH q100_cnt INTO g_cnt
   DISPLAY g_cnt TO cnt
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q100_fap03(l_fap03)   #資產異動說明
DEFINE
      l_fap03   LIKE fap_file.fap03,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
     CASE l_fap03
         WHEN '0'
            CALL cl_getmsg('afa-114',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-014',g_lang) RETURNING l_bn
         WHEN '2' 
            CALL cl_getmsg('afa-015',g_lang) RETURNING l_bn
         WHEN '3' 
            CALL cl_getmsg('afa-016',g_lang) RETURNING l_bn
         WHEN '4' 
            CALL cl_getmsg('afa-017',g_lang) RETURNING l_bn
         WHEN '5' 
            CALL cl_getmsg('afa-018',g_lang) RETURNING l_bn
         WHEN '6' 
            CALL cl_getmsg('afa-019',g_lang) RETURNING l_bn
         WHEN '7' 
            CALL cl_getmsg('afa-020',g_lang) RETURNING l_bn
         WHEN '8' 
            CALL cl_getmsg('afa-021',g_lang) RETURNING l_bn
         WHEN '9' 
            CALL cl_getmsg('afa-022',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION q100_fap06(l_fap06)    #折舊方法
DEFINE
      l_fap06   LIKE fap_file.fap06,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
     CASE l_fap06
         WHEN '0'
            CALL cl_getmsg('afa-008',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-009',g_lang) RETURNING l_bn
         WHEN '2' 
            CALL cl_getmsg('afa-010',g_lang) RETURNING l_bn
         WHEN '3' 
            CALL cl_getmsg('afa-011',g_lang) RETURNING l_bn
         WHEN '4' 
            CALL cl_getmsg('afa-012',g_lang) RETURNING l_bn
         WHEN '5' 
            CALL cl_getmsg('afa-013',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
