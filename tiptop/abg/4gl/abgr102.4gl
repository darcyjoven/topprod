# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr102.4gl  (copy from aglr102)
# Descriptions...: 預算營業成本明細表
#................: 03/03/16 By Kammy
# Modify.........: No.FUN-510025 05/01/13 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構檢查使用者設限及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740048 07/04/12 By johnray 會計科目加帳套
# Modify.........: No.FUN-810069 08/02/27 By ChenMoyan取消預算編號控管 
# Modify.........: No.FUN-860016 08/06/20 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-890102 08/09/22 By baofei CR追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40063 10/05/04 By Summer 正負號相反問題
# Modify.........: No:CHI-A20007 10/10/28 By sabrina r102_sum和r102_sum1的sql條件有誤  
# Modify.........: No:FUN-AB0020 10/11/04 By huangtao 添加預算項目欄位
# Modify.........: No:FUN-B10020 11/01/13 By huangtao 預算項目可以為空 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              a       LIKE maj_file.maj01,  #報表結構編號               #No.FUN-680061  VARCHAR(6)                                                           
              b       LIKE aaa_file.aaa01,  #帳別編號  #No.FUN-670039                                                               
              yy      LIKE abk_file.abk03,  #輸入年度                   #No.FUN-680061  SMALLINT                                                          
              bm      LIKE aah_file.aah03,  #Begin 期別                 #No.FUN-680061  SMALLINT                                                          
              em      LIKE aah_file.aah03,  # End  期別                 #No.FUN-680061  SMALLINT  
              afc01   LIKE afc_file.afc01,         #FUN-AB0020              
#             budget  LIKE afa_file.afa01,  #預算編號                   #No.FUN-680061  VARCHAR(4)     #No.FUN-810069                                                      
              c       LIKE type_file.chr1,  #異動額及餘額為0者是否列印  #No.FUN-680061  VARCHAR(1)                                                          
              d       LIKE type_file.chr1,  #金額單位                   #No.FUN-680061  VARCHAR(1)                                                          
              f       LIKE type_file.num5,  #列印最小階數               #No.FUN-680061  SMALLINT                                                          
              more    LIKE type_file.chr1                               #No.FUN-680061  VARCHAR(1)
              END RECORD,
          g_bookno   LIKE afc_file.afc00,   #帳別
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_unit     LIKE type_file.num10,  #金額單位基數  #No.FUN-680061  INTEGER
          i,j,k,g_mm LIKE type_file.num5,                  #No.FUN-680061  SMALLINT
          g_tot1     ARRAY[100] OF LIKE type_file.num20_6  #No.FUN-680061  ARRAY[100] OF DEC(20,6)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680061  SMALLINT
DEFINE   g_aaa03     LIKE  aaa_file.aaa03 
DEFINE   l_table      STRING,    #FUN-860016 add                                                                                    
         g_sql        STRING,    #FUN-860016 add                                                                                    
         g_str        STRING     #FUN-860016 add  
 
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
 
#---FUN-860016 add ---start                                                                                                         
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                            
  LET g_sql = "maj20.maj_file.maj20,",                                                                                              
              "maj20e.maj_file.maj20,",                                                                                             
              "maj02.maj_file.maj02,",                                                                                              
              "maj03.maj_file.maj03,",                                                                                              
              "maj04.maj_file.maj04,",                                                                                              
              "maj05.maj_file.maj05,",                                                                                              
              "maj07.maj_file.maj07,",                                                                                              
              "aah04_05.aah_file.aah04,",     #實際金額                                                                             
              "g_mai02.mai_file.mai02,",                                                                                            
              "a.maj_file.maj01,",            #報表結構編號                                                                         
              "line.type_file.num5 "          #1:表示此筆為空行 2:表示此筆不為空行                                                  
                                              #11 items                                                                             
  LET l_table = cl_prt_temptable('abgr102',g_sql) CLIPPED   # 產生Temp Table                                                        
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                        
                                                                                                                                    
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,                                                                           
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                    
  PREPARE insert_prep FROM g_sql  
  IF STATUS THEN                                                                                                                    
     CALL cl_err('insert_prep:',status,1)                                                                                           
     EXIT PROGRAM                                                                                                                   
  END IF                                                                                                                            
 #------------------------------ CR (1) ------------------------------#                                                             
