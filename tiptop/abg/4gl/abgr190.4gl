# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr190.4gl (copy from aglr190)
# Descriptions...: 當期部門預算財務報表
# Date & Author..: 03/03/10 By Kammy
# Modify.........: No.FUN-510025 05/01/13 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/08 By baogui 報表修改
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740048 07/04/12 By johnray 會計科目加帳套
# Modify.........: No.TQC-760073 07/06/12 By johnray 調整欄位輸入順序
# Modify.........: No.TQC-760066 07/06/19 By chenl   調整輸入方式，改善交互界面。
# Modify.........: NO.FUN-750025 07/07/26 BY TSD.liquor 改為crystal report
# Modify.........: NO.FUN-810069 08/02/28 By destiny 取消預算編號
# Modify.........: No.FUN-880052 09/01/12 By Cockroach MARK cl_outnam()
# Modify.........: No.MOD-920149 09/02/16 By Sarah 執行報表後會出現錯誤訊息per1公式:數字格式字串錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A30009 10/04/09 By Summer 預算金額錯誤
# Modify.........: No:CHI-A40062 10/05/04 By Summer 增加條件"族群編號"為開窗
# Modify.........: No:MOD-A70030 10/07/05 By sabrina 將g_buf型態改為string
# Modify.........: No:MOD-A20042 10/02/05 By sabrina 修改PREPARE r190_sum的l_sql 
# Modify.........: No:CHI-A20007 10/10/28 By sabrina afb15='2'要mark掉 
# Modify.........: No:FUN-AB0020 10/11/08 By suncx 新增欄位預算項目，處理相關邏輯
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
              a       LIKE maj_file.maj01,     #報表結構編號   #No.FUN-680061 VARCHAR(6)
              b       LIKE aaa_file.aaa01,     #帳別編號  #No.FUN-670039 
              abe01   LIKE abe_file.abe01,     #列印族群/部門  #No.FUN-680061 VARCHAR(6)
              yy     LIKE abk_file.abk03,      #輸入年度         #No.FUN-680061 SMALLINT
              bm      LIKE aah_file.aah03,     #Begin 期別     #No.FUN-680061 SMALLINT
              em      LIKE aah_file.aah03,     # End  期別     #No.FUN-680061 SMALLINT
             #budget  LIKE afa_file.afa01,     #預算編號   #No.FUN-680061 VARCHAR(4)       #No.FUN-810069--mark
              budget  LIKE azf_file.azf01,     #預算项目   #FUN-AB0020 add
              c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印   #No.FUN-680061 VARCHAR(1)
              d       LIKE type_file.chr1,     #金額單位   #No.FUN-680061 VARCHAR(1)
              e       LIKE azi_file.azi05,     #小數位數   #No.FUN-680061 SMALLINT
              f       LIKE maj_file.maj08,     #列印最小階數   #No.FUN-680061 SMALLINT
              h       LIKE fan_file.fan02,     #額外說明類別   #No.FUN-680061 VARCHAR(4)
              o       LIKE type_file.chr1,     #轉換幣別否 #No.FUN-680061 VARCHAR(1)   
              p       LIKE azi_file.azi01,     #幣別
              q       LIKE azj_file.azj03,     #匯率
              r       LIKE azi_file.azi01,     #幣別
              more    LIKE type_file.chr1      #No.FUN-680061 VARCHAR(1)
           END RECORD,
       i,j,k,g_mm      LIKE type_file.num5,    #No.FUN-680061 SMALLINT
       g_unit    LIKE type_file.num10,         #金額單位基數   #No.FUN-680061 INTEGER
      #g_buf     LIKE type_file.chr1000,       #No.FUN-680061 VARCHAR(500),  #MOD-A70030 mark
       g_buf     STRING,                       #MOD-A70030 add                     
       g_bookno  LIKE aah_file.aah00,          #帳別
       g_mai02   LIKE mai_file.mai02,
       g_mai03   LIKE mai_file.mai03,
       g_abe01   LIKE abe_file.abe01,
       g_tot1     ARRAY[50] OF LIKE type_file.num20_6, #No.FUN-680061 DEC(20,6)
       g_basetot1 ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
       rep_cnt    LIKE type_file.num5       #No.FUN-680061 SMALLINT
