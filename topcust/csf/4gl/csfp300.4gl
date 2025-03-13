# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: csfp300.4gl
# Descriptions...: 依照订单拆分RUN CARD
# Date & Author..:darcy:2023/08/05

database ds

globals "../../../tiptop/config/top.global"

type sfb record
    check1      varchar(1),
    sfb22       like sfb_file.sfb22,
    sfb221      like sfb_file.sfb221,
    sfb01       like sfb_file.sfb01,
    sfb86       like sfb_file.sfb86,
    sfb05       like sfb_file.sfb05,
    sfb06       like sfb_file.sfb06,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021,
    sfb13       like sfb_file.sfb13,
    sfb15       like sfb_file.sfb15,
    sfb08       like sfb_file.sfb08,
    ima55       like ima_file.ima55,
    imaud07     like ima_file.imaud07,
    imaud10     like ima_file.imaud10,
    tc_sma04    like tc_sma_file.tc_sma04,
    ynum        like type_file.num15_3,
    cnum        like type_file.num15_3,
    clot        like type_file.num15_3,
    snum        like type_file.num15_3
end record
type sfb1 record
    check2        varchar(1),
    sfb22_1       like sfb_file.sfb22,
    sfb221_1      like sfb_file.sfb221,
    sfb01_1       like sfb_file.sfb01,
    sfb86_1       like sfb_file.sfb86,
    sfb05_1       like sfb_file.sfb05,
    sfb06_1       like sfb_file.sfb06,
    ima02_1       like ima_file.ima02,
    ima021_1      like ima_file.ima021,
    sfb13_1       like sfb_file.sfb13,
    sfb15_1       like sfb_file.sfb15,
    sfb08_1       like sfb_file.sfb08,
    ima55_1       like ima_file.ima55,
    imaud07_1     like ima_file.imaud07,
    imaud10_1     like ima_file.imaud10,
    tc_sma04_1    like tc_sma_file.tc_sma04,
    ynum_1        like type_file.num15_3,
    cnum_1        like type_file.num15_3,
    clot_1        like type_file.num15_3,
    snum_1        like type_file.num15_3
end record
type shm record
    shm01       like shm_file.shm01,
    sfb22_2     like sfb_file.sfb22,
    sfb221_2    like sfb_file.sfb221,
    shm012      like shm_file.shm012,
    sfb86_2     like sfb_file.sfb86,
    ta_shm05    like shm_file.ta_shm05,
    ima02_2     like ima_file.ima02,
    ima021_2    like ima_file.ima021,
    shm05       like shm_file.shm05,
    shm06       like shm_file.shm06,
    shm08       like shm_file.shm08,
    shm09       like shm_file.shm09,
    shm10       like shm_file.shm10,
    shm11       like shm_file.shm11,
    shm111      like shm_file.shm111,
    shm12       like shm_file.shm12,
    shmacti     like shm_file.shmacti,
    shmuser     like shm_file.shmuser,
    shmdate     like shm_file.shmdate
end record

define g_argv1,g_argv2,g_argv3 string
define g_wc1,g_wc2,g_wc3,g_sql string
define g_b_flag,g_action_choice varchar(200)
define l_ac,g_cnt,g_rec_b integer

define g_sfb dynamic array of sfb
define g_sfb1 dynamic array of sfb1
define g_shm dynamic array of shm

main
    options
        input no wrap
    defer interrupt

    if (not cl_user()) then
        exit program
    end if
    whenever error call cl_err_msg_log

    if (not cl_setup("CSF")) then
        exit program
    end if

    call cl_used(g_prog,g_time,1) returning g_time

    let g_argv1 = arg_val(1)
    let g_argv2 = arg_val(2)
    let g_argv3 = arg_val(3)
    if not cl_null(g_argv1) or not cl_null(g_argv2) or not cl_null(g_argv3) then
        # call csfp300_process(g_argv1,g_argv2,g_argv3)
    end if

    open window csfp300_w at 1,1 with form "csf/42f/csfp300"
        attribute (style = g_win_style clipped)
    call cl_ui_init()
    call csfp300_init()
    call csfp300_curs()
    if g_action_choice = "exit" then
        return
    end if
    call csfp300_menu()
    call cl_used(g_prog,g_time,2) returning g_time
end main
# 初始化
function csfp300_init()
    define l_field,l_value string
    define l_tc_sma03       varchar(20)
    define l_tc_sma06       varchar(200)
    call csfp300_crt_temp()
    

    declare csfp300_imaud06_cl cursor for
        select tc_sma03,tc_sma06 from tc_sma_file 
        where tc_sma01='csmi102' and tc_sma02='aimi100'
            and tc_sma20 ='Y'
        order by tc_sma03
    
    foreach csfp300_imaud06_cl into l_tc_sma03,l_tc_sma06
        if sqlca.sqlcode then
            call cl_err('csfp300_imaud06_cl',sqlca.sqlcode,1)
            exit foreach
        end if
        if l_tc_sma03= "0" then
            let l_value = "0"
            let l_field = l_tc_sma03,".",l_tc_sma06
        else
            let l_tc_sma03 = cl_replace_str(l_tc_sma03," ","")
            let l_field = l_field ,",",l_tc_sma03,".",l_tc_sma06
            let l_value = l_value ,",",l_tc_sma03
        end if
    end foreach

    call cl_set_combo_items("tc_sma04",l_value,l_field)

    let g_sql = "select * from sfb_file where sfb01 in (select sfb01 from csfp300_sfb1) for update nowait"
    declare csfp300_page2_1 cursor from g_sql
