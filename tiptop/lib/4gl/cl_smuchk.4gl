# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program Name...: cl_smuchk.4gl
# Descriptions...: 檢查g_user是否對p_slip有p_priv權限
# Input Parameter: p_slip,p_priv
# Return Code....: True:有權限 False:無權限
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds    #FUN-7C0053
 
FUNCTION cl_smuchk(p_slip,p_priv)   
 
   DEFINE p_slip	LIKE smu_file.smu01          #No.FUN-690005  VARCHAR(3) # 單別
   DEFINE p_priv	LIKE type_file.chr1          #No.FUN-690005  VARCHAR(1)		# 權限
   DEFINE l_n		LIKE type_file.num10         #No.FUN-690005  INTEGER 
 
   ERROR "Check authorization error"
   RETURN TRUE
 
   SELECT COUNT(*) INTO l_n FROM smu_file
          WHERE smu01=p_slip                  AND smu03=p_priv
   IF l_n=0 THEN RETURN TRUE END IF
   SELECT COUNT(*) INTO l_n FROM smu_file
          WHERE smu01=p_slip AND smu02=g_user AND smu03=p_priv
   IF l_n=0 THEN
      CALL cl_err('',9005,0) RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
