# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aski006.4gl
# Descriptions...: 群組報工工單維護作業珛
# Date & Author..: No.FUN-810016 No.FUN-840178 07/08/01 By hongmei                                                                                                
# Modify.........: No.FUN-850079 FUN-870117 BY ve007 08/05/16  服飾功能修改
# Modify.........: No.FUN-8A0151 08/11/01 By Carrier 版片序號的arg1應該傳款式號
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940108 09/05/08 By mike skr03查詢開窗報錯   
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 取消料號的管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.TQC-BC0166 11/12/29 By yuhuabao 新增時已移轉件數(skr08) default 0
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_skq           RECORD LIKE skq_file.*,        
    g_skq_t         RECORD LIKE skq_file.*,       
    g_skq_o         RECORD LIKE skq_file.*,      
    g_skq01_t       LIKE skq_file.skq01,            
    g_skq03_t       LIKE skq_file.skq03,
    g_skq08_t       LIKE skq_file.skq08,       
    g_ydate         DATE,                                
    g_skr           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        skr03       LIKE skr_file.skr03,          #版片序號
        skr04       LIKE skr_file.skr04,          #元件料號  
        skr05       LIKE skr_file.skr05,          #部位 
        skr06       LIKE skr_file.skr06,          #單件片數
        skr07       LIKE skr_file.skr07,          #良品件數
        skr08       LIKE skr_file.skr08           #已移轉件數
                    END RECORD,
    g_skr_t         RECORD                        #程式變數 (舊值)
        skr03       LIKE skr_file.skr03,          
        skr04       LIKE skr_file.skr04,            
        skr05       LIKE skr_file.skr05,           
        skr06       LIKE skr_file.skr06,          
        skr07       LIKE skr_file.skr07,          
        skr08       LIKE skr_file.skr08           
                    END RECORD, 
    g_skr_o         RECORD                        #程式變數 (舊值)
        skr03       LIKE skr_file.skr03,          
        skr04       LIKE skr_file.skr04,            
        skr05       LIKE skr_file.skr05,           
        skr06       LIKE skr_file.skr06,          
        skr07       LIKE skr_file.skr07,          
        skr08       LIKE skr_file.skr08            
                    END RECORD,
    g_sql           STRING,                       #CURSOR暫存 
    g_wc            STRING,                       #單頭CONSTRUCT結果
    g_wc2           STRING,                       #單身CONSTRUCT結果
    g_rec_b         LIKE type_file.num5,                     #單身筆數
    l_ac            LIKE type_file.num5                      #目前處理的ARRAY CNT
                                                   
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5               #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10                #總筆數
DEFINE g_jump              LIKE type_file.num10                #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5               #是否開啟指定筆視窗
DEFINE g_argv1             LIKE skr_file.skr01               #單號
DEFINE g_argv2             STRING                 #指定執行的功能
 
