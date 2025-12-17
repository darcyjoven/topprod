# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: cimq024.4gl
# Descriptions...: 呆滞报表
# Date & Author..: darcy:2025/11/17

database ds
GLOBALS "../../config/top.global"
# ---
type img        record
    img01           like img_file.img01,
    ima02           like ima_file.ima02,
    ima021          like ima_file.ima021,
    img02           like img_file.img02,
    imd02           like imd_file.imd02,
    img03           like img_file.img03,
    img04           like img_file.img04,
    img09           like img_file.img09,
    img10           like img_file.img10,
    img37           like img_file.img37,
    stale           integer,
    stale_type      integer,
    img18           like img_file.img18,
    ccc23           like ccc_file.ccc23,
    amt             decimal(20,2),
    remark          varchar(200)
end record
type img02      record
    img02_1        varchar(100),
    col1_1       decimal(20,2),
    col2_1       decimal(20,2),
    col3_1       decimal(20,2),
    col4_1       decimal(20,2),
    col5_1       decimal(20,2),
    col6_1       decimal(20,2),
    col7_1       decimal(20,2),
    col8_1       decimal(20,2),
    col9_1       decimal(20,2),
    col10_1       decimal(20,2)
end record
type materials      record
    img02_2        varchar(100),
    col1_2       decimal(20,2),
    col2_2       decimal(20,2),
    col3_2       decimal(20,2),
    col4_2       decimal(20,2),
    col5_2       decimal(20,2),
    col6_2       decimal(20,2),
    col7_2       decimal(20,2),
    col8_2       decimal(20,2),
    col9_2       decimal(20,2),
    col10_2       decimal(20,2)
end record
type device      record
    img02_3        varchar(100),
    col1_3       decimal(20,2),
    col2_3       decimal(20,2),
    col3_3       decimal(20,2),
    col4_3       decimal(20,2),
    col5_3       decimal(20,2),
    col6_3       decimal(20,2),
    col7_3       decimal(20,2),
    col8_3       decimal(20,2),
    col9_3       decimal(20,2),
    col10_3       decimal(20,2)
end record
type product      record
    img02_4        varchar(100),
    col1_4       decimal(20,2),
    col2_4       decimal(20,2),
    col3_4       decimal(20,2),
    col4_4       decimal(20,2),
    col5_4       decimal(20,2),
    col6_4       decimal(20,2),
    col7_4       decimal(20,2),
    col8_4       decimal(20,2),
    col9_4       decimal(20,2),
    col10_4       decimal(20,2)
end record
type fpcpage      record
    img02_5        varchar(100),
    col1_5       decimal(20,2),
    col2_5       decimal(20,2),
    col3_5       decimal(20,2),
    col4_5       decimal(20,2),
    col5_5       decimal(20,2),
    col6_5       decimal(20,2),
    col7_5       decimal(20,2),
    col8_5       decimal(20,2),
    col9_5       decimal(20,2),
    col10_5       decimal(20,2)
end record
type supppart      record
    img02_6       varchar(100),
    col1_6      decimal(20,2),
    col2_6      decimal(20,2),
    col3_6      decimal(20,2),
    col4_6      decimal(20,2),
    col5_6      decimal(20,2),
    col6_6      decimal(20,2),
    col7_6      decimal(20,2),
    col8_6      decimal(20,2),
    col9_6      decimal(20,2),
    col10_6      decimal(20,2)
end record
type tc_imi record 
    tc_imi01          varchar(40),
    tc_imi02          date,
    tc_imi03          varchar(20),
    tc_imi04          varchar(10),
    tc_imi05          varchar(1),
    tc_imi06          varchar(1)
end record
# ---

# ---
# 主资料
define g_tc_imi   ,g_tc_imi_t           tc_imi
define g_img      ,g_img_excel          dynamic array of    img
define g_img02    ,g_img02_excel        dynamic array of    img02
define g_materials,g_materials_excel    dynamic array of    materials
define g_device   ,g_device_excel       dynamic array of    device
define g_product  ,g_product_excel      dynamic array of    product
define g_fpcpage  ,g_fpcpage_excel      dynamic array of    fpcpage
define g_supppart ,g_supppart_excel     dynamic array of    supppart
# ---

# ---
define g_b_flag integer
define g_rec_b integer # 单身总比数
define g_cnt,g_curs_index,g_row_count integer #总笔数
define l_ac,l_ac_t,g_jump,g_no_ask integer #单身当前笔数
# ---

# ---
# 工单条件和lot条件
define g_wc1,g_wc2,g_sql,g_msg string
define g_bg_job varchar(1)
# ---

# ---
define flag_img         like type_file.chr1
define flag_img02       like type_file.chr1
define flag_materials   like type_file.chr1
define flag_device      like type_file.chr1 
define flag_product     like type_file.chr1
define flag_fpcpage     like type_file.chr1 
define flag_supppart    like type_file.chr1 
# ---

# ---
define g_col dynamic array of integer
# ---

MAIN
    define p_row,p_col   like type_file.num5          #no.fun-680121 smallint
    options                               #改變一些系統預設值
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CIM")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time #no.fun-b30211 
    open window cimq024 at p_row,p_col with form "cim/42f/cimq024"
            attribute (style = g_win_style clipped) #no.fun-580092 hcn
        
    call cl_ui_init()
    -- 字段名称初始化
    call cimq024_col_init()

    call cimq024()

    close window cimq024                 #結束畫面
    call  cl_used(g_prog,g_time,2) returning g_time 
END MAIN

