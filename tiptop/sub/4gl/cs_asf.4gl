# Prog. Version..: '5.30.07-13.05.20(00004)'     #
#
# Pattern name...: cs_asf.4gl
# Descriptions...: 生产相关函数
# Date & Author..: darcy:2024/05/10
 

database ds

GLOBALS "../../config/top.global"
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"
# DEFINE g_status RECORD
#     code          STRING,
#     sqlcode       STRING,
#     description   STRING
# END RECORD

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

# 根据需要需要发料的套数，产生指定作业编号，要发料的料件的明细
# 1. 判断作业编号是否含有多个料件
# 2. 判断料件是否是取替代料号
# 3. 判断库存可用数量,根据可用库存带出,根据批号先进先出带出,库存仅考虑XBC对应工作站的库存
# 4. 如果已经发满则不再继续发料
# 5. sfa28 目前替代比例都为1,不考虑不为1的情况
# param:
#   p_sfa01 工单编号
#   p_sfa08 作业编号
#   p_sfa06 需要发料的套数
# return:
#   l_sfs 返回发料明细
#   l_ok  是否失败 true成功,false失败
function cs_asf_get510(p_sfa01,p_sfa08,p_sfa06)
    define p_sfa01      like sfa_file.sfa01
    define p_sfa08      like sfa_file.sfa08
    define p_sfa06      like sfa_file.sfa06
    define l_sfs dynamic array of sfs

    define l_cnt integer

    define l_sfb record
            sfb08       like sfb_file.sfb08,
            sfb04       like sfb_file.sfb04
        end record
    define l_sfa record
        sfa03       like sfa_file.sfa03,
        sfa26       like sfa_file.sfa26,
        sfa27       like sfa_file.sfa27,
        sfa28       like sfa_file.sfa28,
        sfa12       like sfa_file.sfa12,
        sfa05       like sfa_file.sfa05,
        sfa06       like sfa_file.sfa06,
        sfa161      like sfa_file.sfa161
        end record
    define l_sfa1 record
        sfa03       like sfa_file.sfa03,
        sfa26       like sfa_file.sfa26,
        sfa27       like sfa_file.sfa27,
        sfa28       like sfa_file.sfa28,
        sfa12       like sfa_file.sfa12,
        sfa05       like sfa_file.sfa05,
        sfa06       like sfa_file.sfa06,
        sfa012      like sfa_file.sfa012,
        sfa013      like sfa_file.sfa013
        end record
    define l_img record
        img01       like img_file.img01,
        img02       like img_file.img02,
        img03       like img_file.img03,
        img04       like img_file.img04,
        img09       like img_file.img09,
        img10       like img_file.img10
        end record
    define l_sql        string
    define l_ok         boolean
    define l_sfa06      like sfa_file.sfa06
    define l_qty,l_qty_img,l_qty_avl,l_qty_img1        like sfa_file.sfa06
    define l_factor     decimal(26,10)
    define l_ecd07      like ecd_file.ecd07

    call l_sfs.clear()

    # 获得工单单头必要资料
    select sfb08,sfb04 into l_sfb.sfb08,l_sfb.sfb04
      from sfb_file where sfb01 = p_sfa01
    if sqlca.sqlcode then
        let g_status.code = sqlca.sqlcode
        let g_status.sqlcode = sqlca.sqlcode
        let g_status.description = cl_getmsg(sqlca.sqlcode,g_lang)
        return l_sfs,false
    end if
    if l_sfb.sfb04 ='8' then
        let g_status.code = 'asf-345'
        let g_status.description = cl_getmsg('asf-345',g_lang)
        return l_sfs,false
    end if

    # 获得工作站资料
    select ecd07 into l_ecd07 from ecd_file
     where ecd01 = p_sfa08
    if sqlca.sqlcode then
        let g_status.code = sqlca.sqlcode
        let g_status.sqlcode = sqlca.sqlcode
        let g_status.description = "作业编号:",p_sfa08,"-",cl_getmsg(sqlca.sqlcode,g_lang)
        return l_sfs,false
    end if

    # 遍历所有的料号,只需要原始料号
    let l_sql = "select sfa03,sfa26,sfa27,sfa28,sfa12,sfa05,sfa06,sfa161",
                "  from sfa_file ",
                "  where sfa01 =? and sfa08 = ? and sfa03 = sfa27"
    prepare cs_asf_p1 from l_sql
    declare cs_asf_cur1 cursor for cs_asf_p1

    # 料号已发数量
    # cs_asf_getsfa06()
    
    # 遍历库存可用量,库存仅考虑XBC对应工作站的库存
    let l_sql = "select img01,img02,img03,img04,img09,img10",
                "  from img_file ",
                " where img01 = ? and img02 ='XBC' and img03 = ? ",
                "   and img10 > 0 and img18 >= ? ",
                " order by substr(img04,1,8)"
    prepare cs_asf_p3 from l_sql
    declare cs_asf_cur3 cursor for cs_asf_p3

    let l_cnt = 1
    # 原始料号处理
    foreach cs_asf_cur1 using p_sfa01,p_sfa08 into l_sfa.*
        if sqlca.sqlcode then
            let g_status.code = sqlca.sqlcode
            let g_status.sqlcode = sqlca.sqlcode
            let g_status.description = 'cs_asf_cur1:',cl_getmsg(sqlca.sqlcode,g_lang)
            return l_sfs,false
        end if
        # 获得本作业编号需发数量
        let l_qty = s_digqty( p_sfa06 * l_sfa.sfa161 , l_sfa.sfa12 )  # 料号需发数量
        # let l_qty = l_sfa.sfa05 - l_sfa06 

        if l_qty <= 0 then
            # 已经发完，不需要再处理,处理下一个料件
            continue foreach
        end if

        # 遍历取替代料号 s---
        let l_sql = "select sfa03,sfa26,sfa27,sfa28,sfa12,sfa05,sfa06,sfa012,sfa013",
                    "  from sfa_file where sfa01 = ? and sfa08 = ? and sfa27 =? "
        # 如果是取代，优先取代前料号
        # 如果是替代，优先替代后料号
        # 其它取替代方式暂未考虑,因为系统暂未使用
        if l_sfa.sfa26 = '4' then
            let l_sql = l_sql , " order by sfa26 desc,sfa03"
        else
            let l_sql = l_sql , " order by sfa26,sfa03"
        end if
        prepare cs_asf_p4 from l_sql
        declare cs_asf_cur4 cursor for cs_asf_p4
        foreach cs_asf_cur4 using p_sfa01,p_sfa08,l_sfa.sfa03 into l_sfa1.*
            if sqlca.sqlcode then
                let g_status.code = sqlca.sqlcode
                let g_status.sqlcode = sqlca.sqlcode
                let g_status.description = 'cs_asf_cur4:',cl_getmsg(sqlca.sqlcode,g_lang)
                return l_sfs,false
            end if
            # 已经发完，不需要再处理,处理下一个料件
            if l_qty <= 0 then
                exit foreach
            end if
            # 获得已发数量
            call cs_asf_getsfa06(p_sfa01,l_sfa1.sfa03,l_sfa1.sfa27,p_sfa08,l_sfa1.sfa12) returning l_sfa06,l_ok
            if not l_ok then
                return l_sfs,false
            end if
            # 本个料号已经发完,处理下个料号
            if l_sfa06 >= l_sfa1.sfa05 then
                continue foreach
            end if

            # 本料号可发数量
            let l_qty_avl = l_sfa1.sfa05 - l_sfa06
            # 遍历可用库存 s---
            foreach cs_asf_cur3 using l_sfa1.sfa03,l_ecd07,g_today into l_img.*
                if sqlca.sqlcode then
                    let g_status.code = sqlca.sqlcode
                    let g_status.sqlcode = sqlca.sqlcode
                    let g_status.description = 'cs_asf_cur4:',cl_getmsg(sqlca.sqlcode,g_lang)
                    return l_sfs,false
                end if

                # 已经发完，不需要再处理,处理下一个料件
                if l_qty <= 0 then
                    exit foreach
                end if

                # 本个料号已经发完,处理下个料号
                if l_sfa06 >= l_sfa1.sfa05 then
                    continue foreach
                end if 

                # 将库存数量转为发料单位
                if l_img.img09 != l_sfa1.sfa12 then
                    call s_umfchk(l_sfa1.sfa03,l_img.img09,l_sfa1.sfa12) returning l_ok,l_factor
                    if l_ok then
                        let g_status.code = 'asf-816'
                        let g_status.description = sfmt('库存单位:%1发料单位%2-',l_img.img09,l_sfa1.sfa12),cl_getmsg('asf-816',g_lang)
                        return l_sfs,false
                    end if
                    let l_img.img10 = s_digqty(l_img.img10*l_factor ,l_sfa1.sfa12)
                end if

                # 本次发料数量,是库存数量,本料号可发数量和本作业编号可发数量中最少的一个
                let l_qty_img = iif(l_qty_avl>l_qty,l_qty,l_qty_avl)
                let l_qty_img = iif(l_img.img10 > l_qty_img,l_qty_img,l_img.img10 )
                
                # 如果发料单位g，且库存单位为kg，则将发料数量变为整数g
                # 如果是最后一次发料,即当前数量=料件可发数量的时候,不用整数
                # 如果当前仓储批库存不够,也不用整数
                # 此逻辑是防止g与kg转换时,发生精度换算问题
                if l_img.img09 = 'KG' and l_sfa1.sfa12='G' then
                    if not (l_img.img10 <= l_qty_img or l_qty_avl <= l_qty_img)then
                        let l_qty_img1 = l_qty_img
                        let l_qty_img = s_digqty(l_qty_img ,'PCS')
                        # 取整后,还需要和库存和本料可发数量中做比较,大于任何一个值,就不再取整数
                        if l_qty_img > l_img.img10 or l_qty_img > l_qty_avl then
                            let l_qty_img = l_qty_img1
                        end if
                    end if 
                end if
                
                # l_qty_img 本次要发的库存数量
                # 产生发料明细
                let l_sfs[l_cnt].sfs01 = 'xx'
                let l_sfs[l_cnt].sfs02 = l_cnt
                let l_sfs[l_cnt].sfs03 = p_sfa01
                let l_sfs[l_cnt].sfs04 = l_sfa1.sfa03
                let l_sfs[l_cnt].sfs05 = l_qty_img
                let l_sfs[l_cnt].sfs06 = l_sfa1.sfa12
                let l_sfs[l_cnt].sfs07 = l_img.img02
                let l_sfs[l_cnt].sfs08 = l_img.img03
                let l_sfs[l_cnt].sfs09 = l_img.img04
                let l_sfs[l_cnt].sfs10 = p_sfa08
                let l_sfs[l_cnt].sfs26 = l_sfa1.sfa26
                let l_sfs[l_cnt].sfs27 = l_sfa1.sfa27
                let l_sfs[l_cnt].sfs28 = l_sfa1.sfa28
                let l_sfs[l_cnt].sfsplant = g_plant
                let l_sfs[l_cnt].sfslegal = g_legal
                let l_sfs[l_cnt].sfs012 = l_sfa1.sfa012
                let l_sfs[l_cnt].sfs013 = l_sfa1.sfa013

                let l_cnt = l_cnt + 1 # 项次流水码+1
                # 需要发料套数减少
                let l_qty = l_qty - l_qty_img
                # 已发数量增加
                let l_sfa06 = l_sfa06 + l_qty_img
            end foreach
            # 遍历可用库存 e---
            # 库存不足检查
            # 如果本次料号有未发数量,但是需发送数量还是大于0,则是库存不足
            if l_qty > 0 then
                let g_status.code = 'atm-030'
                let g_status.description = sfmt('料件:%1库位:%2缺少数量:%3-',l_sfa1.sfa03,l_ecd07,iif(l_qty_avl>l_qty,l_qty,l_qty_avl)),cl_getmsg('atm-030',g_lang)
                return l_sfs,false
            end if
        end foreach
        free cs_asf_cur4
        # 遍历取替代料号 e---
    end foreach
    return l_sfs,true
