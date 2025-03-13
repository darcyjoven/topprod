# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi185.4gl
# Descriptions...: 車輛工作日報維護作業(atmi185)
# Date & Author..: 03/12/03 By Leagh
# Modify.........: No.MOD-4A0335 04/10/29 By Carrier
# Modify.........: No.MOD-4B0067 04/11/16 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No.FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/07/18 By mike 報表格式修改為p_query
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C50005 12/05/03 By fanbj 複製完后單身會不見
# Modify.........: No.TQC-C70222 12/07/31 By yangxf 栏位控卡bug修改
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	g_adn01         LIKE adn_file.adn01,   #料件編號
	g_adn01_t       LIKE adn_file.adn01,   #
	g_adn02         LIKE adn_file.adn02,   #廠商編號
	g_adn02_t       LIKE adn_file.adn02,   #
	g_adn03         LIKE adn_file.adn03,   #廠商料號
	g_adn03_t       LIKE adn_file.adn03,   #廠商料號(舊值)
	g_adn           DYNAMIC ARRAY OF RECORD
			adn04       LIKE adn_file.adn04,   #行序
			adn05       LIKE adn_file.adn05,   #說明
			gen02       LIKE gen_file.gen02,
			adn06       LIKE adn_file.adn06,
			adn07       LIKE adn_file.adn07,
			adn08       LIKE adn_file.adn08,
			adn09       LIKE adn_file.adn09,
			adn10       LIKE adn_file.adn10,
			adn11       LIKE adn_file.adn11,
			adn12       LIKE adn_file.adn12,
			adnacti     LIKE adn_file.adnacti
			END RECORD,
	g_adn_t         RECORD
			adn04       LIKE adn_file.adn04,   #行序
			adn05       LIKE adn_file.adn05,   #說明
			gen02       LIKE gen_file.gen02,
			adn06       LIKE adn_file.adn06,
			adn07       LIKE adn_file.adn07,
			adn08       LIKE adn_file.adn08,
			adn09       LIKE adn_file.adn09,
			adn10       LIKE adn_file.adn10,
			adn11       LIKE adn_file.adn11,
			adn12       LIKE adn_file.adn12,
			adnacti     LIKE adn_file.adnacti
			END RECORD,
	l_flag              LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
	g_delete            LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
	g_wc,g_sql          STRING,#TQC-630166
	g_rec_b         LIKE type_file.num5,                  #單身筆數            #No.FUN-680120 SMALLINT
	l_ac            LIKE type_file.num5,                  #目前處理的ARRAY CNT #No.FUN-680120 SMALLINT
#       l_time	LIKE type_file.chr8              #No.FUN-6B0014
        g_argv1         LIKE adn_file.adn01,
        g_ss            LIKE type_file.chr1               #No.FUN-680120 VARCHAR(1)
DEFINE p_row,p_col     LIKE type_file.num5                #No.FUN-680120 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680120 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
 
MAIN
 
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6B0014
 
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
 
    LET g_adn01_t = NULL
    LET g_adn02_t = NULL
    LET g_adn03_t = NULL
    INITIALIZE g_adn_t.* TO NULL
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW i185_w AT p_row,p_col
       	WITH FORM "atm/42f/atmi185"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
 
--##
    CALL g_x.clear()
--##
 
 
    CALL i185_menu()
 
    CLOSE WINDOW i185_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
 
