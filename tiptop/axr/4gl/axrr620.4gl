# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: axrr620.4gl
# Descriptions...: 應收帳齡分析表
# Date & Author..: 95/03/04 by Nick
# Modify.........: No.FUN-4C0100 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-580010 05/08/11 By will 報表轉XML格式
# Modify.........: No.MOD-5A0277 05/10/21 By Smapmin 調整SQL條件
# Modify.........: No.MOD-5C0069 05/12/14 By Carrier ooz07='N'-->oma56t-oma57
#                                                    ooz07='Y'-->oma61
# Modify.........: No.FUN-660116 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-660113 06/06/28 By Smapmin 將l_sql,l_sql1改為STRING
# Modify.........: No.TQC-660146 06/07/03 By Smapmin 補充MOD-660113
# Modify.........: No.FUN-680022 06/08/09 By Tracy 多帳期修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/19 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.MOD-680103 06/11/03 By Smapmin TEMP TABLE 必須先DROP
# Modify.........: No.TQC-6B0051 06/12/12 By xufeng  修改報表格式              
# Modify.........: No.FUN-710066 07/02/09 By rainy 將 axri030 提列率納入          
# Modify.........: No.MOD-720047 07/02/28 by TSD.pinky 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-790101 07/09/17 By Judy "帳齡分段"為控管
# Modify.........: No.FUN-760016 08/01/25 By jamie 1. QBE請提供開窗功能： 「部門編號」、「人員編號」、「客戶類別」、「客戶編號」
#                                                  2. Input「帳齡類別」，請提供開窗功能。
#                                                  3. Input「應收帳款立帳日期選擇」，增加顯示在報表表頭(製表日期後面，接續空白處列印)。
# Modify.........: No.MOD-850112 08/05/12 By Sarah 調整FUN-710066,將呆帳比率計算的金額呈現在新的欄位
# Modify.........: No.MOD-870076 08/07/10 By Sarah 開窗用到q_gem3,q_gen5,q_occ02的,要多傳g_qryparam.arg1=g_dbs
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.MOD-920131 09/02/10 By Sarah 當tm.x='1'時,SQL應過濾oma02<=tm.edate,當tm.x='2'時,SQL應過濾oma11<=tm.edate
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.TQC-A90001 10/09/01 By xiaofeizhu INPUT處BUG修改 
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_oma24應給予預設值'',抓不到值不應為'1'
# Modify.........: No.FUN-B20014 11/02/12 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.FUN-C40021 12/05/31 By jinjj QBE增加會計科目oma18
# Modify.........: No.MOD-C90124 12/09/17 By Polly 針對23類預收帳款增加回溯功能
# Modify.........: No.CHI-D10056 13/02/04 By apo 調整AR單據SQL
# Modify.........: No.MOD-D30025 13/03/04 By apo 如果l_oma53的值為Null則給0
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                            # Print condition RECORD
             #wc      LIKE type_file.chr1000,                   #No.FUN-680123  VARCHAR(1000) # Where condition
              wc      STRING,                                   #MOD-C90124 add
                          omi01   LIKE omi_file.omi01,
                          a1      LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
                          a2      LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
                          a3      LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
                          a4      LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
                          a5      LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
                          a6      LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
                          x       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01),
                          detail  LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01),
                          edate   LIKE type_file.dat,           #No.FUN-680123 DATE,
                          e       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1),
              more                LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)  # Input more condition(Y/N)
              END RECORD,
                          l_omi21         LIKE omi_file.omi21,
                          l_omi22         LIKE omi_file.omi22,
                          l_omi23         LIKE omi_file.omi23,
                          l_omi24         LIKE omi_file.omi24,
                          l_omi25         LIKE omi_file.omi25,
                          l_omi26         LIKE omi_file.omi26,
                          l_tot           LIKE ofr_file.ofr11        #No.FUN-680123 DEC(12,3)
 
