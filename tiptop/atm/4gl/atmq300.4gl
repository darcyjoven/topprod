# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: amtq300.4gl
# Descriptions...: 客戶商品ＢＩＮ卡查詢
# Date & Author..: 2006/03/23 By Sarah
# Modify.........: No.FUN-630027 06/03/23 By Sarah 新增"客戶商品ＢＩＮ卡查詢"
# Modify.........: No.TQC-660050 06/06/12 By Sarah q300_fetch()計算期末庫存WHERE條件少了tuq12,計算期末數量WHERE條件少了tur11,tur12
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7C0047 07/12/06 By xufeng 相同的客戶編號,起始供需日期經兩次以上查詢后,單頭期初庫存和單身的異動后庫存就會錯誤，會累加
# Modify.........: No.MOD-910224 09/01/21 By sherry 單身"異動后庫存"計算有問題,如是'2.客戶銷退',異動后庫存應為期初-異動量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9B0173 09/11/25 By lilingyu MARK MOD-910224逻辑段
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm         RECORD
                   wc    	STRING,                 # Head Where condition
                   wc1  	STRING,                 # Body Where condition
                   wc2  	STRING                  # Body Where condition
                  END RECORD,
       g_tup      RECORD
                   tup11	LIKE tup_file.tup11,    # 庫存類型
                   tup01	LIKE tup_file.tup01,    # 料件編號
                   tup12	LIKE tup_file.tup12,    # 送貨客戶
                   tup02	LIKE tup_file.tup02,    # 倉庫編號
                   tup03	LIKE tup_file.tup03,    # 存放位置
                   tup05	LIKE tup_file.tup05,    # 批號
                   tup04	LIKE tup_file.tup04     # 批號
                  END RECORD,
       g_bdate    LIKE type_file.dat,              #No.FUN-680120 DATE
       g_tur09    LIKE tur_file.tur09, # 期初庫存
       g_occ02    LIKE occ_file.occ02, # 客戶名稱  
       g_occ02_2  LIKE occ_file.occ02, # 送貨客戶名稱 
       g_ima02    LIKE ima_file.ima02, # 品名    
       g_year     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       g_month    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       g_flag     LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
       g_tuq      DYNAMIC ARRAY OF RECORD
                   tuq04   LIKE tuq_file.tuq04,  #異動數量
                   tuq10   LIKE tuq_file.tuq10,  #異動數量
                   desc    LIKE tuq_file.tuq01,  #No.FUN-680120 VARCHAR(10) 	
                   tuq05   LIKE tuq_file.tuq05,  #異動數量
                   tuq09   LIKE tuq_file.tuq09,  #異動數量
                   tot     LIKE tuq_file.tuq09   #MOD-4B0067
                  END RECORD,
       g_argv1    LIKE type_file.chr1,            #No.FUN-680120 VARCHAR(1)
       g_base     LIKE tuq_file.tuq09,  #MOD-4B0067
       g_query_flag    LIKE type_file.num5,       #No.FUN-680120 SMALLINT #第一次進入程式時即進入Query之後進入N.下筆
       g_sql           STRING,  #No.FUN-580092 HCN
       i               LIKE type_file.num10,      #No.FUN-680120 INEGER
       g_rec_b         LIKE type_file.num5        #單身筆數        #No.FUN-680120 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680120 SMALLINT
