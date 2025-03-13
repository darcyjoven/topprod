# Prog. Version..: '5.10.00-08.01.04(00000)'     #
# Pattern name...: axdi119.4gl
# Descriptions...: 車輛加油記錄維護作業
# Input parameter:
# Date & Author..: 2003/12/03 By Leagh
# Modify.........: No:MOD-4A0336 04/10/29 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 By Elva 將變數用Like方式定義,調整報表
# Modify.........: No:FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-660099 06/06/21 By Mandy TQC-630166的MARK不要用{}改用#
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

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
	l_flag          LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
	g_delete        LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
	#g_wc,g_sql     LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(300)  #TQC-630166
	g_wc,g_sql      STRING ,    #TQC-630166 
	g_rec_b         LIKE type_file.num5,   #單身筆數             #No.FUN-680108 SMALLINT
	l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
#       l_time	LIKE type_file.chr8              #No.FUN-6A0091
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-680108 SMALLINT 
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680108 SMALLINT
#主程式開始
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE g_sql_tmp        STRING   #No.TQC-720019

DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680108 SMALLINT    #No.FUN-6A0078

MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0091

    OPTIONS
	FORM LINE     FIRST + 2,
	MESSAGE LINE  LAST,
	PROMPT LINE   LAST,
	INPUT NO WRAP
    DEFER INTERRUPT
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
    INITIALIZE g_ado_t.* TO NULL
    LET g_forupd_sql=" SELECT * FROM ado_file",
                     "  WHERE ado01 = ? AND ado02 = ?",
                     "    FOR UPDATE NOWAIT"
    DECLARE i119_crl CURSOR FROM g_forupd_sql

    LET p_row = 6 LET p_col = 10

 OPEN WINDOW i119_w AT p_row,p_col
	WITH FORM "axd/42f/axdi119" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
--##
    CALL g_x.clear()
--##

    CALL i119_menu()
    CLOSE WINDOW i119_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN


#QBE 查詢資料
FUNCTION i119_cs()
 DEFINE  l_pmh03   LIKE pmh_file.pmh03
    CLEAR FORM                             #清除畫面
    CALL g_ado.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_ado01 TO NULL    #No.FUN-750051
   INITIALIZE g_ado02 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON ado01,ado02,ado03,ado04,ado05,ado06,
                      ado07,adoacti     #螢幕上取條件
                 FROM ado01,ado02,ado03,s_ado[1].ado04,s_ado[1].ado05,
	     	      s_ado[1].ado06,s_ado[1].ado07,s_ado[1].adoacti

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON ACTION CONTROLP
	    CASE
               WHEN INFIELD(ado01)
		  #CALL q_obw01(0,0,g_ado01) RETURNING g_ado01
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_obw01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ado01
                  NEXT FIELD ado01
               WHEN INFIELD(ado06)
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN  RETURN END IF
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
	LET g_wc = g_wc clipped," AND adouser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
	LET g_wc = g_wc clipped," AND adogrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
	LET g_wc = g_wc clipped," AND adogrup IN ",cl_chk_tgrup_list()
    END IF

    LET g_sql= "SELECT UNIQUE ado01,ado02 FROM ado_file ",
	       " WHERE ", g_wc CLIPPED,
	       " ORDER BY ado01,ado02 "
    PREPARE i119_prepare FROM g_sql      #預備一下
    DECLARE i119_b_cs                  #宣告成可捲動的
	SCROLL CURSOR WITH HOLD FOR i119_prepare

    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE z
#   LET g_sql=" SELECT UNIQUE ado01,ado02 ",      #No.TQC-720019
    LET g_sql_tmp=" SELECT UNIQUE ado01,ado02 ",  #No.TQC-720019
	      "   FROM ado_file WHERE ", g_wc CLIPPED ,
              " INTO TEMP z "
#   PREPARE i119_COUNT_pre FROM g_sql      #No.TQC-720019
    PREPARE i119_COUNT_pre FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i119_COUNT_pre
    LET g_sql="SELECT COUNT(*) FROM z "
    PREPARE i119_pre_COUNT FROM g_sql
    DECLARE i119_COUNT CURSOR FOR i119_pre_COUNT
   OPEN i119_count
   FETCH i119_count INTO g_row_count
   CLOSE i119_count
END FUNCTION

