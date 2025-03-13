# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: s_paydate_m.4gl
# Descriptions...: 計算應付款日
# DATE & Author..: 99/11/5 copy from $AAP/4gl/s_paydate
# Usage..........: CALL s_paydate_m(p_dbs,p_cmd,receive_date,invoice_date,
#                                   ap_date,pay_type)
# Input Parameter: p_cmd        ('a'->新增狀態  'u'->修改狀態)
#                  p_dbs        資料庫名稱
#                  receive_date 發票日期
#                  invoice_date 發票日期
#                  ap_date      帳款日期
#                  pay_type     付款方式
# Return code....: pay_date     應付款日
#                  agreed_day   允許票期
# Modify.........: No.8506 03/10/16 by ching
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980020 09/09/08 By douzh GP集團架構修改,sub相關參數
# Modify.........: No:MOD-A50182 10/05/30 By Smapmin 將程式邏輯改為與s_paydate.4gl一致
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70037 10/07/30 By Summer 使用到apz56的部分,先依據廠商抓取pmc29,若為null或=0則改用apz56
# Modify.........: No:MOD-AB0168 10/11/17 By Dido 計算跨年度時月份計算變數調整
# Modify.........: No:MOD-B40072 11/04/12 By Sarah 推算pay_date(付款日)若碰到非工作日應往後抓到工作日為止
#                            　　　　　　　　　　　推算due_date(票到期日)若碰到非工作日或銀行休假日(nph_file)應往後抓到工作日與非銀行休假日為止
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
GLOBALS
    DEFINE g_buf     LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(78)
END GLOBALS
 
#FUNCTION s_paydate_m(p_dbs,p_cmd,receive_date,invoice_date,ap_date,pay_type,p_vendor)  #FUN-980020 mark
FUNCTION s_paydate_m(p_plant,p_cmd,receive_date,invoice_date,ap_date,pay_type,p_vendor) #FUN-980020
    DEFINE p_dbs     LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)
    DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
    DEFINE receive_date,invoice_date,ap_date,pay_date LIKE type_file.dat           #No.FUN-680147 DATE
    DEFINE l_apz56   LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE agreed_day LIKE type_file.num5         #No.FUN-680147 SMALLINT
    DEFINE pay_type  LIKE pma_file.pma01          #No.FUN-680147 VARCHAR(10)
    DEFINE l_y,l_m   LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE l_pma03   LIKE pma_file.pma03          #No.FUN-680147 VARCHAR(1)
    DEFINE l_pma08   LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE l_pma09   LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE l_pma10   LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE l_monday  LIKE smh_file.smh01          #No.FUN-680147 VARCHAR(08)
    DEFINE l_eday    LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE l_day     LIKE aba_file.aba18          #No.FUN-680147 VARCHAR(2)
    DEFINE l_date,check_date    LIKE type_file.dat  #No.FUN-680147 DATE
    DEFINE l_bdate,l_edate LIKE type_file.dat     #No.FUN-680147 DATE
    DEFINE l_pmaacti LIKE pma_file.pmaacti        #No.FUN-680147 VARCHAR(1)
    DEFINE due_date  LIKE type_file.dat,          #No.FUN-680147 DATE
           l_pma12   LIKE pma_file.pma12,         #No.FUN-680147 VARCHAR(1)  
           l_pma13   LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE c_date     LIKE smh_file.smh01         #No.FUN-680147 VARCHAR(8)
    DEFINE ndays,dd,dd2  LIKE type_file.num5      #No.FUN-680147 SMALLINT
    DEFINE p_vendor  LIKE pmc_file.pmc01          #No.FUN-680147 VARCHAR(10)
    DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
    DEFINE p_plant   LIKE type_file.chr10         #FUN-980020
    DEFINE l_date2    LIKE type_file.chr8          #MOD-A50182
    DEFINE l_mm       LIKE type_file.num5          #MOD-A50182
    DEFINE l_pmc29   LIKE pmc_file.pmc29          #CHI-A70037 add
    DEFINE i            LIKE type_file.num5    #MOD-B40072 add
    DEFINE l_nph02      LIKE nph_file.nph02    #MOD-B40072 add
 
#FUN-980020--begin
    IF cl_null(p_plant) THEN
       LET p_dbs = NULL
    ELSE
       LET g_plant_new = p_plant
       CALL s_getdbs()
       LET p_dbs = g_dbs_new
    END IF
