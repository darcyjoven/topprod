# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr810.4gl
# Descriptions...: 三角貿易出貨廠商明細表(axmr810)
# Input parameter:
# Return code....:
# Date & Author..: 98/12/28  By Billy
# Date & Author..: 03/09/30  By Ching No.7946
# Modify.........: No.FUN-4C0096 05/03/03 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550018 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.FUN-550070 05/05/26 By will 單據編號放大
# Modify.........: No.FUN-580013 05/08/15 By will 報表轉XML格式
# Modify.........: NO.TQC-5B0031 05/11/07 BY YITING 報表欄位沒對齊
# Modify.........: No.TQC-630214 06/03/27 By pengu 報表列印選擇輸出Excel、Word時，呈現的資料切割不正常
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: NO.TQC-7C0022 07/12/05 by fangyan 崝增加開窗查詢
# Modify.........: NO.TQC-7C0022 07/12/08 by fangyan 重新寫qry查詢語句
# Modyfy.........: No.FUN-850018 08/05/07 By ChenMoyan 把老報表轉成CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-980115 09/08/17 By Dido 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-970360 09/12/30 By baofei EXECUTE insert_prep USING l_pox.pox06_6->l_pox.pox05_6 
# Modify.........: NO.FUN-A10056 10/01/13 By lutingting 跨DB寫法修改
# Modify.........: No:MOD-A20020 10/02/03 By Dido 出貨區間日期給予預設值 
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.FUN-A50102 10/07/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-C20167 12/02/21 By Vampire 報表範圍下*會導致fetch lga01_cs的錯誤一直出現這個訊息
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,  # No.FUN-680137 VARCHAR(300)     # Where condition
              bdate   LIKE type_file.dat,      # No.FUN-680137 DATE
              edate   LIKE type_file.dat,      # No.FUN-680137 DATE
              trn     LIKE type_file.chr1,     # No.FUN-680137 VARCHAR(1)
              more    LIKE type_file.chr1     # No.FUN-680137 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
#         g_dash1  VARCHAR(300),  #No.FUN-580013
#         g_dash2  VARCHAR(300)   #No.FUN-580013
 
DEFINE   i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(72)
#No.FUN-850018 --Begin
 DEFINE  g_str           LIKE type_file.chr1000,
         #g_sql           LIKE type_file.chr1000,
         g_sql           STRING,       #NO.FUN-910082
         l_table         STRING        #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
#No.FUN-850018 --End
#No.FUN-580013  --begin
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580013  --end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#No.FUN-850018 --Begin
   LET g_sql="oga01.oga_file.oga01,",
             "oga02.oga_file.oga02,",
             "oga03.oga_file.oga03,",
             "oga23.oga_file.oga23,",
             "oga24.oga_file.oga24,",
             "oga50.oga_file.oga50,",
             "oga501.oga_file.oga501,",
             "oma10.oma_file.oma10,",
             "oea904.oea_file.oea904,",
             "poy03_1.poy_file.poy03,",
             "poy03_2.poy_file.poy03,",
             "poy03_3.poy_file.poy03,",                                                                                             
             "poy03_4.poy_file.poy03,",
             "poy03_5.poy_file.poy03,",                                                                                             
             "poy03_6.poy_file.poy03,",
             "poy05_1.poy_file.poy05,",                                                                                             
             "poy05_2.poy_file.poy05,",                                                                                             
             "poy05_3.poy_file.poy05,",                                                                                             
             "poy05_4.poy_file.poy05,",                                                                                             
             "poy05_5.poy_file.poy05,",                                                                                             
             "poy05_6.poy_file.poy05,",
             "oga50_1.oga_file.oga50,",
             "oga50_2.oga_file.oga50,",
             "oga50_3.oga_file.oga50,",
             "oga50_4.oga_file.oga50,",                                                                                             
             "oga50_5.oga_file.oga50,",                                                                                             
             "oga50_6.oga_file.oga50,",
             "oga50_7.oga_file.oga50,",
             "oga501_7.oga_file.oga501,",
             "pox05_1.pox_file.pox05,",
             "pox06_1.pox_file.pox06,",
             "pox05_2.pox_file.pox05,",                                                                                             
             "pox06_2.pox_file.pox06,",
             "pox05_3.pox_file.pox05,",                                                                                             
             "pox06_3.pox_file.pox06,",
             "pox05_4.pox_file.pox05,",                                                                                             
             "pox06_4.pox_file.pox06,",                                                                                             
             "pox05_5.pox_file.pox05,",                                                                                             
             "pox06_5.pox_file.pox06,",                                                                                             
             "pox05_6.pox_file.pox05,",                                                                                             
             "pox06_6.pox_file.pox06,",
             "azi07.azi_file.azi07 "     #No.FUN-870151
   LET l_table = cl_prt_temptable('axmr810',g_sql) CLIPPED 
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                     " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  #No.FUN-870151 Add"?" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
#-----------------No.TQC-610089 modify
   LET tm.trn   = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
#-----------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr810_tm(0,0)        # Input print condition
      ELSE CALL axmr810()            # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr810_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr810_w AT p_row,p_col WITH FORM "axm/42f/axmr810"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate= g_today
   LET tm.edate= g_today              #MOD-A20020
   LET tm.trn='Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01, oga03, oga04, oga14
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
  #..NO.TQC-7C0022.......BEGIN....
      ON ACTION controlp
         CASE
            WHEN INFIELD(oga01)
            CALL cl_init_qry_var()
            LET g_qryparam.state = 'c'
            #LET g_qryparam.form ="q_oga01"
            LET g_qryparam.form ="q_oga011"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oga01
            NEXT FIELD oga01
         END CASE
   #..NO.TQC-7C0022.......END....
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
#UI
   INPUT BY NAME tm.bdate,tm.edate,tm.trn,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD trn
           IF cl_null(tm.trn) OR tm.trn NOT MATCHES '[YN]' THEN
              NEXT FIELD trn
           END IF
      AFTER  FIELD edate
           IF tm.bdate > tm.edate THEN
              NEXT FIELD bdate
           END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr810'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr810','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.trn CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",              #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL axmr810()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr810_w
END FUNCTION
 
