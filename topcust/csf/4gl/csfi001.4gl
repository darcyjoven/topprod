database ds
 
globals "../../../tiptop/config/top.global" 

define g_arg1,g_arg2    string
 
main
    options                                #?????????
        input no wrap
    defer interrupt                        #?????, ?????
 
    if (not cl_user()) then
        exit program
    end if
    
    whenever error call cl_err_msg_log
    
    if (not cl_setup("CIM")) then
        exit program
    end if
    
    call  cl_used(g_prog,g_time,1) returning g_time
    let g_arg1 = ARG_VAL(1)
    let g_arg2 = ARG_VAL(2)

    call cs_csmi113(g_arg1,g_arg2)
    
    call  cl_used(g_prog,g_time,2) returning g_time
end main
