# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi184.4gl
# Descriptions...: 車輛加油記錄維護作業
# Date & Author..: 03/12/03 By Leagh
# Modify.........: No.MOD-4A0336 04/10/29 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 By Elva 將變數用Like方式定義,調整報表
# Modify.........: No.FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: NO.FUN-660104 06/06/16 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改g_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710043 07/01/11 By Rayven 在單身修改并保存后，系統提示錯誤
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/07/18 By mike 報表格式修改為p_query
# Modify.........: No.TQC-7A0033 07/10/12 By Mandy informix區r.c2不過
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.TQC-940076 09/05/08 By mike 新增時，如ado07不輸，則會報更新失敗的錯 
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C50005 12/05/03 By fanbj 複製完后單身會不見
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	g_ado01         LIKE ado_file.ado01,   #料件編號
	g_ado01_t       LIKE ado_file.ado01,   #
	g_ado02         LIKE ado_file.ado02,   #廠商編號
	g_ado02_t       LIKE ado_file.ado02,   #
	g_ado           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
			ado03       LIKE ado_file.ado03,
			ado04       LIKE ado_file.ado04,
			ado05       LIKE ado_file.ado05,
			ado06       LIKE ado_file.ado06,
			gen02       LIKE gen_file.gen02,
			ado07       LIKE ado_file.ado07,
			adoacti     LIKE ado_file.adoacti
			END RECORD,
	g_ado_t         RECORD                 #程式變數 (舊值)
			ado03       LIKE ado_file.ado03,
			ado04       LIKE ado_file.ado04,
			ado05       LIKE ado_file.ado05,
			ado06       LIKE ado_file.ado06,
			gen02       LIKE gen_file.gen02,
			ado07       LIKE ado_file.ado07,
			adoacti     LIKE ado_file.adoacti
			END RECORD,
	l_flag              LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
	g_delete            LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
	g_wc,g_sql      STRING,    #TQC-630166
	g_rec_b         LIKE type_file.num5,              #單身筆數     #No.FUN-680120 SMALLINT
	l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5      #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp      STRING   #No.TQC-720019
DEFINE g_cnt          LIKE type_file.num10       #No.FUN-680120 INTEGER
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000     #No.FUN-680120 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE g_no_ask       LIKE type_file.num5         #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
    OPTIONS
 INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    INITIALIZE g_ado_t.* TO NULL
    LET g_forupd_sql=" SELECT * FROM ado_file",
                     "   WHERE ado01 = ?  AND ado02 = ?",
                     "    FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i184_crl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i184_w WITH FORM "atm/42f/atmi184"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL g_x.clear()
 
    CALL i184_menu()
    CLOSE WINDOW i184_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
 
#QBE 查詢資料
FUNCTION i184_cs()
 DEFINE  l_pmh03   LIKE pmh_file.pmh03
    CLEAR FORM                             #清除畫面
    CALL g_ado.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_ado01 TO NULL    #No.FUN-750051
   INITIALIZE g_ado02 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON ado01,ado02,ado03,ado04,ado05,ado06,
                      ado07,adoacti     #螢幕上取條件
                 FROM ado01,ado02,ado03,s_ado[1].ado04,s_ado[1].ado05,
	     	      s_ado[1].ado06,s_ado[1].ado07,s_ado[1].adoacti
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
	    CASE
               WHEN INFIELD(ado01)
		  #LET g_qryparam.state = 'c' #FUN-980030
		  #LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		  #CALL q_obw01(0,0,g_ado01) RETURNING g_ado01
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_obw01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ado01
                  NEXT FIELD ado01
               WHEN INFIELD(ado06)
          	  #LET g_qryparam.state = 'c' #FUN-980030
          	  #LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
          	  #CALL q_gen(0,0,g_ado[l_ac].ado06) RETURNING g_ado[l_ac].ado06
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ado[1].ado06
                  NEXT FIELD ado06
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
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN  RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
	#	LET g_wc = g_wc clipped," AND adouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
	#	LET g_wc = g_wc clipped," AND adogrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
	#	LET g_wc = g_wc clipped," AND adogrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('adouser', 'adogrup')
    #End:FUN-980030
 
    LET g_sql= "SELECT UNIQUE ado01,ado02 FROM ado_file ",
	       " WHERE ", g_wc CLIPPED,
	       " ORDER BY ado01,ado02 "
    PREPARE i184_prepare FROM g_sql      #預備一下
    DECLARE i184_b_cs                  #宣告成可捲動的
	SCROLL CURSOR WITH HOLD FOR i184_prepare
 
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE z
#   LET g_sql=" SELECT UNIQUE ado01,ado02 ",      #No.TQC-720019
    LET g_sql_tmp=" SELECT UNIQUE ado01,ado02 ",  #No.TQC-720019
	      "   FROM ado_file WHERE ", g_wc CLIPPED ,
              " INTO TEMP z "
