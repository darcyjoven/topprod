# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: anmr108.4gl
# Descriptions...: 應付票據月餘額明細表列印 
# Input parameter:
# Return code....:
# Date & Author..: 99/05/09 By Iceman
# Modify.........: No.7014 03/10/16 By Kitty 292行加上票況678
# Modify.........: No.FUN-4C0098 04/12/24 By pengu 報表轉XML
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表列印小計時程式會當掉
# Modify.........: No.MOD-5B0308 05/11/23 By kim 票況未顯示中文名
# Modify.........: No.MOD-660009 06/06/05 By Smapmin 修正幣別取位
# Modify.........: No.MOD-660008 06/06/05 By Smapmin 修正dash相關顯示
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6C0033 06/12/15 By Smapmin QBE條件增加票據科目
# Modify.........: No.MOD-6C0098 06/12/18 By Smapmin 修改本幣金額加總顯示方式
# Modify.........: No.FUN-770038 07/08/02 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-8B0027 08/12/01 By jan 提供INPUT加上關系人與營運中心 
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/20 By wuxj GP5.2 跨DB報表，財務類
# Modify.........: No.TQC-A40115 10/04/23 By Carrier 补TABLE JOIN 条件
# Modify.........: No:MOD-A90148 10/09/23 By Dido 票況應依截止日回溯 
# Modify.........: No:MOD-AA0031 10/10/07 By Dido 本幣取位調整 
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_nmd19應給予預設值'',抓不到不應為'1'
# Modify.........: No.CHI-B80045 11/08/19 By Polly 修正退票作業與兌現作業同月份時, 報表不會產出未兌現票
# Modify.........: No.MOD-C90149 12/09/21 By Polly 增加aag02科目名稱傳入cr報表
# Modify.........: No.MOD-CC0039 12/12/06 By Polly 給予l_npl03預設值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				               #Print condition RECORD
             #wc      LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(600) #Where Condiction #MOD-C90149 mark
              wc      STRING,                  #MOD-C90149 add
          edate   LIKE type_file.dat,      #No.FUN-680107 DATE
           #NO.FUN-A10098   ----start----
           #  b   LIKE type_file.chr1,     #No.FUN-8B0027
           # p1   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           # p2   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           # p3   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           # p4   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           # p5   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           # p6   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           # p7   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           # p8   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           #NO.FUN-A10098 ----end---
           type   LIKE type_file.chr1,     #No.FUN-8B0027 
              s   LIKE type_file.chr6,     #No.FUN-680107 VARCHAR(2) #排列順序
              t   LIKE type_file.chr3,     #No.FUN-680107 VARCHAR(2) #跳頁否
              u   LIKE type_file.chr3,     #No.FUN-680107 VARCHAR(2) #合計否
           more   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1) #額外摘要是否列印
              END RECORD,
          g_bookno  LIKE aba_file.aba00 #帳別編號
 
#DEFINE   g_cnt      LIKE type_file.num10   #No.FUN-680107 INTEGER   #MOD-6C0098
DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
DEFINE   g_str      STRING  #No.FUN-770038
DEFINE   l_table        STRING  #No.CHI-830003
DEFINE   g_sql          STRING  #No.CHI-830003
DEFINE m_dbs      ARRAY[10] OF LIKE type_file.chr20              #No.FUN-8B0027 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
   
   #No.CHI-830003  --Begin
   LET g_sql = " nmd01.nmd_file.nmd01,",
               " nmd02.nmd_file.nmd02,",
               " nmd03.nmd_file.nmd03,",
               " nmd04.nmd_file.nmd04,",
               " nmd05.nmd_file.nmd05,",
               " nmd06.nmd_file.nmd06,",
               " nmd07.nmd_file.nmd07,",
               " nmd08.nmd_file.nmd08,",
               " nmd12.nmd_file.nmd12,",
               " nmd20.nmd_file.nmd20,",
               " nmd21.nmd_file.nmd21,",
               " nmd23.nmd_file.nmd23,",
               " nmd24.nmd_file.nmd24,",
               " nmd26.nmd_file.nmd26,",
               " nmd27.nmd_file.nmd27,",
               " nmd28.nmd_file.nmd28,",
               " nmd31.nmd_file.nmd31,",
               " pmc24.pmc_file.pmc24,",
               " pmc903.pmc_file.pmc903,",     #FUN-8B0027
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " aag02_1.aag_file.aag02"         #MOD-C90149 add
              #" plant.azp_file.azp01"         #FUN-8B0027  #FUN-9A0018 
 
   LET l_table = cl_prt_temptable('anmr108',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   
               " VALUES(?,?,?,?,?,  ?,?,?,?,?, ",
               "        ?,?,?,?,?,  ?,?,?,?,?, ",                 #MOD-C90149 add
               "        ?,?) "                                    #MOD-C90149 add
              #"        ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,?,? ) "     #FUN-8B0027 
              #"        ?, ?, ?, ?,  ?, ?, ?, ?, ?,?,?) "         #FUN-9A0018 #MOD-C90149 mark
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.CHI-830003  --End   
 
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET tm.u  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#NO.FUN-A10098   ----start---
#  #FUN-8B0027--BEGIN-- 
#  LET tm.b =  ARG_VAL(17)
#  LET tm.p1 = ARG_VAL(18)
#  LET tm.p2 = ARG_VAL(19)
#  LET tm.p3 = ARG_VAL(20)
#  LET tm.p4 = ARG_VAL(21)
#  LET tm.p5 = ARG_VAL(22)
#  LET tm.p6 = ARG_VAL(23)
#  LET tm.p7 = ARG_VAL(24)
#  LET tm.p8 = ARG_VAL(25)
#  LET tm.type = ARG_VAL(26)
#  #FUN-8B0027--END--
   LET tm.type = ARG_VAL(17)
#NO.FUN-A10098  ----end---
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107 --start
#   CREATE TEMP TABLE curr_tmp
#    (curr  VARCHAR(04),                    #幣別
#     amt   DEC(20,6),                   #票面金額
#     order1  VARCHAR(80),                  #FUN-560011
#     order2  VARCHAR(80)                   #FUN-560011
#    );
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     amt1 LIKE type_file.num20_6,   #MOD-6C0098
     order1 LIKE nmd_file.nmd03,
     order2 LIKE nmd_file.nmd03);
