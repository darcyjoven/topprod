# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxi910.4gl
# Descriptions...: 年度保稅原料結算資料維護作業
# Date & Author..: 96/11/04 By Star
# Modift.........: 01/08/29 By Joey
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.MOD-680044 06/08/15 By Claire 放大欄位bwh13 dec(15,3)
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換
# Modify.........: No.FUN-6A0046 06/10/19 By jamie 1.FUNCTION i910()_q 一開始應清空g_bwh.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-990089 09/10/12 By lilingyu 該作業多個欄位未控管負數
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bwh   RECORD LIKE bwh_file.*,
    g_bwh_t RECORD LIKE bwh_file.*,
    g_bwh01_t LIKE bwh_file.bwh01,
    g_bwh02_t LIKE bwh_file.bwh02,
    g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_ima02   LIKE ima_file.ima02,
    g_ima15   LIKE ima_file.ima15,
    g_ima106  LIKE ima_file.ima106
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680062   INTEGER
DEFINE g_msg           LIKE type_file.chr1000   #No.FUN-680062   VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10     #No.FUN-680062   INTEGER
DEFINE g_curs_index    LIKE type_file.num10     #No.FUN-680062   INTEGER
DEFINE g_jump          LIKE type_file.num10     #No.FUN-680062   INTEGER
DEFINE mi_no_ask       LIKE type_file.num5      #No.FUN-680062   SMALLINT
 
MAIN
    DEFINE
        p_row,p_col    LIKE type_file.num5      #No.FUN-680062  SMALLINT
#       l_time         LIKE type_file.chr8      #No.FUN-6A0062
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
    INITIALIZE g_bwh.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bwh_file WHERE bwh01 = ? AND bwh02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i910_cl CURSOR FROM g_forupd_sql        # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW i910_w AT p_row,p_col WITH FORM "abx/42f/abxi910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i910_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i910_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION i910_curs()
    CLEAR FORM
   INITIALIZE g_bwh.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        bwh01,bwh02, ima15,ima106,bwh03,bwh04, bwh05,bwh06, bwh07,bwh09,
        bwh08,bwh10, bwh11,bwh12,bwh13,bwh14,bwh15,bwh16
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
               WHEN INFIELD(bwh02)
#               CALL q_ima(10,4,g_bwh.bwh02) RETURNING g_bwh.bwh02
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_ima"
              #  LET g_qryparam.state = "c"
              #  LET g_qryparam.default1 = g_bwh.bwh02
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","",g_bwh.bwh02,"","","","","",'')  RETURNING g_qryparam.multiret  
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO bwh02
                NEXT FIELD bwh02
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
 
    # 組合出 SQL 指令
    LET g_sql="SELECT bwh_file.bwh01,bwh02 FROM bwh_file,ima_file ",
              " WHERE bwh02=ima01 AND ",g_wc CLIPPED, " ORDER BY bwh01,bwh02"
    PREPARE i910_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i910_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i910_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM bwh_file,ima_file WHERE bwh02=ima01 AND ",g_wc CLIPPED
    PREPARE i910_cntpre FROM g_sql
    DECLARE i910_count CURSOR FOR i910_cntpre
END FUNCTION
 
