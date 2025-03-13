# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: cs_case_close.4gl
# Descriptions...: 库存先进先出提示
# Date & Author..: darcy:2024/04/26 add

database ds
 
globals "../../../tiptop/config/top.global"

# 创建需要的临时表，初始化值
# 如果在事务中，必须调用此函数
function cs_close_begin()
    define  l_sql       string
    whenever error continue
    # 创建工单表,需要处理的工单保存在此
    drop table close_temp
    create temp table close_temp(
        sfb01       varchar(40)
    )
    # 创建info表,工单结案需处理信息表
    # status
    # 1.可以直接结案
    # 2.有警告,需确认
    # 3.有错误,需先处理
    # code
    drop table close_info
    create temp table close_info(
        sfb01       varchar(40),
        status      varchar(5),
        cnt         decimal(5),
        docno       varchar(40),
        code        varchar(40),
        remark      varchar(2000)
    )
    drop table close_info2
    create temp table close_info2(
        sfb01       varchar(40),
        status      varchar(5),
        cnt         decimal(5),
        docno       varchar(40),
        code        varchar(40),
        remark      varchar(2000)
    )
    let l_sql = "insert into close_temp (sfb01) values(?)"
    prepare close_temp_ins from l_sql
    let l_sql = "insert into close_info (sfb01,status,cnt,docno,code,remark) values(?,?,?,?,?, ?)"
    prepare close_info_ins from l_sql
end function

# 处理完成，删除临时表
function cs_close_end()
    drop table close_temp
    drop table close_info
    drop table close_info2
end function


# 检查工单是否可以结案
# 将打开弹窗显示工单能否结案，和工单结案前需要处理的
# params:
#   p_list      工单编号数组 
#   p_inTran    是否在事务中
function cs_close_info(p_list,p_date,p_inTran)
    define  p_list      dynamic array of varchar(40)
    define  p_date      date
    define  p_inTran    boolean
    
end function


