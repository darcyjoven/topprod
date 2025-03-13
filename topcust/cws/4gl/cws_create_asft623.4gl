# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_create_asft623.4gl
# Descriptions...: 产生倒扣料作业
# Date & Author..: darcy:2024/01/224
 
database ds
 
 
globals "../../config/top.global" 
globals "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"
globals "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"
# DEFINE g_status RECORD
#     code          STRING,
#     sqlcode       STRING,
#     description   STRING
# END RECORD

define l_return dynamic array of record
        flag        like type_file.chr1,
        order       integer,
        msg         string
        end record
define g_sgm record 
        sgm01   like sgm_file.sgm01,
        sgm04   like sgm_file.sgm04,
        sgm301  like sgm_file.sgm301
    end record
define l_user       varchar(200)
define l_grup       varchar(200)
define l_post_date  date
define l_stock_no   varchar(200)
define l_store_no   varchar(200)
define l_k,g_cnt integer

define g_sfu01   varchar(40)

define g_sfu record
    sfu00       like sfu_file.sfu00,
    sfu01       like sfu_file.sfu01,
    sfu02       like sfu_file.sfu02,
    sfu04       like sfu_file.sfu04,
    sfupost     like sfu_file.sfupost,
    sfuuser     like sfu_file.sfuuser,
    sfugrup     like sfu_file.sfugrup,
    sfumodu     like sfu_file.sfumodu,
    sfudate     like sfu_file.sfudate,
    sfuconf     like sfu_file.sfuconf,
    sfuplant    like sfu_file.sfuplant,
    sfulegal    like sfu_file.sfulegal,
    sfuoriu     like sfu_file.sfuoriu,
    sfuorig     like sfu_file.sfuorig,
    sfu15       like sfu_file.sfu15,
    sfu16       like sfu_file.sfu16,
    sfumksg     like sfu_file.sfumksg
end record

type sfv record
    sfv01       like sfv_file.sfv01,
    sfv03       like sfv_file.sfv03,
    sfv04       like sfv_file.sfv04,
    sfv05       like sfv_file.sfv05,
    sfv06       like sfv_file.sfv06,
    sfv07       like sfv_file.sfv07,
    sfv08       like sfv_file.sfv08,
    sfv09       like sfv_file.sfv09,
    sfv11       like sfv_file.sfv11,
    sfv20       like sfv_file.sfv20,
    sfv30       like sfv_file.sfv30,
    sfv31       like sfv_file.sfv31,
    sfv32       like sfv_file.sfv32,
    sfv930      like sfv_file.sfv930,
    sfv41       like sfv_file.sfv41,
    sfv42       like sfv_file.sfv42,
    sfv43       like sfv_file.sfv43,
    sfv44       like sfv_file.sfv44,
    sfvud07     like sfv_file.sfvud07,
    sfvud13     like sfv_file.sfvud13,
    sfvplant    like sfv_file.sfvplant,
    sfvlegal    like sfv_file.sfvlegal
end record

define g_sfv sfv
define tm record
        order       integer,
        lot_no      varchar(40),
        gen_date    date,
        amt         decimal(15,3)
    end record
define g_postdate like sfu_file.sfu03

