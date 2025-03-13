# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: amdi202.4gl
# Descriptions...: 促銷條碼維護作業 
# Date & Author..: FUN-AB0080 10/11/27 BY sabrina
# Modify.........: No:FUN-AB0080 10/11/27 By sabrina create program
# Modify.........: No:TQC-AC0086 10/12/08 By sabrina qry改抓q_ima01 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
    g_ami           RECORD LIKE ami_file.*,       
    g_ami_t         RECORD LIKE ami_file.*,      
    g_ami_o         RECORD LIKE ami_file.*,     
    g_ami01_t       LIKE ami_file.ami01,       
    g_ami02_t       LIKE ami_file.ami02,       
    g_ami04_t       LIKE ami_file.ami04,       
    g_amj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        amj05       LIKE amj_file.amj05,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021 
                    END RECORD,
    g_amj_t         RECORD    #程式變數(Program Variables)
        amj05       LIKE amj_file.amj05,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021 
                    END RECORD,
    g_wc,g_wc2,g_sql     string,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_sql                STRING
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_db_type       LIKE type_file.chr3                   #FUN-9B0082 mod
DEFINE   g_cnt          LIKE type_file.num10  
DEFINE   g_i            LIKE type_file.num5  
DEFINE   g_msg          LIKE type_file.chr1000  
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_jump         LIKE type_file.num10  
DEFINE   g_no_ask       LIKE type_file.num5 
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time                
 
    LET g_forupd_sql = "SELECT * FROM ami_file ",
                       " WHERE ami01 = ? AND ami02 = ? ",
                       "   AND ami04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i202_w WITH FORM "amd/42f/amdi202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL i202_menu()
 
    CLOSE WINDOW i202_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time     
END MAIN
 
#QBE 查詢資料
FUNCTION i202_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01 
 
    CLEAR FORM                             #清除畫面
    CALL g_amj.clear()
    CALL cl_set_head_visible("","YES")      
 
   INITIALIZE g_ami.* TO NULL 
    CONSTRUCT BY NAME g_wc ON ami01,ami02,ami03,ami04,ami05
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ami01)
                LET g_qryparam.form = "q_occ02"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ami01
                NEXT FIELD ami01
             OTHERWISE
          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION qbe_select
        CALL cl_qbe_list() RETURNING lc_qbe_sn
        CALL cl_qbe_display_condition(lc_qbe_sn)
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON amj05              # 螢幕上取單身條件
         FROM s_amj[1].amj05
 
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(amj05)
              #LET g_qryparam.form = "q_ima01_4"    #TQC-AC0086 mark
               LET g_qryparam.form = "q_ima01"      #TQC-AC0086 add 
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO amj05
               NEXT FIELD amj05
            OTHERWISE
         END CASE

      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ami01,ami02,ami04 FROM ami_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ami_file.ami01,ami_file.ami02,ami_file.ami04 ",
                   "  FROM ami_file, amj_file",
                   " WHERE ami01 = amj01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE i202_prepare FROM g_sql
    DECLARE i202_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i202_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ami_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ami01) FROM ami_file,amj_file WHERE ",
                  "amj01=ami01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i202_precount FROM g_sql
    DECLARE i202_count CURSOR FOR i202_precount
 
END FUNCTION
 
