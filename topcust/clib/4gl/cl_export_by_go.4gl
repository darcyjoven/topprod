# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_export_to_excel_by_go.4gl
# Descriptions...: 单身汇出excle
# Date & Author..:darcy:2023/05/17

IMPORT os
#darcy:2024/01/11 add s---
import libexport 
import libuuid
#darcy:2024/01/11 add e---

#darcy:2024/01/19 s---
# 文件长度
define g_filesize  decimal(20,3)

#darcy:2024/01/19 e---

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

#darcy:2024/01/11 add s---
# 新的直接使用C调用Go方式产生excel
# 直接返回文件名称，如果失败则为空
function cl_expexcel(p_page1,p_value1,p_page2,p_value2,p_page3,p_value3)
    define  p_page1 varchar(1000),
            p_page2 varchar(1000),
            p_page3 varchar(1000)
    define  l_page1 varchar(1000),
            l_page2 varchar(1000),
            l_page3 varchar(1000),
            p_value1 om.DomNode,
            p_value2 om.DomNode,
            p_value3 om.DomNode
    define l_file varchar(1000)

    let g_filesize = 0
    let l_page1 = cl_exp_data(p_value1)
    let l_page2 = cl_exp_data(p_value2)
    let l_page3 = cl_exp_data(p_value3)
    if not cl_filesize_chk() then return "" end if

    display "page1: "||l_page1
    display "page2: "||l_page2
    display "page3: "||l_page3

    call exportexcel(g_prog,cl_exp_record(),p_page1,l_page1,p_page2,l_page2,p_page3,l_page3) returning l_file

    return l_file 
end function
function cl_expexcel1(p_page1,p_value1)
    define  p_page1 varchar(1000)
    define  l_page1 varchar(1000),
            p_value1 om.DomNode
    define l_file varchar(1000)

    let g_filesize = 0
    let l_page1 = cl_exp_data(p_value1)
    if not cl_filesize_chk() then return "" end if

    call exportexcel1(g_prog,cl_exp_record(),p_page1,l_page1) returning l_file

    return l_file
end function
function cl_expexcel2(p_page1,p_value1,p_page2,p_value2)
    define  p_page1 varchar(1000),
            p_page2 varchar(1000)
    define  l_page1 varchar(1000),
            l_page2 varchar(1000),
            p_value1 om.DomNode,
            p_value2 om.DomNode
    define l_file varchar(1000)

    let g_filesize = 0
    let l_page1 = cl_exp_data(p_value1)
    let l_page2 = cl_exp_data(p_value2)
    if not cl_filesize_chk() then return "" end if

    call exportexcel2(g_prog,cl_exp_record(),p_page1,l_page1,p_page2,l_page2) returning l_file

    return l_file
end function
function cl_expexcel5(p_page1,p_value1,p_page2,p_value2,p_page3,p_value3,p_page4,p_value4,p_page5,p_value5)
    define  p_page1 varchar(1000),
            p_page2 varchar(1000),
            p_page3 varchar(1000),
            p_page4 varchar(1000),
            p_page5 varchar(1000)
    define  l_page1 varchar(1000),
            l_page2 varchar(1000),
            l_page3 varchar(1000),
            l_page4 varchar(1000),
            l_page5 varchar(1000),
            p_value1 om.DomNode,
            p_value2 om.DomNode,
            p_value3 om.DomNode,
            p_value4 om.DomNode,
            p_value5 om.DomNode
    define l_file varchar(1000)
    
    let g_filesize = 0
    let l_page1 = cl_exp_data(p_value1)
    let l_page2 = cl_exp_data(p_value2)
    let l_page3 = cl_exp_data(p_value3)
    let l_page4 = cl_exp_data(p_value4)
    let l_page5 = cl_exp_data(p_value5)
    if not cl_filesize_chk() then return "" end if

    call exportexcel5(g_prog,cl_exp_record(),p_page1,l_page1,p_page2,l_page2,p_page3,l_page3,p_page4,l_page4,p_page5,l_page5) returning l_file

    return l_file
