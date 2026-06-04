# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_action.4gl
# Descriptions...: 单据动作记录
# Date & Author..: darcy 26/06/03

database ds
globals "../../../tiptop/config/top.global"

type tc_pos record
    tc_pos01        like tc_pos_file.tc_pos01, -- 单据编号
    tc_pos02        like tc_pos_file.tc_pos02, -- 项次
    tc_pos03        like tc_pos_file.tc_pos03, -- 作业编号
    tc_pos04        like tc_pos_file.tc_pos04, -- 用户
    tc_pos05        like tc_pos_file.tc_pos05, -- 部门
    tc_pos06        like tc_pos_file.tc_pos06, -- 日期
    tc_pos07        like tc_pos_file.tc_pos07, -- 时间
    tc_pos08        like tc_pos_file.tc_pos08, -- 类型
    tc_pos09        like tc_pos_file.tc_pos09
end record

type tc_pot record
    tc_pot01        like tc_pot_file.tc_pot01, -- 用户
    tc_pot02        like tc_pot_file.tc_pot02, -- 作业编号
    tc_pot03        like tc_pot_file.tc_pot03, -- 类型
    tc_pot04        like tc_pot_file.tc_pot04, -- 上次用户
    tc_pot05        like tc_pot_file.tc_pot05, -- 上次部门
    tc_pot06        like tc_pot_file.tc_pot06  -- 日期
end record

define  g_tc_pos,g_tc_pos_t     tc_pos
define  g_date          boolean

-- p_prog           作业编号
-- p_doc            单据编号
-- p_seq            项次
-- p_type           操作类型
-- p_user           默认用户
-- p_grup           默认部门
-- p_post           是否能弹窗修改
-- p_date           是否能修改日期
function cl_action(p_prog,p_doc,p_seq,p_type,p_user,p_grup,p_post,p_date)
    define  p_prog          like tc_pos_file.tc_pos03,
            p_doc           like tc_pos_file.tc_pos01,
            p_seq           like tc_pos_file.tc_pos02,
            p_type          varchar(20),
            p_user  like tc_pos_file.tc_pos04,
            p_grup  like tc_pos_file.tc_pos05,
            p_post          boolean,
            p_date          boolean
    define  l_type          varchar(1)
    define  l_user,l_grup   varchar(20)

    let g_date = p_date

    initialize g_tc_pos.* to null

    # 默认值
    let g_tc_pos.tc_pos01 = p_doc
    if cl_null(p_seq) then
        let g_tc_pos.tc_pos02 = 0
    else
        let g_tc_pos.tc_pos02 = p_seq
    end if
    let g_tc_pos.tc_pos03 = p_prog
    let g_tc_pos.tc_pos04 = p_user
    let g_tc_pos.tc_pos05 = p_grup
    let g_tc_pos.tc_pos06 = g_today
    let g_tc_pos.tc_pos07 = current hour to second
    let g_tc_pos.tc_pos08 = cl_action_type(p_type)
    let g_tc_pos.tc_pos09 = g_user

    # 再进行一次上次使用的记录检查
    if cl_null(g_tc_pos.tc_pos04||g_tc_pos.tc_pos05) then
        call cl_action_last(p_prog,g_tc_pos.tc_pos08,g_today) returning l_user,l_grup
        if cl_null(g_tc_pos.tc_pos04) then
            let g_tc_pos.tc_pos04 = l_user
        end if
        if cl_null(g_tc_pos.tc_pos05) then
            let g_tc_pos.tc_pos05 = l_grup
        end if
    end if

    if cl_null(g_tc_pos.tc_pos04) then
        let g_tc_pos.tc_pos04 = g_user
    end if

    # 如果部门为空再从用户资料带出一次
    if cl_null(g_tc_pos.tc_pos05) and not cl_null(g_tc_pos.tc_pos04) then
        select gen03 into g_tc_pos.tc_pos05 from gen_file
         where gen01 = g_tc_pos.tc_pos04
    end if

    # 过账的情况下，允许输入用户、部门、日期
    if p_post then
        call cl_action_i()
        if int_flag then
            let int_flag = false
            return false
        end if
    end if

    # 资料插入
    insert into tc_pos_file (tc_pos01,tc_pos02,tc_pos03,tc_pos04,tc_pos05,tc_pos06,tc_pos07,tc_pos08,tc_pos09)
    values(g_tc_pos.tc_pos01,g_tc_pos.tc_pos02,g_tc_pos.tc_pos03,g_tc_pos.tc_pos04,
           g_tc_pos.tc_pos05,g_tc_pos.tc_pos06,g_tc_pos.tc_pos07,g_tc_pos.tc_pos08,
           g_tc_pos.tc_pos09)
    if sqlca.sqlcode then
        call cl_err('ins tc_pos_file',sqlca.sqlcode,1)
        return false
    end if

    # 更新上次操作记录
    call cl_action_record()
    return true
