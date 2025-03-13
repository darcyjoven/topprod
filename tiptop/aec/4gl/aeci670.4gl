# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aeci670.4gl
# Descriptions...: 機器資料維護作業
# Date & Author..: 91/11/08 By Carol
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置調整
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-660193 06/07/01 By APS欄位變動,修正相關程式
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750013 07/05/04 By Mandy 一進入程式,不查詢直接按Action "APS相關資料"時的控管,&權限控管
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/19 By lala   報表轉為使用p_query
# Modify.........: NO.FUN-7C0002 08/01/08 BY yiting apsi203->apsi303
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-850115 08/05/21 BY DUKE  UPDATE vmd_file 預設值
# Modify.........: No.FUN-890085 08/09/18 BY DUKE  刪除時需同步刪除 vmd_file
# Modify.........: No.TQC-920063 09/02/20 By shiwuying 修改 無效的資料也可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-A60028 10/06/07 By lilingyu 平行工藝
# Modify.........: No:FUN-9A0056 11/03/31 By abby 加入MES整合功能
# Modify.........: No:TQC-B50019 11/05/13 By destiny orig,oriu无法下查询条件
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_eci   RECORD LIKE eci_file.*,
    g_eci_t RECORD LIKE eci_file.*,
    g_eci01_t LIKE eci_file.eci01,
    g_wc,g_sql          STRING,                       #TQC-630166 
    l_cmd               LIKE type_file.chr1000        #No.FUN-680073
DEFINE g_forupd_sql          STRING                   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done   LIKE type_file.chr1      #No.FUN-680073  
DEFINE g_chr                 LIKE type_file.chr1      #No.FUN-680073 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10     #No.FUN-680073 INTEGER
DEFINE g_i                   LIKE type_file.num5      #count/index for any purpose  #No.FUN-680073 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000   #No.FUN-680073
DEFINE g_row_count           LIKE type_file.num10     #No.FUN-680073 INTEGER
DEFINE g_curs_index          LIKE type_file.num10     #No.FUN-680073 INTEGER
DEFINE g_jump                LIKE type_file.num10     #No.FUN-680073 INTEGER
DEFINE g_no_ask             LIKE type_file.num5      #No.FUN-680073 SMALLINT
DEFINE g_argv1     LIKE eci_file.eci01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
 
    INITIALIZE g_eci.* TO NULL
    INITIALIZE g_eci_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM eci_file WHERE eci01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i670_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i670_w WITH FORM "aec/42f/aeci670"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i670_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i670_a()
            END IF
         OTHERWISE        
            CALL i670_q() 
      END CASE
   END IF
 
    LET g_action_choice=""
    CALL i670_menu()
 
    CLOSE WINDOW i670_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i670_cs()
    CLEAR FORM
   INITIALIZE g_eci.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" eci01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        eci01,eci06,eci02,eci03,eci04,eci05,eci10,eci07,eci08,   #FUN-A60028 add eci10
        eciuser,ecigrup,ecimodu,ecidate,eciacti
        ,eciorig,ecioriu       #TQC-B50019
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(eci03) #工作區編號
                 CALL q_eca(TRUE,TRUE,g_eci.eci03) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO eci03
                 NEXT FIELD eci03
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
   END IF  #FUN-7C0050
 

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('eciuser', 'ecigrup')
 
    LET g_sql="SELECT eci01 FROM eci_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY eci01"
    PREPARE i670_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i670_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i670_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM eci_file WHERE ",g_wc CLIPPED
    PREPARE i670_precount FROM g_sql
    DECLARE i670_count CURSOR FOR i670_precount
END FUNCTION
 
