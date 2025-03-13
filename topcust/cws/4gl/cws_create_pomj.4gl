# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_create_pomj.4gl
# Descriptions...: 创建模具请购单
# Date & Author..: darcy:2024/01/22
 
database ds
 
 

GLOBALS "../../config/top.global" 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"

define l_return record
        flag        like type_file.chr1,
        po_no       varchar(40),
        item_no     varchar(20),
        msg         string
        end record
define tm record
        userno      varchar(10),
        dat         date,
        pono        varchar(40),
        item        varchar(200),
        amt         decimal(15,3),
        mjtype      varchar(40),
        jztype      varchar(40),
        remark      varchar(200),
        grup        varchar(40),
        RDno        varchar(20),
        #darcy:2024/07/09 add s---
        ifspare     varchar(1),
        old_itemno  varchar(40)
        #darcy:2024/07/09 add e---
    end record
define l_user   varchar(200)
define l_k integer
define g_ima01  varchar(20)
define g_pmk01   varchar(40)

function cws_create_pomj()
     
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

function cws_create_pomj_process()
define l_cnt,l_cnt1,l_i,l_cnt2     integer
    define l_node1,l_node2,l_node3,l_node          om.DomNode
    define l_type  varchar(200)
    define l_ok     integer
    define l_sfp    record like sfp_file.*
    define l_list    om.NodeList
    define l_sql    string #darcy:2024/07/26 add

    let g_success = 'Y'
    let l_cnt1 = aws_ttsrv_getMasterRecordLength("CreatePOMJ") 
    if l_cnt1 = 0 then
       let g_status.code = "-1"
       let g_status.description = "no recordset processed!"
       return
    end if

    #darcy:2024/07/26 add s---
    let l_sql = "select  ima01 from ima_file ",
                " where ima06 = ? and ima01 like ?||'%' ",
                " for update"
    declare cws_pomj_ima_cur cursor from l_sql
    #darcy:2024/07/26 add e---

    for l_i = 1 to l_cnt1
        let l_list = g_request_root.selectByPath("//Document/RecordSet/Master[@name=\"CreatePOMJ\"]")
        if l_list.getlength() = l_cnt1 then
            let l_node1 = l_list.item(l_i)
        end if 

        initialize tm.* to null

        let tm.userno = aws_ttsrv_getRecordField(l_node1,"user")
        let tm.dat    = aws_ttsrv_getRecordField(l_node1,"date")
        let tm.pono   = aws_ttsrv_getRecordField(l_node1,"pono")
        let tm.item   = aws_ttsrv_getRecordField(l_node1,"item")
        let tm.amt    = aws_ttsrv_getRecordField(l_node1,"amt")
        let tm.mjtype = aws_ttsrv_getRecordField(l_node1,"mjtype")
        let tm.jztype = aws_ttsrv_getRecordField(l_node1,"jztype")
        let tm.remark = aws_ttsrv_getRecordField(l_node1,"remark")
        let tm.grup   = aws_ttsrv_getRecordField(l_node1,"grup")
        let tm.RDno   = aws_ttsrv_getRecordField(l_node1,"RDno")
        #darcy:2024/07/09 add s---
        let tm.ifspare   = aws_ttsrv_getRecordField(l_node1,"ifspare")
        let tm.old_itemno   = aws_ttsrv_getRecordField(l_node1,"old_itemno")
        #darcy:2024/07/09 add e---

        # darcy:2024/12/03 add s---
        if cl_null(tm.RDno) then
            if tm.jztype == "试生产" or tm.jztype == "免费样品" then
                let g_status.code = "-1"
                let g_status.description = "试生产与免费样品，必须维护RD号，当前未空"
                return
            end if
        end if
        # darcy:2024/12/03 add e---

        initialize l_return.* to null
        begin work # 开启事务
        let g_success = 'Y'
        if cl_null(tm.old_itemno) then #darcy:2024/07/11 add 
            call cws_create_pomj_ima()  # 建立料件资料
        else
            let g_ima01 = tm.old_itemno
        end if #darcy:2024/07/11 add
        if g_success = 'N' then
            rollback work
            let l_return.flag = 'N'
            let l_return.msg = "料件建立失败"
        end if
        update ima_file 
           set imaud30 = tm.RDno,
               imaud33 = tm.mjtype,
               imaud34 = tm.jztype
         where ima01 = g_ima01
        if sqlca.sqlcode then
            let g_status.code = sqlca.sqlcode
            let g_status.description = "更新料件资料失败"
            return
        end if
        call cws_create_pomj_po() # 生成请购单
        if g_success = 'N' then
            rollback work
            let l_return.flag = 'N'
            let l_return.msg = "产生请购单失败"
        else
            #darcy:2024/07/26 s---
            close cws_pomj_ima_cur
            #darcy:2024/07/26 e---
            commit work
            let l_return.flag = 'Y'
            let l_return.po_no = g_pmk01
            let l_return.item_no = g_ima01
        end if
        let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")
    end for
