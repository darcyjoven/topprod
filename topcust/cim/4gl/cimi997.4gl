# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cimi997.4gl
# Descriptions...: 测试程序
# Date & Author..: darcy:2024/04/18
 
import libgjson
import libxjson
import libmail

import JAVA com.fourjs.fgl.lang.FglRecord



database ds
globals "../../../tiptop/config/top.global" 
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

MAIN
    

    options 
        input no wrap
    defer interrupt

    if not cl_user() THEN
        exit program
    end if

    whenever error call cl_err_msg_log
  
    if (not cl_setup("CIM")) then
        exit program
    end if
 
    call cl_used(g_prog,g_time,1)
        returning g_time  
    
    # call test_cs_asf_gen_offine()
    # call test_cs_close()
    # call test_GetWaitScrapR()
    # call test_gjson()
    # call test_cs_ima()
    # call test_asft623()
    # call test_Application()
    # call test_channel()
    # call test_base_TypeInfo_create()
    # call test_cmd_return()
    # call test_msg_server()
    # call test_comb_sele()
    # call test_fglrecord()
    -- call test_mail()
    # call test_html()
    # call test_mail_html()
    call test_aimq102()
    
    call cl_used(g_prog,g_time,2) returning g_time

END MAIN

function test_aimq102()
    define l_pml04  like pml_file.pml04
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
            sfe_c      LIKE type_file.num15_3,
            sfa_xiaban LIKE type_file.num15_3,
            sfa_liuzhi LIKE type_file.num15_3,
            ima27      like ima_file.ima27,
            rpc13      like rpc_file.rpc13   
        END RECORD

    declare cimi997_pml04 cursor for
        select ima01 from darpml04

    foreach cimi997_pml04 into g_ima.*
        if sqlca.sqlcode then
            exit foreach
        end if
        update darpml04 set darpml04.* = g_ima.*
         where ima01 = g_ima.ima01
    end foreach
end function

function test_mail_html()

end function
function test_html()
    define l_str    string
    # call cs_html_init("这是一个从")
    # call cs_html() returning l_str
    RUN "echo '"||l_str||"' >> /u1/topprod/tiptop/doc/help/2/czz/mail.html"
end function

function test_mail()
define l_ok     varchar(10)
    call mailto("to your ","这是一个邮件测试内容1","darcy.li@forewin-sz.com.cn","")
        returning l_ok
    call mailsend("to your ","这是一个邮件测试内容2","darcy.li@forewin-sz.com.cn","","","")
        returning l_ok
    call mailsendfile("to your ","这是一个邮件测试内容2","darcy.li@forewin-sz.com.cn","","","")
        returning l_ok
end function

function test_fglrecord()
 
end function

function test_json() 
end function

function test_cmd_return()
    define l_cmd string
    define l_ret string

    let l_cmd = "date"
    run l_cmd returning l_cmd
end function

function test_comb_sele()
    define l_wc     string
    define l_pmc911     ui.ComboBox

    open window comb_sele_w at 4,4
         with form "apm/42f/apmi600"
          attribute (style = g_win_style clipped)

    call cl_ui_init()


    CONSTRUCT BY NAME l_wc ON pmc911

        BEFORE CONSTRUCT
            message ''
            let l_pmc911 = ui.ComboBox.forName("pmc911")
            call l_pmc911.clear()
        
        
    END CONSTRUCT

    close window comb_sele_w

end function

function test_msg_server()
 
