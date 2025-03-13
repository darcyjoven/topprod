# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi150.4gl
# Descriptions...: E-BOM元件廠商資料維護
# Date & Author..: 2000/01/03 By Kammy
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0248 04/10/26 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: NO.FUN-570129 05/07/28 By yiting 單身只有行序時只能放棄才能離開
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-720053 07/02/28 By Ray 1.欄位"元件料件”輸入任何值不報錯
#                                                2."組件料件"和"主件編號"字段的開窗數據都與實際不符
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790103 07/09/18 By lumxa 復制時，版本不能開窗
# Modify.........: No.TQC-790168 07/09/29 By Pengu p_flow unicode 區無法執行程式
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AB0025 10/11/05 By vealxu 拿掉FUN-AA0059 料號管控，測試料件無需判斷
# Modify.........: No.TQC-AB0074 10/11/24 By destiny 元件开窗品名规格应抓bmq_file资料
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bel01         LIKE bel_file.bel01,   #規格主鍵編號 (假單頭)  #No.TQC-790168 #TQC-840066
    g_bel02         LIKE bel_file.bel02,   #規格主鍵編號 (假單頭)
    g_bel011        LIKE bel_file.bel011,  #規格主鍵編號 (假單頭)
    g_bel01_t       LIKE bel_file.bel01,   #特性料件編號 (舊值)
    g_bel02_t       LIKE bel_file.bel02,   #特性料件編號 (舊值)
    g_bel011_t      LIKE bel_file.bel011,  #特性料件編號 (舊值)
    l_cnt           LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    l_cnt1          LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    l_cmd           LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(100)
    g_bel           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bel03       LIKE bel_file.bel03,   #行序
        bel04       LIKE bel_file.bel04,   #條件編號
        mse02       LIKE mse_file.mse02,   #
        bmj10       LIKE bmj_file.bmj10,   #承認文號
        bmj11       LIKE bmj_file.bmj11,   #承認日期
        wdesc       LIKE type_file.chr6,   #狀態  #No.FUN-680096 VARCHAR(6)
        bel06       LIKE bel_file.bel06,   #主要供應商
        pmc03       LIKE bel_file.bel06    #
                    END RECORD,
    g_bel_t         RECORD                 #程式變數 (舊值)
        bel03       LIKE bel_file.bel03,   #行序
        bel04       LIKE bel_file.bel04,   #條件編號
        mse02       LIKE mse_file.mse02,   #
        bmj10       LIKE bmj_file.bmj10,   #承認文號
        bmj11       LIKE bmj_file.bmj11,   #承認日期
        wdesc       LIKE type_file.chr6,   #狀態a #No.FUN-680096 VARCHAR(6)
        bel06       LIKE bel_file.bel06,   #主要供應商
        pmc03       LIKE bel_file.bel06    #
                    END RECORD,
    g_bel04_o       LIKE bel_file.bel04,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680096 SMALLINT
    g_ss            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_comp          LIKE bel_file.bel01,
    g_verno         LIKE bel_file.bel011,
    l_za05          LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(40)
    g_item          LIKE bel_file.bel02,
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg      LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
MAIN
# DEFINE                                     #No.FUN-6A0060 
#       l_time    LIKE type_file.chr8        #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
 
    LET g_bel01 = NULL                     #清除鍵值
    LET g_bel02 = NULL                     #清除鍵值
    LET g_bel011= NULL                     #清除鍵值
    LET g_bel01_t = NULL
    LET g_bel02_t = NULL
    LET g_bel011_t = NULL
    #取得參數
    LET g_comp=ARG_VAL(1)	#元件
    IF g_comp=' ' THEN LET g_comp='' ELSE LET g_bel01=g_comp END IF
    LET g_item=ARG_VAL(2)	#主件
    IF g_item=' ' THEN LET g_item='' ELSE LET g_bel02=g_item END IF
    LET g_verno=ARG_VAL(3)      #版本
    IF g_verno=' ' THEN LET g_verno=' ' ELSE LET g_bel011=g_verno END IF
 
    LET p_row = 4 LET p_col = 8
 
    OPEN WINDOW i150_w AT p_row,p_col             #顯示畫面
         WITH FORM "abm/42f/abmi150"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
 
    IF g_item IS NOT NULL	#有傳入參數, 則將已存在的資料顯示出來
    THEN CALL i150_q()
    END IF
    LET g_delete='N'
 
    CALL i150_menu()
 
    CLOSE WINDOW i150_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i150_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
     IF cl_null(g_item) THEN
        CLEAR FORM                             #清除畫面
        CALL g_bel.clear()
        CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INITIALIZE g_bel01 TO NULL    #No.FUN-750051
   INITIALIZE g_bel011 TO NULL    #No.FUN-750051
   INITIALIZE g_bel02 TO NULL    #No.FUN-750051
        CONSTRUCT g_wc ON bel01,bel02,bel011          #螢幕上取條件
             FROM bel01,bel02,bel011
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bel01)
#                    CALL q_bma1(10,3,g_bel01,'') RETURNING g_bel01
                     CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_bma101"     #No.TQC-720053
                    #LET g_qryparam.form = "q_bmp03"     #No.TQC-720053  #No.TQC-AB0074
                     LET g_qryparam.form = "q_bmp3"     #No.TQC-AB0074
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bel01
                     NEXT FIELD bel01
                WHEN INFIELD(bel02)
