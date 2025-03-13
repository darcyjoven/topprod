# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: csfq020.4gl
# Descriptions...: 料件领用查询
# Date & Author..: darcy:2024/05/07


database ds
globals "../../../tiptop/config/top.global"
# type s---
type tlf record
    tlf01       like tlf_file.tlf01,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima02,
    ima06       like ima_file.ima06,
    ima06_desc  like imz_file.imz02,
    tlf06       like tlf_file.tlf06,
    tlf905      like tlf_file.tlf905,
    tlf906      like tlf_file.tlf906,
    tlf13       like tlf_file.tlf13,
    tlf902      like tlf_file.tlf902,
    tlf903      like tlf_file.tlf903,
    tlf904      like tlf_file.tlf904,
    tlf10       like tlf_file.tlf10,
    tlf11       like tlf_file.tlf11,
    tlf12       like tlf_file.tlf12,
    ima25       like ima_file.ima25,
    ccc23       like ccc_file.ccc23,
    price       varchar(100),
    amt         like ccc_file.ccc23,
    tlf07       like tlf_file.tlf07,
    tlf08       like tlf_file.tlf08,
    #darcy:2024/06/25 add s---
    gen01       like gen_file.gen01,
    gen02       like gen_file.gen02,
    gem01       like gem_file.gem01,
    gem02       like gem_file.gem02
    #darcy:2024/06/25 add e---
    end record
type ima record
    imz01       like imz_file.imz01,
    imz02       like imz_file.imz02,
    sum         like ccc_file.ccc23,
    amt_1       like ccc_file.ccc23
    end record
# type e---

define g_tlf,g_tlf_excel dynamic array of tlf
define g_ima,g_ima_excel dynamic array of ima 

define g_rec_b,g_cnt,l_ac,l_ac_t integer
define g_wc,g_cmd string

MAIN
    define   p_row,p_col   like type_file.num5          #no.fun-680121 smallint
    options                               #改變一些系統預設值
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CIM")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time #no.fun-b30211 
    open window cimq020_w at p_row,p_col with form "cim/42f/cimq020"
            attribute (style = g_win_style clipped) #no.fun-580092 hcn
        
    call cl_ui_init()

    call cimq020_crt()
    call cimq020_q()
    call cimq020_menu()

    close window cimq020_w                 #結束畫面
    call cl_used(g_prog,g_time,2) returning g_time 

END MAIN

function cimq020_cs()

    let g_action_choice = ""

    dialog
        construct g_wc on
            tlf01,ima06,tlf06,tlf905,tlf906,tlf902,tlf903,tlf904,tlf10,tlf11
            from  
            s_tlf[1].tlf01,s_tlf[1].ima06,s_tlf[1].tlf06,s_tlf[1].tlf905,s_tlf[1].tlf906,
            s_tlf[1].tlf902,s_tlf[1].tlf903,s_tlf[1].tlf904,s_tlf[1].tlf10,s_tlf[1].tlf11
        end construct 

        on action controlp
            # 开窗 
        
        on action accept
            let g_action_choice="accept"
            exit dialog

        on action cancel
            let g_action_choice="exit"
            exit dialog

        on action exit
            let g_action_choice="exit"
            exit dialog

        on action qbe_select
            call cl_qbe_select()

        on action qbe_save
            call cl_qbe_save()
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        
        on action about
            call cl_about()
        
        on action controlg
            call cl_cmdask()
        
        on action help
            call cl_show_help()
    end dialog

    if int_flag or g_action_choice = "exit" then    #mod-4b0238 add 'exit'
        return
    end if
end function

function cimq020_menu()
    while true
        call cimq020_bp()
        case g_action_choice
            when "help"
            call cl_show_help()
 
            when "exit"
                exit while
            when "close"
                exit while
    
            when "controlg"
                call cl_cmdask()

            when "query"
                if cl_chk_act_auth() then
                    call cimq020_q()
                end if
            
            when "exporttoexcel"
                # 导出excel
                if cl_chk_act_auth() then 
                    call cl_download_by_explorer(
                        cl_expexcel2(
                            "s_tlf",base.typeinfo.create(g_tlf_excel),
                            "s_ima",base.typeinfo.create(g_ima)
                        ))
                    
                end if
        end case
    end while
