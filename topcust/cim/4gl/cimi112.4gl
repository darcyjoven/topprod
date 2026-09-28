# prog. version..: '5.30.06-13.03.28(00010)'     #
#
# pattern name...: cimi112.4gl
# descriptions...: 规格设定作业
# date & author..: 22/09/08  by  darcy 
 
database ds
 
globals "../../../tiptop/config/top.global"

type m_tc_cma  record
            tc_cma05    like tc_cma_file.tc_cma05,
            tc_cma06    like tc_cma_file.tc_cma06,
            tc_cma07    like tc_cma_file.tc_cma07
        end record
type m_tc_cmb  record
            tc_cmb04    like tc_cmb_file.tc_cmb04,
            tc_cmb05    like tc_cmb_file.tc_cmb05,
            tc_cmb06    like tc_cmb_file.tc_cmb06,
            tc_cmb07    like tc_cmb_file.tc_cmb07
        end record
type m_tc_cmc  record
            tc_cmc05    like tc_cmc_file.tc_cmc05,
            tc_cmc06    like tc_cmc_file.tc_cmc06,
            tc_cmc07    like tc_cmc_file.tc_cmc07
        end record

define g_tc_cma dynamic array of m_tc_cma
define g_tc_cmb dynamic array of m_tc_cmb
define g_tc_cmc dynamic array of m_tc_cmc
define g_tc_cma_t  m_tc_cma
define g_tc_cmb_t  m_tc_cmb
define g_tc_cmc_t  m_tc_cmc

define g_tc_cma01 like tc_cma_file.tc_cma01
define g_imz02    like imz_file.imz02
define g_tc_cma02 like tc_cma_file.tc_cma02
define g_tc_cma03 like tc_cma_file.tc_cma03
define g_tc_cma04 like tc_cma_file.tc_cma04
define g_tc_cma05 like tc_cma_file.tc_cma05
define g_tc_cmb04 like tc_cmb_file.tc_cmb04

define g_curs_index,g_jump,g_row_count like type_file.num5
define g_msg string
define mi_no_ask like type_file.chr1
 

define
    g_wc2,g_wc,g_sql     string,#tqc-630166
    g_rec_b         like type_file.num5,
    g_rec_b2        like type_file.num5,
    g_rec_b3        like type_file.num5,
    l_ac            like type_file.num5,
    l_ac2           like type_file.num5,
    l_ac3           like type_file.num5,
    l_sl            like type_file.num5           #no.fun-680122 smallint          #目前處理的screen line
 
define   g_forupd_sql string   #select ... for update sql
define   g_cnt           like type_file.num10            #no.fun-680122 integer
define   g_i             like type_file.num5     #count/index for any purpose        #no.fun-680122 smallint
define   g_cka00      like cka_file.cka00    #fun-c80092 add
 
main
    options                                #改變一些系統預設值
        input no wrap
    defer interrupt                        #擷取中斷鍵, 由程式處理
 
   if (not cl_user()) then
      exit program
   end if
  
   whenever error call cl_err_msg_log
  
   if (not cl_setup("CIM")) then
      exit program
   end if
 
   call  cl_used(g_prog,g_time,1) returning g_time 
 
    open window i112_w with form "cim/42f/cimi112"
       attribute (style = g_win_style clipped) #no.fun-580092 hcn
    
    call cl_ui_init()
    
    call i112_declare()

    #call cl_set_comp_visible("ima391",g_aza.aza63='y')  #fun-740096
 
    let g_wc2 = '1=1'
    call i112_menu()
    close window i112_w                 #結束畫面
 
    call  cl_used(g_prog,g_time,2) returning g_time
end main

