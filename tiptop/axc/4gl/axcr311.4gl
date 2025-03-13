# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr311.4gl
# Descriptions...: 庫存存貨市價核算表
# Input parameter: 
# Return code....: 
# Date & Author..: 00/03/16 By Danny
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/30 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-720042 07/02/14 By TSD.Jin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Mofify.........: No.FUN-7C0101 08/01/25 By lala 成本改善
# Modify.........: No.FUN-7B0120 08/07/30 By Sarah
#                  1.QBE增加"產品分類"ima131選項,Input增加選項:資料內容tm.a(1.列印LCM 2.列印呆滯料 3.全部)
#                  2.報表增加"市價"、"跌溢價金額"欄位,明細清單增加列印"期末成本"總計
#                  3.資料內容選擇2or3時,增加列印呆滯料清單,含:料號、品名、規格、期末數量、期末成本、單位成本(其他欄位為0),最後顯示小計
# Modify.........: No.FUN-8C0141 09/01/09 By kim 列印呆滯料的參數傳錯`
# Modify.........: No.CHI-920006 09/03/03 By jan 修正若 重置成本/凈變現價值/凈變現減利潤 有2者或3者相同時,無法取得市價的問題
# Modify.........: No.MOD-930026 09/03/03 By Pengu 抓取費用率/毛利率的SQL錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:MOD-A40067 10/04/13 By Sarah 報表裡的ima91轉換成以庫存單位為基準
# Modify.........: No.TQC-A40139 10/05/05 By Carrier FUN-9A0067 追单
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            #Print condition RECORD
            wc     LIKE type_file.chr1000,   #No.FUN-680122 VARCHAR(300)     # Where condition
            yy     LIKE type_file.num5,      #No.FUN-680122SMALLINT
            mm     LIKE type_file.num5,      #No.FUN-680122SMALLINT
            type   LIKE ccc_file.ccc07,      #No.FUN-7C0101 add
            a      LIKE type_file.chr1,      #FUN-7B0120 add
            more   LIKE type_file.chr1       #No.FUN-680122CHAR(1)         # Input more condition(Y/N)
           END RECORD
DEFINE g_i         LIKE type_file.num5       #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table     STRING                    #MOD-720042 add
DEFINE l_table1    STRING                    #FUN-7B0120 add
DEFINE g_sql       STRING                    #MOD-720042 add
DEFINE g_str       STRING                    #MOD-720042 add
 
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
 
   #MOD-720042 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = "ccc01.ccc_file.ccc01,  ccc08.ccc_file.ccc08,",     #No.FUN-7C0101 add ccc08
               "ccc91.ccc_file.ccc91,  ccc92.ccc_file.ccc92,",
               "ima02.ima_file.ima02,  ima021.ima_file.ima021,",
               "ima12.ima_file.ima12,  ima131.ima_file.ima131,",   #FUN-7B0120 add ima131
               "ima91.ima_file.ima91,  ima98.ima_file.ima98,",     
               "cost.ccc_file.ccc92,   price.ccc_file.ccc92,",
               "price_m.ccc_file.ccc92,value.ccc_file.ccc92,",     #FUN-7B0120 add price_m
               "value_2.ccc_file.ccc92,cme04.cme_file.cme04,",
               "cme05.cme_file.cme05,  type.type_file.chr1,",      #FUN-7B0120 add type 
               "azi03.azi_file.azi03,  azi04.azi_file.azi04,",
               "azi05.azi_file.azi05 " 
   LET l_table = cl_prt_temptable('axcr311',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #MOD-720042 By TSD.Jin--end
 
  #str FUN-7B0120 add
   #呆滯料明細表
   LET g_sql = "ccq01.ccq_file.ccq01,    ccq02.ccq_file.ccq02,",
               "ima021_q.ima_file.ima021,ccq03.ccq_file.ccq03,",
               "ccq04.ccq_file.ccq04,    u_cost.ccc_file.ccc23,",
               "type.type_file.chr1"                              #FUN-7B0120 add type 
   LET l_table1= cl_prt_temptable('axcr3111',g_sql) CLIPPED  # 產生Temp Table
   IF l_table1= -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  #end FUN-7B0120 add
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #TQC-610051-begin
   LET tm.yy   = ARG_VAL(8)
   LET tm.mm   = ARG_VAL(9)
   LET tm.type = ARG_VAL(10)       #FUN-7C0101
   LET tm.a    = ARG_VAL(11)       #FUN-7B0120 add
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)    #No.FUN-7C0078
   #TQC-610051-end
   #CHI-920006--BEGIN--
   DROP TABLE r311_file
   CREATE TEMP TABLE r311_file(
      mon       LIKE ccc_file.ccc92)
   #CHI-920006--END--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr311_tm(0,0)        # Input print condition
      ELSE CALL axcr311()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
