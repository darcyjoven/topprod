# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr193.4gl (copy from aglr193)
# Descriptions...: 七期實際報表列印
# Date & Author..: 02/03/11 By Kammy
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/08 By baogui 報表修改
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加判斷使用者及部門設限
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740048 07/04/12 By johnray 會計科目加帳套
# Modify.........: No.TQC-760001 07/06/01 By Smapmin 修復shell造成的錯誤
# Modify.........: NO.FUN-750025 07/07/20 BY TSD.pinky 改為crystal report
# Modify.........: No.FUN-810069 08/02/28 By lutingting 取消預算編號控管
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10056 10/01/12 By wuxj 跨DB改為不跨DB，FOR 1-9回圈中主SQL修改 
# Modify.........: No:CHI-A40062 10/05/04 By Summer 增加條件"族群編號"為開窗
# Modify.........: No:MOD-A70030 10/07/05 By sabrina 將g_buf型態改為string
# Modify.........: No:CHI-A20007 10/10/28 By sabrina 欄位抓錯，afb041、afc041才是部門編號
# Modify.........: No:FUN-AB0020 10/11/08 By suncx 新增欄位預算項目，處理相關邏輯
# Modify.........: No:MOD-B10010 11/01/03 By Dido 計算合計階段需增加maj09的控制 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(1)
              a       LIKE maj_file.maj01,    #No.FUN-680061 VARCHAR(6)
              dept    LIKE gem_file.gem01,    #No.FUN-680061 VARCHAR(6)
             #budget  LIKE afa_file.afa01,    #No.FUN-680061 VARCHAR(4)  #FUN-810069
              budget  LIKE afa_file.afa01,    #No.FUN-AB0020 add
              title1  LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)
              yy1     LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT
              bm1     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              em1     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              title2  LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)                                                                                       
              yy2     LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT                                                                                      
              bm2     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT                                                                                      
              em2     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              title3  LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)                                                                                      
              yy3     LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT                                                                                      
              bm3     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT                                                                                      
              em3     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              title4  LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)                                                                                     
              yy4     LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT                                                                                          
              bm4     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT                                                                                      
              em4     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              title5  LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)                                                                                     
              yy5     LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT                                                                                      
              bm5     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT                                                                                      
              em5     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              title6  LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)                                                                                     
              yy6     LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT                                                                                      
              bm6     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT                                                                                      
              em6     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              title7  LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)                                                                                     
              yy7     LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT                                                                                      
              bm7     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT                                                                                      
              em7     LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              ac1     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac2     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac3     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac4     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac5     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac6     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac7     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac8     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              ac9     LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
              c       LIKE type_file.chr1,    #異動額及餘額為0者是否列印 #No.FUN-680061 VARCHAR(1)
              d       LIKE type_file.chr1,    #金額單位      #No.FUN-680061(1)
              e       LIKE azi_file.azi05,    #小數位數       #No.FUN-680061 SMALLINT
              f       LIKE maj_file.maj08,    #列印最小階數   #No.FUN-680061 SMALLINT
              h       LIKE fan_file.fan02,    #額外說明類別   #No.FUN-680061 VARCHAR(4)
              o       LIKE type_file.chr1,    #轉換幣別否     #No.FUN-680061 VARCHAR(1)
              r       LIKE azi_file.azi01,    #幣別    
              p       LIKE azi_file.azi01,    #幣別
              q       LIKE azj_file.azj03,    #匯率
              more    LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)
          END RECORD,
          a_rep       ARRAY[7] OF RECORD
              title   LIKE type_file.chr8,    #No.FUN-680061 VARCHAR(8)
              yy      LIKE abk_file.abk03,    #No.FUN-680061 SMALLINT
              bm      LIKE aah_file.aah03,    #No.FUN-680061 SMALLINT
              em      LIKE aah_file.aah03     #No.FUN-680061 SMALLINT
          END RECORD ,
          m_abd02     LIKE abd_file.abd02,    #No.FUN-680061 VARCHAR(6)
          a_amt       ARRAY[7]    OF LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
          s_amt       ARRAY[50,7] OF LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
          a_dbs       ARRAY[9,2]  OF LIKE type_file.chr21,  #No.FUN-680061 DEC(20,6)
          g_gem       RECORD LIKE gem_file.* ,
          t_dept      LIKE gem_file.gem01,
          i,j,k,r_cnt LIKE type_file.num5,    #No.FUN-680061 SMALLINT
          g_unit      LIKE type_file.num10,   #No.FUN-680061 INTEGER               
          g_dept      LIKE abe_file.abe01,    #No.FUN-680061 VARCHAR(6)
         #g_buf      LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(200),  #MOD-A70030 mark
          g_buf      STRING,                  #MOD-A70030 add                     
          g_bookno   LIKE aah_file.aah00,     #帳別
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_tot      ARRAY[100,7] OF LIKE type_file.num20_6, #No.FUN-680061 DEC(20,6)
          m_gem02    LIKE gem_file.gem02,
          rep_cnt    LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE   g_i         LIKE type_file.num5      #count/index for any purpose   #No.FUN-680061 SMALLINT