end function
function cl_expexcel10(p_page1,p_value1,p_page2,p_value2,p_page3,p_value3,p_page4,p_value4,p_page5,p_value5,p_page6,p_value6,p_page7,p_value7,p_page8,p_value8,p_page9,p_value9,p_page10,p_value10)
    define  p_page1 varchar(1000),
            p_page2 varchar(1000),
            p_page3 varchar(1000),
            p_page4 varchar(1000),
            p_page5 varchar(1000),
            p_page6 varchar(1000),
            p_page7 varchar(1000),
            p_page8 varchar(1000),
            p_page9 varchar(1000),
            p_page10 varchar(1000)
    define  l_page1 varchar(1000),
            l_page2 varchar(1000),
            l_page3 varchar(1000),
            l_page4 varchar(1000),
            l_page5 varchar(1000),
            l_page6 varchar(1000),
            l_page7 varchar(1000),
            l_page8 varchar(1000),
            l_page9 varchar(1000),
            l_page10 varchar(1000),
            p_value1 om.DomNode,
            p_value2 om.DomNode,
            p_value3 om.DomNode,
            p_value4 om.DomNode,
            p_value5 om.DomNode,
            p_value6 om.DomNode,
            p_value7 om.DomNode,
            p_value8 om.DomNode,
            p_value9 om.DomNode,
            p_value10 om.DomNode
    define l_file varchar(1000)

    let g_filesize = 0
    let l_page1 = cl_exp_data(p_value1)
    let l_page2 = cl_exp_data(p_value2)
    let l_page3 = cl_exp_data(p_value3)
    let l_page4 = cl_exp_data(p_value4)
    let l_page5 = cl_exp_data(p_value5)
    let l_page6 = cl_exp_data(p_value6)
    let l_page7 = cl_exp_data(p_value7)
    let l_page8 = cl_exp_data(p_value8)
    let l_page9 = cl_exp_data(p_value9)
    let l_page10 = cl_exp_data(p_value10)
    if not cl_filesize_chk() then return "" end if

    call exportexcel10(
            g_prog,cl_exp_record(),
            p_page1,l_page1,p_page2,l_page2,p_page3,l_page3,p_page4,l_page4,p_page5,l_page5,
            p_page6,l_page6,p_page7,l_page7,p_page8,l_page8,p_page9,l_page9,p_page10,l_page10
            ) returning l_file

    return l_file
