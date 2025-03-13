# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_chkdbs.4gl
# Descriptions...: 
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_chkdbs(p_usr,p_plant,p_lang)	# 檢查使用者是否有權限access資料庫
   DEFINE p_usr	        LIKE zxy_file.zxy01          #No.FUN-680147 VARCHAR(10) # 使用者
   DEFINE p_plant	LIKE zxy_file.zxy03          #No.FUN-680147 VARCHAR(10) # 工廠別
   DEFINE p_lang	LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
   DEFINE n1    	LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
   LET n1=0
   SELECT COUNT(*) INTO n1 FROM zxy_file
    WHERE zxy01=p_usr AND (zxy03='ALL' OR zxy03='all' OR zxy03=p_plant)
   IF STATUS <> 0 OR n1 IS NULL THEN
      LET n1=0
   END IF
   ##NO:6016
   IF n1 > 0 THEN RETURN TRUE 
   ELSE 
       CALL cl_err(g_user,'sub-118',1)
#      CASE
#          WHEN p_lang='0' 
#                    CALL cl_err('使用者無存取本資料庫權限!','!',-1) #中文
#          WHEN p_lang='1' 
#                    CALL cl_err('No authority to access database!','!',-1)  #英文
#          WHEN p_lang='2'
#                    CALL cl_err('使用者無存取本資料庫權限!','!',-1) #簡體
#      END CASE
      RETURN FALSE
   END IF
   ##NO:6016
END FUNCTION
