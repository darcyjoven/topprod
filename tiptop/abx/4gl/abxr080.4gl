# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abxr080.4gl
# Descriptions...: 保稅出口帳查核表
# Date & Author..: 96/07/30 By STAR 
# Modify.........: No.FUN-530012 05/03/15 By kim 報表轉XML功能
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-750093 07/05/28 By jan 報表改為使用crystal report(游標在“異動原因”時，按“放棄”應跳離）
# Modify.........: NO.TQC-780054 07/08/17 By sherry  out內有（+）/to_date的語法改為INFOR
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0283 10/12/01 By huangtao 拿掉cast
# Modify.........: NO:MOD-B30648 11/03/24 By sabrina 抓出口資料時要多串bxr_file，bxr11<'0'
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition    #No.FUN-680062   VARCHAR(1000)
              bdate   LIKE type_file.dat,                            #No.FUN-680062   date
              edate   LIKE type_file.dat,                            #No.FUN-680062   date    
              more    LIKE  type_file.chr1           # Input more condition(Y/N)   #No.FUN-680062   VARCHAR(1)
              END RECORD,
          
          g_bxr02       LIKE bxr_file.bxr02
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   g_str           STRING                  #No.FUN-750093
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr080_tm(4,15)        # Input print condition
      ELSE CALL abxr080()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr080_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,       #No.FUN-680062 smallint
          l_bxi08      LIKE type_file.chr20,        #No.FUN-680062 VARCHAR(20)  
          l_cmd        LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW abxr080_w AT p_row,p_col
        WITH FORM "abx/42f/abxr080" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
#  LET l_bxi08='C1:C3'                #MOD-B30648 mark
   LET l_bxi08='*'                    #MOD-B30648
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
      CONSTRUCT tm.wc ON bxi08 FROM a
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   BEFORE CONSTRUCT
      DISPLAY l_bxi08 TO a
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr080_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
#No.FUN-750093--Begin
       IF INT_FLAG THEN                                                             
          LET INT_FLAG = 0 CLOSE WINDOW abxr080_w                                   
          CALL cl_used(g_prog,g_time,2) RETURNING g_time              
          EXIT PROGRAM                                                              
                                                                                
       END IF
#No.FUN-750093--End
   INPUT BY NAME tm.bdate,tm.edate,tm.more 
   WITHOUT DEFAULTS 
   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
           IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF 
          
      AFTER FIELD edate
           IF cl_null(tm.edate) OR tm.edate < tm.bdate
           THEN NEXT FIELD edate END IF 
          
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr080_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr080'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr080','9031',1)
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
                         " '",tm.bdate   CLIPPED,"'",
                         " '",tm.edate   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                        
         CALL cl_cmdat('abxr080',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr080_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr080()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr080_w
END FUNCTION
 
FUNCTION abxr080()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680062  VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680062 VARCHAR(1000)
          l_oga38   LIKE oga_file.oga38,
          l_oga39   LIKE oga_file.oga39,
          l_chr     LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680062 VARCHAR(40) 
          sr               RECORD 
                                  bxi02  LIKE bxi_file.bxi02,
                                  bxi01  LIKE bxi_file.bxi01,
                                  bxj11  LIKE bxj_file.bxj11,
                                  bxj17  LIKE bxj_file.bxj17,
                                  bxj04  LIKE bxj_file.bxj04,
                                  bxj06  LIKE bxj_file.bxj06,
                                  ima02  LIKE ima_file.ima02,    #No.FUN_750093
                                  ima021 LIKE ima_file.ima021    #No.FUN-750093
                        END RECORD
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-750093--Begin
#     LET l_sql = "SELECT bxi02,bxi01,bxj11,bxj17,bxj04,bxj06 ",                                                                     
#                 "  FROM bxi_file, bxj_file  ",                                                                                     
#                 " WHERE bxi02 BETWEEN '",tm.bdate,"'",                                                                             
#                 "   AND '",tm.edate,"'",                                                                                           
#                 "   AND bxi01 = bxj01 ",                                                                                           
#                 "   AND ( bxj11 IS NOT NULL ",                                                                                     
#                 "   AND bxj11 != ' ')  ",                                                                                          
#                 "   AND ",tm.wc CLIPPED
#No.FUN-750093--End
 
#No.FUN-750093--Begin
     LET l_sql = "SELECT bxi02,bxi01,bxj11,bxj17,bxj04,bxj06,ima02,ima021 ",
                 #No.TQC-780054---Begin
                 #"  FROM bxi_file, bxj_file,ima_file  ",       
                 "  FROM bxi_file, bxr_file,bxj_file LEFT OUTER JOIN ima_file  ",   #MOD-B30648 add bxr_file
                 "    ON bxj04 = ima01 ",
                 #" WHERE bxi02 BETWEEN to_date('",tm.bdate,"','yy/mm/dd') ", 
                 #"   AND to_date('",tm.edate,"','yy/mm/dd')",
       #          " WHERE bxi02 BETWEEN CAST('",tm.bdate,"' AS DATETIME) AND CAST('",tm.edate,"' AS DATETIME)",    #TQC-AB0283  mark
                 " WHERE bxi02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",                                          #TQC-AB0283
                 #No.TQC-780054---End
                 "   AND bxi01 = bxj01 ",
                 "   AND bxr01 = bxj21 ",       #MOD-B30648 add
                 "   AND bxr11 < '0' ",         #MOD-B30648 add
                 "   AND ( bxj11 IS NOT NULL ",
                 "   AND bxj11 != ' ')  ",
                 "   AND ",tm.wc CLIPPED
           LET g_str = ''
           LET g_str = tm.bdate,';',tm.edate,';',tm.wc
           CALL cl_prt_cs1('abxr080','abxr080',l_sql,g_str)
#No.FUN-750093--End
 
#No.FUN-750093--begin
#     PREPARE abxr080_prepare1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
#        EXIT PROGRAM 
           
#     END IF
#     DECLARE abxr080_curs1 CURSOR FOR abxr080_prepare1
 
#      CALL cl_outnam('abxr080') RETURNING l_name
 
#     START REPORT abxr080_rep TO l_name
#     LET g_pageno = 0
#     FOREACH abxr080_curs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN 
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH 
#       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
#       IF cl_null(sr.bxj06) THEN LET sr.bxj06 = 0 END IF 
 
#       OUTPUT TO REPORT abxr080_rep(sr.*)
#     END FOREACH
 
#     FINISH REPORT abxr080_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093--end
END FUNCTION
#No.FUN-750093--begin
{
REPORT abxr080_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,             #No.FUN-680062   VARCHAR(1)
#         l_no SMALLINT, #報單張數
          l_ima02 LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          sr               RECORD 
                                  bxi02  LIKE bxi_file.bxi02,
                                  bxi01  LIKE bxi_file.bxi01,
                                  bxj11  LIKE bxj_file.bxj11,
                                  bxj17  LIKE bxj_file.bxj17,
                                  bxj04  LIKE bxj_file.bxj04,
                                  bxj06  LIKE bxj_file.bxj06
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bxj11
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.bdate,' - ',tm.edate
      PRINT g_x[10] CLIPPED,tm.wc CLIPPED
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
          WHERE ima01=sr.bxj04
      IF SQLCA.sqlcode THEN 
          LET l_ima02 = NULL 
          LET l_ima021 = NULL 
      END IF
 
      PRINT COLUMN g_c[31],sr.bxi02,
            COLUMN g_c[32],sr.bxi01,
            COLUMN g_c[33],sr.bxj11,
            COLUMN g_c[34],sr.bxj17,
            COLUMN g_c[35],sr.bxj04,
            COLUMN g_c[36],l_ima02,
            COLUMN g_c[37],l_ima021,
            COLUMN g_c[38],cl_numfor(sr.bxj06,38,0)
                                           
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
 
END REPORT}
#No.FUN-750093--end