#---FUN-860016 add ---end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
      LET g_trace = 'N'                        #default trace off
   LET g_bookno= ARG_VAL(1)   #No.FUN-740048
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
LET tm.yy   = ARG_VAL(10)
LET tm.bm   = ARG_VAL(11)
LET tm.em   = ARG_VAL(12)
#  LET tm.budget = ARG_VAL(13)    #TQC-610054      #No.FUN-810069 
LET tm.afc01 = ARG_VAL(13)           #FUN-AB0020 
LET tm.c    = ARG_VAL(14)
LET tm.d    = ARG_VAL(15)
LET tm.f    = ARG_VAL(16)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   #No.FUN-570264 ---end---
 
   DROP TABLE abgr102_file
   CREATE TEMP TABLE abgr102_file(
       maj02     LIKE maj_file.maj02,
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20,
       aah04_05  LIKE aah_file.aah04)
 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF #預設帳別
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF          #No.FUN-740048
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r102_tm()                        # Input print condition
   ELSE
      CALL r102()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r102_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680061  SMALLINT
          l_sw           LIKE type_file.chr1,     #No.FUN-680061  VARCHAR(01)
          l_cmd          LIKE type_file.chr1000,  #No.FUN-680061  VARCHAR(400)
          li_chk_bookno  LIKE type_file.num5      #No.FUN-680061  SMALLINT
   DEFINE li_result      LIKE type_file.num5      #NO.FUN-6C0068
 
#   CALL s_dsmark(g_bookno)    #No.FUN-740048
   CALL s_dsmark(tm.b)    #No.FUN-740048
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r102_w AT p_row,p_col
        WITH FORM "abg/42f/abgr102"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)    #No.FUN-740048
   CALL s_shwact(0,0,tm.b)    #No.FUN-740048
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   LET tm.b = g_aza.aza81     #No.FUN-740048
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno    #No.FUN-740048
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b    #No.FUN-740048
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #FUN-660105
#   CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105      #No.FUN-740048
   CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)      #No.FUN-740048
   END IF
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel azi:',SQLCA.sqlcode,0) #FUN-660105
   CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) #FUN-660105 
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
#   LET tm.b = g_bookno #預設帳別    #No.FUN-740048
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
#   INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.budget,tm.f,tm.d,tm.c,tm.more   #No.FUN-810069 
#    INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.more             #No.FUN-810069   #FUN-AB0011  mark
    INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.afc01,tm.f,tm.d,tm.c,tm.more    #FUN-AB0011 
		  WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD a #報表結構編號
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
            WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            AND mai00 = tm.b       #No.FUN-740048
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
 
      AFTER FIELD b #帳別編號
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
 
 
      AFTER FIELD yy #年度
         IF tm.yy = 0 THEN NEXT FIELD yy END IF
 
      AFTER FIELD bm #起始期別
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
#         IF tm.bm <1 OR tm.bm > 13 THEN
#            #期別範圍錯誤,請輸入1-13間的值!!
#            CALL cl_err('','agl-013',0) NEXT FIELD bm
#         END IF
#No.TQC-720032 -- end --
 
#     AFTER FIELD budget                                                   #No.FUN-810069
#        SELECT * FROM afa_file WHERE afa01=tm.budget                      #No.FUN-810069
#                                 AND afaacti IN ('Y','y')               #No.FUN-810069
#                                 AND afa00 = tm.b                         #No.FUN-810069
#       IF STATUS THEN                   #No.FUN-810069
#       CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#       CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105 #No.FUN-810069
#       NEXT FIELD budget END IF         #No.FUN-810069
#FUN-AB0020 -------------start------------------------
         AFTER FIELD afc01
            IF NOT cl_null(tm.afc01) THEN               #FUN-B10020
               SELECT * FROM azf_file WHERE azf01 = tm.afc01
                                      AND azfacti = 'Y'
                                      AND azf02 = '2'
                IF STATUS THEN
                   CALL cl_err3("sel","azf_file",tm.afc01,"",STATUS,"","sel afc:",0)
                   NEXT FIELD afc01
                END IF
            END IF                                      #FUN-B10020
