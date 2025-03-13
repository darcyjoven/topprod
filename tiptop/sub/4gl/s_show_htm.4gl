# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: s_show_htm.4gl
# Descriptions...: 限制htm文件到浏览器
# Date & Author..: darcy:2023/10/19
# Usage..........: CALL cl_show_help() 

 
IMPORT os   #No:TQC-9B0186

DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
DEFINE mc_std_id           LIKE smb_file.smb01            #No.FUN-750068
 
# Descriptions...: 顯示程式的說明文件
# Date & Author..: 2003/08/08 by Hiko
# Input Parameter: none
# Return code....: void
# Memo...........: 
 
FUNCTION s_show_help(p_tc_rel01)
    DEFINE   ls_help_url     STRING,
                ls_fglasip      STRING,
                ls_help_path    STRING   
    DEFINE   lc_zz011        LIKE zz_file.zz011
    DEFINE   g_cnt           LIKE type_file.num10  
    DEFINE   l_cmd,ls_sys    STRING
    define   p_tc_rel01     like tc_rel_file.tc_rel01

    LET ls_fglasip = FGL_GETENV("FGLASIP")

    LET ls_help_url = ls_fglasip.trim(), "/tiptop/help/",g_lang CLIPPED, "/",
                          'release/',p_tc_rel01 CLIPPED, ".htm"

    IF NOT cl_open_url(ls_help_url) THEN
        CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
    END IF
END FUNCTION

