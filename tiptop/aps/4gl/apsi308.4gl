# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsi308.4gl
# Descriptions...: 料件基本資料維護
# Date & Author..: FUN-850114 08/02/29 BY Yiting  
# Modify.........: No.FUN-840209 08/05/19 BY DUKE
# Modify.........: No.FUN-860060 08/06/23 by duke
# Modify.........: No.FUN-8A0149 08/11/03 by duke vmi57是否批次作業設定為 readonly
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0076 09/10/26 By lilingyu 改寫Sql的標準寫法
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: FUN-B50004 11/05/03 By Abby---GP5.25 追版---str---
# Modify.........: FUN-930087 08/03/16 By Duke 增加供應商比例最低量限制 vmi65欄位,預設值為0
# Modify.........: FUN-A80048 10/08/10 By Mandy 「是否依照供應商比例開立」欄位(vmi64)開放維護
# Modify.........: FUN-B50004 11/05/03 By Abby---GP5.25 追版---end---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmi           RECORD LIKE vmi_file.*, #FUN-720043
    g_vmi_t         RECORD LIKE vmi_file.*, #FUN-720043
    g_vmi01         LIKE vmi_file.vmi01,      #品項編號   #FUN-850114
    g_flag          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_wc,g_sql      string  #No.FUN-580092 HCN
 
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER

MAIN
    OPTIONS					#改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
    INITIALIZE g_vmi.* TO NULL
    INITIALIZE g_vmi_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vmi_file WHERE vmi01 = ? FOR UPDATE"  #FUN-9A0076
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i308_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i308_w WITH FORM "aps/42f/apsi308"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_vmi.vmi01  = ARG_VAL(1)
    IF g_vmi.vmi01 IS NOT NULL AND  g_vmi.vmi01 != ' '
       THEN LET g_flag = 'Y'
            CALL i308_q()
       ELSE LET g_flag = 'N'
    END IF
 
    LET g_action_choice=""
    CALL i308_menu()
 
    CLOSE WINDOW i308_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i308_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = " vmi01='",g_vmi.vmi01,"'"
    ELSE
   INITIALIZE g_vmi.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
vmi01,vmi03,vmi05,vmi08,vmi11,vmi15,vmi16,vmi17, 
vmi23,vmi24,vmi25,vmi28,vmi35,vmi36, 
vmi37,vmi38,vmi40,vmi44,vmi45,vmi47, 
vmi49,vmi50,vmi51,vmi52,vmi53,vmi54,vmi55,vmi56, 
vmi60,
vmi64,  #FUN-A80048 add
vmi65   #FUN-930087 ADD
 
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
    END IF
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmeuser', 'pmegrup')
 
    LET g_sql = "SELECT vmi01 FROM vmi_file ",   # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY vmi01"
    PREPARE i308_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i308_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i308_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vmi_file WHERE ",g_wc CLIPPED
    PREPARE i308_precount FROM g_sql
    DECLARE i308_count CURSOR FOR i308_precount
END FUNCTION
 
