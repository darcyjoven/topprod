# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: artt804.4gl
# Descriptions...: 滿額促銷單
# Date & Author..: NO.FUN-A60066 10/06/24 By bnlent 
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No:FUN-B40071 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rah         RECORD LIKE rah_file.*,
       g_rah_t       RECORD LIKE rah_file.*,
       g_rah_o       RECORD LIKE rah_file.*,
       g_t1          LIKE oay_file.oayslip,
       g_rai         DYNAMIC ARRAY OF RECORD
           rai03          LIKE rai_file.rai03,
           rai04          LIKE rai_file.rai04,
           rai05          LIKE rai_file.rai05,
           rai06          LIKE rai_file.rai06,
           rai07          LIKE rai_file.rai07,
           rai08          LIKE rai_file.rai08,
           rai09          LIKE rai_file.rai09,
           raiacti        LIKE rai_file.raiacti
                     END RECORD,
       g_rai_t       RECORD
           rai03          LIKE rai_file.rai03,
           rai04          LIKE rai_file.rai04,
           rai05          LIKE rai_file.rai05,
           rai06          LIKE rai_file.rai06,
           rai07          LIKE rai_file.rai07,
           rai08          LIKE rai_file.rai08,
           rai09          LIKE rai_file.rai09,
           raiacti        LIKE rai_file.raiacti
                     END RECORD,
       g_rai_o       RECORD 
           rai03          LIKE rai_file.rai03,
           rai04          LIKE rai_file.rai04,
           rai05          LIKE rai_file.rai05,
           rai06          LIKE rai_file.rai06,
           rai07          LIKE rai_file.rai07,
           rai08          LIKE rai_file.rai08,
           rai09          LIKE rai_file.rai09,
           raiacti        LIKE rai_file.raiacti
                     END RECORD,
       g_raj         DYNAMIC ARRAY OF RECORD
           raj03          LIKE raj_file.raj03,
           raj04          LIKE raj_file.raj04,
           raj05          LIKE raj_file.raj05,
           raj05_desc     LIKE type_file.chr100,
           raj06          LIKE raj_file.raj06,
           raj06_desc     LIKE gfe_file.gfe02,
           rajacti        LIKE raj_file.rajacti
                     END RECORD,
       g_raj_t       RECORD
           raj03          LIKE raj_file.raj03,
           raj04          LIKE raj_file.raj04,
           raj05          LIKE raj_file.raj05,
           raj05_desc     LIKE type_file.chr100,
           raj06          LIKE raj_file.raj06,
           raj06_desc     LIKE gfe_file.gfe02,
           rajacti        LIKE raj_file.rajacti
                     END RECORD,
       g_raj_o       RECORD
           raj03          LIKE raj_file.raj03,
           raj04          LIKE raj_file.raj04,
           raj05          LIKE raj_file.raj05,
           raj05_desc     LIKE type_file.chr100,
           raj06          LIKE raj_file.raj06,
           raj06_desc     LIKE gfe_file.gfe02,
           rajacti        LIKE raj_file.rajacti
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac3         LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_gec07             LIKE gec_file.gec07
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE rah_file.rah01
DEFINE g_argv2             LIKE rah_file.rah02
DEFINE g_argv3             LIKE rah_file.rahplant
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rec_b1            LIKE type_file.num5
DEFINE g_rec_b3            LIKE type_file.num5
DEFINE g_rec_b4            LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_member            LIKE type_file.chr1