DEFINE g_cnt           LIKE type_file.num10       #No.FUN-680120 INTEGER
DEFINE g_msg           LIKE type_file.chr1000     #No.FUN-680120 VARCHAR(72)
DEFINE l_ac            LIKE type_file.num5        #No.FUN-680120 SMALLINT
DEFINE g_row_count     LIKE type_file.num10       #No.FUN-680120 INTEGER
DEFINE g_curs_index    LIKE type_file.num10       #No.FUN-680120 INTEGER
DEFINE g_jump          LIKE type_file.num10       #No.FUN-680120 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5        #No.FUN-680120 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6B0014
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   CASE g_argv1
      WHEN "1" LET g_prog = 'atmq300'
      WHEN "2" LET g_prog = 'atmq310'
      OTHERWISE 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
 
   LET g_bdate=g_today
   LET g_query_flag=1
   LET p_row = 3 LET p_col = 6
 
   OPEN WINDOW q300_w AT p_row,p_col
        WITH FORM "atm/42f/atmq300"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
   CALL q300_menu()    #中文
   CLOSE WINDOW q300_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION q300_cs()
   DEFINE lc_qbe_sn  LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cnt      LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
   CLEAR FORM
   CALL g_tuq.clear() 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		
   DISPLAY g_bdate TO bdate
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   INITIALIZE g_tup.* TO NULL    #No.FUN-750051
   INITIALIZE g_tur09 TO NULL    #No.TQC-7C0047 
   CONSTRUCT BY NAME tm.wc ON tup01,tup12,tup02,tup03
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds                                            
         CALL cl_on_idle()                                              
         CONTINUE CONSTRUCT                                             
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      #No.FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
                                                                                
   END CONSTRUCT 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   INPUT g_bdate WITHOUT DEFAULTS FROM bdate
 
      BEFORE INPUT             
         CALL cl_qbe_display_condition(lc_qbe_sn)   
 
      AFTER FIELD bdate
         IF cl_null(g_bdate) THEN
            CALL cl_err('','aim-372',0)
            NEXT FIELD bdate
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            RETURN       
         END IF
         IF cl_null(g_bdate) THEN
            CALL cl_err('','aim-372',0)
            NEXT FIELD bdate
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
 
      #No.FUN-580031 --start--         
      ON ACTION qbe_save            
          CALL cl_qbe_save()         
      #No.FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    LET tm.wc2 = "tuq04 >= '",g_bdate,"'"
    LET g_sql="SELECT UNIQUE tup01,tup02,tup03,tup05,tup04,tup11,tup12",
              "  FROM tup_file,tuq_file",
              " WHERE tup01 = tuq01 ",
              "   AND tup02 = tuq02 ",
              "   AND tup03 = tuq03 ",
              "   AND tup11 = tuq11 ",
              "   AND tup12 = tuq12 ",
              "   AND ",tm.wc  CLIPPED,
              "   AND ",tm.wc2 CLIPPED
    CASE g_argv1
       WHEN "1" LET g_sql = g_sql," AND tup11 ='1' "
       WHEN "2" LET g_sql = g_sql," AND tup11 ='2' "
    END CASE
    LET g_sql = g_sql CLIPPED," ORDER BY tup01,tup02,tup03,tup11,tup12"
    PREPARE q300_prepare FROM g_sql
    DECLARE q300_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q300_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql="SELECT UNIQUE tup01,tup02,tup03,tup11,tup12",
              "  FROM tup_file,tuq_file ",
              " WHERE tup01 = tuq01 ",
              "   AND tup02 = tuq02 ",
              "   AND tup03 = tuq03 ",
              "   AND tup11 = tuq11 ",
              "   AND tup12 = tuq12 ",
              "   AND ",tm.wc  CLIPPED ,
              "   AND ",tm.wc2 CLIPPED
    CASE g_argv1
       WHEN "1" LET g_sql = g_sql," AND tup11 ='1' "
       WHEN "2" LET g_sql = g_sql," AND tup11 ='2' "
    END CASE
    LET g_sql = g_sql CLIPPED," INTO TEMP x "
    DROP TABLE x
    PREPARE q300_precount_x FROM g_sql
    EXECUTE q300_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE q300_precount FROM g_sql
    DECLARE q300_cnt CURSOR FOR q300_precount
    OPEN q300_cnt                                                            
    FETCH q300_cnt INTO g_row_count                                           
    CLOSE q300_cnt
END FUNCTION
 
FUNCTION q300_b_askkey()
 
   CONSTRUCT tm.wc2 ON tuq04,tuq10,tuq05,tuq09 
        FROM s_tuq[1].tuq04,s_tuq[1].tuq10,s_tuq[1].tuq05,s_tuq[1].tuq09
 
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
 
END FUNCTION
 
