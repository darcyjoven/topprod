# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: admr114.4gl
# Descriptions...: 銷售價格警訊表
# Input parameter:
# Date & Author..: 02/08/7 By Kitty
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.MOD-710132 07/01/25 By Smapmin 當售價低於0%時,應不含0%的資料
# Modify.........: No.FUN-750123 07/07/09 By xufeng 在折扣率后加%,并且增加幣別欄位
# Modify.........: No.FUN-850111 08/05/20 By lala  CR
# Modify.........: No.MOD-8A0049 08/10/06 By Smapmin 修正FUN-850111
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為oeauser與oeagrup
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
              wc      STRING,                           # Where Condition  No.TQC-630166 
              bdate   LIKE type_file.dat,              #No.FUN-680097 DATE
              edate   LIKE type_file.dat,              #No.FUN-680097 DATE
              d       LIKE type_file.num5,             #No.FUN-680097 SMALLING
              more    LIKE type_file.chr1              # 特殊列印條件   #No.FUN-680097 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_str      STRING          #No.FUN-850111
DEFINE   g_sql      STRING          #No.FUN-850111
DEFINE   l_table    STRING          #No.FUN-850111
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
#No.FUN-850111---start---
   LET g_sql="oeb04.oeb_file.oeb04,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "azi01.azi_file.azi01,",
             "oeb13.oeb_file.oeb13,",
             "oeb904.oeb_file.oeb904,",
             "oeb904a.oeb_file.oeb904,",
             "aa.ala_file.ala21,",
             "oeb01.oeb_file.oeb01,",
             "oea032.oea_file.oea032,",
             "gen02.gen_file.gen02"
 
   LET l_table = cl_prt_temptable('admr114',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850111---end---
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.d     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r114_tm(0,0)	
      ELSE CALL r114()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r114_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r114_w AT p_row,p_col
        WITH FORM "adm/42f/admr114"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea03,oea14
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
      CLOSE WINDOW r114_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.d,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) OR (tm.bdate>tm.edate) THEN
            NEXT FIELD edate
         END IF
 
      AFTER FIELD d
         IF cl_null(tm.d) THEN
            NEXT FIELD d
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
            NEXT FIELD more
         END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      CLOSE WINDOW r114_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr114'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr114','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('admr114',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r114_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r114()
   ERROR ""
END WHILE
   CLOSE WINDOW r114_w
END FUNCTION
 
FUNCTION r114()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0100
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT                 #No.FUN-680097 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,            #No.FUN-680097 VARCHAR(40)
          l_ima02 LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          sr         RECORD
                     oeb04     LIKE    oeb_file.oeb04,    #
                     oeb13     LIKE    oeb_file.oeb13,    #
                     oeb904    LIKE    oeb_file.oeb904,   #
                     oeb01     LIKE    oeb_file.oeb01,    #
                     oea032    LIKE    oea_file.oea032,   #
                     gen02     LIKE    gen_file.gen02,    #
                     oeb904a   LIKE    oeb_file.oeb904,   #差額
                     aa        LIKE    ala_file.ala21,   #折扣率  #No.FUN-680097 DEC(6,2)
                     azi04     LIKE    azi_file.azi04,
                     azi01     LIKE    azi_file.azi01     #No.FUN-750123
                     END RECORD
 
     CALL cl_del_data(l_table)    #MOD-8A0049
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')  #MOD-A70180 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')  #MOD-A70180
     #End:FUN-980030
 
    #LET l_sql = " SELECT oeb04,oeb13,oeb904,oeb01,oea032,gen02,0,0,azi04",   #No.FUN-750123
     LET l_sql = " SELECT oeb04,oeb13,oeb904,oeb01,oea032,gen02,0,0,azi04,azi01",   #No.FUN-750123
                 " FROM oea_file,oeb_file,azi_file,OUTER gen_file ",
                 " WHERE oea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "  AND  oeaconf='Y' AND oea_file.oea14=gen_file.gen01 AND oea23=azi01",
                 "  AND  oea01=oeb01 AND ",tm.wc CLIPPED
 
     PREPARE r114_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r114_c1 CURSOR FOR r114_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
