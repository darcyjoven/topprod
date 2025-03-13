# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg401.4gl
# Descriptions...: 財務比率分析表
# Date & Author..: 01/04/17 By Jason
# Modify.........: No.FUN-580010 05/08/09 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.MOD-5B0029 05/11/22 By Nicola 銷貨淨額、銷貨成本、速動資產計算修改
# Modify.........: No.TQC-620043 06/02/16 By Smapmin 財務分析類別新增32~37
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie 增加“總頁數”
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By Lynn 會計科目加帳套
# Modify.........: No.FUN-780061 07/09/03 By zhoufeng 報表輸出打印改為Crystal Report
# Modify.........: No.CHI-860004 08/12/16 By Sarah 1.流動負債的運算增加18
#                                                  2.畫面增加tm.a(銷貨淨額與銷貨成本依平均存貨方式計算),
#                                                    sr[1~5].f,g_eff[g_i],g_tot[1~5,25]依tm.a改變計算方式
#                                                  3."利息保障倍數"與"稅後每股盈餘"報表說明增加p_ze:abg-124~abg-129
# Modify.........: No.CHI-890029 08/12/16 By Sarah 純益=(23類*-1)+(24類*-1)-25類-26類-27類-28類-29類-31類-37類,移除30類
# Modify.........: No.MOD-920199 09/02/16 By Sarah l_sql中須加入aag09='Y'的條件
# Modify.........: No.MOD-920254 09/02/20 By Sarah 金額取位修正
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/19 By vealxu  精簡程式碼
# Modify.........: No:CHI-A40061 10/05/04 By Summer 餘額檔增加 aaz31 過濾
# Modify.........: No:MOD-A60008 10/06/04 By Dido 調整語法 
# Modify.........: No:MOD-AB0115 10/11/11 By Dido 調整語法 
# Modify.........: No.MOD-AB0186 10/11/19 By Dido 貸餘科目應呈現正數,在計算上再 * -1
# Midify.........: No.FUN-B90028 11/09/07 BY qirl明細CR報表轉GRW 
# Midify.........: No.FUN-B90028 12/01/06 By qirl FUN-BC0027追單

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                      # Print condition RECORD
              s1    LIKE type_file.num5,  #來源方式#No.FUN-680098   smallint
              s2    LIKE type_file.num5,  #來源方式#No.FUN-680098   smallint
              s3    LIKE type_file.num5,  #來源方式#No.FUN-680098   smallint
              s4    LIKE type_file.num5,  #來源方式#No.FUN-680098   smallint
              s5    LIKE type_file.num5,  #來源方式#No.FUN-680098   smallint
              n1    LIKE zaa_file.zaa08,  #來源方式名稱#No.FUN-680098   VARCHAR(8)
              n2    LIKE zaa_file.zaa08,  #來源方式名稱#No.FUN-680098   VARCHAR(8)
              n3    LIKE zaa_file.zaa08,  #來源方式名稱#No.FUN-680098   VARCHAR(8)
              n4    LIKE zaa_file.zaa08,  #來源方式名稱#No.FUN-680098   VARCHAR(8)
              n5    LIKE zaa_file.zaa08,  #來源方式名稱#No.FUN-680098   VARCHAR(8)
              yy1   LIKE aah_file.aah02,  #第一期輸入年度
              yy2   LIKE aah_file.aah02,  #第二期輸入年度
              yy3   LIKE aah_file.aah02,  #第三期輸入年度
              yy4   LIKE aah_file.aah02,  #第四期輸入年度
              yy5   LIKE aah_file.aah02,  #第五期輸入年度
              m1    LIKE aah_file.aah03,  #第一期本期起始期別
              m4    LIKE aah_file.aah03,  #第一期本期截止期別
              m2    LIKE aah_file.aah03,  #第二期起始期別
              m5    LIKE aah_file.aah03,  #第二期截止期別
              m3    LIKE aah_file.aah03,  #第三期起始期別
              m6    LIKE aah_file.aah03,  #第三期截止期別
              m7    LIKE aah_file.aah03,  #第四期起始期別
              m9    LIKE aah_file.aah03,  #第四期截止期別
              m8    LIKE aah_file.aah03,  #第五期起始期別
              m0    LIKE aah_file.aah03,  #第五期截止期別
              a     LIKE type_file.chr1,  #銷貨淨額與銷貨成本依平均存貨方式計算   #CHI-860004 add
              more  LIKE type_file.chr1   #Input more condition(Y/N)#No.FUN-680098   VARCHAR(1)
              END RECORD,
          g_bookno  LIKE aah_file.aah00,                #帳別
          g_tot ARRAY[5,37] OF LIKE aah_file.aah04,    #合計
          g_tot_b ARRAY[5,37] OF LIKE aah_file.aah04,  #上期合計
          g_eff ARRAY[5] OF LIKE aah_file.aah04        #合計
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_sql           STRING                       #No.FUN-780061
DEFINE   g_sql1          STRING                       #FUN-B90028
DEFINE   g_sql2          STRING                       #FUN-B90028
DEFINE   g_str           STRING                       #No.FUN-780061
DEFINE   l_table         STRING                       #No.FUN-780061
 
###GENGRE###START
TYPE sr1_t RECORD
    title LIKE ze_file.ze03,
    msg01 LIKE ze_file.ze03,
    msg02 LIKE ze_file.ze03,
    msg03 LIKE ze_file.ze03,
    num01 LIKE type_file.num20_6,
    num02 LIKE type_file.num20_6,
    tot01 LIKE type_file.num20_6,
    tot02 LIKE type_file.num20_6,
    tot03 LIKE type_file.num20_6,
    tot04 LIKE type_file.num20_6,
    tot05 LIKE type_file.num20_6,
    unit LIKE type_file.chr5,
    sort LIKE type_file.num5,
    sort2 LIKE type_file.num5,
    azi04 LIKE azi_file.azi04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_sql = "title.ze_file.ze03,     msg01.ze_file.ze03,",
               "msg02.ze_file.ze03,     msg03.ze_file.ze03,",
               "num01.type_file.num20_6,num02.type_file.num20_6,", #CHI-890029 mod chr1000->num20_6
               "tot01.type_file.num20_6,tot02.type_file.num20_6,", #CHI-890029 mod chr1000->num20_6
               "tot03.type_file.num20_6,tot04.type_file.num20_6,", #CHI-890029 mod chr1000->num20_6
               "tot05.type_file.num20_6,unit.type_file.chr5,",     #CHI-890029 mod chr1000->num20_6,add unit
               "sort.type_file.num5,    sort2.type_file.num5,",
               "azi04.azi_file.azi04"   #MOD-920254 add
   LET l_table = cl_prt_temptable('aglg401',g_sql) CLIPPED    
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  #CHI-890029 add ?  #MOD-920254 add ?
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF 
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.s1    = ARG_VAL(8)
   LET tm.s2    = ARG_VAL(9)
   LET tm.s3    = ARG_VAL(10)
   LET tm.s4    = ARG_VAL(11)
   LET tm.s5    = ARG_VAL(12)
   LET tm.n1    = ARG_VAL(13)
   LET tm.n2    = ARG_VAL(14)
   LET tm.n3    = ARG_VAL(15)
   LET tm.n4    = ARG_VAL(16)
   LET tm.n5    = ARG_VAL(17)
   LET tm.yy1   = ARG_VAL(18)
   LET tm.yy2   = ARG_VAL(19)
   LET tm.yy3   = ARG_VAL(20)
   LET tm.yy4   = ARG_VAL(21)
   LET tm.yy5   = ARG_VAL(22)
   LET tm.m1    = ARG_VAL(23)
   LET tm.m2    = ARG_VAL(24)
   LET tm.m3    = ARG_VAL(25)
   LET tm.m7    = ARG_VAL(26)
   LET tm.m8    = ARG_VAL(27)
   LET tm.m4    = ARG_VAL(28)
   LET tm.m5    = ARG_VAL(29)
   LET tm.m6    = ARG_VAL(30)
   LET tm.m9    = ARG_VAL(31)
   LET tm.m0    = ARG_VAL(32)
   LET tm.a     = ARG_VAL(33)    #CHI-860004 add
   LET g_rep_user = ARG_VAL(34)
   LET g_rep_clas = ARG_VAL(35)
   LET g_template = ARG_VAL(36)
   LET g_rpt_name = ARG_VAL(37)  #No.FUN-7C0078
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL aglg401_tm()                    # Input print condition
      ELSE CALL aglg401()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
