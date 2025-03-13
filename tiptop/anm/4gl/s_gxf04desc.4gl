# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_gxf04desc(p_status)
  DEFINE p_status	LIKE type_file.num5     #FUN-680107 SMALLINT
  DEFINE l_str   	LIKE type_file.chr8     #FUN-680107 VARCHAR(8)
  CASE g_lang 
     WHEN '0'
          CASE WHEN p_status=1 LET l_str='月付'
               WHEN p_status=2 LET l_str='到期整付'
               OTHERWISE EXIT CASE
          END CASE
     WHEN '2'
          CASE WHEN p_status=1 LET l_str='月付'
               WHEN p_status=2 LET l_str='到期整付'
               OTHERWISE EXIT CASE
          END CASE
     OTHERWISE
          CASE WHEN p_status=1 LET l_str='月付'
               WHEN p_status=2 LET l_str='到期整付'
               OTHERWISE EXIT CASE
          END CASE
  END CASE
  RETURN l_str
END FUNCTION
