# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
##□ s_cntrest
##SYNTAX		LET l_rest=s_cntrest(p_bankno,p_date,p_date_sw,p_curr_sw)
##DESCRIPTION	找出日前餘額(得到此日前一天的銀行存款餘額)
##PARAMETERS    p_bankno        銀行編號
##              p_date          本日日期
##              p_curr          依(1)原幣  (2)本幣
##              p_date_sw       依(1)異動日(2)傳票日
##RETURNING     l_rest          餘額
# Date & Author..: 93/04/14  By  Felicity  Tseng
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.CHI-8B0001 08/11/25 By Sarah 上期結存(l_rest)金額計算時,需考慮到質押及質押解除
# Modify.........: No.MOD-930294 09/03/30 By Sarah 修正CHI-8B0001,當p_curr_sw='1'時抓SUM(nme04),當p_curr_sw='2'時抓SUM(nme08)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS
   DEFINE g_aza RECORD LIKE aza_file.*
END GLOBALS
 
FUNCTION s_cntrest(p_bankno,p_date,p_date_sw,p_curr_sw)
    DEFINE  p_bankno   LIKE nma_file.nma01,          #銀行編號
            p_date     DATE,                         #日期
            p_date_sw  LIKE type_file.chr1,          #FUN-680107 VARCHAR(1)
            p_curr_sw  LIKE type_file.chr1,          #FUN-680107 VARCHAR(1)
            l_year     LIKE type_file.num5,          #FUN-680107 SMALLINT
            l_mon      LIKE type_file.num5,          #FUN-680107 SMALLINT
            l_bdate,l_edate LIKE type_file.dat,      #FUN-680107 DATE
            l_debit    LIKE nme_file.nme04,
            l_credit   LIKE nme_file.nme04,
            l_debit_1  LIKE nme_file.nme04,          #CHI-8B0001 add
            l_credit_1 LIKE nme_file.nme04,          #CHI-8B0001 add
            l_debit_2  LIKE nme_file.nme04,          #CHI-8B0001 add
            l_credit_2 LIKE nme_file.nme04,          #CHI-8B0001 add
            l_rest     LIKE nme_file.nme04
 
    SELECT azn02,azn04 INTO l_year,l_mon FROM azn_file WHERE azn01 = p_date
    IF STATUS THEN RETURN 0 END IF
    SELECT MIN(azn01),MAX(azn01) INTO l_bdate,l_edate FROM azn_file
           WHERE azn02 = l_year AND azn04 = l_mon
    LET l_mon = l_mon - 1
    IF l_mon = 0 THEN
       LET l_year = l_year - 1
       IF g_aza.aza02 = '2' THEN LET l_mon = 13 ELSE LET l_mon = 12 END IF
    END IF
#----------------------------------------------------------------------------
    LET l_rest = 0
    CASE 				#取得上一月份的銀行存款餘額
       WHEN p_curr_sw = '1' AND p_date_sw = '1'
            SELECT nmp06 INTO l_rest FROM nmp_file
                   WHERE nmp01 = p_bankno AND nmp02 = l_year AND nmp03 = l_mon
       WHEN p_curr_sw = '1' AND p_date_sw = '2'
            SELECT nmp16 INTO l_rest FROM nmp_file
                   WHERE nmp01 = p_bankno AND nmp02 = l_year AND nmp03 = l_mon
       WHEN p_curr_sw = '2' AND p_date_sw = '1'
            SELECT nmp09 INTO l_rest FROM nmp_file
                   WHERE nmp01 = p_bankno AND nmp02 = l_year AND nmp03 = l_mon
       WHEN p_curr_sw = '2' AND p_date_sw = '2'
            SELECT nmp19 INTO l_rest FROM nmp_file
                   WHERE nmp01 = p_bankno AND nmp02 = l_year AND nmp03 = l_mon
    END CASE
    IF STATUS AND STATUS != 100 THEN 
#      CALL cl_err('get nmp error!',STATUS,0) FUN-660148
       CALL cl_err3("sel","nmp_file",p_bankno,l_year,STATUS,"","get nmp error!",0) #FUN-660148
    END IF 
