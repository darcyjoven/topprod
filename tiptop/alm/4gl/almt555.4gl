# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almt555.4gl
# Descriptions...: 卡積分規則變更設定作業
# Date & Author..: NO.FUN-C60058 12/07/09 By Lori  
# Modify.........: No.FUN-C90046 12/09/11 By xumeimei 充值基准(lrq06)改为Key值
# Modify.........: No.MOD-DA0067 13/10/12 By SunLM 調整報錯信息現象
 
DATABASE ds

GLOBALS "../../config/top.global"

#FUN-C60058
DEFINE g_lti         RECORD LIKE lti_file.*,
       g_lti_t       RECORD LIKE lti_file.*,
       g_lti01_t     LIKE lti_file.lti01,
       g_lti06       LIKE lti_file.lti06,        
       g_lti00       LIKE lti_file.lti00,
       g_ltj         DYNAMIC ARRAY OF RECORD
          ltj02      LIKE ltj_file.ltj02,
          ltj02_1    LIKE ima_file.ima02,
          ltj03      LIKE ltj_file.ltj03,
          ltj04      LIKE ltj_file.ltj04,
          ltj05      LIKE ltj_file.ltj05,
          ltj06      LIKE ltj_file.ltj06,
          ltj07      LIKE ltj_file.ltj07,
          ltj08      LIKE ltj_file.ltj08,
          ltj09      LIKE ltj_file.ltj09, 
          ltjacti    LIKE ltj_file.ltjacti  
                     END RECORD,
       g_ltj_t       RECORD
          ltj02      LIKE ltj_file.ltj02,
          ltj02_1    LIKE ima_file.ima02,
          ltj03      LIKE ltj_file.ltj03,
          ltj04      LIKE ltj_file.ltj04,
          ltj05      LIKE ltj_file.ltj05,
          ltj06      LIKE ltj_file.ltj06,
          ltj07      LIKE ltj_file.ltj07,
          ltj08      LIKE ltj_file.ltj08,
          ltj09      LIKE ltj_file.ltj09,   
          ltjacti    LIKE ltj_file.ltjacti  
                     END RECORD,
       g_ltk         DYNAMIC ARRAY OF RECORD
          ltk05      LIKE ltk_file.ltk05,
          ltk05_desc LIKE lpc_file.lpc02,
          ltk06      LIKE ltk_file.ltk06,
          ltk11      LIKE ltk_file.ltk11,  
          ltk12      LIKE ltk_file.ltk12,  
          ltk15      LIKE ltk_file.ltk15,  
          ltk16      LIKE ltk_file.ltk16,  
          ltk17      LIKE ltk_file.ltk17,  
          ltk18      LIKE ltk_file.ltk18,  
          ltk19      LIKE ltk_file.ltk19,  
          ltk20      LIKE ltk_file.ltk20,  
          ltk07      LIKE ltk_file.ltk07,
          ltk08      LIKE ltk_file.ltk08,
          ltk09      LIKE ltk_file.ltk09,
          ltk10      LIKE ltk_file.ltk10,      
          ltkacti    LIKE ltk_file.ltkacti     
                     END RECORD,
       g_ltk_t       RECORD
          ltk05      LIKE ltk_file.ltk05,
          ltk05_desc LIKE lpc_file.lpc02,
          ltk06      LIKE ltk_file.ltk06,
          ltk11      LIKE ltk_file.ltk11,  
          ltk12      LIKE ltk_file.ltk12,  
          ltk15      LIKE ltk_file.ltk15,  
          ltk16      LIKE ltk_file.ltk16,  
          ltk17      LIKE ltk_file.ltk17,  
          ltk18      LIKE ltk_file.ltk18,  
          ltk19      LIKE ltk_file.ltk19,  
          ltk20      LIKE ltk_file.ltk20,  
          ltk07      LIKE ltk_file.ltk07,
          ltk08      LIKE ltk_file.ltk08,
          ltk09      LIKE ltk_file.ltk09,
          ltk10      LIKE ltk_file.ltk10,   
          ltkacti    LIKE ltk_file.ltkacti  
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_wc3         STRING,                
       g_rec_b       LIKE type_file.num5,
       g_rec_b1      LIKE type_file.num5,   
       g_str         LIKE type_file.chr1000,
       l_ac          LIKE type_file.num5,
       l_ac1         LIKE type_file.num5    
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
DEFINE g_void              LIKE type_file.chr1
DEFINE g_argv1             LIKE lti_file.lti00          
DEFINE g_argv2             LIKE lti_file.lti01           
DEFINE g_b_flag            STRING                     
DEFINE g_cb                ui.ComboBox               
DEFINE g_ltipos            LIKE lti_file.ltipos      
DEFINE g_ckmult            LIKE type_file.chr1       
DEFINE g_t1                LIKE oay_file.oayslip     
DEFINE g_gee02             LIKE gee_file.gee02       
DEFINE g_flag2             LIKE type_file.chr1
DEFINE g_lti08_o           LIKE lti_file.lti08

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   LET g_argv1=ARG_VAL(1)                
   LET g_argv2=ARG_VAL(2)                

   IF cl_null(g_argv1) THEN LET g_argv1 = '1' END IF    
   CASE g_argv1
        WHEN '1' LET g_prog = "almt555"
                 LET g_lti00= "1" 
                 LET g_gee02= 'Q4'       
        WHEN '2' LET g_prog = "almt556"
                 LET g_lti00= "2"
                 LET g_gee02= 'Q5'       
        WHEN '3' LET g_prog = "almt558"  
                 LET g_lti00= "3"        
                 LET g_gee02= 'Q6'       
   END CASE

   LET g_lti06 = g_plant                
   LET g_lti.lti00=g_lti00
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lti_file WHERE lti06= ? AND lti07 = ? AND lti08 = ? AND ltiplant = ? FOR UPDATE "   
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE t555_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t555_w WITH FORM "alm/42f/almt555"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("ltipos",TRUE)
    ELSE
      CALL cl_set_comp_visible("ltipos",FALSE)
   END IF

   IF g_argv1 = '1' THEN  
      CALL cl_set_comp_visible("ltj05",FALSE)  
      CALL cl_set_comp_visible("ltk10",FALSE)   
      CALL cl_set_comp_visible("lti11",FALSE)  
   END IF
   
   IF g_argv1 = '2' THEN 
      CALL cl_set_comp_visible("ltj03,ltj04",FALSE)  
      CALL cl_set_comp_visible("ltk07,ltk08,ltk09",FALSE)  
      CALL cl_getmsg('alm1492',g_lang) RETURNING g_msg     
      CALL cl_set_comp_att_text("ltk06",g_msg CLIPPED)     
      CALL cl_set_comp_visible("lti11",TRUE)               
   END IF

   IF g_argv1 = '3' THEN
      LET g_cb = ui.ComboBox.forName("lti02")
      CALL g_cb.clear()
      CALL cl_getmsg('art-774',g_lang) RETURNING g_msg
      CALL g_cb.addItem('1',"1:" || g_msg CLIPPED)
      CALL cl_getmsg('art-775',g_lang) RETURNING g_msg
      CALL g_cb.addItem('2',"2:" || g_msg CLIPPED)
      CALL cl_set_comp_visible("lti03",FALSE)
      CALL cl_set_comp_visible("ltj03,ltj04,ltj05",FALSE)
      CALL cl_set_comp_visible("Folder1",FALSE)
      CALL cl_set_comp_visible("cn3,hl1",FALSE)
      CALL cl_set_act_visible("excludedetail",FALSE)
      CALL cl_set_comp_visible("lti11",FALSE)               
   ELSE
      CALL cl_set_comp_visible("ltj06,ltj07,ltj08,ltj09",FALSE)
   END IF
   CALL cl_set_comp_entry("lti00",FALSE) 

   IF NOT cl_null(g_argv2) THEN
      IF cl_chk_act_auth() THEN
         CALL t555_q()
      END IF
   ELSE
      CALL t555_menu()
   END IF
   CLOSE WINDOW t555_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t555_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

      CLEAR FORM
      CALL g_ltj.clear()
      CALL g_ltk.clear()               

   DISPLAY g_lti00 TO lti00            
   CALL cl_set_comp_entry("lti00",FALSE)    

   IF NOT cl_null(g_argv2) THEN
      LET g_wc = " lti01 = '",g_argv2,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lti.* TO NULL
      CONSTRUCT BY NAME g_wc ON lti06,lti07,lti08,                                     
                                lti01,lti04,lti05,lti02,lti03,lti11,                   
                                ltipos,
                                lticonf,lticonu,lticond,lti09,lti10,                   
                                ltiuser,ltimodu,ltiacti,ltigrup,ltidate,               
                                lticrat,ltioriu,ltiorig                                
                                
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(lti06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lti02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lti06
                  NEXT FIELD lti06
               WHEN INFIELD(lti07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrp03"
                  LET g_qryparam.arg1 = g_lti00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lti07
                  NEXT FIELD lti07
               WHEN INFIELD(lticonu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrp04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lticonu
                  NEXT FIELD lticonu
               WHEN INFIELD(lti01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1= g_lti00
                  LET g_qryparam.form ="q_lrp04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lti01
                  NEXT FIELD lti01
                
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
   END IF 
   
   IF NOT cl_null(g_argv2) THEN
      LET g_wc2 = ' 1=1'
   ELSE
      CONSTRUCT g_wc2 ON ltj02,ltj03,ltj04,ltj05,
                         ltj06,ltj07,ltj08,ltj09,ltjacti                 
                    FROM s_ltj[1].ltj02,s_ltj[1].ltj03,
                         s_ltj[1].ltj04, s_ltj[1].ltj05,
                         s_ltj[1].ltj06,s_ltj[1].ltj07, 
                         s_ltj[1].ltj08,s_ltj[1].ltj09,s_ltj[1].ltjacti  

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION controlp
            CASE
               WHEN INFIELD(ltj02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1= g_lti00
                  LET g_qryparam.form ="q_lrq02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltj02
                  NEXT FIELD ltj02
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

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF

      IF g_argv1 = '3' THEN  
         LET g_wc3 = ' 1=1'  
      ELSE                   
         CONSTRUCT g_wc3 ON ltk05,ltk06,ltk11,ltk12,
                            ltk15,ltk16,ltk17,ltk18,ltk19,ltk20,                                         
                            ltk07,ltk08,ltk09,ltk10,ltkacti
                       FROM s_ltk[1].ltk05,s_ltk[1].ltk06,s_ltk[1].ltk11,s_ltk[1].ltk12,
                            s_ltk[1].ltk15,s_ltk[1].ltk16,s_ltk[1].ltk17,s_ltk[1].ltk18,s_ltk[1].ltk19,s_ltk[1].ltk20,   
                            s_ltk[1].ltk07,s_ltk[1].ltk08,s_ltk[1].ltk09,s_ltk[1].ltk10,s_ltk[1].ltkacti

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

            ON ACTION controlp
               CASE
                  WHEN INFIELD(ltk05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lth05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ltk05
                     NEXT FIELD ltk05
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

            ON ACTION qbe_save
               CALL cl_qbe_save()
         END CONSTRUCT
      END IF            
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   LET g_wc2 = g_wc2 CLIPPED
   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN              
          LET g_sql = "SELECT lti06,lti07,lti08,ltiplant FROM lti_file ",               
                      " WHERE ltiplant='",g_plant,"' AND ", g_wc CLIPPED,
                      "   AND lti00 = '",g_lti00,"' ",
                      " ORDER BY lti07"
      ELSE                            
          LET g_sql = "SELECT UNIQUE lti06,lti07,lti08,ltiplant ",                     
                      "  FROM lti_file, ltj_file ",
                      " WHERE lti06 = ltj12 AND lti07 = ltj13 AND lti08 = ltj14 AND ltiplant = ltjplant",
                      "   AND ltiplant = '",g_plant,"' ",
                      "   AND ltjplant = '",g_plant,"' ",
                      "   AND lti00 = '",g_lti00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc2 CLIPPED,
                      " ORDER BY lti07"
      END IF
   ELSE        
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT lti06,lti07,lti08,ltiplant FROM lti_file,ltk_file ",
                      " WHERE lti06 = ltk13 AND lti07 = ltk14 AND lti08 = ltk21 AND ltiplant = ltkplant",
                      "   AND ltiplant = '",g_plant,"' ",
                      "   AND ltkplant = '",g_plant,"' " ,
                      "   AND lti00 = '",g_lti00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc3 CLIPPED,
                      " ORDER BY lti07"
      ELSE
         LET g_sql = "SELECT UNIQUE lti06,lti07,lti08,ltiplant ",
                     "  FROM lti_file, ltj_file,ltk_file ",
                     " WHERE lti06 = ltj12 AND lti07 = ltj13 AND lti08 = ltj14 AND ltiplant = ltjplant",
                     "   AND lti06 = ltk13 AND lti07 = ltk14 AND lti08 = ltk21 AND ltiplant = ltkplant",
                     "   AND ltiplant = '",g_plant,"' ",
                     "   AND ltjplant = '",g_plant,"' ",
                     "   AND ltkplant = '",g_plant,"' ",
                     "   AND lti00 = '",g_lti00,"' ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY lti07"
      END IF
   END IF       

   PREPARE t555_prepare FROM g_sql
   DECLARE t555_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t555_prepare

   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(*) FROM lti_file ",
                      " WHERE ltiplant='",g_plant,"' AND ", g_wc CLIPPED,
                      "   AND lti00 = '",g_lti00,"' ",
                      " ORDER BY lti07"
      ELSE
          LET g_sql = "SELECT COUNT(*) ",
                      "  FROM lti_file, ltj_file ",
                      " WHERE lti06 = ltj12 AND lti07 = ltj13 AND lti08 = ltj14 AND ltiplant = ltjplant",
                      "   AND ltiplant = '",g_plant,"' ",
                      "   AND ltjplant = '",g_plant,"' ",
                      "   AND lti00 = '",g_lti00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc2 CLIPPED,
                      " ORDER BY lti07"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(*) lti_file, ltk_file",
                      " WHERE lti06 = ltk13 AND lti07 = ltk14 AND lti08 = ltk21 AND ltiplant = ltkplant",
                      "   AND ltiplant = '",g_plant,"' ",
                      "   AND ltjplant = '",g_plant,"' ",
                      "   AND ltkplant = '",g_plant,"' " ,
                      "   AND lti00 = '",g_lti00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc3 CLIPPED,
                      " ORDER BY lti07"
      ELSE
         LET g_sql = "SELECT COUNT(*) ",
                     "  FROM lti_file, ltj_file,ltk_file ",
                     " WHERE lti06 = ltj12 AND lti07 = ltj13 AND lti08 = ltj14 AND ltiplant = ltjplant",
                     "   AND lti06 = ltk13 AND lti07 = ltk14 AND lti08 = ltk21 AND ltiplant = ltkplant",
                     "   AND ltiplant = '",g_plant,"' ",
                     "   AND ltjplant = '",g_plant,"' ",
                     "   AND ltkplant = '",g_plant,"' " ,
                     "   AND lti00 = '",g_lti00,"' ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY lti07"
      END IF
   END IF

   PREPARE t555_precount FROM g_sql
   DECLARE t555_count CURSOR FOR t555_precount
END FUNCTION

FUNCTION t555_menu()
DEFINE l_msg        LIKE type_file.chr1000
   WHILE TRUE
      CALL t555_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t555_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t555_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t555_r()    
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t555_u() 
            END IF
            
         WHEN "excludedetail"
            IF cl_chk_act_auth() THEN
               CALL t555_exclude_detail()
            END IF
                        
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_b_flag IS NULL OR g_b_flag ='1' THEN    
                  CALL t555_b()
               ELSE
                  CALL t555_b1()
               END IF 
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltj),'','')
            END IF

         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lti.lti01 IS NOT NULL THEN
                    LET g_doc.column1 = "lti06"
                    LET g_doc.value1  = g_lti.lti06
                    LET g_doc.column2 = "lti07"
                    LET g_doc.value2  = g_lti.lti07
                    LET g_doc.column3 = "lti08"
                    LET g_doc.value3  = g_lti.lti08
                    LET g_doc.column4 = "ltiplant"
                    LET g_doc.value4  = g_lti.ltiplant
                    CALL cl_doc()
                  END IF
              END IF
         
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t555_x()
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t555_conf()
            END IF

         WHEN "eff_plant" 
            IF cl_chk_act_auth() THEN
               CALL t555_eff_plant()
            END IF 
      END CASE
   END WHILE
   
#   IF NOT cl_null(g_errno) THEN
#      CALL cl_err('',g_errno,0) #MOD-DA0067 mark
#   END IF

END FUNCTION

FUNCTION t555_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ltj TO s_ltj.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='1'
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      DISPLAY ARRAY g_ltk TO s_ltk.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='2'

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY
      BEFORE DIALOG
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG 
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG 
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG 
 
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG 
 
         ON ACTION excludedetail
            LET g_action_choice="excludedetail"
            EXIT DIALOG 
 
         ON ACTION first
            CALL t555_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
 
         ON ACTION previous
            CALL t555_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
 
         ON ACTION jump
            CALL t555_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
 
         ON ACTION next
            CALL t555_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
 
         ON ACTION last
            CALL t555_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG 
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG 
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            IF g_argv1 = '3' THEN
               CALL g_cb.clear()
               CALL cl_getmsg('art-774',g_lang) RETURNING g_msg
               CALL g_cb.addItem('1',"1:" || g_msg CLIPPED)
               CALL cl_getmsg('art-775',g_lang) RETURNING g_msg
               CALL g_cb.addItem('2',"2:" || g_msg CLIPPED)
            END IF

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
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG 
 
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG 

         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG

         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG

         ON ACTION eff_plant
            LET g_action_choice="eff_plant" 
            EXIT DIALOG

         AFTER DIALOG
            CONTINUE DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t555_bp_refresh()
  DISPLAY ARRAY g_ltj TO s_ltj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

FUNCTION t555_a()
   DEFINE l_count     LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10 
   DEFINE l_rtz13     LIKE rtz_file.rtz13   
   DEFINE l_azt02     LIKE azt_file.azt02
   
   
   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'

   CALL g_ltj.clear()
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lti.* LIKE lti_file.*
   LET g_lti01_t = NULL
   LET g_lti.ltipos = '1'              

   IF g_argv1 = '3' THEN
      LET g_lti.lti02 = '1'
      LET g_lti.lti03 = '1'
   END IF

   IF g_argv1 <> '2' THEN
      LET g_lti.lti11 = ' '
   ELSE
      LET g_lti.lti11 = '1'
   END IF
 # LET g_lti.lti09    = 'N'
 # LET g_lti.ltiacti  = 'Y'
 # LET g_lti.lticonf  = 'N'
 # LET g_lti.lticrat  = g_today
 # LET g_lti.ltidate  = g_today
 # LET g_lti.ltigrup  = g_grup
 # LET g_lti.ltilegal = g_legal
 # LET g_lti.ltimodu  = g_user
 # LET g_lti.ltiorig  = g_grup
 # LET g_lti.ltioriu  = g_user
 # LET g_lti.ltiplant = g_plant
 # LET g_lti.ltiuser  = g_user

   LET g_lti_t.* = g_lti.*
   LET g_lti.lti00=g_lti00
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t555_i("a")                   
      IF INT_FLAG THEN
         INITIALIZE g_lti.* TO NULL
         CALL g_ltj.clear()     
         CALL g_ltk.clear()     
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_lti.lti01) THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK

      INSERT INTO lti_file VALUES (g_lti.*)
      IF SQLCA.sqlcode THEN      
         CALL cl_err3("ins","lti_file",g_lti.lti07,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK             
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF

      SELECT lti01 INTO g_lti.lti01 FROM lti_file
       WHERE lti00=g_lti00 
         AND lti01 = g_lti.lti01 
      LET g_lti01_t = g_lti.lti01        
      LET g_lti_t.* = g_lti.*
      CALL g_ltj.clear()
      CALL g_ltk.clear()                
      
      CALL t555_b_fill("1=1")
      IF g_argv1 != '3' THEN
         CALL t555_b1_fill("1=1")
      END IF
      CALL t555_refresh()

     #因為預設會將前一版本的單身資料全部都帶進,所以這邊不可以直接將單身資料筆數設定為0
      IF cl_null(g_rec_b) THEN
         LET g_rec_b = 0
      END IF
      IF cl_null(g_rec_b1) THEN
         LET g_rec_b1 = 0
      END IF
      CALL t555_b()
      CALL t555_b1_fill("1=1")
      CALL t555_refresh()
      IF g_argv1 != '3' THEN    
         CALL t555_b1()         
      END IF  
  
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t555_u()
DEFINE   l_n     LIKE type_file.num5
DEFINE   l_ltipos        LIKE lti_file.ltipos               

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL t555_msg('mod')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
  
   SELECT * INTO g_lti.* FROM lti_file
    WHERE lti06 = g_lti.lti06        #FUN-C60056 add   
      AND lti07 = g_lti.lti07        #FUN-C60056 add  
      AND lti08 = g_lti.lti08        #FUN-C60056 add
      AND ltiplant = g_lti.ltiplant  #FUN-C60056 add   

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lti01_t = g_lti.lti01
   IF g_aza.aza88 = 'Y' THEN
      BEGIN WORK
      OPEN t555_cl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant            
      IF STATUS THEN
         CALL cl_err("OPEN t555_cl:", STATUS, 1)
         CLOSE t555_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH t555_cl INTO g_lti.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)
         CLOSE t555_cl
         ROLLBACK WORK
         RETURN
      END IF

      LET g_lti_t.* = g_lti.*
      LET g_ltipos = g_lti.ltipos 
      UPDATE lti_file SET ltipos = '4'
       WHERE lti06 = g_lti_t.lti06                  
         AND lti07 = g_lti_t.lti07                  
         AND lti08 = g_lti_t.lti08               
         AND ltiplant = g_lti_t.ltiplant            
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lti_file",g_lti01_t,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK  
         RETURN
      END IF
      LET g_lti.ltipos = '4'
      DISPLAY BY NAME g_lti.ltipos
      CLOSE t555_cl 
      COMMIT WORK   
   END IF

   BEGIN WORK

   OPEN t555_cl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant           
   IF STATUS THEN
      CALL cl_err("OPEN t555_cl:", STATUS, 1)
      CLOSE t555_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t555_cl INTO g_lti.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)    
       CLOSE t555_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t555_show()

   WHILE TRUE
      LET g_lti01_t = g_lti.lti01

      CALL t555_i("u")                     

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lti.*=g_lti_t.*
         IF g_aza.aza88 = 'Y' THEN   #FUN-C50036
            LET g_lti.ltipos = g_ltipos #FUN-C50036
            UPDATE lti_file SET ltipos = g_lti.ltipos
             WHERE lti06 = g_lti_t.lti06                        
               AND lti07 = g_lti_t.lti07                        
               AND lti08 = g_lti_t.lti08                           
               AND ltiplant = g_lti_t.ltiplant                
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lti_file",g_lti.lti01,"",SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
            DISPLAY BY NAME g_lti.ltipos
         END IF  
         CALL t555_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

         IF g_aza.aza88 = 'Y' THEN
            IF g_ltipos = '1' THEN
               LET g_lti.ltipos = '1'
            ELSE
               LET g_lti.ltipos = '2'
            END IF              
            DISPLAY g_lti.ltipos TO ltipos 
         END IF

         IF g_lti.lti01 != g_lti_t.lti01
            OR g_lti.lti02 != g_lti_t.lti02
            OR g_lti.lti03 != g_lti_t.lti03 
            OR g_lti.lti04 != g_lti_t.lti04 
            OR g_lti_t.lti05 != g_lti.lti05
            OR g_lti_t.lti11 != g_lti.lti11 THEN
     
            SELECT COUNT(*) INTO l_n FROM ltj_file
             WHERE ltj12 = g_lti_t.lti06
               AND ltj13 = g_lti_t.lti07
               AND ltj14 = g_lti_t.lti08
               AND ltjplant = g_lti_t.ltiplant
          
            IF l_n > 0 THEN
               UPDATE ltj_file SET ltj01 = g_lti.lti01,      
                                   ltj10 = g_lti.lti04,            
                                   ltj11 = g_lti.lti05        
                WHERE ltj12 = g_lti_t.lti06                       
                  AND ltj13 = g_lti_t.lti07 
                  AND ltj14 = g_lti_t.lti08                      
                  AND ltjplant = g_lti_t.ltiplant             
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ltj_file",g_lti01_t,"",SQLCA.sqlcode,"","ltj",1)
                  CONTINUE WHILE
               END IF
            END IF  

            UPDATE ltk_file SET ltk02 = g_lti.lti01,
                                ltk03 = g_lti.lti04,
                                ltk04 = g_lti.lti05
             WHERE ltk13 = g_lti_t.lti06   
               AND ltk14 = g_lti_t.lti07
               AND ltk21 = g_lti_t.lti08   
               AND ltkplant = g_lti_t.ltiplant   
               
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ltk_file",g_lti01_t,"",SQLCA.sqlcode,"","ltk",1)
               CONTINUE WHILE
            END IF

            UPDATE ltl_file SET ltl01 = g_lti.lti01,
                                ltl03 = g_lti.lti04,
                                ltl04 = g_lti.lti05
             WHERE ltl05 = g_lti_t.lti06
               AND ltl06 = g_lti_t.lti07
               AND ltl07 = g_lti_t.lti08
               AND ltlplant = g_lti_t.ltiplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ltl_file",g_lti01_t,"",SQLCA.sqlcode,"","ltl",1)
               CONTINUE WHILE
            END IF
         END IF

         UPDATE lti_file SET lti_file.* = g_lti.*
          WHERE lti06 = g_lti_t.lti06
            AND lti07 = g_lti_t.lti07
            AND lti08 = g_lti_t.lti08
            AND ltiplant = g_lti_t.ltiplant

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lti_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF     
      EXIT WHILE
   END WHILE

   CLOSE t555_cl
   COMMIT WORK
END FUNCTION

FUNCTION t555_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1
DEFINE    li_result   LIKE type_file.num5
DEFINE    l_rtz13     LIKE rtz_file.rtz13  
DEFINE    l_rtz28     LIKE rtz_file.rtz28  
DEFINE    l_lph24     LIKE lph_file.lph24
DEFINE    l_lph03     LIKE lph_file.lph03
DEFINE    l_lmf03     LIKE lmf_file.lmf03
DEFINE    l_lmf04     LIKE lmf_file.lmf04
DEFINE    l_lni10     LIKE lni_file.lni10
DEFINE    l_azp02     LIKE azp_file.azp02  

   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY g_lti00 TO lti00
   DISPLAY g_lti.lti02 TO lti02   

   INPUT BY NAME g_lti.lti07,g_lti.lti01,g_lti.lti04,g_lti.lti05,g_lti.lti02,g_lti.lti03,g_lti.lti11,  
                 g_lti.ltiuser,g_lti.ltimodu,g_lti.ltiacti,g_lti.ltigrup,g_lti.ltidate,g_lti.lticrat,   
                 g_lti.ltioriu,g_lti.ltiorig                                                            
           WITHOUT DEFAULTS

      BEFORE INPUT
         DISPLAY BY NAME g_lti.ltipos                   
         LET g_before_input_done = FALSE
         CALL t555_set_entry(p_cmd)
         CALL t555_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         LET g_flag2 = 'N'
         LET g_lti.lti06 = g_plant                                      
         SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant  
         DISPLAY BY NAME g_lti.lti06                                    
         DISPLAY l_azp02 TO azp02
                                             
      AFTER FIELD lti07
         IF NOT cl_null(g_lti.lti07) THEN
            IF p_cmd = 'a' THEN
               CALL t555_lti07()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lti07
               END IF
            END IF
            IF (p_cmd='a' OR p_cmd='u') AND g_lti.lti07 != g_lti_t.lti07 THEN
               CALL t555_delall('change_ins')
               LET g_lti.lti07=g_lti_t.lti07
               NEXT FIELD lti07
            END IF
            DISPLAY BY NAME g_lti.lti08 
         END IF


      AFTER FIELD lti01
         IF NOT cl_null(g_lti.lti01) THEN
            IF p_cmd='a' OR (p_cmd='u' AND g_lti.lti01 != g_lti_t.lti01) THEN
               CALL i555_lti01('a',g_lti.lti01)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_lti.lti01=g_lti_t.lti01
                  NEXT FIELD lrp01
               ELSE
                  IF NOT cl_null(g_lti.lti04) AND NOT cl_null(g_lti.lti05) THEN     
                   SELECT COUNT(*) INTO l_n
                     FROM lrp_file
                    WHERE lrp00=g_lrp00
                      AND lrp01=g_lrp.lrp01
                      AND (lrp04 BETWEEN g_lti.lti04 AND g_lti.lti05
                       OR  lrp05 BETWEEN g_lti.lti04 AND g_lti.lti05
                       OR  g_lti.lti04 BETWEEN lti04 AND lti05)
                      AND lrp09 = 'Y'
                      AND lrpconf = 'Y'
                      AND lrpacti = 'Y'
                      AND lrp07 <> g_lti.lti07                   
                     IF l_n>0 THEN
                        CALL cl_err('','alm1519',1)      
                        LET g_lti.lti01=g_lti_t.lti01
                        DISPLAY '' TO FORMONLY.lph02
                        NEXT FIELD lti01
                     END IF
                  END IF         #FUN-BC0079 add END IF
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.lph02
         END IF  
    
      ON CHANGE lti01
         CALL t555_ckmult()
         IF g_success = 'N' THEN RETURN END IF

      AFTER FIELD lti02 
         IF p_cmd='u' AND g_lti.lti02 != g_lti_t.lti02 THEN 
            IF NOT cl_confirm('alm-816') THEN 
               LET g_lti.lti02=g_lti_t.lti02
            ELSE 
               DELETE FROM ltj_file
                WHERE ltj12 = g_lti.lti06             
                  AND ltj13 = g_lti.lti07 
                  AND ltj14 = g_lti.lti08        
                  AND ltjplant = g_lti.ltiplant   
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ltj_file",g_lti.lti01,g_lti00,SQLCA.sqlcode,"","",1)
                ELSE 
                  CALL g_ltj.clear()
                  CALL t555_b_fill(g_wc2)
                  CALL t555_bp_refresh()
                END IF             
            END IF     
         END IF    
      
      AFTER FIELD lti03
         IF g_lti_t.lti03 !='1' THEN 
            IF p_cmd='u' AND g_lti.lti03 != g_lti_t.lti03 THEN 
               IF NOT cl_confirm('alm-h67') THEN 
                  LET g_lti.lti03=g_lti_t.lti03
               ELSE 
               	 DELETE FROM ltl_file
                    WHERE ltl05 = g_lti.lti06            
                      AND ltl06 = g_lti.lti07
                      AND ltl07 = g_lti.lti08
                      AND ltlplant = g_lti.ltiplant   
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","ltl_file",g_lti.lti01,g_lti00,SQLCA.sqlcode,"","",1)
                   END IF          
               END IF                         
            END IF   
         END IF                
       
      AFTER FIELD lti04
         IF NOT cl_null(g_lti.lti04) THEN
            IF NOT cl_null(g_lti.lti05) THEN
               IF g_lti.lti04 > g_lti.lti05 THEN
                  CALL cl_err('','art-711',0)                      #失效日期不可小于生效日期
                  LET g_lti.lti04=g_lti_t.lti04
                  NEXT FIELD lti04
               END IF
            END IF
            IF p_cmd='a' OR (p_cmd='u' AND g_lti.lti04 != g_lti_t.lti04) THEN
               IF NOT cl_null(g_lti.lti01) AND NOT cl_null(g_lti.lti05) THEN
                  IF p_cmd = 'a' THEN 
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  lrp05 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  g_lti.lti04 BETWEEN lti04 AND lti05)
                         AND lrp09 = 'Y'
                         AND lrpconf = 'Y'
                         AND lrpacti = 'Y'  
                       AND lrp07<>g_lti.lti07
                  ELSE 
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  lrp05 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  g_lti.lti04 BETWEEN lti04 AND lti05)
                         AND lrp04 <> g_lrp_t.lrp04
                         AND lrp05 <> g_lrp_t.lrp05
                         AND lrp09 = 'Y'
                         AND lrpconf = 'Y'
                         AND lrpacti = 'Y'
                         AND lrp07 <> g_lti_t.lti07
                  END IF 
                  IF l_n>0  THEN
                     CALL cl_err('','alm1519',1)
                     LET g_lti.lti04=g_lti_t.lti04
                     NEXT FIELD lti04
                  END IF
               END IF       
            END IF                 
         END IF 

      ON CHANGE lti04
         CALL t555_ckmult()
         IF g_success = 'N' THEN RETURN END IF
           
      AFTER FIELD lti05
         IF NOT cl_null(g_lti.lti05) THEN
            IF NOT cl_null(g_lti.lti04) THEN 
               IF g_lti.lti04 > g_lti.lti05 THEN
                  CALL cl_err('','art-711',0)                      #失效日期不可小于生效日期
                  LET g_lti.lti05=g_lti_t.lti05
                  NEXT FIELD lti05 
               END IF  
            END IF 
            IF p_cmd='a' OR (p_cmd='u' AND g_lti.lti05 != g_lti_t.lti05) THEN
               IF NOT cl_null(g_lti.lti01) AND NOT cl_null(g_lti.lti04) THEN    
                  IF p_cmd = 'a' THEN 
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  lrp05 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  g_lti.lti04 BETWEEN lti04 AND lti05)
                         AND lrp07 <> g_lti.lti07
                  ELSE 
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  lrp05 BETWEEN g_lti.lti04 AND g_lti.lti05
                          OR  g_lti.lti04 BETWEEN lti04 AND lti05)
                         AND lrp04 <> g_lrp_t.lrp04
                         AND lrp05 <> g_lrp_t.lrp05
                         AND lrp09 = 'Y'
                         AND lrpconf = 'Y'
                         AND lrpacti = 'Y'
                         AND lrp07 <> g_lti_t.lti07 
                  END IF 
                  IF l_n>0 THEN
                     CALL cl_err('','alm1519',1)
                     LET g_lti.lti05=g_lti_t.lti05
                     NEXT FIELD lti05
                  END IF
               END IF         
            END IF
         END IF

      ON CHANGE lti05
          CALL t555_ckmult()
          IF g_success = 'N' THEN RETURN END IF 

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION controlp
         CASE
            WHEN INFIELD(lti07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lrp03"
               LET g_qryparam.arg1 = g_lti00
               LET g_qryparam.arg2 = g_plant
               LET g_qryparam.default1 = g_lti.lti07
               CALL cl_create_qry() RETURNING g_lti.lti07
               DISPLAY BY NAME g_lti.lti07
               NEXT FIELD lti07
            WHEN INFIELD(lti01)    
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lph1"
               IF g_lti.lti00 = '1' THEN
                  LET g_qryparam.where = " lph06 = 'Y' "
               END IF
               LET g_qryparam.default1 = g_lti.lti01
               CALL cl_create_qry() RETURNING g_lti.lti01
               DISPLAY BY NAME g_lti.lti01
               NEXT FIELD lti01
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

   IF INT_FLAG AND p_cmd = 'a' AND g_flag2 = 'Y' THEN   #非正常離開必須要將剛才預設新增的單身資料刪除,避免錯誤
      CALL t555_delall('ins_chk')
   END IF
END FUNCTION

FUNCTION t555_lti07()
   DEFINE  l_cnt       LIKE type_file.num5
   DEFINE  l_sql            STRING
   DEFINE  l_lph01     LIKE lph_file.lph01
   DEFINE  l_lph02     LIKE lph_file.lph02
   DEFINE  l_lph24     LIKE lph_file.lph24
   DEFINE  l_lph06     LIKE lph_file.lph06
 
   IF cl_null(g_lti.lti07) THEN
      RETURN
      CALL cl_err('','-400',0)
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM lti_file
    WHERE lti06 = g_plant
      AND lti07 = g_lti.lti07
      AND ltiplant = g_plant
      AND (lticonf = 'N' OR lti09 = 'N')    
 
   IF l_cnt > 0 THEN
      LET g_lti08_o = NULL
      LET g_errno = 'alm-h66'
      RETURN
   END IF
 
   LET g_flag2 = 'Y'
 
   SELECT MAX(lti08) INTO g_lti08_o
     FROM lti_file
    WHERE lti06 = g_plant
      AND lti07 = g_lti.lti07
      AND lti09 = 'Y'
      AND ltiacti = 'Y'
      AND ltiplant = g_plant
 
   IF cl_null(g_lti08_o) THEN
      LET g_lti08_o = 0
   END IF

   SELECT * INTO g_lti.*
     FROM lti_file
    WHERE lti06 = g_plant
      AND lti07 = g_lti.lti07
      AND lti08 = g_lti08_o
      AND ltiplant = g_plant

   LET g_lti.lti06    = g_plant
   LET g_lti.lti08    = g_lti08_o + 1
   LET g_lti.lti09    = 'N'
   LET g_lti.lti10    = NULL
   LET g_lti.ltiacti  = 'Y'
   LET g_lti.lticonf  = 'N'
   LET g_lti.lticonu  = NULL
   LET g_lti.lticond  = NULL
   LET g_lti.lticrat  = g_today
   LET g_lti.ltidate  = g_today
   LET g_lti.ltigrup  = g_grup
   LET g_lti.ltilegal = g_legal
   LET g_lti.ltimodu  = g_user
   LET g_lti.ltiorig  = g_grup
   LET g_lti.ltioriu  = g_user
   LET g_lti.ltiplant = g_plant
   LET g_lti.ltiuser  = g_user
   LET g_lti.ltipos   = '1'
   
   DROP TABLE ltj_temp
   SELECT * FROM ltj_file WHERE 1 = 0 INTO TEMP ltj_temp
   DROP TABLE ltk_temp
   SELECT * FROM ltk_file WHERE 1 = 0 INTO TEMP ltk_temp
   DROP TABLE ltl_temp
   SELECT * FROM ltl_file WHERE 1 = 0 INTO TEMP ltl_temp
   DROP TABLE ltn_temp
   SELECT * FROM ltn_file WHERE 1 = 0 INTO TEMP ltn_temp

   LET g_success = 'Y'

   DELETE FROM ltj_temp
   DELETE FROM ltk_temp
   DELETE FROM ltl_temp
   DELETE FROM ltn_temp

   INSERT INTO ltj_temp 
        SELECT ltj_file.*
          FROM ltj_file
         WHERE ltj12 = g_lti.lti06
           AND ltj13 = g_lti.lti07
           AND ltj14 = g_lti08_o
           AND ltjplant = g_plant

   INSERT INTO ltk_temp
        SELECT ltk_file.*
          FROM ltk_file
         WHERE ltk13 = g_lti.lti06
           AND ltk14 = g_lti.lti07
           AND ltk21 = g_lti08_o
           AND ltkplant = g_plant

   INSERT INTO ltl_temp
        SELECT ltl_file.*
          FROM ltl_file
         WHERE ltl05 = g_lti.lti06
           AND ltl06 = g_lti.lti07
           AND ltl07 = g_lti08_o
           AND ltlplant = g_plant
   
   INSERT INTO ltn_temp
        SELECT ltn_file.*
          FROM ltn_file
         WHERE ltn01 = g_lti.lti06
           AND ltn02 = g_lti.lti07
           AND ltn08 = g_lti08_o
           AND ltnplant = g_plant

   UPDATE ltj_temp SET ltj14 = g_lti.lti08
   UPDATE ltk_temp SET ltk21 = g_lti.lti08
   UPDATE ltl_temp SET ltl07 = g_lti.lti08
   UPDATE ltn_temp SET ltn08 = g_lti.lti08

   LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant, 'ltj_file'),   #單頭
               " SELECT * FROM ltj_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE trans_ins_ltj FROM l_sql
   EXECUTE trans_ins_ltj
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO ltj_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant, 'ltk_file'),   #單頭
               " SELECT * FROM ltk_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE trans_ins_ltk FROM l_sql
   EXECUTE trans_ins_ltk
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO ltk_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant, 'ltl_file'),   #單頭
               " SELECT * FROM ltl_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE trans_ins_ltl FROM l_sql
   EXECUTE trans_ins_ltl
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO ltl_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant, 'ltn_file'),   #單頭
               " SELECT * FROM ltn_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE trans_ins_ltn FROM l_sql
   EXECUTE trans_ins_ltn
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   DROP TABLE ltj_temp
   DROP TABLE ltk_temp
   DROP TABLE ltl_temp
   DROP TABLE ltn_temp

   DISPLAY BY NAME g_lti.lti06,g_lti.lti00,g_lti.lti07,g_lti.lti08,
                   g_lti.lti01,g_lti.lti04,g_lti.lti05,g_lti.lti02,g_lti.lti03,g_lti.lti11,
                   g_lti.ltipos,
                   g_lti.lticonf,g_lti.lticonu,g_lti.lticond,g_lti.lti09,g_lti.lti10,
                   g_lti.ltiuser,g_lti.ltimodu,g_lti.ltiacti,g_lti.ltigrup,g_lti.ltidate,
                   g_lti.lticrat,g_lti.ltioriu,g_lti.ltiorig    

   LET g_errno=''

   SELECT lph02,lph24,lph06 INTO l_lph02,l_lph24,l_lph06
     FROM lph_file WHERE lph01 = g_lti.lti01

   CASE WHEN SQLCA.sqlcode=100 
             LET g_errno = 'anm-027'
             LET l_lph02 = NULL
        WHEN l_lph24 != 'Y'    
             LET g_errno = '9029'
        WHEN l_lph06 <> 'Y' AND g_lti.lti00 = '1'
             LET g_errno = 'alm-829'
        OTHERWISE             
             LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) THEN
      DISPLAY l_lph02 TO FORMONLY.lph02
   END IF
