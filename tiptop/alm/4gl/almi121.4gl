# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almi121.4gl
# Descriptions...: 區域基本資料維護作業
# Date & Author..: No.FUN-B80141 11/08/24 By nanbing

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
      g_lmy1      RECORD
          lmystore      LIKE lmy_file.lmystore,
          lmylegal      LIKE lmy_file.lmylegal,
          lmy01         LIKE lmy_file.lmy01,
          lmy02         LIKE lmy_file.lmy02
                  END RECORD, 
      g_lmy1_t    RECORD      
          lmystore      LIKE lmy_file.lmystore,
          lmylegal      LIKE lmy_file.lmylegal,
          lmy01         LIKE lmy_file.lmy01,
          lmy02         LIKE lmy_file.lmy02
                  END RECORD, 
      g_lmy    DYNAMIC ARRAY of RECORD      
         lmy03          LIKE lmy_file.lmy03,
         lmy04          LIKE lmy_file.lmy04,
         lmy05          LIKE lmy_file.lmy05,
         lmy06          LIKE lmy_file.lmy06,
         lmy07          LIKE lmy_file.lmy07,
         lmyacti        LIKE lmy_file.lmyacti
                   END RECORD,
      g_lmy_t    RECORD 
         lmy03          LIKE lmy_file.lmy03,
         lmy04          LIKE lmy_file.lmy04,
         lmy05          LIKE lmy_file.lmy05,
         lmy06          LIKE lmy_file.lmy06,
         lmy07          LIKE lmy_file.lmy07,
         lmyacti        LIKE lmy_file.lmyacti
                   END RECORD,
      g_lmy_l    DYNAMIC ARRAY of RECORD  
         lmystore       LIKE lmy_file.lmystore,
         rtz13          LIKE rtz_file.rtz13,
         lmylegal       LIKE lmy_file.lmylegal,
         azt02          LIKE azt_file.azt02,
         lmy01          LIKE lmy_file.lmy01,
         lmb03          LIKE lmb_file.lmb03,
         lmy02          LIKE lmy_file.lmy02,
         lmc04          LIKE lmc_file.lmc04,  
         lmy03          LIKE lmy_file.lmy03,
         lmy04          LIKE lmy_file.lmy04,
         lmy05          LIKE lmy_file.lmy05,
         lmy06          LIKE lmy_file.lmy06,
         lmy07          LIKE lmy_file.lmy07,
         lmyacti        LIKE lmy_file.lmyacti
                   END RECORD,                   
      g_wc              STRING, 
      g_sql             STRING, 
      g_ss              LIKE type_file.chr1,   
      g_rec_b           LIKE type_file.num5,  
      g_rec_b1          LIKE type_file.num5,  
      l_ac              LIKE type_file.num5,
      l_ac1             LIKE type_file.num5    
DEFINE g_bp_flag        LIKE type_file.chr10            
DEFINE g_forupd_sql     STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt            LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose  
DEFINE g_on_change      LIKE type_file.num5      
DEFINE g_row_count      LIKE type_file.num5       
DEFINE g_curs_index     LIKE type_file.num5      
DEFINE g_str            STRING 
DEFINE g_argv1          LIKE lmy_file.lmystore                  
DEFINE g_argv2          LIKE lmy_file.lmy01
DEFINE g_argv3          LIKE lmy_file.lmy02
DEFINE g_jump           LIKE type_file.num10  
DEFINE g_msg            LIKE type_file.chr1000   
DEFINE mi_no_ask        LIKE type_file.num5

MAIN

   DEFINE p_row,p_col   LIKE type_file.num5    
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    
 
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW i121_w AT p_row,p_col WITH FORM "alm/42f/almi121"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init()
   LET g_forupd_sql =" SELECT lmystore,lmy01,lmy02 FROM lmy_file ",  
                      "  WHERE lmystore = ? AND lmy01 = ? AND lmy02 = ? ",  
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i121_cl CURSOR FROM g_forupd_sql
   
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN
      CALL i121_q()
   END IF
   CALL i121_menu()
   CLOSE WINDOW i121_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN 

