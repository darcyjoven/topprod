# Prog. Version..: '5.30.06-13.03.19(00008)'     #
#
# Program name...: s_javamail.4gl
# Descriptions...: 新增倉庫庫存明細檔(img_file)
# Date & Author..:darcy:2023/02/10 

function s_javamail(
    subject,
    recipient,
    attachment,
    messagebody
)
    define subject,recipient,attachment,messagebody string
    define l_xmlname string
    define l_message string
    define l_cmd string

    let l_xmlname = "/u1/out/mail/",cl_replace_str(FGL_GETPID()," ",""),".xml"
    let l_message = "/u1/out/mail/",cl_replace_str(FGL_GETPID()," ",""),".txt"
    
    # 先删除防止之前的缓存
    run "rm " || l_xmlname
    run "rm " || l_message

    # 组成xml
    run "echo '<Mail>' >> "|| l_xmlname
    run "echo '<Protocol>smtp</Protocol>' >> "||l_xmlname
    run "echo '<CheckAuth>Y</CheckAuth>' >> "||l_xmlname
    run "echo '<MailServer>59.82.44.168</MailServer>' >> "||l_xmlname
    run "echo '<MailServerPort>25</MailServerPort>' >> "||l_xmlname
    run "echo '<MailServerUser>bi@forewin-sz.com.cn</MailServerUser>' >> "||l_xmlname
    run "echo '<MailServerUserPassword>Fly12345678</MailServerUserPassword>' >> "||l_xmlname
    run "echo '<Subject>"||subject||"</Subject>' >> "||l_xmlname
    if not cl_null(messagebody) then
        # 有正文内容
        run "echo '" ||messagebody||"' >> "||l_message
        run "echo '<MessageBody>"||l_message||"</MessageBody>' >> "||l_xmlname
    else
        run "echo '<MessageBody> </MessageBody>' >> "||l_xmlname
    end if
    if not cl_null(attachment) then
        # 有附件
        run "echo '<Attach>"||attachment||"</Attach>' >> "||l_xmlname
    else
        run "echo '<Attach> </Attach>' >> "||l_xmlname
    end if
    run "echo '<Recipient>"||recipient||"</Recipient>' >> "||l_xmlname
    run "echo '<From>bi@forewin-sz.com.cn</From>' >> "||l_xmlname
    run "echo '</Mail>' >> "||l_xmlname

    let l_cmd = "sh /u1/topprod/tiptop/ds4gl2/bin/javamail/UnixMailSender.bat ",l_xmlname," TRUE"
    run l_cmd
    
    let l_cmd = "rm ",l_xmlname
    run l_cmd


end function