#                    CALL q_bma1(10,3,g_bel02,'') RETURNING g_bel02
                     CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_bma101"      #No.TQC-720053
                     LET g_qryparam.form = "q_bmo"      #No.TQC-720053
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bel02
                     NEXT FIELD bel02
                     #no.6542
                  #--No.MOD-4A0248--#
                 WHEN INFIELD(bel011)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmo1"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bel011
                     NEXT FIELD bel011
                 #-------END-------#
                OTHERWISE
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
        CONSTRUCT g_wc2 ON bel03,bel04,bel06
             FROM s_bel[1].bel03,s_bel[1].bel04,s_bel[1].bel06
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(bel04)      #廠牌
#                 CALL q_mse(0,0,g_bel[1].bel04) RETURNING g_bel[1].bel04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_mse"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bel04
                  NEXT FIELD bel04
             WHEN INFIELD(bel06)
#                 CALL q_pmc(0,0,g_bel[1].bel06) RETURNING g_bel[1].bel06
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bel06
                  NEXT FIELD bel06
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
 
 
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
    	IF INT_FLAG THEN RETURN END IF
     ELSE
        LET g_wc=" bel02='",g_item,"'"
        IF g_comp IS NOT NULL THEN
           LET g_wc=g_wc CLIPPED," AND bel01='",g_comp,"'"
        END IF
        IF g_verno IS NOT NULL THEN
           LET g_wc=g_wc CLIPPED," AND bel011='",g_verno,"'"
        END IF
        LET g_wc2 = "1=1"
     END IF
 
    LET g_sql="SELECT UNIQUE bel01,bel011,bel02 FROM bel_file ", #組合出SQL指令
               " WHERE ", g_wc CLIPPED,
               "   AND ", g_wc2 CLIPPED,
               " ORDER BY bel01,bel02"
    PREPARE i150_prepare FROM g_sql      #預備一下
    DECLARE i150_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i150_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      #LET g_sql = "SELECT UNIQUE bel01,bel011,bel02 FROM bel_file ",      #No.TQC-720019
       LET g_sql_tmp = "SELECT UNIQUE bel01,bel011,bel02 FROM bel_file ",  #No.TQC-720019
                   " WHERE ", g_wc CLIPPED,
                   "  INTO TEMP x "
    ELSE
      #LET g_sql = "SELECT UNIQUE bel01,bel011,bel02 FROM bel_file ",      #No.TQC-720019
       LET g_sql_tmp = "SELECT UNIQUE bel01,bel011,bel02 FROM bel_file ",  #No.TQC-720019
                   " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "  INTO TEMP x "
    END IF
    DROP TABLE x
   #PREPARE i150_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i150_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i150_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE i150_precount FROM g_sql
    DECLARE i150_count CURSOR FOR i150_precount
END FUNCTION
 
 
FUNCTION i150_menu()
 
   WHILE TRUE
      CALL i150_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i150_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i150_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i150_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                CALL i150_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i150_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bel01 IS NOT NULL THEN
                  LET g_doc.column1 = "bel01"
                  LET g_doc.value1 = g_bel01
                  LET g_doc.column2 = "bel011"
                  LET g_doc.value2 = g_bel011
                  LET g_doc.column3 = "bel02"
                  LET g_doc.value3 = g_bel02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bel),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i150_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_bel.clear()
    INITIALIZE g_bel01 LIKE bel_file.bel01
    INITIALIZE g_bel02 LIKE bel_file.bel02
    INITIALIZE g_bel011 LIKE bel_file.bel011
    IF g_comp IS NOT NULL THEN LET g_bel01=g_comp
    DISPLAY g_bel01 TO bel01 END IF
    IF g_item IS NOT NULL THEN LET g_bel02=g_item
    DISPLAY g_bel02 TO bel02 END IF
    IF g_verno IS NOT NULL THEN LET g_bel011=g_verno
    DISPLAY g_bel011 TO bel011 END IF
    LET g_bel01_t = NULL
    LET g_bel02_t = NULL
    LET g_bel011_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        IF g_comp IS NULL THEN
           CALL i150_i("a")                   #輸入單頭
           IF INT_FLAG THEN                   #使用者不玩了
              LET g_bel01 = NULL
              LET INT_FLAG = 0
              CALL cl_err('',9001,0)
              EXIT WHILE
           END IF
        ELSE
           CALL i150_bel01('d')
           IF g_errno='mfg9116' 
           THEN 
           CALL cl_err('',g_errno,0)  
           END IF
           CALL i150_bel02('d')
        END IF
        CALL g_bel.clear()
        DISPLAY g_rec_b TO FORMONLY.cn2
        LET g_rec_b = 0
        CALL i150_b()                   #輸入單身
        LET g_bel01_t = g_bel01            #保留舊值
        LET g_bel02_t = g_bel02            #保留舊值
        LET g_bel011_t = g_bel011            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i150_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bel01 IS NULL OR g_bel02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bel01_t = g_bel01
    LET g_bel02_t = g_bel02
    LET g_bel011_t= g_bel011
    WHILE TRUE
        CALL i150_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_bel01 =g_bel01_t
            LET g_bel02 =g_bel02_t
            LET g_bel011=g_bel011_t
            DISPLAY g_bel01 TO bel01      #單頭
            DISPLAY g_bel02 TO bel02      #單頭
            DISPLAY g_bel011 TO bel011     #單頭
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bel01 != g_bel01_t OR g_bel02 != g_bel02_t OR g_bel011!=g_bel011_t
           THEN #更改單頭值
            UPDATE bel_file SET bel01 = g_bel01,  #更新DB
		                bel02 = g_bel02,
		                bel011= g_bel011
                WHERE bel01 = g_bel01_t          #COLAUTH?
	          AND bel02 = g_bel02_t
	          AND bel011= g_bel011_t
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_bel01 CLIPPED,' + ', g_bel02 CLIPPED,' +',g_bel011
          #     CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("upd","bel_file",g_msg,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i150_i(p_cmd)
