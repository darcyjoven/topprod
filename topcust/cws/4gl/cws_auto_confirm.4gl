# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: cws_auto_confirm.4gl
# Descriptions...: 自动审核中段函数
# Date & Author..:darcy:2023/04/06 add

database ds

globals "../../../tiptop/config/top.global"

function cws_auto_confirm(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    let g_success = 'Y'

    case p_prog
    when 'cxmt520'
        call cws_auto_cxmt520(p_prog,p_docno)
    when 'cpmi252'
        call cws_auto_cpmi252(p_prog,p_docno)
    when 'cpmi262'
        call cws_auto_cpmi252(p_prog,p_docno)
    when 'apmi255'
        call cws_auto_apmi255(p_prog,p_docno)
    when 'apmi265'
        call cws_auto_apmi255(p_prog,p_docno)
    otherwise
        return true
    end case
    if g_success = 'Y' then
        return true
    else
        return false
    end if

end function

function cws_auto_cxmt520(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    call t520sub_y_chk(p_docno)
    if g_success = 'Y' then
        call t520sub_y_upd(p_docno,true)
    end if
end function

function cws_auto_asfi301(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like sfb_file.sfb01
    
end function

function cws_auto_cpmi252(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    call i255sub_y_upd(p_docno,"confirm",true)

end function

function cws_auto_apmi255(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    let g_action_choice = "efconfirm"
    if p_prog = 'apmi255' then 
        call apmi255sub_y_upd(p_docno,"efconfirm",'1',true)
    end if
    if p_prog = 'apmi265' then
        call apmi255sub_y_upd(p_docno,"efconfirm",'2',true)
    end if
end function
