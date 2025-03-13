
import libuuid
import libwritexcel

database ds
 
globals "../../../tiptop/config/top.global" 
 
main
    options                                #改變一些系統預設值
        input no wrap
    defer interrupt                        #擷取中斷鍵, 由程式處理
 
    if (not cl_user()) then
        exit program
    end if
    
    whenever error call cl_err_msg_log
    
    if (not cl_setup("CIM")) then
        exit program
    end if
    
    call  cl_used(g_prog,g_time,1) returning g_time 
    
    display ORD('A')
    display ORD('a')
    display ORD('ab')
    display ORD('你') 	  
    -- call test_excel_cell()
    -- call test_cl_wrtie()
    -- call test_write_excel()
    -- call test_xml()
    -- call test_impxlx()
    
    call  cl_used(g_prog,g_time,2) returning g_time
end main

function test_impxlx()
    define l_file string
    define l_data dynamic array with dimension 2 of string
    define i,x,y integer
    

    let l_file = cl_import_open_file()
    if cl_import_xlsx(l_file)  then
    end if

    -- 文件名
    let l_file = cl_import_get_file_name()

    for i = 1 to cl_import_get_sheet_count()
        let l_file = cl_import_get_sheet_name(i)
        call cl_import_get_sheet_size_by_name(l_file) returning x,y
        call cl_import_get_cell_by_index(i,1,1) returning l_file 
        call cl_import_get_data_by_sheet_index(i) returning l_data
    end for
end function


function test_xml()
    define p_data dynamic array of record
        sheet   string,
        pos       string,
	    value       string,
	    color     string,
	    bold      boolean,
	    italic    boolean,
	    underline boolean
    end record
    
    define p_file string
    define l_xml  om.DomNode
    define l_uuid,l_file string
    

    let p_data[1].sheet = 'AA01' 
    let p_data[1].pos = 'A1'
    let p_data[1].color = '#F0F0F0'
    let p_data[1].bold = true
    let p_data[1].italic = true
    let p_data[1].value = 'AA01' 

    let p_data[2].sheet = 'AA02' 
    let p_data[2].pos = 'A2'
    let p_data[2].color = '#FFF000'
    let p_data[2].underline = true
    let p_data[2].value = 'AA02'

    call base.TypeInfo.create(p_data) returning l_xml

    call genuuidc() returning l_uuid
    let l_file = FGL_GETENV("TEMPDIR"),"/",l_uuid,".xml"
    call l_xml.writeXml(l_file)
end function

function test_write_excel()
    define l_ok string 
    
    call writexcel("/u1/out/XBC呆滞物料.xlsx",
    "/u1/out/6dc576d4-d1bf-487f-85c6-96e81f53d073.xml") returning l_ok
    message l_ok
end function


function test_cl_wrtie()
    define l_data dynamic array of record
        sheet   string,
        row integer,
        col integer,
        -- pos     string,
        value   string,
        style   string -- warn info mark
    end record

    define l_ok boolean

    let l_data[1].sheet = 'OK'
    let l_data[1].row = 3
    let l_data[1].col = 1
    let l_data[1].value = 'OK'
    let l_data[1].style = 'warn'

    let l_data[2].sheet = 'OK'
    let l_data[2].row = 1
    let l_data[2].col = 3
    let l_data[2].value = 'OK'
    let l_data[2].style = 'info'

    let l_data[3].sheet = 'OK'
    let l_data[3].row = 4
    let l_data[3].col = 5
    let l_data[3].value = 'OK'
    let l_data[3].style = 'mark'

    let l_data[4].sheet = 'OK'
    let l_data[4].row = 6
    let l_data[4].col = 1
    let l_data[4].value = 'OK'
    let l_data[4].style = 'as'

    call cl_write("/u1/out/XBC呆滞物料.xlsx",l_data ) returning l_ok
    message l_ok
    
end function
function test_excel_cell()
    define l_str varchar(10)

    let l_str = cl_postion_excel(2,3)
    let l_str = cl_postion_excel(3,121)
    let l_str = cl_postion_excel(1,3)
    let l_str = cl_postion_excel(2,133)
    let l_str = cl_postion_excel(45,6)
end function
