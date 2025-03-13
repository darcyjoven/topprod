# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Descriptions...: 固定/變動成本分析表
# 
# Date & Author..: 01/11/16 BY DS/P
# Modify.........: No.FUN-4C0099 05/01/26 By kim 報表轉XML功能
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤
# Modify.........: No.MOD-720042 07/02/26 By TSD.hoho 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-8C0047 09/01/14 By zhaijie MARK cl_outnam()
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
   DEFINE tm  RECORD                    # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300)       # Where condition
              yy      LIKE type_file.num5,           #No.FUN-680122SMALLINT
              mm      LIKE type_file.num5,           #No.FUN-680122SMALLINT
              more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)         # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE ccq_file.ccq03         #No.FUN-680122DECIMAL(13,2)       # User defined variable
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
 
DEFINE l_table   STRING   #Add No.MOD-720042 By TSD.hoho
DEFINE g_sql     STRING   #Add No.MOD-720042 By TSD.hoho
DEFINE g_str     STRING   #Add No.MOD-720042 By TSD.hoho
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   #----------------Add No.MOD-720042 By TSD.hoho----------------(S)
   # CREATE TEMP TABLE
   LET g_sql = " ima12.ima_file.ima12,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " caj04.caj_file.caj04,",
               " caj05.caj_file.caj05,",
               " caj06.caj_file.caj06,",
               " per1.caj_file.caj05,",
               " caj07.caj_file.caj07,",
               " per2.caj_file.caj05,",
               #070308 Add By TSD.Jack -----(S)-----
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05 "
               #070308 Add By TSD.Jack -----(E)-----
 
   LET l_table = cl_prt_temptable('axcr460',g_sql) CLIPPED  #產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              #070308 Modify By TSD.Jack -----(S)-----
              #" VALUES(?,?,?,?,?, ?,?,?,?) "
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?) "
              #070308 Modify By TSD.Jack -----(E)-----
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
   #----------------Add No.MOD-720042 By TSD.hoho----------------(E)
 
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr460_tm(0,0)             # Input print condition
      ELSE CALL axcr460()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr460_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 32
    ELSE
       LET p_row = 5 LET p_col = 12
    END IF
 
   OPEN WINDOW axcr460_w AT p_row,p_col
        WITH FORM "axc/42f/axcr460" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                 # Default condition
   LET tm.yy=YEAR(g_today)   
   LET tm.mm=MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima57,caj04 
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
 
#No.FUN-570240 --start                                                          
     ON ACTION controlp                                                      
        IF INFIELD(caj04) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima5"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO caj04                            
           NEXT FIELD caj04                                               
        END IF                                                              
#No.FUN-570240 --end     
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
 #MOD-530170
     ON ACTION cancel
        LET INT_FLAG = 1
        EXIT CONSTRUCT
##
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr460_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.yy,tm.mm,tm.more     
   INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD mm
        IF cl_null(tm.mm) OR tm.mm > 12 OR tm.mm < 1 THEN NEXT FIELD mm  END IF   
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr460_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr460'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr460','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr460',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr460_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr460()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr460_w
END FUNCTION
 
FUNCTION axcr460()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          sr        RECORD
                      ima12  LIKE ima_file.ima12,
                      ima02  LIKE ima_file.ima02,
                      ima021 LIKE ima_file.ima021,
                      caj04  LIKE caj_file.caj04,
                      caj05  LIKE caj_file.caj05, #本月投入
                      caj06  LIKE caj_file.caj06, #固定成本
                      per1   LIKE caj_file.caj05,         #No.FUN-680122DEC (6,3)
                      caj07  LIKE caj_file.caj07,
                      per2   LIKE caj_file.caj05          #No.FUN-680122DEC (6,3)
                    END RECORD 
 
   #----------------Add No.MOD-720042 By TSD.hoho----------------------(S)
   ### *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #----------------Add No.MOD-720042 By TSD.hoho----------------------(E)
 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720042 add
   
   LET l_sql=" SELECT ima12,ima02,ima021,caj04,caj05,caj06,0,caj07,0 ", 
             "   FROM caj_file,ima_file ",
             "  WHERE caj01='",tm.yy,"' ",
             "    AND caj02='",tm.mm,"' ",
             "    AND caj04=ima01 ",
             "    AND ",tm.wc CLIPPED
   PREPARE axcr460_p1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr460_c1 CURSOR FOR axcr460_p1
 
