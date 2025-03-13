# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_create_tc_pmm.4gl
# Descriptions...: 创建tc_pmm委外资料
# Date & Author..: darcy:2024/01/22
 
database ds
 
 
globals "../../config/top.global" 
globals "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"

define l_return record
        flag        like type_file.chr1,
        msg         string
        end record
define g_tc_pmm record
        lot_no      varchar(200),
        sub_no      varchar(200),
        job_no      varchar(200),
        amount      DECIMAL(20,3),
        comment1    varchar(2000)
    end record
define l_user   varchar(200)
define l_k integer

define g_tc_pmm01   varchar(40)

function cws_create_tc_pmm()
     
    whenever error continue
 
    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037 
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_create_tc_pmm_process()
    end if
 
    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_create_tc_pmm_process()
    define l_cnt,l_cnt1,l_i,l_cnt2     integer
    define l_node1,l_node2,l_node3,l_node          om.DomNode
    define l_type  varchar(200)
    define l_ok     integer

    let g_success = 'Y'
    let l_cnt1 = aws_ttsrv_getMasterRecordLength("CreateTcpmm") 
    if l_cnt1 = 0 then
       let g_status.code = "-1"
       let g_status.description = "no recordset processed!"
       return
    end if

    for l_i = 1 to l_cnt1
        let l_node1 = aws_ttsrv_getMasterRecord(l_i, "CreateTcpmm")
        let l_user = aws_ttsrv_getRecordField(l_node1,"user")
        let l_type = aws_ttsrv_getRecordField(l_node1,"type")

        let l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "TCPMM")
        if l_cnt2 = 0 then
           let g_status.code = "mfg-009"   #必須有單身資料
           exit for
        end if
        
        let g_tc_pmm01 = ""

        begin work
        let g_success = 'Y'
        for l_k = 1 TO l_cnt2
            let l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_k,"TCPMM")
            initialize g_tc_pmm.* to null
            let g_tc_pmm.lot_no = aws_ttsrv_getRecordField(l_node2,"lot_no")
            let g_tc_pmm.sub_no = aws_ttsrv_getRecordField(l_node2,"sub_no")
            let g_tc_pmm.job_no = aws_ttsrv_getRecordField(l_node2,"job_no")
            let g_tc_pmm.amount = aws_ttsrv_getRecordField(l_node2,"amount")
            let g_tc_pmm.comment1 = aws_ttsrv_getRecordField(l_node2,"comment")

            let l_ok = iif(l_type=="insert",cws_create_tc_pmm_ins(),cws_create_tc_pmm_del())
            if not l_ok then
                let g_success = 'N'
                let l_return.flag = 'N'
                let l_return.msg = g_status.description
                rollback work
                exit for
            end if
        end for
        if g_success = 'Y' then
            let l_return.flag = 'Y'
            let l_return.msg = g_tc_pmm01
            commit work
        end if
        let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")
    end for

end function

