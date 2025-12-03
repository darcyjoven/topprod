# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: cimq023.4gl
# Descriptions...: 样品投入产出
# Date & Author..: 22/11/02 By darcy
import libmail

database ds
globals "../../config/top.global"
# ---
type totalpage record
    item            varchar(40),
    inamt           decimal(15,3),
    stockamt        decimal(15,3),
    stockpercent    decimal(10,2),
    outamt          decimal(15,3),
    outpercent      decimal(10,2),
    firstin         date,
    firstout        date,
    lastout         date
end record
type sfb record
    sfb01           like sfb_file.sfb01,
    sfb81           like sfb_file.sfb81,
    sfb05           like sfb_file.sfb05,
    sfb081          like sfb_file.sfb081
end record
type oga record
    oga01           like oga_file.oga01,
    oga02           like oga_file.oga02,
    ogb03           like ogb_file.ogb03,
    ogb04           like ogb_file.ogb04,
    ogb12           like ogb_file.ogb12
end record
type sfu record
    sfu01           like sfu_file.sfu01,
    sfu02           like sfu_file.sfu02,
    sfv03           like sfv_file.sfv03,
    sfv04           like sfv_file.sfv04,
    sfv09           like sfv_file.sfv09
end record
# ---
# ---
define   w    ui.Window
define   f    ui.Form
define   page om.DomNode
# ---

# ---
# 主资料
define g_total,g_total_excel dynamic array of totalpage
define g_sfb,g_sfb_excel dynamic array of sfb
define g_oga,g_oga_excel dynamic array of oga
define g_sfu,g_sfu_excel dynamic array of sfu
# ---

# ---
define g_b_flag integer
define g_rec_b integer # 单身总比数
define g_cnt integer #总笔数
define l_ac,l_ac_t integer #单身当前笔数
# ---

# ---
# 工单条件和lot条件
define g_wc1,g_wc2 string
define tm record
    begindate date,
    enddate date
end record
# ---

# ---
define flag_total       like type_file.chr1
define flag_sfb         like type_file.chr1
define flag_oga         like type_file.chr1
define flag_sfu         like type_file.chr1 
# ---

main
    define   p_row,p_col   like type_file.num5          #no.fun-680121 smallint
    options                               #改變一些系統預設值
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("AZZ")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time #no.fun-b30211 
    open window cimq023 at p_row,p_col with form "cim/42f/cimq023"
            attribute (style = g_win_style clipped) #no.fun-580092 hcn
        
    call cl_ui_init()

    call cimq023()

    close window cimq023                 #結束畫面
    call  cl_used(g_prog,g_time,2) returning g_time 
end main
# declear
function cimq023_curs()
    # ---
    define l_sql   string
    # ---

    # ---
    # page1工单清单查询
    
    # ---

end function
# 查询条件
function cimq023_cs()
    clear form
    let g_action_choice=" "

    let tm.begindate = g_today - 7 
    let tm.enddate = g_today

    dialog
        input by name tm.* ATTRIBUTES( WITHOUT DEFAULTS)
            before input
        end input

        construct g_wc1 on ima01 from ima01
            before construct
        end construct

        construct g_wc2 on oga03 from oga03
            before construct
        end construct

        on action controlp
            # 开窗
        on action totalpage
            let g_b_flag = "1"
 
        on action inpage
            let g_b_flag = "2"
 
        on action outpage
            let g_b_flag = "3"
 
        on action stockpage
            let g_b_flag = "4" 
        
        on action accept
            let g_action_choice="accept"
            exit dialog

        on action cancel
            let g_action_choice="exit"
            exit dialog

        on action exit
            let g_action_choice="exit"
            exit dialog

        on action qbe_select
            call cl_qbe_select()

        on action qbe_save
            call cl_qbe_save()
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        
        on action about
            call cl_about()
        
        on action controlg
            call cl_cmdask()
        
        on action help
            call cl_show_help()

    end dialog

    if int_flag or g_action_choice = "exit" then    #mod-4b0238 add 'exit'
        return
    end if
end function
# main
function cimq023() 
    call cimq023_menu()
