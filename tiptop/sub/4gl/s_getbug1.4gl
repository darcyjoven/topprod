# Prog. Version..: '5.30.06-13.03.18(00005)'     #
#
# Program Name...: s_getbug1.4gl
# DESCRIPTIONS...: 預算計算
# Date & Author..: 08/04/02 By Carrier  #No.FUN-830161
# Modify.........: FUN-840074 By Carrier 加入afc05=NULL的處理
# Modify.........: FUN-840227 By Carrier 加入s_bug1的內容
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:MOD-A90043 10/09/07 By Summer 調整所有pmn67 = p_afc041的條件均改成(pmn67 = p_afc041 OR pmn67 IS NULL)
# Modify.........: No.MOD-C50108 12/05/22 By Polly 巳消耗預增加判斷是否有總額控制
# Modify.........: No.MOD-C90192 12/09/27 By jt_chen 原抓已確認單據apa41='Y',改抓未作廢單據apa42<>'Y'
# Modify.........: No.MOD-CA0035 12/10/08 By jt_chen 採購單身項次的狀態碼與pmn16之值為6,7,8時，該項次的金額亦不應計入已耗用預算
# Modify.........: No.MOD-C90254 12/11/01 By Dido 預算應再考慮請採購已耗用部分 
# Modify.........: No.MOD-CB0012 12/11/12 By jt_chen 調整apmq651改回CALL s_budamt1;另s_budamt1判斷apmq651、apmr650只需處理非總額不遞延的情況
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.MOD-CB0162 13/01/11 By jt_chen (4)PO已立AP,且AP未拋GL拆成兩段,第一段抓apa00='1%',且不為16類,第二段抓16類且不存在1開頭的
# Modify.........: No.CHI-CB0002 13/02/25 By Elise 確認段控卡，預算認列
# Modify.........: No.MOD-D70009 13/07/01 By SunLM 计算PO已確認且PO未結案且未轉應付的金額”时应排除预付账款 
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053  #No.FUN-840074
DEFINE g_flag_bug  LIKE type_file.num5
DEFINE g_amt_bug   LIKE afc_file.afc07
DEFINE g_afc06     LIKE afc_file.afc06
DEFINE g_afc07     LIKE afc_file.afc07
DEFINE g_amt       LIKE afc_file.afc06
DEFINE g_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目  #MOD-C90254
 
######################################################################################
# Descriptions...: 預算耗用計算
# Date & Author..: 08/04/09 By Carrier  #No.FUN-830161
# Usage..........: CALL s_budget(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,
#                                p_afc041,p_afc042,p_afc05,p_flag)
# Input PARAMETER: p_afc00    帳套
#                  p_afc01    費用原因
#                  p_afc02    會計科目
#                  p_afc03    會計年度
#                  p_afc04    WBS
#                  p_afc041   部門編號
#                  p_afc042   項目編號
#                  p_afc05    期別
#                  p_flag     #0.第一科目 1.第二科目
# RETURN Code....: state      0.FALSE   1.TRUE
#                  l_afb07    預算控制方式
#                  last_bamt  預算總金額
#                  bamt1      消耗1
#                  bamt2      消耗2
#                  bamt3      消耗3
#                  bamt4      消耗4
#                  bamt5      消耗5
#                  bamt6      消耗6
######################################################################################
 