MAIN
    OPTIONS                                #改變一些系統預設值扢硉
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASK")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('slk') THEN
      CALL cl_err("","-1000",1)
      EXIT PROGRAM
   END IF   
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #TQC-940168
 
   LET g_forupd_sql = "SELECT * FROM skq_file WHERE skq01 = ? AND skq03 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i006_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i006_w WITH FORM "ask/42f/aski006"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i006_menu()
   CLOSE WINDOW i006_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間)
   RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i006_cs()
 
 CLEAR FORM                             #清除單頭畫面
 CALL g_skr.clear()                     #清除單身畫面
 
 
 
   CONSTRUCT BY NAME g_wc ON skq01,skq02,skq03,skq07,skq08,
                             skquser,skqgrup,skqmodu,skqdate,skqacti
      ON ACTION controlp
         CASE
            WHEN INFIELD(skq01)    #工單單號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_sfb02"
               LET g_qryparam.arg1 ="2345"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO skq01
               NEXT FIELD skq01
             WHEN INFIELD(skq03)   #工藝序號 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ecm08"
               LET g_qryparam.arg1 =g_skq.skq01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO skq03
               NEXT FIELD skq03 
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('skquser', 'skqgrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
      CONSTRUCT g_wc2 ON skr03,skr07,skr08 #螢幕上取單身條件 
           FROM s_skr[1].skr03,s_skr[1].skr07,s_skr[1].skr08 
                  
      ON ACTION CONTROLP 
         CASE 
          
           WHEN INFIELD(skr03)      #版片序號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form ="q_skp"
              LET g_qryparam.arg1 =g_skq.skq02
              CALL cl_create_qry() RETURNING g_qryparam.multiret  
              DISPLAY g_qryparam.multiret TO skr03  
              NEXT FIELD skr03
            OTHERWISE EXIT CASE
         END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
 
   IF g_wc2 = " 1=1" THEN                  #若單身未輸入條件
      LET g_sql = "SELECT skq01,skq03 FROM skq_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY skq01,skq03"
   ELSE                                    #若單身有輸入條件
      LET g_sql = "SELECT DISTINCT skq01,skq03 ",
                  "  FROM skq_file, skr_file ",
                  " WHERE skq01 = skr01",
                  "   AND skq03 = skr02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY skq01,skq03"
   END IF
 
   PREPARE i006_prepare FROM g_sql
   DECLARE i006_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i006_prepare
 
   IF g_wc2 = " 1=1" THEN                  #取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM skq_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT skq01) FROM skq_file,skr_file WHERE ",
                "skr01=skq01 AND ","skr02=skq03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i006_precount FROM g_sql
   DECLARE i006_count CURSOR FOR i006_precount
 
END FUNCTION
 
FUNCTION i006_menu()
   DEFINE l_str  LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i006_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i006_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i006_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i006_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i006_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i006_x()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exporttoexcel"                                                   
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skq),'','')
            END IF
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "job_production"   #批次產生款式版片資料
            CALL i006_auto_b()   #自動產生單身
            
         WHEN "confirm"          #審核
            IF cl_chk_act_auth() THEN
               CALL i006_y()
               CALL i006_field_pic()
            END IF
         
         WHEN "unconfirm"        #取消審核
           IF cl_chk_act_auth() THEN
              CALL i006_z()
              CALL i006_field_pic()   
           END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_skr TO s_skr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
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
         CALL i006_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION previous
         CALL i006_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION jump
         CALL i006_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION next
         CALL i006_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION last
         CALL i006_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
       
      ON ACTION job_production     #批次產生款式版片資料
         LET g_action_choice="job_production"
         IF cl_chk_act_auth() THEN					
           IF NOT cl_confirm('ask-017') THEN
              RETURN	
           END IF 
         END IF				
         DELETE FROM skr_file WHERE skr01=g_skq.skq01 AND skr02=g_skq.skq03
         CALL i006_auto_b()
 
      ON ACTION confirm 
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL i006_y()
            CALL i006_field_pic()
         END IF 
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL i006_z()
            CALL i006_field_pic()
         END IF
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i006_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_skr.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_skq.* LIKE skq_file.*             #DEFAULT 設定
   LET g_skq01_t = NULL
 
   LET g_skq.skq08 = 'N' 
   #預設值及將數值類變數清成零
   LET g_skq_t.* = g_skq.*
   LET g_skq_o.* = g_skq.*
   
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_skq.skquser=g_user
      LET g_skq.skqgrup=g_grup
      LET g_skq.skqdate=g_today
      LET g_skq.skqacti='Y'              #資料有效虴
      LET g_skq.skqplant=g_plant   #FUN-980008 add
      LET g_skq.skqlegal=g_legal   #FUN-980008 add
 
      CALL i006_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_skq.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_skq.skq01) THEN              # KEY不可空白
         CONTINUE WHILE
      END IF
    
     BEGIN WORK 
    
      LET g_skq.skqoriu = g_user      #No.FUN-980030 10/01/04
      LET g_skq.skqorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO skq_file VALUES (g_skq.*)
              
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err(g_skq.skq01,SQLCA.sqlcode,1) #FUN-B80030 ADD
         ROLLBACK WORK      
      # CALL cl_err(g_skq.skq01,SQLCA.sqlcode,1)   #FUN-B80030 MARK
 
         CONTINUE WHILE
      ELSE
         COMMIT WORK         
         CALL cl_flow_notify(g_skq.skq01,'I')
      END IF
 
      SELECT skq01 INTO g_skq.skq01 FROM skq_file
       WHERE skq01 = g_skq.skq01
      LET g_skq01_t = g_skq.skq01        #保留舊值
      LET g_skq_t.* = g_skq.*
      LET g_skq_o.* = g_skq.*
      LET g_skq.skq04= g_today
      LET g_skq.skq05= g_today
      CALL g_skr.clear()
 
      LET g_rec_b = 0
      IF NOT cl_confirm('ask-017') THEN
         CALL i006_b()   #輸入單身
      ELSE    
        CALL i006_auto_b()
        CALL i006_b()
      END IF 
                           
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i006_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_skq.skq01 AND g_skq.skq03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_skq.* FROM skq_file
    WHERE skq01=g_skq.skq01
      AND skq03=g_skq.skq03
 
   IF g_skq.skqacti ='N' THEN    #檢查資料是否為無效虴
      CALL cl_err(g_skq.skq01,'mfg1000',0)
      RETURN
   END IF
    IF g_skq.skq08 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_skq01_t = g_skq.skq01
   BEGIN WORK
 
   OPEN i006_cl USING g_skq.skq01,g_skq.skq03
   IF STATUS THEN
      CALL cl_err("OPEN i006_cl:", STATUS, 1)
      CLOSE i006_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i006_cl INTO g_skq.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_skq.skq01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i006_show()
 
   WHILE TRUE
      LET g_skq01_t = g_skq.skq01
      LET g_skq_o.* = g_skq.*
      LET g_skq.skqmodu=g_user
      LET g_skq.skqdate=g_today
 
      CALL i006_i("u")                           #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_skq.*=g_skq_t.*
         CALL i006_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_skq.skq01 != g_skq01_t THEN            #更改單號 
         UPDATE skr_file SET skr01 = g_skq.skq01
          WHERE skr01 = g_skq01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","skr_file",g_skq01_t,"",SQLCA.sqlcode,"","skr",1) 
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE skq_file SET skq_file.* = g_skq.*
       WHERE skq01 = g_skq_t.skq01 AND skq03 = g_skq_t.skq03
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","skq_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i006_cl
   COMMIT WORK
   CALL cl_flow_notify(g_skq.skq01,'U')
 
