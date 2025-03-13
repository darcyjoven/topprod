# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: abat311.4gl
# Descriptions...: 條碼調整作業
# Date & Author..: No:DEV-CB0010 12/11/14 By TSD.sophy 
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.FUN-D20061 12/03/25 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查



DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

#模組變數(Module Variables)
DEFINE g_inab              RECORD LIKE inab_file.*, 
       g_inab_t            RECORD LIKE inab_file.*, 
       g_inab_o            RECORD LIKE inab_file.*, 
       g_inab01_t          LIKE inab_file.inab01, 
       g_t1                LIKE oay_file.oayslip,          
       g_inbb              DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
          inbb02           LIKE inbb_file.inbb02,
          inbb04           LIKE inbb_file.inbb04, 
          inbb05           LIKE inbb_file.inbb05,
          ima02            LIKE ima_file.ima02,
          ima021           LIKE ima_file.ima021,
          inbb06           LIKE inbb_file.inbb06,
          inbb07           LIKE inbb_file.inbb07,
          inbb08           LIKE inbb_file.inbb08,
          imgb05           LIKE imgb_file.imgb05,
          inbb09           LIKE inbb_file.inbb09,
          inbb10           LIKE inbb_file.inbb10,
          inbbud01         LIKE inbb_file.inbbud01,
          inbbud02         LIKE inbb_file.inbbud02,
          inbbud03         LIKE inbb_file.inbbud03,
          inbbud04         LIKE inbb_file.inbbud04,
          inbbud05         LIKE inbb_file.inbbud05,
          inbbud06         LIKE inbb_file.inbbud06,
          inbbud07         LIKE inbb_file.inbbud07,
          inbbud08         LIKE inbb_file.inbbud08,
          inbbud09         LIKE inbb_file.inbbud09,
          inbbud10         LIKE inbb_file.inbbud10,
          inbbud11         LIKE inbb_file.inbbud11,
          inbbud12         LIKE inbb_file.inbbud12,
          inbbud13         LIKE inbb_file.inbbud13,
          inbbud14         LIKE inbb_file.inbbud14,
          inbbud15         LIKE inbb_file.inbbud15
                           END RECORD,
       g_inbb_t            RECORD                        #程式變數 (舊值)
          inbb02           LIKE inbb_file.inbb02,
          inbb04           LIKE inbb_file.inbb04, 
          inbb05           LIKE inbb_file.inbb05,
          ima02            LIKE ima_file.ima02,
          ima021           LIKE ima_file.ima021,
          inbb06           LIKE inbb_file.inbb06,
          inbb07           LIKE inbb_file.inbb07,
          inbb08           LIKE inbb_file.inbb08,
          imgb05           LIKE imgb_file.imgb05,
          inbb09           LIKE inbb_file.inbb09,
          inbb10           LIKE inbb_file.inbb10,
          inbbud01         LIKE inbb_file.inbbud01,
          inbbud02         LIKE inbb_file.inbbud02,
          inbbud03         LIKE inbb_file.inbbud03,
          inbbud04         LIKE inbb_file.inbbud04,
          inbbud05         LIKE inbb_file.inbbud05,
          inbbud06         LIKE inbb_file.inbbud06,
          inbbud07         LIKE inbb_file.inbbud07,
          inbbud08         LIKE inbb_file.inbbud08,
          inbbud09         LIKE inbb_file.inbbud09,
          inbbud10         LIKE inbb_file.inbbud10,
          inbbud11         LIKE inbb_file.inbbud11,
          inbbud12         LIKE inbb_file.inbbud12,
          inbbud13         LIKE inbb_file.inbbud13,
          inbbud14         LIKE inbb_file.inbbud14,
          inbbud15         LIKE inbb_file.inbbud15
                           END RECORD,
       g_inbb_o            RECORD                        #程式變數 (舊值)
          inbb02           LIKE inbb_file.inbb02,
          inbb04           LIKE inbb_file.inbb04, 
          inbb05           LIKE inbb_file.inbb05,
          ima02            LIKE ima_file.ima02,
          ima021           LIKE ima_file.ima021,
          inbb06           LIKE inbb_file.inbb06,
          inbb07           LIKE inbb_file.inbb07,
          inbb08           LIKE inbb_file.inbb08,
          imgb05           LIKE imgb_file.imgb05,
          inbb09           LIKE inbb_file.inbb09,
          inbb10           LIKE inbb_file.inbb10,
          inbbud01         LIKE inbb_file.inbbud01,
          inbbud02         LIKE inbb_file.inbbud02,
          inbbud03         LIKE inbb_file.inbbud03,
          inbbud04         LIKE inbb_file.inbbud04,
          inbbud05         LIKE inbb_file.inbbud05,
          inbbud06         LIKE inbb_file.inbbud06,
          inbbud07         LIKE inbb_file.inbbud07,
          inbbud08         LIKE inbb_file.inbbud08,
          inbbud09         LIKE inbb_file.inbbud09,
          inbbud10         LIKE inbb_file.inbbud10,
          inbbud11         LIKE inbb_file.inbbud11,
          inbbud12         LIKE inbb_file.inbbud12,
          inbbud13         LIKE inbb_file.inbbud13,
          inbbud14         LIKE inbb_file.inbbud14,
          inbbud15         LIKE inbb_file.inbbud15
                           END RECORD 
DEFINE g_sql               STRING,                 #CURSOR暫存
       g_wc                STRING,                 #單頭CONSTRUCT結果
       g_wc2               STRING,                 #單身CONSTRUCT結果
       g_rec_b             LIKE type_file.num5,    #單身筆數  
       l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT 
DEFINE p_row,p_col         LIKE type_file.num5     #
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE g_before_input_done LIKE type_file.num5     #
DEFINE g_chr               LIKE type_file.chr1     #
DEFINE g_cnt               LIKE type_file.num10    #
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose 
DEFINE g_msg               LIKE ze_file.ze03       #
DEFINE g_curs_index        LIKE type_file.num10    #
DEFINE g_row_count         LIKE type_file.num10    #總筆數  
DEFINE g_jump              LIKE type_file.num10    #查詢指定的筆數 
DEFINE mi_no_ask           LIKE type_file.num5     #是否開啟指定筆視窗  
DEFINE g_argv1             LIKE inab_file.inab01   #
DEFINE g_argv2             STRING                  #指定執行的功能
DEFINE g_void              LIKE type_file.chr1

