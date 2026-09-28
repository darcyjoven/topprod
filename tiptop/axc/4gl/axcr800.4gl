# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcr800.4gl
# Descriptions...: 在製工單盤盈虧計算表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/08 By Alinna
# Modify.........: No.FUN-4C0099 05/01/27 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 07/01/03 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-7C0101 08/01/25 By Zhangyajun 成本改善增加成本計算類型字段(type)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/23 By lilingyu 平行工藝
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
           #   wc       VARCHAR(300),       # Where condition
              wc       STRING,      #TQC-630166   # Where condition
              choice   LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              user     LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              c        LIKE type_file.chr4,           #No.FUN-680122CHAR(04)
              d        LIKE type_file.chr2,           #No.FUN-680122CHAR(02)
              type     LIKE type_file.chr1,           #No.FUN-7C0101CHAR(1)
              more     LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)        # Input more condition(Y/N)
              END RECORD,
          g_str     LIKE type_file.chr1000        #No.FUN-680122CHAR(40)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680122CHAR(72)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.c     = ARG_VAL(8)
   LET tm.d     = ARG_VAL(9)
   LET tm.choice= ARG_VAL(10)
   LET tm.user  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.type    = ARG_VAL(15)   #No.FUN-7C0101 add
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r833_tm(0,0)        # Input print condition
      ELSE CALL r833()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r833_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-680122 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r833_w AT p_row,p_col
        WITH FORM "axc/42f/axcr800" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LEt g_msg = g_today
   LET tm.choice= '1'
   LET tm.user  = '1'
   LET tm.type = g_ccz.ccz28      #No.FUN-7C0101 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON pid02,pid03,pid01
##
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
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.c,tm.d,tm.choice,tm.user,tm.type,tm.more  #No.FUN-7C0101 add tm.type
                    WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD d
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.d) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
               WHERE azm01 = tm.c
            IF g_azm.azm02 = 1 THEN
               IF tm.d > 12 OR tm.d < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD d
               END IF
            ELSE
               IF tm.d > 13 OR tm.d < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD d
               END IF
            END IF
         END IF
#         IF tm.d > 12 OR tm.d < 1 THEN
##No.MOD-580322--begin                                                                                                              
##           ERROR '月份輸入錯誤,請重新輸入!!'                                                                                      
#            CALL cl_err('','axc-199','1')                                                                                           
##No.MOD-580322--end           
#            NEXT FIELD d
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD choice
         IF tm.choice IS NULL OR tm.choice NOT MATCHES'[12]'
         THEN NEXT FIELD choice
         END IF
 
      AFTER FIELD user  
         IF tm.user   IS NULL OR tm.user   NOT MATCHES'[12]'
         THEN NEXT FIELD user  
         END IF
      #No.FUN-7C0101--start--
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      #No.FUN-7C0101---end---
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
      LET INT_FLAG = 0 CLOSE WINDOW r833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr800'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr800','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.user   CLIPPED,"'",
                         " '",tm.type   CLIPPED,"'",            #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr800',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r833_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r833()
   ERROR ""
END WHILE
   CLOSE WINDOW r833_w
END FUNCTION
 
FUNCTION r833()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE type_file.chr1000,       #No.FUN-680122CHAR(30)
          sr               RECORD 
                           pid01   LIKE pid_file.pid01,   #標籤號碼
                           pid02   LIKE pid_file.pid02,   #料件編號
                           pid03   LIKE pid_file.pid03,   #生產料號
                           pie02   LIKE pie_file.pie02,   #盤點料號
                           pie04   LIKE pie_file.pie04,   #發料單位
                           pie07   LIKE pie_file.pie07,   #項次
                           pie153  LIKE pie_file.pie153, #帳列數
                           pie50   LIKE pie_file.pie50,   #盤點數量
                           ima02   LIKE ima_file.ima02,   #品名規格
                           ccc23   LIKE ccc_file.ccc23,   #單位成本
                           diff    LIKE pid_file.pid13,        #No.FUN-680122DECIMAL(9,3)          #差異
                           amt     LIKE pie_file.pie50,         #No.FUN-680122DECIMAL(12,5)
                           ccc08   LIKE ccc_file.ccc08    #No.FUN-7C0101     
                          ,pid012  LIKE pid_file.pid012   #FUN-A60092
                          ,pid021  LIKE pid_file.pid021   #FUN-A60092
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT pid01, pid02, pid03, pie02,pie04,pie07,pie153,pie50,",
                 "       ima02, ccc23,0,0,ccc08,pid012,pid021",   #No.FUN-7C0101 add ccc08
                                          #FUN-A60092 add pid012,pid021
                 "  FROM pid_file,pie_file,",
                 "  OUTER ima_file, OUTER ccc_file",
                 " WHERE pid01=pie01  ",
                 "   AND pid_file.pid03= ima_file.ima01 ",
                 "   AND pid02 IS NOT NULL ",
                 "   AND ccc_file.ccc01 = pie_file.pie02",
                 "   AND ccc_file.ccc02 = '",tm.c,"'",
                 "   AND ccc_file.ccc03 = '",tm.d,"'",
         #       "   AND pie16 = 'Y' ",
                 "   AND ccc07 = '",tm.type,"'",        #No.FUN-7C0101 add
                 "   AND ",tm.wc
     CASE tm.choice    
           WHEN  '1'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped," AND pie30 >=0 "
                      ELSE LET l_sql =l_sql clipped,"AND pie50 >=0 "
                      END IF
           WHEN  '2'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped,"AND pie40 >=0 "
                      ELSE LET l_sql =l_sql clipped,"AND pie60 >=0 "
                      END IF
     END CASE
     PREPARE r833_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r833_curs1 CURSOR FOR r833_prepare1
 
