# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmi230.4gl
# Descriptions...: 客戶麥頭檔維護作業
# Date & Author..: 94/12/20 by Nick
# modify  2.0 版.: 95/10/19 by Danny 在輸入客戶編號後,show出簡稱
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-510081 05/01/12 By ching 報表order by ocf01,ocf02
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790076 07/09/12 By judy 報表中缺少"From"
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-880037 08/08/06 By Smapmin 連續複製二次就會出現-239的錯誤
# Modify.........: No.FUN-830154 08/04/15 By destiny 報表改為CR輸出         
#                                08/08/18 By Cockroach 5X-->5.1X
# Modify.........: No.MOD-950197 09/05/25 By mike 因目前ocf_file沒有ocfuser/ocfgrup,故將權限控管的相關程式拿掉.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0451 10/02/23 By sabrina 控管entry/noentry的地方都要加上ocf02
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30065 10/03/11 by destiny 更改过资料以后更新资料库不成功
# Modify.........: No.TQC-A80083 10/08/17 查詢再新增資料後,錄入一筆未審核的客戶編號,此時顯示的客戶名稱和客戶編號有異
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B90147 12/01/17 By Vampire 複製功能無法複製第二筆
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ocf   RECORD LIKE ocf_file.*,
	l_occ02 	   LIKE occ_file.occ02,
	l_occ02_t	   LIKE occ_file.occ02,
    g_ocf_t RECORD LIKE ocf_file.*,
    g_ocf01_t LIKE ocf_file.ocf01,
     g_wc,g_sql         LIKE type_file.chr1000, #No.FUN-580092 HCN  #No.FUN-680137 STRING
    g_argv1		LIKE ocf_file.ocf01,
    g_argv2	        LIKE ocf_file.ocf02,
    g_argv3	        LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1) 
 
