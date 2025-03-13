# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor208.4gl
# Descriptions...: 成品出入庫明細帳
# Date & Author..: 05/01/25 By wujie
# Modify.........: No.FUN-550036 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5B0108 05/11/12 By Claire 單據欄位放大
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-840238 08/05/09 By TSD.lucasyeh 傳統報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.TQC-930035 09/03/11 By mike 解決溢位問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)   # Where conditiona
              bdate   LIKE type_file.dat,          #No.FUN-680069 DATE
              edate   LIKE type_file.dat,          #No.FUN-680069 DATE
              a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # Convert HS Code
              s       LIKE type_file.chr4,         #No.FUN-680069 VARCHAR(3) # Order by sequence
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
           END RECORD
DEFINE   g_i           LIKE type_file.num5         #l_count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   l_wc          LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(300)
DEFINE   l_i           LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE   g_head1       STRING
DEFINE   g_orderA ARRAY[3] OF LIKE cor_file.cor01  #No.FUN-680069 VARCHAR(10)
DEFINE  g_sql   STRING,
        g_str   STRING,
        l_table STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#-------------------No.TQC-610082 modify
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   LET tm.s     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
  #LET tm.a  = 'N'
#-------------------No.TQC-610082 modify
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
  #----FUN-840238 add----start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "cob01.cob_file.cob01,",         #編號
               "cob02.cob_file.cob02,",         #品名
               "cob021.cob_file.cob021,",       #規格
               "cob09.cob_file.cob09,",         #HS CODE
               "cor03.cor_file.cor03,",         #年月日
               "smydesc.smy_file.smydesc,",     #名稱
               "cor01.cor_file.cor01,",         #出入庫號碼
               "coo07.coo_file.coo07,",         #報關單號
               "cor15.cor_file.cor15,",         #工單編號
               "cor10.cor_file.cor10,",         #單位
 
               "cor08.cor_file.cor08,",         #客戶簡稱
               "cor09.cor_file.cor09,",         #入庫明細之內部
               "cor12.cor_file.cor12,",         #入庫明細之合同
               "order1.cor_file.cor01,",       
               "order2.cor_file.cor01,",      
               "order3.cor_file.cor01,",     
               "l_sum1.cor_file.cor12,",        #入庫明細之合同累計
               "l_sum2.coo_file.coo16,",        #出庫明細之直接出口合同累計
               "l_sum3.coo_file.coo16,",        #出庫明細之結轉出口合同累計
               "l_sum4.coo_file.coo16,",        #出庫明細之內銷合同累計
 
               "l_sum5.coo_file.coo16,",        #出庫累計
               "l_sum6.coo_file.coo16,",        #合同結餘
               "l_cou1.coo_file.coo14,",        #出庫明細之直接出口-內部
               "l_cou2.coo_file.coo16,",        #出庫明細之直接出口-合同
               "l_cou3.coo_file.coo14,",        #轉廠出口-內部
               "l_cou4.coo_file.coo16,",        #轉廠出口-合同
               "l_cou5.coo_file.coo14,",        #內銷    -內部
               "l_cou6.coo_file.coo16,",        #銷    -合同
               "l_cou7.coo_file.coo16,",        #出庫累計之本日,
               "gr_sum1.cor_file.cor12,",       #入庫明細之合同累計
 
               "gr_sum2.coo_file.coo16,",       #出庫明細之直接出口合同累計
               "gr_sum3.coo_file.coo16,",       #出庫明細之結轉出口合同累計
               "gr_sum4.coo_file.coo16,",       #出庫明細之內銷合同累計
               "gr_sum5.coo_file.coo16,",       #出庫累計
               "gr_sum6.coo_file.coo16,",       #合同結餘
               "tm_a.type_file.chr1"
                                                #36 items
 
   LET l_table = cl_prt_temptable('acor208',g_sql) CLIPPED   # 產生Temp Table
 
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?) "
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      CALL r208_tm(0,0)
   ELSE
      CALL r208()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION r208_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(1000)
 
   OPEN WINDOW r208_w WITH FORM "aco/42f/acor208"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate  = g_today
   LET tm.edate  = g_today
   LET tm.a   = 'N'
   LET tm2.s1 = '1'
   LET tm2.s2 = '2'
   LET tm2.s3 = '3'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON cor06,cor01,cor05
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
 
{     ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
}
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
      CLOSE WINDOW r208_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r208_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
 
     INPUT BY NAME tm.bdate,tm.edate,tm.a,tm2.s1,tm2.s2,tm2.s3,tm.more
                   WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIElD bdate
            IF cl_null(tm.bdate) THEN
                NEXT FIELD bdate
            END IF
 
      AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
                NEXT FIELD edate
            END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
     ON ACTION CONTROLG CALL cl_cmdask()
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
 {     ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
}
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
      CLOSE WINDOW r208_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='acor208'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor208','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'" ,          #No.TQC-610082 add 
                         " '",tm.edate CLIPPED,"'" ,          #No.TQC-610082 add 
                         " '",tm.a CLIPPED,"'" ,              #No.TQC-610082 add  
                         " '",tm.s CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acor208',g_time,l_cmd)
      END IF
      CLOSE WINDOW r208_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r208()
   ERROR ""