#   PREPARE i184_COUNT_pre FROM g_sql      #No.TQC-720019
    PREPARE i184_COUNT_pre FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i184_COUNT_pre
    LET g_sql="SELECT COUNT(*) FROM z "
    PREPARE i184_pre_COUNT FROM g_sql
    DECLARE i184_COUNT CURSOR FOR i184_pre_COUNT
   OPEN i184_count
   FETCH i184_count INTO g_row_count
   CLOSE i184_count
END FUNCTION
 
#中文的MENU
FUNCTION i184_menu()
 DEFINE     l_cmd     STRING     #No.FUN-780056
   WHILE TRUE
      CALL i184_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i184_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i184_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i184_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i184_r()
            END IF
         WHEN "reproduce"
          IF cl_chk_act_auth() THEN
               CALL i184_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i184_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i184_out()                                      #No.FUN-780056  
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF           #No.FUN-780056
               LET l_cmd = 'p_query "atmi184" "',g_wc CLIPPED,'"'    #No.FUN-780056    
               CALL cl_cmdrun(l_cmd)                                 #No.FUN-780056    
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ado01 IS NOT NULL THEN
                LET g_doc.column1 = "ado01"
                LET g_doc.column2 = "ado02"
                LET g_doc.value1 = g_ado01
                LET g_doc.value2 = g_ado02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i184_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_ado.clear()
 
    INITIALIZE g_ado01 LIKE  ado_file.ado01
    INITIALIZE g_ado02 LIKE  ado_file.ado02
    LET g_ado01_t  = NULL
    LET g_ado02_t  = NULL
    CALL cl_opmsg('a')
    LET g_ado02 = g_today
    WHILE TRUE
	CALL i184_i("a")                   #輸入單頭
	IF INT_FLAG THEN                   #使用者不玩了
	    LET g_ado01=NULL
	    LET INT_FLAG = 0
	    CALL cl_err('',9001,0)
	    EXIT WHILE
	END IF
        CALL g_ado.clear()
        LET g_rec_b=0
	CALL i184_b()                   #輸入單身
	LET g_ado01_t = g_ado01
	LET g_ado02_t = g_ado02
	EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i184_u()
    DEFINE  l_buf      LIKE nma_file.nma04        #No.FUN-680120 VARCHAR(30)
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ado01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ado01_t = g_ado01
    LET g_ado02_t = g_ado02
    BEGIN WORK
    WHILE TRUE
        CALL i184_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_ado01=g_ado01_t
            DISPLAY g_ado01 TO ado01               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ado_file SET ado01 = g_ado01, ado02 = g_ado02
         WHERE ado01 = g_ado01_t AND ado02 = g_ado02_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ado01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","ado_file",g_ado01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i184_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
    l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_str           LIKE ima_file.ima01           #No.FUN-680120 VARCHAR(40)
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT g_ado01,g_ado02 WITHOUT DEFAULTS FROM ado01,ado02 HELP 1
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i184_set_entry(p_cmd)
            CALL i184_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
	AFTER FIELD ado01
	    IF NOT cl_null(g_ado01) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_ado01 != g_ado01_t) THEN
  	          CALL i184_ado01(g_ado01)
	          IF NOT cl_null(g_errno) THEN
	             CALL cl_err(g_ado01,g_errno,0)
	             NEXT FIELD ado01
	          END IF
	       END IF
	    END IF
 
	AFTER FIELD ado02
	    IF NOT cl_null(g_ado02) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND (g_ado01 != g_ado01_t OR
                                   g_ado02 != g_ado02_t)) THEN
                  SELECT COUNT(*) INTO l_n FROM ado_file
                   WHERE ado01 = g_ado01 AND ado02 = g_ado02
                  IF l_n > 0 THEN
                     CALL cl_err(g_ado02,-239,0)
	             NEXT FIELD ado02
                  END IF
               END IF
            END IF
 
       ON ACTION CONTROLP
	    CASE
               WHEN INFIELD(ado01)
		  #LET g_qryparam.state = 'c' #FUN-980030
		  #LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		  #CALL q_obw01(0,0,g_ado01) RETURNING g_ado01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_obw01"
                  LET g_qryparam.default1 = g_ado01
                  CALL cl_create_qry() RETURNING g_ado01
                  DISPLAY BY NAME g_ado01 #ATTRIBUTE(YELLOW)   #TQC-8C0076
                  NEXT FIELD ado01
            END CASE
 
        ON ACTION CONTROLF                 #欄位說明
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
END FUNCTION
 
