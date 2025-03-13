# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aici020.4gl
# Descriptions...: ICD料件制程資料維護作業
# Date & Author..: 07/11/15 By Hellen No.FUN-7B0018
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.CHI-920030 09/02/09 By jan  將 單頭 icu02拿掉以下功能:    1.開窗功能 2.AFTER FIELD檢查 3.BUTTEDIT=>EDIT
# Modify.........: No.TQC-920032 09/02/13 By jan  1.mark 掉i020_delall() & i020_g_b() 2.mark掉欄位檢查有檢查ecb_file的部分
# Modify.........: No.FUN-920172 09/02/26 By jan 當 ica040='N' 時，則卡不可執行此程式
# Modify.........: No:EXT-940148 09/06/01 By jan 移除AFTER FIELD icv05的key值重復檢查 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.MOD-B30519 11/03/15 By jan aici020自動產生料號及BOM無法產生
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改 
# Modify.........: No.FUN-BC0106 12/02/01 By jason 單身新增icv07預設分群碼欄位
# Modify.........: No.FUN-C20100 12/02/20 By jason 入口由aimi100_icd進入時,若尚未建立aici020資料時,新增單頭資料,非NEW_CODE申請單時"ICD料號及BOM產生"按鈕不顯示
# Modify.........: No.TQC-C30138 12/03/08 By bart 1.手動輸入icv04值,錯誤訊息改為aic-017
#                                                 2.icv04開窗改為q_ecd_icd
# Modify.........: No.MOD-C30233 12/03/10 By bart   (1)FUN-AA0059所加程式段mark掉
#                                                   (2)_i()段與_copy()段的AFTER FIELD icu01,均需檢查輸入的料號是否存在aimi100_icd或aimi150_icd裡(條件只需判斷存不存在,不需卡料號已確認)
#                                                   (3)新增完icu_file後,將icu02的值回寫到aimi100_icd/aimi150的ima94/imaa94
# Modify.........: No.FUN-C30082 12/03/29 By bart 新增品名、規格、斷階料號三個欄位
# Modify.........: No.FUN-C40011 12/05/15 By bart imaa94回寫錯誤
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C50145 12/05/30 By bart 修改回寫製程編號
# Modify.........: No.TQC-C60183 12/06/25 By bart 斷階料號的輸入要允許它輸入存在aimi150的料號
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-CA0028 12/10/12 By Elise icv05='2'時,icv07卡為必輸欄位
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_icu               RECORD LIKE icu_file.*,       #料件制程資料(單頭)
       g_icu_t             RECORD LIKE icu_file.*,       #料件制程資料(舊值)
       g_icu_o             RECORD LIKE icu_file.*,       #料件制程資料(舊值)
       g_icu01_t           LIKE icu_file.icu01,          #母體料號(舊值)
       g_icu02_t           LIKE icu_file.icu02,          #制程編號(舊值)
       g_icv               DYNAMIC ARRAY OF RECORD       #料件制程資料(單身) 程式變數(Program Variables)
           icv03           LIKE icv_file.icv03,          #制程序
           icv04           LIKE icv_file.icv04,          #作業編號 
           ecd02           LIKE ecd_file.ecd02,          #作業名稱 
           icv05           LIKE icv_file.icv05,          #制程特性
           icv06           LIKE icv_file.icv06,          #編碼原則
           icv07           LIKE icv_file.icv07,          #預設分群碼   #FUN-BC0106
           icv08           LIKE icv_file.icv08,          #品名   #FUN-C30082
           icv09           LIKE icv_file.icv09,          #規格   #FUN-C30082
           icv10           LIKE icv_file.icv10           #段階料號   #FUN-C30082
                           END RECORD,
       g_icv_t             RECORD                        #程式變數 (舊值)
           icv03           LIKE icv_file.icv03,          #制程序
           icv04           LIKE icv_file.icv04,          #作業編號 
           ecd02           LIKE ecd_file.ecd02,          #作業名稱 
           icv05           LIKE icv_file.icv05,          #制程特性
           icv06           LIKE icv_file.icv06,          #編碼原則
           icv07           LIKE icv_file.icv07,          #預設分群碼   #FUN-BC0106
           icv08           LIKE icv_file.icv08,          #品名   #FUN-C30082
           icv09           LIKE icv_file.icv09,          #規格   #FUN-C30082
           icv10           LIKE icv_file.icv10           #段階料號   #FUN-C30082
                           END RECORD,
       g_icv_o             RECORD                        #程式變數 (舊值)
           icv03           LIKE icv_file.icv03,          #制程序
           icv04           LIKE icv_file.icv04,          #作業編號 
           ecd02           LIKE ecd_file.ecd02,          #作業名稱 
           icv05           LIKE icv_file.icv05,          #制程特性
           icv06           LIKE icv_file.icv06,          #編碼原則
           icv07           LIKE icv_file.icv07,          #預設分群碼   #FUN-BC0106
           icv08           LIKE icv_file.icv08,          #品名   #FUN-C30082
           icv09           LIKE icv_file.icv09,          #規格   #FUN-C30082
           icv10           LIKE icv_file.icv10           #段階料號   #FUN-C30082
                           END RECORD,
       g_sql               STRING,                       #CURSOR暫存
       g_wc                STRING,                       #單頭CONSTRUCT結果
       g_wc2               STRING,                       #單身CONSTRUCT結果
       g_rec_b             LIKE type_file.num5,          #單身筆數
       l_ac                LIKE type_file.num5           #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING                        #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5           #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10          #總筆數
DEFINE g_jump              LIKE type_file.num10          #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5           #是否開啟指定筆視窗
DEFINE g_argv1             LIKE icu_file.icu01
DEFINE g_argv2             LIKE icx_file.icx01     #MOD-B30519
DEFINE g_str               STRING
DEFINE g_table             STRING
 
MAIN
   DEFINE l_ica40          LIKE ica_file.ica40            #FUN-920172 
 
   OPTIONS                                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                       #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)   #MOD-B30519
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('icd') THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF
 
   #FUN-920172--BEGIN--
   SELECT ica40 INTO l_ica40 FROM ica_file WHERE ica00 = '0' 
   IF l_ica40 = 'N' THEN
      CALL cl_err('','aic-911',1)
      EXIT PROGRAM
   END IF
   #FUN-920172--END--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM icu_file ",
                      " WHERE icu01 = ? AND icu02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i020_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i020_w WITH FORM "aic/42f/aici020"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   
   LET g_pdate = g_today

   #FUN-C20100 --START--
   IF NOT cl_null(g_argv1) THEN
      IF NOT i020_ins_icu() THEN
      
      END IF 
   END IF 
   IF cl_null(g_argv2) THEN
      CALL cl_set_act_visible("icd_bom", FALSE)
   END IF   
   #FUN-C20100 --START-- 
   
 
   IF NOT cl_null(g_argv1) THEN
      CALL i020_q()
   END IF
 
   CALL i020_menu()
   CLOSE WINDOW i020_w                                   #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i020_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_icv.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " icu01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_icu.* TO NULL
      CONSTRUCT BY NAME g_wc ON icu01,icu02,icu03,icu04,icu05,
                                icu06,icu07,icu08,icu09,icu10,
                                icu11,icu12,icu13
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(icu01)                       #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_imaicd_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icu01
                  NEXT FIELD icu01
               #CHI-920030--BEGIN--
               #WHEN INFIELD(icu02)                       #
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state = 'c'
               #   LET g_qryparam.form ="q_ecu"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO icu02
               #   NEXT FIELD icu02
               #CHI-920030--END--
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                                   #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND icuuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                                   #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND icugrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN                      #群組權限
   #      LET g_wc = g_wc clipped," AND icugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icuuser', 'icugrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON icv03,icv04,icv05,icv06,icv07   #螢幕上取單身條件 #FUN-BC0106 add icv07
                         ,icv08,icv09,icv10   #FUN-C30082
           FROM s_icv[1].icv03,s_icv[1].icv04,
                s_icv[1].icv05,s_icv[1].icv06,
                s_icv[1].icv07,   #FUN-BC0106
                s_icv[1].icv08,s_icv[1].icv09,s_icv[1].icv10   #FUN-C30082
                   
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(icv04)                       #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                 #LET g_qryparam.form ="q_ecb_01"   #TQC-920032
                  #LET g_qryparam.form ="q_ecd02_icd"#TQC-920032  #TQC-C30138 mark
                  LET g_qryparam.form ="q_ecd_icd" #TQC-C30138
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icv04
                  NEXT FIELD icv04
               WHEN INFIELD(icv06)                       #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_icr_icd01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icv06
                  NEXT FIELD icv06
               #FUN-BC0106 --START--
               WHEN INFIELD(icv07)    #預設分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form     = "q_imz"                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icv07
                  NEXT FIELD icv07
               #FUN-BC0106 --END--   
               OTHERWISE EXIT CASE   
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   IF g_wc2 = " 1=1" THEN                                #若單身未輸入條件
      LET g_sql = "SELECT icu01,icu02 FROM icu_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY icu01"
   ELSE                                                  #若單身有輸入條件
      LET g_sql = "SELECT UNIQUE icu_file.icu01,icu_file.icu02 ",
                  "  FROM icu_file,icv_file ",
                  " WHERE icu01 = icv01 ",
                  "   AND icu02 = icv02 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY icu01"
   END IF
 
   PREPARE i020_prepare FROM g_sql
   DECLARE i020_cs                                       #SCROLL CURSOR
    SCROLL CURSOR WITH HOLD FOR i020_prepare
 
   IF g_wc2 = " 1=1" THEN                                #取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM icu_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT icu01,icu02) ",
                "  FROM icu_file,icv_file ",
                " WHERE icu01 = icv01 ",
                "   AND icu02 = icv02 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i020_precount FROM g_sql
   DECLARE i020_count CURSOR FOR i020_precount
 
