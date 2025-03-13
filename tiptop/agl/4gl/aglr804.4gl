# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr804.4gl
# Descriptions...: 科目異動碼累計餘額表
# Input parameter:
# Return code....:
# Date & Author..: 92/09/25 By yen
#                  By Melody    aee00 改為 no-use
# Modify.........: No.FUN-510007 05/01/11 By Nicola 報表架構修改
# Modify.........: No.MOD-5A0015 05/10/07 By Smapmin 表頭多秀出年月份
# Modify.........: No: FUN-5C0015 06/01/05 By kevin
#                  畫面QBE加aed012異動碼類型代號，^p q_ahe。
#                  (p_zaa)序號33放寬至30
# Modify.........: No.TQC-610133 06/02/07 By Smapmin 報表格式修改
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie   調整“接下頁/結束”位置 
# Modify.........: No.FUN-6B0022 06/12/04 By yjkhero 無公司名稱輸出問題修改
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱功能
# Modify.........: No.MOD-740006 07/04/02 By Smapmin 修改SQL條件
# Modify.........: No.FUN-740020 07/04/09 By hongmei 會計科目加帳套-財務
# Modify.........: No.MOD-750011 07/05/03 By Smapmin 以的方式串聯aee_file
# Modify.........: No.FUN-780059 07/08/28 By xiaofeizhu 報表改寫由Crystal Report產出
# Modify.........: No.MOD-910068 09/01/08 By Nicola 多加帳別判斷
# Modify.........: No.TQC-910020 09/03/04 By Sarah aee_file多加帳別判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A90136 10/09/20 By Dido 期初計算需增加aed011異動碼順序條件
# Modify.........: No:MOD-AA0064 10/10/12 By Dido 由於 aee_file 畫面為 QBE 條件,因此需取消 OUTER 
# Modify.........: No.FUN-B20054 11/02/22 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD
              wc      LIKE type_file.chr1000,# Where condition   #No.FUN-680098   VARCHAR(300)
              aed03   LIKE type_file.num10,  # 年度    #No.FUN-680098 integer
              aed04   LIKE aed_file.aed04,   # 期別
              t       LIKE type_file.chr1,   # 每一科目列印完是否跳頁(Y/N)    #No.FUN-680098 VARCHAR(1) 
              b       LIKE type_file.chr1,   # 餘額為零者是否列印(Y/N)        #No.FUN-680098 VARCHAR(1)
              w       LIKE type_file.chr1,   # 依何項科目分類排列(1/2/3/4)    #No.FUN-680098 VARCHAR(1)
              x       LIKE type_file.chr1,   # 科目分類列印後是否跳頁(Y/N)    #No.FUN-680098 VARCHAR(1)
              e       LIKE type_file.chr1,   #FUN-6C0012
              more    LIKE type_file.chr1,   # Input more condition(Y/N)      #No.FUN-680098 VARCHAR(1)
              bookno  LIKE aaa_file.aaa01    #No.FUN-740020
           END RECORD,
           g_aaa      RECORD LIKE aaa_file.* 