end function

# 获取工单某一个料号的已发数量
# 已考虑不同单位情况
# 最终数量换算为sfa12单位
# param:
#   p_sfa01 工单编号
#   p_sfa03 发料料号
#   p_sfa27 bom料号
#   p_sfa08 作业编号
#   p_sfa12 发料单位
# return:
#   l_sum 数量
#   l_ok  false无此料号
function cs_asf_getsfa06(p_sfa01,p_sfa03,p_sfa27,p_sfa08,p_sfa12)
    define  p_sfa01     like sfa_file.sfa01,
            p_sfa03     like sfa_file.sfa03,
            p_sfa27     like sfa_file.sfa27,
            p_sfa08     like sfa_file.sfa08,
            p_sfa12     like sfa_file.sfa12

    define  l_sum       like sfa_file.sfa062

    define l_sql        string
    define l_sfe16      like sfe_file.sfe16,
           l_sfe17      like sfe_file.sfe17
    define l_factor     like type_file.num26_10
    define l_ok         boolean
    define l_ecd07      like ecd_file.ecd07

    let l_sql = "select sum(case smykind when '3' then sfe16 when '4' then -sfe16 end) sfe16,sfe17 ",
                "  from sfe_file left join smy_file on smyslip = substr(sfe02, 0, 3) ",
                " where sfe01 = ? and sfe07 = ? and sfe27 = ? and sfe14 = ?",
                " group by  sfe17"
    prepare cs_asf_p2 from l_sql
    declare cs_asf_cur2 cursor for cs_asf_p2

    let l_sum = 0

    foreach cs_asf_cur2 using p_sfa01,p_sfa03,p_sfa27,p_sfa08
                         into l_sfe16,l_sfe17
        if sqlca.sqlcode then
            let g_status.code = sqlca.sqlcode
            let g_status.sqlcode = sqlca.sqlcode
            let g_status.description = cl_getmsg(sqlca.sqlcode,g_lang)
            return 0,false
        end if
        # 单位不同需要换算数量
        if p_sfa12 <> l_sfe17 then
            call s_umfchk(p_sfa03,l_sfe17,p_sfa12) returning l_ok,l_factor
            if l_ok then
                let l_sfe16 = s_digqty( l_sfe16*l_factor ,p_sfa12)
            end if
        end if
        let l_sum = l_sum + l_sfe16
    end foreach 

    return l_sum,true
