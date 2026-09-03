# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: cimi501.4gl
# Descriptions...: 销售、计划预测维护

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

type tc_ili record
    tc_ili01    like tc_ili_file.tc_ili01,
    tc_ili02    like tc_ili_file.tc_ili02,
    tc_ili03    like tc_ili_file.tc_ili03,
    tc_ili04    like tc_ili_file.tc_ili04,
    tc_ili05    like tc_ili_file.tc_ili05,
    tc_ili06    like tc_ili_file.tc_ili06
end record


define  g_yy,g_mm,l_ac,g_rec_b          integer
define  g_sql,g_msg,g_wc                string
define  g_typ                           varchar(1)

define g_tc_ili         dynamic array of tc_ili
define g_tc_ili_t       tc_ili

define g_no_ask         boolean

define g_sum    decimal(20,3)

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("CIM")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW cimi501_w AT 2,2 WITH FORM "cim/42f/cimi501"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
    call cl_ui_init()
    call cimi501_init()

    call cimi501_q()
    call cimi501_menu()

    close window cimi501_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

--
function cimi501_init()
    define i    integer
    define l_str    string

end function

function cimi501_menu()
    while true
        call cimi501_bp()
        case g_action_choice
            when "query"
                if cl_chk_act_auth() then
                    call cimi501_q()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call cimi501_b()
                end if
            when "delete"
                if cl_chk_act_auth() then
                    call cimi501_delete()
                end if
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(cl_expexcel1("s_tc_ili",base.typeinfo.create(g_tc_ili)))
                end if
            when 'import'
                if cl_chk_act_auth() then
                    call cimi501_import()
                end if
            when "exit"
                exit while
        end case
    end while
end function
function cimi501_b_ask()
    construct g_wc on tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05,tc_ili06
        from s_tc_ili[1].tc_ili01,s_tc_ili[1].tc_ili02,s_tc_ili[1].tc_ili03,s_tc_ili[1].tc_ili04,s_tc_ili[1].tc_ili05,s_tc_ili[1].tc_ili06

        before construct
            call cl_qbe_init()

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action controlg
            call cl_cmdask()

    end construct
end function
function cimi501_q()
    define l_m1,l_m2,l_y    integer
    define l_t1,l_t2        integer
    define i,j,l            integer

    clear form


    message '查询中……'

    call cimi501_b_ask()
    if int_flag then
        let g_action_choice = 'exit'
        let int_flag = false
        return
    end if

    message ''

    call cimi501_b_fill()
end function


