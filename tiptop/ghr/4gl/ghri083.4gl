# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri083
# Descriptions...: 员工定调薪管理
# Date & Author..: 13/06/25 jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   
         g_hrdpa          DYNAMIC ARRAY OF RECORD                  
            hrdpa02         LIKE hrdpa_file.hrdpa02,
            hrdpa03_a       LIKE hrdpa_file.hrdpa03,
            hrdpa04_a       LIKE hrdpa_file.hrdpa04,
            hrdpa05_a       LIKE hrdpa_file.hrdpa05,
            hrdpa06         LIKE hrdpa_file.hrdpa06,
            hrdpa07         LIKE hrdpa_file.hrdpa07,
            hrdpa03         LIKE hrdpa_file.hrdpa03,
            hrdpa03_name    LIKE type_file.chr200,
            hrdpa04         LIKE hrdpa_file.hrdpa04,
            hrdpa04_name    LIKE type_file.chr200,
            hrcyb06         LIKE hrcyb_file.hrcyb06,
            hrcyb07         LIKE hrcyb_file.hrcyb07,
            hrcyb08         LIKE hrcyb_file.hrcyb08,
            hrdpa05         LIKE hrdpa_file.hrdpa05,
            hrdpa08         LIKE hrdpa_file.hrdpa08           
                          END RECORD, 
         g_hrdpa_t        RECORD                  
            hrdpa02         LIKE hrdpa_file.hrdpa02,
            hrdpa03_a       LIKE hrdpa_file.hrdpa03,
            hrdpa04_a       LIKE hrdpa_file.hrdpa04,
            hrdpa05_a       LIKE hrdpa_file.hrdpa05,
            hrdpa06         LIKE hrdpa_file.hrdpa06,
            hrdpa07         LIKE hrdpa_file.hrdpa07,
            hrdpa03         LIKE hrdpa_file.hrdpa03,
            hrdpa03_name    LIKE type_file.chr200,
            hrdpa04         LIKE hrdpa_file.hrdpa04,
            hrdpa04_name    LIKE type_file.chr200,
            hrcyb06         LIKE hrcyb_file.hrcyb06,
            hrcyb07         LIKE hrcyb_file.hrcyb07,
            hrcyb08         LIKE hrcyb_file.hrcyb08,
            hrdpa05         LIKE hrdpa_file.hrdpa05,
            hrdpa08         LIKE hrdpa_file.hrdpa08           
                         END RECORD,    
         g_hrdpb         DYNAMIC ARRAY OF RECORD                  
            hrdpb02         LIKE hrdpb_file.hrdpb02,
            hrdpb03_a       LIKE hrdpb_file.hrdpb03,
            hrdpb04_a       LIKE hrdpb_file.hrdpb04,
            hrdpb03         LIKE hrdpb_file.hrdpb03,
            hrdpb04         LIKE hrdpb_file.hrdpb04,
            hrdpb05         LIKE hrdpb_file.hrdpb05,
            hrdpb06         LIKE hrdpb_file.hrdpb06         
                         END RECORD,   
         g_hrdpb_t       RECORD                  
            hrdpb02         LIKE hrdpb_file.hrdpb02,
            hrdpb03_a       LIKE hrdpb_file.hrdpb03,
            hrdpb04_a       LIKE hrdpb_file.hrdpb04,
            hrdpb03         LIKE hrdpb_file.hrdpb03,
            hrdpb04         LIKE hrdpb_file.hrdpb04,
            hrdpb05         LIKE hrdpb_file.hrdpb05,
            hrdpb06         LIKE hrdpb_file.hrdpb06         
                          END RECORD, 
         g_hrdpc          DYNAMIC ARRAY OF RECORD                  
            hrdpc02         LIKE hrdpc_file.hrdpc02,
            hrdpc03_a       LIKE hrdpc_file.hrdpc03,
            hrdpc04_a       LIKE hrdpc_file.hrdpc04,
            hrdpc05_a       LIKE hrdpc_file.hrdpc05,
            hrdpc06         LIKE hrdpc_file.hrdpc06,
            hrdpc07         LIKE hrdpc_file.hrdpc07,
            hrdpc03         LIKE hrdpc_file.hrdpc03,
            hrdpc03_name    LIKE type_file.chr200,
            hrdpc04         LIKE hrdpc_file.hrdpc04,
            hrdpc05         LIKE hrdpc_file.hrdpc05,
            hrdpc08         LIKE hrdpc_file.hrdpc08           
                          END RECORD,
          g_hrdpc_t       RECORD                  
            hrdpc02         LIKE hrdpc_file.hrdpc02,
            hrdpc03_a       LIKE hrdpc_file.hrdpc03,
            hrdpc04_a       LIKE hrdpc_file.hrdpc04,
            hrdpc05_a       LIKE hrdpc_file.hrdpc05,
            hrdpc06         LIKE hrdpc_file.hrdpc06,
            hrdpc07         LIKE hrdpc_file.hrdpc07,
            hrdpc03         LIKE hrdpc_file.hrdpc03,
            hrdpc03_name    LIKE type_file.chr200,
            hrdpc04         LIKE hrdpc_file.hrdpc04,
            hrdpc05         LIKE hrdpc_file.hrdpc05,
            hrdpc08         LIKE hrdpc_file.hrdpc08           
                          END RECORD, 
          g_hrdpp         DYNAMIC ARRAY OF RECORD 
            hrdp02          LIKE hrdp_file.hrdp02,
            hrdp03          LIKE hrdp_file.hrdp03,
            hrdp04          LIKE hrdp_file.hrdp04,
            hrat02          LIKE hrat_file.hrat02,
            hrao02          LIKE hrao_file.hrao02,
            hras04          LIKE hras_file.hras04,
            hrdp06          LIKE hrdp_file.hrdp06,
            hrdp07          LIKE hrdp_file.hrdp07,     #add by zhangbo130910
            hrdp09          LIKE hrdp_file.hrdp09,     #add by zhangbo130910
            hrdp08          LIKE hrdp_file.hrdp08
                          END record
DEFINE g_hrdp               RECORD LIKE hrdp_file.*
DEFINE g_hrdpt              RECORD LIKE hrdp_file.*
DEFINE g_hratid             LIKE hrat_file.hratid
DEFINE g_hrdp_t             RECORD LIKE hrdp_file.*
DEFINE g_rec_b1             LIKE type_file.num5,  
       g_rec_b2             LIKE type_file.num5,
       g_rec_b3             LIKE type_file.num5,
       g_rec_b4             LIKE type_file.num5,
       l_ac1                LIKE type_file.num5,
       l_ac2                LIKE type_file.num5,
       l_ac3                LIKE type_file.num5,
       l_ac4                LIKE type_file.num5  
DEFINE g_wc                 STRING 
DEFINE g_flag_b             LIKE type_file.chr1
DEFINE g_sql                STRING
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE  SQL        #No.FUN-680102
DEFINE g_before_input_done  LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680102 SMALLINT
DEFINE g_chr                LIKE hrdp_file.hrdpacti        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i                  LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count          LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump               LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE l_name               STRING
DEFINE l_items              STRING 
DEFINE g_sum1               LIKE hrdpa_file.hrdpa05
DEFINE g_sum2               LIKE hrdpb_file.hrdpb03
DEFINE g_sum3               LIKE hrdpc_file.hrdpc05
DEFINE g_sr                 LIKE type_file.num5
#add by zhuzw 20150120 start
DEFINE          g_hrdpa_h          DYNAMIC ARRAY OF RECORD
            hrdp02          LIKE hrdp_file.hrdp02,                  
            hrdpa02         LIKE hrdpa_file.hrdpa02,
            hrdpa06         LIKE hrdpa_file.hrdpa06,
            hrdpa07         LIKE hrdpa_file.hrdpa07,
            hrdpa03         LIKE hrdpa_file.hrdpa03,
            hrdpa03_name    LIKE type_file.chr200,
            hrdpa04         LIKE hrdpa_file.hrdpa04,
            hrdpa04_name    LIKE type_file.chr200,
            hrdpa05         LIKE hrdpa_file.hrdpa05,
            hrdpa08         LIKE hrdpa_file.hrdpa08           
                          END RECORD, 
         g_hrdpb_g         DYNAMIC ARRAY OF RECORD 
            hrdp02          LIKE hrdp_file.hrdp02,                 
            hrdpb02         LIKE hrdpb_file.hrdpb02,
            hrdpb03         LIKE hrdpb_file.hrdpb03,
            hrdpb04         LIKE hrdpb_file.hrdpb04,
            hrdpb05         LIKE hrdpb_file.hrdpb05,
            hrdpb06         LIKE hrdpb_file.hrdpb06         
                         END RECORD,  
         g_hrdpc_k          DYNAMIC ARRAY OF RECORD                  
            hrdp02          LIKE hrdp_file.hrdp02,
            hrdpc02         LIKE hrdpc_file.hrdpc02,
            hrdpc03         LIKE hrdpc_file.hrdpc03,
            hrdpc04         LIKE hrdpc_file.hrdpc04,
            hrdpc05         LIKE hrdpc_file.hrdpc05,
            hrdpc06         LIKE hrdpc_file.hrdpc06,
            hrdpc07         LIKE hrdpc_file.hrdpc07,
            hrdpc08         LIKE hrdpc_file.hrdpc08           
                          END RECORD
