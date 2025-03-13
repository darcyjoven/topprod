# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: axmt660.4gl
# Date & Author..: 09/11/30 FUN-9B0160  By baofei 
# Modify.........: No:TQC-A50134 10/06/29 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A70138 10/07/29 By jan 過單
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80089 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-CB0015 12/11/06 By wuxj  修改link錯誤問題
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE  g_xse          RECORD LIKE xse_file.*, 
        g_xse_t        RECORD LIKE xse_file.*,
        g_xsf     DYNAMIC ARRAY OF  RECORD 
          xsf02          LIKE xsf_file.xsf02,
          occ02          LIKE occ_file.occ02
                      END RECORD,
        g_xsf_t       RECORD
           xsf02         LIKE xsf_file.xsf02,
           occ02         LIKE occ_file.occ02
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    
         g_wc                  STRING,  
         g_wc2                 STRING,
         g_sql                 STRING,  
         g_rec_b               LIKE type_file.num5,    
         l_ac                  LIKE type_file.num5     
DEFINE   g_chr                 LIKE type_file.chr1     
DEFINE   g_cnt                 LIKE type_file.num10   
DEFINE   g_msg                 LIKE type_file.chr1000  
DEFINE   g_player              LIKE azw_file.azw07 
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_curs_index          LIKE type_file.num10    
DEFINE   g_row_count           LIKE type_file.num10    
DEFINE   g_jump                LIKE type_file.num10    
DEFINE   g_no_ask              LIKE type_file.num5        
DEFINE   g_db_type             LIKE type_file.chr3     
DEFINE   mi_no_ask             LIKE type_file.num5

MAIN

   OPTIONS            
      INPUT NO WRAP   
   DEFER INTERRUPT   


   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
  
#  SELECT azw07 INTO g_player FROM azw_file WHERE azw_file.azw01 = g_plant
#  IF NOT cl_null(g_player) THEN
#     CALL cl_err("","xse-012",1)
#     EXIT PROGRAM
#  END IF 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 


   OPEN WINDOW t660_w WITH FORM "axm/42f/axmt660"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()

   LET g_forupd_sql =" SELECT * FROM xse_file ",  
                      " WHERE xse01 = ?  ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t660_lock_u CURSOR FROM g_forupd_sql

   CALL t660_menu() 

   CLOSE WINDOW t660_w   
     CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time 
END MAIN

