# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri040.4gl
# Descriptions...: 
# Date & Author..: 05/06/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrbz               RECORD LIKE hrbz_file.*     
DEFINE g_hrbz_t             RECORD LIKE hrbz_file.*  
DEFINE g_hrbz_o             RECORD LIKE hrbz_file.* 
DEFINE g_hrbz02_t           LIKE hrbz_file.hrbz02  
DEFINE g_hrbza     DYNAMIC ARRAY OF RECORD 
         hrbza01   LIKE hrbza_file.hrbza01,
         hrbza02   LIKE hrbza_file.hrbza02,   
         hrbza03   LIKE hrbza_file.hrbza03,   
         hrbza04   LIKE hrbza_file.hrbza04
                   END RECORD
DEFINE g_hrbza_t   RECORD
         hrbza01   LIKE hrbza_file.hrbza01,                        
         hrbza02   LIKE hrbza_file.hrbza02,   
         hrbza03   LIKE hrbza_file.hrbza03,   
         hrbza04   LIKE hrbza_file.hrbza04
                           END RECORD
DEFINE g_hrbza_o   RECORD
         hrbza01   LIKE hrbza_file.hrbza01,                        
         hrbza02   LIKE hrbza_file.hrbza02,   
         hrbza03   LIKE hrbza_file.hrbza03,   
         hrbza04   LIKE hrbza_file.hrbza04
                   END RECORD
DEFINE g_sql               STRING                        #CURSOR暫存
DEFINE g_wc                STRING                        #單頭CONSTRUCT結果
DEFINE g_wc2               STRING                        #單身CONSTRUCT結果
DEFINE g_rec_b             LIKE type_file.num10          #單身筆數
DEFINE l_ac                LIKE type_file.num10          #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING                        #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num10          #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10          #總筆數
DEFINE g_jump              LIKE type_file.num10          #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num10          #是否開啟指定筆視窗
DEFINE g_hrbz_1   DYNAMIC ARRAY OF RECORD
         hrbz01     LIKE   hrbz_file.hrbz01,
         hraa12     LIKE   hraa_file.hraa12,
         hrbz02     LIKE   hrbz_file.hrbz02,
         hrbz03     LIKE   hrbz_file.hrbz03,
         hrbz04     LIKE   hrbz_file.hrbz04
                  END RECORD,
       g_rec_b1,l_ac1   LIKE  type_file.num5 
DEFINE g_bp_flag           LIKE type_file.chr1 


MAIN
   OPTIONS                               #改變一些系統預設值
        INPUT NO WRAP    #No.FUN-9B0136

   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM hrbz_file WHERE hrbz02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i040_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i040_w WITH FORM "ghr/42f/ghri040"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i040_menu()
 
   CLOSE WINDOW i040_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i040_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   CALL g_hrbza.clear()
 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_hrbz.* TO NULL
   CONSTRUCT BY NAME g_wc ON hrbz01,hrbz02,hrbz03,hrbz04,
                             hrbzuser,hrbzgrup,hrbzoriu,
                             hrbzorig,hrbzmodu,hrbzdate
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbz01)               #單據編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbz01
               NEXT FIELD hrbz01
            OTHERWISE EXIT CASE
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbzuser', 'hrbzgrup')
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON hrbza01,hrbza02,hrbza03,hrbza04
                FROM s_hrbza[1].hrbza01,s_hrbza[1].hrbza02,
                     s_hrbza[1].hrbza03,s_hrbza[1].hrbza04
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         ON ACTION controlp
            CASE
              WHEN INFIELD(hrbza02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_hrbza02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrbza02
                  NEXT FIELD hrbza02
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT hrbz02 FROM hrbz_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY hrbz02"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE hrbz02 ",
                  "  FROM hrbz_file,hrbza_file ",
                  " WHERE hrbz02 = hrbza05 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY hrbz02"
   END IF
 
   PREPARE i040_prepare FROM g_sql
   DECLARE i040_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i040_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM hrbz_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT hrbz02) FROM hrbz_file,hrbza_file",
                " WHERE hrbz02 = hrbza05 ",
                "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
   PREPARE i040_precount FROM g_sql
   DECLARE i040_count CURSOR FOR i040_precount
END FUNCTION
	