function cws_create_asft623()
     
    whenever error continue
 
    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037 
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_create_asft623_process()
    end if
 
    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_create_asft623_process()
    define l_cnt,l_cnt1,l_i,l_cnt2     integer
    define l_node1,l_node2,l_node3,l_node          om.DomNode
    define l_type  varchar(200)
    define l_ok     integer
    define l_sfu    record like sfu_file.*
    define l_list    om.NodeList

    let g_success = 'Y'
    let l_cnt1 = aws_ttsrv_getMasterRecordLength("CreateAsft623") 
    if l_cnt1 = 0 then
       let g_status.code = "-1"
       let g_status.description = "no recordset processed!"
       return
    end if
    call l_return.clear()
    for l_i = 1 to l_cnt1
        let l_list = g_request_root.selectByPath("//Document/RecordSet/Master[@name=\"CreateAsft623\"]")
        if l_list.getlength() = l_cnt1 then
            let l_node1 = l_list.item(l_i)
        end if 

        # 用户 工号
        let l_user = aws_ttsrv_getRecordField(l_node1,"user")
        select gen03 into l_grup from gen_file where gen01 = l_user
        let l_post_date = aws_ttsrv_getRecordField(l_node1,"post_date")
        # 
        if g_sma.sma53 >= l_post_date then
            let g_status.code = 'mfg9999'
            exit for
        end if
        let l_stock_no = aws_ttsrv_getRecordField(l_node1,"stock_no")
        let l_store_no = aws_ttsrv_getRecordField(l_node1,"store_no")

        if cl_null(l_post_date) then
            let l_post_date = g_today
        end if

        let l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "SFV")
        if l_cnt2 = 0 then
           let g_status.code = "mfg-009"   #必須有單身資料
           exit for
        end if
        
        let g_sfu01 = ""

        begin work
        let l_ok = cws_create_asft623_sfu01()
        if not l_ok then
            let g_status.code = "-1"
            let g_status.description = "产生入库单失败"
            rollback work
            return
        end if

        let g_success = 'Y'
        let g_cnt = 1
        for l_k = 1 TO l_cnt2
            let l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_k,"SFV")

            initialize tm.* to null
            let tm.order  = aws_ttsrv_getRecordField(l_node2,"order")
            let tm.lot_no  = aws_ttsrv_getRecordField(l_node2,"lot_no")
            let tm.gen_date = aws_ttsrv_getRecordField(l_node2,"gen_date")
            let tm.amt = aws_ttsrv_getRecordField(l_node2,"amt")

            let l_ok = cws_create_asft623_sfv()
            if not l_ok then
                let g_success = 'N'
                let g_status.code = "-1"
                let g_status.description = "产生入库单失败"
                rollback work
            end if
        end for
        if g_success = 'Y' then
            commit work
            let g_status.code = '0'
            let g_status.description = g_sfu01
        end if
    end for
    let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(g_status), "Master")
    call aws_ttsrv_addDetailRecord(l_node,base.TypeInfo.create(l_return),"Detail")
end function


# 产生倒扣料单别，并插入单头
function cws_create_asft623_sfu01()
    define l_sql    string
    define l_sfu01  varchar(40)
    define l_chr    varchar(40)
    define l_new_no integer

    # 1. 锁表smy_file
    let l_sql = "select * from smy_file where smyslip = ? for update"
    prepare crt_asft623_1p from l_sql
    declare crt_asft623_1c cursor for crt_asft623_1p

    begin work
    open crt_asft623_1c using 'MSL'

    # 2. 取最大编码
    let l_chr = sfmt("MSL-%1%2",year(today) mod 100 using '&&',month(today) using '&&') 
    let l_chr = l_chr,"%"
    select max(sfu01) into g_sfu01 from sfu_file
     where sfu01 like l_chr
    
    if cl_null(g_sfu01) then
        let l_new_no = 0
    else
        let l_new_no = cs_36_decode(g_sfu01[9,12])
    end if
    let g_sfu01 =  sfmt("MSL-%1%2%3",
            year(today) mod 100 using '&&',
            month(today) using '&&',
            cs_36_encode(l_new_no+1))

    let g_sfu.sfu00   = '1'
    let g_sfu.sfu01   = g_sfu01
    let g_sfu.sfu02   = l_post_date
    let g_sfu.sfu04   = l_grup
    let g_sfu.sfupost = 'N'
    let g_sfu.sfuuser = l_user
    let g_sfu.sfugrup = l_grup
    let g_sfu.sfumodu = l_user
    let g_sfu.sfudate = g_today
    let g_sfu.sfuconf = 'N'
    let g_sfu.sfuplant = g_plant
    let g_sfu.sfulegal = g_legal
    let g_sfu.sfuoriu = l_user
    let g_sfu.sfuorig = l_grup
    let g_sfu.sfu15   = '0'
    let g_sfu.sfu16   = l_user
    let g_sfu.sfumksg = 'N'

    insert into sfu_file (sfu00, sfu01,sfu02,sfu04,sfupost,
                          sfuuser,sfugrup,sfumodu,sfudate,sfuconf,
                          sfuplant,sfulegal,sfuoriu,sfuorig,sfu15,
                          sfu16,sfumksg)
     values (
        g_sfu.sfu00,g_sfu.sfu01,g_sfu.sfu02,g_sfu.sfu04,g_sfu.sfupost,
        g_sfu.sfuuser,g_sfu.sfugrup,g_sfu.sfumodu,g_sfu.sfudate,g_sfu.sfuconf,
        g_sfu.sfuplant,g_sfu.sfulegal,g_sfu.sfuoriu,g_sfu.sfuorig,g_sfu.sfu15,
        g_sfu.sfu16,g_sfu.sfumksg)
    if status then
        let g_status.code = "mfg-009"
        let g_status.description = cl_getmsg("mfg-009",g_lang)
        rollback work
        return false
    else
        return true
    end if
