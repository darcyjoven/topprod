# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri029.4gl
# Descriptions...: 考勤区间维护作业
# Date & Author..: 13/05/06 By yangjian

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_hrbl         RECORD LIKE hrbl_file.*,      
       g_hrbl_t       RECORD LIKE hrbl_file.*,      
       g_hrbl_o       RECORD LIKE hrbl_file.*,      
       g_hrbl02_t     LIKE hrbl_file.hrbl01,        
       g_hrbla         DYNAMIC ARRAY OF RECORD  
           hrbla01     LIKE hrbla_file.hrbla01,   
           hrbla03     LIKE hrbla_file.hrbla03,
           hrbla04     LIKE hrbla_file.hrbla04,
           hrbla05     LIKE hrbla_file.hrbla05,    
           hrbla06     LIKE hrbla_file.hrbla06  
                     END RECORD,
       g_hrbla_t       RECORD                     
           hrbla01     LIKE hrbla_file.hrbla01,   
           hrbla03     LIKE hrbla_file.hrbla03,
           hrbla04     LIKE hrbla_file.hrbla04, 
           hrbla05     LIKE hrbla_file.hrbla05,    
           hrbla06     LIKE hrbla_file.hrbla06    
                     END RECORD,
       g_hrbla_o       RECORD                     
           hrbla01     LIKE hrbla_file.hrbla01,   
           hrbla03     LIKE hrbla_file.hrbla03,
           hrbla04     LIKE hrbla_file.hrbla04,
           hrbla05     LIKE hrbla_file.hrbla05,    
           hrbla06     LIKE hrbla_file.hrbla06    
                     END RECORD,
       g_fill        DYNAMIC ARRAY OF RECORD
           hrbl01f      LIKE hrbl_file.hrbl01,
           hrbl01_namef LIKE type_file.chr100,
           hrbl02f      LIKE hrbl_file.hrbl02,
           hrbl03f      LIKE hrbl_file.hrbl03,
           hrbl04f      LIKE hrbl_file.hrbl04,
           hrbl05f      LIKE hrbl_file.hrbl05,
           hrbl06f      LIKE hrbl_file.hrbl06,
           hrbl07f      LIKE hrbl_file.hrbl07,
           hrbl08f      LIKE hrbl_file.hrbl08,
           hrbl09f      LIKE hrbl_file.hrbl09
                     END RECORD,
       g_filla        DYNAMIC ARRAY OF RECORD
           hrbla01f      LIKE hrbla_file.hrbla01,
           hrbla03f      LIKE hrbla_file.hrbla03,
           hrbla04f      LIKE hrbla_file.hrbla04,
           hrbla05f      LIKE hrbla_file.hrbla05,
           hrbla06f      LIKE hrbla_file.hrbla06
                     END RECORD,                     
       g_sql         STRING,                      
       g_wc          STRING,                      
       g_wc2         STRING,                      
       g_rec_b,g_rec_b2,g_rec_b3       LIKE type_file.num5,         
       l_ac          LIKE type_file.num5          
DEFINE g_forupd_sql        STRING                  
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1    
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5     
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10    
DEFINE g_jump              LIKE type_file.num10    
DEFINE g_no_ask            LIKE type_file.num5     
DEFINE g_str               STRING
DEFINE g_buf               STRING
DEFINE g_argv1             LIKE hrbl_file.hrbl02
 
MAIN

      OPTIONS                       
         INPUT NO WRAP
      DEFER INTERRUPT               
 
   LET g_argv1=ARG_VAL(1)           

   IF (NOT cl_user()) THEN          
      EXIT PROGRAM                  
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     
 
   IF (NOT cl_setup("GHR")) THEN          
      EXIT PROGRAM                        
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)
 
   LET g_forupd_sql = "SELECT * FROM hrbl_file WHERE hrbl02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i029_cl CURSOR FROM g_forupd_sql                 #單頭Lock Cursor
 
   OPEN WINDOW i029_w WITH FORM "ghr/42f/ghri029"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()                               #轉換介面語言別、匯入ToolBar、Action...等資訊
   CALL cl_set_label_justify("i029_w","right")
   CALL i029_menu()                                   #進入主視窗選單
   CLOSE WINDOW i029_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