END WHILE
   CLOSE WINDOW r208_w
END FUNCTION
 
FUNCTION r208()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_za05    LIKE za_file.za05,
          l_sliptype LIKE oay_file.oayslip,        #No.FUN-680069 VARCHAR(5) #No.FUN-550036
          l_cnt     LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          l_order   ARRAY[5] OF LIKE cor_file.cor01,       #No.FUN-680069 VARCHAR(20)
          l_cob01   LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(20)
          sr            RECORD
                               cob01  LIKE cob_file.cob01,  #編號
                               cob02  LIKE cob_file.cob02,  #品名
                               cob021 LIKE cob_file.cob021, #規格
                               cob04  LIKE cob_file.cob04,  #合同單位
                               cob09  LIKE cob_file.cob09   #HS Code
                        END RECORD,
          sr1           RECORD
                               cor03  LIKE cor_file.cor03,   #年月日
                               smydesc    LIKE smy_file.smydesc,  #名稱
                               cor01  LIKE cor_file.cor01,   #出入庫號碼
                               coo07  LIKE coo_file.coo07,   #報關單號
                               cor15  LIKE cor_file.cor15,   #工單編號
                               cor10  LIKE cor_file.cor10,   #單位
                               cor07  LIKE cor_file.cor07,   #客戶編號
                               cor08  LIKE cor_file.cor08,   #客戶簡稱
                               cor09  LIKE cor_file.cor09,   #入庫明細之內部
                               cor12  LIKE cor_file.cor12,   #入庫明細之合同
                               coo14  LIKE coo_file.coo14,   #內部
                               coo16  LIKE coo_file.coo16,   #合同
                               coo10  LIKE coo_file.coo10,   #用來判斷出庫類別
                               coo11  LIKE coo_file.coo11    #商品編號
                        END RECORD,
          sr2           RECORD
                               order1 LIKE cor_file.cor01,       #No.FUN-680069 VARCHAR(20)
                               order2 LIKE cor_file.cor01,       #No.FUN-680069 VARCHAR(20)
                               order3 LIKE cor_file.cor01        #No.FUN-680069 VARCHAR(20)
                        END RECORD
  #---FUN-840238 add----start
   DEFINE l_sum1       LIKE cor_file.cor12,          #入庫明細之合同累計
          l_sum2       LIKE coo_file.coo16,          #出庫明細之直接出口合同累計
          l_sum3       LIKE coo_file.coo16,          #出庫明細之結轉出口合同累計
          l_sum4       LIKE coo_file.coo16,          #出庫明細之內銷合同累計
          l_sum5       LIKE coo_file.coo16,          #出庫累計
          l_sum6       LIKE coo_file.coo16,          #合同結余
          l_sum7       LIKE cnk_file.cnk05,          #余下sum是計算時臨時用的
          l_sum8       LIKE coo_file.coo16,        
          l_sum9       LIKE coo_file.coo16        
   DEFINE l_sum01      LIKE cor_file.cor12,          #入庫明細之合同累計
          l_sum02      LIKE coo_file.coo16,          #出庫明細之直接出口合同累計
          l_sum03      LIKE coo_file.coo16,          #出庫明細之結轉出口合同累計
          l_sum04      LIKE coo_file.coo16,          #出庫明細之內銷合同累計
          l_sum05      LIKE coo_file.coo16,          #出庫累計
          l_sum06      LIKE coo_file.coo16           #合同結余
   DEFINE l_cou1       LIKE coo_file.coo14,          #出庫明細之直接出口-內部
          l_cou2       LIKE coo_file.coo16,          #出庫明細之直接出口-合同
          l_cou3       LIKE coo_file.coo14,          #轉廠出口-內部
          l_cou4       LIKE coo_file.coo16,          #轉廠出口-合同
          l_cou5       LIKE coo_file.coo14,          #內銷    -內部
          l_cou6       LIKE coo_file.coo16,          #銷    -合同
          l_cou7       LIKE coo_file.coo16,          #出庫累計之本日
          l_cob01_t    LIKE cob_file.cob01,
          l_coo16      LIKE coo_file.coo16,
          l_coo10      LIKE coo_file.coo10,
          l_title      LIKE cob_file.cob08,       
          l_yy         LIKE type_file.num5,       
          l_mm         LIKE type_file.num5,       
          l_py         LIKE type_file.num5,       
          l_pm         LIKE type_file.num5,    
          l_bdate      LIKE type_file.dat,       
          l_edate      LIKE type_file.dat
   DEFINE l_odrstr     STRING
  #---FUN-840238 add----end
 
    #FUN-840238  ---start---
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
    #FUN-840238  ----end----  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-840238 add
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND adduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND addgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND addgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('adduser', 'addgrup')
     #End:FUN-980030
 
   LET l_wc = tm.wc
 
