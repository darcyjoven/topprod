# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmi705.4gl
# Descriptions...: 業務員工作日報維護作業
# Date & Author..: 02/11/10 by Leagh
# Modify.........: 04/08/04 By Wiky Bugno.MOD-480103 copy寫法有誤
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-740234 07/04/22 By Sarah 從axmi701串過來時,g_argv2是傳空白的,所以cs()的判斷要改寫
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-830152 08/04/10 By baofei  報表打印改為CR輸出
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: NO.TQC-980066 09/08/11 By lilingyu 1.無效資料不可刪除 2.復制時,狀態page的相關欄位應該重新賦值
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0159 09/11/30 By alex 將ofg_file調整non-key為pk, 取消rowid
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0192 10/11/29 by lixh1  INAERT 時新增ofgplant,ofglegal欄位
# Modify.........: No.TQC-B20145 11/02/22 By zhangll 欄位顯示錯誤
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BA0107 11/10/19 By destiny oriu,orig不能查询
# Modify.........: No.TQC-BC0070 12/01/05 By SunLM ofg04增加管控
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ofg   RECORD LIKE ofg_file.*,
    g_ofg_t RECORD LIKE ofg_file.*,
    g_ofg_o RECORD LIKE ofg_file.*,
    g_ofg01_t      LIKE ofg_file.ofg01,
    g_ofg02_t      LIKE ofg_file.ofg02,
    g_ofg03_t      LIKE ofg_file.ofg03,
    g_ofg01_c      LIKE ofg_file.ofg01,  #No.MOD-480103
    g_ofg02_c      LIKE ofg_file.ofg02,  #No.MOD-480103
    g_ofg03_c      LIKE ofg_file.ofg03,  #No.MOD-480103
    g_argv1        LIKE ofg_file.ofg01,
    g_argv2        LIKE ofg_file.ofg02,
    g_argv3        LIKE ofg_file.ofg03,
    g_argv4        LIKE ofg_file.ofg04,
    g_wc,g_sql     STRING,  
    l_cmd          LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE g_cmd       LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE g_buf       LIKE ima_file.ima01     #No.FUN-680137 VARCHAR(40)
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done    STRING
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   INITIALIZE g_ofg.* TO NULL
   INITIALIZE g_ofg_t.* TO NULL
   INITIALIZE g_ofg_o.* TO NULL
   LET g_ofg.ofguser = g_user
   LET g_ofg.ofgoriu = g_user #FUN-980030
   LET g_ofg.ofgorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_ofg.ofggrup = g_grup
   LET g_ofg.ofgdate = g_today
   LET g_ofg.ofgacti = 'Y'
 
   LET g_forupd_sql = "SELECT * FROM ofg_file WHERE ofg01 = ? AND ofg02 = ? AND ofg03 = ? FOR UPDATE "   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i705_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
 
    OPEN WINDOW i705_w WITH FORM "axm/42f/axmi705"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL i705_q()
    END IF
 
    LET g_action_choice=""
    CALL i705_menu()
 
    CLOSE WINDOW i705_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i705_cs()
    LET g_wc = ""
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "ofg01 ='",g_argv1,"'"
       IF NOT cl_null(g_argv2) THEN 
          LET g_wc = g_wc," AND ofg02 = '",g_argv2,"'"
       END IF
       IF NOT cl_null(g_argv3) THEN 
          LET g_wc = g_wc," AND ofg03 = '",g_argv3,"'"
       END IF
      #end MOD-740234 modify
    ELSE
       CLEAR FORM
   INITIALIZE g_ofg.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                   # 螢幕上取條件
           ofg01,ofg02,ofg03,ofg04,ofg05,ofg051,ofg052,ofg053,ofg054,
           ofg06,ofg061,ofg062,ofg063,ofg064,
           ofguser,ofggrup,ofgmodu,ofgdate,ofgacti
            ,ofgoriu,ofgorig  #TQC-BA0107

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           IF INFIELD(ofg01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ofg.ofg01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ofg01
              NEXT FIELD ofg01
           END IF
           IF INFIELD(ofg03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_ofd"
              LET g_qryparam.default1 = g_ofg.ofg03
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ofg03
              NEXT FIELD ofg03
           END IF
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
    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofguser', 'ofggrup')
 
    LET g_sql="SELECT ofg01,ofg02,ofg03 FROM ofg_file ", # 組合出 SQL 指令  #liuxqa 091021
              " WHERE ",g_wc CLIPPED, " ORDER BY ofg01,ofg02,ofg03"
    PREPARE i705_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i705_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i705_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ofg_file WHERE ",g_wc CLIPPED
    PREPARE i705_precount FROM g_sql
    DECLARE i705_count CURSOR FOR i705_precount
END FUNCTION
 
FUNCTION i705_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i705_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL i705_q()
            END IF
 
        ON ACTION next
           CALL i705_fetch('N')
 
        ON ACTION previous
           CALL i705_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i705_u()
            END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i705_x()
            END IF
            #圖形顯示
            CALL cl_set_field_pic("","","","","",g_ofg.ofgacti)
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i705_r()
            END IF
 
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i705_copy()
            END IF
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i705_out()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #圖形顯示
           CALL cl_set_field_pic("","","","","",g_ofg.ofgacti)
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i705_fetch('/')
 
        ON ACTION first
           CALL i705_fetch('F')
 
        ON ACTION last
           CALL i705_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_ofg.ofg01 IS NOT NULL THEN            
                  LET g_doc.column1 = "ofg01"               
                  LET g_doc.column2 = "ofg02"     
                  LET g_doc.column3 = "ofg03"          
                  LET g_doc.value1 = g_ofg.ofg01            
                  LET g_doc.value2 = g_ofg.ofg02   
                  LET g_doc.value3 = g_ofg.ofg03         
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0020-------add--------end----
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i705_cs
END FUNCTION
 
 
 
FUNCTION i705_a()
    DEFINE l_cmd    LIKE gbc_file.gbc05        #No.FUN-680137  VARCHAR(100)
    DEFINE l_ofg02  LIKE ofg_file.ofg02
    DEFINE l_ofg04  LIKE ofg_file.ofg04
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                    # 清螢幕欄位內容
    INITIALIZE g_ofg.* LIKE ofg_file.*
    LET g_ofg01_t = NULL
    LET g_ofg02_t = NULL
    LET g_ofg03_t = NULL
    IF NOT cl_null(g_argv4) THEN LET g_ofg.ofg04 = g_argv4 END IF
    CALL cl_opmsg('a')

    WHILE TRUE
        LET g_ofg.ofg02 = g_today
        LET g_ofg.ofgacti = 'Y'
        LET g_ofg.ofguser = g_user
        LET g_ofg.ofggrup = g_grup
        LET g_ofg.ofgdate = g_today
        LET g_ofg.ofgplant = g_plant    #FUN-980010
        LET g_ofg.ofglegal = g_legal    #FUN-980010
        LET g_ofg.ofgoriu = g_user  #Add No.TQC-B20145
        LET g_ofg.ofgorig = g_grup  #Add No.TQC-B20145
 
        LET g_ofg_t.*=g_ofg.*
        CALL i705_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                        # 若按了DEL鍵
            LET INT_FLAG = 0
            LET g_ofg.*=g_ofg_o.*
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ofg.ofg01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ofg_file(ofg01,ofg02,ofg03,ofg04,ofg05,ofg051,ofg052,ofg053,ofg054,ofg06,ofg061,ofg062,ofg063,ofg064,ofgacti,ofguser,ofggrup,ofgmodu,ofgdate,ofgoriu,ofgorig,ofgplant,ofglegal) VALUES(g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03,g_ofg.ofg04,g_ofg.ofg05,g_ofg.ofg051,g_ofg.ofg052,g_ofg.ofg053,g_ofg.ofg054,g_ofg.ofg06,g_ofg.ofg061,g_ofg.ofg062,g_ofg.ofg063,g_ofg.ofg064,g_ofg.ofgacti,g_ofg.ofguser,g_ofg.ofggrup,g_ofg.ofgmodu,g_ofg.ofgdate, g_user, g_grup,g_plant,g_legal)       # DISK WRITE      #No.FUN-980030 10/01/04  insert columns oriu, orig    #TQC-AB0192
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ofg_file",g_ofg.ofg01,g_ofg.ofg02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        #更新潛在客戶主檔的最后追蹤日期,成交機率
        SELECT MAX(ofg02),ofg04 INTO l_ofg02,l_ofg04 FROM ofg_file
         WHERE ofg01 = g_ofg.ofg01 AND ofg03 = g_ofg.ofg03
         GROUP BY ofg04
        IF STATUS THEN LET l_ofg02 ='' LET l_ofg04 = '' END IF
 
        UPDATE ofd_file SET ofd26 = l_ofg02,
                            ofd29 = l_ofg04
         WHERE ofd01 = g_ofg.ofg03
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('upd ofd29',STATUS,0)   #No.FUN-660167
           CALL cl_err3("upd","ofd_file",g_ofg.ofg03,"",STATUS,"","upd ofd29",1)  #No.FUN-660167
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i705_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
	l_chr		LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
        l_gen02         LIKE gen_file.gen02,
        l_ofd02         LIKE ofd_file.ofd02,
        l_n             LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
 
    INPUT BY NAME g_ofg.ofgoriu,g_ofg.ofgorig,
        g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03,g_ofg.ofg04,
        g_ofg.ofg05,g_ofg.ofg051,g_ofg.ofg052,g_ofg.ofg053,g_ofg.ofg054,
        g_ofg.ofg06,g_ofg.ofg061,g_ofg.ofg062,g_ofg.ofg063,g_ofg.ofg064,
        g_ofg.ofguser,g_ofg.ofggrup,g_ofg.ofgmodu,g_ofg.ofgdate,g_ofg.ofgacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i705_set_entry(p_cmd)
           CALL i705_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD ofg01
            IF NOT cl_null(g_argv1) THEN
               LET g_ofg.ofg01 = g_argv1
               DISPLAY BY NAME g_ofg.ofg01
               SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01 = g_ofg.ofg01
               DISPLAY l_gen02 TO FORMONLY.gen02
               NEXT FIELD ofg02
            END IF
 
        AFTER FIELD ofg01
          IF g_ofg.ofg01 IS NOT NULL THEN
            IF p_cmd='a' OR (p_cmd='u' AND g_ofg_t.ofg01 != g_ofg.ofg01) THEN
               CALL i705_ofg01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ofg.ofg01,g_errno,0)
                  LET g_ofg.ofg01 = g_ofg_t.ofg01
                  DISPLAY BY NAME g_ofg.ofg01
                  NEXT FIELD ofg01
               END IF
            END IF
          END IF
 
        BEFORE FIELD ofg02
            IF NOT cl_null(g_argv2) THEN
               LET g_ofg.ofg02 = g_argv2
               DISPLAY BY NAME g_ofg.ofg02
               NEXT FIELD ofg03
            END IF
 
        BEFORE FIELD ofg03
            IF NOT cl_null(g_argv3) THEN
               LET g_ofg.ofg03 = g_argv3
               DISPLAY BY NAME g_ofg.ofg03
               SELECT ofd02 INTO l_ofd02 FROM ofd_file
                WHERE ofd01 = g_ofg.ofg03
               DISPLAY l_ofd02 TO FORMONLY.ofd02
               NEXT FIELD ofg04
            END IF
 
        AFTER FIELD ofg03
	IF g_ofg.ofg03 IS NOT NULL THEN
          IF p_cmd='a' OR (p_cmd='u' AND g_ofg_t.ofg03 != g_ofg.ofg03) THEN
             CALL i705_ofg03('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ofg.ofg03,g_errno,0)
                LET g_ofg.ofg03 = g_ofg_t.ofg03
                DISPLAY BY NAME g_ofg.ofg03
                NEXT FIELD ofg03
             END IF
          END IF
          IF p_cmd = "a" OR (p_cmd = "u" AND
            (g_ofg.ofg01 != g_ofg01_t OR g_ofg.ofg02 != g_ofg02_t OR
             g_ofg.ofg03 != g_ofg03_t)) THEN
             SELECT COUNT(*) INTO l_n FROM ofg_file
              WHERE ofg01 = g_ofg.ofg01
                AND ofg02 = g_ofg.ofg02
                AND ofg03 = g_ofg.ofg03
             IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err(g_ofg.ofg01,-239,0)
                 LET g_ofg.ofg01 = g_ofg01_t
                 LET g_ofg.ofg02 = g_ofg02_t
                 LET g_ofg.ofg03 = g_ofg03_t
                 DISPLAY BY NAME g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
                 NEXT FIELD ofg01
             END IF
          END IF
        END IF
#TQC-BC0070 begin
        AFTER FIELD ofg04
           IF NOT cl_null(g_ofg.ofg04) THEN 
              IF g_ofg.ofg04 < 0 OR g_ofg.ofg04 > 100 THEN 
                 CALL cl_err(g_ofg.ofg04,'mfg4013',0)
                 NEXT FIELD ofg04
              END IF 
           END IF 
        
#TQC-BC0070 end      
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(ofg01) THEN
      #          LET g_ofg.* = g_ofg_t.*
      #          DISPLAY BY NAME g_ofg.*
      #          NEXT FIELD ofg01
      #      END IF
      #MOD-650015 --end
        AFTER INPUT
           LET g_ofg.ofguser = s_get_data_owner("ofg_file") #FUN-C10039
           LET g_ofg.ofggrup = s_get_data_group("ofg_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           IF INFIELD(ofg01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ofg.ofg01
              CALL cl_create_qry() RETURNING g_ofg.ofg01
              DISPLAY BY NAME g_ofg.ofg01
              NEXT FIELD ofg01
           END IF
           IF INFIELD(ofg03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ofd"
              LET g_qryparam.default1 = g_ofg.ofg03
              CALL cl_create_qry() RETURNING g_ofg.ofg03
#              CALL FGL_DIALOG_SETBUFFER( g_ofg.ofg03 )
              DISPLAY BY NAME g_ofg.ofg03
              NEXT FIELD ofg03
           END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                       # 欄位說明
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
 
FUNCTION i705_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i705_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i705_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ofg.ofg01,SQLCA.sqlcode,0)
       INITIALIZE g_ofg.* TO NULL
    ELSE
      OPEN i705_count
      FETCH i705_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i705_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i705_fetch(p_flag)

    DEFINE p_flag         LIKE type_file.chr1      
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i705_cs INTO g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
        WHEN 'P' FETCH PREVIOUS i705_cs INTO g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
        WHEN 'F' FETCH FIRST    i705_cs INTO g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
        WHEN 'L' FETCH LAST     i705_cs INTO g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
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
            FETCH ABSOLUTE g_jump i705_cs INTO g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofg.ofg01,SQLCA.sqlcode,0)
        INITIALIZE g_ofg.* TO NULL              #No.FUN-6A0020
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ofg.* FROM ofg_file            # 重讀DB,因TEMP有不被更新特性
     WHERE ofg01 = g_ofg.ofg01
       AND ofg02 = g_ofg.ofg02
       AND ofg03 = g_ofg.ofg03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ofg_file",g_ofg.ofg01,g_ofg.ofg02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ofg.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_ofg.ofguser      #FUN-4C0057 add
       LET g_data_group = g_ofg.ofggrup      #FUN-4C0057 add
       LET g_data_plant = g_ofg.ofgplant #FUN-980030
       CALL i705_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i705_show()
    LET g_ofg_t.* = g_ofg.*
    DISPLAY BY NAME g_ofg.ofgoriu,g_ofg.ofgorig,
        g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03,g_ofg.ofg04,
        g_ofg.ofg05,g_ofg.ofg051,g_ofg.ofg052,g_ofg.ofg053,g_ofg.ofg054,
        g_ofg.ofg06,g_ofg.ofg061,g_ofg.ofg062,g_ofg.ofg063,g_ofg.ofg064,
        g_ofg.ofguser,g_ofg.ofggrup,g_ofg.ofgmodu,g_ofg.ofgdate,g_ofg.ofgacti
    CALL i705_ofg01('d')
    CALL i705_ofg03('d')
    #圖形顯示
    CALL cl_set_field_pic("","","","","",g_ofg.ofgacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i705_ofg01(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02   LIKE gen_file.gen02
 
    LET g_errno = ' '
     #No.MOD-480103
    IF p_cmd ='c' THEN
       SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
        WHERE gen01 = g_ofg01_c
    ELSE
       SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
        WHERE gen01 = g_ofg.ofg01
    END IF
     #No.MOD-480103(end)
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                   LET l_gen02 = NULL
                                   LET l_genacti = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION i705_ofg03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_ofdacti LIKE ofd_file.ofdacti,
           l_ofd02   LIKE ofd_file.ofd02
 
    LET g_errno = ' '
     #No.MOD-480103
    IF p_cmd ='c' THEN
       SELECT ofd02,ofdacti INTO l_ofd02,l_ofdacti FROM ofd_file
        WHERE ofd01 = g_ofg03_c
    ELSE
       SELECT ofd02,ofdacti INTO l_ofd02,l_ofdacti FROM ofd_file
        WHERE ofd01 = g_ofg.ofg03
    END IF
     #No.MOD-480103(end)
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2732'
                                   LET l_ofd02 = NULL
                                   LET l_ofdacti = NULL
         WHEN l_ofdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ofd02  TO FORMONLY.ofd02
    END IF
END FUNCTION
 
FUNCTION i705_u()
    DEFINE l_ofg02  LIKE ofg_file.ofg02
    DEFINE l_ofg04  LIKE ofg_file.ofg04
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ofg.ofg01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ofg.* FROM ofg_file
     WHERE ofg01=g_ofg.ofg01 AND ofg02 = g_ofg.ofg02 AND ofg03 = g_ofg.ofg03
    IF g_ofg.ofgacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ofg.ofg01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofg01_t = g_ofg.ofg01
    LET g_ofg02_t = g_ofg.ofg02
    LET g_ofg03_t = g_ofg.ofg03
    LET g_ofg_o.* =g_ofg.*
    BEGIN WORK
 
    OPEN i705_cl USING g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03   #FUN-9B0159
    IF STATUS THEN
       CALL cl_err("OPEN i705_cl:", STATUS, 1)
       CLOSE i705_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i705_cl INTO g_ofg.*              # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofg.ofg01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_ofg.ofgmodu = g_user                      #修改者
    LET g_ofg.ofgdate = g_today                   #修改日期
    CALL i705_show()                           # 顯示最新資料
    WHILE TRUE
        LET g_ofg_t.*=g_ofg.*
        CALL i705_i("u")                       # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofg.*=g_ofg_o.*
            CALL i705_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ofg_file SET ofg_file.* = g_ofg.*    # 更新DB
         WHERE ofg01 = g_ofg01_t             # COLAUTH?
           AND ofg02 = g_ofg02_t AND ofg03 = g_ofg03_t 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ofg_file",g_ofg.ofg01,g_ofg.ofg02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF

        #更新潛在客戶主檔的最后追蹤日期,成交機率
        SELECT MAX(ofg02),ofg04 INTO l_ofg02,l_ofg04 FROM ofg_file
         WHERE ofg01 = g_ofg.ofg01 AND ofg03 = g_ofg.ofg03
         GROUP BY ofg04
        IF STATUS THEN LET l_ofg02 ='' LET l_ofg04 = '' END IF
 
        UPDATE ofd_file SET ofd26 = l_ofg02,
                            ofd29 = l_ofg04
         WHERE ofd01 = g_ofg.ofg03
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","ofd_file",g_ofg.ofg03,"",STATUS,"","upd ofd29",1)  #No.FUN-660167
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i705_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i705_x()

    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofg.ofg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i705_cl USING g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
    IF STATUS THEN
       CALL cl_err("OPEN i705_cl:", STATUS, 1)
       CLOSE i705_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i705_cl INTO g_ofg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofg.ofg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i705_show()
    IF cl_exp(15,12,g_ofg.ofgacti) THEN
        LET g_chr=g_ofg.ofgacti
        IF g_ofg.ofgacti='Y' THEN
            LET g_ofg.ofgacti='N'
        ELSE
            LET g_ofg.ofgacti='Y'
        END IF

        UPDATE ofg_file
            SET ofgacti = g_ofg.ofgacti,
                ofgmodu = g_user,
                ofgdate = g_today
            WHERE ofg01 = g_ofg.ofg01 AND ofg02 = g_ofg.ofg02 AND ofg03 = g_ofg.ofg03
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ofg_file",g_ofg.ofg01,g_ofg.ofg02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_ofg.ofgacti=g_chr
        END IF
        DISPLAY BY NAME g_ofg.ofgacti
    END IF
    CLOSE i705_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i705_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofg.ofg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#TQC-980066 --BEGIN--
   IF g_ofg.ofgacti = 'N' THEN
      CALL cl_err('','abm-033',0)
       RETURN
    END IF 
#TQC-980066 --END--
    BEGIN WORK
 
    OPEN i705_cl USING g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
    IF STATUS THEN
       CALL cl_err("OPEN i705_cl:", STATUS, 1)
       CLOSE i705_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i705_cl INTO g_ofg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofg.ofg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i705_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ofg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ofg02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "ofg03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ofg.ofg01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ofg.ofg02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_ofg.ofg03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ofg_file WHERE ofg01 = g_ofg.ofg01
                              AND ofg02 = g_ofg.ofg02
                              AND ofg03 = g_ofg.ofg03
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_ofg.ofg01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("del","ofg_file",g_ofg.ofg01,g_ofg.ofg02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
          ROLLBACK WORK RETURN
       ELSE
          CLEAR FORM
          INITIALIZE g_ofg.* TO NULL
          OPEN i705_count
          #FUN-B50064-add-start--
          IF STATUS THEN
             CLOSE i705_cs
             CLOSE i705_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          FETCH i705_count INTO g_row_count
          #FUN-B50064-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i705_cs
             CLOSE i705_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i705_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i705_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE
             CALL i705_fetch('/')
          END IF
       END IF
    END IF
    CLOSE i705_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i705_copy()
   DEFINE l_ofg               RECORD LIKE ofg_file.*,
          l_oldkey1,l_newkey1 LIKE ofg_file.ofg01,
          l_oldkey2,l_newkey2 LIKE ofg_file.ofg02,
          l_oldkey3,l_newkey3 LIKE ofg_file.ofg03
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofg.ofg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET l_newkey1 = g_ofg.ofg01
    LET l_newkey2 = g_today
    LET l_newkey3 = g_ofg.ofg03
 
     LET g_before_input_done = FALSE  #No.MOD-480103
     CALL i705_set_entry("a")         #No.MOD-480103
     LET g_before_input_done = TRUE   #No.MOD-480103
 
    INPUT l_newkey1,l_newkey2,l_newkey3 WITHOUT DEFAULTS
     FROM ofg01,ofg02,ofg03
 
        AFTER FIELD ofg01
         IF l_newkey1 IS NOT NULL THEN
            LET g_ofg01_c = l_newkey1   #No.MOD-480103
           CALL i705_ofg01('c')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(l_newkey1,g_errno,0)
              NEXT FIELD ofg01
           END IF
         END IF
 
        AFTER FIELD ofg03
         IF l_newkey3 IS NOT NULL THEN
            LET g_ofg03_c = l_newkey3   #No.MOD-480103
           CALL i705_ofg03('c')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(l_newkey3,g_errno,0)
              NEXT FIELD ofg03
           END IF
           SELECT COUNT(*) INTO g_cnt FROM ofg_file
            WHERE ofg01 = l_newkey1 AND ofg02 = l_newkey2
              AND ofg03 = l_newkey3
            IF g_cnt > 0 THEN
               CALL cl_err(l_newkey3,-239,0)
               NEXT FIELD ofg03
            END IF
          END IF
 
        ON ACTION controlp
           IF INFIELD(ofg01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = l_newkey1      #No.MOD-480103
               CALL cl_create_qry() RETURNING l_newkey1 #No.MOD-480103
               DISPLAY l_newkey1 TO ofg01               #No.MOD-480103
           END IF
           IF INFIELD(ofg03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ofd"
               LET g_qryparam.default1 =l_newkey3       #No.MOD-480103
               CALL cl_create_qry() RETURNING l_newkey3 #No.MOD-480103
               DISPLAY l_newkey3 TO ofg03               #No.MOD-480103
           END IF
 
         #--NO.MOD-860078--
         ON IDLE g_idle_seconds                                                   
            CALL cl_on_idle()                                                     
            CONTINUE INPUT
 
         ON ACTION controlg 
            CALL cl_cmdask()
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
         #--NO.MOD-860078---
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ofg.ofg01,g_ofg.ofg02,g_ofg.ofg03
         CALL i705_ofg01('d')    #No.MOD-480103
         CALL i705_ofg03('d')    #No.MOD-480103
        RETURN
    END IF
    LET l_ofg.* = g_ofg.*
    LET l_ofg.ofg01  =l_newkey1
    LET l_ofg.ofg02  =l_newkey2
    LET l_ofg.ofg03  =l_newkey3
#TQC-980066 --BEGIN--
    LET l_ofg.ofgacti = 'Y'
    LET l_ofg.ofgmodu = NULL
    LET l_ofg.ofgdate = g_today
    LET l_ofg.ofggrup = g_grup
    LET l_ofg.ofguser = g_user
#TQC-980066 --END--
 
    #FUN-980010 add plant & legal 
    LET l_ofg.ofgplant = g_plant 
    LET l_ofg.ofglegal = g_legal 
    #FUN-980010 end plant & legal 
 
    LET l_ofg.ofgoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ofg.ofgorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO ofg_file VALUES (l_ofg.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ofg_file",l_ofg.ofg01,l_ofg.ofg02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
    ELSE
        MESSAGE 'ROW(',l_newkey1,') O.K'
        LET l_oldkey1 = g_ofg.ofg01
        LET l_oldkey2 = g_ofg.ofg02
        LET l_oldkey3 = g_ofg.ofg03
        SELECT ofg_file.* INTO g_ofg.* FROM ofg_file      #liuxqa 091021
         WHERE ofg01 = l_newkey1 AND ofg02 = l_newkey2
           AND ofg03 = l_newkey3
        CALL i705_u()
        #SELECT ofg_file.* INTO g_ofg.* FROM ofg_file      #liuxqa 091021 #FUN-C80046
        # WHERE ofg01 = l_oldkey1 AND ofg02 = l_oldkey2                   #FUN-C80046
        #   AND ofg03 = l_oldkey3                                         #FUN-C80046
    END IF
    CALL i705_show()
END FUNCTION
 
FUNCTION i705_out()
    DEFINE
        l_ofg           RECORD LIKE ofg_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE ima_file.ima01           #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmi705'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-830152---Begin
     LET g_sql = "SELECT ofg_file.*,gen02,ofd02 FROM ofg_file LEFT OUTER JOIN gen_file ON ofg_file.ofg01 = gen_file.gen01 LEFT OUTER JOIN ofd_file ON ofg_file.ofg03 = ofd_file.ofd01 ",
                 " WHERE ",g_wc CLIPPED
#    LET g_sql="SELECT * FROM ofg_file ",
#              " WHERE ",g_wc CLIPPED
 
#    PREPARE i705_p1 FROM g_sql                # RUNTIME
#    DECLARE i705_co                           # CURSOR
#        CURSOR FOR i705_p1
 
#    CALL cl_outnam('axmi705') RETURNING l_name
#    START REPORT i705_rep TO l_name
#    FOREACH i705_co INTO l_ofg.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i705_rep(l_ofg.*)
#    END FOREACH
     CALL cl_prt_cs1('axmi705','axmi705',g_sql,'')
#    FINISH REPORT i705_rep
 
#    CLOSE i705_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-830152---End
END FUNCTION
#No.FUN-830152---Begin
#REPORT i705_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(01)
#       sr              RECORD LIKE ofg_file.*,
#       l_gen02         LIKE gen_file.gen02,
#       l_ofd02         LIKE ofd_file.ofd02,
#       i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ofg01,sr.ofg02,sr.ofg03
 
#   FORMAT
#       PAGE HEADER
#          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.ofg01
#          SELECT ofd02 INTO l_ofd02 FROM ofd_file WHERE ofd01=sr.ofg03
#          PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#          PRINT ' '
#          PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#          PRINT ' '
#          PRINT g_x[11] CLIPPED,sr.ofg01 CLIPPED,' ',l_gen02
#          PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#          PRINT g_dash[1,g_len]
#          LET l_trailer_sw = 'y'
#          LET i = 0
 
#       BEFORE GROUP OF sr.ofg01
#          SKIP TO TOP OF PAGE
#
#       ON EVERY ROW
#          IF i > 0 AND i < 4 THEN
#             PRINT '---------------------------------------------------------',
#                   '-----------------------'
#          END IF
#          LET i = i+1
 
#          PRINT g_x[12] CLIPPED,COLUMN 11,sr.ofg02,
#                COLUMN 21,g_x[13] CLIPPED,
#                COLUMN 34,sr.ofg03 CLIPPED,' ',l_ofd02
#          PRINT g_x[14] CLIPPED,
#                COLUMN 11,sr.ofg04 USING '<<<'
#          PRINT g_x[15] CLIPPED,
#                COLUMN 11,sr.ofg05
#          PRINT COLUMN 11,sr.ofg051
#          PRINT COLUMN 11,sr.ofg052
#          PRINT COLUMN 11,sr.ofg053
#          PRINT COLUMN 11,sr.ofg054
 
#          PRINT g_x[16] CLIPPED,
#                COLUMN 11,sr.ofg06
#          PRINT COLUMN 11,sr.ofg061
#          PRINT COLUMN 11,sr.ofg062
#          PRINT COLUMN 11,sr.ofg063
#          PRINT COLUMN 11,sr.ofg064
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],COLUMN 41,g_x[5] CLIPPED,
#                 COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],COLUMN 41,g_x[5] CLIPPED,
#                     COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-830152---End
FUNCTION i705_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ofg01,ofg02,ofg03",TRUE)  #No.MOD-480103
   END IF
END FUNCTION
 
FUNCTION i705_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ofg01,ofg02,ofg03",FALSE) #No.MOD-480103
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