end function

# 建立料件资料
function cws_create_pomj_ima() 
    define l_ima06  varchar(20) #darcy:2024/07/26 add

    # 需要判断是否是备品
    if tm.ifspare = 'Y' and tm.mjtype = "备品_功能测试" then
        let l_ima06 = "H.FC"
    else
        
        #darcy:2024/09/23 add s---
        # 玻璃菲林
        if tm.mjtype = "玻璃菲林" then
            let l_ima06 = "H.FL"
        else
        #darcy:2024/09/23 add e---
            let l_ima06 = "H.MJ"
        end if #darcy:2024/09/23 add
    end if 

    #darcy:2024/07/26 add s---
    open cws_pomj_ima_cur using l_ima06,l_ima06
    if sqlca.sqlcode then
        close cws_pomj_ima_cur
        let g_success = 'N'
        rollback work
        return 
    end if
    #darcy:2024/07/26 add e---

    call cs_ima(l_ima06,tm.item,"") returning g_ima01
    # darcy:2024/07/09 mod e---
    if cl_null(g_ima01) then
        let g_success = 'N'
    end if
end function

# 建立请购单
function cws_create_pomj_po()

    call cws_create_pomj_pmk()
    if g_success = 'N' then
        return
    end if
    call cws_create_pomj_pml()
    if g_success = 'N' then
        return
    end if
    call cws_create_pomj_conf()
    if g_success = 'N' then
        return
    end if
end function

# 请购单单头
function cws_create_pomj_pmk()
    define l_pmk    record like pmk_file.*
    define li_result    boolean

    initialize l_pmk.* to null

    #darcy:2024/07/09 add s---
    # 要分为备品和治具
    if tm.ifspare = 'Y' and tm.mjtype = "备品_功能测试" then
        let l_pmk.pmk01 = 'PR1'
    else
        let l_pmk.pmk01 = 'PMJ'
    end if
    #darcy:2024/07/09 add e---
    let l_pmk.pmk04= tm.dat

    call s_auto_assign_no("apm",l_pmk.pmk01,l_pmk.pmk04,"1","pmk_file","pmk01","","","") returning li_result,l_pmk.pmk01
    if (not li_result) then
        let g_success = 'N'
        let g_status.code = "-1"
        let g_status.description = "产生请购单单号失败"
        return
    end if
    let g_pmk01  = l_pmk.pmk01

    let l_pmk.pmk02 = "REG"
    let l_pmk.pmk03 = 0
    let l_pmk.pmk12 = tm.userno
    select gen02 into l_pmk.pmk13 from gen_file
     where gen01 = tm.userno
    let l_pmk.pmk18 = 'N'
    let l_pmk.pmk25 = '0'
    let l_pmk.pmk27 = g_today
    let l_pmk.pmk30 = 'Y'
    let l_pmk.pmk31 = YEAR(l_pmk.pmk04)
    let l_pmk.pmk32 = MONTH(l_pmk.pmk04)
    let l_pmk.pmk40 = 0
    let l_pmk.pmk401 = 0
    let l_pmk.pmk43 = 0
    let l_pmk.pmk45 = 'Y'
    let l_pmk.pmkprsw = 'Y'
    let l_pmk.pmkprno = 0
    let l_pmk.pmkmksg = 'N'
    let l_pmk.pmksign = ' '
    let l_pmk.pmkdays = 0
    let l_pmk.pmksseq = 0
    let l_pmk.pmksmax = 0 
    let l_pmk.pmkacti = 'Y'
    let l_pmk.pmkuser = tm.userno
    let l_pmk.pmkgrup = l_pmk.pmk13
    let l_pmk.pmkmodu = tm.userno
    let l_pmk.pmkmodu = l_pmk.pmk13
    let l_pmk.pmkdate = g_today
    let l_pmk.pmk46 = '1'
    let l_pmk.pmk47 = g_plant
    let l_pmk.pmk48 = TIME
    let l_pmk.pmkcrat = g_today
    let l_pmk.pmkplant = g_plant
    let l_pmk.pmklegal = g_legal
    let l_pmk.pmkoriu = tm.userno
    let l_pmk.pmkorig = l_pmk.pmk13
    let l_pmk.pmkud04 = tm.pono

    insert into pmk_file values (l_pmk.*)
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = "生成请购单失败"
        return
    end if