FUNCTION i121_cs()
   CLEAR FORM
   CALL g_lmy.clear()
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = g_wc CLIPPED," lmystore = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc CLIPPED," AND lmy01 = '",g_argv2,"'"
         IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc CLIPPED," AND lmy02 = '",g_argv3,"'"
         END IF   
      END IF 
      LET g_argv1 = NULL
      LET g_argv2 = NULL
      LET g_argv3 = NULL
   ELSE
      CONSTRUCT g_wc ON lmystore,lmylegal,lmy01,lmy02,lmy03,lmy04,
                        lmy05,lmy06,lmy07,lmyacti
           FROM lmystore,lmylegal,lmy01,lmy02,s_lmy[1].lmy03,s_lmy[1].lmy04,
                s_lmy[1].lmy05, s_lmy[1].lmy06, s_lmy[1].lmy07, s_lmy[1].lmyacti          
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(lmystore)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmystore" 
                  LET g_qryparam.where = " lmystore IN ",g_auth," "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmystore
                  NEXT FIELD lmystore
               WHEN INFIELD(lmylegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmylegal" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET g_qryparam.where = " lmystore IN ",g_auth," " 
                  DISPLAY g_qryparam.multiret TO lmylegal
                  NEXT FIELD lmylegal

               WHEN INFIELD(lmy01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmy01" 
                  LET g_qryparam.where = " lmystore IN",g_auth," " 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmy01
                  NEXT FIELD lmy01
               WHEN INFIELD(lmy02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmy02"
                  LET g_qryparam.where = " lmystore IN ",g_auth," "  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmy02
                  NEXT FIELD lmy02

               WHEN INFIELD(lmy03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmy03" 
                  LET g_qryparam.where = " lmystore IN ",g_auth," "  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmy03
                  NEXT FIELD lmy03
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
            CALL cl_qbe_select()
         ON ACTION qbe_save
         CALL cl_qbe_save()

      END CONSTRUCT
      LET g_wc = g_wc CLIPPED
      IF INT_FLAG THEN
         LET g_wc = NULL
         RETURN
      END IF 
   END IF  
   LET g_sql = "SELECT UNIQUE lmystore,lmylegal,lmy01,lmy02 FROM lmy_file ",
                  " WHERE ", g_wc CLIPPED,
                  "   AND lmystore IN ",g_auth, 
                  " ORDER BY lmystore,lmy01,lmy02"
 
   PREPARE i121_prepare FROM g_sql
   DECLARE i121_cs                         
       SCROLL CURSOR WITH HOLD FOR i121_prepare                
   LET g_sql="SELECT COUNT(*) FROM ",
             "( SELECT DISTINCT lmystore,lmy01,lmy02 FROM lmy_file ",
             "WHERE ",g_wc CLIPPED,"  AND lmystore IN ",g_auth, ")"
   PREPARE i121_precount FROM g_sql
   DECLARE i121_count CURSOR FOR i121_precount       
END FUNCTION       
FUNCTION i121_menu()
DEFINE l_wc            STRING   
DEFINE l_cmd           STRING  
   WHILE TRUE
      CALL i121_bp("G")
      
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i121_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i121_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i121_r()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i121_b()
            ELSE
               LET g_action_choice = NULL
            END IF  
         WHEN "ground"
            IF cl_chk_act_auth() THEN
              #IF l_ac > 0 THEN
              #   IF NOT cl_null(g_lmy1.lmystore) AND NOT cl_null(g_lmy1.lmy01)
              #      AND NOT cl_null(g_lmy1.lmy02) AND NOT cl_null(g_lmy[l_ac].lmy03) THEN
              #      LET l_cmd = "almt130  '",g_lmy1.lmystore,"' '",g_lmy1.lmy01,"' '",g_lmy1.lmy02,"' '",g_lmy[l_ac].lmy03 CLIPPED,"'"
              #      CALL cl_cmdrun(l_cmd)
              #   END IF   
              #END IF   
               LET l_cmd = "almt130 " #Mod By shi
               CALL cl_cmdrun(l_cmd)
            END IF   
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lmy),base.TypeInfo.create(g_lmy_l),'')
            END IF

      END CASE
   END WHILE
END FUNCTION    
FUNCTION i121_a()                            # Add  輸入
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_azt02    LIKE azt_file.azt02
   MESSAGE ""
   CLEAR FORM
   CALL g_lmy.clear()
   INITIALIZE g_lmy1.* LIKE lmy_file.*
   INITIALIZE g_lmy1_t.* LIKE lmy_file.*

   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_lmy1.lmystore = g_plant
      LET g_lmy1.lmylegal = g_legal
      CALL i121_i("a")                      
 
      IF INT_FLAG THEN 
        INITIALIZE g_lmy1.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_lmy.clear()
      ELSE
         CALL i121_b_fill('1=1') 
      END IF
      LET g_lmy1_t.*=g_lmy1.* 
      CALL i121_b()                                   
      EXIT WHILE
   END WHILE
END FUNCTION 
FUNCTION i121_i(p_cmd)                      
 
   DEFINE   p_cmd        LIKE type_file.chr1    
   DEFINE   l_n          LIKE type_file.num5   
   DEFINE   l_lmc04      LIKE lmc_file.lmc04
   DEFINE   l_lmy01      LIKE lmy_file.lmy01
   LET g_ss = 'N'
 
   DISPLAY g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02 TO lmystore,lmylegal,lmy01,lmy02
   CALL i121_lmystore('d')
   CALL cl_set_head_visible("","YES")   
   INPUT g_lmy1.lmystore,g_lmy1.lmy01,g_lmy1.lmy02 WITHOUT DEFAULTS FROM lmystore,lmy01,lmy02
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i121_set_entry(p_cmd)
          CALL i121_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
      AFTER FIELD lmystore
         IF g_lmy1.lmystore IS NOT NULL THEN
            CALL i121_lmystore(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lmy1.lmystore,g_errno,1)
               LET g_lmy1.lmystore = g_lmy1_t.lmystore
               LET INT_FLAG = 1
               EXIT INPUT
            END IF
         END IF   
      AFTER FIELD lmy01
         IF g_lmy1.lmy01 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lmy1.lmy01 != g_lmy1_t.lmy01)THEN
               CALL i121_lmy01(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lmy1.lmy01,g_errno,1)
                  LET g_lmy1.lmy01 = g_lmy1_t.lmy01
                  
                  NEXT FIELD lmy01
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.lmb03
         END IF
 
      BEFORE FIELD lmy02
         IF cl_null(g_lmy1.lmy01) THEN
            CALL cl_err('','alm-390',0)
            NEXT FIELD lmy01
         END IF
 
      AFTER FIELD lmy02
         IF g_lmy1.lmy02 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lmy1.lmy02 != g_lmy1_t.lmy02)THEN
               CALL i121_lmy02(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lmy1.lmy02,g_errno,1)
                  LET g_lmy1.lmy02 = g_lmy1_t.lmy02
                  NEXT FIELD lmy02
               END IF
            END IF
         ELSE 
            DISPLAY '' TO FORMONLY.lmc04
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF NOT cl_null(g_lmy1.lmystore) AND NOT cl_null(g_lmy1.lmy01) AND NOT cl_null(g_lmy1.lmy02) THEN
            IF g_lmy1.lmystore != g_lmy1_t.lmystore OR cl_null(g_lmy1_t.lmystore) 
               OR g_lmy1.lmy01 != g_lmy1_t.lmy01 OR cl_null(g_lmy1_t.lmy01) 
               OR g_lmy1.lmy02 != g_lmy1_t.lmy02 OR cl_null(g_lmy1_t.lmy02) THEN
               SELECT COUNT(*) INTO g_cnt FROM lmy_file
                WHERE lmy01 = g_lmy1.lmy01
                  AND lmy02 = g_lmy1.lmy02
                  AND lmystore = g_lmy1.lmystore
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
                  IF p_cmd = 'u' THEN
                     CALL cl_err('','alm1022',0)
                     LET g_lmy1.lmystore = g_lmy1_t.lmystore
                     LET g_lmy1.lmy01 = g_lmy1_t.lmy01
                     LET g_lmy1.lmy02 = g_lmy1_t.lmy02
                     NEXT FIELD lmy01
                  END IF
               END IF
            END IF
         END IF
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(lmy01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmy1"
               LET g_qryparam.default1 = g_lmy1.lmy01
               LET g_qryparam.default2 = g_lmy1.lmy02
               LET g_qryparam.default3 = l_lmc04
               LET g_qryparam.where = " lmcstore = '",g_lmy1.lmystore,"'"
               CALL cl_create_qry() 
                  RETURNING g_lmy1.lmy01,g_lmy1.lmy02,l_lmc04
               DISPLAY BY NAME g_lmy1.lmy01,g_lmy1.lmy02
               DISPLAY l_lmc04 TO FORMONLY.lmc04
               NEXT FIELD lmy01
            WHEN INFIELD(lmy02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmy1"
               LET g_qryparam.default1 = g_lmy1.lmy01
               LET g_qryparam.default2 = g_lmy1.lmy02
               LET g_qryparam.default3 = l_lmc04
               LET g_qryparam.where = " lmcstore = '",g_lmy1.lmystore,"'", " AND ",
                                      "lmc02 = '",g_lmy1.lmy01,"'" 
               CALL cl_create_qry() 
                  RETURNING g_lmy1.lmy01,g_lmy1.lmy02,l_lmc04
               DISPLAY BY NAME g_lmy1.lmy01,g_lmy1.lmy02
               DISPLAY l_lmc04 TO FORMONLY.lmc04
               NEXT FIELD lmy02
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
END FUNCTION

FUNCTION i121_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   INITIALIZE g_lmy1.* TO NULL
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM 
   CALL g_lmy.clear()
   LET g_wc = NULL
   CALL i121_cs()                         
   IF INT_FLAG THEN                              
      LET INT_FLAG = 0
      CLEAR FORM 
      CALL g_lmy.clear()
      CALL g_lmy_l.clear()
      RETURN
   END IF
   OPEN i121_cs                        
   IF SQLCA.SQLCODE THEN                         
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_lmy1.* TO NULL
      CLEAR FORM 
      CALL g_lmy.clear()
      CALL g_lmy_l.clear()
   ELSE
      OPEN i121_count
      FETCH i121_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt 
      CALL i121_list_fill()
      CALL i121_fetch('F')              
    END IF
END FUNCTION
FUNCTION i121_r()
DEFINE l_n     LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_lmy1.lmystore) OR cl_null(g_lmy1.lmy01) OR cl_null(g_lmy1.lmy02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF g_lmy1.lmystore <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 
   SELECT COUNT(*) INTO l_n 
     FROM lmd_file
    WHERE lmdstore = g_lmy1.lmystore
      AND lmd03 = g_lmy1.lmy01
      AND lmd04 = g_lmy1.lmy02
   IF l_n > 0 THEN
      CALL cl_err('','alm1028',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n 
     FROM lia_file
    WHERE liaplant = g_lmy1.lmystore
      AND lia07 = g_lmy1.lmy01
      AND lia08 = g_lmy1.lmy02
   IF l_n > 0 THEN
      CALL cl_err('','alm1026',0)
      RETURN
   END IF     
   BEGIN WORK
 
   OPEN i121_cl USING g_lmy1.lmystore,g_lmy1.lmy01,g_lmy1.lmy02
   IF STATUS THEN
      CALL cl_err("OPEN i121_cl:", STATUS, 1)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i121_show()
 
   IF cl_delh(0,0) THEN                 
      DELETE FROM lmy_file 
      WHERE lmy01 = g_lmy1_t.lmy01 AND lmy02 = g_lmy1_t.lmy02 
        AND lmystore = g_lmy1_t.lmystore
      CLEAR FORM
      CALL g_lmy.clear()
      OPEN i121_count
      FETCH i121_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i121_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i121_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE      
         CALL i121_fetch('/')
         CALL i121_list_fill()
      END IF
   END IF
 
   CLOSE i121_cl
   COMMIT WORK
END FUNCTION
FUNCTION i121_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      
    l_n             LIKE type_file.num5,                 #檢查重複用             
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             
    p_cmd           LIKE type_file.chr1,                 #處理狀態               
    l_allow_insert  LIKE type_file.chr1,                
    l_allow_delete  LIKE type_file.chr1                

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    IF cl_null(g_lmy1.lmystore) OR cl_null(g_lmy1.lmy01) OR cl_null(g_lmy1.lmy02) THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF 
    IF g_lmy1.lmystore <> g_plant THEN
       CALL cl_err('','alm1023',0)
       RETURN
    END IF     
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    LET g_forupd_sql = "SELECT lmy03,lmy04,lmy05,lmy06,lmy07,lmyacti",   
                       " FROM lmy_file WHERE lmystore = ?  AND lmy01=? AND lmy02=? AND lmy03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i121_bcl CURSOR FROM g_forupd_sql     
 
    INPUT ARRAY g_lmy WITHOUT DEFAULTS FROM s_lmy.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
       LET p_cmd='' 
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'           
       LET l_n  = ARR_COUNT()
       LET g_on_change = TRUE        
 
       IF g_rec_b>=l_ac THEN
          BEGIN WORK
          LET p_cmd='u'
                                                        
          LET g_before_input_done = FALSE                                      
          CALL i121_set_entry03(p_cmd)                                           
          CALL i121_set_no_entry03(p_cmd)                                        
          LET g_before_input_done = TRUE                                       
            
          LET g_lmy_t.* = g_lmy[l_ac].*  
          OPEN i121_bcl USING g_lmy1.lmystore,g_lmy1_t.lmy01,g_lmy1_t.lmy02,g_lmy_t.lmy03
          IF STATUS THEN
             CALL cl_err("OPEN i121_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
          ELSE 
             FETCH i121_bcl INTO g_lmy[l_ac].* 
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_lmy_t.lmy03,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
          END IF
       END IF
 
     BEFORE INSERT
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
                                                  
        LET g_before_input_done = FALSE                                        
        CALL i121_set_entry03(p_cmd)                                             
        CALL i121_set_no_entry03(p_cmd)                                          
        LET g_before_input_done = TRUE                                         

        INITIALIZE g_lmy[l_ac].* TO NULL 
        LET g_lmy[l_ac].lmyacti = 'Y'      
        LET g_lmy[l_ac].lmy05 = NULL   
        LET g_lmy[l_ac].lmy06 = NULL     
        LET g_lmy[l_ac].lmy07 = NULL      
        LET g_lmy_t.* = g_lmy[l_ac].*        
        CALL cl_show_fld_cont()    
        NEXT FIELD lmy03
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i121_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                
 
        INSERT INTO lmy_file(lmy01,lmy02,lmy03,lmy04,lmy05,lmy06,lmy07,
                             lmyacti,lmylegal,lmystore)        
         VALUES(g_lmy1.lmy01,g_lmy1.lmy02,g_lmy[l_ac].lmy03,g_lmy[l_ac].lmy04,
                g_lmy[l_ac].lmy05,g_lmy[l_ac].lmy06,g_lmy[l_ac].lmy07,
                g_lmy[l_ac].lmyacti,g_lmy1.lmylegal,g_lmy1.lmystore) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lmy_file",g_lmy1.lmy01,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK             
           CANCEL INSERT
        ELSE 
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cnt2
        END IF
     BEFORE DELETE                            #是否取消單身
        IF g_lmy1_t.lmy01 IS NOT NULL THEN
           CALL i121_check()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              CANCEL DELETE
           END IF
           IF NOT cl_delete() THEN
              ROLLBACK WORK    
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN 
              CALL cl_err("", -263, 1) 
              ROLLBACK WORK   
              CANCEL DELETE 
           END IF 
           DELETE FROM lmy_file WHERE lmy01 = g_lmy1_t.lmy01
                                  AND lmy02 = g_lmy1_t.lmy02
                                  AND lmy03 = g_lmy_t.lmy03
                                  AND lmystore = g_lmy1_t.lmystore
           IF SQLCA.sqlcode THEN
               CALL cl_err3("del","lmy_file",g_lmy1_t.lmy01,g_lmy1_t.lmy02,g_lmy_t.lmy03,SQLCA.sqlcode,"",1)  
               ROLLBACK WORK     
               CANCEL DELETE
           ELSE 
              LET g_rec_b = g_rec_b - 1
              DISPLAY g_rec_b TO FORMONLY.cnt2
           END IF
        END IF

     AFTER FIELD lmy03
        IF NOT cl_null(g_lmy[l_ac].lmy03) THEN
           IF g_lmy[l_ac].lmy03 != g_lmy_t.lmy03 OR
              g_lmy_t.lmy03 IS NULL THEN
              IF p_cmd = 'u' THEN
                 CALL i121_check()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lmy[l_ac].lmy03 = g_lmy_t.lmy03
                    NEXT FIELD lmy03
                 END IF
              END IF   
              SELECT COUNT(*) INTO l_n FROM lmy_file
               WHERE lmy01 = g_lmy1_t.lmy01
                 AND lmy02 = g_lmy1_t.lmy02
                 AND lmy03 = g_lmy[l_ac].lmy03
                 AND lmystore = g_lmy1_t.lmystore
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_lmy[l_ac].lmy03 = g_lmy_t.lmy03
                 NEXT FIELD lmy03
              END IF                      
           END IF  
        END IF   
     AFTER FIELD lmyacti
        IF g_lmy[l_ac].lmyacti = 'N' THEN
           CALL i121_check()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_lmy[l_ac].lmyacti = 'Y'
              NEXT FIELD lmyacti
           END IF
        END IF
          
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_lmy[l_ac].* = g_lmy_t.*
          CLOSE i121_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_lmy1.lmy01,-263,0)
           LET g_lmy[l_ac].* = g_lmy_t.*
        ELSE
           UPDATE lmy_file SET lmy01=g_lmy1.lmy01,
                               lmy02=g_lmy1.lmy02,
                               lmy03=g_lmy[l_ac].lmy03,
                               lmy04=g_lmy[l_ac].lmy04,
                               lmy05=g_lmy[l_ac].lmy05,
                               lmy06=g_lmy[l_ac].lmy06,
                               lmy07=g_lmy[l_ac].lmy07,
                               lmyacti=g_lmy[l_ac].lmyacti
                WHERE lmy01 = g_lmy1_t.lmy01
                  AND lmy02 = g_lmy1_t.lmy02
                  AND lmy03 = g_lmy_t.lmy03
                  AND lmystore = g_lmy1_t.lmystore
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","lmy_file",g_lmy1_t.lmy01,g_lmy1_t.lmy02,g_lmy_t.lmy03,SQLCA.sqlcode,"",1)  
              ROLLBACK WORK   
              LET g_lmy[l_ac].* = g_lmy_t.*
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            
        LET l_ac_t = l_ac               
 
        IF INT_FLAG THEN               
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_lmy[l_ac].* = g_lmy_t.*
           END IF
           CLOSE i121_bcl            
           ROLLBACK WORK             
           EXIT INPUT
        END IF
        CLOSE i121_bcl            
        COMMIT WORK
 
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
    CLOSE i121_bcl
    COMMIT WORK
    CALL i121_list_fill()    
END FUNCTION
FUNCTION i121_b_fill(p_wc2)     
DEFINE p_wc2            STRING
    LET g_sql = "SELECT lmy03,lmy04,lmy05,lmy06,lmy07,lmyacti",   
                " FROM lmy_file ",
                "WHERE lmy01 = '",g_lmy1.lmy01,"'",
                "  AND lmy02 = '",g_lmy1.lmy02,"'",
                "   AND lmystore IN ",g_auth
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE i121_pb FROM g_sql
    DECLARE i121_curs CURSOR FOR i121_pb
 
    CALL g_lmy.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH i121_curs INTO g_lmy[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
       END IF
    END FOREACH
    CALL g_lmy.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1  
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i121_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,   
           l_wc            STRING   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lmy TO s_lmy.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                 
            
         ON ACTION INSERT
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION DELETE
            LET g_action_choice="delete"
            EXIT DIALOG
         ON ACTION FIRST
            CALL i121_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
 
         ON ACTION PREVIOUS
            CALL i121_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL i121_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
 
         ON ACTION NEXT
            CALL i121_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
 
         ON ACTION LAST
            CALL i121_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG
         ON ACTION ground
            LET g_action_choice="ground"
            EXIT DIALOG
      
         ON ACTION ACCEPT
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION CANCEL
            LET INT_FLAG=FALSE          
            LET g_action_choice="exit"
            EXIT DIALOG
 
         AFTER DISPLAY
            CONTINUE DIALOG
 
      END DISPLAY
      DISPLAY ARRAY g_lmy_l TO s_lmy_l.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
  
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                 
 
         ON ACTION ACCEPT
            LET l_ac1 = ARR_CURR()
            LET g_jump = l_ac1
            LET mi_no_ask = TRUE
            LET g_bp_flag = NULL
            IF l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT UNIQUE lmystore,lmylegal,lmy01,lmy02
               INTO g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02 
               FROM lmy_file 
              WHERE lmystore=g_lmy_l[l_ac1].lmystore
                AND lmylegal=g_lmy_l[l_ac1].lmylegal
                AND lmy01=g_lmy_l[l_ac1].lmy01
                AND lmy02=g_lmy_l[l_ac1].lmy02
               CALL i121_show()            
            END IF 
            CALL cl_set_comp_visible("page2", FALSE)   
            CALL ui.interface.refresh() 
            CALL cl_set_comp_visible("page2", TRUE)    
            EXIT DIALOG
 
         AFTER DISPLAY
            CONTINUE DIALOG
 
      END DISPLAY
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i121_fetch(p_flag)                  
   DEFINE   p_flag   LIKE type_file.chr1,       
            l_abso   LIKE type_file.num10        
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i121_cs INTO g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02
      WHEN 'P' FETCH PREVIOUS i121_cs INTO g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02
      WHEN 'F' FETCH FIRST    i121_cs INTO g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02
      WHEN 'L' FETCH LAST     i121_cs INTO g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02
      WHEN '/' 
         IF (NOT mi_no_ask) THEN          
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i121_cs INTO g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02
         LET mi_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmy1.lmy01,SQLCA.sqlcode,0)
      INITIALIZE g_lmy1.* TO NULL 
      CLEAR FORM 
      CALL g_lmy.clear()
      CALL g_lmy_l.clear()
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump      
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count) 
      DISPLAY g_curs_index TO FORMONLY.idx  
      CALL i121_show()
   END IF
END FUNCTION
FUNCTION i121_show()
   
   LET g_lmy1_t.* = g_lmy1.*
   DISPLAY g_lmy1.lmystore,g_lmy1.lmylegal,g_lmy1.lmy01,g_lmy1.lmy02 TO lmystore,lmylegal,lmy01,lmy02
   CALL i121_lmystore('d')
   CALL i121_lmy01('d')
   CALL i121_lmy02('d')
   CALL i121_b_fill(g_wc)
   CALL i121_list_fill()
END FUNCTION
FUNCTION i121_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lmystore,lmy01,lmy02",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i121_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lmystore,lmy01,lmy02",FALSE)
   END IF
   CALL cl_set_comp_entry("lmystore",FALSE)
END FUNCTION

FUNCTION i121_set_entry03(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lmy03",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i121_set_no_entry03(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lmy03",FALSE)
   END IF
END FUNCTION
 
FUNCTION i121_lmy01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_cnt      LIKE type_file.num5,
   l_lmb03    LIKE lmb_file.lmb03,
   l_lmb06    LIKE lmb_file.lmb06
 
   LET g_errno=''
   SELECT lmb03,lmb06
     INTO l_lmb03,l_lmb06
     FROM lmb_file
    WHERE lmb02= g_lmy1.lmy01
      AND lmbstore = g_lmy1.lmystore
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-904'
                                LET l_lmb03=NULL
       WHEN l_lmb06='N'         LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) AND NOT cl_null(g_lmy1.lmy02)  THEN
      SELECT COUNT(*) INTO l_cnt FROM lmc_file
       WHERE lmcstore = g_lmy1.lmystore
         AND lmc02 = g_lmy1.lmy01
         AND lmc03 = g_lmy1.lmy02
      IF l_cnt = 0 THEN
         LET g_errno = 'alm-907'
         LET g_lmy1.lmy02 = ''
      END IF
   END IF
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lmb03 TO FORMONLY.lmb03
   END IF
