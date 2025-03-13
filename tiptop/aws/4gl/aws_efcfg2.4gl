# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aws_efcfg2.4gl
# Descriptions...: EF 整合設定作業
# Date & Author..: 94/04/21 By Echo
# Modify.........: No.MOD-560007 05/06/02 By Echo 重新定義FUN名稱
# Modify.........: No.MOD-560086 05/06/14 by Echo 修改controlf 欄位說明
# Modify.........: No.FUN-5A0207 05/10/31 By Echo 判斷設定的程式代號, 其模組代碼為 APY/CPY/GPY 時(refer to zz_file.zz011) 時,
#                                               wsg07, wsg08, wsg09 設為 notNull=0 & required=0(call cl_set_comp_required())
# Modify.........: No.FUN-5A0136 05/12/06 by echo 修改判斷TABLE的SQL語法
# Modify.........: No.FUN-640182 06/04/12 By Alexstar 在「M.維護單頭欄位」、「D.維護單身欄位」裡增加顯示「欄位說明」
# Modify.........: No.FUN-640184 06/04/17 By Echo 自動執行確認功能
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0075 06/10/23 By bnlent g_no_ask --> mi_no_ask 
# Modify.........: No.FUN-6A0091 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730038 07/03/12 By Smapmin 程式名稱由原來的zz02改抓gaz03
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770047 07/09/26 by Echo 新增整合-備註功能
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.MOD-930113 09/03/11 By Vicky 修改 systables => ds:systables
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9C0016 09/12/09 By Dido gae_file key值調整 
# Modify.........: No:TQC-9C0193 09/12/30 By Dido 邏輯調整 
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B30003 11/04/13 By Jay 增加CROSS平台功能
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B90032 11/09/05 By minpp 模組程序撰寫規範修正 
# Modify.........: No.CHI-BC0010 11/12/20 By ka0132 調整維護單頭,單身欄位功能
# Modify.........: No.FUN-B80090 11/12/30 By ka0132 wap_file查無資料時,不顯示錯誤訊息
# Modify.........: No.FUN-C20087 12/03/06 By Abby CROSS自動化流程處理
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
DEFINE
   g_wsd     RECORD LIKE wsd_file.*,              #EasyFlow 整合設定主檔
   g_wse     RECORD LIKE wse_file.*,              #單頭檔設定
   g_wsf     RECORD LIKE wsf_file.*,              #單身檔設定
   g_wsg     RECORD LIKE wsg_file.*,              #單據性質檔設定
   g_wsi     RECORD LIKE wsi_file.*,              #欄位關連設定
   g_wsj     RECORD LIKE wsj_file.*,
   g_wsq     RECORD LIKE wsq_file.*,              #備註檔設定  #FUN-770047
   g_wsd_t   RECORD LIKE wsd_file.*,
   g_wse_t   RECORD LIKE wse_file.*,
   g_wsf_t   RECORD LIKE wsf_file.*,
   g_wsg_t   RECORD LIKE wsg_file.*,
   g_wsq_t   RECORD LIKE wsq_file.*,                           #FUN-770047
   g_wsf_o   RECORD LIKE wsf_file.*,
   g_wsj_t   RECORD LIKE wsj_file.*,
   g_wsj_o   RECORD LIKE wsj_file.*,
   g_wsq_o   RECORD LIKE wsq_file.*,                           #FUN-770047
   g_wsd01_t LIKE wsd_file.wsd01,
   g_wse01_t LIKE wse_file.wse01,
   g_wsf01_t LIKE wsf_file.wsf01,
   g_wsg01_t LIKE wsg_file.wsg01,
   g_wsq01_t LIKE wsq_file.wsq01,                              #FUN-770047
   g_wc,g_sql,g_beforeinput  STRING,
   g_row_cnt        LIKE type_file.num10
DEFINE g_cnt LIKE type_file.num10          #No.FUN-680130 INTEGER
DEFINE g_exc_cnt LIKE type_file.num10      #No.FUN-680130 INTEGER
DEFINE g_bwsj  DYNAMIC ARRAY OF RECORD
      bwsj06  LIKE wsj_file.wsj06,
      bwsj04  LIKE wsj_file.wsj04,
      bwsj02  LIKE wsj_file.wsj02,
      bwsj03  LIKE wsj_file.wsj03
      END RECORD
DEFINE
    g_wsh          DYNAMIC ARRAY of RECORD    #程式變數(Program Variables)
        wsh03       LIKE wsh_file.wsh03,
        wsh04       LIKE wsh_file.wsh04,
        wsh05       LIKE wsh_file.wsh05,
        gae04       LIKE gae_file.gae04,      #FUN-640182    
        wsh06       LIKE wsh_file.wsh06,
        wsh07       LIKE wsh_file.wsh07,
        wsh08       LIKE wsh_file.wsh08,
        wsh09       LIKE wsh_file.wsh09,      #NO.CHI-BC0010
        wsh10       LIKE wsh_file.wsh10,      #NO.CHI-BC0010
        gae04_2     LIKE gae_file.gae04       #NO.CHI-BC0010
                    END RECORD,
    g_wsh_t         RECORD                    #程式變數 (舊值)
        wsh03       LIKE wsh_file.wsh03,
        wsh04       LIKE wsh_file.wsh04,
        wsh05       LIKE wsh_file.wsh05,
        gae04       LIKE gae_file.gae04,      #FUN-640182    
        wsh06       LIKE wsh_file.wsh06,
        wsh07       LIKE wsh_file.wsh07,
        wsh08       LIKE wsh_file.wsh08,
        wsh09       LIKE wsh_file.wsh09,      #NO.CHI-BC0010
        wsh10       LIKE wsh_file.wsh10,      #NO.CHI-BC0010
        gae04_2     LIKE gae_file.gae04       #NO.CHI-BC0010
                    END RECORD,
    g_rec_b         LIKE type_file.num5,      #單身筆數             #No.FUN-680130 SMALLINT
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT  #No.FUN-680130 SMALLINT
    g_forupd_sql    STRING
DEFINE mi_no_ask    LIKE type_file.num5       #是否開啟指定筆視窗   #No.FUN-680130 SMALLINT  #No.FUN-6A0075
DEFINE g_jump       LIKE type_file.num10      #查詢指定的筆數       #No.FUN-680130 INTEGER
DEFINE g_curs_index LIKE type_file.num10      #計算筆數給是否隱藏toolbar按鈕用   #No.FUN-680130 INTEGER
DEFINE g_row_count  LIKE type_file.num10      #總筆數計算           #No.FUN-680130 INTEGER
DEFINE g_gaz03       STRING                   #MOD-730038
DEFINE g_zz03       STRING
DEFINE g_zz04       STRING
DEFINE l_zz05       STRING
DEFINE g_zz06       STRING                 #FUN-770047
DEFINE g_gat03      LIKE gat_file.gat03   #No.FUN-680130 VARCHAR(36)
DEFINE g_gaq03      LIKE gaq_file.gaq03   #FUN-640182
DEFINE g_channel     base.Channel,
       g_cmd         STRING