END MAIN
 
FUNCTION axcr311_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,         #No.FUN-580031
       p_row,p_col    LIKE type_file.num5,         #No.FUN-680122 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr311_w AT p_row,p_col WITH FORM "axc/42f/axcr311"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #No.TQC-A40139  --Begin
#  LET tm.yy = YEAR(g_today)
#  LET tm.mm = MONTH(g_today)
   LET tm.yy = g_ccz.ccz01                                                       
   LET tm.mm = g_ccz.ccz02
   #No.TQC-A40139  --End  
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 add
   LET tm.a    = '1'                  #FUN-7B0120 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON ima01,ima08,ima12,ima131   #FUN-7B0120 add ima131,ccc01->ima01
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
      ON ACTION CONTROLP                                                      
         IF INFIELD(ima01) THEN    #FUN-7B0120 mod ccc01->ima01
            CALL cl_init_qry_var()                                           
            LET g_qryparam.form = "q_ima"                                    
            LET g_qryparam.state = "c"                                       
            CALL cl_create_qry() RETURNING g_qryparam.multiret               
            DISPLAY g_qryparam.multiret TO ima01   #FUN-7B0120 mod ccc01->ima01
            NEXT FIELD ima01   #FUN-7B0120 mod ccc01->ima01
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr311_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.a,tm.more WITHOUT DEFAULTS   #No.FUN-7C0101 add tm.type   #FUN-7B0120 add tm.a
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
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
#         IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN NEXT FIELD mm END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
      
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr311_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr311'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr311','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                    #" '",g_lang CLIPPED,"'",        #No.FUN-7C0078
                     " '",g_rlang CLIPPED,"'",       #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",         #TQC-610051
                     " '",tm.mm CLIPPED,"'",         #TQC-610051
                     " '",tm.type CLIPPED,"'" ,      #No.FUN-7C0101 add
                     " '",tm.a CLIPPED,"'",          #FUN-7B0120 add
                     " '",g_rep_user CLIPPED,"'",    #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",    #No.FUN-570264
                     " '",g_template CLIPPED,"'",    #No.FUN-570264
                     " '",g_rpt_name CLIPPED,"'"     #No.FUN-7C0078
         CALL cl_cmdat('axcr311',g_time,l_cmd)       # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr311_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr311()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr311_w
END FUNCTION
 
