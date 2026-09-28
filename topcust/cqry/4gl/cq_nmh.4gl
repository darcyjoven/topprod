# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name   : 转付票据选取开窗
# Program ver.   : 1.0
# Description    : aapt330作业选择转付票据时,是用此开窗
# Date & Author  : darcy:2024/08/22

database ds

GLOBALS "../../../tiptop/config/top.global"

type nmh record
    check       like type_file.chr1,
    nmh01       like nmh_file.nmh01,
    nmh06       like nmh_file.nmh06,
    nmh31       like nmh_file.nmh31,
    nmh04       like nmh_file.nmh04,
    nmh05       like nmh_file.nmh05,
    nmh02       like nmh_file.nmh02,
    npo04       like npo_file.npo04,
    aph05f      like aph_file.aph05f,
    nmh42       like nmh_file.nmh42
end record

define ma_qry,ma_qry_tmp dynamic array of nmh

define mi_multi_sel,mi_need_cons         boolean
define mi_page_count        like type_file.num10
define ms_ret1,ms_ret2,ms_cons_where      string
define g_apf03              like apf_file.apf03
define g_date               like type_file.dat


# 入口函数,返回字符串
# p_type c OR i 是否对选
# p_cons true or false 是否construct
function cq_nmh(p_type,p_cons,p_date,p_apf03)
    define  p_type          like type_file.chr1,
            p_cons          boolean,
            p_date          like type_file.dat,
            p_apf03         like apf_file.apf03
    define  l_win           ui.Window
    
    whenever error call cl_err_msg_log
    initialize ms_ret1 to null

    open window w_qry with form "cqry/42f/cq_nmh" attribute(style="create_qry")

    call cl_ui_locale("cq_nmh")

    let l_win = ui.Window.getCurrent()
    call l_win.setText("转付票据查询")

    let mi_multi_sel = (p_type == "c")     # 是否可以多选
    let mi_need_cons = p_cons      # 是否可以输入条件
    let g_apf03 = p_apf03
    let g_date = p_date

    if not (mi_multi_sel) then
        # 隐藏多选框
        call cl_set_comp_visible("check",false)
    end if

    if (mi_multi_sel) then 
        #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
        call cl_set_comp_font_color("nmh01", "red")
    end if

    call cq_nmh_qry_sel()

    close window w_qry

    return ms_ret1
end function


function cq_nmh_qry_sel()
    define  ls_hide_act         string
    define  li_hide_page        boolean,    # 隐藏上下页按钮
            li_reconstruct      boolean,    # 重新construct
            li_continue         boolean,    # 是否继续
            li_start_index      like type_file.num10,
            li_end_index        like type_file.num10,
            li_curr_page        like type_file.num10,
            li_count            like ze_file.ze03,
            li_page             like ze_file.ze03

    let mi_page_count = 100
    let li_reconstruct = true

    while true
        clear form

        let int_flag = false
        let ls_hide_act = ""

        if li_reconstruct then
            message ""

            if mi_need_cons then
                # 查询条件录入
                construct ms_cons_where 
                       on nmh01,nmh06,nmh31,nmh04,nmh05,nmh02
                     from s_nmh[1].nmh01,s_nmh[1].nmh06,s_nmh[1].nmh31,
                          s_nmh[1].nmh04,s_nmh[1].nmh05,s_nmh[1].nmh02

                    on action controlg
                        call cl_cmdask()
                    on idle g_idle_seconds
                        call cl_on_idle()
                        continue construct
                    on action about
                        call cl_about()
                    on action help
                        call cl_show_help()
                    on action qbe_select
                        call cl_qbe_select()
                    on action qbe_save
                        call cl_qbe_save()
                end construct
                if int_flag then
                    let int_flag = false
                    exit while
                end if
            end if

            call cq_nmh_qry_prep_result_set()

            if mi_page_count == 0 then
                let mi_page_count = ma_qry.getlength()
            end if

            if mi_page_count >= ma_qry.getlength() then
                let ls_hide_act = "prevpage,nextpage"
            end if

            if not mi_need_cons then
                if cl_null(ls_hide_act) then
                    let ls_hide_act = "reconstruct"
                else
                    let ls_hide_act = "prevpage,nextpage,reconstruct"
                end if 
            end if

            let li_start_index = 1
            let li_reconstruct = false
        end if

        let li_end_index = li_start_index + mi_page_count - 1

        if li_end_index > ma_qry.getlength() then
            let li_end_index = ma_qry.getlength()
        end if

        call cq_nmh_qry_set_display_data(li_start_index,li_end_index)

        if li_end_index mod mi_page_count > 0 then
            let li_curr_page = li_curr_page + 1
        end if

        select ze03 into li_count from ze_file where ze01 = 'qry-001' and ze02 = g_lang
        select ze03 into li_page  from ze_file where ze01 = 'qry-002' and ze02 = g_lang
        
        if mi_multi_sel then
            call cq_nmh_qry_input_array(ls_hide_act, li_start_index, li_end_index)
                returning li_continue,li_reconstruct,li_start_index
        else
            call cq_nmh_qry_display_array(ls_hide_act, li_start_index, li_end_index)
                returning li_continue,li_reconstruct,li_start_index
        end if

        if not li_continue then
            exit while
        end if
    end while