end function
# 菜单
function cimq023_menu()
    define l_file string

    while true
        case g_b_flag
            when '1'
                # 工单明细
                call cimq023_bp1("G")
            when '2'
                # 工单备料明细
                call cimq023_bp2("G")
            when '3'
                call cimq023_bp3("G")
            when '4'
                call cimq023_bp4("G")
            otherwise
                call cimq023_bp1("G")
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
                    call cimq023_q()
                end if
            
            when "exporttoexcel"
                # 导出excel
                if cl_chk_act_auth() then
                    let w = ui.window.getcurrent()
                    let f = w.getform()
                    #call cl_expexcel_display("s_total",base.typeinfo.create(g_total_excel),
                    #                         "s_sfb",base.typeinfo.create(g_sfb_excel),
                    #                         "s_oga",base.typeinfo.create(g_oga_excel),
                    #                         "s_sfu",base.typeinfo.create(g_sfu_excel))
                    call cl_download_by_explorer(
                        cl_expexcel5(
                            "s_total",base.typeinfo.create(g_total_excel),
                            "s_sfb",base.typeinfo.create(g_sfb_excel),
                            "s_oga",base.typeinfo.create(g_oga_excel),
                            "s_sfu",base.typeinfo.create(g_sfu_excel),
                            "",null)) #darcy:2024/01/18 
                end if
            # TODO:功能按钮 s---

            # TODO:功能按钮 e---
        end case
    end while
end function
# 查询
function cimq023_q()
    let g_b_flag = "1"
    let g_rec_b = 0

    clear form
    let flag_total = 'N'
    let flag_sfb = 'N'
    let flag_oga = 'N'
    let flag_sfu = 'N'

    display g_rec_b to cn2
    call cl_opmsg('q')

    MESSAGE ""
    display '   ' to formonly.cnt

    call cimq023_cs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call cimq023_show()
    end if
    message ""
end function

# 查询
function cimq023_show()
    let g_b_flag = '1'
    call cimq023_fill(g_wc1,g_wc2)