FUNCTION axmr810()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_chr        LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
  #       l_azp      ARRAY[6] OF LIKE type_file.chr20,    # No.FUN-680137 VARCHAR(20)# No.FUN-850018
          l_azp      ARRAY[7] OF LIKE type_file.chr20,    # No.FUN-850018 VARCHAR(20)
  #       l_dbs      ARRAY[6] OF LIKE type_file.chr20,    # No.FUN-680137 VARCHAR(20)
          l_dbs      ARRAY[7] OF LIKE type_file.chr20,    # No.FUN-850018
          l_azp01    ARRAY[7] OF LIKE type_file.chr10,    # No.FUN-A10056  
          p_oga01    LIKE oga_file.oga01,     #出貨單號
          l_plant    LIKE azp_file.azp01,
          l_oma54    LIKE oma_file.oma54,
          l_oma56    LIKE oma_file.oma56,
          l_oma01    LIKE oma_file.oma01,
          l_p_dbs    LIKE type_file.chr20,    # No.FUN-680137 VARCHAR(21)
          l_apa31    LIKE apa_file.apa31,
          l_apa31f   LIKE apa_file.apa31f,
          l_pox      RECORD
                 pox02   LIKE pox_file.pox02,
                 pox05_1 LIKE pox_file.pox05,
                 pox06_1 LIKE pox_file.pox06,
                 pox05_2 LIKE pox_file.pox05,
                 pox06_2 LIKE pox_file.pox06,
                 pox05_3 LIKE pox_file.pox05,
                 pox06_3 LIKE pox_file.pox06,
                 pox05_4 LIKE pox_file.pox05,
                 pox06_4 LIKE pox_file.pox06,
                 pox05_5 LIKE pox_file.pox05,
                 pox06_5 LIKE pox_file.pox06,
                 pox05_6 LIKE pox_file.pox05,
                 pox06_6 LIKE pox_file.pox06
                     END RECORD ,
          l_oga      DYNAMIC ARRAY OF RECORD
                 oga50   LIKE oga_file.oga50,
                 oga501  LIKE oga_file.oga501,
                 azi04   LIKE azi_file.azi04,
                 azi05   LIKE azi_file.azi05
                     END RECORD ,
          sr               RECORD
                 oga01  LIKE oga_file.oga01 ,  #出貨單號
                 oga02  LIKE oga_file.oga02 ,  #出貨日期
                 oga03  LIKE oga_file.oga03 ,  #帳款客戶編號
                 oga23  LIKE oga_file.oga23 ,  #幣別
                 oga24  LIKE oga_file.oga24 ,  #匯率
                 oga50  LIKE oga_file.oga50 ,  #員幣出貨金額
                 oga501 LIKE oga_file.oga501,  #本幣出貨金額
                 oma10  LIKE oma_file.oma10 ,  #發票號碼
                 oma03  LIKE oma_file.oma03 ,  #帳款客戶編號
                 oma23  LIKE oma_file.oma23 ,  #幣別
                 oma24  LIKE oma_file.oma24 ,  #匯率
                 oea904 LIKE oea_file.oea904,  #流程代碼
                 poy03_1 LIKE poy_file.poy03 ,  #下游廠商
                 poy03_2 LIKE poy_file.poy03 ,  #下游廠商
                 poy03_3 LIKE poy_file.poy03 ,  #下游廠商
                 poy03_4 LIKE poy_file.poy03 ,  #下游廠商
                 poy03_5 LIKE poy_file.poy03 ,  #下游廠商
                 poy03_6 LIKE poy_file.poy03 ,  #下游廠商
                 poy04_1 LIKE poy_file.poy04 ,  #下游工廠
                 poy04_2 LIKE poy_file.poy04 ,  #下游工廠
                 poy04_3 LIKE poy_file.poy04 ,  #下游工廠
                 poy04_4 LIKE poy_file.poy04 ,  #下游工廠
                 poy04_5 LIKE poy_file.poy04 ,  #下游工廠
                 poy04_6 LIKE poy_file.poy04 ,  #下游工廠
                 poy05_1 LIKE poy_file.poy05 ,  #計價幣別
                 poy05_2 LIKE poy_file.poy05 ,  #計價幣別
                 poy05_3 LIKE poy_file.poy05 ,  #計價幣別
                 poy05_4 LIKE poy_file.poy05 ,  #計價幣別
                 poy05_5 LIKE poy_file.poy05 ,  #計價幣別
                 poy05_6 LIKE poy_file.poy05 ,  #計價幣別
                 azi04  LIKE azi_file.azi04 ,  #幣別小數
                 azi07  LIKE azi_file.azi07 ,  #匯率小數
                 azi05  LIKE azi_file.azi05 ,  #幣別小數
                 oga50_1  LIKE oga_file.oga50 ,
                 oga501_1 LIKE oga_file.oga501 ,
                 azi04_1  LIKE azi_file.azi04 ,
                 azi05_1  LIKE azi_file.azi05 ,
                 oga50_2  LIKE oga_file.oga50 ,
                 oga501_2 LIKE oga_file.oga501 ,
                 azi04_2  LIKE azi_file.azi04 ,
                 azi05_2  LIKE azi_file.azi05 ,
                 oga50_3  LIKE oga_file.oga50 ,
                 oga501_3 LIKE oga_file.oga501 ,
                 azi04_3  LIKE azi_file.azi04 ,
                 azi05_3  LIKE azi_file.azi05 ,
                 oga50_4  LIKE oga_file.oga50 ,
                 oga501_4 LIKE oga_file.oga501 ,
                 azi04_4  LIKE azi_file.azi04 ,
                 azi05_4  LIKE azi_file.azi05 ,
                 oga50_5  LIKE oga_file.oga50 ,
                 oga501_5 LIKE oga_file.oga501 ,
                 azi04_5  LIKE azi_file.azi04 ,
                 azi05_5  LIKE azi_file.azi05 ,
                 oga50_6  LIKE oga_file.oga50 ,
                 oga501_6 LIKE oga_file.oga501 ,
                 azi04_6  LIKE azi_file.azi04 ,
                 azi05_6  LIKE azi_file.azi05,
                 oga50_7  LIKE oga_file.oga50 ,
                 oga501_7 LIKE oga_file.oga501,
                 oga16    LIKE oga_file.oga16,
                 oga99    LIKE oga_file.oga99
          END RECORD
 
     CALL cl_wait()
     CALL cl_del_data(l_table)                       #No.FUN-850018
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580013  --begin
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr810'#No.FUN-850018
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
##     LET g_len = 136   #變動的報表長度             #No.FUN-550018
#    LET g_len = 142   #變動的報表長度             #No.FUN-550070
#    FOR g_i = 1 TO g_len
#        LET g_dash1[g_i,g_i] = '-'
#        LET g_dash2[g_i,g_i] = '='
#    END FOR
##     LET g_len = 138     #No.FUN-550070
#No.FUN-580013  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     #End:FUN-980030
 
 
     LET l_sql = " SELECT " ,
                 " oga01 , oga02, oga03, oga23, oga24 ,oma54, oma56  , ",
                 " oma10 , oma03, oma23, oma24 , " ,
                 " '' , " , #No.B308
                 " '','','','','','', ",
                 " '','','','','','', ",
                 " '','','','','','', ",    #No.B308
                 " azi04 ,azi07, azi05 ,",
                 " '', '', '', '', '', '', '', '', '', '', '', '', ",
                 " '', '', '', '', '', '', '', '', '', '', '', '','',oma59,",
                 " oga16,oga99 ",
                 "   FROM oga_file, oma_file , azi_file ",
                 "  WHERE oga10 = oma01 ",
                 "    AND oga23 = azi01 ",
                 "    AND oga905 = 'Y' ",
                 "    AND oga906 = 'Y' ",
                 "    AND oga909 = 'Y' ",
                 "    AND oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "    AND ", tm.wc  CLIPPED,
                 "    AND ogaconf != 'X' " #01/08/20 mandy
 
     #已拋轉者不列印
     IF tm.trn='N' THEN
        LET l_sql=l_sql CLIPPED," AND (oma33 IS NULL OR oma33=' ') "
     END IF
     PREPARE axmr810_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
