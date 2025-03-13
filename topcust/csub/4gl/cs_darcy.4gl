#Prog.Version..:'5.30.06-13.03.12(00000)'#
#
#ProgramName...:cs+darcy.4gl
#Descriptions...:个人sub函数 
import util
import os
import libuuid

database ds
globals "../../../tiptop/config/top.global"
globals "../../../tiptop/config/darcy.global"

define epoch varchar(30)

function cs_create_DomDocument()
    define topname string
    define  d om.DomDocument
    # define  r om.DomNode 

    let d= om.DomDocument.create('excel') 
    return d
end function

# 新建一个sheet
function cs_append_sheets(xml,sheetname,types) 
    define xml om.DomDocument
    define dom,sheet,row,col,tag om.DomNode
    define sheetname string
    define types dynamic array of string
    
    define i,j integer
    
    # 资料检查
    if darcy_data.getLength() == 0 then
        display "no data to output " 
        return xml,false
    end if
    if darcy_data[1].getLength()== 0 then
        display "no data to output " 
        return xml,false
    end if
    # if darcy_data[1,1]getLength() != types.getLength() then
    #     display "types & cols's length is not equal " attribute(blink,bold)
    #     return xml,false
    # end if
    
    let dom = xml.getDocumentElement()
    try 
        #  增加data节点
        let sheet = dom.createChild("Sheet")
        call sheet.setAttribute("name",sheetname)

        # 增加类型节点
        let row = sheet.createChild("Type")
        for i = 1 to darcy_data[1].getLength()
            let col = row.createChild("Col")
            if cl_null(types[i]) then
                let types[i] ='string'
            end if
            let tag = xml.createChars(types[i])
            call col.appendChild(tag)
        end for

        # row&col处理
        for i = 1 to darcy_data.getLength()
            let row = sheet.createChild("Row")
            for j = 1 to darcy_data[i].getLength()
                let col = row.createChild("Col")
                let tag = xml.createChars(darcy_data[i,j])
                call col.appendChild(tag)
            end for
        end for 
    catch
        return xml,true
    end try

    return xml,false
end function

# 导出文件
function cs_xmlout(xml,path,file)
    define xml om.DomDocument
    define dom om.DomNode
    define path,file string
    define d datetime year to FRACTION(3)

    let dom = xml.getDocumentElement()
    let d = CURRENT YEAR TO FRACTION(3)

    if not cl_null(path) then
        let file = path,"/",file
    end if
    let file = file,d,".xml"
    # demo2022-07-0714:40:17.821.xml
    let file = cl_replace_str(file," ","")
    let file = cl_replace_str(file,":",".")
    let file = cl_replace_str(file,"-",".")

    try
        call dom.writeXml(file)
    catch
        return file,true
    end try

    return file,false
end function

function cs_darcy_efficiency(tag)
    define dur,d1 varchar(30)
    define tag,dur_str string 


    if cl_null(epoch) or epoch ==0 then  
        let epoch = current year to fraction(3)
        display tag||"first time"
        return
    end if 

    let d1 = current year to fraction(3)
    let dur_str = "SELECT to_timestamp(?,'yyyy-mm-ddhh24:mi:ss.ff')-to_timestamp(?,'yyyy-mm-ddhh24:mi:ss.ff') FROM dual "
    prepare dur_cur from dur_str 
    execute dur_cur using d1,epoch into dur
    let epoch = d1

    display tag||" :"||dur
end function


function cs_darcy_crt_table(table,creatsql)
    define table varchar(100)
    define creatsql string

    if cl_null(table) then
        call cl_err("table is null","!",1)
        return false
    end if

    let creatsql = "create table ",table," as ",creatsql
    prepare create_table from creatsql
    execute create_table
    if sqlca.sqlcode then
        call cl_err("create_table err"||table,"!",1)
        return false
    end if
    return true
end function

function cs_darcy_set_title(table,title,sheet)
    define table varchar(100)
    define title string
    define sheet varchar(100)

    define t varchar(100)
    define i integer
    define token base.StringTokenizer

    # 参数检查
    if cl_null(table) then
        call cl_err("table 不可为空","!",1)
        return  false
    end if

    # 已有资料删除
    select count(1) into i from darcy_fastexcel where table_name = table
    if not (cl_null(i) or i==0) then
        delete from darcy_fastexcel where table_name = table
        if sqlca.sqlcode then
            call cl_err("can't delete table :"||table,"!",0)
            return false
        end if
    end if

    # 增加sheetname
    if not cl_null(sheet) then
        insert into darcy_fastexcel (table_name,table_index,table_title,table_date)
            values (table,0,sheet,current year to fraction(5))
        if sqlca.sqlcode then
            call cl_err("can't insert ","!",0)
            return false
        end if
    end if

    let i =1
    let token = base.StringTokenizer.create(title,",")
    
    while token.hasMoreTokens()
        let t = token.nextToken() 
        insert into darcy_fastexcel (table_name,table_index,table_title)
            values (table,i,t)
        let i = i + 1
        if sqlca.sqlcode then
            call cl_err("can't insert ","!",0)
            return false
        end if
    end while

    return true
 
end function

