# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cgot100.4gl
# Descriptions...: CGo程序函数测试程序
# Date & Author..: darcy:2024/04/17

import os
#darcy:2024/04/18 add s---
import libqrbygo
#darcy:2024/04/18 add e---

database ds
globals "../../../tiptop/config/top.global"

define g_argv1,g_argv2  varchar(1000)

MAIN

    options 
        input no wrap
    defer interrupt

    if not cl_user() THEN
        exit program
    end if

    whenever error call cl_err_msg_log
  
    if (not cl_setup("CGO")) then
        exit program
    end if
 
    call cl_used(g_prog,g_time,1)
        returning g_time
    
    let g_argv1 = arg_val(1)
    let g_argv2 = arg_val(2)

    call cgot100_adapter(g_argv1,g_argv2)
 
    call cl_used(g_prog,g_time,2) returning g_time

END MAIN

# 测试入口
function cgot100_adapter(p_prog,p_func)
    define p_prog,p_func  varchar(100)
    define l_success boolean
    define l_cgb02 like cgb_file.cgb02
    define l_cgc09 like cgc_file.cgc09
    define l_cgc10 like cgc_file.cgc10

    case p_prog||"_"||p_func
        when "qrbygo_qrgenerate"
            let l_success = qrbygo_qrgenerate()
        otherwise
            message "no matched"
    end case

    if l_success then
        select cgb02 into l_cgb02 from cgb_file where cgb01 = p_prog
        let l_cgc09 = g_user
        let l_cgc10 = current year to second
        update cgc_file set cgc06 = '2',
               cgc09 = l_cgc09 ,cgc10 = l_cgc10
         where cgc01 = p_prog and cgc04 = p_func
           and cgc02 = l_cgb02
        if sqlca.sqlcode then
            call cl_err("upd cgc_file",sqlca.sqlcode,1)
            return
        end if
    end if
    
end function

function qrbygo_qrgenerate()
    define i integer

    if os.Path.exists("/u1/out/temp_test.png") then
        call os.Path.delete("/u1/out/temp_test.png") returning i
        if not i then
            return false
        end if
    end if
    
    call qrgenerate("darcy","/u1/out/temp_test.png") returning i
    call os.Path.exists("/u1/out/temp_test.png") returning i
    return i
end function