FUNCTION q300_menu()
 
    WHILE TRUE
      CALL q300_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q300_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q300_q()
 
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""      
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q300_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q300_cnt
    FETCH q300_cnt INTO g_row_count
    DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
    OPEN q300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       CALL q300_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
 
END FUNCTION
 
FUNCTION q300_fetch(p_flag)
DEFINE
    l_year 	    LIKE tur_file.tur04, # 年度    
    l_month	    LIKE tur_file.tur05, # 期別    
     #No.MOD-570124  --begin                                                     
    l_date          LIKE type_file.dat,              #No.FUN-680120 DATE                                              
    l_date1         LIKE type_file.dat,              #No.FUN-680120 DATE                                              
    l_tuq09         LIKE tuq_file.tuq09,                                        
    l_tuq091        LIKE tuq_file.tuq09,                                        
    l_tuq092        LIKE tuq_file.tuq09,                                        
    l_tuq093        LIKE tuq_file.tuq09,                                        
     #No.MOD-570124  --end 
    p_flag          LIKE type_file.chr1              #處理方式        #No.FUN-680120 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q300_cs INTO g_tup.tup01,g_tup.tup02,g_tup.tup03,
                                             g_tup.tup05,g_tup.tup04,
                                             g_tup.tup11,g_tup.tup12
        WHEN 'P' FETCH PREVIOUS q300_cs INTO g_tup.tup01,g_tup.tup02,g_tup.tup03,
                                             g_tup.tup05,g_tup.tup04,
                                             g_tup.tup11,g_tup.tup12
        WHEN 'F' FETCH FIRST    q300_cs INTO g_tup.tup01,g_tup.tup02,g_tup.tup03,
                                             g_tup.tup05,g_tup.tup04,
                                             g_tup.tup11,g_tup.tup12
        WHEN 'L' FETCH LAST     q300_cs INTO g_tup.tup01,g_tup.tup02,g_tup.tup03,
                                             g_tup.tup05,g_tup.tup04,
                                             g_tup.tup11,g_tup.tup12
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
          FETCH ABSOLUTE g_jump q300_cs INTO g_tup.tup01,g_tup.tup02,g_tup.tup03,
                                             g_tup.tup05,g_tup.tup04,
                                             g_tup.tup11,g_tup.tup12
          LET mi_no_ask = FALSE
    END CASE
 
    CALL s_yp(g_bdate) RETURNING l_year, l_month
    LET l_date=MDY(l_month,1,l_year)  #No.MOD-570124
    LET l_month = l_month - 1
    IF l_month = 0 THEN
       LET l_month = 12
       LET l_year = l_year - 1
    END IF
 
    LET g_sql = "SELECT tur09 FROM tur_file ",
                " WHERE tur01 = '",g_tup.tup01,"'",
                "   AND tur02 = '",g_tup.tup02,"'",
                "   AND tur03 = '",g_tup.tup03,"'",
                "   AND tur04 = '",l_year,"'",
                "   AND tur05 = '",l_month,"'",
                "   AND tur11 = '",g_tup.tup11,"'",   #TQC-660050 add 
                "   AND tur12 = '",g_tup.tup12,"'"    #TQC-660050 add
    CASE g_argv1
       WHEN "1" LET g_sql = g_sql," AND tur11 ='1' "
       WHEN "2" LET g_sql = g_sql," AND tur11 ='2' "
    END CASE
    PREPARE q300_tur09pre FROM g_sql
    DECLARE q300_tur09 CURSOR FOR q300_tur09pre
    OPEN q300_tur09 
    FETCH q300_tur09 INTO g_tur09
    CLOSE q300_tur09
    IF cl_null(g_tur09) THEN LET g_tur09 = 0 END IF
 
    CASE g_argv1
       WHEN "1" 
            #期初數量還要加上期初至輸入日期前一天的數量                                
            LET l_date1=g_bdate-1                                                      
            SELECT SUM(tuq09) INTO l_tuq091 FROM tuq_file   #本期銷售                  
             WHERE tuq01 = g_tup.tup01 AND tuq02 = g_tup.tup02                         
               AND tuq03 = g_tup.tup03 AND tuq04 BETWEEN l_date AND l_date1            
               AND tuq10 = '1' AND tuq11 = '1' 
               AND tuq12 = g_tup.tup12   #TQC-660050 add 
            SELECT SUM(tuq09) INTO l_tuq092 FROM tuq_file   #本期銷退                  
             WHERE tuq01 = g_tup.tup01 AND tuq02 = g_tup.tup02                         
               AND tuq03 = g_tup.tup03 AND tuq04 BETWEEN l_date AND l_date1            
               AND tuq10 = '2' AND tuq11 = '1'
               AND tuq12 = g_tup.tup12   #TQC-660050 add 
            SELECT SUM(tuq09) INTO l_tuq093 FROM tuq_file   #客戶銷售                  
             WHERE tuq01 = g_tup.tup01 AND tuq02 = g_tup.tup02                         
               AND tuq03 = g_tup.tup03 AND tuq04 BETWEEN l_date AND l_date1            
               AND tuq10 = '3' AND tuq11 = '1'
               AND tuq12 = g_tup.tup12   #TQC-660050 add 
       WHEN "2" 
            #期初數量還要加上期初至輸入日期前一天的數量                                
            LET l_date1=g_bdate-1                                                      
            SELECT SUM(tuq09) INTO l_tuq091 FROM tuq_file   #本期銷售                  
             WHERE tuq01 = g_tup.tup01 AND tuq02 = g_tup.tup02                         
               AND tuq03 = g_tup.tup03 AND tuq04 BETWEEN l_date AND l_date1            
               AND tuq10 = '1' AND tuq11 = '2'
               AND tuq12 = g_tup.tup12   #TQC-660050 add 
            SELECT SUM(tuq09) INTO l_tuq092 FROM tuq_file   #本期銷退                  
             WHERE tuq01 = g_tup.tup01 AND tuq02 = g_tup.tup02                         
               AND tuq03 = g_tup.tup03 AND tuq04 BETWEEN l_date AND l_date1            
               AND tuq10 = '2' AND tuq11 = '2'
               AND tuq12 = g_tup.tup12   #TQC-660050 add 
            SELECT SUM(tuq09) INTO l_tuq093 FROM tuq_file   #客戶銷售                  
             WHERE tuq01 = g_tup.tup01 AND tuq02 = g_tup.tup02                         
               AND tuq03 = g_tup.tup03 AND tuq04 BETWEEN l_date AND l_date1            
               AND tuq10 = '3' AND tuq11 = '2'
               AND tuq12 = g_tup.tup12   #TQC-660050 add 
    END CASE
    IF cl_null(l_tuq091) THEN LET l_tuq091 = 0 END IF                          
    IF cl_null(l_tuq092) THEN LET l_tuq092 = 0 END IF                          
    IF cl_null(l_tuq093) THEN LET l_tuq093 = 0 END IF                          
    LET l_tuq09 = l_tuq091 + l_tuq092 + l_tuq093                               
    LET g_tur09=g_tur09+l_tuq09                                                
    IF SQLCA.sqlcode THEN                                                       
        CALL cl_err(g_tup.tup01,SQLCA.sqlcode,0)                                
        INITIALIZE g_tup.* TO NULL  #TQC-6B0105
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
    CALL q300_show()
