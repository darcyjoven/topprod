# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr710.4gl
# Descriptions...: 轉稼工時統計表
# Date & Author..: 99/05/25 By Iceman
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.TQC-5B0023 05/11/07 By kim 報表'接下頁'位置錯誤
# Modify.........: No.MOD-640238 06/04/010 By pengu 中文說明加 "日期"
# Modify.........: No.FUN-670067 06/07/19 By Jackho voucher型報表轉template1 
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕灰色
# Modify.........: No.FUN-770070 07/07/19 By TSD.Achick報表改寫由Crystal Report產出
# Modify.........: No.TQC-940157 09/05/11 By mike ds_report-->g_cr_db_str     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.TQC-A40137 10/04/28 By jan EXECUTE裡不可有擷取字串的中括號[](修正TQC-9C0179的問題)
# Modify.........: No.TQC-A50156 10/05/28 By Carrier main结构调整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(800)
              yy      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              mm      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
              END RECORD,
          g_shg   RECORD LIKE shg_file.*,
          g_no    LIKE type_file.num5,              #No.FUN-680121 SMALLINT
          g_day  DYNAMIC ARRAY OF RECORD
                 day  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
                 sum  LIKE shg_file.shg09           #No.FUN-680121 DEC(10,4)
          END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE l_table     STRING                       ### FUN-770070 add ###
DEFINE g_sql       STRING                       ### FUN-770070 add ###
DEFINE g_str       STRING                       ### FUN-770070 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50156  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #str FUN-770070 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-770070 *** ##
   LET g_sql = "shg01.shg_file.shg01,",
               "shg04.shg_file.shg04,",
               "shg09.shg_file.shg09,",
               "sgb05.sgb_file.sgb05"
 
   LET l_table = cl_prt_temptable('asfr710',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  #LET g_sql = "INSERT  INTO ds_report.",l_table CLIPPED,     #TQC-940157                                                            
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #TQC-940157 
               " VALUES(?,?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
   #No.TQC-A50156  --End  

   CALL asfr710_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr710_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 15
   END IF
   OPEN WINDOW asfr710_w AT p_row,p_col
        WITH FORM "asf/42f/asfr710"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy= YEAR(g_today)
   LET tm.mm= MONTH(g_today)
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shg04,shg08,shg06,shg021,shg10
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(shg08) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO shg08
               NEXT FIELD shg08
            END IF
#No.FUN-570240 --end--
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
         ON ACTION help                #No.TQC-770004
          LET g_action_choice="help"  #No.TQC-770004
          CALL   cl_show_help()       #No.TQC-770004
          CONTINUE CONSTRUCT          #No.TQC-770004 
    
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW asfr710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
#  IF tm.wc = ' 1=1' THEN
#     CALL cl_err('','9046',0) CONTINUE WHILE
#  END IF
   INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD mm
            IF tm.mm IS NULL OR tm.mm < 1 OR tm.mm >12 THEN
               LET tm.mm = MONTH(g_today)
               NEXT FIELD mm
            END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
          ON ACTION help                #No.TQC-770004                                                                               
          LET g_action_choice="help"  #No.TQC-770004                                                                                
          CALL   cl_show_help()       #No.TQC-770004                                                                                
          CONTINUE INPUT          #No.TQC-770004   
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW asfr710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
 
   CALL cl_wait()
   CALL asfr710()
   ERROR ""
END WHILE
   CLOSE WINDOW asfr710_w
END FUNCTION
 
FUNCTION asfr710()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_shg01   LIKE shg_file.shg01,
          l_sgb05   LIKE sgb_file.sgb05,          #FUN-770070
          bdate,edate LIKE type_file.dat,         #No.FUN-680121 DATE
          l_i,l_dd  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          sr RECORD
             shg01  LIKE shg_file.shg01,
             shg04  LIKE shg_file.shg04,
             shg09  LIKE shg_file.shg09
          END RECORD
   DEFINE l_sgb05_1    LIKE sgb_file.sgb05   #TQC-9C0179
 
   #str FUN-770070  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770070 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-770070  add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770070 add ###
#No.FUN-670067--begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr710'  
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 190 END IF             
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR            
#No.FUN-670067--end
     LET bdate=MDY(tm.mm,1,tm.yy)
     IF tm.mm = 12 THEN
        LET edate=MDY(1,1,tm.yy+1)-1
     ELSE
        LET edate=MDY(tm.mm+1,1,tm.yy)-1
     END IF
     LET l_sql = "SELECT UNIQUE shg01 FROM shg_file",
                 " WHERE shg11 = 'Y' AND shg09 <> 0 ",
                 "   AND shg01 >= '",bdate,"'",
                 "   AND shg01 <= '",edate,"' AND ",tm.wc
 
     PREPARE asfr710_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE asfr710_curs1 CURSOR FOR asfr710_prepare1
    
     FOR l_i=1 TO 31
         LET g_day[l_i].day=0
         LET g_day[l_i].sum=0
     END FOR
     LET g_pageno = 0
     LET g_no=1
     FOREACH asfr710_curs1 INTO l_shg01
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_dd=DAY(l_shg01)
       LET g_day[g_no].day=l_dd
       LET g_no=g_no+1
     END FOREACH
     LET g_no=g_no-1
     LET g_len = 8*(g_no+1)+10
     IF g_len < 80 THEN                
        LET g_len=80                  
     END IF                          
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '-' END FOR         #No.FUN-670067
     LET l_sql = "SELECT shg01,shg04,SUM(shg09) FROM shg_file",
                 " WHERE shg11 = 'Y' AND shg09 <> 0 ",
                 "   AND shg01 >= '",bdate,"'",
                 "   AND shg01 <= '",edate,"' AND ",tm.wc CLIPPED,
                 " GROUP BY shg04,shg01"
     PREPARE asfr710_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE asfr710_curs2 CURSOR FOR asfr710_prepare2
     FOREACH asfr710_curs2 INTO sr.*
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770070 *** ##
         SELECT sgb05 INTO l_sgb05 FROM sgb_file WHERE sgb01 = sr.shg04
         LET l_sgb05_1 = l_sgb05[1,10]   #TQC-9C0179
         EXECUTE insert_prep USING 
           #sr.shg01, sr.shg04, sr.shg09, l_sgb05[1,10]   #TQC-9C0179 mark
            sr.shg01, sr.shg04, sr.shg09, l_sgb05_1       #TQC-9C0179 #TQC-A40137
       #------------------------------ CR (3) ------------------------------#
       
     END FOREACH
 
   #str FUN-770070 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770070 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'shg04,shg08,shg06,shg021,shg10')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str
   CALL cl_prt_cs3('asfr710','asfr710',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   
END FUNCTION