DEFINE g_rec_b_g,g_rec_b_h,g_rec_b_k             LIKE type_file.num5                        
#add by zhuzw 20150120 end 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                                      #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   INITIALIZE g_hrdp.* TO NULL
   INITIALIZE g_hrdpt.* TO NULL
   
   LET g_forupd_sql = "SELECT * FROM hrdp_file WHERE hrdp01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i083_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR


   OPEN WINDOW i083_w WITH FORM "ghr/42f/ghri083"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL cl_set_comp_visible("hrdpa03_a,hrdpa04_a,hrdpa05_a",FALSE)
   CALL cl_set_comp_visible("hrdpb03_a,hrdpb04_a",FALSE)
   CALL cl_set_comp_visible("hrdpc03_a,hrdpc04_a,hrdpc05_a",FALSE)
   CALL cl_set_combo_items("hrdp03",NULL,NULL)
   CALL cl_set_combo_items("hrdp03_1",NULL,NULL)      #add by zhangbo130910
   CALL cl_set_combo_items("hrdp09",NULL,NULL)
   CALL cl_set_combo_items("hrdp09_1",NULL,NULL)      #add by zhangbo130910
   CALL cl_set_combo_items("hrdpa02",NULL,NULL)
   CALL cl_set_combo_items("hrdpb02",NULL,NULL)
   CALL cl_set_combo_items("hrdpc02",NULL,NULL)
   CALL cl_set_combo_items("hrdpc04",NULL,NULL)
   CALL i083_get_items('629') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdp03",l_name,l_items)
   CALL cl_set_combo_items("hrdp03_1",l_name,l_items) #add by zhangbo130910   
   CALL i083_get_items('103') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdp09",l_name,l_items)
   CALL cl_set_combo_items("hrdp09_1",l_name,l_items)   #add by zhangbo130910
   CALL i083_get_hrdpa02() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdpa02",l_name,l_items)
   CALL i083_get_hrdpb02() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdpb02",l_name,l_items)
   CALL i083_get_hrdpc02() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdpc02",l_name,l_items)
   CALL i083_get_items('648') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdpc04",l_name,l_items)
   
   CALL i083_menu()
   
   CLOSE WINDOW i083_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i083_cs()

    CLEAR FORM
    INITIALIZE g_hrdp.* TO NULL
    INITIALIZE g_hrdpt.* TO NULL    
    CALL g_hrdpa.clear()
    CALL g_hrdpb.clear()
    CALL g_hrdpc.clear()
    CALL g_hrdpp.clear()
    CONSTRUCT BY NAME g_wc ON hrdp04,hrdp07,hrdp09,hrdp05,hrdp03,hrdpud13
       BEFORE CONSTRUCT
         CALL cl_qbe_init()

       ON ACTION controlp
          CASE
            WHEN INFIELD(hrdp04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrdp04
              NEXT FIELD hrdp04
              #add by zhuzw 20150122 start
            WHEN INFIELD(hrdp05)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '657'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrdp05
              NEXT FIELD hrdp05
              #add by zhuzw 20140122 end 
            OTHERWISE
              EXIT CASE
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

    #資料權限的檢查
#    LET g_wc = cl_replace_str(g_wc,"hrdp04","hrat01")
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdpuser', 'hrdpgrup')
    LET g_wc = cl_replace_str(g_wc,"hrdp04","hrat01")
    LET g_sql="SELECT hrdp01 FROM hrdp_file LEFT OUTER JOIN hrat_file ON hratid=hrdp04",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY hrdp04"
    PREPARE i083_prepare FROM g_sql
    DECLARE i083_cs SCROLL CURSOR WITH HOLD FOR i083_prepare
  #  LET g_sql="SELECT COUNT(*) FROM hrdp_file",
LET g_sql="SELECT COUNT(*)  FROM hrdp_file LEFT OUTER JOIN hrat_file ON hratid=hrdp04",
              " WHERE ",g_wc CLIPPED
    PREPARE i083_precount FROM g_sql
    DECLARE i083_count CURSOR FOR i083_precount
END FUNCTION

FUNCTION i083_get_items(p_hrag01)
DEFINE p_hrag01 LIKE  hrag_file.hrag01
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE p_hrag06 LIKE  hrag_file.hrag06
DEFINE p_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i083_get_items_pre FROM l_sql
       DECLARE i083_get_items CURSOR FOR i083_get_items_pre
       FOREACH i083_get_items INTO p_hrag06,p_hrag07
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=p_hrag06
            LET p_items=p_hrag07
          ELSE
            LET p_name=p_name CLIPPED,",",p_hrag06 CLIPPED
            LET p_items=p_items CLIPPED,",",p_hrag07 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION

FUNCTION i083_get_hrdpa02()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrcy01 LIKE hrcy_file.hrcy01
DEFINE l_hrcy02 LIKE hrcy_file.hrcy02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrcy01,hrcy02 FROM hrcy_file ",
                 "  ORDER BY hrcy01"
       PREPARE i083_get_p1 FROM l_sql
       DECLARE i083_get_c1 CURSOR FOR i083_get_p1
       FOREACH i083_get_c1 INTO l_hrcy01,l_hrcy02
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrcy01
            LET p_items=l_hrcy02
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrcy01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrcy02 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION

FUNCTION i083_get_hrdpb02()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
#DEFINE l_hrdh01 LIKE hrdh_file.hrdh01     #mark by zhangbo130905
DEFINE l_hrdh01  LIKE hrdpb_file.hrdpb02   #add by zhangbo130905
DEFINE l_hrdh06 LIKE hrdh_file.hrdh06

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrdh01,hrdh06 FROM hrdh_file ",
                 "  WHERE hrdh02='002' AND hrdh03='004' ",   #add by zhangbo130910
                 "  ORDER BY NLSSORT(hrdh06,'NLS_SORT = SCHINESE_PINYIN_M') "
       PREPARE i083_get_p4 FROM l_sql
       DECLARE i083_get_c4 CURSOR FOR i083_get_p4
       FOREACH i083_get_c4 INTO l_hrdh01,l_hrdh06
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrdh01
            LET p_items=l_hrdh06
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrdh01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrdh06 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION

FUNCTION i083_get_hrdpc02()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrde01 LIKE hrde_file.hrde01
DEFINE l_hrde02 LIKE hrde_file.hrde02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT DISTINCT hrde01,hrde02 FROM hrde_file ",
                 "  ORDER BY hrde01"
       PREPARE i083_get_p5 FROM l_sql
       DECLARE i083_get_c5 CURSOR FOR i083_get_p5
       FOREACH i083_get_c5 INTO l_hrde01,l_hrde02
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrde01
            LET p_items=l_hrde02
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrde01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrde02 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION

FUNCTION i083_menu()

   WHILE TRUE
      CASE g_flag_b
         WHEN '2'
           CALL i083_bp2("G")
         WHEN '3'
           CALL i083_bp3("G")
         #add by zhuzw 20150120 start  
         WHEN '4'
           CALL i083_bp4("G")
         WHEN '5'
           CALL i083_bp5("G")
         WHEN '6'
           CALL i083_bp6("G")  
         #add by zhuzw 20150120 end                                  
         OTHERWISE
           CALL i083_bp1("G")
           
      END CASE 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i083_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i083_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE g_flag_b
                  WHEN '2'
                     CALL i083_b2()
                     CALL i083_b_fill2()
                  WHEN '3'
                     CALL i083_b3()
                     CALL i083_b_fill3()
             #     OTHERWISE #mark by zhuzw 20150120
                  WHEN '1' #add by zhuzw 20150120
                     CALL i083_b1()
                     CALL i083_b_fill1()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i083_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i083_r()
            END IF
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_hrdp.hrdp04 IS NOT NULL THEN
                  LET g_doc.column1 = "hrdp01"
                  LET g_doc.value1 = g_hrdp.hrdp01
                  CALL cl_doc()
               END IF
            END IF 
         WHEN "import"
            IF cl_chk_act_auth() THEN
                 CALL i083_import()
            END IF
       #  WHEN "import1"             #宽带薪资
       #     IF cl_chk_act_auth() THEN
       #          #CALL i083_import1()
       #     END IF
       #  WHEN "import2"             #稳定薪资
       #     IF cl_chk_act_auth() THEN
       #          #CALL i083_import2()
       #     END IF
       #   WHEN "import3"            #等级薪资
       #     IF cl_chk_act_auth() THEN
       #          #CALL i083_import3()
       #     END IF
         WHEN "item_list"
            IF cl_chk_act_auth() THEN
               CALL i083_list_fill()
            END IF 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i083_confirm()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i083_undo_confirm()
            END IF
#         WHEN "copyin"
#            IF cl_chk_act_auth() THEN
#               CALL i083_copy()
#            END IF
         WHEN "help"
            CALL cl_show_help()            
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i083_bp1(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdpa TO s_hrdpa.* ATTRIBUTE(COUNT=g_rec_b1)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index,g_row_count )
                 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
                 
      ON ACTION first
         CALL i083_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i083_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i083_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i083_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i083_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#
#      ON ACTION copyin
#         LET g_action_choice="copyin"
#         EXIT DISPLAY
         
      ON ACTION detail
         LET l_ac1=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac1=1
         LET g_action_choice="detail"
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

      ON ACTION page04
         LET g_flag_b='2'
         EXIT DISPLAY

      ON ACTION page05
         LET g_flag_b='3'
         EXIT DISPLAY 
      ON ACTION p1
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p2
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p3
         LET g_flag_b='5'
         EXIT DISPLAY 
      ON ACTION p4
         LET g_flag_b='6'
         EXIT DISPLAY                            
      ON ACTION page03
         LET g_flag_b='1'
         EXIT DISPLAY
      ON ACTION main
         LET g_flag_b='1'
         EXIT DISPLAY 
      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY
    #  ON ACTION import1
    #     LET g_action_choice="import1"
    #     EXIT DISPLAY
    #  ON ACTION import2
    #     LET g_action_choice="import2"
    #     EXIT DISPLAY
    #  ON ACTION import3
    #     LET g_action_choice="import3"
    #     EXIT DISPLAY
      ON ACTION item_list
         LET g_action_choice="item_list"
         EXIT DISPLAY
         
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

FUNCTION i083_bp2(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdpb TO s_hrdpb.* ATTRIBUTE(COUNT=g_rec_b2)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index,g_row_count )
                 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
                 
      ON ACTION first
         CALL i083_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i083_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i083_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i083_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i083_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

#      ON ACTION copyin
#         LET g_action_choice="copyin"
#         EXIT DISPLAY
         
      ON ACTION detail
         LET l_ac2=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac2=1
         LET g_action_choice="detail"
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

      ON ACTION page03
         LET g_flag_b='1'
         EXIT DISPLAY

      ON ACTION page05
         LET g_flag_b='3'
         EXIT DISPLAY 
      ON ACTION p1
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p2
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p3
         LET g_flag_b='5'
         EXIT DISPLAY 
      ON ACTION p4
         LET g_flag_b='6'
         EXIT DISPLAY                            
      ON ACTION main
         LET g_flag_b='1'
         EXIT DISPLAY 
      ON ACTION item_list
         LET g_action_choice="item_list"
         EXIT DISPLAY
         
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

FUNCTION i083_bp3(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdpc TO s_hrdpc.* ATTRIBUTE(COUNT=g_rec_b3)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index,g_row_count )
                 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
                 
      ON ACTION first
         CALL i083_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i083_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i083_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i083_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i083_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

#      ON ACTION copyin
#         LET g_action_choice="copyin"
#         EXIT DISPLAY
         
      ON ACTION detail
         LET l_ac3=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac3=1
         LET g_action_choice="detail"
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

      ON ACTION page03
         LET g_flag_b='1'
         EXIT DISPLAY

      ON ACTION page04
         LET g_flag_b='2'
         EXIT DISPLAY 
      ON ACTION p1
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p2
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p3
         LET g_flag_b='5'
         EXIT DISPLAY 
      ON ACTION p4
         LET g_flag_b='6'
         EXIT DISPLAY                            
      ON ACTION main
         LET g_flag_b='1'
         EXIT DISPLAY 
      ON ACTION item_list
         LET g_action_choice="item_list"
         EXIT DISPLAY
         
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

FUNCTION i083_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdp.* TO NULL            #No.FUN-6A0015
    INITIALIZE g_hrdpt.* TO NULL 
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i083_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    
    OPEN i083_count
    FETCH i083_count INTO g_row_count
    
    OPEN i083_cs    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdp.hrdp04,SQLCA.sqlcode,0)
        INITIALIZE g_hrdp.* TO NULL
	INITIALIZE g_hrdpt.* TO NULL 
    ELSE
        CALL i083_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i083_next()
    OPEN i083_count
    FETCH i083_count INTO g_row_count
    
    OPEN i083_cs    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdp.hrdp04,SQLCA.sqlcode,0)
        INITIALIZE g_hrdp.* TO NULL
	INITIALIZE g_hrdpt.* TO NULL 
    ELSE
        CALL i083_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i083_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr100

    CASE p_flag
        WHEN 'N' FETCH NEXT     i083_cs INTO g_hrdpt.hrdp01
        WHEN 'P' FETCH PREVIOUS i083_cs INTO g_hrdpt.hrdp01
        WHEN 'F' FETCH FIRST    i083_cs INTO g_hrdpt.hrdp01
        WHEN 'L' FETCH LAST     i083_cs INTO g_hrdpt.hrdp01
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
            FETCH ABSOLUTE g_jump i083_cs INTO g_hrdpt.hrdp01
            LET mi_no_ask = FALSE 
        OTHERWISE 
            LET g_hrdpt.hrdp01=p_flag
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdp.hrdp04,SQLCA.sqlcode,0)
        INITIALIZE g_hrdp.* TO NULL  #TQC-6B0105
	INITIALIZE g_hrdpt.* TO NULL 
        LET g_hrdp.hrdp04 = NULL     #TQC-6B0105
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
         OTHERWISE EXIT CASE 
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF

    SELECT * INTO g_hrdpt.* FROM hrdp_file  # 重讀DB,因TEMP有不被更新特性
       WHERE hrdp01 = g_hrdpt.hrdp01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdp_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",0)
    ELSE
        LET g_data_owner=g_hrdpt.hrdpuser           #FUN-4C0044權限控管
        LET g_data_group=g_hrdpt.hrdpgrup
        CALL i083_show()                               #重新顯示
    END IF
END FUNCTION

FUNCTION i083_show()
DEFINE l_hrat   RECORD LIKE hrat_file.*
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hras04 LIKE hras_file.hras04
DEFINE l_hrat01 LIKE hrat_file.hrat01
DEFINE l_hrdpud02_name  LIKE hrag_file.hrag07
DEFINE l_hrdpud03_name1  LIKE hrde_file.hrdeud01
DEFINE l_hrdpud03_name2  LIKE hrde_file.hrdeud02
DEFINE l_hrdp05_n LIKE hrag_file.hrag07

    LET g_hrdp.* = g_hrdpt.*
    SELECT hrat01 INTO l_hrat01 FROM hrat_file WHERE hratid=g_hrdpt.hrdp04
    LET g_hrdp.hrdp04=l_hrat01
    DISPLAY BY NAME g_hrdp.hrdp02,g_hrdp.hrdp03,g_hrdp.hrdp04,g_hrdp.hrdp05,
                    g_hrdp.hrdp06,g_hrdp.hrdp07,g_hrdp.hrdp08,g_hrdp.hrdp09,
                    g_hrdp.hrdpud02,g_hrdp.hrdpud03,g_hrdp.hrdpud13,
                    g_hrdp.hrdpacti,g_hrdp.hrdpuser,g_hrdp.hrdpgrup,g_hrdp.hrdpmodu,
                    g_hrdp.hrdpdate,g_hrdp.hrdporiu,g_hrdp.hrdporig
                    
    SELECT * INTO l_hrat.* FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
    DISPLAY BY NAME l_hrat.hrat02,l_hrat.hrat25
    
    SELECT HRAG07 INTO l_hrdp05_n FROM HRAG_FILE WHERE HRAG01='657' AND HRAG06=g_hrdp.hrdp05
    DISPLAY l_hrdp05_n TO hrdp05_n
    
    SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01=l_hrat.hrat04
    DISPLAY l_hrao02 TO hrao02

    SELECT hras04 INTO l_hras04 FROM hras_file WHERE hras01=l_hrat.hrat05
    DISPLAY l_hras04 TO hras04
    
      SELECT hrag07 INTO l_hrdpud02_name FROM hrag_file WHERE hrag01='649' AND hrag06=g_hrdp.hrdpud02
      DISPLAY l_hrdpud02_name TO hrdpud02_name
      
      SELECT hrdeud01,hrdeud02 INTO l_hrdpud03_name1,l_hrdpud03_name2 FROM hrde_file WHERE hrde01='001' AND hrde03=g_hrdp.hrdpud02 AND hrde05=g_hrdp.hrdpud03
      DISPLAY l_hrdpud03_name1 TO hrdpud03_name1
      DISPLAY l_hrdpud03_name2 TO hrdpud03_name2
    
    CALL i083_b_fill1()
    CALL i083_b_fill2()
    CALL i083_b_fill3()
#add by zhuzw 20150120 start
    CALL i083_b_fill_p1()
    CALL i083_b_fill_p2()
    CALL i083_b_fill_p3()
#add by zhuzw 20150120 end     
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i083_a()
DEFINE l_sql STRING
DEFINE l_hrdp04 LIKE hrdp_file.hrdp04
DEFINE l_hrde01 LIKE hrde_file.hrde01
DEFINE l_hrde03 LIKE hrde_file.hrde03
DEFINE l_hrde05 LIKE hrde_file.hrde05
DEFINE l_hrde06 LIKE hrde_file.hrde06

    MESSAGE ""
    CLEAR FORM                                     # 清螢墓欄位內容
    INITIALIZE g_hrdp.* TO NULL 
    INITIALIZE g_hrdpt.* TO NULL 
    CALL g_hrdpa.clear()
    CALL g_hrdpb.clear()
    CALL g_hrdpc.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrdp.hrdpuser = g_user
        LET g_hrdp.hrdporiu = g_user #FUN-980030
        LET g_hrdp.hrdporig = g_grup #FUN-980030
        LET g_hrdp.hrdpgrup = g_grup               #使用者所屬群
        LET g_hrdp.hrdpmodu = g_user
        LET g_hrdp.hrdpacti = 'Y'
        LET g_hrdp.hrdpdate = g_today
        LET g_hrdp.hrdp06='0'
	      SELECT max(to_number(hrdp01)) +1  INTO g_hrdp.hrdp01 FROM hrdp_file #add by zhuzw 2015012
          IF cl_null(g_hrdp.hrdp01) THEN
             LET g_hrdp.hrdp01 = 1
          END IF
          SELECT to_char(g_hrdp.hrdp01,'fm0000000000') INTO g_hrdp.hrdp01 FROM DUAL
        CALL i083_i("a")                           # 各欄位輸入
        IF INT_FLAG THEN                           # 若按了DEL鍵
            INITIALIZE g_hrdp.* TO NULL
	    INITIALIZE g_hrdpt.* TO NULL 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
 
	LET g_hrdpt.*=g_hrdp.*
	LET g_hrdpt.hrdp04=g_hratid

