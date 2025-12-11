# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_label.4gl
# Descriptions...: 标签系统
# Date & Author..: darcy:2025/12/10 add

import os

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

globals 
-- 根目录
define g_basepath    varchar(1000)
define g_bartendpath varchar(1000)
end globals
-- 初始化flag
define g_label_init  boolean
-- 总比数
define g_rec         integer
define g_csv         string

-- 标签功能的初始化
-- 1. 查询bartend本地安装目录
-- 2. 查询本地的根目录
function cl_label()

    if not g_label_init then
        -- 根目录
        if cl_null(g_basepath) then
            call ui.Interface.frontCall('standard','feinfo',['fepath'],[g_basepath])
        end if
        -- bartend 安装目录
        call cl_frontcall_findpath("bartend") returning g_bartendpath
        let g_label_init = true
    end if

    if cl_null(g_bartendpath) then
        call cl_err("你的电脑没有安装BarTender软件，无法打印标签，请联系系统管理员","!",1)
        return
    end if

end function

-- 通过调用p_query导出资料
function cl_label_query(p_bartend,p_prog,p_jump,p_argv1,p_argv2,p_argv3,p_argv4,p_argv5)
    define p_bartend,p_prog     varchar(100)
    define p_argv1,p_argv2,p_argv3,p_argv4,p_argv5       string
    define p_jump       boolean  -- 跳过数据预览
    define l_ok         boolean

    define i,j,k,l  integer
    define sr array[100] of varchar(2000)
    define l_cmd,l_sql,l_line      string
    define l_zak02,l_csv,l_local   varchar(2000)
    define l_ch             base.Channel

    call cl_label()

    let g_rec = 0
    
    --Step1. 调用p_query
    if not p_jump then
        let l_cmd = "p_query ",p_prog," ",p_argv1," ",p_argv2," ",p_argv3," ",p_argv4," ",p_argv5
        call cl_cmdrun_wait(l_cmd)
    end if
    --Step2. 组合sql
    select zak02 into l_zak02 from zak_file where zak01 = p_prog
    if sqlca.sqlcode or cl_null(l_zak02) then
        call cl_err(sfmt("%1报表未定义",p_prog),"!",1)
        return false
    end if
    let l_sql = l_zak02
    let l_sql = cl_replace_str(l_sql,'arg1',p_argv1)
    let l_sql = cl_replace_str(l_sql,'arg2',p_argv2)
    let l_sql = cl_replace_str(l_sql,'arg3',p_argv3)
    let l_sql = cl_replace_str(l_sql,'arg4',p_argv4)
    let l_sql = cl_replace_str(l_sql,'arg5',p_argv5)
    --Step3. 写入csv文件
    select count(*) into i from zat_file where zat01 = p_prog
    if i <= 0 then
        call cl_err(sfmt("%1报表未定义任何列",p_prog),sqlca.sqlcode,1)
        return false
    end if

    select tc_sma18 into l_csv from tc_sma_file
     where tc_sma01 = 'csmi128' and tc_sma02 = p_bartend
       and tc_sma06 = 'csv'
    if cl_null(l_csv) then
        call cl_err(sfmt("%1 csmi128 csv 路径 未定义",p_bartend),sqlca.sqlcode,1)
        return false
    end if
    let l_csv = l_csv,"/",g_user
    if not os.Path.isdirectory(l_csv) then
        call os.Path.mkdir(l_csv) returning l_ok
        if not l_ok then
            call cl_err(sfmt("%1 csmi128 csv 创建目录失败",l_csv),"!",1)
            return false
        end if
    end if
    let l_csv = l_csv,"/data.csv"

    let l_ch = base.Channel.create()
    call l_ch.openFile(l_csv,"w")

    declare cl_label_source cursor from l_sql

    let g_rec = 0
    foreach cl_label_source into sr[1],sr[2],sr[3],sr[4],sr[5],sr[6],sr[7],sr[8],sr[9],sr[10],
                                 sr[11],sr[12],sr[13],sr[14],sr[15],sr[16],sr[17],sr[18],sr[19],sr[20],
                                 sr[21],sr[22],sr[23],sr[24],sr[25],sr[26],sr[27],sr[28],sr[29],sr[30],
                                 sr[31],sr[32],sr[33],sr[34],sr[35],sr[36],sr[37],sr[38],sr[39],sr[40],
                                 sr[41],sr[42],sr[43],sr[44],sr[45],sr[46],sr[47],sr[48],sr[49],sr[50],
                                 sr[51],sr[52],sr[53],sr[54],sr[55],sr[56],sr[57],sr[58],sr[59],sr[60],
                                 sr[61],sr[62],sr[63],sr[64],sr[65],sr[66],sr[67],sr[68],sr[69],sr[70],
                                 sr[71],sr[72],sr[73],sr[74],sr[75],sr[76],sr[77],sr[78],sr[79],sr[80],
                                 sr[81],sr[82],sr[83],sr[84],sr[85],sr[86],sr[87],sr[88],sr[89],sr[90],
                                 sr[91],sr[92],sr[93],sr[94],sr[95],sr[96],sr[97],sr[98],sr[99],sr[100]
        if sqlca.sqlcode then
            call cl_err("cl_label_source",sqlca.sqlcode,1)
            return false
        end if
        let l_line = ""
        for j = 1 to i 
            let l_line = l_line , sr[j] , ","
        end for
        let l_line = l_line.subString(1,l_line.getLength()-1)
        call l_ch.writeLine(l_line)
        let g_rec = g_rec + 1
    end foreach
    call l_ch.close()

    --Step4. 覆盖本地文件
    let l_local = g_basepath,"/",p_bartend,"/data.csv"
    let g_csv = l_local

    -- 创建文件夹，防止报错
    if not cl_frontcall_mkdir(l_local) then
        call cl_err(sfmt("创建目录失败 %1",l_local),"!",1)
        return false
    end if

    return cl_download_file(l_csv,l_local)
