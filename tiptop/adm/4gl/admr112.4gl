# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: admr112.4gl
# Descriptions...: 客戶營業額相對降低警訊
# Input parameter:
# Date & Author..: 02/07/31 By Kitty
# Modify.........: No.MOD-530210 05/03/23 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-580110 05/08/25 By jackie 報表轉XML格式
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0116 06/11/08 By king 改正報表中有關錯誤
# Modify.........: No.FUN-750138 08/01/23 By jamie 在報表中，將幣別加在客戶名稱之後。
# Modify.........: No.FUN-850111 08/05/19 By lala CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0124 09/10/19 By mike 第402行的LET sr.oma56a=sr.oma56a*-1改  LET l_oma56a=l_oma56a*-1                   
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為omauser與omagrup

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
              wc     STRING,                            # Where Condition No.TQC-630166   
              bdate  LIKE type_file.dat,               #No.FUN-680097 DATE
              edate  LIKE type_file.dat,               #No.FUN-680097 DATE
              bdate2  LIKE type_file.dat,              #No.FUN-680097 DATE
              edate2  LIKE type_file.dat,              #No.FUN-680097 DATE
              a      LIKE type_file.chr1,              # Prog. Version..: '5.30.06-13.03.12(01)             #
              b      LIKE type_file.num5,              #No.FUN-680097 SMALLING             #
              more   LIKE type_file.chr1              # 特殊列印條件     #No.FUN-680097 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_str      STRING              #No.FUN-850111