#No.FUN-850018 --Begin
#    CALL cl_outnam('axmr810') RETURNING l_name
#    CALL cl_prt_pos_len()    #No.FUN-580013
#    START REPORT axmr810_rep TO l_name              #No.FUN-850018
#No.FUN-850018 --End
     DECLARE axmr810_curs1 CURSOR FOR axmr810_prepare1
     FOREACH axmr810_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #NO.B308 010409 by linda add
        IF cl_null(sr.oga16) THEN
           #只讀取第一筆訂單之資料
           DECLARE oea_f CURSOR FOR
            SELECT oea904 FROM oea_file,ogb_file
                WHERE oea01 = ogb31
                  AND ogb01 = sr.oga01
                  AND oeaconf = 'Y' #01/08/16 mandy
           OPEN oea_f
           FETCH oea_f INTO sr.oea904
        ELSE
           #讀取該出貨單之訂單
           SELECT oea904 INTO sr.oea904
             FROM oea_file
            WHERE oea01 = sr.oga16
              AND oeaconf = 'Y' #01/08/16 mandy
        END IF
        #NO.7946
        SELECT  poy03 , poy04, poy05 INTO sr.poy03_1 , sr.poy04_1, sr.poy05_1
          FROM poy_file WHERE poy01 = sr.oea904 AND poy02 = 1
        SELECT  poy03 , poy04, poy05 INTO sr.poy03_2 , sr.poy04_2, sr.poy05_2
          FROM poy_file WHERE poy01 = sr.oea904 AND poy02 = 2
        SELECT  poy03 , poy04, poy05 INTO sr.poy03_3 , sr.poy04_3, sr.poy05_3
          FROM poy_file WHERE poy01 = sr.oea904 AND poy02 = 3
        SELECT  poy03 , poy04, poy05 INTO sr.poy03_4 , sr.poy04_4, sr.poy05_4
          FROM poy_file WHERE poy01 = sr.oea904 AND poy02 = 4
        SELECT  poy03 , poy04, poy05 INTO sr.poy03_5 , sr.poy04_5, sr.poy05_5
          FROM poy_file WHERE poy01 = sr.oea904 AND poy02 = 5
        SELECT  poy03 , poy04, poy05 INTO sr.poy03_6 , sr.poy04_6, sr.poy05_6
          FROM poy_file WHERE poy01 = sr.oea904 AND poy02 = 6
        #No.B309 end------
        FOR i=1 TO 6
            LET l_azp[i]=''
            INITIALIZE l_oga[i].* TO NULL
        END FOR
 
     LET  l_p_dbs=''
     #抓另外六個工廠的DATABASE
#     LET g_len=108
#     LET g_len=112                        #No.FUN-850018 
     FOR i = 1 TO 6
        IF i = 1 AND sr.poy03_1 IS NOT NULL THEN
           SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_1
           LET l_plant=sr.poy04_1
           LET l_azp01[i] = sr.poy04_1    #FUN-A10056
        END IF
        IF i = 2 AND sr.poy03_2 IS NOT NULL THEN
           SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_2
           LET l_plant=sr.poy04_2
           LET l_azp01[i] = sr.poy04_2    #FUN-A10056
        END IF
        IF i = 3 AND sr.poy03_3 IS NOT NULL THEN
           SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_3
           LET l_plant=sr.poy04_3
           LET l_azp01[i] = sr.poy04_3    #FUN-A10056
        END IF
        IF i = 4 AND sr.poy03_4 IS NOT NULL THEN
           SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_4
           LET l_plant=sr.poy04_4
           LET l_azp01[i] = sr.poy04_4    #FUN-A10056 
        END IF
        IF i = 5 AND sr.poy03_5 IS NOT NULL THEN
           SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_5
           LET l_plant=sr.poy04_5
           LET l_azp01[i] = sr.poy04_5    #FUN-A10056
        END IF
        IF i = 6 AND sr.poy03_6 IS NOT NULL THEN
           SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_6
           LET l_plant=sr.poy04_6
           LET l_azp01[i] = sr.poy04_6    #FUN-A10056
        END IF
 
        IF cl_null(l_azp[i]) THEN CONTINUE FOR END IF
       #LET l_dbs[i] = s_dbstring(l_azp[i] CLIPPED)		#MOD-980115 mark
        LET l_dbs[i] = s_dbstring(l_azp[i] CLIPPED)	#MOD-980115
        #CALL r810_getno(l_dbs[i],sr.oga99)    #FUN-A10056
        CALL r810_getno(l_azp01[i],sr.oga99)   #FUN-A10056
        RETURNING p_oga01
        LET l_sql = " SELECT oga50, oga501 , azi04 ,azi05  ",
                    " ,oma01,oma54,oma56 ",
                   #FUN-A10056--mod--str--
                   #"  FROM ", l_dbs[i] CLIPPED,"oga_file ",
                   #" LEFT OUTER JOIN ",l_dbs[i] CLIPPED,"oma_file ON oga10=oma01,",
                   #                    l_dbs[i] CLIPPED,"azi_file ",
                    "  FROM ",cl_get_target_table(l_azp01[i],'oga_file'),
                    " LEFT OUTER JOIN ",cl_get_target_table(l_azp01[i],'oma_file')," ON oga10=oma01,",
                                        cl_get_target_table(l_azp01[i],'azi_file'),
                   #FUN-A10056--mod--end
                    " WHERE oga23 = azi01 ",
                    "   AND oga01 = '",p_oga01,"'",
                    "   AND oga09 = '4' ",  #MOD-C20167 add
                    "   AND ogaconf != 'X' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
        PREPARE axmr810_prepare2 FROM l_sql
        IF STATUS THEN CALL cl_err('axmr810_prepare2',STATUS,1) END IF
        DECLARE axmr810_curs2 CURSOR FOR axmr810_prepare2
        OPEN axmr810_curs2
        FETCH axmr810_curs2 INTO l_oga[i].*,l_oma01,l_oma54,l_oma56