# 工单结案检查
# 将工单是否能结案，和不能结案原因写入表close_info中
# params:
#   p_list      工单编号数组 
#   p_date      结案时间
function cs_close_chk(p_date) 
    define  p_date      date
    define  l_date      date
    define  l_sql       string

    let g_success = 'Y'
    delete from close_info
    delete from close_info2
    # 1. 工单插入到表中
    # call cs_close_ins(p_list)
    # if g_success = 'N' then
    #     return
    # end if

    #  关账日期检查
    if p_date <= g_sma.sma53 then
        let g_success = 'n'
        call cs_close_err("sma53,closeday",g_sma.sma53||"|"||p_date,"","axm-164")
        return
    end if
    # 1.1 处理已结案工单
    let l_sql = "insert into close_info select a.sfb01,'4',1,'','','工单已结案，结案日期：'||to_char(sfb36,'yy-mm-dd')",
                "  from CLOSE_TEMP a,sfb_file b",
                " where a.sfb01=b.sfb01 and b.sfb04 ='8'"
    prepare cs_close_p0 from l_sql
    execute cs_close_p0

    let l_sql =" delete from close_temp where sfb01 in (select a.sfb01 from sfb_file b,close_temp a where a.sfb01=b.sfb01 and b.sfb04 ='8') "
    prepare cs_close_p01 from l_sql
    execute cs_close_p01

    # 已作废/未审核工单检查
    let l_sql = " insert into close_info select a.sfb01,'5',1,'','','工单已作废或未审核' ",
                "   from close_temp a ,sfb_file b ",
                "  where a.sfb01 = b.sfb01 and b.sfb87<>'Y' "
    prepare cs_close_p02 from l_sql
    execute cs_close_p02

    let l_sql = "delete from close_temp where sfb01 in (select a.sfb01 from sfb_file a,close_temp b where a.sfb01=b.sfb01 and a.sfb87<>'Y')"
    prepare cs_close_p03 from l_sql
    execute cs_close_p03

    # 2. 检查结案日期
    # 2.1 sfe_file 最大日期
    let l_sql = "insert into close_info select sfe01,'3',0,'','','工单元件最后异动日||max(sfe04)||大于结案日期",p_date,
                "'  from sfe_file,close_temp ",
                " where sfe01 = sfb01  group by sfe01 ",
                "having max(sfe04) > '",p_date,"'"
    prepare cs_close_p1 from l_sql
    execute cs_close_p1

    # 2.2 shb_file 最大报工日期
    let l_sql = "insert into close_info select shb05,'3',0,'','','工单报工最后异动日||max(shb03)||大于结案日期",p_date,"'",
                " from shb_file,close_temp where shb05 = sfb01 group by shb05",
                " having max(shb03) > '",p_date,"'"
    prepare cs_close_p2 from l_sql
    execute cs_close_p2

    # 2.3 tlf06 最后异动日期
    let l_sql = "insert into close_info select tlf62,'3',0,'','','工单库存最后异动日||max(tlf06)||大于结案日期",p_date,"'",
                " from tlf_file,close_temp where tlf62=sfb01 group by tlf62",
                " having max(tlf06) > '",p_date,"'"
    prepare cs_close_p3 from l_sql
    execute cs_close_p3

    # 2.4 委外采购单日期
    let l_sql = "insert into close_info select sfb01,'3',0,'','','工单委外采购最后日期||max(pmm04)||大于结案日期",p_date,"'",
                " from pmn_file,pmm_file,close_temp ",
                " where sfb01 = pmn41 and pmn01 = pmm01 and pmm18 <> 'X' group by sfb01",
                " having max(pmm04) > '",p_date,"'"
    prepare cs_close_p4 from l_sql
    execute cs_close_p4
    # 2.5 委外收货
    let l_sql = "insert into close_info select sfb01,'3',0,'','','工单委外收货最后日期||max(rva06)||大于结案日期",p_date,"'",
                " from rva_file,rvb_file,close_temp ",
                " where sfb01 = rvb34 and rva01 = rvb01 and rvaconf <> 'X' group by sfb01",
                " having max(rva06) > '",p_date,"'"
    prepare cs_close_p5 from l_sql
    execute cs_close_p5

    # 3. 检查工单相关单据
    # 3.1 完工入库
    # 是否有未过账、未报废的完工入库单
    let l_sql = "insert into close_info select sfb01,'3',0,sfu01,'asft623','未过账且未报废的工单入库单' ",
                " from sfv_file,sfu_file,close_temp ",
                " where sfv01 = sfu01 and sfv11 = sfb01  and sfupost ='N' and sfuconf<>'X' "
    prepare cs_close_p6 from l_sql
    execute cs_close_p6
    # 3.2 委外采购、收货、入库
    let l_sql = "insert into close_info select sfb01,'3',0,pmm01,'apmt590','未审核的委外采购单' ",
                "  from pmn_file,pmm_file,close_temp ",
                " where pmn01=pmm01 and sfb01 =pmn41 and pmm18='N' ",
                " union all ",
                "select sfb01,'3',0,rva01,'apmt200','未审核的委外收货单' ",
                "  from rva_file,rvb_file,close_temp ",
                " where rva01=rvb01 and rvb34 = sfb01 and rvaconf='N' ",
                " union all ",
                " select sfb01,'3',0,rvu01, ",
                "   case rvu00 when '1' then 'apmt730' when '2' then 'apmt731' when '3' then 'apmt731' else 'x' end ,'未审核的委外入库/验退/仓退单' ",
                "   from rvu_file,rvv_file,close_temp ",
                " where rvu01=rvv01 and rvv18 = sfb01 and rvuconf='N'"
    prepare cs_close_p7 from l_sql
    execute cs_close_p7

    # 3.3 发料单
    # 3.4 退料单
    let l_sql = "insert into close_info select unique sfb01,'3',0,sfp01, ",
                " case sfp06 ",
                " 	when '1' then 'asfi511' ",
                " 	when '2' then 'asfi512' ",
                " 	when '3' then 'asfi513' ",
                " 	when '4' then 'asfi514' ",
                " 	when '6' then 'asfi526' ",
                " 	when '7' then 'asfi527' ",
                " 	when '8' then 'asfi528' ",
                " 	when '9' then 'asfi529' ",
                " end, ",
                " case sfp06 ",
                " 	when '1' then '未审核的成套发料单' ",
                " 	when '2' then '未审核的超领发料单' ",
                " 	when '3' then '未审核的欠料补料单' ",
                " 	when '4' then '未审核的耗材领料单' ",
                " 	when '6' then '未审核的成套退料单' ",
                " 	when '7' then '未审核的超领退料单' ",
                " 	when '8' then '未审核的一般退料单' ",
                " 	when '9' then '未审核的领料退料单' ",
                " end ",
                " from sfs_file,sfp_file,close_temp ",
                " where sfp01 = sfs01 and sfs03 = sfb01 and sfp04 = 'N' and sfpconf<>'X'" 
    prepare cs_close_p8 from l_sql
    execute cs_close_p8

    # 4. 警告
    # 4.1 最小发料套数检查
    let l_sql = "insert into close_info select a.sfb01,'2',0,'','', ",
                " '发料套数不足 发料套数-完工数量-报废数量<0 '||a.sfb09||'+'||a.sfb12||'+'||'-'||a.sfb081||'='||to_char(a.sfb081-a.sfb09-a.sfb12) ",
                " from sfb_file a,(select sfb01 from close_temp) b ",
                " where a.sfb01=b.sfb01 and a.sfb081-a.sfb09-a.sfb12 < 0  "
    prepare cs_close_p9 from l_sql
    execute cs_close_p9
    # 4.2 完工误差率检查
    if g_sma.sma73 = 'Y' then
        let l_sql = "insert into close_info select a.sfb01,'2',0,'','', ",
                    "'完工数量不在可入库数量误差范围中 '||a.sfb08*(100 - nvl(ima153,0))/100||'~'||a.sfb08*(100 +nvl(ima153,0))/100||' 入库+报废='||to_char(a.sfb09+a.sfb12) ",
                    "from sfb_file a,(select sfb01 from close_temp) b,ima_file ",
                    "where a.sfb01=b.sfb01 and a.sfb05 = ima01 ",
                    "and a.sfb09+a.sfb12 not between a.sfb08*(100 - nvl(ima153,0))/100 and a.sfb08*(100 + nvl(ima153,0))/100"
        prepare cs_close_p10 from l_sql
        execute cs_close_p10
    end if
    # 4.3 齐套数量
    # 最小发料套数
    let l_sql = "insert into close_info WITH sfa_min AS ( ",
                "     SELECT sfa01, sfa27, sfa08, sfb08, sfb09, ",
                "         SUM(sfa05) sfa05, ",
                "         SUM(sfa06) sfa06 ",
                "     FROM sfa_file, sfb_file  ",
                "     WHERE sfa01 in (select sfb01 from close_temp) AND sfa01 = sfb01 and sfa05 <> 0  ",
                "     GROUP BY sfa01, sfa27, sfa08, sfb08, sfb09 ",
                " ), ",
                " calculated_min AS ( ",
                "     SELECT sfa01, sfa27, sfa08, sfa05, sfb09, ",
                "         CASE WHEN sfa05 = 0 THEN 0 ELSE sfa06 * sfb08 / sfa05 END AS min2 ",
                "     FROM sfa_min ",
                " ), ",
                " sfa_min2 as ( ",
                " select sfa01,sfa27,sfa08,min2,sfb09 ",
                " FROM ( ",
                "     SELECT sfa01, sfa27, sfa08, ceil( min2) min2, sfb09, ",
                "         ROW_NUMBER() OVER (PARTITION BY sfa01 ORDER BY min2) AS rn ",
                "     FROM calculated_min ",
                " ) ",
                " WHERE rn = 1 ",
                " ) ",
                " SELECT sfa01,'2',0,'','', ",
                " '最小发料套数（'||sfa27||'|'||sfa08||'）：'||min2||'小于工单完工入库数量：'||sfb09 ",
                " FROM sfa_min2 where min2 < sfb09"
    prepare cs_close_p11 from l_sql
    execute cs_close_p11

    # 4.4 在制是否都已处理
    let l_sql = "insert into close_info with sgm_t1 as ( ", # 抓取报工信息，合计报废和下线
                " SELECT sgm01,sgm02,sgm03, sgm65,sgm301, sgm311, sgm313, sgm314, ",
                --累计报废
                "             SUM(sgm314) OVER (PARTITION BY sgm01 ORDER BY sgm03) sgm314s, ",
                --累计下线 
                "             sum(sgm313) OVER (PARTITION BY sgm01 ORDER BY sgm03) sgm313s ",
                " FROM sgm_file ",
                " JOIN (SELECT sfb01  ",
                "         FROM close_temp) sub_query ",
                "     ON sgm02 = sub_query.sfb01 ",
                " ORDER BY sgm01, sgm03 ), ",
                " sgm_t2 as ( ", #/*排除本行的报废和下线*/
                " select sgm01, sgm02,sgm03, sgm65,sgm301, sgm311, sgm313, sgm314, ",
                "             sgm314s-sgm314 sgm314s,sgm313s-sgm313 sgm313s ",
                " from sgm_t1), ",
                " sgm_t3 as ( ", #/*可生产数量去掉下线数量*/
                " select sgm01,sgm02,sgm03,sgm65-sgm314s-sgm313s sgm65,sgm301,sgm311,sgm313,sgm314,sgm314s,sgm313s ",
                " from sgm_t2), ",
                " sgm_t4 as ( ",
                " select sgm01,sgm02,sgm03,sgm65,sgm301,sgm311,sgm313,sgm314,sgm313s,sgm314s, ",
                " least(sgm65,sgm301)-sgm311-sgm313 sgmwip ",
                " from sgm_t3), ",
                " sgm_5 as   ",
                " (select sgm01,sgm02,sgm03,sgmwip,tc_shb02 ", #/*有tc_shb_file开工记录才算作在制*/
                " from sgm_t4,tc_shb_file where sgmwip > 0 ",
                " and sgm01 = tc_shb03 and sgm03 = tc_shb06 and tc_shb01 ='1') ",
                " select sgm02,'2',0,sgm01,'aecq710','工单还有未处理的在制，请处理。LOT:'||sgm01||'作业序号:'||sgm03||'数量:'||sgmwip||' 开工单号:'||tc_shb02 ",
                " from sgm_5 "
    prepare cs_close_p12 from l_sql
    execute cs_close_p12

    # 重新排序 

    let l_sql = "insert into close_info2 with sfb_t1 as ( ",
                " select * from close_info ",
                " union all ",
                " select sfb01,'1',1,'','','可以正常结案' ",
                " from close_temp a ",
                " where  not exists (select 1 from close_info b where a.sfb01=b.sfb01)) ",
                " select sfb01,status,row_number() over(partition by sfb01 order by status desc ,docno ) rn, ",
                " docno,code,remark from sfb_t1" 
    prepare cs_close_p13 from l_sql
    execute cs_close_p13

    delete from close_info
    insert into close_info select * from close_info2 

    # 更新每个工单的状态，状态由最高状态决定
    let l_sql = "merge into close_info a using (",
                " select sfb01,max(status) sta from close_info ",
                " group by sfb01 ) b on (a.sfb01 = b.sfb01) ",
                " when matched then update set a.status = b.sta"
    prepare cs_close_p13_1 from l_sql
    execute cs_close_p13_1


    # 5. 结案
    # 5.1 更新结案状态与日期
    # 5.2 更新sfa25
