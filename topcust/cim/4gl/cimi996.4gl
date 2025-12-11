
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
    -- display LENGTH('abas')
    -- call test_col_ana()
    -- call test_csmi113()
    -- call test_excel_cell()
    -- call test_cl_wrtie()
    -- call test_write_excel()
    -- call test_xml()
    -- call test_impxlx()
    -- call test_cxmt520()
    -- call test_params()
    -- call test_offline()
    -- call test_remark()
    -- call test_tc_oeb()
    -- call test_run()
    -- call test_dll()
    -- call test_base_dll()
    -- call test_frontcall()

    call test_cl_label()
    
    call  cl_used(g_prog,g_time,2) returning g_time
end main

function test_cl_label()
    define l_str,l_err string
    -- let l_str = '"C:\\Program Files (x86)\\Seagull\\BarTender Suite\\bartend.exe" /AF=C:\\app\\FourJs\\gdc\\2.50.22\\bin\\demo\\demo.btw /D=C:\\app\\FourJs\\gdc\\2.50.22\\bin\\demo\\data.csv'
    -- call ui.Interface.frontCall("standard","execute",[l_str,1],[l_err])

    
    if cl_label_query('demo','tqrcim0008','','','','','') then
        if cl_label_prt('demo') then
            display ""
        end if
    end if
end function

function test_frontcall()
    define l_path string

    call cl_frontcall_findpath("bartend") returning l_path


end function

function test_base_dll()
    define res varchar(1000)
    define str string

    -- call ui.Interface.frontCall("frontbase","version",[],[res])

    -- call ui.Interface.frontCall("frontbase","version",[],[str])

    -- call ui.Interface.frontCall("frontbase","modDate",["frontbase.dll"],[str])

    -- call ui.Interface.frontCall("frontbase","modDate",["D:/cache/table.json"],[str])
    
    -- call ui.Interface.frontCall("frontbase","modDate",["D:\\cache\\table.json"],[str])

    -- call ui.Interface.frontCall("base/frontbase","modDate",["D:\\cache\\table.json"],[str])

    call ui.Interface.frontCall("base/frontbase","findPath",["bartend"],[str])
    let str = ""
    call ui.Interface.frontCall("frontbase","findPath",["bartend"],[str])
    let str = ""
    call ui.Interface.frontCall("base/frontbase","findPath",["go"],[str])


end function

function test_dll()
    define  res ,msg  varchar(10)
    define  l_str     varchar(100)
    define  l_cmd     varchar(1000)

    CALL ui.Interface.frontCall("erpdemo", "mysum", [100,250], [res,msg])

    -- l_str = "Genero Desktop Client"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["fename"], [l_str] )
    -- l_str = "C:/app/FourJs/gdc/2.50.22/bin"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["fepath"], [l_str] )
    -- l_str = "WINDOWS"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["ostype"], [l_str] )
    -- l_str = "Windows 8"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["osversion"], [l_str] )
    -- l_str = "2"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["numscreens"], [l_str] )
    -- l_str = "2560x1440"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["screenresolution"], [l_str] )
    -- l_str = "192.168.1.104"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["ip"], [l_str] )
    -- l_str = "C:\\Users\\darcy.li\\AppData\\Local\\Four Js\\Genero Desktop Client\\cache\\ftcache"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["datadirectory"], [l_str] )
    -- l_str = "0"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["isActiveX"], [l_str] )
    -- l_str = "w64v100"
    CALL ui.Interface.frontCall( "standard", "feinfo", ["target"], [l_str] )
    CALL ui.Interface.frontCall( "standard", "feinfo", ["outputmap"], [l_str] )



    -- for /f "tokens=2,*" %a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\bartend.exe" /v Path 2^>nul') do @echo %b > "D:\cache\path.txt"
    -- let l_cmd = 
    -- let l_cmd = "for /f \"tokens=2,*\" %a in ('reg query \"HKLM\\SOFTWARE\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\App Paths\\bartend.exe\" /v Path 2^>nul') do @echo %b > \"D:\\cache\\path.txt\""
    let l_cmd = "D:\\cache\\get.bat"
    call ui.Interface.frontCall("standard","execute",[l_cmd,1],[l_str])

    -- let l_cmd = "\"C:\\Program Files (x86)\\Seagull\\BarTender Suite\\bartend.exe\""
    let l_cmd = "\"C:\Program Files (x86)\Seagull\BarTender Suite\bartend.exe\" /AF=\"D:\\cache\\DB\\bartender\\标签1.btw\" /D=\"D:\\cache\\DB\\bartender\\item1.csv\""
    call ui.Interface.frontCall("standard","execute",[l_cmd,1],[l_str])
    
