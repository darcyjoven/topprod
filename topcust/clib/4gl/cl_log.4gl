# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_log.4gl
# Descriptions...: 程式資料log檔
# Date & Author..: 05/01/25 by saki

database ds
 
globals "../../../tiptop/config/top.global"


# 将日志记录为文件内容
# 文件名称为 g_prog + 日期
function cl_log_string(p_str)
    define p_str string

    define l_cmd string
    
    let l_cmd = "echo '",p_str,"' >> ",cl_log_filename()
    run l_cmd
end function



function cl_log_filename()
    return FGL_GETENV("TEMPDIR")||"/"||g_prog||"-"||year(g_today)||month(g_today)||day(g_today)||".log"
end function
