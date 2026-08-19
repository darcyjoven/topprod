# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_record.4gl
# Descriptions...: 一个有目录结构的日志记录程序
# Date & Author..: darcy 2026-08-19

--IMPORT os

DATABASE ds

GLOBALS "../../config/top.global"


-- 样式
define g_style dynamic array of record
    status      varchar(20),
    style       varchar(1000)
end record
-- 导出范围设定
define  g_print_status      varchar(1000)
-- 全局标识
define  g_title             varchar(1000)
define  g_idx               integer
define  g_init              boolean

--  记录日志
--  p_stauts    类型，实现了 error，info，warn 样式
--  p_str       实际内容
function cl_record(p_status,p_str)
    define  p_status    varchar(20),
            p_str       varchar(2000)
    define  l_curr  datetime year to fraction

    let l_curr = current

    if cl_null(g_title) then
        call cl_record_init("")
    end if

    let g_idx = g_idx + 1

    insert into record_temp (idx,sts,lvl,con,tim)
    values (g_idx,p_status,1,p_str,l_curr)

    if sqlca.sqlcode then
        call cl_err('ins record_temp',sqlca.sqlcode,0)
    end if
end function

function cl_record_header(p_str)
    define  p_str       varchar(2000)
    define  l_curr  datetime year to fraction

    let l_curr = current

    if cl_null(g_title) then
        call cl_record_init("")
    end if

    let g_idx = g_idx + 1

    insert into record_temp (idx,sts,lvl,con,tim)
    values (g_idx,'header',0,p_str,l_curr)

    if sqlca.sqlcode then
        call cl_err('ins record_temp',sqlca.sqlcode,0)
    end if
end function

function cl_record_card(p_key,p_val)
    define  p_val,p_key       varchar(2000)
    define  l_curr  datetime year to fraction

    let l_curr = current

    if cl_null(g_title) then
        call cl_record_init("")
    end if

    let g_idx = g_idx + 1

    insert into record_temp (idx,sts,lvl,con,tim)
    values (g_idx,'card',0,p_key,l_curr)

    if sqlca.sqlcode then
        call cl_err('ins record_temp',sqlca.sqlcode,0)
    end if

    let g_idx = g_idx + 1

    insert into record_temp (idx,sts,lvl,con,tim)
    values (g_idx,'card',0,p_val,l_curr)

    if sqlca.sqlcode then
        call cl_err('ins record_temp',sqlca.sqlcode,0)
    end if

end function

-- 初始化默认配置
function cl_record_init(p_title)
    define  p_title  varchar(1000)

    -- 可以自定义为1,2,3,4 用逗号分开的层级
    if g_init then
        return
    end if
    let g_init = true
    let g_print_status = 'error,warn'
    let g_idx = 0

    let g_title = sfmt("%1-%2",g_prog,p_title)
end function


-- 支持化保存
function cl_record_store()

    insert into record_file (title,idx,sts,lvl,con,tim)
    select g_title,idx,sts,lvl,con,tim from record_temp

    if sqlca.sqlcode then
        call cl_err('ins record_file',sqlca.sqlcode,0)
    end if
end function

-- html 邮件

