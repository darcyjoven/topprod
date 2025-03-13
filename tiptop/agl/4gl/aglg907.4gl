# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg907.4gl
# Descriptions...: 總分類日記帳列印
# Input parameter:
# Return code....:
# Date & Author..: 92/03/31 By DAVID
# Modify.........: No.FUN-510007 05/01/14 By Nicola 報表架構修改
# Modify.........: No.MOD-530357 05/03/26 By echo 簽核欄位擠在一起
# Modify.........: No.MOD-530271 05/05/25 By echo 新增報表備註
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0022 06/12/01 By yjkhero 增加表尾  
# Modify.........: No.FUN-6B0022 06/12/04 By yjkhero 增加zz05列印條件
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/12 By bnlent 會計科目加帳套
# Modify.........: No.TQC-760105 07/06/12 By dxfwo aglg907(總分類日計帳) 科目層級無法輸入!
# Modify.........: No.FUN-790008 08/03/13 By dxfwo CR報表的制作
# Modify.........: No.MOD-850130 08/05/19 By Sarah 重覆下條件印報表資料會一直寫入Temptable(沒將舊資料清除)
# Modify.........: No.FUN-940013 09/04/30 By jan aag01 欄位增加開窗功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B20054 11/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B80158 11/09/19 By yangtt 明細類CR轉換成GRW
# Modify.........: No.FUN-C50005 12/05/04 By qirl GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc        LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(300) 
              bookno    LIKE aaa_file.aaa01,    #No.FUN-740020
              yyyy      LIKE type_file.num5,    #No.FUN-680098  smallint    
              mm        LIKE type_file.num5,    #No.FUN-680098  smallint    
              y         LIKE type_file.num5,    #No.FUN-680098  smallint    
              e         LIKE type_file.chr1,    #FUN-6C0012
              more      LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)     
           END RECORD,
       g_bdate       LIKE type_file.dat,     #No.FUN-680098  date
       g_edate       LIKE type_file.dat,     #No.FUN-680098  date   # Ended date
       g_aaa04       LIKE aaa_file.aaa04,  #No.FUN-680098 #現行會計年度 smallint
       g_aaa05       LIKE aaa_file.aaa05   #No.FUN-680098 #現行期別   smallint 
       #g_bookno      LIKE aaa_file.aaa01         #帳別  #No.FUN-670039   #No.FUN-740020 mark
DEFINE g_chr         LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1) 
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE l_table       STRING                  #No.FUN-790008                                                                 
DEFINE g_sql         STRING                  #No.FUN-790008                                                                 
DEFINE g_str         STRING                  #No.FUN-790008 
 
