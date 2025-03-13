import libuid
# import libqrcodegen
import libqrbygo
import os
database ds 
 

function main() 
    define l_shortid varchar(40) 
    define l_dat varchar(40) 
    define i integer 
    define j varchar(1000)

    database forewin

    call    cl_err("xxx-24080792","csf-134",1)
    return

    call DelMesUseNoR("darct") returning i,l_dat
    return
    
    call qrgenerate("darcy","/u1/out/qrcode.png") returning i

    return

    call cl_progress_bar(10)
    call cl_progressing(10)
    sleep 1
    call cl_progressing(9)
    sleep 1
    call cl_progressing(8)
    sleep 1
    call cl_progressing(7)
    sleep 1
    call cl_progressing(6)
    sleep 1
    call cl_progressing(5)
    sleep 1
    call cl_progressing(4)
    sleep 1
    call cl_progressing(3)
    sleep 1
    call cl_progressing(2)
    sleep 1
    call cl_progressing(1)
    sleep 1
    call cl_progressing(0)

    call cws_create_asfi514_sfp01()
    

    call getMesktReason("MKT-240100001") returning i,j
    call getMesktReasonR("MKT-24010001") returning l_shortid,l_dat,j

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
    open crt_asfi514_1c using 'MRE'

    # 2. 取最大编码
    let l_chr = sfmt("MRE-%1%2",year(today) mod 100 using '&&',month(today) using '&&') 
    let l_chr = l_chr,"%"
    select max(sfp01) into l_sfp01 from sfp_file
     where sfp01 like l_chr
    
    if cl_null(l_sfp01) then
        let l_new_no = 0
    else
        let l_new_no = cws_create_asfi514_decode(l_sfp01[9,12])
    end if
    let l_sfp01 =  sfmt("MRE-%1%2%3",
            year(today) mod 100 using '&&',
            month(today) using '&&',
            cws_create_asfi514_encode(l_new_no+1))

    # 3. 取最新编码并生成单头

    commit work
end function


# 将10进制转为36进制
function cws_create_asfi514_encode(p_int)
    define p_int,l_re    integer
    define l_chr    varchar(10)

    if p_int = 0 then 
        return '0'
    end if

    while p_int > 0
        let l_re = p_int mod 36
        let l_chr = cws_create_asfi514_encodeDigit(l_re),l_chr
        let p_int = p_int / 36
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

function qrcode_print()
    define l_sql string

    let l_sql = "imm11.imm_file.imm11,imm12.imm_file.imm12,",
                 "imm13.imm_file.imm13,imm09.imm_file.imm09,",
                 "imm01.imm_file.imm01,imm02.imm_file.imm02,",
                 "imm07.imm_file.imm07,imn04.imn_file.imn04,",
                 "imn05.imn_file.imn05,imn06.imn_file.imn06,",
                 "imn15.imn_file.imn15,imn16.imn_file.imn16,",
                 "imn17.imn_file.imn17,imn02.imn_file.imn02,",
                 "imn09.imn_file.imn09,imn20.imn_file.imn20,",
                 "imn10.imn_file.imn10,imn29.imn_file.imn29,",
                 "imn03.imn_file.imn03,ima02.ima_file.ima02,", 
                 "ima021.ima_file.ima021,imn28.imn_file.imn28,", 
                 "azf03.azf_file.azf03,immuser.imm_file.immuser,",
#                 "l_str.type_file.chr1000"      #No.FUN-860026
                 "l_str.type_file.chr1000,flag.type_file.num5,",  #No.FUN-860026    #No.FUN-BA0078 add 2,
                 "sign_type.type_file.chr1, sign_img.type_file.blob,", #簽核方式, 簽核圖檔    #No.FUN-BA0078 add
                 "sign_show.type_file.chr1, sign_str.type_file.chr1000" #是否顯示簽核資料(Y/N) #No.FUN-BA0078 add #簽核字串 #No.TQC-C10034 add
               #   darcy:2024/04/16 add s---
                  ,",qrcode_head.type_file.blob,",
                  "qrcode_detail.type_file.blob"
               #   darcy:2024/04/16 add e---
end function
