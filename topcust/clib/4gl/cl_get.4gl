# Prog. Version..: '5.10.07-09.04.27(00009)'     #
#
# Program name...: cl_get.4gl
# Descriptions...: 通过弹窗获取用户输入的值
# Date & Author..:darcy:2023/04/07

database ds
globals "../../../tiptop/config/top.global"

# 获取一个日期
function cl_get_date(p_msg,p_ze01,p_date)
    define p_msg    string
    define p_ze01   like ze_file.ze01
    define p_date   like type_file.dat

    define l_msg    string
    define l_date   like type_file.dat
    define l_ze03   like ze_file.ze03

    let l_msg = cl_get_msg(p_msg,p_ze01)

    open window w_get_date with form "clib/42f/cl_get_date" 
        
                        # attribute(style="show_log", TEXT="Warning")
        # call cl_ui_init()
        input l_date,l_ze03  from todo,ze03
            
            before input
                let l_date = p_date
                let l_ze03 = l_msg
                display  l_ze03 to ze03
 
        end input
    
    close window w_get_date

    return l_date

end function

# 组合错误消息
function cl_get_msg(p_msg,p_ze01)
    define p_msg    string
    define p_ze01   like ze_file.ze01

    # define l_ze03   like ze_file.ze02
    define l_msg    string

    let l_msg = cl_getmsg(p_ze01,g_lang)

    if l_msg.getIndexOf("%",1) then
        return cl_replace_err_msg(l_msg, p_msg)
    end if
    let l_msg = p_msg ,"\n", l_msg
    return l_msg
end function

function cl_get_num(p_msg,p_ze01,p_num)
    define p_msg    string
    define p_ze01   like ze_file.ze01
    define p_num    like type_file.num15_3

    define l_msg    string
    define l_num    like type_file.num15_3
    define l_ze03   like ze_file.ze03

    let l_msg = cl_get_msg(p_msg,p_ze01)

    open window w_get_num with form "clib/42f/cl_get_num" 
        
                        # attribute(style="show_log", TEXT="Warning")
        # call cl_ui_init()
        input l_num,l_ze03  from todo,ze03
            
            before input
                let l_num = p_num
                let l_ze03 = l_msg
                display  l_ze03 to ze03
        end input
    
    close window w_get_num

    return l_num
end function
