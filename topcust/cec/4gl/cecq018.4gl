# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: cecq018.4gl
# Descriptions...: 消耗性料号使用配比表q查询
# Date & Author..: 16/05/06 By guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm    RECORD                                # Print condition RECORD
         b_date   LIKE type_file.dat,
         e_date   LIKE type_file.dat,         
         wc       LIKE type_file.chr1000
       END RECORD
DEFINE g_tc_ecu DYNAMIC ARRAY OF RECORD
         tc_ecu01   LIKE tc_ecu_file.tc_ecu01,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         tc_ecu02   LIKE tc_ecu_file.tc_ecu02,
         ecu03      LIKE ecu_file.ecu03,
         tc_ecu04   LIKE tc_ecu_file.tc_ecu04,
         ima02_1    LIKE ima_file.ima02,
         ima021_1   LIKE ima_file.ima021,
         tc_ecv03   LIKE tc_ecv_file.tc_ecv03,
         ecg02      LIKE ecg_file.ecg02,
         tc_ecv07   LIKE tc_ecv_file.tc_ecv07,
         sjxhb      LIKE type_file.num20_6,
         llxhb      LIKE type_file.num20_6 
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
      OPEN WINDOW q001_w AT 2,18 WITH FORM "cec/42f/cecq018"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      CALL q001_tm()
      CALL q001()   
   END IF 

   CALL q001_menu()
   CLOSE WINDOW q001_w              
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q001_menu()
    WHILE TRUE
      CALL q001_bp()
      
      CASE g_action_choice
         WHEN "page1"
            CALL q001_bp()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_tm()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ecu),'','')
              LET g_action_choice = " " 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q001_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01  

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   CLEAR FORM   
   CALL g_tc_ecu.clear()
   LET tm.b_date= g_today
   LET tm.e_date= g_today
   LET tm.wc=NULL 
   
 
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.b_date,tm.e_date ATTRIBUTES (WITHOUT DEFAULTS)
          BEFORE INPUT 
             CALL cl_qbe_display_condition(lc_qbe_sn)
      END INPUT
      CONSTRUCT tm.wc ON tc_ecv01,tc_ecv02 FROM tc_ecv01,tc_ecv02
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
      END CONSTRUCT   
 
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP 
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION ACCEPT
          LET INT_FLAG = 0
          ACCEPT DIALOG
            
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG
 
      ON ACTION CONTROLP
         CASE 
         WHEN INFIELD(tc_ecv01)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_tc_ecu01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_ecv01
               NEXT FIELD tc_ecv01
         WHEN INFIELD(tc_ecv02)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_ecu"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_ecv02
               NEXT FIELD tc_ecv02
         END CASE 
         
      ON ACTION qbe_select
         CALL cl_qbe_select()
   END DIALOG
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   CALL q001()
   ERROR ""
END FUNCTION
 
FUNCTION q001()
   DEFINE l_sql     STRING 
   DEFINE l_oeb01   LIKE oeb_file.oeb01
   DEFINE l_oeb03   LIKE oeb_file.oeb03
   DEFINE l_oeb04   LIKE oeb_file.oeb04
   DEFINE l_oeb916  LIKE oeb_file.oeb916
   DEFINE l_oeb917  LIKE oeb_file.oeb917
   
   CALL q001_b_fill() 
END FUNCTION


FUNCTION q001_bp()

   DISPLAY g_rec_b TO formonly.cn2

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ecu TO s_tc_ecu.* ATTRIBUTE(COUNT=g_rec_b)    
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


FUNCTION q001_b_fill()
DEFINE l_x   LIKE type_file.num20_6 

   LET g_sql ="SELECT tc_ecu01,a.ima02,a.ima021,tc_ecu02,ecu03,tc_ecu04,b.ima02,b.ima021,tc_ecv03,",
              "       ecg02,tc_ecv07,'',tc_ecu05/tc_ecu06",
              "  FROM tc_ecu_file LEFT JOIN ima_file a ON a.ima01 = tc_ecu01",
              "                   LEFT JOIN ima_file b ON b.ima01 = tc_ecu04",
              "                   LEFT JOIN ecu_file ON ecu02 = tc_ecu02 AND ecu01 = tc_ecu01,",
              "       tc_ecv_file LEFT JOIN ecg_file ON ecg01 =tc_ecv03  ",
              " WHERE tc_ecu01 = tc_ecv01",
              "   AND tc_ecu02 = tc_ecv02",
              "   AND tc_ecu03 = tc_ecv05",
              "   AND tc_ecu04 = tc_ecv06",
              "   AND tc_ecv04 BETWEEN to_date('",tm.b_date,"','yy/mm/dd') AND to_date('",tm.e_date,"','yy/mm/dd')",
              "   AND ",tm.wc CLIPPED 

   PREPARE q001_pb1 FROM g_sql
   DECLARE oeb_curs1 CURSOR FOR q001_pb1 
   
   CALL g_tc_ecu.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH oeb_curs1 INTO g_tc_ecu[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_x = 0
      SELECT SUM(shb111+shb112+shb113+shb114+shb115+shb17) INTO l_x FROM shb_file 
       WHERE (shb16 IS NULL OR shb16=' ')
         AND shb32>=tm.b_date
         AND shb32<=tm.e_date
         AND shbconf = 'Y'
      IF NOT cl_null(l_x) THEN 
         LET g_tc_ecu[g_cnt].sjxhb= g_tc_ecu[g_cnt].tc_ecv07/l_x 
      ELSE 
         LET g_tc_ecu[g_cnt].sjxhb= ''
      END IF 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      END IF
   END FOREACH

   CALL g_tc_ecu.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
END FUNCTION