# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: cxcq912.4gl
# Descriptions...: 工费分摊明细表(主件 + 自制辅料)
# Date & Author..: darcy 2026-09-22
#
# 查询条件(4 个,全部必录,未录入则报错):
#   料号 item / 版本(工艺编号) ver / 年 yy / 月 mm
#
# 取数说明:
#   1) 自制辅料清单 --- bmb_file
#        bmb01 = 主料   bmb03 = 辅料料号   bmb09 = 辅料在主料中的作业编号
#        bmb03 not like '%.%' and bmb04 <= trunc(sysdate)
#        and (bmb05 is null or bmb05 > trunc(sysdate))
#   2) 工艺资料 ------ ecb_file(主件与自制辅料一起取) 关联 eca_file(工作站) / gem_file(部门)
#        工站总人工工时汇总 ecb19s = SUM(ecb19) OVER (PARTITION BY gem01)
#   3) 部门分项成本 --- ta_cck_file 只有主件(tc_cck01=年, ta_cck02=月, ta_cck03=主件料号)
#        主件与其自制辅料落在同一部门时,以主件的部门成本一起分摊
#   4) 人工制费金额 --- (ta_cck06a + ta_cck07a + ta_cck08a) / ta_cck09 / ecb19s * ecb19
#        分母为 0 或该部门无成本资料时,分摊栏位留 0(不报错)
#   5) 累计人工制费 --- 按 ecb01 + ecb02 分类,按 ecb03 顺序累加到当前工序
#   6) 自制辅材料号 / 自制辅材人工总制费
#        辅料自身全部工序人工制费合计,回标到主件 ecb06 = 辅料 bmb09 的那一笔
#        (一个作业编号只会对应一笔自制辅料,仅主件行回标)
#   7) 累计(人工制费 + 自制辅材人工制费)amt_sum2
#        与 amt_sum 同一套分组逻辑,逐笔累加 amt + sub_amt
#
# 金额、单位成本栏位一律 DECIMAL(26,10)(type_file.num26_10),保持 10 位小数
#
# 画面档 cxc/42f/cxcq912 需要的栏位:
#   条件栏位 : item, ver, yy, mm
#   笔数栏位 : cnt
#   明细数组 : s_cxc912.* --- ecb01, ecb02, ecb03, ecb06, ecb17, ecb08, gem01, gem02,
#              ecb19, ecb19s, ta_cck09, ta_cck06a, ta_cck07a, ta_cck08a,
#              amt, amt_sum, sub_bmb03, sub_amt, amt_sum2
#   Action   : query, exporttoexcel, exit, cancel, locale, help, about, controlg, controlp, controlr, controlf

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

TYPE t_cxc912 RECORD                                     # 报表明细
       ecb01        LIKE ecb_file.ecb01,                 # 料件编号
       ecb02        LIKE ecb_file.ecb02,                 # 工艺编号
       ecb03        LIKE ecb_file.ecb03,                 # 工艺序号
       ecb06        LIKE ecb_file.ecb06,                 # 作业编号
       ecb17        LIKE ecb_file.ecb17,                 # 说明
       ecb08        LIKE ecb_file.ecb08,                 # 工作站编号
       gem01        LIKE gem_file.gem01,                 # 部门
       gem02        LIKE gem_file.gem02,                 # 部门名称
       ecb19        LIKE ecb_file.ecb19,                 # 标准人工生产时间
       ecb19s       LIKE ecb_file.ecb19,                 # 工站总人工工时汇总
       ta_cck09     decimal(20,3),                       # 产品入库数量
       ta_cck06a    LIKE type_file.num26_10,             # 工站人工金额
       ta_cck07a    LIKE type_file.num26_10,             # 工站制费金额
       ta_cck08a    LIKE type_file.num26_10,             # 工站其他金额
       amt          LIKE type_file.num26_10,             # 人工制费金额
       amt_sum      LIKE type_file.num26_10,             # 累计人工制费
       sub_bmb03    LIKE bmb_file.bmb03,                 # 自制辅材料号
       sub_amt      LIKE type_file.num26_10,             # 自制辅材人工总制费
       amt_sum2     LIKE type_file.num26_10              # 累计(人工制费 + 自制辅材人工制费)
                            END RECORD