DEFINE   g_aaa03     LIKE  aaa_file.aaa03
DEFINE   g_before_input_done  LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE   p_cmd       LIKE type_file.chr1      #No.FUN-680061  VARCHAR(1)
DEFINE   g_msg       LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(100)
DEFINE   g_cnt       LIKE type_file.chr1000   #No.FUN-680061 SMALLINT
DEFINE   g_str         STRING          # FUN-750025 TSD.pinky
DEFINE   l_table       STRING          # FUN-750025 TSD.pinky
DEFINE   g_sql         STRING          # FUN-750025
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
     #str FUN-750025 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "maj20.maj_file.maj20,",
            "maj20e.maj_file.maj20e,",
            "maj02.maj_file.maj02,",   #項次(排序要用的)
            "maj03.maj_file.maj03,",   #列印碼
            "dept.gem_file.gem01,",
            "amt1.type_file.num20_6,",
            "amt12.type_file.num20_6,",
            "amt13.type_file.num20_6,",
            "amt14.type_file.num20_6,",
            "amt15.type_file.num20_6,",
            "amt16.type_file.num20_6,",
            "amt17.type_file.num20_6,",
            "per1.ima_file.ima48,",
            "per2.ima_file.ima48,",
            "per3.ima_file.ima48,",
            "per4.ima_file.ima48,",
            "per5.ima_file.ima48,",
            "per6.ima_file.ima48,",
            "per7.ima_file.ima48,",
            "line.type_file.num5,",      #1:表示此筆為空行 2:表示此筆不為空行
            "gem02.gem_file.gem02" 
 
  LET l_table = cl_prt_temptable('abgr193',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,? ,",
              "        ?,?,?,?,?, ?,?,?,?,?,? )"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
  #end FUN-750025 add
 
   LET g_trace = 'N'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   #-----TQC-610054---------
   LET tm.a = ARG_VAL(9)
   LET tm.dept = ARG_VAL(10)
#  LET tm.budget = ARG_VAL(11)    #FUN-810069
   LET tm.budget = ARG_VAL(11)    #FUN-AB0020
   LET tm.title1 = ARG_VAL(12)
   LET tm.yy1 = ARG_VAL(13)
   LET tm.bm1 = ARG_VAL(14)
   LET tm.em1 = ARG_VAL(15)
   LET tm.title2 = ARG_VAL(16)
   LET tm.yy2 = ARG_VAL(17)
   LET tm.bm2 = ARG_VAL(18)
   LET tm.em2 = ARG_VAL(19)
   LET tm.title3 = ARG_VAL(20)
   LET tm.yy3 = ARG_VAL(21)
   LET tm.bm3 = ARG_VAL(22)
   LET tm.em3 = ARG_VAL(23)
   LET tm.title4 = ARG_VAL(24)
   LET tm.yy4 = ARG_VAL(25)
   LET tm.bm4 = ARG_VAL(26)
   LET tm.em4 = ARG_VAL(27)
   LET tm.title5 = ARG_VAL(28)
   LET tm.yy5 = ARG_VAL(29)
   LET tm.bm5 = ARG_VAL(30)
   LET tm.em5 = ARG_VAL(31)
   LET tm.title6 = ARG_VAL(32)
   LET tm.yy6 = ARG_VAL(33)
   LET tm.bm6 = ARG_VAL(34)
   LET tm.em6 = ARG_VAL(35)
   LET tm.title7 = ARG_VAL(36)
   LET tm.yy7 = ARG_VAL(37)
   LET tm.bm7 = ARG_VAL(38)
   LET tm.em7 = ARG_VAL(39)
   LET tm.ac1 = ARG_VAL(40)
   LET tm.ac2 = ARG_VAL(41)
   LET tm.ac3 = ARG_VAL(42)
   LET tm.ac4 = ARG_VAL(43)
   LET tm.ac5 = ARG_VAL(44)
   LET tm.ac6 = ARG_VAL(45)
   LET tm.ac7 = ARG_VAL(46)
   LET tm.ac8 = ARG_VAL(47)
   LET tm.ac9 = ARG_VAL(48)
   LET tm.c  = ARG_VAL(49)
   LET tm.d  = ARG_VAL(50)
   LET tm.e  = ARG_VAL(51)
   LET tm.f  = ARG_VAL(52)
   LET tm.h  = ARG_VAL(53)
   LET tm.o  = ARG_VAL(54)
   LET tm.r  = ARG_VAL(55)   
   LET tm.p  = ARG_VAL(56)
   LET tm.q  = ARG_VAL(57)
   #-----END TQC-610054-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(58)
   LET g_rep_clas = ARG_VAL(59)
   LET g_template = ARG_VAL(60)
   LET g_rpt_name = ARG_VAL(61)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r193_tm()                # Input print condition
      ELSE CALL r193()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r193_tm()
   DEFINE p_row,p_col  LIKE type_file.num5,     #No.FUN-680061 SMALLINT
          l_sw         LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5      #No.FUN-6C0068
 
   CALL s_dsmark(g_bookno)
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW r193_w AT p_row,p_col
        WITH FORM "abg/42f/abgr193"   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #FUN-660105
   CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105 
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel azi:',SQLCA.sqlcode,0) #FUN-660105
   CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) #FUN-660105 
   END IF
   LET tm.c = 'N'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'Y'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
