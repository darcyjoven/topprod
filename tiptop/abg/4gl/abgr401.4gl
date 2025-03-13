# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr401.4gl (copy from aglr401)
# Descriptions...: 預算財務比率分析表
# Date & Author..: 03/03/12 By Kammy
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0086 06/11/13 By baogui 報表問題修改
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740029 07/04/11 By johnray 會計科目加帳套
# Modify.........: NO.FUN-750025 07/07/25 BY TSD.liquor 改為crystal report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40162 10/04/28 By sabrina 預算編號改由理由碼維護
# Modify.........: No:CHI-A20007 10/10/28 By sabrina afc04='@'要mark掉
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
                          s1  LIKE type_file.num5,    #No.FUN-680061  SMALLINT
                          s2  LIKE type_file.num5,    #No.FUN-680061  SMALLINT 
                          s3  LIKE type_file.num5,    #No.FUN-680061  SMALLINT 
                          s4  LIKE type_file.num5,    #No.FUN-680061  SMALLINT 
                          s5  LIKE type_file.num5,    #No.FUN-680061  SMALLINT 
                          n1  LIKE type_file.chr10,   #LIKE cql_file.cql02,    #No.FUN-680061  VARCHAR(8)         #TQC-B90211 
                          n2  LIKE type_file.chr10,   #LIKE cql_file.cql02,    #No.FUN-680061  VARCHAR(8)
                          n3  LIKE type_file.chr10,   #LIKE cql_file.cql02,    #No.FUN-680061  VARCHAR(8)
                          n4  LIKE type_file.chr10,   #LIKE cql_file.cql02,    #No.FUN-680061  VARCHAR(8)
                          n5  LIKE type_file.chr10,   #LIKE cql_file.cql02,    #No.FUN-680061  VARCHAR(8)
              yy1 LIKE afc_file.afc03,  #第一期輸入年度
              yy2 LIKE afc_file.afc03,  #第二期輸入年度
              yy3 LIKE afc_file.afc03,  #第三期輸入年度
              yy4 LIKE afc_file.afc03,  #第四期輸入年度
              yy5 LIKE afc_file.afc03,  #第五期輸入年度
              m1  LIKE afc_file.afc05,  #第一期本期起始期別
              m4  LIKE afc_file.afc05,  #第一期本期截止期別
              m2  LIKE afc_file.afc05,  #第二期起始期別
              m5  LIKE afc_file.afc05,  #第二期截止期別
              m3  LIKE afc_file.afc05,  #第三期起始期別
              m6  LIKE afc_file.afc05,  #第三期截止期別
              m7  LIKE afc_file.afc05,  #第四期起始期別
              m9  LIKE afc_file.afc05,  #第四期截止期別
              m8  LIKE afc_file.afc05,  #第五期起始期別
              m0  LIKE afc_file.afc05,  #第五期截止期別
              budget1 LIKE afc_file.afc01,
              budget2 LIKE afc_file.afc01,
              budget3 LIKE afc_file.afc01,
              budget4 LIKE afc_file.afc01,
              budget5 LIKE afc_file.afc01,
              more    LIKE type_file.chr1,   #No.FUN-680061  VARCHAR(1)
              bookno  LIKE aaa_file.aaa01    #No.FUN-740029
              END RECORD,
#          g_bookno  LIKE afc_file.afc00,               #帳別   #No.FUN-740029
          g_tot ARRAY[5,31] OF LIKE afc_file.afc06,    #合計
          g_tot_b ARRAY[5,31] OF LIKE afc_file.afc06,  #上期合計
          g_eff ARRAY[5] OF LIKE afc_file.afc06,       #合計
          g_minus   LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(132)
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose    #No.FUN-680061 SMALLINT
DEFINE   g_aaa03    LIKE  aaa_file.aaa03
DEFINE   g_before_input_done  LIKE type_file.num5      #No.FUN-680061  SMALLINT
DEFINE   p_cmd      LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)
DEFINE   g_msg      LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(100)
DEFINE   g_cnt      LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE   g_str       STRING          # FUN-750025 TSD.liquor add
DEFINE   l_table     STRING          # FUN-750025 TSD.liquor add
DEFINE   g_sql       STRING          # FUN-750025 TSD.liquor add  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
 
   # add FUN-750025
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.liquor *** ##
   LET g_sql = "title.ze_file.ze03,",
               "msg01.ze_file.ze03,",
               "msg02.ze_file.ze03,",
               "msg03.ze_file.ze03,",
               "msg04.ze_file.ze03,",
               "num01.type_file.num20_6,",
               "num02.type_file.chr1000,",
               "tot01.type_file.chr1000,",
               "tot02.type_file.chr1000,",
               "tot03.type_file.chr1000,",
               "tot04.type_file.chr1000,",
               "tot05.type_file.chr1000,",
               "sort.type_file.num5,",
               "sort2.type_file.num5"
 
   LET l_table = cl_prt_temptable('abgr401',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750025
 
   LET g_trace = 'N'                    # default trace off
#   LET g_bookno = ARG_VAL(1)           #No.FUN-740029
   LET tm.bookno = ARG_VAL(1)           #No.FUN-740029
   LET g_pdate = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.s1  = ARG_VAL(8)
   LET tm.s2  = ARG_VAL(9)
   LET tm.s3  = ARG_VAL(10)
   LET tm.s4  = ARG_VAL(11)
   LET tm.s5  = ARG_VAL(12)
   LET tm.n1  = ARG_VAL(13)
   LET tm.n2  = ARG_VAL(14)
   LET tm.n3  = ARG_VAL(15)
   LET tm.n4  = ARG_VAL(16)
   LET tm.n5  = ARG_VAL(17)
   LET tm.yy1 = ARG_VAL(18)
   LET tm.yy2 = ARG_VAL(19)
   LET tm.yy3 = ARG_VAL(20)
   LET tm.yy4 = ARG_VAL(21)
   LET tm.yy5 = ARG_VAL(22)
   LET tm.m1 = ARG_VAL(23)
   LET tm.m2 = ARG_VAL(24)
   LET tm.m3 = ARG_VAL(25)
   LET tm.m7 = ARG_VAL(26)
   LET tm.m8 = ARG_VAL(27)
   LET tm.m4 = ARG_VAL(28)
   LET tm.m5 = ARG_VAL(29)
   LET tm.m6 = ARG_VAL(30)
   LET tm.m9 = ARG_VAL(31)
   LET tm.m0 = ARG_VAL(32)
   #-----TQC-610054---------
   LET tm.budget1 = ARG_VAL(33)
   LET tm.budget2 = ARG_VAL(34)
   LET tm.budget3 = ARG_VAL(35)
   LET tm.budget4 = ARG_VAL(36)
   LET tm.budget5 = ARG_VAL(37)
   #-----END TQC-610054-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(38)
   LET g_rep_clas = ARG_VAL(39)
   LET g_template = ARG_VAL(40)
   LET g_rpt_name = ARG_VAL(41)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-740029 -- begin --
#   IF cl_null(g_bookno) THEN
#      LET g_bookno = g_aaz.aaz64
#   END IF
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF
#No.FUN-740029 -- end --
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL abgr401_tm()                    # Input print condition
      ELSE CALL abgr401()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION abgr401_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680061  SMALLINT
          l_sw          LIKE type_file.chr1,    #重要欄位是否空白  #No.FUN-680061  VARCHAR(1)
          l_cmd         LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(400)
 
#   CALL s_dsmark(g_bookno)     #No.FUN-740029
   CALL s_dsmark(tm.bookno)     #No.FUN-740029
   LET p_row = 4 LET p_col = 5
   OPEN WINDOW abgr401_w AT p_row,p_col
        WITH FORM "abg/42f/abgr401"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno) #No.FUN-740029
   CALL s_shwact(0,0,tm.bookno) #No.FUN-740029
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL                      # Default condition
 
   #使用預設帳別之幣別
  SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = g_aaa.aaa03   #NO.CHI-6A0004
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_sw = 1
WHILE TRUE
    INPUT BY NAME tm.bookno,tm.s1,tm.n1,tm.yy1,tm.m1,tm.m4,tm.budget1,     #No.FUN-740029
                  tm.s2,tm.n2,tm.yy2,tm.m2,tm.m5,tm.budget2,
                  tm.s3,tm.n3,tm.yy3,tm.m3,tm.m6,tm.budget3,
                  tm.s4,tm.n4,tm.yy4,tm.m7,tm.m9,tm.budget4,
                  tm.s5,tm.n5,tm.yy5,tm.m8,tm.m0,tm.budget5,
                  tm.more WITHOUT DEFAULTS HELP 1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD s1
            IF tm.s1 IS NULL OR tm.s1 <1 OR tm.s1 > 14 THEN NEXT FIELD s1 END IF
            CASE tm.s1
                 WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n1
                 WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n1
                 WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n1
                 WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n1
                 WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n1
                 WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n1
                 WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n1
                 WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n1
                 WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n1
                 WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n1
                 WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n1
                 WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n1
                 WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n1
                 WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n1
                 OTHERWISE LET tm.n1 = ' '
            END CASE
            DISPLAY BY NAME tm.n1
 
      AFTER FIELD s2
            IF tm.s2 <1 OR tm.s2 > 14 THEN NEXT FIELD s2 END IF
            CASE tm.s2
                 WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n2
                 WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n2
                 WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n2
                 WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n2
                 WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n2
                 WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n2
                 WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n2
                 WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n2
                 WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n2
                 WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n2
                 WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n2
                 WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n2
                 WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n2
                 WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n2
                 OTHERWISE LET tm.n2 = ' '
            END CASE
            DISPLAY BY NAME tm.n2
 
      AFTER FIELD s3
            IF tm.s3 <1 OR tm.s3 > 14 THEN NEXT FIELD s3 END IF
            CASE tm.s3
                 WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n3
                 WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n3
                 WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n3
                 WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n3
                 WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n3
                 WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n3
                 WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n3
                 WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n3
                 WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n3
                 WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n3
                 WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n3
                 WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n3
                 WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n3
                 WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n3
                 OTHERWISE LET tm.n3 = ' '
            END CASE
            DISPLAY BY NAME tm.n3
 
      AFTER FIELD s4
            IF tm.s4 <1 OR tm.s4 > 14 THEN NEXT FIELD s4 END IF
            CASE tm.s4
                 WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n4
                 WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n4
                 WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n4
                 WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n4
                 WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n4
                 WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n4
                 WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n4
                 WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n4
                 WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n4
                 WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n4
                 WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n4
                 WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n4
                 WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n4
                 WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n4
                 OTHERWISE LET tm.n4 = ' '
            END CASE
            DISPLAY BY NAME tm.n4
 
 
      AFTER FIELD s5
            IF tm.s5 <1 OR tm.s5 > 14 THEN NEXT FIELD s5 END IF
            CASE tm.s5
                 WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n5
                 WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n5
                 WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n5
                 WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n5
                 WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n5
                 WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n5
                 WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n5
                 WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n5
                 WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n5
                 WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n5
                 WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n5
                 WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n5
                 WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n5
                 WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n5
                 OTHERWISE LET tm.n5 = ' '
            END CASE
            DISPLAY BY NAME tm.n5
 