TYPE t_ecb RECORD                                        # 工艺资料取数暂存
       ecb01        LIKE ecb_file.ecb01,
       ecb02        LIKE ecb_file.ecb02,
       ecb03        LIKE ecb_file.ecb03,
       ecb06        LIKE ecb_file.ecb06,
       ecb17        LIKE ecb_file.ecb17,
       ecb08        LIKE ecb_file.ecb08,
       gem01        LIKE gem_file.gem01,
       gem02        LIKE gem_file.gem02,
       ecb19        LIKE ecb_file.ecb19,
       ecb19s       LIKE type_file.num26_10
                            END RECORD

TYPE t_bmb RECORD                                        # 自制辅料清单
       bmb03        LIKE bmb_file.bmb03,                 # 辅料料号
       bmb09        LIKE bmb_file.bmb09,                 # 辅料在主料中的作业编号
       bmb_sub_amt  LIKE type_file.num26_10              # 辅料全工序人工制费合计
                            END RECORD

TYPE t_cck RECORD                                        # 主件的部门分项成本
       gem01        LIKE gem_file.gem01,                 # 部门
       ta_cck06a    LIKE type_file.num26_10,             # 总人工
       ta_cck07a    LIKE type_file.num26_10,             # 总制费
       ta_cck08a    LIKE type_file.num26_10,             # 总其它
       ta_cck09     LIKE type_file.num26_10              # 本月入库数量
                            END RECORD

TYPE t_ver RECORD                                        # 查询条件
       item         LIKE ecb_file.ecb01,                 # 料号
       ver          LIKE ecb_file.ecb02,                 # 版本
       yy           LIKE type_file.num5,                 # 年
       mm           LIKE type_file.num5                  # 月
                            END RECORD

DEFINE g_cxc912          DYNAMIC ARRAY OF t_cxc912       # 报表明细
DEFINE g_bmb             DYNAMIC ARRAY OF t_bmb          # 自制辅料清单
DEFINE g_cck             DYNAMIC ARRAY OF t_cck          # 部门分项成本
DEFINE g_ver             t_ver                           # 查询条件

DEFINE g_rec_b           LIKE type_file.num10            # 单身笔数
DEFINE g_action_choice   STRING                          # ON ACTION 名称

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("CXC")) THEN
        EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW cxcq912_w AT 2,2 WITH FORM "cxc/42f/cxcq912"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

    INITIALIZE g_ver.* TO NULL
    LET g_action_choice = ""
    LET g_rec_b = 0
    CALL g_cxc912.clear()
    CALL g_bmb.clear()
    CALL g_cck.clear()

    CALL cxcq912_q()
    CALL cxcq912_menu()

    CLOSE WINDOW cxcq912_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION cxcq912_menu()
    WHILE TRUE
        CALL cxcq912_bp()
        CASE g_action_choice
            WHEN "query"
                CALL cxcq912_q()
            WHEN "exporttoexcel"
                IF cl_chk_act_auth() THEN
                    CALL cl_download_by_explorer(cl_expexcel1(
                        "s_cxc912",base.typeinfo.create(g_cxc912)
                        ))
                END IF
            WHEN "exit"
                EXIT WHILE
            OTHERWISE
        END CASE
    END WHILE
END FUNCTION

# ------------------------------------------------------------------
# 查询条件输入(4 个必录)
# ------------------------------------------------------------------
FUNCTION cxcq912_cs()
    DIALOG ATTRIBUTES(UNBUFFERED)

        INPUT BY NAME g_ver.item,g_ver.ver,g_ver.yy,g_ver.mm

            BEFORE INPUT
                DISPLAY BY NAME g_ver.item,g_ver.ver,g_ver.yy,g_ver.mm

            ON ACTION controlp
                CASE
                    WHEN INFIELD(item)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_ima"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO item
                        NEXT FIELD item
                    OTHERWISE
                END CASE

            ON ACTION controlr
                CALL cl_show_req_fields()

            ON ACTION controlf
                CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
                CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION controlg
                CALL cl_cmdask()

            ON ACTION accept
                CASE
                    WHEN cl_null(g_ver.item)
                        CALL cl_err('料号 为必录栏位,请输入','!',1)
                        NEXT FIELD item
                    WHEN cl_null(g_ver.ver)
                        CALL cl_err('版本 为必录栏位,请输入','!',1)
                        NEXT FIELD ver
                    WHEN cl_null(g_ver.yy)
                        CALL cl_err('年 为必录栏位,请输入','!',1)
                        NEXT FIELD yy
                    WHEN cl_null(g_ver.mm)
                        CALL cl_err('月 为必录栏位,请输入','!',1)
                        NEXT FIELD mm
                    WHEN g_ver.mm < 1 OR g_ver.mm > 12
                        CALL cl_err('月份需介于 1 ~ 12','!',1)
                        NEXT FIELD mm
                    OTHERWISE
                        exit DIALOG
                END CASE

            ON ACTION cancel
                LET INT_FLAG = TRUE
                EXIT DIALOG

            ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG

            ON ACTION about
                CALL cl_about()

            ON ACTION help
                CALL cl_show_help()

        END INPUT
    END DIALOG

    IF INT_FLAG THEN
        LET INT_FLAG = FALSE
        RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION cxcq912_q()
    IF NOT cxcq912_cs() THEN
        RETURN
    END IF
    CALL cxcq912_b_fill()
    DISPLAY g_rec_b TO FORMONLY.cnt
    MESSAGE SFMT('总笔数: %1',g_rec_b)
