# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program Name...: s_chkno.4gl
# Descriptions...: 檢查是否有空白不連續
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-860042 08/06/30 By elle 修改type
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chkno(p_no)
DEFINE p_no    LIKE apk_file.apk28,        #No.FUN-680147 VARCHAR(12)
       l_no    LIKE type_file.chr10,       #LIKE cqa_file.cqa03,        #No.FUN-680147 VARCHAR(8)   #TQC-B90211
       l_c     LIKE type_file.chr1,        #No.FUN-680147 VARCHAR(01)
#       g_errno LIKE ze_file.ze01,          #No.FUN-680147 VARCHAR(10)
#       g_errno VARCHAR(10),          #No.FUN-680147 VARCHAR(10)
	g_errno LIKE type_file.chr10,          #No.TQC-860042
       l_i     LIKE type_file.num5         #No.FUN-680147 SMALLINT  
 
   LET l_no=p_no[5,12]
   IF cl_null(p_no[1,3]) THEN 
      LET g_errno='anm-217'
      RETURN g_errno
   END IF
   IF cl_null(l_no) THEN RETURN g_errno END IF
 
   FOR l_i=1 TO 8
       LET l_c=l_no[l_i,l_i]
       IF cl_null(l_c)  THEN
          LET g_errno='mfg0084'
          RETURN g_errno
       END IF
   END FOR
   RETURN ' '
END FUNCTION
