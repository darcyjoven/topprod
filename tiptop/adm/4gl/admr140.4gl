# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: admr140.4gl
# Descriptions...: 應收票據過期未處理警訊
# Date & Author..: 02/04/01 By Wiky
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: No.TQC-610083 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
 
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-8A0024 08/10/09 By Smapmin 改為CR報表格式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,                                 #TQC-630166     
           more    LIKE type_file.chr1                     #No.FUN-680097 VARCHAR(01)
           END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
#-----FUN-8A0024---------
DEFINE l_table     STRING   
DEFINE g_sql       STRING
DEFINE g_str       STRING
#-----END FUN-8A0024-----
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
   #-----FUN-8A0024---------
   LET g_sql = "nmh31.nmh_file.nmh31,",
               "nmh09.nmh_file.nmh09,",
               "nmh24.type_file.chr10,",
               "nmh11.nmh_file.nmh11,",
               "nmh30.nmh_file.nmh30,",
               "nmh16.nmh_file.nmh16,",
               "gen02.gen_file.gen02,",
               "nmh01.nmh_file.nmh01,",
               "nmh03.nmh_file.nmh03,",
               "nmh02.nmh_file.nmh02,",
               "azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('admr140',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #-----END FUN-8A0024-----
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
#-------------No.TQC-610083 modify
  #LET tm.more  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
#-------------No.TQC-610083 end
   IF NOT cl_null(tm.wc) THEN
       CALL r140()
   ELSE
       CALL r140_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r140_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680097 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 13 END IF
   OPEN WINDOW r140_w AT p_row,p_col
        WITH FORM "adm/42f/admr140"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh01,nmh10,nmh05,nmh29
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more
      WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
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
      ON ACTION CONTROLG CALL cl_cmdask()
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
      LET INT_FLAG = 0
      CLOSE WINDOW r140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='admr140'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr140','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('admr140',g_time,l_cmd)
      END IF
      CLOSE WINDOW r140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r140()
   ERROR ""
END WHILE
   CLOSE WINDOW r140_w
END FUNCTION
 
FUNCTION r140()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0100
DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT        #No.FUN-680097 VARCHAR(600)
DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(40)
#DEFINE l_order   ARRAY[5] OF  LIKE apm_file.apm08     #No.FUN-680097 VARCHAR(10) #No.TQC-6A0079
DEFINE sr        RECORD
                     nmh01    LIKE nmh_file.nmh01,    #客訴單號
                     nmh31    LIKE nmh_file.nmh31,    #支票號碼
                     nmh09    LIKE nmh_file.nmh09,    #客訴單號
                     nmh24    LIKE nmh_file.nmh24,    #票況
                     nmh11    LIKE nmh_file.nmh11,    #客戶
                     nmh30    LIKE nmh_file.nmh30,    #客戶名稱
                     nmh16    LIKE nmh_file.nmh16,    #業務員
                     nmh03    LIKE nmh_file.nmh03,    #幣別
                     nmh02    LIKE nmh_file.nmh02     #原幣金額
                 END RECORD
