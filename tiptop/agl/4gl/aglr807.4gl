# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr807.4gl
# Descriptions...: 資產科目異動碼與預算比較表
# Input parameter:
# Return code....:
# Date & Author..: 92/10/05 By yen
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-580010 05/08/11 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-5C0015 06/01/06 By kevin 畫面QBE加aed012異動碼類型代號，
#                  ^p q_ahe，(p_zaa)序號32放寬至60
#                  原列印aag15~18，改抓ahe02 ( ahe01=aag15~18，aag31~36)
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie  增加總頁數 
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-6B0021 07/03/16 By jamie 預算欄位開窗查詢
# Modify.........: No.FUN-740020 07/04/09 By Lynn 會計科目加帳套-財務 
# Modify.........: No.FUN-780031 07/09/03 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-810069 08/02/28 By ChenMoyan 去掉預算編號的控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60138 10/06/22 By Dido 語法調整,空白改在 FOREACH 處理�
# Modify.........: No.FUN-AB0020 10/11/04 By chenying 預算編號(預算項目)查詢分情況考慮
# Modify.........: No.FUN-B10020 11/01/13 By lixh1 預算項目允許不輸入值,需判斷當預算項目有輸入時才檢查值的正確性    
# Modify.........: No.TQC-B10121 11/01/14 By Dido 預算項目須有值才需檢核 
# Modify.........: No.FUN-B20054 11/02/23 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
              wc      STRING,                   # Where condition  #TQC-630166 
              bookno  LIKE aed_file.aed00,      #No.FUN-740020
              aed03   LIKE type_file.num10,     # 年度             #No.FUN-680098 INTEGER
              aed04   LIKE aed_file.aed04,      # 期別
              afc01   LIKE afc_file.afc01,      # 預算編號
              t       LIKE type_file.chr2,      # 每一科目列印完是否跳頁(Y/N)   #No.FUN-680098 
              e       LIKE type_file.chr1,      #FUN-6C0012
              more    LIKE type_file.chr1       # Input more condition(Y/N)     #No.FUN-680098 VARCHAR(1)
              END RECORD,
              l_afc01    LIKE afc_file.afc01,   # 預算編號
#             g_bookno   LIKE aah_file.aah00,   #帳別   #TQC-610056             #No.FUN-740020
              l_sw       LIKE type_file.chr1    #No.FUN-580010                      #No.FUN-680098 VARCHAR(1)
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   l_table         STRING  #No.FUN-780031
DEFINE   g_str           STRING  #No.FUN-780031
DEFINE   g_sql           STRING  #No.FUN-780031
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
 
   #No.FUN-780031  --Begin
   LET g_sql = " aed01.aed_file.aed01,",  # 科目編號
               " aed02.aed_file.aed02,",  # 異動碼
               " aag02.aag_file.aag02,",  # 科目名稱
               " aag06.aag_file.aag06,",  # 正常餘額型態
               " buff.type_file.chr1000,",
               " d_c.aed_file.aed05,",  # 實際金額
               " afc06.afc_file.afc06 "   # 各期預算
 
   LET l_table = cl_prt_temptable('aglr807',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?         ) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780031  --End
 
	#金額小數位數
    SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_aaz.aaz64
    SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03          #No.CHI-6A0004 g_azi-->t_azi
    #-----No.MOD-4C0171-----
#  LET g_bookno = ARG_VAL(1)       #TQC-610056     #No.FUN-740020
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.aed03  = ARG_VAL(9)
   LET tm.aed04  = ARG_VAL(10)
   LET tm.afc01  = ARG_VAL(11)
   LET tm.t  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   LET tm.e  = ARG_VAL(16)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
    #-----No.MOD-4C0171 END-----
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aglr807_tm(0,0)                # Input print condition
      ELSE CALL aglr807()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr807_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680098 SMALLINT
          l_n         LIKE type_file.num5,       #No.FUN-680098 SMALLINT
          l_cmd       LIKE type_file.chr1000     #No.FUN-680098 VARCHAR(400)
