# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: ceci400.4gl                                                                                                        
# Descriptions...: 料件工艺编号锁定维护锁业                                                                                            
# Date & Author..: darcy:2023/03/31

database ds
 
globals "../../../tiptop/config/top.global"

DEFINE g_db_type            LIKE type_file.chr3
define g_wc string

# ---
type tc_eci record
    sure        like type_file.chr1,
    ecb01       like ecb_file.ecb01,
    ecb02       like ecb_file.ecb02,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021,
    ecu04       like ecu_file.ecu04,
    ecu05       like ecu_file.ecu05,
    ecu06       like ecu_file.ecu06,
    ecu10       like ecu_file.ecu10,
    ecuud02     like ecu_file.ecuud02,
    tc_eci15    like tc_eci_file.tc_eci15,
    tc_eci03    like tc_eci_file.tc_eci03,
    tc_eci05    like tc_eci_file.tc_eci05,
    gen02       like gen_file.gen02,
    tc_eci06    like tc_eci_file.tc_eci06
end record

type history record
    ecb01_1       like ecb_file.ecb01,
    ecb02_1       like ecb_file.ecb02,
    ima02_1       like ima_file.ima02,
    ima021_1      like ima_file.ima021,
    imaud07_1     like ima_file.imaud07,
    imaud10_1     like ima_file.imaud10,
    ecu04_1       like ecu_file.ecu04,
    ecu05_1       like ecu_file.ecu05,
    ecu06_1       like ecu_file.ecu06,
    ecu10_1       like ecu_file.ecu10,
    ecuud02_1     like ecu_file.ecuud02,
    tc_eci15_1    like tc_eci_file.tc_eci15,
    tc_eci03_1    like tc_eci_file.tc_eci03,
    tc_eci05_1    like tc_eci_file.tc_eci05,
    gen02_2       like gen_file.gen02,
    tc_eci06_1    like tc_eci_file.tc_eci06
end record
# ---

# ---
define   w    ui.Window
define   f    ui.Form
define   page om.DomNode
# ---

# ---
define g_tc_eci,g_tc_eci_excel dynamic array of tc_eci
define g_history,g_history_excel dynamic array of history
define g_tc_eci_t tc_eci
define g_history_t history
# ---

# ---
define g_b_flag integer
define g_rec_b integer # 单身总比数
define g_cnt integer #总笔数
define l_ac,l_ac_t integer #单身当前笔数
# ---

# ---
# 工单条件和lot条件
define g_wc1,g_wc2,g_wc3 string
# ---

# ---
define flag_tc_eci         like type_file.chr1
define flag_history        like type_file.chr1
# ---

# ---
define tm record
    bom_exp     like type_file.chr1,
    cls_sta     like type_file.chr1
end record
# ---

# ---
define g_sql    string
# ---


main

OPTIONS
    INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CEC")) THEN
        EXIT PROGRAM
    END IF
 
    LET g_db_type=cl_db_get_database_type()

    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818

    
    OPEN WINDOW i400_w WITH FORM "cec/42f/ceci400"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()

    let g_sql = "select ecu06 from ecu_file where ecu01 = ? and ecu02 =? for update "
    declare i400_cl cursor from g_sql
    
    call ceci400_menu()

    CLOSE WINDOW i400_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
end main

function ceci400_menu()
    while true
        if g_action_choice = 'exit' then
            let g_wc1 = ''
            let g_wc2 = ''
            let g_wc3 = ''
        end if
        case g_b_flag
            when '1'
                # 查询结果/page01
                call ceci400_bp1("G")
            when '2'
                # 历史/history
                call ceci400_bp2("G")
            otherwise
                call ceci400_bp1("G")
        end case

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
                    call ceci400_q()
                end if
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    let w = ui.window.getcurrent()
                    let f = w.getform()
                    case g_b_flag
                        when '1'
                            let page = f.FindNode("Page","page01")
                            call cl_export_to_excel(page,base.TypeInfo.create(g_tc_eci_excel),'','')
                        when '2'
                            let page = f.FindNode("Page","history")
                            call cl_export_to_excel(page,base.TypeInfo.create(g_history_excel),'','')
                    end case
                end if
        end case
    end while
