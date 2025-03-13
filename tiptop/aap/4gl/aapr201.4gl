# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aapr201.4gl
# Descriptions...: 專業科目表列印
# Input parameter: 
# Return code....: 
# Date & Author.6: 96/11/19 By WUPN
# Modify.........: 97/04/16 By Danny (將apc_file改成npp_file,npq_file)
# Modify.........: No.FUN-4C0097 04/12/27 By Nicola 報表架構修改
#                                                   增加列印部門名稱gem02
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.MOD-670133 06/07/31 By Smapmin 修改小計問題
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/10 By baogui 結束位置調整
# Modify.........: No.FUN-770093 07/10/11 By zhoufeng 報表打印改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改 
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
                 #wc      LIKE type_file.chr1000,       # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
                 wc       STRING,        # Where condition   #TQC-630166
                 s        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        # Order by sequence
                 t        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        # Eject sw
                 u        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        # Group total sw
                 more     LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
# Prog. Version..: '5.30.06-13.03.12(08), #排序名稱
          l_orderA      ARRAY[4] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(16), #排序名稱
                                              #No.FUN-550030
          g_bal_sum LIKE npq_file.npq07f
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time    LIKE type_file.chr8        #No.FUN-6A0055
DEFINE   g_sql      STRING                       #No.FUN-770093
DEFINE   g_str      STRING                       #No.FUN-770093
DEFINE   l_table    STRING                       #No.FUN-770093
  
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #No.FUN-770093 --start--
   LET g_sql="npq08.npq_file.npq08,npq05.npq_file.npq05,gem02.gem_file.gem02,",
             "npq21.npq_file.npq21,npq22.npq_file.npq22,npp03.npp_file.npp03,",
             "nppglno.npp_file.nppglno,npq24.npq_file.npq24,",
             "npq07f_1.npq_file.npq07f,npq07f_2.npq_file.npq07f,",
             "bal.npq_file.npq07f,npq03.npq_file.npq03,npp02.npp_file.npp02"
   LET l_table = cl_prt_temptable('aapr201',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770093 --end--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#   CALL r201_create_tmp()        #No.FUN-770093
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapr201_tm(0,0)
   ELSE
      CALL aapr201()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapr201_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW aapr201_w AT p_row,p_col
     WITH FORM "aap/42f/aapr201"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
      CONSTRUCT BY NAME tm.wc ON npq08,npq21,npq22,npq03,npq05,npp03,npp02,nppglno
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapr201_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
     
      IF tm.wc = ' 1=1' THEN 
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
     
      DISPLAY BY NAME tm.more         # Condition
     
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS 
     
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
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         AFTER INPUT  
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
         CLOSE WINDOW aapr201_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr201'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr201','9031',1)
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr201',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr201_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr201()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr201_w
 
END FUNCTION
 
FUNCTION aapr201()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,             # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     STRING,            # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_curr    LIKE npq_file.npq24,
#         l_order   ARRAY[5] OF VARCHAR(10),
#          l_order   ARRAY[5] OF LIKE oea_file.oea01,      # No.FUN-690028 VARCHAR(16),  #No.FUN-550030
          l_order   ARRAY[5] OF LIKE npq_file.npq22,      # No.FUN-690028 VARCHAR(40),   #No.FUN-560011
          sr        RECORD order1 LIKE npq_file.npq22,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                           order2 LIKE npq_file.npq22,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                           order3 LIKE npq_file.npq22,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                           npq08 LIKE npq_file.npq08,   
                           npq05 LIKE npq_file.npq05,   
                           npq06 LIKE npq_file.npq06,   
                           npq21 LIKE npq_file.npq21,  
                           npq22 LIKE npq_file.npq22, 
                           npq03 LIKE npq_file.npq03,
                           npq24 LIKE npq_file.npq24,
                           npq07f LIKE npq_file.npq07f,
                           npp03 LIKE npp_file.npp03,
                           npp02 LIKE npp_file.npp02,
                           nppglno LIKE npp_file.nppglno,
                           npq07f_1 LIKE npq_file.npq07f,
                           npq07f_2 LIKE npq_file.npq07f,
                           bal   LIKE npq_file.npq07f,
                           gem02 LIKE gem_file.gem02
                    END RECORD
 
   CALL cl_del_data(l_table)                        #No.FUN-770093       
 