DEFINE l_basetot1  LIKE type_file.num20_6    #MOD-920149 add
DEFINE g_i         LIKE type_file.num5       #count/index for any purpose    #No.FUN-680061  SMALLINT
DEFINE g_aaa03     LIKE  aaa_file.aaa03
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680061   SMALLINT
DEFINE p_cmd       LIKE type_file.chr1       #No.FUN-680061  VARCHAR(1)
DEFINE g_msg       LIKE type_file.chr1000    #No.FUN-680061  VARCHAR(100)
DEFINE g_str       STRING                    # FUN-750025 TSD.liquor add
DEFINE l_table     STRING                    # FUN-750025 TSD.liquor add
DEFINE g_sql       STRING                    # FUN-750025 TSD.liquor add  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
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
   LET g_sql = "maj01.maj_file.maj01,maj02.maj_file.maj02,",
               "maj03.maj_file.maj03,maj04.maj_file.maj04,",
               "maj05.maj_file.maj05,maj06.maj_file.maj06,",
               "maj07.maj_file.maj07,maj08.maj_file.maj08,",
               "maj09.maj_file.maj09,maj10.maj_file.maj10,",
               "maj11.maj_file.maj11,maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,maj21.maj_file.maj21,",
               "maj22.maj_file.maj22,maj23.maj_file.maj23,",
               "maj24.maj_file.maj24,maj25.maj_file.maj25,",
               "maj26.maj_file.maj26,maj27.maj_file.maj27,",
               "maj28.maj_file.maj28,maj29.maj_file.maj29,",
               "maj30.maj_file.maj30,dept.abd_file.abd01,",
               "bal1.type_file.num20_6,basetot.type_file.num20_6,",
               "gem02.gem_file.gem02,azi04.azi_file.azi04,",
               "line.type_file.num5"
 
   LET l_table = cl_prt_temptable('abgr190',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
  #str MOD-920149 add
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET basetot=?",
               " WHERE dept=?"
   PREPARE update_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('update_prep:',status,1) EXIT PROGRAM
   END IF
  #end MOD-920149 add
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750025
 
   LET g_trace = 'N'                        #default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
LET tm.a  = ARG_VAL(9)
LET tm.b  = ARG_VAL(10)    #TQC-610054
LET tm.abe01 = ARG_VAL(11)
LET tm.yy = ARG_VAL(12)
LET tm.bm = ARG_VAL(13)
LET tm.em = ARG_VAL(14)
#LET tm.budget  = ARG_VAL(15)  #No.FUN-810069--mark
LET tm.budget = ARG_VAL(15)   #FUN-AB0020 add
LET tm.c  = ARG_VAL(16)
LET tm.d  = ARG_VAL(17)
LET tm.e  = ARG_VAL(18)
LET tm.f  = ARG_VAL(19)
LET tm.h  = ARG_VAL(20)
LET tm.o  = ARG_VAL(21)
LET tm.r  = ARG_VAL(22)   #TQC-610054
LET tm.p  = ARG_VAL(23)
LET tm.q  = ARG_VAL(24)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(25)
   LET g_rep_clas = ARG_VAL(26)
   LET g_template = ARG_VAL(27)
   LET g_rpt_name = ARG_VAL(28)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF   #No.FUN-740048
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r190_tm()                        # Input print condition
   ELSE
      CALL r190()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r190_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680061 SMALLINT
          l_sw           LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000,   #No.FUN-680061 VARCHAR(400)
          li_chk_bookno  LIKE type_file.num5       #No.FUN-680061 SMALLINT
   DEFINE li_result      LIKE type_file.num5       #No.FUN-6C0068
 
#   CALL s_dsmark(g_bookno)    #No.FUN-740048
   CALL s_dsmark(tm.b)   #No.FUN-740048
   LET p_row = 4 LET p_col = 11
   OPEN WINDOW r190_w AT p_row,p_col
        WITH FORM "abg/42f/abgr190"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)    #No.FUN-740048
   CALL  s_shwact(0,0,tm.b)   #No.FUN-740048
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL     #Default condition
   LET tm.b = g_aza.aza81      #No.TQC-760073
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno    #No.FUN-740048
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b         #No.FUN-740048
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #FUN-660105
#   CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105     #No.FUN-740048
   CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)      #No.FUN-740048
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel azi:',SQLCA.sqlcode,0) #FUN-660105
   CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) #FUN-660105 
   END IF