END FUNCTION
 
FUNCTION i020_menu()
 
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i020_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i020_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i020_u()
            END IF
 
#        WHEN "invalid"
#           IF cl_chk_act_auth() THEN
#              CALL i020_x()
#           END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i020_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i020_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icv),'','')
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_icu.icu01 IS NOT NULL AND
                    g_icu.icu02 IS NOT NULL THEN
                 LET g_doc.column1 = "icu01"
                 LET g_doc.column2 = "icu02"
                 LET g_doc.value1 = g_icu.icu01
                 LET g_doc.value2 = g_icu.icu02
                 CALL cl_doc()
               END IF
         END IF
 
         WHEN "icd_bom"                    #BOM產生&下階料產生 
            IF g_argv1 IS NULL OR cl_null(g_argv2) THEN        #此ACTION只有在aict030串接執行時才可用  #MOD-B30519
               CALL cl_err('','aic-958',1)
            END IF
            IF cl_chk_act_auth() THEN
              #CALL s_aic_bom(g_icu.icu01,g_icu.icu02,g_argv1)   #MOD-B30519
               CALL s_aic_bom(g_icu.icu01,g_icu.icu02,g_argv2)   #MOD-B30519
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_icv TO s_icv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i020_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
#     ON ACTION invalid
#        LET g_action_choice="invalid"
#        EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
{
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
         END IF 
}
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls          
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION icd_bom
         LET g_action_choice="icd_bom"
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
{
FUNCTION i020_bp_refresh()
  DISPLAY ARRAY g_icv TO s_icv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
}
 
FUNCTION i020_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_icv.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_icu.* LIKE icu_file.*                     #DEFAULT 設定
   LET g_icu01_t = NULL
   LET g_icu02_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_icu_t.* = g_icu.*
   LET g_icu_o.* = g_icu.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      IF NOT cl_null(g_argv1) THEN
         LET g_icu.icu01 = g_argv1
      END IF
#     LET g_icu.icuuser=g_user
#     LET g_icu.icugrup=g_grup
#     LET g_icu.icudate=g_today
#     LET g_icu.icuacti='Y'                               #資料有效
      LET g_icu.icu03 = "N"
      LET g_icu.icu05 = "1"
      LET g_icu.icu10 = "1"
 
      CALL i020_i("a")                                    #輸入單頭
 
      IF INT_FLAG THEN                                    #使用者不玩了
         INITIALIZE g_icu.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_icu.icu01) THEN                        #KEY不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
       
