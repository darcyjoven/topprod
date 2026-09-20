# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: s_credit_biz.4gl
# Descriptions...: 贷款通用函数之业务流程
# Date & Author..: darcy add 26-09-09

database ds

GLOBALS "../../config/top.global"
globals "../4gl/s_credit.global"


# [x] 创建一个贷款合约
function s_crd_biz_crt_contract(
    p_start,            # 开始日期          为空默认今天
    p_end,              # 截止日期          不可为空
    p_quota_no,         # 额度编号          不可为空
    p_inter_mode,       # 付息方式          1.月 2.还本还息 3.季 4.半年 5.年 6.放款还息
    p_bala_inter,       # 还本还息方式      1.还息 2.不还息 3.退息
    p_first_inter,      # 还息开始日日期    为空默认开始日期
    p_inter_day,        # 还息日            不可为空
    p_bala_mode,        # 还本方式          1.月 2.季 3.半年 4.年 5.截止日期(短期融资)
    p_currency,
    p_exchange,         # 汇率              为空取税种资料，本币为1
    p_inter_rate,       # 利率              不可为空
    p_handing,          # 手续费率          为空默认为0
    p_origin,           # 原币金额          不可为空
    p_local,            # 本币金额          为空默认汇率*原币
    p_remark,           # 备注，一个备注一部
    p_detail,           # 还款明细
    p_tran
)
    define  p_start,p_end               date,
            p_quota_no                  varchar(20),
            p_inter_mode,p_bala_inter   varchar(1),
            p_first_inter               date,
            p_inter_day                 integer,
            p_bala_mode                 varchar(1),
            p_currency                  varchar(20),
            p_exchange                  decimal(20,10),
            p_inter_rate,p_handing,
            p_origin,p_local            decimal(20,6),
            p_remark                    varchar(1000),
            p_tran                      boolean,
            p_detail                    dynamic array of record
                seq                 integer,
                dat                 date,
                origin,local        decimal(20,6)
            end record

    define  l_contract      contract,
            i,j,l           integer,
            l_sql           string,
            l_currency,l_bank       varchar(20),
            l_s,l_e         date,
            l_amt           decimal(20,6)

    if cl_null(p_start) then let p_start = g_today end if
    if cl_null(p_currency) then let p_currency = 'RMB' end if
    if cl_null(p_first_inter) then let p_first_inter = p_start end if
    if cl_null(p_handing) then let p_handing = 0 end if

    # 额度带出默认值
    select nno06,nno02,nno04,nno05
      into l_currency,l_bank,l_s,l_e
      from nno_file
     where nno01 = p_quota_no and nnoacti = 'Y'
    if sqlca.sqlcode then
        call s_errmsg(
            'nno01',
            sfmt('%1',p_quota_no),
            '额度合于不存在或已失效',
            sqlca.sqlcode,1)
        let g_success = 'N'
        goto _err
    end if
    # 检查额度有效日期
    if p_start < l_s or p_start > l_e then
        call s_errmsg(
            'nne111,nno04,nno05',
            sfmt('%1|%2|%3',p_start,l_s,l_e),
            '贷款合约已超过额度有效日期',
            sqlca.sqlcode,1)
        let g_success = 'N'
        goto _err
    end if
    # 汇率
    case
        when l_currency = 'RMB'
            let p_exchange = 1
        when l_currency <> 'RMB' and (cl_null(p_exchange) or p_exchange == 0)
            let l_sql = "select azj03 from
                            (select azj03, row_number() over (order by azj02 desc) as rn
                               from azj_file where azj01 = ?)
                         where rn = 1 "
            prepare crt_contract_p1 from l_sql
            execute crt_contract_p1 using l_currency into p_exchange
            if sqlca.sqlcode then
                call s_errmsg(
                    'azj01',
                    sfmt('%1',l_currency),
                    '币种不存在或者不存在税率资料',
                    sqlca.sqlcode,1)
                let g_success = 'N'
                goto _err
            end if
    end case
    if p_local = 0 then let p_local = p_origin * p_exchange end if

    if not p_tran then
        begin work
    end if

    if p_bala_mode = '5' then
    # 如果是还款日直接还本,就是短期融资
        let g_nne.nne01 = s_crd_biz_crt_docno('1',g_today)
        if cl_null(g_nne.nne01) then goto _err end if

        let g_nne.nne02 = p_start       # 申请日期
        let g_nne.nne03 = p_start       # 动用日期
        let g_nne.nne04 = l_bank        # 信贷银行
        let g_nne.nne06 = 'C01'         # 融资种类 默认 C01
        let g_nne.nne07 = '1'           # 担保品 默认 1.信用借款
        let g_nne.nne08 = p_inter_mode  # 付息方式
        let g_nne.nne09 = '2'           # 计息方式 默认浮动
        let g_nne.nne10 = p_remark      # 摘要
        let g_nne.nne111 = p_start      # 开始日期
        let g_nne.nne112 = p_end        # 截止日期
        let g_nne.nne12 = cl_digcut(p_origin,g_azi04)      # 原币
        let g_nne.nne13 = p_inter_rate  # 借款利率
        let g_nne.nne14 = p_inter_rate  # 还款利率
        let g_nne.nne16 = l_currency    # 币种
        let g_nne.nne17 = p_exchange # 汇率
        let g_nne.nneex2 = p_exchange # 额度汇率
        let g_nne.nne19 = cl_digcut(p_local,g_azi04)   # 贷款本币
        let g_nne.nne20 = 0         # 本币已还
        let g_nne.nne21 = p_end     # 还款日期
        let g_nne.nne22 = p_inter_day # 还息日
        let g_nne.nne23 = 0 # 承销费率
        let g_nne.nne24 = 0 # 承销费用(本币)
        let g_nne.nne25 = 0 # 承销费用(原币)
        let g_nne.nne27 = 0 # 原币已还金额
        let g_nne.nne29 = 0 # 保证费用(本币)
        let g_nne.nne30 = p_quota_no # 合约编号
        let g_nne.nne32 = 'N' # 开张
        let g_nne.nne34 = null
        let g_nne.nne36 = 0 # 签证费率
        let g_nne.nne37 = 0 # 签证费用
        let g_nne.nne41 = 'N' # 背书包装
        let g_nne.nne42 = 0 # 保证额
        let g_nne.nne43 = g_plant # 来源营运中心
        let g_nne.nne_c1 = '1001' # 贷方科目-应付商业本票
        let g_nne.nneconf = 'N'
        let g_nne.nneuser = g_user
        let g_nne.nnegrup = g_grup
        let g_nne.nnedate = g_today
        let g_nne.nne45 = 0 # 交割服务费率
        let g_nne.nne46 = 0 # 交割服务费用
        let g_nne.nne241 = 0 # 承销费用原币
        let g_nne.nne291 = 0 # 保证费用(原币)
        let g_nne.nne371 = 0 # 签证费用(原币)
        let g_nne.nne461 = 0 # 交割服务费用(原币)
        let g_nne.nnelegal = g_legal # 来源营运中心
        let g_nne.nneoriu = g_user # 建立用户
        let g_nne.nneorig = g_grup # 建立部门
        let g_nne.nneud13 = p_first_inter # 开始还息日
        let g_nne.nneud07 = 0 # 手续费率
        let g_nne.nneud02 = p_bala_inter # 还款还息方式
        insert into nne_file values (g_nne.*)
        if sqlca.sqlcode then
            call s_errmsg(
                'nne01',
                sfmt('%1',g_nne.nne01),
                '无法插入合约编号',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
        call s_credit_get_contract(g_nne.nne01) returning l_contract.*
    else
        # 检查明细与总金额是否相等
        if p_detail.getLength() == 0 then
            let p_detail[1].seq = 1
            let p_detail[1].dat = p_end
            let p_detail[1].origin = p_origin
            let p_detail[1].local = p_local
        else
            let l_amt = 0
            for i = 1 to p_detail.getLength()
                let l_amt = l_amt + p_detail[i].origin
            end for
            call s_errmsg(
                'nng20,nnh04f',
                sfmt('%1|%2',p_origin,l_amt),
                '总贷款金额与明细金额不符,无法生成贷款单据',
                '!',1)
            let g_success = 'N'
            goto _err
        end if


        let g_nng.nng01 = s_crd_biz_crt_docno('2',g_today)
        let g_nng.nng02 = p_start
        let g_nng.nng03 = p_start # 动用日期
        let g_nng.nng04 = l_bank # 银行
        let g_nng.nng05 = '1001' # 存入银行
        let g_nng.nng051 = '11' # 存提异动码
        let g_nng.nng06 = '1' # 担保品
        let g_nng.nng081 = p_start # 贷款开始日
        let g_nng.nng082 = p_end # 贷款截止日
        let g_nng.nng09 = p_inter_rate # 利率
        let g_nng.nng101 = p_start # 还款开始日
        let g_nng.nng102 = p_end # 还款截止日
        let g_nng.nng11 = p_detail.getLength() # 期数
        let g_nng.nng12 = p_bala_mode # 付款方式
        let g_nng.nng13 = p_inter_day # 付息日
        let g_nng.nng14 = '2' # 计息方式
        let g_nng.nng15 = '1' # 还款本票
        let g_nng.nng16 = p_inter_mode # 付息方式
        let g_nng.nng18 = p_exchange # 币种汇率
        let g_nng.nng19 = p_exchange # 汇率
        let g_nng.nngex2 = p_exchange # 额度汇率
        let g_nng.nng20 = cl_digcut(p_origin,g_azi04) # 原币贷款金额
        let g_nng.nng21 = 0 # 原币已还
        let g_nng.nng22 = cl_digcut(p_local,g_azi04) # 本币贷款
        let g_nng.nng23 = 0 # 本币已还
        let g_nng.nng24 = 'C01' # 长贷种类
        let g_nng.nng25 = 'N'# 开账
        let g_nng.nng26 = null # 最后还息日
        let g_nng.nng52 = p_quota_no # 合约单号
        let g_nng.nng53 = p_inter_rate  # 总借款成本
        let g_nng.nng55 = '0' # 本票折价
        let g_nng.nng57 = 0 # 保证费
        let g_nng.nng59 = 0  # 承销费
        let g_nng.nng61 = 0  # 签证费
        let g_nng.nng_d1 = '1001' # 借放科目-1
        let g_nng.nng_c1 = '1001'  # 贷方科目-1
        let g_nng.nngconf = 'N'
        let g_nng.nnguser = g_user
        let g_nng.nnggrup = g_grup
        let g_nng.nngmodu = g_user
        let g_nng.nngdate = g_today
        let g_nng.nnglegal = g_legal
        let g_nng.nngoriu = g_user
        let g_nng.nngorig = g_grup
        let g_nng.nngud13 = p_first_inter # 开始还息日
        let g_nng.nngud07 = 0 # 手续费率
        let g_nng.nngud02 = p_bala_inter # 还款还息方式
        insert into nng_file values(g_nng.*)
        if sqlca.sqlcode then
            call s_errmsg(
                'nng01',
                sfmt('%1',g_nng.nng01),
                '无法生成中长期贷款',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if

        for i = 1 to p_detail.getLength()
            let g_nnh.nnh01 = g_nng.nng01
            let g_nnh.nnh02 = p_detail[i].seq
            let g_nnh.nnh03 = p_detail[i].dat
            let g_nnh.nnh04f = p_detail[i].origin
            if p_detail[i].local = 0 or cl_null(p_detail[i].local) then
                let p_detail[i].local = p_detail[i].origin * p_exchange
            end if
            let g_nnh.nnh04 = p_detail[i].local
            let g_nnh.nnhlegal = g_legal
            insert into nnh_file values (g_nnh.*)
            if sqlca.sqlcode then
                call s_errmsg(
                    'nnh01,nnh02,nnh03',
                    sfmt('%1|%2|%3',g_nnh.nnh01,g_nnh.nnh02,g_nnh.nnh03),
                    '无法生成贷款明细，请重新确认',
                    sqlca.sqlcode,1)
                let g_success = 'N'
                goto _err
            end if
        end for
        call s_credit_get_contract(g_nng.nng01) returning l_contract.*
    end if
    if g_success = 'N' then
        call s_errmsg('nne01',sfmt('%1',l_contract.no),'获取贷款信息失败','!',1)
        goto _err
    end if

    label _err:
    if not p_tran then
        if g_success = 'N' then
            rollback work
        else
            commit work
        end if
    end if
    return l_contract.*
end function

# [x] 创建一笔放款扣息记录
function s_crd_biz_crt_dis_inter(p_contract,p_tran)
    define  p_contract      varchar(20),
            p_tran          boolean
    define  l_contract      contract,
            l_doc           varchar(20)

    call s_credit_get_contract(p_contract) returning l_contract.*
    if g_success = 'N' then
        return l_doc
    end if

    if l_contract.original_amt = 0 then
        call s_errmsg('nne12',sfmt('%1',l_contract.original_amt),
            '贷款金额为0，无法生成利息单据','!',1)
        let g_success = 'N'
        return l_doc
    end if

    if p_tran then
        begin work
    end if

    call s_crd_biz_crt_inter(
        p_contract,     # 贷款单号
        l_contract.start,        # 开始计息日
        l_contract.end,          # 结束计息日
        null,     # 汇率 为空时抓最新汇率
        l_contract.interest,         # 利率 为空时抓贷款上利率
        l_contract.original_amt,       # 原币金额 计算利息的基础金额
        null,          # 还息单号，为空时生成单头，否则只产生单身
        p_tran
    ) returning l_doc

    label _err:
    if p_tran then
        if g_success = 'Y' then
            commit work
        else
            rollback work
        end if
    end if
    return l_doc
end function
# [x] 创建一笔还息记录
function s_crd_biz_crt_inter(
    p_contract,     # 贷款单号
    p_date,          # 付款日期
    # p_start,      # 开始计息日
    p_end,          # 结束计息日
    p_exchange,     # 汇率 为空时抓最新汇率
    p_rate,         # 利率 为空时抓贷款上利率
    p_origin,       # 原币金额 计算利息的基础金额
    p_doc,          # 还息单号，为空时生成单头，否则只产生单身
    p_tran
    )
    define  p_contract      varchar(20),
            p_date          date,
            p_end   date,
            p_exchange      decimal(20,10),
            p_rate,p_origin decimal(20,6),
            p_doc           varchar(20),
            p_tran          boolean
    define  l_contract      contract,
            i,j,l           integer,
            l_amt           decimal(20,6),
            l_start         date

    call s_credit_get_contract(p_contract) returning l_contract.*
    if g_success = 'N' then
        return p_doc
    end if
    # 汇率
    if cl_null(p_exchange) or p_exchange = 0 then
        let p_exchange = s_credit_get_exchange(l_contract.currency)
        if g_success = 'N' or p_exchange = 0 then
            return p_doc
        end if
    end if
    # 利率
    if cl_null(p_rate) then
        let p_rate = l_contract.interest
    end if
    # 必须有金额才有利息
    if p_origin <= 0 then
        call s_errmsg('nnj03',sfmt('%1',l_contract.no),'贷款已还完，没有利息可产生','!',1)
        let g_success = 'N'
        return
    end if

    if not p_tran then
        begin work
    end if

    # 产生单头
    if cl_null(p_doc) then
        let p_doc = s_crd_biz_crt_docno('3',p_date)
        if g_success = 'N' or cl_null(p_doc) then
            goto _err
        end if
        let g_nni.nni01 = p_doc
        let g_nni.nni02 = p_date # 付款日期
        let g_nni.nni03 = p_end   # 截止日期
        let g_nni.nni03_y = year(p_date)
        let g_nni.nni03_m = month(p_date)
        let g_nni.nni04 = l_contract.currency # 币种
        let g_nni.nni05 = l_contract.bank # 信贷银行
        let g_nni.nni06 = '1001' # 支付银行
        let g_nni.nni07 = '2' # 银行类型
        let g_nni.nni08 = l_contract.currency # 银行币种
        let g_nni.nni09 = s_credit_get_exchange(g_nni.nni08) # 出账汇率
        let g_nni.nni10 = '10020202' #付款科目
        let g_nni.nni11 = 0 # 暂估原币
        let g_nni.nni12 = 0 # 实付原币
        let g_nni.nni13 = 0 # 暂估本币
        let g_nni.nni14 = 0 # 实付本币
        let g_nni.nni15 = 0 # 利差
        let g_nni.nni16 = 0 # 汇差
        let g_nni.nni22 = '52' # 银行出账异动码
        let g_nni.nniconf = 'N'
        let g_nni.nniinpd = g_today # 录入日期
        let g_nni.nniacti = 'Y'
        let g_nni.nniuser = g_user
        let g_nni.nnigrup = g_grup
        let g_nni.nnimodu = g_user
        let g_nni.nnidate = g_today
        let g_nni.nnilegal = g_legal
        let g_nni.nnioriu = g_user
        let g_nni.nniorig = g_grup
        insert into nni_file values (g_nni.*)
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',g_nni.nni01),
                '无法生成还息单头资料',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    end if


    # 产生单身
    let g_nnj.nnj01 = p_doc
    select max(nnj02) into i from nnj_file where nnj01 = g_nnj.nnj01
    if cl_null(i) or i = 0 then
        let i = 1
    else
        let i = i + 1
    end if
    let g_nnj.nnj02 = i
    # 还息开始日检查
    # 放在项次产生之后
    let l_start = s_credit_get_last_inter_date(p_contract,g_nnj.nnj01,g_nnj.nnj02)

    let g_nnj.nnj03 = l_contract.no
    let g_nnj.nnj04 = l_contract.interest_type # 还息方式
    let g_nnj.nnj05 = l_start # 开始日
    let g_nnj.nnj06 = p_end # 结束日
    let g_nnj.nnj07 = p_end - l_start # 利息天数
    let g_nnj.nnj08 = p_rate
    if l_contract.short then
        let g_nnj.nnj09 = '1'
    else
        let g_nnj.nnj09 = '2'
    end if
    let g_nnj.nnj11 = 0 # 暂估原币
    # 利息计算
    let g_nnj.nnj12 = s_credit_calc_interest(p_origin,g_nnj.nnj08,g_nnj.nnj05,g_nnj.nnj06)
    let g_nnj.nnj13 = 0 # 暂估本币
    let g_nnj.nnj14 = cl_digcut(g_nnj.nnj12 * p_exchange,g_azi04)
    let g_nnj.nnj15 = g_nnj.nnj14 # 利差
    let g_nnj.nnj16 = 0 # 汇差
    let g_nnj.nnjlegal = g_legal
    insert into nnj_file values (g_nnj.*)
    if sqlca.sqlcode then
        call s_errmsg(
            'nnj01,nnj02,nnj03',
            sfmt('%1|%2|%3',g_nnj.nnj01,g_nnj.nnj02,g_nnj.nnj03),
            '无法生产利息单身资料',
            sqlca.sqlcode,1)
        let g_success = 'N'
        goto _err
    end if

    # 更新单头汇总金额
    call s_credit_inter_bu(p_doc)

    label _err:
    if not p_tran then
        if g_success = 'Y' then
            commit work
        else
            rollback work
        end if
    end if
    return p_doc
end function
# [x] 创建一笔利率调整记录
# 利率调整记录单身有两笔记录
# 1. 利率调整前的利息，开始日期需要自己获取
# 2. 利率调整后的利息，此笔天数为0，没有利息，只更改利率
function s_crd_biz_crt_rate_adj(
    p_contract,     # 合约单号
    p_date,         # 税率修改日期
    p_new_rate,     # 新利率
    p_tran
    )
    define  p_contract          varchar(20),
            p_date              date,
            p_new_rate          decimal(20,6),
            p_tran              boolean
    define  l_contract          contract,
            i,j,k               integer,
            l_amt               decimal(20,6),
            l_doc               varchar(20)

    call s_credit_get_contract(p_contract) returning l_contract.*
    if g_success = 'N' then
        return
    end if
    if l_contract.interest = p_new_rate then
        call s_errmsg('nne14',sfmt('%1|%2',l_contract.interest,p_new_rate),
            '前后利率相同不需要改变','!',1)
        let g_success = 'N'
        return
    end if
    # 计算未还金额原币
    let l_amt = s_credit_get_unpay_bala(l_contract.no)
    if l_amt <= 0 then
        call s_errmsg('nne01,nne12',sfmt('%1|%2',l_contract.no,l_amt),
            '贷款金额已全部还完，不需要改变利率','!',1)
        let g_success = 'N'
        return
    end if
    # 上次还息日期
    if l_contract.last_interest > p_date then
        call s_errmsg('nne33',sfmt('%1|%2',p_date,l_contract.last_interest),
            '利率调整不能晚于最后还息日','!',1)
        let g_success = 'N'
        return
    end if

    if not p_tran then
        begin work
    end if

    # 1. 先计算调利率之前利息
    let l_doc = s_crd_biz_crt_inter(
        p_contract,     # 贷款单号
        p_date,          # 付款日期
        p_date,          # 结束计息日
        null,     # 汇率 为空时抓最新汇率
        null,         # 利率 为空时抓贷款上利率
        l_amt,       # 原币金额 计算利息的基础金额
        null,          # 还息单号，为空时生成单头，否则只产生单身
        p_tran)
    if cl_null(l_doc) or g_success = 'N' then
        call s_errmsg('nni01',sfmt('%1',l_doc),'利率调整之前期利息生成失败','!',1)
        let g_success = 'N'
        goto _err
    end if

    # 2. 再产生调利率记录
    let l_doc = s_crd_biz_crt_inter(
        p_contract,     # 贷款单号
        p_date,          # 付款日期
        p_date,          # 结束计息日
        null,     # 汇率 为空时抓最新汇率
        p_new_rate,         # 利率 为空时抓贷款上利率
        l_amt,       # 原币金额 计算利息的基础金额
        l_doc,          # 还息单号，为空时生成单头，否则只产生单身
        p_tran)
    if cl_null(l_doc) or g_success = 'N' then
        call s_errmsg('nni01',sfmt('%1',l_doc),'利率调整之调利率生成失败','!',1)
        let g_success = 'N'
        goto _err
    end if

    label _err:
    if not p_tran then
        if g_success = 'N' then
            rollback work
        else
            commit work
        end if
    end if
    return l_doc
end function
# [x] 创建一笔还本记录
function s_crd_biz_crt_bala(
    p_contract,
    p_date,
    p_exchange,
    p_origin,
    p_doc,
    p_tran
    )
    define  p_contract      varchar(20),
            p_date          date,
            p_exchange      decimal(20,10),
            p_origin        decimal(20,6),
            p_doc           varchar(20),
            p_tran          boolean
    define  l_contract          contract,
            l_last_rate,l_amt,l_interest
                                decimal(20,6),
            l_date              date

    call s_credit_get_contract(p_contract) returning l_contract.*
    if g_success = 'N' then
        return
    end if
    # 汇率
    if cl_null(p_exchange) then
        let p_exchange = s_credit_get_exchange(l_contract.currency)
        if g_success = 'N' or p_exchange = 0 then
            return p_doc
        end if
    end if
    # 检查剩余待还款
    if p_origin = 0 then
        let p_origin = l_contract.unrestored_amt
        if p_origin = 0 then
            call s_errmsg('nng01,nng20',sfmt('%1',p_doc,0),
                '贷款已还完，没有金额需要还款了','!',1)
            let g_success = 'N'
            return p_doc
        end if
    end if

    if not p_tran then
        begin work
    end if

    # 生成单头资料
    if cl_null(p_doc) then
        let p_doc = s_crd_biz_crt_docno('4',p_date)
        if g_success = 'N' or cl_null(p_doc) then
            goto _err
        end if
        let g_nnk.nnk01 = p_doc
        let g_nnk.nnk02 = p_date # 付款日期
        let g_nnk.nnk04 = l_contract.currency # 币种
        let g_nnk.nnk05 = l_contract.bank # 贷款银行
        let g_nnk.nnk06 = '1001' # 支付银行
        let g_nnk.nnk07 = '2' # 银行类型
        let g_nnk.nnk08 = l_contract.currency # 币种
        let g_nnk.nnk09 = p_exchange # 出账汇率
        let g_nnk.nnk10 = '1001' # 支付科目编号
        let g_nnk.nnk11 = 0 # 暂估原币
        let g_nnk.nnk12 = 0 # 实付原币
        let g_nnk.nnk13 = 0 # 暂估本币
        let g_nnk.nnk14 = 0 # 实付本币
        let g_nnk.nnk16 = 0 # 汇差
        let g_nnk.nnk17 = 0 # 手续费
        let g_nnk.nnk18 = '1001' # 手续费银行
        let g_nnk.nnk19 = '1001' # 现金异动码
        let g_nnk.nnk22 = '51' # 存提异动码
        let g_nnk.nnk23 = p_exchange # 换汇标准
        let g_nnk.nnkconf = 'N'
        let g_nnk.nnkinpd = g_today
        let g_nnk.nnkacti = 'Y'
        let g_nnk.nnkuser = g_user
        let g_nnk.nnkgrup = g_grup
        let g_nnk.nnkmodu = g_user
        let g_nnk.nnkdate = g_today
        let g_nnk.nnklegal = g_legal
        let g_nnk.nnkoriu = g_user
        let g_nnk.nnkorig = g_grup

        insert into nnk_file values (g_nnk.*)
        if sqlca.sqlcode then
            call s_errmsg(
                'nnk01',
                sfmt('%1',p_doc),
                '插入还本单头资料失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    end if

    # 产生单身资料
    let g_nnl.nnl01 = p_doc
    # 项次
    select max(nnl02) into g_nnl.nnl02 from nnl_file
     where nnl01 = p_doc
    if cl_null(g_nnl.nnl02) then
        let g_nnl.nnl02 = 1
    else
        let g_nnl.nnl02 = g_nnl.nnl02 + 1
    end if
    # 贷款类型
    if l_contract.short then
        let g_nnl.nnl03 = '1'
    else
        let g_nnl.nnl03 = '2'
    end if
    let g_nnl.nnl04 = l_contract.no # 合约号码
    let g_nnl.nnl11 = p_origin # 应还原币
    let g_nnl.nnl12 = p_origin # 实付原币
    let g_nnl.nnl13 = cl_digcut(p_origin * p_exchange,g_azi04) # 应还本币
    let g_nnl.nnl14 = cl_digcut(p_origin * p_exchange,g_azi04) # 实付本币
    # 利息计算
    let l_interest = 0
    let l_date = s_credit_get_last_inter_date(p_contract,g_nnl.nnl01,g_nnl.nnl02)
    # 截止日检查
    if l_date > p_date then
        call s_errmsg('nnlud13,nnk02',sfmt('%1|%2',l_date,p_date),
            '计息截至日期不能早于最后计息日期','!',1)
        let g_success = 'N'
        goto _err
    end if
    case l_contract.balance_interest
        # 还本还息
        when '1'
            # 计息金额
            let l_amt = s_credit_get_unpay_bala(l_contract.no)
            if l_amt = 0 then
                call s_errmsg('nng01,nng20',sfmt('%1',p_doc,0),
                '贷款已还完，没有金额需要计算利息','!',1)
                let g_success = 'N'
                return p_doc
            end if
            let g_nnl.nnl15 = s_credit_calc_interest(l_amt,l_contract.interest,l_date,p_date)
            let g_nnl.nnl15 = cl_digcut(g_nnl.nnl15,g_azi04)
            let g_nnl.nnlud13 = l_date # 计息开始日
        # # 还本不还利息
        # when '2'
        #     let l_interest = 0
        # 还本退息
        when '3'
            let g_nnl.nnl15 = s_credit_calc_interest(p_origin,l_contract.interest,p_date,l_contract.balance_end)
            let g_nnl.nnl15 = -1 * g_nnl.nnl15
            let g_nnl.nnl15 = cl_digcut(g_nnl.nnl15,g_azi04)
    end case
    let g_nnl.nnl16 = 0 # 汇差损失
    let g_nnl.nnl17 = cl_digcut(g_nnl.nnl15 * p_exchange,g_azi04) # 应付利息本币
    let g_nnl.nnl18 = p_exchange # 额度汇率
    let g_nnl.nnllegal = g_legal
    let g_nnl.nnlud07 = l_contract.interest # 利率
    let g_nnl.nnlud08 = cl_digcut(p_origin * l_contract.handing,g_azi04) # 手续费原币

    insert into nnl_file values(g_nnl.*)
    if sqlca.sqlcode then
        call s_errmsg(
            'nnl01,nnl2',
            sfmt('%1',g_nnl.nnl01,g_nnl.nnl02),
            '无法生成还本单据明细',
            sqlca.sqlcode,1)
        let g_success = 'N'
        goto _err
    end if

    # 更新汇总金额
    call s_credit_inter_bu(p_doc)

    label _err:
    if not p_tran then
        if g_success = 'Y' then
            commit work
        else
            rollback work
        end if
    end if
    return p_doc
end function
# [ ] 更新贷款额度
# [ ] 新增贷款额度

# [x] 批量生成还息记录
# 生成p_end截至日期之前的所有还息记录
function s_crd_gen_inter(p_end)
    define  p_end           date
    define  l_sql           string,
            l_start,l_end   varchar(20),
            i,j,k           integer,
            l_doc           dynamic array of  varchar(20),
            l_interno       varchar(20),
            l_contract      contract

    declare gen_inter_c1 cursor for
    select nng01, nng20 - nng21 unpay
      from nng_file
     where nngconf = 'Y'
       and (nng26 < p_end or nng25 is null)
       and nng20 > nng21
    union all
    select nne01, nne12 - nne27
      from nne_file
     where nneconf = 'Y'
       and (nne33 is null or nne33 < p_end)
       and nne12 > nne27

    call l_doc.clear()
    let i = 1
    foreach gen_inter_c1 into l_doc[i]
        if sqlca.sqlcode then
            call cl_err('gen_inter_c1',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call l_doc.deleteElement(i)

    begin work

    for i = 1 to l_doc.getLength()
        call s_credit_get_contract(l_doc[i]) returning l_contract.*
        if g_success = 'N' then
            goto _err
        end if
        # 创建
        let l_interno = s_crd_biz_crt_inter(
                        l_contract.no,     # 贷款单号
                        p_end,          # 付款日期
                        p_end,          # 结束计息日
                        l_contract.exchange,     # 汇率 为空时抓最新汇率
                        l_contract.interest,         # 利率 为空时抓贷款上利率
                        l_contract.unrestored_amt,       # 原币金额 计算利息的基础金额
                        null,          # 还息单号，为空时生成单头，否则只产生单身
                        true
                        )
        if cl_null(l_interno) or g_success = 'N' then
            goto _err
        end if
        if i = 1 then
            let l_start = l_interno
        end if
        # 检查
        call s_crd_biz_pay_chk(l_contract.no)
        if g_success = 'N' then
            goto _err
        end if
        # 审核
        call s_crd_biz_pay_conf(l_contract.no,true)
        if g_success = 'N' then
            goto _err
        end if
    end for
    let l_end = l_interno

    label _err:
    if g_success = 'N' then
        rollback work
    else
        commit work
    end if
    return l_start,l_end
end function

# [x] 审核贷款合约
function s_crd_biz_cont_chk(p_doc)
    define  p_doc       varchar(20)
    define  l_kind      varchar(10)
    define  amty,amtu,u_amty,
            u_amtu,bal,l_npp07
                        decimal(20,6),
            l_nnp07     like nnp_file.nnp07

    let l_kind = s_credit_short_or_long(p_doc)
    if l_kind = 'short' then
        select * into g_nne.* from nne_file where nne01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nne01',
                sfmt('%1',p_doc),
                '找不到贷款单号',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        if g_nne.nneconf = 'X' then
            call s_errmsg( 'nne01,nneconf', sfmt('%1|%2',p_doc,g_nne.nneconf), '单据已作废，不可审核', '9024',1)
            let g_success = 'N'
            return
        end if
        if g_nne.nneconf = 'Y'  then
            call s_errmsg( 'nne01,nneconf', sfmt('%1|%2',p_doc,g_nne.nneconf), '已审核单据，不能重复审核', '!',1)
            let g_success = 'N'
            return
        end if
        # 金额不能为0
        if g_nne.nne12 = 0 then
            call s_errmsg('nne12',sfmt('%1',g_nne.nne12),'','agl-252',1)
            let g_success = 'N'
            return
        end if
        # 本币检查
        if g_nne.nne19 <> cl_digcut(g_nne.nne12 * g_nne.nne17,g_azi04) then
            call s_errmsg('nne19,nne12,nne17',sfmt('%1|%2|%3',g_nne.nne19,g_nne.nne12,g_nne.nne17),'','aap-938',1)
            let g_success = 'N'
            return
        end if
        call s_credit2('N',g_nne.nne04,g_nne.nne30,g_nne.nne06)
            returning amty,amtu,u_amty,u_amtu,bal
        select nnp07 into l_nnp07 from nnp_file
         where nnp01 = g_nne.nne30 and nnp03 = g_nne.nne06
        if cl_null(l_nnp07) then let l_nnp07 = g_aza.aza17 end if
        if l_nnp07 = g_nne.nne16 then
            let bal=bal-(g_nne.nne12*g_nne.nneex2)
        else
            let bal= bal-(g_nne.nne12*g_nne.nne17)
        end if
        if bal<0 then
            call s_errmsg('nnp08,nne12',sfmt('%1|%2',bal,g_nne.nne12),'已超过贷款额度','anm-287',1)
            let g_success = 'N'
            return
        end if
    else
        select * into g_nng.* from nng_file where nng01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nng01',
                sfmt('%1',p_doc),
                '找不到贷款单号',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        if g_nng.nngconf = 'X' then
            call s_errmsg( 'nng01,nngconf', sfmt('%1|%2',p_doc,g_nng.nngconf), '单据已作废，不可审核', '9024',1)
            let g_success = 'N'
            return
        end if
        if g_nng.nngconf = 'Y'  then
            call s_errmsg( 'nng01,nngconf', sfmt('%1|%2',p_doc,g_nng.nngconf), '已审核单据，不能重复审核', '!',1)
            let g_success = 'N'
            return
        end if
        # 金额不能为0
        if g_nng.nng20 = 0 then
            call s_errmsg('nng20',sfmt('%1',g_nng.nng20),'','agl-252',1)
            let g_success = 'N'
            return
        end if
        # 本币检查
        if g_nng.nng22 <> cl_digcut(g_nng.nng22 * g_nng.nng19,g_azi04) then
            call s_errmsg('nng20,nng19,nng22',sfmt('%1|%2|%3',g_nng.nng20,g_nng.nng19,g_nng.nng22),'','aap-938',1)
            let g_success = 'N'
            return
        end if
        call s_credit2('N',g_nng.nng04,g_nng.nng52,g_nng.nng24)
            returning amty,amtu,u_amty,u_amtu,bal
        select nnp07 into l_nnp07 from nnp_file
         where nnp01 = g_nng.nng52 and nnp03 = g_nng.nng24

        if cl_null(l_nnp07) then let l_nnp07 = g_aza.aza17 end if
        if l_nnp07 = g_nne.nne16 then
            let bal=bal-(g_nng.nng20*g_nng.nngex2)
        else
            let bal= bal-(g_nng.nngex2*g_nng.nng19)
        end if
        if bal<0 then
            call s_errmsg('nnp08,nng20',sfmt('%1|%2',bal,g_nng.nng20),'已超过贷款额度','anm-287',1)
            let g_success = 'N'
            return
        end if
    end if

end function
# [x] 审核贷款单据
function s_crd_biz_cont_conf(p_doc,p_tran)
    define  p_doc       varchar(20),
            p_tran      boolean
    define  l_kind      varchar(10),
            l_doc       varchar(20),
            l_contract  contract

    call s_credit_get_contract(p_doc) returning l_contract.*
    if g_success = 'N' then
        call s_errmsg('nne01',sfmt('%1',p_doc),'获取贷款信息失败','!',1)
        let g_success = 'N'
        return
    end if

    if not p_tran then
        begin work
    end if

    # 生成一笔立即还息记录
    if l_contract.interest_type == '6' then
        let l_doc = s_crd_biz_crt_dis_inter(l_contract.no,p_tran)
        if g_success = 'N' then
            call s_errmsg('nne01',sfmt('%1',p_doc),'生成还款扣息记录失败','!',1)
            goto _err
        end if
        call s_crd_biz_pay_chk(l_doc)
        if g_success = 'N' then
            goto _err
        end if
        call s_crd_biz_pay_conf(p_doc,p_tran)
        if g_success = 'N' then
            goto _err
        end if
    end if

    if l_contract.short then
        update nne_file set nneconf = 'Y' where nne01 = p_doc
    else
        update nng_file set nngconf = 'Y' where nng01 = p_doc
    end if

    if sqlca.sqlcode then
        call s_errmsg(
            'nne01',
            sfmt('%1',p_doc),
            '审核失败',
            sqlca.sqlcode,1)
        let g_success = 'N'
    end if

    label _err:
    if not p_tran then
        if g_success = 'N' then
            rollback work
        else
            commit work
        end if
    end if
end function
# [x] 贷款取消审核检查
function s_crd_biz_cont_unchk(p_doc)
    define  p_doc       varchar(20)
    define  l_kind      varchar(10)

    let l_kind = s_credit_short_or_long(p_doc)
    if l_kind = 'short' then
        select * into g_nne.* from nne_file where nne01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nne01',
                sfmt('%1',p_doc),
                '找不到贷款单号',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        if g_nne.nneconf <> 'Y' then
            call s_errmsg('nne01,nneconf',sfmt('%1|%2',p_doc,g_nne.nneconf),'不是审核状态','!',1)
            let g_success = 'N'
            return
        end if
    else
        select * into g_nng.* from nng_file where nng01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nng01',
                sfmt('%1',p_doc),
                '找不到贷款单号',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        if g_nng.nngconf <> 'Y' then
            call s_errmsg('nng01,nngconf',sfmt('%1|%2',p_doc,g_nng.nngconf),'不是审核状态','!',1)
            let g_success = 'N'
            return
        end if
    end if
    call s_credit_get_sub_docs(p_doc)
end function
# [x] 贷款取消审核
function s_crd_biz_cont_unconf(p_doc)
    define  p_doc       varchar(20)
    define  l_kind      varchar(10)

    let l_kind = s_credit_short_or_long(p_doc)
    if l_kind = 'short' then
        update nne_file set nneconf = 'N' where nne01 = p_doc
    else
        update nng_file set nngconf = 'N' where nng01 = p_doc
    end if
    if sqlca.sqlcode then
        call s_errmsg(
            'nne01',
            sfmt('%1',p_doc),
            '取消审核审核失败',
            sqlca.sqlcode,1)
        let g_success = 'N'
    end if
end function

# [x] 审核还款单据
function s_crd_biz_pay_chk(p_doc)
    define  p_doc       varchar(20)
    define  l_kind      varchar(10)
    define  l_todo      dynamic array of todo
    define  i,j,k       integer

    let l_kind = s_credit_inter_or_bala(p_doc)
    if l_kind = 'interest' then
        # 还息
        select * into g_nni.* from nni_file where nni01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',p_doc),
                '找不到还息单据',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        if g_nni.nniacti != 'Y' or g_nni.nniconf = 'N' then
            call s_errmsg('nni01,nniacti,nniconf',sfmt('%1|%2|%3',p_doc,g_nni.nniacti,g_nni.nniconf),
                '必须未审核且有效的单据才可审核','!',1)
            let g_success = 'N'
            return
        end if
        select count(*) into i from nnj_file where nnj01 = p_doc
        if i = 0 then
            call s_errmsg('nnj01',sfmt('%1',p_doc),'单身没有录入资料','!',1)
            let g_success = 'N'
            return
        end if
        # 是否有未审核其它单据，或者日期在之后的审核单据
        declare pay_chk_c1 cursor for
            select * from nnj_file where nnj01 = p_doc
        foreach pay_chk_c1 into g_nnj.*
            if sqlca.sqlcode then
                call cl_err('pay_chk_c1',sqlca.sqlcode,1)
                exit foreach
            end if
            let l_todo = s_credit_get_todo(g_nnj.nnj03,p_doc,g_nnj.nnj02,g_nnj.nnj05)
            if l_todo.getLength() > 0 then
                for i  = 1 to l_todo.getLength()
                    call s_errmsg('doc,seq,dat',sfmt('%1|%2|%3',l_todo[i].doc,l_todo[i].seq,l_todo[i].dat),
                        '有未审核或者之后日期异动的单据，请先确认','!',1)
                end for
                let g_success = 'N'
            end if
        end foreach
        if g_success = 'N' then
            return
        end if
    else
        # 还本
        select * into g_nnk.* from nnk_file where nnk01 =  p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nnk01',
                sfmt('%1',p_doc),
                '找不到还本单据',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        if g_nnk.nnkacti != 'Y' or g_nnk.nnkconf = 'N' then
            call s_errmsg('nnk01,nnkacti,nnkconf',sfmt('%1|%2|%3',p_doc,g_nnk.nnkacti,g_nnk.nnkconf),
                '必须未审核且有效的单据才可审核','!',1)
            let g_success = 'N'
            return
        end if
        select count(*) into i from nnl_file where nnl01 = p_doc
        if i = 0 then
            call s_errmsg('nnl01',sfmt('%1',p_doc),'单身没有录入资料','!',1)
            let g_success = 'N'
            return
        end if
        # 是否有未审核其它单据，或者日期在之后的审核单据
        declare pay_chk_c2 cursor for
            select * from nnl_file where nnl01 = p_doc
        foreach pay_chk_c2 into g_nnl.*
            if sqlca.sqlcode then
                call cl_err('pay_chk_c2',sqlca.sqlcode,1)
                exit foreach
            end if
            let l_todo = s_credit_get_todo(g_nnl.nnl03,p_doc,g_nnl.nnl02,g_nnl.nnlud13)
            if l_todo.getLength() > 0 then
                for i  = 1 to l_todo.getLength()
                    call s_errmsg('doc,seq,dat',sfmt('%1|%2|%3',l_todo[i].doc,l_todo[i].seq,l_todo[i].dat),
                        '有未审核或者之后日期异动的单据，请先确认','!',1)
                end for
                let g_success = 'N'
            end if
        end foreach
        if g_success = 'N' then
            return
        end if
    end if

end function
function s_crd_biz_pay_conf(p_doc,p_tran)
    define  p_doc       varchar(20),
            p_tran      boolean
    define  l_kind      varchar(10),
            l_sql       string

    if not p_tran then
        begin work
    end if

    let l_kind = s_credit_inter_or_bala(p_doc)
    if l_kind = 'interest' then
        declare pay_conf_c1 cursor for
            select * from nni_file where nni01 = p_doc for update
        open pay_conf_c1
        if status then
            call s_errmsg('nni01',sfmt('%1',p_doc),'open pay_conf_c1',status,1)
            let g_success = 'N'
            goto _err
        end if
        fetch pay_conf_c1 into g_nni.*
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',g_nni.nni01),
                '查询不到还息资料',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
        declare pay_conf_c2 cursor for
            select * from nnj_file where nnj01 = p_doc
        foreach pay_conf_c2 into g_nnj.*
            if sqlca.sqlcode then
                call cl_err('pay_conf_c2',sqlca.sqlcode,1)
                exit foreach
            end if
            call s_credit_upd_interest(g_nnj.nnj01,g_nnj.nnj02,true,p_tran)
            if g_success = 'N' then
                goto _err
            end if
        end foreach
        update nni_file set nniconf = 'Y' where nni01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',p_doc),
                '审核更新失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    else
        declare pay_conf_c3 cursor for
            select * from nnk_file where nnk01 = p_doc for update
        open pay_conf_c3
        if status then
            call s_errmsg('nni01',sfmt('%1',p_doc),'open pay_conf_c3',status,1)
            let g_success = 'N'
            goto _err
        end if
        fetch pay_conf_c3 into g_nnk.*
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',g_nnk.nnk01),
                '查询不到还本资料',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
        declare pay_conf_c4 cursor for
            select * from nnl_file where nnl01 = p_doc
        foreach pay_conf_c4 into g_nnl.*
            if sqlca.sqlcode then
                call cl_err('pay_conf_c4',sqlca.sqlcode,1)
                exit foreach
            end if
            call s_credit_upd_interest(g_nnl.nnl01,g_nnl.nnl02,true,p_tran)
            if g_success = 'N' then
                goto _err
            end if
        end foreach
        update nnk_file set nnkconf = 'Y' where nnk01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nnk01',
                sfmt('%1',p_doc),
                '审核更新失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    end if

    label _err:
    if not p_tran then
        if g_success = 'N' then
            rollback work
        else
            commit work
        end if
    end if
end function

# [x] 取消审核还款单据
function s_crd_biz_pay_unchk(p_doc)
    define  p_doc       varchar(20)
    define  l_kind      varchar(10),
            l_sql       string,
            l_todo      dynamic array of todo,
            i,j         integer

    let l_kind = s_credit_inter_or_bala(p_doc)
    if l_kind = 'interest' then
        # 还息
        select * into g_nni.* from nni_file where nni01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',p_doc),
                '找不到还息单据',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        # 1. 当前单据状态
        if g_nni.nniacti != 'Y' or g_nni.nniconf = 'Y' then
            call s_errmsg('nni01,nniacti,nniconf',sfmt('%1|%2|%3',p_doc,g_nni.nniacti,g_nni.nniconf),
                '必须审核且有效的单据才可取消审核','!',1)
            let g_success = 'N'
            return
        end if
        # 2. 未审核单据或者之后日期的审核单据
        declare pay_unchk_c1 cursor for
            select * from nnj_file where nnj01 = p_doc
        foreach pay_unchk_c1 into g_nnj.*
            if sqlca.sqlcode then
                call cl_err('pay_unchk_c1',sqlca.sqlcode,1)
                exit foreach
            end if
            let l_todo = s_credit_get_todo(g_nnj.nnj03,p_doc,g_nnj.nnj02,g_nnj.nnj05)
            for i = 1 to l_todo.getLength()
                call s_errmsg('doc,seq,dat',sfmt('%1|%2|%3',l_todo[i].doc,l_todo[i].seq,l_todo[i].dat),
                    '有未审核单据，或者之后日期已有审核单据，请先取消这些单据','!',1)
                let g_success = 'N'
            end for
        end foreach
        if g_success = 'N' then
            return
        end if
    else
        # 还款本金不得大于贷款金额
        select * into g_nnk.* from nnk_file where nnk01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',p_doc),
                '找不到还息单据',
                sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        # 1. 当前单据状态
        if g_nnk.nnkacti != 'Y' or g_nnk.nnkconf = 'Y' then
            call s_errmsg('nni01,nniacti,nnkconf',sfmt('%1|%2|%3',p_doc,g_nnk.nnkacti,g_nnk.nnkconf),
                '必须审核且有效的单据才可取消审核','!',1)
            let g_success = 'N'
            return
        end if
        # 2. 未审核单据或者之后日期的审核单据
        declare pay_unchk_c2 cursor for
            select * from nnl_file where nnl01 = p_doc
        foreach pay_unchk_c2 into g_nnl.*
            if sqlca.sqlcode then
                call cl_err('pay_unchk_c2',sqlca.sqlcode,1)
                exit foreach
            end if
            let l_todo = s_credit_get_todo(g_nnl.nnl03,p_doc,g_nnl.nnl02,g_nnl.nnlud13)
            for i = 1 to l_todo.getLength()
                call s_errmsg('doc,seq,dat',sfmt('%1|%2|%3',l_todo[i].doc,l_todo[i].seq,l_todo[i].dat),
                    '有未审核单据，或者之后日期已有审核单据，请先取消这些单据','!',1)
                let g_success = 'N'
            end for
        end foreach
        if g_success = 'N' then
            return
        end if
    end if

end function
function s_crd_biz_pay_unconf(p_doc,p_tran)
    define  p_doc       varchar(20),
            p_tran      boolean
    define  l_kind      varchar(10),
            l_sql       string

    if not p_tran then
        begin work
    end if

    let l_kind = s_credit_inter_or_bala(p_doc)
    if l_kind = 'interest' then
        declare pay_unconf_c1 cursor for
            select * from nni_file where nni01 = p_doc for update
        open pay_unconf_c1
        if status then
            call s_errmsg('nni01',sfmt('%1',p_doc),'open pay_unconf_c1',status,1)
            let g_success = 'N'
            goto _err
        end if
        fetch pay_unconf_c1 into g_nni.*
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',g_nni.nni01),
                '查询不到还息资料',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
        declare pay_unconf_c2 cursor for
            select * from nnj_file where nnj01 = p_doc
        foreach pay_unconf_c2 into g_nnj.*
            if sqlca.sqlcode then
                call cl_err('pay_unconf_c2',sqlca.sqlcode,1)
                exit foreach
            end if
            call s_credit_upd_interest(g_nnj.nnj01,g_nnj.nnj02,true,p_tran)
            if g_success = 'N' then
                goto _err
            end if
        end foreach
        update nni_file set nniconf = 'N' where nni01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',p_doc),
                '审核更新失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    else
        declare pay_unconf_c3 cursor for
            select * from nnk_file where nnk01 = p_doc for update
        open pay_unconf_c3
        if status then
            call s_errmsg('nni01',sfmt('%1',p_doc),'open pay_unconf_c3',status,1)
            let g_success = 'N'
            goto _err
        end if
        fetch pay_unconf_c3 into g_nnk.*
        if sqlca.sqlcode then
            call s_errmsg(
                'nni01',
                sfmt('%1',g_nnk.nnk01),
                '查询不到还本资料',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
        declare pay_unconf_c4 cursor for
            select * from nnl_file where nnl01 = p_doc
        foreach pay_unconf_c4 into g_nnl.*
            if sqlca.sqlcode then
                call cl_err('pay_unconf_c4',sqlca.sqlcode,1)
                exit foreach
            end if
            call s_credit_upd_interest(g_nnl.nnl01,g_nnl.nnl02,true,p_tran)
            if g_success = 'N' then
                goto _err
            end if
        end foreach
        update nnk_file set nnkconf = 'N' where nnk01 = p_doc
        if sqlca.sqlcode then
            call s_errmsg(
                'nnk01',
                sfmt('%1',p_doc),
                '审核更新失败',
                sqlca.sqlcode,1)
            let g_success = 'N'
            goto _err
        end if
    end if

    label _err:
    if not p_tran then
        if g_success = 'N' then
            rollback work
        else
            commit work
        end if
    end if
end function


# [ ] 还款记录导出
function s_crd_biz_pay_history(p_start,p_end,p_bank,p_doc)
    define  p_start,p_end           date,
            p_bank,p_doc            varchar(20)
    define  l_sql                   string,
            i                       integer

    let l_sql = "select case nne01 when 'D01' then '中长期' else '短期融资' end typ,
                        nne01,nne04,alg02,nne111,nne112,
                        nne14,nne16,nne12,nne19, nne27, nne20,
                        typ,nnj01,nnj02,nnj05,nnj06,nni09,nnj08,
                        bent,ben ,nnj12,nnj14
                   from anmt_contract con
                   left join anmt_pay_history pay on nnj03 = nne01
                  where 1=1 "
    if not cl_null(p_start) then
        let l_sql = l_sql , " and nnj06 >= '",p_start,"' "
    end if
    if not cl_null(p_end) then
        let l_sql = l_sql , " and nnj06 <= '",p_end,"' "
    end if
    if not cl_null(p_bank) then
        let l_sql = l_sql , " and nne04 = '",p_bank,"'"
    end if
    if not cl_null(p_doc) then
        let l_sql = l_sql , " and nne01 = '",p_doc,"'"
    end if
    let l_sql = l_sql, " order by nne111, nnj06"
    prepare pay_history_p1 from l_sql
    declare pay_history_c1 cursor for pay_history_p1

    let i = 1
    call g_history.clear()
    foreach pay_history_c1 into g_history[i].*
        if sqlca.sqlcode then
            call cl_err('pay_history_c1',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_history.deleteElement(i)

end function

# [ ] 待还本单据明细
# p_days 天数内到期的本金，贷款明细
function s_crd_biz_to_bala(p_days,p_bank)
    define  p_days          integer,
            p_bank          varchar(20)
    define  l_sql           string,
            i               integer

    let l_sql = "select * from (
                    select 'Y' chk,'短期融资' typ,nne04,alg02,nne01,
                            nne111,nne112,nne14,nne16,nne17,nne12,
                            nne19,nne27,nne20,1 nnh03,
                            nne12 - nne27 nnh04f,nne19 - nne20 nnh04
                      from nne_file, alg_file
                     where nneconf = 'Y' and alg01 = nne04 and nne12 > nne27
                    union all
                    select 'Y','中长期',nng04,alg02,nng01,
                            nng101,nnh03,nng09,nng18,nng19,nnh04f,
                            nnh04,nvl(nnhud07, 0),round(nvl(nnhud07, 0) * nng19, 2),
                            nnh02,nnh04f - nvl(nnhud07, 0),nnh04 - round(nvl(nnhud07, 0) * nng19, 2)
                      from nng_file, alg_file, nnh_file
                     where nngconf = 'Y'
                       and nng01 = nnh01
                       and alg01 = nng04
                       and nnh04f > nvl(nnhud07, 0) )
                    where nne112 < trunc(sysdate) + ",p_days
    if not cl_null(p_bank) then
        let l_sql = l_sql , " and nne01 = '",p_bank,"' "
    end if
    let l_sql = l_sql," order by nne112,nne04,nne01,nne111"
    prepare to_bala_p1 from l_sql
    declare to_bala_c1 cursor for to_bala_p1

    let i = 1
    call g_topay.clear()
    foreach to_bala_c1 into g_topay[i].*
        if sqlca.sqlcode then
            call cl_err('to_bala_c1',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_topay.deleteElement(i)
end function

# [ ] 额度使用导出


# [x] 获得一个单号
# 1. 短期融资
# 2. 中长期贷款
# 3. 还息
# 4. 还本
function s_crd_biz_crt_docno(p_type,p_date)
    define  p_type      varchar(1),
            p_date      date,
            p_tran      boolean
    define  l_slip      varchar(10),
            l_ok        integer,
            l_docno     varchar(20)

    # 单别类型
    case p_type
        when '1'
            call s_auto_assign_no("anm",'D02',p_date,"4","nne_file","nne01","","","")
                returning l_ok,l_docno
        when '2'
            call s_auto_assign_no("anm",'D01',p_date,"5","nng_file","nng01","","","")
                returning l_ok,l_docno
        when '3'
            call s_auto_assign_no("anm",'PI1',p_date,"6","nni_file","nni01","","","")
                returning l_ok,l_docno
        when '4'
            call s_auto_assign_no("anm",'PP1',p_date,"7","nnk_file","nnk01","","","")
                returning l_ok,l_docno
        otherwise
            call s_errmsg(
                'nmyslip|nme02',
                sfmt('%1|%2',p_type,p_date),
                '不合法的单别',
                '!',1)
            let l_ok = false
    end case
    if not l_ok then
        return ''
    end if
    return l_docno
end function


# [ ] 待还息数据获取
function s_crd_biz_to_inter(p_days,p_bank,p_doc)
    define  p_days          integer,
            p_bank,p_doc    varchar(20)
    define  l_sql           string,
            i,j,k,yy,mm,dd  integer,
            l_contract      contract,
            l_start,l_end,l_date        date

    # 还息方式 nne08,nng16            1.月2.本3.季4.半年5.年6.放扣
    # 还息开始日 nneud13,nngud13
    # 贷款开始日 nne111,nng081,
    # 还息日 nne22,nng13
    # 未还金额 nne12-nn27,nng20-nng21
    # 币种  nne16,nng18
    # 银行  nne04,nng04
    # 最后还息日 nne33,nng26

    #        l_contract.no,l_contract.interest_type,l_contract.interest_start,
    #        l_contract.start,l_contract.interest_day,4
    #        l_contract.unrestored_amt,l_contract.currency,bank,
    #        l_contract.last_interest
    let l_sql = "select  nne01,nne08,nneud13,nne111,nne22,
                         nne12-nne17,nne16,nne04,nne33
                 from nne_file
                  where nneconf = 'Y' and nne12 > nne27
                    and nne08 in ('1','3','4','5')
                 union all
                 select  nng01,nng16,nngud13,nng081,nng13,
                         nng20-nng21,nng18,nng04,nng26
                    from nng_file
                   where nngconf = 'Y' and nng20 > nng21
                     and nng16 in ('1','3','4','5')"
    let l_sql = "select * from (",l_sql,") where 1=1 "
    let l_sql = l_sql , " and (nne33 is null or nne33 < trunc(sysdate) + ",p_days,")",
                        " and (nneud13 is null or nneud13 < trunc(sysdate) + ",p_days,")"
    if not cl_null(p_bank) then
        let l_sql = l_sql , " and nne04 = '",p_bank,"'"
    end if
    if not cl_null(p_doc) then
        let l_sql = l_sql , " and nne01 = '",p_doc,"'"
    end if
    prepare to_inter_p1 from l_sql
    declare to_inter_c1 cursor for to_inter_p1

    let i = 1
    call g_tointer.clear()
    foreach to_inter_c1
       into l_contract.no,l_contract.interest_type,l_contract.interest_start,
            l_contract.start,l_contract.interest_day,
            l_contract.unrestored_amt,l_contract.currency,l_contract.bank,
            l_contract.last_interest
        if sqlca.sqlcode then
            call cl_err('to_inter_c1',sqlca.sqlcode,1)
            exit foreach
        end if
        if cl_null(l_contract.interest_start) then
            let l_contract.interest_start = l_contract.start
        end if
        if cl_null(l_contract.last_interest) then
            let l_contract.last_interest = l_contract.start
        end if
        # 计息开始日
        let l_start = l_contract.last_interest
        # 计息方式计算下次计息日期
        let yy = year(l_contract.last_interest)
        let mm = month(l_contract.last_interest)
        let dd = day(l_contract.last_interest)
        case l_contract.interest_type
            when '1' # 月
                if dd >= l_contract.interest_day then
                    if mm = 12 then
                        let yy = yy + 1
                        let mm = 1
                    else
                        let mm = mm + 1
                    end if
                end if
                let l_end = mdy(mm,l_contract.interest_day,yy)
            when '3' # 季度 3 6 9 12
                if mm mod 3 == 0 then
                # 是还息月份，判断还息日期
                    let j = mm / 3
                    let j = j * 3 + 3
                    if dd >= l_contract.interest_day then
                    # 还息日在应还日之后，要增加月份
                        if j + 3 > 12 then
                            let yy = yy + 1
                            let j = j + 3 - 12
                        else
                            let j = j + 3
                        end if
                    end if
                else
                # 不是还息月份，切换到还息月份
                    let j = mm / 3
                    let j = j * 3 + 3
                end if
                let l_end = mdy(j,l_contract.interest_day,yy)
            when '4' # 半年 6 12
                if mm mod 6  == 0 then
                # 是还息月份，判断还息日期
                    let j = mm / 6
                    let j = j * 6 + 6
                    if dd >= l_contract.interest_day then
                    # 还息日在应还日之后，要增加月份
                        if j + 6 > 12 then
                            let yy = yy + 1
                            let j = j + 6 - 12
                        else
                            let j = j + 6
                        end if
                    end if
                else
                # 不是还息月份，切换到还息月份
                    let j = mm / 6
                    let j = j * 6 + 6
                end if
                let l_end = mdy(j,l_contract.interest_day,yy)
            when '5' # 年 12
                if mm = 12 then
                    if dd >= l_contract.interest_day then
                        let yy = yy + 1
                    end if
                end if
                let l_end = mdy(12,l_contract.interest_day,yy)
        end case
        if l_end > g_today + p_days then
            continue foreach
        end if
    end foreach
    call g_tointer.deleteElement(i)

end function
