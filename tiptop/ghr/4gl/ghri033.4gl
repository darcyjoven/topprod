# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri033.4gl
# Descriptions...: 
# Date & Author..: 05/13/13 by lijun

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrbo               RECORD LIKE hrbo_file.*     
DEFINE g_hrbo_t             RECORD LIKE hrbo_file.*  
DEFINE g_hrbo_o             RECORD LIKE hrbo_file.* 
DEFINE g_hrbo02_t           LIKE hrbo_file.hrbo02
DEFINE g_hrboa     DYNAMIC ARRAY OF RECORD
         hrboa15   LIKE hrboa_file.hrboa15, 
         hrboa01   LIKE hrboa_file.hrboa01,
         hrboa02   LIKE hrboa_file.hrboa02,
         hrboa03   LIKE hrboa_file.hrboa03,
         hrboa04   LIKE hrboa_file.hrboa04,
         hrboa05   LIKE hrboa_file.hrboa05,
         hrboa06   LIKE hrboa_file.hrboa06,
         hrboa07   LIKE hrboa_file.hrboa07,
         hrboa08   LIKE hrboa_file.hrboa08,
         hrag07_1  LIKE hrag_file.hrag07,
         hrboa09   LIKE hrboa_file.hrboa09,
         hrag07_2  LIKE hrag_file.hrag07,
         hrboa10   LIKE hrboa_file.hrboa10,
         hrboa11   LIKE hrboa_file.hrboa11,
         hrboa12   LIKE hrboa_file.hrboa12,
         hrboa13   LIKE hrboa_file.hrboa13,
         hrboa14   LIKE hrboa_file.hrboa14
                   END RECORD
DEFINE g_hrboa_t   RECORD
         hrboa15   LIKE hrboa_file.hrboa15, 
         hrboa01   LIKE hrboa_file.hrboa01,
         hrboa02   LIKE hrboa_file.hrboa02,
         hrboa03   LIKE hrboa_file.hrboa03,
         hrboa04   LIKE hrboa_file.hrboa04,
         hrboa05   LIKE hrboa_file.hrboa05,
         hrboa06   LIKE hrboa_file.hrboa06,
         hrboa07   LIKE hrboa_file.hrboa07,
         hrboa08   LIKE hrboa_file.hrboa08,
         hrag07_1  LIKE hrag_file.hrag07,
         hrboa09   LIKE hrboa_file.hrboa09,
         hrag07_2  LIKE hrag_file.hrag07,
         hrboa10   LIKE hrboa_file.hrboa10,
         hrboa11   LIKE hrboa_file.hrboa11,
         hrboa12   LIKE hrboa_file.hrboa12,
         hrboa13   LIKE hrboa_file.hrboa13,
         hrboa14   LIKE hrboa_file.hrboa14
                           END RECORD
DEFINE g_hrboa_o   RECORD
         hrboa15   LIKE hrboa_file.hrboa15, 
         hrboa01   LIKE hrboa_file.hrboa01,
         hrboa02   LIKE hrboa_file.hrboa02,
         hrboa03   LIKE hrboa_file.hrboa03,
         hrboa04   LIKE hrboa_file.hrboa04,
         hrboa05   LIKE hrboa_file.hrboa05,
         hrboa06   LIKE hrboa_file.hrboa06,
         hrboa07   LIKE hrboa_file.hrboa07,
         hrboa08   LIKE hrboa_file.hrboa08,
         hrag07_1  LIKE hrag_file.hrag07,
         hrboa09   LIKE hrboa_file.hrboa09,
         hrag07_2  LIKE hrag_file.hrag07,
         hrboa10   LIKE hrboa_file.hrboa10,
         hrboa11   LIKE hrboa_file.hrboa11,
         hrboa12   LIKE hrboa_file.hrboa12,
         hrboa13   LIKE hrboa_file.hrboa13,
         hrboa14   LIKE hrboa_file.hrboa14
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
DEFINE t_h1                LIKE type_file.num5
DEFINE t_h2                LIKE type_file.num5
DEFINE l_h2                LIKE type_file.num5
DEFINE l_m2                LIKE type_file.num5
DEFINE l_h1                LIKE type_file.num5
DEFINE l_m1                LIKE type_file.num5
DEFINE t_m1                LIKE type_file.num5
DEFINE t_m2                LIKE type_file.num5