DEFINE   g_sql      STRING              #No.FUN-850111
DEFINE   l_table    STRING              #No.FUN-850111
 
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
   LET g_sql="oma032.oma_file.oma032,",
             "oma23.oma_file.oma23,",
             "oma56a.oma_file.oma56,",
             "oma56b.oma_file.oma56,",
             "oma56c.oma_file.oma56,",
             "aa.sma_file.sma13"
 
   LET l_table = cl_prt_temptable('admr112',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?,?)"
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
   LET tm.bdate2= ARG_VAL(10)
   LET tm.edate2= ARG_VAL(11)
   LET tm.a     = ARG_VAL(12)
   LET tm.b     = ARG_VAL(13)
   CALL r112_tmp()
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r112_tm(0,0)	
      ELSE CALL r112()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r112_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r112_w AT p_row,p_col
        WITH FORM "adm/42f/admr112"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a      = '1'
   LET tm.b      = 0
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON oma03,oma14,oma15
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
      CLOSE WINDOW r112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.bdate2,tm.edate2,tm.a,tm.b,tm.more WITHOUT DEFAULTS
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
 
      AFTER FIELD bdate2
         IF cl_null(tm.bdate2) THEN
            NEXT FIELD bdate2
         END IF
 
      AFTER FIELD edate2
         IF cl_null(tm.edate2) OR (tm.bdate2>tm.edate2) THEN
            NEXT FIELD edate2
         END IF
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN
            NEXT FIELD b
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
      CLOSE WINDOW r112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr112'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr112','9031',1)
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
                         " '",tm.bdate2 CLIPPED,"'",
                         " '",tm.edate2 CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'"
         CALL cl_cmdat('admr112',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r112()
   ERROR ""
END WHILE
   CLOSE WINDOW r112_w
END FUNCTION
 
FUNCTION r112()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0100
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680097 VARCHAR(1000)
          l_sql1     LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680097 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          l_oma00     LIKE    oma_file.oma00,    #性質
          l_oma03     LIKE    oma_file.oma03,    #客戶編號
          l_oma032    LIKE    oma_file.oma032,   #客戶簡稱
          l_oma56a    LIKE    oma_file.oma56,    #基準金額1
          l_oma23     LIKE    oma_file.oma23,    #幣別 #FUN-750138 add 
          sr         RECORD
                     oma03     LIKE    oma_file.oma03,    #客戶編號
                     oma032    LIKE    oma_file.oma032,   #客戶簡稱
                     oma56a    LIKE    oma_file.oma56,    #基準金額1
                     oma56b    LIKE    oma_file.oma56,    #基準金額2
                     oma56c    LIKE    oma_file.oma56,    #差異金額
                     aa        LIKE    sma_file.sma13,    #降幅     #No.FUN-680097 DEC(5,2) 
                     oma23     LIKE    oma_file.oma23     #幣別     #FUN-750138 add 
                     END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')  #MOD-A70180
     #End:FUN-980030
 
     DELETE FROM admr112_tmp
     #--取基準區間金額
     IF tm.a='1' THEN
        LET l_sql = " SELECT oma00,oma03,oma032,SUM(oma56),oma23 ",    #依帳款  #FUN-750138 add oma23
                    " FROM oma_file",
                    " WHERE (oma00 ='11' OR oma00='12' OR oma00='13' OR oma00='21')",
                    "  AND  oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                    "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED,
                    "  GROUP BY oma00,oma03,oma032,oma23 "   #FUN-750138 add oma23
     ELSE
        LET l_sql = " SELECT oma00,oma03,oma032,SUM(oma59),oma23 ",    #依發票  #FUN-750138 add oma23
                    " FROM oma_file",
                    " WHERE (oma00 ='11' OR oma00='12' OR oma00='13' OR oma00='21')",
                    "  AND  oma09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                    "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED,
                    "  GROUP BY oma00,oma03,oma032,oma23 "   #FUN-750138 add oma23 
     END IF
 
 
     PREPARE r112_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r112_c1 CURSOR FOR r112_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
#No.FUN-850111---start---
#     CALL cl_outnam('admr112') RETURNING l_name
 
#     START REPORT r112_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r112_c1 INTO l_oma00,l_oma03,l_oma032,l_oma56a,l_oma23   #FUN-750138 add l_oma23
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF l_oma00='21' THEN
          LET l_oma56a=l_oma56a*-1
       END IF
       INSERT INTO admr112_tmp VALUES (l_oma03,l_oma032,l_oma56a,0,l_oma23)  #FUN-750138 add l_oma23
     END FOREACH
 
     #--取比較區間金額
     IF tm.a='1' THEN
        LET l_sql1= " SELECT oma00,oma03,oma032,SUM(oma56),oma23 ",    #依帳款   #FUN-750138 add oma23
                    " FROM oma_file",
                    " WHERE (oma00='11' OR oma00='12' OR oma00='13' OR oma00 ='21') ",
                    "  AND  oma02 BETWEEN '",tm.bdate2,"' AND '",tm.edate2,"'",
                    "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED,
                    "  GROUP BY oma00,oma03,oma032,oma23 "   #FUN-750138 add oma23 
     ELSE
        LET l_sql1= " SELECT oma00,oma03,oma032,SUM(oma59),oma23 ",    #依發票   #FUN-750138 add oma23
                    " FROM oma_file",
                    " WHERE (oma00='11' OR oma00='12' OR oma00='13' OR oma00 ='21') ",
                    "  AND  oma09 BETWEEN '",tm.bdate2,"' AND '",tm.edate2,"'",
                    "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED ,
                    "  GROUP BY oma00,oma03,oma032,oma23 "   #FUN-750138 add oma23 
     END IF
 
 
     PREPARE r112_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r112_c2 CURSOR FOR r112_p2
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     FOREACH r112_c2 INTO l_oma00,l_oma03,l_oma032,l_oma56a,l_oma23   #FUN-750138 add l_oma23
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach2:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF l_oma00='21' THEN
         #LET sr.oma56a=sr.oma56a*-1 #MOD-9A0124                                                                                    
          LET l_oma56a=l_oma56a*-1   #MOD-9A0124  
       END IF
       INSERT INTO admr112_tmp VALUES (l_oma03,l_oma032,0,l_oma56a,l_oma23)  #FUN-750138 add l_oma23
     END FOREACH
 
     #--將暫存檔的資料依需求丟到sr列印
     DECLARE r112_temp CURSOR FOR
      SELECT tmp_oma03,tmp_oma032,SUM(tmp_oma56a),SUM(tmp_oma56b),0,0,tmp_oma23 FROM admr112_tmp   #FUN-750138 add tmp_oma23
       GROUP BY tmp_oma03,tmp_oma032,tmp_oma23   #FUN-750138 add tmp_oma23
     FOREACH r112_temp INTO sr.*
       IF STATUS THEN CALL cl_err('foreach temp',STATUS,0) EXIT FOREACH END IF
       LET sr.oma56c=sr.oma56a-sr.oma56b
       IF sr.oma56c > 0 THEN            #有降低才列印
          LET sr.aa=sr.oma56c/sr.oma56a*100
          IF sr.aa > tm.b THEN            #降低幅度大於選項幅度才列印
#             OUTPUT TO REPORT r112_rep(sr.*)
          END IF
       END IF
     EXECUTE insert_prep USING
        sr.oma032,sr.oma23,sr.oma56a,sr.oma56b,sr.oma56c,sr.aa
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'oma03,oma14,oma15')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.bdate,";",tm.edate,";",tm.bdate2,";",tm.edate2
     CALL cl_prt_cs3('admr112','admr112',g_sql,g_str)
 
 
