# Prog. Version..: '5.30.06-13.03.12(00000)'
# Pattern name...: cs_restful.4gl
# Descriptions...:  restful api 
# Date & Author..: darcy:2023/07/30

IMPORT JAVA com.fourjs.fgl.lang.FglRecord

database ds
globals "../4gl/cs_restful.global"
GLOBALS "../../../tiptop/config/top.global"

function cs_restful()

end function

function cs_do_restful()
    define header string
    define body string
    define i,j integer
    define l_cmd string
    define l_uuid varchar(40)
    define l_t datetime year to fraction(5)

    define head_fglrecord dynamic array of com.fourjs.fgl.lang.FglRecord

    call cs_restful_init()

    for i =1 to RESTful_request.Header.getLength()
        let head_fglrecord[i] = RESTful_request.Header[i]
    end for

    let header = cs_array_json(head_fglrecord,"Header")
    
    let i = RESTful_request.Body.getFieldCount()
    let j = RESTful_request.Bodys.getLength()
    case
        when i > 0 && j > 0
            let body = cs_record_arrays_json(RESTful_request.Body,RESTful_request.Bodys,RESTful_request.BodyNames)
        when i == 0 && j >
        when i == 0 && j > 0
            let body = cs_array_json(RESTful_request.Bodys,"Body")
        when i > 0 && j ==0
            let body = cs_record_json(RESTful_request.Body)
        otherwise
            let body = "{}"
    end case
    let l_uuid = cs_restfule_ins(header,body)
    if not cl_null(l_uuid) THEN
    let l_cmd = "/u1/usr/tiptop/fast/restful",
                    " --config /u1/usr/tiptop/fast/.restful.yaml",
                    " visit -i ",l_uuid
        run l_cmd
        let l_t = current
        update rest_file set rest13 = l_t where rest01 = l_uuid
    end if 
end function

# ??rest_file
function cs_restfule_ins(p_header,p_body)
    define p_header,p_body string
    define l_rest rest
    define l_sql string
    initialize l_rest.* to null
    
    # select uuid into l_rest.rest01 from uuid
    let l_rest.rest02 = RESTful_Address
    let l_rest.rest03 = RESTful_Url
    let l_rest.rest04 = p_header
    let l_rest.rest05 = p_body
    let l_rest.rest06 = current
    let l_rest.rest07 = g_user
    let l_rest.rest08 = g_prog
    let l_rest.rest11 = RESTful_Action
    insert into rest_file (
        rest02,rest03,rest04,rest05,rest06,
        rest07,rest08,rest11
    )values (
        l_rest.rest02,l_rest.rest03,l_rest.rest04,l_rest.rest05,l_rest.rest06,
        l_rest.rest07,l_rest.rest08,l_rest.rest11
    )
    if SQLCA.sqlcode THEN
        call cl_err("",sqlca.sqlcode,0)
        return ""
    end if
    select rest01 into l_rest.rest01 from rest_file
     where rest02 = l_rest.rest02
       and rest03 = l_rest.rest03
       and rest04 = l_rest.rest04
    #    and rest05 = l_rest.rest05
       and rest06 = l_rest.rest06
       and rest07 = l_rest.rest07
       and rest08 = l_rest.rest08
       and rest11 = l_rest.rest11
    return l_rest.rest01
end function
-- ???
function cs_restful_init()
    let RESTful_Address = "http://192.168.1.72:8888"
    # let RESTful_request = request.create()
    let RESTful_request.Header[1].key = "Content-Type"
    let RESTful_request.Header[1].value = "application/json"
    let RESTful_request.Header[2].key = "Accept"
    let RESTful_request.Header[2].value = "application/json"
    let RESTful_request.Header[3].key = "x-token"
    let RESTful_request.Header[3].value = "xxx"

end function

-----------------------------------------
    -- ??
function cs_restful_example()
{
  "ip": "192.168.1.72",
  "nickname": "tiptop",
  "system": "ERP",
  "username": "tiptop"
}
    define body record
        ip varchar(20),
        nickname varchar(20),
        system varchar(20),
        username varchar(20)
    end record 

    let body.ip = "192.168.1.19"
    let body.nickname = g_user
    let body.system = "ERP"
    let body.username = g_user

    let RESTful_Action = "POST"
    let RESTful_Url = "base/tpsip"
    let RESTful_request.Body = body

    call cs_do_restful()
end function
-----------------------------------------
