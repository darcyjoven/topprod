# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: abmi614.4gl
# Descriptions...: 成品材料屬性縮放比例維護作業 
# Date & Author..: 07/08/07  By arman
# Modify.........: No.FUN-810014 08/03/21 By arman
# Modify.........: No.FUN-830088 08/03/24 By arman
# Modify.........: No.FUN-830116 08/03/24 By arman 把兩個公式字段改成可手動輸入維護，
                                                  #然后不要自動彈出公式維護畫面，要用這個功能自己去點
# Modify.........: No.FUN-870127 08/07/24 By arman 服飾版
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時單身無資料提示是否刪除單頭
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_boe01         LIKE boe_file.boe01,   #主件款式     (假單頭)
    g_boe01_t       LIKE boe_file.boe01,   #主件款式 (舊值)
    g_boe02         LIKE boe_file.boe01,   #元件款式     (假單頭)
    g_boe02_t       LIKE boe_file.boe01,   #元件款式 (舊值)
    g_boe07_t       LIKE boe_file.boe07,   #主件款式 (舊值)
    g_boe08_t       LIKE boe_file.boe08,   #主件款式 (舊值)
    g_boe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        boe03       LIKE boe_file.boe03,   #主件屬性段一
        boe04       LIKE boe_file.boe04,   #主件屬性段二
        boe05       LIKE boe_file.boe05,   #主件屬性段三
        boe06       LIKE boe_file.boe06,   #部位
  boe06_bol02       LIKE bol_file.bol02,   #部位描述
        boe07       LIKE boe_file.boe07,   #用量縮放比例公式
        boe08       LIKE boe_file.boe08    #損耗率縮放比率公式
                    END RECORD,
    g_boe_t         RECORD                 #程式變數 (舊值)
        boe03       LIKE boe_file.boe03,   #主件屬性段一
        boe04       LIKE boe_file.boe04,   #主件屬性段二
        boe05       LIKE boe_file.boe05,   #主件屬性段三
        boe06       LIKE boe_file.boe06,   #部位
  boe06_bol02       LIKE bol_file.bol02,   #部位描述
        boe07       LIKE boe_file.boe07,   #用量縮放比例公式
        boe08       LIKE boe_file.boe08    #損耗率縮放比率公式
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,    #TQC-630166
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680096 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5,   #目前處理的SCREEN LINE      #No.FUN-680096 SMALLINT
    g_agb01         LIKE agb_file.agb01,                                                                       
    g_agb02         LIKE agb_file.agb02  
DEFINE l_sql        STRING   
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE l_i     LIKE type_file.num5
 
MAIN
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
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060

    LET g_boe01 = NULL                     #清除鍵值
    LET g_boe01_t = NULL
 
    OPEN WINDOW i614_w WITH FORM "abm/42f/abmi614"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_delete='N'
    CALL i614_menu()
    CLOSE WINDOW i614_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i614_cs()
DEFINE l_n    LIKE type_file.num5
    CLEAR FORM                             #清除畫面
    CALL g_boe.clear()
    CALL cl_set_comp_visible("boe03,boe04,boe05",TRUE)                                                                          
      FOR l_n=1 TO 3                                                                                                                   
        LET g_msg=NULL                                                                                                              
        CASE l_n                                                                                                                    
             WHEN '1'  SELECT ze03 INTO g_msg  FROM ze_file                                                                         
                       WHERE ze01='asmi001' AND ze02=g_lang                                                                         
                       CALL cl_set_comp_att_text('boe03',g_msg CLIPPED)                                                             
             WHEN '2'  SELECT ze03 INTO g_msg  FROM ze_file                                                                         
                       WHERE ze01='asmi002' AND ze02=g_lang                                                                         
                       CALL cl_set_comp_att_text('boe04',g_msg CLIPPED)                                                             
             WHEN '3'  SELECT ze03 INTO g_msg  FROM ze_file                                                                         
                       WHERE ze01='asmi003' AND ze02=g_lang                                                                         
                       CALL cl_set_comp_att_text('boe05',g_msg CLIPPED)                                                             
        END CASE                                                                                                                    
      END FOR 
    	CONSTRUCT g_wc ON boe01,boe02,boe03,boe04,boe05,boe06   #螢幕上取條件
        	FROM boe01,boe02,s_boe[1].boe03,s_boe[1].boe04,s_boe[1].boe05,s_boe[1].boe06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION CONTROLP                  
            CASE
                WHEN INFIELD(boe01)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_boe01"
                  #   LET g_qryparam.state = 'c'
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_boe01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO boe01
                     NEXT FIELD boe01
                WHEN INFIELD(boe02) 
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_boe01"
                  #   LET g_qryparam.state = 'c'
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_boe01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO boe02
                     NEXT FIELD boe02
                WHEN INFIELD(boe06) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_boe06"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO boe06
                     NEXT FIELD boe06
                OTHERWISE EXIT CASE
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
    	IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT UNIQUE boe01,boe02 FROM boe_file ", # 組合出 SQL 指令
               " WHERE ", g_wc CLIPPED,
               " ORDER BY boe01"
    PREPARE i614_prepare FROM g_sql      #預備一下
    DECLARE i614_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i614_prepare