DEFINE   g_forupd_sql  STRING  #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done    STRING
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0094
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 =ARG_VAL(1) CLIPPED   #NO:6882
    LET g_argv2 =ARG_VAL(2) CLIPPED   #NO:6882
    LET g_argv3 =ARG_VAL(3) CLIPPED   #NO:6882 若asfi301串來只能做查詢,新增修改等功能不能執行
    IF cl_null(g_argv3) THEN LET g_argv3=' ' END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_ocf.* TO NULL
    INITIALIZE g_ocf_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ocf_file WHERE ocf01 = ? AND ocf02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i230_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW i230_w AT p_row,p_col WITH FORM "axm/42f/axmi230"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
	IF NOT cl_null(g_argv1) THEN CALL i230_q() END IF
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i230_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i230_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i230_curs()
   CLEAR FORM
   IF cl_null(g_argv1) THEN
   INITIALIZE g_ocf.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
    	ocf01,   ocf02, ocf101, ocf102, ocf103, ocf104, ocf105, ocf106,
    	ocf107, ocf108, ocf109, ocf110, ocf111, ocf112, ocf201, ocf202,
    	ocf203,	ocf204, ocf205, ocf206, ocf207, ocf208, ocf209, ocf210,
    	ocf211,	ocf212
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION controlp
             CASE
                 WHEN INFIELD(ocf01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.default1 = g_ocf.ocf01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ocf01
                 OTHERWISE
                     EXIT CASE
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
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   ELSE
      LET g_wc = "ocf01 ='",g_argv1,"' AND ocf02 ='",g_argv2,"' "
   END IF
IF INT_FLAG THEN RETURN END IF
#MOD-950197   ---start
    #資料權限的檢查
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #    LET g_wc = g_wc clipped," AND ocfuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND ocfgrup MATCHES '",g_grup CLIPPED,"*'"
   #END IF
 
   #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND ocfgrup IN ",cl_chk_tgrup_list()
   #END IF
#MOD-950197   ---end
    LET g_sql="SELECT ocf01,ocf02 FROM ocf_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY ocf01"
    PREPARE i230_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i230_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i230_prepare
    LET g_sql= "SELECT COUNT(*) FROM ocf_file WHERE ",g_wc CLIPPED
    PREPARE i230_precount FROM g_sql
    DECLARE i230_count CURSOR FOR i230_precount
END FUNCTION
 
FUNCTION i230_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF g_argv3<>'D' AND cl_chk_act_auth() THEN  #NO:6882
                 CALL i230_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i230_q()
            END IF
        ON ACTION next
            CALL i230_fetch('N')
        ON ACTION previous
            CALL i230_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF g_argv3<>'D' AND  cl_chk_act_auth() THEN #NO:6882
                 CALL i230_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF g_argv3<>'D' AND  cl_chk_act_auth() THEN #NO:6882
                 CALL i230_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF g_argv3<>'D' AND  cl_chk_act_auth() THEN #NO:6882
                 CALL i230_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i230_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i230_fetch('/')
        ON ACTION first
            CALL i230_fetch('F')
        ON ACTION last
            CALL i230_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_ocf.ocf01 IS NOT NULL THEN
                LET g_doc.column1 = "ocf01"
                LET g_doc.value1 = g_ocf.ocf01
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i230_cs
END FUNCTION
 
 
FUNCTION i230_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    INITIALIZE g_ocf.* TO NULL
    LET g_ocf01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i230_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_ocf.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ocf.ocf01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ocf_file VALUES(g_ocf.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","ocf_file",g_ocf.ocf01,g_ocf.ocf02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
            LET g_ocf_t.* = g_ocf.*                # 保存上筆資料
            SELECT ocf01,ocf02 INTO g_ocf.ocf01,g_ocf.ocf02 FROM ocf_file
                WHERE ocf01 = g_ocf.ocf01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i230_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    INPUT BY NAME
		g_ocf.ocf01 ,g_ocf.ocf02 ,g_ocf.ocf101, g_ocf.ocf102,
		g_ocf.ocf103,g_ocf.ocf104,
		g_ocf.ocf105,g_ocf.ocf106, g_ocf.ocf107, g_ocf.ocf108,
		g_ocf.ocf109,g_ocf.ocf110, g_ocf.ocf111, g_ocf.ocf112,
		g_ocf.ocf201,g_ocf.ocf202, g_ocf.ocf203, g_ocf.ocf204,
		g_ocf.ocf205,g_ocf.ocf206, g_ocf.ocf207, g_ocf.ocf208,
		g_ocf.ocf209,g_ocf.ocf210, g_ocf.ocf211, g_ocf.ocf212
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i230_set_entry(p_cmd)
           CALL i230_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD ocf01
          IF g_ocf.ocf01 IS NOT NULL THEN
	    CALL i230_ocf01("a")
            IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
       #        LET g_ocf.ocf01 = g_ocf_t.ocf01   #TQC-A80083
                NEXT FIELD ocf01
            END IF
          END IF
 
	AFTER FIELD ocf02
          IF g_ocf.ocf02 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ocf.ocf01 != g_ocf_t.ocf01) OR
              (p_cmd = "u" AND g_ocf.ocf02 != g_ocf_t.ocf02) THEN
                SELECT count(*) INTO l_n FROM ocf_file
                    WHERE ocf01 = g_ocf.ocf01 AND ocf02=g_ocf.ocf02
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('ocf01+ocf02',-239,0)
                    LET g_ocf.ocf01 = g_ocf_t.ocf01
                    LET g_ocf.ocf02 = g_ocf_t.ocf02
                    DISPLAY BY NAME g_ocf.ocf01
                    NEXT FIELD ocf01
                END IF
            END IF
          END IF
      #MOD-650015 --start
      # ON ACTION CONTROLO                        # 沿用所有欄位
      #     IF INFIELD(ocf01) THEN
      #        LET g_ocf.* = g_ocf_t.*
      #        DISPLAY BY NAME
      # 	g_ocf.ocf01, g_ocf.ocf102, g_ocf.ocf103, g_ocf.ocf104,
      # 	g_ocf.ocf105,g_ocf.ocf106, g_ocf.ocf107, g_ocf.ocf108,
      # 	g_ocf.ocf109,g_ocf.ocf110, g_ocf.ocf111, g_ocf.ocf112,
      # 	g_ocf.ocf201,g_ocf.ocf202, g_ocf.ocf203, g_ocf.ocf204,
      # 	g_ocf.ocf205,g_ocf.ocf206, g_ocf.ocf207, g_ocf.ocf208,
      # 	g_ocf.ocf209,g_ocf.ocf210, g_ocf.ocf211, g_ocf.ocf212
      # 			CALL i230_ocf01("a")
      #        NEXT FIELD ocf01
      #     END IF
      #MOD-650015 --end
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(ocf01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.default1 = g_ocf.ocf01
                    CALL cl_create_qry() RETURNING g_ocf.ocf01
#                    CALL FGL_DIALOG_SETBUFFER( g_ocf.ocf01 )
                    DISPLAY BY NAME g_ocf.ocf01
                OTHERWISE
                    EXIT CASE
            END CASE
 
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
 
FUNCTION i230_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i230_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i230_count
    FETCH i230_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i230_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)
        INITIALIZE g_ocf.* TO NULL
    ELSE
        CALL i230_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i230_fetch(p_flocf)
    DEFINE
        p_flocf        LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
 
    CASE p_flocf
        WHEN 'N' FETCH NEXT     i230_cs INTO g_ocf.ocf01,g_ocf.ocf02
        WHEN 'P' FETCH PREVIOUS i230_cs INTO g_ocf.ocf01,g_ocf.ocf02
        WHEN 'F' FETCH FIRST    i230_cs INTO g_ocf.ocf01,g_ocf.ocf02
        WHEN 'L' FETCH LAST     i230_cs INTO g_ocf.ocf01,g_ocf.ocf02
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i230_cs INTO g_ocf.ocf01,g_ocf.ocf02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)
        INITIALIZE g_ocf.* TO NULL                #NO.FUN-6A0020 
        RETURN
    ELSE
       CASE p_flocf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ocf.* FROM ocf_file
       WHERE ocf01=g_ocf.ocf01 AND ocf02 = g_ocf.ocf02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ocf_file",g_ocf.ocf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ocf.* TO NULL #FUN-4C0057 add
    ELSE
       LET g_data_owner = ''      #FUN-4C0057 add
       LET g_data_group = ''      #FUN-4C0057 add
       CALL i230_show()           # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i230_show()
    LET g_ocf_t.*=g_ocf.*
    DISPLAY BY NAME
		g_ocf.ocf01 ,g_ocf.ocf02 , g_ocf.ocf101, g_ocf.ocf102,
		g_ocf.ocf103,g_ocf.ocf104,
		g_ocf.ocf105,g_ocf.ocf106, g_ocf.ocf107, g_ocf.ocf108,
		g_ocf.ocf109,g_ocf.ocf110, g_ocf.ocf111, g_ocf.ocf112,
		g_ocf.ocf201,g_ocf.ocf202, g_ocf.ocf203, g_ocf.ocf204,
		g_ocf.ocf205,g_ocf.ocf206, g_ocf.ocf207, g_ocf.ocf208,
		g_ocf.ocf209,g_ocf.ocf210, g_ocf.ocf211, g_ocf.ocf212
	CALL i230_ocf01("a")
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i230_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ocf.ocf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ocf01_t = g_ocf.ocf01
    BEGIN WORK
 
    OPEN i230_cl USING g_ocf.ocf01,g_ocf.ocf02
    IF STATUS THEN
       CALL cl_err("OPEN i230_cl:", STATUS, 1)
       CLOSE i230_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i230_cl INTO g_ocf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i230_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i230_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ocf.*=g_ocf_t.*
            CALL i230_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ocf_file SET ocf_file.* = g_ocf.*  # 更新DB
           #WHERE ocf01=g_ocf.ocf01 AND ocf02 = g_ocf.ocf02             # COLAUTH?  #No.TQC-A30065
            WHERE ocf01=g_ocf_t.ocf01 AND ocf02 = g_ocf_t.ocf02                    #No.TQC-A30065
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ocf_file",g_ocf01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i230_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i230_ocf01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
    l_occacti       LIKE occ_file.occacti
 
    LET g_errno = ' '
    SELECT occ02,occacti INTO l_occ02,l_occacti
        FROM occ_file
        WHERE occ01 = g_ocf.ocf01
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2732'  #MOD-510081
                            LET l_occ02 = NULL
         WHEN l_occacti='N' LET g_errno = '9028'
         WHEN l_occacti MATCHES '[PH]' LET g_errno = '9038'  #FUN-690023 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN
       DISPLAY l_occ02 TO occ02
    END IF
