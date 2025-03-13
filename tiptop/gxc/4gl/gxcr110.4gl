# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: gxcr110.4gl
# Descriptions...: 庫存入項資料明細表
# Input parameter:
# Return code....:
# Date & Author..: 04/03/01 By Elva
# Modify.........: No.FUN-4C0099 05/01/27 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-630003 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-830148 08/04/01 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80044 11/08/04 By fanbj EXIT PROGRAM 前加cl_used(2) 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,  #NO.FUN-680145 VARCHAR(600)  # Where condition
              yy,mm   LIKE type_file.num5,     #NO.FUN-680145 SMALLINT
              more    LIKE type_file.chr1      #NO.FUN-680145 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD
   DEFINE
           bdate   LIKE type_file.dat,         #NO.FUN-680145 DATE
           edate   LIKE type_file.dat,         #NO.FUN-680145 DATE
           g_argv1 LIKE cxa_file.cxa01,        #NO.FUN-680145 VARCHAR(20)
           g_argv2 LIKE type_file.num5,        #NO.FUN-680145 SMALLINT
           g_argv3 LIKE type_file.num5         #NO.FUN-680145 SMALLINT
DEFINE   g_i       LIKE type_file.num5         #NO.FUN-680145 SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING,               ### FUN-830148 ###                                                                     
         g_str           STRING,               ### FUN-830148 ###                                                                     
         g_sql           STRING                ### FUN-830148 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GXC")) THEN
      EXIT PROGRAM
   END IF
 
### *** FUN-830148 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "l_ima02.ima_file.ima02,",
                "l_ima021.ima_file.ima021,",
                "cxa06.cxa_file.cxa06,",
                "cxa07.cxa_file.cxa07,",
                "cxa01.cxa_file.cxa01,",
                "cxa10.cxa_file.cxa10,",
                "cxc04.cxc_file.cxc04,",
                "cxc05.cxc_file.cxc05,",
                "cxc08.cxc_file.cxc08,",
                "cxc09.cxc_file.cxc09,",
                "cxc091.cxc_file.cxc091,",
                "cxc092.cxc_file.cxc092,",
                "cxc093.cxc_file.cxc093,",
                "cxc094.cxc_file.cxc094,",
                "cxc095.cxc_file.cxc095,",
                "cxc11.cxc_file.cxc11"
    LET l_table = cl_prt_temptable('gxcr110',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?,                                                                                 
                         ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                   
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   #TQC-630003-begin
   #INITIALIZE tm.* TO NULL                # Default condition
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_trace = 'N'                      # default trace off
   #LET g_argv1 = ARG_VAL(1)               # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)               # Get arguments from command line
   #LET g_argv3 = ARG_VAL(3)               # Get arguments from command line
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(4)
   #LET g_rep_clas = ARG_VAL(5)
   #LET g_template = ARG_VAL(6)
   ##No.FUN-570264 ---end---
   #IF cl_null(g_argv1)
   # Prog. Version..: '5.30.06-13.03.12(0,0)           # Input print condition
   #   ELSE LET tm.wc="cxa01='",g_argv1,"'"
   #        LET tm.yy=g_argv2
   #        LET tm.mm=g_argv3
   #        CALL gxcr110()                 # Read data and create out-file
   #END IF
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)    
   LET tm.yy    = ARG_VAL(8)    
   LET tm.mm    = ARG_VAL(9)       
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  # No.FUN-B80044---add---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL gxcr110_tm(0,0)          # Input print condition
   ELSE
      CALL gxcr110()                # Read data and create out-file
   END IF
   #TQC-630003-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044---add---
END MAIN
 
FUNCTION gxcr110_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(400)
 
IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 15
   OPEN WINDOW gxcr110_w AT p_row,p_col
        WITH FORM "gxc/42f/gxcr110"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   CALL cl_opmsg('p')
   #TQC-630003-begin
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_trace = 'N'                      # default trace off
   #TQC-630003-end
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
WHILE TRUE
CONSTRUCT BY NAME tm.wc ON cxa01,cxa06
 
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
        IF INFIELD(cxa01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO cxa01
           NEXT FIELD cxa01
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gxcr110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044---add---
      EXIT PROGRAM
   END IF
 
INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD mm
         IF tm.mm < 1 OR tm.mm > 13 THEN NEXT FIELD mm END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
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
      LET INT_FLAG = 0 CLOSE WINDOW gxcr110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044---add---
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gxcr110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gxcr110','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",                #TQC-630003 
                         " '",tm.mm CLIPPED,"'",                #TQC-630003
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('gxcr110',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gxcr110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044---add---
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gxcr110()
   ERROR ""
END WHILE
   CLOSE WINDOW gxcr110_w
END FUNCTION
 
FUNCTION gxcr110()
   DEFINE l_name    LIKE type_file.chr20,    #NO.FUN-680145 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0099
          l_sql     LIKE type_file.chr1000,  #NO.FUN-680145 VARCHAR(400)   # RDSQL STATEMENT
          l_za05    LIKE type_file.chr1000,  #NO.FUN-680145 VARCHAR(40)
       sr        RECORD
                    cxa04  LIKE cxa_file.cxa04,
                    cxa05  LIKE cxa_file.cxa05,
                    cxa06  LIKE cxa_file.cxa06,
                    cxa07  LIKE cxa_file.cxa07,
                    cxa01  LIKE cxa_file.cxa01,
                    cxa02  LIKE cxa_file.cxa02,
                    cxa03  LIKE cxa_file.cxa03,
                    cxa10  LIKE cxa_file.cxa10,
                    cxc04  LIKE cxc_file.cxc04,
                    cxc05  LIKE cxc_file.cxc05,
                    cxc08  LIKE cxc_file.cxc08,
                    cxc09  LIKE cxc_file.cxc09,
                    cxc091 LIKE cxc_file.cxc091,
                    cxc092 LIKE cxc_file.cxc092,
                    cxc093 LIKE cxc_file.cxc093,
                    cxc094 LIKE cxc_file.cxc094,
                    cxc095 LIKE cxc_file.cxc095,
                    cxc11  LIKE cxc_file.cxc11
                    END RECORD
 
   DEFINE  l_ima02  LIKE ima_file.ima02,                                             #FUN-830148                                                                                              
           l_ima021 LIKE ima_file.ima021                                             #FUN-830148
        
     # No.FUN-B80044--start mark------------------------------------------------------------------- 
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     # No.FUN-B80044--end mark---------------------------------------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830148 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                     #FUN-830148                                       
     #------------------------------ CR (2) ------------------------------#
 
 LET l_sql="SELECT cxa04,cxa05,cxa06,cxa07,cxa01,cxa02,cxa03,",             
               "   cxa10,cxc04,cxc05,cxc08,cxc09,cxc091,cxc092,",           
               "   cxc093,cxc094,cxc095,cxc11",                             
               "  FROM cxa_file,OUTER cxc_file",  
               " WHERE cxc_file.cxc06 = cxa_file.cxa06 ",
               "   AND cxc_file.cxc07 = cxa_file.cxa07 ",                      
               "   AND cxc_file.cxc02 = cxa_file.cxa02 ",
               "   AND cxc_file.cxc03 = cxa_file.cxa03 ",
               "   AND cxc_file.cxc01 = cxa_file.cxa01 ",    
               "   AND cxa10 > 0 ",                                             
               "   AND cxa02 = ",tm.yy,                                         
               "   AND cxa03 = ",tm.mm,                                         
               "   AND ",tm.wc  CLIPPED 
     PREPARE gxcr110_prepare1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044---add---
        EXIT PROGRAM 
     END IF
     DECLARE gxcr110_curs1 CURSOR FOR gxcr110_prepare1
 
#    CALL cl_outnam('gxcr110') RETURNING l_name                                 #FUN-830148 MARK
#    START REPORT gxcr110_rep TO l_name                                         #FUN-830148 MARK
     LET g_pageno = 0
     FOREACH gxcr110_curs1 INTO sr.*
       IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
       END IF
#No.FUN-830148--Add-Begin--#
            SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                                                                 
                WHERE ima01=sr.cxa01                                                                                                
            IF SQLCA.sqlcode THEN                                                                                                   
                LET l_ima02 = NULL                                                                                                  
                LET l_ima021 = NULL                                                                                                 
            END IF
#No.FUN-830148--Add-End--#
#      OUTPUT TO REPORT gxcr110_rep(sr.*)                                        #FUN-830148 MARK
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830148 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 l_ima02,l_ima021,sr.cxa06,sr.cxa07,sr.cxa01,sr.cxa10,sr.cxc04,sr.cxc05,
                 sr.cxc08,sr.cxc09,sr.cxc091,sr.cxc092,sr.cxc093,sr.cxc094,sr.cxc095,sr.cxc11
     #------------------------------ CR (3) ------------------------------# 
 
     END FOREACH
 
#    FINISH REPORT gxcr110_rep                                                   #FUN-830148 MARK
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                 #FUN-830148 MARK
 
#No.FUN-830148--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'cxa01,cxa06')                                                     
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-830148--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830148 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.yy,";",tm.mm,";",g_azi04                                                      
    CALL cl_prt_cs3('gxcr110','gxcr110',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
END FUNCTION
 
#FUN-830148--Mark--Begin--#
#REPORT gxcr110_rep(sr)
#  DEFINE l_tot           LIKE alb_file.alb06,    #NO.FUN-680145 DECIMAL(20,6) 
#         l_ima02 LIKE ima_file.ima02,
#         l_ima021 LIKE ima_file.ima021,
#      sr               RECORD
#                          cxa04  LIKE cxa_file.cxa04,
#                          cxa05  LIKE cxa_file.cxa05,
#                          cxa06  LIKE cxa_file.cxa06,
#                          cxa07  LIKE cxa_file.cxa07,
#                          cxa01  LIKE cxa_file.cxa01,
#                          cxa02  LIKE cxa_file.cxa02,
#                          cxa03  LIKE cxa_file.cxa03,
#                          cxa10  LIKE cxa_file.cxa10,
#                          cxc04  LIKE cxc_file.cxc04,
#                          cxc05  LIKE cxc_file.cxc05,
#                          cxc08  LIKE cxc_file.cxc08,
#                          cxc09  LIKE cxc_file.cxc09,
#                          cxc091 LIKE cxc_file.cxc091,
#                          cxc092 LIKE cxc_file.cxc092,
#                          cxc093 LIKE cxc_file.cxc093,
#                          cxc094 LIKE cxc_file.cxc094,
#                          cxc095 LIKE cxc_file.cxc095,
#                          cxc11  LIKE cxc_file.cxc11
#                          END RECORD,
#     l_trailer_sw         LIKE type_file.chr1          #NO.FUN-680145 VARCHAR(1)
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.cxa01,sr.cxa06,sr.cxa07,sr.cxc11 DESC
#  FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_x[15] CLIPPED,tm.yy USING '###&',
#                 g_x[16] CLIPPED,tm.mm USING '#&'
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                 g_x[41],g_x[42],g_x[43],g_x[44]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.cxa01
#           SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#               WHERE ima01=sr.cxa01
#           IF SQLCA.sqlcode THEN
#               LET l_ima02 = NULL
#               LET l_ima021 = NULL
#           END IF
#           PRINT COLUMN g_c[31],sr.cxa01 CLIPPED,
#                 COLUMN g_c[32],l_ima02 CLIPPED,
#                 COLUMN g_c[33],l_ima021 CLIPPED;
 
#       BEFORE GROUP OF sr.cxa06
#           PRINT COLUMN g_c[34],sr.cxa06 CLIPPED;
 
#       BEFORE GROUP OF sr.cxa07
#           PRINT COLUMN g_c[35],sr.cxa07 USING '###&',
#                 COLUMN g_c[36],cl_numfor(sr.cxa10,36,0);
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[37],sr.cxc04,
#                 COLUMN g_c[38],sr.cxc05 USING '###&',
#                 COLUMN g_c[39],cl_numfor(sr.cxc08,39,0),
#                 COLUMN g_c[40],cl_numfor(sr.cxc09,40,g_azi04),
#                 COLUMN g_c[41],cl_numfor(sr.cxc091,41,g_azi04),
#                 COLUMN g_c[42],cl_numfor(sr.cxc092,42,g_azi04),
#                 COLUMN g_c[43],cl_numfor(sr.cxc093,43,g_azi04),
#                 COLUMN g_c[44],cl_numfor(sr.cxc094,44,g_azi04),
#                 COLUMN g_c[45],cl_numfor(sr.cxc095,45,g_azi04)
#
#       AFTER GROUP OF sr.cxa01
#           PRINT
#
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#FUN-830148--Mark--End--#
 
#Patch....NO.TQC-610037 <001> #
#No.FUN-870144