DEFINE
    p_cmd      LIKE type_file.chr1,       #a:輸入 u:更改   #No.FUN-680096 VARCHAR(1)
    l_bel04    LIKE bel_file.bel04
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
    INPUT g_bel01, g_bel02,g_bel011
        WITHOUT DEFAULTS
        FROM bel01,bel02,bel011
 
 
	    BEFORE FIELD bel01  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(8,29,g_bel01) RETURNING g_bel01
	            DISPLAY g_bel01 TO bel01
	    END IF
 
        AFTER FIELD bel01            #元件編號
            IF NOT cl_null(g_bel01) THEN
#FUN-AB0025 --------------mark start-------------
#               #FUN-AA0059 ------------------------add start--------------------
#               IF NOT s_chk_item_no(g_bel01,'') THEN
#                  CALL cl_err('',g_errno,1)
#                  LET g_bel01 = g_bel01_t
#                  DISPLAY g_bel01 TO bel01
#                  NEXT FIELD bel01
#               END IF 
#               #FUN-AA0059 -----------------------add end------------------------ 
#FUN-AB0025 ------------ mark end------------------
                IF g_bel01 != g_bel01_t OR g_bel01_t IS NULL THEN
                    CALL i150_bel01('a')
                    IF NOT cl_null(g_errno) THEN
                       IF g_errno='mfg9116' THEN
                          IF NOT cl_confirm(g_errno)
                          THEN NEXT FIELD bel01
                          END IF
                       ELSE
                          CALL cl_err(g_bel01,g_errno,0)
                          LET g_bel01 = g_bel01_t
                          DISPLAY g_bel01 TO bel01
                          NEXT FIELD bel01
                       END IF
                    END IF
                END IF
            END IF
 
	    BEFORE FIELD bel02   # 是否可以修改 key
	    IF g_sma.sma60 = 'Y' # 若須分段輸入
	       THEN CALL s_inp5(11,29,g_bel02) RETURNING g_bel02
	            DISPLAY g_bel02 TO bel02
	    END IF
 
        AFTER FIELD bel02            #主件編號
            IF NOT cl_null(g_bel02) THEN
#FUN-AB0025 --------------mark start-------------
#               #FUN-AA0059 -------------------------add start-------------------
#               IF NOT s_chk_item_no(g_bel02,'') THEN
#                  CALL cl_err('',g_errno,1)
#                  LET g_bel02 = g_bel02_t
#                  DISPLAY BY NAME g_bel02
#                  NEXT FIELD bel02
#               END IF 
#               #FUN-AA0059 -------------------------add end-------------------------    
#FUN-AB0025 -------------mark end----------------
                IF g_bel02 IS NOT NULL AND
                   (g_bel01!=g_bel01_t OR g_bel02!=g_bel02_t
                    OR g_bel02_t IS NULL)
                    THEN                         # 若輸入或更改且改KEY
                    #TQC-720053-begin-add
                    #-->check 是否存在正式的 BOM 中
                    SELECT count(*) INTO g_cnt FROM bma_file
                        WHERE bma01 = g_bel02
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_bel02,'mfg2758',0)
                       LET g_bel02 = g_bel02_t
                       DISPLAY BY NAME g_bel02
                       NEXT FIELD bel02
                    END IF
                    #TQC-720053-end-add
                    CALL i150_bel02('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_bel02,g_errno,0)
                       LET g_bel02 = g_bel02_t
                       DISPLAY g_bel02 TO bel02
                       NEXT FIELD bel02
                    END IF
                END IF
            END IF
 
         AFTER FIELD bel011
            IF NOT cl_null(g_bel011) THEN
                IF g_bel02 IS NOT NULL AND
                   (g_bel01!=g_bel01_t OR g_bel02!=g_bel02_t
                    OR g_bel02_t IS NULL OR g_bel011!=g_bel011_t)
                    THEN                         # 若輸入或更改且改KEY
                    SELECT count(*) INTO g_cnt FROM bel_file
                        WHERE bel01 = g_bel01
                          AND bel02 = g_bel02
                          AND bel011= g_bel011
                    IF g_cnt > 0 THEN   #資料重複
                       LET g_msg = g_bel01 CLIPPED,'+', g_bel02 CLIPPED,'+',g_bel011
                       CALL cl_err(g_msg,-239,0)
                       LET g_bel01 = g_bel01_t
                       LET g_bel02 = g_bel02_t
                       LET g_bel011= g_bel011_t
                        DISPLAY  g_bel01 TO bel01
                        DISPLAY  g_bel02 TO bel02
                        DISPLAY  g_bel011 TO bel011
                        NEXT FIELD bel01
                    END IF
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bel01)
#                    CALL q_bma1(10,3,g_bel01,'') RETURNING g_bel01
                     CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_bma101"     #No.TQC-720053
                    #LET g_qryparam.form = "q_bmp03"     #No.TQC-720053  #No.TQC-AB0074
                     LET g_qryparam.form = "q_bmp3"     #No.TQC-AB0074
                     LET g_qryparam.default1 = g_bel01
                     CALL cl_create_qry() RETURNING g_bel01
                     DISPLAY BY NAME g_bel01
                     CALL i150_bel01('d')
                     NEXT FIELD bel01
                WHEN INFIELD(bel02)
