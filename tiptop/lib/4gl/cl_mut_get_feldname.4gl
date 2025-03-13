# Prog. Version..: '5.30.06-13.03.12(00000)"     #
# Library name...: cl_mut_get_feldname
# Descriptions...: 依序取出p_feldname內的欄位名稱
# Input parameter: p_f01,p_f03,p_f05,p_f07,p_f09,p_f11 欄位代碼
#                  p_f02,p_f04,p_f06,p_f08,p_f10,p_f12 欄位值
# Return code....: l_msg 欄位說明
# Date & Author..: #FUN-AA0035 10/10/27 By Mandy

DATABASE ds        #FUN-AA0035

GLOBALS "../../config/top.global"

FUNCTION cl_mut_get_feldname(p_f01,p_f02,p_f03,p_f04,p_f05,p_f06,p_f07,p_f08,p_f09,p_f10,p_f11,p_f12)
  DEFINE p_f01,p_f03,p_f05,p_f07,p_f09,p_f11  LIKE  gaq_file.gaq01
  DEFINE p_f02,p_f04,p_f06,p_f08,p_f10,p_f12  LIKE  gaq_file.gaq03
  DEFINE l_f01,l_f03,l_f05,l_f07,l_f09,l_f11  LIKE  gaq_file.gaq03
  DEFINE l_msg   STRING

  WHENEVER ERROR CALL cl_err_msg_log

  LET l_f01=NULL   
  LET l_f03=NULL  
  LET l_f05=NULL  
  LET l_f07=NULL   
  LET l_f09=NULL  
  LET l_f11=NULL
  CALL cl_get_feldname(p_f01,g_lang) RETURNING l_f01
  CALL cl_get_feldname(p_f03,g_lang) RETURNING l_f03
  CALL cl_get_feldname(p_f05,g_lang) RETURNING l_f05
  CALL cl_get_feldname(p_f07,g_lang) RETURNING l_f07
  CALL cl_get_feldname(p_f09,g_lang) RETURNING l_f09
  CALL cl_get_feldname(p_f11,g_lang) RETURNING l_f11
  IF NOT cl_null(l_f01)  THEN
      LET l_msg = l_f01 CLIPPED,":",p_f02 CLIPPED
  END IF
  IF NOT cl_null(l_f03)  THEN
      LET l_msg = l_msg," + ",l_f03 CLIPPED,":",p_f04  CLIPPED
  END IF
  IF NOT cl_null(l_f05)  THEN
      LET l_msg = l_msg," + ",l_f05 CLIPPED,":",p_f06  CLIPPED
  END IF
  IF NOT cl_null(l_f07)  THEN
      LET l_msg = l_msg," + ",l_f07 CLIPPED,":",p_f08  CLIPPED
  END IF
  IF NOT cl_null(l_f09)  THEN
      LET l_msg = l_msg," + ",l_f09 CLIPPED,":",p_f10  CLIPPED
  END IF
  IF NOT cl_null(l_f11) THEN
      LET l_msg = l_msg," + ",l_f11 CLIPPED,":",p_f12  CLIPPED
  END IF
  RETURN l_msg

END FUNCTION

