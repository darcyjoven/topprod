# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: csfq028.4gl
# Descriptions...: 工单发退料查询
# Date & Author..: darcy:2024/02/21 add

database ds
globals "../../../tiptop/config/top.global"

type sfs record
    sfp01       like sfp_file.sfp01,
    sfp02       like sfp_file.sfp02,
    sfp06       like sfp_file.sfp06,
    sfp07       like sfp_file.sfp07,
    gem02       like gem_file.gem02,
    sfp16       like sfp_file.sfp16,
    gen02       like gen_file.gen02,
    sfp04       like sfp_file.sfp04,
    sfpud02     like sfp_file.sfpud02,
    sfpud03     like sfp_file.sfpud03,
    sfs02       like sfs_file.sfs02,
    sfs03       like sfs_file.sfs03, 
    sfq03       like sfq_file.sfq03, 
    sfs26       like sfs_file.sfs26,
    sfs28       like sfs_file.sfs28,
    sfs27       like sfs_file.sfs27,
    sfs04       like sfs_file.sfs04,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021,
    sfs06       like sfs_file.sfs06,
    sfs10       like sfs_file.sfs10,
    eca01       like eca_file.eca01,
    eca02       like eca_file.eca02,
    sfa05       like sfa_file.sfa05,
    sfa06       like sfa_file.sfa06,
    sfsud07     like sfs_file.sfsud07,
    sfsud02     like sfs_file.sfsud02,
    imn05       like imn_file.imn05,
    sfs05       like sfs_file.sfs05,
    sfs07       like sfs_file.sfs07,
    sfs08       like sfs_file.sfs08,
    sfs09       like sfs_file.sfs09
end record
type sfq record
    sfp02_1     like sfp_file.sfp02,
    sfs03_1     like sfs_file.sfs03,
    sfs10_1     like sfs_file.sfs10,
    eca01_1     like eca_file.eca01,
    eca02_1     like eca_file.eca02,
    sfs04_1     like sfs_file.sfs04,
    ima02_1     like ima_file.ima02,
    ima021_1    like ima_file.ima021,
    sfsud07_1   like sfs_file.sfsud07,
    sfs06_1     like sfs_file.sfs06,
    sfsud02_1   like sfs_file.sfsud02,
    imn05_1     like imn_file.imn05,
    sfs09_1     like sfs_file.sfs09,
    sfs05_1     like sfs_file.sfs05
    end record

define g_sql,g_wc,g_wc2,g_wc1 string
define g_page_flag varchar(20)
define g_cnt,l_ac,g_row_count,g_curs_index integer
define tm  record
    sfp06_q varchar(20),
    begin_q varchar(20),
    end_q varchar(20),
    sfsud07_q varchar(1),
    post_q varchar(1),
    xiaban_q varchar(1),
    groupby varchar(10)
    end record

define g_sfs,g_sfs_excel dynamic array of sfs
define g_sfq,g_sfq_excel dynamic array of sfq
define g_accept     varchar(1)


MAIN
    define   p_row,p_col   like type_file.num5
    options
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CSF")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time
    open window csfq028_w at p_row,p_col with form "csf/42f/csfq028"
            attribute (style = g_win_style clipped)
        
    call cl_ui_init()
    
    call csfq028_query()
    if g_accept != 'Y' then return end if

    call csfq028_menu()

    close window csfq028_w
    call  cl_used(g_prog,g_time,2) returning g_time 
end main

function csfq028_menu()
    let g_page_flag =  iif(cl_null(g_page_flag),"page3",g_page_flag)
    while true
        case g_page_flag
            when "page3"
                call csfq028_bp1()
            when "page4"
                call csfq028_bp2()
        end case
        case g_action_choice

            when "help"
            call cl_show_help()
 
            when "exit"
                exit while

            when "close"
                exit while
    
            when "controlg"
                call cl_cmdask()
            
            when "query"
                if cl_chk_act_auth() then
                    call csfq028_query()
                end if
            
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    call csfq028_b_fill1()
                    call csfq028_b_fill2()
                    call csfq028_no_entry()
                    call cl_download_by_explorer(
                        cl_expexcel(
                            "s_sfs",base.typeinfo.create(g_sfs_excel),
                            "s_sfq",base.typeinfo.create(g_sfq_excel),
                            "",""
                        ))
                end if
        end case
    end while
