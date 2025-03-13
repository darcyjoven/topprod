# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr100.4gl
# Descriptions...: 多部門預算財務報表
# Date & Author..: 03/03/14 By Kammy (copy from aglr100)
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/16 By 報表結構判斷使用者權限及部門權限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740029 07/04/11 By johnray 會計科目加帳套
# Modify.........: NO.FUN-750025 07/07/25 BY TSD.liquor 改為crystal report
# Modify.........: No.TQC-760073 07/11/12 By johnray 調整欄位輸入順序
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-A40162 10/04/28 By sabrina 預算編號改由理由碼維護
# Modify.........: No:MOD-A70030 10/07/05 By sabrina 將g_buf型態改為string
# Modify.........: No:CHI-A20007 10/10/27 By sabrina r100_sum和r100_sum1的sql條件有誤  
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              a       LIKE maj_file.maj01,  #報表結構編號              #NO.FUN-680061 VARCHAR(6),
              b       LIKE aaa_file.aaa01,  #帳別編號  #No.FUN-670039  
              abe01   LIKE abe_file.abe01,  #列印族群/部門層級/部門    #NO.FUN-680061 VARCHAR(06),
              yy      LIKE type_file.num5,  #輸入年度                  #NO.FUN-680061 SMALLINT,
              bm      LIKE aah_file.aah03,  #Begin 期別                #NO.FUN-680061 SMALLINT,
              em      LIKE aah_file.aah03,  # End  期別                #NO.FUN-680061 SMALLINT,
              budget  LIKE afa_file.afa01,  #預算編號                  #NO.FUN-680061 VARCHAR(4),
              c       LIKE type_file.chr1,  #異動額及餘額為0者是否列印 #NO.FUN-680061 VARCHAR(1),
              d       LIKE type_file.chr1,  #金額單位                  #NO.FUN-680061 VARCHAR(1),
              f       LIKE type_file.num5,  #列印最小階數              #NO.FUN-680061 SMALLINT,
              more    LIKE type_file.chr1  #Input more condition(Y/N)  #NO.FUN-680061 VARCHAR(1)
              END RECORD,
          i,j,k,g_mm LIKE type_file.num5,   #NO.FUN-680061 SMALLINT,
          g_unit     LIKE type_file.num5,   #金額單位基數 #NO.FUN-680061 INTEGER,
         #g_buf      LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(600),  #MOD-A70030 mark
          g_buf      STRING,                #MOD-A70030 add                     
          g_cn       LIKE type_file.num5,   #NO.FUN-680061 SMALLINT,
          g_flag     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01),
          g_bookno   LIKE aah_file.aah00,   #帳別
          g_gem05    LIKE gem_file.gem05,
          m_dept     LIKE type_file.chr1000,#NO.FUN-680061   VARCHAR(300),
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_abd01    LIKE abd_file.abd01,
          g_abe01    LIKE abe_file.abe01,
          g_total    ARRAY[300] OF RECORD
               maj02 LIKE maj_file.maj02,
               amt   LIKE type_file.num20_6 #NO.FUN-680061   DEC(20,6)
                     END RECORD,     
          g_tot1     ARRAY[100] OF LIKE type_file.num20_6, #NO.FUN-680061 ARRAY[100] OF DEC(20,6),
          g_no       LIKE type_file.num5,                  #NO.FUN-680061 SMALLINT,
       g_dept     ARRAY[300] OF RECORD
		     gem01 LIKE gem_file.gem01, #部門編號
		     gem05 LIKE gem_file.gem05  #是否為會計部門
		     END RECORD
DEFINE   g_i         LIKE type_file.num5        #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_aaa03     LIKE aaa_file.aaa03
DEFINE   g_str       STRING          # FUN-750025 TSD.liquor add
DEFINE   l_table     STRING          # FUN-750025 TSD.liquor add
DEFINE   g_sql       STRING          # FUN-750025 TSD.liquor add  
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
   LET g_sql = "maj02.maj_file.maj02,",
               "maj03.maj_file.maj03,",
               "maj04.maj_file.maj04,",
               "maj05.maj_file.maj05,",
               "maj07.maj_file.maj07,",
               "maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,",
               "str.type_file.chr1000,",
               "m_dept.type_file.chr1000,",
               "line.type_file.num5,",
               "sn.type_file.num5"
 
   LET l_table = cl_prt_temptable('abgr100',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750025
 
      LET g_trace = 'N'                        #default trace off
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)   #TQC-610054
LET tm.abe01= ARG_VAL(10)
LET tm.yy   = ARG_VAL(11)
LET tm.bm   = ARG_VAL(12)
LET tm.em   = ARG_VAL(13)
   LET tm.budget = ARG_VAL(14)   
