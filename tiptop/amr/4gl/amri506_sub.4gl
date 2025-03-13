# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amri506_sub.4gl
# Descriptions...: 独立需求相关sub函数
# Date & Author..: darcy:2023/06/15

database ds
globals "../../config/top.global"

type rpc record
    rpc01       like rpc_file.rpc01,
    rpc02       like rpc_file.rpc02,
    rpc03       like rpc_file.rpc03,
    rpc04       like rpc_file.rpc04,
    rpc10       like rpc_file.rpc10,
    rpc11       like rpc_file.rpc11,
    rpc12       like rpc_file.rpc12,
    rpc13       like rpc_file.rpc13,
    rpc131      like rpc_file.rpc131,
    rpc14       like rpc_file.rpc14,
    rpc15       like rpc_file.rpc15,
    rpc16       like rpc_file.rpc16,
    rpc16_fac   like rpc_file.rpc16_fac,
    rpc17       like rpc_file.rpc17,
    rpc18       like rpc_file.rpc18,
    rpc19       like rpc_file.rpc19,
    rpc20       like rpc_file.rpc20,
    rpc21       like rpc_file.rpc21,
    rpcacti     like rpc_file.rpcacti,
    rpcuser     like rpc_file.rpcuser,
    rpcgrup     like rpc_file.rpcgrup,
    rpcdate     like rpc_file.rpcdate,
    rpcmodu     like rpc_file.rpcmodu,
    rpcplant    like rpc_file.rpcplant,
    rpclegal    like rpc_file.rpclegal,
    rpcoriu     like rpc_file.rpcoriu,
    rpcorig     like rpc_file.rpcorig,
    ta_rpc01    like rpc_file.ta_rpc01,
    ta_rpc02    like rpc_file.ta_rpc02,
    ta_rpc03    like rpc_file.ta_rpc03,
    ta_rpc04    like rpc_file.ta_rpc04,
    ta_rpc05    like rpc_file.ta_rpc05,
    ta_rpc06    like rpc_file.ta_rpc06,
    ta_rpc07    like rpc_file.ta_rpc07,
    ta_rpc08    like rpc_file.ta_rpc08,
    ta_rpc09    like rpc_file.ta_rpc09,
    ta_rpc10    like rpc_file.ta_rpc10
end record

type list record
    item_no varchar(100),
    lot     decimal(15,3),
    unit    varchar(10)
end record

# 入口函数
function amri506sub_get(p_prog,p_docno,p_type,p_inTransaction)
    define p_prog   varchar(10),
           p_docno  varchar(40)
    define p_type   varchar(10) # delete 删除 close 结案 query 查询
    define p_inTransaction like type_file.num5  #是否在事务中

    case p_type
        when "delete"
            return amri506sub_delete(p_prog,p_docno,p_inTransaction,true)
        when "close"
            return amri506sub_close(p_prog,p_docno,p_inTransaction,true)
        when "query"
            call amri506sub_query(p_prog,p_docno)
            return true
    end case
    return true
end function

