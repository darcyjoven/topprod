# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsi331.4gl
# Descriptions...: APS 途程製程指定工模具
# Date & Author..: FUN-880102  08/09/30 By DUKE
# Modify.........: FUN-8A0040  08/10/08 BY DUKE 輸入vnm04時,需檢核只要有存在vnm04的,都不允許輸入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50101 11/05/18 By Mandy GP5.25 平行製程 影響APS程式調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_vnm00         LIKE vnm_file.vnm00,   #FUN-880102
    g_vnm00_t       LIKE vnm_file.vnm00,   #
    g_vnm01         LIKE vnm_file.vnm01,   #FUN-880102
    g_vnm01_t       LIKE vnm_file.vnm01,   #
    g_vnm02         LIKE vnm_file.vnm02,   #FUN-880102
    g_vnm02_t       LIKE vnm_file.vnm02,   #
    g_vnm03         LIKE vnm_file.vnm03,   #FUN-880102
    g_vnm03_t       LIKE vnm_file.vnm03,   #
    g_vnm012        LIKE vnm_file.vnm012,  #FUN-B50101 add
    g_vnm012_t      LIKE vnm_file.vnm012,  #FUN-B50101 add
    g_vnm04_o       LIKE vnm_file.vnm04,
    g_vnm06_o       LIKE vnm_file.vnm06,
    g_vnm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        vnm06       LIKE vnm_file.vnm06,   #
        vnm04       LIKE vnm_file.vnm04   
                    END RECORD,
    g_vnm_t         RECORD                 #程式變數 (舊值)
        vnm06       LIKE vnm_file.vnm06,   #
        vnm04       LIKE vnm_file.vnm04
                    END RECORD,
    g_wc,g_wc2,g_sql    string,            #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數   #No.FUN-680096 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    g_ss            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_argv1         LIKE vnm_file.vnm00,
    g_argv2         LIKE vnm_file.vnm01,
    g_argv3          string,
    l_seq           LIKE type_file.num5,
    g_argv4         LIKE vnm_file.vnm03,
    g_argv5         LIKE vnm_file.vnm012,  #FUN-B50101 add
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(100)
    g_ls            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1) 
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg        LIKE ze_file.ze03      #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
MAIN
# DEFINE                                       #No.FUN-6A0060 
#       l_time    LIKE type_file.chr8          #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
    LET g_vnm00 = NULL                     #清除鍵值
    LET g_vnm00_t = NULL
    LET g_vnm01 = NULL                     #清除鍵值
    LET g_vnm01_t = NULL
    LET g_vnm02 = NULL                     #清除鍵值
    LET g_vnm02_t = NULL
    LET g_vnm03 = NULL                     #清除鍵值
    LET g_vnm03_t = NULL
    LET g_vnm012 = NULL                    #清除鍵值 #FUN-B50101 add
    LET g_vnm012_t = NULL                            #FUN-B50101 add
 
 
	#取得參數
	LET g_argv1=ARG_VAL(1)	#品號
        LET g_argv2=ARG_VAL(2)  #途程製程
        LET g_argv3=ARG_VAL(3)  #加工序號
        LET g_argv3=g_argv3.trim()
        LET g_argv4=ARG_VAL(4)  #作業編號
        LET g_argv5=ARG_VAL(5)  #製程段號 #FUN-B50101 add
        #LET g_argv1='00000'
        #LET g_argv2='TEST'
        #LET g_argv3='3'
        #LET g_argv4='1001'
 
 
	IF g_argv1=' ' THEN 
           LET g_argv1='' 
           LET g_argv2=''
           LET g_argv3=''
           LET g_argv4=''
           LET g_argv5='' #FUN-B50101 add
        ELSE 
           LET g_vnm00=g_argv1 
           LET g_vnm01=g_argv2
           LET g_vnm02=g_argv3 
           LET g_vnm03=g_argv4
           LET g_vnm012=g_argv5 #FUN-B50101 add
        END IF
        DISPLAY 'g_vnm00=',g_vnm00
        DISPLAY 'g_vnm01=',g_vnm01
        DISPLAY 'g_vnm02=',g_vnm02
        DISPLAY 'g_vnm03=',g_vnm03
        DISPLAY 'g_vnm012=',g_vnm012 #FUN-B50101 add
 
 
 
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i331_w AT p_row,p_col WITH FORM "aps/42f/apsi331"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    CALL cl_set_comp_visible("vnm012",g_sma.sma541='Y')  #FUN-B50101 add
 
 
    IF NOT cl_null(g_argv1) THEN CALL i331_q() END IF
 
    LET g_delete='N'
    CALL i331_menu()
    CLOSE WINDOW i331_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i331_cs()
    IF cl_null(g_argv1) THEN
    	CLEAR FORM                             #清除畫面
        CALL g_vnm.clear() 
        CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
        INITIALIZE g_vnm00 TO NULL    
        INITIALIZE g_vnm01 TO NULL    
        INITIALIZE g_vnm02 TO NULL
        INITIALIZE g_vnm03 TO NULL   
        INITIALIZE g_vnm012 TO NULL  #FUN-B50101 add
 
    	CONSTRUCT g_wc ON vnm00,vnm01,vnm02,vnm03,vnm012,vnm04    #螢幕上取條件 #FUN-B50101 add
        	FROM vnm00,vnm01,vnm02,vnm03,vnm012,s_vnm[1].vnm04              #FUN-B50101 add
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
                WHEN INFIELD(vnm00)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO vnm00
                     NEXT FIELD vnm00
                WHEN INFIELD(vnm03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ecd3"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO vnm03
                     NEXT FIELD vnm03
                WHEN INFIELD(vnm04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_vnk01"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO vnm04
                     NEXT FIELD vnm04
 
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
      ELSE
	LET g_wc=" vnm00='",g_argv1,"' AND vnm01= '",g_argv2,"' AND vnm02= '",g_argv3,"' AND vnm03= '",g_argv4,"' AND vnm012= '",g_argv5,"'" #FUN-B50101 add vnm012
    END IF
 
    LET g_sql="SELECT DISTINCT vnm00,vnm01,vnm02,vnm03,vnm012 FROM vnm_file ", #FUN-B50101 add vnm012
               " WHERE vnm05 = 0 AND ", g_wc CLIPPED,
               " ORDER BY vnm00,vnm01,vnm02,vnm03,vnm012"                      #FUN-B50101 add vnm012
    PREPARE i331_prepare FROM g_sql      #預備一下
    IF STATUS THEN CALL cl_err('prep:',STATUS,1) END IF
    DECLARE i331_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i331_prepare
    LET g_sql="SELECT DISTINCT vnm00,vnm01,vnm02,vnm03,vnm012 FROM vnm_file WHERE vnm05=0 AND ",g_wc CLIPPED #FUN-B50101 add vnm012
    PREPARE i331_precount FROM g_sql
    DECLARE i331_count CURSOR FOR i331_precount
END FUNCTION
 
 
FUNCTION i331_menu()
 
   WHILE TRUE
      CALL i331_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i331_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i331_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i331_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i331_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #串apsi331_2 工模具群組取替代
         WHEN "aps_tools_group_replace"
            LET l_ac = ARR_CURR()
            IF l_ac = 0 THEN 
               CALL cl_err('','aps-729',1)
            ELSE
               CALL i331_aps_replace_vnm()
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vnm),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i331_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_vnm.clear()
    INITIALIZE g_vnm00 LIKE vnm_file.vnm00
    INITIALIZE g_vnm01 LIKE vnm_file.vnm01
    INITIALIZE g_vnm02 LIKE vnm_file.vnm02
    INITIALIZE g_vnm03 LIKE vnm_file.vnm03
    INITIALIZE g_vnm012 LIKE vnm_file.vnm012 #FUN-B50101 add
 
	IF NOT cl_null(g_argv1) THEN 
           LET g_vnm00=g_argv1
           LET g_vnm01=g_argv2
           LET g_vnm02=g_argv3
           LET g_vnm03=g_argv4   
           LET g_vnm012=g_argv5 #FUN-B50101 add
	   DISPLAY g_vnm00 TO vnm00 
           DISPLAY g_vnm01 TO vnm01
           DISPLAY g_vnm02 TO vnm02
           DISPLAY g_vnm03 TO vnm03
           DISPLAY g_vnm012 TO vnm012 #FUN-B50101 add
       END IF
    LET g_vnm00_t = NULL
    LET g_vnm01_t = NULL
    LET g_vnm02_t = NULL
    LET g_vnm03_t = NULL
    LET g_vnm012_t = NULL #FUN-B50101 add
 
 
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i331_i("a")                   #輸入單頭
	IF INT_FLAG THEN
           LET g_vnm00=NULL
           LET g_vnm01=NULL
           LET g_vnm02=NULL
           LET g_vnm03=NULL
           LET g_vnm012=NULL #FUN-B50101 add
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        CALL g_vnm.clear()
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i331_b()                   #輸入單身
        LET g_vnm00_t = g_vnm00            #保留舊值
        LET g_vnm01_t = g_vnm01            #保留舊值
        LET g_vnm02_t = g_vnm02
        LET g_vnm03_t = g_vnm03
        LET g_vnm012_t = g_vnm012 #FUN-B50101 add
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i331_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnm00 IS NULL OR g_vnm01 IS NULL 
       OR g_vnm02 IS NULL OR g_vnm03 IS NULL OR 
          g_vnm012 IS NULL THEN #FUN-B50101 add
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vnm00_t = g_vnm00
    LET g_vnm01_t = g_vnm01
    LET g_vnm02_t = g_vnm02
    LET g_vnm03_t = g_vnm03
    LET g_vnm012_t = g_vnm012 #FUN-B50101 add
    WHILE TRUE
        CALL i331_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_vnm00=g_vnm00_t
            LET g_vnm01=g_vnm01_t
            LET g_vnm02=g_vnm02_t
            LET g_vnm03=g_vnm03_t
            LET g_vnm012=g_vnm012_t  #FUN-B50101 add
            DISPLAY g_vnm00 TO vnm00     #單頭
            DISPLAY g_vnm01 TO vnm01     #單頭
            DISPLAY g_vnm02 TO vnm02     #單頭
            DISPLAY g_vnm03 TO vnm03     #單頭
            DISPLAY g_vnm012 TO vnm012   #單頭 #FUN-B50101 add
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_vnm00 != g_vnm00_t OR
           g_vnm01 != g_vnm01_t OR
           g_vnm02 != g_vnm02_t OR
           g_vnm03 != g_vnm03_t OR
           g_vnm012 != g_vnm012_t THEN #FUN-B50101 add
            UPDATE vnm_file SET vnm00 = g_vnm00,  #更新DB
		                vnm01 = g_vnm01,
                                vnm02 = g_vnm02,
                                vnm03 = g_vnm03,
                                vnm012 = g_vnm012 #FUN-B50101
                WHERE vnm00 = g_vnm00_t          #COLAUTH?
	          AND vnm01 = g_vnm01_t 
                  AND vnm02 = g_vnm02_t
                  AND vnm03 = g_vnm03_t
                  AND vnm012 = g_vnm012_t #FUN-B50101 add
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_vnm00 CLIPPED
                CALL cl_err3("upd","vnm_file",g_vnm00_t,g_vnm01_t,SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i331_i(p_cmd)
DEFINE
    p_cmd       LIKE type_file.chr1,     #a:輸入 u:更改   #No.FUN-680096 VARCHAR(1)
    l_vnm04     LIKE vnm_file.vnm04
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012 #FUN-B50101 add vnm012
        WITHOUT DEFAULTS
        FROM vnm00,vnm01,vnm02,vnm03,vnm012        #FUN-B50101 add vnm012
 
 
	BEFORE FIELD vnm00  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
        AFTER FIELD vnm00            #
            IF NOT cl_null(g_vnm00) THEN
                IF g_vnm00 != g_vnm00_t OR g_vnm00_t IS NULL THEN
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_vnm00,g_errno,0)
                        LET g_vnm00 = g_vnm00_t
                        DISPLAY g_vnm00 TO vnm00
                        NEXT FIELD vnm00
                    END IF
                END IF
            END IF
 
        AFTER FIELD vnm01            #
	    IF NOT cl_null(g_vnm01) THEN
                SELECT count(*) INTO g_cnt FROM vnm_file
                    WHERE vnm00 = g_vnm00
                      AND vnm01 = g_vnm01
                      AND vnm02 = g_vnm02
                      AND vnm03 = g_vnm03
                      AND vnm012 = g_vnm012 #FUN-B50101 add
                      AND vnm05 = 0
                IF g_cnt > 0 THEN   #資料重複
	            LET g_msg = g_vnm01 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_vnm01 = g_vnm01_t
                    DISPLAY  g_vnm01 TO vnm01
                    NEXT FIELD vnm01
                END IF
            END IF
        AFTER FIELD vnm02            #
            IF NOT cl_null(g_vnm02) THEN
                SELECT count(*) INTO g_cnt FROM vnm_file
                    WHERE vnm00 = g_vnm00
                      AND vnm01 = g_vnm01
                      AND vnm02 = g_vnm02
                      AND vnm03 = g_vnm03 
                      AND vnm012 = g_vnm012 #FUN-B50101 add
                      AND vnm05 = 0
                IF g_cnt > 0 THEN   #資料重複
                    LET g_msg = g_vnm02 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_vnm02 = g_vnm02_t
                    DISPLAY  g_vnm02 TO vnm02
                    NEXT FIELD vnm02
                END IF
            END IF
        AFTER FIELD vnm03            #
            IF NOT cl_null(g_vnm03) THEN
                SELECT count(*) INTO g_cnt FROM vnm_file
                    WHERE vnm00 = g_vnm00
                      AND vnm01 = g_vnm01
                      AND vnm02 = g_vnm02
                      AND vnm03 = g_vnm03
                      AND vnm012 = g_vnm012 #FUN-B50101 add
                      AND vnm05 = 0
                IF g_cnt > 0 THEN   #資料重複
                    LET g_msg = g_vnm03 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_vnm03 = g_vnm03_t
                    DISPLAY  g_vnm03 TO vnm03
                    NEXT FIELD vnm03
                END IF
            END IF
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(vnm00)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.default1 = g_vnm00
                     CALL cl_create_qry() RETURNING g_vnm00
                     DISPLAY BY NAME g_vnm00
                     NEXT FIELD vnm00
                WHEN INFIELD(vnm03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ecd3"
                     LET g_qryparam.default1 = g_vnm03
                     CALL cl_create_qry() RETURNING g_vnm03
                     DISPLAY BY NAME g_vnm03
                     NEXT FIELD vnm03
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
 
 
#Query 查詢
FUNCTION i331_q()
  DEFINE l_vnm00  LIKE vnm_file.vnm00,
         l_vnm01  LIKE vnm_file.vnm01,
         l_vnm02  LIKE vnm_file.vnm02,
         l_vnm03  LIKE vnm_file.vnm03,
         l_vnm012 LIKE vnm_file.vnm012,   #FUN-B50101 add
         l_cnt    LIKE type_file.num10    #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    IF cl_null(g_argv1) THEN
       INITIALIZE g_vnm00 TO NULL        
       INITIALIZE g_vnm01 TO NULL        
       INITIALIZE g_vnm02 TO NULL
       INITIALIZE g_vnm03 TO NULL
       INITIALIZE g_vnm012 TO NULL #FUN-B50101 add
    END IF
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i331_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        IF cl_null(g_argv1) THEN
           INITIALIZE g_vnm00 TO NULL
           INITIALIZE g_vnm01 TO NULL
           INITIALIZE g_vnm02 TO NULL
           INITIALIZE g_vnm03 TO NULL
           INITIALIZE g_vnm012 TO NULL  #FUN-B50101 add
        END IF
        RETURN
    END IF
    OPEN i331_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('open cursor:',SQLCA.sqlcode,0)
        IF cl_null(g_argv1) THEN
           INITIALIZE g_vnm00 TO NULL
           INITIALIZE g_vnm01 TO NULL
           INITIALIZE g_vnm02 TO NULL
           INITIALIZE g_vnm03 TO NULL
           INITIALIZE g_vnm012 TO NULL  #FUN-B50101 add
        END IF
    ELSE
        FOREACH i331_count INTO l_vnm00,l_vnm01,l_vnm02,l_vnm03,l_vnm012 #FUN-B50101 add vnm012
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i331_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i331_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式   #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i331_bcs INTO g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012 #FUN-B50101 add vnm012
        WHEN 'P' FETCH PREVIOUS i331_bcs INTO g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012 #FUN-B50101 add vnm012
        WHEN 'F' FETCH FIRST    i331_bcs INTO g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012 #FUN-B50101 add vnm012
        WHEN 'L' FETCH LAST     i331_bcs INTO g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012 #FUN-B50101 add vnm012
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i331_bcs INTO g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012 #FUN-B50101 add vnm012
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_vnm00,SQLCA.sqlcode,0)
       IF cl_null(g_argv1) THEN
          INITIALIZE g_vnm00 TO NULL  
          INITIALIZE g_vnm01 TO NULL  
          INITIALIZE g_vnm02 TO NULL
          INITIALIZE g_vnm03 TO NULL
          INITIALIZE g_vnm012 TO NULL #FUN-B50101 add
       END IF
       #RETURN
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
    CALL i331_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i331_show()
    DISPLAY g_vnm00 TO vnm00   #單頭
    DISPLAY g_vnm01 TO vnm01   #單頭
    DISPLAY g_vnm02 TO vnm02   #單頭
    DISPLAY g_vnm03 TO vnm03   #單頭
    DISPLAY g_vnm012 TO vnm012 #單頭 #FUN-B50101 add
    CALL i331_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i331_r()
  DEFINE l_vnm00  LIKE vnm_file.vnm00,
         l_vnm01  LIKE vnm_file.vnm01,
         l_vnm02  LIKE vnm_file.vnm02,
         l_vnm03  LIKE vnm_file.vnm03,
         l_vnm012 LIKE vnm_file.vnm012  #FUN-B50101 add
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnm00 IS NULL OR g_vnm01 IS NULL  OR
       g_vnm02 IS NULL OR g_vnm03 IS NULL  OR
       g_vnm012 IS NULL THEN #FUN-B50101 add
       CALL cl_err("",-400,0)                      #No.FUN-6A0002
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM vnm_file
         WHERE vnm00=g_vnm00 AND vnm01=g_vnm01 AND vnm02=g_vnm02 AND vnm03=g_vnm03 AND vnm012=g_vnm012 #FUN-B50101 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","vnm_file",g_vnm00,g_vnm01,SQLCA.sqlcode,"","BODY DELETE:",1) # TQC-660046
        ELSE
            CLEAR FORM
            CALL g_vnm.clear()
            FOREACH i331_count INTO l_vnm00,l_vnm01,l_vnm02,l_vnm03,l_vnm012 #FUN-B50101 add
                LET g_row_count = g_row_count + 1
            END FOREACH
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i331_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i331_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i331_fetch('/')
            END IF
            LET g_delete='Y'
            LET g_vnm00 = NULL
            LET g_vnm01 = NULL
            LET g_vnm02 = NULL
            LET g_vnm03 = NULL
            LET g_vnm012 = NULL #FUN-B50101 add
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION
 
 
#單身
FUNCTION i331_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否    #No.FUN-680096 SMALLINT
    l_cnt           LIKE type_file.num5      #FUN-660173 add  #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnm00 IS NULL OR g_vnm01 IS NULL OR
       g_vnm02 IS NULL OR g_vnm03 IS NULL OR
       g_vnm012 IS NULL THEN #FUN-B50101 add
        RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT vnm06,vnm04 ",
      " FROM vnm_file ",
      "  WHERE vnm00= ? ",
      "   AND vnm01= ? ",
      "   AND vnm02= ? ",
      "   AND vnm03= ? ",
      "   AND vnm012= ? ", #FUN-B50101 add
      "   AND vnm06= ? ",
      "   AND vnm05=0 ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i331_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_vnm
              WITHOUT DEFAULTS
              FROM s_vnm.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_vnm_t.* = g_vnm[l_ac].*  #BACKUP
	        BEGIN WORK
 
                OPEN i331_bcl USING g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012,g_vnm_t.vnm06 #FUN-B50101 add vnm012
                IF STATUS THEN
                    CALL cl_err("OPEN i331_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i331_bcl INTO g_vnm[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO vnm_file
              (vnm00, vnm01, vnm02, vnm03, vnm012,             #FUN-B50101 add vnm012
               vnm04, vnm05, vnm06, vnmplant, vnmlegal)        #FUN-B50101 add vnmplant,vnmlegal
            VALUES(g_vnm00,g_vnm01,g_vnm02,g_vnm03,g_vnm012,   #FUN-B50101 add vnm012
                   g_vnm[l_ac].vnm04,0,
                   g_vnm[l_ac].vnm06,g_plant,g_legal)          #FUN-B50101 add vnmplant,vnmlegal
 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vnm_file",g_vnm00,g_vnm[l_ac].vnm04,SQLCA.sqlcode,"","",1) # TQC-660046
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
            INITIALIZE g_vnm[l_ac].* TO NULL      #900423
            LET g_vnm_t.* = g_vnm[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vnm06
 
        AFTER FIELD vnm04            
	    IF cl_null(g_vnm[l_ac].vnm04) THEN
                   NEXT FIELD vnm04
            END IF
           LET l_seq = 0
           SELECT COUNT(*) INTO l_seq FROM vnk_file
             WHERE vnk01 = g_vnm[l_ac].vnm04
           IF l_seq = 0 THEN
              CALL cl_err('','aps-726',1)
              NEXT FIELD vnm04
           END IF
           LET l_seq=0
           #FUN-8A0040
           #SELECT COUNT(*) INTO l_seq FROM vnm_file
           #   WHERE vnm00 = g_vnm00
           #     AND vnm01 = g_vnm01
           #     AND vnm02 = g_vnm02
           #     AND vnm03 = g_vnm03
           #     AND vnm06 = g_vnm06
           #     AND vnm05 = 0
           #     AND vnm04 = g_vnm[l_ac].vnm04
           SELECT COUNT(*) INTO l_seq FROM vnm_file
             WHERE vnm00 = g_vnm00
               AND vnm01 = g_vnm01
               AND vnm02 = g_vnm02
               AND vnm03 = g_vnm03
               AND vnm012 = g_vnm012          #FUN-B50101 add
               AND vnm04 = g_vnm[l_ac].vnm04
 
          IF l_seq >0 AND (cl_null(g_vnm_t.vnm04) OR g_vnm[l_ac].vnm04 != g_vnm_t.vnm04) THEN #FUN-8A0040
             CALL cl_err('','aps-301',1)
             NEXT FIELD vnm04
          END IF
 
        BEFORE FIELD vnm06                        #default 序號
            IF p_cmd='a' THEN
                SELECT max(vnm06)+1
                   INTO g_vnm[l_ac].vnm06
                   FROM vnm_file
                   WHERE vnm00=g_vnm00 AND vnm01=g_vnm01
                     AND vnm02=g_vnm02 AND vnm03=g_vnm03
                     AND vnm012=g_vnm012 #FUN-B50101 add
                     AND vnm05 = 0
                IF g_vnm[l_ac].vnm06 IS NULL THEN
                    LET g_vnm[1].vnm06 = 1
                END IF
            END IF
 
        AFTER FIELD vnm06                        #check 序號是否重複
            IF NOT cl_null(g_vnm[l_ac].vnm06) THEN
                IF g_vnm[l_ac].vnm06 != g_vnm_t.vnm06 OR
                   g_vnm_t.vnm06 IS NULL THEN
                    SELECT count(*) INTO l_n FROM vnm_file
                        WHERE vnm00 = g_vnm00
                          AND vnm01 = g_vnm01
                          AND vnm02 = g_vnm02
                          AND vnm03 = g_vnm03
                          AND vnm012= g_vnm012 #FUN-B50101 add
                          AND vnm05 = 0
                          AND vnm06 = g_vnm[l_ac].vnm06
                    IF l_n > 0 THEN
                        CALL cl_err(g_vnm[l_ac].vnm06,-239,0)
                        LET g_vnm[l_ac].vnm06 = g_vnm_t.vnm06
                        DISPLAY g_vnm[l_ac].vnm06 TO s_vnm[l_sl].vnm06
                        NEXT FIELD vnm06
                    END IF
                END IF
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_vnm_t.vnm06 > 0 AND
               g_vnm_t.vnm06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM vnm_file
                    WHERE vnm00 = g_vnm00
                      AND vnm01 = g_vnm01
                      AND vnm02 = g_vnm02
                      AND vnm03 = g_vnm03 
                      AND vnm012= g_vnm012 #FUN-B50101 add
                      AND vnm06 = g_vnm_t.vnm06
 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","vnm_file",g_vnm00,g_vnm01,SQLCA.sqlcode,"","",1)  # TQC-660046
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
               LET g_vnm[l_ac].* = g_vnm_t.*
               CLOSE i331_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vnm[l_ac].vnm06,-263,1)
               LET g_vnm[l_ac].* = g_vnm_t.*
            ELSE
                UPDATE vnm_file SET
                             vnm06=g_vnm[l_ac].vnm06,
                             vnm04=g_vnm[l_ac].vnm04
                 WHERE vnm00=g_vnm00
                   AND vnm01=g_vnm01
                   AND vnm02=g_vnm02
                   AND vnm03=g_vnm03
                   AND vnm012=g_vnm012 #FUN-B50101 add
                   AND vnm04=g_vnm_t.vnm04
                   AND vnm05 = 0
                   AND vnm06=g_vnm_t.vnm06
                UPDATE vnm_file SET
                            vnm06=g_vnm[l_ac].vnm06
                 WHERE vnm00=g_vnm00
                   AND vnm01=g_vnm01
                   AND vnm02=g_vnm02
                   AND vnm03=g_vnm03
                   AND vnm012=g_vnm012 #FUN-B50101 add
                   AND vnm05 = 1
                   AND vnm06=g_vnm_t.vnm06
 
                IF SQLCA.sqlcode THEN 
                    CALL cl_err3("upd","vnm_file",g_vnm00,g_vnm01,SQLCA.sqlcode,"","",1) # TQC-660046
                    LET g_vnm[l_ac].* = g_vnm_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
	            COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_vnm[l_ac].* = g_vnm_t.*
               END IF
               CLOSE i331_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i331_bcl
            COMMIT WORK
 
        #FUN-880102 MARK
        #ON ACTION CONTROLO                        #沿用所有欄位
        #    IF INFIELD(vnm06) AND l_ac > 1 THEN
        #        LET g_vnm[l_ac].* = g_vnm[l_ac-1].*
        #        NEXT FIELD vnm06
        #    END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp 
            CASE
               WHEN INFIELD(vnm04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_vnk01"   
                        LET g_qryparam.default1 = g_vnm[l_ac].vnm04
                        CALL cl_create_qry() RETURNING g_vnm[l_ac].vnm04
                        DISPLAY g_vnm[l_ac].vnm04 TO vnm04
                        NEXT FIELD vnm04
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
      
        END INPUT
 
    CLOSE i331_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION i331_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000    #No.FUN-680096   VARCHAR(300)
 
    CONSTRUCT l_wc ON vnm04                     #螢幕上取條件
       FROM s_vnm[1].vnm04
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
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i331_bf(l_wc)
END FUNCTION
 
FUNCTION i331_bf(p_wc)              #BODY FILL UP
DEFINE p_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300)
DEFINE i	LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
    LET g_sql =
       "SELECT vnm06,vnm04 ",
       " FROM  vnm_file ",
       " WHERE vnm00 = '",g_vnm00,"'",
       "   AND vnm01 = '",g_vnm01,"'",
       "   AND vnm02 = '",g_vnm02,"'",
       "   AND vnm03 = '",g_vnm03,"'",
       "   AND vnm012 = '",g_vnm012,"'", #FUN-B50101 add
       "   AND vnm05 =0 ",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i331_prepare2 FROM g_sql      #預備一下
    DECLARE vnm_cs CURSOR FOR i331_prepare2
    CALL g_vnm.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH vnm_cs INTO g_vnm[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_vnm.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i331_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vnm TO s_vnm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
      #ON ACTION insert
      #   LET g_action_choice="insert"
      #   EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      #ON ACTION delete
      #   LET g_action_choice="delete"
      #   EXIT DISPLAY
      ON ACTION first
         CALL i331_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i331_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i331_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i331_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i331_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      #FUN-880102 工模具群組取替代
      ON ACTION aps_tools_group_replace
         LET g_action_choice="aps_tools_group_replace"
         EXIT DISPLAY    
 
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i331_aps_replace_vnm()
 #LET g_cmd = "apsi331_2 '",g_vnm00,"' '",g_vnm01,"' '",g_vnm02,"' '",g_vnm03,"' '",g_vnm[l_ac].vnm06,"'"                #FUN-B50101 mark
  LET g_cmd = "apsi331_2 '",g_vnm00,"' '",g_vnm01,"' '",g_vnm02,"' '",g_vnm03,"' '",g_vnm[l_ac].vnm06,"' '",g_vnm012,"'"  #FUN-B50101 add
  CALL cl_cmdrun(g_cmd)
END FUNCTION
 
#Patch....NO.TQC-610035 <> #