function cws_create_tc_pmm_ins()
    define l_chr varchar(40)
    define l_sfb04  like sfb_file.sfb04
    define l_tc_pmm  record like tc_pmm_file.*
    define l_imaud10  like ima_file.imaud10
    define l_cnt  integer
    
    # 进行编码
    # if cl_null(g_tc_pmm01) then
    #     let l_chr = 'T01-',year(g_today) mod 100 using '<<',month(g_today) using '&&','%'
    #     select max(tc_pmm01) into g_tc_pmm01 from tc_pmm_file
    #      where tc_pmm01 like l_chr
    #     if cl_null(g_tc_pmm01) or sqlca.sqlcode then
    #         let g_tc_pmm01 = 'T01-',year(g_today) mod 100 using '<<',month(g_today) using '&&','0001'
    #     else
    #         if g_tc_pmm01[9,12] = 9999 then
    #             let g_status.code = "-1"
    #             let g_status.description = g_tc_pmm01," 单号编码超出上限"
    #             return false
    #         end if
    #         let g_tc_pmm01 = 'T01-',year(g_today) mod 100 using '<<',month(g_today) using '&&',(g_tc_pmm01[9,12] + 1) using '&&&&'
    #     end if
    # end if 

    if cl_null(g_tc_pmm01) then
        let g_tc_pmm01 = g_tc_pmm.sub_no
    end if
    
    initialize l_tc_pmm.* to null
    let l_tc_pmm.tc_pmm01 = g_tc_pmm01
    let l_tc_pmm.tc_pmm02 = g_today
    let l_tc_pmm.tc_pmm03 = g_tc_pmm.lot_no[1,16],'-00'
    let l_tc_pmm.tc_pmm04 = g_tc_pmm.lot_no[1,12]

    select sfb04,sfb05 into l_sfb04,l_tc_pmm.tc_pmm05
      from sfb_file where sfb01 = l_tc_pmm.tc_pmm04 
    if sqlca.sqlcode or l_sfb04 ='8' then
        let g_status.code = "-1"
        let g_status.description = l_tc_pmm.tc_pmm04," 工单不存在或已结案。"
        return false
    end if
    let l_tc_pmm.tc_pmm06 = g_tc_pmm.job_no

    select sgm03,ta_sgm01,ta_sgm02 
      into l_tc_pmm.tc_pmm08,l_tc_pmm.tc_pmmud02,l_tc_pmm.tc_pmmud03
      from sgm_file
     where sgm01 = l_tc_pmm.tc_pmm03 and sgm04 = l_tc_pmm.tc_pmm06
    
    if sqlca.sqlcode or cl_null(l_tc_pmm.tc_pmm08) then
        let g_status.code = "-1"
        let g_status.description = l_tc_pmm.tc_pmm03," LOT单不存在。"
        return false
    end if

    let l_tc_pmm.tc_pmm09 = g_tc_pmm.amount
    let l_tc_pmm.tc_pmm11 = 'Y' -- 先设置为N
    let l_tc_pmm.tc_pmm10 = g_tc_pmm.comment1

    let l_tc_pmm.tc_pmmud01 = g_tc_pmm.lot_no

    # 检查是否已经转过
    let l_cnt = 0
    select count(*) into l_cnt from tc_pmm_file
     where tc_pmmud01 = g_tc_pmm.lot_no and tc_pmm11 = 'Y'
       and tc_pmm06 = g_tc_pmm.job_no  #darcy:2024/04/01 add 检查是否已委外，需要考虑不同工序委外
    if l_cnt > 0 then
        select tc_pmm01 into g_tc_pmm01 from tc_pmm_file
         where tc_pmmud01 = g_tc_pmm.lot_no and tc_pmm11 = 'Y'
        let g_status.code = "-1"
        let g_status.description = sfmt("%1lot单已经转过委外，不可再转，委外单号%2",g_tc_pmm.lot_no,g_tc_pmm01)
        return false
    end if

    select max(tc_pmmud10)+1 into l_tc_pmm.tc_pmmud10 from tc_pmm_file where tc_pmm01 = g_tc_pmm01
    if cl_null(l_tc_pmm.tc_pmmud10) then
        let l_tc_pmm.tc_pmmud10 = 1
    end if
    # let l_tc_pmm.tc_pmmud10 = l_k

    # PNL
    select imaud10 into l_imaud10  from ima_file 
     where ima01 = l_tc_pmm.tc_pmm05
    if sqlca.sqlcode or cl_null(l_imaud10) then
        let g_status.code = "-1"
        let g_status.description = l_tc_pmm.tc_pmm05," 找不到排版资料。"
        return false
    end if

    if l_imaud10 = 0 then
        let  l_tc_pmm.tc_pmmud07 = l_tc_pmm.tc_pmm09
    else
        let l_tc_pmm.tc_pmmud07 =   l_tc_pmm.tc_pmm09 / l_imaud10
    end if

    let l_tc_pmm.tc_pmmud14 = g_today
    let l_tc_pmm.tc_pmmud15 = g_today
    let l_tc_pmm.tc_pmmdate = g_today
    let l_tc_pmm.tc_pmmplant = g_plant
    let l_tc_pmm.tc_pmmlegal = g_legal
    let l_tc_pmm.tc_pmmuser = l_user

    insert into tc_pmm_file values (l_tc_pmm.*)
    if sqlca.sqlcode then
        let g_status.code = sqlca.sqlcode
        select ze03 into l_chr from ze_file where ze01 = sqlca.sqlcode and ze02 ='2'
        let g_status.description = l_chr
        return false
    end if
    
    return true
end function

function cws_create_tc_pmm_del()
    define l_cnt  integer
    define l_chr    varchar(1000)

    let l_cnt = 0
    select count(*) into l_cnt
      from tc_pmm_file 
     where tc_pmmud01 = g_tc_pmm.lot_no and tc_pmm11 = 'Y'
       and tc_pmm01 = g_tc_pmm.sub_no
    if l_cnt = 0 then
        let g_status.code = "-1"
        let g_status.description = sfmt("%1lot单不存在委外单据",g_tc_pmm.lot_no)
        return false
    end if

    --update tc_pmm_file set tc_pmm11 = 'N'
    -- where tc_pmmud01 = g_tc_pmm.lot_no and tc_pmm11 = 'Y'
    delete from tc_pmm_file 
     where tc_pmmud01 = g_tc_pmm.lot_no and tc_pmm11 = 'Y'
       and tc_pmm01 = g_tc_pmm.sub_no
    if sqlca.sqlcode then
        let g_status.code = sqlca.sqlcode
        select ze03 into l_chr from ze_file where ze01 = sqlca.sqlcode and ze02 ='2'
        let g_status.description = l_chr
        return false
    end if
    let g_tc_pmm01 = "委外已删除"
    return true
end function
