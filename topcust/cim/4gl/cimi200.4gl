# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cimi200.4gl
# Descriptions...: 料件计划维护
# Date & Author..:darcy:2023/04/20 add

database ds
 
globals "../../../tiptop/config/top.global"

# 单身字段define  s---
type tc_pla record
    tc_pla01        like tc_pla_file.tc_pla01,
    tc_pla02        like tc_pla_file.tc_pla02,
    tc_pla03        like tc_pla_file.tc_pla03,
    gen02           like gen_file.gen02,
    tc_pla04        like tc_pla_file.tc_pla04,
    tc_pla05        like tc_pla_file.tc_pla05,
    tc_pla06        like tc_pla_file.tc_pla06,
    tc_pla07        like tc_pla_file.tc_pla07,
    tc_pla08        like tc_pla_file.tc_pla08,
    tc_pla09        like tc_pla_file.tc_pla09,
    tc_pla10        like tc_pla_file.tc_pla10,
    tc_pla11        like tc_pla_file.tc_pla11,
    tc_pla12        like tc_pla_file.tc_pla12,
    tc_pla13        like tc_pla_file.tc_pla13,
    tc_pla14        like tc_pla_file.tc_pla14,
    tc_pla15        like tc_pla_file.tc_pla15,
    tc_pla16        like tc_pla_file.tc_pla16,
    tc_pla17        like tc_pla_file.tc_pla17,
    tc_pla18        like tc_pla_file.tc_pla18,
    tc_pla19        like tc_pla_file.tc_pla19,
    tc_pla20        like tc_pla_file.tc_pla20,
    tc_pla21        like tc_pla_file.tc_pla21,
    tc_pla22        like tc_pla_file.tc_pla22,
    tc_pla23        like tc_pla_file.tc_pla23,
    tc_pla24        like tc_pla_file.tc_pla24,
    tc_pla25        like tc_pla_file.tc_pla25,
    tc_pla26        like tc_pla_file.tc_pla26,
    tc_pla27        like tc_pla_file.tc_pla27,
    tc_pla28        like tc_pla_file.tc_pla28,
    tc_pla29        like tc_pla_file.tc_pla29,
    tc_pla30        like tc_pla_file.tc_pla30,
    tc_pla31        like tc_pla_file.tc_pla31,
    tc_pla32        like tc_pla_file.tc_pla32,
    tc_pla33        like tc_pla_file.tc_pla33,

    tc_pla34        like tc_pla_file.tc_pla34,
    tc_pla35        like tc_pla_file.tc_pla35
end record

define g_tc_pla  dynamic array of tc_pla
define g_tc_pla_t tc_pla

# 单身字段define  e---

# 常用字段define  s---
define g_wc,g_sql             string
define g_forupd_sql           string
define g_rec_b,l_ac,g_cnt     integer
define g_before_input_done    varchar(1)
# 常用字段define  e---

#客制字段define s---

#客制字段define e--- 

main
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
    open window i040_w at p_row,p_col with form "cim/42f/cimi200"
     attribute (style = g_win_style clipped)
    # 打开窗口 e---

    call cl_ui_init()

    call i200_b_fill(' 1=1')  #先将资料show出来
    call i200_menu()    #进入菜单

    call cl_used(g_prog,g_time,2) returning g_time
end main

function i200_menu()
    while true
        call i200_bp("G")
        case g_action_choice
            when "query"
                if cl_chk_act_auth() then
                    call i200_q()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call i200_b()
                end if
                let g_action_choice = null
            when "help"
                call cl_show_help()
            when "exit"
                exit while
            when "controlg"
                call cl_cmdask()
            when "related_document"
                if cl_chk_act_auth() and l_ac != 0 then 
                    let g_doc.column1 = "tc_pla01"
                    let g_doc.value1 = "demo"
                    call cl_doc()
                end if
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_pla),'','')
                end if
        end case
    end while
end function

# 查询
function i200_q()
    call i200_b_askkey()
end function