END FUNCTION
 
FUNCTION i006_i(p_cmd)
 
DEFINE
   l_n,l_n1        LIKE type_file.num5,
   l_m             LIKE type_file.num5,
   l_x             LIKE type_file.num5,
   p_cmd           LIKE type_file.chr1                #a:輸入 u:更改
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   l_skr08a  LIKE skr_file.skr08
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_skq.skq01,g_skq.skq03,g_skq.skq07,g_skq.skq08,
                   g_skq.skquser,g_skq.skqmodu,g_skq.skqgrup,
                   g_skq.skqdate,g_skq.skqacti,g_skq.skq02
 
   INPUT BY NAME g_skq.skq01,g_skq.skq03,g_skq.skq07,g_skq.skq08,
                 g_skq.skquser,g_skq.skqmodu,g_skq.skqgrup,
                 g_skq.skqdate,g_skq.skqacti
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i006_set_entry(p_cmd)
         CALL i006_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD skq01
          IF cl_null(g_skq.skq01) THEN
             CALL cl_err('skq01','ask-014',0)
             NEXT FIELD skq01
          END IF
          IF g_skq.skq01 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_skq.skq01 !=g_skq01_t) THEN
                SELECT COUNT(*) INTO l_m FROM sfb_file
                 WHERE sfb01 = g_skq.skq01 
                   AND sfb87='Y' 
                   AND sfbacti='Y'
                   AND sfb04>'1' 
                   AND sfb04<'6'
                IF l_m<=0 THEN
                   CALL cl_err(g_skq.skq01,'ask-018',0)
                   NEXT FIELD skq01
                END IF
                IF l_n>0 THEN
                   CALL cl_err(g_skq.skq01,'ask-018',0)
                   NEXT FIELD skq01
                END IF
               CALL i006_skq01('d')                                
             END IF
          END IF 
          
      AFTER FIELD skq03
          IF cl_null(g_skq.skq03) THEN
             CALL cl_err('skq03','ask-014',0)
             NEXT FIELD skq03
          END IF
          IF g_skq.skq03 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_skq.skq03 !=g_skq03_t) THEN
                SELECT COUNT(*) INTO l_x FROM ecm_file
                 WHERE ecm01=g_skq.skq01 and ecmslk01='Y' 
                   AND ecm03 not in (SELECT shb06 FROM shb_file WHERE shb05=g_skq.skq01 AND shb06=g_skq.skq03 AND shbconf = 'Y')  #FUN-A70095 add shbconf
                   AND ecm03 = g_skq.skq03
                IF l_x = 0 THEN
                   CALL cl_err(g_skq.skq03,'ask-018',0)
                   NEXT FIELD skq03
                END IF
                SELECT COUNT(*) INTO l_n1 FROM skq_file
                 WHERE skq01=g_skq.skq01
                   AND skq03=g_skq.skq03
                   IF l_n1>0 THEN
                     CALL cl_err(g_skq.skq01,-239,0)
                     NEXT FIELD skq01
                   END IF
               CALL i006_skq03('d')                                
             END IF
          END IF 
          
                                                                                 
     
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
 
      ON ACTION controlp
         CASE                                                              
            WHEN INFIELD(skq01)                                 
               CALL cl_init_qry_var()                                     
               LET g_qryparam.form ="q_sfb02"                             
               LET g_qryparam.default1 = g_skq.skq01                      
               LET g_qryparam.arg1 ="2345"                 
               CALL cl_create_qry() RETURNING g_skq.skq01
               DISPLAY g_skq.skq01 TO skq01
               NEXT FIELD skq01
            WHEN INFIELD(skq03) 
               CALL cl_init_qry_var()                                     
               LET g_qryparam.form ="q_ecm08"                             
               LET g_qryparam.default1 = g_skq.skq03                      
               LET g_qryparam.arg1 =g_skq.skq01                 
               CALL cl_create_qry() RETURNING g_skq.skq03
               DISPLAY g_skq.skq03 TO skq03
               NEXT FIELD skq03  
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
   END INPUT
 
END FUNCTION
 
