# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: cecq002.4gl
# Descriptions...: 消耗性料号使用配比表q查询
# Date & Author..: 16/05/06 By guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm    RECORD                                       
         wc       LIKE type_file.chr1000
       END RECORD
DEFINE g_tc_eca DYNAMIC ARRAY OF RECORD
         tc_eca01   LIKE tc_eca_file.tc_eca01,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         tc_eca02   LIKE tc_eca_file.tc_eca02,
         ecu03      LIKE ecu_file.ecu03,
         tc_eca04   LIKE tc_eca_file.tc_eca04,
         tc_eca05   LIKE tc_eca_file.tc_eca05,
         ima02_1    LIKE ima_file.ima02,
         ima021_1   LIKE ima_file.ima021,
         tc_ecb01   LIKE tc_ecb_file.tc_ecb01,
         tc_ecb02   LIKE tc_ecb_file.tc_ecb02,
         tc_ecb03   LIKE tc_ecb_file.tc_ecb03,
         tc_ecb05   LIKE tc_ecb_file.tc_ecb05
       END RECORD
DEFINE f        ui.Form
DEFINE PAGE     om.DomNode
DEFINE w        ui.Window
DEFINE g_sql    STRING
DEFINE g_cnt    LIKE type_file.num5
DEFINE g_cnt1   LIKE type_file.num5
DEFINE g_cnt2   LIKE type_file.num5
DEFINE l_ac     LIKE type_file.num5
DEFINE g_rec_b  LIKE type_file.num5
DEFINE g_rec_b1 LIKE type_file.num5
DEFINE g_rec_b2 LIKE type_file.num5
DEFINE g_action_flag LIKE type_file.chr5 
DEFINE l_sta    LIKE type_file.chr5
DEFINE l_no     LIKE type_file.chr100

MAIN   

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127

   
   INITIALIZE tm.* TO NULL

   LET g_bgjob = ARG_VAL(1)
   
   LET g_action_flag='page1'
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      OPEN WINDOW q002_w AT 2,18 WITH FORM "cec/42f/cecq002"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      CALL q002_tm()
      CALL q002()   
   END IF 

   CALL q002_menu()
   CLOSE WINDOW q002_w              
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q002_menu()
    WHILE TRUE
      CALL q002_bp()
      
      CASE g_action_choice
         WHEN "page1"
            CALL q002_bp()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q002_tm()
               LET g_action_choice = " "
            END IF
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
            LET g_action_choice = " " 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_eca),'','')
              LET g_action_choice = " " 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q002_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01  

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   CLEAR FORM   
   CALL g_tc_eca.clear()
   LET tm.wc=NULL 
   

      CONSTRUCT tm.wc ON tc_eca01,tc_eca02,tc_eca04,tc_eca05,tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb05
                    FROM s_tc_eca[1].tc_eca01,s_tc_eca[1].tc_eca02,s_tc_eca[1].tc_eca04,
                         s_tc_eca[1].tc_eca05,s_tc_eca[1].tc_ecb01,s_tc_eca[1].tc_ecb02,
                         s_tc_eca[1].tc_ecb03,s_tc_eca[1].tc_ecb05
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP 
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE 
         WHEN INFIELD(tc_eca01)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_tc_ecu01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_eca01
               NEXT FIELD tc_eca01
         WHEN INFIELD(tc_eca02)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_tc_ecv03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_eca02
               NEXT FIELD tc_eca02
         WHEN INFIELD(tc_eca05)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima011"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_eca05
               NEXT FIELD tc_eca05
         END CASE 
         
      ON ACTION qbe_select
         CALL cl_qbe_select()
    END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   CALL q002()
   ERROR ""
END FUNCTION
 
FUNCTION q002()
   
   CALL q002_b_fill() 
END FUNCTION


FUNCTION q002_bp()

   DISPLAY g_rec_b TO formonly.cn2

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_eca TO s_tc_eca.* ATTRIBUTE(COUNT=g_rec_b)    
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY  
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY  
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         EXIT DISPLAY  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
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
         
      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_action_flag = 'page2'
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q002_b_fill()
DEFINE l_x   LIKE type_file.num20_6 

   LET g_sql ="SELECT tc_eca01,a.ima02,a.ima021,tc_eca02,ecu03,tc_eca04,tc_eca05,b.ima02,b.ima021,",
              "       tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb05",
              "  FROM tc_eca_file LEFT JOIN ima_file a ON a.ima01 = tc_eca01",
              "                   LEFT JOIN ima_file b ON b.ima01 = tc_eca05",
              "                   LEFT JOIN ecu_file ON ecu02 = tc_eca02 AND ecu01 = tc_eca01,",
              "       tc_ecb_file,pmn_file",
              " WHERE tc_eca05 = tc_ecb04",
              "   AND tc_eca01 = pmn04",
              "   AND tc_eca04 = pmnud02",
              "   AND pmn01 = tc_ecb02",
              "   AND pmn02 = tc_ecb03",
              "   AND ",tm.wc CLIPPED,
              "   union all",
              "  SELECT tc_eca01,a.ima02,a.ima021,tc_eca02,ecu03,tc_eca04,tc_eca05,b.ima02,b.ima021,",
              "         tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb05",
              "    FROM tc_eca_file LEFT JOIN ima_file a ON a.ima01 = tc_eca01",
              "                   LEFT JOIN ima_file b ON b.ima01 = tc_eca05",
              "                   LEFT JOIN ecu_file ON ecu02 = tc_eca02 AND ecu01 = tc_eca01,",
              "       tc_ecb_file,pmn_file,rvb_file",
              " WHERE tc_eca05 = tc_ecb04",
              "   AND tc_eca01 = pmn04",
              "   AND tc_eca04 = pmnud02",
              "   AND rvb01 = tc_ecb02",
              "   AND rvb02 = tc_ecb03",
              "   AND rvb04 = pmn01",
              "   AND rvb03 = pmn02",
              "   AND ",tm.wc CLIPPED, 
              " ORDER by tc_eca01"

   PREPARE q002_pb1 FROM g_sql
   DECLARE oeb_curs1 CURSOR FOR q002_pb1 
   
   CALL g_tc_eca.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH oeb_curs1 INTO g_tc_eca[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      END IF
   END FOREACH

   CALL g_tc_eca.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
END FUNCTION