END FUNCTION

FUNCTION i555_lti01(p_cmd,l_lph01)
 DEFINE  p_cmd       LIKE type_file.chr1
 DEFINE  l_lph01     LIKE lph_file.lph01
 DEFINE  l_lph02     LIKE lph_file.lph02
 DEFINE  l_lph24     LIKE lph_file.lph24
 DEFINE  l_lph06     LIKE lph_file.lph06 

   LET g_errno=''
   SELECT lph02,lph24,lph06 INTO l_lph02,l_lph24,l_lph06 
     FROM lph_file WHERE lph01=l_lph01
   CASE WHEN SQLCA.sqlcode=100 LET g_errno = 'anm-027'
                               LET l_lph02 = NULL
        WHEN l_lph24 != 'Y'    LET g_errno = '9029'
        WHEN l_lph06 <> 'Y' AND g_lti.lti00 = '1'      
                               LET g_errno = 'alm-829' 
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd' THEN
      DISPLAY l_lph02 TO FORMONLY.lph02
   END IF
END FUNCTION

FUNCTION t555_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ltj.clear()
   CALL g_ltk.clear()    
   DISPLAY ' ' TO FORMONLY.cnt

   DISPLAY g_lti00 TO lti00    
   CALL cl_set_comp_entry("lti00",FALSE)  

   CALL t555_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lti.* TO NULL
      RETURN
   END IF

   OPEN t555_cs                            
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lti.* TO NULL
   ELSE
      OPEN t555_count
      FETCH t555_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t555_fetch('F')              
   END IF