#主程式開始
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF

   LET g_argv1 = ARG_VAL(1) 
   LET g_argv2 = ARG_VAL(2)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM inab_file WHERE inab01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t311_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t311_w AT p_row,p_col WITH FORM "aba/42f/abat311"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL t311_menu()
   
   CLOSE WINDOW t311_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION t311_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  

   CLEAR FORM 
   CALL g_inbb.clear()
   INITIALIZE g_inab.* TO NULL
   CALL cl_set_head_visible("","YES") 
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " inab01 = '",g_argv1,"'"  
   ELSE
      CALL cl_set_head_visible("","YES")  
      CONSTRUCT BY NAME g_wc ON inab00,inab01,inab02,inab03,inab04,inab05,inab06,
                                inab07,inabconf,inabpost,inabconu,inabcond,
                                inabuser,inabgrup,inaboriu,inaborig,inabmodu,inabdate,
                                inabud01,inabud02,inabud03,inabud04,inabud05,
                                inabud06,inabud07,inabud08,inabud09,inabud10,
                                inabud11,inabud12,inabud13,inabud14,inabud15 

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(inab01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_inab"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inab01
                  NEXT FIELD inab01
               WHEN INFIELD(inab04) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inab04
                  NEXT FIELD inab04 
               WHEN INFIELD(inab05) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inab05
                  NEXT FIELD inab05                                                  
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

      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON inbb02,inbb04,inbb05,inbb06,inbb07,   #螢幕上取單身條件
                         inbb08,inbb09,inbb10,
                         inbbud01,inbbud02,inbbud03,inbbud04,inbbud05,
                         inbbud06,inbbud07,inbbud08,inbbud09,inbbud10,
                         inbbud11,inbbud12,inbbud13,inbbud14,inbbud15 
              FROM s_inbb[1].inbb02,s_inbb[1].inbb04,s_inbb[1].inbb05,
                   s_inbb[1].inbb06,s_inbb[1].inbb07,s_inbb[1].inbb08,
                   s_inbb[1].inbb09,s_inbb[1].inbb10,
                   s_inbb[1].inbbud01,s_inbb[1].inbbud02,s_inbb[1].inbbud03,
                   s_inbb[1].inbbud04,s_inbb[1].inbbud05,s_inbb[1].inbbud06,
                   s_inbb[1].inbbud07,s_inbb[1].inbbud08,s_inbb[1].inbbud09,
                   s_inbb[1].inbbud10,s_inbb[1].inbbud11,s_inbb[1].inbbud12,
                   s_inbb[1].inbbud13,s_inbb[1].inbbud14,s_inbb[1].inbbud15 

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(inbb04) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_imgb"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inbb04
                  NEXT FIELD inbb04
               WHEN INFIELD(inbb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inbb05
                  NEXT FIELD inbb05   
               WHEN INFIELD(inbb06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_imd21" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inbb06
                  NEXT FIELD inbb06  
               WHEN INFIELD(inbb07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_ime6" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO inbb07
                  NEXT FIELD inbb07                                       
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
   
      IF INT_FLAG THEN RETURN END IF
   END IF

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('inabuser', 'inabgrup')

   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT inab01 FROM inab_file ",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE inab01 ",
                  "  FROM inab_file,inbb_file ",
                  " WHERE inab01 = inbb01",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF

   PREPARE t311_prepare FROM g_sql
   DECLARE t311_cs SCROLL CURSOR WITH HOLD FOR t311_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql = "SELECT COUNT(*) FROM inab_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql = "SELECT COUNT(DISTINCT inab01) ",
                  "  FROM inab_file,inbb_file ",
                  " WHERE inbb01 = inab01 ",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF

   PREPARE t311_precount FROM g_sql
   DECLARE t311_count CURSOR FOR t311_precount
END FUNCTION

FUNCTION t311_menu()
   WHILE TRUE
      CALL t311_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t311_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t311_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t311_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t311_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t311_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t311_y()
            END IF
            
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t311_z()
            END IF  
            
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t311_post()
            END IF
            
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t311_undo_post()
            END IF                                 
         
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t311_x()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                       base.TypeInfo.create(g_inbb),'','')
            END IF

         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_inab.inab01 IS NOT NULL THEN
               LET g_doc.column1 = "inab01"
               LET g_doc.value1 = g_inab.inab01
               CALL cl_doc()
             END IF
         END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t311_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_inbb TO s_inbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION insert
         LET g_action_choice = "insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice = "query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice = "delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice = "modify"
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DISPLAY
         
      ON ACTION undo_confirm
         LET g_action_choice = "undo_confirm"
         EXIT DISPLAY 
         
      ON ACTION post
         LET g_action_choice = "post"
         EXIT DISPLAY
         
      ON ACTION undo_post
         LET g_action_choice = "undo_post"
         EXIT DISPLAY                                  

      ON ACTION void
         LET g_action_choice = "void"
         EXIT DISPLAY                                  

      ON ACTION first
         CALL t311_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL t311_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL t311_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL t311_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL t311_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION detail
         LET g_action_choice = "detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice = "help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       

      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice = "controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG = FALSE 
         LET g_action_choice = "exit"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice = "related_document"          
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t311_a()
DEFINE li_result   LIKE type_file.num5

   CALL cl_msg("")
   CLEAR FORM
   CALL g_inbb.clear()
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN RETURN END IF

   INITIALIZE g_inab.* TO NULL             #DEFAULT 設定
   LET g_inab01_t = NULL

   #預設值及將數值類變數清成零
   LET g_inab_t.* = g_inab.*
   LET g_inab_o.* = g_inab.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_inab.inab00 = '1'
      LET g_inab.inab02 = g_today
      LET g_inab.inab03 = g_today
      LET g_inab.inab04 = g_user
      LET g_inab.inab05 = g_grup
      LET g_inab.inabconf = 'N'
      LET g_inab.inabpost = 'N'
      LET g_inab.inabuser = g_user
      LET g_inab.inabgrup = g_grup
      LET g_inab.inabdate = g_today
      LET g_inab.inabplant = g_plant
      LET g_inab.inablegal = g_legal
      LET g_inab.inaboriu = g_user
      LET g_inab.inaborig = g_grup

      CALL t311_i("a")                   #輸入單頭

      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_inab.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_inab.inab01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF

      BEGIN WORK

      CALL s_auto_assign_no("aba",g_inab.inab01,g_inab.inab02,"1","inab_file","inab01","","","")
         RETURNING li_result,g_inab.inab01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_inab.inab01
      
      INSERT INTO inab_file VALUES (g_inab.*)

      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #  ROLLBACK WORK          #FUN-D20061 
         CALL cl_err3("ins","inab_file",g_inab.inab01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK          #FUN-D20061
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_inab.inab01,'I')
      END IF

      SELECT inab01 INTO g_inab.inab01 FROM inab_file
       WHERE inab01 = g_inab.inab01
      LET g_inab01_t = g_inab.inab01        #保留舊值
      LET g_inab_t.* = g_inab.*
      LET g_inab_o.* = g_inab.*
      CALL g_inbb.clear()

      LET g_rec_b = 0
      CALL t311_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t311_u()

   IF s_shut(0) THEN RETURN END IF

   IF g_inab.inab01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01

   IF g_inab.inabconf = 'X' THEN  
      CALL cl_err(g_inab.inab01,'9024',0)
      RETURN
   END IF
   
   IF g_inab.inabconf = 'Y' THEN 
      CALL cl_err(g_inab.inab01,'9023',0)
      RETURN
   END IF    

   CALL cl_msg("") 
   CALL cl_opmsg('u')
   LET g_inab01_t = g_inab.inab01
   BEGIN WORK

   OPEN t311_cl USING g_inab.inab01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t311_cl INTO g_inab.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t311_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t311_show()

   WHILE TRUE
      LET g_inab01_t = g_inab.inab01
      LET g_inab_o.* = g_inab.*
      LET g_inab.inabmodu = g_user
      LET g_inab.inabdate = g_today

      CALL t311_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_inab.* = g_inab_t.*
         CALL t311_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_inab.inab01 != g_inab01_t THEN            # 更改單號
         UPDATE inbb_file SET inbb01 = g_inab.inab01
          WHERE inbb01 = g_inab01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","inbb_file",g_inab01_t,"",SQLCA.sqlcode,"","inbb",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE inab_file SET inab_file.* = g_inab.*
       WHERE inab01 = g_inab.inab01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","inab_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t311_cl
   COMMIT WORK
   CALL cl_flow_notify(g_inab.inab01,'U')

   CALL t311_b_fill("1=1")

END FUNCTION

FUNCTION t311_i(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
DEFINE li_result   LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   DISPLAY BY NAME g_inab.inab00,g_inab.inab01,g_inab.inab02,g_inab.inab03,
                   g_inab.inab04,g_inab.inab05,g_inab.inab06,g_inab.inab07,
                   g_inab.inabconf,g_inab.inabpost,g_inab.inabconu,g_inab.inabcond,
                   g_inab.inabuser,g_inab.inabgrup,g_inab.inabmodu,g_inab.inabdate,
                   g_inab.inaboriu,g_inab.inaborig,
                   g_inab.inabud01,g_inab.inabud02,g_inab.inabud03,g_inab.inabud04,
                   g_inab.inabud05,g_inab.inabud06,g_inab.inabud07,g_inab.inabud08,
                   g_inab.inabud09,g_inab.inabud10,g_inab.inabud11,g_inab.inabud12,
                   g_inab.inabud13,g_inab.inabud14,g_inab.inabud15

   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_inab.inab01,g_inab.inab02,g_inab.inab03,
                 g_inab.inab04,g_inab.inab05,g_inab.inab06,
                 g_inab.inab07,
                 g_inab.inabud01,g_inab.inabud02,g_inab.inabud03,g_inab.inabud04,
                 g_inab.inabud05,g_inab.inabud06,g_inab.inabud07,g_inab.inabud08,
                 g_inab.inabud09,g_inab.inabud10,g_inab.inabud11,g_inab.inabud12,
                 g_inab.inabud13,g_inab.inabud14,g_inab.inabud15
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t311_set_entry(p_cmd)
         CALL t311_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("inab01") 
         
      AFTER FIELD inab01
         IF NOT cl_null(g_inab.inab01) THEN
            IF g_inab.inab01 != g_inab_t.inab01
               OR g_inab_t.inab01 IS NULL THEN
               LET g_t1 = s_get_doc_no(g_inab.inab01)   
               CALL s_check_no("aba",g_inab.inab01,g_inab_t.inab01,"1","inab_file","inab01","")
                 RETURNING li_result,g_inab.inab01
               DISPLAY BY NAME g_inab.inab01
               IF (NOT li_result) THEN
                  NEXT FIELD inab01
               END IF
               
               LET l_cnt = 0 
               SELECT COUNT(*) INTO l_cnt FROM inab_file 
                WHERE inab01 = g_inab.inab01
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
               IF l_cnt > 0 THEN
                  CALL cl_err('','-239',0)
                  NEXT FIELD inab01
               END IF 
            END IF 
         END IF 
          
      AFTER FIELD inab04
         IF NOT cl_null(g_inab.inab04) THEN 
            CALL t311_inab04(p_cmd)
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0) 
               NEXT FIELD inab04
            END IF
         END IF 
          
      AFTER FIELD inab05
          IF NOT cl_null(g_inab.inab05) THEN 
             CALL t311_inab05(p_cmd)
             IF NOT cl_null(g_errno)  THEN
                CALL cl_err('',g_errno,0) 
                NEXT FIELD inab05
             END IF
          END IF                             

      AFTER FIELD inabud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inabud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(inab01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ibe"
               LET g_qryparam.arg1 = '1'
               LET g_qryparam.default1 = g_inab.inab01
               CALL cl_create_qry() RETURNING g_inab.inab01
               DISPLAY BY NAME g_inab.inab01
               NEXT FIELD inab01        
            WHEN INFIELD(inab04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_inab.inab04
               CALL cl_create_qry() RETURNING g_inab.inab04
               DISPLAY BY NAME g_inab.inab04
               NEXT FIELD inab04
            WHEN INFIELD(inab05) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_inab.inab05
               CALL cl_create_qry() RETURNING g_inab.inab05
               DISPLAY BY NAME g_inab.inab05
               NEXT FIELD inab05               
            OTHERWISE EXIT CASE
          END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
END FUNCTION
 
FUNCTION t311_inab04(p_cmd)  
DEFINE l_gen02     LIKE gen_file.gen02,
       l_genacti   LIKE gen_file.genacti,
       p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gen02,genacti
     INTO l_gen02,l_genacti 
     FROM gen_file 
    WHERE gen01 = g_inab.inab04

   CASE WHEN SQLCA.SQLCODE=100  LET g_errno = 'mfg3096'
        WHEN l_genacti='N'      LET g_errno = '9028'
        OTHERWISE   LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   ELSE 
      DISPLAY ' ' TO FORMONLY.gen02
   END IF

END FUNCTION

FUNCTION t311_inab05(p_cmd)  
DEFINE l_gem02     LIKE gem_file.gem02,
       l_gemacti   LIKE gem_file.gemacti,
       p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti 
     FROM gem_file 
    WHERE gem01 = g_inab.inab05

   CASE WHEN SQLCA.SQLCODE=100  LET g_errno = 'afa-083'
        WHEN l_gemacti='N'      LET g_errno = '9028'
        OTHERWISE   LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   ELSE 
      DISPLAY ' ' TO FORMONLY.gem02
   END IF

END FUNCTION

FUNCTION t311_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   
   CALL cl_msg("")
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_inbb.clear()
   INITIALIZE g_inab.* TO NULL
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t311_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_inab.* TO NULL
      RETURN
   END IF

   OPEN t311_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_inab.* TO NULL
   ELSE
      OPEN t311_count
      FETCH t311_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t311_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")
END FUNCTION

FUNCTION t311_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式

   CASE p_flag
      WHEN 'N' FETCH NEXT     t311_cs INTO g_inab.inab01
      WHEN 'P' FETCH PREVIOUS t311_cs INTO g_inab.inab01
      WHEN 'F' FETCH FIRST    t311_cs INTO g_inab.inab01
      WHEN 'L' FETCH LAST     t311_cs INTO g_inab.inab01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump t311_cs INTO g_inab.inab01
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)
      INITIALIZE g_inab.* TO NULL
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

   SELECT * INTO g_inab.* FROM inab_file WHERE inab01 = g_inab.inab01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","inab_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_inab.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_inab.inabuser
   LET g_data_group = g_inab.inabgrup

   CALL t311_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION t311_show()
DEFINE l_gen02_2    LIKE gen_file.gen02

   LET g_inab_t.* = g_inab.*                #保存單頭舊值
   LET g_inab_o.* = g_inab.*                #保存單頭舊值

   DISPLAY BY NAME g_inab.inab00,g_inab.inab01,g_inab.inab02,g_inab.inab03,
                   g_inab.inab04,g_inab.inab05,g_inab.inab06,g_inab.inab07,
                   g_inab.inabconf,g_inab.inabpost,g_inab.inabconu,g_inab.inabcond,
                   g_inab.inabuser,g_inab.inabgrup,g_inab.inabmodu,g_inab.inabdate,
                   g_inab.inaboriu,g_inab.inaborig,
                   g_inab.inabud01,g_inab.inabud02,g_inab.inabud03,g_inab.inabud04,
                   g_inab.inabud05,g_inab.inabud06,g_inab.inabud07,g_inab.inabud08,
                   g_inab.inabud09,g_inab.inabud10,g_inab.inabud11,g_inab.inabud12,
                   g_inab.inabud13,g_inab.inabud14,g_inab.inabud15
   
   SELECT gen02 INTO l_gen02_2 FROM gen_file 
    WHERE gen01 = g_inab.inabconu
   DISPLAY l_gen02_2 TO gen02_2
   
   CALL t311_inab04('d')
   CALL t311_inab05('d')
   CALL t311_pic()
   CALL t311_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t311_r()

   IF s_shut(0) THEN RETURN END IF

   IF g_inab.inab01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01
    
   IF g_inab.inabconf = 'X' THEN  
      CALL cl_err(g_inab.inab01,'9024',0)
      RETURN
   END IF
   
   IF g_inab.inabconf = 'Y' THEN 
      CALL cl_err(g_inab.inab01,'9023',0)
      RETURN
   END IF    

   BEGIN WORK

   OPEN t311_cl USING g_inab.inab01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t311_cl INTO g_inab.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   CALL t311_show()

   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM inab_file WHERE inab01 = g_inab.inab01
      DELETE FROM inbb_file WHERE inbb01 = g_inab.inab01
      CLEAR FORM
      CALL g_inbb.clear()
      OPEN t311_count
      FETCH t311_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t311_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t311_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t311_fetch('/')
      END IF
   END IF

   CLOSE t311_cl
   COMMIT WORK
   CALL cl_flow_notify(g_inab.inab01,'D')
END FUNCTION

#單身
FUNCTION t311_b()
DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,    #檢查重複用
       l_cnt           LIKE type_file.num5,    #檢查重複用
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 
       p_cmd           LIKE type_file.chr1,    #處理狀態
       l_allow_insert  LIKE type_file.num5,    #可新增否 
       l_allow_delete  LIKE type_file.num5     #可刪除否 

   LET g_action_choice = ""

   IF s_shut(0) THEN RETURN END IF

   IF g_inab.inab01 IS NULL THEN
      RETURN
   END IF

   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01

   IF g_inab.inabconf = 'X' THEN  
      CALL cl_err(g_inab.inab01,'9024',0)
      RETURN
   END IF
   
   IF g_inab.inabconf = 'Y' THEN 
      CALL cl_err(g_inab.inab01,'9023',0)
      RETURN
   END IF    

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT inbb02,inbb04,inbb05,'','',",
                      "       inbb06,inbb07,inbb08,'',inbb09,inbb10,",
                      "       inbbud01,inbbud02,inbbud03,inbbud04,inbbud05,",
                      "       inbbud06,inbbud07,inbbud08,inbbud09,inbbud10,",
                      "       inbbud11,inbbud12,inbbud13,inbbud14,inbbud15",
                      "  FROM inbb_file",
                      " WHERE inbb01=? AND inbb02=? "
   DECLARE t311_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_inbb WITHOUT DEFAULTS FROM s_inbb.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)

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

         OPEN t311_cl USING g_inab.inab01
         IF STATUS THEN
            CALL cl_err("OPEN t311_cl:", STATUS, 1)
            CLOSE t311_cl
            ROLLBACK WORK
            RETURN
         END IF

         FETCH t311_cl INTO g_inab.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE t311_cl
            ROLLBACK WORK
            RETURN
         END IF

         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_inbb_t.* = g_inbb[l_ac].*  #BACKUP
            LET g_inbb_o.* = g_inbb[l_ac].*  #BACKUP
            OPEN t311_bcl USING g_inab.inab01,g_inbb_t.inbb02
            IF STATUS THEN
               CALL cl_err("OPEN t311_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t311_bcl INTO g_inbb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_inbb_t.inbb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont() 
            CALL t311_set_entry_b(p_cmd)
            CALL t311_set_no_entry_b(p_cmd)
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_inbb[l_ac].* TO NULL      
         LET g_inbb_t.* = g_inbb[l_ac].*         #新輸入資料
         LET g_inbb_o.* = g_inbb[l_ac].*         #新輸入資料         
         CALL cl_show_fld_cont()
         CALL t311_set_entry_b(p_cmd)
         CALL t311_set_no_entry_b(p_cmd)
         NEXT FIELD inbb02

      BEFORE FIELD inbb02                        #default 序號
         IF g_inbb[l_ac].inbb02 IS NULL OR g_inbb[l_ac].inbb02 = 0 THEN
            SELECT MAX(inbb02)+1
              INTO g_inbb[l_ac].inbb02
              FROM inbb_file
             WHERE inbb01 = g_inab.inab01
            IF g_inbb[l_ac].inbb02 IS NULL THEN
               LET g_inbb[l_ac].inbb02 = 1
            END IF
         END IF

      AFTER FIELD inbb02                        #check 序號是否重複
         IF NOT cl_null(g_inbb[l_ac].inbb02) THEN
            IF g_inbb[l_ac].inbb02 != g_inbb_t.inbb02
               OR g_inbb_t.inbb02 IS NULL THEN
               LET l_n = 0  
               SELECT COUNT(*) INTO l_n FROM inbb_file
                WHERE inbb01 = g_inab.inab01
                  AND inbb02 = g_inbb[l_ac].inbb02
               IF cl_null(l_n) THEN LET l_n = 0 END IF 
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_inbb[l_ac].inbb02 = g_inbb_t.inbb02
                  NEXT FIELD inbb02
               END IF
            END IF
         END IF

      AFTER FIELD inbb04                  #條碼編號
         IF NOT cl_null(g_inbb[l_ac].inbb04) THEN
            IF g_inbb[l_ac].inbb04 IS NULL OR g_inbb_t.inbb04 IS NULL OR
               (g_inbb[l_ac].inbb04 != g_inbb_o.inbb04) THEN
               CALL t311_inbb04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_inbb[l_ac].inbb04,g_errno,0)
                  LET g_inbb[l_ac].inbb04 = g_inbb_t.inbb04
                  DISPLAY BY NAME g_inbb[l_ac].inbb04
                  NEXT FIELD inbb04
               END IF
            END IF
         END IF
         LET g_inbb_o.inbb04 = g_inbb[l_ac].inbb04
         
      AFTER FIELD inbb06
          IF NOT cl_null(g_inbb[l_ac].inbb06) THEN
             CALL t311_inbb06()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_inbb[l_ac].inbb06,g_errno,0)
                LET g_inbb[l_ac].inbb06 = g_inbb_t.inbb06
                DISPLAY BY NAME g_inbb[l_ac].inbb06
                NEXT FIELD inbb06
             END IF
          END IF
	IF NOT s_imechk(g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07) THEN NEXT FIELD inbb07 END IF  #FUN-D40103 add
          
      AFTER FIELD inbb07
     #    IF NOT cl_null(g_inbb[l_ac].inbb07) THEN
     #       CALL t311_inbb07()
     #       IF NOT cl_null(g_errno) THEN
     #          CALL cl_err(g_inbb[l_ac].inbb07,g_errno,0)
     #          LET g_inbb[l_ac].inbb07 = g_inbb_t.inbb07
     #          DISPLAY BY NAME g_inbb[l_ac].inbb07
     #          NEXT FIELD inbb07
     #       END IF
     #    END IF 
      #FUN-D40103--mark--str--
         #FUN-D40103--add--str--    
	IF cl_null(g_inbb[l_ac].inbb07) THEN
            LET g_inbb[l_ac].inbb07 = ' '
         END IF
         IF NOT s_imechk(g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07) THEN
            LET g_inbb[l_ac].inbb07 = g_inbb_t.inbb07
            DISPLAY BY NAME g_inbb[l_ac].inbb07
            NEXT FIELD inbb07
         END IF
         #FUN-D40103--add--end--

      AFTER FIELD inbb08
         IF cl_null(g_inbb[l_ac].inbb06) THEN 
            LET g_inbb[l_ac].inbb06 = ' '
         END IF 
         IF cl_null(g_inbb[l_ac].inbb07) THEN 
            LET g_inbb[l_ac].inbb07 = ' '
         END IF 
         IF cl_null(g_inbb[l_ac].inbb08) THEN 
            LET g_inbb[l_ac].inbb08 = ' '
         END IF        
          
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM imgb_file
          WHERE imgb01 = g_inbb[l_ac].inbb04
            AND imgb02 = g_inbb[l_ac].inbb06
            AND imgb03 = g_inbb[l_ac].inbb07
            AND imgb04 = g_inbb[l_ac].inbb08
         IF cl_null(l_n) THEN LET l_n = 0 END IF 
         #沒有imgb檔，新增筆imgb檔
         IF l_n = 0 THEN
            CALL s_ins_imgb(g_inbb[l_ac].inbb04,g_inbb[l_ac].inbb06,
                            g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08,
                            0,'','') 
         END IF 
         SELECT imgb05 INTO g_inbb[l_ac].imgb05 FROM imgb_file 
          WHERE imgb01 = g_inbb[l_ac].inbb04
            AND imgb02 = g_inbb[l_ac].inbb06
            AND imgb03 = g_inbb[l_ac].inbb07
            AND imgb04 = g_inbb[l_ac].inbb08
         IF cl_null(g_inbb[l_ac].imgb05) THEN 
            LET g_inbb[l_ac].imgb05 = 0
         END IF
               
      AFTER FIELD inbb09
         IF g_inbb[l_ac].imgb05 + g_inbb[l_ac].inbb09 < 0 THEN 
            LET g_showmsg = g_inbb[l_ac].inbb04 || "|" || g_inbb[l_ac].inbb06 || "|" || 
                            g_inbb[l_ac].inbb07 || "|" || g_inbb[l_ac].inbb08
            CALL cl_err(g_showmsg,'aba-070',0)                 
         END IF                                
         
      AFTER FIELD inbbud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD inbbud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_inbb[l_ac].inbb06) THEN 
            LET g_inbb[l_ac].inbb06 = ' '
         END IF 
         IF cl_null(g_inbb[l_ac].inbb07) THEN 
            LET g_inbb[l_ac].inbb07 = ' '
         END IF 
         IF cl_null(g_inbb[l_ac].inbb08) THEN 
            LET g_inbb[l_ac].inbb08 = ' '
         END IF            
         INSERT INTO inbb_file(inbb01,inbb02,inbb04,inbb05,
                               inbb06,inbb07,inbb08,inbb09,inbb10,
                               inbbud01,inbbud02,inbbud03,inbbud04,inbbud05,                                
                               inbbud06,inbbud07,inbbud08,inbbud09,inbbud10,
                               inbbud11,inbbud12,inbbud13,inbbud14,inbbud15,                                
                               inbbplant,inbblegal)
          VALUES(g_inab.inab01,g_inbb[l_ac].inbb02,g_inbb[l_ac].inbb04,
                 g_inbb[l_ac].inbb05,g_inbb[l_ac].inbb06,
                 g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08,
                 g_inbb[l_ac].inbb09,g_inbb[l_ac].inbb10,
                 g_inbb[l_ac].inbbud01,g_inbb[l_ac].inbbud02,
                 g_inbb[l_ac].inbbud03,g_inbb[l_ac].inbbud04,
                 g_inbb[l_ac].inbbud05,g_inbb[l_ac].inbbud06,
                 g_inbb[l_ac].inbbud07,g_inbb[l_ac].inbbud08,
                 g_inbb[l_ac].inbbud09,g_inbb[l_ac].inbbud10,
                 g_inbb[l_ac].inbbud11,g_inbb[l_ac].inbbud12,
                 g_inbb[l_ac].inbbud13,g_inbb[l_ac].inbbud14,
                 g_inbb[l_ac].inbbud15,
                 g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","inbb_file",g_inab.inab01,g_inbb[l_ac].inbb02,
                         SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            CALL cl_msg("INSERT OK") 
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE DELETE                      #是否取消單身
         IF g_inbb_t.inbb02 > 0 AND g_inbb_t.inbb02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM inbb_file
             WHERE inbb01 = g_inab.inab01
               AND inbb02 = g_inbb_t.inbb02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","inbb_file",g_inab.inab01,g_inbb_t.inbb02,
                            SQLCA.sqlcode,"","",1)
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
            LET g_inbb[l_ac].* = g_inbb_t.*
            CLOSE t311_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_inbb[l_ac].inbb02,-263,1)
            LET g_inbb[l_ac].* = g_inbb_t.*
         ELSE
            UPDATE inbb_file SET inbb02 = g_inbb[l_ac].inbb02,
                                 inbb04 = g_inbb[l_ac].inbb04,
                                 inbb05 = g_inbb[l_ac].inbb05,
                                 inbb06 = g_inbb[l_ac].inbb06,
                                 inbb07 = g_inbb[l_ac].inbb07,
                                 inbb08 = g_inbb[l_ac].inbb08,
                                 inbb09 = g_inbb[l_ac].inbb09,
                                 inbb10 = g_inbb[l_ac].inbb10,
                                 inbbud01 = g_inbb[l_ac].inbbud01,
                                 inbbud02 = g_inbb[l_ac].inbbud02,
                                 inbbud03 = g_inbb[l_ac].inbbud03,
                                 inbbud04 = g_inbb[l_ac].inbbud04,
                                 inbbud05 = g_inbb[l_ac].inbbud05,
                                 inbbud06 = g_inbb[l_ac].inbbud06,
                                 inbbud07 = g_inbb[l_ac].inbbud07,
                                 inbbud08 = g_inbb[l_ac].inbbud08,
                                 inbbud09 = g_inbb[l_ac].inbbud09,
                                 inbbud10 = g_inbb[l_ac].inbbud10,
                                 inbbud11 = g_inbb[l_ac].inbbud11,
                                 inbbud12 = g_inbb[l_ac].inbbud12,
                                 inbbud13 = g_inbb[l_ac].inbbud13,
                                 inbbud14 = g_inbb[l_ac].inbbud14,
                                 inbbud15 = g_inbb[l_ac].inbbud15 
             WHERE inbb01 = g_inab.inab01
               AND inbb02 = g_inbb_t.inbb02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","inbb_file",g_inab.inab01,g_inbb_t.inbb02,
                            SQLCA.sqlcode,"","",1)
               LET g_inbb[l_ac].* = g_inbb_t.*
            ELSE
               CALL cl_msg("UPDATE OK") 
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
               LET g_inbb[l_ac].* = g_inbb_t.*
            END IF
            CLOSE t311_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t311_bcl
         COMMIT WORK

      ON ACTION q_imd    #查詢倉庫
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_imd"
         LET g_qryparam.default1 = g_inbb[l_ac].inbb06
         LET g_qryparam.arg1 = 'SW'        #倉庫類別 
         CALL cl_create_qry() RETURNING g_inbb[l_ac].inbb06
         NEXT FIELD inbb06
 
      ON ACTION q_ime    #查詢倉庫儲位
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_ime1"
         LET g_qryparam.arg1 = 'SW'        #倉庫類別 
         LET g_qryparam.default1 = g_inbb[l_ac].inbb06
         LET g_qryparam.default2 = g_inbb[l_ac].inbb07
         CALL cl_create_qry() RETURNING g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07
         NEXT FIELD inbb07
                    
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(inbb04) #條碼編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imgb"  
               LET g_qryparam.default1 = g_inbb[l_ac].inbb04
               CALL cl_create_qry() RETURNING g_inbb[l_ac].inbb04
               DISPLAY BY NAME g_inbb[l_ac].inbb04
               NEXT FIELD inbb04          
            WHEN INFIELD(inbb06) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imgb2"  #ttt
               LET g_qryparam.where = "imgb01 = '",g_inbb[l_ac].inbb04,"' "
               LET g_qryparam.default1 = g_inbb[l_ac].inbb06
               LET g_qryparam.default2 = g_inbb[l_ac].inbb07
               LET g_qryparam.default3 = g_inbb[l_ac].inbb08
               CALL cl_create_qry() 
                  RETURNING g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08
               DISPLAY BY NAME g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08
               NEXT FIELD inbb06 
            WHEN INFIELD(inbb07) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imgb2"
               LET g_qryparam.where = "imgb01 = '",g_inbb[l_ac].inbb04,"' "
               LET g_qryparam.default1 = g_inbb[l_ac].inbb06
               LET g_qryparam.default2 = g_inbb[l_ac].inbb07
               LET g_qryparam.default3 = g_inbb[l_ac].inbb08
               CALL cl_create_qry() 
                  RETURNING g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08
               DISPLAY BY NAME g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08
               NEXT FIELD inbb07 
            WHEN INFIELD(inbb08) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imgb2"
               LET g_qryparam.where = "imgb01 = '",g_inbb[l_ac].inbb04,"' "
               LET g_qryparam.default1 = g_inbb[l_ac].inbb06
               LET g_qryparam.default2 = g_inbb[l_ac].inbb07
               LET g_qryparam.default3 = g_inbb[l_ac].inbb08
               CALL cl_create_qry() 
                  RETURNING g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08
               DISPLAY BY NAME g_inbb[l_ac].inbb06,g_inbb[l_ac].inbb07,g_inbb[l_ac].inbb08
               NEXT FIELD inbb08                                   
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name 
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

   LET g_inab.inabmodu = g_user
   LET g_inab.inabdate = g_today
   UPDATE inab_file SET inabmodu = g_inab.inabmodu,
                        inabdate = g_inab.inabdate
    WHERE inab01 = g_inab.inab01
   DISPLAY BY NAME g_inab.inabmodu,g_inab.inabdate

   CLOSE t311_bcl
   COMMIT WORK