###GENGRE###START
TYPE sr1_t RECORD
    aag01 LIKE aag_file.aag01,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    d LIKE aah_file.aah04,
    c LIKE aah_file.aah05,
    b_bal LIKE aah_file.aah05,
    idate LIKE type_file.dat,
    debit LIKE aas_file.aas04,
    credit LIKE aas_file.aas05,
    l_d LIKE aah_file.aah04,
    l_c LIKE aah_file.aah05,
    l_amt LIKE aah_file.aah05,
    #FUN-B80158------add---str---
    l_bal1 LIKE aah_file.aah05,
    l_amt1 LIKE aah_file.aah05
    #FUN-B80158------add---end---
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-790008---Begin                                                                                                              
   LET g_sql = "aag01.aag_file.aag01, aag02.aag_file.aag02,",
               "aag13.aag_file.aag13, d.aah_file.aah04,",
               "c.aah_file.aah05,     b_bal.aah_file.aah05,",
               "idate.type_file.dat,  debit.aas_file.aas04,",
               "credit.aas_file.aas05,l_d.aah_file.aah04,",
               "l_c.aah_file.aah05,   l_amt.aah_file.aah05,",   #MOD-850130 add l_amt
               #FUN-B80158------add---str---
               "l_bal1.aah_file.aah05,",
               "l_amt1.aah_file.aah05"
               #FUN-B80158------add---end---
   LET l_table = cl_prt_temptable('aglg907',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"   #MOD-850130 add ?   FUN-B80158 add 2?
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
#No.FUN-790008---End
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET tm.bookno= ARG_VAL(1)           #No.FUN-740020
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.yyyy = ARG_VAL(9)
   LET tm.mm   = ARG_VAL(10)
   LET tm.y = ARG_VAL(11)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET tm.e = ARG_VAL(15)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   #No.FUN-740020  --Begin
   #IF g_bookno IS NULL OR g_bookno = ' ' THEN
   #   SELECT aaz64 INTO g_bookno FROM aaz_file
   #END IF
    IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF   #No.FUN-740020
   #No.FUN-740020  --End
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg907_tm()
   ELSE
      CALL aglg907()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION aglg907_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680098 smallint
          l_cmd       LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(400)   
DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054
 
   CALL s_dsmark(tm.bookno)    #No.FUN-740020
   LET p_row = 4 LET p_col = 30
   OPEN WINDOW aglg907_w AT p_row,p_col
     WITH FORM "agl/42f/aglg907"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)  #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.bookno = g_aza.aza81  #No.FUN-740020
 
   SELECT aaa04,aaa05,azi04 INTO tm.yyyy,tm.mm,g_azi04
   # FROM aaa_file, OUTER azi_file     # No.FUN-C50005 mark
     FROM aaa_file LEFT OUTER JOIN azi_file ON aaa03 = azi01  # No.FUN-C50005 add
    WHERE aaa01 = tm.bookno    #No.FUN-740020
   #  AND aaa_file.aaa03 = azi_file.azi01      # No.FUN-C50005 mark
 
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   DISPLAY BY NAME tm.bookno,tm.yyyy,tm.mm,tm.y,tm.e,tm.more  #No.FUN-B20054
   WHILE TRUE
#No.FUN-B20054--add-start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD bookno
              IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD  bookno
                END IF
             END IF
         END INPUT

#No.FUN-B20054--add-end--
 
      CONSTRUCT BY NAME tm.wc ON aag01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#         #FUN-940013--begin--add
#       ON ACTION controlp 
#           CASE 
#              WHEN INFIELD(aag01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c" 
#                   LET g_qryparam.form = "q_aag" 
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
#                   DISPLAY g_qryparam.multiret TO aag01
#                   NEXT FIELD aag01
#              OTHERWISE EXIT CASE
#           END CASE
#       #FUN-940013--end--add 
# 
#         ON ACTION locale
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
      END CONSTRUCT
#No.FUN-B20054--mark--start-- 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglg907_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
# 
#      DISPLAY BY NAME tm.bookno,tm.yyyy,tm.mm,tm.y,tm.e,tm.more  #FUN-6C0012   #No.FUN-740020                #No.TQC-760105
#      INPUT BY NAME tm.bookno,tm.yyyy,tm.mm,tm.y,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012  #No.FUN-740020  #No.TQC-760105
#No.FUN-B20054--mark--end-- 
       INPUT BY NAME tm.yyyy,tm.mm,tm.y,tm.e,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)    #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#         #No.FUN-740020  --Begin
#         AFTER FIELD bookno
#            IF tm.bookno  IS NULL THEN
#               NEXT FIELD bookno
#            END IF
#         #No.FUN-740020  --End
#No.FUN-B20054--mark--end--
         AFTER FIELD yyyy
            IF tm.yyyy  IS NULL THEN
               NEXT FIELD yyyy
            END IF
 
         AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.mm IS NULL THEN
               NEXT FIELD mm
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
#No.FUN-B20054--mark--start-- 
#         #No.FUN-740020  --Begin
#         ON ACTION CONTROLP
#          CASE
#            WHEN INFIELD(bookno)                                                                                                       
#              CALL cl_init_qry_var()                                                                                                 
#              LET g_qryparam.form = 'q_aaa'                                                                                          
#              LET g_qryparam.default1 = tm.bookno                                                                                     
#              CALL cl_create_qry() RETURNING tm.bookno                                                                                
#              DISPLAY BY NAME tm.bookno                                                                                               
#              NEXT FIELD bookno 
#          END CASE
#         #No.FUN-740020  --End
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
      END INPUT
