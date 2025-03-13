# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program Name...: s_budamt.4gl
# DESCRIPTIONS...: 預算已耗金額計算	
# Date & Author..: 99/12/13 By Aladin  
# Input PARAMETER: (dept,budget_code,acct_id,budget_year,budget_month)
#                  (部門編號,預算編號,科目編號,年度,月份)
# RETURN Code....: 已耗金額 (1)-(6)               
# Modify.........: No.FUN-5A0093 06/01/17 By Sarah
#                  控管每一階段的金額時,於以下幾段請加判斷若計算後的餘額小於0時,應該金額為0:
#                  1.PO已確認,且未結案,且未立AP-->在FOREACH中IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
#                  2.PO已立AP,且AP未拋GL       -->IF bamt4 < 0 THEN LET bamt4 = 0 END IF
#                  3.AP已拋GL,且GL未過帳       -->IF bamt5 < 0 THEN LET bamt5 = 0 END IF
#                  4.GL已過帳                  -->IF bamt6 < 0 THEN LET bamt6 = 0 END IF
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0148 06/12/05 By rainy pml20->pml87,pmn20->pmn87,pml21依轉換率換算
# Modify.........: No.MOD-730009 07/03/06 By Smapmin 排除作廢傳票
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.FUN-9B0039 09/11/05 BY liuxqa substr 修改。
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_budamt(dept,budget_code,acct_id,budget_year,budget_month)
  DEFINE 
      l_sql        LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(1000)
      l_bookno     LIKE aaa_file.aaa01,
      dept         LIKE pmk_file.pmk13,
      budget_year  LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
      budget_month LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
      budget_code  LIKE pmk_file.pmk06,
      acct_id      LIKE pml_file.pml40,
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
     END record  
