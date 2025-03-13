# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: admr141.4gl
# Descriptions...: 應付票據過期未處理警訊
# Date & Author..: 02/04/01 By Wiky
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: No.TQC-610083 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改 
 
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850111 08/05/22 By lala CR
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,                  #TQC-630166   
           more    LIKE type_file.chr1      #No.FUN-680097 VARCHAR(01)
           END RECORD
DEFINE   g_str      STRING      #No.FUN-850111
DEFINE   g_sql      STRING      #No.FUN-850111 
DEFINE   l_table    STRING      #No.FUN-850111 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
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
 
#No.FUN-850111---start---
   LET g_sql="nmd02.nmd_file.nmd02,",
             "nmd05.nmd_file.nmd05,",
             "nmd12.nmd_file.nmd12,",
             "nmd08.nmd_file.nmd08,",
             "nmd24.nmd_file.nmd24,",
             "nmd18.nmd_file.nmd18,",
             "gem02.gem_file.gem02,",
             "nmd01.nmd_file.nmd01,",
             "nmd21.nmd_file.nmd21,",
             "nmd04.nmd_file.nmd04"
 
   LET l_table = cl_prt_temptable('admr141',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850111---end---
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
#---------------No.TQC-610083 modify
  #LET tm.more  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
#---------------No.TQC-610083 end
   IF NOT cl_null(tm.wc) THEN
       CALL r141()
   ELSE
       CALL r141_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r141_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680097 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 13 END IF
   OPEN WINDOW r141_w AT p_row,p_col
        WITH FORM "adm/42f/admr141"
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
   CONSTRUCT BY NAME tm.wc ON nmd01,nmd06,nmd05,nmd20
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
      CLOSE WINDOW r141_w
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
      CLOSE WINDOW r141_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='admr141'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr141','9031',1)
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
         CALL cl_cmdat('admr141',g_time,l_cmd)
      END IF
      CLOSE WINDOW r141_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r141()
   ERROR ""
END WHILE
   CLOSE WINDOW r141_w
END FUNCTION
 
FUNCTION r141()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0100
DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT        #No.FUN-680097 VARCHAR(600)
DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(40)
#DEFINE l_order   ARRAY[5] OF  LIKE apm_file.apm08     #No.FUN-680097 VARCHAR(10) #No.TQC-6A0079
DEFINE l_nmd12      LIKE ade_file.ade04       #No.FUN-850111
DEFINE l_gem02      LIKE gem_file.gem02       #No.FUN-850111
DEFINE sr        RECORD
                     nmd02    LIKE nmd_file.nmd02,    #支票號碼
                     nmd05    LIKE nmd_file.nmd05,    #到期日
                     nmd12    LIKE nmd_file.nmd12,    #票況
                     nmd08    LIKE nmd_file.nmd08,    #廠商
                     nmd24    LIKE nmd_file.nmd24,    #廠商名稱
                     nmd18    LIKE nmd_file.nmd18,    #部門名稱
                     nmd01    LIKE nmd_file.nmd01,    #開票單號
                     nmd21    LIKE nmd_file.nmd21,    #幣別
                     nmd04    LIKE nmd_file.nmd04     #原幣金額
                 END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
     LET l_sql =
                 " SELECT nmd02,nmd05,nmd12,nmd08,nmd24,nmd18,",
                 "        nmd01,nmd21,nmd04 ",
                 " FROM nmd_file ",
                 " WHERE nmd12 != '8' ",
                 "   AND nmd30 != 'X' ",
                 "   AND ", tm.wc CLIPPED
 
     LET l_sql = l_sql CLIPPED,"ORDER BY nmd02"
     PREPARE r141_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
     END IF
     DECLARE r141_curs1 CURSOR FOR r141_prepare1
#No.FUN-850111---start---
#     CALL cl_outnam('admr141') RETURNING l_name
#     START REPORT r141_rep TO l_name
     LET g_pageno = 0
     FOREACH r141_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
#          OUTPUT TO REPORT r141_rep(sr.*)
 
     EXECUTE insert_prep USING
        sr.nmd02,sr.nmd05,l_nmd12,sr.nmd08,sr.nmd24,sr.nmd18,l_gem02,sr.nmd01,sr.nmd21,sr.nmd04
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'nmd01,nmd06,nmd05,nmd20')
             RETURNING tm.wc
     LET g_str=tm.wc
     CALL cl_prt_cs3('admr141','admr141',g_sql,g_str)
#     FINISH REPORT r141_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r141_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1             #No.FUN-680097 VARCHAR(1)
# Prog. Version..: '5.30.06-13.03.12(04)  #TQC-840066
#DEFINE l_gem02      LIKE gem_file.gem02     #部門名稱
#DEFINE sr           RECORD
#                    nmd02    LIKE nmd_file.nmd02,    #支票號碼
#                    nmd05    LIKE nmd_file.nmd05,    #到期日
#                    nmd12    LIKE nmd_file.nmd12,    #票況
#                    nmd08    LIKE nmd_file.nmd08,    #廠商
#                    nmd24    LIKE nmd_file.nmd24,    #廠商名稱
#                    nmd18    LIKE nmd_file.nmd18,    #部門名稱
#                    nmd01    LIKE nmd_file.nmd01,    #開票單號
#                    nmd21    LIKE nmd_file.nmd21,    #幣別
#                    nmd04    LIKE nmd_file.nmd04     #原幣金額
#                   END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.nmd02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED,pageno_total
#     PRINT
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#  ON EVERY ROW
#     SELECT azi04 INTO t_azi04 FROM azi_file           #No.CHI-6A0004
#      WHERE azi01=sr.nmd21
#     LET l_gem02= NULL
#     LET l_nmd12= NULL
#     SELECT gem02 INTO l_gem02 FROM gem_file  #部門名稱
#         WHERE gem01=sr.nmd18
#     IF SQLCA.sqlcode THEN
#         LET l_gem02 = NULL
#     END IF
#     CALL s_nmdsta(sr.nmd12) RETURNING l_nmd12
#     PRINT COLUMN g_c[31],sr.nmd02 CLIPPED,
#           COLUMN g_c[32],sr.nmd05 CLIPPED,
#           COLUMN g_c[33],l_nmd12 CLIPPED,
#           COLUMN g_c[34],sr.nmd08 CLIPPED,
#           COLUMN g_c[35],sr.nmd24 CLIPPED,
#           COLUMN g_c[36],sr.nmd18 CLIPPED,
#           COLUMN g_c[37],l_gem02 CLIPPED,
#           COLUMN g_c[38],sr.nmd01 CLIPPED,
#           COLUMN g_c[39],sr.nmd21 CLIPPED,
#           COLUMN g_c[40],cl_numfor(sr.nmd04,40,t_azi04) CLIPPED  #No.CHI-6A0004
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN
#        CALL cl_wcchp(tm.wc,'nmd01,nmd05,nmd06,nmd20,nmd02')
#             RETURNING tm.wc
#        PRINT g_dash
#      #-- TQC-630166 begin
#        #     IF tm.wc[001,070] > ' ' THEN            # for 80
#        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #     IF tm.wc[071,141] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[071,141] CLIPPED END IF
#        #     IF tm.wc[141,210] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #     IF tm.wc[211,280] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40], g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40], g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850111---end---