end function

# 游标设置
function cq_nmh_qry_prep_result_set()
    define ls_sql,ls_where,l_sql string
    define li_i     like type_file.num10
    define lr_qry   nmh
    define l_sum_aph05f,l_sum_aph05     like aph_file.aph05

    let ls_sql = "select 'N', nmh01,nmh06,nmh31,nmh04,nmh05,nmh02,sum(npo04) npo04,0 aph05f,0 nmh42 ",
                 "  from nmh_file,npn_file,npo_file",
                 " where nmh24 in ('2','4','5') and nmh38 ='Y' ",
                 "   and npo01 = npn01 and npnconf = 'Y' and npn03 = '5' and npn02 <= '",g_date,"'",
                 "   and npn14='",g_apf03,"' and npo03 = nmh01 and nmh42 < nmh32",
                 "   and ",ms_cons_where,
                 " group by nmh01,nmh06,nmh31,nmh04,nmh05,nmh02,nmh42",
                 " order by nmh01 "
    
    declare lcurs_qry cursor from ls_sql

    call ma_qry.clear()
    let li_i = 1
    foreach lcurs_qry into lr_qry.*
        if sqlca.sqlcode then
            call cl_err("ls_sql",sqlca.sqlcode,1)
            exit foreach
        end if
        # 已冲金额
        select sum(aph05f),sum(aph05) into l_sum_aph05f,l_sum_aph05
          from aph_file,apf_file
         where aph03 = 'D' and aph04 = lr_qry.nmh01
            and aph01 = apf01 and apf41 != 'X'
            and apf03 = g_apf03
        if cl_null(l_sum_aph05f) then let l_sum_aph05f = 0 end if
        if cl_null(l_sum_aph05) then let l_sum_aph05 = 0 end if
        # 扣除已冲部分金额
        if l_sum_aph05f >= lr_qry.npo04 then
            continue foreach
        else
            let lr_qry.aph05f = lr_qry.npo04 - l_sum_aph05f
            let lr_qry.nmh42 = l_sum_aph05f
        end if

        if li_i - 1 >= g_aza.aza38 then
            call cl_err_msg(null,"lib-217",g_aza.aza38,10)
            exit foreach
        end if
        let ma_qry[li_i].* = lr_qry.*
        let li_i = li_i + 1
    end foreach
end function

# 显示到画面上
function cq_nmh_qry_set_display_data(pi_start_index,pi_end_index)
    define li_i,li_j,pi_start_index,pi_end_index        like type_file.num10 

    for li_i = ma_qry_tmp.getlength() to 1 step -1
        call ma_qry_tmp.deleteElement(li_i)
    end for

    for li_i = pi_start_index to pi_end_index
        let ma_qry_tmp[li_j + 1].* = ma_qry[li_i].*
        let li_j = li_j + 1
    end for
    call set_count(ma_qry_tmp.getlength())
end function