end function

# 查询条件录入
function csfq028_cs()
    define   l_cnt like type_file.num15_3
    

    clear form

    initialize tm.* to null
    let g_wc = ""
    let g_wc1 = ""
    let g_wc2 = ""
    let g_sql = "select
                 TO_CHAR(TRUNC(SYSDATE - INTERVAL '2' HOUR, 'HH24'), 'HH24:MI:SS'),
                 TO_CHAR(TRUNC(SYSDATE , 'HH24'), 'HH24:MI:SS') FROM DUAL "
    prepare csfq028_tlf08_p from g_sql

    call cl_set_head_visible("","YES")

    call cl_set_act_visible("accept,cancel", true)
    let g_accept = 'N'

    CALL ui.Dialog.setDefaultUnbuffered(TRUE)
    dialog --ATTRIBUTES(WITHOUT DEFAULTS)

        input by name tm.* --attributes( without defaults)

            before input
                

            after field post_q
                if tm.post_q = 'N' then
                    call cl_err("查询非过账时，将忽略过账操作日期和时间条件","!",0)
                end if
            
            after field sfp06_q
                if tm.sfp06_q = '1' then
                    call cl_set_comp_entry("sfsud07_q",true)
                    let tm.sfsud07_q = 'Y'
                    display by name tm.sfsud07_q
                else
                    call cl_set_comp_entry("sfsud07_q",false)
                    let tm.sfsud07_q = 'N'
                    display by name tm.sfsud07_q
                end if
            
        end input
        construct g_wc1 on sfp03 from sfp03_q
        end construct
        construct g_wc2 on tlf07 from tlf07_q

        end construct
        construct by name g_wc on sfp01,sfp02,sfp07,sfp16,sfs03,sfs27,sfs04,sfs10
        end construct 
        

        before dialog
            display g_today to tlf07_q
            display g_today to sfp03_q
            let tm.post_q = 'Y'
            let tm.xiaban_q = 'Y'
            let tm.sfp06_q = '1'
            let tm.groupby = '1' 
            let tm.sfsud07_q = 'Y'
            # 前两个小时，整点
            execute csfq028_tlf08_p into tm.begin_q,tm.end_q
            display by name tm.*

        on action controlp
            case
                when infield(sfp01)
                    message ""
            end case
        
        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog

        on action about
            call cl_about()

        on action help
            call cl_show_help()
        
        on action accept
            let g_accept = 'Y'
            exit dialog

        on action cancel
            exit dialog

        on action exit
            exit dialog

    end dialog
    call cl_set_act_visible("accept,cancel", false)
    
end function

# 查询
function csfq028_query()
    let g_row_count = 0
    let g_curs_index = 0
    call cl_navigator_setting( g_curs_index, g_row_count )
  
    display '   ' to formonly.cnt
    display '   ' to formonly.cn1
    display '   ' to formonly.cn3
    display '   ' to formonly.cn2
    call csfq028_cs()
    if g_accept != 'Y' then 
        return 
    end if
    
    # 查询主体资料
    call csfq028_temp()
    # 先显示汇总页签
    # call csfq028_bp1()
	message ''
end function

function csfq028_bp1()

    let g_action_choice = " "

    # call cl_set_act_visible("accept,cancel", false) 

    display g_sfs.getLength() to cnt

    dialog
    
        display array g_sfs to s_sfs.*
            
        end display

        on action query
            let g_action_choice="query"
            exit dialog
    
        on action help
            let g_action_choice="help"
            exit dialog
    
        on action locale
            let g_action_choice="locale"
            exit dialog
    
        on action exit
            let g_action_choice="exit"
            exit dialog
    
        on action cancel
            let int_flag=false
            let g_action_choice="exit"
            exit dialog
    
        on action controlg
            let g_action_choice="controlg"
            exit dialog
    
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
    
        on action about
            call cl_about()
        
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog
        on action page4
            let g_page_flag = 'page4'
            exit dialog
    end dialog

end function

