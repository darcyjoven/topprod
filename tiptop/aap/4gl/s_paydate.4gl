# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# □ s_paydate
# SYNTAX.........:CALL s_paydate(p_cmd,receive_date,invoice_date,
#                                ap_date,pay_type)
# Descriptions...:計算應付款日
# PARAMETERS.....: p_cmd        ('a'->新增狀態  'u'->修改狀態)
#                  receive_date 發票日期
#                  invoice_date 發票日期
#                  ap_date      帳款日期
#                  pay_type     付款方式
# RETURN.........: pay_date     應付款日
#                  agreed_day   允許票期
# DATE & Author..: 99/11/5 
# Modify.........: No.MOD-560104 05/08/05 By Smapmin 將日期30,31一律視為當月的最後一天
# Modify.........: No.MOD-590526 05/10/20 By Smapmin 票到期日為NULL時,就按照原來的方式計算
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義:w
# Modify.........: NO.TQC-760181 06/07/26 BY yiting 重過單
# Modify.........: No.MOD-7C0133 07/12/20 By Smapmin 付款條件定義為月份-1抓取月底的方式計算,
#                                                    若因超過月結日需要再加一個月時,請指定為當月的月底日期
# Modify.........: No.MOD-970185 09/07/21 By mike 將IF l_pma09 > 0 THEN的判斷拿掉,不然月數設定為負數時,不會計算                     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-980148 09/10/20 By sabrina 若傳入的第二個參數(receive_date)不為空值，則pma12 MATCHES '78'時以第二個參數的日期做計算
# Modify.........: No:MOD-9C0415 09/12/28 By Sarah 當pma09為負數時,計算完的月份若為負數,則會帶出空的日期值
# Modify.........: No:MOD-A70080 10/07/09 By Dido 計算跨年度時月份計算變數調整
# Modify.........: No:CHI-A70037 10/07/29 By Summer 使用到apz56的部分,先依據廠商抓取pmc29,若為null或=0則改用apz56
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------str----
# Modify.........: No:FUN-A10069 10/01/22 By Mandy g_buf DEFINE為locale的就好
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------end----
# Modify.........: No:MOD-B40072 11/04/12 By Sarah 推算pay_date(付款日)若碰到非工作日應往後抓到工作日為止
#                            　　　　　　　　　　　推算due_date(票到期日)若碰到非工作日或銀行休假日(nph_file)應往後抓到工作日與非銀行休假日為止
# Modify.........: No:MOD-B70032 11/07/05 By JoHung mark DEFINE g_errno，改用GLOBALS
# Modify.........: No:CHI-BA0002 11/10/14 By Dido 付款日考慮結算日部分需先處理 
# Modify.........: No:MOD-CC0269 12/12/28 By Polly 增加週六周日判斷處理
 
DATABASE ds

GLOBALS "../../config/top.global"   #MOD-B70032 add

#FUN-A10069--str--
#GLOBALS
#    DEFINE g_buf     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(78)
#END GLOBALS
#FUN-A10069--end--
 
#DEFINE   g_errno         LIKE type_file.chr8        # No.FUN-690028 VARCHAR(10)  #no.TQC-760181   #MOD-B70032 mark

