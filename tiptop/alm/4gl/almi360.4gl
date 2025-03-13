# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almi360.4gl
# Descriptions...: 合同費用標準設置作業
# Date & Author..: NO.FUN-B90121 11/09/26 By huangtao
# Modify.........: No:TQC-C30210 12/03/28 By fanbj BUG修改
# Modify.........: No:TQC-C30340 12/04/01 By fanbj 錄入人員改為不存在的值后，恢復成舊值，但是人員名稱沒有恢復成舊值
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-CA0081 12/10/17 By xumm 比例单身增加 上限和下限栏位

DATABASE ds
 
GLOBALS "../../config/top.global"
                                
DEFINE   g_lim1        DYNAMIC ARRAY OF RECORD
                         lim02        LIKE lim_file.lim02,
                         lim03        LIKE lim_file.lim03,
                         lim04        LIKE lim_file.lim04,
                         lim05        LIKE lim_file.lim05,
                         lim051       LIKE lim_file.lim051
                        END RECORD
DEFINE   g_lim2        DYNAMIC ARRAY OF RECORD
                         lim02        LIKE lim_file.lim02,
                         lim03        LIKE lim_file.lim03,
                         lim04        LIKE lim_file.lim04,
                         lim06        LIKE lim_file.lim06,
                         lim063       LIKE lim_file.lim071,   #FUN-CA0081 add
                         lim064       LIKE lim_file.lim072,   #FUN-CA0081 add
                         lim061       LIKE lim_file.lim061,
                         lim062       LIKE lim_file.lim062
                        END RECORD       
DEFINE   g_lim3        DYNAMIC ARRAY OF RECORD
                         lim02        LIKE lim_file.lim02,
                         lim03        LIKE lim_file.lim03,
                         lim04        LIKE lim_file.lim04,
                         lim07        LIKE lim_file.lim07,
                         lim071       LIKE lim_file.lim071,
                         lim072       LIKE lim_file.lim072,
                         lim073       LIKE lim_file.lim073
                        END RECORD                          
DEFINE   g_lim1_t      RECORD 
                         lim02        LIKE lim_file.lim02,
                         lim03        LIKE lim_file.lim03,
                         lim04        LIKE lim_file.lim04,
                         lim05        LIKE lim_file.lim05,
                         lim051       LIKE lim_file.lim051
                        END RECORD 
DEFINE   g_lim2_t      RECORD 
                         lim02        LIKE lim_file.lim02,
                         lim03        LIKE lim_file.lim03,
                         lim04        LIKE lim_file.lim04,
                         lim06        LIKE lim_file.lim06,
                         lim063       LIKE lim_file.lim071,   #FUN-CA0081 add
                         lim064       LIKE lim_file.lim072,   #FUN-CA0081 add
                         lim061       LIKE lim_file.lim061,
                         lim062       LIKE lim_file.lim062
                        END RECORD   
DEFINE   g_lim3_t      RECORD 
                         lim02        LIKE lim_file.lim02,
                         lim03        LIKE lim_file.lim03,
                         lim04        LIKE lim_file.lim04,
                         lim07        LIKE lim_file.lim07,
                         lim071       LIKE lim_file.lim071,
                         lim072       LIKE lim_file.lim072,
                         lim073       LIKE lim_file.lim073
                        END RECORD                         
                         
DEFINE   g_lil          RECORD LIKE lil_file.*,
         g_lil_t        RECORD LIKE lil_file.*,
         g_lil01        LIKE lil_file.lil01,
         g_lil01_t      LIKE lil_file.lil01,
         g_lil00_t      LIKE lil_file.lil00,
         g_lil04_t      LIKE lil_file.lil04,
         g_wc,g_wc1,g_wc2,g_wc3,
         g_sql          STRING,
         g_rec_b1       LIKE type_file.num5,
         g_rec_b2       LIKE type_file.num5,
         g_rec_b3       LIKE type_file.num5
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_b_flag       LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_forupd_sql   STRING
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_cnt          LIKE type_file.num5
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1
DEFINE   l_ac1          LIKE type_file.num5
DEFINE   l_ac2          LIKE type_file.num5
DEFINE   l_ac3          LIKE type_file.num5
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_t1           LIKE oay_file.oayslip
DEFINE   g_lik10        LIKE lik_file.lik10
DEFINE   g_lil00        LIKE lil_file.lil00

MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_lil00  = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
   LET g_forupd_sql= " SELECT * FROM lil_file WHERE lil01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i360_cl CURSOR FROM g_forupd_sql
 
   LET g_b_flag = '1'
 
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW i360_w AT p_row,p_col WITH FORM "alm/42f/almi360"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_lil00) THEN
      LET g_lil.lil00 = g_lil00
      CALL cl_set_comp_entry("lil00",FALSE)
      CASE g_lil.lil00
         WHEN '1' 
            CALL cl_set_comp_visible('Page4,Page5',FALSE)
            CALL cl_set_comp_visible('Page3',TRUE)
         WHEN '2'
            CALL cl_set_comp_visible('Page3,Page5',FALSE)
            CALL cl_set_comp_visible('Page4',TRUE)
         WHEN '3'
            CALL cl_set_comp_visible('Page3,Page4',FALSE)
            CALL cl_set_comp_visible('Page5',TRUE)
      END CASE
   END IF
          
   CALL i360_menu()
 
   CLOSE WINDOW i360_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

 