function i112_declare()
    define  l_sql   string

    let l_sql = "select tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07 from tc_cmb_file ",
                " where tc_cmb01 = ? and tc_cmb02 = ? and tc_cmb03 =? ",
                " order by tc_cmb04"
    prepare tc_cmb_p from l_sql 
    declare tc_cmb_cur cursor for tc_cmb_p
    let l_sql = "select tc_cmc05,tc_cmc06,tc_cmc07 from tc_cmc_file ",
                " where tc_cmc01 = ? and tc_cmc02 =? and tc_cmc03 =? and tc_cmc04=?",
                " order by tc_cmc05"
    prepare tc_cmc_p from l_sql 
    declare tc_cmc_cur cursor for tc_cmc_p

    let l_sql = "select tc_cma05,tc_cma06,tc_cma07 from tc_cma_file where tc_cma01 = ? and tc_cma02 = ? and tc_cma05 =?",
                " for update"
    declare tc_cma_bcl cursor from l_sql
    let l_sql = "select tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07 from tc_cmb_file where tc_cmb01 = ? and tc_cmb02 = ? ",
                " and tc_cmb03 = ? and tc_cmb04 =? for update"
    declare tc_cmb_bcl cursor from l_sql
    let l_sql = "select tc_cmc05,tc_cmc06,tc_cmc07  from tc_cmc_file where tc_cmc01 = ? and tc_cmc02 = ? ",
                " and tc_cmc03 = ? and tc_cmc04 = ? and tc_cmc05 =? for update"
    declare tc_cmc_bcl cursor from l_sql

    let l_sql = " select tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07 from tc_cmb_file ",
                "  where tc_cmb01 = ? and tc_cmb02 = ? and tc_cmb03 = ? order by tc_cmb04 "
    prepare tc_cmb_f from l_sql
    declare tc_cmb_fill cursor for tc_cmb_f

    let l_sql = " select tc_cmc05,tc_cmc06,tc_cmc07 from tc_cmc_file ",
                "  where tc_cmc01 = ? and tc_cmc02 = ? and tc_cmc03 = ? order by tc_cmc04 "
    prepare tc_cmc_f from l_sql
    declare tc_cmc_fill cursor for tc_cmc_f
end function
 
function i112_menu()
   while true
      call i112_bp("g")
      case g_action_choice
         when "query"  
            if cl_chk_act_auth() then
               call i112_q() 
            end if
         when "detail"
           if cl_chk_act_auth() then
              call i112_b() 
           else
              let g_action_choice = null
           end if
         when "detail"
           if cl_chk_act_auth() then
                call i112_i()
           end if
         when "insert"
            if cl_chk_act_auth() then
                call i112_i()
            end if
         when "help"
            call cl_show_help()
         when "exit"
            exit while
         when "controlg"
            call cl_cmdask()
         #when "exporttoexcel"
         #   call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(tc_cma_curs),'','')
      end case
   end while
end function
 
 
function i112_q()
   call i112_b_askkey()
end function
 
