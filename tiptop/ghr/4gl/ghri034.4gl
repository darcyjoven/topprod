# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri034.4gl
# Descriptions...: 
# Date & Author..: 05/13/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrbp               RECORD LIKE hrbp_file.*     
DEFINE g_hrbp_t             RECORD LIKE hrbp_file.*  
DEFINE g_hrbp_o             RECORD LIKE hrbp_file.* 
DEFINE g_hrbp02_t           LIKE hrbp_file.hrbp02  
DEFINE g_hrbpa     DYNAMIC ARRAY OF RECORD 
         hrbpa01   LIKE hrbpa_file.hrbpa01,
         hrbpa02   LIKE hrbpa_file.hrbpa02,   
         hrbpa03   LIKE hrbpa_file.hrbpa03,   
         hrbpa04   LIKE hrbpa_file.hrbpa04
                   END RECORD
DEFINE g_hrbpa_t   RECORD
         hrbpa01   LIKE hrbpa_file.hrbpa01,                        
         hrbpa02   LIKE hrbpa_file.hrbpa02,   
         hrbpa03   LIKE hrbpa_file.hrbpa03,   
         hrbpa04   LIKE hrbpa_file.hrbpa04
                           END RECORD
DEFINE g_hrbpa_o   RECORD
         hrbpa01   LIKE hrbpa_file.hrbpa01,                        
         hrbpa02   LIKE hrbpa_file.hrbpa02,   
         hrbpa03   LIKE hrbpa_file.hrbpa03,   
         hrbpa04   LIKE hrbpa_file.hrbpa04
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
DEFINE g_flag              LIKE type_file.chr1  
DEFINE g_hrbp_1   DYNAMIC ARRAY OF RECORD
         hrbp01     LIKE   hrbp_file.hrbp01,
         hraa12     LIKE   hraa_file.hraa12,
         hrbp02     LIKE   hrbp_file.hrbp02,
         hrbp03     LIKE   hrbp_file.hrbp03,
         hrbp05     LIKE   hrbp_file.hrbp05,
         hrbp04     LIKE   hrbp_file.hrbp04
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
 
   LET g_forupd_sql = "SELECT * FROM hrbp_file WHERE hrbp02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i034_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i034_w WITH FORM "ghr/42f/ghri034"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i034_menu()
 
   CLOSE WINDOW i034_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i034_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   CALL g_hrbpa.clear()
 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_hrbp.* TO NULL
   CONSTRUCT BY NAME g_wc ON hrbp01,hrbp02,hrbp03,hrbp05,
                             hrbp04,hrbpuser,hrbpgrup,
                             hrbporiu,hrbporig,hrbpmodu,hrbpdate
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbp01)               #單據編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbp01
               NEXT FIELD hrbp01
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbpuser', 'hrbpgrup')
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON hrbpa01,hrbpa02,hrbpa03,hrbpa04
                FROM s_hrbpa[1].hrbpa01,s_hrbpa[1].hrbpa02,
                     s_hrbpa[1].hrbpa03,s_hrbpa[1].hrbpa04
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         #mod by zhangbo130414---放开开窗
         ON ACTION controlp
            CASE
              WHEN INFIELD(hrbpa02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_hrbpa02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrbpa02
                  NEXT FIELD hrbpa02
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
      LET g_sql = "SELECT hrbp02 FROM hrbp_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY hrbp02"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE hrbp02 ",
                  "  FROM hrbp_file,hrbpa_file ",
                  " WHERE hrbp02 = hrbpa05 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY hrbp02"
   END IF
 
   PREPARE i034_prepare FROM g_sql
   DECLARE i034_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i034_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM hrbp_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT hrbp02) FROM hrbp_file,hrbpa_file",
                " WHERE hrbp02 = hrbpa05 ",
                "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
   PREPARE i034_precount FROM g_sql
   DECLARE i034_count CURSOR FOR i034_precount
END FUNCTION
	