FUNCTION axcr311()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#         l_time    LIKE type_file.chr8            #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_sql1    LIKE type_file.chr1000,        #FUN-7B0120 add
          l_sqlc    LIKE type_file.chr1000,        #FUN-7B0120 add
          l_cntc1   LIKE type_file.num5,           #FUN-7B0120 add
          l_cntc2   LIKE type_file.num5,           #FUN-7B0120 add
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_tmp     LIKE ccc_file.ccc92,
          sr        RECORD 
                     ccc01    LIKE ccc_file.ccc01,    #料件編號
                     ccc08    LIKE ccc_file.ccc08,    #No.FUN-7C0101 add
                     ccc91    LIKE ccc_file.ccc91,    #期末數量
                     ccc92    LIKE ccc_file.ccc92,    #期末成本
                     ima02    LIKE ima_file.ima02,    #品名規格
                     ima021   LIKE ima_file.ima021,   #規格   #FUN-4C0099
                     ima12    LIKE ima_file.ima12,    #分群碼一
                     ima131   LIKE ima_file.ima131,   #產品分類   #FUN-7B0120 add
                     ima91    LIKE ima_file.ima91,    #最近月加權進價
                     ima98    LIKE ima_file.ima98,    #最近月加權售價
                     ima25    LIKE ima_file.ima25,    #庫存單位   #MOD-A40067 add
                     ima908   LIKE ima_file.ima908,   #計價單位   #MOD-A40067 add
                     ima44    LIKE ima_file.ima44,    #採購單位   #MOD-A40067 add
                     cost     LIKE ccc_file.ccc92,    #重置成本
                     price    LIKE ccc_file.ccc92,    #售價
                     price_m  LIKE ccc_file.ccc92,    #市價(重置成本,淨變現價值,淨變現減利潤三者中間值)   #FUN-7B0120 add
                     value    LIKE ccc_file.ccc92,    #淨變現價值
                     value_2  LIKE ccc_file.ccc92,    #淨變現減利潤
                     cme04    LIKE cme_file.cme04,    #費用率
                     cme05    LIKE cme_file.cme05,    #毛利率
                     type     LIKE type_file.chr1     #類別   #FUN-7B0120 add
                    END RECORD,
         #str FUN-7B0120 add
          sr1       RECORD 
                     ccq01    LIKE ccq_file.ccq01,    #料件編號
                     ccq02    LIKE ccq_file.ccq02,    #品名規格
                     ima021   LIKE ima_file.ima021,   #規格
                     ccq03    LIKE ccq_file.ccq03,    #庫存數量
                     ccq04    LIKE ccq_file.ccq04,    #庫存成本
                     u_cost   LIKE ccc_file.ccc23,    #單位成本
                     type     LIKE type_file.chr1     #類別
                    END RECORD
         #end FUN-7B0120 add
   DEFINE l_mon     DYNAMIC ARRAY OF LIKE ccc_file.ccc92  #CHI-920006
   DEFINE l_cost    DYNAMIC ARRAY OF LIKE ccc_file.ccc92  #CHI-920006
   DEFINE l_i       LIKE type_file.num5                   #CHI-920006 
   DEFINE l_n       LIKE type_file.num5                   #CHI-920006 
   DEFINE l_fac     LIKE ima_file.ima31_fac               #MOD-A40067 add
 
   #MOD-720042 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)   #FUN-7B0120 add
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?)"   #FUN-7B0120 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   #MOD-720042 By TSD.Jin--end
 
  #str FUN-7B0120 add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
  #end FUN-7B0120 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #070214 By TSD.Jin
 
   #LCM(Lower of Cost or Market Method-成本市價孰低法)
   IF tm.a = '1' OR tm.a = '3' THEN   #FUN-7B0120 add
      LET l_sql = "SELECT ccc01,ccc08,ccc91,ccc92,ima02,ima021,",   #FUN-7C0101 add ccc08
                  "       ima12,ima131,ima91,ima98,",   #FUN-7B0120 add ima131
                  "       ima25,ima908,ima44,",         #MOD-A40067 add
                  "       0,0,0,0,0,0,0,'1' ",          #FUN-7B0120 add 0,'1'
                  "  FROM ccc_file,ima_file ",
                  " WHERE ccc01 = ima01 ",
                  "   AND ccc02 = ",tm.yy,
                  "   AND ccc03 = ",tm.mm,
                  "   AND ccc07 ='",tm.type,"'",        #FUN-7C0101
                  "   AND ",tm.wc CLIPPED
 
      PREPARE axcr311_pr FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM 
      END IF
      DECLARE axcr311_cs1 CURSOR FOR axcr311_pr
 
      LET g_pageno = 0
      FOREACH axcr311_cs1 INTO sr.*
         IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         DELETE FROM r311_file   #CHI-920006
         IF cl_null(sr.ima91) THEN LET sr.ima91 = 0 END IF   #平均採購單價
         IF cl_null(sr.ima98) THEN LET sr.ima98 = 0 END IF   #月加權平均單價
 
        #str MOD-A40067 add
         #找出計價單位/採購單位與庫存單位間的轉換率
         IF g_sma.sma116 MATCHES '[13]' THEN
            CALL s_umfchk(sr.ccc01,sr.ima908,sr.ima25) RETURNING l_i,l_fac
         ELSE
            CALL s_umfchk(sr.ccc01,sr.ima44,sr.ima25) RETURNING l_i,l_fac
         END IF
         IF l_i = 1 THEN LET l_fac = 1 END IF
         #將單價轉換成以庫存單位為基準
         LET sr.ima91 = cl_digcut(sr.ima91/l_fac,g_ccz.ccz26)  #CHI-C30012 g_azi03->g_ccz.ccz26
        #end MOD-A40067 add

         #重置成本 = 本月結存數量 * 平均採購單價
         LET sr.cost = sr.ccc91 * sr.ima91
         IF cl_null(sr.cost) THEN LET sr.cost = 0 END IF
 
         #售價 = 本月結存數量 * 月加權平均單價
         LET sr.price = sr.ccc91 * sr.ima98
         IF cl_null(sr.price) THEN LET sr.price = 0 END IF
 
         #no.4046 cme04/cme05(費用率/毛利率)
         #以成本分群去抓cme04,cme05 
         SELECT cme04,cme05 INTO sr.cme04,sr.cme05 FROM cme_file
          WHERE cme01 = tm.yy
            AND cme02 = tm.mm
            AND cme03 = sr.ima12
            AND cme06 = '5'   #FUN-7B0120 add     #No.MOD-930026 modify
        #str FUN-7B0120 add
         IF SQLCA.sqlcode=100 THEN
            #以產品分類去抓cme04,cme05 
            SELECT cme04,cme05 INTO sr.cme04,sr.cme05 FROM cme_file
             WHERE cme01 = tm.yy
               AND cme02 = tm.mm
               AND cme031= sr.ima131
               AND cme06 = '6'   #FUN-7B0120 add   #No.MOD-930026 modify
         END IF
        #end FUN-7B0120 add
         IF cl_null(sr.cme04) THEN LET sr.cme04 = 0 END IF
         IF cl_null(sr.cme05) THEN LET sr.cme05 = 0 END IF
 
         #淨變現價值 = 售價 * ((100 - 費用率) / 100)
         LET sr.value = sr.price * ((100 - sr.cme04) / 100)
         IF cl_null(sr.value) THEN LET sr.value = 0 END IF
 
         #毛利 = 售價 * 毛利率 / 100
         LET l_tmp = sr.price * sr.cme05 / 100
         IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
 
         #淨變現減利潤 = 淨變現價值 - 毛利
         LET sr.value_2 = sr.value - l_tmp
 