FUNCTION i006_skq01(p_cmd)  
    DEFINE p_cmd         LIKE type_file.chr1,
           l_sfb85       LIKE sfb_file.sfb85,
           l_sfb22       LIKE sfb_file.sfb22,
           l_sfb221      LIKE sfb_file.sfb221,
           l_sfb13       LIKE sfb_file.sfb13,
           l_sfb15       LIKE sfb_file.sfb15,
           l_sfb25       LIKE sfb_file.sfb25,
           l_sfb08       LIKE sfb_file.sfb08,
           l_sfb09       LIKE sfb_file.sfb09,
           l_skr08a      LIKE skr_file.skr08,
           l_skq02       LIKE skq_file.skq02,
           l_ima02       LIKE ima_file.ima02
          
 
    LET g_errno = ' '
        SELECT sfb85,sfb22,sfb221,sfb13,sfb15,
               sfb25            
          INTO l_sfb85,l_sfb22,l_sfb221,l_sfb13,l_sfb15,
               l_sfb25       
          FROM sfb_file WHERE sfb01 = g_skq.skq01
          
        SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_skq.skq01
        SELECT sfb09 INTO l_sfb09 FROM sfb_file WHERE sfb01 = g_skq.skq01
        SELECT sfb05 INTO l_skq02 FROM sfb_file WHERE sfb01 = g_skq.skq01
        SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_skq02
        
        SELECT MIN(skr08) INTO l_skr08a FROM skr_file 
               WHERE skr01=g_skq.skq01 
                 AND skr02=g_skq.skq03
        
        IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","skr_file","","",SQLCA.sqlcode,"","",1)
            LET g_errno = 'agl-005'
        END IF
        LET g_skq.skq02 = l_skq02
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
          DISPLAY l_sfb85 TO sfb85
          DISPLAY l_sfb22 TO sfb22
          DISPLAY l_sfb221 TO sfb221
          DISPLAY l_sfb13 TO sfb13
          DISPLAY l_sfb15 TO sfb15
          DISPLAY l_sfb25 TO sfb25
          DISPLAY l_sfb08 TO sfb08
          DISPLAY l_sfb09 TO sfb09
          DISPLAY l_skr08a TO FORMONLY.skr08a
          DISPLAY l_skq02 TO skq02
          DISPLAY l_ima02 TO ima02
    END IF
END FUNCTION
 
FUNCTION i006_skq03(p_cmd)  
    DEFINE p_cmd         LIKE type_file.chr1,
           l_ecm45       LIKE ecm_file.ecm45,
           l_skq06       LIKE skq_file.skq06,
           l_eca02       LIKE eca_file.eca02 
           
    LET g_errno = ' '
        SELECT ecm45,ecm06
          INTO l_ecm45,l_skq06
          FROM ecm_file WHERE ecm01=g_skq.skq01
                          AND ecm03=g_skq.skq03
       IF l_skq06 IS NULL THEN
        SELECT eca02 INTO l_eca02 FROM eca_file WHERE  eca01 IS NULL 
       ELSE
        SELECT eca02 INTO l_eca02 FROM eca_file WHERE  eca01=l_skq06 
       END IF 
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
          DISPLAY l_ecm45 TO FORMONLY.ecm45
          DISPLAY l_skq06 TO skq06
          DISPLAY l_eca02 TO FORMONLY.eca02
    END IF
END FUNCTION
 
FUNCTION i006_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_skr.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i006_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_skq.* TO NULL
      RETURN
   END IF
 
   OPEN i006_cs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_skq.* TO NULL
   ELSE
      OPEN i006_count
      FETCH i006_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i006_fetch('F')                 #讀出TEMP第一筆并顯示珆尨
   END IF
 
END FUNCTION
 
FUNCTION i006_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1              #處理方式宒
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i006_cs INTO g_skq.skq01,g_skq.skq03
      WHEN 'P' FETCH PREVIOUS i006_cs INTO g_skq.skq01,g_skq.skq03
      WHEN 'F' FETCH FIRST    i006_cs INTO g_skq.skq01,g_skq.skq03
      WHEN 'L' FETCH LAST     i006_cs INTO g_skq.skq01,g_skq.skq03
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
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
            FETCH ABSOLUTE g_jump i006_cs INTO g_skq.skq01,g_skq.skq03
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_skq.skq01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_skq.* FROM skq_file WHERE skq01 = g_skq.skq01 AND skq03 = g_skq.skq03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","skq_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_skq.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_skq.skquser       
   LET g_data_group = g_skq.skqgrup       
 
   CALL i006_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i006_show()
   LET g_skq_t.* = g_skq.*                #保存單頭舊值硉
   LET g_skq_o.* = g_skq.*                #保存單頭舊值
   DISPLAY BY NAME g_skq.skq01,g_skq.skq02,g_skq.skq03,g_skq.skq04,
                   g_skq.skq05,g_skq.skq06,g_skq.skq07,g_skq.skq08,
                   g_skq.skquser,g_skq.skqgrup,g_skq.skqmodu,
                   g_skq.skqdate,g_skq.skqacti
   CALL i006_skq01('d')
   CALL i006_skq03('d')
   CALL i006_b_fill(g_wc2)                #單身
   CALL i006_field_pic()
 
END FUNCTION
 
FUNCTION i006_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_skq.skq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_skq.skq08 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   BEGIN WORK
 
   OPEN i006_cl USING g_skq.skq01,g_skq.skq03
   IF STATUS THEN
      CALL cl_err("OPEN i006_cl:", STATUS, 1)
      CLOSE i006_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i006_cl INTO g_skq.*                           #鎖住將被更改或取消的資料 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_skq.skq01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i006_show()
 
   IF cl_exp(0,0,g_skq.skqacti) THEN        #確認一下
      LET g_chr=g_skq.skqacti
      IF g_skq.skqacti='Y' THEN
         LET g_skq.skqacti='N'
      ELSE
         LET g_skq.skqacti='Y'
      END IF
 
      UPDATE skq_file SET skqacti=g_skq.skqacti,
                          skqmodu=g_user,
                          skqdate=g_today
       WHERE skq01=g_skq.skq01
         AND skq03=g_skq.skq03
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","skq_file",g_skq.skq01,"",SQLCA.sqlcode,"","",1)  
         LET g_skq.skqacti=g_chr
      END IF
   END IF
 
   CLOSE i006_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_skq.skq01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT skqacti,skqmodu,skqdate
     INTO g_skq.skqacti,g_skq.skqmodu,g_skq.skqdate FROM skq_file
    WHERE skq01=g_skq.skq01
      AND skq03=g_skq.skq03
   DISPLAY BY NAME g_skq.skqacti,g_skq.skqmodu,g_skq.skqdate
 
