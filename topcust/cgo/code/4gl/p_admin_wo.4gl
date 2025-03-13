# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: p_admin_wo.4gl
# Descriptions...: 管理员工单处理工具
# Date & Author..: 22/11/02 By darcy
import libmail

database ds
globals "../../config/top.global"
# ---
type sfb record
    checksfb like type_file.chr1,
    sfb01    like sfb_file.sfb01,     #工单单号
    sfb02    like sfb_file.sfb02,     #工单类型
    sfb81    like sfb_file.sfb81,     #开单日期
    sfb87    like sfb_file.sfb87,     #确认码
    sfb28    like sfb_file.sfb28,     #结案状态
    sfb38    like sfb_file.sfb38,     #结案日期
    sfb44    like sfb_file.sfb44,     #申请人
    gen02sfb like gen_file.gen02,  #
    sfb98    like sfb_file.sfb98,     #成本中心
    sfb05    like sfb_file.sfb05,     #产品编号
    sfb06    like sfb_file.sfb06,     #工艺编号
    sfb071   like sfb_file.sfb071,    # 有效日期
    ima02sfb like ima_file.ima02,     #品名
    ima021sfb like ima_file.ima021,    # 规格
    sfbud08  like sfb_file.sfbud08,   #  原工单量
    sfbud09  like sfb_file.sfbud09,   #  生产良率
    sfb08    like sfb_file.sfb08,     #生产数量
    sfbud07  like sfb_file.sfbud07,   #  PNL数量
    sfb081   like sfb_file.sfb081,    # 已发数量
    sfb09    like sfb_file.sfb09,     #完工数量
    sfb12    like sfb_file.sfb12,     #报废数量
    sfbud12  like sfb_file.sfbud12,   #  下版数量
    sfb22    like sfb_file.sfb22,     #订单单号
    sfb221   like sfb_file.sfb221,    # 订单项次
    sfb86    like sfb_file.sfb86,     #母工单号
    sfb89    like sfb_file.sfb89,     #上阶工单单号
    sfb99    like sfb_file.sfb99     #反工否
end record
type sfa record
    checksfa like type_file.chr1,
    sfa01     like sfa_file.sfa01,     #工单单号
    sfa03     like sfa_file.sfa03,     #发料料号
    ima02sfa  like ima_file.ima02,  #   品名
    ima021sfa like ima_file.ima021, #    规格
    sfa27     like sfa_file.sfa27,     #替代前料号
    sfa26     like sfa_file.sfa26,     #替代码
    sfa28     like sfa_file.sfa28,     #替代率
    sfa08     like sfa_file.sfa08,     #作业编号
    ima08sfa  like ima_file.ima08,  #   来源码
    sfa12     like sfa_file.sfa12,     #单位
    sfa11     like sfa_file.sfa11,     #来源特性
    sfa16     like sfa_file.sfa16,     #标准QPA
    sfa161    like sfa_file.sfa161,    # 实际QPA
    sfa05     like sfa_file.sfa05,     #应发数量
    sfa06     like sfa_file.sfa06,     #已发数量
    sfa065    like sfa_file.sfa065,    # 委外代买数量
    sfa062    like sfa_file.sfa062,    # 超领数量
    sfa063    like sfa_file.sfa063,    # 报废数量
    sfa064    like sfa_file.sfa064,    # 盘盈亏数量
    sfa100    like sfa_file.sfa100,    # 误差率
    sfaud08   like sfa_file.sfaud08    #  良率
end record
type sgm record
    checksgm like type_file.chr1,
    sgm01     like sgm_file.sgm01     , #Run     Card
    sgm02     like sgm_file.sgm02     , #工单编号
    sgm11     like sgm_file.sgm11     , #工序序号
    sgm03_par like sgm_file.sgm03_par , #    料件编号
    ima02sgm  like ima_file.ima02  , #
    ima021sgm like ima_file.ima021 , #
    sgm03     like sgm_file.sgm03     , #作业序号
    sgm04     like sgm_file.sgm04     , #作业编号
    sgm45     like sgm_file.sgm45     , #作业名称
    sgm05     like sgm_file.sgm05     , #机器编号
    sgm06     like sgm_file.sgm06     , #工作站
    sgm14     like sgm_file.sgm14     , #标准人工生产时间
    sgm15     like sgm_file.sgm15     , #标准机器设置时间
    sgm16     like sgm_file.sgm16     , #标准机器生产时间
    sgm65     like sgm_file.sgm65     , #标准转出量
    sgm301    like sgm_file.sgm301    , # 良品转入量
    sgm302    like sgm_file.sgm302    , # 重工转入量
    sgm303    like sgm_file.sgm303    , # 分割转入量
    sgm304    like sgm_file.sgm304    , # 合併转入量
    sgm311    like sgm_file.sgm311    , # 良品转出量
    sgm312    like sgm_file.sgm312    , # 重工转出
    sgm313    like sgm_file.sgm313    , # 当站报废量
    sgm314    like sgm_file.sgm314    , # 当站下线量（入库）
    sgm315    like sgm_file.sgm315    , # Bonus     Qty
    sgm316    like sgm_file.sgm316    , # 分割转出量
    sgm317    like sgm_file.sgm317    , # 合并转出量
    sgm321    like sgm_file.sgm321    , # 委外加工量
    sgm322    like sgm_file.sgm322    , # 委外完工量
    sgm52     like sgm_file.sgm52     , #委外否
    sgm53     like sgm_file.sgm53     , #PQC     否
    sgm54     like sgm_file.sgm54     , #Check     in     否
    ta_sgm01  like sgm_file.ta_sgm01, #   生产说明
    ta_sgm02  like sgm_file.ta_sgm02, #   使用工具
    ta_sgm03  like sgm_file.ta_sgm03, #   使用程序
    ta_sgm06  like sgm_file.ta_sgm06 #   报工否
end record
type tc_shb record
    checktc_shb  like type_file.chr1,
    tc_shb03     like tc_shb_file.tc_shb03, # LOT单号
    tc_shb06     like tc_shb_file.tc_shb06, # 作业序号
    tc_shb08     like tc_shb_file.tc_shb08, # 作业编号
    tc_shb01     like tc_shb_file.tc_shb01, # 开工/完工
    tc_shb02     like tc_shb_file.tc_shb02, # 报工单号
    tc_shb14     like tc_shb_file.tc_shb14, # 报工日期
    tc_shb15     like tc_shb_file.tc_shb15, # 报工时间
    tc_shb04     like tc_shb_file.tc_shb04, # 工单单号
    tc_shb07     like tc_shb_file.tc_shb07, # 工序序号
    tc_shb05     like tc_shb_file.tc_shb05, # 生产料号
    tc_shb16     like tc_shb_file.tc_shb16, # 生产单位
    ima02tc_shb  like ima_file.ima02, #    品名
    ima021tc_shb like ima_file.ima021, #     规格
    tc_shb09     like tc_shb_file.tc_shb09, # 工作站
    tc_shb10     like tc_shb_file.tc_shb10, # 委外否
    tc_shb11     like tc_shb_file.tc_shb11, # 报工人员
    gen02tc_shb  like gen_file.gen02, #    姓名
    tc_shb12     like tc_shb_file.tc_shb12, # 数量
    tc_shbud09   like tc_shb_file.tc_shbud09 , #   PNL数量
    tc_shb121    like tc_shb_file.tc_shb121, #    报废数量
    tc_shb122    like tc_shb_file.tc_shb122, #    反工数量
    tc_shb13     like tc_shb_file.tc_shb13, # 线班别
    tc_shb17     like tc_shb_file.tc_shb17 # 转移单号
