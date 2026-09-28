# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cimi300.4gl
# Descriptions...: 耗材领用维护
# Date & Author..: darcy:2025/02/13

database ds
 
globals "../../../tiptop/config/top.global"
type tc_imh record
    tc_imh01    like tc_imh_file.tc_imh01,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021,
    tc_imh02    like tc_imh_file.tc_imh02,
    eca02       like eca_file.eca02,
    gem01       like gem_file.gem01,
    gem02       like gem_file.gem02,
    tc_imh03    like tc_imh_file.tc_imh03,
    tc_imh04    like tc_imh_file.tc_imh04,
    tc_imh05    like tc_imh_file.tc_imh05,
    weekamt     decimal(15,3),
    avlamt      decimal(15,3),
    tc_imh06    like tc_imh_file.tc_imh06,
    tc_imh07    like tc_imh_file.tc_imh07,
    tc_imh08    like tc_imh_file.tc_imh08,
    tc_imh09    like tc_imh_file.tc_imh09,
    tc_imh10    like tc_imh_file.tc_imh10,
    tc_imh11    like tc_imh_file.tc_imh11,
    tc_imh12    like tc_imh_file.tc_imh12,
    tc_imh13    like tc_imh_file.tc_imh13,
    tc_imh14    like tc_imh_file.tc_imh14,
    tc_imh15    like tc_imh_file.tc_imh15
    end record

define g_tc_imh dynamic array of tc_imh
define g_tc_imh_t tc_imh

# 常用字段define  s---
define g_wc,g_sql             string
define g_forupd_sql           string
define g_rec_b,l_ac,g_cnt     integer
define g_before_input_done    varchar(1)
# 常用字段define  e---

MAIN
    define p_row,p_col  integer
    options
        input no wrap
    defer interrupt

    if (not cl_user()) then
        exit program
    end if

    whenever error call cl_err_msg_log

    if (not cl_setup("CIM")) then
        exit program
    end if

    call  cl_used(g_prog,g_time,1)
         returning g_time
    
    let p_row = 4 let p_col = 3
    # 打开窗口 s---
    open window i040_w at p_row,p_col with form "cim/42f/cimi300"
     attribute (style = g_win_style clipped)
    # 打开窗口 e---

    call cl_ui_init()

    call i300_b_fill(' 1=1')  #先将资料show出来
    call i300_menu()    #进入菜单

    call cl_used(g_prog,g_time,2) returning g_time

END MAIN

function i300_menu()
    while true
        call i300_bp("G")
        case g_action_choice
            when "query"
                if cl_chk_act_auth() then
                    call i300_q()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call i300_b()
                end if
                let g_action_choice = null
            when "delete"
                if cl_chk_act_auth() then
                    call i300_r()
                end if
            when "help"
                call cl_show_help()
            when "exit"
                exit while
            when "controlg"
                call cl_cmdask()
            when 'fresh'
                call i300_fresh()
            when "related_document"
                if cl_chk_act_auth() and l_ac != 0 then 
                    let g_doc.column1 = "tc_imh01"
                    let g_doc.value1 = "demo"
                    call cl_doc()
                end if
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(
                        cl_expexcel1( "s_tc_imh",base.typeinfo.create(g_tc_imh))
                    )
                end if
        end case
    end while
end function

# 查询
function i300_q()
    call i300_b_askkey()
end function