END FUNCTION

FUNCTION t311_inbb04() 
DEFINE l_sql     STRING

   LET g_errno = ''
   
   LET l_sql = "SELECT ibb06 FROM ibb_file ",
               " WHERE ibb01 = ? ",
               " ORDER BY ibb06"
   DECLARE t311_ibb06_cs SCROLL CURSOR FROM l_sql
   OPEN t311_ibb06_cs USING g_inbb[l_ac].inbb04
   FETCH t311_ibb06_cs INTO g_inbb[l_ac].inbb05
   CLOSE t311_ibb06_cs
   CASE
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aba-007'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  
   SELECT ima02,ima021 
     INTO g_inbb[l_ac].ima02,g_inbb[l_ac].ima021 
     FROM ima_file
    WHERE ima01 = g_inbb[l_ac].inbb05 
   
END FUNCTION

FUNCTION t311_inbb06() 
DEFINE l_imd02   LIKE imd_file.imd02

  LET g_errno = " "
  SELECT imd02 INTO l_imd02 FROM imd_file
   WHERE imd01 = g_inbb[l_ac].inbb06
   
  CASE 
     WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
     OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
   
END FUNCTION

#FUN-D40103--mark--str--
#FUNCTION t311_inbb07() 
#DEFINE l_ime03   LIKE ime_file.ime03