#     CALL s_auto_assign_no("apm",g_icu.icu01,g_icu.icu06,"","icu_file","icu01","","","") RETURNING li_result,g_icu.icu01
#     IF (NOT li_result) THEN
#        CONTINUE WHILE
#     END IF
#     DISPLAY BY NAME g_icu.icu01
 
      INSERT INTO icu_file VALUES (g_icu.*)
      IF SQLCA.sqlcode THEN                               #置入資料庫不成功
         CALL cl_err3("ins","icu_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN-B80083 ADD
         ROLLBACK WORK
        # CALL cl_err3("ins","icu_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN-B80083 MARK
         CONTINUE WHILE
      ELSE
         #FUN-C50145---begin
         UPDATE ima_file SET ima94 = g_icu.icu02 
          WHERE ima1010 <> '1'  
            AND ima01 IN (SELECT imaicd00 FROM imaicd_file WHERE imaicd01 = g_icu.icu01)  
         IF SQLCA.sqlcode THEN                           
            CALL cl_err3("upd","ima_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CONTINUE WHILE
         END IF 
         UPDATE imaa_file SET imaa94 = g_icu.icu02 WHERE imaaicd01 = g_icu.icu01 AND imaa1010 != '2'
         IF SQLCA.sqlcode THEN                           
            CALL cl_err3("upd","imaa_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CONTINUE WHILE
         END IF 
         #FUN-C50145---end
         COMMIT WORK
         CALL cl_flow_notify(g_icu.icu01,'I')
      END IF
 
#     SELECT ROWID INTO g_icu_rowid FROM icu_file
#      WHERE icu01 = g_icu.icu01
 
      LET g_icu01_t = g_icu.icu01                         #保留舊值
      LET g_icu02_t = g_icu.icu02                         #保留舊值
      LET g_icu_t.* = g_icu.*
      LET g_icu_o.* = g_icu.*
      CALL g_icv.clear()
 
      LET g_rec_b = 0
      CALL i020_b()                                       #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i020_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_icu.icu01 IS NULL OR
      g_icu.icu02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icu.* FROM icu_file
    WHERE icu01 = g_icu.icu01
      AND icu02 = g_icu.icu02
 
#  IF g_icu.icuacti ='N' THEN                             #檢查資料是否為無效
#     CALL cl_err(g_icu.icu01,'mfg1000',0)
#     RETURN
#  END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_icu01_t = g_icu.icu01
   LET g_icu02_t = g_icu.icu02
   
   BEGIN WORK
 
   OPEN i020_cl USING g_icu.icu01,g_icu.icu02
   IF STATUS THEN
      CALL cl_err("OPEN i020_cl:", STATUS, 1)
      CLOSE i020_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i020_cl INTO g_icu.*                             #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_icu.icu01,SQLCA.sqlcode,0)           #資料被他人LOCK
       CLOSE i020_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i020_show()
 
   WHILE TRUE
      LET g_icu01_t = g_icu.icu01
      LET g_icu02_t = g_icu.icu02
      LET g_icu_o.* = g_icu.*
#     LET g_icu.icumodu=g_user
#     LET g_icu.icudate=g_today
 
      CALL i020_i("u")                                    #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_icu.*=g_icu_t.*
         CALL i020_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_icu.icu01 != g_icu01_t OR                      #更改單號
         g_icu.icu02 != g_icu02_t THEN
         UPDATE icv_file SET icv01 = g_icu.icu01,
                             icv02 = g_icu.icu02
          WHERE icv01 = g_icu01_t
            AND icv02 = g_icu02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","icv_file",g_icu01_t,g_icu02_t,SQLCA.sqlcode,"","icv",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE icu_file SET icu_file.* = g_icu.*
       WHERE icu01 = g_icu01_t
         AND icu02 = g_icu02_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","icu_file",g_icu01_t,g_icu02_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF

      #FUN-C50145---begin
      UPDATE ima_file SET ima94 = g_icu.icu02 
       WHERE ima1010 <> '1'  
         AND ima01 IN (SELECT imaicd00 FROM imaicd_file WHERE imaicd01 = g_icu.icu01)  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ima_file",g_icu01_t,g_icu02_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      UPDATE imaa_file SET imaa94 = g_icu.icu02 WHERE imaaicd01 = g_icu.icu01 AND imaa1010 != '2'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","imaa_file",g_icu01_t,g_icu02_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      #FUN-C50145---end
      
      EXIT WHILE
   END WHILE
 
   CLOSE i020_cl
   COMMIT WORK
   CALL cl_flow_notify(g_icu.icu01,'U')
 
   CALL i020_b_fill("1=1")
#  CALL i020_bp_refresh()
 
END FUNCTION
 
FUNCTION i020_i(p_cmd)
DEFINE l_n       LIKE type_file.num5
DEFINE p_cmd     LIKE type_file.chr1                      #a:輸入 u:更改
DEFINE li_result LIKE type_file.num5
DEFINE l_cnt1    LIKE type_file.num5    #MOD-C30233
DEFINE l_cnt2    LIKE type_file.num5    #MOD-C30233
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_icu.icu01,g_icu.icu02,
                   g_icu.icu03,g_icu.icu04,
                   g_icu.icu05,g_icu.icu06,
                   g_icu.icu07,g_icu.icu08,
                   g_icu.icu09,g_icu.icu10,
                   g_icu.icu11,g_icu.icu12,
                   g_icu.icu13
 
   CALL cl_set_head_visible("","YES")
   IF g_icu.icu03 = 'N' THEN 
      CALL cl_set_comp_visible("Page2",FALSE)
   ELSE
      CALL cl_set_comp_visible("Page2",TRUE)
   END IF
 
   INPUT BY NAME g_icu.icu01,g_icu.icu02,g_icu.icu03,
                 g_icu.icu04,g_icu.icu05,g_icu.icu06,
                 g_icu.icu07,g_icu.icu08,g_icu.icu09,
                 g_icu.icu10,g_icu.icu11,g_icu.icu12,
                 g_icu.icu13
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i020_set_entry(p_cmd)
         CALL i020_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#        CALL cl_set_docno_format("icu01")
 
      AFTER FIELD icu01
         IF NOT cl_null(g_icu.icu01) THEN
           #MOD-C30233---begin mark
           #FUN-AA0059 ----------------add start----------------
           # IF NOT s_chk_item_no(g_icu.icu01,'') THEN
           #    CALL cl_err('',g_errno,1)
           #    LET g_icu.icu01 = g_icu01_t
           #    DISPLAY BY NAME g_icu.icu01
           #    NEXT FIELD icu01
           # END IF
           #FUN-AA0059 ----------------add end-----------------
           LET l_cnt1 = 0
           LET l_cnt2 = 0
           SELECT count(*) INTO l_cnt1 FROM ima_file WHERE ima01 = g_icu.icu01
           IF l_cnt1 = 0 THEN
              SELECT count(*) INTO l_cnt2 FROM imaa_file WHERE imaa01 = g_icu.icu01
           END IF 
           IF l_cnt1 = 0 AND l_cnt2 = 0 THEN
              CALL cl_err('','mfg3403',1)
              NEXT FIELD icu01
           END IF 
           #MOD-C30233---end
            IF (p_cmd = 'a') OR (p_cmd = 'u' AND 
               g_icu.icu01 != g_icu01_t) THEN
               SELECT COUNT(*) INTO l_n 
                 FROM icu_file
                WHERE icu01 = g_icu.icu01
                  AND icu02 = g_icu.icu02  #TQC-920032 拿掉MARK符號#允許料件可以重復
               IF l_n > 0 THEN                            #單據編號重複
                  CALL cl_err(g_icu.icu01,-239,0)
                  LET g_icu.icu01 = g_icu01_t
                  DISPLAY BY NAME g_icu.icu01
                  NEXT FIELD icu01
               END IF
               IF l_cnt1 > 0 THEN  #MOD-C30233
                  CALL i020_icu01(p_cmd)
               END IF              #MOD-C30233
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_icu.icu01,g_errno,0)
                  LET g_icu.icu01 = g_icu01_t
                  DISPLAY BY NAME g_icu.icu01
                  NEXT FIELD icu01
               END IF
            END IF
         END IF
 
      BEFORE FIELD icu02
         IF cl_null(g_icu.icu01) THEN
            CALL cl_err(g_icu.icu02,'aic-997',1)
            NEXT FIELD icu01
         END IF
         
      AFTER FIELD icu02
#        IF NOT cl_null(g_icu.icu02) AND
#           NOT cl_null(g_icu.icu01) THEN
#           IF (p_cmd = 'a') OR (p_cmd = 'u' AND 
#              g_icu.icu02 != g_icu02_t) THEN
#              SELECT COUNT(*) INTO l_n 
#                FROM icu_file
#               WHERE icu01 = g_icu.icu01
#                 AND icu02 = g_icu.icu02
#              IF l_n > 0 THEN                            #單據編號重複
#                 CALL cl_err(g_icu.icu01,-239,0)
#                 LET g_icu.icu02 = g_icu02_t
#                 DISPLAY BY NAME g_icu.icu02
#                 NEXT FIELD icu02
#              END IF
#CHI-920030--BEGIN--MARK--
#        IF NOT cl_null(g_icu.icu02) THEN
#           CALL i020_icu02()
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_icu.icu02,g_errno,0)
#              LET g_icu.icu02 = g_icu02_t
#              DISPLAY BY NAME g_icu.icu02
#              NEXT FIELD icu02
#           END IF
#        END IF   
#CHI-920030--END--MARK--
 
      AFTER FIELD icu03
         IF NOT cl_null(g_icu.icu03) THEN
            IF g_icu.icu03 = "Y" THEN
               CALL cl_set_comp_visible("Page2",TRUE)
            ELSE
               CALL cl_set_comp_visible("Page2",FALSE)
            END IF
         END IF
      
      AFTER FIELD icu05
         IF NOT cl_null(g_icu.icu04) THEN
            IF cl_null(g_icu.icu05) THEN
               CALL cl_err(g_icu.icu05,'aic-013',1)
               NEXT FIELD icu05
            END IF
         END IF
         
      AFTER FIELD icu06
         IF NOT cl_null(g_icu.icu06) THEN
            IF NOT cl_null(g_icu.icu07) THEN
               IF NOT i020_num_chk(g_icu.icu06) THEN
                  NEXT FIELD icu06
               END IF
               IF g_icu.icu06 > g_icu.icu07 THEN
                  CALL cl_err(g_icu.icu06,'aic-014',1)
                  NEXT FIELD icu06
               END IF
            END IF        
         END IF
         
      AFTER FIELD icu07
         IF NOT cl_null(g_icu.icu07) THEN
            IF NOT cl_null(g_icu.icu06) THEN
               IF NOT i020_num_chk(g_icu.icu07) THEN
                  NEXT FIELD icu07
               END IF
               IF g_icu.icu07 < g_icu.icu06 THEN
                  CALL cl_err(g_icu.icu07,'aic-015',1)
                  NEXT FIELD icu07
               END IF
            END IF        
         END IF
         
      AFTER FIELD icu10
         IF NOT cl_null(g_icu.icu09) THEN
            IF cl_null(g_icu.icu10) THEN
               CALL cl_err(g_icu.icu10,'aic-013',1)
               NEXT FIELD icu10
            END IF
         END IF
         
      AFTER FIELD icu11
         IF NOT cl_null(g_icu.icu11) THEN
            IF NOT cl_null(g_icu.icu12) THEN
               IF NOT i020_num_chk(g_icu.icu11) THEN
                  NEXT FIELD icu11
               END IF
               IF g_icu.icu11 > g_icu.icu12 THEN
                  CALL cl_err(g_icu.icu11,'aic-014',1)
                  NEXT FIELD icu11
               END IF
            END IF        
         END IF
         
      AFTER FIELD icu12
         IF NOT cl_null(g_icu.icu12) THEN
            IF NOT cl_null(g_icu.icu11) THEN
               IF NOT i020_num_chk(g_icu.icu12) THEN
                  NEXT FIELD icu12
               END IF
               IF g_icu.icu12 < g_icu.icu11 THEN
                  CALL cl_err(g_icu.icu12,'aic-015',1)
                  NEXT FIELD icu12
               END IF
            END IF        
         END IF         
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icu01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_imaicd_1"
               LET g_qryparam.default1 = g_icu.icu01
               CALL cl_create_qry() RETURNING g_icu.icu01
               DISPLAY BY NAME g_icu.icu01
               NEXT FIELD icu01
            #CHI-920030--BEGIN--MARK--
           #WHEN INFIELD(icu02)
           #    CALL cl_init_qry_var()
           #    LET g_qryparam.form ="q_ecu"
           #    LET g_qryparam.default1 = g_icu.icu02
           #    LET g_qryparam.arg1 = g_icu.icu01
           #    CALL cl_create_qry() RETURNING g_icu.icu02
           #    DISPLAY BY NAME g_icu.icu02
           #    NEXT FIELD icu02
           #CHI-920030--END--MARK--
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION i020_num_chk(p_icu06)
DEFINE p_icu06  LIKE icu_file.icu06
DEFINE l_length LIKE type_file.num5
DEFINE i        LIKE type_file.num5
 
   IF NOT cl_null(p_icu06) THEN
      LET l_length = LENGTH(p_icu06)
      FOR i = 1 TO l_length
         IF p_icu06[i,i] NOT MATCHES '[0123456789]' THEN
            CALL cl_err('','aic-910',0)
            RETURN FALSE
            EXIT FOR
         END IF
      END FOR
   END IF
   RETURN TRUE
   
END FUNCTION
 
FUNCTION i020_icu01(p_cmd)
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima021  LIKE ima_file.ima021
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE p_cmd     LIKE type_file.chr1
   
   LET g_errno = " "
   
   SELECT DISTINCT ima02,ima021,imaacti
     INTO l_ima02,l_ima021,l_imaacti
     FROM imaicd_file,ima_file
    WHERE imaicd01 = ima01
      AND imaicd01 = g_icu.icu01
 
   CASE 
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aic-012'
                                 LET l_ima02 = NULL
                                 LET l_ima021 = NULL
        WHEN l_imaacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ima02 TO ima02
      DISPLAY l_ima021 TO ima021
   END IF
       
END FUNCTION
 
#CHI-920030--BEGIN--MARK--  
#FUNCTION i020_icu02()
#  DEFINE l_ecuacti LIKE ecu_file.ecuacti
#  DEFINE p_cmd     LIKE type_file.chr1
#  
#  LET g_errno = " "
#  
#  SELECT ecuacti
#    INTO l_ecuacti
#    FROM ecu_file
#   WHERE ecu01 = g_icu.icu01
#     AND ecu02 = g_icu.icu02
#
#  CASE 
#       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aic-022'
#       WHEN l_ecuacti = 'N'     LET g_errno = '9028'
#       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#  END CASE
 
#END FUNCTION
#CHI-920030--END--MARK-- 
 
FUNCTION i020_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_icv.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i020_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_icu.* TO NULL
      RETURN
   END IF
 
   OPEN i020_cs                                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_icu.* TO NULL      
   ELSE
      OPEN i020_count
      FETCH i020_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i020_fetch('F')                                #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i020_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                    #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i020_cs INTO g_icu.icu01,g_icu.icu02
      WHEN 'P' FETCH PREVIOUS i020_cs INTO g_icu.icu01,g_icu.icu02
      WHEN 'F' FETCH FIRST    i020_cs INTO g_icu.icu01,g_icu.icu02
      WHEN 'L' FETCH LAST     i020_cs INTO g_icu.icu01,g_icu.icu02
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about
                      CALL cl_about()
 
                   ON ACTION HELP
                      CALL cl_show_help()
 
                   ON ACTION controlg
                      CALL cl_cmdask()
 
                END PROMPT
                
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
                
            END IF
            FETCH ABSOLUTE g_jump i020_cs INTO g_icu.icu01,g_icu.icu02
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icu.icu01,SQLCA.sqlcode,0)
      INITIALIZE g_icu.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_icu.* 
     FROM icu_file 
    WHERE icu01 = g_icu.icu01
      AND icu02 = g_icu.icu02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","icu_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_icu.* TO NULL
      RETURN
   END IF
 