FUNCTION i670_menu()
DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-820002
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
                CALL cl_set_act_visible("aps_related_data",FALSE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i670_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i670_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i670_fetch('N')
        ON ACTION previous
            CALL i670_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i670_u()
            END IF
            NEXT OPTION "next"
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i670_x()
            END IF
            NEXT OPTION "next"
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i670_r()
            END IF
            NEXT OPTION "next"
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i670_copy()
            END IF
 
        ON ACTION aps_related_data
            IF NOT cl_null(g_eci.eci01) THEN #TQC-750013 add if 
                IF cl_chk_act_auth() THEN    #TQC-750013 add if

                    SELECT COUNT(*) INTO g_cnt FROM vmd_file
                        WHERE vmd01 = g_eci.eci01
                    IF g_cnt <= 0 THEN
                        INSERT INTO vmd_file(vmd01,vmd02,vmd03,vmd04,vmd07,vmd08) 
                                      VALUES(g_eci.eci01,'','',0,0,100) 
                    END IF
                    LET l_cmd = "apsi303 ","'", g_eci.eci01,"'"
                    CALL cl_cmdrun(l_cmd)
                END IF
            ELSE
                CALL cl_err('',-400,1)
            END IF
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i670_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i670_fetch('/')
        ON ACTION first
            CALL i670_fetch('F')
        ON ACTION last
            CALL i670_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
    
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
   
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_eci.eci01 IS NOT NULL THEN
                  LET g_doc.column1 = "eci01"
                  LET g_doc.value1 = g_eci.eci01
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i670_cs
END FUNCTION
 
 
FUNCTION i670_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_eci.* LIKE eci_file.*
    LET g_eci01_t = NULL
    LET g_eci_t.*=g_eci.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_eci.eciacti ='Y'                   #有效的資料
        LET g_eci.eciuser = g_user
        LET g_eci.ecioriu = g_user #FUN-980030
        LET g_eci.eciorig = g_grup #FUN-980030
        LET g_eci.ecigrup = g_grup               #使用者所屬群
        LET g_eci.ecidate = g_today
        LET g_eci.eci10   = 0                  #FUN-A60028 add
        CALL i670_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_eci.eci01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF

        LET g_success = 'Y'                      #FUN-9A0056 add

        BEGIN WORK                               #FUN-9A0056 add
        
        INSERT INTO eci_file VALUES(g_eci.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","eci_file",g_eci.eci01,"",SQLCA.sqlcode,"","",1) #FUN-660091
            CONTINUE WHILE
        ELSE
            LET g_eci_t.* = g_eci.*                # 保存上筆資料

           #與MES整合
            IF g_aza.aza90 MATCHES "[Yy]" THEN           #FUN-9A0056 add
              CALL i670_mes('insert',g_eci.eci01)        #FUN-9A0056 add
            END IF                                       #FUN-9A0056 add
            
            SELECT eci01 INTO g_eci.eci01 FROM eci_file
                WHERE eci01 = g_eci.eci01
        END IF

       #FUN-9A0056 -- add begin ----
        IF g_success = 'N' THEN
          ROLLBACK WORK
          CONTINUE WHILE
        ELSE
          COMMIT WORK
        END IF
       #FUN-9A0056 -- add end ------
        
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i670_i(p_cmd)
    DEFINE 
        l_sw            LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)    
        p_cmd           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680073 SMALLINT
 
    DISPLAY BY NAME g_eci.eciuser,g_eci.ecigrup,
        g_eci.ecidate, g_eci.eciacti,g_eci.eci10              #FUN-A60028 add g_eci.eci10
    INPUT BY NAME g_eci.ecioriu,g_eci.eciorig,
                  g_eci.eci01,g_eci.eci06,g_eci.eci02, g_eci.eci03,g_eci.eci04,
	                g_eci.eci05,g_eci.eci10,g_eci.eci07,g_eci.eci08         #FUN-A60028 add g_eci.eci10
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i670_set_entry(p_cmd)
           CALL i670_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD eci01
          IF g_eci.eci01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_eci.eci01 != g_eci01_t) THEN
                SELECT count(*) INTO l_n FROM eci_file
                    WHERE eci01 = g_eci.eci01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_eci.eci01,-239,0)
                    LET g_eci.eci01 = g_eci01_t
                    DISPLAY BY NAME g_eci.eci01
                    NEXT FIELD eci01
                END IF
            END IF
          END IF
        AFTER FIELD eci03  #工作區編號, 不可空白, 須存在
             IF g_eci.eci03 IS NOT NULL THEN
                IF g_eci_t.eci03 IS NULL OR
                  (g_eci.eci03 != g_eci_t.eci03 ) THEN
                    CALL i670_eci03('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_eci.eci03,g_errno,0)
                       LET g_eci.eci03 = g_eci_t.eci03
                       DISPLAY BY NAME g_eci.eci03
                       NEXT FIELD eci03
                    END IF
                END IF
             END IF
 
        AFTER FIELD eci04
	    IF g_eci.eci04 < 0 THEN
		LET g_eci.eci04 = g_eci_t.eci04
		DISPLAY BY NAME g_eci.eci04
		NEXT FIELD eci04
	    END IF
 
        AFTER FIELD eci05
	    IF g_eci.eci05 < 0 THEN
		LET g_eci.eci05 = g_eci_t.eci05
		DISPLAY BY NAME g_eci.eci05
		NEXT FIELD eci05
	    END IF
 
        AFTER FIELD eci07
	    IF g_eci.eci07 < 0 THEN
		LET g_eci.eci07 = g_eci_t.eci07
		DISPLAY BY NAME g_eci.eci07
		NEXT FIELD eci07
	    END IF

#FUN-A60028 --begin--
     AFTER FIELD eci10
       IF NOT cl_null(g_eci.eci10) THEN 
          IF g_eci.eci10 < 0 THEN 
             CALL cl_err('','aec-020',0)
             NEXT FIELD CURRENT 
          END IF 
       END IF 
#FUN-A60028 --end--
 
        AFTER FIELD eci08
	    IF g_eci.eci08 < 0 THEN
		LET g_eci.eci08 = g_eci_t.eci08
		DISPLAY BY NAME g_eci.eci08
		NEXT FIELD eci08
	    END IF
 
        AFTER INPUT
           LET g_eci.eciuser = s_get_data_owner("eci_file") #FUN-C10039
           LET g_eci.ecigrup = s_get_data_group("eci_file") #FUN-C10039
	    IF NOT INT_FLAG THEN
		LET l_sw = 'N'
		IF cl_null(g_eci.eci01) THEN
		    LET l_sw = 'Y'
		    DISPLAY BY NAME g_eci.eci01
		END IF
		IF cl_null(g_eci.eci03) THEN
		    LET l_sw = 'Y'
		    DISPLAY BY NAME g_eci.eci03
		END IF
		IF cl_null(g_eci.eci04) THEN
		    LET l_sw = 'Y'
		    DISPLAY BY NAME g_eci.eci04
		END IF
		IF cl_null(g_eci.eci05) THEN
		    LET l_sw = 'Y'
		    DISPLAY BY NAME g_eci.eci05
		END IF
		IF cl_null(g_eci.eci07) THEN
		    LET g_eci.eci07 = 0
		    DISPLAY BY NAME g_eci.eci07
		END IF
		IF cl_null(g_eci.eci08) THEN
		    LET g_eci.eci08 = 0
		    DISPLAY BY NAME g_eci.eci08
		END IF
		IF l_sw = 'Y' THEN
		   CALL cl_err(g_eci.eci01,9033,0)
                   NEXT FIELD eci01
                END IF
	     END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(eci03) #工作區編號
                  CALL q_eca(FALSE,TRUE,g_eci.eci03) RETURNING g_eci.eci03
                  DISPLAY BY NAME g_eci.eci03
                  NEXT FIELD eci03
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION maintain_work_center
            CASE
               WHEN INFIELD(eci03) #工作區編號
                  CALL cl_cmdrun('aeci600')
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
FUNCTION i670_eci03(p_cmd)  #工作中心
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
         l_eca02     LIKE eca_file.eca02,
         l_ecaacti   LIKE eca_file.ecaacti
 
     LET g_errno = ' '
        SELECT eca02,ecaacti INTO l_eca02,l_ecaacti
           FROM eca_file WHERE eca01 = g_eci.eci03
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4011'
                                        LET l_eca02 = NULL
              WHEN l_ecaacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_eca02 TO FORMONLY.eca02
     END IF
END FUNCTION
 
FUNCTION i670_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_eci.* TO NULL              #No.FUN-6A0039
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i670_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i670_count
    FETCH i670_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i670_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eci.eci01,SQLCA.sqlcode,0)
        INITIALIZE g_eci.* TO NULL
    ELSE
        CALL i670_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i670_fetch(p_fleci)
    DEFINE
        p_fleci         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_fleci
        WHEN 'N' FETCH NEXT     i670_cs INTO g_eci.eci01
        WHEN 'P' FETCH PREVIOUS i670_cs INTO g_eci.eci01
        WHEN 'F' FETCH FIRST    i670_cs INTO g_eci.eci01
        WHEN 'L' FETCH LAST     i670_cs INTO g_eci.eci01
        WHEN '/'
           IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i670_cs INTO g_eci.eci01
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eci.eci01,SQLCA.sqlcode,0)
        INITIALIZE g_eci.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_fleci
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_eci.* FROM eci_file            # 重讀DB,因TEMP有不被更新特性
       WHERE eci01 = g_eci.eci01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","eci_file",g_eci.eci01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       INITIALIZE g_eci.* TO NULL
    ELSE
        LET g_data_owner = g_eci.eciuser      #FUN-4C0034
        LET g_data_group = g_eci.ecigrup      #FUN-4C0034
        CALL i670_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i670_show()
    LET g_eci_t.* = g_eci.*
    DISPLAY BY NAME g_eci.ecioriu,g_eci.eciorig,
        g_eci.eci01,g_eci.eci06,g_eci.eci02,g_eci.eci03,g_eci.eci04,g_eci.eci05,
        g_eci.eci07,g_eci.eci08,
        g_eci.eci10,           #FUN-A60028 add
        g_eci.eciuser,g_eci.ecigrup,g_eci.ecimodu,g_eci.ecidate,g_eci.eciacti
        
 
    CALL i670_eci03('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i670_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_eci.eci01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_eci.eciacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_eci.eci01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_eci01_t = g_eci.eci01
    
   #BEGIN WORK           #FUN-9A0056 mark
   #FUN-9A0056 add begin -------------------
    IF g_action_choice <> "reproduce" THEN
       LET g_success = 'Y'
       BEGIN WORK
    END IF
   #FUN-9A0056 add end ---------------------
 
    OPEN i670_cl USING g_eci.eci01
    IF STATUS THEN
       CALL cl_err("OPEN i670_cl:", STATUS, 1)
       CLOSE i670_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i670_cl INTO g_eci.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eci.eci01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_eci.ecimodu=g_user                     #修改者
    LET g_eci.ecidate = g_today                  #修改日期
    CALL i670_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i670_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_eci.*=g_eci_t.*
            CALL i670_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE eci_file SET eci_file.* = g_eci.*    # 更新DB
            WHERE eci01 = g_eci.eci01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","eci_file",g_eci01_t,"",SQLCA.sqlcode,"","",1) #FUN-660091
           #CONTINUE WHILE        #FUN-9A0056 mark 
            LET g_success = 'N'   #FUN-9A0056 add
        END IF

       #FUN-9A0056 add begin -------------------
        IF g_action_choice <> "reproduce" THEN
          IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
             CALL i670_mes('update',g_eci.eci01)
          END IF
        END IF

        IF g_success = 'N' THEN
          ROLLBACK WORK
          BEGIN WORK
          CONTINUE WHILE
        ELSE
          COMMIT WORK
        END IF
       #FUN-9A0056 add end ---------------------
        
        EXIT WHILE
    END WHILE
    CLOSE i670_cl
    #COMMIT WORK     #FUN-9A0056 mark
END FUNCTION
 
FUNCTION i670_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_eci.eci01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    LET g_success = 'Y'                    #FUN-9A0056 add
    BEGIN WORK
 
    OPEN i670_cl USING g_eci.eci01
    IF STATUS THEN
       CALL cl_err("OPEN i670_cl:", STATUS, 1)
       CLOSE i670_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i670_cl INTO g_eci.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eci.eci01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i670_show()
    IF cl_exp(15,21,g_eci.eciacti) THEN
        LET g_chr=g_eci.eciacti
        IF g_eci.eciacti='Y' THEN
            LET g_eci.eciacti='N'
        ELSE
            LET g_eci.eciacti='Y'
        END IF
        UPDATE eci_file
            SET eciacti=g_eci.eciacti,
               ecimodu=g_user, ecidate=g_today
            WHERE eci01=g_eci.eci01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","eci_file",g_eci.eci01,"",SQLCA.sqlcode,"","",1) #FUN-660091
            LET g_eci.eciacti=g_chr
       #FUN-9A0056 -- add begin ---------------------------
            LET g_success = 'N'
              #當資料為有效變無效,傳送刪除給MES;反之,則傳送新增給MES
        ELSE
          IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
            IF g_eci.eciacti='N' THEN
               CALL i670_mes('delete',g_eci.eci01)
            ELSE
               CALL i670_mes('insert',g_eci.eci01)
            END IF
          END IF
       #FUN-9A0056 add end ---------------------------------
        END IF
        DISPLAY BY NAME g_eci.eciacti
    END IF
    CLOSE i670_cl
   #COMMIT WORK   #FUN-9A0056 mark
   #FUN-9A0056 -- add begin ----
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
   #FUN-9A0056 -- add end ------
END FUNCTION
 
FUNCTION i670_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_eci.eci01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_eci.eciacti = 'N' THEN CALL cl_err('','9027',0) RETURN END IF #No.TQC-920063 ADD
    LET g_success = 'Y'  #FUN-9A0056 add
    BEGIN WORK
 
    OPEN i670_cl USING g_eci.eci01
    IF STATUS THEN
       CALL cl_err("OPEN i670_cl:", STATUS, 1)
       CLOSE i670_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i670_cl INTO g_eci.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eci.eci01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i670_show()
    IF cl_delete() THEN
       DELETE FROM eci_file WHERE eci01 = g_eci.eci01
       DELETE FROM vmd_file where vmd01 = g_eci.eci01  #FUN-890085
       CLEAR FORM

      #FUN-9A0056 add begin -----------
      #與MES整合
       IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" AND g_eci.eciacti = 'Y' THEN
         CALL i670_mes('delete',g_eci.eci01)
       END IF
      #FUN-9A0056 add end -------------
       
      #IF g_sma.sma901 = 'Y' THEN                          #FUN-9A0056 mark
       IF g_success='Y' AND g_sma.sma901 = 'Y' THEN        #FUN-9A0056 add
           DELETE FROM aps_eci WHERE eq_id = g_eci.eci01
       END IF
       OPEN i670_count
       FETCH i670_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i670_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i670_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i670_fetch('/')
       END IF
    END IF
    CLOSE i670_cl
   #COMMIT WORK  #FUN-9A0056 mark

   #FUN-9A0056 add begin ----
    IF g_success = 'N' THEN
      ROLLBACK WORK
      LET g_success = 'Y'
    ELSE
      COMMIT WORK
    END IF
   #FUN-9A0056 add end ------
END FUNCTION
 
FUNCTION i670_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
        l_oldno         LIKE eci_file.eci01,
        l_newno         LIKE eci_file.eci01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_eci.eci01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i670_set_entry('a')
    CALL i670_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM eci01
        AFTER FIELD eci01
            IF l_newno IS NULL THEN
                NEXT FIELD eci01
            END IF
            SELECT count(*) INTO g_cnt FROM eci_file
                WHERE eci01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD eci01
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_eci.eci01
        RETURN
    END IF
    SELECT * FROM eci_file
        WHERE eci01=g_eci.eci01
        INTO TEMP x
    UPDATE x
        SET eci01=l_newno,    #資料鍵值
            eciuser=g_user,   #資料所有者
            ecigrup=g_grup,   #資料所有者所屬群
            ecimodu=NULL,     #資料修改日期
            ecidate=g_today,  #資料建立日期
            eciacti='Y'       #有效資料

    LET g_success = 'Y'       #FUN-9A0056 add
    BEGIN WORK                #FUN-9A0056 add
    
    INSERT INTO eci_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","eci_file",g_eci.eci01,"",SQLCA.sqlcode,"","",1) #FUN-660091
        LET g_success = 'N'       #FUN-9A0056 add
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
	LET l_oldno = g_eci.eci01
	LET g_eci.eci01 = l_newno
	SELECT eci_file.* INTO g_eci.*
          FROM eci_file WHERE eci01 = l_newno
	CALL i670_u()
	CALL i670_show()
    
       #FUN-9A0056 add begin -------
       #與MES整合
        IF g_aza.aza90 MATCHES "[Yy]" THEN
           CALL i670_mes('insert',g_eci.eci01)
        END IF
       #FUN-9A0056 add end ---------
    END IF
    DROP TABLE x

   #FUN-9A0056 -- add begin ----
    IF g_success = 'N' THEN
      ROLLBACK WORK
    ELSE
      COMMIT WORK
    END IF
   #FUN-9A0056 -- add end ------
    DISPLAY BY NAME g_eci.eci01
END FUNCTION
 
FUNCTION i670_out()

DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) AND NOT cl_null(g_eci.eci01) THEN                          
       LET g_wc = " eci01 = '",g_eci.eci01,"' "                                 
    END IF                                                                      
    IF g_wc IS NULL THEN                                                        
       CALL cl_err('','9057',0) RETURN                                          
    END IF                                                                      
                                                                                
    #報表轉為使用 p_query                                                       
    LET l_cmd = 'p_query "aeci670" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)                                                       
    RETURN

END FUNCTION
 

 
FUNCTION i670_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("eci01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i670_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("eci01",FALSE)
   END IF
END FUNCTION
 
#No.FUN-9C0077 程式精簡 

#FUN-9A0056 -- add i670_mes() for MES
FUNCTION i670_mes(p_key1,p_key2)
 DEFINE p_key1   VARCHAR(6)
 DEFINE p_key2   VARCHAR(500)
 DEFINE l_mesg01 VARCHAR(30)

 CASE p_key1
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

#CALL aws_mescli
#傳入參數: (1)程式代號
#          (2)功能選項：insert(新增),update(修改),delete(刪除)
#          (3)Key
 CASE aws_mescli('aeci670',p_key1,p_key2)
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
         LET g_success = 'N'
 END CASE

END FUNCTION
#FUN-9A0056 -- add end-------------------------