END FUNCTION
 
FUNCTION q300_show()
 
   DISPLAY BY NAME g_tup.tup01,g_tup.tup02,g_tup.tup03,g_tup.tup04,
                   g_tup.tup05,g_tup.tup11,g_tup.tup12
   
   SELECT occ02 INTO g_occ02 FROM occ_file WHERE occ01=g_tup.tup01
   IF cl_null(g_occ02)   THEN LET g_occ02=''   END IF
   SELECT occ02 INTO g_occ02_2 FROM occ_file WHERE occ01=g_tup.tup12
   IF cl_null(g_occ02_2) THEN LET g_occ02_2='' END IF
   SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01=g_tup.tup02
   IF cl_null(g_ima02)   THEN LET g_ima02=''   END IF
   DISPLAY g_occ02,g_occ02_2,g_ima02,g_bdate,g_tur09
        TO occ02,occ02_2,ima02,bdate,tur09 #ATTRIBUTE(YELLOW)
   CALL q300_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q300_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,        #No.FUN-680120 VARCHAR(500)
          l_bdate   LIKE type_file.dat,            #No.FUN-680120 DATE
          l_edate   LIKE type_file.dat,            #No.FUN-680120 DATE
          l_base    LIKE tur_file.tur09,   #MOD-4B0067
          l_tuq09   LIKE tuq_file.tuq09    #MOD-4B0067
   DEFINE l_tut08   LIKE tut_file.tut08    #MOD-910224 add  
   LET l_sql = "SELECT tuq04,tuq10,'',tuq05,tuq09,0 ",
               "  FROM tuq_file",
               " WHERE tuq01 = '",g_tup.tup01,"'",
               "   AND tuq02 = '",g_tup.tup02 ,"'",
               "   AND tuq03 = '",g_tup.tup03 ,"'",
               "   AND tuq11 = '",g_tup.tup11 ,"'",
               "   AND tuq12 = '",g_tup.tup12 ,"'",
               "   AND ",tm.wc2 CLIPPED
   CASE g_argv1
      WHEN "1" LET l_sql = l_sql," AND tuq11 ='1' "
      WHEN "2" LET l_sql = l_sql," AND tuq11 ='2' "
   END CASE
   LET l_sql = l_sql," ORDER BY tuq04 "
   PREPARE q300_pb FROM l_sql
   DECLARE q300_bcs CURSOR FOR q300_pb           #BODY CURSOR
 
   LET g_rec_b=0
   LET l_base =0
   LET g_base =0
   LET l_tuq09=0
   LET g_year = YEAR(g_bdate)
   LET g_month= MONTH(g_bdate)
   CALL s_azm(g_year,g_month) RETURNING g_flag, l_bdate, l_edate
 
   IF cl_null(g_base) THEN LET g_base = 0 END IF
   LET l_base = l_base + g_tur09
   LET g_cnt = 1
   CALL g_tuq.clear()  #No.MOD-571024
   FOREACH q300_bcs INTO g_tuq[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CASE WHEN g_tuq[g_cnt].tuq10 = '1' LET g_tuq[g_cnt].desc = '銷售'
           WHEN g_tuq[g_cnt].tuq10 = '2' LET g_tuq[g_cnt].desc = '銷退'
           WHEN g_tuq[g_cnt].tuq10 = '3' LET g_tuq[g_cnt].desc = '實際異動'
      END CASE
      IF g_tuq[g_cnt].tuq09 IS NULL THEN 
         LET g_tuq[g_cnt].tuq09 = 0 
      END IF
      IF l_base IS NULL THEN LET l_base = 0 END IF
#MOD-9B0173 --BEGIN--
#      #MOD-910224---Begin
#      LET l_sql = "SELECT tut08 FROM tut_file ", 
#                  " WHERE tut01 = '",g_tuq[g_cnt].tuq05,"' ", 
#                  "   AND tut03 = '",g_tup.tup02,"' "  
#      PREPARE q300_tut1 FROM l_sql                                                                                                  
#      DECLARE q300_tut1_cs CURSOR FOR q300_tut1  
#      FOREACH q300_tut1_cs INTO l_tut08 
#        IF SQLCA.sqlcode THEN                                                                                                       
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)                                                                                  
#           EXIT FOREACH                                                                                                             
#        END IF     
#        IF l_tut08 != '2' THEN EXIT FOREACH END IF                                                                                  
#        LET g_tuq[g_cnt].tuq09 = g_tuq[g_cnt].tuq09 * (-1)                                                                          
#      END FOREACH          
#      #MOD-910224---End
#MOD-9B0173 --END--
      LET l_tuq09 = l_tuq09 + g_tuq[g_cnt].tuq09
      LET g_tuq[g_cnt].tot = l_base + l_tuq09 + g_base
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_tuq.deleteElement(g_cnt)  
   LET g_rec_b=g_cnt-1
   CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
 
END FUNCTION
 
FUNCTION q300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tuq TO s_tuq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL q300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump 
         CALL q300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL q300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL q300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