DEFINE   g_i             LIKE type_file.num5           #No.FUN-680123 SMALLINT   #count/index for any purpose
#No.FUN-580010  --begin
#DEFINE   g_dash          VARCHAR(400)   #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
DEFINE l_table     STRING                        #FUN-710080 add
DEFINE g_sql       STRING                        #FUN-710080 add
DEFINE g_str       STRING                        #FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #MOD-720047 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oma01.oma_file.oma01, oma14.oma_file.oma14, ",
               "oma15.oma_file.oma15, gen02.gen_file.gen02, ",
               "oca01.oca_file.oca01, oca02.oca_file.oca02, ",
               "oma03.oma_file.oma03, oma032.oma_file.oma032,",
               "oma02.oma_file.oma02, omc02.omc_file.omc02, ",
               "oma11.oma_file.oma11, num1.oma_file.oma56t, ",
               "num2.oma_file.oma57,  num3.oma_file.oma57,",
               "num4.oma_file.oma57,  num5.oma_file.oma57,",
               "num6.oma_file.oma57,  num7.oma_file.oma57,",
               "tot.oma_file.oma56,   num1_o.oma_file.oma56t, ",   #MOD-850112 add num1_o
               "num2_o.oma_file.oma57,num3_o.oma_file.oma57,",     #MOD-850112 add
               "num4_o.oma_file.oma57,num5_o.oma_file.oma57,",     #MOD-850112 add
               "num6_o.oma_file.oma57,num7_o.oma_file.oma57,",     #MOD-850112 add
               "azi04.azi_file.azi04, azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('axrr620',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?)"   #MOD-850112 add 7?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #MOD-720047 - END
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.omi01 = ARG_VAL(8)
   LET tm.a1= ARG_VAL(9)
   LET tm.a2= ARG_VAL(10)
   LET tm.a3= ARG_VAL(11)
   LET tm.a4 = ARG_VAL(12)
   LET tm.a5 = ARG_VAL(13)
   LET tm.a6 = ARG_VAL(14)
   LET tm.x = ARG_VAL(15)
   LET tm.edate = ARG_VAL(16)
   LET tm.detail = ARG_VAL(17)
   LET tm.e = ARG_VAL(18)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc)
      THEN CALL axrr620_tm(0,0)             # Input print condition
   ELSE 
      CALL axrr620()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr620_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 10
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW axrr620_w AT p_row,p_col
        WITH FORM "axr/42f/axrr620"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.x='1'
   LET tm.detail='N'
   LET tm.e='Y'
   LET tm.edate=g_today
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma15,oma14,oca01,oma03,oma18    #FUN-C40021 add 'oma18'
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
      #FUN-760016---add---str---
      ON ACTION CONTROLP
         IF INFIELD(oma15) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gem3"
#           LET g_qryparam.arg1 = g_dbs    #MOD-870076 add  #No.FUN-980025 mark
            LET g_qryparam.plant = g_plant #No.FUN-980025 add
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oma15
            NEXT FIELD oma15
         END IF
 
         IF INFIELD(oma14) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen5"