END FUNCTION

FUNCTION t555_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                

   CASE p_flag
      WHEN 'N' FETCH NEXT     t555_cs INTO g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant     
      WHEN 'P' FETCH PREVIOUS t555_cs INTO g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant    
      WHEN 'F' FETCH FIRST    t555_cs INTO g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant    
      WHEN 'L' FETCH LAST     t555_cs INTO g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant    
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
            FETCH ABSOLUTE g_jump t555_cs INTO g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant                    
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)
      INITIALIZE g_lti.* TO NULL
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

   SELECT * INTO g_lti.* FROM lti_file WHERE lti06 = g_lti.lti06
                                         AND lti07 = g_lti.lti07
                                         AND lti08 = g_lti.lti08
                                         AND ltiplant = g_lti.ltiplant

   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lti_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lti.* TO NULL
      RETURN
   END IF

   CALL t555_show()

END FUNCTION

FUNCTION t555_show()
DEFINE l_rtz13     LIKE rtz_file.rtz13   
DEFINE l_lmb03     LIKE lmb_file.lmb03
DEFINE l_lmc04     LIKE lmc_file.lmc04
DEFINE l_azt02     LIKE azt_file.azt02
DEFINE l_azp02     LIKE azp_file.azp02   

   LET g_lti_t.* = g_lti.*
   DISPLAY BY NAME g_lti.lti06,g_lti.lti00,g_lti.lti07,g_lti.lti08,                             
                   g_lti.lti01,g_lti.lti04,g_lti.lti05,g_lti.lti02,g_lti.lti03,g_lti.lti11,    
                   g_lti.ltipos,
                   g_lti.lticonf,g_lti.lticonu,g_lti.lticond,g_lti.lti09,g_lti.lti10,         
                   g_lti.ltiuser,g_lti.ltimodu,g_lti.ltiacti,g_lti.ltigrup,g_lti.ltidate,     
                   g_lti.lticrat,g_lti.ltioriu,g_lti.ltiorig                                  
   DISPLAY g_lti00 TO lti00

   SELECT azp02 INTO l_azp02 FROM azp_file where azp01 = g_lti.lti06
   DISPLAY l_azp02 TO azp02
   
  #CALL t555_lti01('d',g_lti.lti01)
   CALL t555_b_fill(g_wc2)     
   CALL t555_b1_fill(g_wc3)    
   CALL cl_show_fld_cont()
   CALL t555_pic()   
END FUNCTION

FUNCTION t555_r()
DEFINE l_count1   LIKE type_file.num5  
DEFINE l_count2   LIKE type_file.num5 
DEFINE l_count3   LIKE type_file.num5 
DEFINE l_count4   LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL t555_msg('del')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   SELECT * INTO g_lti.* FROM lti_file
    WHERE lti06=g_lti.lti06
      AND lti07 = g_lti.lti07
      AND lti08 = g_lti.lti08 
      AND ltiplant = g_lti.ltiplant
   
    LET g_lti01_t=g_lti.lti01

    IF g_aza.aza88 = 'Y' THEN
       LET l_count1 = 0
       LET l_count2 = 0
       LET l_count3 = 0
       LET l_count4 = 0

       IF g_lti.ltipos = '3' THEN
          SELECT COUNT(*) INTO l_count1
            FROM ltj_file
           WHERE ltj12 = g_lti.lti06
             AND ltj13 = g_lti.lti07
             AND ltj14 = g_lti.lti08
             AND ltjplant = g_lti.ltiplant
             AND ltjacti = 'Y'
           
          SELECT COUNT(*) INTO l_count2
            FROM ltk_file
           WHERE ltk13 = g_lti.lti06
             AND ltk14 = g_lti.lti07
             AND ltk21 = g_lti.lti08
             AND ltkplant = g_lti.ltiplant
             AND ltkacti = 'Y'

          SELECT COUNT(*) INTO l_count3
            FROM ltl_file
           WHERE ltl05 = g_lti.lti06
             AND ltl06 = g_lti.lti07
             AND ltl07 = g_lti.lti08
             AND ltlplqnt = g_lti.ltiplant
             AND ltlacti = 'Y'

          SELECT COUNT(*) INTO l_count4
            FROM ltn_file
           WHERE ltn01 = g_lti.lti06
             AND ltn02 = g_lti.lti07
             AND ltn08 = g_lti.lti08
             AND ltnplant = g_lti.ltiplant
             AND ltnacti = 'Y'
       END IF
       IF g_lti.ltipos = '1' OR
          (g_lti.ltipos = '3' AND l_count1 = 0 AND l_count2 = 0 AND l_count3 = 0 AND l_count4 = 0) THEN    
       ELSE
          CALL cl_err('','apc-156',0) #資料的狀態須已傳POS否為'1.新增未下傳'，或者已傳POS否為'3.已下傳'且單身資料都無效，才能刪除！
          RETURN
       END IF
    END IF

    BEGIN WORK

   OPEN t555_cl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant     
   IF STATUS THEN
      CALL cl_err("OPEN t555_cl:", STATUS, 1)
      CLOSE t555_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t555_cl INTO g_lti.*              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t555_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL          
       LET g_doc.column1 = "lti06"         
       LET g_doc.column2 = "lti07"         
       LET g_doc.column3 = "lti08"         
       LET g_doc.column4 = "ltiplant"      
       LET g_doc.value1 = g_lti.lti06      
       LET g_doc.value2 = g_lti.lti07      
       LET g_doc.value3 = g_lti.lti08      
       LET g_doc.value4 = g_lti.ltiplant   
       CALL cl_del_doc()               
 
     CALL t555_delall('del')

      CLEAR FORM
      CALL g_ltj.clear()
      CALL g_ltk.clear()                 
      OPEN t555_count
      IF STATUS THEN
         CLOSE t555_cs
         CLOSE t555_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t555_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t555_cs
         CLOSE t555_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t555_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t555_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE  
         CALL t555_fetch('/')
      END IF
   END IF

   CLOSE t555_cl
   COMMIT WORK

END FUNCTION