function i112_b()
define
    l_ac_t          like type_file.num5,                #未取消的array cnt        #no.fun-680122 smallint
    l_n             like type_file.num5,                #檢查重複用               #no.fun-680122 smallint
    l_lock_sw       like type_file.chr1,                #單身鎖住否               #no.fun-680122 varchar(1)
    p_cmd           like type_file.chr1,                #處理狀態                 #no.fun-680122 varchar(1)
    l_jump          like type_file.num5,                                          #no.fun-680122 smallint,              #判斷是否跳過after row的處理
    l_allow_insert  like type_file.num5,                #可新增否                 #no.fun-680122 smallint
    l_allow_delete  like type_file.num5                 #可刪除否                 #no.fun-680122 smallint
 
    let g_action_choice = ""
    if s_shut(0) then return end if
    call cl_opmsg('b')    
 
    #mod-550126................begin
    #let l_allow_insert = cl_detail_input_auth("insert")
    #let l_allow_delete = cl_detail_input_auth("delete")
    let l_allow_insert = true
    let l_allow_delete = true
    #mod-550126................begin

    dialog
        input array g_tc_cma from s_tc_cma.*
            attributes(count=g_rec_b,maxcount=g_max_rec,
                        insert row=l_allow_insert,delete row=l_allow_delete,append row=l_allow_insert)
            before input
                if g_rec_b != 0 then
                    call fgl_set_arr_curr(l_ac)
                end if
            
            before insert
                let l_n = arr_count()
                let p_cmd='a'
                initialize g_tc_cma[l_ac].* to null

                call cl_show_fld_cont()
                next field tc_cma05
                
            after insert
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = true
                    cancel insert
                end if
                insert into tc_cma_file (
                    tc_cma01,tc_cma02,tc_cma03,tc_cma05,tc_cma06,tc_cma07
                )values (
                    g_tc_cma01,g_tc_cma02,g_tc_cma03,g_tc_cma[l_ac].tc_cma05
                    ,g_tc_cma[l_ac].tc_cma06,g_tc_cma[l_ac].tc_cma07
                )
                if sqlca.sqlcode then
                    call cl_err("ins tc_cma",g_tc_cma01,1)
                    cancel insert
                    rollback work
                else
                    message 'INSERT O.K'
                    let g_rec_b=g_rec_b+1 
                    commit work
                end if

            before row
                let l_ac = arr_curr()
                let l_n  = arr_count()
                let l_lock_sw = 'n'
                if g_rec_b >= l_ac then
                    # 新增一笔
                    let p_cmd = 'u'
                    let g_tc_cma_t.* = g_tc_cma[l_ac].*
                    let g_tc_cma05 = g_tc_cma_t.tc_cma05
                    call i112_b2_fill()
                    begin work

                    open tc_cma_bcl using g_tc_cma01,g_tc_cma02,g_tc_cma_t.tc_cma05
                    if status then
                        call cl_err("open tc_cma_bcl",status,1)
                        let l_lock_sw = "Y"
                    else
                        fetch tc_cma_bcl into g_tc_cma[l_ac].*
                        if sqlca.sqlcode then
                            call cl_err(
                                g_tc_cma01||g_tc_cma02||g_tc_cma_t.tc_cma05,
                                sqlca.sqlcode,
                                1
                                )
                            let l_lock_sw = "Y"
                        end if
                        call cl_show_fld_cont()
                    end if
                end if
            
            before field tc_cma05
                if g_tc_cma[l_ac].tc_cma05 is null or g_tc_cma[l_ac].tc_cma05 = 0 then
                    select max(tc_cma05)+1 into g_tc_cma[l_ac].tc_cma05 from tc_cma_file
                    where tc_cma01=g_tc_cma01 and tc_cma02=g_tc_cma02 
                    if g_tc_cma[l_ac].tc_cma05 is null then
                        let g_tc_cma[l_ac].tc_cma05 = 1
                    end if
                end if
            
            on row change
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = true
                    let g_tc_cma[l_ac].* = g_tc_cma_t.*
                    close tc_cma_bcl
                    rollback work
                    exit dialog
                end if
                if l_lock_sw = 'Y' then
                    call cl_err(g_tc_cma01||g_tc_cma02||g_tc_cma_t.tc_cma05,-263,1)
                    let g_tc_cma[l_ac].* = g_tc_cma_t.*
                else
                    update tc_cma_file 
                       set tc_cma05 = g_tc_cma[l_ac].tc_cma05,
                           tc_cma06 = g_tc_cma[l_ac].tc_cma06,
                           tc_cma07 = g_tc_cma[l_ac].tc_cma07
                     where tc_cma01= g_tc_cma01 
                       and tc_cma02 = g_tc_cma02
                       and tc_cma05 = g_tc_cma_t.tc_cma05
                    
                    if sqlca.sqlcode then
                        call s_errmsg('tc_cma01',g_tc_cma01||g_tc_cma02||g_tc_cma_t.tc_cma05,'upd ima:',sqlca.sqlcode,1)                           #no.fun-710027 
                        rollback work
                    else
                        commit work
                    end if
                end if
            after row
        end input
        
        input array g_tc_cmb from s_tc_cmb.*
            attributes(count=g_rec_b2,maxcount=g_max_rec,
                        insert row=l_allow_insert,delete row=l_allow_delete,append row=l_allow_insert)
            before input
                if g_rec_b2 != 0 then
                    call fgl_set_arr_curr(l_ac)
                end if
            
            before insert
                let l_n = arr_count()
                let p_cmd='a'
                initialize g_tc_cmb[l_ac].* to null

                call cl_show_fld_cont()
                next field tc_cmb04
                
            after insert
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = true
                    cancel insert
                end if
                insert into tc_cmb_file (
                    tc_cmb01,tc_cmb02,tc_cmb03,tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07
                )values (
                    g_tc_cma01,g_tc_cma02,g_tc_cma05,g_tc_cmb[l_ac].tc_cmb04,
                    g_tc_cmb[l_ac].tc_cmb05,g_tc_cmb[l_ac].tc_cmb06,g_tc_cmb[l_ac].tc_cmb07
                )
                if sqlca.sqlcode then
                    call cl_err("ins tc_cmb",g_tc_cma01,1)
                    cancel insert
                    rollback work
                else
                    message 'INSERT O.K'
                    let g_rec_b2 = g_rec_b2+1 
                    commit work
                end if

            before row
                let l_ac = arr_curr()
                let l_n  = arr_count()
                let l_lock_sw = 'n'
                if g_rec_b2 >= l_ac then
                    # 新增一笔
                    let p_cmd = 'u'
                    let g_tc_cmb_t.* = g_tc_cmb[l_ac].*
                    let g_tc_cmb04 = g_tc_cmb[l_ac].tc_cmb04
                    call i112_b3_fill()
                    begin work

                    open tc_cmb_bcl using g_tc_cma01,g_tc_cma02,g_tc_cma05,g_tc_cmb[l_ac].tc_cmb04
                    if status then
                        call cl_err("open tc_cmb_bcl",status,1)
                        let l_lock_sw = "Y"
                    else
                        fetch tc_cmb_bcl into g_tc_cmb[l_ac].*
                        if sqlca.sqlcode then
                            call cl_err(
                                g_tc_cma01||g_tc_cma02||g_tc_cma05||g_tc_cmb[l_ac].tc_cmb04,
                                sqlca.sqlcode,
                                1
                                )
                            let l_lock_sw = "Y"
                        end if
                        call cl_show_fld_cont()
                    end if
                end if
            
            before field tc_cmb04
                if g_tc_cmb[l_ac].tc_cmb04 is null or g_tc_cmb[l_ac].tc_cmb04 = 0 then
                    select max(tc_cmb04)+1 into g_tc_cmb[l_ac].tc_cmb04 from tc_cmb_file
                    where tc_cmb01=g_tc_cma01 and tc_cmb02=g_tc_cma02 and tc_cmb03 = g_tc_cma05
                    if g_tc_cmb[l_ac].tc_cmb04 is null then
                        let g_tc_cmb[l_ac].tc_cmb04 = 1
                    end if
                end if
            
            on row change
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = true
                    let g_tc_cmb[l_ac].* = g_tc_cmb_t.*
                    close tc_cmb_bcl
                    rollback work
                    exit dialog
                end if
                if l_lock_sw = 'Y' then
                    call cl_err(g_tc_cma01||g_tc_cma02||g_tc_cma05,-263,1)
                    let g_tc_cmb[l_ac].* = g_tc_cmb_t.*
                else
                    update tc_cmb_file 
                       set tc_cmb04 = g_tc_cmb[l_ac].tc_cmb04,
                           tc_cmb05 = g_tc_cmb[l_ac].tc_cmb05,
                           tc_cmb06 = g_tc_cmb[l_ac].tc_cmb06,
                           tc_cmb07 = g_tc_cmb[l_ac].tc_cmb07
                     where tc_cmb01= g_tc_cma01 
                       and tc_cmb02 = g_tc_cma02
                       and tc_cmb03 = g_tc_cma05
                       and tc_cmb04 = g_tc_cmb[l_ac].tc_cmb04
                    
                    if sqlca.sqlcode then
                        call s_errmsg('tc_cmb01',g_tc_cma01||g_tc_cma02||g_tc_cma05||g_tc_cmb[l_ac].tc_cmb04,'upd tc_cmb:',sqlca.sqlcode,1)
                        rollback work
                    else
                        commit work
                    end if
                end if
            after row
        end input

        input array g_tc_cmc from s_tc_cmc.*
            attributes(count=g_rec_b3,maxcount=g_max_rec,
                        insert row=l_allow_insert,delete row=l_allow_delete,append row=l_allow_insert)
            before input
                if g_rec_b3 != 0 then
                    call fgl_set_arr_curr(l_ac)
                end if
            
            before insert
                let l_n = arr_count()
                let p_cmd='a'
                initialize g_tc_cmc[l_ac].* to null

                call cl_show_fld_cont()
                next field tc_cmc05
                
            after insert
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = true
                    cancel insert
                end if
                insert into tc_cmc_file (
                    tc_cmc01,tc_cmc02,tc_cmc03,tc_cmc04,tc_cmc05,tc_cmc06,tc_cmc07
                )values (
                    g_tc_cma01,g_tc_cma02,g_tc_cma05,g_tc_cmb04,
                    g_tc_cmc[l_ac].tc_cmc05,g_tc_cmc[l_ac].tc_cmc06,g_tc_cmc[l_ac].tc_cmc07
                )
                if sqlca.sqlcode then
                    call cl_err("ins tc_cmc",g_tc_cmc[l_ac].tc_cmc05,1)
                    cancel insert
                    rollback work
                else
                    message 'INSERT O.K'
                    let g_rec_b3=g_rec_b3+1 
                    commit work
                end if

            before row
                let l_ac = arr_curr()
                let l_n  = arr_count()
                let l_lock_sw = 'n'
                if g_rec_b3 >= l_ac then
                    # 新增一笔
                    let p_cmd = 'u'
                    let g_tc_cmc_t.* = g_tc_cmc[l_ac].*
                    begin work

                    open tc_cmc_bcl using g_tc_cma01,g_tc_cma02,g_tc_cma05,g_tc_cmb04,g_tc_cmc[l_ac].tc_cmc05
                    if status then
                        call cl_err("open tc_cmc_bcl",status,1)
                        let l_lock_sw = "Y"
                    else
                        fetch tc_cmc_bcl into g_tc_cmc[l_ac].*
                        if sqlca.sqlcode then
                            call cl_err(
                                g_tc_cma01||g_tc_cma02||g_tc_cma05||g_tc_cmb04||g_tc_cmc[l_ac].tc_cmc05,
                                sqlca.sqlcode,
                                1
                                )
                            let l_lock_sw = "Y"
                        end if
                        call cl_show_fld_cont()
                    end if
                end if
            
            before field tc_cmc05
                if g_tc_cmc[l_ac].tc_cmc05 is null or g_tc_cmc[l_ac].tc_cmc05 = 0 then
                    select max(tc_cmc05)+1 into g_tc_cmc[l_ac].tc_cmc05 from tc_cmc_file
                    where tc_cmc01=g_tc_cma02 and tc_cmc02=g_tc_cma02 
                    if g_tc_cmc[l_ac].tc_cmc05 is null then
                        let g_tc_cmc[l_ac].tc_cmc05 = 1
                    end if
                end if
            
            on row change
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = true
                    let g_tc_cmc[l_ac].* = g_tc_cmc_t.*
                    close tc_cmc_bcl
                    rollback work
                    exit dialog
                end if
                if l_lock_sw = 'Y' then
                    call cl_err(g_tc_cma01||g_tc_cma02||g_tc_cma05||g_tc_cmb04||g_tc_cmc[l_ac].tc_cmc05,-263,1)
                    let g_tc_cmc[l_ac].* = g_tc_cmc_t.*
                else
                    update tc_cmc_file
                       set tc_cmc05 = g_tc_cmc[l_ac].tc_cmc05,
                           tc_cmc06 = g_tc_cmc[l_ac].tc_cmc06,
                           tc_cmc07 = g_tc_cmc[l_ac].tc_cmc07
                     where tc_cmc01= g_tc_cma01 
                       and tc_cmc02 = g_tc_cma02
                       and tc_cmc03 = g_tc_cma05
                       and tc_cmc04 = g_tc_cmb04
                    
                    if sqlca.sqlcode then
                        call s_errmsg('tc_cmc01',g_tc_cma01||g_tc_cma02||g_tc_cma05||g_tc_cmb04||g_tc_cmc[l_ac].tc_cmc05,'upd ima:',sqlca.sqlcode,1)                           #no.fun-710027 
                        rollback work
                    else
                        commit work
                    end if
                end if
            after row
        end input

        on action help
            let g_action_choice="help"
            exit dialog
        on action exit
            let g_action_choice="exit"
            exit dialog
    
        on action controlg 
            let g_action_choice="controlg"
            exit dialog
 
        on action accept
            exit dialog
        
        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()
        
        on action cancel
            let int_flag=true
            let g_action_choice="exit"
            exit dialog
 
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
    
        on action about         #mod-4c0121
            call cl_about()      #mod-4c0121
    
 

    end dialog