FUNCTION s_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                  p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE l_afb       RECORD LIKE afb_file.*
  DEFINE l_afc       RECORD LIKE afc_file.*
  DEFINE b_afc       RECORD LIKE afc_file.*
  DEFINE l_flag      LIKE type_file.chr1
  DEFINE l_bookno1   LIKE afa_file.afa01  #帳套1
  DEFINE l_bookno2   LIKE afa_file.afa01  #帳套2
  DEFINE #l_sql       LIKE type_file.chr1000
         l_sql          STRING      #NO.FUN-910082
  DEFINE kk          RECORD
                     pmn01 LIKE pmn_file.pmn01,
                     pmn02 LIKE pmn_file.pmn02,
                     xamt  LIKE afc_file.afc06
                     END RECORD
  DEFINE l_apamt     LIKE afc_file.afc06
  DEFINE last_bamt   LIKE afc_file.afc06
  DEFINE over_amt    LIKE afc_file.afc06
  DEFINE bamt1       LIKE afc_file.afc06
  DEFINE bamt2       LIKE afc_file.afc06
  DEFINE bamt3       LIKE afc_file.afc06
  DEFINE bamt4       LIKE afc_file.afc06
  DEFINE bamt4_1     LIKE afc_file.afc06
  DEFINE bamt4_2     LIKE afc_file.afc06
  DEFINE bamt4_3     LIKE afc_file.afc06
  DEFINE bamt4_1_1   LIKE afc_file.afc06   #MOD-CB0162 add
  DEFINE bamt4_2_1   LIKE afc_file.afc06   #MOD-CB0162 add
  DEFINE bamt4_3_1   LIKE afc_file.afc06   #MOD-CB0162 add
  DEFINE bamt5       LIKE afc_file.afc06
  DEFINE bamt5_1     LIKE afc_file.afc06
  DEFINE bamt5_2     LIKE afc_file.afc06
  DEFINE bamt6       LIKE afc_file.afc06
  DEFINE bamt6_1     LIKE afc_file.afc06
  DEFINE bamt6_2     LIKE afc_file.afc06
  DEFINE l_pml87     LIKE pml_file.pml87
  DEFINE l_pml21     LIKE pml_file.pml21
  DEFINE l_pml44     LIKE pml_file.pml44
  DEFINE l_pml07     LIKE pml_file.pml07
  DEFINE l_pml86     LIKE pml_file.pml86
  DEFINE l_pml04     LIKE pml_file.pml04
  DEFINE l_i         LIKE type_file.num5
  DEFINE l_fac       LIKE ima_file.ima31_fac
  DEFINE l_exist     LIKE type_file.num5
 #CHI-CB0002---add---S
 #請購變更
  DEFINE bamt7       LIKE afc_file.afc06
  DEFINE l_pnf87a    LIKE pnf_file.pnf87a
  DEFINE l_pnf87b    LIKE pnf_file.pnf87b
  DEFINE l_pnf87     LIKE pnf_file.pnf87a
  DEFINE l_pnf07a    LIKE pnf_file.pnf07a
  DEFINE l_pnf07b    LIKE pnf_file.pnf07b
  DEFINE l_pnf07     LIKE pnf_file.pnf07a
  DEFINE l_pnf86a    LIKE pnf_file.pnf86a
  DEFINE l_pnf86b    LIKE pnf_file.pnf86b
  DEFINE l_pnf86     LIKE pnf_file.pnf86a
  DEFINE l_pnf04a    LIKE pnf_file.pnf04a
  DEFINE l_pnf04b    LIKE pnf_file.pnf04b
  DEFINE l_pnf04     LIKE pnf_file.pnf04a
 #採購變更
  DEFINE bamt8       LIKE afc_file.afc06
  DEFINE l_pnb87a    LIKE pnb_file.pnb87a
  DEFINE l_pnb87b    LIKE pnb_file.pnb87b
  DEFINE l_pnb87     LIKE pnb_file.pnb87a
  DEFINE l_pnb07a    LIKE pnb_file.pnb07a
  DEFINE l_pnb07b    LIKE pnb_file.pnb07b
  DEFINE l_pnb07     LIKE pnb_file.pnb07a
  DEFINE l_pnb86a    LIKE pnb_file.pnb86a
  DEFINE l_pnb86b    LIKE pnb_file.pnb86b
  DEFINE l_pnb86     LIKE pnb_file.pnb86a
  DEFINE l_pnb04a    LIKE pnb_file.pnb04a
  DEFINE l_pnb04b    LIKE pnb_file.pnb04b
  DEFINE l_pnb04     LIKE pnb_file.pnb04a
  DEFINE l_pmn44     LIKE pmm_file.pmm04
 #CHI-CB0002---add---E
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF cl_null(p_afc00)  THEN LET p_afc00  = ' ' END IF
  IF cl_null(p_afc01)  THEN LET p_afc01  = ' ' END IF
  IF cl_null(p_afc02)  THEN LET p_afc02  = ' ' END IF
  IF cl_null(p_afc03)  THEN LET p_afc03  = ' ' END IF
  IF cl_null(p_afc04)  THEN LET p_afc04  = ' ' END IF
  IF cl_null(p_afc041) THEN LET p_afc041 = ' ' END IF
  IF cl_null(p_afc042) THEN LET p_afc042 = ' ' END IF
  IF cl_null(p_afc05)  THEN LET p_afc05  = ' ' END IF
 
  #aza63 (使用多帳別) & p_flag = '1' 
  IF g_aza.aza63 = 'N' THEN
     IF p_flag = '1' THEN
       #RETURN TRUE,'1',0,0,0,0,0,0,0      #CHI-CB0002 mark
        RETURN TRUE,'1',0,0,0,0,0,0,0,0,0  #CHI-CB0002
     END IF
  END IF
 
  CALL s_bud_exist(p_afc00,p_afc01,p_afc02,p_afc03,
                   p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
       RETURNING l_exist,l_afb.*,l_afc.*
  IF l_exist = FALSE THEN
    #RETURN FALSE,'3',0,0,0,0,0,0,0        #CHI-CB0002 mark
     RETURN FALSE,'3',0,0,0,0,0,0,0,0,0    #CHI-CB0002
  ELSE
     LET p_afc00 = l_afb.afb00
  END IF
 
  IF cl_null(l_afb.afb18) THEN LET l_afb.afb18 = 'N' END IF  #總額控制
  IF cl_null(l_afb.afb10) THEN LET l_afb.afb10 = 0   END IF  #總年度預算
  IF cl_null(l_afc.afc06) THEN LET l_afc.afc06 = 0   END IF
  IF cl_null(l_afc.afc08) THEN LET l_afc.afc08 = 0   END IF
  IF cl_null(l_afc.afc09) THEN LET l_afc.afc09 = 0   END IF
 
  #計算已消耗的金額
  LET bamt1 = 0
  LET bamt2 = 0
  LET bamt3 = 0
  LET bamt4 = 0
  LET bamt4_1 = 0
  LET bamt4_2 = 0
  LET bamt4_3 = 0
  LET bamt4_1_1 = 0 #MOD-CB0162 add
  LET bamt4_2_1 = 0 #MOD-CB0162 add
  LET bamt4_3_1 = 0 #MOD-CB0162 add
  LET bamt5 = 0
  LET bamt5_1 = 0
  LET bamt5_2 = 0
  LET bamt6 = 0
  LET bamt6_1 = 0
  LET bamt6_2 = 0
  LET last_bamt = 0
  LET bamt7 = 0   #CHI-CB0002 add
  LET bamt8 = 0   #CHI-CB0002 add
 
  IF cl_null(l_afb.afb09) THEN LET l_afb.afb09 = 'N' END IF
  #-------------------------------------
  # (0) 請采購可用預算總額計算(年度)
  #-------------------------------------
  IF l_afb.afb18 = 'Y' THEN      #做總額控制  -不care期別
     LET last_bamt = l_afb.afb10
  ELSE
     IF l_afb.afb09 = 'Y' THEN   #本預算上期未消耗預算可否遞延至下期
        #僅可使用p_afc05以前的月份的剩余金額,而非全年金額,decided by melody
        #因為afc06/afc08/afc09很多空值,nvl也只能oracle用..故用foreach
        DECLARE sel_afc_cur1 CURSOR FOR
         SELECT * FROM afc_file
          WHERE afc00 = p_afc00
            AND afc01 = p_afc01
            AND afc02 = p_afc02
            AND afc03 = p_afc03
            AND afc04 = p_afc04
            AND afc041= p_afc041
            AND afc042= p_afc042
            AND afc05 <= p_afc05
        LET last_bamt = 0
        FOREACH sel_afc_cur1 INTO b_afc.*
           IF SQLCA.sqlcode THEN
              LET g_errno = SQLCA.sqlcode
              #IF g_bgerr THEN
              #   CALL s_errmsg('','','foreach sel_afc_cur1',SQLCA.sqlcode,1)
              #ELSE
              #   CALL cl_err('foreach sel_afc_cur1',SQLCA.sqlcode,1)
              #END IF
              EXIT FOREACH
           END IF
           IF cl_null(b_afc.afc06) THEN LET b_afc.afc06 = 0 END IF
           IF cl_null(b_afc.afc08) THEN LET b_afc.afc08 = 0 END IF
           IF cl_null(b_afc.afc09) THEN LET b_afc.afc09 = 0 END IF
           LET last_bamt = last_bamt + b_afc.afc06 + b_afc.afc08 + b_afc.afc09
        END FOREACH
     ELSE
        LET last_bamt = l_afc.afc06 + l_afc.afc08 + l_afc.afc09
     END IF
  END IF
  IF cl_null(last_bamt) THEN LET last_bamt = 0 END IF
 
  #---------------------------------------------
  #(1) PR 已確認且未結案且未轉PO之金額
  #---------------------------------------------
  LET l_sql="SELECT pml87,pml21,pml44,pml07,pml86,pml04 FROM pmk_file,pml_file",
            " WHERE pmk01=pml01 AND pmk18='Y' ",
            "   AND (pml16< '6' OR pml16='S' OR pml16='R' OR pml16='W') ",
            "   AND pml90='",p_afc01,"'",
            "   AND YEAR(pml33)=",p_afc03,
            "   AND pml121='",p_afc04 ,"' ",
            "   AND pml67 ='",p_afc041,"' ",
            "   AND pml12 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pml40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pml401='",p_afc02,"'"
  END IF
 
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre1 FROM l_sql
  DECLARE cur1 CURSOR FOR pre1
 
  LET bamt1 = 0
 
  FOREACH cur1 INTO l_pml87,l_pml21,l_pml44,l_pml07,l_pml86,l_pml04
     CALL s_umfchk(l_pml04,l_pml07,l_pml86) RETURNING l_i,l_fac
     IF l_i = 1 THEN
        LET g_errno = 'abm-731'
        #IF g_bgerr THEN
        #   LET g_showmsg = l_pml04,'/',l_pml07,'/',l_pml86
        #   CALL s_errmsg('pml04,pml07,pml86',g_showmsg,'s_umfchk','abm-731',0)
        #ELSE
        #   CALL cl_err(l_pml04,'abm-731',0)
        #END IF
        LET l_fac = 1
     END IF
     IF cl_null(l_pml87) THEN LET l_pml87 = 0 END IF
     IF cl_null(l_pml21) THEN LET l_pml21 = 0 END IF
     IF cl_null(l_pml44) THEN LET l_pml44 = 0 END IF
     IF cl_null(l_fac) THEN LET l_fac = 1 END IF
     LET bamt1 = bamt1 + ((l_pml87-(l_pml21*l_fac)) * l_pml44)
  END FOREACH
  IF cl_null(bamt1) THEN LET bamt1 = 0 END IF
  IF bamt1 < 0 THEN LET bamt1 = 0 END IF
 
  #---------------------------------------------
  #(2) PR 已轉PO但PO未確認且未結案之金額
  #---------------------------------------------
  LET l_sql="SELECT sum(pmn44*pmn87) FROM pmm_file,pmn_file,pmk_file,pml_file",
            " WHERE pmm01=pmn01 AND pmm18='N'",
            "   AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
            "   AND pmn16 < '6' ",  #MOD-CA0035 add
            "   AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "   AND pmn98='",p_afc01,"'",
            "   AND YEAR(pml33)=",p_afc03,
            "   AND pmn96='",p_afc04 ,"' ",
           #"   AND pmn67 ='",p_afc041,"' ", #MOD-A90043 mark
            "   AND (pmn67='",p_afc041,"' OR pmn67 IS NULL) ", #MOD-A90043
            "   AND pmn122 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pmn40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pmn401='",p_afc02,"'"
  END IF
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652 
     LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012
  PREPARE pre2 FROM l_sql
  DECLARE cur2 CURSOR FOR pre2
  OPEN cur2
  FETCH cur2 INTO bamt2
  IF bamt2 is NULL THEN LET bamt2 = 0 END IF
  IF bamt2 < 0 THEN LET bamt2 = 0 END IF
 
  #---------------------------------------------
  #(3) PO 已確認且PO 未結案且未轉應付的金額
  #---------------------------------------------
  LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 ",
            "  FROM pmm_file,pmn_file,pmk_file,pml_file",
            " WHERE pmm01 = pmn01 AND pmm18 ='Y' ",
            "   AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
            "   AND pmn16 < '6' ",  #MOD-CA0035 add
            "   AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "   AND pmn98='",p_afc01,"'",
            "   AND YEAR(pml33)=",p_afc03,
            "   AND pmn96='",p_afc04 ,"' ",
           #"   AND pmn67 ='",p_afc041,"' ", #MOD-A90043 mark
            "   AND (pmn67='",p_afc041,"' OR pmn67 IS NULL) ", #MOD-A90043
            "   AND pmn122 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pmn40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pmn401='",p_afc02,"'"
  END IF
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
 
  PREPARE pre31 FROM l_sql
  DECLARE kk_curs CURSOR FOR pre31
  FOREACH kk_curs INTO kk.*
     IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
     IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     DECLARE bb_curs31 cursor FOR
        SELECT (apb08*apb09) from apa_file,apb_file
        WHERE apa01=apb01 AND apb06=kk.pmn01 AND apb07=kk.pmn02 AND apa00[1,1]='1'
          AND apa42 = 'N'
          AND apa00 <> '15'        #add by MOD-D70009
     FOREACH bb_curs31 into l_apamt
        IF l_apamt is NULL THEN LET l_apamt = 0 END IF
        LET kk.xamt = kk.xamt - l_apamt
        IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     END FOREACH
     LET bamt3 = bamt3 + kk.xamt
  END FOREACH
  IF bamt3 is NULL THEN LET bamt3 = 0 END IF
 
  LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 FROM pmm_file,pmn_file",
            " WHERE pmm01 = pmn01 AND pmm18 ='Y' ",
            "   AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
            "   AND pmn16 < '6' ",  #MOD-CA0035 add
           #"   AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL ",               #CHI-CB0002 mark 
            "   AND (pmn24=' ' OR pmn24 IS NULL) AND (pmn25 IS NULL OR pmn25 =0)",  #CHI-CB0002
            "   AND pmn98='",p_afc01,"'",
            "   AND pmm31=", p_afc03,
            "   AND pmn96='",p_afc04 ,"' ",
           #"   AND pmn67 ='",p_afc041,"' ", #MOD-A90043 mark
            "   AND (pmn67='",p_afc041,"' OR pmn67 IS NULL) ", #MOD-A90043
            "   AND pmn122 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pmn40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pmn401='",p_afc02,"'"
  END IF
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND pmm32<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre32 FROM l_sql
  DECLARE kk_curs1 CURSOR FOR pre32
  FOREACH kk_curs1 INTO kk.*
     IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
     IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     DECLARE bb_curs32 cursor FOR
        SELECT (apb08*apb09) from apa_file,apb_file
        WHERE apa01=apb01 AND apb06=kk.pmn01 AND apb07=kk.pmn02 AND apa00[1,1]='1'
          AND apa42 = 'N' #modi 010809
          AND apa00 <> '15'    #add by MOD-D70009
     FOREACH bb_curs32 INTO l_apamt
        IF l_apamt is NULL THEN LET l_apamt = 0 END IF
        LET kk.xamt = kk.xamt - l_apamt
        IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     END FOREACH
     LET bamt3 = bamt3 + kk.xamt
  END FOREACH
  IF bamt3 is NULL THEN LET bamt3 = 0 END IF
  IF bamt3 < 0 THEN LET bamt3 = 0 END IF
 
  #----------------------------------------------
  #(4) PO已立帳(立AP) ,但未拋傳票(未到總帳)之金額
  #----------------------------------------------
  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file,pmm_file,pmn_file,pmk_file,pml_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "   AND apa00[1,1]='1' ",
            "   AND apa42 = 'N' AND pmm18 <> 'X' ",
            "   AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "   AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "   AND apb31='",p_afc01,"'",
            "   AND YEAR(pml33)=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' ",                                 #MOD-CB0162 add ,
            "   AND apa00 <> '16' ",                                          #MOD-CB0162 add
            "   AND apa00 <> '15' "                                          #add by MOD-D70009
            
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre41 FROM l_sql
  DECLARE cur41 CURSOR FOR pre41
  OPEN cur41
  FETCH cur41 INTO bamt4_1
  IF bamt4_1 is NULL THEN LET bamt4_1 = 0 END IF
  
  #MOD-CB0162 -- add start -- #第二段抓16類且不存在1開頭的
  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file,pmm_file,pmn_file,pmk_file,pml_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "   AND apa00='16' ",
            "   AND apa42 = 'N' AND pmm18 <> 'X' ",
            "   AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "   AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "   AND apb31='",p_afc01,"'",
            "   AND YEAR(pml33)=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' ",
            "   AND apb21||apb22 NOT IN ( ",
            "     SELECT apb21||apb22 ",
            "      FROM apa_file,apb_file,pmm_file,pmn_file,pmk_file,pml_file",
            "     WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "      AND apa00[1,1]='1' ",
            "      AND apa42 = 'N' AND pmm18 <> 'X' ",
            "      AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "      AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "      AND apb31='",p_afc01,"'",
            "      AND YEAR(pml33)=", p_afc03,
            "      AND apb36='",p_afc04 ,"' ",
            "      AND apb26 ='",p_afc041,"' ",
            "      AND apb35 ='",p_afc042,"' ",
            "      AND apa00 <> '16' AND apa00 <> '15'  )"     #add by MOD-D70009
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
  ELSE
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
           END IF
        END IF
     END IF
  END IF
  PREPARE pre41_1 FROM l_sql
  DECLARE cur41_1 CURSOR FOR pre41_1
  OPEN cur41_1
  FETCH cur41_1 INTO bamt4_1_1
  IF bamt4_1_1 is NULL THEN LET bamt4_1_1 = 0 END IF
  #MOD-CB0162 -- add end --
 
  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file,pmm_file,pmn_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "   AND apa00[1,1]='1' ",
            "   AND apa42 = 'N' AND pmm18 <> 'X' ",
            "   AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "   AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL ",
            "   AND apb31='",p_afc01,"'",
            "   AND pmm31=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' ",                                 #MOD-CB0162 add ,
            "   AND apa00 <> '16' ",                                          #MOD-CB0162 add
            "   AND apa00 <> '15' "                    #add by MOD-D70009
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND pmm32<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre42 FROM l_sql
  DECLARE cur42 CURSOR FOR pre42
  OPEN cur42
  FETCH cur42 INTO bamt4_2
  IF bamt4_2 is NULL THEN LET bamt4_2 = 0 END IF
 
  #MOD-CB0162 -- add start -- #第二段抓16類且不存在1開頭的
  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file,pmm_file,pmn_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "   AND apa00='16' ",
            "   AND apa42 = 'N' AND pmm18 <> 'X' ",
            "   AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "   AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL ",
            "   AND apb31='",p_afc01,"'",
            "   AND pmm31=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' ",
            "   AND apb21||apb22 NOT IN ( ",
            "    SELECT apb21||apb22 ",
            "      FROM apa_file,apb_file,pmm_file,pmn_file",
            "     WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "       AND apa00[1,1]='1' ",
            "       AND apa42 = 'N' AND pmm18 <> 'X' ",
            "       AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "       AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL ",
            "       AND apb31='",p_afc01,"'",
            "       AND pmm31=", p_afc03,
            "       AND apb36='",p_afc04 ,"' ",
            "       AND apb26 ='",p_afc041,"' ",
            "       AND apb35 ='",p_afc042,"' ",
            "       AND apa00 <> '16' AND apa00 <>'15' )"  #add by MOD-D70009
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
  ELSE
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND pmm32<=",p_afc05
           END IF
        END IF
     END IF
  END IF
  PREPARE pre42_1 FROM l_sql
  DECLARE cur42_1 CURSOR FOR pre42_1
  OPEN cur42_1
  FETCH cur42_1 INTO bamt4_2_1
  IF bamt4_2_1 is NULL THEN LET bamt4_2_1 = 0 END IF
  #MOD-CB0162 -- add end --

  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') AND apa42 <> 'Y'",   #MOD-C90192 apa41='Y' -> apa42 <> 'Y' 
            "   AND apa00[1,1]='1' ",
            "   AND (apb06=' ' OR apb06 IS NULL) ",
            "   AND (apb07 IS NULL) ",
            "   AND apb31='",p_afc01,"'",
            "   AND YEAR(apa02)=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' ",                                 #MOD-CB0162 add ,
            "   AND apa00 <> '16' "                                          #MOD-CB0162 add
           ,"   AND apa00 <> '15' "                          #add by MOD-D70009
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre43 FROM l_sql
  DECLARE cur43 CURSOR FOR pre43
  OPEN cur43
  FETCH cur43 INTO bamt4_3
  IF bamt4_3 is NULL THEN LET bamt4_3 = 0 END IF

  #MOD-CB0162 -- add start -- #第二段抓16類且不存在1開頭的
  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') AND apa42 <> 'Y'",   #MOD-C90192 apa41='Y' -> apa42 <> 'Y'
            "   AND apa00='16' ",
            "   AND (apb06=' ' OR apb06 IS NULL) ",
            "   AND (apb07 IS NULL) ",
            "   AND apb31='",p_afc01,"'",
            "   AND YEAR(apa02)=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' ",
            "   AND apb21||apb22 NOT IN ( ",
            "     SELECT apb21||apb22 ",
            "       FROM apa_file,apb_file",
            "      WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') AND apa42 <> 'Y'",   #MOD-C90192 apa41='Y' -> apa42 <> 'Y'
            "        AND apa00[1,1]='1' ",
            "        AND (apb06=' ' OR apb06 IS NULL) ",
            "        AND (apb07 IS NULL) ",
            "        AND apb31='",p_afc01,"'",
            "        AND YEAR(apa02)=", p_afc03,
            "        AND apb36='",p_afc04 ,"' ",
            "        AND apb26 ='",p_afc041,"' ",
            "        AND apb35 ='",p_afc042,"' ",
            "        AND apa00 <> '16' AND apa00 <> '15'  )"  #add by MOD-D70009
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)=",p_afc05
  ELSE
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)<=",p_afc05
           END IF
        END IF
     END IF
  END IF
  PREPARE pre43_1 FROM l_sql
  DECLARE cur43_1 CURSOR FOR pre43_1
  OPEN cur43_1
  FETCH cur43_1 INTO bamt4_3_1
  IF bamt4_3_1 is NULL THEN LET bamt4_3_1 = 0 END IF
  #MOD-CB0162 -- add end --
 
 #LET bamt4 = bamt4_1 + bamt4_2 + bamt4_3                                            #MOD-CB0162 mark
  LET bamt4 = bamt4_1 + bamt4_1_1 + bamt4_2 +bamt4_2_1 + bamt4_3 + bamt4_3_1         #MOD-CB0162 add   

  IF bamt4 < 0 THEN LET bamt4 = 0 END IF
 
  #------------------------------------------
  #(5) AP 已拋傳票(已轉總帳),但未過帳
  #------------------------------------------
  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='N' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '1'",
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' ",
            "   AND aba19 <> 'X' "  #CHI-C80041
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre51 FROM l_sql
  DECLARE cur51 CURSOR FOR pre51
  OPEN cur51
  FETCH cur51 INTO bamt5_1
  IF bamt5_1 is NULL THEN LET bamt5_1 = 0 END IF
 
  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='N' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '2'" ,
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' ",
            "   AND aba19 <> 'X' "  #CHI-C80041
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre52 FROM l_sql
  DECLARE cur52 CURSOR FOR pre52
  OPEN cur52
  FETCH cur52 INTO bamt5_2
  IF bamt5_2 is NULL THEN LET bamt5_2 = 0 END IF
 
  LET bamt5 = bamt5_1 - bamt5_2
  IF bamt5 < 0 THEN LET bamt5 = 0 END IF
 
  #---------------------------------------------
  #(6) AP 已拋傳票已過帳
  #---------------------------------------------
  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='Y' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '1'",
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' "
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre61 FROM l_sql
  DECLARE cur61 CURSOR FOR pre61
  OPEN cur61
  FETCH cur61 INTO bamt6_1
  IF bamt6_1 is NULL THEN LET bamt6_1 = 0 END IF
 
  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='Y' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '2'" ,
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' "
  #MOD-CB0012 -- add start --
  IF g_prog[1,7] = "apmq651" OR g_prog[1,7] = "apmr650" OR g_prog[1,7] = "apmr652" THEN  #CHI-CB0002 add apmr652
     LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
  ELSE
  #MOD-CB0012 -- add end --
     IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
        IF l_afb.afb18 = 'N' THEN #非總額
           IF l_afb.afb09='N' THEN   #不遞延
              LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
           ELSE
              LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
           END IF
        END IF
     END IF
  END IF   #MOD-CB0012 add
  PREPARE pre62 FROM l_sql
  DECLARE cur62 CURSOR FOR pre62
  OPEN cur62
  FETCH cur62 INTO bamt6_2
  IF bamt6_2 is NULL THEN LET bamt6_2 = 0 END IF
 
  LET bamt6 = bamt6_1 - bamt6_2
  IF bamt6 < 0 THEN LET bamt6 = 0 END IF
 