end function

-- 通过xml文件和数据导出数据
function cl_label_record(p_bartend,p_value,p_field)
    define p_bartend,p_value,p_field                                      string

    let g_rec = 0

end function

-- 调用bartend打印标签
function cl_label_prt(p_bartend)
    define p_bartend        varchar(100)
    define l_btw,l_local    varchar(1000)
    define l_filename       varchar(1000)
    define l_dat,l_today    varchar(10)
    define l_ok             boolean
    define l_choice         integer
    define l_cmd            string
    define l_bartend        string
    define l_csv            string

    select tc_sma18 into l_btw from tc_sma_file 
     where tc_sma01 = 'csmi128' and tc_sma02 = p_bartend
       and tc_sma06 = 'temp'
    if cl_null(l_btw) then
        call cl_err(sfmt("%1模板未在csmi128定义",p_bartend),sqlca.sqlcode,1)
        return false
    end if

    --Step1. 检查是否下载了模板
    let l_filename = os.Path.basename(l_btw)
    let l_local = g_basepath,"/",p_bartend,"/",l_filename

    let l_dat = cl_frontcall_modDate(l_local)
    let l_today = sfmt("%1/%2/%3",year(g_today) mod 100 using '&&',month(g_today) using '&&',day(g_today) using '&&')

    if cl_null(l_dat) or l_dat < l_today then
        -- 重新下载
        -- 创建文件夹，防止报错
        if not cl_frontcall_mkdir(l_local) then
            call cl_err(sfmt("创建目录失败 %1",l_local),"!",1)
            return false
        end if

        call cl_download_file(l_btw,l_local) returning l_ok
        if not l_ok then
            call cl_err(sfmt("下载模板失败 %1",l_local),"!",1)
            return false
        end if
    end if

    --Step2. 检查bartend是否安装
    call cl_frontcall_findpath("bartend") returning g_bartendpath
    if cl_null(g_bartendpath) then
        call cl_err("未找到 Bartender 安装目录，请联系管理员","!",1)
        return false
    end if

    --Step3. 打印/预览标签
    open window cl_label_w at 1,1     with form "clib/42f/cl_label"
         attribute (style = g_win_style clipped) 

    call cl_ui_init()

    let l_choice = 0

    display sfmt("共%1笔资料，请选择打印方式",g_rec) to msg

    input l_choice without defaults from choice 
    if int_flag then
        message "已取消"
        close window cl_label_w
        let int_flag = true
        return false
    end if

    close window cl_label_w
    let l_bartend = g_bartendpath,"bartend.exe"
    let l_local = cl_replace_str(l_local,'/',"\\")
    let g_csv = cl_replace_str(g_csv,'/',"\\")
    let l_cmd = sfmt('"%1" /AF=%2 /D=%3',l_bartend,l_local,g_csv)

    case l_choice
        when 0
            -- 预览
            call ui.Interface.frontCall("standard","execute",[l_cmd,1],[l_ok])
        when 1
            -- 直接打印
            let l_cmd = l_cmd," /P /X"
            call ui.Interface.frontCall("standard","execute",[l_cmd,1],[l_ok])
        when 2
            -- 取消
            message "已取消"
            let l_ok =  false
        otherwise
            call cl_err("至少选择一种方式","!",1)
            let l_ok = false
    end case

    return l_ok
end function