FUNCTION i040_menu()
 
   WHILE TRUE
      CALL i040_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN 
         SELECT hrbz_file.*
           INTO g_hrbz.*
           FROM hrbz_file
          WHERE hrbz02=g_hrbz_1[l_ac1].hrbz02
      END IF

      IF g_action_choice != "" THEN
         LET g_bp_flag = 'Page3'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i040_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page4", TRUE)
      END IF
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i040_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i040_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i040_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i040_u()
            END IF
 
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i040_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbza),'','')
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_hrbz.hrbz02 IS NOT NULL THEN
               LET g_doc.column1 = "hrbz02"
               LET g_doc.value1 = g_hrbz.hrbz02
               CALL cl_doc()
            END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_hrbza TO s_hrbza.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION delete
         LET g_action_choice="delete"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION first
         CALL i040_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION previous
         CALL i040_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION jump
         CALL i040_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION next
         CALL i040_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION last
         CALL i040_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
     ON ACTION detail
        LET g_action_choice="detail"
        LET l_ac = 1
        #EXIT DISPLAY
        EXIT DIALOG
        
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG
         
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         #EXIT DISPLAY
         EXIT DIALOG
         
      AFTER DISPLAY
         #CONTINUE DISPLAY
         CONTINUE DIALOG
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         #EXIT DISPLAY
         EXIT DIALOG
          
      &include "qry_string.4gl"
 
   END DISPLAY
   
   DISPLAY ARRAY g_hrbz_1 TO s_hrbz.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
         
       ON ACTION main
         LET g_bp_flag = 'Page3'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i040_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page4", TRUE)
         EXIT DIALOG
      
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i040_fetch('/')
         CALL cl_set_comp_visible("Page4", FALSE)
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page4", TRUE)
         EXIT DIALOG
         
      ON ACTION insert
         LET g_action_choice="insert"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION delete
         LET g_action_choice="delete"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG
         
      ON ACTION about
         CALL cl_about()
         
      AFTER DISPLAY
         #CONTINUE DISPLAY
         CONTINUE DIALOG
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         #EXIT DISPLAY
         EXIT DIALOG
         
   END DISPLAY
   
   END DIALOG
                      
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i040_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_hrbza.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_hrbz.* LIKE hrbz_file.*             #DEFAULT 設定
   LET g_hrbz02_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_hrbz_t.* = g_hrbz.*
   LET g_hrbz_o.* = g_hrbz.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrbz.hrbzuser=g_user
      LET g_hrbz.hrbzgrup=g_grup
      LET g_hrbz.hrbzoriu = g_user
      LET g_hrbz.hrbzorig = g_grup
 
      CALL i040_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_hrbz.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_hrbz.hrbz02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF

      BEGIN WORK
 
      INSERT INTO hrbz_file VALUES (g_hrbz.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         ROLLBACK WORK
         CALL cl_err3("ins","hrbz_file",g_hrbz.hrbz02,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_hrbz.hrbz02,'I')
      END IF
 
      LET g_hrbz02_t = g_hrbz.hrbz02        #保留舊值
      LET g_hrbz_t.* = g_hrbz.*
      LET g_hrbz_o.* = g_hrbz.*
      
      CALL g_hrbza.clear() 
      LET g_rec_b = 0
      CALL i040_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
	
FUNCTION i040_u()
DEFINE l_n  LIKE  type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbz.hrbz02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_hrbz.* FROM hrbz_file
    WHERE hrbz02=g_hrbz.hrbz02
    
   LET l_n=0 
   SELECT COUNT(*) INTO l_n FROM hrbp_filehrbpa_file
    WHERE hrbp02=hrbpa05
      AND hrbp05='2'             #轮转依据为群组
      AND hrbpa02=g_hrbz.hrbz02  #班组编号
   IF l_n>0 THEN
   	  CALL cl_err('该班组以维护轮转,不可修改','!',0)
   	  RETURN
   END IF	      
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrbz02_t = g_hrbz.hrbz02
   BEGIN WORK
 
   OPEN i040_cl USING g_hrbz.hrbz02
   IF STATUS THEN
      CALL cl_err("OPEN i040_cl:", STATUS, 1)
      CLOSE i040_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i040_cl INTO g_hrbz.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbz.hrbz02,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i040_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i040_show()
 
   WHILE TRUE
      LET g_hrbz02_t = g_hrbz.hrbz02
      LET g_hrbz_o.* = g_hrbz.*
      LET g_hrbz.hrbzmodu=g_user
      LET g_hrbz.hrbzdate=g_today
 
      CALL i040_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_hrbz.*=g_hrbz_t.*
         CALL i040_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      #IF g_hrbz.hrbz02 != g_hrbz02_t THEN            # 更改單號
      #   UPDATE hrbza_file SET hrbza07 = g_hrbz.hrbz02
      #   WHERE hrbza07 = g_hrbz02_t
      #   IF SQLCA.sqlcode THEN
      #      CALL cl_err3("upd","hrbza_file",g_hrbz01_t,"",SQLCA.sqlcode,"","hrbza",1)
      #      CONTINUE WHILE
      #   END IF
      #END IF
 
      UPDATE hrbz_file SET hrbz_file.* = g_hrbz.*
       WHERE hrbz02 = g_hrbz02_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","hrbz_file",g_hrbz02_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i040_cl
   COMMIT WORK
   CALL cl_flow_notify(g_hrbz.hrbz02,'U')
 
   CALL i040_show()
   CALL i040_b1_fill(g_wc,g_wc2) 
END FUNCTION
	
FUNCTION i040_i(p_cmd)
   DEFINE l_n         LIKE type_file.num10
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_hraa12    LIKE hraa_file.hraa12
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_hrbz.hrbz01,g_hrbz.hrbz02,
                   g_hrbz.hrbz03,g_hrbz.hrbz04,
                   g_hrbz.hrbzuser,g_hrbz.hrbzmodu,g_hrbz.hrbzoriu,
                   g_hrbz.hrbzorig,g_hrbz.hrbzgrup,g_hrbz.hrbzdate
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_hrbz.hrbz01,g_hrbz.hrbz02,
                 g_hrbz.hrbz03,g_hrbz.hrbz04
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i040_set_entry(p_cmd)
         CALL i040_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD hrbz01
         IF NOT cl_null(g_hrbz.hrbz01) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file
             WHERE hraa01=g_hrbz.hrbz01
               AND hraaacti='Y'
            IF l_n=0 THEN
            	 CALL cl_err("无此公司编号","!",0)
            	 NEXT FIELD hrbz01
            END IF
            
            SELECT hraa12 INTO l_hraa12 FROM hraa_file
             WHERE hraa01=g_hrbz.hrbz01
               AND hraaacti='Y'
            DISPLAY l_hraa12 TO hraa12   		    
         END IF
      
      #mod by zhangbo130528
      #自动编号,3位流水码
      BEFORE FIELD hrbz02
         IF p_cmd='a' THEN
            IF cl_null(g_hrbz.hrbz02) THEN
               SELECT MAX(hrbz02) INTO g_hrbz.hrbz02 FROM hrbz_file
               IF cl_null(g_hrbz.hrbz02) THEN
                  LET g_hrbz.hrbz02='001'
               ELSE
                  LET g_hrbz.hrbz02=g_hrbz.hrbz02+1 USING '&&&'
               END IF
            END IF
         END IF 
         	
      AFTER FIELD hrbz02
         IF NOT cl_null(g_hrbz.hrbz02) THEN
         	  IF g_hrbz_t.hrbz02 != g_hrbz.hrbz02 
         	  	OR g_hrbz_t.hrbz02 IS NULL THEN
         	  	LET l_n=0
         	  	SELECT COUNT(*) INTO l_n FROM hrbz_file
         	  	 WHERE hrbz02=g_hrbz.hrbz02
         	  	IF l_n>0 THEN
         	  		 CALL cl_err("班组编号不能重复","!",0)
         	  		 NEXT FIELD hrbz02
         	  	END IF
         	  END IF
         END IF
      
      AFTER FIELD hrbz03
         IF NOT cl_null(g_hrbz.hrbz03) THEN
         	  IF g_hrbz_t.hrbz03 != g_hrbz.hrbz03 
         	  	OR g_hrbz_t.hrbz03 IS NULL THEN
         	  	LET l_n=0
         	  	SELECT COUNT(*) INTO l_n FROM hrbz_file
         	  	 WHERE hrbz03=g_hrbz.hrbz03
         	  	IF l_n>0 THEN
         	  		 CALL cl_err("班组名称不能重复","!",0)
         	  		 NEXT FIELD hrbz03
         	  	END IF
         	  END IF
         END IF    	
         		  				     	
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbz01)     
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hraa01"
               LET g_qryparam.default1 = g_hrbz.hrbz01              
               CALL cl_create_qry() RETURNING g_hrbz.hrbz01              
               DISPLAY BY NAME g_hrbz.hrbz01
               NEXT FIELD hrbz01
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