#CHI-920006--BEGIN--MARK--
#       #str FUN-7B0120 add
#        #市價 = 重置成本cost,淨變現價值value,淨變現減利潤value_2三者中間值
#        CASE
#           WHEN sr.cost > sr.value > sr.value_2 OR sr.value_2 > sr.value > sr.cost
#              LET sr.price_m = sr.value
#           WHEN sr.value> sr.cost > sr.value_2 OR sr.value_2 >sr.cost > sr.value
#              LET sr.price_m = sr.cost
#           WHEN sr.cost > sr.value_2 > sr.value OR sr.value > sr.value_2 > sr.cost
#              LET sr.price_m = sr.value_2
#        END CASE
#       #end FUN-7B0120 add
#CHI-920006--END--MARK
   
        #CHI-920006--BEGIN--
        LET l_mon[1] = sr.cost
        LET l_mon[2] = sr.value
        LET l_mon[3] = sr.value_2
        FOR l_i = 1 TO 3
            INSERT INTO r311_file VALUES(l_mon[l_i])
            IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("ins","r311_file","","",STATUS,"","ins r311_file",1)
               EXIT FOR
            END IF
        END FOR
        DECLARE tmp_curs CURSOR FOR
           SELECT * FROM r311_file ORDER BY mon
        IF STATUS THEN
           CALL cl_err('tmp_curs',STATUS,1)
        END IF
        LET l_n = 1
        FOREACH tmp_curs INTO l_cost[l_n]
           IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
           IF l_n < 2 THEN
              LET l_n = l_n + 1
              CONTINUE FOREACH
           END IF
           LET sr.price_m = l_cost[l_n]
           EXIT FOREACH
        END FOREACH
        #CHI-920006--END--
          
         #MOD-720042 By TSD.Jin--start
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         EXECUTE insert_prep USING
            sr.ccc01, sr.ccc08,sr.ccc91,  sr.ccc92,sr.ima02,    #FUN-7C0101 add ccc08
            sr.ima021,sr.ima12,sr.ima131, sr.ima91,sr.ima98,    #FUN-7B0120 add ima131
            sr.cost,  sr.price,sr.price_m,sr.value,sr.value_2,  #FUN-7B0120 add price_m
            #sr.cme04, sr.cme05,sr.type,   g_azi03, g_azi04,     #FUN-7B0120 add type #CHI-C30012
            sr.cme04, sr.cme05,sr.type,   g_ccz.ccz26, g_ccz.ccz26,  #CHI-C30012
            #g_azi05 #CHI-C30012
            g_ccz.ccz26 #CHI-C30012
         #MOD-720042 By TSD.Jin--end  
      END FOREACH
   END IF   #FUN-7B0120 add
 
  #str FUN-7B0120 add
   #呆滯料明細表
   IF tm.a = '2' OR tm.a = '3' THEN
      LET l_sql = "SELECT ccq01,ccq02,ima021,ccq03,ccq04,0,'2' ",
                  "  FROM ccq_file,ima_file ",
                  " WHERE ccq01 = ima01 ",
                  "   AND ",tm.wc CLIPPED
 
      PREPARE axcr311_pr2 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM 
      END IF
      DECLARE axcr311_cs2 CURSOR FOR axcr311_pr2
 
      FOREACH axcr311_cs2 INTO sr1.*
         IF STATUS THEN 
            CALL cl_err('foreach2:',STATUS,1)
            EXIT FOREACH
         END IF
 
         IF cl_null(sr1.ccq03) THEN LET sr1.ccq03 = 0 END IF
         IF cl_null(sr1.ccq04) THEN LET sr1.ccq04 = 0 END IF
         LET sr1.u_cost = sr1.ccq04 / sr1.ccq03
         IF cl_null(sr1.u_cost) THEN LET sr1.u_cost = 0 END IF
 
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         EXECUTE insert_prep1 USING
            sr1.ccq01, sr1.ccq02,sr1.ima021,sr1.ccq03,sr1.ccq04,
            sr1.u_cost,sr1.type
      END FOREACH
   END IF
  #end FUN-7B0120 add
 
   #MOD-720042 By TSD.Jin--start
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
   #是否列印選擇條件
   LET g_str = NULL
   LET l_cntc1 = 0   LET l_cntc2 = 0   #FUN-7B0120 add
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ccc01,ima12,ima08')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ' '
   END IF
   #             p1        p2                     p3
   LET g_str = tm.wc,";",tm.yy USING '####',";",tm.mm USING '&&',";",
   #                p4           p5         p6
               #g_ccz.ccz27,";",g_azi03,";",tm.a   #FUN-7B0120 add tm.a #CHI-C30012
               g_ccz.ccz27,";",g_ccz.ccz26,";",tm.a   #CHI-C30012
   
  #str FUN-7B0120 mod
  #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #LCM
   LET l_sql = "SELECT A.*,B.ccq01,B.ccq02,B.ima021_q,B.ccq03,",
               "       B.ccq04,B.u_cost ",
               "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
               "       ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON(A.ccc01=B.ccq01) "
   #呆滯料
   LET l_sql1= "SELECT A.*,B.ccc01,B.ccc91,B.ccc92,B.ima02,",
               "       B.ima021,B.ima12,B.ima131,B.ima91,B.ima98,",
               "       B.cost,B.price,B.price_m,B.value,B.value_2,",
               "       B.cme04,B.cme05 ",
               "  FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A  LEFT OUTER JOIN  ",
               "       ",g_cr_db_str CLIPPED,l_table CLIPPED," B ON(A.ccq01=B.ccc01) "
   CASE tm.a
      WHEN '1'   #列印LCM 
         CALL cl_prt_cs3('axcr311','axcr311',l_sql,g_str)   #FUN-710080 modify   #FUN-7B0120 mod
      WHEN '2'   #列印呆滯料 
        #CALL cl_prt_cs3('axcr311','axcr311_1',l_sql,g_str)   #FUN-710080 modify   #FUN-7B0120 mod #FUN-8C0141
         CALL cl_prt_cs3('axcr311','axcr311_1',l_sql1,g_str)   #FUN-8C0141
      WHEN '3'   #全部 
         LET l_sqlc= "SELECT COUNT(*) ",
                     "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
                     "       ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON(A.ccc01=B.ccq01) "
         PREPARE axcr311_prc1 FROM l_sqlc
         DECLARE axcr311_csc1 CURSOR FOR axcr311_prc1
         OPEN axcr311_csc1
         FETCH axcr311_csc1 INTO l_cntc1
         IF l_cntc1 > 0 THEN 
            CALL cl_prt_cs3('axcr311','axcr311',l_sql,g_str)   #FUN-710080 modify   #FUN-7B0120 mod
         END IF
 
         LET l_sqlc= "SELECT COUNT(*) ",
                     "  FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A  LEFT OUTER JOIN  ",
                     "       ",g_cr_db_str CLIPPED,l_table CLIPPED," B ON(A.ccq01=B.ccc01) "
         PREPARE axcr311_prc2 FROM l_sqlc
         DECLARE axcr311_csc2 CURSOR FOR axcr311_prc2
         OPEN axcr311_csc2
         FETCH axcr311_csc2 INTO l_cntc2
         IF l_cntc2 > 0 THEN 
            IF l_cntc1 > 0 THEN
               CALL cl_err('','lib-002',1)
            END If
           #CALL cl_prt_cs3('axcr311','axcr311_1',l_sql,g_str)   #FUN-710080 modify   #FUN-7B0120 mod #FUN-8C0141
            CALL cl_prt_cs3('axcr311','axcr311_1',l_sql1,g_str)   #FUN-8C0141
         END IF
         IF l_cntc1 = 0 AND l_cntc2 = 0 THEN
            CALL cl_prt_cs3('axcr311','axcr311',l_sql,g_str)   #FUN-710080 modify   #FUN-7B0120 mod
         END IF
   END CASE
  #end FUN-7B0120 mod
   #MOD-720042 By TSD.Jin--end  
 