DEFINE g_hrbo_1   DYNAMIC ARRAY OF RECORD
         hrbo01     LIKE   hrbo_file.hrbo01,
         hraa02     LIKE   hraa_file.hraa02,
         hrbo02     LIKE   hrbo_file.hrbo02,
         hrbo03     LIKE   hrbo_file.hrbo03,
         hrbo06     LIKE   hrbo_file.hrbo06,
         hrbo07     LIKE   hrbo_file.hrbo07,
         hrbo04     LIKE   hrbo_file.hrbo04,
         hrbo05     LIKE   hrbo_file.hrbo05,
         hrbo08     LIKE   hrbo_file.hrbo08,
         hrbo09     LIKE   hrbo_file.hrbo09,
         hrbo11     LIKE   hrbo_file.hrbo11,
         hrbo12     LIKE   hrbo_file.hrbo12,
         hrbo13     LIKE   hrbo_file.hrbo13,
         hrbo10     LIKE   hrbo_file.hrbo10
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
 
   LET g_forupd_sql = "SELECT * FROM hrbo_file WHERE hrbo02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i033_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i033_w WITH FORM "ghr/42f/ghri033"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i033_menu()
 
   CLOSE WINDOW i033_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i033_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   CALL g_hrboa.clear()
 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_hrbo.* TO NULL
   CONSTRUCT BY NAME g_wc ON hrbo01,hrbo02,hrbo03,hrbo04,hrbo05,
                             hrbo06,hrbo07,hrbo08,hrbo09,hrbo10,
                             hrbo11,hrbo12,hrbo13,hrbo14,hrbo15,
                             hrbouser,hrbogrup,
                             hrbooriu,hrboorig,hrbomodu,hrbodate
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbo01)               #單據編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbo01
               NEXT FIELD hrbo01
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbouser', 'hrbogrup')
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON hrboa01,hrboa02,hrboa03,hrboa04,hrboa05,
                      hrboa06,hrboa07,hrboa08,hrboa09,hrboa10,
                      hrboa11,hrboa12,hrboa13,hrboa14
                FROM s_hrboa[1].hrboa01,s_hrboa[1].hrboa02,s_hrboa[1].hrboa03,s_hrboa[1].hrboa04,s_hrboa[1].hrboa05,
                     s_hrboa[1].hrboa06,s_hrboa[1].hrboa07,s_hrboa[1].hrboa08,s_hrboa[1].hrboa09,s_hrboa[1].hrboa10,
                     s_hrboa[1].hrboa11,s_hrboa[1].hrboa12,s_hrboa[1].hrboa13,s_hrboa[1].hrboa14
                     
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         ON ACTION controlp
            CASE
              WHEN INFIELD(hrboa08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1='508'
                  LET g_qryparam.form ="q_hrag06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrboa08
                  NEXT FIELD hrboa08
              WHEN INFIELD(hrboa09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1='531'
                  LET g_qryparam.form ="q_hrag06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrboa09
                  NEXT FIELD hrboa09
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
      LET g_sql = "SELECT hrbo02 FROM hrbo_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY hrbo02"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE hrbo02 ",
                  "  FROM hrbo_file,hrboa_file ",
                  " WHERE hrbo02 = hrboa15 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY hrbo02"
   END IF
 
   PREPARE i033_prepare FROM g_sql
   DECLARE i033_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i033_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM hrbo_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT hrbo02) FROM hrbo_file,hrboa_file",
                " WHERE hrbo02 = hrboa15 ",
                "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
   PREPARE i033_precount FROM g_sql
   DECLARE i033_count CURSOR FOR i033_precount
END FUNCTION
	
FUNCTION i033_menu()
DEFINE m_cnt LIKE type_file.num5
DEFINE l_cmd LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i033_bp("G")
      
      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN 
         SELECT hrbo_file.*
           INTO g_hrbo.*
           FROM hrbo_file
          WHERE hrbo01=g_hrbo_1[l_ac1].hrbo01
            AND hrbo02=g_hrbo_1[l_ac1].hrbo02
      END IF

      IF g_action_choice != "" THEN
         LET g_bp_flag = 'Page3'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i033_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page4", TRUE)
      END IF
      
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i033_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i033_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i033_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i033_u()
            END IF
 
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i033_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrboa),'','')
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_hrbo.hrbo02 IS NOT NULL THEN
               LET g_doc.column1 = "hrbo02"
               LET g_doc.value1 = g_hrbo.hrbo02
               CALL cl_doc()
            END IF
         END IF
        
         WHEN "ghri033_a"
            LET m_cnt = ARR_CURR()
            IF cl_null(m_cnt) OR m_cnt=0 THEN
            	CALL cl_err('未选中单身一笔资料','!',0)
            ELSE
              IF g_hrbo.hrbo10 = 'Y' THEN
                LET l_cmd = "ghri033_1 ",g_hrboa[m_cnt].hrboa15," ",g_hrboa[m_cnt].hrboa01
                CALL cl_cmdrun(l_cmd)
              ELSE
                CALL cl_err('此班次未按照刷卡加班','!',0)
              END IF
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i033_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
    DISPLAY ARRAY g_hrboa TO s_hrboa.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         CALL i033_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
 
      ON ACTION previous
         CALL i033_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
 
      ON ACTION jump
         CALL i033_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
 
      ON ACTION next
         CALL i033_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         #ACCEPT DISPLAY
         ACCEPT DIALOG
 
      ON ACTION last
         CALL i033_fetch('L')
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
         
      ON ACTION ghri033_a
         LET g_action_choice = 'ghri033_a'
         #EXIT DISPLAY
         EXIT DIALOG
 
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
   
    DISPLAY ARRAY g_hrbo_1 TO s_hrbo.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
         
#       ON ACTION main
#         LET g_bp_flag = 'Page3'
#         LET l_ac1 = ARR_CURR()
#         LET g_jump = l_ac1
#         LET g_no_ask = TRUE
#         IF g_rec_b1 >0 THEN
#             CALL i033_fetch('/')
#         END IF
#         CALL cl_set_comp_visible("Page4", FALSE)
#         CALL ui.interface.refresh()
#         CALL cl_set_comp_visible("Page4", TRUE)
#         EXIT DIALOG
      
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i033_fetch('/')
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
	
