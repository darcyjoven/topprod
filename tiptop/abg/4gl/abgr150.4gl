# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr150.4gl (copy from aglr150)
# Descriptions...: 五期預算財務報表列印
# Date & Author..: 03/03/17 By Kammy
# Modify.........: No:8782 03/12/01 ching 工廠編號為10碼
# Modify.........: No.FUN-580010 05/08/09 By yoyo 憑証類報表原則修改
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740048 07/04/12 By johnray 會計科目加帳套
# Modify.........: No.TQC-760001 07/06/01 By Smapmin 修復shell造成的錯誤
# Modify.........: NO.FUN-750025 07/07/25 BY TSD.Ken 改為CR
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.FUN-810069 08/02/28 By lutingting 取消預算編號控管 
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-950007 09/05/12 By sabrina 跨主機資料拋轉，shell手工調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10056 10/01/12 By wuxj 去掉 plant，跨DB改為不跨DB 
# Modify.........: No:CHI-A40036 10/04/22 By Summer 相關有使用afb04,afb041,afb042若給予''者,將改為' '
# Modify.........: No:CHI-A40063 10/05/05 By Summer 正負號相反問題
# Modify.........: No:MOD-AA0104 10/10/18 By Dido 報表的百分比計算邏輯有問題，應該是跑完所有報表后找出設定百分比基准的科目與金額，再計算各筆資料的百分比
# Modify.........: No:CHI-A20007 10/10/28 By sabrina 欄位抓錯，afb041、afc041才是部門編號
# Modify.........: No:FUN-AB0020 10/11/08 By suncx 新增欄位預算項目，處理相關邏輯
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,      #No.FUN-680061  VARCHAR(1)
              a       LIKE abh_file.abh05,      #No.FUN-680061  VARCHAR(6)
 
              title1  LIKE type_file.chr8,      #No.FUN-680061  VARCHAR(8)
              yy1     LIKE abk_file.abk03,      #No.FUN-680061  SMALLINT
              bm1     LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT
              em1     LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT
           #  plant1  LIKE cre_file.cre08,      #No.FUN-680061  CAHR(10)  #FUN-A10056  mark
           #  dbs1    LIKE type_file.chr21,     #No.FUN-680061  CAHR(21)  #FUN-A10056  mark
              book1   LIKE aaa_file.aaa01,      #帳別編號    #No.FUN-670039 
 
              title2  LIKE type_file.chr8,      #No.FUN-680061  VARCHAR(8)                                                                                       
              yy2     LIKE abk_file.abk03,      #No.FUN-680061  SMALLINT                                                                                          
              bm2     LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                          
              em2     LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                       
           #  plant2  LIKE cre_file.cre08,      #No.FUN-680061  CAHR(10)    #FUN-A10056 mark                                                                   
           #  dbs2    LIKE type_file.chr21,     #No.FUN-680061  CAHR(21)    #FUN-A10056  mark                                                                   
              book2   LIKE aaa_file.aaa01,     
             
              title3 LIKE type_file.chr8,      #No.FUN-680061  VARCHAR(8)                                                                                       
              yy3    LIKE abk_file.abk03,      #No.FUN-680061  SMALLINT                                                                                       
              bm3    LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                       
              em3    LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                     
           #  plant3 LIKE cre_file.cre08,      #No.FUN-680061  CAHR(10)    #FUN-A10056 mark                                                                   
           #  dbs3   LIKE type_file.chr21,     #No.FUN-680061  CAHR(21)    #FUN-A10056  mark                                                                   
              book3  LIKE aaa_file.aaa01,
            
              title4 LIKE type_file.chr8,      #No.FUN-680061  VARCHAR(8)                                                                                        
              yy4    LIKE abk_file.abk03,      #No.FUN-680061  SMALLINT                                                                                        
              bm4    LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                       
              em4    LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                       
           #  plant4 LIKE cre_file.cre08,      #No.FUN-680061  CAHR(10) #FUN-A10056 mark                                                                      
           #  dbs4   LIKE type_file.chr21,     #No.FUN-680061  CAHR(21)#FUN-A10056  mark                                                                       
              book4  LIKE aaa_file.aaa01,
    
              title5 LIKE type_file.chr8,      #No.FUN-680061  VARCHAR(8)                                                                                       
              yy5    LIKE abk_file.abk03,      #No.FUN-680061  SMALLINT                                                                                       
              bm5    LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                       
              em5    LIKE aah_file.aah03,      #No.FUN-680061  SMALLINT                                                                                       
           #  plant5 LIKE cre_file.cre08,      #No.FUN-680061  CAHR(10) #FUN-A10056  mark                                                                     
           #  dbs5   LIKE type_file.chr21,     #No.FUN-680061  CAHR(21) #FUN-A10056  mark                                                                      
              book5  LIKE aaa_file.aaa01,
 
#             budget LIKE afa_file.afa01,      #No.FUN-680061 VARCHAR(4)  #FUN-810069
              budget  LIKE azf_file.azf01,     #FUN-AB0020 add
              c   LIKE type_file.chr1,         #異動額及餘額為0者是否列印 #No.FUN-680061 VARCHAR(1)
              d   LIKE type_file.chr1,         #金額單位      #No.FUN-680061 VARCHAR(1)
              e   LIKE azi_file.azi05,         #小數位數      #No.FUN-680061 SMALLINT 
              f   LIKE maj_file.maj08,         #列印最小階數  #No.FUN-680061  SMALLINT
              h   LIKE fan_file.fan02,         #額外說明類別  #No.FUN-680061 VARCHAR(4)
              o   LIKE type_file.chr1,         #轉換幣別否    #No.FUN-680061 VARCHAR(4)
              r   LIKE azi_file.azi01,         #幣別
              p   LIKE azi_file.azi01,         #幣別
              q   LIKE pml_file.pml09,         #匯率
              more    LIKE type_file.chr1      #No.FUN-680061  VARCHAR(1)
              END RECORD,
          bdate,edate     LIKE type_file.dat,     #No.FUN-680061  DATE
          i,j,k           LIKE type_file.num5,    #No.FUN-680061 SMALLINT
          g_unit    LIKE type_file.num10,         #No.FUN-680061 INTEGER
          g_bookno  LIKE aah_file.aah00,          #帳別 
          g_mai02   LIKE mai_file.mai02,
          g_mai03   LIKE mai_file.mai03,
          g_tot1    ARRAY[100] OF LIKE type_file.num20_6, #No.FUN-680061  DEC(20,6)
          g_tot2    ARRAY[100] OF LIKE type_file.num20_6, #No.FUN-680061  DEC(20,6)
          g_tot3    ARRAY[100] OF LIKE type_file.num20_6, #No.FUN-680061  DEC(20,6)
          g_tot4    ARRAY[100] OF LIKE type_file.num20_6, #No.FUN-680061  DEC(20,6)
          g_tot5    ARRAY[100] OF LIKE type_file.num20_6, #No.FUN-680061  DEC(20,6)
          g_basetot1  LIKE type_file.num20_6, #No.FUN-680061 DEC(20,6)
          g_basetot2  LIKE type_file.num20_6, #No.FUN-680061 DEC(20.6)
          g_basetot3  LIKE type_file.num20_6, #No.FUN-680061 DEC(20,6)
          g_basetot4  LIKE type_file.num20_6, #No.FUN-680061 DEC(20,6)
          g_basetot5  LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose    #No.FUN-680061 SMALLINT
