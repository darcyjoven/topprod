# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.MOD-670080 06/07/18 By Smapmin 將訊息改由p_ze來維護
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_gxf11desc(p_status)
  DEFINE p_status	LIKE type_file.num5     #FUN-680107 SMALLINT
  DEFINE l_str   	LIKE type_file.chr8     #FUN-680107 VARCHAR(8)
  #-----MOD-670080---------
  CASE p_status
       WHEN '0'
           CALL cl_getmsg('anm-081',g_lang) RETURNING l_str
       WHEN '1'
           CALL cl_getmsg('sub-069',g_lang) RETURNING l_str
       WHEN '2'
           CALL cl_getmsg('anm-638',g_lang) RETURNING l_str
       WHEN '3'
           CALL cl_getmsg('anm-282',g_lang) RETURNING l_str
       WHEN '4'
           CALL cl_getmsg('anm-082',g_lang) RETURNING l_str
  END CASE
  #CASE g_lang
  #     WHEN '0'
  #        CASE WHEN p_status=0 LET l_str='存入'
  #             WHEN p_status=1 LET l_str='質押'
  #             WHEN p_status=2 LET l_str='解除質押'
  #             WHEN p_status=3 LET l_str='解約'
  #             OTHERWISE EXIT CASE
  #        END CASE
  #     WHEN '2'
  #        CASE WHEN p_status=0 LET l_str='存入'
  #             WHEN p_status=1 LET l_str='質押'
  #             WHEN p_status=2 LET l_str='解除質押'
  #             WHEN p_status=3 LET l_str='解約'
  #             OTHERWISE EXIT CASE
  #        END CASE
  #     OTHERWISE
  #        CASE WHEN p_status=0 LET l_str='存入'
  #             WHEN p_status=1 LET l_str='質押'
  #             WHEN p_status=2 LET l_str='解除質押'
  #             WHEN p_status=3 LET l_str='解約'
  #             OTHERWISE EXIT CASE
  #        END CASE
  #END CASE
  #-----END MOD-670080-----
  RETURN l_str
END FUNCTION