function csfq028_bp2()

    let g_action_choice = " " 
    call csfq028_b_fill2()
     
    display g_sfq.getLength() to cn2
    call csfq028_no_entry()

    call cl_set_act_visible("accept,cancel", true)
    dialog
        input by name tm.groupby attributes( without defaults)
            on change groupby
                call csfq028_refresh()
                call csfq028_no_entry()
                display array g_sfq to s_sfq.*
                    before display
                        exit display
                end display
        end input
        display array g_sfq to s_sfq.*
            
        end display

        on action query
            let g_action_choice="query"
            exit dialog
    
        on action help
            let g_action_choice="help"
            exit dialog
    
        on action locale
            let g_action_choice="locale"
            exit dialog
    
        on action exit
            let g_action_choice="exit"
            exit dialog
    
        on action cancel
            let int_flag=false
            let g_action_choice="exit"
            exit dialog
        
        on action accept 
            let g_accept = 'Y'
            exit dialog
    
        on action controlg
            let g_action_choice="controlg"
            exit dialog
    
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
    
        on action about
            call cl_about()
        
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog

        on action page3
            let g_page_flag = 'page3'
            exit dialog
    end dialog
    call cl_set_act_visible("accept,cancel", false)

end function

function csfq028_b_fill1()
    
    let g_sql = "select sfp01,sfp02,sfp06,sfp07,gem02,sfp16,gen02,sfp04,sfpud02,
                        sfpud03,sfs02,sfs03,sfq03,sfs26,sfs28,sfs27,sfs04,ima02,
                        ima021,sfs06,sfs10,eca01,eca02,sfa05,sfa06,sfsud07,
                        sfsud02,imn05,sfs05,sfs07,sfs08,sfs09  from csfq028_temp
                  order by sfp02,sfp01"
    prepare csfq028_bp1_p from g_sql
    declare csfq028_bp1_cl cursor for csfq028_bp1_p

    let g_cnt = 1 
    call g_sfs_excel.clear()
    call g_sfs.clear()
    foreach csfq028_bp1_cl into g_sfs_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfq028_bp1_cl",sqlca.sqlcode,1)
        end if
        if g_cnt <= g_max_rec then
            let g_sfs[g_cnt].* = g_sfs_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfs_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt -1
    
    if g_cnt > g_max_rec then
        call cl_err_msg(NULL,"axc-131",g_cnt||"|"||g_max_rec,10)
    end if

end function

function csfq028_b_fill2()


    
    case tm.groupby
        when '1'
            let g_sql = "select '','','','','',sfs04,ima02,ima021,'',sfs06,sfsud02,imn05,sfs09,"
            if tm.sfsud07_q = 'Y' then
                let g_sql = g_sql," sum(case when sfsud07 >0 then sfsud07 else sfs05 end) sfs05"
            end if 
            let g_sql = g_sql," from csfq028_temp ",
                        "group by sfs06,sfs04,ima02,ima021,sfsud02,imn05,sfs09 ",
                        "order by sfs04,sfs06,sfsud02,imn05,sfs09"
        when '2'
            let g_sql = "select '','','','','',sfs04,ima02,ima021,'',sfs06,'','','',"
            if tm.sfsud07_q = 'Y' then
                let g_sql = g_sql," sum(case when sfsud07 >0 then sfsud07 else sfs05 end) sfs05"
            end if 
            let g_sql = g_sql," from csfq028_temp ",
                        "group by sfs04,ima02,ima021 ",
                        "order by sfs04"
        when '3'
            let g_sql = "select '',sfs03,'','','',sfs04,ima02,ima021,'',sfs06,sfsud02,imn05,sfs09,"
            if tm.sfsud07_q = 'Y' then
                let g_sql = g_sql," sum(case when sfsud07 >0 then sfsud07 else sfs05 end) sfs05"
            end if 
            let g_sql = g_sql," from csfq028_temp ",
                        "group by sfs03,sfs06,sfs04,ima02,ima021,sfsud02,imn05,sfs09 ",
                        "order by sfs03,sfs04,sfs06,sfsud02,imn05,sfs09"
        when '4'
            let g_sql = "select sfp02,'','','','',sfs04,ima02,ima021,'',sfs06,sfsud02,imn05,sfs09,"
            if tm.sfsud07_q = 'Y' then
                let g_sql = g_sql," sum(case when sfsud07 >0 then sfsud07 else sfs05 end) sfs05"
            end if 
            let g_sql = g_sql," from csfq028_temp ",
                        "group by sfp02,sfs06,sfs04,ima02,ima021,sfsud02,imn05,sfs09 ",
                        "order by sfp02,sfs04,sfs06,sfsud02,imn05,sfs09"
        when '5'
            let g_sql = "select '','',sfs10,'','',sfs04,ima02,ima021,'',sfs06,sfsud02,imn05,sfs09,"
            if tm.sfsud07_q = 'Y' then
                let g_sql = g_sql," sum(case when sfsud07 >0 then sfsud07 else sfs05 end) sfs05"
            end if 
            let g_sql = g_sql," from csfq028_temp ",
                        "group by sfs10,sfs06,sfs04,ima02,ima021,sfsud02,imn05,sfs09 ",
                        "order by sfs10,sfs04,sfs06,sfsud02,imn05,sfs09"
        when '6'
            let g_sql = "select '','','',eca01,eca02,sfs04,ima02,ima021,'',sfs06,sfsud02,imn05,sfs09,"
            if tm.sfsud07_q = 'Y' then
                let g_sql = g_sql," sum(case when sfsud07 >0 then sfsud07 else sfs05 end) sfs05"
            end if 
            let g_sql = g_sql," from csfq028_temp ",
                        "group by eca01,eca02,sfs06,sfs04,ima02,ima021,sfsud02,imn05,sfs09 ",
                        "order by eca01,eca02,sfs04,sfs06,sfsud02,imn05,sfs09"
    end case
    

    prepare csfq028_bp2_p from g_sql
    declare csfq028_bp2_cl cursor for csfq028_bp2_p

    let g_cnt = 1 
    call g_sfq_excel.clear()
    call g_sfq.clear()
    foreach csfq028_bp2_cl into g_sfq_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfq028_bp2_cl",sqlca.sqlcode,1)
        end if
        if g_cnt <= g_max_rec then
            let g_sfq[g_cnt].* = g_sfq_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfq_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt -1
    
    if g_cnt > g_max_rec then
        call cl_err_msg(NULL,"axc-131",g_cnt||"|"||g_max_rec,10)
    end if

