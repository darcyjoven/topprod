# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr920.4gl  (copy from aglr920)
# Descriptions...: 二期預算損益比較表列印作業
# Date & Author..: 03/03/17 By Kammy
# Modify.........: No.TQC-660030 06/06/07 By Smapmin 輸入前給予預設值
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-670107 06/08/24 By cheunl voucher型報表轉template1
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740029 07/04/11 By johnray 會計科目加帳套
# Modify.........: No.TQC-760073 07/06/12 By johnray 調整欄位輸入順序
# Modify.........: NO.FUN-750025 07/08/07 BY TSD.liquor 改為crystal report
# Modify.........: NO.FUN-810069 08/02/28 By destiny 取消預算編號
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40063 10/05/05 By Summer 正負號相反問題
# Modify.........: No:CHI-A20007 10/10/28 By sabrina afc041要改成afc04, afc04='@'要mark掉 
# Modify.........: No:FUN-AB0020 10/11/08 By suncx 新增欄位預算項目，處理相關邏輯
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_wc string  #No.FUN-580092 HCN
   DEFINE tm  RECORD
              s       LIKE type_file.chr2,     #No.FUN-680061  VARCHAR(2)
              t       LIKE type_file.chr2,     #No.FUN-680061  VARCHAR(2)
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              yy1     LIKE type_file.num5,     #No.FUN-680061  SMALLINT
              m1      LIKE type_file.num5,     #No.FUN-680061  SMALLINT
              m2      LIKE type_file.num5,     #No.FUN-680061  SMALLINT
              yy2     LIKE type_file.num5,     #No.FUN-680061  SMALLINT
              m3      LIKE type_file.num5,     #No.FUN-680061  SMALLINT
              m4      LIKE type_file.num5,     #No.FUN-680061  SMALLINT
             #budget  LIKE afa_file.afa01,     #No.FUN-680061  VARCHAR(4)   #No.FUN-810069--mark
              budget  LIKE azf_file.azf01,     #FUN-AB0020 add
              choice  LIKE type_file.chr1,     #No.FUN-680061  VARCHAR(1)
              dec     LIKE type_file.num5,     #No.FUN-680061  SMALLINT
              cd      LIKE type_file.chr1,     #No.FUN-680061  VARCHAR(1)
              more    LIKE type_file.chr1,     #No.FUN-680061  VARCHAR(1)
              bookno  LIKE aaa_file.aaa01      #No.FUN-740029
              END RECORD
DEFINE g_orderA    ARRAY[2] OF LIKE type_file.chr20   #No.FUN-680061 VARCHAR(10)
DEFINE g_totdiff   LIKE type_file.num20_6   #No.FUN-680061 DEC(20,6)
#DEFINE g_bookno    LIKE afc_file.afc00      #帳別   #No.FUN-740029
DEFINE g_i         LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE g_aaa03     LIKE  aaa_file.aaa03  
DEFINE   g_str       STRING          # FUN-750025 TSD.liquor add
DEFINE   l_table     STRING          # FUN-750025 TSD.liquor add
DEFINE   g_sql       STRING          # FUN-750025 TSD.liquor add  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
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
   LET g_sql = "order1.aag_file.aag223,",
               "order2.aag_file.aag223,",
               "aae01.aae_file.aae01,",
               "aae02_1.aae_file.aae02,",
               "aae02_2.aae_file.aae02,",
               "amt1.afc_file.afc06,",
               "amt2.afc_file.afc06,",
               "diff.afc_file.afc06,",
               "pr1.afc_file.afc06,",
               "pr2.afc_file.afc06,",
               "pr3.afc_file.afc06,",
               "gsum_3.aah_file.aah04,",
               "gsum_4.aah_file.aah04"
 
 
   LET l_table = cl_prt_temptable('abgr920',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750025
 
   LET g_trace = 'N'
#   LET g_bookno = ARG_VAL(1)   #No.FUN-740029
   LET tm.bookno = ARG_VAL(1)   #No.FUN-740029
   LET g_pdate = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET g_wc  = ARG_VAL(8)
   LET tm.azh01 = ARG_VAL(9)   #TQC-610054
   LET tm.azh02 = ARG_VAL(10)  #TQC-610054
   LET tm.yy1 = ARG_VAL(11)
   LET tm.yy2 = ARG_VAL(12)
   LET tm.m1  = ARG_VAL(13)
   LET tm.m2  = ARG_VAL(14)
   LET tm.m3  = ARG_VAL(15)
   LET tm.m4  = ARG_VAL(16)
#  LET tm.budget  = ARG_VAL(17) #No.FUN-810069--mark
   LET tm.budget = ARG_VAL(17)   #FUN-AB0020 add
   LET tm.dec = ARG_VAL(18)
   LET tm.s  = ARG_VAL(19)
   LET tm.t  = ARG_VAL(20)
   LET tm.choice  = ARG_VAL(21)
   LET tm.cd  = ARG_VAL(22)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#   IF cl_null(g_bookno) THEN   #No.FUN-740029
   IF cl_null(tm.bookno) THEN   #No.FUN-740029
#      LET g_bookno = g_aaz.aaz64   #No.FUN-740029
      LET tm.bookno = g_aza.aza81   #No.FUN-740029
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r920_tm(0,0)
      ELSE CALL r920()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r920_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(400)
 
#   CALL s_dsmark(g_bookno)   #No.FUN-740029
   CALL s_dsmark(tm.bookno)   #No.FUN-740029
 
   OPEN WINDOW r920_w WITH FORM "abg/42f/abgr920"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)   #No.FUN-740029
   CALL  s_shwact(0,0,tm.bookno)   #No.FUN-740029
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bookno = g_aza.aza81   #No.TQC-760073
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740029
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno   #No.FUN-740029
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('',SQLCA.sqlcode,0) #FUN-660105
#   CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105    #No.FUN-740029
   CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #No.FUN-740029
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.dec FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('',SQLCA.sqlcode,0) #FUN-660105
   CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) #FUN-660105 
   END IF
   LET tm.choice = 'N'
   LET tm.cd = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #-----TQC-660030--------- 
   LET tm2.s1='1'
   LET tm2.s2='2'
   LET tm2.t1='N'
   LET tm2.t2='N'
   #-----END TQC-660030-----