LET tm.c    = ARG_VAL(15)
LET tm.d    = ARG_VAL(16)
LET tm.f    = ARG_VAL(17)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   DROP TABLE r100_file
# Thomas 98/11/17
#No.FUN-680061-------------start-------
    CREATE TEMP TABLE r100_file(
       no        LIKE type_file.num5,  
       maj02     LIKE maj_file.maj02,
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,
       maj21     LIKE maj_file.maj21,
       maj22     LIKE maj_file.maj22,
       bal1      LIKE type_file.num20_6) #實際 
#No.FUN-680061-----------end-------------     
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF   #No.FUN-740029
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r100_tm()                        # Input print condition
   ELSE
      CALL r100()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r100_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
          l_sw          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01),
          l_cmd         LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(400)
          li_chk_bookno LIKE type_file.num5    #No.FUN-680061 SMALLINT
   DEFINE li_result     LIKE type_file.num5    #NO.FUN-6C0068
       
#   CALL s_dsmark(g_bookno)   #No.FUN-740029
   CALL s_dsmark(tm.b)   #No.FUN-740029
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "abg/42f/abgr100"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)   #No.FUN-740029
   CALL s_shwact(0,0,tm.b)   #No.FUN-740029
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL                  #Default condition
   LET tm.b = g_aza.aza81   #No.TQC-760073
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740029
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b   #No.FUN-740029
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #FUN-660105
#   CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105    #No.FUN-740029
   CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)      #No.FUN-740029
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
#   LET tm.b = g_bookno   #No.FUN-740029
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
 
# INPUT BY NAME tm.a,tm.b,tm.abe01,tm.yy,tm.bm,tm.em,tm.budget,
     INPUT BY NAME tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,tm.budget,  #TSD.liquor modify
                  tm.f,tm.d,tm.c,tm.more
		  WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
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
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            AND mai00 = tm.b    #No.FUN-740029
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
 
      AFTER FIELD b
      #No.FUN-660141--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-660141--end
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN 
#        CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
         CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0) #FUN-660105
         NEXT FIELD b END IF
 
      AFTER FIELD abe01
         SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
         IF STATUS=100 THEN
           LET g_abe01 =' '
           SELECT UNIQUE abd01 INTO g_abd01 FROM abd_file WHERE abd01=tm.abe01
           IF STATUS=100 THEN
             LET g_abd01=' '
             SELECT gem05 INTO g_gem05 FROM gem_file WHERE gem01=tm.abe01
             IF STATUS THEN NEXT FIELD abe01 END IF
           END IF
         ELSE
           IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
         END IF
 
      AFTER FIELD yy
         IF tm.yy = 0 THEN NEXT FIELD yy END IF
 
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
         IF tm.bm <1 OR tm.bm > 13 THEN
            CALL cl_err('','agl-013',0) NEXT FIELD bm
         END IF
 
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
#        IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
      AFTER FIELD budget
         SELECT * FROM afa_file WHERE afa01=tm.budget AND afaacti IN ('Y','y')
            AND afa00 = tm.b    #No.FUN-740029
        #MOD-A40162---modify---start---
        #SELECT * FROM afa_file WHERE afa01=tm.budget AND afaacti IN ('Y','y')
        #   AND afa00 = tm.b    #No.FUN-740029
         SELECT * FROM azf_file 
          WHERE azf01 = tm.budget AND azf02 = '2'
        #MOD-A40162---modify---end---
        IF STATUS THEN 