#No.7946
{
#        #最後一家以應付金額
#        LET l_sql = " SELECT apa31,apa31f ",     #FUN-A50102
#                    "  FROM ", l_p_dbs CLIPPED,"apa_file ",
#                    " WHERE apa01='",sr.oga01,"' ",
#                    "   AND apa42 = 'N' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#        PREPARE axmr810_prepare4 FROM l_sql
#        IF STATUS THEN CALL cl_err('axmr810_prepare2',STATUS,1) END IF
#        DECLARE axmr810_curs4 CURSOR FOR axmr810_prepare4
#        OPEN axmr810_curs4
#        FETCH axmr810_curs4 INTO l_apa31,l_apa31f
#        IF SQLCA.SQLCODE =0 AND l_apa31 IS NOT NULL THEN
#           LET  l_oga[i].oga50=l_apa31f
#           LET  l_oga[i].oga501=l_apa31
#        END IF
#        LET l_p_dbs=l_dbs[i]
}
#No.FUN-850018 --Begin
#       #計算報表長度
#       IF ( l_oga[i].oga50 IS NOT NULL ) THEN
#          LET g_len = g_len + 30
#       END IF
     END FOR
#      LET g_len=g_len+30
#No.FUN-850018 --End
 
        LET l_sql = " SELECT pox02,pox05,pox06 ",
                    " FROM pox_file ",
                    " WHERE pox01 = '",sr.oea904,"'",
                    "   AND pox04 = ? ",
                    " ORDER BY pox02 DESC "
        PREPARE axmr810_prepare3 FROM l_sql
        IF STATUS THEN CALL cl_err('axmr810_prepare3',STATUS,1) END IF
        DECLARE axmr810_curs3 CURSOR FOR axmr810_prepare3
        OPEN axmr810_curs3 USING '1'
        FETCH axmr810_curs3 INTO l_pox.pox02,l_pox.pox05_1,l_pox.pox06_1
        CLOSE axmr810_curs3
 
        OPEN axmr810_curs3 USING '2'
        FETCH axmr810_curs3 INTO l_pox.pox02,l_pox.pox05_2,l_pox.pox06_2
        CLOSE axmr810_curs3
 
        OPEN axmr810_curs3 USING '3'
        FETCH axmr810_curs3 INTO l_pox.pox02,l_pox.pox05_3,l_pox.pox06_3
        CLOSE axmr810_curs3
 
        OPEN axmr810_curs3 USING '4'
        FETCH axmr810_curs3 INTO l_pox.pox02,l_pox.pox05_4,l_pox.pox06_4
        CLOSE axmr810_curs3
 
        OPEN axmr810_curs3 USING '5'
        FETCH axmr810_curs3 INTO l_pox.pox02,l_pox.pox05_5,l_pox.pox06_5
        CLOSE axmr810_curs3
 
        OPEN axmr810_curs3 USING '6'
        FETCH axmr810_curs3 INTO l_pox.pox02,l_pox.pox05_6,l_pox.pox06_6
        CLOSE axmr810_curs3
 
      LET sr.oga50_1 = l_oga[1].oga50
      LET sr.oga501_1 = l_oga[1].oga501
      LET sr.azi04_1 = l_oga[1].azi04
      LET sr.azi05_1 = l_oga[1].azi05
      LET sr.oga50_2 = l_oga[2].oga50
      LET sr.oga501_2 = l_oga[2].oga501
      LET sr.azi04_2 = l_oga[2].azi04
      LET sr.azi05_2 = l_oga[2].azi05
      LET sr.oga50_3 = l_oga[3].oga50
      LET sr.oga501_3 = l_oga[3].oga501
      LET sr.azi04_3 = l_oga[3].azi04
      LET sr.azi05_3 = l_oga[3].azi05
      LET sr.oga50_4 = l_oga[4].oga50
      LET sr.oga501_4 = l_oga[4].oga501
      LET sr.azi04_4 = l_oga[4].azi04
      LET sr.azi05_4 = l_oga[4].azi05
      LET sr.oga50_5 = l_oga[5].oga50
      LET sr.oga501_5 = l_oga[5].oga501
      LET sr.azi04_5 = l_oga[5].azi04
      LET sr.azi05_5 = l_oga[5].azi05
      LET sr.oga50_6 = l_oga[6].oga50
      LET sr.oga501_6 = l_oga[6].oga501
      LET sr.azi04_6 = l_oga[6].azi04
      LET sr.azi05_6 = l_oga[6].azi05
      LET sr.oga50_7 = sr.oga50-l_oga[1].oga50
#No.FUN-850018 --Begin      
#     OUTPUT TO REPORT axmr810_rep(sr.* ,l_pox.*)
      IF cl_null(sr.oga50) THEN LET sr.oga50=0 END IF
      IF cl_null(sr.oga501) THEN LET sr.oga501=0 END IF
      IF cl_null(sr.oga50_7) THEN LET sr.oga50_7=0 END IF
      IF cl_null(sr.oga501_7) THEN LET sr.oga501_7=0 END IF
      IF cl_null(l_pox.pox06_1) THEN LET l_pox.pox06_1=0 END IF
      IF cl_null(l_pox.pox06_2) THEN LET l_pox.pox06_2=0 END IF
      IF cl_null(l_pox.pox06_3) THEN LET l_pox.pox06_3=0 END IF
      IF cl_null(l_pox.pox06_4) THEN LET l_pox.pox06_4=0 END IF
      IF cl_null(l_pox.pox06_5) THEN LET l_pox.pox06_5=0 END IF
      IF cl_null(l_pox.pox06_6) THEN LET l_pox.pox06_6=0 END IF
      EXECUTE insert_prep USING 
          sr.oga01,sr.oga02,sr.oga03,sr.oga23,sr.oga24,
          sr.oga50,sr.oga501,sr.oma10,sr.oea904,sr.poy03_1,
          sr.poy03_2,sr.poy03_3,sr.poy03_4,sr.poy03_5,sr.poy03_6,
          sr.poy05_1,sr.poy05_2,sr.poy05_3,sr.poy05_4,sr.poy05_5,
          sr.poy05_6,sr.oga50_1,sr.oga50_2,sr.oga50_3,sr.oga50_4,
          sr.oga50_5,sr.oga50_6,sr.oga50_7,sr.oga501_7,l_pox.pox05_1,
          l_pox.pox06_1,l_pox.pox05_2,l_pox.pox06_2,l_pox.pox05_3,l_pox.pox06_3,
          l_pox.pox05_4,l_pox.pox06_4,l_pox.pox05_5,l_pox.pox06_5,l_pox.pox05_6, #TQC-970360
          l_pox.pox06_6,sr.azi07                                                  #No.FUN-870151 Add azi07
     END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
          CALL cl_wcchp(tm.wc,'oga01,oga03,oga04,oga14')
              RETURNING tm.wc
     ELSE 
          LET tm.wc=""
     END IF 
     LET g_str = tm.wc,';',g_plant,';',tm.bdate,';',tm.edate
     CALL cl_prt_cs3('axmr810','axmr810',g_sql,g_str)
