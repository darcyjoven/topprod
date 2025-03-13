# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: cbmp600.4gl
# Descriptions...: 设计资料导入导出
# Date & Author..: darcy:2023/11/23
import os
database ds
 
 
globals "../../../tiptop/config/top.global"

type tc_exp record
    check       like type_file.chr1,
    tc_exp02    like tc_exp_file.tc_exp02, -- 料号
    tc_exp03    like tc_exp_file.tc_exp03, -- 版本
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021,
    tc_exp04    like tc_exp_file.tc_exp04, -- 导出时间
    tc_exp05    like tc_exp_file.tc_exp05, -- bom 状态
    tc_exp06    like tc_exp_file.tc_exp06, -- MI 状态
    tc_exp07    like tc_exp_file.tc_exp07, -- 用户
    gen02       like gen_file.gen02,
    tc_exp08    like tc_exp_file.tc_exp08, -- 导入/导出
    tc_exp09    like tc_exp_file.tc_exp09  -- 成功否
end record

define tm record
    wc string,
    ecu02 like ecu_file.ecu02
end record

define g_cnt integer

define g_tc_exp dynamic array of tc_exp

function main()
    define p_row,p_col   like type_file.num5
    options
        input no wrap,
        field order form
    defer interrupt
    database ds

    if (not cl_user()) then
        exit program
    end if

    whenever error call cl_err_msg_log
    if (not cl_setup("CBM")) then
        exit program
    end if
    call cl_used(g_prog,g_time,1) returning g_time

    let tm.wc = arg_val(1) 

    open window p600_w with form "cbm/42f/cbmp600"
      attribute (style = g_win_style clipped) 
    call cl_ui_init()

    call p600_menu()

    close window p600_w
    call cl_used(g_prog,g_time,2) returning g_time
end function

# 输入查询条件
function p600_cs()

    clear form

    dialog attribute(unbuffered)
        input by name tm.ecu02
        end input

        construct tm.wc on ecu01 from ecu01
            before construct
                call cl_qbe_init()
        end construct

        after dialog

        on action controlp
            case
                when infield(ecu01)
                    call cl_init_qry_var()
                    let g_qryparam.form = "q_bma10"
                    let g_qryparam.state = "c"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to ecu01
                    next field ecu01
                when infield(ecu02)
            end case

        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
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
        on action accept
            let int_flag = 0
            accept dialog
            
        on action cancel
            let int_flag = 1
            exit dialog 

        on action exit
            let int_flag = 1
            exit dialog
                
        on action close
            let int_flag = 1
            exit dialog 
    end dialog
    if int_flag then
        let int_flag = false
        call cl_used(g_prog,g_time,2) returning g_time
        exit program
    end if
    call p600_b_fill()
end function

# 菜单
function p600_menu()

    while true
        call p600_bp("G")
        case g_action_choice
            when "query"
                if cl_chk_act_auth() then
                    call p600_q()
                else
                    let g_action_choice = " "
                end if
            when "help"
                call cl_show_help()
                let g_action_choice = " "
            when "exit"
                exit while
            when "controlg"
                call cl_cmdask()
                let g_action_choice = " "
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    call p600_export()
                end if
            when 'import'
                if cl_chk_act_auth() then
                    call p600_import()
                end if
        end case
    end while
