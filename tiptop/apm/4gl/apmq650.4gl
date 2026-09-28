# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apmq650.4gl
# Descriptions...: 預算耗用/可用餘額查詢
# Date & Author..: No.FUN-810069 08/03/05 By ChenMoyan 因項目預算的表發生重大改變故重寫
# Modify.........: No.FUN-830139 08/04/10 By bnlent s_budamt.4gl參數變更
# Modify.........: No.TQC-840049 08/04/20 By ChenMoyan 調整CONSTRUCT順序
# Modify.........: No.MOD-840181 08/04/20 By ChenMoyan 調整CONSTRUCT順序
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0126 09/10/26 By liuxqa 处理ROWID.
# Modify.........: No.TQC-9A0168 09/10/18 BY LIUXQA ORDER BY 修改。
# Modify.........: No.TQC-9C0105 09/12/14 By lilingyu 查詢時出現-324的錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"

  DEFINE g_argv1	LIKE afb_file.afb01     # 所要查詢的key
  DEFINE g_argv2	LIKE afb_file.afb02     # 所要查詢的key
  DEFINE g_argv3	LIKE afb_file.afb041    # 所要查詢的key
  DEFINE g_argv4	LIKE afb_file.afb03     # 所要查詢的key
  DEFINE g_argv5	LIKE afb_file.afb02    
  DEFINE g_argv6        LIKE afb_file.afb04
  DEFINE g_argv7        LIKE afb_file.afb042 
  DEFINE g_wc           string          	# WHERE CONDICTION  
  DEFINE g_sql		string  
  DEFINE g_cmd		LIKE type_file.chr1000 
  DEFINE g_afb 	RECORD
                afb00   LIKE afb_file.afb00,
                afb01   LIKE afb_file.afb01,
                azf03   LIKE azf_file.azf03,    #No.FUN-830139
                afb02   LIKE afb_file.afb02,
                aag02   LIKE aag_file.aag02,
                afb041  LIKE afb_file.afb041,
                gem02   LIKE gem_file.gem02,
                afb03   LIKE afb_file.afb03,
                afb04   LIKE afb_file.afb04,
                afb042  LIKE afb_file.afb042,
                afb10   LIKE afb_file.afb10,
                amt1    LIKE afc_file.afc06,   
                amt2    LIKE afc_file.afc06,   
                amt3    LIKE afc_file.afc06,   
                amt4    LIKE afc_file.afc06,   
                amt5    LIKE afc_file.afc06,   
                amt6    LIKE afc_file.afc06,   
                res_amt LIKE afc_file.afc06    
            	END RECORD
DEFINE g_order       LIKE type_file.num5      
DEFINE g_bookno1       LIKE aza_file.aza81     
DEFINE g_bookno2       LIKE aza_file.aza82     
DEFINE g_flag          LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_msg           LIKE ze_file.ze03     
DEFINE   g_row_count    LIKE type_file.num10  
DEFINE   g_curs_index   LIKE type_file.num10  
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
    LET g_argv5 = ARG_VAL(5)  
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW q650_w WITH FORM "apm/42f/apmq650"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q650_q() END IF
 
      LET g_action_choice=""
      CALL q650_menu()
 
    CLOSE WINDOW q650_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q650_cs()
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   IF NOT cl_null(g_argv1)
      THEN LET g_wc = "afb01 = '",g_argv1,"' AND ",
                      "afb02 = '",g_argv2,"' OR afb02 = '",g_argv5,"' AND ", 
                      "afb041 = '",g_argv3,"' AND ",
                      "afb03 = '",g_argv4,"'",
                      " AND afb04 = '",g_argv6,"'",
                      " AND afb04 = '",g_argv7,"'"
   ELSE CLEAR FORM #清除畫面
       CALL cl_opmsg('q')
   INITIALIZE g_afb.* TO NULL    
#      CONSTRUCT BY NAME g_wc ON afb00,afb01,afb02,afb041,afb03,afb04,afb042 # 螢幕上取單頭條件#No.TQC-840049
#      CONSTRUCT BY NAME g_wc ON afb00,afb03,afb041,afb01,afb02,afb042,afb04 #No.TQC-840049
       CONSTRUCT BY NAME g_wc ON afb00,afb03,afb01,afb02,afb041,afb042,afb04 #No.MOD-840181
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND afbuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND afbgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND afbgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
       #End:FUN-980030
 
   END IF
 #  LET g_sql=" SELECT afb00,afb01,'',afb02,'',afb041,'',afb03,afb04,afb042,afb10,0,0,0,0,0,0,0,afb01 ", #TQC-9C0105
    LET g_sql=" SELECT afb00,afb01,'',afb02,'',afb041,'',afb03,afb04,afb042,afb10,0,0,0,0,0,0,0 ", #TQC-9C0105
             " FROM afb_file ",
             " WHERE ",g_wc CLIPPED,
            #" ORDER BY sfb00,afb01,afb02 "     #TQC-9A0168 mod  #TQC-9C0105
             " ORDER BY afb00,afb01,afb02 "                      #TQC-9C0105
   PREPARE q650_prepare FROM g_sql
   DECLARE q650_cs SCROLL CURSOR FOR q650_prepare
 
   LET g_sql="SELECT COUNT(*) FROM afb_file WHERE ",g_wc CLIPPED
    PREPARE q650_precount FROM g_sql
    DECLARE q650_count CURSOR FOR q650_precount
