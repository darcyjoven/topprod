# prog. version..: '5.30.06-13.03.28(00010)'     #
#
# pattern name...: cimi114.4gl
# descriptions...: 需求批量查询作业
# date & author..: darcy:2025/04/24
 
database ds
 
globals "../../../tiptop/config/top.global"

type m_tc_cma record
    ima01    LIKE ima_file.ima01, 
    ima02    LIKE ima_file.ima02, 
    ima021   LIKE ima_file.ima02, 
    ima25    LIKE ima_file.ima25, 
    ima05    LIKE ima_file.ima05, 
    ima06    LIKE ima_file.ima06, 
    ima08    LIKE ima_file.ima08, 
    ima37    LIKE ima_file.ima37, 
    ima70    LIKE ima_file.ima70, 
    ima15    LIKE ima_file.ima15, 
    ima906   LIKE ima_file.ima906,
    ima907   LIKE ima_file.ima907,
    ima44     LIKE ima_file.ima44,
    ima44_fac LIKE ima_file.ima44_fac,
    ima45     LIKE ima_file.ima45,
    ima46     LIKE ima_file.ima46,
    ima881    LIKE ima_file.ima881,
    unavl_stk  LIKE type_file.num15_3,
    avl_stk    LIKE type_file.num15_3,
    oeb_q      LIKE type_file.num15_3,
    sfa_q1     LIKE type_file.num15_3,
    sfa_q2     LIKE type_file.num15_3,
    sie_q      LIKE type_file.num15_3,
    pml_q      LIKE type_file.num15_3,
    pmn_q      LIKE type_file.num15_3,
    rvb_q2     LIKE type_file.num15_3,
    rvb_q      LIKE type_file.num15_3,
    sfb_q1     LIKE type_file.num15_3,
    sfb_q2     LIKE type_file.num15_3,
    qcf_q      LIKE type_file.num15_3,
    atp_qty    LIKE type_file.num15_3,
    img_q      LIKE type_file.num15_3,
    sfe_c      LIKE type_file.num15_3,
    sfa_xiaban LIKE type_file.num15_3,
    sfa_liuzhi LIKE type_file.num15_3,
    ima27      like ima_file.ima27,
    rpc13      like rpc_file.rpc13,
    rpc13_1      like rpc_file.rpc13
end record
type m_ima record
    ima01    LIKE ima_file.ima01, 
    ima02    LIKE ima_file.ima02, 
    ima021   LIKE ima_file.ima02, 
    ima25    LIKE ima_file.ima25, 
    ima05    LIKE ima_file.ima05, 
    ima06    LIKE ima_file.ima06, 
    ima08    LIKE ima_file.ima08, 
    ima37    LIKE ima_file.ima37, 
    ima70    LIKE ima_file.ima70, 
    ima15    LIKE ima_file.ima15, 
    ima906   LIKE ima_file.ima906,
    ima907   LIKE ima_file.ima907,
    ima44     LIKE ima_file.ima44,
    ima44_fac LIKE ima_file.ima44_fac,
    ima45     LIKE ima_file.ima45,
    ima46     LIKE ima_file.ima46,
    ima881    LIKE ima_file.ima881,
    unavl_stk  LIKE type_file.num15_3,
    avl_stk    LIKE type_file.num15_3,
    oeb_q      LIKE type_file.num15_3,
    sfa_q1     LIKE type_file.num15_3,
    sfa_q2     LIKE type_file.num15_3,
    sie_q      LIKE type_file.num15_3,
    pml_q      LIKE type_file.num15_3,
    pmn_q      LIKE type_file.num15_3,
    rvb_q2     LIKE type_file.num15_3,
    rvb_q      LIKE type_file.num15_3,
    sfb_q1     LIKE type_file.num15_3,
    sfb_q2     LIKE type_file.num15_3,
    qcf_q      LIKE type_file.num15_3,
    atp_qty    LIKE type_file.num15_3,
    img_q      LIKE type_file.num15_3,
    sfe_c      LIKE type_file.num15_3,
    sfa_xiaban LIKE type_file.num15_3,
    sfa_liuzhi LIKE type_file.num15_3,
    ima27      like ima_file.ima27,
    rpc13      like rpc_file.rpc13
end record

define g_aimq102 dynamic array of m_tc_cma
define g_aimq102_excel dynamic array of m_tc_cma

define p_row,p_col    like type_file.num5
define g_wc           string
define g_cnt integer

