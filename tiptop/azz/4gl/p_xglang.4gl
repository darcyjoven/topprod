# Prog. Version..: '5.30.07-13.05.16(00008)'     #
# Pattern name...: p_xglang.4gl
# Descriptions...: XtraGrid報表樣板設定作業
# Date & Author..: FUN-C60085 12/06/22 by odyliao
# Modify.........: FUN-CA0154 12/10/30 by odyliao 
# Modify.........: FUN-CB0101 12/12/01 by odyliao 調整自動判斷是否勾選千分位符號
# Modify.........: FUN-CC0039 12/12/14 by odyliao 新增欄位gds35設定總計取位
# Modify.........: FUN-CC0115 12/12/26 by odyliao 新增有單頭+圖表的模板、有單頭交叉表的模板
# Modify.........: FUN-D20057 12/03/01 by odyliao 增加匯出自訂檔名
# Modify.........: FUN-D30056 12/03/19 by odyliao 增加預設群組(gds36)
# Modify.........: FUN-D40059 12/04/29 by odyliao 增加清除習慣群組按鈕

IMPORT os
IMPORT com
DATABASE ds

GLOBALS "../../config/top.global"

TYPE    gds_sr_type RECORD #FUN-C60085
        gds01       LIKE gds_file.gds01, #項次
        gds03       LIKE gds_file.gds03, #欄位代號
        gds04       LIKE gds_file.gds04, #欄位說明
        gds14       LIKE gds_file.gds14, #顯示否
        gds12       LIKE gds_file.gds12, #報表位置
        gds07       LIKE gds_file.gds07, #群組小計 
        gds08       LIKE gds_file.gds08, #報表總計
        gds36       LIKE gds_file.gds36, #預設群組 #FUN-D30056
        gds05       LIKE gds_file.gds05, #行序
        gds06       LIKE gds_file.gds06, #欄位順序
        gds29       LIKE gds_file.gds29, #欄位寬度
        gds30       LIKE gds_file.gds30, #縮排
        gds09       LIKE gds_file.gds09, #交叉表橫軸
        gds10       LIKE gds_file.gds10, #交叉表縱軸
        gds11       LIKE gds_file.gds11, #交叉表順序
        gds20       LIKE gds_file.gds20, #交叉表分析類型
        gds21       LIKE gds_file.gds21, #PID (for 交叉表)
        gds22       LIKE gds_file.gds22, #ID  (for 交叉表)
        gds13       LIKE gds_file.gds13, #幣別取位對應欄位
        gds35       LIKE gds_file.gds35, #總計取位對應欄位  #FUN-CC0039
        gds31       LIKE gds_file.gds31, #條件隱藏欄位 FUN-CA0154
        gds23       LIKE gds_file.gds23, #千分位
        gds17       LIKE gds_file.gds17, #對齊位置
        gds16       LIKE gds_file.gds16, #主鍵
       #gds19       LIKE gds_file.gds19, #子報表顯示欄位
        gds32       LIKE gds_file.gds32, #可設為取位欄位
        gds34       LIKE gds_file.gds34, #可設為條件隱藏欄位
        gds15       LIKE gds_file.gds15  #欄位型態
        END RECORD
TYPE    sub_gds_sr_type RECORD
        gds01       LIKE gds_file.gds01,
        gds03       LIKE gds_file.gds03,
        gds04       LIKE gds_file.gds04,
        gds14       LIKE gds_file.gds14,
        gds05       LIKE gds_file.gds05,
        gds06       LIKE gds_file.gds06,
        gds09       LIKE gds_file.gds09, #FUN-CC0115
        gds10       LIKE gds_file.gds10, #FUN-CC0115
        gds11       LIKE gds_file.gds11, #FUN-CC0115
        gds20       LIKE gds_file.gds20, #FUN-CC0115
        gds13       LIKE gds_file.gds13,
        gds23       LIKE gds_file.gds23,
        gds16       LIKE gds_file.gds16,
        gds28       LIKE gds_file.gds28,
        gds17       LIKE gds_file.gds17,
        gds15       LIKE gds_file.gds15
        END RECORD

DEFINE g_gdr        RECORD LIKE gdr_file.*,
       b_gdr        RECORD LIKE gdr_file.*,
       g_gdr_t      RECORD LIKE gdr_file.*,         # 單頭變數舊值
       g_gds        DYNAMIC ARRAY OF gds_sr_type,   # 程式變數
       g_sub_gds    DYNAMIC ARRAY OF sub_gds_sr_type,   #子報表單身
       g_gds_t      gds_sr_type,                    # 變數舊值
       g_sub_gds_t  sub_gds_sr_type,                # 變數舊值
       g_wc         STRING,
       g_wc2        STRING,
       g_sql        STRING,
       g_xml_sql        STRING,
       g_rec_b      LIKE type_file.num5,            # 單身筆數     SMALLINT
       g_rec_b2     LIKE type_file.num5,            # 單身筆數     SMALLINT
       g_rec_b3     LIKE type_file.num5,            # 單身筆數     SMALLINT
       l_ac         LIKE type_file.num5,            # 目前處理的ARRAY CNT  SMALLINT
       l_ac2        LIKE type_file.num5             # 目前處理的ARRAY CNT  SMALLINT
DEFINE g_gds18      LIKE gds_file.gds18
DEFINE g_gds19      LIKE gds_file.gds19
DEFINE g_gds19_t    LIKE gds_file.gds19
DEFINE g_gds_chart   DYNAMIC ARRAY OF RECORD
         gds01          LIKE gds_file.gds01, #項次
         gds03          LIKE gds_file.gds03, #欄位代號
         gds04          LIKE gds_file.gds04, #欄位說明
         gds26          LIKE gds_file.gds26, #分類欄位
         gds24          LIKE gds_file.gds24, #圖表順序
         gds25          LIKE gds_file.gds25, #1.長條 2.線
         gds27          LIKE gds_file.gds27  #彙總欄位
                    END RECORD
DEFINE  g_gds_chart_t RECORD
         gds01          LIKE gds_file.gds01, #項次
         gds03          LIKE gds_file.gds03, #欄位代號
         gds04          LIKE gds_file.gds04, #欄位說明
         gds26          LIKE gds_file.gds26, #分類欄位
         gds24          LIKE gds_file.gds24, #圖表順序
         gds25          LIKE gds_file.gds25, #1.長條 2.線
         gds27          LIKE gds_file.gds27  #彙總欄位
                    END RECORD
DEFINE g_gds03              LIKE gds_file.gds03
DEFINE g_gds02              LIKE gds_file.gds02
DEFINE g_gaz03              LIKE gaz_file.gaz03
DEFINE g_zx02               LIKE zx_file.zx02
DEFINE g_zw02               LIKE zw_file.zw02
DEFINE g_cnt                LIKE type_file.num10    # INTEGER
DEFINE g_msg                LIKE type_file.chr1000  # 
DEFINE g_forupd_sql         STRING
DEFINE g_before_input_done  LIKE type_file.num5     # SMALLINT
DEFINE g_argv1              LIKE gds_file.gds00
DEFINE g_argv2              STRING
DEFINE g_curs_index         LIKE type_file.num10    # INTEGER
DEFINE g_row_count          LIKE type_file.num10    # INTEGER
DEFINE g_sub_row_count      LIKE type_file.num10    # INTEGER
DEFINE g_jump               LIKE type_file.num10    # INTEGER
DEFINE g_no_ask             LIKE type_file.num5     # SMALLINT
DEFINE g_4rpdir             STRING
DEFINE g_gds_f              DYNAMIC ARRAY OF RECORD LIKE gds_file.*
DEFINE m_srccode            DYNAMIC ARRAY OF STRING         #原始程式碼陣列
DEFINE l_zaw01 LIKE zaw_file.zaw01
DEFINE l_gaz03 LIKE gaz_file.gaz03
DEFINE m_mainLn     LIKE type_file.num10            #原始程式MAIN所在行數
DEFINE m_tmpcode    DYNAMIC ARRAY OF STRING         #產生的暫存程式碼陣列
DEFINE m_trcnt      LIKE type_file.num10            #自訂Record個數
DEFINE g_flddef DYNAMIC ARRAY OF RECORD
           recno       LIKE type_file.num5,
           field_name  LIKE gac_file.gac06,
           table_name  LIKE gac_file.gac05,
           column_name LIKE gac_file.gac06
          ,table_cnt   LIKE type_file.num5     #第幾個TABLE(1->主報表 2以後->子報表)
       END RECORD
DEFINE g_xml         DYNAMIC ARRAY OF RECORD
                     xml01   STRING,
                     xml02   STRING,
                     xml03   STRING,
                     xml04   STRING,
                     xml05   STRING
                     END RECORD
DEFINE g_sql_type    LIKE type_file.chr1  #SQL型態(S:select,T:temptable)
DEFINE g_execmd_sql  STRING 
DEFINE l_ofb   RECORD LIKE ofb_file.*

MAIN
    OPTIONS                                        # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                # 擷取中斷鍵,由程式處理 
    
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)

    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AZZ")) THEN
        EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    INITIALIZE g_gdr_t.* TO NULL

  #TEST
  # SELECT * INTO l_ofb.* FROM ofb_file WHERE ofb01 = '390-09090001' AND ofb03 = 1
  # FOR g_cnt = 3 TO 20
  #     LET l_ofb.ofb03 = g_cnt
  #     INSERT INTO ofb_file VALUES(l_ofb.*)
  # END FOR
  #TEST

    OPEN WINDOW p_xglang_w WITH FORM "azz/42f/p_xglang"
    ATTRIBUTE(STYLE=g_win_style CLIPPED)

    CALL cl_ui_init()

    CALL cl_set_comp_visible('gdr00,gdr13,gds15',FALSE)
    #語言別選項
    CALL cl_set_combo_lang("gds02")

    #行業別選項
    CALL cl_set_combo_industry("gdr09")

    LET g_forupd_sql = " SELECT * from gdr_file ",
                       "  WHERE gdr00 = ? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_xglang_cl CURSOR FROM g_forupd_sql

    LET g_forupd_sql =  "SELECT gds01,gds03,gds04,gds14,gds12,",
                        #"       gds07,gds08,gds05,gds06,gds29,gds30,gds09,",
                        "       gds07,gds08,gds36,gds05,gds06,gds29,gds30,gds09,", #FUN-D30056 add gds36
                        "       gds10,gds11,gds20,gds21,gds22,gds13,gds35,gds31,",
                        "       gds23,gds17,gds16,",
                        "       gds32,gds34,gds15",
                        "  FROM gds_file ",
                        " WHERE gds00=? AND gds01=? ",
                        "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_xglang_bcl CURSOR FROM g_forupd_sql

    CALL p_xglang_menu()

    CLOSE WINDOW p_xglang_w                       # 結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p_xglang_cs()                         # QBE 查詢資料
    CLEAR FORM                                    # 清除畫面
    CALL g_gds.clear()
    LET g_gds03 = NULL

    IF NOT cl_null(g_argv1) THEN
        LET g_wc = "gdr00 = '",g_argv1 CLIPPED,"' "
        LET g_wc2 = " 1=1"
    ELSE
        CALL cl_set_head_visible("","YES")
        LET g_wc = NULL
        LET g_wc2 = NULL
        DIALOG ATTRIBUTE(UNBUFFERED)
            CONSTRUCT g_wc ON gdr00,gdr01,gdr02,gdr04,gdr05,gdr09,gdr03,gdr06,gdr10,gdr13,gds02
                         FROM gdr00,gdr01,gdr02,gdr04,gdr05,gdr09,gdr03,gdr06,gdr10,gdr13,gds02
                ON ACTION controlp
                    CASE
                        WHEN INFIELD(gdr01)
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_gaz"
                            LET g_qryparam.state = "c"
                            LET g_qryparam.arg1 = g_lang
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO gdr01
                            CALL p_xglang_gdrdesc("gdr01",g_gdr.gdr01)
                            NEXT FIELD gdr01
                        WHEN INFIELD(gdr04)
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_zx"
                            LET g_qryparam.default1 = g_gdr.gdr04
                            LET g_qryparam.state = "c"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO gdr04
                            CALL p_xglang_gdrdesc("gdr04",g_gdr.gdr04)
                            NEXT FIELD gdr04
                        WHEN INFIELD(gdr05)
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_zw"
                            LET g_qryparam.default1 = g_gdr.gdr05
                            LET g_qryparam.state = "c"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO gdr05
                            CALL p_xglang_gdrdesc("gdr05",g_gdr.gdr05)
                            NEXT FIELD gdr05
                        OTHERWISE
                            EXIT CASE
                    END CASE
            END CONSTRUCT

            #CONSTRUCT g_wc2 ON gds01,gds03,gds04,gds14,gds12,gds07,gds08,
            CONSTRUCT g_wc2 ON gds01,gds03,gds04,gds14,gds12,gds07,gds08,gds36,  #FUN-D30056 add gds36
                               gds05,gds06,gds29,gds30,gds09,gds10,gds11,gds20,gds21,gds22,
                               gds13,gds35,gds31,gds23,gds17,gds16,gds32,gds34,gds15
                          FROM s_gds[1].gds01,s_gds[1].gds03,s_gds[1].gds04,
                               s_gds[1].gds14,s_gds[1].gds12,s_gds[1].gds07,
                               #s_gds[1].gds08,s_gds[1].gds05,s_gds[1].gds06, 
                               s_gds[1].gds08,s_gds[1].gds36,s_gds[1].gds05,s_gds[1].gds06, #FUN-D30056 add gds36
                               s_gds[1].gds29,s_gds[1].gds30,s_gds[1].gds09,
                               s_gds[1].gds10,s_gds[1].gds11,s_gds[1].gds20,s_gds[1].gds21,
                               s_gds[1].gds22,s_gds[1].gds13,s_gds[1].gds35,s_gds[1].gds31,
                               s_gds[1].gds23,s_gds[1].gds17,s_gds[1].gds16,
                               s_gds[1].gds32,s_gds[1].gds34,s_gds[1].gds15
            END CONSTRUCT
            ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG
            ON ACTION HELP
                CALL cl_show_help()
            ON ACTION controlg
                CALL cl_cmdask()
            ON ACTION about
                CALL cl_about()
            ON ACTION ACCEPT
                LET g_gds02 = GET_FLDBUF(gds02)
                EXIT DIALOG
            ON ACTION CANCEL
                CLEAR FORM
                LET INT_FLAG = 1
                EXIT DIALOG
        END DIALOG

        IF INT_FLAG THEN RETURN END IF
    END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null,null) 

    IF g_wc2 = " 1=1" THEN
        LET g_sql = "SELECT DISTINCT gdr00,gdr01,gdr02,gdr04,gdr05,gds02 ",
                    " FROM gdr_file,gds_file ",
                    " WHERE ",g_wc CLIPPED,
                    "   AND gdr00=gds00 ",
                    " ORDER BY gdr01,gdr02,gdr04,gdr05,gds02"
    ELSE
        LET g_sql = "SELECT DISTINCT gdr00,gdr01,gdr02,gdr04,gdr05,gds02 ",
                    "  FROM gdr_file,gds_file ",
                    " WHERE gdr00=gds00",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " ORDER BY gdr01,gdr02,gdr04,gdr05,gds02"
    END IF 

    DECLARE p_xglang_b_curs SCROLL CURSOR WITH HOLD FROM g_sql # 宣告成可捲動的

END FUNCTION

 # 選出筆數直接寫入 g_row_count
FUNCTION p_xglang_count()
DEFINE l_gdr00  LIKE gdr_file.gdr00

    IF g_wc2 = " 1=1" THEN
       LET g_sql = "SELECT DISTINCT gdr00 ",
                   " FROM gdr_file,gds_file ",
                   " WHERE ",g_wc CLIPPED,
                   "   AND gdr00=gds00"
    ELSE
       LET g_sql = "SELECT DISTINCT gdr00 ",
                   " FROM gdr_file,gds_file ",
                   " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "   AND gdr00=gds00"
    END IF
    DECLARE p_xglang_count_cs CURSOR FROM g_sql
    LET g_row_count = 0
    FOREACH p_xglang_count_cs INTO l_gdr00
        LET g_row_count = g_row_count + 1
    END FOREACH
    DISPLAY g_row_count TO formonly.cnt
END FUNCTION

FUNCTION p_xglang_menu()

   WHILE TRUE
      CALL p_xglang_bp("G")

      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_xglang_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_xglang_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_xglang_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_xglang_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_xglang_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "scan_column"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_g_b('Y')
               CALL p_xglang_b_fill('1=1')
            END IF
         WHEN "resort"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_resort('Y')
            END IF
         WHEN "sub_report"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_sub()
            END IF
         WHEN "chart_set"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_chart()
            END IF
         WHEN "copy_other_lang"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_copy_other_lang()
            END IF
         WHEN "xml_read_column"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_genxml()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gds),'','')
            END IF
        #FUN-D20057 ---(S)
         WHEN "gcw_act"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_gcw()
            END IF
        #FUN-D20057 ---(E)
       #FUN-D40059---start
         WHEN "clear_gdr16"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_clear_gdr16()
            END IF
       #FUN-D40059---end
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_xglang_q()                            #Query 查詢
    CALL cl_msg("")
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index,g_row_count )
    CLEAR FORM
    CALL g_gds.clear()
    DISPLAY '' TO FORMONLY.cnt
    CALL p_xglang_cs()                         #取得查詢條件
    IF INT_FLAG THEN                              #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN p_xglang_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN                         #有問題
        CALL cl_err('',SQLCA.SQLCODE,0)
        INITIALIZE g_gdr.* TO NULL
    ELSE
        CALL p_xglang_count()
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL p_xglang_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION p_xglang_fetch(p_flag)                #處理資料的讀取
    DEFINE  p_flag  LIKE type_file.chr1         #處理方式     

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_xglang_b_curs INTO g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,g_gdr.gdr05,g_gds02
        WHEN 'P' FETCH PREVIOUS p_xglang_b_curs INTO g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,g_gdr.gdr05,g_gds02
        WHEN 'F' FETCH FIRST    p_xglang_b_curs INTO g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,g_gdr.gdr05,g_gds02
        WHEN 'L' FETCH LAST     p_xglang_b_curs INTO g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,g_gdr.gdr05,g_gds02
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0

                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                    ON ACTION controlp
                        CALL cl_cmdask()
                    ON ACTION HELP
                        CALL cl_show_help()
                    ON ACTION about
                        CALL cl_about()
                END PROMPT

                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump p_xglang_b_curs INTO g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,g_gdr.gdr05,g_gds02
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gdr.gdr01,SQLCA.sqlcode,0)
        INITIALIZE g_gdr.* TO NULL
        RETURN
    ELSE
        CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump
        END CASE

        CALL cl_navigator_setting(g_curs_index,g_row_count)
    END IF

    CALL p_xglang_show()
END FUNCTION


FUNCTION p_xglang_show()                         # 將資料顯示在畫面上
DEFINE l_chk  LIKE type_file.chr10

    SELECT * INTO g_gdr.* FROM gdr_file WHERE gdr00 = g_gdr.gdr00
    CALL p_xglang_gdrdesc("gdr01",g_gdr.gdr01)
    CALL p_xglang_gdrdesc("gdr04",g_gdr.gdr04)
    CALL p_xglang_gdrdesc("gdr05",g_gdr.gdr05)
    LET g_sql = "SELECT gds02 FROM gds_file WHERE gds00 = ",g_gdr.gdr00
    PREPARE p_xglang_gds02_pr FROM g_sql
    DECLARE p_xglang_gds02_cs CURSOR FOR p_xglang_gds02_pr
    OPEN p_xglang_gds02_cs
    FETCH p_xglang_gds02_cs INTO g_gds02
    CLOSE p_xglang_gds02_cs
    IF cl_null(g_gds02) THEN LET g_gds02 = g_lang END IF
    DISPLAY BY NAME g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,
                    g_gdr.gdr05,g_gdr.gdr06,g_gdr.gdr09,g_gdr.gdr03,
                    g_gdr.gdr10,g_gdr.gdr13
                   ,g_gdr.gdr21 #FUN-D20057
                   #FUN-CC0039 add --start--
                   ,g_gdr.gdr16,g_gdr.gdr17,g_gdr.gdruser,g_gdr.gdrmodu
                   ,g_gdr.gdrdate,g_gdr.gdrgrup
                   #FUN-CC0039 add --end--
    DISPLAY g_gds02 TO gds02
    CALL p_xglang_show_habit(g_gdr.gdr16,'1') #FUN-D30056
    CALL p_xglang_show_habit(g_gdr.gdr17,'2') #FUN-D30056
   #掃描4gl，檢查是否符合此功能 ( CALL cl_prt_cs1 的才繼續下去)
    CALL p_xglang_chk_include() RETURNING l_chk
    IF l_chk = 'cs1' THEN
       CALL cl_set_act_visible('xml_read_column',TRUE)
    ELSE
       CALL cl_set_act_visible('xml_read_column',FALSE)
    END IF
    CALL p_xglang_show_column()
    CALL p_xglang_show_act()
      
    CALL p_xglang_b_fill(g_wc2)                    # 單身
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION p_xglang_r()        # 取消整筆 (所有合乎單頭的資料)

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_gdr.gdr00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
           
    BEGIN WORK    
    LET g_success = 'Y'
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM gdr_file WHERE gdr00 = g_gdr.gdr00
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","gdr_file",g_gdr.gdr00,"",SQLCA.sqlcode,"","BODY DELETE",0)
           LET g_success = 'N'
        END IF
        DELETE FROM gds_file WHERE gds00 = g_gdr.gdr00
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","gds_file",g_gdr.gdr00,"",SQLCA.sqlcode,"","BODY DELETE",0)
           LET g_success = 'N'
        END IF
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL g_gds.clear()
       OPEN p_xglang_b_curs
       IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL p_xglang_fetch('L')
       ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL p_xglang_fetch('/')
       END IF
    ELSE
       ROLLBACK WORK
    END IF

END FUNCTION