# INPUT BY NAME tm.rtype,tm.a,tm.dept,tm.budget,   #FUN-810069
    INPUT BY NAME tm.rtype,tm.a,tm.dept,tm.budget,             #FUN-810069   #FUN-AB0020 add budget
                  tm.title1,tm.yy1,tm.bm1,tm.em1,
                  tm.title2,tm.yy2,tm.bm2,tm.em2,
                  tm.title3,tm.yy3,tm.bm3,tm.em3,
                  tm.title4,tm.yy4,tm.bm4,tm.em4,
                  tm.title5,tm.yy5,tm.bm5,tm.em5,
                  tm.title6,tm.yy6,tm.bm6,tm.em6,
                  tm.title7,tm.yy7,tm.bm7,tm.em7,
                  tm.ac1,tm.ac2,tm.ac3,tm.ac4,tm.ac5,tm.ac6,
                  tm.ac7,tm.ac8,tm.ac9,
                  tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                  tm.p,tm.q,tm.more WITHOUT DEFAULTS HELP 1
 
      BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL r193_set_entry(p_cmd)
            CALL r193_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
        IF tm.a IS NULL THEN NEXT FIELD a END IF
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                AND mai00 = g_aza.aza81       #No.FUN-740048
         IF STATUS THEN 
#        CALL cl_err('sel mai:',STATUS,0) #FUN-660105
         CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0) #FUN-660105 
         NEXT FIELD a
        #No.TQC-C50042   ---start---   Add
         ELSE
            IF g_mai03 = '5' OR g_mai03 = '6' THEN
               CALL cl_err('','agl-268',0)
               NEXT FIELD a
            END IF
        #No.TQC-C50042   ---end---     Add
         END IF
 
{
      AFTER FIELD b
         IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.b IS NULL THEN NEXT FIELD b END IF
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN CALL cl_err('sel aaa:',STATUS,0) NEXT FIELD b END IF
}
 
      AFTER FIELD dept
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
    #    IF cl_chkabf(tm.dept) THEN NEXT FIELD dept END IF
 
#No.FUN-810069--START--
#     AFTER FIELD budget
#        SELECT * FROM afa_file WHERE afa01=tm.budget
#                                 AND afaacti IN ('Y','y')
#                                 AND afa00 = g_aza.aza81     #No.FUN-740048
#       IF STATUS THEN 
##       CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#        CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105
#        NEXT FIELD budget END IF
#No.FUN-810069--END 
#FUN-AB0020 ---add Start-------
     AFTER FIELD budget                                                                                                               
        IF NOT cl_null(tm.budget) THEN                                                                                                         
            SELECT * FROM azf_file          #FUN-AB0020 add                                                                            
             WHERE azfacti = 'Y' AND azf02 = '2' AND azf01 = tm.budget    #FUN-AB0020 add                                              
            IF STATUS THEN                                                                                                             
               #CALL cl_err('sel azf:',STATUS,0) #FUN-660105                                                                            
               CALL cl_err3("sel","azf_file",tm.budget,"",STATUS,"","sel azf:",0) #FUN-660105                                          
               NEXT FIELD budget                                                                                                       
            END IF   
         END IF