end record
type tc_shb_2 record
    checktc_shb_2  like type_file.chr1,
    tc_shb03_2     like tc_shb_file.tc_shb03, # LOT单号
    tc_shb06_2     like tc_shb_file.tc_shb06, # 作业序号
    tc_shb08_2     like tc_shb_file.tc_shb08, # 作业编号
    tc_shb01_2     like tc_shb_file.tc_shb01, # 开工/完工
    tc_shb02_2     like tc_shb_file.tc_shb02, # 报工单号
    tc_shb14_2     like tc_shb_file.tc_shb14, # 报工日期
    tc_shb15_2     like tc_shb_file.tc_shb15, # 报工时间
    tc_shb04_2     like tc_shb_file.tc_shb04, # 工单单号
    tc_shb07_2     like tc_shb_file.tc_shb07, # 工序序号
    tc_shb05_2     like tc_shb_file.tc_shb05, # 生产料号
    tc_shb16_2     like tc_shb_file.tc_shb16, # 生产单位
    ima02tc_shb_2  like ima_file.ima02, #    品名
    ima021tc_shb_2 like ima_file.ima021, #     规格
    tc_shb09_2     like tc_shb_file.tc_shb09, # 工作站
    tc_shb10_2     like tc_shb_file.tc_shb10, # 委外否
    tc_shb11_2     like tc_shb_file.tc_shb11, # 报工人员
    gen02tc_shb_2  like gen_file.gen02, #    姓名
    tc_shb12_2     like tc_shb_file.tc_shb12, # 数量
    tc_shbud09_2   like tc_shb_file.tc_shbud09 , #   PNL数量
    tc_shb121_2    like tc_shb_file.tc_shb121, #    报废数量
    tc_shb122_2    like tc_shb_file.tc_shb122, #    反共数量
    tc_shb13_2     like tc_shb_file.tc_shb13, # 线班别
    tc_shb17_2     like tc_shb_file.tc_shb17 # 转移单号
end record
# ---
# ---
define   w    ui.Window
define   f    ui.Form
define   page om.DomNode
# ---

# ---
# 主资料
define g_sfb,g_sfb_excel dynamic array of sfb
define g_sfa,g_sfa_excel dynamic array of sfa
define g_sgm,g_sgm_excel dynamic array of sgm
define g_tc_shb,g_tc_shb_excel dynamic array of tc_shb
define g_tc_shb_2,g_tc_shb_2_excel dynamic array of tc_shb_2
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
# ---

# ---
define flag_sfb         like type_file.chr1
define flag_sfa         like type_file.chr1
define flag_sgm         like type_file.chr1
define flag_tc_shb      like type_file.chr1
define flag_tc_shb_2    like type_file.chr1
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
    open window p_admin_wo at p_row,p_col with form "azz/42f/p_admin_wo"
            attribute (style = g_win_style clipped) #no.fun-580092 hcn
        
    call cl_ui_init()

    call p_admin_wo()

    close window p_admin_wo                 #結束畫面
    call  cl_used(g_prog,g_time,2) returning g_time 
end main
# declear
function p_admin_wo_curs()
    # ---
    define l_sql   string
    # ---

    # ---
    # page1工单清单查询
    
    # ---

end function
# 查询条件
function p_admin_wo_cs()
    clear form
    let g_action_choice=" "

    dialog
        construct g_wc1 on sfb01,sfb05,sfb06 from sfb01_q,sfb05_q,sfb06_q
            before construct
        end construct
        construct g_wc2 on sgm01,sgm03,sgm04 from sgm01_q,sgm03_q,sgm04_q
            before construct
        end construct

        on action controlp
            # 开窗
        on action allotment
            let g_b_flag = "1"
 
        on action routing
            let g_b_flag = "2"
 
        on action sub_po
            let g_b_flag = "3"
 
        on action issue
            let g_b_flag = "4"
 
        on action fqc
            let g_b_flag = "5"
        
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
function p_admin_wo()
    call p_admin_wo_ctr_temp()
    call p_admin_wo_menu()
end function
# 菜单
function p_admin_wo_menu()
    define n om.DomNode
    define list dynamic array of record
            node om.DomNode,
            name string
        end record
    define l_file string

    while true
        case g_b_flag
            when '1'
                # 工单明细
                call p_admin_wo_bp1("G")
            when '2'
                # 工单备料明细
                call p_admin_wo_bp2("G")
            when '3'
                call p_admin_wo_bp3("G")
            when '4'
                call p_admin_wo_bp4("G")
            when '5'
                call p_admin_wo_bp5("G")
            otherwise
                call p_admin_wo_bp1("G")
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
                    call p_admin_wo_q()
                end if
            
            when "exporttoexcel"
                # 导出excel
                if cl_chk_act_auth() then
                    let w = ui.window.getcurrent()
                    let f = w.getform()
                    call cl_expexcel_display("s_sfb",base.typeinfo.create(g_sfb_excel),"s_sfa",base.typeinfo.create(g_sfa_excel),"s_sgm",base.typeinfo.create(g_sgm_excel))
                    call cl_download_by_explorer(
                        cl_expexcel5(
                            "s_sfb",base.typeinfo.create(g_sfb_excel),
                            "s_sfa",base.typeinfo.create(g_sfa_excel),
                            "s_sgm",base.typeinfo.create(g_sgm_excel),
                            "s_tc_shb",base.typeinfo.create(g_tc_shb_excel),
                            "s_tc_shb_2",base.typeinfo.create(g_tc_shb_2_excel)
                        )) #darcy:2024/01/18 
                end if
            # TODO:功能按钮 s---

            # TODO:功能按钮 e---
        end case
    end while
end function
# 查询
function p_admin_wo_q()
    let g_b_flag = "1"
    let g_rec_b = 0

    clear form
    let flag_sfb = 'N'
    let flag_sfa = 'N'
    let flag_sgm = 'N'
    let flag_tc_shb = 'N'
    let flag_sfb = 'N'

    display g_rec_b to cn2
    call cl_opmsg('q')

    MESSAGE ""
    display '   ' to formonly.cnt

    call p_admin_wo_cs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call p_admin_wo_show()
    end if
    message ""
end function

# 查询
function p_admin_wo_show()
    let g_b_flag = '1'
    # call p_admin_wo_fill_sfb(g_wc1,g_wc2)