END FUNCTION
 
FUNCTION i006_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_skq.skq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_skq.* FROM skq_file
    WHERE skq01=g_skq.skq01
      AND skq03=g_skq.skq03
   IF g_skq.skqacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_skq.skq01,'mfg1000',0)
      RETURN
   END IF
   IF g_skq.skq08 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   BEGIN WORK
 
   OPEN i006_cl USING g_skq.skq01,g_skq.skq03
   IF STATUS THEN
      CALL cl_err("OPEN i006_cl:", STATUS, 1)
      CLOSE i006_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i006_cl INTO g_skq.*                        #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_skq.skq01,SQLCA.sqlcode,0)       #資料被他人 LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i006_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM skq_file WHERE skq01 = g_skq.skq01
                             AND skq03 = g_skq.skq03
      DELETE FROM skr_file WHERE skr01 = g_skq.skq01
                             AND skr02 = g_skq.skq03
      CLEAR FORM
      CALL g_skr.clear()
      OPEN i006_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i006_cs
         CLOSE i006_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i006_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i006_cs
         CLOSE i006_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i006_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i006_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i006_fetch('/')
      END IF
   END IF
 
   CLOSE i006_cl
   COMMIT WORK
   CALL cl_flow_notify(g_skq.skq01,'D')
 
END FUNCTION
 
#單身
FUNCTION i006_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重復用
    l_a             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,              #檢查重復用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態怓
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5               #可刪除否
DEFINE
    l_sfb08         LIKE sfb_file.sfb08
DEFINE
    l_ima151        LIKE ima_file.ima151           #No.FUN-850079