#       CALL cl_err('sel afa:',STATUS,0) #FUN-660105
        CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105
        NEXT FIELD budget END IF
 
      AFTER FIELD f
         IF tm.f < 0  THEN
            LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.yy) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy ATTRIBUTE(REVERSE)
            CALL cl_err('',9033,0)
         END IF
         IF cl_null(tm.bm) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.bm ATTRIBUTE(REVERSE)
         END IF
         IF cl_null(tm.em) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.em ATTRIBUTE(REVERSE)
        END IF
        IF tm.d = '1' THEN LET g_unit = 1       END IF
        IF tm.d = '2' THEN LET g_unit = 1000    END IF
        IF tm.d = '3' THEN LET g_unit = 1000000 END IF
        IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
 
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
           WHEN INFIELD(b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = tm.b
                 CALL cl_create_qry() RETURNING tm.b
                 DISPLAY tm.b TO b
            NEXT FIELD b
         WHEN INFIELD(budget)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_afa"    #MOD-A40162 mark 
                 LET g_qryparam.form ="q_azf"    #MOD-A40162 add 
                 LET g_qryparam.default1 = tm.budget
                #LET g_qryparam.arg1 = tm.b            #No.FUN-740029 #MOD-A40162 mark
                 LET g_qryparam.arg1 = '2'             #MOD-A40162add 
                 CALL cl_create_qry() RETURNING tm.budget
                 DISPLAY tm.budget TO budget
            NEXT FIELD budget
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
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr100','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
#                         " '",g_bookno CLIPPED,"'" ,   #No.FUN-740029
                         " '",tm.b CLIPPED,"'" ,   #No.FUN-740029
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-610054
                         " '",tm.abe01 CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.bm CLIPPED,"'",
                      " '",tm.em CLIPPED,"'",
                         " '",tm.budget CLIPPED,"'",   #TQC-610054
                      " '",tm.c CLIPPED,"'",
                      " '",tm.d CLIPPED,"'",
                      " '",tm.f CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r100()
   DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061 VARCHAR(20)
   DEFINE l_name1   LIKE type_file.chr20    #No.FUN-680061 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT #No.FUN-680061   VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(40)
   DEFINE l_tmp     LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE l_leng,l_leng2 LIKE type_file.num5   #No.FUN-680061 SMALLINT
   DEFINE l_abe03   LIKE abe_file.abe03     
   DEFINE l_abd02   LIKE abd_file.abd02    
   DEFINE l_gem02   LIKE gem_file.gem02  
   DEFINE l_dept    LIKE gem_file.gem01     
   DEFINE l_maj20   LIKE maj_file.maj20,    #No.FUN-680061 VARCHAR(30),
          l_bal     LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE sr  RECORD 
              no        LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
              maj02     LIKE maj_file.maj02,   #No.FUN-680061 DEC(9,2),
              maj03     LIKE maj_file.maj03,   #No.FUN-680061 VARCHAR(01),
              maj04     LIKE maj_file.maj04,   #No.FUN-680061 SMALLINT,
              maj05     LIKE maj_file.maj05,   #No.FUN-680061 SMALLINT,
              maj07     LIKE maj_file.maj07,   #No.FUN-680061 VARCHAR(01),
              maj20     LIKE maj_file.maj20,   #No.FUN-680061 VARCHAR(30),
              maj20e    LIKE maj_file.maj20e,  #No.FUN-680061 VARCHAR(30),
              maj21     LIKE maj_file.maj21,   #No.FUN-680061 VARCHAR(24),
              maj22     LIKE maj_file.maj22,   #No.FUN-680061 VARCHAR(24),
              bal1      LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6)
              END RECORD
    DEFINE sr1 RECORD
              maj02     LIKE maj_file.maj02,   #No.FUN-680061 DEC(9,2),
              maj03     LIKE maj_file.maj03,   #No.FUN-680061 VARCHAR(01),
              maj04     LIKE maj_file.maj04,   #No.FUN-680061 SMALLINT,
              maj05     LIKE maj_file.maj05,   #No.FUN-680061 SMALLINT,
              maj07     LIKE maj_file.maj07,   #No.FUN-680061 VARCHAR(01)
              maj20     LIKE maj_file.maj20,   #No.FUN-680061 VARCHAR(30),
              maj20e    LIKE maj_file.maj20e   #No.FUN-680061 VARCHAR(30)
              END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5   LIKE type_file.chr20  #No.FUN-680061 VARCHAR(20)
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10  LIKE type_file.chr20  #No.FUN-680061 VARCHAR(20)
   DEFINE l_str,l_totstr LIKE type_file.chr1000#No.FUN-680061 VARCHAR(300)
   DEFINE m_abd02        LIKE abd_file.abd02                                      
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5   #No.FUN-680061  SMALLINT
   DEFINE l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000   #No.FUN-680061   VARCHAR(400)
   DEFINE l_amt      LIKE type_file.num20_6    #No.FUN-680061 DEC(20,6)
   DEFINE l_gem02_o  LIKE gem_file.gem02
   DEFINE l_zero1    LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(01),
          l_zero2    LIKE type_file.chr1       #No.FUN-680061 VARCHAR(01)
   
   # add FUN-750025
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.liquor *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ----------------------------------#
   # end FUN-750025
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abgr100'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 170 END IF
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"' AND maj23[1,1]='2' ",
               " ORDER BY maj02"
   IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
   PREPARE r100_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM 
   END IF
   DECLARE r100_c CURSOR FOR r100_p
 
   LET g_mm = tm.em
   LET l_i = 1
   FOR l_i = 1 TO 300
       LET g_total[l_i].maj02 = NULL
       LET g_total[l_i].amt = 0
   END FOR
   LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   LET g_no = 1 FOR g_no = 1 TO 300 INITIALIZE g_dept[g_no].* TO NULL END FOR
   CALL cl_outnam('abgr100') RETURNING l_name
 