# 单身修改/录入/删除
function i200_b()
    define l_allow_insert   like type_file.chr1
    define l_allow_delete   like type_file.chr1
    define p_cmd            like type_file.chr1
    define l_lock_sw        like type_file.chr1
    define l_n,l_cnt,l_ac_t like type_file.num5

    if s_shut(0) then
        return
    end if
    call cl_opmsg('b')
    let g_action_choice = null
    let l_allow_insert = cl_detail_input_auth('insert')
    let l_allow_delete = cl_detail_input_auth('delete')

    let g_forupd_sql = "select tc_pla01,tc_pla02,tc_pla03,'',tc_pla04,tc_pla05,tc_pla06,tc_pla07,tc_pla08,tc_pla09, ",
                       "       tc_pla10,tc_pla11,tc_pla12,tc_pla13,tc_pla14,tc_pla15,tc_pla16,tc_pla17,tc_pla18, ",
                       "       tc_pla19,tc_pla20,tc_pla21,tc_pla22,tc_pla23,tc_pla24,tc_pla25,tc_pla26,tc_pla27, ",
                       "       tc_pla28,tc_pla29,tc_pla30,tc_pla31,tc_pla32,tc_pla33,tc_pla34,tc_pla35 ",
                       "  from tc_pla_file where tc_pla01=? and tc_pla04=? for update "
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare i200_bcl cursor from g_forupd_sql

    input array g_tc_pla without defaults from s_tc_pla.*
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
                # i200_set_entry
                # i200_set_no_entry
                let g_before_input_done = true
                let g_tc_pla_t.* = g_tc_pla[l_ac].*
                open i200_bcl using g_tc_pla_t.tc_pla01,g_tc_pla_t.tc_pla04
                if status then
                    call cl_err('open i200_bcl:',status,1)
                    let l_lock_sw = 'Y'
                else
                    fetch i200_bcl into g_tc_pla[l_ac].*
                    if sqlca.sqlcode then
                        call cl_err(g_tc_pla_t.tc_pla01,sqlca.sqlcode,1)
                        let l_lock_sw = 'Y'
                    end if
                end if
                select gen02 into g_tc_pla[l_ac].gen02 from gen_file
                 where gen01 = g_tc_pla[l_ac].tc_pla03
                call cl_show_fld_cont()
            end if

        before insert
            let l_n = arr_curr()
            let p_cmd = 'a'

            let g_before_input_done = false
            # call i200_set_entry
            let g_before_input_done = true

            initialize g_tc_pla[l_ac].* to null
            
            # 默认值 s---
            let g_tc_pla[l_ac].tc_pla04 = g_today
            let g_tc_pla[l_ac].tc_pla03 = g_user
            let g_tc_pla[l_ac].tc_pla02 = 'Y'
            let g_tc_pla[l_ac].tc_pla05 = 0 let g_tc_pla[l_ac].tc_pla06 = 0 let g_tc_pla[l_ac].tc_pla07 = 0 let g_tc_pla[l_ac].tc_pla08 = 0 let g_tc_pla[l_ac].tc_pla09 = 0 let g_tc_pla[l_ac].tc_pla10 = 0
            let g_tc_pla[l_ac].tc_pla11 = 0 let g_tc_pla[l_ac].tc_pla12 = 0 let g_tc_pla[l_ac].tc_pla13 = 0 let g_tc_pla[l_ac].tc_pla14 = 0 let g_tc_pla[l_ac].tc_pla15 = 0
            let g_tc_pla[l_ac].tc_pla16 = 0 let g_tc_pla[l_ac].tc_pla17 = 0 let g_tc_pla[l_ac].tc_pla18 = 0 let g_tc_pla[l_ac].tc_pla19 = 0 let g_tc_pla[l_ac].tc_pla20 = 0
            let g_tc_pla[l_ac].tc_pla21 = 0 let g_tc_pla[l_ac].tc_pla22 = 0 let g_tc_pla[l_ac].tc_pla23 = 0 let g_tc_pla[l_ac].tc_pla24 = 0 let g_tc_pla[l_ac].tc_pla25 = 0
            let g_tc_pla[l_ac].tc_pla26 = 0 let g_tc_pla[l_ac].tc_pla27 = 0 let g_tc_pla[l_ac].tc_pla28 = 0 let g_tc_pla[l_ac].tc_pla29 = 0 let g_tc_pla[l_ac].tc_pla30 = 0
            let g_tc_pla[l_ac].tc_pla31 = 0 let g_tc_pla[l_ac].tc_pla32 = 0 let g_tc_pla[l_ac].tc_pla33 = 0 let g_tc_pla[l_ac].tc_pla34 = 0 let g_tc_pla[l_ac].tc_pla35 = 0
            select gen02 into g_tc_pla[l_ac].gen02 from gen_file
             where gen01 = g_tc_pla[l_ac].tc_pla03
            let g_tc_pla_t.* = g_tc_pla[l_ac].*
            call cl_show_fld_cont()
            next field tc_pla01
            # 默认值 e---

        after insert
            display 'after insert'

            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                close i200_bcl
                cancel insert
            end if

            begin work

            insert into tc_pla_file(
                tc_pla01,tc_pla02,tc_pla03,tc_pla04,tc_pla05,tc_pla06,tc_pla07,tc_pla08,tc_pla09,tc_pla10,
                tc_pla11,tc_pla12,tc_pla13,tc_pla14,tc_pla15,tc_pla16,tc_pla17,tc_pla18,tc_pla19,tc_pla20,
                tc_pla21,tc_pla22,tc_pla23,tc_pla24,tc_pla25,tc_pla26,tc_pla27,tc_pla28,tc_pla29,tc_pla30,
                tc_pla31,tc_pla32,tc_pla33,tc_pla34,tc_pla35
            ) values (
                g_tc_pla[l_ac].tc_pla01,g_tc_pla[l_ac].tc_pla02,g_tc_pla[l_ac].tc_pla03,g_tc_pla[l_ac].tc_pla04,g_tc_pla[l_ac].tc_pla05,
                g_tc_pla[l_ac].tc_pla06,g_tc_pla[l_ac].tc_pla07,g_tc_pla[l_ac].tc_pla08,g_tc_pla[l_ac].tc_pla09,g_tc_pla[l_ac].tc_pla10,
                g_tc_pla[l_ac].tc_pla11,g_tc_pla[l_ac].tc_pla12,g_tc_pla[l_ac].tc_pla13,g_tc_pla[l_ac].tc_pla14,g_tc_pla[l_ac].tc_pla15,
                g_tc_pla[l_ac].tc_pla16,g_tc_pla[l_ac].tc_pla17,g_tc_pla[l_ac].tc_pla18,g_tc_pla[l_ac].tc_pla19,g_tc_pla[l_ac].tc_pla20,
                g_tc_pla[l_ac].tc_pla21,g_tc_pla[l_ac].tc_pla22,g_tc_pla[l_ac].tc_pla23,g_tc_pla[l_ac].tc_pla24,g_tc_pla[l_ac].tc_pla25,
                g_tc_pla[l_ac].tc_pla26,g_tc_pla[l_ac].tc_pla27,g_tc_pla[l_ac].tc_pla28,g_tc_pla[l_ac].tc_pla29,g_tc_pla[l_ac].tc_pla30,
                g_tc_pla[l_ac].tc_pla31,g_tc_pla[l_ac].tc_pla32,g_tc_pla[l_ac].tc_pla33,g_tc_pla[l_ac].tc_pla34,g_tc_pla[l_ac].tc_pla35
            )
            if sqlca.sqlcode then
                call cl_err3("ins","tc_pla_file",g_tc_pla[l_ac].tc_pla01,'',sqlca.sqlcode,'','',1)
                rollback work
                cancel insert
            else
                commit work
            end if
            
        after field tc_pla01
            if not cl_null(g_tc_pla[l_ac].tc_pla01) then
                let l_cnt = 0
                select count(1)  into l_cnt from bma_file
                 where bma01 = g_tc_pla[l_ac].tc_pla01 and bma05 <= g_today and bma10 ='2'
                if l_cnt = 0 then
                    call cl_err('','cim-026',0)
                    next field tc_pla01
                end if
            end if
        
        before delete
            if not cl_null(g_tc_pla_t.tc_pla01) then
                if not cl_delete() then
                    rollback work
                    cancel delete
                end if
                if l_lock_sw = 'Y' then
                    call cl_err('',-263,1)
                    rollback work
                    cancel delete
                end if
                delete from tc_pla_file
                 where tc_pla01 = g_tc_pla_t.tc_pla01 and tc_pla04= g_tc_pla_t.tc_pla04
                if sqlca.sqlcode then
                    call cl_err3('del','tc_pla_file',g_tc_pla_t.tc_pla01,'',sqlca.sqlcode,'','',1)
                    rollback work
                    cancel delete
                    exit input
                end if
            end if
        
        on row change
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                let g_tc_pla[l_ac].* = g_tc_pla_t.*
                close i200_bcl
                rollback work
                exit input
            end if
            if l_lock_sw = 'Y' then
                call cl_err(g_tc_pla[l_ac].tc_pla01,-262,0)
                let g_tc_pla[l_ac].* = g_tc_pla_t.*
            else
                update tc_pla_file
                    set tc_pla01 = g_tc_pla[l_ac].tc_pla01,tc_pla02 = g_tc_pla[l_ac].tc_pla02,tc_pla03 = g_tc_pla[l_ac].tc_pla03,tc_pla04 = g_tc_pla[l_ac].tc_pla04,tc_pla05 = g_tc_pla[l_ac].tc_pla05,
                        tc_pla06 = g_tc_pla[l_ac].tc_pla06,tc_pla07 = g_tc_pla[l_ac].tc_pla07,tc_pla08 = g_tc_pla[l_ac].tc_pla08,tc_pla09 = g_tc_pla[l_ac].tc_pla09,tc_pla10 = g_tc_pla[l_ac].tc_pla10,
                        tc_pla11 = g_tc_pla[l_ac].tc_pla11,tc_pla12 = g_tc_pla[l_ac].tc_pla12,tc_pla13 = g_tc_pla[l_ac].tc_pla13,tc_pla14 = g_tc_pla[l_ac].tc_pla14,tc_pla15 = g_tc_pla[l_ac].tc_pla15,
                        tc_pla16 = g_tc_pla[l_ac].tc_pla16,tc_pla17 = g_tc_pla[l_ac].tc_pla17,tc_pla18 = g_tc_pla[l_ac].tc_pla18,tc_pla19 = g_tc_pla[l_ac].tc_pla19,tc_pla20 = g_tc_pla[l_ac].tc_pla20,
                        tc_pla21 = g_tc_pla[l_ac].tc_pla21,tc_pla22 = g_tc_pla[l_ac].tc_pla22,tc_pla23 = g_tc_pla[l_ac].tc_pla23,tc_pla24 = g_tc_pla[l_ac].tc_pla24,tc_pla25 = g_tc_pla[l_ac].tc_pla25,
                        tc_pla26 = g_tc_pla[l_ac].tc_pla26,tc_pla27 = g_tc_pla[l_ac].tc_pla27,tc_pla28 = g_tc_pla[l_ac].tc_pla28,tc_pla29 = g_tc_pla[l_ac].tc_pla29,tc_pla30 = g_tc_pla[l_ac].tc_pla30,
                        tc_pla31 = g_tc_pla[l_ac].tc_pla31,tc_pla32 = g_tc_pla[l_ac].tc_pla32,tc_pla33 = g_tc_pla[l_ac].tc_pla33,tc_pla34 = g_tc_pla[l_ac].tc_pla34,tc_pla35 = g_tc_pla[l_ac].tc_pla35
                 where tc_pla01 = g_tc_pla_t.tc_pla01 and tc_pla04 = g_tc_pla_t.tc_pla04
                if sqlca.sqlcode then
                    call cl_err3('upd','tc_pla_file',g_tc_pla_t.tc_pla01,'',sqlca.sqlcode,'','',1)
                    rollback work
                    let g_tc_pla[l_ac].* = g_tc_pla_t.*
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
                    let g_tc_pla[l_ac].* = g_tc_pla_t.*
                else
                    call g_tc_pla.deleteElement(l_ac)
                    if g_rec_b != 0 then
                        let g_action_choice = 'detail'
                        let l_ac = l_ac_t
                    end if
                end if
                close i200_bcl
                rollback work
                exit input
            end if
            let l_ac_t = l_ac
            close i200_bcl
            commit work
        
        on action controlo
            if infield(tc_pla01) and l_ac > 1 then
                let g_tc_pla[l_ac].* = g_tc_pla[l_ac-1].*
                next field tc_pla01
            end if
        
        on action controlp
            case
                when infield(tc_pla01)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_bma10'
                    call cl_create_qry() returning g_tc_pla[l_ac].tc_pla01
                    display g_tc_pla[l_ac].tc_pla01 to tc_pla01
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

    close i200_bcl
    commit work