#     FINISH REPORT r112_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r112_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
#         sr         RECORD
#                    oma03     LIKE    oma_file.oma03,    #客戶編號
#                    oma032    LIKE    oma_file.oma032,   #客戶簡稱
#                    oma56a    LIKE    oma_file.oma56,    #基準金額1
#                    oma56b    LIKE    oma_file.oma56,    #基準金額2
#                    oma56c    LIKE    oma_file.oma56,    #差異金額
#                    aa        LIKE    sma_file.sma13,    #降幅    #No.FUN-680097 DEC(5,2)
#                    oma23     LIKE    oma_file.oma23     #幣別    #FUN-750138 add
#                    END RECORD
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.aa DESC,sr.oma03
 
# FORMAT
#  PAGE HEADER
#No.FUN-580110 --start--
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT g_dash[1,g_len]
#     LET g_x[16]=tm.bdate,'-',tm.edate
#     LET g_x[17]=tm.bdate2,'-',tm.edate2
#     PRINT COLUMN r112_getStartPos(32,32,g_x[16]),g_x[16],
#           COLUMN r112_getStartPos(33,33,g_x[17]),g_x[17]
#     PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
#           COLUMN g_c[33],g_dash2[1,g_w[33]]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]  #FUN-750138 add g_x[36]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     PRINT
#           COLUMN g_c[31], sr.oma032 CLIPPED,
#           COLUMN g_c[36], sr.oma23  CLIPPED,               #幣別 #FUN-750138 add
#           COLUMN g_c[32],cl_numfor(sr.oma56a,32,t_azi04),  #金額
#           COLUMN g_c[33],cl_numfor(sr.oma56b,33,t_azi04),  #金額
#           COLUMN g_c[34],cl_numfor(sr.oma56c,34,t_azi04),  #金額
#           COLUMN g_c[35],sr.aa USING '####.##%'
 
#  ON LAST ROW
#   #  PRINT COLUMN 14,g_x[16],COLUMN 56,g_x[17] CLIPPED
#     PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
#           COLUMN g_c[33],g_dash2[1,g_w[33]],
#           COLUMN g_c[34],g_dash2[1,g_w[34]]
#     PRINT
#           COLUMN g_c[31], g_x[15] CLIPPED,
#           COLUMN g_c[32],cl_numfor(SUM(sr.oma56a),32,t_azi04),  #金額
#           COLUMN g_c[33],cl_numfor(SUM(sr.oma56b),33,t_azi04),  #金額
#           COLUMN g_c[34],cl_numfor(SUM(sr.oma56c),34,t_azi04)   #金額
#No.FUN-580110 --end--
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT g_dash[1,g_len]
#             #No.TQC-630166 --start--
#             IF tm.wc[001,80] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#             #No.TQC-630166 ---end---
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
# #   PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-7), g_x[7] CLIPPED #No.TQC-6A0116
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-6A0116
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED   
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850111---end---
FUNCTION r112_tmp()
#No.FUN-680097-BEGIN
  CREATE TEMP TABLE admr112_tmp(
    tmp_oma03     LIKE oma_file.oma03,
    tmp_oma032    LIKE oma_file.oma032,
     tmp_oma56a   LIKE type_file.num20_6,
     tmp_oma56b   LIKE type_file.num20_6,
     tmp_oma23    LIKE oma_file.oma23)      #FUN-750138 add 
#No.FUN-680097-END   
 
END FUNCTION
 
FUNCTION r112_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680097 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
 
#Patch....NO.TQC-610035 <> #
