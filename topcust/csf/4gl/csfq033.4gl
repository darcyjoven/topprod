# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: csfq033.4gl
# Descriptions...: 工单查询
# Date & Author..: 22/11/02 By darcy


database ds
globals "../../../tiptop/config/top.global"
# type s---
type sfb record
    sfb01       like sfb_file.sfb01,
    sfb81       like sfb_file.sfb81,
    sfb02       like sfb_file.sfb02,
    sfb04       like sfb_file.sfb04,
    sfb28       like sfb_file.sfb28,
    sfb22       like sfb_file.sfb22,
    sfb221      like sfb_file.sfb221, 
    sfb05       like sfb_file.sfb05,
    sfb06       like sfb_file.sfb06,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021, 
    sfb08       like sfb_file.sfb08,
    sfbud07     like sfb_file.sfbud07,
    pnl         like sfb_file.sfb08,
    sfb081      like sfb_file.sfb081,
    sfb09       like sfb_file.sfb09,
    sfb12       like sfb_file.sfb12,
    sfbud12     like sfb_file.sfbud12
    end record
type sfa record
    sfa01       like sfa_file.sfa01,
    sfa03       like sfa_file.sfa03,
    ima02_1     like ima_file.ima02,
    ima021_1    like ima_file.ima021,
    sfa27       like sfa_file.sfa27,
    sfa28       like sfa_file.sfa28,
    ecm03       like ecm_file.ecm03,
    sfa08       like sfa_file.sfa08,
    sfa26       like sfa_file.sfa26,
    sfa12       like sfa_file.sfa12,
    sfa05       like sfa_file.sfa05,
    sfb081_1    like sfb_file.sfb081,
    sfb081_c    like sfb_file.sfb081,
    sfb081_f    like sfb_file.sfb081,
    sfa06       like sfa_file.sfa06,
    short_qty   like sfb_file.sfb081,
    sfa16       like sfa_file.sfa16,
    sfa161      like sfa_file.sfa161,
    sfa061      like sfa_file.sfa061,
    sfa062      like sfa_file.sfa062,
    sfa11       like sfa_file.sfa11    
    end record
type sfe record
    sfe01       like sfe_file.sfe01,
    sfe04       like sfe_file.sfe04,
    sfe02       like sfe_file.sfe02,
    sfe28       like sfe_file.sfe28,
    sfe07       like sfe_file.sfe07,
    ima02_2     like ima_file.ima02,
    ima021_2    like ima_file.ima021,
    sfe16       like sfe_file.sfe16,
    sfe17       like sfe_file.sfe17,
    sfe14       like sfe_file.sfe14,
    sfe08       like sfe_file.sfe08,
    sfe09       like sfe_file.sfe09,
    sfe10       like sfe_file.sfe10
    end record
type sfv record
    sfv11       like sfv_file.sfv11,
    sfu01       like sfu_file.sfu01,
    sfu02       like sfu_file.sfu02,
    sfv03       like sfv_file.sfv03,
    sfv20       like sfv_file.sfv20,
    sfv04       like sfv_file.sfv04,
    ima02_3     like ima_file.ima02,
    ima021_3    like ima_file.ima021,
    sfv08       like sfv_file.sfv08,
    sfv09       like sfv_file.sfv09,
    sfv05       like sfv_file.sfv05,
    sfv06       like sfv_file.sfv06,
    sfv07       like sfv_file.sfv07
    end record