FUNCTION i184_ado01(p_ado01)
  DEFINE l_obw01   LIKE obw_file.obw01,
         l_obwacti LIKE obw_file.obwacti,
         p_ado01   LIKE ado_file.ado01
 
     LET g_errno = ' '
     SELECT obw01,obwacti INTO l_obw01,l_obwacti
       FROM obw_file
      WHERE obw01=p_ado01
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='axd-010'
         WHEN l_obwacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
END FUNCTION
 
#Query 查詢
FUNCTION i184_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ado01 TO NULL              #NO.FUN-6B0043
    INITIALIZE g_ado02 TO NULL              #NO.FUN-6B0043
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ado.clear()
 
    CALL i184_cs()                          #取得查詢條件
 
    IF INT_FLAG THEN                        #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_ado01 TO NULL
        INITIALIZE g_ado02 TO NULL
        RETURN
    END IF
--mi
    OPEN i184_count
    FETCH i184_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
--#
    OPEN i184_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ado01 TO NULL
        INITIALIZE g_ado02 TO NULL
    ELSE
        CALL i184_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i184_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i184_b_cs INTO g_ado01,g_ado02
        WHEN 'P' FETCH PREVIOUS i184_b_cs INTO g_ado01,g_ado02
        WHEN 'F' FETCH FIRST    i184_b_cs INTO g_ado01,g_ado02
        WHEN 'L' FETCH LAST     i184_b_cs INTO g_ado01,g_ado02
        WHEN '/'
            IF (NOT g_no_ask) THEN  #No.FUN-6A0072
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i184_b_cs INTO g_ado01,g_ado02
            LET g_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_ado01,SQLCA.sqlcode,0)
        INITIALIZE g_ado01 TO NULL  #TQC-6B0105
        INITIALIZE g_ado02 TO NULL  #TQC-6B0105
    ELSE
       CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL i184_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i184_show()
    DISPLAY g_ado01 TO ado01               #單頭
    DISPLAY g_ado02 TO ado02               #單頭
 #    CALL i184_gen02('d')   #MOD-4A0336             #單身
    CALL i184_b_fill(g_wc)              #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i184_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_ado01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0043
       RETURN 
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ado01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ado02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ado01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ado02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM ado_file WHERE ado01 = g_ado01 AND ado02 = g_ado02
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("del","ado_file",g_ado01,g_ado02,SQLCA.sqlcode,
                         "","BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            CALL g_ado.clear()
--mi
         DROP TABLE z                            #No.TQC-720019
         PREPARE i184_COUNT_pre2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i184_COUNT_pre2                 #No.TQC-720019
         OPEN i184_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i184_b_cs
            CLOSE i184_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i184_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i184_b_cs
            CLOSE i184_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i184_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i184_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE   #No.FUN-6A0072
            CALL i184_fetch('/')
         END IF
--#
            LET g_cnt=SQLCA.SQLERRD[3]
            LET g_delete = 'Y'
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
    COMMIT WORK
END FUNCTION
#單身
FUNCTION i184_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680120 SMALLINT
    l_no            LIKE type_file.num5,                #No.FUN-680120 SMALLINT            #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680120 VARCHAR(1)
    l_str           LIKE bnb_file.bnb06,             #                      #No.FUN-680120 VARCHAR(20)   
    l_acti          LIKE pmh_file.pmhacti,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0)  THEN RETURN END IF
    IF g_ado01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql="SELECT ado03,ado04,ado05,ado06,' ',ado07,adoacti",
                     "  FROM ado_file",
                     "  WHERE ado01 = ?  AND ado02 = ?",
                     "   AND ado03 = ?",
                     "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i184_b_cl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ado WITHOUT DEFAULTS FROM s_ado.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_ado_t.* = g_ado[l_ac].*
               OPEN i184_b_cl USING g_ado01,g_ado02,g_ado_t.ado03
               IF STATUS THEN
                  CALL cl_err("OPEN i184_b_cl:", STATUS, 1)
                  CLOSE i184_b_cl
                  ROLLBACK WORK
                  RETURN
               END IF
 
               FETCH i184_b_cl INTO g_ado[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ado_t.ado04,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               CALL i184_gen02('d')                #單身
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ado[l_ac].* TO NULL      #900423
            LET g_ado_t.* = g_ado[l_ac].*         #新輸入資料
            SELECT obw16 INTO g_ado[l_ac].ado06 FROM obw_file
             WHERE obw01 = g_ado01
            LET g_ado[l_ac].adoacti = 'Y'
            LET g_ado[l_ac].ado04 = 0
            LET g_ado[l_ac].ado05 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ado03
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ado_file(ado01,ado02,ado03,ado04,ado05,
                                 ado06,ado07,adoacti,adouser,
                                 adogrup,adomodu,adodate,
                                 adoplant,adolegal,adooriu,adoorig) #FUN-980009
            VALUES(g_ado01,g_ado02,g_ado[l_ac].ado03,
                   g_ado[l_ac].ado04,g_ado[l_ac].ado05,
                   g_ado[l_ac].ado06,g_ado[l_ac].ado07,
                   g_ado[l_ac].adoacti,g_user,g_grup,'',g_today,
                   g_plant,g_legal, g_user, g_grup)                 #FUN-980009      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ado[l_ac].ado03,SQLCA.sqlcode,0)  #No.FUN-660104
                CALL cl_err3("ins","ado_file",g_ado[l_ac].ado03,"",SQLCA.sqlcode,
                             "","",1)  #No.FUN-660104
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
 
        BEFORE FIELD ado03                        # dgeeault 序號
            IF cl_null(g_ado[l_ac].ado03) OR g_ado[l_ac].ado03 = 0 THEN
               SELECT max(ado03)+1 INTO g_ado[l_ac].ado03 FROM ado_file
                WHERE ado01 = g_ado01 AND ado02 = g_ado02
               IF g_ado[l_ac].ado03 IS NULL THEN
                  LET g_ado[l_ac].ado03 = 1
               END IF
            END IF
 
        AFTER FIELD ado03                        #check 序號是否重複
            IF NOT cl_null(g_ado[l_ac].ado03) AND
               (g_ado[l_ac].ado03 != g_ado_t.ado03 OR
                g_ado_t.ado03 IS NULL) THEN
                LET l_no = 0
                SELECT COUNT(*) INTO l_no FROM ado_file
                 WHERE ado01 = g_ado01 AND ado02 = g_ado02
                   AND ado03 = g_ado[l_ac].ado03
                IF l_no > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ado[l_ac].ado03 = g_ado_t.ado03
                    NEXT FIELD ado03
                END IF
            END IF
 
        AFTER FIELD ado04
           IF NOT cl_null(g_ado[l_ac].ado04) THEN
              IF g_ado[l_ac].ado04 < 0 THEN
                 NEXT FIELD ado04
              END IF
           END IF
 
        AFTER FIELD ado05
           IF NOT cl_null(g_ado[l_ac].ado05) THEN
              IF g_ado[l_ac].ado05 < 0 THEN
                 NEXT FIELD ado05
              END IF
           END IF
 
        AFTER FIELD ado06
           IF NOT cl_null(g_ado[l_ac].ado06) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_ado[l_ac].ado06 != g_ado_t.ado06) THEN
                 CALL i184_gen02('d')                #單身
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ado[l_ac].ado06,g_errno,0)
                    NEXT FIELD ado06
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ado_t.ado03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ado_file
                 WHERE ado01 = g_ado01 AND ado02 = g_ado02
                   AND ado03 = g_ado_t.ado03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_ado_t.ado04,SQLCA.sqlcode,0)  #No.FUN-660104
                    CALL cl_err3("del","ado_file",g_ado_t.ado03,"",SQLCA.sqlcode,
                                 "","",1)  #No.FUN-660104
 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
             END IF
             COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ado[l_ac].* = g_ado_t.*
               CLOSE i184_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ado[l_ac].ado04,-263,1)
               LET g_ado[l_ac].* = g_ado_t.*
            ELSE
               UPDATE ado_file SET(ado03,ado04,ado05,ado06,ado07,
                                   adoacti,adouser,adomodu)
                           =(g_ado[l_ac].ado03,g_ado[l_ac].ado04,
                             g_ado[l_ac].ado05,g_ado[l_ac].ado06,
                             g_ado[l_ac].ado07,g_ado[l_ac].adoacti,
                             g_user,g_today)
                WHERE CURRENT OF i184_b_cl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ado[l_ac].ado03,SQLCA.sqlcode,0)  #No.FUN-660104
                   CALL cl_err3("upd","ado_file",g_ado[l_ac].ado03,"",
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   LET g_ado[l_ac].* = g_ado_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
    AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ado[l_ac].* = g_ado_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_ado.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i184_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30033 add
            CLOSE i184_b_cl
            COMMIT WORK
 
       ON ACTION CONTROLP
            CASE
                 WHEN INFIELD(ado06)
          	    #LET g_qryparam.state = 'c' #FUN-980030
          	    #LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
          	    #CALL q_gen(0,0,g_ado[l_ac].ado06)
                    #     RETURNING g_ado[l_ac].ado06
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_ado[l_ac].ado06
                    CALL cl_create_qry() RETURNING g_ado[l_ac].ado06
#                    CALL FGL_DIALOG_SETBUFFER( g_ado[l_ac].ado06 )
                    NEXT FIELD ado06
            END CASE
 
        ON ACTION CONTROLN
            CALL i184_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(ado04) AND l_ac > 1 THEN
                LET g_ado[l_ac].* = g_ado[l_ac-1].*
                NEXT FIELD ado03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END               
 
        END INPUT
 
    #FUN-5B0113-begin
     UPDATE ado_file SET adomodu = g_user,adodate = g_today
      WHERE ado01 = g_ado01
        AND ado02 = g_ado02
       #AND ado03 = g_ado[l_ac].ado03 #TQC-940076    
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN  #No.TQC-710043 ora里將SQLCA.SQLERRD[3] = 0替換成了STATUS = 0了，現已修改ora
#       CALL cl_err('upd ado',SQLCA.SQLCODE,1)  #No.FUN-660104
        CALL cl_err3("upd","ado_file",g_ado01,g_ado02,
                      SQLCA.sqlcode,"","upd ado",1)  #No.FUN-660104
     END IF
    #FUN-5B0113-end
 
    CLOSE i184_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i184_gen02(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file
   WHERE gen01 = g_ado[l_ac].ado06
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_ado[l_ac].gen02 = l_gen02
    END IF
END FUNCTION
 
FUNCTION i184_b_askkey()
DEFINE
    #l_wc            LIKE type_file.chr1000  #TQC-630166        #No.FUN-680120 VARCHAR(200)
    l_wc            STRING    #TQC-630166
 
    CONSTRUCT l_wc ON ado03,ado04,ado05,ado06,ado07,adoacti    #螢幕上取條件
                 FROM s_ado[1].ado03,s_ado[1].ado04,s_ado[1].ado05,
                      s_ado[1].ado06,s_ado[1].ado07,s_ado[1].adoacti
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
	    CASE
               WHEN INFIELD(ado06)
          	  #LET g_qryparam.state = 'c' #FUN-980030
          	  #LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
          	  #CALL q_gen(0,0,g_ado[l_ac].ado06) RETURNING g_ado[l_ac].ado06
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ado[1].ado06
                  NEXT FIELD ado06
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
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i184_b_fill(l_wc)
END FUNCTION
 
FUNCTION i184_b_fill(p_wc)              #BODY FILL UP
DEFINE
    #p_wc            LIKE type_file.chr1000  #TQC-630166        #No.FUN-680120
    p_wc            STRING   #TQC-630166
   
    #TQC-C50005--start add ----------------------------------
    IF cl_null(p_wc) THEN
       LET p_wc = ' 1=1'
    END IF   
    #TQC-C50005--end add-------------------------------------
 
    LET g_sql =
       "SELECT ado03,ado04,ado05,ado06,gen02,ado07,adoacti",
        "  FROM ado_file,OUTER gen_file ",    #NO.MOD-4B0067
       " WHERE ado01 = '",g_ado01,"'",
       "   AND ado02 = '",g_ado02,"'",
        "   AND ado_file.ado06=gen_file.gen01 AND ",p_wc CLIPPED ,#NO.MOD-4B0067
       " ORDER BY ado03"
    PREPARE i184_prepare2 FROM g_sql      #預備一下
    DECLARE ado_cs CURSOR FOR i184_prepare2
 
    CALL g_ado.clear()
    LET g_cnt = 1
    FOREACH ado_cs INTO g_ado[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ado.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i184_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ado TO s_ado.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
--mi
      BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)
--#
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END         
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i184_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i184_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i184_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i184_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i184_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i184_copy()
DEFINE l_newno1,l_oldno1  LIKE ado_file.ado01,
       l_newno2,l_oldno2  LIKE ado_file.ado02,
       l_n                LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ado01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i184_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno1,l_newno2 FROM ado01,ado02
        AFTER FIELD ado01
            IF cl_null(l_newno1) THEN
                NEXT FIELD ado01
            END IF
            CALL i184_ado01(l_newno1)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_newno1,g_errno,0)
               NEXT FIELD ado01
            END IF
 
        AFTER FIELD ado02
            IF cl_null(l_newno2) THEN NEXT FIELD ado02 END IF
            SELECT COUNT(*) INTO l_n FROM ado_file
             WHERE ado01 = l_newno1 AND ado02 = l_newno2
            IF l_n > 0 THEN
               CALL cl_err(l_newno2,-239,0)
               NEXT FIELD ado02
            END IF
 
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ado01)
                  #CALL q_obw01(0,0,l_newno1) RETURNING l_newno1
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_obw01"
                  LET g_qryparam.default1 = l_newno1
                  CALL cl_create_qry() RETURNING l_newno1
                  DISPLAY l_newno1 TO ado01 #ATTRIBUTE(YELLOW)   #TQC-8C0076
                  NEXT FIELD ado01
            END CASE
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
       DISPLAY g_ado01 TO ado01  #ATTRIBUTE(YELLOW)   #TQC-8C0076
       DISPLAY g_ado02 TO ado02  #ATTRIBUTE(YELLOW)   #TQC-8C0076
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM ado_file         #單身複製
        WHERE g_ado01=ado01 AND g_ado02 = ado02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_ado01 CLIPPED,'+',g_ado02
