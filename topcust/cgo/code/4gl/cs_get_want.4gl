# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cs_get_want.4gl
# Descriptions...: 获取料件应发数量和已发数量
# Date & Author..:darcy:2023/05/09

database ds
globals "../../../tiptop/config/top.global"
# 取替代情况,只传入 3,4即可,
function cs_get_want(
    p_sfa01,
    p_sfa03,
    p_sfa08,
    p_sfa12,
    p_sfa26,
    p_sfa27,
    p_in        --需要再开工数量,或者再入库数量
)
    define p_sfa01 like sfa_file.sfa01,
           p_sfa03 like sfa_file.sfa03,
           p_sfa08 like sfa_file.sfa08,
           p_sfa12 like sfa_file.sfa12,
           p_sfa26 like sfa_file.sfa26,
           p_sfa27 like sfa_file.sfa27
    define p_in         like type_file.num15_3 -- 需开工数量

    define l_want,l_got like type_file.num20_6
    define l_sql        string
    define l_sgm03      like sgm_file.sgm03
    define l_tc_shb12,l_tsc05   like tc_shb_file.tc_shb12
    define l_sfa161     like sfa_file.sfa161
    define l_gfe03      like gfe_file.gfe03
    
    #1.查询序号
    select unique sgm03 into l_sgm03 from sgm_file where sgm02 = p_sfa01 and sgm04=p_sfa08
    if sqlca.sqlcode then
        let g_success = 'N'
        return
    end if
    #2 开工数量
    let l_tc_shb12 = 0
    select sum(tc_shb12) into l_tc_shb12 from tc_shb_file
     where tc_shb04 =p_sfa01 and tc_shb08 =p_sfa08
       and tc_shb01 ='1'
    if sqlca.sqlcode then
        let g_success = 'N'
        return
    end if
    if cl_null(l_tc_shb12) then
        let l_tc_shb12 = 0
    end if
    #3 下线数量
    let l_tsc05 = 0
    select sum(tsc05) into l_tsc05 from tsc_file,shb_file
     where tsc14 like p_sfa01||"%"
       and tscud02 = shb01 and shb06 >=l_sgm03
    if cl_null(l_tsc05) then
        let l_tsc05 = 0
    end if
    
    # 4 QBA查询
    select sfa161 into l_sfa161 from sfa_file where sfa01 =p_sfa01 and sfa03 = p_sfa03
       and sfa08 = p_sfa08 and sfa12 = p_sfa12 and sfa26 = p_sfa26 and sfa27 = p_sfa27

    let l_want = (l_tc_shb12-l_tsc05+p_in) * l_sfa161
    let l_want = s_digqty(l_want,p_sfa12)

    #got 计算
    let l_got = 0
    select sum(case sfa28 when 0 then 0 else -(smykind-3.5)*2*sfe16 end) sfe16s
      into l_got
      from sfe_file,smy_file,sfa_file
     where smyslip = substr(sfe02, 0, 3)
       and sfe01 = sfa01 and sfe07 = sfa03 and sfe27 = sfa27 and sfe17 = sfa12 and sfe14 = sfa08
       and sfa27 = p_sfa03 and sfa08 = p_sfa08  and sfa01 = p_sfa01
    if cl_null(l_got) then
        let l_got = 0
    end if

    # 查询发料单位小数位数
    select gfe03 into l_gfe03 from gfe_file where gfe01 = p_sfa12
    if sqlca.sqlcode or cl_null(l_gfe03) then
        let l_gfe03 = 0
    end if 
    let l_got = s_trunc(l_got,l_gfe03)

    return l_want,l_got
end function