#  
#	LET g_hrdpt.hrdp01=g_hratid
        INSERT INTO hrdp_file VALUES(g_hrdpt.*)     # DISK WRITE
      IF NOT cl_null(g_hrdpt.hrdpud02) AND NOT cl_null(g_hrdpt.hrdpud03) AND NOT cl_null(g_hrdpt.hrdpud13) THEN
         LET l_sql = "SELECT hrde01,hrde03,hrde05,hrde06 FROM hrde_file WHERE hrde03='",g_hrdpt.hrdpud02,"' AND hrde05='",g_hrdpt.hrdpud03,"'"
         PREPARE i083_p0  FROM l_sql
         DECLARE i083_p0_c CURSOR FOR i083_p0
         FOREACH i083_p0_c INTO l_hrde01,l_hrde03,l_hrde05,l_hrde06
            INSERT INTO hrdpc_file (hrdpc01,hrdpc02,hrdpc03,hrdpc04,hrdpc05,hrdpc06,hrdpc07)
               VALUES(g_hrdpt.hrdp01,l_hrde01,l_hrde03,l_hrde05,l_hrde06,g_hrdp.hrdpud13,'2099/12/31')
         END FOREACH 
      END IF 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdp_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        LET g_rec_b1=0
        LET g_rec_b2=0
        LET g_rec_b3=0
        CALL i083_b_fill3()
        #LET g_curs_index = 3
        #LET g_row_count =1
        #CALL i083_bp3("G")
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i083_u()
DEFINE l_sql STRING
DEFINE l_hrde01   LIKE hrde_file.hrde01
DEFINE l_hrde02   LIKE hrde_file.hrde02
DEFINE l_hrde03   LIKE hrde_file.hrde03
DEFINE l_hrde04   LIKE hrde_file.hrde04
DEFINE l_hrde05   LIKE hrde_file.hrde05
DEFINE l_hrde06   LIKE hrde_file.hrde06
DEFINE l_hrdpc06  LIKE hrdpc_file.hrdpc06
    
    
    IF g_hrdpt.hrdp04 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_hrdp.hrdpacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_hrdp.hrdp09='003' THEN 
    	 CALL cl_err('已审核不能修改','!',0)
       RETURN 
    END IF 
    
    CALL cl_opmsg('u')
    LET g_hrdp_t.* = g_hrdpt.*
    BEGIN WORK

    OPEN i083_cl USING g_hrdpt.hrdp01
    IF STATUS THEN
       CALL cl_err("OPEN i083_cl:", STATUS, 1)
       CLOSE i083_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i083_cl INTO g_hrdp.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdp.hrdp04,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_hrdp.hrdpmodu=g_user                # 修改者
    LET g_hrdp.hrdpdate=g_today               # 修改日期
    CALL i083_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i083_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdp.*=g_hrdp_t.*
            CALL i083_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrdp_file SET hrdp_file.* = g_hrdp.*  # 更新DB
            WHERE hrdp01 = g_hrdp_t.hrdp01           #MOD-BB0113 add
      IF NOT cl_null(g_hrdp.hrdpud02) AND NOT cl_null(g_hrdp.hrdpud03) AND NOT cl_null(g_hrdp.hrdpud13) THEN
         SELECT MAX(hrdpc06) INTO l_hrdpc06 FROM hrdpc_file WHERE hrdpc01=g_hrdp.hrdp01
         IF cl_null(l_hrdpc06) OR g_hrdp.hrdpud13 > l_hrdpc06 THEN
            IF NOT cl_null(l_hrdpc06) THEN
               LET l_hrdpc06 = g_hrdp.hrdpud13-1
               UPDATE hrdpc_file SET hrdpc07=l_hrdpc06 WHERE hrdpc01=g_hrdp.hrdp01 AND hrdpc07='2099/12/31'
            END IF 
            LET l_sql = "SELECT hrde01,hrde03,hrde05,hrde06 FROM hrde_file WHERE hrde03='",g_hrdp.hrdpud02,"' AND hrde05='",g_hrdp.hrdpud03,"'"
            PREPARE i083_p  FROM l_sql
            DECLARE i083_p_c CURSOR FOR i083_p
            FOREACH i083_p_c INTO l_hrde01,l_hrde03,l_hrde05,l_hrde06
               INSERT INTO hrdpc_file (hrdpc01,hrdpc02,hrdpc03,hrdpc04,hrdpc05,hrdpc06,hrdpc07)
                  VALUES(g_hrdp.hrdp01,l_hrde01,l_hrde03,l_hrde05,l_hrde06,g_hrdp.hrdpud13,'2099/12/31')
            END FOREACH 
         END IF
        CALL i083_b_fill3()
      END IF 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdp_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i083_cl
    COMMIT WORK
END FUNCTION