FUNCTION i202_menu()
   WHILE TRUE
      CALL i202_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i202_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i202_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i202_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i202_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i202_b()
            ELSE
               LET g_action_choice = NULL
            END IF
    
         WHEN "help" 
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_amj),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i202_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_amj.clear()
 
    INITIALIZE g_ami.* LIKE ami_file.*             #DEFAULT 設定
    LET g_ami01_t = NULL
    LET g_ami_t.* = g_ami.*
    LET g_ami_o.* = g_ami.*
    LET g_ami.ami02 = g_today
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i202_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_ami.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ami.ami01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
 
        INSERT INTO ami_file(ami01,ami02,ami03,ami04,ami05) 
                      VALUES(g_ami.ami01,g_ami.ami02,g_ami.ami03,
                             g_ami.ami04,g_ami.ami05)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
           CALL cl_err3("ins","ami_file",g_ami.ami01,"",SQLCA.sqlcode,"","",1)  
           CONTINUE WHILE
        END IF
 
        SELECT ami01 INTO g_ami.ami01 FROM ami_file
         WHERE ami01 = g_ami.ami01
        LET g_ami01_t = g_ami.ami01        #保留舊值
        LET g_ami_t.* = g_ami.*
 
        CALL g_amj.clear()
        LET g_rec_b = 0 
 
        CALL i202_b()                      #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i202_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ami.ami01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_ami01_t = g_ami.ami01
    LET g_ami_o.* = g_ami.*
    LET g_ami_t.* = g_ami.*
 
    BEGIN WORK
 
    OPEN i202_cl USING g_ami.ami01,g_ami.ami02,g_ami.ami04
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ami.ami01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i202_cl ROLLBACK WORK RETURN
    END IF
 
    FETCH i202_cl INTO g_ami.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ami.ami01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i202_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i202_show()
 
    WHILE TRUE
        LET g_ami01_t = g_ami.ami01
        CALL i202_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ami.*=g_ami_t.*
            CALL i202_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        IF g_ami.ami03 != g_ami_t.ami03 THEN 
           UPDATE amj_file SET amj03 = g_ami.ami03
            WHERE amj01 = g_ami.ami01 AND amj02 = g_ami.ami02 AND amj04 = g_ami.ami04
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","amj_file",g_ami01_t,"",SQLCA.sqlcode,"","amj",1)  
              CONTINUE WHILE  
           END IF
        END IF
 
        UPDATE ami_file SET ami01 = g_ami.ami01, ami02 = g_ami.ami02 ,
                            ami03 = g_ami.ami03, ami04 = g_ami.ami04,
                            ami05 = g_ami.ami05
         WHERE ami01 = g_ami.ami01 AND ami02 = g_ami.ami02 AND ami04 = g_ami.ami04
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ami_file",g_ami01_t,"",SQLCA.sqlcode,"","",1)  
           CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    CLOSE i202_cl
    COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i202_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
    l_n1            LIKE type_file.num5,          
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
    l_occ02         LIKE occ_file.occ02                  #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)

 
    DISPLAY BY NAME g_ami.ami01,g_ami.ami02,g_ami.ami04 
    CALL cl_set_head_visible("","YES")       
 
    INPUT BY NAME
        g_ami.ami01,g_ami.ami02,g_ami.ami03,
        g_ami.ami04,g_ami.ami05
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i202_set_entry(p_cmd)
           CALL i202_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
        
        AFTER FIELD ami01      
           IF NOT cl_null(g_ami.ami01) THEN
              IF g_ami.ami01 != g_ami01_t OR cl_null(g_ami01_t) THEN
                 LET g_cnt = 0
                 SELECT COUNT(*) INTO g_cnt FROM occ_file
                  WHERE occ01 = g_ami.ami01
                 IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                 IF g_cnt = 0 THEN
                    CALL cl_err(g_ami.ami01,'anm-045',1)
                    NEXT FIELD ami01
                 ELSE
                    SELECT occ02 INTO l_occ02 FROM occ_file
                     WHERE occ01 = g_ami.ami01
                    DISPLAY l_occ02 TO FORMONLY.ami012
                 END IF
              END IF
              LET g_ami_o.ami01 = g_ami.ami01
           END IF
             
        AFTER FIELD ami02
           IF NOT cl_null(g_ami.ami02) AND NOT cl_null(g_ami.ami03) THEN
              IF g_ami.ami03 <= g_ami.ami02 THEN
                 CALL cl_err('','mfg3009',0)
                 NEXT FIELD ami02
              END IF
           END IF

        AFTER FIELD ami03
           IF NOT cl_null(g_ami.ami02) AND NOT cl_null(g_ami.ami03) THEN
              IF g_ami.ami03 <= g_ami.ami02 THEN
                 CALL cl_err('','mfg3009',0)
                 NEXT FIELD ami03
              END IF
           END IF

       AFTER FIELD ami04
          IF NOT cl_null(g_ami.ami04) THEN
             IF NOT cl_null(g_ami.ami01) AND NOT cl_null(g_ami.ami02) THEN
                SELECT COUNT(*) INTO g_cnt FROM ami_file
                 WHERE ami01=g_ami.ami01 AND ami02=g_ami.ami02
                   AND ami04=g_ami.ami04
                IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                IF g_cnt > 0 THEN
                   CALL cl_err(g_ami.ami04,'-239',0)
                   NEXT FIELD ami04
                END IF
             END IF
          END IF  
            
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ami01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ02"
                LET g_qryparam.default1= g_ami.ami01 
                CALL cl_create_qry() RETURNING g_ami.ami01 
                NEXT FIELD ami01
          END CASE

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
    
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ami.* TO NULL              #FUN-6B0079
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL i202_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ami.* TO NULL
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
 
    OPEN i202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ami.* TO NULL
    ELSE
       OPEN i202_count
       FETCH i202_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL i202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i202_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i202_cs INTO g_ami.ami01,g_ami.ami02,g_ami.ami04
        WHEN 'P' FETCH PREVIOUS i202_cs INTO g_ami.ami01,g_ami.ami02,g_ami.ami04
        WHEN 'F' FETCH FIRST    i202_cs INTO g_ami.ami01,g_ami.ami02,g_ami.ami04
        WHEN 'L' FETCH LAST     i202_cs INTO g_ami.ami01,g_ami.ami02,g_ami.ami04
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED || ': ' FOR g_jump   
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
 
                    ON ACTION about         
                       CALL cl_about()      
 
                    ON ACTION help          
                       CALL cl_show_help()  
 
                    ON ACTION controlg      
                       CALL cl_cmdask()     
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i202_cs INTO g_ami.ami01,g_ami.ami02,g_ami.ami04
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ami.ami01,SQLCA.sqlcode,0)
        INITIALIZE g_ami.* TO NULL  
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
    SELECT * INTO g_ami.* FROM ami_file WHERE ami01 = g_ami.ami01
      AND ami02 = g_ami.ami02 AND ami04 = g_ami.ami04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ami_file",g_ami.ami01,"",SQLCA.sqlcode,"","",1)  
        INITIALIZE g_ami.* TO NULL
        RETURN
    END IF
    LET g_data_owner = ''      
    LET g_data_group = ''      
    CALL i202_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i202_show()
   DEFINE l_occ02      LIKE occ_file.occ02


    LET g_ami_t.* = g_ami.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_ami.ami01,g_ami.ami02,g_ami.ami03,g_ami.ami04,g_ami.ami05
    SELECT occ02 INTO l_occ02 FROM occ_file
     WHERE occ01 = g_ami.ami01
    DISPLAY l_occ02 TO FORMONLY.ami012
    CALL i202_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i202_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1      #No.FUN-680137 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ami.ami01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i202_cl USING g_ami.ami01,g_ami.ami02,g_ami.ami04
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_ami.ami01,SQLCA.sqlcode,0)
       CLOSE i202_cl ROLLBACK WORK RETURN 
    END IF
 
    FETCH i202_cl INTO g_ami.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_ami.ami01,SQLCA.sqlcode,0)
       CLOSE i202_cl ROLLBACK WORK RETURN 
    END IF
 
    CALL i202_show()
 
    IF cl_delh(20,16) THEN
        DELETE FROM ami_file WHERE ami01 = g_ami.ami01
         AND ami02 = g_ami.ami02 AND ami04 = g_ami.ami04
        DELETE FROM amj_file WHERE amj01 = g_ami.ami01
        AND amj02 = g_ami.ami02 AND amj04 = g_ami.ami04
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","ami_file",g_ami.ami01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        ELSE
           CLEAR FORM
           CALL g_amj.clear()
    	   INITIALIZE g_ami.* LIKE ami_file.*             #DEFAULT 設定
           OPEN i202_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE i202_cs
              CLOSE i202_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH i202_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i202_cs
              CLOSE i202_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i202_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i202_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i202_fetch('/')
           END IF
        END IF
    END IF
 
    CLOSE i202_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i202_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