end function
function cimq023_fill(p_wc1,p_wc2)
    # ---
    define p_wc1 string
    define p_wc2 string
    define l_sql string
    # --- 

    delete from SampleInOutItem_file
    delete from SampleInOut_temp

    let p_wc2 = cl_replace_str(p_wc1,"oga03","tlf19")

    # Step1. 将日期区间内的出货料号抓取到SampleInOutItem_file表中
    let l_sql = " insert into SampleInOutItem_file (item,fpc) ",
                " select substr(tlf01,0,6) ima01,case when substr(tlf01,7,1) in ('A','B','C') then 'N' else 'Y' end ",
                "   from tlf_file,ima_file ",
                "  where tlf13 = 'axmt620' ",
                "    and tlf06 between ? and ? ",
                "    and (tlf01 like '%S' or tlf01 like '%F')  ",
                "    and tlf01 not like 'ZJ%' and tlf01 not like 'TE%' ",
                "    and tlf01 = ima01  ",
                "    and ima02 not like '%zjb%' ",
                "    and ima02 not like '%zhuanjieban%' ",
                "    and ima02 not like '%转接板%' ",
                "    and ima02 not like '%测试%' ",
                "    and ",p_wc1 clipped," and ",p_wc2 clipped,
                "  group by substr(tlf01, 0, 6), substr(tlf01, 7, 1) "
    prepare cimq023_item from l_sql
    execute cimq023_item using tm.begindate,tm.enddate
    if sqlca.sqlcode then
        call cl_err('期间内出货料号收集',sqlca.sqlcode,1)
        return
    end if

    # Step2. 出货数量
    insert into SampleInOut_temp (kind,item,ordno,seq,amt,dat)
    select 'out' kind,tlf01,tlf905,tlf906,tlf10*tlf12,tlf06
      from tlf_file,SampleInOutItem_file
     where tlf01 like item||'%'
       and tlf13 = 'axmt620'
       and (tlf01 like '%S' or tlf01 like '%F')
       and tlf902 != 'ZTC'
       -- 不管是否是组装出货
       -- and substr(tlf01,7,1) in ('A','B','C')
    if sqlca.sqlcode then
        call cl_err('出货数量计算',sqlca.sqlcode,1)
        return
    end if

    # Step3. 投料数量
    insert into SampleInOut_temp (kind,item,ordno,seq,amt,dat)
    select 'in',sfb05,sfb01,0 seq,sfb081,sfb81
      from sfb_file,SampleInOutItem_file
     where sfb05 like item||'%'
       and (sfb05 like '%S' or sfb05 like '%F')
       and substr(sfb05,7,1) not in ('A','B','C')
       and sfb87 = 'Y' and sfb081 <> 0 
    if sqlca.sqlcode then
        call cl_err('投料数量计算',sqlca.sqlcode,1)
        return
    end if
    # Step3.1 考虑不同料号领光板的问题
    insert into SampleInOut_temp (kind,item,ordno,seq,amt,dat)
    select 'in', sfb05, sfb01, 0 seq, sfa06, sfb81
      from sfb_file, sfa_file
     where sfb01 = sfa01
       and sfb87 = 'Y'
       and sfa03 not like '%.%'
       and sfa03 not like '%-%'
       and substr(sfb05, 1, 6) <> substr(sfa03, 1, 6)
       and (sfb05 like '%S' or sfb05 like '%F')
       and sfa06 <> 0
    if sqlca.sqlcode then
        call cl_err('投料数量计算',sqlca.sqlcode,1)
        return
    end if

    
    # Step4. 入库数量
    # Strp4.1 组装入库
    insert into SampleInOut_temp (kind,item,ordno,seq,amt,dat)
    select 'stock' kind,tlf01,tlf905,tlf906,tlf10*tlf12,tlf06
      from tlf_file,SampleInOutItem_file
     where tlf01 like item||'%'
       and tlf13 = 'asft6231'
       and (tlf01 like '%S' or tlf01 like '%F')
       and substr(tlf01,7,1) in ('A','B','C')
       and tlf10*tlf12 <> 0
    if sqlca.sqlcode then
        call cl_err('入库数量计算',sqlca.sqlcode,1)
        return
    end if
    # Step4.2 光板入库
    insert into SampleInOut_temp (kind,item,ordno,seq,amt,dat)
    select 'stock' kind,tlf01,tlf905,tlf906,tlf10*tlf12,tlf06
      from tlf_file,SampleInOutItem_file
     where tlf01 like item||'%'
       and tlf13 = 'asft6231'
       and (tlf01 like '%S' or tlf01 like '%F')
       --and substr(tlf01,7,1) in ('A','B','C')
       and tlf10*tlf12 <> 0 and fpc = 'Y'
    if sqlca.sqlcode then
        call cl_err('入库数量计算',sqlca.sqlcode,1)
        return
    end if

    # Step5. 更新各字段总数量
    let l_sql = "
    merge into SampleInOutItem_file a
    using (select substr(item,1,6) item,sum(amt) amt,min(dat) firstout,max(dat) lastout
             from SampleInOut_temp where kind = 'out' group by substr(item,1,6) ) b
       on (a.item = b.item)
     when matched then update set a.outamt=b.amt, a.firstout=b.firstout, a.lastout=b.lastout"
    prepare cimq023_merge1 from l_sql
    execute cimq023_merge1
    if sqlca.sqlcode then
        call cl_err('更新出货信息',sqlca.sqlcode,1)
        return
    end if
    
    let l_sql = "
    merge into SampleInOutItem_file a
    using (select substr(item,1,6) item,sum(amt) amt
             from SampleInOut_temp where kind = 'stock' group by substr(item,1,6) ) b
       on (a.item = b.item)
     when matched then update set a.stockamt=b.amt"
    prepare cimq023_merge2 from l_sql
    execute cimq023_merge2
    if sqlca.sqlcode then
        call cl_err('更新入库信息',sqlca.sqlcode,1)
        return
    end if
    
    let l_sql = "
    merge into SampleInOutItem_file a
    using (select substr(item,1,6) item,sum(amt) amt,min(dat) firstin
             from SampleInOut_temp where kind = 'in' group by substr(item,1,6) ) b
       on (a.item = b.item)
     when matched then update set a.inamt=b.amt,a.firstin=b.firstin"
    prepare cimq023_merge3 from l_sql
    execute cimq023_merge3
    if sqlca.sqlcode then
        call cl_err('更新投料信息',sqlca.sqlcode,1)
        return
    end if


    declare cimq023_total_fill cursor for
        select item,inamt,stockamt,
               (case inamt when 0 then 0 else stockamt/inamt end)*100 stockpercent,
               outamt,(case inamt when 0 then 0 else outamt/inamt end)*100 outpercent,
               firstin,firstout,lastout
          from SampleInOutItem_file order by item
    call g_total.clear()
    call g_total_excel.clear()
    let g_cnt = 1
    foreach cimq023_total_fill into g_total_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cimq023_total_fill',sqlca.sqlcode,1)
            return
        end if
        if g_cnt <= 10000 then
            let g_total[g_cnt].* = g_total_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_total_excel.deleteElement(g_cnt)
    
    declare cimq023_in_fill cursor for
        select ordno,dat,item,amt from SampleInOut_temp
         where kind = 'in' order by item,dat,ordno
    call g_sfb.clear()
    call g_sfb_excel.clear()
    let g_cnt = 1
    foreach cimq023_in_fill into g_sfb_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cimq023_in_fill',sqlca.sqlcode,1)
            return
        end if
        if g_cnt <= 10000 then
            let g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfb_excel.deleteElement(g_cnt)

    declare cimq023_out_fill cursor for
        select ordno,dat,seq,item,amt from SampleInOut_temp
         where kind = 'out' order by item,dat,ordno,seq
    call g_oga.clear()
    call g_oga_excel.clear()
    let g_cnt = 1
    foreach cimq023_out_fill into g_oga_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cimq023_out_fill',sqlca.sqlcode,1)
            return
        end if
        if g_cnt <= 10000 then
            let g_oga[g_cnt].* = g_oga_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_oga_excel.deleteElement(g_cnt)
    
    declare cimq023_stock_fill cursor for
        select ordno,dat,seq,item,amt from SampleInOut_temp
         where kind = 'stock' order by item,dat,ordno,seq
    call g_sfu.clear()
    call g_sfu_excel.clear()
    let g_cnt = 1
    foreach cimq023_stock_fill into g_sfu_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cimq023_stock_fill',sqlca.sqlcode,1)
            return
        end if
        if g_cnt <= 10000 then
            let g_sfu[g_cnt].* = g_sfu_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfu_excel.deleteElement(g_cnt)
        