#           LET g_qryparam.arg1 = g_dbs    #MOD-870076 add   #No.FUN-980025 mark
            LET g_qryparam.plant = g_plant #No.FUN-980025 add
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oma14
            NEXT FIELD oma14
         END IF
 
         IF INFIELD(oca01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_oca"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oca01
            NEXT FIELD oca01
         END IF
 
         IF INFIELD(oma03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_occ02"
#           LET g_qryparam.arg1 = g_dbs    #MOD-870076 add #No.FUN-980025 mark
            LET g_qryparam.plant = g_plant #No.FUN-980025 add
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oma03
            NEXT FIELD oma03
         END IF
      #FUN-760016---add---end---

      #No.FUN-C40021 --start--
         IF INFIELD(oma18) THEN#科目編號
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oma18
            NEXT FIELD oma18
         END IF
      #No.FUN-C40021 ---end---  
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.omi01,
       tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6,tm.x,tm.edate,tm.detail,tm.e,tm.more
       WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
          BEFORE FIELD omi01
                IF cl_null(tm.omi01) THEN
                SELECT MIN(omi01) INTO tm.omi01 FROM omi_file
                END IF
          AFTER FIELD omi01
                SELECT omi11,omi12,omi13,omi14,omi15,omi16,omi21,
                       omi22,omi23,omi24,omi25,omi26
                   INTO tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6,
                        l_omi21,l_omi22,l_omi23,l_omi24,l_omi25,l_omi26
                   FROM omi_file
                 WHERE omi01=tm.omi01
                IF status THEN
#                  CALL cl_err('omi01','axr-256',1)   #No.FUN-660116
                   CALL cl_err3("sel","omi_file",tm.omi01,"","axr-256","","omi01",1)   #No.FUN-660116
                   NEXT FIELD omi01
                END IF
                 DISPLAY BY NAME tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6
#TQC-790101.....begin
      AFTER FIELD a1
         IF NOT cl_null(tm.a1) THEN 
            IF tm.a1 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a1
            END IF
         END IF
 
      AFTER FIELD a2
         IF NOT cl_null(tm.a2) THEN 
            IF tm.a2 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a2
            END IF
            IF NOT cl_null(tm.a1) THEN
               IF tm.a2 <= tm.a1 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a2
               END IF
            END IF
         END IF
 
      AFTER FIELD a3
         IF NOT cl_null(tm.a3) THEN 
            IF tm.a3 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a3
            END IF
            IF NOT cl_null(tm.a2) THEN
               IF tm.a3 <= tm.a2 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a3
               END IF
            END IF
         END IF
 
      AFTER FIELD a4
         IF NOT cl_null(tm.a4) THEN 
            IF tm.a4 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a4
            END IF
            IF NOT cl_null(tm.a3) THEN
               IF tm.a4 <= tm.a3 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a4
               END IF
            END IF
         END IF
 
      AFTER FIELD a5
         IF NOT cl_null(tm.a5) THEN 
            IF tm.a5 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a5
            END IF
            IF NOT cl_null(tm.a4) THEN
               IF tm.a5 <= tm.a4 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a5
               END IF
            END IF
         END IF
 
      AFTER FIELD a6
         IF NOT cl_null(tm.a6) THEN 
            IF tm.a6 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a6
            END IF
            IF NOT cl_null(tm.a5) THEN
               IF tm.a6 <= tm.a5 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a6
               END IF
            END IF
         END IF
#TQC-790101.....end
 
      AFTER FIELD x
         IF cl_null(tm.x) OR tm.x NOT MATCHES '[12]' THEN
            NEXT FIELD x
         END IF
      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
            NEXT FIELD e
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
 
      #FUN-760016---add---str---
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(omi01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_omi01'
               LET g_qryparam.default1 = tm.omi01
               CALL cl_create_qry() RETURNING tm.omi01
               DISPLAY BY NAME tm.omi01
#              NEXT FIELD tm.omi01                       #TQC-A90001 Mark
               NEXT FIELD omi01                          #TQC-A90001 Add
         END CASE 
      #FUN-760016---add---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr620','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.omi01 CLIPPED,"'" ,   #TQC-610059
                         " '",tm.a1 CLIPPED,"'" ,
                         " '",tm.a2 CLIPPED,"'" ,
                         " '",tm.a3 CLIPPED,"'" ,
                         " '",tm.a4 CLIPPED,"'" ,
                         " '",tm.a5 CLIPPED,"'" ,   #TQC-610059
                         " '",tm.a6 CLIPPED,"'" ,   #TQC-610059
                         " '",tm.x CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.detail CLIPPED,"'"  ,   #TQC-610059
                         " '",tm.e CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr620()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr620_w
END FUNCTION
 
FUNCTION axrr620()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20),        # External(Disk) file name
          l_time    LIKE type_file.chr8,          #No.FUN-680123 VARCHAR(8),         # Used time for running the job
          #l_sql     VARCHAR(1600),                  #MOD-660113
          #l_sql1    VARCHAR(1000),                  #MOD-660113
          l_sql     STRING,                       #MOD-660113
          l_sql1    STRING,                       #MOD-660113
          amt1,amt2 LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6),
          amt3      LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6),
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40),
          l_oma00       LIKE oma_file.oma00,
          l_omavoid     LIKE oma_file.omavoid,
          l_omaconf     LIKE oma_file.omaconf,
          l_bucket      LIKE type_file.num5,             #No.FUN-680123 SMALLINT,
          l_order   ARRAY[5] OF LIKE cre_file.cre08,      #No.FUN-680123 VARCHAR(10),
          sr        RECORD
                 #   order1    LIKE cre_file.cre08,        #No.FUN-680123 VARCHAR(10),
                 #   order2    LIKE cre_file.cre08,        #No.FUN-680123 VARCHAR(10),
                 #   order3    LIKE cre_file.cre08,        #No.FUN-680123 VARCHAR(10),
                 #   order4    LIKE cre_file.cre08,        #No.FUN-680123 VARCHAR(10),
                    oma01     LIKE oma_file.oma01,
                    oma14     LIKE oma_file.oma14,   #業務員編號
                    oma15     LIKE oma_file.oma15,   #部門
                    gen02     LIKE gen_file.gen02,   #業務員
                    oca01     LIKE oca_file.oca01,
                    oca02     LIKE oca_file.oca02,   #客戶分類說明
                    oma03     LIKE oma_file.oma03,   #客戶
                    oma032    LIKE oma_file.oma032,  #簡稱
                    oma02     LIKE oma_file.oma02,   #客戶
                    omc02     LIKE omc_file.omc02,   #子帳期項次
                    oma11     LIKE oma_file.oma11,   #客戶
                    num1      LIKE oma_file.oma56t,  #應收金額
                    num2      LIKE oma_file.oma57,
                    num3      LIKE oma_file.oma57,
                    num4      LIKE oma_file.oma57,
                    num5      LIKE oma_file.oma57,
                    num6      LIKE oma_file.oma57,
                    num7      LIKE oma_file.oma57,
                    tot       LIKE oma_file.oma56,       #未沖金額
                    num1_o    LIKE oma_file.oma56t,  #MOD-850112 add  #呆帳比率計算金額
                    num2_o    LIKE oma_file.oma57,   #MOD-850112 add  #呆帳比率計算金額
                    num3_o    LIKE oma_file.oma57,   #MOD-850112 add  #呆帳比率計算金額
                    num4_o    LIKE oma_file.oma57,   #MOD-850112 add  #呆帳比率計算金額
                    num5_o    LIKE oma_file.oma57,   #MOD-850112 add  #呆帳比率計算金額
                    num6_o    LIKE oma_file.oma57,   #MOD-850112 add  #呆帳比率計算金額
                    num7_o    LIKE oma_file.oma57    #MOD-850112 add  #呆帳比率計算金額
                    END RECORD
   DEFINE l_oox01   STRING                 #CHI-830003 add
   DEFINE l_oox02   STRING                 #CHI-830003 add
   DEFINE l_sql_1   STRING                 #CHI-830003 add
   DEFINE l_sql_2   STRING                 #CHI-830003 add
   DEFINE l_omb03_1 LIKE omb_file.omb03    #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5    #CHI-830003 add
   DEFINE l_oma24   LIKE oma_file.oma24    #CHI-830003 add                    
   DEFINE l_oma54t  LIKE oma_file.oma54t   #MOD-C90124 add
   DEFINE l_oma56t  LIKE oma_file.oma56t   #MOD-C90124 add
   DEFINE l_omc06   LIKE omc_file.omc06    #MOD-C90124 add
   DEFINE l_oma16   LIKE oma_file.oma16    #MOD-C90124 add
   DEFINE l_oma52   LIKE oma_file.oma52    #原幣訂金 #MOD-C90124 add
   DEFINE l_oma53   LIKE oma_file.oma53    #本幣訂金 #MOD-C90124 add
   DEFINE l_oma_osum LIKE oma_file.oma57   #MOD-C90124 add
   DEFINE l_oma_lsum LIKE oma_file.oma57   #MOD-C90124 add
 
     #MOD-720047 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     #MOD-720047 - END
  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axrr620'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 192 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
     #No.MOD-5C0069  --begin
     DROP TABLE omax_file   #MOD-680103
     IF g_ooz.ooz07 = 'N' THEN
        IF tm.x='1' THEN   #MOD-920131 add
           SELECT * FROM oma_file
            WHERE omaconf='Y'
              AND oma02 <= tm.edate
              AND (oma56t>oma57 OR
                   oma01 IN (SELECT oob06 FROM ooa_file,oob_file
                              WHERE ooa01=oob01 AND ooa02 > tm.edate
                                AND ooa37 = '1')                            #FUN-B20014
                                OR                                          #MOD-C90124 add
                   oma16 IN (SELECT oma19 FROM oma_file                     #MOD-C90124 add
                              WHERE omaconf = 'Y' AND omavoid = 'N'         #MOD-C90124 add
                                AND (oma00 = '12' OR oma00 = '13')          #MOD-C90124 add
                                AND oma02 > tm.edate))                      #MOD-C90124 add
             INTO TEMP omax_file
       #str MOD-920131 add  
        ELSE
           SELECT * FROM oma_file
            WHERE omaconf='Y'
              AND oma11 <= tm.edate
              AND (oma56t>oma57 OR
                   oma01 IN (SELECT oob06 FROM ooa_file,oob_file
                              WHERE ooa01=oob01 AND ooa02 > tm.edate
                                AND ooa37 = '1')           #FUN-B20014                              
                                OR                                          #MOD-C90124 add
                   oma16 IN (SELECT oma19 FROM oma_file                     #MOD-C90124 add
                              WHERE omaconf = 'Y' AND omavoid = 'N'         #MOD-C90124 add
                                AND (oma00 = '12' OR oma00 = '13')          #MOD-C90124 add
                                AND oma02 > tm.edate))                      #MOD-C90124 add
             INTO TEMP omax_file
        END IF
       #end MOD-920131 add  
        LET l_sql="SELECT ",
                  "    oma01,oma14,oma15,gen02,oca01,oca02,oma03,oma032,",
                  "    oma02,omc02,omc04,omc09-omc11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,oma00, ",   #MOD-850112 add 0,0,0,0,0,0,0,
                  "    oma16 ",                                                              #MOD-C90124 add oma16
                 #"  FROM omax_file, omc_file,gen_file,occ_file,  oca_file,gem_file",        #CHI-D10056 mark   FUN-760016 add gem_file #No.FUN-680022 add omc
                  "  FROM omc_file , occ_file,oca_file,gem_file",                            #CHI-D10056
                  "      ,omax_file LEFT JOIN gen_file ON oma14 = gen01",                    #CHI-D10056
                 #" WHERE oma14=gen01 AND oma00 MATCHES '1*'   ",   #TQC-660146
                 #" WHERE oma14=gen01 ",   #TQC-660146         #CHI-D10056 mark
                 #"   AND omaconf = 'Y' AND omavoid = 'N'",    #CHI-D10056 mark    #97/07/29 modify
                  " WHERE omaconf = 'Y' AND omavoid = 'N'",    #CHI-D10056 
                  "   AND oma01=omc01 ",         #No.FUN-680022
                  "   AND oma15=gem_file.gem01 ",         #FUN-760016 add 
                  "   AND occ01=oma03 AND occ03 = oca_file.oca01 AND ",tm.wc CLIPPED
           #讀取折讓金額 No.B251 010412 by linda add
           #-----TQC-660146---------
           IF tm.e = 'Y' THEN
              LET l_sql = l_sql CLIPPED,
                          "AND (oma00 MATCHES '1*' OR oma00 MATCHES '2*')"
           ELSE
              LET l_sql = l_sql CLIPPED,
                          "AND oma00 MATCHES '1*' "
           END IF
     ELSE
        IF tm.x='1' THEN   #MOD-920131 add
           SELECT * FROM oma_file
            WHERE omaconf='Y'
              AND oma02 <= tm.edate
              AND (oma61 > 0    OR
                   oma01 IN (SELECT oob06 FROM ooa_file,oob_file
                              WHERE ooa01=oob01 AND ooa02 > tm.edate
                                AND ooa37 = '1')           #FUN-B20014                              
                             OR                                             #MOD-C90124 add
                   oma16 IN (SELECT oma19 FROM oma_file                     #MOD-C90124 add
                              WHERE omaconf = 'Y' AND omavoid = 'N'         #MOD-C90124 add
                                AND (oma00 = '12' OR oma00 = '13')          #MOD-C90124 add
                                AND oma02 > tm.edate))                      #MOD-C90124 add
             INTO TEMP omax_file
       #str MOD-920131 add  
        ELSE
           SELECT * FROM oma_file
            WHERE omaconf='Y'
              AND oma11 <= tm.edate
              AND (oma61 > 0 OR
                   oma01 IN (SELECT oob06 FROM ooa_file,oob_file
                              WHERE ooa01=oob01 AND ooa02 > tm.edate
                                AND ooa37 = '1')           #FUN-B20014                              
                             OR                                             #MOD-C90124 add
                   oma16 IN (SELECT oma19 FROM oma_file                     #MOD-C90124 add
                              WHERE omaconf = 'Y' AND omavoid = 'N'         #MOD-C90124 add
                                AND (oma00 = '12' OR oma00 = '13')          #MOD-C90124 add
                                AND oma02 > tm.edate))                      #MOD-C90124 add
             INTO TEMP omax_file
        END IF
       #end MOD-920131 add  
        LET l_sql="SELECT ",
                  "    oma01,oma14,oma15,gen02,oca01,oca02,oma03,oma032,",
                  "    oma02,omc02,omc04,omc13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,oma00, ", #No.FUN-680022  #MOD-850112 add 0,0,0,0,0,0,0,
                  "    oma16 ",                                                             #MOD-C90124 add
                 #"  FROM omax_file,omc_file,gen_file,occ_file,  oca_file",                 #CHI-D10056 mark   No.FUN-680022 add omc
                  "  FROM omc_file , occ_file,oca_file",                                    #CHI-D10056
                  "      ,omax_file LEFT JOIN gen_file ON oma14 = gen01",                   #CHI-D10056
                 #" WHERE oma14=gen01 AND oma00 MATCHES '1*'   ",   #TQC-660146
                 #" WHERE oma14=gen01 ",   #TQC-660146       #CHI-D10056 mark
                 #"   AND omaconf = 'Y' AND omavoid = 'N'",  #CHI-D10056 mark  97/07/29 modify
                  " WHERE omaconf = 'Y' AND omavoid = 'N'",  #CHI-D10056 
                  "   AND omc01=oma01 ",         #No.FUN-680022
                  "   AND occ01=oma03 AND occ03 = oca_file.oca01 AND ",tm.wc CLIPPED
           #讀取折讓金額 No.B251 010412 by linda add
           #-----TQC-660146---------
           IF tm.e = 'Y' THEN
              LET l_sql = l_sql CLIPPED,
                          "AND (oma00 MATCHES '1*' OR oma00 MATCHES '2*')"
           ELSE
              LET l_sql = l_sql CLIPPED,
                          "AND oma00 MATCHES '1*' "
           END IF
     END IF
     #No.MOD-5C0069  --end
     PREPARE axrr620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr620_curs1 CURSOR FOR axrr620_prepare1
 
     LET g_pageno = 0
         LET l_tot=0
     FOREACH axrr620_curs1 INTO sr.*,l_oma00,l_oma16                    #MOD-C90124 add oma16
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
      #CHI-830003--Add--Begin--#    
      IF g_ooz.ooz07 = 'Y' THEN
         LET l_oox01 = YEAR(tm.edate)
         LET l_oox02 = MONTH(tm.edate)                      	 
         LET l_oma24 = ''    #TQC-B10083 add
         WHILE cl_null(l_oma24)
            IF g_ooz.ooz62 = 'N' THEN
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 = '0'"
               PREPARE r620_prepare7 FROM l_sql_2
               DECLARE r620_oox7 CURSOR FOR r620_prepare7
               OPEN r620_oox7
               FETCH r620_oox7 INTO l_count
               CLOSE r620_oox7                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'   #TQC-B10083 mark 
                  EXIT WHILE           #TQC-B10083 add
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '0'"
               END IF                 
            ELSE
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 <> '0'"
               PREPARE r620_prepare8 FROM l_sql_2
               DECLARE r620_oox8 CURSOR FOR r620_prepare8
               OPEN r620_oox8
               FETCH r620_oox8 INTO l_count
               CLOSE r620_oox8                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'     #TOC-B10083 mark
                  EXIT WHILE             #TQC-B10083 add
               ELSE            
                  SELECT MIN(omb03) INTO l_omb03_1 FROM omb_file
                   WHERE omb01 = sr.oma01
                  IF cl_null(l_omb03_1) THEN
                     LET l_omb03_1 = 0
                  END IF       
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '",l_omb03_1,"'"                                      
               END IF
            END IF   
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE r620_prepare07 FROM l_sql_1
               DECLARE r620_oox07 CURSOR FOR r620_prepare07
               OPEN r620_oox07
               FETCH r620_oox07 INTO l_oma24
               CLOSE r620_oox07
            END IF              
         END WHILE              
      END IF
      #CHI-830003--Add--End--#       
       
       IF l_oma00 MATCHES '1*' THEN
          LET amt1=0 LET amt2=0
          SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2
               FROM oob_file, ooa_file
              WHERE oob06=sr.oma01 AND oob03='2' AND oob04='1' AND ooaconf='Y'
                AND ooa37 = '1'            #FUN-B20014              
                AND oob19=sr.omc02               #No.FUN-680022
                AND ooa01=oob01 AND ooa02 > tm.edate
          IF amt1 IS NULL THEN LET amt1=0 END IF
          IF amt2 IS NULL THEN LET amt2=0 END IF
          #CHI-830003--Begin--#
          #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
          IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN   #TQC-B10083 mod
             LET amt2 = amt1 * l_oma24
          END IF    
          #CHI-830003--End--#          
          LET amt2=sr.num1+amt2 LET sr.num1=0
       ELSE
          #讀取折讓金額 No.B251 010412 by linda add
          LET amt1=0 LET amt2=0
          SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2
               FROM oob_file, ooa_file
              WHERE oob06=sr.oma01 AND oob03='1' AND oob04='3' AND ooaconf='Y'
                AND oob19=sr.omc02               #No.FUN-680022
                AND ooa01=oob01 AND ooa02 > tm.edate
                AND ooa37 = '1'            #FUN-B20014                
          IF amt1 IS NULL THEN LET amt1=0 END IF
          IF amt2 IS NULL THEN LET amt2=0 END IF
          #CHI-830003--Begin--#
          #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
          IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN   #TQC-B10083 mod
             LET amt2 = amt1 * l_oma24
          END IF    
          #CHI-830003--End--#          
         #---------------------------------MOD-C90124---------------------------(S)
         #當oma00='23'的帳單號碼抓取對應到oma00='12'的oma19其單據日期>截止日期,
         #已沖金額需加回這些超出截止日期單據的oma52,oma53
          IF l_oma00 = '23' THEN
             LET l_oma52 = 0
             LET l_oma53 = 0
             LET sr.num1 = 0
             LET l_sql ="SELECT omc08-omc10,omc09-omc11,omc06",
                        "  FROM omc_file",
                        " WHERE omc01='",sr.oma01,"'",
                        "   AND omc02= ",sr.omc02
             PREPARE r620_pre1 FROM l_sql
             DECLARE r620_c1 CURSOR FOR r620_pre1
             OPEN r620_c1
             FETCH r620_c1 INTO l_oma54t,l_oma56t,l_omc06

             IF cl_null(l_oma54t) THEN LET l_oma54t = 0 END IF
             IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN
                LET l_oma56t = l_oma54t * l_oma24
                CALL cl_digcut(l_oma56t,g_azi04) RETURNING l_oma56t
             END IF
             IF cl_null(l_oma56t) THEN LET l_oma56t=0 END IF
             IF cl_null(l_omc06)  THEN LET l_omc06 =1 END IF
             LET l_sql = "SELECT SUM(oma52),SUM(oma53) ",
                         "  FROM oma_file",   #FUN-A10098
                         " WHERE oma19='",l_oma16,"'",
                         "   AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N' ",
                         "   AND oma02 > '",tm.edate,"'"
             PREPARE r620_pre2 FROM l_sql
             DECLARE r620_c2 CURSOR FOR r620_pre2
             OPEN r620_c2
             FETCH r620_c2 INTO l_oma_osum,l_oma_lsum

             IF cl_null(l_oma_osum) THEN LET l_oma_osum=0 END IF
             IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN
                LET l_oma_lsum = l_oma_osum * l_oma24
                CALL cl_digcut(l_oma_lsum,g_azi04) RETURNING l_oma_lsum
             END IF
             IF cl_null(l_oma_lsum) THEN LET l_oma_lsum = 0 END IF
            #未沖金額 = 應收 - 已收
             LET l_oma52 = l_oma54t + l_oma_osum
            #預收待抵本幣金額 = 預收剩餘原幣 x 原立帳匯率
             LET l_oma53 = l_oma52 * l_omc06
             CALL cl_digcut(l_oma53,g_azi04) RETURNING l_oma53
          END IF
          IF cl_null(l_oma53) THEN LET l_oma53 = 0 END IF   #MOD-D30025
         #---------------------------------MOD-C90124---------------------------(E)
          LET amt2 = sr.num1 + amt2 + l_oma53                    #MOD-C90124 add l_oma53
          LET sr.num1 = 0
          LET amt2 = amt2 * -1
          #No.B251 end --------
       END IF
           IF tm.x='2' THEN LET sr.oma02=sr.oma11 END IF
           LET l_bucket=tm.edate-sr.oma02
          #str MOD-850112 add
           CASE WHEN l_bucket<=tm.a1 LET sr.num1=amt2
                WHEN l_bucket<=tm.a2 LET sr.num2=amt2
                WHEN l_bucket<=tm.a3 LET sr.num3=amt2
                WHEN l_bucket<=tm.a4 LET sr.num4=amt2
                WHEN l_bucket<=tm.a5 LET sr.num5=amt2
                WHEN l_bucket<=tm.a6 LET sr.num6=amt2
                OTHERWISE            LET sr.num7=amt2
           END CASE
          #end MOD-850112 add
         #str MOD-850112 mod
         # CASE WHEN l_bucket<=tm.a1 LET sr.num1=amt2 * l_omi21/100
         #      WHEN l_bucket<=tm.a2 LET sr.num2=amt2 * l_omi22/100
         #      WHEN l_bucket<=tm.a3 LET sr.num3=amt2 * l_omi23/100
         #      WHEN l_bucket<=tm.a4 LET sr.num4=amt2 * l_omi24/100
         #      WHEN l_bucket<=tm.a5 LET sr.num5=amt2 * l_omi25/100
         #      WHEN l_bucket<=tm.a6 LET sr.num6=amt2 * l_omi26/100
         #      OTHERWISE            LET sr.num7=amt2
         ##FUN-710066 end
         # END CASE
           CASE WHEN l_bucket<=tm.a1 LET sr.num1_o=amt2 * l_omi21/100
                WHEN l_bucket<=tm.a2 LET sr.num2_o=amt2 * l_omi22/100
                WHEN l_bucket<=tm.a3 LET sr.num3_o=amt2 * l_omi23/100
                WHEN l_bucket<=tm.a4 LET sr.num4_o=amt2 * l_omi24/100
                WHEN l_bucket<=tm.a5 LET sr.num5_o=amt2 * l_omi25/100
                WHEN l_bucket<=tm.a6 LET sr.num6_o=amt2 * l_omi26/100
                OTHERWISE            LET sr.num7_o=amt2
           END CASE
         #str MOD-850112 mod
 
         #MOD-720047 - START
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         LET sr.tot=sr.num1+sr.num2+sr.num3+sr.num4+sr.num5+sr.num6+sr.num7
         EXECUTE insert_prep USING sr.*,t_azi04,t_azi05
         #MOD-720047 - END
     END FOREACH
 
     #MOD-720047 - START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oma15,oma14,oca01,oma03,oma18')   #FUN-C40021 add 'oma18'
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str CLIPPED,";",
           tm.a1,";",tm.a2,";",tm.a3,";",tm.a4,";",
           tm.a5,";",tm.a6,";",tm.x,";",tm.edate,";",tm.detail,";",tm.e
     CALL cl_prt_cs3('axrr620','axrr620',l_sql,g_str)   #FUN-710080 modify
     #------------------------------ CR (4) ------------------------------#
     #MOD-720047 - END
END FUNCTION
