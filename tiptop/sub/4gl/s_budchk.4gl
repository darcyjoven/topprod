# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program Name...: s_budchk.4gl
# DESCRIPTIONS...: 預算額度即時計算
# Date & Author..: 99/12/13 By Aladin  
# Input PARAMETER: (dept,budget_code,acct_id,consum_date,consum_amt)
#                  (部門,預算編號,預算科目,預算日,本次耗用金額)
# RETURN Code....: 0    FALSE(預算額度超限)
#                  1    TRUE (預算額度未超限)
# Memo...........: 本副程式將會在PR 確認 及 PO 確認時被起動以便檢查預算額度是否超限
#                  已耗金額計算以發單日期為準 1.PR 請購日
#                                             2.PO 採購日
#                                             3.AP 帳款日
#                                             4.已拋 GL 則以傳票日為準
# ModIFy.........: No.MOD-530378 05/03/29 By Mandy 請採購預算未考慮送簽中的單據.pml16 ,pmm25要納入簽核的單據
# ModIFy.........: No.FUN-5A0093 06/01/17 By Sarah
#                  控管每一階段的金額時,於以下幾段請加判斷若計算後的餘額小於0時,應該金額為0:
#                  1.PO已確認,且未結案,且未立AP-->在FOREACH中IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
#                  2.PO已立AP,且AP未拋GL       -->IF bamt4 < 0 THEN LET bamt4 = 0 END IF
#                  3.AP已拋GL,且GL未過帳       -->IF bamt5 < 0 THEN LET bamt5 = 0 END IF
#                  4.GL已過帳                  -->IF bamt6 < 0 THEN LET bamt6 = 0 END IF
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.MOD-730009 07/03/06 By Smapmin 排除作廢傳票
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-920280 09/02/23 By Smapmin pml20->pml87,pmn20->pmn87,pml21依轉換率換算
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_budchk(dept,budget_code,acct_id,consum_date,consum_amt,p_bookno)
    DEFINE 
      l_sql        LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(1000)
      p_bookno     LIKE aaa_file.aaa01,
      dept         LIKE pmk_file.pmk13,
      budget_year  LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
      budget_month LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
      budget_code  LIKE pmk_file.pmk06,
      acct_id      LIKE pml_file.pml40,
      consum_amt   LIKE afc_file.afc07,
      consum_date  LIKE type_file.dat,                    	#No.FUN-680147 DATE
      l_apamt      LIKE afc_file.afc06,
      bamt1        LIKE afc_file.afc06 ,
      bamt2        LIKE afc_file.afc06 ,
      bamt3        LIKE afc_file.afc06 ,
      bamt4        LIKE afc_file.afc06 ,
      bamt4_1      LIKE afc_file.afc06 ,
      bamt4_2      LIKE afc_file.afc06 ,
      bamt4_3      LIKE afc_file.afc06 ,
      bamt5        LIKE afc_file.afc06 ,
      bamt5_1      LIKE afc_file.afc06,
      bamt5_2      LIKE afc_file.afc06,
      bamt6        LIKE afc_file.afc06 ,
      bamt6_1      LIKE afc_file.afc06,
      bamt6_2      LIKE afc_file.afc06,
      kk record 
       pmn01       LIKE pmn_file.pmn01, 
       pmn02       LIKE pmn_file.pmn02,
       xamt        LIKE afc_file.afc06
     END record,
      l_pnr06      LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
      last_bamt    LIKE afc_file.afc06,  
      over_amt     LIKE afc_file.afc06
 