#   DELETE FROM r201_tmp                            #No.FUN-770093
#   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #No.FUN-770093 --mark--
#   #bugno:5197................................................................
#   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r201_tmp WHERE order1 = ? ",
#               " GROUP BY curr ORDER BY curr"
#   PREPARE r201tmp_pre1 FROM l_sql
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('tmp_pre1:',SQLCA.sqlcode,1)
#      RETURN 
#   END IF
#   DECLARE r201_tmpcs1 CURSOR FOR r201tmp_pre1
#
#   #LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r201_tmp WHERE order2 = ? ",   #MOD-670133
#   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r201_tmp WHERE order1 = ? AND order2 = ? ",   #MOD-670133
#               " GROUP BY curr ORDER BY curr"
#   PREPARE r201tmp_pre2 FROM l_sql
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('tmp_pre2:',SQLCA.sqlcode,1)
#      RETURN 
#   END IF
#   DECLARE r201_tmpcs2 CURSOR FOR r201tmp_pre2
#
#   #LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r201_tmp WHERE order3 = ? ",   #MOD-670133
#   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r201_tmp WHERE order1 = ? AND order2 = ? AND order3 = ? ",   #MOD-670133
#               " GROUP BY curr ORDER BY curr"
#   PREPARE r201tmp_pre3 FROM l_sql
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('tmp_pre3:',SQLCA.sqlcode,1)
#      RETURN 
#   END IF
#   DECLARE r201_tmpcs3 CURSOR FOR r201tmp_pre3
#
#   LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2) FROM r201_tmp ",
#               " GROUP BY curr ORDER BY curr"
#   PREPARE r201tmp_pre4 FROM l_sql
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('tmp_pre4:',SQLCA.sqlcode,1) 
#      RETURN 
#   END IF
#   DECLARE r201_tmpcs4 CURSOR FOR r201tmp_pre4
#   #bug end.................................................................
    #No.FUN-770093 --end--
 
   LET l_sql = "SELECT '','','',",
               "  npq08, npq05, npq06, npq21, npq22,",
               "  npq03, npq24,npq07f ,npp03, npp02, nppglno ,'',''",
               "  FROM npp_file,npq_file ", 
               " WHERE ",tm.wc,
               "   AND npq01 = npp01 " ,
               "   AND nppsys= npqsys ",
               "   AND npp00 = npq00  ",
               "   AND npp011= npq011 "
 
   LET l_sql = l_sql CLIPPED," ORDER BY npq08"
 
   PREPARE aapr201_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE aapr201_curs1 CURSOR FOR aapr201_prepare1
 
#   CALL cl_outnam('aapr201') RETURNING l_name       #No.FUN-770093
#   START REPORT aapr201_rep TO l_name               #No.FUN-770093
#
#   LET g_pageno = 0                                 #No.FUN-770093
 
   FOREACH aapr201_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH
      END IF
 
      LET g_bal_sum=0
 
      SELECT gem02 INTO sr.gem02 
        FROM gem_file
       WHERE gem01 = sr.npq05
 
      #No.FUN-770093 --mark--
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.npq08
#                                       LET l_orderA[g_i]=g_x[11]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.npq21
#                                       LET l_orderA[g_i]=g_x[12]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.npq22
#                                       LET l_orderA[g_i]=g_x[13]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.npq03
#                                       LET l_orderA[g_i]=g_x[14]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.npq05
#                                       LET l_orderA[g_i]=g_x[15]
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.npp03 USING 'YYYYMMDD'
#                                       LET l_orderA[g_i]=g_x[16]
#              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.npp02 USING 'YYYYMMDD'
#                                       LET l_orderA[g_i]=g_x[17]
#              WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.nppglno
#                                       LET l_orderA[g_i]=g_x[18]
#              OTHERWISE LET l_order[g_i] = '-'
#                        LET l_orderA[g_i] = ' '
#         END CASE
#      END FOR
#
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
#      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
#      IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
      #No.FUN-770093 --end--
      
      IF sr.npq07f IS NULL THEN
         LET sr.npq07f = 0
      END IF
 
      IF sr.npq06='1' THEN 
         LET sr.npq07f_1=sr.npq07f 
         LET sr.npq07f_2=0
         LET sr.bal=sr.npq07f 
      ELSE
         LET sr.npq07f_2=sr.npq07f
         LET sr.npq07f_1=0
         LET sr.bal=sr.npq07f*(-1) 
      END IF
 
      #No.FUN-770093 --mark--