end function
 
function i112_b_askkey() 
    call g_tc_cma.clear()
    dialog
        construct by name g_wc on tc_cma01,imz02,tc_cma02,tc_cma03
            before construct
                message ""
        end construct

        construct g_wc2 on tc_cma05,tc_cma06,tc_cma07
            from s_tc_cma[1].tc_cma05,s_tc_cma[1].tc_cma06,s_tc_cma[1].tc_cma07
            before construct
                message ""
        end construct

        on action accept
            exit dialog
        on action cancel
            let int_flag = true
            exit dialog
        on action controlp
            case
                when infield(tc_cma01)
                    call cl_init_qry_var()
                    let g_qryparam.form     = "q_imz"
                    let g_qryparam.state    = "c"
                    call cl_create_qry() returning g_qryparam.multiret 
                    display g_qryparam.multiret to tc_cma01
                    next field tc_cma01
            end case
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog

        on action about        
            call cl_about() 

        on action help         
            call cl_show_help() 

        on action controlg    
            call cl_cmdask()
    end dialog
 
#no.tqc-710076 -- begin --
#    if int_flag then let int_flag = 0 return end if
   if int_flag then
      let int_flag = 0
      let g_wc = null
      let g_wc2 = null
      return
   end if
#no.tqc-710076 -- end --
    let g_sql = " select unique tc_cma01,tc_cma02 from tc_cma_file where ",g_wc," and ",g_wc2 ," order by tc_cma01,tc_cma02"
    prepare cimi112_prepare from g_sql
    declare cimi112_curs scroll cursor with hold for cimi112_prepare
    open cimi112_curs
    call i112_fetch("F")
    # call i112_b_fill(g_wc,g_wc2)