END FUNCTION
 
FUNCTION q650_menu()
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
           CALL q650_q()
 
        ON ACTION qry_monthly_budget
           #No.FUN-830139  --Begin
           LET g_cmd = "apmq651 "," '",g_afb.afb00,"' ",
                                  " '",g_afb.afb01,"' ",
                                  " '",g_afb.afb02,"' ",
                                       g_afb.afb03,
                                  " '",g_afb.afb04,"' " CLIPPED,
                                  " '",g_afb.afb041,"' ",
                                  " '",g_afb.afb042,"' " CLIPPED
           #No.FUN-830139  --End   
           CALL cl_cmdrun(g_cmd)
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL q650_fetch('/')
 
        ON ACTION first
           CALL q650_fetch('F')
 
        ON ACTION last
           CALL q650_fetch('L')
 
        ON ACTION next
           CALL q650_fetch('N')
 
        ON ACTION previous
           CALL q650_fetch('P')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about        
           CALL cl_about()    
 
           LET g_action_choice = "exit"
        CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    ERROR ""
END FUNCTION
 
 
FUNCTION q650_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q650_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting!"
    OPEN q650_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('q650_q:',SQLCA.sqlcode,0)
    ELSE
       OPEN q650_count
       FETCH q650_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q650_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q650_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10,                #絕對的筆數  #No.FUN-680136 INTEGER
    l_afb01         LIKE afb_file.afb01
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q650_cs INTO g_afb.*    #   ,l_afb01   #TQC-9C0105
        WHEN 'P' FETCH PREVIOUS q650_cs INTO g_afb.*    #   ,l_afb01   #TQC-9C0105
        WHEN 'F' FETCH FIRST    q650_cs INTO g_afb.*    #   ,l_afb01   #TQC-9C0105
        WHEN 'L' FETCH LAST     q650_cs INTO g_afb.*    #   ,l_afb01   #TQC-9C0105
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q650_cs INTO g_afb.*  #   ,l_afb01   #TQC-9C0105
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err('Fetch:',SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL  #TQC-6B0105
#       INITIALIZE l_afb01 TO NULL  #TQC-6B0105     ##TQC-9C0105  mark
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL s_get_bookno(g_afb.afb03) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_afb.afb03,'aoo-081',1)
    END IF
    CALL q650_show()
 
END FUNCTION
 
FUNCTION q650_show()
DEFINE l_afc05 LIKE afc_file.afc05    #No.FUN-830139
#No.FUN-830139  --Begin
DEFINE l_flag          LIKE type_file.chr1
DEFINE l_flag1         LIKE type_file.chr1
DEFINE l_bookno1       LIKE aaa_file.aaa01
DEFINE l_bookno2       LIKE aaa_file.aaa01
#No.FUN-830139  --End  
    CALL cl_wait()
    #No.FUN-830139 ...begin
    #SELECT afa02 INTO g_afb.afa02 FROM afa_file
    #   WHERE afa01=g_afb.afb01
    #     AND afa00=g_aza.aza81 
    SELECT azf03 INTO g_afb.azf03 FROM azf_file
       WHERE azf01=g_afb.afb01
         AND azf02='2'
    IF STATUS THEN LET g_afb.azf03='' END IF
    #No.FUN-830139 ...end
 
    SELECT aag02 INTO g_afb.aag02 FROM aag_file
       WHERE aag01=g_afb.afb02
         AND aag00=g_bookno1  
    IF STATUS THEN LET g_afb.aag02='' END IF
 
    SELECT gem02 INTO g_afb.gem02 FROM gem_file
       WHERE gem01=g_afb.afb041
    IF STATUS THEN LET g_afb.gem02='' END IF
 
    #------------------------------------------ 已耗金額
    #No.FUN-830139 ...begin
    #CALL s_budamt(g_afb.afb041,g_afb.afb01,g_afb.afb02,g_afb.afb03,0)
    CALL s_get_bookno(g_afb.afb03) RETURNING l_flag,l_bookno1,l_bookno2
    IF l_bookno1 = g_afb.afb00 THEN
       LET l_flag1 = '0'
    ELSE
       LET l_flag1 = '1'
    END IF
    CALL s_budamt1(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,
                   g_afb.afb041,g_afb.afb042,0,l_flag1)
    #No.FUN-830139 ...end
         RETURNING g_afb.amt1, g_afb.amt2, g_afb.amt3,
                   g_afb.amt4, g_afb.amt5, g_afb.amt6
    LET g_afb.res_amt=g_afb.afb10-g_afb.amt1-g_afb.amt2-g_afb.amt3
                                 -g_afb.amt4-g_afb.amt5-g_afb.amt6
    #------------------------------------------
    DISPLAY BY NAME g_afb.*
    MESSAGE ''
    ERROR ""
    CALL cl_show_fld_cont()            
END FUNCTION
#No.FUN-810069