DEFINE   g_aaa03      LIKE  aaa_file.aaa03
DEFINE   g_before_input_done  LIKE type_file.num5       #No.FUN-680061  SMALLINT
DEFINE   p_cmd        LIKE type_file.chr1     #No.FUN-680061  VARCHAR(1)
DEFINE   g_msg        LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(100)
DEFINE   g_str         STRING          # FUN-750025 
DEFINE   l_table       STRING          # FUN-750025 
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
             "bal1.type_file.num20_6,",
             "bal2.type_file.num20_6,",
             "bal3.type_file.num20_6,",
             "bal4.type_file.num20_6,",
             "bal5.type_file.num20_6,",
             "line.type_file.num5,",      #1:表示此筆為空行 2:表示此筆不為空行
             "per1.ima_file.ima18,",
             "per2.ima_file.ima18,",
             "per3.ima_file.ima18,",
             "per4.ima_file.ima18,",
             "per5.ima_file.ima18,",
             "azi04.azi_file.azi04"
 
 LET l_table = cl_prt_temptable('abgr150',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
 END IF
 #------------------------------ CR (1) ------------------------------#
 #end FUN-750025 add
 
  #-MOD-AA0104-add-
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               "   SET per1 =?,per2 =?,per3 =?,per4 = ?,per5 =?",
               " WHERE maj02=? AND line=?"
   PREPARE update_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('update_prep:',status,1) EXIT PROGRAM
   END IF 
  #-MOD-AA0104-end-

   LET g_trace = 'N'                # default trace off
LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
LET tm.a  = ARG_VAL(9)
   LET tm.title1 = ARG_VAL(10)   #TQC-610054
LET tm.yy1 = ARG_VAL(11)
LET tm.bm1 = ARG_VAL(12)
LET tm.em1 = ARG_VAL(13)
   LET tm.title2 = ARG_VAL(14)   #TQC-610054
LET tm.yy2 = ARG_VAL(15)   #TQC-610054
LET tm.bm2 = ARG_VAL(16)   #TQC-610054
LET tm.em2 = ARG_VAL(17)   #TQC-610054
   LET tm.title3 = ARG_VAL(18)   #TQC-610054
LET tm.yy3 = ARG_VAL(19)   #TQC-610054
LET tm.bm3 = ARG_VAL(20)   #TQC-610054
LET tm.em3 = ARG_VAL(21)   #TQC-610054
   LET tm.title4 = ARG_VAL(22)   #TQC-610054
LET tm.yy4 = ARG_VAL(23)   #TQC-610054
LET tm.bm4 = ARG_VAL(24)   #TQC-610054
LET tm.em4 = ARG_VAL(25)   #TQC-610054
   LET tm.title5 = ARG_VAL(26)   #TQC-610054
LET tm.yy5 = ARG_VAL(27)   #TQC-610054
LET tm.bm5 = ARG_VAL(28)   #TQC-610054
LET tm.em5 = ARG_VAL(29)   #TQC-610054
#LET tm.budget  = ARG_VAL(30)   #TQC-610054   #FUN-810069
LET tm.budget  = ARG_VAL(30)   #FUN-AB0020
LET tm.c  = ARG_VAL(31)
LET tm.d  = ARG_VAL(32)
LET tm.e  = ARG_VAL(33)
LET tm.f  = ARG_VAL(34)
LET tm.h  = ARG_VAL(35)
LET tm.o  = ARG_VAL(36)
LET tm.r  = ARG_VAL(37)   #TQC-610054
LET tm.p  = ARG_VAL(38)
LET tm.q  = ARG_VAL(39)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(40)
   LET g_rep_clas = ARG_VAL(41)
   LET g_template = ARG_VAL(42)
   LET g_rpt_name = ARG_VAL(43)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF     #No.FUN-740048
   IF cl_null(g_bookno) THEN LET g_bookno = g_aza.aza81 END IF     #No.FUN-740048
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r150_tm()                # Input print condition
      ELSE CALL r150()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r150_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680061  SMALLINT
          l_sw           LIKE type_file.chr1,        #No.FUN-680061  VARCHAR(1)
          l_cmd          LIKE type_file.chr1000      #No.FUN-680061  VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5         #No.FUN-6C0068
 
   CALL s_dsmark(g_bookno)
   LET p_row = 2 LET p_col = 3  #No.8782
   OPEN WINDOW r150_w AT p_row,p_col
        WITH FORM "abg/42f/abgr150"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
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
   LET tm.title1 = 'M.T.D.'
   LET tm.title2 = 'Y.T.D.'
   LET tm.book1 = g_bookno
   LET tm.book2 = g_bookno
   LET tm.book3 = g_bookno
   LET tm.book4 = g_bookno
   LET tm.book5 = g_bookno
   LET tm.c = 'Y'
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
 INPUT BY NAME tm.rtype,tm.a,
              #   tm.title1,tm.yy1,tm.bm1,tm.em1,tm.plant1,tm.book1,   #FUN-A10056 mark
                  tm.title1,tm.yy1,tm.bm1,tm.em1,tm.book1,              #FUN-A10056
             #    tm.title2,tm.yy2,tm.bm2,tm.em2,tm.plant2,tm.book2,    #FUN-A10056 mark
                  tm.title2,tm.yy2,tm.bm2,tm.em2,tm.book2,              #FUN-A10056
             #    tm.title3,tm.yy3,tm.bm3,tm.em3,tm.plant3,tm.book3,    #FUN-A10056 mark
                  tm.title3,tm.yy3,tm.bm3,tm.em3,tm.book3,              #FUN-A10056
             #    tm.title4,tm.yy4,tm.bm4,tm.em4,tm.plant4,tm.book4,    #FUN-A10056 mark
                  tm.title4,tm.yy4,tm.bm4,tm.em4,tm.book4,              #FUN-A10056
             #    tm.title5,tm.yy5,tm.bm5,tm.em5,tm.plant5,tm.book5,    #FUN-A10056 mark
                  tm.title5,tm.yy5,tm.bm5,tm.em5,tm.book5,
                 #tm.budget,  #FUN-810069
                  tm.budget,  #FUN-AB0020
                  tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                 tm.p,tm.q,tm.more WITHOUT DEFAULTS HELP 1
        BEFORE INPUT
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
            LET g_before_input_done = FALSE
            CALL r150_set_entry(p_cmd)
            CALL r150_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
      AFTER FIELD rtype
            CALL r150_set_entry(p_cmd)
            CALL r150_set_no_entry(p_cmd)
 
      AFTER FIELD a
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                AND mai00 = g_aza.aza81         #No.FUN-740048
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
 
 
      AFTER FIELD yy1
         IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
            NEXT FIELD yy1
         END IF
 
      AFTER FIELD bm1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            ELSE
               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.bm1 <1 OR tm.bm1 > 13 THEN
            CALL cl_err('','agl-013',0)
            NEXT FIELD bm1
         END IF
      AFTER FIELD em1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
#         IF tm.em1 <1 OR tm.em1 > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em1
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm1 > tm.em1 THEN CALL cl_err('','9011',0) NEXT FIELD bm1 END IF
         IF tm.yy2 IS NULL THEN
            LET tm.yy2 = tm.yy1
            LET tm.bm2 = tm.bm1
            LET tm.em2 = 12
            DISPLAY BY NAME tm.yy2,tm.bm2,tm.em2
         END IF

#FUN-A10056----start----mark
#     AFTER FIELD plant1
#        IF tm.plant1 IS NOT NULL THEN
#           SELECT azp02 FROM azp_file WHERE azp01=tm.plant1
#           IF STATUS THEN 
#           CALL cl_err('sel azp:',STATUS,0) #FUN-660105
#           CALL cl_err3("sel","azp_file",tm.plant1,"",STATUS,"","sel azp:",0) #FUN-660105
#           NEXT FIELD plant1
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant1) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant1
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#no.5464
#     AFTER FIELD plant2
#        IF tm.plant2 IS NOT NULL THEN
#           SELECT azp02 FROM azp_file WHERE azp01=tm.plant2
#           IF STATUS THEN 
#           CALL cl_err('sel azp:',STATUS,0) #FUN-660105
#           CALL cl_err3("sel","azp_file",tm.plant2,"",STATUS,"","sel azp:",0) #FUN-660105
#           NEXT FIELD plant2
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant2) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant2
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#     AFTER FIELD plant3
#        IF tm.plant3 IS NOT NULL THEN
#           SELECT azp02 FROM azp_file WHERE azp01=tm.plant3
#           IF STATUS THEN 
#           CALL cl_err('sel azp:',STATUS,0) #FUN-660105
#           CALL cl_err3("sel","azp_file",tm.plant3,"",STATUS,"","sel azp:",0) #FUN-660105
#           NEXT FIELD plant3
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant3) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant3
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#     AFTER FIELD plant4
#        IF tm.plant4 IS NOT NULL THEN
#           SELECT azp02 FROM azp_file WHERE azp01=tm.plant4
#           IF STATUS THEN 
#           CALL cl_err('sel azp:',STATUS,0) #FUN-660105
#           CALL cl_err3("sel","azp_file",tm.plant4,"",STATUS,"","sel azp:",0) #FUN-660105
#           NEXT FIELD plant4
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant4) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant4
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#     AFTER FIELD plant5
#        IF tm.plant5 IS NOT NULL THEN
#           SELECT azp02 FROM azp_file WHERE azp01=tm.plant5
#           IF STATUS THEN 
#           CALL cl_err('sel azp:',STATUS,0) #FUN-660105
#           CALL cl_err3("sel","azp_file",tm.plant5,"",STATUS,"","sel azp:",0) #FUN-660105
#           NEXT FIELD plant5
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant5) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant5
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#no.5464(end)
#FUN-A10056----end----
      AFTER FIELD book1
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.book1 AND aaaacti ='Y'
         IF STATUS THEN 