end function

function csfq028_refresh()
    call csfq028_b_fill2()
end function

# 查询主体资料，结果保存到临时表中
function csfq028_temp()
    define l_sfs_sql string
    define l_tlf_sql string

    drop table csfq028_temp
    # 建立临时表
    let g_sql ="select sfp01,sfp02,sfp06,sfp07,gem02,sfp16,gen02,sfp04,sfpud02,
                       sfpud03,sfs02,sfs03,sfq03,sfs26,sfs28,sfs27,sfs04,ima02,
                       ima021,sfs06,sfs10,eca01,eca02,sfa05,sfa06,sfsud07,
                       sfsud02,imn05,sfs05,sfs07,sfs08,sfs09 
                from sfp_file,sfs_file,sfq_file,gem_file,gen_file,ima_file,imn_file,sfa_file,eca_file
                where 1=2
                into temp csfq028_temp"
    prepare csfq028_crt_tmp from g_sql
    execute csfq028_crt_tmp
    if sqlca.sqlcode then
        call cl_err('csfq028_crt_tmp',sqlca.sqlcode,1)
        return
    end if
    

    let g_sql = "ALTER TABLE csfq028_temp MODIFY (SFP01 NULL, SFS02 NULL, ECA01 NULL,SFA05 null,SFA06 null) "
    prepare csfq028_alter_tmp from g_sql
    execute csfq028_alter_tmp
    if sqlca.sqlcode then
        call cl_err('csfq028_alter_tmp',sqlca.sqlcode,1)
        return
    end if

    delete from csfq028_temp


    if tm.post_q = 'Y' then
        let l_sfs_sql = "(select sfe02 sfs01,sfe28 sfs02,sfe01 sfs03,'' sfs26,1 sfs28,sfe27 sfs27,sfe07 sfs04, ",
                        " sfe17 sfs06, sfe14 sfs10,sfeud07 sfsud07 ,sfeud02 sfsud02,sfe16 sfs05, sfe08 sfs07, ",
                        " sfe09 sfs08,sfe10 sfs09 from sfe_file) sfs_file"
    else
        let l_sfs_sql = "sfs_file"
    end if

    let l_tlf_sql = "select tlf905 from tlf_file where tlf13 like 'asfi5%' "
    
    let g_sql = "select sfp01,sfp02,sfp06,sfp07,gem02,sfp16,gen02,sfp04,sfpud02,
                       sfpud03,sfs02,sfs03,sfq03,sfs26,sfs28,sfs27,sfs04,ima02,
                       ima021,sfs06,sfs10,eca01,eca02,sfa05,sfa06,sfsud07,
                       sfsud02,imn05,sfs05,sfs07,sfs08,sfs09",
                "   from sfp_file
                    left join gem_file on gem01 = sfp07
                    left join gen_file on gen01 = sfp16, ",
                " (select unique sfq01,sfq02,sfq03 from sfq_file ) sfq_file, ",l_sfs_sql,"
                    left join ima_file on ima01 = sfs04
                    left join (
                        select unique imm09, imn03, imn06, imn05,imn10 from imn_file, imm_file
                         where imn01 = imm01 and imm03 = 'Y') imn_file 
                        on imm09 = sfs01 and imn03 = sfs04 and imn06 = sfs09 and imn10 = sfsud07
                    left join sfa_file on sfa01 = sfs03 and sfa03 = sfs04 and sfs10 = sfa08
                    left join ecm_file on ecm01 = sfs03 and ecm04 = sfs10
                    left join eca_file on eca01 = ecm06
                    where sfp01 = sfq01
                    and sfs01 = sfp01 and sfq02 = sfs03"

    if g_wc !=" 1=1" then
        # 单身条件
        let g_sql = g_sql," and ",g_wc
    end if
    if g_wc1 !=" 1=1" then
        # 过账日期sfp03
        let g_sql = g_sql," and ",g_wc1
    end if
    if g_wc2 !=" 1=1" then
        # 操作日期 # tlf07
        let l_tlf_sql = l_tlf_sql," and ",g_wc2
    end if
    if not cl_null(tm.begin_q) then
        let l_tlf_sql = l_tlf_sql , " and tlf08 >= '",tm.begin_q,"'"
    end if

    if not cl_null(tm.end_q) then
        let l_tlf_sql = l_tlf_sql, " and tlf08 <= '",tm.end_q,"'"
    end if

    if  l_tlf_sql != "select tlf905 from tlf_file where tlf13 like 'asfi5%' " then
        let g_sql = g_sql , " and sfp01 in (",l_tlf_sql,")"
    end if
    if not cl_null(tm.sfp06_q) then
        let g_sql = g_sql , " and sfp06 = '",tm.sfp06_q clipped,"'"
    end if
    if tm.xiaban_q = 'Y' then
        let g_sql = g_sql," and sfp01 not like 'TT%' "
    end if
    let g_sql = "insert into csfq028_temp ",g_sql

    prepare csfq028_ins_tmp from g_sql
    execute csfq028_ins_tmp

    if sqlca.sqlcode then
        call cl_err("csfq028_ins_tmp",sqlca.sqlcode,1)
        return
    end if

    call csfq028_b_fill1()
    
end function

function csfq028_no_entry()
    call cl_set_comp_visible("sfp02_1,sfs03_1,sfs10_1,eca01_1,eca02_1,sfs04_1,ima02_1,ima021_1,sfsud07_1,sfs06_1,sfsud02_1,imn05_1,sfs09_1,sfs05_1",true)
    case tm.groupby
        when '1'
            call cl_set_comp_visible("sfp02_1,sfs03_1,sfs10_1,eca01_1,eca02_1,sfsud07_1",false)
        when '2'
            call cl_set_comp_visible("sfp02_1,sfs03_1,sfs10_1,eca01_1,eca02_1,sfsud07_1,sfsud02_1,imn05_1,sfs09_1",false)
        when '3'
            call cl_set_comp_visible("sfp02_1,sfs10_1,eca01_1,eca02_1,sfsud07_1",false)
        when '4'
            call cl_set_comp_visible("sfs03_1,sfs10_1,eca01_1,eca02_1,sfsud07_1",false)
        when '5'
            call cl_set_comp_visible("sfp02_1,sfs03_1,eca01_1,eca02_1,sfsud07_1",false)
        when '6'
            call cl_set_comp_visible("sfp02_1,sfs03_1,sfs10_1,sfsud07_1",false)
    end case
end function