# 新增独立需求
function amri506sub_insert(p_prog,p_docno,p_inTransaction,p_list,p_date)
    define p_list dynamic array of list
    define p_prog   varchar(10),
           p_docno  varchar(40)
    define p_inTransaction like type_file.num5  #是否在事务中
    define p_date Date
     
    define l_rpc02  varchar(40)
    define l_i,l_cnt    integer
    define l_sql  string
    define l_rpc rpc
    define l_ima25  varchar(10)
    define l_flag   like type_file.num5,
           l_factor  like type_file.num26_10
    define l_msg   string

    # if g_user !='tiptop' then return true end if
    # 无资料需要处理
    if p_list.getLength() = 0 then
        return true
    end if

    # 检查是否已存在
    let l_rpc02 = amri506sub_get_rpc02(p_prog,p_docno)

    if not cl_null(l_rpc02) then
        call cl_err(l_rpc02,'cmr-005',1)
        return false
    end if

    let g_success = 'Y' 
    if not p_inTransaction then
        begin work
    end if

    # 单据编码
    call s_auto_assign_no("asf","XRO",p_date,"L","rpc_file","rpc02","","","")
        returning l_cnt,l_rpc02
    if (not l_cnt) then
        if not p_inTransaction then
            rollback work
        end if 
        return false
    end if

    for l_i = 1 to p_list.getLength()
        initialize l_rpc.* to null
        let l_rpc.rpc01 = p_list[l_i].item_no
        let l_rpc.rpc02 = l_rpc02
        let l_rpc.rpc03 = l_i
        let l_rpc.rpc04 = 0
        let l_rpc.rpc11 = 4
        let l_rpc.rpc12 = p_date
        #  数量换算为库存数量
        select ima25 into l_ima25 from ima_file where ima01=l_rpc.rpc01
        if sqlca.sqlcode  or cl_null(l_ima25) then
            call cl_err(l_rpc.rpc01,'axm-945',1)
            let g_success = 'N'
            exit for
        end if
        if l_ima25 = p_list[l_i].unit then
            let l_rpc.rpc13 = p_list[l_i].lot
        else
            call s_umfchk(l_rpc.rpc01,p_list[l_i].unit,l_ima25)
                returning l_flag,l_factor
            if not l_factor then
                # 找不到换算率
                call cl_err(p_list[l_i].unit||'~'||l_ima25,'art-242',1)
                let g_success = 'N'
                exit for
            else
                let l_rpc.rpc13 = s_digqty(p_list[l_i].lot*l_factor,l_ima25)
            end if
        end if
        
        let l_rpc.rpc131 = 0
        let l_rpc.rpc14 = 0
        let l_rpc.rpc16 = l_ima25
        let l_rpc.rpc16_fac = 1
        let l_rpc.rpc18 = 'Y'
        let l_rpc.rpc19 = 'N'
        let l_rpc.rpc21 = p_date
        let l_rpc.rpcacti = 'Y'
        let l_rpc.rpcuser = g_user
        let l_rpc.rpcgrup = g_grup
        let l_rpc.rpcdate = p_date
        let l_rpc.rpcmodu = g_user
        let l_rpc.rpcplant = g_plant
        let l_rpc.rpclegal = g_legal
        let l_rpc.rpcoriu = g_user
        let l_rpc.rpcorig = g_grup
        let l_rpc.ta_rpc04 = p_prog
        let l_rpc.ta_rpc05 = p_docno

        insert into rpc_file (
            rpc01,rpc02,rpc03,rpc04,rpc11,
            rpc12,rpc13,rpc131,rpc14,rpc16,rpc16_fac,
            rpc18,rpc19,rpc21,rpcacti,rpcuser,
            rpcgrup,rpcdate,rpcmodu,rpcplant,rpclegal,
            rpcoriu,rpcorig,ta_rpc04,ta_rpc05
        )values(
            l_rpc.rpc01,l_rpc.rpc02,l_rpc.rpc03,l_rpc.rpc04,l_rpc.rpc11,
            l_rpc.rpc12,l_rpc.rpc13,l_rpc.rpc131,l_rpc.rpc14,l_rpc.rpc16,l_rpc.rpc16_fac,
            l_rpc.rpc18,l_rpc.rpc19,l_rpc.rpc21,l_rpc.rpcacti,l_rpc.rpcuser,
            l_rpc.rpcgrup,l_rpc.rpcdate,l_rpc.rpcmodu,l_rpc.rpcplant,l_rpc.rpclegal,
            l_rpc.rpcoriu,l_rpc.rpcorig,l_rpc.ta_rpc04,l_rpc.ta_rpc05
        )
        if sqlca.sqlcode then
            call cl_err('ins rpc',sqlca.sqlcode,1)
            let g_success = 'N'
            exit for
        end if
    end for
    if g_success = 'N' then
        if not p_inTransaction then
            rollback work
            return false
        end if
    end if
    if g_success = 'Y' then
        if not p_inTransaction then
            commit work
        end if
    end if

    let l_msg = "独立需求产生成功，单号：",l_rpc02
    message l_msg
    return true
end function