#No.FUN-B20054--add--start--
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(bookno)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              LET g_qryparam.default1 = tm.bookno
              CALL cl_create_qry() RETURNING tm.bookno
              DISPLAY BY NAME tm.bookno
              NEXT FIELD bookno
            WHEN INFIELD(aag01)
              CALL cl_init_qry_var()
              LET g_qryparam.state    = "c"
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aag01
              NEXT FIELD aag01
            OTHERWISE EXIT CASE
          END CASE

       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION accept
          EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
  END DIALOG
#No.FUN-B20054--add--end--
 
      #CALL s_azm(tm.yyyy,tm.mm) RETURNING g_chr,g_bdate,g_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.yyyy,tm.mm,g_plant,tm.bookno) RETURNING g_chr,g_bdate,g_edate
      ELSE
         CALL s_azm(tm.yyyy,tm.mm) RETURNING g_chr,g_bdate,g_edate
      END IF
      #CHI-A70007 add --end--
 
#No.FUN-B20054--add--start--
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#No.FUN-B20054--add--end--
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglg907_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
#No.FUN-B20054--add--start--
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#No.FUN-B20054--add--end-- 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg907'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg907','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.bookno CLIPPED,"'",   #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        #-----TQC-610056---------
                        " '",tm.yyyy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.y CLIPPED,"'",
                        #-----END TQC-610056-----
                        " '",tm.e CLIPPED,"'",  #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg907',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg907_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg907()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg907_w
 
END FUNCTION
 
 
FUNCTION aglg907()
   DEFINE l_name      LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098  VARCHAR(20) 
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,           # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1000) 
          l_sql1      LIKE type_file.chr1000,           # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1000) 
          l_chr            LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
          sr     RECORD
                    aag01  LIKE aag_file.aag01,   # acct. no
                    aag02  LIKE aag_file.aag02,   # acct. name        #No.A056
                    aag13  LIKE aag_file.aag13,   #FUN-6C0012
                    aag07  LIKE aag_file.aag07,   # acct. name        #
                    aag24  LIKE aag_file.aag24,   # acct. name        #
                    idate  LIKE type_file.dat,     # accumulated date    #No.FUN-680098    date
                    b_bal  LIKE aah_file.aah05,
                    b_d    LIKE aah_file.aah04,
                    b_c    LIKE aah_file.aah05,
                    debit  LIKE aas_file.aas04,
                    credit LIKE aas_file.aas05,
                    l_d    LIKE aah_file.aah04,
                    l_c    LIKE aah_file.aah05,
                    #FUN-B80158-----add----str---
                    l_bal1 LIKE aah_file.aah05,
                    l_amt1 LIKE aah_file.aah05
                    #FUN-B80158-----add----end---
                 END RECORD
    DEFINE l_bal,l_amt     LIKE aah_file.aah05 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)   #MOD-850130 add
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno   #No.FUN-740020
      AND aaf02 = g_lang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
   #No.A056
   LET l_sql1= "SELECT aag01,aag02,aag13,aag07,aag24,'',0,0,0,0,0,0,0,0,0",  #FUN-6C0012   FUN-B80158 add 2 0
               "  FROM aag_file ",
               " WHERE aag03 ='2' AND aag07 IN ('1','3') ",
               "   AND aag00 = '",tm.bookno,"'",    #No.FUN-740020
               "   AND ",tm.wc CLIPPED
   #No.A056 end
 
   PREPARE aglg907_prepare2 FROM l_sql1
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add     
      EXIT PROGRAM
   END IF
   DECLARE aglg907_curs2 CURSOR FOR aglg907_prepare2
 