type shb record
    shb01       like shb_file.shb01,
    shb02       like shb_file.shb02,
    shb021      like shb_file.shb021,
    shb03       like shb_file.shb03,
    shb031      like shb_file.shb031,
    shb04       like shb_file.shb04,
    shb05       like shb_file.shb05,
    shb06       like shb_file.shb06,
    shb07       like shb_file.shb07,
    shb08       like shb_file.shb08,
    shb081      like shb_file.shb081,
    shb082      like shb_file.shb082,
    shb09       like shb_file.shb09,
    shb10       like shb_file.shb10,
    shb111      like shb_file.shb111,
    shb112      like shb_file.shb112,
    shb113      like shb_file.shb113,
    shb114      like shb_file.shb114,
    shb115      like shb_file.shb115,
    shb12       like shb_file.shb12,
    shb13       like shb_file.shb13,
    shb14       like shb_file.shb14,
    shb15       like shb_file.shb15,
    shb16       like shb_file.shb16,
    shb17       like shb_file.shb17,
    shb18       like shb_file.shb18,
    shb19       like shb_file.shb19,
    shb20       like shb_file.shb20,
    shb21       like shb_file.shb21,
    shb22       like shb_file.shb22,
    shb012      like shb_file.shb012,
    shb121      like shb_file.shb121,
    shb23       like shb_file.shb23,
    shb24       like shb_file.shb24,
    shb25       like shb_file.shb25,
    shb26       like shb_file.shb26,
    shb28       like shb_file.shb28,
    shb29       like shb_file.shb29,
    shb30       like shb_file.shb30,
    shb31       like shb_file.shb31,
    shb32       like shb_file.shb32,
    shb34       like shb_file.shb34,
    shb032      like shb_file.shb032,
    shb033      like shb_file.shb033
    end record
type tsc record
    shb16_1     like shb_file.shb16,
    shb081_1    like shb_file.shb081,
    shb06_1     like shb_file.shb06,
    tscud02     like tsc_file.tscud02,
    sfb01_1     like sfb_file.sfb01,
    tsc01       like tsc_file.tsc01,
    tsc21       like tsc_file.tsc21,
    tsc03       like tsc_file.tsc03,
    tsc15       like tsc_file.tsc15,
    tsc16       like tsc_file.tsc16,
    tsc14       like tsc_file.tsc14,
    tsc04       like tsc_file.tsc04,
    tsc05       like tsc_file.tsc05,
    pnl_1       like shb_file.shb081,
    shb16_new   like shb_file.shb16
    end record
# type e---

define g_sfb,g_sfb_excel dynamic array of sfb
define g_sfa,g_sfa_excel dynamic array of sfa
define g_sfe,g_sfe_excel dynamic array of sfe
define g_sfv,g_sfv_excel dynamic array of sfv
define g_shb,g_shb_excel dynamic array of shb
define g_tsc,g_tsc_excel dynamic array of tsc

define g_rec_b,g_cnt,l_ac,l_ac_t integer
define g_wc1,g_wc2,g_wc3,g_wc4,g_wc5,g_wc6,g_cmd string

MAIN
    define   p_row,p_col   like type_file.num5          #no.fun-680121 smallint
    options                               #改變一些系統預設值
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CSF")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time #no.fun-b30211 
    open window csfq033_w at p_row,p_col with form "csf/42f/csfq033"
            attribute (style = g_win_style clipped) #no.fun-580092 hcn
        
    call cl_ui_init()

    call csfq033_q()
    call csfq033_menu()

    close window csfq033_w                 #結束畫面
    call cl_used(g_prog,g_time,2) returning g_time 

END MAIN