#  LET g_errno = " "
#  SELECT ime03 INTO l_ime03 FROM ime_file
#   WHERE ime01 = g_inbb[l_ac].inbb06
#     AND ime02 = g_inbb[l_ac].inbb07
#  CASE 
#     WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aba-071'
#     OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
#  END CASE
   
#END FUNCTION
#FUN-D40103--mark--end--

FUNCTION t311_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_s     LIKE type_file.chr1000 
DEFINE l_m     LIKE type_file.chr1000 
DEFINE i       LIKE type_file.num5
 
   IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF
   
   LET g_sql = "SELECT inbb02,inbb04,inbb05,ima02,ima021,",
               "       inbb06,inbb07,inbb08,NVL(imgb05,0),inbb09,inbb10,",
               "       inbbud01,inbbud02,inbbud03,inbbud04,inbbud05,",
               "       inbbud06,inbbud07,inbbud08,inbbud09,inbbud10,",
               "       inbbud11,inbbud12,inbbud13,inbbud14,inbbud15",
               "  FROM inbb_file ",
               "  LEFT JOIN ima_file ON ima01 = inbb05 ",
               "  LEFT JOIN imgb_file ",
               "    ON imgb01 = inbb04 AND imgb02 = inbb06 AND ",
               "       imgb03 = inbb07 AND imgb04 = inbb08 ",
               " WHERE inbb01 ='",g_inab.inab01,"' ",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY inbb02 "
   
   PREPARE t311_pb FROM g_sql
   DECLARE inbb_cs CURSOR FOR t311_pb

   CALL g_inbb.clear()
   LET g_cnt = 1

   FOREACH inbb_cs INTO g_inbb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
       
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_inbb.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t311_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("inab01",TRUE)
   END IF

