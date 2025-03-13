# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afaq100.4gl
# Descriptions...: 
# Date & Author..: 
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-510146 05/01/24 By Kitty 異動代號 "A","B" 簡稱未帶出
# Modify.........: No.MOD-530814 05/03/30 By Smapmin 不做UNIQUE的動作 
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6A0019 06/11/07 By Smapmin 以fap56取代fap22
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7C0089 07/12/17 By Smapmin 修改異動代號說明
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0024 09/10/13 By destiny display xxx.*改为display对应栏位
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.TQC-CB0033 11/04/07 By lujh 此作業查詢的是異動前的歷史資料查詢,請將畫面與程式中 fap56 改為 fap22
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE 
        g_ima RECORD  LIKE ima_file.*,
        g_argv1       LIKE type_file.chr20,           #No.FUN-680070 VARCHAR(15)
         g_sql         string,  #No.FUN-580092 HCN
        tm_wc 	      LIKE type_file.chr1000,		# Head Where condition       #No.FUN-680070 VARCHAR(1000)
        l_chr         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
        g_fap  RECORD
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
                        fap22  LIKE fap_file.fap22,    #MOD-6A0019  #TQC-CB0033  unmark 
                        #fap56  LIKE fap_file.fap56,   #MOD-6A0019  #TQC-CB0033  mark
                        fap23  LIKE fap_file.fap23,
                        fap07  LIKE fap_file.fap07,
                        fap17  LIKE fap_file.fap17,
                        fap18  LIKE fap_file.fap18,
                        fap12  LIKE fap_file.fap12,
                        fap121 LIKE fap_file.fap121,     #FUN-AB0088 by chenmoyan
                        fap13  LIKE fap_file.fap13,
#                       fap121 LIKE fap_file.fap121,     #No.FUN-680028 #FUN-AB0088 by chenmoyan
                        fap131 LIKE fap_file.fap131,     #No.FUN-680028
                        fap15  LIKE fap_file.fap15,
                        fap16  LIKE fap_file.fap16,
                        fap14  LIKE fap_file.fap14,
                        fap141 LIKE fap_file.fap141,     #No.FUN-680028
                        #-----No:FUN-AB0088-----
                        fap152  LIKE fap_file.fap152,
                        fap162  LIKE fap_file.fap162,
                        fap052  LIKE fap_file.fap052,
                        fap062  LIKE fap_file.fap062,
                        fap092  LIKE fap_file.fap092,
                       #fap102  LIKE fap_file.fap102,
                        fap103  LIKE fap_file.fap103,   #No:FUN-B30036
                        fap112  LIKE fap_file.fap112,
                        fap212  LIKE fap_file.fap212,
                        fap1012 LIKE fap_file.fap1012,
                        fap082  LIKE fap_file.fap082,
                        fap072  LIKE fap_file.fap072,
                        fap562  LIKE fap_file.fap562,
                        fap232  LIKE fap_file.fap232
                        #-----No:FUN-AB0088 END-----
        END RECORD,
    g_argv11   LIKE type_file.chr20           #No.FUN-680070 VARCHAR(15)
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
MAIN
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
   LET g_argv1 = ARG_VAL(1)
   CALL afaq100(g_argv1)
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
END MAIN
 
 
FUNCTION afaq100(p_argv1)
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0069
   DEFINE p_argv1       LIKE type_file.chr20            #No.FUN-680070 VARCHAR(15)
 
       LET g_argv11 =p_argv1    #序號參數
 
    OPEN WINDOW q100_w WITH FORM "afa/42f/afaq100" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    #No.FUN-680028 --begin
  # IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
       CALL cl_set_comp_visible("fap121,fap131,fap141,page03",TRUE)   #No:FUN-AB0088
    ELSE
       CALL cl_set_comp_visible("fap121,fap131,fap141,page03",FALSE)
    END IF
    #No.FUN-680028 --end
    #No:A099
    IF g_aza.aza26 = '2' THEN                                                   
       CALL q100_set_comments()
    END IF  
    #end No:A099
 
  {
    IF cl_chk_act_auth() THEN
       CALL q100_q()
    END IF
  }
  IF NOT cl_null(g_argv11) THEN 
      CALL q100_q() 
  END IF  
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q100_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q100_w
      #CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0069
      #   RETURNING l_time    #MOD-580222 mark