END FUNCTION
 
FUNCTION i230_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_ocf.ocf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i230_cl USING g_ocf.ocf01,g_ocf.ocf02
    IF STATUS THEN
       CALL cl_err("OPEN i230_cl:", STATUS, 1)
       CLOSE i230_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i230_cl INTO g_ocf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i230_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ocf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ocf.ocf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ocf_file WHERE ocf01 = g_ocf.ocf01
                              AND ocf02 = g_ocf.ocf02
       CLEAR FORM
       INITIALIZE g_ocf.* TO NULL
       OPEN i230_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i230_cs
          CLOSE i230_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i230_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i230_cs
          CLOSE i230_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i230_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i230_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i230_fetch('/')
       END IF
 
    END IF
    CLOSE i230_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i230_copy()
    DEFINE
        l_ocf           RECORD  LIKE ocf_file.*,
        l_newno,l_oldno         LIKE ocf_file.ocf01,
        l_newno2,l_oldno2       LIKE ocf_file.ocf02
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ocf.ocf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    #MOD-B90147 --- start ---
    LET g_before_input_done = FALSE
    CALL i230_set_entry("a")
    LET g_before_input_done = TRUE
    #MOD-B90147 ---  end  ---
    
    INPUT l_newno, l_newno2 FROM ocf01,ocf02
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           #CALL i230_set_entry("a")    #MOD-B90147 mark
           #CALL i230_set_no_entry("a") #MOD-B90147 mark
           LET g_before_input_done = TRUE
 
        AFTER FIELD ocf01
          IF l_newno IS NOT NULL THEN
            LET l_oldno=g_ocf.ocf01    #做備份動作
            LET g_ocf.ocf01=l_newno
            CALL i230_ocf01('a')
            LET g_ocf.ocf01=l_oldno
          END IF
        AFTER FIELD ocf02
          IF l_newno2 IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM ocf_file
                WHERE ocf01 = l_newno AND
                      ocf02=l_newno2
            IF g_cnt > 0 THEN                  # Duplicated
                CALL cl_err(l_newno2,-239,0)
                NEXT FIELD ocf01
            END IF
          END IF
       ON ACTION controlp
            CASE
                WHEN INFIELD(ocf01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.default1 = l_newno
                    CALL cl_create_qry() RETURNING l_newno
#                    CALL FGL_DIALOG_SETBUFFER( l_newno )
                    DISPLAY BY NAME l_newno
                    NEXT FIELD ocf01
                OTHERWISE
                    EXIT CASE
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
        RETURN
    END IF
    LET l_ocf.* = g_ocf.*
    LET l_ocf.ocf01  =l_newno   #新的鍵值
    LET l_ocf.ocf02  =l_newno2  #新的鍵值
    DROP TABLE x   #MOD-880037
   SELECT * FROM ocf_file
       WHERE ocf01=g_ocf.ocf01 AND ocf02=g_ocf.ocf02
       INTO TEMP x
   UPDATE x
       SET ocf01=l_newno,    #資料鍵值
           ocf02=l_newno2
   INSERT INTO ocf_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ocf.ocf01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("ins","ocf_file",l_newno,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660167
   ELSE
        MESSAGE 'ROW(',l_newno,'-',l_newno2,') O.K'
        LET l_oldno = g_ocf.ocf01
        LET l_oldno2 = g_ocf.ocf02
        SELECT ocf_file.* INTO g_ocf.* FROM ocf_file
                       WHERE ocf01 = l_newno AND ocf02=l_newno2
        CALL i230_u()
        #SELECT ocf_file.* INTO g_ocf.* FROM ocf_file             #FUN-C80046
        #               WHERE ocf01 = l_oldno AND ocf02=l_oldno2  #FUN-C80046
    END IF
    CALL i230_show()
END FUNCTION
 
FUNCTION i230_out()
    DEFINE
    l_ocf           RECORD LIKE ocf_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
    DEFINE g_str        STRING                        #No.FUN-830154  
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
#    CALL cl_outnam('axmi230') RETURNING l_name                    #No.FUN-830154 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog       #No.FUN-830154   
#    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmi230'     #No.FUN-830154 
#No.FUN-830154--add begin-- 
    LET g_sql="SELECT ocf01,occ02,ocf02,ocf101,ocf201,ocf102,ocf202,ocf103,ocf203,ocf104,ocf204, ",                                 
              "ocf105,ocf205,ocf106,ocf206,ocf107,ocf207,ocf108,ocf208,ocf109,ocf209,ocf110,ocf210, ",                              
              "ocf111,ocf211,ocf112,ocf212 ",                                                                                       
              "  FROM ocf_file LEFT OUTER JOIN occ_file ON occ_file.occ01 = ocf_file.ocf01 ",          # 組合出 SQL 指令                                                          
               "  WHERE ",g_wc CLIPPED                                                                               
    IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(g_wc,'ocf01,ocf02,ocf101,ocf102,ocf103,ocf104,ocf105,ocf106,                                                  
                            ocf107,ocf108,ocf109,ocf110,ocf111,ocf112,ocf201,ocf202,                                                
                            ocf203,ocf204,ocf205,ocf206,ocf207,ocf208,ocf209,ocf210,                                                
                            ocf211,ocf212')                                                                                         
        RETURNING g_wc                                                                                                              
        LET g_str = g_wc                                                                                                            
     END IF                                                                                                                         
     LET g_str =g_str                                                                                                               
     CALL cl_prt_cs1('axmi230','axmi230',g_sql,g_str)    
#No.FUN-830154--add end--     
#No.FUN-830154--mark begin--     
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    LET g_sql="SELECT * FROM ocf_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#   PREPARE i230_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i230_co                         # CURSOR
#       CURSOR FOR i230_p1
 
#   START REPORT i230_rep TO l_name
 
#   FOREACH i230_co INTO l_ocf.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i230_rep(l_ocf.*)
#   END FOREACH
 
#   FINISH REPORT i230_rep
 
#   CLOSE i230_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i230_rep(sr)
#   DEFINE
#       l_trailer_sw   LIKE type_file.chr1,      #No.FUN-680137  VARCHAR(1) 
#   sr              RECORD LIKE ocf_file.*,
#       l_occ02			LIKE occ_file.occ02
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#    ORDER BY sr.ocf01,sr.ocf02      #MOD-510081
 
#   FORMAT
#       PAGE HEADER
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT ' '
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#               COLUMN g_len-25,g_x[9] CLIPPED,g_user,   #TQC-790076
#               COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#           PRINT g_dash[1,g_len]
 
#  BEFORE GROUP OF sr.ocf02
#           SKIP TO TOP OF PAGE
#           SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.ocf01
#           PRINT COLUMN 10,g_x[11] CLIPPED,sr.ocf01,' ',l_occ02,
#           	  COLUMN 45,g_x[12] CLIPPED,sr.ocf02
#           PRINT '       ------------------------------   ',
#       	  '-----------------------------'
#           PRINT COLUMN 21,g_x[13],
#       	  COLUMN 45,g_x[14]
#           PRINT '       ------------------------------   '
#       	  ,'-----------------------------'
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN 8,sr.ocf101,
#                 COLUMN 41,sr.ocf201
#           PRINT COLUMN 8,sr.ocf102,
#                 COLUMN 41,sr.ocf202
#           PRINT COLUMN 8,sr.ocf103,
#                 COLUMN 41,sr.ocf203
#           PRINT COLUMN 8,sr.ocf104,
#                 COLUMN 41,sr.ocf204
#           PRINT COLUMN 8,sr.ocf105,
#                 COLUMN 41,sr.ocf205
#           PRINT COLUMN 8,sr.ocf106,
#                 COLUMN 41,sr.ocf206
#           PRINT COLUMN 8,sr.ocf107,
#                 COLUMN 41,sr.ocf207
#           PRINT COLUMN 8,sr.ocf108,
#                 COLUMN 41,sr.ocf208
#           PRINT COLUMN 8,sr.ocf109,
#                 COLUMN 41,sr.ocf209
#           PRINT COLUMN 8,sr.ocf110,
#                 COLUMN 41,sr.ocf210
#           PRINT COLUMN 8,sr.ocf111,
#                 COLUMN 41,sr.ocf211
#           PRINT COLUMN 8,sr.ocf112,
#                 COLUMN 41,sr.ocf212
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-830154--mark end--     
 
FUNCTION i230_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ocf01,ocf02",TRUE)        #MOD-9C0451 add ocf02
   END IF
END FUNCTION
 
FUNCTION i230_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ocf01,ocf02",FALSE)         #MOD-9C0451 add ocf02
   END IF
            IF cl_chk_act_auth() THEN
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