function csfq033_cs()

    let g_action_choice = ""

    dialog
        construct g_wc1 on
            sfb01,sfb81,sfb02,sfb04,sfb28,sfb22,sfb221,sfb05,sfb06,sfb08,sfbud07,sfb081,sfb09,sfb12,sfbud12
            from s_sfb[1].sfb01,s_sfb[1].sfb81,s_sfb[1].sfb02,s_sfb[1].sfb04,s_sfb[1].sfb28,s_sfb[1].sfb22,
                s_sfb[1].sfb221,s_sfb[1].sfb05,s_sfb[1].sfb06,s_sfb[1].sfb08,s_sfb[1].sfbud07,s_sfb[1].sfb081,
                s_sfb[1].sfb09,s_sfb[1].sfb12,s_sfb[1].sfbud12
        end construct

        construct g_wc2 on 
            sfa01,sfa03,sfa27,sfa28,sfa08,sfa26,sfa12,sfa05,sfa06,sfa16,sfa161,sfa061,sfa062,sfa11
            from s_sfa[1].sfa01,s_sfa[1].sfa03,s_sfa[1].sfa27,s_sfa[1].sfa28,s_sfa[1].sfa08,s_sfa[1].sfa26,s_sfa[1].sfa12,
                 s_sfa[1].sfa05,s_sfa[1].sfa06,s_sfa[1].sfa16,s_sfa[1].sfa161,s_sfa[1].sfa061,s_sfa[1].sfa062,s_sfa[1].sfa11
        end construct

        construct g_wc3 on
            sfe01,sfe04,sfe02,sfe28,sfe07,sfe16,sfe17,sfe14,sfe08,sfe09,sfe10
            from s_sfe[1].sfe01,s_sfe[1].sfe04,s_sfe[1].sfe02,s_sfe[1].sfe28,s_sfe[1].sfe07,s_sfe[1].sfe16,
                 s_sfe[1].sfe17,s_sfe[1].sfe14,s_sfe[1].sfe08,s_sfe[1].sfe09,s_sfe[1].sfe10
        end construct

        construct g_wc4 on 
            sfv11,sfu01,sfu02,sfv03,sfv20,sfv04,sfv08,sfv09,sfv05,sfv06,sfv07
            from s_sfv[1].sfv11,s_sfv[1].sfu01,s_sfv[1].sfu02,s_sfv[1].sfv03,s_sfv[1].sfv20,s_sfv[1].sfv04,
                 s_sfv[1].sfv08,s_sfv[1].sfv09,s_sfv[1].sfv05,s_sfv[1].sfv06,s_sfv[1].sfv07
        end construct

        construct g_wc5 on 
            shb01,shb02,shb021,shb03,shb031,shb04,shb05,shb06,shb07,shb08,
            shb081,shb082,shb09,shb10,shb111,shb112,shb113,shb114,shb115,shb12,
            shb13,shb14,shb15,shb16,shb17,shb18,shb19,shb20,shb21,shb22,shb012,shb121,
            shb23,shb24,shb25,shb26,shb28,shb29,shb30,shb31,shb32,shb34,shb032,shb033
            from s_shb[1].shb01,s_shb[1].shb02,s_shb[1].shb021,s_shb[1].shb03,s_shb[1].shb031,s_shb[1].shb04,s_shb[1].shb05,s_shb[1].shb06,s_shb[1].shb07,s_shb[1].shb08,
                 s_shb[1].shb081,s_shb[1].shb082,s_shb[1].shb09,s_shb[1].shb10,s_shb[1].shb111,s_shb[1].shb112,s_shb[1].shb113,s_shb[1].shb114,s_shb[1].shb115,s_shb[1].shb12,
                 s_shb[1].shb13,s_shb[1].shb14,s_shb[1].shb15,s_shb[1].shb16,s_shb[1].shb17,s_shb[1].shb18,s_shb[1].shb19,s_shb[1].shb20,s_shb[1].shb21,s_shb[1].shb22,s_shb[1].shb012,s_shb[1].shb121,
                 s_shb[1].shb23,s_shb[1].shb24,s_shb[1].shb25,s_shb[1].shb26,s_shb[1].shb28,s_shb[1].shb29,s_shb[1].shb30,s_shb[1].shb31,s_shb[1].shb32,s_shb[1].shb34,s_shb[1].shb032,s_shb[1].shb033
        end construct

        construct g_wc6 on
            tscud02,tsc01,tsc21,tsc03,tsc15,tsc16,tsc14,tsc04,tsc05
            from s_tsc[1].tscud02,s_tsc[1].tsc01,s_tsc[1].tsc21,s_tsc[1].tsc03,s_tsc[1].tsc15,
                   s_tsc[1].tsc16,s_tsc[1].tsc14,s_tsc[1].tsc04,s_tsc[1].tsc05
        end construct

        on action controlp
            # 开窗 
        
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

