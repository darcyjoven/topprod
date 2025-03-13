# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapr822.4gl
# Descriptions...: 信用狀到單明細表列印
# Date & Author..: 93/02/05  By  Felicity  Tseng
 # Modify.........: No.MOD-4C0172 05/01/28 By Nicola 取位錯誤
# Modify.........: No.FUN-4C0097 05/01/28 By Nicola 報表架構修改
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.FUN-770093 07/10/25 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc      STRING,   #No.TQC-630166
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3), 
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),
              u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
           END RECORD,
#      g_orderA    ARRAY[3] OF VARCHAR(10)  #排序名稱
       g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)  #排序名稱
                                         #No.FUN-550030
DEFINE g_i         LIKE type_file.num5   #count/index for any purpose  #No.FUN-690028 SMALLINT
#DEFINEl_time      LIKE type_file.chr8   #No.FUN-6A0055
DEFINE g_sql       STRING                #No.FUN-770093
DEFINE g_str       STRING                #No.FUN-770093
DEFINE l_table     STRING                #No.FUN-770093
   
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
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #No.FUN-770093 --start--
   LET g_sql="alh01.alh_file.alh01,alh10.alh_file.alh10,alh00.alh_file.alh00,",
             "alh02.alh_file.alh02,alh05.alh_file.alh05,alh06.alh_file.alh06,",
             "alh11.alh_file.alh11,alh12.alh_file.alh12,alh15.alh_file.alh15,",
             "alh30.alh_file.alh30,alh32.alh_file.alh32,alh35.alh_file.alh35,",
             "alh37.alh_file.alh37,alh72.alh_file.alh72,alh03.alh_file.alh03,",
             "alh08.alh_file.alh08,pmc03.pmc_file.pmc03,alg02.alg_file.alg02,",
             "alh14.alh_file.alh14,alh16.alh_file.alh16,alh31.alh_file.alh31,",
             "alh19.alh_file.alh19,alh36.alh_file.alh36,alh38.alh_file.alh38,",
             "azi04.azi_file.azi04,azi05.azi_file.azi05,azi07.azi_file.azi07" #No.FUN-870151 add azi07
   LET l_table = cl_prt_temptable('aapr822',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                         #No.FUN-870151 add ?   
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF
   #No.FUN-770093 --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
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
 
   #No.FUN-770093 --mark--
#   DROP TABLE curr_tmp
## No.FUN-690028 --start-- 
#  CREATE TEMP TABLE curr_tmp(
#       curr    LIKE apa_file.apa13,
#       amt1    LIKE type_file.num20_6,
#       amt2    LIKE type_file.num20_6,
#       amt3    LIKE type_file.num20_6,
#       order1  LIKE alh_file.alh01,
#       order2  LIKE alh_file.alh01, 
#       order3   LIKE alh_file.alh01)
#      
## No.FUN-690028 ---end---
   #No.FUN-770093 --end--
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r822_tm(0,0)
   ELSE
      CALL r822()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r822_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 12
   OPEN WINDOW r822_w AT p_row,p_col
     WITH FORM "aap/42f/aapr822"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '1'                             
   LET tm.u    = ' '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
 
      CONSTRUCT BY NAME tm.wc ON alh01,alh02,alh05,alh06,alh10,alh11,alh72,alh00
 
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
         CLOSE WINDOW r822_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
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
            CALL cl_cmdask()
 
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
         CLOSE WINDOW r822_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr822'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr822','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
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
            CALL cl_cmdat('aapr822',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r822_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r822()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r822_w
 
END FUNCTION
 
FUNCTION r822()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_order   ARRAY[5] OF LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
          sr        RECORD order1 LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(20),
                       order2 LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(20),
                       order3 LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(20),
                       alh    RECORD LIKE alh_file.*,
                       alg    RECORD LIKE alg_file.*,
                       alk    RECORD LIKE alk_file.*,
                       pmc03  LIKE pmc_file.pmc03
                    END RECORD
 
   CALL cl_del_data(l_table)                         #No.FUN-770093
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alhuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alhuser', 'alhgrup')
   #End:FUN-980030
 
   #No.FUN-770093 --start--
#   #no.6133   (針對幣別加總)
#   DELETE FROM curr_tmp;
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ",
#             "   FROM curr_tmp ",    #group 1 小計
#             "  WHERE order1=? ",
#             "  GROUP BY curr"
#   PREPARE tmp1_pre FROM l_sql
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   DECLARE tmp1_cs CURSOR FOR tmp1_pre
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ",
#             "   FROM curr_tmp ",    #group 2 小計
#             "  WHERE order1=? ",
#             "    AND order2=? ",
#             "  GROUP BY curr  "
#   PREPARE tmp2_pre FROM l_sql
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   DECLARE tmp2_cs CURSOR FOR tmp2_pre
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ",
#             "   FROM curr_tmp ",    #group 3 小計
#             "  WHERE order1=? ",
#             "    AND order2=? ",
#             "    AND order3=? ",
#             "  GROUP BY curr  "
#   PREPARE tmp3_pre FROM l_sql
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('pre_3:',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   DECLARE tmp3_cs CURSOR FOR tmp3_pre
#
#   #no.6133(end)
   #No.FUN-770093 --end--
 
   LET l_sql = "SELECT '','','', ",
               " alh_file.*, alg_file.*, alk_file.*, pmc03",
               " FROM alh_file,OUTER alg_file,OUTER alk_file,OUTER pmc_file",
               " WHERE alh_file.alh06 = alg_file.alg01 AND alh_file.alh05=pmc_file.pmc01",
               "   AND alh_file.alh30=alk_file.alk01",
               "   AND alk_file.alkfirm <> 'X' ",  #CHI-C80041  
               "   AND ", tm.wc CLIPPED
 
   PREPARE r822_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r822_curs1 CURSOR FOR r822_prepare1
 
#   CALL cl_outnam('aapr822') RETURNING l_name     #No.FUN-770093
#   START REPORT r822_rep TO l_name                #No.FUN-770093
#
#   LET g_pageno = 0                               #No.FUN-770093
 
   FOREACH r822_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET sr.alh.alh14 = sr.alh.alh14 - sr.alh.alh76
      LET sr.alh.alh16 = sr.alh.alh16 - sr.alh.alh77
 
      #No.FUN-770093 --mark--
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.alh.alh01
#                                       LET g_orderA[g_i]= g_x[10]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.alh.alh02 USING 'YYYYMMDD'
#                                       LET g_orderA[g_i]= g_x[11]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.alh.alh05
#                                       LET g_orderA[g_i]= g_x[12]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.alh.alh06
#                                       LET g_orderA[g_i]= g_x[13]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.alh.alh10
#                                       LET g_orderA[g_i]= g_x[14]
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.alh.alh11
#                                       LET g_orderA[g_i]= g_x[15]
#              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.alh.alh72
#                                       LET g_orderA[g_i]= g_x[16]
#              OTHERWISE LET l_order[g_i]  = '-'
#                        LET g_orderA[g_i] = ' '          #清為空白
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
#      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
#      IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
#
#      OUTPUT TO REPORT r822_rep(sr.*)
      #No.FUN-770093 --end--
      #No.FUN-770093 --start--
     #SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05               #No.FUN-870151 
      SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07 #No.FUN-870151       
             FROM azi_file
      WHERE azi01=sr.alh.alh11
 
      SELECT pmc03 INTO sr.alg.alg02 FROM pmc_file WHERE pmc01=sr.alh.alh06
 
      EXECUTE insert_prep USING sr.alh.alh01,sr.alh.alh10,sr.alh.alh00,
                                sr.alh.alh02,sr.alh.alh05,sr.alh.alh06,
                                sr.alh.alh11,sr.alh.alh12,sr.alh.alh15,
                                sr.alh.alh30,sr.alh.alh32,sr.alh.alh35,
                                sr.alh.alh37,sr.alh.alh72,sr.alh.alh03,
                                sr.alh.alh08,sr.pmc03,sr.alg.alg02,
                                sr.alh.alh14,sr.alh.alh16,sr.alh.alh31,
                                sr.alh.alh19,sr.alh.alh36,sr.alh.alh38,
                                t_azi04,t_azi05
                                ,t_azi07   #No.FUN-870151
      #No.FUN-770093 --end--   
   END FOREACH
 
#   FINISH REPORT r822_rep                         #No.FUN-770093
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-770093
   #No.FUN-770093 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(tm.wc,'alh01,alh02,alh05,alh06,alh10,alh11,alh72,alh00')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",
               tm.u[2,2],";",tm.u[3,3],";",g_azi04,";",g_azi05
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aapr822','aapr822',l_sql,g_str)
   #No.FUN-770093 --end--
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
 
END FUNCTION
#No.FUN-770093 --start-- mark
{REPORT r822_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr           RECORD
                          order1 LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(20),
                          order2 LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(20),
                          order3 LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(20),
                          alh    RECORD LIKE alh_file.*,
                          alg    RECORD LIKE alg_file.*,
                          alk    RECORD LIKE alk_file.*,
                          pmc03  LIKE pmc_file.pmc03
                       END RECORD,
          sr1          RECORD
                          curr      LIKE azi_file.azi01,      # No.FUN-690028 VARCHAR(04),
                          amt1      LIKE alh_file.alh12,
                          amt2      LIKE alh_file.alh32,
                          amt3      LIKE alh_file.alh14
                       END RECORD
#         l_azi03      LIKE azi_file.azi03,  #NO.CHI-6A0004
#         l_azi04      LIKE azi_file.azi04,  #NO.CHI-6A0004
#         l_azi05      LIKE azi_file.azi05   #NO.CHI-6A0004
   DEFINE g_head1       STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.alh.alh11,sr.order2,sr.order3,sr.alh.alh01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,'-',
                       g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
                          g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
                          g_x[43],g_x[44]
         PRINTX name = H2 g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
                          g_x[51],g_x[52],g_x[53],g_x[54]
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
         SELECT azi03,azi04,azi05
#          INTO l_azi03,l_azi04,l_azi05   #NO.CHI-6A0004
           INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
           FROM azi_file
          WHERE azi01 = sr.alh.alh11
 
         PRINTX name = D1 COLUMN g_c[31],sr.alh.alh01,
                          COLUMN g_c[32],sr.alh.alh10,
                          COLUMN g_c[33],sr.alh.alh00,
                          COLUMN g_c[34],sr.alh.alh02,
                          COLUMN g_c[35],sr.alh.alh05,
                          COLUMN g_c[36],sr.alh.alh06,
                          COLUMN g_c[37],sr.alh.alh11,
#                         COLUMN g_c[38],cl_numfor(sr.alh.alh12,38,l_azi04),   #NO.CHI-6A0004
                          COLUMN g_c[38],cl_numfor(sr.alh.alh12,38,t_azi04),   #NO.CHI-6A0004
#                         COLUMN g_c[39],cl_numfor(sr.alh.alh15,39,l_azi04),   #No.MOD-4C0172 #NO.CHI-6A0004
                          COLUMN g_c[39],cl_numfor(sr.alh.alh15,39,t_azi04),   #No.MOD-4C0172 #NO.CHI-6A0004
                          COLUMN g_c[40],sr.alh.alh30,
#                         COLUMN g_c[41],cl_numfor(sr.alh.alh32,41,l_azi04),   #NO.CHI-6A0004
                          COLUMN g_c[41],cl_numfor(sr.alh.alh32,41,t_azi04),   #NO.CHI-6A0004
                          COLUMN g_c[42],cl_numfor(sr.alh.alh35,42,g_azi04),
                          COLUMN g_c[43],cl_numfor(sr.alh.alh37,43,g_azi04),
                          COLUMN g_c[44],sr.alh.alh72 CLIPPED
 
         SELECT pmc03 INTO sr.alg.alg02 FROM pmc_file WHERE pmc01=sr.alh.alh06
 
         PRINTX name = D2 COLUMN g_c[45],sr.alh.alh03,
                          COLUMN g_c[46],sr.alh.alh08,
                          COLUMN g_c[47],sr.pmc03,
                          COLUMN g_c[48],sr.alg.alg02,
#                         COLUMN g_c[49],cl_numfor(sr.alh.alh14,49,l_azi04),   #NO.CHI-6A0004
                          COLUMN g_c[49],cl_numfor(sr.alh.alh14,49,t_azi04),   #NO.CHI-6A0004
                          COLUMN g_c[50],cl_numfor(sr.alh.alh16,50,g_azi04),
                          COLUMN g_c[51],sr.alh.alh31,
                          COLUMN g_c[52],cl_numfor(sr.alh.alh19,52,g_azi04),
                          COLUMN g_c[53],cl_numfor(sr.alh.alh36,53,g_azi04),
                          COLUMN g_c[54],cl_numfor(sr.alh.alh38,54,g_azi04)
         PRINT
 
         INSERT INTO curr_tmp VALUES(sr.alh.alh11,sr.alh.alh12,sr.alh.alh32,
                                     sr.alh.alh14,sr.order1,sr.order2,sr.order3)
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            PRINT COLUMN g_c[37],g_dash2[1,g_w[37]],
                  COLUMN g_c[38],g_dash2[1,g_w[38]],
                  COLUMN g_c[39],g_dash2[1,g_w[39]],
                  COLUMN g_c[40],g_dash2[1,g_w[40]],
                  COLUMN g_c[41],g_dash2[1,g_w[41]],
                  COLUMN g_c[42],g_dash2[1,g_w[42]],
                  COLUMN g_c[43],g_dash2[1,g_w[43]],
                  COLUMN g_c[44],g_dash2[1,g_w[44]]
 
            PRINTX name = S1 COLUMN g_c[33],g_orderA[1] CLIPPED,
                             COLUMN g_c[34],sr.order1[1,10] CLIPPED,
                             COLUMN g_c[35],g_x[17] CLIPPED,
#                             COLUMN g_c[36],sr.order1[11,20] CLIPPED,
                             COLUMN g_c[43],cl_numfor(GROUP SUM(sr.alh.alh37),43,g_azi05)
 
            PRINTX name = S2 COLUMN g_c[50],cl_numfor(GROUP SUM(sr.alh.alh16),50,g_azi05),
                             COLUMN g_c[52],cl_numfor(GROUP SUM(sr.alh.alh19),52,g_azi05),
                             COLUMN g_c[53],cl_numfor(GROUP SUM(sr.alh.alh36),53,g_azi05),
                             COLUMN g_c[54],cl_numfor(GROUP SUM(sr.alh.alh38),54,g_azi05)
 
            FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#              SELECT azi05 INTO l_azi05 FROM azi_file
               SELECT azi05 INTO t_azi05 FROM azi_file
                WHERE azi01 = sr1.curr
               LET sr1.curr = sr1.curr CLIPPED,':'
               PRINTX name = S1 COLUMN g_c[37],sr1.curr,
#NO.CHI-6A0004 --START
#                               COLUMN g_c[38],cl_numfor(sr1.amt1,38,l_azi05),
#                               COLUMN g_c[41],cl_numfor(sr1.amt2,41,l_azi05)
#              PRINTX name = S2 COLUMN g_c[49],cl_numfor(sr1.amt3,49,l_azi05)
                                COLUMN g_c[38],cl_numfor(sr1.amt1,38,t_azi05),
                                COLUMN g_c[41],cl_numfor(sr1.amt2,41,t_azi05)
               PRINTX name = S2 COLUMN g_c[49],cl_numfor(sr1.amt3,49,t_azi05)
#NO.CHI-6A0004 --END
            END FOREACH
 
            PRINT
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT COLUMN g_c[37],g_dash2[1,g_w[37]],
                  COLUMN g_c[38],g_dash2[1,g_w[38]],
                  COLUMN g_c[39],g_dash2[1,g_w[39]],
                  COLUMN g_c[40],g_dash2[1,g_w[40]],
                  COLUMN g_c[41],g_dash2[1,g_w[41]],
                  COLUMN g_c[42],g_dash2[1,g_w[42]],
                  COLUMN g_c[43],g_dash2[1,g_w[43]],
                  COLUMN g_c[44],g_dash2[1,g_w[44]]
 
            PRINTX name = S1 COLUMN g_c[33],g_orderA[2] CLIPPED,
                             COLUMN g_c[34],sr.order2[1,10] CLIPPED,
                             COLUMN g_c[35],g_x[17] CLIPPED,
#                             COLUMN g_c[36],sr.order2[11,20] CLIPPED,
                             COLUMN g_c[43],cl_numfor(GROUP SUM(sr.alh.alh37),43,g_azi05)
 
            PRINTX name = S2 COLUMN g_c[50],cl_numfor(GROUP SUM(sr.alh.alh16),50,g_azi05),
                             COLUMN g_c[52],cl_numfor(GROUP SUM(sr.alh.alh19),52,g_azi05),
                             COLUMN g_c[53],cl_numfor(GROUP SUM(sr.alh.alh36),53,g_azi05),
                             COLUMN g_c[54],cl_numfor(GROUP SUM(sr.alh.alh38),54,g_azi05)
 
            FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#              SELECT azi05 INTO l_azi05 FROM azi_file   #NO.CHI-6A0004
               SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                WHERE azi01 = sr1.curr
               LET sr1.curr = sr1.curr CLIPPED,':'
               PRINTX name = S1 COLUMN g_c[37],sr1.curr,
#NO.CHI-6A0004 --START
#                               COLUMN g_c[38],cl_numfor(sr1.amt1,38,l_azi05),
#                               COLUMN g_c[41],cl_numfor(sr1.amt2,41,l_azi05)
#              PRINTX name = S2 COLUMN g_c[49],cl_numfor(sr1.amt3,49,l_azi05)
                                COLUMN g_c[38],cl_numfor(sr1.amt1,38,t_azi05),
                                COLUMN g_c[41],cl_numfor(sr1.amt2,41,t_azi05)
               PRINTX name = S2 COLUMN g_c[49],cl_numfor(sr1.amt3,49,t_azi05)
#NO.CHI-6A0004 --END
            END FOREACH
 
            PRINT
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT COLUMN g_c[37],g_dash2[1,g_w[37]],
                  COLUMN g_c[38],g_dash2[1,g_w[38]],
                  COLUMN g_c[39],g_dash2[1,g_w[39]],
                  COLUMN g_c[40],g_dash2[1,g_w[40]],
                  COLUMN g_c[41],g_dash2[1,g_w[41]],
                  COLUMN g_c[42],g_dash2[1,g_w[42]],
                  COLUMN g_c[43],g_dash2[1,g_w[43]],
                  COLUMN g_c[44],g_dash2[1,g_w[44]]
 
            PRINTX name = S1 COLUMN g_c[33],g_orderA[3] CLIPPED,
                             COLUMN g_c[34],sr.order3[1,10] CLIPPED,
                             COLUMN g_c[35],g_x[17] CLIPPED,
                             COLUMN g_c[36],sr.order3[11,20] CLIPPED,
                             COLUMN g_c[43],cl_numfor(GROUP SUM(sr.alh.alh37),43,g_azi05)
 
            PRINTX name = S2 COLUMN g_c[50],cl_numfor(GROUP SUM(sr.alh.alh16),50,g_azi05),
                             COLUMN g_c[52],cl_numfor(GROUP SUM(sr.alh.alh19),52,g_azi05),
                             COLUMN g_c[53],cl_numfor(GROUP SUM(sr.alh.alh36),53,g_azi05),
                             COLUMN g_c[54],cl_numfor(GROUP SUM(sr.alh.alh38),54,g_azi05)
 
            FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#              SELECT azi05 INTO l_azi05 FROM azi_file   #NO.CHI-6A0004
               SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                WHERE azi01 = sr1.curr
               LET sr1.curr = sr1.curr CLIPPED,':'
               PRINTX name = S1 COLUMN g_c[37],sr1.curr,
# NO.CHI-6A0004 --START
#                               COLUMN g_c[38],cl_numfor(sr1.amt1,38,l_azi05),
#                               COLUMN g_c[41],cl_numfor(sr1.amt2,41,l_azi05)
#              PRINTX name = S2 COLUMN g_c[49],cl_numfor(sr1.amt3,49,l_azi05)
                                COLUMN g_c[38],cl_numfor(sr1.amt1,38,t_azi05),
                                COLUMN g_c[41],cl_numfor(sr1.amt2,41,t_azi05)
               PRINTX name = S2 COLUMN g_c[49],cl_numfor(sr1.amt3,49,t_azi05)
# NO.CHI-6A0004 --END
            END FOREACH
 
            PRINT
         END IF
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'alh01,alh02,alh03,alh04,alh05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            #No.TQC-630166 --start--
#           IF tm.wc[001,070] > ' ' THEN            # for 80
#              PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#                    COLUMN g_c[32],tm.wc[001,070] CLIPPED
#           END IF
#           IF tm.wc[071,140] > ' ' THEN
#              PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#           END IF
#           IF tm.wc[141,210] > ' ' THEN
#              PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#           END IF
#           IF tm.wc[211,280] > ' ' THEN
#              PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#           END IF
            CALL cl_prt_pos_wc(tm.wc)
            #No.TQC-630166 ---end---
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-770093 --end--
