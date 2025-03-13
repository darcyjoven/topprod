# Prog. Version..: '5.30.06-13.03.14(00009)'     #
#
# Pattern name...: axrt210.4gl
# Descriptions...: 銷售信用狀押匯作業
# Date & Author..: 96/01/20 By Danny
#                  96-09-23 By Charis 1.立即confirm 2.單別可按<^P>查詢
# Modify.........: No.8890 04/01/09 Kammy 輸入 Invoice後請帶出貨日期及出貨金額
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 修正欄位顯示名稱
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 修正欄位顯示名稱
# Modify.........: No.MOD-4B0048 04/11/08 By ching 取消確認,清空axmt500 LC No.
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-5B0007 05/11/08 By Smapmin 收狀單號不可更改.查詢後不應出現error message
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/26 By Smapmin 修改列印參數傳遞
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/07/20 By Carrier 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-670088 06/08/07 By Sarah 單頭增加部門、成本中心欄位
# Modify.........: No.FUN-670047 06/08/16 By Ray 多帳套修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.MOD-690148 06/10/17 By Smapmin 製表日期為空
# Modify.........: No.FUN-6A0095 06/11/06 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0042 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710050 07/01/29 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-720083 07/03/01 By Smapmin  1.請檢核 invoice 是否存在
#                                                     2.更新 olb09/olb10 予以取消
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-750133 07/05/29 By Smapmin 修改自動確認流程
# Modify.........: No.TQC-770025 07/07/04 By Rayven 錄入完出貨金額后直接點擊確定,則押匯金額不會隨之更改
# Modify.........: No.TQC-770046 07/07/06 By chenl  1.審核后不可刪除。
# Modify.........:                                  2.已有押匯入賬，不可取消審核。
# Modify.........:                                  3.押匯金額不可大于信用狀金額。
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/09 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-860075 08/06/10 By Carrier 直接拋轉總帳時，aba07(來源單號)沒有取得值
# Modify.........: no.MOD-880050 08/08/07 by Yiting olc29->olc01
# Modify.........: No.MOD-870016 08/07/03 By chenl  增加invoice#的判斷，invoice中的訂單必須全部存在于信用狀內的訂單.
# Modify.........: No.FUN-8A0086 08/10/21 By dongbg 修正FUN-710050錯誤
# Modify.........: No.CHI-920059 09/05/13 By jan 出貨金額以及其他金額不預設給押匯金額
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-810036 09/08/19 By xiaofeizhu 拋轉憑証時，傳入參數內的user應為資料所有者
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/07 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A40054 10/04/13 by xiaofeizhu ¼f®֪º®ɭԥ¼¦^¼g©ãª÷lc11
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.TQC-AB0366 11/01/13 By vealxu 單別維護作業（axri010）維護了總帳單別也可以拋轉總賬
# Modify.........: No:MOD-B20023 11/02/10 by 取消確認時應排除作廢的 nmg_file 資料
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-B50233 11/05/27 by Dido 錯誤訊息代號調整
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B70163 11/07/19 By Polly 進入 FUNCTION t210_m 時,先給予 LET g_olc_t.*=g_olc.*
# Modify.........: No.TQC-B80167 11/08/23 By guoch 修改成本中心栏位被清空的BUG，查询时资料建立部门和资料建立者无法下条件
# Modify.........: No.MOD-C20221 12/03/02 By Polly 調整出貨金額olc09為加總ofb14t含稅金額
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.MOD-CC0174 12/12/21 By Polly 確認段與取消確認段取消 olc11 = olc09 動作

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_olc               RECORD LIKE olc_file.*,
    g_ola               RECORD LIKE ola_file.*,
    g_olc_t             RECORD LIKE olc_file.*,
    g_olc01_t           LIKE olc_file.olc01,
     g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_argv1		LIKE olc_file.olc01,
    g_order             LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(01),
    g_amt               LIKE olc_file.olc09,
    g_t1                LIKE ooy_file.ooyslip,         #No.FUN-680123 VARCHAR(05),             #No.FUN-550071
    g_buf		LIKE gem_file.gem02          #No.FUN-680123 VARCHAR(40)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(72)
DEFINE g_str           STRING     #No.FUN-670060
DEFINE g_wc_gl         STRING     #No.FUN-670060
DEFINE g_dbs_gl        LIKE type_file.chr21         #No.FUN-680123 VARCHAR(21)   #No.FUN-670060
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680123 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680123 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1 = ARG_VAL(1)
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818    #No.FUN-6A0095
    INITIALIZE g_olc.* TO NULL
    INITIALIZE g_olc_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM olc_file WHERE olc01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t210_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t210_w AT p_row,p_col
         WITH FORM "axr/42f/axrt210"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL t210_q() END IF
 
    CALL cl_set_comp_visible("olc930,gem02b",g_aaz.aaz90='Y')   #FUN-670088 add
 
    LET g_action_choice=""
    CALL t210_menu()
 
    CLOSE WINDOW t210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818    #No.FUN-6A0095
END MAIN
 
