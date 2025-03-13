# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: csfp300.4gl
# Descriptions...: 依照订单拆分RUN CARD
# Date & Author..:darcy:2023/08/05

database ds

globals "../../../tiptop/config/top.global"

define g_ima  RECORD
        ima01    LIKE ima_file.ima01, 
        ima02    LIKE ima_file.ima02, 
        ima021   LIKE ima_file.ima02, 
        ima25    LIKE ima_file.ima25, 
        ima05    LIKE ima_file.ima05, 
        ima06    LIKE ima_file.ima06, 
        ima08    LIKE ima_file.ima08, 
        ima37    LIKE ima_file.ima37, 
        ima70    LIKE ima_file.ima70, 
        ima15    LIKE ima_file.ima15, 
        ima906   LIKE ima_file.ima906,
        ima907   LIKE ima_file.ima907,
        ima44     LIKE ima_file.ima44,
        ima44_fac LIKE ima_file.ima44_fac,
        ima45     LIKE ima_file.ima45,
        ima46     LIKE ima_file.ima46,
        ima881    LIKE ima_file.ima881,
        unavl_stk  LIKE type_file.num15_3,
        avl_stk    LIKE type_file.num15_3,
        oeb_q      LIKE type_file.num15_3,
        sfa_q1     LIKE type_file.num15_3,
        sfa_q2     LIKE type_file.num15_3,
        sie_q      LIKE type_file.num15_3,
        pml_q      LIKE type_file.num15_3,
        pmn_q      LIKE type_file.num15_3,
        rvb_q2     LIKE type_file.num15_3,
        rvb_q      LIKE type_file.num15_3,
        sfb_q1     LIKE type_file.num15_3,
        sfb_q2     LIKE type_file.num15_3,
        qcf_q      LIKE type_file.num15_3,
        atp_qty    LIKE type_file.num15_3,
        img_q      LIKE type_file.num15_3,
        sfe_c      LIKE type_file.num15_3 
        ,sfa_xiaban LIKE type_file.num15_3
        ,sfa_liuzhi LIKE type_file.num15_3
        ,ima27      like ima_file.ima27 
        ,rpc13      like rpc_file.rpc13 
    end record

main
    options
        input no wrap
    defer interrupt

    if (not cl_user()) then
        exit program
    end if

    if (not cl_setup("CIM")) then
        exit program
    end if

    call cimp100()
end main

function cimp100()
    define l_ima01 like ima_file.ima01

# CREATE TEMP TABLE cimp100_file(
#     IMA01    LIKE IMA_FILE.IMA01,
#     IMA02    LIKE IMA_FILE.IMA02,
#     IMA021   LIKE IMA_FILE.IMA02,
#     IMA25    LIKE IMA_FILE.IMA25,
#     IMA05    LIKE IMA_FILE.IMA05,
#     IMA06    LIKE IMA_FILE.IMA06,
#     IMA08    LIKE IMA_FILE.IMA08,
#     IMA37    LIKE IMA_FILE.IMA37,
#     IMA70    LIKE IMA_FILE.IMA70,
#     IMA15    LIKE IMA_FILE.IMA15,
#     IMA906   LIKE IMA_FILE.IMA906,
#     IMA907   LIKE IMA_FILE.IMA907,
#     IMA44     LIKE IMA_FILE.IMA44,
#     IMA44_FAC LIKE IMA_FILE.IMA44_FAC,
#     IMA45     LIKE IMA_FILE.IMA45,
#     IMA46     LIKE IMA_FILE.IMA46,
#     IMA881    LIKE IMA_FILE.IMA881,
#     UNAVL_STK  LIKE TYPE_FILE.NUM15_3,
#     AVL_STK    LIKE TYPE_FILE.NUM15_3,
#     OEB_Q      LIKE TYPE_FILE.NUM15_3,
#     SFA_Q1     LIKE TYPE_FILE.NUM15_3,
#     SFA_Q2     LIKE TYPE_FILE.NUM15_3,
#     SIE_Q      LIKE TYPE_FILE.NUM15_3,
#     PML_Q      LIKE TYPE_FILE.NUM15_3,
#     PMN_Q      LIKE TYPE_FILE.NUM15_3,
#     RVB_Q2     LIKE TYPE_FILE.NUM15_3,
#     RVB_Q      LIKE TYPE_FILE.NUM15_3,
#     SFB_Q1     LIKE TYPE_FILE.NUM15_3,
#     SFB_Q2     LIKE TYPE_FILE.NUM15_3,
#     QCF_Q      LIKE TYPE_FILE.NUM15_3,
#     ATP_QTY    LIKE TYPE_FILE.NUM15_3,
#     IMG_Q      LIKE TYPE_FILE.NUM15_3,
#     SFE_C      LIKE TYPE_FILE.NUM15_3,
#     SFA_XIABAN LIKE TYPE_FILE.NUM15_3,
#     SFA_LIUZHI LIKE TYPE_FILE.NUM15_3,
#     IMA27      LIKE IMA_FILE.IMA27,
#     RPC13      LIKE RPC_FILE.RPC13)

    delete from cimp100_file
    
    declare cimp100_cur cursor for 
    SELECT UNIQUE pmn04 FROM pmn_file,pmk_file,pmm_file
    WHERE pmn01=pmm01 AND pmn16=2
    AND pmk01 =pmn24
    AND pmk12='55758'
    
    foreach cimp100_cur into l_ima01
        if sqlca.sqlcode then
            exit foreach
        end if
        initialize g_ima.* to null
        call q102_get_g_ima(l_ima01) returning g_ima.*
        insert into cimp100_file values(g_ima.*)
    end foreach

end function