END FUNCTION

FUNCTION t311_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("inab01",FALSE)
   END IF

END FUNCTION

FUNCTION t311_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

END FUNCTION

FUNCTION t311_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

END FUNCTION

FUNCTION t311_y()                                     #審核
DEFINE l_gen02_2  LIKE gen_file.gen02                            
DEFINE l_time     LIKE type_file.chr8                 #FUN-D20061             

   IF g_inab.inab01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF

   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01
   
   IF g_inab.inabconf = 'X' THEN  
      CALL cl_err(g_inab.inab01,'9024',0)
      RETURN
   END IF
   
   IF g_inab.inabconf = 'Y' THEN 
      CALL cl_err(g_inab.inab01,'9023',0)
      RETURN
   END IF    

   IF NOT cl_confirm('axr-108') THEN RETURN END IF
     
   BEGIN WORK
 
   OPEN t311_cl USING g_inab.inab01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t311_cl INTO g_inab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t311_show()
    
   LET g_inab.inabconf = 'Y'
   LET g_inab.inabconu = g_user
   LET g_inab.inabcond = g_today
#  LET g_inab.inabcont = TIME       #FUN-D20061
   LET g_inab.inabcont = l_time     #FUN-D20061 TIME-->l_time
   UPDATE inab_file 
      SET inabconf = g_inab.inabconf,
          inabconu = g_inab.inabconu,
          inabcond = g_inab.inabcond,
          inabcont = g_inab.inabcont
    WHERE inab01 = g_inab.inab01
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)
      LET g_inab.inabconf = 'N'
   END IF
   
   DISPLAY BY NAME g_inab.inabconf,g_inab.inabconu,
                   g_inab.inabcond,g_inab.inabcont
   
   SELECT gen02 INTO l_gen02_2 FROM gen_file
    WHERE gen01 = g_inab.inabconu
   DISPLAY l_gen02_2 TO gen02_2
   
   CALL t311_pic()
   CLOSE t311_cl
   COMMIT WORK