FUNCTION t555_b()
DEFINE   l_ac_t          LIKE type_file.num5          
DEFINE   l_n             LIKE type_file.num5                
DEFINE   l_cnt           LIKE type_file.num5                
DEFINE   l_lock_sw       LIKE type_file.chr1                
DEFINE   p_cmd           LIKE type_file.chr1                
DEFINE   l_allow_insert  LIKE type_file.num5
DEFINE   l_allow_delete  LIKE type_file.num5
DEFINE   l_count         LIKE type_file.num5
DEFINE   l_n1            LIKE type_file.num5
DEFINE   l_ltipos        LIKE lti_file.ltipos               
DEFINE   l_pos_str       LIKE type_file.chr1                
    
    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lti.lti01 IS NULL THEN
       RETURN
   END IF

   IF g_lti.lti06 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF g_lti.ltiacti = 'N' THEN
      CALL cl_err('','9027',0)
      RETURN
   END IF

   IF g_lti.lti09 = 'Y' THEN        #已發佈時不允許修改
      CALL cl_err('','alm-h55',0)
      RETURN
   END IF

   IF g_lti.lticonf = 'Y' THEN   #已確認時不允許修改
      CALL cl_err('','alm-027',0)
      RETURN
   END IF

    IF g_aza.aza88 = 'Y' THEN
       BEGIN WORK
       OPEN t555_cl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant            
       IF STATUS THEN
          CALL cl_err("OPEN t555_cl:", STATUS, 1)
          CLOSE t555_cl
          ROLLBACK WORK
          RETURN
       END IF

       FETCH t555_cl INTO g_lti.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)
          CLOSE t555_cl
          ROLLBACK WORK
          RETURN
       END IF
       LET l_pos_str = 'N'
       LET l_ltipos = g_lti.ltipos
       
       UPDATE lti_file SET ltipos = '4'
        WHERE lti06 = g_lti_t.lti06
          AND lti07 = g_lti_t.lti07
          AND lti08 = g_lti_t.lti08
          AND ltiplant = g_lti_t.ltiplant
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","lti_file",g_lti.lti01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       LET g_lti.ltipos = '4'
       DISPLAY BY NAME g_lti.ltipos
       COMMIT WORK  #FUN-C40109 Add
    END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT ltj02,'',ltj03,ltj04,ltj05,ltj06,ltj07,ltj08,ltj09,ltjacti ",
                       " FROM ltj_file ",
                       #" WHERE ltj12 = ? AND ltj13 = ? AND ltj14 =?  AND ltjplant = ? AND ltj02 = ?",                 #FUN-C90046 mark
                       " WHERE ltj12 = ? AND ltj13 = ? AND ltj14 =?  AND ltjplant = ? AND ltj02 = ? AND ltj06 = ?",    #FUN-C90046 add
                       "  FOR UPDATE  "
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

    DECLARE t555_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_ltj WITHOUT DEFAULTS FROM s_ltj.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

           IF g_lti.lticonf = 'Y' THEN
              CALL cl_err('','1208',0)
              RETURN
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           OPEN t555_cl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant              
           IF STATUS THEN
              CALL cl_err("OPEN t555_cl:", STATUS, 1)
              CLOSE t555_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t555_cl INTO g_lti.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)
              CLOSE t555_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
               IF g_aza.aza88 = 'Y' THEN
                  IF l_ltipos <> '1' THEN
                     CALL cl_set_comp_entry("ltj02",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("ltj02",TRUE)
                  END IF 
               END IF 
              LET g_ltj_t.* = g_ltj[l_ac].*  #BACKUP
              #OPEN t555_bcl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant,g_ltj_t.ltj02               #FUN-C90046 mark
              OPEN t555_bcl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant,g_ltj_t.ltj02,g_ltj_t.ltj06  #FUN-C90046 add 
              IF STATUS THEN
                 CALL cl_err("OPEN t555_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t555_bcl INTO g_ltj[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ltj_t.ltj02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL t555_ltj02('d')
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_set_comp_entry("ltj02",TRUE)   
           INITIALIZE g_ltj[l_ac].* TO NULL
           LET g_ltj[l_ac].ltj09 = 'Y'           
           LET g_ltj[l_ac].ltjacti = 'Y'         
           LET g_ltj_t.* = g_ltj[l_ac].*         
           LET g_ltj[l_ac].ltj03=1
           LET g_ltj[l_ac].ltj04=1
           LET g_ltj[l_ac].ltj05=100
           IF g_argv1 = '3' THEN
              LET g_ltj[l_ac].ltj03=0
              LET g_ltj[l_ac].ltj04=0
              LET g_ltj[l_ac].ltj05=0
           ELSE
              LET g_ltj[l_ac].ltj06=0
              LET g_ltj[l_ac].ltj07=0
              LET g_ltj[l_ac].ltj08=0
           END IF
           CALL cl_show_fld_cont()
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
           NEXT FIELD ltj02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

          INSERT INTO ltj_file(ltj00,ltj01,ltj02,ltj03,ltj04,ltj05,ltj06,ltj07,ltj08,ltj09,ltj10,ltj11,ltjacti,
                               ltj12,ltj13,ltj14,ltjlegal,ltjplant)                                                    
          VALUES(g_lti00,g_lti.lti01,g_ltj[l_ac].ltj02,g_ltj[l_ac].ltj03,g_ltj[l_ac].ltj04,g_ltj[l_ac].ltj05,
                 g_ltj[l_ac].ltj06,g_ltj[l_ac].ltj07,g_ltj[l_ac].ltj08,g_ltj[l_ac].ltj09,
                 g_lti.lti04,g_lti.lti05,g_ltj[l_ac].ltjacti,
                 g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltilegal,g_lti.ltiplant)                                          

          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ltj_file",g_lti.lti01,g_ltj[l_ac].ltj02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET l_pos_str = 'Y'   
             IF l_ltipos <> '1' THEN
                LET l_ltipos = '2'
             ELSE
                LET l_ltipos = '1'
             END IF
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF

        AFTER FIELD ltj02
           IF NOT cl_null(g_ltj[l_ac].ltj02) THEN
              IF g_lti.lti02='4' THEN
                 IF NOT s_chk_item_no(g_ltj[l_ac].ltj02,"") THEN
                    CALL cl_err('',g_errno,1)
                    LET g_ltj[l_ac].ltj02= g_ltj_t.ltj02
                    NEXT FIELD ltj02
                 END IF
              END IF
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltj[l_ac].ltj02 != g_ltj_t.ltj02) THEN
                 CALL t555_ltj02('a')
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_ltj[l_ac].ltj02=g_ltj_t.ltj02
                    NEXT FIELD ltj02
                 END IF 
                 #FUN-C90046------add---str
                 IF g_argv1 = '3' THEN
                    IF NOT cl_null(g_ltj[l_ac].ltj06) THEN
                       SELECT COUNT(*) INTO l_n1
                         FROM ltj_file
                        WHERE ltj12 = g_lti.lti06
                          AND ltj13 = g_lti.lti07
                          AND ltj14 = g_lti.lti08
                          AND ltjplant = g_lti.ltiplant
                          AND ltj02 = g_ltj[l_ac].ltj02
                          AND ltj06 = g_ltj[l_ac].ltj06
                       IF l_n1>0 THEN
                          CALL cl_err('','-239',1)
                          LET g_ltj[l_ac].ltj02=g_ltj_t.ltj02
                          NEXT FIELD ltj02
                       END IF
                    END IF
                 ELSE
                 #FUN-C90046------add---end 
                    SELECT COUNT(*) INTO l_n1 
                      FROM ltj_file 
                     WHERE ltj12 = g_lti.lti06
                       AND ltj13 = g_lti.lti07
                       AND ltj14 = g_lti.lti08
                       AND ltjplant = g_lti.ltiplant
                       AND ltj02=g_ltj[l_ac].ltj02
                    IF l_n1>0 THEN 
                       CALL cl_err('','-239',1)
                       LET g_ltj[l_ac].ltj02=g_ltj_t.ltj02
                       NEXT FIELD ltj02
                    END IF      
                END IF     #FUN-C90046 add
              END IF
           END IF

        AFTER FIELD ltj03
           IF NOT cl_null(g_ltj[l_ac].ltj03) THEN
              IF g_ltj[l_ac].ltj03 <= 0 THEN
                 CALL cl_err('','alm-061',0)
                 NEXT FIELD ltj03
              END IF
           END IF

        AFTER FIELD ltj04
           IF NOT cl_null(g_ltj[l_ac].ltj04) THEN
              IF g_ltj[l_ac].ltj04 <= 0 THEN
                 CALL cl_err('','alm-061',0)
                 NEXT FIELD ltj04
              END IF
           END IF
           
        AFTER FIELD ltj05
           IF NOT cl_null(g_ltj[l_ac].ltj05) THEN
              IF g_ltj[l_ac].ltj05 < 0 OR g_ltj[l_ac].ltj05 > 100 THEN
                 CALL cl_err('','alm-257',0)
                 NEXT FIELD ltj05
              END IF
           END IF   

        AFTER FIELD ltj06
           IF NOT cl_null(g_ltj[l_ac].ltj06) THEN
              IF g_ltj[l_ac].ltj06 <= 0 THEN 
                 CALL cl_err('','alm-808',0)
                 NEXT FIELD ltj06
              END IF
              #FUN-C90046------add---str
              IF (p_cmd = 'a' OR (p_cmd = 'u' AND g_ltj[l_ac].ltj06 != g_ltj_t.ltj06))
                 AND NOT cl_null(g_ltj[l_ac].ltj02) THEN
                 SELECT COUNT(*) INTO l_n1
                   FROM ltj_file
                  WHERE ltj12 = g_lti.lti06
                    AND ltj13 = g_lti.lti07
                    AND ltj14 = g_lti.lti08
                    AND ltjplant = g_lti.ltiplant
                    AND ltj02 = g_ltj[l_ac].ltj02
                    AND ltj06 = g_ltj[l_ac].ltj06
                 IF l_n1>0 THEN
                    CALL cl_err('','-239',1)
                    LET g_ltj[l_ac].ltj06=g_ltj_t.ltj06
                    NEXT FIELD ltj06
                 END IF
              END IF
              #FUN-C90046------add---end
           END IF

        AFTER FIELD ltj07
           IF NOT cl_null(g_ltj[l_ac].ltj07) THEN
              IF g_ltj[l_ac].ltj07 <= 0 THEN
                 CALL cl_err('','alm-808',0)
                 NEXT FIELD ltj07
              END IF
           END IF

        AFTER FIELD ltj08
           IF NOT cl_null(g_ltj[l_ac].ltj08) THEN
              IF g_ltj[l_ac].ltj08 <= 0 THEN
                 CALL cl_err('','alm-808',0)
                 NEXT FIELD ltj08
              END IF
           END IF
                   
        BEFORE DELETE                 
           DISPLAY "BEFORE DELETE"
           IF g_ltj_t.ltj02 IS NOT NULL THEN
              IF g_aza.aza88 = 'Y' THEN
                 IF l_ltipos = '1' OR (l_ltipos = '3' AND g_ltj_t.ltjacti = 'N') THEN
                 ELSE
                    CALL cl_err('','apc-155',0)
                    CANCEL DELETE
                 END IF
              END IF
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ltj_file
               WHERE ltj12 = g_lti.lti06                      
                 AND ltj13 = g_lti.lti07 
                 AND ltj14 = g_lti.lti08                
                 AND ltjplant = g_lti.ltiplant       
                 AND ltj02 = g_ltj_t.ltj02               
                 AND ltj06 = g_ltj_t.ltj06       #FUN-C90046 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ltj_file",g_lti.lti01,g_ltj_t.ltj02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ltj[l_ac].* = g_ltj_t.*
              CLOSE t555_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ltj[l_ac].ltj02,-263,1)
              LET g_ltj[l_ac].* = g_ltj_t.*
           ELSE
              UPDATE ltj_file SET ltj02 = g_ltj[l_ac].ltj02,
                                  ltj03 = g_ltj[l_ac].ltj03,
                                  ltj04 = g_ltj[l_ac].ltj04,
                                  ltj05 = g_ltj[l_ac].ltj05,
                                  ltj06 = g_ltj[l_ac].ltj06,  
                                  ltj07 = g_ltj[l_ac].ltj07,  
                                  ltj08 = g_ltj[l_ac].ltj08,  
                                  ltj09 = g_ltj[l_ac].ltj09,  
                                  ltjacti = g_ltj[l_ac].ltjacti
               WHERE ltj12 = g_lti_t.lti06  
                 AND ltj13 = g_lti_t.lti07 
                 AND ltj14 = g_lti_t.lti08 
                 AND ltjplant = g_lti_t.ltiplant       
                 AND ltj02 = g_ltj_t.ltj02             
                 AND ltj06 = g_ltj_t.ltj06       #FUN-C90046 add
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ltj_file",g_lti.lti01,g_ltj_t.ltj02,SQLCA.sqlcode,"","",1)
                 LET g_ltj[l_ac].* = g_ltj_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 LET l_pos_str = 'Y'
                 IF l_ltipos <> '1' THEN
                    LET l_ltipos = '2'
                 ELSE
                    LET l_ltipos = '1'
                 END IF
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
                 LET g_ltj[l_ac].* = g_ltj_t.*
                 CALL t555_delall('upd_del1')
              END IF
              CLOSE t555_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t555_bcl
           COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(ltj02)
                IF g_lti.lti02 <> '4' THEN
                   CALL cl_init_qry_var()
                   CASE g_lti.lti02
                      WHEN "1" 
                        LET g_qryparam.form ="q_lpc01_1"
                        LET g_qryparam.where = " lpcacti = 'Y' " 
                        LET g_qryparam.arg1 = '6'      
                      WHEN "2"
                        IF g_argv1 = '3' THEN                  
                           LET g_qryparam.form = "q_lpc01_1"  
                           LET g_qryparam.where = " lpcacti = 'Y' "  
                           LET g_qryparam.arg1 = '7'           
                        ELSE                                   
                           LET g_qryparam.form ="q_oba1"
                        END IF                                 
                      WHEN "3"
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1='2'
                   END CASE      
                   LET g_qryparam.default1 = g_ltj[l_ac].ltj02
                   CALL cl_create_qry() RETURNING g_ltj[l_ac].ltj02
                ELSE
                   CALL q_sel_ima(FALSE, "q_ima", "", g_ltj[l_ac].ltj02, "", "", "", "" ,"",'' )  RETURNING g_ltj[l_ac].ltj02
                END IF
                DISPLAY BY NAME g_ltj[l_ac].ltj02
                NEXT FIELD ltj02
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLO                       
           IF INFIELD(ltj02) AND l_ac > 1 THEN
              LET g_ltj[l_ac].* = g_ltj[l_ac-1].*
              LET g_ltj[l_ac].ltj02 = g_rec_b + 1
              NEXT FIELD ltj02
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

        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
    END INPUT

    CLOSE t555_bcl
    COMMIT WORK
    IF g_aza.aza88 = 'Y' THEN
       IF l_pos_str = 'Y' THEN
          IF l_ltipos <> '1' THEN
             LET g_lti.ltipos = '2'
          ELSE
             LET g_lti.ltipos = '1'
          END IF
       ELSE
         LET g_lti.ltipos = l_ltipos
       END IF
     
       UPDATE lti_file SET ltipos = g_lti.ltipos
        WHERE lti06 = g_lti.lti06                             
          AND lti07 = g_lti.lti07                             
          AND lti08 = g_lti.lti08                             
          AND ltiplant = g_lti.ltiplant                       
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","lti_file",g_lti.lti01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       DISPLAY BY NAME g_lti.ltipos
    END IF
    CALL t555_delall('upd_del1_chk')
END FUNCTION