END FUNCTION
 
FUNCTION i121_lmy02(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_cnt      LIKE type_file.num5,
   l_lmc04    LIKE lmc_file.lmc04,
   l_lmc07    LIKE lmc_file.lmc07
 
   LET g_errno=''
   SELECT COUNT(*) INTO l_cnt FROM lmc_file
    WHERE lmcstore = g_lmy1.lmystore
      AND lmc03 = g_lmy1.lmy02
   IF l_cnt = 0 THEN
      LET g_errno = 'alm-977'
   END IF
   IF cl_null(g_errno)  THEN   
      SELECT lmc04,lmc07
        INTO l_lmc04,l_lmc07
        FROM lmc_file
       WHERE lmc03=g_lmy1.lmy02
         AND lmcstore=g_lmy1.lmystore
         AND lmc02=g_lmy1.lmy01
      CASE
         WHEN SQLCA.sqlcode=100   LET g_errno='alm-907'
                                LET l_lmc04=NULL
         WHEN l_lmc07='N'         LET g_errno='9028'
         OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
      END CASE
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION
FUNCTION i121_list_fill()
DEFINE l_i             LIKE type_file.num10
DEFINE l_sql           STRING 
    CALL g_lmy_l.clear()
    LET l_i = 1
    LET l_sql = " SELECT UNIQUE lmystore,'',lmylegal,'',lmy01,'',lmy02,'',",
                "lmy03,lmy04,lmy05,lmy06,lmy07,lmyacti ",
                "FROM lmy_file ",
                "WHERE ",g_wc CLIPPED ,
                "   AND lmystore IN ",g_auth, 
                " ORDER BY lmystore,lmy01,lmy02"
    PREPARE i121_listpre FROM l_sql
    DECLARE i121_listcl CURSOR FOR i121_listpre    
    FOREACH i121_listcl INTO g_lmy_l[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach i121_listcl',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT rtz13 INTO g_lmy_l[l_i].rtz13 FROM rtz_File
        WHERE rtz01 = g_lmy_l[l_i].lmystore
       SELECT azt02 INTO g_lmy_l[l_i].azt02 FROM azt_file
        WHERE azt01 = g_lmy_l[l_i].lmylegal
       SELECT lmb03 INTO g_lmy_l[l_i].lmb03 FROM lmb_File
        WHERE lmb02 = g_lmy_l[l_i].lmy01
          AND lmbstore = g_lmy_l[l_i].lmystore
       SELECT lmc04 INTO g_lmy_l[l_i].lmc04 FROM lmc_File
        WHERE lmc02 = g_lmy_l[l_i].lmy01
          AND lmc03 = g_lmy_l[l_i].lmy02
          AND lmcstore = g_lmy_l[l_i].lmystore 
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_lmy_l.deleteElement(l_i)
    LET g_rec_b1 = l_i - 1
    DISPLAY g_rec_b1 TO cnt1
    DISPLAY ARRAY g_lmy_l TO s_lmy_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION

FUNCTION i121_lmystore(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_rtz01    LIKE rtz_file.rtz01,   
   l_rtz13    LIKE rtz_file.rtz13,  
   l_rtz28    LIKE rtz_file.rtz28,   
   l_azwacti  LIKE azw_file.azwacti  
DEFINE l_azt02 LIKE azt_file.azt02
 
   LET g_errno=''
   SELECT rtz01,rtz13,rtz28,azwacti                        
     INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti               
     FROM rtz_file INNER JOIN azw_file                     
       ON rtz01 = azw01                                     
    WHERE rtz01=g_lmy1.lmystore
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-001'
                                LET l_rtz13=NULL
       WHEN l_azwacti = 'N'     LET g_errno='9028'           
       WHEN l_rtz28='N'         LET g_errno='alm-002'
       WHEN l_rtz01 <> g_plant  LET g_errno='alm-376'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lmy1.lmylegal
 
      DISPLAY l_rtz13 TO FORMONLY.rtz13
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION

FUNCTION i121_check()
DEFINE l_n      LIKE type_file.num5
   LET g_errno = ''
   SELECT COUNT(*) INTO l_n 
     FROM lmd_file
    WHERE lmdstore = g_lmy1.lmystore
      AND lmd03 = g_lmy1.lmy01
      AND lmd04 = g_lmy1.lmy02
      AND lmd14 = g_lmy[l_ac].lmy03
   IF l_n > 0 THEN
      LET g_errno = 'alm1028'
   END IF  
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_n 
        FROM lia_file
       WHERE liaplant = g_lmy1.lmystore
         AND lia07 = g_lmy1.lmy01
         AND lia08 = g_lmy1.lmy02
         AND lia09 = g_lmy[l_ac].lmy03
      IF l_n > 0 THEN
         LET g_errno = 'alm1026'
      END IF      
   END IF     
END FUNCTION
#FUN-B80141
