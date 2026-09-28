# Prog. Version..: '5.10.07-09.04.27(00009)'     #
#
# Program name...: cl_import.4gl
# Descriptions...: 文件导入工具
# Date & Author..: darcy:2025/01/17 add 
# Modify.........: 

import libimpxlsx
import libuuid
import os

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

type cell record
    sheet string,
    x integer,
    y integer,
    value string
end record

define g_root om.DomNode
define g_docu om.DomDocument

-- 导入xlsx的excel文件，解析为xml后范围xml文件目录
function cl_import_xlsx(p_file)
    define p_file  string
    define l_file  varchar(1000)
    try
        call impxlsx(p_file) returning l_file
        if cl_null(l_file) then
            return false
        end if
    catch
        message "Error caught during import xlsx:", status
        return false
    end try
    let g_docu = om.DomDocument.createFromXmlFile(l_file)
    let g_root = g_docu.getDocumentElement()
    return true
end function

-- 获取文件工作簿数量
function cl_import_get_sheet_count()
    define l_cnt integer

    let l_cnt = g_root.getChildCount()
    return l_cnt
end function

-- 获得工作簿的尺寸，行列
function cl_import_get_sheet_size_by_name(p_sheet)
    define p_sheet string
    define l_row,l_col integer
    define l_sheet,l_n1 om.DomNode

    let l_sheet = cl_import_get_sheet_node_by_name(p_sheet)
    if l_sheet is null then
        return 0,0
    end if

    let l_row = l_sheet.getChildCount()
    if l_row = 0 then
        return 0,0
    end if
    
    let l_n1 = l_sheet.getChildByIndex(1)
    if l_n1 is null then
        return l_row,0
    end if
    let l_col = l_n1.getChildCount()
    return l_row,l_col
end function

-- 获得工作簿的尺寸，行列
function cl_import_get_sheet_size_by_index(p_index)
    define p_index integer
    define l_row,l_col integer
    define l_sheet,l_n1 om.DomNode

    let l_sheet = cl_import_get_sheet_node_by_index(p_index)
    if l_sheet is null then
        return 0,0
    end if

    let l_row = l_sheet.getChildCount()
    if l_row = 0 then
        return 0,0
    end if
    
    let l_n1 = l_sheet.getChildByIndex(1)
    if l_n1 is null then
        return l_row,0
    end if
    let l_col = l_n1.getChildCount()
    return l_row,l_col
end function


-- 导入xlsx，并返回二维string数组
-- 获取其中一个sheet
function cl_import_get_data_by_sheet_name(p_sheet)
    define p_sheet  string
    define l_data   dynamic array with dimension 2 of string
    define l_n1     om.DomNode

    call l_data.clear()

    let l_n1 = cl_import_get_sheet_node_by_name(p_sheet)
    if l_n1 is null then
        return l_data
    end if
    return cl_import_get_sheet_data(l_n1)
end function

-- 根据顺序获取sheet
function cl_import_get_data_by_sheet_index(p_index)
    define p_index  integer
    define l_data   dynamic array with dimension 2 of string
    define l_sheet om.DomNode

    call l_data.clear()

    let l_sheet = cl_import_get_sheet_node_by_index(p_index)
    if l_sheet is null then
        return l_data
    end if
    return cl_import_get_sheet_data(l_sheet)
end function

-- 导出sheet所有资料
private function cl_import_get_sheet_data(p_sheet) 
    define p_sheet,l_row,l_cell om.DomNode
    define i,j integer
    define l_data   dynamic array with dimension 2 of string

    call l_data.clear()

    -- rows
    for i = 1 to p_sheet.getChildCount()
        let l_row = p_sheet.getChildByIndex(i)
        -- cell
        for j = 1 to l_row.getChildCount()
            let l_cell = l_row.getChildByIndex(j)
            let l_data[i,j] = l_cell.getAttribute("value")
        end for
    end for
    return l_data
end function