end function


# 产生当站下线BOM
# 1.下线的作业编号，和前面的作业编号的料号将会组成中间BOM
# 2.下线的料号参考原BOM，下线的用量直接取工单用量
# 3. 如果料号已存在，则将所有旧资料失效，覆盖旧资料
# 使用时要在事务外调用s_cbmp600_crt_temp()
# param:
#   p_sfa01:工单编号
#   p_sfa08:下线的作业编号
#   p_inTransaction: 是否在事务中
# return:
#   l_bma01: 主键料号
function cs_asf_gen_offine(p_sfa01,p_sfa08,p_inTransaction)
    define p_sfa01  like sfa_file.sfa01,
           p_sfa08  like sfa_file.sfa08,
           p_inTransaction  boolean
    define l_bma01  like bma_file.bma01,
           l_ok     boolean

    define l_sql    string
    define l_sfb04  like sfb_file.sfb04
    define l_sfb05  like sfb_file.sfb05
    define l_bma10  like bma_file.bma10
    
    select sfb05,sfb04 into l_sfb05,l_sfb04
      from sfb_file where sfb01 = p_sfa01
    
    if l_sfb04 = '8' then
        return '',false
    end if
    if LENGTH(l_sfb05) != 10 then
        return '',false
    end if
    let l_bma01 = l_sfb05[1,9],'T'

    # 开启事务
    if not p_inTransaction then
        begin work
    end if

    let l_bma10 = ''
    select bma10 into l_bma10 from bma_file
     where bma01 = l_bma01
    if cl_null(l_bma10) then
        # 未查询到资料
        if not cs_asf_aimi100(l_sfb05,l_bma01) then
            let g_success = 'N'
            goto _error
        end if
        # darcy:2024/07/04 add s---
        # 默认仓库
        update ima_file set ima35 ='D-BCP' ,ima36 = 'DDDZ'
         where ima01 = l_bma01
        # darcy:2024/07/04 add e---
        # 直接新建BOM资料
        if not cs_asf_crt_bom(p_sfa01,p_sfa08,l_bma01) then
            let g_success = 'N'
            goto _error
        end if
    else
        if l_bma10 = '0' then
            # 未审核资料直接删除
            delete from bma_file where bma01 = l_bma01
            delete from bmb_file where bmb01 = l_bma01
            # 然后新建BOM资料
            if not cs_asf_crt_bom(p_sfa01,p_sfa08,l_bma01) then
                let g_success = 'N'
                goto _error
            end if
        end if
        if l_bma10 = '1' or l_bma10 = '2' then
            # 需要做变更单
            if not cs_asf_abmi720(p_sfa01,p_sfa08,l_bma01) then
                let g_success = 'N'
                goto _error
            end if
        end if
    end if

    label _error:
    if not p_inTransaction then
        if g_success = 'Y' then
            commit work
        else
            rollback work
        end if
    end if

    return l_bma01,g_success = 'Y'
