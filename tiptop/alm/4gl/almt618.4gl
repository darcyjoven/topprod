# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt618.4gl
# Descriptions...: 會員卡資訊重計變更作業
# Date & Author..: No.FUN-BA0066 11/10/19 By pauline
# Modify.........: No:TQC-BB0125 11/11/24 by pauline 控卡platn code不是當前營運中心時，不允許執行任何動作
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C30090 11/11/24 by pauline p_ze 錯誤訊息修改 
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30176 12/06/18 by pauline 加入卡開帳及換卡計算邏輯
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C70097 12/07/23 by pauline 計算變更後積分時必須要先把變數清0,避免錯誤
# Modify.........: No.FUN-C90070 12/09/21 By xumm 添加GR打印功能
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20015 13/03/28 By lixh1 整批修改update[確認]/[取消確認]動作時,要一併異動確認異動人員與確認異動日期
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
    g_lqu             RECORD LIKE lqu_file.*,      
    g_lqu_t           RECORD LIKE lqu_file.*,  
    g_lqu_o           RECORD LIKE lqu_file.*, 
    g_lqu01_t         LIKE lqu_file.lqu01,  
    g_lqv             DYNAMIC ARRAY OF RECORD      
        lqv02         LIKE lqv_file.lqv02,    
        lqv03         LIKE lqv_file.lqv03, 
        lqv04         LIKE lqv_file.lqv04, 
        lqv05         LIKE lqv_file.lqv05, 
        lqv06         LIKE lqv_file.lqv06,   
        lqv07         LIKE lqv_file.lqv07,  
        lqv08         LIKE lqv_file.lqv08,    
        lqv09         LIKE lqv_file.lqv09,   
        lqv10         LIKE lqv_file.lqv10,  
        lqv11         LIKE lqv_file.lqv11,   
        lqv12         LIKE lqv_file.lqv12,   
        lqv13         LIKE lqv_file.lqv13,  
        lqv14         LIKE lqv_file.lqv14,    
        lqv15         LIKE lqv_file.lqv15      
                      END RECORD, 
    g_lqv_o           RECORD      
        lqv02         LIKE lqv_file.lqv02,    
        lqv03         LIKE lqv_file.lqv03, 
        lqv04         LIKE lqv_file.lqv04, 
        lqv05         LIKE lqv_file.lqv05, 
        lqv06         LIKE lqv_file.lqv06,   
        lqv07         LIKE lqv_file.lqv07,  
        lqv08         LIKE lqv_file.lqv08,    
        lqv09         LIKE lqv_file.lqv09,   
        lqv10         LIKE lqv_file.lqv10,  
        lqv11         LIKE lqv_file.lqv11,   
        lqv12         LIKE lqv_file.lqv12,   
        lqv13         LIKE lqv_file.lqv13,  
        lqv14         LIKE lqv_file.lqv14,    
        lqv15         LIKE lqv_file.lqv15          
                      END RECORD,
    g_lqv_t           RECORD      
        lqv02         LIKE lqv_file.lqv02,    
        lqv03         LIKE lqv_file.lqv03, 
        lqv04         LIKE lqv_file.lqv04, 
        lqv05         LIKE lqv_file.lqv05, 
        lqv06         LIKE lqv_file.lqv06,   
        lqv07         LIKE lqv_file.lqv07,  
        lqv08         LIKE lqv_file.lqv08,    
        lqv09         LIKE lqv_file.lqv09,   
        lqv10         LIKE lqv_file.lqv10,  
        lqv11         LIKE lqv_file.lqv11,   
        lqv12         LIKE lqv_file.lqv12,   
        lqv13         LIKE lqv_file.lqv13,  
        lqv14         LIKE lqv_file.lqv14,    
        lqv15         LIKE lqv_file.lqv15        
                      END RECORD
DEFINE
         g_wc           STRING, 
         g_wc1          STRING,
         g_sql          STRING,
         l_flag         LIKE type_file.chr1,    
         g_rec_b        LIKE type_file.num5,    #單身筆數 
         l_ac           LIKE type_file.num5     #目前處理的ARRAY CNT  
DEFINE   g_forupd_sql   STRING                  #SELECT ...  FOR UPDATE SQL
DEFINE   g_msg          LIKE ze_file.ze03       
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose
DEFINE   g_before_input_done  LIKE type_file.num5  
DEFINE   g_row_count    LIKE type_file.num10    
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_jump         LIKE type_file.num10    
DEFINE   g_no_ask       LIKE type_file.num5   
DEFINE   g_kindtype     LIKE oay_file.oaytype 
DEFINE   g_kindslip     LIKE oay_file.oayslip  
DEFINE   g_date         LIKE lqr_file.lqrdate
DEFINE   g_modu         LIKE lqr_file.lqrmodu
DEFINE   g_chr          LIKE type_file.chr1     
DEFINE   g_cnt          LIKE type_file.num10    
DEFINE   g_multi_lqv03   STRING 
#FUN-C90070----add---str
DEFINE g_wc2             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lqu01     LIKE lqu_file.lqu01, 
    lqu02     LIKE lqu_file.lqu02,
    lqu03     LIKE lqu_file.lqu03,
    lqu04     LIKE lqu_file.lqu04,
    lquconf   LIKE lqu_file.lquconf,
    lqucond   LIKE lqu_file.lqucond,
    lquconu   LIKE lqu_file.lquconu,
    lqu05     LIKE lqu_file.lqu05,
    lqv02     LIKE lqv_file.lqv02,
    lqv03     LIKE lqv_file.lqv03,
    lqv04     LIKE lqv_file.lqv04,
    lqv05     LIKE lqv_file.lqv05,
    lqv06     LIKE lqv_file.lqv06,
    lqv07     LIKE lqv_file.lqv07,
    lqv08     LIKE lqv_file.lqv08,
    lqv09     LIKE lqv_file.lqv09,
    lqv10     LIKE lqv_file.lqv10,
    lqv11     LIKE lqv_file.lqv11,
    lqv12     LIKE lqv_file.lqv12,
    lqv13     LIKE lqv_file.lqv13,
    lqv14     LIKE lqv_file.lqv14,
    lqv15     LIKE lqv_file.lqv15,
    azf03     LIKE azf_file.azf03,
    gen02_1   LIKE gen_file.gen02,
    gen02_2   LIKE gen_file.gen02