#----------------------------------------------------------------------------
    LET l_debit = 0 LET l_credit = 0
    LET l_debit_1=0 LET l_credit_1=0    #CHI-8B0001 add
    LET l_debit_2=0 LET l_credit_2=0    #CHI-8B0001 add
    CASE 				#取得上一月份的銀行存款餘額
       WHEN p_curr_sw = '1' AND p_date_sw = '1'
            SELECT SUM(nme04) INTO l_debit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1' #異動碼
             AND   nme02 >= l_bdate AND nme02 < p_date
            SELECT SUM(nme04) INTO l_credit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2' #異動碼
             AND   nme02 >= l_bdate AND nme02 < p_date
       WHEN p_curr_sw = '1' AND p_date_sw = '2'
            SELECT SUM(nme04) INTO l_debit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1' #異動碼
             AND   nme16 >= l_bdate AND nme16 < p_date
            SELECT SUM(nme04) INTO l_credit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2' #異動碼
             AND   nme16 >= l_bdate AND nme16 < p_date
       WHEN p_curr_sw = '2' AND p_date_sw = '1'
            SELECT SUM(nme08) INTO l_debit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1' #異動碼
             AND   nme02 >= l_bdate AND nme02 < p_date
            SELECT SUM(nme08) INTO l_credit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2' #異動碼
             AND   nme02 >= l_bdate AND nme02 < p_date
       WHEN p_curr_sw = '2' AND p_date_sw = '2'
            SELECT SUM(nme08) INTO l_debit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1' #異動碼
             AND   nme16 >= l_bdate AND nme16 < p_date
            SELECT SUM(nme08) INTO l_credit FROM nme_file, nmc_file
             WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2' #異動碼
             AND   nme16 >= l_bdate AND nme16 < p_date
    END CASE
   #str CHI-8B0001 add
   #抓取上期結存(l_rest)時,應考慮到質押及質押解除,
   #  質押日界於上期日期範圍的金額   ->將此金額扣除
   #  解除日>上期結束日期的金額      ->將此金額加入
    CASE                     #MOD-930294 add
      WHEN p_curr_sw = '1'   #MOD-930294 add
        SELECT SUM(nme04) INTO l_debit_1 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1'
           AND gxf011= nme12
           AND gxf21>= l_bdate AND gxf21 < p_date
        SELECT SUM(nme04) INTO l_credit_1 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2'
           AND gxf011= nme12
           AND gxf21>= l_bdate AND gxf21 < p_date
 
        SELECT SUM(nme04) INTO l_debit_2 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1'
           AND gxf011= nme12
           AND gxf22>= l_bdate AND gxf22 < p_date
        SELECT SUM(nme04) INTO l_credit_2 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2'
           AND gxf011= nme12
           AND gxf22>= l_bdate AND gxf22 < p_date
    #str MOD-930294 add
      WHEN p_curr_sw = '2'
        SELECT SUM(nme08) INTO l_debit_1 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1'
           AND gxf011= nme12 
           AND gxf21>= l_bdate AND gxf21 < p_date
        SELECT SUM(nme08) INTO l_credit_1 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2'
           AND gxf011= nme12 
           AND gxf21>= l_bdate AND gxf21 < p_date
 
        SELECT SUM(nme08) INTO l_debit_2 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '1'
           AND gxf011= nme12 
           AND gxf22>= l_bdate AND gxf22 < p_date
        SELECT SUM(nme08) INTO l_credit_2 FROM nme_file,nmc_file,gxf_file
         WHERE nme01 = p_bankno AND nmc01 = nme03 AND nmc03 = '2'
           AND gxf011= nme12 
           AND gxf22>= l_bdate AND gxf22 < p_date
    END CASE
    #end MOD-930294 add
   #end CHI-8B0001 add
    IF STATUS THEN 
#      CALL cl_err('get nme error!',STATUS,0) FUN-660148
       CALL cl_err3("sel","nme_file,nmc_file",p_bankno,"",STATUS,"","get nme error!",0) #FUN-660148
    END IF 
#----------------------------------------------------------------------------
    IF cl_null(l_debit)  THEN LET l_debit = 0 END IF
    IF cl_null(l_credit) THEN LET l_credit= 0 END IF
   #str CHI-8B0001 add
    IF cl_null(l_debit_1)  THEN LET l_debit_1 = 0 END IF
    IF cl_null(l_credit_1) THEN LET l_credit_1= 0 END IF
    IF cl_null(l_debit_2)  THEN LET l_debit_2 = 0 END IF
    IF cl_null(l_credit_2) THEN LET l_credit_2= 0 END IF
   #end CHI-8B0001 add
    LET l_rest = l_rest + l_debit - l_credit
                        -(l_debit_1-l_credit_1)   #CHI-8B0001 add
                        +(l_debit_2-l_credit_2)   #CHI-8B0001 add
    RETURN l_rest
END FUNCTION