#   CALL cl_outnam('axcr460') RETURNING l_name       #FUN-8C0047 by zhaij
   #START REPORT axcr460_rep TO l_name # Modify 070226 By TSD.hoho CR11 add
   LET g_pageno = 0
 
   FOREACH axcr460_c1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM 
      END IF
      IF sr.caj05 IS NULL THEN LET sr.caj05=0 END IF 
      IF sr.caj06 IS NULL THEN LET sr.caj06=0 END IF 
      IF sr.caj07 IS NULL THEN LET sr.caj07=0 END IF 
      LET sr.per1=sr.caj05/sr.caj06 
      LET sr.per2=sr.caj05/sr.caj07
 
      #Add No.MOD-720042 By TSD.hoho --------------------------------------(S)
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
              sr.ima12,sr.ima02,sr.ima021,sr.caj04,
             #070308 Modify By TSD.Jack -----(S)-----
             #sr.caj05,sr.caj06,sr.per1,sr.caj07,sr.per2
              #sr.caj05,sr.caj06,sr.per1,sr.caj07,sr.per2,g_azi03,g_azi04,g_azi05 #CHI-C30012
              sr.caj05,sr.caj06,sr.per1,sr.caj07,sr.per2,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26 #CHI-C30012
             #070308 Modify By TSD.Jack -----(E)-----
      #Add No.MOD-720042 By TSD.hoho --------------------------------------(E)
   END FOREACH
 
   #Modify No.MOD-720042 By TSD.hoho ------------------------------------(S)
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima12,ima57,caj04')
           RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = " "
   END IF
   #            p1    ;   p2    ;    p3
   #LET g_str = g_str,";",tm.yy,";",tm.mm
   CALL cl_prt_cs3('axcr460','axcr460',l_sql,g_str)   #FUN-710080 modify
   #Modify No.MOD-720042 By TSD.hoho ------------------------------------(E)
 
END FUNCTION
 
{
REPORT axcr460_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
          l_chr         LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          per1_sum   LIKE caj_file.caj05,
          per2_sum   LIKE caj_file.caj05,
          caj05_sum   LIKE caj_file.caj05,
          caj06_sum   LIKE caj_file.caj06,
          caj07_sum   LIKE caj_file.caj07,
          sr        RECORD
                      ima12  LIKE ima_file.ima12,
                      ima02  LIKE ima_file.ima02,
                      ima021 LIKE ima_file.ima021,
                      caj04  LIKE caj_file.caj04,
                      caj05  LIKE caj_file.caj05, #本月投入
                      caj06  LIKE caj_file.caj06, #固定成本
                      per1   LIKE caj_file.caj05,         #No.FUN-680122DEC (6,3)
                      caj07  LIKE caj_file.caj07,
                      per2   LIKE caj_file.caj05          #No.FUN-680122DEC (6,3)
                    END RECORD 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 ORDER BY sr.ima12,sr.caj04 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT 
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39]
      PRINT g_dash1
      LET l_last_sw = 'n'
  
   BEFORE GROUP OF sr.ima12 
     LET caj05_sum=0 
     LET caj06_sum=0 
     LET caj07_sum=0 
     PRINT COLUMN g_c[31],sr.ima12;
 
   ON EVERY ROW
     LET caj05_sum=caj05_sum+sr.caj05 
     LET caj06_sum=caj06_sum+sr.caj06 
     LET caj07_sum=caj07_sum+sr.caj07 
     PRINT COLUMN g_c[32],sr.caj04,
           COLUMN g_c[33],sr.ima02,
           COLUMN g_c[34],sr.ima021,
           COLUMN g_c[35],cl_numfor(sr.caj05,35,g_azi03),    #FUN-570190
           COLUMN g_c[36],cl_numfor(sr.caj06,36,g_azi03),    #FUN-570190
           COLUMN g_c[37],sr.per1  USING '###.#&',
           COLUMN g_c[38],cl_numfor(sr.caj07,38,g_azi03),    #FUN-570190
           COLUMN g_c[39],sr.per2  USING '###.#&'
     
   AFTER GROUP OF sr.ima12 
     LET per1_sum=caj05_sum/caj06_sum 
     LET per2_sum=caj05_sum/caj07_sum
     PRINT COLUMN g_c[31],sr.ima12,
           COLUMN g_c[34],g_x[9] CLIPPED, 
           COLUMN g_c[35],cl_numfor(caj05_sum,35,g_azi03),    #FUN-570190
           COLUMN g_c[36],cl_numfor(caj06_sum,36,g_azi03),    #FUN-570190
           COLUMN g_c[37],per1_sum  USING '###.#&',
           COLUMN g_c[38],cl_numfor(caj07_sum,38,g_azi03),    #FUN-570190
           COLUMN g_c[39],per2_sum  USING '###.#&'
 
   ON LAST ROW
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]   #No.TQC-6A0078
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