FUNCTION t210_curs()
    CLEAR FORM
    IF cl_null(g_argv1) THEN
   INITIALIZE g_olc.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        olc29,olc28,olc23,olc24,olcconf,olc30,
        olc32,olc930,                           #FUN-670088 add
        olc01,olc02,olc09,olc10,
        olc12,olc11,olc13,olc141,
        olc19,olc20,
        olc04,olc03,olc06,olc05,
        olc07,olc08,
        olc15,olc16,olc17,olc18,
        olcuser,olcgrup,olcmodu,olcdate,olcoriu,olcorig,   #TQC-B80167 add olcriu,olcorig
        olcud01,olcud02,olcud03,olcud04,olcud05,
        olcud06,olcud07,olcud08,olcud09,olcud10,
        olcud11,olcud12,olcud13,olcud14,olcud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
     	   CASE
 	      WHEN INFIELD(olc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ofa"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_olc.olc01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO olc01
 	         NEXT FIELD olc01
              WHEN INFIELD(olc29)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ola"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_olc.olc29
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO olc29
                 NEXT FIELD olc29
       	      WHEN INFIELD(olc05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_olc.olc05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO olc05   #MOD-4A0252修正顯示欄位名稱
	         NEXT FIELD olc05
              WHEN INFIELD(olc06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_olc.olc06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO olc06
	         NEXT FIELD olc06
              WHEN INFIELD(olc32)   #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem"
                 LET g_qryparam.state = "c"   #多選
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO olc42
                 NEXT FIELD olc32
              WHEN INFIELD(olc930)   #成本中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem4"
                 LET g_qryparam.state = "c"   #多選
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO olc930
                 NEXT FIELD olc930
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
       END CONSTRUCT
    ELSE
       LET g_wc = "olc01 ='",g_argv1,"'"
    END IF
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('olcuser', 'olcgrup')
 
    LET g_sql="SELECT olc01 FROM olc_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY olc01"
    DISPLAY g_sql
    PREPARE t210_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t210_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t210_prepare
    LET g_sql= "SELECT COUNT(*) FROM olc_file WHERE ",g_wc CLIPPED
    DISPLAY g_sql
    PREPARE t210_precount FROM g_sql
    DECLARE t210_count CURSOR FOR t210_precount
END FUNCTION
 
FUNCTION t210_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 = 'Y' THEN
               CALL cl_set_act_visible("entry_sheet2",TRUE)
            ELSE
               CALL cl_set_act_visible("entry_sheet2",FALSE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t210_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t210_q()
            END IF
 
        ON ACTION next
           CALL t210_fetch('N')
 
        ON ACTION previous
           CALL t210_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t210_u()
            END IF
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL t210_out('a')
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL t210_r()
            END IF
 
        ON ACTION gen_entry
           LET g_action_choice="gen_entry"
           IF cl_chk_act_auth() THEN
              CALL t210_v()
           END IF
 
        ON ACTION entry_sheet
           LET g_action_choice="entry_sheet"
           IF cl_chk_act_auth() THEN
              CALL t210_vc()
           END IF
 
        ON ACTION entry_sheet2
           LET g_action_choice="entry_sheet2"
           IF cl_chk_act_auth() THEN
              CALL t210_vc_1()
           END IF
 
        ON ACTION carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_olc.olcconf = 'Y' THEN
                 CALL t210_carry_voucher()       #No.FUN-670060
               ELSE 
                  CALL cl_err('','atm-402',1)
              END IF
           END IF
 
        ON ACTION undo_carry
           IF cl_chk_act_auth() THEN
              IF g_olc.olcconf = 'Y' THEN
                 CALL t210_undo_carry_voucher()  #No.FUN-670060
               ELSE 
                  CALL cl_err('','atm-403',1)
              END IF
           END IF
 
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL t210_y()
           END IF
 
        ON ACTION undo_confirm
           LET g_action_choice="undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL t210_z()
           END IF
 
        ON ACTION no_negotiation_reason
           LET g_action_choice="no_negotiation_reason"
           IF cl_chk_act_auth() THEN
              CALL t210_m()
           END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic(g_olc.olcconf,"","","","","")
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION first
           CALL t210_fetch('F')
 
        ON ACTION last
           CALL t210_fetch('L')
 
        ON ACTION jump
           CALL t210_fetch('/')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_olc.olc01 IS NOT NULL THEN
                  LET g_doc.column1 = "olc01"
                  LET g_doc.value1 = g_olc.olc01
                  CALL cl_doc()
               END IF
           END IF
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t210_cs
END FUNCTION
 
 
FUNCTION t210_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    INITIALIZE g_olc.* TO NULL
    LET g_olc.olc10 = 0
    LET g_olc.olc30 = ''
    LET g_olc.olc32 = g_grup   #FUN-670088 add
    LET g_olc.olc930= s_costcenter(g_olc.olc32)  #FUN-670088 add
    LET g_olc.olcconf = 'N'
    LET g_olc.olcuser = g_user
    LET g_olc.olcoriu = g_user #FUN-980030
    LET g_olc.olcorig = g_grup #FUN-980030
    LET g_olc.olcgrup = g_grup
    LET g_olc.olcdate = g_today
    LET g_olc.olclegal = g_legal #FUN-980011 add
    LET g_olc_t.*=g_olc.*
    LET g_olc01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t210_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0 CALL cl_err('',9001,0)
            INITIALIZE g_olc.* TO NULL
            CLEAR FORM EXIT WHILE
        END IF
        IF g_olc.olc01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO olc_file VALUES(g_olc.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","olc_file",g_olc.olc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        ELSE
            LET g_olc_t.* = g_olc.*                # 保存上筆資料
            SELECT olc01 INTO g_olc.olc01 FROM olc_file
                WHERE olc01 = g_olc.olc01
            # 新增自動confirm功能 Modify by Charis 96-09-23
            CALL s_get_doc_no(g_olc.olc01) RETURNING g_t1    
            SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
            IF STATUS THEN 
               CALL cl_err3("sel","oay_file",g_t1,"",STATUS,"","sel oay_file",1)  
               EXIT WHILE
            END IF
            IF g_oay.oayconf='N' #單據不需自動confirm
               THEN EXIT WHILE
            ELSE CALL t210_y()
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t210_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1),
        l_no            LIKE ola_file.ola011,
        l_msg           STRING,                      #MOD-870016
        l_n             LIKE type_file.num5,         #No.FUN-680123 SMALLINT,
        l_olc28         LIKE type_file.num5,         #No.FUN-680123 SMALLINT,
        l_conf          LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(01),
        l_amt           LIKE ola_file.ola09,
        l_ofa211        LIKE ofa_file.ofa211,
        l_ofa02         LIKE ofa_file.ofa02,
        l_ofa50         LIKE ofa_file.ofa50,
        l_ofa61         LIKE ofa_file.ofa61
    DEFINE l_success    LIKE type_file.num5           #No.TQC-770046
    DEFINE l_chk        LIKE type_file.chr1           #No.MOD-870016
    DEFINE l_olc32_o    LIKE olc_file.olc32          #TQC-B80167
 
    INPUT BY NAME g_olc.olcoriu,g_olc.olcorig,
        g_olc.olc29,g_olc.olc28,g_olc.olcconf,g_olc.olc30,
        g_olc.olc32,g_olc.olc930,   #FUN-670088 add
        g_olc.olc23,g_olc.olc24,
        g_olc.olc01,g_olc.olc02,g_olc.olc09,g_olc.olc10,
        g_olc.olc12,g_olc.olc11,g_olc.olc13,g_olc.olc141,
        g_olc.olc04,g_olc.olc03,g_olc.olc06,g_olc.olc05,
        g_olc.olc07,g_olc.olc08,g_olc.olc19,g_olc.olc20,
        g_olc.olc15,g_olc.olc16,g_olc.olc17,g_olc.olc18,
        g_olc.olcuser,g_olc.olcgrup,g_olc.olcmodu,g_olc.olcdate,
        g_olc.olcud01,g_olc.olcud02,g_olc.olcud03,g_olc.olcud04,
        g_olc.olcud05,g_olc.olcud06,g_olc.olcud07,g_olc.olcud08,
        g_olc.olcud09,g_olc.olcud10,g_olc.olcud11,g_olc.olcud12,
        g_olc.olcud13,g_olc.olcud14,g_olc.olcud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t210_set_entry(p_cmd)
           CALL t210_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
            CALL cl_set_docno_format("olc29")
           LET l_olc32_o = g_olc_t.olc32  #TQC-B80167  add
 
        AFTER FIELD olc29
            IF NOT cl_null(g_olc.olc29) THEN
               IF g_olc_t.olc29 IS NULL OR  g_olc_t.olc29 != g_olc.olc29 THEN
                  SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_olc.olc29
                                                      AND olaconf !='X' #010806增
                  IF STATUS THEN
                     CALL cl_err3("sel","ola_file",g_olc.olc29,"",STATUS,"","sel ola",1)  #No.FUN-660116
                     NEXT FIELD olc29
                  END IF
                  IF g_ola.ola40 = 'Y' THEN    #收狀單已結案
                     CALL cl_err(g_olc.olc29,'axr-369',1) NEXT FIELD olc29
                  END IF
                  IF g_ola.olaconf != 'Y' THEN    #收狀單尚未confirm
                     CALL cl_err(g_olc.olc29,'9029',1) NEXT FIELD olc29   #No:8887
                  END IF
                  LET g_olc.olc09 = 0                      #出貨金額
                  LET g_olc.olc03 = g_ola.ola11            #內/外銷
                  LET g_olc.olc04 = g_ola.ola04            #L/C NO
                  LET g_olc.olc05 = g_ola.ola05            #客戶編號
                  LET g_olc.olc06 = g_ola.ola15            #收款條件
                  LET g_olc.olc07 = g_ola.ola25            #最後裝船日
                  LET g_olc.olc08 = g_ola.ola14            #有效日期
                  IF cl_null(g_olc.olc04) OR g_ola.ola04 != g_olc.olc04 THEN
                     CALL cl_err(g_olc.olc29,'axr-059',0)
                     NEXT FIELD olc29
                 END IF
                 IF cl_null(g_olc.olc11) THEN
                    LET g_olc.olc11=0
                 END IF
                 DISPLAY BY NAME g_olc.olc02,g_olc.olc03,g_olc.olc04,
                                 g_olc.olc05,g_olc.olc06,g_olc.olc07,
                                 g_olc.olc08,g_olc.olc09,g_olc.olc11
                 SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_olc.olc06
                 IF STATUS THEN LET g_buf = '' END IF
                 DISPLAY g_buf TO FORMONLY.oag02
                 SELECT occ02 INTO g_buf FROM occ_file
                  WHERE occ01= g_olc.olc05 AND occacti='Y'
                 IF STATUS THEN LET g_buf ='' END IF
                 DISPLAY g_buf TO FORMONLY.occ02
                 CALL s_t200_amt(g_olc.olc04,'n') RETURNING g_order,g_amt
                #---------------MOD-CC0174--------------------mark
                ##若可用餘額已扣除出貨金額,且押匯未confirm
                #IF g_order = 'Y' AND g_olc.olcconf = 'N' THEN
                #   LET g_amt = g_amt -g_olc_t.olc09 + g_olc.olc09
                #END IF
                #---------------MOD-CC0174--------------------mark
                 DISPLAY g_amt TO FORMONLY.net_amt
              END IF
              LET g_olc_t.olc04=g_olc.olc04
              IF cl_null(g_olc.olc28) THEN
                 SELECT max(olc28) INTO l_olc28 FROM olc_file
                                  WHERE olc29 = g_olc.olc29
                 IF cl_null(l_olc28) THEN LET l_olc28 = 0 END IF
                 LET g_olc.olc28 = l_olc28 + 1
                 SELECT MAX(ola011) +1 INTO l_no FROM ola_file
                  WHERE ola01 = g_olc.olc29
                 IF cl_null(l_no) THEN LET l_no = 1 END IF
                 IF g_olc.olc28 < l_no THEN LET g_olc.olc28 = l_no END IF
                 SELECT MAX(ole02) +1 INTO l_no FROM ole_file
                  WHERE ole01 = g_olc.olc29
                 IF cl_null(l_no) THEN LET l_no = 1 END IF
                 IF g_olc.olc28 < l_no THEN LET g_olc.olc28 = l_no END IF
                 DISPLAY BY NAME g_olc.olc28
              END IF
           END IF
 
        AFTER FIELD olc32   #部門
           IF NOT cl_null(g_olc.olc32) THEN
              SELECT gem02 INTO g_buf FROM gem_file
               WHERE gem01=g_olc.olc32
                 AND gemacti='Y'   #NO:6950
                 AND gem05 = 'Y'   #No.MOD-530272
              IF STATUS THEN
                 CALL cl_err3("sel","gem_file",g_olc.olc32,"","agl-202","","sel gem",1)
                 NEXT FIELD olc32
              END IF
              CALL t210_olc32(p_cmd)       #No.MOD-490461
              IF STATUS THEN
                 CALL cl_err('select gem',STATUS,0)
                 NEXT FIELD olc32
              END IF
              IF p_cmd = "a" OR (p_cmd = "u" AND g_olc.olc32 != l_olc32_o) THEN  #TQC-B80167 add
                 LET l_olc32_o = g_olc.olc32   #TQC-B80167 add
                 LET g_olc.olc930=s_costcenter(g_olc.olc32)
                 DISPLAY BY NAME g_olc.olc930
                 DISPLAY s_costcenter_desc(g_olc.olc930) TO FORMONLY.gem02b
              END IF  #TQC-B80167 add
           END IF
 
        AFTER FIELD olc930   #成本中心
           IF NOT s_costcenter_chk(g_olc.olc930) THEN
              LET g_olc.olc930=NULL
              DISPLAY BY NAME g_olc.olc930
              DISPLAY NULL TO FORMONLY.gem02b
              NEXT FIELD olc930
           ELSE
              DISPLAY s_costcenter_desc(g_olc.olc930) TO FORMONLY.gem02b
           END IF
 
        AFTER FIELD olc01
            IF NOT cl_null(g_olc.olc01) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_olc.olc01 != g_olc_t.olc01) THEN
                  SELECT count(*) INTO l_n FROM olc_file
                   WHERE olc01 = g_olc.olc01
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_olc.olc01,-239,0)
                     LET g_olc.olc01 = g_olc_t.olc01
                     DISPLAY BY NAME g_olc.olc01
                     NEXT FIELD olc01
                  END IF
                  LET l_n = 0
                 #FUN-A60056--mod-str--
                 #SELECT COUNT(*) INTO l_n FROM ofa_file
                 # WHERE ofa01 = g_olc.olc01 AND ofaconf='Y'
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant,'ofa_file'),
                              " WHERE ofa01 = '",g_olc.olc01,"'",
                              "   AND ofaconf='Y'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                  PREPARE sel_ofa FROM g_sql
                  EXECUTE sel_ofa INTO l_n
                 #FUN-A60056--mod--end
                  IF l_n = 0 THEN 
                     CALL cl_err(g_olc.olc01,'axm-013',0)
                     LET g_olc.olc01 = g_olc_t.olc01
                     DISPLAY BY NAME g_olc.olc01
                     NEXT FIELD olc01
                  END IF
                  CALL t210_chk_olc01(g_olc.olc01,g_olc.olc29)
                       RETURNING l_chk,l_msg
                  IF l_chk = 'N' THEN 
                     CALL cl_msgany(0,0,l_msg)
                     NEXT FIELD olc01
                  END IF
                  #FUN-A60056--mod--str--
                  #SELECT ofa02 INTO g_olc.olc02 FROM ofa_file
                  # WHERE ofa01 = g_olc.olc01
                   LET g_sql = "SELECT ofa02 FROM ",cl_get_target_table(g_plant,'ofa_file'),
                               " WHERE ofa01 = '",g_olc.olc01,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                   PREPARE sel_ofa02 FROM g_sql
                   EXECUTE sel_ofa02 INTO g_olc.olc02
                  #FUN-A60056--mod--end
                   DISPLAY BY NAME g_olc.olc02
                  SELECT SUM(oma54t) INTO g_olc.olc09 FROM oma_file
                   WHERE oma39=g_olc.olc01
                  IF cl_null(g_olc.olc09) THEN LET g_olc.olc09=0 END IF
                  CALL s_t200_amt(g_olc.olc04,'n') RETURNING g_order,g_amt
                 #---------------MOD-CC0174--------------------mark
                 ##若可用餘額已扣除出貨金額,且押匯未confirm
                 #IF g_order = 'Y' AND g_olc.olcconf = 'N' THEN
                 #   LET g_amt = g_amt -g_olc_t.olc09 + g_olc.olc09
                 #END IF
                 #---------------MOD-CC0174--------------------mark
                  DISPLAY g_amt TO FORMONLY.net_amt
                  #No.8890 出貨金額直接帶 Invoice 單身金額
                 #FUN-A60056--mod--str--
                 #SELECT SUM(ofb14) INTO g_olc.olc09 FROM ofb_file
                 # WHERE ofb01 = g_olc.olc01
                 #LET g_sql = "SELECT SUM(ofb14) FROM ",cl_get_target_table(g_plant,'ofb_file'),  #MOD-C20221 mark
                  LET g_sql = "SELECT SUM(ofb14t) FROM ",cl_get_target_table(g_plant,'ofb_file'), #MOD-C20221 add 
                              " WHERE ofb01 = '",g_olc.olc01,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                 #PREPARE sel_ofb14 FROM g_sql                               #MOD-C20221 mark
                  PREPARE sel_ofb14t FROM g_sql                              #MOD-C20221 add
                 #EXECUTE sel_ofb14 INTO g_olc.olc09                         #MOD-C20221 mark
                  EXECUTE sel_ofb14t INTO g_olc.olc09                        #MOD-C20221 add
                 #FUN-A60056--mod--end
                  IF cl_null(g_olc.olc09) THEN LET g_olc.olc09 = 0 END IF
                  DISPLAY BY NAME g_olc.olc09
               END IF
            END IF
 
   	AFTER FIELD olc03
           IF g_olc.olc03 NOT MATCHES '[12]' THEN
              NEXT FIELD olc03
           END IF
 
	AFTER FIELD olc05
            IF NOT cl_null(g_olc.olc05) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_olc.olc06 != g_olc_t.olc06) THEN
                  SELECT occ02 INTO g_buf FROM occ_file
                   WHERE occ01= g_olc.olc05 AND occacti='Y'
                  IF STATUS THEN LET g_buf = '' END IF
                  DISPLAY g_buf TO FORMONLY.occ02
               END IF
            END IF
 
	AFTER FIELD olc06
            IF NOT cl_null(g_olc.olc06) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_olc.olc06 != g_olc_t.olc06) THEN
                  SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_olc.olc06
                  IF STATUS THEN LET g_buf = '' END IF
                  DISPLAY g_buf TO FORMONLY.oag02
               END IF
            END IF
 
        AFTER FIELD olc09
           IF cl_null(g_olc.olc09) THEN LET g_olc.olc09 = 0 END IF
           CALL t210_olc11(g_olc.olc11) RETURNING l_success
           IF l_success = 0 THEN
              NEXT FIELD olc09
           END IF 
           DISPLAY BY NAME g_olc.olc11
 
	AFTER FIELD olc10
           IF cl_null(g_olc.olc10) THEN LET g_olc.olc10 = 0 END IF
           CALL t210_olc11(g_olc.olc11) RETURNING l_success
           IF l_success = 0 THEN
              NEXT FIELD olc10
           END IF 
           DISPLAY BY NAME g_olc.olc11
 
        BEFORE FIELD olc12
           CALL t210_set_entry(p_cmd)
 
	AFTER FIELD olc12
           IF NOT cl_null(g_olc.olc12) THEN
              LET g_olc.olc141= ''
              DISPLAY BY NAME g_olc.olc141
           END IF
           CALL t210_set_no_entry(p_cmd)
 
        AFTER FIELD olcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT    #97/05/22 modify
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
     	   CASE
 	      WHEN INFIELD(olc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ofa"
                 LET g_qryparam.default1 = g_olc.olc01
                 CALL cl_create_qry() RETURNING g_olc.olc01
 	         DISPLAY BY NAME g_olc.olc01
 	         NEXT FIELD olc01
              WHEN INFIELD(olc29)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ola"
                 LET g_qryparam.default1 = g_olc.olc29
                 CALL cl_create_qry() RETURNING g_olc.olc29
                 DISPLAY BY NAME g_olc.olc29
                 NEXT FIELD olc29
       	      WHEN INFIELD(olc05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_olc.olc05
                 CALL cl_create_qry() RETURNING g_olc.olc05
	         DISPLAY BY NAME g_olc.olc05
	         NEXT FIELD olc05
	      WHEN INFIELD(olc06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oag"
                 LET g_qryparam.default1 = g_olc.olc06
                 CALL cl_create_qry() RETURNING g_olc.olc06
                 DISPLAY BY NAME g_olc.olc06
	         NEXT FIELD olc06
              WHEN INFIELD(olc32)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem1"
                 LET g_qryparam.default1 = g_olc.olc32
                 CALL cl_create_qry() RETURNING g_olc.olc32
                 DISPLAY BY NAME g_olc.olc32
                 NEXT FIELD olc32
              WHEN INFIELD(olc930)   #成本中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_olc.olc930
                 DISPLAY BY NAME g_olc.olc930
                 NEXT FIELD olc930
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON KEY(F1)
           NEXT FIELD olc01
 
        ON KEY(F2)
           NEXT FIELD olc12
           NEXT FIELD olc15
           NEXT FIELD olc19
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t210_olc32(p_cmd)  #部門名稱
   DEFINE p_cmd     LIKE type_file.chr1         #No.FUN-680123 VARCHAR(01)
   DEFINE l_gem02   LIKE gem_file.gem02
 
   LET g_errno = ' '
   LET l_gem02 = ' '
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_olc.olc32
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg-3097'
                                  LET l_gem02 = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02a
   END IF
 
END FUNCTION
 
FUNCTION t210_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_olc.* TO NULL              #No.FUN-6B0042
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t210_curs()                        # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t210_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_olc.olc01,SQLCA.sqlcode,0)
       INITIALIZE g_olc.* TO NULL
    ELSE
       OPEN t210_count
       FETCH t210_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t210_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t210_fetch(p_flolc)
    DEFINE
        p_flolc         LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1),
        l_abso          LIKE type_file.num10         #No.FUN-680123  INTEGER
 
    CASE p_flolc
        WHEN 'N' FETCH NEXT     t210_cs INTO g_olc.olc01
        WHEN 'P' FETCH PREVIOUS t210_cs INTO g_olc.olc01
        WHEN 'F' FETCH FIRST    t210_cs INTO g_olc.olc01
        WHEN 'L' FETCH LAST     t210_cs INTO g_olc.olc01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump t210_cs INTO g_olc.olc01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_olc.olc01,SQLCA.sqlcode,0)
        INITIALIZE g_olc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flolc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_olc.* FROM olc_file
       WHERE olc01 = g_olc.olc01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","olc_file",g_olc.olc01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660116
    ELSE
        CALL t210_show()                      # 重新顯示
        ERROR ""      #MOD-5B0007
    END IF
END FUNCTION
 
FUNCTION t210_show()
  DEFINE l_msg   LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(40)
    DISPLAY BY NAME g_olc.olcoriu,g_olc.olcorig,
 
 
        g_olc.olc29,g_olc.olc28,g_olc.olcconf,g_olc.olc30,
        g_olc.olc32,g_olc.olc930,   #FUN-670088 add
        g_olc.olc23,g_olc.olc24,
        g_olc.olc01,g_olc.olc02,g_olc.olc09,g_olc.olc10,
        g_olc.olc12,g_olc.olc11,g_olc.olc13,g_olc.olc141,
        g_olc.olc04,g_olc.olc03,g_olc.olc06,g_olc.olc05,
        g_olc.olc07,g_olc.olc08,g_olc.olc19,g_olc.olc20,
        g_olc.olc15,g_olc.olc16,g_olc.olc17,g_olc.olc18,
        g_olc.olcuser,g_olc.olcgrup,g_olc.olcmodu,g_olc.olcdate,
        g_olc.olcud01,g_olc.olcud02,g_olc.olcud03,g_olc.olcud04,
        g_olc.olcud05,g_olc.olcud06,g_olc.olcud07,g_olc.olcud08,
        g_olc.olcud09,g_olc.olcud10,g_olc.olcud11,g_olc.olcud12,
        g_olc.olcud13,g_olc.olcud14,g_olc.olcud15 
 
        CALL cl_set_field_pic(g_olc.olcconf,"","","","","")
 
        SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_olc.olc06
        IF STATUS THEN LET g_buf = '' END IF
        DISPLAY g_buf TO FORMONLY.oag02
        SELECT occ02 INTO g_buf FROM occ_file WHERE occ01= g_olc.olc05
        IF STATUS THEN LET g_buf = '' END IF
        DISPLAY g_buf TO FORMONLY.occ02
        CALL t210_olc32('d')
        DISPLAY s_costcenter_desc(g_olc.olc930) TO FORMONLY.gem02b
        CALL s_t200_amt(g_olc.olc04,'n') RETURNING g_order,g_amt
       #---------------MOD-CC0174--------------------mark
       ##若可用餘額已扣除出貨金額,且押匯未confirm
       #IF g_order = 'Y' AND g_olc.olcconf = 'N' THEN
       #   LET g_amt = g_amt + g_olc.olc09
       #END IF
       #---------------MOD-CC0174--------------------mark
        DISPLAY g_amt TO FORMONLY.net_amt
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t210_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_olc.olc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_olc.* FROM olc_file WHERE olc01 = g_olc.olc01
    IF g_olc.olcconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_olc01_t = g_olc.olc01
    BEGIN WORK
 
    OPEN t210_cl USING g_olc.olc01
 
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 1)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_olc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_olc.olc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_olc_t.*=g_olc.*
    CALL t210_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_olc.olcmodu = g_user
        LET g_olc.olcdate = g_today
        CALL t210_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_olc.*=g_olc_t.*
            CALL t210_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE olc_file SET olc_file.* = g_olc.*  # 更新DB
            WHERE olc01 = g_olc_t.olc01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","olc_file",g_olc01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        ELSE
            #新增自動confirm功能 Modify by Charis 96-09-23
            CALL s_get_doc_no(g_olc.olc01) RETURNING g_t1    
            SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
            IF STATUS THEN 
               CALL cl_err3("sel","oay_file",g_t1,"",STATUS,"","sel oay_file",1) 
               EXIT WHILE
            END IF
            IF g_oay.oayconf='N' #單據不需自動confirm
               THEN EXIT WHILE
            ELSE CALL t210_y()
            END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t210_cl
    COMMIT WORK
 
    CALL cl_set_field_pic("","","","","","")
