# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfr721.4gl
# Descriptions...: 品質異常報告表
# Date & Author..: 99/06/28 By Kammy
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕灰色
# Modify.........: No.FUN-7B0138 07/12/11 By Lutingting 轉為用Crystal Report 輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
#              wc      VARCHAR(600),        # Where condition #NO.TQC-630166 MARK
              wc      STRING,
              type    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 確認否
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   l_table         STRING     #No.FUN-7B0138
DEFINE   g_sql           STRING     #No.FUN-7B0138
DEFINE   g_str           STRING     #No.FUN-7B0138
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
#No.FUN-7B0138--start--
   LET g_sql = "shh01.shh_file.shh01,",
               "shh02.shh_file.shh02,",
               "shh03.shh_file.shh03,",
               "sfb05.sfb_file.sfb05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "shh05.shh_file.shh05,",
               "shh06.shh_file.shh06,",
               "shh14.shh_file.shh14"
   LET l_table = cl_prt_temptable('asfr721',g_sql) CLIPPED
   IF L_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM
   END IF
#No.FUN-7B0138--end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.more  = ARG_VAL(8)       #TQC-610080 
   LET tm.type  = ARG_VAL(8)       #TQC-610080
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL asfr721_tm(0,0)        # Input print condition
      ELSE CALL asfr721()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr721_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN
      LET p_row = 5 LET p_col = 12
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW asfr721_w AT p_row,p_col WITH FORM "asf/42f/asfr721"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.type = '3'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shh01,shh02,shh03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
     ON ACTION help                          #No.TQC-770004                                                                                                               
         #CALL cl_dynamic_locale()           #No.TQC-770004                                                                                       
          CALL cl_show_help()                   #No.FUN-550037 hmf #No.TQC-770004                                                             
         LET g_action_choice = "help"          #No.TQC-770004                                                                                          
         continue  CONSTRUCT                  #No.TQC-770004
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfr721_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more      # Condition
   INPUT BY NAME tm.type,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD type
         IF tm.type NOT MATCHES "[123]" OR tm.type IS NULL THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = "Y" THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG
             CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION help                          #No.TQC-770004                                                                         
         #CALL cl_dynamic_locale()           #No.TQC-770004                                                                         
          CALL cl_show_help()                   #No.FUN-550037 hmf #No.TQC-770004                                                   
         LET g_action_choice = "help"          #No.TQC-770004                                                                       
         continue  input                  #No.TQC-770004      
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfr721_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr721'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr721','9031',1)
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
                         " '",tm.type  CLIPPED,"'",             #TQC-610080 
                         #" '",tm.more CLIPPED,"'",             #TQC-610080
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('asfr721',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW asfr721_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr721()
   ERROR ""
END WHILE
CLOSE WINDOW asfr721_w
END FUNCTION
 
FUNCTION asfr721()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,        #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                       shh01  LIKE shh_file.shh01,
                       shh02  LIKE shh_file.shh02,
                       shh03  LIKE shh_file.shh03,
                       sfb05  LIKE sfb_file.sfb05,
                       shh05  LIKE shh_file.shh05,
                       shh06  LIKE shh_file.shh06,
                       shh14  LIKE shh_file.shh14
                    END RECORD
     DEFINE     l_ima02      LIKE ima_file.ima02,   #No.FUN-7B0138
                l_ima021     LIKE ima_file.ima021   #No.FUN-7B0138                       
     CALL cl_del_data(l_table)                      #No.FUN-7B0138
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='asfr721'   #No.FUN-7B0138
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND shhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND shhgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND shhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT shh01, shh02, shh03, sfb05, shh05, shh06 ,shh14 ",
                 "  FROM shh_file, OUTER sfb_file ",
                 " WHERE sfb_file.sfb01 = shh_file.shh03 AND shh14!='X' ",
                 "   AND ",tm.wc CLIPPED
     IF tm.type = '1' THEN LET l_sql = l_sql CLIPPED ," AND shh14='N' " END IF
     IF tm.type = '2' THEN LET l_sql = l_sql CLIPPED ," AND shh14='Y' " END IF
     LET l_sql = l_sql CLIPPED, " ORDER BY shh01 "
     PREPARE asfr721_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
     END IF
     DECLARE asfr721_curs1 CURSOR FOR asfr721_prepare1
 
#     CALL cl_outnam('asfr721') RETURNING l_name  #No.FUN-7B0138
#     START REPORT asfr721_rep TO l_name          #No.FUN-7B0138
#     LET g_pageno = 0                            #No.FUN-7B0138
     FOREACH asfr721_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0  THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
#       OUTPUT TO REPORT asfr721_rep(sr.*)        #No.FUN-7B0138
#NO.FUN-7B0138--START--
      LET l_ima02 = ''
      LET l_ima021= ''
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.sfb05
      EXECUTE insert_prep USING
          sr.shh01,sr.shh02,sr.shh03, sr.sfb05, l_ima02, l_ima021,
          sr.shh05,sr.shh06,sr.shh14
#No.FUN-7B0138--end         
     END FOREACH
#No.FUN-7B0138--start
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'shh01,shh02,shh03')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('asfr721','asfr721',g_sql,g_str)
#     FINISH REPORT asfr721_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7B0138--end
END FUNCTION
 
#No.DUN-7B0138--START--
#REPORT asfr721_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#          exhaust      LIKE bed_file.bed07,          #No.FUN-680121 DEC(12,3)
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          l_sfe06      LIKE sfe_file.sfe06,
#          l_sfe16      LIKE sfe_file.sfe16,
#          sr           RECORD
#                       shh01  LIKE shh_file.shh01,
#                       shh02  LIKE shh_file.shh02,
#                       shh03  LIKE shh_file.shh03,
#                       sfb05  LIKE sfb_file.sfb05,
#                       shh05  LIKE shh_file.shh05,
#                       shh06  LIKE shh_file.shh06,
#                       shh14  LIKE shh_file.shh14
#                       END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.shh01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT ''
#      PRINT g_dash
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39]
#      PRINT g_dash1
 
#   ON EVERY ROW
#      LET l_ima02 = ''
#      LET l_ima021= ''
#      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#       WHERE ima01 = sr.sfb05
#      PRINT COLUMN g_c[31],sr.shh01,
#            COLUMN g_c[32],sr.shh02,
#            COLUMN g_c[33],sr.shh03,
#            COLUMN g_c[34],sr.sfb05,
#            COLUMN g_c[35],l_ima02,
#            COLUMN g_c[36],l_ima021,
#            COLUMN g_c[37],sr.shh05,
#            COLUMN g_c[38],sr.shh06 USING '########',
#            COLUMN g_c[39],sr.shh14
 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'sfh01,sfh04,shh02')
#              RETURNING tm.wc
#         PRINT g_dash
##NO.TQC-6310166 start--
##         IF tm.wc[001,070] > ' ' THEN            # for 80
##              PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##         IF tm.wc[071,140] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##         IF tm.wc[141,210] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##         IF tm.wc[211,280] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#          CALL cl_prt_pos_wc(tm.wc)
##NO.TQC-630166 end**
#      END IF
#      PRINT g_dash
##     PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED     #No.TQC-710016
#      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-710016
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
##        PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED     #No.TQC-710016
#         PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-710016
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-7B0138--end
