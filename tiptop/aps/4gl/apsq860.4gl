# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsq860.4gl
# Descriptions...: APS供給與需求單據追溯查詢
# Date & Author..: #FUN-9B0084 09/11/18 By Mandy
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
     g_voq           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables) #FUN-9B0084
        voq01       LIKE voq_file.voq01,   
        voq02       LIKE voq_file.voq02,   
        voq05       LIKE voq_file.voq05,   
        voq07       LIKE voq_file.voq07,   
        voq04       LIKE voq_file.voq04,   
        voq10       LIKE voq_file.voq10,   
        voq03       LIKE voq_file.voq03,   
        pmk01       LIKE pmk_file.pmk01,   
        voq06       LIKE voq_file.voq06,   
        voq09       LIKE voq_file.voq09,   
        voq08       LIKE voq_file.voq08
                    END RECORD,
    g_voq_t         RECORD                 #程式變數 (舊值)
        voq01       LIKE voq_file.voq01,   
        voq02       LIKE voq_file.voq02,   
        voq05       LIKE voq_file.voq05,   
        voq07       LIKE voq_file.voq07,   
        voq04       LIKE voq_file.voq04,   
        voq10       LIKE voq_file.voq10,   
        voq03       LIKE voq_file.voq03,   
        pmk01       LIKE pmk_file.pmk01,   
        voq06       LIKE voq_file.voq06,   
        voq09       LIKE voq_file.voq09,   
        voq08       LIKE voq_file.voq08
                    END RECORD,
    g_wc2,g_sql    string,  
    g_rec_b         LIKE type_file.num5,     
    l_ac            LIKE type_file.num5     

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_i          LIKE type_file.num5     
DEFINE l_table      STRING                  
DEFINE g_str        STRING                  
DEFINE g_argv1      LIKE voq_file.voq05
DEFINE g_voq05      LIKE voq_file.voq05
DEFINE g_db_type    LIKE type_file.chr3 


MAIN
DEFINE p_row,p_col   LIKE type_file.num5     
    #FUN-B50050---mod---str---
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    #FUN-B50050---mod---end---

   LET g_argv1 = ARG_VAL(1)
   LET g_voq05 = g_argv1

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
   LET p_row = 5 LET p_col = 22
   OPEN WINDOW q860_w AT p_row,p_col WITH FORM "aps/42f/apsq860"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
   
   CALL cl_ui_init()
   IF NOT cl_null(g_voq05) THEN
       LET g_db_type = DB_GET_DATABASE_TYPE()
       IF g_db_type = 'ORA' THEN
           LET g_wc2 = " voq05 LIKE    '",g_voq05 CLIPPED,"%'"
       ELSE
           LET g_wc2 = " voq05 MATCHES '",g_voq05 CLIPPED,"*'"
       END IF
       CALL q860_b_fill(g_wc2)
   END IF
   CALL q860_menu()
   CLOSE WINDOW q860_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN

FUNCTION q860_menu()

   WHILE TRUE
      CALL q860_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q860_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
              CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_voq),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION




FUNCTION q860_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   

    LET g_sql =
        "SELECT voq01,voq02,voq05,voq07,voq04, ",
        "       voq10,voq03,''   ,voq06,voq09, ",
        "       voq08 ",
        " FROM voq_file ",
        " WHERE voq00 = '",g_plant,"'",
        "   AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY voq01,voq02,voq05,voq07,voq04,voq03,voq09"
    PREPARE q860_pb FROM g_sql
    DECLARE voq_curs CURSOR FOR q860_pb

    CALL g_voq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH voq_curs INTO g_voq[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_voq[g_cnt].voq04 = 'M' THEN 
            #M:工單
            SELECT sfb01 
              INTO g_voq[g_cnt].pmk01
              FROM sfb_file
             WHERE sfb222 = g_voq[g_cnt].voq03
        ELSE
            #P:採購
            SELECT pml01 
              INTO g_voq[g_cnt].pmk01
              FROM pml_file
             WHERE pml05 = g_voq[g_cnt].voq03
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_voq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION

FUNCTION q860_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No:FUN-680102 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_voq TO s_voq.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
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

      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q860_q()
   CALL q860_b_askkey()
END FUNCTION

FUNCTION q860_b_askkey()

    CLEAR FORM
    CALL g_voq.clear()

    CONSTRUCT g_wc2 ON voq01,voq02,voq05,voq07,voq04,
                       voq10,voq03,voq06,voq09,voq08      
         FROM s_voq[1].voq01,s_voq[1].voq02,s_voq[1].voq05,
              s_voq[1].voq07,s_voq[1].voq04,s_voq[1].voq10,
              s_voq[1].voq03,s_voq[1].voq06,s_voq[1].voq09,
              s_voq[1].voq08

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION controlp
             CASE 
                  WHEN INFIELD(voq01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_voq01"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_plant
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_voq[1].voq01
                     NEXT FIELD voq01
                  WHEN INFIELD(voq02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_voq02"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_plant
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_voq[1].voq02
                     NEXT FIELD voq02
                  WHEN INFIELD(voq03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_voq03"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_plant
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_voq[1].voq03
                     NEXT FIELD voq03
                  WHEN INFIELD(voq05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_voq05"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_plant
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_voq[1].voq05
                     NEXT FIELD voq05
                  WHEN INFIELD(voq09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_voq09"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_plant
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_voq[1].voq09
                     NEXT FIELD voq09
                  OTHERWISE
                     EXIT CASE
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

   IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
   END IF

   CALL q860_b_fill(g_wc2)

END FUNCTION