DEFINE l_pml86     LIKE pml_file.pml86,  #FUN-6A0148
       l_pml07     LIKE pml_file.pml07,  #FUN-6A0148
       l_pml87     LIKE pml_file.pml87,  #FUN-6A0148
       l_pml21     LIKE pml_file.pml21,  #FUN-6A0148
       l_pml44     LIKE pml_file.pml44,  #FUN-6A0148
       l_pml04     LIKE pml_file.pml04,  #FUN-6A0148
       l_fac       LIKE pml_file.pml09,  #FUN-6A0148
       l_i         LIKE type_file.num5   #FUN-6A0148
 
 
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
 
   #---------------------------------------------
   #(1) PR 已確認且未結案且未轉PO之金額
   #---------------------------------------------
  #FUN-6A0148 --begin
   #LET l_sql="SELECT SUM((pml20-pml21)*pml44) FROM pmk_file,pml_file", 
   #          "    WHERE pmk01=pml01 AND pmk18='Y' AND pml16 < '6' ",
   #          "      AND pml40='",acct_id,"' AND pml66='",budget_code,"' ",
   #          "      AND pml67='",dept,"' AND pmk31='",budget_year,"' "
   #IF budget_month!=0 THEN 
   #   LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   #END IF
   #PREPARE pre1 FROM l_sql
   #DECLARE cur1 CURSOR FOR pre1
   #OPEN cur1
   #FETCH cur1 INTO bamt1 
   #IF bamt1 is NULL THEN LET bamt1 = 0 END IF
   LET l_sql="SELECT pml87,pml21,pml44,pml07,pml86,pml04 FROM pmk_file,pml_file", 
             "    WHERE pmk01=pml01 AND pmk18='Y' AND pml16 < '6' ",
             "      AND pml40='",acct_id,"' AND pml66='",budget_code,"' ",
             "      AND pml67='",dept,"' AND pmk31='",budget_year,"' "
   IF budget_month!=0 THEN 
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
  #FUN-6A0148--end  
   IF bamt1 < 0 THEN LET bamt1 = 0 END IF   #FUN-5A0093
 
   #---------------------------------------------
   #(2) PR 已轉PO但PO未確認且未結案之金額
   #---------------------------------------------
   #LET l_sql="SELECT sum(pmn44*pmn20) FROM pmm_file,pmn_file,pmk_file,pml_file",   #FUN-6A0148 remark
   LET l_sql="SELECT sum(pmn44*pmn87) FROM pmm_file,pmn_file,pmk_file,pml_file",    #FUN-6A0148
             "   WHERE pmm01=pmn01 AND pmm18='N' AND pmm25 < '6' ",
             "     AND pmn40='",acct_id,"' AND pmn66='",budget_code,"' ",
             "     AND pmn67='",dept,"' AND pmk31='",budget_year,"' ",
             "     AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 "
   IF budget_month!=0 THEN 
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
   #LET l_sql="SELECT pmn01,pmn02,pmn20*pmn44 ",   #FUN-6A0148 remark
   LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 ",    #FUN-6A0148
             "    FROM pmm_file,pmn_file,pmk_file,pml_file",
             "   WHERE pmm01 = pmn01 and pmm18 ='Y' and pmm25 < '6'",
             "     AND pmn40='",acct_id,"' AND pmn66='",budget_code,"' ",
             "     AND pmn67='",dept,"' AND pmk31='",budget_year,"' ",
             "     AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 "
   IF budget_month!=0 THEN 
      LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   END IF
   PREPARE pre31 FROM l_sql
   DECLARE kk_curs CURSOR FOR pre31
   FOREACH kk_curs INTO kk.*
      IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
      IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF   #FUN-5A0093
      declare bb_curs31 cursor FOR 
         SELECT (apb08*apb09) from apa_file,apb_file 
         WHERE apa01=apb01 and apb06=kk.pmn01 and apb07=kk.pmn02 and apa00[1,1]='1'
           AND apa42 = 'N' #date 010809
      FOREACH bb_curs31 into l_apamt 
         IF l_apamt is NULL THEN LET l_apamt = 0 END IF
         LET kk.xamt = kk.xamt - l_apamt
         IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF   #FUN-5A0093
      END FOREACH 
      LET bamt3 = bamt3 + kk.xamt 
   END FOREACH
   IF bamt3 is NULL THEN LET bamt3 = 0 END IF
   
   #LET l_sql="SELECT pmn01,pmn02,pmn20*pmn44 FROM pmm_file,pmn_file",  #FUN-6A0148 remark
   LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 FROM pmm_file,pmn_file",   #FUN-6A0148
             "   WHERE pmm01 = pmn01 and pmm18 ='Y' and pmm25 < '6'",
             "     AND pmn40='",acct_id,"' AND pmn66='",budget_code,"' ",
             "     AND pmn67='",dept,"' AND pmm31='",budget_year,"' ",
             "     AND (pmn24=' ' OR pmn24 IS NULL)  AND pmn25 IS NULL "
   IF budget_month!=0 THEN 
      LET l_sql=l_sql CLIPPED," AND pmm32='",budget_month,"' " 
   END IF
   PREPARE pre32 FROM l_sql
   DECLARE kk_curs1 CURSOR FOR pre32
   FOREACH kk_curs1 INTO kk.*
      IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
      IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF   #FUN-5A0093
      declare bb_curs32 cursor FOR 
         SELECT (apb08*apb09) from apa_file,apb_file 
         WHERE apa01=apb01 and apb06=kk.pmn01 and apb07=kk.pmn02 and apa00[1,1]='1'
           and apa42 = 'N'
      FOREACH bb_curs32 into l_apamt 
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
             "  WHERE apa01=apb01 and (apa44 is NULL or apa44=' ') ",
             "    AND apb25='",acct_id,"' AND apb30='",budget_code,"' ",
             "    AND apb26='",dept,"' AND pmk31='",budget_year,"' ",
             "    AND apa42 = 'N' ",
             #"    AND SUBSTR(apa00,1,1-1+1)='1' AND pmm18 <> 'X'", 
             "    AND apa00[1,1-1+1]='1' AND pmm18 <> 'X'",    #FUN-9B0039 mod 
             "    AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
             "    AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 "
   IF budget_month!=0 THEN 
      LET l_sql=l_sql CLIPPED," AND pmk32='",budget_month,"' " 
   END IF
   PREPARE pre41 FROM l_sql
   DECLARE cur41 CURSOR FOR pre41
   OPEN cur41
   FETCH cur41 INTO bamt4_1 
   IF bamt4_1 is NULL THEN LET bamt4_1 = 0 END IF
   
   LET l_sql="SELECT SUM(apb08*apb09) ",
             "   FROM apa_file,apb_file,pmm_file,pmn_file",
             "  WHERE apa01=apb01 and (apa44 is NULL or apa44=' ') ",
             "    AND apb25='",acct_id,"' AND apb30='",budget_code,"' ",
             "    AND apb26='",dept,"' AND pmm31='",budget_year,"' ",
             #"    AND SUBSTR(apa00,1,1-1+1)='1' ", 
             "    AND apa00[1,1-1+1]='1' ",                     #FUN-9B0039 mod 
             "    AND apa42 = 'N' AND pmm18 <> 'X'",
             "    AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
             "    AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL "
   IF budget_month!=0 THEN 
      LET l_sql=l_sql CLIPPED," AND pmm32='",budget_month,"' " 
   END IF
   PREPARE pre42 FROM l_sql
   DECLARE cur42 CURSOR FOR pre42
   OPEN cur42
   FETCH cur42 INTO bamt4_2 
   IF bamt4_2 is NULL THEN LET bamt4_2 = 0 END IF
   
   LET l_sql="SELECT SUM(apb08*apb09) ",
             "   FROM apa_file,apb_file",
             "  WHERE apa01=apb01 and (apa44 is NULL or apa44=' ') AND apa41='Y'",
             "    AND apb25='",acct_id,"' AND apb30='",budget_code,"' ",
             "    AND apb26='",dept,"' AND YEAR(apa02)='",budget_year,"' ",
             #"    AND SUBSTR(apa00,1,1-1+1)='1' ", 
             "    AND apa00[1,1-1+1]='1' ",    #FUN-9B0039 mod 
             "    AND (apb06=' ' OR apb06 IS NULL) ",
             "    AND (apb07=0 OR apb07 IS NULL) "
   IF budget_month!=0 THEN 
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
 
   SELECT aaz64 INTO l_bookno FROM aaz_file WHERE aaz00='0' #no.7277
 
   LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file", 
             "  WHERE aba01=abb01 and abapost ='N' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '1'" ,
             "    AND aba19 <> 'X' ",  #CHI-C80041
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",l_bookno,"'"   #no.7277
   IF budget_month!=0 THEN 
      LET l_sql=l_sql CLIPPED," AND aba04='",budget_month,"' " 
   END IF
   PREPARE pre51 FROM l_sql
   DECLARE cur51 CURSOR FOR pre51
   OPEN cur51
   FETCH cur51 INTO bamt5_1 
   IF bamt5_1 is NULL THEN LET bamt5_1 = 0 END IF
 
   LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file", 
             "  WHERE aba01=abb01 and abapost ='N' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '2'" ,
             "    AND aba19 <> 'X' ",  #CHI-C80041
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",l_bookno,"'"   #no.7277
   IF budget_month!=0 THEN 
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
             "  WHERE aba01=abb01 and abapost ='Y' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '1'" ,
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",l_bookno,"'"   #no.7277
   IF budget_month!=0 THEN 
      LET l_sql=l_sql CLIPPED," AND aba04='",budget_month,"' " 
   END IF
   PREPARE pre61 FROM l_sql
   DECLARE cur61 CURSOR FOR pre61
   OPEN cur61
   FETCH cur61 INTO bamt6_1 
   IF bamt6_1 is NULL THEN LET bamt6_1 = 0 END IF
   
   LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file", 
             "  WHERE aba01=abb01 and abapost ='Y' ",
             "    AND abaacti = 'Y' ",   #MOD-730009
             "    AND abb15='",budget_code,"' AND abb03='",acct_id,"' ",
             "    AND abb05='",dept,"' AND aba03='",budget_year,"' ",
             "    AND abb06 = '2'" ,
             "    AND aba00 = abb00 ",          #no.7277
             "    AND aba00 = '",l_bookno,"'"   #no.7277
   IF budget_month!=0 THEN 
      LET l_sql=l_sql CLIPPED," AND aba04='",budget_month,"' " 
   END IF
   PREPARE pre62 FROM l_sql
   DECLARE cur62 CURSOR FOR pre62
   OPEN cur62
   FETCH cur62 INTO bamt6_2 
   IF bamt6_2 is NULL THEN LET bamt6_2 = 0 END IF 
   
   LET bamt6 = bamt6_1 - bamt6_2
   IF bamt6 < 0 THEN LET bamt6 = 0 END IF   #FUN-5A0093
 
   #---------------------------------------------
   #目前已耗金額 
   #---------------------------------------------
 
   RETURN bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
 
END FUNCTION
