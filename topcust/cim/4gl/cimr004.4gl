# Prog. Version..: '5.30.06-13.03.12(00005)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cimr004.4gl
# Desc/riptions..: 料件基本資料列印表
# Date & Author..: darcy:2025/12/30

database ds

GLOBALS "../../../tiptop/config/top.global"

define  tm  record
        wc      string,
        wc1     string,
        s       like type_file.chr3,
        y       like type_file.chr1,
        more    like type_file.chr1
    end record
define  g_sql,g_str,g_table   string

MAIN
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
    call cl_used(g_prog,g_time,1) returning g_time

    let g_pdate = arg_val(1)        -- 固定组合
    let g_towhom = arg_val(2)       -- 固定组合
    let g_rlang = arg_val(3)        -- 固定组合
    let g_bgjob = arg_val(4)        -- 固定组合
    let g_prtway = arg_val(5)       -- 固定组合
    let g_copies = arg_val(6)       -- 固定组合
    let tm.wc = arg_val(7)
    let tm.s  = arg_val(8)
    let tm.y  = arg_val(9)
    let g_rep_user = arg_val(10)    -- 固定组合
    let g_rep_clas = arg_val(11)    -- 固定组合
    let g_template = arg_val(12)    -- 固定组合
    let g_rpt_name = arg_val(13)    -- 固定组合

    let g_sql=
               "rowidx.type_file.num5,",
               "img01.img_file.img01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "img02.img_file.img02,",
               "img03.img_file.img03,",
               "img09.img_file.img09,",
               "img10.img_file.img10,",
               "num01.ima_file.ima02,",
               "num02.ima_file.ima02,",
               "num03.ima_file.ima02,",
               "num04.ima_file.ima02,",
               "remark.ima_file.ima02"

    let g_table = cl_prt_temptable('cimr004',g_sql) clipped

    if g_table = -1 then
        exit program
    end if

    if cl_null(g_bgjob) or g_bgjob = 'N' then
        call cimr004_tm()
    else
        call cimr004()
    end if

    call cl_used(g_prog,g_time,2) returning g_time
END MAIN

function cimr004_tm()
    DEFINE  l_cmd       LIKE type_file.chr1000

    open window r110_w at 1,1 with form "cim/42f/cimr004"
        attribute (style = g_win_style clipped)

    call cl_ui_init()

    call cl_opmsg('p')

    while true

        dialog attributes(unbuffered)

            construct by name tm.wc on img02

                before construct
                    call cl_qbe_init()
            end construct


            before dialog
                initialize tm.* to null
                let tm.s    = '123'
                let tm.y    = '0'
                let tm.more = 'N'
                let g_pdate = g_today
                let g_rlang = g_lang
                let g_bgjob = 'N'
                let g_copies = '1'
                let tm2.s1='1'
                let tm2.s2='2'
                let tm2.s3='3'
                display by name tm.s,tm.y,tm.more,tm2.s1,tm2.s2,tm2.s3

            on action controlp
                if infield(img02) then
                    call cl_init_qry_var()
                    let g_qryparam.form = "q_imd01"
                    let g_qryparam.state = "c"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to img02
                    next field img02
                end if

            on action locale
                call cl_show_fld_cont()
                let g_action_choice = "locale"
                exit dialog

            on idle g_idle_seconds
                call cl_on_idle()
                continue dialog

            on action about
                call cl_about()

            on action help
                call cl_show_help()

            on action controlg
                call cl_cmdask()

            on action controlr
                call cl_show_req_fields()

            on action exit
                let int_flag = 1
                exit dialog

            on action cancel
                let int_flag = 1
                exit dialog

            on action accept
                exit dialog

            on action qbe_select
                call cl_qbe_select()

            on action qbe_save
                    call cl_qbe_save()

        end dialog

        if g_action_choice = "locale" then
            let g_action_choice = ""
            call cl_dynamic_locale()
            continue while
        end if

        if int_flag then
            let int_flag = 0
            close window r110_w
            call cl_used(g_prog,g_time,2) returning g_time
            exit program
        end if

        if tm.wc = " 1=1" then
            call cl_err('','9046',0)
            continue while
        end if

        if int_flag then
            let int_flag = 0 close window r110_w
            call cl_used(g_prog,g_time,2) returning g_time
            exit program
        end if

        if g_bgjob = 'Y' then
            select zz08 into l_cmd from zz_file where zz01='cimr004'
            if sqlca.sqlcode or l_cmd is null then
                call cl_err('cimr004','9031',1)
            else
                let tm.wc=cl_replace_str(tm.wc, "'", "\"")
                let l_cmd = l_cmd clipped,
                            " '",g_pdate clipped,"'",
                            " '",g_towhom clipped,"'",
                            " '",g_rlang clipped,"'",
                            " '",g_bgjob clipped,"'",
                            " '",g_prtway clipped,"'",
                            " '",g_copies clipped,"'",
                            " '",tm.wc clipped,"'",
                            " '",tm.s clipped,"'",
                            " '",tm.y clipped,"'",
                            " '",g_rep_user clipped,"'",
                            " '",g_rep_clas clipped,"'",
                            " '",g_template clipped,"'",
                            " '",g_rpt_name clipped,"'"
                call cl_cmdat('cimr004',g_time,l_cmd)
            end if

            close window r110_w
            call cl_used(g_prog,g_time,2) returning g_time
            exit program
        end if

        call cl_wait()
        call cimr004()
        error ""
    end while
    close window r110_w