FUNCTION i083_i(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrat   RECORD LIKE hrat_file.*
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hras04 LIKE hras_file.hras04
DEFINE l_hrdpud02_name  LIKE hrag_file.hrag07
DEFINE l_hrdpud03_name1  LIKE hrde_file.hrdeud01
DEFINE l_hrdpud03_name2  LIKE hrde_file.hrdeud02
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_hhrdp05_n LIKE hrag_file.hrag07
  # INPUT BY NAME g_hrdp.hrdp02,g_hrdp.hrdp03,g_hrdp.hrdp04,g_hrdp.hrdp05,g_hrdp.hrdp07,g_hrdp.hrdp08,g_hrdp.hrdpud02,g_hrdp.hrdpud03,g_hrdp.hrdpud13
  # INPUT BY NAME g_hrdp.hrdp04,g_hrdp.hrdp05,g_hrdp.hrdpud02,g_hrdp.hrdpud03,g_hrdp.hrdp02,g_hrdp.hrdp03,g_hrdp.hrdp07,g_hrdp.hrdp08,g_hrdp.hrdpud13
   INPUT BY NAME g_hrdp.hrdp04,g_hrdp.hrdp05,g_hrdp.hrdp03,g_hrdp.hrdpud02,g_hrdp.hrdpud03,g_hrdp.hrdpud13,g_hrdp.hrdp08
      WITHOUT DEFAULTS

      BEFORE INPUT
         IF p_cmd='a' THEN 
            LET g_hrdp.hrdp07=g_today
            LET g_hrdp.hrdp09='002'
            DISPLAY BY NAME g_hrdp.hrdp07,g_hrdp.hrdp09
         END IF 
         CALL cl_set_comp_entry("hrdp04",TRUE)#add by zhuzw 20150130
         IF p_cmd='u' THEN  
         	CALL cl_set_comp_entry("hrdp04",FALSE)
         END IF  
         
      AFTER FIELD hrdpud02
         IF NOT cl_null(g_hrdp.hrdpud02) THEN 
            SELECT hrag07 INTO l_hrdpud02_name FROM hrag_file WHERE hrag01='649' AND hrag06=g_hrdp.hrdpud02
            DISPLAY l_hrdpud02_name TO hrdpud02_name
         END IF 
         
      AFTER FIELD hrdpud03
         IF NOT cl_null(g_hrdp.hrdpud03) AND NOT cl_null(g_hrdp.hrdpud02) THEN 
            SELECT hrdeud01,hrdeud02 INTO l_hrdpud03_name1,l_hrdpud03_name2 FROM hrde_file WHERE hrde01='001' AND hrde03=g_hrdp.hrdpud02 AND hrde05=g_hrdp.hrdpud03
            DISPLAY l_hrdpud03_name1 TO hrdpud03_name1
            DISPLAY l_hrdpud03_name2 TO hrdpud03_name2
         END IF 
         
      AFTER FIELD hrdpud13
         IF NOT cl_null(g_hrdp.hrdpud13) THEN 
            SELECT COUNT(*) INTO l_cnt FROM hrct_file WHERE hrct07=g_hrdp.hrdpud13
            IF cl_null(l_cnt) OR l_cnt=0 THEN 
               IF cl_confirm('生效日期不等于薪资月开始日期\n是否重新设置生效日期?') THEN
                  LET g_hrdp.hrdpud13 = NULL 
                  NEXT FIELD hrdpud13
               END IF
            END IF 
         END IF 

      AFTER FIELD hrdp04
         IF g_hrdp.hrdp04!=g_hrdp_t.hrdp04 OR cl_null(g_hrdp_t.hrdp04) THEN 
            SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
            #add by zhuzw 20150130 start
            IF p_cmd= 'a' THEN 
               SELECT count(*) INTO g_i FROM hrdp_file
                WHERE hrdp04=g_hratid
                  AND hrdp09 ='002' #add by zhuzw 20150130
               IF g_i>0  THEN 
            	   CALL cl_err('已存在该员工未审核调薪数据，不可再次新增','!',0)
                 NEXT FIELD hrdp04
               END IF 
            END IF
             #add by zhuzw 20150130 end  
            IF cl_null(g_hratid) THEN 
            	CALL cl_err('员工不存在，请检查','!',0)
               NEXT FIELD hrdp04
            END IF  
            #LET g_hrdp.hrdp01=g_hratid
            IF cl_null(g_hrdp.hrdp02) OR g_hrdp.hrdp02 = ' ' THEN 
            	LET g_hrdp.hrdp02 = g_hrdp.hrdp01
            	DISPLAY g_hrdp.hrdp02 TO hrdp02
            END IF
            SELECT * INTO l_hrat.* FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
            DISPLAY BY NAME l_hrat.hrat02,l_hrat.hrat25

            SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01=l_hrat.hrat04
            DISPLAY l_hrao02 TO hrao02

            SELECT hras04 INTO l_hras04 FROM hras_file WHERE hras01=l_hrat.hrat05
            DISPLAY l_hras04 TO hras04
          #  LET g_hrdp.hrdp04=g_hratid
         END IF 
#add by zhuzw 20150122 start
      AFTER FIELD hrdp05
         IF NOT cl_null(g_hrdp.hrdp05) THEN 
            SELECT hrag07 INTO l_hhrdp05_n FROM hrag_file WHERE hrag01='657' AND hrag06=g_hrdp.hrdp05
            DISPLAY l_hhrdp05_n TO hrdp05_n
         END IF 
#add by zhuzw 20150122 end          
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrdp04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              CALL cl_create_qry() RETURNING g_hrdp.hrdp04
              DISPLAY BY NAME g_hrdp.hrdp04
              NEXT FIELD hrdp04
           WHEN INFIELD(hrdpud02)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '649'
              LET g_qryparam.form = "q_hrag06"
              CALL cl_create_qry() RETURNING g_hrdp.hrdpud02
              DISPLAY BY NAME g_hrdp.hrdpud02
              NEXT FIELD hrdpud02
#add by zhuzw 20150122 start
           WHEN INFIELD(hrdp05)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '657'
              LET g_qryparam.form = "q_hrag06"
              CALL cl_create_qry() RETURNING g_hrdp.hrdp05
              DISPLAY BY NAME g_hrdp.hrdp05
              NEXT FIELD hrdp05
#add by zhuzw 20150122 end 
           WHEN INFIELD(hrdpud03)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = g_hrdp.hrdpud02
              LET g_qryparam.form = "q_hrde05"
              CALL cl_create_qry() RETURNING g_hrdp.hrdpud03
              DISPLAY BY NAME g_hrdp.hrdpud03
              NEXT FIELD hrdpud03
        END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
            
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
            
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
      ON ACTION ghri083_f
         CALL cl_err('等待实现功能','!',1)
        
   END INPUT

END FUNCTION

FUNCTION i083_b_fill1()
   LET g_sql = "SELECT hrdpa02,'','','',hrdpa06,hrdpa07,hrdpa03,hrcyb04,",
               "       hrdpa04,hrcyb05,hrcyb06,hrcyb07,hrcyb08,hrdpa05,hrdpa08",
               "  FROM hrdpa_file LEFT OUTER JOIN hrcyb_file ",
               "    ON hrcyb01=hrdpa02 and hrcyb02=hrdpa03 and hrcyb03=hrdpa04",
               " WHERE hrdpa01 = '",g_hrdpt.hrdp01,"'",
               " ORDER BY hrdpa02"
   PREPARE i083_pb1 FROM g_sql
   DECLARE i083_hrdpa CURSOR FOR i083_pb1
   CALL g_hrdpa.clear()
   LET g_cnt = 1

   FOREACH i083_hrdpa INTO g_hrdpa[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrdpa.deleteElement(g_cnt)
   LET g_rec_b1=g_cnt-1
END FUNCTION

FUNCTION i083_b_fill2()
   LET g_sql = "SELECT hrdpb02,'','',hrdpb03,hrdpb04,hrdpb05,hrdpb06",
               "  FROM hrdpb_file",
               " WHERE hrdpb01 = '",g_hrdpt.hrdp01,"'",
               " ORDER BY hrdpb02"
   PREPARE i083_pb2 FROM g_sql
   DECLARE i083_hrdpb CURSOR FOR i083_pb2
   CALL g_hrdpb.clear()
   LET g_cnt = 1

   FOREACH i083_hrdpb INTO g_hrdpb[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrdpb.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
END FUNCTION

FUNCTION i083_b_fill3()
DEFINE l_hrde04 LIKE hrde_file.hrde04

   LET g_sql = "SELECT hrdpc02,'','','',hrdpc06,hrdpc07,hrdpc03,'',",
               "       hrdpc04,hrdpc05,hrdpc08",
               "  FROM hrdpc_file",
               " WHERE hrdpc01 = '",g_hrdpt.hrdp01,"'",
               " ORDER BY hrdpc02"
   PREPARE i083_pb3 FROM g_sql
   DECLARE i083_hrdpc CURSOR FOR i083_pb3
   CALL g_hrdpc.clear()
   LET g_cnt = 1

   FOREACH i083_hrdpc INTO g_hrdpc[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       SELECT hrde04 INTO l_hrde04 FROM hrde_file 
        WHERE hrde01=g_hrdpc[g_cnt].hrdpc02
       CASE l_hrde04
         WHEN '0'
           SELECT hrar04 INTO g_hrdpc[g_cnt].hrdpc03_name FROM hrar_file
            WHERE hrar03=g_hrdpc[g_cnt].hrdpc03
         WHEN '1'
           SELECT hras04 INTO g_hrdpc[g_cnt].hrdpc03_name FROM hras_file
            WHERE hras01=g_hrdpc[g_cnt].hrdpc03
         WHEN '2'
           SELECT hrag07 INTO g_hrdpc[g_cnt].hrdpc03_name FROM hrag_file
            WHERE hrag01='649' AND hrad06=g_hrdpc[g_cnt].hrdpc03
       END CASE
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrdpc.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1
END FUNCTION

FUNCTION i083_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
DEFINE 
    l_cnt           LIKE type_file.num5,
    l_hrat25        LIKE hrat_file.hrat25,
    l_sr            LIKE type_file.num5
   
    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    IF g_hrdp.hrdp09='003' THEN 
       RETURN 
    END IF 
    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    IF g_hrdp.hrdp03='002' THEN 
       CALL cl_set_comp_visible("hrdpa03_a,hrdpa04_a,hrdpa05_a",TRUE)
    END IF 
    LET g_forupd_sql = "SELECT hrdpa02,'','','',hrdpa06,hrdpa07,hrdpa03,hrcyb04,",
                       "       hrdpa04,hrcyb05,hrcyb06,hrcyb07,hrcyb08,hrdpa05,hrdpa08",
                       "  FROM hrdpa_file LEFT OUTER JOIN hrcyb_file ",
                       "    ON hrcyb01=hrdpa02 AND hrcyb02=hrdpa03 AND hrcyb03=hrdpa04",
                       " WHERE hrdpa01=? AND hrdpa02=? AND hrdpa06= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i083_bcl_1 CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hrdpa WITHOUT DEFAULTS FROM s_hrdpa.*
      ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b1>=l_ac1 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_hrdpa_t.* = g_hrdpa[l_ac1].*  #BACKUP
               OPEN i083_bcl_1 USING g_hrdpt.hrdp01,g_hrdpa[l_ac1].hrdpa02,g_hrdpa[l_ac1].hrdpa06
               IF STATUS THEN
                  CALL cl_err("OPEN i083_bcl_1:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i083_bcl_1 INTO g_hrdpa[l_ac1].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrdpa_t.hrdpa02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

        ON ACTION controlp
          CASE WHEN INFIELD(hrdpa03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrcya02"
                LET g_qryparam.arg1=g_hrdpa[l_ac1].hrdpa02
                CALL cl_create_qry() RETURNING g_hrdpa[l_ac1].hrdpa03
                DISPLAY BY NAME g_hrdpa[l_ac1].hrdpa03
                NEXT FIELD hrdpa03
               WHEN INFIELD(hrdpa04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrcyb03"
                LET g_qryparam.arg1=g_hrdpa[l_ac1].hrdpa02
                LET g_qryparam.arg2=g_hrdpa[l_ac1].hrdpa03
                CALL cl_create_qry() RETURNING g_hrdpa[l_ac1].hrdpa04
                DISPLAY BY NAME g_hrdpa[l_ac1].hrdpa04
                NEXT FIELD hrdpa04
          END CASE

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_show_fld_cont()
           SELECT count(*) INTO l_cnt FROM hrdpa_file 
            WHERE hrdpa01=g_hrdpt.hrdp01
#           IF l_cnt>0 THEN 
#              LET g_hrdpa[l_ac1].hrdpa06=g_today
#           ELSE
#              SELECT hrat25 INTO l_hrat25 FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
#              LET g_hrdpa[l_ac1].hrdpa06=l_hrat25
#           END IF 
#           LET g_hrdpa[l_ac1].hrdpa07='9999/12/31'
#           DISPLAY BY NAME g_hrdpa[l_ac1].hrdpa06,g_hrdpa[l_ac1].hrdpa07
        AFTER FIELD hrdpa02
           IF cl_null(g_hrdpa[l_ac1].hrdpa06) THEN 
              SELECT to_date(to_char(SYSDATE,'yyyymm'),'yyyymm') INTO g_hrdpa[l_ac1].hrdpa06 FROM dual
              LET g_hrdpa[l_ac1].hrdpa07='9999/12/31'
           END IF
        AFTER FIELD hrdpa03
           SELECT hrcya03 INTO g_hrdpa[l_ac1].hrdpa03_name FROM hrcya_file
            WHERE hrcya01=g_hrdpa[l_ac1].hrdpa02
              AND hrcya02=g_hrdpa[l_ac1].hrdpa03
           DISPLAY BY NAME g_hrdpa[l_ac1].hrdpa03_name
           
        AFTER FIELD hrdpa04
           SELECT hrcyb05,hrcyb06,hrcyb07,hrcyb08
             INTO g_hrdpa[l_ac1].hrdpa04_name,g_hrdpa[l_ac1].hrcyb06,g_hrdpa[l_ac1].hrcyb07,g_hrdpa[l_ac1].hrcyb08
             FROM hrcyb_file
            WHERE hrcyb01=g_hrdpa[l_ac1].hrdpa02
              AND hrcyb02=g_hrdpa[l_ac1].hrdpa03
              AND hrcyb03=g_hrdpa[l_ac1].hrdpa04
           LET g_hrdpa[l_ac1].hrdpa05=g_hrdpa[l_ac1].hrcyb08
           DISPLAY BY NAME g_hrdpa[l_ac1].hrdpa04_name,g_hrdpa[l_ac1].hrdpa05,g_hrdpa[l_ac1].hrcyb06,
                           g_hrdpa[l_ac1].hrcyb07,g_hrdpa[l_ac1].hrcyb08

        AFTER FIELD hrdpa06
          IF NOT cl_null(g_hrdpa[l_ac1].hrdpa06) AND NOT cl_null(g_hrdpa[l_ac1].hrdpa07) 
          	AND g_hrdpa[l_ac1].hrdpa06<>g_hrdpa_t.hrdpa06 THEN 
           IF g_hrdpa[l_ac1].hrdpa06>g_hrdpa[l_ac1].hrdpa07 THEN
           	CALL cl_err('生效日期不能大于失效日期，请修改','！',0)
            NEXT FIELD hrdpa06
           END IF 
           	LET l_sr='0'
            SELECT COUNT(*) INTO l_sr FROM hrdpa_file WHERE hrdpa01=g_hrdpt.hrdp01
                                                       AND hrdpa02=g_hrdpa[l_ac1].hrdpa02
                                                       AND hrdp06<=g_hrdpa[l_ac1].hrdpa07
                                                       AND hrdp07>=g_hrdpa[l_ac1].hrdpa06
            IF l_sr>0 THEN 
           	  CALL cl_err('区间重复，请检查','！',0)
              NEXT FIELD hrdpa07
            END IF 
          END IF 
        AFTER FIELD hrdpa07
           IF NOT cl_null(g_hrdpa[l_ac1].hrdpa06) AND NOT cl_null(g_hrdpa[l_ac1].hrdpa07) 
          	 AND g_hrdpa[l_ac1].hrdpa07<>g_hrdpa_t.hrdpa07 THEN 
            IF g_hrdpa[l_ac1].hrdpa06>g_hrdpa[l_ac1].hrdpa07 THEN
            	 CALL cl_err('生效日期不能大于失效日期，请修改','！',0)
              NEXT FIELD hrdpa07
            END IF 
            	LET l_sr='0'
             SELECT COUNT(*) INTO l_sr FROM hrdpa_file WHERE hrdpa01=g_hrdpt.hrdp01
                                                       AND hrdpa02=g_hrdpa[l_ac1].hrdpa02
                                                       AND hrdp06<=g_hrdpa[l_ac1].hrdpa07
                                                       AND hrdp07>=g_hrdpa[l_ac1].hrdpa06
            IF l_sr>0 THEN 
           	  CALL cl_err('区间重复，请检查','！',0)
              NEXT FIELD hrdpa07
            END IF 
           END IF 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i083_bcl_1
              CANCEL INSERT
           END IF
           BEGIN WORK
           UPDATE hrdpa_file SET hrdpa07 = g_hrdpa[l_ac1].hrdpa06-1 WHERE hrdpa01=g_hrdpt.hrdp01 AND hrdpa02=g_hrdpa[l_ac1].hrdpa02 AND (hrdpa07='9999/12/31' OR hrdpa07='1999/12/31' OR hrdpa07='2099/12/31')
           INSERT INTO hrdpa_file(hrdpa01,hrdpa02,hrdpa03,hrdpa04,hrdpa05,hrdpa06,hrdpa07,hrdpa08)
                VALUES(g_hrdpt.hrdp01,g_hrdpa[l_ac1].hrdpa02,g_hrdpa[l_ac1].hrdpa03,g_hrdpa[l_ac1].hrdpa04,
                       g_hrdpa[l_ac1].hrdpa05,g_hrdpa[l_ac1].hrdpa06,g_hrdpa[l_ac1].hrdpa07,g_hrdpa[l_ac1].hrdpa08)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK
               CALL cl_err3("ins","hrdpa_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b1=g_rec_b1+1
           END IF

        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           UPDATE hrdpa_file SET hrdpa07 = '9999/12/31'  WHERE hrdpa01=g_hrdpt.hrdp01 AND hrdpa02=g_hrdpa[l_ac1].hrdpa02 AND hrdpa07=g_hrdpa[l_ac1].hrdpa06-1
           DELETE FROM hrdpa_file WHERE hrdpa01 = g_hrdpt.hrdp01
                                    AND hrdpa02 = g_hrdpa[l_ac1].hrdpa02
                                    AND hrdpa06 = g_hrdpa[l_ac1].hrdpa06
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdpa_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b1=g_rec_b1-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdpa[l_ac1].* = g_hrdpa_t.*
              CLOSE i083_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrdp.hrdp04,-263,0)
               LET g_hrdpa[l_ac1].* = g_hrdpa_t.*
           ELSE
               UPDATE hrdpa_file SET hrdpa02=g_hrdpa[l_ac1].hrdpa02,
                                     hrdpa03=g_hrdpa[l_ac1].hrdpa03,
                                     hrdpa04=g_hrdpa[l_ac1].hrdpa04,
                                     hrdpa05=g_hrdpa[l_ac1].hrdpa05,
                                     hrdpa06=g_hrdpa[l_ac1].hrdpa06,
                                     hrdpa07=g_hrdpa[l_ac1].hrdpa07,
                                     hrdpa08=g_hrdpa[l_ac1].hrdpa08
                               WHERE hrdpa01 = g_hrdpt.hrdp01
                                 AND hrdpa02 = g_hrdpa_t.hrdpa02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrdpa_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdpa[l_ac1].* = g_hrdpa_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac1 = ARR_CURR()        # ?板?
           LET l_ac_t = l_ac1            # ?板?

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrdpa[l_ac1].* = g_hrdpa_t.*
              END IF
              CLOSE i083_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i083_bcl_1
           COMMIT WORK

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121

        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121

    END INPUT
    
    CLOSE i083_bcl_1
    CALL cl_set_comp_visible("hrdpa03_a,hrdpa04_a,hrdpa05_a",FALSE)
    COMMIT WORK

    SELECT sum(hrdpa05) INTO g_sum1 FROM hrdpa_file WHERE hrdpa01=g_hrdpt.hrdp01
    SELECT sum(hrdpb03) INTO g_sum2 FROM hrdpb_file WHERE hrdpb01=g_hrdpt.hrdp01
    SELECT sum(hrdpc05) INTO g_sum3 FROM hrdpc_file WHERE hrdpc01=g_hrdpt.hrdp01
    IF cl_null(g_sum1) THEN LET g_sum1=0 END IF 
    IF cl_null(g_sum2) THEN LET g_sum2=0 END IF 
    IF cl_null(g_sum3) THEN LET g_sum3=0 END IF 
    LET g_hrdp.hrdp06=g_sum1+g_sum2+g_sum3 
    UPDATE hrdp_file SET hrdp06=g_hrdp.hrdp06 WHERE hrdp01=g_hrdp.hrdp01
    DISPLAY BY NAME g_hrdp.hrdp06
END FUNCTION

FUNCTION i083_b2()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
DEFINE 
    l_cnt           LIKE type_file.num5,
    l_hrat25        LIKE hrat_file.hrat25
    
    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    IF g_hrdp.hrdp09='003' THEN 
       RETURN 
    END IF 
    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    IF g_hrdp.hrdp03='002' THEN 
       CALL cl_set_comp_visible("hrdpb03_a,hrdpb04_a",TRUE)
    END IF 
    LET g_forupd_sql = "SELECT hrdpb02,'','',hrdpb03,hrdpb04,hrdpb05,hrdpb06",
                       "  FROM hrdpb_file ",
                       " WHERE hrdpb01=? AND hrdpb02=? and hrdpb04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i083_bcl_2 CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hrdpb WITHOUT DEFAULTS FROM s_hrdpb.*
      ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b2>=l_ac2 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_hrdpb_t.* = g_hrdpb[l_ac2].*  #BACKUP
               OPEN i083_bcl_2 USING g_hrdpt.hrdp01,g_hrdpb[l_ac2].hrdpb02,g_hrdpb[l_ac2].hrdpb04
               IF STATUS THEN
                  CALL cl_err("OPEN i083_bcl_2:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i083_bcl_2 INTO g_hrdpb[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrdpb_t.hrdpb02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF
            
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_show_fld_cont()
           SELECT count(*) INTO l_cnt FROM hrdp_file 
            WHERE hrdp01!=g_hrdp.hrdp01
#           IF l_cnt>0 THEN 
#              LET g_hrdpb[l_ac2].hrdpb04=g_today
#           ELSE
#              SELECT hrat25 INTO l_hrat25 FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
#              LET g_hrdpb[l_ac2].hrdpb04=l_hrat25
#           END IF 
#           LET g_hrdpb[l_ac2].hrdpb05='9999/12/31'
#           DISPLAY BY NAME g_hrdpb[l_ac2].hrdpb04,g_hrdpb[l_ac2].hrdpb05
        AFTER FIELD hrdpb02
           IF cl_null(g_hrdpb[l_ac2].hrdpb04) THEN 
              SELECT to_date(to_char(SYSDATE,'yyyymm'),'yyyymm') INTO g_hrdpb[l_ac2].hrdpb04 FROM dual
              LET g_hrdpb[l_ac2].hrdpb05='9999/12/31'
           END IF
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i083_bcl_2
              CANCEL INSERT
           END IF
           BEGIN WORK
           UPDATE hrdpb_file SET hrdpb05 = g_hrdpb[l_ac2].hrdpb04-1 WHERE hrdpb01=g_hrdpt.hrdp01 AND hrdpb02=g_hrdpb[l_ac2].hrdpb02 AND (hrdpb05='9999/12/31' OR hrdpb05='1999/12/31' OR hrdpb05='2099/12/31')
           INSERT INTO hrdpb_file(hrdpb01,hrdpb02,hrdpb03,hrdpb04,hrdpb05,hrdpb06)
                VALUES(g_hrdpt.hrdp01,g_hrdpb[l_ac2].hrdpb02,g_hrdpb[l_ac2].hrdpb03,g_hrdpb[l_ac2].hrdpb04,
                       g_hrdpb[l_ac2].hrdpb05,g_hrdpb[l_ac2].hrdpb06)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK
               CALL cl_err3("ins","hrdpb_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
           END IF

        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           UPDATE hrdpb_file SET hrdpb05 = '9999/12/31' WHERE hrdpb01=g_hrdpt.hrdp01 AND hrdpb02=g_hrdpb[l_ac2].hrdpb02 AND hrdpb05=g_hrdpb[l_ac2].hrdpb04-1
           DELETE FROM hrdpb_file WHERE hrdpb01 = g_hrdpt.hrdp01
                                    AND hrdpb02 = g_hrdpb[l_ac2].hrdpb02
                                    AND hrdpb04 = g_hrdpb[l_ac2].hrdpb04
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdpb_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b2=g_rec_b2-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdpb[l_ac2].* = g_hrdpb_t.*
              CLOSE i083_bcl_2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrdp.hrdp04,-263,0)
               LET g_hrdpb[l_ac2].* = g_hrdpb_t.*
           ELSE
               UPDATE hrdpb_file SET hrdpb02=g_hrdpb[l_ac2].hrdpb02,
                                     hrdpb03=g_hrdpb[l_ac2].hrdpb03,
                                     hrdpb04=g_hrdpb[l_ac2].hrdpb04,
                                     hrdpb05=g_hrdpb[l_ac2].hrdpb05,
                                     hrdpb06=g_hrdpb[l_ac2].hrdpb06
                               WHERE hrdpb01 = g_hrdpt.hrdp01
                                 AND hrdpb02 = g_hrdpb_t.hrdpb02
                                 AND hrdpb04 = g_hrdpb_t.hrdpb04 
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrdpb_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdpb[l_ac2].* = g_hrdpb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac2 = ARR_CURR()        # ?板?
           LET l_ac_t = l_ac2            # ?板?

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrdpb[l_ac2].* = g_hrdpb_t.*
              END IF
              CLOSE i083_bcl_2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i083_bcl_2
           COMMIT WORK

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121

        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121

    END INPUT
    
    CLOSE i083_bcl_2
    CALL cl_set_comp_visible("hrdpb03_a,hrdpb04_a",FALSE)
    COMMIT WORK

    SELECT sum(hrdpa05) INTO g_sum1 FROM hrdpa_file WHERE hrdpa01=g_hrdpt.hrdp01
    SELECT sum(hrdpb03) INTO g_sum2 FROM hrdpb_file WHERE hrdpb01=g_hrdpt.hrdp01
    SELECT sum(hrdpc05) INTO g_sum3 FROM hrdpc_file WHERE hrdpc01=g_hrdpt.hrdp01
    IF cl_null(g_sum1) THEN LET g_sum1=0 END IF 
    IF cl_null(g_sum2) THEN LET g_sum2=0 END IF 
    IF cl_null(g_sum3) THEN LET g_sum3=0 END IF 
    LET g_hrdp.hrdp06=g_sum1+g_sum2+g_sum3 
    UPDATE hrdp_file SET hrdp06=g_hrdp.hrdp06 WHERE hrdp04=g_hrdpt.hrdp01
    DISPLAY BY NAME g_hrdp.hrdp06
END FUNCTION

FUNCTION i083_b3()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
DEFINE
    l_cnt           LIKE type_file.num5,
    l_hrde04        LIKE hrde_file.hrde04,        
    l_hrat25        LIKE hrat_file.hrat25
   
    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    IF g_hrdp.hrdp09='003' THEN 
       RETURN 
    END IF 
    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    IF g_hrdp.hrdp03='002' THEN 
       CALL cl_set_comp_visible("hrdpc03_a,hrdpc04_a,hrdpc05_a",TRUE)
    END IF 
    LET g_forupd_sql = "SELECT hrdpc02,'','','',hrdpc06,hrdpc07,hrdpc03,'',",
                       "       hrdpc04,hrdpc05,hrdpc08",
                       "  FROM hrdpc_file",
                       " WHERE hrdpc01=? AND hrdpc02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i083_bcl_3 CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hrdpc WITHOUT DEFAULTS FROM s_hrdpc.*
      ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac3)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac3 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b3>=l_ac3 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_hrdpc_t.* = g_hrdpc[l_ac3].*  #BACKUP
               OPEN i083_bcl_3 USING g_hrdpt.hrdp01,g_hrdpc[l_ac3].hrdpc02
               IF STATUS THEN
                  CALL cl_err("OPEN i083_bcl_3:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i083_bcl_3 INTO g_hrdpc[l_ac3].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrdpc_t.hrdpc02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT hrde04 INTO l_hrde04 FROM hrde_file
                   WHERE hrde01=g_hrdpc[l_ac3].hrdpc02
                  CASE l_hrde04
                   WHEN '0'
                    SELECT hrar04 INTO g_hrdpc[l_ac3].hrdpc03_name FROM hrar_file
                     WHERE hrar03=g_hrdpc[l_ac3].hrdpc03
                   WHEN '1'
                    SELECT hras04 INTO g_hrdpc[l_ac3].hrdpc03_name FROM hras_file
                     WHERE hras01=g_hrdpc[l_ac3].hrdpc03
                   WHEN '2'
                    SELECT hrag07 INTO g_hrdpc[l_ac3].hrdpc03_name FROM hrag_file
                     WHERE hrag01='649' AND hrad06=g_hrdpc[l_ac3].hrdpc03
                  END CASE
                  DISPLAY BY NAME g_hrdpc[l_ac3].hrdpc03_name
               END IF
               CALL cl_show_fld_cont()
            END IF
            
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_show_fld_cont()
           SELECT count(*) INTO l_cnt FROM hrdp_file 
            WHERE hrdp01!=g_hrdp.hrdp01
#           IF l_cnt>0 THEN 
#              LET g_hrdpc[l_ac3].hrdpc06=g_today
#           ELSE
#              SELECT hrat25 INTO l_hrat25 FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
#              LET g_hrdpc[l_ac3].hrdpc06=l_hrat25
#           END IF 
#           LET g_hrdpc[l_ac3].hrdpc07='9999/12/31'
#           DISPLAY BY NAME g_hrdpc[l_ac3].hrdpc06,g_hrdpc[l_ac3].hrdpc07
        AFTER FIELD hrdpc02
           IF cl_null(g_hrdpc[l_ac3].hrdpc06) THEN 
              SELECT to_date(to_char(SYSDATE,'yyyymm'),'yyyymm') INTO g_hrdpc[l_ac3].hrdpc06 FROM dual
              LET g_hrdpc[l_ac3].hrdpc07='9999/12/31'
           END IF
           SELECT hrde04 INTO l_hrde04 FROM hrde_file WHERE hrde01=g_hrdpc[l_ac3].hrdpc02

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i083_bcl_3
              CANCEL INSERT
           END IF
           BEGIN WORK
           UPDATE hrdpc_file SET hrdpc07 = g_hrdpc[l_ac3].hrdpc06-1 WHERE hrdpc01=g_hrdpt.hrdp01 AND hrdpc02=g_hrdpc[l_ac3].hrdpc02 AND (hrdpc07='9999/12/31' OR hrdpc07='1999/12/31' OR hrdpc07='2099/12/31')
           INSERT INTO hrdpc_file(hrdpc01,hrdpc02,hrdpc03,hrdpc04,hrdpc05,hrdpc06,hrdpc07,hrdpc08)
                VALUES(g_hrdpt.hrdp01,g_hrdpc[l_ac3].hrdpc02,g_hrdpc[l_ac3].hrdpc03,g_hrdpc[l_ac3].hrdpc04,
                       g_hrdpc[l_ac3].hrdpc05,g_hrdpc[l_ac3].hrdpc06,g_hrdpc[l_ac3].hrdpc07,g_hrdpc[l_ac3].hrdpc08)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK
               CALL cl_err3("ins","hrdpc_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b3=g_rec_b3+1
           END IF

        ON ACTION controlp
           CASE WHEN INFIELD(hrdpc03)
             CALL cl_init_qry_var()
             CASE l_hrde04
               WHEN '0'
                 LET g_qryparam.form = "q_hrar03"
               WHEN '1'
                 LET g_qryparam.form = "q_hras01"
               WHEN '2'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.arg1 = "649"
             END CASE 
             CALL cl_create_qry() RETURNING g_hrdpc[l_ac3].hrdpc03
             DISPLAY BY NAME g_hrdpc[l_ac3].hrdpc03
             NEXT FIELD hrdpc03
        END CASE
            
        AFTER FIELD hrdpc03
           CASE l_hrde04
             WHEN '0'
               SELECT hrar04 INTO g_hrdpc[l_ac3].hrdpc03_name FROM hrar_file
                WHERE hrar03=g_hrdpc[l_ac3].hrdpc03
             WHEN '1'
               SELECT hras04 INTO g_hrdpc[l_ac3].hrdpc03_name FROM hras_file
                WHERE hras01=g_hrdpc[l_ac3].hrdpc03
             WHEN '2'
               SELECT hrag07 INTO g_hrdpc[l_ac3].hrdpc03_name FROM hrag_file
                WHERE hrag01='649' AND hrad06=g_hrdpc[l_ac3].hrdpc03
           END CASE
           DISPLAY BY NAME g_hrdpc[l_ac3].hrdpc03_name

        AFTER FIELD hrdpc04
           SELECT hrde06 INTO g_hrdpc[l_ac3].hrdpc05 FROM hrde_file
            WHERE hrde01=g_hrdpc[l_ac3].hrdpc02
              AND hrde03=g_hrdpc[l_ac3].hrdpc03
              AND hrde05=g_hrdpc[l_ac3].hrdpc04
           DISPLAY BY NAME g_hrdpc[l_ac3].hrdpc05
           
        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           UPDATE hrdpc_file SET hrdpc07 = '9999/12/31'  WHERE hrdpc01=g_hrdpt.hrdp01 AND hrdpc02=g_hrdpc[l_ac3].hrdpc02 AND hrdpc07=g_hrdpc[l_ac3].hrdpc06-1
           DELETE FROM hrdpc_file WHERE hrdpc01 = g_hrdpt.hrdp01
                                    AND hrdpc02 = g_hrdpc[l_ac3].hrdpc02
                                    AND hrdpc06 = g_hrdpc[l_ac3].hrdpc06
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdpc_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b3=g_rec_b3-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdpc[l_ac3].* = g_hrdpc_t.*
              CLOSE i083_bcl_3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrdp.hrdp04,-263,0)
               LET g_hrdpc[l_ac3].* = g_hrdpc_t.*
           ELSE
               UPDATE hrdpc_file SET hrdpc02=g_hrdpc[l_ac3].hrdpc02,
                                     hrdpc03=g_hrdpc[l_ac3].hrdpc03,
                                     hrdpc04=g_hrdpc[l_ac3].hrdpc04,
                                     hrdpc05=g_hrdpc[l_ac3].hrdpc05,
                                     hrdpc06=g_hrdpc[l_ac3].hrdpc06,
                                     hrdpc07=g_hrdpc[l_ac3].hrdpc07,
                                     hrdpc08=g_hrdpc[l_ac3].hrdpc08
                               WHERE hrdpc01 = g_hrdpt.hrdp01
                                 AND hrdpc02 = g_hrdpc_t.hrdpc02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrdpc_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdpc[l_ac3].* = g_hrdpc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac3 = ARR_CURR()        # ?板?
           LET l_ac_t = l_ac3            # ?板?

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrdpc[l_ac3].* = g_hrdpc_t.*
              END IF
              CLOSE i083_bcl_3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i083_bcl_3
           COMMIT WORK

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121

        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121

    END INPUT

    CLOSE i083_bcl_3
    CALL cl_set_comp_visible("hrdpc03_a,hrdpc04_a,hrdpc05_a",FALSE)
    COMMIT WORK
    
    SELECT sum(hrdpa05) INTO g_sum1 FROM hrdpa_file WHERE hrdpa01=g_hrdpt.hrdp01
    SELECT sum(hrdpb03) INTO g_sum2 FROM hrdpb_file WHERE hrdpb01=g_hrdpt.hrdp01
    SELECT sum(hrdpc05) INTO g_sum3 FROM hrdpc_file WHERE hrdpc01=g_hrdpt.hrdp01
    IF cl_null(g_sum1) THEN LET g_sum1=0 END IF 
    IF cl_null(g_sum2) THEN LET g_sum2=0 END IF 
    IF cl_null(g_sum3) THEN LET g_sum3=0 END IF 
    LET g_hrdp.hrdp06=g_sum1+g_sum2+g_sum3 
    UPDATE hrdp_file SET hrdp06=g_hrdp.hrdp06 WHERE hrdp04=g_hrdpt.hrdp01
    DISPLAY BY NAME g_hrdp.hrdp06
END FUNCTION

FUNCTION i083_r()

    
   IF s_shut(0) THEN RETURN END IF

   IF g_hrdpt.hrdp01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_hrdp.hrdpacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrdp.hrdp04,9027,0)
      RETURN
   END IF

   BEGIN WORK
   OPEN i083_cl USING g_hrdpt.hrdp01
   IF STATUS THEN
      CALL cl_err("OPEN i803_cl:", STATUS, 1)
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i083_cl INTO g_hrdp.*                 # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrdp.hrdp04,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF cl_delh(0,0) THEN                    #確認一下
      DELETE FROM hrdp_file
       WHERE hrdp01 = g_hrdp.hrdp01
      IF SQLCA.sqlcode THEN 
         CLOSE i083_cl
         ROLLBACK WORK
         RETURN
      END IF 
      DELETE FROM hrdpa_file
       WHERE hrdpa01 = g_hrdp.hrdp01
      IF SQLCA.sqlcode THEN 
         CLOSE i083_cl
         ROLLBACK WORK
         RETURN
      END IF 
      DELETE FROM hrdpb_file
       WHERE hrdpb01 = g_hrdp.hrdp01
      IF SQLCA.sqlcode THEN 
         CLOSE i083_cl
         ROLLBACK WORK
         RETURN
      END IF 
      DELETE FROM hrdpc_file
       WHERE hrdpc01 = g_hrdp.hrdp01
      IF SQLCA.sqlcode THEN 
         CLOSE i083_cl
         ROLLBACK WORK
         RETURN
      END IF 
      INITIALIZE g_hrdp.* TO NULL
      INITIALIZE g_hrdpt.* TO NULL 
      CLEAR FORM
      CALL g_hrdpa.clear()
      CALL g_hrdpb.clear()
      CALL g_hrdpc.clear()
   END IF
   CLOSE i083_cl
   COMMIT WORK
   CALL i083_next()
END FUNCTION

FUNCTION i083_list_fill()
DEFINE l_hrat04   LIKE hrat_file.hrat04
DEFINE l_hrat05   LIKE hrat_file.hrat05
DEFINE l_hrdp04   LIKE hrdp_file.hrdp04
   
 
   LET g_sql = "SELECT hrdp02,hrdp03,hrdp04,hrat02,'','',hrdp06,hrdp07,hrdp09,hrdp08,hrat04,hrat05", #mod by zhangbo130910
               "  FROM hrdp_file LEFT OUTER JOIN hrat_file ON hratid=hrdp04",
               " WHERE ",
               "    ",g_wc,
               " ORDER BY hrdp04"
   PREPARE i083_pb4 FROM g_sql
   DECLARE i083_hrdp CURSOR FOR i083_pb4
   CALL g_hrdpp.clear()
   LET g_cnt = 1

   FOREACH i083_hrdp INTO g_hrdpp[g_cnt].*,l_hrat04,l_hrat05   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT hrao02 INTO g_hrdpp[g_cnt].hrao02 FROM hrao_file WHERE hrao01=l_hrat04
       SELECT hras04 INTO g_hrdpp[g_cnt].hras04 FROM hras_file WHERE hras01=l_hrat05
       SELECT hrat01 INTO g_hrdpp[g_cnt].hrdp04 FROM hrat_file WHERE hratid=g_hrdpp[g_cnt].hrdp04
       LET g_cnt = g_cnt + 1
#       IF g_cnt > g_max_rec THEN
#          CALL cl_err( '', 9035, 0 )
#          EXIT FOREACH
#       END IF
   END FOREACH
   CALL g_hrdpp.deleteElement(g_cnt)
   LET g_rec_b4=g_cnt-1

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdpp TO s_hrdpp.* ATTRIBUTE(COUNT=g_rec_b4)
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION cancel
         LET INT_FLAG=FALSE     
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION ACCEPT 
      	 LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE 
         CALL i083_fetch('/')
         LET g_flag_b='1'
         EXIT DISPLAY 

#      ON ACTION confirm
#         LET l_ac4 = ARR_CURR()
#         CALL i083_confirm1(g_hrdpp[l_ac4].hrdp04)
#         CONTINUE DISPLAY
#
#      ON ACTION undo_confirm
#         LET l_ac4 = ARR_CURR()
#         CALL i083_undo_confirm1(g_hrdpp[l_ac4].hrdp04)
#         CONTINUE DISPLAY

      ON ACTION main
         IF NOT cl_null(l_hrdp04) THEN 
            CALL i083_fetch(l_hrdp04)
         END IF 
         LET g_flag_b='1'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION 

FUNCTION i083_confirm()
DEFINE l_n,l_n1   LIKE type_file.num5 #add by zhuzw 20150130
DEFINE l_hratid LIKE hrat_file.hratid #add by zhuzw 20150130
DEFINE l_hrdp01  LIKE hrdp_file.hrdp01 #add by zhuzw 20150130
DEFINE l_sql STRING #add by zhuzw 20150424
DEFINE l_hrdpb02 LIKE hrdpb_file.hrdpb02 #add by zhuzw 20150424
DEFINE l_hrdpb05 LIKE hrdpb_file.hrdpb05
   IF s_shut(0) THEN RETURN END IF
   IF g_hrdp.hrdp09='003' THEN RETURN END IF 
   IF g_hrdpt.hrdp01 IS NULL THEN RETURN END IF

   IF g_hrdp.hrdpacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrdp.hrdp04,9027,0)
      RETURN
   END IF
#  #add by zhuzw 20150130 start
   SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
   SELECT COUNT(*) INTO l_n FROM hrdp_file 
    WHERE hrdp04 = l_hratid
      AND hrdpud13 > g_hrdp.hrdpud13
   IF l_n >0 THEN 
     # CALL cl_err('已存在大于该调薪生效日期的调薪数据，请维护正确的生效日期','!',0)
     # RETURN
   END IF 
#   #add by zhuzw 20150130 end  
   BEGIN WORK
   OPEN i083_cl USING g_hrdpt.hrdp01
   IF STATUS THEN
      CALL cl_err("OPEN i803_cl:", STATUS, 1)
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i083_cl INTO g_hrdp.*                 # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrdp.hrdp04,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE hrdp_file SET hrdp09='003' WHERE hrdp01=g_hrdp.hrdp01
   IF SQLCA.sqlcode THEN 
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
#add by zhuzw 20150130 start
   ELSE 
   SELECT COUNT(*) INTO l_n FROM hrdp_file 
    WHERE hrdp04 = g_hrdp.hrdp04
      AND hrdpud13 < g_hrdp.hrdpud13 AND hrdpud02 IS NOT NULL AND hrdpud03 IS NOT NULL
   SELECT COUNT(*) INTO l_n1 FROM hrdpc_file
    WHERE hrdpc01 =  g_hrdp.hrdp01   
   IF l_n >0 AND l_n1 >0 THEN 
      SELECT hrdp01 INTO l_hrdp01 FROM hrdp_file 
       WHERE hrdp04 = g_hrdp.hrdp04
         AND hrdpud13= (SELECT MAX(hrdpud13)  FROM hrdp_file 
                         WHERE hrdp04 = g_hrdp.hrdp04
                           AND hrdpud13 < g_hrdp.hrdpud13 )
      UPDATE hrdpc_file SET hrdpc07=g_hrdp.hrdpud13 - 1 WHERE hrdpc01=l_hrdp01 AND hrdpc07='2099/12/31' 
   END IF    	
#add by zhuzw 20150130 end
#add by zhuzw 20150424 start
   LET l_sql = " select hrdpb02,hrdpb05 from hrdpb_file where hrdpb01 = '",g_hrdp.hrdp01,"' "
   PREPARE i083_ud FROM l_sql
   DECLARE i083_uds CURSOR FOR i083_ud
   FOREACH i083_uds INTO l_hrdpb02,l_hrdpb05
      UPDATE hrdpb_file SET hrdpb05=g_hrdp.hrdpud13 - 1 WHERE hrdpb05>= to_date('2099/12/31','yyyy/mm/dd') AND hrdpb02 = l_hrdpb02 AND hrdpb01 IN (SELECT hrdp01 FROM hrdp_file WHERE  hrdp04 = g_hrdp.hrdp04)  AND hrdpb01 != g_hrdp.hrdp01
   END FOREACH   
#add by zhuzw 20150424 end     	     
   END IF 
   CLOSE i083_cl
   COMMIT WORK 
   SELECT hrdp09 INTO g_hrdp.hrdp09 FROM hrdp_file WHERE hrdp01=g_hrdp.hrdp01
   DISPLAY BY NAME g_hrdp.hrdp09
   
END FUNCTION 

FUNCTION i083_undo_confirm()
DEFINE l_n   LIKE type_file.num5 #add by zhuzw 20150130
DEFINE l_hratid LIKE hrat_file.hratid #add by zhuzw 20150130
DEFINE l_hrdp01  LIKE hrdp_file.hrdp01 #add by zhuzw 20150130
   IF s_shut(0) THEN RETURN END IF
   IF g_hrdp.hrdp09='002' THEN RETURN END IF 
   IF g_hrdpt.hrdp01 IS NULL THEN RETURN END IF

   IF g_hrdp.hrdpacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrdp.hrdp04,9027,0)
      RETURN
   END IF
  #add by zhuzw 20150130 start
   SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdp.hrdp04
   SELECT COUNT(*) INTO l_n FROM hrdp_file 
    WHERE hrdp04 = l_hratid
      AND hrdpud13 > g_hrdp.hrdpud13
   #IF l_n >0 THEN 
   #   CALL cl_err('已存在新的调薪数据，旧数据不可取消审核','!',0)
   #   RETURN
   #END IF 
   #add by zhuzw 20150130 end    
   BEGIN WORK
   OPEN i083_cl USING g_hrdpt.hrdp01
   IF STATUS THEN
      CALL cl_err("OPEN i803_cl:", STATUS, 1)
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i083_cl INTO g_hrdp.*                 # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrdp.hrdp04,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE hrdp_file SET hrdp09='002' WHERE hrdp01=g_hrdp.hrdp01
   LET g_hrdpt.hrdp09='002'
   IF SQLCA.sqlcode THEN 
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
#add by zhuzw 20150130 start
   ELSE 
   SELECT COUNT(*) INTO l_n FROM hrdp_file 
    WHERE hrdp04 = g_hrdp.hrdp04
      AND hrdpud13 < g_hrdp.hrdpud13
   IF l_n >0 THEN 
      SELECT hrdp01 INTO l_hrdp01 FROM hrdp_file 
       WHERE hrdp04 = g_hrdp.hrdp04
         AND hrdpud13= (SELECT MAX(hrdpud13)  FROM hrdp_file 
                         WHERE hrdp04 = g_hrdp.hrdp04
                           AND hrdpud13 < g_hrdp.hrdpud13 )
      UPDATE hrdpc_file SET hrdpc07 = to_date('2099/12/31','yyyy/mm/dd') WHERE hrdpc01=l_hrdp01 AND hrdpc07= g_hrdp.hrdpud13 - 1 
   END IF    	
#add by zhuzw 20150130 end 
   END IF 
   CLOSE i083_cl
   COMMIT WORK 
   SELECT hrdp09 INTO g_hrdp.hrdp09 FROM hrdp_file WHERE hrdp01=g_hrdp.hrdp01
   DISPLAY BY NAME g_hrdp.hrdp09
END FUNCTION 

#FUNCTION i083_copy()
#DEFINE l_wc        STRING 
#DEFINE l_hrdp      RECORD LIKE hrdp_file.*
#DEFINE l_hrdpa     RECORD LIKE hrdpa_file.*
#DEFINE l_hrdpb     RECORD LIKE hrdpb_file.*
#DEFINE l_hrdpc     RECORD LIKE hrdpc_file.*
#DEFINE tok         base.StringTokenizer
#DEFINE l_hrdp04    LIKE hrdp_file.hrdp04
#DEFINE l_hrdp04    LIKE hrdp_file.hrdp04
#DEFINE l_sql       STRING 
#DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
#     IF cl_null(g_hrdp.hrdp04) THEN RETURN END IF 
#     IF g_hrdp.hrdpacti='N' THEN RETURN END IF 
#
#     SELECT * INTO l_hrdp.* FROM hrdp_file WHERE hrdp04=g_hrdp.hrdp04
#     LET l_sql="SELECT * FROM hrdpa_file WHERE hrdpa01='",g_hrdp.hrdp04,"' ORDER BY hrdpa02"
#     PREPARE ins_hrdpa_p FROM l_sql
#     DECLARE ins_hrdpa_c CURSOR FOR ins_hrdpa_p
#
#     LET l_sql="SELECT * FROM hrdpb_file WHERE hrdpb01='",g_hrdp.hrdp04,"' ORDER BY hrdpb02"
#     PREPARE ins_hrdpb_p FROM l_sql
#     DECLARE ins_hrdpb_c CURSOR FOR ins_hrdpb_p
#
#     LET l_sql="SELECT * FROM hrdpc_file WHERE hrdpc01='",g_hrdp.hrdp04,"' ORDER BY hrdpc02"
#     PREPARE ins_hrdpc_p FROM l_sql
#     DECLARE ins_hrdpc_c CURSOR FOR ins_hrdpc_p
#     
#     INPUT l_wc WITHOUT DEFAULTS FROM hrdp04
#        BEFORE INPUT
#          CALL cl_qbe_display_condition(lc_qbe_sn)      
#
#       ON ACTION controlp
#          CASE
#            WHEN INFIELD(hrdp04)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_hrat01"
#              LET g_qryparam.state = "c"
#              CALL cl_create_qry() RETURNING l_wc
#              DISPLAY l_wc TO hrdp04
#              NEXT FIELD hrdp04
#          END CASE
#       
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
#       ON ACTION about
#          CALL cl_about()
#       ON ACTION help
#          CALL cl_show_help()
#     END INPUT 
#     BEGIN WORK 
#       LET tok = base.StringTokenizer.create(l_wc,"|")
#       WHILE tok.hasMoreTokens()
#          LET l_hrdp04 = tok.nextToken()
#          #单头
#          
#          SELECT hratid INTO l_hrdp04 FROM hrat_file WHERE hrat01=l_hrdp04
#          LET l_hrdp.hrdp04=l_hrdp04
#          LET l_hrdp.hrdpuser = g_user
#          LET l_hrdp.hrdporiu = g_user
#          LET l_hrdp.hrdporig = g_grup 
#          LET l_hrdp.hrdpgrup = g_grup    
#          LET l_hrdp.hrdpmodu = g_user
#          LET l_hrdp.hrdpacti = 'Y'
#          LET l_hrdp.hrdpdate = g_today
#          INSERT INTO hrdp_file VALUES(l_hrdp.*)     # DISK WRITE
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("ins","hrdp_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",0)
#             ROLLBACK WORK
#             EXIT WHILE
#          END IF
#          #单身一
#          FOREACH ins_hrdpa_c INTO l_hrdpa.*
#          LET l_hrdpa.hrdpa01=l_hrdp.hrdp04
#          INSERT INTO hrdpa_file VALUES(l_hrdpa.*)
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("ins","hrdpa_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",0)
#             ROLLBACK WORK
#             EXIT WHILE
#          END IF
#          END FOREACH 
#          #单身二
#          FOREACH ins_hrdpb_c INTO l_hrdpb.*
#          LET l_hrdpb.hrdpb01=l_hrdp.hrdp04
#          INSERT INTO hrdpb_file VALUES(l_hrdpb.*)
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("ins","hrdpb_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",0)
#             ROLLBACK WORK
#             EXIT WHILE
#          END IF
#          END FOREACH 
#          #单身三
#          FOREACH ins_hrdpc_c INTO l_hrdpc.*
#          LET l_hrdpc.hrdpc01=l_hrdp.hrdp04
#          INSERT INTO hrdpc_file VALUES(l_hrdpc.*)
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("ins","hrdpc_file",g_hrdp.hrdp04,"",SQLCA.sqlcode,"","",0)
#             ROLLBACK WORK
#             EXIT WHILE
#          END IF
#          END FOREACH 
#       END WHILE
#     COMMIT WORK
#     DISPLAY BY NAME g_hrdp.hrdp04
#     CALL cl_err('','ghr-113',1)
#END FUNCTION 

FUNCTION i083_confirm1(p_hrdp04)
DEFINE p_hrdp04  LIKE hrdp_file.hrdp04

   BEGIN WORK
   OPEN i083_cl USING p_hrdp04
   IF STATUS THEN
      CALL cl_err("OPEN i803_cl:", STATUS, 1)
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i083_cl INTO g_hrdp.*                 # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_hrdp04,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE hrdp_file SET hrdp09='003' WHERE hrdp04=p_hrdp04
   IF SQLCA.sqlcode THEN 
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF 
   CLOSE i083_cl
   COMMIT WORK 
   
END FUNCTION 

FUNCTION i083_undo_confirm1(p_hrdp04)
DEFINE p_hrdp04 LIKE hrdp_file.hrdp04

   BEGIN WORK
   OPEN i083_cl USING p_hrdp04
   IF STATUS THEN
      CALL cl_err("OPEN i803_cl:", STATUS, 1)
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i083_cl INTO g_hrdp.*                 # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_hrdp04,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE hrdp_file SET hrdp09='002' WHERE hrdp04=p_hrdp04
   IF SQLCA.sqlcode THEN 
      CLOSE i083_cl
      ROLLBACK WORK
      RETURN
   END IF 
   CLOSE i083_cl
   COMMIT WORK 
END FUNCTION
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i083_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 20131118 By shenran 
#=================================================================#
FUNCTION i083_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrdp01  LIKE hrdp_file.hrdp01,
         hrdp03  LIKE hrdp_file.hrdp03,
         hrdp04  LIKE hrdp_file.hrdp04,
         hrdp05  LIKE hrdp_file.hrdp05,
         hrdp07  LIKE hrdp_file.hrdp07,
         enddate LIKE hrdp_file.hrdp07,
         hrdp08  LIKE hrdp_file.hrdp08,
         hrdp09  LIKE hrdp_file.hrdp09,
         hrdpud02 LIKE hrdp_file.hrdpud02,
         hrdpud03 LIKE hrdp_file.hrdpud03,
         hrdpud13 LIKE hrdp_file.hrdpud13,
         hrdpb02  LIKE hrdpb_file.hrdpb02,
         hrdpb03  LIKE hrdpb_file.hrdpb03
              END RECORD      
DEFINE l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k,li_i_r   LIKE  type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE l_racacti  LIKE rac_file.racacti
DEFINE l_hrat01   LIKE hrat_file.hrat01
DEFINE l_imaacti  LIKE ima_file.imaacti, 
       l_ima02    LIKE ima_file.ima02,
       l_ima25    LIKE ima_file.ima25
DEFINE l_obaacti  LIKE oba_file.obaacti,
       l_oba02    LIKE oba_file.oba02
DEFINE l_tqaacti  LIKE tqa_file.tqaacti,
       l_tqa02    LIKE tqa_file.tqa02,
       l_tqa05    LIKE tqa_file.tqa05,
       l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02    LIKE gfe_file.gfe02
DEFINE l_gfeacti  LIKE gfe_file.gfeacti
DEFINE l_flag     LIKE type_file.num5,
       l_fac      LIKE ima_file.ima31_fac 
DEFINE l_hrde01   LIKE hrde_file.hrde01
DEFINE l_hrde03   LIKE hrde_file.hrde03
DEFINE l_hrde05   LIKE hrde_file.hrde05
DEFINE l_hrde06   LIKE hrde_file.hrde06
DEFINE l_hrdpc07  LIKE hrdpc_file.hrdpc07

   SELECT to_date('20991231','yyyymmdd') INTO l_hrdpc07 FROM dual
   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
      LET l_count =  LENGTH(l_file)
      IF l_count = 0 THEN  
         LET g_success = 'N'
         RETURN 
      END IF 
      INITIALIZE sr.* TO NULL
      LET li_k = 1
      LET li_i_r = 1
      LET g_cnt = 1 
      LET l_sql = l_file
     
      CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
      IF xlApp <> -1 THEN
         LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
         CALL ui.interface.frontCall('WinCOM','CallMethod',
                                     [xlApp,'WorkBooks.Open',l_sql],[iRes])
         IF iRes <> -1 THEN
            CALL ui.interface.frontCall('WinCOM','GetProperty',
                 [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
            IF iRow > 0 THEN  
               LET g_success = 'Y'
               BEGIN WORK  
               CALL s_showmsg_init()
               FOR i = 2 TO iRow             
                  INITIALIZE sr.* TO NULL
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hrdp03])      #调动类型编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrdp04])      #员工工号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrdp05])      #调动原因
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrdp07])      #申请日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrdpud13])    #生效日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[sr.hrdp09])     #审核状态
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrdpud02])   #等级体系编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',13).Value'],[sr.hrdpud03])   #薪资等级编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',15).Value'],[sr.hrdpb02])   #稳定薪资编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',17).Value'],[sr.hrdpb03])   #稳定薪资金额
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',18).Value'],[sr.hrdp08])     #备注
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',19).Value'],[sr.enddate])    #终止日期
                  #add by zhuzw 20150424 start
                  SELECT hratid INTO  sr.hrdp04 FROM hrdp_file
                   WHERE hrat01 = sr.hrdp04
                  #add by zhuzw 2150424 end                    
                  SELECT max(to_number(hrdp01))+1 INTO sr.hrdp01 FROM hrdp_file
                  SELECT to_char(sr.hrdp01,'fm0000000000') INTO sr.hrdp01 FROM DUAL 
                  IF cl_null(sr.hrdpud13) THEN 
                     CALL cl_err( '生效日期为空','!', 1 )
                     CONTINUE FOR
                  END IF 
                  IF cl_null(sr.enddate) THEN
                     SELECT to_date('2099/12/31','yyyy/mm/dd') INTO sr.enddate FROM dual
                  END IF 
                  IF NOT cl_null(sr.hrdp03) AND NOT cl_null(sr.hrdp04) 
                     AND NOT cl_null(sr.hrdp05) AND NOT cl_null(sr.hrdp07) AND NOT cl_null(sr.hrdp09) THEN 
                     LET l_hrat01=sr.hrdp04
                     SELECT hratid INTO sr.hrdp04 FROM hrat_file WHERE hrat01=sr.hrdp04
                     IF i > 1 THEN 
                        INSERT INTO hrdp_file(hrdp01,hrdp02,hrdp03,hrdp04,hrdp05,hrdp06,hrdp07,hrdp08,hrdp09,hrdpud02,hrdpud03,hrdpud13,hrdpacti,hrdpuser,hrdpgrup,hrdpdate,hrdporig,hrdporiu)
                           VALUES (sr.hrdp01,sr.hrdp01,sr.hrdp03,sr.hrdp04,sr.hrdp05,'0',sr.hrdp07,sr.hrdp08,sr.hrdp09,sr.hrdpud02,sr.hrdpud03,sr.hrdpud13,'Y',g_user,g_grup,g_today,g_grup,g_user)
                        IF SQLCA.sqlcode THEN 
                           CALL cl_err3("ins","hrdp_file",sr.hrdp01,'',SQLCA.sqlcode,"","",1)   
                           LET g_success  = 'N'
                           CONTINUE FOR 
                        END IF 
                     END IF  
                     #添加等级薪资明细
                     IF NOT cl_null(sr.hrdpud02) AND NOT cl_null(sr.hrdpud03) THEN
                        UPDATE hrdpc_file SET hrdpc07=sr.hrdpud13 - 1 WHERE hrdpc07>=l_hrdpc07 AND hrdpc01 IN (SELECT hrdp01 FROM hrdp_file WHERE hrdp04=sr.hrdp04)
                        LET l_sql = "SELECT hrde01,hrde03,hrde05,hrde06 FROM hrde_file WHERE hrde03='",sr.hrdpud02,"' AND hrde05='",sr.hrdpud03,"'"
                        PREPARE i083_i0  FROM l_sql
                        DECLARE i083_i0_c CURSOR FOR i083_i0
                        FOREACH i083_i0_c INTO l_hrde01,l_hrde03,l_hrde05,l_hrde06
                           INSERT INTO hrdpc_file (hrdpc01,hrdpc02,hrdpc03,hrdpc04,hrdpc05,hrdpc06,hrdpc07)
                              VALUES(sr.hrdp01,l_hrde01,l_hrde03,l_hrde05,l_hrde06,sr.hrdpud13,sr.enddate)
                        END FOREACH 
                     END IF
                     #添加稳定薪资明细
                     IF NOT cl_null(sr.hrdpb02) AND NOT cl_null(sr.hrdpb03) THEN
                        UPDATE hrdpb_file SET hrdpb05=sr.hrdpud13 - 1 WHERE hrdpb05>=l_hrdpc07 AND hrdpb02=sr.hrdpb02 AND hrdpb01 IN (SELECT hrdp01 FROM hrdp_file WHERE hrdp04=sr.hrdp04)
                        INSERT INTO hrdpb_file (hrdpb01,hrdpb02,hrdpb03,hrdpb04,hrdpb05)
                            VALUES(sr.hrdp01,sr.hrdpb02,sr.hrdpb03,sr.hrdpud13,sr.enddate)
                     END IF 
                  END IF 
               END FOR 
               IF g_success = 'N' THEN 
                  ROLLBACK WORK 
                  CALL s_showmsg() 
               ELSE 
                  IF g_success = 'Y' THEN 
                     COMMIT WORK 
                     CALL cl_err( '导入成功','!', 1 )
                  END IF 
               END IF 
            END IF
         ELSE
            DISPLAY 'NO FILE'
         END IF
      ELSE
         DISPLAY 'NO EXCEL'
      END IF     
      CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
      CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
      
      SELECT * INTO g_hrdp.* FROM hrdp_file
      WHERE hrdp04=sr.hrdp04
      
      CALL i083_show()
   END IF