end function

# 建立料号
function cs_asf_aimi100(p_sfb05,p_ima01)
    define p_sfb05  like sfb_file.sfb05
    define p_ima01  like ima_file.ima01
    define l_cnt    integer
    define l_ima    record like ima_file.*

    select count(*) into l_cnt from ima_file 
     where ima01 = p_ima01 and ima1010 ='1'
    if l_cnt > 0 then
        return true
    end if

    select * into l_ima.* from ima_file
     where ima01 = p_sfb05
    let l_ima.ima01 = p_ima01

    insert into ima_file values l_ima.*
    if sqlca.sqlcode then
        call cl_err("ins ima_file",sqlca.sqlcode,1)
        return false
    end if
    return true
end function

# 直接新建BOM
function cs_asf_crt_bom(p_sfa01,p_sfa08,p_ima01)
    define p_sfa01  like sfa_file.sfa01,
           p_sfa08  like sfa_file.sfa08,
           p_ima01  like ima_file.ima01
    define l_bma    record like bma_file.*
    define l_bmb    record like bmb_file.*
    define l_sql    string
    define l_ima25  like ima_file.ima25,
           l_ima86  like ima_file.ima86
    define l_ok     boolean
    define l_ecm03  like ecm_file.ecm03
    

    # 单头资料插入
    initialize l_bma.* to null
    let l_bma.bma01 = p_ima01
    let l_bma.bma05 = g_today
    let l_bma.bmauser = g_user
    let l_bma.bmagrup = g_grup
    let l_bma.bmamodu = g_user
    let l_bma.bmadate = g_today
    let l_bma.bmaacti = 'Y'
    let l_bma.bma06 = ' '
    let l_bma.bma08 = g_plant
    let l_bma.bma09 = 0
    let l_bma.bma10 = '0'
    let l_bma.bmaoriu = g_user
    let l_bma.bmaorig = g_grup
    
    insert into bma_file values l_bma.*
    if sqlca.sqlcode then
        call cl_err("ins bma_file",sqlca.sqlcode,1)
        return false
    end if

    # 查询下线的部署
    let l_ecm03 = 0
    select max(ecm03) into l_ecm03 from ecm_file
     where ecm01 = p_sfa01 and ecm04 = p_sfa08

    if l_ecm03 = 0 or cl_null(l_ecm03) then
        call cl_err('不存在此作业编号，或工单未走工艺','!',1)
        return false
    end if

    initialize l_bmb.* to null
    
    let l_sql = "select '",p_ima01,"' bmb01,rownum bmb02,sfa03 bmb03,trunc(sysdate) bmb04,'' bmb05,sfa05/sfb08 bmb06,1 bmb07, ",
                " 0 bmb08,sfa08 bmb09,sfa12 bmb10,1 bmb10_fac,1 bmb10_fac2,'' bmb11,' ' bmb13,0 bmb14,'N' bmb15,'0' bmb16, ",
                " 'N' bmb17,0 bmb18,'1' bmb19, '' bmb20, '' bmb21, '' bmb22, 100 bmb23, '' bmb24, '' bmb25, '' bmb26, ",
                " 'N' bmb27,0 bmb28, '",g_user,"' bmbmodu, trunc(sysdate) bmbdate,'abmi600' bmbcomm, ' ' bmb29,' 'bmb30, ",
                " 'N' bmb31, 0 bmb33, '' bmbud01,'' bmbud02,'' bmbud03,'' bmbud04,'' bmbud05, '' bmbud06,'' bmbud07, '' bmbud08, ",
                " '' bmbud09,'' bmbud10,'' bmbud11 ,'' bmbud12,'' bmbud13,'' bmbud14, '' bmbud15, 0 bmb081,1 bmb082,'' bmb36,'' bmb37 ",
                " from sfa_file,ecm_file,sfb_file where ecm01 =sfa01 and ecm04 = sfa08 and sfa01=sfb01 and sfa05 >0 ",
                " and sfa01 = ? and ecm03 <= ? "
    prepare cs_asf_p5 from l_sql
    declare cs_asf_cur5 cursor for cs_asf_p5

    foreach cs_asf_cur5 using p_sfa01,l_ecm03 into l_bmb.*
        if sqlca.sqlcode then
            call cl_err("cs_asf_cur5",sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
        end if
        select ima25,ima86 into l_ima25,l_ima86 from ima_file
         where ima01 = l_bmb.bmb03
        if l_bmb.bmb10 <> l_ima25 then
            # 库存单位换算率
            call s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_ima25) returning l_ok,l_bmb.bmb10_fac
            if l_ok then
                call cl_err(l_bmb.bmb10||"/"||l_ima25,"abm-731",1)
                return false
            end if
        end if
        if l_bmb.bmb10 <> l_ima86 then
            # 成本单位换算率
            call s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_ima86) returning l_ok,l_bmb.bmb10_fac2
            if l_ok then
                call cl_err(l_bmb.bmb10||"/"||l_ima86,"abm-731",1)
                return false
            end if
        end if

        # 工单开立
        let l_bmb.bmb19 = iif(l_bmb.bmb03 matches '*.*','1','2')
        # 消耗性料件否
        select ima70 into l_bmb.bmb15 from ima_file
         where ima01 = l_bmb.bmb03

        insert into bmb_file values l_bmb.*
        if sqlca.sqlcode then
            call cl_err("ins bmb_file",sqlca.sqlcode,1)
            return false
        end if
    end foreach
    call s_showmsg_init()
    # 审核 # 发放
    call s_cbmp600(" 1=1 AND bma01 ='"||p_ima01||"' AND bma06 =' '",true)
    if g_success ='N' then
        call s_showmsg()
        return false
    end if
    return true
