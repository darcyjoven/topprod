# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_check_subdts.4gl
# Descriptions...: 检查当站委外入库数量
# Date & Author..:darcy:2022/10/18
 
database ds
 
 
globals "../../config/top.global" 
globals "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"

define l_return record
        flag        like type_file.chr1,
        subnum      like type_file.num20_6,
        dtsnum      like type_file.num20_6
        end record

function cws_check_subdts()
     
    whenever error continue
 
    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037 
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_check_subdts_process()
    end if
 
    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_check_subdts_process()
    define l_node,l_node1           om.DomNode
    define l_sql    string
    define l_cnt1        like type_file.num5

    define param record
            lot_no      like sgm_file.sgm01,
            job_order   like sgm_file.sgm01,
            job_no      like sgm_file.sgm04
            end record
 
    let l_cnt1 = aws_ttsrv_getmasterrecordlength("CheckSubDTS")
    if l_cnt1 = 0 then
        let g_status.code = "-1"
        let g_status.description = "无资料!"
        return
    end if 
    
    LET l_node1 = aws_ttsrv_getMasterRecord(1, "CheckSubDTS")

    # 获取第一个 Master 
    let param.lot_no = aws_ttsrv_getRecordField(l_node1,"lot_no")
    let param.job_order = aws_ttsrv_getRecordField(l_node1,"job_order")
    let param.job_no = aws_ttsrv_getRecordField(l_node1,"job_no")

    if cl_null(param.job_order) then
        select sgm03 into param.job_order from sgm_file
         where sgm01 = param.lot_no and sgm04 = param.job_no
        if cl_null(param.job_order) then
            let g_status.code = "-1"
            let g_status.description = "无资料"
            let g_success = 'N'
        end if
    end if

    let l_cnt1 = 0
    select count(1) into l_cnt1 from sgm_file
     where sgm01 = param.lot_no and sgm03 = param.job_order
    if l_cnt1 <= 0 then
        let g_status.code = "-1"
        let g_status.description = "未查询到指定lot单",param.lot_no,param.job_order,param.job_no
        let g_success = 'N'
    end if

    #委外订单数量查询
    select sum(pmn20) into l_return.subnum from pmm_file,pmn_file
     where pmm01 = pmn01 and pmm18 = 'Y'
       and pmn18 = param.lot_no and pmn32 = param.job_order

    if cl_null(l_return.subnum) then let l_return.subnum = 0 end if
    
    if l_return.subnum <= 0 then
    # 委外数量为0
        let l_return.dtsnum = 0
        let g_status.code="-1"
        let g_status.description="委外订单需求数量为0"
    end if

    # 委外入库数量查询
    select sum(rvv17) into l_return.dtsnum
      from rvv_file, rvu_file,pmn_file
     where rvv01 = rvu01 and rvu00 = '1' and rvuconf = 'Y'
       and rvv36 = pmn01 and rvv37 = pmn02
       and pmn18 = param.lot_no and pmn32 = param.job_order 
    if cl_null(l_return.dtsnum) then let l_return.dtsnum =0 end if

    if l_return.dtsnum >0 and l_return.subnum >0 then 
        let l_return.flag ='Y'
    else
        let l_return.flag ='N'
    end if
    let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")

end function
