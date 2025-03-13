# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aeci650.4gl
# Descriptions...: 班次資料維護作業
# Date & Author..: 91/11/06 By MAY
# Modify.........: 92/04/22 By PIN
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/19 By lala   報表轉為使用p_query
# Modify.........: No.TQC-920063 09/02/20 By shiwuying 修改 無效的資料也可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60028 10/06/07 By lilingyu 平行工藝
# Modify.........: No:FUN-9A0056 11/03/31 By abby MES功能追版
# Modify.........: No:TQC-B40120 11/04/15 By lixia 查詢時oriu orig無法下條件
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B80251 12/06/15 By Elise 將aec-052/aec-051控卡拿掉 
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ecg   RECORD LIKE ecg_file.*,
    g_ecg_t RECORD LIKE ecg_file.*,
    g_ecg_o RECORD LIKE ecg_file.*,
    g_ecg01_t LIKE ecg_file.ecg01,
    g_wc,g_sql          STRING,                       #TQC-630166    
    g_cmd               LIKE type_file.chr1000        #No.FUN-680073
DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
    INITIALIZE g_ecg.* TO NULL
    INITIALIZE g_ecg_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ecg_file  WHERE ecg01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aeci650_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW aeci650_w WITH FORM "aec/42f/aeci650"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL aeci650_menu()
 
    CLOSE WINDOW aeci650_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION aeci650_cs()
    CLEAR FORM
   INITIALIZE g_ecg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件#TQC-B40120 add oriu orig
        ecg01,ecg02,ecg05,ecg06,ecguser,ecggrup,ecgoriu,ecgorig,ecgmodu,ecgdate,ecgacti  #FUN-A60028 add ecg05,ecg06
 
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ecguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecguser', 'ecggrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ecg01 FROM ecg_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY ecg01"
    PREPARE aeci650_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE aeci650_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aeci650_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ecg_file WHERE ",g_wc CLIPPED
    PREPARE aeci650_precount FROM g_sql
    DECLARE aeci650_count CURSOR FOR aeci650_precount
END FUNCTION
 
FUNCTION aeci650_menu()
DEFINE l_cmd  LIKE type_file.chr1000         #No.FUN-820002
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL aeci650_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aeci650_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL aeci650_fetch('N')
        ON ACTION previous
            CALL aeci650_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aeci650_u()
            END IF
            NEXT OPTION "next"
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL aeci650_x()
            END IF
            NEXT OPTION "next"
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL aeci650_r()
            END IF
            NEXT OPTION "next"
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL aeci650_copy()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL aeci650_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL aeci650_fetch('/')
        ON ACTION first
            CALL aeci650_fetch('F')
        ON ACTION last
            CALL aeci650_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0039-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ecg.ecg01 IS NOT NULL THEN
                  LET g_doc.column1 = "ecg01"
                  LET g_doc.value1 = g_ecg.ecg01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0039-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE aeci650_cs