FUNCTION i029_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL g_hrbla.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " hrbl02 = ",g_argv1
   ELSE
      CALL cl_set_head_visible("","YES")           #設定單頭為顯示狀態
      INITIALIZE g_hrbl.* TO NULL    
      CONSTRUCT BY NAME g_wc ON hrbl01,hrbl02,hrbl03,hrbl04,hrbl05,hrbl06, 
                                hrbl07,hrbl08,hrbl09,
                                hrblud01,hrblud02,hrblud03,hrblud04,hrblud05,
                                hrblud06,hrblud07,hrblud08,hrblud09,hrblud10,
                                hrblud11,hrblud12,hrblud13,hrblud14,hrblud15,
                                hrbluser,hrblgrup,hrblmodu,hrbldate,hrblacti,
                                hrbloriu,hrblorig    #TQC-B80232  add
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(hrbl01) #公司名称   
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_hraa01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrbl01
                  NEXT FIELD hrbl01
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds                         #每個交談指令必備以下四個功能
            CALL cl_on_idle()                           #idle、about、help、controlg
            CONTINUE CONSTRUCT
      
         ON ACTION about       
            CALL cl_about()   
      
         ON ACTION help         
            CALL cl_show_help() 
      
         ON ACTION controlg    
            CALL cl_cmdask()
      
         ON ACTION qbe_select                           #查詢提供條件選擇，選擇後直接帶入畫面
            CALL cl_qbe_list() RETURNING lc_qbe_sn      #提供列表選擇
            CALL cl_qbe_display_condition(lc_qbe_sn)    #顯示條件
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbluser', 'hrblgrup')
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON hrbla01,hrbla03,hrbla04,
                         hrbla05,hrbla06
              FROM s_hrbla[1].hrbla01,s_hrbla[1].hrbla03,s_hrbla[1].hrbla04,
                   s_hrbla[1].hrbla05,s_hrbla[1].hrbla06
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)    #再次顯示查詢條件，因為進入單身後會將原顯示值清空
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
         ON ACTION qbe_save                       #條件儲存
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  hrbl02 FROM hrbl_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY hrbl01,hrbl04,hrbl05"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE hrbl_file.hrbl02 ",
                  "  FROM hrbl_file, hrbla_file ",
                  " WHERE hrbl02 = hrbla02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY hrbl01,hrbl04,hrbl05"
   END IF
 
   PREPARE i029_prepare FROM g_sql
   DECLARE i029_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i029_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM hrbl_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT hrbl02) FROM hrbl_file,hrbla_file WHERE ",
                "hrbla02=hrbl02 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i029_precount FROM g_sql
   DECLARE i029_count CURSOR FOR i029_precount
 
END FUNCTION
 
FUNCTION i029_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
      CALL i029_bp("G")
       
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i029_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i029_q()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i029_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i029_x()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i029_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "detailb"
            IF cl_chk_act_auth() THEN
               SELECT * INTO g_hrbl.* FROM hrbl_file
                WHERE hrbl02 = g_fill[l_ac].hrbl02f
               CALL i029_show()
            END IF 
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbla),'','')
            END IF

         WHEN "related_document"                    #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_hrbl.hrbl02 IS NOT NULL THEN
                 LET g_doc.column1 = "hrbl02"
                 LET g_doc.value1 = g_hrbl.hrbl02
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i029_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_hrbla TO s_hrbla.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         
         BEFORE ROW                                                     
            LET l_ac = ARR_CURR()                                       
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             
         AFTER DISPLAY
           CONTINUE DIALOG

      END DISPLAY 
      
      DISPLAY ARRAY g_fill TO s_fill.* 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         
         BEFORE ROW                                                     
            LET l_ac = ARR_CURR()                                       
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf      
            CALL i029_d_fill(g_fill[l_ac].hrbl02f)
      END DISPLAY
      
      DISPLAY ARRAY g_filla TO s_filla.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         
      END DISPLAY 
   
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
 
      ON ACTION first
         CALL i029_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i029_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   #FUN-530067(smin)
 
      ON ACTION jump
         CALL i029_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   #FUN-530067(smin)
 
      ON ACTION next
         CALL i029_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   #FUN-530067(smin)
 
      ON ACTION last
         CALL i029_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   #FUN-530067(smin)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG

      ON ACTION detailb
         LET g_action_choice="detailb"
         LET l_ac = ARR_CURR()
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                    #畫面上欄位的工具提示轉換語言別
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE                         #利用單身驅動menu時，cancel代表右上角的"X"
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION exporttoexcel                       #匯出Excel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION controls                            #單頭摺疊，可利用hot key "Ctrl-s"開啟/關閉單頭區塊
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                    #相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
END FUNCTION
 