END MAIN
 
FUNCTION aglg401_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw          LIKE type_file.chr1,          #重要欄位是否空白 #No.FUN-680098   VARCHAR(1)
          l_cmd         LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
 
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 5
   END IF
   OPEN WINDOW aglg401_w AT p_row,p_col
        WITH FORM "agl/42f/aglg401"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
 
   #使用預設帳別之幣別
   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = g_aaa.aaa03    #No.CHI-6A0004 g_azi-->t_azi
   LET tm.a    = 'N'   #CHI-860004 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_sw = 1
WHILE TRUE
    INPUT BY NAME tm.s1,tm.n1,tm.yy1,tm.m1,tm.m4,
                  tm.s2,tm.n2,tm.yy2,tm.m2,tm.m5,
                  tm.s3,tm.n3,tm.yy3,tm.m3,tm.m6,
                  tm.s4,tm.n4,tm.yy4,tm.m7,tm.m9,
                  tm.s5,tm.n5,tm.yy5,tm.m8,tm.m0,
                  tm.a,tm.more WITHOUT DEFAULTS    #CHI-860004 add tm.a
         BEFORE INPUT
             CALL cl_qbe_init()
       ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
 
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
 
      AFTER FIELD n1
        IF cl_null(tm.n1) THEN
           NEXT FIELD n1
        END IF
 
      AFTER FIELD yy1
                 IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
                        NEXT FIELD yy1
                 END IF
 
      AFTER FIELD m1
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
         IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
 
      AFTER FIELD m2
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
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
         IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
 
      AFTER FIELD m3
         IF tm.m3 IS NOT NULL AND (tm.m3 <1 OR tm.m3 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m3
         END IF
 
      AFTER FIELD m7
         IF tm.m7 IS NOT NULL AND (tm.m7 <1 OR tm.m7 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m7
         END IF
 
      AFTER FIELD m8
         IF tm.m8 IS NOT NULL AND (tm.m8 <1 OR tm.m8 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m8
         END IF
 
      AFTER FIELD m4
         IF tm.m4 IS NOT NULL AND (tm.m4 <1 OR tm.m4 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m4
         END IF
 
      AFTER FIELD m5
         IF tm.m5 IS NOT NULL AND (tm.m5 <1 OR tm.m5 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m5
         END IF
 
      AFTER FIELD m6
         IF tm.m6 IS NOT NULL AND (tm.m6 <1 OR tm.m6 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m6
         END IF
 
      AFTER FIELD m9
         IF tm.m9 IS NOT NULL AND (tm.m9 <1 OR tm.m9 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m9
         END IF
 
      AFTER FIELD m0
         IF tm.m0 IS NOT NULL AND (tm.m0 <1 OR tm.m0 > 13) THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD m0
         END IF
 
       AFTER FIELD a
          IF tm.a IS NULL OR tm.a NOT MATCHES '[YN]' THEN
             NEXT FIELD a
          END IF
 
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
               DISPLAY BY NAME tm.s1
               CALL cl_err('',9033,0)
            END IF
            IF tm.yy1 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy1
               CALL cl_err('',9033,0)
            END IF
            IF tm.m1 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.m1
               CALL cl_err('',9033,0)
            END IF
            IF tm.m4 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.m4
               CALL cl_err('',9033,0)
            END IF
            IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD s1
               CALL cl_err('',9033,0)
            END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglg401_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg401'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg401','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
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
                         " '",tm.a CLIPPED,"'",                 #CHI-860004 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglg401',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW aglg401_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglg401()
   ERROR ""
END WHILE
   CLOSE WINDOW aglg401_w
END FUNCTION
 
FUNCTION aglg401()
   DEFINE l_name        LIKE type_file.chr20,             # External(Disk) file name  #No.FUN-680098 VARCHAR(20)
          l_sql         LIKE type_file.chr1000,           # RDSQL STATEMENT           #No.FUN-680098 VARCHAR(1000)
          l_yy          ARRAY[5] OF LIKE type_file.num5,  #年度     #No.FUN-680098 smallint
          l_bm          ARRAY[5] OF LIKE type_file.num5,  #起始期別 #No.FUN-680098 smallint
          l_em          ARRAY[5] OF LIKE type_file.num5,  #截止期別 #No.FUN-680098 smallint
          l_tot         LIKE aah_file.aah04,              #合計
          l_aag06       LIKE aag_file.aag06,              #借貸別
          l_aag19       LIKE aag_file.aag19,              #財務比率分析類別
          l_yyb,l_yy1   LIKE type_file.num5,              #No.FUN-680098 smallint
          l_bm1         LIKE type_file.num5,              #No.FUN-680098 smallint
          l_chr         LIKE type_file.chr1,              #No.FUN-680098 VARCHAR(1)
          l_za05        LIKE za_file.za05                 #No.FUN-680098 VARCHAR(40)
#  DEFINE l_aaz31       LIKE aaz_file.aaz31               #CHI-A40061 add  #FUN-B90028
   DEFINE l_aaa14       LIKE aaa_file.aaa14                #FUN-B90028 
     CALL cl_del_data(l_table)                            #No.FUN-780061
 
     SELECT aaf03 INTO g_company FROM aaf_file
        WHERE aaf01 = g_bookno AND aaf02 = g_rlang
 
     FOR g_i = 1 to 37   #TQC-620043
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
 
#    SELECT aaz31 INTO l_aaz31 FROM aaz_file  #CHI-A40061 add
     SELECT aaa14 INTO l_aaa14 FROM aaa_file WHERE aaa01 = g_bookno  #FUN-90028 FROM FUN-BC0027 add

     FOR g_i = 1 TO 5
        IF l_yy[g_i] IS NULL OR l_yy[g_i]=0 THEN EXIT FOR END IF
        # 全數計算
        IF tm.a = 'Y' THEN
           LET g_eff[g_i] = 1
        ELSE
           LET g_eff[g_i] = (l_em[g_i] - l_bm[g_i]+1) / 12
        END IF   #CHI-860004 add
        LET l_sql = "SELECT aag06,aag19,SUM(aah04-aah05)",
                    " FROM aag_file,aah_file",
                    " WHERE aah00 = '",g_bookno,"'",
                    "   AND aah00 = aag00",              #No.FUN-740020
                    "   AND aah01 = aag01",
                   #"   AND aah01 != l_aaz31",           #CHI-A40061 add   #MOD-A60008 mark
#                   "   AND aah01 != '",l_aaz31,"'",                       #MOD-A60008    #NO.FUN-B90028 mark
                    "   AND aah01 != '",l_aaa14,"'",              #NO.FUN-B90028 add
                    "   AND aah02 = ? ",
                    "   AND aah03 <=  ? ",
                    "   AND aag04 = '1'",
                    "   AND aag07 != '1'",  # Jason 0427
                    "   AND aag09 = 'Y'",   #MOD-920199 add
                    "   GROUP BY aag06,aag19"
        PREPARE aglg401_p1 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('p1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
           CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
           EXIT PROGRAM
        END IF
 
        DECLARE aglg401_c1 CURSOR FOR aglg401_p1
        FOREACH aglg401_c1 USING l_yy[g_i],l_em[g_i] INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
          END IF
 
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF   #TQC-620043
          LET g_tot[g_i,l_aag19] = g_tot[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE aglg401_c1
        LET l_yy1= l_yy[g_i]
        LET l_bm1= l_bm[g_i]  - 1
        IF l_bm1< 1 THEN
           LET l_bm1= 12
           LET l_yy1= l_yy1 -1
        END IF
        # 期初
        FOREACH aglg401_c1 USING l_yy1,l_bm1 INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
          END IF
 
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF   #TQC-620043
          LET g_tot_b[g_i,l_aag19] = g_tot_b[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE aglg401_c1
     END FOR
 
     FOR g_i = 1 TO 5
        IF l_yy[g_i] IS NULL OR l_yy[g_i]=0 THEN EXIT FOR END IF
        LET l_sql = "SELECT aag06,aag19,SUM(aah04-aah05)",
                    " FROM aag_file,aah_file",
                    " WHERE aah00 = '",g_bookno,"'",
                    "   AND aah00 = aag00",       #No.FUN-740020
                    "   AND aah01 = aag01",
                   #"   AND aah01 != l_aaz31",           #CHI-A40061 add   #MOD-AB0115 mark
#                   "   AND aah01 != '",l_aaz31,"'",                       #MOD-AB0115   #NO.FUN-B90028 mark
                    "   AND aah01 != '",l_aaa14,"'",      #NO.FUN-B90028 add
                    "   AND aah02 = ? ",
                    "   AND aah03 >= ",l_bm[g_i],
                    "   AND aah03 <= ",l_em[g_i],
                    "   AND aag04 = '2'",
                    "   AND aag07 != '1'",  # Jason 0427
                    "   AND aag09 = 'Y'",   #MOD-920199 add
                    "   GROUP BY aag06,aag19"
        PREPARE aglg401_p2 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('p1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
           CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
           EXIT PROGRAM
        END IF
 
        DECLARE aglg401_c2 CURSOR FOR aglg401_p2
        FOREACH aglg401_c2 USING l_yy[g_i] INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF   #TQC-620043
 
          LET g_tot[g_i,l_aag19] = g_tot[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE aglg401_c2
        LET l_yyb = l_yy[g_i] -1
        #去年同期
        FOREACH aglg401_c2 USING l_yyb INTO l_aag06,l_aag19,l_tot
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
 
          IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF
 
          IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF   #TQC-620043
 
          LET g_tot_b[g_i,l_aag19] = g_tot_b[g_i,l_aag19] + l_tot
        END FOREACH
        CLOSE aglg401_c2
     END FOR
 
     CALL aglg401_ins_temp()
###GENGRE###     LET g_str = tm.n5,";",tm.yy1,";",tm.yy2,";",tm.yy3,";",tm.yy4,";",
###GENGRE###                 tm.yy5,";",tm.m1,";",tm.m2,";",tm.m3,";",                                 
###GENGRE###                 tm.m4,";",tm.m5,";",tm.m6,";",tm.m7,";",tm.m8,";",tm.m9,";",   
###GENGRE###                 tm.m0,";",tm.n1,";",tm.n2,";",tm.n3,";",tm.n4
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('aglg401','aglg401',l_sql,g_str)
    CALL aglg401_grdata()    ###GENGRE###
END FUNCTION
 
FUNCTION aglg401_ins_temp()
   DEFINE l_last_sw     LIKE type_file.chr1    #No.FUN-680098      VARCHAR(1)
   DEFINE l_tot         ARRAY[5,36] OF LIKE type_file.num20_6 #財務比率(五年)(34項比率)#No.FUN-680098 dec(20,6)
   DEFINE l_n           LIKE type_file.num5          
   DEFINE l_azi04       LIKE azi_file.azi04    #MOD-920254 add
   DEFINE l_format1     LIKE type_file.chr20   #MOD-920254 add
   DEFINE l_format2     LIKE type_file.chr20   #MOD-920254 add
   DEFINE sr    DYNAMIC ARRAY OF RECORD
                 a      LIKE type_file.num20_6,    #流動資產#No.FUN-680098 dec(20,6)
                 b      LIKE type_file.num20_6,    #流動負債#No.FUN-680098 dec(20,6)
                 c      LIKE type_file.num20_6,    #速動資產#No.FUN-680098 dec(20,6)
                 d      LIKE type_file.num20_6,    #營運資金#No.FUN-680098 dec(20,6)
                 e      LIKE type_file.num20_6,    #資產總額#No.FUN-680098 dec(20,6)
                 f      LIKE type_file.num20_6,    #營業毛利#No.FUN-680098 dec(20,6)
                 g      LIKE type_file.num20_6,    #平均應收帳款#No.FUN-680098 dec(20,6)
                 h      LIKE type_file.num20_6,    #平均存貨#No.FUN-680098 dec(20,6)
                 i      LIKE type_file.num20_6,    #基金及長期投資#No.FUN-680098 dec(20,6)
                 j      LIKE type_file.num20_6,    #負債總額#No.FUN-680098 dec(20,6)
                 k      LIKE type_file.num20_6,    #業主權益#No.FUN-680098 dec(20,6)
                 l      LIKE type_file.num20_6,    #淨利#No.FUN-680098 dec(20,6)
                 m      LIKE type_file.num20_6,    #平均應收款項#No.FUN-680098 dec(20,6)
                 n      LIKE type_file.num20_6,    #營業利益#No.FUN-680098 dec(20,6)
                 o      LIKE type_file.num20_6,    #稅前淨利#No.FUN-680098 dec(20,6)
                 p      LIKE type_file.num20_6,    #純益#No.FUN-680098 dec(20,6)
                 t      LIKE type_file.num20_6,    #上期資產總額#No.FUN-680098 dec(20,6)
                 u      LIKE type_file.num20_6     #上期業主權益#No.FUN-680098 dec(20,6)
                END RECORD 
   DEFINE  sr1  RECORD                                                          
                 title  LIKE ze_file.ze03,                      
                 msg01  LIKE ze_file.ze03,                      
                 msg02  LIKE ze_file.ze03,                      
                 msg03  LIKE ze_file.ze03,                      
                 num01  LIKE type_file.num20_6,                 
                 num02  LIKE type_file.num20_6,   #CHI-890029 mod chr1000->num20_6
                 tot01  LIKE type_file.num20_6,   #CHI-890029 mod chr1000->num20_6
                 tot02  LIKE type_file.num20_6,   #CHI-890029 mod chr1000->num20_6
                 tot03  LIKE type_file.num20_6,   #CHI-890029 mod chr1000->num20_6
                 tot04  LIKE type_file.num20_6,   #CHI-890029 mod chr1000->num20_6
                 tot05  LIKE type_file.num20_6,   #CHI-890029 mod chr1000->num20_6
                 unit   LIKE type_file.chr5,      #CHI-890029 add
                 sort   LIKE type_file.num5,
                 sort2  LIKE type_file.num5,
                 azi04  LIKE azi_file.azi04       #MOD-920254 add
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
   #流動資產的運算=1類+2類+3類+4類+5類+6類+7類+8類
   FOR g_i = 1 TO 8
       LET sr[1].a = sr[1].a + g_tot[1,g_i]   #第一期
       LET sr[2].a = sr[2].a + g_tot[2,g_i]   #第二期
       LET sr[3].a = sr[3].a + g_tot[3,g_i]   #第三期
       LET sr[4].a = sr[4].a + g_tot[4,g_i]   #第四期
       LET sr[5].a = sr[5].a + g_tot[5,g_i]   #第五期
   END FOR
   #流動負債的運算=14類+15類+16類+18類
   FOR g_i = 14 TO 16
       LET sr[1].b = sr[1].b + g_tot[1,g_i]*-1   #第一期   #MOD-AB0186 mod
       LET sr[2].b = sr[2].b + g_tot[2,g_i]*-1   #第二期   #MOD-AB0186 mod
       LET sr[3].b = sr[3].b + g_tot[3,g_i]*-1   #第三期   #MOD-AB0186 mod
       LET sr[4].b = sr[4].b + g_tot[4,g_i]*-1   #第四期   #MOD-AB0186 mod
       LET sr[5].b = sr[5].b + g_tot[5,g_i]*-1   #第五期   #MOD-AB0186 mod
   END FOR
  #流動負債的運算增加 18
   LET sr[1].b = sr[1].b + g_tot[1,18]*-1        #第一期   #MOD-AB0186 mod
   LET sr[2].b = sr[2].b + g_tot[2,18]*-1        #第二期   #MOD-AB0186 mod
   LET sr[3].b = sr[3].b + g_tot[3,18]*-1        #第三期   #MOD-AB0186 mod
   LET sr[4].b = sr[4].b + g_tot[4,18]*-1        #第四期   #MOD-AB0186 mod
   LET sr[5].b = sr[5].b + g_tot[5,18]*-1        #第五期   #MOD-AB0186 mod
   #速動資產的運算=1類+2類+3類+4類+8類
   LET sr[1].c =  sr[1].a - (g_tot[1,5] + g_tot[1,6] + g_tot[1,7])   #第一期
   LET sr[2].c =  sr[2].a - (g_tot[2,5] + g_tot[2,6] + g_tot[2,7])   #第二期
   LET sr[3].c =  sr[3].a - (g_tot[3,5] + g_tot[3,6] + g_tot[3,7])   #第三期
   LET sr[4].c =  sr[4].a - (g_tot[4,5] + g_tot[4,6] + g_tot[4,7])   #第四期
   LET sr[5].c =  sr[5].a - (g_tot[5,5] + g_tot[5,6] + g_tot[5,7])   #第五期
   #營運資金=(1類+2類+3類+4類+5類+6類+7類+8類)-(14類+15類+16類+18類)*-1
   LET sr[1].d = sr[1].a - sr[1].b*-1          #第一期
   LET sr[2].d = sr[2].a - sr[2].b*-1          #第二期
   LET sr[3].d = sr[3].a - sr[3].b*-1          #第三期
   LET sr[4].d = sr[4].a - sr[4].b*-1          #第四期
   LET sr[5].d = sr[5].a - sr[5].b*-1          #第五期
   #資產總額=1類+2類+3類+4類+5類+6類+7類+8類+9類+10類+11類+12類+13類+32類
   FOR g_i = 1 TO 13
       LET sr[1].e = sr[1].e + g_tot[1,g_i]   #第一期
       LET sr[2].e = sr[2].e + g_tot[2,g_i]   #第二期
       LET sr[3].e = sr[3].e + g_tot[3,g_i]   #第三期
       LET sr[4].e = sr[4].e + g_tot[4,g_i]   #第四期
       LET sr[5].e = sr[5].e + g_tot[5,g_i]   #第五期
   END FOR
   LET sr[1].e = sr[1].e + g_tot[1,32]
   LET sr[2].e = sr[2].e + g_tot[2,32]
   LET sr[3].e = sr[3].e + g_tot[3,32]
   LET sr[4].e = sr[4].e + g_tot[4,32]
   LET sr[5].e = sr[5].e + g_tot[5,32]
   #上期資產總額
   FOR g_i = 1 TO 13
       LET sr[1].t = sr[1].t + g_tot_b[1,g_i]   #第一期
       LET sr[2].t = sr[2].t + g_tot_b[2,g_i]   #第二期
       LET sr[3].t = sr[3].t + g_tot_b[3,g_i]   #第三期
       LET sr[4].t = sr[4].t + g_tot_b[4,g_i]   #第四期
       LET sr[5].t = sr[5].t + g_tot_b[5,g_i]   #第五期
   END FOR
   LET sr[1].t = sr[1].t + g_tot_b[1,32]
   LET sr[2].t = sr[2].t + g_tot_b[2,32]
   LET sr[3].t = sr[3].t + g_tot_b[3,32]
   LET sr[4].t = sr[4].t + g_tot_b[4,32]
   LET sr[5].t = sr[5].t + g_tot_b[5,32]
 
   #銷貨淨額
   #當tm.a(銷貨淨額與銷貨成本依平均存貨方式計算)=Y,銷貨淨額=23類/期數*12
   #                                            =N,銷貨淨額=23類
   IF tm.a = 'Y' THEN
      LET sr[1].f = g_tot[1,23]*-1 /(tm.m4-tm.m1 +1) * 12   #第一期   #MOD-AB0186 mod
      LET sr[2].f = g_tot[2,23]*-1 /(tm.m5-tm.m2 +1) * 12   #第二期   #MOD-AB0186 mod
      LET sr[3].f = g_tot[3,23]*-1 /(tm.m6-tm.m3 +1) * 12   #第三期   #MOD-AB0186 mod
      LET sr[4].f = g_tot[4,23]*-1 /(tm.m9-tm.m7 +1) * 12   #第四期   #MOD-AB0186 mod
      LET sr[5].f = g_tot[5,23]*-1 /(tm.m0-tm.m8 +1) * 12   #第五期   #MOD-AB0186 mod
   ELSE
      LET sr[1].f = g_tot[1,23]*-1                         #第一期    #MOD-AB0186 mod
      LET sr[2].f = g_tot[2,23]*-1                         #第二期    #MOD-AB0186 mod
      LET sr[3].f = g_tot[3,23]*-1                         #第三期    #MOD-AB0186 mod
      LET sr[4].f = g_tot[4,23]*-1                         #第四期    #MOD-AB0186 mod
      LET sr[5].f = g_tot[5,23]*-1                         #第五期    #MOD-AB0186 mod
   END IF   #CHI-860004 add
 
   #@@平均應收款項=(上期3類+本期3類)/2
   LET sr[1].g = (g_tot_b[1,3]+g_tot[1,3])/2             #第一期
   LET sr[2].g = (g_tot_b[2,3]+g_tot[2,3])/2             #第一期
   LET sr[3].g = (g_tot_b[3,3]+g_tot[3,3])/2             #第一期
   LET sr[4].g = (g_tot_b[4,3]+g_tot[4,3])/2             #第一期
   LET sr[5].g = (g_tot_b[5,3]+g_tot[5,3])/2             #第一期
   #@@平均存貨(上期5類+本期5類)/2
   LET sr[1].h =(g_tot_b[1,5] + g_tot[1,5])/2             #第一期
   LET sr[2].h =(g_tot_b[2,5] + g_tot[2,5])/2             #第二期
   LET sr[3].h =(g_tot_b[3,5] + g_tot[3,5])/2             #第三期
   LET sr[4].h =(g_tot_b[4,5] + g_tot[4,5])/2             #第四期
   LET sr[5].h =(g_tot_b[5,5] + g_tot[5,5])/2             #第五期
   #基金及長期投資=9類+10類+11類
   FOR g_i = 9 TO 11
       LET sr[1].i = sr[1].i + g_tot[1,g_i]   #第一期
       LET sr[2].i = sr[2].i + g_tot[2,g_i]   #第二期
       LET sr[3].i = sr[3].i + g_tot[3,g_i]   #第三期
       LET sr[4].i = sr[4].i + g_tot[4,g_i]   #第四期
       LET sr[5].i = sr[5].i + g_tot[5,g_i]   #第五期
   END FOR
   #負債總額=14類+15類+16類+17類+18類+33類
   FOR g_i = 14 TO 18
       LET sr[1].j = sr[1].j + g_tot[1,g_i]*-1   #第一期     #MOD-AB0186 mod
       LET sr[2].j = sr[2].j + g_tot[2,g_i]*-1   #第二期     #MOD-AB0186 mod
       LET sr[3].j = sr[3].j + g_tot[3,g_i]*-1   #第三期     #MOD-AB0186 mod
       LET sr[4].j = sr[4].j + g_tot[4,g_i]*-1   #第四期     #MOD-AB0186 mod
       LET sr[5].j = sr[5].j + g_tot[5,g_i]*-1   #第五期     #MOD-AB0186 mod
   END FOR
   LET sr[1].j = sr[1].j + g_tot[1,33]*-1                    #MOD-AB0186 mod
   LET sr[2].j = sr[2].j + g_tot[2,33]*-1                    #MOD-AB0186 mod
   LET sr[3].j = sr[3].j + g_tot[3,33]*-1                    #MOD-AB0186 mod
   LET sr[4].j = sr[4].j + g_tot[4,33]*-1                    #MOD-AB0186 mod
   LET sr[5].j = sr[5].j + g_tot[5,33]*-1                    #MOD-AB0186 mod
   #業主權益=19類+20類+21類+22類+34類+35類+36類
   FOR g_i = 19 TO 22
       LET sr[1].k = sr[1].k + g_tot[1,g_i]*-1   #第一期     #MOD-AB0186 mod
       LET sr[2].k = sr[2].k + g_tot[2,g_i]*-1   #第二期     #MOD-AB0186 mod
       LET sr[3].k = sr[3].k + g_tot[3,g_i]*-1   #第三期     #MOD-AB0186 mod
       LET sr[4].k = sr[4].k + g_tot[4,g_i]*-1   #第四期     #MOD-AB0186 mod
       LET sr[5].k = sr[5].k + g_tot[5,g_i]*-1   #第五期     #MOD-AB0186 mod
   END FOR
   FOR g_i = 34 TO 36
       LET sr[1].k = sr[1].k + g_tot[1,g_i]*-1               #MOD-AB0186 mod
       LET sr[2].k = sr[2].k + g_tot[2,g_i]*-1               #MOD-AB0186 mod
       LET sr[3].k = sr[3].k + g_tot[3,g_i]*-1               #MOD-AB0186 mod
       LET sr[4].k = sr[4].k + g_tot[4,g_i]*-1               #MOD-AB0186 mod
       LET sr[5].k = sr[5].k + g_tot[5,g_i]*-1               #MOD-AB0186 mod
   END FOR
   #上期業主權益
   FOR g_i = 19 TO 22
       LET sr[1].u = sr[1].u + g_tot_b[1,g_i]*-1   #第一期   #MOD-AB0186 mod
       LET sr[2].u = sr[2].u + g_tot_b[2,g_i]*-1   #第二期   #MOD-AB0186 mod
       LET sr[3].u = sr[3].u + g_tot_b[3,g_i]*-1   #第三期   #MOD-AB0186 mod
       LET sr[4].u = sr[4].u + g_tot_b[4,g_i]*-1   #第四期   #MOD-AB0186 mod 
       LET sr[5].u = sr[5].u + g_tot_b[5,g_i]*-1   #第五期   #MOD-AB0186 mod
   END FOR
   FOR g_i = 34 TO 36
       LET sr[1].u = sr[1].u + g_tot_b[1,g_i]*-1   #第一期   #MOD-AB0186 mod
       LET sr[2].u = sr[2].u + g_tot_b[2,g_i]*-1   #第二期   #MOD-AB0186 mod
       LET sr[3].u = sr[3].u + g_tot_b[3,g_i]*-1   #第三期   #MOD-AB0186 mod
       LET sr[4].u = sr[4].u + g_tot_b[4,g_i]*-1   #第四期   #MOD-AB0186 mod
       LET sr[5].u = sr[5].u + g_tot_b[5,g_i]*-1   #第五期   #MOD-AB0186 mod
   END FOR
 
   IF tm.a = 'Y' THEN
      LET g_tot[1,25] = g_tot[1,25]/(tm.m4-tm.m1 +1) * 12   #第一期
      LET g_tot[2,25] = g_tot[2,25]/(tm.m5-tm.m2 +1) * 12   #第二期
      LET g_tot[3,25] = g_tot[3,25]/(tm.m6-tm.m3 +1) * 12   #第三期
      LET g_tot[4,25] = g_tot[4,25]/(tm.m9-tm.m7 +1) * 12   #第四期
      LET g_tot[5,25] = g_tot[5,25]/(tm.m0-tm.m8 +1) * 12   #第五期
   END IF
 
   #淨利(收入-成本)=(23類*-1)+(24類*-1)-25類-26類
   LET sr[1].l =(g_tot[1,23] * -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]
   LET sr[2].l =(g_tot[2,23] * -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]
   LET sr[3].l =(g_tot[3,23] * -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]
   LET sr[4].l =(g_tot[4,23] * -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]
   LET sr[5].l =(g_tot[5,23] * -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]
   #營業利益=(23類*-1)-25類-27類
   LET sr[1].n =(g_tot[1,23]* -1)-g_tot[1,25]-g_tot[1,27]    #第一期
   LET sr[2].n =(g_tot[2,23]* -1)-g_tot[2,25]-g_tot[2,27]    #第二期
   LET sr[3].n =(g_tot[3,23]* -1)-g_tot[3,25]-g_tot[3,27]    #第三期
   LET sr[4].n =(g_tot[4,23]* -1)-g_tot[4,25]-g_tot[4,27]    #第四期
   LET sr[5].n =(g_tot[5,23]* -1)-g_tot[5,25]-g_tot[5,27]    #第五期
   #稅前淨利=(23類*-1)+(24類*-1)-25類-26類-27類-28類-31類-37類
   LET sr[1].o =(g_tot[1,23]* -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]-   #第一期
                 g_tot[1,27]-g_tot[1,28]-g_tot[1,31]-g_tot[1,37]   #TQC-620043
   LET sr[2].o =(g_tot[2,23]* -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]-   #第二期
                 g_tot[2,27]-g_tot[2,28]-g_tot[2,31]-g_tot[2,37]   #TQC-620043
   LET sr[3].o =(g_tot[3,23]* -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]-   #第三期
                 g_tot[3,27]-g_tot[3,28]-g_tot[3,31]-g_tot[3,37]   #TQC-620043
   LET sr[4].o =(g_tot[4,23]* -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]-   #第四期
                 g_tot[4,27]-g_tot[4,28]-g_tot[4,31]-g_tot[4,37]   #TQC-620043
   LET sr[5].o =(g_tot[5,23]* -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]-   #第五期
                 g_tot[5,27]-g_tot[5,28]-g_tot[5,31]-g_tot[5,37]  #TQC-620043
 
   #純益=(23類*-1)+(24類*-1)-25類-26類-27類-28類-29類-31類-37類
   LET sr[1].p =(g_tot[1,23]* -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]-   #第一期
                 g_tot[1,27]-g_tot[1,28]-g_tot[1,29]-g_tot[1,31]-
                 g_tot[1,37]   #TQC-620043
   LET sr[2].p =(g_tot[2,23]* -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]-   #第二期
                 g_tot[2,27]-g_tot[2,28]-g_tot[2,29]-g_tot[2,31]-
                 g_tot[2,37]   #TQC-620043
   LET sr[3].p =(g_tot[3,23]* -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]-   #第三期
                 g_tot[3,27]-g_tot[3,28]-g_tot[3,29]-g_tot[3,31]-
                 g_tot[3,37]   #TQC-620043
   LET sr[4].p =(g_tot[4,23]* -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]-   #第四期
                 g_tot[4,27]-g_tot[4,28]-g_tot[4,29]-g_tot[4,31]-
                 g_tot[4,37]   #TQC-620043
   LET sr[5].p =(g_tot[5,23]* -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]-   #第五期
                 g_tot[5,27]-g_tot[5,28]-g_tot[5,29]-g_tot[5,31]-
                 g_tot[5,37]   #TQC-620043
 
  #-MOD-AB0186-add-
   LET g_tot[1,17] = g_tot[1,17]*-1
   LET g_tot[2,17] = g_tot[2,17]*-1
   LET g_tot[3,17] = g_tot[3,17]*-1
   LET g_tot[4,17] = g_tot[4,17]*-1
   LET g_tot[5,17] = g_tot[5,17]*-1
   LET g_tot[1,19] = g_tot[1,19]*-1
   LET g_tot[2,19] = g_tot[2,19]*-1
   LET g_tot[3,19] = g_tot[3,19]*-1
   LET g_tot[4,19] = g_tot[4,19]*-1
   LET g_tot[5,19] = g_tot[5,19]*-1
   LET g_tot[1,23] = g_tot[1,23]*-1
   LET g_tot[2,23] = g_tot[2,23]*-1
   LET g_tot[3,23] = g_tot[3,23]*-1
   LET g_tot[4,23] = g_tot[4,23]*-1
   LET g_tot[5,23] = g_tot[5,23]*-1
  #-MOD-AB0186-end-

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
          LET l_tot[g_i,25] = (sr[g_i].p+(g_tot[g_i,31]*0.75))/
                              ((sr[g_i].e+sr[g_i].t)/2) * 100
                      #資產週轉率 (銷貨淨額/資產總額)
          LET l_tot[g_i,27] = (sr[g_i].f/sr[g_i].e)
       END IF
       #流動資產不為零
       IF sr[g_i].a != 0 THEN
                      #流動資產週轉率 (銷貨淨額/流動資產)
          LET l_tot[g_i,6] = (sr[g_i].f/sr[g_i].a)
                      #現金佔流動資產比率 (現金/流動資產)
          LET l_tot[g_i,13] = g_tot[g_i,1]/sr[g_i].a * 100
                      #短期投資佔流動資產比率 (短期投資/流動資產)
          LET l_tot[g_i,14] = g_tot[g_i,2]/sr[g_i].a * 100
                      #應收款項佔流動資產比率 (應收款項/流動資產)
          LET l_tot[g_i,15] =(g_tot[g_i,3]+g_tot[g_i,4])/sr[g_i].a * 100
                      #存貨佔流動資產比率 (存貨/流動資產)
          LET l_tot[g_i,16] = (g_tot[g_i,5]+g_tot[g_i,6])/sr[g_i].a * 100
                      #預付款項佔流動資產比率 (預付款項/流動資產)
          LET l_tot[g_i,17] = g_tot[g_i,7]/sr[g_i].a * 100
                      #其它流動資產佔流動資產比率 (其它流動資產/流動資產)
          LET l_tot[g_i,18] = g_tot[g_i,8]/sr[g_i].a * 100
       END IF
       #固定資產不為零
       IF g_tot[g_i,12] != 0 THEN
              #固定資產週轉率 (銷貨淨額/固定資產)
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
          LET l_tot[g_i,7] = (g_tot[g_i,25]/sr[g_i].h)
       END IF
       #存貨週轉率不為零
       IF l_tot[g_i,7] != 0 THEN
                      #存貨維持日數 (日數/存貨週轉率)
          LET l_tot[g_i,8] = 365*g_eff[g_i]/l_tot[g_i,7]
       END IF
       #應收款項不為零
       IF sr[g_i].g != 0 THEN
                      #應收款項週轉率 (銷貨淨額/應收款項)
          LET l_tot[g_i,4] = (sr[g_i].f/sr[g_i].g)
       END IF
       #應收款項率不為零
       IF l_tot[g_i,4] != 0 THEN
              #應收款項維持日數 (日數/應收款項週轉率)
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
 
  #決定金額取位的FORMAT
   CALL aglg401_get_format()
        RETURNING sr1.azi04,l_format1,l_format2
 
   #股東權益對資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-022',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-023',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-024',g_lang)
   LET sr1.num01 = sr[1].k USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,20]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,20]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,20]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,20]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,20]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 1                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #負債總額對資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-025',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-026',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-027',g_lang)   
   LET sr1.num01 = sr[1].j USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,19]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,19]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,19]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,19]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,19]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 2                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #長期資金對固定資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-028',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-029',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-030',g_lang)                              
   LET sr1.num01 = sr[1].k+g_tot[1,17] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,12] USING l_format2          #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,29]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,29]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,29]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,29]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,29]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 3                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #營運資金比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-031',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-032',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-033',g_lang)                              
   LET sr1.num01 = sr[1].d USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,3]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,3]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,3]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,3]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,3]   #CHI-890029 mod
   LET sr1.unit  = '%'          #CHI-890029 add
   LET sr1.sort = 4                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #流動資產佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-034',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-035',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-036',g_lang)                              
   LET sr1.num01 = sr[1].a USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,9]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,9]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,9]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,9]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,9]   #CHI-890029 mod
   LET sr1.unit  = '%'          #CHI-890029 add
   LET sr1.sort = 5                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #基金及長期投資佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-037',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-038',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-039',g_lang)                              
   LET sr1.num01 = sr[1].i USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,10]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,10]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,10]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,10]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,10]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 6                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
  
   #固定資產佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-040',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-041',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-042',g_lang)                              
   LET sr1.num01 = g_tot[1,12] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,11]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,11]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,11]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,11]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,11]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 7                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #其它資產佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-043',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-044',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-045',g_lang)
   LET sr1.num01 = g_tot[1,13] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,12]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,12]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,12]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,12]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,12]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 8                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #現金佔流動資產比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-046',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-047',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-048',g_lang)                              
   LET sr1.num01 = g_tot[1,1] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,13]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,13]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,13]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,13]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,13]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 9                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
 
   #短期投資佔流動資產比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-049',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-050',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-051',g_lang)                              
   LET sr1.num01 = g_tot[1,2] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,14]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,14]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,14]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,14]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,14]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 10                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #應收款項占流動資產比率                                                   
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-052',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-053',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-054',g_lang)                              
   LET sr1.num01 = g_tot[1,3]+g_tot[1,4] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2                #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,15]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,15]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,15]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,15]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,15]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 11                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #存貨占流動資產比率                                                       
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-055',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-056',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-057',g_lang)                              
   LET sr1.num01 = g_tot[1,5]+g_tot[1,6] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2                #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,16]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,16]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,16]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,16]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,16]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 12                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #預付款項占流動資產比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-058',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-059',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-060',g_lang)                              
   LET sr1.num01 = g_tot[1,7] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,17]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,17]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,17]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,17]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,17]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 13                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #其它流動資產占流動資產比率                                               
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-061',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-062',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-063',g_lang)                              
   LET sr1.num01 = g_tot[1,8] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,18]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,18]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,18]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,18]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,18]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 14                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #固定資產對長期負債之比率                                                 
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-064',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-065',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-066',g_lang)                              
   LET sr1.num01 = g_tot[1,12] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,17] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,22]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,22]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,22]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,22]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,22]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 15                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #固定資產對業主益權比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-067',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-068',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-069',g_lang)                              
   LET sr1.num01 = g_tot[1,12] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].k USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,23]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,23]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,23]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,23]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,23]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 16                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #流動比率                                                                 
   LET sr1.title = cl_getmsg('abg-070',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-071',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-072',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-073',g_lang)                              
   LET sr1.num01 = sr[1].a USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].b USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,1]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,1]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,1]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,1]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,1]   #CHI-890029 mod
   LET sr1.unit  = '%'          #CHI-890029 add
   LET sr1.sort = 17                                                        
   LET sr1.sort2 = 2                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #酸性測驗                                                                 
   LET sr1.title = cl_getmsg('abg-070',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-074',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-075',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-076',g_lang)                              
   LET sr1.num01 = sr[1].c USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].b USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,2]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,2]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,2]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,2]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,2]   #CHI-890029 mod
   LET sr1.unit  = '%'          #CHI-890029 add
   LET sr1.sort = 18                                                        
   LET sr1.sort2 = 2                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #利息保障倍數
   LET sr1.title = cl_getmsg('abg-070',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-127',g_lang)   #CHI-860004 add
   LET sr1.msg02 = cl_getmsg('abg-128',g_lang)   #CHI-860004 add
   LET sr1.msg03 = cl_getmsg('abg-129',g_lang)   #CHI-860004 add
   LET sr1.num01 = sr[1].o + g_tot[1,31] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,31] USING l_format2            #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,36]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,36]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,36]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,36]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,36]   #CHI-890029 mod
   LET sr1.unit  = ' '           #CHI-890029 add
   LET sr1.sort = 19                                                        
   LET sr1.sort2 = 2                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #應收款項周轉率                                                           
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-078',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-079',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-080',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].g USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,4]                        #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,4]                        #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,4]                        #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,4]                        #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,4]                        #CHI-890029 mod
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次   #CHI-890029 add
   LET sr1.sort = 20                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #平均收款日數                                                             
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-081',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-082',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-083',g_lang)                              
   LET sr1.num01 = 365*g_eff[1] USING '###'
   LET sr1.num02 = l_tot[1,4] USING '-,--&.&&'  #MOD-920254 mod #'#,###.&&'
   LET sr1.tot01 = l_tot[1,5]                        #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,5]                        #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,5]                        #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,5]                        #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,5]                        #CHI-890029 mod
   LET sr1.unit  = cl_getmsg('amr-201',g_lang) #天   #CHI-890029 add
   LET sr1.sort = 21                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #存貨周轉率
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-084',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-085',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-086',g_lang)                              
   LET sr1.num01 = g_tot[1,25] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].h USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,7]                        #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,7]                        #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,7]                        #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,7]                        #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,7]                        #CHI-890029 mod
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次   #CHI-890029 add
   LET sr1.sort = 22                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #存貨維持日數                                                             
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-087',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-088',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-089',g_lang)                              
   LET sr1.num01 = 365*g_eff[1] USING '###'
   LET sr1.num02 = l_tot[1,7] USING '-,--&.&&'  #MOD-920254 mod #'#,###.&&'
   LET sr1.tot01 = l_tot[1,8]                        #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,8]                        #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,8]                        #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,8]                        #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,8]                        #CHI-890029 mod
   LET sr1.unit  = cl_getmsg('amr-201',g_lang) #天   #CHI-890029 add
   LET sr1.sort = 23                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #流動資產周轉率                                                           
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-090',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-091',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-092',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,6]                        #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,6]                        #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,6]                        #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,6]                        #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,6]                        #CHI-890029 mod
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次   #CHI-890029 add
   LET sr1.sort = 24                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #固定資產周轉率
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-093',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-094',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-095',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,12] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,28]                       #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,28]                       #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,28]                       #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,28]                       #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,28]                       #CHI-890029 mod
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次   #CHI-890029 add
   LET sr1.sort = 25                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #資產周轉率                                                               
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-096',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-097',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-098',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,27]                       #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,27]                       #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,27]                       #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,27]                       #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,27]                       #CHI-890029 mod
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次   #CHI-890029 add
   LET sr1.sort = 26                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #四.獲利能力%                                                             
   #資產報酬率                                                               
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-100',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-101',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-102',g_lang)                              
   LET sr1.num01 = sr[1].p+(g_tot[1,31]*0.75) USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = (sr[1].e+sr[1].t)/2 USING l_format2         #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,25]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,25]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,25]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,25]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,25]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 27                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*
 
   #股東權益報酬率                                                           
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-103',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-104',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-105',g_lang)                              
   LET sr1.num01 = sr[1].p USING l_format1              #'##,###,###,###,##&'
   LET sr1.num02 = (sr[1].k+sr[1].u)/2 USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,26]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,26]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,26]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,26]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,26]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 28                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #營業利益占實收資本比率                                                   
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-106',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-107',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-108',g_lang)                              
   LET sr1.num01 = sr[1].n USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,30]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,30]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,30]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,30]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,30]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 29                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #稅前純益占實收資本比率                                                   
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-109',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-110',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-111',g_lang)                              
   LET sr1.num01 = sr[1].o USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,31]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,31]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,31]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,31]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,31]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 30                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
        
   #毛利率                                                                   
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-112',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-113',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-114',g_lang)                              
   LET sr1.num01 = sr[1].l USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,23] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,32]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,32]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,32]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,32]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,32]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 31                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #營業利益率                                                               
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-115',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-116',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-117',g_lang)                              
   LET sr1.num01 = sr[1].n USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,23] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,33]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,33]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,33]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,33]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,33]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 32                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #稅前每股盈餘                                                             
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-118',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-119',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-120',g_lang)                              
   LET sr1.num01 = sr[1].o USING l_format1         #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19]/10 USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,34]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot02 = l_tot[2,34]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot03 = l_tot[3,34]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot04 = l_tot[4,34]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot05 = l_tot[5,34]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.unit  = ' '           #CHI-890029 add
   LET sr1.sort = 33                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*
 
   #稅後每股盈餘                                                             
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-124',g_lang)   #CHI-860004 add
   LET sr1.msg02 = cl_getmsg('abg-125',g_lang)   #CHI-860004 add
   LET sr1.msg03 = cl_getmsg('abg-126',g_lang)   #CHI-860004 add
   LET sr1.num01 = sr[1].o-g_tot[1,29] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19]/10 USING l_format2       #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,35]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot02 = l_tot[2,35]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot03 = l_tot[3,35]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot04 = l_tot[4,35]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.tot05 = l_tot[5,35]   #CHI-890029 mod   #CHI-860004 mod 拿掉%
   LET sr1.unit  = ' '           #CHI-890029 add
   LET sr1.sort = 34                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #五.業主權益對負債總額比率                                                
   LET sr1.title = cl_getmsg('abg-121',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-121',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-122',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-123',g_lang)                              
   LET sr1.num01 = sr[1].k USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].j USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,21]   #CHI-890029 mod
   LET sr1.tot02 = l_tot[2,21]   #CHI-890029 mod
   LET sr1.tot03 = l_tot[3,21]   #CHI-890029 mod
   LET sr1.tot04 = l_tot[4,21]   #CHI-890029 mod
   LET sr1.tot05 = l_tot[5,21]   #CHI-890029 mod
   LET sr1.unit  = '%'           #CHI-890029 add
   LET sr1.sort = 34                                                        
   LET sr1.sort2 = 5                                                        
   EXECUTE insert_prep USING sr1.* 
 