function cl_record_html(p_print_status)
    define  p_print_status      string
    define sr   record
        idx     integer,
        sts     varchar(20),
        lvl     integer,
        con     varchar(2000),
        tim     datetime year to fraction
    end record
    define l_list dynamic array of record
        idx integer,
        con varchar(2000)
    end record
    define i,j,l  integer
    define l_tok base.StringTokenizer
    define l_where,l_sql  string
    define l_html,l_card,l_sum,l_detail string
    define l_temp,l_row,l_col           string
    define l_info,l_error,l_warn    integer
    define l_parent,l_cnt                 integer
    define l_name       string
    define l_default    record
        warn,info,error varchar(2000)
    end record

    if not cl_null(p_print_status) then
        let g_print_status = p_print_status
    end if

    -- 图标
    let l_default.info = '<span style="display: inline-block; padding: 4px 12px; border-radius: 3px; ',
                                'font-size: 12px; font-weight: 600; letter-spacing: 0.3px; white-space: nowrap; ',
                                'background-color: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7;">',
                                '✓ 正常完成 </span>'
    let l_default.warn = '<span style="display: inline-block; padding: 4px 12px; border-radius: 3px; ',
                                'font-size: 12px; font-weight: 600; letter-spacing: 0.3px; white-space: nowrap; ',
                                'background-color: #fff8e1; color: #f57f17; border: 1px solid #ffe082;">',
                                '⚠ 警告</span>'
    let l_default.error = '<span style="display: inline-block; padding: 4px 12px; border-radius: 3px; ',
                                'font-size: 12px; font-weight: 600; letter-spacing: 0.3px; white-space: nowrap; ',
                                'background-color: #ffebee; color: #c62828; border: 1px solid #ef9a9a;">',
                                '✕ 错误</span>'

    -- 下面是日志内容
    LET l_tok = base.StringTokenizer.create(g_print_status,",")
    -- 至少要显示 error
    let l_where = "('error'"
    while l_tok.hasMoreTokens()
        let l_where = l_where,",'",l_tok.nextToken(),"'"
    end while
    let l_where = l_where,")"

    let l_sql = "select idx,sts,lvl,con,tim from record_temp
                  where (lvl = 0 or sts in ",l_where,") and sts != 'card'",
                " order by idx"
    declare cl_record_cur cursor from l_sql

    -- card 部分值
    let l_sql = "select idx,con from record_temp
                  where sts = 'card' ",
                " order by idx"
    declare cl_record_cur1 cursor from l_sql

    call l_list.clear()
    let i = 1
    foreach cl_record_cur1 into l_list[i].*
        if sqlca.sqlcode then
            call cl_err('cl_record_cur1',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call l_list.deleteElement(i)

    let l = l_list.getLength()
    if l > 0 then
        let l_card = '<div style="background-color: #fafbfc; border: 1px solid #e8e8e8; border-radius: 4px; padding: 20px 24px; margin-bottom: 28px;">
                        <table style="width: 100%; border-collapse: collapse; font-size: 14px;">\n'
    end if
    let i = 1
    while i <= l
        if i + 1 <= l then
            if l_list[i+1].idx == l_list[i].idx + 1 then
                let l_card = l_card,sfmt(
                '<tr>
                    <td style="padding: 8px 0; vertical-align: top; width: 120px; color: #666666; font-weight: 500; white-space: nowrap;">%1</td>
                    <td style="padding: 8px 0; vertical-align: top; color: #333333;">%2</td>
                </tr>\n',l_list[i].con,l_list[i+1].con)
                let i = i + 2
            else
                let l_card = l_card,sfmt(
                '<tr>
                    <td style="padding: 8px 0; vertical-align: top; width: 120px; color: #666666; font-weight: 500; white-space: nowrap;">%1</td>
                    <td style="padding: 8px 0; vertical-align: top; color: #333333;">%2</td>
                </tr>\n',l_list[i].con,'')
                let i = i + 1
            end if
        end if
    end while
    if l>0 then
        let l_card = l_card,'</table></div>'
    end if

    let l_detail = '<div style="margin-bottom: 28px;">\n'
    foreach cl_record_cur into sr.*
        if sqlca.sqlcode then
            call cl_err('cl_record_cur',sqlca.sqlcode,1)
            exit foreach
        end if

        -- 切换项目，要统计项目
        if sr.lvl = 0 then
            if l_parent != 0 then
                -- TODO 上笔的的收尾
                let l_row = sfmt(
                            '<div style="border: 1px solid #e8e8e8; border-radius: 4px; margin-bottom: 12px; overflow: hidden;">
                                <div style="display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; font-size: 14px; border-bottom: 1px solid #ffebee;">
                                    <span style="font-weight: 600; color: #333333;">%1</span>\n',l_name)
                select count(*) into l_cnt from record_temp where sts = 'error' and idx between l_parent and sr.idx
                if l_cnt > 0 then
                        let l_row = l_row,l_default.error,"</div>\n"
                        let l_temp = '<div style="padding: 10px 16px 14px 16px; font-size: 13px; background-color: #fff5f5; border-top: 1px dashed #ef9a9a;">'
                else
                    select count(*) into l_cnt from record_temp where sts = 'warn' and idx between l_parent and sr.idx - 1
                    if l_cnt > 0 then
                        let l_row = l_row,l_default.warn,"</div>\n"
                        let l_temp = '<div style="padding: 10px 16px 14px 16px; font-size: 13px; background-color: #fffdf5; border-top: 1px dashed #ffe082;">'
                    else
                        let l_row = l_row,l_default.info,"</div>\n"
                        let l_temp = '<div style="padding: 10px 16px 14px 16px; font-size: 13px;  border-top: 1px dashed;">'
                    end if
                end if
                if l_col matches '*</li>*' then
                    let l_detail = l_detail,l_row,l_temp,l_col,'</ol>\n</div>\n</div>\n'
                else
                    let l_detail = l_detail,l_row,'</div>\n'
                end if
            end if
            let l_parent = sr.idx
            let l_name = sr.con
            let l_col = '\n<ol style="padding: 0 16px ; margin: 0;">\n'
        end if
        case sr.sts
            when 'error'
                let l_error = l_error + 1
                let l_col = l_col,sfmt('<li style="color: #c62828;">错误：%1</li>\n',sr.con)
            when 'warn'
                let l_warn = l_warn + 1
                let l_col = l_col,sfmt('<li style="color: #795548;">警告：%1</li>\n',sr.con)
            when 'info'
                let l_info = l_info + 1
                let l_col = l_col,sfmt('<li>第三步：关上冰箱门</li>\n',sr.con)
        end case

    end foreach
    let l_row = sfmt(
                '<div style="border: 1px solid #e8e8e8; border-radius: 4px; margin-bottom: 12px; overflow: hidden;">
                    <div style="display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; font-size: 14px; border-bottom: 1px solid #ffebee;">
                        <span style="font-weight: 600; color: #333333;">%1</span>\n',l_name)
    select count(*) into l_cnt from record_temp where sts = 'error' and idx between l_parent and sr.idx
    if l_cnt > 0 then
            let l_row = l_row,l_default.error,"</div>\n"
            let l_temp = '<div style="padding: 10px 16px 14px 16px; font-size: 13px; background-color: #fff5f5; border-top: 1px dashed #ef9a9a;">'
    else
        select count(*) into l_cnt from record_temp where sts = 'warn' and idx between l_parent and sr.idx - 1
        if l_cnt > 0 then
            let l_row = l_row,l_default.warn,"</div>\n"
            let l_temp = '<div style="padding: 10px 16px 14px 16px; font-size: 13px; background-color: #fffdf5; border-top: 1px dashed #ffe082;">'
        else
            let l_row = l_row,l_default.info,"</div>\n"
            let l_temp = '<div style="padding: 10px 16px 14px 16px; font-size: 13px;  border-top: 1px dashed;">'
        end if
    end if
    if l_col matches '*</li>*' then
        let l_detail = l_detail,l_row,l_temp,l_col,'</ol>\n</div>\n</div>\n'
    else
        let l_detail = l_detail,l_row,'</div>\n'
    end if

    let l_detail = l_detail,'</div>\n'

    let l_sum = '<div style="display: flex; gap: 16px; margin-bottom: 28px; flex-wrap: wrap;">\n'
    if g_print_status matches '*info*' then
        let l_sum = l_sum ,
                    sfmt('<div style="flex: 1; min-width: 130px; padding: 14px 16px; border-radius: 4px; text-align: center; font-size: 13px; background-color: #e8f5e9; border: 1px solid #c8e6c9;">
                            <span style="font-size: 28px; font-weight: 700; display: block; margin-bottom: 2px; color: #2e7d32;">%1</span>
                            <span style="color: #666666; font-size: 12px;">✓ 正常完成</span>
                          </div>\n',l_info)
    end if
    if g_print_status matches '*warn*' then
        let l_sum = l_sum ,
                    sfmt('<div style="flex: 1; min-width: 130px; padding: 14px 16px; border-radius: 4px; text-align: center; font-size: 13px; background-color: #fff8e1; border: 1px solid #ffecb3;">
                                <span style="font-size: 28px; font-weight: 700; display: block; margin-bottom: 2px; color: #f57f17;">2</span>
                                <span style="color: #666666; font-size: 12px;">⚠ 警告</span>
                          </div>\n',l_warn)
    end if
    if g_print_status matches '*error*' then
        let l_sum = l_sum ,
                    sfmt('<div style="flex: 1; min-width: 130px; padding: 14px 16px; border-radius: 4px; text-align: center; font-size: 13px; background-color: #ffebee; border: 1px solid #ffcdd2;">
                            <span style="font-size: 28px; font-weight: 700; display: block; margin-bottom: 2px; color: #c62828;">1</span>
                            <span style="color: #666666; font-size: 12px;">✕ 错误</span>
                          </div>\n',l_error)
    end if
    let l_sum = l_sum,'</div>'

    let l_html = '<body style="font-family: \'Microsoft YaHei\', \'PingFang SC\', \'Helvetica Neue\', Arial, sans-serif; ',
                              'background-color: #f5f6f8; color: #333333; line-height: 1.6; padding: 20px; margin: 0;">\n',
                 '  <div style="max-width: 680px; margin: 0 auto; background-color: #ffffff; border: 1px solid #e0e0e0; border-radius: 4px; overflow: hidden;">\n',
                        '<div style="background-color: #2c3e50; padding: 20px 30px; border-bottom: 3px solid #1a252f;">
                             <h1 style="color: #ffffff; font-size: 20px; font-weight: 600; letter-spacing: 0.5px; margin: 0;">后台程序执行状态提醒</h1>
                             <div style="color: #bdc3c7; font-size: 13px; margin-top: 4px;">Automated Task Execution Report</div>
                        </div>\n',
                        '<div style="padding: 30px;">\n',
                            '<p style="font-size: 15px; color: #333333; margin: 0 0 24px 0;">
                                <strong style="color: #2c3e50;">您好：</strong><br>以下为本次后台程序批量执行的结果汇总，请查阅。
                            </p>\n',
                            l_card,l_sum,
                            '<div style="display: flex; gap: 20px; font-size: 12px; color: #666666; margin-bottom: 20px; flex-wrap: wrap;">
                                <span style="display: flex; align-items: center; gap: 6px;">
                                    <span style="width: 10px; height: 10px; border-radius: 50%; display: inline-block; background-color: #4caf50;"></span>
                                    正常完成（绿色）
                                </span>
                                <span style="display: flex; align-items: center; gap: 6px;">
                                    <span style="width: 10px; height: 10px; border-radius: 50%; display: inline-block; background-color: #ffc107;"></span>
                                    警告（黄色）
                                </span>
                                <span style="display: flex; align-items: center; gap: 6px;">
                                    <span style="width: 10px; height: 10px; border-radius: 50%; display: inline-block; background-color: #f44336;"></span>
                                    错误（红色）
                                </span>
                            </div>\n',
                            '<div style="font-size: 16px; font-weight: 600; color: #2c3e50; margin-bottom: 16px; padding-left: 10px; border-left: 4px solid #2c3e50; line-height: 1.3;">任务执行明细</div>\n',
                            l_detail,
                        '</div>\n',
                 '  </div>\n',
                 '</body>\n'
    let l_html = sfmt('<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>%1</title>
</head>\n',g_title),l_html,'</html>'

    return l_html
end function
