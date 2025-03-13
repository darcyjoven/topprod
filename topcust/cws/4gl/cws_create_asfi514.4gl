# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_create_asfi514.4gl
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

define l_return record
        flag        like type_file.chr1,
        msg         string
        end record
define g_sgm record 
        sgm01   like sgm_file.sgm01,
        sgm04   like sgm_file.sgm04,
        sgm301  like sgm_file.sgm301
    end record
define l_user   varchar(200)
define l_grup   varchar(200)
define l_k,g_cnt integer

define g_sfp01   varchar(40)

define g_sfp    record
    sfp01       like sfp_file.sfp01,
    sfp02       like sfp_file.sfp02,
    sfp03       like sfp_file.sfp03,
    sfp04       like sfp_file.sfp04,
    sfp05       like sfp_file.sfp05,
    sfp06       like sfp_file.sfp06,
    sfp07       like sfp_file.sfp07,
    sfp09       like sfp_file.sfp09,
    sfpuser     like sfp_file.sfpuser,
    sfpgrup     like sfp_file.sfpgrup,
    sfpmodu     like sfp_file.sfpmodu,
    sfpdate     like sfp_file.sfpdate,
    sfp11       like sfp_file.sfp11,
    sfpconf     like sfp_file.sfpconf,
    sfpud04     like sfp_file.sfpud04,
    sfpplant    like sfp_file.sfpplant,
    sfplegal    like sfp_file.sfplegal,
    sfporiu     like sfp_file.sfporiu,
    sfporig     like sfp_file.sfporig,
    sfp15       like sfp_file.sfp15,
    sfp16       like sfp_file.sfp16,
    sfpmksg     like sfp_file.sfpmksg
    end record

type sfs record
    sfs01       like sfs_file.sfs01,
    sfs02       like sfs_file.sfs02,
    sfs03       like sfs_file.sfs03,
    sfs04       like sfs_file.sfs04,
    sfs05       like sfs_file.sfs05,
    sfs06       like sfs_file.sfs06,
    sfs07       like sfs_file.sfs07,
    sfs08       like sfs_file.sfs08,
    sfs09       like sfs_file.sfs09,
    sfs10       like sfs_file.sfs10,
    sfs26       like sfs_file.sfs26,
    sfs27       like sfs_file.sfs27,
    sfs28       like sfs_file.sfs28,
    sfs32       like sfs_file.sfs32,
    sfsplant    like sfs_file.sfsplant,
    sfslegal    like sfs_file.sfslegal,
    sfs012      like sfs_file.sfs012,
    sfs013      like sfs_file.sfs013,
    sfs014      like sfs_file.sfs014
end record

define g_sfs dynamic array of sfs
define g_postdate like sfp_file.sfp03

function cws_create_asfi514()
     
    whenever error continue
 
    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037 
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_create_asfi514_process()
    end if
 
    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_create_asfi514_process()
    define l_cnt,l_cnt1,l_i,l_cnt2     integer
    define l_node1,l_node2,l_node3,l_node          om.DomNode
    define l_type  varchar(200)
    define l_ok     integer
    define l_sfp    record like sfp_file.*
    define l_list    om.NodeList

    let g_success = 'Y'
    let l_cnt1 = aws_ttsrv_getMasterRecordLength("CreateAsfi514") 
    if l_cnt1 = 0 then
       let g_status.code = "-1"
       let g_status.description = "no recordset processed!"
       return
    end if

    for l_i = 1 to l_cnt1
        let l_list = g_request_root.selectByPath("//Document/RecordSet/Master[@name=\"CreateAsfi514\"]")
        if l_list.getlength() = l_cnt1 then
            let l_node1 = l_list.item(l_i)
        end if 

        # 用户 工号
        let l_user = aws_ttsrv_getRecordField(l_node1,"user")
        let l_grup = aws_ttsrv_getRecordField(l_node1,"grup")
        let g_postdate = aws_ttsrv_getRecordField(l_node1,"post")

        if cl_null(g_postdate) then
            let g_postdate = g_today
        end if

        let l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "SGM")
        if l_cnt2 = 0 then
           let g_status.code = "mfg-009"   #必須有單身資料
           exit for
        end if
        
        let g_sfp01 = ""

        begin work
        let l_ok = cws_create_asfi514_sfp01()
        if not l_ok then
            let l_return.flag = 'N'
            let l_return.msg = g_status.description
            rollback work
            return
        end if

        let g_success = 'Y'
        let g_cnt = 1
        for l_k = 1 TO l_cnt2
            let l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_k,"SGM")
            initialize g_sgm.* to null
            # LOT单号
            let g_sgm.sgm01  = aws_ttsrv_getRecordField(l_node2,"sgm01")
            # 作业编号
            let g_sgm.sgm04  = aws_ttsrv_getRecordField(l_node2,"sgm04")
            # 良品转入
            let g_sgm.sgm301 = aws_ttsrv_getRecordField(l_node2,"sgm301")

            let l_ok = cws_create_asfi514_sfs()
            if not l_ok then
                let g_success = 'N'
                let l_return.flag = 'N'
                let l_return.msg = g_status.description
                rollback work
            end if
        end for
        if g_success = 'Y' then

            let g_prog = 'asfi514'
            call i501sub_y_upd(g_sfp01,"confirm",true)  returning l_sfp.*
            if g_success = 'N' then
                let l_return.flag = 'N'
                let l_return.msg = "审核失败"
                rollback work 
            end if
            
            call i501sub_s('1',g_sfp01,true,false)
            if g_success = 'N' then
                let l_return.flag = 'N'
                let l_return.msg = "过账失败"
                rollback work 
            end if

            let g_prog = 'aws_ttsrv2'
            if g_success = 'Y' then
                let l_return.flag = 'Y'
                let l_return.msg = g_sfp01
                commit work
            end if
        end if
        let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")
    end for