end function

function cimq020_q()

    let g_rec_b = 0
    
    clear form
    display '' to cnt    

    message ""

    call cimq020_cs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call cimq020_show()
    end if
    message ""

end function

function cimq020_show()
    call cimq020_b_fill()
end function

function cimq020_b_fill()
    define l_sql string
    define l_sum,l_amt like tlf_file.tlf221
    define l_yy,l_mm,l_cnt integer #darcy:2024/06/30 add

    #darcy:2024/06/30 add s---
    select ccz01,ccz02 into l_yy,l_mm from ccz_file
    select count(*) into l_cnt from ccc_file where ccc02 = l_yy and ccc03 = l_mm
    if l_cnt = 0 or cl_null(l_cnt) then
        let l_mm = iif(l_mm==1,12,l_mm-1)
        let l_yy = iif(l_mm=01,l_yy-1,l_yy)
    end if 
    #darcy:2024/06/30 add e---
    
    if g_wc = " 1=1" then
        call cl_err("","9046",1)
        return
    end if

    delete from cimq020_tmp

    let l_sql = "insert into cimq020_tmp select tlf01,ima02,ima021,ima06,imz02 ima06_desc,",
                "       tlf06,tlf905,tlf906,tlf13,tlf902,",
                "       tlf903,tlf904,trunc(tlf10*tlf60*tlf907,3) tlf10,ima25 tlf11,tlf12,",
                "       ima25,ima53 ccc23,'2' price,0 amt,tlf07,tlf08",
                "       ,'','','',''    ", #darcy:2024/06/25 add
                " from tlf_file left join ima_file on ima01 = tlf01 ",
                "      left join imz_file on imz01 = ima06 ",
                " where tlf13 !='aimt324' ",
                "   and (tlf907='-1' or (tlf907 = '1' and tlf13 like 'asfi5%' ) )",
                "   and ",g_wc
                #" order by ima06,tlf01,tlf06,tlf905,tlf906,"
    prepare cimq020_ins_tmp from l_sql
    execute cimq020_ins_tmp

    #darcy:2024/06/25 add s---
    # 取制单人和部门
    let l_sql = "merge into cimq020_tmp a using (",
                " select unique tlf905,coalesce(ina11,sfp16,rvu07,oga14) gen01, ",
                "        coalesce(ina04,sfp07,rvu06,oga15) gem01",
                "  from cimq020_tmp",
                " left join ina_file on ina01 = tlf905 and tlf13 like 'aimt%'",
                " left join sfp_file on sfp01 = tlf905 and tlf13 like 'asfi%'",
                " left join rvu_file on rvu01 = tlf905 and tlf13 like 'apmt%'",
                " left join oga_file on oga01 = tlf905 and tlf13 like 'axmt%') b",
                " on (a.tlf905 = b.tlf905) ",
                " when matched then update set a.gen01 = b.gen01 , a.gem01 = b.gem01"
    prepare cimq020_upd_gen from l_sql
    execute cimq020_upd_gen

    let l_sql = "merge into cimq020_tmp a using (",
                "     select unique tlf905,a.gen01,b.gen02,a.gem01,c.gem02 from cimq020_tmp a,gen_file b,gem_file c",
                "      where a.gen01 = b.gen01 and a.gem01 = c.gem01 ",
                " )b on(a.tlf905 = b.tlf905)",
                " when matched then update set a.gen02 = b.gen02 ,a.gem02 = b.gem02"
    prepare cimq020_upd_gem from l_sql
    execute cimq020_upd_gem

    let l_sql = "merge into cimq020_tmp a using (",
                "     select tlf905, min(eca02) eca02 from cimq020_tmp,sfe_file,ecd_file,eca_file",
                "      where tlf905 like 'MRE%' and sfe02=tlf905 and ecd01 = sfe14 and eca01 = ecd07 ",
                "      group by tlf905",
                " ) b on (a.tlf905 = b.tlf905)",
                " when matched then update set a.gem02 = b.eca02"
    prepare cimq020_upd_gem2 from l_sql
    execute cimq020_upd_gem2
    #darcy:2024/06/25 add e---

    # 取成本单价
    # 1.标准成本单价
    let l_sql = " merge into cimq020_tmp a",
                " using ( select ccc01, ccc23",
                "   from ccc_file",
                #darcy:2024/06/30 mod s---
                -- " where ccc02 = (select ccz01 from ccz_file)",
                -- "   and ccc03 = (select ccz02 from ccz_file)",
                " where ccc02 = ",l_yy ,
                "   and ccc03 = ",l_mm ,
                #darcy:2024/06/30 mod e---
                "   and ccc23 > 0 ) b",
                " on (a.tlf01=b.ccc01)",
                " when matched then update set a.ccc23 = b.ccc23,a.price='1',a.amt=b.ccc23*a.tlf10"
    prepare cimq020_upd_tmp1 from l_sql
    execute cimq020_upd_tmp1

    # 2.取最近采购单价
    # 默认就是采购单价

    # 3.单价小于等于0的更新为取不到单价
    let l_sql = "update cimq020_tmp ",
                "   set ccc23 = 0 , price ='0', amt = 0 ",
                " where ccc23 <= 0 "
    prepare cimq020_upd_tmp2 from l_sql
    execute cimq020_upd_tmp2

    let l_sql = " select tlf01,ima02,ima021,ima06,ima06_desc,",
                "       tlf06,tlf905,tlf906,tlf13,tlf902,",
                "       tlf903,tlf904,tlf10,tlf11,tlf12,",
                "       ima25, ccc23,price,amt,tlf07,tlf08,gen01,gen02,gem01,gem02",
                " from cimq020_tmp", 
                " order by ima06,tlf01,tlf06,tlf905,tlf906"

    prepare cimq020_tlf_p1 from l_sql
    declare cimq020_tlf_c1 cursor for cimq020_tlf_p1

    let g_cnt = 1
    call g_tlf_excel.clear()
    call g_tlf.clear()
    foreach cimq020_tlf_c1 into g_tlf_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq020_tlf_c1",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= g_max_rec + 1 then
            let g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_tlf_excel.deleteElement(g_cnt)
    call g_tlf.deleteElement(g_cnt) 
    
    # 汇总页面
    let g_cnt = 1
    let l_sum = 0
    let l_amt = 0
    # 原材料
    # M.
    let l_sql = " select ima06 imz01,ima06_desc imz02,sum(tlf10),sum(amt) amt_1",
                " from cimq020_tmp", 
                " where ima06 like 'M.%' ",
                " group by ima06 ,ima06_desc  order by 1"

    prepare cimq020_tlf_p2 from l_sql
    declare cimq020_tlf_c2 cursor for cimq020_tlf_p2

    call g_ima.clear()
    foreach cimq020_tlf_c2 into g_ima[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq020_tlf_c2",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_sum = l_sum + g_ima[g_cnt].sum
        let l_amt = l_amt + g_ima[g_cnt].amt_1
        let g_cnt = g_cnt + 1
    end foreach
    let g_ima[g_cnt].imz01 = ""
    let g_ima[g_cnt].imz02 = "原材料 合计:"
    let g_ima[g_cnt].sum = l_sum
    let g_ima[g_cnt].amt_1 = l_amt
    # 器件
    # E.
    let l_sum = 0 let l_amt = 0 let g_cnt = g_cnt + 1
    let l_sql = " select ima06 imz01,ima06_desc imz02,sum(tlf10),sum(amt) amt_1",
                " from cimq020_tmp", 
                " where ima06 like 'E.%' ",
                " group by ima06 ,ima06_desc  order by 1"

    prepare cimq020_tlf_p3 from l_sql
    declare cimq020_tlf_c3 cursor for cimq020_tlf_p3

    foreach cimq020_tlf_c3 into g_ima[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq020_tlf_c3",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_sum = l_sum + g_ima[g_cnt].sum
        let l_amt = l_amt + g_ima[g_cnt].amt_1
        let g_cnt = g_cnt + 1
    end foreach
    let g_ima[g_cnt].imz01 = ""
    let g_ima[g_cnt].imz02 = "器件 合计:"
    let g_ima[g_cnt].sum = l_sum
    let g_ima[g_cnt].amt_1 = l_amt
    # 药水
    # H.ZX    # H.JX    # H.SX    # H.HX
    let l_sum = 0 let l_amt = 0 let g_cnt = g_cnt + 1
    let l_sql = " select ima06 imz01,ima06_desc imz02,sum(tlf10),sum(amt) amt_1",
                " from cimq020_tmp", 
                " where ima06 in('H.ZX','H.JX','H.SX','H.HX') ",
                " group by ima06, ima06_desc  order by 1"

    prepare cimq020_tlf_p4 from l_sql
    declare cimq020_tlf_c4 cursor for cimq020_tlf_p4

    foreach cimq020_tlf_c4 into g_ima[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq020_tlf_c4",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_sum = l_sum + g_ima[g_cnt].sum
        let l_amt = l_amt + g_ima[g_cnt].amt_1
        let g_cnt = g_cnt + 1
    end foreach
    let g_ima[g_cnt].imz01 = ""
    let g_ima[g_cnt].imz02 = "药水 合计:"
    let g_ima[g_cnt].sum = l_sum
    let g_ima[g_cnt].amt_1 = l_amt
    # 耗材
    # H.HC    # H.FC    # H.BC
    let l_sum = 0 let l_amt = 0 let g_cnt = g_cnt + 1
    let l_sql = " select ima06 imz01,ima06_desc imz02,sum(tlf10),sum(amt) amt_1",
                " from cimq020_tmp", 
                " where ima06 in('H.HC','H.BC','H.FC') ",
                " group by ima06, ima06_desc  order by 1"

    prepare cimq020_tlf_p5 from l_sql
    declare cimq020_tlf_c5 cursor for cimq020_tlf_p5

    foreach cimq020_tlf_c5 into g_ima[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq020_tlf_c5",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_sum = l_sum + g_ima[g_cnt].sum
        let l_amt = l_amt + g_ima[g_cnt].amt_1
        let g_cnt = g_cnt + 1
    end foreach
    let g_ima[g_cnt].imz01 = ""
    let g_ima[g_cnt].imz02 = "耗材 合计:"
    let g_ima[g_cnt].sum = l_sum
    let g_ima[g_cnt].amt_1 = l_amt

end function

function cimq020_bp()
    let g_action_choice = " "
    call cl_set_act_visible("accept,cancel", false)
    dialog
        display array g_tlf to s_tlf.*
            before display
                display g_tlf_excel.getlength() to cnt
            before row
                let l_ac = arr_curr()
                display l_ac to curr
        end display

        display array g_ima to s_ima.*
            before display
                display g_ima.getlength() to cnt
            before row
                let l_ac = arr_curr()
                display l_ac to curr
        end display

        on action help
            let g_action_choice="help"
            exit dialog
        on action exit
            let g_action_choice="exit"
            exit dialog
        on action controlg
            let g_action_choice="controlg"
            exit dialog
        on action query
            let g_action_choice="query"
            exit dialog 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        on action close
            let g_action_choice = 'close'
            exit dialog
    end dialog
    call cl_set_act_visible("accept,cancel", true)

end function

function cimq020_crt()
drop table cimq020_tmp
create temp table cimq020_tmp(
tlf01       varchar(40),
ima02       varchar(400),
ima021      varchar(400),
ima06       varchar(40),
ima06_desc  varchar(400),
tlf06       DATE,
tlf905      varchar(40),
tlf906      integer,
tlf13       varchar(20),
tlf902      varchar(20),
tlf903      varchar(20),
tlf904      varchar(24),
tlf10       decimal(20,6),
tlf11       varchar(4),
tlf12       decimal(20,8),
ima25       varchar(4),
ccc23       decimal(20,6),
price       varchar(100),
amt         decimal(20,6),
tlf07       date,
tlf08       varchar(8),
gen01       varchar(20),
gen02       varchar(200),
gem01       varchar(20),
gem02       varchar(200)
)
end function