DEFINE li_return    LIKE type_file.num5
DEFINE l_scale      LIKE type_file.num5 
DEFINE l_length     LIKE ztb_file.ztb08
DEFINE l_length1    LIKE ztb_file.ztb08  
DEFINE i            LIKE type_file.num5


    LET g_db_type=cl_db_get_database_type()    
    LET g_action_choice = ""
 
    IF g_ami.ami01 IS NULL THEN RETURN END IF
 
    LET g_forupd_sql = "SELECT amj05,'','' ",  
                       " FROM amj_file ",
                       "  WHERE amj01 = ? AND amj02 = ? AND amj04 = ? AND amj05 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_amj WITHOUT DEFAULTS FROM s_amj.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_amj_t.* = g_amj[l_ac].*  #BACKUP
               OPEN i202_bcl USING g_ami.ami01, g_ami.ami02, g_ami.ami04, g_amj_t.amj05
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_amj_t.amj05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i202_bcl INTO g_amj[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_amj_t.amj05,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
                  SELECT ima02,ima021 INTO g_amj[l_ac].ima02,g_amj[l_ac].ima021 FROM ima_file
                   WHERE ima01 = g_amj[l_ac].amj05
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        AFTER FIELD amj05 
            IF NOT cl_null(g_amj[l_ac].amj05) THEN
               IF g_amj[l_ac].amj05 != g_amj_t.amj05 OR cl_null(g_amj_t.amj05) THEN
                  LET g_cnt = 0
                  SELECT COUNT(*) INTO g_cnt FROM ima_file
                   WHERE ima01 = g_amj[l_ac].amj05
                  IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                  IF g_cnt = 0 THEN
                     CALL cl_err(g_amj[l_ac].amj05,'ams-003',0)
                     NEXT FIELD amj05
                  END IF
                  SELECT COUNT(*) INTO g_cnt FROM amj_file
                   WHERE amj01=g_ami.ami01 AND amj02=g_ami.ami02 
                     AND amj04=g_ami.ami04 AND amj05=g_amj[l_ac].amj05 
                  IF g_cnt >0 THEN
                     CALL cl_err(g_amj[l_ac].amj05,-239,0)
                     NEXT FIELD amj05
                  END IF
               END IF
               SELECT ima02,ima021 INTO g_amj[l_ac].ima02,g_amj[l_ac].ima021 FROM ima_file
                WHERE ima01 = g_amj[l_ac].amj05
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_amj[l_ac].* TO NULL
            LET g_amj_t.* = g_amj[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD amj05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO amj_file(amj01,amj02,amj03,amj04,amj05)
                          VALUES(g_ami.ami01,
                                 g_ami.ami02,
                                 g_ami.ami03,
                                 g_ami.ami04,
                                 g_amj[l_ac].amj05)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","amj_file",g_ami.ami01,g_ami.ami02,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               COMMIT WORK
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_amj_t.amj05 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
               END IF
                
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               
               DELETE FROM amj_file 
                WHERE amj01 = g_ami.ami01 
                  AND amj02 = g_ami.ami02 
                  AND amj04 = g_ami.ami04 
                  AND amj05 = g_amj_t.amj05
               IF SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("del","amj_file",g_ami.ami01,g_amj_t.amj05,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
 
               LET g_rec_b = g_rec_b - 1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_amj[l_ac].* = g_amj_t.*
               CLOSE i202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_amj[l_ac].amj05,-263,1)
               LET g_amj[l_ac].* = g_amj_t.*
            ELSE
               UPDATE amj_file SET amj05=g_amj[l_ac].amj05 
                WHERE amj01 = g_ami.ami01 
                  AND amj02 = g_ami.ami02 
                  AND amj04 = g_ami.ami04 
                  AND amj05 = g_amj_t.amj05 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","amj_file",g_ami.ami01,g_amj_t.amj05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_amj[l_ac].* = g_amj_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_amj[l_ac].* = g_amj_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_amj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE i202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30032 add
 
            CLOSE i202_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP                                                        
           CASE                                                                   
               WHEN INFIELD(amj05)
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_ima01_4"    #TQC-AC0086 mark
                   LET g_qryparam.form = "q_ima01"      #TQC-AC0086 add 
                   LET g_qryparam.default1 = g_amj[l_ac].amj05
                   CALL cl_create_qry() RETURNING g_amj[l_ac].amj05 
                   DISPLAY BY NAME g_amj[l_ac].amj05
                   NEXT FIELD amj05
           END CASE                                                               
 
        ON ACTION controls                                  
         CALL cl_set_head_visible("","AUTO")                
   
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
    END INPUT
 
    CLOSE i202_bcl
    COMMIT WORK
    CALL i202_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i202_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM ami_file WHERE ami01 = g_ami.ami01
                                AND ami02 = g_ami.ami02
                                AND ami04 = g_ami.ami04
         INITIALIZE g_ami.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i202_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       
 
    LET g_sql = "SELECT amj05,'','' ",
                " FROM amj_file ",
                " WHERE amj01 ='",g_ami.ami01,"'",  #單頭
                "   AND amj02 ='",g_ami.ami02,"'",
                "   AND amj04 ='",g_ami.ami04,"'",
                " AND ",p_wc2 CLIPPED,              #單身
                " ORDER BY 1" 
 
    PREPARE i202_pb FROM g_sql
    DECLARE amj_curs                       #CURSOR
        CURSOR FOR i202_pb
 
    CALL g_amj.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH amj_curs INTO g_amj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        SELECT ima02,ima021 INTO g_amj[g_cnt].ima02,g_amj[g_cnt].ima021 FROM ima_file
         WHERE ima01 = g_amj[g_cnt].amj05

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    
    END FOREACH
    CALL g_amj.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt-1               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION i202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_amj TO s_amj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION first 
         CALL i202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
                              
      ON ACTION jump 
         CALL i202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY               
                              
      ON ACTION next
         CALL i202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY               
                              
      ON ACTION last 
         CALL i202_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
      
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION controls                                  
         CALL cl_set_head_visible("","AUTO")             
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
   
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i202_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ami01,ami02,ami03,ami04",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i202_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ami01,ami02,ami04",FALSE)
    END IF
 
END FUNCTION
#FUN-AB0080 