FUNCTION i034_menu()
 
   WHILE TRUE
      CALL i034_bp("G")
      
      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN 
         SELECT hrbp_file.*
           INTO g_hrbp.*
           FROM hrbp_file
          WHERE hrbp02=g_hrbp_1[l_ac1].hrbp02
      END IF

      IF g_action_choice != "" THEN
         LET g_bp_flag = 'Page3'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i034_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page4", TRUE)
      END IF
      	
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i034_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i034_q()
            END IF
 
         #WHEN "delete"
         #   IF cl_chk_act_auth() THEN
         #      CALL i034_r()
         #   END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i034_u()
            END IF
 
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i034_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbpa),'','')
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_hrbp.hrbp02 IS NOT NULL THEN
               LET g_doc.column1 = "hrbp02"
               LET g_doc.value1 = g_hrbp.hrbp02
               CALL cl_doc()
            END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i034_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_hrbpa TO s_hrbpa.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      #ON ACTION delete
      #   LET g_action_choice="delete"
      #   EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION first
         CALL i034_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION previous
         CALL i034_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION jump
         CALL i034_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION next
         CALL i034_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
         
      ON ACTION last
         CALL i034_fetch('L')
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
   
   DISPLAY ARRAY g_hrbp_1 TO s_hrbp.* ATTRIBUTE(COUNT=g_rec_b1)
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
             CALL i034_fetch('/')
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
         CALL i034_fetch('/')
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

      ON ACTION close
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
	
