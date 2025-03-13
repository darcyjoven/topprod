# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aapr370.4gl
# Descriptions...: 應付票據/轉帳明細表
# Input parameter:
# Date & Author..: 97/09/17 By Kitty
# Modify.........: No.FUN-4C0097 04/12/31 By Nicola 報表架構修改
#                                                    增加列印銀行名稱pma02
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.MOD-640221 06/04/10 By Smapmin 銀行名稱印不出來
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.MOD-670133 06/07/31 By Smapmin 修改小計問題
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0172 06/12/27 By wujie 調整“接下頁/結束”位置
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.TQC-C30298 12/03/26 By yinhy 報表未顯示收票轉付
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
		#wc  	LIKE type_file.chr1000,	#TQC-630166  #No.FUN-690028 VARCHAR(600)
		wc      STRING,	   #TQC-630166
   		s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),	
   		t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),
   		u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),	
   		a       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),	
   		more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1) 	
              END RECORD,
#         l_orderA      ARRAY[3] OF VARCHAR(8)
          l_orderA      ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)     #No.FUN-550030
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT			
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   LET g_pdate = ARG_VAL(1)	
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
 
   CALL r370_create_tmp()    #no.5197
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapr370_tm(0,0)	
   ELSE
      CALL aapr370()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION aapr370_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd         LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          l_jmp_flag    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW aapr370_w AT p_row,p_col
     WITH FORM "aap/42f/aapr370"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON apf03,apf02,apf01,aph07,aph03
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION locale
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         CLOSE WINDOW aapr370_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
           	
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
           	
      INPUT BY NAME tm.a,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET l_jmp_flag = 'N'
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
            IF INT_FLAG THEN EXIT INPUT END IF
 
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
         CLOSE WINDOW aapr370_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr370'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr370','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr370',g_time,l_cmd)	# Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr370_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr370()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr370_w
 
END FUNCTION
 
