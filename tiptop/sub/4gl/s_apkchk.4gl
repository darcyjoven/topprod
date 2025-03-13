# Prog. Version..: '5.30.06-13.03.27(00003)'     #
#
# Pattern name...: s_apkchk.4gl
# Descriptions...: 傳入發票字頭,並檢查其正確性
# Date & Author..: 96/10/14 By Joanne Chen
# Usage..........: CALL s_apkchk(p_amb01,p_amb02,p_amb03,p_amb04)
#                       RETURNING l_errno,l_msg
# Input Parameter: p_amb01      發票年
#                  p_amb02      發票月
#                  p_amb03      字軌 
#                  p_amb04      格式 
# Return code....: l_errno      錯誤訊息號碼 
#                  l_msg        錯誤訊息
# Modify.........: No.MOD-610093 06/01/16 By Smapmin IF p_amb04 = 'XX' THEN RETURN 
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-960223 09/06/19 By baofei 修改g_errno的預設值為‘ ’
# Modify.........: No.MOD-D30067 13/03/08 By Polly 發票格式為26者，一律比照21格式檢核
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE
      l_amb RECORD LIKE amb_file.*
 
DEFINE   g_msg           LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(72)
FUNCTION s_apkchk(p_amb01,p_amb02,p_amb03,p_amb04)
  DEFINE  p_amb01 LIKE amb_file.amb01,
	  p_amb02 LIKE amb_file.amb02,
	  p_amb03 LIKE amb_file.amb03,
	  p_amb04 LIKE amb_file.amb04
 
#    LET g_errno='0'     #MOD-960223 
    LET g_errno = ' ' #MOD-960223  
    LET g_msg=' '
 
    IF g_apz.apz07 = 'N' THEN RETURN g_errno,g_msg END IF
    IF g_apz.apz07 = 'N' THEN RETURN g_errno,g_msg END IF
   #-----MOD-610093---------
    IF p_amb04 = 'XX' THEN
       RETURN g_errno,g_msg
    END IF
   #-----END MOD-610093-----
   #------------MOD-D30067----------(S)
   #發票格式為26者，一徑比照21格式檢核
    IF p_amb04 = '26' THEN
       LET p_amb04 = '21'
    END IF
   #------------MOD-D30067----------(E)
#讀取發票字頭檔之資料並檢查年別 
    SELECT UNIQUE amb01  INTO l_amb.amb01
      FROM amb_file
     WHERE amb01=p_amb01
    IF SQLCA.SQLCODE!=0  THEN
       IF SQLCA.SQLCODE=100 THEN
          LET g_errno='1' 
          CALL cl_err('','sub-001',1)   #NO:7418
       ELSE
          CALL cl_err('(s_apkchk):',SQLCA.SQLCODE,1)
          LET g_errno=SQLCA.SQLCODE USING '-------'
          CALL cl_err('','sub-002',1)   #NO:7418
       END IF 
       RETURN g_errno,g_msg
    END IF
#讀取發票字頭檔之資料並檢查年別+月
    SELECT UNIQUE amb01  INTO l_amb.amb01
      FROM amb_file
     WHERE amb01=p_amb01
       AND p_amb02 between amb02 and amb07
    IF SQLCA.SQLCODE!=0  THEN
       IF SQLCA.SQLCODE=100 THEN
          LET g_errno='2' 
           LET g_msg = 'sub-003'   #NO:7418 #No.MOD-480431
       ELSE
          CALL cl_err('(s_apkchk):',SQLCA.SQLCODE,1)
          LET g_errno=SQLCA.SQLCODE USING '-------'
           LET g_msg = 'sub-002'   #NO:7418 #No.MOD-480431
       END IF 
       RETURN g_errno,g_msg
    END IF
#讀取發票字頭檔之資料並檢查年別+月+字軌
    SELECT UNIQUE amb01  INTO l_amb.amb01
      FROM amb_file
     WHERE amb01=p_amb01
       AND p_amb02 between amb02 and amb07
       AND amb03=p_amb03
    IF SQLCA.SQLCODE!=0  THEN
       IF SQLCA.SQLCODE=100 THEN
          LET p_amb02=p_amb02+1
          SELECT UNIQUE amb01  INTO l_amb.amb01
            FROM amb_file
           WHERE amb01=p_amb01
             AND p_amb02 between amb02 and amb07
             AND amb03=p_amb03
          IF SQLCA.SQLCODE!=0  THEN
            IF SQLCA.SQLCODE=100 THEN
               LET g_errno='3' 
                LET g_msg = 'sub-004'  #NO:7418 #No.MOD-480431
            ELSE
              CALL cl_err('(s_apkchk):',SQLCA.SQLCODE,1)
              LET g_errno=SQLCA.SQLCODE USING '-------'
               LET g_msg = 'sub-002'   #No.7418 #No.MOD-480431
            END IF 
            RETURN g_errno,g_msg
          END IF 
       ELSE
          CALL cl_err('(s_apkchk):',SQLCA.SQLCODE,1)
          LET g_errno=SQLCA.SQLCODE USING '-------'
           LET g_msg = 'sub-002'   #No.7418 #No.MOD-480431
          RETURN g_errno,g_msg
       END IF 
    END IF
#讀取發票字頭檔之資料並檢查年別+月+字軌+格式
    SELECT *  INTO l_amb.*
      FROM amb_file
     WHERE amb01=p_amb01
       AND p_amb02 between amb02 and amb07
       AND amb03=p_amb03
       AND amb04=p_amb04
    IF SQLCA.SQLCODE  THEN
       IF SQLCA.SQLCODE=100 THEN
          LET g_errno='4' 
           LET g_msg = 'sub-005'   #No.7418 #No.MOD-480431
       ELSE
         CALL cl_err('(s_apkchk):',SQLCA.SQLCODE,1)
         LET g_errno=SQLCA.SQLCODE USING '-------'
          LET g_msg = 'sub-002'   #No.7418 #No.MOD-480431
       END IF 
    END IF
    RETURN g_errno,g_msg
END FUNCTION