end function
# 查询条件输入
function csfp300_curs()
    clear form

    let g_wc1 = ""
    let g_wc2 = ""
    let g_wc3 = ""
    call cl_set_act_title("cancel_input","退出")
    call cl_set_act_title("next_step","下一步")
    call cl_set_act_title("previous_step","重新查询")
    call cl_set_act_visible("accept,cancel",true)
    dialog
        construct by name g_wc1 on oea01,oea02,oea03,oea14,oea10
            before construct
        end construct

        construct by name g_wc2 on oeb04,oeb12
            before construct
        end construct

        construct g_wc3 on sfb01,sfb81,sfb44 from sfb01_q,sfb81,sfb44
            before construct
        end construct

        on action controlp

        on action accept
            if g_wc1 = " 1=1" and g_wc2 = " 1=1" and g_wc3 = " 1=1" then
                call cl_err("","csf-112",1)
                continue dialog
            end if
            let g_action_choice="next_step"
            let g_b_flag = "Page1"
            exit dialog

        on action cancel
            let g_action_choice="exit"
            exit dialog

        on action exit
            let g_action_choice="exit"
            exit dialog
        
        on action cancel_input
            let g_action_choice = "exit"
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
    call cl_set_act_visible("accept,cancel",false)
    if g_action_choice != "exit" then
        call csfp300_page1()
    end if
end function

function csfp300_menu()
    while true
        case g_b_flag
            when 'Page2'
                call csfp300_sfb1_bp()
            when 'Page3'
                call csfp300_shm_bp()
            otherwise
                call csfp300_sfb_bp()
        end case
        label continueCase:
        case g_action_choice
            when "next_step"
                case g_b_flag
                    when "Page1"
                        # 根据page1产生page2资料
                        let g_b_flag = "Page2"
                        call csfp300_page2()
                    when "Page2"
                        # 根据page2产生page3资料
                        let g_b_flag = "Page3"
                        call csfp300_page3()
                end case
                continue while
            when "previous_step"
                case g_b_flag
                    when "Page1"
                        if cl_confirm("csf-114") then
                            # 重新查询
                            call csfp300_curs()
                            if g_action_choice = "exit" then
                                exit while
                            end if
                        end if
                    when "Page2"
                        if not cl_confirm("csf-113") then
                            continue while
                        end if
                        # 重新显示page1资料 
                        call g_sfb1.clear()
                        delete from csfp300_sfb1
                        let g_b_flag = "Page1"
                end case
                let g_action_choice = ""
                continue while
            when "query"
                # 初始化
                # 查询之前，将查询条件，中间表都清空
                call csfp300_clear()
                # 查询
                call csfp300_curs()
                # exit while
            when "exit"
                exit while
            when "close"
                exit while
            when "exporttoexcel"
                call csfp300_export_excel()
            when "controlg"
                call cl_cmdask()
        end case
    end while
end function

function csfp300_sfb_bp()
    define i,j integer
    let g_b_flag = 'Page1'
    call cl_set_comp_visible("Page1",true)
    call cl_set_comp_visible("Page2,Page3",false)
    call cl_set_act_visible("accept,cancel",true)
    call cl_set_act_title("cancel_input","重新查询")
    call cl_set_act_title("next_step","下一步")
    call cl_set_act_title("previous_step","重新查询")
    input array g_sfb without defaults from s_sfb.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before row
            let l_ac = arr_curr()

        after field cnum
            if g_sfb[l_ac].cnum > g_sfb[l_ac].sfb08 then
                let g_sfb[l_ac].cnum = g_sfb[l_ac].sfb08
                call cl_err('数量不得大于可拆分数量',"!",0)
                next field cnum
            end if
            if g_sfb[l_ac].cnum / g_sfb[l_ac].clot / g_sfb[l_ac].imaud10 > 100 then
                if not cl_confirm("csf-118") then
                    next field clot
                end if
            end if

        after field clot
            if g_sfb[l_ac].clot <= 0 then
                call cl_err('拆分LOT数量需要大于0',"!",0)
                next field clot
            end if
            if g_sfb[l_ac].cnum / g_sfb[l_ac].clot / g_sfb[l_ac].imaud10 > 100 then
                if not cl_confirm("csf-118") then
                    next field clot
                end if
            end if

        on change clot
            if not cl_null(g_sfb[l_ac].clot) then
                let g_sfb[l_ac].snum = g_sfb[l_ac].clot * g_sfb[l_ac].imaud10
            end if

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="previous_step"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
            
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
        on action cancel
            let g_action_choice = 'previous_step'
            exit input
        on action accept
            let g_action_choice = "next_step"
            exit input
        on action next_step
            let g_action_choice = "next_step"
            exit input
        on action previous_step
            let g_action_choice = 'previous_step'
            exit input
        on action cancel_input
            let g_action_choice = "query"
            exit input
         

        on action select_all
            for i = 1 to g_sfb.getlength()
                let g_sfb[i].check1 = 'Y'
            end for
        on action inverse
            for i = 1 to g_sfb.getlength()
                let g_sfb[i].check1 = iif(g_sfb[i].check1=='Y','N','Y')
            end for
    end input
    call cl_set_act_visible("accept,cancel",false)
end function