#          g_bookno   LIKE aaa_file.aaa01     #帳別  #No.FUN-740020
DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680098 integer
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_msg        LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(72)
#--str FUN-780059 add--#                                                                                                            
DEFINE   l_table      STRING                                                                                                    
DEFINE   g_sql        STRING                                                                                                    
DEFINE   g_str        STRING                                                                                                    
#--end FUN-780059 add--#  
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 #--str FUN-780059 add--#                                                                                                           
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                          
   LET g_sql = "aed01.aed_file.aed01,",       
               "aed02.aed_file.aed02,",
               "d_c.aed_file.aed05,",
               "d.aed_file.aed05,",
               "c.aed_file.aed06,",
               "d_c2.aed_file.aed05,",     
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,", 
               "aag223.aag_file.aag223,", 
               "aag224.aag_file.aag224,",
               "aag225.aag_file.aag225,",      
               "aag226.aag_file.aag226,",
               "aae02.aae_file.aae02"                                                                        
                                                                                                                                    
   LET l_table = cl_prt_temptable('aglr804',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                       
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                   
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #------------------------------ CR (1) ------------------------------#
   LET tm.bookno= ARG_VAL(1)         #No.FUN-740020
   LET g_pdate = ARG_VAL(2)         # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.aed03  = ARG_VAL(9)
   LET tm.aed04  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   LET tm.x  = ARG_VAL(13)   #TQC-610056
   LET tm.w  = ARG_VAL(14)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No.FUN-570264 ---end---
   LET tm.e  = ARG_VAL(18)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
#No.FUN-740020---Begin
#  IF g_bookno IS NULL OR g_bookno = ' ' THEN
#     LET g_bookno = g_aaz.aaz64
#  END IF
#No.FUN-740020---End
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr804_tm(0,0)
   ELSE
      CALL aglr804()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr804_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_cmd       LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno    LIKE type_file.num5           #No.FUN-B20054

 
#  CALL s_dsmark(g_bookno)       #No.FUN-740020
   CALL s_dsmark(tm.bookno)      #No.FUN-740020
   LET p_row = 2 LET p_col = 16
   OPEN WINDOW aglr804_w AT p_row,p_col
     WITH FORM "agl/42f/aglr804"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)        #No.FUN-740020
   CALL s_shwact(0,0,tm.bookno)       #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.aed03 = YEAR(TODAY)
   LET tm.t     = 'N'
   LET tm.b     = 'N'
   LET tm.w     = '1'
   LET tm.x     = 'N'
#  LET tm.bookno = '00' #No.FUN-740020 
   LET tm.bookno = g_aza.aza81    #No.FUN-B20054
   LET tm.e     = 'N'   #FUN-6C0012
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   DISPLAY BY NAME tm.aed03,tm.bookno,tm.t,tm.b,tm.e,tm.more                #FUN-B20054
   WHILE TRUE
#NO.FUN-B20054--add--start--
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
                   NEXT FIELD bookno
                END IF
             END IF
             IF tm.bookno = '*' THEN
                NEXT FIELD bookno
             END IF

         END INPUT

#NO.FUN-B20054--add--end-- 
      #  FUN-5C0015 mod (s)
      #  add aed012
      #CONSTRUCT BY NAME tm.wc ON aed01,aed011,aed02,aee05
      CONSTRUCT BY NAME tm.wc ON aed01,aed011,aed012,aed02,aee05
      #  FUN-5C0015 mod (e)
 
         # FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#         ON ACTION controlp
#            CASE
#              WHEN INFIELD(aed012) #異動碼類型代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_ahe"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aed012
#                NEXT FIELD aed012
#              OTHERWISE EXIT CASE
#            END CASE
#         # FUN-5C0015 (e)
# 
#         ON ACTION locale
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
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
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglr804_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#No.FUN-B20054--mark--end--

#No.FUN-740020 ---Begin 
#     DISPLAY BY NAME tm.aed03,tm.t,tm.b,tm.e,tm.more   #FUN-6C0012
#     INPUT BY NAME tm.aed03,tm.aed04,tm.t,tm.b,tm.x,tm.w,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012
#     DISPLAY BY NAME tm.aed03,tm.bookno,tm.t,tm.b,tm.e,tm.more                #FUN-B20054
#      INPUT BY NAME tm.aed03,tm.aed04,tm.bookno,tm.t,tm.b,tm.x,tm.w,tm.e,tm.more WITHOUT DEFAULTS   #FUN-B20054
       INPUT BY NAME tm.aed03,tm.aed04,tm.t,tm.b,tm.x,tm.w,tm.e,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
#No.FUN-740020 -- end --
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD aed03
            IF  cl_null(tm.aed03) THEN
                NEXT FIELD aed03
            END IF
 
#No.FUN-B20054--mark--start--
##No.FUN-740020 -- begin --                                                                                                          
#         AFTER FIELD bookno                                                                                                         
#            IF tm.bookno = '*' THEN                                                                                                 
#               NEXT FIELD bookno                                                                                                    
#            END IF                                                                                                                  
##No.FUN-740020 -- end --
#No.FUN-B20054--mark--end--
 
         BEFORE FIELD t
            IF cl_null(tm.aed04) OR tm.aed04 > 13 THEN
               CALL cl_err('aed04','agl-013',0)
               NEXT FIELD aed04
            END IF
 
         AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN
               NEXT FIELD t
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES "[YN]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF

#No.FUN-B20054--mark--start--
##No.FUN-740020 -- begin --                                                                                                          
#         ON ACTION CONTROLP                                                                                                         
#            CASE                                                                                                                    
#              WHEN INFIELD(bookno)                                                                                                  
#                CALL cl_init_qry_var()                                                                                              
#                LET g_qryparam.form     = "q_aaa"                                                                                   
#                LET g_qryparam.state    = "i"                                                                                       
#                CALL cl_create_qry() RETURNING tm.bookno                                                                            
#                LET tm.bookno = tm.bookno                                                                                           
#                DISPLAY tm.bookno TO FORMONLY.bookno                                                                                
#                NEXT FIELD bookno                                                                                                   
#              OTHERWISE EXIT CASE                                                                                                   
#            END CASE                                                                                                                
##No.FUN-740020 -- end -- 
# 
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
#No.FUN-B20054--mark--end-- 
      END INPUT
#No.FUN-B20054--add--start--
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bookno)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aaa"
                LET g_qryparam.state    = "i"
                CALL cl_create_qry() RETURNING tm.bookno
                LET tm.bookno = tm.bookno
                DISPLAY tm.bookno TO FORMONLY.bookno
                NEXT FIELD bookno
               WHEN INFIELD(aed01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aed01
                  NEXT FIELD aed01
              WHEN INFIELD(aed012) #異動碼類型代號
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_ahe"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aed012
                NEXT FIELD aed012
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
 
#No.FUN-B20054--add--start--
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#No.FUN-B20054--add--end--


     IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr804_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 

#No.FUN-B20054--add--start--
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#No.FUN-B20054--add--end--

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr804'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err('aglr804','9031',1) 
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                #       " '",g_bookno CLIPPED,"' ",    #No.FUN-740020                                                                  
                        " '",tm.bookno CLIPPED,"'",    #No.FUN-740020 
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.aed03 CLIPPED,"'",
                        " '",tm.aed04 CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.x CLIPPED,"'",   #TQC-610056
                        " '",tm.w CLIPPED,"'",   #TQC-610056
                        " '",tm.e CLIPPED,"'",   #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr804',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglr804_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr804()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr804_w
 
END FUNCTION
 
FUNCTION aglr804()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098CHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
          sr        RECORD order1 LIKE aae_file.aae01, #No.FUN-680098 VARCHAR(5)
                           aed00 LIKE aed_file.aed00,  #No.FUN-740020
                           aed01 LIKE aed_file.aed01,  # 科目編號
                           aed011 LIKE aed_file.aed011,
                           aed02 LIKE aed_file.aed02,  # 異動碼
                           d_c   LIKE aed_file.aed05,  # 金額
                           d     LIKE aed_file.aed05,  #TQC-610133
                           c     LIKE aed_file.aed06,  #TQC-610133
                           d_c2  LIKE aed_file.aed05,  #TQC-610133
                           aag02 LIKE aag_file.aag02,  # 科目名稱
                           aag13 LIKE aag_file.aag13,  #FUN-6C0012
                           aag15 LIKE aag_file.aag15,  # 異動碼-1 說明
                           aag16 LIKE aag_file.aag16,  # 異動碼-2 說明
                           aag17 LIKE aag_file.aag17,  # 異動碼-3 說明
                           aag18 LIKE aag_file.aag18,  # 異動碼-4 說明
                           aag223 LIKE aag_file.aag223,  # 分類碼-1
                           aag224 LIKE aag_file.aag224,  # 分類碼-2
                           aag225 LIKE aag_file.aag225,  # 分類碼-3
                           aag226 LIKE aag_file.aag226,  # 分類碼-4
                           aee04 LIKE aee_file.aee04,  # 異動碼說明
                           aee05 LIKE aee_file.aee05,  #
                           aee06 LIKE aee_file.aee06
                    END RECORD
   DEFINE      l_aae02     LIKE aae_file.aae02          #FUN-780059
 
   #--str FUN-780059 add--#                                                                                                         
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                            
   CALL cl_del_data(l_table) 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                                                       
   #------------------------------ CR (2) ------------------------------#                                                           
   #--end FUN-780059 add--#
   SELECT aaf03 INTO g_company FROM aaf_file
#   WHERE aaf01 = g_bookno             #No.FUN-740020                                                                                    
    WHERE aaf01 = tm.bookno            #No.FUN-740020
#    AND aaf02 = g_rlangv              #NO.FUN-6B0022
     AND aaf02 = g_rlang               #NO.FUN-6B0022
   SELECT * INTO g_aaa.* FROM aaa_file
    WHERE aaa01 = g_bookno
 
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file        #No.CHI-6A0004 g_azi-->t_azi
    WHERE azi01 = g_aaa.aaa03
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aeeuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aeegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aeegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aeeuser', 'aeegrup')
   #End:FUN-980030
 
 
#  LET l_sql = "SELECT '',aed01, aed011, aed02, SUM(aed05-aed06)",               #NO.FUN-780059
   LET l_sql = "SELECT '','',aed01, aed011, aed02, SUM(aed05-aed06)",            #NO.FUN-780059
               "  FROM aed_file,aee_file",   #MOD-750011        #MOD-AA0064 remark
              #"  FROM aed_file,OUTER aee_file",   #MOD-750011  #MOD-AA0064 mark
               " WHERE aed03 = '",tm.aed03,"'",
               "   AND aed04 <= '",tm.aed04,"'",
               "   AND aed00 =aee00 ",   #No.MOD-910068 
               "   AND aed01 =aee01 ",                
               "   AND aed011=aee02 ",               
               "   AND aed02 =aee03 ",             
        #      "   AND aed00 ='",g_bookno,"'",     #No.FUN-740020
               "   AND aed00 ='",tm.bookno,"'",    #No.FUN-740020
               "   AND ",tm.wc CLIPPED,
               " GROUP BY aed01,aed011,aed02 "
 
   PREPARE aglr804_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr804_curs1 CURSOR FOR aglr804_prepare1
 
#  CALL cl_outnam('aglr804') RETURNING l_name               #FUN-780059--mark
#  START REPORT aglr804_rep TO l_name                       #FUN-780059--mark
 
   LET g_pageno = 0
   INITIALIZE sr.* TO NULL
 
   FOREACH aglr804_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF tm.b = 'N' AND sr.d_c = 0 THEN
         CONTINUE FOREACH
      END IF
 
      #-----TQC-610133---------
         SELECT SUM(aed05-aed06) INTO sr.d_c2 FROM aed_file
            #WHERE ((aed03 = tm.aed03 AND aed04 < tm.aed04) OR aed03 < tm.aed03)    #MOD-740006
            WHERE aed03 = tm.aed03 AND aed04 < tm.aed04    #MOD-740006
              AND aed01 = sr.aed01
              AND aed02 = sr.aed02
              AND aed011= sr.aed011   #MOD-A90136
  #           AND aed00 = g_bookno    #No.FUN-740020
              AND aed00 = tm.bookno   #No.FUN-740020
         SELECT SUM(aed05),SUM(aed06) INTO sr.d,sr.c FROM aed_file
            WHERE aed03 = tm.aed03
              AND aed04 = tm.aed04
              AND aed01 = sr.aed01
              AND aed02 = sr.aed02
              AND aed011= sr.aed011   #MOD-A90136
  #           AND aed00 = g_bookno    #No.FUN-740020                                                                                
              AND aed00 = tm.bookno   #No.FUN-740020
 
         IF cl_null(sr.d_c2) THEN LET sr.d_c2 = 0 END IF
         IF cl_null(sr.d) THEN LET sr.d = 0 END IF
         IF cl_null(sr.c) THEN LET sr.c = 0 END IF
      #-----END TQC-610133-----
 
      SELECT aag02,aag13,aag15,aag16,aag17,aag18,aag223,aag224,aag225,aag226   #FUN-6C0012
        INTO sr.aag02,sr.aag13,sr.aag15,sr.aag16,sr.aag17,sr.aag18,                     #FUN-6C0012
             sr.aag223,sr.aag224,sr.aag225,sr.aag226
        FROM aag_file
       WHERE aag01 = sr.aed01
         AND aag00 = tm.bookno      #NO.FUN-740020
 
      IF SQLCA.sqlcode THEN
         LET sr.aag02 = ' '
         LET sr.aag13 = ' '   #FUN-6C0012
         LET sr.aag15 = ' '
         LET sr.aag16 = ' '
         LET sr.aag17 = ' '
         LET sr.aag18 = ' '
         LET sr.aag223= ' '
         LET sr.aag224= ' '
         LET sr.aag225= ' '
         LET sr.aag226= ' '
      END IF
 
      SELECT aee04,aee05,aee06
        INTO sr.aee04,sr.aee05,sr.aee06
        FROM aee_file
       WHERE aee01 = sr.aed01
         AND aee02 = sr.aed011
         AND aee03 = sr.aed02
         AND aee00 = tm.bookno   #TQC-910020 add
 
      CASE WHEN tm.w = '1' LET sr.order1 = sr.aag223
           WHEN tm.w = '2' LET sr.order1 = sr.aag224
           WHEN tm.w = '3' LET sr.order1 = sr.aag225
           WHEN tm.w = '4' LET sr.order1 = sr.aag226
           OTHERWISE       LET sr.order1 = ' '
      END CASE
#--str-FUN-780059--add--#
         SELECT aae02 INTO l_aae02 FROM aae_file WHERE aae01 = sr.order1                                                            
         IF STATUS THEN                                                                                                             
            LET l_aae02 = NULL                                                                                                      
         END IF
#--end-FUN-780059--add--#
#     OUTPUT TO REPORT aglr804_rep(sr.*)                 #FUN-780059--mark
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING              
                      sr.aed01,sr.aed02,sr.d_c,sr.d,sr.c,sr.d_c2,sr.aag02,sr.aag13,
                      sr.aag223,sr.aag224,sr.aag225,sr.aag226,l_aae02                                                                                   
          #------------------------------ CR (3) ------------------------------#
 
      INITIALIZE sr.* TO NULL
 
   END FOREACH
 
#  FINISH REPORT aglr804_rep                             #FUN-780059--mark
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #FUN-780059--mark
#-str-FUN-780059--add--#                                                                                                            
         IF g_zz05 = 'Y' THEN                                                                                                       
            CALL cl_wcchp(tm.wc,'aed01,aed011,aed012,aed02,aee05') RETURNING tm.wc                                                                            
         END IF                                                                                                                     
#-end-FUN-780059--add--#
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.w,";",tm.aed03,";",tm.aed04,";",tm.e,";",                                                          
                tm.x,";",tm.t,";",t_azi04,";",t_azi05                                                                                        
    CALL cl_prt_cs3('aglr804','aglr804',l_sql,g_str)                                                                                  
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#--str-FUN-780059--mark--#
#REPORT aglr804_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,                 #No.FUN-680098 VARCHAR(1)
#         sr           RECORD order1 LIKE aae_file.aae01,        #No.FUN-680098 VARCHAR(4)
#                             aed00 LIKE aed_file.aed00,  #No.FUN-740020
#                             aed01 LIKE aed_file.aed01,  # 科目編號
#                             aed011 LIKE aed_file.aed011,
#                             aed02 LIKE aed_file.aed02,  # 異動碼
#                             d_c   LIKE aed_file.aed05,  # 金額
#                             d     LIKE aed_file.aed05,  #TQC-610133
#                             c     LIKE aed_file.aed06,  #TQC-610133
#                             d_c2  LIKE aed_file.aed05,  #TQC-610133
#                             aag02 LIKE aag_file.aag02,  # 科目名稱
#                             aag13 LIKE aag_file.aag13,  #FUN-6C0012
#                             aag15 LIKE aag_file.aag15,  # 異動碼-1 說明
#                             aag16 LIKE aag_file.aag16,  # 異動碼-2 說明
#                             aag17 LIKE aag_file.aag17,  # 異動碼-3 說明
#                             aag18 LIKE aag_file.aag18,  # 異動碼-4 說明
#                             aag223 LIKE aag_file.aag223,  # 分類碼-1
#                             aag224 LIKE aag_file.aag224,  # 分類碼-2
#                             aag225 LIKE aag_file.aag225,  # 分類碼-3
#                             aag226 LIKE aag_file.aag226,  # 分類碼-4
#                             aee04 LIKE aee_file.aee04,  # 異動碼說明
#                             aee05 LIKE aee_file.aee05,  #
#                             aee06 LIKE aee_file.aee06
#                      END RECORD,
#     l_sw         LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
#     l_aae02      LIKE aae_file.aae02,
#     l_amt        LIKE aed_file.aed05
#  DEFINE g_head1 STRING
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.order1,sr.aed01,sr.aed02
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        LET g_head1 = g_x[9] CLIPPED,tm.aed03 USING "####",
#                      g_x[10] CLIPPED,tm.aed04 USING "##"
#        PRINT g_head1   #MOD-5A0015
#        PRINT g_dash[1,g_len]
#        PRINT g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]   #TQC-610133
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#
#     BEFORE GROUP OF sr.order1
#        SELECT aae02 INTO l_aae02 FROM aae_file WHERE aae01 = sr.order1
#        IF STATUS THEN
#           LET l_aae02 = NULL
#        END IF
#        IF tm.x = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
#
#     BEFORE GROUP OF sr.aed01
#        IF tm.t = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#            SKIP TO TOP OF PAGE
#        END IF
#        #-----TQC-610133---------
#        PRINT COLUMN g_c[37],g_x[12] CLIPPED,
#              COLUMN g_c[38],sr.order1 CLIPPED,l_aae02 CLIPPED,
#              COLUMN g_c[39],g_x[11] CLIPPED,
#              COLUMN g_c[40],sr.aed01 CLIPPED;
#              COLUMN g_c[41],sr.aag02 CLIPPED     #FUN-6C0012
#        #FUN-6C0012.....begin
#        IF tm.e = 'N' THEN
#           PRINT COLUMN g_c[41],sr.aag02 CLIPPED
#        ELSE
#           PRINT COLUMN g_c[41],sr.aag13 CLIPPED
#        END IF
#        #FUN-6C0012.....end 
#        #-----END TQC-610133-----
#        PRINT
#
#     AFTER GROUP OF sr.aed02
#        #-----TQC-610133---------
#        LET l_amt = GROUP SUM(sr.d_c)
#        PRINT COLUMN g_c[37],sr.aed02,
#              COLUMN g_c[38],cl_numfor(sr.d_c2,38,t_azi04),       #No.CHI-6A0004 g_azi-->t_azi
#              COLUMN g_c[39],cl_numfor(sr.d,39,t_azi04),          #No.CHI-6A0004 g_azi-->t_azi
#              COLUMN g_c[40],cl_numfor(sr.c,40,t_azi04);          #No.CHI-6A0004 g_azi-->t_azi
#        IF l_amt < 0 THEN
#           LET l_amt = l_amt * -1
#           PRINT COLUMN g_c[41],cl_numfor(l_amt,41,t_azi04),      #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[42],'C'
#        ELSE
#           PRINT COLUMN g_c[41],cl_numfor(l_amt,41,t_azi04),      #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[42],'D'
#        END IF
#        #-----END TQC-610133-----
#
#     AFTER GROUP OF sr.aed01
#        #-----TQC-610133---------
#        LET l_amt = GROUP SUM(sr.d_c)
#        PRINT COLUMN g_c[40],g_x[13] CLIPPED;
#        IF l_amt < 0 THEN
#           LET l_amt = l_amt * -1
#           PRINT COLUMN g_c[41],cl_numfor(l_amt,41,t_azi05),      #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[42],'C'
#        ELSE
#           PRINT COLUMN g_c[41],cl_numfor(l_amt,41,t_azi05),      #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[42],'D'
#        END IF
#        #-----END TQC-610133-----
#        PRINT g_dash2
 
#     AFTER GROUP OF sr.order1
#        #-----TQC-610133---------
#        LET l_amt = GROUP SUM(sr.d_c)
#        PRINT COLUMN g_c[40],g_x[13] CLIPPED;
#        IF l_amt < 0 THEN
#           LET l_amt = l_amt * -1
#           PRINT COLUMN g_c[41],cl_numfor(l_amt,41,t_azi05),      #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[42],'C'
#        ELSE
#           PRINT COLUMN g_c[41],cl_numfor(l_amt,41,t_azi05),      #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[42],'D'
#        END IF
#        #-----END TQC-610133-----
#        PRINT g_dash2
#
#     ON LAST ROW
#        LET l_last_sw = 'y'
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-610133    #No.TQC-6B0093
#
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #TQC-610133    #No.TQC-6B0093
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT}
#--end-FUN-780059--mark--#
#Patch....NO.TQC-610035 <001> #
