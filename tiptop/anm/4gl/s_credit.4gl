# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: s_credit.4gl
# Descriptions...: 贷款通用函数
# Date & Author..: darcy add 26-09-09

database ds

GLOBALS "../../config/top.global"
globals "../4gl/s_credit.global"

################## 基础函数 ##################

-- 获取合约最近一次结息日，还本日 收息 / 还本 / 利率调整
-- 如果本金中利息是0不计算利息日
-- 如果调整利率中利息是0，不计算利息日
function s_credit_get_last_date(p_contract,p_doc,p_seq)
    define  p_contract,p_doc    varchar(20),
            p_seq               integer

    define  l_interest,l_balance    date,
            l_sql                   string,
            l_dat                   date

    if cl_null(p_doc) or cl_null(p_seq) then
        -- 只查询已审核的单据
        -- 上次还息日期
        select max(nnj06) into l_dat from nni_file,nnj_file
         where nni01 = nnj01
           and nniconf = 'Y' and nnj12 > 0
           and nnj03 = p_contract
        if cl_null(l_dat) then
            let l_interest = l_dat
        end if
        let l_dat = null
        select max(nnk02) into l_dat from nnl_file,nnk_file
         where nnl01 = nnk01 and nnlconf = 'Y'
           and nnl15 > 0 and nnl04 = p_contract
        if not cl_null(l_dat) and l_dat > l_interest then
        let l_interest = l_dat
        end if

        -- 上次还本日期
        let l_dat = null
        select max(nnk02) into l_dat from nnl_file,nnk_file
         where nnl01 = nnk01 and nnlconf = 'Y'
           and nnl04 = p_contract
        if not cl_null(l_dat) then
            let l_balance = l_dat
        end if
    else
        -- 查询所有单据
        -- 只查询已审核的单据
        -- 上次还息日期
        select max(nnj06) into l_dat from nni_file,nnj_file
         where nni01 = nnj01 and nnj12 > 0
           and nnj03 = p_contract
           and ((nnj01 = p_doc and nnj02 <> p_seq) or (nnj01 <> p_doc))
        if cl_null(l_dat) then
            let l_interest = l_dat
        end if
        let l_dat = null
        select max(nnk02) into l_dat from nnl_file,nnk_file
         where nnl01 = nnk01
           and nnl15 > 0 and nnl04 = p_contract
           and ((nnl01 = p_doc and nnl02 <> p_seq) or (nnl01 <> p_doc))
        if not cl_null(l_dat) and l_dat > l_interest then
        let l_interest = l_dat
        end if

        -- 上次还本日期
        let l_dat = null
        select max(nnk02) into l_dat from nnl_file,nnk_file
         where nnl01 = nnk01 and nnl04 = p_contract
           and ((nnl01 = p_doc and nnl02 <> p_seq) or (nnl01 <> p_doc))
        if not cl_null(l_dat) then
            let l_balance = l_dat
        end if
    end if
    return l_interest,l_balance
end function

-- 获得贷款类型
function s_credit_get_contract_type()
end function

-- 计算期间利息，只考虑利息、利率、期间
function s_credit_calc_interest(p_amt,p_rate,p_start,p_end)
    define  p_amt               decimal(20,6),
            p_rate              decimal(20,6),
            p_seq               integer,
            p_start,p_end       date
    define  l_amt               decimal(20,6),
            l_day               integer,
            l_base_day          integer,
            l_rate              decimal(20,10)


    # 台湾台币用365,其它地区都是360天
    if g_aza.aza01 = 0  then
        let l_base_day = 365
    else
        let l_base_day = 360
    end if

    # 算头不算尾部
    let l_day = p_end - p_start
    let l_rate = p_amt* (p_rate / l_base_day) * l_day
    let l_amt = p_amt * l_rate

    return l_amt
end function

-- 银行资料是否可以删除
function s_credit_chk_bank_del(p_bank)
    define  p_bank      like alg_file.alg01
    define  i   integer

    -- 检查额度资料
    select count(*) into i from nno_file
     where nno01 = p_bank
    if i > 0 then
        call cl_err(p_bank,'cnm-011',1)
        return false
    end if
    -- 检查短期贷款
    select count(*) into i from nne_file
     where nne04 = p_bank and nneconf <> 'X'
     if i > 0 then
         call cl_err(p_bank,'cnm-012',1)
         return false
     end if
    -- 检查中长期期贷款
    select count(*) into i from nng_file
     where nng04 = p_back and nngconf <> 'X'
     if i > 0 then
         call cl_err(p_bank,'cnm-012',1)
         return false
     end if
     return true
end function

-- 贷款类型是否可以删除
function s_credit_chk_type_del(p_type)
    define  p_type      like nnn_file.nnn01
    define  i   integer

    select count(*) into i from nnp_file,nno_file
     where nnp03 = p_type and nno01 = nnp01
       and nnoacti = 'Y'
    if i > 0 then
        call cl_err(p_type,'cnm-011',1)
        return false
    end if

    select count(*) into i from nne_file
     where nne06 = p_type and nneconf <> 'X'
    if i > 0 then
        call cl_err(p_type,'cnm-012',1)
        return false
    end if

     select count(*) into i from nng_file
      where nng24 = p_type and nngconf <> 'X'
    if i > 0 then
        call cl_err(p_type,'cnm-012',1)
        return false
    end if

    return true
end function

-- 贷款额度是否允许删除
function s_credit_chk_limit_del(p_limit)
    define  p_limit     like nno_file.nno01
    define  i           integer

    select count(*) into i from nne_file
     where nne30 = p_limit and nneconf <> 'X'
    if i > 0 then
        call cl_err(p_limit,'cnm-012',1)
        return false
    end if

     select count(*) into i from nng_file
      where nng52 = p_limit and nngconf <> 'X'
    if i > 0 then
        call cl_err(p_limit,'cnm-012',1)
        return false
    end if

    return true
end function

################## 基础函数 ##################


