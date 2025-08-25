# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: cs_csmi113.4gl
# Descriptions...: 计算工单排版
# Date & Author..: darcy:2025/04/23
database ds
 
globals "../../../tiptop/config/top.global"


-- 显示到屏幕上的内容
define g_csmi113 record
    ima01       like ima_file.ima01,
    oeb12       like oeb_file.oeb12,
    bei         like oeb_file.oeb12,
    pnls        like type_file.num15_3,
    sets        like type_file.num15_3,
    kuan        integer,
    tc_sma02    varchar(1000),
    tc_sma04    varchar(1000),
    tc_sma07    integer,
    tc_sma09    like tc_sma_file.tc_sma09,
    tc_sma10    like type_file.num15_3,
    tc_sma12    like type_file.num15_3,
    tc_sma13    like type_file.num15_3,
    tc_sma15    like type_file.num15_3,
    tc_sma16    like type_file.num15_3,
    tc_sma18    like type_file.num15_3,
    tc_sma19    like type_file.num15_3,
    impedancechk    varchar(1),
    rollchk         varchar(1),
    pcs         string,
    pnl         like type_file.num15_3,
    first       like type_file.num15_3,
    impedance   like type_file.num15_3,
    roll        like type_file.num15_3,
    main        like type_file.num15_3,
    sub         like type_file.num15_3
end record


function cs_csmi113(p_ima01,p_oeb12)
    define p_ima01      varchar(40)
    define p_oeb12      like type_file.num15_3


    open window cs_csmi113_w at 1,1 with form "csub/42f/cs_csmi113"
         attribute (style = g_win_style clipped)
    call cl_ui_init()

    initialize g_csmi113.* to null
    let g_csmi113.ima01 = p_ima01
    let g_csmi113.oeb12 = p_oeb12
    -- 当料号不为空的时候查询出基本资料
    call cs_csmi113_default(g_csmi113.ima01)
    call cs_csmi113_calculate()

    message ''

    call cl_set_act_visible('accept,cancel',false)

    input by name g_csmi113.* without defaults

        before input

        after field ima01
            call cs_csmi113_default(g_csmi113.ima01)

        on change ima01 
            call cs_csmi113_default(g_csmi113.ima01)
            call cs_csmi113_calculate()
            call cs_csmi113_show()

        on change oeb12,bei,tc_sma12,impedancechk,rollchk,tc_sma10
            call cs_csmi113_calculate()
            call cs_csmi113_show()

        on action btn
            call cs_csmi113_calculate()
            call cs_csmi113_show()
        
        on action controlp
            call cl_set_act_visible('accept,cancel',true)
            call cl_init_qry_var()
            let g_qryparam.form = "cq_ima03"
            let g_qryparam.arg1 = g_lang
            let g_qryparam.default1 = g_csmi113.ima01
            call cl_create_qry() returning g_csmi113.ima01
            call cl_set_act_visible('accept,cancel',false)
            display by name g_csmi113.ima01
            next field ima01

        on action cancel
            exit input
        on action exit
            exit input
    end input
    

    close window cs_csmi113_w
end function

