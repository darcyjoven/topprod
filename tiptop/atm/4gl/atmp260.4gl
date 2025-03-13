# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: atmp260.4gl
# Descriptions...: 工艺工时维护
# Date & Author..: 2017/04/18 By Wgh
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
type tsc record
    check       like type_file.chr1,
    shb16       like shb_file.shb16,
    shb081      like shb_file.shb081,
    shb06       like shb_file.shb06,
    tscud02     like tsc_file.tscud02,
    sfb01       like sfb_file.sfb01,
    tsc01       like tsc_file.tsc01,
    tsc21       like tsc_file.tsc21,
    tsc15       like tsc_file.tsc15,
    gem02       like gem_file.gem02,
    tsc16       like tsc_file.tsc16,
    gen02       like gen_file.gen02,
    tsc03       like tsc_file.tsc03,
    tsc14       like tsc_file.tsc14,
    tsc04       like tsc_file.tsc04,
    tsc05       like tsc_file.tsc05,
    pnl         like tsc_file.tsc05
end record
define g_tsc dynamic array of tsc,
    g_wc,g_sql     STRING,  
    g_rec_b         LIKE type_file.num5,   
    l_ac            LIKE type_file.num5  
DEFINE   p_row,p_col     LIKE type_file.num5        
DEFINE   g_before_input_done  LIKE type_file.num5 
DEFINE   g_forupd_sql STRING
DEFINE   g_forupd_sql2   STRING            #add by jiangln 170525 
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5    
DEFINE   g_msg           LIKE ze_file.ze03      
define   g_t1                LIKE oay_file.oayslip        #No.FUN-550067  #No.FUN-680121 VARCHAR(5)
 
MAIN
DEFINE p_cmd LIKE type_file.chr1           #add by jiangln 170525
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET p_row = 4 LET p_col = 5

    OPEN WINDOW p260_w AT p_row,p_col WITH FORM "atm/42f/atmp260"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
#    LET g_wc = '1=1' CALL p260_b_fill(g_wc,p_cmd)   #No.TQC-6B0074    #mark by jiangln 170525
    CALL p260_q() 
    CALL p260_menu()
    CLOSE WINDOW p260_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p260_menu()
 
   WHILE TRUE
      CALL p260_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL p260_q() 
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               --CALL p260_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tsc),'','')
            END IF
        when "gen_sfa"
            if cl_chk_act_auth() then
                call p260_gen_asfi301()
                let g_action_choice = ''
            end if
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p260_q()
   CALL p260_b_askkey()
END FUNCTION
 