end function


# 工单结案需处理
# 背景直接不弹窗，失败一个就全部失败
# 前景弹窗，确认是否将警告内容工单结案
# params:
#   p_list  工单list
#   p_date  结案时间
#   p_inTran 是否在事务中
# return:
#   l_ok  处理是否失败
#   l_cnt1 结案工单笔数
#   l_cnt2 未结案工单笔数
function cs_close_do(p_list,p_date,p_inTran)
    define  p_list              dynamic array of varchar(40)
    define  p_date              date
    define  p_inTran,l_ok       boolean
    define  l_cnt1,l_cnt2,l_cnt       integer
    define  l_list              dynamic array of varchar(40)

    let g_success = 'Y'
    if not cs_close_tmp_chk(p_inTran) then
        call cs_close_err("","","未创建临时表，请联系IT人员处理","!")
        let g_success = 'N'
        return
    end if
    # 检查工单能否结案
    # 1. 工单插入到表中
    call cs_close_ins(p_list)
    if g_success = 'N' then
        return
    end if
    call cs_close_chk(p_date)
    
    # 弹窗提示
    # 背景执行
    #   1. 弹窗
    #   2. 如果有警告或者可直接结案，弹窗确认
    #   3. 全部都是可结案和已结案，不需要选择是否将警告内容结案
    # 前景执行
    #   1. 全部都是可结案和已结案，才会结案，其它情况不结案

    if not p_inTran then
        begin work
    end if
    if g_bgjob = 'Y' then
        # 背景执行
        # 如果有1，4状态外的资料，则失败
        let l_cnt = 0
        select count(*) into l_cnt from close_info
         where status not in ('1','4','5')
        if l_cnt > 0  then
            # 不进行结案
            let l_cnt1 = 0
            let l_cnt2 = 0
            select count(unique sfb01) into l_cnt2 from close_info
            return true,l_cnt1,l_cnt2
        else
            # 将可以结案工单结案
            delete from close_temp
            insert into close_temp select unique sfb01 from close_info where status = '1'
            call cs_close_ok(p_date," status = '1' ")
        end if
    else
        # 前景执行
        # 开启弹窗确认
        if cs_close_popup() then
            # TODO 存在一种情况，如果弹窗中没有警告
            # 但是确认后做了在制，或其它内容，会导致警告的工单也会结案
            call cs_close_ok(p_date," status in ('1','2') ")
        end if
    end if

    if not p_inTran then
        if g_success = 'N' then
            rollback work
        else
            commit work
        end if
    end if