-- 根据料号取出基本资料
function cs_csmi113_default(p_ima01)
    define p_ima01      like ima_file.ima01
    define l_err        integer
    define l_tc_sma02   like tc_sma_file.tc_sma02
    define l_tc_sma03   like tc_sma_file.tc_sma03
    define l_imaud07    like ima_file.imaud07
    define l_imaud06    like ima_file.imaud06
    define l_tok        base.StringTokenizer
    define l_layer      integer
    define l_tc_sma04   like tc_sma_file.tc_sma04

    if cl_null(p_ima01) then
        return
    end if

    -- 判断是否是光板样品
    if p_ima01[10,10] not matches '[FS]' then
        message "请输入光板样品料号"
        initialize g_csmi113.* to null
        return
    end if
    -- pnl 排版
    select imaud10,imaud07,imaud06 into g_csmi113.pnls,l_imaud07,l_imaud06
      from ima_file where ima01 = p_ima01
    if sqlca.sqlcode ='100' then
        message sfmt('找不到%1的PNL排版资料',p_ima01)
        initialize g_csmi113.* to null
        return
    end if
    -- 宽幅
    let l_tok = base.StringTokenizer.create(l_imaud07,"*")
    if l_tok.hasMoreTokens() then
        let g_csmi113.kuan = l_tok.nextToken()
    else
        message sfmt('%1 宽度无法解析,默认为0',l_imaud07)
        let g_csmi113.kuan = 0
    end if
    -- set
    call s_umfchk(p_ima01,'SET','PCS') returning l_err,g_csmi113.sets
    if l_err then
        let g_csmi113.sets =  g_csmi113.pnls / 4
    end if
    -- 层数
    if ORD(p_ima01[8,8]) >= 48 and  ORD(p_ima01[8,8]) <= 57 then
        let l_layer = p_ima01[8,8]
    else
        if ORD(p_ima01[8,8]) >= 65 and ORD(p_ima01[8,8]) <= 90 then
            let l_layer = ORD(p_ima01[8,8]) - 55
        else
            let l_layer = 1
            message sfmt('%1 层数无法解析,默认为1',p_ima01[8,8]) 
        end if
    end if

    -- 查询csmi113 配置资料
    -- 1. 优先查询匹配的料号
    select tc_sma02,tc_sma03 into l_tc_sma02,l_tc_sma03 from (
    select tc_sma02,tc_sma03 from tc_sma_file
     where p_ima01 like tc_sma09||'%' and tc_sma01 = 'csmi113'
       and tc_sma09 is not null
       and (tc_sma07 = l_layer or (tc_sma07 < l_layer and tc_sma05 = 'Y'))
     order by tc_sma02 desc ,tc_sma03
     ) where rownum = 1
    if not cl_null(l_tc_sma02) then
        -- 找到匹配项目
        goto info
    end if
    -- 2. 类型 + 层数
    -- LCM
    let l_tc_sma04 = null
    if l_imaud06 = 4 then
        if g_csmi113.kuan = 250 then
            let l_tc_sma04 = 0
        else
            let l_tc_sma04 = 1
        end if
    end if
    -- 汽车
    if l_imaud06 = 8 then
        if g_csmi113.kuan < 600 then
            let l_tc_sma04 = 2
        else
            let l_tc_sma04 = 3
        end if
    end if 
    -- 宽幅
    if not cl_null(l_tc_sma04) then
        select tc_sma02,tc_sma03 into l_tc_sma02,l_tc_sma03 from
        (select tc_sma02,tc_sma03
            from tc_sma_file where tc_sma01 = 'csmi113'
            and tc_sma02 = l_imaud06 and tc_sma04 = l_tc_sma04
            -- 层数
            and ( (tc_sma07 = l_layer) or (tc_sma05 ='Y' and tc_sma07 < l_layer))
            and tc_sma09 is null 
        order by tc_sma02 desc ,tc_sma03 ) where rownum = 1
    else
        select tc_sma02,tc_sma03 into l_tc_sma02,l_tc_sma03 from
        (select tc_sma02,tc_sma03
            from tc_sma_file where tc_sma01 = 'csmi113'
            and tc_sma02 = l_imaud06
            -- 层数
            and ( (tc_sma07 = l_layer) or (tc_sma05 ='Y' and tc_sma07 < l_layer))
            and tc_sma09 is null 
        order by tc_sma02 desc ,tc_sma03 ) where rownum = 1

        if sqlca.sqlcode = 100 then
            select tc_sma02,tc_sma03 into l_tc_sma02,l_tc_sma03 from
        (select tc_sma02,tc_sma03
            from tc_sma_file where tc_sma01 = 'csmi113'
            and tc_sma02 = '0'
            -- 层数
            and ( (tc_sma07 = l_layer) or (tc_sma05 ='Y' and tc_sma07 < l_layer))
            and tc_sma09 is null 
        order by tc_sma02 desc ,tc_sma03 ) where rownum = 1
        end if
    end if
    label info:
    if cl_null(l_tc_sma02) then
        message sfmt('找不到%1的csmi113配置资料,市场类型%2,层数%3,宽幅%4',p_ima01,l_imaud06,l_layer,g_csmi113.kuan)
        initialize g_csmi113.* to null
        return
    end if

    select tc_sma04,tc_sma07,tc_sma09,tc_sma10,tc_sma12,tc_sma13,tc_sma15,tc_sma16,tc_sma18,tc_sma19
      into g_csmi113.tc_sma04,g_csmi113.tc_sma07,g_csmi113.tc_sma09,g_csmi113.tc_sma10,
           g_csmi113.tc_sma12,g_csmi113.tc_sma13,g_csmi113.tc_sma15,g_csmi113.tc_sma16,
           g_csmi113.tc_sma18,g_csmi113.tc_sma19
      from tc_sma_file where tc_sma01 = 'csmi113' and tc_sma02 = l_tc_sma02 and tc_sma03 = l_tc_sma03
    -- 市场类型
    select tc_sma03||'.'||tc_sma06 into g_csmi113.tc_sma02 from tc_sma_file
     where tc_sma01 = 'csmi102' and tc_sma02 = 'aimi100' and tc_sma03 = l_imaud06
    --  宽幅
    case g_csmi113.tc_sma04
        when 0
            let g_csmi113.tc_sma04 = 'LCM*250'
        when 1
            let g_csmi113.tc_sma04 = 'LCM*500'
        when 2
            let g_csmi113.tc_sma04 = '汽车板<600mm'
        when 3
            let g_csmi113.tc_sma04 = '汽车板>=600mm'
    end case
    -- 默认chk
    let g_csmi113.impedancechk = 'N'
    let g_csmi113.rollchk = 'N'