FUNCTION p_xglang_b()                              # 單身
    DEFINE  l_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT SMALLINT
            l_n,i           LIKE type_file.num5,   # 檢查重複用 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否 
            p_cmd           LIKE type_file.chr1,   # 處理狀態   
            l_allow_insert  LIKE type_file.num5,   # SMALLINT
            l_allow_delete  LIKE type_file.num5,   # SMALLINT
            ls_msg_o        STRING,
            l_str           STRING,
            l_cnt           LIKE type_file.num5,
            ls_msg_n        STRING
    DEFINE  l_max_cols      LIKE type_file.num5

    LET g_action_choice = ""
    IF s_shut(0) THEN
        RETURN
    END IF
    IF cl_null(g_gdr.gdr00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    CALL cl_opmsg('b')

    #LET l_allow_insert = cl_detail_input_auth("insert")
    #LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_allow_insert = FALSE  #不允許新增一筆單身資料
    LET l_allow_delete = FALSE  #不允許刪除一筆單身資料

    LET l_ac_t = 0

  WHILE TRUE #FUN-D30056 
    INPUT ARRAY g_gds WITHOUT DEFAULTS FROM s_gds.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()
            LET g_before_input_done = TRUE

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()

            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_gds_t.* = g_gds[l_ac].*    #BACKUP
                OPEN p_xglang_bcl USING g_gdr.gdr00,g_gds_t.gds01
                IF SQLCA.sqlcode THEN
                    CALL cl_err("OPEN p_xglang_bcl:",STATUS,1)
                    LET l_lock_sw = 'Y'
                ELSE
                    FETCH p_xglang_bcl INTO g_gds[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('FETCH p_xglang_bcl:',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()
            END IF
            CALL p_xglang_set_no_required_b()
            CALL p_xglang_set_required_b()
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gds[l_ac].* TO NULL
            LET g_gds_t.* = g_gds[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD gds01

   #    AFTER INSERT
   #        IF INT_FLAG THEN
   #            CALL cl_err('',9001,0)
   #            LET INT_FLAG = 0
   #            CANCEL INSERT
   #        END IF
   #        INSERT INTO gds_file
   #            VALUES (g_gdr.gdr00,
   #                    g_gds[l_ac].gds01,
   #                    g_gds02,
   #                    g_gds[l_ac].gds03,
   #                    g_gds[l_ac].gds04,
   #                    g_gds[l_ac].gds05,
   #                    g_gds[l_ac].gds06,
   #                    g_gds[l_ac].gds07,
   #                    g_gds[l_ac].gds08,
   #                    g_gds[l_ac].gds09,
   #                    g_gds[l_ac].gds10,
   #                    g_gds[l_ac].gds11,
   #                    g_gds[l_ac].gds12,
   #                    g_gds[l_ac].gds13,
   #                    g_gds[l_ac].gds14,
   #                    g_gds[l_ac].gds15,
   #                    g_gds[l_ac].gds16)
   #        IF SQLCA.sqlcode THEN
   #            CALL cl_err3("ins","gds_file",g_gdr.gdr00,g_gds[l_ac].gds01,SQLCA.sqlcode,"","",0)
   #            CANCEL INSERT
   #        ELSE
   #            MESSAGE 'INSERT O.K'
   #            LET g_rec_b = g_rec_b + 1
   #            DISPLAY g_rec_b TO FORMONLY.cn2
   #        END IF

   #    BEFORE DELETE                            #是否取消單身
   #        IF NOT cl_null(g_gds_t.gds01) THEN
   #            IF NOT cl_delb(0,0) THEN
   #                CANCEL DELETE
   #            END IF
   #            IF l_lock_sw = "Y" THEN
   #                CALL cl_err("",-263,1)
   #                CANCEL DELETE
   #            END IF
   #            DELETE FROM gds_file WHERE gds00 = g_gdr.gdr00
   #                                   AND gds01 = g_gds_t.gds01
   #            IF SQLCA.sqlcode THEN
   #                CALL cl_err3("del","gds_file",g_gdr.gdr00,g_gds_t.gds01,SQLCA.sqlcode,"","",0)
   #                ROLLBACK WORK
   #                CANCEL DELETE
   #            END IF
   #            LET g_rec_b = g_rec_b - 1
   #            DISPLAY g_rec_b TO FORMONLY.cn2
   #        END IF
   #        COMMIT WORK

         AFTER FIELD gds04
            IF NOT cl_null(g_gds[l_ac].gds04) THEN
               LET l_str = g_gds[l_ac].gds04
               LET l_cnt = l_str.getIndexOf(":",1)
               IF l_cnt > 0 THEN
                  CALL cl_err('','azz1295',1)
                  NEXT FIELD CURRENT
               END IF
               LET l_cnt = l_str.getIndexOf(",",1)
               IF l_cnt > 0 THEN
                  CALL cl_err('','azz1295',1)
                  NEXT FIELD CURRENT
               END IF
            END IF

        AFTER FIELD gds05
            IF NOT cl_null(g_gds[l_ac].gds05) THEN
               IF g_gds[l_ac].gds05 <= 0 THEN
                  NEXT FIELD CURRENT
               END IF
            END IF

        AFTER FIELD gds06
            IF NOT cl_null(g_gds[l_ac].gds06) THEN
               IF g_gds[l_ac].gds06 <= 0 THEN
                  NEXT FIELD CURRENT
               END IF
            END IF

        AFTER FIELD gds29
            IF NOT cl_null(g_gds[l_ac].gds29) THEN
               IF g_gds[l_ac].gds29 <= 0 THEN
                  NEXT FIELD CURRENT
               END IF
            END IF

      #FUN-D30056 add---(S)
        AFTER FIELD gds36
            IF NOT cl_null(g_gds[l_ac].gds36) THEN
               IF g_gds[l_ac].gds36 <= 0 THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
      #FUN-D30056 add---(E)

        AFTER FIELD gds07
            IF g_gds[l_ac].gds07 NOT MATCHES '[0123456]' THEN
               NEXT FIELD CURRENT
            END IF

        AFTER FIELD gds08
            IF g_gds[l_ac].gds08 NOT MATCHES '[0123456]' THEN
               NEXT FIELD CURRENT
            END IF

        BEFORE FIELD gds09
            CALL p_xglang_set_no_required_b()
            CALL p_xglang_set_required_b()
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()

        AFTER FIELD gds09 
            IF g_gds[l_ac].gds09 NOT MATCHES '[YN]' THEN 
               NEXT FIELD CURRENT
            END IF
            CALL p_xglang_set_no_required_b()
            CALL p_xglang_set_required_b()
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()
            IF g_gds[l_ac].gds10='Y' OR g_gds[l_ac].gds09='Y' THEN
               LET g_gds[l_ac].gds20=' ' 
            END IF

        ON CHANGE gds09
            CALL p_xglang_set_no_required_b()
            CALL p_xglang_set_required_b()
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()

        BEFORE FIELD gds10
            CALL p_xglang_set_no_required_b()
            CALL p_xglang_set_required_b()
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()

        AFTER FIELD gds10
            IF g_gds[l_ac].gds10 NOT MATCHES '[YN]' THEN 
               NEXT FIELD CURRENT
            END IF
            CALL p_xglang_set_no_required_b()
            CALL p_xglang_set_required_b()
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()
            IF g_gds[l_ac].gds10='Y' OR g_gds[l_ac].gds09='Y' THEN
               LET g_gds[l_ac].gds20=' ' 
            END IF

        ON CHANGE gds10
            CALL p_xglang_set_no_required_b()
            CALL p_xglang_set_required_b()
            CALL p_xglang_set_entry_b()
            CALL p_xglang_set_no_entry_b()

        BEFORE FIELD gds13
            CALL p_xglang_set_gds13_combo()

        BEFORE FIELD gds35
            CALL p_xglang_set_gds35_combo()

        BEFORE FIELD gds31
            CALL p_xglang_set_gds31_combo()

        BEFORE FIELD gds14
           CALL p_xglang_set_entry_b()
           CALL p_xglang_set_no_entry_b()

        AFTER FIELD gds14
           IF NOT cl_null(g_gds[l_ac].gds14) THEN
              IF g_gds[l_ac].gds14 = 'N' THEN
                 LET g_gds[l_ac].gds07 = '6'
                 LET g_gds[l_ac].gds08 = '6'
              END IF
           END IF
           CALL p_xglang_set_entry_b()
           CALL p_xglang_set_no_entry_b()

     #  ON CHANGE gds20
     #     IF g_gds[l_ac].gds20 MATCHES '[Y]' THEN
     #        FOR i = 1 TO g_gds.getlength()
     #            IF i = l_ac THEN CONTINUE FOR END IF
     #            LET g_gds[i].gds20 = 'N' 
     #        END FOR
     #     END IF

     #  AFTER FIELD gds20
     #     CALL p_xglang_show_column()

        ON CHANGE gds21
           IF g_gds[l_ac].gds21 MATCHES '[Y]' THEN
              FOR i = 1 TO g_gds.getlength()
                  IF i = l_ac THEN CONTINUE FOR END IF
                  LET g_gds[i].gds21 = 'N' 
              END FOR
           END IF

        ON CHANGE gds22
           IF g_gds[l_ac].gds22 MATCHES '[Y]' THEN
              FOR i = 1 TO g_gds.getlength()
                  IF i = l_ac THEN CONTINUE FOR END IF
                  LET g_gds[i].gds22 = 'N' 
              END FOR
           END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gds[l_ac].* = g_gds_t.*
               CLOSE p_xglang_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gds[l_ac].gds01,-263,1)
               LET g_gds[l_ac].* = g_gds_t.*
           ELSE
               IF cl_null(g_gds[l_ac].gds20) THEN
                  LET g_gds[l_ac].gds20 = ' '
               END IF
               UPDATE gds_file SET gds01 = g_gds[l_ac].gds01,
                                   gds03 = g_gds[l_ac].gds03,
                                   gds04 = g_gds[l_ac].gds04,
                                   gds05 = g_gds[l_ac].gds05,
                                   gds06 = g_gds[l_ac].gds06,
                                   gds07 = g_gds[l_ac].gds07,
                                   gds08 = g_gds[l_ac].gds08,
                                   gds09 = g_gds[l_ac].gds09,
                                   gds10 = g_gds[l_ac].gds10,
                                   gds11 = g_gds[l_ac].gds11,
                                   gds12 = g_gds[l_ac].gds12,
                                   gds13 = g_gds[l_ac].gds13,
                                   gds14 = g_gds[l_ac].gds14,
                                   gds15 = g_gds[l_ac].gds15,
                                   gds16 = g_gds[l_ac].gds16,
                                   gds17 = g_gds[l_ac].gds17,
                                  #gds19 = g_gds[l_ac].gds19,
                                   gds20 = g_gds[l_ac].gds20,
                                   gds21 = g_gds[l_ac].gds21,
                                   gds22 = g_gds[l_ac].gds22,
                                   gds23 = g_gds[l_ac].gds23,
                                   gds30 = g_gds[l_ac].gds30,
                                   gds31 = g_gds[l_ac].gds31,
                                   gds32 = g_gds[l_ac].gds32,
                                   gds34 = g_gds[l_ac].gds34,
                                   gds35 = g_gds[l_ac].gds35,
                                   gds36 = g_gds[l_ac].gds36, #FUN-D30056
                                   gds29 = g_gds[l_ac].gds29
                 WHERE gds00 = g_gdr.gdr00 
                   AND gds01 = g_gds_t.gds01
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_gds_t.gds01,SQLCA.sqlcode,"","",0)
                    LET g_gds[l_ac].* = g_gds_t.*
                ELSE
                   CALL p_xglang_upd_gds2()
                   IF g_success = 'Y' THEN
                      MESSAGE 'UPDATE O.K'
                      COMMIT WORK
                   ELSE
                      ROLLBACK WORK
                      LET g_gds[l_ac].* = g_gds_t.*
                   END IF
                END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac

            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                #LET INT_FLAG = 0 #FUN-D30056 mark
                IF p_cmd='u' THEN
                   LET g_gds[l_ac].* = g_gds_t.*
                END IF
                CLOSE p_xglang_bcl
                ROLLBACK WORK
                EXIT INPUT
            END IF
            CLOSE p_xglang_bcl
            COMMIT WORK
            

        ON ACTION controlp


        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(gds02) AND l_ac > 1 THEN
                LET g_gds[l_ac].* = g_gds[l_ac-1].*
                NEXT FIELD gds02
            END IF

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLZ
            CALL cl_show_req_fields()

        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

        ON ACTION HELP
            CALL cl_show_help()

        ON ACTION about
            CALL cl_about()

        ON ACTION controls
            CALL cl_set_head_visible("","AUTO")

    END INPUT
    IF p_xglang_chkerror_gds36() THEN
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG=0
       EXIT WHILE #FUN-D30056
    END IF
    EXIT WHILE
  END WHILE #FUN-D30056 

    CLOSE p_xglang_bcl
    COMMIT WORK
    CALL p_xglang_resort('Y')
    CALL p_xglang_chkerror()
    CALL p_xglang_b_fill(" 1=1")

END FUNCTION

FUNCTION p_xglang_b_fill(p_wc2)               #BODY FILL UP
    DEFINE  p_wc2            STRING
    DEFINE  l_combo_item     LIKE type_file.chr1000
    DEFINE  l_combo_item2    LIKE type_file.chr1000

    LET g_sql = "SELECT gds01,gds03,gds04,gds14,gds12,",
                #"       gds07,gds08,gds05,gds06,gds29,gds30,gds09,",
                "       gds07,gds08,gds36,gds05,gds06,gds29,gds30,gds09,", #FUN-D30056 add gds36
                "       gds10,gds11,gds20,gds21,gds22,gds13,gds35,gds31,",
                "       gds23,gds17,gds16,",
                "       gds32,gds34,gds15",
                " FROM gds_file",
                " WHERE gds00=? AND gds02=?",
                "   AND gds18 = 1 ",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY gds01"
    DECLARE p_xglang_b_fill_curs CURSOR FROM g_sql

    CALL g_gds.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    LET l_combo_item=NULL
    LET l_combo_item2=NULL
    FOREACH p_xglang_b_fill_curs USING g_gdr.gdr00,g_gds02 INTO g_gds[g_cnt].*       #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    #  #for gds13 (幣別取位對應欄位)
    #   IF g_gds[g_cnt].gds32= 'Y' THEN
    #      LET l_combo_item = l_combo_item CLIPPED,g_gds[g_cnt].gds03 CLIPPED,","
    #   END IF
    #  #for gds31 (條件隱藏欄位)
    #   IF g_gds[g_cnt].gds34= 'Y' THEN
    #      LET l_combo_item2= l_combo_item2 CLIPPED,g_gds[g_cnt].gds03 CLIPPED,","
    #   END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gds.deleteElement(g_cnt)

  # IF LENGTH(l_combo_item) > 1 THEN
  #    LET l_combo_item = l_combo_item[1,LENGTH(l_combo_item)-1]
  # END IF
  # CALL cl_set_combo_items('gds13',l_combo_item,'')

  # IF LENGTH(l_combo_item2) > 1 THEN
  #    LET l_combo_item2 = l_combo_item2[1,LENGTH(l_combo_item2)-1]
  # END IF
  # CALL cl_set_combo_items('gds31',l_combo_item2,'')
    CALL p_xglang_set_gds13_combo()
    CALL p_xglang_set_gds31_combo()
    CALL p_xglang_set_gds35_combo()

    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION p_xglang_bp(p_ud)
    DEFINE   p_ud   LIKE type_file.chr1          

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF

    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel",FALSE)
    CALL SET_COUNT(g_rec_b)
    DISPLAY ARRAY g_gds TO s_gds.* ATTRIBUTE(UNBUFFERED)

        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)

        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

        ON ACTION insert                           # A.輸入
            LET g_action_choice='insert'
            EXIT DISPLAY

        ON ACTION query                            # Q.查詢
            LET g_action_choice='query'
            EXIT DISPLAY

        ON ACTION modify                           # Q.修改
            LET g_action_choice='modify'
            EXIT DISPLAY

        ON ACTION reproduce                        # C.複製
            LET g_action_choice='reproduce'
            EXIT DISPLAY

        ON ACTION delete                           # R.取消
            LET g_action_choice='delete'
            EXIT DISPLAY

        ON ACTION detail                           # B.單身
            LET g_action_choice='detail'
            LET l_ac = ARR_CURR()
            EXIT DISPLAY

        ON ACTION ACCEPT
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DISPLAY

        ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DISPLAY

        ON ACTION first                            # 第一筆
            CALL p_xglang_fetch('F')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION previous                         # P.上筆
            CALL p_xglang_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION jump                             # 指定筆
            CALL p_xglang_fetch('/')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION next                             # N.下筆
            CALL p_xglang_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION last                             # 最終筆
            CALL p_xglang_fetch('L')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION help                             # H.說明
            LET g_action_choice='help'
            EXIT DISPLAY

        ON ACTION sub_report
            LET g_action_choice='sub_report'
            EXIT DISPLAY

        ON ACTION chart_set
            LET g_action_choice='chart_set'
            EXIT DISPLAY

        ON ACTION copy_other_lang
            LET g_action_choice='copy_other_lang'
            EXIT DISPLAY
        ON ACTION xml_read_column
            LET g_action_choice='xml_read_column'
            EXIT DISPLAY

        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            EXIT DISPLAY

        ON ACTION exit                             # Esc.結束
            LET g_action_choice='exit'
            EXIT DISPLAY

        ON ACTION CLOSE
            LET g_action_choice='exit'
            EXIT DISPLAY

        ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DISPLAY

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

        ON ACTION about
            CALL cl_about()

        ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DISPLAY

        ON ACTION scan_column
            LET g_action_choice = 'scan_column'
            EXIT DISPLAY

        ON ACTION resort
            LET g_action_choice = 'resort'
            EXIT DISPLAY

       #
        ON ACTION gcw_act
            LET g_action_choice = 'gcw_act'
            EXIT DISPLAY

       #FUN-D40059---start
        ON ACTION clear_gdr16
            LET g_action_choice = 'clear_gdr16'
            EXIT DISPLAY
       #FUN-D40059---end

        AFTER DISPLAY
            CONTINUE DISPLAY

        ON ACTION controls
            CALL cl_set_head_visible("","AUTO")

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION p_xglang_gdrdesc(l_column,l_value)
    DEFINE  l_column    STRING,
            l_value     LIKE type_file.chr10

    CASE l_column
        WHEN "gdr01"
            SELECT gaz03 INTO g_gaz03 FROM gaz_file
             WHERE gaz01 = l_value AND gaz02 = g_lang
            IF SQLCA.SQLCODE THEN
                LET g_gaz03 = ""
            END IF
            DISPLAY g_gaz03 TO gaz03
        WHEN "gdr05"
            SELECT zw02 INTO g_zw02 FROM zw_file
             WHERE zw01 = l_value
            IF SQLCA.SQLCODE THEN
                LET g_zw02 = ""
            END IF
            IF l_value = "default" THEN
                LET g_zw02 = "default"
            END IF
            DISPLAY g_zw02 TO zw02
        WHEN "gdr04"
            SELECT zx02 INTO g_zx02 FROM zx_file
             WHERE zx01 = l_value
            IF SQLCA.SQLCODE THEN
                LET g_zx02 = ""
            END IF
            IF l_value = "default" THEN
                LET g_zx02 = "default"
            END IF
            DISPLAY g_zx02 TO zx02
   END CASE
END FUNCTION

FUNCTION p_xglang_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

    CALL cl_set_comp_entry("gdr00,gdr09,",TRUE)

END FUNCTION

FUNCTION p_xglang_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("gdr00,gdr09,",FALSE)
    END IF

END FUNCTION

FUNCTION p_xglang_set_entry_b()

    IF l_ac <=0 THEN RETURN END IF
    CALL cl_set_comp_entry('gds06,gds05,gds07,gds08,gds09,gds10,gds11,gds20',TRUE)

END FUNCTION

FUNCTION p_xglang_set_no_entry_b()

    IF l_ac <=0 THEN RETURN END IF
    IF g_gds[l_ac].gds14 = 'N' THEN
       CALL cl_set_comp_entry('gds07,gds08',FALSE)
    END IF
    IF g_gdr.gdr06 = '5' THEN
       IF g_gds[l_ac].gds09='Y' THEN 
          CALL cl_set_comp_entry('gds10',FALSE)
       END IF
       IF g_gds[l_ac].gds10='Y' THEN 
          CALL cl_set_comp_entry('gds09',FALSE)
       END IF
       IF g_gds[l_ac].gds09='N' AND g_gds[l_ac].gds10='N' THEN 
          CALL cl_set_comp_entry('gds11',FALSE)
       END IF
       IF g_gds[l_ac].gds09='Y' OR g_gds[l_ac].gds10='Y' THEN 
          CALL cl_set_comp_entry('gds20',FALSE)
       END IF
      #IF g_gds[l_ac].gds12='1' THEN #單頭欄位
      #   CALL cl_set_comp_entry('gds20',FALSE)
      #END IF
    END IF

END FUNCTION

FUNCTION p_xglang_copy()
DEFINE l_n  LIKE type_file.num5
DEFINE l_gds  RECORD LIKE gds_file.*

    IF g_gdr.gdr00 = 0 OR cl_null(g_gdr.gdr00) THEN CALL cl_err('',-400,1) RETURN END IF
    CALL cl_set_comp_entry('gdr01,gds02',FALSE)
    LET b_gdr.* = g_gdr.*

    SELECT MAX(gdr00) INTO l_n
      FROM gdr_file
    IF cl_null(l_n) THEN LET l_n=0 END IF
    LET g_gdr.gdr00 = l_n + 1

    BEGIN WORK
    LET g_success = 'Y'
    CALL p_xglang_i('c')

    IF NOT g_xglang_ins_gdr() THEN
       LET g_success = 'N'
    END IF

    IF g_success = 'Y' THEN
       DECLARE p_xglang_sel_gds_copy CURSOR FOR
        SELECT * FROM gds_file WHERE gds00 = b_gdr.gdr00
       FOREACH p_xglang_sel_gds_copy INTO l_gds.*
          IF STATUS THEN
             CALL cl_err('foreach gds_copy:',STATUS,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          LET l_gds.gds00 = g_gdr.gdr00

          INSERT INTO gds_file VALUES(l_gds.*)
          IF STATUS THEN
             CALL cl_err('ins gds_copy:',STATUS,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       END FOREACH
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_set_comp_entry('gdr01,gds02',TRUE)

END FUNCTION

FUNCTION p_xglang_u()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gdr.gdr00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL cl_opmsg('u')
   LET g_gdr_t.* = g_gdr.*

   BEGIN WORK
   OPEN p_xglang_cl USING g_gdr.gdr00
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_xglang_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_xglang_cl INTO g_gdr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zaw01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_xglang_cl
      ROLLBACK WORK
      RETURN
   END IF

   DISPLAY BY NAME g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,
                   g_gdr.gdr05,g_gdr.gdr09,g_gdr.gdr03,g_gdr.gdr06
   DISPLAY g_gds02 TO gds02

   WHILE TRUE
      CALL p_xglang_i("u")
      IF INT_FLAG THEN
         LET g_gdr.* = g_gdr_t.*
         DISPLAY BY NAME g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,
                         g_gdr.gdr05,g_gdr.gdr09,g_gdr.gdr03,g_gdr.gdr06
         DISPLAY g_gds02 TO gds02
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE gdr_file SET gdr01 = g_gdr.gdr01,
                          gdr02 = g_gdr.gdr02,
                          gdr03 = g_gdr.gdr03,
                          gdr04 = g_gdr.gdr04,
                          gdr05 = g_gdr.gdr05,
                          gdr06 = g_gdr.gdr06,
                          gdr07 = g_gdr.gdr07,
                          gdr08 = g_gdr.gdr08,
                          gdr09 = g_gdr.gdr09,
                          gdr10 = g_gdr.gdr10,
                          gdr13 = g_gdr.gdr13,
                          gdr21 = g_gdr.gdr21, #FUN-D20057
                          gdrmodu = g_user , 
                          gdrdate = g_today
       WHERE gdr00 = g_gdr_t.gdr00
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_gdr.gdr01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE p_xglang_cl
   COMMIT WORK

END FUNCTION

FUNCTION p_xglang_a()                            # Add  輸入
DEFINE l_n  LIKE type_file.num5
DEFINE l_chk  LIKE type_file.chr10
   MESSAGE ""
   CLEAR FORM
   CALL g_gds.clear()

   INITIALIZE g_gdr.* TO NULL
   LET g_gdr.gdr09 = 'std'
   LET g_gdr.gdr03 = 'N'
   LET g_gdr.gdr10 = '1'
   LET g_gdr.gdr13 = 'N'
   SELECT MAX(gdr00) INTO l_n
     FROM gdr_file
   IF cl_null(l_n) THEN LET l_n=0 END IF
   LET g_gdr.gdr00 = l_n+1

   CALL cl_opmsg('a')

   WHILE TRUE
      BEGIN WORK
      CALL p_xglang_i("a")                       # 輸入單頭

      IF INT_FLAG THEN                            # 使用者不玩了
         INITIALIZE g_gdr.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF NOT g_xglang_ins_gdr() THEN
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      

      LET g_rec_b = 0
      CALL p_xglang_chk_include() RETURNING l_chk
      IF l_chk = 'cs3' THEN
         CALL p_xglang_g_b('N')
      ELSE
         CALL p_xglang_genxml()
      END IF
      CALL p_xglang_resort('N')
      CALL p_xglang_b_fill('1=1')             # 單身

      CALL p_xglang_b()                       # 輸入單身
      CALL p_xglang_delall()
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p_xglang_g_b(p_ask)
DEFINE p_ask         LIKE type_file.chr1
DEFINE l_4gldir LIKE type_file.chr1000
DEFINE l_tmpline    STRING  #目前所在行內容
DEFINE l_utmpline   STRING  #目前所在行轉大寫後的內容
DEFINE l_varname    STRING  #變數名稱字串
DEFINE l_paramstr   STRING  #參數字串
DEFINE l_tmpTabLn   LIKE type_file.num10 #cl_prt_temptable()所在行數
DEFINE l_lastLn     LIKE type_file.num10 #原始程式最後比對的行數
DEFINE l_cs3Ln      LIKE type_file.num10 #cl_prt_cs3()所在行數
DEFINE l_ttsqlLnS   LIKE type_file.num10 #TempTable SQL開始行數
DEFINE l_ttsqlLnE   LIKE type_file.num10 #TempTable SQL結束行數
DEFINE l_cs3sqlLnS  LIKE type_file.num10 #cs3 SQL開始行數
DEFINE l_cs3sqlLnE  LIKE type_file.num10 #cs3 SQL結束行數
DEFINE l_cs3strLnS  LIKE type_file.num10 #cs3 Str開始行數
DEFINE l_cs3strLnE  LIKE type_file.num10 #cs3 Str結束行數
DEFINE l_i          LIKE type_file.num10
DEFINE l_gaq07      LIKE gaq_file.gaq07
DEFINE l_udatatype  STRING
DEFINE l_table_cnt  LIKE type_file.num5
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_gds00      LIKE gds_file.gds00
DEFINE l_gds01      LIKE gds_file.gds01
DEFINE l_gds03      LIKE gds_file.gds03
DEFINE l_chk        LIKE type_file.chr10

   #掃描4gl，檢查是否符合此功能 ( CALL cl_prt_cs1 的才繼續下去)
    CALL p_xglang_chk_include() RETURNING l_chk
    IF l_chk = 'cs1' THEN
       CALL cl_err('','azz1275',1) #請改用手動輸入
       RETURN
    END IF

    IF p_ask = 'Y' THEN
       IF NOT cl_confirm('azz1267') THEN RETURN END IF
    END IF

    LET l_4gldir = p_xglang_get_4gldir(g_gdr.gdr01)
    IF cl_null(l_4gldir) THEN RETURN END IF
    CALL p_xglang_load_source(l_4gldir)
     
    #找出cl_prt_temptable()的程式段
    LET m_mainLn = 0
    LET l_tmpTabLn = 0
    LET l_lastLn = 1
    LET m_trcnt = 0
    CALL g_flddef.clear()  
    LET l_table_cnt = 1
    FOR l_i = 1 TO m_srccode.getLength()
        LET l_tmpline = p_xglang_rm_line_mark(m_srccode[l_i])

        IF l_tmpline IS NOT NULL THEN
            LET l_paramstr = p_xglang_get_substr(l_tmpline,"cl_prt_temptable(",")")
            #找到cl_prt_temptable()該行
            IF l_paramstr IS NOT NULL THEN
                #設定cl_prt_temptable()所在行數
                LET l_tmpTabLn = l_i
                LET l_varname = p_xglang_get_str_part(l_paramstr,",",-1)
                CALL p_xglang_find_lineno(l_varname,l_lastLn,l_tmpTabLn)
                    RETURNING l_ttsqlLnS,l_ttsqlLnE
                LET m_trcnt = m_trcnt + 1
                CALL p_xglang_add_typedef_code(m_tmpcode,l_ttsqlLnS,l_ttsqlLnE,l_table_cnt)
               #CALL p_xglang_add_typedef_code(m_tmpcode,l_ttsqlLnS,l_ttsqlLnE)
                #將最後比對行數移到目前行
                LET l_lastLn = l_tmpTabLn
                LET l_table_cnt = l_table_cnt + 1
            END IF

            IF m_mainLn <= 0 THEN
                LET l_utmpline = l_tmpline.toUpperCase()
                IF l_utmpline.getIndexOf("MAIN",1) > 0 THEN
                    LET m_mainLn = l_i
                    #DISPLAY "m_mainLn=",m_mainLn
                END IF
            END IF
        END IF
    END FOR

   #將陣列中的資料寫入 gds_file
    BEGIN WORK
    LET g_success = 'Y'
    FOR l_i = 1 TO g_flddef.getlength()
        CALL p_xglang_ins_gds(g_flddef[l_i].field_name,
                              g_flddef[l_i].table_name,
                              g_flddef[l_i].column_name,
                              g_flddef[l_i].table_cnt)
        IF g_success = 'N' THEN EXIT FOR END IF
    END FOR

   #檢查是否有移除掉的欄位，若有則刪除
    IF g_success = 'Y' THEN
       DECLARE p_xglang_chk_gds_column_cs CURSOR FOR
        SELECT gds00,gds01,gds03 FROM gds_file
         WHERE gds00 = g_gdr.gdr00
       FOREACH p_xglang_chk_gds_column_cs INTO l_gds00,l_gds01,l_gds03
           IF cl_null(l_gds03) THEN CONTINUE FOREACH END IF
           LET l_flag = 'N'
           FOR l_i = 1 TO g_flddef.getlength()
               IF l_gds03 = g_flddef[l_i].field_name THEN
                  LET l_flag = 'Y' #存在最新的欄位中
                  EXIT FOR
               END IF
           END FOR
           IF l_flag = 'N' THEN
              DELETE FROM gds_file 
               WHERE gds00 = l_gds00
                 AND gds01 = l_gds01
           END IF
       END FOREACH
    END IF

   #更新序號(gds01)
    IF g_success = 'Y' THEN
       LET l_i = 1
       DECLARE p_xglang_reseq_cs CURSOR FOR
        SELECT gds00,gds01 FROM gds_file
         WHERE gds00 = g_gdr.gdr00
         ORDER BY gds01
       FOREACH p_xglang_reseq_cs INTO l_gds00,l_gds01
           IF l_i <> l_gds01 THEN
              UPDATE gds_file
                 SET gds01 = l_i
               WHERE gds00 = g_gdr.gdr00
                 AND gds01 = l_gds01
              IF STATUS THEN
                 EXIT FOREACH
              END IF
           END IF
           LET l_i = l_i + 1
       END FOREACH
    END IF
    

    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF

END FUNCTION

##################################################
FUNCTION p_xglang_add_typedef_code(p_strarr,p_startline,p_endline,p_table_cnt)
#FUNCTION p_xglang_add_typedef_code(p_strarr,p_startline,p_endline)
    DEFINE p_table_cnt  LIKE type_file.num5
    DEFINE p_strarr     DYNAMIC ARRAY OF STRING
    DEFINE p_startline  LIKE type_file.num10
    DEFINE p_endline    LIKE type_file.num10
    DEFINE l_curline    STRING      #目前所在行內容
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_charpos    DYNAMIC ARRAY OF LIKE type_file.num10
    DEFINE l_j          LIKE type_file.num10
    DEFINE l_charcnt    LIKE type_file.num10
    DEFINE l_charposCnt LIKE type_file.num10
    DEFINE l_str        STRING
    DEFINE l_nextstr    STRING
    DEFINE lc_strtok    base.StringTokenizer
    DEFINE lc_strbuf    base.StringBuffer
    DEFINE l_codeLines  LIKE type_file.num10
    DEFINE l_dbfcnt     LIKE type_file.num10     #欄位數
    DEFINE l_pos1       LIKE type_file.num10
    DEFINE l_pos2       LIKE type_file.num10

    WHENEVER ERROR CONTINUE
   #CALL g_flddef.clear()
    IF p_startline <= p_endline AND p_startline > 0 THEN
        LET l_codeLines = p_strarr.getLength()
        IF l_codeLines > 0 THEN
            CALL p_strarr.appendElement()
        END IF

        CALL p_strarr.appendElement()
        LET l_codeLines = p_strarr.getLength()
        #LET l_dbfcnt = 0
        LET l_dbfcnt = g_flddef.getlength()

        FOR l_i = p_startline TO p_endline
            LET l_curline = p_xglang_rm_line_mark(m_srccode[l_i])
            IF l_curline IS NOT NULL THEN
                LET l_charcnt = 1
                FOR l_j = 1 TO l_curline.getLength()
                    IF l_curline.getCharAt(l_j) = "\"" THEN
                        LET l_charpos[l_charcnt] = l_j
                        LET l_charcnt = l_charcnt + 1
                    END IF
                END FOR

                LET l_charposCnt = l_charpos.getLength()
                IF l_charposCnt > 1 THEN
                    FOR l_j = 1 TO l_charposCnt STEP 2
                        LET l_str = l_curline.subString(l_charpos[l_j] + 1,l_charpos[l_j + 1] - 1)
                        LET l_str = l_str.trim()
                        LET lc_strtok = base.StringTokenizer.create(l_str,",")
                        WHILE (lc_strtok.hasMoreTokens())
                            LET l_nextstr = lc_strtok.nextToken()
                            LET l_nextstr = l_nextstr.trim()
                            IF l_nextstr IS NOT NULL THEN
                                LET lc_strbuf = base.StringBuffer.create()
                                CALL lc_strbuf.append(l_nextstr)
                                CALL lc_strbuf.replace("."," LIKE ",1)
                                CALL lc_strbuf.append(",")
                                CALL lc_strbuf.insertAt(1,"    ")
                                LET l_codeLines = l_codeLines + 1
                                LET p_strarr[l_codeLines] = lc_strbuf.toString()

                                #將欄位放到資料欄位定義陣列
                                LET l_pos1 = l_nextstr.getIndexOf(".",1)
                                LET l_pos2 = l_nextstr.getIndexOf(".",l_pos1 +1)
                                LET l_dbfcnt = l_dbfcnt + 1
                                INITIALIZE g_flddef[l_dbfcnt] TO NULL
                                LET g_flddef[l_dbfcnt].recno = m_trcnt
                                LET g_flddef[l_dbfcnt].field_name = l_nextstr.subString(1,l_pos1 - 1)
                                LET g_flddef[l_dbfcnt].table_name = l_nextstr.subString(l_pos1 + 1,l_pos2 - 1)
                                LET g_flddef[l_dbfcnt].column_name = l_nextstr.subString(l_pos2 + 1,l_nextstr.getLength())
                                LET g_flddef[l_dbfcnt].table_cnt = p_table_cnt
                            END IF
                        END WHILE
                    END FOR
                END IF
            END IF
        END FOR

        LET p_strarr[l_codeLines] = p_strarr[l_codeLines].subString(1,p_strarr[l_codeLines].getLength() - 1)
    END IF
END FUNCTION

#取出String token指定的部分
FUNCTION p_xglang_get_str_part(p_str,p_delim,p_index)
    DEFINE p_str        STRING
    DEFINE p_delim      STRING
    DEFINE p_index      LIKE type_file.num10
    DEFINE l_res        STRING
    DEFINE l_str        STRING
    DEFINE l_index      LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_strtok     base.StringTokenizer

    LET l_res = NULL
    LET l_strtok = base.StringTokenizer.create(p_str,p_delim)
    IF l_strtok IS NOT NULL THEN
        IF p_index > 0 THEN
            LET l_index = p_index
        ELSE
            LET l_index = l_strtok.countTokens() + 1 + p_index
        END IF

        LET l_i = 1
        WHILE (l_strtok.hasMoreTokens())
            LET l_str = l_strtok.nextToken()
            IF l_i = l_index THEN
                LET l_res = l_str
                EXIT WHILE
            END IF
            LET l_i = l_i + 1
        END WHILE
    END IF
    IF l_res IS NOT NULL THEN
        LET l_res = l_res.trim()
    END IF
    RETURN l_res
END FUNCTION


#將檔案讀入原始碼字串陣列
FUNCTION p_xglang_load_source(p_filePath)
    DEFINE p_filePath   STRING
    DEFINE l_cnt        LIKE type_file.num10
    DEFINE l_ch         base.Channel
    DEFINE l_result     STRING

    CALL m_srccode.clear()
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(p_filePath,"r")
    CALL l_ch.setDelimiter("")
    LET l_cnt = 1
    WHILE l_ch.read(l_result)
        LET m_srccode[l_cnt] = l_result
        LET l_cnt = l_cnt + 1
    END WHILE
    CALL m_srccode.deleteElement(l_cnt)
    CALL l_ch.close()
END FUNCTION

##################################################
# Descriptions...: 找出LET 變數的程式段
# Input Parameter: p_str        目前行的字串
#                  p_startline  起始行數
#                  p_endline    結束行數
##################################################
FUNCTION p_xglang_find_lineno(p_str,p_startline,p_endline)
    DEFINE p_str        STRING
    DEFINE p_startline  LIKE type_file.num10
    DEFINE p_endline    LIKE type_file.num10
    DEFINE l_startline  LIKE type_file.num10
    DEFINE l_endline    LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_j          LIKE type_file.num10
    DEFINE l_tmpline    STRING      #去註解後的目前所在行內容
    DEFINE l_str        STRING
    DEFINE l_nextline   LIKE type_file.num10

    #DISPLAY "start: ",p_startline,",",p_endline
    LET l_startline = 0
    FOR l_i = p_endline - 1 TO p_startline STEP -1
        LET l_tmpline = p_xglang_rm_line_mark(m_srccode[l_i])

        #找開始行
        IF l_tmpline.getIndexOf("LET",1) > 0
            AND l_tmpline.getIndexOf(p_str,2) > 0
        THEN
            LET l_startline = l_i
            EXIT FOR
        END IF
    END FOR

    IF l_startline > 0 THEN
        FOR l_i = l_startline TO p_endline - 1
            #找結束行
            LET l_tmpline = p_xglang_rm_line_mark(m_srccode[l_i])

            #找第一個結尾非逗號的行
            IF　l_tmpline IS NOT NULL
                AND l_tmpline.getCharAt(l_tmpline.getLength()) != ","
            THEN
                LET l_nextline = 0
                #找到該行後，確認非註解的下一行第一個非空白字元不可為逗號
                FOR l_j = l_i + 1 TO p_endline - 1
                    LET l_str = p_xglang_rm_line_mark(m_srccode[l_j])
                    LET l_str = l_str.trim()
                    #DISPLAY "cl_null(l_str)=",cl_null(l_str) USING "<<<<&"
                    IF NOT cl_null(l_str) THEN
                        LET l_nextline = l_j
                        EXIT FOR
                    END IF
                END FOR
                #DISPLAY "l_nextline: ",l_nextline USING "<<<<&"
                IF l_nextline > 0 THEN
                    IF l_str.getCharAt(1) != "," OR cl_null(l_str) THEN
                    LET l_endline = l_i
                    EXIT FOR
                    END IF
                ELSE
                    LET l_endline = l_i
                    EXIT FOR
                END IF
            END IF
        END FOR
    END IF
    #DISPLAY "result: ",l_startline,",",l_endline
    RETURN l_startline,l_endline
END FUNCTION


FUNCTION p_xglang_get_4gldir(p_prog)
DEFINE p_prog   LIKE type_file.chr100
DEFINE l_4gldir LIKE type_file.chr1000
DEFINE l_module LIKE zz_file.zz011

    SELECT zz011 INTO l_module FROM zz_file WHERE zz01=p_prog
    LET l_4gldir = os.Path.join(FGL_GETENV(l_module),os.Path.join("4gl",p_prog || ".4gl"))

    RETURN l_4gldir

END FUNCTION

FUNCTION p_xglang_i(p_cmd)                       # 輸入單頭
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_zwacti LIKE zw_file.zwacti


   DISPLAY BY NAME g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,
                   g_gdr.gdr05,g_gdr.gdr09,g_gdr.gdr03,g_gdr.gdr06
                  ,g_gdr.gdr21 #FUN-D20057
   DISPLAY g_gds02 TO gds02
   INPUT g_gdr.gdr00,g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr04,g_gdr.gdr05,
         g_gdr.gdr09,g_gdr.gdr03,g_gdr.gdr06,g_gdr.gdr10,g_gds02
        ,g_gdr.gdr21  #FUN-D20057 add
         WITHOUT DEFAULTS
    FROM gdr00,gdr01,gdr02,gdr04,gdr05,gdr09,gdr03,gdr06,gdr10,gds02
        ,gdr21 #FUN-D20057 add

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_xglang_set_entry(p_cmd)
         CALL p_xglang_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD gdr01
         IF NOT cl_null(g_gdr.gdr01) THEN
            IF g_gdr.gdr01 <> g_gdr_t.gdr01 OR g_gdr_t.gdr01 IS NULL THEN
               IF NOT p_xglang_chkgdr01() THEN
                  CALL cl_err(g_gdr.gdr01,'azz-052',1)
                  NEXT FIELD gdr01
               END IF
               CALL p_xglang_gdrdesc("gdr01",g_gdr.gdr01)
               IF NOT p_xglang_chkkey(p_cmd) THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF

      BEFORE FIELD gdr01
         IF cl_null(g_gdr.gdr02) THEN
            LET g_gdr.gdr02 = g_gdr.gdr01
            DISPLAY BY NAME g_gdr.gdr02
         END IF

      AFTER FIELD gdr02
         IF NOT cl_null(g_gdr.gdr02) THEN
            IF g_gdr.gdr02 <> g_gdr_t.gdr02 OR g_gdr_t.gdr02 IS NULL THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM gdr_file
                WHERE gdr01 = g_gdr.gdr01 #程式代號
                  AND gdr02 = g_gdr.gdr02 #樣版代號
                  AND gdr03 = g_gdr.gdr03 #客製否
                  AND gdr04 = "default"   #使用者
                  AND gdr05 = "default"   #權限類別
                  AND gdr09 = g_gdr.gdr09 #行業別
               IF g_cnt = 0 THEN
                  LET g_gdr.gdr04 = "default"
                  CALL p_xglang_gdrdesc("gdr04",g_gdr.gdr04)
                  LET g_gdr.gdr05 = "default"
                  CALL p_xglang_gdrdesc("gdr05",g_gdr.gdr05)
               END IF
               IF NOT p_xglang_chkkey(p_cmd) THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF

       AFTER FIELD gdr03
         IF NOT cl_null(g_gdr.gdr03) THEN
            IF g_gdr.gdr03 <> g_gdr_t.gdr03 OR g_gdr_t.gdr03 IS NULL THEN
               IF NOT p_xglang_chkkey(p_cmd) THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
          
       AFTER FIELD gdr04
         IF NOT cl_null(g_gdr.gdr04) THEN
            IF g_gdr.gdr04 <> g_gdr_t.gdr04 OR g_gdr_t.gdr04 IS NULL THEN
               IF g_gdr.gdr04 <> 'default' THEN
                 SELECT COUNT(*) INTO g_cnt FROM zx_file
                  WHERE zx01 = g_gdr.gdr04
                  IF g_cnt = 0 THEN
                     CALL cl_err( g_gdr.gdr04,'mfg1312',0)
                     NEXT FIELD CURRENT
                  END IF
               END IF
               IF g_gdr.gdr04 = 'default' THEN
                  IF g_gdr.gdr05 <> 'default' THEN
                     CALL cl_set_comp_entry("gdr05",TRUE)
                     CALL cl_set_comp_entry("gdr04",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("gdr04",TRUE)
                     CALL cl_set_comp_entry("gdr05",TRUE)
                  END IF
               ELSE
                  IF g_gdr.gdr05 = 'default' THEN
                     CALL cl_set_comp_entry("gdr04",TRUE)
                     CALL cl_set_comp_entry("gdr05",FALSE)
                  END IF
               END IF
            END IF
         END IF
         CALL p_xglang_gdrdesc("gdr04",g_gdr.gdr04)

       AFTER FIELD gdr05
         IF NOT cl_null(g_gdr.gdr05) THEN
            IF g_gdr.gdr05 <> g_gdr_t.gdr05 OR g_gdr_t.gdr05 IS NULL THEN
               IF g_gdr.gdr05 <> 'default' THEN
                  SELECT zwacti INTO l_zwacti FROM zw_file
                   WHERE zw01 = g_gdr.gdr05
                   IF STATUS THEN
                      CALL cl_err('select '||g_gdr.gdr05||" ",STATUS,0)
                      NEXT FIELD CURRENT
                   ELSE
                     IF l_zwacti != "Y" THEN
                        CALL cl_err_msg(NULL,"azz-218",g_gdr.gdr05 CLIPPED,10)
                        NEXT FIELD CURRENT
                     END IF
                   END IF
               END IF
               IF g_gdr.gdr05 = 'default' THEN
                  IF g_gdr.gdr04 <> 'default' THEN
                     CALL cl_set_comp_entry("gdr04",TRUE)
                     CALL cl_set_comp_entry("gdr05",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("gdr05",TRUE)
                     CALL cl_set_comp_entry("gdr04",TRUE)
                  END IF
               ELSE
                  IF g_gdr.gdr04 = 'default' THEN
                     CALL cl_set_comp_entry("gdr05",TRUE)
                     CALL cl_set_comp_entry("gdr04",FALSE)
                  END IF
               END IF
            END IF
         END IF
         CALL p_xglang_gdrdesc("gdr05",g_gdr.gdr05)

       AFTER FIELD gdr06
         IF g_gdr.gdr06 NOT MATCHES "[123456]" THEN 
            NEXT FIELD CURRENT
         ELSE
            CALL p_xglang_show_column()
         END IF


        AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
              EXIT INPUT
           END IF
        
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gdr01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.default1= g_gdr.gdr01
                   CALL cl_create_qry() RETURNING g_gdr.gdr01
                   NEXT FIELD gdr01

              WHEN INFIELD(gdr05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zw"
                   LET g_qryparam.default1 = g_gdr.gdr05
                   CALL cl_create_qry() RETURNING g_gdr.gdr04
                   NEXT FIELD gdr05

              WHEN INFIELD(gdr04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zx"
                   LET g_qryparam.default1 = g_gdr.gdr04
                   CALL cl_create_qry() RETURNING g_gdr.gdr04
                   NEXT FIELD gdr04

              OTHERWISE
                   EXIT CASE
          END CASE

        ON ACTION controlf                  #欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        ON ACTION about   
            CALL cl_about()
        ON ACTION HELP 
            CALL cl_show_help()
        ON ACTION controlg
            CALL cl_cmdask()

   END INPUT


END FUNCTION

FUNCTION p_xglang_rm_line_mark(p_str)
    DEFINE p_str        STRING
    DEFINE l_str        STRING
    DEFINE l_mark_pos   LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_char       STRING
    DEFINE l_char1      STRING
    DEFINE l_chkmark2   LIKE type_file.num10

    LET l_mark_pos = 0
    LET l_chkmark2 = FALSE
    LET l_str = p_str.trim()
    FOR l_i = 1 TO p_str.getLength()
        LET l_char = l_str.getCharAt(l_i)
        IF l_char = "-" THEN
            LET l_char1 = l_str.getCharAt(l_i + 1)
            IF l_char1 = "-" THEN
                LET l_chkmark2 = TRUE
            END IF
        END IF
        IF l_char = "#" OR l_char = "{" OR l_chkmark2 THEN
            LET l_mark_pos = l_i
            EXIT FOR
        END IF
    END FOR
    IF l_mark_pos > 1 THEN
        LET l_str = l_str.subString(1,l_mark_pos - 1)
        LET l_str = l_str.trim()
    ELSE
        IF l_mark_pos = 1 THEN
            LET l_str = NULL
        END IF
    END IF
    RETURN l_str
END FUNCTION

#取出子字串
FUNCTION p_xglang_get_substr(p_str,p_startStr,p_endStr)
    DEFINE p_str            STRING
    DEFINE p_startStr       STRING
    DEFINE p_endStr         STRING
    DEFINE l_str            STRING
    DEFINE l_startPos       LIKE type_file.num10
    DEFINE l_endPos         LIKE type_file.num10
    DEFINE l_startStrLen    LIKE type_file.num10

    LET l_str = NULL
    IF p_str IS NOT NULL AND p_startStr IS NOT NULL AND p_endStr IS NOT NULL THEN
        LET l_startStrLen = p_startStr.getLength()
        LET l_startPos = p_str.getIndexOf(p_startStr,1)
        IF l_startPos > 0 THEN
            LET l_endPos = p_str.getIndexOf(p_endStr,l_startPos + 1)
        END IF
    END IF

    IF l_endPos >= l_startPos AND l_startPos > 0 THEN
        LET l_str = p_str.subString(l_startPos + l_startStrLen,l_endPos - 1)
    END IF

    RETURN l_str
END FUNCTION

FUNCTION p_xglang_ins_gds(p_field_name,p_table_name,p_column_name,p_table_cnt)
#FUNCTION p_xglang_ins_gds(p_field_name,p_table_name,p_column_name)
DEFINE p_field_name  LIKE gac_file.gac06,
       p_table_name  LIKE gac_file.gac05,
       p_column_name LIKE gac_file.gac06,
       p_table_cnt   LIKE type_file.num5
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_sn    LIKE type_file.num5
DEFINE l_datatype  LIKE ahe_file.ahe04
DEFINE l_length    LIKE type_file.num5 
DEFINE l_gds   RECORD LIKE gds_file.*

      IF cl_null(p_field_name) THEN RETURN END IF
      SELECT COUNT(*) INTO l_cnt FROM gds_file
       WHERE gds00 = g_gdr.gdr00 #ID
         AND gds03 = p_field_name
         AND gds18 = p_table_cnt
      IF l_cnt > 0 THEN RETURN END IF #已存在就不處理

      CALL cl_get_column_info('ds',p_table_name,p_column_name)
          RETURNING l_datatype,l_length

      INITIALIZE l_gds.* TO NULL
      LET l_gds.gds00 = g_gdr.gdr00
      SELECT MAX(gds01) INTO l_sn FROM gds_file
       WHERE gds00 = g_gdr.gdr00
      IF cl_null(l_sn) THEN LET l_sn=0 END IF
      LET l_gds.gds01 = l_sn + 1
      LET l_gds.gds02 = g_gds02
      LET l_gds.gds03 = p_field_name
      SELECT gaq03 INTO l_gds.gds04 FROM gaq_file
       WHERE gaq01 = l_gds.gds03
         AND gaq02 = l_gds.gds02
      IF cl_null(l_gds.gds04) THEN 
         LET l_gds.gds04 = l_gds.gds03
      END IF
      CALL cl_replace_str(l_gds.gds04,",","") RETURNING l_gds.gds04
      CALL cl_replace_str(l_gds.gds04,":","") RETURNING l_gds.gds04
      LET l_gds.gds05 = 1
      SELECT MAX(gds06) INTO l_sn FROM gds_file
       WHERE gds00 = g_gdr.gdr00
         AND gds05 = l_gds.gds05
      IF cl_null(l_sn) THEN LET l_sn=0 END IF
      LET l_gds.gds06 = l_sn + 1
      LET l_gds.gds07 ='6'  #不小計
      LET l_gds.gds08 ='6'  #不總計
      LET l_gds.gds09 ='N'
      LET l_gds.gds10 ='N'
      LET l_gds.gds11 =NULL
      LET l_gds.gds12 ='2'
      LET l_gds.gds13 =NULL
      LET l_gds.gds14 ='Y'
      LET l_gds.gds23 ='N' #FUN-CB0101
      CASE l_datatype
        WHEN "varchar" LET l_gds.gds15 = 'C'
        WHEN "varchar2" LET l_gds.gds15 = 'C'
        WHEN "number"  LET l_gds.gds15 = 'N'
                       IF l_length = 206 THEN
                          LET l_gds.gds23='Y'
                       END IF
        WHEN "date"    LET l_gds.gds15 = 'D'
        WHEN "datetime" LET l_gds.gds15 = 'D'
        OTHERWISE      LET l_gds.gds15 = 'C'
      END CASE
      LET l_gds.gds29 = p_xglang_get_gds29(l_datatype,l_length)
      LET l_gds.gds16 ='N' #主鍵
     #對齊位置
      CASE l_gds.gds15 
         WHEN "N"
              LET l_gds.gds17="2"  #靠右
         WHEN "C" 
              LET l_gds.gds17="1"  #靠左
         WHEN "D"  
              LET l_gds.gds17="1"  #靠左
         OTHERWISE LET l_gds.gds17="1" 
      END CASE
      LET l_gds.gds18 = p_table_cnt
      LET l_gds.gds19 = "N"   #預設子報表不顯示
      IF g_gdr.gdr06='5' THEN #交叉表
         LET l_gds.gds20 = "0"   #交叉表分析型態
      ELSE
         LET l_gds.gds20 = " "   #交叉表分析型態
      END IF
      LET l_gds.gds21 = "N"   #樹狀圖PID
      LET l_gds.gds22 = "N"   #樹狀圖ID
      LET l_gds.gds24 = NULL  #圖表欄位順序
      LET l_gds.gds25 = " "   #圖表欄位型態(LINE or BAR) for 長條圖/線圖
      LET l_gds.gds26 = "N"   #圖表X軸
      LET l_gds.gds27 = "N"   #圖表Y軸
      LET l_gds.gds30 = "N"   #縮排
      LET l_gds.gds28 = NULL
      LET l_gds.gds31 = NULL
      LET l_gds.gds32 = "N"  #FUN-CC0039 add
      LET l_gds.gds34 = "N"  #FUN-CC0039 add

      INSERT INTO gds_file VALUES(l_gds.*) 
      IF STATUS THEN
         CALL cl_err('insert gds:',STATUS,1)
         LET g_success = 'N'
      END IF
      LET g_cnt = g_cnt + 1

END FUNCTION


FUNCTION g_xglang_ins_gdr() 

    LET g_gdr.gdruser = g_user
    LET g_gdr.gdroriu = g_user
    LET g_gdr.gdrgrup = g_grup
    LET g_gdr.gdrorig = g_grup
    IF cl_null(g_gdr.gdr07) THEN LET g_gdr.gdr07 = ' ' END IF
    IF cl_null(g_gdr.gdr08) THEN LET g_gdr.gdr08 = ' ' END IF
    IF cl_null(g_gdr.gdr11) THEN LET g_gdr.gdr11 = ' ' END IF
    IF cl_null(g_gdr.gdr12) THEN LET g_gdr.gdr12 = ' ' END IF
    IF cl_null(g_gdr.gdr13) THEN LET g_gdr.gdr13 = ' ' END IF
    IF cl_null(g_gdr.gdr19) THEN LET g_gdr.gdr19 = ' ' END IF
    INSERT INTO gdr_file VALUES(g_gdr.*)
    IF STATUS THEN
       CALL cl_err('insert gdr:',STATUS,1)
       RETURN FALSE
    ELSE
       RETURN TRUE
    END IF

END FUNCTION

FUNCTION p_xglang_chkgdr01()
    DEFINE  li_cnt      LIKE type_file.num5
    DEFINE  li_cnt2     LIKE type_file.num5
    DEFINE  li_pos      LIKE type_file.num10
    DEFINE  li_flag     LIKE type_file.num5
    DEFINE  ls_str      STRING
    DEFINE  lc_gdr01    LIKE gdr_file.gdr01
    DEFINE  lc_zz08     LIKE zz_file.zz08

    LET li_flag = FALSE
    LET lc_zz08 = "%",g_gdr.gdr01 CLIPPED,"%"

    SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz08 LIKE lc_zz08

    SELECT COUNT(*) INTO g_cnt from zz_file where zz01= g_gdr.gdr01

    IF li_cnt > 0 THEN
        SELECT COUNT(*) INTO li_cnt2 FROM gak_file WHERE gak01 = g_gdr.gdr01
        IF li_cnt2 > 0 THEN
            LET li_flag = TRUE
        END IF
    ELSE
        IF li_cnt = 0 AND g_cnt = 0 THEN
            LET li_flag = FALSE
        ELSE
            SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01 = g_gdr.gdr01
            LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
            LET li_cnt = ls_str.getIndexOf("i/",1)
            LET li_pos = ls_str.getIndexOf(" ",li_cnt)
            IF li_pos <= li_cnt THEN LET li_pos = ls_str.getLength() END IF
            LET lc_gdr01 = ls_str.subString(li_cnt + 2, li_pos)
            CALL cl_err_msg(NULL,"azz-060",g_gdr.gdr01 CLIPPED|| "|" || lc_gdr01 CLIPPED,10)
            LET g_gdr.gdr01 = lc_gdr01 CLIPPED
            LET li_flag = TRUE
            DISPLAY g_gdr.gdr01 TO gdr01
        END IF
    END IF
    RETURN li_flag

END FUNCTION

FUNCTION p_xglang_chkkey(p_cmd)
DEFINE p_cmd LIKE type_file.chr1

   IF cl_null(g_gdr.gdr01) THEN RETURN TRUE END IF
   IF cl_null(g_gdr.gdr02) THEN RETURN TRUE END IF
   IF cl_null(g_gdr.gdr03) THEN RETURN TRUE END IF
   IF cl_null(g_gdr.gdr04) THEN RETURN TRUE END IF
   IF cl_null(g_gdr.gdr05) THEN RETURN TRUE END IF
   IF cl_null(g_gdr.gdr09) THEN RETURN TRUE END IF

   IF p_cmd = 'c' THEN
      SELECT COUNT(*) INTO g_cnt FROM gdr_file,gds_file
       WHERE gdr01 = g_gdr.gdr01
         AND gdr02 = g_gdr.gdr02
         AND gdr03 = g_gdr.gdr03
         AND gdr04 = g_gdr.gdr04
         AND gdr05 = g_gdr.gdr05
         AND gdr09 = g_gdr.gdr09
         AND gdr00 = gds00
         AND gds02 = g_gds02
   ELSE
      SELECT COUNT(*) INTO g_cnt FROM gdr_file
       WHERE gdr01 = g_gdr.gdr01
         AND gdr02 = g_gdr.gdr02
         AND gdr03 = g_gdr.gdr03
         AND gdr04 = g_gdr.gdr04
         AND gdr05 = g_gdr.gdr05
         AND gdr09 = g_gdr.gdr09
   END IF
   IF g_cnt > 0 THEN
      CALL cl_err('','-239',1)
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION

FUNCTION p_xglang_show_column()
DEFINE l_cnt  LIKE type_file.num5

    IF cl_null(g_gdr.gdr06) THEN RETURN END IF

    CALL cl_set_comp_visible("gds05,gds07,gds08,gds09,gds10,gds11,gds12,gds13,gds20,gds21,gds22,gds31,gds32,gds34,gds35",TRUE)
    CALL cl_set_comp_visible("gds36",TRUE) #FUN-D30056
    CASE g_gdr.gdr06
      WHEN "1" #清單統計
        CALL cl_set_comp_visible("gds05,gds09,gds10,gds11,gds12,gds16,gds20,gds21,gds22",FALSE)
      WHEN "2" #清單統計(有單頭)
        CALL cl_set_comp_visible("gds09,gds10,gds11,gds16,gds20,gds21,gds22",FALSE)
      WHEN "3" #清單統計(子報表)
        CALL cl_set_comp_visible("gds05,gds09,gds10,gds11,gds12,gds20,gds21,gds22",FALSE)
      WHEN "4" #清單統計(有單頭+子報表)
        CALL cl_set_comp_visible("gds09,gds10,gds11,gds19,gds20,gds21,gds22",FALSE)
      WHEN "5" #交叉分析表
        CALL cl_set_comp_visible("gds07,gds08,gds13,gds16,gds19,gds21,gds22,gds30,gds31,gds32,gds34,gds35",FALSE)
      WHEN "6" #樹狀圖
        CALL cl_set_comp_visible("gds05,gds07,gds08,gds09,gds10,gds11,gds12,gds16,gds19,gds20,gds30,gds32,gds34",FALSE)
        CALL cl_set_comp_visible("gds36",FALSE) #FUN-D30056
    END CASE

END FUNCTION

#重新整理單頭單身排序
FUNCTION p_xglang_resort(p_ask)
DEFINE p_ask   LIKE type_file.chr1
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_max   LIKE type_file.num5
DEFINE l_num   LIKE type_file.num5
DEFINE l_gds05  LIKE gds_file.gds05
DEFINE l_gds06  LIKE gds_file.gds06
DEFINE l_gds12  LIKE gds_file.gds12
DEFINE l_gds18  LIKE gds_file.gds18
DEFINE l_gds01  LIKE gds_file.gds01
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_sql    STRING

    IF cl_null(g_gdr.gdr00) OR g_gdr.gdr00=0 THEN RETURN END IF
    LET l_flag = 'N'
    DECLARE p_xglang_sort_cs CURSOR FOR
     SELECT UNIQUE gds12,gds05,gds18 FROM gds_file
      WHERE gds00 = g_gdr.gdr00
        AND gds05 IS NOT NULL
    LET l_sql = "SELECT UNIQUE gds06 FROM gds_file ",
                " WHERE gds00 = ? AND gds12=? AND gds05=? AND gds18=? "
    PREPARE p_xglang_sort_pr3 FROM l_sql
    DECLARE p_xglang_sort_cs3 CURSOR FOR p_xglang_sort_pr3

    LET l_sql = "SELECT gds01,gds06 FROM gds_file ",
                " WHERE gds00 = ? ",
                "   AND gds12 = ? ",
                "   AND gds05 = ? ",
                "   AND gds18 = ? ",
                " ORDER BY gds06 "
    PREPARE p_xglang_sort_pr2 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare sort_pr2:',STATUS,1) RETURN END IF
    DECLARE p_xglang_sort_cs2 CURSOR FOR p_xglang_sort_pr2

    FOREACH p_xglang_sort_cs INTO l_gds12,l_gds05,l_gds18
      #最大欄序<>此行的數量
        SELECT COUNT(*) INTO l_cnt FROM gds_file
         WHERE gds00 = g_gdr.gdr00
           AND gds12 = l_gds12 #行序
           AND gds05 = l_gds05 #單頭/單身
           AND gds18 = l_gds18 #報表序號(主報表/子報表)
        IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
        SELECT MAX(gds06) INTO l_max FROM gds_file
         WHERE gds00 = g_gdr.gdr00
           AND gds12 = l_gds12
           AND gds05 = l_gds05
           AND gds18 = l_gds18
        IF cl_null(l_max) THEN LET l_max=0 END IF
        IF (l_cnt <> l_max) AND l_gds12='2' THEN
           LET l_flag = 'Y'
        END IF
      #欄序重覆
       FOREACH p_xglang_sort_cs3 USING g_gdr.gdr00,l_gds12,l_gds05,l_gds18
          INTO l_gds06
          SELECT COUNT(*) INTO l_cnt
            FROM gds_file
           WHERE gds00 = g_gdr.gdr00
             AND gds12 = l_gds12
             AND gds05 = l_gds05
             AND gds18 = l_gds18
             AND gds06 = l_gds06
          IF l_cnt > 1 THEN LET l_flag = 'Y' EXIT FOREACH END IF
       END FOREACH
        
    END FOREACH
    
    IF l_flag = 'Y' THEN
       IF p_ask = 'Y' THEN #詢問否
          IF NOT cl_confirm('azz1266') THEN RETURN END IF
       END IF
       LET g_success = 'Y'
       BEGIN WORK
       FOREACH p_xglang_sort_cs INTO l_gds12,l_gds05,l_gds18
           LET l_num = 1
           FOREACH p_xglang_sort_cs2 USING g_gdr.gdr00,l_gds12,l_gds05,l_gds18
              INTO l_gds01,l_gds06
               UPDATE gds_file SET gds06 = l_num
                WHERE gds00 = g_gdr.gdr00
                  AND gds01 = l_gds01
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err('update gds06',STATUS,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #IF l_num = l_gds06 THEN CONTINUE FOREACH END IF
              #DISPLAY l_gds12,'-',l_gds05,'-',l_gds06,'-->',l_num
               LET l_num=l_num + 1
           END FOREACH
        IF g_success = 'N' THEN EXIT FOREACH END IF
       END FOREACH
       IF g_success = 'Y' THEN
          COMMIT WORK
          CALL p_xglang_b_fill(' 1=1')
       ELSE
          ROLLBACK WORK
       END IF
    END IF

END FUNCTION

FUNCTION p_xglang_set_no_required_b()

    IF l_ac <=0 THEN RETURN END IF
    IF g_gds[l_ac].gds09='N' AND g_gds[l_ac].gds10='N' THEN
       CALL cl_set_comp_required('gds11,gds20',FALSE)
    END IF

END FUNCTION

FUNCTION p_xglang_set_required_b()

    IF l_ac <=0 THEN RETURN END IF
    IF g_gds[l_ac].gds09='Y' OR g_gds[l_ac].gds10='Y' THEN
       CALL cl_set_comp_required('gds11',TRUE)
    END IF

    IF g_gds[l_ac].gds09='N' AND g_gds[l_ac].gds10='N' AND g_gds[l_ac].gds10='2' THEN
       CALL cl_set_comp_required('gds20',TRUE)
    END IF

END FUNCTION

FUNCTION p_xglang_sub()
DEFINE l_sql   STRING

    IF cl_null(g_gdr.gdr00) OR g_gdr.gdr00=0 THEN RETURN END IF

    OPEN WINDOW p_xglang_d_w WITH FORM "azz/42f/p_xglang_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("p_xglang_1")
    LET l_sql = "SELECT UNIQUE gds18,gds19 FROM gds_file ",
                " WHERE gds00 = ",g_gdr.gdr00,
                "   AND gds18 > 1 ",  #只抓子報表部份
                " ORDER BY gds18"
    DECLARE p_xglang_sub_curs SCROLL CURSOR WITH HOLD FROM l_sql
    IF INT_FLAG THEN                              #使用者不玩了
        LET INT_FLAG = 0
        CLOSE WINDOW p_xglang_d_w
        RETURN
    END IF
    OPEN p_xglang_sub_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN                         #有問題
        CALL cl_err('',SQLCA.SQLCODE,0)
        LET g_gds18 = NULL
        LET g_gds19 = NULL
    ELSE
        CALL p_xglang_sub_count()
        CALL p_xglang_sub_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF

    CALL p_xglang_sub_show_column()

    CALL p_xglang_sub_menu()
    CLOSE p_xglang_sub_curs
    CLOSE WINDOW p_xglang_d_w
    
END FUNCTION

FUNCTION p_xglang_sub_menu()

   WHILE TRUE
      CALL p_xglang_sub_bp("G")

      CASE g_action_choice
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_xglang_sub_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_xglang_sub_b()
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
   LET g_action_choice = NULL

END FUNCTION

FUNCTION p_xglang_sub_bp(p_ud)
    DEFINE   p_ud   LIKE type_file.chr1

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF

    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel",FALSE)
    CALL SET_COUNT(g_rec_b2)
    DISPLAY ARRAY g_sub_gds TO s_sub_gds.* ATTRIBUTE(UNBUFFERED)

        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_sub_row_count)

        BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

        ON ACTION modify                           # Q.修改
            LET g_action_choice='modify'
            EXIT DISPLAY

        ON ACTION detail                           # B.單身
            LET g_action_choice='detail'
            LET l_ac2 = ARR_CURR()
            EXIT DISPLAY

        ON ACTION ACCEPT
            LET g_action_choice="detail"
            LET l_ac2 = ARR_CURR()
            EXIT DISPLAY
            
        ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DISPLAY

        ON ACTION first                            # 第一筆
            CALL p_xglang_sub_fetch('F')
            CALL cl_navigator_setting(g_curs_index,g_sub_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION previous                         # P.上筆
            CALL p_xglang_sub_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_sub_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION jump                             # 指定筆
            CALL p_xglang_sub_fetch('/')
            CALL cl_navigator_setting(g_curs_index,g_sub_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION next                             # N.下筆
            CALL p_xglang_sub_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_sub_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY
            
        ON ACTION last                             # 最終筆
            CALL p_xglang_sub_fetch('L')
            CALL cl_navigator_setting(g_curs_index,g_sub_row_count)
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DISPLAY

        ON ACTION help                             # H.說明
            LET g_action_choice='help'
            EXIT DISPLAY

        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            EXIT DISPLAY

        ON ACTION exit                             # Esc.結束
            LET g_action_choice='exit'
            EXIT DISPLAY

        ON ACTION CLOSE
            LET g_action_choice='exit'
            EXIT DISPLAY

        ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DISPLAY
            
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

        ON ACTION about
            CALL cl_about()

        AFTER DISPLAY
            CONTINUE DISPLAY

        ON ACTION controls
            CALL cl_set_head_visible("","AUTO")

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION p_xglang_sub_fetch(p_flag)                #處理資料的讀取
    DEFINE  p_flag  LIKE type_file.chr1         #處理方式    

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_xglang_sub_curs INTO g_gds18,g_gds19
        WHEN 'P' FETCH PREVIOUS p_xglang_sub_curs INTO g_gds18,g_gds19
        WHEN 'F' FETCH FIRST    p_xglang_sub_curs INTO g_gds18,g_gds19
        WHEN 'L' FETCH LAST     p_xglang_sub_curs INTO g_gds18,g_gds19
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0

                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                    ON ACTION controlp
                        CALL cl_cmdask()
                    ON ACTION HELP
                        CALL cl_show_help()
                    ON ACTION about
                        CALL cl_about()
                END PROMPT

                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump p_xglang_sub_curs INTO g_gds18,g_gds19
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gdr.gdr01,SQLCA.sqlcode,0)
        LET g_gds18 = NULL
        LET g_gds19 = NULL
        RETURN
    ELSE
        CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_sub_row_count
            WHEN '/' LET g_curs_index = g_jump 
        END CASE

        CALL cl_navigator_setting(g_curs_index,g_sub_row_count)
    END IF

    CALL p_xglang_sub_show()
    
END FUNCTION

FUNCTION p_xglang_sub_show()

    DISPLAY g_gds18 TO gds18

    DECLARE p_xglang_sub_gds19 CURSOR FOR
     SELECT gds19 FROM gds_file
      WHERE gds00 = g_gdr.gdr00
        AND gds18 = g_gds18
    FOREACH p_xglang_sub_gds19 INTO g_gds19
       EXIT FOREACH
    END FOREACH
    DISPLAY g_gds19 TO gds19

    CALL p_xglang_sub_b_fill()
    CALL p_xglang_set_combo('gds13',g_gds18)
    CALL p_xglang_set_combo('gds28',1)

END FUNCTION


FUNCTION p_xglang_sub_b_fill()
DEFINE l_sql   STRING

       LET l_sql = "SELECT gds01,gds03,gds04,gds14,gds05,gds06,",
                   "       gds09,gds10,gds11,gds20,",
                   "       gds13,gds23,gds16,gds28,gds17,gds15 ",
                   "  FROM gds_file ",
                   " WHERE gds00 = ",g_gdr.gdr00,
                   "   AND gds18 = ",g_gds18,
                   " ORDER BY gds01 "
       PREPARE p_xglang_sub_bfill_pr FROM l_sql
       DECLARE p_xglang_sub_bfill_cs CURSOR FOR p_xglang_sub_bfill_pr
       CALL g_sub_gds.clear()
       LET g_cnt = 1
       FOREACH p_xglang_sub_bfill_cs INTO g_sub_gds[g_cnt].*
           IF STATUS THEN CALL cl_err('foreach sub_b_fill:',STATUS,1) EXIT FOREACH END IF
           LET g_cnt = g_cnt + 1
       END FOREACH
       CALL g_sub_gds.deleteElement(g_cnt)
       LET g_rec_b2 = g_cnt - 1
       DISPLAY g_rec_b2 TO cn2

END FUNCTION

FUNCTION p_xglang_set_combo(p_column,p_sn)
DEFINE p_column     LIKE type_file.chr100
DEFINE p_sn         LIKE type_file.num5
DEFINE l_combo_item LIKE type_file.chr1000
DEFINE l_gds01      LIKE gds_file.gds01
DEFINE l_gds03      LIKE gds_file.gds03

       LET g_sql = "SELECT gds01,gds03",
                   " FROM gds_file",
                   " WHERE gds00=? AND gds02=?"
       IF cl_null(p_sn) THEN
          LET g_sql = g_sql CLIPPED,"   AND gds18 = 1 "
       ELSE
          LET g_sql = g_sql CLIPPED,"   AND gds18 = ",p_sn
       END IF
       LET g_sql = g_sql CLIPPED," ORDER BY gds01"
       DECLARE p_xglang_setcombo_curs CURSOR FROM g_sql
    
       LET l_combo_item = NULL
       FOREACH p_xglang_setcombo_curs USING g_gdr.gdr00,g_gds02 INTO l_gds01,l_gds03
           LET l_combo_item = l_combo_item CLIPPED,l_gds03 CLIPPED,","
       END FOREACH
       CALL g_gds.deleteElement(g_cnt)
    
       IF LENGTH(l_combo_item) > 1 THEN
          LET l_combo_item = l_combo_item[1,LENGTH(l_combo_item)-1]
       END IF
    #  DISPLAY p_column
    #  DISPLAY l_combo_item
       CALL cl_set_combo_items(p_column,l_combo_item,'')

END FUNCTION

 # 選出筆數直接寫入 g_sub_row_count
FUNCTION p_xglang_sub_count()
DEFINE l_gdr00  LIKE gdr_file.gdr00
DEFINE l_gds18  LIKE gds_file.gds18
DEFINE l_gds19  LIKE gds_file.gds19

    LET g_sql = "SELECT DISTINCT gds18,gds19 ",
                "  FROM gds_file ",
                " WHERE gds00 = ",g_gdr.gdr00,
                "   AND gds18 > 1 "
    DECLARE p_xglang_sub_count_cs CURSOR FROM g_sql
    LET g_sub_row_count = 0
    FOREACH p_xglang_sub_count_cs INTO l_gds18,l_gds19
        LET g_sub_row_count = g_sub_row_count + 1
    END FOREACH
    DISPLAY g_sub_row_count TO formonly.cnt

END FUNCTION

FUNCTION p_xglang_upd_gds2()
    
    LET g_success = 'Y'
    IF l_ac <= 0 THEN RETURN END IF

  #FUN-CC0039 mark
  # IF g_gds[l_ac].gds20 MATCHES '[Y]' THEN
  #    UPDATE gds_file SET gds20 = 'N'
  #     WHERE gds00 = g_gdr.gdr00
  #       AND gds01 <> g_gds_t.gds01
  #    IF SQLCA.sqlcode THEN
  #       CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_gds_t.gds01,SQLCA.sqlcode,"","",0)
  #       LET g_success = 'N'
  #       RETURN
  #    END IF
  # END IF
  #FUN-CC0039 mark

    IF g_gds[l_ac].gds21 MATCHES '[Y]' THEN
       UPDATE gds_file SET gds21 = 'N'
        WHERE gds00 = g_gdr.gdr00
          AND gds01 <> g_gds_t.gds01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_gds_t.gds01,SQLCA.sqlcode,"","",0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF

    IF g_gds[l_ac].gds22 MATCHES '[Y]' THEN
       UPDATE gds_file SET gds22 = 'N'
        WHERE gds00 = g_gdr.gdr00
          AND gds01 <> g_gds_t.gds01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_gds_t.gds01,SQLCA.sqlcode,"","",0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF

END FUNCTION

FUNCTION p_xglang_chart()
DEFINE p_cmd  LIKE type_file.chr1
DEFINE i      LIKE type_file.num5
DEFINE l_lock_sw  LIKE type_file.chr1

    IF cl_null(g_gdr.gdr00) OR g_gdr.gdr00=0 THEN RETURN END IF
    LET g_forupd_sql =  "SELECT gds01,gds03,gds04,",
                        "       gds26,gds24,gds25,gds27 ",
                        "  FROM gds_file ",
                        " WHERE gds00=? AND gds01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_xglang_bcl2 CURSOR FROM g_forupd_sql

    OPEN WINDOW p_xglang_2_w WITH FORM "azz/42f/p_xglang_2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("p_xglang_2")
    CALL cl_set_comp_required("gdr11",FALSE)

    CALL p_xglang_chart_fill()
    CALL p_xglang_chart_visible(g_gdr.gdr11)

    DISPLAY BY NAME g_gdr.gdr11,g_gdr.gdr12

  WHILE TRUE
    DIALOG ATTRIBUTE(UNBUFFERED)
         INPUT BY NAME g_gdr.gdr11,g_gdr.gdr12
            ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

            BEFORE INPUT
              BEGIN WORK

            ON CHANGE gdr11
              CALL p_xglang_chart_visible(g_gdr.gdr11)

            AFTER FIELD gdr11
              IF cl_null(g_gdr.gdr11) THEN
                 LET g_gdr.gdr11= ' '
              ELSE
                 CALL p_xglang_chart_visible(g_gdr.gdr11)
              END IF

            AFTER FIELD gdr12
              IF g_gdr.gdr12 NOT MATCHES '[12]' THEN
                 NEXT FIELD CURRENT
              END IF

            AFTER INPUT
              IF g_gdr.gdr11 MATCHES "[23]" THEN
                 LET g_gdr.gdr12 = '1'
                #清空 長條圖/線圖 的設定
                 UPDATE gds_file SET gds24 = NULL,
                                     gds25 = ' '
                  WHERE gds00 = g_gdr.gdr00
              END IF
              IF cl_null(g_gdr.gdr11) THEN
                 LET g_gdr.gdr11=' '
                 LET g_gdr.gdr12=' '
              END IF
              UPDATE gdr_file SET gdr11 = g_gdr.gdr11,
                                  gdr12 = g_gdr.gdr12
               WHERE gdr00 = g_gdr.gdr00
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err('upd gdr11:',STATUS,1)
                 EXIT DIALOG
              END IF
              COMMIT WORK
         
         END INPUT

         INPUT ARRAY g_gds_chart FROM s_gds_chart.*
             ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
             INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

             BEFORE INPUT
               IF g_rec_b2 != 0 THEN
                  CALL fgl_set_arr_curr(l_ac2)
               END IF 

             AFTER INPUT


             BEFORE ROW
               LET p_cmd=''
               LET l_ac2 = DIALOG.getCurrentRow("s_gds_chart")
               LET l_lock_sw = 'N'            #DEFAULT
               IF g_rec_b2 >= l_ac2 THEN
                  BEGIN WORK
                  LET p_cmd='u'
                  LET g_gds_chart_t.* = g_gds_chart[l_ac2].*  #BACKUP
                  OPEN p_xglang_bcl2 USING g_gdr.gdr00,g_gds_chart_t.gds01
                  IF STATUS THEN
                      CALL cl_err("OPEN p_xglang_bcl2:", STATUS, 1)
                  ELSE
                      FETCH p_xglang_bcl2 INTO g_gds_chart[l_ac2].*
                      IF SQLCA.sqlcode THEN
                          CALL cl_err(g_gds_chart_t.gds01,SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                      END IF
                  END IF
                  CALL cl_show_fld_cont()
               END IF
               CALL p_xglang_chart_entry()
               CALL p_xglang_chart_no_entry()
               CALL p_xglang_chart_no_required()
               CALL p_xglang_chart_required()

             
             AFTER ROW
               LET l_ac2 = DIALOG.getCurrentRow("s_gds_chart")
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd='u' THEN
                     LET g_gds_chart[l_ac2].* = g_gds_chart_t.*
                  END IF
                  CLOSE p_xglang_bcl2
                  ROLLBACK WORK
                  EXIT DIALOG
               END IF
               CLOSE p_xglang_bcl2
               COMMIT WORK

             ON ROW CHANGE
                IF INT_FLAG THEN
                    CALL cl_err('',9001,0)
                    LET INT_FLAG = 0
                    LET g_gds[l_ac2].* = g_gds_t.*
                    CLOSE p_xglang_bcl
                    ROLLBACK WORK
                    EXIT DIALOG
                END IF
                IF l_lock_sw = 'Y' THEN
                    CALL cl_err(g_gds[l_ac2].gds01,-263,1)
                    LET g_gds[l_ac2].* = g_gds_t.*
                ELSE
                    UPDATE gds_file SET gds24 = g_gds_chart[l_ac2].gds24,
                                        gds25 = g_gds_chart[l_ac2].gds25,
                                        gds26 = g_gds_chart[l_ac2].gds26,
                                        gds27 = g_gds_chart[l_ac2].gds27
                      WHERE gds00 = g_gdr.gdr00
                        AND gds01 = g_gds_chart_t.gds01
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_gds_chart_t.gds01,SQLCA.sqlcode,"","",0)
                        LET g_gds[l_ac2].* = g_gds_t.*
                    ELSE
                        CALL p_xglang_chart_upd()
                        IF g_success = 'Y' THEN
                           MESSAGE 'UPDATE O.K'
                           COMMIT WORK
                        ELSE
                           ROLLBACK WORK
                           LET g_gds[l_ac2].* = g_gds_t.*
                        END IF
                    END IF
                END IF

             AFTER INSERT

             AFTER FIELD gds26 #圖表X軸
               IF g_gds_chart[l_ac2].gds26 NOT MATCHES '[YN]' THEN
                  NEXT FIELD CURRENT
               END IF
               CALL p_xglang_chart_entry()
               CALL p_xglang_chart_no_entry()

             AFTER FIELD gds24 #欄位Y軸順序
               IF g_gds_chart[l_ac2].gds24 <= 0 THEN
                  NEXT FIELD CURRENT
               END IF
               CALL p_xglang_chart_no_required()
               CALL p_xglang_chart_required()

             AFTER FIELD gds25 #圖表性質(1.線 2.長條 3.區域)
               IF g_gds_chart[l_ac2].gds25 NOT MATCHES '[123]' THEN
                  NEXT FIELD CURRENT
               END IF

             AFTER FIELD gds27 #圖表Y軸
               IF g_gds_chart[l_ac2].gds27 NOT MATCHES '[YN]' THEN
                  NEXT FIELD CURRENT
               END IF

             ON CHANGE gds26
                IF g_gds_chart[l_ac2].gds26 MATCHES '[Y]' THEN
                   FOR i = 1 TO g_gds_chart.getlength()
                       IF i = l_ac2 THEN CONTINUE FOR END IF
                       LET g_gds_chart[i].gds26 = 'N' 
                   END FOR
                END IF

            #ON CHANGE gds27
            #   IF g_gds_chart[l_ac2].gds27 MATCHES '[Y]' THEN
            #      FOR i = 1 TO g_gds_chart.getlength()
            #          IF i = l_ac2 THEN CONTINUE FOR END IF
            #          LET g_gds_chart[i].gds27 = 'N' 
            #      END FOR
            #   END IF

         END INPUT
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG
   
          ON ACTION about
             CALL cl_about()
        
          ON ACTION help
             CALL cl_show_help()
        
          ON ACTION controlg 
             CALL cl_cmdask()
        
          ON ACTION accept
             ACCEPT DIALOG
         
          ON ACTION cancel
             EXIT DIALOG

    END DIALOG

    CALL p_xglang_chart_chk()
    IF g_success = 'Y' THEN
       EXIT WHILE
    ELSE
       CONTINUE WHILE
    END IF
  END WHILE

    CLOSE WINDOW p_xglang_2_w

END FUNCTION

FUNCTION p_xglang_chart_fill()
DEFINE l_sql   STRING
DEFINE l_n     LIKE type_file.num5
    LET l_sql = "SELECT gds01,gds03,gds04,gds26,gds24,gds25,gds27 ",
                "  FROM gds_file ",
                " WHERE gds00 = '",g_gdr.gdr00,"'",
                " ORDER BY gds01 "
    PREPARE p_xglang_chart_pr FROM l_sql
    DECLARE p_xglang_chart_cs CURSOR FOR p_xglang_chart_pr
    CALL g_gds_chart.clear()
    LET l_n = 1

    FOREACH p_xglang_chart_cs INTO g_gds_chart[l_n].*
        IF STATUS THEN CALL cl_err('fill chart:',STATUS,1) EXIT FOREACH END IF
        LET l_n = l_n + 1
    END FOREACH
    CALL g_gds_chart.deleteElement(l_n)
    LET g_rec_b2 = l_n - 1

END FUNCTION

FUNCTION p_xglang_chart_visible(p_gdr11)
DEFINE p_gdr11  LIKE gdr_file.gdr11

    CALL cl_set_comp_visible("gds24,gds25,gds26,gds27,gdr12",TRUE)
    CASE p_gdr11
       WHEN "1" #長條/線圖
         CALL cl_set_comp_visible("gds27",FALSE)
       WHEN "2" #圓餅圖
         CALL cl_set_comp_visible("gds24,gds25",FALSE)
         CALL cl_set_comp_visible("gdr12",FALSE)
       WHEN "3" #雷達圖
         CALL cl_set_comp_visible("gds24,gds25",FALSE)
         CALL cl_set_comp_visible("gdr12",FALSE)
       OTHERWISE
         CALL cl_set_comp_visible("gds24,gds25,gds26,gds27,gdr12",FALSE)
    END CASE

END FUNCTION

FUNCTION p_xglang_chart_entry()

    CALL cl_set_comp_entry("gds24,gds25,gds26,gds27",TRUE)

END FUNCTION

FUNCTION p_xglang_chart_no_entry()
DEFINE l_gds15  LIKE gds_file.gds15

    IF l_ac2 <=0 THEN RETURN END IF

    IF g_gdr.gdr11 MATCHES '[23]' THEN
       SELECT gds15 INTO l_gds15 FROM gds_file
        WHERE gds00 = g_gdr.gdr00
          AND gds01 = g_gds_chart[l_ac2].gds01
       IF l_gds15 NOT MATCHES '[N]' THEN #非數字 (Y軸必須為數字才可分析)
          CALL cl_set_comp_entry("gds27",FALSE)
       END IF
    END IF

   #此欄位勾選分類後，不能再選彙總
    IF g_gdr.gdr11 = '1' THEN
       IF g_gds_chart[l_ac2].gds26 MATCHES '[Y]' THEN
          CALL cl_set_comp_entry("gds24,gds25",FALSE)
       END IF
    END IF

END FUNCTION

FUNCTION p_xglang_chart_no_required()

    CALL cl_set_comp_required("gds25",FALSE)

END FUNCTION

FUNCTION p_xglang_chart_required()

    IF l_ac2 <=0 THEN RETURN END IF
    IF NOT cl_null(g_gds_chart[l_ac2].gds24) THEN
       CALL cl_set_comp_required("gds25",TRUE)
    END IF

END FUNCTION

FUNCTION p_xglang_chart_chk()
DEFINE l_n   LIKE type_file.num5


    LET g_success = 'Y' 
    IF cl_null(g_gdr.gdr11) THEN RETURN END IF #沒設圖型，不檢查

    SELECT COUNT(*) INTO l_n
      FROM gds_file
     WHERE gds00 = g_gdr.gdr00
       AND gds26 = 'Y'
    IF l_n <> 1 THEN
       CALL cl_err('分類欄位設定錯誤','!',1)
       LET g_success = 'N'
       RETURN
    END IF  
    IF g_gdr.gdr11 = '1' THEN #長條/線圖
       SELECT COUNT(*) INTO l_n
         FROM gds_file
        WHERE gds00 = g_gdr.gdr00
          AND gds25 IN ('1','2','3')
       IF l_n = 0 THEN
          CALL cl_err('','azz1268',1)
          LET g_success = 'N'
          RETURN
       END IF
    END IF
     
    IF g_gdr.gdr11 = '2' THEN #餅圖
       SELECT COUNT(*) INTO l_n
         FROM gds_file
        WHERE gds00 = g_gdr.gdr00
          AND gds27 = 'Y'
       IF l_n <> 1 THEN
          CALL cl_err('','azz1269',1)
          LET g_success = 'N'
          RETURN
       END IF
    END IF

END FUNCTION

FUNCTION p_xglang_chart_upd()
    
    LET g_success = 'Y'
    IF l_ac2 <= 0 THEN RETURN END IF

    IF g_gds_chart[l_ac2].gds26 MATCHES '[Y]' THEN
       UPDATE gds_file SET gds26 = 'N'
        WHERE gds00 = g_gdr.gdr00
          AND gds01 <> g_gds_chart_t.gds01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_gds_chart_t.gds01,SQLCA.sqlcode,"","",0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF

 #  IF g_gds_chart[l_ac2].gds27 MATCHES '[Y]' THEN
 #     UPDATE gds_file SET gds27 = 'N'
 #      WHERE gds00 = g_gdr.gdr00
 #        AND gds01 <> g_gds_chart_t.gds01
 #     IF SQLCA.sqlcode THEN
 #        CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_gds_chart_t.gds01,SQLCA.sqlcode,"","",0)
 #        LET g_success = 'N'
 #        RETURN
 #     END IF
 #  END IF

END FUNCTION


FUNCTION p_xglang_show_act()
DEFINE l_cnt   LIKE type_file.num5

    IF g_gdr.gdr00 = 0 OR cl_null(g_gdr.gdr00) THEN
       CALL cl_set_comp_visible("sub_report",FALSE)
    END IF

    SELECT COUNT(*) INTO l_cnt
      FROM gds_file
     WHERE gds18 > 1
       AND gds00 = g_gdr.gdr00
    IF l_cnt > 0 THEN
       CALL cl_set_act_visible("sub_report",TRUE)
    ELSE
       CALL cl_set_act_visible("sub_report",FALSE)
    END IF

   #目前僅明細清單有圖表
    IF g_gdr.gdr06 MATCHES '[12]' THEN
       CALL cl_set_act_visible("chart_set",TRUE)
    ELSE
       CALL cl_set_act_visible("chart_set",FALSE)
    END IF


END FUNCTION

FUNCTION p_xglang_sub_u()

   IF cl_null(g_gdr.gdr00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL cl_opmsg('u')
   LET g_gds19_t = g_gds19

   BEGIN WORK
   DISPLAY g_gds19 TO gds19

   WHILE TRUE
      CALL p_xglang_sub_i("u")
      IF INT_FLAG THEN
         LET g_gds19_t = g_gds19
         DISPLAY g_gds19 TO gds19
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE gds_file SET gds19 = g_gds19
       WHERE gds00 = g_gdr.gdr00
         AND gds18 = g_gds18
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_gdr.gdr01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   COMMIT WORK

END FUNCTION

FUNCTION p_xglang_sub_i(p_cmd)
DEFINE  p_cmd    LIKE type_file.chr1
DEFINE  i        LIKE type_file.num5

   CALL cl_set_head_visible("","YES")
   INPUT g_gds19 WITHOUT DEFAULTS FROM gds19
       
       AFTER FIELD gds19
         IF cl_null(g_gds19) THEN
            NEXT FIELD CURRENT
         END IF

       AFTER INPUT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            EXIT INPUT
        END IF

   END INPUT

END FUNCTION

FUNCTION p_xglang_sub_b()
DEFINE  l_ac2_t         LIKE type_file.num5,   # 未取消的ARRAY CNT SMALLINT
        l_n,i           LIKE type_file.num5,   # 檢查重複用 SMALLINT
        l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否 
        p_cmd           LIKE type_file.chr1,   # 處理狀態  
        l_allow_insert  LIKE type_file.num5,   # SMALLINT
        l_allow_delete  LIKE type_file.num5    # SMALLINT
DEFINE l_str  STRING
DEFINE l_cnt  LIKE type_file.num5

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_gdr.gdr00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    LET g_forupd_sql =  "SELECT gds01,gds03,gds04,gds14,gds05,gds06,",
                        "       gds09,gds10,gds11,gds20,gds13,gds23,",
                        "       gds16,gds28,gds17,gds15",
                        "  FROM gds_file ",
                        " WHERE gds00=? AND gds01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_xglang_bcl3 CURSOR FROM g_forupd_sql

    CALL cl_opmsg('b')

    LET l_allow_insert = FALSE  #不允許新增一筆單身資料
    LET l_allow_delete = FALSE  #不允許刪除一筆單身資料

    LET l_ac2_t = 0

    INPUT ARRAY g_sub_gds WITHOUT DEFAULTS FROM s_sub_gds.*
        ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b2 != 0 THEN
                CALL fgl_set_arr_curr(l_ac2)
            END IF
            LET g_before_input_done = FALSE
           #CALL p_xglang_sub_set_entry_b()
           #CALL p_xglang_sub_set_no_entry_b()
            LET g_before_input_done = TRUE

        BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()

            IF g_rec_b2>= l_ac2 THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_sub_gds_t.* = g_sub_gds[l_ac2].*    #BACKUP
                OPEN p_xglang_bcl3 USING g_gdr.gdr00,g_sub_gds_t.gds01
                IF SQLCA.sqlcode THEN
                    CALL cl_err("OPEN p_xglang_bcl3:",STATUS,1)
                    LET l_lock_sw = 'Y'
                ELSE
                    FETCH p_xglang_bcl3 INTO g_sub_gds[l_ac2].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('FETCH p_xglang_bcl3:',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()
            END IF
           #CALL p_xglang_sub_set_no_required_b()
           #CALL p_xglang_sub_set_required_b()
           #CALL p_xglang_sub_set_entry_b()
           #CALL p_xglang_sub_set_no_entry_b()
            
        BEFORE INSERT

         AFTER FIELD gds04
            IF NOT cl_null(g_sub_gds[l_ac2].gds04) THEN
               LET l_str = g_sub_gds[l_ac2].gds04
               LET l_cnt = l_str.getIndexOf(":",1)
               IF l_cnt > 0 THEN
                  CALL cl_err('','azz1295',1)
                  NEXT FIELD CURRENT
               END IF
               LET l_cnt = l_str.getIndexOf(",",1)
               IF l_cnt > 0 THEN
                  CALL cl_err('','azz1295',1)
                  NEXT FIELD CURRENT
               END IF
            END IF
                
         AFTER FIELD gds05
            IF NOT cl_null(g_sub_gds[l_ac2].gds05) THEN
               IF g_sub_gds[l_ac2].gds05 <= 0 THEN
                  NEXT FIELD CURRENT
               END IF
            END IF

         AFTER FIELD gds06
            IF NOT cl_null(g_sub_gds[l_ac2].gds06) THEN
               IF g_sub_gds[l_ac2].gds06 <= 0 THEN
                  NEXT FIELD CURRENT
               END IF
            END IF

       #FUN-CC0115 add---(S)
        BEFORE FIELD gds09
            CALL p_xglang_sub_set_no_required_b()
            CALL p_xglang_sub_set_required_b()
            CALL p_xglang_sub_set_entry_b()
            CALL p_xglang_sub_set_no_entry_b()

        AFTER FIELD gds09 
            IF g_sub_gds[l_ac2].gds09 NOT MATCHES '[YN]' THEN 
               NEXT FIELD CURRENT
            END IF
            CALL p_xglang_sub_set_no_required_b()
            CALL p_xglang_sub_set_required_b()
            CALL p_xglang_sub_set_entry_b()
            CALL p_xglang_sub_set_no_entry_b()
            IF g_sub_gds[l_ac2].gds10='Y' OR g_sub_gds[l_ac2].gds09='Y' THEN
               LET g_sub_gds[l_ac2].gds20=' ' 
            END IF

        ON CHANGE gds09
            CALL p_xglang_sub_set_no_required_b()
            CALL p_xglang_sub_set_required_b()
            CALL p_xglang_sub_set_entry_b()
            CALL p_xglang_sub_set_no_entry_b()

        BEFORE FIELD gds10
            CALL p_xglang_sub_set_no_required_b()
            CALL p_xglang_sub_set_required_b()
            CALL p_xglang_sub_set_entry_b()
            CALL p_xglang_sub_set_no_entry_b()

        AFTER FIELD gds10
            IF g_sub_gds[l_ac].gds10 NOT MATCHES '[YN]' THEN 
               NEXT FIELD CURRENT
            END IF
            CALL p_xglang_sub_set_no_required_b()
            CALL p_xglang_sub_set_required_b()
            CALL p_xglang_sub_set_entry_b()
            CALL p_xglang_sub_set_no_entry_b()
            IF g_sub_gds[l_ac2].gds10='Y' OR g_sub_gds[l_ac2].gds09='Y' THEN
               LET g_sub_gds[l_ac2].gds20=' ' 
            END IF

        ON CHANGE gds10
            CALL p_xglang_sub_set_no_required_b()
            CALL p_xglang_sub_set_required_b()
            CALL p_xglang_sub_set_entry_b()
            CALL p_xglang_sub_set_no_entry_b()
       #FUN-CC0115 add---(E)

         AFTER FIELD gds14
            IF g_sub_gds[l_ac2].gds14 NOT MATCHES '[YN]' THEN
               NEXT FIELD CURRENT
            END IF
            IF g_sub_gds[l_ac2].gds14='N' THEN
               LET g_sub_gds[l_ac2].gds09 = 'N'
               LET g_sub_gds[l_ac2].gds10 = 'N'
               LET g_sub_gds[l_ac2].gds11 = NULL
               LET g_sub_gds[l_ac2].gds20 = ' '
            END IF

         AFTER FIELD gds23  
            IF g_sub_gds[l_ac2].gds23 NOT MATCHES '[YN]' THEN
               NEXT FIELD CURRENT
            END IF

         AFTER FIELD gds16
            IF g_sub_gds[l_ac2].gds16 NOT MATCHES '[YN]' THEN
               NEXT FIELD CURRENT
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sub_gds[l_ac2].* = g_sub_gds_t.*
               CLOSE p_xglang_bcl3
               ROLLBACK WORK
               EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sub_gds[l_ac2].gds01,-263,1)
               LET g_sub_gds[l_ac2].* = g_sub_gds_t.*
           ELSE 
               UPDATE gds_file SET gds04 = g_sub_gds[l_ac2].gds04,
                                   gds05 = g_sub_gds[l_ac2].gds05,
                                   gds06 = g_sub_gds[l_ac2].gds06,
                                   gds09 = g_sub_gds[l_ac2].gds09,
                                   gds10 = g_sub_gds[l_ac2].gds10,
                                   gds11 = g_sub_gds[l_ac2].gds11,
                                   gds13 = g_sub_gds[l_ac2].gds13,
                                   gds14 = g_sub_gds[l_ac2].gds14,
                                   gds15 = g_sub_gds[l_ac2].gds15,
                                   gds16 = g_sub_gds[l_ac2].gds16,
                                   gds17 = g_sub_gds[l_ac2].gds17,
                                   gds20 = g_sub_gds[l_ac2].gds20,
                                   gds23 = g_sub_gds[l_ac2].gds23,
                                   gds28 = g_sub_gds[l_ac2].gds28
                 WHERE gds00 = g_gdr.gdr00
                   AND gds01 = g_sub_gds_t.gds01
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","gds_file",g_gdr.gdr00,g_sub_gds_t.gds01,SQLCA.sqlcode,"","",0)
                    LET g_sub_gds[l_ac2].* = g_sub_gds_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF

        AFTER ROW
            LET l_ac2 = ARR_CURR()
            LET l_ac2_t = l_ac2

            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_sub_gds[l_ac2].* = g_sub_gds_t.*
                END IF
                CLOSE p_xglang_bcl3
                ROLLBACK WORK
                EXIT INPUT
            END IF
            CLOSE p_xglang_bcl3
            COMMIT WORK
            
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLZ
            CALL cl_show_req_fields()

        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

        ON ACTION HELP
            CALL cl_show_help()

        ON ACTION about
            CALL cl_about()

        ON ACTION controls
            CALL cl_set_head_visible("","AUTO")

    END INPUT

    CLOSE p_xglang_bcl3
    COMMIT WORK
    CALL p_xglang_resort('Y')
    

END FUNCTION

FUNCTION p_xglang_get_gds29(p_datatype,p_length)
DEFINE p_datatype  LIKE ahe_file.ahe04
DEFINE p_length    LIKE type_file.num5 
DEFINE l_gds29     LIKE gds_file.gds29

      LET l_gds29 = p_length / 5
      IF l_gds29 > 5 THEN
         LET l_gds29 = 5
      END IF
      IF l_gds29 < 1 THEN
         LET l_gds29 = 1
      END IF

      RETURN l_gds29
END FUNCTION

FUNCTION p_xglang_copy_other_lang()
DEFINE l_wc,l_sql      STRING
DEFINE l_gds02         LIKE gds_file.gds02
DEFINE l_overwrite LIKE type_file.chr1
DEFINE l_gdr00         LIKE gdr_file.gdr00
DEFINE l_gay01         LIKE gay_file.gay01
DEFINE l_gdr           RECORD LIKE gdr_file.*
DEFINE l_gds           RECORD LIKE gds_file.*
DEFINE l_n,l_cnt       LIKE type_file.num5

    IF cl_null(g_gdr.gdr00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    LET l_sql = "SELECT UNIQUE gds02 FROM gds_file ",
                " WHERE gds00 ='",g_gdr.gdr00,"'"
    PREPARE p_xglang_uni_gds02_pr FROM l_sql
    DECLARE p_xglang_uni_gds02_cs CURSOR FOR p_xglang_uni_gds02_pr
    LET l_gds02 = NULL
    FOREACH p_xglang_uni_gds02_cs INTO l_gds02
        EXIT FOREACH
    END FOREACH
    IF cl_null(l_gds02) THEN RETURN END IF

    IF NOT cl_confirm('mfg-065') THEN
       RETURN 
    END IF    

   #抓不是目前這個語言的其它語言
    LET l_sql = "SELECT gay01 FROM gay_file ",
                " WHERE gay01 <> '",l_gds02,"'",
                " ORDER BY gay01 "
    PREPARE p_xglang_gay01_pr FROM l_sql
    DECLARE p_xglang_gay01_cs CURSOR FOR p_xglang_gay01_pr

    LET l_sql = "SELECT * FROM gds_file ",
                " WHERE gds00 = '",g_gdr.gdr00,"'",
                " ORDER BY gds01 "
    PREPARE p_xglang_selgds_pr FROM l_sql
    DECLARE p_xglang_selgds_cs CURSOR FOR p_xglang_selgds_pr

    BEGIN WORK
    LET g_success = 'Y'
    LET l_cnt = 0
   #檢查是否有其它語言-------(S)
    SELECT COUNT(*) INTO l_n FROM gdr_file,gds_file
     WHERE gdr00 = gds00
       AND gdr01 = g_gdr.gdr01
       AND gdr02 = g_gdr.gdr02
       AND gdr04 = g_gdr.gdr04
       AND gdr05 = g_gdr.gdr05
       AND gds02 <> g_gds02
    IF l_n > 0 THEN
       IF cl_confirm('azz1273') THEN
          DECLARE p_xglang_sel_gdr00_cs3 CURSOR FOR
           SELECT UNIQUE gdr00 FROM gdr_file,gds_file
            WHERE gdr00 = gds00
              AND gdr01 = g_gdr.gdr01
              AND gdr02 = g_gdr.gdr02
              AND gdr04 = g_gdr.gdr04
              AND gdr05 = g_gdr.gdr05
              AND gds02 <> g_gds02
          FOREACH p_xglang_sel_gdr00_cs3 INTO l_gdr00
              DELETE FROM gdr_file WHERE gdr00 = l_gdr00
              DELETE FROM gds_file WHERE gds00 = l_gdr00
          END FOREACH
       END IF
    END IF
   #檢查是否有其它語言-------(E)
    FOREACH p_xglang_gay01_cs INTO l_gay01
       #同樣板存在此語言就跳過不INSERT
        SELECT COUNT(*) INTO l_n FROM gdr_file,gds_file
         WHERE gdr00 = gds00
           AND gdr01 = g_gdr.gdr01
           AND gdr02 = g_gdr.gdr02
           AND gdr04 = g_gdr.gdr04
           AND gdr05 = g_gdr.gdr05
           AND gds02 = l_gay01
        IF l_n > 0 THEN CONTINUE FOREACH END IF
        SELECT MAX(gdr00)+1 INTO l_gdr00 FROM gdr_file
        IF cl_null(l_gdr00) THEN LET l_gdr00 = 1 END IF
        SELECT * INTO l_gdr.* FROM gdr_file WHERE gdr00 = g_gdr.gdr00
        LET l_gdr.gdr00 = l_gdr00
        INSERT INTO gdr_file VALUES(l_gdr.*)
        IF STATUS THEN
           CALL cl_err('insert gdr:',STATUS,1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        FOREACH p_xglang_selgds_cs INTO l_gds.*
           LET l_gds.gds00 = l_gdr00
           LET l_gds.gds02 = l_gay01

           LET l_gds.gds04 = NULL
           SELECT gaq03 INTO l_gds.gds04 FROM gaq_file
            WHERE gaq01 = l_gds.gds03
              AND gaq02 = l_gds.gds02
           IF cl_null(l_gds.gds04) THEN
              LET l_gds.gds04 = l_gds.gds03
           END IF
           CALL cl_replace_str(l_gds.gds04,",","") RETURNING l_gds.gds04

           INSERT INTO gds_file VALUES(l_gds.*)
           IF STATUS THEN
              CALL cl_err('insert gds:',STATUS,1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        END FOREACH
        IF g_success = 'N' THEN EXIT FOREACH END IF
        LET l_cnt = l_cnt + 1
    END FOREACH

    IF g_success = 'Y' AND l_cnt = 0 THEN
       CALL cl_err('','azz1271',1)
       LET g_success = 'N'
    END IF

    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_err('','aic-059',1)
    ELSE
       ROLLBACK WORK
    END IF

   CLOSE WINDOW p_xglang_3_w

END FUNCTION

FUNCTION p_xglang_genxml()
DEFINE p_cmd  LIKE type_file.chr1
DEFINE i      LIKE type_file.num5
DEFINE l_lock_sw  LIKE type_file.chr1
DEFINE l_i    LIKE type_file.num5
DEFINE l_chk  LIKE type_file.chr10
DEFINE l_cnt  LIKE type_file.num5

    IF cl_null(g_gdr.gdr00) OR g_gdr.gdr00=0 THEN RETURN END IF

   #掃描4gl，檢查是否符合此功能 ( CALL cl_prt_cs1 的才繼續下去)
    CALL p_xglang_chk_include() RETURNING l_chk
    IF l_chk = 'cs3' THEN
       CALL cl_err('','azz1274',1) #請改用掃描欄位功能
       RETURN
    END IF

    OPEN WINDOW p_xglang_4_w WITH FORM "azz/42f/p_xglang_4"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("p_xglang_4")
    CALL cl_set_comp_visible('xml04,xml05',FALSE)

    INPUT g_xml_sql WITHOUT DEFAULTS FROM xmlsql
  
        AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               CLEAR FORM
               CALL g_xml.clear()
               LET g_rec_b3 = 0
               EXIT INPUT
           END IF
        
           #檢查 SQL 指令是否正確 
           IF NOT p_xglang_genxml_sql_check(g_xml_sql) THEN
              NEXT FIELD xmlsql
           END IF
  
           #產生 XML Array
           IF NOT p_xglang_genxml_array() THEN
              NEXT FIELD xmlsql
           END IF
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about
           CALL cl_about()
  
        ON ACTION help
           CALL cl_show_help()
  
        ON ACTION controlg
           CALL cl_cmdask()
  
        ON ACTION controlz
           CALL cl_show_req_fields()
  
        ON ACTION controlf                        # 欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
           
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=FALSE
       CLOSE WINDOW p_xglang_4_w
       RETURN
    END IF
       
    CALL cl_set_act_visible("accept",FALSE)
    DISPLAY ARRAY g_xml TO s_xml.* ATTRIBUTE(UNBUFFERED)

        BEFORE DISPLAY

        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

        ON ACTION xml_gen
            LET g_action_choice="xml_gen"
            EXIT DISPLAY
            
        ON ACTION cancel
            LET INT_FLAG=TRUE
            LET g_action_choice="exit"
            EXIT DISPLAY

        ON ACTION help                             # H.說明
            LET g_action_choice='help'
            EXIT DISPLAY

        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            EXIT DISPLAY

        ON ACTION exit                             # Esc.結束
            LET g_action_choice='exit'
            EXIT DISPLAY

        ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DISPLAY
            
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

        ON ACTION about
            CALL cl_about()

        AFTER DISPLAY
            CONTINUE DISPLAY

        ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
        

    END DISPLAY
    CALL cl_set_act_visible("accept",TRUE)
    IF INT_FLAG THEN
       LET INT_FLAG=FALSE
       LET g_action_choice = NULL
       CLOSE WINDOW p_xglang_4_w
       RETURN
    END IF

    IF g_action_choice <> 'xml_gen' THEN
       LET g_action_choice = NULL
       CLOSE WINDOW p_xglang_4_w
       RETURN
    END IF
       
    IF cl_confirm('azz1276') THEN
       BEGIN WORK
       LET g_success = 'Y'

       SELECT COUNT(*) INTO l_i FROM gds_file
        WHERE gds00 = g_gdr.gdr00
       IF l_i > 0 THEN
          IF cl_confirm('azz1277') THEN
             DELETE FROM gds_file
              WHERE gds00 = g_gdr.gdr00
             IF STATUS THEN
                LET g_success = 'Y'
             END IF
          END IF
       END IF

       IF g_success = 'Y' THEN
          LET g_cnt = 0
          FOR l_i = 1 TO g_xml.getlength()
              IF cl_null(g_xml[l_i].xml01) THEN CONTINUE FOR END IF
              CALL p_xglang_ins_gds(g_xml[l_i].xml01,
                                    g_xml[l_i].xml04,
                                    g_xml[l_i].xml05,1)
              IF g_success = 'N' THEN EXIT FOR END IF
          END FOR
       END IF

       IF g_success = 'Y' THEN
          COMMIT WORK
          IF g_cnt > 0 THEN
             CALL cl_err('','abm-019',1)
          ELSE
             CALL cl_err('','axc-034',1)
          END IF
       ELSE
          ROLLBACK WORK
       END IF
    END IF


   LET g_action_choice = NULL
   LET g_xml_sql = NULL
   CLOSE WINDOW p_xglang_4_w
   CALL p_xglang_b_fill(' 1=1')
END FUNCTION

FUNCTION p_xglang_chk_include() 
DEFINE l_sql  STRING
DEFINE l_n    LIKE type_file.num5
DEFINE l_chk  LIKE type_file.chr1
DEFINE l_4gldir LIKE type_file.chr1000
DEFINE l_tmpline    STRING  #目前所在行內容
DEFINE l_utmpline   STRING  #目前所在行轉大寫後的內容
DEFINE l_varname    STRING  #變數名稱字串
DEFINE l_paramstr   STRING  #參數字串
DEFINE l_tmpTabLn   LIKE type_file.num10 #cl_prt_temptable()所在行數
DEFINE l_lastLn     LIKE type_file.num10 #原始程式最後比對的行數
DEFINE l_cs3Ln      LIKE type_file.num10 #cl_prt_cs3()所在行數
DEFINE l_ttsqlLnS   LIKE type_file.num10 #TempTable SQL開始行數
DEFINE l_ttsqlLnE   LIKE type_file.num10 #TempTable SQL結束行數
DEFINE l_cs3sqlLnS  LIKE type_file.num10 #cs3 SQL開始行數
DEFINE l_cs3sqlLnE  LIKE type_file.num10 #cs3 SQL結束行數
DEFINE l_cs3strLnS  LIKE type_file.num10 #cs3 Str開始行數
DEFINE l_cs3strLnE  LIKE type_file.num10 #cs3 Str結束行數
DEFINE l_i          LIKE type_file.num5
DEFINE l_cnt,i      LIKE type_file.num5

    #讀取 4gl 中是否含有一開始定義的 SQL
     LET l_4gldir = p_xglang_get_4gldir(g_gdr.gdr01)
     IF cl_null(l_4gldir) THEN RETURN END IF
     CALL p_xglang_load_source(l_4gldir)

    #找出cl_prt_temptable()的程式段
    LET m_mainLn = 0
    LET l_tmpTabLn = 0
    LET l_lastLn = 1
    LET m_trcnt = 0
    CALL g_flddef.clear()
    FOR l_i = 1 TO m_srccode.getLength()
        LET l_tmpline = p_xglang_rm_line_mark(m_srccode[l_i])

        IF l_tmpline IS NOT NULL THEN
            LET l_paramstr = p_xglang_get_substr(l_tmpline,"cl_prt_temptable(",")")
            #找到cl_prt_temptable()該行
            IF l_paramstr IS NOT NULL THEN
                #設定cl_prt_temptable()所在行數
                LET l_tmpTabLn = l_i
                LET l_varname = p_xglang_get_str_part(l_paramstr,",",-1)
                CALL p_xglang_find_lineno(l_varname,l_lastLn,l_tmpTabLn)
                    RETURNING l_ttsqlLnS,l_ttsqlLnE
                LET m_trcnt = m_trcnt + 1
                CALL p_xglang_add_typedef_code(m_tmpcode,l_ttsqlLnS,l_ttsqlLnE,1)
                #將最後比對行數移到目前行
                LET l_lastLn = l_tmpTabLn
            END IF

            IF m_mainLn <= 0 THEN
                LET l_utmpline = l_tmpline.toUpperCase()
                IF l_utmpline.getIndexOf("MAIN",1) > 0 THEN
                    LET m_mainLn = l_i
                END IF
            END IF
        END IF
    END FOR

    LET l_cnt = 0 
    FOR i = 1 TO g_flddef.getlength()
        IF NOT cl_null(g_flddef[i].recno) THEN
           LET l_cnt = l_cnt + 1
        END IF
    END FOR

    IF l_cnt > 0 THEN
       RETURN 'cs3'
    ELSE
       RETURN 'cs1'
    END IF

END FUNCTION

FUNCTION p_xglang_genxml_chkname(p_xmlname)
 DEFINE p_xmlname   LIKE zz_file.zz01
 DEFINE li_i1       LIKE type_file.num5    #No.FUN-680135 SMALLINT
 DEFINE li_i2       LIKE type_file.num5    #No.FUN-680135 SMALLINT
 DEFINE lc_zz08     LIKE zz_file.zz08
 DEFINE lc_db       LIKE type_file.chr3    #No.FUN-680135 VARCHAR(3)
 DEFINE ls_str      STRING
 DEFINE lc_xmlname  STRING
 DEFINE l_cnt       LIKE type_file.num10
 DEFINE l_cnt2      LIKE type_file.num10

 LET p_xmlname = p_xglang_genxml_get_prog(p_xmlname) CLIPPED

 LET lc_db=cl_db_get_database_type()
  CASE lc_db
     WHEN "ORA"
         LET lc_zz08="%",p_xmlname CLIPPED,"%"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 LIKE lc_zz08
     WHEN "IFX"
         LET lc_zz08="*",p_xmlname CLIPPED,"*"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 MATCHES lc_zz08
   END CASE
   SELECT COUNT(*) INTO l_cnt from zz_file where zz01= p_xmlname
   IF li_i1 > 0 THEN
      select COUNT(*) INTO l_cnt2 from gak_file where gak01 = p_xmlname
      IF l_cnt2 = 0 THEN
         RETURN 0
      END IF
   ELSE
      IF (li_i1 = 0 AND l_cnt = 0 )THEN
         RETURN 0
      ELSE
         SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01=p_xmlname
         LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
         LET li_i1 = ls_str.getIndexOf("i/",1)
         LET li_i2 = ls_str.getIndexOf(" ",li_i1)
         IF li_i2 <= li_i1 THEN LET li_i2=ls_str.getLength() END IF
         LET lc_xmlname = ls_str.subString(li_i1+2,li_i2)
         CALL cl_err_msg(NULL,"azz-060",p_xmlname CLIPPED|| "|" || lc_xmlname,10)
      END IF
  END IF
  RETURN 1
END FUNCTION

#檢查傳入的字串是否含有正確程式代號, 並傳回程式代號
FUNCTION p_xglang_genxml_get_prog(p_xmlname)
    DEFINE p_xmlname   LIKE zz_file.zz01
    DEFINE lr_xmlname  LIKE zz_file.zz01      #傳出去的程式代號
    DEFINE lc_xmlname  STRING
    DEFINE l_endpos    LIKE type_file.num10   #最後一個'_'字元的位置
    DEFINE l_xmllen    LIKE type_file.num10   #傳入參數p_xmlname的字串長度
    DEFINE l_i         LIKE type_file.num10   #
    DEFINE l_cnt       LIKE type_file.num10

    INITIALIZE lr_xmlname TO NULL

    SELECT COUNT(*) INTO l_cnt from zz_file where zz01= p_xmlname
    IF l_cnt > 0 THEN
        RETURN p_xmlname CLIPPED
    ELSE
        LET lc_xmlname = p_xmlname CLIPPED
        LET l_xmllen = lc_xmlname.getLength()
        FOR l_i = l_xmllen TO 1 STEP -1
            IF lc_xmlname.getCharAt(l_i) = "_" THEN
                LET l_endpos = l_i
                EXIT FOR
            END IF
        END FOR

        IF l_endpos > 1 THEN
            LET lr_xmlname = lc_xmlname.subString(1,l_endpos - 1)
        END IF

        RETURN lr_xmlname CLIPPED
    END IF
END FUNCTION

FUNCTION p_xglang_genxml_sql_check(p_sql)
DEFINE p_sql         STRING
DEFINE buf           base.StringBuffer
DEFINE l_str         STRING
DEFINE l_tmp         STRING
DEFINE l_execmd      STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_start	     LIKE type_file.num5       
DEFINE l_end  	     LIKE type_file.num5       
DEFINE l_tok_table   base.StringTokenizer
DEFINE l_cnt_dot     LIKE type_file.num5
DEFINE l_cnt_comma   LIKE type_file.num5
DEFINE l_text        STRING
DEFINE l_field       RECORD
        field001, field002, field003, field004, field005, field006, field007,
        field008, field009, field010, field011, field012, field013, field014,
        field015, field016, field017, field018, field019, field020, field021,
        field022, field023, field024, field025, field026, field027, field028,
        field029, field030, field031, field032, field033, field034, field035,
        field036, field037, field038, field039, field040, field041, field042,
        field043, field044, field045, field046, field047, field048, field049,
        field050, field051, field052, field053, field054, field055, field056,
        field057, field058, field059, field060, field061, field062, field063,
        field064, field065, field066, field067, field068, field069, field070,
        field071, field072, field073, field074, field075, field076, field077,
        field078, field079, field080, field081, field082, field083, field084,
        field085, field086, field087, field088, field089, field090, field091,
        field092, field093, field094, field095, field096, field097, field098,
        field099, field100  LIKE gaq_file.gaq03     #No.FUN-680135 VARCHAR(255)
                    END RECORD
 
        
        LET buf = base.StringBuffer.create()
        CALL buf.append(p_sql CLIPPED)
        CALL buf.replace( "\"","'", 0)
        LET p_sql = buf.toString()
 
       #LET l_str= cl_query_cut_spaces(p_sql)
        LET l_str= p_sql.trim()                              #No.FUN-810062
        LET l_end = l_str.getIndexOf(';',1)
        IF l_end != 0 THEN
           LET l_str=l_str.subString(1,l_end-1)
        END IF
        LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
        LET l_text = NULL
        WHILE l_tok.hasMoreTokens()
              LET l_tmp=l_tok.nextToken()
              IF l_text is null THEN
                 LET l_text = l_tmp.trim()
              ELSE
                 LET l_text = l_text CLIPPED,' ',l_tmp.trim()
              END IF
        END WHILE
        LET l_tmp=l_text
        LET l_execmd=l_tmp
 
        LET l_execmd = l_execmd.toLowerCase()
        LET l_start = l_execmd.getIndexOf('select',1)
        IF l_start > 0 THEN
 
           PREPARE sql_pre1 FROM l_execmd
           IF SQLCA.SQLCODE THEN
              CALL cl_err("prepare:",sqlca.sqlcode,1) 
              RETURN 0
           END IF
           
           DECLARE sql_cur1 CURSOR FOR sql_pre1
           IF SQLCA.SQLCODE THEN
              CALL cl_err("prepare:",sqlca.sqlcode,1) 
              RETURN 0
           END IF
           
           FOREACH sql_cur1 INTO l_field.*
              EXIT FOREACH
           END FOREACH
           IF SQLCA.SQLCODE THEN
              CALL cl_err("prepare:",sqlca.sqlcode,1) 
              RETURN 0
           END IF
           LET g_sql_type = "S"
        ELSE
           LET l_tok_table = base.StringTokenizer.create(p_sql,".")
           LET l_cnt_dot = l_tok_table.countTokens()
           LET l_tok_table = base.StringTokenizer.create(p_sql,",")
           LET l_cnt_comma = l_tok_table.countTokens()
           IF ((l_cnt_dot-1)/2)  <> l_cnt_comma THEN
             IF g_bgerr THEN                                                                                                               
                CALL s_errmsg('','','','lib-359',1)                                                                     
             ELSE                                                                                                                          
                CALL cl_err('','lib-359',1)                                                                             
             END IF                                                                                                                        
             RETURN 0
           END IF
           LET g_sql_type = "T"
        END IF
        LET g_execmd_sql = l_execmd
        RETURN 1
        
END FUNCTION

FUNCTION p_xglang_genxml_array()
DEFINE l_str              STRING
DEFINE l_str2             STRING
DEFINE l_tok_table        base.StringTokenizer,
       l_table_name       LIKE gac_file.gac05,
       l_field_name       LIKE gac_file.gac06,
       l_alias_name       LIKE gac_file.gac06,
       l_datatype         LIKE ztb_file.ztb04
DEFINE l_p                LIKE type_file.num5,
       l_p2               LIKE type_file.num5,
       l_sql              STRING,
       l_name             STRING,
       l_length           STRING
DEFINE l_i,l_k,l_j        LIKE type_file.num10                  
DEFINE l_feld             DYNAMIC ARRAY OF STRING               #欄位ID
DEFINE l_feld_cnt         LIKE type_file.num5                   #欄位數
DEFINE l_feld_tmp         LIKE type_file.chr1000
DEFINE l_str_bak          STRING
DEFINE l_tmp              STRING
DEFINE l_tok              base.StringTokenizer
DEFINE l_start            LIKE type_file.num10          #No.FUN-680135 SMALLINT
DEFINE l_end              LIKE type_file.num10          #No.FUN-680135 SMALLINT
DEFINE l_sel              LIKE type_file.chr1
DEFINE l_tab_cnt          LIKE type_file.num5  
DEFINE l_tab              DYNAMIC ARRAY OF STRING
DEFINE l_tab_alias        DYNAMIC ARRAY OF STRING
DEFINE l_feld_length      LIKE type_file.num5     #欄位長度
DEFINE l_scale            LIKE type_file.num10    #欄位小數點
DEFINE l_dbname           STRING                        #No.FUN-810062
DEFINE l_table_tok        base.StringTokenizer          #FUN-AC0011
DEFINE l_text             STRING                        #FUN-AC0011
 
   LET g_rec_b = 0
 
   CASE g_sql_type 
      WHEN "S" 
           LET l_str_bak = g_execmd_sql.toLowerCase()
           LET l_start = l_str_bak.getIndexOf('select',1)
           IF l_start=0 THEN
              CALL cl_err('can not execute this command!','!',0)
              RETURN 0
           END IF
           LET l_end   = l_str_bak.getIndexOf('from',1)
           LET l_str2=l_str_bak.subString(l_start+7,l_end-2)
           LET l_str2=l_str2.trim()
           LET l_tok = base.StringTokenizer.createExt(l_str2 CLIPPED,",","",TRUE)
           LET l_i=1
           WHILE l_tok.hasMoreTokens()
                 LET l_feld[l_i]=l_tok.nextToken()
                 LET l_feld[l_i]=l_feld[l_i].trim()
                 LET l_i=l_i+1
           END WHILE
           LET l_feld_cnt=l_i-1
           
           LET l_start = l_str_bak.getIndexOf('from',1)
           LET l_end   = l_str_bak.getIndexOf('where',1)
           IF l_end=0 THEN
              LET l_end   = l_str_bak.getIndexOf('group',1)
              IF l_end=0 THEN
                 LET l_end   = l_str_bak.getIndexOf('order',1)
                 IF l_end=0 THEN
                    LET l_end=l_str_bak.getLength()
                    LET l_str2=l_str_bak.subString(l_start+5,l_end)
                 ELSE
                    LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                 END IF
              ELSE
                 LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
              END IF
           ELSE
              LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
           END IF
           LET l_str2=l_str2.trim()
           LET l_tok = base.StringTokenizer.createExt(l_str2 CLIPPED,",","",TRUE)
           LET l_j=1
           WHILE l_tok.hasMoreTokens()
                 #---FUN-AC0011---start-----
                 #因為sql語法中FROM後面的table有可能會以 JOIN 的形式出現
                 #例1:SELECT XXX FROM nni_file nni LEFT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
                 #例2:SELECT XXX FROM nni_file nni RIGHT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
                 #例3:SELECT XXX FROM nni_file nni OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
                 LET l_str = l_tok.nextToken()

                 #依照關鍵字去除,取代成逗號,以利分割table
                 LET l_text = "left outer join"
                 CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
                 LET l_text = "right outer join"
                 CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
                 LET l_text = "outer join"
                 CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
                 WHILE l_str.getIndexOf("on", 1) > 0
                       #準備將on後面的條件式去除,如:XXXXXX JOIN nma_file nma [ON nma01 = nni06], 
                       LET l_start = l_str.getIndexOf("on", 1) 

                       #從剛才找出on關鍵字地方關始找下一個逗號,應該就是此次所要截取的table名稱和別名
                       #如果後面已找不到逗號位置,代表應該已到字串的最尾端
                       LET l_end = l_str.getIndexOf(",", l_start)  
                       IF l_end = 0 THEN
                          LET l_end = l_str.getLength() + 1   #因為下面會減1,所以這裡先加1
                       END IF
                       LET l_text = l_str.subString(l_start, l_end - 1)
                       CALL cl_replace_str(l_str, l_text, " ") RETURNING l_str
                 END WHILE

                 #依逗號區隔出各table名稱和別名
                 LET l_table_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
                 WHILE l_table_tok.hasMoreTokens()
                 #---FUN-AC0011---end-------
                       #LET l_tab[l_j]=l_tok.nextToken()          #FUN-AC0011 mark 改成下面取tok方式
                       LET l_tab[l_j] = l_table_tok.nextToken()   #FUN-AC0011
                       LET l_tab[l_j]=l_tab[l_j].trim()
                       IF l_tab[l_j].getIndexOf(' ',1) THEN
                          DISPLAY 'qazzaq:',l_tab[l_j].getIndexOf(' ',1)
                          LET l_tab_alias[l_j]=l_tab[l_j].subString(l_tab[l_j].getIndexOf(' ',1)+1,l_tab[l_j].getLength())
                          LET l_tab[l_j]=l_tab[l_j].subString(1,l_tab[l_j].getIndexOf(' ',1)-1)
                       END IF
                       LET l_j=l_j+1
                 END WHILE   #FUN-AC0011 
           END WHILE
           LET l_tab_cnt=l_j-1
          
           CALL cl_query_prt_temptable()     #No.FUN-A60085
         
           FOR l_i=1 TO l_feld_cnt
               IF l_feld[l_i]='*' THEN
                  LET l_start = l_str_bak.getIndexOf('from',1)
                  LET l_end   = l_str_bak.getIndexOf('where',1)
                  IF l_end=0 THEN
                     LET l_end   = l_str_bak.getIndexOf('group',1)
                     IF l_end=0 THEN
                        LET l_end   = l_str_bak.getIndexOf('order',1)
                        IF l_end=0 THEN
                           LET l_end=l_str_bak.getLength()
                           LET l_str2=l_str_bak.subString(l_start+5,l_end)
                        ELSE
                           LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                        END IF
                     ELSE
                        LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                     END IF
                  ELSE
                     LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                  END IF
                  LET l_str2=l_str2.trim()
                  LET l_tok = base.StringTokenizer.createExt(l_str2 CLIPPED,",","",TRUE)
                  FOR l_j=1 TO l_tab_cnt 
                      CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')   #No.FUN-810062
                      DECLARE cl_query_insert_d_ifx CURSOR FOR
                              SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01
                      FOREACH cl_query_insert_d_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                         IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale,'','') THEN   #No.FUN-860089
                            RETURN 0 
                         END IF
                      END FOREACH
                  END FOR
                  EXIT FOR   #確保避免因人為的sql錯誤產生多除的顯示欄位
               ELSE
                  IF l_feld[l_i].getIndexOf('.',1) THEN
                     IF l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())='*' THEN
                        FOR l_j=1 TO l_tab_cnt
                            IF l_tab_alias[l_j] is null THEN
                               IF l_tab[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                                  CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')  #No.FUN-810062
                                  DECLARE cl_query_insert_d1_ifx CURSOR FOR 
                                          SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                                  FOREACH cl_query_insert_d1_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                                     IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale,'','') THEN  #No.FUN-860089
                                        RETURN 0 
                                     END IF
                                  END FOREACH
                               END IF
                            ELSE
                               IF l_tab_alias[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                                  CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')   #No.FUN-810062
                                  DECLARE cl_query_insert_d2_ifx CURSOR FOR 
                                          SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                                  FOREACH cl_query_insert_d2_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                                     IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale,'','') THEN  #No.FUN-860089
                                        RETURN 0 
                                     END IF
                                  END FOREACH
                               END IF
                            END IF 
                        END FOR
                     ELSE
                        LET l_feld[l_i]=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
                        CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0')    #No.FUN-810062
                        DECLARE cl_query_ifx CURSOR FOR 
                                SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                        FOREACH cl_query_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                            IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale,'','') THEN   #No.FUN-860089
                               RETURN 0 
                            END IF
                        END FOREACH
                     END IF
                  ELSE
                        CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0')    #No.FUN-810062
                        DECLARE cl_query_d1_ifx CURSOR FOR 
                                SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                        FOREACH cl_query_d1_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                            IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale,'','') THEN  #No.FUN-860089
                               RETURN 0 
                            END IF
                        END FOREACH
                  END IF
               END IF
           END FOR
      WHEN "T"
           ### Using Function to get data type and length ###
           LET l_tok_table = base.StringTokenizer.create(g_execmd_sql,",")
           WHILE l_tok_table.hasMoreTokens()
              #DISPLAY l_tok_table.nextToken()
              LET l_name = l_tok_table.nextToken()
              LET l_p = l_name.getIndexOf(".",1)
              LET l_p2 = l_name.getIndexOf(".",l_p+1)
              LET l_alias_name = l_name.subString(1,l_p-1)
              LET l_table_name = l_name.subString(l_p+1,l_p2-1)
              LET l_field_name = l_name.subString(l_p2+1,l_name.getLength())
              #No.FUN-810062 
              CASE cl_db_get_database_type()
                WHEN "MSV" 
                   LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'                
                OTHERWISE
                   LET l_dbname = 'ds'
              END CASE
              CALL cl_get_column_info(l_dbname,l_table_name,l_field_name)  
                  RETURNING l_datatype,l_length
              #END No.FUN-810062
              IF cl_null(l_datatype) THEN
                 CALL cl_err(l_field_name,'-2863',1)
                 RETURN 0
              END IF
              IF l_datatype  = 'date' THEN
                 LET l_length = 10
              END IF
 
              IF NOT p_zxd_feld(l_alias_name,l_datatype,l_length,'',l_table_name,l_field_name) THEN
                 RETURN 0
              END IF
           END WHILE
   END CASE  
   RETURN 1
END FUNCTION

FUNCTION p_zxd_feld(p_name,p_type,p_len,p_scale,p_table,p_field)    
DEFINE p_name     STRING
DEFINE p_type     STRING   
DEFINE p_len      STRING
DEFINE l_i        LIKE type_file.num5
DEFINE p_scale    LIKE type_file.num10 #欄位小數點 
DEFINE p_table    LIKE type_file.chr100
DEFINE p_field    LIKE type_file.chr100
 
    FOR l_i = 1 TO g_rec_b 
        IF g_xml[l_i].xml01 = p_name THEN
           CALl cl_err(p_name,'azz-300',0)
           LET g_rec_b = 0
           CALL g_xml.clear()
           RETURN 0
        END IF
    END FOR
    
    #No.FUN-860089 -- start --
    IF p_scale >= 0 THEN
       IF p_scale=0 THEN
          LET p_len = p_len.trim(),",0"
       ELSE
          LET p_len = p_len.trim(),",",p_scale USING '<<<<<<<<<<<'
       END IF
    END IF
 
    LET g_rec_b = g_rec_b + 1
    LET g_xml[g_rec_b].xml01 = p_name.trim()
    LET g_xml[g_rec_b].xml02 = p_type
    LET g_xml[g_rec_b].xml03 = p_len
    LET g_xml[g_rec_b].xml04 = p_table
    LET g_xml[g_rec_b].xml05 = p_field
    RETURN 1
END FUNCTION

#防呆措施
FUNCTION p_xglang_chkerror()
DEFINE l_str  STRING
DEFINE l_n,l_i  LIKE type_file.num5
DEFINE l_gds    RECORD LIKE gds_file.*

    #檢查幣別取位欄位不合理的情形
     DECLARE p_xglang_chkerr_cs1 CURSOR FOR
      SELECT * FROM gds_file
       WHERE gds13 IS NOT NULL
         AND gds00 = g_gdr.gdr00
       ORDER BY gds01
     FOREACH p_xglang_chkerr_cs1 INTO l_gds.*
         SELECT COUNT(*) INTO l_n
           FROM gds_file
          WHERE gds03 = l_gds.gds13
            AND gds00 = l_gds.gds00
         IF l_n = 0 THEN
            UPDATE gds_file SET gds13 = NULL
             WHERE gds00 = l_gds.gds00
               AND gds01 = l_gds.gds01
         END IF
     END FOREACH

    #檢查條件隱藏欄位不合理的情形
     DECLARE p_xglang_chkerr_cs3 CURSOR FOR
      SELECT * FROM gds_file
       WHERE gds31 IS NOT NULL
         AND gds00 = g_gdr.gdr00
       ORDER BY gds01
     FOREACH p_xglang_chkerr_cs3 INTO l_gds.*
         SELECT COUNT(*) INTO l_n
           FROM gds_file
          WHERE gds03 = l_gds.gds31
            AND gds00 = l_gds.gds00
         IF l_n = 0 THEN
            UPDATE gds_file SET gds31 = NULL
             WHERE gds00 = l_gds.gds00
               AND gds01 = l_gds.gds01
         END IF
     END FOREACH

    #檢查主鍵 (1.單頭不可當主鍵 2.只能有一個欄位當主鍵)
     SELECT COUNT(*) INTO l_n 
       FROM gds_file
      WHERE gds00 = g_gdr.gdr00
        AND gds16 = 'Y'
        AND gds12 = '2'
     IF l_n <> 1 THEN
        UPDATE gds_file SET gds16 = 'N'
         WHERE gds00 = g_gdr.gdr00
        DECLARE p_xglang_chkerr_cs2 CURSOR FOR
         SELECT * FROM gds_file
          WHERE gds00 = g_gdr.gdr00
            AND gds12 = '2'
          ORDER BY gds01
        FOREACH p_xglang_chkerr_cs2 INTO l_gds.*
            UPDATE gds_file SET gds16 = 'Y'
             WHERE gds00 = l_gds.gds00
               AND gds01 = l_gds.gds01
            EXIT FOREACH
        END FOREACH
     END IF

END FUNCTION

FUNCTION p_xglang_delall()

   SELECT COUNT(*) INTO g_cnt FROM gds_file
    WHERE gds00=g_gdr.gdr00
   IF g_cnt = 0 THEN                   
      CALL cl_err('','9044',1) #未輸入單身資料, 則取消單頭資料
      DELETE FROM gds_file WHERE gds00 = g_gdr.gdr00
   END IF

END FUNCTION

FUNCTION p_xglang_set_gds13_combo()
DEFINE l_gds03 LIKE gds_file.gds03
DEFINE l_combo_item LIKE type_file.chr1000

    DECLARE p_xglang_gds13_combo_cs CURSOR FOR
     SELECT UNIQUE gds03 FROM gds_file
      WHERE gds00 = g_gdr.gdr00
        AND gds32 = 'Y'
    LET l_combo_item = NULL
    FOREACH p_xglang_gds13_combo_cs INTO l_gds03
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_combo_item = l_combo_item CLIPPED,l_gds03 CLIPPED,","
    END FOREACH

    IF LENGTH(l_combo_item) > 1 THEN
       LET l_combo_item = l_combo_item[1,LENGTH(l_combo_item)-1]
    END IF
    CALL cl_set_combo_items('gds13',l_combo_item,'')

END FUNCTION

FUNCTION p_xglang_set_gds35_combo()
DEFINE l_gds03 LIKE gds_file.gds03
DEFINE l_combo_item LIKE type_file.chr1000

    DECLARE p_xglang_gds35_combo_cs CURSOR FOR
     SELECT UNIQUE gds03 FROM gds_file
      WHERE gds00 = g_gdr.gdr00
        AND gds32 = 'Y'
    LET l_combo_item = NULL
    FOREACH p_xglang_gds35_combo_cs INTO l_gds03
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_combo_item = l_combo_item CLIPPED,l_gds03 CLIPPED,","
    END FOREACH

    IF LENGTH(l_combo_item) > 1 THEN
       LET l_combo_item = l_combo_item[1,LENGTH(l_combo_item)-1]
    END IF
    CALL cl_set_combo_items('gds35',l_combo_item,'')

END FUNCTION

FUNCTION p_xglang_set_gds31_combo()
DEFINE l_gds03 LIKE gds_file.gds03
DEFINE l_combo_item LIKE type_file.chr1000

    DECLARE p_xglang_gds31_combo_cs CURSOR FOR
     SELECT UNIQUE gds03 FROM gds_file
      WHERE gds00 = g_gdr.gdr00
        AND gds34 = 'Y'
    LET l_combo_item = NULL
    FOREACH p_xglang_gds31_combo_cs INTO l_gds03
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_combo_item = l_combo_item CLIPPED,l_gds03 CLIPPED,","
    END FOREACH

    IF LENGTH(l_combo_item) > 1 THEN
       LET l_combo_item = l_combo_item[1,LENGTH(l_combo_item)-1]
    END IF
    CALL cl_set_combo_items('gds31',l_combo_item,'')

END FUNCTION

FUNCTION p_xglang_sub_show_column()

    CALL cl_set_comp_visible("Page1",TRUE)
    CALL cl_set_comp_visible("gds05,gds13,gds23,gds16,gds09,gds10,gds11,gds20",TRUE)

    IF g_gdr.gdr06 = '5' THEN
       CALL cl_set_comp_visible("Page1",FALSE) 
       CALL cl_set_comp_visible("gds05,gds13,gds23,gds16",FALSE)
    ELSE
       CALL cl_set_comp_visible("gds09,gds10,gds11,gds20",FALSE)
    END IF

END FUNCTION

FUNCTION p_xglang_sub_set_no_required_b()

    IF l_ac <=0 THEN RETURN END IF
    IF g_sub_gds[l_ac2].gds09='N' AND g_sub_gds[l_ac2].gds10='N' THEN
       CALL cl_set_comp_required('gds11,gds20',FALSE)
    END IF

END FUNCTION

FUNCTION p_xglang_sub_set_required_b()

    IF l_ac <=0 THEN RETURN END IF
    IF g_sub_gds[l_ac2].gds09='Y' OR g_sub_gds[l_ac].gds10='Y' THEN
       CALL cl_set_comp_required('gds11',TRUE)
    END IF

    IF g_sub_gds[l_ac2].gds09='N' AND g_sub_gds[l_ac].gds10='N' THEN
       CALL cl_set_comp_required('gds20',TRUE)
    END IF

END FUNCTION

FUNCTION p_xglang_sub_set_entry_b()

    IF l_ac2 <=0 THEN RETURN END IF
    CALL cl_set_comp_entry('gds09,gds10,gds11,gds20',TRUE)

END FUNCTION

FUNCTION p_xglang_sub_set_no_entry_b()

    IF l_ac2 <=0 THEN RETURN END IF
    IF g_gdr.gdr06 = '5' THEN
       IF g_sub_gds[l_ac2].gds09='Y' THEN 
          CALL cl_set_comp_entry('gds10',FALSE)
       END IF
       IF g_sub_gds[l_ac2].gds10='Y' THEN 
          CALL cl_set_comp_entry('gds09',FALSE)
       END IF
       IF g_sub_gds[l_ac2].gds09='N' AND g_sub_gds[l_ac2].gds10='N' THEN 
          CALL cl_set_comp_entry('gds11',FALSE)
       END IF
       IF g_sub_gds[l_ac2].gds09='Y' OR g_sub_gds[l_ac2].gds10='Y' THEN 
          CALL cl_set_comp_entry('gds20',FALSE)
       END IF
       IF g_sub_gds[l_ac2].gds14='N' THEN #不顯示時也不可維護
          CALL cl_set_comp_entry('gds09,gds10,gds11,gds20',FALSE)
       END IF
    END IF

END FUNCTION

#FUN-D20057 ---(S)
FUNCTION p_xglang_gcw()
   DEFINE ls_tmp           STRING
   DEFINE l_i,l_x,l_y      LIKE type_file.num5
   DEFINE l_gcw   RECORD
                    gcw01         LIKE gcw_file.gcw01,      #程式代號
                    gcw02         LIKE gcw_file.gcw02,      #樣板代號
                    gcw03         LIKE gcw_file.gcw03,      #權限類別
                    gcw04         LIKE gcw_file.gcw04,      #使用者
                    gcw05         LIKE gcw_file.gcw05,      #報表檔案命名第一段
                    gcw06         LIKE gcw_file.gcw06,      #報表檔案命名第二段
                    gcw07         LIKE gcw_file.gcw07,      #報表檔案命名第三段
                    gcw08         LIKE gcw_file.gcw08,      #報表檔案命名第四段
                    gcw09         LIKE gcw_file.gcw09,      #報表檔案命名第五段
                    gcw10         LIKE gcw_file.gcw10,      #報表檔案命名第六段
                    gcw11         LIKE gcw_file.gcw11,      #重複時覆寫
                    gcw12         LIKE gcw_file.gcw12       #行業別
                  END RECORD

   IF cl_null(g_gdr.gdr01) or cl_null(g_gdr.gdr02) or cl_null(g_gdr.gdr03) or cl_null(g_gdr.gdr05) or cl_null(g_gdr.gdr09) THEN
      RETURN
   END IF

   OPEN WINDOW p_xglang_gcw_w AT 10,03 WITH FORM "azz/42f/p_xglang_gcw"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("p_xglang_gcw")

   CALL cl_set_comp_entry("gcw11",TRUE)
   CALL cl_set_combo_industry("gdr09")   #行業別

   WHILE TRUE
      DECLARE p_xglang_gcw_c CURSOR FOR
           SELECT gcw01,gcw02,gcw03,gcw04,gcw05,gcw06,gcw07,gcw08,gcw09,gcw10,gcw11,gcw12
             FROM gcw_file
            WHERE gcw01 = g_gdr.gdr01
              AND gcw02 = g_gdr.gdr02
              AND gcw03 = g_gdr.gdr05
              AND gcw04 = g_gdr.gdr04
              AND gcw12 = g_gdr.gdr09

      LET l_i = 0
      FOREACH p_xglang_gcw_c INTO l_gcw.*
         LET l_i = l_i + 1
      END FOREACH

      IF l_i = 0 THEN
         LET l_gcw.gcw11 = "Y"
      END IF

      DISPLAY g_gdr.gdr01,g_gdr.gdr02,g_gdr.gdr05,g_gdr.gdr04,g_gdr.gdr09,l_gcw.gcw11,g_gaz03,g_zx02,g_zw02
         TO gdr01,gdr02,gdr05,gdr04,gdr09,gcw11,gaz03,zx02,zw02

      INPUT BY NAME l_gcw.gcw05,l_gcw.gcw06,l_gcw.gcw07,l_gcw.gcw08,l_gcw.gcw09,l_gcw.gcw10,l_gcw.gcw11 WITHOUT DEFAULTS
         ON CHANGE gcw05
            #檢查檔名段落是否重覆
            IF l_gcw.gcw05=l_gcw.gcw06 OR l_gcw.gcw05=l_gcw.gcw07 OR l_gcw.gcw05=l_gcw.gcw08 OR l_gcw.gcw05=l_gcw.gcw09 OR l_gcw.gcw05=l_gcw.gcw10 THEN
              CALL cl_err('1','azz1000',1)
            END IF

         ON CHANGE gcw06
            #檢查檔名段落是否重覆
            IF l_gcw.gcw06=l_gcw.gcw05 OR l_gcw.gcw06=l_gcw.gcw07 OR l_gcw.gcw06=l_gcw.gcw08 OR l_gcw.gcw06=l_gcw.gcw09 OR l_gcw.gcw06=l_gcw.gcw10 THEN
              CALL cl_err('2','azz1000',1)
            END IF

         ON CHANGE gcw07
            #檢查檔名段落是否重覆
            IF l_gcw.gcw07=l_gcw.gcw05 OR l_gcw.gcw07=l_gcw.gcw06 OR l_gcw.gcw07=l_gcw.gcw08 OR l_gcw.gcw07=l_gcw.gcw09 OR l_gcw.gcw07=l_gcw.gcw10 THEN
              CALL cl_err('3','azz1000',1)
            END IF
            
         ON CHANGE gcw08
            #檢查檔名段落是否重覆
            IF l_gcw.gcw08=l_gcw.gcw05 OR l_gcw.gcw08=l_gcw.gcw06 OR l_gcw.gcw08=l_gcw.gcw07 OR l_gcw.gcw08=l_gcw.gcw09 OR l_gcw.gcw08=l_gcw.gcw10 THEN
              CALL cl_err('4','azz1000',1)
            END IF

         ON CHANGE gcw09
            #檢查檔名段落是否重覆
            IF l_gcw.gcw09=l_gcw.gcw05 OR l_gcw.gcw09=l_gcw.gcw06 OR l_gcw.gcw09=l_gcw.gcw07 OR l_gcw.gcw09=l_gcw.gcw08 OR l_gcw.gcw09=l_gcw.gcw10 THEN
              CALL cl_err('5','azz1000',1)
            END IF

         ON CHANGE gcw10
            #檢查檔名段落是否重覆
            IF l_gcw.gcw10=l_gcw.gcw05 OR l_gcw.gcw10=l_gcw.gcw06 OR l_gcw.gcw10=l_gcw.gcw07 OR l_gcw.gcw10=l_gcw.gcw08 OR l_gcw.gcw10=l_gcw.gcw09 THEN
              CALL cl_err('6','azz1000',1)
            END IF

      END INPUT

      IF cl_null(l_gcw.gcw11) THEN
         LET l_gcw.gcw11 = "N"
      END IF

      IF INT_FLAG THEN   #按"取消"
         LET INT_FLAG = 0
         CLOSE WINDOW p_xglang_gcw_w
         RETURN
      ELSE
         #新增
         IF l_i = 0 THEN
            #設主鍵與zaw相同
            LET l_gcw.gcw01 = g_gdr.gdr01   #程式代號
            LET l_gcw.gcw02 = g_gdr.gdr02   #樣板代號
            LET l_gcw.gcw03 = g_gdr.gdr05   #權限類別
            LET l_gcw.gcw04 = g_gdr.gdr04   #使用者
            LET l_gcw.gcw12 = g_gdr.gdr09   #行業別

            INSERT INTO gcw_file (gcw01,gcw02,gcw03,gcw04,gcw05,gcw06,gcw07,gcw08,gcw09,gcw10,gcw11,gcw12)
               VALUES (l_gcw.gcw01,l_gcw.gcw02,l_gcw.gcw03,l_gcw.gcw04,l_gcw.gcw05,l_gcw.gcw06,l_gcw.gcw07,l_gcw.gcw08,l_gcw.gcw09,l_gcw.gcw10,l_gcw.gcw11,l_gcw.gcw12)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gcw_file",l_gcw.gcw01,l_gcw.gcw02,SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
         END IF

         #修改
         IF l_i > 0 THEN
            UPDATE gcw_file
               SET gcw05 = l_gcw.gcw05,
                   gcw06 = l_gcw.gcw06,
                   gcw07 = l_gcw.gcw07,
                   gcw08 = l_gcw.gcw08,
                   gcw09 = l_gcw.gcw09,
                   gcw10 = l_gcw.gcw10,
                   gcw11 = l_gcw.gcw11
               WHERE gcw01 = l_gcw.gcw01
                 AND gcw02 = l_gcw.gcw02
                 AND gcw03 = l_gcw.gcw03
                 AND gcw04 = l_gcw.gcw04
                 AND gcw12 = l_gcw.gcw12

            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gcw_file",l_gcw.gcw01,l_gcw.gcw02,SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
         END IF

      END IF
      EXIT WHILE
   END WHILE

   CLOSE WINDOW p_xglang_gcw_w
   
END FUNCTION
#FUN-D20057 ---(E)

#FUN-D30056 ---(S)
FUNCTION p_xglang_chkerror_gds36() 
DEFINE l_err LIKE type_file.chr1
DEFINE l_gds03 LIKE gds_file.gds03
DEFINE l_gds36 LIKE gds_file.gds36
DEFINE l_n     LIKE type_file.num5

    DECLARE p_xglang_gds36_cs CURSOR FOR
     SELECT gds03,gds36 FROM gds_file
      WHERE gds00 = g_gdr.gdr00
        AND gds36 IS NOT NULL
      ORDER BY gds36
    LET l_n = 1
    LET l_err = 'N'
    FOREACH p_xglang_gds36_cs INTO l_gds03,l_gds36
        IF l_gds36 <> l_n THEN
           CALL cl_err(l_gds03,'azz1315',1)
           LET l_err = 'Y'
           EXIT FOREACH
        END IF
        LET l_n = l_n + 1
    END FOREACH

    IF l_err = 'Y' THEN
       RETURN TRUE
    ELSE
       RETURN FALSE
    END IF

END FUNCTION
#FUN-D30056 ---(E)

#FUN-D30056 取得習慣群組/排序的欄位描述
FUNCTION p_xglang_show_habit(p_columns,p_code) #FUN-D30056
DEFINE p_columns  LIKE gdr_file.gdr16
DEFINE p_code     LIKE type_file.chr1
DEFINE l_strtok   base.StringTokenizer
DEFINE l_desc     STRING
DEFINE l_str      LIKE gds_file.gds04
DEFINE l_i        LIKE type_file.num5
DEFINE l_col      LIKE gds_file.gds03

    IF cl_null(p_columns) THEN
       RETURN
    ELSE
       LET p_columns = DOWNSHIFT(p_columns)
    END IF   

    LET l_strtok = base.StringTokenizer.create(p_columns,",")
    IF l_strtok IS NOT NULL THEN
        LET l_i = 1
        WHILE (l_strtok.hasMoreTokens())
            LET l_col = l_strtok.nextToken()
            SELECT gds04 INTO l_str FROM gds_file
             WHERE gds00 = g_gdr.gdr00 AND gds03 = l_col
            IF cl_null(l_str) THEN LET l_str = l_col END IF
            IF l_i = 1 THEN
               LET l_desc = l_str
            ELSE
               LET l_desc = l_desc CLIPPED,",",l_str
            END IF
            LET l_i = l_i + 1
        END WHILE
    END IF

    CASE p_code
      WHEN "1" DISPLAY l_desc TO gdr16
      WHEN "2" DISPLAY l_desc TO gdr17
    END CASE
END FUNCTION

#FUN-D40059---start
FUNCTION p_xglang_clear_gdr16()

    IF cl_null(g_gdr.gdr00) OR g_gdr.gdr00 = 0 THEN
       CALL cl_err('',-400,1)
       RETURN 
    END IF
    IF NOT cl_confirm('azz1318') THEN RETURN END IF

    BEGIN WORK
    UPDATE gdr_file SET gdr16=NULL,gdr17=NULL,gdr18=NULL
     WHERE gdr00 = g_gdr.gdr00
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('',9050,1)
       ROLLBACK WORK
    ELSE
       COMMIT WORK
       CALL p_xglang_show()
    END IF

END FUNCTION
#FUN-D40059---end