end function

function i112_fetch(p_flima)
    define
        p_flima          like type_file.chr1    #no.fun-690026 varchar(1)
 
    case p_flima
        when 'N' fetch next     cimi112_curs into g_tc_cma01,g_tc_cma02
        when 'P' fetch previous cimi112_curs into g_tc_cma01,g_tc_cma02
        when 'F' fetch first    cimi112_curs into g_tc_cma01,g_tc_cma02
        when 'L' fetch last     cimi112_curs into g_tc_cma01,g_tc_cma02
        when '/'
            if (true) then    #no.fun-6a0061
               call cl_getmsg('fetch',g_lang) returning g_msg
               let int_flag = 0  ######add for prompt bug
               prompt g_msg clipped,': ' for g_jump
                  on idle g_idle_seconds
                     call cl_on_idle()
 
      on action about         #mod-4c0121
         call cl_about()      #mod-4c0121
 
      on action help          #mod-4c0121
         call cl_show_help()  #mod-4c0121
 
      on action controlg      #mod-4c0121
         call cl_cmdask()     #mod-4c0121
 
               end prompt
               if int_flag then
                   let int_flag = 0
                   exit case
               end if
            end if
            fetch absolute g_jump cimi112_curs into g_tc_cma01,g_tc_cma02
            let mi_no_ask = false     #no.fun-6a0061
    end case
 
    if sqlca.sqlcode then
        call cl_err(g_tc_cma01,sqlca.sqlcode,0)
        #initialize g_tc_cma.* to null  #tqc-6b0105
        return
    else
      case p_flima
         when 'F' let g_curs_index = 1
         when 'P' let g_curs_index = g_curs_index - 1
         when 'N' let g_curs_index = g_curs_index + 1
         when 'L' let g_curs_index = g_row_count
         when '/' let g_curs_index = g_jump
      end case
 
      call cl_navigator_setting(g_curs_index, g_row_count)
    end if
 
    call i112_show()