# 单身修改/录入/删除
function i300_b()
    define l_allow_insert   like type_file.chr1
    define l_allow_delete   like type_file.chr1
    define p_cmd            like type_file.chr1
    define l_lock_sw        like type_file.chr1
    define l_n,l_cnt,l_ac_t like type_file.num5
    define l_ima25          like ima_file.ima25
    define l_failed         like type_file.num5
    define l_fac            decimal(20,8) 

    if s_shut(0) then
        return
    end if
    call cl_opmsg('b')
    let g_action_choice = null
    let l_allow_insert = cl_detail_input_auth('insert')
    let l_allow_delete = cl_detail_input_auth('delete')

    let g_forupd_sql = "select tc_imh01,'','',tc_imh02,'','','',tc_imh03,tc_imh04,tc_imh05,0,0,",
                       "       tc_imh06,tc_imh07,tc_imh08,tc_imh09, ",
                       "       tc_imh10,tc_imh11,tc_imh12,tc_imh13,tc_imh14,tc_imh15 ",
                       "  from tc_imh_file where tc_imh01=? and tc_imh02=? for update "
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare i300_bcl cursor from g_forupd_sql

    input array g_tc_imh without defaults from s_tc_imh.*
        attribute (count=g_rec_b,maxcount=g_max_rec,unbuffered,
                     insert row = l_allow_insert,delete row=l_allow_delete,append row=l_allow_insert)

        before input
            if g_rec_b !=0 then
                call fgl_set_arr_curr(l_ac)
            end if
        
        before row
            let p_cmd = ''
            let l_ac = arr_curr()
            let l_lock_sw = 'N'
            let l_n = arr_curr()
            
            if g_rec_b >= l_ac then
                begin work
                let p_cmd = 'u'

                let g_before_input_done = false 
                let g_before_input_done = true
                let g_tc_imh_t.* = g_tc_imh[l_ac].*
                open i300_bcl using g_tc_imh_t.tc_imh01,g_tc_imh_t.tc_imh02
                if status then
                    call cl_err('open i300_bcl:',status,1)
                    let l_lock_sw = 'Y'
                else
                    fetch i300_bcl into g_tc_imh[l_ac].*
                    if sqlca.sqlcode then
                        call cl_err(g_tc_imh_t.tc_imh01,sqlca.sqlcode,1)
                        let l_lock_sw = 'Y'
                    end if
                end if
                select ima02,ima021 into g_tc_imh[l_ac].ima02,g_tc_imh[l_ac].ima021
                  from ima_file where ima01 = g_tc_imh[l_ac].tc_imh01
                select eca02,eca03,gem02 into g_tc_imh[l_ac].eca02,g_tc_imh[l_ac].gem01,g_tc_imh[l_ac].gem02
                  from eca_file,gem_file where gem01 = eca03 and eca01 = g_tc_imh[l_ac].tc_imh02
                -- darcy:2025/06/04 mark add s---
                -- call i300_weekamt(g_tc_imh[l_ac].tc_imh01,g_tc_imh[l_ac].tc_imh02,g_tc_imh[l_ac].tc_imh03)
                --     returning g_tc_imh[l_ac].weekamt
                -- let g_tc_imh[l_ac].avlamt = g_tc_imh[l_ac].tc_imh04 - g_tc_imh[l_ac].weekamt
                -- darcy:2025/06/04 mark add e---

                call cl_show_fld_cont()
            end if

        before insert
            let l_n = arr_curr()
            let p_cmd = 'a'

            let g_before_input_done = false
            # call i300_set_entry
            let g_before_input_done = true

            initialize g_tc_imh[l_ac].* to null
            
            # 默认值 s---
            let g_tc_imh[l_ac].tc_imh04 = 0
            let g_tc_imh[l_ac].tc_imh06 = current year to second
            let g_tc_imh[l_ac].tc_imh07 = current year to second
            let g_tc_imh[l_ac].tc_imh08 = g_user
            let g_tc_imh[l_ac].tc_imh09 = g_user
            let g_tc_imh[l_ac].tc_imh10 = 'Y'
            let g_tc_imh_t.* = g_tc_imh[l_ac].*
            call cl_show_fld_cont()
            next field tc_imh01
            # 默认值 e---

        after insert
            display 'after insert'

            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                close i300_bcl
                cancel insert
            end if

            begin work

            insert into tc_imh_file(
                tc_imh01,tc_imh02,tc_imh03,tc_imh04,tc_imh05,tc_imh06,tc_imh07,tc_imh08,tc_imh09,tc_imh10,
                tc_imh11,tc_imh12,tc_imh13,tc_imh14,tc_imh15
            ) values (
                g_tc_imh[l_ac].tc_imh01,g_tc_imh[l_ac].tc_imh02,g_tc_imh[l_ac].tc_imh03,g_tc_imh[l_ac].tc_imh04,g_tc_imh[l_ac].tc_imh05,
                g_tc_imh[l_ac].tc_imh06,g_tc_imh[l_ac].tc_imh07,g_tc_imh[l_ac].tc_imh08,g_tc_imh[l_ac].tc_imh09,g_tc_imh[l_ac].tc_imh10,
                g_tc_imh[l_ac].tc_imh11,g_tc_imh[l_ac].tc_imh12,g_tc_imh[l_ac].tc_imh13,g_tc_imh[l_ac].tc_imh14,g_tc_imh[l_ac].tc_imh15
            )
            if sqlca.sqlcode then
                call cl_err3("ins","tc_imh_file",g_tc_imh[l_ac].tc_imh01,'',sqlca.sqlcode,'','',1)
                rollback work
                cancel insert
            else
                commit work
            end if
            
        after field tc_imh01
            if  not cl_null(g_tc_imh[l_ac].tc_imh01) then

                if not s_chk_item_no(g_tc_imh[l_ac].tc_imh01,'') then
                    call cl_err('',g_errno,1)
                    let g_tc_imh[l_ac].tc_imh01 = g_tc_imh_t.tc_imh01
                    next field  tc_imh01
                end if
                if  not cl_null(g_tc_imh[l_ac].tc_imh02) 
                    and (g_tc_imh_t.tc_imh01 != g_tc_imh[l_ac].tc_imh01 or g_tc_imh_t.tc_imh02 != g_tc_imh[l_ac].tc_imh02) then
                    let l_cnt = 0
                    select count(1) into l_cnt from tc_imh_file
                    where tc_imh01 = g_tc_imh[l_ac].tc_imh01 and tc_imh02 = g_tc_imh[l_ac].tc_imh02
                    if l_cnt > 0 then
                        call cl_err(sfmt('料号：%1 工作站：%2',g_tc_imh[l_ac].tc_imh01,g_tc_imh[l_ac].tc_imh02),'cim-038',0)
                        next field current
                    end if
                end if
                select ima02,ima021,ima25 into g_tc_imh[l_ac].ima02,g_tc_imh[l_ac].ima021,l_ima25
                  from ima_file where ima01 = g_tc_imh[l_ac].tc_imh01
                if cl_null(g_tc_imh[l_ac].tc_imh03) then
                    let g_tc_imh[l_ac].tc_imh03 = l_ima25
                end if
                display by name g_tc_imh[l_ac].ima02,g_tc_imh[l_ac].ima021,g_tc_imh[l_ac].tc_imh03
            end if
        after field tc_imh02
            if  not cl_null(g_tc_imh[l_ac].tc_imh02) then
                let l_cnt = 0
                select count(*) into l_cnt from eca_file where eca01 = g_tc_imh[l_ac].tc_imh02
                if l_cnt = 0 then
                    call cl_err(g_tc_imh[l_ac].tc_imh02,'aec-054',0)
                    next field tc_imh02
                end if
                if  not cl_null(g_tc_imh[l_ac].tc_imh02) 
                    and (g_tc_imh_t.tc_imh01 != g_tc_imh[l_ac].tc_imh01 or g_tc_imh_t.tc_imh02 != g_tc_imh[l_ac].tc_imh02) then
                    let l_cnt = 0
                    select count(1) into l_cnt from tc_imh_file
                    where tc_imh01 = g_tc_imh[l_ac].tc_imh01 and tc_imh02 = g_tc_imh[l_ac].tc_imh02
                    if l_cnt > 0 then
                        call cl_err(sfmt('料号：%1 工作站：%2',g_tc_imh[l_ac].tc_imh01,g_tc_imh[l_ac].tc_imh02),'cim-038',0)
                        next field tc_imh02
                    end if
                end if
                select eca02,eca03,gem02 into g_tc_imh[l_ac].eca02,g_tc_imh[l_ac].gem01,g_tc_imh[l_ac].gem02
                  from eca_file,gem_file where eca01 = g_tc_imh[l_ac].tc_imh02 and gem01 = eca03
                display by name g_tc_imh[l_ac].eca02,g_tc_imh[l_ac].gem01,g_tc_imh[l_ac].gem02
            end if
        after field tc_imh03
            if not cl_null(g_tc_imh[l_ac].tc_imh03) then
                select ima25 into l_ima25 from ima_file where ima01 = g_tc_imh[l_ac].tc_imh01
                if g_tc_imh[l_ac].tc_imh03 != l_ima25 then
                    call s_umfchk(g_tc_imh[l_ac].tc_imh01,l_ima25,g_tc_imh[l_ac].tc_imh03)
                        returning l_failed,l_fac
                    if l_failed then
                        call cl_err(sfmt('换算率抓取不到，料号：%1 库存单位:%2 单位：%3',g_tc_imh[l_ac].tc_imh01,l_ima25,g_tc_imh[l_ac].tc_imh03),'abm-731',1)
                        next field tc_imh03
                    end if
                end if
            end if
        
        before delete
            if not cl_null(g_tc_imh_t.tc_imh01) and not cl_null(g_tc_imh_t.tc_imh02) then
                if not cl_delete() then
                    rollback work
                    cancel delete
                end if
                if l_lock_sw = 'Y' then
                    call cl_err('',-263,1)
                    rollback work
                    cancel delete
                end if
                delete from tc_imh_file
                 where tc_imh01 = g_tc_imh_t.tc_imh01 and tc_imh02 = g_tc_imh_t.tc_imh02
                if sqlca.sqlcode then
                    call cl_err3('del','tc_imh_file',g_tc_imh_t.tc_imh01,'',sqlca.sqlcode,'','',1)
                    rollback work
                    cancel delete
                    exit input
                end if
            end if
        
        on row change
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                let g_tc_imh[l_ac].* = g_tc_imh_t.*
                close i300_bcl
                rollback work
                exit input
            end if
            if l_lock_sw = 'Y' then
                call cl_err(sfmt('料号：%1 工作站：%2',g_tc_imh[l_ac].tc_imh01,g_tc_imh[l_ac].tc_imh02),-262,0)
                let g_tc_imh[l_ac].* = g_tc_imh_t.*
            else
                let g_tc_imh[l_ac].tc_imh07 = current year to second
                let g_tc_imh[l_ac].tc_imh09 = g_user
                update tc_imh_file
                    set tc_imh01 = g_tc_imh[l_ac].tc_imh01,tc_imh02 = g_tc_imh[l_ac].tc_imh02,tc_imh03 = g_tc_imh[l_ac].tc_imh03,tc_imh04 = g_tc_imh[l_ac].tc_imh04,tc_imh05 = g_tc_imh[l_ac].tc_imh05,
                        tc_imh06 = g_tc_imh[l_ac].tc_imh06,tc_imh07 = g_tc_imh[l_ac].tc_imh07,tc_imh08 = g_tc_imh[l_ac].tc_imh08,tc_imh09 = g_tc_imh[l_ac].tc_imh09,tc_imh10 = g_tc_imh[l_ac].tc_imh10,
                        tc_imh11 = g_tc_imh[l_ac].tc_imh11,tc_imh12 = g_tc_imh[l_ac].tc_imh12,tc_imh13 = g_tc_imh[l_ac].tc_imh13,tc_imh14 = g_tc_imh[l_ac].tc_imh14,tc_imh15 = g_tc_imh[l_ac].tc_imh15
                 where tc_imh01 = g_tc_imh_t.tc_imh01 and tc_imh02 = g_tc_imh_t.tc_imh02
                if sqlca.sqlcode then
                    call cl_err3('upd','tc_imh_file',g_tc_imh_t.tc_imh01,'',sqlca.sqlcode,'','',1)
                    rollback work
                    let g_tc_imh[l_ac].* = g_tc_imh_t.*
                else
                    commit work
                end if
            end if
        
        after row
            let l_ac = arr_curr()
            
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                if p_cmd = 'u' then
                    let g_tc_imh[l_ac].* = g_tc_imh_t.*
                else
                    call g_tc_imh.deleteElement(l_ac)
                    if g_rec_b != 0 then
                        let g_action_choice = 'detail'
                        let l_ac = l_ac_t
                    end if
                end if
                close i300_bcl
                rollback work
                exit input
            end if
            let l_ac_t = l_ac
            close i300_bcl
            commit work
        
        on action controlo
            if infield(tc_imh01) and l_ac > 1 then
                let g_tc_imh[l_ac].* = g_tc_imh[l_ac-1].*
                next field tc_imh01
            end if
        
        on action controlp
            case
                when infield(tc_imh01)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_ima'
                    call cl_create_qry() returning g_tc_imh[l_ac].tc_imh01
                    display g_tc_imh[l_ac].tc_imh01 to tc_imh01
                    next field tc_imh01
                when infield(tc_imh02)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_eca1'
                    call cl_create_qry() returning g_tc_imh[l_ac].tc_imh02
                    display g_tc_imh[l_ac].tc_imh02 to tc_imh02
                    next field tc_imh02 
            end case
        
        on action controlr
            call cl_show_req_fields()
        
        on action controlg
            call cl_cmdask()
        
        on action controlf
            call cl_set_focus_form(ui.Interface.getRootNode()) 
                returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)
        
        on IDLE g_idle_seconds
            call cl_on_idle()
            continue input
        
        on action about
            call cl_about()
        
        on action help
            call cl_show_help()
        
        # 自定义按钮 s---
        # 自定义按钮 e---
        
    end input

    close i300_bcl
    commit work