END FUNCTION 
 
#QBE 查詢資料
FUNCTION q100_cs()
   DEFINE   l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
	CLEAR FORM
	INITIALIZE g_fap.* TO NULL 
  IF  cl_null(g_argv11)  THEN  
   INITIALIZE g_fap.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm_wc ON fap02,fap021,fap01,fap03,fap50,
		 fap501,fap04,fap17,fap18,fap15,fap16,fap05,fap06,
                 fap20,fap09,fap10,fap11,fap21,fap22,fap23,fap101,    #MOD-6A0019   #TQC-CB0033 unmark
                 #fap20,fap09,fap10,fap11,fap21,fap56,fap23,fap101,   #MOD-6A0019   #TQC-CB0033 mark
                 fap08,fap07,
                 fap152,fap162,fap052,fap062,fap092,fap103,fap112,   #No:FUN-AB0088   #No:FUN-B30036
                 fap212,fap1012,fap082,fap072,fap562,fap232,         #No:FUN-AB0088
                 fap12,fap13,fap14,fap121,fap131,fap141     #No.FUN-680028
 
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
#   IF SQLCA.SQLCODE THEN CALL cl_err('construct',SQLCA.SQLCODE,1)
#                         RETURN      
#   END IF 
   IF INT_FLAG THEN RETURN END IF
      MESSAGE ' WAIT ' 
    LET g_sql=" SELECT fap02,fap03,fap04,fap021 FROM fap_file ",   
             " WHERE ",tm_wc CLIPPED 
   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q100_prepare
 
   # 取合乎條件筆數
    DISPLAY ' ' TO FORMONLY.cnt 
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
 #   LET g_sql=" SELECT COUNT(UNIQUE fap01) FROM fap_file ",  #MOD-530814
    LET g_sql=" SELECT COUNT(fap01) FROM fap_file ",  #MOD-530814
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
#            NEXT OPTION "next資料"
        ON ACTION next 
            CALL q100_fetch('N')
        ON ACTION previous 
            CALL q100_fetch('P')
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #No:A099
           IF g_aza.aza26 = '2' THEN                                                   
              CALL q100_set_comments()
           END IF  
           #end No:A099
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
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   '  TO FORMONLY.cnt
    CALL q100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN q100_cnt
    FETCH q100_cnt INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt 
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
          IF (NOT mi_no_ask) THEN
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
         LET mi_no_ask = FALSE
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
	    fap11, fap101, fap08, fap21, fap22, fap23,   #MOD-6A0019    #TQC-CB0033 ummark
	    #fap11, fap101, fap08, fap21, fap56, fap23,   #MOD-6A0019   #TQC-CB0033 mark
            fap07, fap17, fap18, fap12, fap121, fap13,     #No.FUN-680028
            fap131, fap15, fap16, fap14, fap141,     #No.FUN-680028
            fap152,fap162,fap052,fap062,fap092,fap103,fap112,   #No:FUN-AB0088   #No:FUN-B30036
            fap212,fap1012,fap082,fap072,fap562,fap232    #No:FUN-AB0088
       INTO g_fap.* FROM fap_file WHERE fap02 = g_fap.fap02 AND fap03 = g_fap.fap03 AND fap04 = g_fap.fap04 AND fap021 = g_fap.fap021 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fap.fap01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fap_file",g_fap.fap01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660136
        RETURN
    END IF
 
    CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
 DEFINE fap03_disp   LIKE type_file.chr20           #No.FUN-680070 VARCHAR(10)
 DEFINE fap06_disp   LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 DEFINE fap06_disp2  LIKE type_file.chr20    #No:FUN-AB0088
 DEFINE l_gem02      LIKE gem_file.gem02
 
    #No.FUN-9A0024--begin   
    DISPLAY BY NAME g_fap.*    #No:FUN-AB0088
 #   DISPLAY BY NAME g_fap.fap01,g_fap.fap02,g_fap.fap021,g_fap.fap03,g_fap.fap04,g_fap.fap50, #No:FUN-AB0088-MARK
 #                   g_fap.fap501,g_fap.fap05,g_fap.fap06,g_fap.fap20,g_fap.fap09,g_fap.fap10, #No:FUN-AB0088-MARK
 #                   g_fap.fap11,g_fap.fap101,g_fap.fap08,g_fap.fap21,g_fap.fap56,g_fap.fap23, #No:FUN-AB0088-MARK
 #                   g_fap.fap07,g_fap.fap17,g_fap.fap18,g_fap.fap12,g_fap.fap13,g_fap.fap121, #No:FUN-AB0088-MARK
 #                   g_fap.fap131,g_fap.fap15,g_fap.fap16,g_fap.fap14,g_fap.fap141
            #No.FUN-9A0024--end 
    CALL q100_fap03(g_fap.fap03) RETURNING fap03_disp
    CALL q100_fap06(g_fap.fap06) RETURNING fap06_disp
    CALL q100_fap06(g_fap.fap062) RETURNING fap06_disp2   #No:FUN-AB0088
    DISPLAY fap03_disp TO FORMONLY.fap03_disp 
    DISPLAY fap06_disp TO FORMONLY.fap06_disp
    DISPLAY fap06_disp2 TO FORMONLY.fap06_disp2   #No:FUN-AB0088 
    SELECT gem02 INTO l_gem02 FROM gem_file 
              WHERE gem01 = g_fap.fap17 AND gemacti = 'Y'
    DISPLAY l_gem02 TO FORMONLY.gem02
   #OPEN q100_cnt 
   #FETCH q100_cnt INTO g_cnt
   #DISPLAY g_cnt TO cnt
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
          #No.MOD-510146 add
         WHEN 'A' 
            CALL cl_getmsg('afa-023',g_lang) RETURNING l_bn
         WHEN 'B' 
            CALL cl_getmsg('afa-024',g_lang) RETURNING l_bn
          #No.MOD-510146 end
         #-----MOD-7C0089---------
         WHEN 'C' 
            CALL cl_getmsg('afa-059',g_lang) RETURNING l_bn
         WHEN 'D' 
            CALL cl_getmsg('afa-515',g_lang) RETURNING l_bn
         WHEN 'E' 
            CALL cl_getmsg('afa-052',g_lang) RETURNING l_bn
         WHEN 'E' 
            CALL cl_getmsg('afa-516',g_lang) RETURNING l_bn
         #-----END MOD-7C0089----- 
         OTHERWISE LET l_bn='' EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION q100_fap06(l_fap06)    #折舊方法