end function

# 查询条件产生
function i200_b_askkey()
    clear form  #清除栏位值
    call g_tc_pla.clear()

    construct g_wc on 
        tc_pla01,tc_pla02,tc_pla03,tc_pla04,tc_pla05,tc_pla06,tc_pla07,tc_pla08,tc_pla09,tc_pla10,
        tc_pla11,tc_pla12,tc_pla13,tc_pla14,tc_pla15,tc_pla16,tc_pla17,tc_pla18,tc_pla19,tc_pla20,
        tc_pla21,tc_pla22,tc_pla23,tc_pla24,tc_pla25,tc_pla26,tc_pla27,tc_pla28,tc_pla29,tc_pla30,
        tc_pla31,tc_pla32,tc_pla33,tc_pla34,tc_pla35
        from
        s_tc_pla[1].tc_pla01,s_tc_pla[1].tc_pla02,s_tc_pla[1].tc_pla03,s_tc_pla[1].tc_pla04,s_tc_pla[1].tc_pla05,
        s_tc_pla[1].tc_pla06,s_tc_pla[1].tc_pla07,s_tc_pla[1].tc_pla08,s_tc_pla[1].tc_pla09,s_tc_pla[1].tc_pla10,
        s_tc_pla[1].tc_pla11,s_tc_pla[1].tc_pla12,s_tc_pla[1].tc_pla13,s_tc_pla[1].tc_pla14,s_tc_pla[1].tc_pla15,
        s_tc_pla[1].tc_pla16,s_tc_pla[1].tc_pla17,s_tc_pla[1].tc_pla18,s_tc_pla[1].tc_pla19,s_tc_pla[1].tc_pla20,
        s_tc_pla[1].tc_pla21,s_tc_pla[1].tc_pla22,s_tc_pla[1].tc_pla23,s_tc_pla[1].tc_pla24,s_tc_pla[1].tc_pla25,
        s_tc_pla[1].tc_pla26,s_tc_pla[1].tc_pla27,s_tc_pla[1].tc_pla28,s_tc_pla[1].tc_pla29,s_tc_pla[1].tc_pla30,
        s_tc_pla[1].tc_pla31,s_tc_pla[1].tc_pla32,s_tc_pla[1].tc_pla33,s_tc_pla[1].tc_pla34,s_tc_pla[1].tc_pla35

        before construct
            call cl_qbe_init()
        
        on action controlp
            case 
                when infield(tc_pla01)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_bma10'
                    let g_qryparam.state = 'c'
                    call cl_create_qry () returning g_qryparam.multiret
                    display g_qryparam.multiret to s_tc_pla[1].tc_pla01

                when infield(tc_pla03)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_dgen'
                    let g_qryparam.state = 'c'
                    call cl_create_qry () returning g_qryparam.multiret
                    display g_qryparam.multiret to s_tc_pla[1].tc_pla03
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
    call i200_b_fill(g_wc)