#No.FUN-680107 --end
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr108_tm()	        	# Input print condition
      ELSE CALL anmr108()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr108_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
          l_jmp_flag    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   DEFINE li_result     LIKE type_file.num5     #No.FUN-940102
 
   LET p_row = 4 LET p_col = 13
   OPEN WINDOW anmr108_w AT p_row,p_col
        WITH FORM "anm/42f/anmr108"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s = '12'
   LET tm.t = '  '
   LET tm.more = 'N'
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
   #FUN-8B0027-Begin--#                                                                                                             
 # LET tm.b ='N'        #FUN-A10098
   LET tm.type = '3'
 # LET tm.p1=g_plant    #FUN-A10098
 # CALL r108_set_entry_1()     #FUN-A10098
 # CALL r108_set_no_entry_1()  #FUN-A10098
 # CALL r108_set_comb()        #FUN-A10098
   #FUN-8B0027-End--# 
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON nmd08,nmd03,nmd07,nmd01,nmd02,nmd06,nmd20,nmd31   #FUN-6C0033
   CONSTRUCT BY NAME tm.wc ON nmd08,nmd03,nmd07,nmd01,nmd02,nmd23,nmd06,nmd20,nmd31   #FUN-6C0033
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      #-----FUN-6C0033---------
      ON ACTION CONTROLP
         IF INFIELD(nmd23) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_aag"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nmd23
         END IF
      #-----END FUN-6C0033-----
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr108_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.edate,
                #FUN-A10098   ---start---
                #tm.b,tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type,   #FUN-8B0027
                 tm.type,
                #FUN-A10098 ---end-- 
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,
                 tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF

    #FUN-A10098   ---start--- 
    # #FUN-8B0027--Begin--#
    # AFTER FIELD b
    #     IF NOT cl_null(tm.b)  THEN
    #        IF tm.b NOT MATCHES "[YN]" THEN
    #           NEXT FIELD b
    #        END IF
    #     END IF
 
    #  ON CHANGE  b
    #     LET tm.p1=g_plant
    #     LET tm.p2=NULL
    #     LET tm.p3=NULL
    #     LET tm.p4=NULL
    #     LET tm.p5=NULL
    #     LET tm.p6=NULL
    #     LET tm.p7=NULL
    #     LET tm.p8=NULL
    #     DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8
    #     CALL r108_set_entry_1()
    #     CALL r108_set_no_entry_1()
    #     CALL r108_set_comb()
    #FUN-A10098 ----end---
 
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF 

#FUN-A10098  ---start--- 
#     AFTER FIELD p1
#        IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#        SELECT azp01 FROM azp_file WHERE azp01 = tm.p1 
#        IF STATUS THEN
#           CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)
#           NEXT FIELD p1
#        END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p1) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p1
#               END IF 
#No.FUN-940102 --end-- 
#
#     AFTER FIELD p2
#        IF NOT cl_null(tm.p2) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p2 
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)
#              NEXT FIELD p2
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p2) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p2
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p3
#        IF NOT cl_null(tm.p3) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p3 
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)
#              NEXT FIELD p3
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p3) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p3
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p4
#        IF NOT cl_null(tm.p4) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p4 
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)
#              NEXT FIELD p4
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p4) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p4
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p5
#        IF NOT cl_null(tm.p5) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p5 
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)
#              NEXT FIELD p5
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p5) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p5
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p6
#        IF NOT cl_null(tm.p6) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p6 
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)
#              NEXT FIELD p6
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p6) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p6
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p7
#        IF NOT cl_null(tm.p7) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p7 
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1)
#              NEXT FIELD p7
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p7) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p7
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#
#     AFTER FIELD p8
#        IF NOT cl_null(tm.p8) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p8 
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)
#              NEXT FIELD p8
#           END IF
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,tm.p8) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD p8
#               END IF 
#No.FUN-940102 --end-- 
#        END IF
#     #FUN-8B0027--END--
#FUN-A10098  ---end---

      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#FUN-A10098  ---start---