#                    CALL q_bma1(10,3,g_bel02,'') RETURNING g_bel02
                     CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_bma101"      #No.TQC-720053
                     LET g_qryparam.form = "q_bmo"      #No.TQC-720053
                     LET g_qryparam.default1 = g_bel02
                     CALL cl_create_qry() RETURNING g_bel02,g_bel011      #No.TQC-720053
        	     IF g_bel02 IS NULL THEN
		         LET g_bel02 = g_bel02_t
         	     END IF
                     DISPLAY BY NAME g_bel02,g_bel011      #No.TQC-720053
                     CALL i150_bel02('d')
                     NEXT FIELD bel02
                     #no.6542
                WHEN INFIELD(bel011) #料件主檔
#                    CALL q_bmo1(8,8,g_bel02) RETURNING g_bel011
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmo1"
                     LET g_qryparam.default1 = g_bel011
                     LET g_qryparam.construct = "N"
                     IF NOT cl_null(g_bel02) THEN
                        LET g_qryparam.where = " bmo01 = '",g_bel02,"'"
                     END IF
                     CALL cl_create_qry() RETURNING g_bel011
                     DISPLAY BY NAME g_bel011
                     NEXT FIELD bel011
                     #no.6542(end)
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021 
    END INPUT
END FUNCTION
 
FUNCTION i150_bel01(p_cmd)  #規格主件編號
    DEFINE p_cmd     LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima05   LIKE ima_file.ima05,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti,
           l_bmq011  LIKE bmq_file.bmq011
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima05,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bel01
#No.TQC-720053 --begin
#   CASE WHEN SQLCA.SQLCODE
           IF STATUS THEN
#No.TQC-720053 --end
              SELECT  bmq011,bmq02,bmq021,bmq05,bmq08,bmqacti
              INTO l_bmq011,l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti
                 FROM bmq_file
                WHERE bmq01 = g_bel01
           END IF                  #TQC-730053  add
    CASE                       #TQC-720053  add
         WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2631'
                            LET l_ima02 = NULL  LET l_ima05 = NULL
                            LET l_ima021 = NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
 
         WHEN l_ima08 NOT MATCHES '[PVZS]' LET g_errno = 'mfg9116'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #--->來源碼為'Z':雜項料件
    IF l_ima08 ='Z' THEN LET g_errno = 'mfg2752' RETURN END IF
 
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h
           DISPLAY l_ima021 TO FORMONLY.ima021_h
           DISPLAY l_ima05 TO FORMONLY.ima05_h
           DISPLAY l_ima08 TO FORMONLY.ima08_h
    END IF
END FUNCTION
 