#      INSERT INTO r201_tmp VALUES(sr.npq24,sr.npq07f_1,sr.npq07f_2,
#                                  sr.order1,sr.order2,sr.order3)
#     
#      OUTPUT TO REPORT aapr201_rep(sr.*)
      #No.FUN-770093 --end--
      #No.FUN-770093 --start--
      EXECUTE insert_prep USING sr.npq08,sr.npq05,sr.gem02,sr.npq21,sr.npq22,
                                sr.npp03,sr.nppglno,sr.npq24,sr.npq07f_1,
                                sr.npq07f_2,sr.bal,sr.npq03,sr.npp02
      #No.FUN-770093 --end--
 
   END FOREACH
 
#   FINISH REPORT aapr201_rep                      #No.FUN-770093
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-770093
   #No.FUN-770093 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'npq08,npq21,npq22,npq03,npq05,npp03,npp02,nppglno')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",
               tm.u[2,2],";",tm.u[3,3],";",g_azi05,";",g_azi04
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aapr201','aapr201',l_sql,g_str)
   #No.FUN-770093 --end--
  # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
#No.FUN-770093 --start-- mark
{REPORT aapr201_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr       RECORD order1 LIKE npq_file.npq22,      # No.FUN-690028 VARCHAR(40),       #FUN-560011
                          order2 LIKE npq_file.npq22,      # No.FUN-690028 VARCHAR(40),       #FUN-560011
                          order3 LIKE npq_file.npq22,      # No.FUN-690028 VARCHAR(40),       #FUN-560011
                          npq08 LIKE npq_file.npq08,   
                          npq05 LIKE npq_file.npq05,   
                          npq06 LIKE npq_file.npq06,   
                          npq21 LIKE npq_file.npq21,  
                          npq22 LIKE npq_file.npq22, 
                          npq03 LIKE npq_file.npq03,
                          npq24 LIKE npq_file.npq24,
                          npq07f LIKE npq_file.npq07f,
                          npp03 LIKE npp_file.npp03,
                          npp02 LIKE npp_file.npp02,
                          nppglno LIKE npp_file.nppglno,
                          npq07f_1 LIKE npq_file.npq07f,
                          npq07f_2 LIKE npq_file.npq07f,
                          bal   LIKE npq_file.npq07f,
                          gem02 LIKE gem_file.gem02
                   END RECORD,
      l_amt        LIKE npq_file.npq07f,
      l_amt1       LIKE npq_file.npq07f,
      l_curr       LIKE npq_file.npq24,
      l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE g_head1   STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.npq08,sr.npq24
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[19] CLIPPED,l_orderA[1] CLIPPED,
                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
               g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
         PRINT g_dash1 
         LET l_last_sw = 'n'
      
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
      
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
      
      BEFORE GROUP OF sr.order3
         IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN 
            SKIP TO TOP OF PAGE
         END IF
      
      BEFORE GROUP OF sr.npq24
         IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN 
            SKIP TO TOP OF PAGE
         END IF
         LET g_bal_sum=0
      
      ON EVERY ROW
         LET g_bal_sum=g_bal_sum+sr.bal
         PRINT COLUMN g_c[31],sr.npq08,
               COLUMN g_c[32],sr.npq05,
               COLUMN g_c[33],sr.gem02,
               COLUMN g_c[34],sr.npq21,
               COLUMN g_c[35],sr.npq22,
               COLUMN g_c[36],sr.npp03,
               COLUMN g_c[37],sr.nppglno,
               COLUMN g_c[38],sr.npq24,
               COLUMN g_c[39],cl_numfor(sr.npq07f_1,39,g_azi04),
               COLUMN g_c[40],cl_numfor(sr.npq07f_2,40,g_azi04),
               COLUMN g_c[41],cl_numfor(g_bal_sum,41,g_azi04)
      
      AFTER GROUP OF sr.npq24
         SKIP 1 LINE
         LET g_bal_sum=0
      
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            FOREACH r201_tmpcs1 USING sr.order1 INTO l_curr,l_amt,l_amt1
               IF SQLCA.sqlcode THEN 
                  CALL cl_err('foreach1',SQLCA.sqlcode,1)
                  EXIT FOREACH 
               END IF 
               PRINT COLUMN g_c[36],l_curr,
                     COLUMN g_c[37],l_orderA[1] CLIPPED,
                     COLUMN g_c[38],g_x[9] CLIPPED,
                     COLUMN g_c[39],cl_numfor(l_amt,39,g_azi05),
                     COLUMN g_c[40],cl_numfor(l_amt1,40,g_azi05),
                     COLUMN g_c[41],cl_numfor(l_amt-l_amt1,41,g_azi05)
            END FOREACH
            SKIP 1 LINE
         END IF
         LET g_bal_sum=0
      
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            #FOREACH r201_tmpcs2 USING sr.order2 INTO l_curr,l_amt,l_amt1   #MOD-670133
            FOREACH r201_tmpcs2 USING sr.order1,sr.order2 INTO l_curr,l_amt,l_amt1   #MOD-670133
               IF SQLCA.sqlcode THEN 
                  CALL cl_err('foreach2',SQLCA.sqlcode,1)
                  EXIT FOREACH 
               END IF 
               PRINT COLUMN g_c[36],l_curr,
                     COLUMN g_c[37],l_orderA[2] CLIPPED,
                     COLUMN g_c[38],g_x[9] CLIPPED,
                     COLUMN g_c[39],cl_numfor(l_amt,39,g_azi05),
                     COLUMN g_c[40],cl_numfor(l_amt1,40,g_azi05),
                     COLUMN g_c[41],cl_numfor(l_amt-l_amt1,41,g_azi05)
            END FOREACH
            SKIP 1 LINE
         END IF
         LET g_bal_sum=0
      
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            #FOREACH r201_tmpcs3 USING sr.order3 INTO l_curr,l_amt,l_amt1   #MOD-670133
            FOREACH r201_tmpcs3 USING sr.order1,sr.order2,sr.order3 INTO l_curr,l_amt,l_amt1   #MOD-670133
               IF SQLCA.sqlcode THEN 
                  CALL cl_err('foreach3',SQLCA.sqlcode,1)
                  EXIT FOREACH 
               END IF 
               PRINT COLUMN g_c[36],l_curr,
                     COLUMN g_c[37],l_orderA[3] CLIPPED,
                     COLUMN g_c[38],g_x[9] CLIPPED,
                     COLUMN g_c[39],cl_numfor(l_amt,39,g_azi05),
                     COLUMN g_c[40],cl_numfor(l_amt1,40,g_azi05),
                     COLUMN g_c[41],cl_numfor(l_amt-l_amt1,41,g_azi05)
            END FOREACH
            SKIP 1 LINE
         END IF
         LET g_bal_sum=0
      
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'npq08,npq21,npq22,npq03,npq05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[41],g_x[7] CLIPPED         #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED         #TQC-6A0088
      
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[41],g_x[6] CLIPPED       #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED       #TQC-6A0088
         ELSE 
            SKIP 2 LINE
         END IF
 
END REPORT
 
FUNCTION r201_create_tmp()    #no.5197
# No.FUN-690028 --start--
   CREATE TEMP TABLE r201_tmp(
       curr      LIKE apa_file.apa13,
       amt1      LIKE type_file.num20_6,
       amt2      LIKE type_file.num20_6,
       order1    LIKE npq_file.npq22,
       order2    LIKE npq_file.npq22,
       order3    LIKE npq_file.npq22)
      
# No.FUN-690028 ---end---
END FUNCTION}
#No.FUN-770093 --end--