DEFINE l_str        STRING                #No.FUN-8A0151
DEFINE l_index      LIKE type_file.num5   #No.FUN-8A0151
    
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_skq.skq01 IS NULL THEN
       RETURN
    END IF
       
    SELECT * INTO g_skq.* FROM skq_file
     WHERE skq01=g_skq.skq01
       AND skq03=g_skq.skq03
 
    IF g_skq.skqacti ='N' THEN    #檢查資料是否為無效虴
       CALL cl_err(g_skq.skq01,'mfg1000',0)
       RETURN
    END IF
    IF g_skq.skq08 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT skr03,skr04,skr05,skr06,skr07,skr08 ",
                       "  FROM skr_file",
                       " WHERE skr01=? AND skr03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i006_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
 
    INPUT ARRAY g_skr WITHOUT DEFAULTS FROM s_skr.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i006_cl USING g_skq.skq01,g_skq.skq03
           IF STATUS THEN
              CALL cl_err("OPEN i006_cl:", STATUS, 1)
              CLOSE i006_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i006_cl INTO g_skq.*            #鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_skq.skq01,SQLCA.sqlcode,0)      #資料被他人�LOCK
              CLOSE i006_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_skr_t.* = g_skr[l_ac].*  #BACKUP
              LET g_skr_o.* = g_skr[l_ac].*  #BACKUP
              OPEN i006_bcl USING g_skq.skq01,g_skr[l_ac].skr03
              IF STATUS THEN
                 CALL cl_err("OPEN i006_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i006_bcl INTO g_skr[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_skq.skq08,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT skr05,skr06 INTO  
                                               g_skr[l_ac].skr05,
                                               g_skr[l_ac].skr06
                    FROM skr_file WHERE skr01 =g_skr[l_ac].skr03
              END IF
              CALL i006_set_entry_b(p_cmd)     
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_skr[l_ac].* TO NULL      
           LET g_skr[l_ac].skr08 = 0             #No.TQC-BC0166 add
           LET g_skr_t.* = g_skr[l_ac].*         #新輸入資料
           LET g_skr_o.* = g_skr[l_ac].*         #新輸入資料
           CALL i006_set_entry_b(p_cmd)    
           NEXT FIELD skr03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO skr_file
           VALUES(g_skq.skq01,g_skq.skq03,g_skr[l_ac].skr03,
                  g_skr[l_ac].skr04,g_skr[l_ac].skr05,g_skr[l_ac].skr06,
                  g_skr[l_ac].skr07,
                  g_skr[l_ac].skr08,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","skr_file",g_skq.skq01,g_skr[l_ac].skr03,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD skr03
          IF g_skr[l_ac].skr03 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_skr[l_ac].skr03 !=g_skr_t.skr03) THEN
                SELECT COUNT(*) INTO l_n FROM skp_file,skq_file,imx_file
                    WHERE skp01 = imx_file.imx00
                      AND imx000= g_skq.skq02 
                      AND skp02 = g_skr[l_ac].skr03
                IF l_n=0 THEN
                   CALL cl_err(g_skr[l_ac].skr03,'ask-015',0)
                   NEXT FIELD skr03
                END IF
                CALL i006_skr03('d')
             END IF
          END IF
          
       AFTER FIELD skr04
        IF NOT cl_null(g_skr[l_ac].skr04) THEN 
#FUN-AB0025 -----------------------mark----------------------------
#FUN-AA0059 ---------------------start----------------------------
#           IF NOT s_chk_item_no(g_skr[l_ac].skr04,"") THEN
#              CALL cl_err('',g_errno,1)
#              LET g_skr[l_ac].skr04= g_skr_t.skr04
#              NEXT FIELD skr04
#           END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 ----------------------mark-----------------------------
            IF p_cmd= 'a' OR (p_cmd= 'u' AND g_skr[l_ac].skr04 != g_skr_t.skr04) THEN 
              SELECT COUNT(*) INTO l_n FROM skp_file,imx_file
                WHERE imx00= skp01 AND imx_file.imx000= g_skq.skq02
                  AND   skp03 = g_skr[l_ac].skr04
             IF l_n =0 THEN     
               SELECT COUNT(*) INTO l_n FROM sfa_file,ecm_file
                 WHERE (sfa_file.sfa08=ecm_file.ecm04 AND  ecm_file.ecm01=g_skq.skq01 AND  ecm_file.ecm03=g_skq.skq03) 
     	             OR ((sfa_file.sfa08 IS  NULL  OR  sfa_file.sfa08='') AND  sfa_file.sfa01=g_skq.skq01) 
     	            AND sfa03 =g_skr[l_ac].skr04
     	       END IF      
             IF l_n = 0  THEN 
     	         CALL cl_err(g_skr[l_ac].skr04,'ask-015',0)
               NEXT FIELD skr04
             END IF
         END IF 
       END IF 
            
       AFTER FIELD skr06
          IF g_skr[l_ac].skr06 < 0 THEN 
             CALL cl_err(g_skr[l_ac].skr06,'ask-019',0)
          END IF 
             
       AFTER FIELD skr07
          SELECT sfb08 INTO l_sfb08 
              FROM sfb_file 
             WHERE sfb01=g_skq.skq01
          IF NOT cl_null(g_skr[l_ac].skr04) 
             AND g_skr[l_ac].skr07 > l_sfb08 THEN 
             CALL cl_err(g_skr[l_ac].skr07,'ask-020',0)
             NEXT FIELD skr07
          END IF   
       
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_skr_t.skr03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM skr_file
               WHERE skr01 = g_skq.skq01
                 AND skr03 = g_skr_t.skr03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","skq_file",g_skq.skq01,g_skr_t.skr03,SQLCA.sqlcode,"","",1)   
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
              LET g_skr[l_ac].* = g_skr_t.*
              CLOSE i006_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_skr[l_ac].skr03,-263,1)
              LET g_skr[l_ac].* = g_skr_t.*
           ELSE
              UPDATE skr_file SET skr03=g_skr[l_ac].skr03,
                                  skr04=g_skr[l_ac].skr04,
                                  skr05=g_skr[l_ac].skr05,
                                  skr06=g_skr[l_ac].skr06,
                                  skr07=g_skr[l_ac].skr07,
                                  skr08=g_skr[l_ac].skr08
               WHERE skr01=g_skq.skq01
                 AND skr03=g_skr_t.skr03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","skr_file",g_skq.skq01,g_skr_t.skr03,SQLCA.sqlcode,"","",1)  
                 LET g_skr[l_ac].* = g_skr_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac         #FUN-D40030 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_skr[l_ac].* = g_skr_t.*
              #FUN-D40030---add---str---
              ELSE
                 CALL g_skr.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030---add---end---
              END IF
              CLOSE i006_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac         #FUN-D40030 add
           CLOSE i006_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(skr03) AND l_ac > 1 THEN
              LET g_skr[l_ac].* = g_skr[l_ac-1].*
              LET g_skr[l_ac].skr03 = g_rec_b + 1
              NEXT FIELD skr03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(skr03) #版片序號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_skp"
                 LET g_qryparam.default1 = g_skr[l_ac].skr03
                 LET l_str = g_skq.skq02
                 LET l_index = l_str.getIndexOf(g_sma.sma46,1)
                 IF l_index > 1 THEN LET l_index = l_index - 1 END IF
                 LET g_qryparam.arg1 = g_skq.skq02[1,l_index]
                 CALL cl_create_qry() RETURNING g_skr[l_ac].skr03
                 DISPLAY BY NAME g_skr[l_ac].skr03
                 CALL i006_skr03('d')
                 NEXT FIELD skr03
              WHEN INFIELD(skr04) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_skr04"
                 LET g_qryparam.arg1 = g_skq.skq02
                 LET g_qryparam.default1 = g_skr[l_ac].skr04
                 CALL cl_create_qry() RETURNING g_skr[l_ac].skr04
                 SELECT ima151 INTO l_ima151 FROM ima_file 
                    WHERE ima01 = g_skr[l_ac].skr04
                 IF l_ima151 = 'Y' THEN 
                    SELECT sfa03 INTO g_skr[l_ac].skr04  FROM sfa_file,ecm_file
                      WHERE (sfa_file.sfa08=ecm_file.ecm04 AND  ecm_file.ecm01=g_skq.skq01 AND  ecm_file.ecm03=g_skq.skq03) 
     	                   OR ((sfa_file.sfa08 IS  NULL  OR  sfa_file.sfa08='') AND  sfa_file.sfa01=g_skq.skq01)  
     	           END IF          
                 DISPLAY BY NAME g_skr[l_ac].skr04
                 NEXT FIELD skr04
             OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
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
 
   #記錄單身修改人和時間
    LET g_skq.skqmodu = g_user
    LET g_skq.skqdate = g_today
    UPDATE skq_file SET skqmodu = g_skq.skqmodu,skqdate = g_skq.skqdate
     WHERE skq01 = g_skq.skq01
       AND skq03 = g_skq.skq03
    DISPLAY BY NAME g_skq.skqmodu,g_skq.skqdate
    
 
    CLOSE i006_bcl
    COMMIT WORK