#No.FUN-740029 -- begin --
      AFTER FIELD bookno
         IF tm.bookno IS NULL THEN
            CALL cl_err('','atm-339',0)
            NEXT FIELD bookno
         END IF
#No.FUN-740029 -- end --
 
      AFTER FIELD yy1
                 IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
                        NEXT FIELD yy1
                 END IF
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
#No.TQC-720032 -- begin --
#         IF tm.m1 <1 OR tm.m1 > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m1
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m2
         IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#         IF tm.m2 <1 OR tm.m2 > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m2
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m3
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m3) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy3
            IF g_azm.azm02 = 1 THEN
               IF tm.m3 > 12 OR tm.m3 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m3
               END IF
            ELSE
               IF tm.m3 > 13 OR tm.m3 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m3
               END IF
            END IF
         END IF
#         IF tm.m3 IS NOT NULL AND (tm.m3 <1 OR tm.m3 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m3
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m7
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m7) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy4
            IF g_azm.azm02 = 1 THEN
               IF tm.m7 > 12 OR tm.m7 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m7
               END IF
            ELSE
               IF tm.m7 > 13 OR tm.m7 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m7
               END IF
            END IF
         END IF
#         IF tm.m7 IS NOT NULL AND (tm.m7 <1 OR tm.m7 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m7
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m8
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m8) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy5
            IF g_azm.azm02 = 1 THEN
               IF tm.m8 > 12 OR tm.m8 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m8
               END IF
            ELSE
               IF tm.m8 > 13 OR tm.m8 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m8
               END IF
            END IF
         END IF
#         IF tm.m8 IS NOT NULL AND (tm.m8 <1 OR tm.m8 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m8
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m4
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m4) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.m4 > 12 OR tm.m4 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4
               END IF
            ELSE
               IF tm.m4 > 13 OR tm.m4 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4
               END IF
            END IF
         END IF
#         IF tm.m4 IS NOT NULL AND (tm.m4 <1 OR tm.m4 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m4
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m5
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m5) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
            IF g_azm.azm02 = 1 THEN
               IF tm.m5 > 12 OR tm.m5 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m5
               END IF
            ELSE
               IF tm.m5 > 13 OR tm.m5 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m5
               END IF
            END IF
         END IF
#         IF tm.m5 IS NOT NULL AND (tm.m5 <1 OR tm.m5 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m5
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m6
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m6) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy3
            IF g_azm.azm02 = 1 THEN
               IF tm.m6 > 12 OR tm.m6 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m6
               END IF
            ELSE
               IF tm.m6 > 13 OR tm.m6 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m6
               END IF
            END IF
         END IF
#         IF tm.m6 IS NOT NULL AND (tm.m6 <1 OR tm.m6 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m6
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m9
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m9) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy4
            IF g_azm.azm02 = 1 THEN
               IF tm.m9 > 12 OR tm.m9 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m9
               END IF
            ELSE
               IF tm.m9 > 13 OR tm.m9 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m9
               END IF
            END IF
         END IF
#         IF tm.m9 IS NOT NULL AND (tm.m9 <1 OR tm.m9 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m9
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD budget1
         IF NOT cl_null(tm.budget1) THEN
           #MOD-A40162---modify---start---
           #SELECT * FROM afa_file WHERE afa01=tm.budget1
           #                       AND afaacti IN ('Y','y')
           #                       AND afa00 = tm.bookno     #No.FUN-740029
            SELECT * FROM azf_file 
             WHERE azf01 = tm.budget1 AND azf02 = '2'
           #MOD-A40162---modify---end---
            IF STATUS THEN 
#              CALL cl_err('sel afa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","afa_file",tm.budget1,"",STATUS,"","sel afa:",0) #FUN-660105
               NEXT FIELD budget1 
            END IF
         END IF
      AFTER FIELD budget2
         IF NOT cl_null(tm.budget2) THEN
           #MOD-A40162---modify---start---
           #SELECT * FROM afa_file WHERE afa01=tm.budget2
           #                       AND afaacti IN ('Y','y')
           #                       AND afa00 = tm.bookno     #No.FUN-740029
            SELECT * FROM azf_file 
             WHERE azf01 = tm.budget2 AND azf02 = '2'
           #MOD-A40162---modify---end---
            IF STATUS THEN 
#              CALL cl_err('sel afa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","afa_file",tm.budget2,"",STATUS,"","sel afa:",0) #FUN-660105
               NEXT FIELD budget2 
            END IF
         END IF
      AFTER FIELD budget3
         IF NOT cl_null(tm.budget3) THEN
           #MOD-A40162---modify---start---
           #SELECT * FROM afa_file WHERE afa01=tm.budget3
           #                       AND afaacti IN ('Y','y')
           #                       AND afa00 = tm.bookno     #No.FUN-740029
            SELECT * FROM azf_file 
             WHERE azf01 = tm.budget3 AND azf02 = '2'
           #MOD-A40162---modify---end---
            IF STATUS THEN 
   #           CALL cl_err('sel afa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","afa_file",tm.budget3,"",STATUS,"","sel afa:",0) #FUN-660105
               NEXT FIELD budget3 
            END IF
         END IF
      AFTER FIELD budget4
         IF NOT cl_null(tm.budget4) THEN
           #MOD-A40162---modify---start---
           #SELECT * FROM afa_file WHERE afa01=tm.budget4
           #                       AND afaacti IN ('Y','y')
           #                       AND afa00 = tm.bookno     #No.FUN-740029
            SELECT * FROM azf_file 
             WHERE azf01 = tm.budget4 AND azf02 = '2'
           #MOD-A40162---modify---end---
            IF STATUS THEN 
#              CALL cl_err('sel afa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","afa_file",tm.budget4,"",STATUS,"","sel afa:",0) #FUN-660105
               NEXT FIELD budget4 
            END IF
         END IF
      AFTER FIELD budget5
         IF NOT cl_null(tm.budget5) THEN
           #MOD-A40162---modify---start---
           #SELECT * FROM afa_file WHERE afa01=tm.budget5
           #                       AND afaacti IN ('Y','y')
           #                       AND afa00 = tm.bookno     #No.FUN-740029
            SELECT * FROM azf_file 
             WHERE azf01 = tm.budget5 AND azf02 = '2'
           #MOD-A40162---modify---end---
            IF STATUS THEN 