function cs_darcy_excel(tables,file)
    define tables string
    define file string
    
    define i integer
    define cmd string
    define tempdir string
    define filename string

    #file 文件名和路径处理
    if file matches "/*" then
        # 说明给了路径，不需要再处理
        if file not matches "*.xlsx" then
            # 有问题，必须要以xlsx结尾,后面加上xlsx
            let file = file,".xlsx"
        end if
    else
        let tempdir = fgl_getenv("TEMPDIR")
        let cmd = current year to second
        let cmd = cl_replace_str(cmd," ",".")
        let cmd = cl_replace_str(cmd,":",".")
        let cmd = cl_replace_str(cmd,"-",".")
        let filename = file clipped,cmd clipped,".xlsx"
        let file = tempdir,"/",file clipped,cmd clipped,".xlsx"
    end if
  
    # 组成table
    let cmd = "/u1/usr/tiptop/bin/fastexcel ",tables," ",file

    run cmd
    if not os.Path.exists(file) then
        return "",false
    end if 
    call cs_darcy_open(filename)
    return file,true
end function

function cs_darcy_open(file)
    define file string
    define res like type_file.num10

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

# 建立crontab
function cs_darcy_cron(cron,types)
    define cron,ls_cmd string  #需要写入的脚本.cmd命令
    define types like type_file.chr1
    define li_status,li_i   like type_file.num10 #记录执行状态，计数变量
    define ls_cronFile string  #临时文件
    define lch_file,lch_pipe    base.Channel  #临时文件和crontab 的值
    define ls_buf      string  #缓冲

    # 1. 读取现有file到临时文件
    run "crontab -l >/dev/null 2>&1" returning li_status  #crontab运行情况
    if li_status !=0 then
        #直接报错
        return false
    end if
    let ls_cronFile = "/tmp/p_cron.", FGL_GETPID() using '<<<<<<<<<<' #临时文件名称

    let lch_file = base.Channel.create() #创建管道文件
    call lch_file.openFile(ls_cronFile, "w")
    CALL lch_file.setDelimiter(NULL)

    let lch_pipe = base.Channel.create()
    call lch_pipe.openPipe("crontab -l 2>/dev/null", "r")
    # 读取crontab 文件
    while lch_pipe.read(ls_buf)
        # 當作業系統為 LINUX時，略去 crontab -l 前三行，那些是註解
        if  ( li_i <= 3 ) and ( ls_buf.substring(1,2) = "# " ) then
            let li_i = li_i + 1
            continue while
        end if
        # 将本次脚本跳过
        if ls_buf.getindexof(cron,(ls_buf.getlength()-cron.getlength()+1))>0 then #tqc-b60314
            let li_i = li_i +1
            continue while
        end if
        call lch_file.write(ls_buf)
        let li_i = li_i + 1
    end while
    # 2. 临时文件中增加本次需要的排程
    if types then 
        # 需要写入，是新增crontab
        call lch_file.write(cron)
    end if
    call lch_file.close()

    # 3. crontab 临时文件
    run "chmod 777 "||ls_cronFile||" >/dev/null 2>&1"
    let ls_cmd= "crontab " || ls_cronFile 
    call runBatch(ls_cmd,true) returning li_status
    if li_status !=0 then
        #运行失败，先删除文件再退出
        let ls_cmd= "rm -f "||ls_cronFile clipped|| " >/dev/null 2>&1"
        call runBatch(ls_cmd,true) returning li_status
        if li_status !=0 then
            return false
        end if
        return false
    end if
    # 4. 删除临时文件
    let ls_cmd= "rm -f "||ls_cronFile clipped|| " >/dev/null 2>&1"
    call runBatch(ls_cmd,true) returning li_status
    if li_status !=0 then
        return false
    end if
    return true
end function

function runbatch(cmd, silent)
  define cmd string
  define silent string
  define result like type_file.num5
  if silent then
    run cmd in form mode returning result
  else
    run cmd in line mode returning result
  end if
  if fgl_getenv("OS") matches "Win*" then
    return result
  else
    return ( result / 256 )
  end if
end function

function cs_darcy_get_cron(cron)
    define cron,ls_cmd string  #需要写入的脚本.cmd命令
    define types like type_file.chr1
    define li_status,li_i   like type_file.num10 #记录执行状态，计数变量
    define ls_cronFile string  #临时文件
    define lch_file,lch_pipe    base.Channel  #临时文件和crontab 的值
    define ls_buf      string  #缓冲
    define result      string

    # 1. 读取现有file到临时文件
    run "crontab -l >/dev/null 2>&1" returning li_status  #crontab运行情况
    if li_status !=0 then
        #直接报错
        return result
    end if
    let ls_cronFile = "/tmp/p_cron.", FGL_GETPID() using '<<<<<<<<<<' #临时文件名称

    let lch_file = base.Channel.create() #创建管道文件
    call lch_file.openFile(ls_cronFile, "w")
    CALL lch_file.setDelimiter(NULL)

    let lch_pipe = base.Channel.create()
    call lch_pipe.openPipe("crontab -l 2>/dev/null", "r")
    # 读取crontab 文件
    while lch_pipe.read(ls_buf)
        # 當作業系統為 LINUX時，略去 crontab -l 前三行，那些是註解
        if  ( li_i <= 3 ) and ( ls_buf.substring(1,2) = "# " ) then
            let li_i = li_i + 1
            continue while
        end if
        # 将本次脚本跳过
        if ls_buf.getindexof(cron,(ls_buf.getlength()-cron.getlength()+1))>0 then #tqc-b60314
            let li_i = li_i +1
            let result = ls_buf
            exit while
        end if
        call lch_file.write(ls_buf)
        let li_i = li_i + 1
    end while 
    call lch_file.close()

    # 4. 删除临时文件
    let ls_cmd= "rm -f "||ls_cronFile clipped|| " >/dev/null 2>&1"
    call runBatch(ls_cmd,true) returning li_status
    if li_status !=0 then
        return result
    end if
    return result
end function


function cs_uuid()
    define l_uuid   varchar(50)
    call genuuidc() returning l_uuid
    return l_uuid
end function