WHILE TRUE
   CONSTRUCT BY NAME  g_wc ON aag223,aag224,aag225,aag226
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
      CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   DISPLAY BY NAME tm.more #ATTRIBUTE(YELLOW)   #TQC-8C0076
   INPUT BY NAME tm.bookno,tm.azh01,tm.azh02,    #No.FUN-740029
                 tm.yy1,tm.m1,tm.m2,
                 tm.yy2,tm.m3,tm.m4,
#                tm.budget,tm.dec,               #No.FUN-810069--mark
                 tm.budget,                      #No.FUN-AB0020 add
                 tm.dec,                         #No.FUN-810069
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.choice,tm.cd,tm.more
                  WITHOUT DEFAULTS HELP 1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD azh01
           IF NOT cl_null(tm.azh01) THEN
              SELECT azh02
                 INTO tm.azh02
                 FROM azh_file
                 WHERE azh01 = tm.azh01
                      IF SQLCA.SQLCODE = 100 THEN
#                        CALL cl_err(tm.azh01,'mfg9207',1) #FUN-660105
                         CALL cl_err3("sel","azh_file",tm.azh01,"","mfg9207","","",1) #FUN-660105 
                         NEXT FIELD azh01
                      END IF
           END IF
#No.FUN-740029 -- begin --
      AFTER FIELD bookno
         IF tm.bookno IS NULL THEN
            CALL cl_err('','atm-339',0)
            NEXT FIELD bookno
         END IF