#              CALL cl_err('sel afa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","afa_file",tm.budget5,"",STATUS,"","sel afa:",0) #FUN-660105
               NEXT FIELD budget5 
            END IF
         END IF
 
      AFTER FIELD m0
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m0) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy5
            IF g_azm.azm02 = 1 THEN
               IF tm.m0 > 12 OR tm.m0 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m0
               END IF
            ELSE
               IF tm.m0 > 13 OR tm.m0 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m0
               END IF
            END IF
         END IF
#         IF tm.m0 IS NOT NULL AND (tm.m0 <1 OR tm.m0 > 13) THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m0
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF tm.s1 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.s1 ATTRIBUTE(REVERSE)
               CALL cl_err('',9033,0)
            END IF
            IF tm.yy1 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy1 ATTRIBUTE(REVERSE)
               CALL cl_err('',9033,0)
            END IF
            IF tm.m1 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.m1 ATTRIBUTE(REVERSE)
               CALL cl_err('',9033,0)
            END IF
            IF tm.m4 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.m4 ATTRIBUTE(REVERSE)
               CALL cl_err('',9033,0)
            END IF
            IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD s1
               CALL cl_err('',9033,0)
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
      ON ACTION CONTROLP
         CASE
#No.FUN-740029 -- begin --
           WHEN INFIELD(bookno)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = tm.bookno
                   CALL cl_create_qry() RETURNING tm.bookno
                   DISPLAY tm.bookno TO bookno
            NEXT FIELD bookno
#No.FUN-740029 -- end --
          WHEN INFIELD(budget1)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_afa"    #MOD-A40162 mark 
                 LET g_qryparam.form ="q_azf"    #MOD-A40162 add 
                 LET g_qryparam.default1 = tm.budget1
                #LET g_qryparam.arg1 = tm.bookno       #No.FUN-740029 #MOD-A40162 mark
                 LET g_qryparam.arg1 = '2'             #MOD-A40162add 
                 CALL cl_create_qry() RETURNING tm.budget1
                 DISPLAY tm.budget1 TO budget1
            NEXT FIELD budget1
 
          WHEN INFIELD(budget2)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_afa"    #MOD-A40162 mark 
                 LET g_qryparam.form ="q_azf"    #MOD-A40162 add 
                 LET g_qryparam.default1 = tm.budget2
                #LET g_qryparam.arg1 = tm.bookno       #No.FUN-740029 #MOD-A40162 mark
                 LET g_qryparam.arg1 = '2'             #MOD-A40162add 
                 CALL cl_create_qry() RETURNING tm.budget2
                 DISPLAY tm.budget2 TO budget2
            NEXT FIELD budget2
 
           WHEN INFIELD(budget3)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_afa"    #MOD-A40162 mark 
                 LET g_qryparam.form ="q_azf"    #MOD-A40162 add 
                 LET g_qryparam.default1 = tm.budget3
                #LET g_qryparam.arg1 = tm.bookno       #No.FUN-740029 #MOD-A40162 mark
                 LET g_qryparam.arg1 = '2'             #MOD-A40162add 
                 CALL cl_create_qry() RETURNING tm.budget3
                 DISPLAY tm.budget3 TO budget3
            NEXT FIELD budget3
 
         WHEN INFIELD(budget4)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_afa"    #MOD-A40162 mark 
                 LET g_qryparam.form ="q_azf"    #MOD-A40162 add 
                 LET g_qryparam.default1 = tm.budget4
                #LET g_qryparam.arg1 = tm.bookno       #No.FUN-740029 #MOD-A40162 mark
                 LET g_qryparam.arg1 = '2'             #MOD-A40162add 
                 CALL cl_create_qry() RETURNING tm.budget4
                 DISPLAY tm.budget4 TO budget4
            NEXT FIELD budget4
         WHEN INFIELD(budget5)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_afa"    #MOD-A40162 mark 
                 LET g_qryparam.form ="q_azf"    #MOD-A40162 add 
                 LET g_qryparam.default1 = tm.budget5
                #LET g_qryparam.arg1 = tm.bookno       #No.FUN-740029 #MOD-A40162 mark
                 LET g_qryparam.arg1 = '2'             #MOD-A40162add 
                 CALL cl_create_qry() RETURNING tm.budget5
                 DISPLAY tm.budget5 TO budget5
            NEXT FIELD budget5
         END CASE
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
 
      #-----TQC-740001--------- 
      ON ACTION locale
         CALL cl_dynamic_locale()
      #-----END TQC-740001-----
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abgr401_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr401'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr401','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
#                         " '",g_bookno CLIPPED,"'",      #No.FUN-740029
                         " '",tm.bookno CLIPPED,"'",      #No.FUN-740029
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.s1 CLIPPED,"'",
                         " '",tm.s2 CLIPPED,"'",
                         " '",tm.s3 CLIPPED,"'",
                         " '",tm.s4 CLIPPED,"'",
                         " '",tm.s5 CLIPPED,"'",
                         " '",tm.n1 CLIPPED,"'",
                         " '",tm.n2 CLIPPED,"'",
                         " '",tm.n3 CLIPPED,"'",
                         " '",tm.n4 CLIPPED,"'",
                         " '",tm.n5 CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.yy3 CLIPPED,"'",
                         " '",tm.yy4 CLIPPED,"'",
                         " '",tm.yy5 CLIPPED,"'",
                         " '",tm.m1 CLIPPED,"'",
                         " '",tm.m2 CLIPPED,"'",
                         " '",tm.m3 CLIPPED,"'",
                         " '",tm.m7 CLIPPED,"'",
                         " '",tm.m8 CLIPPED,"'",
                         " '",tm.m4 CLIPPED,"'",
                         " '",tm.m5 CLIPPED,"'",
                         " '",tm.m6 CLIPPED,"'",
                         " '",tm.m9 CLIPPED,"'",
                         " '",tm.m0 CLIPPED,"'",
                         #-----TQC-610054---------
                         " '",tm.budget1 CLIPPED,"'",
                         " '",tm.budget2 CLIPPED,"'",
                         " '",tm.budget3 CLIPPED,"'",
                         " '",tm.budget4 CLIPPED,"'",
                         " '",tm.budget5 CLIPPED,"'",
                         #-----END TQC-610054-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr401',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW abgr401_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abgr401()
   ERROR ""
END WHILE
   CLOSE WINDOW abgr401_w
END FUNCTION
 
FUNCTION abgr401()
   DEFINE l_name        LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680061  VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0056
          l_sql         LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680061  VARCHAR(1000)
          l_yy          ARRAY[5] OF LIKE abk_file.abk03,  #No.FUN-680061  SMALLINT
          l_bm          ARRAY[5] OF LIKE aah_file.aah03,  #No.FUN-680061  SMALLINT
          l_em          ARRAY[5] OF LIKE aah_file.aah03,  #No.FUN-680061  SMALLINT
          l_budget      ARRAY[5] OF LIKE afa_file.afa01,  #No.FUN-680061  VARCHAR(4)
          l_tot         LIKE afc_file.afc06,    #合計
          l_aag06       LIKE aag_file.aag06,    #借貸別
          l_aag19       LIKE aag_file.aag19,    #財務比率分析類別
          l_yyb,l_yy1,l_bm1  LIKE type_file.num5,    #No.FUN-680061  SMALLINT
          l_chr         LIKE type_file.chr1,    #No.FUN-680061  VARCHAR(1)
          l_za05        LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(40)
   
   # add FUN-750025
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.liquor *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ----------------------------------#
   # end FUN-750025
 
     SELECT aaf03 INTO g_company FROM aaf_file