FUNCTION i308_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_set_comp_entry("vmi57",FALSE)  #FUN-8A0149  ADD
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i308_q()
           END IF
        ON ACTION first
           CALL i308_fetch('F')
        ON ACTION next
           CALL i308_fetch('N')
        ON ACTION previous
           CALL i308_fetch('P')
        ON ACTION last
           CALL i308_fetch('L')
        ON ACTION jump
           CALL i308_fetch('/')
        ON ACTION modify
           CALL i308_u()
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_vmi.vmi01 IS NOT NULL THEN
                  LET g_doc.column1 = "vmi01"
                  LET g_doc.value1 = g_vmi.vmi01
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i308_cs
END FUNCTION
 
 
FUNCTION i308_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vmi.* LIKE vmi_file.*
    LET g_vmi.vmi01 = NULL
    LET g_vmi.vmi03 = 0
    LET g_vmi.vmi05 = 0
    LET g_vmi.vmi08 = 999999  #TQC-750013 mod
    LET g_vmi.vmi11 = 0
    LET g_vmi.vmi15 = 0
    LET g_vmi.vmi16 = 0
    LET g_vmi.vmi17 = 0
    LET g_vmi.vmi23 = 0  
    LET g_vmi.vmi24 = 1  
    LET g_vmi.vmi25 = 0  
    LET g_vmi.vmi28 = NULL
    LET g_vmi.vmi35 = 0  
    LET g_vmi.vmi36 = NULL  
    LET g_vmi.vmi37 = 7  
    LET g_vmi.vmi38 = 0  
    LET g_vmi.vmi40 = NULL  
    LET g_vmi.vmi44 = NULL 
    LET g_vmi.vmi45 = NULL  
    LET g_vmi.vmi47 = 0  
    LET g_vmi.vmi49 = 1
    LET g_vmi.vmi50 = 1
    LET g_vmi.vmi51 = NULL
    LET g_vmi.vmi52 = NULL
    LET g_vmi.vmi53 = NULL
    LET g_vmi.vmi54 = NULL
    LET g_vmi.vmi55 = NULL
    LET g_vmi.vmi60 = 0
    LET g_vmi.vmi64 = 0  #FUN-A80048 add
    LET g_vmi.vmi65 = 0  #FUN-930087  ADD
    LET g_vmi_t.*=g_vmi.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i308_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vmi.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_vmi.vmi01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vmi_file VALUES(g_vmi.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmi_file",g_vmi.vmi01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            update ima_file set imadate=sysdate where ima01=g_vmi.vmi01 #FUN-860060
            LET g_vmi_t.* = g_vmi.*                # 保存上筆資料
SELECT vmi01 INTO g_vmi.vmi01 FROM vmi_file
WHERE vmi01 = g_vmi.vmi01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i308_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
        DISPLAY BY NAME
          g_vmi.vmi01,g_vmi.vmi03,g_vmi.vmi05,g_vmi.vmi08,
          g_vmi.vmi11,g_vmi.vmi15,g_vmi.vmi16,g_vmi.vmi17,
          g_vmi.vmi23,g_vmi.vmi24,
          g_vmi.vmi25,g_vmi.vmi28,g_vmi.vmi35,g_vmi.vmi36,
          g_vmi.vmi37,g_vmi.vmi38,g_vmi.vmi40,g_vmi.vmi44,g_vmi.vmi45,
          g_vmi.vmi47,
          g_vmi.vmi49,g_vmi.vmi50,g_vmi.vmi51,g_vmi.vmi52,g_vmi.vmi53,
          g_vmi.vmi54,g_vmi.vmi55,g_vmi.vmi56,
          g_vmi.vmi60,
          g_vmi.vmi57,
          g_vmi.vmi64, #FUN-A80048 add
          g_vmi.vmi65  #FUN-930087 ADD          
        INPUT BY NAME
          g_vmi.vmi01,g_vmi.vmi03,g_vmi.vmi05,g_vmi.vmi08,
          g_vmi.vmi11,g_vmi.vmi15,g_vmi.vmi16,g_vmi.vmi17,
          g_vmi.vmi23,g_vmi.vmi24,
          g_vmi.vmi25,g_vmi.vmi28,g_vmi.vmi35,g_vmi.vmi36,
          g_vmi.vmi37,g_vmi.vmi38,g_vmi.vmi40,g_vmi.vmi44,g_vmi.vmi45,
          g_vmi.vmi47,
          g_vmi.vmi49,g_vmi.vmi50,g_vmi.vmi51,g_vmi.vmi52,g_vmi.vmi53,
          g_vmi.vmi54,g_vmi.vmi55,g_vmi.vmi56,
          g_vmi.vmi60,
          g_vmi.vmi57,
          g_vmi.vmi64, #FUN-A80048 add
          g_vmi.vmi65  #FUN-930087 ADD    
        WITHOUT DEFAULTS
 
 
    BEFORE INPUT
       CALL i308_set_no_entry(p_cmd)
 
        AFTER FIELD vmi03
            IF NOT cl_null(g_vmi.vmi03) THEN
               IF g_vmi.vmi03 NOT MATCHES '[012]' THEN
                  NEXT FIELD vmi03
               END IF
            END IF
            LET g_vmi_t.vmi03 = g_vmi.vmi03
 
        AFTER FIELD vmi11
            IF NOT cl_null(g_vmi.vmi11) THEN
               IF g_vmi.vmi11 NOT MATCHES '[01]' THEN
                  NEXT FIELD vmi11
               END IF
            END IF
            LET g_vmi_t.vmi11 = g_vmi.vmi11
 
 
        AFTER FIELD vmi15
            IF NOT cl_null(g_vmi.vmi15) THEN
               IF g_vmi.vmi15 NOT MATCHES '[01]' THEN
                  NEXT FIELD vmi15
               END IF
            END IF
            LET g_vmi_t.vmi15 = g_vmi.vmi15

        #FUN-930087    ADD   --STR--
        AFTER FIELD vmi65
           IF cl_null(g_vmi.vmi65) OR
              (NOT cl_null(g_vmi.vmi65) AND g_vmi.vmi65<0)  THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmi65
           END IF
           LET g_vmi_t.vmi65 = g_vmi.vmi65
        #FUN-930087    ADD    --END--
 
        AFTER FIELD vmi08
           IF NOT cl_null(g_vmi.vmi08) and g_vmi.vmi08<0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmi08
           END IF
           LET g_vmi_t.vmi08 = g_vmi.vmi08
 
        AFTER FIELD vmi16
           IF NOT cl_null(g_vmi.vmi16) and g_vmi.vmi16<0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmi16
           END IF
           LET g_vmi_t.vmi16 = g_vmi.vmi16
       AFTER FIELD vmi17
          IF NOT cl_null(g_vmi.vmi17) and g_vmi.vmi17<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi17
          END IF
          LET g_vmi_t.vmi17 = g_vmi.vmi17
       AFTER FIELD vmi24
          IF NOT cl_null(g_vmi.vmi24) and g_vmi.vmi24<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi24
          END IF
          LET g_vmi_t.vmi24 = g_vmi.vmi24
 
       AFTER FIELD vmi35
          IF NOT cl_null(g_vmi.vmi35) and g_vmi.vmi35<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi35
          END IF
          LET g_vmi_t.vmi35 = g_vmi.vmi35
 
       AFTER FIELD vmi37
          IF NOT cl_null(g_vmi.vmi37) and g_vmi.vmi37<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi37
          END IF
          LET g_vmi_t.vmi37 = g_vmi.vmi37
 
       AFTER FIELD vmi38
          IF NOT cl_null(g_vmi.vmi38) and g_vmi.vmi38<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi38
          END IF
          LET g_vmi_t.vmi38 = g_vmi.vmi38
 
       AFTER FIELD vmi60
          IF NOT cl_null(g_vmi.vmi60) and g_vmi.vmi60<0 THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmi60
          END IF
          LET g_vmi_t.vmi60 = g_vmi.vmi60
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vmi01
           END IF
 
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
 
FUNCTION i308_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i308_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vmi.* TO NULL
        RETURN
    END IF
    OPEN i308_count
    FETCH i308_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i308_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmi.vmi01,SQLCA.sqlcode,0)
        INITIALIZE g_vmi.* TO NULL
    ELSE
        CALL i308_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i308_fetch(p_flpme)
    DEFINE
        p_flpme         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flpme
        WHEN 'N' FETCH NEXT     i308_cs INTO g_vmi.vmi01
        WHEN 'P' FETCH PREVIOUS i308_cs INTO g_vmi.vmi01
        WHEN 'F' FETCH FIRST    i308_cs INTO g_vmi.vmi01
        WHEN 'L' FETCH LAST     i308_cs INTO g_vmi.vmi01
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso i308_cs INTO g_vmi.vmi01
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmi.vmi01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vmi.* TO NULL          #No.FUN-6A0163
        RETURN
    ELSE
       CASE p_flpme
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vmi.* FROM vmi_file            
WHERE vmi01 = g_vmi.vmi01
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmi.vmi01 CLIPPED
         CALL cl_err3("sel","vmi_file",g_vmi.vmi01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vmi.* TO NULL       #No.FUN-6A0163
    ELSE
 
        CALL i308_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i308_show()
    LET g_vmi_t.* = g_vmi.*
 
     DISPLAY BY NAME
           g_vmi.vmi01,g_vmi.vmi03,g_vmi.vmi05,g_vmi.vmi08,
           g_vmi.vmi11,g_vmi.vmi15,g_vmi.vmi16,g_vmi.vmi17,
           g_vmi.vmi23,g_vmi.vmi24,
           g_vmi.vmi25,g_vmi.vmi28,g_vmi.vmi35,g_vmi.vmi36,
           g_vmi.vmi37,g_vmi.vmi38,g_vmi.vmi40,g_vmi.vmi44,g_vmi.vmi45,
           g_vmi.vmi47,
           g_vmi.vmi49,g_vmi.vmi50,g_vmi.vmi51,g_vmi.vmi52,g_vmi.vmi53,
           g_vmi.vmi54,g_vmi.vmi55,g_vmi.vmi56,
           g_vmi.vmi60,
           g_vmi.vmi57,
           g_vmi.vmi64, #FUN-A80048 add  
           g_vmi.vmi65  #FUN-930087 ADD
 
    LET g_vmi.vmi05 = 0 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i308_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmi.vmi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmi01 = g_vmi.vmi01
    BEGIN WORK
 
    OPEN i308_cl USING g_vmi.vmi01
    IF STATUS THEN
       CALL cl_err("OPEN i308_cl:", STATUS, 1)
       CLOSE i308_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i308_cl INTO g_vmi.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmi.vmi01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i308_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i308_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmi.* = g_vmi_t.*
            CALL i308_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmi_file SET vmi_file.* = g_vmi.*    # 更新DB
            WHERE vmi01 = g_vmi01               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           LET g_msg = g_vmi.vmi01 CLIPPED
            CALL cl_err3("upd","vmi_file",g_vmi01,"",SQLCA.sqlcode,"","",1) # FUN-660095
           CONTINUE WHILE
        ELSE
           update ima_file set imadate=sysdate where ima01=g_vmi.vmi01 #FUN-860060
           LET g_vmi_t.* = g_vmi.*# 保存上筆資料
SELECT vmi01 INTO g_vmi.vmi01 FROM vmi_file
WHERE vmi01 = g_vmi.vmi01
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i308_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i308_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmi.vmi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i308_cl USING g_vmi.vmi01
    IF STATUS THEN
       CALL cl_err("OPEN i308_cl:", STATUS, 1)
       CLOSE i308_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i308_cl INTO g_vmi.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmi.vmi01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i308_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmi01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmi.vmi01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM vmi_file WHERE vmi01 = g_vmi.vmi01
            update ima_file set imadate=sysdate where ima01=g_vmi.vmi01  #FUN-860060
            CLEAR FORM
    END IF
    CLOSE i308_cl
    INITIALIZE g_vmi.* TO NULL
    COMMIT WORK
END FUNCTION
 
FUNCTION i308_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
#FUN-B50004 GP5.25追版
