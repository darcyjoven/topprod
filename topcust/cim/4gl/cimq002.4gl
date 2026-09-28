# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: cimq002.4gl
# Descriptions...: 消耗性料号使用配比表q查询
# Date & Author..: 16/05/06 By guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm    RECORD                                       
         wc       LIKE type_file.chr1000
       END RECORD
DEFINE g_inb DYNAMIC ARRAY OF RECORD
         ina00   LIKE ina_file.ina00,
         ina01   LIKE inb_file.inb01,
         ina02   LIKE ina_file.ina02,
         ina04    LIKE ina_file.ina04,
         gem02   LIKE gem_file.gem02,
         ina11   LIKE ina_file.ina11,
         gen02   LIKE gen_file.gen02,
         inb03  LIKE inb_file.inb03,
         inb04  LIKE inb_file.inb04,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         inb05    LIKE inb_file.inb05,
         inb06    LIKE  inb_file.inb06,
         inb07    LIKE inb_file.inb07,
         inb16    LIKE inb_file.inb16,
         inb09    LIKE inb_file.inb09,
         inb15    LIKE  inb_file.inb15,
         azf03    LIKE azf_file.azf03,
         inb13    LIKE  inb_file.inb13,
         inb14    LIKE inb_file.inb14 
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
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127

   
   INITIALIZE tm.* TO NULL

   LET g_bgjob = ARG_VAL(1)
   
   LET g_action_flag='page1'
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      OPEN WINDOW q002_w AT 2,18 WITH FORM "cim/42f/cimq002"
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_inb),'','')
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
   CALL g_inb.clear()
   LET tm.wc=NULL 
   

      CONSTRUCT tm.wc ON ina00,ina01,ina02,ina04,ina11,inb03,inb04  ,inb05,inb06,inb07,inb16,inb09,inb15
                    FROM s_inb[1].ina00,s_inb[1].ina01,s_inb[1].ina02,s_inb[1].ina04,
                         s_inb[1].ina11,s_inb[1].inb03,s_inb[1].inb04 ,
                        s_inb[1].inb05,s_inb[1].inb06,s_inb[1].inb07,s_inb[1].inb16,s_inb[1].inb09,s_inb[1].inb15

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
         WHEN INFIELD(ina01)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ina2"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ina01
               NEXT FIELD inb01
         WHEN INFIELD(ina04)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ina04
               NEXT FIELD inb02
         WHEN INFIELD(ina11)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ina11
               NEXT FIELD ina11
         WHEN INFIELD(inb04)
               CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inb04
               NEXT FIELD ina11
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
   DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b)    
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

   LET g_sql ="SELECT ina00,ina01,ina02,ina04,gem02,ina11,gen02,inb03,inb04,ima02,ima021,inb05,inb06,inb07,inb16,inb09,inb15,azf03,",
              " inb13,inb14 ",
              " from ina_file,inb_file,gem_file,gen_file,azf_file,ima_file ",
              " where ina01 = inb01 and ina04 = gem01 and ina11 = gen01 and inb15 = azf01 and ima01=inb04 and inapost='Y'  ",
              "  AND ina00 in ('1','3')  AND ",tm.wc CLIPPED

   PREPARE q002_pb1 FROM g_sql
   DECLARE oeb_curs1 CURSOR FOR q002_pb1 
   
   CALL g_inb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH oeb_curs1 INTO g_inb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT ccc23 INTO g_inb[g_cnt].inb13 FROM ccc_file WHERE ccc01=g_inb[g_cnt].inb04
      AND ccc02=YEAR(g_today) AND ccc03=MONTH(g_today)
      IF cl_null(g_inb[g_cnt].inb13) OR g_inb[g_cnt].inb13=0 THEN  #成本单价为0的时候抓取单据之前的最近采购单价
         DECLARE sel_pmn_cur CURSOR WITH HOLD FOR
         SELECT pmn31t   FROM pmn_file,pmm_file WHERE pmn04=g_inb[g_cnt].inb04 
         AND  pmm01=pmn01 AND pmm18='Y' AND pmm04<g_inb[g_cnt].ina02 ORDER BY pmm02 DESC
         OPEN sel_pmn_cur
         FETCH sel_pmn_cur into g_inb[g_cnt].inb13
         CLOSE sel_pmn_cur


      END IF 
      LET g_inb[g_cnt].inb14=g_inb[g_cnt].inb13*g_inb[g_cnt].inb09
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_inb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
END FUNCTION