#將部門填入array------------------------------------
   LET g_buf = ''
   IF g_abe01 = ' ' THEN
     IF g_abd01 = ' ' THEN                   #--- 部門
       LET g_no = 1
       LET g_dept[g_no].gem01 = tm.abe01
       LET g_dept[g_no].gem05 = g_gem05
     ELSE                                    #--- 部門層級
       LET g_no=0
       DECLARE r192_bom1 CURSOR FOR
         SELECT abd02,gem05 FROM abd_file,gem_file WHERE abd01=tm.abe01
                                                     AND gem01=abd02
           ORDER BY abd02
       FOREACH r192_bom1 INTO l_abd02,l_chr
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         LET g_no = g_no + 1
         LET g_dept[g_no].gem01 = l_abd02
         LET g_dept[g_no].gem05 = l_chr
       END FOREACH
     END IF
 
   ELSE                                      #--- 族群
      LET g_no = 0
      DECLARE r192_bom2 CURSOR FOR
        SELECT abe03,gem05 FROM abe_file,gem_file WHERE abe01=tm.abe01
                                                   AND gem01=abe03
        ORDER BY abe03
      FOREACH r192_bom2 INTO l_abe03,l_chr
          IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
          LET g_no = g_no + 1
          LET g_dept[g_no].gem01 = l_abe03
          LET g_dept[g_no].gem05 = l_chr
      END FOREACH
   END IF
