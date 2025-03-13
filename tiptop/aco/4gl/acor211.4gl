# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor211.4gl
# Descriptions...: 原材料出入庫供應商明細帳
# Date & Author..: 05/02/02 By wujie
# Modify.........: No.FUN-550036 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-560026 05/06/07 By wujie 增加對日期變量l_date_cnd為空時的判斷
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-840238 08/05/13 By TSD.lucasyeh 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.TQC-930037 09/03/11 By mike 解決溢位問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300) # Where conditiona
              y1      LIKE type_file.dat,          #No.FUN-680069 DATE # bdate
              y2      LIKE type_file.dat,          #No.FUN-680069 DATE # edate
              y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # Convert HS Code
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
           END RECORD
DEFINE   g_i          LIKE type_file.num5          #l_count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_sql        LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(800)
DEFINE   l_wc         LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
DEFINE   l_i          LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   l_table      STRING,    #FUN-840238 add
         g_str        STRING     #FUN-840238 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE tm.* TO NULL
#-----------------No.TQC-610082 modify
  #LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.y1 = ARG_VAL(8)
   LET tm.y2 = ARG_VAL(9)
   LET tm.y  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
  #LET tm.y  = 'N'
#-----------------No.TQC-610082 end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
#---FUN-840238 add ---start
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "cob01.cob_file.cob01,",    #產品編號
               "cob02.cob_file.cob02,",    #產品名稱
               "cob021.cob_file.cob021,",  #產品規格
               "cob04.cob_file.cob04,",    #合同單位
               "cob09.cob_file.cob09,",    #HS.code
               "coc03.coc_file.coc03,",
               "cop05.cop_file.cop05,",
               "cop06.cop_file.cop06,",
               "dt.cop_file.cop03,",       #單據日期
               "dn.smy_file.smydesc,",     #單據名稱
               "dno.cop_file.cop01,",      #單據編號
               "iu.cop_file.cop15,",       #內部單位
               "l_cou1.cop_file.cop14,",   #內部數量
               "l_cou2.cop_file.cop16,",   #合同數量
	       "l_cou3.cnp_file.cnp05,",   #報關進口量
               "l_sum1.cop_file.cop16,",   #進貨合同累計
               "l_sum2.cop_file.cop16,",   #報關累計
               "l_sum3.cop_file.cop16,",   #合同結餘
               "l_sum01.cop_file.cop16,",  #期初進貨合同累計
               "l_sum02.cop_file.cop16,",  #期初報關累計
               "l_sum03.cop_file.cop16"    #期出合同結餘
                                           #21 items
   LET l_table = cl_prt_temptable('acor211',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
  #------------------------------ CR (1) ------------------------------#
#---FUN-840238 add ---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      CALL r211_tm(0,0)
   ELSE
      CALL r211()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION r211_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(1000)
 
   OPEN WINDOW r211_w WITH FORM "aco/42f/acor211"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.y1  = g_today
   LET tm.y2  = g_today
   LET tm.y   = 'N'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON cob09,coc03,cob01,cop05
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
      CLOSE WINDOW r211_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r211_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
 
     INPUT BY NAME tm.y1,tm.y2,tm.y,tm.more
                   WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIElD y1
            IF cl_null(tm.y1) THEN
                NEXT FIELD y1
            END IF
 
      AFTER FIELD y2
            IF cl_null(tm.y2) OR tm.y2 < tm.y1 THEN
                NEXT FIELD y2
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
      CLOSE WINDOW r211_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
 
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='acor211'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor211','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.y1 CLIPPED,"'" ,             #No.TQC-610082 add
                         " '",tm.y2 CLIPPED,"'" ,             #No.TQC-610082 add
                         " '",tm.y CLIPPED,"'" ,              #No.TQC-610082 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acor211',g_time,l_cmd)
      END IF
      CLOSE WINDOW r211_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r211()
   ERROR ""
END WHILE
   CLOSE WINDOW r211_w
END FUNCTION
 
FUNCTION r211()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05,
          l_sliptype LIKE oay_file.oayslip,      #No.FUN-680069 VARCHAR(5) #No.FUN-550036
          l_cnt     LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          sr            RECORD
                               cob01  LIKE cob_file.cob01,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               cob04  LIKE cob_file.cob04,
                               cob09  LIKE cob_file.cob09,   #FUN-840238 add HS CODE
                               coc03  LIKE coc_file.coc03,
                               cop05  LIKE cop_file.cop05,
                               cop06  LIKE cop_file.cop06
                        END RECORD,
          sr1           RECORD
                               bno    LIKE cno_file.cno10,   #手冊編號
                               gno    LIKE cop_file.cop11,   #商品編號
                               vender LIKE cop_file.cop06,   #廠商
                               dt     LIKE cop_file.cop03,   #日期
                               dn     LIKE smy_file.smydesc, #單據名稱
                               dno    LIKE cop_file.cop01,   #單據編號
                               sd     LIKE cob_file.cob02,   #規格明細
                               iu     LIKE cop_file.cop15,   #內部單位
                               inqty  LIKE cop_file.cop14,   #內部數量
                               bn     LIKE cop_file.cop16,   #合同數量
                               icc    LIKE cnp_file.cnp05,   #報關進口量
                               cop10  LIKE cop_file.cop10,   #控制cop14打印
                               cno031 LIKE cno_file.cno031   #控制cnp05打印
                        END RECORD
#FUN-840238 add---START
   DEFINE l_sum1       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #進貨合同累計
          l_sum2       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #報關明細進口累計
          l_sum3       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #合同結余
          l_sum01      LIKE cop_file.cop16,        #期初進貨合同累計
          l_sum02      LIKE cop_file.cop16,        #期初報關明細進口累計
          l_sum03      LIKE cop_file.cop16         #期初合同結余
   DEFINE l_cou1       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #內部數量
          l_cou2       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #合同數量
          l_cou3       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #報關進口量
          l_cob01_t    LIKE cob_file.cob01,
          l_cop05_t    LIKE cop_file.cop05,
          l_bookno_t   LIKE coc_file.coc03,
          l_cob09      LIKE cob_file.cob09,
          l_title      LIKE cob_file.cob08,         #No.FUN-680069 VARCHAR(30)
          l_yy         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_mm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_py         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_pm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_bdate      LIKE type_file.dat,          #No.FUN-680069 DATE
          l_date_cnd   LIKE type_file.num10,        #No.FUN-680069 INTEGER
          l_edate      LIKE type_file.dat           #No.FUN-680069 DATE
 
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
 
#FUN-840238 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-840238 add ###
 
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
    
#TQC-930037 ----start
    #FOR l_i = 1 TO 296
    #    IF l_wc[l_i,l_i+4] = 'cop05' THEN
    #       LET l_wc[l_i,l_i+4] = 'cno08'
    #    END IF
    #END FOR
    LET l_wc=cl_replace_str(l_wc,"cop05","cno08")
#TQC-930037  ----end
 
      LET l_sql = "SELECT DISTINCT cob01,cob02,cob021,cob04,cob09,", #FUN-840238 add cob09
                  "                coc03,cop05,cop06 ",
                   "  FROM cob_file,coe_file,cop_file,coc_file ",
                   " WHERE cob01 = coe03 ",
                   "   AND cob01 = cop11 AND coe01=coc01",
                   "   AND cop18 = coc03 ",
                   "   AND copacti = 'Y'",
                   "   AND copconf = 'Y'",
                   "   AND cobacti = 'Y'",
                   "   AND cocacti = 'Y'",
                   "   AND cop10 IN ('1','2','3','4','5','6')",
                   "   AND cop03 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                   "   AND ", tm.wc CLIPPED,
                   " UNION ",
                   "SELECT DISTINCT cob01,cob02,cob021,cob04,cob09,", #FUN-840238 add cob09
                   "                coc03,cno08,cno09 ",
                   "  FROM cob_file,cnp_file,cno_file,coe_file,coc_file ",
                   " WHERE cob01 = cnp03 ",
                   "   AND cob01 = coe03 AND coe01=coc01",
                   "   AND cno10 = coc03 ",
                   "   AND cnp01 = cno01 ",
                   "   AND cnoacti = 'Y'",
                   "   AND cnoconf = 'Y'",
                   "   AND cobacti = 'Y'",
                   "   AND cocacti = 'Y'",
                   "   AND cno03 = '2' ",
                   "   AND cno031 IN ('1','2','4') ",
                   "   AND cno04 IN ('1','2','3','6') ",
                   "   AND cno02 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                   "   AND ", l_wc CLIPPED
 
     PREPARE r211_pre1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('pre1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE r211_cs1 CURSOR FOR r211_pre1
 
     LET l_sql = "SELECT  cop18,cop11,cop06,cop03,smydesc,cop01,'', ",
                 "        cop15,cop14,cop16,'',cop10,'' ",
                  " FROM cob_file,coe_file,coc_file,cop_file ",
                  " LEFT OUTER JOIN smy_file ON cop01 like ltrim(rtrim(smyslip)) || '-%' ",
                  "WHERE cop11 = ? ",
                  "  AND cop05 = ? ",
                  "  AND cop18 = ? ",
#No.FUN-550036--end
                 "  AND copacti = 'Y'",
                 "  AND copconf = 'Y'",
                 "  AND cobacti = 'Y'",
                 "  AND cocacti = 'Y'",
                 "  AND cop11 = cob01",
                 "  AND cop11 = coe03 AND cob01 = coe03 AND coc01 = coe01",
                 "  AND cop18 = coc03",
                 "  AND cop10 IN ('1','2','3','4','5','6')",
                 "  AND ", tm.wc CLIPPED,
                 "  AND cop03 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                 "ORDER BY cop03"
 
     PREPARE r211_pre2 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('pre2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE r211_cs2 CURSOR FOR r211_pre2
 
     LET l_sql = "SELECT cno10,cnp03,cno09,cno02,smydesc,cno01,'', ",
                  "      cnp06,'','',cnp05,'',cno031 ",
                  " FROM cob_file,cnp_file,coe_file,coc_file,cno_file ",
                  " LEFT OUTER JOIN smy_file ON cno01 like ltrim(rtrim(smyslip)) || '-%' ",
                 "WHERE cnp03 = ? ",
                 "  AND cno08 = ? ",
                 "  AND cno10 = ? ",
#No.FUN-550036--begin
#                "  AND smy_file.smyslip=substr(cno01,1,3)",
#No.FUN-550036--end
                 "  AND cnoacti = 'Y'",
                 "  AND cobacti = 'Y'",
                 "  AND cocacti = 'Y'",
                 "  AND cnoacti = 'Y'",
                 "  AND cnoconf = 'Y'",
                 "  AND cnp03 = cob01",
                 "  AND cob01 = coe03 AND coc01 = coe01",
                 "  AND cno03 = '2'",
                 "  AND cno01 = cnp01",
                 "  AND cno031 IN ('1','2','4') ",
                 "  AND cno04 IN ('1','2','3','6') ",
                 "  AND cno10 = coc03",
                 "  AND ", l_wc CLIPPED,
                 "  AND cno02 BETWEEN '",tm.y1,"' AND '",tm.y2,"' "
 
     PREPARE r211_pre3 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('pre3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE r211_cs3 CURSOR FOR r211_pre3
 
 
 
     DROP TABLE r211_temp
#No.FUN-680069-begin
     CREATE TEMP TABLE r211_temp(
                         bno    LIKE type_file.chr1000,
                         gno    LIKE type_file.chr1000,
                         vender LIKE type_file.chr1000,
                         dt     LIKE type_file.dat,   
                         dn     LIKE type_file.chr1000,
                         dno    LIKE type_file.chr1000,
                         sd     LIKE type_file.chr1000,
                         iu     LIKE qcf_file.qcf062,
                         inqty  LIKE col_file.col09,
                         bn     LIKE col_file.col09,
                         icc    LIKE qcs_file.qcs06,
                         cop10  LIKE type_file.chr1,  
                         cno031 LIKE cno_file.cno031)
#No.FUN-680069-end
#    CALL cl_outnam('acor211') RETURNING l_name #FUN-840238 mark
#    START REPORT r211_rep TO l_name            #FUN-840238 mark
#    LET g_pageno = 0                           #FUN-840238 mark
 
#    DELETE FROM r211_temp
     FOREACH r211_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       DELETE FROM r211_temp    #FUN-840238 add
 
       # 處理進貨明細  CURSOR r211_cs2
       FOREACH r211_cs2 USING sr.cob01,sr.cop05,sr.coc03 INTO sr1.*
          IF SQLCA.sqlcode  THEN
             CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
          END IF
          INSERT INTO r211_temp VALUES(sr1.*)
       END FOREACH
       # 處理報關明細 CURSOR r211_cs3
       FOREACH r211_cs3 USING sr.cob01,sr.cop05,sr.coc03 INTO sr1.*
          IF SQLCA.sqlcode  THEN
             CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
          END IF
          INSERT INTO r211_temp VALUES(sr1.*)
       END FOREACH
 
       LET l_sql = " SELECT * FROM r211_temp " 
 
       PREPARE r211_pre4 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
          EXIT PROGRAM 
       END IF
 
       DECLARE r211_cs4 CURSOR FOR r211_pre4
       FOREACH r211_cs4 INTO sr1.*
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
         END IF
 
       #---FUN-840238 add---START
         IF sr1.bno = sr.coc03 AND sr1.vender = sr.cop06
            AND sr1.gno = sr.cob01    THEN
 
            IF  sr.cob01 != l_cob01_t
                OR sr.coc03 != l_bookno_t
                OR sr.cop05 != l_cop05_t  THEN
 
                LET l_sum1 = 0
                LET l_sum2 = 0
                LET l_sum3 = 0
                LET l_cou1 = 0
                LET l_cou2 = 0
                LET l_cou3 = 0
            END IF
 
           # 計算期初
           IF (sr.cob01 != l_cob01_t OR cl_null(l_cob01_t))
              OR (sr.coc03 != l_bookno_t OR cl_null(l_bookno_t))
              OR (sr.cop05 != l_cop05_t OR cl_null(l_cop05_t))  THEN
 
           # 進貨合同累計和進口累計
              SELECT MAX(cnd03*12+cnd04) INTO l_date_cnd FROM cnd_file
                         WHERE (cnd03*12+cnd04)<=YEAR(tm.y1)*12+MONTH(tm.y1)
                         AND cnd01 = sr.cob01 AND cnd02 = sr.coc03
                         AND cnd05 = '4' AND cnd06 = '2'
                         AND cndacti = 'Y'
                         AND cnd07 = sr.cop05
 
 #No.MOD-560026--end
             LET g_sql = "SELECT cnd12,cnd11 FROM cnd_file ",
                         " WHERE cnd01 = '",sr.cob01,"' AND cnd02 = '",sr.coc03,"'",
                         "   AND cnd05 = '4' AND cnd06 = '2' ",
                         "   AND cnd07 = '",sr.cop05 ,"'",
                         "   AND cndacti = 'Y' ",
                         "   AND cndconf = 'Y' "
             IF l_date_cnd THEN
                LET g_sql = g_sql,"   AND (cnd03*12+cnd04) = ",l_date_cnd
             END IF
 #No.MOD-560026--end
 
             PREPARE r211_xx1 FROM g_sql
             IF SQLCA.sqlcode !=0 THEN
                CALL cl_err('xx1:',SQLCA.sqlcode,1)
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
                EXIT PROGRAM
             END IF
             DECLARE r211_csxx CURSOR FOR r211_xx1
             OPEN r211_csxx
             FETCH r211_csxx INTO l_sum1,l_sum2
             IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
             IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
 
             # 合同累計
             LET l_sum3 = l_sum1 - l_sum2
 
             LET l_cob01_t  = sr.cob01
             LET l_bookno_t = sr.coc03
             LET l_cop05_t  = sr.cop05
 
             LET l_sum01 = l_sum1
             LET l_sum02 = l_sum2
             LET l_sum03 = l_sum3
           END IF
 
          # 計算各欄位明細資料　
          # l_cou1 -- 內部數量 sr1.inqty
          # l_cou2 -- 合同數量 sr1.bn
          # l_cou3 -- 報關進口量 sr1.icc　
          # l_sum1 -- 進貨合同累計
          # l_sum2 -- 報關明細之進口累計
          # l_sum3 -- 合同結余
 
           IF sr1.cop10 MATCHES '[123]' THEN
              IF cl_null(sr1.inqty) THEN
                 LET sr1.inqty = 0
              END IF
              IF cl_null(sr1.bn) THEN
                 LET sr1.bn = 0
              END IF
              LET l_cou1 = sr1.inqty
              LET l_cou2 = sr1.bn
              LET l_cou3 = ''
              LET l_sum1 = l_sum1+l_cou2
              LET l_sum2 = l_sum2
              LET l_sum3 = l_sum3+l_cou2
           END IF
 
           IF sr1.cop10 MATCHES '[456]' THEN
              IF cl_null(sr1.inqty) THEN
                 LET sr1.inqty = 0
              END IF
              IF cl_null(sr1.bn) THEN
                 LET sr1.bn = 0
              END IF
              LET l_cou1 = -sr1.inqty
              LET l_cou2 = -sr1.bn
              LET l_cou3 = ''
              LET l_sum1 = l_sum1+l_cou2
              LET l_sum2 = l_sum2
              LET l_sum3 = l_sum3+l_cou2
           END IF
 
           IF sr1.cno031 = '1' THEN
              IF cl_null(sr1.icc) THEN
                 LET sr1.icc = 0
              END IF
              LET l_cou1 = ''
              LET l_cou2 = ''
              LET l_cou3 = -sr1.icc
              LET l_sum1 = l_sum1
              LET l_sum2 = l_sum2+l_cou3
              LET l_sum3 = l_sum3-l_cou3
           END IF
 
           IF sr1.cno031 MATCHES '[24]' THEN
              IF cl_null(sr1.icc) THEN
                 LET sr1.icc = 0
              END IF
              LET l_cou1 = ''
              LET l_cou2 = ''
              LET l_cou3 = sr1.icc
              LET l_sum1 = l_sum1
              LET l_sum2 = l_sum2+l_cou3
              LET l_sum3 = l_sum3-l_cou3
           END IF
 
           EXECUTE insert_prep USING sr.*,
                                     sr1.dt, sr1.dn, sr1.dno, sr1.iu,
                                     l_cou1, l_cou2, l_cou3,
                                     l_sum1, l_sum2, l_sum3,
                                     l_sum01, l_sum02, l_sum03
 
           IF SQLCA.sqlcode  THEN
              CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
           END IF
         END IF
       #---FUN-840238 add---END
 
#        OUTPUT TO REPORT r211_rep(sr.*,sr1.*)  #FUN-840238 mark
       END FOREACH
     END FOREACH
 
   #FUN-840238  ---start---
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#                " ORDER BY coc03, cob01, cop05"
 
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'zu01')
             RETURNING tm.wc
        LET g_str = tm.wc 
     END IF
     LET g_str = g_str,";",tm.y,";",tm.y1,";",tm.y2
     CALL cl_prt_cs3('acor211','acor211',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
   #FUN-840238  ----end----   
 
#    FINISH REPORT r211_rep                     #FUN-840238 mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)#FUN-840238 mark
END FUNCTION
 
#---FUN-840238 mark---start
{
REPORT r211_rep(sr,sr1)
   DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-680069 VARCHAR(1)
          l_sum1       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #進貨合同累計
          l_sum2       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #報關明細進口累計
          l_sum3       LIKE cop_file.cop16         #No.FUN-680069 DEC(13,2) #合同結余
   DEFINE l_cou1       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #內部數量
          l_cou2       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #合同數量
          l_cou3       LIKE cop_file.cop16,        #No.FUN-680069 DEC(13,2) #報關進口量
          l_cob01_t    LIKE cob_file.cob01,
          l_cop05_t    LIKE cop_file.cop05,
          l_bookno_t   LIKE coc_file.coc03,
          l_cob09      LIKE cob_file.cob09,
          l_title      LIKE cob_file.cob08,         #No.FUN-680069 VARCHAR(30)
          l_yy         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_mm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_py         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_pm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_bdate      LIKE type_file.dat,          #No.FUN-680069 DATE
          l_date_cnd   LIKE type_file.num10,        #No.FUN-680069 INTEGER
          l_edate      LIKE type_file.dat           #No.FUN-680069 DATE
   DEFINE sr            RECORD
                               cob01  LIKE cob_file.cob01,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               cob04  LIKE cob_file.cob04,
                               coc03  LIKE coc_file.coc03,
                               cop05  LIKE cop_file.cop05,
                               cop06  LIKE cop_file.cop06
                        END RECORD,
          sr1           RECORD
                               bno    LIKE cno_file.cno10,   #手冊編號
                               gno    LIKE cop_file.cop11,   #商品編號
                               vender LIKE cop_file.cop06,   #廠商
                               dt     LIKE cop_file.cop03,   #日期
                               dn     LIKE smy_file.smydesc, #單據名稱
                               dno    LIKE cop_file.cop01,   #單據編號
                               sd     LIKE cob_file.cob02,   #規格明細
                               iu     LIKE cop_file.cop15,   #內部單位
                               inqty  LIKE cop_file.cop14,   #內部數量
                               bn     LIKE cop_file.cop16,   #合同數量
                               icc    LIKE cnp_file.cnp05,   #報關進口量
                               cop10  LIKE cop_file.cop10,   #控制cop14打印
                               cno031 LIKE cno_file.cno031   #控制cnp05打印
                        END RECORD
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.coc03 ,sr.cob01,sr.cop05
  FORMAT
   PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
 
            PRINT COLUMN 1,g_x[9] CLIPPED,sr.coc03
            IF tm.y = 'N' THEN
                PRINT COLUMN 1,g_x[10] CLIPPED,sr.cob01 CLIPPED,' ';
            ELSE
                SELECT cob09 INTO l_cob09 FROM cob_file
                 WHERE cob01 = sr.cob01
                PRINT COLUMN 1,g_x[10] CLIPPED,l_cob09 CLIPPED,' ';
            END IF
            PRINT g_x[11],sr.cob02
            PRINT COLUMN 1,g_x[19] CLIPPED,sr.cob021
            PRINT COLUMN 1,g_x[12] CLIPPED,sr.cop05,' ',sr.cop06
            PRINT COLUMN 1,g_x[13] CLIPPED,
                  COLUMN (g_len-30)/2,g_x[14] CLIPPED,tm.y1,'--',tm.y2,
                  COLUMN (g_len-14),g_x[15] CLIPPED,sr.cob04
            PRINT g_dash[1,g_len]
 
      PRINT COLUMN r211_getStartPos(36,38,g_x[16]),g_x[16],
            COLUMN r211_getStartPos(39,40,g_x[17]),g_x[17]
      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+2],
            COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+1]
 
      PRINT g_x[31],g_x[32],g_x[33],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
      PRINT g_dash1
 
         LET l_last_sw ='n'
         LET l_cob01_t = ''
         LET l_cop05_t = ''
         LET l_bookno_t= ''
         LET l_sum1 = 0
         LET l_sum2 = 0
         LET l_sum3 = 0
         LET l_cou1 = 0
         LET l_cou2 = 0
         LET l_cou3 = 0
 
   BEFORE GROUP OF sr.coc03
     IF   sr.cob01 != l_cob01_t
          OR sr.coc03 != l_bookno_t
          OR sr.cop05 != l_cop05_t  THEN
         SKIP TO TOP OF PAGE
     END IF
   BEFORE GROUP OF sr.cob01
     IF   sr.cob01 != l_cob01_t
          OR sr.coc03 != l_bookno_t
          OR sr.cop05 != l_cop05_t  THEN
         SKIP TO TOP OF PAGE
     END IF
   BEFORE GROUP OF sr.cop05
     IF   sr.cob01 != l_cob01_t
          OR sr.coc03 != l_bookno_t
          OR sr.cop05 != l_cop05_t  THEN
         SKIP TO TOP OF PAGE
     END IF
 
   ON EVERY ROW
    IF sr1.bno = sr.coc03 AND sr1.vender = sr.cop06
       AND sr1.gno = sr.cob01    THEN
     # 計算期初
     IF   (sr.cob01 != l_cob01_t OR cl_null(l_cob01_t))
          OR (sr.coc03 != l_bookno_t OR cl_null(l_bookno_t))
          OR (sr.cop05 != l_cop05_t OR cl_null(l_cop05_t))  THEN
 
 
          # 進貨合同累計和進口累計
             SELECT MAX(cnd03*12+cnd04) INTO l_date_cnd FROM cnd_file
                         WHERE (cnd03*12+cnd04)<=YEAR(tm.y1)*12+MONTH(tm.y1)
                         AND cnd01 = sr.cob01 AND cnd02 = sr.coc03
                         AND cnd05 = '4' AND cnd06 = '2'
                         AND cndacti = 'Y'
                         AND cnd07 = sr.cop05
 #No.MOD-560026--begin
       LET g_sql = "SELECT cnd12,cnd11 FROM cnd_file ",
                   " WHERE cnd01 = '",sr.cob01,"' AND cnd02 = '",sr.coc03,"'",
                   "   AND cnd05 = '4' AND cnd06 = '2' ",
                   "   AND cnd07 = '",sr.cop05 ,"'",
                   "   AND cndacti = 'Y' ",
                   "   AND cndconf = 'Y' "
       IF l_date_cnd THEN
       LET g_sql = g_sql,"   AND (cnd03*12+cnd04) = ",l_date_cnd
       END IF
 #No.MOD-560026--end
       PREPARE r211_xx1 FROM g_sql
       IF SQLCA.sqlcode !=0 THEN
           CALL cl_err('xx1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM
       END IF
       DECLARE r211_csxx CURSOR FOR r211_xx1
       OPEN r211_csxx
       FETCH r211_csxx INTO l_sum1,l_sum2
       IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
       IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
 
       # 合同累計
       LET l_sum3 = l_sum1 - l_sum2
 
       PRINTX name=S1 COLUMN g_c[31],g_x[18] CLIPPED,
             COLUMN g_c[38],l_sum1 USING '----------&.&&&',
             COLUMN g_c[40],l_sum2 USING '----------&.&&&',
             COLUMN g_c[41],l_sum3 USING '----------&.&&&'
       LET l_cob01_t  = sr.cob01
       LET l_bookno_t = sr.coc03
       LET l_cop05_t  = sr.cop05
     END IF
 
       # 計算各欄位明細資料　
       # l_cou1 -- 內部數量 sr1.inqty
       # l_cou2 -- 合同數量 sr1.bn
       # l_cou3 -- 報關進口量 sr1.icc　
       # l_sum1 -- 進貨合同累計
       # l_sum2 -- 報關明細之進口累計
       # l_sum3 -- 合同結余
 
      IF sr1.cop10 MATCHES '[123]' THEN
         IF cl_null(sr1.inqty) THEN
            LET sr1.inqty = 0
         END IF
         IF cl_null(sr1.bn) THEN
            LET sr1.bn = 0
         END IF
         LET l_cou1 = sr1.inqty
         LET l_cou2 = sr1.bn
         LET l_cou3 = ''
         LET l_sum1 = l_sum1+l_cou2
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3+l_cou2
      END IF
 
      IF sr1.cop10 MATCHES '[456]' THEN
         IF cl_null(sr1.inqty) THEN
            LET sr1.inqty = 0
         END IF
         IF cl_null(sr1.bn) THEN
            LET sr1.bn = 0
         END IF
         LET l_cou1 = -sr1.inqty
         LET l_cou2 = -sr1.bn
         LET l_cou3 = ''
         LET l_sum1 = l_sum1+l_cou2
         LET l_sum2 = l_sum2
         LET l_sum3 = l_sum3+l_cou2
      END IF
 
      IF sr1.cno031 = '1' THEN
         IF cl_null(sr1.icc) THEN
            LET sr1.icc = 0
         END IF
         LET l_cou1 = ''
         LET l_cou2 = ''
         LET l_cou3 = -sr1.icc
         LET l_sum1 = l_sum1
         LET l_sum2 = l_sum2+l_cou3
         LET l_sum3 = l_sum3-l_cou3
      END IF
 
      IF sr1.cno031 MATCHES '[24]' THEN
           IF cl_null(sr1.icc) THEN
              LET sr1.icc = 0
           END IF
           LET l_cou1 = ''
           LET l_cou2 = ''
           LET l_cou3 = sr1.icc
           LET l_sum1 = l_sum1
           LET l_sum2 = l_sum2+l_cou3
           LET l_sum3 = l_sum3-l_cou3
      END IF
 
 
      PRINT COLUMN g_c[31],sr1.dt ,
            COLUMN g_c[32],sr1.dn ,
            COLUMN g_c[33],sr1.dno,
            COLUMN g_c[35],sr1.iu,
            COLUMN g_c[36],l_cou1 USING '----------&.&&&',
            COLUMN g_c[37],l_cou2 USING '----------&.&&&',
            COLUMN g_c[38],l_sum1 USING '----------&.&&&',
            COLUMN g_c[39],l_cou3 USING '----------&.&&&',
            COLUMN g_c[40],l_sum2 USING '----------&.&&&',
            COLUMN g_c[41],l_sum3 USING '----------&.&&&'
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
FUNCTION r211_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_str        STRING       #No.FUN-680069
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
#No.FUN-870144
#---FUN-840238 mark---end
