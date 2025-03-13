# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: csfp510.4gl
# Descriptions...: ?????????
# Date & Author..: darcy:2024/11/28

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

type tc_sfe record
    chk         varchar(1),
    tc_sfd01    like tc_sfd_file.tc_sfd01,
    tc_sfd07    like tc_sfd_file.tc_sfd07,
    tc_sfe02    like tc_sfe_file.tc_sfe02,
    shm01       like shm_file.shm01,
    sfb05       like sfb_file.sfb05,
    ima02       like ima_file.ima02,
    tc_sfe03    like tc_sfe_file.tc_sfe03,
    tc_sfeud02  like tc_sfe_file.tc_sfeud02
end record

define g_wc,g_sql     string
define g_tc_sfe     dynamic array of tc_sfe
define p_row,p_col,g_cnt,g_rec_b  integer


MAIN
    OPTIONS
    INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
    END IF
 
 
    CALL cl_used(g_prog,g_time,1)       #?????? (????) 
        RETURNING g_time              
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW csfp510_w AT p_row,p_col              #????
        WITH FORM "csf/42f/csfp510"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
    call csfp510_q()
    CALL csfp510_menu()
 
    CLOSE WINDOW csfp510_w              #????
    CALL cl_used(g_prog,g_time,2)    #?????? (????) 
        RETURNING g_time       
END MAIN

function csfp510_menu()
    WHILE TRUE
        CALL csfp510_bp()
        CASE g_action_choice   
            WHEN "query"
               CALL csfp510_q()
            WHEN "help" 
                CALL cl_show_help()
            WHEN "exit"
                EXIT WHILE
            WHEN "controlg"
                CALL cl_cmdask()
            WHEN "exporttoexcel"
                call cl_download_by_explorer(
                    cl_expexcel1("s_tc_sfe",base.typeinfo.create(g_tc_sfe)))
        END CASE
    END WHILE
end function

function csfp510_q()

    let g_action_choice = ""
    DISPLAY '   ' TO FORMONLY.cn2

    CALL csfp510_cs()
    IF INT_FLAG or g_action_choice="exit" THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
    call csfp510_b_fill()
    MESSAGE ""

end function

function csfp510_cs()

    CLEAR FORM
    CALL g_tc_sfe.clear()
    CALL cl_set_head_visible("","YES")
    CALL cl_set_act_visible("accept,cancel", true)

    let int_flag = 0
    CONSTRUCT g_wc ON 
        tc_sfd01,tc_sfd07,tc_sfe02,sfb05,tc_sfe03
        from s_tc_sfe[1].tc_sfd01,s_tc_sfe[1].tc_sfd07,s_tc_sfe[1].tc_sfe02,s_tc_sfe[1].sfb05,s_tc_sfe[1].tc_sfe03

        on action controlp
            case
                when infield(tc_sfd01)
                    call cl_init_qry_var()
                    let g_qryparam.form = "cq_tc_sfd01"
                    let g_qryparam.arg1 = g_lang
                    let g_qryparam.state= "c"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to tc_sfd01
                    next field tc_sfd01
                when infield(tc_sfd07)
                    call cl_init_qry_var()
                    let g_qryparam.form = "cq_tc_sfd02"
                    let g_qryparam.arg1 = g_lang
                    let g_qryparam.state= "c"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to tc_sfd07
                    next field tc_sfd07
                when infield(tc_sfe02)
                    call cl_init_qry_var()
                    let g_qryparam.form = "cq_tc_sfd03"
                    let g_qryparam.arg1 = g_lang
                    let g_qryparam.state= "c"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to tc_sfe02
                    next field tc_sfe02
                when infield(sfb05)
                    call cl_init_qry_var()
                    let g_qryparam.form = "cq_tc_sfd04"
                    let g_qryparam.arg1 = g_lang
                    let g_qryparam.state= "c"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to sfb05
                    next field sfb05
            end case

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

        ON ACTION about     
            CALL cl_about()   
        
        ON ACTION help        
            CALL cl_show_help() 
        
        ON ACTION controlg     
            CALL cl_cmdask()   

        ON ACTION qbe_save
            CALL cl_qbe_save()
        
        on action exit
            let g_action_choice = "exit"
            exit construct
    end construct
    CALL cl_set_act_visible("accept,cancel", false)