end function

--  进行输入
function cl_action_i()
    define  p_post          boolean
    define  l_tc_pos04_desc like gen_file.gen02,
            l_tc_pos05_desc like gem_file.gem02,
            l_genacti       like gen_file.genacti,
            l_gemacti       like gem_file.gemacti

    OPEN WINDOW cl_action_w AT 2,2 WITH FORM "clib/42f/cl_post" ATTRIBUTE (STYLE = g_win_style CLIPPED)
    call cl_ui_init()
    call cl_action_ui()

    display by name g_tc_pos.tc_pos01,g_tc_pos.tc_pos02,g_tc_pos.tc_pos03,g_tc_pos.tc_pos04,
                    g_tc_pos.tc_pos05,g_tc_pos.tc_pos06,g_tc_pos.tc_pos07,g_tc_pos.tc_pos08
    select gen02 into l_tc_pos04_desc from gen_file where gen01 = g_tc_pos.tc_pos04
    select gem02 into l_tc_pos05_desc from gem_file where gem01 = g_tc_pos.tc_pos05
    display l_tc_pos04_desc,l_tc_pos05_desc to tc_pos04_desc,tc_pos05_desc

    input by name g_tc_pos.tc_pos01,g_tc_pos.tc_pos02,g_tc_pos.tc_pos04,
                  g_tc_pos.tc_pos05,g_tc_pos.tc_pos06,g_tc_pos.tc_pos07,g_tc_pos.tc_pos08 without defaults

        after field tc_pos04
            if not cl_null(g_tc_pos.tc_pos04) then
                select gen02,genacti into l_tc_pos04_desc,l_genacti from gen_file
                 where gen01 = g_tc_pos.tc_pos04
                if sqlca.sqlcode or l_genacti <> 'Y' then
                    call cl_err(g_tc_pos.tc_pos04,"mfg1312",1)
                    next field tc_pos04
                end if
                display l_tc_pos04_desc to tc_pos04_desc
            end if
        after field tc_pos05
            if not cl_null(g_tc_pos.tc_pos05) then
                select gem02,gemacti into l_tc_pos05_desc,l_gemacti from gem_file
                 where gem01 = g_tc_pos.tc_pos05
                if sqlca.sqlcode or l_gemacti <> 'Y' then
                    call cl_err(g_tc_pos.tc_pos04,"mfg3097",1)
                    next field tc_pos05
                end if
                display l_tc_pos05_desc to tc_pos05_desc
            end if

        on action controlp
            -- 开窗
            case
                when infield(tc_pos04)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_gen'
                    call cl_create_qry() returning g_tc_pos.tc_pos04
                    display by name g_tc_pos.tc_pos04
                when infield(tc_pos05)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_gem'
                    call cl_create_qry() returning g_tc_pos.tc_pos05
                    display by name g_tc_pos.tc_pos05
                otherwise
            end case

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

    close window cl_action_w
end function