END FUNCTION
 
FUNCTION aglg401_get_format()
   DEFINE l_azi04   LIKE azi_file.azi04
   DEFINE l_format1 LIKE type_file.chr20
   DEFINE l_format2 LIKE type_file.chr20
 
   #抓取本國幣金額取位小數位數
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=g_aza.aza17
   #決定金額取位的FORMAT
   CASE l_azi04
      WHEN 0  LET l_format1 =  '--,---,---,---,--&'
              LET l_format2 = '-<<,<<<,<<<,<<<,<<&'
      WHEN 1  LET l_format1 =  '----,---,---,--&.&'
              LET l_format2 = '-<<<<,<<<,<<<,<<&.&'
      WHEN 2  LET l_format1 =  '---,---,---,--&.&&'
              LET l_format2 = '-<<<,<<<,<<<,<<&.&&'
      WHEN 3  LET l_format1 =  '--,---,---,--&.&&&'
              LET l_format2 = '-<<,<<<,<<<,<<&.&&&'
      WHEN 4  LET l_format1 =  '-,---,---,--&.&&&&'
              LET l_format2 = '-<,<<<,<<<,<<&.&&&&'
      WHEN 5  LET l_format1 =  '----,---,--&.&&&&&'
              LET l_format2 = '-<<<<,<<<,<<&.&&&&&'
      WHEN 6  LET l_format1 =  '---,---,--&.&&&&&&'
              LET l_format2 = '-<<<,<<<,<<&.&&&&&&'
   END CASE
   RETURN l_azi04,l_format1,l_format2