#FUN-980020--end
 
    LET pay_date = NULL
    LET due_date = NULL
 
   #讀取付款方式資料
   LET l_sql = "SELECT  pma03,pma08,pma09,pma10,pmaacti,pma12,pma13 ",
             #" FROM ",p_dbs CLIPPED,"pma_file ",
             " FROM ",cl_get_target_table(p_plant,'pma_file'), #FUN-A50102
             " WHERE pma01 = '",pay_type,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE pma_p FROM l_sql
   IF STATUS THEN CALL cl_err('pma_p',STATUS,1) END IF
   DECLARE pma_cur CURSOR FOR pma_p
   OPEN pma_cur
   FETCH pma_cur INTO l_pma03,l_pma08,l_pma09,l_pma10,l_pmaacti,l_pma12,l_pma13
   CLOSE pma_cur
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-036'
        WHEN l_pmaacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
    IF p_cmd != 'a' THEN RETURN pay_date,due_date,agreed_day END IF
    IF NOT cl_null(g_errno) THEN RETURN pay_date,due_date,agreed_day END IF
    IF cl_null(l_pma08) THEN LET l_pma08=0 END IF
    IF cl_null(l_pma09) THEN LET l_pma09=0 END IF
    IF cl_null(l_pma12) THEN LET l_pma12=l_pma03 END IF
    LET agreed_day  = l_pma10
   #LET g_apa.apa24 = l_pma10
   #DISPLAY BY NAME g_apa.apa24
    IF l_pma03 MATCHES "[14]" THEN LET pay_date = receive_date END IF
    IF l_pma03 MATCHES "[25]" THEN LET pay_date = invoice_date END IF
    IF l_pma03 MATCHES "[36]" THEN LET pay_date = ap_date      END IF
    IF l_pma03 MATCHES "[456]" THEN   #次月初
       LET g_buf = pay_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
       LET pay_date = MDY(g_buf[5,6],1,g_buf[1,4])
    END IF
    #IF l_pma09 > 0 THEN               #起算日起加幾月   #MOD-A50182
       LET g_buf = pay_date USING 'yyyymmdd'
       #-----MOD-A50182---------
       #LET g_buf[5,6] = (g_buf[5,6] + l_pma09) USING '&&'
       #IF g_buf[5,6] > '12' THEN
       #   LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
       #   LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       #END IF
       LET l_mm = 0
       LET l_mm = g_buf[5,6] + l_pma09
       CASE
          WHEN l_mm <= 0
             LET g_buf[1,4] = (g_buf[1,4] - 1)  USING '&&&&'
             LET g_buf[5,6] = (g_buf[5,6] + 12 + l_pma09) USING '&&'
          WHEN l_mm > 12
             LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
            #LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'     #MOD-AB0168 mark
             LET g_buf[5,6] = (l_mm - 12) USING '&&'           #MOD-AB0168
          OTHERWISE
             LET g_buf[5,6] = (g_buf[5,6] + l_pma09) USING '&&'
       END CASE
       #-----END MOD-A50182-----
       LET l_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(l_date) RETURNING l_bdate,l_edate
       LET l_monday = l_edate USING 'yyyymmdd'
       IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
       LET pay_date= MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
    #END IF   #MOD-A50182
    #判斷該日期是否合理日期
    LET g_buf = pay_date USING 'yyyymmdd'
    LET l_date = MDY(g_buf[5,6],1,g_buf[1,4])
    CALL s_mothck(l_date) RETURNING l_bdate,l_edate
    LET l_monday = l_edate USING 'yyyymmdd'
    IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
    LET pay_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
    LET pay_date = pay_date + l_pma08  #起算日起加幾天
 
    #付款日須考慮結算日, 當立帳日大於結帳日時, 付款日須多加一個月
    LET l_eday = DAY(ap_date)
    #SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0' #CHI-A70037 mark
    #CHI-A70037 add --start--
    LET l_sql = "SELECT  pmc29 ",
                " FROM ",cl_get_target_table(p_plant,'pmc_file'),
                " WHERE pmc01 = '",p_vendor,"' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
    PREPARE pmc29_p FROM l_sql
    DECLARE pmc29_cur CURSOR FOR pmc29_p
    OPEN pmc29_cur
    FETCH pmc29_cur INTO l_pmc29 
    CLOSE pmc29_cur
    IF cl_null(l_pmc29) OR l_pmc29=0 THEN 
       SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0'
    ELSE
       LET l_apz56 = l_pmc29
    END IF
    #CHI-A70037 add --end--
    IF NOT cl_null(l_apz56) AND l_eday > l_apz56 THEN
       LET g_buf = pay_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
    #  LET pay_date = MDY(g_buf[5,6],1,g_buf[1,4])
    #  LET g_buf = pay_date USING 'yyyymmdd'
{#no.6127 mark
     IF l_pma09 > 0 AND l_pma08 = 0 THEN 
       LET check_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(check_date) RETURNING l_bdate,l_edate
       LET pay_date = l_edate
     ELSE
}
       #判斷該日期是否合理日期
       LET check_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(check_date) RETURNING l_bdate,l_edate
       LET l_monday = l_edate USING 'yyyymmdd'
       IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
       #-----MOD-A50182---------
       CALL s_mothck(pay_date) RETURNING l_bdate,l_edate
       IF pay_date = l_edate THEN
          LET g_buf[7,8] = l_monday[7,8]
       END IF
       #-----END MOD-A50182-----
       LET pay_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
       LET g_buf = pay_date USING 'yyyymmdd'
