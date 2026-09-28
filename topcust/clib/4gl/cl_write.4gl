# Prog. Version..: '5.10.07-09.04.27(00009)'     #
#
# Program name...: cl_write.4gl
# Descriptions...: excel????
# Date & Author..: darcy:2025/02/24 add 
# Modify.........: 

import os
import libuuid
import libwritexcel

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

constant WARN = '#f52b25', -- red
         INFO = '#2496ff', -- blue
         MRAK = '#f0f0f0', -- grey
         DARK = '#000000' -- 黑色

type cell record
    sheet   string,
    row integer,
    col integer,
    value   string,
    style   string -- warn info mark
end record

type style record
    sheet   string,
    pos     string,
    value   string,
    color     string,
    bold      boolean,
    italic    boolean,
    underline boolean
end record

-- 写入excel文件
function cl_write(p_file,p_data)
    define p_file,l_file,l_uuid,l_ok string
    define p_data dynamic array of cell
    define l_data dynamic array of style
    define i integer
    define l_n  om.DomNode

    -- 文件检查
    if not os.Path.exists(p_file) then
        message sfmt("%1 文件不存在",p_file)
        return false
    end if
    -- 类型检查
    if p_file not matches '*.xlsx' then
        message sfmt("%1 文件不是xlsx类型",p_file)
        return false
    end if

    -- 转为样式文件
    call l_data.clear()
    for i = 1 to p_data.getlength()
        let l_data[i].sheet = p_data[i].sheet
        let l_data[i].pos = cl_postion_excel(p_data[i].row,p_data[i].col)
        let l_data[i].value  = p_data[i].value
        case p_data[i].style
            when 'warn'
                call warn() returning l_data[i].color,l_data[i].bold,l_data[i].italic,l_data[i].underline
            when 'info'
                call info() returning l_data[i].color,l_data[i].bold,l_data[i].italic,l_data[i].underline
            when 'mark'
                call mark() returning l_data[i].color,l_data[i].bold,l_data[i].italic,l_data[i].underline
            otherwise
                call nomarl() returning l_data[i].color,l_data[i].bold,l_data[i].italic,l_data[i].underline
        end case
    end for

    if l_data.getlength()<=0 then
        message '不存在修改内容'
        return false
    end if

    call genuuidc() returning l_file
    let l_file = sfmt('%1/%2.xml',fgl_getenv('TEMPDIR'),l_file)


    try
        call base.TypeInfo.create(l_data) returning l_n
        call l_n.writeXml(l_file)
        call writexcel(p_file,l_file) returning l_ok 
    catch
        message sfmt('写入excel失败,excel:"%1 xml:%2',p_file,l_file)
        return false
    end try

    return l_ok == 'Y'
end function

private function warn() 
    return WARN,true,false,false
end function
private function info()
    return INFO,false,true,false
end function
private function mark()
    return MRAK,false,false,true
end function
private function nomarl()
    return DARK,false,false,false
end function
 

function cl_postion_excel(row_num  , col_num )
    define row_num,col_num integer
    define col_str      varchar(10)
    define temp_col,_remainder  integer

    let temp_col = col_num

    while temp_col > 0 
        let  _remainder = (temp_col - 1) mod  26   -- 计算当前位的余数
        let  col_str   =  ascii(ord('A') + _remainder) clipped , col_str clipped 
        -- let  temp_col  = floor((temp_col - 1) / 26)  -- 更新剩余列号
        select floor((temp_col - 1) / 26) into temp_col from dual
    end while 

    return col_str||sfmt("%1",row_num)


end function  
