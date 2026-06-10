# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cbmq502.4gl
# Descriptions...: BOM 尾阶级查询
# Date & Author..: darcy add

database ds
GLOBALS "../../../tiptop/config/top.global"

type bmb record
    level       integer,
    bmb01       like bmb_file.bmb01,
    bmbud02     like bmb_file.bmbud02,
    ecb03       like ecb_file.ecb03,
    bmb09       like bmb_file.bmb09,
    bmb02       like bmb_file.bmb02,
    bmb03       like bmb_file.bmb03,
    ima02_b     like ima_file.ima02,
    ima021_b    like ima_file.ima021,
    bmb10       like bmb_file.bmb10,
    bmb06       like bmb_file.bmb06,
    qpa         like bmb_file.bmb06
end record
type bma record
    bma01       like bma_file.bma01,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021,
    ima05       like ima_file.ima05,
    ima08       like ima_file.ima08,
    ima55       like ima_file.ima55,
    bma06       like bma_file.bma06,
    bmauser     like bma_file.bmauser,
    bmamodu     like bma_file.bmamodu,
    bmaacti     like bma_file.bmaacti,
    bmagrup     like bma_file.bmagrup,
    bmadate     like bma_file.bmadate,
    bmaoriu     like bma_file.bmaoriu,
    bmaorig     like bma_file.bmaorig
end record

define g_bma01  like bma_file.bma01
define g_argv1,g_sql,g_wc,g_msg          string
define l_ac,g_cnt,g_jump,g_curs_index,g_row_count,g_rec_b       integer
define g_bma bma
define g_bmb    dynamic array of bmb
define mi_no_ask boolean

MAIN
    DEFINE  # l_time LIKE type_file.chr8           #No.FUN-6A0060
          l_sl	       LIKE type_file.num5    #No.FUN-680096 SMALLINT

   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF


    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)

    OPEN WINDOW cbmq502_w AT 2,3 WITH FORM "cbm/42f/cbmq502"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

    IF NOT cl_null(g_argv1) THEN CALL cbmq502_q() END IF

    CALL cbmq502_menu()

    CLOSE WINDOW cbmq502_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
--
function cbmq502_menu()
    while true
        call cbmq502_bp()
        case g_action_choice
            when 'query'
                if cl_chk_act_auth() then
                    call cbmq502_q()
                end if
            when 'exporttoexcel'
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(cl_expexcel1('s_bmb',base.typeinfo.create(g_bmb)))
                end if
            when 'exit'
                exit while
        end case
    end while
end function



--
function cbmq502_cs()

    construct by name g_wc on bma01,ima05,ima08,ima55,bma06

        before construct
            call cl_qbe_init()

        on action controlp
            -- 开窗
            case
                when infield(bma01)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_bma'
                    let g_qryparam.state = "c"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to bma01
                    next field bma01
                otherwise
            end case

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action controlg
            call cl_cmdask()
        on idle g_idle_seconds
            call cl_on_idle()
            continue construct
        on action accept
            exit construct
        on action cancel
            let INT_FLAG = true
            exit construct
    end construct

    if int_flag then
        return
    end if

    if g_wc = ' 1=1' then
        call cl_err('查询条件不能为空','!',1)
        return
    end if

    let g_sql = "select bma01 from bma_file,ima_file where ima01 = bma01 ",
                " and ",g_wc clipped," order by bma01"
    prepare cbmq502_prepare from g_sql
    declare cbmq502_cs scroll cursor for cbmq502_prepare

    let g_sql = "select count(*) from (",g_sql,")"
    prepare cbmq502_pp from g_sql
    declare cbmq502_cnt scroll cursor for cbmq502_pp
end function
--
function cbmq502_q()
    call cbmq502_cs()
    if int_flag then
        let int_flag = false
        return
    end if
    OPEN cbmq502_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN cbmq502_cnt
       FETCH cbmq502_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL cbmq502_fetch('F')
    END IF
    MESSAGE ''