DEFINE l_pml86     LIKE pml_file.pml86,  #MOD-920280
       l_pml07     LIKE pml_file.pml07,  #MOD-920280
       l_pml87     LIKE pml_file.pml87,  #MOD-920280
       l_pml21     LIKE pml_file.pml21,  #MOD-920280
       l_pml44     LIKE pml_file.pml44,  #MOD-920280
       l_pml04     LIKE pml_file.pml04,  #MOD-920280
       l_fac       LIKE pml_file.pml09,  #MOD-920280
       l_i         LIKE type_file.num5   #MOD-920280
 
   #---------------------------
   # 先計算目前額度的年度及月份
   #---------------------------
   LET bamt1 = 0 
   LET bamt2 = 0
   LET bamt3 = 0
   LET bamt4 = 0
   LET bamt4_1 = 0
   LET bamt4_2 = 0
   LET bamt4_3 = 0
   LET bamt5 = 0
   LET bamt5_1 = 0
   LET bamt5_2 = 0
   LET bamt6 = 0
   LET bamt6_1 = 0
   LET bamt6_2 = 0
   LET last_bamt = 0
   LET budget_year = YEAR(consum_date)
   LET budget_month = MONTH(consum_date)
 
   SELECT pnr06 INTO l_pnr06 FROM pnr_file
    WHERE pnr01=budget_code AND pnr02=acct_id AND pnr03=dept AND pnr04=budget_year
   IF STATUS THEN LET l_pnr06=' ' END IF
   IF l_pnr06=' ' OR l_pnr06 IS NULL THEN RETURN 0,0,0 END IF
 
   #------------------------------------- 
   # (0) 請採購可用預算總額計算(年度)
   #------------------------------------- 
   IF l_pnr06='Y' THEN
      SELECT pnr10 INTO last_bamt FROM pnr_file
        WHERE pnr01=budget_code AND pnr02=acct_id AND pnr03=dept 
          AND pnr04=budget_year  
   ELSE
      SELECT pns09 INTO last_bamt FROM pns_file
        WHERE pns01=budget_code AND pns02=acct_id AND pns03=dept 
          AND pns04=budget_year AND pns05=budget_month 
   END IF
   IF last_bamt is NULL THEN LET last_bamt = 0 END IF
 
   #---------------------------------------------
   #(1) PR 已確認且未結案且未轉PO之金額
   #---------------------------------------------
   #-----MOD-920280---------
   #LET l_sql="SELECT SUM((pml20-pml21)*pml44) FROM pmk_file,pml_file", 
   #          "    WHERE pmk01=pml01 AND pmk18='Y' ",
   #         #"      AND pml16 < '6' ",                                           #MOD-530378
   #          "      AND (pml16< '6' OR pml16='S' OR pml16='R' OR pml16='W') ",   #MOD-530378
   #          "      AND pml40='",acct_id,"' AND pml66='",budget_code,"' ",
   #          "      AND pml67='",dept,"' AND pmk31='",budget_year,"' "
   #IF l_pnr06='N' THEN 
   #   LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   #END IF
   #PREPARE pre1 FROM l_sql
   #DECLARE cur1 CURSOR FOR pre1
   #OPEN cur1
   #FETCH cur1 INTO bamt1   
   #IF bamt1 is NULL THEN LET bamt1 = 0 END IF
   LET l_sql="SELECT pml87,pml21,pml44,pml07,pml86,pml04 FROM pmk_file,pml_file", 
             "    WHERE pmk01=pml01 AND pmk18='Y' ",
             "      AND (pml16< '6' OR pml16='S' OR pml16='R' OR pml16='W') ",   #MOD-530378
             "      AND pml40='",acct_id,"' AND pml66='",budget_code,"' ",
             "      AND pml67='",dept,"' AND pmk31='",budget_year,"' "
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   END IF
   PREPARE pre1 FROM l_sql
   DECLARE cur1 CURSOR FOR pre1
   FOREACH cur1 INTO l_pml87,l_pml21,l_pml44,l_pml07,l_pml86,l_pml04
     CALL s_umfchk(l_pml04,l_pml07,l_pml86) RETURNING l_i,l_fac
     IF l_i = 1 THEN
        CALL cl_err(l_pml04,'abm-731',0) LET l_fac = 1
     END IF
     LET bamt1 = bamt1 + ((l_pml87-(l_pml21*l_fac)) * l_pml44)
     IF bamt1 is NULL THEN LET bamt1 = 0 END IF
   END FOREACH 
   #-----END MOD-920280-----
   IF bamt1 < 0 THEN LET bamt1 = 0 END IF   #FUN-5A0093
 
   #---------------------------------------------
   #(2) PR 已轉PO但PO未確認且未結案之金額
   #---------------------------------------------
   #LET l_sql="SELECT sum(pmn44*pmn20) FROM pmm_file,pmn_file,pmk_file,pml_file",   #MOD-920280
   LET l_sql="SELECT sum(pmn44*pmn87) FROM pmm_file,pmn_file,pmk_file,pml_file",   #MOD-920280
             "   WHERE pmm01=pmn01 AND pmm18='N'",
            #"      AND pmm25 < '6' ",                                           #MOD-530378
             "      AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",   #MOD-530378
             "     AND pmn40='",acct_id,"' AND pmn66='",budget_code,"' ",
             "     AND pmn67='",dept,"' AND pmk31='",budget_year,"' ",
             "     AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 "
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   END IF
   PREPARE pre2 FROM l_sql
   DECLARE cur2 CURSOR FOR pre2
   OPEN cur2
   FETCH cur2 INTO bamt2   
   IF bamt2 is NULL THEN LET bamt2 = 0 END IF
   IF bamt2 < 0 THEN LET bamt2 = 0 END IF   #FUN-5A0093
 
   #---------------------------------------------
   #(3) PO 已確認且PO 未結案且未轉應付的金額
   #---------------------------------------------
   #LET l_sql="SELECT pmn01,pmn02,pmn20*pmn44 ",   #MOD-920280
   LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 ",   #MOD-920280
             "    FROM pmm_file,pmn_file,pmk_file,pml_file",
             "   WHERE pmm01 = pmn01 AND pmm18 ='Y' ",
            #"     AND pmm25 < '6'",                                            #MOD-530378
             "     AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",   #MOD-530378
             "     AND pmn40='",acct_id,"' AND pmn66='",budget_code,"' ",
             "     AND pmn67='",dept,"' AND pmk31='",budget_year,"' ",
             "     AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 "
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   END IF
   PREPARE pre31 FROM l_sql
   DECLARE kk_curs CURSOR FOR pre31
   FOREACH kk_curs INTO kk.*
      IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
      IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF   #FUN-5A0093
      DECLARE bb_curs31 cursor FOR 
         SELECT (apb08*apb09) from apa_file,apb_file 
         WHERE apa01=apb01 AND apb06=kk.pmn01 AND apb07=kk.pmn02 AND apa00[1,1]='1'
           AND apa42 = 'N'  #modi 010809
      FOREACH bb_curs31 into l_apamt 
         IF l_apamt is NULL THEN LET l_apamt = 0 END IF
         LET kk.xamt = kk.xamt - l_apamt
         IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF   #FUN-5A0093 
      END FOREACH 
      LET bamt3 = bamt3 + kk.xamt 
   END FOREACH
   IF bamt3 is NULL THEN LET bamt3 = 0 END IF
 
   #LET l_sql="SELECT pmn01,pmn02,pmn20*pmn44 FROM pmm_file,pmn_file",   #MOD-920280
   LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 FROM pmm_file,pmn_file",   #MOD-920280
             "   WHERE pmm01 = pmn01 AND pmm18 ='Y' AND pmm25 < '6'",
             "     AND pmn40='",acct_id,"' AND pmn66='",budget_code,"' ",
             "     AND pmn67='",dept,"' AND pmm31='",budget_year,"' ",
             "     AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL "
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND pmm32='",budget_month,"' " 
   END IF
   PREPARE pre32 FROM l_sql
   DECLARE kk_curs1 CURSOR FOR pre32
   FOREACH kk_curs1 INTO kk.*
      IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
      IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF   #FUN-5A0093
      DECLARE bb_curs32 cursor FOR 
         SELECT (apb08*apb09) from apa_file,apb_file 
         WHERE apa01=apb01 AND apb06=kk.pmn01 AND apb07=kk.pmn02 AND apa00[1,1]='1'
           AND apa42 = 'N' #modi 010809
      FOREACH bb_curs32 INTO l_apamt 
         IF l_apamt is NULL THEN LET l_apamt = 0 END IF
         LET kk.xamt = kk.xamt - l_apamt
         IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF   #FUN-5A0093
      END FOREACH 
      LET bamt3 = bamt3 + kk.xamt 
   END FOREACH
   IF bamt3 is NULL THEN LET bamt3 = 0 END IF
   IF bamt3 < 0 THEN LET bamt3 = 0 END IF   #FUN-5A0093
 
   #----------------------------------------------
   #(4) PO已立帳(立AP) ,但未拋傳票(未到總帳)之金額
   #----------------------------------------------
   LET l_sql="SELECT SUM(apb08*apb09) ",
             "   FROM apa_file,apb_file,pmm_file,pmn_file,pmk_file,pml_file",
             "  WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
             "    AND apb25='",acct_id,"' AND apb30='",budget_code,"' ",
             "    AND apb26='",dept,"' AND pmk31='",budget_year,"' ",
             "    AND apa00[1,1]='1' ", 
             "    AND apa42 = 'N' AND pmm18 <> 'X' ",
             "    AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
             "    AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 "
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   END IF
   PREPARE pre41 FROM l_sql
   DECLARE cur41 CURSOR FOR pre41
   OPEN cur41
   FETCH cur41 INTO bamt4_1 
   IF bamt4_1 is NULL THEN LET bamt4_1 = 0 END IF
 
   LET l_sql="SELECT SUM(apb08*apb09) ",
             "   FROM apa_file,apb_file,pmm_file,pmn_file",
             "  WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
             "    AND apb25='",acct_id,"' AND apb30='",budget_code,"' ",
             "    AND apb26='",dept,"' AND pmm31='",budget_year,"' ",
             "    AND apa00[1,1]='1' ", 
             "    AND apa42 = 'N' AND pmm18 <> 'X' ",
             "    AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
             "    AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL "
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND pmm32='",budget_month,"' " 
   END IF
   PREPARE pre42 FROM l_sql
   DECLARE cur42 CURSOR FOR pre42
   OPEN cur42
   FETCH cur42 INTO bamt4_2 
   IF bamt4_2 is NULL THEN LET bamt4_2 = 0 END IF
 
   LET l_sql="SELECT SUM(apb08*apb09) ",
             "   FROM apa_file,apb_file",
             "  WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') AND apa41='Y'",
             "    AND apb25='",acct_id,"' AND apb30='",budget_code,"' ",
             "    AND apb26='",dept,"' AND YEAR(apa02)='",budget_year,"' ",
             "    AND apa00[1,1]='1' ", 
             "    AND (apb06=' ' OR apb06 IS NULL) ",
             "    AND (apb07 IS NULL) "
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND MONTH(apa02)='",budget_month,"' " 
   END IF
   PREPARE pre43 FROM l_sql
   DECLARE cur43 CURSOR FOR pre43
   OPEN cur43
   FETCH cur43 INTO bamt4_3 
   IF bamt4_3 is NULL THEN LET bamt4_3 = 0 END IF
   
   LET bamt4 = bamt4_1 + bamt4_2 + bamt4_3
   IF bamt4 < 0 THEN LET bamt4 = 0 END IF   #FUN-5A0093
 
   #------------------------------------------
   #(5) AP 已拋傳票(已轉總帳),但未過帳
   #------------------------------------------
   #no.7277
   IF cl_null(p_bookno) THEN
      SELECT aaz64 INTO p_bookno FROM aaz_file WHERE aaz00='0'
   END IF
   #no.7277(END)
   LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file", 
             "  WHERE aba01=abb01 AND abapost ='N' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '1'",
             "    AND aba19 <> 'X' ",  #CHI-C80041
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",p_bookno,"'"   #no.7277
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND aba04='",budget_month,"' " 
   END IF
   PREPARE pre51 FROM l_sql
   DECLARE cur51 CURSOR FOR pre51
   OPEN cur51
   FETCH cur51 INTO bamt5_1 
   IF bamt5_1 is NULL THEN LET bamt5_1 = 0 END IF
 
   LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file", 
             "  WHERE aba01=abb01 AND abapost ='N' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '2'" ,
             "    AND aba19 <> 'X' ",  #CHI-C80041
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",p_bookno,"'"   #no.7277
 
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND aba04='",budget_month,"' " 
   END IF
   PREPARE pre52 FROM l_sql
   DECLARE cur52 CURSOR FOR pre52
   OPEN cur52
   FETCH cur52 INTO bamt5_2 
   IF bamt5_2 is NULL THEN LET bamt5_2 = 0 END IF 
 
   LET bamt5 = bamt5_1 - bamt5_2
   IF bamt5 < 0 THEN LET bamt5 = 0 END IF   #FUN-5A0093
 
   #---------------------------------------------
   #(6) AP 已拋傳票已過帳
   #---------------------------------------------
   LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file", 
             "  WHERE aba01=abb01 AND abapost ='Y' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '1'",
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",p_bookno,"'"   #no.7277
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND aba04='",budget_month,"' " 
   END IF
   PREPARE pre61 FROM l_sql
   DECLARE cur61 CURSOR FOR pre61
   OPEN cur61
   FETCH cur61 INTO bamt6_1 
   IF bamt6_1 is NULL THEN LET bamt6_1 = 0 END IF
 
   LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file", 
             "  WHERE aba01=abb01 AND abapost ='Y' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '2'" ,
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",p_bookno,"'"   #no.7277
   IF l_pnr06='N' THEN 
      LET l_sql=l_sql CLIPPED," AND aba04='",budget_month,"' " 
   END IF
   PREPARE pre62 FROM l_sql
   DECLARE cur62 CURSOR FOR pre62
   OPEN cur62
   FETCH cur62 INTO bamt6_2 
   IF bamt6_2 is NULL THEN LET bamt6_2 = 0 END IF 
   
   LET bamt6 = bamt6_1 - bamt6_2
   IF bamt6 < 0 THEN LET bamt6 = 0 END IF   #FUN-5A0093
 
   #-----------------------------------------------
   # 判斷是否超限
   #-----------------------------------------------
   
   LET over_amt = last_bamt - bamt1 - bamt2 - bamt3 - bamt4 - bamt5 - bamt6 
   
   IF over_amt < 0 THEN 
      RETURN 0,over_amt,last_bamt         # 預算超限
   ELSE
      RETURN 1,over_amt,last_bamt         # 預算未超限 
   END IF
 
END FUNCTION