FUNCTION t555_ltj02(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_obaacti       LIKE oba_file.obaacti
DEFINE   l_imaacti       LIKE ima_file.imaacti
DEFINE   l_tqa03         LIKE tqa_file.tqa03
DEFINE   l_lpf05         LIKE lpc_file.lpcacti    
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_tqa02         LIKE tqa_file.tqa02
DEFINE   l_lpf02         LIKE lpc_file.lpc02   
DEFINE   l_oba02         LIKE oba_file.oba02   

    LET g_errno =''
    CASE g_lti.lti02
       WHEN "1"
          SELECT lpcacti,lpc02 INTO l_lpf05,l_lpf02 FROM lpC_file  
           WHERE lpc01 = g_ltj[l_ac].ltj02       
             AND lpc00 = '6'                     
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_lpf02 = NULL
               WHEN l_lpf05 !='Y'       LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_ltj[l_ac].ltj02_1=l_lpf02
             DISPLAY BY NAME g_ltj[l_ac].ltj02_1
          END IF 
       WHEN "2"
          IF g_argv1 = '3' THEN
             SELECT lpcacti,lpc02 INTO l_lpf05,l_lpf02 FROM lpC_file
              WHERE lpc01 = g_ltj[l_ac].ltj02
                AND lpc00 = '7'
             CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                         LET l_lpf02 = NULL
                  WHEN l_lpf05 !='Y'     LET g_errno='9028'
                  OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
             END CASE
          ELSE
             SELECT obaacti,oba02 INTO l_obaacti,l_oba02
               FROM oba_file
              WHERE oba01=g_ltj[l_ac].ltj02
             CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                         LET l_oba02 = NULL
                  WHEN l_obaacti !='Y'   LET g_errno='9028'
                  OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
             END CASE 
          END IF             
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             IF g_argv1 = '3' THEN
                LET g_ltj[l_ac].ltj02_1=l_lpf02
             ELSE
                LET g_ltj[l_ac].ltj02_1=l_oba02
             END IF
             DISPLAY BY NAME g_ltj[l_ac].ltj02_1
          END IF           	                         
       WHEN "3"
          SELECT tqa03,tqa02 INTO l_tqa03,l_tqa02 FROM tqa_file 
          WHERE tqa01=g_ltj[l_ac].ltj02 AND tqa03='2'
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_tqa02 = NULL
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_ltj[l_ac].ltj02_1=l_tqa02
             DISPLAY BY NAME g_ltj[l_ac].ltj02_1
          END IF                                      
       WHEN "4"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file 
          WHERE ima01=g_ltj[l_ac].ltj02
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_ltj[l_ac].ltj02_1=l_ima02
             DISPLAY BY NAME g_ltj[l_ac].ltj02_1
          END IF                
    END CASE                   

END FUNCTION 

FUNCTION t555_delall(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr10
   DEFINE l_lti06    LIKE lti_file.lti06,
          l_lti07    LIKE lti_file.lti07,
          l_lti08    LIKE lti_file.lti08,
          l_ltiplant LIKE lti_file.ltiplant
   DEFINE l_ltj_cnt  LIKE type_file.num5,
          l_ltk_cnt  LIKE type_file.num5 

   #p_cmd = change_ins    新增變更單時,單頭變換單號時檢查
   #p_cmd = ins_chk       新增變更單時,單頭輸入完畢後檢查
   #p_cmd = del           刪除變更單時檢查
   #p_cmd = upd_del1_ins  第一單身新增修改欄位後檢查
   #p_cmd = upd_del1_chk  第一單身輸入資料完畢後檢查
   #p_cmd = upd_del2_ins  第二單身新增修改欄位後檢查
   #p_cmd = upd_del2_chk  第二單身輸入資料完畢後檢查

   IF p_cmd = 'change_ins' THEN
      LET l_lti06    = g_lti_t.lti06
      LET l_lti07    = g_lti_t.lti07
      LET l_lti08    = g_lti_t.lti08
      LET l_ltiplant = g_lti_t.ltiplant
   ELSE
      LET l_lti06    = g_lti.lti06
      LET l_lti07    = g_lti.lti07
      LET l_lti08    = g_lti.lti08
      LET l_ltiplant = g_lti.ltiplant      
   END IF

   SELECT COUNT(*) INTO l_ltj_cnt FROM ltj_file          
    WHERE ltj12    = l_lti06        
      AND ltj13    = l_lti07
      AND ltj14    = l_lti08        
      AND ltjplant = l_ltiplant   
   
   SELECT COUNT(*) INTO l_ltk_cnt FROM ltk_file
    WHERE ltk13    = l_lti06
      AND ltk14    = l_lti07
      AND ltk21    = l_lti08
      AND ltkplant = l_ltiplant

   IF p_cmd = 'change_ins' OR p_cmd = 'del' 
      OR (p_cmd = 'ins_chk' AND g_flag2 = 'Y') THEN
      IF l_ltj_cnt > 0 THEN
         DELETE FROM ltj_file 
               WHERE ltj12    = l_lti06 
                 AND ltj13    = l_lti07 
                 AND ltj14    = l_lti08 
                 AND ltjplant = l_ltiplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("DELETE ","ltj_file",l_lti07,"",SQLCA.sqlcode,"","ltj",1)
         END IF
         LET l_ltj_cnt = 0
      END IF

      IF l_ltk_cnt > 0 THEN
         DELETE FROM ltk_file
               WHERE ltk13    = l_lti06 
                 AND ltk14    = l_lti07 
                 AND ltk21    = l_lti08 
                 AND ltkplant = l_ltiplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("DELETE ","ltk_file",l_lti07,"",SQLCA.sqlcode,"","ltj",1)
         END IF
         LET l_ltk_cnt = 0
      END IF
   END IF
   
   IF l_ltj_cnt =0 AND l_ltk_cnt = 0 THEN                #第一單身及第二單身都沒有資料時刪除單頭 
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
  
      DELETE FROM ltl_file
            WHERE ltl05    = l_lti06
              AND ltl06    = l_lti07
              AND ltl07    = l_lti08
              AND ltlplant = l_ltiplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("DELETE ","ltl_file",l_lti07,"",SQLCA.sqlcode,"","ltj",1)
      END IF      

      DELETE FROM ltn_file
            WHERE ltn01    = l_lti06
              AND ltn02    = l_lti07
              AND ltn08    = l_lti08
              AND ltnplant = l_ltiplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("DELETE ","ltn_file",l_lti07,"",SQLCA.sqlcode,"","ltj",1)
      END IF

      DELETE FROM lti_file
            WHERE lti06    = l_lti06             
              AND lti07    = l_lti07          
              AND lti08    = l_lti08        
              AND ltiplant = l_ltiplant  
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("DELETE ","lti_file",l_lti07,"",SQLCA.sqlcode,"","ltj",1)
      END IF

      CLEAR FORM 
      INITIALIZE g_lti.* TO NULL  
      LET g_flag2 = 'N'
      COMMIT WORK
   END IF
END FUNCTION

FUNCTION t555_b1()
DEFINE  l_ac1_t          LIKE type_file.num5,  
        l_n,l_n1,l_n2   LIKE type_file.num5, 
        l_cnt           LIKE type_file.num5,
        l_lock_sw       LIKE type_file.chr1,
        p_cmd           LIKE type_file.chr1,
        l_allow_insert  LIKE type_file.num5,
        l_allow_delete  LIKE type_file.num5,
        l_ltipos        LIKE lti_file.ltipos,
        l_pos_str       LIKE type_file.chr1 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lti.lti01 IS NULL THEN
       RETURN
    END IF
 
    IF g_lti.lticonf = 'Y' THEN   #已確認時不允許修改
       CALL cl_err('','alm-027',0)
       RETURN
    END IF

    IF g_aza.aza88 = 'Y' THEN
       BEGIN WORK
       OPEN t555_cl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant            
       IF STATUS THEN
          CALL cl_err("OPEN t555_cl:", STATUS, 1)
          CLOSE t555_cl
          ROLLBACK WORK
          RETURN
       END IF

       FETCH t555_cl INTO g_lti.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)
          CLOSE t555_cl
          ROLLBACK WORK
          RETURN
       END IF
       LET l_pos_str = 'N'
       LET l_ltipos = g_lti.ltipos
       UPDATE lti_file SET ltipos = '4'
        WHERE lti06 = g_lti.lti06                             
          AND lti07 = g_lti.lti07                             
          AND lti08 = g_lti.lti08                             
          AND ltiplant = g_lti.ltiplant                       
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","lti_file",g_lti.lti01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       LET g_lti.ltipos = '4'
       DISPLAY BY NAME g_lti.ltipos
       COMMIT WORK  
    END IF

    LET g_forupd_sql = "SELECT ltk05,'',ltk06,ltk11,ltk12,ltk15,ltk16,ltk17,ltk18,ltk19,ltk20,ltk07,ltk08,ltk09,ltk10,ltkacti ",
                       "  FROM ltk_file",
                       " WHERE ltk13=? AND ltk14=? AND ltkplant = ? AND ltk05 = ? AND ltk21 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t555_bcl_1 CURSOR FROM g_forupd_sql      
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
 
    INPUT ARRAY g_ltk WITHOUT DEFAULTS FROM s_ltk.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
  
           IF g_lti.lticonf = 'Y' THEN
              CALL cl_err('','1208',0)
              RETURN
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t555_cl USING g_lti.lti06,g_lti.lti07,g_lti.lti08,g_lti.ltiplant            
           IF STATUS THEN
              CALL cl_err("OPEN t555_cl:", STATUS, 1)
              CLOSE t555_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t555_cl INTO g_lti.*     
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)   
              CLOSE t555_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
               IF g_aza.aza88 = 'Y' THEN
                  IF l_ltipos <> '1' THEN
                     CALL cl_set_comp_entry("ltk05",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("ltk05",TRUE)
                  END IF
               END IF
              LET g_ltk_t.* = g_ltk[l_ac1].*
              OPEN t555_bcl_1 USING g_lti.lti06,g_lti.lti07,g_lti.ltiplant,g_ltk_t.ltk05,g_lti.lti08            
              IF STATUS THEN
                 CALL cl_err("OPEN t555_bcl_1:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t555_bcl_1 INTO g_ltk[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lti.lti02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                    CALL t555_ltk05('d')
                    IF NOT cl_null(g_ltk[l_ac1].ltk06) THEN
                       IF g_ltk[l_ac1].ltk06 <> '3' THEN
                          LET g_ltk[l_ac1].ltk11 = ''
                          LET g_ltk[l_ac1].ltk12 = ''
                          CALL cl_set_comp_entry('ltk11,ltk12',FALSE)
                          CALL cl_set_comp_required('ltk11,ltk12',FALSE)
                       ELSE
                          CALL cl_set_comp_entry('ltk11,ltk12',TRUE)
                          CALL cl_set_comp_required('ltk11,ltk12',TRUE)
                       END IF

                       IF g_ltk[l_ac1].ltk06 = '4' THEN
                          CALL cl_set_comp_entry('ltk15,ltk16,ltk17,ltk18,ltk19,ltk20',TRUE)
                          CALL cl_set_comp_required('ltk15,ltk16,ltk17,ltk18',TRUE)
                       ELSE
                          LET g_ltk[l_ac1].ltk15 = null
                          LET g_ltk[l_ac1].ltk16 = null
                          LET g_ltk[l_ac1].ltk17 = null
                          LET g_ltk[l_ac1].ltk18 = null
                          LET g_ltk[l_ac1].ltk19 = null
                          LET g_ltk[l_ac1].ltk20 = null
                          CALL cl_set_comp_entry('ltk15,ltk16,ltk17,ltk18,ltk19,ltk20',FALSE)
                          CALL cl_set_comp_required('ltk15,ltk16,ltk17,ltk18',FALSE)
                       END IF
                    END IF
                 END IF
              END IF
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           CALL cl_set_comp_entry("ltk05",TRUE)     
           LET l_n = ARR_COUNT()
           INITIALIZE g_ltk[l_ac1].* TO NULL      
           IF g_lti00 = '1' THEN
              LET g_ltk[l_ac1].ltk10 = 0
           ELSE
              LET g_ltk[l_ac1].ltk07 = 0
              LET g_ltk[l_ac1].ltk08 = 0
              LET g_ltk[l_ac1].ltk09 = 0
           END IF  
           LET g_ltk[l_ac1].ltkacti = 'Y'        
           LET g_ltk[l_ac1].ltk17 = '00:00:00'   
           LET g_ltk[l_ac1].ltk18 = '23:59:59'   
           LET g_ltk_t.* = g_ltk[l_ac1].*    
           NEXT FIELD ltk05
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           IF cl_null(g_ltk[l_ac1].ltk20) THEN
              LET g_ltk[l_ac1].ltk20 = ' '
           END IF 

           INSERT INTO ltk_file(ltk01,ltk02,ltk03,ltk04,ltk05,ltk06,ltk07,
                                ltk08,ltk09,ltk10,ltk11,ltk12,ltkacti,
                                ltkdate,ltkgrup,ltkmodu,ltkorig,ltkoriu,ltkuser,                              
                                ltk13,ltk14,ltk15,ltk16,ltk17,ltk18,ltk19,ltk20,ltk21,ltklegal,ltkplant)            
           VALUES(g_lti.lti00,g_lti.lti01,g_lti.lti04,g_lti.lti05,g_ltk[l_ac1].ltk05,
                  g_ltk[l_ac1].ltk06,g_ltk[l_ac1].ltk07,
                  g_ltk[l_ac1].ltk08,g_ltk[l_ac1].ltk09,
                  g_ltk[l_ac1].ltk10,g_ltk[l_ac1].ltk11,g_ltk[l_ac1].ltk12,g_ltk[l_ac1].ltkacti,
                  g_today,g_grup,g_user,g_grup,g_user,g_user,                                               
                  g_lti.lti06,g_lti.lti07,g_ltk[l_ac1].ltk15,g_ltk[l_ac1].ltk16,g_ltk[l_ac1].ltk17,         
                  g_ltk[l_ac1].ltk18,g_ltk[l_ac1].ltk19,g_ltk[l_ac1].ltk20,g_lti.lti08,g_legal,g_plant                              
                  )
                 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ltk_file",g_lti.lti01,"",SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET l_pos_str = 'Y'
              IF l_ltipos <> '1' THEN
                 LET l_ltipos = '2'
              ELSE
                 LET l_ltipos = '1'
              END IF
              LET g_rec_b1=g_rec_b1+1
              DISPLAY g_rec_b1 TO FORMONLY.cn3
           END IF
                   
        AFTER FIELD ltk05
           IF NOT cl_null(g_ltk[l_ac1].ltk05) THEN
              CALL t555_ltk05(p_cmd)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,0)
                 LET g_ltk[l_ac1].ltk05 = g_ltk_t.ltk05
                 NEXT FIELD ltk05
              END IF 
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltk_t.ltk05 != g_ltk[l_ac1].ltk05) THEN 
                   SELECT COUNT(*) INTO l_n
                     FROM ltk_file
                    WHERE ltk13 = g_lti.lti06
                      AND ltk14 = g_lti.lti07
                      AND ltk21 = g_lti.lti08
                      AND ltkplant = g_lti.ltiplant
                      AND ltk05 = g_ltk[l_ac1].ltk05
                   IF l_n>0 THEN
                      CALL cl_err('','-239',1)
                      LET g_ltk[l_ac1].ltk05 = g_ltk_t.ltk05
                      DISPLAY '' TO ltk05_desc 
                      NEXT FIELD ltk05
                   END IF
              END IF 
           END IF  
 
        AFTER FIELD ltk06
          IF NOT cl_null(g_ltk[l_ac1].ltk06) THEN
             IF g_ltk[l_ac1].ltk06 <> '3' THEN
                LET g_ltk[l_ac1].ltk11 = ''
                LET g_ltk[l_ac1].ltk12 = ''
                CALL cl_set_comp_entry('ltk11,ltk12',FALSE) 
                CALL cl_set_comp_required('ltk11,ltk12',FALSE)
             ELSE 
                CALL cl_set_comp_entry('ltk11,ltk12',TRUE)
                CALL cl_set_comp_required('ltk11,ltk12',TRUE)
             END IF 
             IF g_ltk[l_ac1].ltk06 = '4' THEN
                CALL cl_set_comp_required('ltk15,ltk16.ltk17,ltk18',TRUE)
             ELSE
                CALL cl_set_comp_required('ltk15,ltk16.ltk17,ltk18',FALSE)
             END IF
          END IF

        ON CHANGE ltk06
          IF NOT cl_null(g_ltk[l_ac1].ltk06) THEN
             IF g_ltk[l_ac1].ltk06 <> '3' THEN
                LET g_ltk[l_ac1].ltk11 = ''
                LET g_ltk[l_ac1].ltk12 = ''
                CALL cl_set_comp_entry('ltk11,ltk12',FALSE) 
                CALL cl_set_comp_required('ltk11,ltk12',FALSE)
             ELSE
                CALL cl_set_comp_entry('ltk11,ltk12',TRUE)
                CALL cl_set_comp_required('ltk11,ltk12',TRUE)
             END IF

             IF g_ltk[l_ac1].ltk06 = '4' THEN
                CALL cl_set_comp_entry('ltk15,ltk16,ltk17,ltk18,ltk19,ltk20',TRUE)
                CALL cl_set_comp_required('ltk15,ltk16,ltk17,ltk18',TRUE)
             ELSE
                LET g_ltk[l_ac1].ltk15 = null
                LET g_ltk[l_ac1].ltk16 = null
                LET g_ltk[l_ac1].ltk17 = null
                LET g_ltk[l_ac1].ltk18 = null
                LET g_ltk[l_ac1].ltk19 = null
                LET g_ltk[l_ac1].ltk20 = null
                CALL cl_set_comp_entry('ltk15,ltk16,ltk17,ltk18,ltk19,ltk20',FALSE)
                CALL cl_set_comp_required('ltk15,ltk16,ltk17,ltk18',FALSE)
             END IF
          END IF


        AFTER FIELD ltk11
          IF NOT cl_null(g_ltk[l_ac1].ltk06) AND g_ltk[l_ac1].ltk06 = '3'      
              AND NOT cl_null(g_ltk[l_ac1].ltk11) THEN
             IF g_ltk[l_ac1].ltk11 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD ltk11
             END IF   
          END IF

        AFTER FIELD ltk12
          IF NOT cl_null(g_ltk[l_ac1].ltk06) AND g_ltk[l_ac1].ltk06 = '3'       
              AND NOT cl_null(g_ltk[l_ac1].ltk12) THEN
             IF g_ltk[l_ac1].ltk12 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD ltk12
             END IF
          END IF
  
        AFTER FIELD ltk15
           IF NOT cl_null(g_ltk[l_ac1].ltk15) THEN
              IF g_ltk[l_ac1].ltk15 < g_lti.lti04 THEN
                 CALL cl_err('','alm-h53',0)
                 NEXT FIELD ltk15
              END IF
      
              IF g_ltk[l_ac1].ltk15 > g_lti.lti05 THEN
                 CALL cl_err('','alm-h53',0)
                 NEXT FIELD ltk15
              END IF
           END IF

        AFTER FIELD ltk16
           IF NOT cl_null(g_ltk[l_ac1].ltk16) THEN
              IF g_ltk[l_ac1].ltk16 < g_lti.lti04 THEN
                 CALL cl_err('','alm-h54',0)
                 NEXT FIELD ltk16
              END IF

              IF g_ltk[l_ac1].ltk16 > g_lti.lti05 THEN
                 CALL cl_err('','alm-h54',0)
                 NEXT FIELD ltk16
              END IF
           END IF

        AFTER FIELD ltk07
          IF NOT cl_null(g_ltk[l_ac1].ltk07) THEN
             IF g_ltk[l_ac1].ltk07 <= 0 THEN
                CALL cl_err('','alm1488',0)
                LET g_ltk[l_ac1].ltk07 = g_ltk_t.ltk07
                NEXT FIELD ltk07
             END IF 
          END IF 


        AFTER FIELD ltk08
          IF NOT cl_null(g_ltk[l_ac1].ltk08) THEN
             IF g_ltk[l_ac1].ltk08 <= 0 THEN
                CALL cl_err('','alm1489',0)
                LET g_ltk[l_ac1].ltk08 = g_ltk_t.ltk08
                NEXT FIELD ltk08
             END IF
          END IF

        AFTER FIELD ltk09
          IF NOT cl_null(g_ltk[l_ac1].ltk09) THEN
             IF g_ltk[l_ac1].ltk09 < 0 THEN
                CALL cl_err('','alm1490',0)
                LET g_ltk[l_ac1].ltk09 = g_ltk_t.ltk09
                NEXT FIELD ltk09
             END IF
          END IF  

        AFTER FIELD ltk10
           IF NOT cl_null(g_ltk[l_ac1].ltk10) THEN
              IF g_ltk[l_ac1].ltk10 < 1 OR g_ltk[l_ac1].ltk10 > 100 THEN
                  CALL cl_err('','alm1491',0)
                  LET g_ltk[l_ac1].ltk10 = g_ltk_t.ltk10
                  NEXT FIELD ltk10
              END IF 
           END IF 
        BEFORE DELETE    
           IF NOT cl_null(g_ltk_t.ltk05) THEN
              IF g_aza.aza88 = 'Y' THEN
                 IF l_ltipos = '1' OR (l_ltipos = '3' AND g_ltk_t.ltkacti = 'N') THEN
                 ELSE
                    CALL cl_err('','apc-155',0)
                    CANCEL DELETE
                 END IF
              END IF
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ltk_file
               WHERE ltk13 = g_lti.lti06         
                 AND ltk14 = g_lti.lti07 
                 AND ltk21 = g_lti.lti08        
                 AND ltkplant = g_lti.ltiplant       
                 AND ltk05 = g_ltk_t.ltk05           
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ltk_file","","",SQLCA.sqlcode,"","",1)   
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn3
           END IF
           COMMIT WORK
 
        AFTER FIELD ltk20
           IF cl_null(g_ltk[l_ac1].ltk20) THEN
              LET g_ltk[l_ac1].ltk20 = ' '
           END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ltk[l_ac1].* = g_ltk_t.*
              CLOSE t555_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ltk[l_ac1].ltk05,-263,1)
              LET g_ltk[l_ac1].* = g_ltk_t.*
           ELSE
              IF cl_null(g_ltk[l_ac1].ltk20) THEN
                 LET g_ltk[l_ac1].ltk20 = ' ' 
              END IF

              UPDATE ltk_file SET ltk05=g_ltk[l_ac1].ltk05, 
                                  ltk06=g_ltk[l_ac1].ltk06,
                                  ltk07=g_ltk[l_ac1].ltk07,
                                  ltk08=g_ltk[l_ac1].ltk08,
                                  ltk09=g_ltk[l_ac1].ltk09, 
                                  ltk10=g_ltk[l_ac1].ltk10,
                                  ltk11=g_ltk[l_ac1].ltk11,          
                                  ltk12=g_ltk[l_ac1].ltk12,         
                                  ltkacti = g_ltk[l_ac1].ltkacti,    
                                  ltk15=g_ltk[l_ac1].ltk15,          
                                  ltk16=g_ltk[l_ac1].ltk16,          
                                  ltk17=g_ltk[l_ac1].ltk17,          
                                  ltk18=g_ltk[l_ac1].ltk18,          
                                  ltk19=g_ltk[l_ac1].ltk19,          
                                  ltk20=g_ltk[l_ac1].ltk20           
               WHERE ltk13 = g_lti_t.lti06       
                 AND ltk14 = g_lti_t.lti07
                 AND ltk21 = g_lti_t.lti08     
                 AND ltkplant = g_lti_t.ltiplant    
                 AND ltk05 = g_ltk_t.ltk05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ltk_file",g_lti.lti01,"",SQLCA.sqlcode,"","",1)  
                 LET g_ltk[l_ac1].* = g_ltk_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 LET l_pos_str = 'Y'
                 IF l_ltipos <> '1' THEN
                    LET l_ltipos = '2'
                 ELSE
                    LET l_ltipos = '1'
                 END IF
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ltk[l_ac1].* = g_ltk_t.*
                 CALL t555_delall('upd_del2')    
              END IF
              CLOSE t555_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t555_bcl_1
           COMMIT WORK
 
        ON ACTION CONTROLO     
           IF INFIELD(ltk02) AND l_ac1 > 1 THEN
              LET g_ltk[l_ac1].* = g_ltk[l_ac1-1].*
              LET g_ltk[l_ac1].ltk05 = g_rec_b1 + 1
              NEXT FIELD ltk05
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ltk05)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpc01_1" 
                 LET g_qryparam.arg1 = '8'  
                 LET g_qryparam.where = " lpcacti = 'Y' "
                 LET g_qryparam.default1 = g_ltk[l_ac1].ltk05
                 CALL cl_create_qry() RETURNING g_ltk[l_ac1].ltk05
                 DISPLAY BY NAME g_ltk[l_ac1].ltk05
                 CALL t555_ltk05('d')
                 NEXT FIELD ltk05
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
    CLOSE t555_bcl_1
    COMMIT WORK
    IF g_aza.aza88 = 'Y' THEN
       IF l_pos_str = 'Y' THEN
          IF l_ltipos <> '1' THEN
             LET g_lti.ltipos = '2'
          ELSE
             LET g_lti.ltipos = '1'
          END IF
       ELSE
         LET g_lti.ltipos = l_ltipos
       END IF  
 
       UPDATE lti_file SET ltipos = l_ltipos
        WHERE lti06 = g_lti.lti06
          AND lti07 = g_lti.lti07
          AND lti08 = g_lti.lti08           
          AND ltiplant = g_lti.ltiplant          
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","lti_file",g_lti.lti01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF

       DISPLAY BY NAME g_lti.ltipos          
    END IF 