END FUNCTION

FUNCTION t311_z()                                     #取消審核
DEFINE l_gen02_2      LIKE gen_file.gen02
DEFINE l_time         LIKE type_file.chr8             #FUN-D20061

   IF g_inab.inab01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01
   
   IF g_inab.inabconf = 'X' THEN  
      CALL cl_err(g_inab.inab01,'9024',0)
      RETURN
   END IF
   
   IF g_inab.inabconf = 'N' THEN 
      CALL cl_err(g_inab.inab01,'9025',0)
      RETURN
   END IF    
          
   IF NOT cl_confirm('axr-109') THEN RETURN END IF
    
   BEGIN WORK
 
   OPEN t311_cl USING g_inab.inab01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t311_cl INTO g_inab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t311_show() 	    	      	      	      	     	      	 	   
   
   LET l_time = TIME     #FUN-D20061
   LET g_inab.inabconf = 'N'
#FUN-D20061--str--
#  LET g_inab.inabconu = ' '
#  LET g_inab.inabcond = ' '
#  LET g_inab.inabcont = ' ' 
   LET g_inab.inabconu = g_user
   LET g_inab.inabcond = g_today
   LET g_inab.inabcont = l_time
#FUN-D20061--end--
   UPDATE inab_file 
      SET inabconf = g_inab.inabconf,
          inabconu = g_inab.inabconu,
          inabcond = g_inab.inabcond,
          inabcont = g_inab.inabcont   	        
    WHERE inab01 = g_inab.inab01
   IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)
       LET g_inab.inabconf = 'Y'
   END IF
   
   DISPLAY BY NAME g_inab.inabconf,g_inab.inabconu,
                   g_inab.inabcond,g_inab.inabcont
   