END RECORD
#FUN-C90070----add---end

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   #FUN-C90070------add-----str
   LET g_pdate = g_today
   LET g_sql ="lqu01.lqu_file.lqu01,",
              "lqu02.lqu_file.lqu02,",
              "lqu03.lqu_file.lqu03,",
              "lqu04.lqu_file.lqu04,",
              "lquconf.lqu_file.lquconf,",
              "lqucond.lqu_file.lqucond,",
              "lquconu.lqu_file.lquconu,",
              "lqu05.lqu_file.lqu05,",
              "lqv02.lqv_file.lqv02,",
              "lqv03.lqv_file.lqv03,",
              "lqv04.lqv_file.lqv04,",
              "lqv05.lqv_file.lqv05,",
              "lqv06.lqv_file.lqv06,",
              "lqv07.lqv_file.lqv07,",
              "lqv08.lqv_file.lqv08,",
              "lqv09.lqv_file.lqv09,",
              "lqv10.lqv_file.lqv10,",
              "lqv11.lqv_file.lqv11,",
              "lqv12.lqv_file.lqv12,",
              "lqv13.lqv_file.lqv13,",
              "lqv14.lqv_file.lqv14,",
              "lqv15.lqv_file.lqv15,",
              "azf03.azf_file.azf03,",
              "gen02_1.gen_file.gen02,",
              "gen02_2.gen_file.gen02"
   LET l_table = cl_prt_temptable('almt618',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end
   LET g_forupd_sql = "SELECT * FROM lqu_file WHERE lqu01 = ? FOR UPDATE" 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t618_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t618_w WITH FORM "alm/42f/almt618"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL t618_menu()
   CLOSE t618_cl
   CLOSE WINDOW t618_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN

FUNCTION t618_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
   CLEAR FORM          
   CALL g_lqv.clear()
   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_lqu.* TO NULL    
   CONSTRUCT BY NAME g_wc ON lqu01,lqu02,lqu03,lqu04,lquconf,lqucond,lquconu,lqu05,
                             lquuser,lqugrup,lquoriu,lquorig,lqumodu,lqudate,lquacti,
                             lquud01,lquud02,lquud03,lquud04,lquud05,lquud06,lquud07,
                             lquud08,lquud09,lquud10,lquud11,lquud12,lquud13,lquud14,lquud15
      BEFORE CONSTRUCT
      CALL cl_qbe_init()
 
      ON ACTION controlp 
         CASE
            WHEN INFIELD(lqu01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqu01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqu01
               NEXT FIELD lqu01
      
            WHEN INFIELD(lqu03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqr03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqu03
               NEXT FIELD lqu03
      
            WHEN INFIELD(lqu04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqu04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqu04
               NEXT FIELD lqu04

            WHEN INFIELD(lquconu)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lquconu"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lquconu
               NEXT FIELD lqu04   
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
   IF INT_FLAG THEN
      RETURN 
   END IF 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lquuser', 'lqugrup') 

   CONSTRUCT g_wc1 ON lqv02,lqv03,lqv04,lqv06,lqv05,lqv07,lqv09,lqv08,
                      lqv10,lqv12,lqv13,lqv11,lqv15,lqv14
        FROM s_lqv[1].lqv02,s_lqv[1].lqv03,s_lqv[1].lqv04,s_lqv[1].lqv06,
             s_lqv[1].lqv05,s_lqv[1].lqv07,s_lqv[1].lqv09,s_lqv[1].lqv08,
             s_lqv[1].lqv10,s_lqv[1].lqv12,s_lqv[1].lqv13,s_lqv[1].lqv11,
             s_lqv[1].lqv15,s_lqv[1].lqv14
       
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help() 

      ON ACTION controlg    
         CALL cl_cmdask()  

      ON ACTION controlp
         CASE
            WHEN INFIELD(lqv03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqv031"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqv03
               NEXT FIELD lqv03
            OTHERWISE EXIT CASE      
         END CASE    
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
     # LET INT_FLAG=0
      RETURN
   END IF
   LET g_wc1 = g_wc1 CLIPPED
   LET g_wc  = g_wc  CLIPPED

   IF cl_null(g_wc) THEN
      LET g_wc =" 1=1"
   END IF
   IF cl_null(g_wc1) THEN
      LET g_wc1=" 1=1"
   END IF
   IF g_wc1 = " 1=1" THEN                
      LET g_sql = "SELECT lqu01 FROM lqu_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY lqu01"
   ELSE                             
      LET g_sql = "SELECT UNIQUE lqu_file.lqu01 ",
                  "  FROM lqu_file, lqv_file ",
                  " WHERE lqu01 = lqv01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc1 CLIPPED,
                  " ORDER BY lqu01"
   END IF 
   PREPARE t618_prepare FROM g_sql
   DECLARE t618_cs SCROLL CURSOR WITH HOLD FOR t618_prepare
   IF g_wc1 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM lqu_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lqu01) FROM lqu_file,lqv_file WHERE ",
                "lqu01=lqv01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
   END IF 
   PREPARE t618_precount FROM g_sql
   DECLARE t618_count CURSOR FOR t618_precount   
END FUNCTION

FUNCTION t618_menu()
   WHILE TRUE
      CALL t618_bp("G")
      CASE g_action_choice
         WHEN "insert"                  #新增
            IF cl_chk_act_auth() THEN
               CALL t618_a()
            END IF
 
         WHEN "query"                   #查詢
            IF cl_chk_act_auth() THEN
               CALL t618_q()
            END IF
 
         WHEN "delete"                  #刪除
            IF cl_chk_act_auth() THEN
               CALL t618_r()
            END IF
 
         WHEN "modify"                  #修改
            IF cl_chk_act_auth() THEN
               CALL t618_u()
            END IF
#FUN-C90070------add------str
        WHEN "output"                   #打印
           IF cl_chk_act_auth() THEN
              CALL t618_out()
           END IF
#FUN-C90070------add------end

 
         WHEN "detail"                 #單身
            IF cl_chk_act_auth() THEN
                  CALL t618_b('a')
            END IF 

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "confirm"               #確認
            IF cl_chk_act_auth() THEN
               CALL t618_yes()  
            END IF
        
         WHEN "void"                  #作廢
            IF cl_chk_act_auth() THEN
               CALL t618_v(1)
            END IF  
         #FUN-D20039 ---------sta
         WHEN "undo_void"                 
            IF cl_chk_act_auth() THEN
               CALL t618_v(2)
            END IF
         #FUN-D20039 ---------end

         WHEN "undo_confirm"               #取消確認
            IF cl_chk_act_auth() THEN
               CALL t618_no()  
            END IF 

         WHEN "issues"
            IF cl_chk_act_auth() THEN
               CALL t618_issue()  
            END IF       

      END CASE
   END WHILE     
END FUNCTION

FUNCTION t618_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,   
            l_wc   STRING   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lqv TO s_lqv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                 
 
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

      #FUN-C90070---add---str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-C90070---add---end
      ON ACTION first
         CALL t618_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  

      ON ACTION previous
         CALL t618_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

      ON ACTION jump
         CALL t618_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL t618_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

      ON ACTION last
         CALL t618_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY 

      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20039 ----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ----------end

      ON ACTION issues
         LET g_action_choice="issues"
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

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION t618_a()
DEFINE li_result   LIKE type_file.num5   
   CLEAR FORM
   LET g_success = 'Y'
   
   CALL g_lqv.clear()

   LET g_wc = NULL
   LET g_wc1= NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lqu.* LIKE lqu_file.*         
   LET g_lqu01_t = NULL
   LET g_lqu_t.* = g_lqu.*
   LET g_lqu_o.* = g_lqu.*
   CALL cl_opmsg('a')
   
   WHILE TRUE
      LET g_lqu.lquuser = g_user
      LET g_lqu.lquacti = 'Y'
      LET g_lqu.lquoriu = g_user 
      LET g_lqu.lquorig = g_grup 
      LET g_lqu.lqugrup = g_grup
      LET g_lqu.lquconf = 'N'
      LET g_lqu.lqu02 = g_today
      LET g_lqu.lquplant = g_plant
      LET g_lqu.lqulegal = g_legal
      LET g_lqu.lqu05 = '0'
      LET g_lqu.lqu04 = g_user
      DISPLAY BY NAME g_lqu.lqu04
      CALL t618_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                  
         INITIALIZE g_lqu.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lqu.lqu01) THEN    
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lqu.lqu01,g_lqu.lqu02,"O3","lqu_file","lqu01","","","")
        RETURNING li_result,g_lqu.lqu01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lqu.lqu01
 
      INSERT INTO lqu_file VALUES (g_lqu.*)    
 
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","lqu_file",g_lqu.lqu01,"",SQLCA.sqlcode,"","",1)                  
         ROLLBACK WORK      
         CONTINUE WHILE
      ELSE
         COMMIT WORK      
         CALL cl_flow_notify(g_lqu.lqu01,'I')
      END IF
 
      SELECT * INTO g_lqu.* FROM lqu_file
       WHERE lqu01 = g_lqu.lqu01
      LET g_lqu01_t = g_lqu.lqu01       
      LET g_lqu_t.* = g_lqu.*
      LET g_lqu_o.* = g_lqu.*
      CALL g_lqv.clear()

      LET g_rec_b = 0  
      CALL t618_b('a')                 
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t618_u()
DEFINE l_n       LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqu.lqu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_lqu.lquacti='N' THEN 
      CALL cl_err(g_lqu.lqu01,'alm-147',1)
      RETURN 
   END IF  
   IF g_lqu.lquconf='Y' THEN
      CALL cl_err(g_lqu.lqu01,9022,1)
      RETURN
   END IF
   IF g_lqu.lquconf='X' THEN
      CALL cl_err(g_lqu.lqu01,9022,1)
      RETURN
   END IF      
   SELECT * INTO g_lqu.* FROM lqu_file
    WHERE lqu01=g_lqu.lqu01
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lqu01_t = g_lqu.lqu01
   BEGIN WORK
 
   OPEN t618_cl USING g_lqu_t.lqu01
   IF STATUS THEN
      CALL cl_err("OPEN t618_cl:", STATUS, 1)
      CLOSE t618_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t618_cl INTO g_lqu.*                    
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lqu.lqu01,SQLCA.sqlcode,0)   
       CLOSE t618_cl
       ROLLBACK WORK
       RETURN
   END IF
  
  LET g_date = g_lqu.lqudate
  LET g_modu = g_lqu.lqumodu  
                                                                      
   CALL t618_show()
 
   WHILE TRUE
      LET g_lqu01_t = g_lqu.lqu01
      LET g_lqu_o.* = g_lqu.*
      LET g_lqu_t.* = g_lqu.*
      LET g_lqu.lqumodu=g_user
      LET g_lqu.lqudate=g_today
      CALL t618_i("u")    
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lqu_t.lqudate = g_date
         LET g_lqu_t.lqumodu = g_modu
         LET g_lqu.*=g_lqu_t.*         
         CALL t618_show()
         CALL cl_err('',9001,0)     
         RETURN        
         EXIT WHILE
      END IF
      IF g_lqu.lqu01 != g_lqu01_t THEN           
         UPDATE lqv_file SET lqv01 = g_lqu.lqu01
          WHERE lqv01 = g_lqv01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqv_file",g_lqu01_t,"",SQLCA.sqlcode,"","lqv",1)
            CONTINUE WHILE
         END IF
      END IF
      UPDATE lqu_file SET lqu_file.* = g_lqu.*
       WHERE lqu01 = g_lqu01_t  
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lqu_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
            
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t618_cl
   COMMIT WORK
   
   CALL cl_flow_notify(g_lqu.lqu01,'U')
   CALL t618_show()
   CALL t618_b_fill("1=1")
END FUNCTION

FUNCTION t618_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1    
DEFINE    li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lqu.lqu01,g_lqu.lqu02,g_lqu.lqu03,g_lqu.lqu04,g_lqu.lqu05,
                   g_lqu.lquuser,g_lqu.lqumodu,g_lqu.lqugrup,g_lqu.lqudate,
                   g_lqu.lquacti,g_lqu.lquoriu,g_lqu.lquorig,g_lqu.lquconf,
                   g_lqu.lquud01,g_lqu.lquud02,g_lqu.lquud03,g_lqu.lquud04,
                   g_lqu.lquud05,g_lqu.lquud06,g_lqu.lquud07,g_lqu.lquud08,
                   g_lqu.lquud09,g_lqu.lquud10,g_lqu.lquud11,g_lqu.lquud12,
                   g_lqu.lquud13,g_lqu.lquud14,g_lqu.lquud15,g_lqu.lqucond,
                   g_lqu.lquconu
  
   INPUT BY NAME g_lqu.lqu01,g_lqu.lqu02,g_lqu.lqu03,g_lqu.lqu04,
                 g_lqu.lquud01,g_lqu.lquud02,g_lqu.lquud03,g_lqu.lquud04,
                 g_lqu.lquud05,g_lqu.lquud06,g_lqu.lquud07,g_lqu.lquud08,
                 g_lqu.lquud09,g_lqu.lquud10,g_lqu.lquud11,g_lqu.lquud12,
                 g_lqu.lquud13,g_lqu.lquud14,g_lqu.lquud15
            WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t618_set_entry(p_cmd)
         CALL t618_set_no_entry(p_cmd)
         CALL cl_set_docno_format("lqu01")
         LET g_before_input_done = TRUE  
 
      AFTER FIELD lqu01
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF NOT cl_null(g_lqu.lqu01) THEN
            IF g_lqu.lqu01 != g_lqu_t.lqu01
                OR g_lqu_t.lqu01 IS NULL THEN         
               CALL s_check_no("alm",g_lqu.lqu01,g_lqu01_t,"Q1","lqu_file","lqu01","")
                    RETURNING li_result,g_lqu.lqu01
               IF (NOT li_result) THEN
                  LET g_lqu.lqu01=g_lqu_t.lqu01
                  NEXT FIELD lqu01
               END IF
                DISPLAY BY NAME g_lqu.lqu01
            END IF   
         END IF    
      AFTER FIELD lqu03
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF NOT cl_null(g_lqu.lqu03) THEN  
            IF g_lqu.lqu03 != g_lqu_t.lqu03
                OR g_lqu_t.lqu03 IS NULL THEN       
               LET g_errno = ''  
               CALL t618_lqu03('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lqu03
               END IF   
            END IF   
         END IF   
      AFTER FIELD lqu04
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF NOT cl_null(g_lqu.lqu04) THEN
            IF g_lqu.lqu04 != g_lqu_t.lqu04
                OR g_lqu_t.lqu04 IS NULL THEN     
               LET g_errno = ''   
               CALL t618_lqu04('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lqu04
               END IF   
            END IF   
         END IF   
      AFTER FIELD lquud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
      AFTER INPUT
         LET g_lqu.lquuser = s_get_data_owner("lqu_file") #FUN-C10039
         LET g_lqu.lqugrup = s_get_data_group("lqu_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         LET g_errno = ''
         CALL t618_lqu03('a')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lqu03
            END IF
         LET g_errno = ''
         CALL t618_lqu04('a') 
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lqu04
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION controlp
         CASE    
            WHEN INFIELD(lqu01)
               LET g_kindslip = s_get_doc_no(g_lqu.lqu01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'Q1','ALM') RETURNING g_kindslip 
               LET g_lqu.lqu01 = g_kindslip
               DISPLAY BY NAME g_lqu.lqu01
               NEXT FIELD lqu01
            WHEN INFIELD(lqu03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf01a"
               LET g_qryparam.arg1 = "I"
               CALL cl_create_qry() RETURNING g_lqu.lqu03
               DISPLAY BY NAME g_lqu.lqu03   
               CALL t618_lqu03('a')           
               NEXT FIELD lqu03    
            WHEN INFIELD(lqu04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_lqu.lqu04
               DISPLAY BY NAME g_lqu.lqu04  
               CALL t618_lqu04('a')            
               NEXT FIELD lqu04    
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

FUNCTION t618_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lqv.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t618_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lqu.* TO NULL
      RETURN
   END IF
 
   OPEN t618_cs                          
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lqu.* TO NULL
   ELSE
      OPEN t618_count
      FETCH t618_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t618_fetch('F')                  
   END IF
END FUNCTION

FUNCTION t618_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t618_cs INTO g_lqu.lqu01
      WHEN 'P' FETCH PREVIOUS t618_cs INTO g_lqu.lqu01
      WHEN 'F' FETCH FIRST    t618_cs INTO g_lqu.lqu01
      WHEN 'L' FETCH LAST     t618_cs INTO g_lqu.lqu01
      WHEN '/'
            IF (NOT g_no_ask) THEN     
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about         
                     CALL cl_about()      
 
                  ON ACTION HELP          
                     CALL cl_show_help()  
 
                  ON ACTION controlg     
                     CALL cl_cmdask()     
               END PROMPT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t618_cs INTO g_lqu.lqu01
            LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqu.lqu01,SQLCA.sqlcode,0)
      INITIALIZE g_lqu.* TO NULL              
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
 
   SELECT * INTO g_lqu.* FROM lqu_file WHERE lqu01 = g_lqu.lqu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lqu_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lqu.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lqu.lquuser        
   LET g_data_group = g_lqu.lqugrup     
   LET g_data_plant = g_lqu.lquplant    #TQC-BB0125 add

   CALL t618_show()
END FUNCTION

FUNCTION t618_show()
DEFINE l_gen02     LIKE gen_file.gen02
   LET g_lqu_t.* = g_lqu.*                
   LET g_lqu_o.* = g_lqu.*                
   LET g_lqu01_t = g_lqu.lqu01
   DISPLAY BY NAME g_lqu.lqu01,g_lqu.lqu02,g_lqu.lqu03,g_lqu.lqu04,g_lqu.lqu05,
                   g_lqu.lquuser,g_lqu.lqumodu,g_lqu.lqugrup,g_lqu.lqudate,
                   g_lqu.lquacti,g_lqu.lquoriu,g_lqu.lquorig,g_lqu.lquconf,
                   g_lqu.lquud01,g_lqu.lquud02,g_lqu.lquud03,g_lqu.lquud04,
                   g_lqu.lquud05,g_lqu.lquud06,g_lqu.lquud07,g_lqu.lquud08,
                   g_lqu.lquud09,g_lqu.lquud10,g_lqu.lquud11,g_lqu.lquud12,
                   g_lqu.lquud13,g_lqu.lquud14,g_lqu.lquud15,g_lqu.lquconu,
                   g_lqu.lqucond
                   
   CALL t618_lqu03('d')
   CALL t618_lqu04('d')
   CALL t618_pic()
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lqu.lquconu
   DISPLAY l_gen02 TO FORMONLY.lquconu_desc
   CALL t618_b_fill(g_wc1)              
   CALL cl_show_fld_cont()    
END FUNCTION

FUNCTION t618_r()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqu.lqu01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_lqu.lquacti='N' THEN 
      CALL cl_err(g_lqu.lqu01,'alm-147',1)
      RETURN 
   END IF   
   IF g_lqu.lquconf='X' OR g_lqu.lqu05 = '1' OR g_lqu.lquconf = 'Y' THEN
      CALL cl_err('','alm-667',1)
      RETURN
   END IF
   IF g_lqu.lqu05 = '2' THEN
      CALL cl_err('','alm1155',1)
      RETURN
   END IF      
   SELECT * INTO g_lqu.* FROM lqu_file
    WHERE lqu01=g_lqu.lqu01 
   BEGIN WORK
 
   OPEN t618_cl USING g_lqu_t.lqu01
   IF STATUS THEN
      CALL cl_err("OPEN t618_cl:", STATUS, 1)
      CLOSE t618_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t618_cl INTO g_lqu.*              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqu.lqu01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t618_show()
 
   IF cl_delh(0,0) THEN                   
      INITIALIZE g_doc.* TO NULL         
      LET g_doc.column1 = "lqu01"       
      LET g_doc.value1 = g_lqu.lqu01    
      CALL cl_del_doc()                                                            
      DELETE FROM lqu_file WHERE lqu01 = g_lqu_t.lqu01 
      DELETE FROM lqv_file WHERE lqv01 = g_lqu_t.lqu01 
          
      CLEAR FORM
      CALL g_lqv.clear()
      OPEN t618_count
      IF STATUS THEN
         CLOSE t618_cs
         CLOSE t618_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t618_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t618_cs
         CLOSE t618_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t618_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t618_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE     
         CALL t618_fetch('/')
      END IF
   END IF
 
   CLOSE t618_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqu.lqu01,'D')
END FUNCTION

FUNCTION t618_b(p_w)
DEFINE   l_ac_t          LIKE type_file.num5               
DEFINE   l_n             LIKE type_file.num5    
DEFINE   l_n1            LIKE type_file.num5      
DEFINE   l_n2            LIKE type_file.num5         
DEFINE   l_cnt           LIKE type_file.num5             
DEFINE   l_lock_sw       LIKE type_file.chr1            
DEFINE   p_cmd           LIKE type_file.chr1               
DEFINE   l_allow_insert  LIKE type_file.num5               
DEFINE   l_allow_delete  LIKE type_file.num5     
DEFINE   p_w             LIKE type_file.chr1

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lqu.lqu01 IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    IF g_lqu.lquacti='N' THEN 
       CALL cl_err(g_lqu.lqu01,'alm-147',1)
       RETURN 
    END IF   
   IF g_lqu.lquconf='Y' THEN
      CALL cl_err(g_lqu.lqu01,9022,1)
      RETURN
   END IF
   IF g_lqu.lquconf='X' THEN
      CALL cl_err(g_lqu.lqu01,9022,1)
      RETURN
   END IF      
    SELECT * INTO g_lqu.* FROM lqu_file
     WHERE lqu01=g_lqu.lqu01
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT lqv02,lqv03,lqv04,lqv05,lqv06,lqv07,lqv08,lqv09,lqv10,lqv11,lqv12,lqv13,lqv14,lqv15",
                       " FROM lqv_file", 
                       " WHERE lqv01 =? and lqv02 =? ",
                       "  FOR UPDATE "
                         
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t618_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_lqv WITHOUT DEFAULTS FROM s_lqv.*
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
 
           OPEN t618_cl USING g_lqu.lqu01
           IF STATUS THEN
              CALL cl_err("OPEN t618_cl:", STATUS, 1)
              CLOSE t618_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t618_cl INTO g_lqu.*           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lqu.lqu01,SQLCA.sqlcode,0)     
              CLOSE t618_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lqv_t.* = g_lqv[l_ac].*  
              LET g_lqv_o.* = g_lqv[l_ac].*  
              OPEN t618_bcl USING g_lqu.lqu01,g_lqv[l_ac].lqv02
              IF STATUS THEN
                 CALL cl_err("OPEN t618_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t618_bcl INTO g_lqv[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lqv_t.lqv02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE 
                #	  CALL t618_lqv(l_ac)                    
                 END IF   
              END IF
              CALL cl_show_fld_cont()    
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lqv[l_ac].* TO NULL
           LET g_lqv_t.* = g_lqv[l_ac].*       
           LET g_lqv_o.* = g_lqv[l_ac].*   
           CALL cl_show_fld_cont()        
           NEXT FIELD lqv02
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF          
           IF cl_null(g_lqv[l_ac].lqv03) THEN
              CALL cl_err('','alm-062',1)
              NEXT FIELD lqv03 
           END IF
           
           IF l_flag = 'Y' THEN  
              INSERT INTO lqv_file(lqv01,lqv02,lqv03,lqv04,lqv05,lqv06,lqv07,lqv08,lqv09,lqv10
                                  ,lqv11,lqv12,lqv13,lqv14,lqv15,lqvlegal,lqvplant)
              VALUES(g_lqu.lqu01,g_lqv[l_ac].lqv02,
                     g_lqv[l_ac].lqv03,g_lqv[l_ac].lqv04,
                     g_lqv[l_ac].lqv05,g_lqv[l_ac].lqv06,g_lqv[l_ac].lqv07,g_lqv[l_ac].lqv08,
                     g_lqv[l_ac].lqv09,g_lqv[l_ac].lqv10,g_lqv[l_ac].lqv11,g_lqv[l_ac].lqv12,
                     g_lqv[l_ac].lqv13,g_lqv[l_ac].lqv14,g_lqv[l_ac].lqv15,g_legal,g_plant)
              IF SQLCA.sqlcode THEN                   
                 CALL cl_err3("ins","lqu_file",g_lqu.lqu01,"",SQLCA.sqlcode,"","",1)     
                 CANCEL INSERT
              ELSE
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
           #      CALL t618_lqv(l_ac)   
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
           ELSE
              CALL s_showmsg() 
              ROLLBACK WORK  
           END IF   
        BEFORE FIELD lqv02                       
           IF g_lqv[l_ac].lqv02 IS NULL OR g_lqv[l_ac].lqv02 = 0 THEN
              SELECT max(lqv02)+1
                INTO g_lqv[l_ac].lqv02
                FROM lqv_file
               WHERE lqv01 = g_lqu.lqu01
              IF g_lqv[l_ac].lqv02 IS NULL THEN
                 LET g_lqv[l_ac].lqv02 = 1
              END IF
           END IF
 
        AFTER FIELD lqv02                      
          IF NOT cl_null(g_lqv[l_ac].lqv02) THEN
             IF g_lqv[l_ac].lqv02 != g_lqv_t.lqv02
                OR g_lqv_t.lqv02 IS NULL THEN
                IF g_lqv[l_ac].lqv02 <= 0 THEN
                   CALL cl_err('','aec-994',0)
                   NEXT FIELD lqv02
                END IF
                SELECT COUNT(*)
                  INTO l_n
                  FROM lqv_file
                 WHERE lqv01 = g_lqu.lqu01
                   AND lqv02 = g_lqv[l_ac].lqv02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_lqv[l_ac].lqv02 = g_lqv_t.lqv02
                   NEXT FIELD lqv02
                ELSE
                   LET l_flag = 'Y'      
                END IF
             END IF
          END IF  
       AFTER FIELD lqv03
           IF NOT cl_null(g_lqv[l_ac].lqv03) THEN
              LET l_n = 0 
              SELECT count(*) INTO l_n FROM lpj_file
                     WHERE lpj03 = g_lqv[l_ac].lqv03
              IF l_n < 1 OR cl_null(l_n) THEN
                 CALL cl_err('','alm-894',0)
                 NEXT FIELD lqv03
              END IF
              LET l_n = 0 
              SELECT count(*) INTO l_n FROM lqv_file
                  WHERE lqv03 = g_lqv[l_ac].lqv03
                   AND  lqv01 = g_lqu.lqu01
                   AND  lqv02 <> g_lqv[l_ac].lqv02
              IF l_n > 0 THEN
                 CALL cl_err('','alm-893',0)
                 NEXT FIELD lqv03
              END IF
              LET g_errno = ''
              CALL t618_lqv03(g_lqv[l_ac].lqv03)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lqv[l_ac].lqv03,g_errno , 0)
                 LET g_lqv[l_ac].lqv04 = ''
                 LET g_lqv[l_ac].lqv05 = ''
                 LET g_lqv[l_ac].lqv06 = ''
                 LET g_lqv[l_ac].lqv07 = ''
                 LET g_lqv[l_ac].lqv08 = ''
                 LET g_lqv[l_ac].lqv09 = ''
                 LET g_lqv[l_ac].lqv10 = ''
                 LET g_lqv[l_ac].lqv11 = ''
                 LET g_lqv[l_ac].lqv12 = ''
                 LET g_lqv[l_ac].lqv13 = ''
                 LET g_lqv[l_ac].lqv14 = ''
                 LET g_lqv[l_ac].lqv15 = ''
                 NEXT FIELD lqv03
              END IF  
              LET g_errno = ''
              IF (cl_null(g_lqv_t.lqv03) AND NOT cl_null(g_lqv[l_ac].lqv03))
                 OR g_lqv_t.lqv03 <> g_lqv[l_ac].lqv03 THEN
                 CALL t618_lqv03_b(g_lqv[l_ac].lqv03)
                     RETURNING g_lqv[l_ac].lqv04, g_lqv[l_ac].lqv05, g_lqv[l_ac].lqv06,
                               g_lqv[l_ac].lqv07, g_lqv[l_ac].lqv08, g_lqv[l_ac].lqv09,
                               g_lqv[l_ac].lqv10, g_lqv[l_ac].lqv11, g_lqv[l_ac].lqv12,
                               g_lqv[l_ac].lqv13, g_lqv[l_ac].lqv14, g_lqv[l_ac].lqv15
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lqv[l_ac].lqv03,g_errno,0)
                    NEXT FIELD lqv03
                 END IF
              END IF
           END IF
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_lqv_t.lqv03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 0)
                 CANCEL DELETE
              END IF
              DELETE FROM lqv_file
               WHERE lqv01 = g_lqu.lqu01
                 AND lqv02 = g_lqv_t.lqv02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lqv_file",g_lqu.lqu01,g_lqv_t.lqv03,SQLCA.sqlcode,"","",1)  
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
              LET g_lqv[l_ac].* = g_lqv_t.*
              CLOSE t618_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lqv[l_ac].lqv03,-263,1)
              LET g_lqv[l_ac].* = g_lqv_t.*
           ELSE 
              IF l_flag = 'Y' THEN        
                 UPDATE lqv_file SET lqv02=g_lqv[l_ac].lqv02,
                                     lqv03=g_lqv[l_ac].lqv03,
                                     lqv04=g_lqv[l_ac].lqv04,
                                     lqv05=g_lqv[l_ac].lqv05,
                                     lqv06=g_lqv[l_ac].lqv06,
                                     lqv07=g_lqv[l_ac].lqv07,
                                     lqv08=g_lqv[l_ac].lqv08,
                                     lqv09=g_lqv[l_ac].lqv09,
                                     lqv10=g_lqv[l_ac].lqv10,
                                     lqv11=g_lqv[l_ac].lqv11,
                                     lqv12=g_lqv[l_ac].lqv12,
                                     lqv13=g_lqv[l_ac].lqv13,
                                     lqv14=g_lqv[l_ac].lqv14,
                                     lqv15=g_lqv[l_ac].lqv15,
                                     lqvlegal=g_legal,
                                     lqvplant=g_plant   
                  WHERE lqv01 = g_lqu.lqu01
                    AND lqv02 = g_lqv_t.lqv02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","lqv_file",g_lqu.lqu01,g_lqv_t.lqv03,SQLCA.sqlcode,"","",1)  
                    LET g_lqv[l_ac].* = g_lqv_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
              ELSE
                 CALL s_showmsg()
                 ROLLBACK WORK   
              END IF   
           END IF
 
        AFTER ROW 
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lqv[l_ac].* = g_lqv_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lqv.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end-- 
              END IF
              CLOSE t618_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30033 Add
           CLOSE t618_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄�
           IF INFIELD(lqv03) AND l_ac > 1 THEN
              LET g_lqv[l_ac].* = g_lqv[l_ac-1].*
              LET g_lqv[l_ac].lqv02 = g_rec_b + 1
              NEXT FIELD lqv02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()       
 
        ON ACTION controlp
           CASE          
             WHEN INFIELD(lqv03) 
               CALL cl_init_qry_var()               
               LET g_qryparam.form ="q_lpj07" 
               LET g_qryparam.default1 = g_lqv[l_ac].lqv03 
               CALL cl_create_qry() RETURNING g_lqv[l_ac].lqv03
               IF NOT cl_null(g_lqv[l_ac].lqv03) THEN
                  DISPLAY BY NAME g_lqv[l_ac].lqv03
                  LET g_errno = ''
                  CALL t618_lqv03(g_lqv[l_ac].lqv03)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_lqv[l_ac].lqv03,g_errno,1)
                     LET g_lqv[l_ac].lqv04 = ''        
                     LET g_lqv[l_ac].lqv05 = ''
                     LET g_lqv[l_ac].lqv06 = ''
                     LET g_lqv[l_ac].lqv07 = ''
                     LET g_lqv[l_ac].lqv08 = ''
                     LET g_lqv[l_ac].lqv09 = ''
                     LET g_lqv[l_ac].lqv10 = ''
                     LET g_lqv[l_ac].lqv11 = ''
                     LET g_lqv[l_ac].lqv12 = ''
                     LET g_lqv[l_ac].lqv13 = ''
                     LET g_lqv[l_ac].lqv14 = ''
                     LET g_lqv[l_ac].lqv15 = ''
                     NEXT FIELD lqv03
                  END IF
                  LET g_errno = ''  
                  IF (cl_null(g_lqv_t.lqv03) AND NOT cl_null(g_lqv[l_ac].lqv03))
                    OR g_lqv_t.lqv03 <> g_lqv[l_ac].lqv03 THEN
                      CALL t618_lqv03_b(g_lqv[l_ac].lqv03)
                         RETURNING g_lqv[l_ac].lqv04, g_lqv[l_ac].lqv05, g_lqv[l_ac].lqv06,
                                   g_lqv[l_ac].lqv07, g_lqv[l_ac].lqv08, g_lqv[l_ac].lqv09,
                                   g_lqv[l_ac].lqv10, g_lqv[l_ac].lqv11, g_lqv[l_ac].lqv12,
                                   g_lqv[l_ac].lqv13, g_lqv[l_ac].lqv14, g_lqv[l_ac].lqv15
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_lqv[l_ac].lqv03,g_errno,0)
                         NEXT FIELD lqv03
                     END IF
                  END IF
               END IF
               NEXT FIELD lqv03   
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
 
        ON ACTION HELP          
           CALL cl_show_help()  
 
        ON ACTION controls                              
           CALL cl_set_head_visible("","AUTO")      
    END INPUT
  
    IF p_w = 'u' THEN 
       LET g_lqu.lqumodu = g_user
       LET g_lqu.lqudate = g_today
    ELSE
   	   LET g_lqu.lqumodu = NULL
       LET g_lqu.lqudate = NULL 
   	END IF     
    UPDATE lqu_file SET lqumodu = g_lqu.lqumodu,
                        lqudate = g_lqu.lqudate
     WHERE lqu01 = g_lqu.lqu01
    
    DISPLAY BY NAME g_lqu.lqumodu,g_lqu.lqudate
  
    CLOSE t618_bcl
    COMMIT WORK