#        CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
         CALL cl_err3("sel","aaa_file",tm.book1,"",STATUS,"","sel aaa:",0) #FUN-660105
         NEXT FIELD book1 END IF
#no.5464
      AFTER FIELD book2
         IF NOT cl_null(tm.book2) THEN
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.book2 AND aaaacti ='Y'
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","aaa_file",tm.book2,"",STATUS,"","sel aaa:",0) #FUN-660105
               NEXT FIELD book2
            END IF
         END IF
      AFTER FIELD book3
         IF NOT cl_null(tm.book3) THEN
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.book3 AND aaaacti ='Y'
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","aaa_file",tm.book3,"",STATUS,"","sel aaa:",0) #FUN-660105
               NEXT FIELD book3
            END IF
         END IF
      AFTER FIELD book4
         IF NOT cl_null(tm.book4) THEN
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.book4 AND aaaacti ='Y'
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","aaa_file",tm.book4,"",STATUS,"","sel aaa:",0) #FUN-660105
               NEXT FIELD book4
            END IF
         END IF
      AFTER FIELD book5
         IF NOT cl_null(tm.book5) THEN
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.book5 AND aaaacti ='Y'
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","aaa_file",tm.book5,"",STATUS,"","sel aaa:",0) #FUN-660105
               NEXT FIELD book5
            END IF
         END IF
#no.5464(end)
 
      AFTER FIELD title5
         IF tm.title5 ='TOTAL' THEN
            LET tm.yy5=NULL
            LET tm.bm5=NULL
            LET tm.em5=NULL
      #     LET tm.plant5=NULL    #FUN-A10056  mark
            LET tm.book5=NULL
      #     DISPLAY BY NAME tm.yy5,tm.bm5,tm.em5,tm.plant5,tm.book5  #FUN-A10056  mark
            DISPLAY BY NAME tm.yy5,tm.bm5,tm.em5,tm.book5            #FUN-A10056
         END IF
 
#No.FUN-810069--START--
#      AFTER FIELD budget
#         SELECT * FROM afa_file WHERE afa01=tm.budget
#       		     AND afaacti IN ('Y','y')
#                            AND afa00 = g_aza.aza81          #No.FUN-740048
#         IF STATUS THEN 
##         CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#         CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105
#         NEXT FIELD budget END IF
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
            CALL r150_set_entry(p_cmd)
            CALL r150_set_no_entry(p_cmd)
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN 
#        CALL cl_err(tm.p,'agl-109',0) #FUN-660105
         CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0) #FUN-660105
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
         IF tm.rtype='1' THEN
            LET tm.bm1 = 0 DISPLAY '' TO bm1
            LET tm.bm2 = 0 DISPLAY '' TO bm2
            LET tm.bm3 = 0 DISPLAY '' TO bm3
            LET tm.bm4 = 0 DISPLAY '' TO bm4
            LET tm.bm5 = 0 DISPLAY '' TO bm5
         END IF
        
