# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_cmbinf.4gl
# Descriptions...: 招商銀行的網絡接口
# Date & Author..: 07/03/29 By yoyo
# Usage..........: LET g_str = cl_cmbinf(l_para,"GetAccInfoA",g_sql,"|")
# Input parameter: p_method	呼叫的方法名
#                  p_para	傳入的參數
#                  p_sep        傳入的分隔符 
# Return code....: l_data	返回的數據.
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
import com
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS "../../aws/4gl/cmbinfService_cmbinf.inc"
 
FUNCTION cl_cmbinf(p_loginstr,p_method,p_para,p_sep)
DEFINE
    p_loginstr STRING,
    p_method STRING,
    p_sep    STRING,
    para1    STRING,
    para2    STRING,
    p_para   STRING,
    l_status STRING,
    l_data   STRING,
    i,j      LIKE type_file.num5,
    tok      base.StringTokenizer
 
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF p_method IS NULL THEN
       RETURN "1",p_sep clipped,"the method can't be null"
    END IF
    IF p_sep IS NULL THEN
       LET p_sep = '|'
    END IF
    IF p_para IS NOT NULL THEN
       LET tok = base.StringTokenizer.create(p_para,p_sep)
       LET i = 1
       WHILE tok.hasMoreTokens()
         IF i = 1 THEN
            LET para1 = tok.nextToken()
         END IF
         IF i = 2 THEN
            LET para2 = tok.nextToken()
         END IF
         LET i = i+1
       END WHILE
    END IF
    
    LET l_data=NULL 
#   CALL fgl_ws_setOption("http_invoketimeout", 6000)    
#   CALL WebService_cmbinfService_cmbinf_connect(p_method,p_sep,para1,para2) 
    CALL com.WebServiceEngine.setOption("http_invoketimeout",6000)
    CALL connect(p_loginstr,p_method,p_sep,para1,para2) 
      RETURNING l_status,l_data
    IF l_status != "0" THEN
       DISPLAY "webservice wrong:",wserror.code,":",wserror.description
       LET l_data = "1",p_sep CLIPPED,"webservice wrong:",wserror.code,":",wserror.description
       RETURN l_data
    END IF
     
    RETURN l_data           
    
END FUNCTION
