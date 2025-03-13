# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cs_mail.4gl
# Descriptions...: 邮件立即发送系统
# Date & Author..:darcy:2023/03/23

import libmail

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

function cs_mail(
    subject,
    body,
    attachment,
    recipient,
    cc,
    bcc
)
    define subject      string
    define body         string
    define attachment   string
    define recipient    string
    define cc           string
    define bcc          string

    define l_xmlname string
    define l_body    string
    define l_cmd string

    # 临时xml文件名
    let l_xmlname = current year to fraction(3)
    # 正文内容
    let l_body = "/u1/out/mail/",cl_replace_str(l_xmlname," ",""),".html"
    let l_xmlname = "/u1/out/mail/",cl_replace_str(l_xmlname," ",""),".xml"

    run "echo '"||body||"' >> "||l_body

    # 收件人
    if not cl_null(cc) then
        let recipient = recipient + cc
    end if
    if not cl_null(bcc) then
        let recipient = recipient + bcc
    end if


    run "echo '<Mail>' >> "||l_xmlname  
    run "echo '<Protocol>smtp</Protocol>' >> "||l_xmlname
    run "echo '<CheckAuth>Y</CheckAuth>' >> "||l_xmlname
    run "echo '<MailServer>59.82.44.168</MailServer>' >> "||l_xmlname
    run "echo '<MailServerPort>25</MailServerPort>' >> "||l_xmlname
    run "echo '<MailServerUser>bi@forewin-sz.com.cn</MailServerUser>' >> "||l_xmlname
    run "echo '<MailServerUserPassword>Fly12345678</MailServerUserPassword>' >> "||l_xmlname
    run "echo '<Subject>"||subject||"</Subject>' >> "||l_xmlname
    run "echo '<MessageBody>"||l_body||"</MessageBody>' >> "||l_xmlname
    if not cl_null(attachment) then
        run "echo '<Attach>"||attachment||"</Attach>' >> "||l_xmlname
    else
        run "echo '<Attach> </Attach>' >> "||l_xmlname
    end if
    run "echo '<Recipient>"||recipient||"</Recipient>' >> "||l_xmlname
    run "echo '<From>bi@forewin-sz.com.cn</From>' >> "||l_xmlname
    run "echo '</Mail>' >> "||l_xmlname

    let l_cmd = "sh /u1/topprod/tiptop/ds4gl2/bin/javamail/UnixMailSender.bat ",l_xmlname," TRUE"
    run l_cmd

    let l_cmd = "mv ",l_xmlname," /u1/out/mail/posted/"
    run l_cmd
    let l_cmd = "rm ",l_body
    run l_cmd

    return true
end function


# 发送邮件
function cs_mail_send(p_subject,p_body,p_to,p_attach)
    define p_subject,p_body,p_to,p_attach       string
    define l_ok     varchar(10)
    call mailto(p_subject,p_body,p_to,p_attach)
        returning l_ok
    return l_ok
end function

function cs_mail_sendcc(p_subject,p_body,p_to,p_cc,p_bcc,p_attach)
    define p_subject,p_body,p_to,p_cc,p_bcc,p_attach        string
    define l_ok     varchar(10)
    call mailsend(p_subject,p_body,p_to,p_cc,p_bcc,p_attach)
        returning l_ok
    return l_ok
end function

function cs_mail_sendfile(p_subject,p_bodyfile,p_to,p_cc,p_bcc,p_attach)
    define p_subject,p_bodyfile,p_to,p_cc,p_bcc,p_attach        string
    define l_ok     varchar(10)
    call mailsendfile(p_subject,p_bodyfile,p_to,p_cc,p_bcc,p_attach)
        returning l_ok
    return l_ok
end function

-- 返回true/false
function cs_mail_csmi111(p_subject,p_bodyfile,p_attach,p_csmi111)
    define p_subject,p_bodyfile,p_attach        string
    define p_csmi111    like tc_sma_file.tc_sma02
    define l_to,l_cc  varchar(2000)
    define l_ok     varchar(10)

    select tc_sma18,tc_sma19 into l_to,l_cc from tc_sma_file
     where tc_sma01 = 'csmi111' and tc_sma02 = p_csmi111
       and tc_sma20 = 'Y'
    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,1)
        return false
    end if

    call mailsendfile(p_subject,p_bodyfile,l_to,l_cc,'',p_attach)
        returning l_ok
    return l_ok
end function