function csfp300_sfb1_bp()
    define i integer
    call cl_set_comp_visible("Page2",true)
    call cl_set_comp_visible("Page1,Page3",false)
    call cl_set_act_visible("accept,cancel",true)
    call cl_set_act_title("cancel_input","重新查询")
    call cl_set_act_title("next_step","下一步")
    call cl_set_act_title("previous_step","上一步")
    input array g_sfb1 without defaults from s_sfb1.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before row
            let l_ac = arr_curr()
        
        after field cnum_1
            if g_sfb1[l_ac].cnum_1 > g_sfb1[l_ac].sfb08_1 then
                let g_sfb1[l_ac].cnum_1 = g_sfb1[l_ac].sfb08_1
                call cl_err('数量不得大于可拆分数量',"!",0)
                next field cnum_1
            end if
            if g_sfb[l_ac].cnum / g_sfb[l_ac].clot / g_sfb1[l_ac].imaud10_1> 100 then
                if not cl_confirm("csf-118") then
                    next field clot
                end if
            end if

        after field clot_1
            if g_sfb1[l_ac].clot_1 <= 0 then
                call cl_err('拆分LOT数量需要大于0',"!",0)
                next field clot_1
            end if
            if g_sfb1[l_ac].cnum_1 / g_sfb1[l_ac].clot_1 / g_sfb1[l_ac].imaud10_1 > 100 then
                if not cl_confirm("csf-118") then
                    next field clot_1
                end if
            end if

        on change clot_1
            if not cl_null(g_sfb1[l_ac].clot_1) then
                let g_sfb1[l_ac].snum_1 = g_sfb1[l_ac].clot_1 * g_sfb1[l_ac].imaud10_1
            end if

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="previous_step"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
            
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
        on action cancel
            let g_action_choice = 'previous_step'
            exit input

        on action accept
            let g_action_choice = "next_step"
            exit input
        on action next_step
            let g_action_choice = "next_step"
            exit input
        on action previous_step
            let g_action_choice = 'previous_step'
            exit input
        on action cancel_input
            let g_action_choice = "query"
            exit input

        on action select_all
            for i = 1 to g_sfb1.getlength()
                let g_sfb1[i].check2 = 'Y'
            end for
        on action inverse
            for i = 1 to g_sfb1.getlength()
                let g_sfb1[i].check2 = iif(g_sfb1[i].check2=='Y','N','Y')
            end for
    end input
    call cl_set_act_visible("accept,cancel",false)
end function

function csfp300_shm_bp()
    call cl_set_comp_visible("Page3",true)
    call cl_set_comp_visible("Page1,Page2",false)
    call cl_set_act_title("cancel_input","继续处理其它工单")
    display array g_shm to s_shm.*  attributes(unbuffered)
        
        on action help
            let g_action_choice="help"
            exit display
        on action controlg
            let g_action_choice="controlg"
            exit display
            
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
        on action close
            let g_action_choice = 'close'
            exit display
            
        on action cancel_input
            let g_action_choice = "query"
            exit display
    end display
end function

# 建立临时表
function csfp300_crt_temp()
DROP TABLE csfp300_sfb
DROP TABLE csfp300_sfb1
DROP TABLE csfp300_shm
CREATE TEMP TABLE csfp300_sfb(
check1       LIKE type_file.chr1,
sfb22       LIKE sfb_file.sfb22,
sfb221      LIKE sfb_file.sfb221,
sfb01       LIKE sfb_file.sfb01,
sfb86       LIKE sfb_file.sfb86,
sfb05       LIKE sfb_file.sfb05,
sfb06       LIKE sfb_file.sfb06,
ima02       LIKE ima_file.ima02,
ima021      LIKE ima_file.ima021,
sfb13       LIKE sfb_file.sfb13,
sfb15       LIKE sfb_file.sfb15,
sfb08       LIKE sfb_file.sfb08,
ima55       LIKE ima_file.ima55,
imaud07     LIKE ima_file.imaud07,
imaud10     LIKE ima_file.imaud10,
tc_sma04    LIKE tc_sma_file.tc_sma04,
ynum        LIKE type_file.num15_3,
cnum        LIKE type_file.num15_3,
clot        LIKE type_file.num15_3,
snum        LIKE type_file.num15_3)
CREATE TEMP TABLE csfp300_sfb1(
check1       LIKE type_file.chr1,
sfb22       LIKE sfb_file.sfb22,
sfb221      LIKE sfb_file.sfb221,
sfb01       LIKE sfb_file.sfb01,
sfb86       LIKE sfb_file.sfb86,
sfb05       LIKE sfb_file.sfb05,
sfb06       LIKE sfb_file.sfb06,
ima02       LIKE ima_file.ima02,
ima021      LIKE ima_file.ima021,
sfb13       LIKE sfb_file.sfb13,
sfb15       LIKE sfb_file.sfb15,
sfb08       LIKE sfb_file.sfb08,
ima55       LIKE ima_file.ima55,
imaud07     LIKE ima_file.imaud07,
imaud10     LIKE ima_file.imaud10,
tc_sma04    LIKE tc_sma_file.tc_sma04,
ynum        LIKE type_file.num15_3,
cnum        LIKE type_file.num15_3,
clot        LIKE type_file.num15_3,
snum        LIKE type_file.num15_3)
SELECT shm_file.*, sfb22,sfb221,sfb86,ima02,ima021 FROM shm_file,sfb_file,ima_file WHERE ima01=sfb05 and sfb01=shm012 AND  1=2 INTO TEMP csfp300_shm
end function