FUNCTION i034_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_hrbpa.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_hrbp.* LIKE hrbp_file.*             #DEFAULT 設定
   LET g_hrbp02_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_hrbp_t.* = g_hrbp.*
   LET g_hrbp_o.* = g_hrbp.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrbp.hrbpuser=g_user
      LET g_hrbp.hrbpgrup=g_grup
      LET g_hrbp.hrbporiu = g_user
      LET g_hrbp.hrbporig = g_grup
 
      CALL i034_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_hrbp.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_hrbp.hrbp02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF

      BEGIN WORK
 
      INSERT INTO hrbp_file VALUES (g_hrbp.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         ROLLBACK WORK
         CALL cl_err3("ins","hrbp_file",g_hrbp.hrbp02,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_hrbp.hrbp02,'I')
      END IF
 
      LET g_hrbp02_t = g_hrbp.hrbp02        #保留舊值
      LET g_hrbp_t.* = g_hrbp.*
      LET g_hrbp_o.* = g_hrbp.*
      
      CALL g_hrbpa.clear() 
      LET g_rec_b = 0
      CALL i034_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
	
FUNCTION i034_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbp.hrbp02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_hrbp.* FROM hrbp_file
    WHERE hrbp02=g_hrbp.hrbp02
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrbp02_t = g_hrbp.hrbp02
   BEGIN WORK
 
   OPEN i034_cl USING g_hrbp.hrbp02
   IF STATUS THEN
      CALL cl_err("OPEN i034_cl:", STATUS, 1)
      CLOSE i034_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i034_cl INTO g_hrbp.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbp.hrbp02,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i034_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i034_show()
 
   WHILE TRUE
      LET g_hrbp02_t = g_hrbp.hrbp02
      LET g_hrbp_o.* = g_hrbp.*
      LET g_hrbp.hrbpmodu=g_user
      LET g_hrbp.hrbpdate=g_today
 
      CALL i034_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_hrbp.*=g_hrbp_t.*
         CALL i034_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      #IF g_hrbp.hrbp02 != g_hrbp02_t THEN            # 更改單號
      #   UPDATE hrbpa_file SET hrbpa07 = g_hrbp.hrbp02
      #   WHERE hrbpa07 = g_hrbp02_t
      #   IF SQLCA.sqlcode THEN
      #      CALL cl_err3("upd","hrbpa_file",g_hrbp01_t,"",SQLCA.sqlcode,"","hrbpa",1)
      #      CONTINUE WHILE
      #   END IF
      #END IF
 
      UPDATE hrbp_file SET hrbp_file.* = g_hrbp.*
       WHERE hrbp02 = g_hrbp02_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","hrbp_file",g_hrbp02_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i034_cl
   COMMIT WORK
   CALL cl_flow_notify(g_hrbp.hrbp02,'U')
 
   CALL i034_show()
   #CALL i034_b_fill(" 1=1") 
   CALL i034_b1_fill(g_wc,g_wc2)
END FUNCTION
	
FUNCTION i034_i(p_cmd)
   DEFINE l_n         LIKE type_file.num10
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_hraa12    LIKE hraa_file.hraa12
   DEFINE l_hraa10    LIKE hraa_file.hraa10
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_hrbp.hrbp01,g_hrbp.hrbp02,g_hrbp.hrbp03,
                   g_hrbp.hrbp05,g_hrbp.hrbp04,
                   g_hrbp.hrbpuser,g_hrbp.hrbpmodu,g_hrbp.hrbporiu,
                   g_hrbp.hrbporig,g_hrbp.hrbpgrup,g_hrbp.hrbpdate
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_hrbp.hrbp01,g_hrbp.hrbp02,
                 g_hrbp.hrbp03,g_hrbp.hrbp05,g_hrbp.hrbp04
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i034_set_entry(p_cmd)
         CALL i034_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD hrbp01
         IF NOT cl_null(g_hrbp.hrbp01) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file
             WHERE hraa01=g_hrbp.hrbp01
               AND hraaacti='Y'
            IF l_n=0 THEN
            	 CALL cl_err("无此公司编号","!",0)
            	 NEXT FIELD hrbp01
            END IF
            
            SELECT hraa12 INTO l_hraa12 FROM hraa_file
             WHERE hraa01=g_hrbp.hrbp01
               AND hraaacti='Y'
            DISPLAY l_hraa12 TO hraa12   		    
         END IF
      
      #mod by zhangbo130528
      #新增自动编号,代码组'017'
      BEFORE FIELD hrbp02
         IF p_cmd='a' THEN
            IF cl_null(g_hrbp.hrbp02) AND NOT cl_null(g_hrbp.hrbp01) THEN
               LET l_hraa10=''
               SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=g_hrbp.hrbp01
               CALL hr_gen_no('hrbp_file','hrbp02','017',g_hrbp.hrbp01,l_hraa10) RETURNING g_hrbp.hrbp02,g_flag
               IF g_flag='Y' THEN
                  CALL cl_set_comp_entry("hrbp02",TRUE)
               ELSE
                  CALL cl_set_comp_entry("hrbp02",FALSE)
               END IF
            END IF
         END IF
         	
      AFTER FIELD hrbp02
         IF NOT cl_null(g_hrbp.hrbp02) THEN
         	  IF g_hrbp_t.hrbp02 != g_hrbp.hrbp02 
         	  	OR g_hrbp_t.hrbp02 IS NULL THEN
         	  	LET l_n=0
         	  	SELECT COUNT(*) INTO l_n FROM hrbp_file
         	  	 WHERE hrbp02=g_hrbp.hrbp02
         	  	IF l_n>0 THEN
         	  		 CALL cl_err("轮班编号不能重复","!",0)
         	  		 NEXT FIELD hrbp02
         	  	END IF
         	  END IF
         END IF
      
      AFTER FIELD hrbp03
         IF NOT cl_null(g_hrbp.hrbp03) THEN
         	  IF g_hrbp_t.hrbp03 != g_hrbp.hrbp03 
         	  	OR g_hrbp_t.hrbp03 IS NULL THEN
         	  	LET l_n=0
         	  	SELECT COUNT(*) INTO l_n FROM hrbp_file
         	  	 WHERE hrbp03=g_hrbp.hrbp03
         	  	IF l_n>0 THEN
         	  		 CALL cl_err("轮班名称不能重复","!",0)
         	  		 NEXT FIELD hrbp03
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
            WHEN INFIELD(hrbp01)     
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hraa01"
               LET g_qryparam.default1 = g_hrbp.hrbp01              
               CALL cl_create_qry() RETURNING g_hrbp.hrbp01              
               DISPLAY BY NAME g_hrbp.hrbp01
               NEXT FIELD hrbp01
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

FUNCTION i034_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrbpa.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i034_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hrbp.* TO NULL
      RETURN
   END IF
 
   OPEN i034_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrbp.* TO NULL
   ELSE
      OPEN i034_count
      FETCH i034_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i034_fetch('F')                  # 讀出TEMP第一筆并顯示
      CALL i034_b1_fill(g_wc,g_wc2)
   END IF
 
END FUNCTION
	
FUNCTION i034_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i034_cs INTO g_hrbp.hrbp02
      WHEN 'P' FETCH PREVIOUS i034_cs INTO g_hrbp.hrbp02
      WHEN 'F' FETCH FIRST    i034_cs INTO g_hrbp.hrbp02
      WHEN 'L' FETCH LAST     i034_cs INTO g_hrbp.hrbp02
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
            FETCH ABSOLUTE g_jump i034_cs INTO g_hrbp.hrbp02
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbp.hrbp02,SQLCA.sqlcode,0)
      INITIALIZE g_hrbp.* TO NULL
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
 
   SELECT * INTO g_hrbp.* FROM hrbp_file WHERE hrbp02 = g_hrbp.hrbp02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrbp_file",g_hrbp.hrbp02,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_hrbp.* TO NULL
      RETURN
   END IF
 
   CALL i034_show()
 