FUNCTION i033_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_hrboa.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_hrbo.* LIKE hrbo_file.*             #DEFAULT 設定
   LET g_hrbo02_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_hrbo_t.* = g_hrbo.*
   LET g_hrbo_o.* = g_hrbo.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrbo.hrbouser = g_user
      LET g_hrbo.hrbogrup = g_grup
      LET g_hrbo.hrbooriu = g_user
      LET g_hrbo.hrboorig = g_grup
      LET g_hrbo.hrbo06='N'
      LET g_hrbo.hrbo07='N'
      LET g_hrbo.hrbo10='N'
      LET g_hrbo.hrbo11='N'
      LET g_hrbo.hrbo12='30'
      LET g_hrbo.hrbo13='30'
 
      CALL i033_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_hrbo.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_hrbo.hrbo02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
      
      IF cl_null(g_hrbo.hrbo08) THEN
      	 LET g_hrbo.hrbo08 = ' '
      END IF
      IF cl_null(g_hrbo.hrbo09) THEN
      	 LET g_hrbo.hrbo09 = ' '
      END IF      

      BEGIN WORK
 
      INSERT INTO hrbo_file VALUES (g_hrbo.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         ROLLBACK WORK
         CALL cl_err3("ins","hrbo_file",g_hrbo.hrbo02,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK
#         CALL cl_flow_notify(g_hrbo.hrbo02,'I')
      END IF
 
      LET g_hrbo02_t = g_hrbo.hrbo02        #保留舊值
      LET g_hrbo_t.* = g_hrbo.*
      LET g_hrbo_o.* = g_hrbo.*
      
      CALL g_hrboa.clear() 
      LET g_rec_b = 0
      CALL i033_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
	
FUNCTION i033_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbo.hrbo02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_hrbo.* FROM hrbo_file
    WHERE hrbo02=g_hrbo.hrbo02
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrbo02_t = g_hrbo.hrbo02
   BEGIN WORK
 
   OPEN i033_cl USING g_hrbo.hrbo02
   IF STATUS THEN
      CALL cl_err("OPEN i033_cl:", STATUS, 1)
      CLOSE i033_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i033_cl INTO g_hrbo.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbo.hrbo02,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i033_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i033_show()
 
   WHILE TRUE
      LET g_hrbo02_t = g_hrbo.hrbo02
      LET g_hrbo_o.* = g_hrbo.*
      LET g_hrbo.hrbomodu=g_user
      LET g_hrbo.hrbodate=g_today
 
      CALL i033_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_hrbo.*=g_hrbo_t.*
         CALL i033_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      #IF g_hrbo.hrbo02 != g_hrbo02_t THEN            # 更改單號
      #   UPDATE hrboa_file SET hrboa07 = g_hrbo.hrbo02
      #   WHERE hrboa07 = g_hrbo02_t
      #   IF SQLCA.sqlcode THEN
      #      CALL cl_err3("upd","hrboa_file",g_hrbo01_t,"",SQLCA.sqlcode,"","hrboa",1)
      #      CONTINUE WHILE
      #   END IF
      #END IF
 
      UPDATE hrbo_file SET hrbo_file.* = g_hrbo.*
       WHERE hrbo02 = g_hrbo02_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","hrbo_file",g_hrbo02_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i033_cl
   COMMIT WORK
#   CALL cl_flow_notify(g_hrbo.hrbo02,'U')
 
   CALL i033_show()
   CALL i033_b_fill(" 1=1")
   CALL i033_b1_fill(g_wc,g_wc2)
END FUNCTION
	
FUNCTION i033_i(p_cmd)
   DEFINE l_n         LIKE type_file.num10
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_hraa02    LIKE hraa_file.hraa02
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_hrbo.hrbo01,g_hrbo.hrbo02,g_hrbo.hrbo03,g_hrbo.hrbo04,g_hrbo.hrbo05,
                   g_hrbo.hrbo06,g_hrbo.hrbo07,g_hrbo.hrbo08,g_hrbo.hrbo09,g_hrbo.hrbo10,
                   g_hrbo.hrbo11,g_hrbo.hrbo12,g_hrbo.hrbo13,g_hrbo.hrbo14,g_hrbo.hrbo15,
                   g_hrbo.hrbouser,g_hrbo.hrbomodu,g_hrbo.hrbooriu,
                   g_hrbo.hrboorig,g_hrbo.hrbogrup,g_hrbo.hrbodate
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_hrbo.hrbo01,g_hrbo.hrbo02,g_hrbo.hrbo03,g_hrbo.hrbo06,g_hrbo.hrbo07,
                 g_hrbo.hrbo04,g_hrbo.hrbo05,g_hrbo.hrbo08,g_hrbo.hrbo09,g_hrbo.hrbo11,
                 g_hrbo.hrbo12,g_hrbo.hrbo13,g_hrbo.hrbo10,
                 g_hrbo.hrbo14,g_hrbo.hrbo15
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i033_set_entry(p_cmd)
         CALL i033_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD hrbo01
         IF NOT cl_null(g_hrbo.hrbo01) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file
             WHERE hraa01=g_hrbo.hrbo01
               AND hraaacti='Y'
            IF l_n=0 THEN
            	 CALL cl_err("无此公司编号","!",0)
            	 NEXT FIELD hrbo01
            END IF
            
            SELECT hraa12 INTO l_hraa02 FROM hraa_file
             WHERE hraa01=g_hrbo.hrbo01
               AND hraaacti='Y'
            DISPLAY l_hraa02 TO hraa02
         ELSE
            CALL cl_err("请录入公司编号","!",0)
            NEXT FIELD hrbo01		    
         END IF
         
      BEFORE FIELD hrbo02
        IF p_cmd='a' THEN
             CALL hr_gen_no('hrbo_file','hrbo02','016',g_hrbo.hrbo01,'') RETURNING g_hrbo.hrbo02,g_flag
             DISPLAY BY NAME g_hrbo.hrbo02
         END IF
         	
      AFTER FIELD hrbo02
         IF NOT cl_null(g_hrbo.hrbo02) THEN
         	  IF g_hrbo_t.hrbo02 != g_hrbo.hrbo02 
         	  	OR g_hrbo_t.hrbo02 IS NULL THEN
         	  	LET l_n=0
         	  	SELECT COUNT(*) INTO l_n FROM hrbo_file
         	  	 WHERE hrbo02=g_hrbo.hrbo02
         	  	IF l_n>0 THEN
         	  		 CALL cl_err("班次编号不能重复","!",0)
         	  		 NEXT FIELD hrbo02
         	  	END IF
         	  END IF
         ELSE
           CALL cl_err("请录入班次编号","!",0)
         	 NEXT FIELD hrbo02 
         END IF
      
      AFTER FIELD hrbo03
         IF NOT cl_null(g_hrbo.hrbo03) THEN
         	  IF g_hrbo_t.hrbo03 != g_hrbo.hrbo03 
         	  	OR g_hrbo_t.hrbo03 IS NULL THEN
         	  	LET l_n=0
         	  	SELECT COUNT(*) INTO l_n FROM hrbo_file
         	  	 WHERE hrbo03=g_hrbo.hrbo03
         	  	IF l_n>0 THEN
         	  		 CALL cl_err("班次名称不能重复","!",0)
         	  		 NEXT FIELD hrbo03
         	  	END IF
         	  END IF
         ELSE
           CALL cl_err("请录入班次名称","!",0)
         	 NEXT FIELD hrbo03 
         END IF
         
      BEFORE FIELD hrbo04
         IF p_cmd='a' AND cl_null(g_hrbo.hrbo04) THEN
         	  LET g_hrbo.hrbo04='00:00'
         END IF
     
      BEFORE FIELD hrbo05
         IF p_cmd='a' AND cl_null(g_hrbo.hrbo05) THEN
         	  LET g_hrbo.hrbo05='00:00'
         END IF
         
      AFTER FIELD hrbo04
         IF NOT cl_null(g_hrbo.hrbo04) THEN
         	  LET l_h1 = g_hrbo.hrbo04[1,2]
         	  LET l_m1 = g_hrbo.hrbo04[4,5]
         	  IF l_h1 < 0 OR l_h1 > 24 OR l_m1 < 0 OR l_m1 > 60 OR cl_null(l_h1) OR cl_null(l_m1) THEN
          	 	  CALL cl_err('结束时间录入不正确','!',0)
          	 	  NEXT FIELD hrbo04
          	END IF
         END IF
      
      AFTER FIELD hrbo05
         IF NOT cl_null(g_hrbo.hrbo05) THEN
         	  LET l_h2 = g_hrbo.hrbo05[1,2]
         	  LET l_m2 = g_hrbo.hrbo05[4,5]
         	  IF l_h2 < 0 OR l_h2 > 24 OR l_m2 < 0 OR l_m2 > 60 OR cl_null(l_h2) OR cl_null(l_m2) THEN
          	 	  CALL cl_err('结束时间录入不正确','!',0)
          	 	  NEXT FIELD hrbo05
          	END IF
          	IF g_hrbo.hrbo07 = 'N' THEN
          	  IF l_h2 < l_h1 OR (l_h1=l_h2 AND l_m2<l_m1) THEN
          		    CALL cl_err('非跨天班结束时间不能早于开始时间','!',0)
          	 	    NEXT FIELD hrbo05
          	  END IF
          	END IF
          	IF g_hrbo.hrbo07 = 'Y' THEN
          	  IF l_h2 > l_h1 OR (l_h1=l_h2 AND l_m2>l_m1) THEN
          		    CALL cl_err('跨天班开始时间不能早于结束时间','!',0)
          	 	    NEXT FIELD hrbo05
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
            WHEN INFIELD(hrbo01)     
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hraa01"
               LET g_qryparam.default1 = g_hrbo.hrbo01              
               CALL cl_create_qry() RETURNING g_hrbo.hrbo01              
               DISPLAY BY NAME g_hrbo.hrbo01
               NEXT FIELD hrbo01
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

FUNCTION i033_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrboa.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i033_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hrbo.* TO NULL
      RETURN
   END IF
 
   OPEN i033_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrbo.* TO NULL
   ELSE
      OPEN i033_count
      FETCH i033_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i033_fetch('F')                  # 讀出TEMP第一筆并顯示
      CALL i033_b1_fill(g_wc,g_wc2)
   END IF
 
END FUNCTION
	
FUNCTION i033_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i033_cs INTO g_hrbo.hrbo02
      WHEN 'P' FETCH PREVIOUS i033_cs INTO g_hrbo.hrbo02
      WHEN 'F' FETCH FIRST    i033_cs INTO g_hrbo.hrbo02
      WHEN 'L' FETCH LAST     i033_cs INTO g_hrbo.hrbo02
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
            FETCH ABSOLUTE g_jump i033_cs INTO g_hrbo.hrbo02
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbo.hrbo02,SQLCA.sqlcode,0)
      INITIALIZE g_hrbo.* TO NULL
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
 
   SELECT * INTO g_hrbo.* FROM hrbo_file WHERE hrbo02 = g_hrbo.hrbo02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrbo_file",g_hrbo.hrbo02,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_hrbo.* TO NULL
      RETURN
   END IF
 
   CALL i033_show()
 
END FUNCTION	
	
FUNCTION i033_show()
 
   LET g_hrbo_t.* = g_hrbo.*                #保存單頭舊值
   LET g_hrbo_o.* = g_hrbo.*                #保存單頭舊值
   
   DISPLAY BY NAME g_hrbo.hrbo01,g_hrbo.hrbo02,g_hrbo.hrbo03,g_hrbo.hrbo04,g_hrbo.hrbo05,
                   g_hrbo.hrbo06,g_hrbo.hrbo07,g_hrbo.hrbo08,g_hrbo.hrbo09,g_hrbo.hrbo10,
                   g_hrbo.hrbo11,g_hrbo.hrbo12,g_hrbo.hrbo13,g_hrbo.hrbo14,g_hrbo.hrbo15,
                   g_hrbo.hrbouser,g_hrbo.hrbogrup,g_hrbo.hrbomodu,
                   g_hrbo.hrbodate,g_hrbo.hrbooriu,g_hrbo.hrboorig
 
   CALL i033_b_fill(g_wc2)
   CALL i033_update_hrbo15()       #add by lijun130829
   DISPLAY BY NAME g_hrbo.hrbo15   #add by lijun130829
END FUNCTION
	
FUNCTION i033_r()
DEFINE l_count   LIKE type_file.num5 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrbo.hrbo02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_count FROM hrboa_file
     WHERE hrboa15=g_hrbo.hrbo02
   IF l_count >0 THEN
   	  CALL cl_err('班次信息已存在，不得删除','!',1)
   	  RETURN
   END IF
 
   SELECT * INTO g_hrbo.* FROM hrbo_file
    WHERE hrbo02=g_hrbo.hrbo02
 
   BEGIN WORK
 
   OPEN i033_cl USING g_hrbo.hrbo02
   IF STATUS THEN
      CALL cl_err("OPEN i033_cl:", STATUS, 1)
      CLOSE i033_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i033_cl INTO g_hrbo.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbo.hrbo02,SQLCA.sqlcode,0)     # 資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i033_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "hrbo02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_hrbo.hrbo02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM hrbo_file WHERE hrbo02 = g_hrbo.hrbo02
      DELETE FROM hrboa_file WHERE hrboa15 = g_hrbo.hrbo02
      CLEAR FORM
      CALL g_hrboa.clear()
      OPEN i033_count
      FETCH i033_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i033_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i033_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i033_fetch('/')
      END IF
   END IF
 
   CLOSE i033_cl
   COMMIT WORK