#        WHERE aaf01 = g_bookno AND aaf02 = g_rlang   #No.FUN-740029
        WHERE aaf01 = tm.bookno AND aaf02 = g_rlang   #No.FUN-740029
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abgr401'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF                 
     FOR g_i = 1 TO 132 LET g_dash[g_i,g_i]  = '=' END FOR    #TQC-6A0081
     FOR g_i = 1 TO 132 LET g_minus[g_i,g_i] = '-' END FOR    #TQC-6A0081
 
     FOR g_i = 1 to 31
         LET g_tot[1,g_i] = 0 LET g_tot[2,g_i] = 0 LET g_tot[3,g_i] = 0
         LET g_tot[4,g_i] = 0 LET g_tot[5,g_i] = 0
         LET g_tot_b[1,g_i] = 0 LET g_tot_b[2,g_i] = 0 LET g_tot_b[3,g_i] = 0
         LET g_tot_b[4,g_i] = 0 LET g_tot_b[5,g_i] = 0
         IF g_i <= 5 THEN
            LET g_eff[g_i] = 0
         END IF
     END FOR
     LET g_pageno = 0
     LET g_cnt    = 1
     LET l_yy[1]  = tm.yy1 LET l_bm[1] = tm.m1 LET l_em[1]= tm.m4
     LET l_yy[2]  = tm.yy2 LET l_bm[2] = tm.m2 LET l_em[2]= tm.m5
     LET l_yy[3]  = tm.yy3 LET l_bm[3] = tm.m3 LET l_em[3]= tm.m6
     LET l_yy[4]  = tm.yy4 LET l_bm[4] = tm.m7 LET l_em[4]= tm.m9
     LET l_yy[5]  = tm.yy5 LET l_bm[5] = tm.m8 LET l_em[5]= tm.m0
     LET l_budget[1] = tm.budget1
     LET l_budget[2] = tm.budget2
     LET l_budget[3] = tm.budget3
     LET l_budget[4] = tm.budget4
     LET l_budget[5] = tm.budget5
 
     FOR g_i = 1 TO 5
        IF l_yy[g_i] IS NULL OR l_yy[g_i]=0 THEN EXIT FOR END IF
        # 全數計算
        LET g_eff[g_i] = (l_em[g_i] - l_bm[g_i]+1) / 12
        LET l_sql = "SELECT aag06,aag19,SUM(afc06)",
                    "  FROM aag_file,afc_file",
                    " WHERE afc02 = aag01",
                   #"   AND afc04 = '@' ",           #整體預算   #CHI-A20007 mark