#No.FUN-740029 -- end --
 
         AFTER FIELD yy1
           IF tm.yy1 <= 1911  THEN
              NEXT FIELD yy1
           END IF
         AFTER FIELD yy2
           IF tm.yy2 <= 1911  THEN
              NEXT FIELD yy2
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
#           IF tm.m1 < 0 OR tm.m1 >14  THEN
#              NEXT FIELD m1
#           END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
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
#           IF tm.m2 < 0 OR tm.m2 >14  THEN
#              NEXT FIELD m2
#           END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD m3
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m3) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
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
#           if TM.M3 < 0 OR tm.m3 >14 THEN
#              NEXT FIELD m3
#           END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD m4
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m4) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
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
#           IF tm.m4 < 0 OR tm.m4 >14 THEN
#              NEXT FIELD m4
#           END IF
#No.TQC-720032 -- end --
#No.FUN-810069--begin--
#         AFTER FIELD budget
#         SELECT * FROM afa_file WHERE afa01=tm.budget
#                                  AND afaacti IN ('Y','y')
#                                  AND afa00 = tm.bookno    #No.FUN-740029
#         IF STATUS THEN 
#        CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#         CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105
#         NEXT FIELD budget END IF
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
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
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
               WHEN INFIELD(azh01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_azh'
                    LET g_qryparam.default1 = tm.azh01
                    LET g_qryparam.default2 = tm.azh02
                    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
#                    CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#                    CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
                    DISPLAY tm.azh01, tm.azh02 TO azh01, azh02
#No.FUN-810069--begin--
#               WHEN INFIELD (budget)
#                    CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_afa"
#                    LET g_qryparam.default1 = tm.budget
#                    LET g_qryparam.arg1 = tm.bookno      #No.FUN-740029
#                    CALL cl_create_qry() RETURNING tm.budget
#                    DISPLAY BY NAME tm.budget
#                    NEXT FIELD budget
#No.FUN-810069--end--
#No.FUN-AB0020--START------------------                                                                                                             
               WHEN INFIELD(budget)                                                                                                      
                    CALL cl_init_qry_var()                                                                                              
                    LET g_qryparam.form ="q_azf"                                                                                        
                    LET g_qryparam.default1 = tm.budget                                                                                 
                    LET g_qryparam.arg1 = '2'                                                                                           
                    CALL cl_create_qry() RETURNING tm.budget                                                                            
                    DISPLAY tm.budget TO budget                                                                                         
                    NEXT FIELD budget                                                                                                   
#No.FUN-AB0020--END----------------
              OTHERWISE EXIT CASE
           END CASE
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
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
      CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='abgr920'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr920','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
#                        " '",g_bookno CLIPPED,"'",   #No.FUN-740029
                        " '",tm.bookno CLIPPED,"'",   #No.FUN-740029
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",g_wc CLIPPED,"'",
                        " '",tm.azh01 CLIPPED,"'",
                        " '",tm.azh02 CLIPPED,"'",
                      " '",tm.yy1 CLIPPED,"'",
                      " '",tm.yy2 CLIPPED,"'",
                      " '",tm.m1 CLIPPED,"'",
                      " '",tm.m2 CLIPPED,"'",
                      " '",tm.m3 CLIPPED,"'",
                      " '",tm.m4 CLIPPED,"'",
#                      " '",tm.budget CLIPPED,"'",          #No.FUN-810069
                      " '",tm.budget CLIPPED,"'",   #FUN-AB0020 add
                      " '",tm.dec CLIPPED,"'",
                      " '",tm.s CLIPPED,"'",
                      " '",tm.t CLIPPED,"'",
                      " '",tm.choice CLIPPED,"'",
                      " '",tm.cd CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr920',g_time,l_cmd)
      END IF
      CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r920()
   ERROR ""
END WHILE
   CLOSE WINDOW r920_w
END FUNCTION
 
FUNCTION r920()
   DEFINE l_name    LIKE type_file.chr20,    #No.FUN-680061 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0056
          l_sql     LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE aag_file.aag223, #No.FUN-680061 VARCHAR(5)
       sr               RECORD
                                  order1 LIKE aag_file.aag223,  #No.FUN-680061 VARCHAR(5)
                                  order2 LIKE aag_file.aag223,  #No.FUN-680061 VARCHAR(5)
                                  aag01  LIKE aag_file.aag01,
                                  aag06  LIKE aag_file.aag06,
                                  aag223 LIKE aag_file.aag223,
                                  aag224 LIKE aag_file.aag224,
                                  aag225 LIKE aag_file.aag225,
                                  aag226 LIKE aag_file.aag226,
                                  amt1   LIKE afc_file.afc06,
                                  amt2   LIKE afc_file.afc06
                        END RECORD
      # add FUN-750025
      ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.liquor *** ##
      CALL cl_del_data(l_table)
      #------------------------------ CR (2) ----------------------------------#
      # end FUN-750025
 
#     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno   #No.FUN-740029
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno   #No.FUN-740029
			AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abgr920'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET g_wc = g_wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET g_wc = g_wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET g_wc = g_wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT aag223,aag224,aag225,aag226,aag01,aag06",
                 " FROM aag_file ",
                 " WHERE ",g_wc CLIPPED,
                 " AND aag00 = '",tm.bookno,"'"    #No.FUN-740029
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r920_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
     END IF
     DECLARE r920_curs1 CURSOR FOR r920_prepare1
     LET l_name = "abgr920.out" #FUN-750025 TSD.liquor add
     START REPORT r920_rep TO l_name
     LET g_pageno = 0
     LET g_totdiff = 0
     FOREACH r920_curs1 INTO sr.aag223,sr.aag224,sr.aag225,sr.aag226,
                             sr.aag01,sr.aag06
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
       IF g_trace='Y' THEN
             DISPLAY sr.aag223,sr.aag224,sr.aag225,sr.aag226,sr.aag01
          END IF
          IF tm.budget IS NULL THEN     #FUN-AB0020
             SELECT SUM(afc06) INTO sr.amt1 FROM afc_file
#               WHERE afc00=g_bookno AND afc02=sr.aag01   #No.FUN-740029
               WHERE afc00=tm.bookno AND afc02=sr.aag01   #No.FUN-740029
#                AND afc01= tm.budget                     #No.FUN-810069         
                 AND afc01=''                             #No.FUN-810069--add     
                #AND afc041=' '                           #No.FUN-810069--add  #CHI-A40063 mod ' ' #CHI-A20007 mark 
                 AND afc04=' '                            #CHI-A20007 add 
                 AND afc042=' '                            #No.FUN-810069--add  #CHI-A40063 mod ' '
                 AND afc03 = tm.yy1
                 AND afc05 BETWEEN tm.m1 AND tm.m2
                #AND afc04 = '@'        #整體預算         #CHI-A20007 mark
           ELSE
              #No.FUN-AB0020--START--
              SELECT SUM(afc06) INTO sr.amt1 FROM afc_file
#               WHERE afc00=g_bookno AND afc02=sr.aag01   #No.FUN-740029
               WHERE afc00=tm.bookno AND afc02=sr.aag01   #No.FUN-740029
                 AND afc01= tm.budget                     #No.FUN-810069         
                 AND afc01=''                             #No.FUN-810069--add     
                #AND afc041=' '                           #No.FUN-810069--add  #CHI-A40063 mod ' ' #CHI-A20007 mark 
                 AND afc04=' '                            #CHI-A20007 add 
                 AND afc042=' '                            #No.FUN-810069--add  #CHI-A40063 mod ' '
                 AND afc03 = tm.yy1
                 AND afc05 BETWEEN tm.m1 AND tm.m2
                #AND afc04 = '@'        #整體預算         #CHI-A20007 mark
              #No.FUN-AB0020--END  
           END IF
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('Select afc error !',SQLCA.SQLCODE,1) #FUN-660105
#               CALL cl_err3("sel","afc_file",g_bookno,sr.aag01,SQLCA.sqlcode,"","Select afc error!",1) #FUN-660105   #No.FUN-740029
               CALL cl_err3("sel","afc_file",tm.bookno,sr.aag01,SQLCA.sqlcode,"","Select afc error!",1) #No.FUN-740029
               EXIT FOREACH
            END IF	
          IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
          IF tm.budget IS NULL THEN     #FUN-AB0020
             SELECT SUM(afc06) INTO sr.amt2 FROM afc_file
#               WHERE afc00=g_bookno AND afc02=sr.aag01   #No.FUN-740029
               WHERE afc00=tm.bookno AND afc02=sr.aag01   #No.FUN-740029
#                AND afc01 = tm.budget                    #No.FUN-810069
                 AND afc01=''                             #No.FUN-810069--add     
                #AND afc041=' '                            #No.FUN-810069--add  #CHI-A40063 mod ' '  #CHI-A20007 mark
                 AND afc04=' '                            #CHI-A20007 add 
                 AND afc042=' '                            #No.FUN-810069--add  #CHI-A40063 mod ' '
                 AND afc03 = tm.yy2
                 AND afc05 BETWEEN tm.m3 AND tm.m4
                #AND afc04 = '@'                          #CHI-A20007 mark
          ELSE
              #No.FUN-AB0020--START--
              SELECT SUM(afc06) INTO sr.amt2 FROM afc_file
#               WHERE afc00=g_bookno AND afc02=sr.aag01   #No.FUN-740029
               WHERE afc00=tm.bookno AND afc02=sr.aag01   #No.FUN-740029
                 AND afc01 = tm.budget                    #No.FUN-810069
                 AND afc01=''                             #No.FUN-810069--add     
                #AND afc041=' '                            #No.FUN-810069--add  #CHI-A40063 mod ' '  #CHI-A20007 mark
                 AND afc04=' '                            #CHI-A20007 add 
                 AND afc042=' '                            #No.FUN-810069--add  #CHI-A40063 mod ' '
                 AND afc03 = tm.yy2
                 AND afc05 BETWEEN tm.m3 AND tm.m4
                #AND afc04 = '@'                          #CHI-A20007 mark
              #No.FUN-AB0020--END
          END IF
          IF SQLCA.SQLCODE THEN
#            CALL cl_err('Select afc error !',SQLCA.SQLCODE,1) #FUN-660105
#             CALL cl_err3("sel","afc_file",g_bookno,sr.aag01,SQLCA.sqlcode,"","Select afc error!",1) #FUN-660105   #No.FUN-740029
             CALL cl_err3("sel","afc_file",tm.bookno,sr.aag01,SQLCA.sqlcode,"","Select afc error!",1) #No.FUN-740029
             EXIT FOREACH
          END IF	
          IF sr.amt2 IS NULL THEN LET sr.amt2=0 END IF
          IF sr.aag06 = '2' THEN                #貸餘
             LET sr.amt1 = -1 * sr.amt1
             LET sr.amt2 = -1 * sr.amt2
          END IF
          IF sr.amt1 = 0 AND sr.amt2 = 0 AND tm.choice = 'N' THEN
             CONTINUE FOREACH
          END IF
          FOR g_i = 1 TO 2
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.aag223
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.aag224
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.aag225
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.aag226
                   OTHERWISE LET l_order[g_i]  = '-'
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          OUTPUT TO REPORT r920_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r920_rep
 
     # FUN-750025 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN
        LET g_str = cl_wcchp(g_wc,'aag223,aag224,aag225,aag226')
     END IF
     LET g_str = g_str,";",tm.t,";",tm.yy1,";",tm.yy2,";",tm.m1,";",tm.m2,
                 ";",tm.m3,";",tm.m4,";",tm.dec,";",tm.cd,";",tm.s
     CALL cl_prt_cs3('abgr920','abgr920',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     # FUN-750025 end
END FUNCTION
 
REPORT r920_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-680061  VARCHAR(1)
DEFINE sr               RECORD                              
                        order1 LIKE aag_file.aag223, #No.FUN-680061 VARCHAR(5)
                        order2 LIKE aag_file.aag223, #No.FUN-680061 VARCHAR(5)
                        aag01  LIKE aag_file.aag01,
                        aag06  LIKE aag_file.aag06,
                        aag223 LIKE aag_file.aag223,
                        aag224 LIKE aag_file.aag224,
                        aag225 LIKE aag_file.aag225,
                        aag226 LIKE aag_file.aag226,
                        amt1   LIKE afc_file.afc06,
                        amt2   LIKE afc_file.afc06
                        END RECORD
DEFINE l_buf ARRAY[200] OF RECORD
                        aae01  LIKE aae_file.aae01,
                        aae02  LIKE aae_file.aae02,
                        amt1   LIKE afc_file.afc06,
                        amt2   LIKE afc_file.afc06,
                        diff   LIKE afc_file.afc06,
                        pr3    LIKE afc_file.afc06
                        END RECORD
DEFINE l_aae02_1        LIKE aae_file.aae02
DEFINE l_aae02_2        LIKE aae_file.aae02
DEFINE l_max            LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE l_idx            LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE l_posistion      LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE l_gsum_1 ,l_gsum_3 LIKE aah_file.aah04
DEFINE l_gsum_2 ,l_gsum_4 LIKE aah_file.aah04
DEFINE l_totdiff        LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
DEFINE l_diff           LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
DEFINE l_pr1            LIKE afc_file.afc06 #FUN-750025
DEFINE l_pr2            LIKE afc_file.afc06 #FUN-750025
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1, sr.order2
  FORMAT
   PAGE HEADER
 
   BEFORE GROUP OF sr.order1
      SELECT aae02
        INTO l_aae02_1
        FROM aae_file
        WHERE aae01 = sr.order1
        IF SQLCA.SQLCODE THEN
           LET l_aae02_1 = NULL
        END IF
      FOR l_idx = 1 TO 200
          INITIALIZE l_buf[l_idx].* TO NULL
      END FOR
      LET l_totdiff = 0
      LET l_max = 0               #Array 用到的個數
      LET l_idx = 0
 
 
   ON EVERY ROW
      IF g_trace = 'Y' THEN
         DISPLAY sr.aag223,sr.aag224,sr.aag225,sr.aag226,sr.aag01
      END IF
 
   AFTER GROUP OF sr.order1
      LET l_gsum_3 = GROUP SUM (sr.amt1)
      LET l_gsum_4 = GROUP SUM (sr.amt2)
      IF l_gsum_3 = 0 THEN LET l_gsum_3 = NULL END IF
      IF l_gsum_4 = 0 THEN LET l_gsum_4 = NULL END IF
      IF l_idx > 200 THEN LET l_max = 200 END IF
      FOR l_idx = 1 to l_max
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
          LET l_pr1 = l_buf[l_idx].amt1 / l_gsum_3*100
          LET l_pr2 = l_buf[l_idx].amt2 / l_gsum_4*100
          IF cl_null(l_buf[l_idx].diff) THEN
             LET l_buf[l_idx].diff = 0
          END IF
          IF cl_null(l_pr1) THEN
             LET l_pr1 = 0
          END IF
          IF cl_null(l_pr2) THEN
             LET l_pr2 = 0
          END IF
          IF cl_null(l_buf[l_idx].pr3) THEN
             LET l_buf[l_idx].pr3 = 0
          END IF 
          #CHI-A40063 add --start--
          IF l_buf[l_idx].amt1<0 THEN LET l_buf[l_idx].amt1=l_buf[l_idx].amt1*-1 END IF
          IF l_buf[l_idx].amt2<0 THEN LET l_buf[l_idx].amt2=l_buf[l_idx].amt2*-1 END IF
          IF l_gsum_3<0 THEN LET l_gsum_3=l_gsum_3*-1 END IF
          IF l_gsum_4<0 THEN LET l_gsum_4=l_gsum_4*-1 END IF
          #CHI-A40063 add --end--
          EXECUTE insert_prep USING 
              sr.order1,sr.order2,l_buf[l_idx].aae01,l_aae02_1,
              l_buf[l_idx].aae02,l_buf[l_idx].amt1,l_buf[l_idx].amt2,
              l_buf[l_idx].diff,
              l_pr1,l_pr2,
              l_buf[l_idx].pr3,
              l_gsum_3,l_gsum_4
          #------------------------------ CR (3) ------------------------------#
          #FUN-750025 TSD.liquor end
          LET l_totdiff = l_totdiff + l_buf[l_idx].diff 
      END FOR
      LET g_totdiff = g_totdiff + l_totdiff
      CALL r920_cha(l_aae02_1)
           RETURNING l_posistion
      SKIP 1 LINE
 
   AFTER GROUP OF sr.order2
      SELECT aae02
        INTO l_aae02_2
        FROM aae_file
        WHERE aae01 = sr.order2
        IF SQLCA.SQLCODE THEN
           LET l_aae02_2 = NULL
        END IF
      LET l_idx = l_idx + 1
      LET l_gsum_1 = GROUP SUM(sr.amt1)
      LET l_gsum_2 = GROUP SUM(sr.amt2)
#     IF l_gsum_1 = 0 THEN LET l_gsum_1 = NULL END IF
#     IF l_gsum_2 = 0 THEN LET l_gsum_2 = NULL END IF
      LET l_diff = l_gsum_1 - l_gsum_2
      LET l_buf[l_idx].aae01=sr.order2
      LET l_buf[l_idx].aae02=l_aae02_2
      LET l_buf[l_idx].amt1=l_gsum_1
      LET l_buf[l_idx].amt2=l_gsum_2
      LET l_buf[l_idx].diff=l_diff
      IF l_gsum_2 = 0 THEN
         LET l_buf[l_idx].pr3= NULL
      ELSE
         LET l_buf[l_idx].pr3=l_buf[l_idx].diff/l_gsum_2 * 100
      END IF
      LET l_max = l_idx
 
   ON LAST ROW
 
   PAGE TRAILER
END REPORT
 
FUNCTION r920_cha(l_cha)
DEFINE l_cha      LIKE type_file.chr20     #No.FUN-680061 VARCHAR(20)
DEFINE l_leng     LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE l_result   LIKE type_file.num5      #No.FUN-680061 SMALLINT
 
   LET l_leng = LENGTH (l_cha)
   LET l_result = 21 - l_leng
   RETURN l_result
END FUNCTION
#Patch....NO.TQC-610035 <001> #