end function

# 产生变更单
function cs_asf_abmi720(p_sfa01,p_sfa08,p_ima01)
    define p_sfa01  like sfa_file.sfa01,
           p_sfa08  like sfa_file.sfa08,
           p_ima01  like ima_file.ima01
    define l_bmx    record like bmx_file.*
    define l_bmy    record like bmy_file.*
    define l_prog   varchar(40)

    initialize l_bmx.* to null

    let l_bmx.bmx01 = "DRA"
    let l_bmx.bmx02  = g_today
    let l_bmx.bmx05  = sfmt("%1:%2",p_sfa01,p_sfa08)
    let l_bmx.bmx07  = g_today
    let l_bmx.bmx04  = 'N'
    let l_bmx.bmx06  = '2'
    let l_bmx.bmx11 = g_plant
    let l_bmx.bmxuser = g_user
    let l_bmx.bmxoriu = g_user
    let l_bmx.bmxorig = g_grup
    let l_bmx.bmxgrup = g_grup
    let l_bmx.bmxdate = g_today
    let l_bmx.bmxacti= 'Y'
    let l_bmx.bmx09 = '0'
    let l_bmx.bmx10 = g_user
    let l_bmx.bmxplant = g_plant
    let l_bmx.bmxlegal = g_legal
    let l_bmx.bmx13 = g_grup
    let l_bmx.bmx50 = '1'

    call s_auto_assign_no("abm",l_bmx.bmx01,l_bmx.bmx02,"1","bmx_file","bmx01","","","")
        returning g_success,l_bmx.bmx01
    if g_success ='N' then
        return false
    end if
    insert into bmx_file values (l_bmx.*)
    if sqlca.sqlcode or sqlca.sqlerrd[3]=0 then
        call cl_err('ins bmx: ',sqlca.sqlcode,1)  
        return false
    end if

    # 处理单身
    if not cs_asf_bmy_void(l_bmx.bmx01,p_ima01) then
        return false
    end if
    if not cs_asf_bmy_ins(l_bmx.bmx01,p_ima01,p_sfa01,p_sfa08) then
        return false
    end if
    # 审核发放
    # 用aws_ttsrv2避免重复开启事务
    let l_prog = g_prog
    let g_prog = 'aws_ttsrv2'
    let g_success = "Y"
    call i720sub_y_chk(l_bmx.bmx01) 
    if g_success = "Y" then
        call i720sub_y_upd(l_bmx.bmx01,'Y')
    end if
    let g_prog = l_prog
    if g_success = 'N' then
        return false
    end if
    return true