END FUNCTION
 
 
FUNCTION aeci650_a()
DEFINE l_ecg05   LIKE ecg_file.ecg05     #FUN-A60028 
DEFINE l_ecg06   LIKE ecg_file.ecg06     #FUN-A60028

    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_ecg.* LIKE ecg_file.*
    LET g_ecg01_t = NULL
    LET g_ecg_t.*=g_ecg.*
    LET g_ecg_o.*=g_ecg.*
    CALL cl_opmsg('a')
    
    LET l_ecg05 = TIME   #FUN-A60028 
    LET l_ecg06 = TIME   #FUN-A60028 
    
    WHILE TRUE
        LET g_ecg.ecgacti ='Y'                   #有效的資料
        LET g_ecg.ecguser = g_user
        LET g_ecg.ecgoriu = g_user #FUN-980030
        LET g_ecg.ecgorig = g_grup #FUN-980030
        LET g_ecg.ecggrup = g_grup               #使用者所屬群
        LET g_ecg.ecgdate = g_today
        
        LET g_ecg.ecg05 = l_ecg05[1,5]   #FUN-A60028 
        LET g_ecg.ecg06 = l_ecg06[1,5]   #FUN-A60028 
        
        CALL aeci650_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ecg.ecg01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF

        LET g_success = 'Y'                        #FUN-9A0056 add

        BEGIN WORK                                 #FUN-9A0056 add
        
        INSERT INTO ecg_file VALUES(g_ecg.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("ins","ecg_file",g_ecg.ecg01,"",SQLCA.sqlcode,"","",1) #FUN-660091
            LET g_success = 'N'                    #FUN-9A0056 add
           #CONTINUE WHILE                         #FUN-9A0056 mark
        ELSE
            LET g_ecg_t.* = g_ecg.*                # 保存上筆資料
            LET g_ecg_o.* = g_ecg.*                # 保存上筆資料
            SELECT ecg01 INTO g_ecg.ecg01 FROM ecg_file
                WHERE ecg01 = g_ecg.ecg01
           #FUN-9A0056 -- add begin ----
            IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
               CALL i650_mes('insert',g_ecg.ecg01)
            END IF
           #FUN-9A0056 -- add end ------
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
 
FUNCTION aeci650_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,      #No.FUN-680073 VARCHAR(1)
        l_n,p_n         LIKE type_file.num5       # No.FUN-680073 SMALLINT 
    DEFINE g_h1         LIKE type_file.num5       #FUN-A60028 
    DEFINE g_h2         LIKE type_file.num5       #FUN-A60028 
    DEFINE g_m1         LIKE type_file.num5       #FUN-A60028 
    DEFINE g_m2         LIKE type_file.num5       #FUN-A60028             
    DEFINE l_chr        LIKE type_file.chr1       #FUN-A60028 
    IF s_shut(0) THEN RETURN END IF
    DISPLAY BY NAME g_ecg.ecguser,g_ecg.ecggrup,
        g_ecg.ecgdate, g_ecg.ecgacti,g_ecg.ecg05,g_ecg.ecg06                #FUN-A60028 ecg05,ecg06
        
    INPUT BY NAME g_ecg.ecgoriu,g_ecg.ecgorig,
        g_ecg.ecg01,g_ecg.ecg02,g_ecg.ecg05,g_ecg.ecg06                #FUN-A60028 ecg05,ecg06
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i650_set_entry(p_cmd)
           CALL i650_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD ecg01
          IF g_ecg.ecg01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (g_ecg01_t IS NULL) OR
              (p_cmd = "u" AND g_ecg.ecg01 != g_ecg01_t) THEN
                SELECT count(*) INTO l_n FROM ecg_file
                    WHERE ecg01 = g_ecg.ecg01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_ecg.ecg01,-239,0)
                    LET g_ecg.ecg01 = g_ecg01_t
                    DISPLAY BY NAME g_ecg.ecg01
                    NEXT FIELD ecg01
                END IF
            END IF
          END IF
 
#FUN-A60028 --begin--
          AFTER FIELD ecg05
            IF NOT cl_null(g_ecg.ecg05) THEN
               LET g_h1=g_ecg.ecg05[1,2]
               LET g_m1=g_ecg.ecg05[4,5]
               LET g_h2=g_ecg.ecg06[1,2]
               LET g_m2=g_ecg.ecg06[4,5]
               LET l_chr = g_ecg.ecg05[3,3]
               IF l_chr != ':' THEN 
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD CURRENT 
               END IF 
               IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
                  CALL cl_err('','asf-807',0)
                  NEXT FIELD CURRENT
              #MOD-B80251---mark---start---
              #ELSE
              #	  IF g_h1 > g_h2 THEN 
              #	     CALL cl_err('','aec-051',0)
              #	     NEXT FIELD CURRENT 
              #	  END IF     
              #	  IF g_h1 = g_h2 AND g_m1 > g_m2 THEN 
              #	     CALL cl_err('','aec-051',0)
              #	     NEXT FIELD CURRENT 
              #	  END IF 
              #MOD-B80251---mark---end---
               END IF			
            END IF

        AFTER FIELD ecg06
            IF NOT cl_null(g_ecg.ecg06) THEN
               LET g_h1=g_ecg.ecg05[1,2]
               LET g_m1=g_ecg.ecg05[4,5]            
               LET g_h2=g_ecg.ecg06[1,2]
               LET g_m2=g_ecg.ecg06[4,5]
               LET l_chr = g_ecg.ecg06[3,3]
               IF l_chr != ':' THEN 
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD CURRENT 
               END IF                
               IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
                  CALL cl_err('','asf-807',0)
                  NEXT FIELD CURRENT 
              #MOD-B80251---mark---start---
              #ELSE
              #	  IF g_h2 < g_h1 THEN 
              #	     CALL cl_err('','aec-052',0)
              #	     NEXT FIELD CURRENT 
              #	  END IF     
              #	  IF g_h2 = g_h1 AND g_m2 < g_m1 THEN 
              #	     CALL cl_err('','aec-052',0)
              #	     NEXT FIELD CURRENT 
              #	  END IF                
              #MOD-B80251---mark---end---	     
               END IF
            END IF            