FUNCTION s_paydate(p_cmd,receive_date,invoice_date,ap_date,pay_type,p_vendor)
DEFINE p_cmd        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE receive_date LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE invoice_date LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE ap_date      LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE pay_date     LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE l_apz56      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE agreed_day   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE pay_type     LIKE pma_file.pma01    #No.FUN-690028 VARCHAR(10)             
DEFINE l_y,l_m      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_pma03      LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)            
DEFINE l_pma08      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_pma09      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_pma10      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_monday     LIKE type_file.chr8    #No.FUN-690028 VARCHAR(08)
DEFINE l_eday       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_day        LIKE aba_file.aba18    #No.FUN-690028 VARCHAR(2)
DEFINE l_date       LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE check_date   LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE l_bdate      LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE l_edate      LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE l_pmaacti    LIKE pma_file.pmaacti  #No.FUN-690028 VARCHAR(1)              
DEFINE due_date     LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE l_pma12      LIKE pma_file.pma12    #No.FUN-690028 VARCHAR(1),          
DEFINE l_pma13      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE c_date       LIKE type_file.chr8    #No.FUN-690028 VARCHAR(8)
DEFINE ndays,dd,dd2 LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE p_vendor     LIKE pmc_file.pmc01    #No.FUN-690028 VARCHAR(10)   
DEFINE l_date2      LIKE type_file.chr8    # Prog. Version..: '5.30.06-13.03.12(08)   #MOD-560104
DEFINE l_mm         LIKE type_file.num5    #MOD-9C0415 add
DEFINE l_pmc29      LIKE pmc_file.pmc29    #CHI-A70037 add
DEFINE g_buf        LIKE type_file.chr1000 #FUN-A10069 add
DEFINE i            LIKE type_file.num5      #MOD-B40072 add
DEFINE l_nph02      LIKE nph_file.nph02      #MOD-B40072 add
DEFINE l_n          LIKE type_file.num10        #MOD-CC0269 add
 
    LET pay_date = NULL
    LET due_date = NULL
    SELECT pma03,pma08,pma09,pma10,pmaacti,pma12,pma13
      INTO l_pma03,l_pma08,l_pma09,l_pma10,l_pmaacti,l_pma12,l_pma13
      FROM pma_file WHERE pma01 = pay_type
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
    IF l_pma03 MATCHES "[14]" THEN LET pay_date = receive_date END IF
    IF l_pma03 MATCHES "[25]" THEN LET pay_date = invoice_date END IF
    IF l_pma03 MATCHES "[36]" THEN LET pay_date = ap_date      END IF
   #-CHI-BA0002-add-
    #付款日須考慮結算日, 當立帳日大於結帳日時, 付款日須多加一個月
    LET l_eday = DAY(ap_date)
    SELECT pmc29 INTO l_pmc29 FROM pmc_file WHERE pmc01 = p_vendor
    IF cl_null(l_pmc29) OR l_pmc29=0 THEN 
       SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0'
    ELSE
       LET l_apz56 = l_pmc29
    END IF
    IF NOT cl_null(l_apz56) AND l_eday > l_apz56 THEN
       LET g_buf = pay_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
       #判斷該日期是否合理日期
       LET check_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(check_date) RETURNING l_bdate,l_edate
       LET l_monday = l_edate USING 'yyyymmdd'
       IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
       CALL s_mothck(pay_date) RETURNING l_bdate,l_edate
       IF pay_date = l_edate THEN
          LET g_buf[7,8] = l_monday[7,8]
       END IF   
       LET pay_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
       LET g_buf = pay_date USING 'yyyymmdd'
    END IF
   #-CHI-BA0002-end-
    IF l_pma03 MATCHES "[456]" THEN   #次月初
       LET g_buf = pay_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
       LET pay_date = MDY(g_buf[5,6],1,g_buf[1,4])
    END IF
   #IF l_pma09 > 0 THEN               #起算日起加幾月 #MOD-970185
    LET g_buf = pay_date USING 'yyyymmdd'
   #str MOD-9C0415 mod
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
         #LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'     #MOD-A70080 mark
          LET g_buf[5,6] = (l_mm - 12) USING '&&'           #MOD-A70080
       OTHERWISE
          LET g_buf[5,6] = (g_buf[5,6] + l_pma09) USING '&&'
    END CASE
   #end MOD-9C0415 mod
    LET l_date = MDY(g_buf[5,6],1,g_buf[1,4])
    CALL s_mothck(l_date) RETURNING l_bdate,l_edate
    LET l_monday = l_edate USING 'yyyymmdd'
    IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
    LET pay_date= MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
   #END IF #MOD-970185
    #判斷該日期是否合理日期
    LET g_buf = pay_date USING 'yyyymmdd'
    LET l_date = MDY(g_buf[5,6],1,g_buf[1,4])
    CALL s_mothck(l_date) RETURNING l_bdate,l_edate
    LET l_monday = l_edate USING 'yyyymmdd'
    IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
    LET pay_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
    LET pay_date = pay_date + l_pma08  #起算日起加幾天
 
  #-CHI-BA0002-mark-
  # #付款日須考慮結算日, 當立帳日大於結帳日時, 付款日須多加一個月
  # LET l_eday = DAY(ap_date)
  ##SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0' #CHI-A70037 mark
  # #CHI-A70037 add --start--
  # SELECT pmc29 INTO l_pmc29 FROM pmc_file WHERE pmc01 = p_vendor
  # IF cl_null(l_pmc29) OR l_pmc29=0 THEN 
  #    SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0'
  # ELSE
  #    LET l_apz56 = l_pmc29
  # END IF
  # #CHI-A70037 add --end--
  # IF NOT cl_null(l_apz56) AND l_eday > l_apz56 THEN
  #    LET g_buf = pay_date USING 'yyyymmdd'
  #    LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
  #    IF g_buf[5,6] > '12' THEN
  #       LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
  #       LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
  #    END IF
  #    #判斷該日期是否合理日期
  #    LET check_date = MDY(g_buf[5,6],1,g_buf[1,4])
  #    CALL s_mothck(check_date) RETURNING l_bdate,l_edate
  #    LET l_monday = l_edate USING 'yyyymmdd'
  #    IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
  #    #-----MOD-7C0133---------
  #    CALL s_mothck(pay_date) RETURNING l_bdate,l_edate
  #    IF pay_date = l_edate THEN
  #       LET g_buf[7,8] = l_monday[7,8]
  #    END IF   
  #    #-----END MOD-7C0133-----
  #    LET pay_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
  #    LET g_buf = pay_date USING 'yyyymmdd'
  # END IF
  #-CHI-BA0002-end-
 
    #N0.+106 010507 add by linda 票據到期日起算基準
    LET due_date = NULL
    IF cl_null(l_pma13) THEN LET l_pma13=0 END IF
    IF cl_null(l_pma10) THEN LET l_pma10=0 END IF
    IF l_pma12 MATCHES "[14]" THEN LET due_date = receive_date END IF
    IF l_pma12 MATCHES "[25]" THEN LET due_date = invoice_date END IF
    IF l_pma12 MATCHES "[36]" THEN LET due_date = ap_date      END IF
  #MOD-980148---modify---start---
   #IF l_pma12 MATCHES "[78]" THEN LET due_date = pay_date    END IF
    IF cl_null(receive_date) THEN
       IF l_pma12 MATCHES "[78]" THEN LET due_date = pay_date    END IF
    ELSE
       IF l_pma12 MATCHES "[78]" THEN
          LET due_date = receive_date
          LET pay_date = receive_date
       END IF
    END IF
  #MOD-980148---modify---end---

    IF l_pma12 MATCHES "[4568]" THEN   #次月初
       LET g_buf = due_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
       LET due_date = MDY(g_buf[5,6],1,g_buf[1,4])
    END IF
   #IF l_pma13 > 0 THEN               #起算日起加幾月  #MOD-9C0415 mark
    LET g_buf = due_date USING 'yyyymmdd'
   #str MOD-9C0415 mod
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
         #LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'        #MOD-A70080 mark
          LET g_buf[5,6] = (l_mm - 12) USING '&&'              #MOD-A70080
       OTHERWISE
          LET g_buf[5,6] = (g_buf[5,6] + l_pma13) USING '&&'
    END CASE
   #end MOD-9C0415 mod
    LET l_date = MDY(g_buf[5,6],1,g_buf[1,4])
    CALL s_mothck(l_date) RETURNING l_bdate,l_edate
    LET l_monday = l_edate USING 'yyyymmdd'
    IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
    LET due_date= MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
   #END IF   #MOD-9C0415 mark
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
    SELECT pmc29 INTO l_pmc29 FROM pmc_file WHERE pmc01 = p_vendor
    IF cl_null(l_pmc29) OR l_pmc29=0 THEN 
       SELECT apz56 INTO l_apz56 FROM apz_file WHERE apz00='0'
    ELSE
       LET l_apz56 = l_pmc29
    END IF
    #CHI-A70037 add --end--
    #票據到期日除依7.應付款日 8.應付款日次月，其餘都要考慮結算日
  IF l_pma12 != '7' AND l_pma12 != '8' THEN
    IF NOT cl_null(l_apz56) AND l_eday > l_apz56 THEN
       LET g_buf = due_date USING 'yyyymmdd'
       LET g_buf[5,6] = (g_buf[5,6] + 1) USING '&&'
       IF g_buf[5,6] > '12' THEN
          LET g_buf[1,4] = (g_buf[1,4] + 1)  USING '&&&&'
          LET g_buf[5,6] = (g_buf[5,6] - 12) USING '&&'
       END IF
       #判斷該日期是否合理日期
       LET check_date = MDY(g_buf[5,6],1,g_buf[1,4])
       CALL s_mothck(check_date) RETURNING l_bdate,l_edate
       LET l_monday = l_edate USING 'yyyymmdd'
       IF g_buf[7,8] > l_monday[7,8] THEN LET g_buf[7,8]=l_monday[7,8] END IF
       #-----MOD-7C0133---------
       CALL s_mothck(due_date) RETURNING l_bdate,l_edate
       IF due_date = l_edate THEN
          LET g_buf[7,8] = l_monday[7,8]
       END IF   
       #-----END MOD-7C0133-----
       LET due_date = MDY(g_buf[5,6],g_buf[7,8],g_buf[1,4])
       LET g_buf = due_date USING 'yyyymmdd'
    END IF
  END IF
    LET  ndays = due_date - pay_date 
    SELECT pmc50,pmc51 INTO dd,dd2 FROM pmc_file WHERE pmc01 = p_vendor
    IF ndays > 0 THEN LET dd = dd2 END IF
    IF NOT cl_null(dd) AND dd > 0 THEN   #MOD-590526
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
#MOD-560104
       ELSE
              LET c_date = due_date USING 'yyyymmdd'
                 CALL s_azn01(c_date[1,4],c_date[5,6]) RETURNING l_bdate,l_edate
                 LET l_date2 = l_edate
                 LET c_date[7,8] = l_date2[7,8]
              LET due_date = c_date
#END MOD-560104
       END IF
    END IF   #MOD-590526
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
   #-----------------MOD-CC0269------------------------(S)
    LET l_n = WEEKDAY(due_date)  # 若為週日
    IF l_n = 0 THEN
       LET due_date = due_date + 1
    END IF
    IF l_n = 6 THEN
       LET due_date = due_date + 2
    END IF
   #-----------------MOD-CC0269------------------------(E)
    LET agreed_day = due_date - pay_date 
    RETURN pay_date,due_date,agreed_day
END FUNCTION
#FUN-AA0022