#  CALL cl_outnam('aglg907') RETURNING l_name   #No.FUN-790008
#  START REPORT aglg907_rep TO l_name           #No.FUN-790008
   CALL cl_del_data(l_table)                    #No.FUN-790008
 
   LET g_pageno = 0
 
   FOREACH aglg907_curs2 INTO sr.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
     #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN  #CHI-710005
      IF NOT cl_null(tm.y) THEN #CHI-710005
         IF sr.aag07 = '1' AND sr.aag24 != tm.y THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      LET sr.idate = g_bdate
      #------- year begin balance ------------------------------------------------
      SELECT sum(aah04-aah05) INTO sr.b_bal FROM aah_file
       WHERE aah00 = tm.bookno     #No.FUN-740020
         AND aah01 = sr.aag01
         AND aah02 = tm.yyyy
         AND aah03 = 0
 
      IF sr.b_bal IS NULL THEN
         LET sr.b_bal = 0
      END IF
 
      #------- month begin D / C ------------------------------------------------
      SELECT sum(aah04),SUM(aah05) INTO sr.b_d,sr.b_c FROM aah_file
       WHERE aah00 = tm.bookno    #No.FUN-740020
         AND aah01 = sr.aag01
         AND aah02 = tm.yyyy
         AND aah03 >= 1
         AND aah03 < tm.mm
 
      IF sr.b_d IS NULL THEN
         LET sr.b_d = 0
      END IF
 
      IF sr.b_c IS NULL THEN
         LET sr.b_c = 0
      END IF
 
      #------- monthly tot D / C ------------------------------------------------
      SELECT sum(aah04),SUM(aah05) INTO sr.l_d,sr.l_c FROM aah_file
       WHERE aah00 = tm.bookno    #No.FUN-740020
         AND aah01 = sr.aag01
         AND aah02 = tm.yyyy
         AND aah03 = tm.mm
 
      IF sr.l_d IS NULL THEN
         LET sr.l_d = 0
      END IF
 
      IF sr.l_c IS NULL THEN
         LET sr.l_c = 0
      END IF
 
      #------- daily's D/C ------------------------------------------------------
      IF sr.b_bal=0 AND sr.b_d=0 AND sr.b_c=0 AND sr.l_d=0 AND sr.l_c=0 THEN
         CONTINUE FOREACH
      END IF
 
      LET l_bal = sr.b_bal                  #MOD-850130 add
      LET l_bal = l_bal + sr.b_d - sr.b_c   #MOD-850130 add
      WHILE TRUE
         LET sr.debit = 0
         LET sr.credit = 0
 
         SELECT aas04,aas05 INTO sr.debit,sr.credit
           FROM aas_file
          WHERE aas00 = tm.bookno   #No.FUN-740020
            AND aas01 = sr.aag01
            AND aas02 = sr.idate
 
         IF sr.debit IS NULL THEN
            LET sr.debit = 0
         END IF
 
         IF sr.credit IS NULL THEN
            LET sr.credit = 0
         END IF
 
#No.FUN-790008---Begin                                                                                                              
        #str MOD-850130 mark
        #LET l_bal = sr.b_bal                                                                                                        
        #IF l_bal >= 0 THEN                                                                                                         
        #   LET l_amt = l_bal                                                                                                       
        #ELSE                                                                                                                       
        #   LET l_amt = l_bal * -1                                                                                                  
        #END IF                                                                                                                     
        #LET l_bal = l_bal + sr.b_d - sr.b_c                                                                                        
        #IF l_bal >= 0 THEN                                                                                                         
        #   LET l_amt = l_bal                                                                                                       
        #ELSE                                                                                                                       
        #   LET l_amt = l_bal * -1                                                                                                  
        #END IF                                                                                                                     
        #end MOD-850130 mark
         LET l_bal = l_bal + sr.debit - sr.credit                                                                                   
                                                                                                                                    
         LET l_amt = l_bal   #MOD-850130 add
        #str MOD-850130 mark
        #IF l_bal >= 0 THEN                                                                                                         
        #   LET l_amt = l_bal                                                                                                       
        #ELSE                                                                                                                       
        #   LET l_amt = l_bal * -1                                                                                                  
        #END IF                                                                                                                     
        #end MOD-850130 mark