# 删除
function amri506sub_delete(p_prog,p_docno,p_inTransaction,p_show)
    define p_prog   varchar(10),
           p_docno  varchar(40)
    define p_inTransaction,p_show like type_file.num5  #是否在事务中
    define l_rpc18  like rpc_file.rpc18,
           l_rpc19  like rpc_file.rpc19

    define l_rpc02  varchar(40)

    # if g_user !='tiptop' then return true end if

    let l_rpc02 = amri506sub_get_rpc02(p_prog,p_docno)

    # 无独立需求单号
    if cl_null(l_rpc02) then
        return true
    end if

    select rpc18,rpc19 into l_rpc18,l_rpc19 from rpc_file
     where rpc02 = l_rpc02
    
    if sqlca.sqlcode then
        if p_show then call cl_err(l_rpc02,sqlca.sqlcode,1) end if
        return false
    end if

    if l_rpc19 = 'Y' then
        # if p_show then call cl_err(l_rpc02,'amr-918',1) end if
        return true
    end if

    let g_success = 'Y'
    if not p_inTransaction then
        begin work
    end if

    delete from rpc_file where rpc02 = l_rpc02

    if sqlca.sqlcode then
        if p_show then call cl_err(l_rpc02,sqlca.sqlcode,1) end if
        let g_success = 'N'
        if not p_inTransaction then
            rollback work
        end if
        return false
    end if

    if g_success = 'Y' then
        if not p_inTransaction then
            commit work
        end if
    end if
    return true

end function

# 结案
function amri506sub_close(p_prog,p_docno,p_inTransaction,p_show)
    define p_prog   varchar(10),
           p_docno  varchar(40)
    define p_inTransaction,p_show like type_file.num5  #是否在事务中
    define l_rpc18  like rpc_file.rpc18,
           l_rpc19  like rpc_file.rpc19

    define l_rpc02  varchar(40)

    # if g_user !='tiptop' then return true end if
    let l_rpc02 = amri506sub_get_rpc02(p_prog,p_docno)

    # 无独立需求单号
    if cl_null(l_rpc02) then
        return true
    end if

    select unique rpc18,rpc19 into l_rpc18,l_rpc19 from rpc_file
     where rpc02 = l_rpc02
    
    if sqlca.sqlcode then
        if p_show then call cl_err(l_rpc02,sqlca.sqlcode,1) end if
        return false
    end if

    if l_rpc18 = 'Y' then else
        if p_show then call cl_err(l_rpc02,'9026',1) end if
        return false
    end if

    if l_rpc19 = 'Y' then
        # if p_show then call cl_err(l_rpc02,'axm-355',1) end if
        return true
    end if

    let g_success = 'Y'
    if not p_inTransaction then
        begin work
    end if

    update rpc_file set rpc19 = 'Y',rpc20 = g_today where rpc02 = l_rpc02

    if sqlca.sqlcode then
        if p_show then call cl_err(l_rpc02,sqlca.sqlcode,1) end if
        let g_success = 'N'
        if not p_inTransaction then
            rollback work
        end if
        return false
    end if

    if g_success = 'Y' then
        if not p_inTransaction then
            commit work
        end if
    end if
    return true
end function

# 打开作业
function amri506sub_query(p_prog,p_docno)
    define p_prog   varchar(10),
           p_docno  varchar(40)
    
    define l_cmd string
    define l_rpc02  varchar(40)
 
    let l_rpc02 = amri506sub_get_rpc02(p_prog,p_docno)
    if cl_null(l_rpc02) then
        call cl_err(p_docno,"cmr-006",1)
        return
    end if

    let l_cmd = "amri506 ",l_rpc02
    call cl_cmdrun_wait(l_cmd)
end function

# 获取amri506单号
function amri506sub_get_rpc02(p_prog,p_docno)
    define p_prog   varchar(10),
           p_docno  varchar(40)
    define l_sql,l_cmd string
    define l_rpc02  varchar(40)

    let l_sql = "select unique rpc02 from rpc_file where ta_rpc04=? and ta_rpc05 =? and rpc18='Y' and rpc19='N'"

    let l_rpc02 = ""
    prepare amri506sub_rpc_cnt from l_sql 
    execute amri506sub_rpc_cnt using p_prog,p_docno into l_rpc02

    return l_rpc02
end function
