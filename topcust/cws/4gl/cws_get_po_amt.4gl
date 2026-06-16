# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_get_po_amt.4gl
# Descriptions...: 查询模具采购金额
# Date & Author..: darcy 2026年4月7日

database ds


globals "../../config/top.global"
globals "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"

function cws_get_po_amt()

    whenever error continue

    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_get_po_amt_process()
    end if

    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_get_po_amt_process()
    define l_node,l_detail,l_r          om.DomNode
    define l_sql                    string
    define l_cnt1,l_cnt2,i,j        integer
    define param record
            pr          varchar(20),
            erp_pr      varchar(20),
            item        varchar(20)
        end record
    define l_return record
            pr      varchar(20),
            date    date,
            erp_pr  varchar(20),
            item    varchar(20),
            success varchar(1),
            mark    varchar(1000),
            po      varchar(200),
            qty     decimal(15,3),
            amt     decimal(15,3),
            amtf    decimal(15,3)
        end record

    let l_cnt1 = aws_ttsrv_getMasterRecordLength("GetPOAmt")

    for i = 1 to l_cnt1

        let l_node = aws_ttsrv_getMasterRecord(i, "GetPOAmt")
        let l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node, "pr")
        if l_cnt2 = 0 then
           let g_status.code = "-1"
           let g_status.description = '未找到任何需要处理的资料'
           return
        end if

        for j = 1 to l_cnt2

            initialize param.* to null
            initialize l_return.* to null
            let l_detail = aws_ttsrv_getDetailRecord(l_node,j,"pr")

            let param.pr = aws_ttsrv_getRecordField(l_detail,"pr")
            let param.erp_pr = aws_ttsrv_getRecordField(l_detail,"erp_pr")
            let param.item = aws_ttsrv_getRecordField(l_detail,"item")

            let l_return.pr = param.pr
            let l_return.erp_pr = param.erp_pr
            let l_return.item = param.item

            call cws_get_po_amt_do(param.*)
                returning l_return.mark,l_return.po,
                          l_return.qty,l_return.amt,l_return.amtf,
                          l_return.date
            let l_r = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")
        end for
    end for

end function

-- 执行采购单金额查询接口
function cws_get_po_amt_do(l_param)
    define i,j                  integer
    define l_param record
            pr                  varchar(20),
            erp_pr              varchar(20),
            item                varchar(20)
        end record
    define l_amt,l_amtf         like pmn_file.pmn88
    define l_qty                like pmn_file.pmn20
    define po                   varchar(200)
    define l_cnt                integer
    define l_pmm01              like pmm_file.pmm01,
           l_pmn20              like pmn_file.pmn20,
           l_pmn88              like pmn_file.pmn88,
           l_pmn88t             like pmn_file.pmn88t,
           l_pmm04              like pmm_file.pmm04,
           l_date               date

    -- 检查单据是否存在
    select count(*) into l_cnt from pml_file,pmk_file where pml01 = pmk01
       and pmk18 = 'Y' and pmk01 = l_param.erp_pr
       and pmkud04 = l_param.pr and pml04 = l_param.item

    if l_cnt == 0 then
        return "ERP请购单不存在或者不是审核状态","",0,0,0
    end if

    -- 检查采购单是否生成

    let l_cnt = 0
    select count(*) into l_cnt from pmm_file,pmn_file where pmm01 = pmn01
      and pmm18 ='Y' and pmn24 = l_param.erp_pr and pmn04 = l_param.item

    if l_cnt == 0 then
        return "还未转采购单，无法查询金额","",0,0,0,''
    end if

    declare get_po_amt_1 cursor for
        select pmm01,pmn20,pmn88,pmn88t,pmm04
          from pmm_file,pmn_file where pmm01 = pmn01
           and pmm18 ='Y' and pmn24 = l_param.erp_pr
           and pmn04 = l_param.item
    let po = ''
    let l_qty = 0
    let l_amt = 0
    let l_amtf = 0
    foreach get_po_amt_1 into l_pmm01,l_pmn20,l_pmn88,l_pmn88t,l_pmm04
        if sqlca.sqlcode then
            call cl_err('get_po_amt_1',sqlca.sqlcode,1)
            exit foreach
        end if
        if cl_null(l_pmm04) or l_date > l_pmm04 or l_date < mdy(1,1,2000) then
            let l_date = l_pmm04
        end if

        if cl_null(po) then
            let po = l_pmm01
        else
            let po = po , "," , l_pmm01
        end if
        let l_qty = l_qty + l_pmn20
        let l_amt = l_amt + l_pmn88
        let l_amtf = l_amtf + l_pmn88t

    end foreach
    return "",po,l_qty,l_amt,l_amtf,l_date
end function