#FUN-A60028 --end-- 

       #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(ecg01) THEN
       #         LET g_ecg.* = g_ecg_t.*
       #         DISPLAY BY NAME g_ecg.*
       #         NEXT FIELD ecg01
       #     END IF
       #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                         # 欄位說明
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
 
FUNCTION aeci650_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ecg.* TO NULL                 #No.FUN-6A0039
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aeci650_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aeci650_count
    FETCH aeci650_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aeci650_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0)
        INITIALIZE g_ecg.* TO NULL
    ELSE
        CALL aeci650_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aeci650_fetch(p_flecg)
    DEFINE
        p_flecg         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flecg
        WHEN 'N' FETCH NEXT     aeci650_cs INTO g_ecg.ecg01
        WHEN 'P' FETCH PREVIOUS aeci650_cs INTO g_ecg.ecg01
        WHEN 'F' FETCH FIRST    aeci650_cs INTO g_ecg.ecg01
        WHEN 'L' FETCH LAST     aeci650_cs INTO g_ecg.ecg01
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
            FETCH ABSOLUTE g_jump aeci650_cs INTO g_ecg.ecg01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0)
        INITIALIZE g_ecg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flecg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ecg.* FROM ecg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ecg01 = g_ecg.ecg01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0) #No.FUN-660091
        CALL cl_err3("sel","ecg_file",g_ecg.ecg01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       INITIALIZE g_ecg.* TO NULL
    ELSE
        LET g_data_owner = g_ecg.ecguser         #FUN-4C0034
        LET g_data_group = g_ecg.ecggrup         #FUN-4C0034
        CALL aeci650_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aeci650_show()
    LET g_ecg_t.* = g_ecg.*
    LET g_ecg_o.* = g_ecg.*
    DISPLAY BY NAME g_ecg.ecg01,g_ecg.ecg02, g_ecg.ecgoriu,g_ecg.ecgorig,
                    g_ecg.ecguser,g_ecg.ecggrup,g_ecg.ecgmodu,g_ecg.ecgdate,
                    g_ecg.ecgacti,
                    g_ecg.ecg05,g_ecg.ecg06              #FUN-A60028 add  
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aeci650_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ecg.ecg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ecg.ecgacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ecg.ecg01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ecg01_t = g_ecg.ecg01
   #BEGIN WORK                    #FUN-9A0056 mark

   #FUN-9A0056 add begin -------- 
    IF g_action_choice <> "reproduce" THEN
       LET g_success = 'Y'
       BEGIN WORK
    END IF
   #FUN-9A0056 add end ----------
 
    OPEN aeci650_cl USING g_ecg.ecg01
    IF STATUS THEN
       CALL cl_err("OPEN aeci650_cl:", STATUS, 1)
       CLOSE aeci650_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aeci650_cl INTO g_ecg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ecg.ecgmodu=g_user                     #修改者
    LET g_ecg.ecgdate = g_today                  #修改日期
    CALL aeci650_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aeci650_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ecg.*=g_ecg_t.*
            CALL aeci650_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ecg_file SET ecg_file.* = g_ecg.*    # 更新DB
            WHERE ecg01 = g_ecg.ecg01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0) #No.FUN-660091
             CALL cl_err3("upd","ecg_file",g_ecg01_t,"",SQLCA.sqlcode,"","",1) #FUN-660091
             LET g_success = 'N'                                                #FUN-9A0056 add
           #CONTINUE WHILE                                                     #FUN-9A0056 mark
        END IF
       #FUN-9A0056 add begin --------
        IF g_action_choice <> "reproduce" THEN
           IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
             CALL i650_mes('update',g_ecg.ecg01)
           END IF
        END IF

        IF g_success = 'N' THEN
          ROLLBACK WORK
          BEGIN WORK
          CONTINUE WHILE
        ELSE
          COMMIT WORK
        END IF
       #FUN-9A0056 add end ----------
        EXIT WHILE
    END WHILE
    CLOSE aeci650_cl
   #COMMIT WORK               #FUN-9A0056 mark
