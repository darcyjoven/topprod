# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cgoi120.4gl
# Descriptions...: CGo程序函数资料
# Date & Author..: darcy:2024/04/17

database ds
globals "../../../tiptop/config/top.global"

type cgc record
    cgc01   like cgc_file.cgc01,
    cgc02   like cgc_file.cgc02,
    cgc03   like cgc_file.cgc03,
    cgc04   like cgc_file.cgc04,
    cgc05   like cgc_file.cgc05,
    cgc06   like cgc_file.cgc06,
    cgc07   like cgc_file.cgc07,
    cgc08   like cgc_file.cgc08,
    cgc09   like cgc_file.cgc09,
    cgc10   like cgc_file.cgc10,
    cgc11   like cgc_file.cgc11,
    cgc12   like cgc_file.cgc12,
    cgc13   like cgc_file.cgc13,
    cgc14   like cgc_file.cgc14,
    cgc15   like cgc_file.cgc15,
    cgc16   like cgc_file.cgc16,
    cgc17   like cgc_file.cgc17,
    cgc18   like cgc_file.cgc18,
    cgc19   like cgc_file.cgc19,
    cgc20   like cgc_file.cgc20
end record

define g_cgc dynamic array of cgc
define g_cgc_t cgc
define g_cgc01  like cgc_file.cgc01,
       g_cgc02  like cgc_file.cgc02
define g_sql,g_wc,g_cmd,g_forupd_sql string
define g_rec_b,l_ac,g_row_count,g_curs_index,g_cnt,l_ac_t integer
define g_before_input_done boolean
define g_argv1 varchar(1000)

MAIN
    define p_row,p_col like type_file.num5

    options 
        input no wrap
    defer interrupt

    if not cl_user() THEN
        exit program
    end if

    whenever error call cl_err_msg_log
  
    if (not cl_setup("CGO")) then
        exit program
    end if
 
    call cl_used(g_prog,g_time,1)
        returning g_time
 
    let p_row = 4 let p_col = 3
    open window cgoi120_w at p_row,p_col with form "cgo/42f/cgoi120"
        attribute (style = g_win_style clipped)
    call cl_ui_init()
    
    let g_wc = arg_val(1)
    if not cl_null(g_wc) then
        call cgoi120_b_fill(g_wc)
    end if
    call cgoi120_menu()

    close window cgoi120_w
    call cl_used(g_prog,g_time,2) returning g_time
END MAIN

function cgoi120_menu()
    while true
        call cgoi120_bp("G")
        case g_action_choice
            when "query"
                if cl_chk_act_auth() then
                    call cgoi120_q()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call cgoi120_b()
                end if
            when "help"
                call cl_show_help()
            when "exit"
                exit while
            when "controlg"
                call cl_cmdask()
            when "exporttoexcel"   #No.FUN-4B0020
                if cl_chk_act_auth() then
                call cl_expexcel_display(
                    "s_cgc",base.typeinfo.create(g_cgc),
                    "","","",""
                )
                end if
        end case
    end while
end function

function cgoi120_q()
    call cgoi120_b_askkey()