END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i083_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 20131118 By shenran 
#=================================================================#
FUNCTION i083_import1()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrdpa01  LIKE hrdpa_file.hrdpa01,
         hrdpa02  LIKE hrdpa_file.hrdpa02,
         hrdpa03  LIKE hrdpa_file.hrdpa03,
         hrdpa04  LIKE hrdpa_file.hrdpa04,
         hrdpa05  LIKE hrdpa_file.hrdpa05,
         hrdpa06  LIKE hrdpa_file.hrdpa06,
         hrdpa07  LIKE hrdpa_file.hrdpa07,
         hrdpa08  LIKE hrdpa_file.hrdpa08
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 
      
DEFINE l_hrdpa06    LIKE hrdpa_file.hrdpa06

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow             
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrdpa01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrdpa02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrdpa03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrdpa04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrdpa05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrdpa06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrdpa07])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrdpa08])
                 
                IF NOT cl_null(sr.hrdpa01) AND NOT cl_null(sr.hrdpa02) AND NOT cl_null(sr.hrdpa03) AND NOT cl_null(sr.hrdpa04)  
                	 AND NOT cl_null(sr.hrdpa05) AND NOT cl_null(sr.hrdpa06) AND NOT cl_null(sr.hrdpa07) THEN 
                	 SELECT hratid INTO sr.hrdpa01 FROM hrat_file WHERE hrat01=sr.hrdpa01
                	 IF i > 1 THEN
                    INSERT INTO hrdpa_file(hrdpa01,hrdpa02,hrdpa03,hrdpa04,hrdpa05,hrdpa06,hrdpa07,hrdpa08)
                      VALUES (sr.hrdpa01,sr.hrdpa02,sr.hrdpa03,sr.hrdpa04,sr.hrdpa05,sr.hrdpa06,sr.hrdpa07,sr.hrdpa08)
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrdpa_file",sr.hrdpa01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                     ELSE 
                     UPDATE hrdp_file SET hrdp06= hrdp06 + sr.hrdpa05
                     	WHERE hrdp04=sr.hrdpa01
                     SELECT COUNT(*) INTO g_sr FROM hrdpa_file
                     WHERE hrdpa01=sr.hrdpa01 AND hrdpa02=sr.hrdpa02
                     LET l_hrdpa06=' '
                     IF g_sr>1 THEN 
                       SELECT MAX(hrdpa06) INTO l_hrdpa06 FROM hrdpa_file 
                        WHERE hrdpa01=sr.hrdpa01 
                        AND hrdpa02=sr.hrdpa02
                        AND hrdpa06<>sr.hrdpa06
                       IF l_hrdpa06 < sr.hrdpa06 THEN 
                     	  UPDATE hrdpa_file SET hrdpa07=sr.hrdpa06-1
                     	  WHERE hrdpa01=sr.hrdpa01 
                     	  AND hrdpa02=sr.hrdpa02
                     	  AND hrdpa06=l_hrdpa06
                     	 END IF 
                     END IF 
                    END IF 
                   END IF 
                END IF 
                  # LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                   COMMIT WORK 
                   CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
       SELECT * INTO g_hrdp.* FROM hrdp_file
       WHERE hrdp04=sr.hrdpa01
       
       CALL i083_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------
