# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_get_stock.4gl
# Descriptions...: 库存查询
# Date & Author..: darcy:2025/11/18
 
database ds


GLOBALS "../../config/top.global" 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"

define l_return dynamic array of record
    img01   varchar(20),
    img10   decimal(15,3)
end record
define g_type   varchar(200)
define l_user   varchar(200)
define l_k integer

function cws_get_stock()
     
    whenever error continue
 
    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037 
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_get_stock_process()
    end if
 
    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_get_stock_process()
    define l_cnt,l_cnt1,l_i,l_cnt2     integer
    define l_node1,l_node2,l_node3,l_node          om.DomNode
    define l_type  varchar(200)
    define l_ok     integer
    define l_sfp    record like sfp_file.*
    define l_list    om.NodeList
    define l_sql    string #darcy:2024/07/26 add

    let g_success = 'Y' 
    call l_return.clear()
    let l_cnt1 = aws_ttsrv_getMasterRecordLength("GetStock") 
    if l_cnt1 = 0 then
       let g_status.code = "-1"
       let g_status.description = "no recordset processed!"
       return
    end if

    for l_i = 1 to l_cnt1
        let l_list = g_request_root.selectByPath("//Document/RecordSet/Master[@name=\"GetStock\"]")
        if l_list.getlength() = l_cnt1 then
            let l_node1 = l_list.item(l_i)
        end if
        let g_type = aws_ttsrv_getRecordField(l_node1,"type")
        case g_type
            when "P001"
                call cws_get_stock_p001()
            otherwise
                let g_status.code = "-1"
                let g_status.description = "no recordset processed!"
        end case
        let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(g_status), "Master")
        call aws_ttsrv_addDetailRecord(l_node,base.TypeInfo.create(l_return),"Detail")
    end for
end function

function cws_get_stock_p001()
    define i                integer

    declare get_stock_p001_c cursor for 
        select img01, sum(img10) img10
          from img_file
         where img01 like 'JL%'
           and img02 = 'P001'
           and img18 >= trunc(sysdate)
           and img10 > 0
         group by img01

    let i = 1
    foreach get_stock_p001_c into l_return[i].*
        if sqlca.sqlcode then
            let g_success = 'N'
            let g_status.code = "-1"
            let g_status.description = "获取库存失败,get_stock_p001_c"
            exit foreach
        end if
        let i = i + 1
    end foreach
    call l_return.deleteElement(i)
end function