FUNCTION i185_cs()
    CLEAR FORM                             #清除畫面
    CALL g_adn.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_adn01 TO NULL    #No.FUN-750051
   INITIALIZE g_adn02 TO NULL    #No.FUN-750051
   INITIALIZE g_adn03 TO NULL    #No.FUN-750051
          CONSTRUCT g_wc ON adn01,adn02,adn03,adn04,adn05,adn06,adn07,
                            adn08,adn09,adn10,adn11,adn12,adnacti
                 FROM adn01,adn02,adn03,s_adn[1].adn04,s_adn[1].adn05,
                      s_adn[1].adn06,s_adn[1].adn07,s_adn[1].adn08,
                      s_adn[1].adn09,s_adn[1].adn10,s_adn[1].adn11,
                      s_adn[1].adn12,s_adn[1].adnacti
 
           #No.FUN-580031 --start--     HCN
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
           #No.FUN-580031 --end--       HCN
 
           ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(adn01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_obw01"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO adn01
                       NEXT FIELD adn01
                  WHEN INFIELD(adn05)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gen"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO adn05
                       NEXT FIELD adn05
                  WHEN INFIELD(adn06)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_adk"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO adn06
                       NEXT FIELD adn06
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('adnuser', 'adngrup') #FUN-980030
 
         IF INT_FLAG THEN RETURN END IF
    LET g_sql= "SELECT UNIQUE adn01,adn02,adn03 FROM adn_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY adn01 "
 
    PREPARE i185_prepare FROM g_sql      #預備一下
    DECLARE i185_b_cs                  #宣告成可捲動的
	SCROLL CURSOR WITH HOLD FOR i185_prepare
 
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE z
#   LET g_sql="SELECT UNIQUE adn01,adn02,adn03 ",      #No.TQC-720019
    LET g_sql_tmp="SELECT UNIQUE adn01,adn02,adn03 ",  #No.TQC-720019
	      " FROM adn_file WHERE ", g_wc CLIPPED,
              " INTO TEMP z "
#   PREPARE i185_count_pre FROM g_sql      #No.TQC-720019
    PREPARE i185_count_pre FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i185_count_pre
    LET g_sql="SELECT COUNT(*) FROM z "
    PREPARE i185_pre_count FROM g_sql
    DECLARE i185_count CURSOR FOR i185_pre_count
--## 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
   OPEN i185_count
   FETCH i185_count INTO g_row_count
   CLOSE i185_count
END FUNCTION
 
FUNCTION i185_menu()
 DEFINE   l_cmd    STRING     #No.FUN-780056
   WHILE TRUE
      CALL i185_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i185_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i185_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i185_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i185_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i185_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i185_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i185_out()                                       #No.FUN-780056
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF          #No.FUN-780056
               LET l_cmd = 'p_query "atmi185" "',g_wc 	CLIPPED,'"'   #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                                  #No.FUN-780056
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controln"
            CALL i185_bp('N')
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_adn01 IS NOT NULL THEN
                LET g_doc.column1 = "adn01"
                LET g_doc.column2 = "adn02"
                LET g_doc.column3 = "adn03"
                LET g_doc.value1 = g_adn01
                LET g_doc.value2 = g_adn02
                LET g_doc.value3 = g_adn03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i185_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_adn.clear()
 
    INITIALIZE g_adn01 LIKE  adn_file.adn01
    INITIALIZE g_adn02 LIKE  adn_file.adn02
    INITIALIZE g_adn03 LIKE  adn_file.adn03
 
    CLOSE i185_b_cs
 
    LET g_adn01_t  = NULL
    LET g_adn02_t  = NULL
    LET g_adn03_t  = NULL
    LET g_adn02 = g_today
    LET g_adn03 = g_today	
 
    LET g_wc       = NULL
 
    CALL cl_opmsg('a')
    WHILE TRUE
	CALL i185_i("a")                #輸入單頭
	IF INT_FLAG THEN                   #使用者不玩了
            LET g_adn01 = NULL
	    LET INT_FLAG = 0
	    CALL cl_err('',9001,0)
	    EXIT WHILE
	END IF
        IF g_ss='N' THEN
            CALL g_adn.clear()
        ELSE
            CALL i185_b_fill(' 1=1')          #單身
        END IF
        LET g_rec_b=0
        CALL i185_b()                        #輸入單身
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_adn01,SQLCA.sqlcode,0)
        END IF
        LET g_adn01_t = g_adn01                 #保留舊值
        LET g_adn02_t = g_adn02
        LET g_adn03_t = g_adn03
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i185_u()
    DEFINE  l_buf      LIKE nma_file.nma04        #No.FUN-680120 VARCHAR(30)
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_adn01) THEN CALL cl_err('',-400,0) RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_adn01_t = g_adn01
    LET g_adn02_t = g_adn02
    LET g_adn03_t = g_adn03
 
    BEGIN WORK
    WHILE TRUE
        CALL i185_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_adn01=g_adn01_t
             LET g_adn02=g_adn02_t   #MOD-4A0335
             LET g_adn03=g_adn03_t   #MOD-4A0335
            DISPLAY g_adn01 TO adn01               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
            UPDATE adn_file
                SET   adn01 = g_adn01,
                      adn02 = g_adn02,
                      adn03 = g_adn03
                WHERE adn01 = g_adn01_t
                  AND adn02 = g_adn02_t
                  AND adn03 = g_adn03_t
        IF SQLCA.sqlcode THEN
         #  CALL cl_err(g_adn01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","adn_file",g_adn01_t,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i185_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
    l_n             LIKE type_file.num5          #No.FUN-680120 SMALLINT
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT g_adn01,g_adn02,g_adn03
          WITHOUT DEFAULTS FROM adn01,adn02,adn03
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i185_set_entry(p_cmd)
            CALL i185_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
	AFTER FIELD adn01
            IF NOT cl_null(g_adn01) THEN
               IF (g_adn01_t IS NULL) OR (g_adn01_t != g_adn01) THEN
                   CALL i185_adn01(g_adn01)
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_adn01,g_errno,0)
                     NEXT FIELD adn01
                   END IF
               END IF
            END IF
 