#    FINISH REPORT axmr810_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-850018 --End
END FUNCTION
 
#No.FUN-850018 --Begin
#REPORT axmr810_rep(sr, l_pox )
#  DEFINE  p_mode    LIKE type_file.chr1     # No.FUN-680137 VARCHAR(1)
#  DEFINE l_last_sw  LIKE type_file.chr1,     # No.FUN-680137 VARCHAR(1)
#         l_month    LIKE type_file.num5,     # No.FUN-680137 SMALLINT
#         l_sum01    LIKE oga_file.oga50 ,
#         l_sum02    LIKE oga_file.oga50 ,
#         l_sum03    LIKE oga_file.oga50 ,
#         l_sum04    LIKE oga_file.oga50 ,
#         l_sum05    LIKE oga_file.oga50 ,
#         l_sum06    LIKE oga_file.oga50 ,
#         l_sum07    LIKE oga_file.oga50 ,
#         l_sum08    LIKE oga_file.oga50 ,
#         l_sum09    LIKE oga_file.oga50 ,
#         l_sum10    LIKE oga_file.oga50 ,
#         l_sum11    LIKE oga_file.oga50 ,
#         l_sum12    LIKE oga_file.oga50 ,
#         l_sum13    LIKE oga_file.oga50 ,
#         l_sum14    LIKE oga_file.oga50 ,
#         l_sum15    LIKE oga_file.oga50 ,
#         l_sum16    LIKE oga_file.oga50 ,
#         l_pox      RECORD
#                pox02   LIKE pox_file.pox02 ,
#                pox05_1 LIKE pox_file.pox05 ,
#                pox06_1 LIKE pox_file.pox06 ,
#                pox05_2 LIKE pox_file.pox05 ,
#                pox06_2 LIKE pox_file.pox06 ,
#                pox05_3 LIKE pox_file.pox05 ,
#                pox06_3 LIKE pox_file.pox06 ,
#                pox05_4 LIKE pox_file.pox05 ,
#                pox06_4 LIKE pox_file.pox06 ,
#                pox05_5 LIKE pox_file.pox05 ,
#                pox06_5 LIKE pox_file.pox06 ,
#                pox05_6 LIKE pox_file.pox05 ,
#                pox06_6 LIKE pox_file.pox06
#                    END RECORD ,
#         l_oga      DYNAMIC ARRAY OF RECORD
#                oga50   LIKE oga_file.oga50,
#                oga501  LIKE oga_file.oga501,
#                azi04   LIKE azi_file.azi04,
#                azi05   LIKE azi_file.azi05
#                    END RECORD ,
#         sr               RECORD
#                oga01  LIKE oga_file.oga01 ,  #出貨單號
#                oga02  LIKE oga_file.oga02 ,  #出貨日期
#                oga03  LIKE oga_file.oga03 ,  #帳款客戶編號
#                oga23  LIKE oga_file.oga23 ,  #幣別
#                oga24  LIKE oga_file.oga24 ,  #匯率
#                oga50  LIKE oga_file.oga50 ,  #員幣出貨金額
#                oga501 LIKE oga_file.oga501,  #本幣出貨金額
#                oma10  LIKE oma_file.oma10 ,  #發票號碼
#                oma03  LIKE oma_file.oma03 ,  #帳款客戶編號
#                oma23  LIKE oma_file.oma23 ,  #幣別
#                oma24  LIKE oma_file.oma24 ,  #匯率
#                oea904 LIKE oea_file.oea904,  #流程代碼
#                poy03_1 LIKE poy_file.poy03 ,  #下游廠商
#                poy03_2 LIKE poy_file.poy03 ,  #下游廠商
#                poy03_3 LIKE poy_file.poy03 ,  #下游廠商
#                poy03_4 LIKE poy_file.poy03 ,  #下游廠商
#                poy03_5 LIKE poy_file.poy03 ,  #下游廠商
#                poy03_6 LIKE poy_file.poy03 ,  #下游廠商
#                poy04_1 LIKE poy_file.poy04 ,  #下游工廠
#                poy04_2 LIKE poy_file.poy04 ,  #下游工廠
#                poy04_3 LIKE poy_file.poy04 ,  #下游工廠
#                poy04_4 LIKE poy_file.poy04 ,  #下游工廠
#                poy04_5 LIKE poy_file.poy04 ,  #下游工廠
#                poy04_6 LIKE poy_file.poy04 ,  #下游工廠
#                poy05_1 LIKE poy_file.poy05 ,  #計價幣別
#                poy05_2 LIKE poy_file.poy05 ,  #計價幣別
#                poy05_3 LIKE poy_file.poy05 ,  #計價幣別
#                poy05_4 LIKE poy_file.poy05 ,  #計價幣別
#                poy05_5 LIKE poy_file.poy05 ,  #計價幣別
#                poy05_6 LIKE poy_file.poy05 ,  #計價幣別
#                azi04  LIKE azi_file.azi04 ,  #幣別小數
#                azi07  LIKE azi_file.azi07 ,  #匯率小數
#                azi05  LIKE azi_file.azi05 ,  #幣別小數
#                oga50_1  LIKE oga_file.oga50 ,
#                oga501_1 LIKE oga_file.oga501 ,
#                azi04_1  LIKE azi_file.azi04 ,
#                azi05_1  LIKE azi_file.azi05 ,
#                oga50_2  LIKE oga_file.oga50 ,
#                oga501_2 LIKE oga_file.oga501 ,
#                azi04_2  LIKE azi_file.azi04 ,
#                azi05_2  LIKE azi_file.azi05 ,
#                oga50_3  LIKE oga_file.oga50 ,
#                oga501_3 LIKE oga_file.oga501 ,
#                azi04_3  LIKE azi_file.azi04 ,
#                azi05_3  LIKE azi_file.azi05 ,
#                oga50_4  LIKE oga_file.oga50 ,
#                oga501_4 LIKE oga_file.oga501 ,
#                azi04_4  LIKE azi_file.azi04 ,
#                azi05_4  LIKE azi_file.azi05 ,
#                oga50_5  LIKE oga_file.oga50 ,
#                oga501_5 LIKE oga_file.oga501 ,
#                azi04_5  LIKE azi_file.azi04 ,
#                azi05_5  LIKE azi_file.azi05 ,
#                oga50_6  LIKE oga_file.oga50 ,
#                oga501_6 LIKE oga_file.oga501 ,
#                azi04_6  LIKE azi_file.azi04 ,
#                azi05_6  LIKE azi_file.azi05,
#                oga50_7  LIKE oga_file.oga50 ,
#                oga501_7 LIKE oga_file.oga501,
#                oga16    LIKE oga_file.oga16,
#                oga99    LIKE oga_file.oga99
#         END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.oea904,sr.oga02,sr.oga01            #流程代碼跳頁
# FORMAT
#  PAGE HEADER
#No.FUN-580013  -begin
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#     PRINT
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<'
#     PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[11])-6)/2)+1,month(sr.oga02),' ',g_x[11]
#     PRINT g_x[12] CLIPPED,tm.bdate,'-',tm.edate
#     PRINT g_dash[1,g_len]
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT ' '
#     LET l_month = month(sr.oga02)
#     PRINT (g_len-20)/2 SPACES, l_month CLIPPED, ' ',g_x[11]
#     LET g_pageno = g_pageno + 1
#     PRINT ''
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN (g_len-30)/2 ,g_x[12] CLIPPED , tm.bdate,'_',tm.edate,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash2[1,g_len]
 