#FUN-AB0020 ---add End---------
 
 
{
      AFTER FIELD yy1
         IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
            NEXT FIELD yy1
         END IF
 
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      BEFORE FIELD bm1
         IF tm.rtype='1' THEN
            LET tm.bm1 = 0 DISPLAY '' TO bm1
            IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
         END IF
 
      AFTER FIELD bm1
         IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
         IF tm.bm1 <1 OR tm.bm1 > 13 THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD bm1
         END IF
 
      AFTER FIELD em1
         IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
         IF tm.em1 <1 OR tm.em1 > 13 THEN
            CALL cl_err('','agl-013',0) NEXT FIELD em1
         END IF
         IF tm.bm1 > tm.em1 THEN CALL cl_err('','9011',0) NEXT FIELD bm1 END IF
         IF tm.yy2 IS NULL THEN
            LET tm.yy2 = tm.yy1
            LET tm.bm2 = tm.bm1
            LET tm.em2 = 12
            DISPLAY BY NAME tm.yy2,tm.bm2,tm.em2
         END IF
}
      AFTER FIELD d
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
 
     AFTER FIELD o
         IF tm.o = 'N' THEN
            LET tm.p = g_aaa03
            LET tm.q = 1
            DISPLAY g_aaa03 TO p
            DISPLAY BY NAME tm.q
         END IF
            CALL r193_set_entry(p_cmd)
            CALL r193_set_no_entry(p_cmd)
 
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN 
#        CALL cl_err(tm.p,'agl-109',0) #FUN-660105
         CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)  #FUN-660105
         NEXT FIELD p END IF
 
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
{
         IF tm.yy1 IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy1 ATTRIBUTE(REVERSE)
            CALL cl_err('',9033,0)
         END IF
         IF tm.bm1 IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.bm1 ATTRIBUTE(REVERSE)
         END IF
         IF tm.em1 IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.em1 ATTRIBUTE(REVERSE)
         END IF
         IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD a
            CALL cl_err('',9033,0)
         END IF
}
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_mai"
                 LET g_qryparam.default1 = tm.a
                 LET g_qryparam.where = " mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                 CALL cl_create_qry() RETURNING tm.a
                 DISPLAY tm.a TO a
                 NEXT FIELD a
           WHEN INFIELD(p)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = tm.p
                 CALL cl_create_qry() RETURNING tm.p
                 DISPLAY tm.p TO p
                 NEXT FIELD p
#No.FUN-810069--START--
#          WHEN INFIELD(budget)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_afa"
#                LET g_qryparam.default1 = tm.budget
#                LET g_qryparam.arg1 = g_aza.aza81         #No.FUN-740048
#                CALL cl_create_qry() RETURNING tm.budget
#                DISPLAY tm.budget TO budget
#                NEXT FIELD budget
#No.FUN-810069--END
#FUN-AB0020 add start--------------------------
          WHEN INFIELD(budget)
                CALL cl_init_qry_var()
               # LET g_qryparam.form ="q_afa"
                LET g_qryparam.form ="q_azf"
                LET g_qryparam.default1 = tm.budget
                #LET g_qryparam.arg1 = g_aza.aza81         #No.FUN-740048
                LET g_qryparam.arg1 = '2'
                CALL cl_create_qry() RETURNING tm.budget
                DISPLAY tm.budget TO budget
                NEXT FIELD budget
#FUN-AB0020 add end-----------------------

          #CHI-A40062 add --start--
          WHEN INFIELD(dept)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_abe'
             LET g_qryparam.default1 = tm.dept
             CALL cl_create_qry() RETURNING tm.dept
             DISPLAY BY NAME tm.dept
             NEXT FIELD dept
          #CHI-A40062 add --end--

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
      LET INT_FLAG = 0 CLOSE WINDOW r193_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr193'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr193','9031',1)
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
#                      " '",tm.budget CLIPPED,"'",    #FUN-810069
                         " '",tm.budget CLIPPED,"'",   #FUN-AB0020
                         #-----TQC-610054----------
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
                         #-----EDN TQC-610054------
                      " '",tm.c CLIPPED,"'",
                      " '",tm.d CLIPPED,"'",
                      " '",tm.e CLIPPED,"'",
                      " '",tm.f CLIPPED,"'",
                      " '",tm.h CLIPPED,"'",
                      " '",tm.o CLIPPED,"'",
                      " '",tm.r CLIPPED,"'",
                      " '",tm.p CLIPPED,"'",
                      " '",tm.q CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr193',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r193_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r193()
   ERROR ""
END WHILE
   CLOSE WINDOW r193_w
END FUNCTION
 