end function
function cl_expexcel32(
    p_page1,p_value1,p_page2,p_value2,p_page3,p_value3,p_page4,p_value4,p_page5,p_value5,p_page6,p_value6,p_page7,p_value7,p_page8,p_value8,p_page9,p_value9,p_page10,p_value10,
    p_page11,p_value11,p_page12,p_value12,p_page13,p_value13,p_page14,p_value14,p_page15,p_value15,p_page16,p_value16,p_page17,p_value17,p_page18,p_value18,p_page19,p_value19,p_page20,p_value20,
    p_page21,p_value21,p_page22,p_value22,p_page23,p_value23,p_page24,p_value24,p_page25,p_value25,p_page26,p_value26,p_page27,p_value27,p_page28,p_value28,p_page29,p_value29,p_page30,p_value30,
    p_page31,p_value31,p_page32,p_value32
)
    define  p_page1 varchar(1000),
            p_page2 varchar(1000),
            p_page3 varchar(1000),
            p_page4 varchar(1000),
            p_page5 varchar(1000),
            p_page6 varchar(1000),
            p_page7 varchar(1000),
            p_page8 varchar(1000),
            p_page9 varchar(1000),
            p_page10 varchar(1000),
            p_page11 varchar(1000),
            p_page12 varchar(1000),
            p_page13 varchar(1000),
            p_page14 varchar(1000),
            p_page15 varchar(1000),
            p_page16 varchar(1000),
            p_page17 varchar(1000),
            p_page18 varchar(1000),
            p_page19 varchar(1000),
            p_page20 varchar(1000),
            p_page21 varchar(1000),
            p_page22 varchar(1000),
            p_page23 varchar(1000),
            p_page24 varchar(1000),
            p_page25 varchar(1000),
            p_page26 varchar(1000),
            p_page27 varchar(1000),
            p_page28 varchar(1000),
            p_page29 varchar(1000),
            p_page30 varchar(1000),
            p_page31 varchar(1000),
            p_page32 varchar(1000)
    define  l_page1 varchar(1000),
            l_page2 varchar(1000),
            l_page3 varchar(1000),
            l_page4 varchar(1000),
            l_page5 varchar(1000),
            l_page6 varchar(1000),
            l_page7 varchar(1000),
            l_page8 varchar(1000),
            l_page9 varchar(1000),
            l_page10 varchar(1000),
            l_page11 varchar(1000),
            l_page12 varchar(1000),
            l_page13 varchar(1000),
            l_page14 varchar(1000),
            l_page15 varchar(1000),
            l_page16 varchar(1000),
            l_page17 varchar(1000),
            l_page18 varchar(1000),
            l_page19 varchar(1000),
            l_page20 varchar(1000),
            l_page21 varchar(1000),
            l_page22 varchar(1000),
            l_page23 varchar(1000),
            l_page24 varchar(1000),
            l_page25 varchar(1000),
            l_page26 varchar(1000),
            l_page27 varchar(1000),
            l_page28 varchar(1000),
            l_page29 varchar(1000),
            l_page30 varchar(1000),
            l_page31 varchar(1000),
            l_page32 varchar(1000),
            p_value1 om.DomNode,
            p_value2 om.DomNode,
            p_value3 om.DomNode,
            p_value4 om.DomNode,
            p_value5 om.DomNode,
            p_value6 om.DomNode,
            p_value7 om.DomNode,
            p_value8 om.DomNode,
            p_value9 om.DomNode,
            p_value10 om.DomNode,
            p_value11 om.DomNode,
            p_value12 om.DomNode,
            p_value13 om.DomNode,
            p_value14 om.DomNode,
            p_value15 om.DomNode,
            p_value16 om.DomNode,
            p_value17 om.DomNode,
            p_value18 om.DomNode,
            p_value19 om.DomNode,
            p_value20 om.DomNode,
            p_value21 om.DomNode,
            p_value22 om.DomNode,
            p_value23 om.DomNode,
            p_value24 om.DomNode,
            p_value25 om.DomNode,
            p_value26 om.DomNode,
            p_value27 om.DomNode,
            p_value28 om.DomNode,
            p_value29 om.DomNode,
            p_value30 om.DomNode,
            p_value31 om.DomNode,
            p_value32 om.DomNode
    define l_file varchar(1000)

    let g_filesize = 0
    let l_page1 = cl_exp_data(p_value1)
    let l_page2 = cl_exp_data(p_value2)
    let l_page3 = cl_exp_data(p_value3)
    let l_page4 = cl_exp_data(p_value4)
    let l_page5 = cl_exp_data(p_value5)
    let l_page6 = cl_exp_data(p_value6)
    let l_page7 = cl_exp_data(p_value7)
    let l_page8 = cl_exp_data(p_value8)
    let l_page9 = cl_exp_data(p_value9)
    let l_page10 = cl_exp_data(p_value10)
    let l_page11 = cl_exp_data(p_value11) 
    let l_page12 = cl_exp_data(p_value12) 
    let l_page13 = cl_exp_data(p_value13) 
    let l_page14 = cl_exp_data(p_value14) 
    let l_page15 = cl_exp_data(p_value15) 
    let l_page16 = cl_exp_data(p_value16) 
    let l_page17 = cl_exp_data(p_value17) 
    let l_page18 = cl_exp_data(p_value18) 
    let l_page19 = cl_exp_data(p_value19) 
    let l_page20 = cl_exp_data(p_value20) 
    let l_page21 = cl_exp_data(p_value21) 
    let l_page22 = cl_exp_data(p_value22) 
    let l_page23 = cl_exp_data(p_value23) 
    let l_page24 = cl_exp_data(p_value24) 
    let l_page25 = cl_exp_data(p_value25) 
    let l_page26 = cl_exp_data(p_value26) 
    let l_page27 = cl_exp_data(p_value27) 
    let l_page28 = cl_exp_data(p_value28) 
    let l_page29 = cl_exp_data(p_value29) 
    let l_page30 = cl_exp_data(p_value30) 
    let l_page31 = cl_exp_data(p_value31) 
    let l_page32 = cl_exp_data(p_value32) 
    if not cl_filesize_chk() then return "" end if
    
    call exportexcel32(
            g_prog,cl_exp_record(),
            p_page1,l_page1,p_page2,l_page2,p_page3,l_page3,p_page4,l_page4,p_page5,l_page5,
            p_page6,l_page6,p_page7,l_page7,p_page8,l_page8,p_page9,l_page9,p_page10,l_page10,
            p_page11,l_page11,p_page12,l_page12,p_page13,l_page13,p_page14,l_page14,p_page15,l_page15,
            p_page16,l_page16,p_page17,l_page17,p_page18,l_page18,p_page19,l_page19,p_page20,l_page20,
            p_page21,l_page21,p_page22,l_page22,p_page23,l_page23,p_page24,l_page24,p_page25,l_page25,
            p_page16,l_page26,p_page27,l_page27,p_page28,l_page28,p_page29,l_page29,p_page30,l_page30,
            p_page31,l_page31,p_page32,l_page32
            ) returning l_file

    return l_file
