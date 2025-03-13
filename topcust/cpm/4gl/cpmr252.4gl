# prog. version..:
#
# pattern name...: cpmr252.4gl
# descriptions...: 
# date & author..: 16/03/03 by yaolf
#hfbg-16030001
import libqrcodegen
database ds
 
globals "../../../tiptop/config/top.global"

define g_wc,l_table,g_str,g_sql,g_msg string
define g_cnt,g_i integer


main
    options
        input no wrap
    defer interrupt
    
    if (not cl_user()) then
        exit program
    end if
    
    whenever error call cl_err_msg_log
    
    if (not cl_setup("CPM")) then
        exit program
    end if
    call cl_used(g_prog,g_time,1) returning g_time

    let g_sql = "tc_pmw01.tc_pmw_file.tc_pmw01,",
                "tc_pmw02.tc_pmw_file.tc_pmw02,",
                "tc_pmx01.tc_pmx_file.tc_pmx01,",
                "tc_pmx02.tc_pmx_file.tc_pmx02,",
                "tc_pmx03.tc_pmx_file.tc_pmx03,",
                "tc_pmx06.tc_pmx_file.tc_pmx06,",
                "tc_pmx06t.tc_pmx_file.tc_pmx06t,",
                "tc_pmx07.tc_pmx_file.tc_pmx07,",
                "tc_pmx07t.tc_pmx_file.tc_pmx07t,",
                "tc_qrcode.type_file.blob"
    let  l_table = cl_prt_temptable('cpmr252',g_sql) CLIPPED
    if l_table=-1 then exit program end if
    let g_sql = "insert into ",g_cr_db_str clipped,l_table clipped,
                " values(?,?,?,?,?, ?,?,?,?,?)"
    prepare insert_prep from g_sql
    if status then
        call cl_err('insert_prep:',status,1) exit program
    end if

    call cpmr252_tm()
    call cl_used(g_prog,g_time,2) returning g_time 
end main
function cpmr252_tm()

    open window cpmr252_w at 9,8 with form "cpm/42f/cpmr252"
        attribute (style = g_win_style clipped) 
    call cl_ui_init()

    call cl_opmsg('p')

    while true
        construct by name g_wc on tc_pmw01,tc_pmw02
            before construct
                call cl_qbe_init()
            on action locale 
                call cl_show_fld_cont()                    
                let g_action_choice = "locale"
                exit construct
            on idle g_idle_seconds
                call cl_on_idle()
                continue construct
            on action controlp

            on action about
                call cl_about()
 
            on action help
                call cl_show_help()
 
            on action controlg
                call cl_cmdask()
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
            let int_flag = 0 close window cpmr252_w 
            call cl_used(g_prog,g_time,2) returning g_time #no.fun-690126
            exit program
        end if

        if g_wc=" 1=1" then
            call cl_err('','9046',0)
            continue while
        end if
        call cl_wait()
        call cpmr252()
        error ""
    end while
    close window cpmr252_w
end function
function cpmr252()
    define sr record
        tc_pmw01 like tc_pmw_file.tc_pmw01,
        tc_pmw02 like tc_pmw_file.tc_pmw02,
        tc_pmx01 like tc_pmx_file.tc_pmx01,
        tc_pmx02 like tc_pmx_file.tc_pmx02,
        tc_pmx03 like tc_pmx_file.tc_pmx03,
        tc_pmx06 like tc_pmx_file.tc_pmx06,
        tc_pmx06t like tc_pmx_file.tc_pmx06t,
        tc_pmx07 like tc_pmx_file.tc_pmx07,
        tc_pmx07t like tc_pmx_file.tc_pmx07t,
        tc_qrcode  byte
    end record 
    define filename varchar(200)

    initialize sr.* to null
    # locate qrcode in memory
    locate sr.tc_qrcode in memory

    let filename = FGL_GETENV("TEMPDIR")
    let filename = sfmt("%1/%2%3.bmp",filename,g_prog,FGL_GETPID())

    # call qrcode.readFile("/u1/out/qrcode.bmp")

    let g_sql = "select tc_pmw01,tc_pmw02,tc_pmx01,tc_pmx02,tc_pmx03,tc_pmx06,tc_pmx06t,tc_pmx07,tc_pmx07t from tc_pmw_file,tc_pmx_file",
                " where tc_pmw01=tc_pmx01 and ",g_wc clipped
    declare cpmr252_curl cursor from g_sql
    foreach cpmr252_curl into sr.tc_pmw01,sr.tc_pmw02,sr.tc_pmx01,sr.tc_pmx02,sr.tc_pmx03,sr.tc_pmx06,sr.tc_pmx06t,sr.tc_pmx07,sr.tc_pmx07t
        if sqlca.sqlcode then
            call cl_err("cpmr252_curl",sqlca.sqlcode,1)
            exit foreach
        end if
        if qrgenerate(sfmt("%1%2%3%4",sr.tc_pmw01,sr.tc_pmw02,sr.tc_pmx01,sr.tc_pmx02),filename) == 0 then
            free sr.tc_qrcode
            locate sr.tc_qrcode in memory
            call sr.tc_qrcode.readFile(filename)
            # let sr.tc_qrcode = qrget(sfmt("%1%2%3%4",sr.tc_pmw01,sr.tc_pmw02,sr.tc_pmx01,sr.tc_pmx02))
        end if
        # let sr.tc_qrcode = qrcode
        execute insert_prep using sr.*
        if sqlca.sqlcode then
            call cl_err("",sqlca.sqlcode,1)
            exit foreach
        end if
    end foreach

    let g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
    call cl_prt_cs3('cpmr252','cpmr252_1',g_sql,"http://192.168.1.22/topprod/images/qrcode_new.jgp")

end function