DEFINE l_azp02             LIKE azp_file.azp02 
DEFINE g_rtz05             LIKE rtz_file.rtz05  #價格策略

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM rah_file WHERE rah01 = ? AND rah02 = ? AND rahplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t804_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t804_w AT p_row,p_col WITH FORM "art/42f/artt804"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant

   CALL cl_set_comp_visible("s_raj",FALSE)
   IF NOT cl_null(g_argv1) THEN
      CALL t804_q()
   END IF
   
   CALL t804_menu()
   CLOSE WINDOW t804_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t804_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rai.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rah01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc CLIPPED," rah02 = '",g_argv2,"'"
      END IF
      IF NOT cl_null(g_argv3) THEN
         LET g_wc = g_wc CLIPPED," rahplant = '",g_argv3,"'"
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rah.* TO NULL
      CONSTRUCT BY NAME g_wc ON rah01,rah02,rah03,rahplant,
                                rah04,rah05,rah06,rah07,rah10,rah11,rah12,rah13,rah14,rah15,
                                rahmksg,rah900,rahconf,rahcond,rahcont,rahconu,rahpos,rah24,
                                rah16,rah17,rah18,rah19,rah20,rah21,rah22,rah23,
                                rahuser,rahgrup,rahoriu,rahmodu,rahdate,rahorig,rahacti,rahcrat
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rah01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rah01
                  NEXT FIELD rah01
      
               WHEN INFIELD(rah02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rah02
                  NEXT FIELD rah02
      
               WHEN INFIELD(rah03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rah03
                  NEXT FIELD rah03
      
               WHEN INFIELD(rahconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rahconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rahconu                                                                              
                  NEXT FIELD rahconu
               WHEN INFIELD(rahplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rahplant"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rahplant                                                                              
                  NEXT FIELD rahplant
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rahuser', 'rahgrup')
 
      CONSTRUCT g_wc1 ON rai03,rai04,rai05,rai06,rai07,rai08,   
                         rai09,raiacti   
              FROM s_rai[1].rai03,s_rai[1].rai04,
                   s_rai[1].rai05,s_rai[1].rai06,s_rai[1].rai07,
                   s_rai[1].rai08,s_rai[1].rai09,s_rai[1].raiacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
       END CONSTRUCT
   
       IF INT_FLAG THEN
          RETURN
       END IF 

       CONSTRUCT g_wc2 ON raj03,raj04,raj05,raj06,rajacti
              FROM s_raj[1].raj03,s_raj[1].raj04,
                   s_raj[1].raj05,s_raj[1].raj06, s_raj[1].rajacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(raj05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_raj05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO raj05
                  NEXT FIELD raj05
               WHEN INFIELD(raj06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_raj06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO raj06
                  NEXT FIELD raj06 
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
       END CONSTRUCT     

       IF INT_FLAG THEN 
          RETURN
       END IF

    END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    LET g_wc  = g_wc  CLIPPED

    IF cl_null(g_wc) THEN
       LET g_wc =" 1=1"
    END IF
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"
    END IF
    
 
    LET g_sql = "SELECT DISTINCT rah01,rah02,rahplant ",
                "  FROM (rah_file LEFT OUTER JOIN rai_file ",
                "       ON (rah01=rai01 AND rah02=rai02 AND rahplant=raiplant AND ",g_wc1,")) ",
                "    LEFT OUTER JOIN raj_file ON ( rah01=raj01 AND rah02=raj02 ",
                "     AND rahplant=rajplant AND ",g_wc2,") ",
                "  WHERE ", g_wc CLIPPED,  
                " ORDER BY rah01,rah02,rahplant"
 
   PREPARE t804_prepare FROM g_sql
   DECLARE t804_cs
       SCROLL CURSOR WITH HOLD FOR t804_prepare
 
   #IF g_wc2 = " 1=1" THEN
   #   LET g_sql="SELECT COUNT(*) FROM rah_file WHERE ",g_wc CLIPPED
   #ELSE
   #   LET g_sql="SELECT COUNT(*) FROM rah_file,rai_file WHERE ",
   #             "rai01=rah01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   #END IF
   LET g_sql = "SELECT COUNT(DISTINCT rah01||rah02||rahplant) ",
                "  FROM (rah_file LEFT OUTER JOIN rai_file ",
                "       ON (rah01=rai01 AND rah02=rai02 AND rahplant=raiplant AND ",g_wc1,")) ",
                "    LEFT OUTER JOIN raj_file ON ( rah01=raj01 AND rah02=raj02 ",
                "     AND rahplant=rajplant AND ",g_wc2,") ",
                "  WHERE ", g_wc CLIPPED,  
                " ORDER BY rah01"

   PREPARE t804_precount FROM g_sql
   DECLARE t804_count CURSOR FOR t804_precount
 
END FUNCTION
 
FUNCTION t804_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t804_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t804_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t804_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t804_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t804_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t804_x()
            END IF
 
#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#               CALL t804_copy()
#            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_flag_b = '1' THEN
                  CALL t804_b()
               ELSE
                  CALL t804_b1()
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t804_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "organization" #生效機構
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rah.rah02) THEN
                  CALl t802_1(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t804_yes()
            END IF
 
         WHEN "Memberlevel"    #會員等級促銷
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rah.rah02) THEN
                 CALl t802_2(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10)
              ELSE
                 CALL cl_err('',-400,0)
              END IF
              #CALL t804_sales()
            END IF

        WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t804_void()
            END IF

        WHEN "issuance"              #發布
           IF cl_chk_act_auth() THEN
              CALL t804_iss()
           END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rai),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rah.rah02 IS NOT NULL THEN
                 LET g_doc.column1 = "rah02"
                 LET g_doc.value1 = g_rah.rah02
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t804_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rai TO s_rai.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
 
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
 
         ON ACTION first
            CALL t804_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t804_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t804_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t804_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t804_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
            EXIT DIALOG
 
#        ON ACTION output
#           LET g_action_choice="output"
#           EXIT DIALOG
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ON ACTION organization                #生效機構
            LET g_action_choice =  "organization" 
            EXIT DIALOG

         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
         ON ACTION void
            LET g_action_choice="void"
            EXIT DIALOG

         ON ACTION issuance                    #發布      
            LET g_action_choice = "issuance"  
            EXIT DIALOG
                                                                                                                                    
         ON ACTION Memberlevel                 #會員促銷
            LET g_action_choice="Memberlevel"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
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
 
         AFTER DISPLAY
            CONTINUE DIALOG
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
    
      DISPLAY ARRAY g_raj TO s_raj.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
 
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
 
         ON ACTION first
            CALL t804_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t804_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t804_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t804_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t804_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = 1
            EXIT DIALOG
 
#        ON ACTION output
#           LET g_action_choice="output"
#           EXIT DIALOG
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
 
         ON ACTION void
            LET g_action_choice="void"
            EXIT DIALOG
 
         ON ACTION Memberlevel                 #會員促銷
            LET g_action_choice="Memberlevel"
            EXIT DIALOG

         ON ACTION issuance                    #發布      
            LET g_action_choice = "issuance"  
            EXIT DIALOG
                                                                                                                                    
         ON ACTION organization                #生效機構
            LET g_action_choice =  "organization" 
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = ARR_CURR()
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
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t804_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rai.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   #CALL cl_set_comp_visible("rai05,rai06,rai08,rai09,Page6",TRUE)
   CALL t804_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rah.* TO NULL
      RETURN
   END IF
 
   OPEN t804_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rah.* TO NULL
   ELSE
      OPEN t804_count
      FETCH t804_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t804_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t804_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t804_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
      WHEN 'P' FETCH PREVIOUS t804_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
      WHEN 'F' FETCH FIRST    t804_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
      WHEN 'L' FETCH LAST     t804_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
        FETCH ABSOLUTE g_jump t804_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
      INITIALIZE g_rah.* TO NULL
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
 
   SELECT * INTO g_rah.* FROM rah_file 
       WHERE rah02 = g_rah.rah02 AND rah01 = g_rah.rah01
         AND rahplant = g_rah.rahplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rah_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rah.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rah.rahuser
   LET g_data_group = g_rah.rahgrup
   LET g_data_plant = g_rah.rahplant #TQC-A10128 ADD
 
   CALL t804_show()
 
END FUNCTION
 
FUNCTION t804_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE l_raa03   LIKE raa_file.raa03 
 
   LET g_rah_t.* = g_rah.*
   LET g_rah_o.* = g_rah.*
   DISPLAY BY NAME g_rah.rah01,g_rah.rah02,g_rah.rah03,  
                   g_rah.rah04,g_rah.rah05,g_rah.rah06,g_rah.rah07,
                   g_rah.rah10,g_rah.rah11,
                   g_rah.rah12,g_rah.rah13,g_rah.rah14,g_rah.rah15,
                   g_rah.rah16,g_rah.rah17,g_rah.rah18,g_rah.rah19,
                   g_rah.rah20,g_rah.rah21,g_rah.rah22,g_rah.rah23,g_rah.rah24,
                   g_rah.rahplant,g_rah.rahconf,g_rah.rahcond,g_rah.rahcont,
                   g_rah.rahconu,g_rah.rah900,g_rah.rahmksg,
                   g_rah.rahoriu,g_rah.rahorig,g_rah.rahuser,
                   g_rah.rahmodu,g_rah.rahacti,g_rah.rahgrup,
                   g_rah.rahdate,g_rah.rahcrat,g_rah.rahpos
 
   IF g_rah.rahconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rah.rahconf,"","","",g_chr,"")                                                                           
  #CALL cl_flow_notify(g_rah.rah01,'V') 

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rah01
   DISPLAY l_azp02 TO FORMONLY.rah01_desc
   SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rah.rah01 AND raa02 = g_rah.rah03
   DISPLAY l_raa03 TO FORMONLY.rah03_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rah.rahconu
   DISPLAY l_gen02 TO FORMONLY.rahconu_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rahplant
   DISPLAY l_azp02 TO FORMONLY.rahplant_desc
   CALL t804_rah10()
   CALL t804_rah11()
   CALL t804_b_fill(g_wc1)
   CALL t804_b1_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t804_b_fill(p_wc1)
DEFINE p_wc1   STRING
 
   LET g_sql = "SELECT rai03,rai04,rai05,rai06,rai07,rai08,rai09, ",
               "       raiacti ", 
               "  FROM rai_file",
               " WHERE rai02 = '",g_rah.rah02,"' AND rai01 ='",g_rah.rah01,"' ",
               "   AND raiplant = '",g_rah.rahplant,"'"
 
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rai03 "
 
   DISPLAY g_sql
 
   PREPARE t804_pb FROM g_sql
   DECLARE rai_cs CURSOR FOR t804_pb
 
   CALL g_rai.clear()
   LET g_cnt = 1
 
   FOREACH rai_cs INTO g_rai[g_cnt].*
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
   CALL g_rai.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn1
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t804_b1_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT raj03,raj04,raj05,'',raj06,'',rajacti",
               "  FROM raj_file",
               " WHERE raj02 = '",g_rah.rah02,"' AND raj01 ='",g_rah.rah01,"' ",
               "   AND rajplant = '",g_rah.rahplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY raj03 "
 
   DISPLAY g_sql
 
   PREPARE t804_pb1 FROM g_sql
   DECLARE raj_cs CURSOR FOR t804_pb1
 
   CALL g_raj.clear()
   LET g_cnt = 1
 
   FOREACH raj_cs INTO g_raj[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_ac1 = g_cnt
       CALL t804_raj05('d')
       CALL t804_raj06('d')

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_raj.deleteElement(g_cnt)
 
   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t804_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   DEFINE l_gen02     LIKE gen_file.gen02

   MESSAGE ""
   CLEAR FORM
   CALL g_rai.clear() 
   CALL g_raj.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rah.* LIKE rah_file.*
   LET g_rah_t.* = g_rah.*
   LET g_rah_o.* = g_rah.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rah.rah01 = g_plant
      LET g_rah.rah06 = '00:00:00' 
      LET g_rah.rah07 = '23:59:59'
      LET g_rah.rah08 = 'N'  #预留
      LET g_rah.rah09 = 'N'  #预留
      LET g_rah.rah10 = '2'
      LET g_rah.rah11 = '1'
      LET g_rah.rah12 = 'N'
      LET g_rah.rah13 = 'N'
      LET g_rah.rah14 = 'N'
      LET g_rah.rah15 = 'Y'
      LET g_rah.rah16 = 'N'
      LET g_rah.rah17 = 'N'
      LET g_rah.rah18 = 'N'
      LET g_rah.rah19 = 'N'
      LET g_rah.rah20 = '1'
      LET g_rah.rah21 = '1'
      LET g_rah.rah22 = '1'
      LET g_rah.rah900   = '0'
      LET g_rah.rahacti  ='Y'
      LET g_rah.rahconf  = 'N'
      LET g_rah.rahpos  = '1' #NO.FUN-B40071
      LET g_rah.rahmksg  = 'N'
      LET g_rah.rahuser  = g_user
      LET g_rah.rahoriu  = g_user  
      LET g_rah.rahorig  = g_grup  
      LET g_rah.rahgrup  = g_grup
      LET g_rah.rahcrat  = g_today
      LET g_rah.rahplant = g_plant
      LET g_rah.rahlegal = g_legal
      LET g_data_plant   = g_plant 

      DISPLAY BY NAME g_rah.rah01,g_rah.rah04,g_rah.rah05,g_rah.rah06,
                      g_rah.rah07,g_rah.rah10,
                      g_rah.rah11,g_rah.rah12,g_rah.rah13,g_rah.rah14,
                      g_rah.rah15,g_rah.rah16,g_rah.rah17,g_rah.rah18,
                      g_rah.rah19,g_rah.rah20,g_rah.rah21,g_rah.rah22,
                      g_rah.rah900,g_rah.rahacti,g_rah.rahconf,g_rah.rahpos,
                      g_rah.rahmksg,g_rah.rahuser,g_rah.rahoriu,g_rah.rahorig,
                      g_rah.rahgrup,g_rah.rahcrat,g_rah.rahplant
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rah01
      DISPLAY l_azp02 TO rah01_desc
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rahplant
      DISPLAY l_azp02 TO rahplant_desc

      CALL t804_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rah.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rah.rah02) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("axm",g_rah.rah02,g_today,"A9","rah_file","rah01,rah02,rahplant","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rah.rah02,g_today,"A9","rah_file","rah01,rah02,rahplant","","","") #FUN-A70130 mod
         RETURNING li_result,g_rah.rah02 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rah.rah02
      INSERT INTO rah_file VALUES (g_rah.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK          # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rah_file",g_rah.rah02,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK           # FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         #FUN-B80085增加空白行


         INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq05,raqacti,raqplant,raqlegal)
                      VALUES (g_rah.rah01,g_rah.rah02,'3',g_rah.rah01,'N','Y',g_rah.rahplant,g_legal)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
            CALL cl_err3("ins","raq_file",g_rah.rah02,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK          # FUN-B80085--add--
            CONTINUE WHILE
         ELSE 
            COMMIT WORK
            CALL cl_flow_notify(g_rah.rah02,'I')
         END IF
      END IF
 
      SELECT * INTO g_rah.* FROM rah_file
       WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
         AND rahplant = g_rah.rahplant  
      LET g_rah_t.* = g_rah.*
      LET g_rah_o.* = g_rah.*     
      CALL t802_1(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf) 
      CALL g_rai.clear()
      CALL g_raj.clear()
      CALL t804_rah10()
      CALL t804_rah11()
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      CALL t804_b()
      IF g_rah.rah11 = '2' THEN
         CALL t804_b1()
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t804_i(p_cmd)
DEFINE     l_pmc05   LIKE pmc_file.pmc05,
           l_pmc30   LIKE pmc_file.pmc30,
           l_n       LIKE type_file.num5,
           p_cmd     LIKE type_file.chr1,
           li_result LIKE type_file.num5
DEFINE     l_date    LIKE rwf_file.rwf06
DEFINE     l_time1   LIKE type_file.num5
DEFINE     l_time2   LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES") 
   
   INPUT BY NAME g_rah.rah02,g_rah.rah03,g_rah.rah04,g_rah.rah05,
                 g_rah.rah06,g_rah.rah07,
                 g_rah.rah10,g_rah.rah11,g_rah.rah12,g_rah.rah13,
                 g_rah.rah14,g_rah.rah15,g_rah.rahmksg,g_rah.rah24,
                 g_rah.rah16,g_rah.rah17,g_rah.rah18,g_rah.rah19,
                 g_rah.rah20,g_rah.rah21,g_rah.rah22,g_rah.rah23

       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t804_set_entry(p_cmd)
         CALL t804_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#         CALL cl_set_comp_visible('kefa',TRUE)
         CALL cl_set_docno_format("rah02")
          
      AFTER FIELD rah02  #促銷單號
         IF NOT cl_null(g_rah.rah02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rah.rah02 <> g_rah_t.rah02) THEN     
               CALL s_check_no("axm",g_rah.rah02,g_rah_t.rah02,"A9","rah_file","rah01,rah02,rahplant","")
                    RETURNING li_result,g_rah.rah02
                 IF (NOT li_result) THEN                                                            
                    LET g_rah.rah02=g_rah_t.rah02                                                                 
                    NEXT FIELD rah02                                                                                     
                 END IF
            END IF
         END IF

      AFTER FIELD rah03  #活動代碼
         IF NOT cl_null(g_rah.rah03) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                   
               g_rah.rah03 != g_rah_o.rah03 OR cl_null(g_rah_o.rah03)) THEN               
               CALL t804_rah03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rah03:',g_errno,0)
                  LET g_rah.rah03 = g_rah_t.rah03
                  DISPLAY BY NAME g_rah.rah03
                  NEXT FIELD rah03
               ELSE
                  LET g_rah_o.rah03 = g_rah.rah03
               END IF
            END IF
         ELSE
            LET g_rah_o.rah03 = ''
            CLEAR rah03_desc           
         END IF

      AFTER FIELD rah04,rah05 #開始,結束日期
           LET l_date = FGL_DIALOG_GETBUFFER()
                 IF INFIELD(rah04) THEN
                    IF NOT cl_null(g_rah.rah05) THEN
                       IF DATE(l_date)>g_rah.rah05 THEN
                          CALL cl_err('','art-201',0)
                          NEXT FIELD rah04
                       END IF
                    END IF
                 END IF
                 IF INFIELD(rah05) THEN
                    IF NOT cl_null(g_rah.rah04) THEN
                       IF DATE(l_date)<g_rah.rah04 THEN
                          CALL cl_err('','art-201',0)
                          NEXT FIELD rah05
                       END IF
                    END IF
                 END IF   
                 CALL t804_check()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD CURRENT
                 END IF
          
       AFTER FIELD rah06 #開始時間
             IF NOT cl_null(g_rah.rah06) THEN
                IF p_cmd = "a" OR                    
                   (p_cmd = "u" AND g_rah.rah06<>g_rah_t.rah06) THEN 
                   CALL t804_chktime(g_rah.rah06) RETURNING l_time1
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rah06
                   ELSE
                     IF NOT cl_null(g_rah.rah07) THEN
                          CALL t804_chktime(g_rah.rah07) RETURNING l_time2
                          IF l_time1>=l_time2 THEN
                             CALL cl_err('','art-207',0)
                             NEXT FIELD rah06
                          END IF
                          CALL t804_check()
                          IF NOT cl_null(g_errno) THEN
                             CALL cl_err('',g_errno,0)
                             NEXT FIELD CURRENT
                          END IF
                      END IF
                    END IF
                 END IF
              END IF
         
       AFTER FIELD rah07 #結束時間
             IF NOT cl_null(g_rah.rah07) THEN
                IF p_cmd = "a" OR                    
                   (p_cmd = "u" AND g_rah.rah07<>g_rah.rah07) THEN 
                   CALL t804_chktime(g_rah.rah07) RETURNING l_time2
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rah07
                   ELSE
                     IF NOT cl_null(g_rah.rah06) THEN
                           CALL t804_chktime(g_rah.rah06) RETURNING l_time1
                           IF l_time1>=l_time2 THEN
                              CALL cl_err('','art-207',0)
                              NEXT FIELD rah07
                           END IF
                           CALL t804_check()
                           IF NOT cl_null(g_errno) THEN
                              CALL cl_err('',g_errno,0)
                              NEXT FIELD CURRENT
                           END IF
                      END IF
                    END IF
                END IF
             END IF
         
      ON CHANGE rah10 #促銷方式
         CALL t804_rah10()
      AFTER FIELD rah10
         CALL t804_rah10()
         
      ON CHANGE rah11 #促銷方式
         CALL t804_rah11()
      AFTER FIELD rah11 #促銷方式
         CALL t804_rah11()

      ON CHANGE rah22 #換贈類型
         CALL t804_rah22()
      AFTER FIELD rah22 #換贈類型
         CALL t804_rah22()
      AFTER FIELD rah23 #
         IF g_rah.rah22 = '2' THEN
            IF g_rah.rah23 <= 1 THEN
               CALL cl_err(g_rah.rah23,'art-659',0)
               NEXT FIELD rah23
            END IF
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
            WHEN INFIELD(rah02)                                                                                                      
              LET g_t1=s_get_doc_no(g_rah.rah02)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'A9','art') RETURNING g_t1         #FUN-A70130                                                       
              LET g_rah.rah02 = g_t1                                                                                                
              DISPLAY BY NAME g_rah.rah02                                                                                           
              NEXT FIELD rah02
            WHEN INFIELD(rah03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_raa02"
               LET g_qryparam.arg1 =g_plant
               LET g_qryparam.default1 = g_rah.rah03
               CALL cl_create_qry() RETURNING g_rah.rah03
               DISPLAY BY NAME g_rah.rah03
               CALL t804_rah03('d')
               NEXT FIELD rah03
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

FUNCTION t804_rah03(p_cmd)
DEFINE l_raa03        LIKE raa_file.raa03 
DEFINE l_raa05        LIKE raa_file.raa05 
DEFINE l_raa06        LIKE raa_file.raa06 
DEFINE l_raaacti      LIKE raa_file.raaacti
DEFINE l_raaconf      LIKE raa_file.raaconf 
DEFINE p_cmd          LIKE type_file.chr1

   SELECT raa03,raaacti,raaconf,raa05,raa06 
    INTO l_raa03,l_raaacti,l_raaconf,l_raa05,l_raa06 FROM raa_file
    WHERE raa01 = g_rah.rah01 AND raa02 = g_rah.rah03

  CASE                          
     WHEN SQLCA.sqlcode=100   LET g_errno='art-196' 
                              LET l_raa03=NULL 
     WHEN l_raaacti='N'       LET g_errno='9028'    
     WHEN l_raaconf<>'Y'      LET g_errno='art-195' 
    OTHERWISE   
    LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF p_cmd = 'a' THEN
     LET g_rah.rah04 = l_raa05 
     LET g_rah.rah05 = l_raa06 
     DISPLAY BY NAME g_rah.rah04,g_rah.rah05
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_raa03 TO FORMONLY.rah03_desc
  END IF
 
END FUNCTION

FUNCTION t804_rah10()
   IF NOT cl_null(g_rah.rah10) THEN
      CASE g_rah.rah10
       WHEN '2' CALL cl_set_comp_visible("rai06,rai09",FALSE)
                CALL cl_set_comp_visible("rai05,rai08",TRUE)
       WHEN '3' CALL cl_set_comp_visible("rai06,rai09",TRUE)
                CALL cl_set_comp_visible("rai05,rai08",FALSE)
      END CASE
   END IF
END FUNCTION
FUNCTION t804_rah11()
   IF NOT cl_null(g_rah.rah11) THEN
      IF g_rah.rah11 = '1' THEN
         CALL cl_set_comp_entry("raj03,raj04,raj05,raj06,rajacti",FALSE)
         #CALL cl_set_comp_visible("Page6",FALSE)
      ELSE
         CALL cl_set_comp_entry("raj03,raj04,raj05,raj06,rajacti",TRUE)
         #CALL cl_set_comp_visible("Page6",TRUE)
      END IF
   END IF
END FUNCTION
FUNCTION t804_rah22()
   IF NOT cl_null(g_rah.rah11) THEN
      IF g_rah.rah22 = '1' THEN
         LET g_rah.rah23 = 1 
         CALL cl_set_comp_entry("rah23",FALSE)
      ELSE
         IF NOT cl_null(g_rah.rah23) AND g_rah.rah23 =1 THEN 
            LET g_rah.rah23 = 2
         END IF
         CALL cl_set_comp_entry("rah23",TRUE)
         CALL cl_set_comp_required("rah23",TRUE)
      END IF
      DISPLAY BY NAME g_rah.rah23
   END IF
END FUNCTION
FUNCTION t804_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
        AND rahplant = g_rah.rahplant
   IF g_rah.rahacti ='N' THEN
      CALL cl_err(g_rah.rah02,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rah.rahconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rah.rahconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
      
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rah.rah02,SQLCA.sqlcode,0)
       CLOSE t804_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t804_show()
 
   WHILE TRUE
      LET g_rah_o.* = g_rah.*
      LET g_rah.rahmodu=g_user
      LET g_rah.rahdate=g_today
 
      CALL t804_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rah.*=g_rah_t.*
         CALL t804_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
     #IF g_rah.rah01 != g_rah_t.rah01 THEN
     #   UPDATE rai_file SET rai01 = g_rah.rah01
     #     WHERE rai02 = g_rah_t.rah02 AND rai01 = g_rah_t.rah01
     #       AND raiplant = g_rah_t.rahplant
     #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #      CALL cl_err3("upd","rai_file",g_rah_t.rah01,"",SQLCA.sqlcode,"","rai",1)
     #      CONTINUE WHILE
     #   END IF
     #END IF
 
      UPDATE rah_file SET rah_file.* = g_rah.*
         WHERE rah02 = g_rah.rah02 AND rah01 = g_rah.rah01  
           AND rahplant = g_rah.rahplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rah_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t804_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rah.rah02,'U')
 
   CALL t804_b_fill("1=1")
   CALL t804_b1_fill("1=1")

END FUNCTION
 



FUNCTION t804_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04

   IF g_rah.rah02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
        AND rahplant = g_rah.rahplant
   IF g_rah.rahconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rah.rahconf = 'X' THEN CALL cl_err(g_rah.rah01,'9024',0) RETURN END IF 
   IF g_rah.rahacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rai_file
    WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01
      AND raiplant = g_rah.rahplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#  SELECT SUM(raj10) INTO l_raj10 FROM raj_file
#      WHERE raj02 = g_rah.rah02 AND raj01=g_rah.rah01
#        AND rajplant = g_rah.rahplant
#  IF l_raj10 IS NULL THEN LET l_raj10 = 0 END IF
#  SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file WHERE rxx00 = '09'
#      AND rxx01 = g_rah.rah01 AND rxxplant = g_rah.rahplant 
#  IF l_rxx04 IS NULL THEN LET l_rxx04 = 0 END IF
#  IF l_rxx04 < l_raj10 THEN
#     CALL cl_err('','art-919',0)
#     RETURN
#  END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
   BEGIN WORK
   OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah02,SQLCA.sqlcode,0)
      CLOSE t804_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
 
   UPDATE rah_file SET rahconf='Y',
                       rahcond=g_today, 
                       rahcont=g_time, 
                       rahconu=g_user
     WHERE  rah02 = g_rah.rah02 AND rah01=g_rah.rah01
       AND rahplant = g_rah.rahplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rah.rahconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rah.rah02,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01 
        AND rahplant = g_rah.rahplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rah.rahconu
   DISPLAY BY NAME g_rah.rahconf                                                                                         
   DISPLAY BY NAME g_rah.rahcond                                                                                         
   DISPLAY BY NAME g_rah.rahcont                                                                                         
   DISPLAY BY NAME g_rah.rahconu
   DISPLAY l_gen02 TO FORMONLY.rahconu_desc
    #CKP
   IF g_rah.rahconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rah.rahconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rah.rah02,'V')
END FUNCTION
 
FUNCTION t804_void()
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
        AND rahplant = g_rah.rahplant
   IF g_rah.rah02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_rah.rahconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rah.rahacti = 'N' THEN CALL cl_err(g_rah.rah02,'art-142',0) RETURN END IF
   IF g_rah.rahconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF
   BEGIN WORK
 
   OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah02,SQLCA.sqlcode,0)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rah.rahconf) THEN
      LET g_chr = g_rah.rahconf
      IF g_rah.rahconf = 'N' THEN
         LET g_rah.rahconf = 'X'
      ELSE
         LET g_rah.rahconf = 'N'
      END IF
 
      UPDATE rah_file SET rahconf=g_rah.rahconf,
                          rahmodu=g_user,
                          rahdate=g_today
       WHERE rah01 = g_rah.rah01  AND rah02 = g_rah.rah02
         AND rahplant = g_rah.rahplant  
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rah_file",g_rah.rah01,"",SQLCA.sqlcode,"","up rahconf",1)
          LET g_rah.rahconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t804_cl
   COMMIT WORK
 
   SELECT * INTO g_rah.* FROM rah_file WHERE rah01=g_rah.rah01 AND rah02 = g_rah.rah02 AND rahplant = g_rah.rahplant 
   DISPLAY BY NAME g_rah.rahconf                                                                                        
   DISPLAY BY NAME g_rah.rahmodu                                                                                        
   DISPLAY BY NAME g_rah.rahdate
    #CKP
   IF g_rah.rahconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rah.rahconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rah.rah01,'V')