end function
function p_admin_wo_fill_sfb(p_wc1,p_wc2)
    # ---
    define p_wc1 string
    define p_wc2 string
    define l_sql string
    # ---

    # ---
    if flag_sfb = 'Y' then
        return
    end if
    let flag_sfb = 'Y'
    # ---

    # ---
    if p_wc2 = ' 1=1' then
        let l_sql = " SELECT 'Y',sfb01,sfb02,sfb81,sfb87,sfb28,sfb38,sfb44, ",
                    "        gen02,sfb98,sfb05,sfb06,sfb071,ima02,ima021,sfbud08, ",
                    "        sfbud09,sfb08,sfbud07,sfb081,sfb09,sfb12,sfbud12, ",
                    "        sfb22,sfb221,sfb86,sfb89,sfb99 ",
                    " from sfb_file left join gen_file on gen01 = sfb44,ima_file ",
                    " WHERE ima01 = sfb05",
                    " and ",p_wc1 clipped
    else
        let l_sql = "select unique 'Y',sfb01,sfb02,sfb81,sfb87,sfb28,sfb38,sfb44, ",
                    "       gen02,sfb98,sfb05,sfb06,sfb071,ima02,ima021,sfbud08, ",
                    "       sfbud09,sfb08,sfbud07,sfb081,sfb09,sfb12,sfbud12, ",
                    "       sfb22,sfb221,sfb86,sfb89,sfb99 ",
                    " from sfb_file left join gen_file on gen01 = sfb44,sgm_file,ima_file ",
                    " where sfb01 = sgm02 and ima01 = sfb05 ",
                    " and ",p_wc1 clipped," and ",p_wc2 clipped
    end if
    prepare p_admin_wo_fill_sfb_p from l_sql
    declare p_admin_wo_fill_sfb cursor for p_admin_wo_fill_sfb_p

    let g_cnt = 1
    call g_sfb_excel.clear()
    call g_sfb.clear()
    message "查询中......"
    foreach p_admin_wo_fill_sfb into g_sfb_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_sfb",status,1)
            exit foreach
        end if
        if g_cnt > g_max_rec then
            if g_cnt = g_max_rec + 1 then
                call cl_err( '', 9035, 0 )
            end if
        else
            let g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    message ''
    call g_sfb_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---
end function
function p_admin_wo_fill_sfa(p_wc)
    define p_wc string
    define l_sql string

    # ---
    if flag_sfa = 'Y' then
        return
    end if
    let flag_sfa = 'Y'
    # ---

    # ---
    let l_sql = " select 'Y',sfa01,sfa03,ima02,ima021,sfa27,sfa26,",
                "         sfa28,sfa08,ima08,sfa12,sfa11,sfa16,",
                "         sfa161,sfa05,sfa06,sfa065,sfa062,sfa063,",
                "         sfa064,sfa100,sfaud08",
                " from sfa_file,sfb_file,ima_file",
                " where sfa01=sfb01 and ima01 =sfa03",
                " and ",p_wc,
                " order by sfa01,sfa03,sfa27,sfa08"
    prepare p_admin_wo_fill_sfa_p from l_sql
    declare p_admin_wo_fill_sfa cursor for p_admin_wo_fill_sfa_p

    # delete from sfa_temp
    let g_cnt = 1
    call g_sfa_excel.clear()
    call g_sfa.clear()
    message "查询中......"
    foreach p_admin_wo_fill_sfa into g_sfa_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_sfa",status,1)
            exit foreach
        end if
        if status then
            call cl_err("ins sfa_temp",status,1)
            return
        end if
        if g_cnt > g_max_rec then
            if g_cnt = g_max_rec + 1 then
                call cl_err( '', 9035, 0 )
            end if
        else
            let g_sfa[g_cnt].* = g_sfa_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    message ''
    call g_sfa_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---

end function
function p_admin_wo_fill_sgm(p_wc)
    define p_wc string
    define l_sql string

    # ---
    if flag_sgm = 'Y' then
        return
    end if
    let flag_sgm = 'Y'
    # ---

    # ---
    let l_sql = " select 'Y',sgm01,sgm02,sgm11,sgm03_par,ima02,ima021,sgm03,",
                "     sgm04,sgm45,sgm05,sgm06,sgm14,sgm15,sgm16,sgm65,sgm301,",
                "     sgm302,sgm303,sgm304,sgm311,sgm312,sgm313,sgm314,sgm315,",
                "     sgm316,sgm317,sgm321,sgm322,sgm52,sgm53,sgm54,ta_sgm01,",
                "     ta_sgm02,ta_sgm03,ta_sgm06 ",
                " from sgm_file,ima_file,sfb_temp",
                " where sgm03_par = ima01 AND sgm03_par = sfb05 AND sgm02 = sfb01",
                " and ",p_wc clipped,
                " order by  sgm03,sgm01"
    prepare p_admin_wo_fill_sgm_p from l_sql
    declare p_admin_wo_fill_sgm cursor for p_admin_wo_fill_sgm_p
 
    let g_cnt = 1
    call g_sgm_excel.clear()
    call g_sgm.clear()
    message "查询中......"
    foreach p_admin_wo_fill_sgm into g_sgm_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_sgm",status,1)
            exit foreach
        end if
        if status then
            call cl_err("ins sgm_temp",status,1)
            return
        end if
        if g_cnt > g_max_rec then
            if g_cnt = g_max_rec + 1 then
                call cl_err( '', 9035, 0 )
            end if
        else
            let g_sgm[g_cnt].* = g_sgm_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    message ''
    call g_sgm_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---

end function
function p_admin_wo_fill_tc_shb()
    define l_sql string

    # ---
    if flag_tc_shb = 'Y' then
        return
    end if
    let flag_tc_shb = 'Y'
    # ---

    # ---
    let l_sql = "select 'Y',tc_shb03,tc_shb06,tc_shb08,tc_shb01,tc_shb02,tc_shb14,",
                " tc_shb15,tc_shb04,tc_shb07,tc_shb05,tc_shb16,ima02,ima021,tc_shb09,tc_shb10,",
                " tc_shb11,gen02,tc_shb12,tc_shbud09,tc_shb121,tc_shb122,tc_shb13,tc_shb17",
                " from tc_shb_file left join gen_file on gen01 = tc_shb11,ima_file,sgm_temp",
                " where ima01 = tc_shb05  ",
                " and tc_shb03 = sgm01 and tc_shb06 = sgm03",
                " order by tc_shb01,tc_shb06,tc_shb03"

    prepare p_admin_wo_fill_tc_shb_p from l_sql
    declare p_admin_wo_fill_tc_shb cursor for p_admin_wo_fill_tc_shb_p
 
    let g_cnt = 1
    call g_tc_shb_excel.clear()
    call g_tc_shb.clear()
    message "查询中......"
    foreach p_admin_wo_fill_tc_shb into g_tc_shb_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_tc_shb",status,1)
            exit foreach
        end if
        if status then
            call cl_err("ins tc_shb_temp",status,1)
            return
        end if
        if g_cnt > g_max_rec then
            if g_cnt = g_max_rec + 1 then
                call cl_err( '', 9035, 0 )
            end if
        else
            let g_tc_shb[g_cnt].* = g_tc_shb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    message ''
    call g_tc_shb_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    # ---