#    LET g_sql="SELECT COUNT(DISTINCT boe01) ",
    LET g_sql="SELECT COUNT(DISTINCT boe01||boe02) ",     #No.FUN-830116
              "  FROM boe_file WHERE ", g_wc CLIPPED
    PREPARE i614_precount FROM g_sql
    DECLARE i614_count CURSOR FOR i614_precount
END FUNCTION
 
FUNCTION i614_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
      CALL i614_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i614_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i614_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i614_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i614_b()
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
               IF g_boe01 IS NOT NULL THEN
                  LET g_doc.column1 = "boe01"
                  LET g_doc.value1 = g_boe01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_boe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i614_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    LET g_boe01 =''
    LET g_boe02 =''
    CALL g_boe.clear()
    INITIALIZE g_boe01 LIKE boe_file.boe01
    LET g_boe01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
       	CALL i614_i("a")                   #輸入單頭
       	IF INT_FLAG THEN                   #使用者不玩了
                LET g_boe01 = NULL
           	LET INT_FLAG = 0
            	CALL cl_err('',9001,0)
            	EXIT WHILE
        END IF
        CALL g_boe.clear()
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2  
        CALL i614_b()                   #輸入單身
        LET g_boe01_t = g_boe01            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i614_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_boe01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_boe01_t = g_boe01
    WHILE TRUE
        CALL i614_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_boe01=g_boe01_t
            DISPLAY g_boe01 TO boe01      #單頭
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_boe01 != g_boe01_t THEN #更改單頭值
            UPDATE boe_file SET boe01 = g_boe01   #更新DB
                WHERE boe01 = g_boe01_t          #COLAUTH?
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_boe01,SQLCA.sqlcode,0)
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i614_i(p_cmd)
DEFINE
    p_cmd    LIKE type_file.chr1  
    CALL cl_set_head_visible("","YES")         
    INPUT g_boe01,g_boe02 WITHOUT DEFAULTS FROM boe01,boe02 
 
        BEFORE FIELD boe01  
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
	    IF g_sma.sma60 = 'Y'	
	       THEN CALL s_inp5(8,29,g_boe01) RETURNING g_boe01 
	            DISPLAY g_boe01 TO boe01 
	    END IF
 
        AFTER FIELD boe01          
            IF NOT cl_null(g_boe01) THEN
               #FUN-AA0059 -----------------------add start-----------------------------
                IF NOT s_chk_item_no(g_boe01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_boe01 = g_boe01_t
                   DISPLAY g_boe01 TO boe01
                   NEXT FIELD boe01
                END IF 
               #FUN-AA0059 -----------------------add end-----------------------------
                IF g_boe01 != g_boe01_t OR g_boe01_t IS NULL THEN
                    CALL i614_boe01('a')
                    IF NOT cl_null(g_errno) THEN
                        	CALL cl_err(g_boe01,g_errno,0)
                        	LET g_boe01 = g_boe01_t
                        	DISPLAY g_boe01 TO boe01 
                        	NEXT FIELD boe01
                    END IF
                END IF
                SELECT COUNT(*) INTO g_cnt FROM ima_file WHERE ima01=g_boe01
                                           AND ima151='Y' AND imaacti='Y'
                IF g_cnt <= 0 THEN #有效性檢查 
                   CALL cl_err(g_boe01,'aic-036',0)
                   LET g_boe01 = g_boe01_t
                   DISPLAY  g_boe01 TO boe01 
                   NEXT FIELD boe01
                END IF
                
            END IF
            CALL cl_set_comp_visible("boe03,boe04,boe05",TRUE)
            CALL i614_b_title() 
        AFTER FIELD boe02          
            IF NOT cl_null(g_boe02) THEN
               #FUN-AA0059 ------------------------add start--------------------
                IF NOT s_chk_item_no(g_boe02,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_boe02 = g_boe02_t
                   DISPLAY g_boe01 TO boe02
                   NEXT FIELD boe02
                END IF 
               #FUN-AA0059 -----------------------add end----------------------- 
                IF g_boe02 != g_boe02_t OR g_boe02_t IS NULL THEN
                    CALL i614_boe02('a')
                    IF NOT cl_null(g_errno) THEN
                        	CALL cl_err(g_boe02,g_errno,0)
                        	LET g_boe02 = g_boe02_t
                        	DISPLAY g_boe01 TO boe02 
                        	NEXT FIELD boe02
                    END IF
                END IF
                SELECT COUNT(*) INTO g_cnt FROM ima_file WHERE ima01=g_boe02
                                           AND ima151='Y' AND imaacti='Y'
                IF g_cnt <= 0 THEN    #有效性檢查 
                   CALL cl_err(g_boe02,'aic-036',0)
                   LET g_boe02 = g_boe02_t
                   DISPLAY  g_boe02 TO boe02 
                   NEXT FIELD boe02
                END IF
            END IF
        ON ACTION CONTROLP                  
            CASE
                WHEN INFIELD(boe01)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_boe01"
                  #   LET g_qryparam.default1 = ''
                  #   CALL cl_create_qry() RETURNING g_boe01 
                     CALL q_sel_ima(FALSE, "q_boe01", "", '', "", "", "", "" ,"",'' )  RETURNING g_boe01
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_boe01 
                     NEXT FIELD boe01
                WHEN INFIELD(boe02)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_boe01" 
                  #   LET  g_qryparam.arg1 = g_boe01
                  #   LET g_qryparam.default1 = ''
                  #   CALL cl_create_qry() RETURNING g_boe02 
                     CALL q_sel_ima(FALSE, "q_boe01", "", '', g_boe01, "", "", "" ,"",'' )  RETURNING g_boe02 
#FUN-AA0059 --End--
                     DISPLAY g_boe02 TO boe02 
                     NEXT FIELD boe02
                OTHERWISE EXIT CASE
            END CASE
   
        ON ACTION CONTROLF                  #欄位說明
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
   
FUNCTION i614_boe01(p_cmd)  #規格主件編號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_imaag   LIKE ima_file.imaag,
           l_aga02   LIKE aga_file.aga02,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,imaag,imaacti INTO l_ima02,l_imaag,l_imaacti  FROM ima_file WHERE ima01= g_boe01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL 
                            LET l_imaag = NULL 
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT aga02 INTO l_aga02 FROM  aga_file,ima_file WHERE aga01= imaag AND ima01=g_boe01
           DISPLAY l_ima02 TO FORMONLY.boe01_ima02 
           DISPLAY l_imaag  TO FORMONLY.boe01_imaag 
           DISPLAY l_aga02  TO FORMONLY.boe01_imaag_aga02 
    END IF
END FUNCTION
FUNCTION i614_boe02(p_cmd)  #規格主件編號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_imaag   LIKE ima_file.imaag,
           l_aga02   LIKE aga_file.aga02,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,imaag,imaacti INTO l_ima02,l_imaag,l_imaacti  FROM ima_file WHERE ima01= g_boe02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL 
                            LET l_imaag = NULL 
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT aga02 INTO l_aga02 FROM  aga_file,ima_file WHERE aga01= imaag AND ima01=g_boe02
           DISPLAY l_ima02 TO FORMONLY.boe02_ima02 
           DISPLAY l_imaag  TO FORMONLY.boe02_imaag 
           DISPLAY l_aga02  TO FORMONLY.boe02_imaag_aga02 
    END IF
END FUNCTION
 
FUNCTION i614_boe06(p_cmd)  #規格主件編號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_bol02   LIKE bol_file.bol02 
 
    LET g_errno = ' '
     SELECT bol02  INTO l_bol02 FROM  bol_file WHERE  bol01=g_boe[l_ac].boe06 and bolacti='Y'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_bol02 = NULL 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
          LET g_boe[l_ac].boe06_bol02 = l_bol02
          DISPLAY BY NAME  g_boe[l_ac].boe06_bol02
    END IF
END FUNCTION
#Query 查詢
FUNCTION i614_q()
  DEFINE l_boe01  LIKE boe_file.boe01,
         l_cnt    LIKE type_file.num10   #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_boe01 TO NULL             #No.FUN-6A0002
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i614_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_boe01 TO NULL
        RETURN
    END IF
    OPEN i614_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_boe01 TO NULL
    ELSE
        CALL i614_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i614_count
        FETCH i614_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i614_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1       #處理方式   #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i614_bcs INTO g_boe01,g_boe02
        WHEN 'P' FETCH PREVIOUS i614_bcs INTO g_boe01,g_boe02
        WHEN 'F' FETCH FIRST    i614_bcs INTO g_boe01,g_boe02
        WHEN 'L' FETCH LAST     i614_bcs INTO g_boe01,g_boe02
        WHEN '/' 
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i614_bcs INTO g_boe01,g_boe02  #No.FUN-870127
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_boe01,SQLCA.sqlcode,0)
        INITIALIZE g_boe01 TO NULL  #TQC-6B0105
    ELSE
        OPEN i614_count
        FETCH i614_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i614_show()
        CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i614_show()
    DEFINE l_cnt    LIKE type_file.num10    #處理方式  #No.FUN-680096 INTEGER
 
    SELECT COUNT(*) INTO l_cnt FROM boe_file WHERE boe01=g_boe01
    IF l_cnt=0 THEN LET g_boe01= NULL END IF
    DISPLAY g_boe01 TO boe01 
    DISPLAY g_boe02 TO boe02 
     CALL i614_boe01('d')
     CALL i614_boe02('d')
     CALL i614_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i614_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_boe01 IS NULL THEN
       CALL cl_err("",-400,0)                      #No.FUN-6A0002
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "boe01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_boe01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
#       DELETE FROM boe_file WHERE boe01 = g_boe01 
        DELETE FROM boe_file WHERE boe01 = g_boe01 AND boe02 = g_boe02      #No.FUN-830116 
        IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
        ELSE
            CLEAR FORM
            CALL g_boe.clear()
            OPEN i614_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i614_bcs
               CLOSE i614_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i614_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i614_bcs
               CLOSE i614_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i614_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i614_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL i614_fetch('/')
            END IF
            LET g_delete='Y'
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION
 
FUNCTION i614_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態     #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否     #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否     #No.FUN-680096 SMALLINT
DEFINE l_sql        STRING   
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_boe01 IS NULL THEN
        RETURN
    END IF
    CALL i614_auto_b()
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
       "SELECT boe03,boe04,boe05,boe06,'',boe07,boe08 ",
       "FROM boe_file  ",
       "WHERE boe01=? AND boe02=? AND boe03=? AND boe04=? AND boe05=? AND boe06=? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i614_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_boe WITHOUT DEFAULTS FROM s_boe.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,
                        DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET g_boe_t.* = g_boe[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
                LET l_sql = "SELECT boe01,boe02,boe03,boe04,boe05,boe06 FROM boe_file ",
                            " WHERE boe01 = '",g_boe01,"' ",
                            "   AND boe02 = '",g_boe02,"' ",
                            "   AND boe03 = '",g_boe_t.boe03,"' "
                IF g_boe_t.boe04  IS NULL THEN
                  LET l_sql = l_sql,"AND boe04 IS NULL "
                ELSE 
                  LET l_sql = l_sql,"AND boe04 = '",g_boe_t.boe04,"'"
                END IF 
                  
                IF g_boe_t.boe05 IS NULL THEN
                  LET l_sql = l_sql,"AND boe05 IS NULL "
                ELSE 
                  LET l_sql = l_sql,"AND boe05 = '",g_boe_t.boe05,"'"
                END IF 
 
                IF g_boe_t.boe06 IS NULL THEN
                  LET l_sql = l_sql,"AND boe06 IS NULL "
                ELSE 
                  LET l_sql = l_sql,"AND boe06 = '",g_boe_t.boe06,"'"
                END IF 
                #No.CHI-950007  --Begin
                PREPARE i614_prepare_r FROM l_sql      #預備一下
               #DECLARE boe_cs_r CURSOR FOR i614_prepare_r
               #EXECUTE boe_cs_r INTO g_boe01,g_boe02,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06
                EXECUTE i614_prepare_r INTO g_boe01,g_boe02,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06
                #No.CHI-950007  --End  
                OPEN i614_bcl USING g_boe01,g_boe02,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06 
                IF STATUS THEN
                    CALL cl_err("OPEN i614_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i614_bcl INTO g_boe[l_ac].* 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_boe02_t,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                SELECT bol02  INTO g_boe[l_ac].boe06_bol02 FROM  bol_file WHERE  bol01=g_boe[l_ac].boe06 and bolacti='Y'
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_boe[l_ac].boe03 IS NULL THEN
               LET  g_boe[l_ac].boe03 = ' ' 
            END IF    
            IF g_boe[l_ac].boe04 IS NULL THEN
               LET  g_boe[l_ac].boe04 = ' ' 
            END IF    
            IF g_boe[l_ac].boe05 IS NULL THEN
               LET  g_boe[l_ac].boe05 = ' ' 
            END IF    
            IF g_boe[l_ac].boe07 IS NULL THEN
               LET  g_boe[l_ac].boe07 = ' ' 
            END IF    
            IF g_boe[l_ac].boe08 IS NULL THEN
               LET  g_boe[l_ac].boe08 = ' ' 
            END IF    
             INSERT INTO boe_file (boe01,boe02,boe03,boe04,boe05,boe06,boe07,boe08)  #No.MOD-470041
                 VALUES(g_boe01,g_boe02,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06,g_boe[l_ac].boe07,g_boe[l_ac].boe08)
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_boe02,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_boe[l_ac].* TO NULL      #900423
            LET g_boe_t.* = g_boe[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD boe03
        AFTER FIELD boe03
           IF NOT cl_null(g_boe[l_ac].boe03) THEN
            SELECT count(*) INTO l_n  FROM agd_file,agc_file,aga_file,agb_file,ima_file 
             WHERE (agd02 = g_boe[l_ac].boe03 AND agd01=agc01 AND agc04='2'
               AND agc01=agb03 AND agb02=1 AND agb01=aga01 
               AND aga01=imaag AND ima01=g_boe01) OR ((g_boe[l_ac].boe03
               BETWEEN agc05 AND agc06) AND agc04='3' AND agc01=agb03 AND agb02=1
               AND agb01=aga01 AND aga01=imaag AND ima01=g_boe01)
               OR (agc04='1' AND agc01=agb03 AND agb02=1 AND agb01=aga01
               AND aga01=imaag AND ima01=g_boe01)
                IF l_n <= 0 THEN #有效性檢查 
                   CALL cl_err('','abm-300',0)
                   NEXT FIELD boe03
                END IF
             END IF
        AFTER FIELD boe04
           IF NOT cl_null(g_boe[l_ac].boe04) THEN
            SELECT count(*) INTO l_n  FROM agd_file,agc_file,aga_file,agb_file,ima_file 
             WHERE (agd02 = g_boe[l_ac].boe04 AND agd01=agc01 AND agc04='2'
               AND agc01=agb03 AND agb02=2 AND agb01=aga01 
               AND aga01=imaag AND ima01=g_boe01) OR ((g_boe[l_ac].boe04
               BETWEEN agc05 AND agc06) AND agc04='3' AND agc01=agb03 AND agb02=2
               AND agb01=aga01 AND aga01=imaag AND ima01=g_boe01)
               OR (agc04='1' AND agc01=agb03 AND agb02=2 AND agb01=aga01
               AND aga01=imaag AND ima01=g_boe01)
                IF l_n <= 0 THEN #有效性檢查 
                   CALL cl_err('','abm-300',0)
                   NEXT FIELD boe04
                END IF
             END IF
        AFTER FIELD boe05
           IF NOT cl_null(g_boe[l_ac].boe05) THEN
            SELECT count(*) INTO l_n  FROM agd_file,agc_file,aga_file,agb_file,ima_file 
             WHERE (agd02 = g_boe[l_ac].boe05 AND agd01=agc01 AND agc04='2'
               AND agc01=agb03 AND agb02=3 AND agb01=aga01 
               AND aga01=imaag AND ima01=g_boe01) OR ((g_boe[l_ac].boe05
               BETWEEN agc05 AND agc06) AND agc04='3' AND agc01=agb03 AND agb02=3
               AND agb01=aga01 AND aga01=imaag AND ima01=g_boe01)
               OR (agc04='1' AND agc01=agb03 AND agb02=3 AND agb01=aga01
               AND aga01=imaag AND ima01=g_boe01)
                IF l_n <= 0 THEN #有效性檢查 
                   CALL cl_err('','abm-300',0)
                   NEXT FIELD boe05
                END IF
             END IF
        AFTER FIELD boe06
            IF NOT cl_null(g_boe[l_ac].boe06) THEN 
                CALL i614_boe06('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_boe[l_ac].boe06,'abm-313',0)
                    NEXT FIELD boe06
                END IF
                SELECT COUNT(*) INTO l_n FROM  bol_file WHERE bolacti='Y'
                                          AND bol01=g_boe[l_ac].boe06
 
                IF l_n <= 0 THEN #有效性檢查 
                   CALL cl_err('','abm-313',0)
                   NEXT FIELD boe06
                END IF
            ELSE 
                LET g_boe[l_ac].boe06 = ' '
            END IF
#NO.FUN-830116 ---begin
#           BEFORE FIELD boe07
#NO.FUN-830088  begin
#           IF cl_null(g_boe[l_ac].boe07)  THEN
#              CALL i614_ylsfbl(g_boe[l_ac].boe07,g_boe01,g_boe02,g_lang,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06)
#              RETURNING g_boe[l_ac].boe07
#              IF g_boe07_t IS NOT NULL THEN
#                 LET g_boe[l_ac].boe07 = g_boe07_t
#              END IF
#              #SELECT boe07 INTO g_boe[l_ac].boe07 FROM boe_file WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe[l_ac].boe03 AND boe04=g_boe[l_ac].boe04 AND boe05=g_boe[l_ac].boe05 AND boe06=g_boe[l_ac].boe06
#              DISPLAY BY NAME g_boe[l_ac].boe07
#           END IF
#           AFTER FIELD boe07
#              SELECT boe07 INTO g_boe[l_ac].boe07 FROM boe_file WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe[l_ac].boe03 AND boe04=g_boe[l_ac].boe04 AND boe05=g_boe[l_ac].boe05 AND boe06=g_boe[l_ac].boe06
#              DISPLAY BY NAME g_boe[l_ac].boe07
#           
#NO.FUN-830088 end
#           BEFORE FIELD boe08
#NO.FUN-830088 begin
#           IF cl_null(g_boe[l_ac].boe08) THEN
#              CALL i614_shlsfbl(g_boe[l_ac].boe08,g_boe01,g_boe02,g_lang,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06)
#              RETURNING g_boe08_t
#              IF g_boe08_t IS NOT NULL THEN
#                 LET g_boe[l_ac].boe08 = g_boe08_t
#              END IF
#              SELECT boe08 INTO g_boe[l_ac].boe08 FROM boe_file WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe[l_ac].boe03 AND boe04=g_boe[l_ac].boe04 AND boe05=g_boe[l_ac].boe05 AND boe06=g_boe[l_ac].boe06
#              DISPLAY BY NAME g_boe[l_ac].boe08
#           END IF
#          AFTER FIELD boe08
#              SELECT boe08 INTO g_boe[l_ac].boe08 FROM boe_file WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe[l_ac].boe03 AND boe04=g_boe[l_ac].boe04 AND boe05=g_boe[l_ac].boe05 AND boe06=g_boe[l_ac].boe06
#              DISPLAY BY NAME g_boe[l_ac].boe08
#NO.FUN-830088 end
#NO.FUN-830116 end
        BEFORE DELETE                            #是否取消單身
            IF g_boe_t.boe03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM boe_file
                    WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe[l_ac].boe03 AND boe04=g_boe[l_ac].boe04 AND boe05=g_boe[l_ac].boe05 AND boe06=g_boe[l_ac].boe06 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_boe_t.boe03,SQLCA.sqlcode,0)
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
               LET g_boe[l_ac].* = g_boe_t.*
               CLOSE i614_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_boe02,-263,1)
                LET g_boe[l_ac].* = g_boe_t.*
            ELSE
                UPDATE boe_file SET
                       boe03 = g_boe[l_ac].boe03,
                       boe04 = g_boe[l_ac].boe04,
                       boe05 = g_boe[l_ac].boe05,
                       boe06 = g_boe[l_ac].boe06, 
#No.FUN-830116 ---begin
                       boe07 = g_boe[l_ac].boe07,
                       boe08 = g_boe[l_ac].boe08 
#No.FUN-830116 ---end 
                 WHERE g_boe01=g_boe01 AND boe02=g_boe02 
                   AND boe03=g_boe_t.boe03 AND boe04=g_boe_t.boe04 
                   AND boe05=g_boe_t.boe05 AND boe06=g_boe_t.boe06
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_boe02,SQLCA.sqlcode,0)
                    LET g_boe[l_ac].* = g_boe_t.*
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
                  LET g_boe[l_ac].* = g_boe_t.*   
               #FUN-D40030--add--str--
               ELSE
                  CALL g_boe.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i614_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_boe_t.* = g_boe[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i614_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i614_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(boe02) AND l_ac > 1 THEN
                LET g_boe[l_ac].* = g_boe[l_ac-1].*
                NEXT FIELD boe02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(boe03) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_boe03"
                     LET g_qryparam.default1 = ''
                     LET g_qryparam.arg1 = g_boe01
                     CALL cl_create_qry() RETURNING g_boe[l_ac].boe03
                     CALL FGL_DIALOG_SETBUFFER(g_boe[l_ac].boe03) 
                     DISPLAY BY NAME g_boe[l_ac].boe03 
                     NEXT FIELD boe03
                WHEN INFIELD(boe04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_boe04"
                     LET g_qryparam.default1 = ''
                     LET g_qryparam.arg1 = g_boe01
                     CALL cl_create_qry() RETURNING g_boe[l_ac].boe04 
                     CALL FGL_DIALOG_SETBUFFER(g_boe[l_ac].boe04) 
                     DISPLAY BY NAME g_boe[l_ac].boe04 
                     NEXT FIELD boe04
                WHEN INFIELD(boe05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_boe05"   #NO.FUN-830116
                     LET g_qryparam.default1 = ''
                     LET g_qryparam.arg1 = g_boe01
                     CALL cl_create_qry() RETURNING g_boe[l_ac].boe05 
                     CALL FGL_DIALOG_SETBUFFER(g_boe[l_ac].boe05) 
                     DISPLAY BY NAME g_boe[l_ac].boe05 
                     NEXT FIELD boe05
                WHEN INFIELD(boe06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_boe06"
                     LET g_qryparam.default1 = ''
                     CALL cl_create_qry() RETURNING g_boe[l_ac].boe06 
                     CALL FGL_DIALOG_SETBUFFER(g_boe[l_ac].boe06) 
                     DISPLAY BY NAME g_boe[l_ac].boe06 
                     NEXT FIELD boe06
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
      ON ACTION ylsfbl
               CALL i614_ylsfbl(g_boe[l_ac].boe07,g_boe01,g_boe02,g_lang,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06)
               RETURNING g_boe07_t
               IF g_boe07_t IS NOT NULL THEN
                  LET g_boe[l_ac].boe07 = g_boe07_t
               END IF
              #SELECT boe07 INTO g_boe[l_ac].boe07 FROM boe_file WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe[l_ac].boe03 AND boe04=g_boe[l_ac].boe04 AND boe05=g_boe[l_ac].boe05 AND boe06=g_boe[l_ac].boe06
               DISPLAY BY NAME g_boe[l_ac].boe07
      ON ACTION shlsfbl
               CALL i614_shlsfbl(g_boe[l_ac].boe08,g_boe01,g_boe02,g_lang,g_boe[l_ac].boe03,g_boe[l_ac].boe04,g_boe[l_ac].boe05,g_boe[l_ac].boe06)
               RETURNING g_boe08_t
               IF g_boe08_t IS NOT NULL THEN
                  LET g_boe[l_ac].boe08 = g_boe08_t
               END IF
#              SELECT boe08 INTO g_boe[l_ac].boe08 FROM boe_file WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe[l_ac].boe03 AND boe04=g_boe[l_ac].boe04 AND boe05=g_boe[l_ac].boe05 AND boe06=g_boe[l_ac].boe06
               DISPLAY BY NAME g_boe[l_ac].boe08
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033    
 
        END INPUT
 
    CLOSE i614_bcl
	COMMIT WORK
    CALL i614_delHeader()   #CHI-C30002  add
END FUNCTION

#CHI-C30002 --------- add ----------- begin
FUNCTION i614_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM boe_file WHERE boe01 = g_boe01 
                                AND boe02 = g_boe02
         LET g_boe01 = NULL
         LET g_boe02 = NULL
         CLEAR FORM
      END IF
   END IF 
END FUNCTION
#CHI-C30002 --------- add ----------- end
   
FUNCTION i614_b_askkey()
DEFINE
   #l_wc            LIKE type_file.chr1000#TQC-630166        #No.FUN-680096
    l_wc            STRING   #TQC-630166
 
    CONSTRUCT l_wc ON boe03,boe04,boe05,boe06,boe07,boe08                               #螢幕上取條件
       FROM s_boe[1].boe03,s_boe[1].boe04,s_boe[1].boe05,s_boe[1].boe06,s_boe[1].boe07,s_boe[1].boe08
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
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i614_bf(l_wc)
END FUNCTION
 
FUNCTION i614_bf(p_wc)              #BODY FILL UP
DEFINE
   #p_wc      	    LIKE type_file.chr1000#TQC-630166        #No.FUN-680096
    p_wc      	    STRING    #TQC-630166
 
    LET g_sql = "SELECT boe03,boe04,boe05,boe06,'',boe07,boe08 FROM boe_file ",
#      " WHERE boe01 = '",g_boe01,"' AND ",p_wc CLIPPED ,
       " WHERE boe01 = '",g_boe01,"' AND boe02 = '",g_boe02,"' AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i614_prepare2 FROM g_sql      #預備一下
    DECLARE boe_cs CURSOR FOR i614_prepare2
    CALL g_boe.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    CALL cl_set_comp_visible("boe03,boe04,boe05",TRUE)
    CALL i614_b_title()
    FOREACH boe_cs INTO g_boe[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT bol02  INTO g_boe[g_cnt].boe06_bol02 FROM  bol_file
         WHERE  bol01=g_boe[g_cnt].boe06 and bolacti='Y'
        LET g_cnt = g_cnt + 1
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_boe.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i614_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_boe TO s_boe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         CALL i614_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i614_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i614_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i614_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i614_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #No.FUN-6C0055 --start--
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
#           CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         #No.FUN-6C0055 --end--
 
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
 
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
#     ON ACTION ylsfbl
#       LET g_action_choice="ylsfbl"
#       EXIT DISPLAY
#     ON ACTION shlsfbl
#       LET g_action_choice="shlsfbl"
#       EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i614_copy()
DEFINE
    l_oldno1         LIKE boe_file.boe01,
    l_newno1         LIKE boe_file.boe01
 
    IF s_shut(0) THEN RETURN END IF             #檢查權限
    IF g_boe01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0033
    INPUT l_newno1  FROM boe01
 
        BEFORE FIELD boe01
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(8,29,l_newno1) RETURNING l_newno1
	            DISPLAY l_newno1 TO boe01 
	    END IF
 
        AFTER FIELD boe01
            IF cl_null(l_newno1) THEN
                NEXT FIELD boe01
            END IF
            #FUN-AA0059 --------------------------add start--------------------
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD boe01
            END IF 
            #FUN-AA0059 -------------------------add end---------------------- 
	       IF l_newno1 !='*' THEN
	          SELECT * FROM ima_file
                   WHERE ima01 = l_newno1 
	           IF SQLCA.sqlcode THEN 
	              CALL cl_err(l_newno1,'mfg2727',0)
		          NEXT FIELD boe01
	           END IF
           END IF
	
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
    	CALL i614_show()
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM boe_file
        WHERE boe01=g_boe01
          AND boe02=g_boe02
        INTO TEMP x
    UPDATE x
        SET boe01=l_newno1     #資料鍵值
    INSERT INTO boe_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_boe01,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K' 
        LET l_oldno1 = g_boe01
        LET g_boe01 = l_newno1
	IF g_chkey = 'Y' THEN CALL i614_u() END IF
        CALL i614_b()
        #LET g_boe01 = l_oldno1   #FUN-C30027
        #CALL i614_show()         #FUN-C30027
    END IF
END FUNCTION
{   
FUNCTION i614_out()
DEFINE
    sr              RECORD
        boe01       LIKE boe_file.boe01,   #規格主件編號
        boe02       LIKE boe_file.boe02,   #特性料件編號
        boe03       LIKE boe_file.boe03,   #行序
        bmi02       LIKE bmi_file.bmi02 
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
 
    IF cl_null(g_wc) THEN 
        LET g_wc=" boe01='",g_boe01,"'" 
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT boe01,boe02,boe03,bmi02",
              " FROM boe_file, OUTER bmi_file ",          # 組合出 SQL 指令
              " WHERE boe03=bmi_file.bmi01 AND ",g_wc CLIPPED
    PREPARE i614_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i614_co                         # CURSOR
        CURSOR FOR i614_p1
 
    CALL cl_outnam('abmi614') RETURNING l_name
    START REPORT i614_rep TO l_name
 
    FOREACH i614_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i614_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i614_rep
 
    CLOSE i614_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i614_rep(sr)
   DEFINE l_ima02      LIKE ima_file.ima02  #FUN-510017
   DEFINE l_ima021     LIKE ima_file.ima021 #FUN-510017
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1) 
    sr              RECORD
        boe01       LIKE boe_file.boe01,   #規格主件編號
        boe02       LIKE boe_file.boe02,   #特性料件編號
        boe03       LIKE boe_file.boe03,   #行序
        bmi02       LIKE bmi_file.bmi02    #條件編號
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.boe01,sr.boe02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED  ))/2)+1 , g_company CLIPPED  
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
            PRINT 
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.boe01
            SELECT ima02,ima021 INTO l_ima02,l_ima021
              FROM ima_file
             WHERE ima01 = sr.boe01
            IF SQLCA.sqlcode THEN
                LET l_ima02  = NULL
                LET l_ima021 = NULL
            END IF
            PRINT COLUMN g_c[31],sr.boe01,
                  COLUMN g_c[32],l_ima02,
                  COLUMN g_c[33],l_ima021;
 
        ON EVERY ROW
            PRINT COLUMN g_c[34],sr.boe02 USING '###&',
                  COLUMN g_c[35],sr.boe03,
                  COLUMN g_c[36],sr.bmi02
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash
                   #IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED      #No.TQC-740079
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED      #No.TQC-740079
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[6] CLIPPED      #No.TQC-740079
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED      #No.TQC-740079
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
FUNCTION i614_b_title()
DEFINE 
    l_j             LIKE type_file.num5,
    l_msg           LIKE type_file.chr1000,
    l_mag           LIKE type_file.chr1000,
    l_chr           LIKE type_file.chr3,
    l_agbslk01     LIKE type_file.chr1
    
    INITIALIZE g_agb02 TO NULL 
    
    SELECT agb01 INTO g_agb01 
    FROM agb_file,ima_file
    WHERE ima01=g_boe01
    AND imaag=agb01  
    FOR l_i =1 TO 3
      LET l_chr = l_i + 2
      LET l_msg = "boe0",l_chr CLIPPED
      SELECT agbslk01,agb02 INTO l_agbslk01,g_agb02 FROM agb_file,ima_file 
        WHERE ima01=g_boe01 AND agb02 = l_i
          AND imaag=agb01  
      IF l_agbslk01 = 'N' OR cl_null(g_agb02)  THEN  
          CALL cl_set_comp_visible(l_msg,FALSE)
      ELSE
      	 SELECT agc02 INTO l_mag FROM agb_file,agc_file WHERE agb02=l_i
            AND agb01=g_agb01
            AND agc_file.agc01=agb03 
         CALL cl_set_comp_att_text(l_msg,l_mag CLIPPED) 
      END IF 
      LET g_agb02 = NULL        
     END FOR   
END FUNCTION 
 
FUNCTION i614_auto_b()
DEFINE  l_k    LIKE type_file.num5
DEFINE  l_h    LIKE type_file.num5
DEFINE  i      LIKE type_file.num5
DEFINE  j      LIKE type_file.num5
DEFINE  k      LIKE type_file.num5
DEFINE  l_m    LIKE type_file.num5
DEFINE  g_boe03         ARRAY[100] OF LIKE boe_file.boe03,                                                                       
        g_boe04         ARRAY[100] OF LIKE boe_file.boe04, 
        g_boe05         ARRAY[100] OF LIKE boe_file.boe05  
  IF g_rec_b  <>0 THEN
     RETURN
  END IF
    LET l_k = 1
    DECLARE i614_auto_b_1 CURSOR FOR 
    SELECT agd02 FROM  agd_file,agb_file WHERE agb02 = '1'
       AND agb01 = g_agb01
       AND agd01 = agb03 AND agb_file.agbslk01 ='Y'
    FOREACH i614_auto_b_1 INTO g_boe03[l_k]
      IF SQLCA.sqlcode THEN                                                   
              CALL cl_err('Foreach:',SQLCA.sqlcode,1)                             
              EXIT FOREACH                                                        
          END IF                                                                  
          LET l_k = l_k + 1
    END FOREACH
    CLOSE i614_auto_b_1 
    LET l_h = 1
    DECLARE i614_auto_b_2 CURSOR FOR 
    SELECT agd02 FROM  agd_file,agb_file WHERE agb02 = '2'
       AND agb01 = g_agb01
       AND agd01 = agb03 AND agb_file.agbslk01='Y'
    FOREACH i614_auto_b_2 INTO g_boe04[l_h]
      IF SQLCA.sqlcode THEN                                                   
              CALL cl_err('Foreach:',SQLCA.sqlcode,1)                             
              EXIT FOREACH                                                        
          END IF                                                                  
          LET l_h = l_h + 1
    END FOREACH
    CLOSE i614_auto_b_2 
    LET l_m = 1 
    DECLARE i614_auto_b_3 CURSOR FOR 
    SELECT agd02 FROM  agd_file,agb_file WHERE agb02 = '3'
       AND agb01 = g_agb01
       AND agd01 = agb03 AND agb_file.agbslk01 = 'Y'
    FOREACH i614_auto_b_3 INTO g_boe05[l_m]
      IF SQLCA.sqlcode THEN                                                   
              CALL cl_err('Foreach:',SQLCA.sqlcode,1)                             
              EXIT FOREACH                                                        
          END IF                                                                  
          LET l_m = l_m + 1
    END FOREACH
    CLOSE i614_auto_b_3 
    IF l_k <>1 THEN
     LET l_k = l_k-1
    END IF
    IF l_h <>1 THEN
      LET l_h = l_h-1
    END IF
    IF l_m <>1 THEN
     LET  l_m = l_m-1
    END IF
    FOR i=1 TO l_k
     FOR j=1 TO l_h
      FOR k=1 TO l_m
       IF g_boe03[i] IS NULL THEN
         LET g_boe03[i] =" " 
       END IF
       IF g_boe04[j] IS NULL THEN
         LET g_boe04[j] = " "
       END IF
       IF g_boe05[k] IS NULL THEN
         LET g_boe05[k] = " "
       END IF
       INSERT INTO boe_file(boe01,boe02,boe03,boe04,boe05,boe06) 
                    VALUES (g_boe01,g_boe02,g_boe03[i],g_boe04[j],g_boe05[k],' ')
      END FOR
     END FOR
    END FOR
    CALL i614_bf(g_wc)
END FUNCTION
#NO.FUN-810014
#No.FUN-870127