#CHI-CB0002------add------S
  #---------------------------------------------
  #(7) 請購單變更 已確認且未發出之金額
  #--------------------------------------------- 
IF g_prog = 'apmt900' THEN
  LET l_sql="SELECT pnf87a,pnf87b,pml44,pnf07a,pnf07b,pnf86a,pnf86b,pnf04a,pnf04b FROM pnf_file,pne_file,pml_file",
            " WHERE pnf01 = pne01 AND pnf01 = pml01 AND pne01 = pml01",
            " AND pnf03 = pml02 AND pnf02 = pne02 ",
            " AND pne06='Y' AND pneconf = 'N'",
            "   AND (pml16< '6' OR pml16='S' OR pml16='R' OR pml16='W') ",
            "   AND pml90='",p_afc01,"'", 
            "   AND YEAR(pml33)=",p_afc03,
            "   AND pml121='",p_afc04 ,"' ",
            "   AND pml67 ='",p_afc041,"' ",
            "   AND pml12 ='",p_afc042,"' "
  
  IF p_flag = '0' THEN   #第一科目 
     LET l_sql = l_sql CLIPPED,"   AND pml40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pml401='",p_afc02,"'"
  END IF

  IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
     IF l_afb.afb18 = 'N' THEN #非總額
        IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
        ELSE
           LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
        END IF
     END IF
  END IF

  PREPARE pre7 FROM l_sql
  DECLARE cur7 CURSOR FOR pre7

  LET bamt7 = 0

  FOREACH cur7 INTO l_pnf87a,l_pnf87b,l_pml44,l_pnf07a,l_pnf07b,l_pnf86a,l_pnf86b,l_pnf04a,l_pnf04b
         IF cl_null(l_pnf87a) THEN
            LET l_pnf87 = l_pnf87b
         ELSE
            LET l_pnf87 = l_pnf87a
         END IF
         IF cl_null(l_pnf07a) THEN
            LET l_pnf07 = l_pnf07b
         ELSE
            LET l_pnf07 = l_pnf07a
         END IF
         IF cl_null(l_pnf86a) THEN
            LET l_pnf86 = l_pnf86b
         ELSE
            LET l_pnf86 = l_pnf86a
         END IF
         IF cl_null(l_pnf04a) THEN
            LET l_pnf04 = l_pnf04b
         ELSE
            LET l_pnf04 = l_pnf04a
         END IF
     CALL s_umfchk(l_pnf04,l_pnf07,l_pnf86) RETURNING l_i,l_fac
     IF l_i = 1 THEN
        LET g_errno = 'abm-731'
        LET l_fac = 1
     END IF
     IF cl_null(l_pnf87) THEN LET l_pnf87 = 0 END IF
     IF cl_null(l_pml44) THEN LET l_pml44 = 0 END IF
     IF cl_null(l_fac) THEN LET l_fac = 1 END IF
     LET bamt7 = bamt7 + (l_pnf87 *l_fac * l_pml44)
  END FOREACH
  IF cl_null(bamt7) THEN LET bamt7 = 0 END IF
  IF bamt7 < 0 THEN LET bamt7 = 0 END IF
