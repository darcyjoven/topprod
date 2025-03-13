# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapr721.4gl
# Descriptions...: 開狀到單應還款統計表列印
# Date & Author..: 93/02/05  By  Felicity  Tseng
# Modify         : No.MOD-530780 05/03/28 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-550030 05/05/20 By Will 單據編號放大
# Modify.........: No.FUN-580010 05/08/02 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/14 By xumin 欄位對齊調整
# Modify.........: No.FUN-760006 08/07/01 By jamie 報表增加"信貸可用餘額"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970008 10/06/13 By Carrier 正常打印后不退出程序
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              s       LIKE type_file.chr3,         # No.FUN-690028 VARCHAR(3),         # Order by sequence
              t       LIKE type_file.chr3,         # No.FUN-690028 VARCHAR(3),         # Eject sw
              u       LIKE type_file.chr3,         # No.FUN-690028 VARCHAR(3),         # Group total sw
              yymm    LIKE type_file.chr8,           # No.FUN-690028 VARCHAR(6),         #
              more    LIKE type_file.chr1          # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
#No.FUN-580010           m_dash VARCHAR(262),            #No.FUN-550030
#No.FUN-580010           m_dash2 VARCHAR(262),           #No.FUN-550030
          tot1 DYNAMIC ARRAY OF RECORD
               cur     LIKE azi_file.azi01,        # No.FUN-690028 VARCHAR(4),	# 幣別
               amt     LIKE type_file.num20_6      # No.FUN-690028 DEC(20,6)	# 信貸額度
               END RECORD,
          tot2 DYNAMIC ARRAY OF RECORD
               cur      LIKE azi_file.azi01,        # No.FUN-690028 VARCHAR(4),	# 幣別
               amt1	LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),	#
               amt2	LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),	#
               amt3	LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),	#
               amt31,amt32,amt33,amt34,amt35,amt36,amt37  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)
               END RECORD,
          g_orderA    ARRAY[3] OF  LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(10)  #排序名稱
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#No.FUN-580010 DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#No.FUN-580010 DEFINE   g_pageno        SMALLINT   #Report page no
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
#No.FUN-580010 DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yymm = ARG_VAL(8)  #TQC-610053
   #LET tm.s  = ARG_VAL(8)   #TQC-610053
   #LET tm.t  = ARG_VAL(9)   #TQC-610053
   #LET tm.u  = ARG_VAL(10)  #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r721_tm(0,0)        # Input print condition
      ELSE CALL r721()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r721_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r721_w AT p_row,p_col
        WITH FORM "aap/42f/aapr721"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '761'
   LET tm.u    = 'Y'
   LET tm.yymm = TODAY USING 'YYYYMM'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ala07,ala20,ala04,ala01,ala02,ala05,ala08
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
      LET INT_FLAG = 0 CLOSE WINDOW r721_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.yymm,tm.more WITHOUT DEFAULTS
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
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r721_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr721'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr721','9031',1)
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
                         " '",tm.yymm CLIPPED,"'",   #TQC-610053
                         #" '",tm.s CLIPPED,"'",   #TQC-610053
                         #" '",tm.t CLIPPED,"'",   #TQC-610053
                         #" '",tm.u CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aapr721',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r721_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r721()
   ERROR ""
#  EXIT PROGRAM  #No.TQC-970008
END WHILE
   CLOSE WINDOW r721_w
END FUNCTION
 
