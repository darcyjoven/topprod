# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almp430.4gl
# Descriptions...: 合同帳單整批生成作業
# Date & Author..: 08/08/19 By Carrier
# Modify.........: No.FUN-960134 09/10/11 By shiwuying 移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A70130 10/08/09 By huangtao 加入欄位費用單別g_slip
# Modify.........: No:FUN-A80105 10/08/26 By huangtao 程式產生費用單時,改為依畫面指定費用單別取號 
# Modify.........: No:FUN-A80105 10/09/20 By lixh1 
# Modify.........: No.FUN-AA0006 10/10/13 BY vealxu 重新規劃 lnt_file、lnu_file 資料檔, 檔案類別由原 B類(基本資料檔) 改成 T類(交易檔). 並在 lnt_file、lnu_file 加 PlantCode 欄位
# Modify.........: No.FUN-AA0046 10/10/22 By huangtao 修改單別檢驗的合理性
# Modify.........: No.FUN-AA0057 10/11/24 By lixh1    在CONSTRUCT前加判斷   
# Modify.........: No.FUN-AC0062 10/12/22 By lixh1 因lua05欄位no use,故mark掉lua05的所有邏輯
# Modify.........: No.TQC-B10038 11/01/07 By shenyang
# Modify.........: No.TQC-B10037 11/01/10 By shenyang 
# Modify.........: No.MOD-B30300 11/03/12 By huangtao 隱藏結算商戶欄位
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm              RECORD
                       wc          LIKE type_file.chr1000,
                       year        LIKE type_file.num5,
                       month       LIKE type_file.num5,
                       g_slip      LIKE rye_file.rye03,               #FUN-A70130
                       dd          LIKE type_file.dat,
                       a           LIKE type_file.chr1
                       END RECORD
DEFINE start_no        LIKE lua_file.lua01
DEFINE end_no          LIKE lua_file.lua01 
DEFINE g_chr           LIKE type_file.chr1
DEFINE g_change_lang   LIKE type_file.chr1
 
DEFINE g_sql           LIKE type_file.chr1000
DEFINE g_cnt           LIKE type_file.num5
DEFINE g_arr           DYNAMIC ARRAY OF RECORD
                       year    LIKE type_file.num5,
                       month   LIKE type_file.num5,
                       days    LIKE type_file.num5,
                       bdate   LIKE type_file.dat,
                       edate   LIKE type_file.dat,
                       amount  LIKE abb_file.abb07
                       END RECORD
DEFINE l_ac            LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num10
DEFINE g_lnv           DYNAMIC ARRAY OF RECORD
                       lnt01   LIKE lnt_file.lnt01,
                       lnv04   LIKE lnv_file.lnv04,
                       oaj02   LIKE oaj_file.oaj02,
                       t_sum   LIKE lnv_file.lnv07,
                       s_sum   LIKE lnv_file.lnv07,
                       a_sum   LIKE lnv_file.lnv07,
                       n_sum   LIKE lnv_file.lnv07,
                       ad_sum  LIKE lnv_file.lnv07 
                       END RECORD
 
MAIN
   OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT
 
   LET tm.wc      = ARG_VAL(1)
   LET tm.year    = ARG_VAL(2)
   LET tm.month   = ARG_VAL(3)
 #dongbg modify
 # LET tm.dd      = ARG_VAL(5)
 #  LET tm.dd      = ARG_VAL(4)                    #FUN-A70130    #FUN-AA0046 mark
 #End
 #  LET tm.a       = ARG_VAL(5)                    #FUN-A70130    #FUN-AA0046 mark
 #  LET g_bgjob    = ARG_VAL(6)                    #FUN-A70130    #FUN-AA0046 mark
#FUN-AA0046 --------start
   LET tm.g_slip  = ARG_VAL(4)                    
   LET tm.dd      = ARG_VAL(5)
   LET tm.a       = ARG_VAL(6)
   LET g_bgjob    = ARG_VAL(7)
#FUN-AA0046 --------end
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   #dongbg add

   LET tm.wc= cl_replace_str(tm.wc,"\\\"","'")  #dongbg add
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00 = '0'  #dongbg add
   IF (SQLCA.SQLCODE) THEN
      INSERT INTO ooz_file(ooz00) VALUES('0')
      CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
      EXIT PROGRAM 
   END IF
   #End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   DROP TABLE p430_tmp;
   CREATE TEMP TABLE p430_tmp(
      lnt01    LIKE lnt_file.lnt01,   #合同
      lnt02    LIKE lnt_file.lnt02,   #合同版本
      lnt15    LIKE lnt_file.lnt15,   #付款方式
      oaj05    LIKE oaj_file.oaj05,   #費用類型
      lnv04    LIKE lnv_file.lnv04,   #費用代號
      c_year   LIKE type_file.num5,   #當前年
      c_month  LIKE type_file.num5,   #當前期
      l_year   LIKE type_file.num5,   #年
      l_month  LIKE type_file.num5,   #月
      amount   LIKE lnv_file.lnv07);  #金額

   IF g_bgjob = 'Y' THEN
      LET g_success='Y'
      CALL s_showmsg_init()
      CALL p430_process()
      CALL s_showmsg()
      CALL p430_b()
 
      CALL p430_process1()
      IF g_success = 'Y' THEN
         COMMIT WORK
      #dongbg add
         CALL p430_voucher()
      #End
      ELSE
         ROLLBACK WORK
      END IF
   ELSE
      OPEN WINDOW p430_w WITH FORM "alm/42f/almp430"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      CALL cl_set_comp_visible("lnt12",FALSE)            #MOD-B30300 add
#FUN-A80105 --Begin--
   IF NOT cl_null(tm.wc) THEN
      CALL cl_set_comp_visible("group01",FALSE)  
      CALL cl_set_comp_visible("g_bgjob",FALSE)
   END IF
   IF NOT cl_null(tm.year) THEN
      DISPLAY tm.year TO year
   END IF
   IF NOT cl_null(tm.month) THEN
      DISPLAY tm.month TO month
   END IF
   IF NOT cl_null(tm.dd) THEN
      DISPLAY tm.dd TO dd
   END IF 