FUNCTION r193()
   DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   DEFINE l_sql1    LIKE type_file.chr1000  # RDSQL STATEMENT   #No.FUN-680061 VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680061   VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061   VARCHAR(40)
   DEFINE l_leng    LIKE type_file.num5     #No.FUN-680061   SMALLINT
   DEFINE l_abe03   LIKE abe_file.abe03,
          l_str1    LIKE type_file.chr21,    
          l_str2    LIKE type_file.chr21,    
          l_str3    LIKE type_file.chr21,    
          l_str4    LIKE type_file.chr21,    
          l_str5    LIKE type_file.chr21,    
          l_str6    LIKE type_file.chr21,    
          l_str7    LIKE type_file.chr21    
 
   #str FUN-750025 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
            AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abgr193'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO 70 LET g_dash2[g_i,g_i] = '-' END FOR
 
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
         FOR i =71 TO 7
             LET g_tot[g_i,i] = 0
             IF g_i < 51 THEN
                LET s_amt[g_i,i] = 0
             END IF
         END FOR
     END FOR
  #NO.FUN-A10056 ---start---mark
  #  FOR i = 1 TO 9
  #      CALL r751_dbs(a_dbs[i,1]) RETURNING a_dbs[i,2]
  #  END FOR
  #NO.FUN-A10056 ---end---mark
     LET r_cnt = 0
 
  #   CALL cl_outnam('abgr193') RETURNING l_name
     LET l_sql1 = "SELECT * FROM maj_file",
                  " WHERE maj01 = '",tm.a,"'",
                  "   AND ",g_msg CLIPPED,
                  " ORDER BY maj02"
     PREPARE r193_p FROM l_sql1
     IF STATUS THEN CALL cl_err('prepare_1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r193_c CURSOR FOR r193_p
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql1) END IF
   #  START REPORT r193_rep TO l_name
 
#---------------------------------------------------
   IF g_dept=' ' THEN                     #--- 部門
      DECLARE r193_curs10 CURSOR FOR
       SELECT abd02,gem05 FROM abd_file,gem_file WHERE abd01=tm.dept
                                                   AND gem01=abd02
        ORDER BY abd02
      FOREACH r193_curs10 INTO m_abd02,l_chr
          IF SQLCA.SQLCODE THEN
             EXIT FOREACH
          END IF
          CALL r193_bom(m_abd02,l_chr)
      END FOREACH
      IF g_buf IS NULL THEN LET g_buf="'",tm.dept CLIPPED,"'," END IF
      LET l_leng=LENGTH(g_buf)
     #LET g_buf=g_buf[1,l_leng-1] CLIPPED               #MOD-A70030 mark
      LET g_buf=g_buf.subString(1,l_leng-1) CLIPPED     #MOD-A70030 add
      CALL r193_process(tm.dept)
   ELSE                                    #--- 族群
      DECLARE r193_bom CURSOR FOR
       SELECT abe03,gem05 FROM abe_file,gem_file WHERE abe01=tm.dept
                                                   AND gem01=abe03
        ORDER BY abe03
      FOREACH r193_bom INTO l_abe03,l_chr
          IF SQLCA.SQLCODE THEN
             EXIT FOREACH
          END IF
          CALL r193_bom(l_abe03,l_chr)
          IF g_buf IS NULL THEN LET g_buf="'",l_abe03 CLIPPED,"'," END IF
          LET l_leng=LENGTH(g_buf)
         #LET g_buf=g_buf[1,l_leng-1] CLIPPED               #MOD-A70030 mark
          LET g_buf=g_buf.subString(1,l_leng-1) CLIPPED     #MOD-A70030 add
          CALL r193_process(l_abe03)
          LET g_buf=''
      END FOREACH
   END IF
 
   LET rep_cnt=0