end function
function test_base_TypeInfo_create()
    define n        om.DomNode
    define l_str    string
    define r    record
        a1  string, 
        a2  varchar(20),
        a3  date,
        a4  decimal(20,6),
        a5  integer,
        l1  dynamic array of varchar(40),
        l2  dynamic array of record
            a1  string,
            a2  date
        end record
    end record
    define a dynamic array of string

    let r.a1 = "i am string"
    let r.a2 = "i am varchar"
    let r.a3 = g_today -10
    let r.a4 = 19.88
    let r.l1[1] = 'i am varchar 1' 
    let r.l1[2] = 'i am varchar 2' 
    let r.l2[1].a1 = " i am l2 a1"
    let r.l2[1].a2 = g_today - 5
    let r.l2[2].a1 = " i am l2 a2"
    let r.l2[2].a2 = g_today - 2

    let n = base.typeinfo.create( r )
    call n.toString() returning l_str

    call x2json(l_str) returning l_str
    
    let l_str = "single field"
    let n = base.typeinfo.create( l_str )
    call n.toString() returning l_str

    let a[1] = "a1"
    let a[1] = "a2"
    let n = base.typeinfo.create( a )
    call n.toString() returning l_str

end function
##############################################################################
--              test_channel
--              Descripcion
--              Autor
--              Fecha
--              Parametros:
--                      Parametros
--              Parametros:
--                      Parametros
##############################################################################
FUNCTION test_channel()
  DEFINE fn CHAR(40)
  DEFINE ex CHAR(10)
  DEFINE ch base.Channel 
  LET ch = base.Channel.create()
  CALL ch.setDelimiter(".")
  CALL ch.openPipe("ls -l","r")
  WHILE ch.read([fn,ex])
    DISPLAY fn, "   ", ex 
  END WHILE
  CALL ch.close()
END FUNCTION 
function test_Application()
    define l_str    string
    call base.Application.getArgument(1)
        returning l_str
    call base.Application.getArgumentCount()
        returning l_str
    call base.Application.getProgramDir()
        returning l_str
    call base.Application.getProgramName()
        returning l_str
    call base.Application.getFglDir()
        returning l_str
    call base.Application.getResourceEntry("flymn3")
        returning l_str
    call base.Application.getStackTrace()
        returning l_str
end function
function test_asft623()
    # 工单发退料日期在最后入库月份之后
    # MRA-23081273
    call cs_asf_last_in_chk("MRL-23094862")

    # 工单报工入库之后
    # MRL-23084554 MRA-23080639
    call cs_asf_last_in_chk("MRL-23084554")

    # 正常结案工单
    # 未最后入库工单

end function
function test_cs_asf_get510()
    define l_sfs dynamic array of sfs
    define l_ok boolean

    call cs_asf_get510("MRA-24050470","F48010",5000) returning l_sfs,l_ok
end function
 
function test_cws_create_asfi514_encode()
    define l_chr varchar(10)

    let l_chr = cws_create_asfi514_encode(1)
    let l_chr = cws_create_asfi514_encode(10)
    let l_chr = cws_create_asfi514_encode(100)
    let l_chr = cws_create_asfi514_encode(1000)
    let l_chr = cws_create_asfi514_encode(10000)
    let l_chr = cws_create_asfi514_encode(100000)
end function

function test_cs_asf_gen_offine()
    define l_bmb01  like bmb_file.bmb01
    define l_ok     boolean
    # cs_asf_gen_offine(p_sfa01,p_sfa08,p_inTransaction)

    call cs_asf_gen_offine('MRA-24050630','F24033',false) returning l_bmb01,l_ok
end function

function test_cs_close()
    define p_list dynamic array of varchar(40)
    define l_i integer
 
    # for l_i = 100 to 999
    #     let p_list[l_i-99] = sfmt('MRA-24050%1',l_i)
    # end for

    # let p_list[1] = 'MRA-21040001'--结案工单
    # let p_list[3] = 'MRA-24050355'-- 未审核发料单
    # let p_list[4] = 'MRA-24050007'-- 在制
    # let p_list[5] = 'MSY-24050402'-- 已作废工单
    -- 结案日期

    let p_list[2] = 'MRA-24050002'-- 未入库
    let g_bgjob = 'Y'
    call cs_close_do(p_list,g_today,false)
    call cs_close_end()
end function