end function

function cimr004()
    define  sr      record
        rowidx  like type_file.num5,
        img01   like img_file.img01,
        ima02   like ima_file.ima02,
        ima021  like ima_file.ima021,
        img02   like img_file.img02,
        img03   like img_file.img03,
        img09   like img_file.img09,
        img10   like img_file.img10,
        num01   like ima_file.ima02,
        num02   like ima_file.ima02,
        num03   like ima_file.ima02,
        num04   like ima_file.ima02,
        remark  like ima_file.ima02
    end record
    define l_sql  string

    call cl_del_data(g_table)

    let g_sql = "insert into ",g_cr_db_str clipped,g_table clipped,
                " values(?,?,?,?,?, ?,?,? ,?,?,?,?,?)"
    prepare insert_prep from g_sql
    if status then
       call cl_err('insert_prep:',status,1)
       call cl_used(g_prog,g_time,2) returning g_time
       exit program
    end if

    let g_sql = "select 1,img01,ima02,ima021,img02,img03,img09,sum(img10) img10",
                " from img_file,ima_file ",
                " where img01 = ima01 and ", tm.wc clipped ,
                "   and img10 <> 0",
                " group by img01,ima02,ima021,img02,img03,img09 "


    prepare cimr004_pr from g_sql
    if sqlca.sqlcode then
       call cl_err('prepare:',sqlca.sqlcode,1)
       call cl_used(g_prog,g_time,2) returning g_time
       exit program
    end if
    declare cimr004_cs1 cursor for cimr004_pr

    foreach cimr004_cs1 into sr.rowidx,sr.img01,sr.ima02,sr.ima021,sr.img02,sr.img03,sr.img09,sr.img10
        if sqlca.sqlcode != 0 then
            call cl_err('foreach:',sqlca.sqlcode,1)
            exit foreach
        end if

        execute insert_prep using sr.rowidx,sr.img01,sr.ima02,sr.ima021,sr.img02,sr.img03,sr.img09,sr.img10,
                                  sr.num01,sr.num02,sr.num03,sr.num04,sr.remark
    end foreach

    let g_sql = "select * from ",g_cr_db_str clipped,g_table clipped

    let g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.y

    let l_sql = g_sql , " order by img02,img03,img01 "

    let l_sql = "select rownum,img01,ima02,ima021,img02,img03,img09,img10,num01,num02,num03,num04,remark",
                "  from ( " , l_sql , " )"
    call cl_fast_query_zat( "tqrcim0010", l_sql, true )

    call cl_prt_cs3('cimr004','cimr004',g_sql,g_str)

end function