FUNCTION i040_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrbza.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i040_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hrbz.* TO NULL
      RETURN
   END IF
 
   OPEN i040_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrbz.* TO NULL
   ELSE
      OPEN i040_count
      FETCH i040_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i040_fetch('F')                  # 讀出TEMP第一筆并顯示
      CALL i040_b1_fill(g_wc,g_wc2)
   END IF
 
END FUNCTION
	
FUNCTION i040_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i040_cs INTO g_hrbz.hrbz02
      WHEN 'P' FETCH PREVIOUS i040_cs INTO g_hrbz.hrbz02
      WHEN 'F' FETCH FIRST    i040_cs INTO g_hrbz.hrbz02
      WHEN 'L' FETCH LAST     i040_cs INTO g_hrbz.hrbz02
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
            FETCH ABSOLUTE g_jump i040_cs INTO g_hrbz.hrbz02
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbz.hrbz02,SQLCA.sqlcode,0)
      INITIALIZE g_hrbz.* TO NULL
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
 
   SELECT * INTO g_hrbz.* FROM hrbz_file WHERE hrbz02 = g_hrbz.hrbz02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrbz_file",g_hrbz.hrbz02,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_hrbz.* TO NULL
      RETURN
   END IF
 
   CALL i040_show()
 
END FUNCTION	
	