#    END IF
    END IF
 
    #N0.+106 010507 add by linda 票據到期日起算基準
    LET due_date = NULL
    IF cl_null(l_pma13) THEN LET l_pma13=0 END IF
    IF cl_null(l_pma10) THEN LET l_pma10=0 END IF
    IF l_pma12 MATCHES "[14]" THEN LET due_date = receive_date END IF
    IF l_pma12 MATCHES "[25]" THEN LET due_date = invoice_date END IF
    IF l_pma12 MATCHES "[36]" THEN LET due_date = ap_date      END IF
    #-----MOD-A50182--------- 
    #IF l_pma12 MATCHES "[78]" THEN LET due_date = pay_date    END IF
    IF cl_null(receive_date) THEN
       IF l_pma12 MATCHES "[78]" THEN LET due_date = pay_date    END IF
    ELSE
       IF l_pma12 MATCHES "[78]" THEN
          LET due_date = receive_date
          LET pay_date = receive_date
       END IF
    END IF
    #-----END MOD-A50182-----
    IF l_pma12 MATCHES "[4568]" THEN   #次月初
       LET g_buf = due_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
       LET due_date = MDY(g_buf[5,6],1,g_buf[1,4])
    END IF
    #IF l_pma13 > 0 THEN               #起算日起加幾月   #MOD-A50182
       LET g_buf = due_date USING 'yyyymmdd'
       #-----MOD-A50182---------
       #LET g_buf[5,6] = (g_buf[5,6] + l_pma13) USING '&&'
       #IF g_buf[5,6] > '12' THEN
       #   LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
       #   LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       #END IF
       LET l_mm = 0
       LET l_mm = g_buf[5,6] + l_pma13
       CASE
          WHEN l_mm <= 0
             LET g_buf[1,4] = (g_buf[1,4] - 1)  USING '&&&&'
             LET g_buf[5,6] = (g_buf[5,6] + 12 + l_pma13) USING '&&'
          WHEN l_mm > 12
             LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
            #LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'        #MOD-AB0168 mark
             LET g_buf[5,6] = (l_mm - 12) USING '&&'              #MOD-AB0168
          OTHERWISE
             LET g_buf[5,6] = (g_buf[5,6] + l_pma13) USING '&&'
       END CASE
       #-----END MOD-A50182-----
       LET l_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(l_date) RETURNING l_bdate,l_edate
       LET l_monday = l_edate USING 'yyyymmdd'
       IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
       LET due_date= MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
    #END IF   #MOD-A50182
    #判斷該日期是否合理日期
    LET g_buf = due_date USING 'yyyymmdd'
    LET l_date = MDY(g_buf[5,6],1,g_buf[1,4])
    CALL s_mothck(l_date) RETURNING l_bdate,l_edate
    LET l_monday = l_edate USING 'yyyymmdd'
    IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
    LET due_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
    LET due_date = due_date + l_pma10  #起算日起加幾天
 
    #付款日須考慮結算日, 當立帳日大於結帳日時, 付款日須多加一個月
    LET l_eday = DAY(ap_date)
    #SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0' #CHI-A70037 mark
    #CHI-A70037 add --start--
    LET l_sql = "SELECT  pmc29 ",
                " FROM ",cl_get_target_table(p_plant,'pmc_file'),
                " WHERE pmc01 = '",p_vendor,"' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
    PREPARE pmc29_p1 FROM l_sql
    DECLARE pmc29_cur1 CURSOR FOR pmc29_p1
    OPEN pmc29_cur1
    FETCH pmc29_cur1 INTO l_pmc29 
    CLOSE pmc29_cur1
    IF cl_null(l_pmc29) OR l_pmc29=0 THEN 
       SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0'
    ELSE
       LET l_apz56 = l_pmc29
    END IF
    #CHI-A70037 add --end--
    #no:3504 modi 01/09/11 
    #票據到期日除依7.應付款日 8.應付款日次月，其餘都要考慮結算日
  IF l_pma12 != '7' AND l_pma12 != '8' THEN
    IF NOT cl_null(l_apz56) AND l_eday > l_apz56 THEN
       LET g_buf = due_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
{#no.6127 mark
     IF l_pma09 > 0 AND l_pma08 = 0 THEN 
       LET check_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(check_date) RETURNING l_bdate,l_edate
       LET due_date = l_edate
     ELSE 
}
       #判斷該日期是否合理日期
       LET check_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(check_date) RETURNING l_bdate,l_edate
       LET l_monday = l_edate USING 'yyyymmdd'
       IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
       #-----MOD-A50182---------
       CALL s_mothck(due_date) RETURNING l_bdate,l_edate
       IF due_date = l_edate THEN
          LET g_buf[7,8] = l_monday[7,8]
       END IF
       #-----END MOD-A50182----- 
       LET due_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
       LET g_buf = due_date USING 'yyyymmdd'