END FUNCTION
 
FUNCTION t210_out(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1),
          l_cmd    LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(400),
          l_wc     LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a' THEN
      LET l_wc = "olc01='",g_olc.olc01,"'"  # "新增"則印單張
   ELSE
      LET l_wc = g_wc                       # 其他則印多張
   END IF
   IF l_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
   LET l_cmd = "axrr212 '",g_today,"' '' '",g_lang,"' 'Y' '' '' ",   #MOD-690148
               "'olc01 =\"",g_olc.olc01,"\"'"
   CALL cl_cmdrun(l_cmd CLIPPED)
   ERROR ' '
END FUNCTION
 
FUNCTION t210_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_olc.olc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF  g_olc.olcconf = 'Y' THEN
        CALL cl_err(g_olc.olc29,"axr-368",0)
        RETURN
    END IF 
 
    BEGIN WORK
 
    OPEN t210_cl USING g_olc.olc01
 
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 1)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_olc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_olc.olc01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t210_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "olc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_olc.olc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM olc_file WHERE olc01 = g_olc.olc01
       #----modify by kammy (必須依序號刪除，否則會刪到別的)----#
       DELETE FROM npp_file WHERE npp01 = g_olc.olc01
                              AND nppsys= 'AR'
                              AND npp00 = 43
                              AND npp011= g_olc.olc28
       DELETE FROM npq_file WHERE npq01 = g_olc.olc01
                              AND npqsys= 'AR'
                              AND npq00 = 43
                              AND npq011= g_olc.olc28
     #FUN-B40056--add--str--
       DELETE FROM tic_file WHERE tic04 = g_olc.olc01
     #FUN-B40056--add--end--
       CLEAR FORM
       OPEN t210_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t210_cs
          CLOSE t210_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t210_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t210_cs
          CLOSE t210_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t210_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t210_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t210_fetch('/')
       END IF
 
    END IF
    CLOSE t210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t210_y() 		
   DEFINE  l_ofb    RECORD LIKE ofb_file.*,
           l_olb    RECORD LIKE olb_file.*,
           l_ofa50  LIKE ofa_file.ofa50,
           l_ofa61  LIKE ofa_file.ofa61,
           l_ofa23  LIKE ofa_file.ofa23,
           l_sql    LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(300),
           l_n      LIKE type_file.num5,         #No.FUN-680123 SMALLINT,    #No.FUN-670060
           l_net    LIKE ofa_file.ofa50,
           l_tot    LIKE ofa_file.ofa50,
           l_rate   LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,10),  #FUN-4C0013
           m_rate   LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,10),  #FUN-4C0013
           l_ofb12  LIKE ofb_file.ofb12,
           l_ofb14  LIKE ofb_file.ofb14
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
 
    SELECT * INTO g_olc.* FROM olc_file WHERE olc01 = g_olc.olc01
   IF g_olc.olcconf='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   IF STATUS THEN CALL cl_err('ofb_curs',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
 
   SELECT * INTO g_ola.* FROM ola_file WHERE ola04 = g_olc.olc04
                                         AND olaconf !='X' #010806增
   IF STATUS THEN
      CALL cl_err3("sel","ola_file",g_olc.olc04,"",STATUS,"","sel ola",1)  #No.FUN-660116
   END IF
   IF g_ola.ola40 = 'Y' THEN    #收狀單已結案
      CALL cl_err('','axr-312',1)
   END IF
   CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1    #No.FUN-550071
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   LET g_success = 'Y'
   CALL s_get_bookno(YEAR(g_olc.olc12)) RETURNING l_flag,l_bookno1,l_bookno2       #No.FUN-740009
   IF l_flag = '1' THEN
      CALL cl_err(YEAR(g_olc.olc12),'aoo-081',1)
      LET g_success = 'N'
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'N' THEN  #No.FUN-670060
      CALL s_chknpq(g_olc.olc29,'AR',g_olc.olc28,'0',l_bookno1) #  (NO:0151)       #No.FUN-740009
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_olc.olc29,'AR',g_olc.olc28,'1',l_bookno2)       #No.FUN-740009
      END IF
   END IF
   IF g_success='N' THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t210_cl USING g_olc.olc01
 
   IF STATUS THEN
      CALL cl_err("OPEN t210_cl:", STATUS, 1)
      CLOSE t210_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t210_cl INTO g_olc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_olc.olc01,SQLCA.sqlcode,0)
       RETURN
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npq01 = g_olc.olc01
         AND npq011 = g_olc.olc28
         AND npq00 = 43
         AND npqsys = 'AR'
      IF l_n = 0 THEN
         CALL t210_gen_glcr(g_olc.*,g_ooy.*,l_bookno1,l_bookno2)       #No.FUN-740009
      END IF
      IF g_success = 'Y' THEN
         CALL s_chknpq(g_olc.olc29,'AR',g_olc.olc28,'0',l_bookno1) #  (NO:0151)       #No.FUN-740009
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_olc.olc29,'AR',g_olc.olc28,'1',l_bookno2)       #No.FUN-740009
         END IF
      END IF
      IF g_success = 'N' THEN RETURN END IF  #No.FUN-670047
   END IF
  #FUN-A60056--mod--str- 
  #SELECT ofa61 INTO l_ofa61
  #  FROM ofa_file
  # WHERE ofa01 = g_olc.olc01
  #   AND ofaconf = 'Y' #取已confirm的資料01/08/07 mandy
   LET g_sql = "SELECT ofa61 FROM ",cl_get_target_table(g_plant,'ofa_file'),
               " WHERE ofa01 = '",g_olc.olc01,"'",
               "   AND ofaconf = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
   PREPARE sel_ofa61 FROM g_sql
   EXECUTE sel_ofa61 INTO l_ofa61
  #FUN-A60056--mod--end
   IF cl_null(l_ofa61) THEN
     #FUN-A60056--mod--str--
     #UPDATE ofa_file SET ofa61 = g_olc.olc04
     # WHERE ofa01 = g_olc.olc01
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant,'ofa_file'),
                  "   SET ofa61 = '",g_olc.olc04,"'",
                  " WHERE ofa01 = '",g_olc.olc01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
      PREPARE upd_ofa_pre1 FROM g_sql
      EXECUTE upd_ofa_pre1
     #FUN-A60056--mod--end
       IF STATUS THEN                #No.MOD-4B0048
         CALL cl_err3("upd","ofa_file",g_olc.olc01,"",SQLCA.sqlcode,"","upd ofa61",1)  #No.FUN-660116
         RETURN
      END IF
   END IF
  #FUN-A60056--mod--str--
  #DECLARE ofb_curs CURSOR FOR
  #   SELECT ofb_file.*
  #     FROM ofa_file,ofb_file
  #    WHERE ofa01 = ofb01
  #      AND ofa61 = g_olc.olc04
  #      AND ofa01 = g_olc.olc01
  #      AND ofaconf = 'Y' #取已confirm的資料01/08/07 mandy
  #    ORDER BY ofb01,ofb03
   LET g_sql = "SELECT ofb_file.* ",
               "  FROM ",cl_get_target_table(g_plant,'ofa_file'),",",
               "       ",cl_get_target_table(g_plant,'ofb_file'),
               " WHERE ofa01 = ofb01 ",
               "   AND ofa61 = '",g_olc.olc04,"'",
               "   AND ofa01 = '",g_olc.olc01,"'",
               "   AND ofaconf = 'Y'",
               "  ORDER BY ofb01,ofb03"
   PREPARE sel_ofb FROM g_sql
   DECLARE ofb_curs CURSOR FOR sel_ofb
  #FUN-A60056--mod--end
   IF STATUS THEN CALL cl_err('ofb_curs',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   #檢查出貨金額是否超出L/C未使用金額
   LET l_net = g_amt
   IF g_olc.olc09 > l_net THEN
      CALL cl_err(g_olc.olc01,'axr-311',1) LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      CALL s_showmsg_init()                   #NO.FUN-710050   
      FOREACH ofb_curs INTO l_ofb.*
     IF STATUS THEN 
         LET  g_showmsg=g_olc.olc04,"/",g_olc.olc01
         LET g_success = 'N'   #No.FUN-8A0086
         CALL s_errmsg('ofa61,ofa01',g_showmsg,'foreach ofb',STATUS,1) EXIT FOREACH  
     END IF    #No.FUN-8A0086 
     IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y' 
     END IF    
         SELECT olb_file.* INTO l_olb.*
           FROM olb_file,ola_file
          WHERE ola01=olb01 AND ola04=g_olc.olc04
            AND olb04 = l_ofb.ofb31 AND olb05 = l_ofb.ofb32
            AND  olaconf !='X' #010806增
         IF STATUS THEN 
         LET  g_showmsg=g_olc.olc04,"/",l_ofb.ofb31,"/",l_ofb.ofb32
         CALL s_errmsg('ola04,olb04,olb05',g_showmsg,'fetch olb',STATUS,1)
         CONTINUE FOREACH
         END IF
         #檢查出貨數量是否超出L/C未押匯數量
        #FUN-A60056--mod--str--
        #SELECT SUM(ofb12),SUM(ofb14) INTO l_ofb12,l_ofb14
        #  FROM ofa_file,ofb_file
        # WHERE ofa01=ofb01 AND ofa61 = g_olc.olc04
        #   AND ofb31 = l_ofb.ofb31 AND ofb32 = l_ofb.ofb32
        #   AND ofaconf = 'Y' #01/08/07 mandy 取已confirm的資料
         LET g_sql = "SELECT SUM(ofb12),SUM(ofb14) ",
                     "  FROM ",cl_get_target_table(l_ofb.ofbplant,'ofa_file'),",",
                     "       ",cl_get_target_table(l_ofb.ofbplant,'ofb_file'),
                     " WHERE ofa01=ofb01 AND ofa61 = '",g_olc.olc04,"'",
                     "   AND ofb31 = '",l_ofb.ofb31,"'",
                     "   AND ofb32 = '",l_ofb.ofb32,"'",
                     "   AND ofaconf = 'Y'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,l_ofb.ofbplant) RETURNING g_sql
         PREPARE sel_ofb12 FROM g_sql
         EXECUTE sel_ofb12 INTO l_ofb12,l_ofb14
        #FUN-A60056--mod--end
         IF cl_null(l_ofb12) THEN LET l_ofb12 = 0 END IF
         IF cl_null(l_olb.olb07) THEN LET l_olb.olb07 = 0 END IF
         IF l_ofb12 > l_olb.olb07 THEN
         LET  g_showmsg=g_olc.olc04,"/",l_ofb.ofb31,"/",l_ofb.ofb32
         CALL s_errmsg('ofa61,ofb04,ofb32',g_showmsg,l_ofb.ofb04,'axr-311',1)
         LET g_success='N'
            CONTINUE FOREACH 
         END IF
         #出貨料號必須對應L/C料號
         IF l_ofb.ofb04 != l_olb.olb11 THEN
            LET  g_showmsg=g_olc.olc04,"/",l_ofb.ofb31,"/",l_ofb.ofb32
            CALL s_errmsg('ofa61,ofb04,ofb32',g_showmsg,l_ofb.ofb04,'axr-313',1) #MOD-B50233 mod axr-311 -> axr-313
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
   END IF
   IF g_success='Y' THEN
      #更新confirm碼、confirm者ID
     #UPDATE olc_file SET olcconf = 'Y',olc30 = g_user WHERE olc01 = g_olc.olc01 #TQC-A40054 Mark
     #TQC-A40054--Add--Begin
      UPDATE olc_file SET olcconf = 'Y',olc30 = g_user 
     #                    olc11 = g_olc.olc09                                    #MOD-CC0174 mark
      WHERE olc01 = g_olc.olc01
     #TQC-A40054--Add--End
       IF STATUS THEN                #No.MOD-4B0048
         CALL s_errmsg('olc01',g_olc.olc01,'upd olcconf',SQLCA.SQLCODE,1)              #NO.FUN-710050
         LET g_success = 'N'
      END IF
     #---------------MOD-CC0174--------------------mark
     ##更新信用狀單頭檔之已押匯金額
     #SELECT SUM(olc11) INTO l_tot FROM olc_file WHERE olc04 = g_olc.olc04
     ##no.4066只承認已confirm的單據
     #                                             AND olcconf='Y'
     #IF cl_null(l_tot) THEN LET l_tot=0 END IF
     #UPDATE ola_file SET ola10 = l_tot WHERE ola04 = g_olc.olc04
     # IF STATUS THEN              #No.MOD-4B0048
     #   CALL s_errmsg('ola04',g_olc.olc04,'upd ola10',SQLCA.SQLCODE,1)              #NO.FUN-710050
     #   LET g_success = 'N'
     #END IF
     #---------------MOD-CC0174--------------------mark
   END IF
   CALL s_showmsg()           #NO.FUN-710050
   IF g_success = 'Y'
      THEN LET g_olc.olcconf='Y' LET g_olc.olc30 = g_user COMMIT WORK
           LET g_amt = g_amt - g_olc.olc09
           DISPLAY g_amt TO FORMONLY.net_amt
          #LET g_olc.olc11 = g_olc.olc09                  #TQC-A40054 Add #MOD-CC0174 mark
          #DISPLAY BY NAME g_olc.olc11                    #TQC-A40054 Add #MOD-CC0174 mark
      ELSE LET g_olc.olcconf='N' LET g_olc.olc30 = ''     ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_olc.olcconf,g_olc.olc30
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN      
      LET g_wc_gl = 'npp01 = "',g_olc.olc29,'" AND npp011 = ',g_olc.olc28
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_olc.olcuser,"' '",g_olc.olcuser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_olc.olc02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #No.TQC-810036
      CALL cl_cmdrun_wait(g_str)                                                
      SELECT olc23,olc24 INTO g_olc.olc23,g_olc.olc24 FROM olc_file
       WHERE olc01 = g_olc.olc01
      DISPLAY BY NAME g_olc.olc23
      DISPLAY BY NAME g_olc.olc24
   END IF                                                                       
   CALL cl_set_field_pic(g_olc.olcconf,"","","","","")
END FUNCTION
 
FUNCTION t210_z() 			
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_sql       STRING                #No.FUN-670060
   DEFINE l_olc30_o   LIKE olc_file.olc30,
          l_ofb       RECORD LIKE ofb_file.*,
          l_olb       RECORD LIKE olb_file.*,
           l_tot    LIKE ofa_file.ofa50,
           l_rate   LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,10),  #FUN-4C0013
           m_rate   LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,10),  #FUN-4C0013
           l_ofb12  LIKE ofb_file.ofb12,
           l_ofb14  LIKE ofb_file.ofb14
   DEFINE l_n       LIKE type_file.num5          #No.TQC-770046
 
    SELECT * INTO g_olc.* FROM olc_file WHERE olc01 = g_olc.olc01
   IF g_olc.olcconf='N' THEN RETURN END IF
 
   #已有押匯入帳，不可取消審核。
   SELECT COUNT(*) INTO l_n FROM nmg_file WHERE nmg21 = g_olc.olc01  #NO.MOD-880050
      AND nmgconf <> 'X'  #MOD-B20023
   IF l_n > 0  THEN
      CALL cl_err(g_olc.olc29,'axr-040',0)
      RETURN
   END IF
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_olc.olc29) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_olc.olc23) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL cl_err(g_olc.olc29,'axr-370',0) RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_plant_new=g_ooz.ooz02p 
      #CALL s_getdbs()      #FUN-A50102
      #LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_olc.olc23,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_olc.olc23,'axr-071',1)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success = 'Y'

   #CHI-C90052 add begin---
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_olc.olc23,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT olc23,olc24 INTO g_olc.olc23,g_olc.olc24 FROM olc_file
       WHERE olc01 = g_olc.olc01
      IF NOT cl_null(g_olc.olc23) THEN
         CALL cl_err(g_olc.olc23,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_olc.olc23
      DISPLAY BY NAME g_olc.olc24
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
 
   OPEN t210_cl USING g_olc.olc01
 
   IF STATUS THEN
      CALL cl_err("OPEN t210_cl:", STATUS, 1)
      CLOSE t210_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t210_cl INTO g_olc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_olc.olc01,SQLCA.sqlcode,0)
       RETURN
   END IF
  #FUN-A60056--mod--str--
  #DECLARE ofb_curs_z CURSOR FOR
  #   SELECT ofb_file.*
  #     FROM ofa_file,ofb_file
  #    WHERE ofa01 = ofb01
  #      AND ofa61 = g_olc.olc04
  #      AND ofa01 = g_olc.olc01
  #      AND ofaconf = 'Y' #取已confirm的資料01/08/07 mandy
  #    ORDER BY ofb01,ofb03
   LET g_sql = "SELECT ofb_file.* ",
               "  FROM ",cl_get_target_table(g_plant,'ofa_file'),",",
               "       ",cl_get_target_table(g_plant,'ofb_file'),
               " WHERE ofa01 = ofb01 ",
               "   AND ofa61 = '",g_olc.olc04,"'",
               "   AND ofa01 = '",g_olc.olc01,"'",
               "   AND ofaconf = 'Y' ",
               "  ORDER BY ofb01,ofb03"
   PREPARE sel_ofb_pre1 FROM g_sql
   DECLARE ofb_curs_z CURSOR FOR sel_ofb_pre1
  #FUN-A60056--mod--end
 
   IF STATUS THEN CALL cl_err('ofb_curs',STATUS,1) RETURN  END IF
   CALL s_showmsg_init()                  #NO.FUN-710050
   FOREACH ofb_curs_z INTO l_ofb.*
       IF STATUS THEN 
          LET g_showmsg=g_olc.olc04,"/",g_olc.olc01        
          LET g_success = 'N'     #No.FUN-8A0086
          CALL s_errmsg('ofa61,ofa01',g_showmsg,'foreach ofb',STATUS,1)
          EXIT FOREACH
       END IF
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF      
         SELECT olb_file.* INTO l_olb.*
           FROM olb_file,ola_file
          WHERE ola01=olb01 AND ola04=g_olc.olc04
            AND olb04 = l_ofb.ofb31 AND olb05 = l_ofb.ofb32
            AND olaconf !='X' #010806增
         #檢查出貨數量是否超出L/C未押匯數量
        #FUN-A60056--mod--str--
        #SELECT SUM(ofb12),SUM(ofb14) INTO l_ofb12,l_ofb14
        #  FROM ofa_file,ofb_file
        # WHERE ofa01=ofb01 AND ofa61 = g_olc.olc04
        #   AND ofb31 = l_ofb.ofb31 AND ofb32 = l_ofb.ofb32
         LET g_sql = "SELECT SUM(ofb12),SUM(ofb14) ",
                     "  FROM ",cl_get_target_table(l_ofb.ofbplant,'ofa_file'),",",
                     "       ",cl_get_target_table(l_ofb.ofbplant,'ofb_file'),
                     " WHERE ofa01=ofb01 AND ofa61 = '",g_olc.olc04,"'",
                     "   AND ofb31 = '",l_ofb.ofb31,"'",
                     "   AND ofb32 = '",l_ofb.ofb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,l_ofb.ofbplant) RETURNING g_sql
         PREPARE  sel_ofb14_pre3 FROM g_sql
         EXECUTE  sel_ofb14_pre3 INTO l_ofb12,l_ofb14 
        #FUN-A60056--mod--end
         IF cl_null(l_ofb12) THEN LET l_ofb12 = 0 END IF
      END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
  #UPDATE olc_file SET olcconf = 'N',olc30 = g_user WHERE olc01 = g_olc.olc01 #TQC-A40054 Mark
  #TQC-A40054--Add--Begin
   UPDATE olc_file SET olcconf = 'N',olc30 = g_user 
                      #olc11 = olc11 - g_olc.olc09   #MOD-CC0174 mark
    WHERE olc01 = g_olc.olc01
  #TQC-A40054--Add--End
    IF STATUS  THEN                #No.MOD-4B0048
      CALL s_errmsg('olc01',g_olc.olc01,'upd olcconf',SQLCA.SQLCODE,1)              #NO.FUN-710050 
      LET g_success = 'N'
   END IF
  #-----------------MOD-CC0174------------------mark
  #IF g_success='Y' THEN
  #   #更新信用狀單頭檔之已押匯金額
  #   SELECT SUM(olc11) INTO l_tot FROM olc_file
  #    WHERE olc04 = g_olc.olc04
  #   #no.4066只承已confirm的單據
  #     AND  olcconf='Y'
  #   IF cl_null(l_tot) THEN LET l_tot=0 END IF
  #   UPDATE ola_file SET ola10 = l_tot WHERE ola04 = g_olc.olc04
  #    IF STATUS  THEN                #No.MOD-4B0048
  #      CALL s_errmsg('ola04',g_olc.olc04,'upd ola10',SQLCA.SQLCODE,1)              #NO.FUN-710050 
  #      LET g_success = 'N'
  #   END IF
  #END IF
  #-----------------MOD-CC0174------------------mark
 
   IF g_success='Y' THEN
     #FUN-A60056--mod--str--
     #UPDATE ofa_file SET ofa61 = ''
     # WHERE ofa01 = g_olc.olc01
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant,'ofa_file'),
                  "   SET ofa61 = '' ",
                  " WHERE ofa01 = '",g_olc.olc01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
      PREPARE upd_ofa_pre2 FROM g_sql
      EXECUTE upd_ofa_pre2
     #FUN-A60056--mod--end
      IF STATUS THEN
         CALL s_errmsg('ofa01',g_olc.olc01,'upd ofa61',SQLCA.SQLCODE,1)              #NO.FUN-710050 
         LET g_success='N'
      END IF
   END IF
 
   LET l_olc30_o = g_olc.olc30
   CALL s_showmsg()                 #NO.FUN-710050
   IF g_success = 'Y' THEN
      LET g_olc.olcconf='N' LET g_olc.olc30 = g_user
     #LET g_amt = g_amt + g_olc.olc09                                   #MOD-CC0174 mark
      CALL s_t200_amt(g_olc.olc04,'n') RETURNING g_order,g_amt          #MOD-CC0174
      DISPLAY g_amt TO FORMONLY.net_amt
     #LET g_olc.olc11 = g_olc.olc11 - g_olc.olc09       #TQC-A40054 Add #MOD-CC0174 mark
     #DISPLAY BY NAME g_olc.olc11                       #TQC-A40054 Add #MOD-CC0174 mark
      COMMIT WORK
   ELSE
      LET g_olc.olcconf='Y'
      LET g_olc.olc30 = l_olc30_o
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_olc.olcconf,g_olc.olc30
 
   #CHI-C90052 mark begin---
   #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_olc.olc23,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT olc23,olc24 INTO g_olc.olc23,g_olc.olc24 FROM olc_file
   #    WHERE olc01 = g_olc.olc01
   #   DISPLAY BY NAME g_olc.olc23
   #   DISPLAY BY NAME g_olc.olc24
   #END IF
   #CHI-C90052 mark end-----

   CALL cl_set_field_pic(g_olc.olcconf,"","","","","")