#No.FUN-790008---End 

         #FUN-B80158-------add---str----
         LET sr.l_bal1 = sr.b_bal + sr.debit - sr.credit
         IF sr.l_bal1 >= 0 THEN
            LET sr.l_amt1 = sr.l_bal1
         ELSE
            LET sr.l_amt1 = sr.l_bal1
         END IF
         #FUN-B80158-------add---end----

#No.FUN-790008---Begin
#        OUTPUT TO REPORT aglg907_rep(sr.*)
         EXECUTE insert_prep USING
            sr.aag01,sr.aag02,sr.aag13,sr.b_d,sr.b_c,sr.b_bal,                                              
            sr.idate,sr.debit,sr.credit,sr.l_d,sr.l_c,l_amt,   #MOD-850130 add l_amt
            sr.l_bal1,sr.l_amt1             #FUN-B80158 add
 
         LET sr.idate = sr.idate + 1
 
         IF sr.idate > g_edate THEN
            EXIT WHILE
         END IF
 
      END WHILE
   END FOREACH
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(tm.wc,'aag01')                                                                                                 
            RETURNING tm.wc                                                                                                         
       LET g_str = tm.wc                                                                                                            
    END IF                                                                                                                          
###GENGRE###     LET g_str = tm.wc,";",tm.e,";",g_azi04                                                                                         
###GENGRE###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                             
###GENGRE###     CALL cl_prt_cs3('aglg907','aglg907',l_sql,g_str)
    CALL aglg907_grdata()    ###GENGRE###
 
#  FINISH REPORT aglg907_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-790008---End 
 
END FUNCTION
 
#REPORT aglg907_rep(sr)
#  DEFINE sr     RECORD
#                   aag01  LIKE aag_file.aag01,   # acct. no
#                   aag02  LIKE aag_file.aag02,   # acct. name     #No.A056
#                   aag13  LIKE aag_file.aag13,   #FUN-6C0012
#                   aag07  LIKE aag_file.aag07,   # acct. name     #
#                   aag24  LIKE aag_file.aag24,   # acct. name     #
#                   idate  LIKE type_file.dat,    #No.FUN-680098    DATE
#                   b_bal  LIKE aah_file.aah05,
#                   b_d    LIKE aah_file.aah04,
#                   b_c    LIKE aah_file.aah05,
#                   debit  LIKE aas_file.aas04,
#                   credit LIKE aas_file.aas05,
#                   l_d    LIKE aah_file.aah04,
#                   l_c    LIKE aah_file.aah05
#             END RECORD
#  DEFINE l_bal,l_amt     LIKE aah_file.aah05
#  DEFINE g_head1         STRING
#  DEFINE l_last_sw       LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1)   
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.aag01,sr.idate
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#        PRINT g_dash1
#
#     BEFORE GROUP OF sr.aag01
#        SKIP TO TOP OF PAGE
 
#        PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#              COLUMN g_c[32],sr.aag01;
#              COLUMN g_c[33],g_x[10] CLIPPED,  #FUN-6C0012 mark
#              COLUMN g_c[34],sr.aag02          #FUN-6C0012 mark
#        #FUN-6C0012.....begin
#        IF tm.e = 'Y' THEN
#           PRINT COLUMN g_c[33],g_x[10] CLIPPED,sr.aag13
#        ELSE
#           PRINT COLUMN g_c[33],g_x[10] CLIPPED,sr.aag02
#        END IF
#        #FUN-6C0012.....end
#        PRINT '  '
 
#        LET l_bal = sr.b_bal
 
#        IF l_bal >= 0 THEN
#           LET l_amt = l_bal
#        ELSE
#           LET l_amt = l_bal * -1
#        END IF
 
#        PRINT
#        PRINT COLUMN g_c[31],g_x[16] CLIPPED,
#              COLUMN g_c[34],cl_numfor(l_amt,34,g_azi04);
 
#        IF l_bal >= 0 THEN
#           PRINT COLUMN g_c[35],'D'
#        ELSE
#           PRINT COLUMN g_c[35],'C'
#        END IF
 
#        PRINT
#        LET l_bal = l_bal + sr.b_d - sr.b_c
 