#   CALL i006_delall()  #CHI-C30002 mark
    CALL i006_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
FUNCTION i006_auto_b()  #自動產生工單各需裁片管理的工序的版片資料
DEFINE
     sr             DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        skr01       LIKE skr_file.skr01,
        skr02       LIKE skr_file.skr02,
        skr03       LIKE skr_file.skr03,          #
        skr04       LIKE skr_file.skr04,          #  
        skr05       LIKE skr_file.skr05,          # 
        skr06       LIKE skr_file.skr06,          #
        skr07       LIKE skr_file.skr07,          #
        skr08       LIKE skr_file.skr08           #
                    END RECORD
DEFINE l_ima151     LIKE ima_file.ima151,
       l_sql        STRING,                       #No.FUN-850079
       l_sfa03      LIKE sfa_file.sfa03,          #No.FUN-850079 
       l_cnt        LIKE type_file.num5           #No.FUN-850079 
                 
    IF cl_null(g_skq.skq02) THEN 
       RETURN
    END IF								
    LET g_cnt = 0  	
     SELECT COUNT(*) INTO g_cnt FROM skr_file 
                                WHERE skr01=g_skq.skq01 
                                  AND skr02=g_skq.skq03     
     IF g_cnt > 0 THEN 		#已有單身則不可再產生
        RETURN 	
     END IF
     
     LET l_sql=" SELECT skp02,skp03,skp04,skp05", 
               "   FROM skp_file,imx_file",              
               "  WHERE skp_file.skp01 = imx_file.imx00 ",
               "    AND imx000 = '",g_skq.skq02,"'"     	          
		 PREPARE i006_auto_b FROM l_sql
		 DECLARE i006_auto_b_c1 CURSOR FOR i006_auto_b					                    
     LET l_ac =1
     FOREACH i006_auto_b_c1 INTO g_skr[l_ac].skr03,g_skr[l_ac].skr04,g_skr[l_ac].skr05,g_skr[l_ac].skr06    
       IF STATUS THEN
       EXIT FOREACH                                  		
       END IF
       SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 =g_skr[l_ac].skr04
       IF l_ima151 ='Y'  THEN 
           SELECT sfa03 INTO g_skr[l_ac].skr04  FROM sfa_file,ecm_file
           WHERE (sfa_file.sfa08=ecm_file.ecm04 AND  ecm_file.ecm01=g_skq.skq01 AND  ecm_file.ecm03=g_skq.skq03) 
     	       OR ((sfa_file.sfa08 IS  NULL  OR  sfa_file.sfa08='') AND  sfa_file.sfa01=g_skq.skq01) 
     	 END IF        
       LET sr[l_ac].skr01=g_skq.skq01 					
       LET sr[l_ac].skr02=g_skq.skq03
       INSERT INTO skr_file VALUES(g_skq.skq01,g_skq.skq03,g_skr[l_ac].skr03,g_skr[l_ac].skr04,g_skr[l_ac].skr05,g_skr[l_ac].skr06,'1','',g_plant,g_legal) #FUN-980008 add g_plant,g_legal
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
          CALL cl_err('ins skr',SQLCA.SQLCODE,1)
       END IF
       LET l_ac= l_ac+1                    #No.FUN-850079
       SELECT * INTO g_skq.* FROM skq_file 
                WHERE skq01=g_skq.skq01
                  AND skq03=g_skq.skq03 
     END FOREACH
 
     CALL i006_show()			
END FUNCTION						
 

#CHI-C30002 -------- add -------- begin
FUNCTION i006_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM skq_file WHERE skq01 = g_skq.skq01
                              AND skq03 = g_skq.skq03
         INITIALIZE g_skq.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i006_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM skr_file