end function

# 产生资料的值，返回xml文件名
function cl_exp_data(p_value)
    define p_value om.DomNode
    define  l_uuid varchar(40),
            l_tempdir varchar(200),
            l_pid   varchar(100),
            l_file      varchar(1000)
    define l_cnt  integer

    try
        let l_cnt = 0
        let l_cnt = p_value.getChildCount()
        if l_cnt = 0 then
            return ""
        end if
    catch
        return ""
    end try
    
    # 取得uuid
    call genuuidc() returning l_uuid
    if cl_null(l_uuid) then return "" end if
    # 取得临时文件目录
    let l_tempdir = FGL_GETENV("TEMPDIR")
    # 取得pid，pid是为了方便删除使用后的文件
    let l_pid = FGL_GETPID()
    # 得到文件名称,uuid,不会重复
    let l_file = os.Path.join(l_tempdir, g_prog||l_pid||l_uuid||".xml")

    # 将p_value的资料xml写入文件中
    call p_value.writeXml(l_file)
    call cl_filesize_add(l_file)

    display "data file: "||l_file
    return l_file     
end function

# 产生画面规格档xml，返回xml文件名
function cl_exp_record()
    define  l_uuid varchar(40),
            l_tempdir varchar(200),
            l_pid   varchar(100),
            l_file      varchar(1000)
    define l_record om.DomNode

    # 取得uuid
    call genuuidc() returning l_uuid
    if cl_null(l_uuid) then return "" end if
    # 取得临时文件目录
    let l_tempdir = FGL_GETENV("TEMPDIR")
    # 取得pid，pid是为了方便删除使用后的文件
    let l_pid = FGL_GETPID()
    # 得到文件名称,uuid,不会重复
    let l_file = os.Path.join(l_tempdir, g_prog||l_pid||l_uuid||".xml")

    # 将当前打开的规格xml写入文件中
    let l_record = ui.Interface.getRootNode()
    call l_record.writeXml(l_file)
    display "record file: "||l_file

    return l_file
end function
#darcy:2024/01/11 add e---

#darcy:2024/01/12 add s---
# 将文件名display出来
function cl_expexcel_display(p_page1,p_value1,p_page2,p_value2,p_page3,p_value3)
    define  p_page1 varchar(1000),
            p_page2 varchar(1000),
            p_page3 varchar(1000),
            p_value1 om.DomNode,
            p_value2 om.DomNode,
            p_value3 om.DomNode
    define l_file varchar(1000)

    # call exportexcel(g_prog,cl_exp_record(),p_page1,cl_exp_data(p_value1),p_page2,cl_exp_data(p_value2),p_page3,cl_exp_data(p_value3)) returning l_file

    display ""
    display g_prog
    display cl_exp_record()
    display p_page1
    display cl_exp_data(p_value1)
    display p_page2
    display cl_exp_data(p_value2)
    display p_page3
    display cl_exp_data(p_value3) 
end function
#darcy:2024/01/12 add e---

#darcy:2024/01/19 add s---
# 如果任意一个xml大于5M，将提醒是否导出
function cl_filesize_chk()
    
    if g_filesize > 10 then
        return cl_confirm("clib-05")
    end if
    return true
end function
function cl_filesize_add(p_filename)
    define p_filename  string
    define l_filesize  decimal(20,3)

    let l_filesize = os.Path.size(p_filename)
    let l_filesize = l_filesize/1024/1024 

    let g_filesize = g_filesize + l_filesize