END FUNCTION
 
FUNCTION aeci650_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecg.ecg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_success = 'Y'                    #FUN-9A0056 add
    BEGIN WORK
 
    OPEN aeci650_cl USING g_ecg.ecg01
    IF STATUS THEN
       CALL cl_err("OPEN aeci650_cl:", STATUS, 1)
       CLOSE aeci650_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aeci650_cl INTO g_ecg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL aeci650_show()
    IF cl_exp(15,21,g_ecg.ecgacti) THEN
        LET g_chr=g_ecg.ecgacti
        IF g_ecg.ecgacti='Y' THEN
            LET g_ecg.ecgacti='N'
        ELSE
            LET g_ecg.ecgacti='Y'
        END IF
        UPDATE ecg_file
            SET ecgacti=g_ecg.ecgacti,
               ecgmodu=g_user, ecgdate=g_today
            WHERE ecg01 = g_ecg.ecg01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0) #No.FUN-660091
             CALL cl_err3("upd","ecg_file",g_ecg.ecg01,"",SQLCA.sqlcode,"","",1) #FUN-660091
            LET g_ecg.ecgacti=g_chr
            LET g_success = 'N'                                                 #FUN-9A0056 add
        END IF
       #FUN-9A0056 add begin ---------------
       #當資料為有效變無效,傳送刪除給MES;反之,則傳送新增給MES
        IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
          IF g_ecg.ecgacti='N' THEN
             CALL i650_mes('delete',g_ecg.ecg01)
          ELSE
             CALL i650_mes('insert',g_ecg.ecg01)
          END IF
        END IF
       #FUN-9A0056 add end -----------------
        DISPLAY BY NAME g_ecg.ecgacti
    END IF
     CLOSE aeci650_cl
   #COMMIT WORK             #FUN-9A0056 mark

   #FUN-9A0056 add begin ----
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
   #FUN-9A0056 add end ------
END FUNCTION
 
FUNCTION aeci650_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecg.ecg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ecg.ecgacti = 'N' THEN CALL cl_err('','9027',0) RETURN END IF #No.TQC-920063 ADD
    LET g_success = 'Y'  #FUN-9A0056 add
    BEGIN WORK
 
    OPEN aeci650_cl USING g_ecg.ecg01

    IF STATUS THEN
       CALL cl_err("OPEN aeci650_cl:", STATUS, 1)
       CLOSE aeci650_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aeci650_cl INTO g_ecg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL aeci650_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ecg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ecg.ecg01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ecg_file WHERE ecg01 = g_ecg.ecg01
       
      #FUN-9A0056 -- add begin ------------
       IF SQLCA.SQLCODE THEN
          CALL cl_err3("del","ecg_file",g_ecg.ecg01,"",SQLCA.SQLCODE,"","",1)
          LET g_success = 'N'
       END IF

      #與MES整合
       IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
          CALL i650_mes('delete',g_ecg_t.ecg01)
       END IF
      #FUN-9A0056 add end -----------------
      
       CLEAR FORM
       OPEN aeci650_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE aeci650_cs
          CLOSE aeci650_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH aeci650_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE aeci650_cs
          CLOSE aeci650_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN aeci650_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL aeci650_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL aeci650_fetch('/')
       END IF
    END IF
    CLOSE aeci650_cl
   #COMMIT WORK   #FUN-9A0056 mark

   #FUN-9A0056 -- add begin ----
    IF g_success = 'N' THEN
      ROLLBACK WORK
    ELSE
      COMMIT WORK
    END IF
   #FUN-9A0056 -- add end ------
END FUNCTION
 