FUNCTION i040_show()
DEFINE l_hraa12  LIKE   hraa_file.hraa12      #add by zhangbo130826

 
   LET g_hrbz_t.* = g_hrbz.*                #保存單頭舊值
   LET g_hrbz_o.* = g_hrbz.*                #保存單頭舊值
   DISPLAY BY NAME g_hrbz.hrbz01,g_hrbz.hrbz02,
                   g_hrbz.hrbz03,g_hrbz.hrbz04,
                   g_hrbz.hrbzuser,g_hrbz.hrbzgrup,g_hrbz.hrbzmodu,
                   g_hrbz.hrbzdate,g_hrbz.hrbzoriu,g_hrbz.hrbzorig

   SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01==g_hrbz.hrbz01      #add by zhangbo130826
   DISPLAY l_hraa12 TO hraa12                                                  #add by zhangbo130826
 
   CALL i040_b_fill(g_wc2)
END FUNCTION
	
FUNCTION i040_r()
DEFINE  l_n   LIKE  type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbz.hrbz02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_hrbz.* FROM hrbz_file
    WHERE hrbz02=g_hrbz.hrbz02
    
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM hrbp_file,hrbpa_file
    WHERE hrbp02=hrbpa05
      AND hrbp05='2'             #轮转依据为群组
      AND hrbpa02=g_hrbz.hrbz02  #群组编号
   IF l_n>0 THEN
   	  CALL cl_err("该班组已维护轮转,不可删除","!",0)
   	  RETURN
   END IF	     
 
   BEGIN WORK
 
   OPEN i040_cl USING g_hrbz.hrbz02
   IF STATUS THEN
      CALL cl_err("OPEN i040_cl:", STATUS, 1)
      CLOSE i040_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i040_cl INTO g_hrbz.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbz.hrbz02,SQLCA.sqlcode,0)     # 資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i040_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "hrbz02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_hrbz.hrbz02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM hrbz_file WHERE hrbz02 = g_hrbz.hrbz02
      DELETE FROM hrbza_file WHERE hrbza05 = g_hrbz.hrbz02
      CLEAR FORM
      CALL g_hrbza.clear()
      OPEN i040_count
      FETCH i040_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i040_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i040_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i040_fetch('/')
      END IF
   END IF
 
   CLOSE i040_cl
   COMMIT WORK
   CALL cl_flow_notify(g_hrbz.hrbz02,'D')
   CALL i040_b1_fill(g_wc,g_wc2)
END FUNCTION
	