#---------------------------------------------------
 
  #   FINISH REPORT r193_rep
  #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
   #str FUN-750025 add
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
  #報表名稱是否以報表結構名稱列印
  LET l_str1=tm.yy1 USING '<<<<','/',tm.bm1 USING '&&','-',tm.yy1 USING '<<<<','/',tm.em1 USING '&&'
  LET l_str2=tm.yy2 USING '<<<<','/',tm.bm2 USING '&&','-',tm.yy2 USING '<<<<','/',tm.em2 USING '&&'
  LET l_str3=tm.yy3 USING '<<<<','/',tm.bm3 USING '&&','-',tm.yy3 USING '<<<<','/',tm.em3 USING '&&'
  LET l_str4=tm.yy4 USING '<<<<','/',tm.bm4 USING '&&','-',tm.yy4 USING '<<<<','/',tm.em4 USING '&&'
  LET l_str5=tm.yy5 USING '<<<<','/',tm.bm5 USING '&&','-',tm.yy5 USING '<<<<','/',tm.em5 USING '&&'
  LET l_str6=tm.yy6 USING '<<<<','/',tm.bm6 USING '&&','-',tm.yy6 USING '<<<<','/',tm.em6 USING '&&'
  LET l_str7=tm.yy7 USING '<<<<','/',tm.bm7 USING '&&','-',tm.yy7 USING '<<<<','/',tm.em7 USING '&&'
  IF g_aaz.aaz77 = 'N' THEN LET g_mai02 = '' END IF
  LET g_str = g_mai02,";", tm.a,";",tm.d,";",
   tm.title1,";",l_str1,";",
   tm.title2,";",l_str2,";",
   tm.title3,";",l_str3,";",
   tm.title4,";",l_str4,";",
   tm.title5,";",l_str5,";",
   tm.title6,";",l_str6,";",
   tm.title7,";",l_str7,";"
            ,tm.e,";",tm.p
  CALL cl_prt_cs3('abgr193','abgr193',g_sql,g_str)
  #------------------------------ CR (4) ------------------------------#
  #end FUN-750025 add
 
END FUNCTION
 
FUNCTION r193_process(l_dept)
   DEFINE r_gem02    LIKE gem_file.gem02
   DEFINE per ARRAY[7] OF LIKE ima_file.ima48  #No.FUN-680061 DEC(7,1)
   DEFINE l_dept   LIKE gem_file.gem01   
   DEFINE l_sql2,l_sql3,l_sql4  LIKE type_file.chr1000  # RDSQL STATEMENT  #No.FUN-680061 VARCHAR(600)
   DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680061 VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(40)
   DEFINE l_gem01          LIKE gem_file.gem01
   DEFINE l_gem02          LIKE gem_file.gem02
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE aah       RECORD LIKE aah_file.*
   DEFINE aao       RECORD LIKE aao_file.*
   DEFINE sr        ARRAY[7] OF LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6)
   DEFINE l_amt     LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
 
 
 
   LET r_cnt = r_cnt + 1
   FOREACH r193_c INTO maj.*
      FOR g_i = 1 TO 7
          LET a_amt[g_i] = 0
          LET sr[g_i]    = 0
          IF a_rep[g_i].yy = 0 OR a_rep[g_i].yy IS NULL THEN
             CONTINUE FOR
          END IF
          FOR i = 1 TO 9
#NO.FUN-A10056 ---start---mark
#              IF a_dbs[i,2] IS NULL THEN
#                 CONTINUE FOR
#              END IF
#NO.FUN-A10056 ---end---
              #----------- sql for sum(afc06)-----------------------------
#TQC-940178 MARK&ADD START-------------------------------------------------
#             LET l_sql4= "SELECT SUM(afc06) FROM ",a_dbs[i,2] CLIPPED,
#                         ".dbo.afc_file,",s_dbstring(a_dbs[i,2]),"afb_file",
#FUN-A10056 ---start--
#              LET l_sql4= "SELECT SUM(afc06) FROM ",s_dbstring(a_dbs[i,2] CLIPPED),                                                             
#                          "afc_file,",s_dbstring(a_dbs[i,2] CLIPPED),"afb_file",  
              LET l_sql4= "SELECT SUM(afc06) FROM afc_file,afb_file",