# declear
function cimq024_curs()
    # ---
    define l_sql   string
    # ---
    if g_bg_job = 'N' or cl_null(g_bg_job) then
        call cimq024_cs()
    end if
    let g_bg_job = 'N'
    # --- 

    let g_sql = "select unique tc_imi01 from tc_imi_file ",
                " where ",g_wc1 clipped,
                " order by tc_imi01"
    prepare cimq024_prepare from g_sql
    declare cimq024_curs
       scroll cursor with hold for cimq024_prepare

    let g_sql= "select count(unique tc_imi01) from tc_imi_file where ",g_wc1 clipped
    prepare cimq024_precount from g_sql
    declare cimq024_count cursor for cimq024_precount

end function

# 查询条件
function cimq024_cs()
    clear form
    let g_action_choice=" "

    dialog
        construct g_wc1 on tc_imi01,tc_imi02,tc_imi04,tc_imi05,tc_imi06 from tc_imi01,tc_imi02,tc_imi04,tc_imi05,tc_imi06
            before construct
        end construct

        construct g_wc2 on img01,ima02,ima021,img03,img04,img37,img18,ccc23,amt,remark from img01,ima02,ima021,img03,img04,img37,img18,ccc23,amt,remark
            before construct
        end construct

        on action controlp
            # 开窗
        on action img       let g_b_flag = "1"
        on action img02     let g_b_flag = "2"
        on action materials let g_b_flag = "3"
        on action device    let g_b_flag = "4"
        on action product   let g_b_flag = "5" 
        on action fpcpage   let g_b_flag = "6" 
        on action supppart  let g_b_flag = "7" 
        
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
function cimq024() 
    call cimq024_menu()
end function
# 菜单
function cimq024_menu()
    define l_file string

    call cl_navigator_setting(g_curs_index, g_row_count)

    while true
        case g_b_flag
            when '1'
                call cimq024_bp1("G")
            when '2'
                call cimq024_bp2("G")
            when '3'
                call cimq024_bp3("G")
            when '4'
                call cimq024_bp4("G")
            when '5'
                call cimq024_bp5("G")
            when '6'
                call cimq024_bp6("G")
            when '7'
                call cimq024_bp7("G")
            otherwise
                call cimq024_bp1("G")
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
                    call cimq024_q()
                end if
            
            when "exporttoexcel"
                # 导出excel
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(
                        cl_expexcel10(
                            "s_img",        base.typeinfo.create(g_img_excel),
                            "s_img02",      base.typeinfo.create(g_img02_excel), 
                            "s_materials",  base.typeinfo.create(g_materials_excel),
                            "s_device",     base.typeinfo.create(g_device_excel), 
                            "s_product",    base.typeinfo.create(g_product_excel),
                            "s_fpc",        base.typeinfo.create(g_fpcpage_excel),
                            "s_supppart",   base.typeinfo.create(g_supppart_excel),
                            "",null,
                            "",null,
                            "",null
                        )
                    )
                end if
            # TODO:功能按钮 s---
            when "generate"
                if cl_chk_act_auth() then
                    call cimq024_generate()
                end if
            # TODO:功能按钮 e---
        end case
    end while
end function
# 查询
function cimq024_q()
    let g_b_flag = "1"
    let g_rec_b = 0

    CALL cl_navigator_setting( g_curs_index, g_row_count )

    clear form
    let flag_img        = "N"
    let flag_img02      = "N"
    let flag_materials  = "N"
    let flag_device     = "N"
    let flag_product    = "N"
    let flag_fpcpage    = "N"
    let flag_supppart   = "N"

    call cl_opmsg('q')

    MESSAGE ""
    display '   ' to formonly.cnt

    call cimq024_curs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    open cimq024_count
    fetch cimq024_count into g_row_count
    display g_row_count to formonly.cnt
    open cimq024_curs

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call cimq024_fetch('F')
    end if
    message ""
end function

# 查询
function cimq024_show()
    let g_b_flag = '1'

    display g_curs_index to curr

    display by name g_tc_imi.*
    call cimq024_fill(g_wc2)
end function