FUNCTION t660_curs()                       
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01  

   CLEAR FORM                     
   CALL g_xsf.clear()

      CALL cl_set_head_visible("","YES") 
      
      CONSTRUCT BY NAME g_wc ON xse03,xse04,xse02,xse07,xse05,xse06

      BEFORE CONSTRUCT 
         CALL cl_qbe_init()
      
      ON ACTION controlg
          CALL cl_cmdask()
     
      ON IDLE g_idle_seconds 
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION help
         CALL cl_show_help()

      END CONSTRUCT   
      
      IF INT_FLAG THEN
        RETURN 
      END IF  

      LET g_wc = g_wc CLIPPED  
   
      CONSTRUCT g_wc2 ON xsf02 FROM s_xsf[1].xsf02 
      
      BEFORE CONSTRUCT 
        CALL cl_qbe_display_condition(lc_qbe_sn)
      
        ON ACTION controlp
           CASE 
              WHEN INFIELD(xsf02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_occ01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO xsf02 
                 NEXT FIELD xsf02 
              OTHERWISE EXIT CASE 
           END CASE

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

          ON ACTION help
             CALL cl_show_help()

          ON ACTION controlg
             CALL cl_cmdask()

      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF

      LET g_wc2 = g_wc2 CLIPPED
      IF g_wc2 = " 1=1" THEN
         LET g_sql = " SELECT DISTINCT xse01 FROM xse_file",
                     " WHERE ",g_wc CLIPPED,  
                     " ORDER BY xse01"                     
      ELSE
         LET g_sql = " SELECT DISTINCT xse01 FROM xse_file, xsf_file",
                     " WHERE xse01 = xsf01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF  
    
      PREPARE t660_prepare FROM g_sql 
      DECLARE t660_b_curs SCROLL CURSOR WITH HOLD FOR t660_prepare
      
      IF g_wc2 = " 1=1" THEN            
         LET g_sql="SELECT COUNT(DISTINCT xse01) FROM xse_file WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql=" SELECT COUNT(DISTINCT xse01) FROM xse_file,xsf_file WHERE ",
                   " xse01=xsf01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
      PREPARE t660_precount FROM g_sql
      DECLARE t660_count CURSOR FOR t660_precount

END FUNCTION
  
FUNCTION t660_menu()

   WHILE TRUE
      CALL t660_bp("G")

      CASE g_action_choice
         WHEN "insert"        
            IF cl_chk_act_auth() THEN
               calL t660_a()
            END IF
         WHEN "modify"       
            IF cl_chk_act_auth() THEN
               CALL t660_u()
            ELSE
               LET g_action_choice = " "
            END IF
        WHEN "delete"       
           IF cl_chk_act_auth() THEN
              CALL t660_r()
           END IF                       
         WHEN "query"      
            IF cl_chk_act_auth() THEN
               CALL t660_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_xse.xse07 = 0 THEN
                  CALL t660_b()
               ELSE
                  IF cl_null(g_xse.xse07) THEN
                     CALL cl_err("","-400",0)
                  ELSE
                    CALL cl_err("","xse-000",0)
                  END IF  
                  LET g_action_choice = " "
               END IF
            END IF
         WHEN "release"
            IF cl_chk_act_auth() THEN 
               CALL t660_release()
            END IF 
         WHEN "closed"
            IF cl_chk_act_auth() THEN 
               CALL t660_closed()
            END IF 
         WHEN "help"      
            CALL cl_show_help()
         WHEN "exit"     
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()

      END CASE
   END WHILE
   
END FUNCTION

FUNCTION t660_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "      
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_xsf TO s_xsf.* ATTRIBUTE(UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION insert                          
         LET g_action_choice= "insert"
         EXIT DISPLAY
      
      ON ACTION query                           
         LET g_action_choice= "query"
         EXIT DISPLAY
                      
      ON ACTION modify                          
         LET g_action_choice= "modify"
         EXIT DISPLAY

      ON ACTION detail                          
         LET g_action_choice= "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
    
      ON ACTION delete
         LET g_action_choice = "delete"
         EXIT DISPLAY

      ON ACTION release
         LET g_action_choice  = "release"
         EXIT DISPLAY 
    
      ON ACTION closed 
         LET g_action_choice = "closed"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first                           
         CALL t660_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY  
 
      ON ACTION previous                        
         CALL t660_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump                           
         CALL t660_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next                           
         CALL t660_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last                            
         CALL t660_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
       ON ACTION help                           
          LET g_action_choice="help"
          EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
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

FUNCTION t660_bp_refresh()
  DISPLAY ARRAY g_xsf TO s_xsf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION t660_a()  
   DEFINE  l_no     LIKE    type_file.num5
         
   MESSAGE ""
   CLEAR FORM
   CALL g_xsf.clear()
   INITIALIZE g_xse.* TO NULL
   LET g_xse.xse07 = 0

   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t660_i('a')

      IF INT_FLAG THEN  
         CLEAR FORM
         INITIALIZE g_xse.* TO NULL
         LET g_xse.xse07 = 0 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      BEGIN WORK
      DISPLAY g_xse.xse02,g_xse.xse03,g_xse.xse04,g_xse.xse05,g_xse.xse06,g_xse.xse07 TO xse02,xse03,xse04,xse05,xse06,xse07 
      SELECT MAX(to_number(xse01)) INTO l_no FROM xse_file  
      IF cl_null(l_no) THEN
         LET g_xse.xse01 = 1
      ELSE
         LET g_xse.xse01 = l_no + 1
      END IF 
      LET g_xse.xse99 = g_plant
      INSERT INTO xse_file VALUES (g_xse.*)
      IF SQLCA.sqlcode THEN               
         CALL cl_err3("ins","xse_file","","",SQLCA.sqlcode,"","",1)   #FUN-B80089
         ROLLBACK WORK      
      #  CALL cl_err3("ins","xse_file","","",SQLCA.sqlcode,"","",1)   #FUN-B80089
         CONTINUE WHILE
      ELSE
         COMMIT WORK        
         CALL cl_flow_notify(g_xse.xse01,'I')
      END IF
      LET g_rec_b = 0
      CALL t660_b()
      EXIT WHILE
   END WHILE
END FUNCTION



FUNCTION t660_u()
   DEFINE l_num     LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_xse.xse01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_xse.xse07 <> 0 THEN
      CALL cl_err("","xse-000",0)
      RETURN 
   END IF
   SELECT * INTO g_xse.* FROM xse_file
     WHERE xse01=g_xse.xse01

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_xse_t.* = g_xse.* 

   BEGIN WORK 
   
   OPEN t660_lock_u USING g_xse.xse01 
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE t660_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t660_lock_u INTO g_xse.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("xse01 LOCK:",SQLCA.sqlcode,1)
      CLOSE t660_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   CALL t660_show()

      WHILE TRUE 
         CALL t660_i("u")
         IF INT_FLAG THEN
            LET g_xse.* = g_xse_t.*
            CALL t660_show()
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
         END IF

         UPDATE xse_file
            SET xse02 = g_xse.xse02,
                xse03 = g_xse.xse03, 
                xse04 = g_xse.xse04,
                xse05 = g_xse.xse05,
                xse06 = g_xse.xse06  
          WHERE xse01 = g_xse.xse01 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","xse_file","","",SQLCA.sqlcode,"","",1) 
            CONTINUE WHILE
         END IF
         EXIT WHILE
      END WHILE
      CLOSE t660_lock_u
      COMMIT WORK
      CALL cl_flow_notify(g_xse.xse01,'U')

      calL t660_b_fill("1=1")
      CALL t660_bp_refresh()
      
END FUNCTION


FUNCTION t660_i(p_cmd)                       
   DEFINE   p_cmd        LIKE type_file.chr1
   DEFINE   l_count      LIKE type_file.num5

   
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")
 
   INPUT g_xse.xse03,g_xse.xse04,g_xse.xse02,g_xse.xse07,g_xse.xse05,g_xse.xse06 WITHOUT DEFAULTS FROM 
         xse03,xse04,xse02,xse07,xse05,xse06 
 
   BEFORE INPUT 
      IF p_cmd = 'a' THEN
         LET g_xse.xse07 = 0 
      END IF      
      LET g_before_input_done = FALSE
      CALL t660_set_no_entry(p_cmd)
      LET g_before_input_done = TRUE

      AFTER FIELD xse03 
         IF NOT cl_null(g_xse.xse03) THEN 
            IF g_xse.xse03 > g_xse.xse04 THEN 
               CALL cl_err("","xse-001",0)
               NEXT FIELD xse03
            END IF  
         ELSE 
            CALL cl_err("","-1124",0)
              NEXT FIELD xse03 
         END IF                 
           
      AFTER FIELD xse04
         IF NOT cl_null(g_xse.xse04) THEN 
            IF g_xse.xse04 < g_xse.xse03 THEN
               CALL cl_err("","xse-001",0) 
               NEXT FIELD xse04  
            END IF  
            IF g_xse.xse04 > g_xse.xse05 THEN
               CALL cl_err("","xse-002",0)
               NEXT FIELD xse04
            END IF 
         ELSE  
            CALL cl_err("","-1124",0)
            NEXT FIELD xse04 
         END IF 
                                
      AFTER FIELD xse02
         IF cl_null(g_xse.xse02) THEN
            CALL cl_err("","-1124",0)
            NEXT FIELD xse02
         END IF
            
      AFTER FIELD xse05
         IF NOT cl_null(g_xse.xse05) THEN 
            IF g_xse.xse05 < g_xse.xse04 THEN
               CALL cl_err("","xse-003",0)
               NEXT FIELD xse05  
            END IF 
         ELSE  
            CALL cl_err("","-1124",0)
            NEXT FIELD xse05 
         END IF   
     
      AFTER FIELD xse06
         IF cl_null(g_xse.xse06) THEN 
            CALL cl_err("","-1124",0)
         END IF 
      
      AFTER INPUT 
         IF INT_FLAG THEN
           EXIT INPUT
         END IF
   
     ON ACTION CONTROLR
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

   END INPUT
END FUNCTION



FUNCTION t660_q() 
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   INITIALIZE g_xse.* TO NULL
   CALL g_xsf.clear()
   DISPLAY  '' TO FORMONLY.cnt
   
   CALL t660_curs() 
     
   IF INT_FLAG THEN  
      LET INT_FLAG = 0
      INITIALIZE g_xse.* TO NULL
      RETURN
   END IF
   
#  OPEN t660_b_curs  
#  IF SQLCA.SQLCODE THEN        
#     CALL cl_err('',SQLCA.SQLCODE,0)
#     INITIALIZE g_xse.* TO NULL
#     LET g_xse.xse07 = 0
#  ELSE
   OPEN t660_count
   FETCH t660_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t660_b_curs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_xse.* TO NULL
      LET g_xse.xse07 = 0
   ELSE
      CALL t660_fetch('F')                 
   END IF

END FUNCTION

FUNCTION t660_release()
   DEFINE l_ac      LIKE type_file.num5
   DEFINE l_count   LIKE type_file.num5 
 
   MESSAGE ""

   IF NOT cl_null(g_xse.xse01) THEN 
      IF g_xse.xse07 <> 0 THEN 
         CALL cl_err("","xse-111",0)
         RETURN 
      END IF 
   ELSE
      CALL cl_err("","-400",0)
      RETURN 
   END IF 
  
   BEGIN WORK 
   
   OPEN t660_lock_u USING g_xse.xse01 
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE t660_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t660_lock_u INTO g_xse.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("xse01 LOCK:",SQLCA.sqlcode,1)
      CLOSE t660_lock_u
      ROLLBACK WORK
      RETURN
   END IF
    
    UPDATE xse_file SET xse07 = 1 
     WHERE xse01 = g_xse.xse01
    IF SQLCA.sqlcode THEN 
       CALL cl_err3("upd","xse_file","","",SQLCA.sqlcode,"","",1)
    ELSE
       LET g_xse.xse07 = 1
       DISPLAY g_xse.xse07 TO xse07 
       MESSAGE("UPDATE O.K")
    END IF 
    COMMIT WORK

END FUNCTION 


FUNCTION t660_closed()

   MESSAGE ""
   IF NOT cl_null(g_xse.xse01) THEN 
      IF g_xse.xse07 <> 1 THEN
         CALL cl_err("","xse-222",0)
         RETURN 
      END IF 
   ELSE
      CALL cl_err("","-400",0)
      RETURN 
   END IF 
 
   BEGIN WORK
   
   OPEN t660_lock_u USING g_xse.xse01 
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE t660_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t660_lock_u INTO g_xse.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("xse01 LOCK:",SQLCA.sqlcode,1)
      CLOSE t660_lock_u
      ROLLBACK WORK
      RETURN
   END IF   

   UPDATE xse_file SET xse07 = 2
    WHERE xse01 = g_xse.xse01 
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("upd","xse_file","","",SQLCA.sqlcode,"","",1)
   ELSE 
      MESSAGE("UPDATE O.K")
      LET g_xse.xse07 = 2 
      DISPLAY g_xse.xse07 TO xse07
   END IF 
   
  COMMIT WORK

END FUNCTION 


FUNCTION t660_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t660_b_curs INTO g_xse.xse01
      WHEN 'P' FETCH PREVIOUS t660_b_curs INTO g_xse.xse01
      WHEN 'F' FETCH FIRST    t660_b_curs INTO g_xse.xse01
      WHEN 'L' FETCH LAST     t660_b_curs INTO g_xse.xse01
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlg
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
         FETCH ABSOLUTE g_jump t660_b_curs INTO g_xse.xse01
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_xse.xse01,SQLCA.sqlcode,0)
      INITIALIZE g_xse.* TO NULL
      RETURN 
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
   END IF
   
   SELECT * INTO g_xse.* FROM xse_file WHERE xse01 = g_xse.xse01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","xse_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_xse.* TO NULL
      LET g_xse.xse07 = 0
      RETURN
   END IF

   CALL t660_show()
END FUNCTION

FUNCTION t660_show()    

   DISPLAY g_xse.xse02,g_xse.xse03,g_xse.xse04,g_xse.xse05,g_xse.xse06,g_xse.xse07
        TO xse02,xse03,xse04,xse05,xse06,xse07
   CALL t660_b_fill(g_wc2)
   CALL cl_show_fld_cont()

END FUNCTION

FUNCTION t660_r()
   DEFINE   l_cnt   LIKE type_file.num5,
            l_xse   RECORD LIKE xse_file.*,
            l_num   LIKE type_file.num5 

   IF s_shut(0) THEN RETURN END IF
   LET  g_action_choice  = " "

   IF cl_null(g_xse.xse01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF  
   
   IF g_xse.xse07 <> 0 THEN
      CALL cl_err("","xse-333",0)
      RETURN 
   END IF 
   BEGIN WORK
    OPEN t660_lock_u USING g_xse.xse01
    IF STATUS THEN
      CALL cl_err("OPEN i214_cl:", STATUS, 1)
      CLOSE t660_lock_u 
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t660_lock_u INTO g_xse.*           
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_xse.xse01,SQLCA.sqlcode,0)       
      ROLLBACK WORK
      RETURN
   END IF

   CALL t660_show()

   IF cl_delh(0,0) THEN 
      DELETE FROM xse_file
         WHERE xse01 = g_xse.xse01  
      DELETE FROM xsf_file 
         WHERE xsf01 = g_xse.xse01       
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("del","xse_file|xsf_file","","",SQLCA.sqlcode,"","BODY DELETE",0) 
#      ELSE
      CLEAR FORM
      CALL g_xsf.clear()
      OPEN t660_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t660_b_curs
         CLOSE t660_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t660_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t660_b_curs
         CLOSE t660_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t660_b_curs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t660_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL t660_fetch('/')
      END IF
   END IF

   CLOSE t660_lock_u
   COMMIT WORK
#   CALL cl_flow_notify(g_xse.xse01,'D')
   
END FUNCTION


FUNCTION t660_b()
   DEFINE   l_ac_t          LIKE type_file.num5,          
            l_n             LIKE type_file.num5,
            l_no            LIKE type_file.num5,
            l_m             LIKE type_file.num5,          
            l_cnt           LIKE type_file.num5,                    
            l_lock_sw       LIKE type_file.chr1,          
            p_cmd           LIKE type_file.chr1,          
            l_allow_insert  LIKE type_file.num5,          
            l_allow_delete  LIKE type_file.num5           
   DEFINE   l_count         LIKE type_file.num5           
   DEFINE   l_occ01         LIKE occ_file.occ01
   

   LET l_no = 0 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_xse.xse01) THEN 
      IF g_action_choice = "insert" THEN
        LET g_action_choice = " "
      ELSE 
         CALL cl_err('',-400,0)
         LET g_action_choice = " "
         RETURN
      END IF
   END IF 
   LET g_action_choice = " "

   CALL cl_opmsg('b')

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   LET g_forupd_sql= " SELECT xsf02,' '",
                     " FROM xsf_file ",
                     " WHERE xsf01 = ? AND xsf02 = ? ",
                     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t660_bcl CURSOR FROM g_forupd_sql      

   LET l_ac_t = 0

   INPUT ARRAY g_xsf WITHOUT DEFAULTS FROM s_xsf.*
              ATTRIBUTE(COUNT=g_rec_b ,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK
         
            OPEN t660_lock_u USING g_xse.xse01
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN t660_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
               ROLLBACK WORK
               RETURN
             END IF

           FETCH t660_lock_u INTO g_xse.*            
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_xse.xse01,SQLCA.sqlcode,0)      
              CLOSE t660_lock_u
              ROLLBACK WORK
              RETURN
           END IF

         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_xsf_t.* =g_xsf[l_ac].*    #BACKUP
            OPEN t660_bcl USING g_xse.xse01,g_xsf[l_ac].xsf02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN t660_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH t660_bcl INTO g_xsf[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH t660_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT occ02 INTO g_xsf[l_ac].occ02 FROM occ_file WHERE occ01 = g_xsf[l_ac].xsf02
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_xsf[l_ac].* TO NULL   
         LET g_xsf_t.* =g_xsf[l_ac].*          
         CALL cl_show_fld_cont()
         NEXT FIELD xsf02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
 #           CALL g_occ.deleteElement(l_ac)
         END IF

      INSERT INTO xsf_file VALUES(g_xse.xse01,g_xsf[l_ac].xsf02)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","xsf_file","","",SQLCA.sqlcode,"","",0)
         CANCEL INSERT
      ELSE
         MESSAGE 'INSERT O.K'
         COMMIT WORK
         LET g_rec_b = g_rec_b + 1
         DISPLAY g_rec_b TO FORMONLY.cn2
      END IF  
          
      AFTER FIELD xsf02  
         SELECT occ01 INTO l_occ01 FROM occ_file,azw_file
            WHERE occ_file.occ01 = azw_file.azw01 AND azw_file.azw07 = g_plant AND occ01 = g_xsf[l_ac].xsf02
         IF cl_null(l_occ01) THEN
            CALL cl_err("","xse-011",0)
            NEXT FIELD xsf02 
         ELSE 
           SELECT occ02 INTO g_xsf[l_ac].occ02 FROM occ_file WHERE occ01 = g_xsf[l_ac].xsf02
         END IF        
             
      BEFORE DELETE      
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN 
            CALL cl_err("", -263, 1) 
            CANCEL DELETE 
          END IF
          DELETE FROM xsf_file WHERE xsf01 = g_xse.xse01 AND xsf02 = g_xsf[l_ac].xsf02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","xsf_file","","",SQLCA.sqlcode,"","",0) 
             ROLLBACK WORK
             CANCEL DELETE
          END IF 
          CALL g_xsf.deleteElement(l_ac)
          LET g_rec_b = g_rec_b - 1
          DISPLAY g_rec_b TO FORMONLY.cn2
          IF g_xsf.getLength() = 0 THEN
             #CALL t660_delall()      #TQC-CB0015  mark
              CALL t660_delHeader()   #TQC-CB0015  add
              LET g_rec_b = g_rec_b -1 
              DISPLAY g_rec_b TO FORMONLY.cn2
              EXIT INPUT
          END IF  
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_xsf[l_ac].* =g_xsf_t.*
            CLOSE t660_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_xsf[l_ac].xsf02,-263,1)
            LET g_xsf[l_ac].* = g_xsf_t.*
         ELSE
            UPDATE xsf_file 
               SET xsf02 = g_xsf[l_ac].xsf02
             WHERE xsf01 = g_xse.xse01 AND xsf02 = g_xsf_t.xsf02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","xsf_file","","",SQLCA.sqlcode,"","",0)
               LET g_xsf[l_ac].* =g_xsf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30034 Mark

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_xsf[l_ac].* = g_xsf_t.*
            END IF
            IF p_cmd = 'a' THEN
               CALL g_xsf.deleteElement(l_ac)
               #FUN-D30034--add--str--
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
               #FUN-D30034--add--end--
            END IF 
            CLOSE t660_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 Add
         CLOSE t660_bcl
         COMMIT WORK

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION controlp 
         CASE
            WHEN INFIELD(xsf02)      
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ01"
                  LET g_qryparam.arg1 = g_plant 
                  LET g_qryparam.default1 =g_xsf[l_ac].xsf02
                  CALL cl_create_qry() RETURNING g_xsf[l_ac].xsf02
                  DISPLAY BY NAME g_xsf[l_ac].xsf02
                  NEXT FIELD xsf02
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help
         CALL cl_show_help()

      ON ACTION about
         CALL cl_about()

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

   END INPUT
   CLOSE t660_bcl
   COMMIT WORK