END IF

  #---------------------------------------------
  #(8) 採購單變更 已確認且未發出之金額
  #---------------------------------------------
IF g_prog = 'apmt910' THEN
  LET l_sql="SELECT pnb87a,pnb87b,pmn44,pnb07a,pnb07b,pnb86a,pnb86b,pnb04a,pnb04b ",
            " FROM pnb_file,pna_file,pmn_file,pmn_file",
            " WHERE pnb01 = pna01 AND pnb01 = pmn01 AND pna01 = pmn01 AND pmm01 = pmn01",
            " AND pnb03 = pmn02 AND pnb02 = pna02 ",
            " AND pna05='Y' AND pnaconf = 'N'",
            "   AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
            "   AND pmn16 < '6' ",
            "   AND (pmn24=' ' OR pmn24 IS NULL) AND (pmn25 IS NULL OR pmn25 =0)",
            "   AND pmn98='",p_afc01,"'",
            "   AND pmm31=", p_afc03,
            "   AND pmn96='",p_afc04 ,"' ",
            "   AND (pmn67='",p_afc041,"' OR pmn67 IS NULL) ",
            "   AND pmn122 ='",p_afc042,"' "

  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pmn40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pmn401='",p_afc02,"'"
  END IF

  IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
     IF l_afb.afb18 = 'N' THEN #非總額
        IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
        ELSE
           LET l_sql = l_sql CLIPPED,"   AND pmm32<=",p_afc05
        END IF
     END IF
  END IF

  PREPARE pre8 FROM l_sql
  DECLARE cur8 CURSOR FOR pre8

  LET bamt8 = 0

  FOREACH cur7 INTO l_pnb87a,l_pnb87b,l_pmn44,l_pnb07a,l_pnb07b,l_pnb86a,l_pnb86b,l_pnb04a,l_pnb04b
         IF cl_null(l_pnb87a) THEN
            LET l_pnf87 = l_pnb87b
         ELSE
            LET l_pnf87 = l_pnb87a
         END IF
         IF cl_null(l_pnb07a) THEN
            LET l_pnf07 = l_pnb07b
         ELSE
            LET l_pnf07 = l_pnb07a
         END IF
         IF cl_null(l_pnb86a) THEN
            LET l_pnf86 = l_pnb86b
         ELSE
            LET l_pnf86 = l_pnb86a
         END IF
         IF cl_null(l_pnb04a) THEN
            LET l_pnf04 = l_pnb04b
         ELSE
            LET l_pnf04 = l_pnb04a
         END IF
     CALL s_umfchk(l_pnb04,l_pnb07,l_pnb86) RETURNING l_i,l_fac
     IF l_i = 1 THEN
        LET g_errno = 'abm-731'
        LET l_fac = 1
     END IF
     IF cl_null(l_pnb87) THEN LET l_pnb87 = 0 END IF
     IF cl_null(l_pmn44) THEN LET l_pmn44 = 0 END IF
     IF cl_null(l_fac) THEN LET l_fac = 1 END IF
     LET bamt8 = bamt8 + (l_pnb87 *l_fac * l_pmn44)
  END FOREACH
  IF cl_null(bamt8) THEN LET bamt8 = 0 END IF
  IF bamt8 < 0 THEN LET bamt8 = 0 END IF