-- 获取指定sheet节点, by name
private function cl_import_get_sheet_node_by_name(p_sheet)
    define p_sheet string
    define l_sheet om.DomNode
    define i integer

    if g_root is null then
        return l_sheet
    end if

    for i = 1 to g_root.getChildCount()
        let l_sheet = g_root.getChildByIndex(i)
        if l_sheet is null or l_sheet.getChildByIndex("name") != p_sheet then
            continue for
        end if
        return l_sheet
    end for
    return l_sheet
end function

-- 获取指定sheet节点 ,by index
private function cl_import_get_sheet_node_by_index(p_index)
    define p_index integer
    define l_sheet om.DomNode

    if g_root is null then
        return l_sheet
    end if

    if p_index > g_root.getChildCount() then
        return l_sheet
    end if
    let l_sheet = g_root.getChildByIndex(p_index)
    return l_sheet
end function

function cl_import_get_cell_by_index(p_index,p_row,p_col)
    define p_index integer
    define p_row,p_col integer
    define l_sheet,l_row,l_cell om.DomNode
    define l_value string
    
    let l_sheet = cl_import_get_sheet_node_by_index(p_index)
    if l_sheet is null then
        return ""
    end if

    if p_row > l_sheet.getChildCount() or p_row = 0 then
        return ""
    end if
    let l_row = l_sheet.getChildByIndex(p_row)
    if l_row is null then
        return ""
    end if

    if p_col > l_row.getChildCount() or p_col = 0 then
        return 0 
    end if
    let l_cell = l_row.getChildByIndex(p_col)
    if l_cell is null then
        return ""
    end if
    
    let l_value = l_cell.getAttribute("value")
    return l_value
end function 

function cl_import_get_cell_by_name(p_sheet,p_row,p_col)
    define p_sheet string
    define p_row,p_col integer
    define l_sheet,l_row,l_cell om.DomNode
    define l_value string
    
    let l_sheet = cl_import_get_sheet_node_by_name(p_sheet)
    if l_sheet is null then
        return ""
    end if

    if p_row > l_sheet.getChildCount() or p_row = 0 then
        return ""
    end if
    let l_row = l_sheet.getChildByIndex(p_row)
    if l_row is null then
        return ""
    end if

    if p_col > l_row.getChildCount() or p_col = 0 then
        return 0 
    end if
    let l_cell = l_row.getChildByIndex(p_col)
    if l_cell is null then
        return ""
    end if

    let l_value = l_cell.getAttribute("value")
    return l_value
end function

-- 获取工作簿名称
function cl_import_get_sheet_name(p_index)
    define p_index  integer
    define l_name string
    define l_sheet om.DomNode

    let l_sheet = cl_import_get_sheet_node_by_index(p_index)
    if l_sheet is null then
        return ""
    end if

    let l_name = l_sheet.getAttribute("name")
    return l_name
end function


-- 获取文件名
function cl_import_get_file_name()
    define l_name string

    if g_root is null then
        return ""
    end if
    let l_name = g_root.getAttribute("name")
    return l_name
end function

-- 上传导入的文件
function cl_import_open_file()
    define ls_location,l_remotepath string

    let ls_location = ""
    while true
        prompt "请录入需要导入的文件：" clipped for ls_location
            attribute(without defaults)

            on action accept
                exit while

            on action cancel
                let ls_location = ""
                exit while

            on action browse_document
                let ls_location = cl_browse_file() 

            on idle g_idle_seconds
                call cl_on_idle()
                let ls_location = ""
        end prompt
    end while
    if cl_null(ls_location) or ls_location = "" then
        return ""
    end if
    # 将文件上传道服务端
    let l_remotepath = fgl_getenv("TEMPDIR"),"/",os.Path.basename(ls_location)
    let ls_location = cl_replace_str(ls_location,"/","\\")
    if not cl_upload_file(ls_location,l_remotepath) then 
        return ""
    end if

    return l_remotepath
end function
 