function test_GetWaitScrapR()
    define l_ok     boolean
    define l_str    string

    define l_ret dynamic array of record
        sfb01   like sfb_file.sfb01,
        sfb12   like sfb_file.sfb12
    end record

    call GetWaitScrapR("MRA-24050001,MRA-24050002,MRA-24050003,MRA-24050004,MRA-24050005,MRA-24050006,MRA-24050007,MRA-24050008,MRA-24050009,MRA-24050010,MRA-24050011,MRA-24050012,MRA-24050013,MRA-24050014,MRA-24050015,MRA-24050016,MRA-24050017,MRA-24050018,MRA-24050019,MRA-24050021,MRA-24050022,MRA-24050023,MRA-24050024,MRA-24050025,MRA-24050026,MRA-24050027,MRA-24050028,MRA-24050029,MRA-24050101,MRA-24050102,MRA-24050103,MRA-24050104,MRA-24050105,MRA-24050106,MRA-24050107,MRA-24050108,MRA-24050109,MRA-24050110,MRA-24050111,MRA-24050112,MRA-24050113,MRA-24050114,MRA-24050115,MRA-24050116,MRA-24050117,MRA-24050118,MRA-24050119,MRA-24050121,MRA-24050122,MRA-24050123,MRA-24050124,MRA-24050125,MRA-24050126,MRA-24050127,MRA-24050128,MRA-24050129,MRA-24050201,MRA-24050202,MRA-24050203,MRA-24050204,MRA-24050205,MRA-24050206,MRA-24050207,MRA-24050208,MRA-24050209,MRA-24050210,MRA-24050211,MRA-24050212,MRA-24050213,MRA-24050214,MRA-24050215,MRA-24050216,MRA-24050217,MRA-24050218,MRA-24050219,MRA-24050221,MRA-24050222,MRA-24050223,MRA-24050224,MRA-24050225,MRA-24050226,MRA-24050227,MRA-24050228,MRA-24050229,MRA-24050301,MRA-24050302,MRA-24050303,MRA-24050304,MRA-24050305,MRA-24050306,MRA-24050307,MRA-24050308,MRA-24050309,MRA-24050310,MRA-24050311,MRA-24050312,MRA-24050313,MRA-24050314,MRA-24050315,MRA-24050316,MRA-24050317,MRA-24050318,MRA-24050319,MRA-24050321,MRA-24050322,MRA-24050323,MRA-24050324,MRA-24050325,MRA-24050326,MRA-24050327,MRA-24050328,MRA-24050329")
        returning l_ok,l_ret
    call cl_err(l_ret.getLength(),"!",1)
end function


function test_gjson()
    define l_str string
    define l_i integer
    define l_f decimal(15,6)

    let l_str = "{\"success\":\"ok\"}"
    let l_str = gString(l_str,"success")
    display l_str

    let l_i = gLength("{\"success\":[{\"wo_no\":\"MRA-24050007\",\"wait_scrap\":222.0},{\"wo_no\":\"MRA-24050023\",\"wait_scrap\":6930.0},{\"wo_no\":\"MRA-24050204\",\"wait_scrap\":308.0},{\"wo_no\":\"MRA-24050212\",\"wait_scrap\":61.0},{\"wo_no\":\"MRA-24050317\",\"wait_scrap\":256.0}]}","success.#")

    display l_i

    let l_f = gFloat("{\"success\":[{\"wo_no\":\"MRA-24050007\",\"wait_scrap\":222.0},{\"wo_no\":\"MRA-24050023\",\"wait_scrap\":6930.0},{\"wo_no\":\"MRA-24050204\",\"wait_scrap\":308.0},{\"wo_no\":\"MRA-24050212\",\"wait_scrap\":61.0},{\"wo_no\":\"MRA-24050317\",\"wait_scrap\":256.0}]}","success.2.wait_scrap")

    display l_f

end function

function test_cs_ima()
    define l_ima01 string
    begin work
    let l_ima01 =  cs_ima("M.MJ","1","2") 
    if cl_null(l_ima01) then
        rollback work
    else
        commit work
    end if
end function