END IF
#CHI-CB0002------add------E

 #RETURN TRUE,l_afb.afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6              #CHI-CB0002 mark
  RETURN TRUE,l_afb.afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6,bamt7,bamt8  #CHI-CB0002
 
END FUNCTION
 
######################################################################################
# Descriptions...: 預算耗用計算
# Date & Author..: 08/04/08 By Carrier  #No.FUN-830161
# Usage..........: CALL s_budamt1(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,
#                                p_afc041,p_afc042,p_afc05,p_flag)
# Input PARAMETER: p_afc00    帳套
#                  p_afc01    費用原因
#                  p_afc02    會計科目
#                  p_afc03    會計年度
#                  p_afc04    WBS
#                  p_afc041   部門編號
#                  p_afc042   項目編號
#                  p_afc05    期別
#                  p_flag     #0.第一科目 1.第二科目
# RETURN Code....: bamt1      消耗1
#                  bamt2      消耗2
#                  bamt3      消耗3
#                  bamt4      消耗4
#                  bamt5      消耗5
#                  bamt6      消耗6
######################################################################################
 
FUNCTION s_budamt1(p_afc00,p_afc01,p_afc02,p_afc03,
                   p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE l_state     LIKE type_file.chr1
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE last_bamt   LIKE afc_file.afc06
  DEFINE bamt1       LIKE afc_file.afc06
  DEFINE bamt2       LIKE afc_file.afc06
  DEFINE bamt3       LIKE afc_file.afc06
  DEFINE bamt4       LIKE afc_file.afc06
  DEFINE bamt5       LIKE afc_file.afc06
  DEFINE bamt6       LIKE afc_file.afc06
  DEFINE bamt7       LIKE afc_file.afc06  #CHI-CB0002 add
  DEFINE bamt8       LIKE afc_file.afc06  #CHI-CB0002 add
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  CALL s_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
      #RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6              #CHI-CB0002 mark
       RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6,bamt7,bamt8  #CHI-CB0002
 
  RETURN bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
 
END FUNCTION
 
######################################################################################
# Descriptions...: 預算檢查
# Date & Author..: 08/04/08 By Carrier  #No.FUN-830161
# Usage..........: CALL s_budchk1(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,
#                                p_afc041,p_afc042,p_afc05,p_flag,p_cmd,
#                                p_sum1,p_sum2)
# Input PARAMETER: p_afc00    帳套
#                  p_afc01    費用原因
#                  p_afc02    會計科目
#                  p_afc03    會計年度
#                  p_afc04    WBS
#                  p_afc041   部門編號
#                  p_afc042   項目編號
#                  p_afc05    期別
#                  p_flag     #0.第一科目 1.第二科目
#                  p_cmd      操作 'a' 新增  'u' 修改
#                  p_sum1     原來的金額 a.新增時傳0 u.修改時,傳修改前金額
#                  p_sum2     現在的金額 a.新增/u.修改 傳畫面上當前的金額
# RETURN Code....: l_sw       0-FALSE 失敗  1-TRUE 檢查成功  超限否標准
#                  over_amt   剩余預算金額
#                  last_bamt  預算總金額
#說明:p_cmd/p_sum1/p_sum2的原因,現在預算的計算,是在keyin時判斷
#若為update時,判斷的時機為..當前筆資料還沒有在DB中提交,故DB中SELECT的結果
#為舊的資料,故要去掉舊的金額,再算上新的金額
######################################################################################
 
FUNCTION s_budchk1(p_afc00,p_afc01,p_afc02,p_afc03,
                  p_afc04,p_afc041,p_afc042,p_afc05,p_flag,
                  p_cmd,p_sum1,p_sum2)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE p_cmd       LIKE type_file.chr1
  DEFINE p_sum1      LIKE afc_file.afc06 
  DEFINE p_sum2      LIKE afc_file.afc06 
  DEFINE l_state     LIKE type_file.chr1
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE last_bamt   LIKE afc_file.afc06
  DEFINE over_amt    LIKE afc_file.afc06
  DEFINE bamt1       LIKE afc_file.afc06
  DEFINE bamt2       LIKE afc_file.afc06
  DEFINE bamt3       LIKE afc_file.afc06
  DEFINE bamt4       LIKE afc_file.afc06
  DEFINE bamt5       LIKE afc_file.afc06
  DEFINE bamt6       LIKE afc_file.afc06
  DEFINE bamt7       LIKE afc_file.afc06  #CHI-CB0002 add
  DEFINE bamt8       LIKE afc_file.afc06  #CHI-CB0002 add
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  CALL s_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
      #RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6              #CHI-CB0002 mark
       RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6,bamt7,bamt8  #CHI-CB0002 add
 
  IF cl_null(l_state) OR l_state = '0' THEN
     RETURN FALSE,' ',0
  END IF
 
  IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
  IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF
 
  ##沒有異動金額,則PASS
  #IF p_sum2 = 0 THEN RETURN TRUE,' ',0 END IF
  #-----------------------------------------------
  # 判斷是否超限
  #-----------------------------------------------
 #LET over_amt = last_bamt - bamt1 - bamt2 - bamt3 - bamt4 - bamt5 - bamt6                  #CHI-CB0002 mark 
  LET over_amt = last_bamt - bamt1 - bamt2 - bamt3 - bamt4 - bamt5 - bamt6 - bamt7 - bamt8  #CHI-CB0002
 
  IF p_cmd = 'a' THEN  #新增時
     LET over_amt = over_amt - p_sum2
  END IF
 
  IF p_cmd = 'u' THEN  #修改時
     LET over_amt = over_amt + p_sum1 - p_sum2
  END IF
  ##因為key in時為非確認的資料..僅確認的資料才會有耗用,故不需管舊值
  #IF p_cmd = 'u' THEN
  #   LET over_amt = over_amt - p_sum2
  #END IF
 
  IF l_afb07 = '1' THEN  #預算超限不做控制
     RETURN TRUE,l_afb07,over_amt
  END IF
 
  IF over_amt < 0 THEN  # 預算超限
     IF l_afb07 = '2' THEN
        LET g_errno = 'apm-310'
        #LET over_amt = over_amt * -1
        #LET g_showmsg = p_afc00 CLIPPED,'/',p_afc01 CLIPPED,'/',p_afc02 CLIPPED,'/',
        #                p_afc03 USING '<<<&','/',p_afc04 CLIPPED,'/',
        #                p_afc041 CLIPPED,'/',p_afc042 CLIPPED,'/',p_afc05 USING '<&','/',
        #                over_amt
        #IF g_bgerr THEN
        #   CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05',g_showmsg,'','apm-310',1)
        #ELSE
        #   CALL cl_err(g_showmsg,'apm-310',1)
        #END IF
        #LET over_amt = over_amt * -1
        RETURN TRUE,l_afb07,over_amt
     END IF
     IF l_afb07 = '3' THEN
        LET g_errno = 'apm-310'
        #LET over_amt = over_amt * -1
        #LET g_showmsg = p_afc00 CLIPPED,'/',p_afc01 CLIPPED,'/',p_afc02 CLIPPED,'/',
        #                p_afc03 USING '<<<&','/',p_afc04 CLIPPED,'/',
        #                p_afc041 CLIPPED,'/',p_afc042 CLIPPED,'/',p_afc05 USING '<&','/',
        #                over_amt
        #IF g_bgerr THEN
        #   CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05',g_showmsg,'','apm-310',1)
        #ELSE
        #   CALL cl_err(g_showmsg,'apm-310',1)
        #END IF
        #LET over_amt = over_amt * -1
        RETURN FALSE,l_afb07,over_amt
     END IF
  ELSE                 # 預算未超限
     RETURN TRUE,l_afb07,over_amt
  END IF
 
END FUNCTION
 
######################################################################################
# Descriptions...: 預算計算
# Date & Author..: 08/04/08 By Carrier  #No.FUN-830161
# Usage..........: CALL s_getbug1(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,
#                                p_afc041,p_afc042,p_afc05,p_flag)
# Input PARAMETER: p_afc00    帳套
#                  p_afc01    費用原因
#                  p_afc02    會計科目
#                  p_afc03    會計年度
#                  p_afc04    WBS
#                  p_afc041   部門編號
#                  p_afc042   項目編號
#                  p_afc05    期別
#                  p_flag     #0.第一科目 1.第二科目
# RETURN Code....: l_flag     '1'-FALSE 失敗  '0'-TRUE 檢查成功
#                  l_afb07    控制方式
#                  amt        金額
######################################################################################
 
FUNCTION s_getbug1(p_afc00,p_afc01,p_afc02,p_afc03,
                  p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE l_state     LIKE type_file.chr1
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE last_bamt   LIKE afc_file.afc06
  DEFINE over_amt    LIKE afc_file.afc06
  DEFINE bamt1       LIKE afc_file.afc06
  DEFINE bamt2       LIKE afc_file.afc06
  DEFINE bamt3       LIKE afc_file.afc06
  DEFINE bamt4       LIKE afc_file.afc06
  DEFINE bamt5       LIKE afc_file.afc06
  DEFINE bamt6       LIKE afc_file.afc06
  DEFINE l_flag      LIKE type_file.chr1
  DEFINE l_bookno1   LIKE afa_file.afa01  #帳套1
  DEFINE l_bookno2   LIKE afa_file.afa01  #帳套2
  DEFINE l_aag07     LIKE aag_file.aag07
  DEFINE l_afb       RECORD LIKE afb_file.*
  DEFINE l_afc06     LIKE afc_file.afc06
  DEFINE l_afc07     LIKE afc_file.afc07
  DEFINE l_amt       LIKE afc_file.afc07
  DEFINE l_amt2      LIKE afc_file.afc07   #MOD-C90254
  DEFINE bamt7       LIKE afc_file.afc06   #CHI-CB0002 add
  DEFINE bamt8       LIKE afc_file.afc06   #CHI-CB0002 add
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF cl_null(p_afc00)  THEN LET p_afc00  = ' ' END IF
  IF cl_null(p_afc01)  THEN LET p_afc01  = ' ' END IF
  IF cl_null(p_afc02)  THEN LET p_afc02  = ' ' END IF
  IF cl_null(p_afc03)  THEN LET p_afc03  = ' ' END IF
  IF cl_null(p_afc04)  THEN LET p_afc04  = ' ' END IF
  IF cl_null(p_afc041) THEN LET p_afc041 = ' ' END IF
  IF cl_null(p_afc042) THEN LET p_afc042 = ' ' END IF
  IF cl_null(p_afc05)  THEN LET p_afc05  = ' ' END IF
 
  #aza63 (使用多帳別) & p_flag = '1' 
  IF g_aza.aza63 = 'N' THEN
     IF p_flag = '1' THEN
        RETURN '0','1',0  #ok
     END IF
  END IF
 
  #8個KEY,不能同時為空
  IF p_afc00 IS NULL AND p_afc01 IS NULL AND p_afc02 IS NULL AND
     p_afc03 IS NULL AND p_afc04 IS NULL AND p_afc041 IS NULL AND
     p_afc042 IS NULL AND p_afc05 IS NULL THEN
     LET g_errno = 'agl-230'
     #LET g_showmsg = p_afc00 CLIPPED,'/',p_afc01 CLIPPED,'/',
     #                p_afc02 CLIPPED,'/',p_afc03 USING "<<<<",'/',
     #                p_afc04 CLIPPED,'/',p_afc041 CLIPPED,'/',
     #                p_afc042 CLIPPED,'/',p_afc05 USING "<<"
     #IF g_bgerr THEN
     #   CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05',g_showmsg,'','agl-230',1)  #所有KEY都是空
     #ELSE
     #   CALL cl_err(g_showmsg,'agl-230',1)
     #END IF
     RETURN '1','3',0  #nook
  END IF
 
  #科目標識 0/1
  IF cl_null(p_flag) OR (p_flag NOT MATCHES '[01]') THEN
     RETURN '1','3',0  #nook
  END IF
  LET g_flag = p_flag   #MOD-C90254 
  #若帳套為空,則用年份p_afc03來取帳套
  IF cl_null(p_afc00) THEN
     CALL s_get_bookno(p_afc03) RETURNING l_flag,l_bookno1,l_bookno2
     IF l_flag = '1' THEN  #抓不到帳套
        LET g_errno = 'aoo-081'
        #IF g_bgerr THEN
        #   CALL s_errmsg('afa01',l_bookno1,'','aoo-081',1)
        #ELSE
        #   CALL cl_err(l_bookno1,'aoo-081',1)
        #END IF
        RETURN '1','3',0  #nook
     ELSE
        IF p_flag = '0' THEN  #第一科目
           LET p_afc00 = l_bookno1
        ELSE                  #第二科目
           LET p_afc00 = l_bookno2
        END IF
     END IF
  END IF
 
  SELECT aag07 INTO l_aag07 FROM aag_file WHERE aag01 = p_afc02
                                            AND aag00 = p_afc00
  IF SQLCA.sqlcode OR l_aag07 NOT MATCHES '[123]' THEN 
     LET g_errno = 'agl-001'
     #IF g_bgerr THEN
     #   LET g_showmsg = p_afc00,'/',p_afc02
     #   CALL s_errmsg('aag00,aag01',g_showmsg,'sel aag07','agl-001',1)
     #ELSE
     #   CALL cl_err(p_afc02,'agl-001',1)
     #END IF
     RETURN '1','3',0  #nook
  END IF
 
  IF l_aag07 != '1' THEN  #不為統制帳戶才需抓取afb_file,若為統制帳戶則
                          #抓明細的超限控制方式和遞延否
     CALL s_get_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                       p_afc04,p_afc041,p_afc042,p_afc05,'1')
       RETURNING l_state,l_afb07,l_afc06,l_afc07,l_amt
    #-MOD-C90254-add-
     CALL s_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                   p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
         #RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6              #CHI-CB0002 mark
          RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6,bamt7,bamt8  #CHI-CB0002
     LET l_amt2 = bamt1 + bamt2 + bamt3 + bamt4 + bamt5 + bamt6 
    #-MOD-C90254-end-
    #LET last_bamt = l_afc06 - l_afc07 + l_amt           #MOD-C90254 mark
     LET last_bamt = l_afc06 - l_afc07 + l_amt - l_amt2  #MOD-C90254
     IF l_state = FALSE THEN
        RETURN 1,' ',0  #nook
     ELSE
        RETURN 0,l_afb07,last_bamt
     END IF
  ELSE  #為統制帳戶
     LET g_amt_bug = 0
     LET g_flag_bug = TRUE
     CALL s_budget_loop(p_afc00,p_afc01,p_afc02,p_afc03,
                        p_afc04,p_afc041,p_afc042,p_afc05,'1')
     SELECT * INTO l_afb.* FROM afb_file
      WHERE afb00 = p_afc00
        AND afb01 = p_afc01
        AND afb02 = p_afc02
        AND afb03 = p_afc03
        AND afb04 = p_afc04
        AND afb041= p_afc041
        AND afb042= p_afc042
        AND afbacti = 'Y'      #FUN-D70090
     IF g_flag_bug = FALSE THEN
        RETURN 1,' ',0               #nook
     ELSE
        RETURN 0,l_afb.afb07,g_amt_bug   #ok
     END IF
  END IF
 
END FUNCTION
 
FUNCTION s_get_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                      p_afc04,p_afc041,p_afc042,p_afc05,p_fl)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_fl        LIKE type_file.chr1  #標識
  DEFINE l_afb       RECORD LIKE afb_file.*
  DEFINE l_afc       RECORD LIKE afc_file.*
  DEFINE last_bamt   LIKE afc_file.afc06
  DEFINE b_afc       RECORD LIKE afc_file.*
  DEFINE l_afc06     LIKE afc_file.afc06
  DEFINE l_afc07     LIKE afc_file.afc07
  DEFINE l_amt       LIKE afc_file.afc06
 
  #檢查8個key組成預算方式,在afb_file中是否存在
  SELECT * INTO l_afb.* FROM afb_file
   WHERE afb00 = p_afc00
     AND afb01 = p_afc01
     AND afb02 = p_afc02
     AND afb03 = p_afc03
     AND afb04 = p_afc04
     AND afb041= p_afc041
     AND afb042= p_afc042
     AND afbacti = 'Y'      #FUN-D70090
  IF SQLCA.sqlcode THEN
     LET g_errno = 'agl-231'
     RETURN FALSE,' ',0,0,0
  END IF
  IF cl_null(l_afb.afb18) THEN LET l_afb.afb18 = 'N' END IF  #總額控制
  IF cl_null(l_afb.afb10) THEN LET l_afb.afb10 = 0   END IF  #總年度預算
  IF cl_null(l_afb.afb09) THEN LET l_afb.afb09 = 'N' END IF  #遞延
 
  #檢查8個key組成預算方式,在afc_file中是否存在
  SELECT * INTO l_afc.* FROM afc_file
   WHERE afc00 = p_afc00
     AND afc01 = p_afc01
     AND afc02 = p_afc02
     AND afc03 = p_afc03
     AND afc04 = p_afc04
     AND afc041= p_afc041
     AND afc042= p_afc042
     AND afc05 = p_afc05
  IF SQLCA.sqlcode THEN
     LET g_errno = 'agl-231'
     RETURN FALSE,' ',0,0,0
  END IF
  IF cl_null(l_afc.afc06) THEN LET l_afc.afc06 = 0 END IF
  IF cl_null(l_afc.afc07) THEN LET l_afc.afc07 = 0 END IF
  IF cl_null(l_afc.afc08) THEN LET l_afc.afc08 = 0 END IF
  IF cl_null(l_afc.afc09) THEN LET l_afc.afc09 = 0 END IF
 
  LET l_afc06 = 0
  LET l_afc07 = 0
  LET l_amt   = 0
 
  IF l_afb.afb18 = 'Y' THEN      #做總額控制  -不care期別
     LET l_afc06 = l_afb.afb10
     LET l_amt   = 0
  ELSE
     LET l_afc06 = l_afc.afc06 + l_afc.afc08 + l_afc.afc09
     IF p_fl <> '1' THEN
        LET l_afc07 = l_afc.afc07
     END IF
  END IF
 
  DECLARE sel_afc07_c1 CURSOR FOR
   SELECT * FROM afc_file
    WHERE afc00 = p_afc00
      AND afc01 = p_afc01
      AND afc02 = p_afc02
      AND afc03 = p_afc03
      AND afc04 = p_afc04
      AND afc041= p_afc041
      AND afc042= p_afc042
    ORDER BY afc05
 
  #全年的消耗,則不care 月份
  #非全年,消耗為當月,但要看遞延
  FOREACH sel_afc07_c1 INTO b_afc.*
     IF SQLCA.sqlcode THEN
        LET g_errno = SQLCA.sqlcode
        RETURN FALSE,' ',0,0,0
     END IF
 
     IF l_afb.afb09 = 'Y' AND l_afb.afb18 = 'N' THEN
        IF b_afc.afc05 >= p_afc05 THEN
           EXIT FOREACH
        END IF
     END IF
     IF cl_null(b_afc.afc06) THEN LET b_afc.afc06 = 0 END IF
     IF cl_null(b_afc.afc07) THEN LET b_afc.afc07 = 0 END IF
     IF cl_null(b_afc.afc08) THEN LET b_afc.afc08 = 0 END IF
     IF cl_null(b_afc.afc09) THEN LET b_afc.afc09 = 0 END IF
 
    #IF p_fl = '1' AND b_afc.afc05 = p_afc05 THEN                          #MOD-C50108 mark
     IF p_fl = '1' AND b_afc.afc05 = p_afc05 AND l_afb.afb18 = 'N' THEN    #MOD-C50108 add
        LET b_afc.afc07 = 0
     END IF
 
     IF l_afb.afb18 = 'Y' THEN   #全年消耗
        LET l_afc07 = l_afc07 + b_afc.afc07
     END IF
     IF l_afb.afb09 = 'Y' AND l_afb.afb18 = 'N' THEN  #遞延
        LET l_amt = l_amt + b_afc.afc06 + b_afc.afc08 + b_afc.afc09 - b_afc.afc07
     END IF
  END FOREACH
  RETURN TRUE,l_afb.afb07,l_afc06,l_afc07,l_amt
 