END FUNCTION
 
FUNCTION t210_v()
   DEFINE l_wc    LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(100)
   DEFINE l_t1    LIKE aba_file.aba00         #No.FUN-680123 VARCHAR(05)             #No.FUN-550071
   DEFINE l_ola01 LIKE ola_file.ola01
   DEFINE l_olc01 LIKE olc_file.olc01
   DEFINE l_olc12 LIKE olc_file.olc12       #No.FUN-740009
   DEFINE l_olc29 LIKE olc_file.olc29
   DEFINE l_olc28 LIKE olc_file.olc28
   DEFINE only_one     LIKE type_file.chr1    #No.FUN-680123 VARCHAR(1)
   DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680123 SMALLINT
   DEFINE ls_tmp STRING
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
    SELECT * INTO g_olc.* FROM olc_file
     WHERE olc01 = g_olc.olc01 AND olc02 = g_olc.olc02
    IF g_olc.olcconf = 'Y' THEN RETURN END IF
    IF g_ooy.ooydmy1 = 'N' THEN RETURN END IF
    LET p_row = 8 LET p_col = 11
    OPEN WINDOW t2109_w AT p_row,p_col WITH FORM "axr/42f/axrt2109"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axrt2109")
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t2109_w RETURN END IF
   IF only_one = '1' THEN
      LET l_wc = " olc01 = '",g_olc.olc01,"' "
   ELSE
      CONSTRUCT BY NAME l_wc ON olc03,olc01,olc02,olcuser,olcgrup
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW t2109_w
         RETURN
      END IF
   END IF
   CLOSE WINDOW t2109_w
   MESSAGE "WORKING !"
   LET g_sql = "SELECT olc01,olc12,olc29,olc28,ola01 FROM olc_file,ola_file ",       #No.FUN-740009
               " WHERE olc04 = ola04  AND olaconf !='X' ", #010806增
               " AND ",l_wc CLIPPED
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   #FUN-B50090 add -end--------------------------
   IF NOT cl_null(g_ooz.ooz09) THEN
      LET g_sql = g_sql CLIPPED," AND olc12 >'",g_ooz.ooz09,"'"
   END IF
   PREPARE t210_v_p FROM g_sql
   DECLARE t210_v_c CURSOR WITH HOLD FOR t210_v_p
   LET g_success='Y' #No.5573
   BEGIN WORK #no.5573
   CALL s_showmsg_init()           #NO.FUN-710050
   FOREACH t210_v_c INTO l_olc01,l_olc12,l_olc29,l_olc28,l_ola01       #No.FUN-740009
      IF STATUS THEN LET g_success = 'N' EXIT FOREACH END IF  #No.FUN-8A0086 
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
      CALL s_get_doc_no(l_ola01) RETURNING l_t1    #No.FUN-550071
      SELECT ooydmy1 INTO g_chr FROM ooy_file
       WHERE ooyslip = l_t1
      IF g_chr='N' THEN CONTINUE FOREACH END IF
      CALL s_get_bookno(YEAR(l_olc12)) RETURNING l_flag,l_bookno1,l_bookno2       #No.FUN-740009
      IF l_flag = '1' THEN
         CALL cl_err(YEAR(l_olc12),'aoo-081',1)
         LET g_success = 'N'
      END IF
      CALL s_t210_gl(l_olc01,l_olc29,l_olc28,'0',l_bookno1)       #No.FUN-740009
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_t210_gl(l_olc01,l_olc29,l_olc28,'1',l_bookno2)       #No.FUN-740009
      END IF
   END FOREACH
     IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
     END IF                                                                          
     CALL s_showmsg()             #NO.FUN-710050
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF #no.5573
   MESSAGE ""
