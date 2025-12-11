# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_frontcall.4gl
# Descriptions...: 前端调用相关函数
# Date & Author..: darcy:2025/12/09 add


DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

globals 
-- 根目录
define g_basepath   varchar(1000)
end globals
-- 是否初始化过了
define g_frontbase  boolean

-- 前端调用基础检查 
{
    1. base.dll 是否需要更新
    2. 查询本地文件最后修改时间，相对路径
    3. 删除文件
    3. 删除文件夹
}
function cl_frontcall_base()
    define l_str    string
    define l_ver    string 
    define l_ip     varchar(20)
    define l_tc_sma05       like tc_sma_file.tc_sma05
 
    -- 初始化后不需要处理
    if g_frontbase then
        return
    end if

    -- 查询IP是否有记录
    CALL ui.Interface.frontCall( "standard", "feinfo", ["ip"], [l_ip] )

    -- 取得根目录
    call ui.Interface.frontCall('standard','feinfo',['fepath'],[g_basepath])

    select tc_sma05 into l_tc_sma05 from tc_sma_file where tc_sma01 = 'csmi129' and tc_sma02 = l_ip
    if sqlca.sqlcode or l_tc_sma05 != 'Y' or cl_null(l_tc_sma05) then
        -- 没有记录，需要重新下载
        if cl_frontcall_base_down() then
            insert into tc_sma_file (tc_sma01,tc_sma02,tc_sma03,tc_sma05) values('csmi129',l_ip,1,'Y')
            let g_frontbase = true
        else
            call cl_err("frontbase.dll库下载失败，请联系管理员","!",1)
            return
        end if
    else
        -- 获取版本失败，重新下载
        try
            call ui.Interface.frontCall("frontbase","version",[],[l_ver])
        catch
            display "获取前端版本失败！"
        end try
        if cl_null(l_ver) then
            if not cl_frontcall_base_down() then
                call cl_err("frontbase.dll库下载失败，请联系管理员","!",1)
                return
            end if 
            let g_frontbase = true
        end if
    end if
    
end function

-- 下载基础dll文件
function cl_frontcall_base_down()
    define l_sql        string
    define l_tc_sma06   like tc_sma_file.tc_sma06
    define l_tc_sma18   like tc_sma_file.tc_sma18
    define l_ok         boolean
    define l_path       string

    declare frontcall_dlist cursor for   
     select tc_sma06,tc_sma18 from tc_sma_file 
      where tc_sma01 = 'csmi128' and tc_sma02 = 'basedll'
    
    foreach frontcall_dlist into l_tc_sma06,l_tc_sma18
        if sqlca.sqlcode then
            call cl_err("frontcall_dlist",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_path = g_basepath,"/",l_tc_sma06
        call cl_download_file(l_tc_sma18,l_path) returning l_ok
        if not l_ok then
            call cl_err(sfmt("请删除文件%1后重新尝试运行此作业",l_path),"!",1)
            return false
        end if
    end foreach
    return true
end function

-- 寻找程序安装路径
function cl_frontcall_findpath(p_prog)
    define p_prog   string
    define l_path   varchar(2000) 

    call cl_frontcall_base()

    call ui.Interface.frontCall("frontbase","findPath",[p_prog],[l_path])

    return l_path
end function

-- 创建目录
-- "C:/test/abc/test.txt"
-- "C:/test/abc/test"
-- 上面两种都会建立目录到abc停止
function cl_frontcall_mkdir(p_path)
    define p_path       string
    define l_result     integer

    call cl_frontcall_base()

    call ui.Interface.frontCall("frontbase","mkdir",[p_path],[l_result])

    return l_result
end function

-- 文件最后修改日期
function cl_frontcall_modDate(p_prog)
    define p_prog       varchar(1000)
    define l_dat        varchar(100)

    call cl_frontcall_base()

    call ui.Interface.frontCall("frontbase","mkdir",[p_prog],[l_dat])

    return l_dat
end function