#  #FUN-8B0027--Begin--#
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE
#       #FUN-8B0027--END--  
#FUN-A10098  ---end---

    AFTER INPUT
      LET l_jmp_flag = 'N'
      LET tm.s = tm2.s1[1,2],tm2.s2[1,2]
      LET tm.t = tm2.t1,tm2.t2
      LET tm.u = tm2.u1,tm2.u2
      IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr108_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr108'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr108','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
			 " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                     #FUN-A10098  ---start---  
                     #   " '",tm.b   CLIPPED,"'",   #FUN-8B0027
                     #   " '",tm.p1   CLIPPED,"'",  #FUN-8B0027
                     #   " '",tm.p2   CLIPPED,"'",  #FUN-8B0027
                     #   " '",tm.p3   CLIPPED,"'",  #FUN-8B0027
                     #   " '",tm.p4   CLIPPED,"'",  #FUN-8B0027
                     #   " '",tm.p5   CLIPPED,"'",  #FUN-8B0027
                     #   " '",tm.p6   CLIPPED,"'",  #FUN-8B0027
                     #   " '",tm.p7   CLIPPED,"'",  #FUN-8B0027
                     #   " '",tm.p8   CLIPPED,"'",  #FUN-8B0027
                     #FUN-A10098   ---end---
                         " '",tm.type CLIPPED,"'"   #FUN-8B0027
         CALL cl_cmdat('anmr108',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr108_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr108()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr108_w
END FUNCTION
 
FUNCTION anmr108()
   DEFINE l_name	LIKE type_file.chr20, 		            # External(Disk) file name #No.FUN-680107 VARCHAR(20)
         #l_time          LIKE type_file.chr8	    #No.FUN-6A0082
         #l_sql         LIKE type_file.chr1000,             #RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200) #MOD-C90149 mark
          l_sql         STRING,                             #MOD-C90149 add
          l_za05	LIKE type_file.chr1000,               #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order ARRAY[2] OF LIKE nmd_file.nmd03,      #No.FUN-680107 ARRAY[2] OF VARCHAR(80) #排列順序    #FUN-560011
          l_i     LIKE type_file.num5,                  #No.FUN-680107 SMALLINT
          sr               RECORD
                           order1    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(80) #排列順序-1    #FUN-560011
                           order2    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(80) #排列順序-2    #FUN-560011
			   g_nmd     RECORD LIKE nmd_file.*,
                           pmc24     LIKE pmc_file.pmc24
                        END RECORD
   DEFINE l_oox01   STRING                           #CHI-830003 add
   DEFINE l_oox02   STRING                           #CHI-830003 add
   DEFINE l_sql_1   STRING                           #CHI-830003 add
   DEFINE l_sql_2   STRING                           #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5              #CHI-830003 add
   DEFINE l_nmd12   LIKE nmd_file.nmd12              #MOD-A90148                        
   DEFINE l_nmd19   LIKE nmd_file.nmd19              #CHI-830003 add                        
   DEFINE l_i1       LIKE type_file.num5             #No.FUN-8B0027 SMALLINT
   DEFINE l_dbs      LIKE azp_file.azp03             #No.FUN-8B0027
   DEFINE l_azp03    LIKE azp_file.azp03             #No.FUN-8B0027
   DEFINE i          LIKE type_file.num5             #No.FUN-8B0027
   DEFINE l_pmc903   LIKE pmc_file.pmc903            #No;FUN-8B0027
   DEFINE l_npl03   LIKE npl_file.npl03              #No.CHI-B80045 add       
   DEFINE l_aag02_1 LIKE aag_file.aag02              #MOD-C90149 add
                 
   #CHI-830003 --Begin--#                     
   DEFINE sr1      RECORD
                         nmd01   LIKE nmd_file.nmd01,
                         nmd02   LIKE nmd_file.nmd02,
                         nmd03   LIKE nmd_file.nmd03,
                         nmd04   LIKE nmd_file.nmd04,
                         nmd05   LIKE nmd_file.nmd05,
                         nmd06   LIKE nmd_file.nmd06,
                         nmd07   LIKE nmd_file.nmd07,
                         nmd08   LIKE nmd_file.nmd08,
                         nmd12   LIKE nmd_file.nmd12,
                         nmd20   LIKE nmd_file.nmd20,
                         nmd21   LIKE nmd_file.nmd21,
                         nmd23   LIKE nmd_file.nmd23,
                         nmd24   LIKE nmd_file.nmd24,
                         nmd26   LIKE nmd_file.nmd26,
                         nmd27   LIKE nmd_file.nmd27,
                         nmd28   LIKE nmd_file.nmd28,
                         nmd31   LIKE nmd_file.nmd31,
                         pmc24   LIKE pmc_file.pmc24,
                         pmc903  LIKE pmc_file.pmc903,    #FUN-8B0027
                         azi04   LIKE azi_file.azi04,
                         azi05   LIKE azi_file.azi05
                   END RECORD
     #CHI-830003 --End--#                                                  
   
     #No.FUN-770038  --Begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-770038  --End
     
     #No.CHI-830003  --Begin
     CALL cl_del_data(l_table)
     #No.CHI-830003  --End     
       
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   # SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
   #	 AND aaf02 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
 
     #No.FUN-770038  --Begin
     ##no.5195   (針對幣別加總)
     #DELETE FROM curr_tmp;
 
     ##LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計   #MOD-6C0098
     #LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",    #group 1 小計   #MOD-6C0098
     #          "  WHERE order1=? ",
     #          "  GROUP BY curr"
     #PREPARE tmp1_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp1_cs CURSOR WITH HOLD FOR tmp1_pre
 
     ##LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計   #MOD-6C0098
     #LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",    #group 2 小計   #MOD-6C0098
     #          "  WHERE order1=? ",
     #          "    AND order2=? ",
     #          "  GROUP BY curr  "
     #PREPARE tmp2_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp2_cs CURSOR WITH HOLD FOR tmp2_pre
 
     ##LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計   #MOD-6C0098
     #LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",    #on last row 總計   #MOD-6C0098
     #          "  GROUP BY curr  "
     #PREPARE tmp3_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp3_cs CURSOR WITH HOLD FOR tmp3_pre
     ##no.5195(end)
#FUN-A10098  ---start---
#  #FUN-8B0027-Begin--#                                                                                                           
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
#  #FUN-8B0027--End--#

#  FOR l_i1 = 1 to 8 
#      IF cl_null(m_dbs[l_i1]) THEN CONTINUE FOR END IF                       #FUN-8B0027
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i1]          #FUN-8B0027
#      LET l_azp03 = l_dbs CLIPPED                                           #FUN-8B0027
#      LET l_dbs = s_dbstring(l_dbs) CLIPPED                                         #FUN-8B0027
#FUN-A10098  ---end---

     LET l_sql = "SELECT nmd01,nmd02,nmd03,nmd04,nmd05,nmd06,nmd07, ",
                 "       nmd08,nmd12,nmd20,nmd21,nmd23,nmd24,nmd26, ",
                 "       nmd27,nmd28,nmd31,pmc24,pmc903,azi04,azi05  ",      #FUN-8B0027 add pmc903
              #No.TQC-A40115  --Begin
                 " FROM nmd_file LEFT OUTER JOIN pmc_file ON nmd08=pmc01 LEFT OUTER JOIN azi_file ON nmd21=azi01",            #FUN-8B0027
                 " WHERE ",tm.wc CLIPPED,
                 "   AND nmd07 <= '",tm.edate,"'",
                 "   AND nmd30 <> 'X' ",
                 "   AND (nmd29 IS NULL ",
                 "    OR  nmd29 > '",tm.edate,"')",
                 "   AND (nmd12 NOT IN ('6','7','8','9') ",
                 "    OR  nmd13 > '",tm.edate,"')"
              #No.TQC-A40115  --End  
 
     #PREPARE anmr108_prepare1 FROM l_sql
     #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
     #   EXIT PROGRAM 
     #END IF
     #DECLARE anmr108_curs1 CURSOR FOR anmr108_prepare1
     #CALL cl_outnam('anmr108') RETURNING l_name
     #START REPORT anmr108_rep TO l_name
 
     #LET g_pageno = 0
     ##LET g_cnt    = 1   #MOD-6C0098
     #FOREACH anmr108_curs1 INTO sr.*
     #  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #  IF sr.g_nmd.nmd12 MATCHES '[6789]' AND sr.g_nmd.nmd13 <= tm.edate THEN     #No:7014
     #     CONTINUE FOREACH
     #  END IF
     #  FOR l_i = 1 TO 2
     #      CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr.g_nmd.nmd08
     #           WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr.g_nmd.nmd03
     #           WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr.g_nmd.nmd07
     #                                                       USING 'YYYYMMDD'
     #           WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr.g_nmd.nmd01
     #           WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr.g_nmd.nmd02
     #           #-----FUN-6C0033---------
     #           #WHEN tm.s[l_i,l_i] = '6' LET l_order[l_i] = sr.g_nmd.nmd06
     #           #WHEN tm.s[l_i,l_i] = '7' LET l_order[l_i] = sr.g_nmd.nmd20
     #           WHEN tm.s[l_i,l_i] = '6' LET l_order[l_i] = sr.g_nmd.nmd23
     #           WHEN tm.s[l_i,l_i] = '7' LET l_order[l_i] = sr.g_nmd.nmd06
     #           WHEN tm.s[l_i,l_i] = '8' LET l_order[l_i] = sr.g_nmd.nmd20
     #           WHEN tm.s[l_i,l_i] = '9' LET l_order[l_i] = sr.g_nmd.nmd31
     #           #-----END FUN-6C0033-----
     #           OTHERWISE LET l_order[l_i] = '-'
     #      END CASE
     #  END FOR
     #  LET sr.order1 = l_order[1]
     #  LET sr.order2 = l_order[2]
     #  IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
     #  IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
     #  OUTPUT TO REPORT anmr108_rep(sr.*)
 
     #END FOREACH
 
     #FINISH REPORT anmr108_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     
     #No.CHI-830003  --Begin
      PREPARE anmr108_prepare1 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM 
      END IF
      DECLARE anmr108_curs1 CURSOR FOR anmr108_prepare1     
      FOREACH anmr108_curs1 INTO sr1.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT azi05 INTO sr1.azi05 FROM azi_file WHERE azi01 = sr1.nmd21 #FUN-8B0027
        IF cl_null(sr1.pmc903) THEN LET sr1.pmc903 = 'N' END IF
        IF tm.type = '1' THEN
           IF sr1.pmc903 = 'N' THEN  CONTINUE FOREACH END IF                                                                            
        END IF                                                                                                                        
        IF tm.type = '2' THEN                                                                                                         
           IF sr1.pmc903  = 'Y' THEN  CONTINUE FOREACH END IF                                                                            
        END IF 
        IF g_nmz.nmz20 = 'Y' THEN
           LET l_oox01 = YEAR(tm.edate)
           LET l_oox02 = MONTH(tm.edate)                      	 
           LET l_nmd19 = ''  #TQC-B10083 add
           WHILE cl_null(l_nmd19)
                 LET l_sql_2 = "SELECT COUNT(*) ",
                             #FUN-A10098   ---start---
                             # "  FROM ",l_dbs CLIPPED,"oox_file ",  #FUN-8B0027
                               "  FROM oox_file ",
                             #FUN-A10098  ---end---
                               " WHERE oox00 = 'NM' AND oox01 <= '",l_oox01,"'",
                               "   AND oox02 <= '",l_oox02,"'",
                               "   AND oox03 = '",sr1.nmd01,"'",
                               "   AND oox04 = '0'",
                               "   AND oox041 = '0'"                             
                 PREPARE r108_prepare7 FROM l_sql_2
                 DECLARE r108_oox7 CURSOR FOR r108_prepare7
                 OPEN r108_oox7
                 FETCH r108_oox7 INTO l_count
                 CLOSE r108_oox7                       
                 IF l_count = 0 THEN
                    #LET l_nmd19 = '1'     #TQC-B10083 mark
                    EXIT WHILE             #TQC-B10083 add 
                 ELSE                  
                    LET l_sql_1 = "SELECT oox07 ",
                                #FUN-A10098  ----start--- 
                                # "  FROM ",l_dbs CLIPPED,"oox_file ",     #FUN-8B0027        
                                  "  FROM oox_file ",
                                #FUN-A10098  ---end---
                                  " WHERE oox00 = 'NM' AND oox01 = '",l_oox01,"'",
                                  "   AND oox02 = '",l_oox02,"'",
                                  "   AND oox03 = '",sr1.nmd01,"'",
                                  "   AND oox04 = '0'",
                                  "   AND oox041 = '0'"
                 END IF                  
              IF l_oox02 = '01' THEN
                 LET l_oox02 = '12'
                 LET l_oox01 = l_oox01-1
              ELSE    
                 LET l_oox02 = l_oox02-1
              END IF            
            
              IF l_count <> 0 THEN        
                 PREPARE r108_prepare07 FROM l_sql_1
                 DECLARE r108_oox07 CURSOR FOR r108_prepare07
                 OPEN r108_oox07
                 FETCH r108_oox07 INTO l_nmd19
                 CLOSE r108_oox07
              END IF              
           END WHILE                       
        END IF
        #IF g_nmz.nmz20 = 'Y' AND l_count <> 0 THEN           #TQC-B10083 mark
        IF g_nmz.nmz20 = 'Y' AND NOT cl_null(l_nmd19) THEN    #TQC-B10083 mod 
           LET sr1.nmd26 = sr1.nmd04 * l_nmd19
        END IF                      
       #-MOD-A90148-add-
        LET l_sql = " SELECT npm07    ",
                    "  FROM npl_file, ",
                    "       npm_file  ",    
                    " WHERE npm03 = '",sr1.nmd01,"'",
                    "   AND npl01 = npm01 ",
                    "   AND nplconf = 'Y' ",
                    "   AND npm08 = (SELECT MAX(npm08) FROM npm_file ",
                    " WHERE npm03 = '",sr1.nmd01,"'",
                    "   AND npm08 <= '",tm.edate,"') " 
        PREPARE r108_npm07p FROM l_sql
        DECLARE r108_npm07 CURSOR FOR r108_npm07p
        OPEN r108_npm07
        FETCH r108_npm07 INTO l_nmd12 
        CLOSE r108_npm07
        IF NOT cl_null(l_nmd12) THEN 
           LET sr1.nmd12 = l_nmd12
        ELSE                           #No.CHI-B80045 add
           LET sr1.nmd12 = '1'         #No.CHI-B80045 add
        END IF
       #-MOD-A90148-end-  
        LET l_npl03 = ''                     #MOD-CC0039 add
        #----------------------No.CHI-B80045------------------------start
        LET l_sql = " SELECT npl03    ",
                    "  FROM npl_file, ",
                    "       npm_file  ",
                    " WHERE npm03 = '",sr1.nmd01,"'",
                    "   AND npl01 = npm01 ",
                    "   AND nplconf = 'Y' ",
                    "   AND npl02 = (SELECT MAX(npl02) FROM npm_file ",
                    " WHERE npm03 = '",sr1.nmd01,"'",
                    "   AND npl02 <= '",tm.edate,"') "
        PREPARE r108_npl03p FROM l_sql
        DECLARE r108_npl03 CURSOR FOR r108_npl03p
        OPEN r108_npl03
        FETCH r108_npl03 INTO l_npl03
        CLOSE r108_npl03
        IF l_npl03 = '8' THEN
           CONTINUE FOREACH
        END IF
       #----------------------No.CHI-B80045--------------------------end
       #----------------------MOD-C90149------------------------(S)
        SELECT aag02 INTO l_aag02_1 FROM aag_file
         WHERE aag00 = g_aza.aza81
           AND aag01 = sr1.nmd23
       #----------------------MOD-C90149------------------------(E)
       #EXECUTE insert_prep USING sr1.*,m_dbs[l_i1]   #FUN-8B0027 #FUN-A10098
        EXECUTE insert_prep USING sr1.*,l_aag02_1     #FUN-A10098 #MOD-C90149 add aag02_1
      END FOREACH 
     #No.CHI-830003  --End     
    #END FOR    #FUN-8B0027   #FUN-A10098  mark
     
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmd08,nmd03,nmd07,nmd01,nmd02,nmd23,nmd06,nmd20,nmd31')
             RETURNING g_str
     END IF