FUNCTION i150_bel02(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima05   LIKE ima_file.ima05,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti,
           l_bmq011  LIKE bmq_file.bmq011
 
      LET g_errno = ' '
      IF g_bel02=g_bel01 THEN LET g_errno='mfg2633' RETURN END IF
      IF g_bel02='all' THEN
         LET g_bel02='ALL'
         DISPLAY g_bel02 TO bel02
      END IF
      IF g_bel02='ALL' THEN
         DISPLAY '' TO FORMONLY.ima02_h2
         DISPLAY '' TO FORMONLY.ima021_h2
         DISPLAY '' TO FORMONLY.ima05_h2
         DISPLAY '' TO FORMONLY.ima08_h2
         RETURN
      END IF
    SELECT ima02,ima021,ima05,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bel02
    CASE WHEN SQLCA.SQLCODE
              SELECT  bmq011,bmq02,bmq021,bmq05,bmq08,bmqacti
              INTO l_bmq011,l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti
                 FROM bmq_file
                WHERE bmq01 = g_bel02
                  IF SQLCA.sqlcode THEN
                      LET g_errno = 'mfg2602'
                      LET l_ima02 = NULL
                      LET l_ima05 = NULL
                      LET l_ima021= NULL
                      LET l_ima08 = NULL
                      LET l_imaacti = NULL
                  END IF
              IF l_bmq011 IS NOT NULL AND l_bmq011 != ' ' THEN
                 LET g_errno = 'mfg2764'
              END IF
         WHEN l_imaacti='N'                  LET g_errno = '9028'
  #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
        
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h2
           DISPLAY l_ima021 TO FORMONLY.ima021_h2
           DISPLAY l_ima05 TO FORMONLY.ima05_h2
           DISPLAY l_ima08 TO FORMONLY.ima08_h2
    END IF
    IF NOT cl_null(g_errno) THEN
      DISPLAY '' TO FORMONLY.ima02_h2
      DISPLAY '' TO FORMONLY.ima021_h2
      DISPLAY '' TO FORMONLY.ima05_h2
      DISPLAY '' TO FORMONLY.ima08_h2
    END IF
END FUNCTION
#Query 查詢
FUNCTION i150_q()
  DEFINE l_bel01  LIKE bel_file.bel01,
         l_bel011 LIKE bel_file.bel011,
         l_bel02  LIKE bel_file.bel02,
         l_cnt    LIKE type_file.num10   #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bel01 TO NULL             #No.FUN-6A0002
    INITIALIZE g_bel02 TO NULL             #No.FUN-6A0002
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i150_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bel01 TO NULL
        INITIALIZE g_bel02 TO NULL
        RETURN
    END IF
    OPEN i150_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bel01 TO NULL
        INITIALIZE g_bel02 TO NULL
    ELSE
        OPEN i150_count
        FETCH i150_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        CALL i150_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i150_fetch(p_flag)
DEFINE
  p_flag   LIKE type_file.chr1,     #處理方式   #No.FUN-680096 VARCHAR(1)
  l_bel01  LIKE bel_file.bel01,
  l_bel011 LIKE bel_file.bel011,
  l_bel02  LIKE bel_file.bel02,
  l_cnt    LIKE type_file.num10     #No.FUN-680096 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i150_bcs INTO g_bel01,g_bel011,g_bel02
        WHEN 'P' FETCH PREVIOUS i150_bcs INTO g_bel01,g_bel011,g_bel02
        WHEN 'F' FETCH FIRST    i150_bcs INTO g_bel01,g_bel011,g_bel02
        WHEN 'L' FETCH LAST     i150_bcs INTO g_bel01,g_bel011,g_bel02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i150_bcs INTO g_bel01,g_bel011,g_bel02
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_bel01,SQLCA.sqlcode,0)
       INITIALIZE g_bel01  TO NULL  #TQC-6B0105
       INITIALIZE g_bel011 TO NULL  #TQC-6B0105
       INITIALIZE g_bel02  TO NULL  #TQC-6B0105
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
    END IF
 
    CALL i150_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i150_show()
    DISPLAY g_bel01 TO bel01      #單頭
    DISPLAY g_bel02 TO bel02      #單頭
    DISPLAY g_bel011 TO bel011      #單頭
    CALL i150_bel01('d')
    CALL i150_bel02('d')
    CALL i150_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i150_r()
    IF s_shut(0) THEN RETURN END IF        #檢查權限
    IF g_bel01 IS NULL THEN
       CALL cl_err("",-400,0)              #No.FUN-6A0002
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bel01"       #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bel01        #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bel011"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bel011       #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bel02"       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bel02        #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM bel_file WHERE bel01 = g_bel01
                               AND bel02 = g_bel02
                               AND bel011= g_bel011
        IF SQLCA.sqlcode THEN
       #    CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660046
            CALL cl_err3("del","bel_file",g_bel01,g_bel02,SQLCA.sqlcode,"","BODY DELETE:",1)   #No.TQC-660046
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i150_precount_x                   #No.TQC-720019
            PREPARE i150_precount_x2 FROM g_sql_tmp   #No.TQC-720019
            EXECUTE i150_precount_x2                  #No.TQC-720019
            #MOD-5A0004 end
            CALL g_bel.clear()
            OPEN i150_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i150_bcs
               CLOSE i150_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i150_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i150_bcs
               CLOSE i150_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i150_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i150_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i150_fetch('/')
            END IF
 
            LET g_delete='Y'
            #No.TQC-720019  --Begin
            #LET g_bel01 = NULL
            #LET g_bel02 = NULL
            #LET g_bel011= NULL
            #LET g_cnt=SQLCA.SQLERRD[3]
            #MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #No.TQC-720019  --End   
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i150_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用      #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否      #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680096 VARCHAR(1)
    l_bmo05         LIKE bmo_file.bmo05,
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bel01 IS NULL THEN
        RETURN
    END IF
    #no.6542
    SELECT bmo05 INTO l_bmo05 FROM bmo_file
     WHERE bmo01 = g_bel02
       AND bmo011= g_bel011
    IF NOT cl_null(l_bmo05) THEN
   #   CALL cl_err('','mfg2761',0) #No.TQC-660046
       CALL cl_err3("sel","bmo_file",g_bel02,g_bel011,'mfg2761',"","",1)  #No.TQC-660046
       RETURN
    END IF
    #no.6542(end)
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT bel03,bel04,'','','','',bel06,'' ",
      "   FROM bel_file ",
      "   WHERE bel01 = ? ",
      "    AND bel011= ? ",
      "    AND bel02 = ? ",
      "    AND bel03 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i150_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bel
              WITHOUT DEFAULTS
              FROM s_bel.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_sl = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bel_t.* = g_bel[l_ac].*  #BACKUP
               LET g_bel04_o = g_bel[l_ac].bel04  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
 
                OPEN i150_bcl USING g_bel01,g_bel011,g_bel02,g_bel_t.bel03
                IF STATUS THEN
                    CALL cl_err("OPEN i150_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i150_bcl INTO g_bel[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bel_t.bel03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    CALL i150_bel04('d')
                    SELECT pmc03 INTO g_bel[l_ac].pmc03 FROM pmc_file
                     WHERE pmc01=g_bel[l_ac].bel06
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bel03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
             INSERT INTO bel_file (bel01,bel011,bel02,bel03,bel04,bel05,bel06) #No.MOD-470041
                 VALUES(g_bel01,g_bel011,g_bel02,g_bel[l_ac].bel03,
                        g_bel[l_ac].bel04,"",g_bel[l_ac].bel06)
            IF SQLCA.sqlcode THEN
        #       CALL cl_err(g_bel[l_ac].bel03,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","bel_file",g_bel01,g_bel011,SQLCA.sqlcode,"","",1)    #No.TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bel[l_ac].* TO NULL      #900423
            LET g_bel_t.* = g_bel[l_ac].*         #新輸入資料
            CASE
             WHEN g_bel[l_ac].wdesc = "0"
                  let g_bel[l_ac].wdesc = g_x[20]
             when g_bel[l_ac].wdesc = "1"
                  let g_bel[l_ac].wdesc = g_x[21]
             when g_bel[l_ac].wdesc = "2"
                  let g_bel[l_ac].wdesc = g_x[22]
             when g_bel[l_ac].wdesc = "3"
                  let g_bel[l_ac].wdesc = g_x[23]
             WHEN g_bel[l_ac].wdesc = "4"
                  let g_bel[l_ac].wdesc = g_x[24]
            END CASE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bel03
 
        BEFORE FIELD bel03                        #default 序號
            IF cl_null(g_bel[l_ac].bel03) OR
                       g_bel[l_ac].bel03=0 THEN
                SELECT max(bel03)+1
                   INTO g_bel[l_ac].bel03
                   FROM bel_file
                   WHERE bel01 = g_bel01 AND bel02 = g_bel02
                IF g_bel[l_ac].bel03 IS NULL THEN
                    LET g_bel[l_ac].bel03 = 1
                END IF
                #NO.FUN-570129 mark
                #DISPLAY g_bel[l_ac].bel03 TO s_bel[l_sl].bel03
            END IF
 
        AFTER FIELD bel03                        #check 序號是否重複
            IF NOT cl_null(g_bel[l_ac].bel03) THEN
                IF g_bel[l_ac].bel03 != g_bel_t.bel03 OR
                   g_bel_t.bel03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bel_file
                        WHERE bel01 = g_bel01
                          AND bel02 = g_bel02
                          AND bel011= g_bel011
                          AND bel03 = g_bel[l_ac].bel03
                    IF l_n > 0 THEN
                        CALL cl_err(g_bel[l_ac].bel03,-239,0)
                        LET g_bel[l_ac].bel03 = g_bel_t.bel03
                        DISPLAY g_bel[l_ac].bel03 TO s_bel[l_sl].bel03
                        NEXT FIELD bel03
                    END IF
                END IF
            END IF
 
        AFTER FIELD bel04  #廠牌
            IF NOT cl_null(g_bel[l_ac].bel04) THEN
               IF g_bel[l_ac].bel04 != g_bel_t.bel04 OR
                  g_bel_t.bel04 IS NULL THEN
                   SELECT count(*) INTO l_n FROM bel_file
                       WHERE bel01 = g_bel01
                         AND bel02 = g_bel02
                         AND bel011= g_bel011
                         AND bel04 = g_bel[l_ac].bel04
                   IF l_n > 0 THEN
                       CALL cl_err(g_bel[l_ac].bel04,-239,0)
                       LET g_bel[l_ac].bel04 = g_bel_t.bel04
                       #------MOD-5A0095 START----------
                       DISPLAY BY NAME g_bel[l_ac].bel04
                       #------MOD-5A0095 END------------
                       NEXT FIELD bel04
                   END IF
               END IF
               CALL i150_bel04('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_bel[l_ac].bel04=g_bel_t.bel04
                   NEXT FIELD bel04
               END IF
            END IF
 
        AFTER FIELD bel06
            IF NOT cl_null(g_bel[l_ac].bel06) THEN
               SELECT pmc03 INTO g_bel[l_ac].pmc03 FROM pmc_file
                WHERE pmc01=g_bel[l_ac].bel06
               IF STATUS = 100 THEN
         #        CALL cl_err(g_bel[l_ac].bel06,'apm-197',0) #No.TQC-660046
                  CALL cl_err3("sel","pmc_file",g_bel[l_ac].bel06,"","apm-197","","",1)   #No.TQC-660046
                  LET g_bel[l_ac].bel06 = g_bel_t.bel06
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_bel[l_ac].bel06
                  #------MOD-5A0095 END------------
                  NEXT FIELD bel06
               END IF
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_bel[l_ac].pmc03
               #------MOD-5A0095 END------------
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bel_t.bel03 > 0 AND
               g_bel_t.bel03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bel_file
                    WHERE bel01 = g_bel01  AND
                          bel011= g_bel011 AND
                          bel02 = g_bel02  AND
                          bel03 = g_bel_t.bel03
                IF SQLCA.sqlcode THEN
      #             CALL cl_err(g_bel_t.bel03,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","bel_file",g_bel01,g_bel011,SQLCA.sqlcode,"","",1)    #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bel[l_ac].* = g_bel_t.*
               CLOSE i150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bel[l_ac].bel03,-263,1)
                LET g_bel[l_ac].* = g_bel_t.*
            ELSE
                UPDATE bel_file SET
                       bel03=g_bel[l_ac].bel03,
                       bel04=g_bel[l_ac].bel04,
                       bel06=g_bel[l_ac].bel06
                 WHERE bel01 = g_bel01
                   AND bel011= g_bel011
                   AND bel02 = g_bel02
                   AND bel03 = g_bel_t.bel03
                IF SQLCA.sqlcode THEN
             #      CALL cl_err(g_bel[l_ac].bel03,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bel_file",g_bel01,g_bel011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                    LET g_bel[l_ac].* = g_bel_t.*
                    DISPLAY g_bel[l_ac].* TO s_bel[l_sl].*
                ELSE
                    MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bel[l_ac].* = g_bel_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bel.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
          #CKP
          #LET g_bel_t.* = g_bel[l_ac].*          # 900423
            CLOSE i150_bcl
            COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL i150_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bel03) AND l_ac > 1 THEN
                LET g_bel[l_ac].* = g_bel[l_ac-1].*
                DISPLAY g_bel[l_ac].* TO s_bel[l_ac].*
                NEXT FIELD bel03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(bel04)      #廠牌