#  LET g_data_owner = g_icu.icuuser
#  LET g_data_group = g_icu.icugrup
 
   CALL i020_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i020_show()
 
   LET g_icu_t.* = g_icu.*                                #保存單頭舊值
   LET g_icu_o.* = g_icu.*                                #保存單頭舊值
 
   IF g_icu.icu03 = 'N' THEN 
      CALL cl_set_comp_visible("Page2",FALSE)
   ELSE
      CALL cl_set_comp_visible("Page2",TRUE)
   END IF
 
   DISPLAY BY NAME g_icu.icu01,g_icu.icu02,
                   g_icu.icu03,g_icu.icu04,
                   g_icu.icu05,g_icu.icu06,
                   g_icu.icu07,g_icu.icu08,
                   g_icu.icu09,g_icu.icu10,
                   g_icu.icu11,g_icu.icu12,
                   g_icu.icu13
 
   CALL i020_icu01('d')
   CALL i020_b_fill(g_wc2)                                #單身
 
    CALL cl_show_fld_cont()
END FUNCTION
 
{
FUNCTION i020_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_icu.icu01 IS NULL OR
      g_icu.icu02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i020_cl USING g_icu.icu01,g_icu.icu02
   IF STATUS THEN
      CALL cl_err("OPEN i020_cl:", STATUS, 1)
      CLOSE i020_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i020_cl INTO g_icu.*                             #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icu.icu01,SQLCA.sqlcode,0)            #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i020_show()
 
   IF cl_exp(0,0,g_icu.icuacti) THEN                      #確認一下
      LET g_chr=g_icu.icuacti
      IF g_icu.icuacti='Y' THEN
         LET g_icu.icuacti='N'
      ELSE
         LET g_icu.icuacti='Y'
      END IF
 
      UPDATE icu_file SET icuacti=g_icu.icuacti,
                          icumodu=g_user,
                          icudate=g_today
       WHERE icu01=g_icu.icu01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","icu_file",g_icu.icu01,"",SQLCA.sqlcode,"","",1)
         LET g_icu.icuacti=g_chr
      END IF
   END IF
 
   CLOSE i020_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_icu.icu01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT icuacti,icumodu,icudate
     INTO g_icu.icuacti,g_icu.icumodu,g_icu.icudate FROM icu_file
    WHERE icu01=g_icu.icu01
   DISPLAY BY NAME g_icu.icuacti,g_icu.icumodu,g_icu.icudate
 
END FUNCTION
}
 
FUNCTION i020_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_icu.icu01 IS NULL OR
      g_icu.icu02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icu.* FROM icu_file
    WHERE icu01 = g_icu.icu01
      AND icu02 = g_icu.icu02
 
   BEGIN WORK
 
   OPEN i020_cl USING g_icu.icu01,g_icu.icu02
   IF STATUS THEN
      CALL cl_err("OPEN i020_cl:", STATUS, 1)
      CLOSE i020_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i020_cl INTO g_icu.*                             #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icu.icu01,SQLCA.sqlcode,0)            #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i020_show()
 
   IF cl_delh(0,0) THEN                                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "icu01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "icu02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_icu.icu01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_icu.icu02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                #No.FUN-9B0098 10/02/24
      DELETE FROM icu_file 
       WHERE icu01 = g_icu.icu01
         AND icu02 = g_icu.icu02
      DELETE FROM icv_file 
       WHERE icv01 = g_icu.icu01
         AND icv02 = g_icu.icu02
      CLEAR FORM
      CALL g_icv.clear()
      OPEN i020_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i020_cs
         CLOSE i020_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i020_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i020_cs
         CLOSE i020_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i020_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i020_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i020_fetch('/')
      END IF
   END IF
 
   CLOSE i020_cl
   COMMIT WORK
   CALL cl_flow_notify(g_icu.icu01,'D')