#    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.u            #FUN-8B0027
   #FUN-A10098  ---start----  
   # LET g_str = g_str,";",tm2.s1,";",tm2.s2,";",tm.t,";",tm.u,";",tm.b            #FUN-8B0027
     LET g_str = g_str,";",tm2.s1,";",tm2.s2,";",tm.t,";",tm.u,";",'N',";",g_azi04,";",g_azi05    #MOD-AA0031 add g_azi04,g_azi05
   #FUN-A10098  ---end---
#    CALL cl_prt_cs1('anmr108','anmr108',l_sql,g_str)                                    #CHI-830003 Mark
     #No.FUN-770038  --End
     
     #No.CHI-830003  --Begin
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('anmr108','anmr108',g_sql,g_str)
     #No.CHI-830003  --End     
       
END FUNCTION
 
#FUN-A10098 ---start---
##FUN-8B0027--Begin--#
#FUNCTION r108_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r108_set_no_entry_1()
#    IF tm.b = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '10' THEN 
#          LET tm2.s1 = ' '
#       END IF
#       IF tm2.s2 = '10' THEN
#          LET tm2.s2 = ' '
#       END IF
#    END IF
#END FUNCTION
#FUNCTION r108_set_comb()
#  DEFINE comb_value STRING
#  DEFINE comb_item  LIKE type_file.chr1000 
# 
#    IF tm.b ='N' THEN 
#       LET comb_value = '1,2,3,4,5,6,7,8,9'
#       SELECT ze03 INTO comb_item FROM ze_file
#         WHERE ze01='anm-915' AND ze02=g_lang
#    ELSE
#       LET comb_value = '1,2,3,4,5,6,7,8,9,10'
#       SELECT ze03 INTO comb_item FROM ze_file
#         WHERE ze01='anm-916' AND ze02=g_lang
#    END IF
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#END FUNCTION
##FUN-8B0027--End--# 
#FUN-A10098  ---END---