end function
function p_admin_wo_fill_tc_shb_2()
    define l_sql string

    # ---
    if flag_tc_shb_2 = 'Y' then
        return
    end if
    let flag_tc_shb_2 = 'Y'
    # ---

    # ---
    let l_sql = "select 'Y',tc_shb03,tc_shb06,tc_shb08,tc_shb01,tc_shb02,tc_shb14,",
                " tc_shb15,tc_shb04,tc_shb07,tc_shb05,tc_shb16,ima02,ima021,tc_shb09,tc_shb10,",
                " tc_shb11,gen02,tc_shb12,tc_shbud09,tc_shb121,tc_shb122,tc_shb13,tc_shb17",
                " from tc_shb_file left join gen_file on gen01 = tc_shb11,ima_file,sgm_temp",
                " where ima01 = tc_shb05  ",
                " and tc_shb03 = sgm01 and tc_shb06 = sgm03 and tc_shb121 >0 and tc_shb01 =2",
                " order by tc_shb01,tc_shb06,tc_shb03"

    prepare p_admin_wo_fill_tc_shb_2_p from l_sql
    declare p_admin_wo_fill_tc_shb_2 cursor for p_admin_wo_fill_tc_shb_2_p
 
    let g_cnt = 1
    call g_tc_shb_2_excel.clear()
    call g_tc_shb_2.clear()
    message "查询中......"
    foreach p_admin_wo_fill_tc_shb_2 into g_tc_shb_2_excel[g_cnt].*
        if status then
            call cl_err("p_admin_wo_fill_tc_shb_2",status,1)
            exit foreach
        end if
        if g_cnt > g_max_rec then
            if g_cnt = g_max_rec + 1 then
                call cl_err( '', 9035, 0 )
            end if
        else
            let g_tc_shb_2[g_cnt].* = g_tc_shb_2_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    message ''
    call g_tc_shb_2_excel.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
end function

function p_admin_wo_ctr_temp()
    whenever any error continue
        drop table sfb_temp
        drop table sgm_temp
    whenever any error stop
    create temp table sfb_temp(
        sfb01   varchar(20),
        sfb05   varchar(40)
    )
    create temp table sgm_temp(
        sgm01   varchar(23),
        sgm03   integer
    )
end function