end function
# 请购单单身
function cws_create_pomj_pml()
    define l_pml    record like pml_file.*

    initialize l_pml.* to null

    let l_pml.pml01 = g_pmk01
    let l_pml.pml011 = 'REG'
    let l_pml.pml02 = 1
    let l_pml.pml04 = g_ima01
    let l_pml.pml041 = tm.item
    let l_pml.pml06 = tm.remark

    select ima44,ima25,ima44_fac,ima39,ima44
      into l_pml.pml07,l_pml.pml08,l_pml.pml09,l_pml.pml40,l_pml.pml86
      from ima_file where ima01 = g_ima01
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = "料件资料查询失败"
        return 
    end if
    let l_pml.pml11 = 'N'
    let l_pml.pml12 = ' '
    let l_pml.pml121 = ' '
    let l_pml.pml122 = ' '
    let l_pml.pml13 = 0
    let l_pml.pml14 = 'Y'
    let l_pml.pml15 = 'Y'
    let l_pml.pml16 = '0'
    let l_pml.pml20 = tm.amt
    let l_pml.pml21 = 0
    let l_pml.pml23 = 'Y'
    let l_pml.pml30 = 0
    let l_pml.pml32 = 0
    let l_pml.pml33 = g_today + 7
    let l_pml.pml34 = g_today + 7
    let l_pml.pml35 = g_today + 7
    let l_pml.pml38 = 'Y'
    let l_pml.pml42 = 0
    let l_pml.pml44 = 0
    select gen02 into l_pml.pml67 from gen_file
     where gen01 = tm.userno
    let l_pml.pml87 = tm.amt
    let l_pml.pml190 = 'N'
    let l_pml.pml192 = 'N'
    let l_pml.pml90 = ' '
    let l_pml.pml91 = 'N'
    let l_pml.pml49 = 1
    let l_pml.pml50 = 1
    let l_pml.pml54 = 2
    let l_pml.pml56 = 1
    let l_pml.pmlplant = g_plant
    let l_pml.pmllegal = g_legal
    let l_pml.pml92 = 'N'

    insert into pml_file values(l_pml.*)
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = "请购单产生失败"
        return 
    end if
end function

# 审核请购单
function cws_create_pomj_conf()
    define l_pmkcont    like pmk_file.pmkcont

    let l_pmkcont = TIME
    update pmk_file set
          pmk25 = '1',
          pmkconu = tm.userno,
          pmkcond = g_today,
          pmkcont = l_pmkcont,
          pmk18='Y',
          pmk15 = tm.userno
    where pmk01 = g_pmk01
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = "请购单审核失败"
        return 
    end if
    update pml_file set pml16 = '1'
       where pml01 = g_pmk01
         and pml16 != '9'
    if sqlca.sqlcode then
        let g_success = 'N'
        let g_status.code = sqlca.sqlcode
        let g_status.description = "请购单审核失败"
        return 
    end if
end function
