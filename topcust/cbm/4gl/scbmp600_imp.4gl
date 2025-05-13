# Program name...: scbmp600_imp.4gl
# Description....: bom导入
# Date & Author..: darcy:2025/02/10
database ds
 
 
globals "../../../tiptop/config/top.global"


define g_result dynamic array of record
        sheet   string,
        row integer,
        col integer,
        value   string,
        style   string -- warn info mark
    end record

-- 从xlsx导入bom资料
function scbmp600_imp_fromxlsx()
    define l_file string
    define l_data dynamic array with dimension 2 of string
    define i,j,k,l integer
    define l_cnt integer
    define l_ok boolean
    define l_bma record like bma_file.*
    define l_bmb record like bmb_file.*
    define l_ima25  like ima_file.ima25,
           l_ima86  like ima_file.ima86 
    define l_ima02  like ima_file.ima02
    # darcy:2025/05/07 add s---
    define l_tok    base.stringTokenizer
    define l_bmd    record like bmd_file.*
    # darcy:2025/05/07 add e---
    define l_sub    boolean #darcy:2025/05/12 add

    whenever error continue

    -- 选择文件
    let l_file = cl_import_open_file()
    if cl_null(l_file) then
        return false
    end if

    -- 解析
    if not cl_import_xlsx(l_file) then
        message '解析文件失败'
        return false
    end if

    call s_showmsg_init()
    let g_success = 'Y'
    -- 初始化
    call g_result.clear() 
    begin work
    -- 导入
    for i = 1 to cl_import_get_sheet_count()
        initialize l_bma.* to null
        let l_bma.bma01 = cl_import_get_sheet_name(i)
        if not s_chk_item_no(l_bma.bma01,'') then
            call s_errmsg('bma01',l_bma.bma01,'主件料号检查失败',g_errno,1)
            call scbmp600_imp_result(l_bma.bma01,1,3,sfmt('%1 主件料号检查失败',l_bma.bma01),'warn')
            let g_success = 'N'
        end if
        let l_cnt = 1
        select count(*) into l_cnt from bma_file where bma01 = l_bma.bma01
        if l_cnt > 0 then
            call s_errmsg('bma01',l_bma.bma01,'已存在该BOM，不能导入','!',1)
            call scbmp600_imp_result(l_bma.bma01,1,3,sfmt('%1 已存在该BOM，不能导入',l_bma.bma01),'warn')
            let g_success = 'N'
        end if 
        let l_bma.bmauser = g_user
        let l_bma.bmagrup = g_grup
        let l_bma.bmamodu = g_user
        let l_bma.bmadate = g_today
        let l_bma.bmaacti = 'Y'
        let l_bma.bma06 =' '
        let l_bma.bma08 = 'FOREWIN'
        let l_bma.bma09 = 0
        let l_bma.bma10 = 0
        -- let l_bma.bmaud02 工艺
        -- let l_bma.bmaud07 = 面积
        -- let l_bma.bmaud10 = 
        let l_bma.bmaoriu = g_user
        let l_bma.bmaorig = g_grup
        if g_success = 'Y' then
            insert into bma_file values (l_bma.*)
            if sqlca.sqlcode or sqlca.sqlerrd[3]==0 then
                call s_errmsg('bma01',l_bma.bma01,'bma插入失败',sqlca.sqlcode,1)
                call scbmp600_imp_result(l_bma.bma01,1,3,sfmt('%1 bma插入失败',l_bma.bma01),'warn')
                let g_success = 'N'
            end if
        end if
        -- 导入单身
        call cl_import_get_data_by_sheet_index(i) returning l_data
        for j = 2 to l_data.getlength() 
            initialize l_bmb.* to null
            let l_bmb.bmb01 = l_bma.bma01
            let l_bmb.bmb02 = (j-1) * 10
            -- let l_bmb.bmb03 = l_data[j][6] -- 元件料号
            let l_cnt = 0
            let l_ima02 = l_data[j][8]
            if cl_null(l_data[j][6]) then
                select count(*) into l_cnt from ima_file where ima02 = l_ima02
            else
                let l_bmb.bmb03 = l_data[j][6]
            end if
            -- 不检查直接报错
            if l_cnt > 1 then
                call scbmp600_imp_result(l_bma.bma01,j,6,sfmt('%1 品名相同元件料号，需手动指定',scbmp600_imp_ima01List(l_ima02)),'warn')
                call s_errmsg('bmb01,bmb03',sfmt("主件:%1 元件:%2",l_bmb.bmb01,l_bmb.bmb03),'元件料号检查失败',g_errno,1)
                let g_success = 'N'
            end if
            if l_cnt = 0 and cl_null(l_data[j][6]) then
                call scbmp600_imp_result(l_bma.bma01,j,6,'需手动指定料号','warn')
                call s_errmsg('bmb01,bmb03',sfmt("主件:%1 元件:%2",l_bmb.bmb01,l_bmb.bmb03),'元件料号检查失败',g_errno,1)
                let g_success = 'N'
            end if 
            if l_cnt = 1 then
                select ima01 into l_bmb.bmb03 from ima_file where ima02 = l_ima02
            end if 
            -- 检查料号
            if not cl_null(l_bmb.bmb03) and l_cnt  <= 1 then
                if not s_chk_item_no(l_bmb.bmb03,'') then
                    call scbmp600_imp_result(l_bma.bma01,j,6,sfmt('%1 料号无法使用',l_bmb.bmb03 ),'warn')
                    call s_errmsg('bmb01,bmb03',sfmt("主件:%1 元件:%2",l_bmb.bmb01,l_bmb.bmb03),'元件料号检查失败',g_errno,1)
                    let g_success = 'N'
                end if 
            end if 
            let l_bmb.bmb04 = g_today
            let l_bmb.bmb06 = l_data[j][10] 
            let l_bmb.bmb07 = 1
            let l_bmb.bmb08 = 0
            let l_bmb.bmb09 = ''
            let l_bmb.bmb10 = l_data[j][11] -- 发料单位
            select ima70,ima25,ima86 into l_bmb.bmb15,l_ima25,l_ima86
              from ima_file where ima01 = l_bmb.bmb03
            call s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_ima25)
                returning l_ok,l_bmb.bmb10_fac
            if l_ok then let l_bmb.bmb10_fac = 1 end if

            call s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_ima86)
                returning l_ok,l_bmb.bmb10_fac2
            if l_ok then let l_bmb.bmb10_fac2 = 1 end if
            let l_bmb.bmb14 = 0
            let l_bmb.bmb16 = 0 -- 取替代
            let l_bmb.bmb17 = 'N'
            let l_bmb.bmb18 = 0
            if l_bmb.bmb03 matches '*-*' then
                let l_bmb.bmb19 = '2'
            else
                let l_bmb.bmb19 = '1'
            end if
            let l_bmb.bmb23 = 100
            let l_bmb.bmb27 = 'N'
            let l_bmb.bmb28 = 0
            let l_bmb.bmbmodu = g_user
            let l_bmb.bmbdate = g_today
            let l_bmb.bmbcomm = 'import'
            let l_bmb.bmb29 = l_bma.bma06
            let l_bmb.bmb30 = ' '
            let l_bmb.bmb31 = 'N'
            let l_bmb.bmb33 = 0
            let l_bmb.bmbud01 = l_data[j][12] --备注
            let l_bmb.bmbud02 = l_data[j][1] -- 工艺发料编码
            let l_bmb.bmbud03 = l_data[j][2] -- 位号
            let l_bmb.bmb081 = 0
            let l_bmb.bmb082 = 1 
            if g_success = 'Y' then
                insert into bmb_file values (l_bmb.*)
                if sqlca.sqlcode or sqlca.sqlerrd[3]==0 then
                    call s_errmsg('bmb01,bmb03',sfmt("主件:%1 元件:%2",l_bmb.bmb01,l_bmb.bmb03),'bmb插入失败',sqlca.sqlcode,1)
                    call scbmp600_imp_result(l_bma.bma01,j,5,sfmt('%1 bmb插入失败',l_bmb.bmb03 ),'warn')
                    let g_success = 'N'
                end if
                # darcy:2025/05/07 add s---
                # 加入替代料
                -- 主键料号:l_bmb.bmb01 元件料号:l_bmb.bmb03
                -- l_data[j][4]
                if not cl_null(l_data[j][4]) then
                    let l_tok = base.StringTokenizer.create(l_data[j][4],',')
                    initialize l_bmd.* to null
                    let l_bmd.bmd01 = l_bmb.bmb03
                    let l_bmd.bmd08 = l_bmb.bmb01
                    let l_bmd.bmd02 = '2'
                    select max(bmd03) into l_bmd.bmd03 from bmd_file
                    where bmd01 = l_bmd.bmd01 and l_bmd.bmd08 = l_bmd.bmd08
                    if cl_null(l_bmd.bmd03) then
                        let l_bmd.bmd03 = 0 
                    end if
                    let l_bmd.bmd05 = g_today
                    let l_bmd.bmd07 = 1
                    -- let l_bmd.bmd09 = g_today
                    let l_bmd.bmdacti = 'Y'
                    let l_bmd.bmddate = g_today
                    let l_bmd.bmdgrup = g_grup
                    let l_bmd.bmduser = g_user
                    let l_bmd.bmdmodu = g_user
                    let l_bmd.bmdoriu = g_grup
                    let l_bmd.bmd11 = 'N'
                    let l_sub = false #darcy:2025/05/12 add
                    while l_tok.hasMoreTokens()
                        let l_bmd.bmd04 = l_tok.nextToken()
                        -- 检查是否存在料号
                        if not cl_null(l_bmd.bmd04) then
                            select count(*) into l_cnt from ima_file
                             where ima01 = l_bmd.bmd04 and ima140 = 'N'
                             and (imaud32 is null or imaud32 <> '1' ) and imaacti = 'Y'
                            if l_cnt <= 0 then
                                call s_errmsg('ima01',l_bmd.bmd04,'料号不存在，或已停用，不能建立取替代资料','!',1)
                                call scbmp600_imp_result(l_bma.bma01,j,4,sfmt('%1 料件不存在，或已停用，不能建立取替代资料',l_bmd.bmd04),'warn')
                                let g_success = 'N'
                            end if
                        end if
                        -- 检查是否已经存在替代料，存在就跳过不报错
                        select count(*) into l_cnt from bmd_file
                         where bmd01 = l_bmd.bmd01 and l_bmd.bmd08 = l_bmd.bmd08
                           and bmd04 = l_bmd.bmd04 and bmd05 <= g_today
                           and (bmd06 is null or bmd06 > g_today)
                        if l_cnt > 0 then
                           continue while
                        end if
                        let l_bmd.bmd03 = l_bmd.bmd03 + 1
                        insert into bmd_file values (l_bmd.*)
                        if sqlca.sqlcode or sqlca.sqlerrd[3]==0 then
                            call s_errmsg('bmd08,bmd01,bmd04',sfmt("主件:%1 元件:%2 替代料件:%3 ",l_bmb.bmb01,l_bmb.bmb03,l_bmd.bmd04),'bmd插入失败',sqlca.sqlcode,1)
                            call scbmp600_imp_result(l_bma.bma01,j,4,sfmt('%1 bmd插入失败',l_bmd.bmd04 ),'warn')
                            let g_success = 'N'
                        else
                            let l_sub = true #darcy:2025/05/12 add
                        end if
                    end while
                    # darcy:2025/05/12 add s---
                    if l_sub then
                        update bmb_file set bmb16 = '2'
                         where bmb01 = l_bmb.bmb01 and bmb03 = l_bmb.bmb03
                    end if
                    # darcy:2025/05/12 add e---
                end if
                # darcy:2025/05/07 add e---
            end if
        end for
    end for
    call s_showmsg() 
    if g_success = 'N' then
        rollback work
        call scbmp600_imp_down_result(l_file)
        return false
    else
        commit work
        return true
    end if