#        IF l_bal >= 0 THEN
#           LET l_amt = l_bal
#        ELSE
#           LET l_amt = l_bal * -1
#        END IF
 
#        PRINT COLUMN g_c[31],g_x[17] CLIPPED,
#              COLUMN g_c[32],cl_numfor(sr.b_d,32,g_azi04),
#              COLUMN g_c[33],cl_numfor(sr.b_c,33,g_azi04),
#              COLUMN g_c[34],cl_numfor(l_amt,34,g_azi04);
 
#        IF l_bal >= 0 THEN
#           PRINT COLUMN g_c[35],'D'
#        ELSE
#           PRINT COLUMN g_c[35],'C'
#        END IF
#        PRINT
#         LET l_last_sw='n'                #MOD-530271
 
#     ON EVERY ROW
#        LET l_bal = l_bal + sr.debit - sr.credit
 
#        IF l_bal >= 0 THEN
#           LET l_amt = l_bal
#        ELSE
#           LET l_amt = l_bal * -1
#        END IF
 
#        PRINT COLUMN g_c[31],sr.idate,
#              COLUMN g_c[32],cl_numfor(sr.debit,32,g_azi04),
#              COLUMN g_c[33],cl_numfor(sr.credit,33,g_azi04),
#              COLUMN g_c[34],cl_numfor(l_amt,34,g_azi04);
 
#        IF l_bal >= 0 THEN
#           PRINT COLUMN g_c[35],'D'
#        ELSE
#           PRINT COLUMN g_c[35],'C'
#        END IF
#
#     AFTER GROUP OF sr.aag01
#        PRINT
#        PRINT COLUMN g_c[31],g_x[18] CLIPPED,
#              COLUMN g_c[32],cl_numfor(sr.l_d,32,g_azi04),
#              COLUMN g_c[33],cl_numfor(sr.l_c,33,g_azi04)
#        LET sr.l_d = sr.b_d + sr.l_d
#        LET sr.l_c = sr.b_c + sr.l_c
#        PRINT
#        PRINT COLUMN g_c[31],g_x[19] CLIPPED,
#              COLUMN g_c[32],cl_numfor(sr.l_d,32,g_azi04),
#              COLUMN g_c[33],cl_numfor(sr.l_c,33,g_azi04)
 
#   ## MOD-530271  ##
#     # PAGE TRAILER                                     #No.MOD-530363
#    #    PRINT g_dash[1,g_len]
#    #    PRINT g_x[11] CLIPPED,COLUMN 14,g_x[12] CLIPPED,COLUMN 27,g_x[13] CLIPPED,
#    #          COLUMN 40,g_x[14] CLIPPED,COLUMN 53,g_x[15] CLIPPED
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[11]
#      PRINT g_memo
#NO.FUN-6B0022--BEGIN                                                                                                               
#     IF  g_zz05 = 'Y' THEN                                                                                                         
#         CALL cl_wcchp(tm.wc,'aag01')                                                                                              
#              RETURNING tm.wc                                                                                                      
#         PRINT g_dash                                                                                                              
#         CALL cl_prt_pos_wc(tm.wc)                                                                                                 
#     END IF                                                                                                                        
#    PRINT g_dash                                                                                                                   
#       PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED                                                 
#        PRINT g_x[11]                                                                                                              
#        PRINT g_memo                                                                                                               
#NO.FUN-6B0022--END 
 
#   PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     IF l_last_sw= 'n' THEN
#        IF g_memo_pagetrailer THEN
#             PRINT g_dash[1,g_len]                                                 #NO.FUN-6B0022      
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED         #NO.FUN-6B0022     
#             PRINT g_x[11]                                                        #NO.FUN-6B0022  
#             PRINT g_memo
#        ELSE 
#             PRINT g_dash[1,g_len]                                                 #NO.FUN-6B0022            
#             PRINT g_x[4],g_x[5],COLUMN (g_len-9),g_x[6] CLIPPED                   #NO.FUN-6B0022    
#             PRINT                                                                 
#             PRINT
#        END IF
#     ELSE  SKIP 4 LINE
#     END IF
 
