# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abxr831.4gl
# Descriptions...: 在製品盤存清冊列印作業(abxr831)
# Date & Author..:
# Modify.........: 05/02/25 By cate 報表標題標準化
# Modify.........: No.FUN-550033 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-580110 05/08/24 By yoyo 報表轉XML
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/30 By TSD.sar2436 報表改由CR產出
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B30079 11/04/21 By sabrina QBE新增"盤點年度"選項
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm   RECORD                         # Print condition RECORD
               wc    LIKE type_file.chr1000            # Where condition   #No.FUN-680062      VARCHAR(1000)
               END RECORD,
          l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062smallint
DEFINE   l_table      STRING,    #FUN-850089 add
         g_str        STRING,    #FUN-850089 add
         g_sql        STRING     #FUN-850089 add
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
 
---FUN-850089 add ---start
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
 LET g_sql = "bwb01.bwb_file.bwb01,",
             "bwb011.bwb_file.bwb011,",
             "bwb02.bwb_file.bwb02,",
             "bwb03.bwb_file.bwb03,",
             "bwb04.bwb_file.bwb04,",
 
             "bwb07.bwb_file.bwb07,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "ima15.ima_file.ima15,",
             "ima25.ima_file.ima25,",
 
             "bwc01.bwc_file.bwc01,",
             "bwc011.bwc_file.bwc011,",
             "bwc02.bwc_file.bwc02,",
             "bwc03.bwc_file.bwc03,",
             "bwc04.bwc_file.bwc04,",
 
             "bwc05.bwc_file.bwc05,",
             "ima02_2.ima_file.ima02,",
             "ima021_2.ima_file.ima021,",
             "ima15_2.ima_file.ima15,",
             "ima25_2.ima_file.ima25"
 
             
        
 LET l_table = cl_prt_temptable('abxr831',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
 LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?  ,?,?,?,?,?  ,?,?,?,?,?)"   #20?
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1)
    EXIT PROGRAM
 END IF
#------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
   IF cl_null(tm.wc)
   THEN
       CALL abxr831_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr831_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 9 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 18
   END IF
   OPEN WINDOW abxr831_w AT p_row,p_col
        WITH FORM "abx/42f/abxr831"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bwb01,bwb011        #CHI-B30079 add bwb011
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr831_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1"
   THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   IF INT_FLAG
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr831_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL abxr831()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr831_w
END FUNCTION
 
FUNCTION abxr831()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name              #No.FUN-680062   VARCHAR(20)   
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       #No.FUN-680062 VARCHAR(1000)
          l_za05    LIKE za_file.za05,            #No.FUN-680062 VARCHAR(40)      
          g_ima15   LIKE ima_file.ima15,
          bwb       RECORD LIKE bwb_file.*,
          bwc       RECORD LIKE bwc_file.*
   DEFINE x_ima02     LIKE ima_file.ima02 #FUN-850059 add
   DEFINE x_ima021    LIKE ima_file.ima021 #FUN-850059 add
   DEFINE x_ima15     LIKE ima_file.ima15 #FUN-850059 add
   DEFINE x_ima25     LIKE ima_file.ima25 #FUN-850059 add
   DEFINE x_ima02_2   LIKE ima_file.ima02 #FUN-850059 add
   DEFINE x_ima021_2  LIKE ima_file.ima021 #FUN-850059 add
   DEFINE x_ima15_2   LIKE ima_file.ima15 #FUN-850059 add
   DEFINE x_ima25_2   LIKE ima_file.ima25 #FUN-850059 add
 
#FUN-850089 add---START
DEFINE l_sql2    STRING
## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql="SELECT ima15,bwb_file.*,bwc_file.* ",
              "  FROM bwb_file,bwc_file,ima_file  ",
              " WHERE bwb01=bwc01 AND bwb03=ima01 AND ",tm.wc clipped
 
     PREPARE abxr831_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM
     END IF
     DECLARE abxr831_curs1 CURSOR FOR abxr831_prepare1
 
     FOREACH abxr831_curs1 INTO g_ima15,bwb.*,bwc.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       MESSAGE g_x[9],bwb.bwb03 clipped,g_x[10],bwb.bwb04
       CALL ui.Interface.refresh()
     #---FUN-850089 add---START
       LET x_ima02 = ''
       LET x_ima021 = ''
       LET x_ima25 = ''
       LET x_ima15 = ''
       LET x_ima02_2 = ''
       LET x_ima021_2 = ''
       LET x_ima25_2 = ''
       LET x_ima15_2 = ''
       SELECT ima02,ima021,ima25,ima15 INTO x_ima02,x_ima021,x_ima25,x_ima15
         FROM ima_file
        WHERE ima01 = bwb.bwb03
       SELECT ima02,ima021,ima25,ima15 INTO x_ima02_2,x_ima021_2,x_ima25_2,x_ima15_2
         FROM ima_file
        WHERE ima01 = bwc.bwc03
 
       EXECUTE insert_prep USING bwb.bwb01,   bwb.bwb011,    bwb.bwb02,  bwb.bwb03,    bwb.bwb04,
                                 bwb.bwb07,   x_ima02,       x_ima021,   x_ima15,      x_ima25,
                                 bwc.bwc01,   bwc.bwc011,    bwc.bwc02,  bwc.bwc03,    bwc.bwc04,
                                 bwc.bwc05,   x_ima02_2,     x_ima021_2, x_ima15_2,    x_ima25_2
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
     #---FUN-850089 add---END
     END FOREACH
 
 #FUN-850089  ---start---
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
   LET l_sql2= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'bwb011,bwb01')     #CHI-B30079 add bwb011
           RETURNING g_str
   ELSE
      LET g_str = ''
   END IF
              
               #P1              
   LET g_str = g_str
   CALL cl_prt_cs3('abxr831','abxr831',l_sql2,g_str)
   #------------------------------ CR (4) ------------------------------#
 #FUN-850089  ----end---
END FUNCTION
#No.FUN-870144