DEFINE l_nmh24   LIKE type_file.chr10   #FUN-8A0024
DEFINE l_gen02   LIKE gen_file.gen02    #FUN-8A0024
 
     CALL cl_del_data(l_table)   #FUN-8A0024
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
     #End:FUN-980030
 
     LET l_sql =
                 " SELECT nmh01,nmh31,nmh09,nmh24,nmh11,nmh30,",
                 "        nmh16,nmh03,nmh02 ",
                 " FROM nmh_file ",
                 " WHERE nmh24 != '8' ",
                 "   AND nmh38 != 'X' ",
                 "   AND nmh05 < '",g_today,"'",   #FUN-8A0024
                 "   AND ", tm.wc CLIPPED
 
     LET l_sql = l_sql CLIPPED,"ORDER BY nmh31"
     PREPARE r140_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
     END IF
     DECLARE r140_curs1 CURSOR FOR r140_prepare1
     #CALL cl_outnam('admr140') RETURNING l_name   #FUN-8A0024
     #START REPORT r140_rep TO l_name   #FUN-8A0024
     LET g_pageno = 0
     FOREACH r140_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          #-----FUN-8A0024---------
          #OUTPUT TO REPORT r140_rep(sr.*) 
          LET l_nmh24 = ''
          LET l_gen02 = ''
          CALL s_nmhsta(sr.nmh24) RETURNING l_nmh24
          SELECT gen02 INTO l_gen02 FROM gen_file
            WHERE gen01=sr.nmh16
          SELECT azi04 INTO t_azi04 FROM azi_file        
           WHERE azi01=sr.nmh03
          EXECUTE insert_prep USING
             sr.nmh31,sr.nmh09,l_nmh24,sr.nmh11,sr.nmh30,
             sr.nmh16,l_gen02,sr.nmh01,sr.nmh03,sr.nmh02,
             t_azi04
          #-----END FUN-8A0024-----
     END FOREACH
     #-----FUN-8A0024---------
     #FINISH REPORT r140_rep   
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  
     CALL cl_wcchp(tm.wc,'nmh01,nmh10,nmh05,nmh29')
          RETURNING g_str
     LET g_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table  CLIPPED
     CALL cl_prt_cs3('admr140','admr140',g_sql,g_str)
     #-----END FUN-8A0024-----
END FUNCTION
 
#-----FUN-8A0024---------
#REPORT r140_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1             #No.FUN-680097 VARCHAR(1)
#DEFINE l_nmh24      LIKE aab_file.aab02             #No.FUN-680097 VARCHAR(06)
#DEFINE l_gen02      LIKE gen_file.gen02     #業務員名稱
#DEFINE sr           RECORD
#                     nmh01    LIKE nmh_file.nmh01,    #客訴單號
#                     nmh31    LIKE nmh_file.nmh31,    #支票號碼
#                     nmh09    LIKE nmh_file.nmh09,    #客訴單號
#                     nmh24    LIKE nmh_file.nmh24,    #票況
#                     nmh11    LIKE nmh_file.nmh11,    #客戶
#                     nmh30    LIKE nmh_file.nmh30,    #客戶名稱
#                     nmh16    LIKE nmh_file.nmh16,    #業務員
#                     nmh03    LIKE nmh_file.nmh03,    #幣別
#                     nmh02    LIKE nmh_file.nmh02     #原幣金額
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.nmh31
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#   ON EVERY ROW
#      SELECT azi04 INTO t_azi04 FROM azi_file               #No.CHI-6A0004
#       WHERE azi01=sr.nmh03
#      LET l_gen02= NULL
#      LET l_nmh24= NULL
#      SELECT gen02 INTO l_gen02 FROM gen_file  #業務人員名稱
#          WHERE gen01=sr.nmh16
#      CALL s_nmhsta(sr.nmh24) RETURNING l_nmh24
#      PRINT COLUMN g_c[31],sr.nmh31 CLIPPED,
#            COLUMN g_c[32],sr.nmh09 CLIPPED,
#            COLUMN g_c[33],l_nmh24 CLIPPED,
#            COLUMN g_c[34],sr.nmh11 CLIPPED,
#            COLUMN g_c[35],sr.nmh30 CLIPPED,
#            COLUMN g_c[36],sr.nmh16 CLIPPED,
#            COLUMN g_c[37],l_gen02 CLIPPED,
#            COLUMN g_c[38],sr.nmh01 CLIPPED,
#            COLUMN g_c[39],sr.nmh03 CLIPPED,
#            COLUMN g_c[40],cl_numfor(sr.nmh02,40,t_azi04) CLIPPED    #No.CHI-6A0004
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN
#         CALL cl_wcchp(tm.wc,'nmh01,nmh05,nmh010,nmh29,nmh31')
#              RETURNING tm.wc
#         PRINT g_dash
#       #-- TQC-630166 begin
#         #     IF tm.wc[001,070] > ' ' THEN            # for 80
#         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#         #     IF tm.wc[071,140] > ' ' THEN
#         #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#         #     IF tm.wc[141,210] > ' ' THEN
#         #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         #     IF tm.wc[211,280] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#       #-- TQC-630166 end
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED,
#            COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED,
#              COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#-----END FUN-8A0024-----
