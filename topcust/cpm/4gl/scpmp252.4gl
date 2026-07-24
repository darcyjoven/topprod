# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: scpmp252.4gl
# Descriptions...: 询价自动转核价
# Date & Author..: darcy 26-07-22

DATABASE ds

GLOBALS "../../config/top.global"


--
function scpmp252(p_pmw01,p_tran)
    define  p_pmw01     like pmw_file.pmw01,
            p_tran      boolean

    let g_success = 'Y'
    if not p_tran then
        begin work
    end if

    call scpmp252_ins_tmp(p_pmw01)
    if g_success = 'Y' then
        call scpmp252_gen(p_pmw01)
        if g_success = 'Y' then
            call scpmp252_confirm(p_pmw01)
        end if
    end if

    if not p_tran then
        if g_success = 'Y' then
            commit work
        else
            rollback work
        end if
    end if
end function


--
function scpmp252_ins_tmp(p_pmw01)
    define  p_pmw01     like pmw_file.pmw01
    define  l_sql       string

    delete from cpmp252_tmp_file where tc_pmx01 = p_pmw01

    LET l_sql = " insert into cpmp252_tmp_file",
                " SELECT CASE SUBSTR(tc_pmw01,1,3) WHEN 'PMW' THEN  'PRL' WHEN 'PMY' THEN 'PRM' ELSE 'PRL' END pmi01,",
	            " trunc(sysdate) pmi02,",
	            " '",g_user,"',",
                " tc_pmw10, ",
	            " gen02,",
	            " tc_pmx04,",
	            " CASE tc_pmx04 WHEN 'MISC' THEN tc_pmx05 ELSE pmc03 END pmc03,",
	            " tc_pmw08,",
	            " tc_pmw081,",
	            " '',",
	            " tc_pmx03,",
	            " tc_pmx031,tc_pmx032,",
	            " tc_pmx10,",
	            " tc_pmx11,",
	            " tc_pmx13,",
	            " tc_pmw03,",
	            " tc_pmx06,",
	            " tc_pmx06t,",
	            " tc_pmx07,",
	            " tc_pmx07t,",
	            " tc_pmx08,",
	            " trunc(sysdate) pmj09,",
	            " tc_pmx01,",
	            " tc_pmx02",
            " FROM tc_pmw_file,tc_pmx_file ",
            " LEFT JOIN gen_file ON gen01 = '",g_user,"'",
            " LEFT JOIN pmc_file ON tc_pmx04 = pmc01",
            " WHERE tc_pmw01=tc_pmx01 and tc_pmwconf='Y' and tc_pmx20 ='Y' and ",
            " tc_pmx18 is null ",
            " and tc_pmx01 = ? "
    prepare scpmp252_ins_tmp from l_sql
    execute scpmp252_ins_tmp using p_pmw01
    if sqlca.sqlcode then
        call cl_err('scpmp252_ins_tmp',sqlca.sqlcode,0)
        let g_success ='N'
        return
    end if
end function