#FUN-A10056---start---mark
#       LET tm.dbs1=NULL
#       LET tm.dbs2=NULL
#       LET tm.dbs3=NULL
#       LET tm.dbs4=NULL
#       LET tm.dbs5=NULL
#       IF tm.plant1 IS NOT NULL THEN
#          SELECT azp03 INTO tm.dbs1 FROM azp_file WHERE azp01=tm.plant1
#          #No.FUN-7B0012  --Begin
#          LET tm.dbs1=s_dbstring(tm.dbs1 CLIPPED)    #FUN-820017
#          #No.FUN-7B0012  --End  
#       END IF
#       IF tm.plant2 IS NOT NULL THEN
#          SELECT azp03 INTO tm.dbs2 FROM azp_file WHERE azp01=tm.plant2
#          #No.FUN-7B0012  --Begin
#          LET tm.dbs2=s_dbstring(tm.dbs2 CLIPPED)    #FUN-820017
#          #No.FUN-7B0012  --End  
#       END IF
#       IF tm.plant3 IS NOT NULL THEN
#          SELECT azp03 INTO tm.dbs3 FROM azp_file WHERE azp01=tm.plant3
#          #No.FUN-7B0012  --Begin
#          LET tm.dbs3=s_dbstring(tm.dbs3 CLIPPED)    #FUN-820017
#          #No.FUN-7B0012  --End  
#       END IF
#       IF tm.plant4 IS NOT NULL THEN
#          SELECT azp03 INTO tm.dbs4 FROM azp_file WHERE azp01=tm.plant4
#          #No.FUN-7B0012  --Begin
#          LET tm.dbs4=s_dbstring(tm.dbs4 CLIPPED)    #FUN-820017
#          #No.FUN-7B0012  --End  
#       END IF
#       IF tm.plant5 IS NOT NULL THEN
#          SELECT azp03 INTO tm.dbs5 FROM azp_file WHERE azp01=tm.plant5
#          #No.FUN-7B0012  --Begin
#          LET tm.dbs5=s_dbstring(tm.dbs5 CLIPPED)    #FUN-820017
#          #No.FUN-7B0012  --End  
#       END IF
#FUN-A10056 ---end---
        IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
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
           {WHEN INFIELD(b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = tm.b
                   CALL cl_create_qry() RETURNING tm.b
                   DISPLAY tm.b TO b
            NEXT FIELD b}
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
#                LET g_qryparam.arg1 = g_aza.aza81        #No.FUN-740048
#                CALL cl_create_qry() RETURNING tm.budget
#                DISPLAY tm.budget TO budget
#           NEXT FIELD budget
#No.FUN-810069--END
#No.FUN-AB0020--START--                                                                                                             
          WHEN INFIELD(budget)                                                                                                      
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form ="q_azf"                                                                                        
                LET g_qryparam.default1 = tm.budget                                                                                 
                LET g_qryparam.arg1 = '2'                                                                                           
                CALL cl_create_qry() RETURNING tm.budget                                                                            
                DISPLAY tm.budget TO budget                                                                                         
                NEXT FIELD budget                                                                                                   
#No.FUN-AB0020--END
 
#NO.FUN-A10056----start---mark
#          WHEN INFIELD(plant1)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_azp'  #No.FUN-940102
#                LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
#                LET g_qryparam.arg1 = g_user   #No.FUN-940102
#                LET g_qryparam.default1 = tm.plant1
#                  CALL cl_create_qry() RETURNING tm.plant1
#                  DISPLAY tm.plant1 TO plant1
#           NEXT FIELD plant1
#
#          WHEN INFIELD(plant2)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_azp'  #No.FUN-940102
#                LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
#                LET g_qryparam.arg1 = g_user   #No.FUN-940102
#                LET g_qryparam.default1 = tm.plant2
#                  CALL cl_create_qry() RETURNING tm.plant2
#                  DISPLAY tm.plant2 TO plant2
#           NEXT FIELD plant2
#
#
#          WHEN INFIELD(plant3)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_azp'  #No.FUN-940102
#                LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
#                LET g_qryparam.arg1 = g_user   #No.FUN-940102
#                LET g_qryparam.default1 = tm.plant3
#                  CALL cl_create_qry() RETURNING tm.plant3
#                  DISPLAY tm.plant3 TO plant3
#           NEXT FIELD plant3
#          WHEN INFIELD(plant4)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_azp'  #No.FUN-940102
#                LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
#                LET g_qryparam.arg1 = g_user   #No.FUN-940102
#                LET g_qryparam.default1 = tm.plant4
#                  CALL cl_create_qry() RETURNING tm.plant4
#                  DISPLAY tm.plant4 TO plant4
#           NEXT FIELD plant4
#          WHEN INFIELD(plant5)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_azp'  #No.FUN-940102
#                LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
#                LET g_qryparam.arg1 = g_user   #No.FUN-940102
#                LET g_qryparam.default1 = tm.plant5
#                  CALL cl_create_qry() RETURNING tm.plant5
#                  DISPLAY tm.plant5 TO plant5
#           NEXT FIELD plant5
#NO.FUN-A10056----end----
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
      LET INT_FLAG = 0 CLOSE WINDOW r150_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr150','9031',1)
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
                         " '",tm.title1 CLIPPED,"'",   #TQC-610054
                      " '",tm.yy1 CLIPPED,"'",
                      " '",tm.bm1 CLIPPED,"'",
                      " '",tm.em1 CLIPPED,"'",
                         " '",tm.title2 CLIPPED,"'",   #TQC-610054
                      " '",tm.yy2 CLIPPED,"'",   #TQC-610054
                      " '",tm.bm2 CLIPPED,"'",   #TQC-610054
                      " '",tm.em2 CLIPPED,"'",   #TQC-610054
                         " '",tm.title3 CLIPPED,"'",   #TQC-610054
                      " '",tm.yy3 CLIPPED,"'",   #TQC-610054
                      " '",tm.bm3 CLIPPED,"'",   #TQC-610054
                      " '",tm.em3 CLIPPED,"'",   #TQC-610054
                         " '",tm.title4 CLIPPED,"'",   #TQC-610054
                      " '",tm.yy4 CLIPPED,"'",   #TQC-610054
                      " '",tm.bm4 CLIPPED,"'",   #TQC-610054
                      " '",tm.em4 CLIPPED,"'",   #TQC-610054
                         " '",tm.title5 CLIPPED,"'",   #TQC-610054
                      " '",tm.yy5 CLIPPED,"'",   #TQC-610054
                      " '",tm.bm5 CLIPPED,"'",   #TQC-610054
                      " '",tm.em5 CLIPPED,"'",   #TQC-610054
#                      " '",tm.budget CLIPPED,"'",   #TQC-610054   #FUN-810069
                      " '",tm.budget CLIPPED,"'",   #FUN-AB0020 add
                      " '",tm.c CLIPPED,"'",
                      " '",tm.d CLIPPED,"'",
                      " '",tm.e CLIPPED,"'",
                      " '",tm.f CLIPPED,"'",
                      " '",tm.h CLIPPED,"'",
                      " '",tm.o CLIPPED,"'",
                      " '",tm.r CLIPPED,"'",   #TQC-610054
                      " '",tm.p CLIPPED,"'",
                      " '",tm.q CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr150',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r150()
   ERROR ""
END WHILE
   CLOSE WINDOW r150_w
END FUNCTION
 
FUNCTION r150()
   DEFINE per1,per2,per3,per4,per5    LIKE ima_File.ima18
   DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT    #No.FUN-680061  VARCHAR(1000)
   DEFINE l_sql1    LIKE type_file.chr1000  # RDSQL STATEMENT    #No.FUN-680061  VARCHAR(1000)
   DEFINE l_sql2    LIKE type_file.chr1000  # RDSQL STATEMENT    #No.FUN-680061  VARCHAR(1000) 
   DEFINE l_sql3    LIKE type_file.chr1000  # RDSQL STATEMENT    #No.FUN-680061  VARCHAR(1000) 
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680061  VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(40)
   DEFINE amt1,amt2,amt3,amt4,amt5 LIKE type_file.num20_6        #No.FUN-680061 DEC(20,6)
   DEFINE l_tmp     LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_azk041_1  LIKE azk_file.azk041
   DEFINE l_azk041_2  LIKE azk_file.azk041
   DEFINE l_azk041_3  LIKE azk_file.azk041
   DEFINE l_azk041_4  LIKE azk_file.azk041
   DEFINE l_azk041_5  LIKE azk_file.azk041
   DEFINE l_azk02_1   LIKE azk_file.azk02
   DEFINE l_azk02_2   LIKE azk_file.azk02
   DEFINE l_azk02_3   LIKE azk_file.azk02
   DEFINE l_azk02_4   LIKE azk_file.azk02
   DEFINE l_azk02_5   LIKE azk_file.azk02
   DEFINE i           LIKE type_file.num5      #No.FUN-680061 SMALLINT
   DEFINE l_dbs       LIKE type_file.chr21     #No.FUN-680061 VARCHAR(21)
   DEFINE l_date      LIKE type_file.chr50     #FUN-750025 add
   DEFINE sr  RECORD
              bal1,bal2,bal3,bal4,bal5	LIKE type_file.num20_6#No.FUN-680061 DEC(20,6)
              END RECORD
  #-MOD-AA0104-add-
   DEFINE cr  RECORD 
                 maj02     LIKE maj_file.maj02,
                 bal1      LIKE type_file.num20_6,
                 bal2      LIKE type_file.num20_6,
                 bal3      LIKE type_file.num20_6,
                 bal4      LIKE type_file.num20_6,
                 bal5      LIKE type_file.num20_6,
                 line      LIKE type_file.num5
              END RECORD
  #-MOD-AA0104-end-
 
     #str FUN-750025 add
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #------------no.3989  依工廠別組 sql-------------------------
     FOR i = 1 TO 5
#FUN-A10056 ---start----
#        CASE i WHEN 1 LET l_dbs = tm.dbs1
#               WHEN 2 LET l_dbs = tm.dbs2
#               WHEN 3 LET l_dbs = tm.dbs3
#               WHEN 4 LET l_dbs = tm.dbs4
#               WHEN 5 LET l_dbs = tm.dbs5
#        END CASE
#        LET l_sql1="SELECT SUM(afc06) FROM ",l_dbs,"afc_file",
         LET l_sql1="SELECT SUM(afc06) FROM afc_file",
#FUN-A10056 ---end---
                   " WHERE afc00 = ?",
                  #"   AND afc01 = '",tm.budget,"'",  #FUN-810069
                   "   AND afc02 BETWEEN ? AND ?",
                   "   AND afc03 = ?",
                   "   AND afc05 BETWEEN ? AND ?",
                  #"   AND afc04 = '@' ",         #整體預算 #CHI-A20007 mark
                  #"   AND afc041 = ' ' AND afc042 = ' ' "  #FUN-810069  #CHI-A40063 mod ' '  #CHI-A20007 mark
                   "   AND afc04 = ' ' AND afc042 = ' ' "   #CHI-A20007 add 
#        LET l_sql2="SELECT SUM(afc06) FROM ",l_dbs,"afc_file,afb_file",   #FUN-A10056  mark
         LET l_sql2="SELECT SUM(afc06) FROM afc_file,afb_file",         #FUN-A10056 
                   " WHERE afc00 = ?",
                   "   AND afb00 = afc00  AND afb01 = afc01 ",
                   "   AND afb02 = afc02  AND afb03 = afc03 ",
                   "   AND afb04 = afc04  ",
                  #"   AND afb15 = '2'    ",     #部門預算   #CHI-A20007 mark
                  #"   AND afc01 = '",tm.budget,"'",  #FUN-810069
                   "   AND afc02 BETWEEN ? AND ?",
                  #"   AND afc04 BETWEEN ? AND ?",    #CHI-A20007 mark
                   "   AND afc041 BETWEEN ? AND ?",   #CHI-A20007 add
                   "   AND afc03 = ?",
                   "   AND afc05 BETWEEN ? AND ? ",
                   "   AND afb041 = afc041 AND afb042 = afc042",  #FUN-810069
                  #"   AND afb041 = ' ' AND afb042 = ' ' "        #FUN-810069 #CHI-A40036 mod ' ' #CHI-A20007 mark
                   "   AND afb04 = ' ' AND afb042 = ' ' "         #CHI-A20007 add 
                  ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
                
        #FUN-AB0020 add start-------------   
        IF NOT cl_null(tm.budget) THEN 
           LET l_sql1 = l_sql1," AND afc01 = '",tm.budget,"'"
           LET l_sql2 = l_sql2," AND afc01 = '",tm.budget,"'"   
        END IF 
        #FUN-AB0020 add end---------------
        CASE i WHEN 1
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032  #FUN-950007 add
                 PREPARE aah_p1 FROM l_sql1 DECLARE aah_c1 CURSOR FOR aah_p1
                 PREPARE aao_p1 FROM l_sql2 DECLARE aao_c1 CURSOR FOR aao_p1
               WHEN 2
                 PREPARE aah_p2 FROM l_sql1 DECLARE aah_c2 CURSOR FOR aah_p2
                 PREPARE aao_p2 FROM l_sql2 DECLARE aao_c2 CURSOR FOR aao_p2
               WHEN 3
                 PREPARE aah_p3 FROM l_sql1 DECLARE aah_c3 CURSOR FOR aah_p3
                 PREPARE aao_p3 FROM l_sql2 DECLARE aao_c3 CURSOR FOR aao_p3
               WHEN 4
                 PREPARE aah_p4 FROM l_sql1 DECLARE aah_c4 CURSOR FOR aah_p4
                 PREPARE aao_p4 FROM l_sql2 DECLARE aao_c4 CURSOR FOR aao_p4
               WHEN 5
                 PREPARE aah_p5 FROM l_sql1 DECLARE aah_c5 CURSOR FOR aah_p5
                 PREPARE aao_p5 FROM l_sql2 DECLARE aao_c5 CURSOR FOR aao_p5
        END CASE
     END FOR
     #------------------------------------------------------------
     CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
          WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
          OTHERWISE         LET g_msg=" 1=1"
     END CASE
     LET g_basetot1 = NULL                            #MOD-AA0104
     LET g_basetot2 = NULL                            #MOD-AA0104
     LET g_basetot3 = NULL                            #MOD-AA0104
     LET g_basetot4 = NULL                            #MOD-AA0104
     LET g_basetot5 = NULL                            #MOD-AA0104
     LET l_sql = "SELECT * FROM maj_file",
                 " WHERE maj01 = '",tm.a,"'",
                 "   AND ",g_msg CLIPPED,
                 " ORDER BY maj02"
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r150_p FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r150_c CURSOR FOR r150_p
     FOR g_i = 1 TO 100
         LET g_tot1[g_i] = 0 LET g_tot2[g_i] = 0 LET g_tot3[g_i] = 0
         LET g_tot4[g_i] = 0 LET g_tot5[g_i] = 0
     END FOR
     #CALL cl_outnam('abgr150') RETURNING l_name
     #START REPORT r150_rep TO l_name
     FOREACH r150_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0 LET amt2 = 0 LET amt3=0 LET amt4=0 LET amt5=0
       IF NOT cl_null(maj.maj21) THEN
          IF maj.maj24 IS NULL THEN
             OPEN aah_c1 USING tm.book1,maj.maj21,maj.maj22,
                               tm.yy1,tm.bm1,tm.em1
             IF STATUS THEN CALL cl_err('open aah_c1',STATUS,1) END IF
             FETCH aah_c1 INTO amt1
          ELSE
             OPEN aao_c1 USING tm.book1,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                               tm.yy1,tm.bm1,tm.em1
             IF STATUS THEN CALL cl_err('open aao_c1',STATUS,1) END IF
             FETCH aao_c1 INTO amt1
          END IF
          IF STATUS THEN CALL cl_err('sel aah1:',STATUS,1) EXIT FOREACH END IF
          IF amt1 IS NULL THEN LET amt1 = 0 END IF
          #CHI-A40063 add --start--
          IF maj.maj09='-' THEN
             LET amt1 = amt1 * -1
          END IF
          #CHI-A40063 add --end--
       END IF
       IF NOT cl_null(maj.maj21) AND tm.yy2 IS NOT NULL THEN
          IF maj.maj24 IS NULL THEN
             OPEN aah_c2 USING tm.book2,maj.maj21,maj.maj22,
                               tm.yy2,tm.bm2,tm.em2
             IF STATUS THEN CALL cl_err('open aah_c2',STATUS,1) END IF
             FETCH aah_c2 INTO amt2
          ELSE
             OPEN aao_c2 USING tm.book2,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                               tm.yy2,tm.bm2,tm.em2
             IF STATUS THEN CALL cl_err('open aao_c2',STATUS,1) END IF
             FETCH aao_c2 INTO amt2
          END IF
          IF STATUS THEN CALL cl_err('sel aah2:',STATUS,1) EXIT FOREACH END IF
          IF amt2 IS NULL THEN LET amt2 = 0 END IF
          #CHI-A40063 add --start--
          IF maj.maj09='-' THEN
             LET amt2 = amt2 * -1
          END IF
          #CHI-A40063 add --end--
       END IF
       IF NOT cl_null(maj.maj21) AND tm.yy3 IS NOT NULL THEN
          IF maj.maj24 IS NULL THEN
             OPEN aah_c3 USING tm.book3,maj.maj21,maj.maj22,
                               tm.yy3,tm.bm3,tm.em3
             IF STATUS THEN CALL cl_err('open aah_c3',STATUS,1) END IF
             FETCH aah_c3 INTO amt3
          ELSE
             OPEN aao_c3 USING tm.book3,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                               tm.yy3,tm.bm3,tm.em3
             IF STATUS THEN CALL cl_err('open aao_c3',STATUS,1) END IF
             FETCH aao_c3 INTO amt3
          END IF
          IF STATUS THEN CALL cl_err('sel aah3:',STATUS,1) EXIT FOREACH END IF
          IF amt3 IS NULL THEN LET amt3 = 0 END IF
          #CHI-A40063 add --start--
          IF maj.maj09='-' THEN
             LET amt3 = amt3 * -1
          END IF
          #CHI-A40063 add --end--
       END IF
       IF NOT cl_null(maj.maj21) AND tm.yy4 IS NOT NULL THEN
          IF maj.maj24 IS NULL THEN
             OPEN aah_c4 USING tm.book4,maj.maj21,maj.maj22,
                               tm.yy4,tm.bm4,tm.em4
             IF STATUS THEN CALL cl_err('open aah_c4',STATUS,1) END IF
             FETCH aah_c4 INTO amt4
          ELSE
             OPEN aao_c4 USING tm.book4,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                               tm.yy4,tm.bm4,tm.em4
             IF STATUS THEN CALL cl_err('open aao_c4',STATUS,1) END IF
             FETCH aao_c4 INTO amt4
          END IF
          IF STATUS THEN CALL cl_err('sel aah4:',STATUS,1) EXIT FOREACH END IF
          IF amt4 IS NULL THEN LET amt4 = 0 END IF
          #CHI-A40063 add --start--
          IF maj.maj09='-' THEN
             LET amt4 = amt4 * -1
          END IF
          #CHI-A40063 add --end--
       END IF
       IF NOT cl_null(maj.maj21) AND tm.yy5 IS NOT NULL THEN
          IF maj.maj24 IS NULL THEN
             OPEN aah_c5 USING tm.book5,maj.maj21,maj.maj22,
                               tm.yy5,tm.bm5,tm.em5
             IF STATUS THEN CALL cl_err('open aah_c5',STATUS,1) END IF
             FETCH aah_c5 INTO amt5
          ELSE
             OPEN aao_c5 USING tm.book5,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                               tm.yy5,tm.bm5,tm.em5
             IF STATUS THEN CALL cl_err('open aao_c5',STATUS,1) END IF
             FETCH aao_c5 INTO amt5
          END IF
          IF STATUS THEN CALL cl_err('sel aah5:',STATUS,1) EXIT FOREACH END IF
          IF amt5 IS NULL THEN LET amt5 = 0 END IF
          #CHI-A40063 add --start--
          IF maj.maj09='-' THEN
             LET amt5 = amt5 * -1
          END IF
          #CHI-A40063 add --end--
       END IF
       #------------------------------------------------------------
       IF tm.title5='TOTAL' THEN	# 當第五期名稱為'TOTAL'時,表合計
          LET amt5=amt1+amt2+amt3+amt4
       END IF
       #------------------------------------------------------------
       IF g_trace='Y' THEN
          DISPLAY 'F2:',maj.maj02,' ',maj.maj21,' TT:',amt1,amt2
       END IF
     #------------no.3989  依工廠別組 sql-------------------------
     #抓取幣別小數取位........
     FOR i = 1 TO 5
#FUN-A10056 ---start---
#        CASE i WHEN 1 LET l_dbs = tm.dbs1
#               WHEN 2 LET l_dbs = tm.dbs2
#               WHEN 3 LET l_dbs = tm.dbs3
#               WHEN 4 LET l_dbs = tm.dbs4
#               WHEN 5 LET l_dbs = tm.dbs5
#        END CASE
#        #---NO:3531 wiky
#        LET l_sql3="SELECT MAX(azk02),azk041 FROM ",l_dbs CLIPPED,"azk_file",
         LET l_sql3="SELECT MAX(azk02),azk041 FROM azk_file",
#FUN-A10056 ---end---
                   " WHERE azk01=?",
                   "   AND YEAR(azk02)=?",
                   "   AND MONTH(azk02)=?",
                   "   GROUP BY azk041 "
        IF tm.o = 'Y' THEN #轉換幣別='Y'
           CASE i
             WHEN 1   #---抓第一個azk041
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
                  PREPARE azk_01 FROM l_sql3 DECLARE azk_1 CURSOR FOR azk_01
                  OPEN azk_1 USING tm.p,tm.yy1,tm.q
                  IF STATUS THEN CALL cl_err('open azk_1',STATUS,1) END IF
                  FETCH azk_1 INTO l_azk02_1,l_azk041_1
             WHEN 2   #---抓第二個azk041
                  PREPARE azk_02 FROM l_sql3 DECLARE azk_2 CURSOR FOR azk_02
                  OPEN azk_2 USING tm.p,tm.yy2,tm.q
                  IF STATUS THEN CALL cl_err('open azk_2',STATUS,1) END IF
                  FETCH azk_2 INTO l_azk02_2,l_azk041_2
             WHEN 3   #---抓第三個azk041
                  PREPARE azk_03 FROM l_sql3 DECLARE azk_3 CURSOR FOR azk_03
                  OPEN azk_3 USING tm.p,tm.yy3,tm.q
                  IF STATUS THEN CALL cl_err('open azk_3',STATUS,1) END IF
                  FETCH azk_3 INTO l_azk02_3,l_azk041_3
             WHEN 4   #---抓第四個azk041
                  PREPARE azk_04 FROM l_sql3 DECLARE azk_4 CURSOR FOR azk_04
                  OPEN azk_4 USING tm.p,tm.yy4,tm.q
                  IF STATUS THEN CALL cl_err('open azk_4',STATUS,1) END IF
                  FETCH azk_4 INTO l_azk02_4,l_azk041_4
             WHEN 5   #---抓第五個azk041
#                 LET l_sql3[31,51]=tm.dbs5
                  PREPARE azk_05 FROM l_sql3 DECLARE azk_5 CURSOR FOR azk_05
                  OPEN azk_5 USING tm.p,tm.yy5,tm.q
                  IF STATUS THEN CALL cl_err('open azk_5',STATUS,1) END IF
                  FETCH azk_5 INTO l_azk02_5,l_azk041_5
           END CASE
        ELSE
           CASE i
             WHEN 1   #---抓第一個azk041
               PREPARE azk_x01 FROM l_sql3 DECLARE azk_x1 CURSOR FOR azk_x01
               OPEN azk_x1 USING tm.r,tm.yy1,tm.q
               IF STATUS THEN CALL cl_err('open azk_x1',STATUS,1) END IF
               FETCH azk_x1 INTO l_azk02_1,l_azk041_1
             WHEN 2   #---抓第二個azk041
               PREPARE azk_x02 FROM l_sql3 DECLARE azk_x2 CURSOR FOR azk_x02
               OPEN azk_x2 USING tm.r,tm.yy2,tm.q
               IF STATUS THEN CALL cl_err('open azk_x2',STATUS,1) END IF
               FETCH azk_x2 INTO l_azk02_2,l_azk041_2
             WHEN 3   #---抓第三個azk041
               PREPARE azk_x03 FROM l_sql3 DECLARE azk_x3 CURSOR FOR azk_x03
               OPEN azk_x3 USING tm.r,tm.yy3,tm.q
               IF STATUS THEN CALL cl_err('open azk_x3',STATUS,1) END IF
               FETCH azk_x3 INTO l_azk02_3,l_azk041_3
             WHEN 4   #---抓第四個azk041
               PREPARE azk_x04 FROM l_sql3 DECLARE azk_x4 CURSOR FOR azk_x04
               OPEN azk_x4 USING tm.r,tm.yy4,tm.q
               IF STATUS THEN CALL cl_err('open azk_x4',STATUS,1) END IF
               FETCH azk_x4 INTO l_azk02_4,l_azk041_4
             WHEN 5   #---抓第五個azk041
               PREPARE azk_x05 FROM l_sql3 DECLARE azk_x5 CURSOR FOR azk_x05
               OPEN azk_x5 USING tm.r,tm.yy5,tm.q
               IF STATUS THEN CALL cl_err('open azk_x5',STATUS,1) END IF
               FETCH azk_x5 INTO l_azk02_5,l_azk041_5
           END CASE
        END IF
     END FOR
       IF tm.q IS NULL THEN
          LET  l_azk041_1=1
          LET  l_azk041_2=1
          LET  l_azk041_3=1
          LET  l_azk041_4=1
          LET  l_azk041_5=1
       END IF
       IF l_azk041_1 IS NULL THEN LET  l_azk041_1=1 END IF
       IF l_azk041_2 IS NULL THEN LET  l_azk041_2=1 END IF
       IF l_azk041_3 IS NULL THEN LET  l_azk041_3=1 END IF
       IF l_azk041_4 IS NULL THEN LET  l_azk041_4=1 END IF
       IF l_azk041_5 IS NULL THEN LET  l_azk041_5=1 END IF
     #各期科目餘額 * azk041
         LET amt1 = amt1 * l_azk041_1
         LET amt2 = amt2 * l_azk041_2
         LET amt3 = amt3 * l_azk041_3
         LET amt4 = amt4 * l_azk041_4
         LET amt5 = amt5 * l_azk041_5
     #---NO:3531 wiky
 
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN	#合計階數處理
          FOR i = 1 TO 100
              LET g_tot1[i]=g_tot1[i]+amt1
              LET g_tot2[i]=g_tot2[i]+amt2
              LET g_tot3[i]=g_tot3[i]+amt3
              LET g_tot4[i]=g_tot4[i]+amt4
              LET g_tot5[i]=g_tot5[i]+amt5
          END FOR
          LET k=maj.maj08
          LET sr.bal1=g_tot1[k] LET sr.bal2=g_tot2[k] LET sr.bal3=g_tot3[k]
          LET sr.bal4=g_tot4[k] LET sr.bal5=g_tot5[k]
          FOR i = 1 TO maj.maj08
              LET g_tot1[i]=0 LET g_tot2[i]=0 LET g_tot3[i]=0
              LET g_tot4[i]=0 LET g_tot5[i]=0
          END FOR
       ELSE
          IF maj.maj03='5' THEN
              LET sr.bal1=amt1
              LET sr.bal2=amt2
              LET sr.bal3=amt3
              LET sr.bal4=amt4
              LET sr.bal5=amt5
          ELSE
              LET sr.bal1=NULL
              LET sr.bal2=NULL
              LET sr.bal3=NULL
              LET sr.bal4=NULL
              LET sr.bal5=NULL
          END IF
       END IF
       IF maj.maj11 = 'Y' THEN			# 百分比基準科目
          LET g_basetot1=sr.bal1
          LET g_basetot2=sr.bal2
          LET g_basetot3=sr.bal3
          LET g_basetot4=sr.bal4
          LET g_basetot5=sr.bal5
          IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF  #MOD-AA0104
          IF g_basetot2 = 0 THEN LET g_basetot2 = NULL END IF  #MOD-AA0104
          IF g_basetot3 = 0 THEN LET g_basetot3 = NULL END IF  #MOD-AA0104
          IF g_basetot4 = 0 THEN LET g_basetot4 = NULL END IF  #MOD-AA0104
          IF g_basetot5 = 0 THEN LET g_basetot5 = NULL END IF  #MOD-AA0104
          IF maj.maj07='2' THEN
             LET g_basetot1=g_basetot1*-1
             LET g_basetot2=g_basetot2*-1
             LET g_basetot3=g_basetot3*-1
             LET g_basetot4=g_basetot4*-1
             LET g_basetot5=g_basetot5*-1
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
       IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]" AND sr.bal1=0 AND sr.bal2=0              #CHI-CC0023 add maj03 match 5
                                    AND sr.bal3=0 AND sr.bal4=0
                                    AND sr.bal5=0 THEN
          CONTINUE FOREACH				#餘額為 0 者不列印
       END IF
       IF tm.f>0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH				#最小階數起列印
       END IF
 
       #str FUN-750025 add
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       IF maj.maj07='2' THEN
          LET sr.bal1=sr.bal1*-1
          LET sr.bal2=sr.bal2*-1
          LET sr.bal3=sr.bal3*-1
          LET sr.bal4=sr.bal4*-1
          LET sr.bal5=sr.bal5*-1
       END IF
       IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
      #-MOD-AA0104-mark-
      #LET per1 = (sr.bal1 / g_basetot1) * 100
      #LET per2 = (sr.bal2 / g_basetot2) * 100
      #LET per3 = (sr.bal3 / g_basetot3) * 100
      #LET per4 = (sr.bal4 / g_basetot4) * 100
      #LET per5 = (sr.bal5 / g_basetot5) * 100
      #IF cl_null(per1) THEN
      #   LET per1=0
      #END IF
      #IF cl_null(per2) THEN
      #   LET per2=0
      #END IF
      #IF cl_null(per3) THEN
      #   LET per3=0
      #END IF
      #IF cl_null(per4) THEN
      #   LET per4=0
      #END IF
      #IF cl_null(per5) THEN
      #   LET per5=0
      #END IF
       LET per1 = 0                                         
       LET per2 = 0                                         
       LET per3 = 0                                         
       LET per4 = 0                                      
       LET per5 = 0                                        
      #-MOD-AA0104-end-
       IF tm.d MATCHES '[23]' THEN
          LET sr.bal1=sr.bal1 / g_unit
          LET sr.bal2=sr.bal2 / g_unit
          LET sr.bal3=sr.bal3 / g_unit
          LET sr.bal4=sr.bal4 / g_unit
          LET sr.bal5=sr.bal5 / g_unit
       END IF

       #CHI-A40063 add --start--
       IF sr.bal1<0 THEN LET sr.bal1=sr.bal1*-1 END IF
       IF sr.bal2<0 THEN LET sr.bal2=sr.bal2*-1 END IF
       IF sr.bal3<0 THEN LET sr.bal3=sr.bal3*-1 END IF
       IF sr.bal4<0 THEN LET sr.bal4=sr.bal4*-1 END IF
       IF sr.bal5<0 THEN LET sr.bal5=sr.bal5*-1 END IF
       #CHI-A40063 add --end--
 
	IF maj.maj04 = 0 THEN
	  EXECUTE insert_prep USING maj.maj20,
                                    maj.maj20e,
                                    maj.maj02,
                                    maj.maj03,
                                    sr.bal1,
                                    sr.bal2,
                                    sr.bal3,
                                    sr.bal4,
                                    sr.bal5,
                                    '2',
                                    per1,
                                    per2,
                                    per3,
                                    per4,
                                    per5,
                                    g_azi04
	ELSE
	  EXECUTE insert_prep USING maj.maj20,
                                    maj.maj20e,
                                    maj.maj02,
                                    maj.maj03,
                                    sr.bal1,
                                    sr.bal2,
                                    sr.bal3,
                                    sr.bal4,
                                    sr.bal5,
                                    '2',
                                    per1,
                                    per2,
                                    per3,
                                    per4,
                                    per5,
                                    g_azi04
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING maj.maj20,maj.maj20e,maj.maj02,'',
             '0','0','0','0','0', 
             '1','','','','','',
             ''
         END FOR
        END IF
 
     END FOREACH
     IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
     IF g_basetot2 = 0 THEN LET g_basetot2 = NULL END IF
     IF g_basetot3 = 0 THEN LET g_basetot3 = NULL END IF
     IF g_basetot4 = 0 THEN LET g_basetot4 = NULL END IF
     IF g_basetot5 = 0 THEN LET g_basetot5 = NULL END IF
 
    #-MOD-AA0104-add-
     IF g_basetot1<>0 OR g_basetot2<>0 OR g_basetot3<>0 OR g_basetot4<>0 OR g_basetot5<>0 THEN
        LET l_sql = "SELECT maj02,bal1,bal2,bal3,bal4,bal5,line",
                    "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
        PREPARE r150_crtmp_p FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        END IF
        DECLARE r150_crtmp_c CURSOR FOR r150_crtmp_p
        FOREACH r150_crtmp_c INTO cr.*
           IF cr.bal1<>0 OR cr.bal2<>0 OR cr.bal3<>0 OR cr.bal4<>0 OR cr.bal5<>0 THEN
              LET per1 = (cr.bal1 / g_basetot1) * 100         
              LET per2 = (cr.bal2 / g_basetot2) * 100        
              LET per3 = (cr.bal3 / g_basetot3) * 100      
              LET per4 = (cr.bal4 / g_basetot4) * 100    
              LET per5 = (cr.bal5 / g_basetot5) * 100  
              EXECUTE update_prep USING per1,per2,per3,per4,per5,cr.maj02,cr.line
           END IF
        END FOREACH
     END IF
    #-MOD-AA0104-end-
     #FINISH REPORT r150_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     #str FUN-750025 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    
     #報表名稱是否以報表結構名稱列印
     IF g_aaz.aaz77 = 'N' THEN LET g_mai02 = '' END IF
     LET l_date = tm.yy1 USING '<<<<','/',tm.bm1 USING '&&','-',tm.em1 USING '&&',
                  tm.yy2 USING '<<<<','/',tm.bm2 USING '&&','-',tm.em2 USING '&&',
                  tm.yy3 USING '<<<<','/',tm.bm3 USING '&&','-',tm.em3 USING '&&',
                  tm.yy4 USING '<<<<','/',tm.bm4 USING '&&','-',tm.em4 USING '&&',
                  tm.yy5 USING '<<<<','/',tm.bm5 USING '&&','-',tm.em5 USING '&&'
     LET g_str = g_mai02,";", tm.a,";",tm.d,";",tm.e,";",tm.p,";",
                 tm.title1,";",tm.title2,";",tm.title3,";",
                 tm.title4,";",tm.title5,";",
                 l_date,";",
#                tm.plant1,";",tm.plant2,";",   #FUN-A10056  mark
#                tm.plant3,";",tm.plant4,";",   #FUN-A10056  mark
#                tm.plant5,";",tm.book1         #FUN-A10056  mark
                 tm.book1                       #FUN-A10056
 
     CALL cl_prt_cs3('abgr150','abgr150',g_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     #end FUN-750025 add
END FUNCTION
 
FUNCTION r150_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680061 VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bm1,p,q",TRUE)
#   END IF
 
END FUNCTION
 
FUNCTION r150_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680061 VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       IF tm.rtype='1' THEN
           LET tm.bm1 = 0 DISPLAY '' TO bm
           CALL cl_set_comp_entry("bm1",FALSE)
       END IF
       IF tm.o = 'N' THEN
           CALL cl_set_comp_entry("p,q",FALSE)
       END IF
#   END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <> #
#TQC-760001