DEFINE
      l_fap06   LIKE fap_file.fap06,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
     #No:A099
     IF g_aza.aza26 = '2' THEN                                                  
        CASE l_fap06                                                            
            WHEN '0'                                                            
               CALL cl_getmsg('afa-008',g_lang) RETURNING l_bn                  
            WHEN '1'                                                            
               CALL cl_getmsg('afa-393',g_lang) RETURNING l_bn                  
            WHEN '2'                                                            
               CALL cl_getmsg('afa-394',g_lang) RETURNING l_bn                  
            WHEN '3'                                                            
               CALL cl_getmsg('afa-395',g_lang) RETURNING l_bn                  
            WHEN '4'                                                            
               CALL cl_getmsg('afa-396',g_lang) RETURNING l_bn                  
            WHEN '5'                                                            
               CALL cl_getmsg('afa-013',g_lang) RETURNING l_bn                  
            OTHERWISE EXIT CASE                                                 
        END CASE                                                                
     ELSE           
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
     END IF
     #end No:A099
     RETURN(l_bn)
END FUNCTION
 
#No:A099
FUNCTION q100_set_comments()                                                        
  DEFINE comm_value STRING                                                      
                                                                                
    CALL cl_getmsg('afa-391',g_lang) RETURNING comm_value
    CALL cl_set_comments('fap06',comm_value)
END FUNCTION
#end No:A099
 