end function
--
function cbmq502_fetch(p_flag)
    define p_flag   varchar(1)

    if p_flag = '/' then
        if not mi_no_ask then
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            prompt g_msg clipped,": " for g_jump
                on idle g_idle_seconds
                    call cl_on_idle()
                on action about
                    call cl_about()
                on action help
                    call cl_show_help()
            end prompt
            if int_flag then
                let int_flag = false
            end if
            let mi_no_ask = false
        end if
    end if

    case p_flag
        when 'N' fetch next             cbmq502_cs into g_bma.bma01
        when 'P' fetch previous         cbmq502_cs into g_bma.bma01
        when 'L' fetch last             cbmq502_cs into g_bma.bma01
        when 'F' fetch first            cbmq502_cs into g_bma.bma01
        when '/' fetch absolute g_jump  cbmq502_cs into g_bma.bma01
    end case
    if sqlca.sqlcode then
        call cl_err(g_bma.bma01,sqlca.sqlcode,1)
        initialize g_bma.* to null
        return
    else
        case p_flag
            when 'N' let g_curs_index = g_curs_index + 1
            when 'P' let g_curs_index = g_curs_index - 1
            when 'L' let g_curs_index = g_row_count
            when 'F' let g_curs_index = 1
            when '/' let g_curs_index = g_jump
        end case
        call cl_navigator_setting( g_curs_index, g_row_count )
    end if
    call cbmq502_show()

end function

--
function cbmq502_show()

    select  bma01,ima02,ima021,ima05,ima08,ima55,bma06,
            bmauser,bmamodu,bmaacti,bmagrup,bmadate,bmaoriu,bmaorig
      into g_bma.*
      from bma_file,ima_file
     where bma01 = g_bma.bma01

    display by name g_bma.*

    call cbmq502_b_fill()

    call cl_show_fld_cont()
end function

--
function cbmq502_b_fill()
    define sr dynamic array of record
        bmb01           like bmb_file.bmb01,
        bmb02           like bmb_file.bmb02,
        bmb03           like bmb_file.bmb03,
        bmb06           like bmb_file.bmb06,
        bmb08           like bmb_file.bmb08,
        bmb09           like bmb_file.bmb09,
        bmb10           like bmb_file.bmb10,
        bmbud02         like bmb_file.bmbud02,
        ecb03           like ecb_file.ecb03
    end record
    define i,j,l_cnt integer
    define l_ecu02  like ecu_file.ecu02

    select max(ecu02) into l_ecu02 from ecu_file where ecu01 = g_bma.bma01
     and ecuud02 = 'Y' and ecu10 = 'Y'

    let g_sql = "select bmb01, bmb02, bmb03, bmb06, bmb08, bmb09, bmb10, bmbud02
                    from (select bmb01, bmb02, bmb03, bmb06, bmb08, bmb09, bmb10, bmbud02,
                                case when bmbud02 is null then 99
                                    else to_number(substr(bmbud02, 2, length(bmbud02)))
                                end as idx
                            from bmb_file
                            where bmb01 = ?
                            and bmb04 <= trunc(sysdate)
                            and (bmb05 is null or bmb05 > trunc(sysdate)))
                    order by idx"
    declare cbmq502_bcs cursor from g_sql

    let i = 1
    call sr.clear()
    foreach cbmq502_bcs using g_bma.bma01 into sr[i].*
        if sqlca.sqlcode then
            call cl_err('cbmq502_bcs',sqlca.sqlcode,1)
            exit foreach
        end if
        select ecb03 into sr[i].ecb03 from ecb_file
         where ecb01 = g_bma.bma01 and ecb02 = l_ecu02
           and ecb06 = sr[i].bmb09
        let i = i + 1
    end foreach
    call sr.deleteElement(i)

    call g_bmb.clear()
    for i = 1 to sr.getLength()
        select count(*) into l_cnt from bmb_file
         where bmb01 = sr[i].bmb03
        if l_cnt > 0 then
            call cbmq502_exp(sr[i].bmb03,sr[i].bmbud02,sr[i].ecb03,1)
        else
            let j = g_bmb.getLength() + 1
            let g_bmb[j].level = 1
            let g_bmb[j].bmb01 = sr[i].bmb01
            let g_bmb[j].bmbud02 = sr[i].bmbud02
            let g_bmb[j].bmb09 = sr[i].bmb09
            let g_bmb[j].bmb02 = sr[i].bmb02
            let g_bmb[j].bmb03 = sr[i].bmb03
            select ima02,ima021 into g_bmb[j].ima02_b,g_bmb[j].ima021_b
              from ima_file where ima01 = g_bmb[j].bmb03
            let g_bmb[j].bmb10 = sr[i].bmb10
            let g_bmb[j].bmb06 = sr[i].bmb06
            let g_bmb[j].qpa = sr[i].bmb06 * (100 + sr[i].bmb08) / 100
            let g_bmb[j].ecb03 = sr[i].ecb03
        end if
    end for

