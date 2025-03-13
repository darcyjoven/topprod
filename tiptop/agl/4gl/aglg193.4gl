# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg193.4gl
# Descriptions...: 七期實際報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 97/08/21 
# Modify.........: BY CONNIE 
# Modify.........: No.FUN-510007 05/02/21 By Nicola 報表架構修改
# Modify.........: No.MOD-570228 05/07/27 By Smapmin SQL語法有錯誤
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 07/01/04 By Judy 調整報表
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: No.FUN-780061 07/08/23 By zhoufeng 報表輸出改為Crystal Reports
# Modify.........: No.MOD-7C0051 07/12/17 By Smapmin 改變變數定義大小
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()     
# Modify.........: No.MOD-980220 09/08/27 By mike yy4 應為 num5      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark
# Modify.........: No:FUN-A30022 10/03/05 By Cockroch 增加選項【是否列印內部管理科目】--aag38
# Modify.........: No:MOD-A50060 10/05/11 By sabrina 若程式沒關掉，重複執行時會出現錯誤
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No:CHI-A40048 10/06/11 By Summer 1.未考量maj03='5'的情況 
#                                                   2.百分比計算邏輯，應該是跑完所有報表後找出設定百分比基準的科目與金額，
#                                                     再計算各筆資料的百分比
# Modify.........: No:CHI-A70046 10/08/04 By Summer 百分比需依金額單位顯示
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No.FUN-B80158 11/09/01 By yangtt 明細類cr轉換成GRW
# Modify.........: No.FUN-C50006 12/05/02 By tanxc GR程式優化
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,   #報表結構編號    #No.FUN-680098 VARCHAR(1) 
              a       LIKE mai_file.mai01,   #報表結構編號    #No.FUN-680098 VARCHAR(6) 
              dept    LIKE abe_file.abe01,                    #No.FUN-680098 VARCHAR(6)
              title1  LIKE type_file.chr8,  #輸入期別名稱     #No.FUN-680098 VARCHAR(8) 
              yy1     LIKE type_file.num5,  #輸入年度         #No.FUN-680098 smallint
              bm1     LIKE type_file.num5,  #Begin 期別       #No.FUN-680098 smallint
              em1     LIKE type_file.num5,  #End  期別        #No.FUN-680098 smallint
              title2  LIKE type_file.chr8,  #輸入期別名稱     #No.FUN-680098 VARCHAR(8) 
              yy2     LIKE type_file.num5,  #入年  度         #No.FUN-680098 smallint
              bm2     LIKE type_file.num5,                    #No.FUN-680098 smallint
              em2     LIKE type_file.num5,  #End  期別        #No.FUN-680098 smallint
              title3  LIKE type_file.chr8,  #輸入期別名稱     #No.FUN-680098 VARCHAR(8) 
              yy3     LIKE type_file.num5,  #輸入年度         #No.FUN-680098 smallint
              bm3     LIKE type_file.num5,  #Begin 期別       #No.FUN-680098 smallint
              em3     LIKE type_file.num5,  #End  期別        #No.FUN-680098 smallint
              title4  LIKE type_file.chr8,  #輸入期別名稱     #No.FUN-680098 VARCHAR(8) 
              yy4     LIKE type_file.num5,  #輸入年度         #No.FUN-680098 smallint #MOD-980220 chr8-->num5
              bm4     LIKE type_file.num5,  #Begin 期別       #No.FUN-680098 smallint
              em4     LIKE type_file.num5,  #End  期別        #No.FUN-680098 smallint
              title5  LIKE type_file.chr8,  #輸入期別名稱     #No.FUN-680098 VARCHAR(8)
              yy5     LIKE type_file.num5,  #輸入年度         #No.FUN-680098 smallint
              bm5     LIKE type_file.num5,  #Begin 期別       #No.FUN-680098 smallint
              em5     LIKE type_file.num5,  #End  期別        #No.FUN-680098 smallint
              title6  LIKE type_file.chr8,  #輸入期別名稱     #No.FUN-680098 VARCHAR(8)
              yy6     LIKE type_file.num5,  #輸入年度         #No.FUN-680098 smalint
              bm6     LIKE type_file.num5,  #Begin 期別       #No.FUN-680098 smallint
              em6     LIKE type_file.num5,  #End  期別        #No.FUN-680098 smallint
              title7  LIKE type_file.chr8,  #輸入期別名稱     #No.FUN-680098 VARCHAR(8)  
              yy7     LIKE type_file.num5,  #輸入年度         #No.FUN-680098 smallint
              bm7     LIKE type_file.num5,  #Begin 期別       #No.FUN-680098 smallint
              em7     LIKE type_file.num5,  #End  期別        #No.FUN-680098 smallint
              ac1     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac2     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac3     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac4     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac5     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac6     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac7     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac8     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
              ac9     LIKE aaa_file.aaa01,  #帳別   #No.FUN-670039
 
              aag38   LIKE aag_file.aag38,  #是否列印內部管理科目 #FUN-A30022 ADD
              e       LIKE type_file.num5,               #小數位數      #No.FUN-680098  smallint
              f       LIKE type_file.num5,               #列印最小階數  #No.FUN-680098  smallint
              d       LIKE type_file.chr1,               #金額單位      #No.FUN-680098  VARCHAR(1) 
              c       LIKE type_file.chr1,               #異動額及餘額為0者是否列印#No.FUN-680098   VARCHAR(1) 
              h       LIKE type_file.chr4,               #額外說明類別   #No.FUN-680098   VARCHAR(4) 
              o       LIKE type_file.chr1,               #轉換幣別否     #No.FUN-680098   VARCHAR(1) 
              r       LIKE azi_file.azi01,  #幣別
              p       LIKE azi_file.azi01,  #幣別
              q       LIKE azj_file.azj03,  #匯率
              more    LIKE type_file.chr1               #Input more condition(Y/N)  #No.FUN-680098   VARCHAR(1) 
          END RECORD,
          a_rep       DYNAMIC ARRAY OF RECORD 
              title   LIKE type_file.chr8,  #輸入期別名稱 #No.FUN-680098   VARCHAR(8) 
              yy      LIKE type_file.num5,  #輸入年     度#No.FUN-680098   smallint
              bm      LIKE type_file.num5,  #Begin 期別   #No.FUN-680098   smallint
              em      LIKE type_file.num5   #End  期別    #No.FUN-680098   smallint 
          END RECORD ,
          m_abd02     LIKE abd_file.abd02,          #No.FUN-680098   VARCHAR(6) 
          a_amt       ARRAY[7]    OF LIKE type_file.num20_6,# every row's value  #No.FUN-680098 dec(20,6) 
         #s_amt       ARRAY[50,7] OF LIKE type_file.num20_6,# every dept devide's value #No.FUN-680098  dec(20,6) #CHI-A40048 mark
          s_amt       ARRAY[7] OF LIKE aah_file.aah04,# every dept devide's value #CHI-A40048 add
          a_dbs       ARRAY[9,2]  OF LIKE type_file.chr21  ,  #No.FUN-680098    VARCHAR(20) 
          g_gem       RECORD LIKE gem_file.* ,
          t_dept      LIKE gem_file.gem01,
          i,j,k,r_cnt LIKE type_file.num5,       #No.FUN-680098  smallint
          g_unit      LIKE type_file.num10,      #金額單位基數 #No.FUN-680098 integer 
          g_dept      LIKE abe_file.abe01,       #No.FUN-680098   VARCHAR(6)
          g_buf       LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(200)  
          g_bookno    LIKE aah_file.aah00, #帳別
          g_mai02     LIKE mai_file.mai02,
          g_mai03     LIKE mai_file.mai03,
          g_tot       ARRAY[100,7] OF LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
          m_gem02     LIKE gem_file.gem02,
          rep_cnt     LIKE type_file.num5     #No.FUN-680098   smallint