#FUN-A10056---end---
#TQC-940178 END---------------------------------------------------------------
                          " WHERE afb00 = afc00  AND afb01 = afc01 ",
                          "   AND afb02 = afc02  AND afb03 = afc03 ",
                          "   AND afb04 = afc04  ",
                         #"   AND afc01 = '",tm.budget,"'",   #FUN-810069
                          "   AND afc02 BETWEEN ? AND ? ",
                         #"   AND afc04 IN (",g_buf CLIPPED,")",     #CHI-A20007 mark
                          "   AND afc041 IN (",g_buf CLIPPED,")",    #CHI-A20007 add
                          "   AND afc03 = ?",
                          "   AND afc05 BETWEEN ? AND ?",
                          "   AND afc00=  ? ",
                         #"   AND afb15 = '2' ",      #部門預算      #CHI-A20007 mark
                          "   AND afb041 = afc041 AND afb042 = afc042 ",  #FUN-810069
                          "   AND afb00 = ? ",                           #FUN-A10056
                        # "   AND afb041 = '' AND afb042 = '' "           #FUN-810069 #FUN-A10056 mark
                         #"   AND afb041 = ' ' AND afb042 = ' ' "         #FUN-A10056 add   #CHI-A20007 mark
                          "   AND afb04 = ' ' AND afb042 = ' ' "          #CHI-A20007 add 
                         ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
              IF NOT cl_null(tm.budget) THEN LET l_sql4 = l_sql4," AND afc01 = '",tm.budget,"'" END IF #FUN-AB0020
 	            CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
              PREPARE pre_sql4 FROM l_sql4
              IF STATUS THEN
                 CALL cl_err('prepare_4:',STATUS,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
                 EXIT PROGRAM
              END IF
              DECLARE a4_curs CURSOR FOR pre_sql4
              OPEN a4_curs USING maj.maj21,maj.maj22,
                                 a_rep[g_i].yy,
                                 a_rep[g_i].bm,a_rep[g_i].em,
                                 a_dbs[i,1],a_dbs[i,1]     #FUN-A10056  add a_dbs[i,1]
              FETCH a4_curs INTO l_amt
              IF STATUS OR l_amt IS NULL THEN
                 LET l_amt = 0
              END IF
              LET a_amt[g_i] = a_amt[g_i] + l_amt
              CLOSE a4_curs
          END FOR
          IF g_trace='Y' THEN
             DISPLAY 'F2:',maj.maj02,' ',maj.maj21
          END IF
          IF tm.o = 'Y' THEN
             LET a_amt[g_i] = a_amt[g_i] * tm.q
          END IF
          IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN	#合計階數處理
             FOR i = 1 TO 100
                 IF a_amt[g_i] IS NULL OR a_amt[g_i] = 0 THEN
                    CONTINUE FOR
                 END IF
                #-MOD-B10010-add-
                #LET g_tot[i,g_i]=g_tot[i,g_i]+a_amt[g_i]
                 IF maj.maj09 = '-' THEN
                    LET g_tot[i,g_i]=g_tot[i,g_i]-a_amt[g_i]
                 ELSE
                    LET g_tot[i,g_i]=g_tot[i,g_i]+a_amt[g_i]
                 END IF
                #-MOD-B10010-end-
             END FOR
             LET k=maj.maj08
             LET sr[g_i] = g_tot[k,g_i]
            #-MOD-B10010-add-
             IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
                LET sr[g_i] = sr[g_i] *-1
             END IF
            #-MOD-B10010-end-
             FOR i = 1 TO maj.maj08
                 LET g_tot[i,g_i] = 0
             END FOR
          END IF
          IF maj.maj11 = 'Y' THEN
             IF maj.maj07 = '2' THEN
                LET s_amt[r_cnt,g_i] = - sr[g_i]
             ELSE
                LET s_amt[r_cnt,g_i] = sr[g_i]
             END IF
          END IF
      END FOR
      FOR i = 1 TO 7
          IF sr[i] = 0 THEN
             LET sr[i] = NULL
          END IF
      END FOR
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"              #CHI-CC0023 add maj03 match 5
          AND sr[1] IS NULL AND sr[2] IS NULL AND sr[3] IS NULL
          AND sr[4] IS NULL AND sr[5] IS NULL AND sr[6] IS NULL
          AND sr[7] IS NULL THEN
          CONTINUE FOREACH				#餘額為 0 者不列印
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH				#最小階數起列印
      END IF
   ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      SELECT gem02 INTO r_gem02 FROM gem_file WHERE gem01=l_dept
 #       AND gem05='Y'     可能為部門群組故非會計部門
      IF STATUS THEN
         LET r_gem02 = ' '
      END IF
      IF maj.maj07='2' THEN
         LET sr[1] = - sr[1]
         LET sr[2] = - sr[2]
         LET sr[3] = - sr[3]
         LET sr[4] = - sr[4]
         LET sr[5] = - sr[5]
         LET sr[6] = - sr[6]
         LET sr[7] = - sr[7]
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
      IF s_amt[r_cnt,1] <> 0 THEN
         LET per[1] = (sr[1]/s_amt[r_cnt,1]) * 100
      END IF
      IF s_amt[r_cnt,2] <> 0 THEN
         LET per[2] = (sr[2]/s_amt[r_cnt,2]) * 100
      END IF
      IF s_amt[r_cnt,3] <> 0 THEN
         LET per[3] = (sr[3]/s_amt[r_cnt,3]) * 100
      END IF
      IF s_amt[r_cnt,4] <> 0 THEN
         LET per[4] = (sr[4]/s_amt[r_cnt,4]) * 100
      END IF
      IF s_amt[r_cnt,5] <> 0 THEN
         LET per[5] = (sr[5]/s_amt[r_cnt,5]) * 100
      END IF
      IF s_amt[r_cnt,6] <> 0 THEN
         LET per[6] = (sr[6]/s_amt[r_cnt,6]) * 100
      END IF
      IF s_amt[r_cnt,7] <> 0 THEN
         LET per[7] = (sr[7]/s_amt[r_cnt,7]) * 100
      END IF
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20 #liquor
     IF maj.maj04 = 0 THEN
	EXECUTE insert_prep USING
	maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
	l_dept,sr[1],sr[2],sr[3],sr[4],sr[5],sr[6],sr[7],
               per[1], per[2], per[3], per[4], per[5], per[6], per[7],
        '2',r_gem02
     ELSE
	EXECUTE insert_prep USING
         maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
	l_dept,sr[1],sr[2],sr[3],sr[4],sr[5],sr[6],sr[7],
               per[1], per[2], per[3], per[4], per[5], per[6], per[7],
         '2',r_gem02
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
        FOR i = 1 TO maj.maj04
           EXECUTE insert_prep USING
            maj.maj20,maj.maj20e,maj.maj02,'',
            l_dept,'0','0','0','0','0','0','0', 
                   '0','0','0','0','0','0','0', '1',r_gem02
        END FOR
      END IF
 
 
   END FOREACH
END FUNCTION
 
#NO.FUN-A10056 ---start---mark
#FUNCTION r751_dbs(l_ac)
#    DEFINE l_ac    LIKE   aaa_file.aaa01
#    DEFINE l_azp   RECORD LIKE azp_file.*
#    DEFINE l_seq   LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(300)

#    DECLARE r751_z1 CURSOR FOR
#     SELECT * FROM azp_file
#      WHERE azp053 != 'N'       #no.7431 ERP資料庫
#    FOREACH r751_z1 INTO l_azp.*
#     #LET l_seq = "SELECT aaa01 FROM ",s_dbstring(l_azp.azp03),"aaa_file ",              #TQC-940178 MARK
#      LET l_seq = "SELECT aaa01 FROM ",s_dbstring(l_azp.azp03 CLIPPED),"aaa_file ",   #TQC-940178 ADD
#                  " WHERE aaa01 = '",l_ac,"'"
#      LET l_seq = "SELECT aaa01 FROM ","aaa_file ",
#                  " WHERE aaa01 = '",l_ac,"'"
#
#      PREPARE pre_str1 FROM l_seq
#      EXECUTE pre_str1   # informix version not matches,故在 v4.x 需開 cursor
#      DECLARE r751_z2 CURSOR FOR pre_str1
#      OPEN r751_z2
#      FETCH r751_z2
#      IF STATUS = 0 THEN
#          RETURN l_azp.azp03 
#      END IF
#      CLOSE r751_z2
#    END FOREACH   #NO.FUN-A10056
#    RETURN ''    
#END FUNCTION
#NO.FUN-A10056 ----end---mark
 
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
#TQC-6A0081--begin
   #NO.FUN-A10056 ---start---mark
   #LET a_dbs[1,2]     = ''
   #LET a_dbs[2,2]     = ''
   #LET a_dbs[3,2]     = ''
   #LET a_dbs[4,2]     = ''
   #LET a_dbs[5,2]     = ''
   #LET a_dbs[6,2]     = ''
   #LET a_dbs[7,2]     = ''
   #LET a_dbs[8,2]     = ''
   #LET a_dbs[9,2]     = ''
   #NO.FUN-A10056 ---end---mark
#    FOR g_cnt = 1 TO 9
#        LET a_dbs[g_cnt,2] = ''
#    END FOR
#TQC-6A0081--end
END FUNCTION
 
FUNCTION r193_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01   #No.FUN-680061 VARCHAR(6)
    DEFINE l_sw     LIKE type_file.chr1   #No.FUN-680061 VARCHAR(1)
    DEFINE l_abd02  LIKE abd_file.abd02   #No.FUN-680061 VARCHAR(6)
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5      #No.FUN-680061 SMALLINT
    DEFINE l_arr ARRAY[300] OF RECORD
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
           CALL r193_bom(l_arr[l_cnt2].*)
        END IF
    END FOR
    IF l_sw = 'Y' THEN
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
FUNCTION r193_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680061 VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("p,q",TRUE)
 #  END IF
 
END FUNCTION
 
FUNCTION r193_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680061 VARCHAR(1)
 
      IF tm.o = 'N' THEN
           CALL cl_set_comp_entry("p,q",FALSE)
      END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <001,002> #
#TQC-760001
