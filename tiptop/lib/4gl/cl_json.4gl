# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cl_json.4gl
# Descriptions...: json 序列化，以及反序列化
# Date & Author..: darcy 2026/06/25

-- 序列化结构体
# base.typeinfo.create(any)
public function cl_json(obj)
    define  obj         om.DomNode
    define  l_tag       string

    try
        call obj.getTagName() returning l_tag
        -- Field Array Record
        case l_tag
            when 'Field'
                return field(obj)
            when 'Array'
                return array(obj)
            when 'Record'
                return record(obj)
        end case
    catch
        error sfmt("解析xml root错误，xml:\n%1 ",obj.toString()),status
    end try

    return 'null'
end function

-- 处理 Field 值
private function field(p_field)
    define  p_field         om.DomNode
    define  l_type          varchar(100),
            l_value         string

    call p_field.getAttribute('type') returning l_type
    -- 判断数据类型 string number bool null
    case
        when l_type like "CHAR%"
            let l_type = "string"
        when l_type like "VARCHAR%"
            let l_type = "string"
        when l_type == "STRING"
            let l_type = "string"
        when l_type == "DATE"
            let l_type = "string"
        when l_type like "INTERVAL%"
            let l_type = "string"
        when l_type like "DATETIME%"
            let l_type = "string"
        when l_type == "BIGINT"
            let l_type = "number"
        when l_type == "INTEGER"
            let l_type = "number"
        when l_type == "SMALLINT"
            let l_type = "number"
        when l_type == "TINYINT"
            let l_type = "number"
        when l_type like "FLOAT%"
            let l_type = "number"
        when l_type == "SMALLFLOAT"
            let l_type = "number"
        when l_type like "DECIMAL%"
            let l_type = "number"
        when l_type like "MONEY%"
            let l_type = "number"
        when l_type == "BYTE"
            let l_type = "null"
        when l_type == "TEXT"
            let l_type = "null"
        when l_type == "BOOLEAN"
            let l_type = "bool"
        otherwise
            return 'null'
    end case

    call p_field.getAttribute('value') returning l_value
    let l_value =  escape(l_value)
    case l_type
        when 'string'
            return sfmt('"%1"',l_value)
        when 'number'
            return iif(cl_null(l_value),'0',l_value)
        when 'bool'
            return iif(l_value,'true','false')
        otherwise
            return 'null'
    end case
end function

-- 处理 record 值
private function record(p_record)
    define  p_record        om.DomNode
    define  l_child         om.DomNode
    define  l_type          varchar(100),
            l_value         string,
            l_name         string,
            l_tag         string
    define  jsonBuf         base.StringBuffer
    define  i,j,cnt         integer

    let jsonBuf = base.StringBuffer.create()

    try
        let cnt = p_record.getChildCount()
        call jsonBuf.append('{')
        -- 开始遍历每个节点，Record可能有Field、Record、Array
        for i = 1 to cnt
            call p_record.getChildByIndex(i) returning l_child
            call l_child.getTagName() returning l_tag
            call l_child.getAttribute('name') returning l_name
            --Field、Record、Array
            case l_tag
                when 'Field'
                    let l_value = field(l_child)
                when 'Record'
                    let l_value = record(l_child)
                when 'Array'
                    let l_value = array(l_child)
                otherwise
                    continue for
            end case
            call jsonBuf.append(sfmt(',"%1":%2',l_name,l_value))
        end for
        call jsonBuf.append('}')
        call jsonBuf.replace(",","",1)
    catch
        error sfmt("解析xml record错误，xml:\n%1  \njson:\n%2 ",p_record.toString(),jsonBuf.toString()),status
    end try
    -- 去掉第一个 ,

    return jsonBuf.toString()
end function

-- 处理 Array 类型
private function array(p_array)
    define  p_array         om.DomNode
    define  l_child         om.DomNode
    define  i,j,cnt         integer
    define  jsonBuf         base.StringBuffer
    define  l_tag,l_value   string

    let jsonBuf = base.StringBuffer.create()

    try
        let cnt = p_array.getChildCount()
        call jsonBuf.append('[')
        for i = 1 to cnt
            call p_array.getChildByIndex(i) returning l_child
            call l_child.getTagName() returning l_tag
            -- Array Record Field
            case l_tag
                when 'Array'
                    let l_value = array(l_child)
                when 'Record'
                    let l_value = record(l_child)
                when 'Field'
                    let l_value = field(l_child)
                otherwise
                    continue for
            end case
            call jsonBuf.append(sfmt(',%1',l_value))
        end for
        call jsonBuf.append(']')
        call jsonBuf.replace(",","",1)
    catch
        error sfmt("解析xml array错误，xml:\n%1  \njson:\n%2 ",p_array.toString(),jsonBuf.toString()),status
    end try

    return jsonBuf.toString()
end function


-- 转义字符转换
private function escape(p_str)
    define  p_str,l_str     string
    define  i               integer

    let p_str =  cl_replace_str(p_str,'"',"\\\"")  # 双引号
    let p_str =  cl_replace_str(p_str,"\t","\\t")  # 制表符
    let p_str =  cl_replace_str(p_str,"\n","\\n")  # 换行
    let p_str =  cl_replace_str(p_str,"\r","\\r")  # 回车
    let p_str =  cl_replace_str(p_str,"\f","\\f")  # 换页
    --let p_str =  cl_replace_str(p_str,"\\","\\\\") # 斜杠

    return p_str
end function