# 汇出excel
function csfp300_export_excel()
    define list dynamic array of record
            node om.DomNode,
            name string
        end record
    case g_b_flag
        when 'Page2'
            call list.clear()
            let list[1].node = base.typeinfo.create(g_sfb1)
            let list[1].name = "s_sfb1"
            call cl_export_to_excel_by_go(list)
        when 'Page3'
            call list.clear()
            let list[1].node = base.typeinfo.create(g_shm)
            let list[1].name = "s_shm"
            call cl_export_to_excel_by_go(list)
        otherwise
            call list.clear()
            let list[1].node = base.typeinfo.create(g_sfb)
            let list[1].name = "s_sfb"
            call cl_export_to_excel_by_go(list)
    end case

end function

# page1
function csfp300_page1()

    if g_action_choice = "exit" then
        return
    end if
    delete from csfp300_sfb
    call g_sfb.clear()

    # 1. 订单条件
    let g_sql = "select unique oea01,oeb03 from oea_file,oeb_file ",
                " where oeaconf = 'Y' and oea49 = '1' and ",g_wc1 clipped," and ",g_wc2 clipped
    # 查询符和条件主工单
    let g_sql = "select 'Y',sfb22,sfb221,sfb01,sfb86,sfb05,sfb06,ima02,ima021,sfb13,",
                "       sfb15,sfb08,ima55,imaud07,imaud10,imaud06,0,0,0,0",
                " from sfb_file,ima_file where (sfb22,sfb221) in (",g_sql clipped,")",
                " and ima01= sfb05 and sfb87 = 'Y' and sfb04 < '8' ",
                " and ",g_wc3 clipped
    let g_sql = "insert into csfp300_sfb ",g_sql

    prepare csfp300_page1_1 from g_sql
    execute csfp300_page1_1
    if sqlca.sqlcode then
        call cl_err("csfp300_page1_1",sqlca.sqlcode,1)
        return
    end if
    # 移到page2处理
    # # 将子工单也加入查询
    # let g_sql = "insert into csfp300_sfb",
    #             " select 'Y',sfb22,sfb221,sfb01,sfb86,sfb05,sfb06,ima02,ima021,sfb13,",
    #             "       sfb15,sfb08,ima55,imaud10,imaud06,0,0,0,0",
    #             " from sfb_file,ima_file where sfb86 in (select unique sfb01 from csfp300_sfb)",
    #             " and ima01 = sfb05 "
    # prepare csfp300_page1_2 from g_sql
    # execute csfp300_page1_2
    # if sqlca.sqlcode then
    #     call cl_err("csfp300_page1_2",sqlca.sqlcode,1)
    #     return
    # end if

    # 已拆分量和拆分LOT处理
    let g_sql = "merge into csfp300_sfb",
                " using (select shm012,sum(shm08) shm08 from shm_file group by shm012)",
                " on (sfb01 = shm012)",
                " when matched then update set ynum = shm08"
    prepare csfp300_page1_3 from g_sql
    execute csfp300_page1_3
    if sqlca.sqlcode then
        call cl_err("csfp300_page1_3",sqlca.sqlcode,1)
        return
    end if

    update csfp300_sfb SET cnum = sfb08 - ynum
    if sqlca.sqlcode then
        call cl_err("upd cnum",sqlca.sqlcode,1)
        return
    end if

    # 删除剩余未拆量未0的
    let g_sql = "delete from csfp300_sfb where cnum = 0"
    prepare csfp300_page1_5 from g_sql
    execute csfp300_page1_5
    if sqlca.sqlcode then
        call cl_err("csfp300_page1_5",sqlca.sqlcode,1)
        return
    end if

    # 更新主工单拆分lot数量
    # 1.G02 光板
    let g_sql = "select sfb01,case when csfp300_sfb.imaud10 >= tc_sma07 then tc_sma09 else '100' end tc_sma092",
                " from csfp300_sfb,ima_file left join tc_sma_file on tc_sma01 = 'csmi102' and tc_sma02 = 'aimi100' and tc_sma03 = imaud06",
                " where ima01 = sfb05 and ( ima06 ='G02' or ima01[7,7] not in ('A','B','C')  )"
                # darcy:2023/11/24 add 增加光板本成品拆批规则 ima01[7,7] not in ('A','B','C')
    let g_sql = "merge into csfp300_sfb a using (",g_sql,") b",
                " on (a.sfb01 = b.sfb01 and (a.sfb86 is null or a.sfb86 =' ' ))",
                " when matched then update set a.clot = b.tc_sma092"
    prepare csfp300_page1_4 from g_sql
    execute csfp300_page1_4
    if sqlca.sqlcode then
        call cl_err("csfp300_page1_4",sqlca.sqlcode,1)
        return
    end if

    # darcy:2024/04/23 add s---
    # 光板csmi108 按照料号设置
    let g_sql = "select a.sfb01, a.sfb05, b.tc_sma02, b.tc_sma06
                   from CSFP300_SFB a, tc_sma_file b,
                        (select sfb01, sfb05, max(length(tc_sma02)) l
                            from CSFP300_SFB, tc_sma_file
                            where tc_sma01 = 'csmi108'
                            and tc_sma20 = 'Y'
                            and sfb05 like tc_sma02 || '%'
                            and (sfb05 = 'G02' or substr(sfb05, 7, 7) not in ('A', 'B', 'C'))
                            group by sfb01, sfb05) c
                 where b.tc_sma01 = 'csmi108'
                   and b.tc_sma20 = 'Y'
                   and a.sfb05 like b.tc_sma02 || '%'
                   and c.sfb01 = a.sfb01
                   and c.l = length(b.tc_sma02)
                   and (a.sfb05 = 'G02' or substr(a.sfb05, 7, 7) not in ('A', 'B', 'C'))"
    let g_sql = "merge into csfp300_sfb a using (",g_sql,") b",
                " on (a.sfb01 = b.sfb01 and (a.sfb86 is null or a.sfb86 =' ' ))",
                " when matched then update set a.clot = b.tc_sma06"
    prepare csfp300_page1_8 from g_sql
    execute csfp300_page1_8 
    # darcy:2024/04/23 add e---

    # 2.G01 组装
    let g_sql = "select unique sfb01,tc_sma06 tc_sma092 from tc_sma_file,csfp300_sfb,ima_file ",
                " where sfb05 = ima01 and (ima06='G01' or substr(ima01,7,7) in ('A','B','C') ) ",
                " and tc_sma01 = 'csmi106' and tc_sma02 = ima01 "
    let g_sql = "merge into csfp300_sfb a using (",g_sql,") b",
                " on (a.sfb01 = b.sfb01 and (a.sfb86 is null or a.sfb86 =' ' ))",
                " when matched then update set a.clot = b.tc_sma092"
    prepare csfp300_page1_7 from g_sql
    execute csfp300_page1_7
    if sqlca.sqlcode then
        call cl_err("csfp300_page1_7",sqlca.sqlcode,1)
        return
    end if

    # 移动到page2处理
    # # 子工单跟随主工单更新
    # let g_sql = "merge into csfp300_sfb a using (",
    #             "     select sfb01,clot from csfp300_sfb",
    #             " ) b on (a.sfb86 = b.sfb01)",
    #             " when matched then update set a.clot = b.clot"
    # prepare csfp300_page1_6 from g_sql
    # execute csfp300_page1_6
    # if sqlca.sqlcode then
    #     call cl_err("csfp300_page1_6",sqlca.sqlcode,1)
    #     return
    # end if

    update csfp300_sfb set clot = 100 where clot = 0
    if sqlca.sqlcode then
        call cl_err("upd clot",sqlca.sqlcode,1)
        return
    end if
    update csfp300_sfb set snum = clot * imaud10
    if sqlca.sqlcode then
        call cl_err("upd snum",sqlca.sqlcode,1)
        return
    end if

    # b_fill
    let g_sql = "select check1,sfb22,sfb221,sfb01,sfb86,sfb05,sfb06,ima02,ima021,sfb13,",
                "       sfb15,sfb08,ima55,imaud07,imaud10,tc_sma04,ynum,cnum,clot,snum",
                " from csfp300_sfb order by sfb01"
    declare csfp300_page1_fill cursor from g_sql
    let g_cnt = 1
    foreach csfp300_page1_fill into g_sfb[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfp300_page1_fill",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        end if
    end foreach
    call g_sfb.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1

end function
# page1=>page2
function csfp300_page2()
    define i,j integer
    define l_shm01  integer
    define l_cnum,l_snum  decimal(15,3)

    delete from csfp300_sfb1
    call g_sfb1.clear()

    let g_action_choice = ""
    # 更新临时表
    for i = 1 to g_sfb.getlength()
        update csfp300_sfb set
            check1  = g_sfb[i].check1  ,
            sfb22   = g_sfb[i].sfb22   ,
            sfb221  = g_sfb[i].sfb221  ,
            sfb86   = g_sfb[i].sfb86   ,
            sfb01   = g_sfb[i].sfb01   ,
            sfb05   = g_sfb[i].sfb05   ,
            sfb06   = g_sfb[i].sfb06   ,
            ima02   = g_sfb[i].ima02   ,
            ima021  = g_sfb[i].ima021  ,
            sfb13   = g_sfb[i].sfb13   ,
            sfb15   = g_sfb[i].sfb15   ,
            sfb08   = g_sfb[i].sfb08   ,
            ima55   = g_sfb[i].ima55   ,
            imaud07 = g_sfb[i].imaud07 ,
            imaud10 = g_sfb[i].imaud10 ,
            tc_sma04= g_sfb[i].tc_sma04,
            ynum    = g_sfb[i].ynum    ,
            cnum    = g_sfb[i].cnum    ,
            clot    = g_sfb[i].clot    ,
            snum    = g_sfb[i].snum    
         where sfb01 = g_sfb[i].sfb01
        if sqlca.sqlcode then
            call cl_err("upd csfp300_sfb",sqlca.sqlcode,1)
            exit for
        end if
    end for

    # 产生Page2资料
    let g_success = 'Y'
    # 将子工单也加入查询
    let g_sql = " insert into csfp300_sfb1",
                " select  'Y',a.sfb22,a.sfb221,a.sfb01,a.sfb86,a.sfb05,a.sfb06,b.ima02,b.ima021,a.sfb13,",
                "         a.sfb15,a.sfb08,b.ima55,b.imaud07,b.imaud10,b.imaud06,0,0,c.clot,0",
                "   from sfb_file a,ima_file b,csfp300_sfb c",
                "  where a.sfb05=b.ima01 and a.sfb86=c.sfb01 and c.check1='Y' and a.sfb87 = 'Y'" #darcy:2025/01/20 add sfb87 ='Y'
    prepare csfp300_page2_6 from g_sql
    execute csfp300_page2_6
    if sqlca.sqlcode then
        call cl_err("csfp300_page2_6",sqlca.sqlcode,1)
        let g_success = 'N'
        return
    end if
    # 已拆分LOT处理
    let g_sql = "merge into csfp300_sfb1",
                " using (select shm012,sum(shm08) shm08 from shm_file group by shm012)",
                " on (sfb01 = shm012)",
                " when matched then update set ynum = shm08"
    prepare csfp300_page2_2 from g_sql
    execute csfp300_page2_2
    if sqlca.sqlcode then
        call cl_err("csfp300_page2_2",sqlca.sqlcode,1)
        let g_success = 'N'
        return
    end if

    # 更新默认本次拆分数量
    update csfp300_sfb1 SET cnum = sfb08 - ynum
    if sqlca.sqlcode then
        call cl_err("upd cnum_1",sqlca.sqlcode,1)
        return
    end if

    # 删除剩余未拆量未0的
    let g_sql = "delete from csfp300_sfb1 where cnum = 0"
    prepare csfp300_page2_3 from g_sql
    execute csfp300_page2_3
    if sqlca.sqlcode then
        call cl_err("csfp300_page1_5",sqlca.sqlcode,1)
        return
    end if

    update csfp300_sfb1 set snum = clot * imaud10
    if sqlca.sqlcode then
        call cl_err("upd snum_1",sqlca.sqlcode,1)
        return
    end if

    let g_sql = "insert into csfp300_sfb1 select * from csfp300_sfb where check1='Y'"
    prepare csfp300_page2_4 from g_sql
    execute csfp300_page2_4
    if sqlca.sqlcode then
        call cl_err("csfp300_page2_4",sqlca.sqlcode,1)
        let g_success = 'N'
        return
    end if

    let g_sql = "select check1,sfb22,sfb221,sfb01,sfb86,sfb05,sfb06,ima02,ima021,sfb13,",
                "       sfb15,sfb08,ima55,imaud07,imaud10,tc_sma04,ynum,cnum,clot,snum",
                " from csfp300_sfb1 order by case sfb86 when ' ' then sfb01 else sfb86 end,sfb01"
    declare csfp300_page2_5 cursor from g_sql
    let g_cnt = 1
    foreach csfp300_page2_5 into g_sfb1[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfp300_page2_5",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        end if
    end foreach
    call g_sfb1.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1

end function

# page2=>page3
# 产生shm_file和sgm_file资料
function csfp300_page3()
    define i,j,l_cnt integer
    define l_insert boolean
    define l_maxXuHao varchar(40)
    define sr record
            shm01       like shm_file.shm01   ,
            shm012      like shm_file.shm012  ,
            shm05       like shm_file.shm05   ,
            shm06       like shm_file.shm06   ,
            shm08       like shm_file.shm08   ,
            shm09       like shm_file.shm09   ,
            shm10       like shm_file.shm10   ,
            shm11       like shm_file.shm11   ,
            shm111      like shm_file.shm111  ,
            shm12       like shm_file.shm12   ,
            shm121      like shm_file.shm121  ,
            shm13       like shm_file.shm13   ,
            shm14       like shm_file.shm14   ,
            shm15       like shm_file.shm15   ,
            shm16       like shm_file.shm16   ,
            shm28       like shm_file.shm28   ,
            shmacti     like shm_file.shmacti ,
            shmuser     like shm_file.shmuser ,
            shmgrup     like shm_file.shmgrup ,
            shmdate     like shm_file.shmdate ,
            shmplant    like shm_file.shmplant,
            shmlegal    like shm_file.shmlegal,
            shmoriu     like shm_file.shmoriu ,
            shmorig     like shm_file.shmorig ,
            ta_shm01    like shm_file.ta_shm01,
            ta_shm02    like shm_file.ta_shm02,
            ta_shm05    like shm_file.ta_shm05,
            ta_shm06    like shm_file.ta_shm06
           end record
    define l_cnum       decimal(20,3),
           l_snum       decimal(20,3),
           l_imaud10    integer,
           l_sfb86      varchar(40),
           l_sfb86_old  varchar(40),
           l_ta_shm05   integer,
           l_shm01      integer,
           l_sfb22      like sfb_file.sfb22,
           l_sfb221     like sfb_file.sfb221,
           l_ima02      like ima_file.ima02,
           l_ima021     like ima_file.ima021

    delete from csfp300_shm
    call g_shm.clear()

    let g_action_choice = ""

    # 更新中间表
    for i = 1 to g_sfb1.getlength()
        update csfp300_sfb1 set
            check1   = g_sfb1[i].check2    ,
            sfb22    = g_sfb1[i].sfb22_1   ,
            sfb221   = g_sfb1[i].sfb221_1  ,
            sfb01    = g_sfb1[i].sfb01_1   ,
            sfb86    = g_sfb1[i].sfb86_1   ,
            sfb05    = g_sfb1[i].sfb05_1   ,
            sfb06    = g_sfb1[i].sfb06_1   ,
            ima02    = g_sfb1[i].ima02_1   ,
            ima021   = g_sfb1[i].ima021_1  ,
            sfb13    = g_sfb1[i].sfb13_1   ,
            sfb15    = g_sfb1[i].sfb15_1   ,
            sfb08    = g_sfb1[i].sfb08_1   ,
            ima55    = g_sfb1[i].ima55_1   ,
            imaud07  = g_sfb1[i].imaud07_1 ,
            imaud10  = g_sfb1[i].imaud10_1 ,
            tc_sma04 = g_sfb1[i].tc_sma04_1,
            ynum     = g_sfb1[i].ynum_1    ,
            cnum     = g_sfb1[i].cnum_1    ,
            clot     = g_sfb1[i].clot_1    ,
            snum     = g_sfb1[i].snum_1    
         where sfb01 = g_sfb1[i].sfb01_1
        if sqlca.sqlcode then
            call cl_err("upd csfp300_sfb1",sqlca.sqlcode,1)
            return
        end if
    end for

    let l_insert = false
    let g_sql = "SELECT SUBSTR(NVL(shm01,'MRA-20000000-000-00'), 14, 3) shm01,'',sfb01,sfb05,sfb06,0,0,0,0,0,0,0,sfb13,'00:00',sfb15,'00:00', ",
                "   'N','Y','",g_user,"','",g_grup,"',TRUNC(SYSDATE),'",g_plant,"','",g_legal,"','",g_user,"','",g_grup,"',0,'Y','','N', ",
                "   cnum,snum,imaud10,CASE sfb86 WHEN ' ' THEN sfb01 ELSE sfb86 END sfb86,sfb22,sfb221,ima02,ima021 ",
                "   FROM csfp300_sfb1 ",
                "   LEFT JOIN (SELECT shm012,MAX(shm01) shm01 FROM shm_file GROUP BY shm012) ON sfb01 = shm012",
                "   where check1 = 'Y'",
                "   order by CASE sfb86 WHEN ' ' THEN sfb01 ELSE sfb86 END"
    declare csfp300_page3_1 cursor from g_sql
    let l_sfb86_old = "" let l_ta_shm05 = 0
    foreach csfp300_page3_1 into l_shm01,sr.*,l_cnum,l_snum,l_imaud10,l_sfb86,l_sfb22,l_sfb221,l_ima02,l_ima021
        if sqlca.sqlcode then
            call cl_err("csfp300_page3_1",sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        if cl_null(l_sfb86_old) or l_sfb86 != l_sfb86_old then
            let l_ta_shm05 = l_ta_shm05 + 1
            let l_sfb86_old = l_sfb86
        end if
        while l_cnum > 0
            let sr.ta_shm05 = l_ta_shm05
            let l_shm01 = l_shm01 + 1
            let sr.shm01 = sr.shm012,"-",l_shm01 using "&&&","-00"
            let sr.shm08 = iif (l_cnum<=l_snum,l_cnum,l_snum )
            let l_cnum = l_cnum - l_snum
            let sr.ta_shm01 = sr.shm08/l_imaud10
            insert into csfp300_shm(
                shm01,shm012,shm05,shm06,shm08,shm09,shm10,shm11,shm111,
                shm12,shm121,shm13,shm14,shm15,shm16,shm28,shmacti,shmuser,
                shmgrup,shmdate,shmplant,shmlegal,shmoriu,shmorig,ta_shm01,
                ta_shm02,ta_shm05,ta_shm06,sfb22,sfb221,sfb86,ima02,ima021
            )values(
                sr.shm01,sr.shm012,sr.shm05,sr.shm06,sr.shm08,sr.shm09,sr.shm10,sr.shm11,sr.shm111,
                sr.shm12,sr.shm121,sr.shm13,sr.shm14,sr.shm15,sr.shm16,sr.shm28,sr.shmacti,sr.shmuser,
                sr.shmgrup,sr.shmdate,sr.shmplant,sr.shmlegal,sr.shmoriu,sr.shmorig,sr.ta_shm01,
                sr.ta_shm02,sr.ta_shm05,sr.ta_shm06,l_sfb22,l_sfb221,l_sfb86,l_ima02,l_ima021
            )
            if sqlca.sqlcode then
                call cl_err("ins csfp300_shm",sqlca.sqlcode,1)
                let g_success = 'N'
                return
            end if
        end while
    end foreach

    call csfp300_process()

end function

# 开始插入正式表
function csfp300_process()
    define l_ta_shm05   integer
    define l_maxXuHao,l_cnt   integer
    define i integer
    define l_error  varchar(20)
    define l_year,l_month,l_day integer
    DEFINE l_now DATETIME YEAR TO FRACTION(3) #darcy:2024/01/22
    define l_shm05 varchar(40)

    # step 1. 取号
    select max(to_number(ta_shm05)) into l_ta_shm05 from csfp300_shm
    if l_ta_shm05 == 0 then
        call cl_err("","csf-112",1)
        return
    end if
    let l_year = YEAR(g_today)
    let l_month = MONTH(g_today)
    let l_day = DAY(g_today)

    LET l_now = CURRENT YEAR TO FRACTION(3) 
    call cl_log_string("\n---"||l_now||"开始拆批---")
    call cl_log_string("year:"||l_year||" month:"||l_month||" day:"||l_day)
    call cl_log_string("当前拆分最大批次："||l_ta_shm05)
    begin work


    declare max_pixuhao cursor from
        "select pixuhao from shm05_file  
          where pixuhaoyear = ? and pixuhaomonth = ? and pixuhaoday= ?  
         for update nowait "
    open max_pixuhao using l_year,l_month,l_day
    fetch max_pixuhao into l_maxXuHao
    call cl_log_string("批序号："||l_maxXuHao)
    if cl_null(l_maxXuHao) or l_maxXuHao = 0 then
        let l_maxXuHao = l_ta_shm05
        insert into shm05_file values(l_maxXuHao,l_year,l_month,l_day)
        call cl_log_string("更新后批次号："||l_maxXuHao)
    else
        update shm05_file set pixuhao = pixuhao + l_ta_shm05
         where pixuhaoyear = l_year and pixuhaomonth = l_month and pixuhaoday= l_day
        call cl_log_string("更新后批次号："||l_maxXuHao + l_ta_shm05)
    end if

    if sqlca.sqlcode then
        call cl_err("upd/ins shm05_file ",sqlca.sqlcode,1)
        close max_pixuhao
        rollback work
        return
    end if

    # 锁定工单号
    open csfp300_page2_1
    if sqlca.sqlcode then
        call cl_err("",sqlca.sqlcode,1)
        close csfp300_page2_1
        close max_pixuhao
        rollback work
        return
    end if

    #darcy:2024/01/31 add s---
    let l_cnt = 0 
    select count(1) into l_cnt from shm_file
     where ta_shm05 in (select 'dhy-'||to_char(SYSDATE,'yyyymmdd')||to_char(ta_shm05+l_maxXuHao,'FM0000') from csfp300_shm)
    if l_cnt > 0 then
        call cl_err("",'csf-120',1)
        close csfp300_page2_1
        close max_pixuhao
        rollback work
        select min('dhy-'||to_char(SYSDATE,'yyyymmdd')||to_char(ta_shm05+l_maxXuHao,'FM0000') )
          into l_shm05
          from csfp300_shm
        call csfp300_upd_shm05(l_shm05,l_ta_shm05)
        return
    end if
    #darcy:2024/01/31 add e---

    insert into shm_file (
        shm01,shm012,shm05,shm06,shm08,shm09,shm10,shm11,shm111,
        shm12,shm121,shm13,shm14,shm15,shm16,shm28,shmacti,shmuser,
        shmgrup,shmdate,shmplant,shmlegal,shmoriu,shmorig,ta_shm01,
        ta_shm02,ta_shm05,ta_shm06
    )select shm01,shm012,shm05,shm06,shm08,shm09,shm10,shm11,shm111,
            shm12,shm121,shm13,shm14,shm15,shm16,shm28,shmacti,shmuser,
            shmgrup,shmdate,shmplant,shmlegal,shmoriu,shmorig,ta_shm01,
            ta_shm02,'dhy-'||to_char(SYSDATE,'yyyymmdd')||to_char(ta_shm05+l_maxXuHao,'FM0000') ta_shm05,ta_shm06
       from csfp300_shm
    
    if sqlca.sqlcode then
        call cl_err("",sqlca.sqlcode,1)
        close csfp300_page2_1
        close max_pixuhao
        rollback work
        return
    end if

    let g_sql = "select shm01,sfb22,sfb221,shm012,sfb86,'dhy-'||to_char(SYSDATE,'yyyymmdd')||to_char(ta_shm05+",l_maxXuHao,",'FM0000') ta_shm05,ima02,ima021, ",
                " shm05,shm06,shm08,shm09,shm10,shm11,shm111,   ",
                " shm12,shmacti,shmuser,shmdate ",
                "  from csfp300_shm ",
                " order by sfb86,shm012,shm01"
    declare csfp300_page3_2 cursor from g_sql
    let g_cnt = 1
    foreach csfp300_page3_2 into g_shm[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfp300_page3_2",sqlca.sqlcode,1)
            return
        end if
        call s_runcard(g_shm[g_cnt].shm01,g_shm[g_cnt].shm012,g_shm[g_cnt].shm06,
                       g_shm[g_cnt].shm05,g_shm[g_cnt].shm08)
            returning l_error 
        if not cl_null(l_error)  then 
            call cl_err(g_shm[g_cnt].shm01,l_error,1)
            let g_success = 'N' 
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        end if
    end foreach
    call g_shm.deleteElement(g_cnt)
    let g_cnt = g_cnt + 1

    close csfp300_page2_1
    close max_pixuhao

    if g_success = 'N' then
        rollback work
        message "生成LOT单失败！"
    else
        if g_user = 'tiptop' then
            rollback work
        else
            commit work
        end if
        message "success!"
    end if
    LET l_now = CURRENT YEAR TO FRACTION(3) 
    call cl_log_string("---"||l_now||" user:"||g_user||"结束拆批---")
end function

# 查询前清空资料
function csfp300_clear()

    let g_wc1 = ""
    let g_wc2 = ""
    let g_wc3 = ""
    call g_sfb.clear()
    call g_sfb1.clear()
    call g_shm.clear()
end function

#darcy:2024/03/11 add s--- 
# 可能为已拆批lot号未更新shm05_file
# 重新更新一次shm05_file
function csfp300_upd_shm05(p_ta_shm05,p_shm05)
    define p_ta_shm05 varchar(40)
    define p_shm05  integer

    define l_ta_shm05 varchar(40)
    define l_max_shm05,l_year,l_month,l_day integer
    define l_cnt integer

    let l_ta_shm05 = p_ta_shm05[1,12],(p_ta_shm05[13,16]+p_shm05-1) using '&&&&'

    select count(*) into l_cnt from shm_file where ta_shm05 between p_ta_shm05 and l_ta_shm05

    if l_cnt > 0 then
        select max(ta_shm05) into l_ta_shm05  from shm_file where shmdate = g_today

        let l_max_shm05 = l_ta_shm05[13,16]
        let l_year = year(g_today)
        let l_month = month(g_today)
        let l_day = day(g_today)

        update shm05_file set pixuhao = l_max_shm05
            where pixuhaoyear = l_year and pixuhaomonth = l_month and pixuhaoday= l_day
    end if
    
end function
#darcy:2024/03/11 add e--- 