END FUNCTION	
	
FUNCTION i034_show()
DEFINE l_hraa12   LIKE    hraa_file.hraa12      #add by zhangbo130826
 
   LET g_hrbp_t.* = g_hrbp.*                #保存單頭舊值
   LET g_hrbp_o.* = g_hrbp.*                #保存單頭舊值
   DISPLAY BY NAME g_hrbp.hrbp01,g_hrbp.hrbp02,g_hrbp.hrbp03,
                   g_hrbp.hrbp05,g_hrbp.hrbp04,
                   g_hrbp.hrbpuser,g_hrbp.hrbpgrup,g_hrbp.hrbpmodu,
                   g_hrbp.hrbpdate,g_hrbp.hrbporiu,g_hrbp.hrbporig

   SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_hrbp.hrbp01     #add by zhangbo130826
   DISPLAY l_hraa12 TO hraa12                                                #add by zhangbo130826
 
   CALL i034_b_fill(g_wc2)
END FUNCTION
	
FUNCTION i034_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbp.hrbp02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_hrbp.* FROM hrbp_file
    WHERE hrbp02=g_hrbp.hrbp02
 
   BEGIN WORK
 
   OPEN i034_cl USING g_hrbp.hrbp02
   IF STATUS THEN
      CALL cl_err("OPEN i034_cl:", STATUS, 1)
      CLOSE i034_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i034_cl INTO g_hrbp.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbp.hrbp02,SQLCA.sqlcode,0)     # 資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i034_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "hrbp02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_hrbp.hrbp02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM hrbp_file WHERE hrbp02 = g_hrbp.hrbp02
      DELETE FROM hrbpa_file WHERE hrbpa05 = g_hrbp.hrbp02
      CLEAR FORM
      CALL g_hrbpa.clear()
      OPEN i034_count
      FETCH i034_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i034_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i034_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i034_fetch('/')
      END IF
   END IF
 
   CLOSE i034_cl
   COMMIT WORK
   CALL cl_flow_notify(g_hrbp.hrbp02,'D')
   CALL i034_b1_fill(g_wc,g_wc2)
END FUNCTION
	