END FUNCTION

FUNCTION t555_ltk05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_lpcacti LIKE lpc_file.lpcacti
   DEFINE l_lpc02   LIKE lpc_file.lpc02
   LET g_errno = '' 
   SELECT lpc02,lpcacti INTO l_lpc02,l_lpcacti
     FROM lpc_file 
    WHERE lpc01 = g_ltk[l_ac1].ltk05
      AND lpc00 = '8'
   CASE
      WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm1484' 
                              LET l_lpc02 = ''
      WHEN l_lpcacti <> 'Y'   LET g_errno = 'alm1485'
                              LET l_lpc02 = ''
      OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'   
   END CASE   
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_ltk[l_ac1].ltk05_desc = l_lpc02
   END IF    
END FUNCTION 

FUNCTION t555_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000
DEFINE  l_m      LIKE type_file.chr1000
DEFINE  i        LIKE type_file.num5
DEFINE  l_n      LIKE type_file.num5

   LET g_sql = "SELECT ltj02,'',ltj03,ltj04,ltj05,ltj06,ltj07,ltj08,ltj09,ltjacti",
               "  FROM ltj_file",
               " WHERE ltj12 = '", g_lti.lti06,"' ",
               "   AND ltj13 = '", g_lti.lti07,"' ",
               "   AND ltj14 = '", g_lti.lti08,"' ",
               "   AND ltjplant = '",g_lti.ltiplant,"' ", 
               "   AND ltj00= '",g_lti00,"'"               

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltj02 "

   DISPLAY g_sql

   PREPARE t555_pb FROM g_sql
   DECLARE ltj_cs CURSOR FOR t555_pb

   CALL g_ltj.clear()
   LET g_cnt = 1

   FOREACH ltj_cs INTO g_ltj[g_cnt].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE g_lti.lti02
          WHEN "1"
             SELECT lpc02 INTO g_ltj[g_cnt].ltj02_1 FROM lpc_file
              WHERE lpc01 = g_ltj[g_cnt].ltj02
                AND lpc00 = '6'
          WHEN "2"
             IF g_argv1 = '3' THEN
                SELECT lpc02 INTO g_ltj[g_cnt].ltj02_1 FROM lpc_file
                 WHERE lpc01 = g_ltj[g_cnt].ltj02
                   AND lpc00 = '7'
             ELSE
                SELECT oba02 INTO g_ltj[g_cnt].ltj02_1 FROM oba_file
                 WHERE oba01=g_ltj[g_cnt].ltj02
             END IF 
          WHEN "3"
             SELECT tqa02 INTO g_ltj[g_cnt].ltj02_1 FROM tqa_file
              WHERE tqa01=g_ltj[g_cnt].ltj02
                AND tqa03='2'         
          WHEN "4"
             SELECT ima02 INTO g_ltj[g_cnt].ltj02_1 FROM ima_file
              WHERE ima01=g_ltj[g_cnt].ltj02    
       END CASE 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ltj.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t555_b1_fill(p_wc2) 
DEFINE p_wc2   STRING

   LET g_sql = "SELECT ltk05,'',ltk06,ltk11,ltk12,ltk15,ltk16,ltk17,ltk18,ltk19,ltk20,ltk07,ltk08,ltk09,ltk10,ltkacti ", 
               "  FROM ltk_file",
               " WHERE ltk13 = '",g_lti.lti06,"' ",                            
               "   AND ltk14 = '",g_lti.lti07,"' ", 
               "   AND ltk21 = '",g_lti.lti08,"' ",                                
               "   AND ltkplant = '",g_lti.ltiplant,"' ",                      
               "   AND ltk01 = '",g_lti00,"' "                                       

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltk05 "

   DISPLAY g_sql

   PREPARE t555_pb_1 FROM g_sql
   DECLARE ltk_cs CURSOR FOR t555_pb_1

   CALL g_ltk.clear()
   LET g_cnt = 1

   FOREACH ltk_cs INTO g_ltk[g_cnt].*   
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT lpc02 INTO g_ltk[g_cnt].ltk05_desc FROM lpc_file
        WHERE lpc01 = g_ltk[g_cnt].ltk05
          AND lpc00 = '8'
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ltk.deleteElement(g_cnt)

   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0 
END FUNCTION 

FUNCTION t555_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lti01,lti04,lti05,lti07,lti11",TRUE)    
    END IF
END FUNCTION

FUNCTION t555_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lti00,lti07",FALSE)       
    END IF

   IF g_aza.aza88 = 'Y' AND p_cmd = 'u' THEN
      IF g_ltipos <> '1' THEN
         CALL cl_set_comp_entry("lti00,lti07",FALSE)               
      END IF 
   END IF

END FUNCTION

FUNCTION t555_exclude_detail()
   CALL t555_msg('exc_detail')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   CALL t555_sub1(g_lti.lti06,g_lti.lti07,g_lti.lti08,g_plant)

    SELECT ltipos INTO g_lti.ltipos FROM lti_file
     WHERE lti00=g_lti00
       AND lti01=g_lti.lti01
       AND lti04=g_lti.lti04 
       AND lti05=g_lti.lti05 
    DISPLAY BY NAME g_lti.ltipos
END FUNCTION 

FUNCTION t555_msg(p_cmd)
   DEFINE p_cmd LIKE type_file.chr30
   
   IF cl_null(g_lti.lti07) THEN
      LET g_errno = '-400'          #請先選取欲處理的資料
      RETURN
   END IF

   IF p_cmd <> 'eff_plant' AND p_cmd <> 'exc_detail' THEN
      IF g_lti.lti06 <> g_plant THEN
         LET g_errno = 'art-977'       #目前鎖在營運中心不是制定營運中心,不可修改
         RETURN
      END IF

      IF g_lti.lti09 = 'Y' THEN
         LET g_errno = 'alm-h55'       #F已發佈,不可修改
         RETURN
      END IF
   END IF

   IF p_cmd = 'exc_detail' THEN
       IF g_lti.lti03='1' THEN
         LET g_errno = 'alm-811'
         RETURN
      END IF
   END IF


   IF p_cmd = 'conf' THEN
      IF g_lti.lticonf ='Y' THEN    #已確認
         LET g_errno = '1208'
         RETURN
      END IF
   END IF

   IF p_cmd = 'mod' THEN
      IF g_lti.lticonf = 'Y' THEN   #已確認時不允許修改
         LET g_errno = 'alm-027'
         RETURN
      END IF
   END IF    
   
   LET g_errno = NULL
END FUNCTION

