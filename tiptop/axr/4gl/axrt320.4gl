# Prog. Version..: '5.30.06-13.04.02(00001)'     #
#
# Pattern name...: axrt320.4gl
# Descriptions...: 開票維護作業
# Date & Author..: 13/01/22  By lujh FUN-D10101

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_omg_1         RECORD
                           omg00        LIKE     omg_file.omg00, 
	                       omg01        LIKE     omg_file.omg01,   
	                       omg02        LIKE     omg_file.omg02, 
	                       omg03        LIKE     omg_file.omg03,   
	                       omg04        LIKE     omg_file.omg04, 
	                       omg041       LIKE     omg_file.omg041, 
	                       omg05        LIKE     omg_file.omg05, 
	                       omg051       LIKE     omg_file.omg051,
                           omg06        LIKE     omg_file.omg06, 
	                       omg07        LIKE     omg_file.omg07,
	                       omg08        LIKE     omg_file.omg08,  
	                       omg20_sum    LIKE     omg_file.omg20,
	                       omg20x_sum   LIKE     omg_file.omg20x,
	                       omg20t_sum   LIKE     omg_file.omg20t,
	                       omg22_sum    LIKE     omg_file.omg22,
	                       omg22x_sum   LIKE     omg_file.omg22x,
	                       omg22t_sum   LIKE     omg_file.omg22t,
                           omguser      LIKE     omg_file.omguser,
                           omggrup      LIKE     omg_file.omggrup,
                           omgmodu      LIKE     omg_file.omgmodu,
                           omgdate      LIKE     omg_file.omgdate,
                           omgoriu      LIKE     omg_file.omgoriu,
                           omgorig      LIKE     omg_file.omgorig
	                       END RECORD,
         g_omg_1_t       RECORD 
                           omg00        LIKE     omg_file.omg00, 
	                       omg01        LIKE     omg_file.omg01,   
	                       omg02        LIKE     omg_file.omg02, 
	                       omg03        LIKE     omg_file.omg03,   
	                       omg04        LIKE     omg_file.omg04, 
	                       omg041       LIKE     omg_file.omg041, 
	                       omg05        LIKE     omg_file.omg05, 
	                       omg051       LIKE     omg_file.omg051,
                           omg06        LIKE     omg_file.omg06, 
	                       omg07        LIKE     omg_file.omg07,
	                       omg08        LIKE     omg_file.omg08,  
	                       omg20_sum    LIKE     omg_file.omg20,
	                       omg20x_sum   LIKE     omg_file.omg20x,
	                       omg20t_sum   LIKE     omg_file.omg20t,
	                       omg22_sum    LIKE     omg_file.omg22,
	                       omg22x_sum   LIKE     omg_file.omg22x,
	                       omg22t_sum   LIKE     omg_file.omg22t,
                           omguser      LIKE     omg_file.omguser,
                           omggrup      LIKE     omg_file.omggrup,
                           omgmodu      LIKE     omg_file.omgmodu,
                           omgdate      LIKE     omg_file.omgdate,
                           omgoriu      LIKE     omg_file.omgoriu,
                           omgorig      LIKE     omg_file.omgorig
	                       END RECORD,       
	                                  
         g_omg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                         omg09       LIKE omg_file.omg09,
                         omg10       LIKE omg_file.omg10,
                         omg11       LIKE omg_file.omg11,
                         omg23       LIKE omg_file.omg23,
                         omg12       LIKE omg_file.omg12,
                         omg13       LIKE omg_file.omg13,   
                         omg14       LIKE omg_file.omg14,   
                         omg15       LIKE omg_file.omg15,
                         omg16       LIKE omg_file.omg16,
                         omg17       LIKE omg_file.omg17,  
                         omg18       LIKE omg_file.omg18, 
                         omg21       LIKE omg_file.omg21,  
                         omg22       LIKE omg_file.omg22,
                         omg22x      LIKE omg_file.omg22x, 
                         omg22t      LIKE omg_file.omg22t,
                         omg19       LIKE omg_file.omg19,
                         omg20       LIKE omg_file.omg20,
                         omg20x      LIKE omg_file.omg20x,
                         omg20t      LIKE omg_file.omg20t
                         END RECORD,
       g_omg_t           RECORD                 #程式變數 (舊值)
       	                 omg09       LIKE omg_file.omg09,
                         omg10       LIKE omg_file.omg10,
                         omg11       LIKE omg_file.omg11,
                         omg23       LIKE omg_file.omg23,
                         omg12       LIKE omg_file.omg12,
                         omg13       LIKE omg_file.omg13,   
                         omg14       LIKE omg_file.omg14,   
                         omg15       LIKE omg_file.omg15,
                         omg16       LIKE omg_file.omg16,
                         omg17       LIKE omg_file.omg17,  
                         omg18       LIKE omg_file.omg18, 
                         omg21       LIKE omg_file.omg21,  
                         omg22       LIKE omg_file.omg22,
                         omg22x      LIKE omg_file.omg22x, 
                         omg22t      LIKE omg_file.omg22t,
                         omg19       LIKE omg_file.omg19,
                         omg20       LIKE omg_file.omg20,
                         omg20x      LIKE omg_file.omg20x,
                         omg20t      LIKE omg_file.omg20t
                         END RECORD,
       g_wc,g_sql       string, 
       g_ss             LIKE type_file.chr1, 
       g_rec_b          LIKE type_file.num5, 
       g_argv1              LIKE omg_file.omg00,        #(帳款編號)
       g_argv2              STRING,
       l_ac             LIKE type_file.num5  
DEFINE g_gec05          LIKE gec_file.gec05
DEFINE g_gec07          LIKE gec_file.gec07  
DEFINE g_omb12          LIKE omb_file.omb12 
DEFINE g_omg01_t        LIKE omg_file.omg01
DEFINE g_omg00_t        LIKE omg_file.omg00  
DEFINE g_omg02_t        LIKE omg_file.omg02
DEFINE g_omg17          LIKE omg_file.omg17  
DEFINE g_forupd_sql STRING   #SELECT ... FOR 
DEFINE g_chr           LIKE type_file.chr1   
DEFINE g_cnt           LIKE type_file.num10  
DEFINE g_i             LIKE type_file.num5   
DEFINE g_msg           LIKE ze_file.ze03     
DEFINE g_row_count     LIKE type_file.num10  
DEFINE g_curs_index    LIKE type_file.num10  
DEFINE g_jump          LIKE type_file.num10  
DEFINE g_no_ask        LIKE type_file.num5    
DEFINE g_bp_flag       LIKE type_file.chr10
DEFINE g_rec_b1        LIKE type_file.num10
DEFINE g_str           STRING                
DEFINE g_wc2           STRING                
DEFINE g_buf           STRING                  
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_ogb71              LIKE ogb_file.ogb71 
DEFINE g_t1                 LIKE ooy_file.ooyslip  
DEFINE p_row,p_col          LIKE type_file.num5 

DEFINE g_imgg10_1       LIKE imgg_file.imgg10,
       g_imgg10_2       LIKE imgg_file.imgg10,
       g_auto_con       LIKE type_file.num5,
       g_omg11_str      STRING,   
       g_change         LIKE type_file.chr1,    
       g_ima25          LIKE ima_file.ima25,
       g_ima31          LIKE ima_file.ima31,
       
       g_ima906         LIKE ima_file.ima906,
       g_ima907         LIKE ima_file.ima907,
       g_ima908         LIKE ima_file.ima908,
       g_factor         LIKE img_file.img21,
       g_buf1            LIKE type_file.chr1000,
       g_flag           LIKE type_file.chr1,
       p_cmd            LIKE type_file.chr1,
       l_lock_sw        LIKE type_file.chr1,
       l_n              LIKE type_file.num5,
       g_tot            LIKE type_file.num20_6,
       g_type           LIKE type_file.chr2,
       g_argv3           LIKE oma_file.oma01
       