end function
# 显示以及action按钮
function p600_bp(p_ud)
    define   p_ud   like type_file.chr1
    define i integer

    if p_ud <> "G" then
        return
    end if
 
    input array g_tc_exp without defaults from s_tc_exp.*
        attribute(count=g_cnt,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        on change check

        on action query
            let g_action_choice = "query"
            exit input
        
        on action checkall
            for i = 1 to g_tc_exp.getLength()
                let g_tc_exp[i].check = 'Y'
            end for
        
        on action unselect
            for i = 1 to g_tc_exp.getLength()
                let g_tc_exp[i].check = iif(g_tc_exp[i].check = 'Y','N','Y')
            end for

        on action help
            let g_action_choice = "help"
            exit input
        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()
            exit input
        on action exit
            let g_action_choice = "exit"
            exit input
        on action cancel
            let int_flag = false
            let g_action_choice = "exit"
            exit input
        on action controlg
            let g_action_choice = "controlg"
            exit input

        ON IDLE g_idle_seconds
            call cl_on_idle()
            continue input

        on action about
            call cl_about()
        on action exporttoexcel
            let g_action_choice = "exporttoexcel"
            exit input
        on action controls
            call cl_set_head_visible("","AUTO")
        
        on action import 
            let g_action_choice = "import"
            exit input

    end input
    call cl_set_act_visible("accept,cancel",true)
end function
function p600_q()
    message ""
    call p600_cs()
end function

# 显示
function p600_b_fill()
    define l_sql,l_cnt_sql string
    define l_cnt integer
    
    let l_sql = "select ecu01 from ecu_file where ecu01 not like '%-%' and ",tm.wc
    let l_cnt_sql = "select count(*) from (",l_sql,")"
    
    let l_cnt = 0
    prepare ecu_cnt_p from l_cnt_sql
    execute ecu_cnt_p into l_cnt
    if l_cnt = 0 then
        let tm.wc = cl_replace_str(tm.wc,"ecu02","bma01")
        let l_sql = "select bma01 ecu01 from bma_file where bma01 not like '%-%' and ",tm.wc
        let l_cnt_sql = "select count(*) from (",l_sql,")"
        prepare bma_cnt_p from l_cnt_sql
        execute bma_cnt_p into l_cnt
        if l_cnt = 0 then
            return
        end if
    end if

    let l_sql = "select 'Y',bma01,ecu02,ima02,ima021,null, ",
                "  case bma10 when '0' then '开立' when '1' then '审核' when '2' then '发出' end bom, ",
                "  case when ecuud02='Y' and ecu10 ='Y' then '发出' when ecuud02='Y' and ecu10 ='N' then '审核' else '开立'  end mi, ",
                "  '",g_user,"',gen02,0,'' ",
                "  from (",l_sql,")  a ",
                "  left join bma_file on bma01=a.ecu01  ",
                "  left join ecu_file b on a.ecu01 = b.ecu01 ",
                "  left join gen_file on gen01 = '",g_user,"' ",
                "  left join ima_file on ima01=a.ecu01"
    prepare p600_b_p from l_sql
    declare p600_b_cur cursor for p600_b_p

    call g_tc_exp.clear()
    let g_cnt = 1
    foreach p600_b_cur into g_tc_exp[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > 1000 then
            call cl_err("笔数不得多余1000笔，超过笔数不予显示","!",1)
            exit foreach
        end if
    end foreach
    call g_tc_exp.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1

end function
function p600_export()
    define i integer

    for i = 1 to g_tc_exp.getLength()
        if g_tc_exp[i].check == 'Y' then
            call s_cbmp600_export(g_tc_exp[i].tc_exp02,g_tc_exp[i].tc_exp03)
                returning g_tc_exp[i].tc_exp09
        end if
    end for
end function

{ 
    导入文件
 }
function p600_import()
    define ls_location,l_remotepath string
    define l_uuid   varchar(40)

    # 1. 上传文件
    let ls_location = ""
    while true
        prompt "请录入需要导入的文件：" clipped for ls_location
            attribute(without defaults)

            on action accept
                exit while

            on action cancel
                let ls_location = ""
                exit while

            on action browse_document
                let ls_location = cl_browse_file() 

            on idle g_idle_seconds
                call cl_on_idle()
                let ls_location = ""
        end prompt
    end while

    # 2. 将文件上传道服务端
    let l_remotepath = "/u1/out/",os.Path.basename(ls_location)
    let ls_location = cl_replace_str(ls_location,"/","\\")
    if not cl_upload_file(ls_location,l_remotepath) then 
        return 
    end if

    # 3. 导入资料
    let l_uuid = s_cbmp600_import(l_remotepath)
end function