END FUNCTION
 
#MOD-720042 By TSD.Jin--start mark
##No.8741
#REPORT axcr311_rep(sr)
# #  DEFINE qty  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
#   DEFINE qty  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
#          u_p  LIKE oeb_file.oeb13,          #No.FUN-680122DECIMAL(20,6)
#          amt  LIKE oeb_file.oeb13           #No.FUN-680122 DECIMAL(20,6)
#   DEFINE l_last_sw LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
#          sr        RECORD 
#                    ccc01    LIKE ccc_file.ccc01,    #料件編號
#                    ccc91    LIKE ccc_file.ccc91,    #期末數量
#                    ccc92    LIKE ccc_file.ccc92,    #期末成本
#                    ima02    LIKE ima_file.ima02,    #品名規格
#                    ima021   LIKE ima_file.ima021,    #規格   #FUN-4C0099
#                    ima12    LIKE ima_file.ima12,    #分群碼一
#                    ima91    LIKE ima_file.ima91,    #最近月加權進價
#                    ima98    LIKE ima_file.ima98,    #最近月加權售價
#                    cost     LIKE ccc_file.ccc92,    #重置成本
#                    price    LIKE ccc_file.ccc92,    #售價
#                    value    LIKE ccc_file.ccc92,    #淨變現價值
#                    value_2  LIKE ccc_file.ccc92,    #淨變現減利潤
#                    cme04    LIKE cme_file.cme04,    #費用率
#                    cme05    LIKE cme_file.cme05     #毛利率
#                    END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ima12,sr.ccc01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_x[9] clipped,tm.yy USING '####','/',tm.mm USING '##'
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41] 
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.ccc01,
#            COLUMN g_c[32],sr.ima02,
#            COLUMN g_c[33],sr.ima021,
#            COLUMN g_c[34],cl_numfor(sr.ccc91,34,g_ccz.ccz27), #CHI-690007 3->ccz27
#            COLUMN g_c[35],cl_numfor(sr.ccc92,35,g_azi03),    #FUN-570190
#            COLUMN g_c[36],cl_numfor(sr.ima91,36,g_azi03),
#            COLUMN g_c[37],cl_numfor(sr.cost,37,g_azi03),    #FUN-570190
#            COLUMN g_c[38],cl_numfor(sr.ima98,38,g_azi03),
#            COLUMN g_c[39],cl_numfor(sr.price,39,g_azi03),    #FUN-570190
#            COLUMN g_c[40],cl_numfor(sr.value,40,g_azi03),    #FUN-570190
#            COLUMN g_c[41],cl_numfor(sr.value_2,41,g_azi03)    #FUN-570190
# 
#   ON LAST ROW
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
##No.8741(END)
#END REPORT
#MOD-720042 By TSD.Jin--end mark