END FUNCTION

FUNCTION t804_bp_refresh()
#  DISPLAY ARRAY g_rai TO s_rai.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#     BEFORE DISPLAY
#        CALL SET_COUNT(g_rec_b+1)
#        CALL fgl_set_arr_curr(g_rec_b+1)
#        CALL cl_show_fld_cont()
#        EXIT DISPLAY
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#  END DISPLAY
 
END FUNCTION
 

FUNCTION t804_rah06()
DEFINE l_gen02    LIKE gen_file.gen02

#   LET g_errno = ' '
#   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rah.rah06 AND genacti = 'Y'
#
#   CASE
#      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'proj-15'
#      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#   DISPLAY l_gen02 TO rah06_desc
END FUNCTION
  
FUNCTION t804_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rah.rahconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rah.rahconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t804_show()
 
  #IF g_rah.rahconf = 'Y' THEN
  #   CALL cl_err('','art-022',0)
  #   RETURN
  #END IF 
   
   IF cl_exp(0,0,g_rah.rahacti) THEN
      LET g_chr=g_rah.rahacti
      IF g_rah.rahacti='Y' THEN
         LET g_rah.rahacti='N'
      ELSE
         LET g_rah.rahacti='Y'
      END IF
 
      UPDATE rah_file SET rahacti=g_rah.rahacti,
                          rahmodu=g_user,
                          rahdate=g_today
       WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
         AND rahplant = g_rah.rahplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rah_file",g_rah.rah01,"",SQLCA.sqlcode,"","",1) 
         LET g_rah.rahacti=g_chr
      END IF
   END IF
 
   CLOSE t804_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rah.rah01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rahacti,rahmodu,rahdate
     INTO g_rah.rahacti,g_rah.rahmodu,g_rah.rahdate FROM rah_file
    WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
      AND rahplant = g_rah.rahplant

   DISPLAY BY NAME g_rah.rahacti,g_rah.rahmodu,g_rah.rahdate
 