#中文的MENU
FUNCTION i119_menu()
   WHILE TRUE
      CALL i119_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i119_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i119_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i119_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i119_r()
            END IF
         WHEN "reproduce"
          IF cl_chk_act_auth() THEN
               CALL i119_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i119_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i119_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No:FUN-6A0165-------add--------str----
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
         #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION

FUNCTION i119_a()
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
	CALL i119_i("a")                   #輸入單頭
	IF INT_FLAG THEN                   #使用者不玩了
	    LET g_ado01=NULL
	    LET INT_FLAG = 0
	    CALL cl_err('',9001,0)
	    EXIT WHILE
	END IF
        CALL g_ado.clear()
        LET g_rec_b=0
	CALL i119_b()                   #輸入單身
	LET g_ado01_t = g_ado01
	LET g_ado02_t = g_ado02
	EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i119_u()
    DEFINE  l_buf     LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(30)

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ado01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ado01_t = g_ado01
    LET g_ado02_t = g_ado02
    BEGIN WORK
    WHILE TRUE
        CALL i119_i("u")                      #欄位更改
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
            CALL cl_err(g_ado01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION

FUNCTION i119_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改   #No.FUN-680108 VARCHAR(1)
    l_n             LIKE type_file.num5,    #No.FUN-680108 SMALLINT
    l_str           LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(40)
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT g_ado01,g_ado02 WITHOUT DEFAULTS FROM ado01,ado02 HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i119_set_entry(p_cmd)
            CALL i119_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE

	AFTER FIELD ado01
	    IF NOT cl_null(g_ado01) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_ado01 != g_ado01_t) THEN
  	          CALL i119_ado01(g_ado01)
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
		  #CALL q_obw01(0,0,g_ado01) RETURNING g_ado01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_obw01"
                  LET g_qryparam.default1 = g_ado01
                  CALL cl_create_qry() RETURNING g_ado01
                  DISPLAY BY NAME g_ado01 ATTRIBUTE(YELLOW)
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

FUNCTION i119_ado01(p_ado01)
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
FUNCTION i119_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ado01 TO NULL             #No.FUN-6A0165 
    INITIALIZE g_ado02 TO NULL             #No.FUN-6A0165

    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ado.clear()

    CALL i119_cs()                         #取得查詢條件

    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_ado01 TO NULL
        INITIALIZE g_ado02 TO NULL
        RETURN
    END IF
--mi
    OPEN i119_count
    FETCH i119_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
--#
    OPEN i119_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ado01 TO NULL
        INITIALIZE g_ado02 TO NULL
    ELSE
        CALL i119_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i119_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #處理方式    #No.FUN-680108 VARCHAR(1)
    l_abso          LIKE type_file.num10    #絕對的筆數  #No.FUN-680108 INTEGER

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i119_b_cs INTO g_ado01,g_ado02
        WHEN 'P' FETCH PREVIOUS i119_b_cs INTO g_ado01,g_ado02
        WHEN 'F' FETCH FIRST    i119_b_cs INTO g_ado01,g_ado02
        WHEN 'L' FETCH LAST     i119_b_cs INTO g_ado01,g_ado02
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
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
            FETCH ABSOLUTE g_jump i119_b_cs INTO g_ado01,g_ado02
            LET mi_no_ask = FALSE   #No.FUN-6A0078
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
      CALL i119_show()
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i119_show()
    DISPLAY g_ado01 TO ado01               #單頭
    DISPLAY g_ado02 TO ado02               #單頭
 #    CALL i119_gen02('d')   #MOD-4A0336             #單身
    CALL i119_b_fill(g_wc)              #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i119_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_ado01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0165
       RETURN 
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM ado_file WHERE ado01 = g_ado01 AND ado02 = g_ado02
        IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
        ELSE
            CLEAR FORM
            CALL g_ado.clear()
            DROP TABLE z                             #No.TQC-720019
            PREPARE i119_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i119_precount_x2                 #No.TQC-720019
--mi
         OPEN i119_count
         FETCH i119_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i119_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i119_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE   #No.FUN-6A0078
            CALL i119_fetch('/')
         END IF
--#
            LET g_cnt=STATUS
            LET g_delete = 'Y'
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
    COMMIT WORK
