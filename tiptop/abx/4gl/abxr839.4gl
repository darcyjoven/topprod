# Prog. Version..: '5.30.06-13.03.14(00006)'     #
#
# Pattern name...: abxr839.4gl
# Descriptions...: 外運折合原料清冊作業(abxr839)
# Date & Author..: 
# Modify.........: No.FUN-530012 05/03/16 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗 
# Modify.........: NO.TQC-5A0003 05/10/07 BY yiting 沒有規格
# Modify.........: No.TQC-5B0216 05/11/30 By Rosayu 按語言鍵無法選取其他語言別
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/06/06 By TSD.liquor 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-CC0147 12/12/26 By Elise 修改查詢bne08組成用量時之sql日期判斷
# Modify.........: No.MOD-CC0208 13/01/11 By Elise 修改條件bne05 = bwg04
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc     LIKE type_file.chr1000  # Where condition       #No.FUN-680062   VARCHAR(300)   
              END RECORD,
          g_count LIKE type_file.num5,                               #No.FUN-680062   smallint   
          l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   l_table              STRING,    #FUN-850089 add
         g_sql                STRING,    #FUN-850089 add
         g_str                STRING     #FUN-850089 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
  #---FUN-850089 add ---start
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bwg01.bwg_file.bwg01,",
              "bwg02.bwg_file.bwg02,",
              "x_bnd04.bnd_file.bnd04,",
              "bwg05.bwg_file.bwg05,",
              "x_ima02.ima_file.ima02,",
              "x_ima021.ima_file.ima021,",
              "nbwg03.bwg_file.bwg05,",
              "nbwg04.bwg_file.bwg04,",
              "ima02.ima_file.ima02,",
              "bne08.bne_file.bne08,",
              "nbwg05.bwg_file.bwg05"
             
  LET l_table = cl_prt_temptable('abxr839',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  #------------------------------ CR (1) ------------------------------#
  #---FUN-850089 add ---end
 
 
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
   IF cl_null(tm.wc)
   THEN 
       CALL abxr839_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr839_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680062 smallint
          l_cmd        LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 9 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW abxr839_w AT p_row,p_col
        WITH FORM "abx/42f/abxr839" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON bwd01 ON ACTION locale #TQC-5B0216 mark
   #TQC-5B0216 add
   CONSTRUCT BY NAME tm.wc ON bwd01 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
   #TQC-5B0216 end
#No.FUN-570243 --start--                                                                                    
      ON ACTION CONTROLP                                                                                              
            IF INFIELD(bwd01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO bwd01                                                                                 
               NEXT FIELD bwd01                                                                                                     
            END IF  
#No.FUN-570243 --end-- 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr839_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" 
   THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr839_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL abxr839()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr839_w
END FUNCTION
 
FUNCTION abxr839()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name        #No.FUN-680062  VARCHAR(20)    
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,        #No.FUN-680062 VARCHAR(600)
          l_za05    LIKE za_file.za05,             #No.FUN-680062 VARCHAR(40)      
          bwd       RECORD LIKE bwd_file.*,   
          bwg       RECORD LIKE bwg_file.* 
   #FUN-850089 add----------------------
   DEFINE  sr  RECORD
         bwg01      LIKE bwg_file.bwg01,
         bwg02      LIKE bwg_file.bwg02,
         x_bnd04    LIKE bnd_file.bnd04,
         bwg05      LIKE bwg_file.bwg05,
         x_ima02    LIKE ima_file.ima02,
         x_ima021   LIKE ima_file.ima021,
         nbwg03     LIKE bwg_file.bwg05,
         nbwg04     LIKE bwg_file.bwg04,
         ima02      LIKE ima_file.ima02,
         bne08      LIKE bne_file.bne08,
         nbwg05     LIKE bwg_file.bwg05
       END RECORD,
         nbwg       RECORD LIKE bwg_file.*,
         l_flag     LIKE type_file.chr1
   #FUN-850089 add end------------------  
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ------------------------------#
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql="SELECT bwd_file.*,bwg_file.* ",
              "  FROM bwd_file,bwg_file  ",
              " WHERE bwd01=bwg01 AND bwd02=bwg02 AND bwg00 ='T' AND ",
              " bwg01 = bwg04 AND ",tm.wc clipped 
 
     PREPARE abxr839_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
     END IF
     LET g_count = 0
     DECLARE abxr839_curs1 CURSOR FOR abxr839_prepare1
    
     FOREACH abxr839_curs1 INTO bwd.*,bwg.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       #FUN-850089 add----------CR (3)------------
        DECLARE selmmxx2 CURSOR FOR 
          SELECT * FROM bwg_file 
            WHERE bwg00 = bwg.bwg00 
              AND bwg01 = bwg.bwg01
              AND bwg02 = bwg.bwg02 
              AND bwg01 <> bwg04       
              ORDER BY bwg00,bwg01,bwg02,bwg03
        INITIALIZE sr.* TO NULL
        LET sr.bwg01 = bwg.bwg01
        LET sr.bwg02 = bwg.bwg02
        SELECT bnd04 INTO sr.x_bnd04 
           FROM bnd_file 
             WHERE bnd01 = bwd.bwd01 
        LET sr.bwg05 = bwg.bwg05
        SELECT ima02,ima021 INTO sr.x_ima02,sr.x_ima021
          FROM ima_file WHERE ima01 = bwd.bwd01 
        LET l_flag = 'N'
        FOREACH selmmxx2 INTO nbwg.*
          LET sr.nbwg03 = nbwg.bwg03
          LET sr.nbwg04 = nbwg.bwg04
          SELECT ima02 INTO sr.ima02
            FROM ima_file 
              WHERE ima01 = nbwg.bwg04
          SELECT bne08 INTO sr.bne08 
            FROM bne_file 
             WHERE bne01 = nbwg.bwg01
              #AND bne02 = nbwg.bwg02   #MOD-CC0147 mark
               AND bne02 <= nbwg.bwg02  #MOD-CC0147
              #AND bne03 = nbwg.bwg03   #MOD-CC0208 mark
               AND bne05 = mbwg.bwg04   #MOD-CC0208
          LET sr.nbwg05 = nbwg.bwg05
          EXECUTE insert_prep USING sr.*
          LET l_flag = 'Y'
        END FOREACH 
        IF l_flag = 'N' THEN
          EXECUTE insert_prep USING sr.*
        END IF   
       #FUN-850089 add end------------------------
     END FOREACH
 
     #FUN-850089  ---start---
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bwd01')
             RETURNING g_str
     ELSE
        LET g_str = ''
     END IF
 
     CALL cl_prt_cs3('abxr839','abxr839',l_sql,g_str)
     #---FUN-850089 add---END
 
END FUNCTION
#No.FUN-870144