END FUNCTION
 
FUNCTION t804_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rah.* FROM rah_file
     WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
      AND rahplant = g_rah.rahplant
 
   IF g_rah.rahconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rah.rahconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rah.rahacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
   IF g_aza.aza88='Y' THEN
     #FUN-B40071 --START--
      #IF NOT (g_rah.rahacti='N' AND g_rah.rahpos='Y') THEN
      #   CALL cl_err('', 'art-648', 1) #NO.FUN-B40071         
      #   RETURN
      #END IF
      IF NOT ((g_rah.rahpos='3' AND g_rah.rahacti='N') 
                 OR (g_rah.rahpos='1'))  THEN                  
         CALL cl_err('','apc-139',0)            
         RETURN
      END IF      
     #FUN-B40071 --END--
   END IF
  
   BEGIN WORK
 
   OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t804_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL      
       LET g_doc.column1 = "rah01"      
       LET g_doc.value1 = g_rah.rah01    
       CALL cl_del_doc()              
      DELETE FROM rah_file WHERE rah02 = g_rah.rah02 AND rah01 = g_rah.rah01
                             AND rahplant = g_rah.rahplant
      DELETE FROM rai_file WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                             AND raiplant = g_rah.rahplant 
      DELETE FROM raj_file WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                             AND rajplant = g_rah.rahplant
      DELETE FROM raq_file WHERE raq02 = g_rah.rah02 AND raq01 = g_rah.rah01
                             AND raqplant = g_rah.rahplant AND raq03 = '3'

      CLEAR FORM
      CALL g_rai.clear() 
      CALL g_raj.clear()

      OPEN t804_count
      FETCH t804_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t804_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t804_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t804_fetch('/')
      END IF
   END IF
 
   CLOSE t804_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rah.rah01,'D')
END FUNCTION
 
FUNCTION t804_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc05         LIKE pmc_file.pmc05,
    l_pmc30         LIKE pmc_file.pmc30
 
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_azp03   LIKE azp_file.azp03
DEFINE l_line    LIKE type_file.num5
DEFINE l_sql1    STRING
DEFINE l_bamt    LIKE type_file.num5
DEFINE l_rxx04   LIKE rxx_file.rxx04
 