#     PRINT COLUMN 01, g_x[13] CLIPPED ,
#     #No.FUN-550018 start
#           COLUMN 18, g_x[14] CLIPPED ,
#           COLUMN 37, g_x[15] CLIPPED ,
#           COLUMN 46, g_x[16] CLIPPED ,
#           COLUMN 52, g_x[17] CLIPPED ,
#           COLUMN 63, g_x[18] CLIPPED ,
#           COLUMN 63, g_x[19] CLIPPED ,
#           COLUMN 92, g_x[20] CLIPPED ,9 SPACES;
#           IF (sr.oga50_1 IS NOT NULL ) THEN
#               PRINT COLUMN 106,'AP-' , sr.poy03_1 CLIPPED , g_x[27] CLIPPED;
#               LET g_zaa[39].zaa08 = 'AP-' , sr.poy03_1 CLIPPED , g_x[27] CLIPPED
#           ELSE
#              PRINT '';
#              LET g_zaa[39].zaa06 = 'Y'
#           END IF
#           IF (sr.oga50_2 IS NOT NULL  ) THEN
#               PRINT COLUMN 123,'AP-' ,sr.poy03_2 CLIPPED, g_x[27] CLIPPED ;
#               LET g_zaa[40].zaa08 = 'AP-' , sr.poy03_2 CLIPPED , g_x[27] CLIPPED
#           ELSE
#              PRINT '';
#              LET g_zaa[40].zaa06 = 'Y'
#           END IF
#           IF (sr.oga50_3 IS NOT NULL  ) THEN
#               PRINT COLUMN 142,'AP-' ,sr.poy03_3 CLIPPED , g_x[27] CLIPPED ;
#               LET g_zaa[41].zaa08 = 'AP-' , sr.poy03_3 CLIPPED , g_x[27] CLIPPED
#           ELSE
#              PRINT '';
#              LET g_zaa[41].zaa06 = 'Y'
#           END IF
#           IF (sr.oga50_4 IS NOT NULL  ) THEN
#               PRINT COLUMN 161,'AP-' ,sr.poy03_4 CLIPPED , g_x[27] CLIPPED ;
#               LET g_zaa[42].zaa08 = 'AP-' , sr.poy03_4 CLIPPED , g_x[27] CLIPPED
#           ELSE
#              PRINT '';
#              LET g_zaa[42].zaa06 = 'Y'
#           END IF
#           IF (sr.oga50_5 IS NOT NULL  ) THEN
#               PRINT COLUMN 180,'AP-' ,sr.poy03_5 CLIPPED , g_x[27] CLIPPED ;
#               LET g_zaa[43].zaa08 = 'AP-' , sr.poy03_5 CLIPPED , g_x[27] CLIPPED
#           ELSE
#              PRINT '';
#              LET g_zaa[43].zaa06 = 'Y'
#           END IF
#           IF (sr.oga50_6 IS NOT NULL  ) THEN
#               PRINT COLUMN 185,'AP-' ,sr.poy03_6 CLIPPED , g_x[27] CLIPPED ;
#               LET g_zaa[44].zaa08 = 'AP-' , sr.poy03_6 CLIPPED , g_x[27] CLIPPED
#           ELSE
#              PRINT '';
#              LET g_zaa[44].zaa06 = 'Y'
#           END IF
#           PRINT 1 SPACES ,g_x[29] CLIPPED,g_plant CLIPPED, g_x[27] CLIPPED ,
#                 3 SPACES ,g_x[29] CLIPPED,g_plant CLIPPED, g_x[28] CLIPPED
#           LET g_zaa[45].zaa08 = g_x[29] CLIPPED,g_plant CLIPPED,g_x[27] CLIPPED
#           LET g_zaa[46].zaa08 = g_x[29] CLIPPED,g_plant CLIPPED,g_x[28] CLIPPED
 
#     PRINT '---------------- ---------------- ---------- ---- ----------- -------------------',
#           ' -------- ------------------- ';
#
#     #No.FUN-550018 end
 
#           IF (sr.oga50_1 IS NOT NULL ) THEN
#               PRINT '------------------- ';
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_2 IS NOT NULL ) THEN
#               PRINT '------------------- ';
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_3 IS NOT NULL ) THEN
#               PRINT '------------------- ';
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_4 IS NOT NULL ) THEN
#               PRINT '------------------- ';
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_5 IS NOT NULL ) THEN
#               PRINT '------------------- ';
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_6 IS NOT NULL ) THEN
#               PRINT '------------------- ';
#           ELSE
#              PRINT '';
#           END IF
#           PRINT '---------------- -------------- '
#     #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#     #      g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#     #      g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#     #NO.TQC-5B0031
#     PRINT g_dash[1,g_len]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],   #TQC-630214 modify
#                    g_x[36],g_x[37],g_x[38],g_x[45],g_x[46],g_x[39],g_x[40],
#                    g_x[41],g_x[42],g_x[43],g_x[44]
#     #NO.TQC-5B0031
#     PRINT g_dash1
#No.FUN-580013 --end
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.oea904
 