DEFINE g_wsh09      LIKE wsh_file.wsh09   #NO.CHI-BC0010
DEFINE g_wsh10      LIKE wsh_file.wsh10   #NO.CHI-BC0010
DEFINE g_gae04      LIKE gae_file.gae04   #NO.CHI-BC0010

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AWS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW efcfg2_w WITH FORM "aws/42f/aws_efcfg2"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
   #-----指定combo wsg06的值-------------#
   CALL cl_set_combo_module("wsg06", 1)
   #-------------------------------------#
 
    IF g_aza.aza72 != 'Y' OR g_aza.aza72 IS NULL THEN
       CALL cl_set_comp_visible("page05",FALSE)
       CALL cl_set_act_visible("memofield",FALSE)
    END IF
 
    CALL efcfg2_menu()
 
    CLOSE WINDOW efcfg2_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION efcfg2_curs()
    CLEAR FORM
 
   INITIALIZE g_wsd.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        wsd01,wsd02,wse02,wse03,wse04,wse05,wse06,wse07,
        wse08,wse09,wse10,wse11,wse12,wse13,
        wsf03,wsf04,wsf05,wsf06,wsf07,wsf08,wsf09,
        wsg02,wsg03,wsg04,wsg05,wsg06,wsg07,wsg08,wsg09,wsg10, #FUN-640184
        wsq02,wsq03,wsq04,wsq05,wsq06,wsq07,                   #FUN-770047
        wsduser,wsdgrup,wsdmodu,wsddate,wsdacti
 
        BEFORE CONSTRUCT
            CALL cl_set_combo_items("wse03",NULL,NULL)
            CALL cl_set_combo_items("wse04",NULL,NULL)
            CALL cl_set_combo_items("wse05",NULL,NULL)
            CALL cl_set_combo_items("wse06",NULL,NULL)
            CALL cl_set_combo_items("wse07",NULL,NULL)
            CALL cl_set_combo_items("wse08",NULL,NULL)
            CALL cl_set_combo_items("wse09",NULL,NULL)
            CALL cl_set_combo_items("wse10",NULL,NULL)
            CALL cl_set_combo_items("wse11",NULL,NULL)
            CALL cl_set_combo_items("wse12",NULL,NULL)
            CALL cl_set_combo_items("wsf04",NULL,NULL)
            CALL cl_set_combo_items("wsf05",NULL,NULL)
            CALL cl_set_combo_items("wsf06",NULL,NULL)
            CALL cl_set_combo_items("wsf07",NULL,NULL)
            CALL cl_set_combo_items("wsf08",NULL,NULL)
            CALL cl_set_combo_items("wsf09",NULL,NULL)
            CALL cl_set_combo_items("wsg03",NULL,NULL)
            CALL cl_set_combo_items("wsg04",NULL,NULL)
            CALL cl_set_combo_items("wsg05",NULL,NULL)
            CALL cl_set_combo_items("wsg07",NULL,NULL)
            CALL cl_set_combo_items("wsg09",NULL,NULL)
            CALL cl_set_combo_items("wsg10",NULL,NULL)    #FUN-640184
            CALL cl_set_combo_items("wsq03",NULL,NULL)    #FUN-770047
            CALL cl_set_combo_items("wsq04",NULL,NULL)    #FUN-770047
            CALL cl_set_combo_items("wsq05",NULL,NULL)    #FUN-770047
            CALL cl_set_combo_items("wsq06",NULL,NULL)    #FUN-770047
            CALL cl_set_combo_items("wsq07",NULL,NULL)    #FUN-770047
 
            CALL cl_qbe_init()           #No.FUN-580031
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wsd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_wsd.wsd01
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wsd01
                WHEN INFIELD(wse02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_wse.wse02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wse02
                WHEN INFIELD(wsf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsf.wsf03
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wsf03
                WHEN INFIELD(wsg02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsg.wsg02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wsg02
               #FUN-770047
                WHEN INFIELD(wsq02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_wsq.wsq02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wsq02
               #END FUN-770047
 
            END CASE
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
             CALL cl_qbe_select()
         ON ACTION qbe_save
             CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END CONSTRUCT
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND wsduser = '",g_user,"'"   #FUN-770047
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND wsdgrup MATCHES '",       #FUN-770047
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND wsdgrup IN ",cl_chk_tgrup_list() #FUN-770047
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('wsduser', 'wsdgrup')
    #End:FUN-980030
 
 
    # 組合出 SQL 指令
    #FUN-770047
    LET g_sql="SELECT wsd01 FROM wsd_file,OUTER wse_file,OUTER wsf_file,",
              " OUTER wsg_file,OUTER wsq_file ",
              " WHERE wsd_file.wsd01=wse_file.wse01 AND wsd_file.wsd01=wsf_file.wsf01 ",
              "   AND wsd_file.wsd01=wsg_file.wsg01 AND wsd_file.wsd01=wsq_file.wsq01 ",
              "   AND wsf_file.wsf02=1 AND ", g_wc CLIPPED," ORDER BY wsd01"
    #END FUN-770047
 
    PREPARE efcfg2_prepare FROM g_sql
    DECLARE efcfg2_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR efcfg2_prepare
 
    #FUN-770047
    LET g_sql=
        "SELECT COUNT(*) FROM wsd_file,OUTER wse_file,OUTER wsf_file,",
        " OUTER wsg_file,OUTER wsq_file ",
        " WHERE wsd_file.wsd01=wse_file.wse01 AND wsd_file.wsd01=wsf_file.wsf01 ",
        "   AND wsd_file.wsd01=wsg_file.wsg01 AND wsd_file.wsd01=wsq_file.wsq01 ",
        "   AND wsf_file.wsf02=1 AND ",g_wc CLIPPED
    #END FUN-770047
 
    PREPARE efcfg2_precount FROM g_sql
    DECLARE efcfg2_count CURSOR FOR efcfg2_precount
END FUNCTION
 
FUNCTION efcfg2_menu()
    DEFINE l_wap02   LIKE wap_file.wap02     #FUN-B30003
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting(g_curs_index, g_row_count)
           #FUN-C20087 add str---
            SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'
            IF l_wap02 = "Y" THEN
               CALL cl_set_act_visible("ef_services", FALSE)
            END IF
           #FUN-C20087 add end---
 
        LET g_action_choice = ""
 
        ON ACTION insert
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
                  CALL efcfg2_a()
            END IF
 
        ON ACTION query
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
                 CALL efcfg2_q()
            END IF
 
        ON ACTION previous
            CALL efcfg2_fetch('P')
 
        ON ACTION next
            CALL efcfg2_fetch('N')
 
        ON ACTION first
            CALL efcfg2_fetch('F')
 
        ON ACTION last
            CALL efcfg2_fetch('L')
 
        ON ACTION jump
            CALL efcfg2_fetch('/')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL efcfg2_u()
            END IF
 
        ON ACTION masfield
            CALL efcfg2_h()
 
        ON ACTION detailfield
            CALL efcfg2_d()
 
        #FUN-770047
        ON ACTION memofield
            CALL efcfg2_m()
        #END FUN-770047
 
        ON ACTION delete
            LET g_action_choice = "delete"
            IF cl_chk_act_auth() THEN
                 CALL efcfg2_r()
            END IF
 
        ON ACTION reproduce
            LET g_action_choice = "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL efcfg2_copy()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION traninfo
            CALL aws_efcol2('W', g_wsd.wsd01)
 
#        ON ACTION proex
 
 ##### MOD-490275 #####
          #  LET g_cmd = "ls ", "aws_",g_wsd.wsd01 CLIPPED,".4gl"
          #  RUN g_cmd
#            LET g_channel = base.Channel.create()
#            LET g_cmd = "wc -l ", fgl_getenv('AWS') CLIPPED, "/4gl/aws2_", g_wsd.wsd01 CLIPPED, ".4gl" , " | awk ' { print $1 }'"
#            CALL g_channel.openPipe(g_cmd, "r")
#            WHILE g_channel.read(g_row_cnt)
#            END WHILE
#            CALL g_channel.close()
 
#            IF g_row_cnt = 0  THEN
#               CALL aws_eftpl2(g_wsd.wsd01)
#            ELSE
#               IF (cl_confirm("aws-070")) THEN
#                  CALL aws_eftpl2(g_wsd.wsd01)
#               ELSE
#                  CONTINUE MENU
#               END IF
#           END IF
 ##### END MOD-490275 #####
 
        ON ACTION EFstation
            LET g_action_choice = "EFstation"
            IF cl_chk_act_auth() THEN
               #---FUN-B30003---start-----
               SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'
               #---FUN-B80090---start-----
               #避免在沒有啟動CROSS整合時,wap_file沒有資料會出現錯誤訊息提示,將下面SQLCA錯誤mark
               #IF SQLCA.SQLCODE THEN
               #   CALL cl_err("wap_file", SQLCA.SQLCODE, 1)   
               #END IF
               #---FUN-B80090---end-------
               IF l_wap02 = "Y" THEN
                  CALL cl_err(NULL,"aws-714", 1) 
                 #CALL cl_cmdrun_wait("aws_crosscfg prod_detail")  #FUN-C20087 mark
               END IF 
               #---FUN-B30003---end-----
               CALL aws_efcfg_station()
            END IF

        #---FUN-B30003---start-----
        ON ACTION ef_services
            LET g_action_choice = "ef_services"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun("aws_efsrv2_list")
            END IF
        #---FUN-B30003---end-----
 
        ON ACTION exit
            EXIT MENU
 
        ON ACTION controlg
            CALL cl_cmdask()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE         #MOD-570244    mars
            EXIT MENU
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
 
         ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
        ON ACTION locale
            CALL cl_dynamic_locale()
 
    END MENU
    CLOSE efcfg2_cs
END FUNCTION
 
FUNCTION efcfg2_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE " "
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_wsd.* LIKE wsd_file.*
    INITIALIZE g_wse.* LIKE wse_file.*
    INITIALIZE g_wsf.* LIKE wsf_file.*
    INITIALIZE g_wsg.* LIKE wsg_file.*
    INITIALIZE g_wsq.* LIKE wsq_file.*                            #FUN-770047
    LET g_wsd01_t = NULL
    LET g_wse01_t = NULL
    LET g_wsf01_t = NULL
    LET g_wsg01_t = NULL
    LET g_wsq01_t = NULL                                          #FUN-770047
 
    LET g_wc = NULL #因為BugNO:4137的原故所以在此要讓g_wc變回NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_wsf.wsf02 = 1
        LET g_wsd.wsduser = g_user
        LET g_wsd.wsdgrup = g_grup               #使用者所屬群
        LET g_wsd.wsddate = g_today
        LET g_wsd.wsdacti = 'Y'
        CALL efcfg2_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_wsd.* TO NULL
            INITIALIZE g_wse.* TO NULL
            INITIALIZE g_wsf.* TO NULL
            INITIALIZE g_wsg.* TO NULL
            INITIALIZE g_wsq.* TO NULL                            #FUN-770047
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_wsd.wsd01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        LET g_wse.wse01=g_wsd.wsd01
        LET g_wsf.wsf01=g_wsd.wsd01
        LET g_wsg.wsg01=g_wsd.wsd01
        LET g_wsq.wsq01=g_wsd.wsd01                               #FUN-770047
 
        BEGIN WORK
 
        LET g_wsd.wsdoriu = g_user      #No.FUN-980030 10/01/04
        LET g_wsd.wsdorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO wsd_file VALUES(g_wsd.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wsd_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155        #FUN-B80064     ADD
            ROLLBACK WORK
#           CALL cl_err(g_wsd.wsd01,SQLCA.sqlcode,0)   #No.FUN-660155
           # CALL cl_err3("ins","wsd_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155       #FUN-B80064     MARK 
            CONTINUE WHILE
        END IF
        INSERT INTO wse_file VALUES(g_wse.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wse_file",g_wse.wse01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155        #FUN-B80064     ADD
            ROLLBACK WORK
#           CALL cl_err(g_wse.wse02,SQLCA.sqlcode,0)   #No.FUN-660155
           # CALL cl_err3("ins","wse_file",g_wse.wse01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155       #FUN-B80064     MARK
            CONTINUE WHILE
        END IF
        IF g_wsf.wsf03 IS NOT NULL THEN
          INSERT INTO wsf_file VALUES(g_wsf.*)
          IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","wsf_file",g_wsf.wsf01,g_wsf.wsf02,SQLCA.sqlcode,"","",0)   #No.FUN-660155      #FUN-B80064     ADD
              ROLLBACK WORK
#             CALL cl_err(g_wsf.wsf03,SQLCA.sqlcode,0)   #No.FUN-660155
             # CALL cl_err3("ins","wsf_file",g_wsf.wsf01,g_wsf.wsf02,SQLCA.sqlcode,"","",0)   #No.FUN-660155     #FUN-B80064     MARK
              CONTINUE WHILE
          END IF
        END IF
        INSERT INTO wsg_file VALUES(g_wsg.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wsg_file",g_wsg.wsg01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155        #FUN-B80064     ADD
            ROLLBACK WORK
#           CALL cl_err(g_wsf.wsf02,SQLCA.sqlcode,0)   #No.FUN-660155
           # CALL cl_err3("ins","wsg_file",g_wsg.wsg01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155       #FUN-B80064     MARK
            CONTINUE WHILE
        END IF
        UPDATE wsi_file SET wsi_file.wsi05 = g_wse.wse03    # 更新DB
            WHERE wsi01 = g_wsd.wsd01 AND wsi02 = g_wse.wse13 AND wsi05 = g_wse_t.wse03
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wsi_file",g_wsd.wsd01,g_wse.wse13,SQLCA.sqlcode,"","",0)   #No.FUN-660155      #FUN-B80064     ADD
            ROLLBACK WORK
#           CALL cl_err(g_wse.wse13,SQLCA.sqlcode,0)   #No.FUN-660155
           # CALL cl_err3("upd","wsi_file",g_wsd.wsd01,g_wse.wse13,SQLCA.sqlcode,"","",0)   #No.FUN-660155     #FUN-B80064     MARK
            CONTINUE WHILE
        END IF
        #FUN-770047
        IF g_wsq.wsq02 IS NOT NULL THEN
          INSERT INTO wsq_file VALUES(g_wsq.*)
          IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","wsq_file",g_wsq.wsq01,g_wsq.wsq02,SQLCA.sqlcode,"","",0)         #FUN-B80064     ADD
              ROLLBACK WORK
             # CALL cl_err3("ins","wsq_file",g_wsq.wsq01,g_wsq.wsq02,SQLCA.sqlcode,"","",0)        #FUN-B80064     MARK
              CONTINUE WHILE
          END IF
        END IF
        #END FUN-770047
 
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION efcfg2_i(p_cmd)
DEFINE p_cmd         LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1)
       l_cnt         LIKE type_file.num5,   #No.FUN-680130 SMALLINT
       #l_zz02         LIKE zz_file.zz02,   #MOD-730038
       l_gaz03         LIKE gaz_file.gaz03,   #MOD-730038
       l_items       STRING,
       l_beforeinput LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE l_message     STRING
DEFINE l_ze03        LIKE ze_file.ze03
DEFINE l_wsf02       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_change      LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_zz01        LIKE zz_file.zz01,     #FUN-5A0207
       l_zz011       LIKE zz_file.zz011     #FUN-5A0207
 
    MESSAGE " "
    DISPLAY BY NAME
        g_wsd.wsd01,g_wsd.wsd02,g_wse.wse02,g_wse.wse03,g_wse.wse04,
        g_wse.wse05,g_wse.wse06,g_wse.wse07,g_wse.wse08,g_wse.wse09,
        g_wse.wse10,g_wse.wse11,g_wse.wse12,g_wse.wse13,
        g_wsf.wsf03,g_wsf.wsf04,g_wsf.wsf05,g_wsf.wsf06,g_wsf.wsf07,
        g_wsf.wsf08,g_wsf.wsf09,g_wsg.wsg02,g_wsg.wsg03,g_wsg.wsg04,
        g_wsg.wsg05,g_wsg.wsg06,g_wsg.wsg07,g_wsg.wsg08,g_wsg.wsg09,g_wsg.wsg10, #FUN-640184
        g_wsq.wsq02,g_wsq.wsq03,g_wsq.wsq04,g_wsq.wsq05,g_wsq.wsq06,g_wsq.wsq07, #FUN-770047
        g_wsd.wsduser,g_wsd.wsdgrup,g_wsd.wsdmodu,g_wsd.wsddate,g_wsd.wsdacti
 
 
    INPUT BY NAME
        g_wsd.wsd01,g_wsd.wsd02,g_wse.wse02,g_wse.wse03,g_wse.wse04,
        g_wse.wse05,g_wse.wse06,g_wse.wse07,g_wse.wse08,g_wse.wse09,
        g_wse.wse10,g_wse.wse11,g_wse.wse12,g_wse.wse13,
        g_wsf.wsf03,g_wsf.wsf04,g_wsf.wsf05,g_wsf.wsf06,g_wsf.wsf07,
        g_wsf.wsf08,g_wsf.wsf09,g_wsg.wsg02,g_wsg.wsg03,g_wsg.wsg04,
        g_wsg.wsg05,g_wsg.wsg06,g_wsg.wsg07,g_wsg.wsg08,g_wsg.wsg09,g_wsg.wsg10, #FUN-640184
        g_wsq.wsq02,g_wsq.wsq03,g_wsq.wsq04,g_wsq.wsq05,g_wsq.wsq06,g_wsq.wsq07, #FUN-770047
        g_wsd.wsdgrup,g_wsd.wsdmodu,g_wsd.wsddate,g_wsd.wsdacti
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        BEFORE INPUT
            CALL cl_set_act_visible("fromowner_ref", FALSE)
            CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
            CALL cl_set_comp_required("wsf03,wsf04,wsq02,wsq03", FALSE) #FUN-770047
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
            IF p_cmd='a' THEN
               LET g_wsd.wsd02 = 'N'
            ELSE
               LET l_beforeinput = "N"
 
               #FUN-5A0207
               SELECT zz011 INTO l_zz011 FROM zz_file where zz01=g_wsd.wsd01
               IF l_zz011 = "APY" OR l_zz011="CPY" OR l_zz011="GPY" THEN
                    CALL cl_set_comp_required("wsg07,wsg08,wsg09", FALSE) 
                    CALL cl_set_comp_entry("wsg10", FALSE)  #FUN-640184 
               ELSE
                    CALL cl_set_comp_entry("wsg10", TRUE)  #FUN-640184 
               END IF
               #END FUN-5A0207
 
               NEXT FIELD wse02
            END IF
 
        BEFORE FIELD wsd01
            IF p_cmd = 'u' AND g_chkey = 'N' THEN
               NEXT FIELD wsd02
            END IF
 
        AFTER FIELD wsd01
            IF g_wsd.wsd01 IS NULL THEN
              #DISPLAY '' TO FORMONLY.zz02   #MOD-730038
              DISPLAY '' TO FORMONLY.gaz03   #MOD-730038
              NEXT FIELD wsd01
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_wsd.wsd01 != g_wsd01_t) THEN
               SELECT zz01,zz011 INTO l_zz01,l_zz011
                  FROM zz_file WHERE zz01 = g_wsd.wsd01   #FUN-5A0207
               IF SQLCA.SQLCODE THEN
                 CALL cl_err(g_wsd.wsd01,NOTFOUND,0)   
                  #DISPLAY '' TO FORMONLY.zz02   #MOD-730038
                  DISPLAY '' TO FORMONLY.gaz03   #MOD-730038
                  NEXT FIELD wsd01
               END IF
               SELECT COUNT(*) INTO l_cnt FROM wsd_file WHERE wsd01 = g_wsd.wsd01
               IF l_cnt > 0 THEN                  # Duplicated
                  CALL cl_err(g_wsd.wsd01,-239,0)
                  #DISPLAY '' TO FORMONLY.zz02   #MOD-730038
                  DISPLAY '' TO FORMONLY.gaz03   #MOD-730038
                  NEXT FIELD wsd01
               END IF
               #CALL efcfg2_zz02(g_wsd.wsd01)   #MOD-730038
               CALL efcfg2_gaz03(g_wsd.wsd01)   #MOD-730038
 
               #FUN-5A0207
               IF l_zz011 = "APY" OR l_zz011="CPY" OR l_zz011="GPY" THEN
                    CALL cl_set_comp_required("wsg07,wsg08,wsg09", FALSE) 
                    CALL cl_set_comp_entry("wsg10", FALSE)  #FUN-640184 
               ELSE
                    CALL cl_set_comp_entry("wsg10", TRUE)  #FUN-640184 
               END IF
               #END FUN-5A0207
            END IF
            LET g_wse.wse01 = g_wsd.wsd01
            LET g_wsf.wsf01 = g_wsd.wsd01
            LET g_wsg.wsg01 = g_wsd.wsd01
            LET g_wsq.wsq01 = g_wsd.wsd01                          #FUN-770047
 
        BEFORE FIELD wse02
            CALL cl_set_act_visible("fromowner_ref", TRUE)
            CALL cl_set_action_active("fromowner_ref", FALSE)
            LET l_change = FALSE
 
        ON CHANGE wse02
            LET l_change = TRUE
 
        AFTER FIELD wse02
            IF g_wse.wse02 IS NULL THEN
               CALL cl_err(NULL,"aws-067", 0)
               NEXT FIELD wse02
            END IF
 
            IF l_change THEN
               IF NOT efcfg2_tab(g_wse.wse02) THEN
                  NEXT FIELD wse02
               END IF
               IF (g_wse.wse02 = g_wsf.wsf03) OR (g_wse.wse02 = g_wsg.wsg02) OR
                  (g_wse.wse02 = g_wsq.wsq02)                      #FUN-770047
               THEN
                  CALL cl_err(g_wse.wse02,-239,0)
                  LET g_wse.wse02 = g_wse_t.wse02                  #FUN-770047
                  NEXT FIELD wse02
               END IF
 
               LET g_gat03 = NULL
               SELECT gat03 INTO g_gat03 FROM gat_file
                 WHERE gat01 = g_wse.wse02
                       AND gat02 = g_lang
               DISPLAY g_gat03 TO FORMONLY.zz03
 
               LET g_wse.wse03 = NULL
               LET g_wse.wse04 = NULL
               LET g_wse.wse05 = NULL
               LET g_wse.wse06 = NULL
               LET g_wse.wse07 = NULL
               LET g_wse.wse08 = NULL
               LET g_wse.wse09 = NULL
               LET g_wse.wse10 = NULL
               LET g_wse.wse11 = NULL
               LET g_wse.wse12 = NULL
               LET g_wse.wse13 = NULL
               DELETE FROM wsi_file where wsi01 = g_wse.wse01
                  AND wsi02 = g_wse_t.wse02 AND wsi05 = g_wse_t.wse03
               LET l_items = efcfg2_combobox(g_wse.wse02)
               CALL cl_set_combo_items("wse03",l_items,l_items)
               CALL cl_set_combo_items("wse04",l_items,l_items)
               CALL cl_set_combo_items("wse05",l_items,l_items)
               CALL cl_set_combo_items("wse06",l_items,l_items)
               CALL cl_set_combo_items("wse07",l_items,l_items)
               CALL cl_set_combo_items("wse08",l_items,l_items)
               CALL cl_set_combo_items("wse09",l_items,l_items)
               CALL cl_set_combo_items("wse10",l_items,l_items)
               CALL cl_set_combo_items("wse11",l_items,l_items)
               CALL cl_set_combo_items("wse12",l_items,l_items)
               CALL efcfg2_set_no_entry()
               CALL efcfg2_set_entry()
            END IF
 
        ON CHANGE wse03
            IF g_wse.wse03 IS NOT NULL THEN
               CALL cl_set_comp_entry("wse04", TRUE)
            ELSE
               LET g_wse.wse04 = NULL
               LET g_wse.wse05 = NULL
               LET g_wse.wse06 = NULL
               LET g_wse.wse07 = NULL
               CALL cl_set_comp_entry("wse04", FALSE)
               CALL cl_set_comp_entry("wse05", FALSE)
               CALL cl_set_comp_entry("wse06", FALSE)
               CALL cl_set_comp_entry("wse07", FALSE)
            END IF
 
        AFTER FIELD wse03
            IF g_wse.wse03 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse03) THEN
                  CALL cl_err(g_wse.wse03,-239,0)
                  NEXT FIELD wse03
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wse04
            IF g_wse.wse04 IS NOT NULL THEN
               CALL cl_set_comp_entry("wse05", TRUE)
            ELSE
               LET g_wse.wse05 = NULL
               LET g_wse.wse06 = NULL
               LET g_wse.wse07 = NULL
               CALL cl_set_comp_entry("wse05", FALSE)
               CALL cl_set_comp_entry("wse06", FALSE)
               CALL cl_set_comp_entry("wse07", FALSE)
            END IF
 
        AFTER FIELD wse04
            IF g_wse.wse04 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse04) THEN
                     CALL cl_err(g_wse.wse04,-239,0)
                     NEXT FIELD wse04
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wse05
            IF g_wse.wse05 IS NOT NULL THEN
               CALL cl_set_comp_entry("wse06", TRUE)
            ELSE
               LET g_wse.wse06 = NULL
               LET g_wse.wse07 = NULL
               CALL cl_set_comp_entry("wse06", FALSE)
               CALL cl_set_comp_entry("wse07", FALSE)
            END IF
 
        AFTER FIELD wse05
            IF g_wse.wse05 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse05) THEN
                     CALL cl_err(g_wse.wse05,-239,0)
                     NEXT FIELD wse05
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wse06
            IF g_wse.wse06 IS NOT NULL THEN
               CALL cl_set_comp_entry("wse07", TRUE)
            ELSE
               LET g_wse.wse07 = NULL
               CALL cl_set_comp_entry("wse07", FALSE)
            END IF
 
        AFTER FIELD wse06
            IF g_wse.wse06 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse06) THEN
                     CALL cl_err(g_wse.wse06,-239,0)
                     NEXT FIELD wse07
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        AFTER FIELD wse07
            IF g_wse.wse07 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse07) THEN
                     CALL cl_err(g_wse.wse07,-239,0)
                     NEXT FIELD wse07
               END IF
            END IF
 
        AFTER FIELD wse08
            IF g_wse.wse08 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse08) THEN
                     CALL cl_err(g_wse.wse08,-239,0)
                     NEXT FIELD wse08
               END IF
            END IF
 
        AFTER FIELD wse09
            IF g_wse.wse09 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse09) THEN
                     CALL cl_err(g_wse.wse09,-239,0)
                     NEXT FIELD wse09
               END IF
            END IF
 
        AFTER FIELD wse10
            IF g_wse.wse10 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse10) THEN
                     CALL cl_err(g_wse.wse10,-239,0)
                     NEXT FIELD wse10
               END IF
            END IF
 
        AFTER FIELD wse11
            IF g_wse.wse11 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse11) THEN
                     CALL cl_err(g_wse.wse11,-239,0)
                     NEXT FIELD wse11
               END IF
            END IF
 
        AFTER FIELD wse12
            IF g_wse.wse12 IS NOT NULL THEN
               IF NOT efcfg2_field_wse(g_wse.wse12) THEN
                  #FUN-5A0207
                  #IF g_wse.wse13 != g_wse.wse12 THEN
                     CALL cl_err(g_wse.wse12,-239,0)
                     NEXT FIELD wse12
                  #END IF
                  #END FUN-5A0207
               END IF
            END IF
 
        BEFORE FIELD wse13
            CALL cl_set_act_visible("fromowner_ref", TRUE)
            CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
            CALL cl_set_action_active("fromowner_ref", TRUE)
 
        AFTER FIELD wse13
            CALL cl_set_action_active("fromowner_ref", FALSE)
            IF g_wse.wse13 IS NOT NULL THEN
               #FUN-5A0207
               #IF NOT efcfg2_field_wse(g_wse.wse13) THEN
               #   IF g_wse.wse13 != g_wse.wse12 THEN
               #      CALL cl_err(g_wse.wse13,-239,0)
               #      NEXT FIELD wse13
               #   END IF
               #END IF
               #END FUN-5A0207
               IF NOT efcfg2_col(g_wse.wse13,g_wse.wse02) THEN
                     MESSAGE ' '
                     SELECT COUNT(*) INTO l_cnt from wsi_file where wsi01=g_wse.wse01
                        AND wsi02 = g_wse_t.wse13 AND wsi05 = g_wse_t.wse03
                     IF l_cnt = 0 OR g_wse.wse13 != g_wse_t.wse13 THEN
                         CALL fromowner_ref('E',g_wse.wse13,g_wse_t.wse13,g_wse.wse03,g_wse_t.wse03)
                         NEXT FIELD wse13
                     END IF
               ELSE
                     DELETE FROM wsi_file where wsi01 = g_wse.wse01
                        AND wsi02 = g_wse_t.wse02 AND wsi05 = g_wse_t.wse03
               END IF
            END IF
 
        BEFORE FIELD wsf03
            LET l_wsf02 = 0
            CALL cl_set_act_visible("fromowner_ref", FALSE)
            CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", TRUE)
            SELECT MAX(wsf02) INTO l_wsf02 FROM wsf_file where wsf01 = g_wsf.wsf01
            IF l_wsf02 IS NULL THEN
               LET l_wsf02 = 0
            END IF
            CASE l_wsf02
                WHEN 0
                     CALL cl_set_action_active("aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
                WHEN 1
                     CALL cl_set_action_active("aws_detail3,aws_detail4,aws_detail5", FALSE)
                WHEN 2
                     CALL cl_set_action_active("aws_detail4,aws_detail5", FALSE)
                WHEN 3
                     CALL cl_set_action_active("aws_detail5", FALSE)
            END CASE
            LET l_change = FALSE
 
        ON CHANGE wsf03
            LET l_change = TRUE
 
        AFTER FIELD wsf03
            IF g_wsf.wsf03 IS NOT NULL THEN
               IF l_change THEN
                  IF NOT efcfg2_tab(g_wsf.wsf03) THEN
                     NEXT FIELD wsf03
                  END IF
                  IF (g_wse.wse02=g_wsf.wsf03) OR (g_wsf.wsf03=g_wsg.wsg02) OR
                     (g_wsg.wsg02=g_wsq.wsq02)                    #FUN-770047
                  THEN
                      CALL cl_err(g_wsf.wsf03,-239,0)
                      LET g_wsf.wsf03 = g_wsf_t.wsf03               #FUN-770047
                      NEXT FIELD wsf03
                  END IF
 
                  SELECT COUNT(*) INTO l_cnt FROM wsf_file
                   WHERE wsf01 = g_wsf.wsf01 AND wsf03 = g_wsf.wsf03
                  IF l_cnt > 0 THEN
                      CALL cl_err(g_wsf.wsf03,-239,0)
                      NEXT FIELD wsf03
                  END IF
 
                  LET g_gat03 = NULL
                  SELECT gat03 INTO g_gat03 FROM gat_file
                    WHERE gat01 = g_wsf.wsf03
                          AND gat02 = g_lang
                  DISPLAY g_gat03 TO FORMONLY.zz04
 
                  LET g_wsf.wsf04 = NULL
                  LET g_wsf.wsf05 = NULL
                  LET g_wsf.wsf06 = NULL
                  LET g_wsf.wsf07 = NULL
                  LET g_wsf.wsf08 = NULL
                  LET g_wsf.wsf09 = NULL
                  LET l_items = efcfg2_combobox(g_wsf.wsf03)
                  CALL cl_set_combo_items("wsf04",l_items,l_items)
                  CALL cl_set_combo_items("wsf05",l_items,l_items)
                  CALL cl_set_combo_items("wsf06",l_items,l_items)
                  CALL cl_set_combo_items("wsf07",l_items,l_items)
                  CALL cl_set_combo_items("wsf08",l_items,l_items)
                  CALL cl_set_combo_items("wsf09",l_items,l_items)
               END IF
               CALL cl_set_comp_required("wsf04", TRUE)            #FUN-770047
            ELSE
               LET g_wsf.wsf04 = NULL
               LET g_wsf.wsf05 = NULL
               LET g_wsf.wsf06 = NULL
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               LET g_wsf.wsf09 = NULL
               CALL cl_set_combo_items("wsf04",NULL,NULL)
               CALL cl_set_combo_items("wsf05",NULL,NULL)
               CALL cl_set_combo_items("wsf06",NULL,NULL)
               CALL cl_set_combo_items("wsf07",NULL,NULL)
               CALL cl_set_combo_items("wsf08",NULL,NULL)
               CALL cl_set_combo_items("wsf09",NULL,NULL)
               CALL cl_set_comp_required("wsf04", FALSE)            #FUN-770047
               DISPLAY "" TO FORMONLY.zz04                          #FUN-770047
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf04
            IF g_wsf.wsf04 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf05", TRUE)
            ELSE
               LET g_wsf.wsf05 = NULL
               LET g_wsf.wsf06 = NULL
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf05", FALSE)
               CALL cl_set_comp_entry("wsf06", FALSE)
               CALL cl_set_comp_entry("wsf07", FALSE)
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf04
            IF g_wsf.wsf04 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf04) THEN
                  CALL cl_err(g_wsf.wsf04,-239,0)
                  NEXT FIELD wsf04
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf05
            IF g_wsf.wsf05 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf06", TRUE)
            ELSE
               LET g_wsf.wsf06 = NULL
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf06", FALSE)
               CALL cl_set_comp_entry("wsf07", FALSE)
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf05
            IF g_wsf.wsf05 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf05) THEN
                  CALL cl_err(g_wsf.wsf05,-239,0)
                  NEXT FIELD wsf05
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf06
            IF g_wsf.wsf06 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf07", TRUE)
            ELSE
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf07", FALSE)
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf06
            IF g_wsf.wsf06 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf06) THEN
                  CALL cl_err(g_wsf.wsf06,-239,0)
                  NEXT FIELD wsf06
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf07
            IF g_wsf.wsf07 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf08", TRUE)
            ELSE
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf07
            IF g_wsf.wsf07 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf07) THEN
                  CALL cl_err(g_wsf.wsf07,-239,0)
                  NEXT FIELD wsf07
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        AFTER FIELD wsf08
            IF g_wsf.wsf08 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf08) THEN
                  CALL cl_err(g_wsf.wsf08,-239,0)
                  NEXT FIELD wsf08
               END IF
            END IF
 
        BEFORE FIELD wsf09
            LET l_wsf02 = 0
            CALL cl_set_act_visible("fromowner_ref", FALSE)
            CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", TRUE)
            SELECT MAX(wsf02) INTO l_wsf02 FROM wsf_file where wsf01 = g_wsf.wsf01
            IF l_wsf02 IS NULL THEN
               LET l_wsf02 = 0
            END IF
            CASE l_wsf02
                WHEN 0
                     CALL cl_set_action_active("aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
                WHEN 1
                     CALL cl_set_action_active("aws_detail3,aws_detail4,aws_detail5", FALSE)
                WHEN 2
                     CALL cl_set_action_active("aws_detail4,aws_detail5", FALSE)
                WHEN 3
                     CALL cl_set_action_active("aws_detail5", FALSE)
            END CASE
 
        AFTER FIELD wsf09
            IF g_wsf.wsf09 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf09) THEN
                  CALL cl_err(g_wsf.wsf09,-239,0)
                  NEXT FIELD wsf09
               END IF
            END IF
 
        BEFORE FIELD wsg02
            CALL cl_set_act_visible("fromowner_ref,aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
            LET l_change = FALSE
 
        ON CHANGE wsg02
            LET l_change = TRUE
 
        AFTER FIELD wsg02
            IF g_wsg.wsg02 IS NULL THEN
               CALL cl_err(NULL,"aws-067", 0)
               NEXT FIELD wsg02
            END IF
 
            IF l_change THEN
               IF NOT efcfg2_tab(g_wsg.wsg02) THEN
                  NEXT FIELD wsg02
               END IF
               IF (g_wsg.wsg02 = g_wsf.wsf03) OR (g_wsg.wsg02 = g_wse.wse02) OR
                  (g_wsg.wsg02 = g_wsq.wsq02)                      #FUN-770047
               THEN
                  CALL cl_err(g_wsg.wsg02,-239,0)
                  LET g_wsg.wsg02 = g_wsg_t.wsg02               #FUN-770047
                  NEXT FIELD wsg02
               END IF
 
               LET g_gat03 = NULL
               SELECT gat03 INTO g_gat03 FROM gat_file
                 WHERE gat01 = g_wsg.wsg02
                       AND gat02 = g_lang
               DISPLAY g_gat03 TO FORMONLY.zz05
 
               LET g_wsg.wsg03 = NULL
               LET g_wsg.wsg04 = NULL
               LET g_wsg.wsg05 = NULL
               LET g_wsg.wsg06 = NULL
               LET g_wsg.wsg07 = NULL
               LET g_wsg.wsg08 = NULL
               LET g_wsg.wsg09 = NULL
               LET g_wsg.wsg10 = NULL                            #FUN-640184
               LET l_items = efcfg2_combobox(g_wsg.wsg02)
               CALL cl_set_combo_items("wsg03",l_items,l_items)
               CALL cl_set_combo_items("wsg04",l_items,l_items)
               CALL cl_set_combo_items("wsg05",l_items,l_items)
               CALL cl_set_combo_items("wsg07",l_items,l_items)
               CALL cl_set_combo_items("wsg09",l_items,l_items)
               CALL cl_set_combo_items("wsg10",l_items,l_items)  #FUN-640184
            END IF
 
        AFTER FIELD wsg03
            IF g_wsg.wsg03 IS NOT NULL THEN
               IF NOT efcfg2_field_wsg(g_wsg.wsg03) THEN
                  CALL cl_err(g_wsg.wsg03,-239,0)
                  NEXT FIELD wsg03
               END IF
            END IF
 
        AFTER FIELD wsg04
            IF g_wsg.wsg04 IS NOT NULL THEN
               IF NOT efcfg2_field_wsg(g_wsg.wsg04) THEN
                  CALL cl_err(g_wsg.wsg04,-239,0)
                  NEXT FIELD wsg04
               END IF
            END IF
 
        ON CHANGE wsg05
            IF g_wsg.wsg05 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsg06", TRUE)
            ELSE
               LET g_wsg.wsg06 = NULL
               CALL cl_set_comp_entry("wsg06", FALSE)
            END IF
 
        AFTER FIELD wsg05
            IF g_wsg.wsg05 IS NOT NULL THEN
               IF NOT efcfg2_field_wsg(g_wsg.wsg05) THEN
                  CALL cl_err(g_wsg.wsg05,-239,0)
                  NEXT FIELD wsg05
               END IF
               IF g_wsg.wsg06 IS NULL THEN
                  NEXT FIELD wsg06
               END IF
            END IF
 
        AFTER FIELD wsg06
           IF g_wsg.wsg06 IS NULL AND g_wsg.wsg05 IS NOT NULL THEN
              NEXT FIELD wsg06
           END IF
 
        AFTER FIELD wsg07
            IF g_wsg.wsg07 IS NOT NULL THEN
               IF NOT efcfg2_field_wsg(g_wsg.wsg07) THEN
                     CALL cl_err(g_wsg.wsg07,-239,0)
                     NEXT FIELD wsg07
               END IF
            END IF
 
        #FUN-5A0207
        AFTER FIELD wsg08
            IF g_wsg.wsg08 IS NOT NULL AND g_wsg.wsg07 IS NULL THEN
               NEXT FIELD wsg07
            END IF
        #END FUN-5A0207
 
        AFTER FIELD wsg09
            IF g_wsg.wsg09 IS NOT NULL THEN
               IF NOT efcfg2_field_wsg(g_wsg.wsg09) THEN
                     CALL cl_err(g_wsg.wsg09,-239,0)
                     NEXT FIELD wsg09
               END IF
            END IF
 
        #FUN-640184
        AFTER FIELD wsg10
            IF g_wsg.wsg10 IS NOT NULL THEN
               IF NOT efcfg2_field_wsg(g_wsg.wsg10) THEN
                     CALL cl_err(g_wsg.wsg10,-239,0)
                     NEXT FIELD wsg10
               END IF
            END IF
        #END FUN-640184
 
        #FUN-770047
        BEFORE FIELD wsq02
            CALL cl_set_act_visible("fromowner_ref,aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
            LET l_change = FALSE
 
        ON CHANGE wsq02
            LET l_change = TRUE
 
        AFTER FIELD wsq02
            IF g_wsq.wsq02 IS NOT NULL THEN
               IF l_change THEN
                  IF NOT efcfg2_tab(g_wsq.wsq02) THEN
                     NEXT FIELD wsq02
                  END IF
                  IF (g_wse.wse02=g_wsq.wsq02) OR (g_wsq.wsq02=g_wsg.wsg02) OR
                     (g_wsq.wsq02=g_wsf.wsf03) 
                  THEN
                      CALL cl_err(g_wsq.wsq02,-239,0)
                      LET g_wsq.wsq02 = g_wsq_t.wsq02               #FUN-770047
                      NEXT FIELD wsq02
                  END IF
 
                  SELECT COUNT(*) INTO l_cnt FROM wsq_file
                   WHERE wsq01 = g_wsq.wsq01 AND wsq02 = g_wsq.wsq02
                  IF l_cnt > 0 THEN
                      CALL cl_err(g_wsq.wsq02,-239,0)
                      LET g_wsq.wsq02 = g_wsq_t.wsq02               #FUN-770047
                      NEXT FIELD wsq02
                  END IF
 
                  LET g_gat03 = efcfg2_gat03(g_wsq.wsq02)
                  DISPLAY g_gat03 TO FORMONLY.zz06
 
                  LET g_wsq.wsq03 = NULL
                  LET g_wsq.wsq04 = NULL
                  LET g_wsq.wsq05 = NULL
                  LET g_wsq.wsq06 = NULL
                  LET g_wsq.wsq07 = NULL
                  LET l_items = efcfg2_combobox(g_wsq.wsq02)
                  CALL cl_set_combo_items("wsq03",l_items,l_items)
                  CALL cl_set_combo_items("wsq04",l_items,l_items)
                  CALL cl_set_combo_items("wsq05",l_items,l_items)
                  CALL cl_set_combo_items("wsq06",l_items,l_items)
                  CALL cl_set_combo_items("wsq07",l_items,l_items)
               END IF
               CALL cl_set_comp_required("wsq03", TRUE)            #FUN-770047
            ELSE
               LET g_wsq.wsq03 = NULL
               LET g_wsq.wsq04 = NULL
               LET g_wsq.wsq05 = NULL
               LET g_wsq.wsq06 = NULL
               LET g_wsq.wsq07 = NULL
               CALL cl_set_combo_items("wsq03",NULL,NULL)
               CALL cl_set_combo_items("wsq04",NULL,NULL)
               CALL cl_set_combo_items("wsq05",NULL,NULL)
               CALL cl_set_combo_items("wsq06",NULL,NULL)
               CALL cl_set_combo_items("wsq07",NULL,NULL)
               CALL cl_set_comp_required("wsq03", FALSE)            #FUN-770047
               DISPLAY "" TO FORMONLY.zz06                          #FUN-770047  
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsq03
            IF g_wsq.wsq03 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsq04", TRUE)
            ELSE
               LET g_wsq.wsq04 = NULL
               LET g_wsq.wsq05 = NULL
               LET g_wsq.wsq06 = NULL
               LET g_wsq.wsq07 = NULL
               CALL cl_set_comp_entry("wsq04", FALSE)
               CALL cl_set_comp_entry("wsq05", FALSE)
               CALL cl_set_comp_entry("wsq06", FALSE)
               CALL cl_set_comp_entry("wsq07", FALSE)
            END IF
 
        AFTER FIELD wsq03
            IF g_wsq.wsq03 IS NOT NULL THEN
               IF NOT efcfg2_field_wsq(g_wsq.wsq03) THEN
                  CALL cl_err(g_wsq.wsq03,-239,0)
                  NEXT FIELD wsq03
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsq04
            IF g_wsq.wsq04 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsq05", TRUE)
            ELSE
               LET g_wsq.wsq05 = NULL
               LET g_wsq.wsq06 = NULL
               LET g_wsq.wsq07 = NULL
               CALL cl_set_comp_entry("wsq05", FALSE)
               CALL cl_set_comp_entry("wsq06", FALSE)
               CALL cl_set_comp_entry("wsq07", FALSE)
            END IF
 
        AFTER FIELD wsq04
            IF g_wsq.wsq04 IS NOT NULL THEN
               IF NOT efcfg2_field_wsq(g_wsq.wsq04) THEN
                     CALL cl_err(g_wsq.wsq04,-239,0)
                     NEXT FIELD wsq04
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsq05
            IF g_wsq.wsq05 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsq06", TRUE)
            ELSE
               LET g_wsq.wsq06 = NULL
               LET g_wsq.wsq07 = NULL
               CALL cl_set_comp_entry("wsq06", FALSE)
               CALL cl_set_comp_entry("wsq07", FALSE)
            END IF
 
        AFTER FIELD wsq05
            IF g_wsq.wsq05 IS NOT NULL THEN
               IF NOT efcfg2_field_wsq(g_wsq.wsq05) THEN
                     CALL cl_err(g_wsq.wsq05,-239,0)
                     NEXT FIELD wsq05
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsq06
            IF g_wsq.wsq06 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsq07", TRUE)
            ELSE
               LET g_wsq.wsq07 = NULL
               CALL cl_set_comp_entry("wsq07", FALSE)
            END IF
 
        AFTER FIELD wsq06
            IF g_wsq.wsq06 IS NOT NULL THEN
               IF NOT efcfg2_field_wsq(g_wsq.wsq06) THEN
                     CALL cl_err(g_wsq.wsq06,-239,0)
                     NEXT FIELD wsq07
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        AFTER FIELD wsq07
            IF g_wsq.wsq07 IS NOT NULL THEN
               IF NOT efcfg2_field_wsq(g_wsq.wsq07) THEN
                     CALL cl_err(g_wsq.wsq07,-239,0)
                     NEXT FIELD wsq07
               END IF
            END IF
        #END FUN-770047
 
        AFTER INPUT
               IF INT_FLAG THEN                            # 使用者不玩了
                   EXIT INPUT
               END IF
               IF g_wsf.wsf03 IS NULL THEN
                  INITIALIZE g_wsf.* TO NULL
               END IF
 
               #FUN-770047
               IF g_wsq.wsq02 IS NULL THEN
                  INITIALIZE g_wsq.* TO NULL
               END IF
               #END FUN-770047
 
               #FUN-5A0207
               IF g_wsg.wsg08 IS NOT NULL AND g_wsg.wsg07 IS NULL THEN
                  NEXT FIELD wsg07
               END IF
               #END FUN-5A0207
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wsd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz1"
                  LET g_qryparam.default1 = g_wsd.wsd01
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  #CALL cl_create_qry() RETURNING g_wsd.wsd01,g_zz02   #MOD-730038
                  CALL cl_create_qry() RETURNING g_wsd.wsd01,g_gaz03   #MOD-730038
                  DISPLAY BY NAME g_wsd.wsd01
                  #DISPLAY g_zz02 TO FORMONLY.zz02   #MOD-730038
                  DISPLAY g_gaz03 TO FORMONLY.gaz03   #MOD-730038
                WHEN INFIELD(wse02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wse.wse02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wse.wse02,g_zz03
                  DISPLAY BY NAME g_wse.wse02
                  DISPLAY g_zz03 TO FORMONLY.zz03
                WHEN INFIELD(wsf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsf.wsf03
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsf.wsf03,g_zz04
                  DISPLAY BY NAME g_wsf.wsf03
                  DISPLAY g_zz04 TO FORMONLY.zz04
                WHEN INFIELD(wsg02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsg.wsg02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsg.wsg02,l_zz05
                  DISPLAY BY NAME g_wsg.wsg02
                  DISPLAY l_zz05 TO FORMONLY.zz05
                #FUN-770047
                WHEN INFIELD(wsq02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsq.wsq02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsq.wsq02,g_zz06
                  DISPLAY BY NAME g_wsq.wsq02
                  DISPLAY g_zz06 TO FORMONLY.zz06
                #END FUN-770047
            END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION aws_master
               CALL cl_set_act_visible("fromowner_ref", TRUE)
               CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
               IF NOT INFIELD(wse13) THEN
                  CALL cl_set_action_active("fromowner_ref", FALSE)
               END IF
 
       ON ACTION aws_detail
               LET l_wsf02 = 0
               CALL cl_set_act_visible("fromowner_ref", FALSE)
               CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", TRUE)
               SELECT MAX(wsf02) INTO l_wsf02 FROM wsf_file where wsf01 = g_wsf.wsf01
               IF l_wsf02 IS NULL THEN
                  LET l_wsf02 = 0
               END IF
               CASE l_wsf02
                   WHEN 0
                        CALL cl_set_action_active("aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
                   WHEN 1
                        CALL cl_set_action_active("aws_detail3,aws_detail4,aws_detail5", FALSE)
                   WHEN 2
                        CALL cl_set_action_active("aws_detail4,aws_detail5", FALSE)
                   WHEN 3
                        CALL cl_set_action_active("aws_detail5", FALSE)
               END CASE
 
       ON ACTION aws_document
               CALL cl_set_act_visible("fromowner_ref,aws_detail2,aws_detail3,aws_detail4,aws_detail5", FALSE)
 
       ON ACTION fromowner_ref
          IF NOT efcfg2_col(g_wse.wse13,g_wse.wse02) THEN
              MESSAGE ' '
              CALL fromowner_ref('E',g_wse.wse13,g_wse_t.wse13,g_wse.wse03,g_wse_t.wse03)
          END IF
 
 
       ON ACTION aws_detail2
          CALL aws_set_detail(2)
          LET l_wsf02 = 0
          CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", TRUE)
          SELECT MAX(wsf02) INTO l_wsf02 FROM wsf_file where wsf01 = g_wsf.wsf01
          IF l_wsf02 IS NULL THEN
             LET l_wsf02 = 0
          END IF
          CASE l_wsf02
              WHEN 1
                   CALL cl_set_action_active("aws_detail3,aws_detail4,aws_detail5", FALSE)
              WHEN 2
                   CALL cl_set_action_active("aws_detail4,aws_detail5", FALSE)
              WHEN 3
                   CALL cl_set_action_active("aws_detail5", FALSE)
          END CASE
 
       ON ACTION aws_detail3
          CALL aws_set_detail(3)
          LET l_wsf02 = 0
          CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", TRUE)
          SELECT MAX(wsf02) INTO l_wsf02 FROM wsf_file where wsf01 = g_wsf.wsf01
          IF l_wsf02 IS NULL THEN
             LET l_wsf02 = 0
          END IF
          CASE l_wsf02
              WHEN 2
                   CALL cl_set_action_active("aws_detail4,aws_detail5", FALSE)
              WHEN 3
                   CALL cl_set_action_active("aws_detail5", FALSE)
          END CASE
 
       ON ACTION aws_detail4
          CALL aws_set_detail(4)
          LET l_wsf02 = 0
          CALL cl_set_act_visible("aws_detail2,aws_detail3,aws_detail4,aws_detail5", TRUE)
          SELECT MAX(wsf02) INTO l_wsf02 FROM wsf_file where wsf01 = g_wsf.wsf01
          IF l_wsf02 IS NULL THEN
             LET l_wsf02 = 0
          END IF
          CASE l_wsf02
              WHEN 3
                   CALL cl_set_action_active("aws_detail5", FALSE)
          END CASE
 
       ON ACTION aws_detail5
          CALL aws_set_detail(5)
 
       ON ACTION controlg
           CALL cl_cmdask()
 
       #TQC-860022
       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
       #END TQC-860022
 
    END INPUT
    CALL cl_set_comp_required("wsg07,wsg08,wsg09", TRUE)    #FUN-5A0207 
 
END FUNCTION
 
FUNCTION efcfg2_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL efcfg2_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
 
    OPEN efcfg2_count
    FETCH efcfg2_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt #ATTRIBUTE(MAGENTA)
 
    OPEN efcfg2_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_wsd.wsd01,SQLCA.sqlcode,0)
        INITIALIZE g_wsd.* TO NULL
    ELSE
        CALL efcfg2_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION efcfg2_fetch(p_flwse)
    DEFINE
        p_flwse         LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
    INITIALIZE g_wsd.* TO NULL
    INITIALIZE g_wse.* TO NULL
    INITIALIZE g_wsf.* TO NULL
    INITIALIZE g_wsg.* TO NULL
    INITIALIZE g_wsq.* TO NULL                                    #FUN-770047
 
    CASE p_flwse
        WHEN 'N' FETCH NEXT     efcfg2_cs INTO g_wsd.wsd01
        WHEN 'P' FETCH PREVIOUS efcfg2_cs INTO g_wsd.wsd01
        WHEN 'F' FETCH FIRST    efcfg2_cs INTO g_wsd.wsd01
        WHEN 'L' FETCH LAST     efcfg2_cs INTO g_wsd.wsd01
        WHEN '/' IF (NOT mi_no_ask) THEN    #No.FUN-6A0075
                    CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
 
                    PROMPT g_msg CLIPPED,': ' FOR g_jump
                        ON IDLE g_idle_seconds
                            CALL cl_on_idle()
 
                         ON ACTION about         #MOD-4C0121
                              CALL cl_about()      #MOD-4C0121
 
                         ON ACTION help          #MOD-4C0121
                              CALL cl_show_help()  #MOD-4C0121
 
                         ON ACTION controlg      #MOD-4C0121
                              CALL cl_cmdask()     #MOD-4C0121
 
                    END PROMPT
                    IF INT_FLAG THEN
                        LET INT_FLAG = 0
                        EXIT CASE
                    END IF
                 END IF
 
                 FETCH ABSOLUTE g_jump efcfg2_cs INTO g_wsd.wsd01
                 LET mi_no_ask = FALSE   #No.FUN-6A0075
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(NULL,SQLCA.sqlcode,0)
        INITIALIZE g_wsd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
        CASE p_flwse
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
        END CASE
        CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
     SELECT * INTO g_wsd.* FROM wsd_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsd01=g_wsd.wsd01
     SELECT * INTO g_wse.* FROM wse_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wse01=g_wsd.wsd01
     SELECT * INTO g_wsf.* FROM wsf_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsf01=g_wsd.wsd01 AND wsf02=1
     SELECT * INTO g_wsq.* FROM wsq_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsq01=g_wsd.wsd01              #FUN-770047
     SELECT * INTO g_wsg.* FROM wsg_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsg01=g_wsd.wsd01
 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wsd.wsd01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","wsg_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
    ELSE
        CALL efcfg2_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION efcfg2_show()
 
    LET g_wsd_t.* = g_wsd.*
    LET g_wse_t.* = g_wse.*
    LET g_wsf_t.* = g_wsf.*
    LET g_wsg_t.* = g_wsg.*
    LET g_wsq_t.* = g_wsq.*                                       #FUN-770047
 
    LET g_beforeinput = "FALSE"
    CALL efcfg2_combo_list()
    LET g_beforeinput = "TRUE"
    DISPLAY BY NAME
        g_wsd.wsd01,g_wsd.wsd02,g_wse.wse02,g_wse.wse03,g_wse.wse04,
        g_wse.wse05,g_wse.wse06,g_wse.wse07,g_wse.wse08,g_wse.wse09,
        g_wse.wse10,g_wse.wse11,g_wse.wse12,g_wse.wse13,
        g_wsf.wsf03,g_wsf.wsf04,g_wsf.wsf05,g_wsf.wsf06,g_wsf.wsf07,
        g_wsf.wsf08,g_wsf.wsf09,g_wsg.wsg02,g_wsg.wsg03,g_wsg.wsg04,
        g_wsg.wsg05,g_wsg.wsg07,g_wsg.wsg06,g_wsg.wsg08,g_wsg.wsg09,g_wsg.wsg10, #FUN-640184
        g_wsq.wsq02,g_wsq.wsq03,g_wsq.wsq04,g_wsq.wsq05,g_wsq.wsq06,g_wsq.wsq07, #FUN-770047
        g_wsd.wsduser,g_wsd.wsdgrup,g_wsd.wsdmodu,g_wsd.wsddate,g_wsd.wsdacti
 
    #CALL efcfg2_zz02(g_wsd.wsd01)   #MOD-730038
    CALL efcfg2_gaz03(g_wsd.wsd01)   #MOD-730038
    LET g_gat03 = ""
    IF g_wse.wse02 IS NOT NULL OR g_wse.wse02 <> "" THEN
       #FUN-770047
       #LET g_gat03 = NULL
       #SELECT gat03 INTO g_gat03 FROM gat_file
       #  WHERE gat01 = g_wse.wse02
       #        AND gat02 = g_lang
       LET g_gat03 = efcfg2_gat03(g_wse.wse02)
       #END FUN-770047
       DISPLAY g_gat03 TO FORMONLY.zz03
    ELSE
       DISPLAY "" TO FORMONLY.zz03
    END IF
 
    IF g_wsf.wsf03 IS NOT NULL OR g_wsf.wsf03 <> "" THEN
       #FUN-770047
       #LET g_gat03 = NULL
       #SELECT gat03 INTO g_gat03 FROM gat_file
       #  WHERE gat01 = g_wsf.wsf03
       #        AND gat02 = g_lang
        LET g_gat03 = efcfg2_gat03(g_wsf.wsf03)
       #END FUN-770047
        DISPLAY g_gat03 TO FORMONLY.zz04
    ELSE
       DISPLAY "" TO FORMONLY.zz04
    END IF
 
    IF g_wsg.wsg02 IS NOT NULL OR g_wsg.wsg02 <> "" THEN
       #FUN-770047
       #LET g_gat03 = NULL
       #SELECT gat03 INTO g_gat03 FROM gat_file
       #  WHERE gat01 = g_wsg.wsg02
       #        AND gat02 = g_lang
        LET g_gat03 = efcfg2_gat03(g_wsg.wsg02)
       #END FUN-770047
        DISPLAY g_gat03 TO FORMONLY.zz05
    ELSE
       DISPLAY "" TO FORMONLY.zz05
    END IF
 
    #FUN-770047
    IF g_wsq.wsq02 IS NOT NULL OR g_wsq.wsq02 <> "" THEN
       LET g_gat03 = efcfg2_gat03(g_wsq.wsq02)
       DISPLAY g_gat03 TO FORMONLY.zz06
    ELSE
       DISPLAY "" TO FORMONLY.zz06
    END IF
    #END FUN-770047
 
END FUNCTION
 
#FUN-770047
FUNCTION efcfg2_gat03(p_gat01)
DEFINE p_gat01  LIKE gat_file.gat01
 
 LET g_gat03 = NULL
 SELECT gat03 INTO g_gat03 FROM gat_file
   WHERE gat01 = p_gat01 AND gat02 = g_lang
 RETURN g_gat03
 
END FUNCTION
#END FUN-770047
 
#-----MOD-730038---------
#FUNCTION efcfg2_zz02(p_wsd01)
#    DEFINE l_zz02 LIKE zz_file.zz02
#    DEFINE p_wsd01 LIKE wsd_file.wsd01
#    SELECT zz02 INTO l_zz02 FROM zz_file WHERE zz01 = p_wsd01
#    DISPLAY l_zz02 TO FORMONLY.zz02
#END FUNCTION
FUNCTION efcfg2_gaz03(p_wsd01)
    DEFINE l_gaz03 LIKE gaz_file.gaz03
    DEFINE p_wsd01 LIKE wsd_file.wsd01
    SELECT gaz03 INTO l_gaz03 FROM gaz_file WHERE gaz01 = p_wsd01 AND gaz02=g_lang
    DISPLAY l_gaz03 TO FORMONLY.gaz03
END FUNCTION
#-----END MOD-730038-----
 
FUNCTION efcfg2_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_wsd.wsd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
     SELECT * INTO g_wsd.* FROM wsd_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsd01=g_wsd.wsd01
     SELECT * INTO g_wse.* FROM wse_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wse01=g_wsd.wsd01
     SELECT * INTO g_wsf.* FROM wsf_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsf01=g_wsd.wsd01  AND wsf02=1
     SELECT * INTO g_wsq.* FROM wsq_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsq01=g_wsd.wsd01              #FUN-770047
     SELECT * INTO g_wsg.* FROM wsg_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsg01=g_wsd.wsd01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wsd.wsd01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","wsg_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        RETURN
    END IF
 
    IF g_wsd.wsdacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_wsd_t.*=g_wsd.*
    LET g_wse_t.*=g_wse.*
    LET g_wsf_t.*=g_wsf.*
    LET g_wsg_t.*=g_wsg.*
    LET g_wsq_t.*=g_wsq.*                       #FUN-770047
    LET g_wsd01_t = g_wsd.wsd01
    BEGIN WORK
    LET g_wsd.wsdmodu=g_user                  #修改者
    LET g_wsd.wsddate = g_today               #修改日期
    CALL efcfg2_show()                          # 顯示最新資料
    WHILE TRUE
        CALL efcfg2_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_wsd.*=g_wsd_t.*
            LET g_wse.*=g_wse_t.*
            LET g_wsf.*=g_wsf_t.*
            LET g_wsg.*=g_wsg_t.*
            LET g_wsq.*=g_wsq_t.*               #FUN-770047
 
            CALL efcfg2_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE wsd_file SET wsd_file.* = g_wsd.*    # 更新DB
            WHERE wsd01 = g_wsd.wsd01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsd.wsd01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsd_file",g_wsd_t.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        END IF
        UPDATE wse_file SET wse_file.* = g_wse.*    # 更新DB
            WHERE wse01 = g_wsd.wsd01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wse.wse02,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wse_file",g_wse_t.wse01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        END IF
        IF g_wsf_t.wsf03 IS NULL THEN
            IF g_wsf.wsf03 IS NOT NULL THEN
               ####
               LET g_wsf.wsf01= g_wsd.wsd01
               LET g_wsf.wsf02= 1
               ####
               INSERT INTO wsf_file VALUES(g_wsf.*)
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_wsf.wsf03,SQLCA.sqlcode,0)   #No.FUN-660155
                   CALL cl_err3("ins","wsf_file",g_wsf.wsf01,g_wsf.wsf02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                   CONTINUE WHILE
               END IF
            END IF
        ELSE
           IF g_wsf.wsf03 IS NULL THEN
               DELETE FROM wsf_file WHERE wsf01 = g_wsd.wsd01
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('del wsf: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","wsf_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","del wsf:", 0)   #No.FUN-660155)   #No.FUN-660155
                  CONTINUE WHILE
               END IF
           ELSE
               UPDATE wsf_file SET wsf_file.* = g_wsf.*    # 更新DB
                   WHERE wsf01 = g_wsd.wsd01  AND wsf02=1
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_wsf.wsf03,SQLCA.sqlcode,0)   #No.FUN-660155
                   CALL cl_err3("upd","wsf_file",g_wsd_t.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
                   CONTINUE WHILE
               END IF
           END IF
        END IF
        UPDATE wsg_file SET wsg_file.* = g_wsg.*    # 更新DB
            WHERE wsg01 = g_wsd.wsd01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsg.wsg02,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsg_file",g_wsd_t.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        END IF
        UPDATE wsi_file SET wsi_file.wsi05 = g_wse.wse03    # 更新DB
            WHERE wsi01 = g_wsd.wsd01 AND wsi02 = g_wse.wse13 AND wsi05 = g_wse_t.wse03
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wse.wse13,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsi_file",g_wsd.wsd01,g_wse.wse13,SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        END IF
        #FUN-770047
        IF g_wsq_t.wsq02 IS NULL THEN
            IF g_wsq.wsq02 IS NOT NULL THEN
               LET g_wsq.wsq01= g_wsd.wsd01
               INSERT INTO wsq_file VALUES(g_wsq.*)
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","wsq_file",g_wsq.wsq01,g_wsq.wsq02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                   CONTINUE WHILE
               END IF
            END IF
        ELSE
           IF g_wsq.wsq02 IS NULL THEN
               DELETE FROM wsq_file WHERE wsq01 = g_wsd.wsd01
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("del","wsq_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","del wsq:", 0)   #No.FUN-660155)   #No.FUN-660155
                  CONTINUE WHILE
               END IF
               #FUN-770047 
               DELETE FROM wsh_file WHERE wsh01 = g_wsd.wsd01 AND wsh02='R'
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("del","wsh_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","del wsh:", 0)   #No.FUN-660155)   #No.FUN-660155
                  ROLLBACK WORK
                  RETURN
               END IF
               #END FUN-770047 
           ELSE
               UPDATE wsq_file SET wsq_file.* = g_wsq.*    # 更新DB
                   WHERE wsq01 = g_wsd.wsd01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","wsq_file",g_wsd_t.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
                   CONTINUE WHILE
               END IF
           END IF
        END IF
        #END FUN-770047
 
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION efcfg2_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_wsd.wsd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
     SELECT * INTO g_wsd.* FROM wsd_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsd01=g_wsd.wsd01
     SELECT * INTO g_wse.* FROM wse_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wse01=g_wsd.wsd01
     SELECT * INTO g_wsf.* FROM wsf_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsf01=g_wsd.wsd01
     SELECT * INTO g_wsq.* FROM wsq_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsq01=g_wsd.wsd01              #FUN-770047
     SELECT * INTO g_wsg.* FROM wsg_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsg01=g_wsd.wsd01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wsd.wsd01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","wsg_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
    CALL efcfg2_show()
    IF cl_delete() THEN
       DELETE FROM wsd_file WHERE wsd01 = g_wsd.wsd01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsd: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsd_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","del wsd:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wse_file WHERE wse01 = g_wse.wse01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wse: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wse_file",g_wse.wse01,"",SQLCA.sqlcode,"","del wse:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wsf_file WHERE wsf01 = g_wsf.wsf01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsf: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsf_file",g_wsf.wsf01,"",SQLCA.sqlcode,"","del wsf:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wsg_file WHERE wsg01 = g_wsg.wsg01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsg: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsg_file",g_wsg.wsg01,"",SQLCA.sqlcode,"","del wsg:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wsh_file WHERE wsh01 = g_wsd.wsd01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsh: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsh_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","del wsh:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wsi_file WHERE wsi01 = g_wsd.wsd01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsi: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsi_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","del wsi:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wsj_file WHERE wsj05 = g_wsd.wsd01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsj: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsj_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","del wsj:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       #FUN-770047
       DELETE FROM wsq_file WHERE wsq01 = g_wsq.wsq01
       IF SQLCA.SQLCODE THEN
          CALL cl_err3("del","wsq_file",g_wsq.wsq01,"",SQLCA.sqlcode,"","del wsq:", 0)
          ROLLBACK WORK
          RETURN
       END IF
       #END FUN-770047
 
       CLEAR FORM
 
       OPEN efcfg2_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE efcfg2_cs
          CLOSE efcfg2_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH efcfg2_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE efcfg2_cs
          CLOSE efcfg2_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
 
       IF g_row_count != 0 THEN
          OPEN efcfg2_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL efcfg2_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE    #No.FUN-6A0075
             CALL efcfg2_fetch('/')
          END IF
       ELSE
          INITIALIZE g_wsd.* TO NULL
       END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION efcfg2_tab(p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           l_cnt    LIKE type_file.num5    #No.FUN-680130 SMALLINT

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構 
    ##FUN-5A0136
    #CASE cl_db_get_database_type()
    #  WHEN "ORA"
    #      SELECT COUNT(*) INTO l_cnt FROM ALL_TABLES WHERE  #FUN-5A0136
    #      TABLE_NAME = UPPER(p_tabname) AND OWNER = 'DS'
    # 
    #  WHEN "IFX"
    #       SELECT COUNT(*) INTO l_cnt FROM ds:systables
    #        WHERE tabname = p_tabname
    #END CASE
    ##END FUN-5A0136
    SELECT COUNT(*) INTO l_cnt FROM sch_file 
      WHERE sch01 = p_tabname
    #---FUN-A90024---end-------  
 
    IF l_cnt = 0 THEN
       CALL cl_err(p_tabname,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION efcfg2_col(p_colname,p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           p_colname    LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           l_cnt    LIKE type_file.num5,   #No.FUN-680130 SMALLINT
           l_name       STRING
 
    #FUN-5A0136
    IF p_tabname IS NULL THEN
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構 
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM ALL_TAB_COLUMNS
      #     WHERE COLUMN_NAME = UPPER(p_colname) AND OWNER = 'DS'
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM ds:syscolumns
      #     WHERE colname = p_colname
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch02 = p_colname
      #---FUN-A90024---end-------
    ELSE
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構 
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM ALL_TAB_COLUMNS
      #     WHERE TABLE_NAME = UPPER(p_tabname) AND COLUMN_NAME = UPPER(p_colname)
      #       AND OWNER = 'DS'
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM ds:syscolumns col, ds:systables tab
      #     WHERE tab.tabname =  p_tabname AND tab.tabid = col.tabid
      #     AND colname = p_colname
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch01 = p_tabname AND sch02 = p_colname
      #---FUN-A90024---end-------
    END IF
    #END FUN-5A0136
 
   # SELECT COUNT(*) INTO l_cnt FROM syscolumns WHERE colname = p_colname
    IF l_cnt = 0 THEN
       LET l_name= p_tabname,"+",p_colname
       CALL cl_err(l_name,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION efcfg2_h()
    IF g_wsd.wsd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_wse.wse02 IS NULL THEN
       CALL cl_err(NULL,"aws-067",0)
       RETURN
    END IF
    OPEN WINDOW efcfg2_w1 AT 4, 16
        WITH FORM "aws/42f/aws_efcfg_config" ATTRIBUTE(STYLE = g_win_style)
 
   # CALL cl_ui_init()
    CALL cl_ui_locale("aws_efcfg_config")
    CALL efcfg2_b_fill('M')
    CALL efcfg2_b('M')
 
    CLOSE WINDOW efcfg2_w1
END FUNCTION
 
FUNCTION efcfg2_d()
    IF g_wsd.wsd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_wsf.wsf03 IS NULL THEN
       CALL cl_err(NULL,"aws-068",0)
       RETURN
    END IF
    OPEN WINDOW efcfg2_w1 AT 4, 16
        WITH FORM "aws/42f/aws_efcfg_config" ATTRIBUTE(STYLE = g_win_style)
 
   # CALL cl_ui_init()
    CALL cl_ui_locale("aws_efcfg_config")
    CALL efcfg2_b_fill('D')
    CALL efcfg2_b('D')
 
    CLOSE WINDOW efcfg2_w1
END FUNCTION
 
#FUN-770047
FUNCTION efcfg2_m()
   IF g_wsd.wsd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_wsq.wsq02 IS NULL THEN
      CALL cl_err(NULL,"aws-104",0)
      RETURN
   END IF
   OPEN WINDOW efcfg2_w1 AT 4, 16
       WITH FORM "aws/42f/aws_efcfg_config" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_locale("aws_efcfg_config")
   CALL efcfg2_b_fill('R')
   CALL efcfg2_b('R')
 
   CLOSE WINDOW efcfg2_w1
END FUNCTION
#END FUN-770047
 
FUNCTION efcfg2_b_fill(p_wsh02)             #BODY FILL UP
DEFINE
    p_wsh02          LIKE wsh_file.wsh02,          #No.FUN-680130 VARCHAR(1)
    l_cnt            LIKE type_file.num5,          #No.FUN-680130 SMALLINT
    l_i              LIKE type_file.num5,          #No.FUN-680130 SMALLINT
    l_item           STRING
    LET g_sql =
        "SELECT wsh03,wsh04,wsh05,'',wsh06,wsh07,wsh08,wsh09,wsh10,''", #FUN-640182 #CHI-BC0010
        " FROM wsh_file",          
        " WHERE wsh01 = '", g_wsd.wsd01 CLIPPED, "'",                  #單身
        "   AND wsh02 = '", p_wsh02, "'",
        " ORDER BY wsh03,wsh04"
    PREPARE efcfg2_pb FROM g_sql
    DECLARE efcfg2_curs CURSOR FOR efcfg2_pb
 
    CALL g_wsh.clear() #單身 ARRAY 乾洗
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH efcfg2_curs INTO g_wsh[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        #FUN-640182---start---
         SELECT gae04 INTO g_wsh[g_cnt].gae04    
           FROM gae_file
         WHERE gae01 = g_wsd.wsd01 
           and gae02 = g_wsh[g_cnt].wsh05
           and gae03 = g_lang
           and gae11 = 'Y'                           #CHI-9C0016
           and gae12 = g_sma.sma124                  #CHI-9C0016
        #-CHI-9C0016-add- 
         IF SQLCA.sqlcode THEN 
           SELECT gae04 INTO g_wsh[g_cnt].gae04 
             FROM gae_file 
            WHERE gae01 = g_wsd.wsd01 
              AND gae02 = g_wsh[g_cnt].wsh05 
              AND gae03 = g_lang
              AND (gae11 IS NULL OR gae11 = 'N')
              AND gae12 = g_sma.sma124 
         END IF
         IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
            SELECT gaq03 INTO g_wsh[g_cnt].gae04 
              FROM gaq_file 
             WHERE gaq01 = g_wsh[g_cnt].wsh05 
               AND gaq02 = g_lang 
       
            IF SQLCA.SQLCODE THEN
               LET g_wsh[g_cnt].gae04 = g_wsh[g_cnt].wsh05 
            END IF
         END IF
        #-CHI-9C0016-end- 
 
         IF cl_null(g_wsh[g_cnt].gae04) THEN
           SELECT gaq03 INTO g_wsh[g_cnt].gae04
           FROM gaq_file
            WHERE gaq01 = g_wsh[g_cnt].wsh05
              and gaq02 = g_lang
         END IF
        #FUN-640182---end---
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    SELECT MAX(wsf02) INTO l_cnt FROM wsf_file
         WHERE wsf01 = g_wsd.wsd01
    FOR l_i = 1 TO l_cnt
        IF l_i = 1 THEN
           LET l_item = l_i USING '<<<<<'
        ELSE
           LET l_item = l_item,",",l_i USING '<<<<<'
        END IF
    END FOR
    display l_item
    CALL cl_set_combo_items("wsh03",l_item,l_item)
    CALL g_wsh.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION efcfg2_b(p_wsh02)
DEFINE
    l_ac_t             LIKE type_file.num5,              #No.FUN-680130 SMALLINT
    l_n                LIKE type_file.num5,              #No.FUN-680130 SMALLINT
    l_lock_sw          LIKE type_file.chr1,   #單身鎖住否#No.FUN-680130 VARCHAR(1)
    p_cmd              LIKE type_file.chr1,   #處理狀態  #No.FUN-680130 VARCHAR(1)
    p_wsh02           LIKE wsh_file.wsh02,              #No.FUN-680130 VARCHAR(1)
    l_allow_insert     LIKE type_file.chr1,   #可新增否  #No.FUN-680130 VARCHAR(01)
    l_allow_delete     LIKE type_file.chr1    #可刪除否  #No.FUN-680130 VARCHAR(01)
DEFINE l_message       STRING
DEFINE l_ze03          LIKE ze_file.ze03
DEFINE l_cnt           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_sql           STRING                 #FUN-770047
DEFINE l_idx           INTEGER                #CHI-BC0010
DEFINE l_chk           INTEGER                #CHI-BC0010
DEFINE l_tmp           INTEGER                #CHI-BC0010
DEFINE l_tag           STRING                 #CHI-BC0010

    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = " SELECT wsh03,wsh04,wsh05,' ',wsh06,wsh07,wsh08,wsh09,wsh10,''", #CHI-BC0010
       " FROM wsh_file ",
      "   WHERE wsh01=?  AND wsh02= ? AND wsh03= ? AND wsh04 = ? AND wsh05 = ? ",
      "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE efcfg2_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
    #FUN-770047
    #IF p_wsh02 = "M" THEN
    #    CALL cl_set_comp_visible("wsh03",FALSE)
    #END IF
    CASE p_wsh02
        WHEN "M"
             CALL cl_set_comp_visible("wsh03",FALSE)
        WHEN "R"
             CALL cl_set_comp_visible("wsh03,wsh06,wsh07,wsh08", FALSE)
    END CASE
    #END FUN-770047
 
    CALL cl_set_comp_visible("wsh04",FALSE)
    INPUT ARRAY g_wsh WITHOUT DEFAULTS FROM s_wsh.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        #FUN-770047
        BEFORE INPUT
            IF p_wsh02 = "R" THEN
               CALL cl_set_act_visible("column_ref2", FALSE)
            END IF
        #END FUN-770047
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            IF p_wsh02 = "M" OR p_wsh02 = "R" THEN                 #FUN-770047
                LET g_wsh[l_ac].wsh03 = 1
            END IF
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_wsh_t.* = g_wsh[l_ac].*  #BACKUP
 
               OPEN efcfg2_bcl USING g_wsd.wsd01, p_wsh02, g_wsh_t.wsh03,g_wsh_t.wsh04,g_wsh_t.wsh05
               IF STATUS THEN
                  CALL cl_err("OPEN efcfg2_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH efcfg2_bcl INTO g_wsh[l_ac].*
                  #CHI-BC0010 - Start - 顯示欄位名稱
                  FOR l_idx = 1 TO  g_wsh.getLength()
                     IF g_wsh[l_idx].wsh10 IS NOT NULL THEN
                        LET l_tmp = 0
                        SELECT COUNT(*) INTO l_tmp FROM gae_file where gae02 = g_wsh[l_idx].wsh10 AND gae01 = g_wsh[l_idx].wsh09 AND gae03 = g_lang
                        IF l_tmp > 0 THEN
                           SELECT UNIQUE gae04 INTO g_wsh[l_idx].gae04_2 FROM gae_file 
                              where gae02 = g_wsh[l_idx].wsh10 AND gae01 = g_wsh[l_idx].wsh09 AND gae03 = g_lang
                        END IF
                     END IF
                  END FOR
                  #CHI-BC0010 -  End  -
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_wsh_t.wsh05,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               #FUN-640182 ---start
                SELECT gae04 INTO g_wsh[l_ac].gae04    
                  FROM gae_file
                WHERE gae01 = g_wsd.wsd01 
                  and gae02 = g_wsh[l_ac].wsh05
                  and gae03 = g_lang
                  and gae11 = 'Y'                           #CHI-9C0016
                  and gae12 = g_sma.sma124                  #CHI-9C0016
               #-CHI-9C0016-add- 
                IF SQLCA.sqlcode THEN 
                 #SELECT gae04 INTO g_wsh[g_cnt].gae04      #TQC-9C0193 mark
                  SELECT gae04 INTO g_wsh[l_ac].gae04       #TQC-9C0193
                    FROM gae_file 
                   WHERE gae01 = g_wsd.wsd01 
                    #AND gae02 = g_wsh[g_cnt].wsh05         #TQC-9C0193 mark 
                     AND gae02 = g_wsh[l_ac].wsh05          #TQC-9C0193
                     AND gae03 = g_lang
                     AND (gae11 IS NULL OR gae11 = 'N')
                     AND gae12 = g_sma.sma124 
                END IF
                IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
                  #SELECT gaq03 INTO g_wsh[g_cnt].gae04     #TQC-9C0193 mark 
                   SELECT gaq03 INTO g_wsh[l_ac].gae04      #TQC-9C0193
                     FROM gaq_file 
                   #WHERE gaq01 = g_wsh[g_cnt].wsh05        #TQC-9C0193 mark
                    WHERE gaq01 = g_wsh[l_ac].wsh05         #TQC-9C0193
                      AND gaq02 = g_lang 
              
                   IF SQLCA.SQLCODE THEN
                     #LET g_wsh[g_cnt].gae04 = g_wsh[g_cnt].wsh05   #TQC-9C0193 mark 
                      LET g_wsh[l_ac].gae04 = g_wsh[l_ac].wsh05     #TQC-9C0193
                   END IF
                END IF
               #-CHI-9C0016-end- 
 
                IF NOT cl_null(g_wsh[l_ac].gae04) THEN
                  LET g_wsh_t.gae04 = g_wsh[l_ac].gae04
                ELSE
                   SELECT gaq03 INTO g_wsh[l_ac].gae04
                   FROM gaq_file
                   WHERE gaq01 = g_wsh[l_ac].wsh05
                     and gaq02 = g_lang
                   LET g_wsh_t.gae04 =g_wsh[l_ac].gae04
                END IF
                #FUN-640182 ---end
            END IF
 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
         INITIALIZE g_wsh[l_ac].* TO NULL      #900423
            IF l_ac > 1 AND p_wsh02 = 'D' THEN
                LET g_wsh[l_ac].wsh03 = g_wsh[l_ac-1].wsh03
            ELSE
                LET g_wsh[l_ac].wsh03 = 1
            END IF
            LET g_wsh_t.* = g_wsh[l_ac].*         #新輸入資料
            #FUN-770047
            IF p_wsh02 = 'M' OR p_wsh02='R' THEN
               LET l_sql = "SELECT MAX(wsh04)+1 FROM wsh_file ",
                           " WHERE wsh01 = '",g_wsd.wsd01 CLIPPED,"'",
                           "   AND wsh02 = '",p_wsh02,"'"
               DECLARE wsh_cs CURSOR FROM l_sql
               OPEN wsh_cs
               FETCH wsh_cs INTO g_wsh[l_ac].wsh04
               IF g_wsh[l_ac].wsh04 = 0 OR g_wsh[l_ac].wsh04 IS NULL
                 THEN LET g_wsh[l_ac].wsh04 = 1 END IF
            END IF
            #END FUN-770047
            NEXT FIELD wsh03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_wsh[l_ac].wsh03 IS NULL THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT COUNT(*) INTO l_n FROM wsh_file
             WHERE wsh01 = g_wsd.wsd01 AND
                   wsh02 = p_wsh02 AND
                   wsh03 = g_wsh[l_ac].wsh03 AND
                   wsh04 = g_wsh[l_ac].wsh04
            IF l_n > 0 THEN
               CALL cl_err(g_wsh[l_ac].wsh04,-239,0)
               NEXT FIELD wsh04
            END IF
            INSERT INTO wsh_file (wsh01,wsh02,wsh03,wsh04,wsh05,wsh06,wsh07,wsh08,wsh09,wsh10) #CHI-BC0010
                 VALUES (g_wsd.wsd01,p_wsh02,g_wsh[l_ac].wsh03,g_wsh[l_ac].wsh04, g_wsh[l_ac].wsh05,g_wsh[l_ac].wsh06,g_wsh[l_ac].wsh07,g_wsh[l_ac].wsh08,g_wsh[l_ac].wsh09,g_wsh[l_ac].wsh10) #CHI-BC0010
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_wsh[l_ac].wsh03,SQLCA.sqlcode,1)   #No.FUN-660155
               CALL cl_err3("ins","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",1)   #No.FUN-660155
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD wsh03
            IF p_wsh02 = 'D' AND g_wsh[l_ac].wsh04 IS NULL THEN
               SELECT MAX(wsh04)+1 INTO g_wsh[l_ac].wsh04 FROM wsh_file
                    WHERE wsh01 = g_wsd.wsd01 AND wsh02 = 'D' AND wsh03 = g_wsh[l_ac].wsh03
               IF g_wsh[l_ac].wsh04 = 0 OR g_wsh[l_ac].wsh04 IS NULL
                THEN LET g_wsh[l_ac].wsh04 = 1 END IF
            END IF
 
        AFTER FIELD wsh04
           IF g_wsh[l_ac].wsh04 IS NOT NULL THEN
               IF (g_wsh_t.wsh04 IS NULL AND g_wsh[l_ac].wsh04 IS NOT NULL) OR
                 (g_wsh[l_ac].wsh04 != g_wsh_t.wsh04) THEN
                  SELECT COUNT(*) INTO l_n FROM wsh_file
                   WHERE wsh01 = g_wsd.wsd01 AND
                         wsh02 = p_wsh02 AND
                         wsh03 = g_wsh[l_ac].wsh03 AND
                         wsh04 = g_wsh[l_ac].wsh04
                  IF l_n > 0 THEN
                     CALL cl_err(g_wsh[l_ac].wsh04,-239,0)
                     NEXT FIELD wsh04
                  END IF
               END IF
            END IF
 
        AFTER FIELD wsh05
            IF g_wsh[l_ac].wsh05 != g_wsh_t.wsh05 OR g_wsh_t.wsh05 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM wsh_file
                   WHERE wsh01 = g_wsd.wsd01 AND
                         wsh02 = p_wsh02 AND
                         wsh03 = g_wsh[l_ac].wsh03 AND
                         wsh05 = g_wsh[l_ac].wsh05
                  IF l_n > 0 THEN
                     CALL cl_err(g_wsh[l_ac].wsh05,-239,0)
                     NEXT FIELD wsh05
                  END IF
            END IF
 
            #FUN-770047
            IF p_wsh02 = "R" THEN
               IF g_wsh[l_ac].wsh05 IS NOT NULL THEN
                  IF NOT efcfg2_col(g_wsh[l_ac].wsh05,g_wsq.wsq02) THEN
                     NEXT FIELD wsh05
                  END IF
               END IF
            END IF
            #END FUN-770047
 
            #FUN-640182 ---start
            LET g_wsh[l_ac].gae04="" 
            SELECT gae04 INTO g_wsh[l_ac].gae04    
              FROM gae_file
            WHERE gae01 = g_wsd.wsd01 
              and gae02 = g_wsh[l_ac].wsh05
              and gae03 = g_lang
              and gae11 = 'Y'                           #CHI-9C0016
              and gae12 = g_sma.sma124                  #CHI-9C0016
           #-CHI-9C0016-add- 
            IF SQLCA.sqlcode THEN 
             #SELECT gae04 INTO g_wsh[g_cnt].gae04      #TQC-9C0193 mark 
              SELECT gae04 INTO g_wsh[l_ac].gae04       #TQC-9C0193 
                FROM gae_file 
               WHERE gae01 = g_wsd.wsd01 
                #AND gae02 = g_wsh[g_cnt].wsh05         #TQC-9C0193 mark
                 AND gae02 = g_wsh[l_ac].wsh05          #TQC-9C0193
                 AND gae03 = g_lang
                 AND (gae11 IS NULL OR gae11 = 'N')
                 AND gae12 = g_sma.sma124 
            END IF
            IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
              #SELECT gaq03 INTO g_wsh[g_cnt].gae04     #TQC-9C0193 mark
               SELECT gaq03 INTO g_wsh[l_ac].gae04      #TQC-9C0193
                 FROM gaq_file 
               #WHERE gaq01 = g_wsh[g_cnt].wsh05        #TQC-9C0193 mark 
                WHERE gaq01 = g_wsh[l_ac].wsh05         #TQC-9C0193
                  AND gaq02 = g_lang 
          
               IF SQLCA.SQLCODE THEN
                 #LET g_wsh[g_cnt].gae04 = g_wsh[g_cnt].wsh05   #TQC-9C0193 mark 
                  LET g_wsh[l_ac].gae04 = g_wsh[l_ac].wsh05     #TQC-9C0193
               END IF
            END IF
           #-CHI-9C0016-end- 
 
            IF NOT cl_null(g_wsh[l_ac].gae04) THEN
              DISPLAY g_wsh[l_ac].gae04 TO FORMONLY.gae04
              LET g_wsh_t.gae04 =g_wsh[l_ac].gae04
            ELSE
              SELECT gaq03 INTO g_wsh[l_ac].gae04
              FROM gaq_file
              WHERE gaq01 = g_wsh[l_ac].wsh05
                and gaq02 = g_lang
              DISPLAY g_wsh[l_ac].gae04 TO FORMONLY.gae04
              LET g_wsh_t.gae04 =g_wsh[l_ac].gae04
            END IF
            #FUN-640182 ---end
 
 
        BEFORE FIELD wsh06
            IF g_wsh[l_ac].wsh06 != g_wsh_t.wsh06 THEN
               MESSAGE ' '
               CALL fromowner_ref('H',g_wsh[l_ac].wsh06,g_wsh_t.wsh06,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   LET g_wsh[l_ac].wsh06 = g_wsh_t.wsh06
                   DISPLAY BY NAME g_wsh[l_ac].wsh06
               ELSE
                   UPDATE wsh_file SET wsh_file.wsh06 = g_wsi.wsi02    # 更新DB
                       WHERE wsh01 = g_wsd.wsd01 AND
                           wsh02 = p_wsh02 AND
                           wsh03 = g_wsh_t.wsh03 AND
                           wsh04 = g_wsh_t.wsh04 AND
                           wsh05 = g_wsh_t.wsh05
                   IF SQLCA.sqlcode THEN
#                      CALL cl_err(g_wsh[l_ac].wsh06,SQLCA.sqlcode,0)   #No.FUN-660155
                       CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                   END IF
                   LET g_wsh[l_ac].wsh06 = g_wsi.wsi02
                   LET g_wsh_t.wsh06 = g_wsh[l_ac].wsh06
                   DISPLAY BY NAME g_wsh[l_ac].wsh06
               END IF
            END IF
 
        AFTER FIELD wsh06
            IF g_wsh[l_ac].wsh06 IS NOT NULL THEN
              IF g_wsh[l_ac].wsh06 != g_wsh_t.wsh06 OR g_wsh_t.wsh06 IS NULL THEN
                 MESSAGE ' '
                 CALL fromowner_ref('H',g_wsh[l_ac].wsh06,g_wsh_t.wsh06,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh06 = g_wsh_t.wsh06
                     DISPLAY BY NAME g_wsh[l_ac].wsh06
                 ELSE
                    UPDATE wsh_file SET wsh_file.wsh06 = g_wsi.wsi02    # 更新DB
                        WHERE wsh01 = g_wsd.wsd01 AND
                            wsh02 = p_wsh02 AND
                            wsh03 = g_wsh_t.wsh03 AND
                            wsh04 = g_wsh_t.wsh04 AND
                            wsh05 = g_wsh_t.wsh05
                    IF SQLCA.sqlcode THEN
#                      CALL cl_err(g_wsh[l_ac].wsh06,SQLCA.sqlcode,0)   #No.FUN-660155
                       CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                    END IF
                    LET g_wsh[l_ac].wsh06 = g_wsi.wsi02
                    LET g_wsh_t.wsh06 = g_wsh[l_ac].wsh06
                    DISPLAY BY NAME g_wsh[l_ac].wsh06
                 END IF
              END IF
            ELSE
                 IF g_wsh_t.wsh06 IS NOT NULL THEN
                     DELETE FROM wsi_file where wsi01 = g_wse.wse01
                        AND wsi02 = g_wsh_t.wsh06 AND wsi05 = g_wsh_t.wsh05
                     LET g_wsh_t.wsh06 = NULL
                 END IF
            END IF
 
        BEFORE FIELD wsh07
              #CHI-BC0010 - Start -
              #IF g_wsh[l_ac].wsh06 IS NULL THEN
              #     SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-071' AND ze02 = g_lang
              #     LET l_cnt = l_cnt + 1
              #     LET l_message = l_ze03 CLIPPED,' 1 '
              #     SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-076' AND ze02 = g_lang
              #     LET l_message = l_message,l_ze03
              #     CALL cl_msgany(9,10,l_message) 
              #     NEXT FIELD wsh06               
              #END IF
              #CHI-BC0010 -  End  -
 
              IF g_wsh[l_ac].wsh07 != g_wsh_t.wsh07 THEN
                 MESSAGE ' '
                 CALL fromowner_ref('H',g_wsh[l_ac].wsh07,g_wsh_t.wsh07,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh07 = g_wsh_t.wsh07
                     DISPLAY BY NAME g_wsh[l_ac].wsh07
                 ELSE
                     UPDATE wsh_file SET wsh_file.wsh07 = g_wsi.wsi02    # 更新DB
                         WHERE wsh01 = g_wsd.wsd01 AND
                             wsh02 = p_wsh02 AND
                             wsh03 = g_wsh_t.wsh03 AND
                             wsh04 = g_wsh_t.wsh04 AND
                             wsh05 = g_wsh_t.wsh05
                     IF SQLCA.sqlcode THEN
#                        CALL cl_err(g_wsh[l_ac].wsh07,SQLCA.sqlcode,0)   #No.FUN-660155
                         CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                     END IF
                     LET g_wsh[l_ac].wsh07 = g_wsi.wsi02
                     LET g_wsh_t.wsh07 = g_wsh[l_ac].wsh07
                     DISPLAY BY NAME g_wsh[l_ac].wsh07
                 END IF
              END IF
 
        AFTER FIELD wsh07
#CHI-BC0010 - Start -
            IF g_wsh[l_ac].wsh06 IS NULL AND g_wsh[l_ac].wsh07 IS NOT NULL THEN
                 SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-071' AND ze02 = g_lang
                 LET l_cnt = l_cnt + 1
                 LET l_message = l_ze03 CLIPPED,' 1 '
                 SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-076' AND ze02 = g_lang
                 LET l_message = l_message,l_ze03
                 CALL cl_msgany(9,10,l_message) 
                 LET g_wsh[l_ac].wsh07 = NULL
                 NEXT FIELD wsh06               
            END IF
            #CHI-BC0010 -  End  -

            If g_wsh[l_ac].wsh07 IS NOT NULL THEN
              IF g_wsh[l_ac].wsh07 != g_wsh_t.wsh07 OR g_wsh_t.wsh07 IS NULL THEN
                 MESSAGE ' '
                 CALL fromowner_ref('H',g_wsh[l_ac].wsh07,g_wsh_t.wsh07,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh07 = g_wsh_t.wsh07
                     DISPLAY BY NAME g_wsh[l_ac].wsh07
                 ELSE
                    UPDATE wsh_file SET wsh_file.wsh07 = g_wsi.wsi02    # 更新DB
                        WHERE wsh01 = g_wsd.wsd01 AND
                            wsh02 = p_wsh02 AND
                            wsh03 = g_wsh_t.wsh03 AND
                            wsh04 = g_wsh_t.wsh04 AND
                            wsh05 = g_wsh_t.wsh05
                    IF SQLCA.sqlcode THEN
#                      CALL cl_err(g_wsh[l_ac].wsh07,SQLCA.sqlcode,0)   #No.FUN-660155
                       CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                    END IF
                    LET g_wsh[l_ac].wsh07 = g_wsi.wsi02
                    LET g_wsh_t.wsh07 = g_wsh[l_ac].wsh07
                    DISPLAY BY NAME g_wsh[l_ac].wsh07
                 END IF
              END IF
            ELSE
                 IF g_wsh_t.wsh07 IS NOT NULL THEN
                     DELETE FROM wsi_file where wsi01 = g_wse.wse01
                        AND wsi02 = g_wsh_t.wsh07 AND wsi05 = g_wsh_t.wsh05
                     LET g_wsh_t.wsh07 = NULL
                 END IF
            END IF
 
        BEFORE FIELD wsh08
              #CHI-BC0010 - Start -
              #IF g_wsh[l_ac].wsh06 IS NULL THEN
              #     SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-071' AND ze02 = g_lang
              #     LET l_cnt = l_cnt + 1
              #     LET l_message = l_ze03 CLIPPED,' 1 '
              #     SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-076' AND ze02 = g_lang
              #     LET l_message = l_message,l_ze03
              #     CALL cl_msgany(9,10,l_message) 
              #     NEXT FIELD wsh06               
              #END IF
              
              #IF g_wsh[l_ac].wsh07 IS NULL THEN
              #     SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-071' AND ze02 = g_lang
              #     LET l_cnt = l_cnt + 1
              #     LET l_message = l_ze03 CLIPPED,' 2 '
              #     SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-076' AND ze02 = g_lang
              #     LET l_message = l_message,l_ze03
              #     #CALL cl_msgany(9,10,l_message) 
              #     #NEXT FIELD wsh07               
              #END IF
              #CHI-BC0010 -  End  -
              IF g_wsh[l_ac].wsh08 != g_wsh_t.wsh08 THEN
                 MESSAGE ' '
                 CALL fromowner_ref('H',g_wsh[l_ac].wsh08,g_wsh_t.wsh08,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh08 = g_wsh_t.wsh08
                     DISPLAY BY NAME g_wsh[l_ac].wsh08
                 ELSE
                     UPDATE wsh_file SET wsh_file.wsh08 = g_wsi.wsi02    # 更新DB
                         WHERE wsh01 = g_wsd.wsd01 AND
                             wsh02 = p_wsh02 AND
                             wsh03 = g_wsh_t.wsh03 AND
                             wsh04 = g_wsh_t.wsh04 AND
                             wsh05 = g_wsh_t.wsh05
                     IF SQLCA.sqlcode THEN
#                        CALL cl_err(g_wsh[l_ac].wsh08,SQLCA.sqlcode,0)   #No.FUN-660155
                         CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                     END IF
                     LET g_wsh[l_ac].wsh08 = g_wsi.wsi02
                     LET g_wsh_t.wsh08 = g_wsh[l_ac].wsh08
                     DISPLAY BY NAME g_wsh[l_ac].wsh08
                 END IF
              END IF
 
        AFTER FIELD wsh08
#CHI-BC0010 - Start -
           IF g_wsh[l_ac].wsh06 IS NULL AND g_wsh[l_ac].wsh08 IS NOT NULL  THEN
              SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-071' AND ze02 = g_lang
              LET l_cnt = l_cnt + 1
              LET l_message = l_ze03 CLIPPED,' 1 '
              SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-076' AND ze02 = g_lang
              LET l_message = l_message,l_ze03
              CALL cl_msgany(9,10,l_message) 
              LET g_wsh[l_ac].wsh08 = NULL
              NEXT FIELD wsh06               
           END IF
           IF g_wsh[l_ac].wsh07 IS NULL AND g_wsh[l_ac].wsh08 IS NOT NULL   THEN
              SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-071' AND ze02 = g_lang
              LET l_cnt = l_cnt + 1
              LET l_message = l_ze03 CLIPPED,' 2 '
              SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-076' AND ze02 = g_lang
              LET l_message = l_message,l_ze03
              CALL cl_msgany(9,10,l_message) 
              LET g_wsh[l_ac].wsh08 = NULL
              NEXT FIELD wsh07                      
           END IF
           #CHI-BC0010 -  End  -
            If g_wsh[l_ac].wsh08 IS NOT NULL THEN
              IF g_wsh[l_ac].wsh08 != g_wsh_t.wsh08 OR g_wsh_t.wsh08 IS NULL THEN
                 MESSAGE ' '
                 CALL fromowner_ref('H',g_wsh[l_ac].wsh08,g_wsh_t.wsh08,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh08 = g_wsh_t.wsh08
                     DISPLAY BY NAME g_wsh[l_ac].wsh08
                 ELSE
                    UPDATE wsh_file SET wsh_file.wsh08 = g_wsi.wsi02    # 更新DB
                        WHERE wsh01 = g_wsd.wsd01 AND
                            wsh02 = p_wsh02 AND
                            wsh03 = g_wsh_t.wsh03 AND
                            wsh04 = g_wsh_t.wsh04 AND
                            wsh05 = g_wsh_t.wsh05
                    IF SQLCA.sqlcode THEN
#                        CALL cl_err(g_wsh[l_ac].wsh08,SQLCA.sqlcode,0)   #No.FUN-660155
                         CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                    END IF
                    LET g_wsh[l_ac].wsh08 = g_wsi.wsi02
                    LET g_wsh_t.wsh08 = g_wsh[l_ac].wsh08
                    DISPLAY BY NAME g_wsh[l_ac].wsh08
                 END IF
              END IF
            ELSE
                 IF g_wsh_t.wsh08 IS  NOT NULL THEN
                     DELETE FROM wsi_file where wsi01 = g_wse.wse01
                        AND wsi02 = g_wsh_t.wsh08 AND wsi05 = g_wsh_t.wsh05
                     LET g_wsh_t.wsh08 = NULL
                 END IF
            END IF

        #CHI-BC0010 - Start -
        BEFORE FIELD wsh09
              IF g_wsh[l_ac].wsh09 != g_wsh_t.wsh09 THEN
                 MESSAGE ' '
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh09 = g_wsh_t.wsh09
                     DISPLAY BY NAME g_wsh[l_ac].wsh09
                 ELSE
                     LET g_wsh_t.wsh09 = g_wsh[l_ac].wsh09
                     DISPLAY BY NAME g_wsh[l_ac].wsh09
                 END IF
              END IF
 
        AFTER FIELD wsh09
            If g_wsh[l_ac].wsh09 IS NOT NULL THEN
              LET l_chk = 0
              SELECT COUNT(*) INTO l_chk FROM gav_file WHERE gav01 = g_wsh[l_ac].wsh09
              IF l_chk = 0 THEN 
                 LET g_wsh[l_ac].wsh10 = NULL
                 LET g_wsh_t.wsh10 = NULL 
                 LET g_wsh[l_ac].gae04_2 = NULL
                 LET g_wsh_t.gae04_2 = NULL 
                 DISPLAY BY NAME g_wsh[l_ac].wsh10
                 DISPLAY BY NAME g_wsh[l_ac].gae04_2
                 LET g_wsh[l_ac].wsh09 = NULL
                 SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-803' AND ze02 = g_lang
                 LET l_message = l_ze03
                 CALL cl_msgany(9,10,l_message) 
                 NEXT FIELD wsh09
              END IF
              IF g_wsh[l_ac].wsh09 != g_wsh_t.wsh09 OR g_wsh_t.wsh09 IS NULL THEN
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh09 = g_wsh_t.wsh09
                     DISPLAY BY NAME g_wsh[l_ac].wsh09
                 ELSE
                    LET g_wsh_t.wsh09 = g_wsh[l_ac].wsh09
                    DISPLAY BY NAME g_wsh[l_ac].wsh09
                 END IF
              END IF
            ELSE
               IF g_wsh[l_ac].wsh10 IS NOT NULL THEN
                  LET g_wsh[l_ac].wsh10 = NULL
                  LET g_wsh_t.wsh10 = NULL 
                  LET g_wsh[l_ac].gae04_2 = NULL
                  LET g_wsh_t.gae04_2 = NULL 
                  DISPLAY BY NAME g_wsh[l_ac].wsh10
                  DISPLAY BY NAME g_wsh[l_ac].gae04_2
               END IF
            END IF
            IF g_wsh[l_ac].wsh09 IS NOT NULL AND g_wsh[l_ac].wsh10 IS NULL  THEN
               NEXT FIELD wsh10
            END IF
        BEFORE FIELD wsh10
            IF g_wsh[l_ac].wsh09 IS NULL THEN
               SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-804' AND ze02 = g_lang
               LET l_message = l_ze03
               CALL cl_msgany(9,10,l_message)
               NEXT FIELD wsh09       
            END IF

            IF g_wsh[l_ac].wsh10 != g_wsh_t.wsh10 THEN
               MESSAGE ' '
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  LET g_wsh[l_ac].wsh09 = g_wsh_t.wsh10
                  DISPLAY BY NAME g_wsh[l_ac].wsh10
               ELSE
                  LET g_wsh_t.wsh09 = g_wsh[l_ac].wsh10
                  DISPLAY BY NAME g_wsh[l_ac].wsh10
               END IF
            END IF

        AFTER FIELD wsh10
           IF g_wsh[l_ac].wsh10 IS NULL THEN
              LET g_wsh[l_ac].gae04_2 = NULL
              DISPLAY BY NAME g_wsh[l_ac].gae04_2
              SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-805' AND ze02 = g_lang
              LET l_message = l_ze03
              CALL cl_msgany(9,10,l_message)
              IF g_wsh_t.wsh10 IS NOT NULL THEN
                  LET g_wsh_t.wsh10 = NULL
              END IF
              NEXT FIELD wsh09       
           END IF     
           
           LET l_chk = 0
           SELECT COUNT(*) INTO l_chk FROM gav_file WHERE gav01 = g_wsh[l_ac].wsh09 AND gav02 = g_wsh[l_ac].wsh10
           IF l_chk = 0 THEN 
                 LET g_wsh[l_ac].wsh10 = NULL
                 LET g_wsh[l_ac].gae04_2 = NULL
                 LET g_wsh_t.gae04_2 = NULL
                 DISPLAY BY NAME g_wsh[l_ac].gae04_2
                 SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-805' AND ze02 = g_lang
                 LET l_message = l_ze03
                 CALL cl_msgany(9,10,l_message) 
                 NEXT FIELD wsh10
           END IF


           If g_wsh[l_ac].wsh10 IS NOT NULL THEN
              IF g_wsh[l_ac].wsh10 != g_wsh_t.wsh10 OR g_wsh_t.wsh10 IS NULL THEN
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].wsh10 = g_wsh_t.wsh10
                     DISPLAY BY NAME g_wsh[l_ac].wsh10
                 ELSE
                    LET g_wsh_t.wsh10 = g_wsh[l_ac].wsh10
                    DISPLAY BY NAME g_wsh[l_ac].wsh10
                 END IF
              END IF
            END IF
            LET l_tmp = 0
            SELECT COUNT(*) INTO l_tmp FROM gae_file where gae02 = g_wsh[l_ac].wsh10 AND gae01 = g_wsh[l_ac].wsh09  AND gae03 = g_lang
            IF l_tmp <> 0 THEN
               SELECT gae04 INTO g_wsh[l_ac].gae04_2 FROM gae_file where gae02 = g_wsh[l_ac].wsh10 AND gae01 = g_wsh[l_ac].wsh09  AND gae03 = g_lang
            ELSE
               LET g_wsh[l_ac].gae04_2 = ""
            END IF
            DISPLAY BY NAME g_wsh[l_ac].gae04_2

        AFTER INPUT
        ON ACTION controlp
            CASE
                WHEN INFIELD(wsh09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gav2"
                  LET g_qryparam.state = "i"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  LET g_qryparam.default1 = g_wsh[l_ac].wsh09
                  CALL cl_create_qry() RETURNING g_wsh[l_ac].wsh09
                  DISPLAY BY NAME g_wsh[l_ac].wsh09
                  CALL cl_init_qry_var()
                  
                WHEN INFIELD(wsh10)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gav3"
                   LET g_qryparam.state = "i"
                   LET g_qryparam.default1 = g_wsh[l_ac].wsh10
                   LET g_qryparam.arg1 = g_lang CLIPPED
                   LET g_qryparam.arg2 = g_wsh[l_ac].wsh09
                   CALL cl_create_qry() RETURNING g_wsh[l_ac].wsh10
                   DISPLAY BY NAME g_wsh[l_ac].wsh10
                   LET l_tmp = 0
                   SELECT COUNT(*) INTO l_tmp FROM gae_file where gae02 = g_wsh[l_ac].wsh10 AND gae01 = g_wsh[l_ac].wsh09  AND gae03 = g_lang
                   IF l_tmp <> 0 THEN
                      SELECT gae04 INTO g_wsh[l_ac].gae04_2 FROM gae_file where gae02 = g_wsh[l_ac].wsh10 AND gae01 = g_wsh[l_ac].wsh09  AND gae03 = g_lang
                   ELSE
                      LET g_wsh[l_ac].gae04_2 = ""
                   END IF
                      DISPLAY BY NAME g_wsh[l_ac].gae04_2
                   END CASE
        #CHI-BC0010 -  End  -

        BEFORE DELETE                            #是否取消單身
            IF g_wsh_t.wsh05 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
{ckp#1}           DELETE FROM wsh_file
                  WHERE wsh01 = g_wsd.wsd01 AND
                      wsh02 = p_wsh02 AND
                      wsh03 = g_wsh_t.wsh03 AND
                      wsh04 = g_wsh_t.wsh04 AND
                      wsh05 = g_wsh_t.wsh05
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wsh_t.wsh05,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete Ok"
               CLOSE efcfg2_bcl
               COMMIT WORK
            END IF
 
        AFTER ROW
                CALL efcfg2_set_entry_b()
                LET l_ac = ARR_CURR()
                LET l_ac_t = l_ac
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   IF p_cmd = 'u' THEN
                      LET g_wsh[l_ac].* = g_wsh_t.*
                   END IF
                   CLOSE efcfg2_bcl
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                CLOSE efcfg2_bcl
                COMMIT WORK
 
        ON ROW CHANGE
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   LET g_wsh[l_ac].* = g_wsh_t.*
                   CLOSE efcfg2_bcl
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                IF l_lock_sw = 'Y' THEN
                   CALL cl_err(g_wsh[l_ac].wsh03,-263,1)
                   LET g_wsh[l_ac].* = g_wsh_t.*
                ELSE
                    ## MOD-490275
                   IF g_wsh[l_ac].wsh03 IS NULL THEN
                     CALL cl_err('',9001,0)
                     LET INT_FLAG = 0
                     LET g_wsh[l_ac].* = g_wsh_t.*
                     CLOSE efcfg2_bcl
                     ROLLBACK WORK
                   END IF
                    ## END MOD-490275
                   UPDATE wsh_file SET wsh03 = g_wsh[l_ac].wsh03,
                                       wsh04 = g_wsh[l_ac].wsh04,
                                       wsh05 = g_wsh[l_ac].wsh05,
                                       wsh06 = g_wsh[l_ac].wsh06,
                                       wsh07 = g_wsh[l_ac].wsh07,
                                       wsh08 = g_wsh[l_ac].wsh08,
                                       wsh09 = g_wsh[l_ac].wsh09, #CHI-BC0010
                                       wsh10 = g_wsh[l_ac].wsh10  #CHI-BC0010
                      WHERE wsh01 = g_wsd.wsd01 AND
                            wsh02 = p_wsh02 AND
                            wsh03 = g_wsh_t.wsh03 AND
                            wsh04 = g_wsh_t.wsh04 AND
                            wsh05 = g_wsh_t.wsh05
 
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_wsh[l_ac].wsh05,SQLCA.sqlcode,0)   #No.FUN-660155
                      CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                      LET g_wsh[l_ac].* = g_wsh_t.*
                      CLOSE efcfg2_bcl
                      ROLLBACK WORK
                   ELSE
                      MESSAGE 'UPDATE O.K'
                      CLOSE efcfg2_bcl
                      COMMIT WORK
                   END IF
                END IF
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION column_ref2
            CASE
                WHEN INFIELD(wsh06)
                    CALL fromowner_ref('H',g_wsh[l_ac].wsh06,g_wsh_t.wsh06,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                    IF INT_FLAG THEN
                        LET INT_FLAG = 0
                        LET g_wsh[l_ac].wsh06 = g_wsh_t.wsh06
                        DISPLAY BY NAME g_wsh[l_ac].wsh06
                    ELSE
                       UPDATE wsh_file SET wsh_file.wsh06 = g_wsi.wsi02    # 更新DB
                           WHERE wsh01 = g_wsd.wsd01 AND
                               wsh02 = p_wsh02 AND
                               wsh03 = g_wsh_t.wsh03 AND
                               wsh04 = g_wsh_t.wsh04 AND
                               wsh05 = g_wsh_t.wsh05
                       IF SQLCA.sqlcode THEN
#                         CALL cl_err(g_wsh[l_ac].wsh06,SQLCA.sqlcode,0)   #No.FUN-660155
                          CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                       END IF
                       LET g_wsh[l_ac].wsh06 = g_wsi.wsi02
                       LET g_wsh_t.wsh06 = g_wsh[l_ac].wsh06
                       DISPLAY BY NAME g_wsh[l_ac].wsh06
                    END IF
                WHEN INFIELD(wsh07)
                    CALL fromowner_ref('H',g_wsh[l_ac].wsh07,g_wsh_t.wsh07,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                    IF INT_FLAG THEN
                        LET INT_FLAG = 0
                        LET g_wsh[l_ac].wsh07 = g_wsh_t.wsh07
                        DISPLAY BY NAME g_wsh[l_ac].wsh07
                    ELSE
                       UPDATE wsh_file SET wsh_file.wsh07 = g_wsi.wsi02    # 更新DB
                           WHERE wsh01 = g_wsd.wsd01 AND
                               wsh02 = p_wsh02 AND
                               wsh03 = g_wsh_t.wsh03 AND
                               wsh04 = g_wsh_t.wsh04 AND
                               wsh05 = g_wsh_t.wsh05
                       IF SQLCA.sqlcode THEN
#                         CALL cl_err(g_wsh[l_ac].wsh07,SQLCA.sqlcode,0)   #No.FUN-660155
                          CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                       END IF
                       LET g_wsh[l_ac].wsh07 = g_wsi.wsi02
                       LET g_wsh_t.wsh07 = g_wsh[l_ac].wsh07
                       DISPLAY BY NAME g_wsh[l_ac].wsh07
                    END IF
                WHEN INFIELD(wsh08)
                    CALL fromowner_ref('H',g_wsh[l_ac].wsh08,g_wsh_t.wsh08,g_wsh[l_ac].wsh05,g_wsh_t.wsh05)
                    IF INT_FLAG THEN
                        LET INT_FLAG = 0
                        LET g_wsh[l_ac].wsh08 = g_wsh_t.wsh08
                        DISPLAY BY NAME g_wsh[l_ac].wsh08
                    ELSE
                       UPDATE wsh_file SET wsh_file.wsh08 = g_wsi.wsi02    # 更新DB
                           WHERE wsh01 = g_wsd.wsd01 AND
                               wsh02 = p_wsh02 AND
                               wsh03 = g_wsh_t.wsh03 AND
                               wsh04 = g_wsh_t.wsh04 AND
                               wsh05 = g_wsh_t.wsh05
                       IF SQLCA.sqlcode THEN
#                           CALL cl_err(g_wsh[l_ac].wsh08,SQLCA.sqlcode,0)   #No.FUN-660155
                            CALL cl_err3("upd","wsh_file",g_wsd.wsd01,p_wsh02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                       END IF
                       LET g_wsh[l_ac].wsh08 = g_wsi.wsi02
                       LET g_wsh_t.wsh08 = g_wsh[l_ac].wsh08
                       DISPLAY BY NAME g_wsh[l_ac].wsh08
                    END IF
            END CASE
 
#        ON ACTION CONTROLO                        #沿用所有欄位
#            IF INFIELD(wsh03) AND l_ac > 1 THEN
#                LET g_wsh[l_ac].* = g_wsh[l_ac-1].*
#                NEXT FIELD wsh03
#            END IF
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
    END INPUT
    #FUN-770047
    #IF p_wsh02 = "M" THEN
    #    CALL cl_set_comp_visible("wsh03",TRUE)
    #END IF
    CASE p_wsh02
        WHEN "M"
             CALL cl_set_comp_visible("wsh03",FALSE)
        WHEN "R"
             CALL cl_set_comp_visible("wsh03,wsh06,wsh07,wsh08",FALSE)
             CALL cl_set_act_visible("column_ref2", FALSE)
    END CASE
    #END FUN-770047
 
    CLOSE efcfg2_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION efcfg2_copy()
 DEFINE l_newno         LIKE wsd_file.wsd01,
        l_oldno         LIKE wsd_file.wsd01,
    l_cnt        LIKE type_file.num5     #No.FUN-680130 SMALLINT
 DEFINE l_zz01          LIKE zz_file.zz01,      #FUN-5A0207
        l_zz011         LIKE zz_file.zz011      #FUN-5A0207
 
    IF s_shut(0) THEN RETURN END IF
    IF g_wsd.wsd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    INPUT l_newno FROM wsd01
         BEFORE INPUT
            #DISPLAY '' TO zz02   #MOD-730038
            DISPLAY '' TO gaz03   #MOD-730038
 
         AFTER FIELD wsd01
            IF l_newno IS NULL THEN
                NEXT FIELD wsd01
            END IF
            SELECT zz01,zz011 INTO l_zz01,l_zz011
               FROM zz_file WHERE zz01 = l_newno       #FUN-5A0207
            IF SQLCA.SQLCODE THEN
              CALL cl_err(l_newno,SQLCA.SQLCODE,0)   
               NEXT FIELD wsd01
            END IF
            SELECT COUNT(*) INTO l_cnt FROM wsd_file WHERE wsd01 = l_newno
            IF l_cnt > 0 THEN                  # Duplicated
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD wsd01
            END IF
            #CALL efcfg2_zz02(l_newno)   #MOD-730038
            CALL efcfg2_gaz03(l_newno)   #MOD-730038
 
            #FUN-5A0207
            IF l_zz011 = "APY" OR l_zz011="CPY" OR l_zz011="GPY" THEN
                 CALL cl_set_comp_required("wsg07,wsg08,wsg09", FALSE) 
                 CALL cl_set_comp_entry("wsg10", FALSE)  #FUN-640184 
            ELSE
                 CALL cl_set_comp_entry("wsg10", TRUE)  #FUN-640184 
            END IF
            #END FUN-5A0207
 
         ON ACTION controlp
             CASE
                 WHEN INFIELD(wsd01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz1"
                   LET g_qryparam.default1 = l_newno
                   LET g_qryparam.default2 = NULL
                   LET g_qryparam.arg1 = g_lang CLIPPED
                   #CALL cl_create_qry() RETURNING l_newno,g_zz02   #MOD-730038
                   CALL cl_create_qry() RETURNING l_newno,g_gaz03   #MOD-730038
                   DISPLAY l_newno TO wsd01
                   #DISPLAY g_zz02 TO FORMONLY.zz02   #MOD-730038
                   DISPLAY g_gaz03 TO FORMONLY.gaz03   #MOD-730038
             END CASE
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_wsd.wsd01
        #CALL efcfg2_zz02(g_wsd.wsd01)   #MOD-730038
        CALL efcfg2_gaz03(g_wsd.wsd01)   #MOD-730038
        RETURN
    END IF
 
    BEGIN WORK
 
    DROP TABLE x
    SELECT * FROM wsd_file WHERE wsd01 = g_wsd.wsd01 INTO TEMP x
    UPDATE x SET wsd01 = l_newno,
                 wsdacti = 'Y',
                 wsduser = g_user,
                 wsdgrup= g_grup,
                 wsdmodu = NULL,
                 wsddate = g_today
    INSERT INTO wsd_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wsd_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wse_file WHERE wse01 = g_wsd.wsd01 INTO TEMP x
    UPDATE x SET wse01 = l_newno
    INSERT INTO wse_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wse_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wsh_file WHERE wsh01 = g_wsd.wsd01 INTO TEMP x
    UPDATE x SET wsh01 = l_newno
    INSERT INTO wsh_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wsh_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wsf_file WHERE wsf01 = g_wsd.wsd01 INTO TEMP x
    UPDATE x SET wsf01 = l_newno
    INSERT INTO wsf_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wsf_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wsg_file WHERE wsg01 = g_wsd.wsd01 INTO TEMP x
    UPDATE x SET wsg01 = l_newno
    INSERT INTO wsg_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wsg_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wsi_file WHERE wsi01 = g_wsd.wsd01 INTO TEMP x
    UPDATE x SET wsi01 = l_newno
    INSERT INTO wsi_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wsi_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
 
    #FUN-770047
    DROP TABLE x
    SELECT * FROM wsq_file WHERE wsq01 = g_wsd.wsd01 INTO TEMP x
    UPDATE x SET wsq01 = l_newno
    INSERT INTO wsq_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","wsq_file",l_newno,"",SQLCA.sqlcode,"","",0)  
        ROLLBACK WORK
        RETURN
    END IF
    #END FUN-770047
 
    MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
    LET l_oldno = g_wsd.wsd01
    LET g_wsd.wsd01 = l_newno
    SELECT wsd_file.* INTO g_wsd.* FROM wsd_file
           WHERE wsd01 = l_newno
    CALL efcfg2_u()
    #FUN-C80046---begin
    #SELECT wsd_file.* INTO g_wsd.* FROM wsd_file  
    #       WHERE wsd01 = l_oldno                  
    #
    #LET g_wsd.wsd01 = l_oldno                     
    #CALL efcfg2_show()
    #FUN-C80046---end
    OPEN efcfg2_count
    FETCH efcfg2_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    IF l_newno < l_oldno THEN
       LET g_curs_index = g_curs_index + 1
    END IF
    CALL cl_navigator_setting(g_curs_index, g_row_count)
    
    OPEN efcfg2_cs
    LET g_jump = g_curs_index
    LET mi_no_ask = TRUE   #No.FUN-6A0075
    CALL efcfg2_fetch('/')
    #FUN-C80046---begin
    SELECT wsd_file.* INTO g_wsd.* FROM wsd_file
           WHERE wsd01 = l_newno
    CALL efcfg2_show()    
    #FUN-C80046---end
END FUNCTION
 
FUNCTION efcfg2_set_entry()
   IF g_wse.wse03 IS NOT NULL THEN
       CALL cl_set_comp_entry("wse04", TRUE)
   END IF
   IF g_wse.wse04 IS NOT NULL THEN
       CALL cl_set_comp_entry("wse05", TRUE)
   END IF
   IF g_wse.wse05 IS NOT NULL THEN
       CALL cl_set_comp_entry("wse06", TRUE)
   END IF
   IF g_wse.wse06 IS NOT NULL THEN
       CALL cl_set_comp_entry("wse07", TRUE)
   END IF
   IF g_wsf.wsf04 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsf05", TRUE)
   END IF
   IF g_wsf.wsf05 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsf06", TRUE)
   END IF
   IF g_wsf.wsf06 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsf07", TRUE)
   END IF
   IF g_wsf.wsf07 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsf08", TRUE)
   END IF
   #FUN-770047
   IF g_wsq.wsq03 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsq04", TRUE)
   END IF
   IF g_wsq.wsq04 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsq05", TRUE)
   END IF
   IF g_wsq.wsq05 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsq06", TRUE)
   END IF
   IF g_wsq.wsq06 IS NOT NULL THEN
       CALL cl_set_comp_entry("wsq07", TRUE)
   END IF
   #END FUN-770047
 
END FUNCTION
 
FUNCTION efcfg2_set_no_entry()
   IF g_wse.wse03 IS NULL THEN
       CALL cl_set_comp_entry("wse04,wse05,wse06,wse07", FALSE)
       LET g_wse.wse04 = NULL
       LET g_wse.wse05 = NULL
       LET g_wse.wse06 = NULL
       LET g_wse.wse07 = NULL
   END IF
   IF g_wse.wse04 IS NULL THEN
       CALL cl_set_comp_entry("wse05,wse06,wse07", FALSE)
       LET g_wse.wse05 = NULL
       LET g_wse.wse06 = NULL
       LET g_wse.wse07 = NULL
   END IF
   IF g_wse.wse05 IS NULL THEN
       CALL cl_set_comp_entry("wse06,wse07", FALSE)
       LET g_wse.wse06 = NULL
       LET g_wse.wse07 = NULL
   END IF
   IF g_wse.wse06 IS NULL THEN
       CALL cl_set_comp_entry("wse07", FALSE)
       LET g_wse.wse07 = NULL
   END IF
   IF g_wsf.wsf04 IS NULL THEN
       CALL cl_set_comp_entry("wsf05,wsf06,wsf07,wsf08", FALSE)
       LET g_wsf.wsf05 = NULL
       LET g_wsf.wsf06 = NULL
       LET g_wsf.wsf07 = NULL
       LET g_wsf.wsf08 = NULL
   END IF
   IF g_wsf.wsf05 IS NULL THEN
       CALL cl_set_comp_entry("wsf06,wsf07,wsf08", FALSE)
       LET g_wsf.wsf06 = NULL
       LET g_wsf.wsf07 = NULL
       LET g_wsf.wsf08 = NULL
   END IF
   IF g_wsf.wsf06 IS NULL THEN
       CALL cl_set_comp_entry("wsf07,wsf08", FALSE)
       LET g_wsf.wsf07 = NULL
       LET g_wsf.wsf08 = NULL
   END IF
   IF g_wsf.wsf07 IS NULL THEN
       CALL cl_set_comp_entry("wsf08", FALSE)
       LET g_wsf.wsf08 = NULL
   END IF
   #FUN-770047
   IF g_wsq.wsq03 IS NULL THEN
       CALL cl_set_comp_entry("wsq04,wsq05,wsq06,wsq07", FALSE)
       LET g_wsq.wsq04 = NULL
       LET g_wsq.wsq05 = NULL
       LET g_wsq.wsq06 = NULL
       LET g_wsq.wsq07 = NULL
   END IF
   IF g_wsq.wsq04 IS NULL THEN
       CALL cl_set_comp_entry("wsq05,wsq06,wsq07", FALSE)
       LET g_wsq.wsq05 = NULL
       LET g_wsq.wsq06 = NULL
       LET g_wsq.wsq07 = NULL
   END IF
   IF g_wsq.wsq05 IS NULL THEN
       CALL cl_set_comp_entry("wsq06,wsq07", FALSE)
       LET g_wsq.wsq06 = NULL
       LET g_wsq.wsq07 = NULL
   END IF
   IF g_wsq.wsq06 IS NULL THEN
       CALL cl_set_comp_entry("wsq07", FALSE)
       LET g_wsq.wsq07 = NULL
   END IF
   #END FUN-770047
 
END FUNCTION
 
FUNCTION efcfg2_set_entry_b()
       CALL cl_set_comp_entry("wsh04,wsh06,wsh07", TRUE)
END FUNCTION
 
FUNCTION efcfg2_set_no_entry_b()
       CALL cl_set_comp_entry("wsh04,wsh06,wsh07", FALSE)
END FUNCTION
 
FUNCTION efcfg2_field_wse(p_colname)
   DEFINE p_colname STRING
 
   IF NOT INFIELD(wse03) AND g_wse.wse03 IS NOT NULL THEN
      IF g_wse.wse03 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse04) AND g_wse.wse04 IS NOT NULL THEN
     IF g_wse.wse04 CLIPPED = p_colname CLIPPED THEN
        RETURN 0
     END IF
   END IF
   IF NOT INFIELD(wse05) AND g_wse.wse05 IS NOT NULL THEN
      IF g_wse.wse05 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse06) AND g_wse.wse06 IS NOT NULL THEN
      IF g_wse.wse06 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse07) AND g_wse.wse07 IS NOT NULL THEN
      IF g_wse.wse07 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse08) AND g_wse.wse08 IS NOT NULL THEN
      IF g_wse.wse08 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse09) AND g_wse.wse09 IS NOT NULL THEN
      IF g_wse.wse09 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse10) AND g_wse.wse10 IS NOT NULL THEN
      IF g_wse.wse10 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse11) AND g_wse.wse11 IS NOT NULL THEN
      IF g_wse.wse11 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wse12) AND g_wse.wse12 IS NOT NULL THEN
      IF g_wse.wse12 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   #FUN-5A0207
   #IF NOT INFIELD(wse13) AND g_wse.wse13 IS NOT NULL THEN
   #   IF g_wse.wse13 CLIPPED = p_colname CLIPPED THEN
   #      RETURN 0
   #   END IF
   #END IF
   #END FUN-5A0207
   RETURN 1
END FUNCTION
 
FUNCTION efcfg2_field_wsg(p_colname)
   DEFINE p_colname LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
 
   IF NOT INFIELD(wsg03) AND g_wsg.wsg03 IS NOT NULL THEN
      IF g_wsg.wsg03 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsg04) AND g_wsg.wsg04 IS NOT NULL THEN
      IF g_wsg.wsg04 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsg05) AND g_wsg.wsg05 IS NOT NULL THEN
      IF g_wsg.wsg05 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsg07) AND g_wsg.wsg07 IS NOT NULL THEN
     IF g_wsg.wsg07 CLIPPED = p_colname CLIPPED THEN
        RETURN 0
     END IF
   END IF
   IF NOT INFIELD(wsg09) AND g_wsg.wsg09 IS NOT NULL THEN
      IF g_wsg.wsg09 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   #FUN-640184
   IF NOT INFIELD(wsg10) AND g_wsg.wsg10 IS NOT NULL THEN
      IF g_wsg.wsg10 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   #END FUN-640184
   RETURN 1
END FUNCTION
 
FUNCTION efcfg2_field_wsf(p_colname)
   DEFINE p_colname LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
 
   IF NOT INFIELD(wsf04) AND g_wsf.wsf04 IS NOT NULL THEN
      IF g_wsf.wsf04 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsf05) AND g_wsf.wsf05 IS NOT NULL THEN
      IF g_wsf.wsf05 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsf06) AND g_wsf.wsf06 IS NOT NULL THEN
      IF g_wsf.wsf06 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsf07) AND g_wsf.wsf07 IS NOT NULL THEN
      IF g_wsf.wsf07 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsf08) AND g_wsf.wsf08 IS NOT NULL THEN
      IF g_wsf.wsf08 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsf09) AND g_wsf.wsf09 IS NOT NULL THEN
      IF g_wsf.wsf09 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   RETURN 1
END FUNCTION
 
#FUN-770047
FUNCTION efcfg2_field_wsq(p_colname)
   DEFINE p_colname STRING
 
   IF NOT INFIELD(wsq03) AND g_wsq.wsq03 IS NOT NULL THEN
      IF g_wsq.wsq03 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsq04) AND g_wsq.wsq04 IS NOT NULL THEN
     IF g_wsq.wsq04 CLIPPED = p_colname CLIPPED THEN
        RETURN 0
     END IF
   END IF
   IF NOT INFIELD(wsq05) AND g_wsq.wsq05 IS NOT NULL THEN
      IF g_wsq.wsq05 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsq06) AND g_wsq.wsq06 IS NOT NULL THEN
      IF g_wsq.wsq06 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wsq07) AND g_wsq.wsq07 IS NOT NULL THEN
      IF g_wsq.wsq07 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   RETURN 1
END FUNCTION
#END FUN-770047
 
FUNCTION efcfg2_combobox(p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
    DEFINE l_colname    LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
    DEFINE l_items      STRING
    DEFINE l_i          LIKE type_file.num10   #No.FUN-680130 INTEGER

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構 
    #CASE cl_db_get_database_type()
    ##FUN-5A0136
    #CASE cl_db_get_database_type()
    #    WHEN "ORA"
    #         LET g_sql= "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = UPPER('",p_tabname CLIPPED,"') AND OWNER='DS' ORDER BY COLUMN_ID"
    #    WHEN "IFX"
    #         LET g_sql = "SELECT colname FROM ds:syscolumns col, ds:systables tab WHERE tab.tabname = '",p_tabname CLIPPED ,"' AND tab.tabid = col.tabid ORDER BY colno"  #MOD-930113
    #END CASE
    ##END FUN-5A0136
    LET g_sql= "SELECT sch02 FROM sch_file ", 
               "  WHERE sch01 = '",p_tabname CLIPPED,"' ",
               " ORDER BY sch05"
    #---FUN-A90024---end-------  
 
    DECLARE efcfg2_cur5 CURSOR FROM g_sql
    LET l_i=0
    INITIALIZE l_items TO NULL
    FOREACH efcfg2_cur5 INTO l_colname
            LET l_i = l_i + 1
            IF l_i = 1 THEN
               LET l_items = l_colname CLIPPED
            ELSE
               LET l_items = l_items,",",l_colname CLIPPED
            END IF
    END FOREACH
    LET l_items = l_items.toLowerCase()
    RETURN l_items
END FUNCTION
 
FUNCTION efcfg2_combo_list()
DEFINE   l_items      STRING
      IF INFIELD(wse02) OR g_beforeinput="FALSE" THEN
               LET l_items = efcfg2_combobox(g_wse.wse02)
               CALL cl_set_combo_items("wse03",l_items,l_items)
               CALL cl_set_combo_items("wse04",l_items,l_items)
               CALL cl_set_combo_items("wse05",l_items,l_items)
               CALL cl_set_combo_items("wse06",l_items,l_items)
               CALL cl_set_combo_items("wse07",l_items,l_items)
               CALL cl_set_combo_items("wse08",l_items,l_items)
               CALL cl_set_combo_items("wse09",l_items,l_items)
               CALL cl_set_combo_items("wse10",l_items,l_items)
               CALL cl_set_combo_items("wse11",l_items,l_items)
               CALL cl_set_combo_items("wse12",l_items,l_items)
      END IF
 
      IF INFIELD(wsf03) OR g_beforeinput="FALSE" THEN
               LET l_items = efcfg2_combobox(g_wsf.wsf03)
               CALL cl_set_combo_items("wsf04",l_items,l_items)
               CALL cl_set_combo_items("wsf05",l_items,l_items)
               CALL cl_set_combo_items("wsf06",l_items,l_items)
               CALL cl_set_combo_items("wsf07",l_items,l_items)
               CALL cl_set_combo_items("wsf08",l_items,l_items)
               CALL cl_set_combo_items("wsf09",l_items,l_items)
      END IF
 
      IF INFIELD(wsg02) OR g_beforeinput="FALSE" THEN
               LET l_items = efcfg2_combobox(g_wsg.wsg02)
               CALL cl_set_combo_items("wsg03",l_items,l_items)
               CALL cl_set_combo_items("wsg04",l_items,l_items)
               CALL cl_set_combo_items("wsg05",l_items,l_items)
               CALL cl_set_combo_items("wsg07",l_items,l_items)
               CALL cl_set_combo_items("wsg09",l_items,l_items)
               CALL cl_set_combo_items("wsg10",l_items,l_items)  #FUN-640184
      END IF
 
      #FUN-770047
      IF INFIELD(wsq02) OR g_beforeinput="FALSE" THEN
               LET l_items = efcfg2_combobox(g_wsq.wsq02)
               CALL cl_set_combo_items("wsq03",l_items,l_items)
               CALL cl_set_combo_items("wsq04",l_items,l_items)
               CALL cl_set_combo_items("wsq05",l_items,l_items)
               CALL cl_set_combo_items("wsq06",l_items,l_items)
               CALL cl_set_combo_items("wsq07",l_items,l_items)
      END IF
      #END FUN-770047
 
END FUNCTION
 
FUNCTION fromowner_ref(p_cmd,p_ref1,p_ref1_t,p_ref2,p_ref2_t)
DEFINE p_cmd     LIKE type_file.chr1   # E: wse_file, H: wsh_file  #No.FUN-680130 VARCHAR(1)
DEFINE l_cmd     LIKE type_file.chr1   #No.FUN-680130 VARCHAR(1)
DEFINE l_cnt     LIKE type_file.num10  #No.FUN-680130 INTEGER
DEFINE l_ref01   STRING
DEFINE p_ref1    LIKE wsi_file.wsi02   #wse13 OR wsh06,wsh07,wsh08 (參考欄位)
DEFINE p_ref1_t  LIKE wsi_file.wsi02   #wse13_t OR wsh06_t,wsh07_t,wsh08_t (舊參考欄位)
DEFINE p_ref2    LIKE wsi_file.wsi05   #wse03 OR wsh05 (key值)
DEFINE p_ref2_t  LIKE wsi_file.wsi05   #wse03_t OR wsh05_t (舊key值)
 
    INITIALIZE g_wsi.* TO NULL
    SELECT COUNT(*) INTO l_cnt FROM wsi_file where wsi01=g_wsd.wsd01
       AND wsi02 = p_ref1_t AND wsi05 = p_ref2_t
    IF l_cnt = 0 THEN
       LET l_cmd = 'a'
    ELSE
       LET l_cmd = 'u'
       SELECT * INTO g_wsi.* FROM wsi_file where wsi01=g_wsd.wsd01
          AND wsi02 = p_ref1_t AND wsi05 = p_ref2_t
    END IF
 
    OPEN WINDOW efcfg2_ref AT 4, 16
        WITH FORM "aws/42f/aws_efcfg_ref" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("aws_efcfg_ref")
 
    MESSAGE ''
    IF l_cmd = 'u' THEN
       DISPLAY BY NAME g_wsi.wsi02,g_wsi.wsi03,g_wsi.wsi04, g_wsi.wsi05,g_wsi.wsi06
       IF g_wsi.wsi02 IS NOT NULL OR g_wsi.wsi02 <> "" THEN
          LET g_gat03 = NULL
          SELECT gat03 INTO g_gat03 FROM gat_file
            WHERE gat01 = g_wsi.wsi03
                  AND gat02 = g_lang
          DISPLAY g_gat03 TO FORMONLY.ref01
          #FUN-640182 ---start
          SELECT gaq03 INTO g_gaq03 FROM gaq_file   
            WHERE gaq01 = g_wsi.wsi02 
                  and gaq02 = g_lang 
          DISPLAY g_gaq03 TO FORMONLY.gaq03
          #FUN-640182 ---end
       ELSE
          DISPLAY "" TO FORMONLY.ref01
          DISPLAY "" TO FORMONLY.gaq03    ##FUN-640182
       END IF
       
    END IF
    INPUT BY NAME
        g_wsi.wsi02,g_wsi.wsi03,g_wsi.wsi04,g_wsi.wsi06
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
           LET g_wsi.wsi01=g_wsd.wsd01
           LET g_wsi.wsi02=p_ref1
           LET g_wsi.wsi05=p_ref2
 
           DISPLAY BY NAME g_wsi.wsi05
           DISPLAY BY NAME g_wsi.wsi02
        ON CHANGE wsi03
             LET g_wsi.wsi04 = NULL
        #FUN-640182 ---start
        AFTER FIELD wsi02        
               LET g_gaq03 = NULL
               SELECT gaq03 INTO g_gaq03 FROM gaq_file   
               WHERE gaq01 = g_wsi.wsi02 
                 and gaq02 = g_lang 
               DISPLAY g_gaq03 TO FORMONLY.gaq03
        #FUN-640182 ---end
        AFTER FIELD wsi03
            IF g_wsi.wsi03 IS NULL THEN
               CALL cl_err(NULL,"aws-067", 0)
               DISPLAY '' TO FORMONLY.ref01
               NEXT FIELD wsi03
            END IF
            IF g_wsi.wsi03 IS NOT NULL THEN
               IF NOT efcfg2_tab(g_wsi.wsi03) THEN
                  DISPLAY '' TO FORMONLY.ref01
                  NEXT FIELD wsi03
               END IF
               LET g_gat03 = NULL
               SELECT gat03 INTO g_gat03 FROM gat_file
                 WHERE gat01 = g_wsi.wsi03
                       AND gat02 = g_lang
                 DISPLAY g_gat03 TO FORMONLY.ref01
            END IF
 
        AFTER FIELD wsi04
            IF g_wsi.wsi04 IS NOT NULL THEN
               IF NOT efcfg2_col(g_wsi.wsi04,g_wsi.wsi03) THEN NEXT FIELD wsi04 END IF
            END IF
 
 
        AFTER INPUT
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF NOT efcfg2_col(g_wsi.wsi02,g_wsi.wsi03) THEN NEXT FIELD wsi02 END IF
           #IF g_wsi.wsi02 = g_wsi.wsi04 THEN
           #     CALL cl_err(NULL,-239,1)
           #     NEXT FIELD wsi02
           #END IF
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wsi03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsi.wsi03
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsi.wsi03,l_ref01
 
                  DISPLAY BY NAME g_wsi.wsi03
                  DISPLAY l_ref01 TO FORMONLY.ref01
            END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
    END INPUT
 
    IF INT_FLAG THEN
        CLOSE WINDOW efcfg2_ref
        IF p_cmd = "E" THEN
             LET INT_FLAG = 0
        END IF
        RETURN
    END IF
    IF l_cmd = 'a' THEN
        INSERT INTO wsi_file VALUES(g_wsi.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsi.wsi01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("ins","wsi_file",g_wsi.wsi01,g_wsi.wsi02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CLOSE WINDOW efcfg2_ref
            RETURN
        END IF
    ELSE
        UPDATE wsi_file SET wsi_file.* = g_wsi.*    # 更新DB
            WHERE wsi01 = g_wsd.wsd01 AND wsi02 = p_ref1_t AND wsi05 = p_ref2_t
 
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsi.wsi01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsi_file",g_wsd.wsd01,p_ref1_t,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    END IF
    IF p_cmd = 'E' THEN
       UPDATE wse_file SET wse_file.wse13 = g_wsi.wsi02,    # 更新DB
                           wse_file.wse03 = g_wsi.wsi05
           WHERE wse01 = g_wsd.wsd01
       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_wsd.wsd01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("upd","wse_file",g_wsd.wsd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
       END IF
       LET g_wse.wse13 = g_wsi.wsi02
       LET g_wse.wse03 = g_wsi.wsi05
       LET g_wse_t.wse13 = g_wse.wse13
       LET g_wse_t.wse03 = g_wse.wse03
       DISPLAY BY NAME g_wse.wse13
       DISPLAY BY NAME g_wse.wse03
    END IF
    CLOSE WINDOW efcfg2_ref
END FUNCTION
 
FUNCTION aws_set_detail(p_item)
DEFINE p_item          LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE l_message       STRING
DEFINE l_ze03          LIKE ze_file.ze03
DEFINE l_cnt           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_cmd           LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE l_wsf03_t       LIKE wsf_file.wsf03
DEFINE l_items         STRING
DEFINE l_change        LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    LET g_wsf_o.* = g_wsf.*
 
    INITIALIZE g_wsf.* TO NULL
    LET g_wsf.wsf02 = p_item
    SELECT COUNT(*) INTO l_cnt FROM wsf_file
      WHERE wsf01=g_wsd.wsd01 AND wsf02 = g_wsf.wsf02
    IF l_cnt = 0 THEN
       LET l_cmd = 'a'
    ELSE
       LET l_cmd = 'u'
       SELECT * INTO g_wsf.* FROM wsf_file
        WHERE wsf01=g_wsd.wsd01 AND wsf02 = g_wsf.wsf02
       LET l_wsf03_t=g_wsf.wsf03
       CALL efcfg2_combo_list()
    END IF
 
    OPEN WINDOW efcfg2_detail AT 4, 16
        WITH FORM "aws/42f/aws_efcfg_detail" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("aws_efcfg_detail")
 
    MESSAGE ''
    IF l_cmd = 'u' THEN
       DISPLAY BY NAME
        g_wsf.wsf03,g_wsf.wsf04,g_wsf.wsf05,g_wsf.wsf06,g_wsf.wsf07,
        g_wsf.wsf08,g_wsf.wsf09
 
       IF g_wsf.wsf03 IS NOT NULL OR g_wsf.wsf03 <> "" THEN
          LET g_gat03 = NULL
          SELECT gat03 INTO g_gat03 FROM gat_file
            WHERE gat01 = g_wsf.wsf03
                  AND gat02 = g_lang
          DISPLAY g_gat03 TO FORMONLY.detail01
       ELSE
          DISPLAY "" TO FORMONLY.detail01
       END IF
    END IF
    INPUT BY NAME
        g_wsf.wsf03,g_wsf.wsf04,g_wsf.wsf05,g_wsf.wsf06,g_wsf.wsf07,
        g_wsf.wsf08,g_wsf.wsf09
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        BEFORE INPUT
            LET g_wsf.wsf01 = g_wsd.wsd01
            CALL cl_set_comp_required("wsf03,wsf04", FALSE)
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
            LET l_items = efcfg2_combobox(g_wsf.wsf03)
            CALL cl_set_combo_items("wsf04",l_items,l_items)
            CALL cl_set_combo_items("wsf05",l_items,l_items)
            CALL cl_set_combo_items("wsf06",l_items,l_items)
            CALL cl_set_combo_items("wsf07",l_items,l_items)
            CALL cl_set_combo_items("wsf08",l_items,l_items)
            CALL cl_set_combo_items("wsf09",l_items,l_items)
 
        BEFORE FIELD wsf03
            LET l_change = FALSE
 
        ON CHANGE wsf03
            LET l_change = TRUE
 
        AFTER FIELD wsf03
            IF g_wsf.wsf03 IS NOT NULL THEN
               IF l_change THEN
                  IF NOT efcfg2_tab(g_wsf.wsf03) THEN
                     DISPLAY  '' TO FORMONLY.detail01
                     NEXT FIELD wsf03
                  END IF
                  IF (g_wse.wse02 = g_wsf.wsf03) OR (g_wsf.wsf03=g_wsg.wsg02) OR
                     (g_wsq.wsq02 = g_wsf.wsf03)            #FUN-770047
                  THEN
                      CALL cl_err(g_wsf.wsf03,-239,0)
                      NEXT FIELD wsf03
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM wsf_file
                   WHERE wsf01 = g_wsf.wsf01 AND wsf03 = g_wsf.wsf03
                  IF l_cnt > 0 THEN
                      CALL cl_err(g_wsf.wsf03,-239,0)
                      NEXT FIELD wsf03
                  END IF
 
                  LET g_gat03 = NULL
                  SELECT gat03 INTO g_gat03 FROM gat_file
                    WHERE gat01 = g_wsf.wsf03
                          AND gat02 = g_lang
                  DISPLAY g_gat03 TO FORMONLY.detail01
 
                  LET g_wsf.wsf04 = NULL
                  LET g_wsf.wsf05 = NULL
                  LET g_wsf.wsf06 = NULL
                  LET g_wsf.wsf07 = NULL
                  LET g_wsf.wsf08 = NULL
                  LET g_wsf.wsf09 = NULL
                  LET l_items = efcfg2_combobox(g_wsf.wsf03)
                  CALL cl_set_combo_items("wsf04",l_items,l_items)
                  CALL cl_set_combo_items("wsf05",l_items,l_items)
                  CALL cl_set_combo_items("wsf06",l_items,l_items)
                  CALL cl_set_combo_items("wsf07",l_items,l_items)
                  CALL cl_set_combo_items("wsf08",l_items,l_items)
                  CALL cl_set_combo_items("wsf09",l_items,l_items)
               END IF
            ELSE
               LET g_wsf.wsf04 = NULL
               LET g_wsf.wsf05 = NULL
               LET g_wsf.wsf06 = NULL
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               LET g_wsf.wsf09 = NULL
               CALL cl_set_combo_items("wsf04",NULL,NULL)
               CALL cl_set_combo_items("wsf05",NULL,NULL)
               CALL cl_set_combo_items("wsf06",NULL,NULL)
               CALL cl_set_combo_items("wsf07",NULL,NULL)
               CALL cl_set_combo_items("wsf08",NULL,NULL)
               CALL cl_set_combo_items("wsf09",NULL,NULL)
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf04
            IF g_wsf.wsf04 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf05", TRUE)
            ELSE
               LET g_wsf.wsf05 = NULL
               LET g_wsf.wsf06 = NULL
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf05", FALSE)
               CALL cl_set_comp_entry("wsf06", FALSE)
               CALL cl_set_comp_entry("wsf07", FALSE)
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf04
            IF g_wsf.wsf04 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf04) THEN
                  CALL cl_err(g_wsf.wsf04,-239,0)
                  NEXT FIELD wsf04
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf05
            IF g_wsf.wsf05 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf06", TRUE)
            ELSE
               LET g_wsf.wsf06 = NULL
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf06", FALSE)
               CALL cl_set_comp_entry("wsf07", FALSE)
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf05
            IF g_wsf.wsf05 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf05) THEN
                  CALL cl_err(g_wsf.wsf05,-239,0)
                  NEXT FIELD wsf05
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf06
            IF g_wsf.wsf06 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf07", TRUE)
            ELSE
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf07", FALSE)
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf06
            IF g_wsf.wsf06 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf06) THEN
                  CALL cl_err(g_wsf.wsf06,-239,0)
                  NEXT FIELD wsf06
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        ON CHANGE wsf07
            IF g_wsf.wsf07 IS NOT NULL THEN
               CALL cl_set_comp_entry("wsf08", TRUE)
            ELSE
               LET g_wsf.wsf08 = NULL
               CALL cl_set_comp_entry("wsf08", FALSE)
            END IF
 
        AFTER FIELD wsf07
            IF g_wsf.wsf07 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf07) THEN
                  CALL cl_err(g_wsf.wsf07,-239,0)
                  NEXT FIELD wsf07
               END IF
            END IF
            CALL efcfg2_set_no_entry()
            CALL efcfg2_set_entry()
 
        AFTER FIELD wsf08
            IF g_wsf.wsf08 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf08) THEN
                  CALL cl_err(g_wsf.wsf08,-239,0)
                  NEXT FIELD wsf08
               END IF
            END IF
 
        AFTER FIELD wsf09
            IF g_wsf.wsf09 IS NOT NULL THEN
               IF NOT efcfg2_field_wsf(g_wsf.wsf09) THEN
                  CALL cl_err(g_wsf.wsf09,-239,0)
                  NEXT FIELD wsf09
               END IF
            END IF
 
         AFTER INPUT
               IF g_wsf.wsf03 IS NULL THEN
                  INITIALIZE g_wsf.* TO NULL
               END IF
 
        ON ACTION aws_detail_del
            IF g_wsf.wsf03 IS NULL THEN
                CALL cl_err('',-400,0)
                NEXT FIELD wsf03
            END IF
            SELECT COUNT(*) INTO l_cnt FROM wsf_file where wsf01=g_wsf.wsf01 AND wsf02 > g_wsf.wsf02
            IF l_cnt > 0 THEN
               SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-074' AND ze02 = g_lang
               LET l_message = l_ze03
               SELECT ze03 INTO l_ze03 from ze_file where ze01='aws-075' AND ze02 = g_lang
               LET l_message = l_message,g_wsf.wsf02 USING '<<<<'," ",l_ze03
               CALL cl_msgany(9,10,l_message)
               NEXT FIELD wsf03
            END IF
            IF cl_delete() THEN
               DELETE FROM wsf_file WHERE wsf01 = g_wsf.wsf01 AND wsf02 = g_wsf.wsf02
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('del wsf_file: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","wsf_file",g_wsf.wsf01,g_wsf.wsf02,SQLCA.sqlcode,"","del wsf_file", 0)   #No.FUN-660155)   #No.FUN-660155
               END IF
               DELETE FROM wsh_file WHERE wsh01 = g_wsf.wsf01 AND wsh02 = 'D' AND wsh03 = g_wsf.wsf02
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('del wsh_file: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","wsh_file",g_wsf.wsf01,g_wsf.wsf02,SQLCA.sqlcode,"","del wsh_file:", 0)   #No.FUN-660155)   #No.FUN-660155
               END IF
               LET g_wsf.wsf03 = NULL
               LET g_wsf.wsf04 = NULL
               LET g_wsf.wsf05 = NULL
               LET g_wsf.wsf06 = NULL
               LET g_wsf.wsf07 = NULL
               LET g_wsf.wsf08 = NULL
               LET g_wsf.wsf09 = NULL
               LET l_wsf03_t = NULL
               DISPLAY '' TO FORMONLY.detail01
            END IF
 
        ON ACTION controlp
           CASE
                WHEN INFIELD(wsf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsf.wsf03
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsf.wsf03,g_zz04
                  DISPLAY BY NAME g_wsf.wsf03
                  DISPLAY g_zz04 TO FORMONLY.detail01
           END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
    END INPUT
 
    IF INT_FLAG THEN
        LET g_wsf.* = g_wsf_o.*
        CLOSE WINDOW efcfg2_detail
        LET INT_FLAG = 0
        RETURN
    END IF
    IF l_cmd = 'a' THEN
        INSERT INTO wsf_file VALUES(g_wsf.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("ins","wsf_file",g_wsf.wsf01,g_wsf.wsf02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
            LET g_wsf.* = g_wsf_o.*
            CLOSE WINDOW efcfg2_detail
            RETURN
        END IF
    ELSE
        UPDATE wsf_file SET wsf_file.* = g_wsf.*    # 更新DB
            WHERE wsf01 = g_wsd.wsd01 AND wsf02 = g_wsf.wsf02
 
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsf_file",g_wsd.wsd01,g_wsf.wsf02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    END IF
    LET g_wsf.* = g_wsf_o.*
    CLOSE WINDOW efcfg2_detail
END FUNCTION
 
FUNCTION aws_efcfg_station()
DEFINE l_cnt  LIKE type_file.num10   #No.FUN-680130 INTEGER
 DEFINE l_wap02   LIKE wap_file.wap02    #FUN-C20087
 
    OPEN WINDOW efcfg2_station AT 4, 16
        WITH FORM "aws/42f/aws_efcfg_station" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("aws_efcfg_station")
 
    MESSAGE ''
 
    INITIALIZE g_wsj.* TO NULL
 
    SELECT COUNT(*) INTO l_cnt FROM wsj_file where wsj01='S'
    IF l_cnt > 0 THEN
       SELECT * INTO g_wsj.* FROM wsj_file where wsj01='S'
       DISPLAY BY NAME g_wsj.wsj02,g_wsj.wsj03,g_wsj.wsj04
       LET g_wsj_t.* = g_wsj.*
    END IF
 
    #FUN-C20087 add str---
    SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'
    IF l_wap02 = 'Y' THEN
       CALL aws_efcfg_station_menu()
    ELSE
    #FUN-C20087 add end---
    INPUT BY NAME g_wsj.wsj04,g_wsj.wsj02,g_wsj.wsj03
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
           IF l_cnt = 0 THEN
                 LET g_wsj.wsj01 = 'S'
                 LET g_wsj.wsj05 = '*'
                 LET g_wsj.wsj06 = '*'
                 LET g_wsj.wsj07 = '*'
           END IF
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION Exception
           IF l_cnt = 0 THEN
                 CALL cl_err(NULL,'aws-077',1)
                 NEXT FIELD wsj02
           ELSE
              LET g_wsj_o.* = g_wsj.*
              CALL aws_efcfg2_exception()
              LET g_wsj.* = g_wsj_o.*
           END IF
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
    END INPUT
    IF INT_FLAG THEN
        CLOSE WINDOW efcfg2_station
        LET INT_FLAG = 0
        RETURN
    END IF
    IF l_cnt = 0 THEN
        INSERT INTO wsj_file VALUES(g_wsj.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsj.wsj01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("ins","wsj_file",g_wsj.wsj01,g_wsj.wsj05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    ELSE
        UPDATE wsj_file SET wsj_file.* = g_wsj.*    # 更新DB
            WHERE wsj01 = g_wsj.wsj01 AND wsj05 = g_wsj.wsj05 AND
                  wsj06 = g_wsj.wsj06 AND wsj07 = g_wsj.wsj07
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsj_file",g_wsj.wsj01,g_wsj.wsj05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    END IF
    END IF  #FUN-C20087
    CLOSE WINDOW efcfg2_station
END FUNCTION
 
FUNCTION aws_efcfg2_exception()
 DEFINE l_wap02   LIKE wap_file.wap02  #FUN-C20087
 
    LET l_ac = 1
    CALL aws_exc_fill()
    OPEN WINDOW efcfg2_exc AT 4, 16
        WITH FORM "aws/42f/aws_efcfg_exc" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("aws_efcfg_exc")
    MESSAGE ''
    CALL cl_set_act_visible("accept,cancel", FALSE)

    #FUN-C20087 add str---
    SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'
    IF l_wap02 = 'Y' THEN
       CALL cl_set_act_visible("insert,modify,delete", FALSE)
    END IF
    #FUN-C20087 add end---

    DISPLAY ARRAY g_bwsj TO s_bwsj.* ATTRIBUTE(COUNT=g_exc_cnt,UNBUFFERED)
 
      #FUN-C20087 add str---
      BEFORE DISPLAY
         IF l_wap02 = 'Y' THEN
             CALL cl_set_act_visible("insert,modify,delete", FALSE) 
         END IF
      #FUN-C20087 add end---

      BEFORE ROW
          LET l_ac = ARR_CURR()
          IF l_ac != 0 THEN
             DISPLAY g_bwsj[l_ac].bwsj06 TO wsj06
             DISPLAY g_bwsj[l_ac].bwsj04 TO wsj04
             DISPLAY g_bwsj[l_ac].bwsj02 TO wsj02
             DISPLAY g_bwsj[l_ac].bwsj03 TO wsj03
          END IF
 
      AFTER DISPLAY
          CONTINUE DISPLAY
 
      ON ACTION insert
          CALL aws_exc_maintain("insert")
          ACCEPT DISPLAY
 
      ON ACTION modify
          IF l_ac != 0 THEN
             CALL aws_exc_maintain("modify")
          END IF
 
      ON ACTION delete
         IF l_ac != 0 THEN
             IF cl_delete() THEN
               DELETE FROM wsj_file WHERE wsj01 = 'E' AND wsj05 = '*'
                   AND wsj06 = g_bwsj[l_ac].bwsj06 AND wsj07='*'
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('del wsd: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","wsj_file",g_bwsj[l_ac].bwsj06,"",SQLCA.sqlcode,"","del wsd:", 0)   #No.FUN-660155)   #No.FUN-660155
               END IF
               CALL aws_exc_fill()
               IF g_bwsj.getLength() = 0 THEN
                  DISPLAY '' TO wsj06
                  DISPLAY '' TO wsj04
                  DISPLAY '' TO wsj02
                  DISPLAY '' TO wsj03
               END IF
               ACCEPT DISPLAY
             END IF
          END IF
 
      ON ACTION accept
          IF l_ac != 0 THEN
             CALL aws_exc_maintain("modify")
          END IF
 
      ON ACTION exit
           EXIT DISPLAY
 
      ON ACTION cancel
           EXIT DISPLAY
 
      ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
    IF INT_FLAG THEN                         # 若按了DEL鍵
        LET INT_FLAG = 0
    END IF
    CLOSE WINDOW efcfg2_exc
END FUNCTION
 
FUNCTION aws_exc_fill()
    LET g_sql = "SELECT wsj06,wsj04,wsj02,wsj03 FROM wsj_file where wsj01='E'"
 
    PREPARE efcfg2_pp FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90032
       EXIT PROGRAM
    END IF
    DECLARE efcfg2_cs2 CURSOR FOR efcfg2_pp
    CALL g_bwsj.clear()
    LET g_exc_cnt=1
    FOREACH efcfg2_cs2 INTO g_bwsj[g_exc_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_exc_cnt=g_exc_cnt+1
   END FOREACH
   CALL g_bwsj.deleteElement(g_exc_cnt)
END FUNCTION
 
FUNCTION aws_exc_maintain(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(10)
DEFINE l_cnt       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wsj06     LIKE wsj_file.wsj06
 
    INITIALIZE g_wsj.* TO NULL
 
    IF p_cmd = "modify" THEN
       LET g_wsj.wsj06 = g_bwsj[l_ac].bwsj06
       LET g_wsj.wsj04 = g_bwsj[l_ac].bwsj04
       LET g_wsj.wsj02 = g_bwsj[l_ac].bwsj02
       LET g_wsj.wsj03 = g_bwsj[l_ac].bwsj03
       LET l_wsj06 = g_bwsj[l_ac].bwsj06
       CALL cl_set_comp_entry("wsj06", FALSE)
    END IF
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    INPUT BY NAME g_wsj.wsj06,g_wsj.wsj04,g_wsj.wsj02,g_wsj.wsj03
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
           LET g_wsj.wsj01 = 'E'
           LET g_wsj.wsj05 = '*'
           LET g_wsj.wsj07 = '*'
 
        AFTER FIELD wsj06
           IF g_wsj.wsj06 IS NOT NULL THEN
                SELECT COUNT(*) INTO l_cnt FROM azp_file
                        where azp01 = g_wsj.wsj06
                IF l_cnt = 0 THEN
                   CALL cl_err(g_wsj.wsj06,"-827",0)
                   NEXT FIELD wsj06
                END IF
           END IF
 
        AFTER INPUT
           IF p_cmd = "insert" THEN
              SELECT COUNT(*) INTO l_cnt FROM wsj_file
                WHERE wsj01 = g_wsj.wsj01 AND wsj05 = g_wsj.wsj05 AND
                      wsj06 = g_wsj.wsj06 AND wsj07 = g_wsj.wsj07
              IF l_cnt > 0 THEN
                  CALL cl_err(g_wsj.wsj06,-239,0)
                  NEXT FIELD wsj06
              END IF
           END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(wsj06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_wsj.wsj06
              CALL cl_create_qry() RETURNING g_wsj.wsj06
              DISPLAY BY NAME g_wsj.wsj06
              NEXT FIELD wsj06
           END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL aws_exc_fill()
        IF p_cmd = "modify" THEN
           CALL cl_set_comp_entry("wsj06", TRUE)
        END IF
        CALL cl_set_act_visible("accept,cancel", FALSE)
        RETURN
    END IF
    IF p_cmd ="insert" THEN
        INSERT INTO wsj_file VALUES(g_wsj.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsj.wsj01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("ins","wsj_file",g_wsj.wsj01,g_wsj.wsj05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    ELSE
        UPDATE wsj_file SET wsj06 = g_wsj.wsj06,
                            wsj04 = g_wsj.wsj04,
                            wsj02 = g_wsj.wsj02,
                            wsj03 = g_wsj.wsj03
            WHERE wsj01 = g_wsj.wsj01 AND wsj05 = g_wsj.wsj05 AND
                  wsj06 = l_wsj06 AND wsj07 = g_wsj.wsj07
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsj_file",g_wsj.wsj01,g_wsj.wsj05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    END IF
    CALL aws_exc_fill()
 
    IF p_cmd = "modify" THEN
       CALL cl_set_comp_entry("wsj06", TRUE)
    END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION

#FUN-C20087 add str---
FUNCTION aws_efcfg_station_menu()
  DEFINE l_cnt    LIKE   type_file.num10


    SELECT COUNT(*) INTO l_cnt FROM wsj_file where wsj01='S'
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting(g_curs_index, g_row_count)

        LET g_action_choice = ""

        ON ACTION exception_menu
           IF l_cnt = 0 THEN
              CALL cl_err(NULL,'aws-077',1)
              CONTINUE MENU
           ELSE
              LET g_wsj_o.* = g_wsj.*
              CALL aws_efcfg2_exception()
              LET g_wsj.* = g_wsj_o.*
           END IF

        ON ACTION exit
           EXIT MENU

        ON ACTION controlg
           CALL cl_cmdask()

        ON ACTION close   #COMMAND KEY(INTERRUPT) 
           LET INT_FLAG=FALSE    
           EXIT MENU

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

        ON ACTION about     
           CALL cl_about()

    END MENU

END FUNCTION
#FUN-C20087 add end---
 
#Patch....NO.TQC-610037 <001,002> #