DEFINE l_azfacti      LIKE azf_file.azfacti      #FUN-B10020
DEFINE li_chk_bookno  LIKE type_file.num5        #No.FUN-B20054
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW aglr807_w AT p_row,p_col
        WITH FORM "agl/42f/aglr807"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bookno = '00'                      #No.FUN-740020
   LET tm.aed03 = YEAR(TODAY)
   LET tm.t     = 'N'
   LET tm.e     = 'N'  #FUN-6C0012
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'

   DISPLAY BY NAME tm.bookno,tm.aed03,tm.t,tm.e,tm.more  #No.FUN-B20054
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
 
  # FUN-5C0015 (s)
   #CONSTRUCT BY NAME tm.wc ON aed01,aed011,aed02
   CONSTRUCT BY NAME tm.wc ON aed01,aed011,aed012,aed02
   # FUN-5C0015 (e)
 
      #FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
      #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start--
# 
#      ON ACTION controlp
#        CASE
#           WHEN INFIELD(aed012) #異動碼類型代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_ahe"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aed012
#                NEXT FIELD aed012
#              OTHERWISE EXIT CASE
#        END CASE
#      # FUN-5C0015 (e)
# 
#      ON ACTION locale
#        #CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
# 
#      #No.FUN-580031 --start--
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#      #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end--

  END CONSTRUCT
#No.FUN-B20054--mark--start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW aglr807_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#      EXIT PROGRAM
#         
#   END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#   DISPLAY BY NAME tm.bookno,tm.aed03,tm.t,tm.e,tm.more   # Condition  #FUN-6C0012     #No.FUN-740020
#   INPUT BY NAME tm.bookno,tm.aed03,tm.aed04,tm.afc01,tm.t,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012   #No.FUN-740020
#No.FUN-B20054--mark--end--
    INPUT BY NAME tm.aed03,tm.aed04,tm.afc01,tm.t,tm.e,tm.more ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
##No.FUN-740020 -- begin --                                                                                                          
#         AFTER FIELD bookno                                                                                                         
#            IF tm.bookno = '*' THEN                                                                                                 
#               NEXT FIELD bookno                                                                                                    
#            END IF                                                                                                                  
##No.FUN-740020 -- end --
#No.FUN-B20054--mark--end-- 
      AFTER FIELD aed03
         IF cl_null(tm.aed03)
            THEN NEXT FIELD aed03
         END IF

      BEFORE FIELD afc01
         IF cl_null(tm.aed04) OR tm.aed04 > 13 THEN
            CALL cl_err('aed04','agl-013',0)
            NEXT FIELD aed04
         END IF

      BEFORE FIELD t
#FUN-B10020 ---------------Begin-------------------
#         IF cl_null(tm.afc01)
#            THEN NEXT FIELD afc01
#         END IF
#FUN-B10020 ---------------End---------------------
          IF NOT cl_null(tm.afc01) THEN   #TQC-B10121 
             SELECT count(*) INTO l_n FROM afc_file
                  WHERE afc00 = tm.bookno       #No.FUN-740020 
                    AND afc01 = tm.afc01
     #              AND afc04 = '3'
                    AND afc041 = '' AND afc042 = ''  #No.FUN-810069
             IF l_n = 0 THEN
                 CALL cl_err(tm.afc01,'agl-158',0)
                 NEXT FIELD afc01
             END IF
          END IF                          #TQC-B10121
 
      AFTER FIELD t
         IF tm.t NOT MATCHES "[YN]"
            THEN NEXT FIELD t
         END IF

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

#FUN-B10020 ---------------------------Begin-----------------------------------
     AFTER FIELD afc01
       IF NOT cl_null(tm.afc01) THEN
          SELECT azf01 FROM azf_file
           WHERE azf01 = tm.afc01  AND azf02 = '2'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
            NEXT FIELD afc01
         ELSE
            SELECT azfacti INTO l_azfacti FROM azf_file
             WHERE azf01 = tm.afc01 AND azf02 = '2'
            IF l_azfacti = 'N' THEN
               CALL cl_err(tm.afc01,'agl1002',0)
            END IF
         END IF
      END IF