end function
function test_run()
    define l_str string
    run "golang version" returning l_str
end function

function test_tc_oeb()
    call t400sub_export_batch(" oeb04 = 'MR0016S4DR'")
end function

function test_remark()
    define l_str    string
    
    let l_str = "1.Au: 0.075±0.025um, pa: 0.12±0.21122um, Ni: 3.5±1.5um\n2.化金面积S=2.73dm”，主检化金不良，记入表单，手指厚度切片\n3.测HOTBAR手指，见手指化金管控图，量测12pcs金手指尺寸"

    call i100sub_surface_remark(l_str) returning l_str

    display l_str
end function

function test_offline()
    define l_bmb01  like bmb_file.bmb01,
           l_ok     integer
    call cs_asf_gen_offine("MRA-25030069",'A10012',false)
        returning l_bmb01,l_ok
end function

function test_display()
    open window  test_param with form "azz/42f/p_zz"
          attribute (style = g_win_style clipped)


    close window test_param
end function

-- 动态新增栏位测试
function test_params()
    define lwin_curr        ui.Window
    define lnode_win        om.DomNode,
           lnode_form       om.DomNode,
           llst_items       om.NodeList,
           lnode_root       om.DomNode,
           lnode_desc       om.DomNode,
           lnode_item       om.DomNode,
           lnode_desc_new       om.DomNode,
           lnode_item_new       om.DomNode,
           child       om.DomNode
    define i,j,k,l,m,n,x,y      integer
    define l_str            string


    open window test_param with form "azz/42f/p_param"
          attribute (style = g_win_style clipped)
    
    let lwin_curr = ui.Window.getCurrent()
    let lnode_win = lwin_curr.getNode()

    let llst_items = lnode_win.selectByPath("//Form/HBox/Grid")

    if llst_items.getLength() ==0 then
        return
    end if

    let lnode_root = llst_items.item(1)
    
    let l = lnode_root.getChildCount()

    let l_str = lnode_root.tostring() 

    call lnode_root.parse(l_str) returning lnode_root

    let l = lnode_root.getChildCount()

    MENU
        ON ACTION new 
            -- CALL newFile()
        ON ACTION open 
            -- CALL openFile()
        ON ACTION save 
            -- CALL saveFile()
        ON ACTION import 
            -- LOAD FROM "infile.dat" INSERT INTO table 
        ON ACTION quit 
            EXIT PROGRAM
    END MENU
    
    close window test_param
end function


function test_cxmt520()
    message scxmt520_input('TE2-25050077',2)
end function


function test_col_ana()
    define l_sql  string
    define l_cnt integer
    
    begin work
    let l_sql = "SELECT ima01, ima02, ima021, 
               CASE ima06 WHEN 'M.IN' THEN 1 ELSE 2 END ima07,
               (ima51 * 2) / 100 AS ima51,
               (SELECT NVL(imz02, 'null') FROM imz_file WHERE imz01 = ima06)
        FROM ima_file
        WHERE ima01 LIKE 'M.IN.00%'"
    execute immediate "begin  parse_sql_query(q'["||l_sql||"]'); END;"

    select count(*) into l_cnt from col_analysis
    COMMIT work
    select count(*) into l_cnt from col_analysis
    return
end function

function test_csmi113()
    call cs_csmi113('JA0233F3AS',1000)
end function

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
