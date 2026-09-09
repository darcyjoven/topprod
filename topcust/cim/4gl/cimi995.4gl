import JAVA com.fourjs.fgl.lang.FglRecord

database ds

GLOBALS "../../../tiptop/config/top.global"
--type FglRecord  com.fourjs.fgl.lang.FglRecord


main

OPTIONS                               #改變一些系統預設值
   FORM LINE       FIRST + 2,         #畫面開始的位置
   MESSAGE LINE    LAST,              #訊息顯示的位置
   PROMPT LINE     LAST,              #提示訊息的位置
   INPUT NO WRAP                      #輸入的方式: 不打轉
DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("CIM")) THEN
       EXIT PROGRAM
    END IF
    --call testid()
    call cimp500()
    --call testrecord()
    --call testdatetime()
    --call txml()
    --call tescape()
    --call test_JSON()
    --call cs_json_example()
     --call saeci100_csmi134('JL8091R6MR')
    --call upd_bmb06()
    --call cpmp252()
    --call cecq034()
    --call doaction()
    --call remark()
    --call cbmr002()
end main

--
function testid()
    define l_id     varchar(100)
    define l_str    varchar(10)
    define i integer

    let l_str = "1"
    for i = 1 to 10
        let l_id = cl_2base62(l_str)
        let l_str = l_str , "1"
    end for


    let l_id = cl_short_id()
    let l_id = cl_uuid()
    --let l_id = cl_uid_oracel()
    let l_id = cl_2base62(10086)
    let l_id = cl_uuid_go()
end function

--
function cimp500()
    define l_dat    integer

    for l_dat = 1 to 31
        call scimp500(mdy(8,l_dat,2026),'normal','N',true,true)
    end for

end function

--
function testrecord()
    define i,j    integer
    define l_str  string

    call cl_record_init("这是一个测试用例")

    call cl_record_card("单据编号:","doc-26070091")
    call cl_record_card("时间：",current)
    call cl_record_card("人员：","tiptop")

    call cl_record_header("1.开立")
    call cl_record("info","1.开立没有问题，执行完成")
    call cl_record("info","1.开立没有问题，执行完成")

    call cl_record_header("2.修改")
    call cl_record("info","2.修改没有问题，执行完成")
    call cl_record("info","2.修改没有问题，执行完成")
    call cl_record("warn","2.修改这是一个警告")
    call cl_record("warn","2.修改这是一个警告")

    call cl_record_header("3.审核")
    call cl_record("info","3.审核没有问题，执行完成")
    call cl_record("info","3.审核没有问题，执行完成")
    call cl_record("error","3.审核这是一个报错")
    call cl_record("warn","3.审核这是一个警告")
    call cl_record("warn","3.审核这是一个警告")

    call cl_record_header("4.抛转")
    call cl_record("info","4.抛转没有问题，执行完成")
    call cl_record("warn","4.抛转这是一个警告")
    call cl_record("warn","4.抛转这是一个警告")
    call cl_record("info","4.抛转没有问题，执行完成")
    call cl_record("info","4.抛转没有问题，执行完成")
    call cl_record("warn","4.抛转这是一个警告")

    call cl_record_store()
    call cl_record_html("error") returning l_str
    display l_str
end function

--
function testdatetime()
    define l_curr   datetime year to FRACTION
    define l_cnt    integer

    create temp table cimi995_tmp(
        dat     datetime year to FRACTION
    )
    let l_curr = current year to FRACTION
    let l_curr = current

    insert into cimi995_tmp values (l_curr)
    if sqlca.sqlcode then
        message ''
    end if

    select count(*) into l_cnt from cimi995_tmp

    select dat into l_curr from cimi995_tmp

end function