#      CALL cl_err(g_msg,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("ins","x",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    UPDATE x
        SET ado01 = l_newno1,
            ado02 = l_newno2
    INSERT INTO ado_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = l_newno1 CLIPPED,'+',l_newno2
#      CALL cl_err(g_msg,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("ins","ado_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
     LET l_oldno1= g_ado01
     LET l_oldno2= g_ado02
     LET g_ado01=l_newno1
     LET g_ado02=l_newno2
     CALL i184_b()
     #LET g_ado01=l_oldno1  #FUN-C80046
     #LET g_ado02=l_oldno2  #FUN-C80046
     #CALL i184_show()      #FUN-C80046
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i184_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    sr              RECORD
        ado01       LIKE ado_file.ado01,
        ado02       LIKE ado_file.ado02,
        ado03       LIKE ado_file.ado03,
        ado04       LIKE ado_file.ado04,
        ado05       LIKE ado_file.ado05,
        ado06       LIKE ado_file.ado06,
        gen02       LIKE gen_file.gen02,
        ado07       LIKE ado_file.ado07,
        adoacti     LIKE ado_file.adoacti
                    END RECORD,
    l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)             #External(Disk) file name
     l_za05          LIKE za_file.za05      #NO.MOD-4B0067
 
    IF cl_null(g_wc) AND NOT cl_null(g_ado01)  AND NOT cl_null(g_ado02)
       AND NOT cl_null(g_ado[l_ac].ado03) THEN
       LET g_wc = " ado01 = '",g_ado01,"' AND ado02 = '",g_ado02,"' AND ado03 = '",g_ado[l_ac].ado03,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('atmi184') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ado01,ado02,ado03,ado04,ado05,ado06,gen02,ado07,adoacti",
              "  FROM ado_file ,OUTER gen_file ",  # 組合出 SQL 指令
              " WHERE ado06=gen_file.gen01 AND ",g_wc CLIPPED,
              "   AND adoacti = 'Y' ",
              " ORDER BY ado01,ado02 "
    PREPARE i184_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i184_co                         # CURSOR
        CURSOR FOR i184_p1
 
    START REPORT i184_rep TO l_name
    FOREACH i184_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i184_rep(sr.*)
    END FOREACH
    FINISH REPORT i184_rep
    CLOSE i184_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i184_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    sr              RECORD
        ado01       LIKE ado_file.ado01,
        ado02       LIKE ado_file.ado02,
        ado03       LIKE ado_file.ado03,
        ado04       LIKE ado_file.ado04,
        ado05       LIKE ado_file.ado05,
        ado06       LIKE ado_file.ado06,
        gen02       LIKE gen_file.gen02,
        ado07       LIKE ado_file.ado07,
        adoacti     LIKE ado_file.adoacti
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ado01,sr.ado02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],
                  g_x[35],g_x[36],g_x[37],g_x[38]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 #MOD-4B0067  --begin
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.ado01 CLIPPED;
            PRINT COLUMN g_c[32],sr.ado02 CLIPPED;
 #MOD-4B0067  --end
            PRINT COLUMN g_c[33],sr.ado03 USING '###&', #FUN-590118 #TQC-7A0033
                  COLUMN g_c[34],sr.ado04 USING '###,###,##&.&&&',
                  COLUMN g_c[35],cl_numfor(sr.ado05,35,t_azi04),
                  COLUMN g_c[36],sr.ado06 CLIPPED,
                  COLUMN g_c[37],sr.gen02 CLIPPED,
                  COLUMN g_c[38],sr.ado07 CLIPPED
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc,'ado01,ado02,ado03,ado04')
                    RETURNING g_sql
               #TQC-630166
               #PRINT g_dash[1,g_len]
               #IF g_sql[001,080] > ' ' THEN
	       #PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
	       #PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
	       #PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
               PRINT g_dash[1,g_len]
               CALL cl_prt_pos_wc(g_sql)               
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056 -end
 
FUNCTION i184_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ado01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i184_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ado01",FALSE)
       END IF
   END IF
 
END FUNCTION