END FUNCTION
#單身
FUNCTION i119_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680108 SMALLINT 
    l_n             LIKE type_file.num5,   #檢查重複用 #No.FUN-680108 SMALLINT
    l_no            LIKE type_file.num5,   #檢查重複用 #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否 #No.FUN-680108 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,   #處理狀態   #No.FUN-680108 VARCHAR(01)
    l_str           LIKE type_file.chr20,  #No.FUN-680108 VARCHAR(20)
    l_acti          LIKE pmh_file.pmhacti,
    l_allow_insert  LIKE type_file.num5,   #可新增否  #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否  #No.FUN-680108 SMALLINT
 
    LET g_action_choice = ""

    IF s_shut(0)  THEN RETURN END IF
    IF g_ado01 IS NULL THEN RETURN END IF

    CALL cl_opmsg('b')
    LET g_forupd_sql="SELECT ado03,ado04,ado05,ado06,' ',ado07,adoacti",
                     "  FROM ado_file",
                     " WHERE ado01 = ? AND ado02 = ?",
                     "   AND ado03 = ?",
                     "   FOR UPDATE NOWAIT"
    DECLARE i119_b_cl CURSOR FROM g_forupd_sql

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_ado WITHOUT DEFAULTS FROM s_ado.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_ado_t.* = g_ado[l_ac].*
               OPEN i119_b_cl USING g_ado01,g_ado02,g_ado_t.ado03
               IF STATUS THEN
                  CALL cl_err("OPEN i119_b_cl:", STATUS, 1)
                  CLOSE i119_b_cl
                  ROLLBACK WORK
                  RETURN
               END IF

               FETCH i119_b_cl INTO g_ado[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ado_t.ado04,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               CALL i119_gen02('d')                #單身
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
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
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ado_file(ado01,ado02,ado03,ado04,ado05,
                                 ado06,ado07,adoacti,adouser,
                                 adogrup,adomodu,adodate)
            VALUES(g_ado01,g_ado02,g_ado[l_ac].ado03,
                   g_ado[l_ac].ado04,g_ado[l_ac].ado05,
                   g_ado[l_ac].ado06,g_ado[l_ac].ado07,
                   g_ado[l_ac].adoacti,g_user,g_grup,'',g_today)
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_ado[l_ac].ado03,SQLCA.sqlcode,0)
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
                 CALL i119_gen02('d')                #單身
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
                    CALL cl_err(g_ado_t.ado04,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
             END IF
             COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ado[l_ac].* = g_ado_t.*
               CLOSE i119_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ado[l_ac].ado04,-263,1)
               LET g_ado[l_ac].* = g_ado_t.*
            ELSE
  UPDATE ado_file 
     SET ado03=g_ado[l_ac].ado03,ado04=g_ado[l_ac].ado04,      
         ado05=g_ado[l_ac].ado05,ado06=g_ado[l_ac].ado06,      
         ado07=g_ado[l_ac].ado07,adoacti=g_ado[l_ac].adoacti,    
         adouser=g_user,adomodu=g_today                           
   WHERE CURRENT OF i119_b_cl
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ado[l_ac].ado03,SQLCA.sqlcode,0)
                   LET g_ado[l_ac].* = g_ado_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ado[l_ac].* = g_ado_t.*
               END IF
               CLOSE i119_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i119_b_cl
            COMMIT WORK
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

       ON ACTION CONTROLP
            CASE
                 WHEN INFIELD(ado06)
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
            CALL i119_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(ado04) AND l_ac > 1 THEN
                LET g_ado[l_ac].* = g_ado[l_ac-1].*
                NEXT FIELD ado03
            END IF

        ON ACTION CONTROLZ
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
 
        END INPUT

    #FUN-5B0113-begin
     UPDATE ado_file SET adomodu = g_user,adodate = g_today
      WHERE ado01 = g_ado01
        AND ado02 = g_ado02
        AND ado03 = g_ado[l_ac].ado03
     IF SQLCA.SQLCODE OR STATUS = 0 THEN
        CALL cl_err('upd ado',SQLCA.SQLCODE,1)
     END IF
    #FUN-5B0113-end

    CLOSE i119_b_cl
    COMMIT WORK
END FUNCTION