-- 从字符串变为类型
function cl_action_type(p_type)
    define  p_type          varchar(20)
    case p_type
        when 'create'
            return '1'
        when 'delete'
            return '2'
        when 'modify'
            return '3'
        when 'confirm'
            return '4'
        when 'unconfirm'
            return '5'
        when 'post'
            return '6'
        when 'unpost'
            return '7'
        when 'close'
            return '8'
        when 'open'
            return '9'
        when 'void'
            return 'a'
        when 'unvoid'
            return 'b'
        when 'sign'
            return 'c'
        when 'voucher'
            return 'd'
        when 'unvoucher'
            return 'e'
        otherwise
            return '0'
    end case
    return '0'
end function

-- 从类型变成说明文字
function cl_action_type_desc(p_type)
    define  p_type          like tc_pot_file.tc_pot03
    case p_type
        when '1'
            return 'create'
        when '2'
            return 'delete'
        when '3'
            return 'modify'
        when '4'
            return 'confirm'
        when '5'
            return 'unconfirm'
        when '6'
            return 'post'
        when '7'
            return 'unpost'
        when '8'
            return 'close'
        when '9'
            return 'open'
        when 'a'
            return 'void'
        when 'b'
            return 'unvoid'
        when 'c'
            return 'sign'
        when 'd'
            return 'voucher'
        when 'e'
            return 'unvoucher'
        when '0'
            return 'other'
        otherwise
            return 'error'
    end case
    return 'other'
end function


-- 上次使用的默认值
function cl_action_last(p_prog,p_flag,p_date)
    define  p_prog          varchar(20),
            p_flag          varchar(1),
            p_date          date
    define  l_user,l_grup   varchar(20)

    select tc_pot04,tc_pot05 into l_user,l_grup
      from tc_pot_file
     where tc_pot01 = g_user
       and tc_pot02 = p_prog
       and tc_pot03 = p_flag
       and tc_pot06 = p_date
    return l_user,l_grup
end function

-- 记录上次action的用户和grup
function cl_action_record()
    define l_tc_pot     tc_pot
    define l_cnt        integer

    initialize l_tc_pot.* to null

    let l_tc_pot.tc_pot01 = g_user
    let l_tc_pot.tc_pot02 = g_tc_pos.tc_pos03
    let l_tc_pot.tc_pot03 = g_tc_pos.tc_pos08
    let l_tc_pot.tc_pot04 = g_tc_pos.tc_pos04
    let l_tc_pot.tc_pot05 = g_tc_pos.tc_pos05
    let l_tc_pot.tc_pot06 = g_today

    select count(*) into l_cnt from tc_pot_file
     where tc_pot01 = l_tc_pot.tc_pot01
       and tc_pot02 = l_tc_pot.tc_pot02
       and tc_pot03 = l_tc_pot.tc_pot03
       and tc_pot06 = l_tc_pot.tc_pot06
    if l_cnt > 0 then
        update tc_pot_file
           set tc_pot04 = l_tc_pot.tc_pot04,tc_pot05 = l_tc_pot.tc_pot05
         where tc_pot01 = l_tc_pot.tc_pot01
           and tc_pot02 = l_tc_pot.tc_pot02
           and tc_pot03 = l_tc_pot.tc_pot03
           and tc_pot06 = l_tc_pot.tc_pot06
    else
        insert into tc_pot_file(tc_pot01,tc_pot02,tc_pot03,tc_pot04,tc_pot05,tc_pot06)
            values(l_tc_pot.tc_pot01,l_tc_pot.tc_pot02,l_tc_pot.tc_pot03,
                   l_tc_pot.tc_pot04,l_tc_pot.tc_pot05,l_tc_pot.tc_pot06)
    end if
end function


function cl_action_ui()
    call cl_set_combo_items('tc_pos08','0,1,2,3,4,5,6,7,8,9,a,b,c,d,e',
    '0.其它,1.建立,2.删除,3.修改,4.审核,5.取消审核,6.过账,7.过账还原,8.结案,9.取消结案,a.作废,b.取消作业,c.送签,d.抛转凭证,e.凭证还原')

    call cl_set_comp_entry('tc_pos06',g_date)
end function