end function
function cgoi120_b()
    define l_allow_delete,l_allow_insert like type_file.chr1
    define p_cmd,l_lock_sw  like type_file.chr1
    define l_n,l_cnt integer
    define l_arg1 varchar(2000)
    
    if s_shut(0) then return end if
    let g_action_choice = ""

    let l_allow_insert = cl_detail_input_auth('insert')
    let l_allow_delete = cl_detail_input_auth('delete')

    let g_forupd_sql = "select cgc01,cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10,",
                       "       cgc11,cgc12,cgc13,cgc14,cgc15,cgc16,cgc17,cgc18,cgc19,cgc20",
                       "  from cgc_file where cgc01 = ? and cgc02 = ? and cgc03 = ? for update"
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare cgoi120_bcl cursor from g_forupd_sql

    input array g_cgc without defaults from s_cgc.*
        attribute (count=g_rec_b,maxcount=g_max_rec,unbuffered,
                   insert row = l_allow_delete,delete row =l_allow_delete)
        before input
            if g_rec_b != 0 then
                call fgl_set_arr_curr(l_ac)
            end if

        before row
            let p_cmd = ''
            let l_ac = arr_curr()
            let l_lock_sw = 'N'
            let l_n = arr_count()

            if g_rec_b >= l_ac then
                begin work
                let p_cmd = 'u'
                let g_before_input_done = false
                call cgoi120_set_entry(p_cmd)
                call cgoi120_set_no_entry(p_cmd)
                let g_cgc_t.* = g_cgc[l_ac].*
                open cgoi120_bcl  using g_cgc_t.cgc01,g_cgc_t.cgc02,g_cgc_t.cgc03
                if status then
                    call cl_err("open cgoi120_bcl",status,1)
                    let l_lock_sw = 'Y'
                else
                    fetch cgoi120_bcl into g_cgc[l_ac].*
                    if sqlca.sqlcode then
                        call cl_err(g_cgc_t.cgc01||g_cgc_t.cgc02||g_cgc_t.cgc03,sqlca.sqlcode,1)
                        let l_lock_sw = 'Y'
                    end if
                end if
                call cl_show_fld_cont()
            end if
        
        before insert
            let l_n = arr_count()
            let p_cmd = 'a'
            let g_before_input_done = false
            call cgoi120_set_entry(p_cmd)
            call cgoi120_set_no_entry(p_cmd)
            let g_before_input_done = true

            initialize g_cgc[l_ac].* to NULL
            let g_cgc[l_ac].cgc06 = 1
            
            let g_cgc_t.* = g_cgc[l_ac].*
            call cl_show_fld_cont()
            next field cgc01
        
        after insert
            display "AFTER INSERT"
            if int_flag then
                call cl_err("",9001,0)
                let int_flag = 0
                close cgoi120_bcl
                cancel insert
            end if
            begin work
            insert into cgc_file (
                cgc01,cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10,
                cgc11,cgc12,cgc13,cgc14,cgc15,cgc16,cgc17,cgc18,cgc19,cgc20
            ) values(
                g_cgc[l_ac].cgc01,g_cgc[l_ac].cgc02,g_cgc[l_ac].cgc03,g_cgc[l_ac].cgc04,g_cgc[l_ac].cgc05,g_cgc[l_ac].cgc06,g_cgc[l_ac].cgc07,g_cgc[l_ac].cgc08,g_cgc[l_ac].cgc09,g_cgc[l_ac].cgc10,
                g_cgc[l_ac].cgc11,g_cgc[l_ac].cgc12,g_cgc[l_ac].cgc13,g_cgc[l_ac].cgc14,g_cgc[l_ac].cgc15,g_cgc[l_ac].cgc16,g_cgc[l_ac].cgc17,g_cgc[l_ac].cgc18,g_cgc[l_ac].cgc19,g_cgc[l_ac].cgc20
            )
            if sqlca.sqlcode then
                call cl_err3("ins","cgc_file",g_cgc[l_ac].cgc01,"",sqlca.sqlcode,"","",1)
                rollback work
                cancel insert
            else
                commit work
            end if
        
        on action controlp
            let l_arg1 = " 1=1"
            case 
                when infield(cgc01)
                    call cl_init_qry_var()
                    let g_qryparam.form = "cq_cgb01"
                    let g_qryparam.arg1 = l_arg1
                    let g_qryparam.default1 = g_cgc[l_ac].cgc01
                    let g_qryparam.default2 = g_cgc[l_ac].cgc02
                    call cl_create_qry() returning g_cgc[l_ac].cgc01,g_cgc[l_ac].cgc02
                    display g_cgc[l_ac].cgc01,g_cgc[l_ac].cgc02 to cgc01,cgc02

                when infield(cgc02)
                    if not cl_null(g_cgc[l_ac].cgc01) then
                        let l_arg1 = l_arg1 , " and cgc01='",g_cgc[l_ac].cgc01,"'"
                    end if
                    call cl_init_qry_var()
                    let g_qryparam.form = "cq_cgb01"
                    let g_qryparam.arg1 = l_arg1
                    let g_qryparam.default1 = g_cgc[l_ac].cgc01
                    let g_qryparam.default2 = g_cgc[l_ac].cgc02
                    call cl_create_qry() returning g_cgc[l_ac].cgc01,g_cgc[l_ac].cgc02
                    display g_cgc[l_ac].cgc01,g_cgc[l_ac].cgc02 to cgc01,cgc02

            end case
        
        after field cgc01
            if not cl_null(g_cgc[l_ac].cgc01) then
                let l_cnt = 0
                select count(*) into l_cnt from cgb_file
                 where cgb01 = g_cgc[l_ac].cgc01
                if l_cnt = 0 then
                    call cl_err("请在cgli100先维护该程序","!",1)
                    next field cgc01
                end if
                if not cl_null(g_cgc[l_ac].cgc02) then
                    let l_cnt = 0
                    select count(*) into l_cnt from cgb_file
                     where cgb01 = g_cgc[l_ac].cgc01
                       and cgb02 = g_cgc[l_ac].cgc02
                    if l_cnt = 0 then
                        message "无此版本资料"
                    end if
                end if
            end if

        on change cgc01 

        after field cgc02
            if not cl_null(g_cgc[l_ac].cgc02) then
                if cl_null(g_cgc[l_ac].cgc01) then
                    call cl_err("请先维护CGo程序名称","!",1)
                    next field cgc01
                end if
                let l_cnt = 0
                select count(*) into l_cnt from cgb_file
                    where cgb01 = g_cgc[l_ac].cgc01
                    and cgb02 = g_cgc[l_ac].cgc02
                if l_cnt = 0 then
                    call cl_err("无此版本资料","!",1)
                    next field cgc02
                end if
            end if

        on change cgc02

        before field cgc03
            if cl_null(g_cgc[l_ac].cgc01) then
                next field cgc01
            end if
            if cl_null(g_cgc[l_ac].cgc02) then
                next field cgc02
            end if

            let l_cnt = 0 
            select max(cgc03) + 1  into l_cnt from cgc_file
             where cgc01 = g_cgc[l_ac].cgc01 and cgc02 = g_cgc[l_ac].cgc02
            if cl_null(l_cnt) then
                let l_cnt = 1
            end if

            let g_cgc[l_ac].cgc03 = l_cnt
            display g_cgc[l_ac].cgc03 to cgc0

        after field cgc03
            if not cl_null(g_cgc[l_ac].cgc01) and not cl_null(g_cgc[l_ac].cgc02) and not cl_null(g_cgc[l_ac].cgc03) then
                let l_cnt = 0
                select count(*) into l_cnt from cgc_file
                 where cgc01 = g_cgc[l_ac].cgc01 and cgc02 = g_cgc[l_ac].cgc02
                   and cgc03 = g_cgc[l_ac].cgc03
                if l_cnt > 0 then
                    call cl_err("该项次已存在资料，请重新维护项次","!",1)
                    next field cgc03
                end if
            end if

        after field cgc04
            

        before delete
            if not (cl_null(g_cgc_t.cgc01) or cl_null(g_cgc_t.cgc02) or cl_null(g_cgc_t.cgc03)) then
                if not cl_delete() then
                    rollback work
                    cancel delete
                end if
                delete from cgc_file
                 where cgc01 = g_cgc_t.cgc01
                   and cgc02 = g_cgc_t.cgc02
                   and cgc03 = g_cgc_t.cgc03
                if sqlca.sqlcode then
                    call cl_err3("del","cgc_file",g_cgc_t.cgc01||g_cgc_t.cgc02||g_cgc_t.cgc03,"",sqlca.sqlcode,"","",1)
                    rollback work
                    cancel delete
                    exit input
                end if
            end if
        
        on row change
            if int_flag then
                call cl_err("",9001,0)
                let int_flag = false
                let g_cgc[l_ac].* = g_cgc_t.*
                close cgoi120_bcl
                rollback work
                exit input
            end if
            if l_lock_sw = 'Y' then
                call cl_err(g_cgc_t.cgc01||g_cgc_t.cgc02||g_cgc_t.cgc03,-263,0)
                let g_cgc[l_ac].* = g_cgc_t.*
            else
                update cgc_file 
                   set cgc01=g_cgc[l_ac].cgc01,cgc02=g_cgc[l_ac].cgc02,
                       cgc03=g_cgc[l_ac].cgc03,cgc04=g_cgc[l_ac].cgc04,
                       cgc05=g_cgc[l_ac].cgc05,cgc06=g_cgc[l_ac].cgc06,
                       cgc07=g_cgc[l_ac].cgc07,cgc08=g_cgc[l_ac].cgc08,
                       cgc09=g_cgc[l_ac].cgc09,cgc10=g_cgc[l_ac].cgc10,
                       cgc11=g_cgc[l_ac].cgc11,cgc12=g_cgc[l_ac].cgc12,
                       cgc13=g_cgc[l_ac].cgc13,cgc14=g_cgc[l_ac].cgc14,
                       cgc15=g_cgc[l_ac].cgc15,cgc16=g_cgc[l_ac].cgc16,
                       cgc17=g_cgc[l_ac].cgc17,cgc18=g_cgc[l_ac].cgc18,
                       cgc19=g_cgc[l_ac].cgc19,cgc20=g_cgc[l_ac].cgc20
                 where cgc01 = g_cgc_t.cgc01
                   and cgc02 = g_cgc_t.cgc02
                   and cgc03 = g_cgc_t.cgc03
                if sqlca.sqlcode then
                    call cl_err3("upd","cgc_file",g_cgc_t.cgc01||g_cgc_t.cgc02||g_cgc_t.cgc03,"",sqlca.sqlcode,"","",1)
                    rollback work
                    let g_cgc[l_ac].* = g_cgc_t.*
                end if
            end if
        
        after row
            let l_ac = arr_curr()
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                if p_cmd = 'u' then
                    let g_cgc[l_ac].* = g_cgc_t.*
                else
                    call g_cgc.deleteElement(l_ac)
                    if g_rec_b != 0 then
                        let g_action_choice = "detail"
                        let l_ac = l_ac_t
                    end if
                end if
                close cgoi120_bcl
                rollback work
                exit input
            end if
            let l_ac_t = l_ac
            close cgoi120_bcl
            commit work
        
        on action controlo
            message "不可使用复制功能"

        on action controlr
            call cl_show_req_fields()
        
        on action controlg
            call cl_cmdask()
        
        on action controlf
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        
        on action about
            call cl_about()
        
        on action help
            call cl_show_help()

    end input
    close cgoi120_bcl
    commit work
