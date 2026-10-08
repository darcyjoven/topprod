# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: cnms700.4gl
# Descriptions...: 银行贷款工作台
# Date & Author..: 26-09-17 By darcy

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/anm/4gl/s_credit.global"


define  g_head      record
    credit_limit    decimal(20,6),
    used_limit      decimal(20,6),
    credit_bar      decimal(10,3),
    loan_amount     decimal(20,6),
    repaid_bala     decimal(20,6),
    loan_bar        decimal(10,3),
    last_bala       date,
    last_inter      date,
    to_bala         integer,
    to_inter        integer
end record
define  tm      record
    remainings      integer,
    bank01          varchar(20),
    start           date,
    end             date,
    bank02          varchar(20)
end record

define g_rec_b      integer

MAIN
    options
       input no wrap
    defer interrupt

    if (not cl_user()) then
        exit program
    end if

    whenever error call cl_err_msg_log

    if (not cl_setup("CNM")) then
        exit program
    end if

    call  cl_used(g_prog,g_time,1) returning g_time

    open window cnms700_w at 1,6 with form "cnm/42f/cnms700"
        attribute (style = g_win_style clipped)

    call cl_ui_init()
    call cnms700_bank_comp()

    call cnms700_default()
    call cnms700()

    close window cnms700_w
    call  cl_used(g_prog,g_time,2) returning g_time
END MAIN

function cnms700_default()

    let tm.remainings = 30
    let tm.start = mdy(1,1,year(g_today))
    let tm.end = mdy(12,31,year(g_today))

    call cnms700_show()
end function

# 主入口
function cnms700()
    while true
        call cnms700_bp()
        case g_action_choice
            when 're_search'
            when 'refresh'
            when 'pay_bala'
            when 'pay_inter'
            when 'exporttoexcel'
                if cl_chk_act_auth() then
                     call cl_download_by_explorer(
                        cl_expexcel(
                            "s_to_pay",base.typeinfo.create(g_topay),
                            "s_history",base.typeinfo.create(g_history),
                            '',null
                        ))
                end if
            when 'exit'
                exit while
        end case
    end while
end function

# 显示
function cnms700_bp()
    call cl_set_act_visible('accept,cancel',false)
    dialog attributes(unbuffered)
        input by name tm.*  attributes (WITHOUT DEFAULTS)
        end input

        input array g_topay from s_topay.*
            attribute(count=g_rec_b,maxcount=g_max_rec,
            insert row=false,delete row=false,append row=false,WITHOUT DEFAULTS)
        end input

        display array g_history to s_history.* attribute(count=g_rec_b)
        end display

        before dialog
            --call cl_navigator_setting(g_curs_index, g_row_count)
        on action re_search
            let g_action_choice = 're_search'
            exit dialog
        on action refresh
            let g_action_choice = 'refresh'
            exit dialog
        on action pay_bala
            let g_action_choice = 'pay_bala'
            exit dialog
        on action pay_inter
            let g_action_choice = 'pay_inter'
            exit dialog

        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice = 'exit'
            exit dialog

        on action cancel
            let int_flag = false
            let g_action_choice = 'exit'
            exit dialog

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog

        on action about
            call cl_about()

        on action help
            call cl_show_help()
    end dialog
    call cl_set_act_visible('accept,cancel',true)
end function

# 栏位显示
function cnms700_show()
    define  l_amt       decimal(20,6),
            l_dat       date

    # 今天日期
    display g_today to cur_dat

    # 额度
    select sum(nno08) into g_head.credit_limit from nno_file
     where nno05 >= g_today and nnoacti = 'Y' and (nno09 = 'N' or nno09 is null )
    if cl_null(g_head.credit_limit) then let g_head.credit_limit = 0 end if
    select sum(nne19-nne20) into g_head.used_limit from nne_file
     where nneconf = 'Y' and nne19 > nne20
    if cl_null(g_head.used_limit) then let g_head.used_limit = 0 end if
    select sum(nng22-nng23) into l_amt from nng_file
     where nngconf = 'Y' and nng22 > nng23
    if cl_null(l_amt) then let l_amt = 0 end if
    let g_head.used_limit = g_head.used_limit + l_amt
    let g_head.credit_bar = g_head.used_limit * 100 / g_head.credit_limit

    # 贷款
    select sum(nne19) into g_head.loan_amount from nne_file
     where nneconf = 'Y' and nne19 > nne20
    if cl_null(g_head.loan_amount) then let g_head.loan_amount = 0 end if
    select sum(nng22) into l_amt from nng_file
     where nngconf = 'Y' and nng22 > nng23
    if cl_null(l_amt) then let l_amt = 0 end if
    let g_head.loan_amount = g_head.loan_amount + l_amt
    let g_head.repaid_bala = g_head.loan_amount - g_head.used_limit
    let g_head.loan_bar = g_head.repaid_bala * 100 / g_head.loan_amount

    # 最后还息
    select max(nne33) into g_head.last_inter from nne_file where nneconf = 'Y'
    select max(nng26) into l_dat from nng_file where nngconf = 'Y'
    if cl_null(g_head.last_inter) then
        let g_head.last_inter = l_dat
    end if
    if l_dat > g_head.last_inter then
        let g_head.last_inter = l_dat
    end if
    # 最后还本
    select max(nnk02) into g_head.last_bala from nnk_file where nnkconf = 'Y'

    # 还息代办
    call s_crd_biz_to_inter(0,null,null)
    let g_head.to_inter = g_tointer.getLength()

    # 还本代办
    call s_crd_biz_to_bala(0,null)
    let g_head.to_bala = g_topay.getLength()

    --display by name g_head.*
    display g_head.credit_limit to credit_limit
    display g_head.used_limit   to used_limit
    display g_head.credit_bar   to credit_bar
    display g_head.loan_amount  to loan_amount
    display g_head.repaid_bala  to repaid_bala
    display g_head.loan_bar     to loan_bar
    display g_head.last_bala    to last_bala
    display g_head.last_inter   to last_inter
    display g_head.to_bala      to to_bala
    display g_head.to_inter     to to_inter

    display g_head.loan_bar to loan_per
    display g_head.credit_bar to credit_per

    --display by name tm.*
    display tm.remainings  to remainings
    display tm.bank01      to bank01
    display tm.start       to start
    display tm.end         to end
    display tm.bank02      to bank02

    call cnms700_b_fill()

end function

# 刷新
function cnms700_refresh()
end function

# 单身显示
function cnms700_b_fill()
    call s_crd_biz_to_bala(tm.remainings,tm.bank01)
    call s_crd_biz_pay_history(tm.start,tm.end,tm.bank02,null)
end function


function cnms700_bank_comp()
    define  l_alg01         like alg_file.alg01,
            l_alg02         like alg_file.alg02,
            l_val,l_desc    string

    declare bank_comp cursor for
    select alg01, alg02 from alg_file order by alg01

    foreach bank_comp into l_alg01,l_alg02
        if sqlca.sqlcode then
            call cl_err('back_comp',sqlca.sqlcode,1)
            exit foreach
        end if
        let l_val = l_val , ',' , l_alg01
        let l_desc = l_desc , ',' , l_alg01 , ':' , l_alg02
    end foreach
    call cl_set_combo_items("bank01",l_val,l_desc)
    call cl_set_combo_items("bank02",l_val,l_desc)
end function