#TQC-930035 ----start
  #FOR l_i = 1 TO 296
  #   IF l_wc[l_i,l_i+4] = 'cor06' THEN LET l_wc[l_i,l_i+4] = 'coo12' END IF
  #   IF l_wc[l_i,l_i+4] = 'cor01' THEN LET l_wc[l_i,l_i+4] = 'coo01' END IF
  #   IF l_wc[l_i,l_i+4] = 'cor05' THEN LET l_wc[l_i,l_i+4] = 'coo11' END IF
  #END FOR
   LET l_wc=cl_replace_str(l_wc,"cor06","coo12")
   LET l_wc=cl_replace_str(l_wc,"cor01","coo01") 
   LET l_wc=cl_replace_str(l_wc,"cor05","coo11") 
#TQC-930035  ----end
 
      LET l_sql = "SELECT DISTINCT cob01,cob02,cob021,cob04",
                  "               ,cob09 ",                   #FUN-840238 add
                   "  FROM cob_file,cod_file,cor_file ",
                   " WHERE cob01 = cor05 ",
                   "   AND cob01 = cod03 ",
                   "   AND coracti = 'Y' AND cor00 = '1' ",
                   "   AND cobacti = 'Y' ",
                   "   AND cor03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                   "   AND ", tm.wc CLIPPED,
                   " UNION ",
                   "SELECT DISTINCT cob01,cob02,cob021,cob04",
                   "               ,cob09 ",                   #FUN-840238 add
                   "  FROM cob_file,cod_file,coo_file ",
                   " WHERE cob01 = coo11 ",
                   "   AND cob01 = cod03 ",
                   "   AND cooacti = 'Y'",
                   "   AND cooconf = 'Y'",
                   "   AND cobacti = 'Y' ",
                   "   AND coo03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                   "   AND ", l_wc  CLIPPED
 
     PREPARE r208_pre1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('pre1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE r208_cs1 CURSOR FOR r208_pre1
 
     LET l_sql = "SELECT cor03,smydesc,cor01,'',cor15,cor10,",
                 "       cor07,cor08,cor09,cor12,'','','',cor05 ",
                 " FROM cor_file LEFT OUTER JOIN smy_file ON cor01 like ltrim(rtrim(smyslip)) || '-%' ",
                 "WHERE cor05 = ? ",
#No.FUN-550036--begin
#                "  AND smy_file.smyslip=substr(cor01,1,3)",
#No.FUN-550036--end
                 "  AND coracti = 'Y'",
                 "  AND cor00 = '1' AND ",tm.wc CLIPPED,
                 "  AND cor03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "ORDER BY cor03 "
     PREPARE r208_pre2 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('pre2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE r208_cs2 CURSOR FOR r208_pre2
 
     LET l_sql = "SELECT coo03,smydesc,coo01,coo07,'',coo15,'',coo06,'','',",
                 "      coo14,coo16,coo10,coo11 ",
                 " FROM coo_file LEFT OUTER JOIN smy_file ON coo01 like ltrim(rtrim(smyslip)) || '-%' ",
                 "WHERE coo11 = ? ",
#No.FUN-550036--begin
#                "  AND smy_file.smyslip=substr(coo01,1,3)",
#No.FUN-550036--end
                 "  AND cooacti = 'Y'",
                 "  AND cooconf = 'Y'",
                 "  AND ",l_wc CLIPPED,
                 "  AND coo03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "ORDER BY coo03 "
     PREPARE r208_pre3 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('pre3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE r208_cs3 CURSOR FOR r208_pre3
 
     DROP TABLE r208_temp
#No.FUN-680069-begin
     CREATE TEMP TABLE r208_temp(
                     cor03  LIKE cor_file.cor03,
                     smydesc LIKE type_file.chr1000,
                     cor01  LIKE cor_file.cor01,
                     coo07  LIKE coo_file.coo07,
                     cor15  LIKE cor_file.cor15,
                     cor10  LIKE cor_file.cor10,
                     cor07  LIKE cor_file.cor07,
                     cor08  LIKE cor_file.cor08,
                     cor09  LIKE cor_file.cor09,
                     cor12  LIKE cor_file.cor12,
                     coo14  LIKE coo_file.coo14,
                     coo16  LIKE coo_file.coo16,
                     coo10  LIKE coo_file.coo10,
                     coo11  LIKE coo_file.coo11)
#No.FUN-680069-end
    #CALL cl_outnam('acor208') RETURNING l_name    #FUN-840238 mark
    #START REPORT r208_rep TO l_name               #FUN-840238 mark
    #LET g_pageno = 0                              #FUN-840238 mark
     DELETE FROM r208_temp
     FOREACH r208_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       # 處理內部單據  CURSOR r208_cs2
       FOREACH r208_cs2 USING sr.cob01 INTO sr1.*
          IF SQLCA.sqlcode  THEN
             CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
          END IF
          INSERT INTO r208_temp VALUES(sr1.*)
       END FOREACH
       # 處理外部單據 CURSOR r208_cs3
       FOREACH r208_cs3 USING sr.cob01 INTO sr1.*
          IF SQLCA.sqlcode  THEN
             CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
          END IF
          INSERT INTO r208_temp VALUES(sr1.*)
       END FOREACH
 
       LET l_sql = " SELECT * FROM r208_temp"
 
      #---FUN-840238 add---Start
       LET l_odrstr = ''
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1'
                    IF cl_null(l_odrstr) THEN
                       LET l_odrstr =" ORDER BY "
                    ELSE
                       LET l_odrstr = l_odrstr, ","
                    END IF
                    LET l_odrstr = l_odrstr, "cor03"
 
               WHEN tm.s[g_i,g_i] = '2'
                    IF cl_null(l_odrstr) THEN
                       LET l_odrstr =" ORDER BY "
                    ELSE
                       LET l_odrstr = l_odrstr, ","
                    END IF
                    LET l_odrstr = l_odrstr, "cor01"
 
               WHEN tm.s[g_i,g_i] = '3'
                    IF cl_null(l_odrstr) THEN
                       LET l_odrstr =" ORDER BY "
                    ELSE
                       LET l_odrstr = l_odrstr, ","
                    END IF
                    LET l_odrstr = l_odrstr, "cor07"
 
               OTHERWISE
                    LET l_odrstr = l_odrstr
          END CASE
       END FOR
       IF NOT cl_null(l_odrstr) THEN
          LET l_sql = l_sql, l_odrstr
       END IF
      #---FUN-840238 add---End
 
       PREPARE r208_pre4 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
          EXIT PROGRAM 
       END IF
 
       #---FUN-840238  add---start
       LET l_cob01_t = ''     
       LET l_sum1 = 0
       LET l_sum2 = 0
       LET l_sum3 = 0
       LET l_sum4 = 0
       LET l_sum5 = 0
       LET l_sum6 = 0
       LET l_sum7 = 0
       LET l_sum8 = 0
       LET l_sum9 = 0
       LET l_cou1 = 0
       LET l_cou2 = 0
       LET l_cou3 = 0
       LET l_cou4 = 0
       LET l_cou5 = 0
       LET l_cou6 = 0
       LET l_cou7 = 0
       #---FUN-840238  add-----end
 
       DECLARE r208_cs4 CURSOR FOR r208_pre4
       FOREACH r208_cs4 INTO sr1.*
 
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr1.cor03
             #                          LET g_orderA[g_i] = g_x[26]  #FUN-840238 mark
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr1.cor01
             #                          LET g_orderA[g_i] = g_x[27]  #FUN-840238 mark
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr1.cor07
             #                          LET g_orderA[g_i] = g_x[28]  #FUN-840238 mark
               OTHERWISE LET l_order[g_i] = '-'
             #           LET g_orderA[g_i] = ' '          #清為空白  #FUN-840238 mark
          END CASE
       END FOR
       LET sr2.order1 = l_order[1]
       LET sr2.order2 = l_order[2]
       LET sr2.order3 = l_order[3]
 
      #OUTPUT TO REPORT r208_rep(sr.*,sr1.*,sr2.*)    #FUN-840238  mark
 
      #---FUN-840238 add---start
      IF sr.cob01 = sr1.coo11 THEN
        IF sr.cob01 != l_cob01_t OR cl_null(l_cob01_t) THEN
           #計算當前年度期別
           CALL s_yp(tm.bdate) RETURNING l_yy,l_mm
           CALL s_lsperiod(YEAR(tm.bdate),MONTH(tm.bdate)) RETURNING l_py,l_pm
           CALL s_azn01(l_yy,l_mm) RETURNING l_bdate,l_edate
           # 入庫明細合同累計
           SELECT sum(cor12) INTO l_sum1
             FROM cor_file
            WHERE cor03<l_bdate AND cor05=sr.cob01 AND cor00='1'
           IF cl_null(l_sum1) THEN
             LET l_sum1 = 0
           END IF
 
          # 出庫明細之直接出口合同累計
          SELECT sum(cnk05-cnk06) INTO l_sum7
            FROM cnk_file,cob_file
           WHERE cnk02=cob_file.cob01 AND cnk03=l_py AND cnk04=l_pm
          SELECT sum(coo16) INTO l_sum8
            FROM coo_file
           WHERE coo10 = '1'
             AND coo03 BETWEEN l_bdate and tm.bdate
          SELECT sum(coo16) INTO l_sum9
            FROM coo_file
           WHERE coo10 = '6'
             AND coo03 BETWEEN l_bdate and tm.bdate
          IF cl_null(l_sum7) THEN
             LET l_sum7 = 0
          END IF
          IF cl_null(l_sum8) THEN
             LET l_sum8 = 0
          END IF
          IF cl_null(l_sum9) THEN
             LET l_sum9 = 0
          END IF
          LET l_sum2 = l_sum7+l_sum8-l_sum9
          LET l_sum7 = 0
          LET l_sum8 = 0
          LET l_sum9 = 0
 
          # 出庫明細之結轉出口合同累計
          SELECT sum(cnk07-cnk08) INTO l_sum7
            FROM cnk_file
           WHERE cnk02=sr.cob01 AND cnk03=l_py AND cnk04=l_pm
          SELECT sum(coo16) INTO l_sum8
            FROM coo_file
           WHERE coo10 = '2'
             AND coo03 BETWEEN l_bdate and tm.bdate
          SELECT sum(coo16) INTO l_sum9
            FROM coo_file
           WHERE coo10 = '7'
             AND coo03 BETWEEN l_bdate and tm.bdate
          IF cl_null(l_sum7) THEN
             LET l_sum7 = 0
          END IF
          IF cl_null(l_sum8) THEN
             LET l_sum8 = 0
          END IF
          IF cl_null(l_sum9) THEN
             LET l_sum9 = 0
          END IF
          LET l_sum3 = l_sum7+l_sum8-l_sum9
          LET l_sum7 = 0
          LET l_sum8 = 0
          LET l_sum9 = 0
 
          # 出庫明細之內銷合同累計
          SELECT sum(cnk09-cnk10) INTO l_sum7
            FROM cnk_file
           WHERE cnk02=sr.cob01 AND cnk03=l_py AND cnk04=l_pm
          SELECT sum(coo16) INTO l_sum8
            FROM coo_file
           WHERE coo10 = '0'
             AND coo03 BETWEEN l_bdate and tm.bdate
          SELECT sum(coo16) INTO l_sum9
            FROM coo_file
           WHERE coo10 = '5'
             AND coo03 BETWEEN l_bdate and tm.bdate
          IF cl_null(l_sum7) THEN
             LET l_sum7 = 0
          END IF
          IF cl_null(l_sum8) THEN
             LET l_sum8 = 0
          END IF
          IF cl_null(l_sum9) THEN
             LET l_sum9 = 0
          END IF
          LET l_sum4 = l_sum7+l_sum8-l_sum9
          LET l_sum7 = 0
          LET l_sum8 = 0
          LET l_sum9 = 0
 
          # 出庫累計
          LET l_sum5 = l_sum2+l_sum3+l_sum4
 
          # 合同結余
          LET l_sum6 = l_sum1-l_sum5
 
          LET l_sum01 = l_sum1
          LET l_sum02 = l_sum2
          LET l_sum03 = l_sum3
          LET l_sum04 = l_sum4
          LET l_sum05 = l_sum5
          LET l_sum06 = l_sum6
 
          LET l_cob01_t = sr.cob01
        END IF
 
        # 計算出庫明細各欄位數據
        # 入庫明細
        IF cl_null(sr1.cor12) THEN
           LET sr1.cor12 = 0
        END IF
        LET l_sum1 = l_sum1+sr1.cor12
 
       CASE sr1.coo10
        WHEN '1'                   # 出庫明細-直接出口
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = sr1.coo14
         LET l_cou2 = sr1.coo16
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou2
         LET l_sum2 = l_sum2+l_cou2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
        WHEN '6'
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = -sr1.coo14
         LET l_cou2 = -sr1.coo16
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou2
         LET l_sum2 = l_sum2+l_cou2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
        WHEN '2'                   # 出庫明細-轉廠出口
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = sr1.coo14
         LET l_cou4 = sr1.coo16
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou4
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3+l_cou4
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
        WHEN '7'
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = -sr1.coo14
         LET l_cou4 = -sr1.coo16
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou4
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3+l_cou4
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
        WHEN '0'                   # 出庫明細-內銷出口
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = sr1.coo14
         LET l_cou6 = sr1.coo16
         LET l_cou7 = l_cou6
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4+l_cou6
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
        WHEN '5'
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = -sr1.coo14
         LET l_cou6 = -sr1.coo16
         LET l_cou7 = l_cou6
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4+l_cou6
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
        OTHERWISE              #入庫
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = ''
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2
         LET l_sum6 = l_sum1-l_sum5
       END CASE
       #*********將值塞入temp_table*********
       EXECUTE insert_prep USING sr.cob01, sr.cob02, sr.cob021, sr.cob09,
                                 sr1.cor03, sr1.smydesc, sr1.cor01, sr1.coo07,
                                 sr1.cor15, sr1.cor10,   sr1.cor08, sr1.cor09,
                                 sr1.cor12,
                                 sr2.order1, sr2.order2, sr2.order3,
                                 l_sum1, l_sum2, l_sum3, l_sum4,
                                 l_sum5, l_sum6,
                                 l_cou1, l_cou2, l_cou3, l_cou4,
                                 l_cou5, l_cou6, l_cou7,
                                 l_sum01, l_sum02, l_sum03,
                                 l_sum04, l_sum05, l_sum06,
                                 tm.a
       #----------------------------CR (3)--------------------------#
      END IF 
      #---FUN-840238 add---end
       END FOREACH
     END FOREACH
 
    #FUN-840238  ---start---
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'zu01')             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm2.s1[1,1],";",
                 tm2.s2[1,1],";",tm2.s3[1,1]
 
     CALL cl_prt_cs3('acor208','acor208',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
    #FUN-840238  ----end----
 
    #FINISH REPORT r208_rep                           #FUN-840238
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #FUN-840238
END FUNCTION
#No.FUN-870144 
#FUN-840238 mark
{
REPORT r208_rep(sr,sr1,sr2)
   DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-680069 VARCHAR(1)
          l_sum1       LIKE cor_file.cor12,        #No.FUN-680069 DEC(13,2)   #入庫明細之合同累計
          l_sum2       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #出庫明細之直接出口合同累計
          l_sum3       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #出庫明細之結轉出口合同累計
          l_sum4       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #出庫明細之內銷合同累計
          l_sum5       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #出庫累計
          l_sum6       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #合同結余
          l_sum7       LIKE cnk_file.cnk05,        #No.FUN-680069 DEC(13,2)   #余下sum是計算時臨時用的
          l_sum8       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2) 
          l_sum9       LIKE coo_file.coo16         #No.FUN-680069 DEC(13,2)
   DEFINE l_cou1       LIKE coo_file.coo14,        #No.FUN-680069 DEC(13,2)   #出庫明細之直接出口-內部
          l_cou2       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #出庫明細之直接出口-合同
          l_cou3       LIKE coo_file.coo14,        #No.FUN-680069 DEC(13,2)   #轉廠出口-內部
          l_cou4       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #轉廠出口-合同
          l_cou5       LIKE coo_file.coo14,        #No.FUN-680069 DEC(13,2)   #內銷    -內部
          l_cou6       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #銷    -合同
          l_cou7       LIKE coo_file.coo16,        #No.FUN-680069 DEC(13,2)   #出庫累計之本日
          l_cob01_t    LIKE cob_file.cob01,
          l_cob09      LIKE cob_file.cob09,
          l_coo16      LIKE coo_file.coo16,
          l_coo10      LIKE coo_file.coo10,
          l_title      LIKE cob_file.cob08,         #No.FUN-680069 VARCHAR(30)
          l_yy         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_mm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_py         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_pm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_bdate      LIKE type_file.dat,          #No.FUN-680069 DATE
          l_edate      LIKE type_file.dat           #No.FUN-680069 DATE
   DEFINE sr            RECORD
                               cob01  LIKE cob_file.cob01,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               cob04  LIKE cob_file.cob04
                        END RECORD,
          sr1           RECORD
                               cor03  LIKE cor_file.cor03,   #年月日
                               smydesc    LIKE smy_file.smydesc,  #名稱
                               cor01  LIKE cor_file.cor01,   #出入庫號碼
                               coo07  LIKE coo_file.coo07,   #報關單號
                               cor15  LIKE cor_file.cor15,   #工單編號
                               cor10  LIKE cor_file.cor10,   #單位
                               cor07  LIKE cor_file.cor07,   #客戶編號
                               cor08  LIKE cor_file.cor08,   #客戶
                               cor09  LIKE cor_file.cor09,   #入庫明細之內部
                               cor12  LIKE cor_file.cor12,   #入庫明細之合同
                               coo14  LIKE coo_file.coo14,   #內部
                               coo16  LIKE coo_file.coo16,   #合同
                               coo10  LIKE coo_file.coo10,   #用來判斷出庫類別
                               coo11  LIKE coo_file.coo11    #商品編號
                        END RECORD,
          sr2           RECORD
                               order1 LIKE cor_file.cor01,       #No.FUN-680069 VARCHAR(20)
                               order2 LIKE cor_file.cor01,       #No.FUN-680069 VARCHAR(20)
                               order3 LIKE cor_file.cor01        #No.FUN-680069 VARCHAR(20)
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.cob01,sr2.order1,sr2.order2,sr2.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN (((g_len-FGL_WIDTH(g_x[1])))/2)+1 ,g_x[1]
      LET g_head1 = g_x[25] CLIPPED, g_orderA[1] CLIPPED, '-',
                    g_orderA[2] CLIPPED, '-', g_orderA[3]
      PRINT g_head1
      PRINT
 
      IF tm.a = 'N' THEN
          PRINT COLUMN 1,g_x[9] CLIPPED,sr.cob01 CLIPPED,' ';
      ELSE
          SELECT cob09 INTO l_cob09 FROM cob_file
           WHERE cob01 = sr.cob01
          PRINT COLUMN 1,g_x[9] CLIPPED,l_cob09 CLIPPED,' ';
      END IF
      PRINT g_x[10] CLIPPED,sr.cob02 CLIPPED,' ',
            g_x[29] CLIPPED,sr.cob021 CLIPPED,
            COLUMN (g_len-30)/2,g_x[11] CLIPPED,tm.bdate,'--',tm.edate,
            COLUMN (g_len-14),g_x[12] CLIPPED,sr.cob04
      PRINT g_dash[1,g_len]
 
      PRINT COLUMN r208_getStartPos(31,37,g_x[13]),g_x[13],
            COLUMN r208_getStartPos(38,40,g_x[14]),g_x[14],
            COLUMN r208_getStartPos(41,51,g_x[15]),g_x[15]
      PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+g_w[32]+g_w[33]+g_w[34]+g_w[35]
                                   +g_w[36]+g_w[37]+6],
            COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+2],
            COLUMN g_c[41],g_dash2[1,g_w[41]+g_w[42]+g_w[43]+g_w[44]+g_w[45]
                                   +g_w[46]+g_w[47]+g_w[48]+g_w[49]+g_w[50]
                                   +g_w[51]+10]
      PRINT COLUMN g_c[31],g_x[16],
            COLUMN r208_getStartPos(32,37,g_x[17]),g_x[17],
            COLUMN r208_getStartPos(38,39,g_x[18]),g_x[18],
            COLUMN r208_getStartPos(41,43,g_x[19]),g_x[19],
            COLUMN r208_getStartPos(44,46,g_x[20]),g_x[20],
            COLUMN r208_getStartPos(47,49,g_x[21]),g_x[21],
            COLUMN r208_getStartPos(50,51,g_x[22]),g_x[22]
      PRINT COLUMN g_c[31],g_dash2[1,g_w[31]],
            COLUMN g_c[32],g_dash2[1,g_w[32]+g_w[33]+g_w[34]+g_w[35]
                                   +g_w[36]+g_w[37]+5],
            COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+1],
            COLUMN g_c[41],g_dash2[1,g_w[41]+g_w[42]+g_w[43]+2],
            COLUMN g_c[44],g_dash2[1,g_w[44]+g_w[45]+g_w[46]+2],
            COLUMN g_c[47],g_dash2[1,g_w[47]+g_w[48]+g_w[49]+2],
            COLUMN g_c[50],g_dash2[1,g_w[50]+g_w[51]+1]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52]
      PRINT g_dash1
      LET l_last_sw='n'
 
   BEFORE GROUP OF sr.cob01
         LET l_cob01_t = ''
         LET l_sum1 = 0
         LET l_sum2 = 0
         LET l_sum3 = 0
         LET l_sum4 = 0
         LET l_sum5 = 0
         LET l_sum6 = 0
         LET l_sum7 = 0
         LET l_sum8 = 0
         LET l_sum9 = 0
         LET l_cou1 = 0
         LET l_cou2 = 0
         LET l_cou3 = 0
         LET l_cou4 = 0
         LET l_cou5 = 0
         LET l_cou6 = 0
         LET l_cou7 = 0
         SKIP TO TOP OF PAGE
 
   ON EVERY ROW
      IF sr.cob01 = sr1.coo11 THEN
       IF sr.cob01 != l_cob01_t OR cl_null(l_cob01_t) THEN
          #計算當前年度期別
          CALL s_yp(tm.bdate) RETURNING l_yy,l_mm
          CALL s_lsperiod(YEAR(tm.bdate),MONTH(tm.bdate)) RETURNING l_py,l_pm
          CALL s_azn01(l_yy,l_mm) RETURNING l_bdate,l_edate
          # 入庫明細合同累計
          SELECT sum(cor12) INTO l_sum1
            FROM cor_file
           WHERE cor03<l_bdate AND cor05=sr.cob01 AND cor00='1'
          IF cl_null(l_sum1) THEN
            LET l_sum1 = 0
          END IF
 
 
          # 出庫明細之直接出口合同累計
          SELECT sum(cnk05-cnk06) INTO l_sum7
            FROM cnk_file,cob_file
           WHERE cnk02=cob_file.cob01 AND cnk03=l_py AND cnk04=l_pm
          SELECT sum(coo16) INTO l_sum8
            FROM coo_file
           WHERE coo10 = '1'
             AND coo03 BETWEEN l_bdate and tm.bdate
          SELECT sum(coo16) INTO l_sum9
            FROM coo_file
           WHERE coo10 = '6'
             AND coo03 BETWEEN l_bdate and tm.bdate
          IF cl_null(l_sum7) THEN
             LET l_sum7 = 0
          END IF
          IF cl_null(l_sum8) THEN
             LET l_sum8 = 0
          END IF
          IF cl_null(l_sum9) THEN
             LET l_sum9 = 0
          END IF
          LET l_sum2 = l_sum7+l_sum8-l_sum9
          LET l_sum7 = 0
          LET l_sum8 = 0
          LET l_sum9 = 0
 
 
          # 出庫明細之結轉出口合同累計
          SELECT sum(cnk07-cnk08) INTO l_sum7
            FROM cnk_file
           WHERE cnk02=sr.cob01 AND cnk03=l_py AND cnk04=l_pm
          SELECT sum(coo16) INTO l_sum8
            FROM coo_file
           WHERE coo10 = '2'
             AND coo03 BETWEEN l_bdate and tm.bdate
          SELECT sum(coo16) INTO l_sum9
            FROM coo_file
           WHERE coo10 = '7'
             AND coo03 BETWEEN l_bdate and tm.bdate
          IF cl_null(l_sum7) THEN
             LET l_sum7 = 0
          END IF
          IF cl_null(l_sum8) THEN
             LET l_sum8 = 0
          END IF
          IF cl_null(l_sum9) THEN
             LET l_sum9 = 0
          END IF
          LET l_sum3 = l_sum7+l_sum8-l_sum9
          LET l_sum7 = 0
          LET l_sum8 = 0
          LET l_sum9 = 0
 
 
          # 出庫明細之內銷合同累計
          SELECT sum(cnk09-cnk10) INTO l_sum7
            FROM cnk_file
           WHERE  cnk02=sr.cob01 AND cnk03=l_py AND cnk04=l_pm
          SELECT sum(coo16) INTO l_sum8
            FROM coo_file
           WHERE coo10 = '0'
             AND coo03 BETWEEN l_bdate and tm.bdate
          SELECT sum(coo16) INTO l_sum9
            FROM coo_file
           WHERE coo10 = '5'
             AND coo03 BETWEEN l_bdate and tm.bdate
          IF cl_null(l_sum7) THEN
             LET l_sum7 = 0
          END IF
          IF cl_null(l_sum8) THEN
             LET l_sum8 = 0
          END IF
          IF cl_null(l_sum9) THEN
             LET l_sum9 = 0
          END IF
          LET l_sum4 = l_sum7+l_sum8-l_sum9
          LET l_sum7 = 0
          LET l_sum8 = 0
          LET l_sum9 = 0
 
 
          # 出庫累計
          LET l_sum5 = l_sum2+l_sum3+l_sum4
 
 
          # 合同結余
          LET l_sum6 = l_sum1-l_sum5
         PRINTX name=S1 COLUMN g_c[31],g_x[24] CLIPPED,
             COLUMN g_c[40],l_sum1 USING '----------&.&&&',
             COLUMN g_c[43],l_sum2 USING '----------&.&&&',
             COLUMN g_c[46],l_sum3 USING '----------&.&&&',
             COLUMN g_c[49],l_sum4 USING '----------&.&&&',
             COLUMN g_c[51],l_sum5 USING '----------&.&&&',
             COLUMN g_c[52],l_sum6 USING '----------&.&&&'
       LET l_cob01_t = sr.cob01
       END IF
 
       # 計算出庫明細各欄位數據
       # 入庫明細
       IF cl_null(sr1.cor12) THEN
          LET sr1.cor12 = 0
       END IF
       LET l_sum1 = l_sum1+sr1.cor12
 
       CASE sr1.coo10
       WHEN '1'                   # 出庫明細-直接出口
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = sr1.coo14
         LET l_cou2 = sr1.coo16
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou2
         LET l_sum2 = l_sum2+l_cou2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
       WHEN '6'
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = -sr1.coo14
         LET l_cou2 = -sr1.coo16
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou2
         LET l_sum2 = l_sum2+l_cou2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
       WHEN '2'                   # 出庫明細-轉廠出口
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = sr1.coo14
         LET l_cou4 = sr1.coo16
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou4
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3+l_cou4
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
       WHEN '7'
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = -sr1.coo14
         LET l_cou4 = -sr1.coo16
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = l_cou4
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3+l_cou4
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
       WHEN '0'                   # 出庫明細-內銷出口
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = sr1.coo14
         LET l_cou6 = sr1.coo16
         LET l_cou7 = l_cou6
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4+l_cou6
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
       WHEN '5'
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = -sr1.coo14
         LET l_cou6 = -sr1.coo16
         LET l_cou7 = l_cou6
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4+l_cou6
         LET l_sum5 = l_sum2+l_sum3+l_sum4
         LET l_sum6 = l_sum1-l_sum5
      OTHERWISE              #入庫
         IF cl_null(sr1.coo14) THEN
            LET sr1.coo14 = 0
         END IF
         IF cl_null(sr1.coo16) THEN
            LET sr1.coo16 = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = ''
         LET l_cou4 = ''
         LET l_cou5 = ''
         LET l_cou6 = ''
         LET l_cou7 = ''
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3
         LET l_sum4 = l_sum4
         LET l_sum5 = l_sum2
         LET l_sum6 = l_sum1-l_sum5
 
      END CASE
 
 
      PRINT COLUMN g_c[31],sr1.cor03 CLIPPED,
            COLUMN g_c[32],sr1.smydesc CLIPPED,
            COLUMN g_c[33],sr1.cor01 CLIPPED,
            COLUMN g_c[34],sr1.coo07 CLIPPED,
            COLUMN g_c[35],sr1.cor15 CLIPPED,
            COLUMN g_c[36],sr1.cor10 CLIPPED,
            COLUMN g_c[37],sr1.cor08 CLIPPED,
            COLUMN g_c[38],sr1.cor09 USING '----------&.&&&',
            COLUMN g_c[39],sr1.cor12 USING '----------&.&&&',
            COLUMN g_c[40],l_sum1 USING '----------&.&&&',
            COLUMN g_c[41],l_cou1 USING '----------&.&&&',
            COLUMN g_c[42],l_cou2 USING '----------&.&&&',
            COLUMN g_c[43],l_sum2 USING '----------&.&&&',
            COLUMN g_c[44],l_cou3 USING '----------&.&&&',
            COLUMN g_c[45],l_cou4 USING '----------&.&&&',
            COLUMN g_c[46],l_sum3 USING '----------&.&&&',
            COLUMN g_c[47],l_cou5 USING '----------&.&&&',
            COLUMN g_c[48],l_cou6 USING '----------&.&&&',
            COLUMN g_c[49],l_sum4 USING '----------&.&&&',
            COLUMN g_c[50],l_cou7 USING '----------&.&&&',
            COLUMN g_c[51],l_sum5 USING '----------&.&&&',
            COLUMN g_c[52],l_sum6 USING '----------&.&&&'
      END IF
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
FUNCTION r208_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_str          STRING       #No.FUN-680069
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
}
#FUN-840238 mark