end function


# 产生倒扣料单别，并插入单头
function cws_create_asfi514_sfp01()
    define l_sql    string
    define l_sfp01  varchar(40)
    define l_chr    varchar(40)
    define l_new_no integer

    # 1. 锁表smy_file
    let l_sql = "select * from smy_file where smyslip = ? for update"
    prepare crt_asfi514_1p from l_sql
    declare crt_asfi514_1c cursor for crt_asfi514_1p

    begin work
    open crt_asfi514_1c using '105'

    # 2. 取最大编码
    let l_chr = sfmt("105-%1%2",year(today) mod 100 using '&&',month(today) using '&&') 
    let l_chr = l_chr,"%"
    select max(sfp01) into g_sfp01 from sfp_file
     where sfp01 like l_chr
    
    if cl_null(g_sfp01) then
        let l_new_no = 0
    else
        let l_new_no = cws_create_asfi514_decode(g_sfp01[9,12])
    end if
    let g_sfp01 =  sfmt("105-%1%2%3",
            year(today) mod 100 using '&&',
            month(today) using '&&',
            cws_create_asfi514_encode(l_new_no+1))

    let g_sfp.sfp01 = g_sfp01
    let g_sfp.sfp02 = g_today
    let g_sfp.sfp03 = g_postdate
    let g_sfp.sfp04 = 'N'
    let g_sfp.sfp05 = 'N'
    let g_sfp.sfp06 = '4'
    let g_sfp.sfp07 = l_grup
    let g_sfp.sfp09 = 'N'
    let g_sfp.sfpuser = l_user
    let g_sfp.sfpgrup = l_grup
    let g_sfp.sfpmodu = l_user
    let g_sfp.sfpdate = g_today
    let g_sfp.sfp11 = ' '
    let g_sfp.sfpconf = 'N'
    # let g_sfp.sfpud04 ='W020-240206M00000062'
    let g_sfp.sfpplant = g_plant
    let g_sfp.sfplegal = g_legal
    let g_sfp.sfporiu = l_user
    let g_sfp.sfporig = l_grup
    let g_sfp.sfp15 = '0'
    let g_sfp.sfp16 = l_user
    let g_sfp.sfpmksg = 'N'

    insert into sfp_file (sfp01,sfp02,sfp03,sfp04,sfp05,
        sfp06,sfp07,sfp09,sfpuser,sfpgrup,sfpmodu,
        sfpdate,sfp11,sfpconf,sfpud04,sfpplant,sfplegal,
        sfporiu,sfporig,sfp15,sfp16,sfpmksg)
     values (
        g_sfp.sfp01,g_sfp.sfp02,g_sfp.sfp03,g_sfp.sfp04,g_sfp.sfp05,
        g_sfp.sfp06,g_sfp.sfp07,g_sfp.sfp09,g_sfp.sfpuser,g_sfp.sfpgrup,g_sfp.sfpmodu,
        g_sfp.sfpdate,g_sfp.sfp11,g_sfp.sfpconf,g_sfp.sfpud04,g_sfp.sfpplant,g_sfp.sfplegal,
        g_sfp.sfporiu,g_sfp.sfporig,g_sfp.sfp15,g_sfp.sfp16,g_sfp.sfpmksg
     )

    if status then
        let g_status.code = "mfg-009"
        let g_status.description = cl_getmsg("mfg-009",g_lang)
        rollback work
        return false
    else
        return true
    end if