#   LET tm.b = g_bookno    #No.FUN-740048
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
    LET g_buf=''
    LET l_sw = 1
    LET rep_cnt=0
#    INPUT BY NAME tm.rtype,tm.a,tm.b,tm.abe01,tm.yy,tm.bm,tm.em,tm.budget,   #No.TQC-760073
#    INPUT BY NAME tm.b,tm.rtype,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,tm.budget,   #No.TQC-760073 #No.FUN-810069--mark
     INPUT BY NAME tm.b,tm.rtype,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,tm.budget,             #No.FUN-810069--add  #FUN-AB0020 add budget
                 tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                 tm.p,tm.q,tm.more WITHOUT DEFAULTS HELP 1
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL r190_set_entry(p_cmd)
            CALL r190_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_comp_required("bm",TRUE)     #No.TQC-760066
 
       AFTER FIELD rtype
             CALL r190_set_entry(p_cmd)
             CALL r190_set_no_entry(p_cmd)
       AFTER FIELD a
          IF NOT cl_null(tm.a) THEN     #No.TQC-760066
            #FUN-6C0068--begin
              CALL s_chkmai(tm.a,'RGL') RETURNING li_result
              IF NOT li_result THEN
                CALL cl_err(tm.a,g_errno,1)
                NEXT FIELD a
              END IF
            #FUN-6C0068--end
              SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                     WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                     AND mai00 = tm.b              #No.FUN-740048
              IF STATUS THEN 
#             CALL cl_err('sel mai:',STATUS,0) #FUN-660105
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
          END IF                     #No..TQC-760066
 
      AFTER FIELD b
         IF NOT cl_null(tm.b) THEN   #No.TQC-760066
            #No.FUN-660141--begin
            CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF 
            #No.FUN-660141--end
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN 
#           CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
            CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0) #FUN-660105 
            NEXT FIELD b END IF
         END IF                       #No.TQC-760066
 
      AFTER FIELD abe01
         IF NOT cl_null(tm.abe01) THEN    #No.TQC-760066
            SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
            IF STATUS=100 THEN
               LET g_abe01 =' '
               SELECT * FROM gem_file WHERE gem01=tm.abe01 AND gem05='Y'
               IF STATUS=100 THEN NEXT FIELD abe01 END IF
            END IF
            IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
         END IF     #No.TQC-760066
 
 
      AFTER FIELD yy
         IF NOT cl_null(tm.yy) THEN    #No.TQC-760066
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF
         END IF                   #No.TQC-760066
 
 
      AFTER FIELD bm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
        #IF tm.bm IS NULL THEN NEXT FIELD bm END IF       #No.TQC-760066 mark
