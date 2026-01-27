# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_update_lot.4gl
# Descriptions...: 报工资料异动资料
# Date & Author..: darcy:2024/01/22
 
database ds
 
 

GLOBALS "../../config/top.global" 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"


define tm record
    lot_no      varchar(40),    # lot号
    qty         integer,        # 数量
    sub_no      varchar(10)     # 作业编号
end record
define g_type  integer         # 1.开工 2.完工 3.报废
define g_peo    varchar(10)     # 作业人员
define l_k integer

function cws_update_lot()
     
    whenever error continue
 
    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037 
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_create_pomj_process()
    end if
 
    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_update_lot_process()
    define i,j,k,l,m,n,l_cnt,l_cnt2 integer
    define l_node,l_detail        om.DomNode


    let l_cnt = aws_ttsrv_getMasterRecordLength("UpdateLot")
    if l_cnt = 0 then 
        let g_status.code = "-1"
        let g_status.description = "no recordset processed!"
        return
    end if

    for i = 1 to l_cnt
        let g_type = 0
        let g_peo = ''

        # 单头参数
        let l_node = aws_ttsrv_getMasterRecord(i, "UpdateLot")
        let g_peo = aws_ttsrv_getRecordField(l_node,"user")
        let g_type = aws_ttsrv_getRecordField(l_node,"status")

        if g_type not matches '[123]' then
            let g_status.code = "-1"
            let g_status.description = sfmt('该状态 %1 不在处理范围内',g_type)
            return
        end if

        let l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node, "lot")
        if l_cnt2 = 0 then
           let g_status.code = "-1"
           let g_status.description = '未找到任何需要处理的资料'
           return
        end if

        # 遍历单身
        begin work
        let g_success = 'Y'
        
        for j = 1 to l_cnt2
            initialize tm.* to null
            let l_detail = aws_ttsrv_getDetailRecord(l_node,j,"lot")
            let tm.lot_no = aws_ttsrv_getRecordField(l_detail,"lot_no")
            let tm.qty = aws_ttsrv_getRecordField(l_detail,"qty")
            let tm.sub_no = aws_ttsrv_getRecordField(l_detail,"sub_no")

            case g_type
                when 1
                    call cws_update_lot_del_process()
                when 2
                    call cws_update_lot_del_process()
                when 3
                    call cws_update_lot_del_scrap()
                otherwise 
                    let g_success = 'N'
                    let g_status.code = "-1"
                    let g_status.description = '未找到任何需要处理的资料'
            end case
        end for
        if g_success = 'Y' then
            commit work
            let g_status.code = "0"
            let g_status.description = sfmt('%1笔报废已删除',l_cnt2)
        else
            rollback work
        end if
    end for
end function

# 删除报工/开工
function cws_update_lot_del_process()
    let g_status.code = "-1"
    let g_status.description = '还未实现的功能'
end function

# 删除报废
function cws_update_lot_del_scrap()
    define l_cnt ,i ,j ,k   integer
    define l_sql            string
    define l_tc_shb02       like tc_shb_file.tc_shb02
    define l_shb01          like shb_file.shb01

    if cws_update_lot_wo_close(tm.lot_no[1,12]) then
        let g_success = 'N'
        let g_status.code = "-1"
        let g_status.description = sfmt("工单%1已结案或者不存在",tm.lot_no[1,12])
        return
    end if

    #Step1. 找到对应的tc_shb_file资料并删除
    let l_sql =" select tc_shb02 ",
               " from (select tc_shb02 ",
               "         from tc_shb_file ",
               "         where tc_shb01 = '2' ",
               "         and tc_shb03 = ? ",
               "         and tc_shb08 = ? ",
               "         and tc_shb121 = ? ",
               "         order by tc_shb14 desc, tc_shb15 desc) ",
               " where rownum = 1     "
    prepare tc_shb_p from l_sql
    execute tc_shb_p using tm.lot_no,tm.sub_no,tm.qty into l_tc_shb02

    if sqlca.sqlcode or cl_null(l_tc_shb02) then
        let g_success = 'N'
        let g_status.code = "-1"
        let g_status.description = sfmt("lot%1找不到(%2/%3)报废的记录tc_shb_file",tm.lot_no,tm.sub_no,tm.qty)
        return
    end if

    delete from tc_shb_file where tc_shb02 = l_tc_shb02
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = sfmt("lot%1删除tc_shb_file失败",tm.lot_no)
        return
    end if
    #Step2. 查询sgm_file 更新报废数量
    update sgm_file set sgm313 = sgm313 - tm.qty
     where sgm01 = tm.lot_no and sgm04 = tm.sub_no
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = sfmt("lot%1更新sgm_file失败",tm.lot_no)
        return
    end if
    #Step3. 找到shb_file 记录并删除
    let l_sql = "select shb01 from ( ",
                "   select shb01 from shb_file ",
                "   where shb16 = ? ",
                "     and shb081 = ? ",
                "     and shb112 = ? ",
                "   order by shb03 desc,shb031 desc) ",
                 "where rownum = 1 "
    prepare shb_p from l_sql
    execute shb_p using tm.lot_no,tm.sub_no,tm.qty into l_shb01
    if sqlca.sqlcode or cl_null(l_tc_shb02) then
        let g_success = 'N'
        let g_status.code = "-1"
        let g_status.description = sfmt("lot%1找不到(%2/%3)报废的记录shb_file",tm.lot_no,tm.sub_no,tm.qty)
        return
    end if

    delete from shb_file where shb01 = l_shb01
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = sfmt("lot%1删除shb_file失败",tm.lot_no)
        return
    end if
    
end function

# 工单结案否
function cws_update_lot_wo_close(p_sfb01)
    define p_sfb01  like sfb_file.sfb01
    define l_sfb04  like sfb_file.sfb04

    select sfb04 into l_sfb04 from sfb_file where sfb01 = p_sfb01

    if sqlca.sqlcode or l_sfb04 == '8' then
        return true
    end if

    return false
end function