end function

# 查询条件产生
function i300_b_askkey()
    clear form  #清除栏位值
    call g_tc_imh.clear()

    construct g_wc on 
        tc_imh01,tc_imh02,tc_imh03,tc_imh04,tc_imh05,tc_imh06,tc_imh07,tc_imh08,tc_imh09,tc_imh10,
        tc_imh11,tc_imh12,tc_imh13,tc_imh14,tc_imh15
        from
        s_tc_imh[1].tc_imh01,s_tc_imh[1].tc_imh02,s_tc_imh[1].tc_imh03,s_tc_imh[1].tc_imh04,s_tc_imh[1].tc_imh05,
        s_tc_imh[1].tc_imh06,s_tc_imh[1].tc_imh07,s_tc_imh[1].tc_imh08,s_tc_imh[1].tc_imh09,s_tc_imh[1].tc_imh10,
        s_tc_imh[1].tc_imh11,s_tc_imh[1].tc_imh12,s_tc_imh[1].tc_imh13,s_tc_imh[1].tc_imh14,s_tc_imh[1].tc_imh15

        before construct
            call cl_qbe_init()
        
        on action controlp
            case 
                when infield(tc_imh01)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_ima'
                    let g_qryparam.state = 'c'
                    call cl_create_qry () returning g_qryparam.multiret
                    display g_qryparam.multiret to s_tc_imh[1].tc_imh01
                    next field tc_imh01

                when infield(tc_imh02)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_eca1'
                    let g_qryparam.state = 'c'
                    call cl_create_qry () returning g_qryparam.multiret
                    display g_qryparam.multiret to s_tc_imh[1].tc_imh02
                    next field tc_imh02

                otherwise
                    exit case
            end case
        on IDLE g_idle_seconds
            call cl_on_idle()
            continue construct
        
        on action about
            call cl_about()
        
        on action help
            call cl_show_help()

        on action controlg
            call cl_cmdask()
        
        on action qbe_select
            call cl_qbe_select()
        
        on action qbe_save
            call cl_qbe_save()

    end construct
    
    if int_flag then
        let int_flag = 0 
        let g_wc = null
        return
    end if
    call i300_b_fill(g_wc)
