# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_modify_pomj.4gl
# Descriptions...: 结案模具请购单
# Date & Author..: darcy:2026/10/08
#
# 说明:
#   参考 cws_create_pomj.4gl 创建模具请购单接口, 反向做结案.
#   传入: 请购单号(pmk01 / erp_pr) 或 MES 请购单号(pmkud04 / pr).
#   若已转采购 或 已结案, 中断并回传对应报错信息.
#
# 规则:
#   - 单档(Master): ModifyPOMJ; 栏位 pr=pmkud04, erp_pr=pmk01, item=pml04(选填), user
#   - "已转采购": 仅查采购单是否存在 (pmm_file/pmn_file, pmm01=pmn01 and pmn24=pmk01)
#   - "已结案"  : pmk25 IN ('6','9')
#   - "未审核"  : pmk25 = '0' 直接报错 (理论上不应有未审核单据)
#   - 结案写法  : 依标准 apmp451, 单身 pml16 依 (pml20-pml21) 置 6/7/8
#   - pmkud04 对应多笔: 全部一起结案
#   - 校验失败  : 整单中断, 设 g_status 后 return (不逐笔回传)
#   - 不同步 ruc_file 等其它表

database ds


GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"

define l_return record
        flag        like type_file.chr1,
        pr          varchar(40),    # MES 请购单号 (回填)
        erp_pr      varchar(200),   # ERP 请购单号 (可能多笔, 逗号分隔)
        item        varchar(20),
        msg         string
    end record
define tm record
        user        varchar(10),
        pr          varchar(40),    # MES 请购单号 (pmkud04)
        erp_pr      varchar(40),    # ERP 请购单号 (pmk01)
        item        varchar(20)     # 料号 (pml04) 选填
    end record
define g_pmk_arr dynamic array of record
        pmk01   like pmk_file.pmk01
    end record
define g_pmk01  like pmk_file.pmk01 # 当前处理的请购单号
define g_msg    string              # 错误信息 (由 helper 带回)

function cws_modify_pomj()

    whenever error continue

    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    if g_status.code = "0" then
        call cws_modify_pomj_process()
    end if

    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_modify_pomj_process()
    define l_cnt,l_i,l_j    integer
    define l_node,l_n       om.DomNode
    define l_list           om.NodeList

    let g_success = 'Y'
    let l_cnt = aws_ttsrv_getMasterRecordLength("ModifyPOMJ")
    if l_cnt = 0 then
        let g_status.code = "-1"
        let g_status.description = "no recordset processed!"
        return
    end if

    let l_list = g_request_root.selectByPath("//Document/RecordSet/Master[@name=\"ModifyPOMJ\"]")

    for l_i = 1 to l_cnt
        let l_node = l_list.item(l_i)

        initialize tm.* to null
        initialize l_return.* to null
        let l_return.flag = 'N'

        let tm.user   = aws_ttsrv_getRecordField(l_node,"user")
        let tm.pr     = aws_ttsrv_getRecordField(l_node,"pr")
        let tm.erp_pr = aws_ttsrv_getRecordField(l_node,"erp_pr")
        let tm.item   = aws_ttsrv_getRecordField(l_node,"item")

        let l_return.pr   = tm.pr
        let l_return.item = tm.item

        begin work
        let g_success = 'Y'

        #----------------------------------------------------------------------#
        # 定位请购单 (可能多笔) -> g_pmk_arr                                    #
        #----------------------------------------------------------------------#
        call cws_modify_pomj_find()
        if g_pmk_arr.getLength() = 0 then
            rollback work
            let g_status.code = "-1"
            let g_status.description = g_msg
            return
        end if

        for l_j = 1 to g_pmk_arr.getLength()
            let g_pmk01 = g_pmk_arr[l_j].pmk01

            call cws_modify_pomj_check()     # 检查 已转采购 / 已结案
            if g_success = 'Y' then
                call cws_modify_pomj_close() # 结案
            end if
            if g_success = 'N' then
                rollback work
                let g_status.code = "-1"
                let g_status.description = g_msg
                return
            end if

            # 回填 ERP 请购单号 (多笔以逗号分隔)
            if cl_null(l_return.erp_pr) then
                let l_return.erp_pr = g_pmk01
            else
                let l_return.erp_pr = l_return.erp_pr, ",", g_pmk01
            end if
        end for

        commit work
        let l_return.flag = 'Y'
        let l_return.msg  = "结案成功"
        let l_n = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")
    end for