end function

# 单身资料生成
function i200_b_fill(p_wc)
    define p_wc         string

    let g_sql = "select tc_pla01,tc_pla02,tc_pla03,gen02,tc_pla04,tc_pla05,tc_pla06,tc_pla07,tc_pla08,tc_pla09, ",
                "       tc_pla10,tc_pla11,tc_pla12,tc_pla13,tc_pla14,tc_pla15,tc_pla16,tc_pla17,tc_pla18, ",
                "       tc_pla19,tc_pla20,tc_pla21,tc_pla22,tc_pla23,tc_pla24,tc_pla25,tc_pla26,tc_pla27, ",
                "       tc_pla28,tc_pla29,tc_pla30,tc_pla31,tc_pla32,tc_pla33,tc_pla34,tc_pla35 ",
                "  from tc_pla_file left join gen_file on gen01 = tc_pla03 ",
                " where ",p_wc clipped," order by tc_pla04,tc_pla01"
    prepare i200_pb from g_sql
    declare tc_pla_curs cursor for i200_pb

    call g_tc_pla.clear()
    let g_cnt = 1
    message 'Seaching!'
    foreach tc_pla_curs into g_tc_pla[g_cnt].*
        if status then
            call cl_err('foreach:',status,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err('',9035,0)
            exit foreach
        end if
    end foreach
    call g_tc_pla.deleteElement(g_cnt)
    message ''
    let g_rec_b = g_cnt - 1
    display g_rec_b to formonly.cn2
    let g_cnt = 0
end function

# 单身显示和action菜单
function i200_bp(p_ud)
    define p_ud     like type_file.chr1

    if p_ud != 'G' OR g_action_choice ='detail' then
        return
    end if

    let g_action_choice = ''

    call cl_set_act_visible('accept,cancel',false)
    display array g_tc_pla to s_tc_pla.* attribute(count=g_rec_b)

        before display

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()

        on action query
            let g_action_choice = 'query'
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
            let int_flag = true
            let g_action_choice = 'exit'
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
        
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
        
        after display
            continue display

    end display

    call cl_set_act_visible('accept,cancel',true)
end function