#FUN-D20061--str--
   SELECT gen02 INTO l_gen02_2 FROM gen_file
    WHERE gen01 = g_inab.inabconu
   DISPLAY l_gen02_2 TO gen02_2
#  LET l_gen02_2 = ''
#  DISPLAY l_gen02_2 TO gen02_2
#FUN-D20061--end--
   
   CALL t311_pic()
   CLOSE t311_cl
   COMMIT WORK
END FUNCTION 

FUNCTION t311_pic()
   IF g_inab.inabconf = 'X' THEN 
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_inab.inabconf,"",g_inab.inabpost,"",g_void,"")
END FUNCTION

FUNCTION t311_post()
DEFINE l_gen02_2      LIKE gen_file.gen02
DEFINE l_n            LIKE type_file.num5

   IF g_inab.inab01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01
   
   IF g_inab.inabconf = 'X' THEN  
      CALL cl_err(g_inab.inab01,'9024',0)
      RETURN
   END IF
   
   IF g_inab.inabconf = 'N' THEN 
      CALL cl_err(g_inab.inab01,'aba-072',0)
      RETURN 
   END IF 
   
   IF g_inab.inabpost = 'Y' THEN 
      CALL cl_err(g_inab.inab01,'aba-074',0)
      RETURN 
   END IF     

   FOR l_n=1 TO g_rec_b
      IF g_inbb[l_n].imgb05 + g_inbb[l_n].inbb09 < 0 THEN 
         LET g_showmsg = g_inbb[l_n].inbb04 || "|" || g_inbb[l_n].inbb06 || "|" || 
                         g_inbb[l_n].inbb07 || "|" || g_inbb[l_n].inbb08
         CALL cl_err(g_showmsg,'aba-073',0)
         RETURN 
      END IF 
   END FOR
              
   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
    
   BEGIN WORK
 
   OPEN t311_cl USING g_inab.inab01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t311_cl INTO g_inab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t311_show() 	    	      	      	      	     	      	 	   

   LET g_success = 'Y' 
   
   FOR l_n=1 TO g_rec_b
      CALL t311_tlfb(g_inbb[l_n].inbb04,g_inbb[l_n].inbb06,g_inbb[l_n].inbb07,
                     g_inbb[l_n].inbb08,g_inbb[l_n].inbb09,g_inbb[l_n].inbb02)
      IF g_success = 'N' THEN 
         EXIT FOR 
      END IF 
   END FOR 
 
   IF g_success = 'Y' THEN                        
      CALL t311_show()
       LET g_inab.inabpost = 'Y'
       UPDATE inab_file 
          SET inabpost = g_inab.inabpost
        WHERE inab01 = g_inab.inab01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)
           LET g_success = 'N'
           LET g_inab.inabpost = 'N'
        END IF
      DISPLAY BY NAME g_inab.inabpost
   END IF 
   
   IF g_success = 'Y' THEN 
      CALL t311_pic()
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK 
   END IF 

END FUNCTION 

