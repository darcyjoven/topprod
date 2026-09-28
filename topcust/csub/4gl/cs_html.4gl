# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cs_html.4gl
# Descriptions...: 产生html功能
# Date & Author..: darcy:2024/09/29

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

type cbox record
            val     string,
            des     string
    end record
define g_buf    base.StringBuffer

function cs_html_init(p_title,p_subtitle)
    define p_title      string
    define p_subtitle   string

    let g_buf = base.StringBuffer.create()
    # head 
    call g_buf.append(cs_html_head())

    call g_buf.append("    <table style=\"border: none;\">")
    # 标题
    call g_buf.append(sfmt("        <tr style=\"border: none;\">
                                        <td style=\"border: none;text-align: center;\">
                                            <h2 class=\"center\">%1</h2>
                                        </td>
                                    </tr>\n",p_title)) 
    # 副标题
    call g_buf.append(sfmt("        <tr style=\"border: none;\">
                                        <td style=\"border: none;text-align: center;\">
                                            <span>%1</span>
                                        </td>
                                    </tr>\n",p_subtitle)) 

    # 生成参数
    call g_buf.append(sfmt("        <tr style=\"border: none;\">
                                        <td style=\"border: none;text-align: center;\">
                                            <span>生成时间：%1 操作员：%2 部门：%3</span>
                                            <hr>
                                        </td>
                                    </tr>\n",
                    cs_html_now(),cs_html_user(),cs_html_partment()))

end function

# 新增单头，可以运行多个
function cs_html_main(p_desc,p_value)
    define  p_desc   dynamic array of string
    define  p_value   dynamic array of string

    define l_desc,l_value   string 
    define l_cnt,i  integer

    let l_cnt = p_desc.getlength()
    if l_cnt < p_value.getlength() then
        let l_cnt = p_value.getlength()
    end if
    call g_buf.append("        <tr style=\"border: none;\">
            <td style=\"border: none;\">
                <div class=\"container\">")
    for i = 1 to l_cnt
        if i > p_desc.getLength() then
            let l_desc = ""
        else
            let l_desc = p_desc[i]
        end if
        if i > p_value.getLength() then
            let l_value = ""
        else
            let l_value = p_value[i]
        end if
        call g_buf.append(sfmt("<div><span>%1：</span><span>%2</span></div>\n",l_desc,l_value))
    end for

    call g_buf.append("                </div>\n                <hr>\n            </td>\n        </tr>\n")
end function

# 新增一笔单身，可以运行多个
function cs_html_detail(p_title,p_table,p_value)
    define p_title      string
    define p_table      dynamic array of string
    define p_value      dynamic array with dimension 2 of string

    define l_cnt,i,j    integer
    define l_desc,l_value       string

    call g_buf.append("        <tr style=\"border: none;\">
            <td style=\"border: none;\">\n")
    call g_buf.append("                <table>\n")
    # 表格标题
    call g_buf.append(sfmt("<caption>%1</caption>\n",p_title))

    let l_cnt = p_table.getLength()
    if p_value.getLength() > 0 then
        if l_cnt < p_value[1].getLength() then
            let l_cnt = p_value[1].getLength()
        end if
    end if
    # 栏位标题
    call g_buf.append("<thead>\n<tr>\n")
    # 写入标题
    for i = 1 to l_cnt
        if p_table.getLength() < i then
            let l_desc = ""
        else
            let l_desc = p_table[i]
        end if
        call g_buf.append(sfmt("<th>%1</th>\n",l_desc))
    end for
    call g_buf.append("</tr>\n</thead>\n")

    # 写入资料
    for i = 1 to p_value.getLength()
        call g_buf.append("<tr>\n")
        for j = 1 to p_value[i].getLength()
            if j > p_value[i].getLength() then
                let l_value = ""
            else
                let l_value = p_value[i,j]
            end if
            call g_buf.append(sfmt("<td>%1</td>\n",l_value))
        end for
        call g_buf.append("</tr>\n")
    end for
    call g_buf.append("                </table>\n")
    call g_buf.append("                <hr>
            </td>
        </tr>")
end function

# 返回产生的html字符串
function cs_html_end()
    call g_buf.append(cs_html_footer())
    return g_buf.toString()
end function

function cs_html_write(p_filepath)
    define p_filepath   string
    if cl_null(p_filepath) then
        return
    end if
    call g_buf.append(cs_html_footer())
    run "echo '"||cs_html_end()||"' >> "||p_filepath
end function

private function cs_html_now()
    return current year to second
end function
private function cs_html_user()
    define l_gen02 like gen_file.gen02

    select gen02 into l_gen02 from gen_file where gen01 = g_user 
    return g_user||"-"||l_gen02
end function
private function cs_html_partment()
    define l_gem02 like gem_file.gem02

    select gem02 into l_gem02 from gem_file where gem01 = g_grup
    return g_grup||"-"||l_gem02
end function

# 头部
private function cs_html_head()
    return '<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" lang="en">

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Email</title>
    <style>
        body {
            font-family: "Consolas", "微软雅黑", monospace;
            margin: 0 80px;
            /* 两边空余80px空白 */
        }

        .center {
            text-align: center;
            font-weight: normal;
            /* 标题不要粗体 */
        }

        h1 {
            font-size: 24px;
            /* 标题字体小一点 */
        }

        h2 {
            font-size: 20px;
            /* 副标题字体小一点 */
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table,
        th,
        td {
            border: 1px solid black;
        }

        th,
        td {
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .container {
            overflow: hidden;
            /* 清除浮动 */
        }

        .container div {
            float: left;
            /* 设置浮动 */
            margin: 5px;
            /* 设置间距 */
            padding: 10px;
            /* 设置内边距 */
        }
    </style>
</head>

<body>'
end function 
# 尾部
private function cs_html_footer()
    return "    </table>
</body>
</html>"
end function 


# function test_mail()

#     call cs_html_init(cl_get_progname(g_prog,g_lang),"这个是p_admin_wo作业导出的格式样式测试")
#     call test_mail_main(ui.Interface.getRootNode(),"sfb01_q,sgm03_q,sgm01_q")
#     call test_mail_detail(ui.Interface.getRootNode(),"sfb02,sfb81,sfb87,sfb01,sfb44,",base.typeinfo.create(g_sfb_excel))   
#     run "echo '"||cs_html_end()||"' >> /u1/topprod/tiptop/doc/help/2/czz/mail.html"
# end function

# 传入作业的ui.Interface.getRootNode()，和单档需要显示field，用 , 隔开
function cs_html_main_field(p_node,p_field)
    define p_field  string
    define p_node   om.DomNode

    define tok base.StringTokenizer
    define l_desc,l_value string
    define l_n1     om.DomNode
    define l_nlist  om.NodeList
    define l_descList,l_valueList dynamic array of string
    define l_cnt    integer
    define l_n2     om.DomNode
    define l_field  record
            val         string,
            combobox    dynamic array of cbox
    end record

    let tok = base.StringTokenizer.create(p_field,",")
    while tok.hasMoreTokens() 
        initialize l_field.* to null
        let l_desc = "" let l_value = ""
        let l_field.val =  tok.nextToken()
        call p_node.selectByPath(sfmt("//FormField[@colName=\"%1\"]",l_field.val))
            returning l_nlist
        if l_nlist.getLength() = 0 then
            # 如果找不到node,直接继续下一个
            continue while
        end if

        let l_n2 = l_nlist.item(1)
        # combobox 处理
        let l_field.combobox = cs_html_comobox(l_n2)
        call l_n2.getAttribute("value") returning l_value
        let l_value = cs_html_comobox_convert(l_value,l_field.*)
        # desc 说明
        call l_n2.getPrevious() returning l_n1
        if l_n1 is null then
            # 找不到Label
            goto _write
        else
            # 查看是否是Label标签
            if l_n1.getTagName() != "Label" then
                if l_n1.getTagName() == "Button" then
                    # 可能是超链接，向前找一个
                    call l_n1.getPrevious() returning l_n1
                    if l_n1 is null or l_n1.getTagName() != "Label" then
                        goto _write
                    end if
                end if
            end if
            call l_n1.getAttribute("text") returning l_desc
        end if

        label _write:
            let l_cnt = l_descList.getlength() + 1
            let l_descList[l_cnt] = l_desc
            let l_valueList[l_cnt] = l_value
    end while

    call cs_html_main(l_descList,l_valueList)
end function

# 传入作业的ui.Interface.getRootNode()，和单档需要显示field，用 , 隔开 ， 传入单身资料的二维数组
function cs_html_detail_field(p_node,p_field,p_value)   
    
    define p_field          string
    define p_node,p_value   om.DomNode

    define tok base.StringTokenizer
    define l_field,l_desc,l_value,l_title string
    define l_descList   dynamic array of string
    define l_fieldList dynamic array of record
            val         string,
            combobox    dynamic array of cbox
    end record
    define l_combobox   cbox
    define l_valueList  dynamic array with dimension 2 of string
    define l_page       string
    define l_n1,l_n2,l_n3,l_n4      om.DomNode
    define l_nlist          om.NodeList
    define i,j,k            integer
    define l_cnt,l_cnt2            integer
    define l_n5,l_n6,l_n7        om.DomNode
    
    let tok = base.StringTokenizer.create(p_field,",")
    # 先获取第一个token，来获取对应的Table
    if tok.hasMoreTokens() then
        let l_field = tok.nextToken()
        call p_node.selectByPath(sfmt("//TableColumn[@colName=\"%1\"]",l_field))
            returning l_nlist
        if l_nlist.getlength() == 0 then
            # 第一个field找不到直接不处理
            return
        end if

        let l_n1 = l_nlist.item(1)
        let l_n1 = l_n1.getParent()
        # 父节点不是Table也不处理
        if l_n1 is null then
            return
        end if
        let l_page = l_n1.getAttribute("name")
        if cl_null(l_page) then return end if
        # 继续找父节点page，看看能否找到
        let l_n2 = l_n1.getParent()
        if l_n2 is null or l_n2.getTagName() != "Page" then
            let l_title = ""
        else
            let l_title = l_n2.getAttribute("text")
        end if
    else
        # field 为控，什么都不处理
        return
    end if

    # field和title设置
    call l_fieldList.clear()
    call l_descList.clear()

    # 处理combobox情况
    let l_n5 = l_nlist.item(1)
    let l_fieldList[1].combobox = cs_html_comobox(l_n5)
    let l_fieldList[1].val = l_field
    let l_descList[1] = l_n5.getAttribute("text")

    # call l_n5.getFirstChild() returning l_n4
    # if l_n4 is not null then
    #     if l_n4.getTagName() == "ComboBox" then
    #         call l_fieldList[1].combobox.clear()
    #         for k = 1 to l_n4.getChildCount()
    #             let l_n7 = l_n4.getChildByIndex(k)
    #             if l_n7 is null or l_n7.getTagName() != "Item" then
    #                 continue for
    #             end if
    #             initialize l_combobox.* to null
    #             let l_combobox.val = l_n7.getAttribute("name")
    #             let l_combobox.des = l_n7.getAttribute("text")
    #             let l_fieldList[1].combobox[l_fieldList[1].combobox.getLength() + 1].* = l_combobox.*
    #         end for
    #     end if
    # end if

    while tok.hasMoreTokens()
        let l_field = "" let l_desc = ""

        let l_field = tok.nextToken()
        if cl_null(l_field) then
            continue while
        end if

        call p_node.selectByPath(sfmt("//Table[@name=\"%1\"]/TableColumn[@colName=\"%2\"]",l_page,l_field))
            returning l_nlist
        if l_nlist is null or l_nlist.getlength() == 0 then
            #找不到就不处理
            continue while
        end if
        
        # 处理combobox情况
        let l_cnt = l_fieldList.getLength() + 1
        let l_n5 = l_nlist.item(1)
        let l_fieldList[l_cnt].val = l_field
        let l_fieldList[l_cnt].combobox = cs_html_comobox(l_n5)
        let l_descList[l_cnt] = l_n5.getAttribute("text")

        # call l_n5.getFirstChild() returning l_n4
        # if l_n4 is not null then
        #     if l_n4.getTagName() == "ComboBox" then
        #         call l_fieldList[l_cnt].combobox.clear()
        #         for k = 1 to l_n5.getChildCount()
        #             let l_n4 = l_n5.getChildByIndex(k)
        #             if l_n4 is null or l_n4.getTagName() != "Item" then
        #                 continue for
        #             end if
        #             initialize l_combobox.* to null
        #             let l_combobox.val = l_n4.getAttribute("name")
        #             let l_combobox.des = l_n4.getAttribute("text")
        #             let l_cnt2 = l_fieldList[l_cnt].combobox.getlength() + 1
        #             let l_fieldList[l_cnt].combobox[l_cnt2].* = l_combobox.*
        #         end for
        #     end if
        # end if
    end while

    # 值获取
    call l_valueList.clear()
    for i = 1 to p_value.getChildCount()
        # 第 i 行
        let l_n3 = p_value.getChildByIndex(i)
        for j = 1 to l_fieldList.getlength()
            call l_n3.selectByPath(sfmt("//Record/Field[@name=\"%1\"]",l_fieldList[j].val))
                returning l_nlist
            if l_nlist is null or l_nlist.getlength() == 0 then
                let l_valueList[i,j] = ""
            else
                let l_n6 = l_nlist.item(1)
                let l_valueList[i,j] = l_n6.getAttribute("value")
                let l_valueList[i,j] = cs_html_comobox_convert(l_valueList[i,j],l_fieldList[j].*)

                # if l_fieldList[j].combobox.getlength() > 0 then
                #     # combobox 类型值改为说明文字
                #     for k = 1 to l_fieldList[j].combobox.getlength()
                #         if l_valueList[i,j]  == l_fieldList[j].combobox[k].val then
                #             let l_valueList[i,j] = l_fieldList[j].combobox[k].des
                #         end if
                #     end for
                # end if
            end if
        end for
    end for

    call cs_html_detail(l_title,l_descList,l_valueList)
end function

# 判读字段是否时从RadioGroup或者ComboBox类型，并返回对应字段的说明
private function cs_html_comobox(p_node)
    define p_node   om.DomNode

    define l_cboxs dynamic array of cbox
    define l_n1,l_n2    om.DomNode
    define l_nlist      om.NodeList
    define i,l_cnt      integer

    define l_tag        string

    call l_cboxs.clear()

    call p_node.getFirstChild() returning l_n1
    if l_n1 is null then return l_cboxs end if 
    let l_tag = l_n1.getTagName()
    if l_tag != "RadioGroup" and l_tag != "ComboBox" then
        return l_cboxs
    end if

    for i = 1 to l_n1.getChildCount()
        call l_n1.getChildByIndex(i) returning l_n2
        if l_n2 is null or l_n2.getTagName() != "Item" then
            continue for
        end if
        let l_cnt = l_cboxs.getLength() + 1
        let l_cboxs[l_cnt].val = l_n2.getAttribute("name")
        let l_cboxs[l_cnt].des = l_n2.getAttribute("text")
    end for

    return l_cboxs 
end function

# 将下拉框值改为说明文字
private function cs_html_comobox_convert(p_value,p_field)
    define p_value  string
    define p_field  record
            val         string,
            combobox    dynamic array of cbox
    end record

    define l_value string
    define i        integer
 
    let l_value = p_value
    for i = 1 to p_field.combobox.getLength()
        if p_field.combobox[i].val == p_value then
            let l_value = p_field.combobox[i].des
        end if 
    end for

    return l_value
end function