END FUNCTION
 
FUNCTION t210_vc()
    IF g_olc.olc01 IS NULL THEN RETURN END IF
 
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       LET g_chr='D'
    ELSE
       LET g_chr='U'
    END IF
 
    CALL s_showmsg_init()                   #NO.FUN-710050
    CALL s_fsgl('AR',43,g_olc.olc29,g_olc.olc11,g_ooz.ooz02b,g_olc.olc28,g_olc.olcconf,'0',g_ooz.ooz02p)       #No.FUN-670047
    CALL s_showmsg()                        #NO.FUN-710050     
END FUNCTION
 
FUNCTION t210_vc_1()
    IF g_olc.olc01 IS NULL THEN RETURN END IF
 
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       LET g_chr='D'
    ELSE
       LET g_chr='U'
    END IF
    CALL s_showmsg_init()                    #NO.FUN-710050
    CALL s_fsgl('AR',43,g_olc.olc29,g_olc.olc11,g_ooz.ooz02c,g_olc.olc28,g_olc.olcconf,'1',g_ooz.ooz02p)       #No.FUN-670047
    CALL s_showmsg()                         #NO.FUN-710050
END FUNCTION
 
FUNCTION t210_m()
    LET g_olc_t.*=g_olc.*           #No.MOD-B70163 add
    IF g_olc.olc01 IS NULL THEN RETURN END IF
    WHILE TRUE
       INPUT BY NAME g_olc.olc141
                WITHOUT DEFAULTS
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END INPUT
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE olc_file SET olc141=g_olc.olc141
            WHERE olc01 = g_olc_t.olc01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","olc_file",g_olc.olc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t210_set_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1      #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("olc01",TRUE)
   END IF
 
   IF INFIELD(olc12) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("olc141",TRUE)
   END IF
 
   CALL cl_set_comp_entry("olc29",TRUE)   #MOD-750133
 