end function

function cimq023_bp1(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " " 

    call cl_set_act_visible("accept,cancel", false)
    display g_total.getLength() to cn2

    display array g_total to s_total.*

        before display
            let l_ac = arr_curr()
            display l_ac to formonly.cnt
        on action help
            let g_action_choice="help"
            exit display
        on action exit
            let g_action_choice="exit"
            exit display
        on action controlg
            let g_action_choice="controlg"
            exit display
        on action query
            let g_action_choice="query"
            exit display 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
        on action close
            let g_action_choice = 'close'
            exit display 

        on action inpage
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            exit display
        on action outpage
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit display
        on action stockpage
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            exit display

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        
        # TODO：公共按钮 s---
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function
function cimq023_bp2(p_ud)
    define   p_ud   like type_file.chr1
    define   l_wc   string
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    display g_sfb.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    display array g_sfb to s_sfb.*

        before display
            let l_ac = arr_curr()
            display l_ac to cnt

        on action help
            let g_action_choice="help"
            exit display
        on action exit
            let g_action_choice="exit"
            exit display
        on action controlg
            let g_action_choice="controlg"
            exit display
        on action query
            let g_action_choice="query"
            exit display 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
        on action close
            let g_action_choice = 'close'
            exit display
            
        on action totalpage
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit display
        on action outpage
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit display
        on action stockpage
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            exit display

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        # TODO：公共按钮 e---

    end display
    call cl_set_act_visible("accept,cancel", true)
end function
function cimq023_bp3(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    display g_oga.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)
    
    display array g_oga to s_oga.*

        before display
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit display
        on action exit
            let g_action_choice="exit"
            exit display
        on action controlg
            let g_action_choice="controlg"
            exit display
        on action query
            let g_action_choice="query"
            exit display 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
        on action close
            let g_action_choice = 'close'
            exit display
            
        on action totalpage
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit display
        on action inpage
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            exit display
        on action stockpage
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            exit display 

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function
function cimq023_bp4(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    display g_sfu.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    display array g_sfu to s_sfu.*

        before display
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit display
        on action exit
            let g_action_choice="exit"
            exit display
        on action controlg
            let g_action_choice="controlg"
            exit display
        on action query
            let g_action_choice="query"
            exit display 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
        on action close
            let g_action_choice = 'close'
            exit display
            
        on action totalpage
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit display
        on action inpage
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            exit display
        on action outpage
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit display

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function