FUNCTION i119_gen02(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
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

FUNCTION i119_b_askkey()
DEFINE
    #l_wc           LIKE type_file.chr1000,  #TQC-630166  #No.FUN-680108 VARCHAR(200)
    l_wc            STRING    #TQC-630166

    CONSTRUCT l_wc ON ado03,ado04,ado05,ado06,ado07,adoacti    #螢幕上取條件
                 FROM s_ado[1].ado03,s_ado[1].ado04,s_ado[1].ado05,
                      s_ado[1].ado06,s_ado[1].ado07,s_ado[1].adoacti

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON ACTION CONTROLP
	    CASE
               WHEN INFIELD(ado06)
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i119_b_fill(l_wc)
END FUNCTION

FUNCTION i119_b_fill(p_wc)              #BODY FILL UP
DEFINE
    #p_wc           LIKE type_file.chr1000, #TQC-630166  #No.FUN-680108 VARCHAR(200)
    p_wc            STRING   #TQC-630166

    LET g_sql =
       "SELECT ado03,ado04,ado05,ado06,gen02,ado07,adoacti",
        "  FROM ado_file,OUTER gen_file ",    #NO.MOD-4B0067
       " WHERE ado01 = '",g_ado01,"'",
       "   AND ado02 = '",g_ado02,"'",
        "   AND ado06 = gen_file.gen01 AND ",p_wc CLIPPED ,#NO.MOD-4B0067
       " ORDER BY ado03"
    PREPARE i119_prepare2 FROM g_sql      #預備一下
    DECLARE ado_cs CURSOR FOR i119_prepare2

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

FUNCTION i119_bp(p_ud)
DEFINE
    p_ud           LIKE type_file.chr1       #No.FUN-680108 VARCHAR(1)

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
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL i119_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION previous
         CALL i119_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION jump
         CALL i119_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION next
         CALL i119_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION last
         CALL i119_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

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
 
      ON ACTION related_document                #No:FUN-6A0165  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i119_copy()
DEFINE l_newno1,l_oldno1  LIKE ado_file.ado01,
       l_newno2,l_oldno2  LIKE ado_file.ado02,
       l_n                LIKE type_file.num5    #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_ado01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    LET g_before_input_done = FALSE
    CALL i119_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno1,l_newno2 FROM ado01,ado02
        AFTER FIELD ado01
            IF cl_null(l_newno1) THEN
                NEXT FIELD ado01
            END IF
            CALL i119_ado01(l_newno1)
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
                  DISPLAY l_newno1 TO ado01 ATTRIBUTE(YELLOW)
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
       DISPLAY g_ado01 TO ado01  ATTRIBUTE(YELLOW)
       DISPLAY g_ado02 TO ado02  ATTRIBUTE(YELLOW)
       RETURN
    END IF

    DROP TABLE x
    SELECT * FROM ado_file         #單身複製
        WHERE g_ado01=ado01 AND g_ado02 = ado02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_ado01 CLIPPED,'+',g_ado02
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    UPDATE x
        SET ado01 = l_newno1,
            ado02 = l_newno2
    INSERT INTO ado_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = l_newno1 CLIPPED,'+',l_newno2
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    LET g_cnt=STATUS
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno1= g_ado01
     LET l_oldno2= g_ado02
     LET g_ado01=l_newno1
     LET g_ado02=l_newno2
     CALL i119_b()
     LET g_ado01=l_oldno1
     LET g_ado02=l_oldno2
     CALL i119_show()
END FUNCTION

FUNCTION i119_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680108 SMALLINT
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
    l_name          LIKE type_file.chr20,  #External(Disk) file name   #No.FUN-680108 VARCHAR(20)
     l_za05          LIKE za_file.za05      #NO.MOD-4B0067

    IF cl_null(g_wc) AND NOT cl_null(g_ado01)  AND NOT cl_null(g_ado02)
       AND NOT cl_null(g_ado[l_ac].ado03) THEN
       LET g_wc = " ado01 = '",g_ado01,"' AND ado02 = '",g_ado02,"' AND ado03 = '",g_ado[l_ac].ado03,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axdi119') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ado01,ado02,ado03,ado04,ado05,ado06,gen02,ado07,adoacti",
              "  FROM ado_file ,OUTER gen_file ",  # 組合出 SQL 指令
              " WHERE ado06=gen_file.gen01 AND ",g_wc CLIPPED,
              "   AND adoacti = 'Y' ",
              " ORDER BY ado01,ado02 "
    PREPARE i119_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i119_co                         # CURSOR
        CURSOR FOR i119_p1

    START REPORT i119_rep TO l_name
    FOREACH i119_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i119_rep(sr.*)
    END FOREACH
    FINISH REPORT i119_rep
    CLOSE i119_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i119_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
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
         PRINT COLUMN g_c[33],sr.ado03 USING '###&', #FUN-590118
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

FUNCTION i119_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ado01",TRUE)
   END IF

END FUNCTION

FUNCTION i119_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ado01",FALSE)
       END IF
   END IF

END FUNCTION