function p_admin_wo_bp1(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_sfb(g_wc1,g_wc2)

    call cl_set_act_visible("accept,cancel", false)
    display g_sfb.getLength() to cn2

    input array g_sfb without defaults from s_sfb.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt
        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input

        on row change

        on action checkall
            for l_index = 1 to g_sfb.getLength()
                let g_sfb[l_index].checksfb = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_sfb.getLength()
                if g_sfb[l_index].checksfb = 'Y' then
                    let g_sfb[l_index].checksfb = 'N'
                else
                    let g_sfb[l_index].checksfb = 'Y'
                end if
            end for

        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            call p_admin_wo_page1_check()
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            call p_admin_wo_page1_check()
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            call p_admin_wo_page1_check()
            call p_admin_wo_fill_sgm(g_wc2)
            call p_admin_wo_page3_check()
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            call p_admin_wo_page1_check()
            call p_admin_wo_fill_sgm(g_wc2)
            call p_admin_wo_page3_check()
            exit input

        # TODO: 功能按钮 s---
        
        on action updsfb12
            # 更新作废数量
            call p_admin_wo_updsfb12()
        on action updsfbud12
            # 更新退版数量
            call p_admin_wo_updsfbud12()
        on action atmt260
            # 因下版导致无法开工
            call p_admin_wo_atmt260()
        on action unatmt260
            # 下版无法开工取消
            call p_admin_wo_unatmt260()
        on action unatmt260_all
            # 所有下版一并取消
            call unatmt260_all()
        on action test_mail
            call test_mail()
        # TODO: 功能按钮 e---
        
        # TODO：公共按钮 s---
        on action btn_sfb98
            call p_admin_wo_sfb98()
        # TODO：公共按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp2(p_ud)
    define   p_ud   like type_file.chr1
    define   l_wc   string
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    let l_wc = " (sfb01,sfb05) in (select sfb01,sfb05 from sfb_temp) "
    call p_admin_wo_fill_sfa(l_wc)

    display g_sfa.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_sfa without defaults from s_sfa.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            exit input
        
        on action checkall
            for l_index = 1 to g_sfa.getLength()
                let g_sfa[l_index].checksfa = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_sfa.getLength()
                if g_sfa[l_index].checksfa = 'Y' then
                    let g_sfa[l_index].checksfa = 'N'
                else
                    let g_sfa[l_index].checksfa = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        on action updsfa06
            call p_admin_wo_updsfa06()
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action btn_sfb98
            call p_admin_wo_sfb98()
        # TODO：公共按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp3(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_sgm(g_wc2)

    display g_sgm.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_sgm without defaults from s_sgm.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            call p_admin_wo_page3_check()
            exit input
        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            call p_admin_wo_page3_check()
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            call p_admin_wo_page3_check()
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            call p_admin_wo_page3_check()
            exit input
        
        on action checkall
            for l_index = 1 to g_sgm.getLength()
                let g_sgm[l_index].checksgm = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_sgm.getLength()
                if g_sgm[l_index].checksgm = 'Y' then
                    let g_sgm[l_index].checksgm = 'N'
                else
                    let g_sgm[l_index].checksgm = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        # --- 取消/勾选报工
        on action ta_sgm06
            call p_admin_wo_ta_sgm06('Y','Y')
        on action unta_sgm06
            call p_admin_wo_ta_sgm06('N','Y')
        on action ta_sgm06_lot
            call p_admin_wo_ta_sgm06('Y','N')
        on action unta_sgm06_lot
            call p_admin_wo_ta_sgm06('N','N')
        # --- 取消/勾选报工
        
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action btn_sfb98
            call p_admin_wo_sfb98()
        # TODO：公共按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp4(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_tc_shb()

    display g_tc_shb.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_tc_shb without defaults from s_tc_shb.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit input
        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit input
        on action fqc
            let g_action_choice = 'fill'
            let g_b_flag = '5'
            exit input
        
        on action checkall
            for l_index = 1 to g_tc_shb.getLength()
                let g_tc_shb[l_index].checktc_shb = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_tc_shb.getLength()
                if g_tc_shb[l_index].checktc_shb = 'Y' then
                    let g_tc_shb[l_index].checktc_shb = 'N'
                else
                    let g_tc_shb[l_index].checktc_shb = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        on action tc_shb_del
            call p_admin_wo_tc_shb_del()
        on action tc_shb_only
            call p_admin_wo_tc_shb_del_only()
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action btn_sfb98
            call p_admin_wo_sfb98()
        # TODO：公共按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function
function p_admin_wo_bp5(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    call p_admin_wo_fill_tc_shb_2()

    display g_tc_shb_2.getLength() to cn2
    call cl_set_act_visible("accept,cancel", false)

    input array g_tc_shb_2 without defaults from s_tc_shb_2.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            let l_ac = arr_curr()
            display l_ac to formonly.cnt

        on action help
            let g_action_choice="help"
            exit input
        on action exit
            let g_action_choice="exit"
            exit input
        on action controlg
            let g_action_choice="controlg"
            exit input
        on action query
            let g_action_choice="query"
            exit input 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit input
        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        on action close
            let g_action_choice = 'close'
            exit input
            
        on action allotment
            let g_action_choice = 'fill'
            let g_b_flag = '1'
            exit input
        on action routing
            let g_action_choice = 'fill'
            let g_b_flag = '2'
            exit input
        on action sub_po
            let g_action_choice = 'fill'
            let g_b_flag = '3'
            exit input
        on action issue
            let g_action_choice = 'fill'
            let g_b_flag = '4'
            exit input
        
        on action checkall
            for l_index = 1 to g_tc_shb_2.getLength()
                let g_tc_shb_2[l_index].checktc_shb_2 = 'Y'
            end for
        on action inverse
            for l_index = 1 to g_tc_shb_2.getLength()
                if g_tc_shb_2[l_index].checktc_shb_2 = 'Y' then
                    let g_tc_shb_2[l_index].checktc_shb_2 = 'N'
                else
                    let g_tc_shb_2[l_index].checktc_shb_2 = 'Y'
                end if
            end for

        # TODO: 功能按钮 s---
        on action tc_shb121_del
            call p_admin_wo_tc_shb121_del()
        # TODO: 功能按钮 e---
        # TODO：公共按钮 s---
        on action btn_sfb98
            call p_admin_wo_sfb98()
        # TODO：公共按钮 e---
    end input
    call cl_set_act_visible("accept,cancel", true)
end function

function p_admin_wo_page1_check()
    define l_index  integer

    # ---
    let flag_sgm = 'N'
    let flag_sfa = 'N'
    let flag_tc_shb = 'N'
    let flag_tc_shb_2 = 'N'
    # ---

    delete from sfb_temp
    begin work
    for l_index = 1 to g_sfb.getLength()
        if g_sfb[l_index].checksfb = 'Y' then
            insert into sfb_temp values (g_sfb[l_index].sfb01,g_sfb[l_index].sfb05)
            if status then
                call cl_err("ins sfb_temp",status,1)
                rollback work
                return
            end if
        end if
    end for
    commit work
end function

function p_admin_wo_page3_check()
    define l_index  integer

    let flag_tc_shb = 'N'
    let flag_tc_shb_2 = 'N'
    
    delete from sgm_temp
    begin work
    for l_index = 1 to g_sgm.getLength()
        if g_sgm[l_index].checksgm = 'Y' then
            insert into sgm_temp values (g_sgm[l_index].sgm01,g_sgm[l_index].sgm03)
            if status then
                call cl_err("ins sgm_temp",status,1)
                rollback work
                return
            end if
        end if
    end for
    commit work
end function

#  更新报废数量
function p_admin_wo_updsfb12()
    define l_index integer
    define l_sfb12 decimal(15,3)
    define l_msg   string
    define flag  like type_file.chr1

    begin work
    call s_showmsg_init()
    let flag = 'N'

    for l_index = 1 to g_sfb.getlength()
        if g_sfb[l_index].checksfb ='Y' then
            let l_sfb12 = 0 
            select sum(sgm313) into l_sfb12 from sgm_file where sgm02 = g_sfb[l_index].sfb01
            if cl_null(l_sfb12) then let l_sfb12 = 0 end if
            if l_sfb12 != g_sfb[l_index].sfb12 then
                let flag = 'Y'
                let g_sfb[l_index].sfb12 = l_sfb12 #darcy:2022/11/29 add
                update sfb_file set sfb12 = l_sfb12 where sfb01 = g_sfb[l_index].sfb01
                if status then
                    call cl_err("upd sfb",status,1)
                    rollback work
                    return
                end if
                if not p_admin_wo_check(g_sfb[l_index].sfb01) then
                    call s_errmsg("sfb01",g_sfb[l_index].sfb01,"",'czz-011',1)
                end if
                let l_msg = "工单:",g_sfb[l_index].sfb01,"报废数量:",l_sfb12
                call s_errmsg("sfb12",g_sfb[l_index].sfb12,l_msg,'czz-006',1)
            end if
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
        else
            rollback work
        end if
    end if
end function

# 退版数量更新
function p_admin_wo_updsfbud12()
    define l_index integer
    define l_sfbud12 decimal(15,3)
    define l_msg   string
    define l_sql   string
    define flag  like type_file.chr1

    let l_sql = "select sum(tsc05) from tsc_file where tscpost='Y' and tsc14 like ?||'%' "
    prepare upd_sfbud12 from l_sql

    begin work
    call s_showmsg_init()
    
    let flag = 'N'
    for l_index = 1 to g_sfb.getlength()
        if g_sfb[l_index].checksfb ='Y' then
            let l_sfbud12 = 0
            execute upd_sfbud12 using g_sfb[l_index].sfb01 into l_sfbud12
            -- select sum(sgm313) into l_sfb12 from sgm_file where sgm02 = g_sfb[l_index].sfb01
            if cl_null(l_sfbud12) then let l_sfbud12 = 0 end if
            if l_sfbud12 != g_sfb[l_index].sfbud12 then
                let flag = 'Y'
                let g_sfb[l_index].sfbud12 = l_sfbud12 #darcy:2022/11/29 add
                update sfb_file set sfbud12 = l_sfbud12 where sfb01 = g_sfb[l_index].sfb01
                if status then
                    call cl_err("upd sfb",status,1)
                    rollback work
                    return
                end if
                if not p_admin_wo_check(g_sfb[l_index].sfb01) then
                    call s_errmsg("sfb01",g_sfb[l_index].sfb01,"",'czz-011',1)
                end if
                let l_msg = "工单:",g_sfb[l_index].sfb01,"退版数量:",l_sfbud12
                call s_errmsg("sfbud12",g_sfb[l_index].sfbud12,l_msg,'czz-009',1)
            end if
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
        else
            rollback work
        end if
    end if
end function

# 更新已发数量
function p_admin_wo_updsfa06()
    define l_index integer
    define l_sfa06,l_sfa062 decimal(15,3)
    define l_msg   string
    define l_sql   string
    define flag  like type_file.chr1

    let l_sql = "select sum(case smykind when '3' then sfe16 when '4' then - sfe16 end) ",
                " from sfe_file left join smy_file on smyslip = substr(sfe02, 0, 3) ",
                " where sfe01 = ? and sfe07 = ? and sfe27 = ? and sfe17 = ? and sfe14 = ? "
    prepare upd_sfa06 from l_sql

    begin work
    call s_showmsg_init()
    
    let flag = 'N'
    for l_index = 1 to g_sfa.getlength()
        if g_sfa[l_index].checksfa ='Y' then
            let l_sfa06 = 0
            execute upd_sfa06 using g_sfa[l_index].sfa01,g_sfa[l_index].sfa03,
                                    g_sfa[l_index].sfa27,g_sfa[l_index].sfa12,
                                    g_sfa[l_index].sfa08
                               into l_sfa06
            if cl_null(l_sfa06) then let l_sfa06 = 0 end if
            if cl_null(l_sfa062) then let l_sfa062 = 0 end if

            # if not p_admin_wo_check(g_sfb[l_index].sfb01) then #darcy:2023/04/17 mark
            if not p_admin_wo_check(g_sfa[l_index].sfa01) then #darcy:2023/04/17 add
                call s_errmsg("sfb01",g_sfa[l_index].sfa01,"",'czz-011',1)
            end if
            let l_sfa062 = 0 #darcy:2023/04/17
            if l_sfa06 > g_sfa[l_index].sfa05 then
                let l_sfa062 = l_sfa06 - g_sfa[l_index].sfa05
                let l_sfa06 = g_sfa[l_index].sfa05
            end if
            if l_sfa06 != g_sfa[l_index].sfa06 or l_sfa062 != g_sfa[l_index].sfa062 then
                let flag = 'Y'
                update sfa_file set sfa06 = l_sfa06,sfa062=l_sfa062 
                 where sfa01 = g_sfa[l_index].sfa01 and sfa03 = g_sfa[l_index].sfa03 
                   and sfa08  = g_sfa[l_index].sfa08 and sfa27 = g_sfa[l_index].sfa27
                if status then
                    call cl_err("upd sfa",status,1)
                    rollback work
                    return
                end if
                let l_msg = "工单:",g_sfa[l_index].sfa01," 已发数量:",l_sfa06," 超领数量:",l_sfa062
                call s_errmsg("sfa06,sfa062",
                              g_sfa[l_index].sfa06||"|"||g_sfa[l_index].sfa062,
                              l_msg,
                              'czz-010',
                              1)
            end if
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
        else
            rollback work
        end if
    end if
end function

# 因下版数量导致无法开工
function p_admin_wo_atmt260()
    define l_index integer
    define l_msg   string
    define l_sql   string
    define flag  like type_file.chr1

    begin work
    call s_showmsg_init()
    let flag = 'N'

    let l_sql = "MERGE INTO sfa_admin_wo a USING ( ",
                " select sfa01,sfa03,sfa08,sfa27,sfa12,sfa06,'A' status,sysdate d from sfa_file where sfa01 = ? ",
                " ) b ON (a.sfa01 = b.sfa01 AND a.sfa03=b.sfa03 AND a.sfa27 = b.sfa27 AND a.sfa08 = b.sfa08 AND a.sfa12=b.sfa12) ",
                " WHEN MATCHED THEN UPDATE SET a.sfa06 =b.sfa06 ",
                " WHEN NOT MATCHED THEN INSERT VALUES(b.sfa01,b.sfa03,b.sfa08,b.sfa27,b.sfa12,b.sfa06,b.status,b.d)  "
    prepare ins_sfa from l_sql

    let l_sql = ""

    for l_index = 1 to g_sfb.getlength()
        if g_sfb[l_index].checksfb ='Y' then
            # TODO: 结案检查
            let flag = 'Y'

            if not p_admin_wo_check(g_sfb[l_index].sfb01) then
                call s_errmsg("sfb01",g_sfb[l_index].sfb01,"",'czz-011',1)
            end if
            # 备份
            execute ins_sfa using g_sfb[l_index].sfb01
            if status then
                call cl_err("ins sfa_admin_wo",status,1)
                rollback work
                return
            end if
            # 更新sfa06 = sfa05
            update sfa_file set sfa06 = sfa05 where sfa01 = g_sfb[l_index].sfb01
            if status then
                call cl_err("upd sfa",status,1)
                rollback work
                return
            end if
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
        else
            rollback work
        end if
    end if
end function

# 下版数量还原
function p_admin_wo_unatmt260()
define l_index integer
    define l_msg   string
    define l_sql   string
    define flag  like type_file.chr1

    begin work
    call s_showmsg_init()
    let flag = 'N'

    let l_sql = " merge into sfa_file a ",
                " using (select * from sfa_admin_wo where sfa01 =? ) b ",
                " on (a.sfa01 = b.sfa01 and a.sfa03 = b.sfa03 and a.sfa08 = b.sfa08",
                "    and a.sfa27 = b.sfa27 and a.sfa12 = b.sfa12)",
                "when matched then update set a.sfa06= b.sfa06 "
    prepare mer_sfa_admin_wo from l_sql

    let l_sql = "delete from sfa_admin_wo where sfa01 = ?"
    prepare mer_sfa_admin_wo_del from l_sql

    for l_index = 1 to g_sfb.getlength()
        if g_sfb[l_index].checksfb ='Y' then
            # TODO: 结案检查
            if not p_admin_wo_check(g_sfb[l_index].sfb01) then
                call s_errmsg("sfb01",g_sfb[l_index].sfb01,"",'czz-011',1)
            end if
            let flag = 'Y'
            # 恢复备份
            execute mer_sfa_admin_wo using g_sfb[l_index].sfb01
            if status then
                call cl_err("mer sfa_admin_wo",status,1)
                return
            end if
            # 删除备份
            execute mer_sfa_admin_wo_del using g_sfb[l_index].sfb01
            if status then
                call cl_err("mer sfa_admin_wo",status,1)
                return
            end if
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
        else
            rollback work
        end if
    end if
end function

# 成本中心更新
function p_admin_wo_sfb98()
    define l_sql string
    let l_sql = "update sfb_file set sfb98 ='B12' where sfb98 is null or sfb98 ='' or sfb98 = ' '"
    prepare upd_sfb98 from l_sql
    execute upd_sfb98
    if status then
        call cl_err('upd_sfb98',status,1)
        return
    else
        message "成功更新"||sqlca.sqlerrd[3]||"笔工单！"
    end if
end function

# 取消勾选报工
# 勾选报工
function p_admin_wo_ta_sgm06(p_flag,p_all)
    define p_flag,p_all  like type_file.chr1
    -- flag Y:勾选报工 N:取消勾选报工
    -- all Y:更新aeci100 N:不更新aeci100
    define l_sql string
    define l_index INTEGER
    define l_msg   string
    define flag  like type_file.chr1

    let l_sql = "insert into sgm_admin_wo values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
    prepare ins_sgm_admin_wo from l_sql

    let l_sql = "MERGE INTO sgm_file a",
                " USING (",
                " SELECT * FROM sgm_admin_wo )b",
                " ON (a.sgm01 =b.sgm01 AND a.sgm02 =b.sgm02 AND a.sgm03 =b.sgm03 ",
                " AND a.sgm04=b.sgm04  )",
                " WHEN MATCHED THEN UPDATE SET ta_sgm06 ='",p_flag,"',sgmdate =SYSDATE "
    prepare mer_sgm_file from l_sql

    let l_sql = "MERGE INTO ecb_file a USING (",
                " SELECT UNIQUE sgm03_par,ecu02,sgm03,sgm04 FROM sgm_admin_wo,ecu_file",
                " WHERE  ecu01 =sgm03_par AND ecu10='Y' )",
                " ON (ecb01 =sgm03_par AND ecb03=sgm03 AND ecb06=sgm04 AND ecb02 =ecu02)",
                " WHEN MATCHED THEN UPDATE SET ecbud06='",p_flag,"' "
    prepare mer_aeci100 from l_sql

    begin work
    call s_showmsg_init()
    let flag = 'N'

    for l_index = 1 to g_sgm.getlength()
        if g_sgm[l_index].checksgm ='Y' then
            let flag = 'Y'
            # 结案检查
            if not p_admin_wo_check(g_sgm[l_index].sgm02) then
                call s_errmsg("sfb01",g_sgm[l_index].sgm02,"",'czz-011',1)
            end if
            # 当前状态是否一样
            if g_sgm[l_index].ta_sgm06 = p_flag then
                let l_msg = g_sgm[l_index].sgm01,"|",g_sgm[l_index].sgm03,"|",g_sgm[l_index].ta_sgm06
                call s_errmsg("sgm01,sgm03,ta_sgm06","",l_msg,'czz-012',1)
            end if
            # 是否已经有完工
            if g_sgm[l_index].sgm311 + g_sgm[l_index].sgm313 > 0 then
                let l_msg = g_sgm[l_index].sgm01,"|",g_sgm[l_index].sgm03,"|",g_sgm[l_index].sgm311,"|",g_sgm[l_index].sgm313
                call s_errmsg("sgm01,sgm03,sgm311,sgm311","",l_msg,'czz-013',1)
            end if
            execute ins_sgm_admin_wo using g_sgm[l_index].sgm01,g_sgm[l_index].sgm02,g_sgm[l_index].sgm03_par,g_sgm[l_index].sgm03,g_sgm[l_index].sgm04,g_sgm[l_index].sgm301,
                                           g_sgm[l_index].sgm302,g_sgm[l_index].sgm303,g_sgm[l_index].sgm304,g_sgm[l_index].sgm311,g_sgm[l_index].sgm312,g_sgm[l_index].sgm313,
                                           g_sgm[l_index].sgm314,g_sgm[l_index].sgm315,g_sgm[l_index].sgm316,g_sgm[l_index].sgm317,g_sgm[l_index].ta_sgm06
            if status then
                call cl_err('ins_sgm_admin_wo',status,1)
                rollback work
                return
            end if
        end if
    end for

    call s_showmsg()
    execute mer_sgm_file
        if status then
            call cl_err('mer_sgm_file',status,1)
            return
        end if
    if p_all = 'Y' then
        execute mer_aeci100
        if status then
            call cl_err('mer_aeci100',status,1)
            return
        end if
    end if

    delete from sgm_admin_wo
    if status then
        call cl_err('upd sgm_admin_wo',status,1)
        return
    end if

    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
        else
            rollback work
        end if
    end if

end function

# 删除报工
function p_admin_wo_tc_shb_del()
    define l_index integer
    define l_msg   string
    define flag  like type_file.chr1
    define l_sgm03 like sgm_file.sgm03
    define tc_shb121_flag like type_file.chr1
    define l_sfb12 like sfb_file.sfb12
    define l_sfb01 like sfb_file.sfb01

    begin work
    call s_showmsg_init()
    let flag = 'N'

    let tc_shb121_flag = 'N'
    for l_index = 1 to g_tc_shb.getlength()
        if g_tc_shb[l_index].checktc_shb ='Y' then
            let flag = 'Y'
            delete from tc_shb_file where tc_shb02 = g_tc_shb[l_index].tc_shb02
            # 同步修改sgm_file
            if g_tc_shb[l_index].tc_shb01 = '2' then
                if g_tc_shb[l_index].tc_shb12 > 0 then
                #完工
                    # 获取下站的sgm03
                    let l_sgm03 = p_admin_wo_get_next_sgm03(g_tc_shb[l_index].tc_shb03,g_tc_shb[l_index].tc_shb06)
                    if l_sgm03 !=9999 then
                        update sgm_file set sgm301 = sgm301 - g_tc_shb[l_index].tc_shb12
                         where sgm01 = g_tc_shb[l_index].tc_shb03 and sgm03 = l_sgm03
                        if status then
                            call cl_err('update sgm_file',status,1)
                            rollback work
                            return
                        end if
                    end if
                    update sgm_file set sgm311 = sgm311 - g_tc_shb[l_index].tc_shb12
                     where sgm01 = g_tc_shb[l_index].tc_shb03 and sgm03 = g_tc_shb[l_index].tc_shb06
                    if status then
                        call cl_err('update sgm_file',status,1)
                        rollback work
                        return
                    end if
                else
                #报废
                    update sgm_file set sgm313 = sgm313 - g_tc_shb[l_index].tc_shb121
                     where sgm01 = g_tc_shb[l_index].tc_shb03 and sgm03 = g_tc_shb[l_index].tc_shb06
                    if status then
                        call cl_err('update sgm_file',status,1)
                        rollback work
                        return
                    end if
                    let tc_shb121_flag = 'Y'
                end if
            end if
            if status then
                call cl_err('del tc_shb_file',status,1)
                rollback work
                return
            end if
            if tc_shb121_flag ='Y' then
                #更新工单报废数量
                let l_sfb12 = 0 
                let l_sfb01 = g_tc_shb[l_index].tc_shb03
                let l_sfb01= l_sfb01[1,12]
                select sum(sgm313) into l_sfb12 from sgm_file where sgm02 = l_sfb01
                if cl_null(l_sfb12) then let l_sfb12 = 0 end if

                # let g_sfb[l_index].sfb12 = l_sfb12 #darcy:2022/11/29 add
                update sfb_file set sfb12 = l_sfb12 where sfb01 = l_sfb01
                if status then
                    call cl_err("upd sfb",status,1)
                    rollback work
                    return
                end if
                if not p_admin_wo_check(l_sfb01) then
                    call s_errmsg("sfb01",l_sfb01,"",'czz-011',1)
                end if
                let l_msg = "工单:",l_sfb01,"报废数量:",l_sfb12
                call s_errmsg("sfb12","xx",l_msg,'czz-006',1)
                
            end if
            #删除转移单号
            if not cl_null(g_tc_shb[l_index].tc_shb17) then
                delete from shb_file where shb01 = g_tc_shb[l_index].tc_shb17
                if status then
                    call cl_err('del shb_file',status,1)
                    rollback work
                    return
                end if
            end if
            let l_msg = g_tc_shb[l_index].tc_shb01,'|',g_tc_shb[l_index].tc_shb03,'|',
                        g_tc_shb[l_index].tc_shb06,'|',g_tc_shb[l_index].tc_shb12,'|',g_tc_shb[l_index].tc_shb121
            call s_errmsg("tc_shb01,tc_shb03,tc_shb06,tc_shb12,tc_shb121","",l_msg,'czz-014',1)
            
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            call p_admin_wo_fill_sgm(g_wc2)
            commit work
        else
            rollback work
        end if
    end if
end function

# 仅删除tc_shb_file
# 不更新sgm_file等
function p_admin_wo_tc_shb_del_only()
    define l_index integer
    define l_msg   string
    define flag  like type_file.chr1
    define l_sgm03 like sgm_file.sgm03
    define tc_shb121_flag like type_file.chr1
    define l_sfb12 like sfb_file.sfb12

    begin work
    call s_showmsg_init()
    let flag = 'N'

    for l_index = 1 to g_tc_shb.getlength()
        if g_tc_shb[l_index].checktc_shb ='Y' then
            let flag = 'Y'
            delete from tc_shb_file where tc_shb02 = g_tc_shb[l_index].tc_shb02
            if status then
                call cl_err('del tc_shb_file',status,1)
                rollback work
                return
            end if 
            let l_msg = g_tc_shb[l_index].tc_shb01,'|',g_tc_shb[l_index].tc_shb03,'|',
                        g_tc_shb[l_index].tc_shb06,'|',g_tc_shb[l_index].tc_shb12,'|',g_tc_shb[l_index].tc_shb121
            call s_errmsg("tc_shb01,tc_shb03,tc_shb06,tc_shb12,tc_shb121","",l_msg,'czz-014',1)
            
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            call p_admin_wo_fill_sgm(g_wc2)
            commit work
        else
            rollback work
        end if
    end if
end function

# 删除报废数量
function p_admin_wo_tc_shb121_del()
    define l_index integer
    define l_msg   string
    define flag  like type_file.chr1
    define l_sfb12 like sfb_file.sfb12
    define l_sfb01 like sfb_file.sfb01

    begin work
    call s_showmsg_init()
    let flag = 'N'

    for l_index = 1 to g_tc_shb_2.getlength()
        if g_tc_shb_2[l_index].checktc_shb_2 ='Y' then
            let flag = 'Y'
            update sgm_file set sgm313 = sgm313 - g_tc_shb_2[l_index].tc_shb121_2
             where sgm01 = g_tc_shb_2[l_index].tc_shb03_2 and sgm03 = g_tc_shb_2[l_index].tc_shb06_2
            if status then
                call cl_err('update sgm_file',status,1)
                rollback work
                return
            end if
            delete from tc_shb_file where tc_shb02 = g_tc_shb_2[l_index].tc_shb02_2
            if status then
                call cl_err('del tc_shb_file',status,1)
                rollback work
                return
            end if
            let l_msg = g_tc_shb_2[l_index].tc_shb01_2,'|',g_tc_shb_2[l_index].tc_shb03_2,'|',
                        g_tc_shb_2[l_index].tc_shb06_2,'|',g_tc_shb_2[l_index].tc_shb12_2,'|',g_tc_shb_2[l_index].tc_shb121_2
            call s_errmsg("tc_shb01,tc_shb03,tc_shb06,tc_shb12,tc_shb121","",l_msg,'czz-014',1)
            
            #更新工单报废数量
            let l_sfb12 = 0 
            let l_sfb01 = g_tc_shb_2[l_index].tc_shb03_2
            let l_sfb01 = l_sfb01[1,12]
            select sum(sgm313) into l_sfb12 from sgm_file where sgm02 = l_sfb01
            if cl_null(l_sfb12) then let l_sfb12 = 0 end if

            # let g_sfb[l_index].sfb12 = l_sfb12 
            update sfb_file set sfb12 = l_sfb12 where sfb01 = l_sfb01
            if status then
                call cl_err("upd sfb",status,1)
                rollback work
                return
            end if
            if not p_admin_wo_check(l_sfb01) then
                call s_errmsg("sfb01",g_tc_shb_2[l_index].tc_shb03_2,"",'czz-011',1)
            end if
            let l_msg = "工单:",l_sfb01,"报废数量:",l_sfb12
            call s_errmsg("sfb12","xx",l_msg,'czz-006',1)

        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
            call p_admin_wo_fill_sgm(g_wc2)
        else
            rollback work
        end if
    end if
end function

#  跨月更新报工日期
function p_admin_wo_shbdate()
    define l_index integer
    define l_msg   string
    define flag  like type_file.chr1

    begin work
    call s_showmsg_init()
    let flag = 'N'

    for l_index = 1 to g_tc_shb.getlength()
        if g_tc_shb[l_index].checktc_shb ='Y' then
            let flag = 'Y'
            delete from tc_shb_file where tc_shb02 = g_tc_shb[l_index].tc_shb02
            if status then
                call cl_err('del tc_shb_file',status,1)
                rollback work
                return
            end if
            let l_msg = g_tc_shb[l_index].tc_shb01,'|',g_tc_shb[l_index].tc_shb03,'|',
                        g_tc_shb[l_index].tc_shb06,'|',g_tc_shb[l_index].tc_shb12,'|',g_tc_shb[l_index].tc_shb121
            call s_errmsg("tc_shb01,tc_shb03,tc_shb06,tc_shb12,tc_shb121","",l_msg,'czz-014',1)
            
        end if
    end for
    call s_showmsg()
    if flag ='N' then
        rollback work
    else
        if cl_confirm('czz-008') then
            commit work
        else
            rollback work
        end if
    end if
end function

function p_admin_wo_check(p_sfb01)
    define p_sfb01 like sfb_file.sfb01
    define l_cnt integer

    let l_cnt = 0
    select count(1) into l_cnt from sfb_file where sfb01 = p_sfb01
       and sfb28 is null and sfb38 is null
    if l_cnt > 0 then
        return true
    else
        return false
    end if
end function

# 找到下站sgm03
function p_admin_wo_get_next_sgm03(p_sgm01,p_sgm03)
    define p_sgm01      like sgm_file.sgm01
    define p_sgm03      like sgm_file.sgm03
    define r_sgm03      like sgm_file.sgm03
    
    let r_sgm03 = 0
    select min(sgm03) into r_sgm03 from sgm_file where sgm01 = p_sgm01 and sgm03 > p_sgm03
    if cl_null(r_sgm03) or r_sgm03 = 0 then
        let r_sgm03 = 9999
    end if

    return r_sgm03
end function

function unatmt260_all()
    define l_sql        string
    let l_sql = "call unatmt260()"
    prepare unatmt260_all from l_sql
    execute unatmt260_all
    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,1)
    end if
end function

# function test_mail()

#     call cs_html_init(cl_get_progname(g_prog,g_lang),"这个是p_admin_wo作业导出的格式样式测试")
#     call cs_html_main_field(ui.Interface.getRootNode(),"sfb01_q,sgm03_q,sgm01_q")
#     call cs_html_detail_field(ui.Interface.getRootNode(),"sfb02,sfb81,sfb87,sfb01,sfb44,",base.typeinfo.create(g_sfb_excel))   
#     run "echo '"||cs_html_end()||"' >> /u1/topprod/tiptop/doc/help/2/czz/mail.html"
# end function

function test_mail()
    define l_path   string
    define l_ok     varchar(1)

    call cs_html_init(cl_get_progname(g_prog,g_lang),"这个是p_admin_wo作业导出的格式样式测试")
    call cs_html_main_field(ui.Interface.getRootNode(),"sfb01_q,sgm03_q,sgm01_q")
    call cs_html_detail_field(ui.Interface.getRootNode(),"sfb02,sfb81,sfb87,sfb01,sfb44,",base.typeinfo.create(g_sfb_excel))
    
    let l_path = sfmt("/u1/out/%1.html",cs_uuid())
    call cs_html_write(l_path)
    call cs_mail_sendfile("p_admin_wo",l_path,"darcy.li@forewin-sz.com.cn","","","") returning l_ok
end function