end function

# 单身资料生成
function i300_b_fill(p_wc)
    define p_wc         string

    let g_sql = "select tc_imh01,ima02,ima021,tc_imh02,eca02,gem01,gem02,tc_imh03,tc_imh04,tc_imh05, ",
                "       0,0,tc_imh06,tc_imh07,tc_imh08,tc_imh09, ",
                "       tc_imh10,tc_imh11,tc_imh12,tc_imh13,tc_imh14,tc_imh15  ",
                "  from tc_imh_file left join eca_file on eca01 = tc_imh02 ",
                "   left join gem_file on gem01 = eca03 ",
                "   left join ima_file on ima01 = tc_imh01",
                " where ",p_wc clipped," order by tc_imh01,tc_imh02"
    prepare i300_pb from g_sql
    declare tc_imh_curs cursor for i300_pb

    call g_tc_imh.clear()
    let g_cnt = 1
    message 'Seaching!'
    foreach tc_imh_curs into g_tc_imh[g_cnt].*
        if status then
            call cl_err('foreach:',status,1)
            exit foreach
        end if
        -- darcy:2025/06/04 mark s---
        -- call i300_weekamt(g_tc_imh[g_cnt].tc_imh01,g_tc_imh[g_cnt].tc_imh02,g_tc_imh[g_cnt].tc_imh03)
        --     returning g_tc_imh[g_cnt].weekamt
        -- let g_tc_imh[g_cnt].avlamt = g_tc_imh[g_cnt].tc_imh04 - g_tc_imh[g_cnt].weekamt
        -- darcy:2025/06/04 mark e---
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err('',9035,0)
            exit foreach
        end if
    end foreach
    call g_tc_imh.deleteElement(g_cnt)
    message ''
    let g_rec_b = g_cnt - 1
    display g_rec_b to formonly.cn2
    let g_cnt = 0                                   
