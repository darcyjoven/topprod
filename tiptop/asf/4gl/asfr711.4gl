# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfr711.4gl
# Descriptions...: 稼動效率日報表
# Date & Author..: 99/05/26 by patricia
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕灰色
# Modify.........: NO.FUN-7B0139 07/12/07 By zhaijie 報表輸出改為Crystal Report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                    # Print condition RECORD
                    wc    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where condition
                    n     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_sql      STRING                                         #NO.FUN-7B0139
DEFINE g_str      STRING                                         #NO.FUN-7B0139
DEFINE l_table    STRING                                         #NO.FUN-7B0139
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
#NO.FUN-7B0139------------start---------------
   LET g_sql = "shf01.shf_file.shf01,",
               "shf03.shf_file.shf03,",
               "gen01.gen_file.gen01,",
               "gen02.gen_file.gen02,",
               "shg04.shg_file.shg04,",
               "sgb05.sgb_file.sgb05,",
               "shg05.shg_file.shg05,",
               "shg06.shg_file.shg06,",
               "shg07.shg_file.shg07,",
               "shg08.shg_file.shg08,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "shg09.shg_file.shg09,",
               "shg10.shg_file.shg10,",
               "shg11.shg_file.shg11"
   LET l_table = cl_prt_temptable('asfr711',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7B0139------------end-----------
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r711_tm(0,0)        # Input print condition
      ELSE CALL asfr711()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r711_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000         #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 6 LET p_col = 14
   END IF
   OPEN WINDOW r711_w AT p_row,p_col
        WITH FORM "asf/42f/asfr711" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shf01,shf03,shf02 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
   ON ACTION help                     #No.TQC-770004 
      LET g_action_choice="help"      #No.TQC-770004 
      CALL cl_show_help()             #No.TQC-770004 
      CONTINUE CONSTRUCT              #No.TQC-770004 
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
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.n WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF tm.n NOT MATCHES "[123]" OR tm.n IS NULL THEN 
             NEXT FIELD n 
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
         ON ACTION help                     #No.TQC-770004                                                                                
           LET g_action_choice="help"      #No.TQC-770004                                                                                
           CALL cl_show_help()             #No.TQC-770004                                                                                
           CONTINUE INPUT              #No.TQC-770004
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr711'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr711','9031',1)
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
                         " '",tm.n CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
               
         CALL cl_cmdat('asfr711',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfr711()
   ERROR ""
END WHILE
   CLOSE WINDOW r711_w
END FUNCTION
 
FUNCTION asfr711()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          sr        RECORD 
                     shf01  LIKE shf_file.shf01,  #日期
                     shf03  LIKE shf_file.shf03, 
                     gen01  LIKE gen_file.gen01, 
                     gen02  LIKE gen_file.gen02,  #員工編號
                     shg04  LIKE shg_file.shg04, 
                     sgb05  LIKE sgb_file.sgb05, 
                     shg05  LIKE shg_file.shg05,  #轉稼工時
                     shg06  LIKE shg_file.shg06,  
                     shg07  LIKE shg_file.shg07,  
                     shg08  LIKE shg_file.shg08,   #料號
                     ima02  LIKE ima_file.ima02,  
                     ima021 LIKE ima_file.ima021,  
                     shg09  LIKE shg_file.shg09, 
                     shg10  LIKE shg_file.shg10, 
                     shg11  LIKE shg_file.shg11 
                    END RECORD
     CALL cl_del_data(l_table)                             #NO.FUN-7B0139
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asfr711'   #NO.FUN-7B0139
     LET l_sql = " SELECT shf01,shf03,gen01,'',shg04,sgb05,shg05,",
                 "shg06,shg07,shg08,ima02,ima021,shg09,shg10,shg11 ", 
                 "  FROM shf_file,shg_file,OUTER ima_file,OUTER gen_file,", 
                 " OUTER sgb_file ",
                 " WHERE shf01 = shg01 ",
                 "   AND shf02 = shg02 ", 
                 "   AND shf03 = shg021",
                 "   AND shf_file.shf02 = gen_file.gen01 ",
                 "   AND shg_file.shg08 = ima_file.ima01 ",
                 "   AND shg_file.shg04 = sgb_file.sgb01 " , 
                 "   AND ",tm.wc CLIPPED       
     IF tm.n ='2' THEN   
        LET l_sql = l_sql CLIPPED," AND shg09 > 0 " CLIPPED  
     END IF 
     IF tm.n ='3' THEN 
        LET l_sql = l_sql CLIPPED," AND shg09 = 0 " CLIPPED
     END IF      
     PREPARE r711_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM 
           
     END IF
     DECLARE r711_cs1 CURSOR FOR r711_prepare1
#     CALL cl_outnam('asfr711') RETURNING l_name           #NO.FUN-7B0139
#     START REPORT r711_rep TO l_name                      #NO.FUN-7B0139
 
     FOREACH r711_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF sr.gen01 IS NOT NULL THEN 
          SELECT gen02 INTO sr.gen02 FROM gen_file 
           WHERE gen01 = sr.gen01 
       END IF 
#       OUTPUT TO REPORT r711_rep(sr.*)                    #NO.FUN-7B0139   
       EXECUTE insert_prep USING
         sr.shf01,sr.shf03,sr.gen01,sr.gen02,sr.shg04,sr.sgb05,sr.shg05,
         sr.shg06,sr.shg07,sr.shg08,sr.ima02,sr.ima021,sr.shg09,
         sr.shg10,sr.shg11	
     END FOREACH
#     FINISH REPORT r711_rep                               #NO.FUN-7B0139
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-7B0139
#NO.FUN-7B0139--------start------------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'shf01,shf03,shf02')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('asfr711','asfr711',g_sql,g_str)                      
#NO.FUN-7B0139--------end------------
END FUNCTION
 
REPORT r711_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_shg05,shg05_tot    LIKE shg_file.shg05, 
          l_shg09,shg09_tot    LIKE shg_file.shg09, 
          sr        RECORD 
                     shf01  LIKE shf_file.shf01,  #日期
                     shf03  LIKE shf_file.shf03, 
                     gen01  LIKE gen_file.gen01, 
                     gen02  LIKE gen_file.gen02, 
                     shg04  LIKE shg_file.shg04, 
                     sgb05  LIKE sgb_file.sgb05, 
                     shg05  LIKE shg_file.shg05,  #轉稼工時
                     shg06  LIKE shg_file.shg06,  
                     shg07  LIKE shg_file.shg07,  
                     shg08  LIKE shg_file.shg08, 
                     ima02  LIKE ima_file.ima02,  
                     ima021 LIKE ima_file.ima021,  
                     shg09  LIKE shg_file.shg09, 
                     shg10  LIKE shg_file.shg10, 
                     shg11  LIKE shg_file.shg11 
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin 
  LEFT       MARGIN 0
  BOTTOM MARGIN g_bottom_margin 
  PAGE       LENGTH g_page_line
  ORDER BY sr.shf01,sr.shf03  
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_x[09] CLIPPED,sr.shf01
     
      PRINT g_dash
      PRINT g_x[31], 
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41], 
            g_x[42], 
            g_x[43], 
            g_x[44] 
      PRINT g_dash1
 
      LET l_last_sw ='n' 
 
   BEFORE GROUP OF sr.shf01   
      SKIP TO TOP OF PAGE 
 
   BEFORE GROUP OF sr.shf03 
      PRINT COLUMN g_c[31],sr.shf03 CLIPPED;
 
  ON EVERY ROW  
      PRINT COLUMN g_c[32],sr.gen01 CLIPPED,
            COLUMN g_c[33],sr.gen02 CLIPPED,
            COLUMN g_c[34],sr.shg04 CLIPPED,
            COLUMN g_c[35],sr.sgb05 CLIPPED,
            COLUMN g_c[36],sr.shg05 USING '########.&',
            COLUMN g_c[37],sr.shg06,
            COLUMN g_c[38],sr.shg07,
            COLUMN g_c[39],sr.shg08,
            COLUMN g_c[40],sr.ima02  CLIPPED,
            COLUMN g_c[41],sr.ima021 CLIPPED,
            COLUMN g_c[42],sr.shg09 USING '########.#',
            COLUMN g_c[43],sr.shg10,
            COLUMN g_c[44],sr.shg11
  
  AFTER GROUP OF sr.shf03 
      LET l_shg05 = GROUP SUM(sr.shg05) 
      LET l_shg09 = GROUP SUM(sr.shg09) 
      PRINT g_dash2
      PRINT COLUMN g_c[35],g_x[10] CLIPPED,
            COLUMN g_c[36],l_shg05 USING '########.&', 
            COLUMN g_c[42],l_shg09 USING '########.#' 
      PRINT
 
   ON LAST ROW
      LET shg05_tot = SUM(sr.shg05) 
      LET shg09_tot = SUM(sr.shg09)
      PRINT g_dash2
      PRINT COLUMN g_c[35],g_x[11] CLIPPED,
            COLUMN g_c[36],shg05_tot USING '########.&', 
            COLUMN g_c[42],shg09_tot USING '########.#' 
      PRINT g_dash
#     PRINT g_x[4] CLIPPED, COLUMN g_c[43], g_x[7] CLIPPED     #No.TQC-710016
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-710016
      LET l_last_sw = 'y'
 
   PAGE TRAILER
     IF l_last_sw = 'n' THEN 
        PRINT g_dash
#       PRINT g_x[4] CLIPPED, COLUMN g_c[43], g_x[6] CLIPPED     #No.TQC-710016
        PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-710016
     ELSE 
        SKIP 2 LINES
     END IF
END REPORT