#   CALL t618_delall()        #CHI-C30002 mark
    CALL t618_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t618_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lqu.lqu01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lqu_file ",
                  "  WHERE lqu01 LIKE '",l_slip,"%' ",
                  "    AND lqu01 > '",g_lqu.lqu01,"'"
      PREPARE t618_pb1 FROM l_sql 
      EXECUTE t618_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t618_v(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lqu_file WHERE lqu01 = g_lqu.lqu01
         INITIALIZE g_lqu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t618_delall()
#  SELECT COUNT(*) INTO g_cnt FROM lqv_file
#   WHERE lqv01 = g_lqu.lqu01
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM lqu_file WHERE lqu01 = g_lqu.lqu01
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t618_b_fill(p_wc1)
DEFINE  p_wc1    STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
    
   LET g_sql = "SELECT lqv02,lqv03,lqv04,lqv05,lqv06,lqv07,lqv08,lqv09,lqv10,lqv11,",
               "       lqv12,lqv13,lqv14,lqv15 FROM lqv_file",
               " WHERE lqv01 ='",g_lqu.lqu01,"' "
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lqv02 "  
   DISPLAY g_sql
   PREPARE t618_pb FROM g_sql
   DECLARE lqv_cs CURSOR FOR t618_pb
 
   CALL g_lqv.clear()
   LET g_cnt = 1
 
   FOREACH lqv_cs INTO g_lqv[g_cnt].*  
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
   CALL g_lqv.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t618_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1     
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lqu01",TRUE)
    END IF
END FUNCTION
FUNCTION t618_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1   
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lqu01",FALSE)
   END IF
END FUNCTION

FUNCTION t618_yes() 
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_f        LIKE type_file.chr1
DEFINE l_gen02    LIKE  gen_file.gen02
DEFINE l_lqv03                 LIKE lqv_file.lqv03
DEFINE l_lqv04_o               LIKE lqv_file.lqv04
DEFINE l_lqv05_o               LIKE lqv_file.lqv05
DEFINE l_lqv06_o               LIKE lqv_file.lqv06
DEFINE l_lqv07_o               LIKE lqv_file.lqv07
DEFINE l_lqv08_o               LIKE lqv_file.lqv08
DEFINE l_lqv09_o               LIKE lqv_file.lqv09
DEFINE l_lqv10_o               LIKE lqv_file.lqv10
DEFINE l_lqv11_o               LIKE lqv_file.lqv11
DEFINE l_lqv12_o               LIKE lqv_file.lqv12
DEFINE l_lqv13_o               LIKE lqv_file.lqv13
DEFINE l_lqv14_o               LIKE lqv_file.lqv14
DEFINE l_lqv15_o               LIKE lqv_file.lqv15
DEFINE l_lqv04                 LIKE lqv_file.lqv04
DEFINE l_lqv05                 LIKE lqv_file.lqv05
DEFINE l_lqv06                 LIKE lqv_file.lqv06
DEFINE l_lqv07                 LIKE lqv_file.lqv07
DEFINE l_lqv08                 LIKE lqv_file.lqv08
DEFINE l_lqv09                 LIKE lqv_file.lqv09
DEFINE l_lqv10                 LIKE lqv_file.lqv10
DEFINE l_lqv11                 LIKE lqv_file.lqv11
DEFINE l_lqv12                 LIKE lqv_file.lqv12
DEFINE l_lqv13                 LIKE lqv_file.lqv13
DEFINE l_lqv14                 LIKE lqv_file.lqv14
DEFINE l_lqv15                 LIKE lqv_file.lqv15
   IF cl_null(g_lqu.lqu01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
#CHI-C30107 ----------------- add --------------- begin
   IF g_lqu.lquacti='N' THEN
      CALL cl_err('','alm-048',0)
      RETURN
   END IF

   IF g_lqu.lquconf='Y' AND g_lqu.lqu05 = '1' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_lqu.lqu05 = '2' THEN
      CALL cl_err('','alm-942',0)
      RETURN
   END IF

   IF g_lqu.lquconf = 'X' THEN
      CALL cl_err('','alm-674',0)
      RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
      RETURN
   END IF
#CHI-C30107 ----------------- add --------------- end
   SELECT * INTO g_lqu.* FROM lqu_file WHERE lqu01=g_lqu.lqu01 
   IF g_lqu.lquacti='N' THEN
      CALL cl_err('','alm-048',0)
      RETURN
   END IF
   
   IF g_lqu.lquconf='Y' AND g_lqu.lqu05 = '1' THEN 
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_lqu.lqu05 = '2' THEN
      CALL cl_err('','alm-942',0)
      RETURN
   END IF

   IF g_lqu.lquconf = 'X' THEN
      CALL cl_err('','alm-674',0)
      RETURN
   END IF   
   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   OPEN t618_cl USING g_lqu.lqu01
   IF STATUS THEN
      CALL cl_err("OPEN t618_cl:", STATUS, 1)
      CLOSE t618_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t618_cl INTO g_lqu.*    
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lqu.lqu01,SQLCA.sqlcode,0)      
         CLOSE t618_cl
         ROLLBACK WORK
         RETURN
      END IF
   LET l_f = 'Y'
   LET l_sql = " SELECT lqv03,lqv04,lqv05,lqv06,lqv07,lqv08,lqv09, ",
               "        lqv10,lqv11,lqv12,lqv13,lqv14,lqv15",
               " FROM lqv_file",
               " WHERE lqv01 = '",g_lqu.lqu01,"'"
   PREPARE t618_pre1 FROM l_sql
   DECLARE t618_cl1 CURSOR FOR t618_pre1
   FOREACH t618_cl1 INTO l_lqv03,l_lqv04_o,l_lqv05_o,l_lqv06_o,l_lqv07_o,l_lqv08_o,l_lqv09_o,
                         l_lqv10_o, l_lqv11_o, l_lqv12_o, l_lqv13_o, l_lqv14_o, l_lqv15_o
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL t618_lqv03_b(l_lqv03) RETURNING l_lqv04, l_lqv05, l_lqv06, l_lqv07, l_lqv08, l_lqv09,
                                            l_lqv10, l_lqv11, l_lqv12, l_lqv13, l_lqv14, l_lqv15
       IF l_lqv04_o <> l_lqv04 OR
          l_lqv05_o <> l_lqv05 OR
          l_lqv06_o <> l_lqv06 OR
          l_lqv07_o <> l_lqv07 OR
          l_lqv08_o <> l_lqv08 OR
          l_lqv09_o <> l_lqv09 OR 
          l_lqv10_o <> l_lqv10 OR
          l_lqv11_o <> l_lqv11 OR
          l_lqv12_o <> l_lqv12 OR
          l_lqv13_o <> l_lqv13 OR
          l_lqv14_o <> l_lqv14 OR
          l_lqv15_o <> l_lqv15 THEN
          LET l_f = 'N'
          CALL s_errmsg('lqv03',l_lqv03,l_lqv03,'alm1156',1)
       END IF
   END FOREACH
   IF l_f = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF
     
      LET l_cnt = 1
      IF l_f ='Y' THEN
#CHI-C30107 ------------ mark---------------- begin
#        IF NOT cl_confirm('alm-006') THEN 
#           RETURN
#        END IF
#CHI-C30107 ------------ mark---------------- end
         UPDATE lqu_file SET lqu05 = '1',lquconf = 'Y',lqumodu = g_user,lqudate = g_today,
                             lquconu = g_user,lqucond = g_today 
          WHERE lqu01 = g_lqu.lqu01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqu_file",g_lqu.lqu01,"",STATUS,"","",1) 
            LET g_success = 'N'
         ELSE 
            LET g_lqu.lqu05 = '1'
            LET g_lqu.lquconf = 'Y'
            LET g_lqu.lqumodu = g_user
            LET g_lqu.lqudate = g_today
            LET g_lqu.lquconu = g_user
            LET g_lqu.lqucond = g_today
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lqu.lquconu
            DISPLAY l_gen02 TO FORMONLY.lquconu_desc
            DISPLAY BY NAME g_lqu.lqu05,g_lqu.lquconf,g_lqu.lqumodu,g_lqu.lqudate,g_lqu.lqucond,g_lqu.lquconu
            CALL t618_pic()
         END IF 
      END IF
      IF g_success = 'Y' AND l_f = 'Y' THEN
         COMMIT WORK
      ELSE
         CALL s_showmsg()
         ROLLBACK WORK
      END IF
END FUNCTION

FUNCTION t618_no()
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_gen02 LIKE gen_file.gen02    #CHI-D20015
   IF cl_null(g_lqu.lqu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lqu.*
   FROM lqu_file
   WHERE lqu01=g_lqu.lqu01
   IF g_lqu.lquacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lqu.lquconf='N' THEN
      CALL cl_err('','alm-896',0)
      RETURN
   END IF

   IF g_lqu.lqu05 = '2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF

   IF g_lqu.lquconf = 'X' THEN
      CALL cl_err('','alm-895',0)
      RETURN
   END IF   
   IF g_lqu.lquconf = 'Y' AND g_lqu.lqu05 = '1' THEN
      BEGIN WORK
      LET g_success = 'Y'
      OPEN t618_cl USING g_lqu.lqu01
      IF STATUS THEN
         CALL cl_err("OPEN t618_cl:", STATUS, 0)
         CLOSE t618_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH t618_cl INTO g_lqu.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lqu.lqu01,SQLCA.sqlcode,0)
         CLOSE t618_cl
         ROLLBACK WORK
         RETURN
      END IF
   
      IF NOT cl_confirm('alm-008') THEN
         RETURN
      END IF

    # UPDATE lqu_file SET lquconf = 'N',lqu05 = '0',lqucond = NULL,lquconu = NULL,lqumodu = g_user,lqudate = g_today       #CHI-D20015 mark 
      UPDATE lqu_file SET lquconf = 'N',lqu05 = '0',lqucond = g_today,lquconu = g_user,lqumodu = g_user,lqudate = g_today  #CHI-D20015
       WHERE lqu01 = g_lqu.lqu01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lqu_file",g_lqu.lqu01,"",STATUS,"","",1)
         LET g_success = 'N'
      ELSE
         LET g_lqu.lquconf = 'N'
         LET g_lqu.lqu05 = '0'
         LET g_lqu.lqumodu = g_user
         LET g_lqu.lqudate = g_today
      #CHI-D20015 ----Begin------
      #  LET g_lqu.lquconu = NULL
      #  LET g_lqu.lqucond = NULL
         LET g_lqu.lquconu = g_user
         LET g_lqu.lqucond = g_today
      #  DISPLAY '   ' TO FORMONLY.lquconu_desc
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lqu.lquconu
         DISPLAY l_gen02 TO FORMONLY.lquconu_desc   
      #CHI-D20015 ----End--------
         DISPLAY BY NAME g_lqu.lquconf,g_lqu.lqu05,g_lqu.lqumodu,g_lqu.lqudate,g_lqu.lqucond,g_lqu.lquconu
         CALL t618_pic()
      END IF
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF   
END FUNCTION

FUNCTION t618_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_cnt   LIKE type_file.num5
   IF cl_null(g_lqu.lqu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lqu.*
   FROM lqu_file
   WHERE lqu01=g_lqu.lqu01
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lqu.lquconf='X' THEN RETURN END IF
    ELSE
       IF g_lqu.lquconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_lqu.lquacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lqu.lquconf='Y' AND g_lqu.lqu05 <> '2' THEN
      CALL cl_err('','alm-897',0)
      RETURN
   END IF
   IF g_lqu.lquconf='Y' AND g_lqu.lqu05 = '2' THEN
      CALL cl_err('','axm-015',0)
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t618_cl USING g_lqu.lqu01
   IF STATUS THEN
      CALL cl_err("OPEN t618_cl:", STATUS, 0)
      CLOSE t618_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t618_cl INTO g_lqu.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqu.lqu01,SQLCA.sqlcode,0)
      CLOSE t618_cl
      ROLLBACK WORK
      RETURN
   END IF
  
   IF cl_void(0,0,g_lqu.lquconf) THEN
      IF g_lqu.lquconf ='N' THEN
         LET g_lqu.lquconf='X'
      ELSE
         LET g_lqu.lquconf='N'
      END IF
   END IF   
   UPDATE lqu_file SET lquconf = g_lqu.lquconf, lqumodu = g_user,lqudate = g_today,
                       lqucond = NULL,lquconu = NULL
    WHERE lqu01 = g_lqu.lqu01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0THEN
      CALL cl_err3("upd","lqu_file",g_lqu.lqu01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lqu.lquconf = g_lqu.lquconf
      LET g_lqu.lqumodu = g_user
      LET g_lqu.lqudate = g_today
      LET g_lqu.lqucond = NULL
      LET g_lqu.lquconu = NULL
      DISPLAY '   ' TO FORMONLY.lquconu_desc
      DISPLAY BY NAME g_lqu.lquconf,g_lqu.lqumodu,g_lqu.lqudate,g_lqu.lquconu,g_lqu.lqucond
      
      CALL t618_pic()
   END IF 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t618_issue()
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_sql          STRING        
DEFINE l_f            LIKE type_file.chr1
DEFINE l_lqv03                 LIKE lqv_file.lqv03
DEFINE l_lqv10_o               LIKE lqv_file.lqv10
DEFINE l_lqv11_o               LIKE lqv_file.lqv11
DEFINE l_lqv12_o               LIKE lqv_file.lqv12
DEFINE l_lqv13_o               LIKE lqv_file.lqv13
DEFINE l_lqv14_o               LIKE lqv_file.lqv14
DEFINE l_lqv15_o               LIKE lqv_file.lqv15
DEFINE l_lqv10                 LIKE lqv_file.lqv10
DEFINE l_lqv11                 LIKE lqv_file.lqv11
DEFINE l_lqv12                 LIKE lqv_file.lqv12
DEFINE l_lqv13                 LIKE lqv_file.lqv13
DEFINE l_lqv14                 LIKE lqv_file.lqv14
DEFINE l_lqv15                 LIKE lqv_file.lqv15
   IF cl_null(g_lqu.lqu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lqu.* 
   FROM lqu_file
   WHERE lqu01=g_lqu.lqu01
   IF g_lqu.lqu05 = '2' THEN          #已發出不可變更發出 
      CALL cl_err('','alm-944',0)
      RETURN
   END IF
   IF g_lqu.lquconf='N' THEN          #未確認不可變更發出 
      CALL cl_err('','alm-899',0)
      RETURN
   END IF
   IF g_lqu.lquconf = 'X' THEN       #已作廢不可變更發出 
      CALL cl_err('','alm-898',0)
      RETURN
   END IF
   CALL s_showmsg_init()
   LET l_f = 'Y'
   LET l_sql = " SELECT lqv03,lqv10,lqv11,lqv12,lqv13,lqv14,lqv15",
               " FROM lqv_file",
               " WHERE lqv01 = '",g_lqu.lqu01,"'"
   PREPARE t618_pre11 FROM l_sql
   DECLARE t618_cl11 CURSOR FOR t618_pre11
   FOREACH t618_cl11 INTO l_lqv03,l_lqv10_o, l_lqv11_o, l_lqv12_o, l_lqv13_o, l_lqv14_o, l_lqv15_o
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL t618_lqv03_a(l_lqv03) RETURNING l_lqv10, l_lqv11, l_lqv12, l_lqv13, l_lqv14, l_lqv15
       IF l_lqv10_o <> l_lqv10 OR
          l_lqv11_o <> l_lqv11 OR
          l_lqv12_o <> l_lqv12 OR
          l_lqv13_o <> l_lqv13 OR
          l_lqv14_o <> l_lqv14 OR
          l_lqv15_o <> l_lqv15 THEN
          LET l_f = 'N'
          CALL s_errmsg('lqv03',l_lqv03,l_lqv03,'alm1157',1)
       END IF
   END FOREACH
   IF l_f = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF

   IF g_lqu.lquconf = 'Y' AND g_lqu.lqu05 <> '2' AND l_f = 'Y' THEN
      CALL s_showmsg_init() 
     #IF NOT cl_confirm('alm1022') THEN  #TQC-C30090 mark
      IF NOT cl_confirm('art-859') THEN  #TQC-C30090 add
         RETURN
      END IF
      BEGIN WORK
      LET g_success = 'Y'
      FOREACH t618_cl11 INTO l_lqv03,l_lqv10_o, l_lqv11_o, l_lqv12_o, l_lqv13_o, l_lqv14_o, l_lqv15_o 
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #修改單頭部分為已發出
         UPDATE lqu_file SET lqu05 = '2', lqumodu = g_user,lqudate = g_today
          WHERE lqu01 = g_lqu.lqu01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqu_file",g_lqu.lqu01,"",STATUS,"","",1)
            LET g_success = 'N'
         ELSE
            LET g_lqu.lqu05 = '2'
            LET g_lqu.lqumodu = g_user
            LET g_lqu.lqudate = g_today
            DISPLAY BY NAME g_lqu.lqu05,g_lqu.lqumodu,g_lqu.lqudate  
            #將單身部分資料update 到lpj_file內               
            UPDATE lpj_file
                SET lpj07 = l_lqv12_o,
                    lpj08 = l_lqv10_o,
                    lpj12 = l_lqv15_o,
                    lpj13 = l_lqv14_o,
                    lpj14 = l_lqv13_o,
                    lpj15 = l_lqv11_o,
                    lpjpos = '2'
                WHERE lpj03 = l_lqv03    
             
            IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lpj_file",l_lqv03 ,"",STATUS,"","",1)
               LET g_success = 'N'
            END IF    
         END IF 
         END FOREACH 
         IF g_success = 'Y' AND l_f = 'Y' THEN
            COMMIT WORK
         ELSE
            CALL s_showmsg()
            ROLLBACK WORK
         END IF                      
   END IF 
END FUNCTION

FUNCTION t618_pic()
   IF g_lqu.lquconf='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
   CALL cl_set_field_pic(g_lqu.lquconf,"","","",g_chr,"")
END FUNCTION

FUNCTION t618_lqu03(p_cmd)
DEFINE    p_cmd         LIKE type_file.chr1,
          l_azf03       LIKE azf_file.azf03,
          l_azf09       LIKE azf_file.azf09,
          l_azfacti     LIKE azf_file.azfacti
   LET g_errno = ''
   SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file 
    WHERE azf01 = g_lqu.lqu03 AND azf02 = '2' 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1028'
        WHEN l_azfacti = 'N'      LET g_errno = 'alm1030'
        WHEN l_azf09 <> 'I'       LET g_errno = 'alm1031'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE 
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
   END IF
END FUNCTION

FUNCTION t618_lqu04(p_cmd)
DEFINE    p_cmd         LIKE type_file.chr1,
          l_gen02       LIKE gen_file.gen02,
          l_genacti     LIKE gen_file.genacti
   LET g_errno = ''
   SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
    WHERE gen01 = g_lqu.lqu04        
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-017'
        WHEN l_genacti = 'N'      LET g_errno = 'art-733'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE 
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_gen02 TO FORMONLY.gen02 
   END IF
END FUNCTION
#判斷是否此會員卡號已存在於其他未確認/未發出變更單中
FUNCTION t618_lqv03(l_lqv03)
DEFINE l_lqv03                 LIKE lqv_file.lqv03
DEFINE l_n                     LIKE type_file.num5
   LET g_errno = ''
   SELECT COUNT(*) INTO l_n FROM lqv_file,lqu_file
        WHERE lqv03 = l_lqv03
          AND lqu01 <> g_lqu.lqu01
          AND lqu01 = lqv01
          AND lquconf = 'N'
   IF l_n > 0 THEN
      LET g_errno = 'alm1152'
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM lqv_file,lqu_file
        WHERE lqv03 = l_lqv03
          AND lqu01 <> g_lqu.lqu01
          AND lqv01 = lqu01
          AND lquconf = 'Y' AND lqu05 <> '2'
   IF l_n > 0 THEN
      LET g_errno = 'alm1153'
      RETURN
   END IF
END FUNCTION

FUNCTION t618_lqv03_b(l_lqv03)
DEFINE l_lqv03                 LIKE lqv_file.lqv03
DEFINE l_n                     LIKE type_file.num5
DEFINE l_lqv04                 LIKE lqv_file.lqv04
DEFINE l_lqv05                 LIKE lqv_file.lqv05
DEFINE l_lqv06                 LIKE lqv_file.lqv06
DEFINE l_lqv07                 LIKE lqv_file.lqv07
DEFINE l_lqv08                 LIKE lqv_file.lqv08
DEFINE l_lqv09                 LIKE lqv_file.lqv09
DEFINE l_lqv10                 LIKE lqv_file.lqv10
DEFINE l_lqv11                 LIKE lqv_file.lqv11
DEFINE l_lqv12                 LIKE lqv_file.lqv12
DEFINE l_lqv13                 LIKE lqv_file.lqv13
DEFINE l_lqv14                 LIKE lqv_file.lqv14
DEFINE l_lqv15                 LIKE lqv_file.lqv15
DEFINE l_cnt                   LIKE type_file.num5
   LET g_errno = ''
   #變更前
   SELECT lpj08,lpj07,lpj15,lpj14,lpj12,lpj13
      INTO l_lqv04,l_lqv06,l_lqv05,l_lqv07,l_lqv09,l_lqv08 
      FROM lpj_file
      WHERE lpj03 = l_lqv03 
   IF cl_null(l_lqv05) THEN LET l_lqv05 = 0 END IF
   IF cl_null(l_lqv06) THEN LET l_lqv06 = 0 END IF
   IF cl_null(l_lqv07) THEN LET l_lqv07 = 0 END IF 
   IF cl_null(l_lqv08) THEN LET l_lqv08 = 0 END IF
   IF cl_null(l_lqv09) THEN LET l_lqv09 = 0 END IF
   SELECT COUNT (*) INTO l_cnt FROM lsm_file WHERE lsm01 = l_lqv03
   IF l_cnt >= 1 THEN 
      CALL t618_lqv03_a(l_lqv03)  RETURNING  l_lqv10, l_lqv11, l_lqv12, l_lqv13, l_lqv14, l_lqv15
      IF l_lqv04 = l_lqv10 AND
         l_lqv05 = l_lqv11 AND
         l_lqv06 = l_lqv12 AND
         l_lqv07 = l_lqv13 AND
         l_lqv08 = l_lqv14 AND 
         l_lqv09 = l_lqv15  THEN
         LET g_errno = 'alm1154'
      END IF
   ELSE
      LET l_lqv10 = l_lqv04  
      LET l_lqv11 = l_lqv05  
      LET l_lqv12 = l_lqv06
      LET l_lqv13 = l_lqv07
      LET l_lqv14 = l_lqv08
      LET l_lqv15 = l_lqv09
      LET g_errno = 'alm1154'
   END IF
   
   RETURN l_lqv04, l_lqv05, l_lqv06, l_lqv07, l_lqv08, l_lqv09,
          l_lqv10, l_lqv11, l_lqv12, l_lqv13, l_lqv14, l_lqv15

END FUNCTION

FUNCTION t618_lqv03_a(l_lqv03)
DEFINE l_lqv03                 LIKE lqv_file.lqv03
DEFINE l_lqv10                 LIKE lqv_file.lqv10
DEFINE l_lqv11                 LIKE lqv_file.lqv11
DEFINE l_lqv12                 LIKE lqv_file.lqv12
DEFINE l_lqv13                 LIKE lqv_file.lqv13
DEFINE l_lqv14                 LIKE lqv_file.lqv14
DEFINE l_lqv15                 LIKE lqv_file.lqv15
#FUN-C30176 add START
DEFINE l_lsm09                 LIKE lsm_file.lsm09 
DEFINE l_lsm10                 LIKE lsm_file.lsm10
DEFINE l_lsm11                 LIKE lsm_file.lsm11
DEFINE l_lsm12                 LIKE lsm_file.lsm12
DEFINE l_lsm13                 LIKE lsm_file.lsm13
DEFINE l_lsm14                 LIKE lsm_file.lsm14
#FUN-C30176 add END
   #變更後
   SELECT MAX(lsm05) INTO l_lqv10 FROM lsm_file WHERE lsm01 = l_lqv03
#         AND lsm02 IN ('1', '5', '6', '7', '8')     #FUN-C70045 mark
          AND lsm02 IN ('2', '3', '7', '8')          #FUN-C70045 add
   SELECT SUM(lsm08),SUM(lsm04) 
      INTO l_lqv11,l_lqv13   
         FROM lsm_file 
         WHERE lsm01 = l_lqv03
#         AND lsm02 IN ('1', '5', '6', '7', '8')     #FUN-C70045 mark
          AND lsm02 IN ('2', '3', '7', '8')          #FUN-C70045 add
   IF cl_null(l_lqv11) THEN LET l_lqv11 = 0 END IF 
   IF cl_null(l_lqv13) THEN LET l_lqv13 = 0 END IF 
 
   SELECT COUNT(*) INTO l_lqv12 FROM lsm_file 
        WHERE lsm01 = l_lqv03
#         AND lsm02 IN ('1', '7', '8')             #FUN-C70045 mark
          AND lsm02 IN ('7', '8')                  #FUN-C70045 add
   IF cl_null(l_lqv12) THEN LET l_lqv12 = 0 END IF

   SELECT SUM(lsm04) INTO l_lqv14
        FROM lsm_file
        WHERE lsm01 = l_lqv03
#         AND lsm02 IN ('2', '3', '4', '9', 'A')  #FUN-C70045 mark
          AND lsm02 IN ('5', '6', '9', 'A')       #FUN-C70045 add
   IF cl_null(l_lqv14) THEN LET l_lqv14 = 0 END IF
  #LET l_lqv14 = l_lqv14 * (-1)  #FUN-C30176 mark

   LET l_lqv15 = 0 
  #LET l_lqv15 = l_lqv13 - l_lqv14  #FUN-C30176 mark 
   LET l_lqv15 = l_lqv13 + l_lqv14  #FUN-C30176 add

  #FUN-C30176 add START
  #開帳
  #FUN-C70097 add START
   LET l_lsm09 = 0 
   LET l_lsm10 = 0 
   LET l_lsm11 = 0 
   LET l_lsm12 = 0 
   LET l_lsm13 = 0 
   LET l_lsm14 = NULL
  #FUN-C70097 add END
   SELECT lsm09,lsm10,lsm11,lsm12,lsm13,lsm14 
      INTO l_lsm09,l_lsm10,l_lsm11,l_lsm12,l_lsm13,l_lsm14  
        FROM lsm_file
        WHERE lsm01 = l_lqv03
#         AND lsm02 = 'B'                         #FUN-C70045 mark
          AND lsm02 = '1' AND lsm15 = '1'         #FUN-C70045 add
   IF cl_null(l_lsm09) THEN LET l_lsm09 = 0 END IF
   IF cl_null(l_lsm10) THEN LET l_lsm10 = 0 END IF
   IF cl_null(l_lsm11) THEN LET l_lsm11 = 0 END IF
   IF cl_null(l_lsm12) THEN LET l_lsm12 = 0 END IF
   IF cl_null(l_lsm13) THEN LET l_lsm13 = 0 END IF
   LET l_lqv12 = l_lqv12 + l_lsm09
   LET l_lqv11 = l_lqv11 + l_lsm10
   LET l_lqv13 = l_lqv13 + l_lsm11
   LET l_lqv15 = l_lqv15 + l_lsm12
   LET l_lqv14 = l_lqv14 + l_lsm13
   IF NOT cl_null(l_lsm14) THEN
      IF l_lsm14 > l_lqv10 THEN
         LET l_lqv10 = l_lsm14
      END IF
   END IF 
  #換卡
  #FUN-C70097 add START
   LET l_lsm09 = 0 
   LET l_lsm10 = 0 
   LET l_lsm11 = 0 
   LET l_lsm12 = 0 
   LET l_lsm13 = 0 
   LET l_lsm14 = NULL
  #FUN-C70097 add END
   SELECT lsm09,lsm10,lsm11,lsm12,lsm13,lsm14 
      INTO l_lsm09,l_lsm10,l_lsm11,l_lsm12,l_lsm13,l_lsm14
        FROM lsm_file
        WHERE lsm01 = l_lqv03
#         AND lsm02 = 'C'                         #FUN-C70045 mark
          AND lsm02 = '4' AND lsm15 = '1'         #FUN-C70045 add
   IF cl_null(l_lsm09) THEN LET l_lsm09 = 0 END IF
   IF cl_null(l_lsm10) THEN LET l_lsm10 = 0 END IF
   IF cl_null(l_lsm11) THEN LET l_lsm11 = 0 END IF
   IF cl_null(l_lsm12) THEN LET l_lsm12 = 0 END IF
   IF cl_null(l_lsm13) THEN LET l_lsm13 = 0 END IF
   LET l_lqv12 = l_lqv12 + l_lsm09
   LET l_lqv11 = l_lqv11 + l_lsm10
   LET l_lqv13 = l_lqv13 + l_lsm11
   LET l_lqv15 = l_lqv15 + l_lsm12
   LET l_lqv14 = l_lqv14 + l_lsm13
   IF NOT cl_null(l_lsm14) THEN
      IF l_lsm14 > l_lqv10 THEN
         LET l_lqv10 = l_lsm14
      END IF
   END IF
  #FUN-C30176 add END 
 
   RETURN l_lqv10, l_lqv11, l_lqv12, l_lqv13, l_lqv14, l_lqv15

END FUNCTION
#FUN-BA0066
#FUN-C90070-------add------str
FUNCTION t618_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_azf03   LIKE azf_file.azf03,
       l_gen02_1 LIKE gen_file.gen02,
       l_gen02_2 LIKE gen_file.gen02,        
       sr        RECORD
                 lqu01     LIKE lqu_file.lqu01, 
                 lqu02     LIKE lqu_file.lqu02,
                 lqu03     LIKE lqu_file.lqu03,
                 lqu04     LIKE lqu_file.lqu04,
                 lquconf   LIKE lqu_file.lquconf,
                 lqucond   LIKE lqu_file.lqucond,
                 lquconu   LIKE lqu_file.lquconu,
                 lqu05     LIKE lqu_file.lqu05,
                 lqv02     LIKE lqv_file.lqv02,
                 lqv03     LIKE lqv_file.lqv03,
                 lqv04     LIKE lqv_file.lqv04,
                 lqv05     LIKE lqv_file.lqv05,
                 lqv06     LIKE lqv_file.lqv06,
                 lqv07     LIKE lqv_file.lqv07,
                 lqv08     LIKE lqv_file.lqv08,
                 lqv09     LIKE lqv_file.lqv09,
                 lqv10     LIKE lqv_file.lqv10,
                 lqv11     LIKE lqv_file.lqv11,
                 lqv12     LIKE lqv_file.lqv12,
                 lqv13     LIKE lqv_file.lqv13,
                 lqv14     LIKE lqv_file.lqv14,
                 lqv15     LIKE lqv_file.lqv15
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lquuser', 'lqugrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lqu01 = '",g_lqu.lqu01,"'" END IF
     IF cl_null(g_wc1) THEN LET g_wc1 = " lqv01 = '",g_lqu.lqu01,"'" END IF
     LET l_sql = "SELECT lqu01,lqu02,lqu03,lqu04,lquconf,lqucond,lquconu,lqu05,",
                 "       lqv02,lqv03,lqv04,lqv05,lqv06,lqv07,lqv08,lqv09,lqv10,",
                 "       lqv11,lqv12,lqv13,lqv14,lqv15",
                 "  FROM lqu_file,lqv_file",
                 " WHERE lqu01 = lqv01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc1 CLIPPED
     PREPARE t618_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t618_cs1 CURSOR FOR t618_prepare1

     DISPLAY l_table
     FOREACH t618_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
  
       LET l_azf03 = ' '
       SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.lqu03 AND azf02='2' AND azf09='I'
       LET l_gen02_1 = ' '
       SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01=sr.lqu04
       LET l_gen02_2 = ' '
       SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01=sr.lquconu
       EXECUTE insert_prep USING sr.*,l_azf03,l_gen02_1,l_gen02_2
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lqu01,lqu02,lqu03,lqu04,lquconf,lqucond,lquconu,lqu05')
          RETURNING g_wc2
     CALL cl_wcchp(g_wc1,'lqv01,lqv02,lqv03,lqv04,lqv05,lqv06,lqv07,lqv08,lqv09,lqv10,lqv11,lqv12,lqv13,lqv14,lqv15')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc2=''
     END IF
     IF g_wc1 = " 1=1" THEN
        LET g_wc3=''
     END IF
     IF g_wc <> " 1=1" AND g_wc1 <> " 1=1" THEN
        LET g_wc4 = g_wc2," AND ",g_wc3
     ELSE
        IF g_wc = " 1=1" AND g_wc1 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc2,g_wc3
        END IF
     END IF
     CALL t618_grdata()
END FUNCTION

FUNCTION t618_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt618")
       IF handler IS NOT NULL THEN
           START REPORT t618_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lqu01,lqv02"
           DECLARE t618_datacur1 CURSOR FROM l_sql
           FOREACH t618_datacur1 INTO sr1.*
               OUTPUT TO REPORT t618_rep(sr1.*)
           END FOREACH
           FINISH REPORT t618_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t618_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lquconf  STRING
    DEFINE l_lqu05    STRING


    
    ORDER EXTERNAL BY sr1.lqu01,sr1.lqv02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc2,g_wc3,g_wc4
              
        BEFORE GROUP OF sr1.lqu01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.lqv02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lquconf = cl_gr_getmsg("gre-304",g_lang,sr1.lquconf)
            LET l_lqu05 = cl_gr_getmsg("gre-308",g_lang,sr1.lqu05)
            PRINTX sr1.*
            PRINTX l_lquconf
            PRINTX l_lqu05


        AFTER GROUP OF sr1.lqu01
        AFTER GROUP OF sr1.lqv02

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