end function

# 失效已有单身
function cs_asf_bmy_void(p_bmx01,p_bma01)
    define p_bmx01      like bmx_file.bmx01
    define p_bma01      like bma_file.bma01
    define l_sql        string

    let l_sql = "insert into bmy_file select ",
                " '",p_bmx01,"' bmy01,rownum bmy02,'1' bmy03,bmb02 bmy04,bmb03 bmy05,bmb06 bmy06,bmb07 bmy07, ",
                " bmb08 bmy08,bmb09 bmy09,bmb10 bmy10,bmb10_fac bmy10_fac,bmb10_fac2 bmy10_fac2,'' bmy11, ",
                " ' 'bmy13,bmb01 bmy14,bmb15 bmy15,bmb16 bmy16,'' bmy17,'' bmy171,0 bmy18,'' bmy19,bmb19 bmy20,bmb15 bmy21, ",
                " '' bmy22,0 bmy23,' 'bmy25,' 'bmy26,'' bmy27,' ' bmy29,' 'bmy30,0bmy33,'N'bmy33, ",
                " '",g_plant,"' bmyplant,'",g_legal,"' bmylegal,' 'bmy011,' ' bmy012,0bmy013,bmb081 bmy081,bmb082 bmy082, ",
                " 0 bmy35,''bmy36,''bmy361,''bmy37,''ta_bmy01,''ta_bmy02,''ta_bmy03,''ta_bmy04,''ta_bmy05,''ta_bmy06 ",
                " from bmb_file where bmb01 ='",p_bma01,"' ",
                " and bmb04 <=trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate)) "
    prepare cs_asf_p6 from l_sql 
    execute cs_asf_p6 
    if sqlca.sqlcode or sqlca.sqlerrd[3]=0 then
        call cl_err('ins bmy: ',sqlca.sqlcode,1)  
        return false
    end if
    return true
end function