#    LET l_name = 'axcr800.out'
     CALL cl_outnam('axcr800') RETURNING l_name
     
      #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[34].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[34].zaa06='N'
     END IF
     #No.FUN-7C0101---end---
     
     START REPORT r833_rep TO l_name
     IF tm.choice = '1' 
     THEN LET g_str = g_x[15] clipped
     ELSE LET g_str = g_x[16] clipped
     END IF
     LET g_pageno = 0
     FOREACH r833_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF sr.ccc23 IS NULL THEN
          LET sr.ccc23 = 0
       END IF
       LET sr.diff = sr.pie50 - sr.pie153
       LET sr.amt  = sr.pie50 * sr.ccc23

#FUN-A60092 --begin--
      IF g_sma.sma541 = 'Y' THEN
         LET g_zaa[41].zaa06 = 'N'
         LET g_zaa[42].zaa06 = 'N'
      ELSE
         LET g_zaa[41].zaa06 = 'Y'
         LET g_zaa[42].zaa06 = 'Y'         
      END IF 
#FUN-A60092 --end--
       
       OUTPUT TO REPORT r833_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r833_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r833_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
          sr               RECORD 
                           pid01 LIKE pid_file.pid01,   #標籤號碼
                           pid02 LIKE pid_file.pid02,   #料件編號
                           pid03 LIKE pid_file.pid03,   #生產料號
                           pie02 LIKE pie_file.pie02,   #盤點料號
                           pie04 LIKE pie_file.pie04,   #發料單位
                           pie07 LIKE pie_file.pie07,   #項次
                           pie153 LIKE pie_file.pie153, #代買量
                           pie50 LIKE pie_file.pie50,   
                           ima02 LIKE ima_file.ima02,   #品名規格
                           ccc23 LIKE ccc_file.ccc23,
                           diff  LIKE pid_file.pid13,        #No.FUN-680122DECIMAL(9,3)
                           amt   LIKE pie_file.pie50,        #No.FUN-680122DECIMAL(12,5)
                           ccc08 LIKE ccc_file.ccc08    #No.FUN-7C0101
                          ,pid012 LIKE pid_file.pid012   #FUN-A60092
                          ,pid021 LIKE pid_file.pid021   #FUN-A60092 
                        END RECORD,
      l_sw         LIKE type_file.num5,          #No.FUN-680122SMALLINT
      l_diff       LIKE pid_file.pid13,
      l_pair       LIKE pid_file.pid04,
      l_uninv      LIKE pie_file.pie11,
      l_actuse     LIKE pie_file.pie11,
      l_ima02      LIKE ima_file.ima02,
      l_ima021     LIKE ima_file.ima021,
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 ORDER BY sr.pid02,sr.pid01,sr.pie07,sr.pie02
 # ORDER BY sr.pid01,sr.pid02,sr.pie07,sr.pie02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT 
      PRINT g_dash
      PRINT column  3,g_x[9] CLIPPED,sr.pid02,
            column 36,g_x[10] CLIPPED,sr.pid01
      PRINT column  3,g_x[11] CLIPPED,sr.pid03
      PRINT column 12,sr.ima02
      PRINT ' '
      PRINTX name=H1 g_x[31],g_x[32],
                     g_x[41],            #FUN-A60092 add 
                     g_x[33],g_x[34],g_x[35],g_x[36]
      PRINTX name=H2 g_x[37],g_x[38],g_x[39],
                     g_x[42],            #FUN-A60092 add
                     g_x[40]                   #No.FUN-7C0101 add g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pid02 
      IF (PAGENO > 1 OR LINENO > 17)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.pid01
       SKIP TO TOP OF PAGE
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.pie02
      PRINTX name=D1 COLUMN g_c[31],sr.pie07 using '###&',
                     COLUMN g_c[32],sr.pie02,
                     COLUMN g_c[41],sr.pid012,   #FUN-A60092 add
                     COLUMN g_c[33],sr.pie04,
                     COLUMN g_c[34],cl_numfor(sr.pie50,34,g_ccz.ccz27),      #應發數量 #CHI-690007 3->ccz27
                     COLUMN g_c[35],sr.ccc08,
#                    COLUMN g_c[36],cl_numfor(sr.ccc23,35,g_azi03),    #FUN-A60092 mark
                     COLUMN g_c[36],cl_numfor(sr.ccc23,36,g_ccz.ccz26),    #FUN-A60092 #CHI-C30012 g_azi03->g_ccz.ccz26
#                    COLUMN g_c[37],cl_numfor(sr.amt,36,g_azi03)       #FUN-570190  #FUN-A60092 mark
                     COLUMN g_c[37],cl_numfor(sr.amt,37,g_ccz.ccz26)       #FUN-A60092 #CHI-C30012 g_azi03->g_ccz.ccz26                 
      PRINTX name=D2 COLUMN g_c[38],' ',
                     COLUMN g_c[39],l_ima02,
                     COLUMN g_c[42],sr.pid021,   #FUN-A60092 add
                     COLUMN g_c[40],l_ima021
    AFTER GROUP OF sr.pid02
      PRINT COLUMN g_c[35],g_x[12],
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt),36,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'pid03,pid04,pid05,pid02,pid01')
              RETURNING tm.wc
   #          IF tm.wc[001,070] > ' ' THEN            # for 80
   #     PRINT g_dash
   #    PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
   #         IF tm.wc[071,140] > ' ' THEN
   #     PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
   #         IF tm.wc[141,210] > ' ' THEN
   #     PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
   #         IF tm.wc[211,280] > ' ' THEN
   #     PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