#     SKIP TO TOP OF PAGE
 
#  ON EVERY ROW
 
#     PRINTX name=D1 COLUMN g_c[31],sr.oma10 CLIPPED,   #TQC-630214 modify
#                    COLUMN g_c[32],sr.oga01 CLIPPED,
#                    COLUMN g_c[33],sr.oga03 CLIPPED,
#                    COLUMN g_c[34],sr.oga23 CLIPPED,
#                    COLUMN g_c[35],cl_numfor(sr.oga24,35,sr.azi07),
#                    COLUMN g_c[36],cl_numfor(sr.oga50,36,sr.azi04) CLIPPED,
#                    COLUMN g_c[37],sr.oga02 CLIPPED,
#                    COLUMN g_c[38],cl_numfor(sr.oga501 CLIPPED,38,g_azi04),
#                    #NO.TQC-5B0031
#                    COLUMN g_c[45],cl_numfor(sr.oga50_7,45,sr.azi04),   #No.FUN-550018
#                    COLUMN g_c[46],cl_numfor(sr.oga501_7,46,g_azi04),    #No.FUN-550018
#                    #NO.TQC-5B0031
#                    COLUMN g_c[39],cl_numfor(sr.oga50_1,39,sr.azi04_1),
#                    COLUMN g_c[40],cl_numfor(sr.oga50_2,40,sr.azi04_2),
#                    COLUMN g_c[41],cl_numfor(sr.oga50_3,41,sr.azi04_3),
#                    COLUMN g_c[42],cl_numfor(sr.oga50_4,42,sr.azi04_4),
#                    COLUMN g_c[43],cl_numfor(sr.oga50_5,43,sr.azi04_5),
#                    COLUMN g_c[44],cl_numfor(sr.oga50_6,44,sr.azi04_6)
#                    #COLUMN g_c[45],cl_numfor(sr.oga50_7,45,sr.azi04),   #No.FUN-550018
#                    #COLUMN g_c[46],cl_numfor(sr.oga501_7,46,g_azi04)    #No.FUN-550018
#     PRINT sr.oma10 CLIPPED ,
#           COLUMN 18 , sr.oga01 CLIPPED ,
#           COLUMN 35 , sr.oga03 CLIPPED ,
#           COLUMN 47 , sr.oga23 CLIPPED ,
#           COLUMN 51 , cl_numfor(sr.oga24,10,sr.azi07),
#           COLUMN 63 , cl_numfor(sr.oga50,18,sr.azi04) CLIPPED ,
#           COLUMN 83 , sr.oga02 CLIPPED ,
#           COLUMN 92 , cl_numfor(sr.oga501 CLIPPED,18,g_azi04) ;
#           IF (sr.oga50_1 IS NOT NULL ) THEN
#               PRINT ' ', cl_numfor(sr.oga50_1,18,sr.azi04_1);
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_2 IS NOT NULL ) THEN
 
#               PRINT ' ', cl_numfor(sr.oga50_2,18,sr.azi04_2);
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_3 IS NOT NULL ) THEN
#               PRINT ' ', cl_numfor(sr.oga50_3,18,sr.azi04_3);
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_4 IS NOT NULL ) THEN
#               PRINT ' ', cl_numfor(sr.oga50_4,18,sr.azi04_4);
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_5 IS NOT NULL ) THEN
#               PRINT ' ', cl_numfor(sr.oga50_5,18,sr.azi04_5);
#           ELSE
#              PRINT '';
#           END IF
#           IF (sr.oga50_6 IS NOT NULL ) THEN
#               PRINT ' ', cl_numfor(sr.oga50_6,18,sr.azi04_6);
#           ELSE
#              PRINT '';
#           END IF
#           PRINT ' ', cl_numfor(sr.oga50_7,14,sr.azi04),   #No.FUN-550018
#                 ' ', cl_numfor(sr.oga501_7,14,g_azi04)    #No.FUN-550018
#No.FUN-580013  --end
 
#  AFTER GROUP OF sr.oea904
 
#     LET l_sum01 = GROUP SUM(sr.oga50_1)
#     LET l_sum02 = GROUP SUM(sr.oga501_1)
#     LET l_sum03 = GROUP SUM(sr.oga50_2)
#     LET l_sum04 = GROUP SUM(sr.oga501_2)
#     LET l_sum05 = GROUP SUM(sr.oga50_3)
#     LET l_sum06 = GROUP SUM(sr.oga501_3)
#     LET l_sum07 = GROUP SUM(sr.oga50_4)
#     LET l_sum08 = GROUP SUM(sr.oga501_4)
#     LET l_sum09 = GROUP SUM(sr.oga50_5)
#     LET l_sum10 = GROUP SUM(sr.oga501_5)
#     LET l_sum11 = GROUP SUM(sr.oga50_6)
#     LET l_sum12 = GROUP SUM(sr.oga501_6)
#     LET l_sum13 = GROUP SUM(sr.oga50)
#     LET l_sum14 = GROUP SUM(sr.oga501)
#     LET l_sum15 = GROUP SUM(sr.oga50_7)
#     LET l_sum16 = GROUP SUM(sr.oga501_7)
 
#  #------------------------------ 印合計
#No.FUN-580013  --begin
#     PRINT g_dash1[1,g_len]
#     PRINT g_dash2[1,g_len]
 
#     PRINT COLUMN 63, cl_numfor(l_sum13,18,sr.azi05),
#           COLUMN 92, cl_numfor(l_sum14,18,g_azi05) ;
#     PRINTX name=D1 COLUMN g_c[36],cl_numfor(l_sum13,36,sr.azi05),   #TQC-630214 modify
#                    COLUMN g_c[38],cl_numfor(l_sum14,38,g_azi05),
#                    #NO.TQC-5B0031
#                    COLUMN g_c[45],cl_numfor(l_sum15,45,sr.azi05),    #No.FUN-550018
#                    COLUMN g_c[46],cl_numfor(l_sum16,46,g_azi05),      #No.FUN-550018
#                    #NO.TQC-5B0031
#                    COLUMN g_c[39],cl_numfor(l_sum01,39,sr.azi05_1),
#                    COLUMN g_c[40],cl_numfor(l_sum03,40,sr.azi05_2),
#                    COLUMN g_c[41],cl_numfor(l_sum05,41,sr.azi05_3),
#                    COLUMN g_c[42],cl_numfor(l_sum07,42,sr.azi05_4),
#                    COLUMN g_c[43],cl_numfor(l_sum09,43,sr.azi05_5),
#                    COLUMN g_c[44],cl_numfor(l_sum11,44,sr.azi05_6)
#                    #COLUMN g_c[45],cl_numfor(l_sum15,45,sr.azi05),    #No.FUN-550018
#           #COLUMN g_c[46],cl_numfor(l_sum16,46,g_azi05)      #No.FUN-550018
#           IF (sr.oga50_1 IS NOT NULL ) THEN
#               PRINT ' ', cl_numfor(l_sum01,18,sr.azi05_1);
#           ELSE
#              PRINT '' ;
#           END IF
#           IF (sr.oga50_2 IS NOT NULL  ) THEN
#               PRINT ' ', cl_numfor(l_sum03,18,sr.azi05_2);
#           ELSE
#              PRINT '' ;
#           END IF
 