end function


# 将10进制转为36进制
function cws_create_asfi514_encode(p_int)
    define p_int,l_re    integer
    define l_chr    string

    if p_int = 0 then 
        return '0'
    end if

    while p_int > 0
        let l_re = p_int mod 36
        let l_chr = cws_create_asfi514_encodeDigit(l_re),l_chr
        let p_int = p_int / 36
    end while

    while l_chr.getLength() < 4
        let l_chr = '0',l_chr
    end while

    return l_chr clipped
end function

# 将36进制转为10进制
function cws_create_asfi514_decode(p_chr)
    define p_chr    string
    define l_int    integer
    define l_chr    varchar(1)
    define l_index  integer

    if cl_null(p_chr) then
        return 0
    end if

    let l_index = 0
    while not cl_null(p_chr)

        let l_chr = p_chr.getCharAt(p_chr.getLength())
        let l_int = l_int + cws_create_asfi514_decodeDigit(l_chr) *36**l_index

        let p_chr = p_chr.subString(1,p_chr.getLength()-1)
        let l_index = l_index + 1
    end while
    
    return l_int
end function


# 转换小于36的数为36进制
function cws_create_asfi514_encodeDigit(p_int)
    define p_int integer
    define l_chr varchar(1)
    if p_int < 10 then
        let l_chr = p_int
    else
        let l_chr = ASCII(65+p_int-10)
    end if
    return l_chr
end function


# 转换小于36的数为10进制数
function cws_create_asfi514_decodeDigit(p_chr)
    define l_int integer
    define p_chr varchar(1)
    if p_chr < 10 then
        let l_int = p_chr
    else
        let l_int = ORD(p_chr)-65+10
    end if
    return l_int
end function


# 建立单身，已经在事务中
function cws_create_asfi514_sfs()
    define l_ok     boolean
    define l_sfa01  like sfa_file.sfa01
    define l_cnt    integer

    call g_sfs.clear()
    let l_sfa01 = g_sgm.sgm01[1,12]

    call cs_asf_get510(l_sfa01,g_sgm.sgm04,g_sgm.sgm301) returning g_sfs,l_ok

    if not l_ok then 
        return l_ok
    end if

    for l_cnt = 1to g_sfs.getlength()
        let g_sfs[l_cnt].sfs01 = g_sfp01
        let g_sfs[l_cnt].sfs02 = g_cnt
        let g_sfs[l_cnt].sfs014 = g_sgm.sgm01
        insert into sfs_file (sfs01,sfs02,sfs03,sfs04,sfs05,sfs06,
                              sfs07,sfs08,sfs09,sfs10,sfs26,sfs27,sfs28,
                              sfs32,sfsplant,sfslegal,sfs012,sfs013,sfs014)
         values (g_sfs[l_cnt].sfs01,g_sfs[l_cnt].sfs02,g_sfs[l_cnt].sfs03,g_sfs[l_cnt].sfs04,g_sfs[l_cnt].sfs05,g_sfs[l_cnt].sfs06,
                 g_sfs[l_cnt].sfs07,g_sfs[l_cnt].sfs08,g_sfs[l_cnt].sfs09,g_sfs[l_cnt].sfs10,g_sfs[l_cnt].sfs26,g_sfs[l_cnt].sfs27,
                 g_sfs[l_cnt].sfs28,g_sfs[l_cnt].sfs32,g_sfs[l_cnt].sfsplant,g_sfs[l_cnt].sfslegal,g_sfs[l_cnt].sfs012,
                 g_sfs[l_cnt].sfs013,g_sfs[l_cnt].sfs014)
        if sqlca.sqlcode then
            let g_status.code = sqlca.sqlcode
            let g_status.description = cl_getmsg(sqlca.sqlcode,g_lang) 
            return false
        end if
        let g_cnt = g_cnt + 1
    end for
    return true
end function

 
