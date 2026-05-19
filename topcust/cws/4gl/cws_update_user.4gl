# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_update_user.4gl
# Descriptions...: 更新用户信息
# Date & Author..: 2026/05/19 darcy add

database ds

GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"

function cws_update_user()
    whenever error continue

    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037
    if g_status.code = "0" then
        call cws_update_user_process()
    end if

    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_update_user_process()
    define l_master,l_detail            om.DomNode
    define i,j,k,l_cnt                  integer
    define l_user                       varchar(20)

    let l_cnt = aws_ttsrv_getMasterRecordLength('UpdateUser')
    if l_cnt = 0 then
        let g_status.code = '-1'
        let g_status.description = "no recordset processed!"
        return
    end if

    let l_master = aws_ttsrv_getMasterRecord(1,"UpdateUser")

    let l_user = aws_ttsrv_getRecordField(l_master,"user")

    call cws_update_user_reset(l_user)

end function

function cws_update_user_reset(p_user)
    define p_user           varchar(20)
    define l_cnt            integer
    define l_zxacti         varchar(1)
    define l_zx         record
        zx10        like zx_file.zx10,
        zx16        like zx_file.zx16,
        zx17        like zx_file.zx17
    end record

    select count(*) into l_cnt from zx_file where zx01 = p_user
    if l_cnt = 0 then
        let g_status.code = '-1'
        let g_status.description = "账号不存在!"
        return
    end if

    select zxacti into l_zxacti from zx_file
     where zx01 = p_user
    if l_zxacti = 'N' then
        let g_status.code = '-1'
        let g_status.description = "账号已禁止使用!"
        return
    end if

    initialize l_zx.* to null
    let l_zx.zx16 = g_today
    let l_zx.zx17 = 0
    let l_zx.zx10 = cl_user_encode(p_user)

    update zx_file set zx16 = l_zx.zx16,zx17=l_zx.zx17,zx10 = l_zx.zx10
     where zx01 = p_user
    if sqlca.sqlcode then
        let g_status.code = sqlca.sqlcode
        let g_status.description = "更新密码失败!"
        return
    end if
    let g_status.description = "密码已重置为工号。"
end function