#No.FUN-B20054--mark--start--
##FUN-B10020 ---------------------------End-------------------------------------
#################################################################################
## START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
## END genero shell script ADD
#################################################################################
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
##     ON ACTION CONTROLP CALL aglr807_wc()   # Input detail Where Condition
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
# 
#      #No.FUN-580031 --start--
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#      #No.FUN-580031 ---end---
# 
#      ON ACTION controlp
##No.FUN-740020  ---begin
#        CASE                                                                                                                        
#          WHEN INFIELD(bookno)                                                                                                       
#             CALL cl_init_qry_var()                                                                                                 
#             LET g_qryparam.form = 'q_aaa'                                                                                          
#             LET g_qryparam.default1 = tm.bookno                                                                                     
#             CALL cl_create_qry() RETURNING tm.bookno                                                                                
#             DISPLAY BY NAME tm.bookno                                                                                               
#             NEXT FIELD bookno 
##No.FUN-740020  ---end                                                                                                       
#          #FUN-6B0021---add---end---
#          WHEN INFIELD(afc01)
#             CALL cl_init_qry_var()
##            LET g_qryparam.form = 'q_afa'     #No.FUN-810069
#             LET g_qryparam.form = 'q_azf'     #No.FUN-810069
#             LET g_qryparam.default1 = tm.afc01
##            LET g_qryparam.arg1 = tm.bookno   #No.FUN-810069
#             LET g_qryparam.arg1 = '2'         #No.FUN-810069
#             CALL cl_create_qry() RETURNING tm.afc01
#             DISPLAY BY NAME tm.afc01
#             NEXT FIELD afc01
#          #FUN-6B0021---add---end---
#        END CASE
#No.FUN-B20054--mark--end--
   END INPUT