FUNCTION i034_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT hrbpa01,hrbpa02,hrbpa03,hrbpa04 ",
               "  FROM hrbpa_file ",
               " WHERE hrbpa05 ='",g_hrbp.hrbp02,"' " 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY hrbpa01 "
 
   PREPARE i034_pb FROM g_sql
   DECLARE hrbpa_cs CURSOR FOR i034_pb
 
   CALL g_hrbpa.clear()
   LET g_cnt = 1
 
   FOREACH hrbpa_cs INTO g_hrbpa[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrbpa.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i034_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("hrbp02,hrbp05",TRUE)
    END IF
END FUNCTION
 
FUNCTION i034_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("hrbp02,hrbp05",FALSE)
    END IF
 
END FUNCTION
	
FUNCTION i034_b()
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
        
        IF cl_null(g_hrbp.hrbp02) THEN
           RETURN 
        END IF
        
        SELECT * INTO g_hrbp.* FROM hrbp_file
         WHERE hrbp02=g_hrbp.hrbp02
        
        CALL cl_opmsg('b')
        
        LET g_forupd_sql= "SELECT hrbpa01,hrbpa02,hrbpa03,hrbpa04 ",
                          "  FROM hrbpa_file ",
                          " WHERE hrbpa01 = ? ",
                          "   AND hrbpa05 = ? ",
                          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i034_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_hrbpa WITHOUT DEFAULTS FROM s_hrbpa.*
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
           OPEN i034_cl USING g_hrbp.hrbp02
           IF STATUS THEN
              CALL cl_err("OPEN i034_cl:",STATUS,1)
              CLOSE i034_cl
              ROLLBACK WORK
           END IF
           
           FETCH i034_cl INTO g_hrbp.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrbp.hrbp02,SQLCA.sqlcode,0)
              CLOSE i034_cl
              ROLLBACK WORK 
              RETURN
           END IF
           	
           IF g_rec_b>=l_ac THEN 
               LET p_cmd ='u'
               LET g_hrbpa_t.*=g_hrbpa[l_ac].*
               LET g_hrbpa_o.*=g_hrbpa[l_ac].*
               OPEN i034_bcl USING g_hrbpa_t.hrbpa01,g_hrbp.hrbp02
               IF STATUS THEN
                  CALL cl_err("OPEN i034_bcl:",STATUS,1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i034_bcl INTO g_hrbpa[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrbpa_t.hrbpa02,SQLCA.sqlcode,1)
                     LET l_lock_sw="Y"
                  END IF
                  	 	 	
               END IF
           END IF
       BEFORE INSERT
           LET l_n=ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_hrbpa[l_ac].* TO NULL
           LET g_hrbpa_t.*=g_hrbpa[l_ac].*  	 	     
           CALL cl_show_fld_cont()
           NEXT FIELD hrbpa01
                
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             CANCEL INSERT
          END IF
          INSERT INTO hrbpa_file(hrbpa01,hrbpa02,hrbpa03,
                      hrbpa04,hrbpa05)
             VALUES(g_hrbpa[l_ac].hrbpa01,g_hrbpa[l_ac].hrbpa02,
                    g_hrbpa[l_ac].hrbpa03,g_hrbpa[l_ac].hrbpa04,
                    g_hrbp.hrbp02)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","hrbpa_file",g_hrbp.hrbp02,g_hrbpa[l_ac].hrbpa01,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   MESSAGE 'INSERT O.K.'
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                
      BEFORE FIELD hrbpa01
        IF cl_null(g_hrbpa[l_ac].hrbpa01) OR g_hrbpa[l_ac].hrbpa01 = 0 THEN 
            SELECT MAX(hrbpa01)+1 INTO g_hrbpa[l_ac].hrbpa01
              FROM hrbpa_file
             WHERE hrbpa05 = g_hrbp.hrbp02
            IF g_hrbpa[l_ac].hrbpa01 IS NULL THEN
               LET g_hrbpa[l_ac].hrbpa01=1
            END IF
         END IF
         
      AFTER FIELD hrbpa01 #項次
        IF NOT cl_null(g_hrbpa[l_ac].hrbpa01) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_hrbpa[l_ac].hrbpa01 <> g_hrbpa_t.hrbpa01) THEN
              SELECT COUNT(*) INTO l_n FROM hrbpa_file
               WHERE hrbpa05 = g_hrbp.hrbp02
                 AND hrbpa01 = g_hrbpa[l_ac].hrbpa01
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_hrbpa[l_ac].hrbpa01=g_hrbpa_t.hrbpa01
                 NEXT FIELD hrbpa01
              END IF
           END IF
         END IF
       
       AFTER FIELD hrbpa02
          IF NOT cl_null(g_hrbpa[l_ac].hrbpa02) THEN
          	 LET l_n=0 
             IF g_hrbp.hrbp05='1' THEN       #按班次轮转    
                SELECT COUNT(*) INTO l_n FROM hrbo_file
                 WHERE hrbo02=g_hrbpa[l_ac].hrbpa02
                IF l_n=0 THEN
                	 CALL cl_err('无此班次编号','!',0)
                	 NEXT FIELD hrbpa02
                END IF
                
                SELECT hrbo03 INTO g_hrbpa[l_ac].hrbpa03
                  FROM hrbo_file
                 WHERE hrbo02=g_hrbpa[l_ac].hrbpa02
             ELSE                             #按班组轮转
             	  SELECT COUNT(*) INTO l_n FROM hrbz_file
                 WHERE hrbz02=g_hrbpa[l_ac].hrbpa02
                IF l_n=0 THEN
                	 CALL cl_err('无此班组编号','!',0)
                	 NEXT FIELD hrbpa02
                END IF
                
                SELECT hrbz03 INTO g_hrbpa[l_ac].hrbpa03
                  FROM hrbz_file
                 WHERE hrbz02=g_hrbpa[l_ac].hrbpa02 
             END IF
             
             DISPLAY BY NAME g_hrbpa[l_ac].hrbpa03		         		      
          END IF
 
       
         
       BEFORE DELETE                      
           IF g_hrbpa_t.hrbpa01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM hrbpa_file
               WHERE hrbpa05 = g_hrbp.hrbp02
                 AND hrbpa01 = g_hrbpa_t.hrbpa01
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","hrbpa_file",g_hrbp.hrbp02,g_hrbpa_t.hrbpa01,SQLCA.sqlcode,"","",1)  
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
              LET g_hrbpa[l_ac].* = g_hrbpa_t.*
              CLOSE i034_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_hrbpa[l_ac].hrbpa01,-263,1)
              LET g_hrbpa[l_ac].* = g_hrbpa_t.*
           ELSE
              UPDATE hrbpa_file SET hrbpa01 = g_hrbpa[l_ac].hrbpa01,
                                    hrbpa02 = g_hrbpa[l_ac].hrbpa02,
                                    hrbpa03 = g_hrbpa[l_ac].hrbpa03,
                                    hrbpa04 = g_hrbpa[l_ac].hrbpa04
                 WHERE hrbpa05 = g_hrbp.hrbp02
                   AND hrbpa01 = g_hrbpa_t.hrbpa01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","hrbpa_file",g_hrbp.hrbp02,g_hrbpa_t.hrbpa01,SQLCA.sqlcode,"","",1) 
                 LET g_hrbpa[l_ac].* = g_hrbpa_t.*
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
                 LET g_hrbpa[l_ac].* = g_hrbpa_t.*
              END IF
              CLOSE i034_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i034_bcl
           COMMIT WORK

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbpa02)
            CALL cl_init_qry_var()
            IF g_hrbp.hrbp05='1' THEN
               LET g_qryparam.form ="q_hrbo02"
            ELSE
            	 LET g_qryparam.form ="q_hrbz02"
            END IF
            LET g_qryparam.arg1 = g_hrbp.hrbp01 		     
            LET g_qryparam.default1 = g_hrbpa[l_ac].hrbpa02
            CALL cl_create_qry() RETURNING g_hrbpa[l_ac].hrbpa02
            DISPLAY BY NAME g_hrbpa[l_ac].hrbpa02
            NEXT FIELD hrbpa02
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

    CLOSE i034_bcl
    COMMIT WORK
    CALL i034_delall()
    CALL i034_show()