end function


# 建立单身，已经在事务中
function cws_create_asft623_sfv()
    define l_ok         boolean
    define l_sfa01      like sfa_file.sfa01
    define l_ima153     like ima_file.ima153
    define l_cnt,l_i    integer
    define l_min_set    decimal(15,3)
    define l_sfv09      decimal(15,3)
    define l_max,l_max2        integer
    define l_sgm01      like sgm_file.sgm01
    define l_sfb04      like sfb_file.sfb04
    define l_sgm311     like sgm_file.sgm311 
    define l_sql        string

    initialize g_sfv.* to null
    let l_sfa01 = tm.lot_no[1,12]

    let g_sfv.sfv01   = g_sfu01
    let g_sfv.sfv03   = tm.order

    let l_sgm01 = tm.lot_no[1,16],"-00"
    select sgm03_par,sgm02 into g_sfv.sfv04,g_sfv.sfv11
     from sgm_file where sgm01 = l_sgm01
    # let g_sfv.sfv04   
    let g_sfv.sfv05   = l_stock_no
    let g_sfv.sfv06   = l_store_no

    # 批号，生成流水号
    select max(substr(sfv07,21,3)) into l_max
      from sfv_file where sfv07 like tm.lot_no||'%'
    if cl_null(l_max) then
        let l_max = 1
    else
        let l_max = l_max + 1
    end if
    select max(substr(img04,21,3)) into l_max2
     from img_file where img04 like tm.lot_no||'%'
    if cl_null(l_max2) then
        let l_max2 = 1
    else
        let l_max2 = l_max2 + 1
    end if
    let l_max = iif(l_max>l_max2,l_max,l_max2)

    let g_sfv.sfv07 = sfmt("%1-%2",tm.lot_no,l_max using '&&&')


    let g_sfv.sfv09   = tm.amt
    # let g_sfv.sfv11   
    let g_sfv.sfv20   = l_sgm01
    select ima25,ima25,ima153 into g_sfv.sfv30,g_sfv.sfv08,l_ima153
      from ima_file
     where ima01 = g_sfv.sfv04
    if cl_null(l_ima153) then let l_ima153 = 0 end if
    # let g_sfv.sfv30   
    let g_sfv.sfv31   = 1
    let g_sfv.sfv32   = 0
    let g_sfv.sfv930  = 'B12'
    let g_sfv.sfv41   = ' '
    let g_sfv.sfv42   = ' '
    let g_sfv.sfv43   = ' '
    let g_sfv.sfv44   = ' '
    let g_sfv.sfvud07 = 0
    let g_sfv.sfvud13 = tm.gen_date
    let g_sfv.sfvplant = g_plant
    let g_sfv.sfvlegal = g_legal

    # 检查最小发料套数是否满足
    call s_minp(g_sfv.sfv11,g_sma.sma73,l_ima153,'','','',l_post_date)
        returning l_cnt,l_min_set
    if l_cnt != 0  then
        let g_status.code = "asf-549"
        let g_status.description = g_sfv.sfv11," ",cl_getmsg("asf-549",g_lang) 
        rollback work
        return false
    end if

    if cl_null(l_min_set) then
        let l_min_set = 0
    end if

    # 查询除了此笔外所有入库单
    select sum(sfv09) into l_sfv09 from sfv_file,sfu_file
     where sfuconf != 'X' and sfu01 = sfv01
       and sfv11 = g_sfv.sfv11 and sfu01 != g_sfu01

    if cl_null(l_sfv09) then
        let l_sfv09 = 0
    end if
    
    if l_min_set - l_sfv09  < g_sfv.sfv09 then
        let l_i = l_return.getlength() + 1
        let l_return[l_i].flag = 'N'
        let l_return[l_i].order = g_sfv.sfv03
        let l_return[l_i].msg = sfmt("入库数量大于发料套数，工单：%1最小发料套数：%2已入库数量：%3本次入库数量：%4",g_sfv.sfv11,l_min_set,l_sfv09,g_sfv.sfv09)
        let g_success = 'N'
        rollback work
    end if

    # 检查sgm可入库数量 s--- 
    let l_sql = "SELECT sgm311 FROM (
                    SELECT 
                        sgm01, 
                        sgm03, 
                        sgm311,
                        ROW_NUMBER() OVER (PARTITION BY sgm01 ORDER BY sgm03 DESC) as rn
                    FROM sgm_file where sgm01 = ? )
                WHERE rn = 1 "
    prepare cws_asft623_sgm311 from l_sql
    execute cws_asft623_sgm311 using l_sgm01 into l_sgm311
    if cl_null(l_sgm311) then
        let l_i = l_return.getlength() + 1
        let l_return[l_i].flag = 'N'
        let l_return[l_i].order = g_sfv.sfv03
        let l_return[l_i].msg = sfmt("未查询到完工记录 LOT：%1",l_sgm01)
        let g_success = 'N'
        rollback work
    end if

    select sum(sfv09) into l_sfv09 from sfv_file,sfu_file
     where sfuconf != 'X' and sfu01 = sfv01
       and sfv20 = l_sgm01 and sfu01 != g_sfu01

    if cl_null(l_sfv09) then
        let l_sfv09 = 0
    end if

    if l_sgm311 - l_sfv09  < g_sfv.sfv09 then
        let l_i = l_return.getlength() + 1
        let l_return[l_i].flag = 'N'
        let l_return[l_i].order = g_sfv.sfv03
        let l_return[l_i].msg = sfmt("入库数量大于完工数量，LOT：%1完工数量：%2已入库数量：%3本次入库数量：%4",l_sgm01,l_sgm311,l_sfv09,g_sfv.sfv09)
        let g_success = 'N'
        rollback work
    end if

    # 检查sgm可入库数量 e---

    # 工单已结案
    select sfb04 into l_sfb04 from sfb_file where sfb01 = g_sfv.sfv11

    if l_sfb04 = '8' then
        let l_i = l_return.getlength() + 1
        let l_return[l_i].flag = 'N'
        let l_return[l_i].order = g_sfv.sfv03
        let l_return[l_i].msg = sfmt("工单已结案不得入库，工单：%1",g_sfv.sfv11)
        let g_success = 'N'
        rollback work
    end if
    if g_success = 'N' then
        return false
    end if
    insert into sfv_file (sfv01,sfv03,sfv04,sfv05,sfv06,
                          sfv07,sfv08,sfv09,sfv11,sfv20,
                          sfv30,sfv31,sfv32,sfv930,sfv41,
                          sfv42,sfv43,sfv44,sfvud07,sfvud13,
                          sfvplant,sfvlegal)
     values (g_sfv.*)

    if g_sfv.sfv07 is null then let g_sfv.sfv07 = ' ' end if

    select count(*) into l_cnt from img_file
     where img01=g_sfv.sfv04 and img02=g_sfv.sfv05
       and img03=g_sfv.sfv06 and img04=g_sfv.sfv07

    if status = 100 or l_cnt = 0 then 
        call s_add_img(g_sfv.sfv04, g_sfv.sfv05,
                       g_sfv.sfv06, g_sfv.sfv07,
                       g_sfu.sfu01, g_sfv.sfv03,g_sfv.sfvud13)
    end if

    return true
end function

 