FUNCTION aapr370()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time	LIKE type_file.chr8,  		# Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql         STRING,		# RDSQL STATEMENT   #TQC-630166
          l_order	ARRAY[5] OF LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),   # No.FUN-550030
          sr            RECORD order1 LIKE apf_file.apf01,    # No.FUN-690028 VARCHAR(16), # No.FUN-550030
                               order2 LIKE apf_file.apf01,    # No.FUN-690028 VARCHAR(16), # No.FUN-550030
                               order3 LIKE apf_file.apf01,    # No.FUN-690028 VARCHAR(16), # No.FUN-550030
                               apf03  LIKE apf_file.apf03,
                               apf12  LIKE apf_file.apf12,
                               apf02  LIKE apf_file.apf02,
                               apf01  LIKE apf_file.apf01,
                               aph03  LIKE aph_file.aph03,
                               aph03a LIKE zaa_file.zaa08,    # No.FUN-690028 VARCHAR(04),
                               aph07  LIKE aph_file.aph07,
                               aph13  LIKE aph_file.aph13,
                               aph14  LIKE aph_file.aph14,
                               aph05f LIKE aph_file.aph05f,
                               aph05  LIKE aph_file.aph05,
                               aph08  LIKE aph_file.aph08,
                               aph09  LIKE aph_file.aph09,
                               nmd01  LIKE nmd_file.nmd01,
                               aph02  LIKE aph_file.aph02,
                               azi04  LIKE azi_file.azi04,
                               azi05  LIKE azi_file.azi05,
                               azi07  LIKE azi_file.azi07,  #No.FUN-870151
                               nma02  LIKE nma_file.nma02   #MOD-640221
                               #pma02  LIKE pma_file.pma02   #MOD-640221
                        END RECORD
 
   DELETE FROM r370_tmp
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #bugno:5197................................................................
   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r370_tmp WHERE order1 = ? ",
               " GROUP BY curr ORDER BY curr"
   PREPARE r370tmp_pre1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('tmp_pre1:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE r370_tmpcs1 CURSOR FOR r370tmp_pre1
 
   #LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r370_tmp WHERE order2 = ? ",   #MOD-670133
   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r370_tmp WHERE order1 = ? AND order2 = ? ",   #MOD-670133
               " GROUP BY curr ORDER BY curr"
   PREPARE r370tmp_pre2 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('tmp_pre2:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE r370_tmpcs2 CURSOR FOR r370tmp_pre2
 
   #LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r370_tmp WHERE order3 = ? ",   #MOD-670133
   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r370_tmp WHERE order1 = ? AND order2 = ? AND order3 = ? ",   #MOD-670133
               " GROUP BY curr ORDER BY curr"
   PREPARE r370tmp_pre3 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('tmp_pre3:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE r370_tmpcs3 CURSOR FOR r370tmp_pre3
 
   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r370_tmp ",
               " GROUP BY curr ORDER BY curr"
   PREPARE r370tmp_pre4 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('tmp_pre4:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE r370_tmpcs4 CURSOR FOR r370tmp_pre4
   #bug end.................................................................
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apfuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT '','','',",
               "       apf03, apf12, apf02, apf01, aph03, ' ', aph07,",
               "       aph13, aph14, aph05f, aph05, aph08, aph09, '',",
               "       aph02, azi04,azi05,azi07,''",   #No.FUN-870151 add azi07
               "  FROM apf_file,aph_file,  OUTER azi_file",
               " WHERE apf01 = aph01",
               "   AND aph_file.aph13 = azi_file.azi01 ",
             # "   AND apf41 = 'Y' AND aph03 MATCHES '[12]' ",
                #No.5058
               "   AND ",tm.wc
   CASE tm.a
      WHEN '1'
         LET l_sql = l_sql CLIPPED," AND aph09 = 'Y'"
      WHEN '2'
         LET l_sql = l_sql CLIPPED," AND (aph09 IS NULL OR aph09 ='N') "
   END CASE
 
   PREPARE aapr370_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE aapr370_curs1 CURSOR FOR aapr370_prepare1
 
   CALL cl_outnam('aapr370') RETURNING l_name
   START REPORT aapr370_rep TO l_name
 
   LET g_pageno = 0
 
   FOREACH aapr370_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF sr.aph03 = '1' THEN
         LET sr.aph03a = g_x[17]
      END IF
 
      IF sr.aph03 = '2' THEN
         LET sr.aph03a = g_x[18]
      END IF
 
      IF sr.aph03 = 'C' THEN
         LET sr.aph03a = g_x[19]
      END IF

      #No.TQC-C30298  --Begin
      IF sr.aph03 = 'D' THEN
         LET sr.aph03a = g_x[20]
      END IF
      #No.TQC-C30298  --End
 
      SELECT nmd01 INTO sr.nmd01 FROM nmd_file
       WHERE nmd10=sr.apf01 AND nmd101=sr.aph02 AND nmd30 <> 'X'
 
      #-----MOD-640221---------
      #SELECT pma02 INTO sr.pma02 FROM pma_file
      # WHERE pma01 = sr.aph08
      SELECT nma02 INTO sr.nma02 FROM nma_file
       WHERE nma01 = sr.aph08
      #-----END MOD-640221-----
 
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apf03
                                       LET l_orderA[g_i] = g_x[10]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apf02 USING 'yyyymmdd'
                                       LET l_orderA[g_i] = g_x[11]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apf01
                                       LET l_orderA[g_i] = g_x[13]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.aph07 USING 'yyyymmdd'
                                       LET l_orderA[g_i] = g_x[12]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.aph03
                                       LET l_orderA[g_i] = g_x[14]
              OTHERWISE LET l_order[g_i] = '-'
                        LET l_orderA[g_i] = ' '
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
      IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
 
      INSERT INTO r370_tmp VALUES(sr.aph13,sr.aph05f,sr.aph05,
                                  sr.order1,sr.order2,sr.order3)
 
      OUTPUT TO REPORT aapr370_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT aapr370_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
 
END FUNCTION
 
REPORT aapr370_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_curr        LIKE aph_file.aph13,
          sr            RECORD order1 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),           #No.FUN-550030
                               order2 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),           #No.FUN-550030
                               order3 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),           #No.FUN-550030
                               apf03  LIKE apf_file.apf03,
                               apf12  LIKE apf_file.apf12,
                               apf02  LIKE apf_file.apf02,
                               apf01  LIKE apf_file.apf01,
                               aph03  LIKE aph_file.aph03,
                               aph03a LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(04),
                               aph07  LIKE aph_file.aph07,
                               aph13  LIKE aph_file.aph13,
                               aph14  LIKE aph_file.aph14,
                               aph05f LIKE aph_file.aph05f,
                               aph05  LIKE aph_file.aph05,
                               aph08  LIKE aph_file.aph08,
                               aph09  LIKE aph_file.aph09,
                               nmd01  LIKE nmd_file.nmd01,
                               aph02  LIKE aph_file.aph02,
                               azi04  LIKE azi_file.azi04,
                               azi05  LIKE azi_file.azi05,
                               azi07  LIKE azi_file.azi07,  #No.FUN-870151
                               nma02  LIKE nma_file.nma02   #MOD-640221
                               #pma02  LIKE pma_file.pma02   #MOD-640221
                        END RECORD,
	  l_amt		LIKE aph_file.aph05f,
	  l_amt1	LIKE aph_file.aph05
   DEFINE g_head1       STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.apf03
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,l_orderA[1] CLIPPED,
                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44] 
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         IF tm.t[3,3] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.apf03,
               COLUMN g_c[32],sr.apf12,
               COLUMN g_c[33],sr.apf02,
               COLUMN g_c[34],sr.apf01,
               COLUMN g_c[35],sr.aph03a CLIPPED,
               COLUMN g_c[36],sr.aph07,
               COLUMN g_c[37],sr.aph13,
              #COLUMN g_c[38],cl_numfor(sr.aph14,38,g_azi07), #MOD-580211 #No.FUN-870151 mark
               COLUMN g_c[38],cl_numfor(sr.aph14,38,sr.azi07),            #No.FUN-870151               
               COLUMN g_c[39],cl_numfor(sr.aph05f,39,sr.azi04),
               COLUMN g_c[40],cl_numfor(sr.aph05,40,g_azi04),
               COLUMN g_c[41],sr.aph08,
               #COLUMN g_c[42],sr.pma02,   #MOD-640221
               COLUMN g_c[42],sr.nma02,   #MOD-640221
               COLUMN g_c[43],sr.aph09,
               COLUMN g_c[44],sr.nmd01
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            PRINT ' '
            FOREACH r370_tmpcs1 USING sr.order1 INTO l_curr,l_amt,l_amt1
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach1',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               PRINT COLUMN g_c[33],l_curr,
                     COLUMN g_c[34],l_orderA[1],
                     COLUMN g_c[35],g_x[15] CLIPPED,
                     COLUMN g_c[39],cl_numfor(l_amt ,39,g_azi05),
                     COLUMN g_c[40],cl_numfor(l_amt1,40,g_azi05)
            END FOREACH
            PRINT g_dash2[1,g_len]
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT ' '
            #FOREACH r370_tmpcs2 USING sr.order2 INTO l_curr,l_amt,l_amt1   #MOD-670133
            FOREACH r370_tmpcs2 USING sr.order1,sr.order2 INTO l_curr,l_amt,l_amt1   #MOD-670133
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach2',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               PRINT COLUMN g_c[33],l_curr,
                     COLUMN g_c[34],l_orderA[2],
                     COLUMN g_c[35],g_x[15] CLIPPED,
                     COLUMN g_c[39],cl_numfor(l_amt ,39,g_azi05),
                     COLUMN g_c[40],cl_numfor(l_amt1,40,g_azi05)
            END FOREACH
            PRINT g_dash2[1,g_len]
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT ' '
            #FOREACH r370_tmpcs3 USING sr.order3 INTO l_curr,l_amt,l_amt1   #MOD-670133
            FOREACH r370_tmpcs3 USING sr.order1,sr.order2,sr.order3 INTO l_curr,l_amt,l_amt1   #MOD-670133
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach3',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               PRINT COLUMN g_c[33],l_curr,
                     COLUMN g_c[34],l_orderA[3],
                     COLUMN g_c[35],g_x[15] CLIPPED,
                     COLUMN g_c[39],cl_numfor(l_amt ,39,g_azi05),
                     COLUMN g_c[40],cl_numfor(l_amt1,40,g_azi05)
            END FOREACH
            PRINT g_dash2[1,g_len]
         END IF
 
      ON LAST ROW
         FOREACH r370_tmpcs4 INTO l_curr,l_amt,l_amt1
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach3',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            PRINT COLUMN g_c[33],l_curr,
                  COLUMN g_c[35], g_x[16] CLIPPED,
                  COLUMN g_c[39], cl_numfor(l_amt ,39,g_azi05),
                  COLUMN g_c[40], cl_numfor(l_amt1,40,g_azi05)
         END FOREACH
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apf03,apf02,apf01,aph07,aph03') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            #TQC-630166
            #IF tm.wc[001,120] > ' ' THEN			# for 132
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,120] CLIPPED
            #END IF
            #IF tm.wc[121,240] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[121,240] CLIPPED
            #END IF
            #IF tm.wc[241,300] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[241,300] CLIPPED
            #END IF
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[44],g_x[7] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED              #No.TQC-6C0172
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[44],g_x[6] CLIPPED
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED           #No.TQC-6C0172
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
 
FUNCTION r370_create_tmp()    #no.5197
# No.FUN-690028 --start--
   CREATE TEMP TABLE r370_tmp(
       curr      LIKE apa_file.apa13,
       amt1      LIKE type_file.num20_6,
       amt2      LIKE type_file.num20_6,
       order1    LIKE apf_file.apf01,
       order2    LIKE apf_file.apf01,
       order3    LIKE apf_file.apf01)
      
# No.FUN-690028 ---end---
END FUNCTION