DEFINE l_price    LIKE rai_file.rai05
DEFINE l_discount LIKE rai_file.rai06

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rah.rah02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rah.* FROM rah_file
     WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
       AND rahplant = g_rah.rahplant
 
    IF g_rah.rahacti ='N' THEN
       CALL cl_err(g_rah.rah01||g_rah.rah02,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rah.rahconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rah.rahconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
    CALL s_showmsg_init()
 
    LET g_forupd_sql = "SELECT rai03,rai04,rai05,rai06,rai07,rai08,", 
                       "       rai09,raiacti", 
                       "  FROM rai_file ",
                       " WHERE rai01 = ? AND rai02=? AND rai03=? AND raiplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t804_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rai WITHOUT DEFAULTS FROM s_rai.*
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
 
           OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
           IF STATUS THEN
              CALL cl_err("OPEN t804_cl:", STATUS, 1)
              CLOSE t804_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t804_cl INTO g_rah.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
              CLOSE t804_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rai_t.* = g_rai[l_ac].*  #BACKUP
              LET g_rai_o.* = g_rai[l_ac].*  #BACKUP
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("rai03",FALSE)
              ELSE
                 CALL cl_set_comp_entry("rai03",TRUE)
              END IF   
              OPEN t804_bcl USING g_rah.rah01,g_rah.rah02,g_rai_t.rai03,g_rah.rahplant
              IF STATUS THEN
                 CALL cl_err("OPEN t804_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t804_bcl INTO g_rai[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rai_t.rai03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
          END IF 
          CALL t804_rai_entry()

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rai[l_ac].* TO NULL
           LET g_rai[l_ac].raiacti = 'Y'    
           LET g_rai[l_ac].rai07 = 'N'
           IF g_rah.rah10 = '2' THEN
              LET g_rai[l_ac].rai06 = 0 
              LET g_rai[l_ac].rai09 = 0 
           END IF
           IF p_cmd='u' THEN
              CALL cl_set_comp_entry("rai03",FALSE)
           ELSE
              CALL cl_set_comp_entry("rai03",TRUE)
           END IF   
           LET g_rai_t.* = g_rai[l_ac].*
           LET g_rai_o.* = g_rai[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rai03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
          #IF cl_null(g_rai[l_ac].rai04) AND cl_null(g_rai[l_ac].rai05)
          #   AND cl_null(g_rai[l_ac].rai06) THEN
          #   CALL cl_err('','art-629',0)
          #   DISPLAY BY NAME g_rai[l_ac].rai07
          #   NEXT FIELD rai04
          #END IF
          #IF g_rai[l_ac].rai07 IS NULL THEN LET g_rai[l_ac].rai07 = 0 END IF
           IF cl_null(g_rai[l_ac].rai06) THEN LET g_rai[l_ac].rai06 = 0  END IF
           IF cl_null(g_rai[l_ac].rai09) THEN LET g_rai[l_ac].rai09 = 0  END IF
           INSERT INTO rai_file(rai01,rai02,rai03,rai04,rai05,rai06,
                                rai07,rai08,rai09,raiacti,raiplant,railegal)   
           VALUES(g_rah.rah01,g_rah.rah02,
                  g_rai[l_ac].rai03,g_rai[l_ac].rai04,
                  g_rai[l_ac].rai05,g_rai[l_ac].rai06,
                  g_rai[l_ac].rai07,g_rai[l_ac].rai08,
                  g_rai[l_ac].rai09,g_rai[l_ac].raiacti,
                  g_rah.rahplant,g_rah.rahlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rai_file",g_rah.rah01,g_rai[l_ac].rai03,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              IF p_cmd='u' THEN
                 CALL t804_upd_log()
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rai03
           IF g_rai[l_ac].rai03 IS NULL OR g_rai[l_ac].rai03 = 0 THEN
              SELECT max(rai03)+1
                INTO g_rai[l_ac].rai03
                FROM rai_file
               WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                 AND raiplant = g_rah.rahplant
              IF g_rai[l_ac].rai03 IS NULL THEN
                 LET g_rai[l_ac].rai03 = 1
              END IF
           END IF
 
        AFTER FIELD rai03
           IF NOT cl_null(g_rai[l_ac].rai03) THEN
              IF g_rai[l_ac].rai03 != g_rai_t.rai03
                 OR g_rai_t.rai03 IS NULL THEN
                 SELECT COUNT(*)
                   INTO l_n
                   FROM rai_file
                  WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                    AND rai03 = g_rai[l_ac].rai03 AND raiplant = g_rah.rahplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rai[l_ac].rai03 = g_rai_t.rai03
                    NEXT FIELD rai02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rai04
         IF NOT cl_null(g_rai[l_ac].rai04) THEN
            IF g_rai_o.rai04 IS NULL OR
               (g_rai[l_ac].rai04 != g_rai_o.rai04 ) THEN
               IF g_rai[l_ac].rai04 <= 0 THEN
                  CALL cl_err(g_rai[l_ac].rai04,'aec-020',0)
                  LET g_rai[l_ac].rai04= g_rai_o.rai04
                  NEXT FIELD rai04
               END IF
            END IF
         END IF

      ON CHANGE rai07
         IF NOT cl_null(g_rai[l_ac].rai07) THEN
            CALL t804_rai_entry()
         END IF         

      AFTER FIELD rai07
         IF g_rai[l_ac].rai07 = 'Y' THEN
            LET g_rai[l_ac].rai08 = ''
            LET g_rai[l_ac].rai09 = 0
            DISPLAY BY NAME g_rai[l_ac].rai08,g_rai[l_ac].rai09
         ELSE 
            IF g_rah.rah10 = '3' AND g_rai[l_ac].rai09 <= 0 THEN
              CALL cl_err('','art-180',0)
              NEXT FIELD rai09
            END IF
            IF g_rah.rah10 = '2' AND g_rai[l_ac].rai08 IS NULL THEN
              NEXT FIELD rai08
            END IF
         END IF
      BEFORE FIELD rai05,rai06,rai08,rai09
         IF NOT cl_null(g_rai[l_ac].rai07) THEN
            CALL t804_rai_entry()
         END IF

      AFTER FIELD rai05,rai09    #特賣價
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-180',0)
            NEXT FIELD CURRENT
         ELSE
           #CASE 
           #  WHEN INFIELD(rai05)
           #       LET g_rai[l_ac].rai06 = l_price/l_stdprice*100
           #  WHEN INFIELD(rai09)
           #       LET g_rai[l_ac].rai10 = l_price/l_memprice*100
           #END CASE
            DISPLAY BY NAME g_rai[l_ac].rai05,g_rai[l_ac].rai09
           #DISPLAY BY NAME CURRENT
         END IF

      AFTER FIELD rai06   #折扣率
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
             #CASE 
             #  WHEN INFIELD(rai06)
             #       LET g_rai[l_ac].rai07 = l_stdprice*l_discount/100
             #  WHEN INFIELD(rai10)
             #       LET g_rai[l_ac].rai11 = l_memprice*l_discount/100
             #END CASE
              DISPLAY BY NAME g_rai[l_ac].rai06
           END IF

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rai_t.rai03 > 0 AND g_rai_t.rai03 IS NOT NULL THEN
             #LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rah.rah01,"' AND rxx03='1'"
             #PREPARE t804_prxx04 FROM l_sql1
             #DECLARE t804_crxx04 CURSOR FOR t804_prxx04
             #LET l_bamt=0
             #FOREACH t804_crxx04 INTO l_rxx04
             #    LET l_bamt=l_rxx04+l_bamt
             #END FOREACH 
             #IF l_bamt>0 THEN
             #   CALL cl_err('','art-634',1) 
             #   CANCEL DELETE
             #END IF 
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rai_file
               WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                 AND rai03 = g_rai_t.rai03  AND raiplant = g_rah.rahplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rai_file",g_rah.rah01,g_rai_t.rai03,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 #FUN-B80085增加空白行
                
 
               	 DELETE FROM raj_file 
               	  WHERE raj01 = g_rah.rah01   AND raj02 = g_rah.rah02
                    AND raj03 = g_rai_t.rai03 AND rajplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","raj_file",g_rah.rah01,g_rai_t.rai03,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF 
              END IF
              CALL t804_upd_log() 
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rai[l_ac].* = g_rai_t.*
              CLOSE t804_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_rai[l_ac].rai04) THEN
              NEXT FIELD rai04
           END IF
          #IF NOT cl_null(g_rai[l_ac].rai04) THEN
              
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rai[l_ac].rai03,-263,1)
              LET g_rai[l_ac].* = g_rai_t.*
           ELSE
              UPDATE rai_file SET rai04  =g_rai[l_ac].rai04,
                                  rai05  =g_rai[l_ac].rai05,
                                  rai06  =g_rai[l_ac].rai06,
                                  rai07  =g_rai[l_ac].rai07,
                                  rai08  =g_rai[l_ac].rai08,
                                  rai09  =g_rai[l_ac].rai09,
                                  raiacti=g_rai[l_ac].raiacti
               WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01
                 AND rai03=g_rai_t.rai03 AND raiplant = g_rah.rahplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rai_file",g_rah.rah01,g_rai_t.rai03,SQLCA.sqlcode,"","",1) 
                 LET g_rai[l_ac].* = g_rai_t.*
              ELSE
                 MESSAGE 'UPDATE rai_file O.K'
                 CALL t804_upd_log() 
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
                 LET g_rai[l_ac].* = g_rai_t.*
              END IF
              CLOSE t804_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CALL t804_repeat(g_rai[l_ac].rai03)  #check
           CLOSE t804_bcl
           COMMIT WORK
 
        ON ACTION Memberlevel    #會員等級促銷
           #IF cl_chk_act_auth() THEN
           #   CALL t8042_sales()
           #END IF

        ON ACTION CONTROLO
           IF INFIELD(rai03) AND l_ac > 1 THEN
              LET g_rai[l_ac].* = g_rai[l_ac-1].*
              LET g_rai[l_ac].rai03 = g_rec_b + 1
              NEXT FIELD rai04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
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
    
    UPDATE rah_file SET rahmodu = g_rah.rahmodu,rahdate = g_rah.rahdate
      WHERE rah01 = g_rah.rah01
        AND rah02 = g_rah.rah02
        AND rahplant = g_rah.rahplant 
    DISPLAY BY NAME g_rah.rahmodu,g_rah.rahdate
    CLOSE t804_bcl
    COMMIT WORK
    CALL s_showmsg()
    CALL t804_delall()
 
END FUNCTION

FUNCTION t804_upd_log()
   LET g_rah.rahmodu = g_user
   LET g_rah.rahdate = g_today
   UPDATE rah_file SET rahmodu = g_rah.rahmodu,
                       rahdate = g_rah.rahdate
    WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
      AND rahplant = g_rah.rahplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rah_file",g_rah.rahmodu,g_rah.rahdate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rah.rahmodu,g_rah.rahdate
   MESSAGE 'UPDATE rah_file O.K.'
END FUNCTION

FUNCTION t804_chktime(p_time)  #check 時間格式
DEFINE p_time LIKE type_file.chr5
DEFINE l_hour LIKE type_file.num5
DEFINE l_min  LIKE type_file.num5
 
      LET g_errno=''
      IF p_time[1,1] MATCHES '[012]' AND
         p_time[2,2] MATCHES '[0123456789]' AND
         p_time[3,3] =':' AND
         p_time[4,4] MATCHES '[012345]' AND 
         p_time[5,5] MATCHES '[0123456789]' THEN
         IF p_time[1,2]<'00' OR p_time[1,2]>='24' OR
            p_time[4,5]<'00' OR p_time[4,5]>='60' THEN
            LET g_errno='art-209' 
         END IF
      ELSE
         LET g_errno='art-209'
      END IF
      IF cl_null(g_errno) THEN         
         LET l_hour=p_time[1,2]
         LET l_min = p_time[4,5]
         RETURN l_hour*60+l_min
      ELSE
         RETURN NULL
      END IF
END FUNCTION


FUNCTION t804_rai_entry()
DEFINE p_rai04    LIKE rai_file.rai04   

          CASE g_rah.rah10
             WHEN '2'
                CALL cl_set_comp_entry("rai05",TRUE)
                CALL cl_set_comp_entry("rai06",FALSE)
                CALL cl_set_comp_required("rai05",TRUE)
             WHEN '3'
                CALL cl_set_comp_entry("rai05",FALSE)
                CALL cl_set_comp_entry("rai06",TRUE)
                CALL cl_set_comp_required("rai06",TRUE)
             OTHERWISE
                CALL cl_set_comp_entry("rai05",TRUE)
                CALL cl_set_comp_entry("rai06",TRUE)
                CALL cl_set_comp_required("rai05",TRUE)
                CALL cl_set_comp_required("rai06",TRUE)
          END CASE
           
          IF g_rai[l_ac].rai07='Y' THEN
             CALL cl_set_comp_entry("rai08,rai09",FALSE)
          ELSE
             CASE g_rah.rah10
                WHEN '2'
                   CALL cl_set_comp_entry("rai08",TRUE)
                   CALL cl_set_comp_entry("rai09",FALSE)
                   CALL cl_set_comp_required("rai08",TRUE)
                WHEN '3'
                   CALL cl_set_comp_entry("rai08",FALSE)
                   CALL cl_set_comp_entry("rai09",TRUE)
                   CALL cl_set_comp_required("rai09",TRUE)
                OTHERWISE
                   CALL cl_set_comp_entry("rai08",TRUE)
                   CALL cl_set_comp_entry("rai09",TRUE)
                   CALL cl_set_comp_required("rai08",TRUE)
                   CALL cl_set_comp_required("rai09",TRUE)
             END CASE
          END IF

END FUNCTION

FUNCTION t804_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rai_file
    WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
      AND raiplant = g_rah.rahplant
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rah_file WHERE rah01 = g_rah.rah01 AND rah02=g_rah.rah02 AND rahplant=g_rah.rahplant
      DELETE FROM raq_file WHERE raq01 = g_rah.rah01 AND raq02=g_rah.rah02 
                             AND raq03='3' AND raqplant=g_rah.rahplant
      CALL g_rai.clear()
   END IF
END FUNCTION

FUNCTION t804_b1()
DEFINE
    l_ac1_t         LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rah.rah02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rah.* FROM rah_file
     WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
       AND rahplant = g_rah.rahplant
 
    IF g_rah.rahacti ='N' THEN
       CALL cl_err(g_rah.rah01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rah.rahconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rah.rahconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
    CALL s_showmsg_init()

  
    LET g_forupd_sql = "SELECT raj03,raj04,raj05,'',raj06,'',rajacti", 
                       "  FROM raj_file ",
                       " WHERE raj01=? AND raj02=? AND raj03=? AND raj04=? AND rajplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t8041_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_raj WITHOUT DEFAULTS FROM s_raj.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
           IF STATUS THEN
              CALL cl_err("OPEN t804_cl:", STATUS, 1)
              CLOSE t804_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t804_cl INTO g_rah.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
              CLOSE t804_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_raj_t.* = g_raj[l_ac1].*  #BACKUP
              LET g_raj_o.* = g_raj[l_ac1].*  #BACKUP
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("raj03",FALSE)
              ELSE
                 CALL cl_set_comp_entry("raj03",TRUE)
              END IF 
              OPEN t8041_bcl USING g_rah.rah01,g_rah.rah02,g_raj_t.raj03,g_raj_t.raj04,g_rah.rahplant
              IF STATUS THEN
                 CALL cl_err("OPEN t8041_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t8041_bcl INTO g_raj[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_raj_t.raj03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t804_raj04()
                 CALL t804_raj05('d')
                 CALL t804_raj06('d')
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_raj[l_ac1].* TO NULL

           LET g_raj[l_ac1].rajacti = 'Y'            #Body default
           LET g_raj_t.* = g_raj[l_ac1].*
           LET g_raj_o.* = g_raj[l_ac1].*
           IF p_cmd='u' THEN
              CALL cl_set_comp_entry("raj03",FALSE)
           ELSE
              CALL cl_set_comp_entry("raj03",TRUE)
           END IF 
           CALL cl_show_fld_cont()
           NEXT FIELD raj03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO raj_file(raj01,raj02,raj03,raj04,raj05,raj06,
                                rajacti,rajplant,rajlegal)   
           VALUES(g_rah.rah01,g_rah.rah02,
                  g_raj[l_ac1].raj03,g_raj[l_ac1].raj04,
                  g_raj[l_ac1].raj05,g_raj[l_ac1].raj06,
                  g_raj[l_ac1].rajacti,
                  g_rah.rahplant,g_rah.rahlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","raj_file",g_rah.rah01,g_raj[l_ac1].raj03,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
           END IF
 
       BEFORE FIELD raj03
          IF g_raj[l_ac1].raj03 IS NULL OR g_raj[l_ac1].raj03 = 0 THEN
             SELECT MAX(raj03)
               INTO g_raj[l_ac1].raj03
               FROM raj_file
              WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                AND rajplant = g_rah.rahplant
             IF g_raj[l_ac1].raj03 IS NULL THEN
                LET g_raj[l_ac1].raj03 = 1
             END IF
          END IF
 
       AFTER FIELD raj03
          IF NOT cl_null(g_raj[l_ac1].raj03) THEN
             IF g_raj[l_ac1].raj03 != g_raj_t.raj03
                OR g_raj_t.raj03 IS NULL THEN
                SELECT COUNT(*)
                  INTO l_n
                  FROM raj_file
                 WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                   AND raj03 = g_raj[l_ac1].raj03 AND raj04 = g_raj[l_ac1].raj04 AND rajplant = g_rah.rahplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_raj[l_ac1].raj03 = g_raj_t.raj03
                   NEXT FIELD raj03
                END IF
             END IF
          END IF
 
      AFTER FIELD raj04
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            IF g_raj_o.raj04 IS NULL OR
               (g_raj[l_ac1].raj04 != g_raj_o.raj04 ) THEN
                SELECT COUNT(*)
                  INTO l_n
                  FROM raj_file
                 WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                   AND raj03 = g_raj[l_ac1].raj03 AND raj04 = g_raj[l_ac1].raj04 AND rajplant = g_rah.rahplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_raj[l_ac1].raj04 = g_raj_t.raj04
                   NEXT FIELD raj04
                END IF
               CALL t804_raj04() 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_raj[l_ac1].raj04,g_errno,0)
                  LET g_raj[l_ac1].raj04 = g_raj_o.raj04
                  NEXT FIELD raj04
               END IF
            END IF  
         END IF  

      ON CHANGE raj04
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            CALL t804_raj04()   
         END IF
  
      BEFORE FIELD raj05,raj06
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            IF g_raj[l_ac1].raj04='1' THEN
               CALL cl_set_comp_entry("raj06",TRUE)
               CALL cl_set_comp_required("raj06",TRUE)
            ELSE
               CALL cl_set_comp_entry("raj06",FALSE)
            END IF
         END IF

      AFTER FIELD raj05
         IF NOT cl_null(g_raj[l_ac1].raj05) THEN
            IF g_raj_o.raj05 IS NULL OR
               (g_raj[l_ac1].raj05 != g_raj_o.raj05 ) THEN
               CALL t804_raj05('a') 
               CALL t804sub_chk('3',g_rah.rahplant,g_raj[l_ac1].raj04,g_raj[l_ac1].raj05,g_raj[l_ac1].raj06,g_rah.rah04,
                           g_rah.rah05,g_rah.rah06,g_rah.rah07)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_raj[l_ac1].raj05,g_errno,0)
                  LET g_raj[l_ac1].raj05 = g_raj_o.raj05
                  NEXT FIELD raj05
               END IF
            END IF  
         END IF  

      AFTER FIELD raj06
         IF NOT cl_null(g_raj[l_ac1].raj06) THEN
            IF g_raj_o.raj06 IS NULL OR
               (g_raj[l_ac1].raj06 != g_raj_o.raj06 ) THEN
               CALL t804_raj06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_raj[l_ac1].raj06,g_errno,0)
                  LET g_raj[l_ac1].raj06 = g_raj_o.raj06
                  NEXT FIELD raj06
               END IF
            END IF  
         END IF
        
        
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_raj_t.raj03 > 0 AND g_raj_t.raj03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM raj_file
               WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                 AND raj03 = g_raj_t.raj03 AND raj04 = g_raj_t.raj04 
                 AND rajplant = g_rah.rahplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","raj_file",g_rah.rah01,g_raj_t.raj03,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_raj[l_ac1].* = g_raj_t.*
              CLOSE t8041_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_raj[l_ac1].raj03,-263,1)
              LET g_raj[l_ac1].* = g_raj_t.*
           ELSE
              UPDATE raj_file SET raj05=g_raj[l_ac1].raj05,
                                  raj06=g_raj[l_ac1].raj06,
                                  rajacti=g_raj[l_ac1].rajacti
               WHERE raj02 = g_rah.rah02 AND raj01=g_rah.rah01
                 AND raj03=g_raj_t.raj03 AND raj04=g_raj_t.raj04 AND rajplant = g_rah.rahplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","raj_file",g_rah.rah01,g_raj_t.raj03,SQLCA.sqlcode,"","",1) 
                 LET g_raj[l_ac1].* = g_raj_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
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
                 LET g_raj[l_ac1].* = g_raj_t.*
              END IF
              CLOSE t8041_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CALL t804_repeat(g_raj[l_ac1].raj03)  #check
           CLOSE t8041_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(raj03) AND l_ac1 > 1 THEN
              LET g_raj[l_ac1].* = g_raj[l_ac1-1].*
              NEXT FIELD raj03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(raj05)
                 CALL cl_init_qry_var()
                 CASE g_raj[l_ac1].raj04
                    WHEN '1'
                       IF cl_null(g_rtz05) THEN
                          LET g_qryparam.form="q_ima"
                       ELSE
                          LET g_qryparam.form = "q_rtg03_1" 
                          LET g_qryparam.arg1 = g_rtz05  
                       END IF
                    WHEN '2'
                       LET g_qryparam.form ="q_oba01"
                    WHEN '3'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '1'
                    WHEN '4'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '2'
                    WHEN '5'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '3'
                    WHEN '6'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '4'
                    WHEN '7'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '5'
                    WHEN '8'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '6'
                    WHEN '9'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '27'
                 END CASE
                 LET g_qryparam.default1 = g_raj[l_ac1].raj05
                 CALL cl_create_qry() RETURNING g_raj[l_ac1].raj05
                 CALL t804_raj05('d')
                 NEXT FIELD raj05
              WHEN INFIELD(raj06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_raj[l_ac1].raj06
                 CALL cl_create_qry() RETURNING g_raj[l_ac1].raj06
                 CALL t804_raj06('d')
                 NEXT FIELD raj06
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
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
     
    CALL t804_upd_log() 
    
    CLOSE t8041_bcl
    COMMIT WORK
    CALL s_showmsg()
 
END FUNCTION

FUNCTION t804_compute()
DEFINE l_ima25       LIKE ima_file.ima25
DEFINE l_flag    LIKE type_file.num5                                                                                           
DEFINE l_fac     LIKE ima_file.ima31_fac

   LET g_errno = ' '
   IF cl_null(g_raj[l_ac1].raj03) OR cl_null(g_raj[l_ac1].raj05) THEN RETURN END IF
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_raj[l_ac1].raj03
   CALL s_umfchk(g_raj[l_ac1].raj03,g_raj[l_ac1].raj05,l_ima25)
      RETURNING l_flag,l_fac
   IF l_flag = 1 THEN 
      LET g_errno = 'art-032'  
   ELSE
      LET g_raj[l_ac1].raj06 = l_fac
   END IF
END FUNCTION

#No.TQC-A20011--begin
FUNCTION t804_check_rai04()
DEFINE l_n          LIKE type_file.num5
   
#   LET g_errno=''
#   SELECT COUNT(*) INTO l_n FROM rai_file 
#    WHERE rai01=g_rah.rah01 
#      AND raiplant=g_rah.rahplant
#      AND rai04=g_rai[l_ac].rai04
#   IF l_n>0 THEN 
#      LET g_errno='art-642'
#   END IF 
END FUNCTION 

FUNCTION t804_check_rai05()
DEFINE l_n          LIKE type_file.num5
   
#   LET g_errno=''
#   SELECT COUNT(*) INTO l_n FROM rai_file 
#    WHERE rai01=g_rah.rah01 
#      AND raiplant=g_rah.rahplant 
#      AND rai05=g_rai[l_ac].rai05
#   IF l_n>0 THEN 
#      LET g_errno='art-642'
#   END IF 
END FUNCTION  
#No.TQC-A20011--end

FUNCTION t804_rai04()
DEFINE l_oga51      LIKE oga_file.oga51
DEFINE l_oga02      LIKE oga_file.oga02

#   LET g_errno = ' '
#   SELECT oga16 INTO g_rai[l_ac].rai05 FROM oga_file
#      WHERE oga01 = g_rai[l_ac].rai04
#        AND ogaconf = 'Y'
#   CASE 
#      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'abx-002'
#      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
#   END CASE
#   IF NOT cl_null(g_errno) THEN RETURN END IF
#   SELECT SUM(rxx04) INTO g_rai[l_ac].rai07 FROM rxx_file
#        WHERE rxx00 = '02' AND rxx01 = g_rai[l_ac].rai04
#   IF g_rai[l_ac].rai05 IS NOT NULL THEN
#      CALL cl_set_comp_entry("rai05",FALSE)
#   END IF
END FUNCTION

FUNCTION t804_rai04_3()
DEFINE l_oga02      LIKE oga_file.oga02

#   LET g_errno = ' '
#   IF  g_rai[l_ac].rai03 IS NULL OR  g_rai[l_ac].rai04 IS NULL THEN RETURN END IF
#   SELECT oga02 INTO l_oga02 FROM oga_file
#      WHERE oga01 = g_rai[l_ac].rai04
#        AND ogaconf = 'Y'
#   IF l_oga02 != g_rai[l_ac].rai03 THEN LET g_errno = 'art-914' END IF
END FUNCTION

FUNCTION t804_kehu(p_flag)
DEFINE p_flag        LIKE type_file.chr1
DEFINE l_rai04       LIKE rai_file.rai04
DEFINE l_rai05       LIKE rai_file.rai05
DEFINE l_oga87       LIKE oga_file.oga87
DEFINE l_old_oga87   LIKE oga_file.oga87

   LET g_errno = ' '

#   IF p_flag = '1' THEN
#      SELECT oga87 INTO l_oga87 FROM oga_file   
#         WHERE oga01 = g_rai[l_ac].rai04
#   END IF
#   IF p_flag = '2' THEN
#      SELECT oea87 INTO l_oga87 FROM oea_file   
#         WHERE oea01 = g_rai[l_ac].rai05
#   END IF
#
#   LET g_sql = "SELECT rai04,rai05 FROM rai_file ",
#               "  WHERE rai02 = '",g_rah.rah02,"' ",
#               "    AND rai01 = '",g_rah.rah01,"' ",
#               "    AND raiplant = '",g_rah.rahplant,"'"
#   PREPARE pre_sel_rai04 FROM g_sql
#   DECLARE cur_rai04 CURSOR FOR pre_sel_rai04
#   FOREACH cur_rai04 INTO l_rai04,l_rai05
#      IF l_rai04 IS NOT NULL THEN 
#         SELECT oga87 INTO l_old_oga87 FROM oga_file   
#            WHERE oga01 = l_rai04
#      ELSE
#         IF l_rai05 IS NOT NULL THEN 
#            SELECT oea87 INTO l_old_oga87 FROM oea_file   
#               WHERE oea01 = l_rai05
#         END IF
#      END IF
#      IF NOT cl_null(l_oga87) AND NOT cl_null(l_old_oga87) THEN
#         IF l_oga87 != l_old_oga87 THEN
#            LET g_errno = 'art-913'
#            EXIT FOREACH
#         END IF
#      END IF
#   END FOREACH
END FUNCTION

FUNCTION t804_check()
DEFINE l_sql STRING
DEFINE l_n LIKE type_file.num5
DEFINE l_rwj05 LIKE rwj_file.rwj05
DEFINE l_rwj06 LIKE rwj_file.rwj06
 
    LET g_errno =''
   IF NOT cl_null(g_rah.rah04) AND NOT cl_null(g_rah.rah05) AND
      NOT cl_null(g_rah.rah06) AND NOT cl_null(g_rah.rah07) THEN
      SELECT COUNT(*) INTO l_n FROM raq_file
       WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02
         AND raq03 = '3'
         AND raqplant = g_rah.rahplant AND raq04 = g_rah.rahplant
      IF l_n >0  THEN
       LET l_sql = "SELECT ima01 FROM rwj_file ",
                   " WHERE rwj01 = ? AND rwj02 = ? ",
                   "   AND rwjplant = ? "
       PREPARE rwj_chk_pre1 FROM l_sql
       DECLARE rwj_chk1 CURSOR FOR rwj_chk_pre1
       FOREACH rwj_chk1 USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
                        INTO l_rwj05,l_rwj06
         IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach rwj_chk1:',SQLCA.sqlcode,0)    
            EXIT FOREACH                     
         END IF
         #CALL t804sub_chk('1',g_rah.rahplant,l_rwj05,l_rwj06,g_rah.rah04,
         #                  g_rah.rah05,g_rah.rah06,g_rah.rah07)
         IF NOT cl_null(g_errno) THEN
            LET g_errno = 'art-218'
            EXIT FOREACH
         END IF
        END FOREACH
      END IF
    END IF     
END FUNCTION

FUNCTION t804_rai05()
DEFINE l_oea62      LIKE oea_file.oea62

#   LET g_errno = ' '
#   SELECT oea62 INTO l_oea62 FROM oea_file
#      WHERE oea01 = g_rai[l_ac].rai05
#        AND oeaconf = 'Y'
#   CASE 
#      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'asf-500'
#      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
#   END CASE
#   IF g_rai[l_ac].rai07 IS NULL THEN
#      SELECT SUM(rxx04) INTO g_rai[l_ac].rai07 FROM rxx_file
#          WHERE rxx00 = '01' AND rxx01 = g_rai[l_ac].rai05
#   END IF  
END FUNCTION

FUNCTION t804_raj04()

   IF g_raj[l_ac1].raj04='1' THEN
      CALL cl_set_comp_entry("raj06",TRUE)
      CALL cl_set_comp_required("raj06",TRUE)
   ELSE
      CALL cl_set_comp_entry("raj06",FALSE)
      CALL cl_set_comp_required("raj06",FALSE)
      LET g_raj[l_ac1].raj06=NULL
      LET g_raj[l_ac1].raj06_desc=NULL
   END IF

   DISPLAY BY NAME g_raj[l_ac1].raj06,g_raj[l_ac1].raj06_desc
END FUNCTION

FUNCTION t804_raj05(p_cmd)
DEFINE l_n         LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1 

DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06

   LET g_errno = ' '
   
   CASE g_raj[l_ac1].raj04
      WHEN '1'
         IF cl_null(g_rtz05) THEN
            SELECT DISTINCT ima02,ima25,imaacti
              INTO l_ima02,l_ima25,l_imaacti
              FROM ima_file
             WHERE ima01=g_raj[l_ac1].raj05  
            CASE
               WHEN SQLCA.sqlcode=100   LET g_errno=100
                                        LET l_ima02=NULL
               WHEN l_imaacti='N'       LET g_errno='9028'
               OTHERWISE
               LET g_errno=SQLCA.sqlcode USING '------'
            END CASE
         ELSE
            SELECT DISTINCT ima02,ima25,rte07
              INTO l_ima02,l_ima25,l_imaacti
              FROM ima_file,rte_file
             WHERE ima01 = rte03 AND ima01=g_raj[l_ac1].raj05  
            CASE
               WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                        LET l_ima02=NULL
               WHEN l_imaacti='N'       LET g_errno='9028'
               OTHERWISE
               LET g_errno=SQLCA.sqlcode USING '------'
            END CASE
         END IF
      WHEN '2'
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_raj[l_ac1].raj05 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '3'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[l_ac1].raj05 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '4'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[l_ac1].raj05 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '5'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[l_ac1].raj05 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '6'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[l_ac1].raj05 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '7'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[l_ac1].raj05 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '8'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[l_ac1].raj05 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '9'
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[l_ac1].raj05 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_raj[l_ac1].raj04
         WHEN '1'
            LET g_raj[l_ac1].raj05_desc = l_ima02
            IF cl_null(g_raj[l_ac1].raj06) THEN
               LET g_raj[l_ac1].raj06      = l_ima25
            END IF
            SELECT gfe02 INTO g_raj[l_ac1].raj06_desc FROM gfe_file
             WHERE gfe01=g_raj[l_ac1].raj06 AND gfeacti='Y'
         WHEN '2'
            LET g_raj[l_ac1].raj06 = ''
            LET g_raj[l_ac1].raj06_desc = ''
            LET g_raj[l_ac1].raj05_desc = l_oba02
         WHEN '9'
            LET g_raj[l_ac1].raj06 = ''
            LET g_raj[l_ac1].raj06_desc = ''
            LET g_raj[l_ac1].raj05_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_raj[l_ac1].raj05_desc = g_raj[l_ac1].raj05_desc,"BETWEEN ",l_tqa02 CLIPPED," AND "
            LET l_tqa02 = l_tqa06
            LET g_raj[l_ac1].raj05_desc = g_raj[l_ac1].raj05_desc,l_tqa02 CLIPPED
         OTHERWISE
            LET g_raj[l_ac1].raj06 = ''
            LET g_raj[l_ac1].raj06_desc = ''
            LET g_raj[l_ac1].raj05_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_raj[l_ac1].raj05_desc,g_raj[l_ac1].raj06,g_raj[l_ac1].raj06_desc
   END IF

END FUNCTION

FUNCTION t804_raj06(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1   
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti

   LET g_errno = ' '
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file 
    WHERE gfe01 = g_raj[l_ac1].raj06 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      LET g_raj[l_ac1].raj06_desc=l_gfe02
      DISPLAY BY NAME g_raj[l_ac1].raj06_desc
   END IF    
END FUNCTION 
 

FUNCTION t804_copy()
   DEFINE l_newno     LIKE rah_file.rah01,
          l_oldno     LIKE rah_file.rah01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t804_set_entry('a')
# 
#   CALL cl_set_head_visible("","YES")
#   INPUT l_newno FROM rah01
#       BEFORE INPUT
#         CALL cl_set_docno_format("rah01")
#         
#       AFTER FIELD rah01
#          IF l_newno IS NULL THEN
#             NEXT FIELD rah01
#          ELSE 
#      	     CALL s_check_no("art",l_newno,"","9","rah_file","rah01","")                                                           
#                RETURNING li_result,l_newno                                                                                        
#             IF (NOT li_result) THEN                                                                                               
#                NEXT FIELD rah01                                                                                                   
#             END IF                                                                                                                
#             BEGIN WORK                                                                                                            
#             CALL s_auto_assign_no("axm",l_newno,g_today,"","rah_file","rah01",g_plant,"","")                                           
#                RETURNING li_result,l_newno  
#             IF (NOT li_result) THEN                                                                                               
#                ROLLBACK WORK                                                                                                      
#                NEXT FIELD rah01                                                                                                   
#             ELSE                                                                                                                  
#                COMMIT WORK                                                                                                        
#             END IF
#          END IF
#      ON ACTION controlp
#         CASE 
#            WHEN INFIELD(rah01)                                                                                                      
#              LET g_t1=s_get_doc_no(g_rah.rah01)                                                                                    
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','9') RETURNING g_t1                                                                 
#              LET l_newno = g_t1                                                                                                
#              DISPLAY l_newno TO rah01                                                                                           
#              NEXT FIELD rah01
#         END CASE 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#     ON ACTION about
#        CALL cl_about()
# 
#     ON ACTION HELP
#        CALL cl_show_help()
# 
#     ON ACTION controlg
#        CALL cl_cmdask()
# 
#   END INPUT
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      DISPLAY BY NAME g_rah.rah01
#      ROLLBACK WORK
#      RETURN
#   END IF
#   BEGIN WORK
# 
#   DROP TABLE y
# 
#   SELECT * FROM rah_file
#       WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
#         AND rahplant = g_rah.rahplant
#       INTO TEMP y
# 
#   UPDATE y
#       SET rah01=l_newno,
#           rahplant=g_plant, 
#           rahlegal=g_legal,
#           rahconf = 'N',
#           rahcond = NULL,
#           rahconu = NULL,
#           rahuser=g_user,
#           rahgrup=g_grup,
#           rahmodu=NULL,
#           rahdate=g_today,
#           rahacti='Y',
#           rahcrat=g_today ,
#           rahoriu = g_user,
#           rahorig = g_grup
#           
#   INSERT INTO rah_file SELECT * FROM y
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","rah_file","","",SQLCA.sqlcode,"","",1)
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   DROP TABLE x
# 
#   SELECT * FROM rai_file
#       WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01 
#         AND raiplant = g_rah.rahplant
#       INTO TEMP x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE x SET rai01=l_newno,
#                raiplant = g_plant,
#                railegal = g_legal 
# 
#   INSERT INTO rai_file
#       SELECT * FROM x
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","rai_file","","",SQLCA.sqlcode,"","",1) 
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF 
#    
#   DROP TABLE z
# 
#   SELECT * FROM raj_file
#       WHERE raj02 = g_rah.rah02 AND raj01=g_rah.rah01 
#         AND rajplant = g_rah.rahplant
#       INTO TEMP z
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE z SET raj01=l_newno,
#                rajplant = g_plant,
#                rajlegal = g_legal 
# 
#   INSERT INTO raj_file
#       SELECT * FROM z   
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","raj_file","","",SQLCA.sqlcode,"","",1)  
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF    
#   LET g_cnt=SQLCA.SQLERRD[3]
#   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
# 
#   LET l_oldno = g_rah.rah01
#   SELECT rah_file.* INTO g_rah.* FROM rah_file 
#      WHERE rah02=g_rah.rah02 AND rah01 = l_newno
#        AND rahplant = g_rah.rahplant
#   CALL t804_u()
#   CALL t804_b()
#   SELECT rah_file.* INTO g_rah.* FROM rah_file 
#       WHERE rah02=g_rah.rah02 AND rah01 = l_oldno 
#         AND rahplant = g_rah.rahplant
#
#   CALL t804_show()
# 
END FUNCTION
 
FUNCTION t804_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
#    IF g_wc IS NULL AND g_rah.rah01 IS NOT NULL THEN
#       LET g_wc = "rah01='",g_rah.rah01,"'"
#    END IF        
#     
#    IF g_wc IS NULL THEN
#       CALL cl_err('','9057',0)
#       RETURN
#    END IF
#                                                                                                                  
#    IF g_wc2 IS NULL THEN                                                                                                           
#       LET g_wc2 = ' 1=1'                                                                                                     
#    END IF                                                                                                                   
#                                                                                                                                    
#    LET l_cmd='p_query "artt804" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t804_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rah02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t804_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rah02",FALSE)
   END IF
 
END FUNCTION

FUNCTION t804_iss() 
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_dbs   LIKE azp_file.azp03   
DEFINE l_sql   STRING
DEFINE l_raq04 LIKE raq_file.raq04
DEFINE l_rtz11 LIKE rtz_file.rtz11
DEFINE l_rahlegal LIKE rah_file.rahlegal
DEFINE l_raq05    LIKE raq_file.raq05

  
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rah.rah02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
        AND rahplant = g_rah.rahplant
   IF g_rah.rahacti ='N' THEN
      CALL cl_err(g_rah.rah01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rah.rahconf = 'N' THEN
      CALL cl_err('','art-656',0)   #此筆資料未確認不可發布
      RETURN
   END IF

   IF g_rah.rahconf = 'X' THEN
      CALL cl_err('','art-661',0)
      RETURN
   END IF

   IF g_rah.rah01 <> g_plant THEN
      CALL cl_err('','art-663',1)
      RETURN
   END IF

   SELECT DISTINCT raq05 INTO l_raq05 FROM raq_file
    WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02 
      AND raq03 = '3' AND raqplant = g_rah.rahplant
   IF l_raq05 = 'Y' THEN
      CALL cl_err('','art-662',1)
      RETURN
   END IF
  
  DROP TABLE rah_temp
  DROP TABLE raq_temp
  DROP TABLE rai_temp
  DROP TABLE raj_temp
  DROP TABLE rap_temp
  DROP TABLE rar_temp
  DROP TABLE ras_temp
  SELECT * FROM rah_file WHERE 1 = 0 INTO TEMP rah_temp
  SELECT * FROM raj_file WHERE 1 = 0 INTO TEMP raj_temp
  SELECT * FROM rai_file WHERE 1 = 0 INTO TEMP rai_temp
  SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp  
  SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp  
  SELECT * FROM rar_file WHERE 1 = 0 INTO TEMP rar_temp  
  SELECT * FROM ras_file WHERE 1 = 0 INTO TEMP ras_temp  
 
   BEGIN WORK
   LET g_success = 'Y'

   OPEN t804_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM raq_file
    WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02
      AND raq03 = '3' AND raqplant = g_rah.rahplant
   IF l_cnt = 0 THEN
      CALL cl_err('','art-545',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM rai_file
    WHERE rai01 = g_rah.rah01 AND rai02 = g_rah.rah02
      AND raiplant = g_rah.rahplant 
   IF l_cnt = 0 THEN
      CALL cl_err('','art-548',0)
      RETURN
   END IF
   IF NOT cl_confirm('art-660') THEN 
       RETURN
   END IF     
   
   CALL s_showmsg_init()
 
   SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = g_plant

   LET l_sql="SELECT raq04 FROM raq_file ",
             " WHERE raq01=? AND raq02=?",
             "   AND raq03='3' AND raqacti='Y' AND raqplant=?"
   PREPARE raq_pre FROM l_sql
   DECLARE raq_cs CURSOR FOR raq_pre
   FOREACH raq_cs USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
                  INTO l_raq04  
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach raq_cs:',SQLCA.sqlcode,1)                         
      END IF   
      IF g_rah.rahplant<>l_raq04 THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file
          WHERE azw07 = g_rah.rahplant
            AND azw01 = l_raq04
         IF l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
      LET g_plant_new = l_raq04
      CALL s_gettrandbs()
      LET l_dbs=g_dbs_tra
      
      DELETE FROM rah_temp
      DELETE FROM rai_temp
      DELETE FROM raj_temp  
      DELETE FROM raq_temp
      DELETE FROM rap_temp
      DELETE FROM rar_temp
      DELETE FROM ras_temp

      UPDATE raq_file SET raq05='Y' 
       WHERE raq01=g_rah.rah01 AND raq02=g_rah.rah02
         AND raq03='3' AND raq04=l_raq04 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","raq_file",g_rah.rah01,"",STATUS,"","",1) 
         LET g_success = 'N'
      END IF
      IF g_rah.rahplant = l_raq04 THEN #與當前機構相同則不拋
         CONTINUE FOREACH
      ELSE
      #將數據放入臨時表中處理
         SELECT azw02 INTO l_rahlegal FROM azw_file
          WHERE azw01 = l_raq04 AND azwacti='Y'

         INSERT INTO rai_temp SELECT rai_file.* FROM rai_file
                               WHERE rai01 = g_rah.rah01 AND rai02 = g_rah.rah02
                                 AND raiplant = g_rah.rahplant
         UPDATE rai_temp SET raiplant=l_raq04,
                             railegal = l_rahlegal

         INSERT INTO raj_temp SELECT raj_file.* FROM raj_file
                               WHERE raj01 = g_rah.rah01 AND raj02 = g_rah.rah02
                                 AND rajplant = g_rah.rahplant
         UPDATE raj_temp SET rajplant=l_raq04,
                             rajlegal = l_rahlegal

         INSERT INTO rap_temp SELECT rap_file.* FROM rap_file
                               WHERE rap01 = g_rah.rah01 AND rap02 = g_rah.rah02
                                 AND rapplant = g_rah.rahplant
         UPDATE rap_temp SET rapplant=l_raq04,
                             raplegal = l_rahlegal

         INSERT INTO rar_temp SELECT rar_file.* FROM rar_file
                               WHERE rar01 = g_rah.rah01 AND rar02 = g_rah.rah02
                                 AND rarplant = g_rah.rahplant AND rar03 = '3'
         UPDATE rar_temp SET rarplant=l_raq04,
                             rarlegal = l_rahlegal

         INSERT INTO ras_temp SELECT ras_file.* FROM ras_file
                               WHERE ras01 = g_rah.rah01 AND ras02 = g_rah.rah02
                                 AND rasplant = g_rah.rahplant AND ras03 = '3'
         UPDATE ras_temp SET rasplant=l_raq04,
                             raslegal = l_rahlegal

         INSERT INTO rah_temp SELECT * FROM rah_file
          WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
            AND rahplant = g_rah.rahplant
         IF l_rtz11='Y' THEN
            UPDATE rah_temp SET rahplant = l_raq04,
                                rahlegal = l_rahlegal,
                                rahconf = 'N',
                                rahcond = NULL,
                                rahcont = NULL,
                                rahconu = NULL
         ELSE
            UPDATE rah_temp SET rahplant = l_raq04,
                                rahlegal = l_rahlegal,
                                rahconf = 'Y',
                                rahcond = g_today,
                                rahcont = g_time,
                                rahconu = g_user
         END IF

         INSERT INTO raq_temp SELECT * FROM raq_file
          WHERE raq01=g_rah.rah01 AND raq02 = g_rah.rah02
            AND raq03 ='3' AND raqplant = g_rah.rahplant
          UPDATE raq_temp SET raqplant = l_raq04,
                                raqlegal = l_rahlegal

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rah_file'),
                     " SELECT * FROM rah_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rah FROM l_sql
         EXECUTE trans_ins_rah
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rah_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF
         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rai_file'), 
                     " SELECT * FROM rai_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rai FROM l_sql
         EXECUTE trans_ins_rai
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rai_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raj_file'), 
                     " SELECT * FROM raj_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_raj FROM l_sql
         EXECUTE trans_ins_raj
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO raj_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rap_file'), 
                     " SELECT * FROM rap_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rap FROM l_sql
         EXECUTE trans_ins_rap
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raq_file'), 
                     " SELECT * FROM raq_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql  
         PREPARE trans_ins_raq FROM l_sql
         EXECUTE trans_ins_raq
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF
      END IF       
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   END IF
   IF g_success = 'Y' THEN #拋磚成功
      MESSAGE "TRANS_DATA_OK !"
      COMMIT WORK
   END IF

END FUNCTION

#同一商品同一單位在同一機構中不能在同一時間參與兩種及以上的一般促銷
#p_group :組別
FUNCTION t804_repeat(p_group)     
DEFINE p_group    LIKE rai_file.rai03
DEFINE l_raj04    LIKE raj_file.raj04
DEFINE l_raj05    LIKE raj_file.raj05
DEFINE l_raj06    LIKE raj_file.raj06
DEFINE l_rah04    LIKE rah_file.rah04
DEFINE l_rah05    LIKE rah_file.rah05
DEFINE l_rah06    LIKE rah_file.rah06
DEFINE l_rah07    LIKE rah_file.rah07

   LET l_raj04=0
   LET g_errno =' '

   SELECT raj04 INTO l_raj04 FROM raj_file
    WHERE raj01=g_rah.rah01 AND raj02=g_rah.rah02
      AND rajplant=g_rah.rahplant AND raj03=p_group
      AND rajacti='Y'

   IF l_raj04<>1 THEN RETURN END IF
 
   SELECT raj04,raj05,raj06 INTO l_raj04,l_raj05,l_raj06
     FROM raj_file
    WHERE raj01=g_rah.rah01 AND raj02=g_rah.rah02
      AND rajplant=g_rah.rahplant AND raj03=p_group
   IF cl_null(l_raj04) OR cl_null(l_raj05) OR cl_null(l_raj06) THEN
      RETURN
   END IF

   SELECT rah04,rah05,rah06,rah07
     INTO l_rah04,l_rah05,l_rah06,l_rah07 
     FROM rai_file
    WHERE rai01=g_rah.rah01 AND rai02=g_rah.rah02
      AND raiplant=g_rah.rahplant AND rai03=p_group
      AND raiacti='Y'
   IF cl_null(l_rah04) OR cl_null(l_rah05) OR cl_null(l_rah06) OR cl_null(l_rah07) THEN
      RETURN
   END IF
   
  # CALL t802sub_chk('0',g_plant,l_raj05,l_raj06,l_rah04,l_rah05,l_rah06,l_rah07)
   IF NOT cl_null(g_errno) THEN
      LET g_showmsg=g_rah.rahplant CLIPPED,"|",l_raj05 CLIPPED,"|",l_raj06 CLIPPED
      CALL s_errmsg('rahplant',g_showmsg,'',g_errno,1)
   END IF
   LET g_errno=' '

END FUNCTION
