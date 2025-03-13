# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abxr020.4gl
# Descriptions...: 放行單未銷案明細表
# Date & Author..: 96/07/23 By STAR 
# Modify.........: No.FUN-530012 05/03/15 By kim 報表轉XML功能
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By Jackho 本幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6C0152 07/01/08 By xufeng 接下頁和結束上方應是雙橫線
# Modify.........: No.FUN-750093 07/06/11 By zhoufeng 報表輸出改為Crystal Reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990119 09/10/15 By lilingyu CR報表欄位"備注"未帶出相應的值
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc     LIKE type_file.chr1000,  # Where condition          #No.FUN-680062   VARCHAR(1000)
              bdate  LIKE type_file.dat,      #No.FUN-680062   date
              edate  LIKE type_file.dat,      #No.FUN-680062   date
              more   LIKE type_file.chr1      #Input more condition(Y/N) #No.FUN-680062   VARCHAR(1)
              END RECORD,
          g_mount    LIKE type_file.num10     #No.FUN-680062 integer
 
DEFINE   g_i         LIKE type_file.num5      #count/index for any purpose  #No.FUN-680062 smallint
DEFINE   g_sql       STRING                   #No.FUN-750093
DEFINE   l_table     STRING                   #No.FUN-750093
DEFINE   g_str       STRING                   #No.FUN-750093
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
#No.FUN-750093 --start--
   LET g_sql="num10.type_file.num10,bnb01.bnb_file.bnb01,bnb12.bnb_file.bnb12,",
             "bnb02.bnb_file.bnb02,bnb09.bnb_file.bnb09,bnb16.bnb_file.bnb16,bnb15.bnb_file.bnb15"   #TQC-990119 add bnb15
   LET l_table = cl_prt_temptable('abxr020',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
#               " VALUES(?,?,?,?,?,?)"   #TQC-990119
                " VALUES(?,?,?,?,?,?,?)"  #TQC-990119               
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM
   END IF
#No.FUN-750093 --end--
 
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#------------------No.TQC-610081 modify
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------------No.TQC-610081 end
IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr020_tm(4,10)        # Input print condition
      ELSE CALL abxr020()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr020_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062char(1000)
 
   LET p_row = 7 LET p_col = 22
 
   OPEN WINDOW abxr020_w AT p_row,p_col WITH FORM "abx/42f/abxr020" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate = g_today
   LET tm.edate = g_today
LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1' 
WHILE TRUE
   INPUT BY NAME tm.bdate,tm.edate,tm.more 
   WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
 
      AFTER FIELD bdate
           IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF 
 
      AFTER FIELD edate
           IF cl_null(tm.edate) OR tm.edate<tm.bdate 
           THEN NEXT FIELD edate END IF 
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr020_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr020'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr020','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate  CLIPPED,"'",
                         " '",tm.edate  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                         
         CALL cl_cmdat('abxr020',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr020_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr020()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr020_w
END FUNCTION
 
FUNCTION abxr020()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name             #No.FUN-680062 VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT                      #No.FUN-680062 VARCHAR(1000)
          l_oga38   LIKE oga_file.oga38,
          l_oga39   LIKE oga_file.oga39,
          l_chr     LIKE type_file.chr1,    #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-680062 VARCHAR(40)  
          l_order   ARRAY[3] OF LIKE type_file.chr20,                              #No.FUN-680062  VARCHAR(10)
          sr               RECORD  num   LIKE type_file.num10,                     #No.FUN-680062  integer
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb03  LIKE bnb_file.bnb03,
                                  bnb12  LIKE bnb_file.bnb12,
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnb09  LIKE bnb_file.bnb09,
                                  bnb16  LIKE bnb_file.bnb16,
                                  bnb15  LIKE bnb_file.bnb15     #TQC-990119                                   
                        END RECORD
     CALL cl_del_data(l_table)              #No.FUN-750093
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT 0,bnb01,bnb04,bnb03,bnb12, ",
                 "       bnb02,bnb09,bnb16,bnb15 ",     #TQC-990119  add bnb15
                 "  FROM bnb_file ",
                 " WHERE bnb02 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'",
                 "   AND ( bnb13 IS NULL OR bnb13 = '') ",
                 "   AND bnb12 IS NOT NULL "
#No.CHI-6A0004--begin
#     SELECT azi03,azi04,azi05 
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
     PREPARE abxr020_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr020_curs1 CURSOR FOR abxr020_prepare1
 
#      CALL cl_outnam('abxr020') RETURNING l_name      #No.FUN-750093
#
#     START REPORT abxr020_rep TO l_name
#     LET g_pageno = 0
     LET g_mount = 0 
     FOREACH abxr020_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.bnb16) THEN LET sr.bnb16 = ' ' END IF 
      
       LET g_mount = g_mount + 1
       LET sr.num = g_mount
#      OUTPUT TO REPORT abxr020_rep(sr.*)             #No.FUN-750093
       EXECUTE insert_prep USING sr.num,sr.bnb01,sr.bnb12,sr.bnb02,
                                 sr.bnb09,sr.bnb16,sr.bnb15          #TQC-990119 add bnb15
                               
     END FOREACH
 
#     FINISH REPORT abxr020_rep                      #No.FUN-750093 
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     LET g_str = tm.bdate,";",tm.edate
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('abxr020','abxr020',l_sql,g_str)
END FUNCTION
 
REPORT abxr020_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,   #No.FUN-680062 VARCHAR(1)
          sr               RECORD num    LIKE type_file.num10,  #No.FUN-680062 INTEGER
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb03  LIKE bnb_file.bnb03,
                                  bnb12  LIKE bnb_file.bnb12,
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnb09  LIKE bnb_file.bnb09,
                                  bnb16  LIKE bnb_file.bnb16
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bnb01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,':',tm.bdate,' - ',tm.edate
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
         PRINT COLUMN g_c[31],sr.num USING '###&', 
               COLUMN g_c[32],sr.bnb01,
               COLUMN g_c[33],sr.bnb12,
               COLUMN g_c[34],sr.bnb02,
               COLUMN g_c[35],sr.bnb09,
               COLUMN g_c[36],sr.bnb16 
 
   ON LAST ROW
      PRINT g_dash
      PRINT g_x[10] CLIPPED ,'  ',g_mount USING '###&',g_x[11] CLIPPED
     #PRINT g_dash2    #No.TQC-6C0152
      PRINT g_dash     #No.TQC-6C0152
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
          #PRINT g_dash2     #No.TQC-6C0152
           PRINT g_dash      #No.TQC-6C0152
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
 
END REPORT
