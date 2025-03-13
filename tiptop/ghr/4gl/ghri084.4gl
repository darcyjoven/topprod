# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri084.4gl 
# Descriptions...: 排班信息作业
# Date & Author..: 13/06/28 jiangxt


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrdq       DYNAMIC ARRAY OF RECORD
        hrdq03_a    LIKE hrdq_file.hrdq03,
        hrdq04_a    LIKE hrdq_file.hrdq04,
        hrdq05      LIKE hrdq_file.hrdq05,
        hrdq12      LIKE hrdq_file.hrdq12,
        hrdq13      LIKE hrdq_file.hrdq13,
        hrdq06      LIKE hrdq_file.hrdq06,
        hrdq07      LIKE hrdq_file.hrdq07,
        hrdq08      LIKE hrdq_file.hrdq08,
        hrdq09      LIKE hrdq_file.hrdq09,
        hrdq10      LIKE hrdq_file.hrdq10
                    END RECORD 
DEFINE g_wc         STRING
DEFINE g_cnt        LIKE type_file.num10  
DEFINE g_rec_b      LIKE type_file.num5
DEFINE g_bdate      LIKE type_file.dat
DEFINE g_edate      LIKE type_file.dat
DEFINE g_hrdq02     LIKE hrdq_file.hrdq02
DEFINE g_sql        STRING
DEFINE l_bdate      LIKE type_file.dat
DEFINE l_edate      LIKE type_file.dat

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW i084_w WITH FORM "ghr/42f/ghri084"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL i084_menu()

   CLOSE WINDOW i084_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i084_cs()
DEFINE lc_qbe_sn  LIKE gbm_file.gbm01
    CLEAR FORM
    INPUT g_hrdq02,g_bdate,g_edate WITHOUT DEFAULTS FROM hrdq02,bdate,edate
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
          LET g_bdate=g_today
          LET g_edate=g_today
          DISPLAY g_bdate TO bdate
          DISPLAY g_edate TO edate

       AFTER FIELD hrdq02
          IF cl_null(g_hrdq02) THEN 
             NEXT FIELD hrdq02 
          END IF 
          
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

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    
    CONSTRUCT BY NAME g_wc ON hrdq03
        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION CONTROLP
          CASE
            WHEN INFIELD(hrdq03)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              CASE g_hrdq02
                WHEN '1'
                  LET g_qryparam.form  = "q_hrat01"
                WHEN '2'
                  LET g_qryparam.form  = "q_hrao01"
                WHEN '3'
                  LET g_qryparam.form  = "q_hraa01"
                WHEN '4'
                  LET g_qryparam.form  = "q_hrcb"
                OTHERWISE
                  NEXT FIELD hrca02
              END CASE
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrdq03
              NEXT FIELD hrdq03
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdquser', 'hrdqgrup')
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    IF g_hrdq02='1' THEN 
       LET g_wc=cl_replace_str(g_wc,"hrdq03","hrat01")
    END IF
END FUNCTION

FUNCTION i084_menu()

   WHILE TRUE
      CALL i084_bp("G")
      CASE g_action_choice
         WHEN "pinsert"
            IF cl_chk_act_auth() THEN
               CALL i084_insert()
            END IF 
            
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i084_q()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdq),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i084_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdq TO s_hrdq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( 1,1 )
         IF g_rec_b=0 THEN 
            CLEAR FORM
         END IF 
         
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION pinsert
         LET g_action_choice="pinsert"
         EXIT DISPLAY
              
      ON ACTION query
         LET g_action_choice="query"
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

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about                #MOD-4C0121
         CALL cl_about()             #MOD-4C0121
          
      ON ACTION exporttoexcel        #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i084_q()

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i084_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF 
    CALL i084_b_fill()
END FUNCTION

FUNCTION i084_b_fill()

   LET g_sql = "SELECT hrdq03,hrdq04,hrdq05,hrdq12,hrdq13,",
               "  hrdq06,hrdq07,hrdq08,hrdq09,hrdq10",
               "  FROM hrdq_file LEFT OUTER JOIN hrat_file ON hratid=hrdq03",
               " WHERE hrdq05 >= '",g_bdate,"'",
               "   AND hrdq05 <= '",g_edate,"'",
               "   AND hrdq02 =  '",g_hrdq02,"'",
               "   AND ",g_wc,
               " ORDER BY hrdq01"

   PREPARE i084_pb FROM g_sql
   DECLARE i084_cb CURSOR FOR i084_pb

   CALL g_hrdq.clear()
   LET g_cnt = 1

   FOREACH i084_cb INTO g_hrdq[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT hrat01 INTO g_hrdq[g_cnt].hrdq03_a FROM hrat_file
        WHERE hratid = g_hrdq[g_cnt].hrdq03_a
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrdq.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION i084_insert()
DEFINE lc_qbe_sn  LIKE gbm_file.gbm01
DEFINE l_max_date LIKE type_file.dat
DEFINE l_msg      STRING 

      OPEN WINDOW i084_w1 WITH FORM "ghr/42f/ghri0841"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_init()
      
      INPUT l_bdate,l_edate WITHOUT DEFAULTS FROM bdate,edate
        BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
          SELECT max(hrdq05)+1 INTO l_max_date FROM hrdq_file
          IF cl_null(l_max_date) THEN 
             LET l_bdate=g_today
          ELSE
             LET l_bdate=l_max_date
          END IF 
          LET l_edate=l_bdate+45
          DISPLAY l_bdate TO bdate
          DISPLAY l_edate TO edate

       AFTER FIELD bdate
          IF NOT cl_null(l_max_date) THEN 
             IF l_bdate >l_max_date THEN 
                CALL cl_err('','ghr-123',0)
                NEXT FIELD bdate
             END IF 
          END IF 
          
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

      IF INT_FLAG THEN
         CLOSE WINDOW i084_w1
         RETURN
      END IF

      LET l_msg="ghrp084 Y '",l_bdate,"' '",l_edate,"'"
      CALL cl_cmdrun(l_msg)
      CLOSE WINDOW i084_w1
END FUNCTION 
