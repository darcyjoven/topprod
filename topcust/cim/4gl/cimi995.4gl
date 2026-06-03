database ds

GLOBALS "../../../tiptop/config/top.global"

main

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("CIM")) THEN
       EXIT PROGRAM
    END IF

    call doaction()
    --call remark()
end main

--
function doaction()
    if cl_action(g_prog,'MISC',1,'confirm','52948','',false) then
        message 'OK'
    end if
    if cl_action(g_prog,'MISC',2,'post','52948','',true) then
        message 'OK'
    end if
    if cl_action(g_prog,'MISC',3,'xxx','52948','',true) then
        message 'OK'
    end if

    if cl_action(g_prog,'MISC',2,'post','','',true) then
        message 'OK'
    end if

end function
--
function remark()
    call cl_remark('aeci100','xybtest',0)
    call cl_remark_chk('aeci100','xybtest',0)
    call cl_remark_show('aeci100','xybtest',0)
end function