#TQC-AC0326 add --------------------end-----------------------
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i083_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 20131118 By shenran 
#=================================================================#
FUNCTION i083_import2()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrdpb01  LIKE hrdpb_file.hrdpb01,
         hrdpb02  LIKE hrdpb_file.hrdpb02,
         hrdpb03  LIKE hrdpb_file.hrdpb03,
         hrdpb04  LIKE hrdpb_file.hrdpb04,
         hrdpb05  LIKE hrdpb_file.hrdpb05,
         hrdpb06  LIKE hrdpb_file.hrdpb06
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 
       
DEFINE l_hrdpb04    LIKE hrdpb_file.hrdpb04

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
      LET l_count =  LENGTH(l_file)
      IF l_count = 0 THEN  
         LET g_success = 'N'
         RETURN 
      END IF 
      INITIALIZE sr.* TO NULL
      LET li_k = 1
      LET li_i_r = 1
      LET g_cnt = 1 
      LET l_sql = l_file
     
      CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                  ['Excel.Application'],[xlApp])
      IF xlApp <> -1 THEN
         LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
         CALL ui.interface.frontCall('WinCOM','CallMethod',
                                     [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                   # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

         IF iRes <> -1 THEN
            CALL ui.interface.frontCall('WinCOM','GetProperty',
                 [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
            IF iRow > 0 THEN  
               LET g_success = 'Y'
               BEGIN WORK  
#               CALL s_errmsg_init()
               CALL s_showmsg_init()
               CALL cl_progress_bar(iROW)
               FOR i = 1 TO iRow             
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrdpb01])
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrdpb02])
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrdpb03])
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrdpb04])
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrdpb05])
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrdpb06])
                  CALL cl_progressing(sr.hrdpb01) 
                  IF NOT cl_null(sr.hrdpb01) AND NOT cl_null(sr.hrdpb02) AND NOT cl_null(sr.hrdpb03) AND NOT cl_null(sr.hrdpb04)  
                  	 AND NOT cl_null(sr.hrdpb05) THEN 
                     SELECT hratid INTO sr.hrdpb01 FROM hrat_file WHERE hrat01=sr.hrdpb01
                  	LET l_flag = 0
                  	LET l_data = ''
                  	SELECT COUNT(*) INTO l_flag FROM hrdh_file WHERE hrdh03='004' AND hrdh01=sr.hrdpb02
                  	IF l_flag = 0 THEN 
                  	   LET l_data = '编号',sr.hrdpb02,'稳定项目不存在'
                  	   CALL cl_err(l_data,'!',1) 
                  	END IF 
                  	IF i > 1 AND l_flag > 0 THEN
                        INSERT INTO hrdpb_file(hrdpb01,hrdpb02,hrdpb03,hrdpb04,hrdpb05,hrdpb06)
                          VALUES (sr.hrdpb01,sr.hrdpb02,sr.hrdpb03,sr.hrdpb04,sr.hrdpb05,sr.hrdpb06)
                        IF SQLCA.sqlcode THEN 
                           CALL cl_err3("ins","hrdpb_file",sr.hrdpb01,'',SQLCA.sqlcode,"","",1)   
                           LET g_success  = 'N'
                           CONTINUE FOR
                        ELSE 
                         	UPDATE hrdp_file SET hrdp06= hrdp06 + sr.hrdpb03
                         	WHERE hrdp04=sr.hrdpb01
                         	SELECT COUNT(*) INTO g_sr FROM hrdpb_file WHERE hrdpb01=sr.hrdpb01 AND hrdpb02=sr.hrdpb02
                           LET l_hrdpb04=' '
                           IF g_sr>1 THEN 
                              SELECT MAX(hrdpb04) INTO l_hrdpb04 FROM hrdpb_file 
                              WHERE hrdpb01=sr.hrdpb01 
                              AND hrdpb02=sr.hrdpb02
                              AND hrdpb04<>sr.hrdpb04
                           IF l_hrdpb04 < sr.hrdpb04 THEN 
                           	UPDATE hrdpb_file SET hrdpb05=sr.hrdpb04-1
                           	WHERE hrdpb01=sr.hrdpb01 
                         	   AND hrdpb02=sr.hrdpb02
                         	   AND hrdpb04=l_hrdpb04
                           END IF
                         END IF  
                        END IF 
                     END IF 
                  END IF 
                 # LET i = i + 1
                 # LET l_ac = g_cnt 
               END FOR 
               IF g_success = 'N' THEN 
                  ROLLBACK WORK 
                  CALL s_showmsg() 
               ELSE 
                  IF g_success = 'Y' THEN 
                     COMMIT WORK
                     CALL cl_err( '导入成功','!', 1 )
                  END IF 
               END IF 
           END IF
         ELSE 
             DISPLAY 'NO FILE'
         END IF
      ELSE
      	DISPLAY 'NO EXCEL'
      END IF     
      CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
      CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
      
      SELECT * INTO g_hrdp.* FROM hrdp_file
      WHERE hrdp04=sr.hrdpb01
      
      CALL i083_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------