#   CALL cl_flow_notify(g_hrbo.hrbo02,'D')
   CALL i033_b1_fill(g_wc,g_wc2)
END FUNCTION
	
FUNCTION i033_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT hrboa15,hrboa01,hrboa02,hrboa03,hrboa04, ",
               "hrboa05,hrboa06,hrboa07,hrboa08,'',hrboa09,'', ",
               "hrboa10,hrboa11,hrboa12,hrboa13,hrboa14  ",
               "  FROM hrboa_file ",
               " WHERE hrboa15 ='",g_hrbo.hrbo02,"' " 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY hrboa01 "
 
   PREPARE i033_pb FROM g_sql
   DECLARE hrboa_cs CURSOR FOR i033_pb
 
   CALL g_hrboa.clear()
   LET g_cnt = 1
 
   FOREACH hrboa_cs INTO g_hrboa[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT hrag07 INTO g_hrboa[g_cnt].hrag07_1 FROM hrag_file
         WHERE hrag01='508' AND hrag06=g_hrboa[g_cnt].hrboa08		      
       SELECT hrag07 INTO g_hrboa[g_cnt].hrag07_2 FROM hrag_file
         WHERE hrag01='531' AND hrag06=g_hrboa[g_cnt].hrboa09
                 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrboa.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i033_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("hrbo02",TRUE)
    END IF
END FUNCTION
 
FUNCTION i033_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("hrbo02",FALSE)
    END IF
 
END FUNCTION
	
FUNCTION i033_b()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_i     LIKE type_file.num5
DEFINE s_hrboa11  LIKE hrboa_file.hrboa11
DEFINE l_hrboa11  LIKE type_file.num5
DEFINE s_hrboa12  LIKE hrboa_file.hrboa12
DEFINE l_hrboa12  LIKE type_file.num5
DEFINE s_hrboa13  LIKE hrboa_file.hrboa13
DEFINE l_hrboa13  LIKE type_file.num5
    
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_hrbo.hrbo02) THEN
           RETURN 
        END IF
        
        SELECT * INTO g_hrbo.* FROM hrbo_file
         WHERE hrbo02=g_hrbo.hrbo02
        
        CALL cl_opmsg('b')
        
        LET g_forupd_sql= "SELECT hrboa15,hrboa01,hrboa02,hrboa03,hrboa04,hrboa05, ",
                          "hrboa06,hrboa07,hrboa08,'',hrboa09,'',hrboa10, ",
                          "hrboa11,hrboa12,hrboa13,hrboa14 ",
                          "  FROM hrboa_file ",
                          " WHERE hrboa01 = ? ",
                          "   AND hrboa15 = ? ",
                          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i033_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_hrboa WITHOUT DEFAULTS FROM s_hrboa.*
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
           OPEN i033_cl USING g_hrbo.hrbo02
           IF STATUS THEN
              CALL cl_err("OPEN i033_cl:",STATUS,1)
              CLOSE i033_cl
              ROLLBACK WORK
           END IF
           
           FETCH i033_cl INTO g_hrbo.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrbo.hrbo02,SQLCA.sqlcode,0)
              CLOSE i033_cl
              ROLLBACK WORK 
              RETURN
           END IF
           	
           IF g_rec_b>=l_ac THEN 
               LET p_cmd ='u'
               LET g_hrboa_t.*=g_hrboa[l_ac].*
               LET g_hrboa_o.*=g_hrboa[l_ac].*
               OPEN i033_bcl USING g_hrboa_t.hrboa01,g_hrbo.hrbo02
               IF STATUS THEN
                  CALL cl_err("OPEN i033_bcl:",STATUS,1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i033_bcl INTO g_hrboa[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrboa_t.hrboa02,SQLCA.sqlcode,1)
                     LET l_lock_sw="Y"
                  END IF
                  SELECT hrag07 INTO g_hrboa[l_ac].hrag07_1 FROM hrag_file
                    WHERE hrag01='508' AND hrag06=g_hrboa[l_ac].hrboa08		      
                  SELECT hrag07 INTO g_hrboa[l_ac].hrag07_2 FROM hrag_file
                    WHERE hrag01='531' AND hrag06=g_hrboa[l_ac].hrboa09	 	 	
               END IF
           END IF
       BEFORE INSERT
           LET l_n=ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_hrboa[l_ac].* TO NULL
           LET g_hrboa_t.*=g_hrboa[l_ac].*
           LET g_hrboa[l_n].hrboa03='N'
           LET g_hrboa[l_n].hrboa04='60'
           LET g_hrboa[l_n].hrboa06='N'
           LET g_hrboa[l_n].hrboa07='60'
           LET g_hrboa[l_n].hrboa08='001'
           LET g_hrboa[l_n].hrboa10='Y'
           SELECT hrag07 INTO g_hrboa[l_n].hrag07_1 FROM hrag_file
             WHERE hrag01='508' AND hrag06=g_hrboa[l_n].hrboa08		      
           SELECT hrag07 INTO g_hrboa[l_n].hrag07_2 FROM hrag_file
             WHERE hrag01='531' AND hrag06=g_hrboa[l_n].hrboa09 	 	     
           CALL cl_show_fld_cont()
           NEXT FIELD hrboa01
                
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             CANCEL INSERT
          END IF
          INSERT INTO hrboa_file(hrboa01,hrboa02,hrboa03,hrboa04,hrboa05,
                                 hrboa06,hrboa07,hrboa08,hrboa09,hrboa10,                                
                                 hrboa11,hrboa12,hrboa13,hrboa14,hrboa15)
             VALUES(g_hrboa[l_ac].hrboa01,g_hrboa[l_ac].hrboa02,
                    g_hrboa[l_ac].hrboa03,g_hrboa[l_ac].hrboa04,
                    g_hrboa[l_ac].hrboa05,g_hrboa[l_ac].hrboa06,
                    g_hrboa[l_ac].hrboa07,g_hrboa[l_ac].hrboa08,
                    g_hrboa[l_ac].hrboa09,g_hrboa[l_ac].hrboa10,
                    g_hrboa[l_ac].hrboa11,g_hrboa[l_ac].hrboa12,
                    g_hrboa[l_ac].hrboa13,g_hrboa[l_ac].hrboa14,
                    g_hrbo.hrbo02)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","hrboa_file",g_hrbo.hrbo02,g_hrboa[l_ac].hrboa01,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   MESSAGE 'INSERT O.K.'
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2
#                   SELECT SUM(hrboa13) INTO s_hrboa13 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                   LET l_hrboa13 = s_hrboa13*24*60
#                   SELECT SUM(hrboa12) INTO s_hrboa12 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                   LET l_hrboa12 = s_hrboa12*60
#                   SELECT SUM(hrboa11) INTO s_hrboa11 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                   LET l_hrboa11 = s_hrboa11+l_hrboa12+l_hrboa13
#                   IF NOT cl_null(l_hrboa11) THEN
#                   	  UPDATE hrbo_file SET hrbo09 = l_hrboa11 WHERE hrbo02 = g_hrbo.hrbo02
#                   	  LET g_hrbo.hrbo09 = l_hrboa11
#                   END IF
                END IF
                
      BEFORE FIELD hrboa01
        IF cl_null(g_hrboa[l_ac].hrboa01) OR g_hrboa[l_ac].hrboa01 = 0 THEN 
            SELECT MAX(hrboa01)+1 INTO g_hrboa[l_ac].hrboa01
              FROM hrboa_file
             WHERE hrboa15 = g_hrbo.hrbo02
            IF g_hrboa[l_ac].hrboa01 IS NULL THEN
               LET g_hrboa[l_ac].hrboa01=1
            END IF
         END IF
         
      AFTER FIELD hrboa01 #項次
        IF NOT cl_null(g_hrboa[l_ac].hrboa01) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_hrboa[l_ac].hrboa01 <> g_hrboa_t.hrboa01) THEN
              SELECT COUNT(*) INTO l_n FROM hrboa_file
               WHERE hrboa15 = g_hrbo.hrbo02
                 AND hrboa01 = g_hrboa[l_ac].hrboa01
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_hrboa[l_ac].hrboa01=g_hrboa_t.hrboa01
                 NEXT FIELD hrboa01
              END IF
           END IF
         END IF
       
       AFTER FIELD hrboa08
          IF NOT cl_null(g_hrboa[l_ac].hrboa08) THEN
          	 SELECT hrag07 INTO g_hrboa[l_ac].hrag07_1 FROM hrag_file
                 WHERE hrag01='508' AND hrag06=g_hrboa[l_ac].hrboa08
             DISPLAY g_hrboa[l_ac].hrag07_1 TO hrag07_1		      
          END IF
       
       AFTER FIELD hrboa09
          IF NOT cl_null(g_hrboa[l_ac].hrboa08) THEN
          	 SELECT hrag07 INTO g_hrboa[l_ac].hrag07_2 FROM hrag_file
                 WHERE hrag01='531' AND hrag06=g_hrboa[l_ac].hrboa09
             DISPLAY g_hrboa[l_ac].hrag07_2 TO hrag07_2		      
          END IF
          
       AFTER FIELD hrboa02
          IF NOT cl_null(g_hrboa[l_ac].hrboa02) THEN
          	 LET l_h1 = g_hrboa[l_ac].hrboa02[1,2]
          	 LET l_m1 = g_hrboa[l_ac].hrboa02[4,5]
          	 IF l_h1 < 0 OR l_h1 > 24 OR l_m1 < 0 OR l_m1 > 60 OR cl_null(l_h1) OR cl_null(l_m1) THEN
          	 	   CALL cl_err('结束时间录入不正确','!',0)
          	 	   NEXT FIELD hrboa02
          	 ELSE
          	   LET t_h1 = g_hrbo.hrbo04[1,2]
          	 	 LET t_h2 = g_hrbo.hrbo05[1,2]
          	   LET t_m1 = g_hrbo.hrbo04[4,5]
          	   LET t_m2 = g_hrbo.hrbo05[4,5]          	 	 
          	   IF g_hrboa[l_ac].hrboa10 = 'Y' AND g_hrbo.hrbo07 = 'N' THEN
          	      IF l_h1 < t_h1 OR l_h2 > t_h2 THEN
          	      	 CALL cl_err('班段开始时间超过班次开始结束时间范围','!',0)
          	    	   NEXT FIELD hrboa02
          	      END IF
          	      IF l_h1 = t_h1 AND l_m1 < t_m1 THEN
          	      	 CALL cl_err('班段结束时间超过班次开始结束时间范围','!',0)
          	      	 NEXT FIELD hrboa05          	        
          	      END IF
          	      IF l_h1 = t_h2 AND l_m1 > t_m2 THEN
          	      	 CALL cl_err('班段结束时间超过班次开始结束时间范围','!',0)
          	      	 NEXT FIELD hrboa05      	        
          	      END IF
          	   END IF
          	 END IF
          END IF
       
       AFTER FIELD hrboa05
          IF NOT cl_null(g_hrboa[l_ac].hrboa05) THEN
          	 LET l_h2 = g_hrboa[l_ac].hrboa05[1,2]
          	 LET l_m2 = g_hrboa[l_ac].hrboa05[4,5]
          	 IF l_h2 < 0 OR l_h2 > 24 OR l_m2 < 0 OR l_m2 > 60 OR cl_null(l_h2) OR cl_null(l_m2) THEN
          	 	   CALL cl_err('结束时间录入不正确','!',0)
          	 	   NEXT FIELD hrboa05
          	 ELSE
          	   IF l_h2 < t_h1 AND g_hrbo.hrbo07 = 'N' THEN
          	     CALL cl_err('结束时间不得早于开始时间','!',0)
          	   ELSE
          	     LET t_h1 = g_hrbo.hrbo04[1,2]
          	   	 LET t_h2 = g_hrbo.hrbo05[1,2]
          	   	 LET t_m1 = g_hrbo.hrbo04[4,5]
          	   	 LET t_m2 = g_hrbo.hrbo05[4,5]
          	  	 
          	     IF g_hrboa[l_ac].hrboa10 = 'Y' AND g_hrbo.hrbo07 = 'N' THEN
          	        IF l_h2 < t_h1 OR l_h2 > t_h2 THEN
          	      	   CALL cl_err('班段结束时间超过班次开始结束时间范围','!',0)
          	      	   NEXT FIELD hrboa05
          	        END IF
          	        IF l_h2 = t_h1 AND l_m2 < t_m1 THEN
          	      	   CALL cl_err('班段结束时间超过班次开始结束时间范围','!',0)
          	      	   NEXT FIELD hrboa05          	        
          	        END IF
          	        IF l_h2 = t_h2 AND l_m2 > t_m2 THEN
          	      	   CALL cl_err('班段结束时间超过班次开始结束时间范围','!',0)
          	      	   NEXT FIELD hrboa05      	        
          	        END IF
          	     END IF
          	   END IF
          	 END IF
          END IF
          
       BEFORE FIELD hrboa02
          IF cl_null(g_hrboa[l_ac].hrboa02) AND p_cmd='a' THEN
             LET g_hrboa[l_ac].hrboa02 = '00:00'
          END IF

       BEFORE FIELD hrboa05
          IF cl_null(g_hrboa[l_ac].hrboa05) AND p_cmd='a' THEN
             LET g_hrboa[l_ac].hrboa05 = '00:00'
          END IF    
 
       
         
       BEFORE DELETE                      
           IF g_hrboa_t.hrboa01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM hrboa_file
               WHERE hrboa15 = g_hrbo.hrbo02
                 AND hrboa01 = g_hrboa_t.hrboa01
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","hrboa_file",g_hrbo.hrbo02,g_hrboa_t.hrboa01,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
#                 SELECT SUM(hrboa13) INTO s_hrboa13 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                 LET l_hrboa13 = s_hrboa13*24*60
#                 SELECT SUM(hrboa12) INTO s_hrboa12 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                 LET l_hrboa12 = s_hrboa12*60
#                 SELECT SUM(hrboa11) INTO s_hrboa11 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                 LET l_hrboa11 = s_hrboa11+l_hrboa12+l_hrboa13
#                 IF NOT cl_null(l_hrboa11) THEN
#                   	UPDATE hrbo_file SET hrbo09 = l_hrboa11 WHERE hrbo02 = g_hrbo.hrbo02
#                   	LET g_hrbo.hrbo09 = l_hrboa11
#                 END IF              
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrboa[l_ac].* = g_hrboa_t.*
              CLOSE i033_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_hrboa[l_ac].hrboa01,-263,1)
              LET g_hrboa[l_ac].* = g_hrboa_t.*
           ELSE
              UPDATE hrboa_file SET hrboa01 = g_hrboa[l_ac].hrboa01,
                                    hrboa02 = g_hrboa[l_ac].hrboa02,
                                    hrboa03 = g_hrboa[l_ac].hrboa03,
                                    hrboa04 = g_hrboa[l_ac].hrboa04,
                                    hrboa05 = g_hrboa[l_ac].hrboa05,
                                    hrboa06 = g_hrboa[l_ac].hrboa06,
                                    hrboa07 = g_hrboa[l_ac].hrboa07,
                                    hrboa08 = g_hrboa[l_ac].hrboa08,
                                    hrboa09 = g_hrboa[l_ac].hrboa09,
                                    hrboa10 = g_hrboa[l_ac].hrboa10,
                                    hrboa11 = g_hrboa[l_ac].hrboa11,
                                    hrboa12 = g_hrboa[l_ac].hrboa12,
                                    hrboa13 = g_hrboa[l_ac].hrboa13,
                                    hrboa14 = g_hrboa[l_ac].hrboa14
                 WHERE hrboa15 = g_hrbo.hrbo02
                   AND hrboa01 = g_hrboa_t.hrboa01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","hrboa_file",g_hrbo.hrbo02,g_hrboa_t.hrboa01,SQLCA.sqlcode,"","",1) 
                 LET g_hrboa[l_ac].* = g_hrboa_t.*
              ELSE                
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
#                 SELECT SUM(hrboa13) INTO s_hrboa13 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                 LET l_hrboa13 = s_hrboa13*24*60
#                 SELECT SUM(hrboa12) INTO s_hrboa12 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                 LET l_hrboa12 = s_hrboa12*60
#                 SELECT SUM(hrboa11) INTO s_hrboa11 FROM hrboa_file WHERE hrboa15=g_hrbo.hrbo02
#                 LET l_hrboa11 = s_hrboa11+l_hrboa12+l_hrboa13
#                 IF NOT cl_null(l_hrboa11) THEN
#                   	UPDATE hrbo_file SET hrbo09 = l_hrboa11 WHERE hrbo02 = g_hrbo.hrbo02
#                   	LET g_hrbo.hrbo09 = l_hrboa11
#                 END IF
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_hrboa[l_ac].* = g_hrboa_t.*
              END IF
              CLOSE i033_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           
           CLOSE i033_bcl
           COMMIT WORK

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrboa08)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_hrag06"
            LET g_qryparam.arg1 = '508'
            LET g_qryparam.default1 = g_hrboa[l_ac].hrboa08
            CALL cl_create_qry() RETURNING g_hrboa[l_ac].hrboa08
            DISPLAY g_hrboa[l_ac].hrboa08 TO hrboa08
            NEXT FIELD hrboa08
            WHEN INFIELD(hrboa09)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_hrag06"
            LET g_qryparam.arg1 = '531'
            LET g_qryparam.default1 = g_hrboa[l_ac].hrboa09
            CALL cl_create_qry() RETURNING g_hrboa[l_ac].hrboa09
            DISPLAY g_hrboa[l_ac].hrboa09 TO hrboa09
            NEXT FIELD hrboa09         
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

    CLOSE i033_bcl
    COMMIT WORK
    CALL i033_delall()
    CALL i033_show()