end function
#darcy:2024/01/19 add e---

# 通过golang 导出excel
# 1.解决xls只能导出6万多行限制
# 2.可以将表单样式导出到excel
# return file  产生的excel绝对地址
function cl_export_to_excel_by_go_with_style(p_value,p_style)
    define p_record om.NodeList                    #字段宽度、字段属性和字段名称等资料
    define p_value,p_style  dynamic array of record
            node om.DomNode,         #字段的值
            name string              #对应画面表格名称
        end record

    define l_file   string

    call cl_export_to_excel_by_go(p_value) 
end function

function cl_export_to_excel_by_go(p_value)
    define p_value  dynamic array of record
            node om.DomNode,         #字段的值
            name string              #对应画面表格名称
        end record
    define l_record om.DomNode

    define l_temp   string      #文件前缀
    define d datetime day to fraction(3)

    define i,j,l_cnt      integer
    define m,n          string
    define node1 om.DomNode

    # 获取文件前缀 
    let l_temp = cl_export_get_excel_name()
    # l_temp = "/u1/out/cimq200_18075409598"

    # 产生xml文件
    for i = 1 to p_value.getLength()
        # 当前table名称 like  s_oeb,s_oha....不会重复
        let m = p_value[i].name
        if cl_null(m) then
            continue for
        end if
        if i<10 then
            call p_value[i].node.writeXml(l_temp||"_value_"||m||"_"||i||".xml")
        else
            call p_value[i].node.writeXml(l_temp||"_value_"||m||"_"||Num2Letter(i-9)||".xml")
        end if
    end for
    let l_record = ui.Interface.getRootNode()
    call l_record.writeXml(l_temp||"_record.xml")
    message "excel 导出中..."
    run "/u1/usr/tiptop/fast/excel --file "||l_temp||"_record.xml"
    message "excel 导出完成."||l_temp||".xlsx"

    call cl_download_by_explorer(l_temp||".xlsx")

end function

# 通过浏览器下载
# cl_download_file(a,b)将服务器a直接下载到用户b
function cl_download_by_explorer(p_file)
    define p_file       string

    define file string
    define res like type_file.num10

    let file = os.Path.basename(p_file)

    let file = fgl_getenv("FGLASIP") clipped,"/tiptop/out/",file clipped
    call ui.Interface.frontCall("standard",
                                "shellexec",
                                ["EXPLORER \"" || file || "\""],
                                [res])
    if status then
        call cl_err("Front End Call Failed.",status,1)
        return
    end if
end function


function Num2Letter(p_num)
    define p_num integer
    define l_str string
    define temp dynamic array of integer
    define slice dynamic array of string
    define i,k  integer

    let slice[1]=""
    let slice[2]="A"
    let slice[3]="B"
    let slice[4]="C"
    let slice[5]="D"
    let slice[6]="E"
    let slice[7]="F"
    let slice[8]="G"
    let slice[9]="H"
    let slice[10]="I"
    let slice[11]="J"
    let slice[12]="K"
    let slice[13]="L"
    let slice[14]="M"
    let slice[15]="N"
    let slice[16]="O"
    let slice[17]="P"
    let slice[18]="Q"
    let slice[19]="R"
    let slice[20]="S"
    let slice[21]="T"
    let slice[22]="U"
    let slice[23]="V"
    let slice[24]="W"
    let slice[25]="X"
    let slice[26]="Y"
    let slice[27]="Z"
 
	# //⽤来匹配的字符A-Z
	if p_num > 26 then #数据⼤于26需要进⾏拆分
        let i =1
        while true
            let k = p_num mod 26
            if k = 0 then
                let temp[i]=26
                let i=i+1
                let k = 26
            else
                let temp[i]=k
                let i=i+1
            end if
            let p_num = (p_num-k) / 26
            if p_num <=26 then
                let temp[i]=p_num
                let i=i+1
                exit while
            end if
        end while
    else
        return slice[p_num]
    end if 

    for k = 1 to temp.getLength()
        if not cl_null(temp[k]) then
            let l_str = slice[temp[k]+1],l_str
        end if
    end for
	return l_str
end function

