# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_detype.4gl
# Descriptions...: 將獨立性需求的需求類別轉換為中文
# Date & Author..: 93/03/22 By Apple
# Usage..........: CALL s_detype(p_code) RETURNING l_sts
# Input Parameter: p_code  需求特性 
# Return code....: l_sts   需求特性說明
# Memo...........: 英文版時,請將l_sta的長度加長變成(C20),及畫面上的
#                  欄位長度亦同時修改之。
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #No.FUN-680147 
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_detype(p_code)
   DEFINE  p_code   LIKE type_file.num5,         #No.FUN-680147 SMALLINT
           l_sta    LIKE ze_file.ze03            #No.FUN-680147 VARCHAR(20)
   LET l_sta = " "
   IF cl_null(p_code)THEN RETURN l_sta END IF
   CASE p_code
		WHEN  1  CALL cl_getmsg('ams-108',g_lang) RETURNING l_sta
		WHEN  2  CALL cl_getmsg('ams-109',g_lang) RETURNING l_sta
		WHEN  3  CALL cl_getmsg('ams-110',g_lang) RETURNING l_sta
		WHEN  4  CALL cl_getmsg('ams-111',g_lang) RETURNING l_sta
		WHEN  5  CALL cl_getmsg('ams-112',g_lang) RETURNING l_sta
		WHEN  6  CALL cl_getmsg('ams-113',g_lang) RETURNING l_sta
		WHEN  7  CALL cl_getmsg('ams-114',g_lang) RETURNING l_sta
		WHEN  8  CALL cl_getmsg('ams-115',g_lang) RETURNING l_sta
		WHEN  9  CALL cl_getmsg('ams-116',g_lang) RETURNING l_sta
		WHEN  10 CALL cl_getmsg('ams-117',g_lang) RETURNING l_sta
		WHEN  11 CALL cl_getmsg('ams-118',g_lang) RETURNING l_sta
		WHEN  12 CALL cl_getmsg('ams-119',g_lang) RETURNING l_sta
		WHEN  13 CALL cl_getmsg('ams-120',g_lang) RETURNING l_sta
		WHEN  14 CALL cl_getmsg('ams-121',g_lang) RETURNING l_sta
		WHEN  15 CALL cl_getmsg('ams-122',g_lang) RETURNING l_sta
		WHEN  16 CALL cl_getmsg('ams-123',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
