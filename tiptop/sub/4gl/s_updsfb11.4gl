# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_updsfb11 
# Descriptions...: 計算工單FQC在驗量
# Date & Author..: 01/05/03 By Tommy 
# Memo...........: No.+036:
#                       FQC = 送驗量 - (已入庫-工單退庫)
#                         --> 送驗量 = QC未確認 + QC已確認且<>'2'
# Modify.........: No.FUN-550012 05/05/25 By pengu FQC單號改放工單完工入庫單身
# Modify.........; NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_updsfb11(p_sfb01)
 DEFINE p_sfb01       LIKE sfb_file.sfb01
 DEFINE l_sfv09_in    LIKE sfv_file.sfv09
 DEFINE l_sfv09_out   LIKE sfv_file.sfv09
 DEFINE l_qc_nofirm   LIKE qcf_file.qcf091
 DEFINE l_qc_firm     LIKE qcf_file.qcf091
 DEFINE l_sfb11       LIKE sfb_file.sfb11
 DEFINE l_sfb94       LIKE sfb_file.sfb94
 
 
   IF cl_null(p_sfb01) THEN LET g_success = 'N' RETURN END IF
 
   SELECT sfb94 INTO l_sfb94
     FROM sfb_file
    WHERE sfb01 = p_sfb01 AND sfb87 !='X'
   IF SQLCA.sqlcode OR STATUS THEN
      LET l_sfb94 = 'N'
   END IF
   IF cl_null(l_sfb94) OR l_sfb94 = 'N' THEN RETURN END IF
 
   # QC未確認
   SELECT SUM(qcf22) INTO l_qc_nofirm
     FROM qcf_file,sfb_file
    WHERE qcf14 = 'N' 
      AND qcf22 > 0 
      AND sfb01 = p_sfb01
      AND qcf02 = sfb01 
      AND sfb94='Y'     #No.+370 010705 by linda add
      AND qcf00='1'     #No.+370 010705 by linda add
   IF SQLCA.sqlcode OR STATUS THEN LET l_qc_nofirm = 0 END IF
   IF cl_null(l_qc_nofirm) THEN LET l_qc_nofirm = 0 END IF
   
   # QC已確認且判定結果不為退貨
   SELECT SUM(qcf091) INTO l_qc_firm
     FROM qcf_file,sfb_file
    WHERE qcf14 = 'Y' 
      AND qcf09 <> '2'
      AND qcf22 > 0 
      AND sfb01 = p_sfb01
      AND qcf02 = sfb01
      AND sfb94='Y'        #No.+370 010705 by linda add
      AND qcf00='1'        #No.+370 010705 by linda add
   IF SQLCA.sqlcode OR STATUS THEN LET l_qc_firm = 0 END IF
   IF cl_null(l_qc_firm) THEN LET l_qc_firm = 0 END IF
 
   # 工單入庫已確認且扣帳 
   SELECT SUM(sfv09) INTO l_sfv09_in 
     FROM sfu_file,sfv_file,sfb_file,qcf_file
    WHERE sfu00 = '1'
      AND qcf22 > 0
      AND sfupost = 'Y'
      AND sfu01 = sfv01
      AND sfv11 = sfb01 
      AND sfb01 = p_sfb01
      AND sfb01 = qcf02
      AND sfv17 = qcf01       #No.+370 010705 by linda add    #FUN-550012
      #AND sfu03 = qcf01       #No.+370 010705 by linda add   #FUN-550012 
      AND sfb94='Y'           #No.+370 010705 by linda add
      AND qcf00='1'           #No.+370 010705 by linda add
   IF SQLCA.sqlcode OR STATUS THEN LET l_sfv09_in = 0 END IF
   IF cl_null(l_sfv09_in) THEN LET l_sfv09_in = 0 END IF
 
   # 工單退庫已確認且扣帳 
   SELECT SUM(sfv09) INTO l_sfv09_out
     FROM sfu_file,sfv_file,sfb_file,qcf_file
    WHERE sfu00 = '2'
      AND qcf22 > 0
      AND sfupost = 'Y'
      AND sfu01 = sfv01
      AND sfv11 = sfb01 
      AND sfb01 = p_sfb01
      AND sfb01 = qcf02
      AND sfv17 = qcf01       #No.+370 010705 by linda add    #FUN-550012
      #AND sfu03 = qcf01       #No.+370 010705 by linda add   #FUN-550012
      AND sfb94='Y'           #No.+370 010705 by linda add
      AND qcf00='1'           #No.+370 010705 by linda add
   IF SQLCA.sqlcode OR STATUS THEN LET l_sfv09_out = 0 END IF
   IF cl_null(l_sfv09_out) THEN LET l_sfv09_out = 0 END IF
 
   LET l_sfb11 = (l_qc_nofirm+l_qc_firm)-(l_sfv09_in-l_sfv09_out)
   #No.+399 010711 add by linda
   IF l_sfb11 <0 THEN
       LET l_sfb11=0
   END IF
   #No.+399 end---
   UPDATE sfb_file
      SET sfb11 = l_sfb11
    WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      #CALL cl_err('s_updsfb11:',SQLCA.sqlcode,0)  #FUN-670091
      CALL cl_err3("upd","sfb_file",p_sfb01,"",SQLCA.sqlcode,"","",0)  #FUN-670091
      LET g_success = 'N'
   END IF
   #End No.+036
 
END FUNCTION