FUNCTION r721()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
          l_alh     RECORD LIKE alh_file.*,
          a1,a2,a3  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
          sr               RECORD order1 LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
                                  order2 LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
                                  order3 LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
                                  ala07 LIKE ala_file.ala07,
                                  alg02 LIKE alg_file.alg02,
                                  nnp07 LIKE nnp_file.nnp07,
                                  nnp08 LIKE nnp_file.nnp08,
                                  used  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
                                  ala20 LIKE ala_file.ala20,
                                  ala72 LIKE ala_file.ala72,
                                  ala01 LIKE ala_file.ala01,
                                  ala21 LIKE ala_file.ala21,
                                  ala23 LIKE ala_file.ala23,
                                  ala24 LIKE ala_file.ala24,
                                  ala25 LIKE ala_file.ala25,
                                  ala02 LIKE ala_file.ala02,
                                  ala04 LIKE ala_file.ala04,
                                  ala05 LIKE ala_file.ala05,
                                  ala08 LIKE ala_file.ala08,
                                  ala79	LIKE ala_file.ala79,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  #alaclos VARCHAR(1),              #FUN-660117 remark
                                  alaclos LIKE ala_file.alaclos, #FUN-660117
                                  amt1  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
                                  amt2  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
                                  amt3  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
                            amt31,amt32,amt33,amt34,amt35,amt36,amt37  LIKE type_file.num20_6,    # No.FUN-690028 DEC(20,6)
                                  nnp09 LIKE nnp_file.nnp09         #FUN-760006 add
                        END RECORD
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010 --start--
{
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr721'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 262 END IF  #No.FUN-550030
     FOR g_i = 1 TO g_len LET m_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET m_dash2[g_i,g_i]= '-' END FOR
}
#No.FUN-580010 --end--
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND alagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','', ",
                 " ala07,alg02,nnp07,nnp08,0,",
                 " ala20,ala72,ala01,ala21,ala23,ala24,ala25,",
                 " ala02,ala04,ala05,ala08,ala79,azi04,azi05, ",
                 " alaclos,0,0,0,0,0,0,0,0,0,0,",
                 " nnp09",            #FUN-760006 add
                 " FROM ala_file, OUTER alg_file ,azi_file ,nnp_file",
                 " WHERE ala_file.ala07 = alg_file.alg01 ",
                 "   AND ala20 = azi_file.azi01 ",
                 "   AND ala35 = nnp_file.nnp03 ",
                 "   AND ala33 = nnp_file.nnp01 ",
                 "   AND alafirm <> 'X' ",
                 "   AND ", tm.wc CLIPPED
     PREPARE r721_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r721_curs1 CURSOR FOR r721_prepare1
#    LET l_name = 'aapr721.out'
     CALL cl_outnam('aapr721') RETURNING l_name
     START REPORT r721_rep TO l_name
     LET g_pageno = 0
     FOR g_i = 1 TO 10
         LET tot1[g_i].cur=NULL
         LET tot1[g_i].amt=0
         LET tot2[g_i].cur=NULL
         LET tot2[g_i].amt1=0
         LET tot2[g_i].amt2=0
         LET tot2[g_i].amt3=0
         LET tot2[g_i].amt31=0
         LET tot2[g_i].amt32=0
         LET tot2[g_i].amt33=0
         LET tot2[g_i].amt34=0
         LET tot2[g_i].amt35=0
         LET tot2[g_i].amt36=0
         LET tot2[g_i].amt37=0
     END FOR
     DROP TABLE aapr721_tmp
# No.FUN-690028 --start-- 
    CREATE TEMP TABLE aapr721_tmp(
             bank  LIKE ala_file.ala07,
             used  LIKE type_file.num20_6)
# No.FUN-690028 ---end---
     DELETE FROM aapr721_tmp
     FOREACH r721_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          DECLARE c2 CURSOR FOR
                  SELECT * FROM alh_file WHERE alh03=sr.ala01 AND alh00='1'
          LET a1=0 LET a2=0
          FOREACH c2 INTO l_alh.*
             IF l_alh.alh75='1' THEN		# 若已改貸, 則以改貸為準
                SELECT alh76{*alh18} INTO l_alh.alh76 FROM alh_file
                       WHERE alh30=l_alh.alh01 AND alh00='2'
             END IF
             IF l_alh.alh76 > 0			# 若已還款, 則不列入統計
                THEN LET a1 = a1 + l_alh.alh12
                     LET a2 = a2 + l_alh.alh13
                ELSE LET sr.amt3 = sr.amt3 + l_alh.alh14
                     LET g_i =((YEAR(l_alh.alh08))*12+MONTH(l_alh.alh08))-
                              (tm.yymm[1,4]*12+tm.yymm[5,6]) + 1
                     IF g_i < 1 THEN LET g_i=1 END IF
                     CASE WHEN g_i=1 LET sr.amt31=sr.amt31+l_alh.alh14
                          WHEN g_i=2 LET sr.amt32=sr.amt32+l_alh.alh14
                          WHEN g_i=3 LET sr.amt33=sr.amt33+l_alh.alh14
                          WHEN g_i=4 LET sr.amt34=sr.amt34+l_alh.alh14
                          WHEN g_i=5 LET sr.amt35=sr.amt35+l_alh.alh14
                          WHEN g_i=6 LET sr.amt36=sr.amt36+l_alh.alh14
                          OTHERWISE  LET sr.amt37=sr.amt37+l_alh.alh14
                     END CASE
             END IF
          END FOREACH
          LET sr.amt1=(sr.ala23+sr.ala24)              - a1
          LET sr.amt2=(sr.ala23+sr.ala24)*sr.ala21/100 - a2
          IF (sr.alaclos='Y' OR sr.amt1=0) AND sr.amt3=0 THEN
             CONTINUE FOREACH
          END IF
          LET sr.used=(sr.amt1-sr.amt2)*sr.ala79
          IF cl_null(sr.used) THEN LET sr.used = 0 END IF
          UPDATE aapr721_tmp SET used=used+sr.used WHERE bank=sr.ala07
          IF SQLCA.SQLERRD[3]=0 THEN
             INSERT INTO aapr721_tmp VALUES (sr.ala07,sr.used)
          END IF
          OUTPUT TO REPORT r721_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r721_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
