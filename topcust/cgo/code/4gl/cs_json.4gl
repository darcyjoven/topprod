# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cs_json.4gl
# Descriptions...: json 序列化，以及反序列化
# Date & Author..: darcy:2023/07/28

import JAVA com.fourjs.fgl.lang.FglRecord

type FglRecord  com.fourjs.fgl.lang.FglRecord



# 将record 转为json
function cs_record_json(obj)
    define jsonstr string
    define obj com.fourjs.fgl.lang.FglRecord
    define i,j integer

    let jsonstr = "{",cs_json_record(obj),"}"
    return jsonstr
end function

# array 类型只能是record，且是不嵌套的形式
# fieldname为objs对于的名称
# 将array 转为json
function cs_array_json(objs,fieldname)
    define jsonstr string
    define fieldname string
    define objs dynamic array of com.fourjs.fgl.lang.FglRecord
    define i,j integer

    let jsonstr ="{" , cs_json_array(objs,fieldname),"}"

    return jsonstr
end function

# array和record类型和以上要求一样
# 产生的json record记录在前array在后
# fieldname为objs对于的名称
# 将一个record和array转为json
function cs_record_array_json(obj,objs,fieldname)
    define jsonstr base.StringBuffer
    define fieldname string
    define obj com.fourjs.fgl.lang.FglRecord
    define objs dynamic array of com.fourjs.fgl.lang.FglRecord
    
    let jsonstr = base.StringBuffer.create()
    call jsonstr.append("{")
    call jsonstr.append(cs_json_record(obj))
    call jsonstr.append(",")
    call jsonstr.append(cs_json_array(objs,fieldname))
    call jsonstr.append("}")
    return jsonstr.toString()
end function

# 和cs_record_array_json一样
# objs变为二维数组,fieldname变为字符串数组
function cs_record_arrays_json(obj,objs,fieldname)
    define jsonstr base.StringBuffer
    define fieldname dynamic array of string
    define obj com.fourjs.fgl.lang.FglRecord
    define objs dynamic array with dimension 2 of com.fourjs.fgl.lang.FglRecord
    define i,j integer

    let jsonstr = base.StringBuffer.create()
    call jsonstr.append("{")
    call jsonstr.append(cs_json_record(obj))
    for i = 1 to objs.getLength()
        call jsonstr.append(",")
        call jsonstr.append(cs_json_array(objs[i],fieldname[i]))
    end for
    call jsonstr.append("}")

    return jsonstr.toString()
end function


# 此为执行函数,产生不带{}的字符串
function cs_json_record(obj)
    define jsonstr base.StringBuffer
    define obj com.fourjs.fgl.lang.FglRecord
    define i integer
    define l_temp string

    try
        let jsonstr = base.StringBuffer.create()
        for i = 1 to obj.getFieldCount()
            case cs_json_type(obj.getTypeName(i))
                when "string"
                    call jsonstr.append(sfmt(",\"%1\":\"%2\"",obj.getFieldName(i),obj.getString(i)))
                when "number"
                    call jsonstr.append(sfmt(",\"%1\":%2",obj.getFieldName(i),obj.getString(i)))
                when "bool"
                    let l_temp = obj.getString(i)
                    call jsonstr.append(sfmt(",\"%1\":%2",obj.getFieldName(i),iif(l_temp,"true","false")))
                otherwise
                    call jsonstr.append(sfmt(",\"%1\":null",obj.getFieldName(i)))
            end case
        end for
        call jsonstr.replace(",","",1)
    catch
        error sfmt("无法将obj转为正确字符串,当前位置%1,当前字符串 %2 ",i,jsonstr.toString()),status
    end try

    return jsonstr.toString()
end function

function cs_json_array(objs,fieldname)
    define jsonstr base.StringBuffer
    define fieldname string
    define objs dynamic array of com.fourjs.fgl.lang.FglRecord
    define i,j integer
    define l_temp integer

    try
        let jsonstr = base.StringBuffer.create()
        call jsonstr.append(sfmt("\"%1\":[",fieldname))
        for i =1 to objs.getLength()
            call jsonstr.append(",")
            call jsonstr.append(cs_record_json(objs[i]))
        end for
        call jsonstr.append("]")
        call jsonstr.replace(",","",1)
    catch
        error sfmt("无法将obj转为正确字符串,当前位置i:%1/j:%2,当前字符串 %3 ",i,j,jsonstr.toString()),status
    end try

    return jsonstr.toString()
end function

# 类型转化,将多类型转化为数字,字符串,布尔,空
function cs_json_type(types)
    define types string
    case
        when types like "CHAR%"
            return "string"
        when types like "VARCHAR%"
            return "string"
        when types == "STRING"
            return "string"
        when types == "DATE"
            return "string"
        when types like "INTERVAL%"
            return "string"
        when types like "DATETIME%"
            return "string"
        when types == "BIGINT"
            return "number"
        when types == "INTEGER"
            return "number"
        when types == "SMALLINT"
            return "number"
        when types == "TINYINT"
            return "number"
        when types like "FLOAT%"
            return "number"
        when types == "SMALLFLOAT"
            return "number"
        when types like "DECIMAL%"
            return "number"
        when types like "MONEY%"
            return "number"
        when types == "BYTE"
            return "null"
        when types == "TEXT"
            return "null"
        when types == "BOOLEAN"
            return "bool"
        otherwise
            return "null"
    end case
    return types
end function


-------------------------------------
# 以下为使用示例


function cs_json_example()
    type person record
        name string,
        age  integer,
        sex  boolean,
        score decimal(10,2)
    end record
    define darcy person
    define joven person
    define peter person
    define fieldname dynamic array of string

    define jsonstr string
    define obj com.fourjs.fgl.lang.FglRecord
    define objs1 dynamic array of com.fourjs.fgl.lang.FglRecord
    define objs2 dynamic array with dimension 2 of com.fourjs.fgl.lang.FglRecord


    let darcy.name = "darcy"
    let darcy.age = 18
    let darcy.sex = true
    let darcy.score = 80.5

    let joven.name = "joven"
    let joven.age = 28
    let joven.sex = true
    let joven.score = 50.23

    let peter.name = "peter"
    let peter.age = 38
    let peter.sex = false
    let peter.score = 70.23


    let obj = darcy
    let objs1[1] = darcy
    let objs1[2] = joven

    let objs2[1,1]=darcy
    let objs2[1,2]=joven
    let objs2[2,1]=peter
    let objs2[2,2]=peter

    let fieldname[1]="class1"
    let fieldname[2]="class2"

    let jsonstr = cs_record_json(obj)
    let jsonstr = cs_array_json(objs1,"class1")
    let jsonstr = cs_record_array_json(obj,objs1,"class1")
    let jsonstr = cs_record_arrays_json(obj,objs2,fieldname)

end function

-------------------------------------