END FUNCTION
 
FUNCTION t210_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1         #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'u' THEN
      IF g_olc.olcconf = 'Y' THEN
         CALL cl_set_comp_entry("olc01,olc02,olc09,olc10,olc04,olc06,olc05,olc03,olc07,olc08,olc23,olc24",FALSE)
      ELSE
       IF ( NOT g_before_input_done ) AND g_chkey='N' THEN
         CALL cl_set_comp_entry("olc01",FALSE)
       END IF
      END IF
      CALL cl_set_comp_entry("olc29",FALSE)   #MOD-5B0007
   END IF
 
   IF INFIELD(olc12) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_olc.olc12) THEN
         CALL cl_set_comp_entry("ool141",FALSE)
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION t210_gen_glcr(p_olc,p_ooy,p_bookno1,p_bookno2)       #No.FUN-740009
  DEFINE p_olc     RECORD LIKE olc_file.*
  DEFINE p_ooy     RECORD LIKE ooy_file.*
  DEFINE p_bookno1 LIKE aza_file.aza81       #No.FUN-740009
  DEFINE p_bookno2 LIKE aza_file.aza82       #No.FUN-740009
 
    IF cl_null(p_ooy.ooygslp) THEN
       CALL cl_err(p_olc.olc29,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_t210_gl(p_olc.olc01,p_olc.olc29,p_olc.olc28,'0',p_bookno1)       #No.FUN-740009
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL s_t210_gl(p_olc.olc01,p_olc.olc29,p_olc.olc28,'1',p_bookno2)       #No.FUN-740009
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t210_carry_voucher()
  DEFINE l_ooygslp    LIKE ooy_file.ooygslp
  DEFINE li_result    LIKE type_file.num5         #No.FUN-680123 SMALLINT 
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680123 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_olc.olc29) RETURNING g_t1
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF g_ooy.ooydmy1 = 'N' THEN RETURN END IF
  # IF g_ooy.ooyglcr = 'Y' THEN                                                           #TQC-AB0366 mark
    IF g_ooy.ooyglcr = 'Y' OR (g_ooy.ooyglcr != 'Y' AND NOT cl_null(g_ooy.ooygslp)) THEN  #TQC-AB0366
       LET g_plant_new=g_ooz.ooz02p 
       #CALL s_getdbs()      #FUN-A50102
       #LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                   "    AND aba01 = '",g_olc.olc23,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2 
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN 
          CALL cl_err(g_olc.olc23,'aap-991',1)
          RETURN
       END IF
 
       LET l_ooygslp = g_ooy.ooygslp
    ELSE
       CALL cl_err('','aap-992',1)
       RETURN
 
    END IF
    IF cl_null(l_ooygslp) THEN
       CALL cl_err(g_olc.olc29,'axr-070',1)
       RETURN
    END IF
    IF g_aza.aza63 = 'Y' AND cl_null(g_ooy.ooygslp1) THEN
       CALL cl_err(g_olc.olc29,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_olc.olc29,'" AND npp011 = ',g_olc.olc28
    LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_olc.olcuser,"' '",g_olc.olcuser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_olc.olc02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.TQC-810036
    CALL cl_cmdrun_wait(g_str)
    SELECT olc23,olc24 INTO g_olc.olc23,g_olc.olc24 FROM olc_file
     WHERE olc01 = g_olc.olc01
    DISPLAY BY NAME g_olc.olc23
    DISPLAY BY NAME g_olc.olc24
    
END FUNCTION
 
FUNCTION t210_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_olc.olc01) RETURNING g_t1                                                                                   
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1                                                                          
    IF g_ooy.ooyglcr = 'N' THEN                                                                                                     
       CALL cl_err('','aap-990',1)                                                                                                  
       RETURN                                                                                                                       
    END IF
 
    LET g_plant_new=g_ooz.ooz02p 
    #CALL s_getdbs()      #FUN-A50102   
    #LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                "    AND aba01 = '",g_olc.olc23,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_olc.olc23,'axr-071',1)
       RETURN
    END IF
    LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_olc.olc23,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT olc23,olc24 INTO g_olc.olc23,g_olc.olc24 FROM olc_file
     WHERE olc01 = g_olc.olc01
    DISPLAY BY NAME g_olc.olc23
    DISPLAY BY NAME g_olc.olc24