end function

function csfp510_b_fill()
    if cl_null(g_wc) then let g_wc = " 1=1" end if

    let g_sql = "select 'N',tc_sfd01,tc_sfd07,tc_sfe02,shm01,sfb05,ima02,tc_sfe03,tc_sfeud02 ",
                "  from tc_sfd_file,tc_sfe_file,sfb_file,ima_file,shm_file ",
                " where tc_sfe01 = tc_sfd01 and sfb01 = tc_sfe02 and ima01 = sfb05 and ta_shm05 = tc_sfd07 ",
                "   and ",g_wc clipped," and (tc_sfeud02 = 'N' or tc_sfeud02 is null)",
                " order by tc_sfd01"
    prepare csfp510_pb from g_sql
    declare csfp510_curs cursor for csfp510_pb

    call g_tc_sfe.clear()
    let g_cnt = 1
    foreach csfp510_curs into g_tc_sfe[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfp510_curs",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_tc_sfe.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    let g_rec_b = g_cnt

end function

function csfp510_bp()
    define i,l_ac integer
    input array g_tc_sfe without defaults from s_tc_sfe.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
                  insert row = false,delete row =false ,
                  append row = false)
        before input

        before row
            let l_ac = ARR_CURR()
 
        on action controlo 

        on change chk
            for i = 1 to g_tc_sfe.getLength() 
                if g_tc_sfe[i].tc_sfd01 = g_tc_sfe[l_ac].tc_sfd01  and g_tc_sfe[i].tc_sfe02 = g_tc_sfe[l_ac].tc_sfe02 then
                    let g_tc_sfe[i].chk = g_tc_sfe[l_ac].chk
                end if
            end for

        on action controlg
            call cl_cmdask()
 
        on idle g_idle_seconds
           call cl_on_idle()
           continue input
 
        on action about      
           call cl_about()  
        
        on action help        
           call cl_show_help()

        on action exit
            if g_action_choice = "exit" then
                let g_action_choice = "exit"
            else
                let g_action_choice = "query"
            end if
            exit input

        on action select_all
            for i = 1 to g_tc_sfe.getLength() 
                let g_tc_sfe[i].chk = 'Y'
            end for

        on action cancel_all
            for i = 1 to g_tc_sfe.getLength() 
                let g_tc_sfe[i].chk = 'N'
            end for

        on action reverse_all
            for i = 1 to g_tc_sfe.getLength() 
                if g_tc_sfe[i].chk = 'N' then
                    let g_tc_sfe[i].chk = 'Y'
                else
                    let g_tc_sfe[i].chk = 'N'
                end if
            end for

        on action send_out
            if csfp510_send_out() then
                call csfp510_b_fill()
                display array g_tc_sfe to s_tc_sfe.*
                    before display
                        exit display
                end display
                continue input
            end if

    end input
end function

function csfp510_send_out()
    define i integer
    define l_cnt integer

    begin work
    let g_success = 'Y'
    let l_cnt = 0
    for i = 1 to g_tc_sfe.getlength()
        if g_tc_sfe[i].chk = 'Y' then
            update tc_sfe_file set tc_sfeud02 = 'Y'
             where tc_sfe01 = g_tc_sfe[i].tc_sfd01
               and tc_sfe02 = g_tc_sfe[i].tc_sfe02
            if sqlca.sqlcode then
                call cl_err(g_tc_sfe[i].tc_sfd01||","||g_tc_sfe[i].tc_sfe02,sqlca.sqlcode,1)
                let g_success = 'N'
                exit for
            end if
            let l_cnt = l_cnt + 1
        end if
    end for
    if g_success = 'Y' then
        commit work
        CALL cl_err_msg('','agl1023',l_cnt,1)
        return true
    else
        rollback work
        return false
    end if
end function