FUNCTION i029_bp_refresh()
  DISPLAY ARRAY g_hrbla TO s_hrbla.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION i029_a()
   DEFINE li_result   LIKE type_file.num5  
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_hrbla.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_hrbl.* LIKE hrbl_file.*             #DEFAULT 設定
   LET g_hrbl02_t = NULL

   LET g_hrbl_t.* = g_hrbl.*
   LET g_hrbl_o.* = g_hrbl.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrbl.hrbluser=g_user
      LET g_hrbl.hrbloriu = g_user #FUN-980030
      LET g_hrbl.hrblorig = g_grup #FUN-980030
      LET g_hrbl.hrblgrup=g_grup
      LET g_hrbl.hrbldate=g_today
      LET g_hrbl.hrblacti='Y'   
      LET g_hrbl.hrbl08 = 'N'       
 
      CALL i029_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_hrbl.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      SELECT g_hrbl.hrbl04||'-'||g_hrbl.hrbl05||'('||hraa12||')' INTO g_hrbl.hrbl03
        FROM hraa_file
       WHERE hraa01 = g_hrbl.hrbl01
      DISPLAY BY NAME g_hrbl.hrbl03    
      
      SELECT MAX(hrbl02)+1 INTO g_hrbl.hrbl02 FROM hrbl_file
      IF g_hrbl.hrbl02 IS NULL OR g_hrbl.hrbl02=0 THEN LET g_hrbl.hrbl02 = 1 END IF 
      
      IF cl_null(g_hrbl.hrbl02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF

      DISPLAY BY NAME g_hrbl.hrbl02
 
      INSERT INTO hrbl_file VALUES (g_hrbl.*)

      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         CALL cl_err3("ins","hrbl_file",g_hrbl.hrbl02,"",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                    #新增成功後，若有設定流程通知
         CALL cl_flow_notify(g_hrbl.hrbl02,'I')           #則增加訊息到udm7主畫面上或使用者信箱
      END IF                                            #此功能適用單據程式
 
      SELECT hrbl02 INTO g_hrbl.hrbl02 FROM hrbl_file WHERE hrbl02 = g_hrbl.hrbl02

      LET g_hrbl02_t = g_hrbl.hrbl02                       #保留舊值
      LET g_hrbl_t.* = g_hrbl.*
      LET g_hrbl_o.* = g_hrbl.*
      CALL g_hrbla.clear()
      LET g_rec_b = 0  

      LET g_hrbla[1].hrbla01 = 1
      LET g_hrbla[1].hrbla03 = 'N'
      LET g_hrbla[1].hrbla04 = g_hrbl.hrbl06
      LET g_hrbla[1].hrbla05 = g_hrbl.hrbl07
      INSERT INTO hrbla_file(hrbla01,hrbla02,hrbla03,hrbla04,hrbla05) 
             VALUES (g_hrbla[1].hrbla01,g_hrbl.hrbl02,g_hrbla[1].hrbla03,
                     g_hrbla[1].hrbla04,g_hrbla[1].hrbla05) 
      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         CALL cl_err3("ins","hrbla_file",g_hrbl.hrbl02,"",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
         CALL g_hrbla.clear()
      ELSE 
         LET g_rec_b = 1
      END IF 
      CALL i029_b()                                     #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i029_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbl.hrbl02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_hrbl.* FROM hrbl_file
    WHERE hrbl02=g_hrbl.hrbl02
 
   IF g_hrbl.hrblacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrbl.hrbl02,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrbl02_t = g_hrbl.hrbl02
   BEGIN WORK
 
   OPEN i029_cl USING g_hrbl.hrbl02
   IF STATUS THEN
      CALL cl_err("OPEN i029_cl:", STATUS, 1)
      CLOSE i029_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i029_cl INTO g_hrbl.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbl.hrbl02,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i029_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i029_show()
 
   WHILE TRUE
      LET g_hrbl02_t = g_hrbl.hrbl02
      LET g_hrbl_o.* = g_hrbl.*
      LET g_hrbl.hrblmodu=g_user
      LET g_hrbl.hrbldate=g_today
 
      CALL i029_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_hrbl.*=g_hrbl_t.*
         CALL i029_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE hrbl_file SET hrbl_file.* = g_hrbl.*
       WHERE hrbl02 = g_hrbl.hrbl02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","hrbl_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i029_cl
   COMMIT WORK
   CALL cl_flow_notify(g_hrbl.hrbl02,'U')
 
   CALL i029_b_fill("1=1")
   CALL i029_bp_refresh()
 
END FUNCTION
 

FUNCTION i029_i(p_cmd)

   DEFINE l_pmc05     LIKE pmc_file.pmc05
   DEFINE l_pmc30     LIKE pmc_file.pmc30
   DEFINE l_n         LIKE type_file.num5    
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改  
   DEFINE li_result   LIKE type_file.num5    
   DEFINE l_error     BOOLEAN
   DEFINE l_ym        LIKE type_file.num10
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_hrbl.hrbluser,g_hrbl.hrblmodu,g_hrbl.hrblgrup,g_hrbl.hrbldate,g_hrbl.hrblacti,
                   g_hrbl.hrbloriu,g_hrbl.hrblorig,
                   g_hrbl.hrbl08
 
   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_hrbl.hrbl01,g_hrbl.hrbl02,g_hrbl.hrbl03,g_hrbl.hrbl04,g_hrbl.hrbl05,
                 g_hrbl.hrbl06,g_hrbl.hrbl07,g_hrbl.hrbl08,g_hrbl.hrbl09,
                 g_hrbl.hrblud01,g_hrbl.hrblud02,g_hrbl.hrblud03,g_hrbl.hrblud04,g_hrbl.hrblud05,
                 g_hrbl.hrblud06,g_hrbl.hrblud07,g_hrbl.hrblud08,g_hrbl.hrblud09,g_hrbl.hrblud10,
                 g_hrbl.hrblud11,g_hrbl.hrblud12,g_hrbl.hrblud13,g_hrbl.hrblud14,g_hrbl.hrblud15
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i029_set_entry(p_cmd)
         CALL i029_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD hrbl01
         IF NOT cl_null(g_hrbl.hrbl01) THEN
         	 IF g_hrbl.hrbl01 != g_hrbl_t.hrbl01 OR g_hrbl_t.hrbl01 IS NULL THEN 
              CALL i029_hrbl01('a')
              IF NOT cl_null(g_errno) THEN
              	 CALL cl_err('',g_errno,0)
              	 NEXT FIELD hrbl01
              END IF
              IF cl_null(g_hrbl.hrbl04) AND cl_null(g_hrbl.hrbl05) THEN
              	 LET l_ym = NULL
              	 SELECT MAX(hrbl07)+1 INTO g_hrbl.hrbl06 FROM hrbl_file
              	  WHERE hrbl01 = g_hrbl.hrbl01
                 SELECT MAX(hrbl04*12+hrbl05) INTO l_ym FROM hrbl_file 
                  WHERE hrbl01 = g_hrbl.hrbl01
              	 IF NOT cl_null(l_ym) THEN
              	    LET l_ym = l_ym + 1 
                    LET g_hrbl.hrbl05 = l_ym MOD 12
                    IF g_hrbl.hrbl05 = 0 THEN LET g_hrbl.hrbl05 = 12 END IF 
                    LET g_hrbl.hrbl04 = (l_ym - g_hrbl.hrbl05)/12
              	    DISPLAY BY NAME g_hrbl.hrbl04,g_hrbl.hrbl05,g_hrbl.hrbl06
                 END IF 
              END IF 
              SELECT COUNT(*) INTO l_n FROM hrbl_file 
               WHERE hrbl01 = g_hrbl.hrbl01
                 AND hrbl04 = g_hrbl.hrbl04
                 AND hrbl05 = g_hrbl.hrbl05
              IF l_n > 0 THEN
              	 CALL cl_err('',-239,0)
              	 NEXT FIELD hrbl01
              END IF
           END IF 
         END IF
 
      AFTER FIELD hrbl04                  #年度
         IF NOT cl_null(g_hrbl.hrbl04) THEN
         	 IF g_hrbl.hrbl04 != g_hrbl_t.hrbl04 OR g_hrbl_t.hrbl04 IS NULL THEN   	
               IF g_hrbl.hrbl04 >2999 OR g_hrbl.hrbl04 < 2000 THEN
                  CALL cl_err('','ghr-055',0)
                  NEXT FIELD hrbl04
               END IF  
               SELECT COUNT(*) INTO l_n FROM hrbl_file 
                WHERE hrbl01 = g_hrbl.hrbl01
                  AND hrbl04 = g_hrbl.hrbl04
                  AND hrbl05 = g_hrbl.hrbl05
               IF l_n > 0 THEN
               	 CALL cl_err('',-239,0)
               	 NEXT FIELD hrbl04
               END IF           
            END IF                         
         END IF
         
      AFTER FIELD hrbl05                  #月度
         IF NOT cl_null(g_hrbl.hrbl05) THEN
         	 IF g_hrbl.hrbl05 != g_hrbl_t.hrbl05 OR g_hrbl_t.hrbl05 IS NULL THEN       	
               IF g_hrbl.hrbl05 >13 OR g_hrbl.hrbl05 < 1 THEN
                  CALL cl_err('','aom-580',0)
                  NEXT FIELD hrbl05
               END IF 
               SELECT COUNT(*) INTO l_n FROM hrbl_file 
                WHERE hrbl01 = g_hrbl.hrbl01
                  AND hrbl04 = g_hrbl.hrbl04
                  AND hrbl05 = g_hrbl.hrbl05
               IF l_n > 0 THEN
               	 CALL cl_err('',-239,0)
               	 NEXT FIELD hrbl05
               END IF               
            END IF             
         END IF
         
      AFTER FIELD hrbl06                  #开始日期
         IF NOT cl_null(g_hrbl.hrbl06) AND NOT cl_null(g_hrbl.hrbl07) THEN
         	  CALL i029_hrbl06() RETURNING l_error
         	  IF NOT cl_null(g_errno) THEN
         	  	 CALL cl_err('',g_errno,1)
         	  	 IF l_error THEN 
         	  	   NEXT FIELD hrbl06
         	  	 ELSE
         	     END IF 
         	   END IF 
         END IF  
         
      AFTER FIELD hrbl07                  #结束日期
         IF NOT cl_null(g_hrbl.hrbl07) AND NOT cl_null(g_hrbl.hrbl06) THEN
         	  CALL i029_hrbl06() RETURNING l_error
         	  IF NOT cl_null(g_errno) THEN
         	  	 CALL cl_err('',g_errno,1)
         	  	 IF l_error THEN 
         	  	   NEXT FIELD hrbl07
         	  	 ELSE
         	     END IF 
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
            WHEN INFIELD(hrbl01) #幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.default1 = g_hrbl.hrbl01
               CALL cl_create_qry() RETURNING g_hrbl.hrbl01
               DISPLAY BY NAME g_hrbl.hrbl01
               CALL i029_hrbl01('d')
               NEXT FIELD hrbl01
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
 
FUNCTION i029_hrbl01(p_cmd) 
   DEFINE l_hraa12  LIKE hraa_file.hraa12,
          l_hraaacti  LIKE hraa_file.hraaacti,
          p_cmd     LIKE type_file.chr1 
 
   LET g_errno = ' '
   SELECT hraa12,hraaacti
     INTO l_hraa12,l_hraaacti
     FROM hraa_file WHERE hraa01 = g_hrbl.hrbl01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ghr-001'
                                  LET l_hraa12 = NULL
        WHEN l_hraaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_hraa12 TO FORMONLY.hrbl01_name
   END IF
 
END FUNCTION


FUNCTION i029_hrbl06()
 DEFINE l_n  LIKE type_file.num5
    
   LET g_errno = ''  
   IF g_hrbl.hrbl06 > g_hrbl.hrbl07 THEN 
   	 LET g_errno = 'alm-402'
   	 RETURN TRUE
   END IF 
   IF g_hrbl.hrbl07 - g_hrbl.hrbl06 > 31 THEN
   	 LET g_errno = 'ghr-056'
   	#RETURN FALSE
   END IF 
   SELECT COUNT(*) INTO l_n FROM hrbl_file
    WHERE ((hrbl06 BETWEEN g_hrbl.hrbl06 AND g_hrbl.hrbl07) OR 
           (hrbl07 BETWEEN g_hrbl.hrbl06 AND g_hrbl.hrbl07) OR
           (hrbl06 <= g_hrbl.hrbl06 AND hrbl07 >= g_hrbl.hrbl07))
      AND hrbl01 = g_hrbl.hrbl01
      AND hrbl02 != g_hrbl.hrbl02
   IF l_n > 0 THEN 
         IF g_errno IS NULL THEN 
   	    LET g_errno = 'ghr-057'
         END IF 
         LET g_hrbl.hrbl09 = cl_getmsg('ghr-057',g_lang)
         DISPLAY BY NAME g_hrbl.hrbl09
   	 RETURN FALSE 
   ELSE 
         LET g_hrbl.hrbl09 = NULL
         DISPLAY BY NAME g_hrbl.hrbl09
   	 RETURN FALSE 
   END IF
   RETURN TRUE
END FUNCTION

 
FUNCTION i029_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrbla.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i029_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hrbl.* TO NULL
      RETURN
   END IF
 
   OPEN i029_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrbl.* TO NULL
   ELSE
      OPEN i029_count
      FETCH i029_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i029_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i029_fetch(p_flag)

   DEFINE p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i029_cs INTO g_hrbl.hrbl02
      WHEN 'P' FETCH PREVIOUS i029_cs INTO g_hrbl.hrbl02
      WHEN 'F' FETCH FIRST    i029_cs INTO g_hrbl.hrbl02
      WHEN 'L' FETCH LAST     i029_cs INTO g_hrbl.hrbl02
      WHEN '/'
            IF (NOT g_no_ask) THEN      #No.FUN-6A0067
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump i029_cs INTO g_hrbl.hrbl02
            LET g_no_ask = FALSE     #No.FUN-6A0067
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbl.hrbl02,SQLCA.sqlcode,0)
      INITIALIZE g_hrbl.* TO NULL               #No.FUN-6A0162
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
      DISPLAY g_curs_index TO FORMONLY.idx                    #No.FUN-4A0089
   END IF
 
   SELECT * INTO g_hrbl.* FROM hrbl_file WHERE hrbl02 = g_hrbl.hrbl02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrbl_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_hrbl.* TO NULL
      RETURN
   END IF
 
   CALL i029_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i029_show()
 
   LET g_hrbl_t.* = g_hrbl.*                #保存單頭舊值
   LET g_hrbl_o.* = g_hrbl.*                #保存單頭舊值
   DISPLAY BY NAME g_hrbl.hrbloriu,g_hrbl.hrblorig,              #FUN-650191
                   g_hrbl.hrbluser,g_hrbl.hrblgrup,g_hrbl.hrblmodu,
                   g_hrbl.hrbldate,g_hrbl.hrblacti,
                   g_hrbl.hrbl01,g_hrbl.hrbl02,g_hrbl.hrbl03,g_hrbl.hrbl04,g_hrbl.hrbl05,
                   g_hrbl.hrbl06,g_hrbl.hrbl07,g_hrbl.hrbl08,g_hrbl.hrbl09,
                   g_hrbl.hrblud01,g_hrbl.hrblud02,g_hrbl.hrblud03,g_hrbl.hrblud04,g_hrbl.hrblud05,
                   g_hrbl.hrblud06,g_hrbl.hrblud07,g_hrbl.hrblud08,g_hrbl.hrblud09,g_hrbl.hrblud10,
                   g_hrbl.hrblud11,g_hrbl.hrblud12,g_hrbl.hrblud13,g_hrbl.hrblud14,g_hrbl.hrblud15
 
   CALL i029_hrbl01('d')
   CALL i029_b_fill(g_wc2)                 #單身
   CALL i029_c_fill()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i029_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbl.hrbl02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i029_cl USING g_hrbl.hrbl02
   IF STATUS THEN
      CALL cl_err("OPEN i029_cl:", STATUS, 1)
      CLOSE i029_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i029_cl INTO g_hrbl.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbl.hrbl02,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i029_show()
 
   IF cl_exp(0,0,g_hrbl.hrblacti) THEN                   #確認一下
      LET g_chr=g_hrbl.hrblacti
      IF g_hrbl.hrblacti='Y' THEN
         LET g_hrbl.hrblacti='N'
      ELSE
         LET g_hrbl.hrblacti='Y'
      END IF
 
      UPDATE hrbl_file SET hrblacti=g_hrbl.hrblacti,
                          hrblmodu=g_user,
                          hrbldate=g_today
       WHERE hrbl02=g_hrbl.hrbl02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","hrbl_file",g_hrbl.hrbl02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_hrbl.hrblacti=g_chr
      END IF
   END IF
 
   CLOSE i029_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_hrbl.hrbl02,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT hrblacti,hrblmodu,hrbldate
     INTO g_hrbl.hrblacti,g_hrbl.hrblmodu,g_hrbl.hrbldate FROM hrbl_file
    WHERE hrbl02=g_hrbl.hrbl02
   DISPLAY BY NAME g_hrbl.hrblacti,g_hrbl.hrblmodu,g_hrbl.hrbldate
 
END FUNCTION
 

#單身
FUNCTION i029_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_n1            LIKE type_file.num5,        
    l_n2            LIKE type_file.num5,        
    l_n3            LIKE type_file.num5,         
    l_cnt           LIKE type_file.num5,                #檢查重複用 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_allow_insert  LIKE type_file.num5,                #可新增否  
    l_allow_delete  LIKE type_file.num5,                #可刪除否  
    l_pmc05         LIKE pmc_file.pmc05,   
    l_pmc30         LIKE pmc_file.pmc30   
DEFINE  i        LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_hrbl.hrbl02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_hrbl.* FROM hrbl_file
     WHERE hrbl02=g_hrbl.hrbl02
 
    IF g_hrbl.hrblacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_hrbl.hrbl02,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT hrbla01,hrbla03,hrbla04,hrbla05,hrbla06 ",
                       "  FROM hrbla_file",
                       "  WHERE hrbla01=? AND hrbla02=? ",
                       "    FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i029_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_hrbla WITHOUT DEFAULTS FROM s_hrbla.*
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
 
           OPEN i029_cl USING g_hrbl.hrbl02
           IF STATUS THEN
              CALL cl_err("OPEN i029_cl:", STATUS, 1)
              CLOSE i029_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i029_cl INTO g_hrbl.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrbl.hrbl02,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i029_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_hrbla_t.* = g_hrbla[l_ac].*  #BACKUP
              LET g_hrbla_o.* = g_hrbla[l_ac].*  #BACKUP
              OPEN i029_bcl USING g_hrbla_t.hrbla01,g_hrbl.hrbl02
              IF STATUS THEN
                 CALL cl_err("OPEN i029_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i029_bcl INTO g_hrbla[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_hrbl.hrbl02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              CALL i029_set_entry_b(p_cmd)    #No.FUN-610018
              CALL i029_set_no_entry_b(p_cmd) #No.FUN-610018
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_hrbla[l_ac].* TO NULL      #900423
           LET g_hrbla[l_ac].hrbla03 = 'Y'
           LET g_hrbla_t.* = g_hrbla[l_ac].*         #新輸入資料
           LET g_hrbla_o.* = g_hrbla[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()         #FUN-550037(smin)
           CALL i029_set_entry_b(p_cmd)    #No.FUN-610018
           CALL i029_set_no_entry_b(p_cmd) #No.FUN-610018
           NEXT FIELD hrbla01
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO hrbla_file(hrbla01,hrbla02,hrbla03,hrbla04,hrbla05,hrbla06)
           VALUES(g_hrbla[l_ac].hrbla01,g_hrbl.hrbl02,
                  g_hrbla[l_ac].hrbla03,g_hrbla[l_ac].hrbla04,
                  g_hrbla[l_ac].hrbla05,g_hrbla[l_ac].hrbla06)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrbla_file",g_hrbla[l_ac].hrbla01,g_hrbl.hrbl02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD hrbla01                        #default 序號
           IF g_hrbla[l_ac].hrbla01 IS NULL OR g_hrbla[l_ac].hrbla01 = 0 THEN
              SELECT max(hrbla01)+1
                INTO g_hrbla[l_ac].hrbla01
                FROM hrbla_file
               WHERE hrbla02 = g_hrbl.hrbl02
              IF g_hrbla[l_ac].hrbla01 IS NULL THEN
                 LET g_hrbla[l_ac].hrbla01 = 1
              END IF
           END IF
 
        AFTER FIELD hrbla01                        #check 序號是否重複
           IF NOT cl_null(g_hrbla[l_ac].hrbla01) THEN
              IF g_hrbla[l_ac].hrbla01 != g_hrbla_t.hrbla01
                 OR g_hrbla_t.hrbla01 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM hrbla_file
                  WHERE hrbla02 = g_hrbl.hrbl02
                    AND hrbla01 = g_hrbla[l_ac].hrbla01
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_hrbla[l_ac].hrbla01 = g_hrbla_t.hrbla01
                    NEXT FIELD hrbla01
                 END IF
              END IF
           END IF
        
        AFTER FIELD hrbla05
           IF NOT cl_null(g_hrbla[l_ac].hrbla05) THEN 
           	  IF g_hrbla[l_ac].hrbla05 != g_hrbla_t.hrbla05 OR g_hrbla_t.hrbla05 IS NULL THEN
           	     IF g_hrbla[l_ac].hrbla05 < g_hrbl.hrbl06 OR 
           	        g_hrbla[l_ac].hrbla05 > g_hrbl.hrbl07 THEN
           	        CALL cl_err('','ghr-059',1)
           	      END IF 
           	      IF g_hrbla[l_ac].hrbla04 > g_hrbla[l_ac].hrbla05 THEN 
           	      	 CALL cl_err('','alm-402',0)
           	      	 NEXT FIELD hrbla05
           	      END IF 
           	  END IF 
           END IF 
        
        AFTER FIELD hrbla04
           IF NOT cl_null(g_hrbla[l_ac].hrbla04) THEN 
           	  IF g_hrbla[l_ac].hrbla04 != g_hrbla_t.hrbla04 OR g_hrbla_t.hrbla04 IS NULL THEN
           	     IF g_hrbla[l_ac].hrbla04 < g_hrbl.hrbl06 OR 
           	        g_hrbla[l_ac].hrbla04 > g_hrbl.hrbl07 THEN
           	        CALL cl_err('','ghr-058',1)
           	      END IF 
           	      IF g_hrbla[l_ac].hrbla04 > g_hrbla[l_ac].hrbla05 THEN 
           	      	 CALL cl_err('','alm-402',0)
           	      	 NEXT FIELD hrbla04
           	      END IF            	      
           	  END IF 
           END IF         
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_hrbla_t.hrbla01 > 0 AND g_hrbla_t.hrbla01 IS NOT NULL THEN
              IF g_hrbla_t.hrbla01 = 1 THEN
              	 CALL cl_err('cancel delete','!',0)
              	 CANCEL DELETE 
              END IF            	
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF

              DELETE FROM hrbla_file
               WHERE hrbla02 = g_hrbl.hrbl02
                 AND hrbla01 = g_hrbla_t.hrbla01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hrbla_file",g_hrbl.hrbl02,g_hrbla_t.hrbla01,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_hrbla[l_ac].* = g_hrbla_t.*
              CLOSE i029_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_hrbla[l_ac].hrbla01,-263,1)
              LET g_hrbla[l_ac].* = g_hrbla_t.*
           ELSE
              UPDATE hrbla_file SET hrbla01=g_hrbla[l_ac].hrbla01,
                                  hrbla03=g_hrbla[l_ac].hrbla03,
                                  hrbla04=g_hrbla[l_ac].hrbla04,
                                  hrbla05=g_hrbla[l_ac].hrbla05,
                                  hrbla06=g_hrbla[l_ac].hrbla06
               WHERE hrbla02=g_hrbl.hrbl02
                 AND hrbla01=g_hrbla_t.hrbla01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","hrbla_file",g_hrbl.hrbl02,g_hrbla_t.hrbla01,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_hrbla[l_ac].* = g_hrbla_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_hrbla[l_ac].* = g_hrbla_t.*
              END IF
              CLOSE i029_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i029_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(hrbla02) AND l_ac > 1 THEN
              LET g_hrbla[l_ac].* = g_hrbla[l_ac-1].*
              LET g_hrbla[l_ac].hrbla01 = g_rec_b + 1
              NEXT FIELD hrbla01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_hrbl.hrblmodu = g_user
    LET g_hrbl.hrbldate = g_today
    UPDATE hrbl_file SET hrblmodu = g_hrbl.hrblmodu,hrbldate = g_hrbl.hrbldate
     WHERE hrbl02 = g_hrbl.hrbl02
    DISPLAY BY NAME g_hrbl.hrblmodu,g_hrbl.hrbldate
 
    CLOSE i029_bcl
    COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i029_b_askkey()
 
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON hrbla01,hrbla03,hrbla04,
                       hrbla05,hrbla06
            FROM s_hrbla[1].hrbla01,s_hrbla[1].hrbla03,s_hrbla[1].hrbla04,
                 s_hrbla[1].hrbla05,s_hrbla[1].hrbla06
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
 
    CALL i029_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i029_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT hrbla01,hrbla03,hrbla04,hrbla05,hrbla06 ",
               "  FROM hrbla_file",  
               " WHERE hrbla02 ='",g_hrbl.hrbl02,"' "  
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY hrbla02,hrbla01 "
   DISPLAY g_sql
 
   PREPARE i029_pb FROM g_sql
   DECLARE hrbla_cs CURSOR FOR i029_pb
 
   CALL g_hrbla.clear()
   LET g_cnt = 1
 
   FOREACH hrbla_cs INTO g_hrbla[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrbla.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

FUNCTION i029_c_fill()

  LET g_cnt = 1 
  CALL g_fill.clear()
  LET g_sql = "SELECT hrbl01,hraa12,hrbl02,hrbl03,hrbl04,hrbl05,",
              "       hrbl06,hrbl07,hrbl08,hrbl09 ",
              "  FROM hrbl_file,hraa_file",
              " WHERE hrbl01 = hraa01(+) ",
              " ORDER BY hrbl01,hrbl02 "
  PREPARE i029_c_prep FROM g_sql
  DECLARE i029_c_cs CURSOR FOR i029_c_prep
  FOREACH i029_c_cs INTO g_fill[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL i029_hrbl01('d')
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF         
  END FOREACH 
  CALL g_fill.deleteElement(g_cnt)
  LET g_rec_b2=g_cnt-1
  
  DISPLAY g_rec_b2 TO FORMONLY.cn3
  LET g_cnt = 0
   
END FUNCTION

FUNCTION i029_d_fill(p_hrbla02)
DEFINE p_hrbla02   LIKE hrbla_file.hrbla02
 
   LET g_sql = "SELECT hrbla01,hrbla03,hrbla04,hrbla05,hrbla06 ",
               "  FROM hrbla_file",  
               " WHERE hrbla02 ='",p_hrbla02,"' ",
               " ORDER BY hrbla02,hrbla01 "
   PREPARE i029_pb2 FROM g_sql
   DECLARE hrbla_cs2 CURSOR FOR i029_pb2
 
   CALL g_filla.clear()
   LET g_cnt = 1
   FOREACH hrbla_cs2 INTO g_filla[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_filla.deleteElement(g_cnt)
 
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cn4
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i029_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("hrbl01,hrbl04,hrbl05",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i029_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    CALL cl_set_comp_entry("hrbl02,hrbl03",FALSE)
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("hrbl01,hrbl04,hrbl05",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i029_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'a' THEN 
#    	 CALL cl_set_comp_entry("hrbla01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i029_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    CALL cl_set_comp_entry("hrbla01",FALSE)
    IF p_cmd = 'u' THEN 
#    	 CALL cl_set_comp_entry("hrbla01",FALSE)
    END IF 
END FUNCTION