end function

# 单身显示和action菜单
function i300_bp(p_ud)
    define p_ud     like type_file.chr1

    if p_ud != 'G' OR g_action_choice ='detail' then
        return
    end if

    let g_action_choice = ''

    call cl_set_act_visible('accept,cancel',false)
    display array g_tc_imh to s_tc_imh.* attribute(count=g_rec_b)

        before display

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()

        on action query
            let g_action_choice = 'query'
            exit display
        
        on action delete
            let g_action_choice = 'delete'
            exit display
        
        on action detail
            let g_action_choice = 'detail'
            let l_ac = 1
            exit display
        
        on action help
            let g_action_choice = 'help'
            exit display
        
        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()
        
        on action exit
            let g_action_choice = 'exit'
            exit display
        
        on action controlg
            let g_action_choice = 'controlg'
            exit display
        
        on action accept
            let g_action_choice = 'detail'
            exit display
        
        on action cancel
            let g_action_choice = 'exit'
            exit display
        
        on IDLE g_idle_seconds
            call cl_on_idle()
            continue display
        
        on action about
            call cl_about()
        
        on action related_document
            let g_action_choice = 'related_document'
            exit display
        
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display

        on action fresh
            let g_action_choice = 'fresh'
            exit display
        
        after display
            continue display

    end display

    call cl_set_act_visible('accept,cancel',true)