--
function cbmr002()
    define l_bom dynamic array of record
        design      varchar(100),
        confirm     varchar(100),
        cust_no     varchar(100),
        item        varchar(20),
        version     varchar(5),
        remark      varchar(1000),
        detail dynamic array of record
            seq         integer,
            order       varchar(10),
            work_no     varchar(10),
            name        varchar(100),
            desc        like ima_file.ima02,
            item        varchar(20),
            spec        like ima_file.ima021,
            sub_item    varchar(100),
            size        like ima_file.ima02,
            dosage      decimal(20,6),
            unit        varchar(10),
            type        varchar(20),
            remark      varchar(100)
        end record
    end record
    define i,j  integer
    define l_n  om.DomNode
    define l_str    string

    declare cbmr001_cur1 cursor for
    select bmauser,bmamodu,ima02,bma01,max(ecu02) ecu02,imaud06
      from bma_file,ima_file,ecu_file
     where bma01 = ima01 and ecu01 = ima01 and ecu10 = 'Y' and ecuud02 = 'Y'
       and bma01 like 'AA0667%'
       group by bmauser,bmamodu,ima02,bma01,imaud06

    declare cbmr001_cur2 cursor from
    "select rownum,bmbud02,bmb09,bmbud05,ima02,bmb03,ima021,'' sub,bmbud06,bmb06/bmb07,bmb10,ima08,bmbud01
      from bmb_file,ima_file where bmb03 = ima01
       and bmb04 <= trunc(sysdate)
       and (bmb05 > trunc(sysdate) or bmb05 is null)
       and bmb01 = ? order by to_number(substr(bmbud02, 2, length(bmbud02)))"

    let i = 1
    foreach cbmr001_cur1 into l_bom[i].design thru l_bom[i].remark
        if sqlca.sqlcode then
            call cl_err('cbmr001_cur1',sqlca.sqlcode,1)
            exit foreach
        end if
        let j = 1
        foreach cbmr001_cur2 using l_bom[i].item into l_bom[i].detail[j].*
            if sqlca.sqlcode then
                call cl_err('cbmr001_cur2',sqlca.sqlcode,1)
                exit foreach
            end if
            let j = j + 1
        end foreach
        call l_bom[i].detail.deleteElement(j)
        let i = i +1
    end foreach
    call l_bom.deleteElement(i)
    let l_str = cl_json( base.typeinfo.create(l_bom))
    display l_str
    run "echo '"||l_str||"' >> /u1/out/darcy.json"
end function

--
function cecq034()
    let g_bgjob = 'Y'
    call scecq034_generate(2026,7,true)
end function

function cpmp252()
    let g_bgjob = 'Y'
    call scpmp252('PMT-26070001',false)
end function
--
function tescape()
    define p_str    string
    define i        integer
    define tmp      varchar(1)
    define tmpStr   string

    let p_str = "\"\n\u0007"
    for i = 1 to p_str.getLength()
        let tmp = p_str.substring(i,i)
        let tmpStr = p_str.substring(i,i)
    end for

end function