function cimi501_b()
    define  p_cmd,l_lock_sw       varchar(1)
    define  l_ac_t,i,l_cnt        integer

    let g_sql = "select tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05,tc_ili06 from tc_ili_file ",
                " where tc_ili01 = ? and tc_ili02 = ? and tc_ili03 = ? and tc_ili04 = ? and tc_ili05 = ? for update"
    declare cimi501_bcl cursor from g_sql

    message '录入中……'

    input array g_tc_ili without defaults from s_tc_ili.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=true,delete row=false,append row=true)

        before input
            if g_rec_b != 0 then
                call fgl_set_arr_curr(l_ac)
            end if

        before row
            -- 刷新资料
            let p_cmd=''
            let l_ac = ARR_CURR()
            let l_lock_sw = 'N'
            if g_rec_b >= l_ac then
                begin work
                let p_cmd = 'u'
                let g_tc_ili_t.* = g_tc_ili[l_ac].*
                -- 设置栏位是否能够录入
                call cimi501_set_entry_b(p_cmd)
                call cimi501_set_no_entry_b(p_cmd)
                -- 刷新栏位的值
                open cimi501_bcl using g_tc_ili_t.tc_ili01,g_tc_ili_t.tc_ili02,g_tc_ili_t.tc_ili03,g_tc_ili_t.tc_ili04,g_tc_ili_t.tc_ili05
                if status then
                    call cl_err('open cimi501_bcl',status,1)
                    let l_lock_sw = 'Y'
                else
                    fetch cimi501_bcl into g_tc_ili[l_ac].*
                    if sqlca.sqlcode then
                        call cl_err(g_tc_ili_t.tc_ili01,sqlca.sqlcode,1)
                        let l_lock_sw = 'Y'
                    end if
                    -- 这里可以查询一些说明栏位
                end if
                -- 刷新一些特殊栏位
                call cl_show_fld_cont()
            end if

        before insert
            -- 录入默认值
            let p_cmd = 'a'
            call cimi501_set_entry_b(p_cmd)
            call cimi501_set_no_entry_b(p_cmd)
            initialize g_tc_ili[l_ac].* to null
            let g_tc_ili_t.* = g_tc_ili[l_ac].*
            call cl_show_fld_cont()

        after field tc_ili03
            if not cl_null(g_tc_ili[l_ac].tc_ili03) then
                if year(g_tc_ili[l_ac].tc_ili03) <> g_tc_ili[l_ac].tc_ili01 or month(g_tc_ili[l_ac].tc_ili03) <> g_tc_ili[l_ac].tc_ili02 then
                    call cl_err(sfmt("%1 与期别%2-%3 对应不上，请重新输入",g_tc_ili[l_ac].tc_ili03,g_tc_ili[l_ac].tc_ili01,g_tc_ili[l_ac].tc_ili02),'!',1)
                    next field tc_ili03
                end if
            end if
        after field tc_ili04
            if not cl_null(g_tc_ili[l_ac].tc_ili04) then
                if g_tc_ili[l_ac].tc_ili04 != 'product' and g_tc_ili[l_ac].tc_ili04 != 'sale' then
                    call cl_err(sfmt("%1 只能是 product 或者 sale ",g_tc_ili[l_ac].tc_ili04),'!',1)
                    next field tc_ili04
                end if
            end if
        after field tc_ili05
            if not cl_null(g_tc_ili[l_ac].tc_ili05) then
                if g_tc_ili[l_ac].tc_ili04 = 'product' then
                    if g_tc_ili[l_ac].tc_ili05 != 'smt' and g_tc_ili[l_ac].tc_ili05 != 'fpc' and g_tc_ili[l_ac].tc_ili05 != 'comp' then
                        if g_tc_ili[l_ac].tc_ili05 = 'all' then
                            call cl_err(g_tc_ili[l_ac].tc_ili05||" 计划只能录入 smt 、 fpc 或者 comp",'!',1)
                            next field tc_ili05
                        end if
                    end if
                else
                    if g_tc_ili[l_ac].tc_ili04 = 'sale' then
                        if g_tc_ili[l_ac].tc_ili05 != 'all' then
                            call cl_err(g_tc_ili[l_ac].tc_ili05||"销售只能录入all类型",'!',1)
                            next field tc_ili05
                        end if
                    else
                        call cl_err("先录入销售/计划栏位",'!',1)
                        next field tc_ili04
                    end if
                end if
            end if

        on row change
            -- 更新数据
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = false
                let g_tc_ili[l_ac].* = g_tc_ili_t.*
                    close cimi501_bcl
                    rollback work
                exit input
            end if
            if l_lock_sw = 'Y' then
                call cl_err(g_tc_ili[l_ac].tc_ili01,-263,0)
                let g_tc_ili[l_ac].* = g_tc_ili_t.*
            else
                update tc_ili_file set tc_ili06 = g_tc_ili[l_ac].tc_ili06
                 where tc_ili01 = g_tc_ili_t.tc_ili01
                   and tc_ili02 = g_tc_ili_t.tc_ili02
                   and tc_ili03 = g_tc_ili_t.tc_ili03
                   and tc_ili04 = g_tc_ili_t.tc_ili04
                   and tc_ili05 = g_tc_ili_t.tc_ili05
                if sqlca.sqlcode then
                    call cl_err3('upd','tc_ili_file',g_tc_ili[l_ac].tc_ili01,'',sqlca.sqlcode,'','',1)
                    let g_tc_ili[l_ac].* = g_tc_ili_t.*
                else
                    commit work
                end if
            end if
            let g_sum = 0
            for i = 1 to g_tc_ili.getLength()
                if not cl_null(g_tc_ili[i].tc_ili03) then
                    let g_sum = g_sum + g_tc_ili[i].tc_ili03
                end if
            end for

        before delete
            call cl_err('编辑状态不可以删除，请退出后根据条件删除','!',1)
            cancel delete

        after row
            let l_ac = arr_curr()
            if int_flag then
                -- 取消新增/更改
                --call cl_err('',-400,0)
                let int_flag = false
                if p_cmd = 'u' then
                    -- 还原旧数据
                    let g_tc_ili[l_ac].* = g_tc_ili_t.*
                else
                    -- 删除旧数据
                    call g_tc_ili.deleteElement(l_ac)
                    if g_rec_b!=0 then
                        let g_action_choice = 'detail'
                        let l_ac = l_ac_t
                    end if
                end if
                close cimi501_bcl
                rollback work
                exit input
            end if

        after insert
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                close cimi501_bcl
                cancel insert
            end if

            select count(*) into l_cnt from tc_ili_file
             where  tc_ili01 = g_tc_ili[l_ac].tc_ili01
                and tc_ili02 = g_tc_ili[l_ac].tc_ili02
                and tc_ili03 = g_tc_ili[l_ac].tc_ili03
                and tc_ili04 = g_tc_ili[l_ac].tc_ili04
                and tc_ili05 = g_tc_ili[l_ac].tc_ili05

            if l_cnt > 0 then
                call cl_err('资料重复','!',1)
                cancel insert
            end if

            begin work

            insert into tc_ili_file(tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05,tc_ili06)
                values (g_tc_ili[l_ac].*)
            if sqlca.sqlcode then
                call cl_err('ins tc_ili_file',sqlca.sqlcode,1)
                rollback work
                cancel insert
            end if
            let g_rec_b = g_rec_b + 1
            display g_rec_b to cnt
            commit work

        on action controlo
            -- 复制上一行
            if infield(tc_ili03) and l_ac > 1 then
                let g_tc_ili[l_ac].* = g_tc_ili[l_ac-1].*
                let g_tc_ili[l_ac].tc_ili06 = 0
                let g_tc_ili[l_ac].tc_ili03 = g_tc_ili[l_ac].tc_ili03 + 1
                next field tc_ili06
            end if

        on action controlr
            call cl_show_req_fields()

        on action controlf
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue input

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end input
    message ''
