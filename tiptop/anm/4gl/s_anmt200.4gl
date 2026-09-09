# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: Function-Library
# Descriptions...: 票据相关的sub函数
# Date & Author..: darcy:2024/08/22

DATABASE ds

GLOBALS "../../config/top.global"

# 单据还原时,检查单据是否时最后一次异动
# 目前转付类型'5',可能有多笔记录,其它记录都只有一笔
function sanmt200_undo_chk(p_nmh01,p_no)
    define p_nmh01      like nmh_file.nmh01
    define p_no         like type_file.chr30
    define l_nmykind    like nmy_file.nmykind
    define l_nmi03      like type_file.num5     #darcy:2025/01/07 add
    define l_nmi        record
        nmi02           like nmi_file.nmi02,
        nmi10           like nmi_file.nmi10
        end record
    define l_npn02      like npn_file.npn02,
           l_npn03      like npn_file.npn03
    define l_nmyslip    varchar(3)

    call s_showmsg_init()
    let g_success = "Y"

    let l_nmyslip = p_no
    select nmykind into l_nmykind from nmy_file
     where nmyslip = l_nmyslip
    case
        when l_nmykind == 'B'
            # 这是anmt250单据异动
            select npn02,npn03 into l_npn02,l_npn03 from npn_file
             where npn01 = p_no
            if l_npn03 matches '[458]' then
                # 要还原的是转付
                # 1.检查单据后面序号是否还有转付记录
                select max(to_number(nmi03)) into l_nmi03 from nmi_file
                where nmi01 = p_nmh01 and nmi02 = l_npn02 and nmi06 = l_npn03
                if cl_null(l_nmi03) then
                    call s_errmsg("npn01",p_no,"未查到单据异动记录",'cnm-004',1)
                    let g_success = "N"
                    goto _error
                end if

                declare sanmt200_nmi_5 cursor for
                    select nmi02,nmi10 from nmi_file
                     where nmi01 = p_nmh01 and nmi06 in ('4','5','8')
                       and to_number(nmi03) > l_nmi03
                foreach sanmt200_nmi_5 into l_nmi.*
                    if sqlca.sqlcode then
                        call cl_err("sanmt200_nmi_5",sqlca.sqlcode,1)
                        exit foreach
                    end if
                    call s_errmsg("nmi02,npn01",sfmt("%1|%2",l_nmi.nmi02,l_nmi.nmi10),"",'cnm-005',1)
                    let g_success = "N"
                end foreach
            end if
        when l_nmykind == '2'
        otherwise

    end case
    label _error:
    if g_success = "N" then
        call s_showmsg()
        return false
    end if
    return true
end function

# 检查票贴和转付的金额是否大于总金额
# 票贴最多一次,转付可以多次
# 转付之后还可以票贴
function sanmt200_chk_amt(p_npn01)
    define p_npn01      like npn_file.npn01
    define l_npo        record
            npo02       like npo_file.npo02,
            npo03       like npo_file.npo03,
            npo04       like npo_file.npo04,
            npo05       like npo_file.npo05
    end record
    define l_npo04,l_npo05  like npo_file.npo04
    define l_nmh02,l_nmh32  like nmh_file.nmh02

    let g_success = 'Y'
    call s_showmsg_init()

    declare sanmt200_chk_amt_cur cursor for
        select npo02,npo03,npo04,npo05 from npo_file,npn_file
         where npo01 = p_npn01 and npn01 = npo01 and npn03 in ('4','5')

    prepare sanmt200_has_amt_p from
        "select sum(npo04),sum(npo05) from npo_file,npn_file where npo01 <> ? and npo03 = ?  and npn01 = npo01  and npnconf = 'Y' "

    initialize l_npo.* to null
    foreach sanmt200_chk_amt_cur into l_npo.*
        if sqlca.sqlcode then
            call cl_err("sanmt200_chk_amt_cur",sqlca.sqlcode,1)
            exit foreach
        end if

        execute sanmt200_has_amt_p
          using p_npn01,l_npo.npo03
           into l_npo04,l_npo05

        if cl_null(l_npo04) then let l_npo04 = 0 end if
        if cl_null(l_npo05) then let l_npo05 = 0 end if

        select nmh02,nmh32 into l_nmh02,l_nmh32 from nmh_file
         where nmh01 = l_npo.npo03

        if l_nmh02 - l_npo04 < l_npo.npo04  or l_nmh32 - l_npo05 < l_npo.npo05 then
            call s_errmsg("npo03,npo04,nmh02",sfmt("本次金额:%1,已转付金额:%2,票据总金额:%3",l_npo.npo04,l_npo04,l_nmh02),"",'cnm-006',1)
            let g_success = "N"
        end if
    end foreach

    label _error:
    if g_success = "N" then
        call s_showmsg()
        return false
    end if
    return true
end function