#           IF (sr.oga50_3 IS NOT NULL  ) THEN
#               PRINT ' ', cl_numfor(l_sum05,18,sr.azi05_3);
#           ELSE
#              PRINT '' ;
#           END IF
 
#           IF (sr.oga50_4 IS NOT NULL  ) THEN
#               PRINT ' ', cl_numfor(l_sum07,18,sr.azi05_4);
#           ELSE
#              PRINT '' ;
#           END IF
 
#           IF (sr.oga50_5 IS NOT NULL  ) THEN
#               PRINT ' ', cl_numfor(l_sum09,18,sr.azi05_5);
#           ELSE
#              PRINT '' ;
#           END IF
 
#           IF (sr.oga50_6 IS NOT NULL  ) THEN
#               PRINT ' ', cl_numfor(l_sum11,18,sr.azi05_6);
#           ELSE
#              PRINT '';
#           END IF
#           PRINT 1 SPACES, cl_numfor(l_sum15,14,sr.azi05),    #No.FUN-550018
#                 1 SPACES, cl_numfor(l_sum16,14,g_azi05)      #No.FUN-550018
 
#      PRINT g_dash2[1,g_len]
#      PRINT g_dash[1,g_len]
#No.FUN-580013  --end
#      PRINT g_x[22] CLIPPED ,
#            sr.oea904 CLIPPED
#      PRINT COLUMN 5, g_x[23] CLIPPED ,
#            COLUMN 16, g_x[24] CLIPPED ,
#            COLUMN 22, g_x[25] CLIPPED ,
#            COLUMN 31, g_x[26] CLIPPED
 
#     IF (sr.oga50_1 IS NOT NULL ) THEN
#        PRINT COLUMN 6, sr.poy03_1 CLIPPED ,
#              COLUMN 17, sr.poy05_1 CLIPPED ,
#              COLUMN 25 , l_pox.pox05_1 CLIPPED ,
#              COLUMN 31 , l_pox.pox06_1 USING '##&.##' CLIPPED,
#              COLUMN 39 , '%'
#     ELSE
#        PRINT ''
#     END IF
#     IF (sr.oga50_2 IS NOT NULL ) THEN
#        PRINT COLUMN 6, sr.poy03_2 CLIPPED ,
#              COLUMN 17, sr.poy05_2 CLIPPED ,
#              COLUMN 25, l_pox.pox05_2 CLIPPED ,
#              COLUMN 31, l_pox.pox06_2 USING '##&.##',
#              COLUMN 39 , '%'
#     ELSE
#        PRINT ''
#     END IF
#     IF (sr.oga50_3 IS NOT NULL ) THEN
#        PRINT COLUMN 6, sr.poy03_3 CLIPPED ,
#              COLUMN 17, sr.poy05_3 CLIPPED ,
#              COLUMN 25, l_pox.pox05_3 CLIPPED ,
#              COLUMN 31, l_pox.pox06_3 USING '##&.#' ,
#              COLUMN 39 , '%'
#     ELSE
#        PRINT ''
#     END IF
#     IF (sr.oga50_4 IS NOT NULL ) THEN
#        PRINT COLUMN 6, sr.poy03_4 CLIPPED ,
#              COLUMN 17, sr.poy05_4 CLIPPED ,
#              COLUMN 25, l_pox.pox05_4 CLIPPED ,
#              COLUMN 31, l_pox.pox06_4 USING '##&.##' ,
#              COLUMN 39 , '%'
#     ELSE
#        PRINT ''
#     END IF
#     IF (sr.oga50_5 IS NOT NULL ) THEN
#        PRINT COLUMN 6, sr.poy03_5 CLIPPED ,
#              COLUMN 17, sr.poy05_5 CLIPPED ,
#              COLUMN 25, l_pox.pox05_5 CLIPPED ,
#              COLUMN 31, l_pox.pox06_5 USING '##&.##' ,
#              COLUMN 39 , '%'
#     ELSE
#        PRINT ''
#     END IF
#     IF (sr.oga50_6 IS NOT NULL ) THEN
#        PRINT COLUMN 6, sr.poy03_6 CLIPPED ,
#              COLUMN 17, sr.poy05_6 CLIPPED ,
#              COLUMN 25, l_pox.pox05_6 CLIPPED ,
#              COLUMN 31, l_pox.pox06_6 USING '##&.##' ,
#              COLUMN 39 , '%'
#     ELSE
#        PRINT ''
#     END IF
 
 
#END REPORT
#No.FUN-850018 --End
#取得單號
#FUNCTION r810_getno(p_dbs,p_oga99)   #FUN-A10056
FUNCTION r810_getno(p_azp01,p_oga99)   #FUN-A10056
     DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(500)
     DEFINE l_oga01 LIKE oga_file.oga01
     DEFINE p_dbs   LIKE type_file.chr20    # No.FUN-680137 VARCHAR(21)
     DEFINE p_azp01 LIKE azp_file.azp01     # No.FUN-A10056
     DEFINE p_oga99 LIKE oga_file.oga99
     DEFINE i     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    #LET l_sql = " SELECT oga01 FROM ",p_dbs CLIPPED,"oga_file ",   #FUN-A10056
     LET l_sql = " SELECT oga01 FROM ",cl_get_target_table(p_azp01,'oga_file'),  #FUN-A10056
                 "  WHERE oga99 ='",p_oga99,"'"
                 #"    AND oga09 = '4' " #MOD-C20167 mark
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql    #FUN-A10056
     PREPARE oga01_pre FROM l_sql
     DECLARE oga01_cs CURSOR FOR oga01_pre
     OPEN oga01_cs
     FETCH oga01_cs INTO l_oga01                              #出貨單
     IF SQLCA.SQLCODE THEN
        LET g_msg = p_dbs CLIPPED,'fetch lga01_cs'
        CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        LET g_success = 'N'
     END IF
     RETURN l_oga01
 END FUNCTION
#Patch....NO.TQC-610037 <> #
#No.FUN-870144