END FUNCTION
 
#押匯金額與信用狀金額比較。
FUNCTION t210_olc11(p_olc11)
DEFINE   p_olc11        LIKE olc_file.olc11
DEFINE   l_ola09        LIKE ola_file.ola09
DEFINE   l_msg          LIKE type_file.chr1000
 
    LET l_ola09 = NULL
    LET l_msg = NULL
 
    SELECT ola09 INTO l_ola09 FROM ola_file WHERE ola01 = g_olc.olc29   
    IF cl_null(l_ola09) THEN
       LET l_ola09 = 0
    END IF 
    IF p_olc11 > l_ola09 THEN
       LET l_msg = p_olc11,'>',l_ola09
       CALL cl_err(l_msg,'axr-041',1)
       RETURN 0
    END IF
    RETURN 1
END FUNCTION
 
#此函數的功能是判斷invoice中的訂單是否存在于信用狀內，
#若invoice內有訂單不存在于信用狀中，則不可輸入該invoice.
FUNCTION t210_chk_olc01(p_ofb01,p_olb01)
DEFINE   p_ofb01                 LIKE ofb_file.ofb01    #INVOICE#
DEFINE   p_olb01                 LIKE olb_file.olb01    #Μ﹐蟲蟲腹
DEFINE   l_sql                   STRING
DEFINE   l_msg                   STRING
DEFINE   l_ofb01                 LIKE ofb_file.ofb01
DEFINE   l_ofb31                 LIKE ofb_file.ofb31
DEFINE   l_ofb32                 LIKE ofb_file.ofb32
DEFINE   l_success               LIKE type_file.chr1
DEFINE   l_cnt                   LIKE type_file.num5
 
    LET l_success = 'Y' 
    LET l_msg = ''
 
   #LET l_sql = " SELECT COUNT(ofb01) FROM ofb_file ",   #FUN-A60056
    LET l_sql = " SELECT COUNT(ofb01) FROM ",cl_get_target_table(g_plant,'ofb_file'),   #FUN-A60056
                "  WHERE (ofb31,ofb32) NOT IN ",
                "  ( SELECT olb04,olb05 FROM olb_file ",
                "     WHERE olb01='",p_olb01,"' )  ",
                "    AND ofb01 ='",p_ofb01,"'" 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A60056
    CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql   #FUN-A60056
    PREPARE t210_chk_olc01_prep1 FROM l_sql
    DECLARE t210_chk_olc01_cs1 CURSOR FOR t210_chk_olc01_prep1
 
    LET l_cnt = 0
    OPEN t210_chk_olc01_cs1
    FETCH t210_chk_olc01_cs1 INTO l_cnt
    CLOSE t210_chk_olc01_cs1
 
    IF l_cnt = 0 THEN 
       RETURN l_success,l_msg
    ELSE
       LET l_msg = cl_getmsg('axr-416',g_lang)
       LET l_msg = l_msg ,': \n'
      #LET l_sql = " SELECT ofb01,ofb31,ofb32 FROM ofb_file ",   #FUN-A60056
       LET l_sql = " SELECT ofb01,ofb31,ofb32 FROM ",cl_get_target_table(g_plant,'ofb_file'),   #FUN-A60056
                   "  WHERE (ofb31,ofb32) NOT IN ",
                   "  ( SELECT olb04,olb05 FROM olb_file ",
                   "     WHERE olb01='",p_olb01,"' )  ",
                   "    AND ofb01 ='",p_ofb01,"'" 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A60056
       CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql   #FUN-A60056
       PREPARE t210_chk_olc01_prep2 FROM l_sql 
       DECLARE t210_chk_olc01_cs2 CURSOR FOR t210_chk_olc01_prep2
 
       FOREACH t210_chk_olc01_cs2 INTO l_ofb01,l_ofb31,l_ofb32
          LET  l_msg = l_msg ,l_ofb01,'  ',l_ofb31,'-',l_ofb32,'\n'
       END FOREACH
       LET l_success = 'N'
       RETURN l_success ,l_msg
    END IF 
    
 
END FUNCTION 
#No.FUN-9C0072 精簡程式碼