FUNCTION p260_b_askkey()
DEFINE p_cmd LIKE type_file.chr1   #add by jiangln 170525
    LET p_cmd = 'q'
    CLEAR FORM
    CALL g_tsc.clear()
    CALL cl_opmsg('q')
    call cl_set_act_visible("accept,cancel", true)
    CONSTRUCT g_wc ON shb16,shb081,shb06,tscud02,tsc01,tsc21,tsc15,tsc16,tsc03,tsc14,tsc04,tsc05
                FROM s_tsc[1].shb16,s_tsc[1].shb081,s_tsc[1].shb06,s_tsc[1].tscud02,s_tsc[1].tsc01,
                     s_tsc[1].tsc21,s_tsc[1].tsc15,s_tsc[1].tsc16,s_tsc[1].tsc03,s_tsc[1].tsc14,
                     s_tsc[1].tsc04,s_tsc[1].tsc05
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(shb16)
              WHEN INFIELD(shb081)
              WHEN INFIELD(tscud02)
              WHEN INFIELD(tsc01)
              WHEN INFIELD(tsc03)
              WHEN INFIELD(tc_ecg01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecg10
                 NEXT FIELD tc_ecg10
              OTHERWISE
                 EXIT CASE
           END CASE
           
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
    ON ACTION qbe_select
        CALL cl_qbe_select() 
    ON ACTION qbe_save
        CALL cl_qbe_save()
    END CONSTRUCT
    call cl_set_act_visible("accept,cancel", false)
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
    CALL p260_b_fill(g_wc,p_cmd)
END FUNCTION
 
FUNCTION p260_b_fill(p_wc2,p_cmd)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200) 
DEFINE p_cmd           LIKE type_file.chr1          #add by jiangln 170525


    let g_sql = "select 'N',shb16, shb081, shb06,tscud02,substr(tsc14, 1, 12) sfb01,tsc01,",
                "       tsc21,tsc15,gem02,tsc16,gen02,tsc03,tsc14,tsc04,tsc05,",
                "       case imaud10 when 0 then 0 else tsc05 / imaud10 end pnl",
                " from tsc_file",
                " left join gen_file on gen01 = tsc16",
                " left join gem_file on gem01 = tsc15",
                " left join sfb_file on sfb01 = substr(tsc14, 1, 12)",
                " left join ima_file on ima01 = sfb05, shb_file",
                " where shb01 = tscud02 and tscpost = 'Y'",
                "  and not exists (select sfb01 from sfb_file where sfb01 = tscud03 and sfb87 != 'X')",
                "  and tsc21 >= to_date('230501','yymmdd') ",
                "  and ",p_wc2 clipped," order by shb16"

    PREPARE p260_pb FROM g_sql
    DECLARE pma_curs CURSOR FOR p260_pb
 
    CALL g_tsc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pma_curs INTO g_tsc[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       let g_cnt = g_cnt + 1
    END FOREACH
    CALL g_tsc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION
 
FUNCTION p260_bp(p_ud)
    DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
    define l_i,l_j  integer
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
    call cl_set_act_visible("accept,cancel", false)
    input array g_tsc without defaults from s_tsc.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)
   --DISPLAY ARRAY g_tsc TO s_tsc.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
            call p260_sum()

        ON ACTION query
            LET g_action_choice="query"
            EXIT input
        ON ACTION output
            LET g_action_choice="output"
            EXIT input
        ON ACTION help
            LET g_action_choice="help"
            EXIT input
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
            LET g_action_choice="exit"
            EXIT input
        on action cancel
            LET g_action_choice="exit"
            EXIT input
 
        ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT input 
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE input
 
        ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 

        ON ACTION exporttoexcel       #FUN-4B0025
            LET g_action_choice = 'exporttoexcel'
            EXIT input
        after field check
            call p260_sum()
        on change check
            call p260_sum()
        
        on action checkall
            for l_i = 1 to g_tsc.getlength()
                let g_tsc[l_i].check = 'Y'
            end for
            call p260_sum()
        on action inverse
            for l_i = 1 to g_tsc.getlength()
                let g_tsc[l_i].check = iif(g_tsc[l_i].check='Y','N','Y')
            end for
            call p260_sum()
        on action gen_sfa
            let g_action_choice = 'gen_sfa'
            exit input
  
      AFTER input
         CONTINUE input

    END input
END FUNCTION

# 更行已勾选的数量汇总
function p260_sum()
define l_i,l_j      integer
define l_pcs,l_pnl  like type_file.num15_3

    let l_pcs = 0
    let l_pnl = 0
    let l_j = 0
    for l_i = 1 to g_tsc.getlength()
        if g_tsc[l_i].check!='Y' then
            continue for
        end if
        let l_pcs = l_pcs  + g_tsc[l_i].tsc05
        let l_pnl = l_pnl  + g_tsc[l_i].pnl
        let l_j = l_j + 1
    end for
    display l_pcs,l_pnl,l_j to pcs_sum,pnl_sum,cn1
end function