FUNCTION i910_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i910_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i910_q()
            END IF
        ON ACTION next
            CALL i910_fetch('N')
        ON ACTION previous
            CALL i910_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i910_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i910_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
            CALL i910_fetch('/')
        ON ACTION first
            CALL i910_fetch('F')
        ON ACTION last
            CALL i910_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0046-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_bwh.bwh01 IS NOT NULL THEN            
                  LET g_doc.column1 = "bwh01"               
                  LET g_doc.column2 = "bwh02"               
                  LET g_doc.value1 = g_bwh.bwh01            
                  LET g_doc.value2 = g_bwh.bwh02           
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0046-------add--------end----
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i910_cs
END FUNCTION
 
 
FUNCTION i910_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bwh.* LIKE bwh_file.*
    LET g_bwh01_t = NULL
    LET g_bwh02_t = NULL
    LET g_bwh.bwh03 = 0
    LET g_bwh.bwh04 = 0
    LET g_bwh.bwh05 = 0
    LET g_bwh.bwh06 = 0
    LET g_bwh.bwh07 = 0
    LET g_bwh.bwh08 = 0
    LET g_bwh.bwh09 = 0
    LET g_bwh.bwh10 = 0
    LET g_bwh.bwh11 = 0
    LET g_bwh.bwh12 = 0
    LET g_bwh.bwh13 = 0
    LET g_bwh.bwh14 = 0
    LET g_bwh.bwh15 = 0
    LET g_bwh.bwh16 = 0
 
    LET g_bwh.bwhplant = g_plant  #FUN-980001 add
    LET g_bwh.bwhlegal = g_legal  #FUN-980001 add
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i910_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_bwh.bwh02 IS NULL THEN LET g_bwh.bwh02=' ' END IF
        IF g_bwh.bwh01 IS NULL OR g_bwh.bwh02 IS NULL THEN  # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO bwh_file VALUES(g_bwh.*)        # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_bwh.bwh01,SQLCA.sqlcode,0) #No.FUN-660052
           CALL cl_err3("ins","bwh_file",g_bwh.bwh01,g_bwh.bwh02,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        ELSE
            LET g_bwh_t.* = g_bwh.*                # 保存上筆資料
            SELECT bwh01,bwh02 INTO g_bwh.bwh01,g_bwh.bwh02 FROM bwh_file
                WHERE bwh01 = g_bwh.bwh01 AND bwh02 = g_bwh.bwh02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i910_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680062  VARCHAR(1)
        l_n             LIKE type_file.num5      #No.FUN-680062  SMALLINT
 
    DISPLAY BY NAME
       g_bwh.bwh01,g_bwh.bwh02,g_bwh.bwh03,g_bwh.bwh04,g_bwh.bwh05,g_bwh.bwh06,
       g_bwh.bwh07,g_bwh.bwh08,g_bwh.bwh09,g_bwh.bwh10,g_bwh.bwh11,g_bwh.bwh12,
       g_bwh.bwh13,g_bwh.bwh14,g_bwh.bwh15,g_bwh.bwh16
 
    INPUT BY NAME
       g_bwh.bwh01,g_bwh.bwh02,g_bwh.bwh03,g_bwh.bwh04,g_bwh.bwh05,g_bwh.bwh06,
       g_bwh.bwh07,g_bwh.bwh09,g_bwh.bwh08,g_bwh.bwh10,g_bwh.bwh11,g_bwh.bwh12,
       g_bwh.bwh13,g_bwh.bwh14,g_bwh.bwh15,g_bwh.bwh16
       WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i910_set_entry(p_cmd)
           CALL i910_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD bwh01
            IF g_bwh.bwh01<0 THEN
               NEXT FIELD bwh01
            END IF
 
        AFTER FIELD bwh02
          IF NOT cl_null(g_bwh.bwh02) THEN
            #FUN-AA0059 --------------------------------add start---------------------
             IF NOT s_chk_item_no(g_bwh.bwh02,'') THEN
                CALL cl_err('',g_errno,1)
                LET g_bwh.bwh01 = g_bwh_t.bwh01
                LET g_bwh.bwh02 = g_bwh_t.bwh02
                NEXT FIELD bwh02
             END IF 
            #FUN-AA0059 ---------------------------------add end---------------------        
             SELECT count(*) INTO l_n FROM bwh_file
                 WHERE bwh01 = g_bwh.bwh01
                   AND bwh02 = g_bwh.bwh02
             IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err('',-239,0)
                 LET g_bwh.bwh01 = g_bwh_t.bwh01
                 LET g_bwh.bwh02 = g_bwh_t.bwh02
                 NEXT FIELD bwh02
             END IF
            SELECT ima02 ,ima15,ima106 INTO g_ima02,g_ima15 ,g_ima106
              FROM ima_file
             WHERE ima01 = g_bwh.bwh02
            IF STATUS THEN
#              CALL cl_err(g_bwh.bwh02,STATUS,0)    #No.FUN-660052
               CALL cl_err3("sel","ima_file",g_bwh.bwh02,"",SQLCA.sqlcode,"","",1)
               NEXT FIELD bwh02
            ELSE
               DISPLAY g_ima02 TO FORMONLY.ima02
               DISPLAY g_ima15 TO FORMONLY.ima15
               DISPLAY g_ima106 TO FORMONLY.ima106
            END IF
          END IF
 
#TQC-990089 --begin--
        AFTER FIELD bwh03
           IF NOT cl_null(g_bwh.bwh03) THEN 
              IF g_bwh.bwh03 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh03
              END IF 
           END IF 
 
        AFTER FIELD bwh04
           IF NOT cl_null(g_bwh.bwh04) THEN 
              IF g_bwh.bwh04 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh04
              END IF 
           END IF 
 
        AFTER FIELD bwh05
           IF NOT cl_null(g_bwh.bwh05) THEN 
              IF g_bwh.bwh05 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh05
              END IF 
           END IF 
 
        AFTER FIELD bwh06
           IF NOT cl_null(g_bwh.bwh06) THEN 
              IF g_bwh.bwh06 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh06
              END IF 
           END IF 
 
        AFTER FIELD bwh07
           IF NOT cl_null(g_bwh.bwh07) THEN 
              IF g_bwh.bwh07 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh07
              END IF 
           END IF 
 
        AFTER FIELD bwh08
           IF NOT cl_null(g_bwh.bwh08) THEN 
              IF g_bwh.bwh08 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh08
              END IF 
           END IF 
        
        AFTER FIELD bwh09
           IF NOT cl_null(g_bwh.bwh09) THEN 
              IF g_bwh.bwh09 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh09
              END IF 
           END IF 
 
        AFTER FIELD bwh10
           IF NOT cl_null(g_bwh.bwh10) THEN 
              IF g_bwh.bwh10 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh10
              END IF 
           END IF 
 
        AFTER FIELD bwh11
           IF NOT cl_null(g_bwh.bwh11) THEN 
              IF g_bwh.bwh11 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh11
              END IF 
           END IF 
 
        AFTER FIELD bwh12
           IF NOT cl_null(g_bwh.bwh12) THEN 
              IF g_bwh.bwh12 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh12
              END IF 
           END IF 
 
        AFTER FIELD bwh13
           IF NOT cl_null(g_bwh.bwh13) THEN 
              IF g_bwh.bwh13 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh13
              END IF 
           END IF 
        
        AFTER FIELD bwh14
           IF NOT cl_null(g_bwh.bwh14) THEN 
              IF g_bwh.bwh14 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh14
              END IF 
           END IF 
        
        AFTER FIELD bwh15
           IF NOT cl_null(g_bwh.bwh15) THEN 
              IF g_bwh.bwh15 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh15
              END IF 
           END IF  
           
        AFTER FIELD bwh16
           IF NOT cl_null(g_bwh.bwh16) THEN 
              IF g_bwh.bwh16 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bwh16
              END IF 
           END IF                                                                                                                                    
 #TQC-990089 --end--
  
        ON ACTION controlp                        # 沿用所有欄位
            CASE
               WHEN INFIELD(bwh02)
#               CALL q_ima(10,4,g_bwh.bwh02) RETURNING g_bwh.bwh02
#               CALL FGL_DIALOG_SETBUFFER( g_bwh.bwh02 )
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_ima"
              #  LET g_qryparam.default1 = g_bwh.bwh02
              #  CALL cl_create_qry() RETURNING g_bwh.bwh02
                 CALL q_sel_ima(FALSE, "q_ima", "", g_bwh.bwh02, "", "", "", "" ,"",'' )  RETURNING g_bwh.bwh02
#FUN-AA0059 --End--
#                CALL FGL_DIALOG_SETBUFFER( g_bwh.bwh02 )
                DISPLAY BY NAME g_bwh.bwh02
                NEXT FIELD bwh02
               OTHERWISE
                EXIT CASE
            END CASE
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bwh01) THEN
        #        LET g_bwh.* = g_bwh_t.*
        #        CALL i910_show()
        #        NEXT FIELD bwh01
        #    END IF
        #MOD-650015 --end
 
 
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
 