END FUNCTION
 
REPORT r721_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr               RECORD order1 LIKE zaa_file.zaa08,        # No.FUN-690028 VARCHAR(10),
                                  order2 LIKE zaa_file.zaa08,        # No.FUN-690028 VARCHAR(10),
                                  order3 LIKE zaa_file.zaa08,        # No.FUN-690028 VARCHAR(10),
                                  ala07 LIKE ala_file.ala07,
                                  alg02 LIKE alg_file.alg02,
                                  nnp07 LIKE nnp_file.nnp07,
                                  nnp08 LIKE nnp_file.nnp08,
                                  used  LIKE type_file.num20_6,      # No.FUN-690028 DEC(20,6),
                                  ala20 LIKE ala_file.ala20,
                                  ala72 LIKE ala_file.ala72,
                                  ala01 LIKE ala_file.ala01,
                                  ala21 LIKE ala_file.ala21,
                                  ala23 LIKE ala_file.ala23,
                                  ala24 LIKE ala_file.ala24,
                                  ala25 LIKE ala_file.ala25,
                                  ala02 LIKE ala_file.ala02,
                                  ala04 LIKE ala_file.ala04,
                                  ala05 LIKE ala_file.ala05,
                                  ala08 LIKE ala_file.ala08,
                                  ala79	LIKE ala_file.ala79,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  #alaclos VARCHAR(1),              #FUN-660117 remark
                                  alaclos LIKE ala_file.alaclos, #FUN-660117
                                  amt1  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
                                  amt2  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
                                  amt3  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
                      amt31,amt32,amt33,amt34,amt35,amt36,amt37  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6)
                                  nnp09 LIKE nnp_file.nnp09         #FUN-760006 add
                        END RECORD,
      l_yymm	   LIKE type_file.chr8,       # No.FUN-690028 VARCHAR(6),
      l_used       LIKE type_file.num20_6,    # No.FUN-690028 DEC(20,6),
      l_chr        LIKE type_file.chr1        #No.FUN-690028 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.ala07,sr.ala20
 
   FORMAT
      PAGE HEADER
#No.FUN-580010 --start--
{
        PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
        IF g_towhom IS NULL OR g_towhom = ' ' THEN
           PRINT '';
        ELSE
           PRINT 'TO:',g_towhom;
        END IF
        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
        PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
}
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#No.FUN-580010 --end--
        PRINT ' '
        LET g_pageno = g_pageno + 1
        LET l_chr = 'N'
        PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
              COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#No.FUN-580010 --start--
#        PRINT m_dash[1,g_len]
#        PRINT g_x[32],
#              COLUMN 41,g_x[33],
#              COLUMN 90,g_x[34] CLIPPED;
        PRINT g_dash[1,g_len]
        PRINT g_x[35],g_x[36],g_x[49],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41];   #FUN-760006 add g_x[49]
#No.FUN-580010 --end--
        LET l_yymm=tm.yymm
        FOR g_i= 1 TO 7
            LET l_yymm[5,6]=(l_yymm[5,6]+1) USING '&&'
            IF l_yymm[5,6] > 12 THEN
               LET l_yymm[1,4]=(l_yymm[1,4]+1) USING '&&&&'
               LET l_yymm[5,6]='01'
            END IF
#No.FUN-580010 --start--
#            IF g_i = 1 THEN
#               PRINT 12 SPACES,l_yymm[1,4],'/',l_yymm[5,6];
#            ELSE
#               PRINT 13 SPACES,l_yymm[1,4],'/',l_yymm[5,6];
#            END IF
        LET g_zaa[41+g_i].zaa08 = l_yymm[1,4],'/',l_yymm[5,6] CLIPPED
        PRINT g_x[41+g_i];
#No.FUN-580010 --end--
        END FOR
        PRINT
#No.FUN-580010 --start--
#        PRINT "--------------- --------------------- ---- ",
#              "------------------- ------------------- ------------------- ",
#              "------------------- ------------------- ------------------- ",
#              "------------------- ------------------- ------------------- ",
#              "------------------- -------------------"
        PRINT g_dash1