MAIN

    options                                #改變一些系統預設值
        input no wrap
    defer interrupt                        #擷取中斷鍵, 由程式處理
 
    if (not cl_user()) then
        exit program
    end if
    
    whenever error call cl_err_msg_log
    
    if (not cl_setup("CIM")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time
    LET p_row = 3 LET p_col = 2
 
    open window q114_w at p_row,p_col with form "cim/42f/cimq114"
          attribute (style = g_win_style clipped)
    call cl_ui_init()
    call q114_crt_temp()
    call q114_menu()
    close window q114_w
    call cl_used(g_prog,g_time,2) returning g_time

END MAIN

function q114_menu()
    while true
        call q114_bp("G")
        case g_action_choice
        when "query"
            if cl_chk_act_auth() then
               call q114_q()
            end if
        when "help"
            call cl_show_help()
        when "exit"
            exit while
        when "controlg"
            call cl_cmdask()
        when "exporttoexcel" #fun-4b0002
            if cl_chk_act_auth() then
                call cl_download_by_explorer(cl_expexcel1("s_ima",base.typeinfo.create(g_aimq102_excel))) 
            end if
      end case
   end while
end function

function q114_q()
    call q114_b_askkey() 
    if int_flag then let int_flag = 0 return end if
    call q114_b_fill()
end function


function q114_b_askkey()
    construct g_wc on ima01,ima06,ima08 from s_ima[1].ima01,s_ima[1].ima06,s_ima[1].ima08

        on action about     
            call cl_about() 
 
        on action help        
            call cl_show_help()
 
        on action controlg
            call cl_cmdask()
            
        on idle g_idle_seconds
            call cl_on_idle()
            continue construct

        on action controlp 
            case 
                when infield(ima01)
                    call cl_init_qry_var()
                    let g_qryparam.form = "q_ima"
                    let g_qryparam.state = 'c'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to ima01
                    next field ima01
                when infield(ima06)
                    call cl_init_qry_var()
                    let g_qryparam.form = "q_ima06"
                    let g_qryparam.state = 'c'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to ima06
                    next field ima06 
            end case
        on action qbe_save
		    call cl_qbe_save()
    end construct
end function

function q114_b_fill()
    define l_sql    string
    define l_ima01  like ima_file.ima01
    define l_aimq102 m_ima
    define l_ok     varchar(20)
    define l_rpc13  like rpc_file.rpc13

    let l_sql = "select ima01 from ima_file where ",g_wc clipped," order by ima01 "
    if g_user = 'tiptop' and not cl_null(l_ok) then
        let l_sql = "select unique ima01 from ima_file,mss_file",
                    " where ima01 = mss01 and mss08 <> 0 and mss_v = '",l_ok,"'",
                    " order by ima01 "
    end if
    prepare q114_ima_p from l_sql
    declare q114_ima_cur cursor for q114_ima_p

    delete from q114_aimq102

    foreach q114_ima_cur into l_ima01
        if sqlca.sqlcode then
            call cl_err('q114_ima_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        call q102_get_g_ima(l_ima01) returning l_aimq102.*
        call ui.Interface.refresh()
        select sum(rpc13-nvl(rpc131,0)) into l_rpc13 from rpc_file 
         where rpc01 =l_ima01   and rpc18='Y' and rpc19='N' 
           and ta_rpc06 = '2'
        if cl_null(l_rpc13) then let l_rpc13 = 0 end if
        let l_aimq102.rpc13 = l_aimq102.rpc13 - l_rpc13 

        insert into q114_aimq102 values (l_aimq102.*,l_rpc13)
    end foreach
    MESSAGE "Search Completed" 

    let l_sql = "select * from q114_aimq102 order by ima01"
    let g_cnt = 1
    prepare q114_b_p from l_sql
    declare q114_b_cur cursor for q114_b_p

    foreach q114_b_cur into g_aimq102_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('q114_b_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt = 10001 then
            call cl_err_msg(NULL,"axc-131",g_cnt||"|"||10000,10)
        end if
        if g_cnt <=10000 then
            let g_aimq102[g_cnt].* = g_aimq102_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_aimq102_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1

end function

function q114_bp(p_ud)
    define   p_ud   LIKE type_file.chr1

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "
    
    display g_cnt to cnt

    call cl_set_act_visible("accept,cancel", FALSE)
    display array g_aimq102 to s_ima.* attribute(count=g_cnt,unbuffered)
 
        before display
            call cl_show_fld_cont()
        
        before row
            display ARR_CURR() to curr

        on action query
            let g_action_choice="query"
            exit display

        on action help
            let g_action_choice="help"
            exit display
 
        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()
 
        on action exit
            let g_action_choice="exit"
            exit display

        on action controlg
            let g_action_choice="controlg"
            exit display
 
        on action accept
            exit display
 
        on action cancel
            let int_flag=false
            let g_action_choice="exit"
            exit display
 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
 
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
 
        on action about
            call cl_about()

        after display
            continue display

        on ACTION controls                                                                                                             
            call cl_set_head_visible("","AUTO")     
 
    end display
    call cl_set_act_visible("accept,cancel", true)
end function

function q114_crt_temp()
    drop table q114_aimq102
    create temp table q114_aimq102(
        ima01    varchar(40), 
        ima02    varchar(120), 
        ima021   varchar(120), 
        ima25    varchar(4), 
        ima05    varchar(10), 
        ima06    varchar(10), 
        ima08    varchar(1), 
        ima37    varchar(1), 
        ima70    varchar(1), 
        ima15    varchar(1),  
        ima906   varchar(1),  
        ima907   varchar(4),  
        ima44    varchar(4),  
        ima44_fac decimal(20,8),
        ima45     decimal(15,3),
        ima46     decimal(15,3),
        ima881    date,
        unavl_stk  decimal(15,3),
        avl_stk    decimal(15,3),
        oeb_q      decimal(15,3),
        sfa_q1     decimal(15,3),
        sfa_q2     decimal(15,3),
        sie_q      decimal(15,3),
        pml_q      decimal(15,3),
        pmn_q      decimal(15,3),
        rvb_q2     decimal(15,3),
        rvb_q      decimal(15,3),
        sfb_q1     decimal(15,3),
        sfb_q2     decimal(15,3),
        qcf_q      decimal(15,3),
        atp_qty    decimal(15,3),
        img_q      decimal(15,3),
        sfe_c      decimal(15,3),
        sfa_xiaban decimal(15,3),
        sfa_liuzhi decimal(15,3),
        ima27      decimal(15,3),
        rpc13      decimal(15,3),
        rpc13_1    decimal(15,3)
    )
end function