FUNCTION i910_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bwh.* TO NULL                #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i910_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i910_count
    FETCH i910_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i910_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwh.bwh01,SQLCA.sqlcode,0)
        INITIALIZE g_bwh.* TO NULL
    ELSE
        CALL i910_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i910_fetch(p_flbwh)
    DEFINE
        p_flbwh       LIKE type_file.chr1,     #No.FUN-680062 VARCHAR(1)
        l_abso        LIKE type_file.num10     #No.FUN-680062 INTEGER
 
    CASE p_flbwh
        WHEN 'N' FETCH NEXT     i910_cs INTO g_bwh.bwh01,
                                            g_bwh.bwh02
        WHEN 'P' FETCH PREVIOUS i910_cs INTO g_bwh.bwh01,
                                            g_bwh.bwh02
        WHEN 'F' FETCH FIRST    i910_cs INTO g_bwh.bwh01,
                                            g_bwh.bwh02
        WHEN 'L' FETCH LAST     i910_cs INTO g_bwh.bwh01,
                                            g_bwh.bwh02
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
            FETCH ABSOLUTE g_jump i910_cs INTO g_bwh.bwh01,
                                            g_bwh.bwh02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwh.bwh01,SQLCA.sqlcode,0)
        INITIALIZE g_bwh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbwh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bwh.* FROM bwh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bwh01 = g_bwh.bwh01 AND bwh02 = g_bwh.bwh02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bwh.bwh01,SQLCA.sqlcode,0)    #No.FUN-660052
       CALL cl_err3("sel","bwh_file",g_bwh.bwh01,g_bwh.bwh02,SQLCA.sqlcode,"","",1)
    ELSE
 
        CALL i910_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i910_show()
    LET g_bwh_t.* = g_bwh.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_bwh.*
    DISPLAY BY NAME g_bwh.bwh01,g_bwh.bwh02,g_bwh.bwh03,g_bwh.bwh04,g_bwh.bwh05,g_bwh.bwh06,
                    g_bwh.bwh07,g_bwh.bwh08,g_bwh.bwh09,g_bwh.bwh10,g_bwh.bwh11,g_bwh.bwh12,
                    g_bwh.bwh13,g_bwh.bwh14,g_bwh.bwh15,g_bwh.bwh16
    #No.FUN-9A0024--end 
    SELECT ima02,ima15,ima106 INTO g_ima02,g_ima15,g_ima106 FROM ima_file
     WHERE ima01 = g_bwh.bwh02
    DISPLAY g_ima02 TO FORMONLY.ima02
    DISPLAY g_ima15 TO FORMONLY.ima15
    DISPLAY g_ima106 TO FORMONLY.ima106
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO ima15
    END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i910_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bwh.bwh01 IS NULL OR g_bwh.bwh02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bwh01_t = g_bwh.bwh01
    LET g_bwh02_t = g_bwh.bwh02
    BEGIN WORK
 
    OPEN i910_cl USING g_bwh.bwh01,g_bwh.bwh02
    IF STATUS THEN
       CALL cl_err("OPEN i910_cl:", STATUS, 1)
       CLOSE i910_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i910_cl INTO g_bwh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwh.bwh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i910_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i910_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bwh.*=g_bwh_t.*
            CALL i910_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
         UPDATE bwh_file SET bwh_file.* = g_bwh.*     # 更新DB
          WHERE bwh01 = g_bwh01_t AND bwh02 = g_bwh02_t
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_bwh.bwh01,SQLCA.sqlcode,0)  #No.FUN-660052
           CALL cl_err3("upd","bwh_file",g_bwh01_t,g_bwh02_t,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i910_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i910_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_bwh.bwh01 IS NULL OR
       g_bwh.bwh02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i910_cl USING g_bwh.bwh01,g_bwh.bwh02
    IF STATUS THEN
       CALL cl_err("OPEN i910_cl:", STATUS, 1)
       CLOSE i910_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i910_cl INTO g_bwh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bwh.bwh01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i910_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bwh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bwh02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bwh.bwh01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bwh.bwh02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bwh_file WHERE bwh01=g_bwh.bwh01 AND bwh02=g_bwh.bwh02
       CLEAR FORM
       OPEN i910_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i910_cs
          CLOSE i910_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i910_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i910_cs
          CLOSE i910_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i910_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i910_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i910_fetch('/')
       END IF
    END IF
    CLOSE i910_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i910_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680062  VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bwh01,bwh02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i910_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bwh01,bwh02",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
