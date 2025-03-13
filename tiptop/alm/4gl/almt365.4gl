# Prog. Version..: '5.30.06-13.04.09(00004)'     #
#
# Pattern name...: almt365.4gl
# Descriptions...: 摊位个别费用标准变更作业 
# Date & Author..: NO.FUN-B90121 11/09/26 By nanbing
# Modify.........: No:TQC-C30239 12/03/20 By fanbj 確認后沒有帶出確認人名稱
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-CA0081 12/10/23 By xumm 比例单身增加 上限和下限栏位
# Modify.........: No.CHI-D20015 13/03/27 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE   g_lir     RECORD LIKE lir_file.*      
DEFINE   g_lir_t   RECORD LIKE lir_file.*   
DEFINE   g_lis1    DYNAMIC ARRAY OF RECORD
                   lis02      LIKE lis_file.lis02, 
                   lis03_1    LIKE lis_file.lis03,
                   lis04_1    LIKE lis_file.lis04,
                   lis05_1    LIKE lis_file.lis05,    
                   lis06_1    LIKE lis_file.lis06,    
                   lis07_1    LIKE lis_file.lis07,    
                   lis071_1   LIKE lis_file.lis071,    
                   lis10_1    LIKE lis_file.lis10,    
                   lis03      LIKE lis_file.lis03,    
                   lis04      LIKE lis_file.lis04,
                   lis05      LIKE lis_file.lis05,    
                   lis06      LIKE lis_file.lis06,    
                   lis07      LIKE lis_file.lis07,    
                   lis071     LIKE lis_file.lis071,    
                   lis10      LIKE lis_file.lis10    
                   END RECORD
DEFINE   g_lis1_t  RECORD
                   lis02      LIKE lis_file.lis02, 
                   lis03_1    LIKE lis_file.lis03,
                   lis04_1    LIKE lis_file.lis04,
                   lis05_1    LIKE lis_file.lis05,    
                   lis06_1    LIKE lis_file.lis06,    
                   lis07_1    LIKE lis_file.lis07,    
                   lis071_1   LIKE lis_file.lis071,    
                   lis10_1    LIKE lis_file.lis10,    
                   lis03      LIKE lis_file.lis03,    
                   lis04      LIKE lis_file.lis04,
                   lis05      LIKE lis_file.lis05,    
                   lis06      LIKE lis_file.lis06,    
                   lis07      LIKE lis_file.lis07,    
                   lis071     LIKE lis_file.lis071,    
                   lis10      LIKE lis_file.lis10    
                   END RECORD
DEFINE   g_lis2    DYNAMIC ARRAY OF RECORD
                   lis02      LIKE lis_file.lis02,
                   lis03_2    LIKE lis_file.lis03,    
                   lis04_2    LIKE lis_file.lis04,
                   lis05_2    LIKE lis_file.lis05,    
                   lis06_2    LIKE lis_file.lis06, 
                   lis08_2    LIKE lis_file.lis08,       
                   lis091_2   LIKE lis_file.lis091,    #FUN-CA0081 add
                   lis092_2   LIKE lis_file.lis092,    #FUN-CA0081 add
                   lis081_2   LIKE lis_file.lis081,    
                   lis082_2   LIKE lis_file.lis082,
                   lis083_2   LIKE lis_file.lis083,    
                   lis084_2   LIKE lis_file.lis084,
                   lis10_2    LIKE lis_file.lis10,          
                   lis03      LIKE lis_file.lis03,    
                   lis04      LIKE lis_file.lis04,
                   lis05      LIKE lis_file.lis05,    
                   lis06      LIKE lis_file.lis06, 
                   lis08      LIKE lis_file.lis08,       
                   lis091     LIKE lis_file.lis091,    #FUN-CA0081 add
                   lis092     LIKE lis_file.lis092,    #FUN-CA0081 add
                   lis081     LIKE lis_file.lis081,    
                   lis082     LIKE lis_file.lis082,
                   lis083     LIKE lis_file.lis083,    
                   lis084     LIKE lis_file.lis084,
                   lis10      LIKE lis_file.lis10     
                   END RECORD
DEFINE   g_lis2_t  RECORD
                   lis02      LIKE lis_file.lis02,
                   lis03_2    LIKE lis_file.lis03,    
                   lis04_2    LIKE lis_file.lis04,
                   lis05_2    LIKE lis_file.lis05,    
                   lis06_2    LIKE lis_file.lis06, 
                   lis08_2    LIKE lis_file.lis08,       
                   lis091_2   LIKE lis_file.lis091,    #FUN-CA0081 add
                   lis092_2   LIKE lis_file.lis092,    #FUN-CA0081 add
                   lis081_2   LIKE lis_file.lis081,    
                   lis082_2   LIKE lis_file.lis082,
                   lis083_2   LIKE lis_file.lis083,    
                   lis084_2   LIKE lis_file.lis084,
                   lis10_2    LIKE lis_file.lis10,                                  
                   lis03      LIKE lis_file.lis03,    
                   lis04      LIKE lis_file.lis04,
                   lis05      LIKE lis_file.lis05,    
                   lis06      LIKE lis_file.lis06, 
                   lis08      LIKE lis_file.lis08,       
                   lis091     LIKE lis_file.lis091,    #FUN-CA0081 add
                   lis092     LIKE lis_file.lis092,    #FUN-CA0081 add
                   lis081     LIKE lis_file.lis081,    
                   lis082     LIKE lis_file.lis082,
                   lis083     LIKE lis_file.lis083,    
                   lis084     LIKE lis_file.lis084,
                   lis10      LIKE lis_file.lis10     
                   END RECORD
DEFINE   g_lis3    DYNAMIC ARRAY OF RECORD
                   lis02      LIKE lis_file.lis02,
                   lis03_3    LIKE lis_file.lis03,    
                   lis04_3    LIKE lis_file.lis04,
                   lis05_3    LIKE lis_file.lis05,    
                   lis06_3    LIKE lis_file.lis06, 
                   lis09_3    LIKE lis_file.lis09,       
                   lis091_3   LIKE lis_file.lis091,    
                   lis092_3   LIKE lis_file.lis092,
                   lis093_3   LIKE lis_file.lis093,    
                   lis094_3   LIKE lis_file.lis094,
                   lis10_3    LIKE lis_file.lis10,              
                   lis03      LIKE lis_file.lis03,    
                   lis04      LIKE lis_file.lis04,
                   lis05      LIKE lis_file.lis05,    
                   lis06      LIKE lis_file.lis06, 
                   lis09      LIKE lis_file.lis09,       
                   lis091     LIKE lis_file.lis091,    
                   lis092     LIKE lis_file.lis092,
                   lis093     LIKE lis_file.lis093,    
                   lis094     LIKE lis_file.lis094,
                   lis10      LIKE lis_file.lis10            
                   END RECORD
DEFINE   g_lis3_t  RECORD
                   lis02      LIKE lis_file.lis02, 
                   lis03_3    LIKE lis_file.lis03,    
                   lis04_3    LIKE lis_file.lis04,
                   lis05_3    LIKE lis_file.lis05,    
                   lis06_3    LIKE lis_file.lis06, 
                   lis09_3    LIKE lis_file.lis09,       
                   lis091_3   LIKE lis_file.lis091,    
                   lis092_3   LIKE lis_file.lis092,
                   lis093_3   LIKE lis_file.lis093,    
                   lis094_3   LIKE lis_file.lis094,
                   lis10_3    LIKE lis_file.lis10,             
                   lis03      LIKE lis_file.lis03,    
                   lis04      LIKE lis_file.lis04,
                   lis05      LIKE lis_file.lis05,    
                   lis06      LIKE lis_file.lis06, 
                   lis09      LIKE lis_file.lis09,       
                   lis091     LIKE lis_file.lis091,    
                   lis092     LIKE lis_file.lis092,
                   lis093     LIKE lis_file.lis093,    
                   lis094     LIKE lis_file.lis094,
                   lis10      LIKE lis_file.lis10            
                   END RECORD

DEFINE   g_rec_b1  LIKE type_file.num5
DEFINE   g_rec_b2  LIKE type_file.num5
DEFINE   g_rec_b3  LIKE type_file.num5
DEFINE   g_wc,g_wc2,g_wc3,g_wc4     STRING
DEFINE   g_sql                STRING
DEFINE   g_forupd_sql        STRING
DEFINE   g_forupd_sql1        STRING
DEFINE   g_forupd_sql2        STRING
DEFINE   g_chr                LIKE type_file.chr1     
DEFINE   g_cnt                LIKE type_file.num10    
DEFINE   g_i                  LIKE type_file.num5     
DEFINE   g_msg                LIKE ze_file.ze03       
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_row_count          LIKE type_file.num10
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_jump               LIKE type_file.num10
DEFINE   g_no_ask             LIKE type_file.num5  
DEFINE   g_confirm            LIKE type_file.chr1
DEFINE   g_void               LIKE type_file.chr1    
DEFINE   g_t1                 LIKE oay_file.oayslip
DEFINE   li_result            LIKE type_file.num5
DEFINE   l_ac1                LIKE type_file.num5
DEFINE   l_ac2                LIKE type_file.num5 
DEFINE   l_ac3                LIKE type_file.num5
DEFINE   g_argv1              LIKE lir_file.lir06
DEFINE   g_lir01_t            LIKE lir_file.lir01
DEFINE   g_flag_b             LIKE type_file.chr1
DEFINE   g_desc               LIKE lis_file.lis10
DEFINE   cb                   ui.ComboBox 
DEFINE   g_lla04              LIKE lla_file.lla04
MAIN 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   LET g_argv1 = ARG_VAL(1) 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
   LET g_forupd_sql= " SELECT * FROM lir_file WHERE lir01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t365_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t365_w  WITH FORM "alm/42f/almt365"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   SELECT lla04 INTO g_lla04 FROM lla_file
    WHERE llastore = g_plant   
   IF NOT cl_null(g_argv1) THEN 
      LET cb = ui.ComboBox.forName("lir06")
      LET g_lir.lir06 = g_argv1
      DISPLAY BY NAME g_lir.lir06 
      CASE  g_lir.lir06 
         WHEN  "1" 
              CALL cb.removeItem('2')    
              CALL cb.removeItem('3')      
              CALL cl_set_comp_visible("page4,page5",FALSE)
         WHEN  "2" 
              CALL cb.removeItem('1')    
              CALL cb.removeItem('3')      
              CALL cl_set_comp_visible("page3,page5",FALSE)
         WHEN  "3" 
              CALL cb.removeItem('1')    
              CALL cb.removeItem('2')               
              CALL cl_set_comp_visible("page3,page4",FALSE)
      END CASE    
   END IF   
   CALL t365_menu()
 
   CLOSE WINDOW t365_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