#No.FUN-580010 --end--
        LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.ala07
         LET l_used=0
         SELECT used INTO l_used FROM aapr721_tmp WHERE bank=sr.ala07
#No.FUN-580010 --start--
#         PRINT sr.ala07[1,4],' ',sr.alg02,' ',sr.nnp07,
#               COLUMN 19,cl_numfor(l_used,18,sr.azi04) ;
         PRINT COLUMN g_c[35],sr.ala07[1,4],' ',sr.alg02 CLIPPED,' ',sr.nnp07 CLIPPED,   #TQC-6A0081
               COLUMN g_c[36],cl_numfor(l_used,18,sr.azi04),   #FUN-760006 replace;
#No.FUN-580010 --end--
               COLUMN g_c[49],cl_numfor(sr.nnp09-l_used,18,sr.azi04); #FUN-760006 add
         FOR g_i = 1 TO 10
            IF tot1[g_i].cur IS NULL THEN LET tot1[g_i].cur = sr.nnp07 END IF
            IF tot1[g_i].cur = sr.nnp07 THEN
               LET tot1[g_i].amt = tot1[g_i].amt + l_used
               EXIT FOR
            END IF
         END FOR
 
      AFTER GROUP OF sr.ala20
#No.FUN-580010 --start--
#         PRINT COLUMN 39,sr.ala20,
#               COLUMN 44,cl_numfor(GROUP SUM(sr.amt1),18,sr.azi05),
#               COLUMN 64,cl_numfor(GROUP SUM(sr.amt2),18,sr.azi05),
#               COLUMN 84,cl_numfor(GROUP SUM(sr.amt3),18,sr.azi05),
#               COLUMN 104,cl_numfor(GROUP SUM(sr.amt1-sr.amt2-sr.amt3),18,sr.azi05),
#               COLUMN 124,cl_numfor(GROUP SUM(sr.amt31),18,sr.azi05),
#               COLUMN 144,cl_numfor(GROUP SUM(sr.amt32),18,sr.azi05),
#               COLUMN 164,cl_numfor(GROUP SUM(sr.amt33),18,sr.azi05),
#               COLUMN 184,cl_numfor(GROUP SUM(sr.amt34),18,sr.azi05),
#               COLUMN 204,cl_numfor(GROUP SUM(sr.amt35),18,sr.azi05),
#               COLUMN 224,cl_numfor(GROUP SUM(sr.amt36),18,sr.azi05),
#               COLUMN 244,cl_numfor(GROUP SUM(sr.amt37),18,sr.azi05)
         PRINT  COLUMN g_c[37],sr.ala20 CLIPPED,  #TQC-6A0081
                COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt1),18,sr.azi05),
                COLUMN g_c[39],cl_numfor(GROUP SUM(sr.amt2),18,sr.azi05),
                COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt3),18,sr.azi05),
                COLUMN g_c[41],cl_numfor(GROUP SUM(sr.amt1-sr.amt2-sr.amt3),18,sr.azi05),
                COLUMN g_c[42],cl_numfor(GROUP SUM(sr.amt31),18,sr.azi05),
                COLUMN g_c[43],cl_numfor(GROUP SUM(sr.amt32),18,sr.azi05),
                COLUMN g_c[44],cl_numfor(GROUP SUM(sr.amt33),18,sr.azi05),
                COLUMN g_c[45],cl_numfor(GROUP SUM(sr.amt34),18,sr.azi05),
                COLUMN g_c[46],cl_numfor(GROUP SUM(sr.amt35),18,sr.azi05),
                COLUMN g_c[47],cl_numfor(GROUP SUM(sr.amt36),18,sr.azi05),
                COLUMN g_c[48],cl_numfor(GROUP SUM(sr.amt37),18,sr.azi05)
#No.FUN-580010 --end--
         FOR g_i = 1 TO 10
            IF tot2[g_i].cur IS NULL THEN LET tot2[g_i].cur = sr.ala20 END IF
            IF tot2[g_i].cur = sr.ala20 THEN
               LET tot2[g_i].amt1 = tot2[g_i].amt1 + GROUP SUM(sr.amt1)
               LET tot2[g_i].amt2 = tot2[g_i].amt2 + GROUP SUM(sr.amt2)
               LET tot2[g_i].amt3 = tot2[g_i].amt3 + GROUP SUM(sr.amt3)
               LET tot2[g_i].amt31= tot2[g_i].amt31+ GROUP SUM(sr.amt31)
               LET tot2[g_i].amt32= tot2[g_i].amt32+ GROUP SUM(sr.amt32)
               LET tot2[g_i].amt33= tot2[g_i].amt33+ GROUP SUM(sr.amt33)
               LET tot2[g_i].amt34= tot2[g_i].amt34+ GROUP SUM(sr.amt34)
               LET tot2[g_i].amt35= tot2[g_i].amt35+ GROUP SUM(sr.amt35)
               LET tot2[g_i].amt36= tot2[g_i].amt36+ GROUP SUM(sr.amt36)
               LET tot2[g_i].amt37= tot2[g_i].amt37+ GROUP SUM(sr.amt37)
               EXIT FOR
            END IF
         END FOR
 
      AFTER GROUP OF sr.ala07
