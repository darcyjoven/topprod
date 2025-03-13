# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Library name...: cl_get_err_msg()
# Descriptions...: 將陣列g_err_msg內的內容組成字串型式回傳
# Input parameter: 
#                  
# Return code....: 
# Date & Author..: #FUN-AC0060 10/12/31 By Mandy
#---------------------------------------------------------------------------------------------
# Modify.........: #FUN-AC0060 11/07/05 By Mandy PLM GP5.1追版至GP5.25 以上為GP5.1單號

DATABASE ds        #FUN-AC0060

GLOBALS "../../config/top.global"

FUNCTION cl_get_err_msg()
    DEFINE l_msg      STRING          
    DEFINE l_i        LIKE type_file.num5

    WHENEVER ERROR CALL cl_err_msg_log
    FOR l_i = 1 TO g_err_msg.getLength() 
         LET l_msg= l_msg CLIPPED," MESSAGE ROW(",l_i USING '&&#',")",
                    " fld1 = '",g_err_msg[l_i].fld1 CLIPPED,"'",
                    " fld2 = '",g_err_msg[l_i].fld2 CLIPPED,"'",
                    " fld3 = '",g_err_msg[l_i].fld3 CLIPPED,"'",
                    " fld4 = '",g_err_msg[l_i].fld4 CLIPPED,"'",
                    " fld5 = '",g_err_msg[l_i].fld5 CLIPPED,"'"
    END FOR
    RETURN l_msg
END FUNCTION