FUNCTION aeci650_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
        l_oldno         LIKE ecg_file.ecg01,
        l_newno         LIKE ecg_file.ecg01
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ecg.ecg01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i650_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM ecg01
        AFTER FIELD ecg01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM ecg_file
                WHERE ecg01 = l_newno
               IF g_cnt > 0 THEN
                   CALL cl_err(l_newno,-239,0)
                   NEXT FIELD ecg01
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
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ecg.ecg01
        RETURN
    END IF
 
    SELECT * FROM ecg_file
     WHERE ecg01=g_ecg.ecg01
      INTO TEMP x
    UPDATE x
        SET ecg01=l_newno,    #資料鍵值
            ecguser=g_user,   #資料所有者
            ecggrup=g_grup,   #資料所有者所屬群
            ecgmodu=NULL,     #資料修改日期
            ecgdate=g_today,  #資料建立日期
            ecgacti='Y'       #有效資料
            
    LET g_success = 'Y'      #FUN-9A0056 add
    BEGIN WORK               #FUN-9A0056 add
 
    INSERT INTO ecg_file
      SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ecg.ecg01,SQLCA.sqlcode,1) #No.FUN-660091
        CALL cl_err3("ins","ecg_file",g_ecg.ecg01,"",SQLCA.sqlcode,"","",1) #FUN-660091
      #DROP TABLE x              #FUN-9A0056 mark
       LET g_success = 'N'       #FUN-9A0056 add
    ELSE
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_ecg.ecg01
       SELECT ecg_file.* INTO g_ecg.*
              FROM ecg_file WHERE ecg01 = l_newno
       CALL aeci650_u()
       #FUN-C30027---begin
       #SELECT ecg_file.* INTO g_ecg.* FROM ecg_file
       #     WHERE ecg01 = l_oldno
       #CALL aeci650_show()
       #FUN-C30027---end
      #FUN-9A0056 add begin ------------
      #與MES整合
       IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
          CALL i650_mes('insert',g_ecg.ecg01)
       END IF
      #FUN-9A0056 add end --------------
    END IF
    DROP TABLE x

   #FUN-9A0056 add begin ----
    IF g_success = 'N' THEN
      ROLLBACK WORK
    ELSE
      COMMIT WORK
    END IF
   #FUN-9A0056 add end ------
    DISPLAY BY NAME g_ecg.ecg01
 
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION aeci650_out()
DEFINE l_cmd           LIKE type_file.chr1000
#   DEFINE
#       l_i             LIKE type_file.num5,     #No.FUN-680073 SMALLINT
#       l_name          LIKE type_file.chr20,    # No.FUN-680073 VARCHAR(20),# External(Disk) file name
#       l_ecg   RECORD LIKE ecg_file.*,
#       l_za05          LIKE type_file.chr1000,  # No.FUN-680073  VARCHAR(40),
#       l_chr           LIKE type_file.chr1      #No.FUN-680073 VARCHAR(1)
    IF cl_null(g_wc) AND NOT cl_null(g_ecg.ecg01) THEN                                                                              
       LET g_wc = " ecg01 = '",g_ecg.ecg01,"' "                                                                                     
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
                                                                                                                                    
    #報表轉為使用 p_query                                                                                                           
    LET l_cmd = 'p_query "aeci650" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN
#   IF cl_null(g_wc) THEN
#      LET g_wc=" ecg01='",g_ecg.ecg01,"'"
#   END IF
 
#   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   CALL cl_outnam('aeci650') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM ecg_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE aeci650_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE aeci650_co                         # SCROLL CURSOR
#       CURSOR FOR aeci650_p1
 
#   START REPORT aeci650_rep TO l_name
 
#   FOREACH aeci650_co INTO l_ecg.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT aeci650_rep(l_ecg.*)
#   END FOREACH
 
#   FINISH REPORT aeci650_rep
 
#   CLOSE aeci650_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT aeci650_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1) 
#       sr RECORD LIKE ecg_file.*,
#       l_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#   ORDER BY sr.ecg01
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           IF sr.ecgacti = 'N' THEN PRINT g_c[31],'*'; END IF
#           PRINT COLUMN g_c[32],sr.ecg01,
#                 COLUMN g_c[33],sr.ecg02
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#                  #IF g_wc[001,080] > ' ' THEN
#       	   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                  #IF g_wc[071,140] > ' ' THEN
#       	   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                  #IF g_wc[141,210] > ' ' THEN
#       	   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#           END IF
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end--
 
FUNCTION i650_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ecg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i650_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ecg01",FALSE)
   END IF
END FUNCTION
 
#FUN-9A0056 add i650_mes() for MES ---
FUNCTION i650_mes(p_key1,p_key2)
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

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli('aeci650',p_key1,p_key2)
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
         LET g_success = 'N'
 END CASE

END FUNCTION
#FUN-9A0056 add end ----------------