#    END IF
    END IF
  END IF
    LET  ndays = due_date - pay_date 
    #依 s_duedate 
   #讀取廠商資料
   LET l_sql = "SELECT  pmc50,pmc51 ",
             #" FROM ",p_dbs CLIPPED,"pmc_file ",
             " FROM ",cl_get_target_table(p_plant,'pmc_file'), #FUN-A50102
             " WHERE pmc01 = '",p_vendor,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE pmc_p FROM l_sql
   IF STATUS THEN CALL cl_err('pmc_p',STATUS,1) END IF
   DECLARE pmc_cur CURSOR FOR pmc_p
   OPEN pmc_cur
   FETCH pmc_cur INTO dd,dd2
   CLOSE pmc_cur
 
    IF ndays > 0 THEN LET dd = dd2 END IF
    IF NOT cl_null(dd) AND dd > 0 THEN   #MOD-A50182
       IF SQLCA.SQLCODE = 0 AND dd > 0 AND dd < 30
         THEN LET c_date = due_date USING 'yyyymmdd'
              IF c_date[7,8] > dd THEN
                 LET c_date[5,6] = (c_date[5,6] + 1) USING '&&'
                 IF c_date[5,6] > '12' THEN
                    LET c_date[1,4] = (c_date[1,4] + 1) USING '&&&&'
                    LET c_date[5,6] = (c_date[5,6] - 12) USING '&&'
                 END IF
              END IF
              LET c_date[7,8] = dd USING '&&'
              LET due_date = c_date
              WHILE STATUS != 0 AND c_date[7,8] > '00'
                  LET c_date[7,8] = (c_date[7,8] - 1) USING '&&'
                  LET due_date = c_date
              END WHILE
    #-----MOD-A50182---------
       ELSE
              LET c_date = due_date USING 'yyyymmdd'
                 CALL s_azn01(c_date[1,4],c_date[5,6]) RETURNING l_bdate,l_edate
                 LET l_date2 = l_edate
                 LET c_date[7,8] = l_date2[7,8]
              LET due_date = c_date
       END IF
    #-----END MOD-A50182-----
    END IF
   #str MOD-B40072 add
    #推算pay_date(付款日)若碰到非工作日應往後抓到工作日為止
    #推算due_date(票到期日)若碰到非工作日或銀行休假日(nph_file)應往後抓到工作日與非銀行休假日為止
    CALL s_aday(pay_date,1,0) RETURNING pay_date
    CALL s_aday(due_date,1,0) RETURNING due_date
    FOR i=1 TO 30
       SELECT nph02 INTO l_nph02 FROM nph_file WHERE nph01=due_date
       IF STATUS = 0 THEN
          LET due_date=due_date+1
       ELSE
          EXIT FOR
       END IF
    END FOR
   #end MOD-B40072 add
    LET agreed_day = due_date - pay_date 
    #010507 end----
    RETURN pay_date,due_date,agreed_day
END FUNCTION
 