#No.FUN-850111---start---
#     CALL cl_outnam('admr114') RETURNING l_name
 
#     START REPORT r114_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r114_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #--計算差額及百分比
       IF cl_null(sr.oeb904) THEN LET sr.oeb904=0 END IF
       LET sr.oeb904a=sr.oeb904-sr.oeb13
       LET sr.aa=sr.oeb904a/sr.oeb904*100
   #   IF sr.aa >= tm.d THEN               #超出選項百比較才列印
       IF sr.aa > tm.d AND sr.aa <> 0 THEN    #MOD-710132
#          OUTPUT TO REPORT r114_rep(sr.*)
       END IF   #MOD-710132 取消 mark
     SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
         WHERE ima01=sr.oeb04
     IF SQLCA.sqlcode THEN
         LET l_ima02 = NULL
         LET l_ima021 = NULL
     END IF
     IF sr.aa > tm.d AND sr.aa <> 0 THEN    #MOD-8A0049
        EXECUTE insert_prep USING
           sr.oeb04,l_ima02,l_ima021,sr.azi01,sr.oeb13,sr.oeb904,sr.oeb904a,
           sr.aa,sr.oeb01,sr.oea032,sr.gen02
     END IF   #MOD-8A0049
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'oea03,oea14')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('admr114','admr114',g_sql,g_str)
 
 
#     FINISH REPORT r114_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r114_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
#         l_ima02 LIKE ima_file.ima02,
#         l_ima021 LIKE ima_file.ima021,
#         sr         RECORD
#                    oeb04     LIKE    oeb_file.oeb04,    #
#                    oeb13     LIKE    oeb_file.oeb13,    #
#                    oeb904    LIKE    oeb_file.oeb904,   #
#                    oeb01     LIKE    oeb_file.oeb01,    #
#                    oea032    LIKE    oea_file.oea032,   #
#                    gen02     LIKE    gen_file.gen02,    #
#                    oeb904a   LIKE    oeb_file.oeb904,   #差額
#                    aa        LIKE    ala_file.ala21,   #折扣率  #No.FUN-680097 DEC(6,2)
#                    azi04     LIKE    azi_file.azi04,
#                    azi01     LIKE    azi_file.azi01     #No.FUN-750123
#                    END RECORD
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.oeb04,sr.oeb01
 
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
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41]  #No.FUN-750123
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.oeb04
#     SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#         WHERE ima01=sr.oeb04
#     IF SQLCA.sqlcode THEN
#         LET l_ima02 = NULL
#         LET l_ima021 = NULL
#     END IF
#     PRINT COLUMN g_c[31],sr.oeb04,
#           COLUMN g_c[32],l_ima02,
#           COLUMN g_c[33],l_ima021;
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[41],sr.azi01,  #No.FUN-750123
#           COLUMN g_c[34],cl_numfor(sr.oeb13,34,sr.azi04),
#           COLUMN g_c[35],cl_numfor(sr.oeb904,35,sr.azi04),
#           COLUMN g_c[36],cl_numfor(sr.oeb904a,36,sr.azi04),
#         # COLUMN g_c[37],cl_numfor(sr.aa,37,2),   #No.FUN-740123
#           COLUMN g_c[37],cl_numfor(sr.aa,6,2),"%",   #No.FUN-740123
#           COLUMN g_c[38],sr.oeb01,
#           COLUMN g_c[39],sr.oea032,
#           COLUMN g_c[40],sr.gen02
 
#  ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT g_dash
#             #No.TQC-630166 --start--
#             IF tm.wc[001,80] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#             #No.TQC-630166 ---end---
#     END IF
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850111---end---