#TQC-AC0326 add --------------------end-----------------------
#TQC-AC0326 add --------------------end-----------------------
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i083_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 20131118 By shenran 
#=================================================================#
FUNCTION i083_import3()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrdpc01  LIKE hrdpc_file.hrdpc01,
         hrdpc02  LIKE hrdpc_file.hrdpc02,
         hrdpc03  LIKE hrdpc_file.hrdpc03,
         hrdpc04  LIKE hrdpc_file.hrdpc04,
         hrdpc05  LIKE hrdpc_file.hrdpc05,
         hrdpc06  LIKE hrdpc_file.hrdpc06,
         hrdpc07  LIKE hrdpc_file.hrdpc07,
         hrdpc08  LIKE hrdpc_file.hrdpc08
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 
DEFINE l_hrdpc06   LIKE hrdpc_file.hrdpc06


   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow             
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrdpc01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrdpc02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrdpc03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrdpc04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrdpc06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrdpc07])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrdpc08])
                 
                IF NOT cl_null(sr.hrdpc01) AND NOT cl_null(sr.hrdpc02) AND NOT cl_null(sr.hrdpc03) AND NOT cl_null(sr.hrdpc04)  
                	  AND NOT cl_null(sr.hrdpc06) AND NOT cl_null(sr.hrdpc07) THEN 
                	 SELECT hratid INTO sr.hrdpc01 FROM hrat_file WHERE hrat01=sr.hrdpc01
                	 SELECT hrde06 INTO sr.hrdpc05 FROM hrde_file WHERE hrde03=sr.hrdpc03  AND hrde05=sr.hrdpc04 AND hrde01=sr.hrdpc02
                	 IF cl_null(sr.hrdpc05) THEN LET sr.hrdpc05='0' END IF  
                	 IF i > 1 THEN
                    INSERT INTO hrdpc_file(hrdpc01,hrdpc02,hrdpc03,hrdpc04,hrdpc05,hrdpc06,hrdpc07,hrdpc08)
                      VALUES (sr.hrdpc01,sr.hrdpc02,sr.hrdpc03,sr.hrdpc04,sr.hrdpc05,sr.hrdpc06,sr.hrdpc07,sr.hrdpc08)
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrdpc_file",sr.hrdpc01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                     ELSE 
                     UPDATE hrdp_file SET hrdp06= hrdp06 + sr.hrdpc05
                     	WHERE hrdp04=sr.hrdpc01
                     SELECT COUNT(*) INTO g_sr FROM hrdpc_file
                     WHERE hrdpc01=sr.hrdpc01 AND hrdpc02=sr.hrdpc02
                     LET l_hrdpc06=' '
                     IF g_sr>1 THEN 
                       SELECT MAX(hrdpc06) INTO l_hrdpc06 FROM hrdpc_file 
                        WHERE hrdpc01=sr.hrdpc01 
                        AND hrdpc02=sr.hrdpc02
                        AND hrdpc06<>sr.hrdpc06
                       IF l_hrdpc06 < sr.hrdpc06 THEN 
                     	  UPDATE hrdpc_file SET hrdpc07=sr.hrdpc06-1
                     	  WHERE hrdpc01=sr.hrdpc01 
                     	  AND hrdpc02=sr.hrdpc02
                     	  AND hrdpc06=l_hrdpc06
                     	 END IF 
                     END IF 
                    END IF 
                   END IF 
                END IF 
                  # LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
       SELECT * INTO g_hrdp.* FROM hrdp_file
       WHERE hrdp04=sr.hrdpc01
       
       CALL i083_show()
   END IF 