end function

# 弹窗确认，勾选的工单插入到close_temp中
function cs_close_popup()
    define l_cnt,l_ac,l_i,l_chkcnt   integer
    define l_sql            string
    define l_close dynamic array of record
        chk     varchar(1),
        sfb01   varchar(40),
        status  varchar(10),
        count   integer,
        docno   varchar(40),
        code    varchar(10),
        remark  varchar(2000)
    end record
    define l_action_choice  varchar(20)
    
    let l_sql = "select case status when '1' then 'Y' else 'N' end chk, ",
                "       sfb01,status,cnt count,docno,code,remark ",
                " from close_info ",
                "order by status,sfb01,docno "
    prepare cs_close_p14 from l_sql
    declare cs_close_cur14 cursor for cs_close_p14

    let l_cnt = 1
    let l_chkcnt = 0
    call l_close.clear()
    foreach cs_close_cur14 into l_close[l_cnt].*
        if sqlca.sqlcode then
            call cs_close_err("","","cs_close_cur14",sqlca.sqlcode)
            let g_success = 'N'
            exit foreach
        end if
        if l_close[l_cnt].chk = 'Y' then
            let l_chkcnt = l_chkcnt + 1
        end if
        let l_cnt = l_cnt + 1 
    end foreach

    call l_close.deleteElement(l_cnt)
    
    open window cs_close_w at 4,4 with form "csub/42f/cs_close"
            attribute (style = g_win_style clipped)
    call cl_ui_init()

    input array l_close without defaults from s_close.*
        attribute(count=l_cnt,maxcount=l_cnt,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input 
            let l_ac = arr_curr()
            display l_cnt to cnt
            display l_chkcnt to selected 
        before row
            let l_ac = arr_curr()
 
        on action exit
            let l_action_choice="exit"
            exit input
        on action controlg
            call cl_cmdask()
            continue input
        on action exporttoexcel
            call cl_download_by_explorer(
                cl_expexcel1(
                    "s_close",base.typeinfo.create(l_close)
                ))
            continue input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let l_action_choice = 'exit'
            exit input
 

        on change chk
            if l_close[l_ac].status = '4' or l_close[l_ac].status = '5' then
                call cl_err("不可选择已结案或报废工单","!",1)
                let l_close[l_ac].chk ='N'
                next field chk
            end if
            if l_close[l_ac].status = '3' then
                call cl_err("此工单需要,先处理再进行结案","!",1)
                let l_close[l_ac].chk ='N'
                next field chk
            end if
            if l_close[l_ac].chk ='N' then
                let l_chkcnt = l_chkcnt - 1
                display l_chkcnt to selected
            else
                let l_chkcnt = l_chkcnt + 1
                display l_chkcnt to selected
            end if

        on action select_all
            let l_chkcnt = 0 
            for l_i = 1 to l_close.getLength()
                if l_close[l_i].status = '1' or l_close[l_i].status = '2' then
                    let l_close[l_i].chk = 'Y'
                    let l_chkcnt = l_chkcnt + 1
                end if
            end for
            display l_chkcnt to selected
            continue input
        on action calcel_all
            for l_i = 1 to l_close.getLength()
                let l_close[l_i].chk = 'N'
            end for
            let l_chkcnt = 0
            display l_chkcnt to selected
        on action unselect
            let l_chkcnt = 0
            for l_i = 1 to l_close.getLength()
                if l_close[l_i].status = '1' or l_close[l_i].status = '2' then
                    let l_close[l_i].chk = iif(l_close[l_i].chk='N','Y','N')
                    let l_chkcnt = l_chkcnt + iif(l_close[l_i].chk='N',0,1)
                end if
            end for
            display l_chkcnt to selected
            continue input
        on action accept
            # 结案已勾选工单
            delete from close_temp
            for l_i = 1 to l_close.getLength()
                if l_close[l_i].chk = 'Y' then
                    if l_close[l_i].status = '1' or l_close[l_i].status = '2' then
                        insert into close_temp(sfb01) values(l_close[l_i].sfb01)
                    end if
                end if
            end for
             
            # 检查是否含有警告类型工单
            let l_cnt = 0
            select count(*) into l_cnt from close_temp
             where status ='2'
            if l_cnt > 0 then
                if not cl_confirm("csf-123") then
                    let l_action_choice = 'exit'
                    exit input
                end if
            end if
            exit input
    end input 
    close window cs_close_w
    if l_action_choice = 'exit' then
        return false
    else
        return true
    end if
end function

# 将指定状态工单结案
# 此函数必在事务中
# 调用此函数，会重新检查一遍close_temp中的资料,检查前将工单sfb锁住
function cs_close_ok(p_date,p_status)
    define p_date       date
    define l_sql,p_status        string
    define l_cnt        integer

    # 锁表
    # sfb_file
    let l_sql = "select sfb01 from sfb_file where sfb01 in (select sfb01 from close_temp) for update nowait"
    prepare cs_close_p15 from l_sql
    declare cs_close_cur15 cursor for cs_close_p15

    open cs_close_cur15
    if sqlca.sqlcode then
        call cs_close_err("","","open cur cs_close_cur15","!")
        close cs_close_cur15
        let g_success = 'N'
        return
    end if
    # 委外的单据
    # pmm_file
    let l_sql = "select pmm01 from pmm_file where pmm01 in (",
                "  select pmn01 from pmn_file where pmn41 in (select sfb01 from close_temp) )",
                " for update nowait"
    prepare cs_close_p15_1 from l_sql
    declare cs_close_cur15_1 cursor for cs_close_p15_1
    open cs_close_cur15_1
    if sqlca.sqlcode then
        call cs_close_err("","","open cur cs_close_cur15_1","!")
        close cs_close_cur15_1
        let g_success = 'N'
        return
    end if

    # 重新检查以下工单
    call cs_close_chk(p_date)

    # 检查是否有3，4状态工单
    let l_cnt = 0
    let l_sql = "select count(*) from close_info ",
                " where not ",p_status clipped
    prepare cs_close_p16 from l_sql
    execute cs_close_p16 into l_cnt
    if l_cnt > 0 then
        call cs_close_err("",l_cnt,"有不可结案工单，请重新确认","!")
        close cs_close_cur15
        let g_success = 'N'
        return
    end if

    call cs_close_wo(p_date)
    call cs_close_sub(p_date)

end function

# 工单结案
function cs_close_wo(p_date)
    define p_date   date
    define l_sql    string
    # 更新结案日期
    # 1 阶段
    let l_sql = "merge into sfb_file a using ( ",
                "     select unique a.sfb01 from sfb_file a,close_temp b ",
                "      where a.sfb01 = b.sfb01 and a.sfb28 is null ",
                " ) b ",
                " on ( a.sfb01 = b.sfb01)  ",
                " when matched then update ",
                "  set a.sfb04 = '8',a.sfb28 = '1',a.sfb36 = '",p_date,"',a.sfbdate = '",g_today,"'"
    prepare cs_close_p17 from l_sql
    execute cs_close_p17

    # 2 阶段
    let l_sql = "merge into sfb_file a using ( ",
                "     select unique a.sfb01 from sfb_file a,close_temp b ",
                "      where a.sfb01 = b.sfb01 and a.sfb28 = '1'",
                " ) b ",
                " on ( a.sfb01 = b.sfb01)  ",
                " when matched then update ",
                "  set a.sfb04 = '8',a.sfb28 = '1',a.sfb36 = '",p_date,"',a.sfbdate = '",g_today,"'"
    prepare cs_close_p18 from l_sql
    execute cs_close_p18

    # 写入日志
    let l_sql = "insert into azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)",
                " select unique 'cs_close','",g_user,"',to_date('",g_today,"','yy/mm/dd'),'",time,"',sfb01,",
                "'UPDATE sfb_file','",g_plant,"','",g_legal,"' from close_temp"
    prepare cs_close_p19 from l_sql
    execute cs_close_p19
    
    # 更新sfa_file
    let l_sql = " merge into sfa_file using (select unique sfb01 from close_temp)",
                " on(sfa01=sfb01) when matched then update set ",
                " sfa25 = sfa05 - sfa06"
    prepare cs_close_p20 from l_sql
    execute cs_close_p20
    
    let l_sql = "insert into azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)",
                " select unique 'cs_close','",g_user,"',to_date('",g_today,"','yy/mm/dd'),'",time,"',sfb01,'更新工单发料，元件料号:'||sfa03,",
                " '",g_plant,"','",g_legal,"' from close_temp,sfa_file ",
                " where sfa01 = sfb01"
    prepare cs_close_p21 from l_sql
    execute cs_close_p21
end function

# 工单关联的委外单同步结案
function cs_close_sub(p_date)
    define p_date   date
    define l_sql    string

    # 更新单身
    let l_sql = " merge into pmn_file a using ( ",
                " select pmn01,pmn02,pmn50-pmn20-pmn55 qty from pmn_file,pmm_file ",
                "  where pmm01 = pmn01 and pmm18 <> 'X' and pmn41 in (select sfb01 from close_temp) ",
                "    and pmn16 not in ('6','7','8')) b ",
                " on (a.pmn01 = b.pmn01 and a.pmn02 = b.pmn02) ",
                " when matched then update set a.pmn57 = qty, ",
                " a.pmn16 = case when qty>0 then '7' when qty=0 then '6' else '8' end "
    prepare cs_close_p22 from l_sql
    execute cs_close_p22

    let l_sql = "insert into azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) ",
                " select unique 'cs_close','",g_user,"',to_date('",g_today,"','yy/mm/dd'),'",time,"',pmn01,'更新委外结案状态,项次:'||pmn02, ",
                " '",g_plant,"','",g_legal,"' from close_temp,pmn_file,pmm_file ",
                " where pmn41 = sfb01 and pmn01 = pmm01 and pmm18 <> 'X' "
    prepare cs_close_p23 from l_sql
    execute cs_close_p23

    # 更新单头
    let l_sql = " merge into pmm_file a using ( select pmm01 from pmm_file,pmn_file,close_temp ",
                "  where pmm01 = pmn01 and pmm18 <> 'X' and pmn41 = sfb01 ",
                " group by pmm01 having count(case when pmn16 not in ('6','7','8') then 1 end ) = 0) b ",
                " on (a.pmm01 = b.pmm01) when matched then update set a.pmm25 = '6' "
    prepare cs_close_p24 from l_sql
    execute cs_close_p24

    let l_sql = "insert into azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) ",
                " select unique 'cs_close','",g_user,"',to_date('",g_today,"','yy/mm/dd'),'",time,"',pmm01,'更新委外结案状态', ",
                " '",g_plant,"','",g_legal,"' from pmm_file,pmn_file,close_temp ",
                " where pmm01 = pmn01 and pmm18 <> 'X' and pmn41 = sfb01 ",
                " group by pmm01 having count(case when pmn16 not in ('6','7','8') then 1 end ) = 0 "
    prepare cs_close_p25 from l_sql
    execute cs_close_p25

end function
 
# 将工单插入close_temp
function cs_close_ins(p_list)
    define  p_list      dynamic array of varchar(40)
    define  l_i         integer

    for l_i = 1 to p_list.getLength()
        execute close_temp_ins using p_list[l_i]
        if sqlca.sqlcode then
            call cs_close_err("sfb01",p_list[l_i],"ins close_temp",sqlca.sqlcode)
            let g_success = 'N'
            exit for
        end if
    end for
end function

# 检查表是否建立,如果没有建立则建立
# 如果事务中,没有建立,则报错
function cs_close_tmp_chk(p_inTran)
    define  l_cnt   integer
    define  l_ok,p_inTran    boolean
    whenever error continue

    # 判断表是否建立
    select count(*) into l_cnt from close_temp
    if sqlca.sqlcode then
        let l_ok = true
    end if
    select count(*) into l_cnt from close_info
    if sqlca.sqlcode then
        let l_ok = true
    end if

    # 不再事务中的时候,可以再建立表
    if not l_ok then
        return true
    end if
    if not p_inTran then
        call cs_close_begin()
        return true
    else
        return false
    end if
end function

# 错误信息，区分背景执行和前台执行
# params:
#   p_field 字段名称,
#   p_value 字段值用‘|’隔开,
#   p_msg   信息,
#   p_ze01  错误代码
function cs_close_err(p_field,p_value,p_msg,p_ze01)
    define p_field,p_value,p_msg    string
    define p_ze01       like ze_file.ze01

    if g_bgjob == 'Y' then
        call s_errmsg('img01,img02,img03,img04',p_field,p_msg,p_ze01,1)
    else
        call cl_err(p_msg,p_ze01,1)
    end if
end function

# 工单警告
function cs_close_warn(p_sfb01,p_docno,p_remark)
    define p_sfb01,p_docno      varchar(40)
    define p_remark              varchar(400)
    define p_code   varchar(40)
    
    let p_code = cs_close_getcode(p_docno)
    execute close_info_ins using p_sfb01,'2','0',p_docno,p_code,p_remark
    if sqlca.sqlcode then
        call cs_close_err("sfb01,sfe01",p_sfb01||"|"||p_docno,"ins close_info",sqlca.sqlcode)
        return false
    end if
    return true
end function

# 工单错误
function cs_close_error(p_sfb01,p_docno,p_remark)
    define p_sfb01,p_docno      varchar(40)
    define p_remark             varchar(400)
    define p_code   varchar(40)
    
    let p_code = cs_close_getcode(p_docno)
    execute close_info_ins using p_sfb01,'3','0',p_docno,p_code,p_remark
    if sqlca.sqlcode then
        call cs_close_err("sfb01,sfe01",p_sfb01||"|"||p_docno,"ins close_info",sqlca.sqlcode)
        return false
    end if
    return true
end function

# 返回单据编号的作业编码
function cs_close_getcode(p_docno)
    define p_docno      varchar(40)
    return ""
end function