function cl_fast_query_zat(p_zai01,p_param,p_report)
    define p_zai01  like zai_file.zai01
    define p_param  string
    define p_report like type_file.num5
    define result like type_file.num5
    define l_file string

    define l_cmd    string

    let l_cmd = "/u1/usr/tiptop/fast/query"
    let l_cmd = l_cmd," --config /u1/usr/tiptop/fast/config.query.xml"
    let l_cmd = l_cmd," --query ",p_zai01
    if not cl_null(p_param) then
        let p_param = cl_export_replace_date_str(p_param)
        let l_cmd = l_cmd," --param \"",p_param,"\""
    end if
    let l_file = cl_export_get_excel_name(),".xlsx"
    let l_cmd = l_cmd," --excel ",l_file
    if p_report then
        let l_cmd = l_cmd , " --report "
    end if
    display l_cmd
    run l_cmd #执行
    if not os.Path.exists(l_file) then
        call cl_err('','lib-216',1)
        return
    end if
    call cl_download_by_explorer(l_file)

end function

# 获得没有后缀名的文件路径
# /u1/out/cimq200_18075409598
function cl_export_get_excel_name()
    define d datetime day to fraction(3)
    define l_temp   string

    # 获取文件前缀
    let d = current day to fraction(3)
    let l_temp = cl_replace_str(d,' ','')
    let l_temp = cl_replace_str(l_temp,':','')
    let l_temp = cl_replace_str(l_temp,'.','')
    let l_temp = fgl_getenv("TEMPDIR") clipped,"/",g_prog,"_",l_temp
    # l_temp = "/u1/out/cimq200_18075409598"
    return l_temp
end function

# 将字符串中的日期替换为to_date('23/01/01','yy/mm/dd')
function cl_export_replace_date_str(p_sql)
    define p_sql,l_sql  string
    define l_where,l_temp string
    define types  varchar(20)
    define l_length,l_i,l_m,l_n,l_s,l_a,l_b integer  -- 日期字串长度,postion
    define l_match,l_format string

    let l_temp = p_sql.toLowerCase()
    let l_b = l_temp.getIndexOf("where",1)
    let l_temp =""

    let l_s = p_sql.getLength() --p_sql 长度
    if l_b > 0 then
        let l_where = p_sql.subString(l_b+5,l_s)
    else
        # 没有where语句，不需要转换
        return p_sql
    end if

    let l_s = l_where.getLength() --p_sql 长度

    let types = fgl_getenv("DBDATE")
    #  Y2MD/  Y4MD/ 四位或者二位年份
    if types = "Y2MD/" then
        let l_length = 8
        let l_format = "'yy/mm/dd'"
    end if
    if types = "Y4MD/" then
        let l_length = 10
        let l_format = "'yyyy/mm/dd'"
    end if
    let l_match ="'[0-9]*/[0-9]*/[0-9]*'"

    let l_a = 1 # 开始 l_where 是第一个位置
    let l_i = 1 # 现在位置 '
    while true
        let l_m = l_where.getIndexOf("'",l_i)
        if l_m <=0 then
            let l_sql = l_sql,l_where.subString(l_a,l_s)
            exit while
        end if
        let l_i = l_m + 1
        let l_n = l_where.getIndexOf("'",l_i)
        if l_n<=0 then
            let l_sql = l_sql,l_where.subString(l_a,l_s)
            exit while
        end if
        let l_i = l_n + 1
        #  '23/01/01' '2023/01/01'
        let l_temp = l_where.subString(l_m,l_n)
        if l_temp.getLength()!=l_length+2 or l_temp not MATCHES l_match then
            # 不是日期格式
            let l_sql = l_sql,l_where.subString(l_a,l_n)
            let l_a = l_n + 1  #+1 下次从下个位置开始
            continue while
        end if
        # 是日期格式
        # l_a 上次结束位置
        # 将日期之前加入
        let l_sql = l_sql,l_where.subString(l_a,l_m-1) #-1是为了去掉 '
        let l_sql = l_sql,"to_date(",l_temp,",",l_format,")"
        let l_a = l_n + 1 #+1是为了去掉 '
    end while
    let l_sql = p_sql.subString(1,l_b+4),l_sql # +4是为了加上where
    return l_sql 
end function 