function p260_gen_asfi301()
    define l_i,l_j,l_cnt  integer
    define l_tsc03  like tsc_file.tsc03
    define l_sfb01  like sfb_file.sfb01
    define l_where,l_sql  string
    define l_sfb    record like sfb_file.*
    define l_ima    record like ima_file.*
    define l_pcs,l_pnl  like type_file.num15_3
    define l_ima928         like ima_file.ima928 
    define l_ima140         like ima_file.ima140 
    define l_ima1401        like ima_file.ima1401
    define l_ima910         like ima_file.ima910 
    define l_ima1010        like ima_file.ima1010
    #darcy:2023/05/16 add s---
    define l_sgm01          like sgm_file.sgm01
    define l_sgm03          like sgm_file.sgm03
    #darcy:2023/05/16 add e---
    let g_success = 'Y'
    #0. 事先检查
    let l_where = "tsc01 in ('misc'"
    let l_pcs = 0
    let l_pnl = 0
    initialize l_sfb.* to null
    let l_sfb.sfb01 = ''
    let l_sgm03 = 0
    let l_sgm01 = ''
    for l_i = 1 to g_tsc.getLength()
        if g_tsc[l_i].check != 'Y' then
            continue for
        end if
        #0.1 选择的工单半成品料号是否相同
        if cl_null(l_tsc03) then
            let l_tsc03 = g_tsc[l_i].tsc03
        end if
        if g_tsc[l_i].tsc03 != l_tsc03 then
            call cl_err(g_tsc[l_i].tsc03||'|'||l_tsc03,'ctm-001',1)
            let g_success = 'N'
            exit for
        end if
        #0.2 是否都还未生成新工单
        let l_sfb01 = ''
        select sfb01 into l_sfb01 from sfb_file,tsc_file 
         where sfb01 = tscud03 and tsc01 = g_tsc[l_i].tsc01 and sfb87 != 'X'
        if not cl_null(l_sfb01) then
            call cl_err(g_tsc[l_i].tsc01||'|'||l_sfb01,'ctm-002',1)
            let g_success = 'N'
            exit for
        end if
        let l_where = l_where,",'",g_tsc[l_i].tsc01,"'"
        let l_pcs = l_pcs  + g_tsc[l_i].tsc05
        let l_pnl = l_pnl  + g_tsc[l_i].pnl
        if cl_null(l_sfb.sfb01) then
            let l_sfb.sfb01 = g_tsc[l_i].sfb01[1,3]
            let l_sgm03 = cl_replace_str(cl_replace_str(g_tsc[l_i].tsc14,g_tsc[l_i].sfb01,''),'-','')
            let l_sgm01 = g_tsc[l_i].shb16
        end if
    end for
    call g_tsc.deleteElement(l_i)
    if g_success='N' then
        # close p260_cl
        rollback work
        return
    end if
    
    #1. 获取新料号和版本
    open window p260_sub1 at 6,3 with form "atm/42f/atmp260_1"
        attribute (style = g_win_style clipped)
    call cl_ui_locale("atmp260_1")

    # let l_sfb.sfb01 = g_tsc[l_i].sfb01[1,3]
    let l_sfb.sfb81 = g_today
    let l_sfb.sfb071 = g_today
    let l_sfb.sfb08 = l_pcs
    let l_sfb.sfbud07 = l_pnl
    #下线步数

    call cl_set_act_visible("accept,cancel",true)
    input l_sfb.sfb01,l_sfb.sfb81,l_sfb.sfb05,l_sfb.sfb06,
          l_sfb.sfb071,l_sfb.sfb08,l_sfb.sfbud07,l_sgm03
        without defaults
        from sfb01,sfb81,sfb05,sfb06,sfb071,sfb08,sfbud07,sgm03
        
            
        before input

        on action controlp
            case
                when infield(sfb01)
                    let g_t1 = s_get_doc_no(l_sfb.sfb01)
                    let l_sql = " (smy73 <> 'Y' or smy73 is null)"  
                    call smy_qry_set_par_where(l_sql)
                    call q_smy( false,true,g_t1,'ASF','1') returning g_t1  
                    let l_sfb.sfb01=g_t1
                    display l_sfb.sfb01 to sfb01
                    next field sfb01
                when infield(sfb05)
                    call q_sel_ima(false, "q_ima18","",l_sfb.sfb05,"","","","","",'' )
                        returning l_sfb.sfb05
                    display by name l_sfb.sfb05
                    next field sfb05
                otherwise
            end case
        
        after field sfb05
            if not cl_null(l_sfb.sfb05) then 
                if not s_chk_item_no(l_sfb.sfb05,"") then
                    call cl_err('',g_errno,1)
                    next field sfb05
                end if 
                let l_ima928 = 'N'
                select ima928 into l_ima928 from ima_file
                where ima01 = l_sfb.sfb05
                if l_ima928 = 'Y' then
                    let l_cnt = 0
                    select count(*) into l_cnt from bmm_file
                    where bmm01 = l_sfb.sfb05
                        and bmm05 = 'Y'
                    if l_cnt = 0 then 
                        call cl_err('','ima-001',1)
                        next field sfb05
                    end if 
                end if 
                if not s_chkima08(l_sfb.sfb05) then
                    next field current
                end if 
                select ima140,ima1401,ima910 into l_ima140,l_ima1401,l_ima910 from ima_file 
                where ima01=l_sfb.sfb05
                if l_ima140 = 'Y' and l_ima1401 <= l_sfb.sfb81 then
                    call cl_err('','asf-960',1)
                    next field sfb05
                end if 
                if l_sfb.sfb05 matches 'misc*' then
                    call cl_err('','asf-306',1)
                    next field sfb05
                end if 
                if g_sma.sma118 ='Y' then
                    let l_sfb.sfb95 = l_ima910
                end if
                        
                select ima1010 into l_ima1010 from ima_file
                    where ima01 = l_sfb.sfb05
                if l_ima1010 <> '1' then
                    call cl_err('','atm-380',1)
                    next field sfb05
                end if
                if not cl_null(g_errno) then
                    call cl_err(l_sfb.sfb82,g_errno,1)
                    next field sfb05
                end if
            
                select count(*) into g_cnt from ima_file
                where ima01=l_sfb.sfb05 and ima911='Y'
                if g_cnt>0 then
                    call cl_err('','asr-040',1)
                    next field sfb05
                end if
                select * into l_ima.* from ima_file where ima01=l_sfb.sfb05
                if status then
                    call cl_err3("sel","ima_file",l_sfb.sfb05,"",status,"","sel ima",1) 
                        next field sfb05
                end if
                select max(ecu02) into l_sfb.sfb06 from ecu_file where ecu01 =l_sfb.sfb05
                    and ecuud02 ='Y' and ecu10='Y'
            end if
        
        after field sfb06
            if not cl_null(l_sfb.sfb06) and not cl_null(l_sfb.sfb06) then
                select count(1) into l_cnt from ecu_file 
                    where ecu01 = l_sfb.sfb05 and ecu02 = l_sfb.sfb06
                    and ecuud02 ='Y' and ecu10='Y'
                if l_cnt = 0 then
                    call cl_err('','mfg4030',1)
                    next field sfb06
                end if
            end if
        
        after field sgm03
            if not cl_null(l_sgm03) then
                let l_cnt = 0
                select count(1) into l_cnt from sgm_file where sgm01 = l_sgm01 and sgm03 = l_sgm03
                if l_cnt = 0 then
                    call cl_err(l_sgm01,'ctm-005',1)
                    next field sgm03
                end if
            end if

        after field sfb071

        on action accept
            exit input

        on action cancel
            let g_success = 'N'
            exit input 
    end input
    call cl_set_act_visible("accept,cancel",false)
    close window p260_sub1
    if g_success = 'N' then
        return
    end if

    begin work
    #0.3 开启事务，将atmt260单据锁定，不允许修改
    let l_sql = "select * from tsc_file where ",l_where,") for update nowait"
    declare p260_cl cursor from l_sql
    open p260_cl
    if sqlca.sqlcode then
        call cl_err("lock tsc:",sqlca.sqlcode,1)
        close p260_cl
        rollback work
        let g_success = 'N'
        return
    end if


    # 接受资料
    #2. 组合单头资料
    call p260_gen_sfb(l_sfb.sfb01,l_sfb.sfb81,l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071,l_sfb.sfb08,l_sfb.sfbud07)
        returning l_sfb.sfb01
    if g_success ='N' then
        close p260_cl
        rollback work
        return
    end if
    #3. 产生单身资料
    if not p260_gen_sfa(l_sfb.sfb01) then
        let g_success ='N'
        close p260_cl
        rollback work
        return
    end if

    if not p260_del_sfb(l_sfb.sfb01,l_sgm03,l_tsc03) then
        let g_success ='N'
        close p260_cl
        rollback work
        return
    end if

    #4 更新下线单据上的工单号
    for l_i = 1 to g_tsc.getLength()
        if g_tsc[l_i].check != 'Y' then
            continue for
        end if
        update tsc_file set tscud03 = l_sfb.sfb01
         where tsc01 = g_tsc[l_i].tsc01
        if sqlca.sqlcode then
            call cl_err(g_tsc[l_i].tsc01,sqlca.sqlcode,1)
            let g_success = 'N'
            rollback work
            exit for
        end if
    end for
    call g_tsc.deleteElement(l_i)

    if g_success = 'Y' then
        commit work
        if cl_confirm('ctm-003') then
            call cl_cmdrun_wait("asfi301 '"||l_sfb.sfb01||"' 'query'")
        end if
        message "工单生成成功，单号："||l_sfb.sfb01||"。"
    else
        rollback work
    end if