#                 CALL q_mse(0,0,g_bel[l_ac].bel04) RETURNING g_bel[l_ac].bel04
#                 CALL FGL_DIALOG_SETBUFFER( g_bel[l_ac].bel04 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_mse"
                  LET g_qryparam.default1 = g_bel[l_ac].bel04
                  CALL cl_create_qry() RETURNING g_bel[l_ac].bel04
                 #CALL FGL_DIALOG_SETBUFFER( g_bel[l_ac].bel04 )
                   DISPLAY BY NAME g_bel[l_ac].bel04         #No.MOD-490371
                  NEXT FIELD bel04
             WHEN INFIELD(bel06)
#                 CALL q_pmc(0,0,g_bel[l_ac].bel06) RETURNING g_bel[l_ac].bel06
#                 CALL FGL_DIALOG_SETBUFFER( g_bel[l_ac].bel06 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.default1 = g_bel[l_ac].bel06
                  CALL cl_create_qry() RETURNING g_bel[l_ac].bel06
                 #CALL FGL_DIALOG_SETBUFFER( g_bel[l_ac].bel06 )
                   DISPLAY BY NAME g_bel[l_ac].bel06         #No.MOD-490371
                  NEXT FIELD bel06
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
    CLOSE i150_bcl
	COMMIT WORK
 