end function
function ceci400_cs()
    clear form
    let g_action_choice = " "

    dialog
        construct g_wc1 on ecu01,ecu02,ecb06,ecb03,ecb08
         from ecu01_q,ecu02_q,ecb06_q,ecb03_q,ecb08_q
            before construct
        end construct

        input by name tm.*
            before input
        end input

        construct g_wc2
            on ecb02,ecu04,ecu05,ecu06,ecuud02
            from 
            s_tc_eci[1].ecb02,s_tc_eci[1].ecu04,s_tc_eci[1].ecu05,s_tc_eci[1].ecu06,s_tc_eci[1].ecuud02

            before construct
        end construct

        construct g_wc3 on tc_eci03,tc_eci05,tc_eci06
            from 
            s_tc_eci[1].tc_eci03,s_tc_eci[1].tc_eci05,s_tc_eci[1].tc_eci06
            before construct
        end construct
        
        on action controlp
            # 开窗
            case
                when infield(ecu01_q)
                    call cl_init_qry_var()
                    let g_qryparam.state  = "c"
                    let g_qryparam.form   = "q_ecu01"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to ecu01_q
                    next field ecu01_q
                when infield(ecb06_q)
                    call cl_init_qry_var()
                    let g_qryparam.state  = "c"
                    let g_qryparam.form   = "q_ecb06"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to ecb06_q
                    next field ecb06_q
                when infield(ecb08_q)
                    call cl_init_qry_var()
                    let g_qryparam.state  = "c"
                    let g_qryparam.form   = "q_eca1"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to ecb08_q
                    next field ecb08_q
                when infield(tc_eci05)
                    call cl_init_qry_var()
                    let g_qryparam.state  = "c"
                    let g_qryparam.form   = "q_gen"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to tc_eci05
                    next field tc_eci05
            end case
        on action page01
            let g_b_flag = "1"
 
        on action history
            let g_b_flag = "2"
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
function ceci400_q()
    let g_b_flag = "1"
    let g_rec_b = 0

    clear form

    let flag_tc_eci = 'N'
    let flag_history = 'N'

    display g_rec_b to  cn2
    call cl_opmsg('q')
    message ""

    call ceci400_cs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call ceci400_show()
    end if
    message ""

end function

function ceci400_show()
    let g_b_flag = '1'
end function