#---------------------------------------------------
#控制一次印十個部門---------------------------------
   LET l_cnt=(10-(g_no MOD 10))+g_no     ###一行 10 個
   LET l_i = 0
   FOR l_i = 10 TO l_cnt STEP 10
       LET g_flag = 'n'
       LET l_name1='r100_',l_i/10 USING '&&&','.out'
       LET g_cn = 0
       LET g_pageno = 0
       DELETE FROM r100_file
       LET m_dept = ''
       IF l_i <= g_no THEN
          LET l_no = l_i - 10
          FOR l_cn = 1 TO 10
              LET g_i = 1
	      FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
              LET g_buf = ''
              LET l_dept = g_dept[l_no+l_cn].gem01
              LET l_chr  = g_dept[l_no+l_cn].gem05
              LET l_gem02 = ''
              SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
              LET l_leng2 = LENGTH(l_gem02_o)
              LET l_leng2 = 11 - l_leng2
              IF l_cn = 1 THEN
                 LET m_dept = l_gem02
              ELSE
                 LET m_dept = m_dept CLIPPED,l_leng2 SPACES,3 SPACES,l_gem02
              END IF
              CALL r100_bom(l_dept,l_chr)
              IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
              LET l_leng=LENGTH(g_buf)
             #LET g_buf=g_buf[1,l_leng-1] CLIPPED               #MOD-A70030 mark
              LET g_buf=g_buf.subString(1,l_leng-1) CLIPPED     #MOD-A70030 add
              CALL r100_process(l_cn)
              LET g_cn = l_cn
	      LET l_gem02_o = l_gem02
          END FOR
       ELSE
          LET l_no = (l_i - 10)
          FOR l_cn = 1 TO (g_no - (l_i - 10))
              LET g_i = 1
              FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
              LET g_buf = ''
              LET l_dept = g_dept[l_no+l_cn].gem01
              LET l_chr  = g_dept[l_no+l_cn].gem05
              LET l_gem02 = ''
              SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
              LET l_leng2 = LENGTH(l_gem02_o)
              LET l_leng2 = 11 - l_leng2
              IF l_cn = 1 THEN
                 LET m_dept = l_gem02
              ELSE
                 LET m_dept = m_dept CLIPPED,l_leng2 SPACES,3 SPACES,l_gem02
              END IF
              CALL r100_bom(l_dept,l_chr)
              IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
              LET l_leng=LENGTH(g_buf)
             #LET g_buf=g_buf[1,l_leng-1] CLIPPED               #MOD-A70030 mark
              LET g_buf=g_buf.subString(1,l_leng-1) CLIPPED     #MOD-A70030 add
              CALL r100_process(l_cn)
              LET g_cn = l_cn
	      LET l_gem02_o = l_gem02
          END FOR
          LET l_leng2 = LENGTH(l_gem02)
          LET l_leng2 = 11 - l_leng2
          LET m_dept = m_dept CLIPPED,l_leng2 SPACES,3 SPACES,'合  計'
	  LET g_flag = 'y'
       END IF
   #add NO:4404--
   IF l_i > g_no AND (g_no MOD 10) = 0  THEN
      FOR i = 1 TO 300
          IF g_total[i].maj02 IS NOT NULL THEN
             SELECT maj02,maj03,maj04,maj05,maj07,maj20,maj20e
               INTO sr1.*
               FROM maj_file
              WHERE maj01 = tm.a
                AND maj02 = g_total[i].maj02
                IF sr1.maj03 = '%' THEN
                    LET l_totstr = g_total[i].amt USING '--------&.&&',' %'
                ELSE
                    LET l_totstr = g_total[i].amt USING '--,---,---,--&'
                END IF
                LET l_str = l_totstr CLIPPED
             #表頭不應該列印金額
              IF sr1.maj03 = 'H' THEN
                  LET l_str = NULL
               END IF
             #add by chien 02/01/14
              IF (tm.c='N' OR sr1.maj03='2') AND sr1.maj03 MATCHES "[0125]"  AND g_total[i].amt = 0 THEN
                  CONTINUE FOR
             END IF
             
            ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
            IF sr1.maj04 = 0 THEN
              EXECUTE insert_prep USING sr1.*,l_str,m_dept,'2',l_i
            ELSE
              EXECUTE insert_prep USING sr1.*,l_str,m_dept,'2',l_i
              #空行的部份,以寫入同樣的maj20資料列進Temptable,
              #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
              #讓空行的這筆資料排在正常的資料前面印出
              FOR i = 1 TO sr1.maj04
                  EXECUTE insert_prep USING sr1.*,l_str,m_dept,'1',l_i
              END FOR
            END IF
            #------------------------------ CR (3) ------------------------------#
            #FUN-750025 TSD.liquor end
          END IF
      END FOR
   #end add--
   ELSE
       CALL r100_total()
       DECLARE tmp_curs CURSOR FOR
          SELECT * FROM r100_file ORDER BY maj02,no
       IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
       LET l_j = 1
       FOREACH tmp_curs INTO sr.*
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
	 IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
         IF tm.d MATCHES '[23]' THEN             #換算金額單位
            IF g_unit!=0 THEN
               LET sr.bal1 = sr.bal1 / g_unit    #實際
            ELSE
               LET sr.bal1 = 0
            END IF
         END IF
         # Modify -- 98/12/10 By Iris
         IF sr.maj03 = '%' THEN   # 顯示百分比 Thomas 98/11/17
	    CASE sr.no
	         WHEN 1  LET l_str1  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 2  LET l_str2  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 3  LET l_str3  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 4  LET l_str4  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 5  LET l_str5  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 6  LET l_str6  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 7  LET l_str7  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 8  LET l_str8  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 9  LET l_str9  = sr.bal1 USING '--------&.&&',' %'
	         WHEN 10 LET l_str10 = sr.bal1 USING '--------&.&&',' %'
            END CASE
         ELSE
	    CASE sr.no
	         WHEN 1  LET l_str1  = sr.bal1 USING '--,---,---,--&'
	         WHEN 2  LET l_str2  = sr.bal1 USING '--,---,---,--&'
	         WHEN 3  LET l_str3  = sr.bal1 USING '--,---,---,--&'
	         WHEN 4  LET l_str4  = sr.bal1 USING '--,---,---,--&'
	         WHEN 5  LET l_str5  = sr.bal1 USING '--,---,---,--&'
	         WHEN 6  LET l_str6  = sr.bal1 USING '--,---,---,--&'
	         WHEN 7  LET l_str7  = sr.bal1 USING '--,---,---,--&'
	         WHEN 8  LET l_str8  = sr.bal1 USING '--,---,---,--&'
	         WHEN 9  LET l_str9  = sr.bal1 USING '--,---,---,--&'
	         WHEN 10 LET l_str10 = sr.bal1 USING '--,---,---,--&'
             END CASE
         END IF
         IF sr.no = g_cn THEN
            #NO:4404
            LET l_zero1 = 'N'
            LET l_zero2 = 'N'
            IF (tm.c='N' OR sr.maj03='2') AND sr.maj03 MATCHES "[0125]" AND
               (l_str1[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str2[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str3[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str4[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str5[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str6[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str7[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str8[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str9[1,14]='        0' OR cl_null(l_str1[1,14])) AND
               (l_str10[1,14]='       0' OR cl_null(l_str1[1,14])) THEN
                LET l_zero1 = 'Y'             #餘額為 0 者不列印
            END IF
 
            LET l_str = l_str1 CLIPPED,l_str2 CLIPPED,l_str3 CLIPPED,
                        l_str4 CLIPPED,l_str5 CLIPPED,l_str6 CLIPPED,
                        l_str7 CLIPPED,l_str8 CLIPPED,l_str9 CLIPPED,
                        l_str10 CLIPPED
            LET l_str1 = '' LET l_str2 = '' LET l_str3 = ''
            LET l_str4 = '' LET l_str5 = '' LET l_str6 = ''
            LET l_str7 = '' LET l_str8 = '' LET l_str9 = ''
            LET l_str10= ''
            IF g_flag = 'y' THEN
               IF sr.maj03 = '%' THEN
	          LET l_totstr = g_total[l_j].amt USING '--------&.&&',' %'
               ELSE
                  LET l_totstr = g_total[l_j].amt USING '--,---,---,--&'
               END IF
               IF (tm.c='N' OR sr.maj03='2') AND sr.maj03 MATCHES "[0125]"  AND g_total[l_j].amt = 0 THEN
                  LET l_zero2 = 'Y'
               END IF
               LET l_str = l_str CLIPPED,l_totstr CLIPPED
               LET l_j = l_j + 1
               IF l_j > 300 THEN
		  CALL cl_err('l_j > 300',STATUS,1) EXIT FOREACH
               END IF
            END IF
            #NO:4404
            #表頭不應該列印金額
            IF sr.maj03 = 'H' THEN
               LET l_str =NULL
            END IF
            IF l_zero1 = 'Y' AND (g_flag = 'n' OR
               (g_flag = 'y' AND l_zero2 = 'Y')) THEN
               CONTINUE FOREACH
            END IF
            ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
            IF sr.maj04 = 0 THEN
              EXECUTE insert_prep USING 
                 sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                 sr.maj07,sr.maj20,sr.maj20e,l_str,m_dept,'2',l_i
            ELSE
              EXECUTE insert_prep USING 
                 sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                 sr.maj07,sr.maj20,sr.maj20e,l_str,m_dept,'2',l_i
              #空行的部份,以寫入同樣的maj20資料列進Temptable,
              #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
              #讓空行的這筆資料排在正常的資料前面印出
              FOR i = 1 TO sr.maj04
                  EXECUTE insert_prep USING 
                    sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                    sr.maj07,sr.maj20,sr.maj20e,l_str,m_dept,'1',l_i
              END FOR
            END IF
            #------------------------------ CR (3) ------------------------------#
            #FUN-750025 TSD.liquor end
         END IF
         # Iris
    END FOREACH
    CLOSE tmp_curs
 END IF
 
#   LET l_cmd2="chmod 777 ",l_name1                     #No.FUN-9C0009
#   RUN l_cmd2                                          #No.FUN-9C0009 
    IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo 
###結合報表
       IF l_i/10 = 1 THEN
          LET l_cmd1='cat ',l_name1
       ELSE
          LET l_cmd1=l_cmd1 CLIPPED,' ',l_name1
       END IF
   END FOR
   LET l_cmd1=l_cmd1 CLIPPED,' > ',l_name
   RUN l_cmd1
#---------------------------------------------------
 
   # FUN-750025 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = g_str,";",tm.a,";",tm.d,";",tm.yy,";",tm.bm,";",tm.em
 
   CALL cl_prt_cs3('abgr100','abgr100',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   # FUN-750025 end
END FUNCTION
 
FUNCTION r100_process(l_cn)
   DEFINE l_sql,l_sql1   LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(1000)
   DEFINE l_cn           LIKE type_file.num5     #No.FUN-680061 SMALLINT
   DEFINE l_temp         LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE l_sun          LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE l_mon          LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE l_amt1,amt1,amt2,amt  LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6)
   DEFINE maj            RECORD LIKE maj_file.*  
   DEFINE m_bal1,m_bal2  LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE l_amt          LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
   DEFINE m_per1,m_per2  LIKE con_file.con06     #No.FUN-680061 DEC(9,5)
   DEFINE l_mm           LIKE type_file.num5     #No.FUN-680061 SMALLINT
 
    #----------- sql for sum(afc06)-----------------------------------
    LET l_sql = "SELECT SUM(afc06) FROM afc_file,afb_file",
                " WHERE afb00 = afc00  AND afb01 = afc01 ",
                "   AND afb02 = afc02  AND afb03 = afc03 ",
                "   AND afb04 = afc04  ",
                "   AND afb041 = afc041  ",                    #CHI-A20007 add
                "   AND afb042 = afc042 ",                     #CHI-A20007 add
               #"   AND afb15 = '2' " ,          #部門預算     #CHI-A20007 mark
                "   AND afc01 = '",tm.budget,"'",
                "   AND afc00 = ? ",
                "   AND afc02 BETWEEN ? AND ? ",
                "   AND afc03 = ? ",
                "   AND afc05 BETWEEN ? AND ? ",
               #"   AND afc04 IN (",g_buf CLIPPED,")"      #---- g_buf 部門族群      #CHI-A20007 mark
                "   AND afc041 IN (",g_buf CLIPPED,")"      #---- g_buf 部門族群     #CHI-A20007 add
               ,"   AND afbacti = 'Y' "                    #FUN-D70090 add
    PREPARE r100_sum FROM l_sql
    DECLARE r100_sumc CURSOR FOR r100_sum
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM 
    END IF
 
    #----------- sql for sum(afc06)-----------------------------------
    LET l_sql = "SELECT SUM(afc06) FROM afc_file,afb_file",
                " WHERE afb00 = afc00  AND afb01 = afc01 ",
                "   AND afb02 = afc02  AND afb03 = afc03 ",
                "   AND afb04 = afc04  ",
                "   AND afb041 = afc041 ",                      #CHI-A20007 add
                "   AND afb042 = afc042 ",                    #CHI-A20007 add
               #"   AND afb15 = '2' ",           #部門預算      #CHI-A20007 mark
                "   AND afc01 = '",tm.budget,"'",
                "   AND afc00 = ? ",
                "   AND afc02 BETWEEN ? AND ? ",
                "   AND afc03 = ? ",
                "   AND afc05 <= ? ",                     #期初
               #"   AND afc04 IN (",g_buf CLIPPED,")"     #---- g_buf 部門族群   #CHI-A20007 mark
                "   AND afc041 IN (",g_buf CLIPPED,")"    #---- g_buf 部門族群   #CHI-A20007 add
               ,"   AND afbacti = 'Y' "                    #FUN-D70090 add
    PREPARE r100_sum1 FROM l_sql
    DECLARE r100_sumc1 CURSOR FOR r100_sum1
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM 
    END IF
    FOREACH r100_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0 LET amt  = 0
       IF NOT cl_null(maj.maj21) THEN
          IF maj.maj06 = '1' OR maj.maj06='3' THEN # Thomas99/01/11 取前期餘額
             IF maj.maj06='1' THEN LET l_mm=tm.bm-1 ELSE LET l_mm=tm.bm END IF
             OPEN r100_sumc1 USING tm.b,maj.maj21,maj.maj22,tm.yy,l_mm
             FETCH r100_sumc1 INTO amt1
          ELSE
             OPEN r100_sumc USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.bm,g_mm
             FETCH r100_sumc INTO amt1
          END IF
          IF STATUS THEN CALL cl_err('fetch #1',STATUS,1) EXIT FOREACH END IF
          IF cl_null(amt1) THEN LET amt1 = 0 END IF
       END IF
 
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
          FOR i = 1 TO 100
              LET l_amt1 = amt1
              IF maj.maj09 = '-' THEN  # Thomas 99/01/12
                 LET g_tot1[i]=g_tot1[i]-l_amt1     #科目餘額
              ELSE
                 LET g_tot1[i]=g_tot1[i]+l_amt1     #科目餘額
              END IF
          END FOR
          LET k=maj.maj08
          LET m_bal1=g_tot1[k]
          IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
             LET m_bal1 = m_bal1 *-1
          END IF
          #-----------
          FOR i = 1 TO k LET g_tot1[i]=0 END FOR
       ELSE
	  IF maj.maj03 = '%' THEN
	     LET l_temp = maj.maj21
	     SELECT bal1 INTO l_sun FROM r100_file WHERE no=l_cn
	            AND maj02=l_temp
	     LET l_temp = maj.maj22
	     SELECT bal1 INTO l_mon FROM r100_file WHERE no=l_cn
	            AND maj02=l_temp
	     IF cl_null(l_sun) OR cl_null(l_mon) OR l_mon = 0 THEN
	     ELSE
                LET m_bal1 = l_sun / l_mon * 100
             END IF
          ELSE
             LET m_bal1=NULL
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
    #  IF (tm.c='N' OR maj.maj03='2') AND
    #     maj.maj03 MATCHES "[012]" AND m_bal1=0 THEN
    #     CONTINUE FOREACH                              #餘額為 0 者不列印
    #  END IF
 
       # IF maj.maj07='2' THEN LET m_bal1=m_bal1*-1 END IF
       IF maj.maj03 !='%' THEN
         IF maj.maj07='2' THEN
            # LET m_bal1=m_bal1*-1
            IF NOT cl_null(maj.maj21) THEN
               IF m_bal1 > 0 AND amt1 < 0 THEN
                  LET m_bal1=m_bal1
               END IF
            END IF
         END IF
        #IF maj.maj07='1' THEN
        #   IF NOT cl_null(maj.maj21) THEN
        #      IF maj.maj09 <> '-' AND m_bal1 < 0 THEN
        #         LET m_bal1=m_bal1*-1  END IF
        #      END IF
        #   END IF
        #END IF
       END IF
       IF tm.f > 0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                              #最小階數起列印
       END IF
       INSERT INTO r100_file VALUES(l_cn,maj.maj02,maj.maj03,maj.maj04,
                                    maj.maj05,maj.maj07,maj.maj20,maj.maj20e,
                                    maj.maj21,maj.maj22,m_bal1)
       IF STATUS OR STATUS = 100 THEN
#         CALL cl_err('ins r100_file',STATUS,1) #FUN-660105
          CALL cl_err3("ins","r100_file","","",STATUS,"","sel r100_file:",1) #FUN-660105
          EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
 
 
FUNCTION r100_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01        #No.FUN-680061 VARCHAR(06)
    DEFINE l_sw     LIKE type_file.chr1        #No.FUN-680061 VARCHAR(01)
    DEFINE l_abd02  LIKE abd_file.abd02        #No.FUN-680061 VARCHAR(06)
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5   #No.FUN-680061 SMALLINT
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
           CALL r100_bom(l_arr[l_cnt2].*)
        END IF
    END FOR
    IF l_sw = 'Y' THEN
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
 
FUNCTION r100_total()
    DEFINE  l_i,l_y  LIKE type_file.num5,     #No.FUN-680061 SMALLINT,   
	    l_maj02  LIKE maj_file.maj02, 
	    l_maj03  LIKE maj_file.maj03,
	    l_maj21  LIKE maj_file.maj21,
	    l_maj22  LIKE maj_file.maj22,
	    l_t1,l_t2 LIKE type_file.num5,    #No.FUN-680061 SMALLINT,
	    l_bal    LIKE type_file.num20_6   #No.FUN-680061 DEC(20,6)
 
    DECLARE tot_curs CURSOR FOR
      SELECT maj02,maj03,maj21,maj22,SUM(bal1)
        FROM r100_file
       GROUP BY maj02,maj03,maj21,maj22 ORDER BY maj02
    IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) END IF
    LET l_i = 1
    LET l_maj02 = ' '
    LET l_bal = 0
    FOREACH tot_curs INTO l_maj02,l_maj03,l_maj21,l_maj22,l_bal
       IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) EXIT FOREACH END IF
       IF cl_null(l_bal) THEN LET l_bal = 0 END IF
       IF tm.d MATCHES '[23]' THEN             #換算金額單位
          IF g_unit!=0 THEN
             LET l_bal = l_bal / g_unit    #實際
          ELSE
             LET l_bal = 0
          END IF
       END IF
       IF l_maj03 = '%' THEN
          LET l_t1 = l_maj21
          LET l_t2 = l_maj22
          FOR l_y = 1 TO 300
              IF g_total[l_y].maj02 = l_t1 THEN LET l_t1 = l_y END IF
              IF g_total[l_y].maj02 = l_t2 THEN LET l_t2 = l_y END IF
          END FOR
          IF g_total[l_t2].amt != 0 THEN
             LET g_total[l_i].amt = g_total[l_t1].amt / g_total[l_t2].amt * 100
          ELSE
             LET g_total[l_i].amt = 0
          END IF
       ELSE
          LET g_total[l_i].amt = g_total[l_i].amt + l_bal
       END IF
       LET g_total[l_i].maj02 = l_maj02
       LET l_i = l_i + 1
       IF l_i > 300 THEN
          CALL cl_err('l_i > 300',STATUS,1) EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
#Patch....NO.TQC-610035 <001,002> #