end function

-- 已有默认数据，进行计算
function cs_csmi113_calculate()
    define l_pcs       like type_file.num15_3
    define l_imaud06    like ima_file.imaud06
    define l_tmp        integer

    if cl_null(g_csmi113.ima01) or cl_null(g_csmi113.tc_sma02) then
        message '料号为空或未匹配到csmi113排版资料'
        initialize g_csmi113.* to null
        return 
    end if

    -- PCS 计算
    -- pnl = （ 订单数量 + 备品数*Set排版 + 出货资料数 ) / 良率 / PNL 排版
    -- s_roundup（1.2，0）
    let g_csmi113.pcs = sfmt('(订单数量:%1 + 备品数:%2 * SET排版:%3 + 出货数量:%4 ) / 良率:%5%% / PNL排版:%6',
                    g_csmi113.oeb12,nvl(g_csmi113.bei,0),g_csmi113.sets,
                    nvl(g_csmi113.tc_sma12,0),g_csmi113.tc_sma10,g_csmi113.pnls)
    let l_pcs = g_csmi113.oeb12
    if not cl_null(g_csmi113.bei) then
        let l_pcs = l_pcs + g_csmi113.bei * g_csmi113.sets
    end if
    if not cl_null(g_csmi113.tc_sma12) then
        let l_pcs = l_pcs + g_csmi113.tc_sma12
    end if
    let l_pcs = l_pcs * 100 / g_csmi113.tc_sma10 / g_csmi113.pnls
    let l_tmp = l_pcs
    -- 进位
    if l_tmp * 1000 < l_pcs * 1000 then
        let g_csmi113.pnl = l_tmp + 1
    else
        let g_csmi113.pnl = l_pcs
    end if
    let g_csmi113.main = g_csmi113.pnl
    -- 首件
    if not cl_null(g_csmi113.tc_sma15) then
        let g_csmi113.first = g_csmi113.tc_sma15
        let g_csmi113.main = g_csmi113.main + g_csmi113.first
    else
        let g_csmi113.first = 0
    end if
    -- 阻抗损耗
    if not cl_null(g_csmi113.tc_sma16) and g_csmi113.impedancechk = 'Y' then
        let g_csmi113.impedance = g_csmi113.tc_sma16
        let g_csmi113.main = g_csmi113.main + g_csmi113.impedance
    else
        let g_csmi113.impedance = 0
    end if

    -- 如果主板数量小于最小投料数，main = 最小 + 卷料 sub  = 最小 + 辅材
    if g_csmi113.main < g_csmi113.tc_sma13 then
        if not cl_null(g_csmi113.tc_sma18) and g_csmi113.rollchk = 'Y' then
            let g_csmi113.main = g_csmi113.tc_sma13 + g_csmi113.tc_sma18
        else
            let g_csmi113.main = g_csmi113.tc_sma13
        end if

        if not cl_null(g_csmi113.tc_sma19) then
            let g_csmi113.sub =  g_csmi113.tc_sma13 + g_csmi113.tc_sma19
        else
            let g_csmi113.sub =  g_csmi113.tc_sma13
        end if
    else
    -- 主板数量大于等于最小投料数，main = main + 卷料  sub = main + 辅材
        if not cl_null(g_csmi113.tc_sma19) then
            let g_csmi113.sub =  g_csmi113.main + g_csmi113.tc_sma19
        else
            let g_csmi113.sub =  g_csmi113.main
        end if
        if not cl_null(g_csmi113.tc_sma18) and g_csmi113.rollchk = 'Y' then
            let g_csmi113.main = g_csmi113.main + g_csmi113.tc_sma18
        end if
    end if
    select  imaud06 into l_imaud06
      from ima_file where ima01 = g_csmi113.ima01
    if l_imaud06 matches '[134]' then
        -- CCM&LCM 最终PNL要为偶数
        if g_csmi113.main mod 2 != 0 then
            let g_csmi113.main = g_csmi113.main + 1 
        end if
        if g_csmi113.sub mod 2 != 0 then
            let g_csmi113.sub = g_csmi113.sub + 1 
        end if
    end if
    
end function

-- 将所有资料显示到画面中
function cs_csmi113_show() 
    display by name g_csmi113.*
end function