# 多笔选择
function cq_nmh_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
    define ps_hide_act string
    define pi_start_index, pi_end_index,li_i like type_file.num10
    define li_continue,li_reconstruct boolean

    input array ma_qry_tmp without defaults from s_nmh.*
        attribute(  insert row = false,
                    delete row = false,
                    append row = false,
                    unbuffered
                )
        
        before input
            call cl_set_act_visible("prevpage,nextpage,reconstruct",true)
            if not cl_null(ps_hide_act) then
                call cl_set_act_visible(ps_hide_act,false)
            end if
        
        on action prevpage
            call get_fldbuf(s_nmh.check)
                returning ma_qry_tmp[arr_curr()].check
            call cq_nmh_qry_reset_multi_sel( pi_start_index,pi_end_index )
            
            if pi_start_index - mi_page_count >= 1 then
                let pi_start_index = pi_start_index - mi_page_count
            end if

            let li_continue = true
            exit input
        
        on action nextpage
            call get_fldbuf(s_nmh.check)
                returning ma_qry_tmp[arr_curr()].check
            call cq_nmh_qry_reset_multi_sel( pi_start_index,pi_end_index )

            if pi_start_index + mi_page_count <= ma_qry.getlength() then
                let pi_start_index = pi_start_index + mi_page_count
            end if
            let li_continue = true
            exit input
        
        on action refresh
            call cq_nmh_qry_refresh()
            let pi_start_index = 1
            let li_continue = true
            exit input
        
        on action reconstruct
            let li_reconstruct = true
            let li_continue = true
            exit input
        
        on action accept
            if arr_curr() > 0 then
                call get_fldbuf(s_nmh.check)
                    returning ma_qry_tmp[arr_curr()].check
                call cq_nmh_qry_reset_multi_sel( pi_start_index,pi_end_index )
                call cq_nmh_qry_accept(pi_start_index + arr_curr() -1)
            else
                let ms_ret1 = null
            end if
            let li_continue = false
            exit input
        
        on action cancel
            let int_flag = false
            if not mi_multi_sel then
                let ms_ret1 = ""
            end if
            let li_continue = false
            exit input
        
        on action controls
            call cl_set_head_visible("grid01,grid02","AUTO")

        on action exporttoexcel
            call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        
        on action qry_string
            call cl_qry_string("detail")
        
        on action selectall
            for li_i = 1 to ma_qry_tmp.getlength()
                let ma_qry_tmp[li_i].check = "Y"
            end for
        
        on action select_none
            for li_i = 1 to ma_qry_tmp.getlength()
                let ma_qry_tmp[li_i].check = "N"
            end for
        
        on action qbe_select
            call cl_qbe_select()
        
        on action qbe_save
            call cl_qbe_save()

    end input
    return li_continue,li_reconstruct,pi_start_index
end function

# 单笔选择
function cq_nmh_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
    define ps_hide_act  string
    define pi_start_index,pi_end_index,li_i  like type_file.num10
    define li_continue,li_reconstruct   boolean

    display array ma_qry_tmp to s_nmh.*

        before display
            call cl_set_act_visible("prevpage,nextpage,reconstruct",true)
            if not cl_null(ps_hide_act) then
                call cl_set_act_visible(ps_hide_act,false)
            end if
        
        on action prevpage
            if pi_start_index - mi_page_count >= 1 then
                let pi_start_index = pi_start_index - mi_page_count
            end if
            let li_continue = true
            exit display
        
        on action nextpage
            if pi_start_index + mi_page_count <= ma_qry.getlength() then
                let pi_start_index = pi_start_index + mi_page_count
            end if
            let li_continue = true
            exit display
        
        on action refresh
            let pi_start_index = 1
            let li_continue = true
        
        on action reconstruct
            let li_reconstruct = true
            let li_continue = true
            exit display
        
        on action accept
            call cq_nmh_qry_accept(pi_start_index+arr_curr()-1)
            let li_continue = false
            exit display
        
        on action cancel
            let int_flag = false
            if not mi_multi_sel then
                let ms_ret1 = ""
            end if
            let li_continue = false
            exit display
        
        on action exporttoexcel
            call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        
        on action controls
            call cl_set_head_visible("grid01,grid02","AUTO")

        on action qry_string
            call cl_qry_string("detail")
        
        on action selectall
            for li_i = 1 to ma_qry_tmp.getlength()
                let ma_qry_tmp[li_i].check = "Y"
            end for
        
        on action select_none
            for li_i = 1 to ma_qry_tmp.getlength()
                let ma_qry_tmp[li_i].check = "N"
            end for
        
        on action qbe_select
            call cl_qbe_select()
        
        on action qbe_save
            call cl_qbe_save()
    end display
    call cl_set_act_visible("accept,cancel",true)
    return li_continue,li_reconstruct,pi_start_index
end function

# 
function cq_nmh_qry_reset_multi_sel( pi_start_index,pi_end_index )
    define pi_start_index,pi_end_index,li_i,li_j    like type_file.num10

    for li_i = pi_start_index to pi_end_index
        let ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
        let li_j = li_j + 1
    end for
end function

function cq_nmh_qry_accept(pi_sel_index)
    define pi_sel_index,li_i     like type_file.num10
    define lsb_multi_sel    base.StringBuffer

    if pi_sel_index = 0 then
        return
    end if

    if mi_multi_sel then
        let lsb_multi_sel = base.StringBuffer.create()

        for li_i = 1 to ma_qry.getlength()
            if ma_qry[li_i].check = "Y" then
                call lsb_multi_sel.append(ma_qry[li_i].nmh01 clipped)
            else
                call lsb_multi_sel.append("|" || ma_qry[li_i].nmh01 clipped)
            end if
        end for
        let ms_ret1 = lsb_multi_sel.toString()
    else
        let ms_ret1 = ma_qry[pi_sel_index].nmh01 clipped
    end if
end function

# 刷新
function cq_nmh_qry_refresh()
    define li_i     like type_file.num10

    for li_i = 1 to ma_qry.getlength()
        let ma_qry[li_i].check = "N"
    end for
end function