END FUNCTION 
 
FUNCTION i033_delall()
#刪除單頭資料
   SELECT COUNT(*) INTO g_cnt FROM hrboa_file
    WHERE hrboa15 = g_hrbo.hrbo02
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
 
      DELETE FROM hrbo_file
       WHERE hrbo02 = g_hrbo.hrbo02
      CLEAR FORM 
      INITIALIZE g_hrbo.* TO NULL
   END IF
END FUNCTION

#add by lijun130829-------begin-------单身开始结束时间拼接回写单头
FUNCTION i033_update_hrbo15()
DEFINE l_sql_lj   STRING
DEFINE l_hrbo15   LIKE hrbo_file.hrbo15
DEFINE l_hrbo15_new  LIKE hrbo_file.hrbo15
DEFINE l_hrboa02  LIKE hrboa_file.hrboa02
DEFINE l_hrboa05  LIKE hrboa_file.hrboa05

   LET l_hrbo15_new =''
   LET l_hrbo15 =''
   LET l_hrboa02=''
   LET l_hrboa05=''
   LET l_sql_lj= " SELECT hrboa02,hrboa05 FROM hrboa_file ",
                 " LEFT JOIN hrbo_file ON hrbo02 = hrboa15",
                # " WHERE hrboa15='",g_hrbo.hrbo02,"' AND ((hrboa08='001' AND hrbo06 ='N') OR (hrboa08 = '003' AND hrbo06='Y'))",
                 " WHERE hrboa15='",g_hrbo.hrbo02,"' AND hrboa08='001' ",
                 " ORDER BY hrboa01 "
   PREPARE i033_sql_lj FROM l_sql_lj
   DECLARE i033_lj CURSOR FOR i033_sql_lj
   FOREACH i033_lj INTO l_hrboa02,l_hrboa05
     LET l_hrbo15 = l_hrboa02,'-',l_hrboa05
     IF NOT cl_null(l_hrbo15_new) THEN
        LET l_hrbo15_new = l_hrbo15_new,'|',l_hrbo15
     ELSE
        LET l_hrbo15_new = l_hrbo15
     END IF                   
   END FOREACH
   IF NOT cl_null(l_hrbo15_new) THEN
      UPDATE hrbo_file SET hrbo15 = l_hrbo15_new WHERE hrbo02 = g_hrbo.hrbo02
      LET g_hrbo.hrbo15 = l_hrbo15_new
   END IF