end function
function cgoi120_b_askkey()
    clear form
    call g_cgc.clear()

    construct g_wc on cgc01,cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10,
                      cgc11,cgc12,cgc13,cgc14,cgc15,cgc16,cgc17,cgc18,cgc19,cgc20
         from s_cgc[1].cgc01,s_cgc[1].cgc02,s_cgc[1].cgc03,s_cgc[1].cgc04,s_cgc[1].cgc05,s_cgc[1].cgc06,s_cgc[1].cgc07,s_cgc[1].cgc08,s_cgc[1].cgc09,s_cgc[1].cgc10,
              s_cgc[1].cgc11,s_cgc[1].cgc12,s_cgc[1].cgc13,s_cgc[1].cgc14,s_cgc[1].cgc15,s_cgc[1].cgc16,s_cgc[1].cgc17,s_cgc[1].cgc18,s_cgc[1].cgc19,s_cgc[1].cgc20
        
        before construct
            call cl_qbe_init()
        
        on action controlp
            case 
                when infield(cgc01)
                when infield(cgc02)
            end case
        
        on idle g_idle_seconds
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
        let int_flag = false
        let g_wc = null
        return
    end if

    call cgoi120_b_fill(g_wc)
end function
function cgoi120_bp(p_ud)
    define p_ud     like type_file.chr1

    if p_ud <> 'G' or g_action_choice = 'detail' then
        return
    end if

    let g_action_choice = ' '
    let g_row_count = 0
    let g_curs_index = 0

    call cl_set_act_visible("accept,cancel",false)
    display array g_cgc to s_cgc.* attribute(count=g_rec_b)

        before display
            call cl_navigator_setting(g_curs_index,g_row_count)

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()
        
        on action query
            let g_action_choice = "query"
            exit display
        
        on action detail
            let g_action_choice = "detail"
            let l_ac = 1
            exit display
        
        on action help
            let g_action_choice = "help"
            exit display
        
        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()
        
        on action exit
            let g_action_choice ="exit"
            exit display

        on action accept
            let g_action_choice = "detail"
            let l_ac = arr_curr()
            exit display
        
        on action cancel
            let int_flag = false
            let g_action_choice = "exit"
            exit display
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
        
        on action about
            call cl_about()
        
        on action exporttoexcel
            let g_action_choice = "exporttoexcel"
            exit display
        
        after display
            continue display
    end display
    call cl_set_act_visible("accept,cancel",true)

end function

function cgoi120_b_fill(p_wc)
    define p_wc string

    let g_sql = "select cgc01,cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10, ",
                "       cgc11,cgc12,cgc13,cgc14,cgc15,cgc16,cgc17,cgc18,cgc19,cgc20  ",
                "  from cgc_file where 1=1 and ",g_wc," order by cgc01,cgc02,cgc03 "
    prepare cgoi120_pb from g_sql
    declare cgc_curs cursor for cgoi120_pb

    call g_cgc.clear()
    let g_cnt = 1
    message "Searching!"
    foreach cgc_curs into g_cgc[g_cnt].*
        if status then
            call cl_err('cgc_curs',status,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err('',9035,0)
            exit foreach
        end if
    end foreach
    call g_cgc.deleteElement(g_cnt)
    message ""
    let g_rec_b = g_cnt - 1
    display g_rec_b to cnt
    let g_cnt = 0

end function

function cgoi120_set_entry(p_cmd)
    define p_cmd like type_file.chr1
end function
function cgoi120_set_no_entry(p_cmd)
    define p_cmd like type_file.chr1
end function