function csfq033_menu()
    while true
        call csfq033_bp()
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
                    call csfq033_q()
                end if
            
            when "exporttoexcel"
                # 导出excel
                if cl_chk_act_auth() then 
                    call cl_download_by_explorer(
                        cl_expexcel10(
                            "s_sfb",base.typeinfo.create(g_sfb_excel),
                            "s_sfa",base.typeinfo.create(g_sfa_excel),
                            "s_sfe",base.typeinfo.create(g_sfe_excel),
                            "s_sfv",base.typeinfo.create(g_sfv_excel),
                            "s_shb",base.typeinfo.create(g_shb_excel),
                            "s_tsc",base.typeinfo.create(g_tsc_excel),
                            "","",
                            "","",
                            "","",
                            "",""
                        )) #darcy:2024/01/18
                    
                end if
        end case
    end while
end function

function csfq033_q()

    let g_rec_b = 0
    
    clear form
    display '' to cnt    

    message ""

    call csfq033_cs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call csfq033_show()
    end if
    message ""

end function

function csfq033_show()
    call csfq033_b_fill()
end function

function csfq033_b_fill()
    define l_sql string
    define l_sfb081  like sfb_file.sfb081
    define l_sfa161  like sfa_file.sfa161
    define l_sfa05   like sfa_file.sfa05
    define l_sfa012  like sfa_file.sfa012,
           l_sfa013  like sfa_file.sfa013
    
    if g_wc1 = " 1=1" then
        call cl_err("","9046",1)
        return
    end if

    let l_sql = "select sfb01,sfb81,sfb02,sfb04,sfb28,sfb22,sfb221,sfb05,sfb06,",
                "       ima01,ima021,sfb08,sfbud07,round(sfb08/sfbud07,3) pnl,",
                "       sfb081,sfb09,sfb12,nvl(sfbud12,0) sfbud12 from sfb_file,ima_file ",
                " where sfb05 = ima01 and ",g_wc1 clipped ,
                " order by sfb81,sfb01"
    prepare csfq033_sfb_p from l_sql
    declare csfq033_sfb_c cursor for csfq033_sfb_p

    let g_cnt = 1
    call g_sfb_excel.clear()
    call g_sfb.clear()
    foreach csfq033_sfb_c into g_sfb_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfq033_sfb_c",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= g_max_rec + 1 then
            let g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfb_excel.deleteElement(g_cnt)
    call g_sfb.deleteElement(g_cnt)

    let l_sql = "select sfa01,sfa03,ima02 ima02_1,ima021 ima021_1,sfa27,sfa28,ecm03,sfa08, ",
                "       sfa26,sfa12,sfa05,sfb081 sfb081_1, 0 sfb081_c,0 sfb081_f,sfa06,0 short_qty, ",
                "       sfa16,sfa161,sfa061,sfa062,sfa11,sfa012,sfa013 ",
                "  from sfa_file left join ecm_file on ecm01 = sfa01 and ecm04 = sfa08,ima_file,sfb_file ",
                " where sfa03 = ima01 and sfa01 = sfb01 and ",g_wc1 clipped ," and ",g_wc2 clipped,
                " order by sfa01,ecm03,sfa03"

    prepare csfq033_sfa_p from l_sql
    declare csfq033_sfa_c cursor for csfq033_sfa_p

    let g_cnt = 1
    call g_sfa_excel.clear()
    call g_sfa.clear()
    foreach csfq033_sfa_c into g_sfa_excel[g_cnt].*,l_sfa012,l_sfa013
        if sqlca.sqlcode then
            call cl_err("csfq033_sfa_c",sqlca.sqlcode,1)
            exit foreach
        end if
        # 发料套数要计算所有替代料 
        select sum(sfa05),sum(sfa06+sfa062) into l_sfa05, l_sfb081 from sfa_file
         where sfa01 = g_sfa_excel[g_cnt].sfa01 and sfa27 = g_sfa_excel[g_cnt].sfa27
               and sfa08 = g_sfa_excel[g_cnt].sfa08 

        select sfb08 * l_sfb081 / l_sfa05 into g_sfa_excel[g_cnt].sfb081_c from sfa_file,sfb_file
         where sfa01 = g_sfa_excel[g_cnt].sfa01 and sfa27 = g_sfa_excel[g_cnt].sfa27
               and sfa08 = g_sfa_excel[g_cnt].sfa08 and sfa161 <> 0
               and sfa01 = sfb01
        if cl_null(g_sfa_excel[g_cnt].sfb081_c) then
            let g_sfa_excel[g_cnt].sfb081_c = 0
        else
            let g_sfa_excel[g_cnt].sfb081_f = g_sfa_excel[g_cnt].sfb081_1 - g_sfa_excel[g_cnt].sfb081_c
        end if
        # 欠料数量
        call s_shortqty(g_sfa_excel[g_cnt].sfa01,g_sfa_excel[g_cnt].sfa03,g_sfa_excel[g_cnt].sfa08,
                      g_sfa_excel[g_cnt].sfa12,g_sfa_excel[g_cnt].sfa27,
                      l_sfa012,l_sfa013)
              returning g_sfa_excel[g_cnt].short_qty
        if g_cnt <= g_max_rec + 1 then
            let g_sfa[g_cnt].* = g_sfa_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfa_excel.deleteElement(g_cnt)
    call g_sfa.deleteElement(g_cnt)

    let l_sql ="select sfe01,sfe04,sfe02,sfe28,sfe07,ima02 ima02_2,ima021 ima021_2,sfe16, ",
               "       sfe17,sfe14,sfe08,sfe09,sfe10 ",
               " from sfe_file,sfb_file,ima_file ",
               " where sfe01 = sfb01 and ima01 = sfe07 and ",g_wc1 clipped,
               " and ",g_wc3 clipped,
               " order by sfe01,sfe04"

    prepare csfq033_sfe_p from l_sql
    declare csfq033_sfe_c cursor for csfq033_sfe_p

    let g_cnt = 1
    call g_sfe_excel.clear()
    call g_sfe.clear()
    foreach csfq033_sfe_c into g_sfe_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfq033_sfe_c",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= g_max_rec + 1 then
            let g_sfe[g_cnt].* = g_sfe_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfe_excel.deleteElement(g_cnt)
    call g_sfe.deleteElement(g_cnt)

    let l_sql = "select sfv11,sfu01,sfu02,sfv03,sfv20,sfv04,ima02 ima02_3 ,ima021 ima021_3, ",
                "       sfv08,sfv09,sfv05,sfv06,sfv07 ",
                " from sfu_file,sfv_file,ima_file,sfb_file ",
                " where sfu01 = sfv01 and ima01 = sfv04 and sfv11 = sfb01 ",
                " and ",g_wc1 clipped," and ",g_wc4 clipped,
                " order by sfv11,sfu01,sfv04"

    prepare csfq033_sfv_p from l_sql
    declare csfq033_sfv_c cursor for csfq033_sfv_p

    let g_cnt = 1
    call g_sfv_excel.clear()
    call g_sfv.clear()
    foreach csfq033_sfv_c into g_sfv_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfq033_sfv_c",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= g_max_rec + 1 then
            let g_sfv[g_cnt].* = g_sfv_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfv_excel.deleteElement(g_cnt)
    call g_sfv.deleteElement(g_cnt)

    let l_sql = "select shb01,shb02,shb021,shb03,shb031,shb04,shb05,shb06,shb07,shb08, ",
                "       shb081,shb082,shb09,shb10,shb111,shb112,shb113,shb114,shb115, ",
                "       shb12,shb13,shb14,shb15,shb16,shb17,shb18,shb19,shb20,shb21, ",
                "       shb22,shb012,shb121,shb23,shb24,shb25,shb26,shb28,shb29,shb30, ",
                "       shb31,shb32,shb34,shb032,shb033 ",
                "  from shb_file,sfb_file ",
                " where shb05 = sfb01 and ",g_wc1 clipped," and ",g_wc5 clipped,
                " order by shb05,shb01 "

    prepare csfq033_shb_p from l_sql
    declare csfq033_shb_c cursor for csfq033_shb_p

    let g_cnt = 1
    call g_shb_excel.clear()
    call g_shb.clear()
    foreach csfq033_shb_c into g_shb_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfq033_shb_c",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= g_max_rec + 1 then
            let g_shb[g_cnt].* = g_shb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_shb_excel.deleteElement(g_cnt)
    call g_shb.deleteElement(g_cnt)

    let l_sql = "select shb16 shb16_1,shb081 shb081_1,shb06 shb06_1,tscud02,sfb01 sfb01_1, ",
                "       tsc01,tsc21,tsc03,tsc15,tsc16,tsc14,tsc04,tsc05,0 pnl ,tscud03 shb16_new",
                "  from shb_file,sfb_file ,tsc_file,ima_file ",
                " where shb05 = sfb01 and tscud02 = shb01 and ima01 = sfb05 and ",g_wc1 clipped,
                " and ",g_wc6 clipped,
                " order by sfb01,shb16"
                
    prepare csfq033_tsc_p from l_sql
    declare csfq033_tsc_c cursor for csfq033_tsc_p

    let g_cnt = 1
    call g_tsc_excel.clear()
    call g_tsc.clear()
    foreach csfq033_tsc_c into g_tsc_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("csfq033_tsc_c",sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt <= g_max_rec + 1 then
            let g_tsc[g_cnt].* = g_tsc_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_tsc_excel.deleteElement(g_cnt)
    call g_tsc.deleteElement(g_cnt)

end function

function csfq033_bp()
    let g_action_choice = " "
    call cl_set_act_visible("accept,cancel", false)
    dialog
        display array g_sfb to s_sfb.*
            on action accept
                let l_ac = arr_curr()
                let g_cmd = "asfq301 ",g_sfb[l_ac].sfb01
                call cl_cmdrun_wait(g_cmd)
        end display
        display array g_sfa to s_sfa.*
            on action accept
                let l_ac = arr_curr()
                let g_cmd = "asfq301 ",g_sfa[l_ac].sfa01
                call cl_cmdrun_wait(g_cmd)
        end display
        display array g_sfe to s_sfe.*
            on action accept
                let l_ac = arr_curr()
                let g_cmd = "asfq301 ",g_sfe[l_ac].sfe01
                call cl_cmdrun_wait(g_cmd)
        end display
        display array g_sfv to s_sfv.*
            on action accept
                let l_ac = arr_curr()
                let g_cmd = "asfq301 ",g_sfv[l_ac].sfv11
                call cl_cmdrun_wait(g_cmd)
        end display
        display array g_shb to s_shb.*
            on action accept
                let l_ac = arr_curr()
                let g_cmd = "asfq301 ",g_shb[l_ac].shb05
                call cl_cmdrun_wait(g_cmd)
        end display
        display array g_tsc to s_tsc.*
            on action accept
                let l_ac = arr_curr()
                let g_cmd = "asfq301 ",g_tsc[l_ac].sfb01_1
                call cl_cmdrun_wait(g_cmd)
        end display

        on action help
            let g_action_choice="help"
            exit dialog
        on action exit
            let g_action_choice="exit"
            exit dialog
        on action controlg
            let g_action_choice="controlg"
            exit dialog
        on action query
            let g_action_choice="query"
            exit dialog 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        on action close
            let g_action_choice = 'close'
            exit dialog
    end dialog
    call cl_set_act_visible("accept,cancel", true)

end function