#FUN-A80105 --End--      
      CALL cl_set_comp_visible("a",FALSE)
      CALL p430()
      CLOSE WINDOW p430_w
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p430()
   DEFINE lc_cmd     LIKE type_file.chr1000
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_n1      LIKE type_file.num5
   DEFINE li_result LIKE type_file.num5   
   IF cl_null(tm.wc) THEN         #TQC-B10037
     INITIALIZE tm.* TO NULL
   END IF                         #TQC-B10037
   WHILE TRUE
      LET INT_FLAG=0
      LET g_change_lang = FALSE
 
      LET start_no = NULL
      LET end_no   = NULL
      DISPLAY BY NAME start_no,end_no
   IF cl_null(tm.wc) THEN        #FUN-AA0057  By lixh1
      CONSTRUCT BY NAME tm.wc ON lnt01,lnt03,lnt04,lnt12
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lnt01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lnt01_1"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060       #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt01
                  NEXT FIELD lnt01
               WHEN INFIELD(lnt04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lnt04"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060      #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt04
                  NEXT FIELD lnt04
               WHEN INFIELD(lnt12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lnt12"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060       #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt12
                  NEXT FIELD lnt12
               OTHERWISE EXIT CASE
            END CASE
         ON ACTION locale
            LET g_change_lang = TRUE         #No.FUN-570145
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
   END IF           #FUN-AA0057 By lixh1
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('lntuser', 'lntgrup') #FUN-980030
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW almp430_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      SELECT rye03 INTO tm.g_slip FROM rye_file WHERE rye01='art' AND rye02 ='B9'   #FUN-A70130 add  
      LET tm.a = 'Y'
      LET tm.year = YEAR(g_today)
      LET tm.month= MONTH(g_today)
      LET tm.dd = g_today
      LET g_bgjob = 'N'
      DISPLAY BY NAME tm.a,tm.year,tm.month,tm.g_slip,tm.dd,g_bgjob      #FUN-A70130 
 
      INPUT BY NAME tm.year,tm.month,tm.g_slip,tm.dd,tm.a,g_bgjob WITHOUT DEFAULTS   #FUN-A70130 
         AFTER FIELD year
            IF tm.year <= 0 THEN NEXT FIELD year END IF
 
         AFTER FIELD month
            IF tm.month < 1 OR tm.month > 12 THEN
               NEXT FIELD month
            END IF
#FUN-A70130  add ------------------start--------------------------
        AFTER FIELD g_slip
            #FUN-AA0046 ----------------start -------------------
            # SELECT COUNT(*) INTO  l_n1 FROM oay_file
            # WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = tm.g_slip
            # IF l_n1 = 0 THEN 
            # CALL cl_err(tm.g_slip,'art-800',0)
            # NEXT FIELD g_slip
            # END IF
              CALL  s_check_no("art",tm.g_slip,"","B9","oay_file","oayslip","") RETURNING li_result,tm.g_slip
              IF NOT li_result THEN
                 CALL cl_err(tm.g_slip,'art-800',0)
                 NEXT FIELD g_slip
              END IF
            #FUN-AA0046 ---------------end ----------------------
#FUN-A70130 add ---------------------end-------------------------- 
         AFTER FIELD dd
            IF NOT cl_null(tm.dd) AND NOT cl_null(tm.year) THEN
               IF YEAR(tm.dd) <> tm.year THEN
                  CALL cl_err(tm.dd,'alm-380',0)
                  NEXT FIELD dd
               END IF
            END IF
            IF NOT cl_null(tm.dd) AND NOT cl_null(tm.month) THEN
               IF MONTH(tm.dd) <> tm.month THEN
                  CALL cl_err(tm.dd,'alm-381',0)
                  NEXT FIELD dd
               END IF
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#FUN-A70130 add --------------------------start------------------------ 
         ON ACTION CONTROLP
             CASE
               WHEN INFIELD(g_slip)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_slip"
                  LET g_qryparam.default1 = tm.g_slip
                  CALL cl_create_qry() RETURNING tm.g_slip
                  DISPLAY BY NAME tm.g_slip
                  NEXT FIELD g_slip
               OTHERWISE EXIT CASE
            END CASE
 #FUN-A70130 add ---------------------------end --------------------------   
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_change_lang = TRUE
            EXIT INPUT
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW almp430_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
#FUN-AA0046 --------start
         IF cl_null(tm.g_slip) THEN
            SELECT rye03 INTO tm.g_slip FROM rye_file WHERE rye01='art' AND rye02 ='B9'
         END IF
#FUN-AA0046 --------end
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "almp430"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('almp430','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "\"", "'")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.year CLIPPED,"'",              #FUN-AA0046
                         " '",tm.month CLIPPED,"'",             #FUN-AA0046
                         " '",tm.g_slip CLIPPED,"'",            #FUN-AA0046           
                         " '",tm.a  CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('almp430',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW almp430_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      LET g_success='Y'
      CALL s_showmsg_init()
      CALL p430_process()
      CALL s_showmsg()
      CALL p430_b()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CONTINUE WHILE
      END IF
 
      IF cl_sure(0,0) THEN
         CALL p430_process1()
         DISPLAY BY NAME start_no,end_no
         IF g_success = 'Y' THEN
            COMMIT WORK
      #dongbg add
            CALL p430_voucher()
      #End
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            DISPLAY '' TO FORMONLY.start_no                #FUN-A80105
            DISPLAY '' TO FORMONLY.end_no                  #FUN-A80105
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION p430_process()
   DEFINE l_lnt01      LIKE lnt_file.lnt01
   DEFINE l_bdate      LIKE type_file.dat
   DEFINE l_edate      LIKE type_file.dat
 
   DELETE FROM p430_tmp;
   CALL s_azn01(tm.year,tm.month) RETURNING l_bdate,l_edate
   
   LET g_sql = "SELECT lnt01 FROM lnt_file ",
               " WHERE (lnt26 = 'Y' OR lnt26 = 'E') ",
               "   AND lntplant = '",g_plant,"'",                       #FUN-AA0006 mod lntstore -> lntplant
               #計租期間要與計算的日期範圍有交集
               "   AND NOT (lnt21 > '",l_edate,"' OR lnt22 < '",l_bdate,"')",
               "   AND ",tm.wc CLIPPED
   PREPARE p430_p1 FROM g_sql
   DECLARE p430_cs1 CURSOR FOR p430_p1
   
   FOREACH p430_cs1 INTO l_lnt01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach p430_cs1',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      CALL p430_lnt(l_lnt01)
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH
 
END FUNCTION
 
FUNCTION p430_lnt(p_lnt01)
   DEFINE p_lnt01     LIKE lnt_file.lnt01
   DEFINE l_lnt       RECORD LIKE lnt_file.*
   DEFINE l_lnv       RECORD 
                      type   LIKE type_file.chr1,
                      lnv04  LIKE lnv_file.lnv04,
                      lnv05  LIKE lnv_file.lnv05,
                      lnv06  LIKE lnv_file.lnv06,
                      lnv11  LIKE lnv_file.lnv11,
                      lnv12  LIKE lnv_file.lnv12,
                      lnv13  LIKE lnv_file.lnv13,
                      lnv15  LIKE lnv_file.lnv15,
                      lnv16  LIKE lnv_file.lnv16,
                      lnv17  LIKE lnv_file.lnv17
                      END RECORD
   DEFINE l_fare      LIKE abb_file.abb07
   DEFINE l_fare1     LIKE abb_file.abb07
   DEFINE l_fare2     LIKE abb_file.abb07
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_j         LIKE type_file.num5
   DEFINE l_k         LIKE type_file.num5
   DEFINE l_l         LIKE type_file.num5
   DEFINE l_lnr03     LIKE lnr_file.lnr03
   DEFINE l_lnl09     LIKE lnl_file.lnl09
   DEFINE l_lnl10     LIKE lnl_file.lnl10
   DEFINE l_oaj05     LIKE oaj_file.oaj05
   DEFINE l_year      LIKE type_file.num5
   DEFINE l_month     LIKE type_file.num5
   DEFINE l_year1     LIKE type_file.num5
   DEFINE l_year2     LIKE type_file.num5
   DEFINE l_month1    LIKE type_file.num5
   DEFINE l_month2    LIKE type_file.num5
   DEFINE l_date1     LIKE type_file.dat
   DEFINE c_year1     LIKE type_file.num5
   DEFINE c_year2     LIKE type_file.num5
   DEFINE c_month1    LIKE type_file.num5
   DEFINE c_month2    LIKE type_file.num5
   DEFINE e_year1     LIKE type_file.num5  #生效
   DEFINE e_year2     LIKE type_file.num5  #失效
   DEFINE e_month1    LIKE type_file.num5  #生效
   DEFINE e_month2    LIKE type_file.num5  #失效
   DEFINE e_day2      LIKE type_file.num5  #失效
   DEFINE l_bdate     LIKE type_file.dat
   DEFINE l_edate     LIKE type_file.dat
   DEFINE l_index     LIKE type_file.num5
   DEFINE l_index1    LIKE type_file.num5
   DEFINE l_index2    LIKE type_file.num5
   DEFINE l_lnx       RECORD LIKE lnx_file.*
   DEFINE l_pre_flag  LIKE type_file.chr1
   DEFINE l_pre_rate  LIKE abb_file.abb25
   DEFINE l_pre_mons  LIKE lnx_file.lnx05
   DEFINE l_ii        LIKE type_file.num5  #No.FUN-9B0136
   DEFINE l_days1     LIKE type_file.num5  #No.FUN-9B0136
   
   SELECT * INTO l_lnt.* FROM lnt_file WHERE lnt01 = p_lnt01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lnt01',p_lnt01,'step 1',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL g_arr.clear()
   LET l_year1  = YEAR(l_lnt.lnt21)
   LET l_month1 = MONTH(l_lnt.lnt21)
   LET l_year2  = YEAR(l_lnt.lnt22)
   LET l_month2 = MONTH(l_lnt.lnt22)
   LET g_cnt = l_year2 * 12 + l_month2 - l_year1 * 12 - l_month1 + 1
   
   CALL p430_pay(l_lnt.lnt15,l_year1,l_month1,l_year2,l_month2)
        RETURNING c_year2,c_month2
 
   ##array中當前的行數 index1~index2(4~6)
   #LET l_index1 = c_year1 * 12 + c_month1 - (l_year1 * 12 + l_month1) + 1
   #LET l_index2 = c_year2 * 12 + c_month2 - (l_year1 * 12 + l_month1) + 1
 
   #組出每個月的array:2008/1  2008/2 .... 2009/12
   LET l_j = l_year1 * 12 + l_month1
   LET l_k = l_year2 * 12 + l_month2  #不能用c_year2/c_month2來替代,因為后面要算總金額
   LET l_l = 1
   FOR l_i = l_j TO l_k
       LET g_arr[l_l].year  = l_i / 12 
       LET g_arr[l_l].month = l_i MOD 12
       IF g_arr[l_l].month = 0 THEN
          LET g_arr[l_l].year = g_arr[l_l].year - 1
          LET g_arr[l_l].month = 12
       END IF
       #每月的天數,為了不足月時,計算金額
       LET l_date1 = MDY(g_arr[l_l].month,1,g_arr[l_l].year)
       CALL s_months(l_date1) RETURNING g_arr[l_l].days
       IF cl_null(g_arr[l_l].days) THEN LET g_arr[l_l].days = 1 END IF
 
       LET g_arr[l_l].amount = 0
       LET l_l = l_l + 1
   END FOR
 
   #每個費用項目/計租期間的費用計算(BY每月)
   DECLARE p430_lnv_cs CURSOR FOR
    SELECT '1',lnv04,lnv05,lnv06,lnv11,lnv12,lnv13,lnv15,lnv16,lnv17
      FROM lnv_file
     WHERE lnv01 = p_lnt01
#      AND lnv16 <= tm.dd #AND (lnv17 > tm.dd OR lnv17 IS NULL)  #生效/失效範圍
     UNION
    SELECT '2',lnw03,'','',lnw06,0,lnw07,lnw10,lnw08,lnw09
      FROM lnw_file
     WHERE lnw01 = p_lnt01
#      AND lnw08 <= tm.dd #AND (lnw09 > tm.dd OR lnw09 IS NULL)  #生效/失效範圍
   FOREACH p430_lnv_cs INTO l_lnv.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p430_lnv_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #費用編號
      IF cl_null(l_lnv.lnv04) THEN RETURN END IF
 
      #生效日期/失效日期 範圍大于 計租起訖,則按計租起訖算
      IF l_lnv.lnv16 < l_lnt.lnt21 THEN
         LET l_lnv.lnv16 = l_lnt.lnt21
      END IF
      IF l_lnv.lnv17 > l_lnt.lnt22 THEN
         LET l_lnv.lnv17 = l_lnt.lnt22
      END IF
 
      #生效/失效年/月
      LET e_year1  = YEAR(l_lnv.lnv16)
      LET e_month1 = MONTH(l_lnv.lnv16)
      LET e_year2  = YEAR(l_lnv.lnv17)
      LET e_month2 = MONTH(l_lnv.lnv17)
      IF cl_null(l_lnv.lnv17) THEN  #carrier 08/11/13
         LET e_year2  = YEAR(l_lnt.lnt22)
         LET e_month2 = MONTH(l_lnt.lnt22)
      END IF
 
      #費用類型 01.定金 02.租金/收入...
      SELECT oaj05 INTO l_oaj05 FROM oaj_file WHERE oaj01 = l_lnv.lnv04
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oaj01',l_lnv.lnv04,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
 
      #費用設置
      IF l_lnv.type = '1' THEN
         SELECT lnl09,lnl10 INTO l_lnl09,l_lnl10 FROM lnl_file
          WHERE lnl01    = l_lnv.lnv04
            AND lnlstore = l_lnt.lntplant             #FUN-AA0006 mod lntstore -> lntplant
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('lnl01',l_lnv.lnv04,'',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      ELSE
         LET l_lnl09 = '1'
         LET l_lnl10 = '3' 
      END IF
 
      FOR l_i = 1 TO g_cnt
          #每月的起始日期/截止日期 此處的日期都是足月的狀況,1~足月天數(ex:1月1~31)
          LET g_arr[l_i].bdate = MDY(g_arr[l_i].month,1,g_arr[l_i].year)
          LET g_arr[l_i].edate = MDY(g_arr[l_i].month,g_arr[l_i].days,g_arr[l_i].year)
          LET g_arr[l_i].amount = 0
      END FOR
 
      LET l_fare = 0  #費用標准
      LET l_fare = l_lnv.lnv11
      LET l_fare2= l_lnv.lnv12
      LET l_fare1=l_fare
      #若為年費用,則先換算成月標准  若為"月銷售額"則不需要/12,月銷售額就是月的概念
      IF NOT cl_null(l_lnv.lnv05) AND cl_null(l_lnv.lnv06) AND l_lnl10 <> '1' THEN
         LET l_fare = l_fare / 12
         LET l_fare2= l_fare2/ 12
      END IF
      IF cl_null(l_fare) THEN LET l_fare = 0 END IF
 
      #優惠
      LET l_pre_flag = 'N'  #優惠標識
      LET l_pre_mons = 0    #優惠月數
      LET l_pre_rate = 1    #優惠比率
      SELECT * INTO l_lnx.* FROM lnx_file
       WHERE lnx01 = p_lnt01
         AND lnx03 = l_lnv.lnv04
      IF SQLCA.sqlcode = 0 THEN
         LET l_pre_flag = 'Y'
         LET l_pre_mons = l_lnx.lnx05
         IF cl_null(l_lnx.lnx04) OR l_lnx.lnx04 = 0 THEN
            LET l_lnx.lnx04 = 100
         END IF
         IF cl_null(l_lnx.lnx10) OR l_lnx.lnx10 = 0 THEN
            LET l_lnx.lnx10 = 100
         END IF
         IF cl_null(l_lnx.lnx101) OR l_lnx.lnx101 = 0 THEN
            LET l_lnx.lnx101 = 100
         END IF
         IF cl_null(l_lnx.lnx102) OR l_lnx.lnx102 = 0 THEN
            LET l_lnx.lnx102 = 100
         END IF
         #最終優惠比率
      #No.FUN-9B0136 BEGIN -----
      #  LET l_pre_rate = l_lnx.lnx04 * l_lnx.lnx10 * l_lnx.lnx101 * l_lnx.lnx102 /100/100/100/100
         LET l_pre_rate = l_lnx.lnx04 * (l_lnx.lnx10 + l_lnx.lnx101 + l_lnx.lnx102)/100/100
      #No.FUN-9B0136 END -------
      END IF
 
      FOR l_i = 1 TO g_cnt  #每個月填金額
          #還沒有生效的月份,不需要填金額
          IF g_arr[l_i].year*12 + g_arr[l_i].month < e_year1*12 + e_month1 THEN
             CONTINUE FOR
          END IF
          #已經失效的月份,不需要填金額
          IF g_arr[l_i].year*12 + g_arr[l_i].month > e_year2*12 + e_month2 THEN
             EXIT FOR
          END IF
 
          #不足月時,會用 實際天數 * 月標准 /足月天數  #08/11/13
          IF cl_null(l_lnv.lnv05) AND cl_null(l_lnv.lnv06) AND l_lnv.lnv13 = '0' THEN
          ELSE
             #生效日期
             IF g_arr[l_i].year = e_year1 AND g_arr[l_i].month = e_month1 THEN
                LET g_arr[l_i].bdate = l_lnv.lnv16
             END IF
             #失效日期
             IF g_arr[l_i].year = e_year2 AND g_arr[l_i].month = e_month2 THEN
                LET g_arr[l_i].edate = l_lnv.lnv17
             END IF
          END IF
 
          CASE l_lnl10
               WHEN '0'
                   LET l_fare1 = l_fare1 * (g_arr[l_i].edate-g_arr[l_i].bdate+1)/g_arr[l_i].days
               WHEN '1'    #月銷售額
                   #carrier test
                   #IF g_arr[l_i].year = YEAR(tm.dd)  AND 
                   #   g_arr[l_i].month= MONTH(tm.dd) THEN
                   #   LET l_edate = tm.dd
                   #END IF
                   #CALL p430_sales(l_bdate,l_edate,l_lnt.lnt06) RETURNING l_fare1
                   CALL p430_sales(g_arr[l_i].bdate,g_arr[l_i].edate,l_lnt.lnt06) RETURNING l_fare1
                   #LET l_fare1 = 350000
                   LET l_fare1 = l_fare1 * l_lnv.lnv11 / 100
               WHEN '2'   #按有效面積
                   LET l_fare1 = l_fare * l_lnt.lnt11 * (g_arr[l_i].edate-g_arr[l_i].bdate+1)/g_arr[l_i].days
               WHEN '3'   #所填金額
                   LET l_fare1 = l_fare * (g_arr[l_i].edate-g_arr[l_i].bdate+1)/g_arr[l_i].days
          END CASE
          IF l_pre_flag = 'Y' THEN
             LET l_fare1 = l_fare1 * l_pre_rate
          END IF 
          #小于保底金額
          IF l_fare1 < l_fare2 THEN
             LET l_fare1 = l_fare2
          END IF
 
          #1.無年/無月
          IF cl_null(l_lnv.lnv05) AND cl_null(l_lnv.lnv06) THEN
            #IF l_lnv.lnv13 = '0' AND l_i = 1 THEN  #一次性收取
             IF l_lnv.lnv13 = '0' AND g_arr[l_i].year = e_year1
                                  AND g_arr[l_i].month= e_month1 THEN  #一次性收取
                LET g_arr[l_i].amount = l_fare1
                EXIT FOR
             END IF
             IF l_lnv.lnv13 = '1' THEN
                LET g_arr[l_i].amount = l_fare1
             END IF
          END IF
 
          #2.有月無年
          IF cl_null(l_lnv.lnv05) AND NOT cl_null(l_lnv.lnv06) THEN
             IF g_arr[l_i].month = l_lnv.lnv06 THEN
                LET g_arr[l_i].amount = l_fare1
             END IF
          END IF
 
          #3.有年無月
          IF NOT cl_null(l_lnv.lnv05) AND cl_null(l_lnv.lnv06) THEN
             IF g_arr[l_i].year = l_lnv.lnv05 THEN
                LET g_arr[l_i].amount = l_fare1
             END IF
          END IF
 
          #4.有年/有月 - 在該年的該月計算金額
          IF NOT cl_null(l_lnv.lnv05) AND NOT cl_null(l_lnv.lnv06) THEN
             IF g_arr[l_i].year = l_lnv.lnv05 AND g_arr[l_i].month = l_lnv.lnv06 THEN
                LET g_arr[l_i].amount = l_fare1
             END IF
          END IF
      END FOR
 
      IF l_lnv.lnv15 = '0' THEN   #權責發生制
         LET l_year = tm.year
         LET l_month = tm.month
      ELSE
         LET l_year = c_year2
         LET l_month = c_month2
      END IF
      IF l_lnv.lnv13 = '0' THEN  #carrier 08/11/13
         LET l_year = e_year2
         LET l_month = e_month2
      END IF
      FOR l_i = 1 TO g_cnt
         #No.FUN-9C0136 BEGIN -----
         #IF l_pre_flag = 'Y' THEN
         #   #IF l_i <= l_pre_mons THEN   #減免幾個月
         #   IF g_arr[l_i].year * 12 + g_arr[l_i].month - 
         #      e_year1 * 12 - e_month1 < l_pre_mons THEN
         #      CONTINUE FOR
         #   END IF
         #END IF
          IF l_pre_flag = 'Y' THEN
             IF (cl_null(l_lnv.lnv05) AND cl_null(l_lnv.lnv06)) THEN
                #如果是一次收取,應減去優惠月對應的金額
                LET l_days1 = 0
                FOR l_ii = 1 TO l_pre_mons
                    LET l_days1 = l_days1 + g_arr[l_ii].days
                END FOR
                IF cl_null(l_lnv.lnv05) AND cl_null(l_lnv.lnv06) THEN
                   LET g_arr[l_i].amount = g_arr[l_i].amount -
                       l_days1*g_arr[l_i].amount/(l_lnt.lnt22 - l_lnt.lnt21)
                END IF
             ELSE
                IF g_arr[l_i].year * 12 + g_arr[l_i].month -
                   e_year1 * 12 - e_month1 < l_pre_mons THEN
                   CONTINUE FOR 
                END IF
             END IF
          END IF
         #No.FUN-9C0136 END ------
          INSERT INTO p430_tmp VALUES(p_lnt01,l_lnt.lnt02,l_lnt.lnt15,
                                      l_oaj05,l_lnv.lnv04,
                                      l_year,l_month,g_arr[l_i].year,
                                      g_arr[l_i].month,g_arr[l_i].amount);
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('lnv01',p_lnt01,'',SQLCA.sqlcode,1)
             LET g_success = 'N'
             CONTINUE FOR
          END IF
      END FOR
   END FOREACH
   ##其他費用
   #CALL p430_lnw(p_lnt01,l_lnt.lnt02,l_year1,l_month1,l_year2,l_month2)
END FUNCTION
 
#FUNCTION p430_lnw(p_lnt01,p_lnt02,p_year1,p_month1,p_year2,p_month2)
#   DEFINE p_lnt01     LIKE lnt_file.lnt01
#   DEFINE p_lnt02     LIKE lnt_file.lnt02
#   DEFINE p_year1     LIKE type_file.num5
#   DEFINE p_year2     LIKE type_file.num5
#   DEFINE p_month1    LIKE type_file.num5
#   DEFINE p_month2    LIKE type_file.num5
#   DEFINE l_lnw       RECORD LIKE lnw_file.*
#   DEFINE c_year2     LIKE type_file.num5
#   DEFINE c_month2    LIKE type_file.num5
#   DEFINE l_oaj05     LIKE oaj_file.oaj05
#
#   DECLARE p430_lnw_cs CURSOR FOR
#    SELECT * FROM lnw_file
#     WHERE lnw01 = p_lnt01
#   FOREACH p430_lnw_cs INTO l_lnw.*
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('','','p430_lnw_cs',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
#      CALL p430_pay(l_lnw.lnw07,p_year1,p_month1,p_year2,p_month2)
#           RETURNING c_year2,c_month2
#
#      #費用類型 01.定金 02.租金/收入...
#      SELECT oaj05 INTO l_oaj05 FROM oaj_file 
#       WHERE oaj01 = l_lnw.lnw03
#      IF SQLCA.sqlcode OR cl_null(l_oaj05) THEN
#         CALL s_errmsg('oaj01',l_lnw.lnw03,'',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#      END IF
#
#      #一次性收取
#      INSERT INTO p430_tmp VALUES(p_lnt01,p_lnt02,l_lnw.lnw07,
#                                  l_oaj05,l_lnw.lnw03,
#                                  c_year2,c_month2,p_year1,
#                                  p_month1,l_lnw.lnw06);
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('lnw01',l_lnw.lnw01,'',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#      END IF
#   END FOREACH
#
#END FUNCTION
 
FUNCTION p430_sales(p_bdate,p_edate,p_lsa02)
   DEFINE p_bdate   LIKE type_file.dat
   DEFINE p_edate   LIKE type_file.dat
   DEFINE p_lsa02   LIKE lsa_file.lsa02
   DEFINE l_sum1    LIKE lsa_file.lsa11
   DEFINE l_sum2    LIKE lsa_file.lsa11
   DEFINE l_sum3    LIKE lsa_file.lsa11
 
   #收款
   SELECT SUM(lsa11) INTO l_sum1 FROM lsa_file
    WHERE lsa01 BETWEEN p_bdate AND p_edate
      AND lsa02 = p_lsa02
      AND lsa12 = '1'
   IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
 
   ##退款
   #SELECT SUM(lsa11) INTO l_sum2 FROM lsa_file
   # WHERE lsa01 BETWEEN p_bdate AND p_edate
   #   AND lsa02 = p_lsa02
   #   AND lsa12 = '2'
   #IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
 
   RETURN l_sum1   #BY佳彥 銷退金額不算
 
END FUNCTION
 
FUNCTION p430_b()
   DEFINE p_flag      LIKE type_file.chr1
   DEFINE l_n         LIKE type_file.num5
   DEFINE ta_sum      LIKE lub_file.lub04
   DEFINE l_lnt37     LIKE lnt_file.lnt37
 
   DECLARE p430_lnv_curs CURSOR FOR
    SELECT UNIQUE lnt01,lnv04,oaj02,0,0,0,0,0
      FROM p430_tmp LEFT OUTER JOIN oaj_file
                    ON lnv04 = oaj01
     ORDER BY lnt01,lnv04
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare p430_lnv_curs',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL g_lnv.clear()
   LET g_cnt = 1
   FOREACH p430_lnv_curs INTO g_lnv[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach p430_lnv_curs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #總金額
      SELECT SUM(amount) INTO g_lnv[g_cnt].t_sum
        FROM p430_tmp
       WHERE lnt01 = g_lnv[g_cnt].lnt01
         AND lnv04 = g_lnv[g_cnt].lnv04
      IF SQLCA.sqlcode THEN  
         CALL cl_err3('sel','p430_tmp',g_lnv[g_cnt].lnt01,g_lnv[g_cnt].lnv04,SQLCA.sqlcode,'','','1')
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF cl_null(g_lnv[g_cnt].t_sum) THEN LET g_lnv[g_cnt].t_sum = 0 END IF
   
      #截止到目前應產生的金額
      SELECT SUM(amount) INTO g_lnv[g_cnt].s_sum
        FROM p430_tmp
       WHERE lnt01 = g_lnv[g_cnt].lnt01
         AND lnv04 = g_lnv[g_cnt].lnv04
         AND (l_year*12+l_month) <= (c_year*12+c_month)   #小于當前期金額合計
      IF SQLCA.sqlcode THEN  
         CALL cl_err3('sel','p430_tmp',g_lnv[g_cnt].lnt01,g_lnv[g_cnt].lnv04,SQLCA.sqlcode,'','','1')
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF cl_null(g_lnv[g_cnt].s_sum) THEN LET g_lnv[g_cnt].s_sum = 0 END IF
 
      #已產生金額
      SELECT SUM(lub04),SUM(lub04t) INTO g_lnv[g_cnt].a_sum,ta_sum
        FROM lua_file,lub_file
       WHERE lua01 = lub01
         AND lua04 = g_lnv[g_cnt].lnt01
         AND lua15 = 'Y'                  #已審核
         AND lub03 = g_lnv[g_cnt].lnv04
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','lua_file,lub_file',g_lnv[g_cnt].lnt01,g_lnv[g_cnt].lnv04,SQLCA.sqlcode,'','','1')
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      SELECT lnt37 INTO l_lnt37 FROM lnt_file
       WHERE lnt01 = g_lnv[g_cnt].lnt01
      IF l_lnt37 = 'Y' THEN  #含稅
         LET g_lnv[g_cnt].a_sum = ta_sum
      END IF
      IF cl_null(g_lnv[g_cnt].a_sum) THEN LET g_lnv[g_cnt].a_sum = 0 END IF
    
      #本次應產生金額
      LET g_lnv[g_cnt].n_sum = g_lnv[g_cnt].s_sum - g_lnv[g_cnt].a_sum
      LET g_lnv[g_cnt].ad_sum = g_lnv[g_cnt].n_sum
 
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_lnv.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   LET g_rec_b = g_cnt
 
   IF g_bgjob = 'N' THEN
      OPEN WINDOW p430_1_w WITH FORM "alm/42f/almp430_1"
           ATTRIBUTE(STYLE=g_win_style CLIPPED)
      CALL cl_ui_locale("almp430_1")
   
      DISPLAY g_rec_b TO FORMONLY.cnt
   
      INPUT ARRAY g_lnv WITHOUT DEFAULTS FROM s_lnv.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=FALSE,DELETE ROW=FALSE,
                     APPEND ROW=FALSE)
           BEFORE INPUT
              IF g_rec_b != 0 THEN
                 CALL fgl_set_arr_curr(l_ac)
              END IF
   
           BEFORE ROW
              LET l_ac = ARR_CURR()
      
           AFTER FIELD ad_sum
             #IF g_lnv[l_ac].ad_sum < 0 OR 
             #   g_lnv[l_ac].ad_sum > g_lnv[l_ac].n_sum AND g_lnv[l_ac].n_sum >=0 THEN
              IF g_lnv[l_ac].ad_sum > g_lnv[l_ac].n_sum THEN
                 LET g_lnv[l_ac].ad_sum = g_lnv[l_ac].n_sum
                 NEXT FIELD ad_sum
              END IF
   
           AFTER ROW
              LET l_ac = ARR_CURR()
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 EXIT INPUT
              END IF
   
          #ON ACTION process
          #   CALL p430_process1()
   
           ON ACTION CONTROLG
              CALL cl_cmdask()
   
           ON ACTION CONTROLF
              CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
              CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
   
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
   
           ON ACTION about
              CALL cl_about()
   
           ON ACTION help
              CALL cl_show_help()
      END INPUT
      IF INT_FLAG THEN
   #     LET INT_FLAG=0
         LET g_success = 'N'
         CALL cl_err('',9001,0)
      END IF
 
      CLOSE WINDOW p430_1_w
   END IF
 
END FUNCTION
 
FUNCTION p430_process1()
   DEFINE l_i         LIKE type_file.num10
   DEFINE l_lnt01     LIKE lnt_file.lnt01
   DEFINE l_lnt02     LIKE lnt_file.lnt02
   DEFINE l_lnt04     LIKE lnt_file.lnt04     #TQC-B10038
   DEFINE l_lnt36     LIKE lnt_file.lnt36
   DEFINE l_lnt37     LIKE lnt_file.lnt37
   DEFINE l_oaj05     LIKE oaj_file.oaj05
   DEFINE l_lnv04     LIKE lnv_file.lnv04
   DEFINE l_lua01     LIKE lua_file.lua01
   DEFINE t_lnt01     LIKE lnt_file.lnt01
   DEFINE t_oaj05     LIKE oaj_file.oaj05
   DEFINE l_sum       LIKE lub_file.lub04
   DEFINE l_oma01     LIKE oma_file.oma01   #dongbg add
   DEFINE l_sql       LIKE type_file.chr1000 #dongbg add
 
   DROP TABLE p430_tmp1;
   CREATE TEMP TABLE p430_tmp1(
      lnt01    LIKE lnt_file.lnt01,           #合同
      lnt02    LIKE lnt_file.lnt02,           #合同版本
      oaj05    LIKE oaj_file.oaj05,           #費用類型
      lnv04    LIKE lnv_file.lnv04,           #費用代號
      adsum    LIKE type_file.num20_6);        #金額
   
   LET g_success = 'Y'
   BEGIN WORK
   CALL s_showmsg_init()
   
   FOR l_i = 1 TO g_rec_b
       IF g_lnv[l_i].ad_sum = 0 THEN CONTINUE FOR END IF
 
       #合同版本
       SELECT lnt02 INTO l_lnt02 FROM lnt_file
        WHERE lnt01 = g_lnv[l_i].lnt01
       IF cl_null(l_lnt02) THEN LET l_lnt02 = '0' END IF
 
       #費用類型 01.定金 02.租金/收入...
       SELECT oaj05 INTO l_oaj05 FROM oaj_file 
        WHERE oaj01 = g_lnv[l_i].lnv04
       IF SQLCA.sqlcode OR cl_null(l_oaj05) THEN
          CALL s_errmsg('oaj01',g_lnv[l_i].lnv04,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
 
       #BY戴瑩規定，若為減項，則拋到almi010時，類型選 10.支出 & 金額變正
       IF g_lnv[l_i].ad_sum < 0 THEN
          LET l_oaj05 = '10'
          LET g_lnv[l_i].ad_sum = g_lnv[l_i].ad_sum * -1
       END IF
     
       INSERT INTO p430_tmp1
              VALUES(g_lnv[l_i].lnt01,l_lnt02,l_oaj05,
                     g_lnv[l_i].lnv04,g_lnv[l_i].ad_sum)
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('lnv04',g_lnv[l_i].lnv04,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
   END FOR
 
   DECLARE p430_lua_cs CURSOR FOR
    SELECT lnt01,lnt02,oaj05,lnv04,adsum
      FROM p430_tmp1
     ORDER BY lnt01,oaj05
   LET t_lnt01 = NULL
   LET t_oaj05 = NULL
   FOREACH p430_lua_cs INTO l_lnt01,l_lnt02,
                            l_oaj05,l_lnv04,l_sum
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach p430_lua_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET l_lnt36 = NULL
      LET l_lnt37 = NULL
      SELECT lnt04,lnt36,lnt37 INTO  l_lnt04,l_lnt36,l_lnt37  #TQC-B10038 add lnt04
        FROM lnt_file
       WHERE lnt01 = l_lnt01
      IF SQLCA.sqlcode THEN
         LET l_lnt36 = 0
         LET l_lnt37 = 'Y'
      END IF
      IF cl_null(l_lnt36) THEN LET l_lnt36 = 0   END IF
      IF cl_null(l_lnt37) THEN LET l_lnt37 = 'N' END IF
      IF cl_null(t_lnt01) OR cl_null(t_oaj05) OR
         l_lnt01 <> t_lnt01 OR l_oaj05 <> t_oaj05 THEN
         CALL p430_ins_lua(l_lnt01,l_lnt02,l_oaj05) RETURNING l_lua01
      END IF
      CALL p430_ins_lub(l_lua01,l_lnv04,l_sum,l_lnt36,l_lnt37)
      LET t_lnt01 = l_lnt01
      LET t_oaj05 = l_oaj05
     
   END FOREACH
 
#dongbg add 產生AR
  IF NOT t610_own(l_lnt04) THEN     #TQC-B10038
   LET l_sql = " SELECT lua01 FROM lua_file WHERE lua01 BETWEEN ? AND ? "
   PREPARE p430_ar_p1 FROM l_sql
   DECLARE p430_ar_cs CURSOR FOR p430_ar_p1
   
   LET l_lua01 = NULL 
   FOREACH p430_ar_cs USING start_no,end_no INTO l_lua01
      IF STATUS THEN
         CALL cl_err('',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      LET l_oma01 = NULL
      CALL s_costs_ar(l_lua01) RETURNING l_oma01
      IF cl_null(l_oma01) OR g_success ='N' THEN
         CALL s_errmsg('','','Produces the expense err','alm-974',1)
         LET g_success = 'N'
      #dongbg add
      #回寫費用單上的財務單號
      ELSE
         UPDATE lua_file SET lua24 = l_oma01 
          WHERE lua01 = l_lua01
         IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN 
            CALL s_errmsg('upd','lua_file',l_lua01,SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF
      #End
      
   END FOREACH
#End
 END IF     #TQC-B10038
   CALL s_showmsg()
END FUNCTION
#TQC-B10038 ---add--begin
#判斷是否為同法人自營櫃商戶(同法人的營運中心)
FUNCTION t610_own(l_occ01)
   DEFINE l_occ01 LIKE occ_file.occ01
   DEFINE l_occ930 LIKE occ_file.occ930
   DEFINE l_azw02  LIKE azw_file.azw02

   SELECT occ930 INTO l_occ930 FROM occ_file
    WHERE occ01 = l_occ01
   IF cl_null(l_occ930) THEN
      RETURN FALSE
   ELSE
      SELECT azw02 INTO l_azw02 FROM azw_file
       WHERE azw01 = l_occ930
      IF l_azw02 != g_legal THEN
         RETURN FALSE
      ELSE
         RETURN TRUE
      END IF
   END IF
END FUNCTION
#TQC-B10038--add----end
 
FUNCTION p430_ins_lua(p_lnt01,p_lnt02,p_oaj05)
   DEFINE p_lnt01     LIKE lnt_file.lnt01
   DEFINE p_lnt02     LIKE lnt_file.lnt02
   DEFINE p_oaj05     LIKE oaj_file.oaj05
   DEFINE l_lua       RECORD LIKE lua_file.*
   DEFINE l_lnt       RECORD LIKE lnt_file.*
#  DEFINE l_slip1     LIKE lrk_file.lrkslip            #FUN-A70130  mark
#  DEFINE l_slip2     LIKE lrk_file.lrkslip            #FUN-A70130  mark    
   DEFINE li_result   LIKE type_file.num5
 
   SELECT * INTO l_lnt.* FROM lnt_file WHERE lnt01 = p_lnt01
 
   INITIALIZE l_lua.* TO NULL
   LET l_lua.luaplant = g_plant
#FUN-A70130 mark------------------start-------------------------
#  LET l_slip1 = s_get_doc_no(p_lnt01)
#   SELECT lrkdmy3 INTO l_slip2 FROM lrk_file
#    WHERE lrkslip = l_slip1
#   IF cl_null(l_slip2) THEN
#      LET g_success = 'N'
#      CALL s_errmsg('lrkslip',l_slip1,'','alm-560',1)
#   END IF
#   CALL s_auto_assign_no("alm",l_slip2,tm.dd,'01',"lua_file","lua01","","","")
#FUN-A70130 mark --------------------end-----------------------
    CALL s_auto_assign_no("art",tm.g_slip,tm.dd,'B9',"lua_file","lua01","","","")  #FUN-A80105  
      RETURNING li_result,l_lua.lua01
   IF (NOT li_result) THEN
#      CALL s_errmsg('lrkslip',l_slip2,'','abm-621',1)    #FUN-A70130 mark
      CALL s_errmsg('oayslip',tm.g_slip,'','abm-621',1)
      LET g_success = 'N'
   END IF
  
  #CALL p430_auto_code() RETURNING l_lua.lua01
   LET l_lua.lua02 = p_oaj05
   LET l_lua.lua03 = ' '
   LET l_lua.lua04 = p_lnt01
 # LET l_lua.lua05 = '2'           #FUN-AC0062
   LET l_lua.lua05 = ' '           #FUN-AC0062
   LET l_lua.lua06 = l_lnt.lnt04
   SELECT lne05 INTO l_lua.lua061 FROM lne_file
    WHERE lne01 = l_lua.lua06
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lne01',l_lua.lua06,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 
   LET l_lua.lua07 = l_lnt.lnt06
   LET l_lua.lua08 = 0
   LET l_lua.lua08t= 0
   LET l_lua.lua09 = tm.dd
   LET l_lua.lua10 = 'Y'
 #  LET l_lua.lua11 = '1'         #No.FUN-A70130   mark
   LET l_lua.lua11 = '5'          #No.FUN-A70130     
   LET l_lua.lua12 = l_lnt.lnt01
   LET l_lua.lua13 = 'N'
   LET l_lua.lua14 = '0'
   LET l_lua.lua15 = 'Y'
   LET l_lua.lua16 = g_user
   LET l_lua.lua17 = tm.dd
   LET l_lua.lua18 = NULL
   LET l_lua.luauser = g_user
   LET l_lua.luamodu = ''
   LET l_lua.luagrup = g_plant
   LET l_lua.luacrat = g_today
   LET l_lua.luadate = ''
   LET l_lua.luaacti = 'Y'
   LET l_lua.luaplant = l_lnt.lntplant #FUN-AA0006 mod lntstore -> lntplant
   LET l_lua.lua19 = l_lua.luaplant                   #FUN-A80105
   LET l_lua.lua20 = p_lnt02
   LET l_lua.lua21 = l_lnt.lnt35
   LET l_lua.lua22 = l_lnt.lnt36
   LET l_lua.lua23 = l_lnt.lnt37
   LET l_lua.luaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_lua.luaorig = g_grup      #No.FUN-980030 10/01/04
   LET l_lua.lualegal = g_legal    #FUN-A60064 add
   LET l_lua.lua32 = '2'    #No.FUN-A70130   add 
   INSERT INTO lua_file VALUES(l_lua.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lua01',l_lua.lua01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF cl_null(start_no) THEN LET start_no = l_lua.lua01 END IF
   LET end_no = l_lua.lua01
   RETURN l_lua.lua01
END FUNCTION
 
FUNCTION p430_ins_lub(p_lua01,p_lnv04,p_sum,p_lnt36,p_lnt37)
   DEFINE p_lua01     LIKE lua_file.lua01
   DEFINE p_lnv04     LIKE lnv_file.lnv04
   DEFINE p_sum       LIKE lub_file.lub04
   DEFINE p_lnt36     LIKE lnt_file.lnt36
   DEFINE p_lnt37     LIKE lnt_file.lnt37
   DEFINE l_lub       RECORD LIKE lub_file.*
   DEFINE l_lub04     LIKE lub_file.lub04
   DEFINE l_lub04t    LIKE lub_file.lub04t
   
   INITIALIZE l_lub.* TO NULL
 
   LET l_lub.lubplant   = g_plant
   LET l_lub.lublegal = g_legal    #FUN-A60064 add
   LET l_lub.lub01      = p_lua01
   SELECT MAX(lub02)+1 INTO l_lub.lub02 FROM lub_file
     WHERE lub01 = p_lua01
   IF cl_null(l_lub.lub02) OR l_lub.lub02 = 0 THEN
      LET l_lub.lub02 = 1
   END IF
   LET l_lub.lub03 = p_lnv04
   IF p_lnt37 = 'N' THEN
      LET l_lub.lub04 = p_sum
      LET l_lub.lub04t= p_sum * (1+p_lnt36/100)
   ELSE
      LET l_lub.lub04t= p_sum
      LET l_lub.lub04 = p_sum / (1+p_lnt36/100)
   END IF
  
   LET l_lub.lub05 = ''
   INSERT INTO lub_file VALUES(l_lub.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lub01',l_lub.lub01,'insert lub_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   SELECT SUM(lub04),SUM(lub04t) INTO l_lub04,l_lub04t FROM lub_file
    WHERE lub01 = p_lua01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lub01',l_lub.lub01,'select sum(lub04)',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF cl_null(l_lub04)  THEN LET l_lub04 = 0 END IF
   IF cl_null(l_lub04t) THEN LET l_lub04t= 0 END IF
   UPDATE lua_file SET lua08 = l_lub04,lua08t = l_lub04t
    WHERE lua01 = p_lua01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lua01',p_lua01,'update lua08',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION p430_auto_code()
   DEFINE l_lua01    LIKE lua_file.lua01
   DEFINE l_date     LIKE lua_file.luacrat
   SELECT max(SUBSTR(lua01,10))+1 INTO l_lua01 FROM lua_file
    WHERE lua09 = tm.dd    
   IF cl_null(l_lua01) THEN
      LET l_lua01 = l_lua01 using '&&&&'
      LET l_lua01 = YEAR(tm.dd) USING '&&&&' ,MONTH(tm.dd) USING '&&',DAY(tm.dd) USING '&&',"0001"
   ELSE
      LET l_lua01 = l_lua01 using '&&&&' 
      LET l_lua01 = YEAR(tm.dd) USING '&&&&' ,MONTH(tm.dd) USING '&&',DAY(tm.dd) USING '&&',l_lua01 
   END IF
   RETURN l_lua01
END FUNCTION
 
#付款截止年/期推算
FUNCTION p430_pay(p_lnr01,p_year1,p_month1,p_year2,p_month2)
   DEFINE p_lnr01     LIKE lnr_file.lnr01
   DEFINE p_year1     LIKE type_file.num5
   DEFINE p_year2     LIKE type_file.num5
   DEFINE p_month1    LIKE type_file.num5
   DEFINE p_month2    LIKE type_file.num5
   DEFINE l_lnr03     LIKE lnr_file.lnr03
   DEFINE c_year1     LIKE type_file.num5
   DEFINE c_year2     LIKE type_file.num5
   DEFINE c_month1    LIKE type_file.num5
   DEFINE c_month2    LIKE type_file.num5
   DEFINE l_index     LIKE type_file.num5
   
   #付款方式  -幾月一付?
   SELECT lnr03 INTO l_lnr03 FROM lnr_file WHERE lnr01 = p_lnr01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lnr01',p_lnr01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(l_lnr03) OR l_lnr03 = 0 THEN LET l_lnr03 = 1 END IF
 
   #根據帳期,算出當前是什麼? 用于計算后續當前相關的金額
   #ex:計租期間 2007/1~2008/12 計算年/月:2007/5 三月一付
   #則算出當前為 2007/4~2007/6(c_year1/c_month1 ~ c_year2/c_month2)
   LET l_index = ((tm.year*12+tm.month) - (p_year1*12+p_month1)) / l_lnr03
   LET c_year2 = p_year1 * 12 + p_month1 + l_index * l_lnr03 + (l_lnr03 - 1)
   IF c_year2 > p_year2 * 12 + p_month2 THEN  #計租最后一期不滿 幾月時
      LET c_year2 = p_year2 * 12 + p_month2
   END IF
   LET c_month2 = c_year2 MOD 12
   LET c_year2 = c_year2 / 12
   IF c_month2 = 0 THEN
      LET c_month2 = 12
      LET c_year2 = c_year2 - 1
   END IF
#  LET c_year1 = c_year2 * 12 + c_month2 - (l_lnr03 - 1)
#  LET c_month1 = c_year1 MOD 12
#  LET c_year1 = c_year1 / 12
#  IF c_month1 = 0 then
#     LET c_month1 = 12
#     LET c_year1 = c_year1 - 1
#  END IF
 
   RETURN c_year2,c_month2
 
END FUNCTION
FUNCTION p430_voucher()
DEFINE l_oma01   LIKE oma_file.oma01
DEFINE l_oma02   LIKE oma_file.oma02
DEFINE g_t1      LIKE ooy_file.ooyslip
DEFINE l_wc_gl   LIKE type_file.chr1000
DEFINE g_str,l_sql     LIKE type_file.chr1000
 
   LET l_sql = " SELECT oma01,oma02 FROM oma_file WHERE oma70 BETWEEN ? AND ? ",
               "    AND oma00 IN ('15','17','22')"
   PREPARE p430_vou_p1 FROM l_sql
   DECLARE p430_vou_cs CURSOR FOR p430_vou_p1
   FOREACH p430_vou_cs USING start_no,end_no INTO l_oma01,l_oma02
     IF STATUS THEN
        EXIT FOREACH
     END IF
     CALL s_get_doc_no(l_oma01) RETURNING g_t1
     SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_t1 
     IF STATUS THEN
        EXIT FOREACH
     END IF 
     IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
        LET l_wc_gl = 'npp01 = "',l_oma01,'" AND npp011 = 1'
        LET g_str="axrp590 '",l_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",
                   g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",
                   l_oma02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"
        CALL cl_cmdrun_wait(g_str)
     END IF
   END FOREACH
END FUNCTION
#No.FUN-960134
#FUN-A
