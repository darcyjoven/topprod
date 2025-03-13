# Prog. Version..: '5.30.06-13.03.14(00005)'     #
#
# Pattern name...: abxr836.4gl
# Descriptions...: 外銷折合原料清冊作業(abxr836)
# Date & Author..: 
# Modify.........: No.FUN-530012 05/03/16 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗 
# Modify.........: NO.TQC-5A0003 05/10/06 BY yiting 只有印品名.沒有規格
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/29 By TSD.Ken 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-CC0146 12/12/26 By Elise 修改日期比對sql的判斷
# Modify.........: No.MOD-CC0208 13/01/11 By Elise 修改條件bne05 = bwg04
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc   LIKE type_file.chr1000    # Where condition      #No.FUN-680062   VARCHAR(1000)   
              END RECORD,
          g_count LIKE type_file.num5,                              #No.FUN-680062     smallint 
          l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
   DEFINE   l_table              STRING,    #FUN-850089 add
            l_table1             STRING,    #FUN-850089 add
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
 
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql ="bwg00.bwg_file.bwg00,",
             "bwg01.bwg_file.bwg01,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "bwg02.bwg_file.bwg02,",
             "bwg05.bwg_file.bwg05,",
             "bnd04.bnd_file.bnd04"
 
  LET l_table = cl_prt_temptable('abxr836',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
 
  LET g_sql ="bwg00.bwg_file.bwg00,",
             "bwg01.bwg_file.bwg01,",
             "ima02.ima_file.ima02,",
             "bwg02.bwg_file.bwg02,",
             "bwg03.bwg_file.bwg03,",
             "bwg04.bwg_file.bwg04,",
             "bwg05.bwg_file.bwg05,",
             "bne08.bne_file.bne08"
 
  LET l_table1 = cl_prt_temptable('abxr83601',g_sql) CLIPPED   # 產生Temp Table
  IF l_table1 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?)" #7 items
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?)" #8 items
  PREPARE insert_prep1 FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep1:',status,1)
     EXIT PROGRAM
  END IF
 
 
  #------------------------------ CR (1) ------------------------------#
  #---FUN-850089 add ---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
   IF cl_null(tm.wc)
   THEN 
       CALL abxr836_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr836_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 9 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 19
   END IF
   OPEN WINDOW abxr836_w AT p_row,p_col
        WITH FORM "abx/42f/abxr836" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bwd01
#No.FUN-570243 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr836_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" 
   THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr836_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL abxr836()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr836_w
END FUNCTION
 
FUNCTION abxr836()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name             #No.FUN-680062   VARCHAR(20)   
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       #No.FUN-680062  VARCHAR(1000)
          l_za05    LIKE za_file.za05,            #No.FUN-680062  VARCHAR(40)    
          bwd       RECORD LIKE bwd_file.*,   
          bwg       RECORD LIKE bwg_file.*   
 
#FUN-850089 add---START
DEFINE l_ima RECORD LIKE ima_file.*
DEFINE l_bnd RECORD LIKE bnd_file.*
DEFINE l_bne RECORD LIKE bne_file.*,
       mbwg       RECORD LIKE bwg_file.*   
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
 
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql="SELECT bwd_file.*,bwg_file.* ",
              "  FROM bwd_file,bwg_file  ",
              " WHERE bwd01=bwg01 AND bwd02=bwg02 AND bwg00 ='F' AND ",
              " bwg01 = bwg04 AND ",tm.wc clipped 
 
     PREPARE abxr836_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
     END IF
     LET g_count = 0
     DECLARE abxr836_curs1 CURSOR FOR abxr836_prepare1
    
     FOREACH abxr836_curs1 INTO bwd.*,bwg.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
      #FUN-850089  ---start---
      INITIALIZE l_ima.* TO NULL
      SELECT * INTO l_ima.* from ima_file 
       where ima01 = bwd.bwd01 
 
      INITIALIZE l_bnd.* TO NULL
      select * into l_bnd.* FROM bnd_file where bnd01 = bwd.bwd01 
 
      EXECUTE insert_prep 
        USING bwg.bwg00,bwg.bwg01,l_ima.ima02,l_ima.ima021,
              bwg.bwg02,bwg.bwg05,l_bnd.bnd04
      IF STATUS THEN
         CALL cl_err('ins prep',STATUS,1)
      END IF
 
      declare selmmxxk cursor for 
        select * from bwg_file 
      where bwg00 = bwg.bwg00 
      AND   bwg01 = bwg.bwg01
      AND   bwg02 = bwg.bwg02 
       AND bwg01 <> bwg04       #No.9572
      ORDER BY bwg00,bwg01,bwg02,bwg03
      FOREACH selmmxxk INTO mbwg.*
        select * into l_ima.* from ima_file 
         where ima01 = mbwg.bwg04
        select * into l_bne.* 
          from bne_file where bne01 = mbwg.bwg01
                         #and bne02 = mbwg.bwg02   #MOD-CC0146 mark
                          and bne02 <= mbwg.bwg02  #MOD-CC0146
                         #and bne03 = mbwg.bwg03   #MOD-CC0208 mark
                          and bne05 = mbwg.bwg04   #MOD-CC0208
 
        EXECUTE insert_prep1 
          USING mbwg.bwg00,
                mbwg.bwg01,
                l_ima.ima02,
                mbwg.bwg02,
                mbwg.bwg03,
                mbwg.bwg04,
                mbwg.bwg05,
               l_bne.bne08
      IF STATUS THEN
         CALL cl_err('ins prep',STATUS,1)
      END IF
      END FOREACH
 
      #FUN-850089  ---end---
     END FOREACH
 
   #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bwd01')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
 
    LET g_str = g_str
 
    CALL cl_prt_cs3('abxr836','abxr836',l_sql,g_str)
   #---FUN-850089 add---END
END FUNCTION
#No.FUN-870144
