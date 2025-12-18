# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_tool.4gl
# Descriptions...: 实用工具函数，lib函数不能调用除lib之外的任何函数，防止依赖过多
# Date & Author..: darcy:2025/12/18
DATABASE ds
 
GLOBALS "../../config/top.global"

-- 临时日志
-- 不方便debug的时候，用来日志记录错误和flag的函数
function cl_temp_log(p_prog,p_error,p_msg)
    define p_prog       varchar(100)
    define p_error      boolean
    define p_msg        string
    define l_time       varchar(20)
    define l_path       string
    define l_cmd        string
    define l_msg        string

    let l_time = current year to second
    
    let l_path = FGL_GETENV("TEMPDIR")

    let l_path = l_path , "/" , sfmt("cws-temp-%1%2%3",year(today) mod 100 using '&&',month(today) using '&&',day(today) using '&&') ,".log"
    
    if  p_error then
        let l_msg = sfmt("[%1 %2 ERROR]: %3",p_prog,l_time,p_msg)
    else
        let l_msg = sfmt("[%1 %2]: %3",p_prog,l_time,p_msg)
    end if
    let l_cmd = "echo '"||l_msg||"' >> "||l_path

    run l_cmd
end function