DEFINE   g_aaa03      LIKE aaa_file.aaa03   
DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680098  integer
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 smallint
DEFINE   g_msg        LIKE type_file.chr1000  #No.FUN-680098   VARCHAR(72)
DEFINE   g_sql        STRING                  #No.FUN-780061
DEFINE   g_str        STRING                  #No.FUN-780061
DEFINE   l_table      STRING                  #No.FUN-780061
 
###GENGRE###START
TYPE sr1_t RECORD
    gem01 LIKE gem_file.gem01,
    gem02 LIKE gem_file.gem02,
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    amt01 LIKE type_file.num20_6,
    amt02 LIKE type_file.num20_6,
    amt03 LIKE type_file.num20_6,
    amt04 LIKE type_file.num20_6,
    amt05 LIKE type_file.num20_6,
    amt06 LIKE type_file.num20_6,
    amt07 LIKE type_file.num20_6,
    per01 LIKE cot_file.cot12,
    per02 LIKE cot_file.cot12,
    per03 LIKE cot_file.cot12,
    per04 LIKE cot_file.cot12,
    per05 LIKE cot_file.cot12,
    per06 LIKE cot_file.cot12,
    per07 LIKE cot_file.cot12,
    line LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-780061 --start--
   LET g_sql="gem01.gem_file.gem01,gem02.gem_file.gem02,maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,maj02.maj_file.maj02,",
             "maj03.maj_file.maj03,amt01.type_file.num20_6,",
             "amt02.type_file.num20_6,amt03.type_file.num20_6,",
             "amt04.type_file.num20_6,amt05.type_file.num20_6,",
             "amt06.type_file.num20_6,amt07.type_file.num20_6,",
             "per01.cot_file.cot12,per02.cot_file.cot12,per03.cot_file.cot12,",
             "per04.cot_file.cot12,per05.cot_file.cot12,per06.cot_file.cot12,",
             "per07.cot_file.cot12,line.type_file.num5"
   LET l_table = cl_prt_temptable('aglg193',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   #No.FUN-780061 --end--

  #CHI-A40048 add --start--
  LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
              "   SET per01 =?",
              "     , per02 =?",
              "     , per03 =?",
              "     , per04 =?",
              "     , per05 =?",
              "     , per06 =?",
              "     , per07 =?",
              " WHERE maj02=? AND gem01=? AND line=?"
  PREPARE update_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('update_prep:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
     CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
     EXIT PROGRAM
  END IF
  #CHI-A40048 add --end--
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
  #-----TQC-610056---------
  LET tm.a = ARG_VAL(9)
  LET tm.dept = ARG_VAL(10)
  LET tm.title1 = ARG_VAL(11)
  LET tm.yy1 = ARG_VAL(12)
  LET tm.bm1 = ARG_VAL(13)
  LET tm.em1 = ARG_VAL(14)
  LET tm.title2 = ARG_VAL(15)
  LET tm.yy2 = ARG_VAL(16)
  LET tm.bm2 = ARG_VAL(17)
  LET tm.em2 = ARG_VAL(18)
  LET tm.title3 = ARG_VAL(19)
  LET tm.yy3 = ARG_VAL(20)
  LET tm.bm3 = ARG_VAL(21)
  LET tm.em3 = ARG_VAL(22)
  LET tm.title4 = ARG_VAL(23)
  LET tm.yy4 = ARG_VAL(24)
  LET tm.bm4 = ARG_VAL(25)
  LET tm.em4 = ARG_VAL(26)
  LET tm.title5 = ARG_VAL(27)
  LET tm.yy5 = ARG_VAL(28)
  LET tm.bm5 = ARG_VAL(29)
  LET tm.em5 = ARG_VAL(30)
  LET tm.title6 = ARG_VAL(31)
  LET tm.yy6 = ARG_VAL(32)
  LET tm.bm6 = ARG_VAL(33)
  LET tm.em6 = ARG_VAL(34)
  LET tm.title7 = ARG_VAL(35)
  LET tm.yy7 = ARG_VAL(36)
  LET tm.bm7 = ARG_VAL(37)
  LET tm.em7 = ARG_VAL(38)
  LET tm.ac1 = ARG_VAL(39)
  LET tm.ac2 = ARG_VAL(40)
  LET tm.ac3 = ARG_VAL(41)
  LET tm.ac4 = ARG_VAL(42)
  LET tm.ac5 = ARG_VAL(43)
  LET tm.ac6 = ARG_VAL(44)
  LET tm.ac7 = ARG_VAL(45)
  LET tm.ac8 = ARG_VAL(46)
  LET tm.ac9 = ARG_VAL(47)
  LET tm.e = ARG_VAL(48)
  LET tm.f = ARG_VAL(49)
  LET tm.d = ARG_VAL(50)
  LET tm.c = ARG_VAL(51)
  LET tm.h = ARG_VAL(52)
  LET tm.o = ARG_VAL(53)
  LET tm.r = ARG_VAL(54)
  LET tm.p = ARG_VAL(55)
  LET tm.q = ARG_VAL(56)
  #-----END TQC-610056-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(57)
   LET g_rep_clas = ARG_VAL(58)
   LET g_template = ARG_VAL(59)
   LET g_rpt_name = ARG_VAL(60)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.aag38 = ARG_VAL(61)  #FUN-A30022 ADD

   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g193_tm()                # Input print condition
      ELSE CALL g193()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION g193_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,     #No.FUN-680098 smallint
          l_sw          LIKE type_file.chr1,     #重要欄位是否空白 #No.FUN-680098   VARCHAR(1) 
          l_cmd         LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(400)
   DEFINE li_result     LIKE type_file.num5      #NO.FUN-6C0068
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 1 LET p_col = 6
   ELSE LET p_row = 2 LET p_col = 3
   END IF
   OPEN WINDOW g193_w AT p_row,p_col
        WITH FORM "agl/42f/aglg193"  
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0) #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
   LET tm.c  = 'N'
   LET tm.d  = '1'
   LET tm.f  = 0
   LET tm.h  = 'N'
   LET tm.aag38 = 'N'   #FUN-A30022 ADD  
   LET tm.o  = 'N'
   LET tm.p  = g_aaa03
   LET tm.q  = 1
   LET tm.r  = g_aaa03
   LET tm.ac1= g_bookno #no.7600
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
    #NO.590002 START----------
    LET tm.rtype = '1'
    #NO.590002 END------------
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.rtype,tm.a,tm.dept,
                  tm.title1,tm.yy1,tm.bm1,tm.em1,
                  tm.title2,tm.yy2,tm.bm2,tm.em2,
                  tm.title3,tm.yy3,tm.bm3,tm.em3,
                  tm.title4,tm.yy4,tm.bm4,tm.em4,
                  tm.title5,tm.yy5,tm.bm5,tm.em5,
                  tm.title6,tm.yy6,tm.bm6,tm.em6,
                  tm.title7,tm.yy7,tm.bm7,tm.em7,
                  tm.ac1,tm.ac2,tm.ac3,tm.ac4,tm.ac5,tm.ac6,
                  tm.ac7,tm.ac8,tm.ac9,tm.aag38,             #FUN-A30022 ADD
                  tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                  tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD a
         IF tm.a IS NULL THEN NEXT FIELD a END IF
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                  AND mai00 = g_aza.aza81    #No.FUN-740020
         IF STATUS THEN
#           CALL cl_err('sel mai:',STATUS,0) #No.FUN-660123
            CALL cl_err3("sel","mai_file",g_aaa03,"",STATUS,"","sel mai:",0)   #No.FUN-660123
            NEXT FIELD a 
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
         END IF
 
      AFTER FIELD dept
         IF tm.dept IS NULL THEN NEXT FIELD dept END IF
         SELECT UNIQUE abe01 INTO g_dept FROM abe_file 
          WHERE abe01 = tm.dept
         IF STATUS <> 0 THEN
            LET g_dept =' '
            SELECT * FROM gem_file 
             WHERE gem01 = tm.dept AND gem05='Y'
            IF STATUS <> 0 THEN
               NEXT FIELD dept
            END IF
         END IF
         
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
            NEXT FIELD d
         END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
      AFTER FIELD e
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME tm.e
         END IF
 
      AFTER FIELD f
         IF tm.f IS NULL OR tm.f < 0  THEN
            LET tm.f = 0
            DISPLAY BY NAME tm.f
            NEXT FIELD f
         END IF
 
      AFTER FIELD h
         IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
      AFTER FIELD o
         IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
         IF tm.o = 'N' THEN 
            LET tm.p = g_aaa03 
            LET tm.q = 1
            DISPLAY g_aaa03 TO p
            DISPLAY BY NAME tm.q
         END IF
 
      BEFORE FIELD p
         IF tm.o = 'N' THEN NEXT FIELD more END IF
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN 
#           CALL cl_err(tm.p,'agl-109',0)
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)   #No.FUN-660123  
            NEXT FIELD p 
         END IF
 
      BEFORE FIELD q
         IF tm.o = 'N' THEN NEXT FIELD o END IF
 
     #FUN-A30022 ADD-------                                                                                                         
      AFTER FIELD aag38                                                                                                             
         IF cl_null(tm.aag38) OR tm.aag38 NOT MATCHES '[YN]' THEN                                                                   
            NEXT FIELD aag38                                                                                                        
         END IF                                                                                                                     
     #FUN-A30022 ADD END---
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT 
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLP
         IF INFIELD(a) THEN
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_mai'
    LET g_qryparam.default1 = tm.a
   #LET g_qryparam.where = " mai00 = '",g_aza.aza81,"'"       #No.FUN-740020   #No.TQC-C50042   Mark
    LET g_qryparam.where = " mai00 = '",g_aza.aza81,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
    CALL cl_create_qry() RETURNING tm.a
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
         IF INFIELD(p) THEN
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_azi'
    LET g_qryparam.default1 = tm.p
    CALL cl_create_qry() RETURNING tm.p
            DISPLAY BY NAME tm.p
            NEXT FIELD p
         END IF
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g193_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg193'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg193','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.rtype CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.dept CLIPPED,"'",
                        #-----TQC-610056---------
                        " '",tm.title1 CLIPPED,"'",
                        " '",tm.yy1 CLIPPED,"'",
                        " '",tm.bm1 CLIPPED,"'",
                        " '",tm.em1 CLIPPED,"'",
                        " '",tm.title2 CLIPPED,"'",
                        " '",tm.yy2 CLIPPED,"'",
                        " '",tm.bm2 CLIPPED,"'",
                        " '",tm.em2 CLIPPED,"'",
                        " '",tm.title3 CLIPPED,"'",
                        " '",tm.yy3 CLIPPED,"'",
                        " '",tm.bm3 CLIPPED,"'",
                        " '",tm.em3 CLIPPED,"'",
                        " '",tm.title4 CLIPPED,"'",
                        " '",tm.yy4 CLIPPED,"'",
                        " '",tm.bm4 CLIPPED,"'",
                        " '",tm.em4 CLIPPED,"'",
                        " '",tm.title5 CLIPPED,"'",
                        " '",tm.yy5 CLIPPED,"'",
                        " '",tm.bm5 CLIPPED,"'",
                        " '",tm.em5 CLIPPED,"'",
                        " '",tm.title6 CLIPPED,"'",
                        " '",tm.yy6 CLIPPED,"'",
                        " '",tm.bm6 CLIPPED,"'",
                        " '",tm.em6 CLIPPED,"'",
                        " '",tm.title7 CLIPPED,"'",
                        " '",tm.yy7 CLIPPED,"'",
                        " '",tm.bm7 CLIPPED,"'",
                        " '",tm.em7 CLIPPED,"'",
                        " '",tm.ac1 CLIPPED,"'",
                        " '",tm.ac2 CLIPPED,"'",
                        " '",tm.ac3 CLIPPED,"'",
                        " '",tm.ac4 CLIPPED,"'",
                        " '",tm.ac5 CLIPPED,"'",
                        " '",tm.ac6 CLIPPED,"'",
                        " '",tm.ac7 CLIPPED,"'",
                        " '",tm.ac8 CLIPPED,"'",
                        " '",tm.ac9 CLIPPED,"'",
                        #-----END TQC-610056-----
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",   #TQC-610056
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'",            #No.FUN-7C0078
                        " '",tm.aag38 CLIPPED,"'"     #FUN-A30022 ADD
         CALL cl_cmdat('aglg193',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g193_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g193()
   ERROR ""
END WHILE
   CLOSE WINDOW g193_w
END FUNCTION
 
FUNCTION g193()
   DEFINE l_name    LIKE type_file.chr20         # External(Disk) file name        #No.FUN-680098 VARCHAR(20) 
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE #l_sql1    LIKE type_file.chr1000       # RDSQL STATEMENT    #No.FUN-680098  VARCHAR(1000) 
          l_sql1      STRING     #NO.FUN-910082 
   DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680098     VARCHAR(1) 
   DEFINE l_leng    LIKE type_file.num5          #No.FUN-680098     smallint
   DEFINE l_abe03   LIKE abe_file.abe03
   #No.FUN-780061 --start--
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_tit1    LIKE type_file.chr1000          
   DEFINE l_tit2    LIKE type_file.chr1000          
   DEFINE l_tit3    LIKE type_file.chr1000          
   DEFINE l_tit4    LIKE type_file.chr1000          
   DEFINE l_tit5    LIKE type_file.chr1000          
   DEFINE l_tit6    LIKE type_file.chr1000          
   DEFINE l_tit7    LIKE type_file.chr1000
   #No.FUN-780061 --end--
 
   CALL cl_del_data(l_table)                     #No.FUN-780061
 
   LET g_buf = NULL    #MOD-A50060 add
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
          AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
 
   CALL move_datas()
   FOR g_i = 1 TO 7
       IF a_rep[g_i].yy IS NULL THEN 
          LET a_rep[g_i].yy = 0
       END IF
   END FOR    
   FOR g_i = 1 TO 100
       FOR i = 1 TO 7 
           LET g_tot[g_i,i] = 0
           IF g_i < 51 THEN 
             #LET s_amt[g_i,i] = 0 #CHI-A40048 mark
              LET s_amt[i] = 0     #CHI-A40048 add
           END IF
       END FOR 
   END FOR
   FOR i = 1 TO 9
       CALL r751_dbs(a_dbs[i,1]) RETURNING a_dbs[i,2] 
   END FOR 
 
   LET r_cnt = 0
 
#  CALL cl_outnam('aglg193') RETURNING l_name        #No.FUN-780061
   LET l_sql1 = "SELECT * FROM maj_file",
                " WHERE maj01 = '",tm.a,"'",
                "   AND ",g_msg CLIPPED,
                " ORDER BY maj02"
   PREPARE g193_p FROM l_sql1
   IF STATUS THEN CALL cl_err('prepare_1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   DECLARE g193_c CURSOR FOR g193_p
#  START REPORT g193_rep TO l_name                   #No.FUN-780061
 
#---------------------------------------------------
   IF g_dept=' ' THEN                     #--- 部門
      DECLARE g193_curs10 CURSOR FOR 
       SELECT abd02,gem05 FROM abd_file,gem_file WHERE abd01=tm.dept
                                                   AND gem01=abd02
        ORDER BY 1
      FOREACH g193_curs10 INTO m_abd02,l_chr
          IF SQLCA.SQLCODE THEN 
             EXIT FOREACH 
          END IF
          CALL g193_bom(m_abd02,l_chr)
      END FOREACH
      IF g_buf IS NULL THEN LET g_buf="'",tm.dept CLIPPED,"'," END IF
      LET l_leng=LENGTH(g_buf)
      LET g_buf=g_buf[1,l_leng-1] CLIPPED 
      CALL g193_process(tm.dept)
   ELSE                                    #--- 族群
      DECLARE g193_bom CURSOR FOR
       SELECT abe03,gem05 FROM abe_file,gem_file WHERE abe01=tm.dept
                                                   AND gem01=abe03
        ORDER BY 1
      FOREACH g193_bom INTO l_abe03,l_chr
          IF SQLCA.SQLCODE THEN 
             EXIT FOREACH 
          END IF
          CALL g193_bom(l_abe03,l_chr)
          IF g_buf IS NULL THEN LET g_buf="'",l_abe03 CLIPPED,"'," END IF
          LET l_leng=LENGTH(g_buf)
          LET g_buf=g_buf[1,l_leng-1] CLIPPED
          CALL g193_process(l_abe03)
          LET g_buf=''
      END FOREACH
   END IF
 
   LET rep_cnt=0
#---------------------------------------------------
 
#    FINISH REPORT g193_rep                          #No.FUN-780061
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #No.FUN-780061
     #No.FUN-780061 --start--
     LET l_tit1 = "(",tm.yy1 USING '<<<<','/',tm.bm1 USING'&&',
                  '-',tm.em1 USING'&&',")"
     LET l_tit2 = "(",tm.yy2 USING '<<<<','/',tm.bm2 USING'&&',
                  '-',tm.em2 USING'&&',")"
     LET l_tit3 = "(",tm.yy3 USING '<<<<','/',tm.bm3 USING'&&',
                  '-',tm.em3 USING'&&',")"
     LET l_tit4 = "(",tm.yy4 USING '<<<<','/',tm.bm4 USING'&&',
                  '-',tm.em4 USING'&&',")"
     LET l_tit5 = "(",tm.yy5 USING '<<<<','/',tm.bm5 USING'&&',
                  '-',tm.em5 USING'&&',")"
     LET l_tit6 = "(",tm.yy6 USING '<<<<','/',tm.bm6 USING'&&',
                  '-',tm.em6 USING'&&',")"
     LET l_tit7 = "(",tm.yy7 USING '<<<<','/',tm.bm7 USING'&&',
                  '-',tm.em7 USING'&&',")"
###GENGRE###     LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.e,";",tm.title1,";",
###GENGRE###                 tm.title2,";",tm.title3,";",tm.title4,";",tm.title5,";",
###GENGRE###                 tm.title6,";",tm.title7,";",l_tit1,";",l_tit2,";",l_tit3,";",
###GENGRE###                 l_tit4,";",l_tit5,";",l_tit6,";",l_tit7
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('aglg193','aglg193',l_sql,g_str)
    CALL aglg193_grdata()    ###GENGRE###
     #No.FUN-780061 --end--
END FUNCTION 
 
FUNCTION g193_process(l_dept)
   DEFINE l_dept          LIKE gem_file.gem01
   DEFINE l_sql2,l_sql3,l_sql4 STRING    # RDSQL STATEMENT    #No.FUN-680098  VARCHAR(600)    #MOD-7C0051
   DEFINE l_chr     LIKE type_file.chr1                  #No.FUN-680098   VARCHAR(1) 
   DEFINE l_gem01   LIKE gem_file.gem01
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE aah       RECORD LIKE aah_file.*
   DEFINE aao       RECORD LIKE aao_file.*
   DEFINE sr        ARRAY[7] OF LIKE type_file.num20_6    #No.FUN-680098 DEC(20,6)
   DEFINE l_amt     LIKE aao_file.aao05
   DEFINE per       ARRAY[7] OF LIKE cot_file.cot12       #No.FUN-780061
  #CHI-A40048 add --start--
  DEFINE l_sql     STRING
  DEFINE cr        RECORD     
                      maj02  LIKE maj_file.maj02,
                      amt01   LIKE aao_file.aao05,
                      amt02   LIKE aao_file.aao05,
                      amt03   LIKE aao_file.aao05,
                      amt04   LIKE aao_file.aao05,
                      amt05   LIKE aao_file.aao05,
                      amt06   LIKE aao_file.aao05,
                      amt07   LIKE aao_file.aao05,
                      line   LIKE type_file.num5
                   END RECORD
  #CHI-A40048 add --end--
   #FUN-C50006--add--begin--
   LET l_sql4 = "SELECT SUM(aao05-aao06) " ,
                 " FROM aao_file,aag_file ",   
                " WHERE aao01 BETWEEN ? AND ? ",
                "   AND aao02 IN (",g_buf CLIPPED,")",
                "   AND aao03 = ? ",
                "   AND aao04 BETWEEN ? AND ? ",
                "   AND aao00 = ? ",
		"   AND aao01 = aag01",
		"   AND aao00 = aag00",
                "   AND aag07 IN ('2','3') "
   
   LET l_sql4 = l_sql4 CLIPPED," AND aag38= '",tm.aag38,"'"      #FUN-A30022 ADD
   PREPARE pre_sql4 FROM l_sql4
   IF STATUS THEN 
      CALL cl_err('prepare_4:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE a4_curs CURSOR FOR pre_sql4
   #FUN-C50006--add--end-- 
   LET r_cnt = r_cnt + 1
   FOREACH g193_c INTO maj.*
      FOR g_i = 1 TO 7
          LET a_amt[g_i] = 0
          LET sr[g_i]    = 0
          IF a_rep[g_i].yy = 0 OR a_rep[g_i].yy IS NULL THEN 
             CONTINUE FOR 
          END IF
          FOR i = 1 TO 9
              IF cl_null(a_dbs[i,1]) THEN CONTINUE FOR END IF #no.7600 帳別
              IF cl_null(a_dbs[i,2]) THEN CONTINUE FOR END IF #        資料庫
 
              #FUN-C50006--mark--begin--
              #LET l_sql4 = "SELECT SUM(aao05-aao06) " ,
 #            #               "  FROM ",a_dbs[i,2] CLIPPED,   #MOD-570228
 #            #               ".aao_file,aag_file ",   #MOD-570228
              #              " FROM aao_file,aag_file ",   #MOD-570228
              #             " WHERE aao01 BETWEEN ? AND ? ",
              #             "   AND aao02 IN (",g_buf CLIPPED,")",
              #             "   AND aao03 = ? ",
              #             "   AND aao04 BETWEEN ? AND ? ",
              #             "   AND aao00 = ? ",
              #             "   AND aao00 = aag00",      #No.FUN-740020
              #             "   AND aao01 = aag01 ",
              #             "   AND aag07 IN ('2','3') "
              #
              #LET l_sql4 = l_sql4 CLIPPED," AND aag38= '",tm.aag38,"'"      #FUN-A30022 ADD
              #PREPARE pre_sql4 FROM l_sql4
              #IF STATUS THEN 
              #   CALL cl_err('prepare_4:',STATUS,1)
              #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
              #   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
              #   EXIT PROGRAM
              #END IF
              #DECLARE a4_curs CURSOR FOR pre_sql4
              #FUN-C50006--mark--end--
              OPEN a4_curs USING maj.maj21,maj.maj22,
                                 a_rep[g_i].yy,
                                 a_rep[g_i].bm,a_rep[g_i].em,
                                 a_dbs[i,1]
              FETCH a4_curs INTO l_amt 
              IF STATUS OR l_amt IS NULL THEN 
                 LET l_amt = 0
              END IF
              LET a_amt[g_i] = a_amt[g_i] + l_amt
              CLOSE a4_curs
          END FOR
          IF tm.o = 'Y' THEN
             LET a_amt[g_i] = a_amt[g_i] * tm.q
          END IF
          IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN      #合計階數處理
             FOR i = 1 TO 100
                 IF a_amt[g_i] IS NULL OR a_amt[g_i] = 0 THEN 
                    CONTINUE FOR 
                 END IF
                #CHI-A70050---modify---start---
                #LET g_tot[i,g_i]=g_tot[i,g_i]+a_amt[g_i]
                 IF maj.maj09 = '-' THEN
                    LET g_tot[i,g_i]=g_tot[i,g_i]-a_amt[g_i]
                 ELSE
                    LET g_tot[i,g_i]=g_tot[i,g_i]+a_amt[g_i]
                 END IF
                #CHI-A70050---modify---end---
             END FOR
             LET k=maj.maj08 
             LET sr[g_i] = g_tot[k,g_i] 
            #CHI-A70050---add---start---
             IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
                LET sr[g_i] = sr[g_i] *-1
             END IF
            #CHI-A70050---add---end---
             FOR i = 1 TO maj.maj08 
                 LET g_tot[i,g_i] = 0
             END FOR
          #CHI-A40048 add --start-- 
          ELSE
             IF maj.maj03 = '5' THEN
                LET sr[g_i] = a_amt[g_i]
             ELSE
                LET sr[g_i] = NULL
             END IF
          #CHI-A40048  add --end--
          END IF
          IF maj.maj11 = 'Y' THEN 
             #CHI-A40048 mark --start--
             #IF maj.maj07 = '2' THEN 
             #   LET s_amt[r_cnt,g_i] = - sr[g_i] 
             #ELSE
             #   LET s_amt[r_cnt,g_i] = sr[g_i] 
             #END IF
             #CHI-A40048 mark --end--
             #CHI-A40048 add --start--
             LET s_amt[g_i] = sr[g_i] 
             IF s_amt[g_i] = sr[g_i] = 0 THEN
                LET s_amt[g_i] = NULL
             END IF
             IF maj.maj07 = '2' THEN 
                LET s_amt[g_i] = s_amt[g_i] * -1
             END IF  
             #CHI-A40048 add --end--
             LET s_amt[g_i]=s_amt[g_i]/g_unit #CHI-A70046 add
          END IF 
      END FOR 
      FOR i = 1 TO 7
          IF sr[i] = 0 THEN 
             LET sr[i] = NULL
          END IF
      END FOR  
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"               #CHI-CC0023 add maj03 match 5 
          AND sr[1] IS NULL AND sr[2] IS NULL AND sr[3] IS NULL 
          AND sr[4] IS NULL AND sr[5] IS NULL AND sr[6] IS NULL 
          AND sr[7] IS NULL THEN 
          CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
#     OUTPUT TO REPORT g193_rep(l_dept,maj.*,sr[1],sr[2],sr[3], #No.FUN-780061
#                                sr[4],sr[5],sr[6],sr[7],r_cnt) #No.FUN-780061
      #No.FUN-780061 --start--
      IF maj.maj07 = '2' THEN
         LET sr[1] = - sr[1]
         LET sr[2] = - sr[2]
         LET sr[3] = - sr[3]
         LET sr[4] = - sr[4]
         LET sr[5] = - sr[5]
         LET sr[6] = - sr[6]
         LET sr[7] = - sr[7]
      END IF
      IF tm.h = 'Y' THEN
         LET maj.maj20 = maj.maj20e
      END IF
 
      IF tm.d MATCHES '[23]' THEN
         LET sr[1] = sr[1] / g_unit
         LET sr[2] = sr[2] / g_unit
         LET sr[3] = sr[3] / g_unit
         LET sr[4] = sr[4] / g_unit
         LET sr[5] = sr[5] / g_unit
         LET sr[6] = sr[6] / g_unit
         LET sr[7] = sr[7] / g_unit
      END IF
   
      FOR i = 1 TO 7
        #LET per[i] = NULL #CHI-A40048 mark
         LET per[i] = 0    #CHI-A40048 add
      END FOR 
      #CHI-A40048 mark --start--
      #IF s_amt[r_cnt,1] <> 0 THEN 
      #   LET per[1] = (sr[1]/s_amt[r_cnt,1]) * 100 
      #END IF
      #IF s_amt[r_cnt,2] <> 0 THEN 
      #   LET per[2] = (sr[2]/s_amt[r_cnt,2]) * 100
      #END IF
      #IF s_amt[r_cnt,3] <> 0 THEN 
      #   LET per[3] = (sr[3]/s_amt[r_cnt,3]) * 100 
      #END IF
      #IF s_amt[r_cnt,4] <> 0 THEN 
      #   LET per[4] = (sr[4]/s_amt[r_cnt,4]) * 100
      #END IF
      #IF s_amt[r_cnt,5] <> 0 THEN 
      #   LET per[5] = (sr[5]/s_amt[r_cnt,5]) * 100
      #END IF
      #IF s_amt[r_cnt,6] <> 0 THEN 
      #   LET per[6] = (sr[6]/s_amt[r_cnt,6]) * 100
      #END IF
      #IF s_amt[r_cnt,7] <> 0 THEN 
      #   LET per[7] = (sr[7]/s_amt[r_cnt,7]) * 100
      #END IF
      #CHI-A40048 mark --end--
 
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
 
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01= l_dept
      
      IF maj.maj04 = 0 THEN
         EXECUTE insert_prep USING l_dept,l_gem02,maj.maj20,maj.maj20e,
                                   maj.maj02,maj.maj03,sr[1],sr[2],sr[3],
                                   sr[4],sr[5],sr[6],sr[7],
                                   per[1],per[2],per[3],
                                   per[4],per[5],per[6],per[7],'2'
      ELSE
         EXECUTE insert_prep USING l_dept,l_gem02,maj.maj20,maj.maj20e,         
                                   maj.maj02,maj.maj03,sr[1],sr[2],sr[3],       
                                   sr[4],sr[5],sr[6],sr[7],                     
                                   per[1],per[2],per[3],       
                                   per[4],per[5],per[6],per[7],'2'
         FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING l_dept,l_gem02,maj.maj20,maj.maj20e,
                                      maj.maj02,'','0','0','0','0','0',
                                      '0','0','0','0','0','0','0','0',
                                      '0','1'
         END FOR
      END IF
      #No.FUN-780061 --end--
         
   END FOREACH  
  #CHI-A40048 add --start--
  IF (NOT cl_null(s_amt[1])) OR (NOT cl_null(s_amt[2])) OR (NOT cl_null(s_amt[3])) OR (NOT cl_null(s_amt[4])) 
     OR (NOT cl_null(s_amt[5])) OR (NOT cl_null(s_amt[6])) OR (NOT cl_null(s_amt[7])) THEN
     LET l_sql = "SELECT maj02,amt01,amt02,amt03,amt04,amt05,amt06,amt07,line",
                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE gem01='",l_dept,"'"
     PREPARE g193_crtmp_p FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
     END IF
     DECLARE g193_crtmp_c CURSOR FOR g193_crtmp_p
     FOREACH g193_crtmp_c INTO cr.*
        IF s_amt[1] <> 0 THEN 
           LET per[1] = (cr.amt01/s_amt[1]) * 100 
        END IF
        IF s_amt[2] <> 0 THEN 
           LET per[2] = (cr.amt02/s_amt[2]) * 100
        END IF
        IF s_amt[3] <> 0 THEN 
           LET per[3] = (cr.amt03/s_amt[3]) * 100 
        END IF
        IF s_amt[4] <> 0 THEN 
           LET per[4] = (cr.amt04/s_amt[4]) * 100
        END IF
        IF s_amt[5] <> 0 THEN 
           LET per[5] = (cr.amt05/s_amt[5]) * 100
        END IF
        IF s_amt[6] <> 0 THEN 
           LET per[6] = (cr.amt06/s_amt[6]) * 100
        END IF
        IF s_amt[7] <> 0 THEN 
           LET per[7] = (cr.amt07/s_amt[7]) * 100
        END IF

        EXECUTE update_prep USING per[1],per[2],per[3],per[4],per[5],per[6],per[7],cr.maj02,l_dept,cr.line
     END FOREACH
  END IF
  #CHI-A40048 add --end--
END FUNCTION
 
FUNCTION r751_dbs(l_ac)
    DEFINE l_ac    LIKE   aaa_file.aaa01
    DEFINE l_azp   RECORD LIKE azp_file.*
    DEFINE l_seq   LIKE  type_file.chr1000    #No.FUN-680098   VARCHAR(300) 
    
    IF cl_null(l_ac) THEN RETURN '' END IF #no.7600
    DECLARE r751_z1 CURSOR FOR 
     SELECT * FROM azp_file
      WHERE azp053 != 'N'       #no.7431 ERP資料庫
        AND azp01 IN(SELECT azw01 FROM azw_file WHERE azwacti = 'Y')  #FUN-A50102
    FOREACH r751_z1 INTO l_azp.*
#     LET l_seq = "SELECT aaa01 FROM ",l_azp.azp03 CLIPPED,".aaa_file ",    #TQC-950003 MARK                                        
     #LET l_seq = "SELECT aaa01 FROM ",s_dbstring(l_azp.azp03),"aaa_file ", #TQC-950003 ADD #FUN-A50102
      LET l_seq = "SELECT aaa01 FROM ",cl_get_target_table(l_azp.azp01,'aaa_file'),   #FUN-A50102 
                  " WHERE aaa01 = '",l_ac,"'"
      CALL cl_replace_sqldb(l_seq) RETURNING l_seq  #FUN-A50102
      CALL cl_parse_qry_sql(l_seq,l_azp.azp01) RETURNING l_seq   #FUN-A50102
      PREPARE pre_str1 FROM l_seq
#     EXECUTE pre_str1   # informix version not matches,故在 v4.x 需開 cursor 
      DECLARE r751_z2 CURSOR FOR pre_str1
      OPEN r751_z2
      FETCH r751_z2
      IF STATUS = 0 THEN 
         RETURN l_azp.azp03
      END IF
      CLOSE r751_z2
    END FOREACH 
    RETURN ''
END FUNCTION 
#No.FUN-780061 --start-- mark
{REPORT g193_rep(r_gem01,maj,sr,r_cnt)
   DEFINE l_last_sw,page_jp  LIKE type_file.chr1        #No.FUN-680098   VARCHAR(1) 
   DEFINE l_unit             LIKE zaa_file.zaa08        #No.FUN-680098   VARCHAR(4) 
   DEFINE r_gem01            LIKE gem_file.gem01
   DEFINE r_gem02            LIKE gem_file.gem02
   DEFINE maj                RECORD LIKE maj_file.*
   DEFINE sr                 RECORD
                                amt1   LIKE aao_file.aao05,
                                amt2   LIKE aao_file.aao05,
                                amt3   LIKE aao_file.aao05,
                                amt4   LIKE aao_file.aao05,
                                amt5   LIKE aao_file.aao05,
                                amt6   LIKE aao_file.aao05,
                                amt7   LIKE aao_file.aao05
                             END RECORD
   DEFINE per         ARRAY[7] OF LIKE cot_file.cot12,  #No.FUN-680098 dec(7,1)
          r_cnt       LIKE type_file.num5             #No.FUN-680098   smallint
   DEFINE g_head1     STRING  
   DEFINE l_tit1      LIKE type_file.chr1000          #No.FUN-680098   VARCHAR(12) 
   DEFINE l_tit2      LIKE type_file.chr1000          #No.FUN-680098   VARCHAR(12) 
   DEFINE l_tit3      LIKE type_file.chr1000          #No.FUN-680098   VARCHAR(12) 
   DEFINE l_tit4      LIKE type_file.chr1000          #No.FUN-680098   VARCHAR(12) 
   DEFINE l_tit5      LIKE type_file.chr1000          #No.FUN-680098   VARCHAR(12) 
   DEFINE l_tit6      LIKE type_file.chr1000          #No.FUN-680098   VARCHAR(12) 
   DEFINE l_tit7      LIKE type_file.chr1000          #No.FUN-680098   VARCHAR(12) 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY r_gem01,maj.maj02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         LET g_x[1] = g_mai02
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
     
         #金額單位之列印
         CASE tm.d
            WHEN '1'  LET l_unit = g_x[12]
            WHEN '2'  LET l_unit = g_x[13]
            WHEN '3'  LET l_unit = g_x[14]
            OTHERWISE LET l_unit = ' '
         END CASE
 
         LET g_head1 = g_x[10] CLIPPED,tm.a,'               ',
                       g_x[15] CLIPPED,tm.p,'     ',
                       g_x[11] CLIPPED,l_unit
         PRINT g_head1
     
         SELECT gem02 INTO r_gem02 FROM gem_file WHERE gem01= r_gem01
         IF STATUS THEN 
            LET r_gem02 = ' '
         END IF
     
         LET g_head1 = g_x[16],r_gem02
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[32],tm.title1 CLIPPED,  #FUN-6C0012
               COLUMN g_c[34],tm.title2 CLIPPED,  #FUN-6C0012
               COLUMN g_c[36],tm.title3 CLIPPED,  #FUN-6C0012
               COLUMN g_c[38],tm.title4 CLIPPED,  #FUN-6C0012
               COLUMN g_c[40],tm.title5 CLIPPED,  #FUN-6C0012
               COLUMN g_c[42],tm.title6 CLIPPED,  #FUN-6C0012
               COLUMN g_c[44],tm.title7 CLIPPED   #FUN-6C0012
 
         LET l_tit1 = "(",tm.yy1 USING '<<<<','/',tm.bm1 USING'&&',
                      '-',tm.em1 USING'&&',")"
         LET l_tit2 = "(",tm.yy2 USING '<<<<','/',tm.bm2 USING'&&',
                      '-',tm.em2 USING'&&',")"
         LET l_tit3 = "(",tm.yy3 USING '<<<<','/',tm.bm3 USING'&&',
                      '-',tm.em3 USING'&&',")"
         LET l_tit4 = "(",tm.yy4 USING '<<<<','/',tm.bm4 USING'&&',
                      '-',tm.em4 USING'&&',")"
         LET l_tit5 = "(",tm.yy5 USING '<<<<','/',tm.bm5 USING'&&',
                      '-',tm.em5 USING'&&',")"
         LET l_tit6 = "(",tm.yy6 USING '<<<<','/',tm.bm6 USING'&&',
                      '-',tm.em6 USING'&&',")"
         LET l_tit7 = "(",tm.yy7 USING '<<<<','/',tm.bm7 USING'&&',
                      '-',tm.em7 USING'&&',")"
         PRINT COLUMN g_c[32],l_tit1 CLIPPED,  #FUN-6C0012
               COLUMN g_c[34],l_tit2 CLIPPED,  #FUN-6C0012
               COLUMN g_c[36],l_tit3 CLIPPED,  #FUN-6C0012
               COLUMN g_c[38],l_tit4 CLIPPED,  #FUN-6C0012
               COLUMN g_c[40],l_tit5 CLIPPED,  #FUN-6C0012 
               COLUMN g_c[42],l_tit6 CLIPPED,  #FUN-6C0012 
               COLUMN g_c[44],l_tit7 CLIPPED   #FUN-6C0012 
 
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
         PRINT g_dash1
         LET l_last_sw = 'n'
         LET page_jp = 'n'
 
      BEFORE GROUP OF r_gem01
         IF page_jp = 'y' THEN 
            SKIP TO TOP OF PAGE
         END IF
 
      ON EVERY ROW
         LET page_jp = 'y'
         IF maj.maj07 = '2' THEN
            LET sr.amt1 = - sr.amt1
            LET sr.amt2 = - sr.amt2
            LET sr.amt3 = - sr.amt3
            LET sr.amt4 = - sr.amt4
            LET sr.amt5 = - sr.amt5
            LET sr.amt6 = - sr.amt6
            LET sr.amt7 = - sr.amt7
         END IF
 
         IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e
         END IF
 
         CASE 
            WHEN maj.maj03 = '9'
               SKIP TO TOP OF PAGE
            WHEN maj.maj03 = '3' 
               FOR i = 1 TO 7
                  IF a_rep[i].yy = 0 OR a_rep[i].yy IS NULL THEN 
                     CONTINUE FOR 
                  END IF
                  PRINT COLUMN g_c[31+i],g_dash2[1,g_w[31+i]],
                        COLUMN g_c[31+(i*2)],g_dash2[1,g_w[31+(i*2)]];
               END FOR 
               PRINT
            WHEN maj.maj03 = '4'
               PRINT g_dash2[1,g_len]
            WHEN maj.maj03 = 'H' 
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               PRINT COLUMN g_c[31],maj.maj20 
            OTHERWISE
               FOR i = 1 TO maj.maj04
                  PRINT
               END FOR
               IF tm.d MATCHES '[23]' THEN
                  LET sr.amt1 = sr.amt1 / g_unit
                  LET sr.amt2 = sr.amt2 / g_unit
                  LET sr.amt3 = sr.amt3 / g_unit
                  LET sr.amt4 = sr.amt4 / g_unit
                  LET sr.amt5 = sr.amt5 / g_unit
                  LET sr.amt6 = sr.amt6 / g_unit
                  LET sr.amt7 = sr.amt7 / g_unit
               END IF
               FOR i = 1 TO 7
                  LET per[i] = NULL
               END FOR 
               IF s_amt[r_cnt,1] <> 0 THEN 
                  LET per[1] = (sr.amt1/s_amt[r_cnt,1]) * 100 
               END IF
               IF s_amt[r_cnt,2] <> 0 THEN 
                  LET per[2] = (sr.amt2/s_amt[r_cnt,2]) * 100
               END IF
               IF s_amt[r_cnt,3] <> 0 THEN 
                  LET per[3] = (sr.amt3/s_amt[r_cnt,3]) * 100 
               END IF
               IF s_amt[r_cnt,4] <> 0 THEN 
                  LET per[4] = (sr.amt4/s_amt[r_cnt,4]) * 100
               END IF
               IF s_amt[r_cnt,5] <> 0 THEN 
                  LET per[5] = (sr.amt5/s_amt[r_cnt,5]) * 100
               END IF
               IF s_amt[r_cnt,6] <> 0 THEN 
                  LET per[6] = (sr.amt6/s_amt[r_cnt,6]) * 100
               END IF
               IF s_amt[r_cnt,7] <> 0 THEN 
                  LET per[7] = (sr.amt7/s_amt[r_cnt,7]) * 100
               END IF
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               PRINT COLUMN g_c[31],maj.maj20 CLIPPED,
                     COLUMN g_c[32],cl_numfor(sr.amt1,32,tm.e),
                     COLUMN g_c[33],(per[1]) USING '---&.&&%',
                     COLUMN g_c[34],cl_numfor(sr.amt2,34,tm.e),
                     COLUMN g_c[35],(per[2]) USING '---&.&&%',
                     COLUMN g_c[36],cl_numfor(sr.amt3,36,tm.e),
                     COLUMN g_c[37],(per[3]) USING '---&.&&%',
                     COLUMN g_c[38],cl_numfor(sr.amt4,38,tm.e),
                     COLUMN g_c[39],(per[4]) USING '---&.&&%',
                     COLUMN g_c[40],cl_numfor(sr.amt5,40,tm.e),
                     COLUMN g_c[41],(per[5]) USING '---&.&&%',
                     COLUMN g_c[42],cl_numfor(sr.amt6,42,tm.e),
                     COLUMN g_c[43],(per[6]) USING '---&.&&%',
                     COLUMN g_c[44],cl_numfor(sr.amt7,44,tm.e),
                     COLUMN g_c[45],(per[7]) USING '---&.&&%'
         END CASE
     
      ON LAST ROW
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
     
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
     
END REPORT}
#No.FUN-780061 --end--
FUNCTION move_datas()
    LET a_rep[1].title = tm.title1 
    LET a_rep[1].yy    = tm.yy1
    LET a_rep[1].bm    = tm.bm1
    LET a_rep[1].em    = tm.em1
 
    LET a_rep[2].title = tm.title2 
    LET a_rep[2].yy    = tm.yy2
    LET a_rep[2].bm    = tm.bm2
    LET a_rep[2].em    = tm.em2
 
    LET a_rep[3].title = tm.title3
    LET a_rep[3].yy    = tm.yy3
    LET a_rep[3].bm    = tm.bm3
    LET a_rep[3].em    = tm.em3
 
    LET a_rep[4].title = tm.title4
    LET a_rep[4].yy    = tm.yy4
    LET a_rep[4].bm    = tm.bm4
    LET a_rep[4].em    = tm.em4
 
    LET a_rep[5].title = tm.title5 
    LET a_rep[5].yy    = tm.yy5
    LET a_rep[5].bm    = tm.bm5
    LET a_rep[5].em    = tm.em5
 
    LET a_rep[6].title = tm.title6 
    LET a_rep[6].yy    = tm.yy6
    LET a_rep[6].bm    = tm.bm6
    LET a_rep[6].em    = tm.em6
 
    LET a_rep[7].title = tm.title7 
    LET a_rep[7].yy    = tm.yy7
    LET a_rep[7].bm    = tm.bm7
    LET a_rep[7].em    = tm.em7
 
    LET a_dbs[1,1]     = tm.ac1 
    LET a_dbs[2,1]     = tm.ac2 
    LET a_dbs[3,1]     = tm.ac3 
    LET a_dbs[4,1]     = tm.ac4 
    LET a_dbs[5,1]     = tm.ac5 
    LET a_dbs[6,1]     = tm.ac6 
    LET a_dbs[7,1]     = tm.ac7 
    LET a_dbs[8,1]     = tm.ac8 
    LET a_dbs[9,1]     = tm.ac9 
    FOR g_cnt = 1 TO 9 
        LET a_dbs[g_cnt,2] = ''
    END FOR 
END FUNCTION 
 
FUNCTION g193_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01               #No.FUN-680098   VARCHAR(6) 
    DEFINE l_sw     LIKE type_file.chr1               #No.FUN-680098   VARCHAR(1) 
    DEFINE l_abd02  LIKE abd_file.abd02               #No.FUN-680098   VARCHAR(6)  
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5          #No.FUN-680098   SMALLINT
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             gem01 LIKE gem_file.gem01,
             gem05 LIKE gem_file.gem05
           END RECORD
 
### 98/03/06 REWRITE BY CONNIE,遞迴有誤,故採用陣列作法.....
    LET l_cnt1 = 1
    DECLARE a_curs CURSOR FOR 
     SELECT abd02,gem05 FROM abd_file,gem_file
      WHERE abd01 = l_dept
        AND abd02 = gem01
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH 
 
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].gem01 IS NOT NULL THEN 
           CALL g193_bom(l_arr[l_cnt2].*)
        END IF
    END FOR 
    IF l_sw = 'Y' THEN 
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION

###GENGRE###START
FUNCTION aglg193_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg193")
        IF handler IS NOT NULL THEN
            START REPORT aglg193_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg193_datacur1 CURSOR FROM l_sql
            FOREACH aglg193_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg193_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg193_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg193_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158------add----str-------
    DEFINE l_per1    STRING
    DEFINE l_per2    STRING
    DEFINE l_per3    STRING
    DEFINE l_per4    STRING
    DEFINE l_per5    STRING
    DEFINE l_per6    STRING
    DEFINE l_per7    STRING
    DEFINE l_unit    STRING
    DEFINE l_tit1    LIKE type_file.chr1000          
    DEFINE l_tit2    LIKE type_file.chr1000          
    DEFINE l_tit3    LIKE type_file.chr1000          
    DEFINE l_tit4    LIKE type_file.chr1000          
    DEFINE l_tit5    LIKE type_file.chr1000          
    DEFINE l_tit6    LIKE type_file.chr1000          
    DEFINE l_tit7    LIKE type_file.chr1000
    DEFINE l_amt_fmt STRING
    DEFINE l_title2      STRING
    #FUN-B80158------add----end-------

    
    ORDER EXTERNAL BY sr1.gem01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80158------add----str-------
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit

            IF g_aaz.aaz77 = 'Y' THEN
               LET l_title2 = g_mai02
            ELSE
               LET l_title2 = g_grPageHeader.title2
            END IF
            PRINTX l_title2
            LET l_tit1 = "(",tm.yy1 USING '<<<<','/',tm.bm1 USING'&&',
                           '-',tm.em1 USING'&&',")"
            LET l_tit2 = "(",tm.yy2 USING '<<<<','/',tm.bm2 USING'&&',
                           '-',tm.em2 USING'&&',")"
            LET l_tit3 = "(",tm.yy3 USING '<<<<','/',tm.bm3 USING'&&',
                           '-',tm.em3 USING'&&',")"
            LET l_tit4 = "(",tm.yy4 USING '<<<<','/',tm.bm4 USING'&&',
                           '-',tm.em4 USING'&&',")"
            LET l_tit5 = "(",tm.yy5 USING '<<<<','/',tm.bm5 USING'&&',
                           '-',tm.em5 USING'&&',")"
            LET l_tit6 = "(",tm.yy6 USING '<<<<','/',tm.bm6 USING'&&',
                           '-',tm.em6 USING'&&',")"
            LET l_tit7 = "(",tm.yy7 USING '<<<<','/',tm.bm7 USING'&&',
                           '-',tm.em7 USING'&&',")"
            PRINTX l_tit1
            PRINTX l_tit2
            PRINTX l_tit3
            PRINTX l_tit4
            PRINTX l_tit5
            PRINTX l_tit6
            PRINTX l_tit7
            #FUN-B80158------add----end-------
              
        BEFORE GROUP OF sr1.gem01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158------add----str-------
            IF cl_null(sr1.per01) THEN
               LET l_per1 = NULL
            ELSE
               LET l_per1 = sr1.per01 USING '--,---,--&.&&'
               LET l_per1 = l_per1.trim()
            END IF
            PRINTX l_per1

            IF cl_null(sr1.per02) THEN
               LET l_per2 = NULL
            ELSE
               LET l_per2 = sr1.per02 USING '--,---,--&.&&'
               LET l_per2 = l_per2.trim()
            END IF
            PRINTX l_per2

            IF cl_null(sr1.per03) THEN
               LET l_per3 = NULL
            ELSE
               LET l_per3 = sr1.per03 USING '--,---,--&.&&'
               LET l_per3 = l_per3.trim()
            END IF
            PRINTX l_per3

            IF cl_null(sr1.per04) THEN
               LET l_per4 = NULL
            ELSE
               LET l_per4 = sr1.per04 USING '--,---,--&.&&'
               LET l_per4 = l_per4.trim()
            END IF
            PRINTX l_per4

            IF cl_null(sr1.per05) THEN
               LET l_per5 = NULL
            ELSE
               LET l_per5 = sr1.per05 USING '--,---,--&.&&'
               LET l_per5 = l_per5.trim()
            END IF
            PRINTX l_per5

            IF cl_null(sr1.per06) THEN
               LET l_per6 = NULL
            ELSE
               LET l_per6 = sr1.per06 USING '--,---,--&.&&'
               LET l_per6 = l_per6.trim()
            END IF
            PRINTX l_per6

            IF cl_null(sr1.per07) THEN
               LET l_per7 = NULL
            ELSE
               LET l_per7 = sr1.per07 USING '--,---,--&.&&'
               LET l_per7 = l_per7.trim()
            END IF
            PRINTX l_per7

            LET l_amt_fmt = cl_gr_numfmt("type_file","num20_6",tm.e)
            PRINTX l_amt_fmt
            #FUN-B80158------add----end-------

            PRINTX sr1.*

        AFTER GROUP OF sr1.gem01

        
        ON LAST ROW

END REPORT
###GENGRE###END