################## 产生单据/异动单据 ##################
-- 更新利息，有可能是取消审核，要放在一起处理
function s_credit_upd_interest(p_doc,p_seq,p_confirm,p_tran)
    define  p_doc               varchar(20),
            p_seq               integer,
            p_confirm,p_tran    boolean
    define  l_interest          decimal(20,6),
            l_start,l_end       date,
            l_contract          contract,
            l_rate,l_last_rate  decimal(20,6),
            l_todo              dynamic array of todo,
            i                   integer

    select nnj03,nnj12,nnj05,nnj06,nnj08
      into l_contract.no,l_interest,l_start,l_end,l_rate from nni_file,nnj_file
     where nni01 = nnj01 and nniconf <> 'X'
       and nni01 = p_doc and nnj02 = p_seq
    if sqlca.sqlcode then
        call s_errmsg(
            'nni01,nnj02',
            sfmt('%1',p_doc,p_seq),
            '查询还息单据失败',
            sqlca.sqlcode,1)
        let g_success = 'N'
        return
    end if

    call s_credit_get_contract(l_contract.no) returning l_contract.*
    if g_success = 'N' then
        return
    end if

    ############ 检查 ############
    call s_credit_get_todo(l_contract.no,p_doc,p_seq,l_start) returning l_todo
    if l_todo.getLength() > 0 then
        for i = 1 to l_todo.getLength()
            call s_errmsg(
                'nni01,nnj02,nnj06',
                sfmt('%1|%2|%3',l_todo[i].doc,l_todo[i].seq,l_todo[i].dat),
                '有未审核或者之后日期的单据，需要先处理，在进行此操作',
                '!',1)
        end for
        let g_success ='N'
        return
    end if

    ############ 更新 ############
    if p_tran then
        begin work
    end if

    if p_confirm then
    # 审核
        # 更新最后还息日
        if l_contract.short then
            update nne_file set nne33 = l_end where nne01 = l_contract.no
        else
            update nng_file set nng26 = l_end where nng01 = l_contract.no
        end if
        if sqlca.sqlcode then
            call s_errmsg(
                'nne01',
                sfmt('%1',l_contract.no),
                '更新最后还息日失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
        # 更新利率
        if l_contract.interest <> l_rate then
            if l_contract.short then
                update nne_file set nne14 = l_rate where nne01 = l_contract.no
            else
                update nng_file set nng09 = l_rate where nng01 = l_contract.no
            end if
        end if
        if sqlca.sqlcode then
            call s_errmsg(
                'nne01,nne14',
                sfmt('%1|%2',l_contract.no,l_rate),
                '利率更新失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    else
    # 反审
        # 更新最后还息日
        if l_contract.short then
            update nne_file set nne33 = l_start where nne01 = l_contract.no
        else
            update nng_file set nng26 = l_start where nng01 = l_contract.no
        end if
        if sqlca.sqlcode then
            call s_errmsg(
                'nne01',
                sfmt('%1',l_contract.no),
                '更新最后还息日失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
        # 更新利率
        # 获取这个利率之前一笔的记录
        let l_last_rate = s_credit_get_last_rate(p_doc,p_seq)
        if g_success = 'N' then
            return
        end if
        if l_last_rate <> l_contract.interest then
            if l_contract.short then
                update nne_file set nne14 = l_last_rate where nne01 = l_contract.no
            else
                update nng_file set nng09 = l_last_rate where nng01 = l_contract.no
            end if
        end if
        if sqlca.sqlcode then
            call s_errmsg(
                'nne01,nne14',
                sfmt('%1|%2',l_contract.no,l_last_rate),
                '利率更新失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    end if

    label _err:
    if p_tran then
        if g_success = 'N' then
            rollback work
        else
            commit work
        end if
    end if
end function

-- 更新还款本金，取消审核放在一起处理
function s_credit_upd_balance(p_doc,p_seq,p_confirm,p_tran)
    define  p_doc    varchar(20),
            p_seq               integer,
            p_confirm,p_tran    boolean
    define  l_contract          contract,
            l_docno             varchar(20),
            l_seq               integer,
            l_balance_ori       decimal(20,6),
            l_balance_loca      decimal(20,6),
            l_interest_ori      decimal(20,6),
            l_interest_loca     decimal(20,6),
            l_start,l_end       date,
            l_nni01             like nni_file.nni01,
            l_nnj02             like nnj_file.nnj02,
            l_nnj06             like nnj_file.nnj06
    define  l_nnh02             like nnh_file.nnh02,
            l_nnh03             like nnh_file.nnh03,
            l_nnh04f            like nnh_file.nnh04f,
            l_nnhud07           like nnh_file.nnhud07,
            l_amt               like nnh_file.nnh04f,
            l_amt2              like nnh_file.nnh04f,
            l_todo              dynamic array of todo,
            i                   integer

    let g_success = 'Y'

    select nnl04,nnl12,nnl14,nnl15,nnl17,nnlud13,nnk02
      into  l_contract.no,l_balance_ori,l_balance_loca,l_interest_ori,l_interest_loca,
            l_start,l_end
      from nnl_file,nnk_file
     where nnl01 = p_doc and nnl02 = p_seq
       and nnl01 = nnk01 and nnkconf <> 'X'
    if sqlca.sqlcode then
        call s_errmsg("nnl01,nnl02",sfmt("%1|%2",p_doc,p_seq),"找不到单据资料",sqlca.sqlcode,1)
        let g_success = 'N'
        return
    end if

    call s_credit_get_contract(l_contract.no) returning l_contract.*
    if g_success = 'N' then
        return
    end if

    ############ 检查 ############
    call s_credit_get_todo(l_contract.no,p_doc,p_seq,l_start) returning l_todo
    if l_todo.getLength() > 0 then
        for i = 1 to l_todo.getLength()
            call s_errmsg(
                'nni01,nnj02,nnj06',
                sfmt('%1|%2|%3',l_todo[i].doc,l_todo[i].seq,l_todo[i].dat),
                '有未审核或者之后日期的单据，需要先处理，在进行此操作',
                '!',1)
        end for
        let g_success ='N'
        return
    end if

    -- 金额大小检查，不能超过原有的贷款金额
    if p_confirm then
        if l_balance_ori > l_contract.unrestored_amt then
            let g_success = 'N'
            call s_errmsg("nnl04,nnl12,nng20",
                sfmt("%1|%2|%3",l_contract.no,l_balance_ori,l_contract.original_amt),
                "还款本金不得大于贷款金额",'!',1)
            return
        end if
    else
        if l_balance_ori < l_contract.original_amt - l_contract.unrestored_amt then
            let g_success = 'N'
            call s_errmsg("nnl04,nnl12,nng20",
                sfmt("%1|%2|%3",l_contract.no,l_balance_ori,l_contract.original_amt),
                "取消还款后，还款金额会小于0",'!',1)
            return
        end if
    end if

    ############ 项目更新 ############
    if not p_tran then
        begin work
    end if
    case
        when p_confirm and l_contract.short
        -- 短期归还本金
            update nne_file set nne27 = nne27 + l_balance_ori ,nne20 = nne20 + l_balance_loca
             where nne01 = l_contract.no
            if sqlca.sqlcode then
                call s_errmsg("nne01",l_contract.no,'更新还本金额失败',sqlca.sqlcode,1)
                let g_success = 'N'
                goto _err
            end if
            -- 更新还息日
            if l_interest_ori <> 0 then
                update nne_file set nne33 = l_end
                 where nne01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg("nne01",l_contract.no,'更新还息日期失败',sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
            -- 结案判断
            if l_contract.unrestored_amt <= l_balance_ori then
                update nne_file set nne26 = l_end
                 where nne01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg("nne01",l_contract.no,'更新结案日期失败',sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
        when p_confirm and not l_contract.short
        -- 中长期归还本金
            -- 更新已还本金
            update nng_file set nng21 = nng21+l_balance_ori , nng23 = nng23+l_balance_loca
             where nng01 = l_contract.no
            if sqlca.sqlcode then
                call s_errmsg(
                    'nng01',
                    sfmt('%1',l_contract.no),
                    '更新还本金额失败',
                    sqlca.sqlcode,1)
                let g_success = 'N'
                goto _err
            end if
            -- 还款明细更新
            declare upd_balance_c3 cursor for
                select nnh02,nnh03,l_nnh04f,nnhud07 from nnh_file
                 where nnh01 = l_contract.no
                   and nnh04f > nvl(nnhud07,0)
                 order by nnh03
            let l_amt2 = l_balance_ori
            foreach upd_balance_c3 into l_nnh02,l_nnh03,l_nnh04f,l_nnhud07
                if sqlca.sqlcode then
                    call cl_err('upd_balance_c3',sqlca.sqlcode,1)
                    exit foreach
                end if
                if l_amt2 > 0 then
                    if l_amt2 <= l_nnh04f - l_nnhud07 then
                        let l_amt = l_amt2
                        let l_amt2 = 0
                    else
                        let l_amt = l_nnh04f - l_nnhud07
                        let l_amt2 = l_amt2 - l_amt
                    end if
                    update nnh_file set nnhud07 = nvl(nnhud07,0) + l_amt
                     where nnh01 = l_contract.no and nnh02 = l_nnh02
                    if sqlca.sqlcode then
                        let g_success = 'N'
                        call s_errmsg('nng01,nnh02,nnh03',
                            sfmt('%1|%2|%3',l_contract.no,l_nnh02,l_nnh03),
                            '更新还款计划还本金额失败',sqlca.sqlcode,1)
                        goto _err
                    end if
                else
                    exit foreach
                end if
            end foreach
            -- 更新还息日
            if l_interest_ori > 0 then
                update nng_file set nng26 = l_end where nng01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg(
                        'nng01,nng26',
                        sfmt('%1|%2',l_contract.no,l_end),
                        '更新还息日失败',
                        sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
            -- 判断结案
            if l_contract.unrestored_amt <= l_balance_ori then
                update nng_file set nngud14 = l_end where nng01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg(
                        'nng01',
                        sfmt('%1',l_contract.no),
                        '更新结案日期失败',
                        sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
        when not p_confirm and l_contract.short
        -- 短期取消归还本金
            update nne_file set nne27 = nne27 - l_balance_ori ,nne20 = nne20 - l_balance_loca
             where nne01 = l_contract.no
            if sqlca.sqlcode then
                call s_errmsg("nne01",l_contract.no,'更新还本金额失败',sqlca.sqlcode,1)
                let g_success = 'N'
                goto _err
            end if
            -- 更新还息日
            if l_interest_ori <> 0 then
                # call s_credit_get_last_date() returning l_start,l_end
                update nne_file set nne33 = l_start
                 where nne01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg("nne01",l_contract.no,'更新还息日期失败',sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
            -- 结案判断
            if l_contract.unrestored_amt = 0 then
                update nne_file set nne26 = null where nne01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg("nne01",l_contract.no,'更新结案日期失败',sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
        when not p_confirm and not l_contract.short
        -- 中长期取消归还本金
            -- 更新已还本金
            update nng_file set nng21 = nng21-l_balance_ori , nng23 = nng23-l_balance_loca
             where nng01 = l_contract.no
            if sqlca.sqlcode then
                call s_errmsg(
                    'nng01',
                    sfmt('%1',l_contract.no),
                    '更新还本金额失败',
                    sqlca.sqlcode,1)
                let g_success = 'N'
                goto _err
            end if
            -- 还款明细更新
            declare upd_balance_c4 cursor for
                select nnh02,nnh03,l_nnh04f,nnhud07 from nnh_file
                 where nnh01 = l_contract.no
                   and nvl(nnhud07,0) > 0
                 order by nnh03 desc
            let l_amt2 = l_balance_ori
            foreach upd_balance_c4 into l_nnh02,l_nnh03,l_nnh04f,l_nnhud07
                if sqlca.sqlcode then
                    call cl_err('upd_balance_c4',sqlca.sqlcode,1)
                    exit foreach
                end if
                if l_amt2 > 0 then
                    if l_amt2 <= l_nnhud07 then
                        let l_amt = l_amt2
                    else
                        let l_amt = l_nnhud07
                    end if
                    let l_amt2 = l_amt2 - l_amt
                    update nnh_file set nnhud07 = nvl(nnhud07,0) - l_amt
                     where nnh01 = l_contract.no and nnh02 = l_nnh02
                    if sqlca.sqlcode then
                        let g_success = 'N'
                        call s_errmsg('nng01,nnh02,nnh03',
                            sfmt('%1|%2|%3',l_contract.no,l_nnh02,l_nnh03),
                            '更新还款计划还本金额失败',sqlca.sqlcode,1)
                        goto _err
                    end if
                else
                    exit foreach
                end if
            end foreach
            -- 更新还息日
            if l_interest_ori <> 0 then
                update nng_file set nng26 = l_start where nng01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg(
                        'nng01,nng26',
                        sfmt('%1|%2',l_contract.no,l_end),
                        '更新还息日失败',
                        sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
            -- 判断结案
            if l_contract.unrestored_amt = 0 then
                update nng_file set nngud14 = null where nng01 = l_contract.no
                if sqlca.sqlcode then
                    call s_errmsg(
                        'nng01',
                        sfmt('%1',l_contract.no),
                        '更新结案日期失败',
                        sqlca.sqlcode,1)
                    let g_success = 'N'
                    goto _err
                end if
            end if
        otherwise
            call cl_err('未知的操作','!',1)
            let g_success = 'N'
            return
    end case

    label _err:
    if not p_tran then
        if g_success = 'N' then
            rollback work
        else
            begin work
        end if
    end if
end function

-- 创建一笔合约
--function s_credit_crt_contract(
--    p_start,            # 开始日期
--    p_end,              # 截止日期
--    p_bank,             # 贷款银行
--    p_quota_no,         # 额度编号
--    p_inter_mode,       # 付息方式
--    p_bala_inter,       # 还本还息方式
--    p_first_inter,      # 还息开始日日期
--    p_inter_day,        # 还息日
--    p_bala_mode,        # 还本方式
--    p_currency,         # 币种
--    p_inter_rate,       # 利率
--    p_exchange,         # 汇率
--    p_handing,          # 手续费率
--    p_origin,           # 原币金额
--    p_local,            # 本币金额
--    p_remark            # 备注，一个备注一部
--    )

--end function

-- 更新贷款额度
function s_credit_upd_limit()
end function

################## 产生单据/异动单据 ##################


################## 报表查询 ##################

-- 获得贷款的异动记录
-- 数据写入 Oracle 会话级临时表，函数仅返回 boolean
--create global temporary table credit_history (
--   credit_no     varchar(20),     -- 贷款号码
--   credit_date   date,            -- 贷款日期
--   bank          varchar(20),     -- 贷款银行
--   total_amt     decimal(20,6),   -- 贷款总金额原币
--   unpat_amt     decimal(20,6),   -- 剩余未还金额原币
--   cutoff_date   date,            -- 截至日期
--   docno         varchar(20),     -- 异动单据
--   seq           integer,         -- 项次
--   start_date    date,            -- 开始
--   end_date      date,            -- 结束
--   interest_rate decimal(20,6),   -- 利率
--   curreny       varchar(10),     -- 币种
--   exchange_rate decimal(20,10),  -- 汇率
--   balance_ori   decimal(20,6),   -- 本金原币
--   balance_loc   decimal(20,6),   -- 本金本币
--   interest_ori  decimal(20,6),   -- 利息原币
--   interest_loc  decimal(20,6)    -- 利息本币
----) on commit preserve rows;
--function s_credit_get_history(p_contract,p_start,p_end)
--    define  p_contract          varchar(20),
--            p_start,p_end       date
--    define  l_sql               string,
--            i,j,l               integer
--    define  sr                  history
--    define  l_contract          contract

--    let l_sql = "
--        select * from (
--        select nni01,nnj02,nnj05,nnj06,nnj08,nni04,nni09,0 amt1,0 amt2,nnj12,nnj14
--          from nni_file,nnj_file
--         where nni01 = nnj01 and nniconf = 'Y'
--           and nnj03 = '",p_contract,"'"
--    if not cl_null(p_start) then
--        let l_sql = l_sql , " and nnj06 >= '",p_start,"'"
--    end if
--    if not cl_null(p_end) then
--        let l_sql = l_sql, " and nnj06 <= '",p_end,"'"
--    end if
--    let l_sql = l_sql,"
--        union all
--        select nnk01,nnl02,nnlud13,nnk02,nnlud07,nnk04,nnk09,nnl12,nnl13,nnl15,nnl17
--          from nnk_file,nnl_file
--         where nnk01 = nnl01 and nnkconf = 'Y'
--           and nnl04 = '",p_contract,"'"
--    if not cl_null(p_start) then
--        let l_sql = l_sql , " and nnk02 >= '",p_start,"'"
--    end if
--    if not cl_null(p_end) then
--        let l_sql = l_sql, " and nnk02 <= '",p_end,"'"
--    end if
--    let l_sql = l_sql, ") order by nnj05,nnj06"
--    prepare get_history_p1 from l_sql
--    declare get_history_c1 cursor for get_history_p1

--    initialize sr.* to null
--    let l_contract = s_credit_get_contract(p_contract)
--    if g_success = 'N' then
--        return
--    end if
--    let sr.credit_no = l_contract.no
--    let sr.credit_date = l_contract.start
--    let sr.bank = l_contract.bank
--    let sr.total_amt = l_contract.original_amt
--    let sr.unpat_amt = l_contract.unrestored_amt
--    let sr.cutoff_date = l_contract.balance_end

--    foreach get_history_c1
--       into sr.docno,sr.seq,sr.start_date,sr.end_date,sr.interest_rate,sr.curreny,
--            sr.exchange_rate,sr.balance_ori,sr.balance_loc,sr.interest_ori,
--            sr.interest_loc

--        if sqlca.sqlcode then
--            call cl_err('get_history_c1',sqlca.sqlcode,1)
--            exit foreach
--        end if
--        insert into credit_history(
--            credit_no,credit_date,bank,total_amt,unpat_amt,cutoff_date,
--            docno,seq,start_date,end_date,interest_ratecurreny,
--            exchange_rate,balance_ori,balance_loc,interest_ori,interest_loc )
--         values (
--            sr.credit_no,sr.credit_date,sr.bank,sr.total_amt,sr.unpat_amt,sr.cutoff_date,
--            sr.docno,seq,sr.start_date,sr.end_date,sr.interest_ratecurreny,
--            sr.exchange_rate,sr.balance_ori,sr.balance_loc,isr.nterest_ori,sr.interest_loc)
--        if sqlca.sqlcode then
--            call s_errmsg("nne01",p_contract,"get_history_c1",sqlca.sqlcode,1)
--            let g_success = 'N'
--        end if
--    end foreach

--end function

-- 获得最近预期的记录
-- 数据写入 Oracle 会话级临时表，函数仅返回 boolean
--create global temporary table credit_ledger (
--   credit_no     varchar(20),     -- 贷款号码
--   credit_date   date,            -- 贷款日期
--   bank          varchar(20),     -- 贷款银行
--   credit_typ    varchar(100),    -- 类型
--   credit_remark varchar(1000),   -- 备注
--   curreny       varchar(10),     -- 币种
--   exchange_rate decimal(20,10),  -- 汇率
--   interest_rate decimal(20,6),   -- 利率
--   handing_rate  decimal(20,6),   -- 手续费率
--   amt_ori       decimal(20,6),   -- 原币
--   amt_loc       decimal(20,6),   -- 本币
--   pay_balance   decimal(20,6),   -- 已还本金
--   pay_interest  decimal(20,6),   -- 已还利息
--   hangding_amt  decimal(20,6),   -- 手续费
--   unpay_amt_ori decimal(20,6),   -- 未还本金原币
--   unpay_amt_loc decimal(20,6),   -- 未还本金本币
--   next_balance  date,            -- 下次还款日
--   next_amt_ori  decimal(20,6),   -- 下次还款原币
--   next_amt_loc  decimal(20,6)    -- 下次还款本币
--) on commit preserve rows;
function s_credit_get_expectation(p_day)
    define  p_day               integer
    define  sr                  ledger,
            l_sql               string,
            i                   integer,
            l_contract          contract,
            l_docno             varchar(20),
            l_amt               decimal(20,6)

    let l_sql =
    "select nne01 from nne_file
     where nneconf = 'Y' and nne12 > nne27
       and nne112 <= trunc(sysdate) + ",p_day,"
    union all
    select nng01 from nng_file
     where nngconf = 'Y' and nng20 > nng21
       and exists (select 1 from nnh_file
             where nnh01 = nng01 and nnh04f > nvl(nnhud07, 0)
               and nnh03 <= trunc(sysdate) + ",p_day,")"
    prepare get_expectation_p1 from l_sql
    declare get_expectation_c1 cursor for get_expectation_c1

    foreach get_expectation_c1 into l_docno
        if sqlca.sqlcode then
            call cl_err('get_expectation_c1',sqlca.sqlcode,1)
            exit foreach
        end if
        call s_credit_get_contract(l_docno) returning l_contract.*
        if g_success = 'N' then
            continue foreach
        end if
        initialize sr.* to null
        let sr.credit_no = l_contract.no
        let sr.credit_date = l_contract.start
        let sr.bank = l_contract.bank
        let sr.credit_typ = ""
        let sr.credit_remark = ""
        let sr.curreny = l_contract.currency
        let sr.exchange_rate = l_contract.exchange
        let sr.interest_rate = l_contract.interest_start
        let sr.handing_rate = l_contract.handing
        let sr.amt_ori = l_contract.original_amt
        let sr.amt_loc = l_contract.local_amt
        let sr.pay_balance = l_contract.original_amt - l_contract.unrestored_amt
        -- 利息合计
        let sr.pay_interest = 0
        let l_amt = 0
        select sum(nnj12) into l_amt from nni_file,nnj_file
         where nni01 = nnj01 and nniconf ='Y'
           and nnj03 = sr.credit_no
        if not cl_null(l_amt) then
            let sr.pay_interest = sr.pay_interest + l_amt
        end if
        let l_amt = 0
        select sum(nnl15) into l_amt from nnk_file,nnl_file
         where nnk01 = nnl01 and nnk01 = 'Y'
           and nnl04 = sr.credit_no
        if not cl_null(l_amt) then
            let sr.pay_interest = sr.pay_interest + l_amt
        end if
        -- 手续费
        select sum(nvl(nnl08,0)) into sr.hangding_amt from nnk_file,nnl_file
         where nnk01 = nnl01 and nnk01 = 'Y'
           and nnl04 = sr.credit_no
        if cl_null(sr.hangding_amt) then
        let sr.hangding_amt = 0
        end if
        let sr.unpay_amt_ori = l_contract.unrestored_amt
        let sr.unpay_amt_loc = l_contract.unrestored_amt*l_contract.exchange
        -- 下次还本
        if l_contract.short then
            let sr.next_balance = l_contract.balance_end
            let sr.next_amt_ori = l_contract.unrestored_amt
            let sr.next_amt_loc = l_contract.unrestored_amt*l_contract.exchange
        else
            select min(nnh03) into sr.next_balance from nnh_file
             where nnh01 = sr.credit_no and nnh04f > nvl(nnhud07,0)
            if cl_null(sr.next_balance) or sqlca.sqlcode then
                call s_errmsg("nng01",sr.credit_no,"找不到下次还本金日期",'!',1)
                let g_success = 'N'
                continue foreach
            end if
            select nnh04f-nvl(nnhud07,0) into sr.next_amt_ori from nnh_file
             where nnh01 = sr.credit_no and nnh04f > nvl(nnhud07,0)
               and nnh03 = sr.next_balance
            if cl_null(sr.next_amt_ori) or sqlca.sqlcode then
                call s_errmsg("nng01,nnh03",sfmt("%1|%2",sr.credit_no,sr.next_balance),"找不到下次还本金金额",'!',1)
                let g_success = 'N'
                continue foreach
            end if
            let sr.next_amt_loc = sr.next_amt_ori * l_contract.exchange
        end if
        insert into credit_ledger(
            credit_no,credit_date,bank,credit_typ,credit_remark,curreny,
            exchange_rate,interest_rate,handing_rate,amt_ori,amt_loc,
            pay_balance,pay_interest,hangding_amt,unpay_amt_ori,unpay_amt_loc,
            next_balance,next_amt_ori,next_amt_loc  )
        values (
            sr.credit_no,sr.credit_date,sr.bank,credit_typ,sr.credit_remark,curreny,
            sr.exchange_rate,sr.interest_rate,sr.handing_rate,sr.amt_ori,sr.amt_loc,
            sr.pay_balance,sr.pay_interest,sr.hangding_amt,sr.unpay_amt_ori,sr.unpay_amt_loc,
            sr.next_balance,sr.next_amt_ori,sr.next_amt_loc  )
        if sqlca.sqlcode then
            call s_errmsg("nne01",sr.credit_no,"ins credit_ledger",sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
        end if
    end foreach

end function

-- 取得一笔贷款的基础资料
function s_credit_get_contract(p_contract)
    define  p_contract      varchar(20),
            l_contract      contract,
            l_nne           record like nne_file.*,
            l_nng           record like nng_file.*,
            l_kind          varchar(20)

    initialize l_contract.* to null
    let l_kind = s_credit_short_or_long(p_contract)

    case l_kind
        when 'short'
            select * into l_nne.* from nne_file where nne01 = p_contract
            if sqlca.sqlcode then
                call s_errmsg("nne01",p_contract,"无法取得该单据",sqlca.sqlcode,1)
                let g_success = 'N'
                return l_contract.*
            end if
            -- 作废检查
            if l_nne.nneacti = 'X' then
                call s_errmsg("nne01,nneacti",sfmt("%1|%2",l_nne.nne01,l_nne.nneacti),"该单据已作废",'!',1)
                let g_success = 'N'
                return l_contract.*
            end if
            let l_contract.no = l_nne.nne01
            let l_contract.short = true
            let l_contract.bank = l_nne.nne04
            let l_contract.start = l_nne.nne111
            let l_contract.end = l_nne.nne112
            let l_contract.balance_start = l_nne.nne21
            let l_contract.balance_end = l_nne.nne21
            if not cl_null(l_nne.nneud13) then
                let l_contract.interest_start = l_nne.nneud13
            else
                let l_contract.interest_start = l_nne.nne111
            end if
            let l_contract.currency = l_nne.nne16
            let l_contract.exchange = l_nne.nne17
            let l_contract.interest = l_nne.nne14
            let l_contract.handing = l_nne.nneud07
            let l_contract.original_amt = l_nne.nne12
            let l_contract.local_amt = l_nne.nne19
            let l_contract.unrestored_amt = l_nne.nne12 - l_nne.nne27
            let l_contract.is_float = l_nne.nne09 == '2'
            let l_contract.interest_type = l_nne.nne08
            let l_contract.interest_day = l_nne.nne22
            let l_contract.balance_interest = l_nne.nneud02
            --let l_contract.balance_typ = l_nne.nne16 不需要
            call s_credit_get_last_date(l_contract.no,null,null)
                returning l_contract.last_interest,l_contract.last_balance
            let l_contract.dat = l_nne.nnedate
        when 'long'
            select * into l_nng.* from nng_file where nng01 = p_contract
            if sqlca.sqlcode then
                call s_errmsg("nng01",p_contract,"无法取得该单据",sqlca.sqlcode,1)
                let g_success = 'N'
                return l_contract.*
            end if
            -- 作废检查
            if l_nng.nngacti = 'X' then
                call s_errmsg("nng01,nngacti",sfmt("%1|%2",l_nng.nng01,l_nng.nngacti),"该单据已作废",'!',1)
                let g_success = 'N'
                return l_contract.*
            end if
            let l_contract.no = l_nng.nng01
            let l_contract.short = false
            let l_contract.bank = l_nng.nng04
            let l_contract.start = l_nng.nng081
            let l_contract.end = l_nng.nng082
            select min(nnh03),max(nnh03) into l_nng.nng101,l_nng.nng102
              from nnh_file where nnh01 = l_nng.nng01
            if not cl_null(l_nng.nngud13) then
                let l_contract.interest_start = l_nng.nngud13
            else
                let l_contract.interest_start = l_nng.nng081
            end if
            let l_contract.currency = l_nng.nng18
            let l_contract.exchange = l_nng.nng19
            let l_contract.interest = l_nng.nng09
            let l_contract.handing = l_nng.nngud07
            let l_contract.original_amt = l_nng.nng20
            let l_contract.local_amt = l_nng.nng22
            let l_contract.unrestored_amt = l_nng.nng20 - l_nng.nng21
            let l_contract.is_float = l_nng.nng14 == '2'
            let l_contract.interest_type = l_nng.nng16
            let l_contract.interest_day = l_nng.nng13
            let l_contract.balance_interest = l_nng.nngud02
            let l_contract.balance_typ = l_nng.nng12
            call s_credit_get_last_date(l_contract.no,null,null)
                returning l_contract.last_interest,l_contract.last_balance
            let l_contract.dat = l_nng.nngdate
        otherwise
            call s_errmsg("nne01,nmykind",sfmt("%1|%2",p_contract,p_contract[1,3]),"单别不是短期融资，也不是长期贷款",'!',1)
            let g_success = 'N'
            return l_contract.*
    end case

    return l_contract.*
end function

################## 报表查询 ##################

# 获取贷款合约是否允许录入、审核、取消审核，自动判断是还息还是还本
# 因为还本单据，可能随时会增加利息金额，所以一并当作利息单据计算
function s_credit_get_todo(p_contract,p_doc,p_seq,p_start)
    define  p_contract,p_doc    varchar(20),
            p_seq               integer,
            p_start             date
    define  l_contract          contract,
            l_kind              varchar(20),
            l_todo              dynamic array of todo,
            i                   integer

    let l_kind = s_credit_inter_or_bala(p_doc)
    if g_success = 'N' then
        return l_todo
    end if
    if l_kind == 'interest' then
        if cl_null(p_start) then
            select nnj05 into p_start from nnj_file
             where nnj01 = p_doc and nnj02 = p_seq
        end if
    else
        if cl_null(p_start) then
            select nnlud13 into p_start from nnl_file
             where nnl01 = p_doc and nnl02 = p_seq
        end if
    end if

    -- 其它未审核还息、还本单据
    -- 计息开始 大于 本次 计息开始 已审核 all单据
    declare get_todo_c1 cursor for
    select nni01,nnj02,nnj05 from nni_file,nnj_file
     where nni01 = nnj01 and nniconf = 'N'
       and nnj03 = p_contract
    union all
    select nnk01,nnl02,nnlud13 from nnk_file,nnl_file
     where nnk01 = nnl01 and nnkconf = 'N'
       and nnl04 = p_contract
    union all
    select nni01,nnj02,nnj05 from nni_file,nnj_file
     where nni01 = nnj01 and nniconf = 'Y'
       and nnj05 >= p_start and nnj03 = p_contract
    union all
    select nnk01,nnl02,nnlud13 from nnk_file,nnl_file
     where nnk01 = nnl01 and nnkconf = 'Y'
       and nnlud13 >= p_start and nnl04 = p_contract

    let i = 1
    foreach get_todo_c1 into l_todo[i].*
        if sqlca.sqlcode then
            call cl_err('get_todo_c1',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call l_todo.deleteElement(i)

    return l_todo
end function

# 取得一笔还息单据的上次的利率
function s_credit_get_last_rate(p_doc,p_seq)
    define  p_doc           varchar(20),
            p_seq           integer
    define  l_rate          decimal(20,6),
            l_creditno      varchar(20),
            l_start,l_end   date,
            l_dat           date,
            l_sql           string

    select nnj03,nnj05,nnj06 into l_creditno,l_start,l_end
      from nnj_file
     where nni01 = p_doc and nnj02 = p_seq
    if sqlca.sqlcode then
        call s_errmsg(
            'nnj01,nnj02',
            sfmt('%1|%2',p_doc,p_seq),
            '没有找这笔还息单据',
            sqlca.sqlcode,1)
        let g_success = 'N'
        return 0
    end if
    # 先找这笔单据有没有更早的日期的一个项次单据
    select max(nnj06) into l_dat from nnj_file
     where nnj01 = p_doc and nnj02 <> p_seq
       and nnj03 = l_creditno and nnj06 <= l_start
    if not sqlca.sqlcode and not cl_null(l_dat) then
        select nnj08 into l_rate from nnj_file
         where nnj01 = p_doc and nnj02 <> p_seq
           and nnj03 = l_creditno
           and nnj06 < l_dat
        if sqlca.sqlcode then
            call s_errmsg(
                'nnj01,nnj03,nnj06',
                sfmt('%1|%2|%3',p_doc,l_creditno,l_dat),
                '找不到这笔还息单据信息',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return null
        end if
        return l_rate
    end if

    # 再找其它还本，还息单据
    let l_sql = "
    select nnj08
     from (select nnj08,
               row_number() over (order by nnj06 desc) as rn
          from (select nnj06, nnj08
                  from nni_file, nnj_file
                 where nni01 = nnj01
                   and nnjconf = 'Y'
                   and nnj06 <= '",l_start,"'
                   and nnj01 <> '",p_doc,"'
                union all
                select nnk02, nnlud07
                  from nnk_file, nnl_file
                 where nnk01 = nnl01
                   and nnkconf = 'Y'
                   and nnk02 <= '",l_start,"'
                   and nnl04 <> '",p_doc,"')) where rn = 1"
    prepare get_last_rate_p1 from l_sql
    execute get_last_rate_p1 into l_rate
    if sqlca.sqlcode = 100 or cl_null(l_rate) then
        return 0
    else
        if sqlca.sqlcode then
            call s_errmsg(
                '',
                '',
                'get_last_rate_p1 执行失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return 0
        end if
    end if
    return l_rate

end function

# 判断单据是还息、还是还本
function s_credit_inter_or_bala(p_doc)
    define  p_doc       varchar(20)
    define  l_nmykind   like nmy_file.nmykind,
            l_nmyslip   varchar(3)

    let l_nmyslip = p_doc
    select nmykind into l_nmykind from nmy_file
     where nmy01 = l_nmyslip
    if sqlca.sqlcode then
        call s_errmsg("nne01",p_doc,"无法取得该单别",sqlca.sqlcode,1)
        let g_success = 'N'
        return ''
    end if
    if l_nmykind = '6' then
        return 'interest'
    end if
    if l_nmykind = '7' then
        return 'balance'
    end if
    return ''
end function

# 判断贷款是长期、短期
function s_credit_short_or_long(p_doc)
    define  p_doc       varchar(20)
    define  l_nmykind   like nmy_file.nmykind,
            l_nmyslip   varchar(3)

    let l_nmyslip = p_doc
    select nmykind into l_nmykind from nmy_file
     where nmy01 = l_nmyslip
    if sqlca.sqlcode then
        call s_errmsg("nne01",p_doc,"无法取得该单别",sqlca.sqlcode,1)
        let g_success = 'N'
        return ''
    end if
    if l_nmykind = '4' then
        return 'short'
    end if
    if l_nmykind = '5' then
        return 'long'
    end if
    return ''
end function

# [x] 获取是否有其它下游单据
# 贷款合约后续是否有还息还本单据，作废单据也不允许
function s_credit_get_sub_docs(p_doc)
    define  p_doc       varchar(20)
    define  l_doc       varchar(20),
            l_seq       integer,
            l_dat       date

    declare get_sub_docs_c1 cursor for
        select nni01,nni02,nnj02 from nni_file,nnj_file
         where nni01 = nnj01 and nnj03 = p_doc
        union all
        select nnk01,nnk02,nnl02 from nnk_file,nnl_file
         where nnk01 = nnl01 and nnl04 = p_doc
    foreach get_sub_docs_c1 into l_doc,l_dat,l_seq
        if sqlca.sqlcode then
            call cl_err('get_sub_docs_c1',sqlca.sqlcode,1)
            exit foreach
        end if
        call s_errmsg('doc,dat,seq',sfmt('%1|%2|%3',l_doc,l_dat,l_seq),
            '后续有还息/还本单据，无法进行此异动','!',1)
        let g_success = 'N'
    end foreach
end function

# [x] 获取最新的汇率
function s_credit_get_exchange(p_currency)
    define  p_currency          varchar(10)
    define  l_exchange          decimal(20,10),
            l_sql               string

    if p_currency = g_aza.aza17 then
        return 1
    end if

    let l_sql = "select azj03
                   from (select azj03, row_number() over (order by azj02 desc) as rn
                           from azj_file where azj01 = ?) where rn = 1"
    prepare get_exchange_p1 from l_sql
    execute get_exchange_p1 using p_currency into l_exchange
    if sqlca.sqlcode then
        call s_errmsg(
            'azj01',
            sfmt('%1',p_currency),
            '汇率没有维护或者不存在的币种',
            sqlca.sqlcode,1)
        let g_success = 'N'
        return 0
    end if
    return l_exchange
end function

# [x] 获取合约未还本金
function s_credit_get_unpay_bala(p_contract)
    define  p_contract      varchar(20)
    define  l_amt,l_pay     decimal(20,6),
            l_kind          varchar(10)

    # 贷款原币
    let l_kind = s_credit_short_or_long(p_contract)
    case l_kind
        when 'short'
            select nne12 into l_amt from nne_file
             where nne01 = p_contract and nneconf = 'Y'
        when 'long'
            select nng20 into l_amt from nng_file
             where nng01 = p_contract and nngconf = 'Y'
        otherwise return 0
    end case
    if l_amt < = 0 then
        return 0
    end if

    # 已还本金
    select sum(nnl12) into l_pay from nnj_file,nnl_file
     where nnl01 = nnj01 and nnjconf = 'Y'
    if cl_null(l_pay) then let l_pay = 0 end if

    return l_amt - l_pay
end function

# [x] 获得最近一次还息日
# s_credit_get_last_date 区别是，这个函数还会将本单据其它项次计算再内
# 同来带开始日期的时候用此函数
# 用来抓取正式资料的时候用 s_credit_get_last_date
function s_credit_get_last_inter_date(p_contract,p_doc,p_seq)
    define  p_contract,p_doc        varchar(20),
            p_seq                   integer
    define  l_date,l_date2          date,
            l_contract              contract,
            l_kind                  varchar(10)

    call s_credit_get_contract(p_contract) returning l_contract.*
    if g_success = 'N' then
        return null
    end if

    # 先默认为开始还款日，之后一步步增加
    let l_date = l_contract.interest_start
    if cl_null(l_date) then
        let l_date = l_contract.start
    end if

    # 抓还息/还本日期
    let l_kind = s_credit_inter_or_bala(p_doc)
    if l_kind = 'interest' then
        select max(nnj06) into l_date2 from nni_file,nnj_file
         where nni01 = nnj01 and nnj03 = p_contract
           and ( nnjconf = 'Y'
            or (nnjconf = 'N' and nnj01 = p_doc and nnj02 <> p_seq ))
    else
        select max(nnlud13) into l_date2 from nnk_file,nnl_file
         where nnk01 = nnl01 and nnl04 = p_contract
           and ( nnkconf = 'Y'
            or ( nnkconf = 'N' and nnk01 = p_doc and nnl02 <> p_seq ))
    end if
    if cl_null(l_date2) and l_date2 > l_date then
        let l_date = l_date2
    end if

    return l_date
end function

# [x] 汇总还息单头金额
function s_credit_inter_bu(p_doc)
    define  p_doc       varchar(20)

    select sum(nnj11),sum(nnj12),sum(nnj13),sum(nnj14),sum(nnj15),sum(nnj16)
      into g_nni.nni11,g_nni.nni12,g_nni.nni13,g_nni.nni14,g_nni.nni15,g_nni.nni16
      from nnj_file where nnj01 = p_doc

    update nni_file set nni11 = g_nni.nni11,nni12 = g_nni.nni12,
                        nni13 = g_nni.nni13,nni14 = g_nni.nni14,
                        nni15 = g_nni.nni15,nni16 = g_nni.nni16
     where nni01 = p_doc
    if sqlca.sqlcode then
        call s_errmsg(
            'nni01',
            sfmt('%1',p_doc),
            '更新单头汇总金额失败',
            sqlca.sqlcode,1)
        let g_success = 'N'
    end if
end function

# [x] 汇总还本单头金额
function s_credit_bala_bu(p_doc)
    define  p_doc       varchar(20)

    select sum(nnl11),sum(nnl12),sum(nnl13),sum(nnl14),sum(nnl16),sum(nnlud08)
      into g_nnk.nnk11,g_nnk.nnk12,g_nnk.nnk13,g_nnk.nnk14,g_nnk.nnk16,g_nnk.nnk17
      from nnl_fiel where nnl01 = p_doc
    if sqlca.sqlcode then
        call s_errmsg(
            'nnl01',
            sfmt('%1',p_doc),
            '更新还本单头金额失败',
            sqlca.sqlcode,1)
        let g_success = 'N'
    end if
end function