end function

function i112_show()
    select tc_cma01,imz02,tc_cma02,tc_cma03,tc_cma04
      into g_tc_cma01,g_imz02,g_tc_cma02,g_tc_cma03,g_tc_cma04
      from tc_cma_file,imz_file where tc_cma01=imz01 and tc_cma01 =g_tc_cma01 and tc_cma02 = g_tc_cma02

    display g_tc_cma01,g_imz02,g_tc_cma02,g_tc_cma03
         to tc_cma01,imz02,tc_cma02,tc_cma03

    call i112_b_fill(g_wc2)

end function

function i112_b_fill(p_wc2)              #body fill up
define
    p_wc2            string       #no.fun-680122 varchar(200)  
    
    let g_sql = "select tc_cma05,tc_cma06,tc_cma07 from tc_cma_file ",
                " where tc_cma01 = '",g_tc_cma01,"' and tc_cma02 = '",g_tc_cma02,"' and ",p_wc2,
                " order by tc_cma05"
    prepare tc_cma_p from g_sql
    declare tc_cma_curs cursor for tc_cma_p

    call g_tc_cma.clear()
    let g_cnt = 1
    message "searching!" 
    foreach tc_cma_curs into g_tc_cma[g_cnt].*   #單身 array 填充
        if status then call cl_err('foreach:',status,1) exit foreach end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
           call cl_err( '', 9035, 0 )
           exit foreach
        end if
    end foreach
    call g_tc_cma.deleteelement(g_cnt)
    message ""
    let g_rec_b = g_cnt-1
    # display g_rec_b to formonly.cn2  
    
    let g_cnt = 1
    ## tc_cmb
    foreach tc_cmb_cur using g_tc_cma01,g_tc_cma02
        into g_tc_cmb[g_cnt].*
        if status then
            call cl_err('tc_cmb_cur',status,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err("",9035,0)
            exit foreach
        end if
    end foreach
    call g_tc_cmb.deleteelement(g_cnt)

    let g_cnt = 1
    ## tc_cmc
    foreach tc_cmc_cur using g_tc_cma01,g_tc_cma02
        into g_tc_cmc[g_cnt].*
        if status then
            call cl_err('tc_cmc_cur',status,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err("",9035,0)
            exit foreach
        end if
    end foreach
    call g_tc_cmc.deleteelement(g_cnt)

end function
 
function i112_bp(p_ud)
    define   p_ud   like type_file.chr1          #no.fun-680122 varchar(1)
    
    
    if p_ud <> "g" or g_action_choice = "detail" then
        return
    end if
    
    let g_action_choice = " "
    
    call cl_set_act_visible("accept,cancel", false)



    dialog #ATTRIBUTES(UNBUFFERED)
        display array g_tc_cma to s_tc_cma.* #attributes(focusonfield)
            before row
                let l_ac = arr_curr()
                if g_tc_cma05 != g_tc_cma[l_ac].tc_cma05 then
                    let g_tc_cma05 = g_tc_cma[l_ac].tc_cma05
                    call i112_b2_fill()
                    # call i112_bp('g')
                    continue dialog
                else
                end if
            after row
            
        end display

        display array g_tc_cmb to s_tc_cmb.* #attributes(focusonfield)
            before display
                call ui.Interface.refresh()
            before row
                let l_ac2 = arr_curr()
                #call i112_b3_fill()
                call ui.Interface.refresh()
                if g_tc_cmb04 != g_tc_cmb[l_ac2].tc_cmb04 then
                    let g_tc_cmb04 = g_tc_cmb[l_ac2].tc_cmb04
                    call i112_b3_fill()
                    # call i112_bp('g')
                    continue dialog
                else
                end if
            after row
            
        end display

        display array g_tc_cmc to s_tc_cmc.* #attributes(focusonfield)
            before row
                let l_ac3 = arr_curr()
        end display

        on action query
            clear form
            let g_action_choice="query"
            exit dialog
        on action detail
            let g_action_choice="detail"
            let l_ac = 1
            exit dialog
        on action output
            let g_action_choice="output"
            exit dialog
        on action insert
            let g_action_choice="insert"
            exit dialog
        on action help
            let g_action_choice="help"
            exit dialog
        on action exit
            let g_action_choice="exit"
            exit dialog

        on action first
            call i112_fetch('F')
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action previous
            let g_action_choice="previous"
            call i112_fetch('P')     #mod-490490
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action jump
            let g_action_choice="jump"
            call i112_fetch('/')
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action next
            let g_action_choice="next"
            call i112_fetch('N')
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action last
            let g_action_choice="last"
            call i112_fetch('L')
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog
    
        on action controlg 
            let g_action_choice="controlg"
            exit dialog

        on action accept
            let g_action_choice="detail"
            let l_ac = arr_curr()
            exit dialog
        
        on action locale
                call cl_dynamic_locale()
                call cl_show_fld_cont()
        
        on action cancel
            let int_flag=true
            let g_action_choice="exit"
            exit dialog

        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
    
        on action about
            call cl_about()
    end dialog

   call cl_set_act_visible("accept,cancel", true)
end function
function i112_i()
    define cnt like type_file.num5
    define success like type_file.chr1

    input g_tc_cma01 from tc_cma01
        before input
            message ""

        after field tc_cma01
            if not cl_null(g_tc_cma01) then
                call i112_get_tc_cma02(g_tc_cma01) returning success,g_tc_cma02
                display g_tc_cma02 to tc_cma02
            else
                next field tc_cma01
            end if

        on action accept
            if not cl_null(g_tc_cma01) then
                call i112_get_tc_cma02(g_tc_cma01) returning success,g_tc_cma02
                let g_tc_cma03='N'
                display g_tc_cma02,g_tc_cma03 to tc_cma02,tc_cma03
            else
                next field tc_cma01
            end if
            exit input
        on action cancel
            let int_flag = false
            exit input
        after input
            if not cl_null(g_tc_cma01) then
                call i112_get_tc_cma02(g_tc_cma01) returning success,g_tc_cma02
                let g_tc_cma03='N'
                display g_tc_cma02,g_tc_cma03 to tc_cma02,tc_cma03
            else
                next field tc_cma01
            end if
            exit input

        on action controlp
            case
                when infield(tc_cma01)
                    call cl_init_qry_var()
                    let g_qryparam.form     = "q_imz"
                    let g_qryparam.state    = "i"
                    call cl_create_qry() returning g_tc_cma01
                    display g_tc_cma01 to tc_cma01
                    next field tc_cma01
            end case
        on action controlr
            call cl_show_req_fields()

        on action controlg
            call cl_cmdask()

        on action controlf
            message ""

        on idle g_idle_seconds
            call cl_on_idle()
            continue input

        on action about
            call cl_about()

        on action help
            call cl_show_help()
    end input
    if int_flag then
        return
    end if
    call i112_b()
end function

function i112_get_tc_cma02(p_tc_cma01)
    define p_tc_cma01  like tc_cma_file.tc_cma01
    define l_tc_cma02  like tc_cma_file.tc_cma02

    define cnt         like type_file.num5

    let cnt = 0
    select count(1) into cnt from imz_file where imz01 = g_tc_cma01 and imzacti='Y'
    if cnt = 0 then
        call cl_err(g_tc_cma01,"aic-037",1)
        return false,""
    else
        select imz01,imz02 into g_tc_cma01,g_imz02 from imz_file where imz01 = g_tc_cma01
        if sqlca.sqlcode then
            call cl_err("select imz",status,1)
            return false,""
        end if
        let l_tc_cma02 = 0
        select max(tc_cma02) into l_tc_cma02 from tc_cma_file where tc_cma01=g_tc_cma01
        if sqlca.sqlcode then
            call cl_err("select tc_cma",status,1)
            return false,""
        end if
        if l_tc_cma02 =0 or cl_null(l_tc_cma02) then
            let l_tc_cma02 = 1
        else
            let l_tc_cma02 = l_tc_cma02 + 1
        end if
    end if

    return true,l_tc_cma02
end function

function i112_b2_fill()
    define l_sql string
    define l_cnt like type_file.num5

    call g_tc_cmb.clear()
    let l_cnt = 1
    foreach tc_cmb_fill using g_tc_cma01,g_tc_cma02,g_tc_cma05
        into g_tc_cmb[l_cnt].*
        if sqlca.sqlcode then
            call cl_err("tc_cmb_fill",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_cnt = l_cnt + 1
    end foreach
    call g_tc_cmb.deleteElement(l_cnt)
    let g_rec_b2 = l_cnt - 1
end function
function i112_b3_fill()
    define l_sql string
    define l_cnt like type_file.num5

    call g_tc_cmc.clear()
    let l_cnt = 1
    foreach tc_cmc_fill using g_tc_cma01,g_tc_cma02,g_tc_cma05,g_tc_cmb04
        into g_tc_cmc[l_cnt].*
        if sqlca.sqlcode then
            call cl_err("tc_cmc_fill",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_cnt = l_cnt + 1
    end foreach
    call g_tc_cmc.deleteElement(l_cnt)
    let g_rec_b3 = l_cnt - 1
end function