#	AFTER FIELD adn03          #TQC-C70222 MARK
        AFTER FIELD adn02,adn03    #TQC-C70222 add
            IF NOT cl_null(g_adn03) AND NOT cl_null(g_adn02) THEN
	       IF g_adn02 > g_adn03 THEN
                  #NEXT FIELD adn02               #TQC-C70222 mark
                  #TQC-C70222 add begin ---
                  CALL cl_err('','atm-269',0) 
                  CASE
                     WHEN INFIELD(adn02)
                          LET g_adn02 = g_adn02_t
                     WHEN INFIELD(adn03)
                          LET g_adn03 = g_adn03_t
                  END CASE
                  NEXT FIELD CURRENT
                  #TQC-C70222 add end  ---
               END IF
              #TQC-C70222 MARK BEGIN --- 
	      # IF MONTH(g_adn02) != MONTH(g_adn03) THEN
              #    NEXT FIELD adn02
              # END IF
              #TQC-C70222 MARK END -----
               IF ((g_adn01_t IS NULL) OR (g_adn01 != g_adn01_t OR
                                          g_adn02 != g_adn02_t OR
                                          g_adn03 != g_adn03_t)) THEN
                  SELECT COUNT(*) INTO g_cnt FROM  adn_file
                   WHERE adn01 = g_adn01
                     AND adn02 = g_adn02
                     AND adn03 = g_adn03
                  IF g_cnt > 0 THEN
                      CALL cl_err(g_adn03,-239,0)
                      #NEXT FIELD adn03              #TQC-C70222 mark
                      NEXT FIELD CURRENT             #TQC-C70222 add
                  END IF
               END IF
            END IF
 
        ON ACTION CONTROLP
         CASE
           WHEN INFIELD(adn01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_obw01"
                 LET g_qryparam.default1 = g_adn01
                   CALL cl_create_qry() RETURNING g_adn01
                   DISPLAY g_adn01 TO adn01
                   NEXT FIELD adn01
         END CASE
 
        ON ACTION controlf                  #欄位說明
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
 
FUNCTION i185_adn01(p_adn01)
  DEFINE l_obw01   LIKE obw_file.obw01,
         l_obwacti LIKE obw_file.obwacti,
         p_adn01   LIKE adn_file.adn01
 
     LET g_errno = ' '
     SELECT obw01,obwacti INTO l_obw01,l_obwacti
       FROM obw_file
      WHERE obw01=p_adn01
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='axd-010'
         WHEN l_obwacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
END FUNCTION
 
#Query 查詢
FUNCTION i185_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   #No.FUN-6B0043----add----str----
    INITIALIZE g_adn01 TO NULL
    INITIALIZE g_adn02 TO NULL
    INITIALIZE g_adn03 TO NULL
   #No.FUN-6B0043----add----end----
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_adn.clear()
 
    CALL i185_cs()                    #取得查詢條件
 
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_adn01 TO NULL
        INITIALIZE g_adn02 TO NULL
        INITIALIZE g_adn03 TO NULL
        RETURN
    END IF
--mi
    OPEN i185_count
    FETCH i185_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
--#
    OPEN i185_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adn01 TO NULL
        INITIALIZE g_adn02 TO NULL
        INITIALIZE g_adn03 TO NULL
    ELSE
        CALL i185_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i185_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i185_b_cs INTO g_adn01,g_adn02,g_adn03
                                               
        WHEN 'P' FETCH PREVIOUS i185_b_cs INTO g_adn01,g_adn02,g_adn03
                                               
        WHEN 'F' FETCH FIRST    i185_b_cs INTO g_adn01,g_adn02,g_adn03
                                               
        WHEN 'L' FETCH LAST     i185_b_cs INTO g_adn01,g_adn02,g_adn03
                                               
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump i185_b_cs INTO g_adn01,g_adn02,g_adn03
                                                 
            LET mi_no_ask = FALSE    #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_adn01,SQLCA.sqlcode,0)
#        INITIALIZE g_adn01 TO NULL
    ELSE
#        OPEN i185_count
#        FETCH i185_count INTO g_cnt
#        DISPLAY g_cnt TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
#        CALL i185_show()
 
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i185_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i185_show()
    DISPLAY g_adn01 TO adn01               #單頭
    DISPLAY g_adn02 TO adn02               #單頭
    DISPLAY g_adn03 TO adn03               #單頭
    CALL i185_b_fill(g_wc)              #單身
 #    CALL i185_gen02('d')   #MOD-4A0335
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i185_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_adn01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6B0043
       RETURN 
    END IF
 
    BEGIN WORK
    IF cl_delh(0,0) THEN
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "adn01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "adn02"      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "adn03"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_adn01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_adn02       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_adn03       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                       #No.FUN-9B0098 10/02/24
        DELETE FROM adn_file
              WHERE adn01 = g_adn01
                AND adn02 = g_adn02
                AND adn03 = g_adn03
        IF SQLCA.sqlcode THEN
        #   CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("del","adn_file",g_adn01,"",SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            CALL g_adn.clear()
--mi
         DROP TABLE z                            #No.TQC-720019
         PREPARE i185_count_pre2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i185_count_pre2                 #No.TQC-720019
         OPEN i185_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i185_b_cs
            CLOSE i185_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i185_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i185_b_cs
            CLOSE i185_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i185_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i185_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE   #No.FUN-6A0072
            CALL i185_fetch('/')
         END IF
--#
            LET g_cnt=SQLCA.SQLERRD[3]
            LET g_delete = 'Y'
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
#            CLOSE i185_b_cs
#            OPEN i185_b_cs
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION i185_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680120 SMALLINT
    l_no            LIKE type_file.num5,                #No.FUN-680120 SMALLINT             #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680120 VARCHAR(1)
    l_adn11         LIKE adn_file.adn11,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
 
    IF cl_null(g_adn01) THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
   LET g_forupd_sql =
    "SELECT adn04,adn05,' ',adn06,adn07,adn08,adn09,adn10,adn11,adn12,adnacti ",
    " FROM adn_file ",
    " WHERE adn01 = ? AND adn02 = ? AND adn03 = ? AND adn04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i185_b_cl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
 
    INPUT ARRAY g_adn WITHOUT DEFAULTS FROM s_adn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
 
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_adn_t.* = g_adn[l_ac].*  #BACKUP
               IF (g_adn_t.adn04 IS NOT NULL AND  g_adn_t.adn04 != 0) THEN
                   LET p_cmd='u'
                   OPEN i185_b_cl USING g_adn01,g_adn02,g_adn03,g_adn_t.adn04
                   IF STATUS THEN
                      CALL cl_err("OPEN i185_b_cl:", STATUS, 1)
                      CLOSE i185_b_cl
                      ROLLBACK WORK
                      RETURN
                   END IF
                   FETCH i185_b_cl INTO g_adn[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_adn_t.adn04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_adn_t.*=g_adn[l_ac].*
                   END IF
                CALL i185_gen02("d")
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adn[l_ac].* TO NULL      #900423
            LET g_adn_t.* = g_adn[l_ac].*         #新輸入資料
            SELECT obw16 INTO g_adn[l_ac].adn05 FROM obw_file
             WHERE obw01 = g_adn01
            LET g_adn[l_ac].adn08 = g_adn03
            LET g_adn[l_ac].adnacti ='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adn04
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO adn_file(adn01,adn02,adn03,adn04,adn05,adn06,adn07,
                                 adn08,adn09,adn10,adn11,adn12,adnacti,
                                 adnplant,adnlegal,adnoriu,adnorig) #FUN-980009
                          VALUES(g_adn01,g_adn02,g_adn03,
                                 g_adn[l_ac].adn04,g_adn[l_ac].adn05,
                                 g_adn[l_ac].adn06,g_adn[l_ac].adn07,
                                 g_adn[l_ac].adn08,g_adn[l_ac].adn09,
                                 g_adn[l_ac].adn10,g_adn[l_ac].adn11,
                                 g_adn[l_ac].adn12,g_adn[l_ac].adnacti,
                                 g_plant,g_legal, g_user, g_grup) #FUN-980009      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_adn[l_ac].adn04,SQLCA.sqlcode,0)  #No.FUN-660104
               CALL cl_err3("ins","adn_file",g_adn[l_ac].adn04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE FIELD adn04                        # dgeeault 序號
            IF cl_null(g_adn[l_ac].adn04) OR g_adn[l_ac].adn04 = 0 THEN
                SELECT MAX(adn04)+1 INTO g_adn[l_ac].adn04 FROM adn_file
                 WHERE adn01 = g_adn01 AND adn02 = g_adn02
                   AND adn03 = g_adn03
                IF g_adn[l_ac].adn04 IS NULL THEN
                    LET g_adn[l_ac].adn04 = 1
                END IF
            END IF
 
        AFTER FIELD adn04                        #check 序號是否重複
            IF NOT cl_null(g_adn[l_ac].adn04) THEN
               IF (g_adn[l_ac].adn04 != g_adn_t.adn04 OR
                   g_adn_t.adn04 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM adn_file
                   WHERE adn01 = g_adn01 AND adn02 = g_adn02
                     AND adn03 = g_adn03 AND adn04 = g_adn[l_ac].adn04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_adn[l_ac].adn04 = g_adn_t.adn04
                     NEXT FIELD adn04
                  END IF
               END IF
            END IF
 
        AFTER FIELD adn05
           IF NOT cl_null(g_adn[l_ac].adn05) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_adn[l_ac].adn05 != g_adn_t.adn05) THEN
                 CALL i185_gen02("d")
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_adn[l_ac].adn05,g_errno,0)
                    NEXT FIELD adn05
                 END IF
              END IF
           END IF
 
        AFTER FIELD adn06
           IF NOT cl_null(g_adn[l_ac].adn06) THEN
               SELECT adk03 INTO g_adn[l_ac].adn07
                 FROM adk_file
                WHERE adk01 = g_adn[l_ac].adn06
               IF STATUS THEN
               #   CALL cl_err('select g_adn[l_ac].adn06','mfg0044',0)  #No.FUN-660104
                   CALL cl_err3("sel","adk_file",g_adn[l_ac].adn06,"","mfg0044","","select g_adn[l_ac].adn06",1)  #No.FUN-660104
                   NEXT FIELD adn06
               END IF
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_adn[l_ac].adn07
               #------MOD-5A0095 END------------
            END IF
 
        BEFORE FIELD adn10
           IF p_cmd = 'a' AND cl_null(g_adn[l_ac].adn10) THEN
              SELECT MAX(adn11) INTO g_adn[l_ac].adn10 FROM adn_file
               WHERE adn01 = g_adn01
                 AND adn03 = (SELECT MAX(adn03) FROM adn_file
                              WHERE adn01 = g_adn01 AND adnacti = 'Y')
              IF STATUS THEN
                 LET g_adn[l_ac].adn10 = 0
                 END IF
              IF cl_null(g_adn[l_ac].adn10) THEN
                 LET g_adn[l_ac].adn10=0
                 END IF
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_adn[l_ac].adn10
               #------MOD-5A0095 END------------
           END IF
 
        #AFTER FIELD adn11             #TQC-C70222 mark
         AFTER FIELD adn10,adn11       #TQC-C70222 add
           #TQC-C70222 add begin---
           IF NOT cl_null(g_adn[l_ac].adn10) AND g_adn[l_ac].adn10 < 0 THEN
              LET g_adn[l_ac].adn10 = g_adn_t.adn10
              CALL cl_err('','atm-157',0)
              NEXT FIELD adn10
           END IF 
           IF NOT cl_null(g_adn[l_ac].adn11) AND g_adn[l_ac].adn11 < 0 THEN
              LET g_adn[l_ac].adn11 = g_adn_t.adn11
              CALL cl_err('','atm-157',0)
              NEXT FIELD adn11
           END IF
           #TQC-C70222 add end -----
           IF NOT cl_null(g_adn[l_ac].adn11)
              AND NOT cl_null(g_adn[l_ac].adn10) THEN
             #IF g_adn[l_ac].adn11 < g_adn[l_ac].adn10 THEN NEXT FIELD adn11 END IF      #TQC-C70222 mark
             #TQC-C70222 add begin ---
              IF g_adn[l_ac].adn11 < g_adn[l_ac].adn10 THEN
                 CALL cl_err('','atm-156',0)
                 CASE 
                    WHEN INFIELD(adn10)
                         LET g_adn[l_ac].adn10 = g_adn_t.adn10 
                    WHEN INFIELD(adn11)
                         LET g_adn[l_ac].adn11 = g_adn_t.adn11
                 END CASE
                 NEXT FIELD CURRENT 
              END IF 
             #TQC-C70222 add end -----
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_adn_t.adn04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM adn_file
                    WHERE adn01 = g_adn01 AND adn02 = g_adn02
                      AND adn03 = g_adn03 AND adn04 = g_adn_t.adn04
                IF SQLCA.sqlcode THEN
                #  CALL cl_err(g_adn_t.adn04,SQLCA.sqlcode,0)  #No.FUN-660104
                   CALL cl_err3("del","adn_file",g_adn_t.adn04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
               LET g_adn[l_ac].* = g_adn_t.*
               CLOSE i185_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adn[l_ac].adn04,-263,1)
               LET g_adn[l_ac].* = g_adn_t.*
            ELSE
 UPDATE adn_file SET adn01=g_adn01,
                     adn02=g_adn02,
                     adn03=g_adn03,
                     adn04=g_adn[l_ac].adn04,
                     adn05=g_adn[l_ac].adn05,
                     adn06=g_adn[l_ac].adn06,
                     adn07=g_adn[l_ac].adn07,
                     adn08=g_adn[l_ac].adn08,
                     adn09=g_adn[l_ac].adn09,
                     adn10=g_adn[l_ac].adn10,
                     adn11=g_adn[l_ac].adn11,                    
                     adn12=g_adn[l_ac].adn12,
                     adnacti=g_adn[l_ac].adnacti                               
                WHERE adn01 = g_adn01
                  AND adn02 = g_adn02
                  AND adn03 = g_adn03
                  AND adn04 = g_adn_t.adn04
 
                     IF SQLCA.sqlcode THEN
                     #  CALL cl_err(g_adn[l_ac].adn04,SQLCA.sqlcode,0)   #No.FUN-660104
                        CALL cl_err3("upd","adn_file",g_adn_t.adn04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104 
                        LET g_adn[l_ac].* = g_adn_t.*
                        ROLLBACK WORK
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
                  LET g_adn[l_ac].* = g_adn_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_adn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i185_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30033 add
            CLOSE i185_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLP
             CASE
                WHEN INFIELD(adn05)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_gen"
                       LET g_qryparam.default1 = g_adn[l_ac].adn05
                       CALL cl_create_qry() RETURNING g_adn[l_ac].adn05
#                       CALL FGL_DIALOG_SETBUFFER( g_adn[l_ac].adn05 )
                       SELECT gen02
                       INTO g_adn[l_ac].gen02
                       FROM gen_file
                       WHERE gen01 = g_adn[l_ac].adn05
                   IF STATUS THEN
                   #  CALL cl_err('select gen',STATUS,1)  #No.FUN-660104
                      CALL cl_err3("sel","gen_file",g_adn[l_ac].adn05,"",STATUS,"","select gen",1)  #No.FUN-660104
                   END IF
                       NEXT FIELD adn05
                 WHEN INFIELD(adn06)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_adk"
                       LET g_qryparam.default1 = g_adn[l_ac].adn06
                       CALL cl_create_qry() RETURNING g_adn[l_ac].adn06
#                       CALL FGL_DIALOG_SETBUFFER( g_adn[l_ac].adn06 )
                       SELECT adk03
                       INTO g_adn[l_ac].adn07
                       FROM adk_file
                       WHERE adk01 = g_adn[l_ac].adn06
                   IF STATUS THEN
                   #  CALL cl_err('select adk',STATUS,1)   #No.FUN-660104
                      CALL cl_err3("sel","adk_file",g_adn[l_ac].adn06,"",STATUS,"","select adk",1)  #No.FUN-660104
                   END IF
                       NEXT FIELD adn06
             END CASE
 
        ON ACTION CONTROLN
           CALL i185_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(adn04) AND l_ac > 1 THEN
               LET g_adn[l_ac].* = g_adn[l_ac-1].*
               NEXT FIELD adn04
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
 
      CLOSE i185_b_cl
      COMMIT WORK
 
 #MOD-4A0335  --begin
    SELECT MAX(adn11) INTO l_adn11 FROM adn_file
     WHERE adn01=g_adn01 AND adn02=g_adn02 AND adn03=g_adn03
    UPDATE obw_file SET obw13=l_adn11
     WHERE obw01=g_adn01 AND (obw13<l_adn11 OR obw13 IS NULL)
    IF SQLCA.sqlcode THEN
    #  CALL cl_err('update obw13',SQLCA.sqlcode,0)   #No.FUN-660104
       CALL cl_err3("upd","obw_file",g_adn01,"",SQLCA.sqlcode,"","update obw13",1)  #No.FUN-660104
    END IF
 #MOD-4A0335  --end
 
END FUNCTION
 
FUNCTION i185_gen02(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file
   WHERE gen01 = g_adn[l_ac].adn05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    LET g_adn[l_ac].gen02 = l_gen02
    #------MOD-5A0095 START----------
    DISPLAY BY NAME g_adn[l_ac].gen02
    #------MOD-5A0095 END------------
  END IF
END FUNCTION
 
FUNCTION i185_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc ON adn04,adn05,adn06,adn07,adn08,adn09,
                      adn10,adn11,adn12,adnacti    #螢幕上取條件
                 FROM s_adn[1].adn04,s_adn[1].adn05,s_adn[1].adn06,
                      s_adn[1].adn07,s_adn[1].adn08,s_adn[1].adn09,
                      s_adn[1].adn10,s_adn[1].adn11,s_adn[1].adn12,
                      s_adn[1].adnacti
 
           #No.FUN-580031 --start--     HCN
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
           #No.FUN-580031 --end--       HCN
 
 #MOD-4A0335  --begin
           ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(adn05)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gen"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO adn05
                       NEXT FIELD adn05
                  WHEN INFIELD(adn06)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_adk"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO adn06
                       NEXT FIELD adn06
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
 
 #MOD-4A0335  --end
 
           #No.FUN-580031 --start--     HCN
           ON ACTION qbe_select
               CALL cl_qbe_select() 
           ON ACTION qbe_save
               CALL cl_qbe_save()
           #No.FUN-580031 --end--       HCN
     END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    CALL i185_b_fill(l_wc)
END FUNCTION
 
FUNCTION i185_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adn TO s_adn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION first
         CALL i185_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i185_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i185_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i185_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i185_fetch('L')
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
 
FUNCTION i185_b_fill(p_wc)
   DEFINE p_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
   
   #TQC-C50005--start add----
   IF cl_null(p_wc) THEN
      LET p_wc = ' 1=1'   
   END IF 
   #TQC-C50005--end add------

   LET g_sql ="SELECT adn04,adn05,gen02,adn06,adn07,adn08,adn09,",
              "       adn10,adn11,adn12,adnacti",
              " FROM adn_file,gen_file ",
              " WHERE adn01 = '",g_adn01,"'",
              "   AND adn02 = '",g_adn02,"'",
              "   AND adn03 = '",g_adn03,"'",
              "   AND adn05 = gen01 AND ",p_wc CLIPPED ,
              " ORDER BY adn04"
   PREPARE i185_prepare2 FROM g_sql
   DECLARE adn_cs CURSOR FOR i185_prepare2
   CALL g_adn.clear()
   LET g_cnt = 1
   FOREACH adn_cs INTO g_adn[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET g_cnt=g_cnt+1
       IF g_cnt>g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_adn.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION i185_copy()
DEFINE l_newno1,l_oldno1  LIKE adn_file.adn01,
       l_newno2,l_oldno2  LIKE adn_file.adn02,
       l_newno3,l_oldno3  LIKE adn_file.adn03,
       l_n                LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_adn01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET g_before_input_done = FALSE
    CALL i185_set_entry('a')
    LET g_before_input_done = TRUE  
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno1,l_newno2,l_newno3 FROM adn01,adn02,adn03
        AFTER FIELD adn01
            IF cl_null(l_newno1) THEN NEXT FIELD adn01 END IF
            CALL i185_adn01(l_newno1)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_newno1,g_errno,0)
               NEXT FIELD adn01
            END IF
 
        AFTER FIELD adn03
          IF NOT cl_null(l_newno3) THEN
            IF l_newno2 > l_newno3 THEN NEXT FIELD adn02 END IF
            IF MONTH(l_newno2) != MONTH(l_newno3) THEN NEXT FIELD adn02 END IF
            SELECT COUNT(*) INTO g_cnt FROM  adn_file
             WHERE adn01 = l_newno1 AND adn02 = l_newno2
               AND adn03 = l_newno3
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno3,-239,0)
                NEXT FIELD adn03
            END IF
          END IF
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(adn01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_obw01"
                 LET g_qryparam.default1 = l_newno1
                 CALL cl_create_qry() RETURNING l_newno1
                 DISPLAY l_newno1 TO adn01
                 NEXT FIELD adn01
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY  g_adn01 TO adn01
            DISPLAY  g_adn02 TO adn02
            DISPLAY  g_adn03 TO adn03
            RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM adn_file         #單身複製
        WHERE g_adn01=adn01 AND g_adn02 = adn02 AND g_adn03=adn03
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_adn01 CLIPPED,'+',g_adn02 CLIPPED,'+',g_adn03
    #  CALL cl_err(g_msg,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("ins","x",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    UPDATE x
        SET adn01 = l_newno1,
            adn02 = l_newno2,
            adn03 = l_newno3
    INSERT INTO adn_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',l_newno3
    #  CALL cl_err(g_msg,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("ins","adn_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno1= g_adn01
     LET l_oldno2= g_adn02
     LET l_oldno3= g_adn03
     LET g_adn01=l_newno1
     LET g_adn02=l_newno2
     LET g_adn03=l_newno3
     CALL i185_b()
     #FUN-C80046---begin
     #LET g_adn01=l_oldno1
     #LET g_adn02=l_oldno2
     # LET g_adn03=l_oldno3     #MOD-4A0335
     #CALL i185_show()
     #FUN-C80046---end
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i185_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    sr              RECORD
        adn01       LIKE adn_file.adn01,   #料件編號
        adn02       LIKE adn_file.adn02,   #說明性質
        adn03       LIKE adn_file.adn03,   #廠商料件編號
        adn04       LIKE adn_file.adn04,   #行序
        adn05       LIKE adn_file.adn05,   #說明
        gen02       LIKE gen_file.gen02,
        adn06       LIKE adn_file.adn06,   #說明
        adn07       LIKE adn_file.adn07,   #說明
        adn08       LIKE adn_file.adn08,   #說明
        adn09       LIKE adn_file.adn09,   #說明
        adn10       LIKE adn_file.adn10,   #說明
        adn11       LIKE adn_file.adn11,   #說明
        adn12       LIKE adn_file.adn12,   #說明
        adnacti     LIKE adn_file.adnacti  #說明
                    END RECORD,
    l_name          LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)             #External(Disk) file name
     l_za05          LIKE za_file.za05      #NO.MOD-4B0067
 
 
    IF cl_null(g_wc) AND NOT cl_null(g_adn01) AND NOT cl_null(g_adn02)
       AND NOT cl_null(g_adn03) AND NOT cl_null(g_adn[l_ac].adn04) THEN
       LET g_wc = " adn01 = '",g_adn01,"' AND adn02 = '",g_adn02,"'",
                  " AND adn03 = '",g_adn03,"' AND adn04 = '",g_adn[l_ac].adn04,"'"
    END IF
    IF not cl_null(g_argv1) THEN
        LET g_wc = " adn01 ='",g_argv1,"'" CLIPPED
    END IF
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
 
    CALL cl_wait()
    CALL cl_outnam('atmi185') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT adn01,adn02,adn03,adn04,adn05,gen02,adn06,adn07,adn08,",
              "       adn09,adn10,adn11,adn12,adnacti                       ",
              " FROM adn_file ,OUTER gen_file ",  # 組合出 SQL 指令
              " WHERE adn05 = gen_file.gen01 AND ",g_wc CLIPPED,
              "   AND adnacti = 'Y' ",
              " ORDER BY adn01,adn02,adn03,adn04 "
    PREPARE i185_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
           
    END IF
    DECLARE i185_co                         # CURSOR
        CURSOR FOR i185_p1
 
    START REPORT i185_rep TO l_name
 
    FOREACH i185_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i185_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i185_rep
 
    CLOSE i185_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
}
#No.FUN-780056 -end
 
#No.FUN-780056 -str
#REPORT i185_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#    l_sw1           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#    l_i             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#    sr              RECORD
#                    adn01       LIKE adn_file.adn01,   #料件編號
#                    adn02       LIKE adn_file.adn02,   #說明性質
#                    adn03       LIKE adn_file.adn03,   #廠商料件編號
#                    adn04       LIKE adn_file.adn04,   #行序
#                    adn05       LIKE adn_file.adn05,   #說明
#                    gen02       LIKE gen_file.gen02,
#                    adn06       LIKE adn_file.adn06,   #說明
#                    adn07       LIKE adn_file.adn07,   #說明
#                    adn08       LIKE adn_file.adn08,   #說明
#                    adn09       LIKE adn_file.adn09,   #說明
#                    adn10       LIKE adn_file.adn10,   #說明
#                    adn11       LIKE adn_file.adn11,   #說明
#                    adn12       LIKE adn_file.adn12,   #說明
#                    adnacti     LIKE adn_file.adnacti  #說明
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.adn01,sr.adn02,sr.adn03,sr.adn04
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            PRINT ' '
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#                  g_x[35],g_x[36],g_x[37],g_x[38],
#                  g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.adn01
# #MOD-4B0067  --begin
#
#        BEFORE GROUP OF sr.adn02
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.adn01;
#            PRINT COLUMN g_c[32],sr.adn02;
#            PRINT COLUMN g_c[33],sr.adn03,
#                  COLUMN g_c[34],sr.adn04 USING '###&', #FUN-590118
#                  COLUMN g_c[35],sr.adn05,
#                  COLUMN g_c[36],sr.gen02,
#                  COLUMN g_c[37],sr.adn12,
#                  COLUMN g_c[38],sr.adn06,
#                  COLUMN g_c[39],sr.adn07,
#                  COLUMN g_c[40],sr.adn08,
#                  COLUMN g_c[41],sr.adn09,
#                  COLUMN g_c[42],sr.adn10 USING '#######&',
#                  COLUMN g_c[43],sr.adn11 USING '#######&'
# #MOD-4B0067  --end
#
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               PRINT g_dash[1,g_len]
#            #TQC-630166
#            {
#               IF g_sql[001,080] > ' ' THEN
#	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#               IF g_sql[071,140] > ' ' THEN
#	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#               IF g_sql[141,210] > ' ' THEN
#	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#            }
#              CALL cl_prt_pos_wc(g_sql)
#            #END TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-780056 -end
 
FUNCTION i185_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("adn01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i185_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("adn01",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002,003> #