#FUN-AB0020 --------------end-------------------------
 
      AFTER FIELD em #截止期別
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
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD f  #列印最小階數
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
 
        #---->金額單位換算
        CASE tm.d
            WHEN '1'
                 LET g_unit = 1        #元
            WHEN '2'
                 LET g_unit = 1000     #千
            WHEN '3'
                 LET g_unit = 1000000  #百萬
        END CASE
 
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
                #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740048  #No.TQC-C50042   Mark
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
#         WHEN INFIELD(budget)                          #No.FUN-810069
#                CALL cl_init_qry_var()                 #No.FUN-810069
#                LET g_qryparam.form ="q_afa"           #No.FUN-810069
#                LET g_qryparam.default1 = tm.budget    #No.FUN-810069
#                LET g_qryparam.arg1 = tm.b             #No.FUN-740048 #No.FUN-810069
#                CALL cl_create_qry() RETURNING tm.budget              #No.FUN-810069
#                DISPLAY tm.budget TO budget            #No.FUN-810069
#           NEXT FIELD budget                           #No.FUN-810069
#FUN-AB0020 --------------start--------------------
          WHEN INFIELD(afc01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_azf'    
             LET g_qryparam.default1 = tm.afc01
             LET g_qryparam.arg1 = '2'        
             CALL cl_create_qry() RETURNING tm.afc01
             DISPLAY BY NAME tm.afc01
             NEXT FIELD afc01
#FUN-AB0020 ---------------end--------------------
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
      LET INT_FLAG = 0 CLOSE WINDOW r102_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr102'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr102','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                          " '",tm.afc01 CLIPPED,"'",         #FUN-AB0020 
#                        " '",tm.budget CLIPPED,"'" ,   #TQC-610054 #No.FUN-810069
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.f CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr102',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r102_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r102()
   ERROR ""
END WHILE
   CLOSE WINDOW r102_w
END FUNCTION
 
FUNCTION r102()
   DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061   VARCHAR(20)
   DEFINE l_name1   LIKE type_file.chr20    #No.FUN-680061   VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT    #No.FUN-680061   VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680061   VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061   VARCHAR(40)
   DEFINE l_tmp     LIKE type_file.num20_6  #No.FUN-680061   DEC(20,6)
   DEFINE l_leng,l_leng2    LIKE type_file.num5     #No.FUN-680061   SMALLINT
   DEFINE l_abe03   LIKE abe_file.abe03     #部門代號
   DEFINE l_abd02   LIKE abd_file.abd02     #部門編號
   DEFINE l_gem02   LIKE gem_file.gem02     #部門名稱
   DEFINE l_dept    LIKE gem_file.gem01     #部門編號
   DEFINE l_maj20   LIKE maj_file.maj20,    #科目列印名稱  #No.FUN-680061  VARCHAR(30)
          l_bal     LIKE type_file.num20_6  #No.FUN-680061   DEC(20,6)
   DEFINE sr  RECORD
              maj02     LIKE maj_file.maj02,   #項次
              maj03     LIKE maj_file.maj03,   #列印碼
              maj04     LIKE maj_file.maj04,   #空行數
              maj05     LIKE maj_file.maj05,   #空格數
              maj07     LIKE maj_file.maj07,   #正常餘額型態 (1.借餘/2.貸餘)
              maj20     LIKE maj_file.maj20,   #科目列印名稱
              maj20e    LIKE maj_file.maj20e,  #額外列印名稱
              aah04_05  LIKE aah_file.aah04    #實際金額  #No.FUN-680061   DEC(20,6)
              END RECORD
 
#FUN-860016 add---START                                                                                                             
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                            
    CALL cl_del_data(l_table)                                                                                                       
   #------------------------------ CR (2) ------------------------------#                                                           
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
#FUN-860016 add---END 
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b  #aaf03帳別名稱
      AND aaf02 = g_rlang
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"' AND maj23[1,1]='2' ",
               " ORDER BY maj02"
   IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
   PREPARE r102_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM 
   END IF
   DECLARE r102_c CURSOR FOR r102_p
 
#   CALL cl_outnam('abgr102') RETURNING l_name
 
   DROP TABLE abgr102_file
#No.FUN-680061-----------start----------
   CREATE TEMP TABLE abgr102_file(
       maj02     LIKE maj_file.maj02,
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,
       aah04_05  LIKE aah_file.aah04)
#No.FUN-680061-----------end----------
 
#   START REPORT r102_rep TO l_name
 
   #---->抓取maj_file的資料,並做與afc_file的處理
   CALL r102_process()
 
   DECLARE tmp_curs CURSOR FOR
       SELECT * FROM abgr102_file ORDER BY maj02
 
   FOREACH tmp_curs INTO sr.*
      #---FUN-860016 add---START                                                                                                    
      IF sr.maj04 = 0 THEN                                                                                                          
         EXECUTE insert_prep USING                                                                                                  
            sr.maj20,sr.maj20e,sr.maj02,sr.maj03,                                                                                   
            sr.maj04, sr.maj05,sr.maj07,sr.aah04_05,g_mai02,tm.a,'2'                                                                
      ELSE                                                                                                                          
         EXECUTE insert_prep USING                                                                                                  
            sr.maj20,sr.maj20e,sr.maj02,sr.maj03,                                                                                   
            sr.maj04,sr.maj05,sr.maj07,sr.aah04_05,g_mai02,tm.a,'2'                                                                 
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                            
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                                  
         #讓空行的這筆資料排在正常的資料前面印出                                                                                    
         FOR i = 1 TO sr.maj04                                                                                                      
            EXECUTE insert_prep USING                                                                                               
               sr.maj20,sr.maj20e,sr.maj02,'',                                                                                      
               '','','','','',tm.a,'1'                                                                                              
         END FOR                                                                                                                    
      END IF                                                                                                                        
       IF SQLCA.sqlcode  THEN                                                                                                       
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH                                                                         
       END IF                                                                                                                       
      #---FUN-860016 add---END          
#       OUTPUT TO REPORT r102_rep(sr.*)
 
   END FOREACH
 
 #  FINISH REPORT r102_rep
 
 #  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #FUN-860016  ---start---                                                                                                          
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>                                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                               
                " ORDER BY maj02 "                                                                                                  
                                                                                                                                    
    #是否列印選擇條件                                                                                                               
    LET g_str = ''                                                                                                                  
                                                                                                                                    
                #P1       #P2                 #P3              #P4                                                                  
    LET g_str = g_str,";",tm.yy USING "<<<<;",tm.bm USING"&&;",tm.em USING"&&;",                                                    
                #P5      #P6         #P7                                                                                            
                tm.d,";",g_azi04,";",g_aaz.aaz77                                                                                    
    CALL cl_prt_cs3('abgr102','abgr102',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#                                                          
  #FUN-860016  ----end---    
 
END FUNCTION
 
FUNCTION r102_process()
   DEFINE l_sql,l_sql1   LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(1000)
   DEFINE l_cn           LIKE type_file.num5     #No.FUN-680061  SMALLINT
   DEFINE l_temp         LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_sun          LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_mon          LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_amt1,amt1,amt2,amt  LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_maj          RECORD LIKE maj_file.*
   DEFINE m_bal1,m_bal2  LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_amt          LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE m_per1,m_per2  LIKE con_file.con06     #No.FUN-680061  DEC(9,5)
   DEFINE l_mm           LIKE type_file.num5     #No.FUN-680061  SMALLINT
   DEFINE l_aah04_05     LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_aah04_05_sum LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE l_maj08_last LIKE maj_file.maj08
 
#----------- sql for sum(afc06)-----------------------------------
 
    LET l_sql = "SELECT SUM(afc06) FROM afc_file",
                " WHERE afc00 = ? AND afc02 BETWEEN ? AND ? ",
#               "   AND afc01 = '",tm.budget,"'",               #No.FUN-810069
                "   AND afc03 = ? ",
                "   AND afc05 BETWEEN ? AND ? ",
               #"   AND afc041 = ''",                           #No.FUN-810069  #CHI-A40063 mod ' '  #CHI-A20007 mark
                "   AND afc04 = ' '",                            #CHI-A20007 add #CHI-A40063 mod ' '
                "   AND afc042 = ' '"                            #No.FUN-810069  #CHI-A40063 mod ' '
               #"   AND afc04 = '@' "  #整體預算             #CHI-A20007 mark
    LET l_sql = l_sql CLIPPED
#FUN-AB0020 ----------start------------------------
    IF NOT cl_null(tm.afc01) THEN
       LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
    END IF
#FUN-AB0020 -------------end----------------------
 
    PREPARE r102_sum FROM l_sql
    DECLARE r102_sumc CURSOR FOR r102_sum
    IF STATUS THEN CALL cl_err('prepare:r102_sum',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM 
    END IF
 
#----------- sql for sum(afc06)------Sum 期初---------------------
 
    LET l_sql = "SELECT SUM(afc06) FROM afc_file",
                " WHERE afc00 = ? AND afc02 BETWEEN ? AND ? ",
#               "   AND afc01 = '",tm.budget,"'",               #No.FUN-810069
                "   AND afc03 = ? ",
                "   AND afc05 <= ? ",
               #"   AND afc041 = ''",                           #No.FUN-810069  #CHI-A40063 mod ' '  #CHI-A20007 mark
                "   AND afc04 = ' '",                            #CHI-A20007 add #CHI-A40063 mod ' '
                "   AND afc042 = ' '"                            #No.FUN-810069  #CHI-A40063 mod ' '
               #"   AND afc04 = '@' "  #整體預算             #CHI-A20007 mark
    LET l_sql = l_sql CLIPPED
#FUN-AB0020 ----------start------------------------
    IF NOT cl_null(tm.afc01) THEN
       LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
    END IF
#FUN-AB0020 -------------end----------------------
 
    PREPARE r102_sum1 FROM l_sql
    DECLARE r102_sumc1 CURSOR FOR r102_sum1
    IF STATUS THEN CALL cl_err('prepare:r102_sum1',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM 
    END IF
   #MOD FUN-860016 應清空為0才不致於為null-----(S)                                                                                  
    FOR i = 1 TO 100                                                                                                                
        LET g_tot1[i]=0                                                                                                             
    END FOR                                                                                                                         
   #MOD FUN-860016 應清空為0才不致於為null-----(E) 
    FOREACH r102_c INTO l_maj.*
       IF STATUS THEN CALL cl_err('foreach:r102_c',STATUS,1) EXIT FOREACH END IF
 
       LET l_aah04_05 = 0
       IF NOT cl_null(l_maj.maj21) THEN
          IF l_maj.maj06 = '2' THEN      #2:科目之當期異動
              OPEN r102_sumc USING tm.b,l_maj.maj21,l_maj.maj22,tm.yy,tm.bm,tm.em
              FETCH r102_sumc INTO l_aah04_05
          ELSE
              IF l_maj.maj06 = '1' THEN  #1:科目之期初(借減貸)
                  LET l_mm = tm.bm-1
              ELSE                       #3:科目之期末(借減貸)
                  LET l_mm = tm.em
              END IF
              OPEN r102_sumc1 USING tm.b,l_maj.maj21,l_maj.maj22,tm.yy,l_mm
              FETCH r102_sumc1 INTO l_aah04_05
          END IF
          IF STATUS THEN CALL cl_err('fetch:r102_sumc',STATUS,1) EXIT FOREACH END IF
          IF cl_null(l_aah04_05) THEN LET l_aah04_05 = 0 END IF
       END IF
       #---->正常餘額型態
       IF l_maj.maj07 = '2' THEN #2:貸餘
           IF l_aah04_05 < 0 THEN
               LET l_aah04_05 = l_aah04_05 * (-1)
           END IF
       END IF
       #---->合計階數處理
       IF l_maj.maj03 MATCHES "[012]" AND l_maj.maj08 > 0 THEN   #合計階數處理
           FOR i = 1 TO 100
               LET l_amt1 = l_aah04_05
               IF l_maj.maj09 = '-' THEN  # Thomas 99/01/12
                   LET g_tot1[i] = g_tot1[i] - l_amt1     #科目餘額
               ELSE
                   LET g_tot1[i] = g_tot1[i] + l_amt1     #科目餘額
               END IF
           END FOR
           LET k = l_maj.maj08
           LET l_aah04_05 = g_tot1[k]
           FOR i = 1 TO k LET g_tot1[i] = 0 END FOR
      #---FUN-860016 add---START                                                                                                    
       ELSE                                                                                                                         
           LET l_aah04_05 = NULL                                                                                                    
      #---FUN-860016 add---END
       END IF
 
       #---->本行不印出
       IF l_maj.maj03 = '0' THEN CONTINUE FOREACH END IF
 
       #---->餘額為 0 者不列印
       IF (tm.c = 'N' OR l_maj.maj03 = '2') AND
          l_maj.maj03 MATCHES "[0125]" AND l_aah04_05 = 0 THEN                         #CHI-CC0023 add maj03 match 5
           CONTINUE FOREACH
       END IF
 
       #---->最小階數起列印
       IF tm.f > 0 AND l_maj.maj08 < tm.f THEN
           CONTINUE FOREACH
       END IF
 
       #---->金額單位換算
       LET l_aah04_05 = l_aah04_05 / g_unit
       IF l_aah04_05<0 THEN LET l_aah04_05=l_aah04_05*-1 END IF #CHI-A40063 add
 
       INSERT INTO abgr102_file VALUES(l_maj.maj02,l_maj.maj03,l_maj.maj04,
                                    l_maj.maj05,l_maj.maj07,l_maj.maj20,l_maj.maj20e,
                                    l_aah04_05)
       IF STATUS OR STATUS = 100 THEN
#          CALL cl_err('ins abgr102_file',STATUS,1) #FUN-660105
           CALL cl_err3("ins","abgr102_file","","",STATUS,"","ins abgr102_file:",1) #FUN-660105 
           EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
#No.FUN-860016----BEGIN 
#REPORT r102_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1      #No.FUN-680061  VARCHAR(1)
#  DEFINE l_unit       LIKE type_file.chr4      #No.FUN-680061  VARCHAR(4)
#  DEFINE per1         LIKE ima_file.ima18      #No.FUN-680061  DEC(8,3)
#  DEFINE l_gem02      LIKE gem_file.gem02,
#         g_head1      STRING
#  DEFINE sr  RECORD
#             maj02     LIKE maj_file.maj02,
#             maj03     LIKE maj_file.maj03,
#             maj04     LIKE maj_file.maj04,
#             maj05     LIKE maj_file.maj05,
#             maj07     LIKE maj_file.maj07,
#             maj20     LIKE maj_file.maj20,
#             maj20e    LIKE maj_file.maj20e,
#             aah04_05  LIKE aah_file.aah04    #實際金額  #No.FUN-680061  DEC(20,6)
#             END RECORD,
#         l_j LIKE type_file.num5,        #No.FUN-680061  SMALLINT
#         i   LIKE type_file.num5,        #No.FUN-680061  SMALLINT
#         l_total  LIKE ima_file.ima18,   #No.FUN-680061  DEC(17,3)
#         l_x LIKE type_file.chr50        #No.FUN-680061  VARCHAR(40)
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.maj02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#     #金額單位之列印
#     CASE tm.d
#          WHEN '1'  LET l_unit = g_x[12]
#          WHEN '2'  LET l_unit = g_x[13]
#          WHEN '3'  LET l_unit = g_x[14]
#          OTHERWISE LET l_unit = ' '
#     END CASE
#     IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     LET g_head1 = g_x[10] CLIPPED,tm.a,' ',
#                   g_x[9] CLIPPED,
#                   tm.yy USING '<<<<','/',tm.bm USING'&&','-',tm.em USING'&&',' ',
#                   g_x[11] CLIPPED,l_unit
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     CASE WHEN sr.maj03 = '9'    #9:跳頁,本行印前跳頁
#            SKIP TO TOP OF PAGE
#          WHEN sr.maj03 = '3'    #3:底線,本行印出金額底線
#            PRINT COLUMN g_c[32],g_dash2[1,g_w[32]]
#          WHEN sr.maj03 = '4'    #4:橫線,本行印出整排橫線
#            PRINT g_dash2
#          OTHERWISE
#            FOR i = 1 TO sr.maj04 PRINT END FOR  #空行數
#            #maj05空格數,maj20科目列印名稱
#            PRINT COLUMN g_c[31],sr.maj20,
#                  COLUMN g_c[32],cl_numfor(sr.aah04_05,32,g_azi04)
#     END CASE
 
#  ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
#            COLUMN (g_len-9),g_x[7] CLIPPED
#  PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
#          COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          SKIP 2 LINE
#      END IF
 
#END REPORT
#No.FUN-860016----END
#No.FUN-890102
#Patch....NO.TQC-610035 <001> #