#No.FUN-770038  --Begin
#REPORT anmr108_rep(sr)
#   DEFINE l_last_sw	    LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#          l_nmd12_1     LIKE ze_file.ze03,     #No.FUN-680107 VARCHAR(8) #MOD-5B0308
#		      l_p_flag      LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#        # l_azi04       LIKE azi_file.azi04,
#        #  l_azi05       LIKE azi_file.azi05,   #MOD-660009  #NO.CHI-6A0004
#          l_flag1       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#		      l_nmd12       LIKE nmd_file.nmd12,   #No.FUN-680107 VARCHAR(4)
#		      l_nmd14       LIKE nmd_file.nmd14,   #No.FUN-680107 VARCHAR(4)
#          l_count       LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(10)
#          l_curr        LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(10)
#          l_str         LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(20)
#          l_zero        LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#		      l_cnt_1       LIKE type_file.num5,   #No.FUN-680107 SMALLINT   #group 1 合計票據張數
#		      l_cnt_2       LIKE type_file.num5,   #No.FUN-680107 SMALLINT   #group 2 合計票據張數
#		      l_cnt_tot     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
#          #l_total       LIKE nmd_file.nmd04,  #票面金額合計   #MOD-6C0098
#          #l_total2      LIKE nmd_file.nmd26,  #本幣金額合計   #MOD-6C0098
#          l_orderA      ARRAY[2] OF LIKE zaa_file.zaa08,      #No.FUN-680107 ARRAY[2] OF VARCHAR(20) #排序名稱
#          sr               RECORD
#                           order1    LIKE nmd_file.nmd03,     #No.FUN-680107 VARCHAR(80) #排列順序-1 #FUN-560011
#                           order2    LIKE nmd_file.nmd03,     #No.FUN-680107 VARCHAR(80) #排列順序-2 #FUN-560011
#			   g_nmd     RECORD LIKE nmd_file.*,
#                           pmc24     LIKE pmc_file.pmc24
#                        END RECORD,
#          sr1           RECORD
#                           curr      LIKE azi_file.azi01,     #No.FUN-680107 VARCHAR(4)
#                           amt       LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
#                           amt1      LIKE type_file.num20_6   #MOD-6C0098
#                        END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.g_nmd.nmd07
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
## 處理排列順序於列印時所需控制
#   FOR g_i = 1 TO 2
#      CASE WHEN tm.s[g_i,g_i] = '1' LET l_orderA[g_i] = g_x[12]
#           WHEN tm.s[g_i,g_i] = '2' LET l_orderA[g_i] = g_x[13]
#           WHEN tm.s[g_i,g_i] = '3' LET l_orderA[g_i] = g_x[14]
#           WHEN tm.s[g_i,g_i] = '4' LET l_orderA[g_i] = g_x[15]
#           WHEN tm.s[g_i,g_i] = '5' LET l_orderA[g_i] = g_x[16]
#           #-----MOD-6C0098---------
#           #WHEN tm.s[g_i,g_i] = '6' LET l_orderA[g_i] = g_x[17]
#           #WHEN tm.s[g_i,g_i] = '7' LET l_orderA[g_i] = g_x[18]
#           WHEN tm.s[g_i,g_i] = '6' LET l_orderA[g_i] = g_x[19]
#           WHEN tm.s[g_i,g_i] = '7' LET l_orderA[g_i] = g_x[17]
#           WHEN tm.s[g_i,g_i] = '8' LET l_orderA[g_i] = g_x[18]
#           WHEN tm.s[g_i,g_i] = '9' LET l_orderA[g_i] = g_x[20]
#           #-----END MOD-6C0098-----
#           OTHERWISE LET l_orderA[g_i] = ' '
#      END CASE
#   END FOR
#            LET g_head1=g_x[11],l_orderA[1] CLIPPED," - ",l_orderA[2]
#            PRINT g_head1
#      PRINT g_dash
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            #g_x[39] CLIPPED,g_x[40] CLIPPED   #FUN-6C0033
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED   #FUN-6C0033
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#
#      SELECT azi04
#        INTO t_azi04    #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.g_nmd.nmd21
#      #MOD-5B0308...............begin
#      LET l_nmd12_1=''
#      IF NOT cl_null(sr.g_nmd.nmd12) THEN
#        CALL s_nmd12(sr.g_nmd.nmd12) RETURNING l_nmd12_1
#        LET l_nmd12_1=sr.g_nmd.nmd12,':',l_nmd12_1
#      END IF
#      #MOD-5B0308...............end
#
#      PRINT COLUMN g_c[31],sr.g_nmd.nmd08,
#            COLUMN g_c[32],sr.g_nmd.nmd24,
#            COLUMN g_c[33], sr.pmc24,
#            COLUMN g_c[34], sr.g_nmd.nmd27,
#            COLUMN g_c[35], sr.g_nmd.nmd28,
#           #COLUMN g_c[36], sr.g_nmd.nmd12,
#            COLUMN g_c[36], l_nmd12_1 CLIPPED, #MOD-5B0308
#            COLUMN g_c[37], sr.g_nmd.nmd05,
#            COLUMN g_c[38], sr.g_nmd.nmd02,
#            #-----FUN-6C0033---------
#            #COLUMN g_c[39], cl_numfor(sr.g_nmd.nmd04,39,t_azi04),
#            #COLUMN g_c[40], cl_numfor(sr.g_nmd.nmd26,40,g_azi04)
#            COLUMN g_c[39], sr.g_nmd.nmd23,
#            COLUMN g_c[40], sr.g_nmd.nmd21,
#            COLUMN g_c[41], cl_numfor(sr.g_nmd.nmd04,41,t_azi04),
#            COLUMN g_c[42], cl_numfor(sr.g_nmd.nmd26,42,g_azi04)
#            #-----END FUN-6C0033-----
#      LET l_cnt_1 = l_cnt_1 + 1
#      LET l_cnt_2 = l_cnt_2 + 1
#      LET l_cnt_tot = l_cnt_tot + 1
#      #no.5195
#      #INSERT INTO curr_tmp VALUES(sr.g_nmd.nmd21,sr.g_nmd.nmd04,sr.order1,sr.order2)   #MOD-6C0098
#      INSERT INTO curr_tmp VALUES(sr.g_nmd.nmd21,sr.g_nmd.nmd04,sr.g_nmd.nmd26,sr.order1,sr.order2)   #MOD-6C0098
#      IF STATUS THEN 
#         CALL cl_err('ins tmp:',STATUS,1) #FUN-660148
#         CALL cl_err3("ins","curr_tmp","","",STATUS,"","ins tmp:",1) #FUN-660148
#         END IF
#      #no.5195(end)
#
#   AFTER GROUP OF sr.order1
#      #LET l_total = GROUP SUM(sr.g_nmd.nmd04)   #MOD-6C0098
#      #LET l_total2= GROUP SUM(sr.g_nmd.nmd26)   #MOD-6C0098
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_str=l_orderA[1],"  ", g_x[10]
#         LET l_count=l_cnt_1,' ',g_x[9]
#         PRINT COLUMN g_c[33],l_str,
#               COLUMN g_c[34],l_count;
#         #no.5195
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#             #SELECT azi05 INTO g_azi05 FROM azi_file   #MOD-660009
#             SELECT azi05 INTO t_azi05 FROM azi_file   #MOD-660009  #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_curr=sr1.curr CLIPPED,':'
#             PRINT COLUMN g_c[37],l_curr,
#                   #COLUMN g_c[39],cl_numfor(sr1.amt,39,g_azi05) CLIPPED;   #MOD-660009
#                   #COLUMN g_c[39],cl_numfor(sr1.amt,39,t_azi05) CLIPPED;   #MOD-660009   #NO.CHI-6A0004   #FUN-6C0033
#                   COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05) CLIPPED,   #MOD-660009   #NO.CHI-6A0004   #FUN-6C0033
#                   COLUMN g_c[42],cl_numfor(sr1.amt1,42,g_azi05) CLIPPED   #MOD-6C0098
#             #-----MOD-6C0098---------
#             #IF g_cnt = 1 THEN
#             #   #PRINT COLUMN g_c[40],cl_numfor(l_total2,40,g_azi05) CLIPPED   #FUN-6C0033
#             #   PRINT COLUMN g_c[42],cl_numfor(l_total2,42,g_azi05) CLIPPED   #FUN-6C0033
#             #ELSE PRINT END IF
#             #LET g_cnt = g_cnt + 1
#             #-----END MOD-6C0098-----
#         END FOREACH
#         #no.5195(end)
#         #PRINT l_dash[1,g_len]     #No.TQC-5B0107 mark
#         PRINT g_dash2              #No.TQC-5B0107 modify
#      END IF
#         LET l_cnt_1 = 0
#
#   AFTER GROUP OF sr.order2
#      #LET l_total = GROUP SUM(sr.g_nmd.nmd04)   #MOD-6C0098
#      #LET l_total2= GROUP SUM(sr.g_nmd.nmd26)   #MOD-6C0098
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_str=l_orderA[2],"  ", g_x[10]
#         LET l_count=l_cnt_2,' ',g_x[9]
#         PRINT COLUMN g_c[33],l_str,
#               COLUMN g_c[34],l_count;
#         #no.5195
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#             #SELECT azi05 INTO g_azi05 FROM azi_file   #MOD-660009
#             SELECT azi05 INTO t_azi05 FROM azi_file   #MOD-660009  #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_curr=sr1.curr CLIPPED,':'
#             PRINT COLUMN g_c[37],l_curr,
#                   #COLUMN g_c[39],cl_numfor(sr1.amt,39,g_azi05) CLIPPED;   #MOD-660009
#                   #COLUMN g_c[39],cl_numfor(sr1.amt,39,t_azi05) CLIPPED;   #MOD-660009  #NO.CHI-6A0004   #FUN-6C0033
#                   COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05) CLIPPED,   #MOD-660009  #NO.CHI-6A0004   #FUN-6C0033
#                   COLUMN g_c[42],cl_numfor(sr1.amt1,42,g_azi05) CLIPPED   #MOD-6C0098
#             #-----MOD-6C0098--------- 
#             #IF g_cnt = 1 THEN
#             #   #PRINT COLUMN g_c[40],cl_numfor(l_total2,40,g_azi05) CLIPPED   #FUN-6C0033
#             #   PRINT COLUMN g_c[42],cl_numfor(l_total2,42,g_azi05) CLIPPED   #FUN-6C0033
#             #ELSE PRINT END IF
#             #LET g_cnt = g_cnt + 1
#             #-----END MOD-6C0098-----
#         END FOREACH
#         #no.5195(end)
#         PRINT g_dash2   #MOD-660008
#      END IF
#	  LET l_cnt_2 = 0
#
#   ON LAST ROW
#      #LET l_total = SUM(sr.g_nmd.nmd04)   #MOD-6C0098
#      #LET l_total2= SUM(sr.g_nmd.nmd26)   #MOD-6C0098
#          PRINT
#          LET l_count=l_cnt_tot,' ',g_x[9]
#          PRINT COLUMN g_c[33],g_x[10] CLIPPED,COLUMN g_c[34],l_count;
#           # ,COLUMN 80,cl_numfor(l_total,39,g_azi04) CLIPPED,
#           #  COLUMN 97,cl_numfor(l_total2,40,g_azi04) CLIPPED
# 
#      #LET g_cnt = 1   #MOD-6C0098
#      #no.5195
#      FOREACH tmp3_cs INTO sr1.*
#          #SELECT azi05 INTO g_azi05 FROM azi_file   #MOD-660009
#          SELECT azi05 INTO t_azi05 FROM azi_file   #MOD-660009   #NO.CHI-6A0004
#           WHERE azi01 = sr1.curr
#          LET l_curr=sr1.curr CLIPPED,':'
#          PRINT COLUMN g_c[37],l_curr,
#                #COLUMN g_c[39],cl_numfor(sr1.amt,39,g_azi05) CLIPPED;   #MOD-660009
#                #COLUMN g_c[39],cl_numfor(sr1.amt,39,t_azi05) CLIPPED;   #MOD-660009  #NO.CHI-6A0004   #FUN-6C0033
#                COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05) CLIPPED,   #MOD-660009  #NO.CHI-6A0004   #FUN-6C0033
#                COLUMN g_c[42],cl_numfor(sr1.amt1,42,g_azi05) CLIPPED   #MOD-6C0098
#          #-----MOD-6C0098---------
#          #IF g_cnt = 1 THEN
#          #   #PRINT COLUMN g_c[40],cl_numfor(l_total2,40,g_azi05) CLIPPED   #FUN-6C0033
#          #   PRINT COLUMN g_c[42],cl_numfor(l_total2,42,g_azi05) CLIPPED   #FUN-6C0033
#          #ELSE PRINT END IF
#          #LET g_cnt = g_cnt + 1
#          #-----END MOD-6C0098-----
#      END FOREACH
#      #no.5195(end)
#          PRINT g_dash
#          #PRINT g_dash1          #No.TQC-5B0107 mark
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_cnt_1 = 0
#      LET l_cnt_2 = 0
#      LET l_cnt_tot = 0
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-770038  --End  