#    WHERE skr01 = g_skq.skq01
#      AND skr02 = g_skq.skq03
#
#   IF g_cnt = 0 THEN                   #未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM skq_file WHERE skq01 = g_skq.skq01
#                             AND skq03 = g_skq.skq03 
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i006_skr03(p_cmd)  #
    DEFINE p_cmd       LIKE type_file.chr1,
           p_code      LIKE type_file.chr1,
           l_skr04     like skr_file.skr04,
           l_skr05     like skr_file.skr05,
           l_skr06     like skr_file.skr06,
           l_sql       STRING
 
    LET g_errno = ' '
       SELECT skp03,skp04,skp05 INTO l_skr04,l_skr05,l_skr06 FROM skp_file,imx_file  #No.FUN-850079 
        WHERE skp01 = imx_file.imx00
          AND imx000= g_skq.skq02 
          AND skp02=g_skr[l_ac].skr03
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
           LET   g_skr[l_ac].skr04 = l_skr04
           LET   g_skr[l_ac].skr05 = l_skr05
           LET   g_skr[l_ac].skr06 = l_skr06
    END IF     
END FUNCTION 
 
FUNCTION i006_b_askkey()
 
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON skr03,skr04,skr05,skr06,skr07,skr08
            FROM s_skr[1].skr03,s_skr[1].skr04,s_skr[1].skr05,
                 s_skr[1].skr06,s_skr[1].skr07,s_skr[1].skr08 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()     
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i006_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i006_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2       STRING
   
 
    LET g_sql = "SELECT skr03,'',skp04,skp05,skr07,skr08",
                " FROM skr_file,skp_file,imx_file",   
                " WHERE skr01 ='",g_skq.skq01,"' ",
                " AND skr02 ='",g_skq.skq03,"' ",
                " AND skp01 = imx_file.imx00",
                " AND imx000='",g_skq.skq02,"' ",
                " AND skp02 = skr03 "
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY skr03" 
    DISPLAY g_sql
            
    PREPARE i006_pb FROM g_sql
    DECLARE skr_cs                       #CURSOR
        CURSOR FOR i006_pb
 
    CALL g_skr.clear()
    LET g_cnt = 1
 
    FOREACH skr_cs INTO g_skr[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT skr04 INTO g_skr[g_cnt].skr04
        FROM skr_file 
        WHERE skr01=g_skq.skq01
          AND skr02=g_skq.skq03                #No.FUN-850079
          AND skr03=g_skr[g_cnt].skr03         #No.FUN-850079
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	    EXIT FOREACH
      END IF
    END FOREACH
    CALL g_skr.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i006_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("skq01,skq03",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION i006_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
 
  CALL cl_set_comp_entry("skq08",FALSE)
 
  IF p_cmd='u' AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("skq01,skq03",FALSE)
  END IF
   
END FUNCTION
 
FUNCTION i006_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF
END FUNCTION
 
 
FUNCTION i006_y()
   IF cl_null(g_skq.skq01) OR
      cl_null(g_skq.skq03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_skq.skq08 !='N' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   IF g_skq.skqacti = 'N' THEN
      CALL cl_err('','9028',0)      
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------------- add ---------------- begin
   SELECT * INTO g_skq.* FROM skq_file WHERE skq01 = g_skq.skq01
                                         AND skq03 = g_skq.skq03
   IF cl_null(g_skq.skq01) OR
      cl_null(g_skq.skq03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_skq.skq08 !='N' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_skq.skqacti = 'N' THEN
      CALL cl_err('','9028',0)
      RETURN
   END IF
#CHI-C30107 -------------- add ---------------- end
   BEGIN WORK
 
   OPEN i006_cl USING g_skq.skq01,g_skq.skq03
   IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 1)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_skq.*               #對DB鎖定
    LET g_skq.skq08 = 'Y'
    UPDATE skq_file SET skq08 = g_skq.skq08
                     WHERE skq01 = g_skq.skq01
                       AND skq03 = g_skq.skq03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","skq_file",g_skq.skq01,"",SQLCA.sqlcode,"","",0)
       ROLLBACK WORK
       RETURN
    END IF
    CLOSE i006_cl
    COMMIT WORK
    DISPLAY BY NAME g_skq.skq08
END FUNCTION 
 
FUNCTION i006_z()
 DEFINE l_n   LIKE type_file.num5
   IF g_skq.skq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM sie_file  
                   WHERE sie03=g_skq.skq01
                     AND sie04=g_skq.skq03
        
   IF l_n>0  THEN
      CALL cl_err("",'ask-021',1)
   END IF 
 
   IF g_skq.skq08="N" OR g_skq.skqacti="N" THEN
      CALL cl_err("",'atm-365',1)
   ELSE
      IF cl_confirm('aap-224') THEN
         BEGIN WORK
         UPDATE skq_file SET skq08="N"
                         WHERE skq01=g_skq.skq01
      
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","skq_file",g_skq.skq01,"",SQLCA.sqlcode,"","skq08",1)
         ROLLBACK WORK
      ELSE
         COMMIT WORK
         LET g_skq.skq08="N"
         DISPLAY BY NAME g_skq.skq08
      END IF
      END IF
   END IF
END FUNCTION 
 
FUNCTION i006_field_pic()
   DEFINE l_flag   LIKE type_file.chr1
 
   CASE
     #無效
     WHEN g_skq.skqacti = 'N' 
        CALL cl_set_field_pic("","","","","","N")
     #審核
     WHEN g_skq.skq08 = 'Y' 
        CALL cl_set_field_pic("Y","","","","","")
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION
#No.FUN-9C0072 精簡程式碼
