# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr442.4gl
# Descriptions...:工單成本分析表
# Input parameter:
# Return code....:
# Date & Author..: 00/11/20 By Chihming
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-580014 05/08/16 by day   報表轉xml
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0110 05/11/11 By CoCo 料號位置調整
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670058 06/07/18 By Sarah 增加抓拆件式工單資料(cct_file,ccu_file)
# Modify.........: No.FUN-680007 06/08/03 By Sarah 將之前FUN-670058多抓cct_file,ccu_file的部份remove
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-720042 07/02/13 By TSD.Sora 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.FUN-7C0101 08/01/23 By shiwuying成本改善，CR增加類別編號ccg07和各種制費
# Modify.........: No.MOD-930190 09/05/25 By Pengu sr record訂義的數量與sql select欄位的數量不合
# Modify.........: No.MOD-940374 09/06/17 By mike ccg32f,ccg32g,ccg32h select時有兩次,但sr只有一次,sr的先后順序,個數,定義應該>
# Modify.........: No.TQC-980012 09/08/04 By Carrier DL/HR及OH/HR的值修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)      # Where condition
           yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT
           type    LIKE ccg_file.ccg06,          #No.FUN-7C0101 add
           more    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)         # Input more condition(Y/N)
           END RECORD,
       g_tot_bal   LIKE ccq_file.ccq03        #No.FUN-680122DECIMAL(13,2)   # User defined variable