end function

function p260_gen_sfb(
    p_sfb01,p_sfb81,p_sfb05,p_sfb06,p_sfb071,p_sfb08,p_sfbud07
)
    define p_sfb01          like sfb_file.sfb01  
    define p_sfb81          like sfb_file.sfb81  
    define p_sfb05          like sfb_file.sfb05  
    define p_sfb06          like sfb_file.sfb06  
    define p_sfb071         like sfb_file.sfb071 
    define p_sfb08          like sfb_file.sfb08  
    define p_sfbud07        like sfb_file.sfbud07

    define l_sfb        record like sfb_file.*
    define l_item       like ima_file.ima571
    define l_cnt        integer

    define li_result    like type_file.num5
    define l_smy57      like smy_file.smy57
    define l_imaud10    like ima_file.imaud10

    initialize l_sfb.* to null

    let l_sfb.sfb01   = p_sfb01  
    let l_sfb.sfb81   = p_sfb81  
    let l_sfb.sfb05   = p_sfb05  
    let l_sfb.sfb06   = p_sfb06  
    let l_sfb.sfb071  = p_sfb071 
    let l_sfb.sfb08   = p_sfb08  
    let l_sfb.sfbud07  = p_sfbud07 

    let l_sfb.sfb02 =  '1'  --工单类型
    let l_sfb.sfb04 = '1'
    select ima35,ima36,ima571
      into l_sfb.sfb30,l_sfb.sfb31,l_item
      from ima_file
     where ima01=l_sfb.sfb05 and imaacti= 'Y'

    if sqlca.sqlcode then
        call s_errmsg('ima01',l_sfb.sfb05,'select ima35','aom-198',1)
        let g_success = 'N'
        return ''
    end if
    if cl_null(l_item) then let l_item=l_sfb.sfb05 end if

    let l_cnt = 0
    if not cl_null(l_sfb.sfb06) and g_sma.sma542 = 'Y' then
        select count(*) into l_cnt from bra_file
            where bra01=l_sfb.sfb05
            and bra05 is not null
            and bra05 <=l_sfb.sfb81
            and bra06 = ' '
            and bra011 = l_sfb.sfb06
            and braacti = 'Y' 
    end if
    if l_cnt = 0 then
        select count(*) into l_cnt from bma_file
        where bma01=l_sfb.sfb05
        and bma05 is not null
        and bma05 <=l_sfb.sfb81
        and bma06 = ' '
        and bmaacti = 'Y'
    end if

    if l_cnt = 0 then
        call s_errmsg('bom',l_sfb.sfb05,'select bom','mfg5071',1)
        let g_success = 'N'
        return ''
    end if

    let l_sfb.sfb081= 0
    let l_sfb.sfb09 = 0
    let l_sfb.sfb10 = 0
    let l_sfb.sfb11 = 0
    let l_sfb.sfb111= 0
    let l_sfb.sfb121= 0
    let l_sfb.sfb122= 0
    let l_sfb.sfb12 = 0

    let l_sfb.sfb13 = g_today
    let l_sfb.sfb15 = g_today
    let l_sfb.sfb23 = 'Y'
    let l_sfb.sfb24 = 'N'
    let l_sfb.sfb251= l_sfb.sfb81
    let l_sfb.sfb27 = ' '
    let l_sfb.sfb29 = 'Y'
    let l_sfb.sfb39 = '1'
    let l_sfb.sfb85 = ' '
    let l_sfb.sfb86 = ' '
    let l_sfb.sfb89 = ' '
    let l_sfb.sfb87 = 'N'
    let l_sfb.sfb91 = ' '
    let l_sfb.sfb92 = NULL
    let l_sfb.sfb87 = 'N'
    let l_sfb.sfb41 = 'N'
    let l_sfb.sfb44 = g_user

    let l_sfb.sfb43 = '0'
    let l_sfb.sfb99 = 'N'
    let l_sfb.sfb98 ='B12'
    let l_sfb.sfbacti = 'Y'
    let l_sfb.sfbuser = g_user
    let l_sfb.sfbgrup = g_grup
    let l_sfb.sfbdate = g_today
    let l_sfb.sfb1002='N'

    let l_sfb.sfbplant = g_plant
    let l_sfb.sfblegal = g_legal
    let l_sfb.sfb93 = 'Y'

    select smy57 into l_smy57 from smy_file where smyslip=l_sfb.sfb01
    let l_sfb.sfb94 = l_smy57[2,2]

    select ima34 into l_sfb.sfb98 from ima_file
     where ima01 = l_sfb.sfb05
    
    let l_sfb.sfboriu = g_user
    let l_sfb.sfborig = g_grup
    let l_sfb.sfb104 = 'N'

    let l_imaud10 = ''
    select imaud10 into l_sfb.sfbud10 from ima_file where ima01 = l_sfb.sfb05

    if cl_null(l_sfb.sfbud10) or l_sfb.sfbud10 = 0 then 
        let l_sfb.sfbud10 = 1
    end if

    call s_auto_assign_no("asf",l_sfb.sfb01,l_sfb.sfb81,"","","","","","")
            returning li_result,l_sfb.sfb01 
    if (not li_result) then                                    
        call s_errmsg('smyslip',l_sfb.sfb01,'s_auto_assign_no','asf-963',1) 
        let g_success='N'
        close p260_cl
        rollback work
        return ''
    end if

    insert into sfb_file values(l_sfb.*)
    if sqlca.sqlcode then
        call s_errmsg('sfb05',l_sfb.sfb05,'insert sfb','asf-738',1)
        let g_success='N'
        close p260_cl
        rollback work
        return ''
    end if

    if l_sfb.sfb93='Y' then
        call s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,
                        l_sfb.sfb06,l_sfb.sfb02,l_item,l_sfb.sfb08,2)
            returning l_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
        end if
        let l_sfb.sfb13=g_today
        let l_sfb.sfb15=g_today

        if l_sfb.sfb24 is not null then
        update sfb_file
            set sfb24= l_sfb.sfb24 
            where sfb01=l_sfb.sfb01 
        if sqlca.sqlcode then 
            call s_errmsg('sfb05',l_sfb.sfb05,'update sfb',sqlca.sqlcode,1)
            let g_success='N'
            close p260_cl
            rollback work
            return ''
        end if
    end if 

    return l_sfb.sfb01