end function
function i300_weekamt(p_ima01,p_eca01,p_unit)
    define  p_ima01     like ima_file.ima01,
            p_eca01     like eca_file.eca01
    define l_weekamt    decimal(15,3)
    define l_gem01      like gem_file.gem01
    define p_unit   like inb_file.inb08
    define l_begin,l_end    date
    define l_inb08,l_tc_imh03  like inb_file.inb08
    define l_inb09  like inb_file.inb09
    define l_ima25  like ima_file.ima25
    define l_sql    string 
    define l_ok      varchar(1)
    define l_fac  decimal(20,6)
    define l_flag varchar(1)

    # 获取日期所属周的周日和周六两个日期
   let l_sql = "select min(azn01), max(azn01)  ",
               "  from azn_file where (azn02, azn05) in",
               " (select azn02, azn05 from azn_file where azn01 = '",g_today,"')"
   prepare i300_azn from l_sql
   execute i300_azn into l_begin,l_end
   if l_end == g_today  then
      -- 向后取一周
      let g_today = g_today + 1
      execute i300_azn into l_begin,l_end
   end if
      let l_begin = l_begin - 1
      let l_end = l_end - 1

    select eca03 into l_gem01 from eca_file where eca01 = p_eca01

    declare i300_weekamt cursor for
    select inb08,inb09
     from ina_file,inb_file where ina01 = inb01
      and inaconf <> 'X' and ina00 = '1'
      and inb04 = p_ima01 and ina04 = l_gem01
      and (
         (inapost ='Y' and ina02 between l_begin and l_end)
         or (inapost !='Y' and ina03 between l_begin and l_end)
      )

   let l_weekamt = 0
   foreach i300_weekamt into l_inb08,l_inb09
      if sqlca.sqlcode then
         call cl_err('i300_weekamt',sqlca.sqlcode,1)
         exit foreach
      end if

      if l_inb08!=p_unit then
         call s_umfchk(p_ima01,l_inb08,p_unit) returning l_flag,l_fac
         if l_flag = 1 then
            let l_fac = 1
         end if
      else
         let l_fac = 1
      end if
      let l_weekamt = s_digqty(l_weekamt + l_inb09 * l_fac , p_unit)
   end foreach

    return l_weekamt
end function

function i300_r()
    IF s_shut(0) THEN RETURN END IF  

    if cl_confirm('csm-002') then
        delete from tc_imh_file
        if sqlca.sqlcode then
            call cl_err('del tc_imh',sqlca.sqlcode,1)
            return
        end if
    end if
end function

function i300_fresh()
    define i  integer

    for i = 1 to g_tc_imh.getLength()
        call i300_weekamt(g_tc_imh[i].tc_imh01,g_tc_imh[i].tc_imh02,g_tc_imh[i].tc_imh03)
            returning g_tc_imh[i].weekamt
        let g_tc_imh[i].avlamt = g_tc_imh[i].tc_imh04 - g_tc_imh[i].weekamt
    end for
    
end function