END FUNCTION
 
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg401_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg401")
        IF handler IS NOT NULL THEN
            START REPORT aglg401_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg401_datacur1 CURSOR FROM l_sql
            FOREACH aglg401_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg401_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg401_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg401_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B90028---add-----str---------
    DEFINE sr1_o  sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_count    LIKE type_file.num10
    DEFINE l_str         STRING         
    DEFINE l_unit        STRING     
    DEFINE l_detail      STRING
    DEFINE l_tmyy1      STRING
    DEFINE l_tmyy2      STRING
    DEFINE l_tmyy3      STRING
    DEFINE l_tmyy4      STRING
    DEFINE l_tmyy5      STRING
    DEFINE l_tmm0       STRING
    DEFINE l_tmm2       STRING
    DEFINE l_tmm3       STRING
    DEFINE l_tmm4       STRING
    DEFINE l_tmm5       STRING
    DEFINE l_tmm1       STRING
    DEFINE l_tmm6       STRING
    DEFINE l_tmm7       STRING
    DEFINE l_tmm8       STRING
    DEFINE l_tmm9       STRING
    DEFINE l_tmn1       STRING
    DEFINE l_tmn2       STRING
    DEFINE l_tmn3       STRING
    DEFINE l_tmn4       STRING
    DEFINE l_tmn5       STRING
    DEFINE l_date01      STRING
    DEFINE l_date02      STRING
    DEFINE l_date03      STRING
    DEFINE l_date04      STRING
    DEFINE l_date05      STRING
    DEFINE l_fmt         STRING
    DEFINE l_display     LIKE type_file.chr1
    DEFINE l_flag        LIKE type_file.chr1
    DEFINE l_flag1       LIKE type_file.chr1
    DEFINE l_display1    LIKE type_file.chr1
    DEFINE l_sort2       LIKE type_file.num5 
    #FUN-B90028---add-----end---------

    
    ORDER EXTERNAL BY sr1.sort2,sr1.sort
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_company,g_ptime,g_user_name    #FUN-B90028 add g_ptime,g_used_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.sort2
        BEFORE GROUP OF sr1.sort
            #FUN-B90028----add-----str----------
            LET l_tmyy1 = tm.yy1
            LET l_tmyy2 = tm.yy2
            LET l_tmyy3 = tm.yy3
            LET l_tmyy4 = tm.yy4
            LET l_tmyy5 = tm.yy5
            LET l_tmm1 = tm.m1
            LET l_tmm2 = tm.m2
            LET l_tmm3 = tm.m3
            LET l_tmm7 = tm.m7
            LET l_tmm6 = tm.m6
            LET l_tmm8 = tm.m8
            LET l_tmm9 = tm.m9
            LET l_tmm5 = tm.m5
            LET l_tmm0 = tm.m0
            LET l_tmm4 = tm.m4
            LET l_unit = cl_gr_getmsg("gre-211",g_lang,'1')
            LET l_detail = l_unit,l_tmyy1.trim(),'/',l_tmm1.trim(),'-',l_tmyy1.trim(),'/',l_tmm4.trim()
            PRINTX l_detail
            LET l_tmn1 = tm.n1
            PRINTX l_tmn1
            LET l_tmn2 = tm.n2
            PRINTX l_tmn2
            LET l_tmn3 = tm.n3
            PRINTX l_tmn3
            LET l_tmn4 = tm.n4
            PRINTX l_tmn4
            LET l_tmn5= tm.n5
            PRINTX l_tmn5
     
            LET l_date01 = l_tmyy1.trim(),'/',l_tmm1.trim(),'-',l_tmm4.trim()
            PRINTX l_date01
            LET l_date02 = l_tmyy2.trim(),'/',l_tmm2.trim(),'-',l_tmm5.trim()
            PRINTX l_date02
            LET l_date03 = l_tmyy3.trim(),'/',l_tmm3.trim(),'-',l_tmm6.trim()
            PRINTX l_date03
            LET l_date04 = l_tmyy4.trim(),'/',l_tmm7.trim(),'-',l_tmm9.trim()
            PRINTX l_date04
            LET l_date05 = l_tmyy5.trim(),'/',l_tmm8.trim(),'-',l_tmm0.trim()
            PRINTX l_date05
            #FUN-B90028----add-----end----------

                   
        ON EVERY ROW
            #FUN-B90028--------------ADD--------STAR---
            LET g_sql1 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         " WHERE sort2 = '",sr1.sort2,"'" 
            DECLARE aglg401_reordcur1 CURSOR FROM g_sql1
            FOREACH aglg401_reordcur1 INTO l_cnt END FOREACH

            LET g_sql2 = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         " WHERE sort2 = '",sr1.sort2,"'"
            DECLARE aglg401_reordcur2 CURSOR FROM g_sql1
            FOREACH aglg401_reordcur2 INTO sr1_o.*
              LET l_count = l_count + 1
              IF l_sort2 = sr1.sort2 THEN
                 LET l_flag1 = 'N'
              ELSE
                 LET l_flag1 = 'Y'
              END IF
            
              IF l_count = l_cnt THEN 
                 LET l_flag = 'N'
                 LET l_count = 0 
              ELSE
                 LET l_flag = 'Y'
              END IF
              LET l_sort2 = sr1.sort2

            END FOREACH   
            LET l_display = l_flag
            PRINTX l_display 
            LET l_display1 = l_flag1
            PRINTX l_display1 
             
            LET l_fmt = cl_gr_numfmt("type_file","num20_6",sr1.azi04)
            PRINTX l_fmt
     
            #FUN-B90028-----------END--------
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.sort2
        AFTER GROUP OF sr1.sort

        
        ON LAST ROW

END REPORT
###GENGRE###END