END FUNCTION

# ------------------------------------------------------------------
# 取自制辅料清单
# ------------------------------------------------------------------
FUNCTION cxcq912_b_fill()
    DEFINE i,j,k        LIKE type_file.num10
    DEFINE l_sql        STRING
    DEFINE l_msg        LIKE type_file.chr1000
    DEFINE l_amt        DECIMAL(32,12)
    DEFINE l_sum        LIKE type_file.num26_10
    DEFINE l_cur_item   LIKE ecb_file.ecb01
    DEFINE l_cur_ver    LIKE ecb_file.ecb02
    DEFINE l_raw        t_ecb

    CALL g_cxc912.clear()
    CALL g_bmb.clear()
    CALL g_cck.clear()
    LET g_rec_b = 0

    # ---------------- 1. 自制辅料清单 ----------------
    DECLARE cxcq912_bmb CURSOR FOR
    SELECT bmb03,bmb09
      FROM bmb_file
     WHERE bmb01 = g_ver.item
       AND bmb03 NOT LIKE '%.%'
       AND bmb04 <= TRUNC(SYSDATE)
       AND (bmb05 IS NULL OR bmb05 > TRUNC(SYSDATE))
     ORDER BY bmb09,bmb03
    LET i = 1
    FOREACH cxcq912_bmb INTO g_bmb[i].bmb03,g_bmb[i].bmb09
        IF SQLCA.sqlcode THEN
            CALL cl_err('cxcq912_bmb',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET i = i + 1
    END FOREACH
    CALL g_bmb.deleteElement(i)

    # ---------------- 2. 主件的部门分项成本 ----------------
    LET l_sql = " SELECT ta_cck04,ta_cck06a,ta_cck07a,ta_cck08a,ta_cck09 ",
                "   FROM ta_cck_file ",
                "  WHERE ta_cck01 = ",g_ver.yy,
                "    AND ta_cck02 = ",g_ver.mm,
                "    AND ta_cck03 = '",g_ver.item CLIPPED,"'"
    PREPARE cxcq912_cck_p FROM l_sql
    DECLARE cxcq912_cck_c CURSOR FOR cxcq912_cck_p
    LET i = 1
    FOREACH cxcq912_cck_c INTO g_cck[i].gem01,g_cck[i].ta_cck06a,g_cck[i].ta_cck07a,
                              g_cck[i].ta_cck08a,g_cck[i].ta_cck09
        IF SQLCA.sqlcode THEN
            CALL cl_err('cxcq912_cck_c',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET i = i + 1
    END FOREACH
    CALL g_cck.deleteElement(i)

    # NULL 视为 0,避免相加后整笔变成 NULL
    FOR i = 1 TO g_cck.getLength()
        IF cl_null(g_cck[i].ta_cck06a) THEN LET g_cck[i].ta_cck06a = 0 END IF
        IF cl_null(g_cck[i].ta_cck07a) THEN LET g_cck[i].ta_cck07a = 0 END IF
        IF cl_null(g_cck[i].ta_cck08a) THEN LET g_cck[i].ta_cck08a = 0 END IF
    END FOR

    # ---------------- 3. 工艺资料(主件 + 自制辅料一起取) ----------------
    LET l_sql = " SELECT ecb01,ecb02,ecb03,ecb06,ecb17,ecb08,gem01,gem02,ecb19, ",
                "        SUM(ecb19) OVER (PARTITION BY gem01) ecb19s ",
                "   FROM ecb_file,eca_file,gem_file ",
                "  WHERE (ecb01 = '",g_ver.item CLIPPED,"'"
    IF g_bmb.getLength() > 0 THEN
        LET l_sql = l_sql CLIPPED," OR ecb01 IN ("
        FOR j = 1 TO g_bmb.getLength()
            IF j > 1 THEN
                LET l_sql = l_sql CLIPPED,","
            END IF
            LET l_sql = l_sql CLIPPED,"'",g_bmb[j].bmb03 CLIPPED,"'"
        END FOR
        LET l_sql = l_sql CLIPPED,")"
    END IF
    LET l_sql = l_sql CLIPPED,") ",
                "    AND ecb02 = '",g_ver.ver CLIPPED,"' ",
                "    AND ecb08 = eca01 ",
                "    AND eca03 = gem01 ",
                "  ORDER BY ecb01,ecb02,ecb03"

    PREPARE cxcq912_ecb_p FROM l_sql
    DECLARE cxcq912_ecb_c CURSOR FOR cxcq912_ecb_p
    LET i = 1
    FOREACH cxcq912_ecb_c INTO l_raw.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('cxcq912_ecb_c',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cxc912[i].ecb01   = l_raw.ecb01
        LET g_cxc912[i].ecb02   = l_raw.ecb02
        LET g_cxc912[i].ecb03   = l_raw.ecb03
        LET g_cxc912[i].ecb06   = l_raw.ecb06
        LET g_cxc912[i].ecb17   = l_raw.ecb17
        LET g_cxc912[i].ecb08   = l_raw.ecb08
        LET g_cxc912[i].gem01   = l_raw.gem01
        LET g_cxc912[i].gem02   = l_raw.gem02
        LET g_cxc912[i].ecb19   = l_raw.ecb19
        LET g_cxc912[i].ecb19s  = l_raw.ecb19s
        LET i = i + 1
    END FOREACH
    CALL g_cxc912.deleteElement(i)
    LET g_rec_b = g_cxc912.getLength()

    IF g_rec_b = 0 THEN
        LET l_msg = '料号 ',g_ver.item CLIPPED,' 版本 ',g_ver.ver CLIPPED,' 无工艺资料'
        CALL cl_err(l_msg,'!',0)
        RETURN
    END IF

    # ---------------- 4. 逐笔计算人工制费与累计 ----------------
    # 用首笔初始化:与 NULL 比较的结果恒为 false,若初值给 NULL,
    # 下面的判断永远不成立,整张表都不会归零(主件 -> 辅料 -1/-2 也照样累加)
    LET l_cur_item = g_cxc912[1].ecb01
    LET l_cur_ver  = g_cxc912[1].ecb02
    LET l_sum      = 0

    FOR i = 1 TO g_rec_b
        # 4.1 按 ecb01 + ecb02 分类,换料件/换工艺编号即归零
        IF g_cxc912[i].ecb01 <> l_cur_item OR g_cxc912[i].ecb02 <> l_cur_ver THEN
            LET l_cur_item = g_cxc912[i].ecb01
            LET l_cur_ver  = g_cxc912[i].ecb02
            LET l_sum      = 0
        END IF

        # 4.2 取该部门的分项成本(只有主件有;主件与辅料同部门时一起分摊)
        LET k = cxcq912_find_gem(g_cxc912[i].gem01)
        IF k > 0 THEN
            LET g_cxc912[i].ta_cck09  = g_cck[k].ta_cck09
            LET g_cxc912[i].ta_cck06a = g_cck[k].ta_cck06a
            LET g_cxc912[i].ta_cck07a = g_cck[k].ta_cck07a
            LET g_cxc912[i].ta_cck08a = g_cck[k].ta_cck08a

            # 4.3 人工制费金额 = (人工+制费+其它)/入库数量/工站总工时汇总*本工序工时
            #     分母为 0 时不分摊,留 0
            LET g_cxc912[i].amt = 0
            IF NOT cl_null(g_cck[k].ta_cck09) AND g_cck[k].ta_cck09 <> 0 THEN
                IF NOT cl_null(g_cxc912[i].ecb19s) AND g_cxc912[i].ecb19s <> 0 THEN
                    LET l_amt = g_cck[k].ta_cck06a + g_cck[k].ta_cck07a + g_cck[k].ta_cck08a
                    LET l_amt = l_amt / g_cck[k].ta_cck09
                    LET l_amt = l_amt / g_cxc912[i].ecb19s
                    LET l_amt = l_amt * g_cxc912[i].ecb19
                    LET g_cxc912[i].amt = l_amt
                END IF
            END IF
        ELSE
            # 该部门无成本资料,分摊栏位留空/0
            LET g_cxc912[i].ta_cck09  = NULL
            LET g_cxc912[i].ta_cck06a = NULL
            LET g_cxc912[i].ta_cck07a = NULL
            LET g_cxc912[i].ta_cck08a = NULL
            LET g_cxc912[i].amt       = 0
        END IF

        # 4.4 累计人工制费
        LET l_sum = l_sum + g_cxc912[i].amt
        LET g_cxc912[i].amt_sum = l_sum
    END FOR

    # ---------------- 5. 自制辅料成本回标 ----------------
    # 5.1 每笔辅料自身全部工序的人工制费合计
    FOR i = 1 TO g_bmb.getLength()
        LET l_sum = 0
        FOR j = 1 TO g_rec_b
            IF g_cxc912[j].ecb01 = g_bmb[i].bmb03 THEN
                LET l_sum = l_sum + g_cxc912[j].amt
            END IF
        END FOR
        LET g_bmb[i].bmb_sub_amt = l_sum
    END FOR

    # 5.2 回标到主件 ecb06 = 辅料 bmb09 的那一笔
    FOR i = 1 TO g_rec_b
        IF g_cxc912[i].ecb01 <> g_ver.item THEN
            CONTINUE FOR
        END IF
        FOR j = 1 TO g_bmb.getLength()
            IF g_cxc912[i].ecb06 = g_bmb[j].bmb09 THEN
                LET g_cxc912[i].sub_bmb03 = g_bmb[j].bmb03
                LET g_cxc912[i].sub_amt   = g_bmb[j].bmb_sub_amt
                EXIT FOR
            END IF
        END FOR
    END FOR

    # ---------------- 6. 累计(人工制费 + 自制辅材人工制费)amt_sum2 ----------------
    #     与 amt_sum 同一套逻辑:按 ecb01 + ecb02 分组归零,逐笔累加 amt + sub_amt
    #     必须放在 5.2 之后,此时 sub_amt 才回标完成
    LET l_cur_item = g_cxc912[1].ecb01
    LET l_cur_ver  = g_cxc912[1].ecb02
    LET l_sum      = 0

    FOR i = 1 TO g_rec_b
        IF g_cxc912[i].ecb01 <> l_cur_item OR g_cxc912[i].ecb02 <> l_cur_ver THEN
            LET l_cur_item = g_cxc912[i].ecb01
            LET l_cur_ver  = g_cxc912[i].ecb02
            LET l_sum      = 0
        END IF

        # amt 每笔都有值(4.3 无成本资料时填 0)
        LET l_sum = l_sum + g_cxc912[i].amt

        # sub_amt 只有主件被回标的那一笔有值,为 NULL 时按 0 计
        # (NULL 参与运算会把累计值整个变成 NULL,不能直接相加)
        IF NOT cl_null(g_cxc912[i].sub_amt) THEN
            LET l_sum = l_sum + g_cxc912[i].sub_amt
        END IF
        LET g_cxc912[i].amt_sum2 = l_sum
    END FOR
END FUNCTION

# ------------------------------------------------------------------
# 依部门取该部门分项成本在 g_cck 的索引,取不到回 0
# ------------------------------------------------------------------
FUNCTION cxcq912_find_gem(p_gem)
    DEFINE p_gem        LIKE gem_file.gem01
    DEFINE i            LIKE type_file.num10

    FOR i = 1 TO g_cck.getLength()
        IF g_cck[i].gem01 = p_gem THEN
            RETURN i
        END IF
    END FOR
    RETURN 0
END FUNCTION

# ------------------------------------------------------------------
# 明细显示
# ------------------------------------------------------------------
FUNCTION cxcq912_bp()
    LET g_action_choice = ""
    CALL cl_set_act_visible("accept,cancel",FALSE)

    DISPLAY ARRAY g_cxc912 TO s_cxc912.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

        BEFORE DISPLAY
            CALL cl_show_fld_cont()

        ON ACTION query
            LET g_action_choice = "query"
            EXIT DISPLAY

        ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT DISPLAY

        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT DISPLAY

        ON ACTION cancel
            LET INT_FLAG = FALSE
            LET g_action_choice = "exit"
            EXIT DISPLAY

        ON ACTION about
            CALL cl_about()

        ON ACTION help
            CALL cl_show_help()

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

        AFTER DISPLAY
            CONTINUE DISPLAY

    END DISPLAY

    CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