END FUNCTION
 
FUNCTION  i150_bel04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
      #-->check 存在於mse_file
      SELECT mse02 INTO g_bel[l_ac].mse02
        FROM mse_file
       WHERE mse01 = g_bel[l_ac].bel04
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2603'
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF NOT cl_null(g_errno) AND p_cmd = 'a' THEN RETURN END IF
      #--->show data
      SELECT bmj10,bmj11,bmj08
       INTO g_bel[l_ac].bmj10,g_bel[l_ac].bmj11,g_bel[l_ac].wdesc
       FROM bmj_file
      WHERE bmj01 = g_bel01 AND bmj02 = g_bel[l_ac].bel04
          IF SQLCA.sqlcode THEN
             LET g_bel[l_ac].bmj10 = ' '
             LET g_bel[l_ac].bmj11 = ' '
             LET g_bel[l_ac].wdesc   = ' '
          END IF
       CASE
       WHEN g_bel[l_ac].wdesc = "0"
            let g_bel[l_ac].wdesc = g_x[20]
       when g_bel[l_ac].wdesc = "1"
            let g_bel[l_ac].wdesc = g_x[21]
       when g_bel[l_ac].wdesc = "2"
            let g_bel[l_ac].wdesc = g_x[22]
       when g_bel[l_ac].wdesc = "3"
            let g_bel[l_ac].wdesc = g_x[23]
       WHEN g_bel[l_ac].wdesc = "4"
            let g_bel[l_ac].wdesc = g_x[24]
       WHEN g_bel[l_ac].wdesc = "X"
            let g_bel[l_ac].wdesc = g_x[25]
       END CASE
END FUNCTION
 
FUNCTION i150_b_askkey()
DEFINE
    l_wc     LIKE type_file.chr1000    #No.FUN-680096  VARCHAR(200)
 
    CONSTRUCT l_wc ON bel03,bel04,bel06             #螢幕上取條件
       FROM s_bel[1].bel03,s_bel[1].bel04,s_bel[1].bel06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i150_b_fill(l_wc)
END FUNCTION
 