end function
function p260_gen_sfa(p_sfb01)
    define p_sfb01      like sfb_file.sfb01
    define l_minopseq,l_cnt   integer
    define l_sfb        record like sfb_file.*

    select * into l_sfb.* from sfb_file where sfb01 = p_sfb01

    let l_minopseq = 0
    call s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) 
        returning l_minopseq
    
    let l_cnt = 0
    call s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                 l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                 'Y',l_sfb.sfb95)
        returning l_cnt
    
    if l_cnt = 0 then
        call s_errmsg('sfb05',l_sfb.sfb05,'s_cralc error','asf-385',1)
        let g_success = 'N' 
        close p260_cl
        rollback work
        return ''
    end if

    #下线工单不需要产生子工单
    # call p301(l_sfb.sfb01, l_sfb.sfb81, 99, 'N', true)
    # let g_success = 'Y'

    call p260_chk_sfb39(l_sfb.sfb01)
    return true
end function

function p260_chk_sfb39(l_sfb01)
    define l_cnt      like type_file.num5
    define l_cnt2     like type_file.num5
    define l_sfb01    like sfb_file.sfb01
    define l_sfb01_2  like sfb_file.sfb01

    let l_cnt=0
    select count(*) into l_cnt from sfa_file
    where sfa01  = l_sfb01
        and sfa11 != 'E' and sfa11 !='X'          
    if l_cnt = 0 then
        update sfb_file set sfb39='2' where sfb01=l_sfb01
    end if

    let l_cnt=0
    select count(*) into l_cnt from sfb_file
    where sfb86  = l_sfb01

    if l_cnt>0 then
        declare p304_cur1 cursor for
        select sfb01 from sfb_file where sfb86  = l_sfb01

        foreach p304_cur1 into l_sfb01_2
        let l_cnt2=0
        select count(*) into l_cnt2 from sfa_file
            where sfa01  = l_sfb01_2
            and sfa11 != 'E' 
        if l_cnt2 = 0 then 
            update sfb_file set sfb39='2' where sfb01=l_sfb01_2
        end if
        end foreach
    end if
