# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# 
# Pattern name...: abxr002.4gl
# Descriptions...: 保稅(銷售+報廢+外運)折合數量列印作業
# 1998.07.20 BY CHIAYI
# Modify.........: No.FUN-530012 05/03/14 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP 
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/20 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE   wc            LIKE type_file.chr1000, #No.FUN-680062 VARCHAR(1000)
         g_mount       LIKE type_file.num10    #No.FUN-680062 INTEGER
 
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   l_table      STRING,    #FUN-850089 add
         g_str        STRING,    #FUN-850089 add
         g_sql        STRING     #FUN-850089 add  #sql字串
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "bwg00.bwg_file.bwg00,",        #類別
               "bwg04.bwg_file.bwg04,",        #料件編號
               "bwg01.bwg_file.bwg01,",        #主件料號
	       "bwg05.bwg_file.bwg05,",        #折合數量
               "ima02.ima_file.ima02,",        #品名
               "ima15.ima_file.ima15,",        #保稅與否
               "l_type.ima_file.ima15"
 
 
                                          #7 items
  LET l_table = cl_prt_temptable('abxr002',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   CALL abxr002_tm(4,15)        # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr002_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062 VARCHAR(1000)
 
   LET p_row = 8 LET p_col = 25
            
   OPEN WINDOW abxr002_w AT p_row,p_col WITH FORM "abx/42f/abxr002" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   LET  wc = '' 
 
WHILE TRUE
   CONSTRUCT BY NAME wc ON bwg00,bwg04,ima15
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
#No.FUN-570243  --start-                                                                          
      ON ACTION CONTROLP                                                                          
            IF INFIELD(bwg04) THEN                                                                
               CALL cl_init_qry_var()                                                             
               LET g_qryparam.form = "q_ima"                                                      
               LET g_qryparam.state = "c"                                                         
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                 
               DISPLAY g_qryparam.multiret TO bwg04                                               
               NEXT FIELD bwg04                                                                   
            END IF                                                                                
#No.FUN-570243 --end-- 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 LET wc = wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL abxr002()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr002_w
END FUNCTION
 
FUNCTION abxr002()
   DEFINE l_name   LIKE type_file.chr20,           # External(Disk) file name        #No.FUN-680062 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT                 #No.FUN-680062 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,           #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,         #No.FUN-680062 VARCHAR(40)
          bwg       RECORD LIKE bwg_file.*,
          ima       RECORD LIKE ima_file.* 
  #FUN-850089  ---start---
   DEFINE l_type      LIKE ima_file.ima15
       
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT bwg_file.*,ima_file.* ",
                 "  FROM bwg_file,OUTER ima_file ",
                 " WHERE bwg_file.bwg04 = ima_file.ima01 ",
                 "   AND ",wc clipped 
 
     PREPARE abxr002_prepare1 FROM l_sql
 
     IF SQLCA.sqlcode != 0 
     THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
 
     DECLARE abxr002_curs1 CURSOR FOR abxr002_prepare1
 
     LET g_pageno = 0
     FOREACH abxr002_curs1 INTO bwg.*,ima.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
      #---FUN-850089 add---START
      CASE           #L:內銷 F:外銷 S:報廢 T:外運
         WHEN bwg.bwg00  = "L"
              LET l_type = '1' 
         WHEN bwg.bwg00  = "F"
              LET l_type = '2'
         WHEN bwg.bwg00  = "S"
              LET l_type = '3'
         WHEN bwg.bwg00  = "T"
              LET l_type = '4'
      END CASE 
 
      EXECUTE insert_prep USING bwg.bwg00, bwg.bwg04, bwg.bwg01,
                                bwg.bwg05, ima.ima02, ima.ima15, 
                                l_type
    
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
     END FOREACH
 
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bwg00,bwg04"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(wc,'bzj01,bzj02,bzj03,bzj04,bzj05,bzj06,bzjuser,bzjgrup,bzjmodu,bzjdate,bzjacti')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str
    CALL cl_prt_cs3('abxr002','abxr002',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---
 
END FUNCTION
#No.FUN-870144