DEFINE bdate       LIKE type_file.dat           #No.FUN-680122DATE
DEFINE edate       LIKE type_file.dat           #No.FUN-680122DATE
DEFINE g_chr       LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_i         LIKE type_file.num5          #count/index for any purpose        #No.FUN-680122 SMALLINT
#070602 BY TSD.Sora---start---
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#070602 BY TSD.Sora---end---
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
  
   #MOD-720042 BY TSD.Sora---start---
   LET g_sql = "ccg01.ccg_file.ccg01,",
               "ccg02.ccg_file.ccg02,",
               "ccg03.ccg_file.ccg03,",
               "ccg04.ccg_file.ccg04,",
               "ccg07.ccg_file.ccg07,",       #No.FUN-7C0101 add 
               "ccg20.ccg_file.ccg20,",
               "ccg31.ccg_file.ccg31,",
               "ccg32.ccg_file.ccg32,",
               "ccg32a.ccg_file.ccg32a,",
               "ccg32b.ccg_file.ccg32b,",
               "ccg32c.ccg_file.ccg32c,",
               "ccg32d.ccg_file.ccg32d,",
               "ccg32e.ccg_file.ccg32e,",
               "cch01.cch_file.cch01,",
               "cch02.cch_file.cch02,",
               "cch04.cch_file.cch04,",
               "cch31.cch_file.cch31,",
               "cch32.cch_file.cch32,",
               "cch32a.cch_file.cch32a,",
               "cch32b.cch_file.cch32b,",
               "cch32c.cch_file.cch32c,",
               "cch32d.cch_file.cch32d,",
               "cch32e.cch_file.cch32e,",
               "sfb01.sfb_file.sfb01,",
               "sfb08.sfb_file.sfb08,",
               "sfb13.sfb_file.sfb13,",
               "sfb15.sfb_file.sfb15,",
               "sfb98.sfb_file.sfb98,",
               "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima86.ima_file.ima86,",
               "l_cck06.cck_file.cck06,",
               "l_cck07.cck_file.cck07,",
               "l_ima02.ima_file.ima02,",
           #    "l_ima86.ima_file.ima86"      #No.FUN-7C0101
               "l_ima86.ima_file.ima86,",     #No.FUN-7C0101
               "ccg32f.ccg_file.ccg32f,",     #No.FUN-7C0101 add    
               "ccg32g.ccg_file.ccg32g,",     #No.FUN-7C0101 add    
               "ccg32h.ccg_file.ccg32h,",     #No.FUN-7C0101 add 
               "cch32f.cch_file.cch32f,",     #No.FUN-7C0101 add    
               "cch32g.cch_file.cch32g,",     #No.FUN-7C0101 add    
               "cch32h.cch_file.cch32h "      #No.FUN-7C0101 add 
               
   LET l_table = cl_prt_temptable('axcr442',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,",     #No.FUN-7C0101 add 
               "        ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #MOD-720042 BY TSD.Sora---end---
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.type=ARG_VAL(13)  #No.FUN-7C0101 add 
  #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr442_tm(0,0)        # Input print condition
      ELSE CALL axcr442()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr442_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr442_w AT p_row,p_col
        WITH FORM "axc/42f/axcr442"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 add
   LET tm.yy = YEAR(g_today)          #No.FUN-7C0101 add
   LET tm.mm = MONTH(g_today)         #No.FUN-7C0101 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON ima01,ima57,ima39,ima09,ima11,
                              ccg01,ima08,ima06,ima10,ima12
##
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
 
#No.FUN-570240 --start
      ON ACTION controlp
         IF INFIELD(ima01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
         END IF
#No.FUN-570240 --end
 
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr442_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.more WITHOUT DEFAULTS  #No.FUN-7C0101 add type
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
                
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
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr442_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr442'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr442','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",                #TQC-610051 
                         " '",tm.mm CLIPPED,"'",                #TQC-610051
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr442',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr442_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr442()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr442_w
END FUNCTION
 
FUNCTION axcr442()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     STRING,   #CHAR(600),        # RDSQL STATEMENT   #FUN-670058 modify
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_last_sw LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
          sr        RECORD
                     ccg01   LIKE ccg_file.ccg01,
                     ccg02   LIKE ccg_file.ccg02,
                     ccg03   LIKE ccg_file.ccg03,
                     ccg04   LIKE ccg_file.ccg04,
                     ccg07   LIKE ccg_file.ccg07,    #No.FUN-7C0101 add 
                     ccg20   LIKE ccg_file.ccg20,
                     ccg31   LIKE ccg_file.ccg31,
                     ccg32   LIKE ccg_file.ccg32,
                     ccg32a  LIKE ccg_file.ccg32a,
                     ccg32b  LIKE ccg_file.ccg32b,
                     ccg32c  LIKE ccg_file.ccg32c,
                     ccg32d  LIKE ccg_file.ccg32d,
                     ccg32e  LIKE ccg_file.ccg32e,
                     cch01   LIKE cch_file.cch01,
                     cch02   LIKE cch_file.cch02,
                     cch04   LIKE cch_file.cch04,
                     cch31   LIKE cch_file.cch31,
                     cch32   LIKE cch_file.cch32,
                     cch32a  LIKE cch_file.cch32a,
                     cch32b  LIKE cch_file.cch32b,
                     cch32c  LIKE cch_file.cch32c,
                     cch32d  LIKE cch_file.cch32d,
                     cch32e  LIKE cch_file.cch32e,
                     sfb01   LIKE sfb_file.sfb01,
                     sfb08   LIKE sfb_file.sfb08,
                     sfb13   LIKE sfb_file.sfb13,
                     sfb15   LIKE sfb_file.sfb15,
                     sfb98   LIKE sfb_file.sfb98,
                     ima01   LIKE ima_file.ima01,
                     ima02   LIKE ima_file.ima02,
                     ima021  LIKE ima_file.ima021,
                     ima86   LIKE ima_file.ima86,
                     l_cck06 LIKE cck_file.cck06,
                     l_cck07 LIKE cck_file.cck07,
                     l_ima02 LIKE ima_file.ima02,
                     l_ima86 LIKE ima_file.ima86
                    ,ccg32f  LIKE ccg_file.ccg32f,  #No.FUN-7C0101 add
	       	     ccg32g  LIKE ccg_file.ccg32g,  #No.FUN-7C0101 add
                     ccg32h  LIKE ccg_file.ccg32h,  #No.FUN-7C0101 add
                     cch32f  LIKE cch_file.cch32f,  #No.FUN-7C0101 add
	       	     cch32g  LIKE cch_file.cch32g,  #No.FUN-7C0101 add
                     cch32h  LIKE cch_file.cch32h   #No.FUN-7C0101 add
                   END RECORD
    
   #MOD-72004 BY TSD.Sora---start---
   CALL cl_del_data(l_table)
   #MOD-720042 BY TSD.Sora---end---
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-72004 add
 
   LET l_sql = "SELECT ccg01,ccg02,ccg03,ccg04,ccg07,ccg20,",  #No.FUN-7C0101 add ccg07
              #"       ccg31,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,", #No.FUN-7C0101 #MOD-940374 mark
               "       ccg31,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,",   #MOD-940374 add
               "       cch01,cch02,cch04,",
               "       cch31,cch32,cch32a,cch32b,cch32c,cch32d,cch32e,",
               "       sfb01,sfb08,sfb13,sfb15,sfb98,ima01,ima02,",
               "       ima021,ima86",
               "       ,'','','','' ",   #MOD-940374 add
               "       ,ccg32f,ccg32g,ccg32h,cch32f,cch32g,cch32h",   #No.MOD-930190  add
               "  FROM ccg_file,cch_file,sfb_file,ima_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND ccg02=",tm.yy," AND ccg03=",tm.mm,
               "   AND ccg06='",tm.type,"'",    #No.FUN-7C0101 add
               "   AND ccg04=ima01 ",
               "   AND ccg01=cch01 ",
               "   AND ccg02=cch02 ",
               "   AND ccg03=cch03 ",
               "   AND ccg06=cch06 ",           #No.FUN-7C0101 add 
#              "   AND ccg07=cch07 ",           #No.FUN-7C0101 add #TQC-970003
               "   AND ccg01=sfb01 ",
               "   AND cch01=sfb01 "
 
   PREPARE axcr442_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr442_curs1 CURSOR FOR axcr442_prepare1
 
   LET g_pageno = 0
   FOREACH axcr442_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #MOD-720042 BY TSD.Sora---start---
      IF cl_null(sr.sfb98) THEN LET sr.sfb98 = ' ' END IF
      IF g_ccz.ccz06 = '1' THEN LET sr.sfb98 = ' ' END IF
      SELECT cck06,cck07 INTO sr.l_cck06,sr.l_cck07 FROM cck_file
        WHERE cck01 = tm.yy
          AND cck02 = tm.mm
          AND cck_w = sr.sfb98
      IF cl_null(sr.l_cck06) THEN LET sr.l_cck06 = 0 END IF
      IF cl_null(sr.l_cck07) THEN LET sr.l_cck07 = 0 END IF
  
      #No.TQC-980012  --Begin
      IF sr.l_cck06 = 0 THEN
         LET sr.l_cck06 = sr.ccg32b / sr.ccg20
      END IF
      IF sr.l_cck06 < 0 THEN LET sr.l_cck06 = sr.l_cck06 * -1 END IF
 
      IF sr.l_cck07 = 0 THEN
         LET sr.l_cck07 = sr.ccg32c / sr.ccg20
      END IF
      IF sr.l_cck07 < 0 THEN LET sr.l_cck07 = sr.l_cck07 * -1 END IF
      #No.TQC-980012  --End  
 
      SELECT ima02,ima86 INTO sr.l_ima02,sr.l_ima86 FROM ima_file
       WHERE ima01 = sr.cch04
      IF SQLCA.sqlcode THEN  LET sr.l_ima02 = ' ' LET sr.l_ima86 = ' ' END IF
     
      EXECUTE insert_prep USING
              sr.ccg01,sr.ccg02,sr.ccg03,sr.ccg04,sr.ccg07,sr.ccg20,sr.ccg31,sr.ccg32, #No.FUN-7C0101 add ccg07
              sr.ccg32a,sr.ccg32b,sr.ccg32c,sr.ccg32d,sr.ccg32e,sr.cch01,
              sr.cch02,sr.cch04,sr.cch31,sr.cch32,sr.cch32a,sr.cch32b,
              sr.cch32c,sr.cch32d,sr.cch32e,sr.sfb01,sr.sfb08,sr.sfb13,
              sr.sfb15,sr.sfb98,sr.ima01,sr.ima02,sr.ima021,sr.ima86,sr.l_cck06,
              sr.l_cck07,sr.l_ima02,sr.l_ima86    
              ,sr.ccg32f,sr.ccg32g,sr.ccg32h,   #No.FUN-7C0101 add
              sr.cch32f,sr.cch32g,sr.cch32h     #No.FUN-7C0101 add
      #MOD-720042 BY TSD.Sora---end---
   END FOREACH
 
   #MOD-720042 BY TSD.Sora---start---
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima01,ima57,ima39,ima09,ima11,ccg01,ima08,ima06,
                    ima10,ima12')
        RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = " "
   END IF
   #LET g_str = g_str,";",bdate,";",edate,";",g_azi03,";",tm.type  #FUN-710080 modify  #No.FUN-7C0101 add tm.type #CHI-C30012
   LET g_str = g_str,";",bdate,";",edate,";",g_ccz.ccz26,";",tm.type  #CHI-C30012
   CALL cl_prt_cs3('axcr442','axcr442',l_sql,g_str)   #FUN-710080 modify
   #MOD-720042 BY TSD.Sora---end---
 
END FUNCTION
 
{
REPORT axcr442_rep(sr)
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_last_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
          l_ima02   LIKE ima_file.ima02,
          l_ima86   LIKE ima_file.ima86,
          l_cck06   LIKE cck_file.cck06,
          l_cck07   LIKE cck_file.cck07,
          sr        RECORD
                     ccg01   LIKE ccg_file.ccg01,
                     ccg02   LIKE ccg_file.ccg02,
                     ccg03   LIKE ccg_file.ccg03,
                     ccg04   LIKE ccg_file.ccg04,
                     ccg20   LIKE ccg_file.ccg20,
                     ccg31   LIKE ccg_file.ccg31,
                     ccg32   LIKE ccg_file.ccg32,
                     ccg32a  LIKE ccg_file.ccg32a,
                     ccg32b  LIKE ccg_file.ccg32b,
                     ccg32c  LIKE ccg_file.ccg32c,
                     ccg32d  LIKE ccg_file.ccg32d,
                     ccg32e  LIKE ccg_file.ccg32e,
                     cch01   LIKE cch_file.cch01,
                     cch02   LIKE cch_file.cch02,
                     cch04   LIKE cch_file.cch04,
                     cch31   LIKE cch_file.cch31,
                     cch32   LIKE cch_file.cch32,
                     cch32a  LIKE cch_file.cch32a,
                     cch32b  LIKE cch_file.cch32b,
                     cch32c  LIKE cch_file.cch32c,
                     cch32d  LIKE cch_file.cch32d,
                     cch32e  LIKE cch_file.cch32e,
                     sfb01   LIKE sfb_file.sfb01,
                     sfb08   LIKE sfb_file.sfb08,
                     sfb13   LIKE sfb_file.sfb13,
                     sfb15   LIKE sfb_file.sfb15,
                     sfb98   LIKE sfb_file.sfb98,
                     ima01   LIKE ima_file.ima01,
                     ima02   LIKE ima_file.ima02,
                     ima021  LIKE ima_file.ima021,
                     ima86   LIKE ima_file.ima86,
                     l_cck06 LIKE cck_file.cck06,
                     l_cck07 LIKE cck_file.cck07,
                     l_ima02 LIKE ima_file.ima02,
                     l_ima86 LIKE ima_file.ima86
                    END RECORD
 
  OUTPUT TOP MARGIN 0
        LEFT MARGIN g_left_margin
        BOTTOM MARGIN 7
        PAGE LENGTH g_page_line
 
  ORDER BY sr.ccg01,sr.cch04
 
#No.FUN-580014-begin
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT bdate ,g_x[11] CLIPPED,edate
      PRINT g_dash[1,g_len]
 
      #-->取每小時工資率
      IF cl_null(sr.sfb98) THEN LET sr.sfb98 = ' ' END IF
      IF g_ccz.ccz06 = '1' THEN LET sr.sfb98 = ' ' END IF
      SELECT cck06,cck07 INTO l_cck06,l_cck07 FROM cck_file
         WHERE cck01 = tm.yy
           AND cck02 = tm.mm
           AND cck_w = sr.sfb98
       IF cl_null(l_cck06) THEN LET l_cck06 = 0 END IF
       IF cl_null(l_cck07) THEN LET l_cck07 = 0 END IF
 
##TQC-5B0110&051112 START##
      PRINT COLUMN 3 , g_x[13] CLIPPED, sr.ccg01  CLIPPED,
            COLUMN 70, g_x[14] CLIPPED,cl_numfor(sr.sfb08,15,0) CLIPPED,
            COLUMN 97, g_x[15] CLIPPED,cl_numfor((sr.ccg32a*-1),18,g_azi03) CLIPPED,    #FUN-570190
            COLUMN 120, '@' CLIPPED, cl_numfor((sr.ccg32a/sr.ccg31),18,g_azi03) CLIPPED    #FUN-570190
           # COLUMN 45, g_x[14] CLIPPED,cl_numfor(sr.sfb08,15,0) CLIPPED,
           # COLUMN 72, g_x[15] CLIPPED,cl_numfor((sr.ccg32a*-1),18,g_azi03) CLIPPED,    #FUN-570190
           # COLUMN 95, '@' CLIPPED, cl_numfor((sr.ccg32a/sr.ccg31),18,g_azi03) CLIPPED    #FUN-570190
 
      PRINT COLUMN 3 , g_x[16] CLIPPED, sr.ccg04  CLIPPED,
            COLUMN 70, g_x[17] CLIPPED, sr.sfb13  CLIPPED,
            COLUMN 97, g_x[18] CLIPPED, cl_numfor((sr.ccg32b*-1),18,g_azi03) CLIPPED,    #FUN-570190
            COLUMN 120, '@' CLIPPED,cl_numfor((sr.ccg32b/sr.ccg31),18,3)
           # COLUMN 45, g_x[17] CLIPPED, sr.sfb13  CLIPPED,
           # COLUMN 72, g_x[18] CLIPPED, cl_numfor((sr.ccg32b*-1),18,g_azi03) CLIPPED,    #FUN-570190
           # COLUMN 95, '@' CLIPPED,cl_numfor((sr.ccg32b/sr.ccg31),18,3)
      PRINT COLUMN 3 , g_x[19] CLIPPED, sr.ima02  CLIPPED,
            COLUMN 70, g_x[39] CLIPPED, sr.sfb15  CLIPPED,
            COLUMN 97, g_x[20] CLIPPED, cl_numfor((sr.ccg32c*-1),18,g_azi03) CLIPPED,    #FUN-570190
            COLUMN 120, '@' CLIPPED,cl_numfor((sr.ccg32c/sr.ccg31),18,3) CLIPPED
           # COLUMN 45, g_x[39] CLIPPED, sr.sfb15  CLIPPED,
           # COLUMN 72, g_x[20] CLIPPED, cl_numfor((sr.ccg32c*-1),18,g_azi03) CLIPPED,    #FUN-570190
           # COLUMN 95, '@' CLIPPED,cl_numfor((sr.ccg32c/sr.ccg31),18,3) CLIPPED
      PRINT COLUMN 3 , g_x[21] CLIPPED, sr.ima021  CLIPPED,
            COLUMN 70, g_x[22] CLIPPED,cl_numfor((sr.ccg31*-1),15,0) CLIPPED,
            COLUMN 97, g_x[23] CLIPPED, cl_numfor((sr.ccg32d*-1),18,g_azi03) CLIPPED,    #FUN-570190
            COLUMN 120, '@' CLIPPED,cl_numfor((sr.ccg32d/sr.ccg31),18,3) CLIPPED
           # COLUMN 45, g_x[22] CLIPPED,cl_numfor((sr.ccg31*-1),15,0) CLIPPED,
           # COLUMN 72, g_x[23] CLIPPED, cl_numfor((sr.ccg32d*-1),18,g_azi03) CLIPPED,    #FUN-570190
           # COLUMN 95, '@' CLIPPED,cl_numfor((sr.ccg32d/sr.ccg31),18,3) CLIPPED
 
      PRINT COLUMN 97, g_x[24] CLIPPED, cl_numfor((sr.ccg32e*-1),18,g_azi03) CLIPPED,    #FUN-570190
            COLUMN 120, '@' CLIPPED,cl_numfor((sr.ccg32e/sr.ccg31),18,3) CLIPPED
      #PRINT COLUMN 72, g_x[24] CLIPPED, cl_numfor((sr.ccg32e*-1),18,g_azi03) CLIPPED,    #FUN-570190
      #      COLUMN 95, '@' CLIPPED,cl_numfor((sr.ccg32e/sr.ccg31),18,3) CLIPPED
      PRINT COLUMN 3 , g_x[25] CLIPPED,cl_numfor(sr.ccg20,13,0) CLIPPED,
            COLUMN 26, g_x[26] CLIPPED,cl_numfor(l_cck06,13,0) CLIPPED,
            COLUMN 45, g_x[27] CLIPPED,cl_numfor(l_cck07,13,0) CLIPPED,
            COLUMN 97, g_x[40] CLIPPED,cl_numfor((sr.ccg32*-1),18,g_azi03) CLIPPED,    #FUN-570190
            COLUMN 120, '@' CLIPPED, cl_numfor((sr.ccg32/sr.ccg31),18,g_azi03) CLIPPED    #FUN-570190
           # COLUMN 72, g_x[40] CLIPPED,cl_numfor((sr.ccg32*-1),18,g_azi03) CLIPPED,    #FUN-570190
           # COLUMN 95, '@' CLIPPED, cl_numfor((sr.ccg32/sr.ccg31),18,g_azi03) CLIPPED    #FUN-570190
##TQC-5B0110&051112 END##
      PRINT g_dash2[1,g_len]
      PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
                     g_x[47],g_x[48],g_x[49],g_x[50]
      PRINTX name=H2 g_x[51]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ccg01
   SKIP TO TOP OF PAGE
 
   ON EVERY ROW
     SELECT ima02,ima86 INTO l_ima02,l_ima86 FROM ima_file
       WHERE ima01 = sr.cch04
     IF SQLCA.sqlcode THEN  LET l_ima02 = ' ' LET l_ima86 = ' ' END IF
      PRINTX name=D1
            #COLUMN g_c[41],sr.cch04[1,20],
            COLUMN g_c[41],sr.cch04 clipped, #NO.FUN-5B0015
            COLUMN g_c[42],l_ima86    CLIPPED,
            COLUMN g_c[43],cl_numfor((sr.cch31*-1) ,43,0) CLIPPED,
            COLUMN g_c[44],cl_numfor((sr.cch32a*-1),44,g_azi03) CLIPPED,
            COLUMN g_c[45],cl_numfor((sr.cch32b*-1),45,g_azi03) CLIPPED,
            COLUMN g_c[46],cl_numfor((sr.cch32c*-1),46,g_azi03) CLIPPED,
            COLUMN g_c[47],cl_numfor((sr.cch32d*-1),47,g_azi03) CLIPPED,
            COLUMN g_c[48],cl_numfor((sr.cch32e*-1),48,g_azi03) CLIPPED,
            COLUMN g_c[49],cl_numfor((sr.cch32*-1),49,g_azi03)  CLIPPED,
            COLUMN g_c[50],cl_numfor((sr.cch32/sr.cch31),50,g_azi03)  CLIPPED
      PRINTX name=D2
            COLUMN g_c[51],l_ima02 CLIPPED
#No.FUN-580014-end
 
   ON LAST ROW
      PRINT
      PRINT g_dash[1,g_len] CLIPPED
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610037 <> #
}