FUNCTION i360_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
DEFINE  l_table         LIKE    type_file.chr1000
DEFINE  l_where         LIKE    type_file.chr1000

      CLEAR FORM
      LET g_action_choice=" " 
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lil.* TO NULL
      IF cl_null(g_lil00) THEN
         CONSTRUCT BY NAME g_wc ON
                lil00,lil01,lil02,lil03,lil04,lilplant,lillegal,lil05,lil06,lil07,
                lil08,lil09,lil10,lil11,lil12,lil13,lil14,lil15,lil16,
                lilmksg,lil17,lilconf,lilconu,lilcond,lilcont,lil18,lil19,lil20,
                liluser,lilgrup,liloriu,lilmodu,lildate,lilorig,lilacti,lilcrat     
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE WHEN INFIELD(lil01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil01"
                    LET g_qryparam.default1 = g_lil.lil01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil01
                    NEXT FIELD lil01
            
                 WHEN INFIELD(lil04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil04"
                    LET g_qryparam.default1 = g_lil.lil04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil04
                    NEXT FIELD lil04
                
                 WHEN INFIELD(lilplant)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lilplant"
                      LET g_qryparam.default1 = g_lil.lilplant
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lilplant
                      NEXT FIELD lilplant
                      
                 WHEN INFIELD(lillegal)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lillegal"
                      LET g_qryparam.default1 = g_lil.lillegal
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lillegal
                      NEXT FIELD lillegal
                 
                WHEN INFIELD(lil05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil05"
                    LET g_qryparam.default1 = g_lil.lil05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil05
                    NEXT FIELD lil05
                    
                WHEN INFIELD(lil06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil06"
                    LET g_qryparam.default1 = g_lil.lil06
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil06
                    NEXT FIELD lil06  
                    
                 WHEN INFIELD(lil07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil07"
                    LET g_qryparam.default1 = g_lil.lil07
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil07
                    NEXT FIELD lil07  
                    
                 WHEN INFIELD(lil08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil08"
                    LET g_qryparam.default1 = g_lil.lil08
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil08
                    NEXT FIELD lil08  
                    
                 WHEN INFIELD(lil09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil09"
                    LET g_qryparam.default1 = g_lil.lil09
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil09
                    NEXT FIELD lil09      

                WHEN INFIELD(lil15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil15"
                    LET g_qryparam.default1 = g_lil.lil15
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil15
                    NEXT FIELD lil15     
                    
                 WHEN INFIELD(lilconu)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lilconu"
                      LET g_qryparam.default1 = g_lil.lilconu
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lilconu
                      NEXT FIELD lilconu

                 WHEN INFIELD(lil18)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lil18"
                      LET g_qryparam.default1 = g_lil.lil18
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lil18
                      NEXT FIELD lil18
                      
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
      
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT CONSTRUCT
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         END CONSTRUCT
      ELSE
         CONSTRUCT BY NAME g_wc ON
                lil01,lil02,lil03,lil04,lilplant,lillegal,lil05,lil06,lil07,
                lil08,lil09,lil10,lil11,lil12,lil13,lil14,lil15,lil16,
                lilmksg,lil17,lilconf,lilconu,lilcond,lilcont,lil18,lil19,lil20,
                liluser,lilgrup,liloriu,lilmodu,lildate,lilorig,lilacti,lilcrat     
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE WHEN INFIELD(lil01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil01"
                    LET g_qryparam.default1 = g_lil.lil01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil01
                    NEXT FIELD lil01
            
                 WHEN INFIELD(lil04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil04"
                    LET g_qryparam.default1 = g_lil.lil04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil04
                    NEXT FIELD lil04
                
                 WHEN INFIELD(lilplant)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lilplant"
                      LET g_qryparam.default1 = g_lil.lilplant
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lilplant
                      NEXT FIELD lilplant
                      
                 WHEN INFIELD(lillegal)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lillegal"
                      LET g_qryparam.default1 = g_lil.lillegal
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lillegal
                      NEXT FIELD lillegal
                 
                WHEN INFIELD(lil05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil05"
                    LET g_qryparam.default1 = g_lil.lil05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil05
                    NEXT FIELD lil05
                    
                WHEN INFIELD(lil06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil06"
                    LET g_qryparam.default1 = g_lil.lil06
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil06
                    NEXT FIELD lil06  
                    
                 WHEN INFIELD(lil07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil07"
                    LET g_qryparam.default1 = g_lil.lil07
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil07
                    NEXT FIELD lil07  
                    
                 WHEN INFIELD(lil08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil08"
                    LET g_qryparam.default1 = g_lil.lil08
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil08
                    NEXT FIELD lil08  
                    
                 WHEN INFIELD(lil09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil09"
                    LET g_qryparam.default1 = g_lil.lil09
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil09
                    NEXT FIELD lil09      

                WHEN INFIELD(lil15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lil15"
                    LET g_qryparam.default1 = g_lil.lil15
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lil15
                    NEXT FIELD lil15     
                    
                 WHEN INFIELD(lilconu)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lilconu"
                      LET g_qryparam.default1 = g_lil.lilconu
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lilconu
                      NEXT FIELD lilconu

                 WHEN INFIELD(lil18)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_lil18"
                      LET g_qryparam.default1 = g_lil.lil18
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lil18
                      NEXT FIELD lil18
                      
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
      
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT CONSTRUCT
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         END CONSTRUCT
      END IF
      
      IF INT_FLAG OR g_action_choice = "exit" THEN
         RETURN
      END IF

      DIALOG ATTRIBUTES(UNBUFFERED) 
        CONSTRUCT g_wc1 ON lim02,lim03,lim04,lim05,lim051
             FROM s_lim1[1].lim02_1,s_lim1[1].lim03_1,s_lim1[1].lim04_1,
                  s_lim1[1].lim05,s_lim1[1].lim051
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      

        END CONSTRUCT

        CONSTRUCT g_wc2 ON lim02,lim03,lim04,lim06,lim063,lim064,lim061,lim062                          #FUN-CA0081 add lim063,lim064
             FROM s_lim2[1].lim02_2,s_lim2[1].lim03_2,s_lim2[1].lim04_2,
                  s_lim2[1].lim06,s_lim2[1].lim063,s_lim2[1].lim064,s_lim2[1].lim061,s_lim2[1].lim062   #FUN-CA0081 add lim063,lim064
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      

        END CONSTRUCT
         CONSTRUCT g_wc3 ON lim02,lim03,lim04,lim07,lim071,lim072,lim073
             FROM s_lim3[1].lim02_3,s_lim3[1].lim03_3,s_lim3[1].lim04_3,
                  s_lim3[1].lim07,s_lim3[1].lim071,s_lim3[1].lim072,s_lim3[1].lim073
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      

        END CONSTRUCT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
            
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
         
      
      ON ACTION controlg
         CALL cl_cmdask()
        
      
      ON ACTION qbe_save
         CALL cl_qbe_save() 
        
         
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
         
     END DIALOG
     IF INT_FLAG THEN
        RETURN
     END IF
   LET g_sql = "SELECT lil01 " 
   LET l_table = " FROM lil_file "
   IF NOT cl_null(g_lil00) THEN
      LET g_wc = g_wc," AND lil00 = '",g_lil00,"'"
   END IF
   LET l_where = " WHERE ",g_wc 
   IF g_wc1 <> " 1=1" OR g_wc2 <> " 1=1" OR g_wc3 <> " 1=1" THEN
      LET l_table = l_table,",lim_file"
      LET l_where = l_where," AND lil01 = lim01 AND ",g_wc1," AND ",g_wc2," AND ",g_wc3
   END IF
   LET g_sql = g_sql,l_table,l_where," ORDER BY lil01"
 
   PREPARE i360_prepare FROM g_sql
   DECLARE i360_cs SCROLL CURSOR WITH HOLD FOR i360_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT lil01) ",l_table,l_where
   PREPARE i360_precount FROM g_sql
   DECLARE i360_count CURSOR FOR i360_precount
END FUNCTION
 
FUNCTION i360_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      CASE g_b_flag
         WHEN '1'
            CALL i360_bp1("G")
            CALL i360_b1_fill(g_wc1)
         WHEN '2'
            CALL i360_bp2("G")
            CALL i360_b2_fill(g_wc2)
         WHEN '3'
            CALL i360_bp3("G")
            CALL i360_b3_fill(g_wc3)
         OTHERWISE 
            CALL i360_bp1("G")
            CALL i360_b1_fill(g_wc1)
      END CASE
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i360_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i360_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i360_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i360_u()
            END IF

        WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i360_x()
            END IF
            
        WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_b_flag = 1 THEN
                  CALL i360_b1()
               END IF
               IF g_b_flag = 2 THEN
                  CALL i360_b2()
               END IF
               IF g_b_flag = 3 THEN
                  CALL i360_b3()
               END IF
            END IF
        
 
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN  
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lim1),base.TypeInfo.create(g_lim2),base.TypeInfo.create(g_lim3))   
            END IF

 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "confirm"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL i360_y()
            END IF  

         WHEN "over"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL i360_s()
            END IF         
                                                                                                                                    
            
         WHEN "controlg"
            CALL cl_cmdask()
 
 
       WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_lil.lil01 IS NOT NULL THEN
                LET g_doc.column1 = "lil01"
                LET g_doc.value1 = g_lil.lil01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION


FUNCTION i360_x()

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_lil.* FROM lil_file WHERE lil01 = g_lil.lil01
   IF g_lil.lil01 IS NULL  OR g_lil.lilplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   IF g_lil.lilconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_lil.lilconf = 'S' THEN CALL cl_err('','alm-228',0) RETURN END IF
    BEGIN WORK
 
   OPEN i360_cl USING g_lil.lil01
   IF STATUS THEN
      CALL cl_err("OPEN i360_cl:", STATUS, 1)
      CLOSE i360_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i360_cl INTO g_lil.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lil.lil01,SQLCA.sqlcode,0)
      CLOSE i360_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_exp(0,0,g_lil.lilacti) THEN
      LET g_chr=g_lil.lilacti
      IF g_lil.lilacti='Y' THEN
         LET g_lil.lilacti='N'
      ELSE
         CALL i360_chk_lil12_lil13()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            CLOSE i360_cl
            ROLLBACK WORK
            RETURN 
         END IF
         LET g_lil.lilacti='Y'
      END IF

      UPDATE lil_file SET lilacti=g_lil.lilacti,
                          lilmodu=g_user,
                          lildate=g_today
       WHERE lil01=g_lil.lil01
      IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","lil_file",g_lil.lil01,"",SQLCA.sqlcode,"","",1)
        LET g_lil.lilacti = g_chr
        CLOSE i360_cl
        ROLLBACK WORK
        RETURN
      END IF
    END IF
    CLOSE i360_cl
    COMMIT WORK

   SELECT lilacti,lilmodu,lildate
     INTO g_lil.lilacti,g_lil.lilmodu,g_lil.lildate FROM lil_file
    WHERE lil01=g_lil.lil01
   DISPLAY BY NAME g_lil.lilacti,g_lil.lilmodu,g_lil.lildate

END FUNCTION

FUNCTION i360_s()
DEFINE   l_gen02    LIKE gen_file.gen02

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_lil.* FROM lil_file WHERE lil01 = g_lil.lil01
   IF g_lil.lil01 IS NULL  OR g_lil.lilplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   IF g_lil.lilconf = 'N' THEN CALL cl_err('','alm-226',0) RETURN END IF
   IF g_lil.lilconf = 'S' THEN CALL cl_err('','alm-228',0) RETURN END IF
   IF g_lil.lilacti = 'N' THEN CALL cl_err(g_lil.lil01,'mfg0301',0) RETURN END IF
   IF NOT cl_confirm('alm-227') THEN RETURN END IF
    BEGIN WORK
 
   OPEN i360_cl USING g_lil.lil01
   IF STATUS THEN
      CALL cl_err("OPEN i360_cl:", STATUS, 1)
      CLOSE i360_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i360_cl INTO g_lil.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lil.lil01,SQLCA.sqlcode,0)
      CLOSE i360_cl
      ROLLBACK WORK
      RETURN
   END IF
   
    UPDATE lil_file SET lilconf='S',
                        lil18 = g_user,
                        lil19 = g_today
     WHERE lil01 = g_lil.lil01 
    IF SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("upd","lil_file",g_lil.lil01,"",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK
    END IF
   
    COMMIT WORK
    CLOSE i360_cl
    SELECT * INTO g_lil.* FROM lil_file WHERE lil01=g_lil.lil01
    DISPLAY BY NAME g_lil.lilconf,g_lil.lil18,g_lil.lil19
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lil.lil18
    DISPLAY l_gen02 TO FORMONLY.lil18_desc
    
END FUNCTION


FUNCTION i360_y()
DEFINE l_cnt1         LIKE type_file.num5
DEFINE l_cnt2         LIKE type_file.num5
DEFINE l_cnt3         LIKE type_file.num5
DEFINE l_cnt4         LIKE type_file.num5
DEFINE l_count        LIKE type_file.num5
DEFINE l_gen02        LIKE gen_file.gen02
DEFINE l_lil08        LIKE lil_file.lil08
DEFINE l_flag         LIKE type_file.num5
DEFINE l_org          LIKE azp_file.azp01
 
    IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
#CHI-C30107 ------------- add -------------- begin
    IF g_lil.lilconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lil.lilconf = 'S' THEN CALL cl_err('','alm-228',0) RETURN END IF
    IF g_lil.lilacti = 'N' THEN CALL cl_err(g_lil.lil01,'art-142',0) RETURN END IF
    IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ------------- add -------------- end
    SELECT * INTO g_lil.* FROM lil_file WHERE lil01=g_lil.lil01 
#CHI-C30107 ------------- add -------------- begin
    IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
#CHI-C30107 ------------- add -------------- end
    IF g_lil.lilconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lil.lilconf = 'S' THEN CALL cl_err('','alm-228',0) RETURN END IF
    IF g_lil.lilacti = 'N' THEN CALL cl_err(g_lil.lil01,'art-142',0) RETURN END IF
    CALL i360_chk_lil12_lil13()
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('',g_errno,0)
       RETURN 
    END IF
#   IF NOT cl_confirm('art-026') THEN RETURN END IF  #CHI-C30107 mark
    BEGIN WORK
    OPEN i360_cl USING g_lil.lil01
    IF STATUS THEN
       CALL cl_err("OPEN i360_cl:", STATUS, 1)
       CLOSE i360_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i360_cl INTO g_lil.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lil.lil01,SQLCA.sqlcode,0)
       CLOSE i360_cl 
       ROLLBACK WORK 
       RETURN
    END IF
 
    LET g_success = 'Y'
    LET l_cnt2 = 0
    LET l_cnt3 = 0
   
    SELECT COUNT(*) INTO l_cnt2 FROM lim_file                                                                                   
       WHERE lim01 = g_lil.lil01 
 
    IF l_cnt2 = 0 THEN 
       CALL cl_err('','alm-791',0)
       ROLLBACK WORK
       RETURN
    END IF
    LET g_lil.lilcont = TIME
    UPDATE lil_file SET lilconf='Y',
                        lil17 = '1',
                        lilcond=g_today, 
                        lilcont=g_lil.lilcont,
                        lilconu=g_user
     WHERE lil01 = g_lil.lil01 
    IF SQLCA.sqlerrd[3]=0 THEN
       LET g_success='N'
    END IF
 
   IF g_success = 'Y' THEN
      LET g_lil.lilconf='Y'
      LET g_lil.lil17 = '1'
      LET g_lil.lilcond=g_today    
      LET g_lil.lilconu=g_user    
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   
   SELECT * INTO g_lil.* FROM lil_file WHERE lil01=g_lil.lil01 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lil.lilconu
   DISPLAY BY NAME g_lil.lilconf,g_lil.lil17,g_lil.lilcond,g_lil.lilcont,g_lil.lilconu                                                                                        
   DISPLAY l_gen02 TO FORMONLY.lilconu_desc
   CALL cl_set_field_pic(g_lil.lilconf,g_lil.lil17,"","","","") 
   
END FUNCTION
 
FUNCTION i360_desc()
DEFINE l_oaj02    LIKE oaj_file.oaj02
DEFINE l_azp02    LIKE  azp_file.azp02
DEFINE l_azt02    LIKE  azt_file.azt02
DEFINE l_tqa02    LIKE  tqa_file.tqa02
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_gen02_1  LIKE gen_file.gen02
DEFINE l_gen02_2  LIKE gen_file.gen02
DEFINE l_lmb03    LIKE lmb_file.lmb03
DEFINE l_lmc04    LIKE lmc_file.lmc04
DEFINE l_lmy04    LIKE lmy_file.lmy04
DEFINE l_oba02    LIKE oba_file.oba02

   SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = g_lil.lil04
   DISPLAY l_oaj02 TO FORMONLY.lil04_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
   DISPLAY l_azp02 TO FORMONLY.lilplant_desc
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lil.lillegal
   DISPLAY l_azt02 TO FORMONLY.lillegal_desc
   SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmbstore = g_lil.lilplant AND lmb02 = g_lil.lil05
   DISPLAY l_lmb03  TO FORMONLY.lil05_desc 
   SELECT lmc04 INTO l_lmc04 FROM lmc_file WHERE lmcstore = g_lil.lilplant AND lmc02 = g_lil.lil05 AND lmc03 = g_lil.lil06
   DISPLAY l_lmc04  TO FORMONLY.lil06_desc
   SELECT lmy04 INTO l_lmy04 FROM lmy_file WHERE lmystore = g_lil.lilplant AND lmy01 = g_lil.lil05
                                             AND lmy02 = g_lil.lil06 AND lmy03 = g_lil.lil07
   DISPLAY l_lmy04  TO FORMONLY.lil07_desc
   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_lil.lil08
   DISPLAY l_oba02  TO FORMONLY.lil08_desc
   SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = g_lil.lil09 AND tqa03 = '30'
   DISPLAY l_tqa02  TO FORMONLY.lil09_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lil.lil15
   DISPLAY l_gen02 TO FORMONLY.lil15_desc
   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lil.lilconu
   DISPLAY l_gen02_1 TO FORMONLY.lilconu_desc
   SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01 = g_lil.lil18
   DISPLAY l_gen02_2 TO FORMONLY.lil18_desc
   
END FUNCTION

FUNCTION i360_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_lim1.clear()
   CALL g_lim2.clear()
   CALL g_lim3.clear()
 
   INITIALIZE g_lil.* LIKE lil_file.*
   LET g_lil01_t = NULL
   LET g_lil_t.* = g_lil.*
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_lil.lil02 = 0
       LET g_lil.lil03 = g_today
       LET g_lil.lilplant = g_plant
       LET g_lil.lillegal = g_legal
       LET g_lil.lilconf = 'N'
       LET g_lil.lilmksg = 'N'
       LET g_lil.lil14 = 'N'
       LET g_lil.lil15 = g_user
       LET g_lil.lil16 = g_today
       LET g_lil.lil17 = '0'
       LET g_lil.liluser = g_user
       LET g_lil.liloriu = g_user 
       LET g_lil.lilorig = g_grup 
       LET g_data_plant  = g_plant 
       LET g_lil.lilgrup = g_grup
       LET g_lil.lilmodu = NULL
       LET g_lil.lildate = NULL
       LET g_lil.lilacti = 'Y'
       LET g_lil.lilcrat = g_today
       CALL i360_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_lim1.clear()
           CALL g_lim2.clear()
           CALL g_lim3.clear()
           IF cl_null(g_lil00) THEN
              CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
           END IF
           EXIT WHILE
       END IF
       IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
       CALL s_auto_assign_no("alm",g_lil.lil01,g_today,"O9","lil_file","lil01","","","")
          RETURNING li_result,g_lil.lil01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_lil.lil01
       
       INSERT INTO lil_file VALUES(g_lil.*)     
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","lil_file",g_lil.lil01,"",SQLCA.SQLCODE,"","",1)
          ROLLBACK WORK
          CONTINUE WHILE
       ELSE
          COMMIT WORK
       END IF
       LET g_rec_b1=0
       LET g_rec_b2=0
       LET g_rec_b3=0
       IF g_lil.lil00 = '1' THEN
          CALL i360_b1()  
       END IF
       IF g_lil.lil00 = '2' THEN
          CALL i360_b2()
       END IF
       IF g_lil.lil00 = '3' THEN
          CALL i360_b3()
       END IF
       CALL i360_delall()
       EXIT WHILE
   END WHILE
END FUNCTION


FUNCTION i360_delall()
DEFINE l_cnt1      LIKE type_file.num5
 
   LET l_cnt1 = 0
   SELECT COUNT(*) INTO l_cnt1 FROM lim_file                                                                                   
       WHERE lim01=g_lil.lil01 AND limplant = g_plant
   IF l_cnt1=0  THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lil_file WHERE lil01 = g_lil.lil01 AND lilplant = g_plant
      INITIALIZE g_lil.* TO NULL
      CALL g_lim1.clear()
      CALL g_lim2.clear()
      CALL g_lim3.clear()
      CLEAR FORM
   END IF
END FUNCTION
 

 
FUNCTION i360_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_lil.* FROM lil_file WHERE lil01 = g_lil.lil01
 
   IF g_lil.lilconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF   
   IF g_lil.lilacti = 'N' THEN                                                                                                      
      CALL cl_err('','mfg1000',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lil01_t = g_lil.lil01
   LET g_lil_t.* = g_lil.*
   BEGIN WORK
   OPEN i360_cl USING g_lil.lil01
   FETCH i360_cl INTO g_lil.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lil.lil01,SQLCA.SQLCODE,0)
      CLOSE i360_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL i360_show()
   WHILE TRUE
      LET g_lil01_t = g_lil.lil01
      LET g_lil.lilmodu=g_user
      LET g_lil.lildate=g_today
      CALL i360_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lil.*=g_lil_t.*
          CALL i360_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE lil_file SET lil_file.* = g_lil.* WHERE lil01 = g_lil.lil01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","lil_file",g_lil.lil01,"",SQLCA.SQLCODE,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i360_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i360_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5,
          li_result    LIKE type_file.num5,
          l_lmb03      LIKE lmb_file.lmb03,
          l_lmc04      LIKE lmc_file.lmc04,
          l_gen02      LIKE gen_file.gen02,
          l_lmb06      LIKE lmb_file.lmb06,
          l_lmc07      LIKE lmc_file.lmc07,
          l_tqa02      LIKE tqa_file.tqa02,
          l_lil05      LIKE lil_file.lil05,
          l_lim03      LIKE lim_file.lim03,
          l_lim04      LIKE lim_file.lim04

   LET g_lik10 = ''
   DISPLAY BY NAME
      g_lil.lil00,g_lil.lil01,g_lil.lil02, g_lil.lil03,g_lil.lil04,g_lil.lilplant,g_lil.lillegal,
      g_lil.lil05,g_lil.lil06,g_lil.lil07,g_lil.lil08,g_lil.lil09,g_lil.lil10,
      g_lil.lil11,g_lil.lil12,g_lil.lil13,g_lil.lil14,g_lil.lil15,g_lil.lil16,
      g_lil.lilmksg,g_lil.lil17,g_lil.lilconf,g_lil.lilconu,g_lil.lilcond,g_lil.lilcont,
      g_lil.lil18,g_lil.lil19,g_lil.lil20,
      g_lil.liluser,g_lil.lilmodu,g_lil.lilacti,g_lil.lilgrup,
      g_lil.lildate,g_lil.lilcrat,g_lil.liloriu,g_lil.lilorig 

   LET g_lil04_t = g_lil.lil04
   CALL i360_desc()
   
   INPUT BY NAME g_lil.lil00,g_lil.lil01,g_lil.lil03,g_lil.lil04,g_lil.lil05,
      g_lil.lil06,g_lil.lil07,g_lil.lil08,g_lil.lil09,
      g_lil.lil12,g_lil.lil13,g_lil.lil14,g_lil.lil15,g_lil.lil16,g_lil.lil20  WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i360_set_entry(p_cmd)
           CALL i360_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("lil01")
 
       AFTER FIELD lil01
           IF NOT cl_null(g_lil.lil01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_lil.lil01!=g_lil_t.lil01) THEN
                 CALL s_check_no("alm",g_lil.lil01,g_lil01_t,"O9","lil_file","lil01","")  
                    RETURNING li_result,g_lil.lil01
                 IF (NOT li_result) THEN                                                            
                    LET g_lil.lil01=g_lil_t.lil01                                                                 
                    NEXT FIELD lil01                                                                                      
                 END IF
                 SELECT oayapr INTO g_lil.lilmksg FROM oay_file WHERE oayslip = g_lil.lil01 
              END IF
           END IF
       ON CHANGE lil00
          IF NOT cl_null(g_lik10) AND cl_null(g_lil00) THEN
             IF g_lik10 <> g_lil.lil00 THEN
                CALL cl_err('','alm-870',0)
                LET g_lil.lil00 = g_lil00_t
                NEXT FIELD lil00
             END IF
          END IF
          LET g_lil00_t = g_lil.lil00
          CASE g_lil.lil00
             WHEN '1' 
               CALL cl_set_comp_visible('Page4,Page5',FALSE)
               CALL cl_set_comp_visible('Page3',TRUE)
             WHEN '2'
               CALL cl_set_comp_visible('Page3,Page5',FALSE)
               CALL cl_set_comp_visible('Page4',TRUE)
             WHEN '3'
               CALL cl_set_comp_visible('Page3,Page4',FALSE)
               CALL cl_set_comp_visible('Page5',TRUE)
          END CASE

        
       AFTER FIELD lil04
         IF NOT cl_null(g_lil.lil04) THEN
            IF cl_null(g_lil04_t)  OR g_lil04_t <> g_lil.lil04 THEN
               LET g_lil.lil05 = ''
               LET g_lil.lil06 = ''
               LET g_lil.lil07 = ''
               LET g_lil.lil08 = ''
               LET g_lil.lil10 = ''
               LET g_lil.lil11 = ''
               LET g_lik10 = ''
               DISPLAY BY NAME g_lil.lil05,g_lil.lil06,g_lil.lil07,
                               g_lil.lil08,g_lil.lil10,g_lil.lil11
               DISPLAY '' TO FORMONLY.lil05_desc
               DISPLAY '' TO FORMONLY.lil06_desc
               DISPLAY '' TO FORMONLY.lil07_desc
               DISPLAY '' TO FORMONLY.lil08_desc
            END IF
                CALL i360_chk_lil04()
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lil.lil04 = g_lil_t.lil04
                    NEXT FIELD lil04
                ELSE
                   LET g_lil04_t = g_lil.lil04
                END IF
            CALL i360_lil04()
         ELSE
            DISPLAY ' ' TO FORMONLY.lil04_desc
         END IF

      AFTER FIELD lil05
         IF NOT cl_null(g_lil.lil05) THEN
       #     IF (p_cmd='a') OR (p_cmd='u' AND g_lil.lil05!=g_lil_t.lil05) THEN 
                CALL i360_chk_lil05()
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lil.lil05 = g_lil_t.lil05
                    NEXT FIELD lil05
                END IF
                IF NOT cl_null(g_lil.lil12) AND NOT cl_null(g_lil.lil13) THEN
                   CALL i360_chk_lil12_lil13()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lil.lil05 = g_lil_t.lil05
                       NEXT FIELD lil05
                    END IF 
                END IF
                CALL i360_chk_to()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lil.lil05 = g_lil_t.lil05
                   NEXT FIELD lil05
                END IF
       #     END IF
            CALL i360_lil05()
         ELSE
            DISPLAY ' ' TO FORMONLY.lil05_desc
         END IF
       
      AFTER FIELD lil06
         IF NOT cl_null(g_lil.lil06) THEN
       #     IF (p_cmd='a') OR (p_cmd='u' AND g_lil.lil06!=g_lil_t.lil06) THEN 
                CALL i360_chk_lil06()
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lil.lil06 = g_lil_t.lil06
                    NEXT FIELD lil06
                END IF
                 IF NOT cl_null(g_lil.lil12) AND NOT cl_null(g_lil.lil13) THEN
                   CALL i360_chk_lil12_lil13()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lil.lil06 = g_lil_t.lil06
                       NEXT FIELD lil06
                    END IF 
                END IF
                CALL i360_chk_to()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lil.lil06 = g_lil_t.lil06
                   NEXT FIELD lil06
                END IF
       #     END IF
            CALL i360_lil06()
         ELSE
            DISPLAY ' ' TO FORMONLY.lil06_desc
         END IF

       AFTER FIELD lil07 
          IF NOT cl_null(g_lil.lil07) THEN
       #     IF (p_cmd='a') OR (p_cmd='u' AND g_lil.lil07!=g_lil_t.lil07) THEN 
                CALL i360_chk_lil07()
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lil.lil07= g_lil_t.lil07
                    NEXT FIELD lil07
                END IF
                 IF NOT cl_null(g_lil.lil12) AND NOT cl_null(g_lil.lil13) THEN
                   CALL i360_chk_lil12_lil13()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lil.lil07 = g_lil_t.lil07
                       NEXT FIELD lil07
                    END IF 
                END IF
                CALL i360_chk_to()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lil.lil07 = g_lil_t.lil07
                   NEXT FIELD lil07
                END IF
      #      END IF
            CALL i360_lil07()
         ELSE
            DISPLAY ' ' TO FORMONLY.lil07_desc
         END IF

       AFTER FIELD lil08
         IF NOT cl_null(g_lil.lil08) THEN
       #     IF (p_cmd='a') OR (p_cmd='u' AND g_lil.lil08!=g_lil_t.lil08) THEN 
                CALL i360_chk_lil08()
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lil.lil08 = g_lil_t.lil08
                    NEXT FIELD lil08
                END IF
                 IF NOT cl_null(g_lil.lil12) AND NOT cl_null(g_lil.lil13) THEN
                   CALL i360_chk_lil12_lil13()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lil.lil08 = g_lil_t.lil08
                       NEXT FIELD lil08
                    END IF 
                END IF
                CALL i360_chk_to()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lil.lil08 = g_lil_t.lil08
                   NEXT FIELD lil08
                END IF
       #     END IF
            CALL i360_lil08()
         ELSE
             DISPLAY ' ' TO FORMONLY.lil08_desc
         END IF

           
       AFTER FIELD lil09
           IF NOT cl_null(g_lil.lil09) THEN  
              IF (p_cmd='a') OR (p_cmd='u' AND g_lil.lil09!=g_lil_t.lil09) THEN
                 SELECT COUNT(*) INTO l_n FROM tqa_file WHERE tqa01 = g_lil.lil09 AND tqa03 = '30'
                 IF l_n = 0 THEN
                    CALL cl_err('','alm-780',0)
                    LET g_lil.lil09 = g_lil_t.lil09
                    NEXT FIELD lil09
                 END IF
              END IF
               IF NOT cl_null(g_lil.lil12) AND NOT cl_null(g_lil.lil13) THEN
                   CALL i360_chk_lil12_lil13()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lil.lil09 = g_lil_t.lil09
                       NEXT FIELD lil09
                    END IF 
                END IF
              CALL i360_chk_to()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lil.lil09 = g_lil_t.lil09
                 NEXT FIELD lil09
              END IF
              SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lil.lil09 AND tqa03 = '30'
              DISPLAY l_tqa02 TO FORMONLY.lil09_desc
           ELSE
              LET l_tqa02 = ' '
              DISPLAY l_tqa02 TO FORMONLY.lil09_desc 
           END IF

      AFTER FIELD lil12,lil13
         IF NOT cl_null(g_lil.lil12) AND NOT cl_null(g_lil.lil13)  THEN 
             IF g_lil.lil12 > g_lil.lil13 THEN
                CALL cl_err('','',0)
                NEXT FIELD CURRENT
             END IF
             CALL i360_chk_lil12_lil13()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD CURRENT
             END IF
             IF p_cmd = 'u' THEN
                SELECT MIN(lim03) INTO l_lim03 FROM lim_file WHERE lim01 = g_lil.lil01
                SELECT MAX(lim04) INTO l_lim04 FROM lim_file WHERE lim01 = g_lil.lil01
                IF g_lil.lil12 > l_lim03 OR g_lil.lil13 < l_lim04 THEN
                   CALL cl_err('','alm-862',0)
                   NEXT FIELD CURRENT 
                END IF
             END IF
         END IF

      #TQC-C30210--start add------------------------------
      AFTER FIELD lil15
         IF NOT cl_null(g_lil.lil15) THEN
            CALL i360_lil15(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lil.lil15 = g_lil_t.lil15
               CALL i360_lil15('d')        #TQC-C30340 add
               DISPLAY BY NAME g_lil.lil15
               NEXT FIELD lil15
            END IF   
         END IF  
      #TQC-C30210--end add--------------------------------

           
      ON ACTION controlp
          CASE 
             WHEN INFIELD(lil01)
                LET g_t1=s_get_doc_no(g_lil.lil01)
                CALL q_oay(FALSE,FALSE,g_t1,'O9','ALM') RETURNING g_t1  
                LET g_lil.lil01=g_t1               
                DISPLAY BY NAME g_lil.lil01       
                NEXT FIELD lil01
                
           WHEN INFIELD(lil04) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lnl01"
                LET g_qryparam.arg1 = g_lil.lilplant
                LET g_qryparam.default1 = g_lil.lil04
                CALL cl_create_qry() RETURNING g_lil.lil04
                CALL i360_lil04() 
                DISPLAY BY NAME g_lil.lil04
                NEXT FIELD lil04

            WHEN INFIELD(lil05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lmb1"
                LET g_qryparam.arg1 = g_lil.lilplant
                LET g_qryparam.default1 = g_lil.lil05
                CALL cl_create_qry() RETURNING g_lil.lil05
                DISPLAY BY NAME g_lil.lil05
                CALL i360_lil05()
                NEXT FIELD lil05 

            WHEN INFIELD(lil06) 
                CALL cl_init_qry_var()
                IF cl_null(g_lil.lil05) THEN
                   LET g_qryparam.form = "q_lmc3"
                   LET g_qryparam.arg1 = g_lil.lilplant
                ELSE
                   LET g_qryparam.form = "q_lmc2"
                   LET g_qryparam.arg1 = g_lil.lil05 
                   LET g_qryparam.arg2 = g_lil.lilplant
                END IF
                LET g_qryparam.default1 = l_lil05
                LET g_qryparam.default2 = g_lil.lil06
                LET g_qryparam.default3 = l_lmc04
                CALL cl_create_qry() RETURNING l_lil05,g_lil.lil06,l_lmc04
                DISPLAY BY NAME g_lil.lil06
                DISPLAY  l_lmc04 TO FORMONLY.lil06_desc
                NEXT FIELD lil06
                   
            WHEN INFIELD(lil07) 
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lmy3"
                LET g_qryparam.arg1 = g_lil.lilplant
                #TQC-C30210--start add---------------
                IF NOT cl_null(g_lil.lil05) AND NOT cl_null(g_lil.lil06) THEN
                   LET g_qryparam.where = " lmy01 = '",g_lil.lil05,"' AND lmy02 = '",g_lil.lil06,"' "
                ELSE
                   IF NOT cl_null(g_lil.lil05) THEN
                      LET g_qryparam.where = " lmy01 = '",g_lil.lil05,"'"        
                   END IF  
                   IF NOT cl_null(g_lil.lil06) THEN
                      LET g_qryparam.where = " lmy02 = '",g_lil.lil06,"'"
                   END IF 
                END IF 
                #TQC-C30210--end add-----------------
                LET g_qryparam.default1 = g_lil.lil07
                CALL cl_create_qry() RETURNING g_lil.lil07
                DISPLAY BY NAME g_lil.lil07
                NEXT FIELD lil07 

            
            WHEN INFIELD(lil08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba01"
               LET g_qryparam.default1 = g_lil.lil08
               CALL cl_create_qry() RETURNING g_lil.lil08
               DISPLAY BY NAME g_lil.lil08
               CALL i360_lil08()
               NEXT FIELD lil08 
                
            WHEN INFIELD(lil09) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_tqa"
                LET g_qryparam.default1 = g_lil.lil09
                LET g_qryparam.arg1 ='30'
                CALL cl_create_qry() RETURNING g_lil.lil09
                DISPLAY BY NAME g_lil.lil09
                NEXT FIELD lil09
                
          END CASE
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
 
       AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
   END INPUT
END FUNCTION

FUNCTION i360_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_lil.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   IF cl_null(g_lil00) THEN
      CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
   END IF
   CALL i360_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_lil.* TO NULL
      CALL g_lim1.clear()
      CALL g_lim2.clear()
      CALL g_lim3.clear()
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN i360_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_lil.* TO NULL
   ELSE
      OPEN i360_count
      FETCH i360_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i360_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION i360_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i360_cs INTO g_lil.lil01
      WHEN 'P' FETCH PREVIOUS i360_cs INTO g_lil.lil01
      WHEN 'F' FETCH FIRST    i360_cs INTO g_lil.lil01
      WHEN 'L' FETCH LAST     i360_cs INTO g_lil.lil01
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
         FETCH ABSOLUTE g_jump i360_cs INTO g_lil.lil01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lil.lil01,SQLCA.SQLCODE,0) 
      INITIALIZE g_lil.* TO NULL
      CALL g_lim1.clear()
      CALL g_lim2.clear()
      CALL g_lim3.clear()
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
   SELECT * INTO g_lil.* FROM lil_file WHERE  lil01 = g_lil.lil01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_lil.* TO NULL
      CALL g_lim1.clear()
      CALL g_lim2.clear()
      CALL g_lim3.clear()
      CALL cl_err3("sel","lil_file",g_lil.lil01,"",SQLCA.SQLCODE,"","",1)  
      RETURN
   END IF
   
   CALL i360_show()
END FUNCTION
 
FUNCTION i360_show()
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_lmb03    LIKE lmb_file.lmb03
   DEFINE l_lmc04    LIKE lmc_file.lmc04
 
 
   DISPLAY BY NAME
      g_lil.lil00,g_lil.lil01,g_lil.lil02, g_lil.lil03,g_lil.lil04,g_lil.lilplant,
      g_lil.lillegal,g_lil.lil05,g_lil.lil06,g_lil.lil07,
      g_lil.lil08,g_lil.lil09,g_lil.lil10,g_lil.lil11,g_lil.lil12,g_lil.lil13,
      g_lil.lil14,g_lil.lil15,g_lil.lil16,
      g_lil.lilmksg,g_lil.lil17,g_lil.lilconf,g_lil.lilconu,g_lil.lilcond,g_lil.lilcont,
      g_lil.lil18,g_lil.lil19,g_lil.lil20,
      g_lil.liluser,g_lil.lilmodu,g_lil.lilacti,g_lil.lilgrup,
      g_lil.lildate,g_lil.lilcrat,g_lil.liloriu,g_lil.lilorig        
   CALL cl_set_field_pic(g_lil.lilconf,g_lil.lil17,"","","","") 
   CALL i360_desc()
   IF g_lil.lil00 = '1' THEN
      CALL i360_b1_fill(g_wc1)
      CALL cl_set_comp_visible('Page4,Page5',FALSE)
      CALL cl_set_comp_visible('Page3',TRUE)
      LET g_b_flag = '1'
   END IF
   IF g_lil.lil00 = '2' THEN
      CALL i360_b2_fill(g_wc2)
      CALL cl_set_comp_visible('Page3,Page5',FALSE)
      CALL cl_set_comp_visible('Page4',TRUE)
      LET g_b_flag = '2'
   END IF
   IF g_lil.lil00 = '3' THEN
      CALL i360_b3_fill(g_wc3)
      CALL cl_set_comp_visible('Page3,Page4',FALSE)
      CALL cl_set_comp_visible('Page5',TRUE)
      LET g_b_flag = '3'
   END IF
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i360_b1()
DEFINE
   l_ac1_t         LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5

   
   LET g_b_flag = '1'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN RETURN END IF
      
   SELECT * INTO g_lil.* FROM lil_file
      WHERE lil01=g_lil.lil01 
   IF g_lil.lilacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_lil.lilconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
   
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = 
       " SELECT lim02,lim03,lim04,lim05,lim051",
       "  FROM lim_file ",
       " WHERE lim02=? AND lim01='",g_lil.lil01,"'",
       " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i360_bc1 CURSOR FROM g_forupd_sql     
 
   LET l_ac1_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lim1 WITHOUT DEFAULTS FROM s_lim1.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
              LET l_ac1 = 1
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN i360_cl USING g_lil.lil01
           IF STATUS THEN
              CALL cl_err("OPEN i360_cl:", STATUS, 1)
              CLOSE i360_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i360_cl INTO g_lil.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_lil.lil01,SQLCA.SQLCODE,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b1>=l_ac1 THEN
              LET g_lim1_t.* = g_lim1[l_ac1].*  #BACKUP
              LET p_cmd='u'
              OPEN i360_bc1 USING g_lim1_t.lim02
              IF STATUS THEN
                 CALL cl_err("OPEN i360_bc1:", STATUS, 1)
                 CLOSE i360_bc1
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH i360_bc1 INTO g_lim1[l_ac1].*
              IF SQLCA.SQLCODE THEN
                  CALL cl_err(g_lim1_t.lim02,SQLCA.SQLCODE,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL cl_show_fld_cont()
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lim1[l_ac1].* TO NULL
           LET g_lim1_t.* = g_lim1[l_ac1].*
           CALL cl_show_fld_cont()
           LET g_lim1[l_ac1].lim051 = 1
           NEXT FIELD lim02_1
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lim_file(lim01,lim02,lim03,lim04,lim05,lim051,limplant,limlegal)
              VALUES(g_lil.lil01,g_lim1[l_ac1].lim02,g_lim1[l_ac1].lim03,g_lim1[l_ac1].lim04,
                    g_lim1[l_ac1].lim05,g_lim1[l_ac1].lim051,g_plant,g_legal)
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","lim_file",g_lil.lil01,"",SQLCA.SQLCODE,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
         
              LET g_rec_b1=g_rec_b1+1   
           END IF



      BEFORE FIELD lim02_1
         IF g_lim1[l_ac1].lim02 IS NULL OR g_lim1[l_ac1].lim02 = 0 THEN
              SELECT max(lim02)+1
                INTO g_lim1[l_ac1].lim02
                FROM lim_file
               WHERE lim01 = g_lil.lil01
              IF g_lim1[l_ac1].lim02 IS NULL THEN
                 LET g_lim1[l_ac1].lim02 = 1
              END IF
         END IF

     AFTER FIELD lim02_1
           IF NOT cl_null(g_lim1[l_ac1].lim02) THEN
              IF g_lim1[l_ac1].lim02 != g_lim1_t.lim02
                 OR g_lim1_t.lim02 IS NULL THEN
                 IF g_lim1[l_ac1].lim02 <= 0 THEN
                    CALL cl_err('','aec-994',0)
                    LET g_lim1[l_ac1].lim02 = g_lim1_t.lim02
                    NEXT FIELD lim02_1
                 END IF 
                 SELECT count(*)
                   INTO l_n
                   FROM lim_file
                  WHERE lim01 = g_lil.lil01
                    AND lim02 = g_lim1[l_ac1].lim02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lim1[l_ac1].lim02 = g_lim1_t.lim02
                    NEXT FIELD lim02_1
                 END IF
              END IF
           END IF

     AFTER FIELD lim03_1,lim04_1
          IF NOT cl_null(g_lim1[l_ac1].lim03) OR NOT cl_null(g_lim1[l_ac1].lim04) THEN
             IF g_lim1[l_ac1].lim03 < g_lil.lil12 OR g_lim1[l_ac1].lim04 > g_lil.lil13 THEN
                CALL cl_err('','alm-862',0)
                NEXT FIELD CURRENT
             END IF
          END IF
          IF NOT cl_null(g_lim1[l_ac1].lim03) AND NOT cl_null(g_lim1[l_ac1].lim04) THEN
             IF g_lim1[l_ac1].lim03 > g_lim1[l_ac1].lim04 THEN
                CALL cl_err('','alm1038',0)
                NEXT FIELD CURRENT
             END IF
             IF p_cmd = 'a' THEN
                SELECT COUNT(*) INTO l_n FROM lim_file 
                 WHERE lim01 = g_lil.lil01 
                   AND ((g_lim1[l_ac1].lim03 BETWEEN lim03 AND lim04
                        OR g_lim1[l_ac1].lim04 BETWEEN lim03 AND lim04)
                    OR  (lim03 BETWEEN g_lim1[l_ac1].lim03 AND g_lim1[l_ac1].lim04
                         OR lim04 BETWEEN g_lim1[l_ac1].lim03 AND g_lim1[l_ac1].lim04 ))
                IF l_n > 0 THEN
                   CALL cl_err('','alm-863',0)
                   NEXT FIELD CURRENT
                END IF
             ELSE
                IF g_lim1[l_ac1].lim03 <> g_lim1_t.lim03 OR g_lim1[l_ac1].lim04 <> g_lim1_t.lim04 THEN
                   SELECT COUNT(*) INTO l_n FROM lim_file 
                    WHERE lim01 = g_lil.lil01 
                      AND lim02 <> g_lim1_t.lim02 
                      AND ((g_lim1[l_ac1].lim03 BETWEEN lim03 AND lim04
                          OR g_lim1[l_ac1].lim04 BETWEEN lim03 AND lim04)
                      OR  (lim03 BETWEEN g_lim1[l_ac1].lim03 AND g_lim1[l_ac1].lim04
                         OR lim04 BETWEEN g_lim1[l_ac1].lim03 AND g_lim1[l_ac1].lim04 ))
                   IF l_n > 0 THEN
                      CALL cl_err('','alm-863',0)
                      NEXT FIELD CURRENT
                   END IF
                END IF    
             END IF
          END IF
          
     AFTER FIELD lim05
        IF NOT cl_null(g_lim1[l_ac1].lim05) THEN
           IF  g_lim1[l_ac1].lim05 < 0 THEN
              CALL cl_err('','alm1080',0)
              NEXT FIELD lim05
           END IF
        END IF
     

     AFTER FIELD lim051
        IF NOT cl_null(g_lim1[l_ac1].lim051) THEN
           IF  g_lim1[l_ac1].lim051 <= 0 THEN
              CALL cl_err('','alm1079',0)
              NEXT FIELD lim051
           END IF
        END IF 
     

      BEFORE DELETE  
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM lim_file
            WHERE lim01 = g_lil.lil01
              AND lim02 = g_lim1_t.lim02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","lim_file",g_lil.lil01,g_lim1_t.lim02,SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           LET g_rec_b1=g_rec_b1-1
           COMMIT WORK
           
   
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lim1[l_ac1].* = g_lim1_t.*
              CLOSE i360_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lim1[l_ac1].lim02,-263,1) 
              LET g_lim1[l_ac1].* = g_lim1_t.*
           ELSE
              UPDATE lim_file SET lim02 = g_lim1[l_ac1].lim02,
                                  lim03 = g_lim1[l_ac1].lim03,
                                  lim04 = g_lim1[l_ac1].lim04,
                                  lim05 = g_lim1[l_ac1].lim05,
                                  lim051 = g_lim1[l_ac1].lim051
                 WHERE lim01=g_lil.lil01 
                   AND lim02=g_lim1_t.lim02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","lim_file",g_lil.lil01,"",SQLCA.SQLCODE,"","",1)
                 LET g_lim1[l_ac1].* = g_lim1_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac1= ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lim1[l_ac1].* = g_lim1_t.*
              END IF
              CLOSE i360_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i360_bc1
           COMMIT WORK

       ON ACTION CONTROLO
          IF INFIELD(lim03) AND l_ac1 > 1 THEN
             LET g_lim1[l_ac1].* = g_lim1[l_ac1-1].*
             NEXT FIELD lim03
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
   IF p_cmd = 'u' THEN
      LET g_lil.lilmodu = g_user
      LET g_lil.lildate = g_today
      UPDATE lil_file SET lilmodu = g_lil.lilmodu,
                          lildate = g_lil.lildate
         WHERE lil01 = g_lil.lil01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lil_file",g_lil.lil01,"",SQLCA.SQLCODE,"","upd lil",1)  
      END IF
      DISPLAY BY NAME g_lil.lilmodu,g_lil.lildate
   END IF
   CLOSE i360_bc1
   COMMIT WORK
END FUNCTION


FUNCTION i360_b2()
DEFINE
   l_ac2_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5


   LET g_b_flag = '2'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN RETURN END IF
   SELECT * INTO g_lil.* FROM lil_file WHERE lil01=g_lil.lil01 
   IF g_lil.lilconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lim02,lim03,lim04,lim06,lim071,lim072,lim061,lim062 FROM lim_file ",   #FUN-CA0081 add lim071,lim072
                      " WHERE lim02=? AND lim01='",g_lil.lil01,"'",
                      "   FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i360_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac2_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lim2 WITHOUT DEFAULTS FROM s_lim2.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i360_cl USING g_lil.lil01
           IF STATUS THEN
              CALL cl_err("OPEN i360_cl:", STATUS, 1)
              CLOSE i360_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i360_cl INTO g_lil.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_lil.lil01,SQLCA.SQLCODE,0)
              CLOSE i360_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2>=l_ac2 THEN
              LET p_cmd='u'
              LET g_lim2_t.* = g_lim2[l_ac2].*   #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN i360_bc2 USING g_lim2_t.lim02
              IF STATUS THEN
                 CALL cl_err("OPEN i360_bc2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i360_bc2 INTO g_lim2[l_ac2].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_lim2_t.lim02,SQLCA.SQLCODE , 1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL i360_set_required(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,g_lim2[l_ac2].lim063,g_lim2[l_ac2].lim064,p_cmd)  #FUN-CA0081 add
              CALL cl_show_fld_cont()
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lim2[l_ac2].* TO NULL
           LET g_lim2_t.* = g_lim2[l_ac2].*
           CALL i360_set_required(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,g_lim2[l_ac2].lim063,g_lim2[l_ac2].lim064,p_cmd)  #FUN-CA0081 add
           CALL cl_show_fld_cont()
           NEXT FIELD lim02_2
          

       BEFORE DELETE 
          IF NOT cl_delb(0,0) THEN
             CANCEL DELETE
          END IF
          IF l_lock_sw = "Y" THEN
             CALL cl_err("", -263, 1)
             CANCEL DELETE
          END IF
          DELETE FROM lim_file
           WHERE lim01 = g_lil.lil01
             AND lim02 = g_lim2_t.lim02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","lim_file",g_lil.lil01,g_lim2_t.lim02,SQLCA.sqlcode,"","",1)  
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          LET g_rec_b2=g_rec_b2-1
          COMMIT WORK
           
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lim_file(lim01,lim02,lim03,lim04,lim06,lim061,lim062,lim071,lim072,limplant,limlegal)  #FUN-CA0081 add lim071,lim072
                        VALUES(g_lil.lil01,g_lim2[l_ac2].lim02,g_lim2[l_ac2].lim03,
                         g_lim2[l_ac2].lim04,g_lim2[l_ac2].lim06,
                         #g_lim2[l_ac2].lim061,g_lim2[l_ac2].lim062,g_plant,g_legal)                          #FUN-CA0081 mark                 
                         g_lim2[l_ac2].lim061,g_lim2[l_ac2].lim062,g_lim2[l_ac2].lim063,g_lim2[l_ac2].lim064,g_plant,g_legal)  #FUN-CA0081 add
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","lim_file",g_lil.lil01,"",SQLCA.SQLCODE,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b2=g_rec_b2+1   
           END IF

      BEFORE FIELD lim02_2
         IF g_lim2[l_ac2].lim02 IS NULL OR g_lim2[l_ac2].lim02 = 0 THEN
              SELECT max(lim02)+1
                INTO g_lim2[l_ac2].lim02
                FROM lim_file
               WHERE lim01 = g_lil.lil01
              IF g_lim2[l_ac2].lim02 IS NULL THEN
                 LET g_lim2[l_ac2].lim02 = 1
              END IF
         END IF

     AFTER FIELD lim02_2
           IF NOT cl_null(g_lim2[l_ac2].lim02) THEN
              IF g_lim2[l_ac2].lim02 != g_lim2_t.lim02
                 OR g_lim2_t.lim02 IS NULL THEN
                 IF g_lim2[l_ac2].lim02 <= 0 THEN
                    CALL cl_err('','aec-994',0)
                    LET g_lim2[l_ac2].lim02 = g_lim2_t.lim02
                    NEXT FIELD lim02_2
                 END IF 
                 SELECT count(*)
                   INTO l_n
                   FROM lim_file
                  WHERE lim01 = g_lil.lil01
                    AND lim02 = g_lim2[l_ac2].lim02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lim2[l_ac2].lim02 = g_lim2_t.lim02
                    NEXT FIELD lim02_2
                 END IF
              END IF
           END IF

     AFTER FIELD lim03_2,lim04_2
          IF NOT cl_null(g_lim2[l_ac2].lim03) OR NOT cl_null(g_lim2[l_ac2].lim04) THEN
             IF g_lim2[l_ac2].lim03 < g_lil.lil12 OR g_lim2[l_ac2].lim04 > g_lil.lil13 THEN
                CALL cl_err('','alm-862',0)
                NEXT FIELD CURRENT
             END IF
          END IF
          IF NOT cl_null(g_lim2[l_ac2].lim03) AND NOT cl_null(g_lim2[l_ac2].lim04) THEN
             IF g_lim2[l_ac2].lim03 > g_lim2[l_ac2].lim04 THEN
                CALL cl_err('','alm1038',0)
                NEXT FIELD CURRENT
             END IF
             IF p_cmd= 'a' THEN
                #FUN-CA0081----add---str
                SELECT COUNT(*) INTO l_n FROM lim_file
                 WHERE lim01 = g_lil.lil01
                   AND lim03 = g_lim2[l_ac2].lim03
                   AND lim04 = g_lim2[l_ac2].lim04
                IF l_n = 0 THEN
                #FUN-CA0081----add---end
                   SELECT COUNT(*) INTO l_n FROM lim_file 
                    WHERE lim01 = g_lil.lil01 
                      AND ((g_lim2[l_ac2].lim03 BETWEEN lim03 AND lim04
                           OR g_lim2[l_ac2].lim04 BETWEEN lim03 AND lim04)
                      OR  (lim03 BETWEEN g_lim2[l_ac2].lim03 AND g_lim2[l_ac2].lim04
                            OR lim04 BETWEEN g_lim2[l_ac2].lim03 AND g_lim2[l_ac2].lim04 ))
                   IF l_n > 0 THEN
                      CALL cl_err('','alm-863',0)
                      NEXT FIELD CURRENT
                   END IF
                END IF #FUN-CA0081 add
             ELSE
                IF g_lim2[l_ac2].lim03 <> g_lim2_t.lim03 OR g_lim2[l_ac2].lim04 <> g_lim2_t.lim04 THEN
                  #FUN-CA0081----add---str
                  SELECT COUNT(*) INTO l_n FROM lim_file
                   WHERE lim01 = g_lil.lil01
                     AND lim02 <> g_lim2_t.lim02
                     AND lim03 = g_lim2[l_ac2].lim03
                     AND lim04 = g_lim2[l_ac2].lim04
                  IF l_n = 0 THEN
                  #FUN-CA0081----add---end
                     SELECT COUNT(*) INTO l_n FROM lim_file 
                      WHERE lim01 = g_lil.lil01 
                        AND lim02 <> g_lim2_t.lim02
                        AND ((g_lim2[l_ac2].lim03 BETWEEN lim03 AND lim04
                               OR g_lim2[l_ac2].lim04 BETWEEN lim03 AND lim04)
                       OR  (lim03 BETWEEN g_lim2[l_ac2].lim03 AND g_lim2[l_ac2].lim04
                            OR lim04 BETWEEN g_lim2[l_ac2].lim03 AND g_lim2[l_ac2].lim04 ))
                     IF l_n > 0 THEN
                        CALL cl_err('','alm-863',0)
                        NEXT FIELD CURRENT
                     END IF
                  END IF #FUN-CA0081 add
                END IF
             END IF
             #FUN-CA0081---------add----str
             IF cl_null(g_lim2[l_ac2].lim063) AND cl_null(g_lim2[l_ac2].lim064) THEN
                CALL i360_chk_lim03_lim04(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD CURRENT
                END IF
             END IF
             IF NOT cl_null(g_lim2[l_ac2].lim063) AND NOT cl_null(g_lim2[l_ac2].lim064) THEN
                CALL i360_chk_lim071(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,g_lim2[l_ac2].lim063,g_lim2[l_ac2].lim064,p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD CURRENT
                END IF
             END IF
             #FUN-CA0081---------add----end
          END IF

      AFTER FIELD lim061
         IF NOT cl_null(g_lim2[l_ac2].lim061) THEN
            IF g_lim2[l_ac2].lim061 <0 OR g_lim2[l_ac2].lim061 >100 THEN
               CALL cl_err('','mfg0091',0)
               NEXT FIELD lim061
            END IF
         END IF  

      AFTER FIELD lim062
         IF NOT cl_null(g_lim2[l_ac2].lim062) THEN
            IF g_lim2[l_ac2].lim062 <0  THEN
               CALL cl_err('','alm1088',0)
               NEXT FIELD lim062
            END IF
         END IF 
     
      #FUN-CA0081-----add---str
      AFTER FIELD lim063
         IF NOT cl_null(g_lim2[l_ac2].lim063) THEN
            IF g_lim2[l_ac2].lim063 < 0 THEN
               CALL cl_err('','alm1089',0)
               LET g_lim2[l_ac2].lim063 = g_lim2_t.lim063
               NEXT FIELD lim063
            END IF
         END IF
         IF NOT cl_null(g_lim2[l_ac2].lim063) AND NOT cl_null(g_lim2[l_ac2].lim064) THEN
            IF g_lim2[l_ac2].lim063 > g_lim2[l_ac2].lim064 THEN
               CALL cl_err('','alm-161',0)
               NEXT FIELD lim063
            END IF
            IF NOT cl_null(g_lim2[l_ac2].lim03) AND NOT cl_null(g_lim2[l_ac2].lim04) THEN
               CALL i360_chk_lim071(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,g_lim2[l_ac2].lim063,g_lim2[l_ac2].lim064,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lim063
               END IF
            END IF
         END IF
         IF (cl_null(g_lim2[l_ac2].lim064) AND NOT cl_null(g_lim2[l_ac2].lim063))
            OR (cl_null(g_lim2[l_ac2].lim063) AND NOT cl_null(g_lim2[l_ac2].lim064))THEN
            CALL cl_err('','alm1383',0)
         END IF
         IF cl_null(g_lim2[l_ac2].lim063) AND cl_null(g_lim2[l_ac2].lim064) THEN
            IF NOT cl_null(g_lim2[l_ac2].lim03) AND NOT cl_null(g_lim2[l_ac2].lim04) THEN
               CALL i360_chk_lim063(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
               END IF
            END IF
         END IF

      AFTER FIELD lim064
         IF NOT cl_null(g_lim2[l_ac2].lim064) THEN
            IF g_lim2[l_ac2].lim064 < 0 THEN
               CALL cl_err('','alm1090',0)
               LET g_lim2[l_ac2].lim064 = g_lim2_t.lim064
               NEXT FIELD lim064
            END IF
         END IF
         IF NOT cl_null(g_lim2[l_ac2].lim063) AND NOT cl_null(g_lim2[l_ac2].lim064) THEN
            IF g_lim2[l_ac2].lim063 > g_lim2[l_ac2].lim064 THEN
               CALL cl_err('','alm-161',0)
               NEXT FIELD lim064
            END IF
            IF NOT cl_null(g_lim2[l_ac2].lim03) AND NOT cl_null(g_lim2[l_ac2].lim04) THEN
               CALL i360_chk_lim071(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,g_lim2[l_ac2].lim063,g_lim2[l_ac2].lim064,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lim064
               END IF
            END IF
         END IF
         IF (cl_null(g_lim2[l_ac2].lim064) AND NOT cl_null(g_lim2[l_ac2].lim063))
            OR (cl_null(g_lim2[l_ac2].lim063) AND NOT cl_null(g_lim2[l_ac2].lim064))THEN
            CALL cl_err('','alm1383',0)
         END IF
         IF cl_null(g_lim2[l_ac2].lim063) AND cl_null(g_lim2[l_ac2].lim064) THEN
            IF NOT cl_null(g_lim2[l_ac2].lim03) AND NOT cl_null(g_lim2[l_ac2].lim04) THEN
               CALL i360_chk_lim063(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
               END IF
            END IF
         END IF
        
      ON CHANGE lim03_2,lim04_2,lim063,lim064
         CALL i360_set_required(g_lim2[l_ac2].lim03,g_lim2[l_ac2].lim04,g_lim2_t.lim02,g_lim2[l_ac2].lim063,g_lim2[l_ac2].lim064,p_cmd)

      #FUN-CA0081-----add---end 
           
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lim2[l_ac2].* = g_lim2_t.*
              CLOSE i360_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lim2[l_ac2].lim02,-263,1)
              LET g_lim2[l_ac2].* = g_lim2_t.*
           ELSE
              UPDATE lim_file SET lim02 = g_lim2[l_ac2].lim02,
                                  lim03 = g_lim2[l_ac2].lim03,
                                  lim04 = g_lim2[l_ac2].lim04,
                                  lim06 = g_lim2[l_ac2].lim06,
                                  lim071 = g_lim2[l_ac2].lim063,  #FUN-CA0081 add
                                  lim072 = g_lim2[l_ac2].lim064,  #FUN-CA0081 add
                                  lim061 = g_lim2[l_ac2].lim061,
                                  lim062 = g_lim2[l_ac2].lim062
               WHERE lim01=g_lil.lil01 
                 AND lim02=g_lim2_t.lim02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","lim_file",g_lim2_t.lim02,'',SQLCA.SQLCODE,"","",1)  
                 LET g_lim2[l_ac2].* = g_lim2_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac2 = ARR_CURR()
           LET l_ac2_t = l_ac2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lim2[l_ac2].* = g_lim2_t.*
              END IF
              CLOSE i360_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i360_bc2
           COMMIT WORK
         
 
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
 
       ON ACTION HELP
          CALL cl_show_help()
          
       ON ACTION controls
         CALL cl_set_head_visible("","AUTO")                                                                                                      
           
                                                                                 
   END INPUT
   
   IF p_cmd = 'u' THEN
      LET g_lil.lilmodu = g_user
      LET g_lil.lildate = g_today
      UPDATE lil_file SET lilmodu = g_lil.lilmodu,
                          lildate = g_lil.lildate
         WHERE lil01 = g_lil.lil01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lil_file",g_lil.lil01,"",SQLCA.SQLCODE,"","upd lil",1)  
      END IF
      DISPLAY BY NAME g_lil.lilmodu,g_lil.lildate
   END IF
   CLOSE i360_bc2
   COMMIT WORK
END FUNCTION

FUNCTION i360_b3()
DEFINE
   l_ac3_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_n1            LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5

   LET g_b_flag = '3'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN RETURN END IF
   SELECT * INTO g_lil.* FROM lil_file WHERE lil01=g_lil.lil01 
   IF g_lil.lilconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lim02,lim03,lim04,lim07,lim071,lim072,lim073 FROM lim_file ", 
                      " WHERE lim02=? AND lim01='",g_lil.lil01,"'",
                      " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i360_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac3_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lim3 WITHOUT DEFAULTS FROM s_lim3.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac3)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac3 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i360_cl USING g_lil.lil01
           IF STATUS THEN
              CALL cl_err("OPEN i360_cl:", STATUS, 1)
              CLOSE i360_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i360_cl INTO g_lil.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_lil.lil01,SQLCA.SQLCODE,0)
              CLOSE i360_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b3>=l_ac3 THEN
              LET p_cmd='u'
              LET g_lim3_t.* = g_lim3[l_ac3].*   #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN i360_bc3 USING g_lim3_t.lim02
              IF STATUS THEN
                 CALL cl_err("OPEN i360_bc3:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i360_bc3 INTO g_lim3[l_ac3].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_lim3_t.lim02,SQLCA.SQLCODE , 1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lim3[l_ac3].* TO NULL
           LET g_lim3_t.* = g_lim3[l_ac3].*
           CALL cl_show_fld_cont()
           NEXT FIELD lim02_3

       BEFORE DELETE 
          IF NOT cl_delb(0,0) THEN
             CANCEL DELETE
          END IF
          IF l_lock_sw = "Y" THEN
             CALL cl_err("", -263, 1)
             CANCEL DELETE
          END IF
          DELETE FROM lim_file
           WHERE lim01 = g_lil.lil01
             AND lim02 = g_lim3_t.lim02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","lim_file",g_lil.lil01,g_lim3_t.lim02,SQLCA.sqlcode,"","",1)  
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          LET g_rec_b3=g_rec_b3-1
          COMMIT WORK
           
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lim_file(lim01,lim02,lim03,lim04,lim07,lim071,lim072,lim073,limplant,limlegal)
                        VALUES(g_lil.lil01,g_lim3[l_ac3].lim02,g_lim3[l_ac3].lim03,
                         g_lim3[l_ac3].lim04,g_lim3[l_ac3].lim07,
                         g_lim3[l_ac3].lim071,g_lim3[l_ac3].lim072,g_lim3[l_ac3].lim073,g_plant,g_legal)                               
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","lim_file",g_lil.lil01,"",SQLCA.SQLCODE,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b3=g_rec_b3+1   
           END IF

       BEFORE FIELD lim02_3
         IF g_lim3[l_ac3].lim02 IS NULL OR g_lim3[l_ac3].lim02 = 0 THEN
              SELECT max(lim02)+1
                INTO g_lim3[l_ac3].lim02
                FROM lim_file
               WHERE lim01 = g_lil.lil01
              IF g_lim3[l_ac3].lim02 IS NULL THEN
                 LET g_lim3[l_ac3].lim02 = 1
              END IF
         END IF

      AFTER FIELD lim02_3
           IF NOT cl_null(g_lim3[l_ac3].lim02) THEN
              IF g_lim3[l_ac3].lim02 != g_lim3_t.lim02
                 OR g_lim3_t.lim02 IS NULL THEN
                 IF g_lim3[l_ac3].lim02 <= 0 THEN
                    CALL cl_err('','aec-994',0)
                    LET g_lim3[l_ac3].lim02 = g_lim3_t.lim02
                    NEXT FIELD lim02_3
                 END IF 
                 SELECT count(*)
                   INTO l_n
                   FROM lim_file
                  WHERE lim01 = g_lil.lil01
                    AND lim02 = g_lim3[l_ac3].lim02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lim3[l_ac3].lim02 = g_lim3_t.lim02
                    NEXT FIELD lim02_3
                 END IF
              END IF
           END IF

      AFTER FIELD lim03_3,lim04_3
          IF NOT cl_null(g_lim3[l_ac3].lim03) OR NOT cl_null(g_lim3[l_ac3].lim04) THEN
             IF g_lim3[l_ac3].lim03 < g_lil.lil12 OR g_lim3[l_ac3].lim04 > g_lil.lil13 THEN
                CALL cl_err('','alm-862',0)
                NEXT FIELD CURRENT
             END IF
          END IF
          IF NOT cl_null(g_lim3[l_ac3].lim03) AND NOT cl_null(g_lim3[l_ac3].lim04) THEN
             IF g_lim3[l_ac3].lim03 > g_lim3[l_ac3].lim04 THEN
                CALL cl_err('','alm1038',0)
                NEXT FIELD CURRENT
             END IF
             IF NOT cl_null(g_lim3[l_ac3].lim071) AND NOT cl_null(g_lim3[l_ac3].lim072) THEN
              IF p_cmd = 'a' THEN
                 SELECT COUNT(*) INTO l_n FROM lim_file 
                 WHERE lim01 = g_lil.lil01 
                   AND ((g_lim3[l_ac3].lim03 BETWEEN lim03 AND lim04
                        OR g_lim3[l_ac3].lim04 BETWEEN lim03 AND lim04)
                        OR (lim03 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04
                        OR lim04 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04 ))
                   AND ((g_lim3[l_ac3].lim071 BETWEEN lim071 AND lim072
                        OR g_lim3[l_ac3].lim072 BETWEEN lim071 AND lim072)
                        OR  (lim071 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072
                        OR lim072 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072 ))
                   IF l_n > 0 THEN
                      CALL cl_err('','alm-872',0)
                      NEXT FIELD CURRENT
                   END IF
              ELSE
               IF g_lim3[l_ac3].lim03 <> g_lim3_t.lim03 OR g_lim3[l_ac3].lim04 <> g_lim3_t.lim04
                 OR g_lim3[l_ac3].lim071 <> g_lim3_t.lim071 OR g_lim3[l_ac3].lim072 <> g_lim3_t.lim072 THEN
                  SELECT COUNT(*) INTO l_n FROM lim_file 
                   WHERE lim01 = g_lil.lil01 
                     AND lim02 <> g_lim3_t.lim02
                     AND ((g_lim3[l_ac3].lim03 BETWEEN lim03 AND lim04
                        OR g_lim3[l_ac3].lim04 BETWEEN lim03 AND lim04)
                        OR (lim03 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04
                         OR lim04 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04 ))
                     AND ((g_lim3[l_ac3].lim071 BETWEEN lim071 AND lim072
                        OR g_lim3[l_ac3].lim072 BETWEEN lim071 AND lim072)
                        OR  (lim071 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072
                        OR lim072 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072 ))
                  IF l_n > 0 THEN
                     CALL cl_err('','alm-872',0)
                     NEXT FIELD CURRENT
                  END IF
               END IF
             END IF
            END IF
          END IF


      AFTER FIELD lim071,lim072
          IF NOT cl_null(g_lim3[l_ac3].lim071) THEN
             IF g_lim3[l_ac3].lim071 < 0 THEN
                CALL cl_err('','mfg0091',0)
                NEXT FIELD lim071
             END IF
          END IF
          IF NOT cl_null(g_lim3[l_ac3].lim072) THEN
             IF g_lim3[l_ac3].lim072 < 0 THEN
                CALL cl_err('','mfg0091',0)
                NEXT FIELD lim072
             END IF
          END IF
          IF NOT cl_null(g_lim3[l_ac3].lim071) AND NOT cl_null(g_lim3[l_ac3].lim072) THEN
             IF g_lim3[l_ac3].lim071 > g_lim3[l_ac3].lim072 THEN
                CALL cl_err('','alm-161',0)
                NEXT FIELD CURRENT
             END IF
             IF NOT cl_null(g_lim3[l_ac3].lim03) AND NOT cl_null(g_lim3[l_ac3].lim04) THEN
             IF p_cmd = 'a' THEN
                SELECT COUNT(*) INTO l_n FROM lim_file 
                 WHERE lim01 = g_lil.lil01 
                   AND ((g_lim3[l_ac3].lim03 BETWEEN lim03 AND lim04
                        OR g_lim3[l_ac3].lim04 BETWEEN lim03 AND lim04)
                        OR (lim03 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04
                         OR lim04 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04  ))
                     AND ((g_lim3[l_ac3].lim071 BETWEEN lim071 AND lim072
                        OR g_lim3[l_ac3].lim072 BETWEEN lim071 AND lim072)
                        OR  (lim071 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072
                        OR lim072 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072 ))     
                IF l_n > 0 THEN
                   CALL cl_err('','alm-872',0)
                   NEXT FIELD CURRENT
                END IF
             ELSE
               IF g_lim3[l_ac3].lim071 <> g_lim3_t.lim071 OR g_lim3[l_ac3].lim072 <> g_lim3_t.lim072 
                 OR g_lim3[l_ac3].lim03 <> g_lim3_t.lim03 OR g_lim3[l_ac3].lim04 <> g_lim3_t.lim04 THEN
                  SELECT COUNT(*) INTO l_n FROM lim_file 
                   WHERE lim01 = g_lil.lil01 
                     AND lim02 <> g_lim3_t.lim02
                     AND ((g_lim3[l_ac3].lim03 BETWEEN lim03 AND lim04
                        OR g_lim3[l_ac3].lim04 BETWEEN lim03 AND lim04)
                        OR (lim03 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04
                         OR lim04 BETWEEN g_lim3[l_ac3].lim03 AND g_lim3[l_ac3].lim04 ))
                      AND ((g_lim3[l_ac3].lim071 BETWEEN lim071 AND lim072
                        OR g_lim3[l_ac3].lim072 BETWEEN lim071 AND lim072)
                        OR  (lim071 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072
                        OR lim072 BETWEEN g_lim3[l_ac3].lim071 AND g_lim3[l_ac3].lim072 ))
                  IF l_n > 0 THEN
                     CALL cl_err('','alm-872',0)
                     NEXT FIELD CURRENT
                  END IF
               END IF
             END IF
             END IF
          END IF 
          
   
          

    AFTER FIELD lim073
          IF NOT cl_null(g_lim3[l_ac3].lim073) THEN
             IF g_lim3[l_ac3].lim073 < 0 THEN
                CALL cl_err('','alm1080',0)
                NEXT FIELD lim073
             END IF
          END IF
      
        
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lim3[l_ac3].* = g_lim3_t.*
              CLOSE i360_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lim3[l_ac3].lim02,-263,1)
              LET g_lim3[l_ac3].* = g_lim3_t.*
           ELSE
              UPDATE lim_file SET lim02 = g_lim3[l_ac3].lim02,
                                  lim03 = g_lim3[l_ac3].lim03,
                                  lim04 = g_lim3[l_ac3].lim04,
                                  lim07 = g_lim3[l_ac3].lim07,
                                  lim071 = g_lim3[l_ac3].lim071,
                                  lim072 = g_lim3[l_ac3].lim072,
                                  lim073 = g_lim3[l_ac3].lim073
               WHERE lim01=g_lil.lil01 
                 AND lim02=g_lim3_t.lim02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","lim_file",g_lim3_t.lim02,'',SQLCA.SQLCODE,"","",1)  
                 LET g_lim3[l_ac3].* = g_lim3_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac3 = ARR_CURR()
           LET l_ac3_t = l_ac3
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lim3[l_ac3].* = g_lim3_t.*
              END IF
              CLOSE i360_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i360_bc3
           COMMIT WORK
         
 
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
 
       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
           
                                                                                 
   END INPUT
   
   IF p_cmd = 'u' THEN
      LET g_lil.lilmodu = g_user
      LET g_lil.lildate = g_today
      UPDATE lil_file SET lilmodu = g_lil.lilmodu,
                          lildate = g_lil.lildate
         WHERE lil01 = g_lil.lil01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lil_file",g_lil.lil01,"",SQLCA.SQLCODE,"","upd lil",1)  
      END IF
      DISPLAY BY NAME g_lil.lilmodu,g_lil.lildate
   END IF
   CLOSE i360_bc3
   COMMIT WORK
END FUNCTION
 
FUNCTION i360_b1_fill(p_wc)
DEFINE l_sql      STRING
DEFINE p_wc       STRING

   LET l_sql = "SELECT lim02,lim03,lim04,lim05,lim051",
               " FROM lim_file ",
               "WHERE lim01 = '",g_lil.lil01,"'",
               "  AND limplant = '",g_lil.lilplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE i360_cr1 CURSOR FROM l_sql
   CALL g_lim1.clear()
   LET g_rec_b1 = 0
   LET g_cnt = 1
   FOREACH i360_cr1 INTO g_lim1[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lim1.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   LET g_cnt = 1
   DISPLAY g_rec_b1 TO FORMONLY.c1
   CLOSE i360_cr1
   CALL i360_bp1_refresh()
END FUNCTION
 
FUNCTION i360_bp1_refresh()
  DISPLAY ARRAY g_lim1 TO s_lim1.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION i360_b2_fill(p_wc)
DEFINE l_sql,p_wc        STRING
 
   LET l_sql = "SELECT lim02,lim03,lim04,lim06,lim071,lim072,lim061,lim062 FROM lim_file ",   #FUN-CA0081 add lim071,lim072
               "WHERE lim01 = '",g_lil.lil01,"'",
               "  AND limplant = '",g_lil.lilplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE i360_cr2 CURSOR FROM l_sql
 
   CALL g_lim2.clear()
   LET g_rec_b2 = 0
 
   LET g_cnt = 1
   FOREACH i360_cr2 INTO g_lim2[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lim2.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.c1
   LET g_cnt = 1
   CLOSE i360_cr2
   CALL i360_bp2_refresh()
END FUNCTION
 
FUNCTION i360_bp2_refresh()
  DISPLAY ARRAY g_lim2 TO s_lim2.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION i360_b3_fill(p_wc)
DEFINE l_sql,p_wc        STRING
 
   LET l_sql = "SELECT lim02,lim03,lim04,lim07,lim071,lim072,lim073 FROM lim_file ", 
               " WHERE lim01 = '",g_lil.lil01,"'",
               "   AND limplant = '",g_lil.lilplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE i360_cr3 CURSOR FROM l_sql
 
   CALL g_lim3.clear()
   LET g_rec_b3 = 0
 
   LET g_cnt = 1
   FOREACH i360_cr3 INTO g_lim3[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lim3.deleteElement(g_cnt)
   LET g_rec_b3 = g_cnt - 1
   DISPLAY g_rec_b3 TO FORMONLY.c1
   LET g_cnt = 1
   CLOSE i360_cr3
   CALL i360_bp3_refresh()
END FUNCTION

FUNCTION i360_bp3_refresh()
  DISPLAY ARRAY g_lim3 TO s_lim3.* ATTRIBUTE(COUNT = g_rec_b3,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION


 
FUNCTION i360_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lim1 TO s_lim1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
 
 
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

      
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac1 = 1
         EXIT DISPLAY
   
       
                                                                                                                                    
      ON ACTION exporttoexcel          
         LET g_action_choice = 'exporttoexcel' 
         EXIT DISPLAY
 

      ON ACTION first
         CALL i360_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL i360_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL i360_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL i360_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL i360_fetch('L')
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL cl_set_field_pic(g_lil.lilconf,g_lil.lil17,"","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION over
         LET g_action_choice="over"
         EXIT DISPLAY
 
      ON ACTION dinge
         LET g_b_flag = '1'
         LET g_action_choice = "dinge"
         EXIT DISPLAY
 
      ON ACTION bili
         LET g_b_flag = '2'
         LET g_action_choice = "bili"
         EXIT DISPLAY

      ON ACTION fenduan
         LET g_b_flag = '3'
         LET g_action_choice = "fenduan"
         EXIT DISPLAY
   
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac1 = ARR_CURR()
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION i360_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lim2 TO s_lim2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()  
 
                                                                                              
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

      
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         EXIT DISPLAY
 

      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'  
         EXIT DISPLAY
 

      ON ACTION first
         CALL i360_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL i360_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL i360_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL i360_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL i360_fetch('L')
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL cl_set_field_pic(g_lil.lilconf,g_lil.lil17,"","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION over
         LET g_action_choice="over"
         EXIT DISPLAY
 
      ON ACTION dinge
         LET g_b_flag = '1'
         LET g_action_choice = "dinge"
         EXIT DISPLAY
 
      ON ACTION bili
         LET g_b_flag = '2'
         LET g_action_choice = "bili"
         EXIT DISPLAY

      ON ACTION fenduan
         LET g_b_flag = '3'
         LET g_action_choice = "fenduan"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
    
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION i360_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lim3 TO s_lim3.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()  
 
                                                                                              
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

     
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac3 = 1
         EXIT DISPLAY
 
     
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'  
         EXIT DISPLAY
 

      ON ACTION first
         CALL i360_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL i360_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL i360_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL i360_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL i360_fetch('L')
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL cl_set_field_pic(g_lil.lilconf,g_lil.lil17,"","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION over
         LET g_action_choice="over"
         EXIT DISPLAY
 
      ON ACTION dinge
         LET g_b_flag = '1'
         LET g_action_choice = "dinge"
         EXIT DISPLAY
 
      ON ACTION bili
         LET g_b_flag = '2'
         LET g_action_choice = "bili"
         EXIT DISPLAY

      ON ACTION fenduan
         LET g_b_flag = '3'
         LET g_action_choice = "fenduan"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
    
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac3 = ARR_CURR()
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
         
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i360_r()
   DEFINE l_cnt    LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   IF g_lil.lil01 IS NULL OR g_lil.lilplant IS NULL THEN 
      CALL cl_err('',-400,2) 
      RETURN 
   END IF
   SELECT * INTO g_lil.* FROM lil_file WHERE lil01 = g_lil.lil01
   IF g_lil.lilconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_lil.lilconf = 'S' THEN CALL cl_err('','alm-228',0) RETURN END IF
   IF g_lil.lilacti='N' THEN CALL cl_err('','aic-201',0) RETURN END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN i360_cl USING g_lil.lil01
   FETCH i360_cl INTO g_lil.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lil.lil01,SQLCA.SQLCODE,0)
      CLOSE i360_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_lil_t.* = g_lil.*
   CALL i360_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          
       LET g_doc.column1 = "lil01"        
       LET g_doc.value1 = g_lil.lil01      
       CALL cl_del_doc()                                     
      DELETE FROM lil_file 
         WHERE lil01=g_lil.lil01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lil_file",g_lil.lil01,"",SQLCA.SQLCODE,"","(i360_r:delete lil)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM lim_file 
         WHERE lim01 = g_lil.lil01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lim_file",g_lil.lil01,"",SQLCA.SQLCODE,"","(i360_r:delete lim)",1) 
         LET g_success='N'
      END IF

      INITIALIZE g_lil.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM
         LET g_lil_t.* = g_lil.*
         CALL g_lim1.clear()
         CALL g_lim2.clear()
         CALL g_lim3.clear()
         OPEN i360_count
         FETCH i360_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i360_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i360_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i360_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_lil.* = g_lil_t.*
      END IF
   END IF
   CALL i360_show()
END FUNCTION

FUNCTION i360_chk_lil04()
DEFINE l_n        LIKE type_file.num5
DEFINE l_lnlacti  LIKE lnl_file.lnlacti

  LET g_errno = ' '
  SELECT COUNT(*) INTO l_n FROM lnl_file WHERE lnl01 = g_lil.lil04 
                                           AND lnlstore = g_lil.lilplant
  IF l_n = 0 THEN
     LET g_errno = 'alm-864'
     RETURN
  ELSE
    SELECT lnlacti INTO  l_lnlacti FROM lnl_file WHERE lnl01 = g_lil.lil04
                                                   AND lnlstore = g_lil.lilplant
    IF l_lnlacti = 'N' THEN
       LET g_errno = 'alm1032'
       RETURN
    END IF
  END IF   

END FUNCTION

FUNCTION  i360_lil04() 
DEFINE  l_lnl03   LIKE lnl_file.lnl03
DEFINE  l_lnl04   LIKE lnl_file.lnl04
DEFINE  l_lnl05   LIKE lnl_file.lnl05
DEFINE  l_lnl09   LIKE lnl_file.lnl09
DEFINE  l_oaj02   LIKE oaj_file.oaj02

   
   SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file WHERE lnl01 = g_lil.lil04 AND lnlstore = g_lil.lilplant
   IF l_lnl03 = 'Y' THEN
      CALL cl_set_comp_entry("lil05",TRUE)
   ELSE
      CALL cl_set_comp_entry("lil05",FALSE) 
   END IF  
   IF l_lnl04 = 'Y' THEN
      CALL cl_set_comp_entry("lil06",TRUE) 
   ELSE
      CALL cl_set_comp_entry("lil06",FALSE) 
   END IF
   IF l_lnl05 = 'Y' THEN
      CALL cl_set_comp_entry("lil07",TRUE) 
   ELSE
      CALL cl_set_comp_entry("lil07",FALSE) 
   END IF
   IF l_lnl09 = 'Y' THEN
      CALL cl_set_comp_entry("lil08",TRUE) 
   ELSE
      CALL cl_set_comp_entry("lil08",FALSE) 
   END IF
   SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = g_lil.lil04 
   DISPLAY l_oaj02 TO FORMONLY.lil04_desc
   
END FUNCTION

FUNCTION i360_chk_lil05()
DEFINE l_n        LIKE type_file.num5
DEFINE l_n1       LIKE type_file.num5
DEFINE l_n2       LIKE type_file.num5
DEFINE l_lmb06    LIKE lmb_file.lmb06

   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n FROM lmb_file WHERE lmb02 = g_lil.lil05
                                            AND lmbstore = g_plant
   IF l_n = 0 THEN
      LET g_errno = 'alm-003'
      RETURN
   ELSE 
      SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lil.lil04
                                                AND lik03 = '*' AND likstore = g_plant
      IF l_n1 = 0 THEN
         SELECT COUNT(*) INTO l_n2 FROM lik_file WHERE lik01 = g_lil.lil04
                                                   AND lik03 = g_lil.lil05 AND likstore = g_plant
         IF l_n2 = 0 THEN
            LET g_errno = 'alm-865'
            RETURN
         END IF
      END IF 
      SELECT lmb06 INTO l_lmb06 FROM lmb_file WHERE lmb02 = g_lil.lil05 AND lmbstore = g_plant
      IF l_lmb06 = 'N' THEN
         LET g_errno = 'alm-905'
         RETURN
      END IF
   END IF
END FUNCTION                                                
   
FUNCTION  i360_lil05() 
DEFINE l_lmb03  LIKE lmb_file.lmb03

   SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmb02 = g_lil.lil05 AND lmbstore = g_plant
   DISPLAY l_lmb03 TO FORMONLY.lil05_desc

END FUNCTION 

FUNCTION i360_chk_lil06()
DEFINE l_n      LIKE type_file.num5
DEFINE l_n1     LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_lmc07  LIKE lmc_file.lmc07

   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n FROM lmc_file WHERE lmc03 = g_lil.lil06 AND lmcstore = g_plant
   IF l_n = 0 THEN
      LET g_errno = 'alm-554'
      RETURN
   ELSE
      SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lil.lil04 
                                                AND lik04 = '*'
      IF l_n1 = 0 THEN
         SELECT COUNT(*) INTO l_n2 FROM lik_file WHERE lik01 = g_lil.lil04 
                                                   AND lik04 = g_lil.lil06
            IF l_n2 = 0 THEN 
               LET g_errno = 'alm-866'
               RETURN 
            END IF
      END IF
      IF NOT cl_null(g_lil.lil05) THEN
         SELECT lmc07 INTO l_lmc07 FROM  lmc_file  WHERE lmc03 = g_lil.lil06 AND lmcstore = g_plant
                                                     AND lmc02 = g_lil.lil05
         IF SQLCA.SQLCODE = 100 THEN
            LET g_errno = 'alm-907'
            RETURN 
         END IF 
         IF l_lmc07 = 'N' AND SQLCA.SQLCODE = 0 THEN
            LET g_errno = 'alm-908'
            RETURN 
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i360_lil06()
DEFINE l_lmc04     LIKE lmc_file.lmc04
   IF NOT cl_null(g_lil.lil05) THEN
      SELECT lmc04 INTO l_lmc04 FROM  lmc_file  WHERE lmc03 = g_lil.lil06 AND lmcstore = g_plant
                                                  AND lmc02 = g_lil.lil05
   ELSE
      SELECT lmc04 INTO l_lmc04 FROM  lmc_file  WHERE lmc03 = g_lil.lil06 AND lmcstore = g_plant
      IF SQLCA.SQLCODE = -284 THEN
         LET l_lmc04 = ' '
      END IF 
   END IF   
   DISPLAY l_lmc04 TO FORMONLY.lil06_desc
   
END FUNCTION

FUNCTION i360_chk_lil07()
DEFINE l_n       LIKE type_file.num5
DEFINE l_n1      LIKE type_file.num5
DEFINE l_n2      LIKE type_file.num5
DEFINE l_n3      LIKE type_file.num5
DEFINE l_n4      LIKE type_file.num5
DEFINE l_lmyacti LIKE lmy_file.lmyacti

    LET g_errno = ' '
    SELECT COUNT(*) INTO l_n FROM lmy_file WHERE lmy03 = g_lil.lil07 AND lmystore = g_plant
    IF l_n = 0 THEN
       LET g_errno = 'alm-767'
       RETURN
    ELSE
       SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lil.lil04 
                                                 AND lik05 = '*'
       IF l_n1 = 0 THEN
          SELECT COUNT(*) INTO l_n2 FROM lik_file WHERE lik01 = g_lil.lil04 
                                                    AND lik05 = g_lil.lil07
            IF l_n2 = 0 THEN 
               LET g_errno = 'alm-867'
               RETURN 
            END IF
       END IF
       IF NOT cl_null(g_lil.lil05) THEN
          SELECT COUNT(*) INTO l_n3 FROM  lmy_file  
           WHERE lmy01 = g_lil.lil05 AND lmy03 = g_lil.lil07 AND lmystore = g_plant
          IF l_n3 = 0 THEN
             LET g_errno = 'alm-747'
             RETURN 
          END IF
       END IF
       IF NOT cl_null(g_lil.lil06) THEN
          SELECT COUNT(*) INTO l_n4 FROM  lmy_file  
           WHERE lmy02 = g_lil.lil06 AND lmy03 = g_lil.lil07 AND lmystore = g_plant
          IF l_n4 = 0 THEN
             LET g_errno = 'alm-749'
             RETURN 
          END IF
       END IF
       IF NOT cl_null(g_lil.lil05) AND NOT cl_null(g_lil.lil06) THEN
          SELECT lmyacti INTO l_lmyacti FROM  lmy_file  
           WHERE lmy01 = g_lil.lil05 AND lmy02 = g_lil.lil06
             AND lmy03 = g_lil.lil07 AND lmystore = g_plant
          IF SQLCA.SQLCODE = 100 THEN
             LET g_errno = 'alm-745'
             RETURN 
          END IF    
          IF l_lmyacti = 'N' AND SQLCA.SQLCODE = 0  THEN
             LET g_errno = 'alm-746'
             RETURN 
          END IF
       END IF
    END IF
    
END FUNCTION

FUNCTION i360_lil07()
DEFINE   l_lmy04    LIKE  lmy_file.lmy04
    IF NOT cl_null(g_lil.lil05) AND NOT cl_null(g_lil.lil06) THEN
       SELECT lmy04 INTO l_lmy04 FROM  lmy_file  
        WHERE lmy01 = g_lil.lil05 AND lmy02 = g_lil.lil06
          AND lmy03 = g_lil.lil07 AND lmystore = g_plant
    ELSE
       IF NOT cl_null(g_lil.lil05) THEN
          SELECT lmy04 INTO l_lmy04 FROM  lmy_file  
           WHERE lmy01 = g_lil.lil05 AND lmy03 = g_lil.lil07 AND lmystore = g_plant
          IF SQLCA.SQLCODE = -284 THEN
             LET l_lmy04 = ' '
          END IF  
       END IF
       IF NOT cl_null(g_lil.lil06) THEN
         SELECT lmy04 INTO l_lmy04 FROM  lmy_file  
          WHERE lmy02 = g_lil.lil06 AND lmy03 = g_lil.lil07 AND lmystore = g_plant
          IF SQLCA.SQLCODE = -284 THEN
             LET l_lmy04 = ' '
          END IF  
       END IF
    END IF
    DISPLAY l_lmy04 TO FORMONLY.lil07_desc

END FUNCTION


FUNCTION i360_chk_lil08()
DEFINE l_n         LIKE type_file.num5  
DEFINE l_n1        LIKE type_file.num5 
DEFINE l_obaacti   LIKE oba_file.obaacti 

   LET g_errno = ' '
   SELECT obaacti INTO l_obaacti FROM oba_file WHERE oba01 = g_lil.lil08
   IF STATUS = 100 THEN
      LET g_errno = 'alm-104'
      RETURN
   ELSE
      IF SQLCA.SQLCODE = 0 AND l_obaacti = 'N' THEN
        LET g_errno = 'alm-781'
        RETURN
      END IF
   END IF
   SELECT COUNT(*) INTO l_n FROM lik_file WHERE lik01 = g_lil.lil04  
                                            AND lik06 = '*'
   IF l_n = 0 THEN
      SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lil.lil04  
                                                AND lik06 = g_lil.lil08
      IF l_n1 = 0 THEN
        LET g_errno = 'alm-868'
        RETURN
      END IF
    END IF
END FUNCTION

FUNCTION i360_lil08()
DEFINE l_oba02    LIKE oba_file.oba02
   SELECT oba02  INTO l_oba02 FROM oba_file  WHERE oba01 = g_lil.lil08
   DISPLAY l_oba02 TO FORMONLY.lil08_desc
END FUNCTION


FUNCTION i360_chk_to()
DEFINE l_lnl03    LIKE lnl_file.lnl03
DEFINE l_lnl04    LIKE lnl_file.lnl04
DEFINE l_lnl05    LIKE lnl_file.lnl05
DEFINE l_lnl09    LIKE lnl_file.lnl09
DEFINE l_sql      STRING

   LET g_errno = ' '
   IF NOT cl_null(g_lil.lil04) AND NOT cl_null( g_lil.lil09) THEN
      SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
        FROM lnl_file WHERE lnl01 = g_lil.lil04 AND lnlstore = g_plant
      LET l_sql = " SELECT lik08,lik09,lik10 FROM lik_file WHERE lik01 = '",g_lil.lil04,"'",
                                                           "  AND lik07 = '",g_lil.lil09,"'"
      IF l_lnl03 = 'Y' THEN
         IF cl_null(g_lil.lil05) THEN
            RETURN
         END IF
         LET l_sql = l_sql," AND (lik03 = '",g_lil.lil05,"' OR lik03 = '*') "
      END IF
      IF l_lnl04 = 'Y' THEN
         IF cl_null(g_lil.lil06) THEN
            RETURN
         END IF
         LET l_sql = l_sql," AND (lik04 = '",g_lil.lil06,"' OR lik04 = '*') "
      END IF
      IF l_lnl05 = 'Y' THEN
         IF cl_null(g_lil.lil07) THEN
            RETURN
         END IF
         LET l_sql = l_sql," AND (lik05 = '",g_lil.lil07,"' OR lik05 = '*') "
      END IF
      IF l_lnl09 = 'Y' THEN
         IF cl_null(g_lil.lil08) THEN
            RETURN
         END IF
         LET l_sql = l_sql," AND (lik06 = '",g_lil.lil08,"' OR lik06 = '*') "
      END IF                                  
      PREPARE sel_lik_pre FROM l_sql
      EXECUTE sel_lik_pre INTO g_lil.lil10,g_lil.lil11,g_lik10
      IF sqlca.sqlcode = 100 THEN 
         LET g_lil.lil10 = ''
         LET g_lil.lil11 = ''
         LET g_lik10 = ''
         DISPLAY BY NAME g_lil.lil10,g_lil.lil11
         LET g_errno = 'alm-869'
         RETURN
      END IF
      IF NOT cl_null(g_lil.lil00 ) THEN
         IF g_lik10 <> g_lil.lil00 THEN
            LET g_errno = 'alm-870'
            LET g_lik10 = ''
            RETURN
         END IF
      ELSE
         LET g_lil.lil00 = g_lik10
          CASE g_lil.lil00
             WHEN '1' 
               CALL cl_set_comp_visible('Page4,Page5',FALSE)
               CALL cl_set_comp_visible('Page3',TRUE)
             WHEN '2'
               CALL cl_set_comp_visible('Page3,Page5',FALSE)
               CALL cl_set_comp_visible('Page4',TRUE)
             WHEN '3'
               CALL cl_set_comp_visible('Page3,Page4',FALSE)
               CALL cl_set_comp_visible('Page5',TRUE)
          END CASE
      END IF
      DISPLAY BY NAME g_lil.lil00,g_lil.lil10,g_lil.lil11
   END IF   

END FUNCTION

#TQC-C30210--start add----------------------------------
FUNCTION i360_lil15(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_gen02     LIKE gen_file.gen02
   DEFINE l_genacti   LIKE gen_file.genacti

   LET g_errno = ''

   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_lil.lil15

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno = 'aap-038'
      WHEN l_genacti <> 'Y'
         LET g_errno ='art-733'
       OTHERWISE
          LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.lil15_desc 
   END IF

END FUNCTION
#TQC-C30210--end add------------------------------------

FUNCTION i360_chk_lil12_lil13()
DEFINE l_sql     STRING
DEFINE l_n       LIKE type_file.num5
    LET g_errno = ' '
    LET l_sql = " SELECT COUNT(*) FROM lil_file WHERE lilplant = '",g_plant,"'",
                " AND (('",g_lil.lil12,"' BETWEEN lil12 AND lil13 ",
                "        OR '",g_lil.lil13,"' BETWEEN lil12 AND lil13 ) ",
                "  OR (lil12 BETWEEN '",g_lil.lil12,"'  AND '",g_lil.lil13,"'",
                "        OR lil13 BETWEEN '",g_lil.lil12,"'  AND '",g_lil.lil13,"'))",
                " AND lilconf <> 'S' AND lilacti = 'Y' "
                
    IF NOT cl_null( g_lil.lil01) THEN
       LET l_sql = l_sql," AND lil01 <> '",g_lil.lil01,"'"
    END IF
    IF NOT cl_null( g_lil.lil04) THEN   
       LET l_sql = l_sql," AND lil04 = '",g_lil.lil04,"'"
    END IF
    IF NOT cl_null( g_lil.lil05) THEN   
       LET l_sql = l_sql," AND lil05 = '",g_lil.lil05,"'"
    END IF
    IF NOT cl_null( g_lil.lil06) THEN   
       LET l_sql = l_sql," AND lil06 = '",g_lil.lil06,"'"
    END IF
    IF NOT cl_null( g_lil.lil07) THEN   
       LET l_sql = l_sql," AND lil07 = '",g_lil.lil07,"'"
    END IF
    IF NOT cl_null( g_lil.lil08) THEN   
       LET l_sql = l_sql," AND lil08 = '",g_lil.lil08,"'"
    END IF
    IF NOT cl_null( g_lil.lil09) THEN   
       LET l_sql = l_sql," AND lil09 = '",g_lil.lil09,"'"
    END IF
    PREPARE sel_num_pre FROM l_sql
    EXECUTE  sel_num_pre INTO l_n
    IF l_n > 0 THEN
       LET g_errno = 'alm-871'
    END IF

END FUNCTION


 
FUNCTION i360_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' THEN
     CALL cl_set_comp_entry("lil00,lil01",TRUE) 
   END IF
END FUNCTION
 
FUNCTION i360_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF  p_cmd = 'a' THEN
      CALL cl_set_comp_entry("lil05,lil06,lil07,lil08",FALSE) 
   END IF
   IF p_cmd = 'u' THEN
      CALL i360_lil04()
      CALL cl_set_comp_entry("lil00,lil01",FALSE) 
   END IF
END FUNCTION
#FUN-B90121
#FUN-CA0081-----------add------str
FUNCTION i360_chk_lim03_lim04(startdate,enddate,p_lim02,p_cmd)
   DEFINE p_lim02          LIKE lim_file.lim02
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat
   
   LET g_errno = ''

   IF p_cmd= 'a' THEN
      SELECT COUNT(*) INTO l_n FROM lim_file
       WHERE lim01 = g_lil.lil01
         AND lim03 = startdate
         AND lim04 = enddate
         AND lim071 IS NULL
         AND lim072 IS NULL
   ELSE
      SELECT COUNT(*) INTO l_n FROM lim_file
       WHERE lim01 = g_lil.lil01
         AND lim02 <> p_lim02
         AND lim03 = startdate
         AND lim04 = enddate
         AND lim071 IS NULL
         AND lim072 IS NULL
   END IF

   IF l_n >0 THEN 
      LET g_errno ='alm1389'
      RETURN
   END IF
END FUNCTION
FUNCTION i360_chk_lim063(startdate,enddate,p_lim02,p_cmd)
   DEFINE p_lim02          LIKE lim_file.lim02
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat

   LET g_errno = ''

   IF p_cmd= 'a' THEN
      SELECT COUNT(*) INTO l_n FROM lim_file
       WHERE lim01 = g_lil.lil01
         AND lim03 = startdate
         AND lim04 = enddate
         AND lim071 IS NOT NULL
         AND lim072 IS NOT NULL
   ELSE
      SELECT COUNT(*) INTO l_n FROM lim_file
       WHERE lim01 = g_lil.lil01
         AND lim02 <> p_lim02
         AND lim03 = startdate
         AND lim04 = enddate
         AND lim071 IS NOT NULL
         AND lim072 IS NOT NULL
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm1389'
      RETURN
   END IF
END FUNCTION
#检查同一时间段内上下限不重复
FUNCTION i360_chk_lim071(startdate,enddate,p_lim02,p_lim063,p_lim064,p_cmd)
   DEFINE p_lim02          LIKE lim_file.lim02
   DEFINE p_lim063         LIKE lim_file.lim071
   DEFINE p_lim064         LIKE lim_file.lim072
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat

   LET g_errno = ''

   IF p_cmd= 'a' THEN
      SELECT COUNT(*) INTO l_n FROM lim_file
       WHERE lim01 = g_lil.lil01
         AND lim03 = startdate
         AND lim04 = enddate
         AND ((p_lim063 BETWEEN lim071 AND lim072
              OR p_lim064 BETWEEN lim071 AND lim072)
         OR  (lim071 BETWEEN p_lim063 AND p_lim064
               OR lim072 BETWEEN p_lim063 AND p_lim064 ))
   ELSE
      SELECT COUNT(*) INTO l_n FROM lim_file
       WHERE lim01 = g_lil.lil01
         AND lim02 <> p_lim02
         AND lim03 = startdate
         AND lim04 = enddate
         AND ((p_lim063 BETWEEN lim071 AND lim072
              OR p_lim064 BETWEEN lim071 AND lim072)
          OR  (lim071 BETWEEN p_lim063 AND p_lim064
               OR lim072 BETWEEN p_lim063 AND p_lim064 ))
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm-872'
      RETURN
   END IF
END FUNCTION
FUNCTION i360_set_required(startdate,enddate,p_lim02,p_lim071,p_lim072,p_cmd)
   DEFINE p_lim02          LIKE lim_file.lim02
   DEFINE p_lim071         LIKE lim_file.lim071
   DEFINE p_lim072         LIKE lim_file.lim072
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat

   IF NOT cl_null(startdate) AND NOT cl_null(enddate) THEN
      IF p_cmd= 'a' THEN
         SELECT COUNT(*) INTO l_n FROM lim_file
          WHERE lim01 = g_lil.lil01
            AND lim03 = startdate
            AND lim04 = enddate
            AND lim071 IS NOT NULL
            AND lim072 IS NOT NULL
      ELSE
         SELECT COUNT(*) INTO l_n FROM lim_file
          WHERE lim01 = g_lil.lil01
            AND lim02 <> p_lim02
            AND lim03 = startdate
            AND lim04 = enddate
            AND lim071 IS NOT NULL
            AND lim072 IS NOT NULL
      END IF
   END IF
   IF NOT cl_null(p_lim071) OR NOT cl_null(p_lim072) OR l_n >0 THEN
      CALL cl_set_comp_required("lim063",TRUE)
      CALL cl_set_comp_required("lim064",TRUE)
   ELSE
      CALL cl_set_comp_required("lim063",FALSE)
      CALL cl_set_comp_required("lim064",FALSE)
   END IF
END FUNCTION
#FUN-CA0081-----------add------end