function ceci400_bp1(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index,l_cnt    integer
    define   l_tc_eci15     like tc_eci_file.tc_eci15


    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call ceci400_fill_tc_eci(g_wc1,g_wc2,g_wc3)

    call cl_set_act_visible("accept,cancel", false)
    display g_tc_eci.getLength() to cn2

    input array g_tc_eci without defaults from s_tc_eci.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            

        before row
            let l_ac = arr_curr()
            call ceci400_b_entry()
            call ceci400_b_no_entry()
            let g_tc_eci_t.* = g_tc_eci[l_ac].*
            # begin work
            # open i400_cl using g_tc_eci[l_ac].ecb01,g_tc_eci[l_ac].ecb02
            # if status then
            #     call cl_err("open t310_cl.", status, 1)
            #     close i400_cl
            #     rollback work
            #     return
            # end if
            # fetch i400_cl into g_tc_eci[l_ac].ecu06
            # if sqlca.sqlcode then
            #     call cl_err(g_tc_eci[l_ac].ecb01,sqlca.sqlcode,0)
            #     close i400_cl
            #     rollback work
            #     return
            # end if


        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
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

        on row change
            -- 检查资料是否完整
            let g_success = 'Y'
            # 1. 锁定必须有锁定原因
            if (g_tc_eci_t.ecu06 != g_tc_eci[l_ac].ecu06 or 
                ( cl_null(g_tc_eci_t.ecu06) and not cl_null(g_tc_eci[l_ac].ecu06) ))
               and cl_null(g_tc_eci[l_ac].tc_eci06) then
                call cl_err(g_tc_eci[l_ac].ecb01,'cec-041',0)
                next field tc_eci06
            end if
            
            if (g_tc_eci_t.ecu06 != g_tc_eci[l_ac].ecu06 or 
                ( cl_null(g_tc_eci_t.ecu06) and not cl_null(g_tc_eci[l_ac].ecu06) ))
                then
                if g_tc_eci[l_ac].ecu06 = 'Y' then
                    let l_tc_eci15 = '2'
                else
                    let l_tc_eci15 = '1'
                end if
                select count(1) into l_cnt from tc_eci_file 
                 where tc_eci01 = g_tc_eci[l_ac].ecb01 and tc_eci02 =g_tc_eci[l_ac].ecb02 
                   and tc_eci03 = g_tc_eci[l_ac].tc_eci03
                   and tc_eci15 = l_tc_eci15
                if l_cnt > 0 then
                    update tc_eci_file 
                      set tc_eci03 = g_tc_eci[l_ac].tc_eci03,
                          tc_eci05 = g_user,
                          tc_eci06 = g_tc_eci[l_ac].tc_eci06
                     where tc_eci01 = g_tc_eci_t.ecb01
                       and tc_eci02 = g_tc_eci_t.ecb02
                       and tc_eci03 = g_tc_eci_t.tc_eci03
                       and tc_eci15 = g_tc_eci_t.tc_eci15
                    if sqlca.sqlcode then
                        call cl_err('ins tc_eci',sqlca.sqlcode,1)
                        # rollback work
                        let g_success = 'N'
                        let g_tc_eci[l_ac].* = g_tc_eci_t.*
                    end if
                else
                    insert into tc_eci_file (
                        tc_eci01,tc_eci02,tc_eci03,tc_eci05,tc_eci06,tc_eci15
                    )values(
                        g_tc_eci[l_ac].ecb01,g_tc_eci[l_ac].ecb02,g_tc_eci[l_ac].tc_eci03,
                        g_user,g_tc_eci[l_ac].tc_eci06,l_tc_eci15
                    )
                    if sqlca.sqlcode then
                        call cl_err('ins tc_eci',sqlca.sqlcode,1)
                        # rollback work
                        let g_success = 'N'
                        let g_tc_eci[l_ac].* = g_tc_eci_t.*
                    end if
                end if
                if g_success = 'Y' then
                    update ecu_file set ecu06 = g_tc_eci[l_ac].ecu06
                    where ecu01 = g_tc_eci[l_ac].ecb01 and ecu02 = g_tc_eci[l_ac].ecb02

                    if sqlca.sqlcode then
                        call cl_err('upd ecu',sqlca.sqlcode,1)
                        # rollback work
                        let g_tc_eci[l_ac].* = g_tc_eci_t.*
                    end if
                end if
            else
                update tc_eci_file 
                   set tc_eci03 = g_tc_eci[l_ac].tc_eci03,
                       tc_eci05 = g_user,
                       tc_eci06 = g_tc_eci[l_ac].tc_eci06
                 where tc_eci01 = g_tc_eci_t.ecb01
                  and tc_eci02 = g_tc_eci_t.ecb02
                  and tc_eci03 = g_tc_eci_t.tc_eci03
                  and tc_eci15 = g_tc_eci_t.tc_eci15
                  and tc_eci05 = g_tc_eci_t.tc_eci05
                  and tc_eci06 = g_tc_eci_t.tc_eci06
                if sqlca.sqlcode then
                    call cl_err('upd tc_eci',sqlca.sqlcode,1)
                    # rollback work
                    let g_tc_eci[l_ac].* = g_tc_eci_t.*
                end if
            end if
        
        before field tc_eci03

        on change sure
            # 勾选改变的时候，同时刷新历史界面
            let flag_history = 'N'

        on change tc_eci03

        on change ecu06
            let g_tc_eci[l_ac].tc_eci05 = g_user
            select gen02 into g_tc_eci[l_ac].gen02 from gen_file where gen01 = g_tc_eci[l_ac].tc_eci05
            let g_tc_eci[l_ac].tc_eci03 = g_today
            if g_tc_eci[l_ac].ecu06 = 'Y' then
                let g_tc_eci[l_ac].tc_eci15 = '2'
            else
                let g_tc_eci[l_ac].tc_eci15 = '1'
            end if
            let g_tc_eci[l_ac].tc_eci06 = ''

        on action checkall
            for l_index = 1 to g_tc_eci.getLength()
                let g_tc_eci[l_index].sure = 'Y'
            end for

        on action inverse
            for l_index = 1 to g_tc_eci.getLength()
                if g_tc_eci[l_index].sure = 'Y' then
                    let g_tc_eci[l_index].sure = 'N'
                else
                    let g_tc_eci[l_index].sure = 'Y'
                end if
            end for
        
        on action history
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            # call ceci400_page1_check()
            exit input

        on action close_the_case
            # 锁住料号
            -- 已锁住跳过
            -- 未来锁住，修改至今日
            -- 未来解锁，提示
            -- 没有锁住，正常提示
            call ceci400_close(true)

        on action open_the_case
            # 解锁料号
            call ceci400_close(false)

        
        on action closed_output
            let g_action_choice = 'closed_output'
            exit input

    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function ceci400_bp2(p_ud)
    define   p_ud   like type_file.chr1
    define   l_wc   string
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call ceci400_fill_history()

    display g_history.getLength() to cn2

    call cl_set_act_visible("accept,cancel", false)

    # input array g_history without defaults from s_history.*
    #     attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
    #     insert row=false,delete row=false,append row=false)
    display array g_history to s_history.* --attribute(count=g_rec_b)

        before display
            let l_ac = arr_curr()

        on action help
            let g_action_choice="help"
            exit display
        on action exit
            let g_action_choice="exit"
            exit display
        on action controlg
            let g_action_choice="controlg"
            exit display
        on action query
            let g_action_choice="query"
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

        on action page01
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit display

        on action closed_output
            let g_action_choice = 'closed_output'
            exit display

    end display
    call cl_set_act_visible("accept,cancel", true)

end function

function ceci400_fill_tc_eci(p_wc1,p_wc2,p_wc3)
    # ---
    define p_wc1 string
    define p_wc2 string
    define p_wc3 string
    define l_sql string
    # ---
    # ---
    if flag_tc_eci = 'Y' then
        return
    end if
    if cl_null(p_wc1) then
        return
    end if
    let flag_tc_eci = 'Y'
    # ---
    call ceci400_temp()
    delete from ceci400_temp
    # ---
    #wc1,wc2是ecu和ecb
    # 先查ecu01/ecu02范围
    let l_sql = "select unique ecu01,ecu02,1 from ecu_file,ecb_file ",
                " where ecu01 =ecb01 and ecuacti='Y' and ",p_wc1 ," and ",p_wc2,
                " and ecu10='Y' and ecuud02 ='Y' "

    let l_sql = "insert into ceci400_temp ",l_sql
    prepare ins_temp from l_sql
    execute ins_temp
    if status then
        call cl_err('ins temp',sqlca.sqlcode,1)
        return
    end if

    if tm.bom_exp ='Y' then
        call ceci400_bom()
    end if
    -- 去重
    select * from ceci400_temp into temp ceci400_temp2
    delete from ceci400_temp
    insert into ceci400_temp select unique ecu01_1,ecu02_1,0 from ceci400_temp2
    drop table ceci400_temp2

    let l_sql ="SELECT 'Y',ecu01,ecu02,ima02,ima021,ecu04,ecu05,ecu06,ecu10,ecuud02,tc_eci15,tc_eci03,tc_eci05,gen02,tc_eci06
                 FROM ceci400_temp, ecu_file
                 LEFT JOIN (SELECT * FROM tc_eci_file
                WHERE (tc_eci01, tc_eci02, tc_eci15, tc_eci03) IN
                        (SELECT tc_eci01,
                                tc_eci02,
                                tc_eci15,
                                MAX(tc_eci03) tc_eci03
                        FROM tc_eci_file
                        GROUP BY tc_eci01, tc_eci02, tc_eci15))
                ON tc_eci01 = ecu01 AND tc_eci02 = ecu02
               AND (((ecu06 = 'Y' OR ecu06 IS NULL) AND tc_eci15 = '2') OR (ecu06 = 'N' AND tc_eci15 = '1'))
                LEFT JOIN ima_file ON ima01 = ecu01 LEFT JOIN gen_file ON gen01 = tc_eci05
                WHERE ecu01 = ecu01_1 AND ecu02 = ecu02_1"
    

    let l_sql = l_sql ," order by ecu01,ecu02 "


    prepare i400_fill_p from l_sql
    declare i400_fill_c cursor for i400_fill_p

    call g_tc_eci.clear()
    let g_cnt = 1
    foreach i400_fill_c into g_tc_eci[g_cnt].*
        if status then
            call cl_err('i400_fill_c',sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        -- if g_cnt > g_rec_b then
        --     exit foreach
        -- end if
    end foreach
    call g_tc_eci.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1

    # ---
end function

function ceci400_fill_history()
    # ---
    define l_sql string
    define l_i      like type_file.num5
    # ---

    # ---
    if flag_history = 'Y' then
        return
    end if
    let flag_history = 'Y'
    if cl_null(g_wc1) then
        return
    end if

    let l_sql = "select ecu01,ecu02,ima02,ima021,imaud07,imaud10,ecu04,ecu05,ecu06,ecu10,ecuud02,tc_eci15,tc_eci03,tc_eci05,gen02,tc_eci06",
                " from ecu_file ",
                " left join tc_eci_file on tc_eci01 = ecu01 and tc_eci02 = ecu02 ",
                " left join gen_file a on a.gen01=tc_eci05 ",
                " left join gen_file b on b.gen01=tc_eci07 ",
                " ,ima_file ",
                " where ecu01 = ima01 and ecu10 ='Y' and ecuud02 ='Y' and ecuacti ='Y' ",
                " and ecu01 =? and ecu02 =? ",
                " order by ecu01,ecu02,tc_eci05 "
    prepare i400_fill_history_p from l_sql
    declare i400_fill_history_c cursor for i400_fill_history_p

    let g_cnt = 1

    for l_i = 1 to g_tc_eci.getLength()
        if g_tc_eci[l_i].sure = 'Y' then
            foreach i400_fill_history_c using g_tc_eci[l_i].ecb01,g_tc_eci[l_i].ecb02
               into g_history[g_cnt].*
                if status then
                    call cl_err('i400_fill_history_c',sqlca.sqlcode,1)
                    exit foreach
                end if
                let g_cnt  = g_cnt + 1
            end foreach
        end if
    end for
    call g_history.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1

end function

function ceci400_bom()
    define l_sql    string
    define l_index,l_i  like type_file.num5

    let l_sql = "insert into ceci400_temp",
                " select bmb03,ecu02_1,? from bmb_file,ceci400_temp ,ecu_file  ",
                " where ecu01_1 =bmb01 and bmb04 <=sysdate and (bmb05 is null or bmb05 >sysdate)",
                " and lev = ? and ecu01 = bmb03 and ecu02_1 = ecu02 and ecuacti ='Y'",
                " and ecu10='Y' and ecuud02 ='Y' "
    prepare ins_temp2 from l_sql
    message "bom 展开中..."
    for l_index = 1 to 99
        let l_i = l_index + 1
        execute ins_temp2 using l_i,l_index
        if sqlca.sqlcode then
            call cl_err('ins_temp2',sqlca.sqlcode,1)
            exit for
        end if
        if sqlca.sqlerrd[3] = 0 then
        -- 无继续处理的必要
            message "bom 展开完毕"
            exit for
        end if
    end for

end function

function ceci400_temp()
    whenever any error continue
        drop table ceci400_temp
    whenever any error stop
    create temp table ceci400_temp(
        ecu01_1   varchar(40),
        ecu02_1   varchar(10),
        lev   integer
    )
end function

function ceci400_b_entry()
    call cl_set_comp_entry("tc_eci06",true) 

end function
function ceci400_b_no_entry()
    call cl_set_comp_entry("tc_eci05",false)
end function

# p_cmd  true 锁定，false 解锁
function ceci400_close(p_cmd)
    define p_cmd  like type_file.chr1
    define l_index,l_cnt,l_cnt2 integer
    define sr record
        tc_eci03_i    like tc_eci_file.tc_eci03,
        tc_eci06_i    like tc_eci_file.tc_eci06
        end record
    define l_sql    string
    define l_tc_eci03   like tc_eci_file.tc_eci03
    define l_tc_eci04   like tc_eci_file.tc_eci04
    define l_tc_eci15   like tc_eci_file.tc_eci15
    define l_ecu06      like ecu_file.ecu06
    define l_message    string
    
    let l_tc_eci15 = iif(p_cmd,'2','1')
    let l_ecu06 = iif (p_cmd,'Y','N')

    initialize sr.* to null
    open window w_i400_1 with form "cec/42f/ceci400_1"
        input by name sr.*
            
            before input
                let sr.tc_eci03_i = g_today
            on change tc_eci03_i
                if not cl_null(sr.tc_eci03_i) then
                    if sr.tc_eci03_i < g_today then
                        call cl_err(sr.tc_eci03_i,'cec-042',1)
                        next field tc_eci03_i
                    end if
                else
                    call cl_err(sr.tc_eci03_i,'cec-040',1)
                    next field tc_eci03_i
                end if
            
            on change tc_eci06_i
                if cl_null(sr.tc_eci06_i) then
                    call cl_err(sr.tc_eci06_i,'cec-041',1)
                    next field tc_eci06_i
                end if

            on action accept
                if cl_null(sr.tc_eci06_i) then
                    call cl_err('','cec-041',0)
                    next field tc_eci06_i
                end if
                exit input
            on action cancel
                exit input
        end input
    close window w_i400_1
    if int_flag then
        message "已取消"
        return
    end if

    # 1. 锁定ecu资料 
    begin work

    let g_success = 'Y'
    let l_sql = "select * from ecu_file where (ecu01,ecu02) in (select ecu01_1,ecu02_1 from ceci400_temp) for update"
    declare i400_cl2 cursor from l_sql
    open i400_cl2
    if status then
        call cl_err("open t310_cl.", status, 1)
        close i400_cl2
        rollback work
        let g_success = 'N'
        return
    end if
    fetch i400_cl2
    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
        close i400_cl2
        rollback work
        let g_success = 'N'
        return
    end if
    let l_cnt = 0
    for l_index = 1 to g_tc_eci.getlength()
        if g_tc_eci[l_ac].sure !='Y' then
            continue for
        end if
        # 2. 更新tc_eci 资料
            # 2.1 如果有资料就更新，没资料就insert
        select count(1) into l_cnt2 from tc_eci_file 
         where tc_eci01 = g_tc_eci[l_index].ecb01 and tc_eci02 =g_tc_eci[l_index].ecb02 
           and tc_eci03 = g_tc_eci[l_index].tc_eci03
           and tc_eci15 = l_tc_eci15
        if l_cnt2 > 0 then
            update tc_eci_file 
                set tc_eci03 = g_today,
                    tc_eci05 = g_user,
                    tc_eci06 = sr.tc_eci06_i
                where tc_eci01 = g_tc_eci[l_index].ecb01
                and tc_eci02 = g_tc_eci[l_index].ecb02
                and tc_eci03 = g_tc_eci[l_index].tc_eci03
                and tc_eci15 = l_tc_eci15
            if sqlca.sqlcode then
                call cl_err('ins tc_eci',sqlca.sqlcode,1)
                # rollback work
                let g_success = 'N'
            end if
        else
            insert into tc_eci_file (
                tc_eci01,tc_eci02,tc_eci03,tc_eci05,tc_eci06,tc_eci15
            )values(
                g_tc_eci[l_index].ecb01,g_tc_eci[l_index].ecb02,g_today,
                g_user,sr.tc_eci06_i,l_tc_eci15
            )
            if sqlca.sqlcode then
                call cl_err("ins tc_eci.", status, 1)
                close i400_cl2
                rollback work
                let g_success = 'N'
                exit for
            end if
        end if
        # 3. 更新 ecu06
        update ecu_file set ecu06 = l_ecu06
         where ecu01 = g_tc_eci[l_index].ecb01 and ecu02 = g_tc_eci[l_index].ecb02
        if sqlca.sqlcode then
            call cl_err("upd ecu.", status, 1)
            close i400_cl2
            rollback work
            let g_success = 'N'
            exit for
        end if
        let l_cnt = l_cnt + 1
    end for
    # 4. 提交
    if g_success ='Y' then
        commit work
        for l_index = 1 to g_tc_eci.getlength()
            if g_tc_eci[l_index].sure !='Y' then
                continue for
            end if
            let g_tc_eci[l_index].ecu06 = l_ecu06
            let g_tc_eci[l_index].tc_eci03 = g_today
            let g_tc_eci[l_index].tc_eci05 = g_user
            select gen02 into g_tc_eci[l_index].gen02 from gen_file where gen01 = g_tc_eci[l_index].tc_eci05
            let g_tc_eci[l_index].tc_eci06 = sr.tc_eci06_i
        end for
        call cl_err_msg('更新成功','cec-039',l_cnt,1)
    else
        close i400_cl2
        rollback work
        return
    end if
end function