MAIN
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
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT oaz100,oaz106 INTO g_oaz.oaz100,g_oaz.oaz106 FROM oaz_file 
   
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00 = '0'   

    LET g_forupd_sql = "SELECT omg00,omg01,omg02,omg03,omg04,omg05,omg06,omg07",
                       "  FROM omg_file WHERE omg00=? FOR UPDATE"

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t320_cl CURSOR FROM g_forupd_sql
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_omg_1.* TO NULL
   INITIALIZE g_omg_1_t.* TO NULL
 
   OPEN WINDOW t320_w WITH FORM "axr/42f/axrt320"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("axrt320")  
   CALL cl_ui_init()

    IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg913",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg915",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg910",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg912",g_msg CLIPPED)
   END IF

   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg913",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg915",g_msg CLIPPED)
      CALL cl_getmsg('axm-567',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg910",g_msg CLIPPED)
      CALL cl_getmsg('axm-568',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omg912",g_msg CLIPPED)
   END IF

   IF NOT cl_null(g_argv3) THEN 
      LET g_action_choice = "query"
      IF cl_chk_act_auth() THEN
         CALL t320_q()
      END IF
   END IF 
   IF NOT cl_null(g_argv1) AND g_argv2 = 'q' THEN 
      LET g_action_choice = "query"
      IF cl_chk_act_auth() THEN
         CALL t320_q()
      END IF
   END IF

   CALL t320_menu()
   CLOSE WINDOW t320_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t320_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   CLEAR FORM                             #清除畫面
   CALL g_omg.clear()
   IF NOT cl_null(g_argv3) THEN 
      LET g_wc2 = " omg11 = '",g_argv3,"'"
      LET g_wc  = " 1=1"
   ELSE
      IF NOT cl_null(g_argv1) AND g_argv2 = 'q' THEN 
         LET g_wc = " omg00 ='",g_argv1,"'"
         LET g_wc2 = " 1=1"
      ELSE
         CALL cl_set_head_visible("","YES")           #設定單頭為顯示狀態
         INITIALIZE g_omg_1.* TO NULL  
      
         CONSTRUCT BY NAME g_wc ON omg00,omg03,omg01,omg02,omg04,omg05,omg06,omg07,omg08
                                  ,omguser,omggrup,omgmodu,omgdate,omgoriu,omgorig   
         BEFORE CONSTRUCT      
            CALL cl_qbe_display_condition(lc_qbe_sn)
            INITIALIZE g_omg_1.* TO NULL
 
         ON ACTION controlp
            CASE
                WHEN INFIELD(omg00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_omg"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO  omg00
                  NEXT FIELD omg00

                WHEN INFIELD(omg04)                                                 
                  CALL cl_init_qry_var()                                           
                  LET g_qryparam.form ="q_occ"                                    
                  LET g_qryparam.state = "c"                                                                           
                  CALL cl_create_qry() RETURNING g_qryparam.multiret               
                  DISPLAY g_qryparam.multiret TO  omg04                            
                  NEXT FIELD omg04
               
	            WHEN INFIELD(omg05)
	              CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gec"
	              LET g_qryparam.state = "c"
	              CALL cl_create_qry() RETURNING g_qryparam.multiret
	              DISPLAY g_qryparam.multiret TO omg05
	              NEXT FIELD omg05
	        
	            WHEN INFIELD(omg06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.state = "c"
	              CALL cl_create_qry() RETURNING g_qryparam.multiret
	              DISPLAY g_qryparam.multiret TO omg06
	              NEXT FIELD omg06
	            OTHERWISE EXIT CASE
            END CASE
	       
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
         IF INT_FLAG THEN RETURN END IF              
                  
         CONSTRUCT g_wc2 ON omg09,omg10,omg11,omg23,omg12,omg13,omg14,omg15,omg16,    
                            omg17,omg18,omg21,omg22,omg22x,omg22t,omg19,omg20,omg20x,omg20t
                      FROM  s_omg[1].omg09,s_omg[1].omg10,s_omg[1].omg11,s_omg[1].omg23,
                            s_omg[1].omg12,s_omg[1].omg13,s_omg[1].omg14,s_omg[1].omg15,
                            s_omg[1].omg16,s_omg[1].omg17,s_omg[1].omg18,s_omg[1].omg21,
                            s_omg[1].omg22,s_omg[1].omg22x,s_omg[1].omg22t,s_omg[1].omg19,
                            s_omg[1].omg20,s_omg[1].omg20x,s_omg[1].omg20t
                        
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
      
         ON ACTION CONTROLP
	        CASE
	           WHEN INFIELD(omg11)#出貨單單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_omg11"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omg11
                  NEXT FIELD omg11   
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
            CALL cl_qbe_select()
         
         ON ACTION qbe_save
            CALL cl_qbe_save()
		
        END CONSTRUCT
 
        IF INT_FLAG THEN
           RETURN
        END IF
     END IF 
  END IF 

   LET g_sql= "SELECT UNIQUE omg00,omg01,omg02,omg03,omg04,omg041,omg05,omg051,omg06,omg07,omg08 FROM omg_file ",
              " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
              " ORDER BY 1"
   PREPARE t320_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('t320_prepare',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE t320_b_curs                         
      SCROLL CURSOR WITH HOLD FOR t320_prepare
      	
   LET g_sql="SELECT COUNT(DISTINCT omg00) FROM omg_file WHERE ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED    
   PREPARE t320_precount FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('t320_precount',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE t320_count CURSOR FOR t320_precount
END FUNCTION
 
FUNCTION t320_menu()
   DEFINE l_cmd        LIKE type_file.chr1000 
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE l_oma00      LIKE oma_file.oma00 
 
   WHILE TRUE
      CALL t320_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t320_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t320_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t320_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t320_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t320_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "confirm"
           IF cl_chk_act_auth() THEN
              BEGIN WORK
              LET g_auto_con = 1
              CALL t320_y()
              IF g_success = 'Y' THEN 
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF 
              CALL t320_show()
           END IF
           
         WHEN "undo_confirm"
           IF cl_chk_act_auth() THEN
              BEGIN WORK
              LET g_auto_con = 1
              CALL t320_w()
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
              CALL t320_show()
           END IF

         WHEN "output"
           IF cl_chk_act_auth()  AND NOT cl_null(g_omg_1.omg00) THEN
              LET g_msg = "axmr680",
                          " '",g_omg_1.omg00,"' 'Y'"
                          CALL cl_cmdrun(g_msg)
            END IF   

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_omg),'','')  
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_omg_1.omg00 IS NOT NULL THEN
                 LET g_doc.column1 = "omg00"
                 LET g_doc.value1 = g_omg_1.omg00
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t320_a()
   DEFINE li_result   LIKE type_file.chr1   
   MESSAGE ""
   CLEAR FORM
   CALL g_omg.clear()
   INITIALIZE g_omg_1.* TO NULL

   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
   	      LET g_omg_1.omg03 = g_today       #Default
          LET g_omg_1.omg08 = 'N'           
          LET g_omg_1.omg02 = ' '           
          DISPLAY BY NAME g_omg_1.omg08     
          LET g_omg_1.omguser = g_user
          LET g_omg_1.omgoriu = g_user
          LET g_omg_1.omgorig = g_grup
          LET g_omg_1.omggrup = g_grup
          LET g_omg_1.omgdate = g_today
          DISPLAY BY NAME g_omg_1.omguser,g_omg_1.omgoriu,g_omg_1.omgorig,
                          g_omg_1.omggrup,g_omg_1.omgdate

      CALL t320_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_omg_1.* TO NULL
         DISPLAY BY NAME g_omg_1.* 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_omg_1.omg00) THEN
         CONTINUE WHILE
      END IF
       CALL s_auto_assign_no("axr",g_omg_1.omg00,g_omg_1.omg03,"","omg_file","omg00","","","") RETURNING li_result,g_omg_1.omg00
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_omg_1.omg00
   
      LET g_rec_b = 0
      IF g_ss='N' THEN
         CALL g_omg.clear()
      ELSE
         CALL t320_b_fill('1=1')         #單身
      END IF
      CALL t320_b()                      #輸入單身

      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t320_i(p_cmd)
DEFINE
       p_cmd        LIKE type_file.chr1,        
       l_n          LIKE type_file.num10        
DEFINE lc_prog_name LIKE gaz_file.gaz03                                                                                                
DEFINE i            LIKE type_file.num5                                                                                                
DEFINE l_mm         LIKE type_file.num5
DEFINE l_yy         LIKE type_file.num5  
DEFINE l_cnt        LIKE type_file.num5
   LET g_ss='Y'
 
   CALL cl_set_head_visible("","YES")           

   
  IF p_cmd = 'a' THEN 
     CALL cl_set_comp_required('omg04,omg05,omg06,omg07',TRUE)
  END IF 
  INPUT BY NAME g_omg_1.omg00,g_omg_1.omg03,g_omg_1.omg01,g_omg_1.omg02,g_omg_1.omg04,  
                g_omg_1.omg05,g_omg_1.omg06,g_omg_1.omg07,g_omg_1.omg08  
       WITHOUT DEFAULTS 
      
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t320_set_entry(p_cmd)
         CALL t320_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
     
      AFTER FIELD omg00
         IF (p_cmd = 'a') OR
            (p_cmd = 'u' AND g_omg_1_t.omg00 != g_omg_1.omg00) THEN
            IF NOT cl_null(g_omg_1.omg00) AND NOT cl_null(g_omg_1.omg00) THEN
               CALL t320_ooy_chk(g_omg_1.omg00)
               IF cl_null(g_errno)THEN
                  DISPLAY g_omg_1.omg00 TO omg00 
               ELSE
                  CALL cl_err('',g_errno,0)
                  LET g_omg_1.omg00 = ''
                  NEXT FIELD omg00
               END IF
             END IF  
          END IF
 	
      AFTER FIELD omg01
        IF (p_cmd = 'a') OR
           (p_cmd = 'u' AND g_omg_1_t.omg01 != g_omg_1.omg01) THEN
           IF NOT cl_null(g_omg_1.omg01) AND g_omg_1.omg02 IS NOT NULL THEN  
              SELECT COUNT(*) INTO l_n FROM omg_file
               WHERE omg01 = g_omg_1.omg01
                 AND omg02 = g_omg_1.omg02
              IF l_n > 0  THEN
                 CALL cl_err('',-239,0)
                 LET g_omg_1.omg01 = g_omg_1_t.omg01
                 DISPLAY BY NAME g_omg_1.omg01
                 NEXT FIELD omg01
               END IF
            END IF
        END IF
        IF g_omg_1.omg01 IS NULL THEN LET g_omg_1.omg01 = ' ' END IF        
 
      AFTER FIELD omg02
         IF (p_cmd = 'a') OR
            (p_cmd = 'u' AND g_omg_1_t.omg02 != g_omg_1.omg02) THEN
            IF NOT cl_null(g_omg_1.omg01) AND g_omg_1.omg02 IS NOT NULL THEN  
              SELECT COUNT(*) INTO l_n FROM omg_file
               WHERE omg01 = g_omg_1.omg01
                 AND omg02 = g_omg_1.omg02
              IF l_n > 0  THEN
                 CALL cl_err('',-239,0)
                 LET g_omg_1.omg01 = g_omg_1_t.omg01
                 DISPLAY BY NAME g_omg_1.omg01
                 NEXT FIELD omg01
              END IF
            END IF
        END IF     
        IF g_omg_1.omg02 IS NULL THEN lET g_omg_1.omg02 = ' ' END IF

      AFTER FIELD omg04
          IF NOT t320_chk_omg04(p_cmd) THEN  
              NEXT FIELD CURRENT             
           END IF 

      AFTER FIELD omg05
         IF NOT cl_null(g_omg_1.omg05) THEN
            SELECT gec04 INTO g_omg_1.omg051
              FROM gec_file WHERE gec01 = g_omg_1.omg05 AND gec011='2' 
            IF STATUS THEN
               CALL cl_err3("sel","gec_file",g_omg_1.omg05,"","mfg3044","","",1) 
               NEXT FIELD omg05
            END IF
            DISPLAY BY NAME g_omg_1.omg051
         END IF
        
      AFTER FIELD omg06
         IF NOT cl_null(g_omg_1.omg06) THEN
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omg_1.omg06
            IF STATUS THEN
               CALL cl_err3("sel","azi_file",g_omg_1.omg06,"","aap-002","","",1)  
               NEXT FIELD omg06
            END IF  
            IF p_cmd='a' OR (p_cmd='u' AND
                            (g_omg_1.omg06 <> g_omg_1_t.omg06)  OR
                            (g_omg_1.omg03 <> g_omg_1_t.omg03)) THEN
               CALL s_curr3(g_omg_1.omg06,g_omg_1.omg03,g_ooz.ooz17)
                    RETURNING g_omg_1.omg07
               IF cl_null(g_omg_1.omg07) THEN
                  LET g_omg_1.omg07 = 0
               END IF
               DISPLAY g_omg_1.omg07 TO omg07
            END IF          
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(omg00)
               LET g_t1=s_get_doc_no(g_omg_1.omg00)
               CALL q_ooy( FALSE,FALSE, g_t1,'50','AXR')  RETURNING g_t1
               LET g_omg_1.omg00 = g_t1
               DISPLAY BY NAME g_omg_1.omg00
               NEXT FIELD omg00

            WHEN INFIELD (omg04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_occ"
               LET g_qryparam.default1 = g_omg_1.omg04
               CALL cl_create_qry() RETURNING g_omg_1.omg04
               DISPLAY BY NAME g_omg_1.omg04
               NEXT FIELD omg04

            WHEN INFIELD(omg05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.arg1 ="2"
               LET g_qryparam.default1 = g_omg_1.omg05
               CALL cl_create_qry() RETURNING g_omg_1.omg05
               NEXT FIELD omg05
 
            WHEN INFIELD(omg06)               # CURRENCY
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_omg_1.omg06
               CALL cl_create_qry() RETURNING g_omg_1.omg06
               DISPLAY BY NAME g_omg_1.omg06

            OTHERWISE EXIT CASE
         END CASE
 
         
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 

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

FUNCTION t320_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_omg_1.* TO NULL 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL t320_cs()                       #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_omg_1.omg01 TO NULL
      INITIALIZE g_omg_1.omg02 TO NULL
      RETURN
   END IF
 
   OPEN t320_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_omg_1.omg01 TO NULL
      INITIALIZE g_omg_1.omg02 TO NULL
   ELSE
      OPEN t320_count
      FETCH t320_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t320_fetch('F')            #讀出TEMP第一筆並顯示 
   END IF
 
END FUNCTION
 
FUNCTION t320_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   MESSAGE ""
   CASE p_flag
  
        WHEN 'N' FETCH NEXT     t320_b_curs INTO g_omg_1.omg00
        WHEN 'P' FETCH PREVIOUS t320_b_curs INTO g_omg_1.omg00
        WHEN 'F' FETCH FIRST    t320_b_curs INTO g_omg_1.omg00
        WHEN 'L' FETCH LAST     t320_b_curs INTO g_omg_1.omg00
        WHEN '/'

       IF (NOT g_no_ask) THEN
           CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
           LET INT_FLAG = 0  ######add for prompt bug
           
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
        END IF
        FETCH ABSOLUTE g_jump t320_b_curs INTO g_omg_1.omg00              
        LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_omg_1.omg01,SQLCA.sqlcode,0)
      INITIALIZE g_omg_1.* TO NULL
   ELSE
      
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )

      SELECT UNIQUE omg00,omg01,omg02,omg03,omg04,omg041,omg05,omg051,omg06,omg07,omg08,
                    '','','','','','','','','','','',''
        INTO g_omg_1.*
        FROM omg_file
       WHERE omg00 = g_omg_1.omg00  
      
      SELECT SUM(omg20),SUM(omg20x),SUM(omg20t),SUM(omg22),SUM(omg22x),SUM(omg22t)
       INTO g_omg_1.omg20_sum,g_omg_1.omg20x_sum,g_omg_1.omg20t_sum,g_omg_1.omg22_sum,g_omg_1.omg22x_sum,g_omg_1.omg22t_sum
       FROM omg_file
      WHERE omg00 = g_omg_1.omg00   
      
      LET g_omg_1.omg20_sum  = cl_digcut(g_omg_1.omg20_sum,g_azi04)
      LET g_omg_1.omg20x_sum = cl_digcut(g_omg_1.omg20x_sum,g_azi04)
      LET g_omg_1.omg20t_sum = cl_digcut(g_omg_1.omg20t_sum,g_azi04)
      LET g_omg_1.omg22_sum  = cl_digcut(g_omg_1.omg22_sum,t_azi04)
      LET g_omg_1.omg22x_sum = cl_digcut(g_omg_1.omg22x_sum,t_azi04)
      LET g_omg_1.omg22t_sum = cl_digcut(g_omg_1.omg22t_sum,t_azi04)
      CALL t320_show()
   END IF
 
END FUNCTION
 
FUNCTION t320_show()

   SELECT omguser,omggrup,omgmodu,omgdate,omgoriu,omgorig INTO g_omg_1.omguser,g_omg_1.omggrup,g_omg_1.omgmodu,
     g_omg_1.omgdate,g_omg_1.omgoriu,g_omg_1.omgorig FROM omg_file
    WHERE omg00 = g_omg_1.omg00
   DISPLAY BY NAME g_omg_1.omguser,g_omg_1.omgoriu,g_omg_1.omgorig,
                   g_omg_1.omggrup,g_omg_1.omgdate

   DISPLAY BY NAME g_omg_1.*
   IF cl_null(g_wc2) THEN LET g_wc2 = '1=1' END IF 
   CALL t320_b_fill(g_wc2)                #單身
   CALL cl_show_fld_cont() 
   CALL cl_set_field_pic(g_omg_1.omg08,"","","","","")
END FUNCTION


FUNCTION t320_u()
DEFINE  l_cnt   LIKE type_file.num5     
   IF s_shut(0) THEN RETURN END IF
   IF g_omg_1.omg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_omg_1.omg08 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF 

   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK

   OPEN t320_cl USING g_omg_1.omg00                 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_omg_1.omg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t320_b_curs
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t320_cl INTO g_omg_1.omg00,g_omg_1.omg01,g_omg_1.omg02,g_omg_1.omg03,
                         g_omg_1.omg04,g_omg_1.omg05,g_omg_1.omg06,g_omg_1.omg07,
                         g_omg_1.omg08 
 
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_omg_1.omg01,SQLCA.sqlcode,0)  # 資料被他人LOCK
         CLOSE t320_cl ROLLBACK WORK RETURN
      END IF
   END IF
   LET g_omg_1_t.* = g_omg_1.* 
   CALL t320_show()
   WHILE TRUE
      LET g_omg00_t = g_omg_1.omg00  
      CALL t320_i("u")                                  #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_omg_1.*=g_omg_1_t.*
         CALL t320_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE omg_file SET omg_file.omg00 = g_omg_1.omg00, 
                          omg_file.omg01 = g_omg_1.omg01,
                          omg_file.omg02 = g_omg_1.omg02,
                          omg_file.omg03 = g_omg_1.omg03,
                          omg_file.omg07 = g_omg_1.omg07,
                          omg_file.omgmodu=g_user,
                          omg_file.omgdate=g_today
                    WHERE omg_file.omg00 = g_omg00_t   
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","omg_file",g_omg01_t,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
       ELSE 
          COMMIT WORK
      END IF

      EXIT WHILE
   END WHILE
   CLOSE t320_cl
   COMMIT WORK
END FUNCTION

FUNCTION t320_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_omg_1.omg00 IS NULL THEN  
      CALL cl_err("",-400,0)  
      RETURN
   END IF
   IF g_omg_1.omg08 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
   BEGIN WORK
   OPEN t320_cl USING g_omg_1.omg00              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_omg_1.omg01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t320_cl INTO g_omg_1.omg00,g_omg_1.omg01,g_omg_1.omg02,g_omg_1.omg03,
                         g_omg_1.omg04,g_omg_1.omg05,g_omg_1.omg06,g_omg_1.omg07,
                         g_omg_1.omg08  
      IF SQLCA.sqlcode THEN                                         #資料被他人LOCK
         CALL cl_err(g_omg_1.omg01,SQLCA.sqlcode,0) RETURN END IF
      END IF
      CALL t320_show()          
      IF cl_delh(15,21) THEN                #確認一下
       INITIALIZE g_doc.* TO NULL     
       LET g_doc.column1 = "omg00"       
       LET g_doc.value1 = g_omg_1.omg00 
       CALL cl_del_doc()       
       DELETE FROM omg_file WHERE omg00 = g_omg_1.omg00                           

       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","omg_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)
          ROLLBACK WORK RETURN
       END IF
       IF g_sma.sma115 = 'Y' THEN 
          DELETE FROM ogg_file 
           WHERE ogg01 = g_omg_1.omg00 
          DELETE FROM ogc_file 
           WHERE ogc01 = g_omg_1.omg00
       ELSE 
          DELETE FROM ogc_file 
           WHERE ogc01 = g_omg_1.omg00 
       END IF
       CLEAR FORM                                                  #刪除后要將畫面上數據清空 
       CALL g_omg.clear()
       MESSAGE ""
       FETCH t320_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t320_cl
          CLOSE t320_count
          COMMIT WORK
          RETURN
       END IF
    
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t320_b_curs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t320_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t320_fetch('/')
       END IF
    END IF
   CLOSE t320_cl
   COMMIT WORK

END FUNCTION
 
#單身
FUNCTION t320_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_n1            LIKE type_file.num5,     
    l_omg11         LIKE omg_file.omg11,   
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_cmd           LIKE type_file.chr1000,  
    l_omg           RECORD LIKE omg_file.*,
    l_ogb12         LIKE ogb_file.ogb12,
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,
    l_omg16         LIKE omg_file.omg16   
    DEFINE l_omg19s LIKE omg_file.omg19,
           l_omg19z LIKE omg_file.omg19
    DEFINE li_cnt   LIKE type_file.num5 
    DEFINE l_oha09  LIKE oha_file.oha09 
    DEFINE l_omg17  LIKE omg_file.omg17     #yinhy131119

    DEFINE temp_omg13 STRING
    DEFINE bst base.StringTokenizer
    DEFINE temptext STRING
    DEFINE l_errno LIKE type_file.num10

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_omg_1.omg00) THEN 
       RETURN
    END IF
     SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omg_1.omg06
    IF g_omg_1.omg08 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    SELECT oaz93,oaz95 INTO g_oaz.oaz93,g_oaz.oaz95 FROM oaz_file	
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT omg09,omg10,omg11,omg23,omg12,omg13,omg14,omg15,omg16,",     
                       "       omg17,omg18,omg21,omg22,omg22x,omg22t,omg19,",
                       "       omg20,omg20x,omg20t FROM omg_file",
                       "  WHERE omg00=? AND omg09=? FOR UPDATE "               
                       
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t320_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CALL cl_set_comp_entry('omg18',FALSE) 
    INPUT ARRAY g_omg WITHOUT DEFAULTS FROM s_omg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           LET g_success = 'Y'  
           BEGIN WORK 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_omg_t.* = g_omg[l_ac].*  
              OPEN t320_bcl USING g_omg_1.omg00,g_omg_t.omg09                  
              IF STATUS THEN
                 CALL cl_err("OPEN t320_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t320_bcl INTO g_omg[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_omg_1_t.omg02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                     CALL t320_set_no_entry(p_cmd)  
                 END IF
              END IF
              CALL cl_show_fld_cont() 
           END IF

           LET g_omg_t.* = g_omg[l_ac].* 
      
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'           
           INITIALIZE g_omg[l_ac].* TO NULL  
           LET g_omg[l_ac].omg10 = 1 
           LET g_omg[l_ac].omg17 = 0         
           LET g_omg[l_ac].omg19 = 0
           LET g_omg[l_ac].omg20 = 0
           LET g_omg[l_ac].omg20x = 0
           LET g_omg[l_ac].omg20t = 0
           LET g_omg[l_ac].omg21 = 0
           LET g_omg[l_ac].omg22 = 0
           LET g_omg[l_ac].omg22x = 0
           LET g_omg[l_ac].omg22t = 0
           LET g_omg_1_t.* = g_omg_1.*
           LET g_omg_t.* = g_omg[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()   
           NEXT FIELD omg09 
  
  
       BEFORE FIELD omg09                        #default 序號
           IF g_omg[l_ac].omg09 IS NULL OR g_omg[l_ac].omg09 = 0 THEN
              SELECT max(omg09)+1
                INTO g_omg[l_ac].omg09
                FROM omg_file
                WHERE omg00 = g_omg_1.omg00     
              IF g_omg[l_ac].omg09 IS NULL THEN
                 LET g_omg[l_ac].omg09 = 1
              END IF
           END IF

       AFTER FIELD omg09                        #check 序號是否重複
           IF NOT cl_null(g_omg[l_ac].omg09) THEN
              IF g_omg[l_ac].omg09 != g_omg_t.omg09
                 OR g_omg_t.omg09 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM omg_file
                  WHERE omg00 = g_omg_1.omg00    
                    AND omg09 = g_omg[l_ac].omg09
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_omg[l_ac].omg09 = g_omg_t.omg09
                    NEXT FIELD omg09
                 END IF
              END IF
           END IF
           
        
         AFTER FIELD omg10
            IF NOT cl_null(g_omg[l_ac].omg10) THEN
               
            END IF 
 
         AFTER FIELD omg11

            IF NOT cl_null(g_omg[l_ac].omg11) THEN
               IF p_cmd = 'a' OR
                  (g_omg_t.omg11 != g_omg[l_ac].omg11) THEN
                  IF NOT cl_null(g_omg[l_ac].omg23) THEN 
                     LET l_n = 0 
                     SELECT count(*) INTO l_n FROM omb_file
                      WHERE omb01 = g_omg[l_ac].omg11
                        AND omb03 = g_omg[l_ac].omg23
                     IF l_n = 0 THEN 
                       CALL cl_err('','axr-332',0)
                       NEXT FIELD omg11
                     END IF 
                  END IF 
                  CALL t320_omg11()
                  IF NOT cl_null(g_errno) THEN
                     IF NOT cl_null(g_omg_t.omg11) THEN
                        LET g_omg[l_ac].omg11 = g_omg_t.omg11
                     END IF
                     CALL cl_err(g_omg[l_ac].omg11,g_errno,0) 
                     NEXT FIELD omg11
                  END IF
               END IF
            END IF

        
         AFTER FIELD omg23
            IF NOT cl_null(g_omg[l_ac].omg23) THEN
              IF (p_cmd = 'a') OR
                 (p_cmd = 'u' AND (g_omg_t.omg23 != g_omg[l_ac].omg23 OR g_omg_t.omg11 != g_omg[l_ac].omg11)) THEN  
                 LET l_n = 0 
                 SELECT count(*) INTO l_n FROM omb_file
                  WHERE omb01 = g_omg[l_ac].omg11
                    AND omb03 = g_omg[l_ac].omg23
                 IF l_n = 0 THEN 
                    CALL cl_err('','axr-332',0)
                    NEXT FIELD omg23
                 END IF 
                 CALL t320_omg23()  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_omg[l_ac].omg23,g_errno,0)
                    NEXT FIELD omg23
                 ELSE 
                 END IF      
              END IF 
           END IF
        
        
        AFTER FIELD omg17
           SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omg_1.omg06
           IF cl_null(g_omg[l_ac].omg17) OR g_omg[l_ac].omg17 = 0  THEN 
              NEXT FIELD omg17
           ELSE         
              CALL t320_omg17()
              #No.yinhy131119  --Begin
              IF g_omg[l_ac].omg17 <0 THEN
                 LET l_omg17 = g_omg[l_ac].omg17 * -1
              END IF              
              #IF g_omb12 - g_omg17 < g_omg[l_ac].omg17 THEN 
              IF g_omb12 - g_omg17 < l_omg17  THEN 
              #No.yinhy131119  --End
                 CALL cl_err('','axr-423',0)
                 NEXT FIELD omg17
              END IF 
               LET g_sql = " SELECT gec05,gec07,gec04 FROM  gec_file",
                           "  WHERE gec01='",g_omg_1.omg05,"' ",
                           "    AND gec011 = '2'"           
               PREPARE sel_gec07_pre1 FROM g_sql
               EXECUTE sel_gec07_pre1 INTO g_gec05,g_gec07,g_omg_1.omg051
               IF g_gec07 = 'Y' THEN    #含稅
                  #未稅金額=(含稅單價*數量)/(1+稅率/100)
                  IF g_omg[l_ac].omg17 <> 0 THEN     
                     LET g_omg[l_ac].omg22 = cl_digcut((g_omg[l_ac].omg21*g_omg[l_ac].omg17),t_azi04)/(1+g_omg_1.omg051/100)    
                     LET g_omg[l_ac].omg22t = g_omg[l_ac].omg17 * g_omg[l_ac].omg21
                  END IF
               ELSE                     #不含稅
                  #未稅金額=未稅單價*數量
                  IF g_omg[l_ac].omg17 <> 0 THEN
                     LET g_omg[l_ac].omg22 = g_omg[l_ac].omg17 * g_omg[l_ac].omg21
                     LET g_omg[l_ac].omg22 = cl_digcut(g_omg[l_ac].omg22,t_azi04)
                     LET g_omg[l_ac].omg22t = g_omg[l_ac].omg22 * (1+g_omg_1.omg051/100) 
                  END IF                                            
               END IF
               
               LET g_omg[l_ac].omg22 = cl_digcut(g_omg[l_ac].omg22,t_azi04)
               LET g_omg[l_ac].omg22t = cl_digcut(g_omg[l_ac].omg22t,t_azi04) 
               LET g_omg[l_ac].omg22x = g_omg[l_ac].omg22t -g_omg[l_ac].omg22 #原幣稅額
               LET g_omg[l_ac].omg22x = cl_digcut(g_omg[l_ac].omg22x,t_azi04)      
               LET g_omg[l_ac].omg20 = g_omg[l_ac].omg22 * g_omg_1.omg07
               LET g_omg[l_ac].omg20 = cl_digcut(g_omg[l_ac].omg20,g_azi04)     #本幣
               LET g_omg[l_ac].omg20t = g_omg[l_ac].omg22t * g_omg_1.omg07
               LET g_omg[l_ac].omg20t = cl_digcut(g_omg[l_ac].omg20t,g_azi04)   #本幣
               LET g_omg[l_ac].omg20x = g_omg[l_ac].omg20t - g_omg[l_ac].omg20
               LET g_omg[l_ac].omg20x = cl_digcut(g_omg[l_ac].omg20x,g_azi04)   #本幣
            END IF   

            DISPLAY BY NAME g_omg[l_ac].omg17
            DISPLAY BY NAME g_omg[l_ac].omg19         
            DISPLAY BY NAME g_omg[l_ac].omg20
            DISPLAY BY NAME g_omg[l_ac].omg20x
            DISPLAY BY NAME g_omg[l_ac].omg20t
            DISPLAY BY NAME g_omg[l_ac].omg21
            DISPLAY BY NAME g_omg[l_ac].omg22
            DISPLAY BY NAME g_omg[l_ac].omg22x
            DISPLAY BY NAME g_omg[l_ac].omg22t
           
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF (g_omg[l_ac].omg20 + g_omg[l_ac].omg20x <> g_omg[l_ac].omg20t) OR
              (g_omg[l_ac].omg22 + g_omg[l_ac].omg22x <> g_omg[l_ac].omg22t) THEN
              IF NOT cl_confirm('axr-181') THEN
                 NEXT FIELD omg20
              END IF
           END IF
           LET l_omg.omg00 = g_omg_1.omg00   
           LET l_omg.omg01 = g_omg_1.omg01
           LET l_omg.omg02 = g_omg_1.omg02
           LET l_omg.omg03 = g_omg_1.omg03
           LET l_omg.omg04 = g_omg_1.omg04
           LET l_omg.omg041= g_omg_1.omg041
           LET l_omg.omg05 = g_omg_1.omg05
           LET l_omg.omg051= g_omg_1.omg051
           LET l_omg.omg06 = g_omg_1.omg06
           LET l_omg.omg07 = g_omg_1.omg07
           LET l_omg.omg08 = g_omg_1.omg08
           LET l_omg.omg08 = 'N'
           LET l_omg.omg09 = g_omg[l_ac].omg09
           LET l_omg.omg10 = g_omg[l_ac].omg10
           LET l_omg.omg11 = g_omg[l_ac].omg11
           LET l_omg.omg23 = g_omg[l_ac].omg23
           LET l_omg.omg12 = g_omg[l_ac].omg12
           LET l_omg.omg13 = g_omg[l_ac].omg13  
           LET l_omg.omg14 = g_omg[l_ac].omg14   
           LET l_omg.omg15 = g_omg[l_ac].omg15 
           LET l_omg.omg16 = g_omg[l_ac].omg16
           LET l_omg.omg17 = g_omg[l_ac].omg17
           LET l_omg.omg18 = g_omg[l_ac].omg18
           LET l_omg.omg21 = g_omg[l_ac].omg21
           LET l_omg.omg22 = g_omg[l_ac].omg22
           LET l_omg.omg22x= g_omg[l_ac].omg22x
           LET l_omg.omg22t= g_omg[l_ac].omg22t
           LET l_omg.omg19 = g_omg[l_ac].omg19
           LET l_omg.omg20 = g_omg[l_ac].omg20
           LET l_omg.omg20x= g_omg[l_ac].omg20x
           LET l_omg.omg20t= g_omg[l_ac].omg20t

           IF cl_null(l_omg.omg02) THEN LET l_omg.omg02 = ' ' END IF
           IF cl_null(l_omg.omg17) THEN LET l_omg.omg17=0 END IF
           IF cl_null(l_omg.omg19) THEN LET l_omg.omg19=0 END IF
           IF cl_null(l_omg.omg20) THEN LET l_omg.omg20=0 END IF
           IF cl_null(l_omg.omg20x) THEN LET l_omg.omg20x=0 END IF
           IF cl_null(l_omg.omg20t) THEN LET l_omg.omg20t=0 END IF
           IF cl_null(l_omg.omg21) THEN LET l_omg.omg21=0 END IF
           IF cl_null(l_omg.omg22) THEN LET l_omg.omg22=0 END IF
           IF cl_null(l_omg.omg22x) THEN LET l_omg.omg22x=0 END IF
           IF cl_null(l_omg.omg22t) THEN LET l_omg.omg22t=0 END IF

           LET l_omg.omguser = g_omg_1.omguser
           LET l_omg.omgoriu = g_omg_1.omgoriu
           LET l_omg.omgorig = g_omg_1.omgorig
           LET l_omg.omggrup = g_omg_1.omggrup
           LET l_omg.omgdate = g_omg_1.omgdate

           BEGIN WORK
           IF cl_null(l_omg.omg23) THEN LET l_omg.omg23 = 0 END IF 
           IF cl_null(l_omg.omg01) THEN LET l_omg.omg01 = ' ' END IF 
           INSERT INTO omg_file VALUES(l_omg.*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("ins","omg_file","","",SQLCA.sqlcode,"","",1) 
              LET g_omg[l_ac].* = g_omg_t.*
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
      BEFORE DELETE                          #是否取消單身
         IF NOT cl_null(g_omg_t.omg21) THEN 
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            #FUN-C60036--add--str
            IF g_sma.sma115 = 'Y' THEN 
               DELETE FROM ogg_file 
                WHERE ogg01 = g_omg_1.omg00 AND ogg03 = g_omg_t.omg09
               DELETE FROM ogc_file
                WHERE ogc01 = g_omg_1.omg00 AND ogc03 = g_omg_t.omg09
            ELSE 
               DELETE FROM ogc_file 
                WHERE ogc01 = g_omg_1.omg00 AND ogc03 = g_omg_t.omg09
            END IF 
            DELETE FROM omg_file WHERE omg00 = g_omg_1.omg00
                                   AND omg09 = g_omg_t.omg09
            IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("del","omg_file",g_omg_t.omg11,g_omg_t.omg12,SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               MESSAGE 'DELETE O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
            SELECT SUM(omg20),SUM(omg20x),SUM(omg20t),SUM(omg22),SUM(omg22x),SUM(omg22t)
              INTO g_omg_1.omg20_sum,g_omg_1.omg20x_sum,g_omg_1.omg20t_sum,g_omg_1.omg22_sum,g_omg_1.omg22x_sum,g_omg_1.omg22t_sum
              FROM omg_file
             WHERE omg01 = g_omg_1.omg00   

            LET g_omg_1.omg20_sum = cl_digcut(g_omg_1.omg20_sum,g_azi04)
            LET g_omg_1.omg20x_sum = cl_digcut(g_omg_1.omg20x_sum,g_azi04)
            LET g_omg_1.omg20t_sum = cl_digcut(g_omg_1.omg20t_sum,g_azi04)
            LET g_omg_1.omg22_sum = cl_digcut(g_omg_1.omg22_sum,t_azi04)
            LET g_omg_1.omg22x_sum = cl_digcut(g_omg_1.omg22x_sum,t_azi04)
            LET g_omg_1.omg22t_sum = cl_digcut(g_omg_1.omg22t_sum,t_azi04)


            DISPLAY BY NAME g_omg_1.omg20_sum,g_omg_1.omg20x_sum,g_omg_1.omg20t_sum,g_omg_1.omg22_sum,g_omg_1.omg22x_sum,g_omg_1.omg22t_sum
         END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_omg[l_ac].* = g_omg_t.*
              CLOSE t320_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
           	  CALL cl_err(g_omg[l_ac].omg11,-263,1)
              LET g_omg[l_ac].* = g_omg_t.*
           ELSE
           	  CALL t320_omg11()
           	  IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_omg[l_ac].omg11,g_errno,0) 
                 NEXT FIELD omg11
              END IF
            

                IF (g_omg[l_ac].omg20 + g_omg[l_ac].omg20x <> g_omg[l_ac].omg20t) OR
                   (g_omg[l_ac].omg22 + g_omg[l_ac].omg22x <> g_omg[l_ac].omg22t) THEN
                   IF NOT cl_confirm('axr-181') THEN
                      NEXT FIELD omg20
                   END IF
                END IF
                UPDATE omg_file SET omg09=g_omg[l_ac].omg09,
                                    omg10=g_omg[l_ac].omg10,
                                    omg11=g_omg[l_ac].omg11,
                                    omg23=g_omg[l_ac].omg23,
                                    omg12=g_omg[l_ac].omg12, 
                                    omg13=g_omg[l_ac].omg13,    
                                    omg14=g_omg[l_ac].omg14,    
                                    omg15=g_omg[l_ac].omg15, 
                                    omg16=g_omg[l_ac].omg16,
                                    omg17=g_omg[l_ac].omg17, 
                                    omg18=g_omg[l_ac].omg18, 
                                    omg21=g_omg[l_ac].omg21, 
                                    omg22=g_omg[l_ac].omg22,
                                    omg22x=g_omg[l_ac].omg22x,
                                    omg22t=g_omg[l_ac].omg22t,
                                    omg19=g_omg[l_ac].omg19,
                                    omg20=g_omg[l_ac].omg20,
                                    omg20x=g_omg[l_ac].omg20x,
                                    omg20t=g_omg[l_ac].omg20t,
                                    omgmodu=g_user,
                                    omgdate=g_today
                              WHERE omg00=g_omg_1.omg00   
                                AND omg09 = g_omg_t.omg09
                
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","omg_file","","",SQLCA.sqlcode,"","",1)
                   LET g_omg[l_ac].* = g_omg_t.*
                   ROLLBACK WORK
                   EXIT INPUT
                ELSE
                  MESSAGE 'UPDATE O.K' 
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
                 LET g_omg[l_ac].* = g_omg_t.*
              END IF
              CLOSE t320_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t320_bcl
           COMMIT WORK
           SELECT SUM(omg20),SUM(omg20x),SUM(omg20t),SUM(omg22),SUM(omg22x),SUM(omg22t)
              INTO g_omg_1.omg20_sum,g_omg_1.omg20x_sum,g_omg_1.omg20t_sum,g_omg_1.omg22_sum,g_omg_1.omg22x_sum,g_omg_1.omg22t_sum
              FROM omg_file
             WHERE omg00 = g_omg_1.omg00
           
            LET g_omg_1.omg20_sum = cl_digcut(g_omg_1.omg20_sum,g_azi04)
            LET g_omg_1.omg20x_sum = cl_digcut(g_omg_1.omg20x_sum,g_azi04)
            LET g_omg_1.omg20t_sum = cl_digcut(g_omg_1.omg20t_sum,g_azi04)
            LET g_omg_1.omg22_sum = cl_digcut(g_omg_1.omg22_sum,t_azi04)
            LET g_omg_1.omg22x_sum = cl_digcut(g_omg_1.omg22x_sum,t_azi04)
            LET g_omg_1.omg22t_sum = cl_digcut(g_omg_1.omg22t_sum,t_azi04)
            DISPLAY BY NAME g_omg_1.omg20_sum,g_omg_1.omg20x_sum,g_omg_1.omg20t_sum,g_omg_1.omg22_sum,g_omg_1.omg22x_sum,g_omg_1.omg22t_sum
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(omg11)
              IF cl_null(g_omg_t.omg11) THEN
                 LET g_omg11_str = ''
                 CALL q_omb1(TRUE,TRUE,g_omg_1.omg04,g_omg_1.omg04,g_omg_1.omg05,
                                   g_omg_1.omg06,g_plant,g_omg_1.omg00) RETURNING g_omg11_str,g_omg[l_ac].omg23
                 IF cl_null(g_omg11_str) THEN
                    LET g_omg[l_ac].omg11 = g_omg_t.omg11
                    LET g_omg[l_ac].omg23 = g_omg_t.omg23
                    NEXT FIELD omg11
                 END IF
                 LET g_success = 'Y'
                 LET l_errno = 0 
                 LET bst= base.StringTokenizer.create(g_omg11_str,'|')
                 CALL s_showmsg_init()
                 WHILE bst.hasMoreTokens()
                    LET temptext=bst.nextToken()
                    LET g_omg[l_ac].omg11 = temptext.substring(1,temptext.getIndexOf(",",1)-1)
                    LET g_omg[l_ac].omg23=temptext.substring(temptext.getIndexOf(",",1)+1,temptext.getlength())
                    CALL t320_omg23()
                    LET l_omg.omg00=g_omg_1.omg00                     
                    LET l_omg.omg01=g_omg_1.omg01
                    LET l_omg.omg02=g_omg_1.omg02
                    LET l_omg.omg03=g_omg_1.omg03
                    LET l_omg.omg04=g_omg_1.omg04
                    LET l_omg.omg041=g_omg_1.omg041
                    LET l_omg.omg05=g_omg_1.omg05
                    LET l_omg.omg051=g_omg_1.omg051
                    LET l_omg.omg06=g_omg_1.omg06
                    LET l_omg.omg07=g_omg_1.omg07
                    LET l_omg.omg08=g_omg_1.omg08
                    LET l_omg.omg08='N'
                    LET l_omg.omg09=g_omg[l_ac].omg09
                    LET l_omg.omg10=g_omg[l_ac].omg10
                    LET l_omg.omg11=g_omg[l_ac].omg11
                    LET l_omg.omg23=g_omg[l_ac].omg23 
                    LET l_omg.omg12=g_omg[l_ac].omg12     
                    LET l_omg.omg13=g_omg[l_ac].omg13
                    LET l_omg.omg14=g_omg[l_ac].omg14
                    LET l_omg.omg15=g_omg[l_ac].omg15     
                    LET l_omg.omg16=g_omg[l_ac].omg16
                    LET l_omg.omg17=g_omg[l_ac].omg17
                    LET l_omg.omg18=g_omg[l_ac].omg18
                    LET l_omg.omg21=g_omg[l_ac].omg21
                    LET l_omg.omg22=g_omg[l_ac].omg22
                    LET l_omg.omg22x=g_omg[l_ac].omg22x
                    LET l_omg.omg22t=g_omg[l_ac].omg22t
                    LET l_omg.omg19=g_omg[l_ac].omg19
                    LET l_omg.omg20=g_omg[l_ac].omg20
                    LET l_omg.omg20x=g_omg[l_ac].omg20x
                    LET l_omg.omg20t=g_omg[l_ac].omg20t

                    IF cl_null(l_omg.omg02) THEN LET l_omg.omg02 = ' ' END IF
                    IF cl_null(l_omg.omg17) THEN LET l_omg.omg17=0 END IF
                    IF cl_null(l_omg.omg19) THEN LET l_omg.omg19=0 END IF
                    IF cl_null(l_omg.omg20) THEN LET l_omg.omg20=0 END IF
                    IF cl_null(l_omg.omg20x) THEN LET l_omg.omg20x=0 END IF
                    IF cl_null(l_omg.omg20t) THEN LET l_omg.omg20t=0 END IF
                    IF cl_null(l_omg.omg21) THEN LET l_omg.omg21=0 END IF
                    IF cl_null(l_omg.omg22) THEN LET l_omg.omg22=0 END IF
                    IF cl_null(l_omg.omg22x) THEN LET l_omg.omg22x=0 END IF
                    IF cl_null(l_omg.omg22t) THEN LET l_omg.omg22t=0 END IF
                    LET l_n = 0 
                    SELECT COUNT(*) INTO l_n FROM omg_file
                     WHERE omg00 = l_omg.omg00  AND omg11 = l_omg.omg11
                       AND omg23 = l_omg.omg23
                    IF l_n = 0 THEN 
                    IF cl_null(l_omg.omg01) THEN LET l_omg.omg01 = ' ' END IF 

                    LET l_omg.omguser = g_omg_1.omguser
                    LET l_omg.omgoriu = g_omg_1.omgoriu
                    LET l_omg.omgorig = g_omg_1.omgorig
                    LET l_omg.omggrup = g_omg_1.omggrup
                    LET l_omg.omgdate = g_omg_1.omgdate

                    INSERT INTO omg_file VALUES(l_omg.*)
                    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                       CALL s_errmsg('omg11','',l_omg.omg11,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                    ELSE
                       LET l_errno = l_errno +1
                       LET g_omg[l_ac+1].omg10 = g_omg[l_ac].omg10 
                       LET g_omg[l_ac+1].omg09 = g_omg[l_ac].omg09 +1
                       LET l_ac = l_ac + 1
                    END IF 
                    ELSE
                       CALL s_errmsg('omg11,omg12','',l_omg.omg11 || '/' || l_omg.omg12,'axr-376',1)
                       LET g_success = 'N'
                    END IF 
                 END WHILE
                 CALL s_showmsg()
                 COMMIT WORK
                 IF l_errno = 0 THEN 
                    LET g_omg[l_ac].omg11 = ''
                    LET g_omg[l_ac].omg23 = ''
                    LET g_omg[l_ac].omg11 = g_omg_t.omg11
                    LET g_omg[l_ac].omg23 = g_omg_t.omg23
                    NEXT FIELD omg11
                 ELSE
                    CALL t320_b_fill(" 1=1")
                    CALL t320_b()
                 END IF 
                 EXIT INPUT
              ELSE
                 CALL q_omb1(FALSE,TRUE,g_omg_1.omg04,g_omg_1.omg04,g_omg_1.omg05,
                                   g_omg_1.omg06,g_plant,g_omg_1.omg00) RETURNING g_omg[l_ac].omg11,g_omg[l_ac].omg23
                 IF cl_null(g_omg[l_ac].omg11) THEN 
                    LET g_omg[l_ac].omg11 = g_omg_t.omg11
                    LET g_omg[l_ac].omg23 = g_omg_t.omg23
                 ELSE
                    CALL t320_omg23() 
                 END IF
              END IF    
              DISPLAY BY NAME g_omg[l_ac].omg11
              NEXT FIELD omg11
              OTHERWISE EXIT CASE
            END CASE
      
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(omg02) AND l_ac > 1 THEN
              LET g_omg[l_ac].* = g_omg[l_ac-1].*
              LET g_omg[l_ac].omg11 = 0  
              NEXT FIELD omg02
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

  

    LET li_cnt = 0
    SELECT COUNT(*) INTO li_cnt FROM omg_file
     WHERE omg00 = g_omg_1.omg00
    IF li_cnt > 0 THEN 
       SELECT SUM(omg19) INTO l_omg19s FROM omg_file
        WHERE omg00 = g_omg_1.omg00
       SELECT SUM(omg19) INTO l_omg19z FROM omg_file
        WHERE omg00 = g_omg_1.omg00
       IF cl_null(l_omg19s) THEN LET l_omg19s = 0 END IF
       IF cl_null(l_omg19z) THEN LET l_omg19z = 0 END IF
       IF (l_omg19s + l_omg19z)< 0  THEN
          CALL cl_err('','gap-003',1)
          CALL t320_b() 
       END IF
    END IF 
 
    CLOSE t320_bcl
    COMMIT WORK

 
END FUNCTION
 
 
FUNCTION t320_b_askkey()
DEFINE
    l_wc    STRING   #MOD-8B0084
 
    CONSTRUCT l_wc ON omg09,omg10,omg11,omg23,omg12,omg13,omg14,omg15,omg16,   
                      omg17,omg18,omg21,omg22,omg22t,omg22x,omg19,omg20,omg20t,omg20x
                 FROM s_omg[1].omg09,s_omg[1].omg10,s_omg[1].omg11,s_omg[1].omg23,  
                      s_omg[1].omg12,s_omg[1].omg13,s_omg[1].omg14,s_omg[1].omg15,  
                      s_omg[1].omg16,s_omg[1].omg17,s_omg[1].omg18,s_omg[1].omg21, 
                      s_omg[1].omg22,s_omg[1].omg22t,s_omg[1].omg22x,s_omg[1].omg19,
                      s_omg[1].omg20,s_omg[1].omg20t,s_omg[1].omg20x
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
 
    IF INT_FLAG THEN RETURN END IF
 
    CALL t320_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t320_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc   STRING   
 
   LET g_sql = "SELECT omg09,omg10,omg11,omg23,omg12,omg13,omg14,omg15,omg16,omg17,",
               "       omg18,omg21,omg22,omg22x,omg22t,omg19,omg20,omg20x,omg20t",
               " FROM omg_file ",
               " WHERE omg00 = '",g_omg_1.omg00,"'",  
               "   AND ",p_wc CLIPPED,
               " ORDER BY omg09,omg10,omg11"
   PREPARE t320_prepare2 FROM g_sql      #預備一下
   DECLARE omg_curs CURSOR FOR t320_prepare2
 
   CALL g_omg.clear()
   LET g_cnt = 1
 
   FOREACH omg_curs INTO g_omg[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     
      SELECT ima021 INTO g_omg[g_cnt].omg16 FROM ima_file WHERE ima01=g_omg[g_cnt].omg14     
      IF g_omg[g_cnt].omg13 = 0 THEN
         LET g_omg[g_cnt].omg13 = ' '
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_omg.deleteElement(g_cnt)
   LET g_rec_b =g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt=0
END FUNCTION
 
FUNCTION t320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_omg TO s_omg.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
  
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   

       AFTER DISPLAY
          CONTINUE DIALOG   #因為外層是DIALOG
   END DISPLAY 
  
 
  ON ACTION insert
     LET g_action_choice="insert"

     EXIT DIALOG
  ON ACTION query
     LET g_action_choice="query"

     EXIT DIALOG
  ON ACTION delete
     LET g_action_choice="delete"

     EXIT DIALOG
  ON ACTION first
     CALL t320_fetch('F')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   
     IF g_rec_b != 0 THEN
        CALL fgl_set_arr_curr(1)  
     END IF
     ACCEPT DIALOG
  
  
  ON ACTION previous
     CALL t320_fetch('P')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   
     IF g_rec_b != 0 THEN
        CALL fgl_set_arr_curr(1) 
     END IF
     ACCEPT DIALOG
  
  
  ON ACTION jump
     CALL t320_fetch('/')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   
     IF g_rec_b != 0 THEN
        CALL fgl_set_arr_curr(1)  
     END IF
     ACCEPT DIALOG
  
  
  ON ACTION next
     CALL t320_fetch('N')
     CALL cl_navigator_setting(g_curs_index, g_row_count)  
     IF g_rec_b != 0 THEN
        CALL fgl_set_arr_curr(1)  
     END IF
     ACCEPT DIALOG 
  
  ON ACTION last
     CALL t320_fetch('L')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   
     IF g_rec_b != 0 THEN
        CALL fgl_set_arr_curr(1) 
     END IF
     ACCEPT DIALOG

  ON ACTION modify
     LET g_action_choice="modify"
     EXIT DIALOG
     
  ON ACTION detail
     LET g_action_choice="detail"
     LET l_ac = 1
     EXIT DIALOG
     
  ON ACTION confirm
     LET g_action_choice="confirm"
     EXIT DIALOG
     
  ON ACTION undo_confirm
     LET g_action_choice="undo_confirm"
     EXIT DIALOG

  ON ACTION help
     LET g_action_choice="help"
     EXIT DIALOG
 
  ON ACTION output 
     LET g_action_choice="output"
     EXIT DIALOG

  ON ACTION locale
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   
  
  ON ACTION exit
     LET g_action_choice="exit"
     EXIT DIALOG
  
  ##########################################################################
  # Special 4ad ACTION
  ##########################################################################
  ON ACTION controlg
     LET g_action_choice="controlg"
     EXIT DIALOG
  
  ON ACTION accept
     LET g_action_choice="detail"
     LET l_ac = ARR_CURR()
     LET g_bp_flag = NULL
     EXIT DIALOG
  
  ON ACTION cancel
     LET INT_FLAG=FALSE 		#MOD-570244	mars
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
  
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
 
FUNCTION t320_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("omg00,omg04,omg05,omg06,omg07",TRUE)
   END IF
END FUNCTION
 
FUNCTION t320_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("omg00,omg04,omg05,omg06,omg07,omg22",FALSE)  	  
   END IF
   CALL cl_set_comp_entry("omg20,omg201",FALSE)
END FUNCTION

 
FUNCTION t320_omg11()
   DEFINE l_n       LIKE type_file.num5,   
          l_oma03   LIKE oma_file.oma03,
          l_oma21   LIKE oma_file.oma21,
          l_oma23   LIKE oma_file.oma23,
          l_omaconf LIKE oma_file.omaconf

   LET g_errno = ''
   LET g_sql = "SELECT UNIQUE oma03,oma21,oma23,omaconf FROM oma_file",
               " WHERE oma01 = '",g_omg[l_ac].omg11,"' "                         
   PREPARE sel_omg11_pre FROM g_sql
   EXECUTE sel_omg11_pre INTO l_oma03,l_oma21,l_oma23,l_omaconf 

      CASE
         WHEN SQLCA.SQLCODE = 100         LET g_errno = 'atm-151'
         WHEN l_oma03 != g_omg_1.omg04    LET g_errno = 'aap-040' 
         WHEN l_oma21 != g_omg_1.omg05    LET g_errno = 'axm-142'
         WHEN l_oma23 != g_omg_1.omg06    LET g_errno = 'alm-730'
         WHEN l_omaconf != 'Y'            LET g_errno = 'anm-960'
      END CASE
   
END FUNCTION

FUNCTION t320_omg23()
   DEFINE g_omg11  LIKE omg_file.omg11,
          g_omg23  LIKE omg_file.omg23, 
          g_omg03  LIKE omg_file.omg03
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_gec04  LIKE gec_file.gec04
   DEFINE l_gec05  LIKE gec_file.gec05
   DEFINE l_oga24  LIKE oga_file.oga24
   DEFINE li_cnt   LIKE type_file.num5 
   DEFINE l_oha09  LIKE oha_file.oha09
   DEFINE l_oma00  LIKE oma_file.oma00      #yinhy131119
   DEFINE l_omb38  LIKE omb_file.omb38      #yinhy131119
   
  SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omg_1.omg05
 
   LET g_errno = ''
   
   SELECT COUNT(*) INTO l_cnt FROM omg_file
    WHERE omg00 = g_omg_1.omg00
      AND omg11 = g_omg[l_ac].omg11
      AND omg23 = g_omg[l_ac].omg23
      AND omg09 <>g_omg[l_ac].omg09
   IF l_cnt>0 THEN
      LET g_errno = 'axr-376'
   END IF 
   
   LET g_sql = "SELECT oma00,omb38,omb31,omb32,omb04,omb06,omb12,omb05,omb13,omb14t,oma54x,omb14t,",      #yinhy131119 add oma00,omb38
               "       omb15,omb16,oma56x,omb16t", 
               "  FROM omb_file,oma_file",
               " WHERE oma01 = '",g_omg[l_ac].omg11,"'",              
               "   AND oma01 = omb01"
   #No.yinhy131119  --Begin
   IF NOT cl_null(g_omg[l_ac].omg23) THEN
       LET g_sql = g_sql CLIPPED, "   AND omb03 = '",g_omg[l_ac].omg23,"'"
   END IF
   #No.yinhy131119  --End
   PREPARE sel_oma_pre FROM g_sql
   EXECUTE sel_oma_pre INTO l_oma00,l_omb38,         #yinhy131119
                            g_omg[l_ac].omg12,g_omg[l_ac].omg13,g_omg[l_ac].omg14,
                            g_omg[l_ac].omg15,g_omg[l_ac].omg17,g_omg[l_ac].omg18,
                            g_omg[l_ac].omg21,g_omg[l_ac].omg22,g_omg[l_ac].omg22x,g_omg[l_ac].omg22t,
                            g_omg[l_ac].omg19,g_omg[l_ac].omg20,g_omg[l_ac].omg20x,g_omg[l_ac].omg20t
 
   SELECT ima021 INTO g_omg[l_ac].omg16 FROM ima_file WHERE ima01=g_omg[l_ac].omg14 

   IF cl_null(g_omg[l_ac].omg12) THEN 
      LET g_omg[l_ac].omg12 = ' '
   END IF 
   IF cl_null(g_omg[l_ac].omg13) THEN 
      LET g_omg[l_ac].omg13 = 0 
   END IF 
     
   CALL t320_omg17()
   
   #No.yinhy131119  --Begin
   IF l_oma00 MATCHES '1*' AND l_omb38 = '3' THEN
   	  LET g_omg[l_ac].omg17 = g_omg[l_ac].omg17 + g_omg17
   ELSE
   #No.yinhy131119  --End
     LET g_omg[l_ac].omg17 = g_omg[l_ac].omg17 - g_omg17
   END IF   #No.yinhy131119 
  
   

   IF g_omb12 != g_omg[l_ac].omg17 THEN 
      LET g_sql = " SELECT gec05,gec07,gec04 FROM  gec_file",
                  "  WHERE gec01='",g_omg_1.omg05,"' ",
                  "    AND gec011 = '2'"           
      PREPARE sel_gec07_pre2 FROM g_sql
      EXECUTE sel_gec07_pre2 INTO g_gec05,g_gec07,g_omg_1.omg051
      IF g_gec07 = 'Y' THEN    #含稅
         #未稅金額=(含稅單價*數量)/(1+稅率/100)
         IF g_omg[l_ac].omg17 <> 0 THEN     
            LET g_omg[l_ac].omg22 = cl_digcut((g_omg[l_ac].omg21*g_omg[l_ac].omg17),t_azi04)/(1+g_omg_1.omg051/100)    
            LET g_omg[l_ac].omg22t = g_omg[l_ac].omg17 * g_omg[l_ac].omg21
         END IF
      ELSE                     #不含稅
         #未稅金額=未稅單價*數量
         IF g_omg[l_ac].omg17 <> 0 THEN
            LET g_omg[l_ac].omg22 = g_omg[l_ac].omg17 * g_omg[l_ac].omg21
            LET g_omg[l_ac].omg22 = cl_digcut(g_omg[l_ac].omg22,t_azi04)
            LET g_omg[l_ac].omg22t = g_omg[l_ac].omg22 * (1+g_omg_1.omg051/100) 
         END IF                                            
      END IF
   END IF 
   
   LET g_omg[l_ac].omg19 = g_omg[l_ac].omg21 * g_omg_1.omg07
 
   LET g_omg[l_ac].omg22 = cl_digcut(g_omg[l_ac].omg22,t_azi04)
   LET g_omg[l_ac].omg22t = cl_digcut(g_omg[l_ac].omg22t,t_azi04)   
   LET g_omg[l_ac].omg22x = g_omg[l_ac].omg22t - g_omg[l_ac].omg22  #原幣稅額  
   LET g_omg[l_ac].omg22x = cl_digcut(g_omg[l_ac].omg22x,t_azi04) 
   
   LET g_omg[l_ac].omg20 = g_omg[l_ac].omg22 * g_omg_1.omg07
   LET g_omg[l_ac].omg20 = cl_digcut(g_omg[l_ac].omg20,g_azi04)     #本幣
   LET g_omg[l_ac].omg20t = g_omg[l_ac].omg22t * g_omg_1.omg07
   LET g_omg[l_ac].omg20t = cl_digcut(g_omg[l_ac].omg20t,g_azi04)   #本幣
   LET g_omg[l_ac].omg20x = g_omg[l_ac].omg20t - g_omg[l_ac].omg20
   LET g_omg[l_ac].omg20x = cl_digcut(g_omg[l_ac].omg20x,g_azi04)   #本幣
  #FUN-C60036--mod--end

   #No.yinhy131119  --Begin
   IF l_oma00 MATCHES '2*' THEN
      LET g_omg[l_ac].omg17 = g_omg[l_ac].omg17 * -1
      LET g_omg[l_ac].omg22 = g_omg[l_ac].omg22 * -1
      LET g_omg[l_ac].omg22x = g_omg[l_ac].omg22x * -1
      LET g_omg[l_ac].omg22t = g_omg[l_ac].omg22t * -1
      LET g_omg[l_ac].omg20 = g_omg[l_ac].omg20 * -1
      LET g_omg[l_ac].omg20x = g_omg[l_ac].omg20x * -1
      LET g_omg[l_ac].omg20t = g_omg[l_ac].omg20t * -1      
   END IF
   #No.yinhy131119  --End
   
   DISPLAY BY NAME g_omg[l_ac].omg12
   DISPLAY BY NAME g_omg[l_ac].omg13
   DISPLAY BY NAME g_omg[l_ac].omg14
   DISPLAY BY NAME g_omg[l_ac].omg15
   DISPLAY BY NAME g_omg[l_ac].omg16
   DISPLAY BY NAME g_omg[l_ac].omg17
   DISPLAY BY NAME g_omg[l_ac].omg18
   DISPLAY BY NAME g_omg[l_ac].omg21
   DISPLAY BY NAME g_omg[l_ac].omg22
   DISPLAY BY NAME g_omg[l_ac].omg22x
   DISPLAY BY NAME g_omg[l_ac].omg22t
   DISPLAY BY NAME g_omg[l_ac].omg19
   DISPLAY BY NAME g_omg[l_ac].omg20
   DISPLAY BY NAME g_omg[l_ac].omg20x
   DISPLAY BY NAME g_omg[l_ac].omg20t
   
END FUNCTION


FUNCTION t320_omg17()
   DEFINE l_sql    STRING  

   #SELECT omb12 INTO g_omb12 FROM omb_file             #yinhy131119
   SELECT abs(omb12) INTO g_omb12 FROM omb_file         #yinhy131119
    WHERE omb01 = g_omg[l_ac].omg11
      AND omb03 = g_omg[l_ac].omg23
   
   LET l_sql = " SELECT abs(SUM(omg17)) ",
               "   FROM omg_file ",
               "  WHERE omg00 <>'",g_omg_1.omg00,"'",
               "    AND omg11 = '",g_omg[l_ac].omg11,"'",
               "    AND omg23 = '",g_omg[l_ac].omg23,"'"
   PREPARE t320_pb1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE omg_curs1 CURSOR FOR t320_pb1
   OPEN omg_curs1
   FETCH omg_curs1 INTO g_omg17
   IF cl_null(g_omg17) THEN LET g_omg17 = 0 END IF
END FUNCTION


FUNCTION t320_y() 		
   DEFINE  l_omg    RECORD LIKE omg_file.*,
           l_ogb    RECORD LIKE ogb_file.*,
           l_ohb    RECORD LIKE ohb_file.*
   DEFINE  tot     	      LIKE type_file.num20_6
   DEFINE  l_oma00        LIKE oma_file.oma00       #yinhy131119 
   DEFINE  l_omg20        LIKE omg_file.omg20       #yinhy131119 
   DEFINE  l_omg20x       LIKE omg_file.omg20x      #yinhy131119 
   DEFINE  l_omg20t       LIKE omg_file.omg20t      #yinhy131119 
   DEFINE  l_omg20_1      LIKE omg_file.omg20       #yinhy131119 
   DEFINE  l_omg20x_1     LIKE omg_file.omg20x      #yinhy131119 
   DEFINE  l_omg20t_1     LIKE omg_file.omg20t      #yinhy131119 
   IF g_omg_1.omg00 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_omg_1.omg08='Y' THEN 
      CALL cl_err('','1208',0) 
      RETURN
   END IF
   IF g_omg_1.omg07 = g_aza.aza17 THEN 
      SELECT SUM(omg20),SUM(omg20x),SUM(omg20t),SUM(omg22),SUM(omg22x),SUM(omg22t)
       INTO g_omg_1.omg20_sum,g_omg_1.omg20x_sum,g_omg_1.omg20t_sum,g_omg_1.omg22_sum,g_omg_1.omg22x_sum,g_omg_1.omg22t_sum
       FROM omg_file
      WHERE omg00 = g_omg_1.omg00
      IF g_omg_1.omg20_sum <> g_omg_1.omg22_sum THEN 
         CALL cl_err('','axr-419',0)
         RETURN
      END IF 
      IF g_omg_1.omg20t_sum <> g_omg_1.omg22t_sum THEN 
         CALL cl_err('','axr-419',0)
         RETURN
      END IF
      IF g_omg_1.omg20x_sum <> g_omg_1.omg22x_sum THEN 
         CALL cl_err('','axr-419',0)
         RETURN
      END IF
   END IF 
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   IF STATUS THEN CALL cl_err('omg_curs',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF

   LET g_success='Y'

   FOR l_ac = 1 TO g_rec_b
      #No.yinhy131119  --Begin
       SELECT oma00 INTO l_oma00
         FROM omb_file,oma_file
        WHERE oma01 = g_omg[l_ac].omg11
          AND omb03 = g_omg[l_ac].omg23              
          AND oma01 = omb01
      IF l_oma00 MATCHES '2*' THEN
         IF g_omg[l_ac].omg17 < 0 THEN
            LET g_omg[l_ac].omg17 = g_omg[l_ac].omg17 * -1
         END IF      
         IF g_omg[l_ac].omg20 < 0 THEN
            LET g_omg[l_ac].omg20 = g_omg[l_ac].omg20 * -1
         END IF
         IF g_omg[l_ac].omg20x < 0 THEN
            LET g_omg[l_ac].omg20x = g_omg[l_ac].omg20x * -1
         END IF
         IF g_omg[l_ac].omg20t < 0 THEN
            LET g_omg[l_ac].omg20t = g_omg[l_ac].omg20t * -1
         END IF 
       END IF
      #No.yinhy131119  --End
      UPDATE omb_file SET omb17 = g_omg[l_ac].omg19,
                          omb18 = g_omg[l_ac].omg20,
                          omb18t= g_omg[l_ac].omg20t,
                          omb48 = omb48 + g_omg[l_ac].omg17
                    WHERE omb01 = g_omg[l_ac].omg11
                      AND omb03 = g_omg[l_ac].omg23
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","omb_file",g_omg[l_ac].omg11,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
       END IF
       #No.yinhy131119  --Begin
       SELECT SUM(omg20),SUM(omg20x),SUM(omg20t) INTO l_omg20,l_omg20x,l_omg20t
         FROM omg_file
        WHERE omg11 = g_omg[l_ac].omg11
          AND omg08 = 'Y' 
       IF cl_null(l_omg20) THEN LET l_omg20 = 0 END IF  
       IF cl_null(l_omg20x) THEN LET l_omg20x = 0 END IF  
       IF cl_null(l_omg20t) THEN LET l_omg20t = 0 END IF                
       SELECT SUM(omg20),SUM(omg20x),SUM(omg20t) INTO l_omg20_1,l_omg20x_1,l_omg20t_1
         FROM omg_file
        WHERE omg11 = g_omg[l_ac].omg11
          AND omg00 = g_omg_1.omg00
       IF l_oma00 MATCHES '2*' THEN
          LET l_omg20 = l_omg20 * -1
          LET l_omg20x = l_omg20x * -1
          LET l_omg20t = l_omg20t * -1
          LET l_omg20_1 = l_omg20_1 * -1
          LET l_omg20x_1 = l_omg20x_1 * -1
          LET l_omg20t_1 = l_omg20t_1 * -1
       END IF
       #UPDATE oma_file SET oma59 = oma59  + g_omg[l_ac].omg20,
       #                    oma59x= oma59x + g_omg[l_ac].omg20x,
       #                    oma59t= oma59t + g_omg[l_ac].omg20t,
       #No.yinhy131119  --End
       UPDATE oma_file SET oma59 = l_omg20  + l_omg20_1,
                           oma59x= l_omg20x + l_omg20x_1,
                           oma59t= l_omg20t + l_omg20t_1,
                           oma75 = g_omg_1.omg02,
                           oma10 = g_omg_1.omg01,
                           oma09 = g_omg_1.omg03,
                           oma58 = g_omg_1.omg07         #yinhy131119
                     WHERE oma01 = g_omg[l_ac].omg11 
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","oma_file",g_omg[l_ac].omg11,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
       END IF
   END FOR 

   IF g_success = 'Y' THEN    
      UPDATE omg_file SET omg08 = 'Y',
                          omgmodu=g_user,
                          omgdate=g_today
                    WHERE omg00 = g_omg_1.omg00
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","omg_file",g_omg_1.omg00,'',STATUS,"","upd omg08",1)
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      COMMIT WORK  	          
      LET g_omg_1.omg08 = 'Y'
      DISPLAY BY NAME g_omg_1.omg08
      CALL cl_set_field_pic(g_omg_1.omg08,"","","","","")
   END IF      
END FUNCTION
 
FUNCTION t320_w() 			
   DEFINE  l_omg    RECORD LIKE omg_file.*,
           l_ogb    RECORD LIKE ogb_file.*,
           l_ohb    RECORD LIKE ohb_file.*
   DEFINE  tot     	       LIKE type_file.num20_6
   DEFINE  l_n      LIKE type_file.num5#FUN-C60036 add
   DEFINE l_omg04 LIKE omg_file.omg04 #FUN-C60036 add
   DEFINE l_oma    RECORD LIKE oma_file.*
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_oma00        LIKE oma_file.oma00       #yinhy131119 
   DEFINE l_omg01        LIKE omg_file.omg01       #yinhy131119
   DEFINE l_omg02        LIKE omg_file.omg02       #yinhy131119
   DEFINE l_omg03        LIKE omg_file.omg03       #yinhy131119
   DEFINE l_cnt1          LIKE type_file.num5      #yinhy131119

   SELECT oaz93,oaz92,oaz100,oaz106 INTO g_oaz.oaz93,g_oaz.oaz92,g_oaz.oaz100,g_oaz.oaz106
     FROM oaz_file
   IF g_omg_1.omg08='N' THEN 
      IF cl_null(g_omg_1.omg00) THEN 
         CALL cl_err('','-400',0)
      ELSE
         CALL cl_err('','9025',0)
      END IF 
      RETURN
   END IF
   
   IF NOT cl_confirm('8882') THEN RETURN END IF

   LET g_success='Y'

   FOR l_ac = 1 TO g_rec_b
      #No.yinhy131119  --Begin
       SELECT oma00 INTO l_oma00
         FROM omb_file,oma_file
        WHERE oma01 = g_omg[l_ac].omg11
          AND omb03 = g_omg[l_ac].omg23              
          AND oma01 = omb01
      IF l_oma00 MATCHES '2*' THEN
         IF g_omg[l_ac].omg17 < 0 THEN
            LET g_omg[l_ac].omg17 = g_omg[l_ac].omg17 * -1
         END IF      
         IF g_omg[l_ac].omg20 < 0 THEN
            LET g_omg[l_ac].omg20 = g_omg[l_ac].omg20 * -1
         END IF
         IF g_omg[l_ac].omg20x < 0 THEN
            LET g_omg[l_ac].omg20x = g_omg[l_ac].omg20x * -1
         END IF
         IF g_omg[l_ac].omg20t < 0 THEN
            LET g_omg[l_ac].omg20t = g_omg[l_ac].omg20t * -1
         END IF 
       END IF
      #No.yinhy131119  --End
      UPDATE omb_file SET omb48 = omb48 - g_omg[l_ac].omg17
                    WHERE omb01 = g_omg[l_ac].omg11
                      AND omb03 = g_omg[l_ac].omg23
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","omb_file",g_omg[l_ac].omg11,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
       END IF
       #No.yinhy131119  --Begin
       SELECT COUNT(*) INTO l_cnt1 FROM omg_file
        WHERE omg11 = g_omg[l_ac].omg11
          AND omg00 <> g_omg_1.omg00
          AND omg08 = 'Y'
       IF l_cnt1 = 0 THEN
          UPDATE oma_file SET oma59 = oma56,
                              oma59x= oma56x,
                              oma59t= oma56t,
                              oma58 = oma24,
                              oma10 = '',
                              oma05 = '',
                              oma09 = ''
                        WHERE oma01 = g_omg[l_ac].omg11 
       ELSE

          SELECT omg01,omg02,l_omg03 INTO l_omg01,l_omg02,l_omg03 FROM omg_file 
           WHERE omg11 = g_omg[l_ac].omg11 
           ORDER BY omg03 DESC
       #No.yinhy131119  --End
          UPDATE oma_file SET oma59 = oma59  - g_omg[l_ac].omg20,
                              oma59x= oma59x - g_omg[l_ac].omg20x,
                              oma59t= oma59t - g_omg[l_ac].omg20t,
                              #oma09 = g_omg_1.omg03                   #No.yinhy131119    
                              oma10 = l_omg01,                         #No.yinhy131119 
                              oma05 = l_omg02,                         #No.yinhy131119 
                              oma09 = l_omg03                          #No.yinhy131119 
                        WHERE oma01 = g_omg[l_ac].omg11
       END IF  #yinhy131119 
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","oma_file",g_omg[l_ac].omg11,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
       END IF
   END FOR 
   
   IF g_success = 'Y' THEN   
      UPDATE omg_file SET omg08 = 'N',
                          omgmodu=g_user,
                          omgdate=g_today
                    WHERE omg00 = g_omg_1.omg00
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","omg_file",g_omg_1.omg00,'',STATUS,"","upd omg08",1)
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      COMMIT WORK   	 
      LET g_omg_1.omg08 = 'N'
      DISPLAY BY NAME g_omg_1.omg08
      CALL cl_set_field_pic(g_omg_1.omg08,"","","","","")
      CALL t320_show()
   END IF      	
END FUNCTION

FUNCTION t320_ooy_chk(p_omg00)
   DEFINE p_omg00   LIKE omg_file.omg00
   DEFINE l_ooyacti LIKE ooy_file.ooyacti
   DEFINE l_ooytype LIKE ooy_file.ooytype
   DEFINE l_ooyslip LIKE ooy_file.ooyslip

   LET g_errno = ''
   SELECT ooyslip,ooyacti,ooytype INTO l_ooyslip,l_ooyacti,l_ooytype
     FROM ooy_file
    WHERE ooyslip = p_omg00

   CASE 
      WHEN SQLCA.sqlcode=100
         LET g_errno='aap-010'
      WHEN l_ooyacti='N'
         LET g_errno='agl-530'
      WHEN l_ooytype <> '50'
         LET g_errno='aap-009'
      OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION 

FUNCTION t320_chk_omg04(p_cmd)
   DEFINE l_occ              RECORD LIKE occ_file.*
   DEFINE p_cmd              LIKE type_file.chr1
   DEFINE l_buf              LIKE omg_file.omg051
   
   IF NOT cl_null(g_omg_1.omg04) THEN     
      IF g_aza.aza50 = 'Y' THEN  
         SELECT * INTO l_occ.* FROM occ_file
          WHERE occ01 = g_omg_1.omg04    
            AND occ1004 ='1'     
            AND occ06 ='1'       
            AND occacti='Y'
         IF SQLCA.sqlcode=100 THEN
            CALL cl_err3("sel","occ_file",g_omg_1.omg04,"","anm-045","","select occ",1)  
            RETURN FALSE  
         ELSE
            IF g_azw.azw04='2' THEN
               IF l_occ.occ930 = g_plant THEN
                  CALL cl_err('','art-444',0)
                  RETURN FALSE
               END IF
            END IF
            IF l_occ.occ1004!='1' THEN    
               CALL cl_err('select occ','atm-073',0)
               RETURN FALSE
            ELSE
               IF l_occ.occ06!='1' THEN
                  CALL cl_err('select occ','atm-072',0)
                  RETURN FALSE
               END IF
            END IF
         END IF
      ELSE
         SELECT * INTO l_occ.* FROM occ_file
          WHERE occ01 = g_omg_1.omg04
            AND occ1004 ='1'
            AND occacti ='Y'
         IF SQLCA.sqlcode=100 THEN
            CALL cl_err3("sel","occ_file",g_omg_1.omg04,"","anm-045","","select occ",1)
            RETURN FALSE 
         END IF
      END IF
    END IF
    SELECT occ02 INTO l_buf FROM occ_file
     WHERE occ01 = g_omg_1.omg04
       AND occacti = 'Y'
    IF STATUS THEN
       LET l_buf =''
    END IF
    LET g_omg_1.omg041 = l_buf
    DISPLAY g_omg_1.omg041  TO omg041

    LET g_omg_1.omg06 = l_occ.occ42
    LET g_omg_1.omg05 = l_occ.occ41
    SELECT gec04 INTO g_omg_1.omg051
      FROM gec_file WHERE gec01 = g_omg_1.omg05 AND gec011='2'
    IF cl_null(g_omg_1.omg051) THEN
       LET g_omg_1.omg051 = 0
    END IF 
    CALL s_curr3(g_omg_1.omg06,g_omg_1.omg03,g_ooz.ooz17) RETURNING  g_omg_1.omg07
    DISPLAY BY NAME g_omg_1.omg06,g_omg_1.omg05,g_omg_1.omg051,g_omg_1.omg07
    RETURN TRUE
END FUNCTION
#FUN-D10101 add end

