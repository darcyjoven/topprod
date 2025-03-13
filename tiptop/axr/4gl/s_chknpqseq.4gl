# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_chknpqseq(p_no,p_seq,p_sys,p_bookno)		# 檢查分錄底稿正確否       #No.FUN-740009
   DEFINE p_no		LIKE type_file.chr20    #No.FUN-680123 VARCHAR(20)  # 單號
   DEFINE p_seq   	LIKE type_file.num5     #No.FUN-680123 SMALLINT  # 單號-序號
   DEFINE p_sys		LIKE npq_file.npqsys    # Prog. Version..: '5.30.06-13.03.12(02)	 # 系統別:AP/AR/NM
   DEFINE p_bookno      LIKE aza_file.aza81     #No.FUN-740009
   DEFINE amtd,amtc	LIKE type_file.num20_6  #No.FUN-680123 DEC(20,6) #FUN-4C0013
   DEFINE l_t1		LIKE npq_file.npq00     #No.FUN-680123 VARCHAR(5)   # No.FUN-550071
   DEFINE l_dmy3	LIKE type_file.chr1     #No.FUN-680123 VARCHAR(1)
   DEFINE n1,n2		LIKE type_file.num5     #No.FUN-680123 SMALLINT
   DEFINE l_npq RECORD  LIKE npq_file.*
   DEFINE l_aag RECORD  LIKE aag_file.*
 
   LET g_success='Y'
#   LET l_t1=p_no[1,3]
   LET l_t1=s_get_doc_no(p_no)          #No.FUN-550071
{
   CASE WHEN p_sys='AP'
             SELECT apydmy3 INTO l_dmy3 FROM apy_file WHERE apyslip = l_t1
        WHEN p_sys='AR'
             SELECT ooydmy1 INTO l_dmy3 FROM ooy_file WHERE ooyslip = l_t1
        WHEN p_sys='NM'
             SELECT nmydmy3 INTO l_dmy3 FROM nmy_file WHERE nmyslip = l_t1
        WHEN p_sys='FA'
             SELECT fahdmy3 INTO l_dmy3 FROM fah_file WHERE fahslip = l_t1
   END CASE
}
   LET l_dmy3 = 'Y'
   IF SQLCA.sqlcode THEN 
      CALL cl_err('sel apy/ooy/nmy:',SQLCA.SQLCODE,1) LET g_success='N' RETURN 
   END IF
   SELECT sum(npq07) INTO amtd FROM npq_file 
          WHERE npq01 = p_no AND npq06 = '1' #--->借方合計
            AND npqsys = p_sys AND npq011 = p_seq
   IF STATUS THEN 
#     CALL cl_err('sel sum(npq07)',STATUS,1)    #No.FUN-660116
      CALL cl_err3("sel","npq_file",p_no,p_sys,STATUS,"","sel sum(npq07)",1)   #No.FUN-660116
      LET g_success='N'
   END IF
   SELECT sum(npq07) INTO amtc FROM npq_file 
          WHERE npq01 = p_no AND npq06 = '2' #--->貸方合計
            AND npqsys = p_sys AND npq011 = p_seq
   IF STATUS THEN 
#     CALL cl_err('sel sum(npq07)',STATUS,1)    #No.FUN-660116
      CALL cl_err3("sel","npq_file",p_no,p_sys,STATUS,"","sel sum(npq07)",1)   #No.FUN-660116
      LET g_success='N'
   END IF
   IF amtd IS NULL THEN LET amtd = 0 END IF 
   IF amtc IS NULL THEN LET amtc = 0 END IF 
   #-->單別不產生分錄, 不可有分錄
   IF l_dmy3 = 'N' THEN
      IF (amtd >0 OR amtc > 0) THEN
         CALL cl_err(p_no,'mfg9310',1) LET g_success='N'
      END IF
      RETURN
   END IF
   #-->必須要有分錄
   IF (amtd = 0 OR amtc=0) THEN
      CALL cl_err(p_no,'aap-261',1) LET g_success='N'
   END IF
   #-->借貸要平
   IF amtd != amtc THEN
      CALL cl_err(p_no,'aap-058',1) LET g_success='N'
   END IF
   #-->科目要對
   SELECT COUNT(*) INTO n1 FROM npq_file
          WHERE npq01 = p_no AND npqsys = p_sys AND npq011 = p_seq
   SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
          WHERE npq01 = p_no AND npqsys = p_sys AND npq011 = p_seq
            AND npq03= aag01 AND aag03='2'  AND aag07 IN ('2','3')
            AND aag00 = p_bookno       #No.FUN-740009
   IF n1<>n2 THEN
      CALL cl_err(p_no,'aap-262',1) LET g_success='N'
   END IF
 
## No:2406 modify 1998/08/26 ----------------------------
   DECLARE npq_cur CURSOR FOR
    SELECT npq_file.*,aag_file.*
      FROM npq_file,OUTER aag_file 
     WHERE npq01 = p_no  AND npq011 = p_seq
       AND npqsys = p_sys 
       AND npq03=aag_file.aag01
       AND aag00 = p_bookno       #No.FUN-740009
     IF STATUS THEN CALL cl_err('decl cursor',STATUS,1) 
      LET g_success='N'
      RETURN
   END IF
   
   FOREACH npq_cur INTO l_npq.*,l_aag.*
 
## ( 若科目有部門管理者,應check部門欄位 )
      IF l_aag.aag05='Y' AND  #部門明細管理
         cl_null(l_npq.npq05) 
         THEN 
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-287',1)
      END IF
 
## ( 若科目有異動碼管理者,應check異動碼欄位 )
      IF (l_aag.aag151='2' OR     #異動碼-1控制方式 
         l_aag.aag151='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq11)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag161='2' OR     #異動碼-1控制方式 
         l_aag.aag161='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq12)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag171='2' OR     #異動碼-1控制方式 
         l_aag.aag171='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq13)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag181='2' OR     #異動碼-1控制方式 
         l_aag.aag181='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq14)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
   END FOREACH
## ------------------------------------------------------
END FUNCTION
