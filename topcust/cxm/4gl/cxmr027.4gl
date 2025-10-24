# Prog. Version..:
#
# Pattern name...: cxmr027.4gl
# Descriptions...: 拆单明细导出
# Date & Author..: 25/10/23 By huanglf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

define g_wc  string
define g_param  record
    oea01   like oea_file.oea01,
    oea02   like oea_file.oea02,
    oea03   like oea_file.oea03,
    oeauser like oea_file.oeauser,
    oeb04   like oeb_file.oeb04,
    tc_oeb16 like tc_oeb_file.tc_oeb16
    end record 
define g_close   varchar(1)
MAIN
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT                      
    
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("CXM")) THEN
        EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
    initialize g_param.* to null
    let g_param.oea01    = arg_val(1)
    let g_param.oea02    = arg_val(2)
    let g_param.oea03    = arg_val(3)
    let g_param.oeauser  = arg_val(4)
    let g_param.oeb04    = arg_val(5)
    let g_param.tc_oeb16 = arg_val(6)
    let g_close          = arg_val(7)
    call cxmr027_tm()

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

function cxmr027_tm()

    open window cxmr027_w at 1,1 with form "axm/42f/axmt400u"
       attribute (style = g_win_style clipped) 
 
    call cl_ui_init()
    
    while true
        construct by name g_wc on oea01 ,oea02 ,oea03 ,oeauser ,oeb04 ,tc_oeb16

            before construct
                call cl_qbe_init()
                display by name g_param.*

            on action locale 
                call cl_show_fld_cont()                    
                let g_action_choice = "locale"
                exit construct
 
            on idle g_idle_seconds
                call cl_on_idle()
                continue construct
 
            on action controlp
                case
                    when infield(oga01)
                        call cl_init_qry_var()
                        let g_qryparam.form = "q_oga7"  #no.tqc-5b0095
                        let g_qryparam.arg1 = "2','3','4','6','7','8','a"   #no.tqc-5b0095 #no.fun-610020   #tqc-bb0013 add "a"
                        let g_qryparam.state = 'c'
                        call cl_create_qry() returning g_qryparam.multiret
                        display g_qryparam.multiret to oga01
                        -- next field oga01
                        -- continue construct
                    otherwise
                        exit case
                end case
 
            on action about         #mod-4c0121
                call cl_about()      #mod-4c0121
 
            on action help          #mod-4c0121
                call cl_show_help()  #mod-4c0121
 
            on action controlg      #mod-4c0121
                call cl_cmdask()     #mod-4c0121
 
 
            on action exit
                let int_flag = 1
                exit construct
         
            on action qbe_select
                call cl_qbe_select()
        end construct
        if g_action_choice = "locale" then
            let g_action_choice = ""
            call cl_dynamic_locale()
            continue while
        end if
    
        if int_flag then
            let int_flag = 0 
            close window cxmr027_w 
            call cl_used(g_prog,g_time,2) returning g_time #no.fun-690126
            exit program 
        end if
        CALL cl_wait()
        CALL cxmr027()
        if g_close = 'Y' then
            exit while
        end if
    end while  
end function

function cxmr027()
    call t400sub_export_batch(g_wc)
end function
