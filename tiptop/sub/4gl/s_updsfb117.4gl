# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_updsfb117 
# Descriptions...: 計算委外工單FQC在驗量
# Date & Author..: 01/05/03 By Tommy 
# Memo...........: No.+036:
#                  FQC = 送驗量 - (已入庫-工單退庫)
#                     --> 送驗量 = QC未確認 + QC已確認且<>'2'
# Modify.........: No.MOD-530712 05/03/30 By Mandy s_updsfb117.4gl  l_sfb02 <> '7' 應增加 8 委外重工之考量
# Modify ........: No.FUN-670091 06/08/02 By rainy cl_err=>cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.MOD-6B0094 06/12/27 By claire 應只列入rvb19=1 採購單收貨
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_updsfb117(p_sfb01)
 DEFINE p_sfb01       LIKE sfb_file.sfb01
 DEFINE l_rvb07       LIKE rvb_file.rvb07
 DEFINE l_rvv17_i     LIKE rvv_file.rvv17
 DEFINE l_rvv17_o     LIKE rvv_file.rvv17
 DEFINE l_sfb11       LIKE sfb_file.sfb11
 DEFINE l_sfb02       LIKE sfb_file.sfb02
 
 
   IF cl_null(p_sfb01) THEN LET g_success = 'N' RETURN END IF
   SELECT sfb02 INTO l_sfb02
     FROM sfb_file
    WHERE sfb01=p_sfb01 AND sfb87!='X'
   IF STATUS THEN LET g_success='N' RETURN END IF
   #IF l_sfb02 <>'7' THEN RETURN END IF               #MOD-530712
    IF l_sfb02 NOT MATCHES '[78]' THEN RETURN END IF  #MOD-530712
 
   #收貨-已確認
   SELECT SUM(rvb07) INTO l_rvb07
     FROM rvb_file,rva_file
    WHERE rvb34 = p_sfb01
      AND rvb01=rva01
   #  AND rvb11=0     #非委外代買
      AND rvb19='1'  #非委外代買  #MOD-6B0094 add
      AND rva10='SUB' #委外
      AND rvaconf ='Y' 
   IF SQLCA.sqlcode OR STATUS THEN LET l_rvb07 = 0 END IF
   IF cl_null(l_rvb07) THEN LET l_rvb07 = 0 END IF
   
   #已入庫並確認
   SELECT SUM(rvv17) INTO l_rvv17_i
     FROM rvv_file,rvu_file,rva_file,rvb_file
    WHERE rvu00 = '1'   #入庫
      AND rvv18 = p_sfb01
      AND rvuconf = 'Y'
      AND rvv01=rvu01
      AND rvv04=rvb01
      AND rvv05=rvb02
   #  AND rvb11=0    #非委外代買
      AND rvb19='1'  #非委外代買  #MOD-6B0094 add
      AND rva01=rvb01 AND rvaconf ='Y'
      AND rva10='SUB'
   IF SQLCA.sqlcode OR STATUS THEN LET l_rvv17_i = 0 END IF
   IF cl_null(l_rvv17_i) THEN LET l_rvv17_i = 0 END IF
 
   # 驗退已確認 
   SELECT SUM(rvv17) INTO l_rvv17_o
     FROM rvv_file,rvu_file,rva_file,rvb_file
    WHERE rvu00 = '2'   #入庫
      AND rvv18 = p_sfb01
      AND rvuconf = 'Y' 
      AND rvv01=rvu01
      AND rvv04=rvb01
      AND rvv05=rvb02
   #  AND rvb11=0    #非委外代買
      AND rvb19='1'  #非委外代買  #MOD-6B0094 add
      AND rva01=rvb01 AND rvaconf ='Y'
      AND rva10='SUB'
   IF SQLCA.sqlcode OR STATUS THEN LET l_rvv17_o = 0 END IF
   IF cl_null(l_rvv17_o) THEN LET l_rvv17_o = 0 END IF
 
   LET l_sfb11 = l_rvb07 - l_rvv17_i - l_rvv17_o
 
   UPDATE sfb_file
      SET sfb11 = l_sfb11
    WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      #CALL cl_err('s_updsfb117:',SQLCA.sqlcode,0)  #FUN-670091
      CALL cl_err3("upd","sfb_file",p_sfb01,"",SQLCA.sqlcode,"","",0)  #FUN-670091
      LET g_success = 'N'
   END IF
   #End No.+036
 
END FUNCTION
