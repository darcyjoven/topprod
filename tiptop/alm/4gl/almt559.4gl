# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: almt559.4gl
# Descriptions...: 會員升等變更維護作業
# Date & Author..: No.FUN-B80051 11/08/08 By nanbing
# Modify.........: No:TQC-BB0125 11/11/24 by pauline 控卡platn code不是當前營運中心時，不允許執行任何動作
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90070 12/09/19 By xumm 添加GR打印功能
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-D10059 13/01/15 By dongsz 會員升等邏輯調整為調用t559sub_lqt03_uplevel函數
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/04/02 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_lqr             RECORD LIKE lqr_file.*,      
    g_lqr_t           RECORD LIKE lqr_file.*,  
    g_lqr_o           RECORD LIKE lqr_file.*, 
    g_lqr01_t         LIKE lqr_file.lqr01,  
    #单身
    g_lqt             DYNAMIC ARRAY OF RECORD      
        lqt02         LIKE lqt_file.lqt02,
        before        LIKE type_file.chr1,    
        lqt03         LIKE lqt_file.lqt03, 
        lpk04         LIKE lpk_file.lpk04,  
        lqt04         LIKE lqt_file.lqt04, 
     #  lpf02_1       LIKE lpf_file.lpf02,
        lpc02_1       LIKE lpc_file.lpc02,
        lqt05         LIKE lqt_file.lqt05, 
        lqt06         LIKE lqt_file.lqt06,   
        lqt07         LIKE lqt_file.lqt07,  
        after         LIKE type_file.chr1,   
        lqt08         LIKE lqt_file.lqt08,
     #  lpf02_2       LIKE lpf_file.lpf02  
        lpc02_2       LIKE lpc_file.lpc02      
                      END RECORD,
    g_lqt_o           RECORD      
        lqt02         LIKE lqt_file.lqt02,
        before        LIKE type_file.chr1,    
        lqt03         LIKE lqt_file.lqt03, 
        lpk04         LIKE lpk_file.lpk04,  
        lqt04         LIKE lqt_file.lqt04, 
     #  lpf02_1       LIKE lpf_file.lpf02,
        lpc02_1       LIKE lpc_file.lpc02,
        lqt05         LIKE lqt_file.lqt05, 
        lqt06         LIKE lqt_file.lqt06,   
        lqt07         LIKE lqt_file.lqt07,  
        after         LIKE type_file.chr1,   
        lqt08         LIKE lqt_file.lqt08,
     #  lpf02_2       LIKE lpf_file.lpf02  
        lpc02_2       LIKE lpc_file.lpc02           
                      END RECORD,
    g_lqt_t           RECORD      
        lqt02         LIKE lqt_file.lqt02,
        before        LIKE type_file.chr1,   
        lqt03         LIKE lqt_file.lqt03, 
        lpk04         LIKE lpk_file.lpk04,  
        lqt04         LIKE lqt_file.lqt04, 
     #  lpf02_1       LIKE lpf_file.lpf02,
        lpc02_1       LIKE lpc_file.lpc02,
        lqt05         LIKE lqt_file.lqt05, 
        lqt06         LIKE lqt_file.lqt06,   
        lqt07         LIKE lqt_file.lqt07,        
        after         LIKE type_file.chr1,   
        lqt08         LIKE lqt_file.lqt08,
     #  lpf02_2       LIKE lpf_file.lpf02  
        lpc02_2       LIKE lpc_file.lpc02         
                      END RECORD
DEFINE
         g_wc           STRING, 
         g_wc1          STRING,
         g_sql          STRING,
         l_flag         LIKE type_file.chr1,    
         g_rec_b        LIKE type_file.num5,    #單身筆數 
         l_ac           LIKE type_file.num5     #目前處理的ARRAY CNT  
