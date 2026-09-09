# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_mail.4gl
# Descriptions...: 单身汇出excle
# Date & Author..: darcy

# 邮件服务配置在 /u1/usr/mail.conf

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../4gl/cl_mail.global"

-- 发送邮件
function cl_mail(p_mail)
    define  p_mail      mail
    define  l_ok        boolean

    return l_ok
end function

-- 背景执行
function cl_mail_no_wait(p_mail)
    define  p_mail      mail
end function

-- 背景执行进度邮件 string
private function cl_mail_process()
end function

-- 前端数据调用 string
private function cl_mail_gui()
end function