END FUNCTION
 
FUNCTION s_budget_loop(p_afc00,p_afc01,p_afc02,p_afc03,
                       p_afc04,p_afc041,p_afc042,p_afc05,p_fl)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_fl        LIKE type_file.chr1  #標識
  DEFINE l_ac        LIKE type_file.num10
  DEFINE l_i         LIKE type_file.num10
  DEFINE last_bamt   LIKE afc_file.afc06
  DEFINE l_state     LIKE type_file.chr1
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE l_aag       DYNAMIC ARRAY OF RECORD
                     aag01  LIKE aag_file.aag01,
                     aag24  LIKE aag_file.aag24,
                     aag07  LIKE aag_file.aag07 
                     END RECORD
  DEFINE l_afc06     LIKE afc_file.afc06
  DEFINE l_afc07     LIKE afc_file.afc07
  DEFINE l_amt       LIKE afc_file.afc07
  DEFINE bamt1       LIKE afc_file.afc06   #MOD-C90254
  DEFINE bamt2       LIKE afc_file.afc06   #MOD-C90254
  DEFINE bamt3       LIKE afc_file.afc06   #MOD-C90254
  DEFINE bamt4       LIKE afc_file.afc06   #MOD-C90254
  DEFINE bamt5       LIKE afc_file.afc06   #MOD-C90254
  DEFINE bamt6       LIKE afc_file.afc06   #MOD-C90254
  DEFINE l_amt2      LIKE afc_file.afc07   #MOD-C90254
  DEFINE bamt7       LIKE afc_file.afc06   #CHI-CB0002 add
  DEFINE bamt8       LIKE afc_file.afc06   #CHI-CB0002 add
 
  DECLARE s_get_cs CURSOR FOR
   SELECT aag01,aag24,aag07 FROM aag_file,afb_file
    WHERE aag00 = afb00
      AND aag01 = afb02
      AND aag08 = p_afc02
      AND afb00 = p_afc00
      AND afb01 = p_afc01
      AND afb03 = p_afc03
      AND afb04 = p_afc04
      AND afb041= p_afc041
      AND afb042= p_afc042  
      AND afbacti = 'Y'      #FUN-D70090
  LET l_ac = 1
 
  FOREACH s_get_cs INTO l_aag[l_i].*
     IF SQLCA.sqlcode THEN
        EXIT FOREACH
     END IF
     LET l_ac = l_ac + 1
  END FOREACH
 
  FOR l_i = 1 TO l_ac - 1 
     IF l_aag[l_i].aag24 = 99 OR l_aag[l_i].aag07 = '2' THEN  #明細科目
        CALL s_get_budget(p_afc00,p_afc01,l_aag[l_i].aag01,p_afc03,
                          p_afc04,p_afc041,p_afc042,p_afc05,p_fl)
             RETURNING l_state,l_afb07,l_afc06,l_afc07,l_amt
       #-MOD-C90254-add-
        CALL s_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                      p_afc04,p_afc041,p_afc042,p_afc05,g_flag)
            #RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6              #CHI-CB0002 mark
             RETURNING l_state,l_afb07,last_bamt,bamt1,bamt2,bamt3,bamt4,bamt5,bamt6,bamt7,bamt8  #CHI-CB0002
        LET l_amt2 = bamt1 + bamt2 + bamt3 + bamt4 + bamt5 + bamt6 
       #-MOD-C90254-end-
       #LET last_bamt = l_afc06 - l_afc07 + l_amt          #MOD-C90254 mark
        LET last_bamt = l_afc06 - l_afc07 + l_amt - l_amt2 #MOD-C90254
        IF l_state = FALSE THEN
           LET g_flag_bug = FALSE
        END IF
        LET g_amt_bug = g_amt_bug + last_bamt
        LET g_afc06 = g_afc06 + l_afc06
        LET g_afc07 = g_afc07 + l_afc07
        LET g_amt   = g_amt   + l_amt
        CONTINUE FOR
     END IF
 
     CALL s_budget_loop(p_afc00,p_afc01,l_aag[l_i].aag01,p_afc03,
                        p_afc04,p_afc041,p_afc042,p_afc05,p_fl)
  END FOR