end function

# 下线处理 
function p260_del_sfb(p_sfb01,p_sgm03,p_tsc03)
    define p_sfb01      like sfb_file.sfb01
    define p_sgm03      like sgm_file.sgm03
    define p_tsc03      like tsc_file.tsc03
    define l_sfa        record like sfa_file.*

    # 删除sfa
    delete from sfa_file where sfa08 in (
        SELECT ecm04 FROM ecm_file WHERE ecm01 =p_sfb01 AND ecm03 < p_sgm03
    ) and sfa01 = p_sfb01 --and sfb87 ='N'
    if sqlca.sqlcode then
        call cl_err('del sfa',sqlca.sqlcode,1)
        return false
    end if
    initialize l_sfa.* to null
    let l_sfa.sfa01 = p_sfb01
    let l_sfa.sfa02 = '1'
    let l_sfa.sfa03 = p_tsc03
    let l_sfa.sfa04 = 0
    let l_sfa.sfa06 = 0
    select sfb05,sfb08 into l_sfa.sfa29,l_sfa.sfa05 from sfb_file where sfb01 = p_sfb01
    let l_sfa.sfa061 = 0
    let l_sfa.sfa062 = 0
    let l_sfa.sfa063 = 0
    let l_sfa.sfa064 = 0
    let l_sfa.sfa065 = 0
    let l_sfa.sfa066 = 0
    let l_sfa.sfa07 = 0
    select ecm04 into l_sfa.sfa08 from ecm_file where ecm01 = p_sfb01 and ecm03 = p_sgm03
    let l_sfa.sfa09 = 0
    let l_sfa.sfa11 = 'N'
    let l_sfa.sfa12 = 'PCS'
    let l_sfa.sfa13 = 1
    let l_sfa.sfa14 = 'PCS'
    let l_sfa.sfa15 = 1
    let l_sfa.sfa16 = 0
    let l_sfa.sfa161 = 1
    let l_sfa.sfa25 = 1
    let l_sfa.sfa26 = '0'
    let l_sfa.sfa27 = p_tsc03
    let l_sfa.sfa28 = 1
    let l_sfa.sfa100 = 0
    let l_sfa.sfaacti = 'Y'
    let l_sfa.sfa32 = 'N'
    let l_sfa.sfaplant = 'FOREWIN'
    let l_sfa.sfalegal = 'FOREWIN'
    let l_sfa.sfa012 = ' '
    let l_sfa.sfa013 = 0

    # 下线料号加入sfa
    insert into sfa_file values (l_sfa.*)
    if sqlca.sqlcode then
        call cl_err('ins sfa',sqlca.sqlcode,1)
        return false
    end if
    # 删除ecm

    delete from ecm_file where ecm01 = p_sfb01 and ecm03 < p_sgm03
    if sqlca.sqlcode then
        call cl_err('del ecm',sqlca.sqlcode,1)
        return false
    end if
    return true

end function