END FUNCTION
 
#單身
FUNCTION i020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                  #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                  #檢查重複用
    l_cnt           LIKE type_file.num5,                  #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                  #單身鎖住否
    p_cmd           LIKE type_file.chr1,                  #處理狀態
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,                  #可新增否
    l_allow_delete  LIKE type_file.num5,                  #可刪除否
    l_ecd02         LIKE ecd_file.ecd02,
    l_cnt1          LIKE type_file.num5,      #MOD-C30233
    l_icv10         LIKE icv_file.icv10       #FUN-C30082
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_icu.icu01 IS NULL OR
       g_icu.icu02 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    SELECT * INTO g_icu.* 
      FROM icu_file
     WHERE icu01 = g_icu.icu01
       AND icu02 = g_icu.icu02
 
{
    IF g_icu.icuacti ='N' THEN                            #檢查資料是否為無效
       CALL cl_err(g_icu.icu01,'mfg1000',0)
       RETURN
    END IF
}
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT icv03,icv04,'',icv05,icv06,icv07",   #FUN-BC0106 add icv07
                       " ,icv08,icv09,icv10 ",  #FUN-C30082
                       "  FROM icv_file",
                       "  WHERE icv01 = ? AND icv02 = ? ",
                       "   AND icv03 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_icv WITHOUT DEFAULTS FROM s_icv.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'                            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i020_cl USING g_icu.icu01,g_icu.icu02
           IF STATUS THEN
              CALL cl_err("OPEN i020_cl:", STATUS, 1)
              CLOSE i020_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i020_cl INTO g_icu.*                     #鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_icu.icu01,SQLCA.sqlcode,0)    #資料被他人LOCK
              CLOSE i020_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_icv_t.* = g_icv[l_ac].*               #BACKUP
              LET g_icv_o.* = g_icv[l_ac].*               #BACKUP
              OPEN i020_bcl USING g_icu.icu01,g_icu.icu02,g_icv_t.icv03
              IF STATUS THEN
                 CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i020_bcl INTO g_icv[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_icv_t.icv03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i020_icv04('d')
#                SELECT ima44,ima908 INTO g_icv[l_ac].ima44,g_icv[l_ac].ima908
#                  FROM ima_file WHERE ima01=g_icv[l_ac].icv08
              END IF
              CALL cl_show_fld_cont()
#             CALL i020_set_entry_b(p_cmd)
#             CALL i020_set_no_entry_b(p_cmd)
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_icv[l_ac].* TO NULL
           LET g_icv_t.* = g_icv[l_ac].*                  #新輸入資料
           LET g_icv_o.* = g_icv[l_ac].*                  #新輸入資料
{
           IF l_ac > 1 THEN
              LET g_icv[l_ac].icv04 = g_icv[l_ac-1].icv04
           ELSE
              LET g_icv[l_ac].icv04 = g_icu.icu06
           END IF
}
           CALL cl_show_fld_cont()
#          CALL i020_set_entry_b(p_cmd)
#          CALL i020_set_no_entry_b(p_cmd)
           NEXT FIELD icv03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO icv_file(icv01,icv02,icv03,icv04,icv05,icv06,icv07,icv08,icv09,icv10)   #FUN-BC0106 add icv07   #FUN-C30082 add icv08,icv09,icv10
                         VALUES(g_icu.icu01,g_icu.icu02,
                                g_icv[l_ac].icv03,g_icv[l_ac].icv04,
                                g_icv[l_ac].icv05,g_icv[l_ac].icv06,
                                g_icv[l_ac].icv07   #FUN-BC0106
                                ,g_icv[l_ac].icv08,g_icv[l_ac].icv09,g_icv[l_ac].icv10)   #FUN-C30082
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","icv_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           #MOD-C30233---begin
           LET l_cnt1 = 0
           #SELECT COUNT(*) INTO l_cnt1 FROM ima_file WHERE ima01 = g_icu.icu01  #FUN-C50145
           SELECT COUNT(*) INTO l_cnt1 FROM ima_file,imaicd_file   #FUN-C50145
            WHERE ima01 =  imaicd00        #FUN-C50145
              AND imaicd01 = g_icu.icu01   #FUN-C50145
              AND ima1010 <> '1'           #FUN-C50145
           IF l_cnt1 > 0 THEN
              #UPDATE ima_file SET ima94 = g_icu.icu02 WHERE ima01 = g_icu.icu01   #FUN-C50145
              UPDATE ima_file SET ima94 = g_icu.icu02   #FUN-C50145
               WHERE ima1010 <> '1'   #FUN-C50145
                 AND ima01 IN (SELECT imaicd00 FROM imaicd_file WHERE imaicd01 = g_icu.icu01)  #FUN-C50145
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ima_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN--B80083 ADD
                 ROLLBACK WORK
                 RETURN
              ELSE
                 COMMIT WORK
              END IF
           #FUN-C40011---begin
           #ELSE
           END IF 
           LET l_cnt1 = 0
           SELECT COUNT(*) INTO l_cnt1 FROM imaa_file WHERE imaaicd01 = g_icu.icu01 AND imaa1010 != '2'
           IF l_cnt1 > 0 THEN
              #UPDATE imaa_file SET imaa94 = g_icu.icu02 WHERE imaa01 = g_icu.icu01
              UPDATE imaa_file SET imaa94 = g_icu.icu02 WHERE imaaicd01 = g_icu.icu01 AND imaa1010 != '2'
           #FUN-C40011---end
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","imaa_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN--B80083 ADD
                 ROLLBACK WORK
                 RETURN
              ELSE
                 COMMIT WORK
              END IF
           END IF 
           #MOD-C30233---end
 
        BEFORE FIELD icv03                                #default 序號
           IF g_icv[l_ac].icv03 IS NULL OR g_icv[l_ac].icv03 = 0 THEN
              SELECT max(icv03)+1
                INTO g_icv[l_ac].icv03
                FROM icv_file
               WHERE icv01 = g_icu.icu01
                 AND icv02 = g_icu.icu02
              IF g_icv[l_ac].icv03 IS NULL THEN
                 LET g_icv[l_ac].icv03 = 1
              END IF
           END IF
 
        AFTER FIELD icv03                                 #check 序號是否重複
           IF NOT cl_null(g_icv[l_ac].icv03) THEN
              IF g_icv[l_ac].icv03 != g_icv_t.icv03 OR
                 g_icv_t.icv03 IS NULL THEN
                #TQC-920032--BEGIN--MARK--
                #LET l_n = 0
                #SELECT COUNT(*) INTO l_n
                #  FROM ecb_file
                # WHERE ecb01 = g_icu.icu01
                #   AND ecb02 = g_icu.icu02
                #   AND ecb03 = g_icv[l_ac].icv03
                #IF l_n = 0 THEN
                #   CALL cl_err(g_icv[l_ac].icv03,"aic-016",0)
                #   LET g_icv[l_ac].icv03 = g_icv_t.icv03
                #   NEXT FIELD icv03
                #END IF
                #TQC-920032--END--
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n
                   FROM icv_file
                  WHERE icv01 = g_icu.icu01
                    AND icv02 = g_icu.icu02
                    AND icv03 = g_icv[l_ac].icv03
                 IF l_n > 0 THEN
                    CALL cl_err(g_icv[l_ac].icv03,-239,0)
                    LET g_icv[l_ac].icv03 = g_icv_t.icv03
                    NEXT FIELD icv03
                 END IF
              END IF
           END IF
 
        AFTER FIELD icv04
           IF NOT cl_null(g_icv[l_ac].icv04) THEN
              IF g_icv_t.icv04 IS NULL OR
                 (g_icv[l_ac].icv04 != g_icv_t.icv04) THEN
                #TQC-920032--BEGIN--MARK--
                #LET l_n = 0
                #SELECT COUNT(*) INTO l_n
                #  FROM ecb_file
                # WHERE ecb01 = g_icu.icu01
                #   AND ecb02 = g_icu.icu02
                #   AND ecb03 = g_icv[l_ac].icv03
                #   AND ecb06 = g_icv[l_ac].icv04
                #IF l_n = 0 THEN
                #   CALL cl_err(g_icv[l_ac].icv04,"aic-017",0)
                #   LET g_icv[l_ac].icv04 = g_icv_t.icv04
                #   NEXT FIELD icv04
                #END IF
                #TQC-920032--END--MARK--
                 CALL i020_icv04(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_icv[l_ac].icv04,g_errno,0)
                    LET g_icv[l_ac].icv04 = g_icv_t.icv04
                    DISPLAY BY NAME g_icv[l_ac].icv04
                    NEXT FIELD icv04
                 END IF
              END IF
           END IF
 
#EXT-940148--begin--amrk--
#       AFTER FIELD icv05
#          IF NOT cl_null(g_icv[l_ac].icv05) THEN
#             IF g_icv[l_ac].icv05 != g_icv_t.icv05 OR
#                g_icv_t.icv05 IS NULL THEN
#                LET l_n = 0
#                SELECT COUNT(*) INTO l_n
#                  FROM icv_file
#                 WHERE icv01 = g_icu.icu01
#                   AND icv02 = g_icu.icu02
#                   AND icv05 = g_icv[l_ac].icv05
#                IF l_n > 0 THEN
#                   CALL cl_err(g_icv[l_ac].icv05,-239,0)
#                   LET g_icv[l_ac].icv05 = g_icv_t.icv05
#                   NEXT FIELD icv05
#                END IF
#             END IF
#          END IF
#EXT-940148--end--mark--

       #MOD-CA0028---add---S
        AFTER FIELD icv05
           IF g_icv[l_ac].icv05 ='2' THEN 
              CALL cl_set_comp_required("icv07",TRUE)  
           ELSE
              CALL cl_set_comp_required("icv07",FALSE)
           END IF           
       #MOD-CA0028---add---E
           
        AFTER FIELD icv06
           IF NOT cl_null(g_icv[l_ac].icv06) THEN
              IF g_icv_t.icv06 IS NULL OR
                 (g_icv[l_ac].icv06 != g_icv_t.icv06) THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n
                   FROM icr_file
                  WHERE icr01 = g_icv[l_ac].icv06
                    AND icr02 = '4'
                 IF l_n = 0 THEN
                    CALL cl_err(g_icv[l_ac].icv06,"aic-018",0)
                    LET g_icv[l_ac].icv06 = g_icv_t.icv06
                    NEXT FIELD icv06
                 END IF
              END IF
           END IF   

        #FUN-BC0106 --START--   
        AFTER FIELD icv07
           IF NOT cl_null(g_icv[l_ac].icv07) THEN 
              IF NOT i020_icv07()THEN
                 NEXT FIELD icv07
              END IF
           END IF    
        #FUN-BC0106 --END--

        #FUN-C30082---begin
        AFTER FIELD icv10
           IF NOT cl_null(g_icv[l_ac].icv10) THEN
              LET l_icv10 = NULL
              SELECT ima01 INTO l_icv10 FROM ima_file
              WHERE ima01 = g_icv[l_ac].icv10
              #TQC-C60183---begin
              IF cl_null(l_icv10) THEN
                 SELECT imaa01 INTO l_icv10
                   FROM imaa_file
                  WHERE imaa01 = g_icv[l_ac].icv10
              END IF 
              #TQC-C60183---end
              IF cl_null(l_icv10) THEN
                 CALL cl_err("", "aic-020", 1)
                 NEXT FIELD icv10
              END IF 
           END IF 
           
        #FUN-C30082---end
        
        BEFORE DELETE                                     #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_icv_t.icv03 > 0 AND g_icv_t.icv03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM icv_file
               WHERE icv01 = g_icu.icu01
                 AND icv02 = g_icu.icu02
                 AND icv03 = g_icv_t.icv03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","icv_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_icv[l_ac].* = g_icv_t.*
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_icv[l_ac].icv03,-263,1)
              LET g_icv[l_ac].* = g_icv_t.*
           ELSE
              UPDATE icv_file SET icv03=g_icv[l_ac].icv03,
                                  icv04=g_icv[l_ac].icv04,
                                  icv05=g_icv[l_ac].icv05,
                                  icv06=g_icv[l_ac].icv06,
                                  icv07=g_icv[l_ac].icv07,   #FUN-BC0106
                                  icv08=g_icv[l_ac].icv08,   #FUN-C30082
                                  icv09=g_icv[l_ac].icv09,   #FUN-C30082
                                  icv10=g_icv[l_ac].icv10    #FUN-C30082
               WHERE icv01 = g_icu.icu01
                 AND icv02 = g_icu.icu02
                 AND icv03=g_icv_t.icv03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","icv_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)
                 LET g_icv[l_ac].* = g_icv_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac#FUN-D40030 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_icv[l_ac].* = g_icv_t.*
             #FUN-D40030--add--str
              ELSE
                 CALL g_icv.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
             #FUN-D40030--add--end
              END IF
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac#FUN-D40030 add
           CLOSE i020_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                                #沿用所有欄位
           IF INFIELD(icv03) AND l_ac > 1 THEN
              LET g_icv[l_ac].* = g_icv[l_ac-1].*
              LET g_icv[l_ac].icv03 = g_rec_b + 1
              NEXT FIELD icv03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(icv04)
               CALL cl_init_qry_var()
               #TQC-920032--BEGIN--
               #LET g_qryparam.form ="q_ecd02_icd"  #TQC-C30138 mark
               LET g_qryparam.form ="q_ecd_icd" #TQC-C30138
               #LET g_qryparam.form ="q_ecb_01" 
               #LET g_qryparam.arg1 = g_icu.icu01
               #LET g_qryparam.arg2 = g_icu.icu02
               #LET g_qryparam.arg3 = g_icv[l_ac].icv03
               #TQC-920032--END--
               LET g_qryparam.default1 = g_icv[l_ac].icv04
               CALL cl_create_qry() RETURNING g_icv[l_ac].icv04
               DISPLAY BY NAME g_icv[l_ac].icv04
               NEXT FIELD icv04
             WHEN INFIELD(icv06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_icr_icd01" 
               LET g_qryparam.default1 = g_icv[l_ac].icv06
               CALL cl_create_qry() RETURNING g_icv[l_ac].icv06
               DISPLAY BY NAME g_icv[l_ac].icv06
               NEXT FIELD icv06
             #FUN-BC0106 --START--
             WHEN INFIELD(icv07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_imz" 
               LET g_qryparam.default1 = g_icv[l_ac].icv07
               CALL cl_create_qry() RETURNING g_icv[l_ac].icv07
               DISPLAY BY NAME g_icv[l_ac].icv07
               NEXT FIELD icv07
             #FUN-BC0106 --END-- 
             #FUN-C30082--begin
             WHEN INFIELD(icv10)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form     = "q_imaicd"
                LET g_qryparam.where    = " imaicd01= '" ,g_icu.icu01 , "' "
                LET g_qryparam.default1 = g_icv[l_ac].icv10
                CALL cl_create_qry() RETURNING g_icv[l_ac].icv10
                DISPLAY BY NAME g_icv[l_ac].icv10
                NEXT FIELD icv10
             #FUN-C30082---end   
             OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION HELP
           CALL cl_show_help()
 
        ON ACTION controls           
           CALL cl_set_head_visible("","AUTO")
    END INPUT
 
{
    LET g_icu.icumodu = g_user
    LET g_icu.icudate = g_today
    UPDATE icu_file SET icumodu = g_icu.icumodu,icudate = g_icu.icudate
     WHERE icu01 = g_icu.icu01
    DISPLAY BY NAME g_icu.icumodu,g_icu.icudate
}
 
    CLOSE i020_bcl
    COMMIT WORK
    
#   CALL i020_delall()  #TQC-920032
   CALL i020_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i020_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM icu_file WHERE icu01 = g_icu.icu01
                                AND icu02 = g_icu.icu02
         INITIALIZE g_icu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
#TQC-920032--BEGIN--MARK--
#FUNCTION i020_g_b()
#  DEFINE l_ecb03 LIKE ecb_file.ecb03
#  DEFINE l_ecb06 LIKE ecb_file.ecb06
#  DEFINE l_i     LIKE type_file.num5
#  DEFINE l_icr01 LIKE icr_file.icr01
#  
#  
#  BEGIN WORK
#  
#  DECLARE g_b_icv CURSOR FOR
#   SELECT ecb03,ecb06
#     FROM ecb_file
#    WHERE ecb01 = g_icu.icu01
#      AND ecb02 = g_icu.icu02
#    ORDER BY ecb01,ecb02,ecb03,ecb06
#   
#  SELECT icr01 INTO l_icr01
#    FROM icr_file
#   WHERE icr02 = '4'
#     AND ROWNUM = 1
#  
#  LET l_i = 1
#  FOREACH g_b_icv INTO l_ecb03,l_ecb06
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        ROLLBACK WORK
#        EXIT FOREACH
#     END IF
#     
#     INSERT INTO icv_file(icv01,icv02,icv03,
#                          icv04,icv05,icv06)
#                   VALUES(g_icu.icu01,g_icu.icu02,l_ecb03,
#                          l_ecb06,l_i,l_icr01)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3('ins','icv_file',g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,'','',1)
#        ROLLBACK WORK
#        EXIT FOREACH
#     END IF
#     
#     LET l_i = l_i + 1
#     
#     IF l_i > 5 THEN
#        LET l_i = 1
#     END IF   
#     
#  END FOREACH
 
#  COMMIT WORK
#  
#  CALL i020_b_fill("1=1")            
 
#END FUNCTION
#FUN-920053--END--MARK--
 
#TQC-920032--BEGIN--MARK--
#FUNCTION i020_delall()
 
#  SELECT COUNT(*) INTO g_cnt 
#    FROM icv_file
#   WHERE icv01 = g_icu.icu01
#     AND icv02 = g_icu.icu02
 
#  IF g_cnt = 0 THEN
#     IF cl_confirm('aic-996') THEN
#        CALL i020_g_b()
#     ELSE                                         #未輸入單身資料, 是否取消單頭資料
#        CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#        ERROR g_msg CLIPPED
#        DELETE FROM icu_file 
#         WHERE icu01 = g_icu.icu01
#           AND icu02 = g_icu.icu02
#     END IF
#  END IF
 
#END FUNCTION
#TQC-920032--END--
 
FUNCTION i020_icv04(p_cmd)
   DEFINE l_ecd02   LIKE ecd_file.ecd02
   DEFINE l_ecdacti LIKE ecd_file.ecdacti
   DEFINE p_cmd     LIKE type_file.chr1
 
   LET g_errno = " "
 
   SELECT ecd02,ecdacti
     INTO l_ecd02,l_ecdacti
     FROM ecd_file 
    WHERE ecd01 = g_icv[l_ac].icv04
 
   CASE 
      #WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aic-017'   #TQC-C30138
                                LET l_ecd02 = NULL
      WHEN l_ecdacti='N'        LET g_errno = '9028'
        OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_icv[l_ac].ecd02 = l_ecd02
      DISPLAY BY NAME g_icv[l_ac].ecd02
   END IF
 
END FUNCTION
 
FUNCTION i020_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   IF NOT cl_null(g_argv1) THEN
      LET g_icu.icu01 = g_argv1
      LET g_sql = "SELECT icv03,icv04,'',icv05,icv06,icv07,icv08,icv09,icv10 ",   #FUN-BC0106 add icv07 #FUN-C30082 add icv08,icv09,icv10
                  "  FROM icv_file",
                  " WHERE icv01 ='",g_icu.icu01,"' "      #單頭
   
   ELSE   
      LET g_sql = "SELECT icv03,icv04,'',icv05,icv06,icv07,icv08,icv09,icv10 ",   #FUN-BC0106 add icv07 #FUN-C30082 add icv08,icv09,icv10
                  "  FROM icv_file",
                  " WHERE icv01 ='",g_icu.icu01,"' ",     #單頭
                  "   AND icv02 ='",g_icu.icu02,"' "
   END IF
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY icv03,icv04,icv05,icv06,icv07,icv08,icv09,icv10 "   #FUN-BC0106 add icv07 #FUN-C30082 add icv08,icv09,icv10
   DISPLAY g_sql
 
   PREPARE i020_pb FROM g_sql
   DECLARE icv_cs CURSOR FOR i020_pb
 
   CALL g_icv.clear()
   LET g_cnt = 1
 
   FOREACH icv_cs INTO g_icv[g_cnt].*                     #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ecd02 INTO g_icv[g_cnt].ecd02 
         FROM ecd_file
        WHERE ecd01 = g_icv[g_cnt].icv04
       IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","ecd_file",g_icv[g_cnt].icv04,"",SQLCA.sqlcode,"","",0)  
         LET g_icv[g_cnt].ecd02 = NULL
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_icv.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i020_copy()
   DEFINE l_newno     LIKE icu_file.icu01
   DEFINE l_oldno     LIKE icu_file.icu01
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_cnt1      LIKE type_file.num5   #MOD-C30233
   DEFINE l_cnt2      LIKE type_file.num5   #MOD-C30233
   
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_icu.icu01 IS NULL OR
      g_icu.icu02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i020_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   
   INPUT l_newno WITHOUT DEFAULTS FROM icu01
   
#      BEFORE INPUT
#         CALL cl_set_docno_format("icu01")
 
       AFTER FIELD icu01
          IF NOT cl_null(l_newno) THEN
            #MOD-C30233---begin
            #FUN-AA0059 ------------add start----------------
            # IF NOT s_chk_item_no(l_newno,'') THEN
            #    CALL cl_err('',g_errno,1)
            #    NEXT FIELD icu01
            # END IF
            #FUN-AA0059 ------------add end---------------
            LET l_cnt1 = 0
            LET l_cnt2 = 0
            SELECT count(*) INTO l_cnt1 FROM ima_file WHERE ima01 = l_newno
            IF l_cnt1 = 0 THEN
               SELECT count(*) INTO l_cnt2 FROM imaa_file WHERE imaa01 = l_newno
            END IF 
            IF l_cnt1 = 0 AND l_cnt2 = 0 THEN
               CALL cl_err('','mfg3403',1)
               NEXT FIELD icu01
            END IF 
            #MOD-C30233---end
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n
               FROM icu_file
              WHERE icu01 = l_newno
             IF l_n > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD icu01
             END IF
          END IF        
          DISPLAY l_newno TO icu01
          IF l_cnt1 > 0 THEN   #MOD-C30233
             CALL i020_icu01(p_cmd)
          END IF               #MOD-C30233
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_icu.icu01,g_errno,0)
             LET g_icu.icu01 = g_icu01_t
             DISPLAY BY NAME g_icu.icu01
             NEXT FIELD icu01
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(icu01)                                                   
                CALL cl_init_qry_var()                                              
                LET g_qryparam.form ="q_imaicd_1"
                LET g_qryparam.default1 = g_icu.icu01                                   
                LET g_qryparam.default1 = l_newno                                 
                CALL cl_create_qry() RETURNING l_newno                              
                DISPLAY l_newno TO icu01                                            
                NEXT FIELD icu01
            #CHI-920030--EBGIN--MARK--
            #WHEN INFIELD(icu02)
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_ecu"
            #   LET g_qryparam.default1 = g_icu.icu02
            #   LET g_qryparam.arg1 = g_icu.icu01
            #   CALL cl_create_qry() RETURNING g_icu.icu02
            #   DISPLAY BY NAME g_icu.icu02
            #   NEXT FIELD icu02
            #CHI-920030--NED--MARK--
            OTHERWISE EXIT CASE                                                 
          END CASE
 
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_icu.icu01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM icu_file                                 #單頭複製
    WHERE icu01 = g_icu.icu01
     INTO TEMP y
 
   UPDATE y
       SET icu01=l_newno                                  #新的鍵值
{       
           icu06=l_newdate,  #新的鍵值
           icuuser=g_user,   #資料所有者
           icugrup=g_grup,   #資料所有者所屬群
           icumodu=NULL,     #資料修改日期
           icudate=g_today,  #資料建立日期
           icuacti='Y'       #有效資料
}
 
   INSERT INTO icu_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","icu_file",l_newno,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM icv_file                                 #單身複製
    WHERE icv01 = g_icu.icu01
      AND icv02 = g_icu.icu02     
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET icv01 = l_newno
 
   INSERT INTO icv_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","icv_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN--B80083 ADD
      ROLLBACK WORK
    #  CALL cl_err3("ins","icv_file",g_icu.icu01,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN--B80083 MARK
      RETURN
   ELSE
       COMMIT WORK
   END IF
   #MOD-C30233---begin
   LET l_cnt1 = 0
   #SELECT COUNT(*) INTO l_cnt1 FROM ima_file WHERE ima01 = l_newno   #FUN-C50145
    SELECT COUNT(*) INTO l_cnt1 FROM ima_file,imaicd_file   #FUN-C50145
     WHERE ima01 =  imaicd00        #FUN-C50145
       AND imaicd01 = l_newno       #FUN-C50145
       AND ima1010 <> '1'           #FUN-C50145
   IF l_cnt1 > 0 THEN
      #UPDATE ima_file SET ima94 = g_icu.icu02 WHERE ima01 = l_newno  #FUN-C50145
      UPDATE ima_file SET ima94 = g_icu.icu02   #FUN-C50145
       WHERE ima1010 <> '1'   #FUN-C50145
         AND ima01 IN (SELECT imaicd00 FROM imaicd_file WHERE imaicd01 = l_newno)  #FUN-C50145
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ima_file",l_newno,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN--B80083 ADD
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
      END IF
   #FUN-C40011---begin   
   #ELSE
   END IF
   LET l_cnt1 = 0
   SELECT COUNT(*) INTO l_cnt1 FROM imaa_file WHERE imaaicd01 = l_newno AND imaa1010 != '2'
   IF l_cnt1 > 0 THEN
      #UPDATE imaa_file SET imaa94 = g_icu.icu02 WHERE imaa01 = l_newno
      UPDATE imaa_file SET imaa94 = g_icu.icu02 WHERE imaaicd01 = l_newno AND imaa1010 != '2'
   #FUN-C40011---end
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","imaa_file",l_newno,g_icu.icu02,SQLCA.sqlcode,"","",1)  #FUN--B80083 ADD
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
      END IF
   END IF 
   #MOD-C30233---end
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_icu.icu01
   SELECT icu_file.* INTO g_icu.* 
     FROM icu_file 
    WHERE icu01 = l_newno
   CALL i020_u()
   CALL i020_b()
   #FUN-C30027---begin
   #SELECT icu_file.* INTO g_icu.* 
   #  FROM icu_file 
   # WHERE icu01 = l_oldno
   #CALL i020_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION i020_out()
DEFINE
    l_i             LIKE type_file.num5,
    sr              RECORD
        icu01       LIKE icu_file.icu01,   #母體料號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        icu02       LIKE icu_file.icu02,   #制程編號
        icu03       LIKE icu_file.icu03,   #code否
        icu04       LIKE icu_file.icu04,   #總code固定值
        icu05       LIKE icu_file.icu05,   #總code前置/后置
        icu06       LIKE icu_file.icu06,   #總code起始流水碼
        icu07       LIKE icu_file.icu07,   #總code截止流水碼
        icu08       LIKE icu_file.icu08,   #總code目前已使用流水碼
        icu09       LIKE icu_file.icu09,   #子code固定值
        icu10       LIKE icu_file.icu10,   #子code前置/后置
        icu11       LIKE icu_file.icu11,   #子code起始流水碼
        icu12       LIKE icu_file.icu12,   #子code截止流水碼
        icu13       LIKE icu_file.icu13,   #子code目前已使用流水碼
        icv03       LIKE icv_file.icv03,   #制程序
        icv04       LIKE icv_file.icv04,   #作業編號
        ecd02       LIKE ecd_file.ecd02,   #作業名稱
        icv05       LIKE icv_file.icv05,   #制程特性
        icv06       LIKE icv_file.icv06    #編碼原則
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name
    l_wc            STRING
 
    IF cl_null(g_icu.icu01) OR
       cl_null(g_icu.icu02) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc = " icu01 = '",g_icu.icu01," '"," AND ",
                  " icu02 = '",g_icu.icu02," '"
       LET g_wc2= " 1=1 "
    END IF
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
 
#   CALL cl_del_data(g_table)
#   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,g_table CLIPPED,
#               "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
#   END IF
 
    LET g_sql = "SELECT icu01,ima02,ima021,icu02,icu03,icu04,icu05,",
                "       icu06,icu07,icu08,icu09,icu10,icu11,icu12,",
                "       icu13,icv03,icv04,ecd02,icv05,icv06 ",
                " FROM  icu_file LEFT OUTER JOIN ima_file ON ima01 = icu01 AND imaacti = 'Y',icv_file LEFT OUTER JOIN ecd_file ON icv04 = ecd01 ",
                " WHERE icu01 = icv01 ", 
                "   AND icu02 = icv02 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
    LET g_sql = g_sql CLIPPED," ORDER BY icu01,icu02"
#   PREPARE i020_p1 FROM g_sql                           #RUNTIME 編譯
#   IF STATUS THEN 
#      CALL cl_err('i020_p1',STATUS,0) 
#   END IF
#   DECLARE i020_co CURSOR FOR i020_p1
 
#   FOREACH i020_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      EXECUTE insert_prep USING sr.* 
#   END FOREACH
 
    #是否列印選擇條件
    #將cl_wcchp轉換後的g_wc放到l_wc,不要改變原來g_wc的值,不然第二次執行會有問題
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'icu01,icu02,icu03')                 
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
 
    LET g_str = l_wc
    CALL cl_prt_cs1('aici020','aici020',g_sql,g_str)