--
function txml()
    type demo record
        str string,
        dat date,
        bool boolean,
        varc   varchar(100),
        inter  interval DAY(5) TO MINUTE,
        datime datetime year to second,
        dec decimal(20,6),
        byt byte,
        txt text
    end record
    type lis dynamic array of demo
    define all record
        all1    string,
        all2    demo,
        all3    lis,
        all4    dynamic array with dimension 2 of demo,
        all5    record
            a   string,
            b   integer,
            c   demo,
            d   lis
        end record,
        all6    dynamic array of    string
    end record
    define list lis
    define cnt  integer
    define l_str string

    let all.all1 = 'all1'

    let all.all2.str  = 'all2.str"\t\n\r\f\\'
    let all.all2.dat  = mdy(1,2,2006)
    let all.all2.bool  = false
    let all.all2.varc  = 'all2.varc'
    let all.all2.inter  = "23423 12:34"
    let all.all2.datime  = current year to second
    let all.all2.dec  = 20.12345
    locate all.all2.byt in memory
    call all.all2.byt.readFile('/u1/usr/tiptop/仓库库存明细.xlsx')
    locate all.all2.txt in memory
    call all.all2.txt.readFile('/u1/usr/tiptop/ecb.sql')

    let all.all3[2].str  = 'all3[2].str'
    let all.all3[2].dat  = mdy(1,2,2006)
    let all.all3[2].bool  = false
    let all.all3[2].varc  = 'all3[2].varc'
    let all.all3[2].inter  = "23423 12:34"
    let all.all3[2].datime  = current year to second
    let all.all3[2].dec  = 20.12345
    locate all.all3[2].byt in memory
    call all.all3[2].byt.readFile('/u1/usr/tiptop/仓库库存明细.xlsx')
    locate all.all3[2].txt in memory
    call all.all3[2].txt.readFile('/u1/usr/tiptop/ecb.sql')

    let all.all4[1,2].str  = 'all4[1,2].str'
    let all.all4[1,2].dat  = mdy(1,2,2006)
    let all.all4[1,2].bool  = false
    let all.all4[1,2].varc  = 'all4[1,2].varc'
    let all.all4[1,2].inter  = "23423 12:34"
    let all.all4[1,2].datime  = current year to second
    let all.all4[1,2].dec  = 20.12345
    locate all.all4[1,2].byt in memory
    call all.all4[1,2].byt.readFile('/u1/usr/tiptop/仓库库存明细.xlsx')
    locate all.all4[1,2].txt in memory
    call all.all4[1,2].txt.readFile('/u1/usr/tiptop/ecb.sql')

    let all.all5.a = ''
    let all.all5.b = 2

    let all.all5.c.str  = 'all5.c.str'
    let all.all5.c.dat  = mdy(1,2,2006)
    let all.all5.c.bool  = false
    let all.all5.c.varc  = 'all5.c.varc'
    let all.all5.c.inter  = "23423 12:34"
    let all.all5.c.datime  = current year to second
    let all.all5.c.dec  = 20.12345
    locate all.all5.c.byt in memory
    call all.all5.c.byt.readFile('/u1/usr/tiptop/仓库库存明细.xlsx')
    locate all.all5.c.txt in memory
    call all.all5.c.txt.readFile('/u1/usr/tiptop/ecb.sql')

    let all.all5.d[2].str  = 'all5.d[2].str'
    let all.all5.d[2].dat  = mdy(1,2,2006)
    let all.all5.d[2].bool  = false
    let all.all5.d[2].varc  = 'all5.d[2].varc'
    let all.all5.d[2].inter  = "23423 12:34"
    let all.all5.d[2].datime  = current year to second
    let all.all5.d[2].dec  = 20.12345
    locate all.all5.d[2].byt in memory
    call all.all5.d[2].byt.readFile('/u1/usr/tiptop/仓库库存明细.xlsx')
    locate all.all5.d[2].txt in memory
    call all.all5.d[2].txt.readFile('/u1/usr/tiptop/ecb.sql')
    let all.all6[2] = 'string'

    let list[2].str  = 'list[2].str'
    let list[2].dat  = mdy(1,2,2006)
    let list[2].bool  = false
    let list[2].varc  = 'list[2].varc'
    let list[2].inter  = "23423 12:34"
    let list[2].datime  = current year to second
    let list[2].dec  = 20.12345
    locate list[2].byt in memory
    call list[2].byt.readFile('/u1/usr/tiptop/仓库库存明细.xlsx')
    locate list[2].txt in memory
    call list[2].txt.readFile('/u1/usr/tiptop/ecb.sql')

    let l_str = cl_json(base.typeinfo.create(all))
    let l_str = cl_json(base.typeinfo.create(list))
    let l_str = cl_json(base.typeinfo.create(cnt))

end function

function test_JSON()
    type demo record
        a string,
        b string,
        c dynamic array of string,
        d dynamic array of record
            a1 string,
            b1 string
        end record
    end record
    define l_list dynamic  array of demo
    define l_jlist FglRecord
    define l_str string

    let l_list[1].a = 'abc'
    let l_jlist = l_list[1]

    let l_str = cs_record_json(l_jlist)

end function





--
function doaction()
    if cl_action(g_prog,'MISC',1,'confirm','52948','',false,true) then
        message 'OK'
    end if
    if cl_action(g_prog,'MISC',2,'post','52948','',true,false) then
        message 'OK'
    end if
    if cl_action(g_prog,'MISC',3,'xxx','52948','',true,true) then
        message 'OK'
    end if

    if cl_action(g_prog,'MISC',2,'post','','',true,false) then
        message 'OK'
    end if

end function
--
function remark()
    call cl_remark('aeci100','xybtest',0)
    call cl_remark_chk('aeci100','xybtest',0)
    call cl_remark_show('aeci100','xybtest',0)
end function