FUNCTION t555_conf()
   DEFINE l_ltn04 LIKE ltn_file.ltn04,
          l_ltn07 LIKE ltn_file.ltn07
   DEFINE l_azw02                             LIKE azw_file.azw02
   DEFINE l_sql                               STRING
   DEFINE l_lti    RECORD                     LIKE lti_file.*,
          l_ltj    DYNAMIC ARRAY OF RECORD    LIKE ltj_file.*,
          l_ltk    DYNAMIC ARRAY OF RECORD    LIKE ltk_file.*,
          l_ltl    DYNAMIC ARRAY OF RECORD    LIKE ltl_file.*,
          l_ltn    DYNAMIC ARRAY OF RECORD    LIKE ltn_file.* 
          
   DEFINE l_cnt                               LIKE type_file.num5
   DEFINE l_max_rec                           LIKE type_file.num5
   DEFINE l_rec                               LIKE type_file.num5
   
   CALL t555_msg('conf')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
 
   IF NOT cl_null(g_lti.lti03) AND g_lti.lti03 <> '1' THEN
      SELECT COUNT(*) INTO l_cnt FROM ltl_file
       WHERE ltl05 = g_lti.lti06
         AND ltl06 = g_lti.lti07
         AND ltl07 = g_lti.lti08
         AND ltlplant = g_lti.ltiplant

      IF l_cnt = 0 THEN
         CALL cl_err('','alm-h68',0)
         RETURN
      END IF
   END IF
  
   SELECT COUNT(*) INTO l_cnt FROM ltn_file
    WHERE ltn01 = g_lti.lti06
      AND ltn02 = g_lti.lti07
      AND ltn03 = g_lti.lti00
      AND ltn08 = g_lti.lti08
      AND ltnplant = g_lti.ltiplant

   IF l_cnt = 0 THEN
      CALL cl_err('','art-546',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM ltn_file
    WHERE ltn01 = g_lti.lti06
      AND ltn02 = g_lti.lti07
      AND ltn03 = g_lti.lti00
      AND ltn04 = g_lti.ltiplant
      AND ltn08 = g_lti.lti08
      AND ltnplant = g_lti.ltiplant    

   IF l_cnt = 0 THEN
      CALL cl_err('','alm-h42',0)
      RETURN
   END IF  

   CALL t555_ckmult()   
    IF g_success = 'N' THEN RETURN END IF

   IF NOT cl_confirm('axm-108') THEN RETURN END IF

   SELECT COUNT(*) INTO l_cnt FROM ltn_file
    WHERE ltn01 = g_lti.lti06
      AND ltn02 = g_lti.lti07
      AND ltn03 = g_lti.lti00
      AND ltn08 = g_lti.lti08
      AND ltn04 NOT IN (SELECT lnk03 FROM lnk_file
                         WHERE lnk01 = g_lti.lti01
                           AND lnk05 = 'Y' )

   IF l_cnt > 0 THEN
      CALL cl_err('','alm-h61',0)
      RETURN
   END IF

   LET g_action_choice = ""
   LET g_success = 'Y'

   UPDATE lti_file
      SET lticond = g_today,
          lticonf = 'Y',
          lticonu = g_user,
          ltiuser = g_user,
          ltidate = g_today,
          ltimodu = g_user,
          lti09   = 'Y',
          lti10   = g_today
    WHERE lti06 = g_lti.lti06 AND lti07 = g_lti.lti07
      AND lti08 = g_lti.lti08 AND ltiplant = g_plant

   IF SQLCA.sqlcode THEN
       LET g_success = 'N'
      CALL cl_err3("upd","lti_file",g_lti.lti07,"",SQLCA.sqlcode,"","lti06",1)
      ROLLBACK WORK
   END IF

   IF g_success = 'Y' THEN  #依變更生效營運中心清單將變更單複製到各營運中心下,並回寫至規則單
      LET l_sql = "SELECT ltn04,ltn07 FROM ltn_file WHERE ltn01 = '",g_lti.lti06 CLIPPED,"' ",
                 "    AND ltn02 = '",g_lti.lti07 CLIPPED,"' " ,
                 "    AND ltn08 =  ",g_lti.lti08 CLIPPED,"  ",
                 "    AND ltnplant = '",g_lti.ltiplant,"' "

      PREPARE ltl_pre1 FROM l_sql
      DECLARE ltl_cs1 CURSOR FOR ltl_pre1
      FOREACH ltl_cs1 INTO l_ltn04,l_ltn07
         IF cl_null(l_ltn04) THEN
            CONTINUE FOREACH
         END IF
         DISPLAY 'Effective Plant(Y/N): ',l_ltn04,' (',l_ltn07,') '
         SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = l_ltn04    

         SELECT * INTO l_lti.* FROM lti_file WHERE lti06 = g_lti.lti06 AND lti07 = g_lti.lti07
                                               AND lti08 = g_lti.lti08 AND ltiplant = g_lti.ltiplant

         LET l_lti.ltiacti  = l_ltn07
         LET l_lti.ltilegal = l_azw02
         LET l_lti.ltiplant = l_ltn04

         #積分/折扣規則變更單頭檔
         IF g_success = 'Y' THEN
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'lrp_file'),
                        " WHERE lrp06 = '",l_lti.lti06,"' ",
                        "   AND lrp07 = '",l_lti.lti07,"' ",
                        "   AND lrp08 =  ",g_lti08_o,
                        "   AND lrpplant ='",l_lti.ltiplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_lrp FROM l_sql
            EXECUTE trans_del_lrp
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE lrp_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delete lrp_file Where lrp07 = ',l_lti.lti07
            END IF
         END IF

         IF g_success = 'Y' AND g_lti.ltiplant <> l_ltn04 THEN   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lti_file'),    
                        "      (lti00,lti01,lti02,lti03,lti04,lti05,lti06,lti07,lti08,lti09,lti10,",
                        "       lti11,ltiacti,lticond,lticonf,lticonu,lticrat,ltidate,ltigrup,ltilegal,",
                        "       ltimodu,ltiorig,ltioriu,ltiplant,ltipos,ltiuser)",
                        "      VALUES('",l_lti.lti00,"','",l_lti.lti01,"','",l_lti.lti02,"','",l_lti.lti03,"','",l_lti.lti04,"','",l_lti.lti05,"', ",
                        "             '",l_lti.lti06,"','",l_lti.lti07,"', ",l_lti.lti08," ,'",l_lti.lti09,"','",l_lti.lti10,"',",
                        "             '",l_lti.lti11,"','",l_lti.ltiacti,"','",l_lti.lticond,"','",l_lti.lticonf,"','",l_lti.lticonu,"',",
                        "             '",l_lti.lticrat,"','",l_lti.ltidate,"','",l_lti.ltigrup,"','",l_lti.ltilegal,"','",l_lti.ltimodu,"', ",
                        "             '",l_lti.ltiorig,"','",l_lti.ltioriu,"','",l_lti.ltiplant,"','",l_lti.ltipos,"','",l_lti.ltiuser,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql   
            PREPARE trans_ins_lti FROM l_sql
            EXECUTE trans_ins_lti         
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'           
               CALL s_errmsg('','','INSERT INTO lti_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Insert: lti_file: ',l_lti.lti07,' for plant:  ',l_ltn04
            END IF
         END IF

         #第一單身
         IF g_success = 'Y' THEN
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'lrq_file'),
                        " WHERE lrq12 = '",l_lti.lti06,"' ",
                        "   AND lrq13 = '",l_lti.lti07,"' ",
                        "   AND lrqplant ='",l_lti.ltiplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_lrq FROM l_sql
            EXECUTE trans_del_lrq
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE lrq_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delete lrq_file, lrq13 : ',l_lti.lti07
            END IF
         END IF

         IF g_success = 'Y' THEN  
            #寫入積分/折扣/儲值加值規則單頭檔
             LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lrp_file'), 
                        "            (lrp00,lrp01,lrp02,lrp03,lrp04,lrp05,lrppos,lrp06,lrp07,lrp08,lrp09,lrp10,",
                        "             lrp11,lrpacti,lrpcond,lrpconf,lrpconu,lrpcrat,lrpdate,lrpgrup,lrplegal,lrpmodu,",
                        "             lrporig,lrporiu,lrpplant,lrpuser)",  
                        "      VALUES('",l_lti.lti00,"','",l_lti.lti01,"','",l_lti.lti02,"','",l_lti.lti03,"','",l_lti.lti04,"','",l_lti.lti05,"','",l_lti.ltipos,"', ",
                        "             '",l_lti.lti06,"','",l_lti.lti07,"','",l_lti.lti08,"','",l_lti.lti09,"','",l_lti.lti10,"',",
                        "             '",l_lti.lti11,"','",l_lti.ltiacti,"','",l_lti.lticond,"','",l_lti.lticonf,"','",l_lti.lticonu,"',",
                        "             '",l_lti.lticrat,"','",l_lti.ltidate,"','",l_lti.ltigrup,"','",l_lti.ltilegal,"','",l_lti.ltimodu,"', ",
                        "             '",l_lti.ltiorig,"','",l_lti.ltioriu,"','",l_lti.ltiplant,"','",l_lti.ltiuser,"')"

            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql   
            PREPARE trans_ins_lrp FROM l_sql
            EXECUTE trans_ins_lrp
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','INSERT INTO lrp_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Insert: lti_file: ',l_lti.lti07,' for plant:  ',l_ltn04
            END IF
         END IF

         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec FROM ltj_file WHERE ltj12 = g_lti.lti06 AND ltj13 = g_lti.lti07 AND ltj14 = g_lti.lti08 AND ltjplant = g_lti.ltiplant
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(g_lti.ltiplant, 'ltj_file'),  
                        " WHERE ltj12 = '",g_lti.lti06,"' ",
                        "   AND ltj13 = '",g_lti.lti07,"' ",
                        "   AND ltj14 = '",g_lti.lti08,"' ",
                        "   AND ltjplant = '",g_lti.ltiplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql 
            PREPARE ltj_sur FROM l_sql
            DECLARE ltj_ins_sur CURSOR FOR ltj_sur
            FOREACH ltj_ins_sur INTO l_ltj[l_rec].*
               LET l_ltj[l_rec].ltjlegal = l_azw02
               LET l_ltj[l_rec].ltjplant = l_ltn04
               IF cl_null(l_ltj[l_rec].ltj03) THEN LET l_ltj[l_rec].ltj03 = 0   END IF
               IF cl_null(l_ltj[l_rec].ltj04) THEN LET l_ltj[l_rec].ltj04 = 0   END IF
               IF cl_null(l_ltj[l_rec].ltj05) THEN LET l_ltj[l_rec].ltj05 = 100 END IF
               IF cl_null(l_ltj[l_rec].ltj06) THEN LET l_ltj[l_rec].ltj06 = 0   END IF
               IF cl_null(l_ltj[l_rec].ltj07) THEN LET l_ltj[l_rec].ltj07 = 0   END IF
               IF cl_null(l_ltj[l_rec].ltj08) THEN LET l_ltj[l_rec].ltj08 = 100 END IF

               IF g_success = 'Y' AND g_lti.ltiplant <> l_ltn04 THEN   
                  #寫入積分/折扣規則變更單身檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltj_file'),             
                              "      (ltj00,ltj01,ltj02,ltj03,ltj04,ltj05,ltj06,ltj07,ltj08,ltj09,ltj10,",
                              "       ltj11,ltj12,ltj13,ltj14,ltjacti,ltjlegal,ltjplant)",
                              "VALUES('",l_ltj[l_rec].ltj00,"','",l_ltj[l_rec].ltj01,"','",l_ltj[l_rec].ltj02,"', ",l_ltj[l_rec].ltj03,",",l_ltj[l_rec].ltj04,",",l_ltj[l_rec].ltj05,",",
                              "        ",l_ltj[l_rec].ltj06," , ",l_ltj[l_rec].ltj07," , ",l_ltj[l_rec].ltj08," ,'",l_ltj[l_rec].ltj09,"','",l_ltj[l_rec].ltj10,"',",
                              "       '",l_ltj[l_rec].ltj11,"','",l_ltj[l_rec].ltj12,"','",l_ltj[l_rec].ltj13,"',", l_ltj[l_rec].ltj14,",'",l_ltj[l_rec].ltjacti,"','",l_ltj[l_rec].ltjlegal,"','",l_ltj[l_rec].ltjplant,"' )"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql
                  PREPARE trans_ins_ltj2 FROM l_sql
                  EXECUTE trans_ins_ltj2
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'   
                     CALL s_errmsg('','','INSERT INTO ltj_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltj_file: ',l_ltj[l_rec].ltj13,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF g_success = 'Y' THEN  
                  #寫入積分/折扣規則單身檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lrq_file'),
                              "           (lrq00,lrq01,lrq02,lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrq10,",
                              "            lrq11,lrqacti,lrq12,lrq13,lrqlegal,lrqplant)",
                              "VALUES('",l_ltj[l_rec].ltj00,"','",l_ltj[l_rec].ltj01,"','",l_ltj[l_rec].ltj02,"', ",l_ltj[l_rec].ltj03,",",l_ltj[l_rec].ltj04,",",l_ltj[l_rec].ltj05,",",
                              "        ",l_ltj[l_rec].ltj06," , ",l_ltj[l_rec].ltj07," , ",l_ltj[l_rec].ltj08," ,'",l_ltj[l_rec].ltj09,"','",l_ltj[l_rec].ltj10,"',",
                              "       '",l_ltj[l_rec].ltj11,"','",l_ltj[l_rec].ltjacti,"','",l_ltj[l_rec].ltj12,"','",l_ltj[l_rec].ltj13,"','",l_ltj[l_rec].ltjlegal,"','",l_ltj[l_rec].ltjplant,"' )"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql  
                  PREPARE trans_ins_lrq FROM l_sql
                  EXECUTE trans_ins_lrq
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'   
                     CALL s_errmsg('','','INSERT INTO lrq_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: lrq_file: ',l_ltj[l_rec].ltj13,' for plant:  ',l_ltn04
                  END IF
               END IF
               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN   
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF

         #第二單身
         IF g_success = 'Y' THEN
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'lth_file'),
                        " WHERE lth13 = '",l_lti.lti06,"' ",
                        "   AND lth14 = '",l_lti.lti07,"' ",
                        "   AND lthplant ='",l_lti.ltiplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_lth FROM l_sql
            EXECUTE trans_del_lth
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE lth_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delete lth_file, lth13: ',l_lti.lti07
            END IF
         END IF

         IF g_success = 'Y' THEN   
            SELECT COUNT(*) INTO l_max_rec FROM ltk_file WHERE ltk13 = g_lti.lti06 AND ltk14 = g_lti.lti07 AND ltk21 = g_lti.lti08 AND ltkplant = g_lti.ltiplant
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(l_lti.ltiplant, 'ltk_file'),   #FUN-C70003
                        " WHERE ltk13 = '",g_lti.lti06,"' ",
                        "   AND ltk14 = '",g_lti.lti07,"' ",
                        "   AND ltk21 = '",g_lti.lti08,"' ",
                        "   AND ltkplant = '",g_lti.ltiplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql                   
            PREPARE ltk_sur FROM l_sql
            DECLARE ltk_ins_sur CURSOR FOR ltk_sur
            FOREACH ltk_ins_sur INTO l_ltk[l_rec].*
               LET l_ltk[l_rec].ltklegal = l_azw02
               LET l_ltk[l_rec].ltkplant = l_ltn04
               IF cl_null(l_ltk[l_rec].ltk07) THEN LET l_ltk[l_rec].ltk07 = 0    END IF
               IF cl_null(l_ltk[l_rec].ltk08) THEN LET l_ltk[l_rec].ltk08 = 0    END IF
               IF cl_null(l_ltk[l_rec].ltk09) THEN LET l_ltk[l_rec].ltk09 = 0    END IF
               IF cl_null(l_ltk[l_rec].ltk10) THEN LET l_ltk[l_rec].ltk10 = 100  END IF
               IF cl_null(l_ltk[l_rec].ltk11) THEN LET l_ltk[l_rec].ltk11 = 0    END IF
               IF cl_null(l_ltk[l_rec].ltk12) THEN LET l_ltk[l_rec].ltk12 = 0    END IF

               IF g_success = 'Y' AND g_lti.ltiplant <> l_ltn04 THEN   
                  #寫入會員活動日積分回饋/折扣率變更設定檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltk_file'),                     
                              "      (ltk01,ltk02,ltk03,ltk04,ltk05,ltk06,ltk07,ltk08,ltk09,ltk10,",
                              "       ltk11,ltk12,ltk13,ltk14,ltk17,ltk18,ltk19,ltk20,",
                              "       ltk21,ltkacti,ltkdate,ltkgrup,ltklegal,ltkmodu,ltkorig,ltkoriu,ltkplant)",
                              "VALUES('",l_ltk[l_rec].ltk01,"','",l_ltk[l_rec].ltk02,"','",l_ltk[l_rec].ltk03,"','",l_ltk[l_rec].ltk04,"', ",
                              "       '",l_ltk[l_rec].ltk05,"','",l_ltk[l_rec].ltk06,"', ",l_ltk[l_rec].ltk07," , ",l_ltk[l_rec].ltk08," , ",
                              "        ",l_ltk[l_rec].ltk09," , ",l_ltk[l_rec].ltk10," , ",l_ltk[l_rec].ltk11," , ",l_ltk[l_rec].ltk12," , ",
                              "       '",l_ltk[l_rec].ltk13,"','",l_ltk[l_rec].ltk14,"',",
                              "       '",l_ltk[l_rec].ltk17,"','",l_ltk[l_rec].ltk18,"','",l_ltk[l_rec].ltk19,"','",l_ltk[l_rec].ltk20,"', ",
                              "        ",l_ltk[l_rec].ltk21," ,'",l_ltk[l_rec].ltkacti,"','",l_ltk[l_rec].ltkdate,"','",l_ltk[l_rec].ltkgrup,"',",
                              "       '",l_ltk[l_rec].ltklegal,"','",l_ltk[l_rec].ltkmodu,"',",
                              "       '",l_ltk[l_rec].ltkorig,"','",l_ltk[l_rec].ltkoriu,"','",l_ltk[l_rec].ltkplant,"')"


                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql  
                  PREPARE trans_ins_ltk2 FROM l_sql
                  EXECUTE trans_ins_ltk2
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'  
                     CALL s_errmsg('','','INSERT INTO ltk_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltk_file: ',l_ltk[l_rec].ltk14,' for plant:  ',l_ltn04
                  END IF

                  IF NOT cl_null(l_ltk[l_rec].ltk15) THEN
                     LET l_sql = " UPDATE ",cl_get_target_table(l_ltn04, 'ltk_file'),               
                                 "    SET ltk15 = '",l_ltk[l_rec].ltk15 CLIPPED,"'",
                                 "  WHERE ltk13 = '",l_ltk[l_rec].ltk13,"'",
                                 "    AND ltk14 = '",l_ltk[l_rec].ltk14,"'",
                                 "    AND ltk21 = '",l_ltk[l_rec].ltk21,"'",
                                 "    AND ltk05 = '",l_ltk[l_rec].ltk05,"'",
                                 "    AND ltkplant = '",l_ltn04,"'"

                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql              
                     PREPARE trans_upd_ltk15 FROM l_sql
                     EXECUTE trans_upd_ltk15
                     IF SQLCA.sqlcode THEN
                        LET g_success = 'N'                                             
                        CALL s_errmsg('','','UPDATE ltk_file:',SQLCA.sqlcode,1)
                        ROLLBACK WORK
                        EXIT FOREACH
                     END IF
                  END IF

                  IF NOT cl_null(l_ltk[l_rec].ltk16) THEN
                     LET l_sql = " UPDATE ",cl_get_target_table(l_ltn04, 'ltk_file'),               
                                 "    SET ltk16 = '",l_ltk[l_rec].ltk16 CLIPPED,"'",
                                 "  WHERE ltk13 = '",l_ltk[l_rec].ltk13,"'",
                                 "    AND ltk14 = '",l_ltk[l_rec].ltk14,"'",
                                 "    AND ltk21 = '",l_ltk[l_rec].ltk21,"'",
                                 "    AND ltk05 = '",l_ltk[l_rec].ltk05,"'",
                                 "    AND ltkplant = '",l_ltn04,"'"

                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql               
                     PREPARE trans_upd_ltk16 FROM l_sql
                     EXECUTE trans_upd_ltk16
                     IF SQLCA.sqlcode THEN
                        LET g_success = 'N'                                             
                        CALL s_errmsg('','','UPDATE ltk_file:',SQLCA.sqlcode,1)
                        ROLLBACK WORK
                        EXIT FOREACH
                     END IF
                  END IF
               END IF

               IF g_success = 'Y' THEN  
                  #寫入會員紀念日積分回饋設定檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lth_file'),  
                              "           (lth01,lth02,lth03,lth04,lth05,lth06,lth07,lth08,lth09,lth10,",
                              "            lth11,lth12,lthacti,lthdate,lthgrup,lthmodu,lthorig,lthoriu,lthuser,",
                              "            lth13,lth14,lth17,lth18,lth19,lth20,lthlegal,lthplant)",
                              "VALUES('",l_ltk[l_rec].ltk01,"','",l_ltk[l_rec].ltk02,"','",l_ltk[l_rec].ltk03,"','",l_ltk[l_rec].ltk04,"', ",
                              "       '",l_ltk[l_rec].ltk05,"','",l_ltk[l_rec].ltk06,"', ",l_ltk[l_rec].ltk07," , ",l_ltk[l_rec].ltk08," , ",
                              "        ",l_ltk[l_rec].ltk09," , ",l_ltk[l_rec].ltk10," , ",l_ltk[l_rec].ltk11," , ",l_ltk[l_rec].ltk12," , ",
                              "       '",l_ltk[l_rec].ltkacti,"','",l_ltk[l_rec].ltkdate,"','",l_ltk[l_rec].ltkgrup,"',",
                              "       '",l_ltk[l_rec].ltkmodu,"','",l_ltk[l_rec].ltkorig,"','",l_ltk[l_rec].ltkoriu,"','",l_ltk[l_rec].ltkuser,"',",
                              "       '",l_ltk[l_rec].ltk13,"','",l_ltk[l_rec].ltk14,"','",l_ltk[l_rec].ltk17,"','",l_ltk[l_rec].ltk18,"','",l_ltk[l_rec].ltk19,"','",l_ltk[l_rec].ltk20,"', ",
                              "       '",l_ltk[l_rec].ltklegal,"','",l_ltk[l_rec].ltkplant,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql                
                  PREPARE trans_ins_lth FROM l_sql
                  EXECUTE trans_ins_lth
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'                                             
                     CALL s_errmsg('','','INSERT INTO lth_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: lth_file: ',l_ltk[l_rec].ltk14,' for plant:  ',l_ltn04
                  END IF

                  IF NOT cl_null(l_ltk[l_rec].ltk15) THEN
                     LET l_sql = " UPDATE ",cl_get_target_table(l_ltn04, 'lth_file'),              
                                 "    SET lth15 = '",l_ltk[l_rec].ltk15 CLIPPED,"'",
                                 "  WHERE lth13 = '",l_ltk[l_rec].ltk13,"'",
                                 "    AND lth14 = '",l_ltk[l_rec].ltk14,"'",
                                 "    AND lth05 = '",l_ltk[l_rec].ltk05,"'",
                                 "    AND lthplant = '",l_ltn04,"'"

                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql              
                     PREPARE trans_upd_lth15 FROM l_sql
                     EXECUTE trans_upd_lth15
                     IF SQLCA.sqlcode THEN
                        LET g_success = 'N'                                               
                        CALL s_errmsg('','','UPDATE lth_file:',SQLCA.sqlcode,1)
                        ROLLBACK WORK
                        EXIT FOREACH
                     END IF
                  END IF

                  IF NOT cl_null(l_ltk[l_rec].ltk16) THEN
                     LET l_sql = " UPDATE ",cl_get_target_table(l_ltn04, 'lth_file'),              
                                 "    SET lth16 = '",l_ltk[l_rec].ltk16 CLIPPED,"'",
                                 "  WHERE lth13 = '",l_ltk[l_rec].ltk13,"'",
                                 "    AND lth14 = '",l_ltk[l_rec].ltk14,"'",
                                 "    AND lth05 = '",l_ltk[l_rec].ltk05,"'",
                                 "    AND lthplant = '",l_ltn04,"'"

                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql              
                     PREPARE trans_upd_lth16 FROM l_sql
                     EXECUTE trans_upd_lth16
                     IF SQLCA.sqlcode THEN
                        LET g_success = 'N'                                             
                        CALL s_errmsg('','','UPDATE lth_file:',SQLCA.sqlcode,1)
                        ROLLBACK WORK
                        EXIT FOREACH
                     END IF
                  END IF
               END IF

               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN   
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF

         #排除明細
         IF g_success = 'Y' THEN
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'lrr_file'),
                        " WHERE lrr05 = '",l_lti.lti06,"' ",
                        "   AND lrr06 = '",l_lti.lti07,"' ",
                        "   AND lrrplant ='",l_lti.ltiplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_lrr FROM l_sql
            EXECUTE trans_del_lrr
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE lrr_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delele lrr_file, lrr06: ',l_lti.lti07
            END IF
         END IF

         IF g_success = 'Y' THEN   
            SELECT COUNT(*) INTO l_max_rec FROM ltl_file WHERE ltl05 = g_lti.lti06 AND ltl06 = g_lti.lti07 AND ltl07 = g_lti.lti08 AND ltlplant = g_lti.ltiplant
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(g_lti.ltiplant, 'ltl_file'),   
                        " WHERE ltl05 = '",g_lti.lti06,"' ",
                        "   AND ltl06 = '",g_lti.lti07,"' ",
                        "   AND ltl07 = '",g_lti.lti08,"' ",
                        "   AND ltlplant = '",g_lti.ltiplant,"' "

            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql  
            PREPARE ltl_sur FROM l_sql
            DECLARE ltl_ins_sur CURSOR FOR ltl_sur
            FOREACH ltl_ins_sur INTO l_ltl[l_rec].* 
               LET l_ltl[l_rec].ltllegal = l_azw02
               LET l_ltl[l_rec].ltlplant = l_ltn04

               IF g_success = 'Y' AND g_lti.ltiplant <> l_ltn04 THEN   
                  #寫入積分/折扣規則排除明細變更檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltl_file'),  
                              "      (ltl00,ltl01,ltl02,ltl03,ltl04,ltl05,ltl06,ltl07,ltlacti,ltllegal,ltlplant)", 
                              "VALUES('",l_ltl[l_rec].ltl00,"','",l_ltl[l_rec].ltl01,"','",l_ltl[l_rec].ltl02,"','",l_ltl[l_rec].ltl03,"','",l_ltl[l_rec].ltl04,"', ",
                              "       '",l_ltl[l_rec].ltl05,"','",l_ltl[l_rec].ltl06,"',",l_ltl[l_rec].ltl07,",'",l_ltl[l_rec].ltlacti,"','",l_ltl[l_rec].ltllegal,"','",l_ltl[l_rec].ltlplant,"')" 

                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql 
                  PREPARE trans_ins_ltl2 FROM l_sql
                  EXECUTE trans_ins_ltl2
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N' 
                     CALL s_errmsg('','','INSERT INTO ltl_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltl_file: ',l_ltl[l_rec].ltl06,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF g_success = 'Y' THEN
                  #寫入積分/折扣規則排除明細
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lrr_file'),
                              "           (lrr00,lrr01,lrr02,lrr03,lrr04,lrracti,lrr05,lrr06,lrrlegal,lrrplant)",
                              "VALUES('",l_ltl[l_rec].ltl00,"','",l_ltl[l_rec].ltl01,"','",l_ltl[l_rec].ltl02,"','",l_ltl[l_rec].ltl03,"','",l_ltl[l_rec].ltl04,"','",l_ltl[l_rec].ltlacti,"',",
                              "       '",l_ltl[l_rec].ltl05,"','",l_ltl[l_rec].ltl06,"','",l_ltl[l_rec].ltllegal,"','",l_ltl[l_rec].ltlplant,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql                    
                  CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql    
                  PREPARE trans_ins_lrr FROM l_sql                                
                  EXECUTE trans_ins_lrr                                           
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N' 
                     CALL s_errmsg('','','INSERT INTO lrr_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: lrr_file: ',l_ltl[l_rec].ltl06,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN 
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF

         #生效營運中心
         IF g_success = 'Y' THEN
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'lso_file'),
                        " WHERE lso01 = '",l_lti.lti06,"' ",
                        "   AND lso02 = '",l_lti.lti07,"' ",
                        "   AND lso03 = '",l_lti.lti00,"' ",
                        "   AND lsoplant ='",l_lti.ltiplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_lso FROM l_sql
            EXECUTE trans_del_lso
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE lso_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delete lso_file,lso02: ',l_lti.lti07
            END IF
         END IF

         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec FROM ltn_file WHERE ltn01 = g_lti.lti06 AND ltn02 = g_lti.lti07 AND ltn08 = g_lti.lti08 AND ltnplant = g_lti.ltiplant
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(g_lti.ltiplant, 'ltn_file'),    
                        " WHERE ltn01 = '",g_lti.lti06,"' ",
                        "   AND ltn02 = '",g_lti.lti07,"' ",
                        "   AND ltn08 =  ",g_lti.lti08,"  ",
                        "   AND ltnplant = '", g_lti.ltiplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_lti.ltiplant) RETURNING l_sql   
            PREPARE ltn_sur FROM l_sql
            DECLARE ltn_ins_sur CURSOR FOR ltn_sur
            FOREACH ltn_ins_sur INTO l_ltn[l_rec].*
               LET l_ltn[l_rec].ltnlegal = l_azw02
               LET l_ltn[l_rec].ltnplant = l_ltn04
  
               IF g_success = 'Y' AND g_lti.ltiplant <> l_ltn04 THEN   
                  #寫入積分/折扣/儲值加值規則生效營運中心變更檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltn_file'),    
                              "      (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)",
                              "values('",l_ltn[l_rec].ltn01,"','",l_ltn[l_rec].ltn02,"','",l_ltn[l_rec].ltn03,"','",l_ltn[l_rec].ltn04,"','",l_ltn[l_rec].ltn05,"',",
                              "       '",l_ltn[l_rec].ltn06,"','",l_ltn[l_rec].ltn07,"',",l_ltn[l_rec].ltn08,",'",l_ltn[l_rec].ltnlegal,"','",l_ltn[l_rec].ltnplant,"')"

                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
                  PREPARE trans_ins_ltn2 FROM l_sql
                  EXECUTE trans_ins_ltn2
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'  
                     CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltn_file: ',l_ltn[l_rec].ltn03,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF g_success = 'Y' THEN
                  #寫入積分/折扣/儲值加值規則生效營運中心檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lso_file'),
                              "           (lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant)",
                              "values('",l_ltn[l_rec].ltn01,"','",l_ltn[l_rec].ltn02,"','",l_ltn[l_rec].ltn03,"','",l_ltn[l_rec].ltn04,"','",l_ltn[l_rec].ltn05,"',",
                              "       '",l_ltn[l_rec].ltn06,"','",l_ltn[l_rec].ltn07,"','",l_ltn[l_rec].ltnlegal,"','",l_ltn[l_rec].ltnplant,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql   
                  PREPARE trans_ins_lso FROM l_sql
                  EXECUTE trans_ins_lso
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'  
                     CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: lso_file: ',l_ltn[l_rec].ltn03,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN  
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF
      END FOREACH
   END IF

   IF g_aza.aza88 = 'Y' THEN
      IF g_ltipos = '1' THEN
         LET g_lti.ltipos = '1'
      ELSE
         LET g_lti.ltipos = '2'
      END IF
      DISPLAY g_lti.ltipos TO ltipos
   END IF

   IF g_success = 'N' THEN  
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   ELSE
      LET g_lti.lticond = g_today
      LET g_lti.lticonf = 'Y' 
      LET g_lti.lticonu = g_user
      LET g_lti.ltidate = g_today
      LET g_lti.ltimodu = g_user
      LET g_lti.ltiuser = g_user
      LET g_lti.lti09   ='Y'
      LET g_lti.lti10   = g_today
      DISPLAY BY NAME g_lti.lticond
      DISPLAY BY NAME g_lti.lticonf
      DISPLAY BY NAME g_lti.lticonu
      DISPLAY BY NAME g_lti.ltidate
      DISPLAY BY NAME g_lti.ltimodu
      DISPLAY BY NAME g_lti.ltiuser
      DISPLAY BY NAME g_lti.lti09
      DISPLAY BY NAME g_lti.lti10

      CALL t555_pic()

      COMMIT WORK
   END IF
END FUNCTION

FUNCTION t555_eff_plant()
   CALL t555_msg('eff_plant')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   CALL t555_sub2(g_lti.lti06,g_lti.lti07,g_lti.lti00,g_lti.lti01,g_lti.lti08)
END FUNCTION

FUNCTION t555_x()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_upd LIKE type_file.chr1

   LET l_cnt = 0 
   LET l_upd = null

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL t555_msg('invalid')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   SELECT count(*) INTO l_cnt FROM lti_file
    WHERE lti00 = g_lti.lti00
      AND lti01 = g_lti.lti01
      AND lti06 = g_plant
      AND ltiacti = 'Y'
      AND (lrp04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
           OR  lrp05 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
           OR  g_lrp.lrp04 BETWEEN lrp04 AND lrp05)

   IF l_cnt > 0 THEN
      CALL cl_err('','alm-h57',0)
   END IF

   BEGIN WORK

   OPEN t555_cl USING g_lti.lti01
   IF STATUS THEN
      CALL cl_err("OPEN lti_cl:", STATUS, 1)
      CLOSE t555_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t555_cl INTO g_lti.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lti.lti01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t555_show()

   IF cl_exp(0,0,g_lti.ltiacti) THEN                   #確認一下
      LET g_chr=g_lti.ltiacti
      IF g_lti.ltiacti='Y' THEN
         LET g_lti.ltiacti = 'N'
         LET g_lti.ltimodu = g_user
      ELSE
         LET g_lti.ltiacti = 'Y'
         LET g_lti.ltimodu = g_user
      END IF

      UPDATE lti_file SET ltiacti=g_lti.ltiacti,
                          ltimodu=g_lti.ltimodu,
                          ltidate=g_today
       WHERE lti06 = g_lti.lti06
         AND lti07 = g_lti.lti07
         AND lti08 = g_lti.lti08
         AND ltiplant = g_lti.ltiplant

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lti_file",g_lti.lti07,"",SQLCA.sqlcode,"","",1)
         LET g_lti.ltiacti=g_chr
      END IF
   END IF

   CLOSE t555_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT ltiacti,ltimodu,ltidate
     INTO g_lti.ltiacti,g_lti.ltimodu,g_lti.ltidate FROM lti_file
    WHERE lti06 = g_lti.lti06
      AND lti07 = g_lti.lti07
      AND lti08 = g_lti.lti08
      AND ltiplant = g_lti.ltiplant

   DISPLAY BY NAME g_lti.ltimodu,g_lti.ltidate,g_lti.ltiacti
   CALL t555_pic()

END FUNCTION

FUNCTION t555_refresh()
      DISPLAY ARRAY g_ltj TO s_ltj.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
           EXIT DISPLAY
      END DISPLAY

      DISPLAY ARRAY g_ltk TO s_ltk.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
           EXIT DISPLAY
      END DISPLAY

END FUNCTION

FUNCTION t555_ckmult()
   DEFINE l_sql        STRING
   DEFINE l_ltn04      LIKE ltn_file.ltn04
   DEFINE l_cnt        LIKE type_file.num5

   CALL s_showmsg_init()
   LET g_success = 'Y'
   LET l_sql = "SELECT DISTINCT ltn04 FROM ltn_file  ",
               "  WHERE ltn01 = '",g_lti.lti06,"' ",
               "    AND ltn02 = '",g_lti.lti07,"' AND ltn07 = 'Y' ",
               "    AND ltn08 = '",g_lti.lti08,"' "
   PREPARE ltl_pre3 FROM l_sql
   DECLARE ltl_cs3 CURSOR FOR ltl_pre3
   FOREACH ltl_cs3 INTO l_ltn04

      IF cl_null(l_ltn04) THEN CONTINUE FOREACH END IF
      LET l_cnt = 0
      #判斷其他生效營運中心是否已存在此單號
      IF NOT cl_null(g_lti.lti04) AND NOT cl_null(g_lti.lti05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04, 'lrp_file'),
                     "   WHERE lrp01 = '",g_lti.lti01,"'  AND lrp09 = 'Y' AND lrpconf = 'Y' ",
                     "     AND lrpacti = 'Y' AND lrp00 = '",g_lti.lti00,"' ",
                     "     AND lrp04 >= '",g_lti.lti04,"' AND lrp04 <= '",g_lti.lti05,"' ",
                     "     AND lrp05 >= '",g_lti.lti04,"' AND lrp05 <= '",g_lti.lti05,"' ",
                     "     AND lrp08 =",g_lti.lti08  
      END IF

      IF NOT cl_null(g_lti.lti04) AND cl_null(g_lti.lti05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04, 'lrp_file'),
                     "   WHERE lrp01 = '",g_lti.lti01,"'  AND lrp09 = 'Y' AND lrpconf = 'Y' ",
                     "     AND lrpacti = 'Y' AND lrp00 = '",g_lti.lti00,"' ",
                     "     AND lrp04 >= '",g_lti.lti04,"' ",
                     "     AND lrp05 <= '",g_lti.lti04,"' ",
                     "     AND lrp08 =",g_lti.lti08
      END IF

      IF cl_null(g_lti.lti04) AND NOT cl_null(g_lti.lti05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04, 'lrp_file'),
                     "   WHERE lrp01 = '",g_lti.lti01,"'  AND lrp09 = 'Y' AND lrpconf = 'Y' ",
                     "     AND lrpacti = 'Y' AND lrp00 = '",g_lti.lti00,"' ",
                     "     AND lrp04 <= '",g_lti.lti05,"' ",
                     "     AND lrp05 >= '",g_lti.lti05,"' ",
                     "     AND lrp08 = ",g_lti.lti08
      END IF

      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
      PREPARE trans_cnt FROM l_sql
      EXECUTE trans_cnt INTO l_cnt
      IF l_cnt > 0 THEN
         CALL s_errmsg('ltl04',l_ltn04,l_ltn04,'alm-h65',1)
         LET g_success = 'N'
      END IF
      #判斷營運中心是否符合卡種生效營運中心
      LET l_cnt = 0
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_lti.lti01,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",l_ltn04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_ltn04 ) RETURNING l_sql
      PREPARE trans_cnt1 FROM l_sql
      EXECUTE trans_cnt1 INTO l_cnt

      IF l_cnt = 0 OR cl_null(l_cnt) THEN
         CALL s_errmsg('ltn04',l_ltn04,l_ltn04,'alm-h33',1)
         LET g_success = 'N'
      END IF
   END FOREACH

   CALL s_showmsg()
END FUNCTION

FUNCTION t555_pic()
   CASE g_lti.lticonf
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE

   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lti.ltiacti)
END FUNCTION