end function

# 定位请购单号 -> g_pmk_arr
function cws_modify_pomj_find()

    declare cws_mpmk_erp_cur cursor for
        select pmk01 from pmk_file where pmk01 = tm.erp_pr
    declare cws_mpmk_pr_cur cursor for
        select pmk01 from pmk_file where pmkud04 = tm.pr

    let g_msg = ''
    call g_pmk_arr.clear()

    #----------------------------------------------------------------------#
    # 优先使用 ERP 请购单号 pmk01                                          #
    #----------------------------------------------------------------------#
    if not cl_null(tm.erp_pr) then
        foreach cws_mpmk_erp_cur into g_pmk_arr[g_pmk_arr.getLength()+1].pmk01
            if sqlca.sqlcode then
                let g_msg = sfmt("请购单 %1 查询失败", tm.erp_pr)
                call g_pmk_arr.clear()
                exit foreach
            end if
        end foreach
        if g_pmk_arr.getLength() = 0 and cl_null(g_msg) then
            let g_msg = sfmt("请购单 %1 不存在", tm.erp_pr)
        end if
        return
    end if

    if cl_null(tm.pr) then
        let g_msg = "请传入请购单号(erp_pr)或 MES 请购单号(pr)"
        return
    end if

    #----------------------------------------------------------------------#
    # 使用 MES 请购单号 pmkud04 定位 (可能多笔, 全部结案)                    #
    #----------------------------------------------------------------------#
    foreach cws_mpmk_pr_cur into g_pmk_arr[g_pmk_arr.getLength()+1].pmk01
        if sqlca.sqlcode then
            let g_msg = sfmt("根据 MES 请购单号 %1 查询失败", tm.pr)
            call g_pmk_arr.clear()
            exit foreach
        end if
    end foreach
    if g_pmk_arr.getLength() = 0 and cl_null(g_msg) then
        let g_msg = sfmt("根据 MES 请购单号 %1 找不到请购单", tm.pr)
    end if
end function

# 检查是否已结案 / 已转采购
function cws_modify_pomj_check()
    define l_pmk25  like pmk_file.pmk25
    define l_cnt    integer

    let l_pmk25 = ' '

    select pmk25 into l_pmk25 from pmk_file where pmk01 = g_pmk01 for update
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 查询失败", g_pmk01)
        return
    end if

    # 未审核
    if l_pmk25 = '0' then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 未审核, 不可结案", g_pmk01)
        return
    end if

    # 已结案 (6=已结案, 9=已取消)
    if l_pmk25 = '6' or l_pmk25 = '9' then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 已结案, 不可重复结案", g_pmk01)
        return
    end if

    # 已转采购: 仅查采购单是否存在
    let l_cnt = 0
    select count(*) into l_cnt
      from pmm_file,pmn_file
     where pmm01 = pmn01
       and pmn24 = g_pmk01
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 采购单查询失败", g_pmk01)
        return
    end if
    if l_cnt > 0 then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 已转采购, 不可结案", g_pmk01)
        return
    end if

    return
end function

# 结案 (依标准 apmp451)
function cws_modify_pomj_close()

    # 单身状况码: 依 (pml20-pml21) -> =0:6(结案) >0:8(结短) <0:7(结长)
    update pml_file set pml16 = '6'
     where pml01 = g_pmk01
       and (nvl(pml20,0) - nvl(pml21,0)) = 0
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 单身结案失败", g_pmk01)
        return
    end if
    update pml_file set pml16 = '8'
     where pml01 = g_pmk01
       and (nvl(pml20,0) - nvl(pml21,0)) > 0
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 单身结案失败", g_pmk01)
        return
    end if
    update pml_file set pml16 = '7'
     where pml01 = g_pmk01
       and (nvl(pml20,0) - nvl(pml21,0)) < 0
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 单身结案失败", g_pmk01)
        return
    end if

    # 单头状况码: 已结案 + 状况异动日期
    update pmk_file set pmk25 = '6',
                       pmk27 = g_today
     where pmk01 = g_pmk01
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_msg = sfmt("请购单 %1 单头结案失败", g_pmk01)
        return
    end if

    return
end function