end function
--
function cbmq502_exp(p_bmb01,p_bmbud02,p_ecb03,level)
    define  p_bmb01  like bmb_file.bmb01,
            p_bmbud02   like bmb_file.bmbud02,
            p_ecb03     like ecb_file.ecb03,
            level integer
    define sr dynamic array of record
        bmb01           like bmb_file.bmb01,
        bmb02           like bmb_file.bmb02,
        bmb03           like bmb_file.bmb03,
        bmb06           like bmb_file.bmb06,
        bmb08           like bmb_file.bmb08,
        bmb09           like bmb_file.bmb09,
        bmb10           like bmb_file.bmb10,
        bmbud02         like bmb_file.bmbud02
    end record
    define i,j,l_cnt integer

    let i = 1
    call sr.clear()
    foreach cbmq502_bcs using p_bmb01 into sr[i].*
        if sqlca.sqlcode then
            call cl_err('cbmq502_bcs',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call sr.deleteElement(i)

    for i = 1 to sr.getLength()
        select count(*) into l_cnt from bmb_file
         where bmb01 = sr[i].bmb03
        if l_cnt > 0 then
            call cbmq502_exp(sr[i].bmb03,p_bmbud02,p_ecb03,level+1)
        else
            let j = g_bmb.getLength() + 1
            let g_bmb[j].level = level + 1
            let g_bmb[j].bmb01 = sr[i].bmb01
            let g_bmb[j].bmbud02 = p_bmbud02
            let g_bmb[j].bmb09 = sr[i].bmb09
            let g_bmb[j].bmb02 = sr[i].bmb02
            let g_bmb[j].bmb03 = sr[i].bmb03
            select ima02,ima021 into g_bmb[j].ima02_b,g_bmb[j].ima021_b
              from ima_file where ima01 = g_bmb[j].bmb03
            let g_bmb[j].bmb10 = sr[i].bmb10
            let g_bmb[j].bmb06 = sr[i].bmb06
            let g_bmb[j].qpa = sr[i].bmb06 * (100 + sr[i].bmb08) / 100
            let g_bmb[j].ecb03 = p_ecb03
        end if
    end for
end function

--
function cbmq502_bp()
    call cl_set_act_visible("accept,cancel", false)
    display array g_bmb to s_bmb.* attribute(count=g_rec_b)
        before display
            call cl_navigator_setting( g_curs_index, g_row_count )

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()

        on action query
            let g_action_choice = 'query'
            exit display

        on action related_document
            let g_action_choice = 'related_document'
            exit display

        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice = 'exit'
            exit display
        on action close
            let g_action_choice = 'exit'
            exit display


        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue display

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        after display
            continue display

    end display
    call cl_set_act_visible("accept,cancel", true)
end function