END FUNCTION	
#add by lijun130829-------end-------单身开始结束时间拼接回写单头


FUNCTION i033_b1_fill(p_wc,p_wc2)
DEFINE p_wc     STRING
DEFINE p_wc2    STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5

  
        CALL g_hrbo_1.clear()
        
        
        IF p_wc2 = " 1=1" THEN 
           LET l_sql=" SELECT hrbo01,'',hrbo02,hrbo03,hrbo06,hrbo07,hrbo04,hrbo05,hrbo08,hrbo09, ",
                     " hrbo11,hrbo12,hrbo13,hrbo10 ",
                     "   FROM hrbo_file ",
                     "  WHERE ",p_wc CLIPPED,
                     "  ORDER BY hrbo01,hrbo02 "
        ELSE
        	 LET l_sql=" SELECT DISTINCT hrbo01,'',hrbo02,hrbo03,hrbo06,hrbo07,hrbo04,hrbo05,hrbo08,hrbo09, ",
        	           " hrbo11,hrbo12,hrbo13,hrbo10 ",
                     "   FROM hrbo_file,hrboa_file ",
                     "  WHERE hrbo02 = hrboa15 ",
                     "    AND ", p_wc CLIPPED, " AND ",p_wc2 CLIPPED,
                     "  ORDER BY hrbo01,hrbo02 " 
        END IF 
                            
        PREPARE i033_b1_pre FROM l_sql
        DECLARE i033_b1_cs CURSOR FOR i033_b1_pre
        
        LET l_i=1
        
        FOREACH i033_b1_cs INTO g_hrbo_1[l_i].*
        
           SELECT hraa02 INTO g_hrbo_1[l_i].hraa02 FROM hraa_file
            WHERE hraa01=g_hrbo_1[l_i].hrbo01
                            
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrbo_1.deleteElement(l_i)
        LET g_rec_b1 = l_i - 1

END FUNCTION