#                    "   AND afc00 = '",g_bookno,"'",   #No.FUN-740029
                    "   AND afc00 = '",tm.bookno,"'",   #No.FUN-740029
                    "   AND afc00 = aag00",             #No.FUN-740029
                    "   AND afc01 = ? ",
                    "   AND afc03 = ? ",
                    "   AND afc05 <=  ? ",
                    "   AND aag04 = '1'",
                    "   AND aag07 != '1'",
                    "   GROUP BY aag06,aag19"
        IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
        PREPARE abgr401_p1 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('p1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
           EXIT PROGRAM
        END IF
 
        DECLARE abgr401_c1 CURSOR FOR abgr401_p1
        FOREACH abgr401_c1 USING l_budget[g_i],l_yy[g_i],l_em[g_i]
                            INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
          END IF
 
          IF g_trace='Y' THEN DISPLAY l_aag19,' ',l_aag06 END IF
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 31 THEN CONTINUE FOREACH END IF
          LET g_tot[g_i,l_aag19] = g_tot[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE abgr401_c1
        LET l_yy1= l_yy[g_i]
        LET l_bm1= l_bm[g_i]  - 1
        IF l_bm1< 1 THEN
           LET l_bm1= 12
           LET l_yy1= l_yy1 -1
        END IF
        # 期初
        FOREACH abgr401_c1 USING l_budget[g_i],l_yy1,l_bm1
                           INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
          END IF
 
          IF g_trace='Y' THEN DISPLAY l_aag19,' ',l_aag06 END IF
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 31 THEN CONTINUE FOREACH END IF
          LET g_tot_b[g_i,l_aag19] = g_tot_b[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE abgr401_c1
     END FOR
 
     FOR g_i = 1 TO 5
        IF l_yy[g_i] IS NULL OR l_yy[g_i]=0 THEN EXIT FOR END IF
        LET l_sql = "SELECT aag06,aag19,SUM(afc06)",
                    " FROM aag_file,afc_file",
#                    " WHERE afc00 = '",g_bookno,"'",   #No.FUN-740029
                    " WHERE afc00 = '",tm.bookno,"'",   #No.FUN-740029
                    "   AND afc02 = aag01",
                   #"   AND afc04 = '@' ",     #整體預算   #CHI-A20007 mark
                    "   AND afc01 = '",l_budget[g_i],"'",
                    "   AND afc03 = ? ",
                    "   AND afc05 >= ",l_bm[g_i],
                    "   AND afc05 <= ",l_em[g_i],
                    "   AND aag04 = '2'",
                    "   AND aag07 != '1'",     # Jason 0427
                    "   GROUP BY aag06,aag19"
        IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
        PREPARE abgr401_p2 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('p1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
           EXIT PROGRAM
        END IF
 
        DECLARE abgr401_c2 CURSOR FOR abgr401_p2
        FOREACH abgr401_c2 USING l_yy[g_i] INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
          END IF
 
          IF g_trace='Y' THEN DISPLAY l_aag19,' ',l_aag06 END IF
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 31 THEN CONTINUE FOREACH END IF
 
          LET g_tot[g_i,l_aag19] = g_tot[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE abgr401_c2
        LET l_yyb = l_yy[g_i] -1
        #去年同期
        FOREACH abgr401_c2 USING l_yyb INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
          END IF
 
          IF g_trace='Y' THEN DISPLAY l_aag19,' ',l_aag06 END IF
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 31 THEN CONTINUE FOREACH END IF
 
          LET g_tot_b[g_i,l_aag19] = g_tot_b[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE abgr401_c2
     END FOR
 
     CALL cl_outnam('abgr401') RETURNING l_name
 
     CALL abgr401_ins_temp()  #FUN-750025 TSD.liquor add 
 
     # FUN-750025 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     LET g_str = tm.n5,";",tm.yy1,";",tm.yy2,";",tm.yy3,";",tm.yy4,";",tm.yy5,";",
                 tm.m1,";",tm.m2,";",tm.m3,";",
                 tm.m4,";",tm.m5,";",tm.m6,";",tm.m7,";",tm.m8,";",tm.m9,";",
                 tm.m0,";",tm.n1,";",tm.n2,";",tm.n3,";",tm.n4
 
     CALL cl_prt_cs3('abgr401','abgr401',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     # FUN-750025 end
 
END FUNCTION
 
#----------FUN-750025 TSD.liquor add start---------------------------
FUNCTION abgr401_ins_temp()
   DEFINE l_last_sw     LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
          l_tot ARRAY[5,36] OF LIKE type_file.num20_6, #No.FUN-680061 DEC(20,6)
          sr    ARRAY[5] OF RECORD
                        a               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
                        b               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        c               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        d               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        e               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        f               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        g               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        h               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)    
                        i               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        j               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)    
                        k               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        l               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        m               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        n               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        o               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        p               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        t               LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)   
                        u               LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6)
                                    END RECORD,
          l_n       LIKE type_file.num5          #No.FUN-680061  SMALLINT
  DEFINE  sr1   RECORD
                title                   LIKE ze_file.ze03,
                msg01                   LIKE ze_file.ze03,
                msg02                   LIKE ze_file.ze03,
                msg03                   LIKE ze_file.ze03,
                msg04                   LIKE ze_file.ze03,
                num01                   LIKE type_file.num20_6,
                num02                   LIKE type_file.chr1000,
                tot01                   LIKE type_file.chr1000,
                tot02                   LIKE type_file.chr1000,
                tot03                   LIKE type_file.chr1000,
                tot04                   LIKE type_file.chr1000,
                tot05                   LIKE type_file.chr1000,
                sort                    LIKE type_file.num5,
                sort2                   LIKE type_file.num5
                END RECORD
     #歸零
      FOR g_i = 1 TO 5
                  LET sr[g_i].a = 0  LET sr[g_i].b = 0 LET sr[g_i].c = 0
                  LET sr[g_i].d = 0  LET sr[g_i].e = 0 LET sr[g_i].f = 0
                  LET sr[g_i].g = 0  LET sr[g_i].h = 0 LET sr[g_i].i = 0
                  LET sr[g_i].j = 0  LET sr[g_i].k = 0 LET sr[g_i].l = 0
                  LET sr[g_i].m = 0  LET sr[g_i].n = 0 LET sr[g_i].o = 0
                  LET sr[g_i].p = 0  LET sr[g_i].t = 0  LET sr[g_i].u = 0
      END FOR
      FOR g_i = 1 TO 36
                  LET l_tot[1,g_i] = 0 LET l_tot[2,g_i] = 0 LET l_tot[3,g_i] = 0
                  LET l_tot[4,g_i] = 0 LET l_tot[5,g_i] = 0
      END FOR
     #流動資產的運算
      FOR g_i = 1 TO 8
          LET sr[1].a = sr[1].a + g_tot[1,g_i]   #第一期
          LET sr[2].a = sr[2].a + g_tot[2,g_i]   #第二期
          LET sr[3].a = sr[3].a + g_tot[3,g_i]   #第三期
          LET sr[4].a = sr[4].a + g_tot[4,g_i]   #第四期
          LET sr[5].a = sr[5].a + g_tot[5,g_i]   #第五期
      END FOR
     #流動負債的運算
      FOR g_i = 14 TO 16
          LET sr[1].b = sr[1].b + g_tot[1,g_i]   #第一期
          LET sr[2].b = sr[2].b + g_tot[2,g_i]   #第二期
          LET sr[3].b = sr[3].b + g_tot[3,g_i]   #第三期
          LET sr[4].b = sr[4].b + g_tot[4,g_i]   #第四期
          LET sr[5].b = sr[5].b + g_tot[5,g_i]   #第五期
      END FOR
     #速動資產的運算
          LET sr[1].c =  sr[1].a - g_tot[1,5] - g_tot[1,7]   #第一期
          LET sr[2].c =  sr[2].a - g_tot[2,5] - g_tot[2,7]   #第二期
          LET sr[3].c =  sr[3].a - g_tot[3,5] - g_tot[3,7]   #第三期
          LET sr[4].c =  sr[4].a - g_tot[4,5] - g_tot[4,7]   #第四期
          LET sr[5].c =  sr[5].a - g_tot[5,5] - g_tot[5,7]   #第五期
     #營運資金
      LET sr[1].d = sr[1].a - sr[1].b*-1          #第一期
      LET sr[2].d = sr[2].a - sr[2].b*-1          #第二期
      LET sr[3].d = sr[3].a - sr[3].b*-1          #第三期
      LET sr[4].d = sr[4].a - sr[4].b*-1          #第四期
      LET sr[5].d = sr[5].a - sr[5].b*-1          #第五期
      #資產總額
      FOR g_i = 1 TO 13
          LET sr[1].e = sr[1].e + g_tot[1,g_i]   #第一期
          LET sr[2].e = sr[2].e + g_tot[2,g_i]   #第二期
          LET sr[3].e = sr[3].e + g_tot[3,g_i]   #第三期
          LET sr[4].e = sr[4].e + g_tot[4,g_i]   #第四期
          LET sr[5].e = sr[5].e + g_tot[5,g_i]   #第五期
      END FOR
      #上期資產總額
      FOR g_i = 1 TO 13
          LET sr[1].t = sr[1].t + g_tot_b[1,g_i]   #第一期
          LET sr[2].t = sr[2].t + g_tot_b[2,g_i]   #第二期
          LET sr[3].t = sr[3].t + g_tot_b[3,g_i]   #第三期
          LET sr[4].t = sr[4].t + g_tot_b[4,g_i]   #第四期
          LET sr[5].t = sr[5].t + g_tot_b[5,g_i]   #第五期
      END FOR
 
     #銷貨淨額
      LET sr[1].f = g_tot[1,23]/(tm.m4-tm.m1 +1) * 12   #第一期
      LET sr[2].f = g_tot[2,23]/(tm.m5-tm.m2 +1) * 12   #第二期
      LET sr[3].f = g_tot[3,23]/(tm.m6-tm.m3 +1) * 12   #第三期
      LET sr[4].f = g_tot[4,23]/(tm.m9-tm.m7 +1) * 12   #第四期
      LET sr[5].f = g_tot[5,23]/(tm.m0-tm.m8 +1) * 12   #第五期
      #@@平均應收款項
      LET sr[1].g = (g_tot_b[1,3]+g_tot[1,3])/2             #第一期
      LET sr[2].g = (g_tot_b[2,3]+g_tot[2,3])/2             #第一期
      LET sr[3].g = (g_tot_b[3,3]+g_tot[3,3])/2             #第一期
      LET sr[4].g = (g_tot_b[4,3]+g_tot[4,3])/2             #第一期
      LET sr[5].g = (g_tot_b[5,3]+g_tot[5,3])/2             #第一期
      #@@平均存貨
      LET sr[1].h =(g_tot_b[1,5] + g_tot[1,5])/2             #第一期
      LET sr[2].h =(g_tot_b[2,5] + g_tot[2,5])/2             #第二期
      LET sr[3].h =(g_tot_b[3,5] + g_tot[3,5])/2             #第三期
      LET sr[4].h =(g_tot_b[4,5] + g_tot[4,5])/2             #第四期
      LET sr[5].h =(g_tot_b[5,5] + g_tot[5,5])/2             #第五期
     #基金及長期投資
      FOR g_i = 9 TO 11
          LET sr[1].i = sr[1].i + g_tot[1,g_i]   #第一期
          LET sr[2].i = sr[2].i + g_tot[2,g_i]   #第二期
          LET sr[3].i = sr[3].i + g_tot[3,g_i]   #第三期
          LET sr[4].i = sr[4].i + g_tot[4,g_i]   #第四期
          LET sr[5].i = sr[5].i + g_tot[5,g_i]   #第五期
      END FOR
     #負債總額
      FOR g_i = 14 TO 18
          LET sr[1].j = sr[1].j + g_tot[1,g_i]   #第一期
          LET sr[2].j = sr[2].j + g_tot[2,g_i]   #第二期
          LET sr[3].j = sr[3].j + g_tot[3,g_i]   #第三期
          LET sr[4].j = sr[4].j + g_tot[4,g_i]   #第四期
          LET sr[5].j = sr[5].j + g_tot[5,g_i]   #第五期
      END FOR
     #業主權益
      FOR g_i = 19 TO 22
          LET sr[1].k = sr[1].k + g_tot[1,g_i]   #第一期
          LET sr[2].k = sr[2].k + g_tot[2,g_i]   #第二期
          LET sr[3].k = sr[3].k + g_tot[3,g_i]   #第三期
          LET sr[4].k = sr[4].k + g_tot[4,g_i]   #第四期
          LET sr[5].k = sr[5].k + g_tot[5,g_i]   #第五期
      END FOR
     #上期業主權益
      FOR g_i = 19 TO 22
          LET sr[1].u = sr[1].u + g_tot_b[1,g_i]   #第一期
          LET sr[2].u = sr[2].u + g_tot_b[2,g_i]   #第二期
          LET sr[3].u = sr[3].u + g_tot_b[3,g_i]   #第三期
          LET sr[4].u = sr[4].u + g_tot_b[4,g_i]   #第四期
          LET sr[5].u = sr[5].u + g_tot_b[5,g_i]   #第五期
      END FOR
     #淨利(收入-成本)
    LET sr[1].l =(g_tot[1,23] *(-1))+(g_tot[1,24]*(-1))
                 - g_tot[1,25]- g_tot[1,26]
      LET sr[2].l =(g_tot[2,23] * -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]
      LET sr[3].l =(g_tot[3,23] * -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]
      LET sr[4].l =(g_tot[4,23] * -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]
      LET sr[5].l =(g_tot[5,23] * -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]
     #營業利益
      LET sr[1].n =(g_tot[1,23]* -1)-g_tot[1,25]-g_tot[1,27]    #第一期
      LET sr[2].n =(g_tot[2,23]* -1)-g_tot[2,25]-g_tot[2,27]    #第二期
      LET sr[3].n =(g_tot[3,23]* -1)-g_tot[3,25]-g_tot[3,27]    #第三期
      LET sr[4].n =(g_tot[4,23]* -1)-g_tot[4,25]-g_tot[4,27]    #第四期
      LET sr[5].n =(g_tot[5,23]* -1)-g_tot[5,25]-g_tot[5,27]    #第五期
     #稅前淨利
      LET sr[1].o =(g_tot[1,23]* -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]-   #第一期
                    g_tot[1,27]-g_tot[1,28]-g_tot[1,31]
      LET sr[2].o =(g_tot[2,23]* -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]-   #第二期
                    g_tot[2,27]-g_tot[2,28]-g_tot[2,31]
      LET sr[3].o =(g_tot[3,23]* -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]-   #第三期
                    g_tot[3,27]-g_tot[3,28]-g_tot[3,31]
      LET sr[4].o =(g_tot[4,23]* -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]-   #第四期
                    g_tot[4,27]-g_tot[4,28]-g_tot[4,31]
      LET sr[5].o =(g_tot[5,23]* -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]-   #第五期
                    g_tot[5,27]-g_tot[5,28]-g_tot[5,31]
 
     #純益
      LET sr[1].p =(g_tot[1,23]* -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]-   #第一期
                    g_tot[1,27]-g_tot[1,28]-g_tot[1,29]+g_tot[1,30]-g_tot[1,31]
      LET sr[2].p =(g_tot[2,23]* -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]-   #第二期
                    g_tot[2,27]-g_tot[2,28]-g_tot[2,29]+g_tot[2,30]-g_tot[2,31]
      LET sr[3].p =(g_tot[3,23]* -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]-   #第三期
                    g_tot[3,27]-g_tot[3,28]-g_tot[3,29]+g_tot[3,30]-g_tot[3,31]
      LET sr[4].p =(g_tot[4,23]* -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]-   #第四期
                    g_tot[4,27]-g_tot[4,28]-g_tot[4,29]+g_tot[4,30]-g_tot[4,31]
      LET sr[5].p =(g_tot[5,23]* -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]-   #第五期
                    g_tot[5,27]-g_tot[5,28]-g_tot[5,29]+g_tot[5,30]-g_tot[5,31]
     #銷貨成本
      LET g_tot[1,25] = g_tot[1,25]/(tm.m4-tm.m1 +1) * 12   #第一期
      LET g_tot[2,25] = g_tot[2,25]/(tm.m5-tm.m2 +1) * 12   #第二期
      LET g_tot[3,25] = g_tot[3,25]/(tm.m6-tm.m3 +1) * 12   #第三期
      LET g_tot[4,25] = g_tot[4,25]/(tm.m9-tm.m7 +1) * 12   #第四期
      LET g_tot[5,25] = g_tot[5,25]/(tm.m0-tm.m8 +1) * 12   #第五期
     #五年度的財務比率計算
      FOR g_i = 1 TO 5
          #流動負債不為零
          IF sr[g_i].b != 0 THEN
                                #流動比率 (流動資產/流動負債)
             LET l_tot[g_i,1] = sr[g_i].a/sr[g_i].b * 100
                                #酸性測驗 (速動資產/流動負債)
             LET l_tot[g_i,2] = sr[g_i].c/sr[g_i].b * 100
          END IF
          #資產總額不為零
          IF sr[g_i].e != 0 THEN
                         #營運資金比率 (營運資金/資產總額)
             LET l_tot[g_i,3] = sr[g_i].d/sr[g_i].e * 100
                         #流動資產佔資產總額比率 (流動資產/資產總額)
             LET l_tot[g_i,9] = sr[g_i].a/sr[g_i].e * 100
                         #基金及長期投資佔資產總額比率 (基金及長期投資/資產總額)
             LET l_tot[g_i,10] = sr[g_i].i/sr[g_i].e * 100
                         #固定資產佔資產總額比率 (固定資產/資產總額)
             LET l_tot[g_i,11] = g_tot[g_i,12]/sr[g_i].e * 100
                         #其它資產佔資產總額比率 (其它資產/資產總額)
             LET l_tot[g_i,12] = g_tot[g_i,13]/sr[g_i].e * 100
                         #負債總額佔資產總額比率 (負債總額/資產總額)
             LET l_tot[g_i,19] = sr[g_i].j/sr[g_i].e * 100
                         #業主權益佔資產總額比率 (業主權益/資產總額)
             LET l_tot[g_i,20] = sr[g_i].k/sr[g_i].e * 100
                         #資產報酬率 (淨利/資產總額)
                         #資產報酬率 [(純益+利息費用(1-25%)]/平均資產總額)
            #LET l_tot[g_i,25] = sr[g_i].l/sr[g_i].e * 100
            #LET l_tot[g_i,25] = (sr[g_i].p+g_tot[g_i,31]*0.75)/sr[g_i].e * 100
             LET l_tot[g_i,25] = (sr[g_i].p+(g_tot[g_i,31]*0.75))/
                                 ((sr[g_i].e+sr[g_i].t)/2) * 100
                         #資產週轉率 (銷貨淨額/資產總額)
            #LET l_tot[g_i,27] = (sr[g_i].f/sr[g_i].e) *g_eff[g_i] * 100
             LET l_tot[g_i,27] = (sr[g_i].f/sr[g_i].e)
          END IF
          #流動資產不為零
          IF sr[g_i].a != 0 THEN
                         #流動資產週轉率 (銷貨淨額/流動資產)
            #LET l_tot[g_i,6] = (sr[g_i].f/sr[g_i].a) * g_eff[g_i]
             LET l_tot[g_i,6] = (sr[g_i].f/sr[g_i].a)
                         #現金佔流動資產比率 (現金/流動資產)
             LET l_tot[g_i,13] = g_tot[g_i,1]/sr[g_i].a * 100
                         #短期投資佔流動資產比率 (短期投資/流動資產)
             LET l_tot[g_i,14] = g_tot[g_i,2]/sr[g_i].a * 100
                         #應收款項佔流動資產比率 (應收款項/流動資產)
             LET l_tot[g_i,15] =(g_tot[g_i,3]+g_tot[g_i,4])/sr[g_i].a * 100
                         #存貨佔流動資產比率 (存貨/流動資產)
           # LET l_tot[g_i,16] = sr[g_i].h/sr[g_i].a * 100
             LET l_tot[g_i,16] = (g_tot[g_i,5]+g_tot[g_i,6])/sr[g_i].a * 100
                         #預付款項佔流動資產比率 (預付款項/流動資產)
             LET l_tot[g_i,17] = g_tot[g_i,7]/sr[g_i].a * 100
                         #其它流動資產佔流動資產比率 (其它流動資產/流動資產)
             LET l_tot[g_i,18] = g_tot[g_i,8]/sr[g_i].a * 100
          END IF
          #固定資產不為零
          IF g_tot[g_i,12] != 0 THEN
                 #固定資產週轉率 (銷貨淨額/固定資產)
            #LET l_tot[g_i,28] = (sr[g_i].f/g_tot[g_i,12]) * g_eff[g_i]
             LET l_tot[g_i,28] = (sr[g_i].f/g_tot[g_i,12])
                 #長期資金佔固定資產比率 (股東權益+長期負債/固定資產)
             LET l_tot[g_i,29] = (sr[g_i].k+g_tot[g_i,17])/g_tot[g_i,12] * 100
          END IF
          #負債總額不為零
          IF sr[g_i].j != 0 THEN
                         #業主權益佔負債總額比率 (業主權益/流動負債)
             LET l_tot[g_i,21] = sr[g_i].k/sr[g_i].j * 100
          END IF
          #長期負債不為零
          IF g_tot[g_i,17] != 0 THEN
                         #固定資產對長期負債比率 (固定資產/長期負債)
             LET l_tot[g_i,22] = g_tot[g_i,12]/g_tot[g_i,17] * 100
          END IF
          #業主權益不為零
          IF sr[g_i].k != 0 THEN
                         #固定資產對業主權益的比率 (固定資產/業主權益)
             LET l_tot[g_i,23] = g_tot[g_i,12]/sr[g_i].k * 100
                         #資本報酬率 (淨利/平均業主權益)
            #LET l_tot[g_i,26] = sr[g_i].l/sr[g_i].k * 100
            #LET l_tot[g_i,26] = sr[g_i].l/
             LET l_tot[g_i,26] = sr[g_i].p/
                                 ((sr[g_i].k+sr[g_i].u)/2) * 100
          END IF
          #銷貨淨額不為零
          IF sr[g_i].f != 0 THEN
                         #利潤率 (淨利/銷貨淨額)
             LET l_tot[g_i,24] = sr[g_i].l/sr[g_i].f * 100
          END IF
          #平均存貨不為零
          IF sr[g_i].h != 0 THEN
                         #存貨週轉率 (銷貨成本/平均存貨)
            #LET l_tot[g_i,7] = (g_tot[g_i,25]/sr[g_i].h) * g_eff[g_i]
             LET l_tot[g_i,7] = (g_tot[g_i,25]/sr[g_i].h)
          END IF
          #存貨週轉率不為零
          IF l_tot[g_i,7] != 0 THEN
                         #存貨維持日數 (日數/存貨週轉率)
            #LET l_tot[g_i,8] = 365 /l_tot[g_i,7] * 100
            #LET l_tot[g_i,8] = 365 /l_tot[g_i,7]
             LET l_tot[g_i,8] = 365*g_eff[g_i]/l_tot[g_i,7]
          END IF
          #應收款項不為零
         #IF g_tot[g_i,3] != 0 THEN
          IF sr[g_i].g != 0 THEN
                         #應收款項週轉率 (銷貨淨額/應收款項)
            #LET l_tot[g_i,4] = (sr[g_i].f/sr[g_i].g) * g_eff[g_i]
             LET l_tot[g_i,4] = (sr[g_i].f/sr[g_i].g)
          END IF
          #應收款項率不為零
          IF l_tot[g_i,4] != 0 THEN
                 #應收款項維持日數 (日數/應收款項週轉率)
            #LET l_tot[g_i,5] = 365 /l_tot[g_i,4] * 100
            #LET l_tot[g_i,5] = 365 /l_tot[g_i,4]
             LET l_tot[g_i,5] = 365*g_eff[g_i]/l_tot[g_i,4]
          END IF
          #股本不為零
          IF g_tot[g_i,19] != 0 THEN
                 #營業利益佔實收資本比率 (營業利益/股本)
             LET l_tot[g_i,30] = sr[g_i].n/g_tot[g_i,19] * 100
                 #稅前淨利佔實收資本比率 (稅前淨利/股本)
             LET l_tot[g_i,31] = sr[g_i].o/g_tot[g_i,19] * 100
                 #稅前每股盈餘           (稅前淨利/股數)
             LET l_tot[g_i,34] = sr[g_i].o/g_tot[g_i,19]*10
                 #稅後每股盈餘           (稅前淨利-所得稅)/股數)
             LET l_tot[g_i,35] =(sr[g_i].o-g_tot[g_i,29])/g_tot[g_i,19]*10
          END IF
          #銷貨淨額不為零
          IF g_tot[g_i,23] != 0 THEN
                 #毛利率 (營業毛利/銷貨淨額)
            #LET l_tot[g_i,32] = sr[g_i].f/g_tot[g_i,23] * 100
             LET l_tot[g_i,32] = sr[g_i].l /g_tot[g_i,23] * 100
                 #營業利益率 (營業利益/銷貨淨額)
             LET l_tot[g_i,33] = sr[g_i].n/g_tot[g_i,23] * 100
          END IF
          #利息費用不為零
          IF g_tot[g_i,31] != 0 THEN
                 #利息保障倍數
             LET l_tot[g_i,36] = (sr[g_i].o+g_tot[g_i,31]) /g_tot[g_i,31]
          END IF
       END FOR
       #------------------------------------------
       #股東權益對資產總額比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-022',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-023',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-024',g_lang)
       LET sr1.num01 = sr[1].k
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,20] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,20] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,20] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,20] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,20] USING'###,###.&&','%'
       LET sr1.sort = 1
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
       #負債總額對資產總額比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-025',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-026',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-027',g_lang)
       LET sr1.num01 = sr[1].j
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,19] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,19] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,19] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,19] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,19] USING'###,###.&&','%'
       LET sr1.sort = 2
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #長期資金對固定資產總額比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-028',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-029',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-030',g_lang)
       LET sr1.num01 = sr[1].k+g_tot[1,17]
       LET sr1.num02 = g_tot[1,12] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,29] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,29] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,29] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,29] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,29] USING'###,###.&&','%'
       LET sr1.sort = 3
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #營運資金比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-031',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-032',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-033',g_lang)
       LET sr1.num01 = sr[1].d
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,3] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,3] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,3] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,3] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,3] USING'###,###.&&','%'
       LET sr1.sort = 4
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #流動資產佔資產總額比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-034',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-035',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-036',g_lang)
       LET sr1.num01 = sr[1].a
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,9] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,9] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,9] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,9] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,9] USING'###,###.&&','%'	
       LET sr1.sort = 5
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #基金及長期投資佔資產總額比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-037',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-038',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-039',g_lang)
       LET sr1.num01 = sr[1].i
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,10] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,10] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,10] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,10] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,10] USING'###,###.&&','%'
       LET sr1.sort = 6
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #固定資產佔資產總額比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-040',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-041',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-042',g_lang)
       LET sr1.num01 = g_tot[1,12]
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,11] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,11] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,11] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,11] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,11] USING'###,###.&&','%'
       LET sr1.sort = 6
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #其它資產佔資產總額比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-043',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-044',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-045',g_lang)
       LET sr1.num01 = g_tot[1,13]
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,12] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,12] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,12] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,12] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,12] USING'###,###.&&','%'
       LET sr1.sort = 7
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #現金佔流動資產比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-046',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-047',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-048',g_lang)
       LET sr1.num01 = g_tot[1,1]
       LET sr1.num02 = sr[1].a USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,13] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,13] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,13] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,13] USING'###,###.&&','%' 
       LET sr1.tot05 = l_tot[5,13] USING'###,###.&&','%'
       LET sr1.sort = 8
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #短期投資佔流動資產比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-049',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-050',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-051',g_lang)
       LET sr1.num01 = g_tot[1,2] 
       LET sr1.num02 = sr[1].a USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,14] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,14] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,14] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,14] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,14] USING'###,###.&&','%'
       LET sr1.sort = 9
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #應收款項佔流動資產比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-052',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-053',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-054',g_lang)
       LET sr1.num01 = g_tot[1,3]+g_tot[1,4]
       LET sr1.num02 = sr[1].a USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,15] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,15] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,15] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,15] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,15] USING'###,###.&&','%'
       LET sr1.sort = 10
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #存貨佔流動資產比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-055',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-056',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-057',g_lang)
       LET sr1.num01 = g_tot[1,5]+g_tot[1,6]
       LET sr1.num02 = sr[1].a USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,16] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,16] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,16] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,16] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,16] USING'###,###.&&','%'
       LET sr1.sort = 11
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #預付款項佔流動資產比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-058',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-059',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-060',g_lang)
       LET sr1.num01 = g_tot[1,7]
       LET sr1.num02 = sr[1].a USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,17] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,17] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,17] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,17] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,17] USING'###,###.&&','%'
       LET sr1.sort = 12
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #其它流動資產佔流動資產比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-061',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-062',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-063',g_lang)
       LET sr1.num01 = g_tot[1,8] 
       LET sr1.num02 = sr[1].a USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,18] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,18] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,18] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,18] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,18] USING'###,###.&&','%'
       LET sr1.sort = 13
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #固定資產對長期負債之比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-064',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-065',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-066',g_lang)
       LET sr1.num01 = g_tot[1,12]
       LET sr1.num02 = g_tot[1,17] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,22] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,22] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,22] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,22] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,22] USING'###,###.&&','%'
       LET sr1.sort = 14
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #固定資產對業主益權比率
       LET sr1.title = cl_getmsg('abg-021',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-067',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-068',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-069',g_lang)
       LET sr1.num01 = g_tot[1,12]
       LET sr1.num02 = sr[1].k USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,23] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,23] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,23] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,23] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,23] USING'###,###.&&','%'
       LET sr1.sort = 15
       LET sr1.sort2 = 1
       EXECUTE insert_prep USING sr1.*
 
      #流動比率
       LET sr1.title = cl_getmsg('abg-070',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-071',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-072',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-073',g_lang)
       LET sr1.num01 = sr[1].a
       LET sr1.num02 = sr[1].b USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,1] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,1] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,1] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,1] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,1] USING'###,###.&&','%'
       LET sr1.sort = 16
       LET sr1.sort2 = 2
       EXECUTE insert_prep USING sr1.*
 
      #酸性測驗
       LET sr1.title = cl_getmsg('abg-070',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-074',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-075',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-076',g_lang)
       LET sr1.num01 = sr[1].c
       LET sr1.num02 = sr[1].b USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,2] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,2] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,2] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,2] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,2] USING'###,###.&&','%'
       LET sr1.sort = 17
       LET sr1.sort2 = 2
       EXECUTE insert_prep USING sr1.*
 
      #利息保障倍數
       LET sr1.title = cl_getmsg('abg-070',g_lang)
       LET sr1.msg01 = ' '
       LET sr1.msg02 = ' '
       LET sr1.msg03 = ' '
       LET sr1.num01 = sr[1].o + g_tot[1,31]
       LET sr1.num02 = g_tot[1,31] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,36] USING'###,###.&&'
       LET sr1.tot02 = l_tot[2,36] USING'###,###.&&'
       LET sr1.tot03 = l_tot[3,36] USING'###,###.&&'
       LET sr1.tot04 = l_tot[4,36] USING'###,###.&&'
       LET sr1.tot05 = l_tot[5,36] USING'###,###.&&'
       LET sr1.sort = 18
       LET sr1.sort2 = 2
       EXECUTE insert_prep USING sr1.*
 
      #應收款項週轉率
       LET sr1.title = cl_getmsg('abg-077',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-078',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-079',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-080',g_lang)
       LET sr1.num01 = sr[1].f
       LET sr1.num02 = sr[1].g USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,4] USING'###,###.&&','次'
       LET sr1.tot02 = l_tot[2,4] USING'###,###.&&','次'
       LET sr1.tot03 = l_tot[3,4] USING'###,###.&&','次'
       LET sr1.tot04 = l_tot[4,4] USING'###,###.&&','次'
       LET sr1.tot05 = l_tot[5,4] USING'###,###.&&','次'
       LET sr1.sort = 19
       LET sr1.sort2 = 3
       EXECUTE insert_prep USING sr1.*
 
      #平均收款日數
       LET sr1.title = cl_getmsg('abg-077',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-081',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-082',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-083',g_lang)
       LET sr1.num01 = 365*g_eff[1]
       LET sr1.num02 = l_tot[1,4] USING '###.&&'
       LET sr1.tot01 = l_tot[1,5] USING'###,###.&&','天'
       LET sr1.tot02 = l_tot[2,5] USING'###,###.&&','天'
       LET sr1.tot03 = l_tot[3,5] USING'###,###.&&','天'
       LET sr1.tot04 = l_tot[4,5] USING'###,###.&&','天'
       LET sr1.tot05 = l_tot[5,5] USING'###,###.&&','天'
       LET sr1.sort = 20
       LET sr1.sort2 = 3
       EXECUTE insert_prep USING sr1.*
 
      #存貨週轉率
       LET sr1.title = cl_getmsg('abg-077',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-084',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-085',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-086',g_lang)
       LET sr1.num01 = g_tot[1,25] 
       LET sr1.num02 = sr[1].h USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,7] USING'###,###.&&','次'
       LET sr1.tot02 = l_tot[2,7] USING'###,###.&&','次'
       LET sr1.tot03 = l_tot[3,7] USING'###,###.&&','次'
       LET sr1.tot04 = l_tot[4,7] USING'###,###.&&','次'
       LET sr1.tot05 = l_tot[5,7] USING'###,###.&&','次'
       LET sr1.sort = 21
       LET sr1.sort2 = 3
       EXECUTE insert_prep USING sr1.*
 
      #存貨維持日數
       LET sr1.title = cl_getmsg('abg-077',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-087',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-088',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-089',g_lang)
       LET sr1.num01 = 365*g_eff[1]
       LET sr1.num02 = l_tot[1,7] USING '###.&&'
       LET sr1.tot01 = l_tot[1,8] USING'###,###.&&','天'
       LET sr1.tot02 = l_tot[2,8] USING'###,###.&&','天'
       LET sr1.tot03 = l_tot[3,8] USING'###,###.&&','天'
       LET sr1.tot04 = l_tot[4,8] USING'###,###.&&','天'
       LET sr1.tot05 = l_tot[5,8] USING'###,###.&&','天'
       LET sr1.sort = 22
       LET sr1.sort2 = 3
       EXECUTE insert_prep USING sr1.*
 
      #流動資產週轉率
       LET sr1.title = cl_getmsg('abg-077',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-090',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-091',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-092',g_lang)
       LET sr1.num01 = sr[1].f 
       LET sr1.num02 = sr[1].a USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,6] USING'###,###.&&','次'
       LET sr1.tot02 = l_tot[2,6] USING'###,###.&&','次'
       LET sr1.tot03 = l_tot[3,6] USING'###,###.&&','次'
       LET sr1.tot04 = l_tot[4,6] USING'###,###.&&','次'
       LET sr1.tot05 = l_tot[5,6] USING'###,###.&&','次'
       LET sr1.sort = 23
       LET sr1.sort2 = 3
       EXECUTE insert_prep USING sr1.*
 
      #固定資產週轉率
       LET sr1.title = cl_getmsg('abg-077',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-093',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-094',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-095',g_lang)
       LET sr1.num01 = sr[1].f 
       LET sr1.num02 = g_tot[1,12] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,28] USING'###,###.&&','次'
       LET sr1.tot02 = l_tot[2,28] USING'###,###.&&','次'
       LET sr1.tot03 = l_tot[3,28] USING'###,###.&&','次'
       LET sr1.tot04 = l_tot[4,28] USING'###,###.&&','次'
       LET sr1.tot05 = l_tot[5,28] USING'###,###.&&','次'
       LET sr1.sort = 24
       LET sr1.sort2 = 3
       EXECUTE insert_prep USING sr1.*
 
      #資產週轉率
       LET sr1.title = cl_getmsg('abg-077',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-096',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-097',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-098',g_lang)
       LET sr1.num01 = sr[1].f 
       LET sr1.num02 = sr[1].e USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,27] USING'###,###.&&','次'
       LET sr1.tot02 = l_tot[2,27] USING'###,###.&&','次'
       LET sr1.tot03 = l_tot[3,27] USING'###,###.&&','次'
       LET sr1.tot04 = l_tot[4,27] USING'###,###.&&','次'
       LET sr1.tot05 = l_tot[5,27] USING'###,###.&&','次'
       LET sr1.sort = 25
       LET sr1.sort2 = 3
       EXECUTE insert_prep USING sr1.*
 
      #四.獲利能力%
      #資產報酬率
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-100',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-101',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-102',g_lang)
       LET sr1.num01 = sr[1].p+(g_tot[1,31]*0.75)
       LET sr1.num02 = (sr[1].e+sr[1].t)/2 USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,25] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,25] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,25] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,25] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,25] USING'###,###.&&','%'
       LET sr1.sort = 26
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #股東權益報酬率
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-103',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-104',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-105',g_lang)
       LET sr1.num01 = sr[1].p
       LET sr1.num02 = (sr[1].k+sr[1].u)/2 USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,26] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,26] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,26] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,26] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,26] USING'###,###.&&','%'
       LET sr1.sort = 27
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #營業利益佔實收資本比率
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-106',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-107',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-108',g_lang)
       LET sr1.num01 = sr[1].n
       LET sr1.num02 = g_tot[1,19] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,30] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,30] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,30] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,30] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,30] USING'###,###.&&','%'
       LET sr1.sort = 28
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #稅前純益佔實收資本比率
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-109',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-110',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-111',g_lang)
       LET sr1.num01 = sr[1].o
       LET sr1.num02 = g_tot[1,19] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,31] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,31] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,31] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,31] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,31] USING'###,###.&&','%'
       LET sr1.sort = 29
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #毛利率
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-112',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-113',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-114',g_lang)
       LET sr1.num01 = sr[1].l
       LET sr1.num02 = g_tot[1,23] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,32] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,32] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,32] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,32] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,32] USING'###,###.&&','%'
       LET sr1.sort = 30
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #營業利益率
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-115',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-116',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-117',g_lang)
       LET sr1.num01 = sr[1].n
       LET sr1.num02 = g_tot[1,23] USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,33] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,33] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,33] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,33] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,33] USING'###,###.&&','%'
       LET sr1.sort = 31
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #稅前每股盈餘
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-118',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-119',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-120',g_lang)
       LET sr1.num01 = sr[1].o
       LET sr1.num02 = g_tot[1,19]/10 USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,34] USING'###,###.&&'
       LET sr1.tot02 = l_tot[2,34] USING'###,###.&&'
       LET sr1.tot03 = l_tot[3,34] USING'###,###.&&'
       LET sr1.tot04 = l_tot[4,34] USING'###,###.&&'
       LET sr1.tot05 = l_tot[5,34] USING'###,###.&&'
       LET sr1.sort = 32
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #稅後每股盈餘
       LET sr1.title = cl_getmsg('abg-099',g_lang)
       LET sr1.msg01 = ' '
       LET sr1.msg02 = ' '
       LET sr1.msg03 = ' '
       LET sr1.num01 = sr[1].o-g_tot[1,29]
       LET sr1.num02 = g_tot[1,19]/10 USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,35] USING'###,###.&&'
       LET sr1.tot02 = l_tot[2,35] USING'###,###.&&'
       LET sr1.tot03 = l_tot[3,35] USING'###,###.&&'
       LET sr1.tot04 = l_tot[4,35] USING'###,###.&&'
       LET sr1.tot05 = l_tot[5,35] USING'###,###.&&'
       LET sr1.sort = 33
       LET sr1.sort2 = 4
       EXECUTE insert_prep USING sr1.*
 
      #五.業主權益對負債總額比率
       LET sr1.title = cl_getmsg('abg-121',g_lang)
       LET sr1.msg01 = cl_getmsg('abg-121',g_lang)
       LET sr1.msg02 = cl_getmsg('abg-122',g_lang)
       LET sr1.msg03 = cl_getmsg('abg-123',g_lang)
       LET sr1.num01 = sr[1].k
       LET sr1.num02 = sr[1].j USING '<<,<<<,<<<,<<&'
       LET sr1.tot01 = l_tot[1,21] USING'###,###.&&','%'
       LET sr1.tot02 = l_tot[2,21] USING'###,###.&&','%'
       LET sr1.tot03 = l_tot[3,21] USING'###,###.&&','%'
       LET sr1.tot04 = l_tot[4,21] USING'###,###.&&','%'
       LET sr1.tot05 = l_tot[5,21] USING'###,###.&&','%'
       LET sr1.sort = 34
       LET sr1.sort2 = 5
       EXECUTE insert_prep USING sr1.*
 
       #------------------------------------------     
 
END FUNCTION
#-----------FUN-750025 add end--------------------------
#Patch....NO.TQC-610035 <001,002> #
