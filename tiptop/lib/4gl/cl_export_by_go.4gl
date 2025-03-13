# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_export_to_excel_by_go.4gl
# Descriptions...: 单身汇出excle
# Date & Author..:darcy:2023/05/17

IMPORT os

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"


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