DEFINE   g_forupd_sql   STRING                  #SELECT ...  FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1     
DEFINE   g_cnt          LIKE type_file.num10    
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg          LIKE ze_file.ze03       
DEFINE   g_before_input_done  LIKE type_file.num5  
DEFINE   g_row_count    LIKE type_file.num10    
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_jump         LIKE type_file.num10    
DEFINE   g_no_ask       LIKE type_file.num5   
DEFINE   g_kindtype     LIKE oay_file.oaytype 
DEFINE   g_kindslip     LIKE oay_file.oayslip  
DEFINE   g_date         LIKE lqr_file.lqrdate
DEFINE   g_modu         LIKE lqr_file.lqrmodu
DEFINE   g_multi_lqt03   STRING   
#FUN-C90070----add---str
DEFINE g_wc2            STRING
DEFINE g_wc3            STRING
DEFINE g_wc4            STRING
DEFINE l_table          STRING
TYPE sr1_t RECORD
    lqr01     LIKE lqr_file.lqr01,
    lqr02     LIKE lqr_file.lqr02,
    lqr03     LIKE lqr_file.lqr03,
    lqr04     LIKE lqr_file.lqr04,
    lqrconf   LIKE lqr_file.lqrconf,
    lqrcond   LIKE lqr_file.lqrcond,
    lqrconu   LIKE lqr_file.lqrconu,
    lqr05     LIKE lqr_file.lqr05,
    lqt02     LIKE lqt_file.lqt02,
    lqt03     LIKE lqt_file.lqt03,
    lqt04     LIKE lqt_file.lqt04,
    lqt05     LIKE lqt_file.lqt05,
    lqt06     LIKE lqt_file.lqt06,
    lqt07     LIKE lqt_file.lqt07,
    lqt08     LIKE lqt_file.lqt08,
    lpk04     LIKE lpk_file.lpk04,
    lpc02_1   LIKE lpc_file.lpc02,
    lpc02_2   LIKE lpc_file.lpc02
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
   LET g_sql ="lqr01.lqr_file.lqr01,",
              "lqr02.lqr_file.lqr02,",
              "lqr03.lqr_file.lqr03,",
              "lqr04.lqr_file.lqr04,",
              "lqrconf.lqr_file.lqrconf,",
              "lqrcond.lqr_file.lqrcond,",
              "lqrconu.lqr_file.lqrconu,",
              "lqr05.lqr_file.lqr05,",
              "lqt02.lqt_file.lqt02,",
              "lqt03.lqt_file.lqt03,",
              "lqt04.lqt_file.lqt04,",
              "lqt05.lqt_file.lqt05,",
              "lqt06.lqt_file.lqt06,",
              "lqt07.lqt_file.lqt07,",
              "lqt08.lqt_file.lqt08,",
              "lpk04.lpk_file.lpk04,",
              "lpc02_1.lpc_file.lpc02,",
              "lpc02_2.lpc_file.lpc02"
   LET l_table = cl_prt_temptable('almt559',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end 
   LET g_forupd_sql = "SELECT * FROM lqr_file WHERE lqr01 = ? FOR UPDATE" 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t559_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t559_w WITH FORM "alm/42f/almt559"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL t559_menu()
   CLOSE t559_cl
   CLOSE WINDOW t559_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN

FUNCTION t559_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
   CLEAR FORM          
   CALL g_lqt.clear()
   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_lqr.* TO NULL    
   CONSTRUCT BY NAME g_wc ON lqr01,lqr02,lqr03,lqr04,lqrconf,lqrcond,lqrconu,lqr05,
                             lqruser,lqrgrup,lqroriu,lqrorig,lqrmodu,lqrdate,lqracti,
                             lqrud01,lqrud02,lqrud03,lqrud04,lqrud05,lqrud06,lqrud07,
                             lqrud08,lqrud09,lqrud10,lqrud11,lqrud12,lqrud13,lqrud14,lqrud15
      BEFORE CONSTRUCT
      CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(lqr01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqr01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqr01
               NEXT FIELD lqr01
      
            WHEN INFIELD(lqr03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqr03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqr03
               NEXT FIELD lqr03
      
            WHEN INFIELD(lqr04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqr04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqr04
               NEXT FIELD lqr04
            WHEN INFIELD(lqrconu)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqrconu"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqrconu
               NEXT FIELD lqr04   
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lqruser', 'lqrgrup') 

   CONSTRUCT g_wc1 ON lqt02,lqt03,lqt04,lqt08,lqt05,lqt06,lqt07
        FROM s_lqt[1].lqt02,s_lqt[1].lqt03,s_lqt[1].lqt04,s_lqt[1].lqt08,
             s_lqt[1].lqt05,s_lqt[1].lqt06,s_lqt[1].lqt07
       
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
            WHEN INFIELD(lqt03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqt03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqt03
               NEXT FIELD lqt03
            OTHERWISE EXIT CASE      
         END CASE    
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      #LET INT_FLAG=0
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
      LET g_sql = "SELECT lqr01 FROM lqr_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY lqr01"
   ELSE                             
      LET g_sql = "SELECT UNIQUE lqr_file.lqr01 ",
                  "  FROM lqr_file, lqt_file ",
                  " WHERE lqr01 = lqt01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc1 CLIPPED,
                  " ORDER BY lqr01"
   END IF 
   PREPARE t559_prepare FROM g_sql
   DECLARE t559_cs SCROLL CURSOR WITH HOLD FOR t559_prepare
   IF g_wc1 = " 1=1" THEN                  
   LET g_sql="SELECT COUNT(*) FROM lqr_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lqr01) FROM lqr_file,lqt_file WHERE ",
                "lqt01=lqr01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
   END IF 
   PREPARE t559_precount FROM g_sql
   DECLARE t559_count CURSOR FOR t559_precount   
END FUNCTION

FUNCTION t559_menu()
   WHILE TRUE
      CALL t559_bp("G")
      CASE g_action_choice
         WHEN "insert"                  #新增
            IF cl_chk_act_auth() THEN
               CALL t559_a()
            END IF
 
         WHEN "query"                   #查詢
            IF cl_chk_act_auth() THEN
               CALL t559_q()
            END IF
 
         WHEN "delete"                  #刪除
            IF cl_chk_act_auth() THEN
               CALL t559_r()
            END IF
 
         WHEN "modify"                  #修改
            IF cl_chk_act_auth() THEN
               CALL t559_u()
            END IF
 
         WHEN "detail"                 #單身
            IF cl_chk_act_auth() THEN
                  CALL t559_b('a')
            END IF 

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "confirm"               #確認
            IF cl_chk_act_auth() THEN
               CALL t559_yes()  
            END IF
        
         WHEN "void"                  #作廢
            IF cl_chk_act_auth() THEN
               CALL t559_v(1)
            END IF 
         #FUN-D20039 -----------------sta
         WHEN "undo_void"                  
            IF cl_chk_act_auth() THEN
               CALL t559_v(2)
            END IF
         #FUN-D20039 -----------------end 
         WHEN "undo_confirm"               #確認
            IF cl_chk_act_auth() THEN
               CALL t559_no()  
            END IF 
         WHEN "issues"
            IF cl_chk_act_auth() THEN
               CALL t559_issue()  
            END IF                      
        # WHEN "exporttoexcel"
        #    IF cl_chk_act_auth() THEN
        #      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lqt),'','')
        #    END IF

      END CASE
   END WHILE     
END FUNCTION

FUNCTION t559_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,   
            l_wc   STRING   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lqt TO s_lqt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
      #FUN-C90070------add------str
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
           CALL t559_out()
         END IF
      #FUN-C90070------add------end
      ON ACTION first
         CALL t559_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
      ON ACTION previous
         CALL t559_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
      ON ACTION jump
         CALL t559_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
      ON ACTION next
         CALL t559_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
      ON ACTION last
         CALL t559_fetch('L')
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
         #IF cl_chk_act_auth() THEN
         #   CALL t559_yes()                                  
         #END IF   
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
         #IF cl_chk_act_auth() THEN
         #   CALL t559_no()
         #END IF 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
         #IF cl_chk_act_auth() THEN
         #   CALL t559_v()
         #END IF 
      #FUN-D20039 ---------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ---------end
      ON ACTION issues
         LET g_action_choice="issues"
         EXIT DISPLAY
         #IF cl_chk_act_auth() THEN
         #   CALL t559_issue()
         #END IF   
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
     # ON ACTION exporttoexcel       
     #    LET g_action_choice = 'exporttoexcel'
     #    EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION t559_a()
DEFINE li_result   LIKE type_file.num5   
   CLEAR FORM
   LET g_success = 'Y'
   
   CALL g_lqt.clear()

   LET g_wc = NULL
   LET g_wc1= NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lqr.* LIKE lqr_file.*         
   LET g_lqr01_t = NULL
   LET g_lqr_t.* = g_lqr.*
   LET g_lqr_o.* = g_lqr.*
   CALL cl_opmsg('a')
   
   WHILE TRUE
      LET g_lqr.lqruser = g_user
      LET g_lqr.lqracti = 'Y'
      LET g_lqr.lqroriu = g_user 
      LET g_lqr.lqrorig = g_grup 
      LET g_lqr.lqrgrup = g_grup
      LET g_lqr.lqrconf = 'N'
      LET g_lqr.lqr02 = g_today
      LET g_lqr.lqrplant = g_plant
      LET g_lqr.lqrlegal = g_legal
      LET g_lqr.lqr05 = '0'
      CALL t559_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                  
         INITIALIZE g_lqr.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lqr.lqr01) THEN    
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lqr.lqr01,g_lqr.lqr02,"O3","lqr_file","lqr01","","","")
        RETURNING li_result,g_lqr.lqr01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lqr.lqr01
 
      INSERT INTO lqr_file VALUES (g_lqr.*)    
 
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'       
         CALL cl_err3("ins","lqr_file",g_lqr.lqr01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF 
      
      IF g_success = 'N' THEN 
         ROLLBACK WORK  
      ELSE
         COMMIT WORK      
         CALL cl_flow_notify(g_lqr.lqr01,'I')
      END IF
       
      SELECT * INTO g_lqr.* FROM lqr_file
       WHERE lqr01 = g_lqr.lqr01
      LET g_lqr01_t = g_lqr.lqr01       
      LET g_lqr_t.* = g_lqr.*
      LET g_lqr_o.* = g_lqr.*
      CALL g_lqt.clear()

      LET g_rec_b = 0  
      CALL t559_b('a')                 
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t559_u()
DEFINE l_n       LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqr.lqr01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_lqr.lqracti='N' THEN 
      CALL cl_err(g_lqr.lqr01,'alm-147',1)
      RETURN 
   END IF  
   IF g_lqr.lqrconf='Y' THEN
      CALL cl_err(g_lqr.lqr01,9022,1)
      RETURN
   END IF
   IF g_lqr.lqrconf='X' THEN
      CALL cl_err(g_lqr.lqr01,9022,1)
      RETURN
   END IF      
   SELECT * INTO g_lqr.* FROM lqr_file
    WHERE lqr01=g_lqr.lqr01
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lqr01_t = g_lqr.lqr01
   BEGIN WORK
 
   OPEN t559_cl USING g_lqr_t.lqr01
   IF STATUS THEN
      CALL cl_err("OPEN t559_cl:", STATUS, 1)
      CLOSE t559_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t559_cl INTO g_lqr.*                    
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)   
       CLOSE t559_cl
       ROLLBACK WORK
       RETURN
   END IF
  
  LET g_date = g_lqr.lqrdate
  LET g_modu = g_lqr.lqrmodu  
                                                                      
   CALL t559_show()
 
   WHILE TRUE
      LET g_lqr01_t = g_lqr.lqr01
      LET g_lqr_o.* = g_lqr.*
      LET g_lqr_t.* = g_lqr.*
      LET g_lqr.lqrmodu=g_user
      LET g_lqr.lqrdate=g_today
      CALL t559_i("u")    
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lqr_t.lqrdate = g_date
         LET g_lqr_t.lqrmodu = g_modu
         LET g_lqr.*=g_lqr_t.*         
         CALL t559_show()
         CALL cl_err('',9001,0)     
         RETURN        
         EXIT WHILE
      END IF
      IF g_lqr.lqr01 != g_lqr01_t THEN           
         UPDATE lqt_file SET lqt01 = g_lqr.lqr01
          WHERE lqt01 = g_lqr01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqt_file",g_lqr01_t,"",SQLCA.sqlcode,"","lqt",1)
            CONTINUE WHILE
         END IF
      END IF
      UPDATE lqr_file SET lqr_file.* = g_lqr.*
       WHERE lqr01 = g_lqr01_t  
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lqr_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
            
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t559_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqr.lqr01,'U')
   CALL t559_show()
   CALL t559_b_fill("1=1")
END FUNCTION


FUNCTION t559_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1    
DEFINE    li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lqr.lqr01,g_lqr.lqr02,g_lqr.lqr03,g_lqr.lqr04,g_lqr.lqr05,
                   g_lqr.lqruser,g_lqr.lqrmodu,g_lqr.lqrgrup,g_lqr.lqrdate,
                   g_lqr.lqracti,g_lqr.lqroriu,g_lqr.lqrorig,g_lqr.lqrconf,
                   g_lqr.lqrud01,g_lqr.lqrud02,g_lqr.lqrud03,g_lqr.lqrud04,
                   g_lqr.lqrud05,g_lqr.lqrud06,g_lqr.lqrud07,g_lqr.lqrud08,
                   g_lqr.lqrud09,g_lqr.lqrud10,g_lqr.lqrud11,g_lqr.lqrud12,
                   g_lqr.lqrud13,g_lqr.lqrud14,g_lqr.lqrud15,g_lqr.lqrcond,
                   g_lqr.lqrconu
  
   INPUT BY NAME g_lqr.lqr01,g_lqr.lqr02,g_lqr.lqr03,g_lqr.lqr04,
                 g_lqr.lqrud01,g_lqr.lqrud02,g_lqr.lqrud03,g_lqr.lqrud04,
                 g_lqr.lqrud05,g_lqr.lqrud06,g_lqr.lqrud07,g_lqr.lqrud08,
                 g_lqr.lqrud09,g_lqr.lqrud10,g_lqr.lqrud11,g_lqr.lqrud12,
                 g_lqr.lqrud13,g_lqr.lqrud14,g_lqr.lqrud15
            WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t559_set_entry(p_cmd)
         CALL t559_set_no_entry(p_cmd)
         CALL cl_set_docno_format("lqr01")
         LET g_before_input_done = TRUE       
 
      AFTER FIELD lqr01
         IF NOT cl_null(g_lqr.lqr01) THEN
            IF g_lqr.lqr01 != g_lqr_t.lqr01
                OR g_lqr_t.lqr01 IS NULL THEN         
               CALL s_check_no("alm",g_lqr.lqr01,g_lqr01_t,"O3","lqr_file","lqr01","")
                    RETURNING li_result,g_lqr.lqr01
               IF (NOT li_result) THEN
                  LET g_lqr.lqr01=g_lqr_t.lqr01
                  NEXT FIELD lqr01
               END IF
                DISPLAY BY NAME g_lqr.lqr01
            END IF   
         END IF    
      AFTER FIELD lqr03
         IF NOT cl_null(g_lqr.lqr03) THEN  
            IF g_lqr.lqr03 != g_lqr_t.lqr03
                OR g_lqr_t.lqr03 IS NULL THEN         
               CALL t559_lqr03('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lqr03
               END IF   
            END IF   
         END IF   
      AFTER FIELD lqr04
         IF NOT cl_null(g_lqr.lqr04) THEN
            IF g_lqr.lqr04 != g_lqr_t.lqr04
                OR g_lqr_t.lqr04 IS NULL THEN        
               CALL t559_lqr04('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lqr04
               END IF   
            END IF   
         END IF   
      AFTER FIELD lqrud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
    # AFTER FIELD lqrud02
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud03
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud04
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud05
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud06
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud07
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud08
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF
    # AFTER FIELD lqrud09
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud10
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud11
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud12
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud13
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud14
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF  
    # AFTER FIELD lqrud15
    #    IF NOT cl_vilidate() THEN NEXT FIELD CURRENT END IF       
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION controlp
         CASE    
            WHEN INFIELD(lqr01)
               LET g_kindslip = s_get_doc_no(g_lqr.lqr01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'O3','ALM') RETURNING g_kindslip 
               LET g_lqr.lqr01 = g_kindslip
               DISPLAY BY NAME g_lqr.lqr01
               NEXT FIELD lqr01
            WHEN INFIELD(lqr03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf01a"
               LET g_qryparam.arg1 = "I"
               CALL cl_create_qry() RETURNING g_lqr.lqr03
               DISPLAY BY NAME g_lqr.lqr03   
               CALL t559_lqr03('a')           
               NEXT FIELD lqr03    
            WHEN INFIELD(lqr04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_lqr.lqr04
               DISPLAY BY NAME g_lqr.lqr04  
               CALL t559_lqr04('a')            
               NEXT FIELD lqr04    
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
FUNCTION t559_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lqt.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t559_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lqr.* TO NULL
      RETURN
   END IF
 
   OPEN t559_cs                          
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lqr.* TO NULL
   ELSE
      OPEN t559_count
      FETCH t559_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t559_fetch('F')                  
   END IF
END FUNCTION
FUNCTION t559_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t559_cs INTO g_lqr.lqr01
      WHEN 'P' FETCH PREVIOUS t559_cs INTO g_lqr.lqr01
      WHEN 'F' FETCH FIRST    t559_cs INTO g_lqr.lqr01
      WHEN 'L' FETCH LAST     t559_cs INTO g_lqr.lqr01
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
            FETCH ABSOLUTE g_jump t559_cs INTO g_lqr.lqr01
            LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)
      INITIALIZE g_lqr.* TO NULL              
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
 
   SELECT * INTO g_lqr.* FROM lqr_file WHERE lqr01 = g_lqr.lqr01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lqr_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lqr.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lqr.lqruser        
   LET g_data_group = g_lqr.lqrgrup     
   LET g_data_plant = g_lqr.lqrplant    #TQC-BB0125 add
   CALL t559_show()
END FUNCTION
FUNCTION t559_show()
DEFINE l_gen02     LIKE gen_file.gen02
   LET g_lqr_t.* = g_lqr.*                
   LET g_lqr_o.* = g_lqr.*                
   LET g_lqr01_t = g_lqr.lqr01
   DISPLAY BY NAME g_lqr.lqr01,g_lqr.lqr02,g_lqr.lqr03,g_lqr.lqr04,g_lqr.lqr05,
                   g_lqr.lqruser,g_lqr.lqrmodu,g_lqr.lqrgrup,g_lqr.lqrdate,
                   g_lqr.lqracti,g_lqr.lqroriu,g_lqr.lqrorig,g_lqr.lqrconf,
                   g_lqr.lqrud01,g_lqr.lqrud02,g_lqr.lqrud03,g_lqr.lqrud04,
                   g_lqr.lqrud05,g_lqr.lqrud06,g_lqr.lqrud07,g_lqr.lqrud08,
                   g_lqr.lqrud09,g_lqr.lqrud10,g_lqr.lqrud11,g_lqr.lqrud12,
                   g_lqr.lqrud13,g_lqr.lqrud14,g_lqr.lqrud15,g_lqr.lqrconu,
                   g_lqr.lqrcond
                   
   CALL t559_lqr03('d')
   CALL t559_lqr04('d')
   CALL t559_pic()
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lqr.lqrconu
   DISPLAY l_gen02 TO FORMONLY.lqrconu_desc
   CALL t559_b_fill(g_wc1)              
   CALL cl_show_fld_cont()    
END FUNCTION

FUNCTION t559_r()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqr.lqr01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_lqr.lqracti='N' THEN 
      CALL cl_err(g_lqr.lqr01,'alm-147',1)
      RETURN 
   END IF   
   #IF g_lqr.lqrconf='Y' THEN
   #   CALL cl_err('','alm-667',1)
   #   RETURN
   #END IF
   IF g_lqr.lqrconf='X' THEN
      CALL cl_err('','alm-667',1)
      RETURN
   END IF      
   SELECT * INTO g_lqr.* FROM lqr_file
    WHERE lqr01=g_lqr.lqr01 
   BEGIN WORK
 
   OPEN t559_cl USING g_lqr_t.lqr01
   IF STATUS THEN
      CALL cl_err("OPEN t559_cl:", STATUS, 1)
      CLOSE t559_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t559_cl INTO g_lqr.*              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t559_show()
 
   IF cl_delh(0,0) THEN                   
      INITIALIZE g_doc.* TO NULL         
      LET g_doc.column1 = "lqr01"       
      LET g_doc.value1 = g_lqr.lqr01    
      CALL cl_del_doc()                                                            
      DELETE FROM lqr_file WHERE lqr01 = g_lqr_t.lqr01 
      DELETE FROM lqt_file WHERE lqt01 = g_lqr_t.lqr01 
          
      CLEAR FORM
      CALL g_lqt.clear()
      OPEN t559_count
      IF STATUS THEN
         CLOSE t559_cs
         CLOSE t559_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t559_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t559_cs
         CLOSE t559_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t559_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t559_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE     
         CALL t559_fetch('/')
      END IF
   END IF
 
   CLOSE t559_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqr.lqr01,'D')
END FUNCTION
FUNCTION t559_b(p_w)
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
 
    IF g_lqr.lqr01 IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    IF g_lqr.lqracti='N' THEN 
       CALL cl_err(g_lqr.lqr01,'alm-147',1)
       RETURN 
    END IF   
   IF g_lqr.lqrconf='Y' THEN
      CALL cl_err(g_lqr.lqr01,9022,1)
      RETURN
   END IF
   IF g_lqr.lqrconf='X' THEN
      CALL cl_err(g_lqr.lqr01,9022,1)
      RETURN
   END IF      
    SELECT * INTO g_lqr.* FROM lqr_file
     WHERE lqr01=g_lqr.lqr01
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lqt02,'',lqt03,'',lqt04,'',lqt05,lqt06,lqt07,'',lqt08,'' from lqt_file", 
                       " WHERE lqt01 =? and lqt02 =? ",
                       "  FOR UPDATE "
                         
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t559_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    #CALL s_showmsg_init()
    INPUT ARRAY g_lqt WITHOUT DEFAULTS FROM s_lqt.*
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
 
           OPEN t559_cl USING g_lqr.lqr01
           IF STATUS THEN
              CALL cl_err("OPEN t559_cl:", STATUS, 1)
              CLOSE t559_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t559_cl INTO g_lqr.*           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)     
              CLOSE t559_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lqt_t.* = g_lqt[l_ac].*  
              LET g_lqt_o.* = g_lqt[l_ac].*  
              OPEN t559_bcl USING g_lqr.lqr01,g_lqt[l_ac].lqt02
              IF STATUS THEN
                 CALL cl_err("OPEN t559_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t559_bcl INTO g_lqt[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lqt_t.lqt02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE 
                	  CALL t559_lqt(l_ac)                    
                 END IF   
              END IF
              CALL cl_show_fld_cont()    
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lqt[l_ac].* TO NULL
           LET g_lqt[l_ac].before = '0'
           LET g_lqt[l_ac].after = '1'           
           LET g_lqt_t.* = g_lqt[l_ac].*       
           LET g_lqt_o.* = g_lqt[l_ac].*   
           CALL cl_show_fld_cont()        
           NEXT FIELD lqt02
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF          
           IF cl_null(g_lqt[l_ac].lqt03) THEN
              CALL cl_err('','alm-062',1)
              NEXT FIELD lqt03 
           END IF
           
           IF l_flag = 'Y' THEN  
              INSERT INTO lqt_file(lqt01,lqt02,lqt03,lqt04,lqt05,lqt06,lqt07,lqt08,lqtlegal,lqtplant)
              VALUES(g_lqr.lqr01,g_lqt[l_ac].lqt02,
                     g_lqt[l_ac].lqt03,g_lqt[l_ac].lqt04,
                     g_lqt[l_ac].lqt05,g_lqt[l_ac].lqt06,g_lqt[l_ac].lqt07,g_lqt[l_ac].lqt08,g_legal,g_plant)
              IF SQLCA.sqlcode THEN                   
                 CALL cl_err3("ins","lqr_file",g_lqr.lqr01,"",SQLCA.sqlcode,"","",1)     
                 CANCEL INSERT
              ELSE
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 CALL t559_lqt(l_ac)   
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
           ELSE
              CALL s_showmsg() 
              ROLLBACK WORK  
           END IF   
        BEFORE FIELD lqt02                       
           IF g_lqt[l_ac].lqt02 IS NULL OR g_lqt[l_ac].lqt02 = 0 THEN
              SELECT max(lqt02)+1
                INTO g_lqt[l_ac].lqt02
                FROM lqt_file
               WHERE lqt01 = g_lqr.lqr01
              IF g_lqt[l_ac].lqt02 IS NULL THEN
                 LET g_lqt[l_ac].lqt02 = 1
              END IF
           END IF
 
        AFTER FIELD lqt02                      
          IF NOT cl_null(g_lqt[l_ac].lqt02) THEN
             IF g_lqt[l_ac].lqt02 != g_lqt_t.lqt02
                OR g_lqt_t.lqt02 IS NULL THEN
                IF g_lqt[l_ac].lqt02 <= 0 THEN
                   CALL cl_err('','aec-994',0)
                   NEXT FIELD lqt02
                END IF
                SELECT COUNT(*)
                  INTO l_n
                  FROM lqt_file
                 WHERE lqt01 = g_lqr.lqr01
                   AND lqt02 = g_lqt[l_ac].lqt02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_lqt[l_ac].lqt02 = g_lqt_t.lqt02
                   NEXT FIELD lqt02
                ELSE
                   LET l_flag = 'Y'      
                END IF
             END IF
          END IF  
       AFTER FIELD lqt03
           IF NOT cl_null(g_lqt[l_ac].lqt03) THEN
              IF p_cmd = "a" OR
                (p_cmd="u" AND g_lqt[l_ac].lqt03 != g_lqt_t.lqt03)THEN
                 CALL s_showmsg_init()  
                 SELECT COUNT(*)
                   INTO l_n
                   FROM lqt_file
                  WHERE lqt01 = g_lqr.lqr01
                    AND lqt03 = g_lqt[l_ac].lqt03
                 IF l_n > 0 THEN
                    LET l_flag = 'N'
                    CALL s_errmsg('lqt03',g_lqt[l_ac].lqt03,'','alm1104',1) 
                 ELSE
                    CALL t559_lqt03(g_lqt[l_ac].lqt03)
                 END IF
                 IF l_flag = 'N' THEN
                    CALL s_showmsg()
                    LET g_lqt[l_ac].lqt03 = g_lqt_t.lqt03
                    NEXT FIELD lqt03
                 ELSE
                    CALL t559_lqt(l_ac)   
                 END IF 
              END IF               
           END IF    
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_lqt_t.lqt03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lqt_file
               WHERE lqt01 = g_lqr.lqr01
                 AND lqt02 = g_lqt_t.lqt02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lqt_file",g_lqr.lqr01,g_lqt_t.lqt03,SQLCA.sqlcode,"","",1)  
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
              LET g_lqt[l_ac].* = g_lqt_t.*
              CLOSE t559_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lqt[l_ac].lqt03,-263,1)
              LET g_lqt[l_ac].* = g_lqt_t.*
           ELSE 
              IF l_flag = 'Y' THEN        
                 UPDATE lqt_file SET lqt02=g_lqt[l_ac].lqt02,
                                     lqt03=g_lqt[l_ac].lqt03,
                                     lqt04=g_lqt[l_ac].lqt04,
                                     lqt05=g_lqt[l_ac].lqt05,
                                     lqt06=g_lqt[l_ac].lqt06,
                                     lqt07=g_lqt[l_ac].lqt07,
                                     lqt08=g_lqt[l_ac].lqt08,
                                     lqtlegal=g_legal,
                                     lqtplant=g_plant   
                  WHERE lqt01 = g_lqr.lqr01
                    AND lqt02 = g_lqt_t.lqt02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","lqt_file",g_lqr.lqr01,g_lqt_t.lqt03,SQLCA.sqlcode,"","",1)  
                    LET g_lqt[l_ac].* = g_lqt_t.*
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
           DISPLAY  "AFTER ROW!!"      
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lqt[l_ac].* = g_lqt_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lqt.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t559_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30033 Add
           CLOSE t559_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄�
           IF INFIELD(lqt03) AND l_ac > 1 THEN
              LET g_lqt[l_ac].* = g_lqt[l_ac-1].*
              LET g_lqt[l_ac].lqt02 = g_rec_b + 1
              NEXT FIELD lqt02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()       
 
        ON ACTION controlp
           CASE          
             WHEN INFIELD(lqt03) 
               CALL cl_init_qry_var()               
               LET g_qryparam.form ="q_lpk01" 
               LET g_qryparam.default1 = g_lqt[l_ac].lqt03 
               IF p_cmd = 'a' THEN
                  LET g_qryparam.state = "c"    
                  CALL cl_create_qry() RETURNING g_multi_lqt03
                  IF NOT cl_null(g_multi_lqt03) THEN
                      CALL t559_lqt03_m()
                      CALL t559_b_fill(" 1=1")
                      CALL t559_b('a')
                      EXIT INPUT
                 # ELSE
                 #    NEXT FIELD lqt03
                  END IF
               ELSE
                  CALL cl_create_qry() RETURNING g_lqt[l_ac].lqt03
                  DISPLAY BY NAME g_lqt[l_ac].lqt03  
                 # NEXT FIELD lqt03
               END IF
               NEXT FIELD lqt03   
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
       LET g_lqr.lqrmodu = g_user
       LET g_lqr.lqrdate = g_today
    ELSE
   	   LET g_lqr.lqrmodu = NULL
       LET g_lqr.lqrdate = NULL 
   	END IF     
    UPDATE lqr_file SET lqrmodu = g_lqr.lqrmodu,
                        lqrdate = g_lqr.lqrdate
     WHERE lqr01 = g_lqr.lqr01
    
    DISPLAY BY NAME g_lqr.lqrmodu,g_lqr.lqrdate
  
    CLOSE t559_bcl
    COMMIT WORK
#   CALL t559_delall() #CHI-C30002 mark
    CALL t559_delHeader()     #CHI-C30002 add
END FUNCTION
#CHI-C30002 -------- add -------- begin
FUNCTION t559_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lqr.lqr01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lqr_file ",
                  "  WHERE lqr01 LIKE '",l_slip,"%' ",
                  "    AND lqr01 > '",g_lqr.lqr01,"'"
      PREPARE t559_pb1 FROM l_sql 
      EXECUTE t559_pb1 INTO l_cnt 
      
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
         CALL t559_v(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lqr_file WHERE lqr01 = g_lqr.lqr01
         INITIALIZE g_lqr.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t559_lqt03_m()
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_e         LIKE type_file.num5
DEFINE   l_lqt       RECORD LIKE lqt_file.*
DEFINE   l_success   LIKE type_file.chr1
DEFINE   l_lqt02     LIKE lqt_file.lqt02
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   LET l_e = 0 
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_lqt03,"|")
   WHILE tok.hasMoreTokens()
      INITIALIZE l_lqt.* TO NULL
      LET l_lqt.lqt03 = tok.nextToken()
      SELECT count(*) INTO l_n FROM lqt_file
       WHERE lqt01 = g_lqr.lqr01
         AND lqt03 = l_lqt.lqt03
      IF l_n > 0 THEN
         CONTINUE WHILE
      ELSE
         CALL t559_lqt03(l_lqt.lqt03)
         IF l_flag = 'Y' THEN
            SELECT max(lqt02)+1
              INTO l_lqt02
              FROM lqt_file
             WHERE lqt01 = g_lqr.lqr01
            IF l_lqt02 IS NULL THEN
                 LET l_lqt02 = 1
            END IF 
            LET l_lqt.lqt01 = g_lqr.lqr01
            LET l_lqt.lqt02 = l_lqt02
            LET l_lqt.lqt03 = g_lqt[l_ac].lqt03 
            LET l_lqt.lqt04 = g_lqt[l_ac].lqt04
            LET l_lqt.lqt05 = g_lqt[l_ac].lqt05
            LET l_lqt.lqt06 = g_lqt[l_ac].lqt06
            LET l_lqt.lqt07 = g_lqt[l_ac].lqt07
            LET l_lqt.lqt08 = g_lqt[l_ac].lqt08
            LET l_lqt.lqtplant = g_plant
            LET l_lqt.lqtlegal = g_legal
            INSERT INTO lqt_file VALUES(l_lqt.*)
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('',l_lqt.lqt02,'Ins lqt_file',SQLCA.sqlcode,1)
               LET l_success = 'N'
               CONTINUE WHILE
            END IF
         ELSE
            LET l_e = l_e + 1
            CONTINUE WHILE
         END IF   
      END IF
      LET l_ac = l_ac + 1
   END WHILE
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   IF l_e <> 0 THEN
      CALL s_showmsg()
   END IF   
END FUNCTION

FUNCTION t559_delall()
   SELECT COUNT(*) INTO g_cnt FROM lqt_file
    WHERE lqt01 = g_lqr.lqr01
 
   IF g_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lqr_file WHERE lqr01 = g_lqr.lqr01
   END IF
END FUNCTION
FUNCTION t559_b_fill(p_wc1)
DEFINE  p_wc1    STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
    
   LET g_sql = "SELECT lqt02,'',lqt03,'',lqt04,'',lqt05,lqt06,lqt07,'',lqt08,'' from lqt_file",
               " WHERE lqt01 ='",g_lqr.lqr01,"' "
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lqt02 "  
   DISPLAY g_sql
   PREPARE t559_pb FROM g_sql
   DECLARE lqt_cs CURSOR FOR t559_pb
 
   CALL g_lqt.clear()
   LET g_cnt = 1
 
   FOREACH lqt_cs INTO g_lqt[g_cnt].*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL t559_lqt(g_cnt)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lqt.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
FUNCTION t559_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1     
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lqr01",TRUE)
    END IF
END FUNCTION
FUNCTION t559_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1   
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lqr01",FALSE)
   END IF
END FUNCTION

FUNCTION t559_lqr03(p_cmd)
DEFINE    p_cmd         LIKE type_file.chr1,
          l_azf03       LIKE azf_file.azf03,
          l_azf09       LIKE azf_file.azf09,
          l_azfacti     LIKE azf_file.azfacti

   SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file 
    WHERE azf01 = g_lqr.lqr03 AND azf02 = '2' 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1103'
        WHEN l_azfacti = 'N'      LET g_errno = 'alm1105'
        WHEN l_azf09 <> 'I'       LET g_errno = 'alm1106'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE 
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
   END IF
END FUNCTION

FUNCTION t559_lqr04(p_cmd)
DEFINE    p_cmd         LIKE type_file.chr1,
          l_gen02       LIKE gen_file.gen02,
          l_genacti     LIKE gen_file.genacti
   SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
    WHERE gen01 = g_lqr.lqr04        
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-017'
        WHEN l_genacti = 'N'      LET g_errno = 'art-733'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE 
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_gen02 TO FORMONLY.gen02 
   END IF
END FUNCTION

FUNCTION t559_lqt03(l_lqt03_1)
DEFINE l_lpk01         LIKE lpk_file.lpk01,
       l_lpk04         LIKE lpk_file.lpk04,
       l_lpk10         LIKE lpk_file.lpk10,
    #  l_lpf02         LIKE lpf_file.lpf02,
       l_lpc02         LIKE lpc_file.lpc02,   
       sum_lpj07       LIKE lpj_file.lpj07,
       sum_lpj14       LIKE lpj_file.lpj14,
       sum_lpj15       LIKE lpj_file.lpj15,
       l_lpkacti       LIKE lpk_file.lpkacti,
       p_cmd           LIKE type_file.chr1,
       l_lqt03_1       LIKE lqt_file.lqt03
   LET l_flag = 'Y'        
#   SELECT lpk01,lpk04,lpk10,lpf02,lpkacti,SUM(lpj07) ,SUM(lpj14) , SUM(lpj15)
#     INTO l_lpk01,l_lpk04,l_lpk10,l_lpf02,l_lpkacti,sum_lpj07,sum_lpj14,sum_lpj15
#     FROM lpj_file INNER JOIN lpk_file ON lpk01 = lpj01
#                   LEFT JOIN lpf_file ON lpk10 = lpf01
#    WHERE lpj01 = l_lqt03_1 AND lpj09 = '2' 
# GROUP BY lpk01,lpk04,lpk10,lpf02,lpkacti  
   SELECT lpk01,lpk04,lpk10,lpc02,lpkacti,SUM(lpj07) ,SUM(lpj14) , SUM(lpj15)
     INTO l_lpk01,l_lpk04,l_lpk10,l_lpc02,l_lpkacti,sum_lpj07,sum_lpj14,sum_lpj15
     FROM lpj_file INNER JOIN lpk_file ON lpk01 = lpj01
                   LEFT JOIN lpc_file ON lpk10 = lpc01 AND lpc00 = '6' #FUN-D10059 Mod
    WHERE lpj01 = l_lqt03_1 AND lpj09 = '2' 
 GROUP BY lpk01,lpk04,lpk10,lpc02,lpkacti   
   CASE
      WHEN SQLCA.SQLCODE = 100
         #LET g_showmsg = l_lqt03_1,cl_getmsg("alm1570",g_lang)
         CALL s_errmsg('lqt03',l_lqt03_1,'','alm1570',1) 
         LET l_flag = 'N'
      WHEN l_lpkacti = 'N'
         #LET g_showmsg = l_lqt03_1,cl_getmsg("alm1107",g_lang) 
         CALL s_errmsg('lqt03',l_lqt03_1,'','alm1107',1) 
         LET l_flag = 'N'
      OTHERWISE          LET g_showmsg = SQLCA.SQLCODE USING '-------' 
   END CASE 
   IF l_flag = 'Y' THEN
      CALL t559_lqt03_check(l_lqt03_1)
      IF l_flag = 'Y'  THEN
         CALL t559_lqt03_uplevel(l_lpk01,l_lpk10,sum_lpj07,sum_lpj14,sum_lpj15)    
         #IF l_flag = 'Y' THEN
         #   LET g_lqt[l_ac].lpk04 = l_lpk04
         #   LET g_lqt[l_ac].lpf02_1 = l_lpf02
         #   DISPLAY BY NAME g_lqt[l_ac].lpk04
         #   DISPLAY BY NAME g_lqt[l_ac].lpf02_1
         #END IF
      END IF
   END IF
END FUNCTION

FUNCTION t559_lqt03_check(l_lqt03_1)
DEFINE l_lqt03       LIKE lqt_file.lqt03,
       l_lqr01       LIKE lqr_file.lqr01,
       l_lqrconf     LIKE lqr_file.lqrconf,
       l_lqr05       LIKE lqr_file.lqr05,
       l_lqt03_1     LIKE lqt_file.lqt03

   SELECT lqt03,lqr01,lqrconf,lqr05 
     INTO l_lqt03,l_lqr01,l_lqrconf,l_lqr05
     FROM lqt_file INNER JOIN lqr_file ON lqt01 = lqr01
    WHERE lqt03 = l_lqt03_1  
      AND (lqrconf = 'N' OR (lqrconf = 'Y' AND lqr05 <> '2'))
   CASE
      WHEN l_lqrconf = 'N'
         LET g_showmsg = l_lqt03,"/",l_lqr01
         CALL s_errmsg('lqt03',g_showmsg,'','alm1109',1)
         LET l_flag = 'N'
      WHEN (l_lqrconf = 'Y' AND l_lqr05 <> '2')
         LET g_showmsg = l_lqt03,"/",l_lqr01 
         CALL s_errmsg('lqt03',g_showmsg,'','alm1113',1) 
         LET l_flag = 'N'
      WHEN SQLCA.SQLCODE = 100
         LET g_showmsg = ''       
      OTHERWISE          LET g_showmsg = SQLCA.SQLCODE USING '-------'  
   END CASE  
END FUNCTION
 
FUNCTION t559_lqt03_uplevel(l_lpk01,l_lpk10,sum_lpj07,sum_lpj14,sum_lpj15)
DEFINE l_lqq01_t       LIKE lqq_file.lqq01,
       l_lpk01         LIKE lpk_file.lpk01,
       l_lpk10         LIKE lpk_file.lpk10,
       sum_lpj07       LIKE lpj_file.lpj07,
       sum_lpj14       LIKE lpj_file.lpj14,
       sum_lpj15       LIKE lpj_file.lpj15,
       l_n             LIKE type_file.num10,
       l_sql           STRING
DEFINE l_arr     DYNAMIC ARRAY OF RECORD
       lqq01         LIKE lqq_file.lqq01,
       lqq02         LIKE lqq_file.lqq02,
       lqq03         LIKE lqq_file.lqq03,
       lqq04         LIKE lqq_file.lqq04,
       lqq05         LIKE lqq_file.lqq05
                END RECORD
#   LET l_sql = "SELECT lqq01,lqq02,lqq03,lqq04,lqq05 ", 
#               "FROM lpf_file ", 
#               "INNER JOIN lqq_file ON lpf01 = lqq01 ",
#               "WHERE lpf05 = 'Y' ",
#               "ORDER BY lqq01 "
  #FUN-D10059--mark--str---
  #LET l_sql = "SELECT lqq01,lqq02,lqq03,lqq04,lqq05 ", 
  #            "FROM lpc_file ", 
  #            "INNER JOIN lqq_file ON lpc01 = lqq01 ",
  #            "WHERE lpc00 = '6' AND lpcacti = 'Y' ",
  #            "ORDER BY lqq01 "               
  #PREPARE t559_lqt03pre FROM　l_sql
  #DECLARE t559_lqt03cl CURSOR FOR t559_lqt03pre
  #LET l_n = 1
  #LET l_flag = 'N'
  #LET l_lqq01_t = ' '  
  #FOREACH t559_lqt03cl INTO l_arr[l_n].*
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err('foreach:',SQLCA.sqlcode,1)
  #      EXIT FOREACH
  #   END IF
  #   
  #   IF l_arr[l_n].lqq01 <> l_lpk10 THEN #如果抓取的等級與當前等級相同則不比較
  #      IF l_lqq01_t <> l_arr[l_n].lqq01 THEN #同一个等级的每一个条件都判断后，通过l_flag判断是否能够升级
  #         IF l_flag = 'Y' THEN
  #            EXIT FOREACH
  #         END IF
  #         LET l_lqq01_t = l_arr[l_n].lqq01 
  #         LET l_flag = 'Y'   
  #      END IF   
  #      CASE 
  #         WHEN l_arr[l_n].lqq02 = '1'  #判斷累積積分
  #            IF l_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN 
  #               IF sum_lpj14 >= l_arr[l_n].lqq04 AND sum_lpj14 <= l_arr[l_n].lqq05 THEN
  #                  LET l_flag = 'Y'
  #               ELSE 
  #                  LET l_flag = 'N'
  #               END IF
  #            END IF
  #         WHEN l_arr[l_n].lqq02 = '2' #判斷累計金額
  #            IF l_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN
  #               IF sum_lpj15 >= l_arr[l_n].lqq04 AND sum_lpj15 <= l_arr[l_n].lqq05 THEN
  #                  LET l_flag = 'Y'
  #               ELSE 
  #                  LET l_flag = 'N'
  #               END IF
  #            END IF
  #         WHEN l_arr[l_n].lqq02 = '3' #判斷累計消費次數
  #            IF l_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN
  #               IF sum_lpj07 >= l_arr[l_n].lqq04 AND sum_lpj07 <= l_arr[l_n].lqq05 THEN
  #                  LET l_flag = 'Y'
  #               ELSE 
  #                  LET l_flag = 'N'
  #               END IF
  #            END IF
  #         OTHERWISE  LET l_flag = 'N'
  #      END CASE
  #   END IF 
  #   LET l_n = l_n + 1
  #END FOREACH 
  #FUN-D10059--mark--end---

   CALL t559sub_lqt03_uplevel(l_lpk01,l_lpk10,sum_lpj15,sum_lpj14,sum_lpj07,l_flag,'1=1',g_lqr.lqrplant)   #FUN-D10059 add
      RETURNING l_flag,l_n,l_lqq01_t            #FUN-D10059 add

   IF l_flag = 'N' AND l_n = 1 THEN
      LET g_showmsg = l_lpk01,"/",l_lpk10
      CALL s_errmsg('lqt03,lpk10',g_showmsg,'','alm1569',1)
   END IF    
   IF l_flag = 'N' AND l_n != 1 THEN#經過判斷后l_flag為N則表示會員編號未符合升等資格
      #LET g_showmsg = cl_getmsg("alm1109",g_lang),l_lpk01,
      #                cl_getmsg("alm1102",g_lang)
         CALL s_errmsg('lqt03',l_lpk01,'','alm1102',1)
   END IF      
   IF l_flag = 'Y' THEN  
      LET g_lqt[l_ac].lqt03 = l_lpk01
      LET g_lqt[l_ac].lqt04 = l_lpk10
      LET g_lqt[l_ac].lqt05 = sum_lpj15
      LET g_lqt[l_ac].lqt06 = sum_lpj14
      LET g_lqt[l_ac].lqt07 = sum_lpj07
      LET g_lqt[l_ac].lqt08 = l_lqq01_t   
      
   END IF   
END FUNCTION
 
FUNCTION t559_lqt(l_ac1)
DEFINE l_ac1   LIKE type_file.num5
       LET g_lqt[l_ac1].before = '0'
       LET g_lqt[l_ac1].after = '1'
       SELECT lpk04 INTO g_lqt[l_ac1].lpk04 FROM lpk_file
        WHERE lpk01=g_lqt[l_ac1].lqt03
#       SELECT lpf02 INTO g_lqt[l_ac1].lpf02_1 FROM lpf_file
#        WHERE lpf01 = g_lqt[l_ac1].lqt04
#       SELECT lpf02 INTO g_lqt[l_ac1].lpf02_2 FROM lpf_file
#        WHERE lpf01 = g_lqt[l_ac1].lqt08 
       SELECT lpc02 INTO g_lqt[l_ac1].lpc02_1 FROM lpc_file
        WHERE lpc01 = g_lqt[l_ac1].lqt04 AND lpc00 = '6'
       SELECT lpc02 INTO g_lqt[l_ac1].lpc02_2 FROM lpc_file
        WHERE lpc01 = g_lqt[l_ac1].lqt08 AND lpc00 = '6'        
END FUNCTION
FUNCTION t559_yes() 
DEFINE l_lni10    LIKE lni_file.lni10
DEFINE l_n        LIKE type_file.num5
DEFINE l_lpk10    LIKE lpk_file.lpk10
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_f        LIKE type_file.chr1
DEFINE l_gen02    LIKE  gen_file.gen02
DEFINE l_lqt   DYNAMIC ARRAY OF RECORD      
       lqt03         LIKE lqt_file.lqt03, 
       lqt04         LIKE lqt_file.lqt04
        END RECORD
   IF cl_null(g_lqr.lqr01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF

#CHI-C30107 ----------------- add --------------------- begin
   IF g_lqr.lqracti='N' THEN
      CALL cl_err('','alm-048',0)
      RETURN
   END IF
   
   IF g_lqr.lqrconf='Y' AND g_lqr.lqr05 = '1' THEN 
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_lqr.lqr05 = '2' THEN
      CALL cl_err('','alm-942',0)
      RETURN
   END IF

   IF g_lqr.lqrconf = 'X' THEN
      CALL cl_err('','alm-674',0)
      RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN 
      RETURN
   END IF 
#CHI-C30107 ----------------- add --------------------- end
   SELECT * INTO g_lqr.* FROM lqr_file WHERE lqr01=g_lqr.lqr01 
   IF g_lqr.lqracti='N' THEN
      CALL cl_err('','alm-048',0)
      RETURN
   END IF
   
   IF g_lqr.lqrconf='Y' AND g_lqr.lqr05 = '1' THEN 
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_lqr.lqr05 = '2' THEN
      CALL cl_err('','alm-942',0)
      RETURN
   END IF

   IF g_lqr.lqrconf = 'X' THEN
      CALL cl_err('','alm-674',0)
      RETURN
   END IF   

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   OPEN t559_cl USING g_lqr.lqr01
   IF STATUS THEN
      CALL cl_err("OPEN t559_cl:", STATUS, 1)
      CLOSE t559_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t559_cl INTO g_lqr.*    
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)      
         CLOSE t559_cl
         ROLLBACK WORK
         RETURN
      END IF
     
      LET l_sql = "SELECT lqt03,lqt04 FROM lqt_file",
                  " WHERE lqt01 = '",g_lqr.lqr01,"'"
      PREPARE t559_pre1 FROM　l_sql
      DECLARE t559_cl1 CURSOR FOR t559_pre1
      LET l_cnt = 1
      LET l_f = 'Y'
      FOREACH t559_cl1 INTO l_lqt[l_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         SELECT lpk10 INTO l_lpk10 FROM lpk_file
          WHERE lpk01 = l_lqt[l_cnt].lqt03
         IF l_lpk10 <> l_lqt[l_cnt].lqt04 THEN
            LET l_f = 'N'
            #LET g_showmsg = l_lqt[l_cnt].lqt03,cl_getmsg("alm1108",g_lang)
            #CALL s_errmsg('lqt03',g_showmsg,'','',1)
            
            CALL s_errmsg('lqt03',l_lqt[l_cnt].lqt03,'','alm1108',1)   
         END IF   
         LET l_cnt = l_cnt + 1
      END FOREACH
      IF l_f ='Y' THEN
#CHI-C30107 --------- mark -------- begin
#        IF NOT cl_confirm('alm-006') THEN 
#           RETURN
#        END IF 
#CHI-C30107 --------- mark -------- end
         UPDATE lqr_file SET lqr05 = '1',lqrconf = 'Y',lqrmodu = g_user,lqrdate = g_today,
                             lqrconu = g_user,lqrcond = g_today
          WHERE lqr01 = g_lqr.lqr01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqr_file",g_lqr.lqr01,"",STATUS,"","",1) 
            LET g_success = 'N'
         ELSE 
            LET g_lqr.lqr05 = '1'
            LET g_lqr.lqrconf = 'Y'
            LET g_lqr.lqrmodu = g_user
            LET g_lqr.lqrdate = g_today
            LET g_lqr.lqrconu = g_user
            LET g_lqr.lqrcond = g_today
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lqr.lqrconu
            DISPLAY l_gen02 TO FORMONLY.lqrconu_desc
            DISPLAY BY NAME g_lqr.lqr05,g_lqr.lqrconf,g_lqr.lqrmodu,g_lqr.lqrdate,g_lqr.lqrcond,g_lqr.lqrconu
            CALL t559_pic()
         END IF 
      END IF
      IF g_success = 'Y' AND l_f = 'Y' THEN
         COMMIT WORK
      ELSE
         CALL s_showmsg()
         ROLLBACK WORK
      END IF
END FUNCTION

FUNCTION t559_no()
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_gen02  LIKE gen_file.gen02    #CHI-D20015
   IF cl_null(g_lqr.lqr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lqr.*
   FROM lqr_file
   WHERE lqr01=g_lqr.lqr01
   IF g_lqr.lqracti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lqr.lqrconf='N' THEN
      CALL cl_err('',9002,0)
      RETURN
   END IF

   IF g_lqr.lqr05 = '2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF

   IF g_lqr.lqrconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF   
   IF g_lqr.lqrconf = 'Y' AND g_lqr.lqr05 = '1' THEN
      BEGIN WORK
      LET g_success = 'Y'
      OPEN t559_cl USING g_lqr.lqr01
      IF STATUS THEN
         CALL cl_err("OPEN t559_cl:", STATUS, 0)
         CLOSE t559_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH t559_cl INTO g_lqr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)
         CLOSE t559_cl
         ROLLBACK WORK
         RETURN
      END IF
   
      IF NOT cl_confirm('alm-008') THEN
         RETURN
      END IF

   #  UPDATE lqr_file SET lqrconf = 'N',lqr05 = '0',lqrcond = NULL,lqrconu = NULL,lqrmodu = g_user,lqrdate = g_today  #CHI-D20015 mark
   #CHI-D20015--add--str--
      UPDATE lqr_file SET lqrconf = 'N',lqr05 = '0',
                          lqrcond = g_today,lqrconu = g_user,
                          lqrmodu = g_user,lqrdate = g_today
   #CHI-D20015--add--end--
       WHERE lqr01 = g_lqr.lqr01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lqr_file",g_lqr.lqr01,"",STATUS,"","",1)
         LET g_success = 'N'
      ELSE
         LET g_lqr.lqrconf = 'N'
         LET g_lqr.lqr05 = '0'
         LET g_lqr.lqrmodu = g_user
         LET g_lqr.lqrdate = g_today
    #     LET g_lqr.lqrconu = NULL   #CHI-D20015 mark
    #     LET g_lqr.lqrcond = NULL   #CHI-D20015 mark
         LET g_lqr.lqrconu = g_user  #CHI-D20015 add
         LET g_lqr.lqrcond =  g_today #CHI-D20015 add
    #     DISPLAY '   ' TO FORMONLY.lqrconu_desc
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lqr.lqrconu   #CHI-D20015 add
         DISPLAY l_gen02 TO FORMONLY.lqrconu_desc                              #CHI-D20015 add
         DISPLAY BY NAME g_lqr.lqrconf,g_lqr.lqr05,g_lqr.lqrmodu,g_lqr.lqrdate,g_lqr.lqrcond,g_lqr.lqrconu
         CALL t559_pic()
      END IF
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF   
END FUNCTION

FUNCTION t559_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

DEFINE l_cnt   LIKE type_file.num5
   IF cl_null(g_lqr.lqr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lqr.*
   FROM lqr_file
   WHERE lqr01=g_lqr.lqr01
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lqr.lqrconf='X' THEN RETURN END IF
    ELSE
       IF g_lqr.lqrconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_lqr.lqracti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lqr.lqrconf='Y' AND g_lqr.lqr05 <> '2' THEN
     #CALL cl_err('','apy-705',0)
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_lqr.lqrconf='Y' AND g_lqr.lqr05 = '2' THEN
      CALL cl_err('','axm-015',0)
      RETURN
   END IF
   #IF g_lqr.lqrconf = 'X' THEN
   #   CALL cl_err('',9024,0)
   #   RETURN
   #END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t559_cl USING g_lqr.lqr01
   IF STATUS THEN
      CALL cl_err("OPEN t559_cl:", STATUS, 0)
      CLOSE t559_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t559_cl INTO g_lqr.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)
      CLOSE t559_cl
      ROLLBACK WORK
      RETURN
   END IF
  
   IF cl_void(0,0,g_lqr.lqrconf) THEN
      IF g_lqr.lqrconf ='N' THEN
         LET g_lqr.lqrconf='X'
      ELSE
         LET g_lqr.lqrconf='N'
      END IF
   END IF   
   UPDATE lqr_file SET lqrconf = g_lqr.lqrconf, lqrmodu = g_user,lqrdate = g_today,
                       lqrcond = NULL,lqrconu = NULL
    WHERE lqr01 = g_lqr.lqr01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0THEN
      CALL cl_err3("upd","lqr_file",g_lqr.lqr01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lqr.lqrconf = g_lqr.lqrconf
      LET g_lqr.lqrmodu = g_user
      LET g_lqr.lqrdate = g_today
      LET g_lqr.lqrcond = NULL
      LET g_lqr.lqrconu = NULL
      DISPLAY '   ' TO FORMONLY.lqrconu_desc
      DISPLAY BY NAME g_lqr.lqrconf,g_lqr.lqrmodu,g_lqr.lqrdate,g_lqr.lqrconu,g_lqr.lqrcond
      
      CALL t559_pic()
   END IF 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t559_issue()
DEFINE l_lqt   DYNAMIC ARRAY OF RECORD      
        lqt03         LIKE lqt_file.lqt03, 
        lqt04         LIKE lqt_file.lqt04
        END RECORD
DEFINE l_lpk10        LIKE lpk_file.lpk10   
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_sql          STRING        
DEFINE l_f            LIKE type_file.chr1
   IF cl_null(g_lqr.lqr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lqr.*
   FROM lqr_file
   WHERE lqr01=g_lqr.lqr01
   IF g_lqr.lqracti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lqr.lqr05 = '2' THEN
      CALL cl_err('','alm-944',0)
      RETURN
   END IF
   IF g_lqr.lqrconf='N' THEN
      CALL cl_err('','alm-936',0)
      RETURN
   END IF
   IF g_lqr.lqrconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   IF g_lqr.lqrconf = 'Y' AND g_lqr.lqr05 <> '2' THEN
      BEGIN WORK
      LET g_success = 'Y'
      CALL s_showmsg_init()
      OPEN t559_cl USING g_lqr.lqr01
      IF STATUS THEN
         CALL cl_err("OPEN t559_cl:", STATUS, 1)
         CLOSE t559_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH t559_cl INTO g_lqr.*
         IF SQLCA.sqlcode THEN
         CALL cl_err(g_lqr.lqr01,SQLCA.sqlcode,0)
         CLOSE t559_cl
         ROLLBACK WORK
         RETURN
      END IF
      LET l_sql = "SELECT lqt03,lqt04 FROM lqt_file",
                  " WHERE lqt01 = '",g_lqr.lqr01,"'"
      PREPARE t559_prec FROM　l_sql
      DECLARE t559_clc CURSOR FOR t559_prec
      LET l_cnt = 1
      LET l_f = 'Y'
      FOREACH t559_clc INTO l_lqt[l_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT lpk10 INTO l_lpk10 FROM lpk_file
          WHERE lpk01 = l_lqt[l_cnt].lqt03
         IF l_lpk10 <> l_lqt[l_cnt].lqt04 THEN 
            LET l_f = 'N' 
            #LET g_showmsg = l_lqt[l_cnt].lqt03,cl_getmsg("alm1114",g_lang)
            #CALL s_errmsg('lqt03',g_showmsg,'check lqt03','',1) 
            CALL s_errmsg('lqt03',l_lqt[l_cnt].lqt03,'','alm1114',1)
         END IF         
      END FOREACH
      IF l_f = 'Y' THEN
         IF NOT cl_confirm('art-859') THEN
            RETURN
         END IF
         UPDATE lqr_file SET lqr05 = '2', lqrmodu = g_user,lqrdate = g_today
          WHERE lqr01 = g_lqr.lqr01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqr_file",g_lqr.lqr01,"",STATUS,"","",1)
            LET g_success = 'N'
         ELSE
            LET g_lqr.lqr05 = '2'
            LET g_lqr.lqrmodu = g_user
            LET g_lqr.lqrdate = g_today
            DISPLAY BY NAME g_lqr.lqr05,g_lqr.lqrmodu,g_lqr.lqrdate
            CALL t559_issue2(g_lqr.lqr01)
         END IF
      END IF   
      
      IF g_success = 'Y' AND l_f = 'Y' THEN
         COMMIT WORK
      ELSE
         CALL s_showmsg()
         ROLLBACK WORK
      END IF
      
   END IF   
END FUNCTION
FUNCTION t559_issue2(l_lqr01)
DEFINE l_lqt   DYNAMIC ARRAY OF RECORD      
        lqt03         LIKE lqt_file.lqt03, 
        lqt08         LIKE lqt_file.lqt08
                END RECORD
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_lqr01        LIKE lqr_file.lqr01
DEFINE l_sql          STRING
   LET l_sql = "SELECT lqt03,lqt08 FROM lqt_file",
               " WHERE lqt01 = '",l_lqr01,"'"
   PREPARE t559_ipre FROM　l_sql
   DECLARE t559_icl CURSOR FOR t559_ipre
   LET l_cnt = 1
   FOREACH t559_icl INTO l_lqt[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      UPDATE lpk_file SET lpk10 = l_lqt[l_cnt].lqt08,lpkmodu = g_user,lpkdate = g_today
       WHERE lpk01 = l_lqt[l_cnt].lqt03 
      IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lqk_file",l_lqt[l_cnt].lqt03 ,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH 
END FUNCTION      
FUNCTION t559_pic()
   IF g_lqr.lqrconf='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
   CALL cl_set_field_pic(g_lqr.lqrconf,"","","",g_chr,"")
END FUNCTION
#FUN-B80051
#FUN-C90070-------add------str
FUNCTION t559_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_lpk04   LIKE lpk_file.lpk04,
       l_lpc02_1 LIKE lpc_file.lpc02,
       l_lpc02_2 LIKE lpc_file.lpc02,
       sr       RECORD
                lqr01     LIKE lqr_file.lqr01,
                lqr02     LIKE lqr_file.lqr02,
                lqr03     LIKE lqr_file.lqr03,
                lqr04     LIKE lqr_file.lqr04,
                lqrconf   LIKE lqr_file.lqrconf,
                lqrcond   LIKE lqr_file.lqrcond,
                lqrconu   LIKE lqr_file.lqrconu,
                lqr05     LIKE lqr_file.lqr05,
                lqt02     LIKE lqt_file.lqt02,
                lqt03     LIKE lqt_file.lqt03,
                lqt04     LIKE lqt_file.lqt04,
                lqt05     LIKE lqt_file.lqt05,
                lqt06     LIKE lqt_file.lqt06,
                lqt07     LIKE lqt_file.lqt07,
                lqt08     LIKE lqt_file.lqt08
                END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lqruser', 'lqrgrup')
     IF cl_null(g_wc) THEN LET g_wc = " lqr01 = '",g_lqr.lqr01,"'" END IF
     IF cl_null(g_wc1) THEN LET g_wc1 = " lqt01 = '",g_lqr.lqr01,"'" END IF
     LET l_sql = "SELECT lqr01,lqr02,lqr03,lqr04,lqrconf,lqrcond,lqrconu,lqr05,",
                 "       lqt02,lqt03,lqt04,lqt05,lqt06,lqt07,lqt08",
                 "  FROM lqr_file,lqt_file",
                 " WHERE lqr01 = lqt01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc1 CLIPPED
     PREPARE t559_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t559_cs1 CURSOR FOR t559_prepare1

     DISPLAY l_table
     FOREACH t559_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
  
       LET l_lpk04 = ' '
       SELECT lpk04 INTO l_lpk04 FROM lpk_file WHERE lpk01 = sr.lqt03
       LET l_lpc02_1 = ' '
       SELECT lpc02 INTO l_lpc02_1 FROM lpc_file WHERE lpc00 = '6' AND lpc01 = sr.lqt04
       LET l_lpc02_2 = ' '
       SELECT lpc02 INTO l_lpc02_2 FROM lpc_file WHERE lpc00 = '6' AND lpc01 = sr.lqt08
       EXECUTE insert_prep USING sr.*,l_lpk04,l_lpc02_1,l_lpc02_2
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lqr01,lqr02,lqr03,lqr04,lqrconf,lqrcond,lqrconu,lqr05')
          RETURNING g_wc2
     CALL cl_wcchp(g_wc1,'lqt01,lqt02,lqt03,lqt04,lqt05,lqt06,lqt07,lqt08')
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
     CALL t559_grdata() 
END FUNCTION

FUNCTION t559_grdata()
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
       LET handler = cl_gre_outnam("almt559")
       IF handler IS NOT NULL THEN
           START REPORT t559_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lqr01,lqt02"
           DECLARE t559_datacur1 CURSOR FROM l_sql
           FOREACH t559_datacur1 INTO sr1.*
               OUTPUT TO REPORT t559_rep(sr1.*)
           END FOREACH
           FINISH REPORT t559_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t559_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lqrconf  STRING
    DEFINE l_lqr05    STRING

    
    ORDER EXTERNAL BY sr1.lqr01,sr1.lqt02
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc2,g_wc3,g_wc4
              
        BEFORE GROUP OF sr1.lqr01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.lqt02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lqrconf = cl_gr_getmsg("gre-304",g_lang,sr1.lqrconf)
            LET l_lqr05 = cl_gr_getmsg("gre-308",g_lang,sr1.lqr05)
            PRINTX sr1.*
            PRINTX l_lqrconf
            PRINTX l_lqr05

        AFTER GROUP OF sr1.lqr01
        AFTER GROUP OF sr1.lqt02

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