#No.FUN-B20054--add-start--
      ON ACTION controlp
        CASE
           WHEN INFIELD(bookno)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              LET g_qryparam.default1 = tm.bookno
              CALL cl_create_qry() RETURNING tm.bookno
              DISPLAY BY NAME tm.bookno
              NEXT FIELD bookno
           WHEN INFIELD(aed01)
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_aag02"
              LET g_qryparam.state    = "c"
              LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aed01
              NEXT FIELD aed01
          WHEN INFIELD(afc01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azf'     #No.FUN-810069
              LET g_qryparam.default1 = tm.afc01
              LET g_qryparam.arg1 = '2'         #No.FUN-810069
              CALL cl_create_qry() RETURNING tm.afc01
              DISPLAY BY NAME tm.afc01
              NEXT FIELD afc01
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
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

#No.FUN-B20054--add-end-- 

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr807_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF   #No.FUN-B20054  add

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr807'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('aglr807','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
#                         " '",g_bookno CLIPPED,"'",   #TQC-610056     #No.FUN-740020
                         " '",tm.bookno CLIPPED,"'",         #No.FUN-740020
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
                         " '",tm.afc01 CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",  #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglr807',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr807_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr807()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr807_w
END FUNCTION
 
FUNCTION aglr807()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name         #No.FUN-680098 VARCHAR(20)
         #l_time    LIKE type_file.chr8           #No.FUN-6A0073
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166     
          l_za05    LIKE za_file.za05,            #No.FUN-680098 VARCHAR(40)
          l_buff    LIKE type_file.chr1000,       #No.FUN-780031
          l_ahe02a  LIKE ahe_file.ahe02,          #MOD-A60138 
          l_ahe02b  LIKE ahe_file.ahe02,          #MOD-A60138  
          l_ahe02c  LIKE ahe_file.ahe02,          #MOD-A60138 
          l_ahe02d  LIKE ahe_file.ahe02,          #MOD-A60138
          l_ahe02e  LIKE ahe_file.ahe02,          #MOD-A60138 
          l_ahe02f  LIKE ahe_file.ahe02,          #MOD-A60138 
          l_ahe02g  LIKE ahe_file.ahe02,          #MOD-A60138 
          l_ahe02h  LIKE ahe_file.ahe02,          #MOD-A60138 
          l_ahe02i  LIKE ahe_file.ahe02,          #MOD-A60138 
          l_ahe02j  LIKE ahe_file.ahe02,          #MOD-A60138 
# 科目編號 � 異動碼      實      際         預      算         差      異     %
# aed01xxxxxxx aag02xxxxx   aag15xxx aag16xxx aag17xxx aag18xxx
#     aed02xxxxxxxxxx aed05-06xxxx.xxx   afc06xxxxxxx.xxx   aed-afcxxxxx.xxx ax%
          sr            RECORD aed00 LIKE aed_file.aed00,    #No.FUN-740020
                               aed01 LIKE aed_file.aed01,  # 科目編號
                               aag02 LIKE aag_file.aag02,  # 科目名稱
                               aag13 LIKE aag_file.aag13,  #FUN-6C0012
                               aag06 LIKE aag_file.aag06,  # 正常餘額型態
                               aag15 LIKE aag_file.aag15,  # 異動碼-1 說明
                               aag16 LIKE aag_file.aag16,  # 異動碼-2 說明
                               aag17 LIKE aag_file.aag17,  # 異動碼-3 說明
                               aag18 LIKE aag_file.aag18,  # 異動碼-4 說明
                               # FUN-5C0015 add (s)
                               aag31 LIKE aag_file.aag31,  # 異動碼-5
                               aag32 LIKE aag_file.aag32,  # 異動碼-6
                               aag33 LIKE aag_file.aag33,  # 異動碼-7
                               aag34 LIKE aag_file.aag34,  # 異動碼-8
                               aag35 LIKE aag_file.aag35,  # 異動碼-9
                               aag36 LIKE aag_file.aag36,  # 異動碼-10
                              #ahe02a LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02b LIKE ahe_file.ahe02,                  #MOD-A60138 mark 
                              #ahe02c LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02d LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02e LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02f LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02g LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02h LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02i LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                              #ahe02j LIKE ahe_file.ahe02,                  #MOD-A60138 mark
                               # FUN-5C0015 add (e)
                               aed02 LIKE aed_file.aed02,  # 異動碼
                               afc06 LIKE afc_file.afc06,  # 各期預算
                               d_c   LIKE aed_file.aed05   # 實際金額
                        END RECORD
 
     #No.FUN-780031  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780031  --End  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT aed00, aed01, aag02, aag13, aag06, aag15, aag16, aag17, aag18,",  #FUN-6C0012  #FUN-AB0020 add aed00
                 # FUN-5C0015 add (s)
                 "       aag31,aag32,aag33,aag34,aag35,aag36,",
                #"       '','','','','','','','','','',",          #MOD-A60138 mark 
                 # FUN-5C0015 add (e)
                 "       aed02, afc06, SUM(aed05 - aed06)",
              #  "  FROM aed_file, aag_file,afc_file",
                 "  FROM aed_file LEFT OUTER JOIN afc_file ON afc02 = aed01, aag_file",
    {aed}        " WHERE aed00 = '",tm.bookno,"'",        #No.FUN-740020
                 "   AND aed03 = '",tm.aed03,"'",
                 "   AND aed04 <= '",tm.aed04,"'",
   {aag}         "   AND aag01 = aed01",
                 "   AND aag00 = '",tm.bookno,"'",       #No.FUN-740020
                 "   AND aag04 = '1'",
                 "   AND aagacti = 'Y'",
   {afc}         "   AND afc00 = '",tm.bookno,"'",       #No.FUN-740020
#                "   AND afc01 = '",tm.afc01,"'",        #FUN-AB0020 mark 
                 "   AND afc03 = '",tm.aed03,"'",
#                "   AND afc04 = '3'",
                 "   AND afc05 = '",tm.aed04,"'",
                 "   AND ",tm.wc CLIPPED
               #FUN-AB0020----mark--------------str---------
               # # FUN-5C0015 add (s)
               # # GROUP BY 1,2,3,4,5,6,7,8,9
               # " GROUP BY aed00,aed01,aag02,aag13,aag06,aag15,aag16,aag17,aag18,",  #FUN-6C0012    #No.FUN-740020
               # "          aag31,aag32,aag33,aag34,aag35,aag36,",
               ##"          '','','','','','','','','','',",        #MOD-A60138 mark 
               # "          aed02,afc06"
               # # FUN-5C0015 add (e)
               #FUN-AB0020----mark--------------end----------
 
#    LET l_sql = l_sql CLIPPED," ORDER BY aed01,gkc03"
#FUN-AB0020-----add---------------str-----------
     IF NOT cl_null(tm.afc01) THEN
        LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'",
                          " GROUP BY aed00,aed01,aag02,aag13,aag06,aag15,aag16,aag17,aag18,", 
                          "          aag31,aag32,aag33,aag34,aag35,aag36,",
                          "          aed02,afc06"
     ELSE
        LET l_sql = l_sql,"GROUP BY aed00,aed01,aag02,aag13,aag06,aag15,aag16,aag17,aag18,",
                          "          aag31,aag32,aag33,aag34,aag35,aag36,",
                          "          aed02,afc06" 
     END IF
#FUN-AB0020-----add---------------end-----------
     PREPARE aglr807_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
     END IF
     DECLARE aglr807_curs1 CURSOR FOR aglr807_prepare1
 
#    LET l_name = 'aglr807.out'
     #No.FUN-780031  --Begin
     #CALL cl_outnam('aglr807') RETURNING l_name
     #START REPORT aglr807_rep TO l_name
     ##FUN-6C0012.....begin
     #IF tm.e = 'N' THEN                                                         
     #   LET g_zaa[37].zaa06 = 'N'                                               
     #   LET g_zaa[38].zaa06 = 'Y'                                               
     #ELSE                                                                       
     #   LET g_zaa[37].zaa06 = 'Y'                                               
     #   LET g_zaa[38].zaa06 = 'N'                                               
     #END IF                                                                     
     #CALL cl_prt_pos_len()
     ##FUN-6C0012.....end
     #LET g_pageno = 0
     #No.FUN-780031  --End  
     FOREACH aglr807_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        # FUN-5C0015 add(s)
        SELECT ahe02 INTO l_ahe02a FROM ahe_file     #MOD-A60138 sr.ahe02a -> l_ahe02a 
          WHERE ahe01 = sr.aag15
        SELECT ahe02 INTO l_ahe02b FROM ahe_file     #MOD-A60138 sr.ahe02b -> l_ahe02b
          WHERE ahe01 = sr.aag16
        SELECT ahe02 INTO l_ahe02c FROM ahe_file     #MOD-A60138 sr.ahe02c -> l_ahe02c
          WHERE ahe01 = sr.aag17
        SELECT ahe02 INTO l_ahe02d FROM ahe_file     #MOD-A60138 sr.ahe02d -> l_ahe02d
          WHERE ahe01 = sr.aag18
        SELECT ahe02 INTO l_ahe02e FROM ahe_file     #MOD-A60138 sr.ahe02e -> l_ahe02e
          WHERE ahe01 = sr.aag31
        SELECT ahe02 INTO l_ahe02f FROM ahe_file     #MOD-A60138 sr.ahe02f -> l_ahe02f
          WHERE ahe01 = sr.aag32
        SELECT ahe02 INTO l_ahe02g FROM ahe_file     #MOD-A60138 sr.ahe02g -> l_ahe02g
          WHERE ahe01 = sr.aag33
        SELECT ahe02 INTO l_ahe02h FROM ahe_file     #MOD-A60138 sr.ahe02h -> l_ahe02h 
          WHERE ahe01 = sr.aag34
        SELECT ahe02 INTO l_ahe02i FROM ahe_file     #MOD-A60138 sr.ahe02i -> l_ahe02i
          WHERE ahe01 = sr.aag35
        SELECT ahe02 INTO l_ahe02j FROM ahe_file     #MOD-A60138 sr.ahe02j -> l_ahe02j 
          WHERE ahe01 = sr.aag36
        # FUN-5C0015 add(e)
 
        #No.FUN-780031  --Begin
        LET l_buff = NULL
        IF NOT cl_null(l_ahe02a) THEN                  #MOD-A60138 sr.ahe02a -> l_ahe02a
           LET l_buff = l_ahe02a                       #MOD-A60138 sr.ahe02a -> l_ahe02a 
        END IF
        IF NOT cl_null(l_ahe02b) THEN                  #MOD-A60138 sr.ahe02b -> l_ahe02b 
           LET l_buff = l_buff CLIPPED,' ',l_ahe02b    #MOD-A60138 sr.ahe02b -> l_ahe02b                                                                                
        END IF
        IF NOT cl_null(l_ahe02c) THEN                  #MOD-A60138 sr.ahe02c -> l_ahe02c                                                                                        
           LET l_buff = l_buff CLIPPED,' ',l_ahe02c    #MOD-A60138 sr.ahe02c -> l_ahe02c                                                                              
        END IF
        IF NOT cl_null(l_ahe02d) THEN                  #MOD-A60138 sr.ahe02d -> l_ahe02d 
           LET l_buff = l_buff CLIPPED,' ',l_ahe02d    #MOD-A60138 sr.ahe02d -> l_ahe02d                                                                              
        END IF
        IF NOT cl_null(l_ahe02e) THEN                  #MOD-A60138 sr.ahe02e -> l_ahe02e                                                                              
           LET l_buff = l_buff CLIPPED,' ',l_ahe02e    #MOD-A60138 sr.ahe02e -> l_ahe02e                                                                              
        END IF
        IF NOT cl_null(l_ahe02f) THEN                  #MOD-A60138 sr.ahe02f -> l_ahe02f                                                                              
           LET l_buff = l_buff CLIPPED,' ',l_ahe02f    #MOD-A60138 sr.ahe02f -> l_ahe02f                                                                              
        END IF
        IF NOT cl_null(l_ahe02g) THEN                  #MOD-A60138 sr.ahe02g -> l_ahe02g                                                                               
           LET l_buff = l_buff CLIPPED,' ',l_ahe02g    #MOD-A60138 sr.ahe02g -> l_ahe02g                                                                              
        END IF
        IF NOT cl_null(l_ahe02h) THEN                  #MOD-A60138 sr.ahe02h -> l_ahe02h                                                                              
           LET l_buff = l_buff CLIPPED,' ',l_ahe02h    #MOD-A60138 sr.ahe02h -> l_ahe02h                                                                              
        END IF
        IF NOT cl_null(l_ahe02i) THEN                  #MOD-A60138 sr.ahe02i -> l_ahe02i                                                                               
           LET l_buff = l_buff CLIPPED,' ',l_ahe02i    #MOD-A60138 sr.ahe02i -> l_ahe02i                                                                              
        END IF
        IF NOT cl_null(l_ahe02j) THEN                  #MOD-A60138 sr.ahe02j -> l_ahe02j                                                                              
           LET l_buff = l_buff CLIPPED,' ',l_ahe02j    #MOD-A60138 sr.ahe02j -> l_ahe02j                                                                              
        END IF
        IF tm.e = 'Y' THEN                                                         
           LET sr.aag02 = sr.aag13
        END IF
        #OUTPUT TO REPORT aglr807_rep(sr.*)
        EXECUTE insert_prep USING sr.aed01,sr.aed02,sr.aag02,sr.aag06,
                l_buff,sr.d_c,sr.afc06
        #No.FUN-780031  --End  
     END FOREACH
 
     #No.FUN-780031  --Begin
     #FINISH REPORT aglr807_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aed01,aed011,aed012,aed02')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.afc01,";",tm.aed03,";",tm.aed04,";",tm.t,";",
                 t_azi04,";",t_azi05,";",tm.e
     CALL cl_prt_cs3('aglr807','aglr807',g_sql,g_str)
     #No.FUN-780031  --End  
END FUNCTION
 
#No.FUN-780031  --Begin
#REPORT aglr807_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,               #No.FUN-680098 VARCHAR(1)
#          sr            RECORD aed00 LIKE aed_file.aed00,  #No.FUN-740020
#                               aed01 LIKE aed_file.aed01,  # 科目編號
#                               aag02 LIKE aag_file.aag02,  # 科目名稱
#                               aag13 LIKE aag_file.aag13,  #FUN-6C0012
#                               aag06 LIKE aag_file.aag06,  # 正常餘額型態
#                               aag15 LIKE aag_file.aag15,  # 異動碼-1 說明
#                               aag16 LIKE aag_file.aag16,  # 異動碼-2 說明
#                               aag17 LIKE aag_file.aag17,  # 異動碼-3 說明
#                               aag18 LIKE aag_file.aag18,  # 異動碼-4 說明
#                               # FUN-5C0015 add (s)
#                               aag31 LIKE aag_file.aag31,  # 異動碼-5
#                               aag32 LIKE aag_file.aag32,  # 異動碼-6
#                               aag33 LIKE aag_file.aag33,  # 異動碼-7
#                               aag34 LIKE aag_file.aag34,  # 異動碼-8
#                               aag35 LIKE aag_file.aag35,  # 異動碼-9
#                               aag36 LIKE aag_file.aag36,  # 異動碼-10
#                               ahe02a LIKE ahe_file.ahe02,
#                               ahe02b LIKE ahe_file.ahe02,
#                               ahe02c LIKE ahe_file.ahe02,
#                               ahe02d LIKE ahe_file.ahe02,
#                               ahe02e LIKE ahe_file.ahe02,
#                               ahe02f LIKE ahe_file.ahe02,
#                               ahe02g LIKE ahe_file.ahe02,
#                               ahe02h LIKE ahe_file.ahe02,
#                               ahe02i LIKE ahe_file.ahe02,
#                               ahe02j LIKE ahe_file.ahe02,
#                               # FUN-5C0015 add (e)
#                               aed02 LIKE aed_file.aed02,  # 異動碼
#                               afc06 LIKE afc_file.afc06,  # 各期預算
#                               d_c   LIKE aed_file.aed05   # 實際金額
#                        END RECORD,
#      l_chr        LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
#      l_amt        LIKE type_file.num20_6,       #No.FUN-680098 dec(20,6)
#      l_dif        LIKE type_file.num20_6,       # 差異金額     #No.FUN-680098  dec(20,6)
#      l_per        LIKE type_file.num5,          #No.FUN-680098   smallint  
#      l_amt1       LIKE type_file.num20_6,       #No.FUN-680098   dec(20,6)
#      l_amt2       LIKE type_file.num20_6,       #No.FUN-680098   dec(20,6)
#      l_amt3       LIKE type_file.num20_6,       #No.FUN-680098   dec(20,6)
#      l_buff       LIKE type_file.chr1000        # FUN-5C0015  add  #No.FUN-680098   VARCHAR(60)
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.aed01,sr.aed02
#  FORMAT
#   PAGE HEADER
##No.FUN-580010 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
##No.FUN-580010 --end--
#      PRINT g_x[16] CLIPPED,tm.afc01
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN 32,g_x[13] CLIPPED,tm.aed03 USING "####",
#            COLUMN 43,g_x[14] CLIPPED,tm.aed04 USING "##",
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<','/pageno'    #No.TQC-6B0093
#      PRINT g_dash[1,g_len]
##No.FUN-580010 --start--
##     PRINT g_x[11],g_x[12]
##     PRINT g_x[31],g_x[37],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]         #FUN-6C0012
#      PRINT g_x[31],g_x[37],g_x[38],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36] #FUN-6C0012
#      PRINT g_dash1
##No.FUN-580010 --end--
#      LET l_last_sw = 'n'
#      LET l_sw = 'N'
#   BEFORE GROUP OF sr.aed01
#      LET l_amt = 0
#      LET l_amt1 = 0
#      LET l_amt2 = 0
#      LET l_amt3 = 0
#      IF tm.t = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
##1234567890123456789012345678901234567890123456789012345678901234567890123456789
##         1         2         3         4         5         6         7
##科目編號 � 異動碼       實      際         預      算         差      異     %
##------------------- -----------------   ----------------   ---------------- ---
##aed01xxxxxxx aag02xxxxx   aag15xxx aag16xxx aag17xxx aag18xxx
##    aed02xxxxxxxxxx aed05-06xxxx.xxxA   afc06xxxxxxx.xxx   aed-afcxxxxx.xxx ax%
##         合 計 :  sum1xxxxxxxxxx.xxxA sum2xxxxxxxxxx.xxx sum3xxxxxxxxxx.xxx ax%
#
##No.FUN-580010 --start--
##     PRINT '------------------- -------------------   ------------------   ------------------ ----'
##     PRINT sr.aed01 CLIPPED,
##           COLUMN 14,sr.aag02 CLIPPED,' ',sr.aag15 CLIPPED,' ',
##           sr.aag16 CLIPPED,' ',sr.aag17 CLIPPED,' ',sr.aag18 CLIPPED
#      IF l_sw = 'Y' THEN
#      PRINT g_dash1
#      ELSE
#         LET l_sw = 'Y'
#      END IF
#      # FUN-5C0015 (s)
#      LET l_buff = NULL
#      IF NOT cl_null(sr.ahe02a) THEN
#         LET l_buff = sr.ahe02a
#      END IF
#      IF NOT cl_null(sr.ahe02b) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02b
#      END IF
#      IF NOT cl_null(sr.ahe02c) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02c
#      END IF
#      IF NOT cl_null(sr.ahe02d) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02d
#      END IF
#      IF NOT cl_null(sr.ahe02e) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02e
#      END IF
#      IF NOT cl_null(sr.ahe02f) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02f
#      END IF
#      IF NOT cl_null(sr.ahe02g) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02g
#      END IF
#      IF NOT cl_null(sr.ahe02h) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02h
#      END IF
#      IF NOT cl_null(sr.ahe02i) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02i
#      END IF
#      IF NOT cl_null(sr.ahe02j) THEN
#         LET l_buff = l_buff CLIPPED,' ',sr.ahe02j
#      END IF
# 
#      PRINT COLUMN g_c[31],sr.aed01 CLIPPED,
#            COLUMN g_c[37],sr.aag02 CLIPPED,
#            COLUMN g_c[38],sr.aag13 CLIPPED,   #FUN-6C0012
#           #COLUMN g_c[32],sr.aag15 CLIPPED,' ',sr.aag16 CLIPPED,' ',
#           #sr.aag17 CLIPPED,' ',sr.aag18 CLIPPED
#            COLUMN g_c[32],l_buff CLIPPED
#      # FUN-5C0015 (e)
##No.FUN-580010 --end--
#   ON EVERY ROW
#      IF sr.d_c < 0 THEN
#           LET l_amt = sr.d_c * -1
#           LET l_chr = 'C'
#           IF sr.aag06 = '2' THEN
#               LET l_dif = l_amt - sr.afc06
#           ELSE
#               LET l_dif = sr.d_c - sr.afc06
#           END IF
#      ELSE
#           LET l_chr = 'D'
#           IF sr.aag06 = '1' THEN
#               LET l_amt = sr.d_c
#               LET l_dif = sr.d_c - sr.afc06
#           ELSE
#               LET l_amt = sr.d_c * -1
#               LET l_dif = l_amt - sr.afc06
#               LET l_amt = l_amt * -1
#           END IF
#      END IF
#      LET l_per = (l_dif / sr.afc06) * 100
#      LET l_amt3 = l_amt3 + l_dif
##No.FUN-580010 --start--
##     PRINT COLUMN 04,sr.aed02,
##           COLUMN 20,cl_numfor(l_amt,18,g_azi04) CLIPPED,l_chr,
##           COLUMN 44,cl_numfor(sr.afc06,18,g_azi04) CLIPPED,
##           COLUMN 65,cl_numfor(l_dif,18,g_azi04) CLIPPED,
##                 COLUMN 82,l_per USING '---#',COLUMN 86,'%'
#      PRINT COLUMN g_c[32],sr.aed02 CLIPPED,
#            COLUMN g_c[33],cl_numfor(l_amt,18,t_azi04) CLIPPED,l_chr,        #No.CHI-6A0004 g_azi-->t_azi
#            COLUMN g_c[34],cl_numfor(sr.afc06,18,t_azi04) CLIPPED,           #No.CHI-6A0004 g_azi-->t_azi
#            COLUMN g_c[35],cl_numfor(l_dif,18,t_azi04) CLIPPED,              #No.CHI-6A0004 g_azi-->t_azi
#            COLUMN g_c[36],l_per USING '---#','%'
##No.FUN-580010 --end--
#   AFTER GROUP OF sr.aed01
#      LET l_amt1= GROUP SUM(sr.d_c)
#      LET l_amt2 = GROUP SUM(sr.afc06)
#      LET l_per = (l_amt3 / l_amt2) * 100
#      IF l_amt1 < 0 THEN
#          LET l_amt1 = l_amt1 * -1
#          LET l_chr  = 'C'
#      ELSE
#          LET l_chr  = 'D'
#      END IF
##No.FUN-580010 --start--
##     PRINT COLUMN 09,g_x[15] CLIPPED,
##           COLUMN 20,cl_numfor(l_amt1,18,g_azi05) CLIPPED,l_chr,
##           COLUMN 44,cl_numfor(l_amt2,18,g_azi05) CLIPPED,
##           COLUMN 65,cl_numfor(l_amt3,18,g_azi05) CLIPPED,
##           COLUMN 82,l_per USING '---#',COLUMN 86,'%'
#      PRINT COLUMN g_c[32],g_x[15] CLIPPED,
#            COLUMN g_c[33],cl_numfor(l_amt1,18,t_azi05) CLIPPED,l_chr,        #No.CHI-6A0004 g_azi-->t_azi
#            COLUMN g_c[34],cl_numfor(l_amt2,18,t_azi05) CLIPPED,              #No.CHI-6A0004 g_azi-->t_azi
#            COLUMN g_c[35],cl_numfor(l_amt3,18,t_azi05) CLIPPED,              #No.CHI-6A0004 g_azi-->t_azi
#            COLUMN g_c[36],l_per USING '---#','%'
##No.FUN-580010 --end--
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'aed01,aed011,aed02')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#        #TQC-630166
#        #      IF tm.wc[001,070] > ' ' THEN            # for 80
#        # PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #      IF tm.wc[071,140] > ' ' THEN
#        #  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #      IF tm.wc[141,210] > ' ' THEN
#        #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #      IF tm.wc[211,280] > ' ' THEN
#        #  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780031  --End  
#Patch....NO.TQC-610035 <> #