# 插入生效单身
function cs_asf_bmy_ins(p_bmx01,p_bma01,p_sfa01,p_sfa08)
    define p_bmx01      like bmx_file.bmx01,
           p_bma01      like bma_file.bma01,
           p_sfa01      like sfa_file.sfa01,
           p_sfa08      like sfa_file.sfa08
    define l_ecm03      like ecm_file.ecm03
    define l_sql        string
    define l_bmy02      like bmy_file.bmy02
    define l_ok         boolean
    define l_ima25      like ima_file.ima25
    define l_ima86      like ima_file.ima86
    define l_bmy        record like bmy_file.*
    define l_bmb02      like bmb_file.bmb02

    select max(bmy02) into l_bmy02 from bmy_file 
     where bmy01 = p_bmx01
    if cl_null(l_bmy02) then
        let l_bmy02 = 0
    end if

    # 查询下线的步数
    let l_ecm03 = 0
    select max(ecm03) into l_ecm03 from ecm_file
     where ecm01 = p_sfa01 and ecm04 = p_sfa08

    if l_ecm03 = 0 or cl_null(l_ecm03) then
        call cl_err('不存在此作业编号，或工单未走工艺','!',1)
        return false
    end if

    # 开始的BOM项次
    select max(bmb02) into l_bmb02 from bmb_file
     where bmb01 = p_bma01
    if cl_null(l_bmb02) then
        let l_bmb02 = 0
    end if

    let l_sql = "select ",
                " '",p_bmx01,"' bmy01,rownum+",l_bmy02," bmy02,'2' bmy03,(rownum+",l_bmb02,") bmy04,sfa03 bmy05,sfa05/sfb08 bmb06,1 bmy07, ",
                " 0 bmy08,sfa08 bmy09,sfa12 bmy10,1 bmy10_fac,1 bmy10_fac2,'' bmy11, ",
                " ' 'bmy13,'",p_bma01,"' bmy14,'N' bmy15,'0' bmy16,'' bmy17,'' bmy171,0 bmy18,'' bmy19,'1' bmy20,'N' bmy21, ",
                " '' bmy22,0 bmy23,' 'bmy25,' 'bmy26,'' bmy27,' ' bmy29,' 'bmy30,0bmy33,'N'bmy33, ",
                " '",g_plant,"' bmyplant,'",g_legal,"' bmylegal,' 'bmy011,' ' bmy012,0bmy013,0 bmy081,1 bmy082, ",
                " 0 bmy35,''bmy36,''bmy361,''bmy37,''ta_bmy01,''ta_bmy02,''ta_bmy03,''ta_bmy04,''ta_bmy05,''ta_bmy06 ",
                " from sfa_file,ecm_file,sfb_file where ecm01 =sfa01 and ecm04 = sfa08 and sfa01=sfb01 and sfa05 >0 ",
                " and sfa01 =? and ecm03 <=? "
    prepare cs_asf_p7 from l_sql
    declare cs_asf_cur7 cursor for cs_asf_p7

    foreach cs_asf_cur7 using p_sfa01,l_ecm03 into l_bmy.*
        if sqlca.sqlcode then
            call cl_err("cs_asf_cur7",sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
        end if
        select ima25,ima86 into l_ima25,l_ima86 from ima_file
         where ima01 = l_bmy.bmy05
        if l_bmy.bmy10 <> l_ima25 then
            # 库存单位换算率
            call s_umfchk(l_bmy.bmy05,l_bmy.bmy10,l_ima25) returning l_ok,l_bmy.bmy10_fac
            if l_ok then
                call cl_err(l_bmy.bmy10||"/"||l_ima25,"abm-731",1)
                return false
            end if
        end if
        if l_bmy.bmy10 <> l_ima86 then
            # 成本单位换算率
            call s_umfchk(l_bmy.bmy05,l_bmy.bmy10,l_ima86) returning l_ok,l_bmy.bmy10_fac2
            if l_ok then
                call cl_err(l_bmy.bmy10||"/"||l_ima86,"abm-731",1)
                return false
            end if
        end if

        # 工单开立
        let l_bmy.bmy20 = iif(l_bmy.bmy05 matches '*.*','1','2')
        # 消耗性料件否
        select ima70 into l_bmy.bmy21 from ima_file
         where ima01 = l_bmy.bmy05

        insert into bmy_file values l_bmy.*
        if sqlca.sqlcode then
            call cl_err("ins bmy_file",sqlca.sqlcode,1)
            return false
        end if
    end foreach 
    return g_success = '1'
end function

# 工单最后一次入库检查
# 检查工单是否有待报废的报工资料
function cs_asf_last_in_chk(p_sfu01)
    define p_sfu01      like sfu_file.sfu01
    define l_sql        string
    define l_ok,l_flag         boolean
    define l_ret dynamic array of record
        sfb01   like sfb_file.sfb01,
        sfb12   like sfb_file.sfb12
    end record
    define l_sfb01      like sfb_file.sfb01
    define l_wip        like sfb_file.sfb12
    define l_i          integer
    define l_postdate   date
    define l_sfe02      like sfe_file.sfe02,
           l_sfe04      like sfe_file.sfe04
    define l_sgm313     like sgm_file.sgm313
    define l_sfv09      like sfv_file.sfv09
    define l_sfv091     like sfv_file.sfv09
    define l_sfb08      like sfb_file.sfb08
    

    select sfu02 into l_postdate from sfu_file where sfu01 = p_sfu01

    call s_showmsg_init() 
    let g_success ='Y'
    # 工单在制数量查询
    let l_sql = "with sgm_t1 as
                (select sgm01,sgm02,sgm03,sgm65,sgm301,sgm311,sgm313,sgm314,
                        sum(sgm314) OVER(partition by sgm01 order by sgm03) sgm314s,
                        sum(sgm313) OVER(partition by sgm01 order by sgm03) sgm313s
                    from sgm_file,
                        (select unique sfv11 sfb01 from sfv_file
                          where sfv01 = '",p_sfu01,"' ) sub_query
                where sgm02 = sub_query.sfb01 order by sgm01, sgm03),
                sgm_t2 as (select sgm01,sgm02,sgm03,sgm65,sgm301,
                        sgm311,sgm313,sgm314,sgm314s - sgm314 sgm314s,sgm313s - sgm313 sgm313s
                    from sgm_t1),
                sgm_t3 as (select sgm01,sgm02,sgm03,sgm65 - sgm314s - sgm313s sgm65,
                        sgm301,sgm311,sgm313,sgm314,sgm314s,sgm313s
                    from sgm_t2),
                sgm_t4 as (select sgm01,sgm02,sgm03,sgm65,sgm301,sgm311,
                                  sgm313,sgm314,sgm313s,sgm314s,
                                  least(sgm65, sgm301) - sgm311 - sgm313 sgmwip
                    from sgm_t3)
                select unique sfv11, nvl(sgmwip, 0) sgmwip
                from sfv_file
                left join (select sgm02, sum(sgmwip) sgmwip
                            from sgm_t4
                            where sgmwip > 0
                            group by sgm02)
                    on sgm02 = sfv11
                where sfv01 = '",p_sfu01,"' "
    prepare cs_asf_p8 from l_sql
    declare cs_asf_cur8 cursor for cs_asf_p8

    # 发退料日期
    let l_sql = "select sfe02, sfe04
                   from sfe_file, (select '",l_postdate,"' postdate from dual)
                  where sfe01 = ? 
                    and ((year(sfe04) = year(postdate) and month(sfe04) > month(postdate)) or
                        (year(sfe04) > year(postdate))) order by sfe04,sfe02"
    prepare cs_asf_p10 from l_sql
    declare cs_asf_cur10 cursor for cs_asf_p10

    # 报工日期
    let l_sql = "select shb01,shb03 
                   from shb_file,(select '",l_postdate,"' postdate from dual)
                  where shb05 = ? 
                    and ((year(shb03) = year(postdate) and month(shb03) > month(postdate)) or
                        (year(shb03) > year(postdate)))"
    prepare cs_asf_p11 from l_sql
    declare cs_asf_cur11 cursor for cs_asf_p11


    # 待报废查询
    declare cs_asf_cur9 cursor for 
        select unique sfv11 from sfv_file where sfv01 = p_sfu01
    let l_sql = ""
    foreach cs_asf_cur9 into l_sfb01
        if sqlca.sqlcode then
            call cl_err("cs_asf_cur9",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_sql = l_sql,l_sfb01,","
    end foreach
    let l_sql = l_sql.subString(1,l_sql.getLength()-1)

    call l_ret.clear()
    call GetWaitScrapR(l_sql) returning l_ok,l_ret

    # 是否是最后一次入库
    let l_flag = false  # 是否是最后一次入库
    foreach cs_asf_cur8 into l_sfb01,l_wip
        if sqlca.sqlcode then
            call cl_err("cs_asf_cur8",sqlca.sqlcode,1)
            exit foreach
        end if

        let l_sfv09 = 0
        select sum(sfv09) into l_sfv09 from sfv_file,sfu_file
         where sfv01=sfu01 and sfv11=l_sfb01 and sfupost='Y' and sfu01 <> p_sfu01
        if cl_null(l_sfv09) then let l_sfv09 = 0 end if

        let l_sfv091 = 0
        select sum(sfv09) into l_sfv091 from sfv_file
         where sfv01=p_sfu01 and sfv11=l_sfb01
        if cl_null(l_sfv091) then let l_sfv091 = 0 end if
    
        let l_sgm313 = 0
        select sum(sgm313) into l_sgm313 from sgm_file
         where sgm02 = l_sfb01
        if cl_null(l_sgm313) then let l_sgm313 = 0 end if

        let l_sfb08 = 0
        select sfb08 into l_sfb08 from sfb_file
         where sfb01 = l_sfb01
        if cl_null(l_sfb08) then let l_sfb08 = 0 end if

        if cl_null(l_wip) or l_wip = 0 then
            # 还需要判断剩余入库数量也为0
            if l_sfb08 <= l_sfv09 + l_sfv091 + l_sgm313 then
                let l_flag = true
                goto jump_wip
            end if
        end if
        # 检查在制数量是否都是待报废
        # CALL s_errmsg(field,date,msg,'mfg0301',1)
        for l_i = 1 to l_ret.getLength()
            if l_ret[l_i].sfb01 = l_sfb01 then
                if l_ret[l_i].sfb12 >= l_wip then
                    let l_flag = true
                    call s_errmsg("sfb01,sfb12",sfmt("%1|%2",l_sfb01,l_ret[l_i].sfb12),"",'csf-124',1)
                    let g_success ='N'
                end if
            end if
        end for

        label jump_wip:
        if l_flag then
            # 检查发退料是否在入库月份中
            foreach cs_asf_cur10 using l_sfb01 into l_sfe02,l_sfe04
                if sqlca.sqlcode then
                    let g_success ='N'
                    call cl_err("cs_asf_cur10",sqlca.sqlcode,1)
                    exit foreach
                end if
                call s_errmsg("sfb01,sfe02,sfe03",sfmt("%1|%2|%3",l_sfb01,l_sfe02,l_sfe04),"",'csf-125',1)
                let g_success ='N'
            end foreach
            # 检查报工日期是否在入库月份中
            foreach cs_asf_cur11 using l_sfb01 into l_sfe02,l_sfe04
                if sqlca.sqlcode then
                    let g_success ='N'
                    call cl_err("cs_asf_cur11",sqlca.sqlcode,1)
                    exit foreach
                end if
                call s_errmsg("sfb01,shb01,shb03",sfmt("%1|%2|%3",l_sfb01,l_sfe02,l_sfe04),"",'csf-126',1)
                    let g_success ='N'
            end foreach
        end if
    end foreach
    call s_showmsg() 
end function