END FUNCTION 
#add by zhuzw 20150120 start
FUNCTION i083_b_fill_p1()
DEFINE l_cnt LIKE type_file.num5
   LET g_sql = "SELECT hrdp02,hrdpa02,hrdpa06,hrdpa07,hrdpa03,hrcyb04,",
               "       hrdpa04,hrcyb05,hrdpa05,hrdpa08",
               "  FROM hrdpa_file LEFT OUTER JOIN hrcyb_file ",
               "    ON hrcyb01=hrdpa02 and hrcyb02=hrdpa03 and hrcyb03=hrdpa04",
               "  ,hrdp_file ",            
               " WHERE hrdp04 = '",g_hrdpt.hrdp04,"'",
               "   AND hrdpa01 = hrdp01 ", 
               " ORDER BY 1 "
   PREPARE i083_pbh FROM g_sql
   DECLARE i083_hrdpah CURSOR FOR i083_pbh
   CALL g_hrdpa_h.clear()
   LET l_cnt = 1

   FOREACH i083_hrdpah INTO g_hrdpa_h[l_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrdpa_h.deleteElement(l_cnt)
   LET g_rec_b_h=l_cnt-1
END FUNCTION
FUNCTION i083_b_fill_p2()
DEFINE l_cnt LIKE type_file.num5
   LET g_sql = "SELECT hrdp02,hrdpb02,hrdpb03,hrdpb04,hrdpb05,hrdpb06",
               "  FROM hrdpb_file,hrdp_file",
               " WHERE hrdp04 = '",g_hrdpt.hrdp04,"'",
               "   AND hrdpb01 = hrdp01 ", 
               " ORDER BY 1 "
   PREPARE i083_pbg FROM g_sql
   DECLARE i083_hrdpbg CURSOR FOR i083_pbg
   CALL g_hrdpb_g.clear()
   LET l_cnt = 1

   FOREACH i083_hrdpbg INTO g_hrdpb_g[l_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT hrdh06 INTO g_hrdpb_g[l_cnt].hrdpb02 FROM hrdh_file 
        WHERE hrdh01 = g_hrdpb_g[l_cnt].hrdpb02
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrdpb_g.deleteElement(l_cnt)
   LET g_rec_b_g=l_cnt-1
END FUNCTION
FUNCTION i083_b_fill_p3()
DEFINE l_cnt LIKE type_file.num5
   LET g_sql = "SELECT hrdp02,hrdpc02,hrdpc03,hrdpc04,hrdpc05,",
               "       hrdpc06,hrdpc07,hrdpc08 ",
               "  FROM hrdpc_file,hrdp_file ",
               " WHERE hrdp04 = '",g_hrdpt.hrdp04,"'",
               "   AND hrdpc01 = hrdp01 ", 
               " ORDER BY 1 "
   PREPARE i083_pbk FROM g_sql
   DECLARE i083_hrdpck CURSOR FOR i083_pbk
   CALL g_hrdpc_k.clear()
   LET l_cnt = 1

   FOREACH i083_hrdpck INTO g_hrdpc_k[l_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF 
       SELECT hrde02 INTO g_hrdpc_k[l_cnt].hrdpc02 FROM hrde_file 
        WHERE hrde01 = g_hrdpc_k[l_cnt].hrdpc02     
       SELECT hrag07 INTO  g_hrdpc_k[l_cnt].hrdpc04 FROM hrag_file 
        WHERE hrag01 = '648'
          AND hrag06 = g_hrdpc_k[l_cnt].hrdpc04
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrdpc_k.deleteElement(l_cnt)
   LET g_rec_b_k=l_cnt-1
END FUNCTION
FUNCTION i083_bp4(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdpa_h TO s_h.* ATTRIBUTE(COUNT=g_rec_b_h)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index,g_row_count )
                 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
                 
      ON ACTION first
         CALL i083_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i083_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i083_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i083_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i083_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
        
      ON ACTION detail
         LET l_ac1=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac1=1
         LET g_action_choice="detail"
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

      ON ACTION page04
         LET g_flag_b='2'
         EXIT DISPLAY

      ON ACTION page05
         LET g_flag_b='3'
         EXIT DISPLAY 
      ON ACTION p1
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p2
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p3
         LET g_flag_b='5'
         EXIT DISPLAY 
      ON ACTION p4
         LET g_flag_b='6'
         EXIT DISPLAY                            
      ON ACTION page03
         LET g_flag_b='1'
         EXIT DISPLAY
      ON ACTION main
         LET g_flag_b='1'
         EXIT DISPLAY 
      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY
    #  ON ACTION import1
    #     LET g_action_choice="import1"
    #     EXIT DISPLAY
    #  ON ACTION import2
    #     LET g_action_choice="import2"
    #     EXIT DISPLAY
    #  ON ACTION import3
    #     LET g_action_choice="import3"
    #     EXIT DISPLAY
      ON ACTION item_list
         LET g_action_choice="item_list"
         EXIT DISPLAY
         
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
FUNCTION i083_bp5(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdpb_g TO s_h1.* ATTRIBUTE(COUNT=g_rec_b_g)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index,g_row_count )
                 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
                 
      ON ACTION first
         CALL i083_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i083_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i083_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i083_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i083_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
       
      ON ACTION detail
         LET l_ac1=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac1=1
         LET g_action_choice="detail"
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

      ON ACTION page04
         LET g_flag_b='2'
         EXIT DISPLAY

      ON ACTION page05
         LET g_flag_b='3'
         EXIT DISPLAY 
      ON ACTION p1
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p2
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p3
         LET g_flag_b='5'
         EXIT DISPLAY 
      ON ACTION p4
         LET g_flag_b='6'
         EXIT DISPLAY 
      ON ACTION page03
         LET g_flag_b='1'
         EXIT DISPLAY
      ON ACTION main
         LET g_flag_b='1'
         EXIT DISPLAY 
      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY
   #   ON ACTION import1
   #      LET g_action_choice="import1"
   #      EXIT DISPLAY
   #   ON ACTION import2
   #      LET g_action_choice="import2"
   #      EXIT DISPLAY
   #   ON ACTION import3
   #      LET g_action_choice="import3"
   #      EXIT DISPLAY
      ON ACTION item_list
         LET g_action_choice="item_list"
         EXIT DISPLAY
         
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
FUNCTION i083_bp6(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdpc_k TO s_h2.* ATTRIBUTE(COUNT=g_rec_b_k)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index,g_row_count )
                 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
                 
      ON ACTION first
         CALL i083_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i083_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i083_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i083_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i083_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
       
      ON ACTION detail
         LET l_ac1=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac1=1
         LET g_action_choice="detail"
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

      ON ACTION page04
         LET g_flag_b='2'
         EXIT DISPLAY

      ON ACTION page05
         LET g_flag_b='3'
         EXIT DISPLAY 
      ON ACTION p1
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p2
         LET g_flag_b='4'
         EXIT DISPLAY 
      ON ACTION p3
         LET g_flag_b='5'
         EXIT DISPLAY 
      ON ACTION p4
         LET g_flag_b='6'
         EXIT DISPLAY 
      ON ACTION page03
         LET g_flag_b='1'
         EXIT DISPLAY
      ON ACTION main
         LET g_flag_b='1'
         EXIT DISPLAY         
      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY
  #    ON ACTION import1
  #       LET g_action_choice="import1"
  #       EXIT DISPLAY
  #    ON ACTION import2
  #       LET g_action_choice="import2"
  #       EXIT DISPLAY
  #    ON ACTION import3
  #       LET g_action_choice="import3"
  #       EXIT DISPLAY
      ON ACTION item_list
         LET g_action_choice="item_list"
         EXIT DISPLAY
         
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