#   ##END MOD-530271 ##
 
#END REPORT

###GENGRE###START
FUNCTION aglg907_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg907")
        IF handler IS NOT NULL THEN
            START REPORT aglg907_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY aag01,idate"         #FUN-B80158 add
          
            DECLARE aglg907_datacur1 CURSOR FROM l_sql
            FOREACH aglg907_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg907_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg907_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg907_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158------add-----str---
    DEFINE l_jd     LIKE type_file.chr1
    DEFINE l_jd1    LIKE type_file.chr1
    DEFINE l_jd2    LIKE type_file.chr1
    DEFINE l_amt    LIKE aah_file.aah05
    DEFINE l_amt2   LIKE aah_file.aah05
    DEFINE l_bal    LIKE aah_file.aah05
    DEFINE l_d1     LIKE aah_file.aah05
    DEFINE l_c1     LIKE aah_file.aah05
    DEFINE l_qt     STRING
    DEFINE l_RTotal_bal LIKE aah_file.aah05
    DEFINE l_bal_fmt STRING
    DEFINE l_amt_fmt STRING
    DEFINE l_d_c_fmt STRING
    #FUN-B80158------add-----end---

    
    ORDER EXTERNAL BY sr1.aag01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-B80158 add g_ptime.g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aag01
            #FUN-B80158------add---str----
            IF sr1.b_bal >= 0 THEN
               LET l_bal = sr1.b_bal
            ELSE
               LET l_bal = sr1.b_bal * (-1)
            END IF
            PRINTX l_bal
 
            IF (sr1.b_bal + sr1.d - sr1.c) >= 0THEN
               LET l_amt = sr1.b_bal + sr1.d - sr1.c
            ELSE
               LET l_amt = (sr1.b_bal + sr1.d - sr1.c) * (-1)
            END IF
            PRINTX l_amt

            IF sr1.b_bal >= 0 THEN
               LET l_jd = 'D'
            ELSE 
               LET l_jd = 'C'
            END IF
            PRINTX l_jd

            IF (sr1.b_bal + sr1.d - sr1.c) >= 0 THEN
               LET l_jd2 = 'D'
            ELSE 
               LET l_jd2 = 'C'
            END IF
            PRINTX l_jd2

            IF tm.e = 'Y' THEN
               LET l_qt = cl_gr_getmsg("gre-230",g_lang,1),':',sr1.aag13
            ELSE
               LET l_qt = cl_gr_getmsg("gre-230",g_lang,1),':',sr1.aag02
            END IF
            PRINTX l_qt
            LET l_bal_fmt = cl_gr_numfmt("aah_file","aah05",g_azi04)
            PRINTX l_bal_fmt
            #FUN-B80158------add---end----

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158------add---str----
            IF sr1.l_amt >= 0 THEN
               LET l_amt2 = sr1.l_amt
            ELSE
               LET l_amt2 = sr1.l_amt * (-1)
            END IF
            PRINTX l_amt2

            IF sr1.l_amt >= 0 THEN
               LET l_jd1 = 'D'
            ELSE 
               LET l_jd1 = 'C'
            END IF
            PRINTX l_jd1

            LET l_amt_fmt = cl_gr_numfmt("aah_file","aah05",g_azi04)
            PRINTX l_amt_fmt
            #FUN-B80158------add---end----

            PRINTX sr1.*

        AFTER GROUP OF sr1.aag01
            #FUN-B80158------add---str----
            LET l_d1 = sr1.d + sr1.l_d
            PRINTX l_d1
            LET l_c1 = sr1.c + sr1.l_c
            PRINTX l_c1
            LET l_RTotal_bal = GROUP SUM(sr1.l_amt1)
            PRINTX l_RTotal_bal

            LET l_d_c_fmt = cl_gr_numfmt("aah_file","aah05",g_azi04)
            PRINTX l_d_c_fmt
            #FUN-B80158------add---end----

        
        ON LAST ROW

END REPORT
###GENGRE###END