END FUNCTION 
 
FUNCTION i034_delall()
#刪除單頭資料
   SELECT COUNT(*) INTO g_cnt FROM hrbpa_file
    WHERE hrbpa05 = g_hrbp.hrbp02
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
 
      DELETE FROM hrbp_file
       WHERE hrbp02 = g_hrbp.hrbp02
      CLEAR FORM 
      INITIALIZE g_hrbp.* TO NULL
   END IF
END FUNCTION
	
FUNCTION i034_b1_fill(p_wc,p_wc2)
DEFINE p_wc     STRING
DEFINE p_wc2    STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5

  
        CALL g_hrbp_1.clear()
        
        
        IF p_wc2 = " 1=1" THEN 
           LET l_sql=" SELECT hrbp01,'',hrbp02,hrbp03,hrbp05,hrbp04",
                     "   FROM hrbp_file ",
                     "  WHERE ",p_wc CLIPPED,
                     "  ORDER BY hrbp02 "
        ELSE
        	 LET l_sql=" SELECT DISTINCT hrbp01,'',hrbp02,hrbp03,hrbp05,hrbp04",
                     "   FROM hrbp_file,hrbpa_file ",
                     "  WHERE hrbp02 = hrbpa05 ",
                     "    AND ", p_wc CLIPPED, " AND ",p_wc2 CLIPPED,
                     "  ORDER BY hrbp02" 
        END IF 
                            
        PREPARE i034_b1_pre FROM l_sql
        DECLARE i034_b1_cs CURSOR FOR i034_b1_pre
        
        LET l_i=1
        
        FOREACH i034_b1_cs INTO g_hrbp_1[l_i].*
        
           SELECT hraa12 INTO g_hrbp_1[l_i].hraa12 FROM hraa_file
            WHERE hraa01=g_hrbp_1[l_i].hrbp01
                            
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrbp_1.deleteElement(l_i)
        LET g_rec_b1 = l_i - 1

END FUNCTION