FUNCTION t311_tlfb(p_tlfb01,p_tlfb02,p_tlfb03,p_tlfb04,p_tlfb05,p_inbb02)
DEFINE p_tlfb01     LIKE tlfb_file.tlfb01
DEFINE p_tlfb02     LIKE tlfb_file.tlfb02
DEFINE p_tlfb03     LIKE tlfb_file.tlfb03
DEFINE p_tlfb04     LIKE tlfb_file.tlfb04
DEFINE p_tlfb05     LIKE tlfb_file.tlfb05
DEFINE p_inbb02     LIKE inbb_file.inbb02
DEFINE l_n          LIKE type_file.num5
                     
   INITIALIZE g_tlfb.* TO NULL
   
   #寫tlfb檔
   LET g_tlfb.tlfb01 = p_tlfb01        #條碼編號
   LET g_tlfb.tlfb02 = p_tlfb02        #倉庫
   LET g_tlfb.tlfb03 = p_tlfb03        #庫位
   LET g_tlfb.tlfb04 = p_tlfb04        #批號
   LET g_tlfb.tlfb05 = p_tlfb05        #數量
   IF g_inab.inabpost = 'N' THEN       
      LET g_tlfb.tlfb06 = +1           #加庫存
   ELSE 
      LET g_tlfb.tlfb06 = -1
   END IF   
   LET g_tlfb.tlfb07 = g_inab.inab01   #來源單號
   LET g_tlfb.tlfb08 = p_inbb02        #來源項次

   LET g_tlfb.tlfb11 = 'abat311'       #來源作業程式 
   CALL s_tlfb('','','','','')
     
   #寫imgb檔 -----------------
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM imgb_file
    WHERE imgb01 = g_tlfb.tlfb01
      AND imgb02 = g_tlfb.tlfb02
      AND imgb03 = g_tlfb.tlfb03
      AND imgb04 = g_tlfb.tlfb04
   IF cl_null(l_n) THEN LET l_n = 0 END IF 
   #沒有imgb檔，新增筆imgb檔
   IF l_n = 0 THEN
      CALL s_ins_imgb(g_tlfb.tlfb01,g_tlfb.tlfb02,
                      g_tlfb.tlfb03,g_tlfb.tlfb04,
                      0,'','')
   END IF 
   IF g_success = 'Y' THEN 
      CALL s_up_imgb(g_tlfb.tlfb01,g_tlfb.tlfb02,
                     g_tlfb.tlfb03,g_tlfb.tlfb04,
                     g_tlfb.tlfb05,g_tlfb.tlfb06,'')
   END IF
   
   #過帳還原刪除tlfb_file
   IF g_inab.inabpost = 'Y' THEN 
      IF g_success = 'Y' THEN 
         DELETE FROM tlfb_file 
          WHERE tlfb07 = g_inab.inab01 
            AND tlfb08 = p_inbb02 
            AND tlfb11 = 'abat311'
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("del","tlfb_file",g_inab.inab01,p_inbb02,STATUS,"","",1)
            LET g_success = 'N'
         END IF  
      END IF
   END IF  
END FUNCTION 

FUNCTION t311_undo_post()
DEFINE l_imgb05   LIKE imgb_file.imgb05
DEFINE l_n        LIKE type_file.num5

   IF g_inab.inab01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
    
   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01
   
   IF g_inab.inabconf = 'X' THEN  
      CALL cl_err(g_inab.inab01,'9024',0)
      RETURN
   END IF
   
   IF g_inab.inabpost = 'N' THEN 
      CALL cl_err(g_inab.inab01,'aba-075',0)
      RETURN 
   END IF     

   FOR l_n=1 TO g_rec_b
      LET l_imgb05 = 0  
      SELECT imgb05 INTO l_imgb05 FROM imgb_file
       WHERE imgb01 = g_inbb[l_n].inbb04
         AND imgb02 = g_inbb[l_n].inbb06
         AND imgb03 = g_inbb[l_n].inbb07
         AND imgb04 = g_inbb[l_n].inbb08 
      IF l_imgb05 - g_inbb[l_n].inbb09 < 0 THEN 
         LET g_showmsg = g_inbb[l_n].inbb04 || "|" || g_inbb[l_n].inbb06 || "|" || 
                         g_inbb[l_n].inbb07 || "|" || g_inbb[l_n].inbb08
         CALL cl_err(g_showmsg,'aba076',0)
         RETURN 
      END IF 
   END FOR
              
   IF NOT cl_confirm('asf-663') THEN RETURN END IF
    
   BEGIN WORK

   OPEN t311_cl USING g_inab.inab01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t311_cl INTO g_inab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t311_show() 	    	      	      	      	     	      	 	   
   
   LET g_success = 'Y' 
   
   FOR l_n=1 TO g_rec_b
      CALL t311_tlfb(g_inbb[l_n].inbb04,g_inbb[l_n].inbb06,g_inbb[l_n].inbb07,
                     g_inbb[l_n].inbb08,g_inbb[l_n].inbb09,g_inbb[l_n].inbb02)
      IF g_success = 'N' THEN 
         EXIT FOR 
      END IF 
   END FOR 
 
   IF g_success = 'Y' THEN                        
      CALL t311_show()
      LET g_inab.inabpost = 'N'
      UPDATE inab_file 
         SET inabpost = g_inab.inabpost
       WHERE inab01 = g_inab.inab01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_inab.inab01,SQLCA.sqlcode,0)
         LET g_success = 'N'
         LET g_inab.inabpost = 'Y'              
      END IF
      DISPLAY BY NAME g_inab.inabpost
   END IF 
   
   IF g_success = 'Y' THEN 
      CALL t311_pic()
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK 
   END IF 
END FUNCTION 

FUNCTION t311_x()

   IF g_inab.inab01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF

   SELECT * INTO g_inab.* FROM inab_file
    WHERE inab01 = g_inab.inab01
   
   IF g_inab.inabpost = 'Y' THEN 
      CALL cl_err(g_inab.inab01,'asf-812',0)
      RETURN 
   END IF 
   
   IF g_inab.inabconf = 'Y' THEN 
      CALL cl_err(g_inab.inab01,'9023',0)
      RETURN
   END IF    

   BEGIN WORK
 
   OPEN t311_cl USING g_inab.inab01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t311_cl INTO g_inab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_inab.inab01,SQLCA.sqlcode,1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   #====>作廢/作廢還原功能
   IF cl_void(0,0,g_inab.inabconf) THEN
      LET g_chr = g_inab.inabconf 
      IF g_inab.inabconf = 'N' THEN 
         LET g_inab.inabconf = 'X' 
      ELSE
         LET g_inab.inabconf = 'N' 
      END IF
 
      UPDATE inab_file
         SET inabconf = g_inab.inabconf, 
             inabmodu = g_user,
             inabdate = g_today
       WHERE inab01 = g_inab.inab01 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","inab_file",g_inab.inab01,"",SQLCA.sqlcode,"",
                      "upd inabconf",1) 
         ROLLBACK WORK   
         RETURN         
      END IF
      DISPLAY BY NAME g_inab.inabconf
   END IF

   CALL t311_show()
END FUNCTION 
#DEV-CB0015--add
#DEV-CB0010 
#DEV-D30025--add