FUNCTION i040_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT hrbza01,hrbza02,hrbza03,hrbza04 ",
               "  FROM hrbza_file ",
               " WHERE hrbza05 ='",g_hrbz.hrbz02,"' " 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY hrbza01 "
 
   PREPARE i040_pb FROM g_sql
   DECLARE hrbza_cs CURSOR FOR i040_pb
 
   CALL g_hrbza.clear()
   LET g_cnt = 1
 
   FOREACH hrbza_cs INTO g_hrbza[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrbza.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i040_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("hrbz02",TRUE)
    END IF
END FUNCTION
 
FUNCTION i040_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("hrbz02",FALSE)
    END IF
 
END FUNCTION
	
FUNCTION i040_b()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_i     LIKE type_file.num5       
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_hrbz.hrbz02) THEN
           RETURN 
        END IF
        
        SELECT * INTO g_hrbz.* FROM hrbz_file
         WHERE hrbz02=g_hrbz.hrbz02
         
        LET l_n=0
        SELECT COUNT(*) INTO l_n FROM hrbp_file,hrbpa_file
         WHERE hrbp02=hrbpa05
           AND hrbp05='2'             #轮转依据为群组
           AND hrbpa02=g_hrbz.hrbz02  #群组编号
        IF l_n>0 THEN
        	  CALL cl_err("该班组已维护轮转,不可进入单身编辑","!",0)
        	  RETURN
        END IF 
        
        CALL cl_opmsg('b')
        
        LET g_forupd_sql= "SELECT hrbza01,hrbza02,hrbza03,hrbza04 ",
                          "  FROM hrbza_file ",
                          " WHERE hrbza01 = ? ",
                          "   AND hrbza05 = ? ",
                          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i040_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_hrbza WITHOUT DEFAULTS FROM s_hrbza.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
           IF g_rec_b !=0 THEN 
              CALL fgl_set_arr_curr(l_ac)
           END IF
                
        BEFORE ROW
           LET p_cmd =''
           LET l_ac =ARR_CURR()
           LET l_lock_sw ='N'
           LET l_n =ARR_COUNT()
                
           BEGIN WORK 
           OPEN i040_cl USING g_hrbz.hrbz02
           IF STATUS THEN
              CALL cl_err("OPEN i040_cl:",STATUS,1)
              CLOSE i040_cl
              ROLLBACK WORK
           END IF
           
           FETCH i040_cl INTO g_hrbz.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrbz.hrbz02,SQLCA.sqlcode,0)
              CLOSE i040_cl
              ROLLBACK WORK 
              RETURN
           END IF
           	
           IF g_rec_b>=l_ac THEN 
               LET p_cmd ='u'
               LET g_hrbza_t.*=g_hrbza[l_ac].*
               LET g_hrbza_o.*=g_hrbza[l_ac].*
               OPEN i040_bcl USING g_hrbza_t.hrbza01,g_hrbz.hrbz02
               IF STATUS THEN
                  CALL cl_err("OPEN i040_bcl:",STATUS,1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i040_bcl INTO g_hrbza[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrbza_t.hrbza02,SQLCA.sqlcode,1)
                     LET l_lock_sw="Y"
                  END IF
                  	 	 	
               END IF
           END IF
       BEFORE INSERT
           LET l_n=ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_hrbza[l_ac].* TO NULL
           LET g_hrbza_t.*=g_hrbza[l_ac].*  	 	     
           CALL cl_show_fld_cont()
           NEXT FIELD hrbza01
                
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             CANCEL INSERT
          END IF
          INSERT INTO hrbza_file(hrbza01,hrbza02,hrbza03,
                      hrbza04,hrbza05)
             VALUES(g_hrbza[l_ac].hrbza01,g_hrbza[l_ac].hrbza02,
                    g_hrbza[l_ac].hrbza03,g_hrbza[l_ac].hrbza04,
                    g_hrbz.hrbz02)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","hrbza_file",g_hrbz.hrbz02,g_hrbza[l_ac].hrbza01,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   MESSAGE 'INSERT O.K.'
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                
      BEFORE FIELD hrbza01
        IF cl_null(g_hrbza[l_ac].hrbza01) OR g_hrbza[l_ac].hrbza01 = 0 THEN 
            SELECT MAX(hrbza01)+1 INTO g_hrbza[l_ac].hrbza01
              FROM hrbza_file
             WHERE hrbza05 = g_hrbz.hrbz02
            IF g_hrbza[l_ac].hrbza01 IS NULL THEN
               LET g_hrbza[l_ac].hrbza01=1
            END IF
         END IF
         
      AFTER FIELD hrbza01 #項次
        IF NOT cl_null(g_hrbza[l_ac].hrbza01) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_hrbza[l_ac].hrbza01 <> g_hrbza_t.hrbza01) THEN
              SELECT COUNT(*) INTO l_n FROM hrbza_file
               WHERE hrbza05 = g_hrbz.hrbz02
                 AND hrbza01 = g_hrbza[l_ac].hrbza01
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_hrbza[l_ac].hrbza01=g_hrbza_t.hrbza01
                 NEXT FIELD hrbza01
              END IF
           END IF
         END IF
       
       AFTER FIELD hrbza02
          IF NOT cl_null(g_hrbza[l_ac].hrbza02) THEN
          	 LET l_n=0     
             SELECT COUNT(*) INTO l_n FROM hrbo_file
              WHERE hrbo01=g_hrbz.hrbz01
                AND hrbo02=g_hrbza[l_ac].hrbza02
             IF l_n=0 THEN
             	 CALL cl_err('无此班次编号','!',0)
             	 NEXT FIELD hrbza02
             END IF
             
             SELECT hrbo03 INTO g_hrbza[l_ac].hrbza03
               FROM hrbo_file
              WHERE hrbo01=g_hrbz.hrbz01
                AND hrbo02=g_hrbza[l_ac].hrbza02
         
             DISPLAY BY NAME g_hrbza[l_ac].hrbza03		         		      
          END IF
 
       
         
       BEFORE DELETE                      
           IF g_hrbza_t.hrbza01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM hrbza_file
               WHERE hrbza05 = g_hrbz.hrbz02
                 AND hrbza01 = g_hrbza_t.hrbza01
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","hrbza_file",g_hrbz.hrbz02,g_hrbza_t.hrbza01,SQLCA.sqlcode,"","",1)  
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
              LET g_hrbza[l_ac].* = g_hrbza_t.*
              CLOSE i040_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_hrbza[l_ac].hrbza01,-263,1)
              LET g_hrbza[l_ac].* = g_hrbza_t.*
           ELSE
              UPDATE hrbza_file SET hrbza01 = g_hrbza[l_ac].hrbza01,
                                    hrbza02 = g_hrbza[l_ac].hrbza02,
                                    hrbza03 = g_hrbza[l_ac].hrbza03,
                                    hrbza04 = g_hrbza[l_ac].hrbza04
                 WHERE hrbza05 = g_hrbz.hrbz02
                   AND hrbza01 = g_hrbza_t.hrbza01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","hrbza_file",g_hrbz.hrbz02,g_hrbza_t.hrbza01,SQLCA.sqlcode,"","",1) 
                 LET g_hrbza[l_ac].* = g_hrbza_t.*
              ELSE                
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_hrbza[l_ac].* = g_hrbza_t.*
              END IF
              CLOSE i040_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i040_bcl
           COMMIT WORK

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbza02)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_hrbo02"
            LET g_qryparam.arg1 = g_hrbz.hrbz01 		     
            LET g_qryparam.default1 = g_hrbza[l_ac].hrbza02
            CALL cl_create_qry() RETURNING g_hrbza[l_ac].hrbza02
            DISPLAY BY NAME g_hrbza[l_ac].hrbza02
            NEXT FIELD hrbza02
         END CASE 
           
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
     
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT

    CLOSE i040_bcl
    COMMIT WORK
    CALL i040_delall()
    CALL i040_show()