function cimq024_fill(p_wc)
    # ---
    define p_wc string
    define i    integer
    # --- 
    -- g_tc_imi   ,g_tc_imi_t       
    -- g_img      ,g_img_excel      
    -- g_img02    ,g_img02_excel    
    -- g_materials,g_materials_excel
    -- g_device   ,g_device_excel   
    -- g_product  ,g_product_excel  
    -- g_fpcpage  ,g_fpcpage_excel  
    -- g_supppart ,g_supppart_excel 

    #Step1. 库存资料
    let g_sql = " select img01,ima02,ima021,img02,imd02,img03,img04,img09,img10,img37,trunc(sysdate)-img37 stale ,0 stale_type,img18,ccc23,amt,remark ",
                "   from tc_imi_file,imd_file where tc_imi01 =  '",g_tc_imi.tc_imi01,"'",
                "    and img02 = imd01 ",
                "    and (img02 not in ('S001','S007','S010') or (img01 not like 'KG%' and img01 not like 'KH%'))",
                "    and ",p_wc clipped,
                " order by img01,img02,img03,img04"
    prepare cimq024_fill1 from g_sql
    declare cimq024_p1 cursor for cimq024_fill1

    let g_cnt = 1
    call g_img.clear()
    call g_img_excel.clear()

    foreach cimq024_p1 into g_img_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq024_p1",sqlca.sqlcode,1)
            exit foreach
        end if

        for i = 1 to g_col.getLength()
            if g_img_excel[g_cnt].stale <= g_col[i] then
                let g_img_excel[g_cnt].stale_type = i
                exit for
            end if
        end for

        if g_cnt <= 10000 then
            let g_img[g_cnt].* = g_img_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_img_excel.deleteElement(g_cnt)

    call cimq024_process(g_tc_imi.tc_imi01)

    #Step2. 仓库汇总
    let g_sql = " select img02,col01,col02,col03,col04,col05,col06,col07,col08,col09,col10",
                "   from cimq024_tmp where typ = ? ",
                "    and ",p_wc clipped,
                "  order by seq,img02 "
    prepare cimq024_fill2 from g_sql
    declare cimq024_p2 cursor for cimq024_fill2

    let g_cnt = 1
    call g_img02.clear()
    call g_img02_excel.clear()

    foreach cimq024_p2 using '1' into g_img02_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq024_p1",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= 10000 then
            let g_img02[g_cnt].* = g_img02_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_img02_excel.deleteElement(g_cnt)

    #Step3. 原材料
    let g_cnt = 1
    call g_materials.clear()
    call g_materials_excel.clear()

    foreach cimq024_p2 using '2' into g_materials_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq024_p1",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= 10000 then
            let g_materials[g_cnt].* = g_materials_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_materials_excel.deleteElement(g_cnt)

    #Step4. 器件
    let g_cnt = 1
    call g_device.clear()
    call g_device_excel.clear()

    foreach cimq024_p2 using '3' into g_device_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq024_p1",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= 10000 then
            let g_device[g_cnt].* = g_device_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_device_excel.deleteElement(g_cnt)
    #Step5. 成品
    let g_cnt = 1
    call g_product.clear()
    call g_product_excel.clear()

    foreach cimq024_p2 using '4' into g_product_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq024_p1",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= 10000 then
            let g_product[g_cnt].* = g_product_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_product_excel.deleteElement(g_cnt)
    #Step6. 光板
    let g_cnt = 1
    call g_fpcpage.clear()
    call g_fpcpage_excel.clear()

    foreach cimq024_p2 using '5' into g_fpcpage_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq024_p1",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= 10000 then
            let g_fpcpage[g_cnt].* = g_fpcpage_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_fpcpage_excel.deleteElement(g_cnt)
    #Step7. 客供器件
    let g_cnt = 1
    call g_supppart.clear()
    call g_supppart_excel.clear()

    foreach cimq024_p2 using '6' into g_supppart_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("cimq024_p1",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= 10000 then
            let g_supppart[g_cnt].* = g_supppart_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_supppart_excel.deleteElement(g_cnt)
    
end function

function cimq024_fetch(p_flag)
    define p_flag   varchar(1)
 
    case p_flag
        when 'N' fetch next     cimq024_curs into g_tc_imi.tc_imi01
        when 'P' fetch previous cimq024_curs into g_tc_imi.tc_imi01
        when 'F' fetch first    cimq024_curs into g_tc_imi.tc_imi01
        when 'L' fetch last     cimq024_curs into g_tc_imi.tc_imi01
        when '/'
            if (not g_no_ask) then   #fun-6a0080
                call cl_getmsg('fetch',g_lang) returning g_msg
                let int_flag = 0

                prompt g_msg clipped,': ' for g_jump
                    
                    on idle g_idle_seconds
                        call cl_on_idle()
 
                    on action about
                        call cl_about()
 
                    on action help
                        call cl_show_help()
                
                    on action controlg
                        call cl_cmdask()

                end prompt
                if int_flag then
                    let int_flag = 0
                    return
                end if
            end if
            fetch absolute g_jump cimq024_curs into g_tc_imi.tc_imi01
            let g_no_ask = false
    end case
 
    if sqlca.sqlcode then
        call cl_err(g_tc_imi.tc_imi01,sqlca.sqlcode,0)
        initialize g_tc_imi.* to null
        let g_tc_imi.tc_imi01 = null
        return
    else
        case p_flag
            when 'F' let g_curs_index = 1
            when 'P' let g_curs_index = g_curs_index - 1
            when 'N' let g_curs_index = g_curs_index + 1
            when 'L' let g_curs_index = g_row_count
            when '/' let g_curs_index = g_jump
        end case
    
        call cl_navigator_setting(g_curs_index, g_row_count)
    end if
 
   select unique tc_imi01,tc_imi02,tc_imi03,tc_imi04,tc_imi05,tc_imi06
     into g_tc_imi.* from tc_imi_file where tc_imi01 = g_tc_imi.tc_imi01
 
   if sqlca.sqlcode then
      call cl_err3("sel","tc_imi_file",g_tc_imi.tc_imi01,"",sqlca.sqlcode,"","",0)    #no.fun-660081
   else       
      call cimq024_show() 
   end if
 
end function

function cimq024_bp1(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " " 

    call cl_set_act_visible("accept,cancel", false) 

    display array g_img to s_img.*

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

        -- on action img       let g_action_choice = 'fill' let g_b_flag = '1' exit display
        on action img02     let g_action_choice = 'fill' let g_b_flag = '2' exit display
        on action materials let g_action_choice = 'fill' let g_b_flag = '3' exit display
        on action device    let g_action_choice = 'fill' let g_b_flag = '4' exit display
        on action product   let g_action_choice = 'fill' let g_b_flag = '5' exit display
        on action fpcpage   let g_action_choice = 'fill' let g_b_flag = '6' exit display
        on action supppart  let g_action_choice = 'fill' let g_b_flag = '7' exit display

        -- fetch
        on action first call cimq024_fetch('F') accept display
        on action previous call cimq024_fetch('P') accept display
        on action jump call cimq024_fetch('/') accept display
        on action next call cimq024_fetch('N') accept display
        on action last call cimq024_fetch('L') accept display
        -- fetch

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        
        # TODO：公共按钮 s---
        on action generate let g_action_choice = 'generate' exit display
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function
function cimq024_bp2(p_ud)
    define   p_ud   like type_file.chr1
    define   l_wc   string
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call cl_set_act_visible("accept,cancel", false)

    display array g_img02 to s_img02.*

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
            
        on action img       let g_action_choice = 'fill' let g_b_flag = '1' exit display
        -- on action img02     let g_action_choice = 'fill' let g_b_flag = '2' exit display
        on action materials let g_action_choice = 'fill' let g_b_flag = '3' exit display
        on action device    let g_action_choice = 'fill' let g_b_flag = '4' exit display
        on action product   let g_action_choice = 'fill' let g_b_flag = '5' exit display
        on action fpcpage   let g_action_choice = 'fill' let g_b_flag = '6' exit display
        on action supppart  let g_action_choice = 'fill' let g_b_flag = '7' exit display

        -- fetch
        on action first call cimq024_fetch('F') accept display
        on action previous call cimq024_fetch('P') accept display
        on action jump call cimq024_fetch('/') accept display
        on action next call cimq024_fetch('N') accept display
        on action last call cimq024_fetch('L') accept display
        -- fetch

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action generate let g_action_choice = 'generate' exit display
        # TODO：公共按钮 e---

    end display
    call cl_set_act_visible("accept,cancel", true)
end function
function cimq024_bp3(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call cl_set_act_visible("accept,cancel", false)
    
    display array g_materials to s_materials.*

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
            
        on action img       let g_action_choice = 'fill' let g_b_flag = '1' exit display
        on action img02     let g_action_choice = 'fill' let g_b_flag = '2' exit display
        -- on action materials let g_action_choice = 'fill' let g_b_flag = '3' exit display
        on action device    let g_action_choice = 'fill' let g_b_flag = '4' exit display
        on action product   let g_action_choice = 'fill' let g_b_flag = '5' exit display
        on action fpcpage   let g_action_choice = 'fill' let g_b_flag = '6' exit display
        on action supppart  let g_action_choice = 'fill' let g_b_flag = '7' exit display

        -- fetch
        on action first call cimq024_fetch('F') accept display
        on action previous call cimq024_fetch('P') accept display
        on action jump call cimq024_fetch('/') accept display
        on action next call cimq024_fetch('N') accept display
        on action last call cimq024_fetch('L') accept display
        -- fetch

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action generate let g_action_choice = 'generate' exit display
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function
function cimq024_bp4(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call cl_set_act_visible("accept,cancel", false)

    display array g_device to s_device.*

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
            
        on action img       let g_action_choice = 'fill' let g_b_flag = '1' exit display
        on action img02     let g_action_choice = 'fill' let g_b_flag = '2' exit display
        on action materials let g_action_choice = 'fill' let g_b_flag = '3' exit display
        -- on action device    let g_action_choice = 'fill' let g_b_flag = '4' exit display
        on action product   let g_action_choice = 'fill' let g_b_flag = '5' exit display
        on action fpcpage   let g_action_choice = 'fill' let g_b_flag = '6' exit display
        on action supppart  let g_action_choice = 'fill' let g_b_flag = '7' exit display

        -- fetch
        on action first call cimq024_fetch('F') accept display
        on action previous call cimq024_fetch('P') accept display
        on action jump call cimq024_fetch('/') accept display
        on action next call cimq024_fetch('N') accept display
        on action last call cimq024_fetch('L') accept display
        -- fetch

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action generate let g_action_choice = 'generate' exit display
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function

function cimq024_bp5(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call cl_set_act_visible("accept,cancel", false)

    display array g_product to s_product.*

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
            
        on action img       let g_action_choice = 'fill' let g_b_flag = '1' exit display
        on action img02     let g_action_choice = 'fill' let g_b_flag = '2' exit display
        on action materials let g_action_choice = 'fill' let g_b_flag = '3' exit display
        on action device    let g_action_choice = 'fill' let g_b_flag = '4' exit display
        -- on action product   let g_action_choice = 'fill' let g_b_flag = '5' exit display
        on action fpcpage   let g_action_choice = 'fill' let g_b_flag = '6' exit display
        on action supppart  let g_action_choice = 'fill' let g_b_flag = '7' exit display

        -- fetch
        on action first call cimq024_fetch('F') accept display
        on action previous call cimq024_fetch('P') accept display
        on action jump call cimq024_fetch('/') accept display
        on action next call cimq024_fetch('N') accept display
        on action last call cimq024_fetch('L') accept display
        -- fetch

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action generate let g_action_choice = 'generate' exit display
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function

function cimq024_bp6(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call cl_set_act_visible("accept,cancel", false)

    display array g_fpcpage to s_fpc.*

        before display
            let l_ac = arr_curr()

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
            
        on action img       let g_action_choice = 'fill' let g_b_flag = '1' exit display
        on action img02     let g_action_choice = 'fill' let g_b_flag = '2' exit display
        on action materials let g_action_choice = 'fill' let g_b_flag = '3' exit display
        on action device    let g_action_choice = 'fill' let g_b_flag = '4' exit display
        on action product   let g_action_choice = 'fill' let g_b_flag = '5' exit display
        -- on action fpcpage   let g_action_choice = 'fill' let g_b_flag = '6' exit display
        on action supppart  let g_action_choice = 'fill' let g_b_flag = '7' exit display

        -- fetch
        on action first call cimq024_fetch('F') accept display
        on action previous call cimq024_fetch('P') accept display
        on action jump call cimq024_fetch('/') accept display
        on action next call cimq024_fetch('N') accept display
        on action last call cimq024_fetch('L') accept display
        -- fetch

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action generate let g_action_choice = 'generate' exit display
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function

function cimq024_bp7(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call cl_set_act_visible("accept,cancel", false)

    display array g_supppart to s_supppart.*

        before display
            let l_ac = arr_curr()

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
            
        on action img       let g_action_choice = 'fill' let g_b_flag = '1' exit display
        on action img02     let g_action_choice = 'fill' let g_b_flag = '2' exit display
        on action materials let g_action_choice = 'fill' let g_b_flag = '3' exit display
        on action device    let g_action_choice = 'fill' let g_b_flag = '4' exit display
        on action product   let g_action_choice = 'fill' let g_b_flag = '5' exit display
        on action fpcpage   let g_action_choice = 'fill' let g_b_flag = '6' exit display
        -- on action supppart  let g_action_choice = 'fill' let g_b_flag = '7' exit display

        -- fetch
        on action first call cimq024_fetch('F') accept display
        on action previous call cimq024_fetch('P') accept display
        on action jump call cimq024_fetch('/') accept display
        on action next call cimq024_fetch('N') accept display
        on action last call cimq024_fetch('L') accept display
        -- fetch

        # TODO: 功能按钮 s---
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action generate let g_action_choice = 'generate' exit display
        # TODO：公共按钮 e---
    end display
    call cl_set_act_visible("accept,cancel", true)
end function

-- 产生库存明细资料
function cimq024_generate()
    define l_tc_imi     tc_imi
    define l_tc_imi01   varchar(40)
    define i,j,k,l      integer 

    if not cl_confirm("cim-041") then
        return
    end if

    # 判断今天是否是最后一天
    let l_tc_imi.tc_imi05 = iif( month(g_today) <> month(g_today + 1),"Y","N")

    # Step1. 确认今天是否已经存在资料，并提示会无效历史资料
    select count(*) into i from tc_imi_file 
     where tc_imi02 = g_today and tc_imi06 = 'Y'
    if i > 0 then
        if not cl_confirm("cim-043")  then
            return
        end if
    end if

    # Step2. 开启事务，无效历史资料
    begin work
    update tc_imi_file set tc_imi06 = 'N' where tc_imi02 = g_today and tc_imi06 = 'Y'

    # Step3. 插入到表tc_imi_file中
    let l_tc_imi.tc_imi01 = sfmt("%1%2%3",year(g_today) using '&&&&',month(g_today) using '&&',day(g_today) using '&&')
    select max(tc_imi01) into l_tc_imi01 from tc_imi_file
     where tc_imi02 = g_today
    
    if cl_null(l_tc_imi01) then
        let l_tc_imi.tc_imi01 = sfmt("%1%2%3%4",year(g_today) using '&&&&',month(g_today) using '&&',day(g_today) using '&&','001')
    else
        let l_tc_imi.tc_imi01 = l_tc_imi01 + 1 using '&&&&&&&&&&&'
    end if
    let l_tc_imi.tc_imi02 = g_today
    let l_tc_imi.tc_imi03 = current hour to second
    let l_tc_imi.tc_imi04 = g_user
    let l_tc_imi.tc_imi06 = 'Y'
 
    let g_sql = "insert into tc_imi_file (tc_imi01,tc_imi02,tc_imi03,tc_imi04,tc_imi05,tc_imi06, ",
                "       img01,ima02,ima021,img02,img03,img04,img09,img10,img37,img18,ccc23,amt,remark) ",
                "select '",l_tc_imi.tc_imi01,"','",l_tc_imi.tc_imi02,"','",l_tc_imi.tc_imi03,"','",l_tc_imi.tc_imi04,
                "','",l_tc_imi.tc_imi05,"','",l_tc_imi.tc_imi06,"', ",
                "       img01, ima02, ima021, img02, img03, img04, img09, img10, img37, img18,",
                "       case when ccc23 = 0 or ccc23 is null then ima53/ima44_fac else ccc23 end as ccc23,",
                "       img10 * (case when ccc23 = 0 or ccc23 is null then ima53/ima44_fac else ccc23 end) as amt, remark",
                " from img_file",
                " left join (select ccc01,nvl(ta_ccc23,ccc23) ccc23 from (",
                "                select ccc01, ccc23 from ccc_file",
                "             where (ccc02, ccc03) in (select case ccz02 when 1 then ccz01-1 else ccz01 end ,",
                "                                             case ccz02 when 1 then 12 else ccz02-1 end from ccz_file)  ",
                "               and ccc23 <> 0)",
                " left join ( select ta_ccc01, ta_ccc23a + ta_ccc23b + ta_ccc23c + ta_ccc23d ta_ccc23",
                "               from ta_ccp_file",
                "              where (ta_ccc02, ta_ccc03) in (select case ccz02 when 1 then ccz01-1 else ccz01 end ,",
                "                                                    case ccz02 when 1 then 12 else ccz02-1 end from ccz_file)",
                "                and ta_ccc23a + ta_ccc23b + ta_ccc23c + ta_ccc23d <> 0) on ta_ccc01 = ccc01 )",
                "       on ccc01 = img01",
	            " left join (select tc_sma02,tc_sma10||';'||tc_sma12||';'||tc_sma13 remark",
                "              from tc_sma_file  where tc_sma01 = 'csmi110') on tc_sma02 = img01",
                " left join ima_file on ima01 = img01",
                " where img10 <> 0"
    prepare cimq024_ins_tc_imi_file from g_sql
    execute cimq024_ins_tc_imi_file
    if sqlca.sqlcode then
        call cl_err("cimq024_ins_tc_imi_file",sqlca.sqlcode,1)
        rollback work
        return
    end if

    commit work

    # Step4. 生成完成,刷新当前资料
    if cl_confirm("cim-042") then
        let g_wc1 = sfmt(" tc_imi01 = '%1'",l_tc_imi.tc_imi01)
        let g_wc2 = " 1=1"
        let g_bg_job = 'Y'
        call cimq024_q()
        -- call cimq024_fill(g_wc2)
    end if

end function

-- 数据处理
-- 对tc_imi_file 资料进行处理，为各page的资料统计
function cimq024_process(p_tc_imi01)
    define p_tc_imi01                           varchar(20)
    define l_tc_imi02                           date
    define last_week,last_month                 varchar(20)
    define last_weekdat,last_monthdat           date
    define i,j,l_start,l_end                    integer
    define l_presql,l_sql                       string
    define l_typ varchar(1),
           l_seq decimal(15,3),
           l_seq1 decimal(15,3)
    define current_msg,last_week_msg,last_month_msg  varchar(100)
    define l_msg varchar(100)

    

    -- 建立临时表
    call cimq024_crt_tmp()

    -- 上周和上个月的资料
    select unique tc_imi02 into l_tc_imi02 from tc_imi_file where tc_imi01 = p_tc_imi01

    select unique tc_imi01,tc_imi02 into last_week,last_weekdat from tc_imi_file 
     where tc_imi02 = l_tc_imi02 - 7 and tc_imi06 = 'Y'

    select unique tc_imi01,tc_imi02 into last_month,last_monthdat from tc_imi_file 
     where tc_imi02 = mdy(month(l_tc_imi02),1,year(l_tc_imi02)) - 1 and tc_imi06 = 'Y'

    let current_msg = sfmt("本次总计(%1/%2/%3)",year(l_tc_imi02) using '&&&&',month(l_tc_imi02) using '&&',day(l_tc_imi02) using '&&')
    let last_week_msg = sfmt("上周总计(%1/%2/%3)",year(last_weekdat) using '&&&&',month(last_weekdat) using '&&',day(last_weekdat) using '&&')
    let last_month_msg = sfmt("上月总计(%1/%2/%3)",year(last_monthdat) using '&&&&',month(last_monthdat) using '&&',day(last_monthdat) using '&&')
    
    #Step1. 仓库汇总
    let g_sql = "select ?,img02_desc||imd02 img02,?,"

    for i = 1 to g_col.getlength()
        if i = 1 then let l_start = 0 else let l_start = g_col[i-1]+1 end if
        let l_end = g_col[i] 

        let g_sql = g_sql , " sum(case when trunc(sysdate) - img37 between ",l_start," and ",l_end," then amt else 0 end) ,"
    end for
    -- 最后一笔
    let g_sql = g_sql ,  " sum(case when trunc(sysdate) - img37 > ",g_col[g_col.getlength()]," then amt else 0 end) ,"
    -- 补上0值  
    for i = g_col.getlength() + 2 to 9  
        let g_sql = g_sql , " 0 ,"
    end for

    -- 最后汇总
    let g_sql = g_sql , " sum(amt) from (select tc_imi01,img01,img02,
                         case img02 when 'S011' then img02 || (case substr(img01, 10, 1) when 'R' then '-量产-' else '-样品-' end)
                                    when 'YP002' then img02|| (case when img02 like 'K.%' then '-器件-' else '-光板-'   end )
                          else img02 end img02_desc, img10, img37, amt from tc_imi_file),imd_file where imd01 = img02 and tc_imi01 = ? "
    -- 预制SQL
    let l_presql = g_sql
    let g_sql = "insert into cimq024_tmp ",g_sql,
                " and (img02 not in ('S001','S007','S010') or (img01 not like 'KG%' and img01 not like 'KH%'))", -- 扣除KG/KH料号
                " group by img02_desc,imd02"

    prepare cimq024_proc1 from g_sql
    let l_typ = '1'
    let l_seq = 3
    execute cimq024_proc1 using l_typ,l_seq,p_tc_imi01
    if sqlca.sqlcode then
        call cl_err("cimq024_proc1",sqlca.sqlcode,1)
        return
    end if

    -- 插入一笔汇总行
    let l_sql = "
    insert into cimq024_tmp
    select ?,?,?,sum(col01),sum(col02),sum(col03),sum(col04),sum(col05),sum(col06),sum(col07),sum(col08),sum(col09),sum(col10)
      from cimq024_tmp where typ = ? and seq = ? "
    prepare cimq024_sum from l_sql

    let l_seq1 = 3.1 
    execute cimq024_sum using l_typ,current_msg,l_seq1,l_typ,l_seq
    if sqlca.sqlcode then
        call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
        return
    end if

    -- K001 仓库匹配PCS汇总
    let l_sql = cl_replace_str(l_presql,"img10","img10 img10_1")
    let l_sql = cl_replace_str(l_sql,"amt","img10")
    let l_sql = "insert into cimq024_tmp ",l_sql," and img02 = 'K001' group by img02_desc,imd02"

    prepare cimq024_proc2 from l_sql
    execute cimq024_proc2 using l_typ,l_seq,p_tc_imi01
    if sqlca.sqlcode then
        call cl_err("cimq024_proc2",sqlca.sqlcode,1)
        return
    end if

    -- 上周和上月资料
    if not cl_null(last_week) then
        let l_seq = 2
        execute cimq024_proc1 using l_typ,l_seq,last_week
        if sqlca.sqlcode then
            call cl_err("cimq024_proc1",sqlca.sqlcode,1)
            return
        end if

        -- 插入一笔汇总行
        let l_seq1 = 2.1
        execute cimq024_sum using l_typ,last_week_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if

        -- K001 仓库匹配PCS汇总
        execute cimq024_proc2 using l_typ,l_seq,p_tc_imi01
        if sqlca.sqlcode then
            call cl_err("cimq024_proc2",sqlca.sqlcode,1)
            return
        end if
    end if

    if not cl_null(last_month) then
        let l_seq = 1
        execute cimq024_proc1 using l_typ,l_seq,last_month
        if sqlca.sqlcode then
            call cl_err("cimq024_proc1",sqlca.sqlcode,1)
            return
        end if

        -- 插入一笔汇总行
        let l_seq1= 3.1
        execute cimq024_sum using l_typ,last_month_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if

        -- K001 仓库匹配PCS汇总
        execute cimq024_proc2 using l_typ,l_seq,p_tc_imi01
        if sqlca.sqlcode then
            call cl_err("cimq024_proc2",sqlca.sqlcode,1)
            return
        end if
    end if

    #Step3. 原材料
    let l_typ = '2'
    let l_sql = "insert into cimq024_tmp ",l_presql,
                " and img02 in ('S001','S007','S010','YP001','YS001')",
                " and img01 like 'M.%' group by img02_desc,imd02"
    prepare cimq024_proc3 from l_sql
    let l_seq = 3
    execute cimq024_proc3 using l_typ,l_seq,p_tc_imi01
    if sqlca.sqlcode then
        call cl_err("cimq024_proc3",sqlca.sqlcode,1)
        return
    end if

    let l_seq1 = 3.1
    execute cimq024_sum using l_typ,current_msg,l_seq1,l_typ,l_seq
    if sqlca.sqlcode then
        call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
        return
    end if
    if not cl_null(last_week) then
        let l_seq = 2
        execute cimq024_proc3 using l_typ,l_seq,last_week
        if sqlca.sqlcode then
            call cl_err("cimq024_proc3",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 2.1
        execute cimq024_sum using l_typ,last_week_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if
    if not cl_null(last_month) then
        let l_seq = 1
        execute cimq024_proc3 using l_typ,l_seq,last_month
        if sqlca.sqlcode then
            call cl_err("cimq024_proc3",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 1.1
        execute cimq024_sum using l_typ,last_month_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if
    
    #Step4. 器件
    let l_typ = '3'
    let l_seq = 3
    let l_sql = "insert into cimq024_tmp ",l_presql,
                " and img02 in ('S003','S012','YP002')",
                " and img01 like 'E.%' group by img02_desc,imd02 "
    prepare cimq024_proc4 from l_sql
    execute cimq024_proc4 using l_typ,l_seq,p_tc_imi01
    if sqlca.sqlcode then
        call cl_err("cimq024_proc4",sqlca.sqlcode,1)
        return
    end if

    let l_seq1 = 3.1
    execute cimq024_sum using l_typ,current_msg,l_seq1,l_typ,l_seq
    if sqlca.sqlcode then
        call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
        return
    end if

    if not cl_null(last_week) then
        let l_seq = 2
        execute cimq024_proc4 using l_typ,l_seq,last_week
        if sqlca.sqlcode then
            call cl_err("cimq024_proc4",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 2.1
        execute cimq024_sum using l_typ,last_week_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if
    if not cl_null(last_month) then
        let l_seq = 1
        execute cimq024_proc4 using l_typ,l_seq,last_month
        if sqlca.sqlcode then
            call cl_err("cimq024_proc4",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 1.1
        execute cimq024_sum using l_typ,last_month_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if

    #Step5. 成品
    let l_typ = '4'
    let l_seq = 3
    let l_sql = "insert into cimq024_tmp ",l_presql,
                " and img02 in ('P001','S006','YP003','S009')",
                " and img01 not like '%.%' group by img02_desc,imd02"
    prepare cimq024_proc5 from l_sql
    execute cimq024_proc5 using l_typ,l_seq,p_tc_imi01
    if sqlca.sqlcode then
        call cl_err("cimq024_proc5",sqlca.sqlcode,1)
        return
    end if

    let l_seq1 = 3.1
    execute cimq024_sum using l_typ,current_msg,l_seq1,l_typ,l_seq
    if sqlca.sqlcode then
        call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
        return
    end if
    
    if not cl_null(last_week) then
        let l_seq = 2
        execute cimq024_proc5 using l_typ,l_seq,last_week
        if sqlca.sqlcode then
            call cl_err("cimq024_proc5",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 2.1
        execute cimq024_sum using l_typ,last_week_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if
    if not cl_null(last_month) then
        let l_seq = 1
        execute cimq024_proc5 using l_typ,l_seq,last_month
        if sqlca.sqlcode then
            call cl_err("cimq024_proc5",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 1.1
        execute cimq024_sum using l_typ,last_month_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if

    #Step6. 光板
    -- S011,要区分量产还是样品 
    let l_typ = '5'
    let l_seq = 3

    let l_sql = "insert into cimq024_tmp ",l_presql,
                " and img01 not like '%.%' and img02 in ('S005','S011','YP002') group by img02_desc,imd02"
    prepare cimq024_proc6 from l_sql
    execute cimq024_proc6 using l_typ,l_seq,p_tc_imi01
    if sqlca.sqlcode then
        call cl_err("cimq024_proc6",sqlca.sqlcode,1)
        return
    end if

    let l_seq1 = 3.1
    execute cimq024_sum using l_typ,current_msg,l_seq1,l_typ,l_seq
    if sqlca.sqlcode then
        call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
        return
    end if

    if not cl_null(last_week) then
        let l_seq = 2
        execute cimq024_proc6 using l_typ,l_seq,last_week
        if sqlca.sqlcode then
            call cl_err("cimq024_proc5",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 2.1
        execute cimq024_sum using l_typ,last_week_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if
    if not cl_null(last_month) then
        let l_seq = 1
        execute cimq024_proc6 using l_typ,l_seq,last_month
        if sqlca.sqlcode then
            call cl_err("cimq024_proc5",sqlca.sqlcode,1)
            return
        end if
        let l_seq1 = 1.1
        execute cimq024_sum using l_typ,last_month_msg,l_seq1,l_typ,l_seq
        if sqlca.sqlcode then
            call cl_err("ins cimq024_tmp",sqlca.sqlcode,1)
            return
        end if
    end if

    #Step7. 客供器件(PCS数量)
    let l_typ = '6'
    let l_seq = 3
    let l_sql = cl_replace_str(l_presql,'img10','img10 img10_1')
    let l_sql = cl_replace_str(l_sql,'amt','img10')
    let l_sql = "insert into cimq024_tmp ",l_sql,
                " and img02 = 'K001' ",
                " and img01 like 'K.%' group by img02_desc,imd02 "
    let l_msg = sfmt("客供件(%1/%2/%3)",year(l_tc_imi02) using '&&&&',month(l_tc_imi02) using '&&',day(l_tc_imi02) using '&&')
    let l_sql = cl_replace_str(l_sql,"img02_desc||imd02 img02"," ? img02")
    prepare cimq024_proc7 from l_sql
    execute cimq024_proc7 using l_typ,l_msg,l_seq,p_tc_imi01
    if sqlca.sqlcode then
        call cl_err("cimq024_proc7",sqlca.sqlcode,1)
        return
    end if

    if not cl_null(last_week) then
        let l_seq = 2
        let l_msg = sfmt("客供件(%1/%2/%3)",year(last_weekdat) using '&&&&',month(last_weekdat) using '&&',day(last_weekdat) using '&&') 
        prepare cimq024_proc8 from l_sql
        execute cimq024_proc8 using l_typ,l_msg,l_seq,last_week
        if sqlca.sqlcode then
            call cl_err("cimq024_proc8",sqlca.sqlcode,1)
            return
        end if
    end if

    if not cl_null(last_month) then
        let l_seq = 1
        let l_msg = sfmt("客供件(%1/%2/%3)",year(last_monthdat) using '&&&&',month(last_monthdat) using '&&',day(last_monthdat) using '&&')
        prepare cimq024_proc9 from l_sql
        execute cimq024_proc9 using l_typ,l_msg,l_seq,p_tc_imi01
        if sqlca.sqlcode then
            call cl_err("cimq024_proc9",sqlca.sqlcode,1)
            return
        end if
    end if

    #Step7. col10 h汇总
    update cimq024_tmp set col10 = col01+col02+col03+col04+col05+col06+col07+col08+col09
    if sqlca.sqlcode then
        call cl_err("upd cimq024_tmp",sqlca.sqlcode,1)
        return
    end if

end function

function cimq024_crt_tmp()
    whenever any error continue
        drop table cimq024_tmp
    whenever any error stop

    create temp table cimq024_tmp(
        typ     varchar(20),
        img02   varchar(100),
        seq     decimal(10,2),
        col01   decimal(15,3),
        col02   decimal(15,3),
        col03   decimal(15,3),
        col04   decimal(15,3),
        col05   decimal(15,3),
        col06   decimal(15,3),
        col07   decimal(15,3),
        col08   decimal(15,3),
        col09   decimal(15,3),
        col10   decimal(15,3)
    )
end function

-- 初始化字段信息
function cimq024_col_init()
    define i,j              integer
    define l_value,l_desc   string

    call g_col.clear()

    declare cimq024_col cursor for
     select tc_sma06 from tc_sma_file
      where tc_sma01 = 'csmi124' order by tc_sma03
    
    let i = 1
    foreach cimq024_col into g_col[i]
        if sqlca.sqlcode then
            call cl_err("cimq024_col",sqlca.sqlcode,1)
            exit foreach
        end if
        if i >= 8 then 
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_col.deleteElement(i)

    -- 字段名称设置
    for i = 1 to g_col.getlength()
        let l_value = l_value,sfmt('%1,',i)
        let l_desc = l_desc,sfmt("%1,",sfmt("%1~%2", -- 字段名称
                        iif(i==1,0,g_col[i-1]+1), -- 上一个col，或者0
                        g_col[i]))
        for j = 1 to 6
            call cl_set_comp_att_text(
                sfmt("col%1_%2",i,j), -- 字段编号
                    sfmt("%1~%2", -- 字段名称
                        iif(i==1,0,g_col[i-1]+1), -- 上一个col，或者0
                        g_col[i]))
        end for
    end for
    -- 最后一笔
    let l_value = l_value,'0'
    let l_desc = l_desc,sfmt("%1及以上",g_col[g_col.getlength()]+1)
    for j = 1 to 6
        call cl_set_comp_att_text(
            sfmt("col%1_%2",g_col.getlength()+1,j), -- 字段编号
                sfmt("%1及以上",g_col[g_col.getlength()]+1))
    end for

    -- 隐藏无用字段
    for i = g_col.getlength() + 2 to 9
        for j = 1 to 6
            call cl_set_comp_visible(sfmt("col%1_%2",i,j),false)
        end for
    end for

    call cl_set_combo_items("stable_type",l_value,l_desc)

end function