end function
function cimi501_b_fill()
    define  i,l_cnt       integer
    define  l_dat   date

    let g_sql = "select tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05,tc_ili06 ",
                "  from tc_ili_file ",
                " where  1=1 and ",g_wc clipped,
                " order by tc_ili01,tc_ili02,tc_ili04,tc_ili06,tc_ili03"
    prepare cimi501_fill_p from g_sql
    declare cimi501_fill_cur cursor for cimi501_fill_p

    call g_tc_ili.clear()
    let i = 1
    let g_sum = 0
    foreach cimi501_fill_cur into g_tc_ili[i].*
        if sqlca.sqlcode then
            call cl_err('cimi501_fill_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_tc_ili.deleteElement(i)
    let g_rec_b = i - 1
    display g_rec_b to cnt
end function

function cimi501_bp()
    call cl_set_act_visible("accept,cancel", false)

    display array g_tc_ili to s_tc_ili.* attribute(count=g_rec_b)

        before display

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()

        on action query
            let g_action_choice = 'query'
            exit display

        on action detail
            let g_action_choice = 'detail'
            exit display

        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display

        on action delete
            let g_action_choice = 'delete'
            exit display

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice = 'exit'
            exit display

        on action accept
            let g_action_choice = 'detail'
            let l_ac = arr_curr()
            exit display

        on action cancel
            let int_flag = false
            let g_action_choice = 'exit'
            exit display

        on action import
            let g_action_choice = 'import'
            exit display

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue display

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        after display
            continue display

    end display
    call cl_set_act_visible("accept,cancel", true)
end function

--
function cimi501_import()
    define l_yy,l_mm        integer
    define l_amt            decimal(20,3)
    define l_cnt,i          integer
    define l_dat            date

    OPEN WINDOW cimi501_2_w AT 2,2 WITH FORM "cim/42f/cimi501_2"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
    call cl_ui_init()

    input l_yy,l_mm,l_amt without defaults from saleyy,salemm,saleamt

        before input
            let l_yy = year(g_today)
            let l_mm = month(g_today)
            let l_amt = 0
            display l_yy,l_mm,l_amt to saleyy,salemm,saleamt

        on action controlr
            call cl_show_req_fields()

        on action controlf
            -- 切换语言
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue input

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end input

    if int_flag then
        let int_flag = false
        goto _err2
    end if

    select count(*) into l_cnt from tc_ili_file where tc_ili01 = l_yy and tc_ili02 = l_mm
       and tc_ili04='sale' and tc_ili05 = 'all'
    if l_cnt > 0 then
        if not cl_confirm('cim-097') then
            goto _err2
        end if
    end if

    begin work

    delete from tc_ili_file where tc_ili01 = l_yy and tc_ili02 = l_mm
       and tc_ili04='sale' and tc_ili05 = 'all'
    if sqlca.sqlcode then
        call cl_err('del tc_ili_file',sqlca.sqlcode,1)
        rollback work
        goto _err2
    end if

    if l_mm = 12 then
        let l_cnt = 31
    else
        let l_cnt = mdy(l_mm+1,1,l_yy) - mdy(l_mm,1,l_yy)
    end if

    let l_dat = mdy(l_mm,1,l_yy) - 1
    let l_amt = l_amt / l_cnt
    for i = 1 to l_cnt
        let l_dat = l_dat + 1
        insert into tc_ili_file(tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05,tc_ili06)
        values (l_yy,l_mm,l_dat,'sale','all',l_amt)
        if sqlca.sqlcode then
            call cl_err('ins tc_ili_file',sqlca.sqlcode,1)
            rollback work
            goto _err2
        end if
    end for

    message '完成'

    commit work

    label _err2:
    close window cimi501_2_w
    call cimi501_b_fill()
end function
function cimi501_delete()
    define l_wc         string
    define l_cnt        integer


    OPEN WINDOW cimi501_1_w AT 2,2 WITH FORM "cim/42f/cimi501_1"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
    call cl_ui_init()

    construct l_wc on tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05
         from yy,mm,dat,typ1,typ2

        before construct
            call cl_qbe_init()

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action controlg
            call cl_cmdask()

    end construct

    if int_flag then
        let int_flag = false
        goto _err
    end if

    let g_sql = "select count(*) from tc_ili_file where 1=1 and ",l_wc clipped
    prepare cimi501_del_p1 from g_sql
    execute cimi501_del_p1 into l_cnt

    if l_cnt <= 0 then
        call cl_err( '无数据需要删除','!',1)
        goto _err
    end if

    if not cl_confirm_parm('cim-096',l_cnt) then
    goto _err
    end if

    let g_sql = "delete from tc_ili_file where 1=1 and ",l_wc clipped
    prepare cimi501_del_p2 from g_sql
    execute cimi501_del_p2
    if sqlca.sqlcode then
        call cl_err('del tc_ili',sqlca.sqlcode,1)
        goto _err
    end if

    label _err:

    close window cimi501_1_w

    call cimi501_b_fill()
end function


function cimi501_set_entry_b(p_cmd)
    define p_cmd    varchar(1)
    if p_cmd = 'a' then
         call cl_set_comp_entry('tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05',true)
    end if
end function
function cimi501_set_no_entry_b(p_cmd)
    define p_cmd    varchar(1)
    if p_cmd = 'u' then
        call cl_set_comp_entry('tc_ili01,tc_ili02,tc_ili03,tc_ili04,tc_ili05',false)
    end if
end function