#      PRINT m_dash2[1,g_len]
      PRINT g_dash2       #No.FUN-580010
      ON LAST ROW
         FOR g_i=1 TO 10
           IF cl_null(tot1[g_i].cur) AND cl_null(tot2[g_i].cur) THEN
              EXIT FOR
           END IF
           IF g_i=1 THEN
#No.FUN-580010 --start--
#             PRINT COLUMN 12,g_x[27] CLIPPED END IF
#             PRINT COLUMN 17,tot1[g_i].cur,
#                   COLUMN 19,cl_numfor(tot1[g_i].amt,18,sr.azi05),' ',tot2[g_i].cur,
#                   COLUMN 44,cl_numfor(tot2[g_i].amt1,18,sr.azi05),
#                   COLUMN 64,cl_numfor(tot2[g_i].amt2,18,sr.azi05),
#                   COLUMN 84,cl_numfor(tot2[g_i].amt3,18,sr.azi05),
#                   COLUMN 104,cl_numfor((tot2[g_i].amt1-tot2[g_i].amt2-tot2[g_i].amt3),18,sr.azi05),
#                   COLUMN 124,cl_numfor(tot2[g_i].amt31,18,sr.azi05),
#                   COLUMN 144,cl_numfor(tot2[g_i].amt32,18,sr.azi05),
#                   COLUMN 164,cl_numfor(tot2[g_i].amt33,18,sr.azi05),
#                   COLUMN 184,cl_numfor(tot2[g_i].amt34,18,sr.azi05),
#                   COLUMN 204,cl_numfor(tot2[g_i].amt35,18,sr.azi05),
#                   COLUMN 224,cl_numfor(tot2[g_i].amt36,18,sr.azi05),
#                   COLUMN 244,cl_numfor(tot2[g_i].amt37,18,sr.azi05)
	     PRINT  g_x[27] CLIPPED END IF
             PRINT  COLUMN g_c[35],tot1[g_i].cur CLIPPED,  #TQC-6A0081
                    COLUMN g_c[36],cl_numfor(tot1[g_i].amt,18,sr.azi05),
                    COLUMN g_c[37],tot2[g_i].cur CLIPPED,  #TQC-6A0081
                    COLUMN g_c[38],cl_numfor(tot2[g_i].amt1,18,sr.azi05),
                    COLUMN g_c[39],cl_numfor(tot2[g_i].amt2,18,sr.azi05),
                    COLUMN g_c[40],cl_numfor(tot2[g_i].amt3,18,sr.azi05),
                    COLUMN g_c[41],cl_numfor((tot2[g_i].amt1-tot2[g_i].amt2-tot2[g_i].amt3),18,sr.azi05),
                    COLUMN g_c[42],cl_numfor(tot2[g_i].amt31,18,sr.azi05),
                    COLUMN g_c[43],cl_numfor(tot2[g_i].amt32,18,sr.azi05),
                    COLUMN g_c[44],cl_numfor(tot2[g_i].amt33,18,sr.azi05),
                    COLUMN g_c[45],cl_numfor(tot2[g_i].amt34,18,sr.azi05),
                    COLUMN g_c[46],cl_numfor(tot2[g_i].amt35,18,sr.azi05),
                    COLUMN g_c[47],cl_numfor(tot2[g_i].amt36,18,sr.azi05),
                    COLUMN g_c[48],cl_numfor(tot2[g_i].amt37,18,sr.azi05)
#No.FUN-580010 --end--
         END FOR
#         PRINT m_dash[1,g_len]
         PRINT g_dash[1,g_len] #No.FUN-580010
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n'
#            THEN PRINT m_dash[1,g_len]
            THEN PRINT g_dash[1,g_len] #No.FUN-580010
                 PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
            ELSE SKIP 2 LINE
         END IF
END REPORT
#Patch....NO.TQC-610035 <> #