function scpmp252_gen(p_pmw01)
    define  p_pmw01     like pmw_file.pmw01
    define  l_pmi       record like pmi_file.*
    define  l_pmj       record like pmj_file.*
    define  i,j,k,l_cnt       integer
    define  li_result   boolean
    define  l_sql       string
    define  l_tc_pmx01  like tc_pmx_file.tc_pmx01
    define  l_tc_pmx02  like tc_pmx_file.tc_pmx02
    define  l_pmi01 like pmi_file.pmi01

    # 上次核价单价
    DECLARE scpmp252_last_price CURSOR FOR
         SELECT pmi03,pmi08,pmj05,pmj09,pmj07,pmj07t
             FROM pmj_file,pmi_file
             WHERE pmj01=pmi01 AND pmiconf = 'Y'
             AND pmj03 = ?
             AND pmj10 = ?
             AND pmj12 = ?
             AND pmj13 = ?
             AND pmj09 = (SELECT MAX(pmj09) FROM pmi_file,pmj_file
             WHERE pmj01=pmi01 AND pmiconf = 'Y'
             AND pmj03 = ?
             AND pmj10 = ?
             AND pmj12 = ?
             AND pmj13 = ?)
             ORDER BY pmi01 desc
    let l_sql = "SELECT pmi01,pmi02,pmi03,pmi04,'N' pmi05,'0' pmi06,'N' pmi07,'N' pmiconf,'Y' pmiacti,'",g_user,"','",g_grup,
                 "','','",g_today,"',pmi08,pmi081,pmi09, ",
                " pmi10,'",g_plant,"','",g_legal,"','",g_user,"','",g_grup,"',",
                " '', ",
                " row_number() OVER(PARTITION BY pmi01,pmi02,pmi09,pmi03,pmi08 ORDER BY pmj03) pmj02, ", --此为项次
                " pmj03,pmj031,pmj032,''pmj04,pmj05,pmj06,pmj07,pmj08,pmj09,pmj10,pmj06t,pmj07t,pmj11, ",
                " pmi10 pmj12,pmj13,'",g_plant,"','",g_legal,"','' pmj14,'' pmjcd14,",
                " '','','','',0,0,'','','','',0,0,0,'','', ",
                " tc_pmx01,tc_pmx02 ",
                " from cpmp252_tmp_file order by pmi01,pmi02,pmi09,pmi03,pmi08 "
    prepare scpmp252_gen_pmj from l_sql
    declare scpmp252_gen_pmj_cl cursor for scpmp252_gen_pmj

    initialize l_pmi.* to null
    initialize l_pmj.* to null

    foreach scpmp252_gen_pmj_cl into l_pmi.*,l_pmj.*,l_tc_pmx01,l_tc_pmx02
        if sqlca.sqlcode then
            call cl_err('scpmp252_gen_pmj_cl',sqlca.sqlcode,0)
            let g_success = 'N'
            exit foreach
        end if

        if l_pmj.pmj03 = 'MISC' then
            call cl_err('料件不能是MISC',sqlca.sqlcode,0)
            let g_success = 'N'
            exit foreach
        end if
        #新增单别
        if l_pmj.pmj02 = 1 then
            let l_pmi01 = ""
            call s_auto_assign_no("apm",l_pmi.pmi01,l_pmi.pmi02,"5","pmi_file","pmi01","","","")
                  returning li_result,l_pmi01
            if (not li_result) then
               call cl_err(l_pmi.pmi01,'wag-673',0)
               let g_success ='N'
               exit foreach
            end if
            let l_pmi.pmi07 = 'N'
            let l_pmi.pmi01 = l_pmi01
            insert into pmi_file values (l_pmi.*)
            if sqlca.sqlcode then
                call cl_err(l_pmi.pmi01,sqlca.sqlcode,0)
                let g_success = 'N'
                exit foreach
            end if
        end if
        # 依据料号设置上次核价单价和核价日期
        let l_pmj.ta_pmj01 = null
        let l_pmj.ta_pmj02 = null
        let l_pmj.ta_pmj03 = null
        let l_pmj.ta_pmj04 = null
        let l_pmj.ta_pmj05 = null
        let l_pmj.ta_pmj06 = null
        open scpmp252_last_price using l_pmj.pmj03,l_pmj.pmj10,l_pmj.pmj12,l_pmj.pmj13,l_pmj.pmj03,l_pmj.pmj10,l_pmj.pmj12,l_pmj.pmj13
        fetch scpmp252_last_price into l_pmj.ta_pmj01,l_pmj.ta_pmj02,l_pmj.ta_pmj03,l_pmj.ta_pmj04,l_pmj.ta_pmj05,l_pmj.ta_pmj06
        close scpmp252_last_price
        let l_pmj.pmj01 = l_pmi01
        insert into pmj_file values (l_pmj.*)
        if sqlca.sqlcode then
           call cl_err(l_pmj.pmj01||"-"||l_pmj.pmj02,sqlca.sqlcode,0)
           let g_success = 'N'
           exit foreach
        end if
        update tc_pmx_file set tc_pmx18 = l_pmj.pmj01,tc_pmx19 = l_pmj.pmj02
         where tc_pmx01 = l_tc_pmx01 and tc_pmx02 = l_tc_pmx02
        if sqlca.sqlcode then
           call cl_err(l_tc_pmx01||"-"||l_tc_pmx02,sqlca.sqlcode,0)
           let g_success = 'N'
           exit foreach
        end if
    end foreach
    delete from cpmp252_tmp_file where tc_pmx01 = p_pmw01
end function

function scpmp252_confirm(p_pmw01)
    define  p_pmw01     like pmw_file.pmw01
    define  l_pmi01     like pmi_file.pmi01
    define  l_pmi10     like pmi_file.pmi10
    define  l_sql       string

    let l_sql = "select unique tc_pmx18,pmi10 from tc_pmx_file,pmi_file ",
                " where tc_pmx01 = ? and tc_pmx18=pmi01"
    prepare scpmp252_cp from l_sql
    declare scpmp252_ccur cursor for scpmp252_cp

    foreach scpmp252_ccur using p_pmw01 into l_pmi01,l_pmi10
        if sqlca.sqlcode then
            call cl_err('scpmp252_ccur',sqlca.sqlcode,0)
            let g_success = 'N'
            exit foreach
        end if

        let g_action_choice = "efconfirm"
        call apmi255sub_y_upd(l_pmi01,"efconfirm",l_pmi10,true)
    end foreach

end function