END FUNCTION
 
FUNCTION s_bud_exist(p_afc00,p_afc01,p_afc02,p_afc03,
                     p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE l_afb       RECORD LIKE afb_file.*
  DEFINE l_afc       RECORD LIKE afc_file.*
  DEFINE l_flag      LIKE type_file.chr1
  DEFINE l_bookno1   LIKE afa_file.afa01  #帳套1
  DEFINE l_bookno2   LIKE afa_file.afa01  #帳套2
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF cl_null(p_afc00)  THEN LET p_afc00  = ' ' END IF
  IF cl_null(p_afc01)  THEN LET p_afc01  = ' ' END IF
  IF cl_null(p_afc02)  THEN LET p_afc02  = ' ' END IF
  IF cl_null(p_afc03)  THEN LET p_afc03  = ' ' END IF
  IF cl_null(p_afc04)  THEN LET p_afc04  = ' ' END IF
  IF cl_null(p_afc041) THEN LET p_afc041 = ' ' END IF
  IF cl_null(p_afc042) THEN LET p_afc042 = ' ' END IF
  IF cl_null(p_afc05)  THEN LET p_afc05  = ' ' END IF
 
  INITIALIZE l_afb.* TO NULL
  INITIALIZE l_afc.* TO NULL
 
  #8個KEY,不能同時為空
  IF p_afc00 IS NULL AND p_afc01 IS NULL AND p_afc02 IS NULL AND
     p_afc03 IS NULL AND p_afc04 IS NULL AND p_afc041 IS NULL AND
     p_afc042 IS NULL AND p_afc05 IS NULL THEN
     LET g_errno = 'agl-230'
     #LET g_showmsg = p_afc00 CLIPPED,'/',p_afc01 CLIPPED,'/',
     #                p_afc02 CLIPPED,'/',p_afc03 USING "<<<<",'/',
     #                p_afc04 CLIPPED,'/',p_afc041 CLIPPED,'/',
     #                p_afc042 CLIPPED,'/',p_afc05 USING "<<"
     #IF g_bgerr THEN
     #   CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05',g_showmsg,'','agl-230',1)  #所有KEY都是空
     #ELSE
     #   CALL cl_err(g_showmsg,'agl-230',1)
     #END IF
     RETURN FALSE,l_afb.*,l_afc.*
  END IF
 
  #科目標識 0/1
  IF cl_null(p_flag) OR (p_flag NOT MATCHES '[01]') THEN
     RETURN FALSE,l_afb.*,l_afc.*
  END IF
 
  #若帳套為空,則用年份p_afc03來取帳套
  IF cl_null(p_afc00) THEN
     CALL s_get_bookno(p_afc03) RETURNING l_flag,l_bookno1,l_bookno2
     IF l_flag = '1' THEN  #抓不到帳套
        LET g_errno = 'aoo-081'
        #IF g_bgerr THEN
        #   CALL s_errmsg('afa01',l_bookno1,'','aoo-081',1)
        #ELSE
        #   CALL cl_err(l_bookno1,'aoo-081',1)
        #END IF
        RETURN FALSE,l_afb.*,l_afc.*
     ELSE
        IF p_flag = '0' THEN  #第一科目
           LET p_afc00 = l_bookno1
        ELSE                  #第二科目
           LET p_afc00 = l_bookno2
        END IF
     END IF
  END IF
 
  #檢查8個key組成預算方式,在afb_file中是否存在
  SELECT * INTO l_afb.* FROM afb_file
   WHERE afb00 = p_afc00
     AND afb01 = p_afc01
     AND afb02 = p_afc02
     AND afb03 = p_afc03
     AND afb04 = p_afc04
     AND afb041= p_afc041
     AND afb042= p_afc042
     AND afbacti = 'Y'      #FUN-D70090
  IF SQLCA.sqlcode THEN
     LET g_errno = 'agl-231'
     #LET g_showmsg = p_afc00 CLIPPED,'/',p_afc01 CLIPPED,'/',p_afc02 CLIPPED,'/',
     #                p_afc03 USING "<<<&",'/',p_afc04 CLIPPED,'/',
     #                p_afc041 CLIPPED,'/',p_afc042 CLIPPED
     #IF g_bgerr THEN
     #   CALL s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',g_showmsg,'','agl-231',1)
     #ELSE
     #   CALL cl_err(g_showmsg,'agl-231',1)
     #END IF
     RETURN FALSE,l_afb.*,l_afc.*
  END IF
 
  IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
     #檢查8個key組成預算方式,在afc_file中是否存在
     SELECT * INTO l_afc.* FROM afc_file
      WHERE afc00 = p_afc00
        AND afc01 = p_afc01
        AND afc02 = p_afc02
        AND afc03 = p_afc03
        AND afc04 = p_afc04
        AND afc041= p_afc041
        AND afc042= p_afc042
        AND afc05 = p_afc05
     IF SQLCA.sqlcode THEN
        LET g_errno = 'agl-231'
        #LET g_showmsg = p_afc00 CLIPPED,'/',p_afc01 CLIPPED,'/',p_afc02 CLIPPED,'/',
        #                p_afc03 USING '<<<&','/',p_afc04 CLIPPED,'/',
        #                p_afc041 CLIPPED,'/',p_afc042 CLIPPED,'/',p_afc05 USING '<&'
        #IF g_bgerr THEN
        #   CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05',g_showmsg,'','agl-231',1)
        #ELSE
        #   CALL cl_err(g_showmsg,'agl-231',1)
        #END IF
        RETURN FALSE,l_afb.*,l_afc.*
     END IF
  END IF
 
  RETURN TRUE,l_afb.*,l_afc.*
END FUNCTION
 
 
######################################################################################
# Descriptions...: 預算耗用計算
# Date & Author..: 08/04/09 By Carrier  #No.FUN-830161
# Usage..........: CALL s_bug1(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,
#                             p_afc041,p_afc042,p_afc05,p_flag)
# Input PARAMETER: p_afc00    帳套
#                  p_afc01    費用原因
#                  p_afc02    會計科目
#                  p_afc03    會計年度
#                  p_afc04    WBS
#                  p_afc041   部門編號
#                  p_afc042   項目編號
#                  p_afc05    期別
#                  p_flag     #0.第一科目 1.第二科目
# RETURN Code....: state      1.FALSE   0.TRUE
#                  l_afc06    本期預算總金額
#                  l_afc07    本期已消耗金額
#                  l_amt      前期金額若為可遞延則抓取零期到上期預算-巳消耗金額
#                             若不為可遞延則傳回 0
######################################################################################
#No.FUN-840227
FUNCTION s_bug1(p_afc00,p_afc01,p_afc02,p_afc03,
                p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE l_afb       RECORD LIKE afb_file.*
  DEFINE l_afc       RECORD LIKE afc_file.*
  DEFINE b_afc       RECORD LIKE afc_file.*
  DEFINE l_flag      LIKE type_file.chr1
  DEFINE l_exist     LIKE type_file.num5
  DEFINE l_afc06     LIKE afc_file.afc06
  DEFINE l_afc07     LIKE afc_file.afc07
  DEFINE l_amt       LIKE afc_file.afc07
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE l_aag07     LIKE aag_file.aag07
  DEFINE l_state     LIKE type_file.num5
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF cl_null(p_afc00)  THEN LET p_afc00  = ' ' END IF
  IF cl_null(p_afc01)  THEN LET p_afc01  = ' ' END IF
  IF cl_null(p_afc02)  THEN LET p_afc02  = ' ' END IF
  IF cl_null(p_afc03)  THEN LET p_afc03  = ' ' END IF
  IF cl_null(p_afc04)  THEN LET p_afc04  = ' ' END IF
  IF cl_null(p_afc041) THEN LET p_afc041 = ' ' END IF
  IF cl_null(p_afc042) THEN LET p_afc042 = ' ' END IF
  IF cl_null(p_afc05)  THEN LET p_afc05  = ' ' END IF
 
  #aza63 (使用多帳別) & p_flag = '1' 
  IF g_aza.aza63 = 'N' THEN
     IF p_flag = '1' THEN
        RETURN '0',0,0,0
     END IF
  END IF
 
  CALL s_bud_exist(p_afc00,p_afc01,p_afc02,p_afc03,
                   p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
       RETURNING l_exist,l_afb.*,l_afc.*
  IF l_exist = FALSE THEN
     RETURN '1',0,0,0
  ELSE
     LET p_afc00 = l_afb.afb00
  END IF
 
  IF cl_null(l_afb.afb18) THEN LET l_afb.afb18 = 'N' END IF  #總額控制
  IF cl_null(l_afb.afb10) THEN LET l_afb.afb10 = 0   END IF  #總年度預算
  IF cl_null(l_afc.afc06) THEN LET l_afc.afc06 = 0   END IF
  IF cl_null(l_afc.afc08) THEN LET l_afc.afc08 = 0   END IF
  IF cl_null(l_afc.afc09) THEN LET l_afc.afc09 = 0   END IF
  IF cl_null(l_afb.afb09) THEN LET l_afb.afb09 = 'N' END IF
 
  SELECT aag07 INTO l_aag07 FROM aag_file
   WHERE aag00 = p_afc00
     AND aag01 = p_afc02
  IF SQLCA.sqlcode THEN
     IF g_bgerr THEN
        LET g_showmsg = p_afc00,'/',p_afc02
        CALL s_errmsg('aag00,aag01',g_showmsg,'',SQLCA.sqlcode,1)
     ELSE
        CALL cl_err3('sel','aag_file',p_afc00,p_afc02,SQLCA.sqlcode,'','',1)
     END IF
     RETURN '1',0,0,0
  END IF
 
  IF l_aag07 NOT MATCHES '[123]' THEN
     IF g_bgerr THEN
        CALL s_errmsg('aag07',l_aag07,'','agl-001',1)
     ELSE
        CALL cl_err(l_aag07,'agl-001',1)
     END IF
     RETURN '1',0,0,0
  END IF
 
  LET l_afc06 = 0   #本月預算
  LET l_afc07 = 0   #本月耗用
  LET l_amt   = 0   #遞延金額
  LET g_afc06 = 0
  LET g_afc07 = 0
  LET g_amt   = 0
  LET g_flag_bug = TRUE
  IF l_aag07 <> '1' THEN  #明細&獨立
     CALL s_get_budget(p_afc00,p_afc01,p_afc02,p_afc03,
                       p_afc04,p_afc041,p_afc042,p_afc05,'2')
          RETURNING l_state,l_afb07,l_afc06,l_afc07,l_amt
     IF l_state = FALSE THEN
        RETURN '1',0,0,0
     ELSE
        RETURN '0',l_amt,l_afc06,l_afc07
     END IF
  ELSE
     CALL s_budget_loop(p_afc00,p_afc01,p_afc02,p_afc03,
                        p_afc04,p_afc041,p_afc042,p_afc05,'2')
     IF g_flag_bug = FALSE THEN
        RETURN '1',0,0,0
     ELSE
        RETURN '0',g_amt,g_afc06,g_afc07
     END IF
  END IF
 
END FUNCTION
 