end function

function scbmp600_imp_result(p_sheet,p_row,p_col,p_value,p_style)
    define p_sheet ,p_value ,p_style string
    define p_row,p_col integer
    define idx integer

    let idx = g_result.getlength() + 1
    let g_result[idx].sheet = p_sheet
    let g_result[idx].row = p_row
    let g_result[idx].col = p_col
    let g_result[idx].value = p_value
    let g_result[idx].style = p_style
end function


function scbmp600_imp_ima01List(p_ima02)
    define p_ima02  like ima_file.ima02
    define l_ima01  like ima_file.ima01
    define l_str    varchar(1000)
    define l_sql    string

    let l_sql = "select ima01 from ima_file where ima02 = '",p_ima02,"'"
    prepare scbmp600_imp_ima01 from l_sql
    declare scbmp600_imp_ima01_c cursor for scbmp600_imp_ima01

    FOREACH scbmp600_imp_ima01_c INTO l_ima01
        if sqlca.sqlcode then
            call cl_err('scbmp600_imp_ima01_c',sqlca.sqlcode,1)
            exit foreach
        end if
        let l_str = l_str , '|', l_ima01
    END FOREACH
    return l_str
end function

-- 下载结果文件
function scbmp600_imp_down_result(p_file)
    define p_file   string
    define l_ok varchar(10)
    if g_result.getlength() > 0 then 
        if cl_write(p_file,g_result ) then 
            -- 下载
            if cl_confirm('cbm-040') then
                call cl_download_by_explorer(p_file)
            end if
        else
            message '写入结果至文件失败'
        end if
    end if
end function