#  CALL t660_delall() #CHI-C30002 mark
   CALL t660_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t660_delHeader()
   SELECT COUNT(*) INTO g_cnt FROM xsf_file WHERE xsf01 = g_xse.xse01
   IF g_cnt = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  xse_file WHERE xse01 = g_xse.xse01
         INITIALIZE g_xse.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION  t660_delall()

# IF g_xsf.getLength() = 0 THEN
#    CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#    ERROR g_msg CLIPPED
#    CLEAR FORM
#    DELETE FROM xse_file WHERE xse01 = g_xse.xse01
# END IF   

#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t660_b_fill(p_wc)             
   DEFINE p_wc         STRING 

    LET g_sql = "SELECT xsf02,' '",
                " FROM xsf_file ",
                " WHERE xsf01 ='",g_xse.xse01,"'"
    
    IF NOT cl_null(p_wc) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY xsf02 "
    DISPLAY g_sql
            
     PREPARE t660_prepare2 FROM g_sql          
     DECLARE t660_cs2 CURSOR WITH HOLD FOR t660_prepare2

    LET g_cnt = 1
    CALL g_xsf.clear()

    FOREACH t660_cs2 INTO g_xsf[g_cnt].*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
     
       SELECT occ02 INTO g_xsf[g_cnt].occ02 FROM occ_file WHERE occ01 = g_xsf[g_cnt].xsf02
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_xsf.deleteElement(g_cnt)

    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION



FUNCTION t660_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
    IF p_cmd = 'u'  AND ( NOT g_before_input_done ) AND g_xse.xse07 <> 0  THEN
       CALL cl_set_comp_entry("xse02,xse03,xse04,xse05,xse06,xse07",FALSE)
    ELSE 
       CALL cl_set_comp_entry("xse07",FALSE)
    END IF
END FUNCTION
#FUN-9B0160 ---end----
#TQC-A50134 10/06/29 By chenls 非T/S類table中的xxxplant替換成xxxstore
#FUN-A70138