FUNCTION t365_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   
   CLEAR FORM
   CALL g_lis1.clear()
   CALL g_lis2.clear()
   CALL g_lis3.clear()
   LET g_action_choice=" " 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lir.* TO NULL
      CONSTRUCT BY NAME g_wc ON
                lir01,lir02,lir03,lir04,lir05,lir06,lir07,lir071,lir08,lirplant,lirlegal,
                lir09,lir10,lir11,lir12,lir13,lir14,lir15,lir16,lir161,lir17,lir171,
                lir18,lir181,lirmksg,lir19,lirconf,lirconu,lircond,lir20,
                liruser,lirgrup,liroriu,lirmodu,lirdate,lirorig,liracti,lircrat     
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(lir01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir01"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir01
                  NEXT FIELD lir01
            
               WHEN INFIELD(lir03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir03"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir03
                  NEXT FIELD lir03
               WHEN INFIELD(lir04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir04"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir04
                  NEXT FIELD lir04
               WHEN INFIELD(lir07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir07"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir07
                  NEXT FIELD lir07 
               WHEN INFIELD(lir08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir08"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir08
                  NEXT FIELD lir08    
               WHEN INFIELD(lirplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lirplant"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lirplant
                  NEXT FIELD lirplant
               WHEN INFIELD(lirlegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lirlegal"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lirlegal
                  NEXT FIELD lirlegal
                
               WHEN INFIELD(lir09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir09"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir09
                  NEXT FIELD lir09
                    
               WHEN INFIELD(lir10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir10"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir10
                  NEXT FIELD lir10  
               WHEN INFIELD(lir11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir11"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir11
                  NEXT FIELD lir11  
               WHEN INFIELD(lir12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir12"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir12
                  NEXT FIELD lir12     
                   
               WHEN INFIELD(lir13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lir13"
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF                 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lir13
                  NEXT FIELD lir13  
               WHEN INFIELD(lirconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lirconu"  
                  IF NOT cl_null(g_argv1) THEN 
                     LET g_qryparam.where = " lir06 = '",g_argv1,"'"
                  END IF 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lirconu
                  NEXT FIELD lirconu   
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
     
         ON ACTION EXIT
            LET g_action_choice="exit"
            EXIT CONSTRUCT
     
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
   IF INT_FLAG OR g_action_choice = "exit" THEN
      RETURN
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('liruser', 'lirgrup')
      DIALOG ATTRIBUTES(UNBUFFERED) 
         CONSTRUCT g_wc2 ON b.lis02,b.lis03,b.lis04,b.lis05,b.lis06,b.lis07,b.lis071,b.lis10
              FROM s_lis1[1].lis02,s_lis1[1].lis03,s_lis1[1].lis04,
                   s_lis1[1].lis05,s_lis1[1].lis06,s_lis1[1].lis07,
                   s_lis1[1].lis071,s_lis1[1].lis10
                
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
      
            ON ACTION controlp
               CASE 
                  WHEN INFIELD(lis04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lis04"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lis04
                     NEXT FIELD lis04
                  OTHERWISE EXIT CASE
               END CASE
      
         END CONSTRUCT

         CONSTRUCT g_wc3 ON b.lis02,b.lis03,b.lis04,b.lis05,b.lis06,b.lis08,b.lis091,b.lis092,          #FUN-CA0081 add b.lis091,b.lis092
                            b.lis081,b.lis082,b.lis083,b.lis084,b.lis10
             FROM s_lis2[1].lis02,s_lis2[1].lis03,s_lis2[1].lis04,
                  s_lis2[1].lis05,s_lis2[1].lis06,s_lis2[1].lis08,
                  s_lis2[1].lis091_4,s_lis2[1].lis092_4,                         #FUN-CA0081 add
                  s_lis2[1].lis081,s_lis2[1].lis082,s_lis2[1].lis083,
                  s_lis2[1].lis084,s_lis2[1].lis10
                
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
      
            ON ACTION controlp
               CASE 
                  WHEN INFIELD(lis04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lis04"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lis04
                     NEXT FIELD lis04
                  OTHERWISE EXIT CASE
               END CASE
      
         END CONSTRUCT
         CONSTRUCT g_wc4 ON b.lis02,b.lis03,b.lis04,b.lis05,b.lis06,b.lis09,
                            b.lis091,b.lis092,b.lis093,b.lis094,b.lisacti
             FROM s_lis3[1].lis02,s_lis3[1].lis03,s_lis3[1].lis04,
                  s_lis3[1].lis05,s_lis3[1].lis06,s_lis3[1].lis09,
                  s_lis3[1].lis091,s_lis3[1].lis092,s_lis3[1].lis093,
                  s_lis3[1].lis094,s_lis3[1].lis10
                
                
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
      
            ON ACTION controlp
               CASE 
                  WHEN INFIELD(lis04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lis04"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lis04
                     NEXT FIELD lis04
                  OTHERWISE EXIT CASE
               END CASE
      
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

         ON ACTION CANCEL
            LET INT_FLAG = 1
            EXIT DIALOG
      END DIALOG
      IF INT_FLAG THEN
         RETURN
      END IF
      
      IF NOT cl_null(g_argv1) THEN 
         LET g_wc = g_wc CLIPPED," AND lir06= '",g_argv1,"'"
      END IF  
      LET g_wc = g_wc CLIPPED," AND lirplant IN ",g_auth 
      IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" AND g_wc4 = " 1=1" THEN
         LET g_sql = "SELECT lir01 FROM lir_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY lir01"
      ELSE
         IF g_wc2 <> " 1=1" THEN  
            LET g_sql = "SELECT UNIQUE lir01 ",
                        " FROM lir_file, lis_file b ",
                        " WHERE lir01 = b.lis01",
                        "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                        " ORDER BY lir01"
         END IF 
         IF g_wc3 <> " 1=1" THEN
            LET g_sql = "SELECT UNIQUE lir01 ",
                        " FROM lir_file, lis_file b",
                        " WHERE lir01 = b.lis01",
                        "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                        " ORDER BY lir01"       
         END IF 
         IF g_wc4 <> " 1=1" THEN 
            LET g_sql = "SELECT UNIQUE lir01 ",
                        " FROM lir_file, lis_file b",
                        " WHERE lir01 = b.lis01",
                        "   AND ", g_wc CLIPPED, " AND ",g_wc4 CLIPPED,
                        " ORDER BY lir01"        
         END IF 
      END IF

   PREPARE t365_prepare FROM g_sql
   DECLARE t365_cs
      SCROLL CURSOR WITH HOLD FOR t365_prepare
   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" AND g_wc4 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM lir_file WHERE ",g_wc CLIPPED
   ELSE
      IF g_wc2 <> " 1=1" THEN  
         LET g_sql="SELECT COUNT(DISTINCT lir01)",
                   " FROM lir_file,lis_file b WHERE ",
                   " b.lis01=lir01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
      IF g_wc3 <> " 1=1" THEN  
         LET g_sql="SELECT COUNT(DISTINCT lir01)",
                   " FROM lir_file,lis_file b WHERE ",
                   " b.lis01=lir01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
      END IF
      IF g_wc4 <> " 1=1" THEN  
         LET g_sql="SELECT COUNT(DISTINCT lir01)",
                   " FROM lir_file,lis_file b WHERE ",
                   " b.lis01=lir01 AND ",g_wc CLIPPED," AND ",g_wc4 CLIPPED
      END IF
   END IF
   PREPARE t365_precount FROM g_sql
   DECLARE t365_count CURSOR FOR t365_precount

END FUNCTION
 
FUNCTION t365_menu()

   WHILE TRUE
      CALL t365_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t365_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t365_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t365_r()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t365_x()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t365_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE g_flag_b
                  WHEN '1'  CALL t365_b1("a")
                  WHEN '2'  CALL t365_b2("a")
                  WHEN '3'  CALL t365_b3("a")
               END CASE
            ELSE
               #IF NOT cl_null(g_flag_b) THEN  
               #   CASE g_flag_b
               #      WHEN '1'  CALL t365_b1("a")
               #      WHEN '2'  CALL t365_b2("a")
               #      WHEN '3'  CALL t365_b3("a")
               #   END CASE
               #ELSE 
                  LET g_action_choice = NULL
              # END IF 
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t365_confirm()
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t365_undoconfirm()
            END IF
         WHEN "change_export"
            IF cl_chk_act_auth() THEN
               CALL t365_change_export()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lir.lir01 IS NOT NULL THEN
                 LET g_doc.column1 = "lir01"
                 LET g_doc.value1 = g_lir.lir01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION t365_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lis1 TO s_lis1.* ATTRIBUTE(COUNT=g_rec_b1)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac1 = ARR_CURR()
          CALL cl_show_fld_cont()
        ON ACTION detail
          LET g_action_choice="detail"
          LET g_flag_b = '1'
          LET l_ac1 = 1
          EXIT DIALOG 
        ON ACTION ACCEPT
          LET g_action_choice="detail"
          LET g_flag_b = '1'
          LET l_ac1 = ARR_CURR()
          EXIT DIALOG 
    
      END DISPLAY  

      DISPLAY ARRAY g_lis2 TO s_lis2.* ATTRIBUTE(COUNT=g_rec_b2)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac2 = ARR_CURR()
          CALL cl_show_fld_cont()
        ON ACTION detail
          LET g_action_choice="detail"
          LET g_flag_b = '2'
          LET l_ac2 = 1
          EXIT DIALOG 
        ON ACTION ACCEPT
          LET g_action_choice="detail"
          LET g_flag_b = '2'
          LET l_ac2 = ARR_CURR()
          EXIT DIALOG           
      END DISPLAY  

      DISPLAY ARRAY g_lis3 TO s_lis3.* ATTRIBUTE(COUNT=g_rec_b3)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac3 = ARR_CURR()
          CALL cl_show_fld_cont()
        ON ACTION detail
          LET g_action_choice="detail"
          LET g_flag_b = '3'
          LET l_ac3 = 1
          EXIT DIALOG 
        ON ACTION ACCEPT
          LET g_action_choice="detail"
          LET g_flag_b = '3'
          LET l_ac3 = ARR_CURR()
          EXIT DIALOG           
      END DISPLAY      

      ON ACTION INSERT
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 

      ON ACTION DELETE
         LET g_action_choice="delete"
         EXIT DIALOG 
         
      ON ACTION MODIFY
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION FIRST
         CALL t365_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION PREVIOUS
         CALL t365_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL t365_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION NEXT
         CALL t365_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION LAST
         CALL t365_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG 

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG 

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG 
      ON ACTION change_export
         LET g_action_choice="change_export"
         EXIT DIALOG 

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG 


      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()


      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t365_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_lis1.clear()
   CALL g_lis2.clear()
   CALL g_lis3.clear()
   INITIALIZE g_lir.* LIKE lir_file.*
   LET g_lir01_t = NULL
   LET g_lir_t.* = g_lir.*
   CALL cl_opmsg('a')
   WHILE TRUE
      IF cl_null(g_argv1) THEN
         CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
      ELSE
         LET g_lir.lir06 = g_argv1
         CASE g_lir.lir06
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
   
       LET g_lir.lir02 = g_today
       LET g_lir.lir03 = g_user
     #  LET g_lir.lirplant = g_plant
     #  LET g_lir.lirlegal = g_legal
       LET g_lir.lirconf = 'N'
       LET g_lir.lir05 = '0'
       LET g_lir.lir19 = '0'
       LET g_lir.liruser = g_user
       LET g_lir.liroriu = g_user 
       LET g_lir.lirorig = g_grup 
       LET g_lir.lirgrup = g_grup
       LET g_lir.lirmodu = ''
       LET g_lir.lirdate = ''
       LET g_lir.liracti = 'Y'
       LET g_lir.lircrat = g_today
       LET g_lir.lir181 = ' '
       CALL t365_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_lis1.clear()
           CALL g_lis2.clear()
           CALL g_lis3.clear()
           EXIT WHILE
       END IF
       IF g_lir.lir01 IS NULL OR g_lir.lirplant IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
       CALL s_auto_assign_no("alm",g_lir.lir01,g_today,"P3","lir_file","lir01","","","")
          RETURNING li_result,g_lir.lir01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_lir.lir01
       
       INSERT INTO lir_file VALUES(g_lir.*)     
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","lir_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
          ROLLBACK WORK
          CONTINUE WHILE
       ELSE
          ##插入lis表
          CALL t365_insert_lis()
          #
          COMMIT WORK
       END IF
       LET g_rec_b1=0
       LET g_rec_b2=0
       LET g_rec_b3=0
       IF g_lir.lir06 = '1' THEN 
          CALL t365_b1_fill(" 1=1 ")
          #CALL t365_1_fill()
          CALL t365_b1("a")
       END IF    
       IF g_lir.lir06 = '2' THEN 
          CALL t365_b2_fill(" 1=1 ")
          CALL t365_b2("a")
       END IF    
       IF g_lir.lir06 = '3' THEN     
          CALL t365_b3_fill(" 1=1 ")                                                                                                        
          CALL t365_b3("a")
       END IF
       EXIT WHILE
   END WHILE
END FUNCTION
FUNCTION t365_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_lir.lir01 IS NULL OR g_lir.lirplant IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_lir.* FROM lir_file WHERE lir01 = g_lir.lir01
 
   IF g_lir.lirconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF   
   IF g_lir.liracti = 'N' THEN                                                                                                      
      CALL cl_err('','mfg1000',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
   IF g_lir.lirplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF  
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lir01_t = g_lir.lir01
   LET g_lir_t.* = g_lir.*
   BEGIN WORK
   OPEN t365_cl USING g_lir.lir01
   FETCH t365_cl INTO g_lir.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lir.lir01,SQLCA.SQLCODE,0)
      CLOSE t365_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t365_show()
   WHILE TRUE
      LET g_lir01_t = g_lir.lir01
      LET g_lir.lirmodu=g_user
      LET g_lir.lirdate=g_today
      CALL t365_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lir.*=g_lir_t.*
          CALL t365_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE lir_file SET lir_file.* = g_lir.* WHERE lir01 = g_lir.lir01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","lir_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t365_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t365_i(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,
       l_n          LIKE type_file.num5,
       li_result    LIKE type_file.num5
          
   DISPLAY BY NAME
      g_lir.lir01,g_lir.lir02, g_lir.lir03,g_lir.lir04,g_lir.lir05,g_lir.lir06,
      g_lir.lir07,g_lir.lir071,g_lir.lir08,g_lir.lirplant,g_lir.lirlegal,g_lir.lir09,
      g_lir.lir10,g_lir.lir11,g_lir.lir12,g_lir.lir13,g_lir.lir14,g_lir.lir15,
      g_lir.lir16,g_lir.lir17,g_lir.lir18,g_lir.lirmksg,g_lir.lir19,   
      g_lir.lirconf,g_lir.lirconu,g_lir.lircond,g_lir.lir20,
      g_lir.liruser,g_lir.lirmodu,g_lir.liracti,g_lir.lirgrup,
      g_lir.lirdate,g_lir.lircrat,g_lir.liroriu,g_lir.lirorig       
      
   
   CALL t365_desc()
   INPUT BY NAME g_lir.lir01,g_lir.lir02,g_lir.lir03,g_lir.lir04,
                 g_lir.lir161,g_lir.lir171,g_lir.lir181  WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t365_set_entry(p_cmd)
           CALL t365_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("lir01")
           IF g_lir.lir161 > g_today THEN 
              CALL cl_set_comp_entry("lir161",TRUE)
           ELSE 
              CALL cl_set_comp_entry("lir161",FALSE)
           END IF 
       AFTER FIELD lir01
           IF NOT cl_null(g_lir.lir01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_lir.lir01!=g_lir_t.lir01) THEN
                 CALL s_check_no("alm",g_lir.lir01,g_lir01_t,"P3","lir_file","lir01","")  
                    RETURNING li_result,g_lir.lir01
                 IF (NOT li_result) THEN                                                            
                    LET g_lir.lir01=g_lir_t.lir01                                                                 
                    NEXT FIELD lir01                                                                                      
                 END IF
                 LET g_t1=s_get_doc_no(g_lir.lir01)
                 SELECT oayapr INTO g_lir.lirmksg FROM oay_file WHERE oayslip = g_t1 
                 DISPLAY BY NAME g_lir.lirmksg
              END IF
           END IF
 
       AFTER FIELD lir03
          IF NOT cl_null(g_lir.lir03) THEN
             CALL t365_lir03(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lir.lir03 = g_lir_t.lir03
                DISPLAY BY NAME g_lir.lir03
                NEXT FIELD lir03
             END IF
          END IF   
       AFTER FIELD lir04 
          IF NOT cl_null(g_lir.lir04) THEN
             CALL t365_lir04(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lir.lir04 = g_lir_t.lir04
                DISPLAY BY NAME g_lir.lir04
                NEXT FIELD lir04
             END IF
          END IF
       AFTER FIELD lir161
          IF NOT cl_null(g_lir.lir161) THEN
             IF g_lir.lir161 < g_lir.lir16 THEN 
                CALL cl_err('','alm1101',0)
                NEXT FIELD lir161
             END IF 
             CALL t365_lir16() RETURNING l_n
             IF l_n = 0 THEN 
                IF NOT cl_null(g_lir.lir171) THEN
                   IF g_lir.lir161 < g_lir.lir171 THEN 
                      CALL t365_lir161(g_lir.lir161,g_lir.lir171)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,0)
                         LET g_lir.lir161 = g_lir_t.lir161
                         DISPLAY BY NAME g_lir.lir161
                         NEXT FIELD lir161
                      END IF                    
                   ELSE
                      CALL cl_err('','art-207',0)
                      LET g_lir.lir161 = g_lir_t.lir161
                      DISPLAY BY NAME g_lir.lir161
                      NEXT FIELD lir161 
                   END IF 
                ELSE
                   CALL t365_lir161(g_lir.lir161,g_lir.lir17)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_lir.lir161 = g_lir_t.lir161
                      DISPLAY BY NAME g_lir.lir161
                      NEXT FIELD lir161
                   END IF    
                END IF
             ELSE 
                CALL cl_err('','alm1100',0)
                LET g_lir.lir161 = g_lir_t.lir161
                DISPLAY BY NAME g_lir.lir161
                NEXT FIELD lir161     
             END IF
          END IF
       AFTER FIELD lir171
          IF NOT cl_null(g_lir.lir171) THEN 
             IF g_lir.lir171 <= g_today THEN 
                CALL cl_err('','alm1097',0)
                LET g_lir.lir171 = g_lir_t.lir171
                DISPLAY BY NAME g_lir.lir171
                NEXT FIELD lir171 
             END IF
             CALL t365_lir17() RETURNING l_n
             IF l_n = 0 THEN 
                IF NOT cl_null(g_lir.lir161) THEN 
                   IF g_lir.lir161 < g_lir.lir171 THEN 
                      CALL t365_lir161(g_lir.lir161,g_lir.lir171)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,0)
                         LET g_lir.lir171 = g_lir_t.lir171
                         DISPLAY  BY NAME g_lir.lir171
                         NEXT FIELD lir171
                      END IF
                   ELSE
                      CALL cl_err('','art-207',0)
                      LET g_lir.lir171 = g_lir_t.lir171
                      DISPLAY BY NAME g_lir.lir171
                      NEXT FIELD lir171  
                   END IF
                ELSE
                   CALL t365_lir161(g_lir.lir16,g_lir.lir171)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_lir.lir171 = g_lir_t.lir171
                      DISPLAY BY NAME g_lir.lir171
                      NEXT FIELD lir171
                   END IF
                END IF    
             ELSE
                CALL cl_err('','alm1100',0)
                LET g_lir.lir171 = g_lir_t.lir171
                DISPLAY BY NAME g_lir.lir171
                NEXT FIELD lir171  
             END IF
          END IF          
       ON ACTION controlp
          CASE 
             WHEN INFIELD(lir01)
                LET g_t1=s_get_doc_no(g_lir.lir01)
                CALL q_oay(FALSE,FALSE,g_t1,'P3','ALM') RETURNING g_t1  
                LET g_lir.lir01=g_t1               
                DISPLAY BY NAME g_lir.lir01       
                NEXT FIELD lir01
             WHEN INFIELD(lir03) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_lir.lir03
                CALL cl_create_qry() RETURNING g_lir.lir03
                DISPLAY BY NAME g_lir.lir03
                CALL t365_lir03(p_cmd)
                NEXT FIELD lir03 
             WHEN INFIELD(lir04) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lip01"
                LET g_qryparam.default1 = g_lir.lir04
                IF NOT cl_null(g_argv1) THEN
                   LET g_qryparam.where = " lip04 = '",g_argv1 ,"'"    
                END IF
                CALL cl_create_qry() RETURNING g_lir.lir04
                DISPLAY BY NAME g_lir.lir04
                CALL t365_lir04(p_cmd)
                NEXT FIELD lir04

            
                
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
FUNCTION t365_b1(p_cmd)
DEFINE
   l_ac1_t         LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5,
   l_where         STRING,
   l_sql           STRING,
   l_date          LIKE lir_file.lir16

   #LET g_b_flag1 = '1'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_lir.lir01 IS NULL OR g_lir.lirplant IS NULL THEN RETURN END IF
      
   SELECT * INTO g_lir.* FROM lir_file
      WHERE lir01=g_lir.lir01 
   IF g_lir.liracti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_lir.lirconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
   IF g_lir.lirplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 
   
   CALL cl_opmsg('b')
 
   LET g_forupd_sql1 =
       " SELECT lis02,lis03,lis04,lis05,lis06,lis07,lis071,lis10",
       "  FROM lis_file ",
       " WHERE lis02=?  AND lis01='",g_lir.lir01,"'",
       "   AND lis03 = ?",
       " FOR UPDATE  "
   LET g_forupd_sql1 = cl_forupd_sql(g_forupd_sql1)
   DECLARE t365_bc11 CURSOR FROM g_forupd_sql1
   LET g_forupd_sql2 =
       " SELECT lis02,lis03,lis04,lis05,lis06,lis07,lis071,lis10",
       "  FROM lis_file ",
       " WHERE lis02=?  AND lis01='",g_lir.lir01,"'",
       "   AND lis03 = ?",
       " FOR UPDATE  "
   LET g_forupd_sql2 = cl_forupd_sql(g_forupd_sql2)
   DECLARE t365_bc12 CURSOR FROM g_forupd_sql2

   LET l_ac1_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lis1 WITHOUT DEFAULTS FROM s_lis1.*
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
 
         OPEN t365_cl USING g_lir.lir01
         IF STATUS THEN
            CALL cl_err("OPEN t365_cl:", STATUS, 1)
            CLOSE t365_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t365_cl INTO g_lir.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_lir.lir01,SQLCA.SQLCODE,0)
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b1>=l_ac1 THEN
            LET g_lis1_t.* = g_lis1[l_ac1].*  #BACKUP
            LET p_cmd='u'
             SELECT count(*) INTO l_n FROM lis_file
             WHERE lis01 = g_lir.lir01
               AND lis02 = g_lis1[l_ac1].lis02
               AND lis03 = '0'
            IF l_n > 0 THEN
               OPEN t365_bc11 USING g_lis1_t.lis02,'0'
               IF STATUS THEN
                  CALL cl_err("OPEN t365_bc11:", STATUS, 1)
                  CLOSE t365_bc11
                  ROLLBACK WORK
                  RETURN
               END IF

               FETCH t365_bc11 INTO g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis03_1,g_lis1[l_ac1].lis04_1,
                                    g_lis1[l_ac1].lis05_1,g_lis1[l_ac1].lis06_1,g_lis1[l_ac1].lis07_1,
                                    g_lis1[l_ac1].lis071_1,g_lis1[l_ac1].lis10_1
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lis1_t.lis02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_lis1[l_ac1].lis03 = ''
            SELECT lis03 INTO g_lis1[l_ac1].lis03 FROM lis_file
             WHERE lis01 = g_lir.lir01
               AND lis02 = g_lis1[l_ac1].lis02
               AND (lis03 = '1' OR lis03='2')
            IF NOT cl_null(g_lis1[l_ac1].lis03) THEN
               OPEN t365_bc12 USING g_lis1_t.lis02,g_lis1[l_ac1].lis03
               IF STATUS THEN
                  CALL cl_err("OPEN t365_bc12:", STATUS, 1)
                  CLOSE t365_bc12
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t365_bc12 INTO g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis03,g_lis1[l_ac1].lis04,
                                    g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06,g_lis1[l_ac1].lis07,
                                    g_lis1[l_ac1].lis071,g_lis1[l_ac1].lis10
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lis1_t.lis02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            NEXT FIELD lis02
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         #LET g
         INITIALIZE g_lis1[l_ac1].* TO NULL
         #LET g_lis1[l_ac1].lis03_1 = '0'
         LET g_lis1[l_ac1].lis03 = '2'
         LET g_lis1_t.* = g_lis1[l_ac1].*
         
         CALL cl_show_fld_cont()
         NEXT FIELD lis02  
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lis_file(lis01,lis02,lis03,lis04,lis05,lis06,lis07,lis071,lisplant,lislegal)
            VALUES(g_lir.lir01,g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis03,g_lis1[l_ac1].lis04,
                   g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06, g_lis1[l_ac1].lis07,
                   g_lis1[l_ac1].lis071,g_lir.lirplant,g_lir.lirlegal)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b1=g_rec_b1+1  
            CALL t365_lis10() 
         END IF

      BEFORE DELETE
 
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM lis_file
          WHERE lis01 = g_lir.lir01 
            AND lis02 = g_lis1[l_ac1].lis02
         IF (l_n = 1 AND g_lis1[l_ac1].lis03_1 = '0') THEN 
            LET g_lis1[l_ac1].lis04 = ''   
            LET g_lis1[l_ac1].lis05 = ''
            LET g_lis1[l_ac1].lis06 = ''
            LET g_lis1[l_ac1].lis07 = ''
            LET g_lis1[l_ac1].lis071 = ''
            LET g_lis1[l_ac1].lis10 = ''  
            CANCEL DELETE 
         END IF          
         IF NOT cl_null(g_lis1[l_ac1].lis04_1) THEN 
            
            CALL t365_lis05('r',g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis04_1,
                        g_lis1[l_ac1].lis05_1,g_lis1[l_ac1].lis06_1)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               CANCEL DELETE
            END IF    
         END IF         
         DELETE FROM lis_file
          WHERE lis01 = g_lir.lir01
            AND lis02 = g_lis1_t.lis02
            AND lis03 = g_lis1_t.lis03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lis_file",g_lir.lir01,g_lis1_t.lis02,SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE
         ELSE
            IF g_lis1[l_ac1].lis03 = '1' THEN 
               LET g_lis1[l_ac1].lis04 = ''   
               LET g_lis1[l_ac1].lis05 = ''
               LET g_lis1[l_ac1].lis06 = ''
               LET g_lis1[l_ac1].lis07 = ''
               LET g_lis1[l_ac1].lis071 = ''
               LET g_lis1[l_ac1].lis10 = ''
               COMMIT WORK 
               CALL t365_lis10()
               CANCEL DELETE 
            END IF    
         END IF
         IF g_lis1_t.lis03 = '2' THEN 
            LET g_rec_b1=g_rec_b1-1           
         END IF
         DISPLAY g_rec_b1 TO FORMONLY.cnt1 
         COMMIT WORK
         CALL t365_lis10()
      BEFORE FIELD lis02
         IF g_lis1[l_ac1].lis02 IS NULL OR g_lis1[l_ac1].lis02 = 0 THEN
            SELECT max(lis02)+1
              INTO g_lis1[l_ac1].lis02
              FROM lis_file
             WHERE lis01 = g_lir.lir01
            IF g_lis1[l_ac1].lis02 IS NULL THEN
               LET g_lis1[l_ac1].lis02 = 1
            END IF
         END IF
      AFTER FIELD lis02
         IF NOT cl_null(g_lis1[l_ac1].lis02) THEN
            IF (g_lis1[l_ac1].lis02 != g_lis1_t.lis02
                AND NOT cl_null(g_lis1_t.lis02))
               OR g_lis1_t.lis02 IS NULL THEN
               SELECT count(*)
                 INTO l_n
                 FROM lis_file
                WHERE lis01 = g_lir.lir01
                  AND lis02 = g_lis1[l_ac1].lis02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lis1[l_ac1].lis02 = g_lis1_t.lis02
                  NEXT FIELD lis02
               END IF
            END IF
            IF g_lis1[l_ac1].lis03_1 = '0' THEN 
               LET g_lis1[l_ac1].lis03 = '1'
            ELSE 
               LET g_lis1[l_ac1].lis03 = '2'   
            END IF
            IF g_lis1[l_ac1].lis05_1 < g_today THEN 
               LET g_lis1[l_ac1].lis04 = g_lis1[l_ac1].lis04_1
               LET g_lis1[l_ac1].lis05 = g_lis1[l_ac1].lis05_1
               LET g_lis1[l_ac1].lis07 = g_lis1[l_ac1].lis07_1
               LET g_lis1[l_ac1].lis071 = g_lis1[l_ac1].lis071_1
               LET g_lis1[l_ac1].lis10 = g_lis1[l_ac1].lis10_1
               IF g_lis1[l_ac1].lis06_1 < g_today THEN
                  LET g_lis1[l_ac1].lis06 = g_lis1[l_ac1].lis06_1
               ELSE    
                  NEXT FIELD lis06
               END IF    
            END IF                         
         END IF   
      AFTER FIELD lis04    
         IF NOT cl_null(g_lis1[l_ac1].lis04) AND g_lis1[l_ac1].lis03 <> '0' THEN
         #   IF (p_cmd='a') OR (p_cmd='u' AND g_lis1[l_ac1].lis04!=g_lis1_t.lis04) THEN
               IF NOT cl_null(g_lis1[l_ac1].lis05_1) THEN 
                  IF g_lis1[l_ac1].lis05_1 < g_today THEN 
                     LET g_lis1[l_ac1].lis04 = g_lis1[l_ac1].lis04_1
                  END IF
               END IF     
               CALL t365_lis04(g_lis1[l_ac1].lis04) 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lis1[l_ac1].lis04 = g_lis1_t.lis04
                  NEXT FIELD lis04
               END IF 
         #   END IF
            IF NOT cl_null(g_lis1[l_ac1].lis05) AND NOT cl_null(g_lis1[l_ac1].lis06) THEN 
               CALL t365_lis05('u',g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis04,
                        g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lis1[l_ac1].lis04 = g_lis1_t.lis04
                  NEXT FIELD lis04
               END IF 
            END IF                
         END IF

      AFTER FIELD lis05   
         IF NOT cl_null(g_lis1[l_ac1].lis05) AND g_lis1[l_ac1].lis03 <> '0' THEN
            IF NOT cl_null(g_lis1[l_ac1].lis05_1) THEN 
               IF g_lis1[l_ac1].lis05_1 < g_today THEN 
                  LET g_lis1[l_ac1].lis05 = g_lis1[l_ac1].lis05_1
               END IF
            END IF 
            IF NOT cl_null(g_lir.lir161) THEN 
               LET l_date = g_lir.lir161
            ELSE 
               LET l_date = g_lir.lir16  
            END IF    
            IF g_lis1[l_ac1].lis05 < l_date THEN 
               CALL cl_err('','alm1085',0)
               LET g_lis1[l_ac1].lis05 = g_lis1_t.lis05
               NEXT FIELD lis05
            ELSE 
               IF NOT cl_null(g_lis1[l_ac1].lis06) THEN
                  IF g_lis1[l_ac1].lis05 > g_lis1[l_ac1].lis06 THEN 
                     CALL cl_err('','art-207',0)
                     LET g_lis1[l_ac1].lis05 = g_lis1_t.lis05
                     NEXT FIELD lis05 
                  END IF
                  IF  NOT cl_null(g_lis1[l_ac1].lis04) THEN    
                     CALL t365_lis05('u',g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis04,g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_lis1[l_ac1].lis05 = g_lis1_t.lis05
                        NEXT FIELD lis05
                     ELSE
                        IF cl_null(g_lis1[l_ac1].lis07) THEN  
                           CALL t365_lis07(g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06)
                                RETURNING g_lis1[l_ac1].lis07 
                        END IF         
                     END IF    
                  END IF    
               END IF
            END IF
         END IF
      AFTER FIELD lis06
         IF NOT cl_null(g_lis1[l_ac1].lis06) AND g_lis1[l_ac1].lis03 <> '0' THEN
            IF (NOT cl_null(g_lis1[l_ac1].lis05_1) AND g_lis1[l_ac1].lis05_1 < g_today)
               AND NOT cl_null(g_lis1[l_ac1].lis06_1) THEN 
               IF g_lis1[l_ac1].lis06_1 < g_today THEN
                  LET g_lis1[l_ac1].lis06 = g_lis1[l_ac1].lis06_1
               ELSE  
                  IF g_lis1[l_ac1].lis06 < g_today THEN 
                     LET g_lis1[l_ac1].lis06 = g_today 
                  END IF  
               END IF    
            END IF 
            IF NOT cl_null(g_lir.lir171) THEN 
               LET l_date = g_lir.lir171
            ELSE 
               LET l_date = g_lir.lir17 
            END IF             
            IF g_lis1[l_ac1].lis06 > l_date THEN 
               CALL cl_err('','alm1085',0)
               LET g_lis1[l_ac1].lis06 = g_lis1_t.lis06
               NEXT FIELD lis06
            ELSE 
               IF NOT cl_null(g_lis1[l_ac1].lis05) THEN
                  IF g_lis1[l_ac1].lis05 > g_lis1[l_ac1].lis06 THEN 
                     CALL cl_err('','art-207',0)
                     LET g_lis1[l_ac1].lis06 = g_lis1_t.lis06
                     NEXT FIELD lis06 
                  END IF 
                  IF NOT cl_null(g_lis1[l_ac1].lis04) THEN    
                     CALL t365_lis05('u',g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis04,g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_lis1[l_ac1].lis06 = g_lis1_t.lis06
                        NEXT FIELD lis06
                     ELSE
                        IF cl_null(g_lis1[l_ac1].lis07) THEN  
                           CALL t365_lis07(g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06)
                                RETURNING g_lis1[l_ac1].lis07
                        END IF  
                     END IF    
                  END IF    
               END IF 
            END IF
         END IF 
         
      AFTER FIELD lis071
         IF NOT cl_null(g_lis1[l_ac1].lis071) THEN 
            IF g_lis1[l_ac1].lis05_1 < g_today THEN 
               LET g_lis1[l_ac1].lis071 = g_lis1[l_ac1].lis071_1
            END IF         
            IF g_lis1[l_ac1].lis071 < 0 THEN 
               CALL cl_err('','alm1080',0)
               NEXT FIELD lis071
            END IF
            CALL cl_digcut(g_lis1[l_ac1].lis071,g_lla04) RETURNING g_lis1[l_ac1].lis071
            IF NOT cl_null(g_lis1[l_ac1].lis07) THEN 
               LET g_lis1[l_ac1].lis10 = (g_lis1[l_ac1].lis071-g_lis1[l_ac1].lis07)/g_lis1[l_ac1].lis07
            END IF
         END IF
      #AFTER FIELD lis10
      #   CALL t365_lis10()
      ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lis1[l_ac1].* = g_lis1_t.*
              CLOSE t365_bc11
              CLOSE t365_bc12
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lis1[l_ac1].lis03,-263,1) 
              LET g_lis1[l_ac1].* = g_lis1_t.*
           ELSE
              SELECT COUNT(*) INTO l_n FROM lis_file
              WHERE lis01 = g_lir.lir01
                AND lis02 = g_lis1_t.lis02
              IF l_n = 2 THEN   
                 UPDATE lis_file SET lis02 = g_lis1[l_ac1].lis02,
                                     lis03 = g_lis1[l_ac1].lis03,
                                     lis04 = g_lis1[l_ac1].lis04,
                                     lis05 = g_lis1[l_ac1].lis05,
                                     lis06 = g_lis1[l_ac1].lis06,
                                     lis07 = g_lis1[l_ac1].lis07,
                                     lis071 = g_lis1[l_ac1].lis071,
                                     lis10 = g_lis1[l_ac1].lis10
                    WHERE lis01=g_lir.lir01 
                      AND lis02=g_lis1_t.lis02
                      AND lis03= g_lis1_t.lis03
                 IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                    CALL cl_err3("upd","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
                    LET g_lis1[l_ac1].* = g_lis1_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    CALL t365_lis10()
                 END IF
              ELSE
                 INSERT INTO lis_file(lis01,lis02,lis03,lis04,lis05,lis06,lis07,lis071,lisplant,lislegal)
                   VALUES(g_lir.lir01,g_lis1[l_ac1].lis02,g_lis1[l_ac1].lis03,g_lis1[l_ac1].lis04,
                        g_lis1[l_ac1].lis05,g_lis1[l_ac1].lis06, g_lis1[l_ac1].lis07,
                        g_lis1[l_ac1].lis071,g_lir.lirplant,g_lir.lirlegal)
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err3("ins","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
                    LET g_lis1[l_ac1].* = g_lis1_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    CALL t365_lis10()
                 END IF
              END IF   
           END IF
 
       AFTER ROW
           LET l_ac1= ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lis1[l_ac1].* = g_lis1_t.*
              END IF
              CLOSE t365_bc11
              CLOSE t365_bc12
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t365_bc11
           CLOSE t365_bc12
           COMMIT WORK
           CALL t365_lis10()
       ON ACTION controlp
           CASE WHEN INFIELD(lis04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lih07"
                LET l_where = " lmfstore = '",g_lir.lirplant,"'"
                IF NOT cl_null(g_lir.lir09) THEN 
                   LET l_where = l_where," AND lmf03 = '",g_lir.lir09,"'"
                END IF 
                IF NOT cl_null(g_lir.lir10) THEN 
                   LET l_where = l_where," AND lmf04 = '",g_lir.lir10,"'"
                END IF    
                LET g_qryparam.where = l_where
                LET g_qryparam.default1 = g_lis1[l_ac1].lis04
                CALL cl_create_qry() RETURNING g_lis1[l_ac1].lis04
                DISPLAY g_lis1[l_ac1].lis04 TO lis04
                CALL t365_lis04(g_lis1[l_ac1].lis04) 
                NEXT FIELD lis04
           OTHERWISE EXIT CASE
           END CASE
            
       ON ACTION CONTROLO
          IF INFIELD(lis02) AND l_ac1 > 1 THEN
             LET g_lis1[l_ac1].* = g_lis1[l_ac1-1].*
             NEXT FIELD lis02
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
                                                                                                             
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END INPUT
   IF p_cmd = 'u' THEN
      LET g_lir.lirmodu = g_user
      LET g_lir.lirdate = g_today
      UPDATE lir_file
         SET lirmodu = g_lip.lirmodu,
             lirdate = g_lip.lirdate
       WHERE lir01 = g_lir.lir01
      DISPLAY BY NAME g_lir.lirmodu,g_lir.lirdate
   END IF
   CLOSE t365_bc11
   CLOSE t365_bc12 
   COMMIT WORK
   
END FUNCTION
FUNCTION t365_b2(p_cmd)
DEFINE
   l_ac2_t         LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5,
   l_where         STRING,
   l_date          LIKE lir_file.lir16
   #LET g_b_flag1 = '1'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_lir.lir01 IS NULL OR g_lir.lirplant IS NULL THEN RETURN END IF
      
   SELECT * INTO g_lir.* FROM lir_file
      WHERE lir01=g_lir.lir01 
   IF g_lir.liracti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_lir.lirconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
   IF g_lir.lirplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 
   
   CALL cl_opmsg('b')
 
   LET g_forupd_sql1 =
       " SELECT lis02,lis03,lis04,lis05,lis06,lis08,lis091,lis092,lis081,lis082,lis083,lis084,lis10",   #FUN-CA0081 add lis091,lis092
       "  FROM lis_file ",
       " WHERE lis02=?  AND lis01='",g_lir.lir01,"'",
       "   AND lis03 = ?",
       " FOR UPDATE  "
   LET g_forupd_sql1 = cl_forupd_sql(g_forupd_sql1)
   DECLARE t365_bc21 CURSOR FROM g_forupd_sql1
   LET g_forupd_sql2 =
       " SELECT lis02,lis03,lis04,lis05,lis06,lis08,lis091,lis092,lis081,lis082,lis083,lis084,lis10",   #FUN-CA0081 add lis091,lis092
       "  FROM lis_file ",
       " WHERE lis02=?  AND lis01='",g_lir.lir01,"'",
       "   AND lis03 = ?",
       " FOR UPDATE  "
   LET g_forupd_sql2 = cl_forupd_sql(g_forupd_sql2)
   DECLARE t365_bc22 CURSOR FROM g_forupd_sql2

   LET l_ac2_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lis2 WITHOUT DEFAULTS FROM s_lis2.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
            LET l_ac2 = 1
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
 
         OPEN t365_cl USING g_lir.lir01
         IF STATUS THEN
            CALL cl_err("OPEN t365_cl:", STATUS, 1)
            CLOSE t365_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t365_cl INTO g_lir.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_lir.lir01,SQLCA.SQLCODE,0)
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b2>=l_ac2 THEN
            LET g_lis2_t.* = g_lis2[l_ac2].*  #BACKUP
            LET p_cmd='u'
            SELECT count(*) INTO l_n FROM lis_file
             WHERE lis01 = g_lir.lir01
               AND lis02 = g_lis2[l_ac2].lis02
               AND lis03 = '0'
            IF l_n > 0 THEN
               OPEN t365_bc21 USING g_lis2_t.lis02,'0'
               IF STATUS THEN
                  CALL cl_err("OPEN t365_bc21:", STATUS, 1)
                  CLOSE t365_bc21
                  ROLLBACK WORK
                  RETURN
               END IF

               FETCH t365_bc21 INTO g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis03_2,g_lis2[l_ac2].lis04_2,
                                    g_lis2[l_ac2].lis05_2,g_lis2[l_ac2].lis06_2,g_lis2[l_ac2].lis08_2,
                                    g_lis2[l_ac2].lis091_2,g_lis2[l_ac2].lis092_2,                           #FUN-CA0081 add
                                    g_lis2[l_ac2].lis081_2,g_lis2[l_ac2].lis082_2,g_lis2[l_ac2].lis083_2,
                                    g_lis2[l_ac2].lis084_2,g_lis2[l_ac2].lis10_2
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lis2_t.lis02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_lis2[l_ac2].lis03 = ''
            SELECT lis03 INTO g_lis2[l_ac2].lis03 FROM lis_file
             WHERE lis01 = g_lir.lir01
               AND lis02 = g_lis2[l_ac2].lis02
               AND (lis03 = '1' OR lis03='2')
            IF NOT cl_null(g_lis2[l_ac2].lis03) THEN
               OPEN t365_bc22 USING g_lis2_t.lis02,g_lis2[l_ac2].lis03
               IF STATUS THEN
                  CALL cl_err("OPEN t365_bc22:", STATUS, 1)
                  CLOSE t365_bc22
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t365_bc22 INTO g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis03,g_lis2[l_ac2].lis04,
                                    g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis08,
                                    g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,                             #FUN-CA0081 add
                                    g_lis2[l_ac2].lis081,g_lis2[l_ac2].lis082,g_lis2[l_ac2].lis083,
                                    g_lis2[l_ac2].lis084,g_lis2[l_ac2].lis10
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lis2_t.lis02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            NEXT FIELD lis02
            CALL t365_set_required(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2_t.lis02,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,p_cmd)  #FUN-CA0081 add
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         #LET g
         INITIALIZE g_lis2[l_ac2].* TO NULL
         #LET g_lis2[l_ac2].lis03_2 = '0'
         LET g_lis2[l_ac2].lis03 = '2'
         LET g_lis2_t.* = g_lis2[l_ac2].*
         CALL t365_set_required(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2_t.lis02,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,p_cmd)  #FUN-CA0081 add 
         CALL cl_show_fld_cont()
         NEXT FIELD lis02    
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lis_file(lis01,lis02,lis03,lis04,lis05,lis06,lis08,lis091,lis092,lis081,lis082,lis083,lis084,lisplant,lislegal)  #FUN-CA0081 add lis091,lis092
            VALUES(g_lir.lir01,g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis03,g_lis2[l_ac2].lis04,
                   g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06, g_lis2[l_ac2].lis08,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,g_lis2[l_ac2].lis081,   #FUN-CA0081 add lis091,lis092
                   g_lis2[l_ac2].lis082,g_lis2[l_ac2].lis083,g_lis2[l_ac2].lis084,g_lir.lirplant,g_lir.lirlegal)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            CALL t365_lis10() 
            LET g_rec_b2=g_rec_b2+1   
         END IF



      BEFORE DELETE 
    
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM lis_file
          WHERE lis01 = g_lir.lir01 
            AND lis02 = g_lis2[l_ac2].lis02
         IF (l_n = 1 AND g_lis2[l_ac2].lis03_2 = '0') THEN  
            LET g_lis2[l_ac2].lis04 = '' 
            LET g_lis2[l_ac2].lis05 = '' 
            LET g_lis2[l_ac2].lis06 = '' 
            LET g_lis2[l_ac2].lis08 = ''
            LET g_lis2[l_ac2].lis091 = ''  #FUN-CA0081 add
            LET g_lis2[l_ac2].lis092 = ''  #FUN-CA0081 add
            LET g_lis2[l_ac2].lis081 = ''
            LET g_lis2[l_ac2].lis082 = ''
            LET g_lis2[l_ac2].lis083 = ''
            LET g_lis2[l_ac2].lis084 = ''
            LET g_lis2[l_ac2].lis10 = ''  
            CANCEL DELETE 
         END IF             
         IF NOT cl_null(g_lis2[l_ac2].lis04_2) THEN 
            
            CALL t365_lis05('r',g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis04_2,
                        g_lis2[l_ac2].lis05_2,g_lis2[l_ac2].lis06_2)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               CANCEL DELETE
            END IF    
         END IF           
         DELETE FROM lis_file
          WHERE lis01 = g_lir.lir01
            AND lis02 = g_lis2_t.lis02
            AND lis03 = g_lis2_t.lis03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lis_file",g_lir.lir01,g_lis2_t.lis02,SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE
         ELSE
            IF g_lis2[l_ac2].lis03 = '1' THEN  
              # LET g_lis2.[l_ac2].lis02 =  g_lis2_t.lis02
               LET g_lis2[l_ac2].lis04 = '' 
               LET g_lis2[l_ac2].lis05 = '' 
               LET g_lis2[l_ac2].lis06 = '' 
               LET g_lis2[l_ac2].lis08 = ''
               LET g_lis2[l_ac2].lis091 = ''  #FUN-CA0081 add
               LET g_lis2[l_ac2].lis092 = ''  #FUN-CA0081 add
               LET g_lis2[l_ac2].lis081 = ''
               LET g_lis2[l_ac2].lis082 = ''
               LET g_lis2[l_ac2].lis083 = ''
               LET g_lis2[l_ac2].lis084 = ''
               LET g_lis2[l_ac2].lis10 = ''
               COMMIT WORK
               CALL t365_lis10() 
               CANCEL DELETE 
            END IF    
         END IF
         IF g_lis2_t.lis03 = '2' THEN 
            LET g_rec_b2=g_rec_b2-1
         END IF
         DISPLAY g_rec_b2 TO FORMONLY.cnt1
         CALL t365_lis10() 
         COMMIT WORK 
      BEFORE FIELD lis02
         IF g_lis2[l_ac2].lis02 IS NULL OR g_lis2[l_ac2].lis02 = 0 THEN
            SELECT max(lis02)+1
              INTO g_lis2[l_ac2].lis02
              FROM lis_file
             WHERE lis01 = g_lir.lir01
            IF g_lis2[l_ac2].lis02 IS NULL THEN
               LET g_lis2[l_ac2].lis02 = 1
            END IF
         END IF

      AFTER FIELD lis02
         IF NOT cl_null(g_lis2[l_ac2].lis02) THEN
            IF (g_lis2[l_ac2].lis02 != g_lis2_t.lis02
                AND NOT cl_null(g_lis2_t.lis02))
               OR g_lis2_t.lis02 IS NULL THEN
               SELECT count(*)
                 INTO l_n
                 FROM lis_file
                WHERE lis01 = g_lir.lir01
                  AND lis02 = g_lis2[l_ac2].lis02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lis2[l_ac2].lis02 = g_lis2_t.lis02
                  NEXT FIELD lis02
               END IF
            END IF
            IF g_lis2[l_ac2].lis03_2 = '0' THEN 
               LET g_lis2[l_ac2].lis03 = '1'
            ELSE 
               LET g_lis2[l_ac2].lis03 = '2'   
            END IF
            IF g_lis2[l_ac2].lis05_2 < g_today THEN 
               LET g_lis2[l_ac2].lis04 = g_lis2[l_ac2].lis04_2
               LET g_lis2[l_ac2].lis05 = g_lis2[l_ac2].lis05_2
               LET g_lis2[l_ac2].lis08 = g_lis2[l_ac2].lis08_2
               LET g_lis2[l_ac2].lis091 = g_lis2[l_ac2].lis091_2   #FUN-CA0081 add
               LET g_lis2[l_ac2].lis092 = g_lis2[l_ac2].lis092_2   #FUN-CA0081 add
               LET g_lis2[l_ac2].lis081 = g_lis2[l_ac2].lis081_2
               LET g_lis2[l_ac2].lis082 = g_lis2[l_ac2].lis082_2
               LET g_lis2[l_ac2].lis083 = g_lis2[l_ac2].lis083_2
               LET g_lis2[l_ac2].lis084 = g_lis2[l_ac2].lis084_2
               LET g_lis2[l_ac2].lis10 = g_lis2[l_ac2].lis10_2 
               IF g_lis2[l_ac2].lis06_2 < g_today THEN
                  LET g_lis2[l_ac2].lis06 = g_lis2[l_ac2].lis06_2
               ELSE    
                  NEXT FIELD lis06
               END IF    
            END IF            
         END IF
    
      AFTER FIELD lis04
         IF NOT cl_null(g_lis2[l_ac2].lis04) AND g_lis2[l_ac2].lis03 <> '0' THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05_2) THEN 
               IF g_lis2[l_ac2].lis05_2 < g_today THEN 
                  LET g_lis2[l_ac2].lis04 = g_lis2[l_ac2].lis04_2
               END IF
            END IF 
            CALL t365_lis04(g_lis2[l_ac2].lis04) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lis2[l_ac2].lis04 = g_lis2_t.lis04
               NEXT FIELD lis04
            END IF 
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN 
               #CALL t365_lis05('u',g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis04,              #FUN-CA0081 mark
               #         g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)                         #FUN-CA0081 mark
               CALL t365_lis06('u',g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis04,g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)   #FUN-CA0081 add
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lis2[l_ac2].lis04 = g_lis2_t.lis04
                  NEXT FIELD lis04
               END IF  
            END IF     
         END IF
          
      AFTER FIELD lis05
         IF NOT cl_null(g_lis2[l_ac2].lis05) AND g_lis2[l_ac2].lis03 <> '0' THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05_2) THEN 
               IF g_lis2[l_ac2].lis05_2 < g_today THEN 
                  LET g_lis2[l_ac2].lis05 = g_lis2[l_ac2].lis05_2
               END IF
            END IF          
            IF NOT cl_null(g_lir.lir161) THEN 
               LET l_date = g_lir.lir161
            ELSE 
               LET l_date = g_lir.lir16  
            END IF 
            IF g_lis2[l_ac2].lis05 < l_date THEN 
               CALL cl_err('','alm1085',0)
               LET g_lis2[l_ac2].lis05 = g_lis2_t.lis05
               NEXT FIELD lis05
            ELSE 
               IF NOT cl_null(g_lis2[l_ac2].lis06) THEN
                  IF g_lis2[l_ac2].lis05 > g_lis2[l_ac2].lis06 THEN 
                     CALL cl_err('','art-207',0)
                     LET g_lis2[l_ac2].lis05 = g_lis2_t.lis05
                     NEXT FIELD lis05 
                  END IF 
                  IF NOT cl_null(g_lis2[l_ac2].lis04) THEN   
                     #CALL t365_lis05('u',g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis04,g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)  #FUN-CA0081 mark
                     CALL t365_lis06('u',g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis04,g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)   #FUN-CA0081 add
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_lis2[l_ac2].lis05 = g_lis2_t.lis05
                        NEXT FIELD lis05
                     ELSE
                        IF cl_null(g_lis2[l_ac2].lis08) OR cl_null(g_lis2[l_ac2].lis082) THEN  
                           CALL t365_lis081(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)
                        END IF      
                     END IF 
                  END IF    
               END IF
            END IF
         END IF
         #FUN-CA0081-----------add-------str
         IF cl_null(g_lis2[l_ac2].lis091) AND cl_null(g_lis2[l_ac2].lis092) THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis05(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis05
               END IF
            END IF
         END IF
         IF NOT cl_null(g_lis2[l_ac2].lis091) AND NOT cl_null(g_lis2[l_ac2].lis092) THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis091(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis05
               END IF
            END IF
         END IF 
         #FUN-CA0081-----------add-------end

      AFTER FIELD lis06
         IF NOT cl_null(g_lis2[l_ac2].lis06) AND g_lis2[l_ac2].lis03 <> '0' THEN
            IF (NOT cl_null(g_lis2[l_ac2].lis05_2) AND g_lis2[l_ac2].lis05_2 < g_today)
               AND NOT cl_null(g_lis2[l_ac2].lis06_2) THEN 
               IF g_lis2[l_ac2].lis06_2 < g_today THEN
                  LET g_lis2[l_ac2].lis06 = g_lis2[l_ac2].lis06_2
               ELSE  
                  IF g_lis2[l_ac2].lis06 < g_today THEN 
                     LET g_lis2[l_ac2].lis06 = g_today 
                  END IF  
               END IF 
            END IF
            IF NOT cl_null(g_lir.lir171) THEN 
               LET l_date = g_lir.lir171
            ELSE 
               LET l_date = g_lir.lir17 
            END IF                 
            IF g_lis2[l_ac2].lis06 > l_date THEN 
               CALL cl_err('','alm1085',0)
               LET g_lis2[l_ac2].lis06 = g_lis2_t.lis06
               NEXT FIELD lis06
            ELSE 
               IF NOT cl_null(g_lis2[l_ac2].lis05) THEN 
                  IF g_lis2[l_ac2].lis05 > g_lis2[l_ac2].lis06 THEN 
                     CALL cl_err('','art-207',0)
                     LET g_lis2[l_ac2].lis06 = g_lis2_t.lis06
                     NEXT FIELD lis06 
                  END IF 
                  IF NOT  cl_null(g_lis2[l_ac2].lis04) THEN  
                     #CALL t365_lis05('u',g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis04,g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)  #FUN-CA0081 mark
                     CALL t365_lis06('u',g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis04,g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)   #FUN-CA0081 add
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        #LET g_lis2[l_ac2].lis05 = g_lis2_t.lis05   #FUN-CA0081 mark
                        LET g_lis2[l_ac2].lis06 = g_lis2_t.lis06    #FUN-CA0081 add
                        NEXT FIELD lis06
                     ELSE
                        IF cl_null(g_lis2[l_ac2].lis081) OR cl_null(g_lis2[l_ac2].lis082) THEN  
                           CALL t365_lis081(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06)
                        END IF
                     END IF
                  END IF     
               END IF 
            END IF
         END IF
         #FUN-CA0081-----------add-------str
         IF cl_null(g_lis2[l_ac2].lis091) AND cl_null(g_lis2[l_ac2].lis092) THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis05(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis06
               END IF
            END IF
         END IF
         IF NOT cl_null(g_lis2[l_ac2].lis091) AND NOT cl_null(g_lis2[l_ac2].lis092) THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis091(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis06
               END IF
            END IF
         END IF
         #FUN-CA0081-----------add-------end
      AFTER FIELD lis083
         IF NOT cl_null(g_lis2[l_ac2].lis083) THEN 
            IF g_lis2[l_ac2].lis05_2 < g_today THEN 
               LET g_lis2[l_ac2].lis083 = g_lis2[l_ac2].lis083_2
            END IF 
            IF g_lis2[l_ac2].lis083 < 0 OR g_lis2[l_ac2].lis083 > 100 THEN 
               CALL cl_err('','art-207',0)
               LET g_lis2[l_ac2].lis083 = g_lis2_t.lis083
               NEXT FIELD lis083
            END IF
         END IF      
      AFTER FIELD lis084
         IF NOT cl_null(g_lis2[l_ac2].lis084) THEN 
            IF g_lis2[l_ac2].lis05_2 < g_today THEN 
               LET g_lis2[l_ac2].lis084 = g_lis2[l_ac2].lis084_2
            END IF  
            IF g_lis2[l_ac2].lis084 < 0 THEN 
               CALL cl_err('','alm1088',0)
               LET g_lis2[l_ac2].lis084 = g_lis2_t.lis084
               NEXT FIELD lis084
            END IF
            CALL cl_digcut(g_lis2[l_ac2].lis084,g_lla04) RETURNING g_lis2[l_ac2].lis084
            IF NOT cl_null(g_lis2[l_ac2].lis082) THEN 
               LET g_lis2[l_ac2].lis10 = (g_lis2[l_ac2].lis084 - g_lis2[l_ac2].lis082)/g_lis2[l_ac2].lis082
            END IF    
         END IF      

      #FUN-CA0081-----------add-------str
      AFTER FIELD lis091_4
         IF NOT cl_null(g_lis2[l_ac2].lis091) THEN
            IF g_lis2[l_ac2].lis091 <0 THEN
               CALL cl_err('','alm1089',0)
               LET g_lis2[l_ac2].lis091 = g_lis2_t.lis091
               NEXT FIELD lis091_4
            END IF
         END IF
         IF NOT cl_null(g_lis2[l_ac2].lis091) AND NOT cl_null(g_lis2[l_ac2].lis092) THEN
            IF g_lis2[l_ac2].lis091 > g_lis2[l_ac2].lis092 THEN
               CALL cl_err('','alm-161',0)
               NEXT FIELD lis091_4
            END IF
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis091(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis091_4
               END IF
            END IF
         END IF
         IF (NOT cl_null(g_lis2[l_ac2].lis091) AND cl_null(g_lis2[l_ac2].lis092))
            OR (cl_null(g_lis2[l_ac2].lis091) AND NOT cl_null(g_lis2[l_ac2].lis092)) THEN
            CALL cl_err('','alm1383',0)
         END IF
         IF cl_null(g_lis2[l_ac2].lis091) AND cl_null(g_lis2[l_ac2].lis092) THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis092(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis091_4 
               END IF
            END IF
         END IF

      AFTER FIELD lis092_4
         IF NOT cl_null(g_lis2[l_ac2].lis092) THEN
            IF g_lis2[l_ac2].lis092 <0 THEN
               CALL cl_err('','alm1089',0)
               LET g_lis2[l_ac2].lis092 = g_lis2_t.lis092
               NEXT FIELD lis092_4
            END IF
         END IF
         IF NOT cl_null(g_lis2[l_ac2].lis091) AND NOT cl_null(g_lis2[l_ac2].lis092) THEN
            IF g_lis2[l_ac2].lis091 > g_lis2[l_ac2].lis092 THEN
               CALL cl_err('','alm-161',0)
               NEXT FIELD lis092_4
            END IF
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis091(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis092_4
               END IF
            END IF
         END IF
         IF (NOT cl_null(g_lis2[l_ac2].lis091) AND cl_null(g_lis2[l_ac2].lis092))
            OR (cl_null(g_lis2[l_ac2].lis091) AND NOT cl_null(g_lis2[l_ac2].lis092)) THEN
            CALL cl_err('','alm1383',0)
         END IF
         IF cl_null(g_lis2[l_ac2].lis091) AND cl_null(g_lis2[l_ac2].lis092) THEN
            IF NOT cl_null(g_lis2[l_ac2].lis05) AND NOT cl_null(g_lis2[l_ac2].lis06) THEN
               CALL t365_chk_lis092(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lis092_4
               END IF
            END IF
         END IF

      ON CHANGE lis05,lis06,lis091_4,lis092_4
         CALL t365_set_required(g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2_t.lis02,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,p_cmd)  #FUN-CA0081 add
      #FUN-CA0081-----------add-------end
      ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lis2[l_ac2].* = g_lis2_t.*
              CLOSE t365_bc21
              CLOSE t365_bc22
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lis2[l_ac2].lis03,-263,1) 
              LET g_lis2[l_ac2].* = g_lis2_t.*
           ELSE
              SELECT COUNT(*) INTO l_n FROM lis_file
              WHERE lis01 = g_lir.lir01
                AND lis02 = g_lis2_t.lis02
              IF l_n = 2 THEN   
                 UPDATE lis_file SET lis02 = g_lis2[l_ac2].lis02,
                                     lis03 = g_lis2[l_ac2].lis03,
                                     lis04 = g_lis2[l_ac2].lis04,
                                     lis05 = g_lis2[l_ac2].lis05,
                                     lis06 = g_lis2[l_ac2].lis06,
                                     lis08 = g_lis2[l_ac2].lis08,
                                     lis091 = g_lis2[l_ac2].lis091,  #FUN-CA0081 add
                                     lis092 = g_lis2[l_ac2].lis092,  #FUN-CA0081 add
                                     lis081 = g_lis2[l_ac2].lis081,
                                     lis082 = g_lis2[l_ac2].lis082,
                                     lis083 = g_lis2[l_ac2].lis083,
                                     lis084 = g_lis2[l_ac2].lis084,
                                     lis10 = g_lis2[l_ac2].lis10
                    WHERE lis01=g_lir.lir01 
                      AND lis02=g_lis2_t.lis02
                      AND lis03=g_lis2[l_ac2].lis03
                 IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                    CALL cl_err3("upd","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
                    LET g_lis2[l_ac2].* = g_lis2_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    CALL t365_lis10()  
                 END IF
              ELSE
                 INSERT INTO lis_file(lis01,lis02,lis03,lis04,lis05,lis06,lis08,lis091,lis092,lis081,lis082,lis083,lis084,lisplant,lislegal)  #FUN-CA0081 add lis091,lis092
                  VALUES(g_lir.lir01,g_lis2[l_ac2].lis02,g_lis2[l_ac2].lis03,g_lis2[l_ac2].lis04,
                      g_lis2[l_ac2].lis05,g_lis2[l_ac2].lis06,g_lis2[l_ac2].lis08,g_lis2[l_ac2].lis091,g_lis2[l_ac2].lis092,g_lis2[l_ac2].lis081,  #FUN-CA0081 add lis091,lis092
                      g_lis2[l_ac2].lis082,g_lis2[l_ac2].lis083,g_lis2[l_ac2].lis084,g_lir.lirplant,g_lir.lirlegal)
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err3("ins","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
                   LET g_lis2[l_ac2].* = g_lis2_t.*
                 ELSE
                    MESSAGE 'INSERT O.K'
                    COMMIT WORK
                   CALL t365_lis10() 
                 END IF
              END IF                  
           END IF
 
       AFTER ROW
           LET l_ac2= ARR_CURR()
           LET l_ac2_t = l_ac2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lis2[l_ac2].* = g_lis2_t.*
              END IF
              CLOSE t365_bc21
              CLOSE t365_bc22
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t365_bc21
           CLOSE t365_bc22
           COMMIT WORK
           CALL t365_lis10() 
       ON ACTION controlp
           CASE WHEN INFIELD(lis04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lih07"
                LET l_where = " lmfstore = '",g_lir.lirplant,"'"
                IF NOT cl_null(g_lir.lir09) THEN 
                   LET l_where = l_where," AND lmf03 = '",g_lir.lir09,"'"
                END IF 
                IF NOT cl_null(g_lir.lir10) THEN 
                   LET l_where = l_where," AND lmf04 = '",g_lir.lir10,"'"
                END IF 
                LET g_qryparam.where = l_where
                LET g_qryparam.default1 = g_lis2[l_ac2].lis04
                CALL cl_create_qry() RETURNING g_lis2[l_ac2].lis04
                DISPLAY g_lis2[l_ac2].lis04 TO lis04
                CALL t365_lis04(g_lis2[l_ac2].lis04) 
                NEXT FIELD lis04
           OTHERWISE EXIT CASE
           END CASE
            
       ON ACTION CONTROLO
          IF INFIELD(lis02) AND l_ac2 > 1 THEN
             LET g_lis2[l_ac2].* = g_lis2[l_ac2-1].*
             NEXT FIELD lis02
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
                                                                                                             
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END INPUT
   IF p_cmd = 'u' THEN
      LET g_lir.lirmodu = g_user
      LET g_lir.lirdate = g_today
      UPDATE lir_file
         SET lirmodu = g_lip.lirmodu,
             lirdate = g_lip.lirdate
       WHERE lir01 = g_lir.lir01
      DISPLAY BY NAME g_lir.lirmodu,g_lir.lirdate
   END IF
   CLOSE t365_bc21
   CLOSE t365_bc22
   COMMIT WORK
END FUNCTION
FUNCTION t365_b3(p_cmd)
DEFINE
   l_ac3_t         LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5,
   l_where         STRING,
   l_date          LIKE lir_file.lir16
   #LET g_b_flag1 = '1'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_lir.lir01 IS NULL OR g_lir.lirplant IS NULL THEN RETURN END IF
      
   SELECT * INTO g_lir.* FROM lir_file
      WHERE lir01=g_lir.lir01 
   IF g_lir.liracti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_lir.lirconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
   IF g_lir.lirplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 
   
   CALL cl_opmsg('b')
   
   LET g_forupd_sql1 =
       " SELECT lis02,lis03,lis04,lis05,lis06,lis09,lis091,lis092,lis093,lis094,lis10",
       "  FROM lis_file ",
       " WHERE lis02=?  AND lis01='",g_lir.lir01,"'",
       "   AND lis03 = ?",
       " FOR UPDATE  "
   LET g_forupd_sql1 = cl_forupd_sql(g_forupd_sql1)
   DECLARE t365_bc31 CURSOR FROM g_forupd_sql1
   LET g_forupd_sql2 =
       " SELECT lis02,lis03,lis04,lis05,lis06,lis09,lis091,lis092,lis093,lis094,lis10",
       "  FROM lis_file ",
       " WHERE lis02=?  AND lis01='",g_lir.lir01,"'",
       "   AND lis03 = ?",
       " FOR UPDATE  "
   LET g_forupd_sql2 = cl_forupd_sql(g_forupd_sql2)
   DECLARE t365_bc32 CURSOR FROM g_forupd_sql2
  
   LET l_ac3_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lis3 WITHOUT DEFAULTS FROM s_lis3.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
            LET l_ac3 = 1
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
 
         OPEN t365_cl USING g_lir.lir01
         IF STATUS THEN
            CALL cl_err("OPEN t365_cl:", STATUS, 1)
            CLOSE t365_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t365_cl INTO g_lir.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_lir.lir01,SQLCA.SQLCODE,0)
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b3>=l_ac3 THEN
            LET g_lis3_t.* = g_lis3[l_ac3].*  #BACKUP
            LET p_cmd='u'
            SELECT count(*) INTO l_n FROM lis_file
             WHERE lis01 = g_lir.lir01
               AND lis02 = g_lis3[l_ac3].lis02
               AND lis03 = '0'
            IF l_n > 0 THEN
               OPEN t365_bc31 USING g_lis3_t.lis02,'0'
               IF STATUS THEN
                  CALL cl_err("OPEN t365_bc31:", STATUS, 1)
                  CLOSE t365_bc31
                  ROLLBACK WORK
                  RETURN
               END IF

               FETCH t365_bc31 INTO g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis03_3,g_lis3[l_ac3].lis04_3,
                                    g_lis3[l_ac3].lis05_3,g_lis3[l_ac3].lis06_3,g_lis3[l_ac3].lis09_3,
                                    g_lis3[l_ac3].lis091_3,g_lis3[l_ac3].lis092_3,g_lis3[l_ac3].lis093_3,
                                    g_lis3[l_ac3].lis094_3,g_lis3[l_ac3].lis10_3
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lis3_t.lis02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_lis3[l_ac3].lis03 = ''
            SELECT lis03 INTO g_lis3[l_ac3].lis03 FROM lis_file
             WHERE lis01 = g_lir.lir01
               AND lis02 = g_lis3[l_ac3].lis02
               AND (lis03 = '1' OR lis03='2')
            IF NOT cl_null(g_lis3[l_ac3].lis03) THEN
               OPEN t365_bc32 USING g_lis3_t.lis02,g_lis3[l_ac3].lis03
               IF STATUS THEN
                  CALL cl_err("OPEN t365_bc32:", STATUS, 1)
                  CLOSE t365_bc32
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t365_bc32 INTO g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis03,g_lis3[l_ac3].lis04,
                                    g_lis3[l_ac3].lis05,g_lis3[l_ac3].lis06,g_lis3[l_ac3].lis09,
                                    g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092,g_lis3[l_ac3].lis093,
                                    g_lis3[l_ac3].lis094,g_lis3[l_ac3].lis10
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lis3_t.lis02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            NEXT FIELD lis02
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         #LET g
         #INITIALIZE g_lis3[l_ac3].* TO NULL
         #LET g_lis3[l_ac3].lis03_3 = '0'
         LET g_lis3[l_ac3].lis03 = '2'
         LET g_lis3_t.* = g_lis3[l_ac3].*
         
         CALL cl_show_fld_cont()
         NEXT FIELD lis02      
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lis_file(lis01,lis02,lis03,lis04,lis05,lis06,lis09,lis091,lis092,lis093,lis094,lisplant,lislegal)
            VALUES(g_lir.lir01,g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis03,g_lis3[l_ac3].lis04,
                   g_lis3[l_ac3].lis05,g_lis3[l_ac3].lis06, g_lis3[l_ac3].lis09,g_lis3[l_ac3].lis091,
                   g_lis3[l_ac3].lis092,g_lis3[l_ac3].lis093,g_lis3[l_ac3].lis094,g_lir.lirplant,g_lir.lirlegal)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            CALL t365_lis10() 
            LET g_rec_b1=g_rec_b1+1   
         END IF



      BEFORE DELETE    
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM lis_file
          WHERE lis01 = g_lir.lir01 
            AND lis02 = g_lis3[l_ac3].lis02
         IF (l_n = 1 AND g_lis3[l_ac3].lis03_3 = '0') THEN 
            LET g_lis3[l_ac3].lis04 = ''   
            LET g_lis3[l_ac3].lis05 = ''   
            LET g_lis3[l_ac3].lis06 = ''   
            LET g_lis3[l_ac3].lis09 = ''   
            LET g_lis3[l_ac3].lis091 = ''   
            LET g_lis3[l_ac3].lis092 = ''   
            LET g_lis3[l_ac3].lis093 = '' 
            LET g_lis3[l_ac3].lis094 = ''   
            LET g_lis3[l_ac3].lis10 = ''    
            CANCEL DELETE 
         END IF              
         IF NOT cl_null(g_lis3[l_ac3].lis04_3) THEN 
            
            CALL t365_lis09('r',g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis04_3,g_lis3[l_ac3].lis05_3,
                        g_lis3[l_ac3].lis06_3,g_lis3[l_ac3].lis091_3,g_lis3[l_ac3].lis092_3)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               CANCEL DELETE
            END IF    
         END IF           
         DELETE FROM lis_file
          WHERE lis01 = g_lir.lir01
            AND lis02 = g_lis3_t.lis02
            AND lis03 = g_lis3_t.lis03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lis_file",g_lir.lir01,g_lis3_t.lis02,SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE
         ELSE 
            IF g_lis3[l_ac3].lis03 = '1' THEN 
               LET g_lis3[l_ac3].lis04 = ''   
               LET g_lis3[l_ac3].lis05 = ''   
               LET g_lis3[l_ac3].lis06 = ''   
               LET g_lis3[l_ac3].lis09 = ''   
               LET g_lis3[l_ac3].lis091 = ''   
               LET g_lis3[l_ac3].lis092 = ''   
               LET g_lis3[l_ac3].lis093 = '' 
               LET g_lis3[l_ac3].lis094 = ''   
               LET g_lis3[l_ac3].lis10 = '' 
               COMMIT WORK 
               CALL t365_lis10() 
               CANCEL DELETE 
            END IF     
         END IF
         IF  g_lis3_t.lis03 = '2' THEN 
            LET g_rec_b3=g_rec_b3-1
         END IF    
         DISPLAY g_rec_b3 TO FORMONLY.cnt1
         COMMIT WORK
         CALL t365_lis10() 
      BEFORE FIELD lis02
         IF g_lis3[l_ac3].lis02 IS NULL OR g_lis3[l_ac3].lis02 = 0 THEN
            SELECT max(lis02)+1
              INTO g_lis3[l_ac3].lis02
              FROM lis_file
             WHERE lis01 = g_lir.lir01
            IF g_lis3[l_ac3].lis02 IS NULL THEN
               LET g_lis3[l_ac3].lis02 = 1
            END IF
         END IF

      AFTER FIELD lis02
         IF NOT cl_null(g_lis3[l_ac3].lis02) THEN
            IF (g_lis3[l_ac3].lis02 != g_lis3_t.lis02
                AND NOT cl_null(g_lis3_t.lis02))
               OR g_lis3_t.lis02 IS NULL THEN
               SELECT count(*)
                 INTO l_n
                 FROM lis_file
                WHERE lis01 = g_lir.lir01
                  AND lis02 = g_lis3[l_ac3].lis02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lis3[l_ac3].lis02 = g_lis3_t.lis02
                  NEXT FIELD lis02
               END IF
            END IF
            IF g_lis3[l_ac3].lis03_3 = '0' THEN 
               LET g_lis3[l_ac3].lis03 = '1'
            ELSE 
               LET g_lis3[l_ac3].lis03 = '2'   
            END IF
            IF g_lis3[l_ac3].lis05_3 < g_today THEN 
               LET g_lis3[l_ac3].lis04 = g_lis3[l_ac3].lis04_3
               LET g_lis3[l_ac3].lis05 = g_lis3[l_ac3].lis05_3
               LET g_lis3[l_ac3].lis09 = g_lis3[l_ac3].lis09_3
               LET g_lis3[l_ac3].lis091 = g_lis3[l_ac3].lis091_3
               LET g_lis3[l_ac3].lis092 = g_lis3[l_ac3].lis092_3
               LET g_lis3[l_ac3].lis093 = g_lis3[l_ac3].lis093_3
               LET g_lis3[l_ac3].lis094 = g_lis3[l_ac3].lis094_3
               LET g_lis3[l_ac3].lis10 = g_lis3[l_ac3].lis10_3
               IF g_lis3[l_ac3].lis06_3 < g_today THEN
                  LET g_lis3[l_ac3].lis06 = g_lis3[l_ac3].lis06_3
               ELSE    
                  NEXT FIELD lis06
               END IF     
            END IF                      
         END IF  
         
      AFTER FIELD lis04
         IF NOT cl_null(g_lis3[l_ac3].lis04) AND g_lis3[l_ac3].lis03 <> '0' THEN
            IF g_lis3[l_ac3].lis05_3 < g_today THEN 
               LET g_lis3[l_ac3].lis04 = g_lis3[l_ac3].lis04_3
            END IF   
            CALL t365_lis04(g_lis3[l_ac3].lis04) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lis3[l_ac3].lis04 = g_lis3_t.lis04
               NEXT FIELD lis04
            END IF
            IF NOT cl_null(g_lis3[l_ac3].lis05) AND NOT cl_null(g_lis3[l_ac3].lis06) THEN 
               IF NOT cl_null(g_lis3[l_ac3].lis091) AND NOT cl_null(g_lis3[l_ac3].lis092) THEN
                  CALL t365_lis09('u',g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis04,g_lis3[l_ac3].lis05,
                          g_lis3[l_ac3].lis06,g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lis3[l_ac3].lis04 = g_lis3_t.lis04
                     NEXT FIELD lis04
                  END IF 
               END IF     
            END IF       
         END IF
  
      AFTER FIELD lis05
         IF NOT cl_null(g_lis3[l_ac3].lis05) AND g_lis3[l_ac3].lis03 <> '0' THEN
            IF NOT cl_null(g_lis3[l_ac3].lis05_3) THEN 
               IF g_lis3[l_ac3].lis05_3 < g_today THEN 
                  LET g_lis3[l_ac3].lis05 = g_lis3[l_ac3].lis05_3
               END IF
            END IF 
            IF NOT cl_null(g_lir.lir161) THEN 
               LET l_date = g_lir.lir161
            ELSE 
               LET l_date = g_lir.lir16  
            END IF             
            IF g_lis3[l_ac3].lis05 < l_date THEN 
               CALL cl_err('','alm1085',0)
               LET g_lis3[l_ac3].lis05 = g_lis3_t.lis05
               NEXT FIELD lis05
            ELSE 
               IF NOT cl_null(g_lis3[l_ac3].lis06) THEN
                  IF g_lis3[l_ac3].lis05 > g_lis3[l_ac3].lis06 THEN 
                     CALL cl_err('','art-207',0)
                     LET g_lis3[l_ac3].lis05 = g_lis3_t.lis05
                     NEXT FIELD lis05 
                  END IF 
                  IF NOT cl_null(g_lis3[l_ac3].lis04) THEN   
                     IF NOT cl_null(g_lis3[l_ac3].lis091) AND NOT cl_null(g_lis3[l_ac3].lis092) THEN
                        CALL t365_lis09('u',g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis04,g_lis3[l_ac3].lis05,
                                         g_lis3[l_ac3].lis06,g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092)
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,0)
                           LET g_lis3[l_ac3].lis05 = g_lis3_t.lis05
                           NEXT FIELD lis05
                        END IF 
                        CALL t365_lis093(g_lis3[l_ac3].lis05,g_lis3[l_ac3].lis06,
                              g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092)
                     END IF  
                  END IF    
               END IF
            END IF
         END IF
      AFTER FIELD lis06
         IF NOT cl_null(g_lis3[l_ac3].lis06) AND g_lis3[l_ac3].lis03 <> '0' THEN
            IF (NOT cl_null(g_lis3[l_ac3].lis05_3) AND g_lis3[l_ac3].lis05_3 < g_today)
               AND NOT cl_null(g_lis3[l_ac3].lis06_3) THEN 
               IF g_lis3[l_ac3].lis06_3 < g_today THEN
                  LET g_lis3[l_ac3].lis06 = g_lis3[l_ac3].lis06_3
               ELSE  
                  IF g_lis3[l_ac3].lis06 < g_today THEN 
                     LET g_lis3[l_ac3].lis06 = g_today 
                  END IF  
               END IF    
            END IF  
            IF NOT cl_null(g_lir.lir171) THEN 
               LET l_date = g_lir.lir171
            ELSE 
               LET l_date = g_lir.lir17  
            END IF             
            IF g_lis3[l_ac3].lis06 > l_date THEN 
               CALL cl_err('','alm1085',0)
               LET g_lis3[l_ac3].lis06 = g_lis3_t.lis06
               NEXT FIELD lis06
            ELSE 
               IF NOT cl_null(g_lis3[l_ac3].lis05) THEN
                  IF g_lis3[l_ac3].lis05 > g_lis3[l_ac3].lis06 THEN 
                     CALL cl_err('','art-207',0)
                     LET g_lis3[l_ac3].lis06 = g_lis3_t.lis06
                     NEXT FIELD lis06 
                  END IF 
                  IF NOT cl_null(g_lis3[l_ac3].lis04) THEN   
                     IF NOT cl_null(g_lis3[l_ac3].lis091) AND NOT cl_null(g_lis3[l_ac3].lis092) THEN
                        CALL t365_lis09('u',g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis04,g_lis3[l_ac3].lis05,
                                         g_lis3[l_ac3].lis06,g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092)
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,0)
                           LET g_lis3[l_ac3].lis06 = g_lis3_t.lis06
                           NEXT FIELD lis06
                        END IF 
                        CALL t365_lis093(g_lis3[l_ac3].lis05,g_lis3[l_ac3].lis06,
                                g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092)
                     END IF
                  END IF                         
                        #IF cl_null(g_lis3[l_ac3].lis093) THEN  
               END IF
            END IF
         END IF
      AFTER FIELD lis091
         IF NOT cl_null(g_lis3[l_ac3].lis091) THEN 
            IF g_lis3[l_ac3].lis05_3 < g_today THEN 
               LET g_lis3[l_ac3].lis091 = g_lis3[l_ac3].lis091_3
            END IF   
            IF g_lis3[l_ac3].lis091 < 0 THEN 
               CALL cl_err('','alm1089',0)
               LET g_lis3[l_ac3].lis091 = g_lis3_t.lis091
               NEXT FIELD lis091
            END IF
            IF NOT cl_null(g_lis3[l_ac3].lis092) THEN 
               IF g_lis3[l_ac3].lis092 < g_lis3[l_ac3].lis091 THEN 
                  CALL cl_err('','alm1020',0)
                  LET g_lis3[l_ac3].lis091 = g_lis3_t.lis091
                  NEXT FIELD lis091
               END IF 
               IF NOT cl_null(g_lis3[l_ac3].lis05) AND NOT cl_null(g_lis3[l_ac3].lis06) THEN
                  CALL t365_lis09('u',g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis04,g_lis3[l_ac3].lis05,
                            g_lis3[l_ac3].lis06,g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lis3[l_ac3].lis091 = g_lis3_t.lis091
                     NEXT FIELD lis091
                  END IF 
               END IF                 
            END IF  
         END IF      
      AFTER FIELD lis092
         IF NOT cl_null(g_lis3[l_ac3].lis092) THEN 
            IF g_lis3[l_ac3].lis05_3 < g_today THEN 
               LET g_lis3[l_ac3].lis092 = g_lis3[l_ac3].lis092_3
            END IF  
            IF g_lis3[l_ac3].lis092 < 0 THEN 
               CALL cl_err('','alm1090',0)
               LET g_lis3[l_ac3].lis092 = g_lis3_t.lis092
               NEXT FIELD lis092
            END IF
            IF NOT cl_null(g_lis3[l_ac3].lis091) THEN 
               IF g_lis3[l_ac3].lis092 < g_lis3[l_ac3].lis091 THEN 
                  CALL cl_err('','alm1020',0)
                  LET g_lis3[l_ac3].lis092 = g_lis3_t.lis092
                  NEXT FIELD lis092
               END IF
               IF NOT cl_null(g_lis3[l_ac3].lis05) AND NOT cl_null(g_lis3[l_ac3].lis06) THEN
                  CALL t365_lis09('u',g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis04,g_lis3[l_ac3].lis05,
                            g_lis3[l_ac3].lis06,g_lis3[l_ac3].lis091,g_lis3[l_ac3].lis092)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lis3[l_ac3].lis092 = g_lis3_t.lis092
                     NEXT FIELD lis092
                  END IF 
               END IF                     
            END IF    
         END IF         
      AFTER FIELD lis094 
         IF NOT cl_null(g_lis3[l_ac3].lis094) THEN
            IF g_lis3[l_ac3].lis05_3 < g_today THEN 
               LET g_lis3[l_ac3].lis094 = g_lis3[l_ac3].lis094_3
            END IF   
            IF g_lis3[l_ac3].lis094 < 0 THEN 
               CALL cl_err('','alm1080',0)
               LET g_lis3[l_ac3].lis094 = g_lis3_t.lis094
               NEXT FIELD lis094
            END IF
            CALL cl_digcut(g_lis3[l_ac3].lis094,g_lla04) RETURNING g_lis3[l_ac3].lis094
            IF NOT cl_null(g_lis3[l_ac3].lis093) THEN 
               LET g_lis3[l_ac3].lis10 = (g_lis3[l_ac3].lis094 - g_lis3[l_ac3].lis093)/g_lis3[l_ac3].lis093
            END IF 
         END IF         
      ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lis3[l_ac3].* = g_lis3_t.*
              CLOSE t365_bc31
              CLOSE t365_bc32
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lis3[l_ac3].lis03,-263,1) 
              LET g_lis3[l_ac3].* = g_lis3_t.*
           ELSE
              SELECT COUNT(*) INTO l_n FROM lis_file
              WHERE lis01 = g_lir.lir01
                AND lis02 = g_lis3_t.lis02
              IF l_n = 2 THEN              
                 UPDATE lis_file SET lis02 = g_lis3[l_ac3].lis02,
                                     lis03 = g_lis3[l_ac3].lis03,
                                     lis04 = g_lis3[l_ac3].lis04,
                                     lis05 = g_lis3[l_ac3].lis05,
                                     lis06 = g_lis3[l_ac3].lis06,
                                     lis09 = g_lis3[l_ac3].lis09,
                                     lis091 = g_lis3[l_ac3].lis091,
                                     lis092 = g_lis3[l_ac3].lis092,
                                     lis093 = g_lis3[l_ac3].lis093,
                                     lis094 = g_lis3[l_ac3].lis094,
                                     lis10 = g_lis3[l_ac3].lis10
                    WHERE lis01=g_lir.lir01 
                      AND lis02=g_lis3_t.lis02
                      AND lis03=g_lis3_t.lis03
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err3("upd","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
                    LET g_lis3[l_ac3].* = g_lis3_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    CALL t365_lis10() 
                 END IF
              ELSE
                 INSERT INTO lis_file(lis01,lis02,lis03,lis04,lis05,lis06,lis09,lis091,lis092,lis093,lis094,lisplant,lislegal)
                  VALUES(g_lir.lir01,g_lis3[l_ac3].lis02,g_lis3[l_ac3].lis03,g_lis3[l_ac3].lis04,
                        g_lis3[l_ac3].lis05,g_lis3[l_ac3].lis06, g_lis3[l_ac3].lis09,g_lis3[l_ac3].lis091,
                       g_lis3[l_ac3].lis092,g_lis3[l_ac3].lis093,g_lis3[l_ac3].lis094,g_lir.lirplant,g_lir.lirlegal)
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err3("ins","lis_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)
                    LET g_lis3[l_ac3].* = g_lis3_t.*
                 ELSE
                    MESSAGE 'INSERT O.K'
                    COMMIT WORK
                    CALL t365_lis10() 
                 END IF  
              END IF                   
           END IF
 
       AFTER ROW
           LET l_ac3= ARR_CURR()
           LET l_ac3_t = l_ac3
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lis3[l_ac3].* = g_lis3_t.*
              END IF
              CLOSE t365_bc31
              CLOSE t365_bc32
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t365_bc31
           CLOSE t365_bc32
           COMMIT WORK
           CALL t365_lis10() 
       ON ACTION controlp
           CASE WHEN INFIELD(lis04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lih07"
                LET l_where = " lmfstore = '",g_lir.lirplant,"'"
                IF NOT cl_null(g_lir.lir09) THEN 
                   LET l_where = l_where," AND lmf03 = '",g_lir.lir09,"'"
                END IF 
                IF NOT cl_null(g_lir.lir10) THEN 
                   LET l_where = l_where," AND lmf04 = '",g_lir.lir10,"'"
                END IF 
                LET g_qryparam.where = l_where
                LET g_qryparam.default1 = g_lis3[l_ac3].lis04
                CALL cl_create_qry() RETURNING g_lis3[l_ac3].lis04
                DISPLAY g_lis3[l_ac3].lis04 TO lis04
                CALL t365_lis04(g_lis3[l_ac3].lis04) 
                NEXT FIELD lis04
           OTHERWISE EXIT CASE
           END CASE
            
       ON ACTION CONTROLO
          IF INFIELD(lis02) AND l_ac3 > 1 THEN
             LET g_lis3[l_ac3].* = g_lis3[l_ac3-1].*
             NEXT FIELD lis02
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
                                                                                                             
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END INPUT
   IF p_cmd = 'u' THEN
      LET g_lir.lirmodu = g_user
      LET g_lir.lirdate = g_today
      UPDATE lir_file
         SET lirmodu = g_lip.lirmodu,
             lirdate = g_lip.lirdate
       WHERE lir01 = g_lir.lir01
      DISPLAY BY NAME g_lir.lirmodu,g_lir.lirdate
   END IF
   CLOSE t365_bc31
   CLOSE t365_bc32
   COMMIT WORK
END FUNCTION

FUNCTION t365_b1_fill(p_wc1)              #BODY FILL UP
DEFINE p_wc1        STRING   
 
    LET g_sql = "SELECT b.lis02,b.lis03,b.lis04,b.lis05,b.lis06,b.lis07,b.lis071,b.lis10,",
                "               a.lis03,a.lis04,a.lis05,a.lis06,a.lis07,a.lis071,a.lis10 ",
                "  FROM lis_file b LEFT OUTER JOIN lis_file a  ",
                "                  ON (a.lis01=b.lis01 AND a.lis02=b.lis02 AND a.lis03 <> b.lis03)",
                " WHERE b.lis03 = '0' AND b.lis01='",g_lir.lir01,"'",
                " AND b.lisplant='",g_lir.lirplant,"' ",
                " AND ", p_wc1 CLIPPED,
                "  ORDER BY b.lis02 " 
       
    PREPARE t365_b11_prepare FROM g_sql                     #預備一下
    DECLARE lis_cs11 CURSOR FOR t365_b11_prepare
    CALL g_lis1.clear()
    LET g_rec_b1 = 0
    LET g_cnt = 1
    FOREACH lis_cs11 INTO g_lis1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_sql = " SELECT b.lis02,'','','','','','','', ",       
                "        b.lis03,b.lis04,b.lis05,b.lis06,b.lis07,b.lis071,b.lis10  ", 
                "   FROM  lis_file b",
                "  WHERE b.lis03 = '2' AND b.lis01 = '",g_lir.lir01,"'",
                "    AND b.lisplant='",g_lir.lirplant,"'",
                "    AND ", p_wc1 CLIPPED,
                "  ORDER BY b.lis02 "    
    PREPARE t365_b12_prepare FROM g_sql                     #預備一下
    DECLARE lis_cs12 CURSOR FOR t365_b12_prepare
    FOREACH lis_cs12 INTO g_lis1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH    
    CALL g_lis1.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cnt1
 
END FUNCTION
FUNCTION t365_b2_fill(p_wc1)              #BODY FILL UP
DEFINE p_wc1        STRING   
 
    LET g_sql = " SELECT b.lis02,b.lis03,b.lis04,b.lis05,b.lis06,b.lis08,b.lis091,b.lis092,b.lis081, ",  #FUN-CA0081 add b.lis091,b.lis092,
                "                              b.lis082,b.lis083,b.lis084,b.lis10, ",         
                "        a.lis03,a.lis04,a.lis05,a.lis06,a.lis08,a.lis091,a.lis092,a.lis081,         ",  #FUN-CA0081 add a.lis091,a.lis092,
                "                        a.lis082,a.lis083,a.lis084,a.lis10        ",   
                "   FROM lis_file b LEFT OUTER JOIN lis_file a",
                "                   ON (b.lis01=a.lis01 AND b.lis02=a.lis02 AND a.lis03 <> b.lis03)  ",
                "  WHERE b.lis03 = '0' AND b.lis01 = '",g_lir.lir01,"'",
                "    AND b.lisplant='",g_lir.lirplant,"'",
                "    AND ", p_wc1 CLIPPED,
                "  ORDER BY b.lis02 " 
    PREPARE t365_b21_prepare FROM g_sql              
    DECLARE lis_cs21 CURSOR FOR t365_b21_prepare
    CALL g_lis2.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH lis_cs21 INTO g_lis2[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_sql = " SELECT b.lis02,'','','','','','','','','','','','', ",                          #FUN-CA0081 add 2''
                "        b.lis03,b.lis04,b.lis05,b.lis06,b.lis08,b.lis091,b.lis092,b.lis081,  ",  #FUN-CA0081 add b.lis091,b.lis092,
                "                        b.lis082,b.lis083,b.lis084,b.lis10 ",   
                "   FROM  lis_file b",
                "  WHERE b.lis03 = '2' AND b.lis01 = '",g_lir.lir01,"'",
                "    AND b.lisplant='",g_lir.lirplant,"'",
                "    AND ", p_wc1 CLIPPED,
                "  ORDER BY b.lis02 "
    PREPARE t365_b22_prepare FROM g_sql              
    DECLARE lis_cs22 CURSOR FOR t365_b22_prepare                
    FOREACH lis_cs22 INTO g_lis2[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH                
    CALL g_lis2.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cnt1
 
END FUNCTION
FUNCTION t365_b3_fill(p_wc1)              #BODY FILL UP
DEFINE p_wc1        STRING   
 
    LET g_sql = " SELECT b.lis02,b.lis03,b.lis04,b.lis05,b.lis06,b.lis09,b.lis091, ",
                "                              b.lis092,b.lis093,b.lis094,b.lis10, ",         
                "        a.lis03,a.lis04,a.lis05,a.lis06,a.lis09,a.lis091,         ",
                "                        a.lis092,a.lis093,a.lis094,a.lis10        ",   
                "   FROM lis_file b LEFT OUTER JOIN lis_file a",
                "                   ON (a.lis01=b.lis01 AND a.lis02=b.lis02 AND b.lis03 <> a.lis03)  ",
                "  WHERE b.lis03 = '0' AND b.lis01 = '",g_lir.lir01,"'",
                "    AND b.lisplant='",g_lir.lirplant,"'",
                "    AND ", p_wc1 CLIPPED,
                "  ORDER BY b.lis02 " 
    PREPARE t365_b31_prepare FROM g_sql                     #預備一下
    DECLARE lis_cs31 CURSOR FOR t365_b31_prepare
    CALL g_lis3.clear()
    LET g_rec_b3 = 0
    LET g_cnt = 1
    FOREACH lis_cs31 INTO g_lis3[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH  
    LET g_sql = " SELECT b.lis02,'','','','','','','','','','', ",       
                "        b.lis03,b.lis04,b.lis05,b.lis06,b.lis09,b.lis091, ",
                "                        b.lis092,b.lis093,b.lis094,b.lis10 ",   
                "   FROM  lis_file b",
                "  WHERE b.lis03 = '2' AND b.lis01 = '",g_lir.lir01,"'",
                "    AND b.lisplant='",g_lir.lirplant,"'",
                "    AND ", p_wc1 CLIPPED,
                "  ORDER BY b.lis02 " 
    PREPARE t365_b32_prepare FROM g_sql                     #預備一下
    DECLARE lis_cs32 CURSOR FOR t365_b32_prepare
    FOREACH lis_cs32 INTO g_lis3[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH    
    CALL g_lis3.deleteElement(g_cnt)
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cnt1
 
END FUNCTION
FUNCTION t365_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_lir.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   IF cl_null(g_argv1) THEN
      CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
   ELSE
      LET g_lir.lir06 = g_argv1
      CASE g_lir.lir06
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
   CALL t365_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      CLEAR FORM 
      INITIALIZE g_lir.* TO NULL
      CALL g_lis1.clear()
      CALL g_lis2.clear()
      CALL g_lis3.clear()
      LET g_wc2 = NULL
      LET g_wc3 = NULL
      LET g_wc4 = NULL
      LET g_lir01_t = NULL
      LET g_wc = NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t365_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_lir.* TO NULL
   ELSE
      OPEN t365_count
      FETCH t365_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t365_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
FUNCTION t365_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lir.lir01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lir.lirconf = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_lir.lirplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 

   SELECT * INTO g_lir.* FROM lir_file
    WHERE lir01=g_lir.lir01
   BEGIN WORK

   OPEN t365_cl USING g_lir.lir01
   IF STATUS THEN
      CALL cl_err("OPEN t365_cl:", STATUS, 1)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t365_cl INTO g_lir.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lir.lir01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t365_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "lir01"
       LET g_doc.value1 = g_lir.lir01
       CALL cl_del_doc()
      DELETE FROM lir_file WHERE lir01 = g_lir.lir01
      DELETE FROM lis_file WHERE lis01 = g_lir.lir01
      CLEAR FORM
      CALL g_lis1.clear()
      CALL g_lis2.clear()
      CALL g_lis3.clear()
      OPEN t365_count
      FETCH t365_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t365_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t365_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t365_fetch('/')
      END IF
   END IF

   CLOSE t365_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lir.lir01,'D')
END FUNCTION 
FUNCTION t365_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lir.lir01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lir.lirplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 
   IF g_lir.lirconf = 'Y' THEN 
      CALL cl_err('','9023',0)
      RETURN
   END IF 
   BEGIN WORK

   OPEN t365_cl USING g_lir.lir01
   IF STATUS THEN
      CALL cl_err("OPEN t365_cl:", STATUS, 1)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t365_cl INTO g_lir.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lir.lir01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t365_show()

   IF cl_exp(0,0,g_lir.liracti) THEN
      IF g_lir.liracti='Y' THEN
         LET g_lir.liracti='N'
      ELSE
         LET g_lir.liracti='Y'
      END IF

      UPDATE lir_file SET liracti=g_lir.liracti,
                          lirmodu=g_user,
                          lirdate=g_today
       WHERE lir01=g_lir.lir01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lir_file",g_lir.lir01,"",SQLCA.sqlcode,"","",1)
      END IF
   END IF

   CLOSE t365_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lir.lir01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   LET g_lir.lirmodu = g_user
   LET g_lir.lirdate=g_today
   DISPLAY BY NAME g_lir.liracti,g_lir.lirmodu,
                   g_lir.lirdate
   CALL cl_set_field_pic(g_lir.lirconf,g_lir.lir19,"","","",g_lir.liracti)
END FUNCTION

FUNCTION t365_fetch(p_flag)
DEFINE   p_flag   LIKE type_file.chr1
   CASE p_flag
      WHEN 'N' FETCH NEXT     t365_cs INTO g_lir.lir01
      WHEN 'P' FETCH PREVIOUS t365_cs INTO g_lir.lir01
      WHEN 'F' FETCH FIRST    t365_cs INTO g_lir.lir01
      WHEN 'L' FETCH LAST     t365_cs INTO g_lir.lir01
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
         FETCH ABSOLUTE g_jump t365_cs INTO g_lir.lir01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lir.lir01,SQLCA.SQLCODE,0) 
      INITIALIZE g_lir.* TO NULL
      CALL g_lis1.clear()
      CALL g_lis2.clear()
      CALL g_lis3.clear()
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
   SELECT * INTO g_lir.* FROM lir_file WHERE  lir01 = g_lir.lir01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_lir.* TO NULL
      CALL g_lis1.clear()
      CALL g_lis2.clear()
      CALL g_lis3.clear()
      CALL cl_err3("sel","lir_file",g_lir.lir01,"",SQLCA.SQLCODE,"","",1)  
      RETURN
   END IF
   
   CALL t365_show()
END FUNCTION
 
FUNCTION t365_show()
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_lmb03    LIKE lmb_file.lmb03
   DEFINE l_lmc04    LIKE lmc_file.lmc04
  
   DISPLAY BY NAME
      g_lir.lir01,g_lir.lir02, g_lir.lir03,g_lir.lir04,g_lir.lir05,g_lir.lir06,
      g_lir.lir07,g_lir.lir071,g_lir.lir08,g_lir.lirplant,g_lir.lirlegal,g_lir.lir09,
      g_lir.lir10,g_lir.lir11,g_lir.lir12,g_lir.lir13,g_lir.lir14,g_lir.lir15,
      g_lir.lir16,g_lir.lir17,g_lir.lir18,g_lir.lir161,g_lir.lir171,g_lir.lir181,
      g_lir.lirmksg,g_lir.lir19,g_lir.lirconf,g_lir.lirconu,g_lir.lircond,g_lir.lir20,         
      g_lir.liruser,g_lir.lirmodu,g_lir.liracti,g_lir.lirgrup,g_lir.lircont,
      g_lir.lirdate,g_lir.lircrat,g_lir.liroriu,g_lir.lirorig        
   CALL t365_desc()
   CASE g_lir.lir06
      WHEN '1'
        CALL cl_set_comp_visible('Page4,Page5',FALSE)
        CALL cl_set_comp_visible('Page3',TRUE)
        CALL t365_b1_fill(g_wc2)
      WHEN '2'
        CALL cl_set_comp_visible('Page3,Page5',FALSE)
        CALL cl_set_comp_visible('Page4',TRUE)
        CALL t365_b2_fill(g_wc3)
      WHEN '3'
        CALL cl_set_comp_visible('Page3,Page4',FALSE)
        CALL cl_set_comp_visible('Page5',TRUE)
        CALL t365_b3_fill(g_wc4)
   END CASE   
   CALL t365_lis10()
   CALL cl_set_field_pic(g_lir.lirconf,g_lir.lir19,"","","",g_lir.liracti)      
   CALL cl_show_fld_cont()
END FUNCTION
FUNCTION t365_desc()
DEFINE l_oaj02    LIKE oaj_file.oaj02
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_azt02    LIKE azt_file.azt02
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_lmb03    LIKE lmb_file.lmb03
DEFINE l_lmc04    LIKE lmc_file.lmc04
DEFINE l_lmy04    LIKE lmy_file.lmy04
DEFINE l_oba02    LIKE oba_file.oba02
DEFINE l_tqa02    LIKE tqa_file.tqa02
DEFINE l_gen02_1  LIKE gen_file.gen02
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lir.lir03
   DISPLAY l_gen02 TO FORMONLY.gen02
   SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = g_lir.lir08
   DISPLAY l_oaj02 TO FORMONLY.oaj02  
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lir.lirplant
   DISPLAY l_rtz13 TO FORMONLY.rtz13
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lir.lirlegal
   DISPLAY l_azt02 TO FORMONLY.azt02
   SELECT lmb03 INTO l_lmb03 FROM lmb_file 
    WHERE lmbstore = g_lir.lirplant AND lmb02 = g_lir.lir09
   DISPLAY l_lmb03  TO FORMONLY.lmb03 
   IF NOT cl_null(g_lir.lir09) AND NOT cl_null(g_lir.lir10) THEN
      SELECT lmc04 INTO l_lmc04 FROM lmc_file WHERE lmcstore = g_lir.lirplant AND lmc02 = g_lir.lir09 AND lmc03 = g_lir.lir10
   ELSE 
     IF NOT cl_null(g_lir.lir10) THEN
        SELECT lmc04 INTO l_lmc04 FROM lmc_file WHERE lmcstore = g_lir.lirplant AND lmc03 = g_lir.lir10
        IF SQLCA.sqlcode = -284 THEN
          LET l_lmc04 = ''
        END IF 
     END IF 
   END IF 
   DISPLAY l_lmc04  TO FORMONLY.lmc04
   SELECT lmy04 INTO l_lmy04 FROM lmy_file 
    WHERE lmystore = g_lir.lirplant AND lmy01 = g_lir.lir09 
      AND lmy02 = g_lir.lir10 AND lmy03 = g_lir.lir11
   DISPLAY l_lmy04  TO FORMONLY.lmy04   
   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_lir.lir12
   DISPLAY l_oba02  TO FORMONLY.oba02
   SELECT tqa02 INTO l_tqa02  FROM tqa_file 
    WHERE tqa01 = g_lir.lir13 AND tqa03 = '30'
   DISPLAY l_tqa02  TO FORMONLY.tqa02
   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lir.lirconu
   DISPLAY l_gen02_1 TO FORMONLY.gen02_1
END FUNCTION 
FUNCTION t365_lir03(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,
       l_gen02   LIKE gen_file.gen02,#員工姓名
       l_genacti LIKE gen_file.genacti
   LET g_errno = ''    
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_lir.lir03
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm1091'
      WHEN l_genacti = 'N'       LET g_errno = 'alm1092'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.gen02   
   END IF   

END FUNCTION
FUNCTION t365_lir04(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_lip   RECORD LIKE lip_file.*
DEFINE l_lir   RECORD LIKE lir_file.*
DEFINE l_n     LIKE type_file.num5
   LET g_errno = ''
   SELECT * INTO l_lip.* FROM lip_file
    WHERE lip01 = g_lir.lir04 
   CASE 
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1093'
      WHEN l_lip.lipacti = 'N'  LET g_errno = 'alm1082'
      WHEN l_lip.lipconf = 'N'  LET g_errno = 'alm1094'
      WHEN l_lip.lipconf = 'S'  LET g_errno = 'alm-884'
      WHEN l_lip.lipplant <> g_plant LET g_errno = 'alm1023'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) AND NOT cl_null(g_argv1) THEN 
      IF l_lip.lip04 <> g_argv1 THEN 
         LET g_errno = 'alm-886'
      END IF 
   END IF    
   IF cl_null(g_errno) THEN 
      CALL t365_lir05(l_lip.lip01) RETURNING l_lip.lip02
   END IF    
   IF cl_null(g_errno) THEN 
      CALL t365_checkexpense(l_lip.lip04,l_lip.lip06,l_lip.lipplant,l_lip.lip07,l_lip.lip08,
                             l_lip.lip09,l_lip.lip10,l_lip.lip11,l_lip.lip12,l_lip.lip13)
   END IF                           
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_lir.lir05 = l_lip.lip02
      LET g_lir.lir06 = l_lip.lip04
      LET g_lir.lir07 = l_lip.lip05
      LET g_lir.lir071 = l_lip.lip051
      LET g_lir.lir08 = l_lip.lip06
      LET g_lir.lirplant = l_lip.lipplant
      LET g_lir.lirlegal = l_lip.liplegal
      LET g_lir.lir09 = l_lip.lip07  
      LET g_lir.lir10 = l_lip.lip08
      LET g_lir.lir11 = l_lip.lip09
      LET g_lir.lir12 = l_lip.lip10
      LET g_lir.lir13 = l_lip.lip11
      LET g_lir.lir14 = l_lip.lip12
      LET g_lir.lir15 = l_lip.lip13
      LET g_lir.lir16 = l_lip.lip14
      LET g_lir.lir17 = l_lip.lip15
      LET g_lir.lir18 = l_lip.lip16

      CASE g_lir.lir06
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
      #CALL t365_lir16() RETURNING l_n
      IF g_lir.lir16 > g_today THEN 
         CALL cl_set_comp_entry("lir161",TRUE)
      ELSE
         CALL cl_set_comp_entry("lir161",FALSE)
      END IF
      DISPLAY BY NAME g_lir.lir05,g_lir.lir06,g_lir.lir07,g_lir.lir071,
                      g_lir.lir08,g_lir.lirplant,g_lir.lirlegal,g_lir.lir09,
                      g_lir.lir10,g_lir.lir11,g_lir.lir12,g_lir.lir13,
                      g_lir.lir14,g_lir.lir15,g_lir.lir16,g_lir.lir17,g_lir.lir18
      CALL t365_desc() 
   END IF   
END FUNCTION
FUNCTION t365_lir05(l_lip01)
DEFINE l_n        LIKE type_file.num5, 
       l_lip01    LIKE lip_file.lip01, 
       l_lir05    LIKE lir_file.lir05
   LET g_errno = ' '    
   SELECT COUNT(*) INTO l_n FROM lir_file
    WHERE lir04 = l_lip01
      AND lir01 <> g_lir.lir01
      AND lirplant = g_plant
      AND (lirconf = 'N' OR (lirconf = 'Y' AND lir19 <> '2'))
   IF l_n > 0 THEN 
      LET g_errno = 'alm1095'       
   ELSE 
      SELECT MAX(lip02)+1 INTO l_lir05
        FROM lip_file
       WHERE lip01 = l_lip01
         AND lipplant = g_plant
      IF l_lir05 = 0 THEN
         LET l_lir05 = 1
      END IF
   END IF
   RETURN l_lir05
END FUNCTION    
FUNCTION t365_checkexpense(l_lip04,l_lip06,l_lipplant,l_lip07,l_lip08,l_lip09,
                           l_lip10,l_lip11,l_lip12,l_lip13)
DEFINE
   l_lip04    LIKE lip_file.lip04,
   l_lip06    LIKE lip_file.lip06,#费用编号
   l_lipplant LIKE lip_file.lipplant,#门店
   l_lip07    LIKE lip_file.lip07,#楼栋编号 
   l_lip08    LIKE lip_file.lip08,#楼层编号
   l_lip09    LIKE lip_file.lip09,#区域编号
   l_lip10    LIKE lip_file.lip10,#小类编号
   l_lip11    LIKE lip_file.lip11,#摊位用途
   l_lip12    LIKE lip_file.lip12,#日期类型
   l_lip13    LIKE lip_file.lip13,#定义方式
   l_lnl03    LIKE lnl_file.lnl03,#楼栋
   l_lnl04    LIKE lnl_file.lnl04,#楼层
   l_lnl05    LIKE lnl_file.lnl05,#区域
   l_lnl09    LIKE lnl_file.lnl09,#小类 
   l_n        LIKE type_file.num5, 
   l_sql      STRING 
   LET g_errno = ' '   
   SELECT lnl03,lnl04,lnl05,lnl09 
     INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file 
    WHERE lnl01 = l_lip06 AND lnlstore = l_lipplant
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm1031'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   LET l_sql = " SELECT COUNT(*) FROM lik_file  ",
               " WHERE lik01 = '",l_lip06,"'",
               "   AND likstore = '",l_lipplant,"'",
               "   AND lik07 = '",l_lip11,"'",
               "   AND lik08 = '",l_lip12,"'", 
               "   AND lik09 = '",l_lip13,"'",
               "   AND lik10 = '",l_lip04,"'"
   IF cl_null(g_errno) THEN
      #判断方案中NOT NULL的栏位在almi350参数中是否有勾选
      IF NOT cl_null(l_lip07) THEN
         IF l_lnl03 = 'Y' THEN 
            LET l_sql = l_sql," AND (lik03 = '",l_lip07,"' OR lik03 = '*') " 
         ELSE
            LET g_errno= 'alm1084'
         END IF 
      ELSE             
         IF NOT cl_null(l_lip08) THEN  
            IF l_lnl04 = 'Y' THEN 
               LET l_sql = l_sql," AND (lik04 = '",l_lip08,"' OR lik04 = '*') "
            ELSE    
               LET g_errno= 'alm1084'
            END IF    
         ELSE
            IF NOT cl_null(l_lip09) THEN 
               IF l_lnl05 = 'Y' THEN 
                  LET l_sql = l_sql," AND (lik05 = '",l_lip09,"' OR lik05 = '*') "
               ELSE    
                  LET g_errno= 'alm1084'
               END IF    
            ELSE
               IF NOT cl_null(l_lip10) THEN 
                  IF l_lnl09 = 'Y' THEN 
                     LET l_sql = l_sql," AND (lik06 = '",l_lip10,"' OR lik06 = '*') "
                  ELSE    
                     LET g_errno= 'alm1084'
                  END IF    
               END IF
            END IF
         END IF
      END IF
      IF cl_null(g_errno) THEN 
       #参数中的日期类型，定义方法，定义方式，摊位用途与方案中的是否一致
         PREPARE t365_likpre FROM l_sql
         DECLARE t365_likcount CURSOR FOR t365_likpre
         OPEN t365_likcount         
         FETCH t365_likcount INTO l_n
         IF l_n = 0 THEN 
            LET g_errno= 'alm1084'
         END IF 
         CLOSE t365_likcount      
      END IF
   END IF 
END FUNCTION 
FUNCTION t365_lir16()
DEFINE  l_n    LIKE type_file.num5
   SELECT COUNT(liq04) INTO l_n FROM liq_file 
    WHERE liq01 = g_lir.lir04
      AND liqplant = g_lir.lirplant
      AND liq04 < g_lir.lir161
   IF l_n = 0 THEN 
      SELECT COUNT(lis05) INTO l_n FROM lis_file
       WHERE lis01 = g_lir.lir01
         AND lirplant = g_lir.lirplant
         AND lis05 < g_lir.lir161
   END IF       
   RETURN  l_n 
END FUNCTION  
FUNCTION t365_lir17()
DEFINE  l_n    LIKE type_file.num5
   SELECT COUNT(liq05) INTO l_n FROM liq_file 
    WHERE liq01 = g_lir.lir04
      AND liqplant = g_lir.lirplant
      AND liq05 > g_lir.lir171
   IF l_n = 0 THEN 
      SELECT COUNT(lis06) INTO l_n FROM lis_file
       WHERE lis01 = g_lir.lir01
         AND lirplant = g_lir.lirplant
         AND lis06 > g_lir.lir161
   END IF         
   RETURN  l_n 
END FUNCTION   
FUNCTION t365_lis04(l_lis04)
DEFINE  p_cmd      LIKE type_file.chr1,
        l_lmfacti  LIKE type_file.chr1,
        l_lis04    LIKE lis_file.lis04, 
        l_lmf06    LIKE lmf_file.lmf06,  #確認碼
        l_sql      STRING 
   LET g_errno = ' '        
   LET l_sql = "  SELECT lmf06,lmfacti ",
               "    FROM lmf_file",
               "   WHERE lmf01 ='", l_lis04,"'",
               "     AND lmfstore = '",g_lir.lirplant,"'"
   IF NOT cl_null(g_lir.lir09) THEN 
      LET l_sql = l_sql," AND lmf03 = '",g_lir.lir09,"'"
   END IF     
   IF NOT cl_null(g_lir.lir10) THEN 
      LET l_sql = l_sql," AND lmf04 = '",g_lir.lir10,"'"
   END IF
   PREPARE t365_lis04pre FROM l_sql
   DECLARE t365_lis04cs CURSOR FOR t365_lis04pre
   OPEN t365_lis04cs
   IF STATUS THEN
      CALL cl_err("OPEN t365_lis04cs:", STATUS, 1)
      CLOSE t365_lis04cs
      RETURN
   END IF
   FETCH t365_lis04cs INTO l_lmf06,l_lmfacti
  # IF SQLCA.SQLCODE THEN
  #     CALL cl_err('',SQLCA.SQLCODE,1)
  # END IF    
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm-042'
      WHEN l_lmf06 <> 'Y'        LET g_errno = 'alm-059'
      WHEN l_lmfacti = 'N'       LET g_errno = ''
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE 
   CLOSE t365_lis04cs 
END FUNCTION
FUNCTION t365_lis05(p_cmd,l_lis02,l_lis04,p_stardate,p_enddate)
DEFINE p_cmd        LIKE type_file.chr1,
       l_n          LIKE type_file.num5,
       l_lis02      LIKE lis_file.lis02,
       l_lis04      LIKE lis_file.lis04,
       p_stardate   LIKE lis_file.lis05,
       p_enddate    LIKE lis_file.lis06
   LET g_errno = ' '    
   SELECT COUNT(lis04) INTO l_n FROM lis_file
    WHERE lis04 = l_lis04
      AND lisplant = g_lir.lirplant
      AND lis02 <> l_lis02
      AND lis01 = g_lir.lir01
      AND ((lis03 = '2' OR lis03 = '1')  
            OR ( lis03 = '0'AND lis02 NOT IN 
                               (SELECT lis02 FROM lis_file 
                                  WHERE lis03 = '1' AND lis01 = g_lir.lir01))) 
      AND (														
           lis05 BETWEEN p_stardate AND p_enddate														
           OR  lis06 BETWEEN p_stardate AND p_enddate														
           OR  (lis05 <=p_stardate AND lis06 >= p_enddate)														
           )
   IF l_n > 0 THEN
      IF p_cmd = 'u' THEN  
         LET g_errno = 'alm1096'
      ELSE 
         IF p_cmd = 'r' THEN 
            LET g_errno = 'alm1116'
         END IF    
      END IF     
   END IF       
END FUNCTION 

#FUN-CA0081------add----str
FUNCTION t365_lis06(p_cmd,l_lis02,l_lis04,p_stardate,p_enddate)
DEFINE p_cmd        LIKE type_file.chr1,
       l_n          LIKE type_file.num5,
       l_n1         LIKE type_file.num5,
       l_lis02      LIKE lis_file.lis02,
       l_lis04      LIKE lis_file.lis04,
       p_stardate   LIKE lis_file.lis05,
       p_enddate    LIKE lis_file.lis06
   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n1 FROM lis_file
    WHERE lis01 = g_lir.lir01 
      AND lisplant = g_lir.lirplant
      AND lis02 <> l_lis02
      AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
      AND lis05 = p_stardate 
      AND lis06 = p_enddate
   IF l_n1 = 0 THEN
      SELECT COUNT(lis04) INTO l_n FROM lis_file
       WHERE lis04 = l_lis04
         AND lisplant = g_lir.lirplant
         AND lis02 <> l_lis02
         AND lis01 = g_lir.lir01
         AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
         AND (
              lis05 BETWEEN p_stardate AND p_enddate
              OR  lis06 BETWEEN p_stardate AND p_enddate
              OR  (lis05 <=p_stardate AND lis06 >= p_enddate)
              )
   END IF
   IF l_n > 0 THEN
      IF p_cmd = 'u' THEN
         LET g_errno = 'alm1096'
      ELSE
         IF p_cmd = 'r' THEN
            LET g_errno = 'alm1116'
         END IF
      END IF
   END IF
END FUNCTION
#FUN-CA0081------add----end
FUNCTION t365_lir161(p_stardate,p_enddate) 
DEFINE l_sql        STRING
DEFINE l_n          LIKE type_file.num5,
       p_stardate   LIKE lip_file.lip14,
       p_enddate    LIKE lip_file.lip15
    LET g_errno = ' '
    LET l_sql = " SELECT COUNT(*) FROM lip_file WHERE lipplant = '",g_lir.lirplant,"'",
                " AND lip01 <> '",g_lir.lir04,"'",
                " AND ('",p_stardate,"' BETWEEN lip14 AND lip15 ",
                "        OR '",p_enddate,"' BETWEEN lip14 AND lip15  ",
                "  OR (lip14 >= '",p_stardate,"'",
                "        AND lip15 <= '",p_enddate,"'))",
                " AND lipconf <> 'S' "
    IF NOT cl_null( g_lir.lir08) THEN
       LET l_sql = l_sql," AND lip06 = '",g_lir.lir08,"'"
    END IF
    IF NOT cl_null( g_lir.lir09) THEN
       LET l_sql = l_sql," AND lip07 = '",g_lir.lir09,"'"
    END IF
    IF NOT cl_null( g_lir.lir10) THEN
       LET l_sql = l_sql," AND lip08 = '",g_lir.lir10,"'"
    END IF
    IF NOT cl_null( g_lir.lir11) THEN
       LET l_sql = l_sql," AND lip09 = '",g_lir.lir11,"'"
    END IF
    IF NOT cl_null( g_lir.lir12) THEN
       LET l_sql = l_sql," AND lip10 = '",g_lir.lir12,"'"
    END IF
    IF NOT cl_null( g_lir.lir13) THEN
       LET l_sql = l_sql," AND lip11 = '",g_lir.lir13,"'"
    END IF
    PREPARE sel_num_pre FROM l_sql
    EXECUTE  sel_num_pre INTO l_n

   IF l_n > 0 THEN 
      LET g_errno = 'alm1078'
   END IF        
END FUNCTION 
FUNCTION t365_confirm()                       #審核
DEFINE l_gen02   LIKE gen_file.gen02
   IF cl_null(g_lir.lir01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
#CHI-C30107 ---------- add ----------- begin
   IF g_lir.lirplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF
    
   IF g_lir.liracti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
 
   IF g_lir.lirconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
        RETURN
   END IF
#CHI-C30107 ---------- add ----------- end
   SELECT * INTO g_lir.* FROM lir_file WHERE lir01=g_lir.lir01
   IF g_lir.lirplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF
    
   IF g_lir.liracti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
 
   IF g_lir.lirconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   CALL t365_checkexpense(g_lir.lir06,g_lir.lir08,g_lir.lirplant,g_lir.lir09,g_lir.lir10,g_lir.lir11,
                           g_lir.lir12,g_lir.lir13,g_lir.lir14,g_lir.lir15)
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('',g_errno,0)
      RETURN 
   END IF
   IF NOT cl_null(g_lir.lir161) AND NOT cl_null(g_lir.lir171) THEN   
      CALL t365_lir161(g_lir.lir161,g_lir.lir171)
   ELSE 
      IF NOT cl_null(g_lir.lir161) THEN 
         CALL t365_lir161(g_lir.lir161,g_lir.lir17)
      ELSE 
         CALL t365_lir161(g_lir.lir16,g_lir.lir171)
      END IF
   END IF           
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('',g_errno,0)
      RETURN 
   END IF    
#CHI-C30107 --------- mark ---------- begin
#  IF NOT cl_confirm('alm-006') THEN
#       RETURN
#  END IF
#CHI-C30107 --------- mark ---------- end

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t365_cl USING g_lir.lir01
   IF STATUS THEN
      CALL cl_err("OPEN t365_cl:", STATUS, 1)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t365_cl INTO g_lir.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lir.lir01,SQLCA.sqlcode,0)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_lir.lircont = TIME
   UPDATE lir_file
      SET lirconf = 'Y',
          lirconu = g_user,
          lircond = g_today,
          lircont = g_lir.lircont,
          lirmodu = g_user,
          lirdate = g_today,
          lir19   = '1'
    WHERE lir01 = g_lir.lir01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lir_file",g_lir.lir01,"",STATUS,"","",1)
      LET g_lir.lircont = ''
      LET g_success = 'N'
   ELSE
      LET g_lir.lirconf = 'Y'
      LET g_lir.lirconu = g_user
      LET g_lir.lircond = g_today
      LET g_lir.lircont = TIME
      LET g_lir.lirmodu = g_user
      LET g_lir.lirdate = g_today
      LET g_lir.lir19   = '1'
      DISPLAY BY NAME g_lir.lirconf,g_lir.lirconu,g_lir.lircond,g_lir.lircont,
                      g_lir.lirmodu,g_lir.lirdate,g_lir.lir19
      CALL cl_set_field_pic(g_lir.lirconf,g_lir.lir19,"","","",g_lir.liracti)
      #SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lin.linconu    #TQC-C30239 mark
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lir.lirconu
      DISPLAY l_gen02 TO FORMONLY.gen02_1
      
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   MESSAGE " "
END FUNCTION
FUNCTION t365_change_export()
   IF cl_null(g_lir.lir01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_lir.*
   FROM lir_file
   WHERE lir01=g_lir.lir01
   IF g_lir.lirplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF   
   IF g_lir.liracti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lir.lirconf='N' THEN
      CALL cl_err('','alm-936',0)
      RETURN
   END IF
   IF g_lir.lir19='2' THEN
      CALL cl_err('','alm-944',0)
      RETURN
   END IF
   CALL t365_checkexpense(g_lir.lir06,g_lir.lir08,g_lir.lirplant,g_lir.lir09,g_lir.lir10,g_lir.lir11,
                           g_lir.lir12,g_lir.lir13,g_lir.lir14,g_lir.lir15)
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('',g_errno,0)
      RETURN 
   END IF    
   IF NOT cl_null(g_lir.lir161) AND NOT cl_null(g_lir.lir171) THEN   
      CALL t365_lir161(g_lir.lir161,g_lir.lir171)
   ELSE 
      IF NOT cl_null(g_lir.lir161) THEN 
         CALL t365_lir161(g_lir.lir161,g_lir.lir17)
      ELSE 
         CALL t365_lir161(g_lir.lir16,g_lir.lir171)
      END IF
   END IF
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('',g_errno,0)
      RETURN 
   END IF    
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t365_cl USING g_lir.lir01
   IF STATUS THEN
      CALL cl_err("OPEN t365_cl:", STATUS, 1)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t365_cl INTO g_lir.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lir.lir01,SQLCA.sqlcode,0)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF NOT cl_confirm('art-859') THEN
        RETURN
   END IF
   CALL t365_change()
     UPDATE lir_file SET lir19 = '2',lirmodu = g_user,lirdate = g_today
      WHERE lir01 = g_lir.lir01
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","lir_file",g_lir.lir01,"",STATUS,"","",1)
        LET g_success = 'N'
     ELSE
        LET g_lir.lir19 = '2'
        LET g_lir.lirmodu = g_user
        LET g_lir.lirdate = g_today
        DISPLAY BY NAME g_lir.lir19,g_lir.lirmodu,g_lir.lirdate
      END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE 
      ROLLBACK WORK   
   END IF 

END FUNCTION 
FUNCTION t365_change()
DEFINE l_n     LIKE type_file.num5

   UPDATE lip_file SET lip02 = g_lir.lir05,
                       lipmodu = g_lir.lir03,
                       lipdate = g_today
    WHERE lip01 = g_lir.lir04  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lip_file",g_lir.lir04,"",STATUS,"","",1)
      LET g_success = 'N'
   END IF 
   IF NOT cl_null(g_lir.lir161) THEN 
      UPDATE lip_file SET lip14 = g_lir.lir161 WHERE lip01 = g_lir.lir04  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lip_file",g_lir.lir04,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF  
   IF NOT cl_null(g_lir.lir171) THEN 
      UPDATE lip_file SET lip15 = g_lir.lir171 WHERE lip01 = g_lir.lir04  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lip_file",g_lir.lir04,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF   
   IF NOT cl_null(g_lir.lir181) THEN 
      UPDATE lip_file SET lip16 = g_lir.lir181 WHERE lip01 = g_lir.lir04  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lip_file",g_lir.lir04,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF      

   IF g_success <> 'N' THEN  
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 = g_lir.lir01
         AND lis03 = '1' 
      IF l_n > 0 THEN 
         CALL t365_update_liq()
      END IF
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 = g_lir.lir01
         AND lis03 = '2' 
      IF l_n > 0 THEN 
         CALL t365_insert_liq()
      END IF
   END IF 
END FUNCTION 
FUNCTION t365_update_liq()
DEFINE l_liq   DYNAMIC ARRAY OF RECORD
         liq02      LIKE liq_file.liq02, 
         liq03      LIKE liq_file.liq03,
         liq04      LIKE liq_file.liq04,
         liq05      LIKE liq_file.liq05,    
         liq06      LIKE liq_file.liq06,
         liq061     LIKE liq_file.liq061,        
         liq07      LIKE liq_file.liq07,    
         liq071     LIKE liq_file.liq071,
         liq072     LIKE liq_file.liq072,
         liq073     LIKE liq_file.liq073,    
         liq074     LIKE liq_file.liq074,
         liq08      LIKE liq_file.liq08,       
         liq081     LIKE liq_file.liq081,    
         liq082     LIKE liq_file.liq082,
         liq083     LIKE liq_file.liq083,    
         liq084     LIKE liq_file.liq084,         
         liq09      LIKE liq_file.liq09
       END RECORD 
DEFINE l_sql   STRING 
DEFINE l_n     LIKE type_file.num5
   LET l_sql = "SELECT lis02,lis04,lis05,lis06,lis07,lis071,",
               "       lis08,lis081,lis082,lis083,lis084,lis09,   ",
               "       lis091,lis092,lis093,lis094,lis10          ",
               "  FROM lis_file                                   ",
               " WHERE lis01 = '",g_lir.lir01,"'",
               "   AND lis03 = '1' "
   PREPARE t365_update_pre FROM l_sql
   DECLARE t365_update_cs CURSOR FOR t365_update_pre
   LET l_n = 1
   FOREACH t365_update_cs INTO l_liq[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      UPDATE liq_file SET liq03 = l_liq[l_n].liq03,liq04 = l_liq[l_n].liq04,
                          liq05 = l_liq[l_n].liq05,liq06 = l_liq[l_n].liq06,
                          liq061 = l_liq[l_n].liq061,liq07 = l_liq[l_n].liq07,
                          liq071 = l_liq[l_n].liq071,liq072 = l_liq[l_n].liq072,
                          liq073 = l_liq[l_n].liq073,liq074 = l_liq[l_n].liq074,
                          liq08 = l_liq[l_n].liq08,liq081 = l_liq[l_n].liq081,
                          liq082 = l_liq[l_n].liq082,liq083 = l_liq[l_n].liq083,
                          liq084 = l_liq[l_n].liq084,liq09 = l_liq[l_n].liq09
       WHERE liq01 = g_lir.lir04 
         AND liq02 = l_liq[l_n].liq02      
     
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","liq_file",g_lir.lir04,l_liq[l_n].liq02 ,SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
      END IF

      LET l_n = l_n + 1

   END FOREACH                   
END FUNCTION 
FUNCTION t365_insert_liq()
DEFINE l_liq   DYNAMIC ARRAY OF RECORD
         liq02      LIKE liq_file.liq02, 
         liq03      LIKE liq_file.liq03,
         liq04      LIKE liq_file.liq04,
         liq05      LIKE liq_file.liq05,    
         liq06      LIKE liq_file.liq06,
         liq061     LIKE liq_file.liq061,        
         liq07      LIKE liq_file.liq07,    
         liq071     LIKE liq_file.liq071,
         liq072     LIKE liq_file.liq072,
         liq073     LIKE liq_file.liq073,    
         liq074     LIKE liq_file.liq074,
         liq08      LIKE liq_file.liq08,       
         liq081     LIKE liq_file.liq081,    
         liq082     LIKE liq_file.liq082,
         liq083     LIKE liq_file.liq083,    
         liq084     LIKE liq_file.liq084,         
         liq09      LIKE liq_file.liq09
       END RECORD 
DEFINE l_sql   STRING 
DEFINE l_n     LIKE type_file.num5
   LET l_sql = "SELECT lis02,lis04,lis05,lis06,lis07,lis071,",
               "       lis08,lis081,lis082,lis083,lis084,lis09,   ",
               "       lis091,lis092,lis093,lis094,lis10          ",
               "  FROM lis_file                                   ",
               " WHERE lis01 = '",g_lir.lir01,"'",
               "   AND lis03 = '2' "
   PREPARE t365_insert_pre FROM l_sql
   DECLARE t365_insert_cs CURSOR FOR t365_insert_pre
   LET l_n = 1
   FOREACH t365_insert_cs INTO l_liq[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INSERT INTO liq_file(liq01,liq02,liq03,liq04,liq05,liq06,liq061,
                           liq07,liq071,liq072,liq073,liq074,liq08,liq081,
                           liq082,liq083,liq084,liq09,liqplant,liqlegal)
           VALUES(g_lir.lir04,l_liq[l_n].liq02,l_liq[l_n].liq03,l_liq[l_n].liq04,
                  l_liq[l_n].liq05,l_liq[l_n].liq06, l_liq[l_n].liq061,l_liq[l_n].liq07,
                  l_liq[l_n].liq071,l_liq[l_n].liq072,l_liq[l_n].liq073,l_liq[l_n].liq074,
                  l_liq[l_n].liq08,l_liq[l_n].liq081,l_liq[l_n].liq082,l_liq[l_n].liq083,
                  l_liq[l_n].liq084,l_liq[l_n].liq09,g_lir.lirplant,g_lir.lirlegal)
     
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","liq_file",g_lir.lir04,l_liq[l_n].liq02 ,SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
      END IF

      LET l_n = l_n + 1

   END FOREACH                      
END FUNCTION 
FUNCTION t365_undoconfirm()                     #取消審核
DEFINE l_gen02 LIKE gen_file.gen02      #CHI-D20015---add---
   IF cl_null(g_lir.lir01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_lir.*
   FROM lir_file
   WHERE lir01=g_lir.lir01
   IF g_lir.lirplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF   
   IF g_lir.liracti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lir.lirconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF g_lir.lir19='2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t365_cl USING g_lir.lir01
   IF STATUS THEN
      CALL cl_err("OPEN t365_cl:", STATUS, 1)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t365_cl INTO g_lir.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lir.lir01,SQLCA.sqlcode,0)
      CLOSE t365_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF NOT cl_confirm('alm-008') THEN
        RETURN
   END IF

   #UPDATE lir_file SET lirconf = 'N',lirconu = '',lircond = '',lircont = '',lir19 = '0',  #CHI-D20015---mark---
   UPDATE lir_file SET lirconf = 'N',lirconu = g_user,lircond = g_today,lircont =TIME,lir19 = '0',  #CHI-D20015---add---
                     lirmodu = g_user,lirdate = g_today
    WHERE lir01 = g_lir.lir01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lir_file",g_lir.lir01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lir.lirconf = 'N'
      #CHI-D20015---modify---str---
      #LET g_lir.lirconu = ''
      #LET g_lir.lircond = ''
      #LET g_lir.lircont = ''
      LET g_lir.lirconu = g_user
      LET g_lir.lircond = g_today
      LET g_lir.lircont = TIME
      #CHI-D20015---modify---end---
      LET g_lir.lir19 = '0'
      LET g_lir.lirmodu = g_user
      LET g_lir.lirdate = g_today
      DISPLAY BY NAME g_lir.lirconf,g_lir.lirconu,g_lir.lircond,g_lir.lircont,g_lir.lir19,
                      g_lir.lirmodu,g_lir.lirdate
      CALL cl_set_field_pic(g_lir.lirconf,g_lir.lir19,"","","",g_lir.liracti)  
      #CHI-D20015---MODIFY---STR---
      #DISPLAY '' TO FORMONLY.gen02_1      
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lir.lirconu
      DISPLAY l_gen02 TO FORMONLY.gen02_1
      #CHI-D20015---MODIFY---END---
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF 
END FUNCTION 
FUNCTION t365_insert_lis()
DEFINE l_lis    DYNAMIC ARRAY OF RECORD 
         lis02      LIKE lis_file.lis02, 
        # lis03      LIKE lis_file.lis03,
         lis04      LIKE lis_file.lis04,
         lis05      LIKE lis_file.lis05,    
         lis06      LIKE lis_file.lis06,    
         lis07      LIKE lis_file.lis07,    
         lis071     LIKE lis_file.lis071,
         lis08      LIKE lis_file.lis08,       
         lis081     LIKE lis_file.lis081,    
         lis082     LIKE lis_file.lis082,
         lis083     LIKE lis_file.lis083,    
         lis084     LIKE lis_file.lis084,
         lis09      LIKE lis_file.lis09,       
         lis091     LIKE lis_file.lis091,    
         lis092     LIKE lis_file.lis092,
         lis093     LIKE lis_file.lis093,    
         lis094     LIKE lis_file.lis094,         
         lis10      LIKE lis_file.lis10
       END RECORD 
DEFINE l_sql   STRING 
DEFINE l_n     LIKE type_file.num5

   LET l_sql = "SELECT liq02,liq03,liq04,liq05,liq06,liq061,liq07, ",
               "       liq071,liq072,liq073,liq074,liq08,liq081,   ",
               "       liq082,liq083, liq084,liq09                 ",
               "  FROM liq_file                                    ",
               " WHERE liq01 = '",g_lir.lir04,"'"
   PREPARE t365_ins_pre FROM l_sql
   DECLARE t365_ins_cs CURSOR FOR t365_ins_pre
   LET l_n = 1
   FOREACH t365_ins_cs INTO l_lis[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INSERT INTO lis_file(lis01,lis02,lis03,lis04,lis05,lis06,lis07,lis071,
                           lis08,lis081,lis082,lis083,lis084,lis09,lis091,
                           lis092,lis093,lis094,lis10,lisplant,lislegal)
           VALUES(g_lir.lir01,l_lis[l_n].lis02,'0',l_lis[l_n].lis04,
                  l_lis[l_n].lis05,l_lis[l_n].lis06, l_lis[l_n].lis07,l_lis[l_n].lis071,
                  l_lis[l_n].lis08,l_lis[l_n].lis081,l_lis[l_n].lis082,l_lis[l_n].lis083,
                  l_lis[l_n].lis084,l_lis[l_n].lis09,l_lis[l_n].lis091,l_lis[l_n].lis092,
                  l_lis[l_n].lis093,l_lis[l_n].lis094,l_lis[l_n].lis10,g_lir.lirplant,g_lir.lirlegal)
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0  THEN
         CALL cl_err3("ins","lis_file",l_lis[l_n].lis02,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
      END IF
      LET l_n = l_n + 1

   END FOREACH   
END FUNCTION 

FUNCTION t365_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lir01",TRUE)
    END IF

END FUNCTION

FUNCTION t365_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lir01",FALSE)
    END IF

END FUNCTION 

FUNCTION t365_lis10()
DEFINE l_count    LIKE lis_file.lis10
DEFINE l_n        LIKE type_file.num5
DEFINE l_count2   LIKE lis_file.lis10
DEFINE l_n2       LIKE type_file.num5
   SELECT SUM(lis10) INTO l_count
     FROM lis_file
    WHERE lis01 = g_lir.lir01
      AND lisplant = g_lir.lirplant
      AND (lis03 = '2' OR lis03 = '1')
   SELECT SUM(lis10) INTO l_count2 
     FROM lis_file
    WHERE lis01 = g_lir.lir01
      AND lisplant = g_lir.lirplant
      AND lis03 = '0'
      AND lis02 NOT IN  ( SELECT lis02 FROM lis_file
                           WHERE lis03 = '1' AND lis01 = g_lir.lir01)
   IF cl_null(l_count) THEN
      LET l_count = 0
   END IF
   IF cl_null(l_count2) THEN
      LET l_count2 = 0
   END IF
   SELECT COUNT(*) INTO l_n 
      FROM lis_file
    WHERE lis01 = g_lir.lir01
      AND lisplant = g_lir.lirplant
      AND (lis03 = '2' OR lis03 = '0')
   LET l_count = l_count + l_count2
   LET g_desc = l_count/l_n
   DISPLAY g_desc TO desc
END FUNCTION 
FUNCTION t365_lis07(l_lis05,l_lis06)
DEFINE l_lis05   LIKE lis_file.lis05
DEFINE l_lis06   LIKE lis_file.lis06
DEFINE l_lim05   LIKE lim_file.lim05
DEFINE l_sql     STRING 
    LET l_sql = "SELECT lim05 FROM lim_file ",
                "  WHERE lim01 = '",g_lir.lir07,"'",
                "    AND limplant='",g_lir.lirplant,"'",
                "    AND (lim03 < '", l_lis05 ,"' AND lim04 > '",l_lis06,"')"
    PREPARE t365_lis07_pre FROM l_sql                 
    DECLARE lis_cs07 CURSOR FOR t365_lis07_pre

    FOREACH lis_cs07 INTO l_lim05             
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF NOT cl_null(l_lim05) THEN
           EXIT FOREACH
        END IF
    END FOREACH
    RETURN l_lim05
END FUNCTION      
FUNCTION t365_lis081(l_lis05,l_lis06)
DEFINE l_lis05    LIKE lis_file.lis05
DEFINE l_lis06    LIKE lis_file.lis06
DEFINE l_lim061   LIKE lim_file.lim061
DEFINE l_lim062   LIKE lim_file.lim062
DEFINE l_sql     STRING 
    LET l_sql = "SELECT lim061,lim062 FROM lim_file ",
                "  WHERE lim01 = '",g_lir.lir07,"'",
                "    AND limplant='",g_lir.lirplant,"'",
                "    AND (lim03 < '", l_lis05 ,"' AND lim04 > '",l_lis06,"')"
    PREPARE t365_lis08_pre FROM l_sql                 
    DECLARE lis_cs08 CURSOR FOR t365_lis08_pre

    FOREACH lis_cs08 INTO g_lis2[l_ac2].lis081,g_lis2[l_ac2].lis082             
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF NOT (cl_null(g_lis2[l_ac2].lis081) OR cl_null(g_lis2[l_ac2].lis081)) THEN
           EXIT FOREACH
        END IF
    END FOREACH
END FUNCTION 
FUNCTION t365_lis093(l_lis05,l_lis06,l_lis091,l_lis092)
DEFINE l_lis05    LIKE lis_file.lis05
DEFINE l_lis06    LIKE lis_file.lis06
DEFINE l_lim073   LIKE lim_file.lim061
DEFINE l_lis091   LIKE lim_file.lim071
DEFINE l_lis092   LIKE lim_file.lim072
DEFINE l_sql     STRING 
    LET l_sql = "SELECT lim073 FROM lim_file ",
                "  WHERE lim01 = '",g_lir.lir07,"'",
                "    AND limplant='",g_lir.lirplant,"'",
                "    AND (lim03 < '", l_lis05 ,"' AND lim04 > '",l_lis06,"')"#,
              #  "    AND (lim071 BETWEEN '", l_lis091 ,"' AND '",l_lis091,"'",														
              #  "         OR  lim072 BETWEEN '", l_lis091 ,"' AND '",l_lis092,"'",													
              #  "         OR  (lim071 <= '", l_lis091 ,"' AND lim072 >= '",l_lis092,"'))"
    PREPARE t365_lis09_pre FROM l_sql                 
    DECLARE lis_cs09 CURSOR FOR t365_lis09_pre

    FOREACH lis_cs09 INTO g_lis3[l_ac3].lis093         
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF NOT cl_null(g_lis3[l_ac3].lis093)THEN
           EXIT FOREACH
        END IF
   END FOREACH        
END FUNCTION 
FUNCTION t365_lis09(p_cmd,l_lis02,l_lis04,l_lis05,l_lis06,l_lis091,l_lis092)
DEFINE p_cmd        LIKE type_file.chr1,
       l_n          LIKE type_file.num5,
       l_lis02      LIKE lis_file.lis02,
       l_lis04      LIKE lis_file.lis04,
       l_lis05      LIKE lis_file.lis05,
       l_lis06      LIKE lis_file.lis06,
       l_lis091     LIKE lis_file.lis091,
       l_lis092     LIKE lis_file.lis092
   LET g_errno = ' '    
   SELECT COUNT(*) INTO l_n FROM lis_file
    WHERE lis04 = l_lis04
      AND lisplant = g_lir.lirplant
      AND lis02 <> l_lis02
      AND lis01 = g_lir.lir01
      AND ((lis03 = '2' OR lis03 = '1')  
            OR ( lis03 = '0'AND lis02 NOT IN 
                               (SELECT lis02 FROM lis_file 
                                  WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
                                  
      AND (														
           lis091 BETWEEN l_lis091 AND l_lis092													
           OR  lis092 BETWEEN l_lis091 AND l_lis092													
           OR  (lis091 <=l_lis091 AND lis092 >= l_lis092)														
           )
      AND (														
           lis05 BETWEEN l_lis05 AND l_lis06													
           OR  lis06 BETWEEN l_lis05 AND l_lis06													
           OR  (lis05 <=l_lis05 AND lis06 >= l_lis06)														
           )           
   IF l_n > 0 THEN
      IF p_cmd = 'u' THEN  
         LET g_errno = 'alm-872'
      ELSE 
         LET g_errno = 'alm1116'
      END IF    
   END IF       
END FUNCTION 
#FUN-B90121
#FUN-CA0081-----------add------str
#检查同一时间段内上下限不重复
FUNCTION t365_chk_lis091(startdate,enddate,p_lis02,p_lis091,p_lis092,p_cmd)
   DEFINE p_lis02          LIKE lis_file.lis02
   DEFINE p_lis091         LIKE lis_file.lis091
   DEFINE p_lis092         LIKE lis_file.lis092
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat
   DEFINE p_cmd            LIKE type_file.chr1

   LET g_errno = ''

   IF p_cmd = 'u' THEN
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 =  g_lir.lir01
         AND lis02 <> p_lis02
         AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
         AND lis05 = startdate 
         AND lis06 = enddate
         AND ((p_lis091 BETWEEN lis091 AND lis092
              OR p_lis092 BETWEEN lis091 AND lis092)
         OR  (lis091 BETWEEN p_lis091 AND p_lis092
               OR lis092 BETWEEN p_lis091 AND p_lis092 ))
   ELSE
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 =  g_lir.lir01
         AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
         AND lis05 = startdate
         AND lis06 = enddate
         AND ((p_lis091 BETWEEN lis091 AND lis092
              OR p_lis092 BETWEEN lis091 AND lis092)
         OR  (lis091 BETWEEN p_lis091 AND p_lis092
               OR lis092 BETWEEN p_lis091 AND p_lis092 )) 
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm-872'
      RETURN
   END IF
END FUNCTION
FUNCTION t365_chk_lis092(startdate,enddate,p_lis02,p_cmd)
   DEFINE p_lis02          LIKE lis_file.lis02
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat
   DEFINE p_cmd            LIKE type_file.chr1

   LET g_errno = ''

   IF p_cmd = 'u' THEN
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 =  g_lir.lir01
         AND lis02 <> p_lis02
         AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
         AND lis05 = startdate
         AND lis06 = enddate
         AND lis091 IS NOT NULL
         AND lis092 IS NOT NULL
   ELSE
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 =  g_lir.lir01
         AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
         AND lis05 = startdate
         AND lis06 = enddate
         AND lis091 IS NOT NULL
         AND lis092 IS NOT NULL
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm1389'
      RETURN
   END IF
END FUNCTION
FUNCTION t365_chk_lis05(startdate,enddate,p_lis02,p_cmd)
   DEFINE p_lis02          LIKE lis_file.lis02
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat
   DEFINE p_cmd            LIKE type_file.chr1

   LET g_errno = ''

   IF p_cmd = 'u' THEN
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 =  g_lir.lir01
         AND lis02 <> p_lis02
         AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
         AND lis05 = startdate
         AND lis06 = enddate
         AND lis091 IS NULL
         AND lis092 IS NULL
   ELSE
      SELECT COUNT(*) INTO l_n FROM lis_file
       WHERE lis01 =  g_lir.lir01
         AND ((lis03 = '2' OR lis03 = '1')
               OR ( lis03 = '0'AND lis02 NOT IN
                                  (SELECT lis02 FROM lis_file
                                     WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
         AND lis05 = startdate
         AND lis06 = enddate
         AND lis091 IS NULL
         AND lis092 IS NULL
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm1389'
      RETURN
   END IF
END FUNCTION
FUNCTION t365_set_required(startdate,enddate,p_lis02,p_lis091,p_lis092,p_cmd)
   DEFINE p_lis02          LIKE lis_file.lis02
   DEFINE p_lis091         LIKE lis_file.lis091
   DEFINE p_lis092         LIKE lis_file.lis092
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat

   IF NOT cl_null(startdate) AND NOT cl_null(enddate) THEN
      IF p_cmd = 'u' THEN
         SELECT COUNT(*) INTO l_n FROM lis_file
          WHERE lis01 =  g_lir.lir01
            AND lis02 <> p_lis02
            AND ((lis03 = '2' OR lis03 = '1')
                  OR ( lis03 = '0'AND lis02 NOT IN
                                     (SELECT lis02 FROM lis_file
                                        WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
            AND lis05 = startdate
            AND lis06 = enddate
            AND lis091 IS NOT NULL
            AND lis092 IS NOT NULL
      ELSE
         SELECT COUNT(*) INTO l_n FROM lis_file
          WHERE lis01 =  g_lir.lir01
            AND ((lis03 = '2' OR lis03 = '1')
                  OR ( lis03 = '0'AND lis02 NOT IN
                                     (SELECT lis02 FROM lis_file
                                        WHERE lis03 = '1' AND lis01 = g_lir.lir01)))
            AND lis05 = startdate
            AND lis06 = enddate
            AND lis091 IS NOT NULL
            AND lis092 IS NOT NULL
      END IF
   END IF
   IF NOT cl_null(p_lis091) OR NOT cl_null(p_lis092) OR l_n >0 THEN
      CALL cl_set_comp_required("lis091_4",TRUE)
      CALL cl_set_comp_required("lis092_4",TRUE)
   ELSE
      CALL cl_set_comp_required("lis091_4",FALSE)
      CALL cl_set_comp_required("lis092_4",FALSE)
   END IF
END FUNCTION
#FUN-CA0081-----------add------end