#   LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,g_table CLIPPED
#   CALL cl_prt_cs3('aici020','aici020',g_sql,g_str)
 
#   CLOSE i020_co
    ERROR ""
END FUNCTION
 
FUNCTION i020_set_entry(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("icu01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i020_set_no_entry(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("icu01",FALSE)
    END IF
 
END FUNCTION

#FUN-BC0106 --START--
FUNCTION i020_icv07()
   DEFINE l_imzacti      LIKE imz_file.imzacti
   SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_icv[l_ac].icv07
   CASE 
    WHEN SQLCA.SQLCODE = 100  
       LET g_errno = 'mfg3179'
    WHEN l_imzacti='N' 
       LET g_errno = '9028'
    OTHERWISE
       LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF NOT cl_null(g_errno) THEN
      CALL cl_err(g_icv[l_ac].icv07,g_errno,0)
      LET g_icv[l_ac].icv07 = g_icv_t.icv07
      DISPLAY BY NAME g_icv[l_ac].icv07
      RETURN FALSE
   END IF
   RETURN TRUE 
END FUNCTION
#FUN-BC0106 --END--

#FUN-C20100 --START--
FUNCTION i020_ins_icu()
DEFINE l_ima94      LIKE ima_file.ima94
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_icu RECORD LIKE icu_file.*
   SELECT ima94 INTO l_ima94 FROM ima_file
    WHERE ima01 = g_argv1 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_argv1,SQLCA.sqlcode,0)
      RETURN FALSE
   END IF 
   SELECT COUNT(*) INTO l_cnt FROM icu_file
    WHERE icu01 = g_argv1 AND icu02 = l_ima94
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_argv1,SQLCA.sqlcode,0)
      RETURN FALSE
   END IF 
   IF l_cnt <= 0 THEN      
      LET l_icu.icu01 = g_argv1
      LET l_icu.icu02 = l_ima94
      LET l_icu.icu03 = "N"
      LET l_icu.icu05 = "1"
      LET l_icu.icu10 = "1"
      
      INSERT INTO icu_file VALUES (l_icu.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_argv1,SQLCA.sqlcode,0)
         RETURN FALSE
      END IF       
   END IF 
   RETURN TRUE 
END FUNCTION
#FUN-C20100 --END--
#No.FUN-7B0018 Create this program