END FUNCTION 
 
FUNCTION i040_delall()
#刪除單頭資料
   SELECT COUNT(*) INTO g_cnt FROM hrbza_file
    WHERE hrbza05 = g_hrbz.hrbz02
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
 
      DELETE FROM hrbz_file
       WHERE hrbz02 = g_hrbz.hrbz02
      CLEAR FORM 
      INITIALIZE g_hrbz.* TO NULL
   END IF
END FUNCTION	
	
FUNCTION i040_b1_fill(p_wc,p_wc2)
DEFINE p_wc     STRING
DEFINE p_wc2    STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5

  
        CALL g_hrbz_1.clear()
        
        
        IF p_wc2 = " 1=1" THEN 
           LET l_sql=" SELECT hrbz01,'',hrbz02,hrbz03,hrbz04",
                     "   FROM hrbz_file ",
                     "  WHERE ",p_wc CLIPPED,
                     "  ORDER BY hrbz02 "
        ELSE
        	 LET l_sql=" SELECT DISTINCT hrbz01,'',hrbz02,hrbz03,hrbz04",
                     "   FROM hrbz_file,hrbza_file ",
                     "  WHERE hrbz02 = hrbza05 ",
                     "    AND ", p_wc CLIPPED, " AND ",p_wc2 CLIPPED,
                     "  ORDER BY hrbz02" 
        END IF 
                            
        PREPARE i040_b1_pre FROM l_sql
        DECLARE i040_b1_cs CURSOR FOR i040_b1_pre
        
        LET l_i=1
        
        FOREACH i040_b1_cs INTO g_hrbz_1[l_i].*
        
           SELECT hraa12 INTO g_hrbz_1[l_i].hraa12 FROM hraa_file
            WHERE hraa01=g_hrbz_1[l_i].hrbz01
                            
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrbz_1.deleteElement(l_i)
        LET g_rec_b1 = l_i - 1

END FUNCTION		