FUNCTION i150_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(200)
 
    LET g_sql =
       "SELECT bel03,bel04,'','','','',bel06,'' ",
       " FROM bel_file ",
       " WHERE bel01 = '",g_bel01 ,"' AND bel02 = '",g_bel02,
       "' AND  bel011= '",g_bel011,"' AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i150_prepare2 FROM g_sql      #預備一下
    DECLARE bel_cs CURSOR FOR i150_prepare2
    CALL g_bel.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH bel_cs INTO g_bel[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT mse02 INTO g_bel[g_cnt].mse02
          FROM mse_file
         WHERE mse01 = g_bel[g_cnt].bel04
 
        SELECT pmc03 INTO g_bel[g_cnt].pmc03
          FROM pmc_file
         WHERE pmc01 = g_bel[g_cnt].bel06
 
        # modi by kitty (by 373016)
           SELECT bmj10,bmj11,bmj08
           INTO  g_bel[g_cnt].bmj10,g_bel[g_cnt].bmj11,g_bel[g_cnt].wdesc
           FROM bmj_file
           WHERE bmj01 = g_bel01 AND  bmj02 = g_bel[g_cnt].bel04
           CASE
           WHEN g_bel[g_cnt].wdesc = "0"
                LET g_bel[g_cnt].wdesc = g_x[20]
           WHEN g_bel[g_cnt].wdesc = "1"
                LET g_bel[g_cnt].wdesc = g_x[21]
           WHEN g_bel[g_cnt].wdesc = "2"
                LET g_bel[g_cnt].wdesc = g_x[22]
           WHEN g_bel[g_cnt].wdesc = "3"
                LET g_bel[g_cnt].wdesc = g_x[23]
            WHEN g_bel[g_cnt].wdesc = "4"
                LET g_bel[g_cnt].wdesc = g_x[24]
            WHEN g_bel[g_cnt].wdesc = "X"
                LET g_bel[g_cnt].wdesc = g_x[25]
           END CASE
           LET g_cnt = g_cnt + 1
           # TQC-630105----------start add by Joe
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
           END IF
           # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_bel.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i150_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bel TO s_bel.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
        LET l_ac = ARR_CURR()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i150_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i150_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i150_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i150_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i150_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i150_copy()
DEFINE
    l_oldno1         LIKE bel_file.bel01,
    l_oldno2         LIKE bel_file.bel02,
    l_oldno011       LIKE bel_file.bel011,
    l_newno1         LIKE bel_file.bel01,
    l_newno2         LIKE bel_file.bel02,
    l_newno011       LIKE bel_file.bel011
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bel01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
    INPUT l_newno1,l_newno2,l_newno011  FROM bel01,bel02,bel011
 
        AFTER FIELD bel01
            IF cl_null(l_newno1) THEN
                NEXT FIELD bel01
            ELSE
#FUN-AB0025 ---------mark start---------------
#              #FUN-AA0059 -------------------------add start------------------------
#              IF NOT s_chk_item_no(l_newno1,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 NEXT FIELD bel01 
#              END IF
#              #FUN-AA0059 --------------------------add end-----------------------------   
#FUN-AB0025 ---------mark end-------------------
               SELECT count(*) INTO g_cnt FROM ima_file
                                WHERE ima01 = l_newno1
                                  AND imaacti = 'Y'
                                  AND ima08 IN ('P','V','Z','S')
                  IF g_cnt=0 THEN
                     SELECT count(*) INTO g_cnt FROM bmq_file
                           WHERE bmq01 = l_newno1
                     IF g_cnt= 0 THEN
                        CALL cl_err('bmq_file',100,0)
                        NEXT FIELD bel01
                     END IF
                  END IF
            END IF
	
        AFTER FIELD bel02
            IF cl_null(l_newno2) THEN
                NEXT FIELD bel02
            ELSE
#FUN-AB0025 ----------------mark start----------------
#              #FUN-AA0059 ----------------------add start-----------------------------
#              IF s_chk_item_no(l_newno2,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 NEXT FIELD bel01
#              END IF 
#              #FUN-AA0059 -----------------------add end---------------------------------  
#FUN-AB0025 ----------------mark end--------------------
               SELECT count(*) INTO g_cnt FROM ima_file
                                WHERE ima01 = l_newno2
                                  AND imaacti = 'Y'
                 IF g_cnt = 0 THEN
                    SELECT count(*) INTO g_cnt FROM bmq_file
                          WHERE bmq01 = l_newno2
                    IF g_cnt= 0 THEN
                       CALL cl_err('bmq_file',100,0)
                       NEXT FIELD bel01
                    END IF
                 END IF
            END IF
 
        AFTER FIELD bel011
            SELECT count(*) INTO g_cnt FROM bel_file
             WHERE bel01 = l_newno1
               AND bel02 = l_newno2
               AND bel011= l_newno011
            IF g_cnt > 0 THEN
	        LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',l_newno011
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD bel01
            END IF
            SELECT count(*) INTO g_cnt FROM bmp_file
                WHERE bmp01 = l_newno2 AND bmp011 = l_newno011
                  AND bmp03 = l_newno1
            IF g_cnt = 0 THEN
                LET g_msg=l_newno1 CLIPPED,'+',l_newno011 CLIPPED,'+',
                          l_newno2 CLIPPED
                CALL cl_err(g_msg,'abm-007',0)
                NEXT FIELD bel01
            END IF
#TQC-790103--start---
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bel01)
                     CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_bmp03"    #No.TQC-AB0074
                     LET g_qryparam.form = "q_bmp3"     #No.TQC-AB0074
                     LET g_qryparam.default1 = l_newno1
                     CALL cl_create_qry() RETURNING l_newno1
                     DISPLAY l_newno1 TO bel01
                     CALL i150_bel01('d')
                     NEXT FIELD bel01
                WHEN INFIELD(bel02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmo"   
                     LET g_qryparam.default1 = l_newno2
                     CALL cl_create_qry() RETURNING l_newno2,l_newno011     
        	     IF l_newno2 IS NULL THEN
		         LET l_newno2= l_oldno2
         	     END IF
                     DISPLAY l_newno2,l_newno011 TO bel02,bel011     
                     CALL i150_bel02('d')
                     NEXT FIELD bel02
                WHEN INFIELD(bel011) #料件主檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmo1"
                     LET g_qryparam.default1 = l_newno011
                     LET g_qryparam.construct = "N"
                     IF NOT cl_null(l_newno011) THEN
                        LET g_qryparam.where = " bmo01 = '",l_newno2,"'"
                     END IF
                     CALL cl_create_qry() RETURNING l_newno011
                     DISPLAY l_newno011 TO bel011
                     NEXT FIELD bel011
                OTHERWISE
            END CASE
#TQC-790103--end---
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
    IF INT_FLAG OR l_newno1 IS NULL THEN
        LET INT_FLAG = 0
    	CALL i150_show()
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM bel_file
        WHERE bel01=g_bel01
          AND bel02=g_bel02
          AND bel011=g_bel011
        INTO TEMP x
    UPDATE x
        SET bel01 =l_newno1,    #資料鍵值
            bel011=l_newno011,
    	    bel02 =l_newno2
    INSERT INTO bel_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
  #     CALL cl_err(g_bel01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("ins","bel_file",g_bel01,g_bel02,SQLCA.sqlcode,"","",1)   #No.TQC-660046
    ELSE
	LET g_msg = l_newno1 CLIPPED, '+', l_newno2 CLIPPED,'+',l_newno011
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno1 = g_bel01
        LET l_oldno2 = g_bel02
        LET l_oldno011 = g_bel011
        LET g_bel01 = l_newno1
        LET g_bel02 = l_newno2
        LET g_bel011 = l_newno011
	IF g_chkey = 'Y' THEN CALL i150_u() END IF
        CALL i150_b()
        #FUN-C30027---begin
        #LET g_bel01 = l_oldno1
        #LET g_bel02 = l_oldno2
        #LET g_bel011= l_oldno011
        #CALL i150_show()
        #FUN-C30027---end
    END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
