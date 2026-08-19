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
    call testrecord()
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
    call cl_record("warn","1.开立这是一个警告")
    call cl_record("warn","1.开立这是一个警告")

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
    call cl_record_html() returning l_str
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



function upd_bmb06()
    call i100sub_upd_bmb09('JL6012F2LR',	'L0')
    call i100sub_upd_bmb09('JL7016F2QR',	'Q0')
    call i100sub_upd_bmb09('KE6005F2BR',	'B0')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G0')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G1')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G2')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G3')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G4')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G5')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G6')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G7')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G8')
    call i100sub_upd_bmb09('JL8000F3GR'	,'G9')
    call i100sub_upd_bmb09('JW0288F2MR'	,'M0')
    call i100sub_upd_bmb09('JW0288F2MR'	,'M1')
    call i100sub_upd_bmb09('JW0288F2MR'	,'M2')
    call i100sub_upd_bmb09('JL8007F3LR'	,'L0')
    call i100sub_upd_bmb09('JL8007F3LR'	,'L1')
    call i100sub_upd_bmb09('JL8007F3LR'	,'L2')
    call i100sub_upd_bmb09('JL8007F3LR'	,'L3')
    call i100sub_upd_bmb09('JL8007F3LR'	,'L4')
    call i100sub_upd_bmb09('JL8007F3LR'	,'L5')
    call i100sub_upd_bmb09('JW0303R6LR'	,'L0')
    call i100sub_upd_bmb09('JW0303R6LR'	,'L1')
    call i100sub_upd_bmb09('JW0303R6LR'	,'L2')
    call i100sub_upd_bmb09('JW0303R6LR'	,'L3')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P0')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P1')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P2')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P3')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P4')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P5')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P6')
    call i100sub_upd_bmb09('JN0150F4PR'	,'P7')
    call i100sub_upd_bmb09('JL7015F2BR'	,'B0')
    call i100sub_upd_bmb09('JL7015F2BR'	,'B1')
    call i100sub_upd_bmb09('JL7015F2AR'	,'A0')
    call i100sub_upd_bmb09('JL7015F2AR'	,'A1')
    call i100sub_upd_bmb09('JL8062F3ZR'	,'Z0')
    call i100sub_upd_bmb09('JL8062F3ZR'	,'Z1')
    call i100sub_upd_bmb09('JL8062F3ZR'	,'Z2')
    call i100sub_upd_bmb09('JL8062F3ZR'	,'Z3')
    call i100sub_upd_bmb09('JL8078F2YR'	,'Y0')
    call i100sub_upd_bmb09('JL8078F2YR'	,'Y1')
    call i100sub_upd_bmb09('JL8078F2YR'	,'Y2')
    call i100sub_upd_bmb09('JL8078F2YR'	,'Y3')
    call i100sub_upd_bmb09('JL8078F2YR'	,'Y4')
    call i100sub_upd_bmb09('JL8078F2YR'	,'Y5')
    call i100sub_upd_bmb09('JL8056F3QR'	,'Q0')
    call i100sub_upd_bmb09('JL8056F3QR'	,'Q1')
    call i100sub_upd_bmb09('JL8056F3QR'	,'Q2')
    call i100sub_upd_bmb09('JL8056F3QR'	,'Q4')
    call i100sub_upd_bmb09('JL8056F3QR'	,'Q5')
    call i100sub_upd_bmb09('JL8056F3QR'	,'Q6')
    call i100sub_upd_bmb09('JL8056F3QR'	,'Q7')
    call i100sub_upd_bmb09('JL9009F3RR'	,'R0')
    call i100sub_upd_bmb09('JL9009F3RR'	,'R2')
    call i100sub_upd_bmb09('AA0644F4UR'	,'U0')
    call i100sub_upd_bmb09('JW0319R6MR'	,'M0')
    call i100sub_upd_bmb09('JL8110F3HR'	,'H0')
    call i100sub_upd_bmb09('JL8110F3HR'	,'H2')
    call i100sub_upd_bmb09('AA0645F3LR'	,'L0')
    call i100sub_upd_bmb09('JL7016F2QR'	,'Q0')
    call i100sub_upd_bmb09('JL8111F3FR'	,'F0')
    call i100sub_upd_bmb09('JW0319R6KR'	,'K0')
    call i100sub_upd_bmb09('JL8095F2QR'	,'Q0')
    call i100sub_upd_bmb09('JL8095F2QR'	,'Q1')
    call i100sub_upd_bmb09('JN0168F4SR'	,'S0')
    call i100sub_upd_bmb09('JN0168F4SR'	,'S1')
    call i100sub_upd_bmb09('JN0168F4SR'	,'S2')
    call i100sub_upd_bmb09('JN0168F4SR'	,'S3')
    call i100sub_upd_bmb09('BN0514F4GR'	,'G0')
    call i100sub_upd_bmb09('CB0954R6FR'	,'F0')
    call i100sub_upd_bmb09('AA0701F1HR'	,'H0')
    call i100sub_upd_bmb09('AA0669F1HR'	,'H0')
    call i100sub_upd_bmb09('JL8100R6KR'	,'K0')
    call i100sub_upd_bmb09('JL8100R6KR'	,'K1')
    call i100sub_upd_bmb09('JL8098F2GR'	,'G0')
    call i100sub_upd_bmb09('JL8098F2GR'	,'G1')
    call i100sub_upd_bmb09('JL8098F2GR'	,'G2')
    call i100sub_upd_bmb09('QM0001F3BR'	,'B0')
    call i100sub_upd_bmb09('JL8001F2FR'	,'F0')
    call i100sub_upd_bmb09('JL8076F2FR'	,'F0')
    call i100sub_upd_bmb09('JL8103F3LR'	,'L0')
    call i100sub_upd_bmb09('CB1007R4LR'	,'L0')
    call i100sub_upd_bmb09('JL8134F4AR'	,'A0')
    call i100sub_upd_bmb09('JL8097F2DR'	,'D0')
    call i100sub_upd_bmb09('BN0468F2HR'	,'H0')
    call i100sub_upd_bmb09('BN0468F2HR'	,'H1')
    call i100sub_upd_bmb09('JL1026F2ER'	,'E0')
    call i100sub_upd_bmb09('CB0948R6PR'	,'P0')
    call i100sub_upd_bmb09('CB0948R6RR'	,'R0')
    call i100sub_upd_bmb09('JL8128F3CR'	,'C0')
    call i100sub_upd_bmb09('JL6012F2LR'	,'L0')
    call i100sub_upd_bmb09('JL6012F2LR'	,'L1')
    call i100sub_upd_bmb09('JL6012F2LR'	,'L2')
    call i100sub_upd_bmb09('JL6012F2LR'	,'L3')
    call i100sub_upd_bmb09('JW0318F6JR'	,'J0')
    call i100sub_upd_bmb09('CB0974R6PR'	,'P0')
    call i100sub_upd_bmb09('QM0001F3AR'	,'A0')
    call i100sub_upd_bmb09('AA0701F1GR'	,'G0')
    call i100sub_upd_bmb09('BN0470F3MR'	,'M0')
    call i100sub_upd_bmb09('JN0168F4NR'	,'N0')
    call i100sub_upd_bmb09('JN0168F4NR'	,'N1')
    call i100sub_upd_bmb09('AA0669F1GR'	,'G0')
    call i100sub_upd_bmb09('AA0644F4VR'	,'V0')
    call i100sub_upd_bmb09('QE0002F3BR'	,'B0')
    call i100sub_upd_bmb09('QE0002F3BR'	,'B1')
    call i100sub_upd_bmb09('JL6021F2HR'	,'H0')
    call i100sub_upd_bmb09('JL6021F2HR'	,'H1')
    call i100sub_upd_bmb09('AA0662F2JR'	,'J0')
    call i100sub_upd_bmb09('JL6016F3WR'	,'W0')
    call i100sub_upd_bmb09('JL6016F3WR'	,'W1')
    call i100sub_upd_bmb09('JL6016F3WR'	,'W2')
    call i100sub_upd_bmb09('AA0663F2JR'	,'J0')
    call i100sub_upd_bmb09('KE6006F2ER'	,'E0')
    call i100sub_upd_bmb09('KE6006F2ER'	,'E1')
    call i100sub_upd_bmb09('KE6006F2ER'	,'E2')
    call i100sub_upd_bmb09('KE6006F2ER'	,'E3')
    call i100sub_upd_bmb09('JW0332R6GR'	,'G0')
    call i100sub_upd_bmb09('BN0519F3KR'	,'K0')
    call i100sub_upd_bmb09('QE0001F3BR'	,'B0')
    call i100sub_upd_bmb09('QE0001F3BR'	,'B1')
    call i100sub_upd_bmb09('JL0239F4PR'	,'P0')
    call i100sub_upd_bmb09('JW0332R6HR'	,'H0')
    call i100sub_upd_bmb09('JW0332R6HR'	,'H1')
    call i100sub_upd_bmb09('JW0308R6FR'	,'F0')
    call i100sub_upd_bmb09('JW0303R6MR'	,'M0')
    call i100sub_upd_bmb09('KE6001F2NR'	,'N0')
    call i100sub_upd_bmb09('KE6001F2NR'	,'N1')
    call i100sub_upd_bmb09('KE6001F2NR'	,'N2')
    call i100sub_upd_bmb09('JL8075F3JR'	,'J0')
    call i100sub_upd_bmb09('JL8075F3JR'	,'J1')
    call i100sub_upd_bmb09('JL8075F3JR'	,'J2')
    call i100sub_upd_bmb09('JL8075F3JR'	,'J3')
    call i100sub_upd_bmb09('JL8075F3JR'	,'J4')

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