#No.TQC-720032 -- begin --
#         IF tm.bm <1 OR tm.bm > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD bm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
#No.FUN-810069--begin--
#      AFTER FIELD budget
#         IF NOT cl_null(tm.budget) THEN    #No.TQC-760066
#            SELECT * FROM afa_file WHERE afa01=tm.budget
#                                     AND afaacti IN ('Y','y')
#                                     AND afa00 = tm.b          #No.FUN-740048
#            IF STATUS THEN 
#           CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#            CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105
#            NEXT FIELD budget END IF
#         END IF                            #No.TQC-760066
#No.FUN-810069--end--
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
            CALL r190_set_entry(p_cmd)
            CALL r190_set_no_entry(p_cmd)
 
 
      AFTER FIELD p
         IF NOT cl_null(tm.p) THEN        #No.TQC-760066
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN 
#           CALL cl_err(tm.p,'agl-109',0) #FUN-660105
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0) #FUN-660105
            NEXT FIELD p END IF
         END IF                           #No.TQC-760066
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.yy IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy ATTRIBUTE(REVERSE)
            CALL cl_err('',9033,0)
        END IF
         IF tm.bm IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.bm ATTRIBUTE(REVERSE)
        END IF
         IF tm.em IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.em ATTRIBUTE(REVERSE)
        END IF
        IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
                #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740048   #No.TQC-C50042   Mark
                 LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                 CALL cl_create_qry() RETURNING tm.a
                 DISPLAY tm.a TO a
                 NEXT FIELD a
           WHEN INFIELD(b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = tm.b
                 CALL cl_create_qry() RETURNING tm.b
                 DISPLAY tm.b TO b
                 NEXT FIELD b
           WHEN INFIELD(p)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = tm.p
                 CALL cl_create_qry() RETURNING tm.p
                 DISPLAY tm.p TO p
                 NEXT FIELD p
#No.FUN-810069--begin--
#         WHEN INFIELD(budget)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_afa"
#                 LET g_qryparam.default1 = tm.budget
#                 LET g_qryparam.arg1 = tm.b               #No.FUN-740048
#                 CALL cl_create_qry() RETURNING tm.budget
#                 DISPLAY tm.budget TO budget
#            NEXT FIELD budget
#No.FUN-810069--end--
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

           #CHI-A40062 add --start--
           WHEN INFIELD(abe01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_abe'
              LET g_qryparam.default1 = tm.abe01
              CALL cl_create_qry() RETURNING tm.abe01
              DISPLAY BY NAME tm.abe01
              NEXT FIELD abe01
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
      LET INT_FLAG = 0 CLOSE WINDOW r190_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr190'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr190','9031',1)
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
                         " '",tm.b CLIPPED,"'",   #TQC-610054
                         " '",tm.abe01 CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.bm CLIPPED,"'",
                      " '",tm.em CLIPPED,"'",
#                     " '",tm.budget CLIPPED,"'",           #No.FUN-810069--mark
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
         CALL cl_cmdat('abgr190',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r190_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r190()
   ERROR ""
END WHILE
   CLOSE WINDOW r190_w
END FUNCTION
 
FUNCTION r190()
   DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT    #No.FUN-680061  VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680061  VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(40)
   DEFINE l_tmp     LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_leng    LIKE type_file.num5     #No.FUN-680061  SMALLINT
   DEFINE l_abe03   LIKE abe_file.abe03  
   DEFINE m_abd02   LIKE abd_file.abd02
 
   # add FUN-750025
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.liquor *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ----------------------------------#
   # end FUN-750025
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE LET g_msg=" 1= 1 "
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
   PREPARE r190_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM 
   END IF
   DECLARE r190_c CURSOR FOR r190_p
 
   LET g_mm = tm.em
   FOR g_i = 1 TO 50 LET g_tot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_basetot1[g_i] = 0 END FOR
 
#  CALL cl_outnam('abgr190') RETURNING l_name           #No.FUN-880052 MARK
#---------------------------------------------------
   IF g_abe01=' ' THEN                     #--- 部門
      DECLARE r190_curs10 CURSOR FOR
       SELECT abd02,gem05 FROM abd_file,gem_file WHERE abd01=tm.abe01
                                                   AND gem01=abd02
        ORDER BY abd02
      FOREACH r190_curs10 INTO m_abd02,l_chr
          IF SQLCA.SQLCODE THEN
             EXIT FOREACH
          END IF
          CALL r190_bom(m_abd02,l_chr)
      END FOREACH
      IF g_buf IS NULL THEN LET g_buf="'",tm.abe01 CLIPPED,"'," END IF
      LET l_leng=LENGTH(g_buf)
     #LET g_buf=g_buf[1,l_leng-1] CLIPPED               #MOD-A70030 mark
      LET g_buf=g_buf.subString(1,l_leng-1) CLIPPED     #MOD-A70030 add
      CALL r190_process(tm.abe01)
   ELSE                                    #--- 族群
      DECLARE r190_bom CURSOR FOR
       SELECT abe03,gem05 FROM abe_file,gem_file WHERE abe01=tm.abe01
                                                   AND gem01=abe03
        ORDER BY abe03
      FOREACH r190_bom INTO l_abe03,l_chr
          IF SQLCA.SQLCODE THEN
             EXIT FOREACH
          END IF
          CALL r190_bom(l_abe03,l_chr)
          IF g_buf IS NULL THEN LET g_buf="'",l_abe03 CLIPPED,"'," END IF
          LET l_leng=LENGTH(g_buf)
         #LET g_buf=g_buf[1,l_leng-1] CLIPPED               #MOD-A70030 mark
          LET g_buf=g_buf.subString(1,l_leng-1) CLIPPED     #MOD-A70030 add
          CALL r190_process(l_abe03)
          LET g_buf=''
      END FOREACH
   END IF
 
   LET rep_cnt=0
#---------------------------------------------------
   # FUN-750025 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = g_str,";",tm.a,";",tm.d,";",tm.yy,";",tm.bm,";",tm.em,";",tm.h,";",tm.p
 
   CALL cl_prt_cs3('abgr190','abgr190',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   # FUN-750025 end
END FUNCTION
 
FUNCTION r190_process(l_dept)
   DEFINE l_dept   LIKE abd_file.abd01       #No.FUN-680061  VARCHAR(6)
   DEFINE l_sql    LIKE type_file.chr1000    #No.FUN-680061  VARCHAR(600)
   DEFINE amt1     LIKE type_file.num20_6    #No.FUN-680061  DEC(20,6)
   DEFINE maj      RECORD LIKE maj_file.*
   DEFINE l_gem02  LIKE gem_file.gem02       #TSD.liquor add
   DEFINE sr  RECORD
              dept    LIKE abd_file.abd01,   #No.FUN-680061  VARCHAR(6)
              bal1    LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6)
              END RECORD
 
   IF l_dept IS NULL THEN
      RETURN
   END IF
   LET rep_cnt=rep_cnt+1
### 98/03/04 by connie modify where conditions
   #----------- sql for sum(afc06)----------------------------------------
   LET l_sql = "SELECT SUM(afc06) FROM afc_file,afb_file",
               " WHERE afb00 = afc00  AND afb01 = afc01 ",
               "   AND afb02 = afc02  AND afb03 = afc03 ",
               "   AND afb04 = afc04  ",
#              "   AND afc01 = '",tm.budget,"'",          #No.FUN-810069--mark
              #"   AND afc01='' ",                        #No.FUN-810069--add    #MOD-A20042 mark
               "   AND afb041=afc041 ",                   #No.FUN-810069--add
               "   AND afb042=afc042 ",                   #No.FUN-810069--add 
               "   AND afc02 BETWEEN ? AND ? ",
               "   AND afc041 IN (",g_buf CLIPPED,")",     #---- g_buf 部門族群  #MOD-A20042 afc04 modify afc041
               "   AND afc03 = '",tm.yy,"'",
               "   AND afc05 BETWEEN '",tm.bm,"' AND '",g_mm,"'",
               "   AND afc00= '",tm.b,"'" 
              #"   AND afb15 = '2' "            #部門預算   #CHI-A20007 mark
              ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
   IF NOT cl_null(tm.budget) THEN LET l_sql = l_sql," AND afc01 = '",tm.budget,"'" END IF #FUN-AB0020 add
   PREPARE r190_sum FROM l_sql
   DECLARE r190_sumc CURSOR FOR r190_sum
   #-----------------------------------------------------------------------
   FOREACH r190_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0
      IF NOT cl_null(maj.maj21) THEN
         OPEN r190_sumc USING maj.maj21,maj.maj22
         FETCH r190_sumc INTO amt1
         IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
         IF amt1 IS NULL THEN LET amt1 = 0 END IF
         IF g_trace='Y' THEN
            DISPLAY 'F2:',maj.maj02,' ',maj.maj21,' TT:',amt1
         END IF
      END IF

      #CHI-A30009 add start---
      IF maj.maj09='-' THEN
        # LET amt1_1 = amt1_1 * -1
         LET amt1 = amt1 * -1
      END IF
      #CHI-A30009 add end-----

      IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF      #匯率的轉換
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
         FOR i = 1 TO 50 LET g_tot1[i]=g_tot1[i]+amt1 END FOR
         LET k=maj.maj08  LET sr.bal1=g_tot1[k]
         FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
      ELSE
         IF maj.maj03='5' THEN
             LET sr.bal1=amt1
         ELSE
             LET sr.bal1=NULL
         END IF
      END IF
      IF maj.maj11 = 'Y' THEN			# 百分比基準科目
         LET g_basetot1[rep_cnt]=sr.bal1
         IF g_basetot1[rep_cnt] = 0 THEN LET g_basetot1[rep_cnt] = NULL END IF
         IF maj.maj07='2' THEN LET g_basetot1[rep_cnt]=g_basetot1[rep_cnt]*-1 END IF
        #str MOD-920149 add
         LET l_basetot1=sr.bal1
         IF l_basetot1=0 THEN LET l_basetot1=NULL END IF
         IF maj.maj07='2' THEN LET l_basetot1=l_basetot1*-1 END IF
        #end MOD-920149 add
      END IF
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
      IF (tm.c='N' OR maj.maj03='2') AND
          maj.maj03 MATCHES "[0125]" AND sr.bal1=0 THEN          #CHI-CC0023 add maj03 match 5
         CONTINUE FOREACH				#餘額為 0 者不列印
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH				#最小階數起列印
      END IF
      LET sr.dept=l_dept                               #部門 code 區別用
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.dept AND gem05='Y'

      IF sr.bal1<0 THEN LET sr.bal1=sr.bal1*-1 END IF #CHI-A30009 add

      IF maj.maj04 = 0 THEN
        EXECUTE insert_prep USING maj.*,sr.*,
                                  g_basetot1[rep_cnt],l_gem02,g_azi04,'2'
      ELSE
        EXECUTE insert_prep USING maj.*,sr.*,
                                  g_basetot1[rep_cnt],l_gem02,g_azi04,'2'
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
        FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING maj.*,sr.*,
                                      g_basetot1[rep_cnt],l_gem02,g_azi04,'1'
        END FOR
      END IF
      #------------------------------ CR (3) ------------------------------#
      #FUN-750025 TSD.liquor end
   END FOREACH
  #str MOD-920149 add
   EXECUTE update_prep USING l_basetot1,sr.dept
  #end MOD-920149 add
END FUNCTION
 
 
FUNCTION r190_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01         #No.FUN-680061 VARCHAR(6)
    DEFINE l_sw     LIKE type_file.chr1         #No.FUN-680061 VARCHAR(1)
    DEFINE l_abd02  LIKE abd_file.abd02         #No.FUN-680061 VARCHAR(6)
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5    #No.FUN-680061 SMALLINT
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
           CALL r190_bom(l_arr[l_cnt2].*)
        END IF
    END FOR
    IF l_sw = 'Y' THEN
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
FUNCTION r190_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680061  VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bm,p,q",TRUE)
#   END IF
 
END FUNCTION
 
FUNCTION r190_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680061  VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       IF tm.rtype='1' THEN
           LET tm.bm = 0 DISPLAY '' TO bm
           CALL cl_set_comp_entry("bm",FALSE)
       END IF
       IF tm.o = 'N' THEN
           CALL cl_set_comp_entry("p,q",FALSE)
       END IF
#   END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
