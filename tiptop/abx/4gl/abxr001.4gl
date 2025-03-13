# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# 
# Pattern name...: abxr001.4gl
# Descriptions...: 保稅庫存折合數量(列印)作業
# 1998.07.20 BY CHIAYI
# Modify.........: No.FUN-530012 05/03/14 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP 
# Modify.........: NO.TQC-5B0028 05/11/07 BY yiting 料號品名不可在同一行 
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/19 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE 
          wc         LIKE type_file.chr1000,               #No.FUN-680062  VARCHAR(1000)
          g_mount    LIKE type_file.num10                  #No.FUN-680062  integer
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose      #No.FUN-680062 smallint
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
   LET g_sql = "bwe00.bwe_file.bwe00,",        #類別
               "bwe03.bwe_file.bwe03,",        #料件編號
               "l_bw01.bwa_file.bwa01,",       #標籤編號
	       "l_bw02.bwa_file.bwa02,",       #料件編號
               "ima15.ima_file.ima15,",        #保稅與否
               "ima02.ima_file.ima02,",        #品名
               "bwe04.bwe_file.bwe04,",        #折合數量
               "l_type.ima_file.ima15"
             
 
                                          #7 items
  LET l_table = cl_prt_temptable('abxr001',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   CALL abxr001_tm(4,15)        # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr001_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062CHAR(1000)
 
   LET p_row = 7 LET p_col =25 
 
   OPEN WINDOW abxr001_w AT p_row,p_col WITH FORM "abx/42f/abxr001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   LET  wc = '' 
 
WHILE TRUE
   CONSTRUCT BY NAME wc ON bwe00,bwe03,ima15
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
            IF INFIELD(bwe03) THEN                               
               CALL cl_init_qry_var()                            
               LET g_qryparam.form = "q_ima"                     
               LET g_qryparam.state = "c"                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                              
               DISPLAY g_qryparam.multiret TO bwe03             
               NEXT FIELD bwe03                                  
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL abxr001()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr001_w
END FUNCTION
 
FUNCTION abxr001()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name            #No.FUN-680062  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680062  VARCHAR(1000)         
          l_chr     LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680062 VARCHAR(40) 
          bwe       RECORD LIKE bwe_file.* ,
          ima       RECORD LIKE ima_file.* 
  #FUN-850089  ---start---
   DEFINE sr RECORD
             l_bw01      LIKE bwa_file.bwa01,      #標籤編號
	     l_bw02      LIKE bwa_file.bwa02,      #料件編號
             l_type      LIKE ima_file.ima15
          END RECORD
       
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  {
     LET g_x[1]='保稅料件庫存(WHERE USER)列印'
     LET g_x[2]='製表日期:'
     LET g_x[3]='頁次:'
     LET g_x[4]='(abxr001)'
     LET g_x[6]='(接下頁)'
     LET g_x[7]='(結  束)'
   }  
 
     LET l_sql = "SELECT bwe_file.*,ima_file.* ",
                 "  FROM bwe_file,OUTER ima_file ",
                 " WHERE bwe_file.bwe03 = ima_file.ima01 ",
                 "   AND ",wc clipped 
 
     PREPARE abxr001_prepare1 FROM l_sql
 
     IF SQLCA.sqlcode != 0 
     THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
 
     DECLARE abxr001_curs1 CURSOR FOR abxr001_prepare1
 
     LET g_pageno = 0
     FOREACH abxr001_curs1 INTO bwe.*,ima.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
 
      #---FUN-850089 add---START
      IF bwe.bwe00 = "S"
      THEN
          SELECT bwa01,bwa02 INTO sr.l_bw01,sr.l_bw02 FROM bwa_file
           WHERE bwa01 = bwe.bwe01
          LET sr.l_type = '1'
      ELSE 
          SELECT bwb01,bwb03 INTO sr.l_bw01,sr.l_bw02 FROM bwb_file
           WHERE bwb01 = bwe.bwe01
          LET sr.l_type = '2'
      END IF 
 
      EXECUTE insert_prep USING bwe.bwe00, bwe.bwe03, sr.l_bw01, 
                                 sr.l_bw02,ima.ima15, ima.ima02, 
                                bwe.bwe04, sr.l_type
    
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
     END FOREACH
 
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bwe00,bwe03"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(wc,'bwe00,bwe03,ima15')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str
    CALL cl_prt_cs3('abxr001','abxr001',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---
 
END FUNCTION
#No.FUN-870144
