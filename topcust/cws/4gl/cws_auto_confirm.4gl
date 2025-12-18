# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: cws_auto_confirm.4gl
# Descriptions...: 自动审核中段函数
# Date & Author..:darcy:2023/04/06 add

database ds

globals "../../../tiptop/config/top.global"

globals
DEFINE g_form  RECORD
    PlantID            LIKE azp_file.azp01,   #No.FUN-680130 VARCHAR(10)
    ProgramID          LIKE wse_file.wse01,   #No.FUN-680130 VARCHAR(10)
    SourceFormID       LIKE oay_file.oayslip, #No.FUN-680130 VARCHAR(5)     #MOD-590183
    SourceFormNum      LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100)
    Date               STRING,
    Time               STRING,
    Status             STRING,
    FormCreatorID      STRING,
    FormOwnerID        STRING,
    TargetFormID       STRING,
    TargetSheetNo      STRING,
          Description        STRING,
          SenderIP           STRING  #No.FUN-680130  VARCHAR(10)      #FUN-560076  #FUN-710063
          END RECORD
end globals

function cws_auto_confirm(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    let g_success = 'Y'

    case p_prog
    when 'cxmt520'
        call cws_auto_cxmt520(p_prog,p_docno)
    when 'cpmi252'
        call cws_auto_cpmi252(p_prog,p_docno)
    when 'cpmi262'
        call cws_auto_cpmi252(p_prog,p_docno)
    when 'apmi255'
        call cws_auto_apmi255(p_prog,p_docno)
    when 'apmi265'
        call cws_auto_apmi255(p_prog,p_docno)
    # darcy:2025/10/28 add s---
    # 增加aeci100 自动审核
    when 'aeci100'
        call cws_auto_aeci100(p_prog,p_docno)
    when 'aeci100_1'
        call cws_auto_aeci100(p_prog,p_docno)
    # darcy:2025/10/28 add e---
    otherwise
        return true
    end case
    if g_success = 'Y' then
        return true
    else
        return false
    end if

end function

function cws_auto_cxmt520(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    call t520sub_y_chk(p_docno)
    if g_success = 'Y' then
        call t520sub_y_upd(p_docno,true)
    end if
end function

function cws_auto_asfi301(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like sfb_file.sfb01
    
end function

function cws_auto_cpmi252(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    call i255sub_y_upd(p_docno,"confirm",true)

end function

function cws_auto_apmi255(p_prog,p_docno)
    define p_prog like type_file.chr20
    define p_docno like oea_file.oea01

    let g_action_choice = "efconfirm"
    if p_prog = 'apmi255' then 
        call apmi255sub_y_upd(p_docno,"efconfirm",'1',true)
    end if
    if p_prog = 'apmi265' then
        call apmi255sub_y_upd(p_docno,"efconfirm",'2',true)
    end if
end function

function cws_auto_aeci100(p_prog,p_docno)
    define  p_prog like type_file.chr20
    define  p_docno like oea_file.oea01
    define  l_ecu01     like ecu_file.ecu01,
            l_ecu02     like ecu_file.ecu02,
            l_ecu10     like ecu_file.ecu10,
            l_ecuud02   like ecu_file.ecuud02
    define l_tok        base.StringTokenizer

    -- call cl_temp_log('cws_auto_confirm',false,sfmt("%(ERRORFILE):%(ERRORLINE) cws_auto_aeci100 call %1 SourceFormNum: %2",'start',g_form.SourceFormNum) )

    -- let l_tok = base.StringTokenizer.createExt(g_form.SourceFormNum CLIPPED,"{+}","",TRUE)
    let l_tok = base.StringTokenizer.create(g_form.SourceFormNum,"{+}")
    let l_ecu01 = l_tok.nextToken()
    let l_ecu02 = l_tok.nextToken()
    let l_ecu02 = cl_replace_str(l_ecu02,"ecu02=","")

    -- call cl_temp_log('cws_auto_confirm',false,sfmt("ecu01: %1 ecu02: %2",l_ecu01,l_ecu02) )

    if cl_null(l_ecu01) or cl_null(l_ecu02) then 
        return
    end if


    select ecu01,ecu02,ecu10,ecuud02 into l_ecu01,l_ecu02,l_ecu10,l_ecuud02
      from ecu_file where ecu01 = l_ecu01 and ecu02 = l_ecu02

    -- call cl_temp_log('cws_auto_confirm',false,sfmt("%(ERRORFILE):%(ERRORLINE) %(ERRNO) %1",'sel ecu') )
    -- call cl_temp_log('cws_auto_confirm',false,sfmt("%(ERRORFILE):%(ERRORLINE) ecuud02:%1",l_ecuud02) )

    if l_ecuud02 = 'N' then
        call i100sub_y_chk(l_ecu01,l_ecu02)
        -- call cl_temp_log('cws_auto_confirm',false,sfmt("%(ERRORFILE):%(ERRORLINE) y_chk:%1",g_success) )
        if g_success = 'Y' then
            call i100sub_y_upd(l_ecu01,l_ecu02,false)
            -- call cl_temp_log('cws_auto_confirm',false,sfmt("%(ERRORFILE):%(ERRORLINE) y_upd:%1",g_success) )
        end if
    end if
    -- call cl_temp_log('cws_auto_confirm',false,sfmt("%(ERRORFILE):%(ERRORLINE) ecu10:%1",l_ecu10) )
    if g_success ='Y' and l_ecu10 = 'N' then
        -- call cl_temp_log('cws_auto_confirm',false,sfmt("%(ERRORFILE):%(ERRORLINE) release:%1",g_success) )
        call i100sub_release(l_ecu01,l_ecu02,false)
    end if
    
end function
