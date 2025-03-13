# Prog. Version..: '5.25.04-11.09.15(00010)'     #
#
# Pattern name...: ghrq083.4gl
# Descriptions...: 员工定调薪查询
# Date & Author..: 13/07/01 By Jiangxt
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cch       DYNAMIC ARRAY OF RECORD
	   hrdp04       LIKE hrdp_file.hrdp04,
       hrat02       LIKE hrat_file.hrat02,
       hrat03       LIKE hraa_file.hraa12,
       hrat04       LIKE hrao_file.hrao02,
       hrdpa06      LIKE hrdpa_file.hrdpa06,
       hrdpa07      LIKE hrdpa_file.hrdpa07,
       hrdpa02_name LIKE hrcy_file.hrcy02,
       hrdpa03_name LIKE hrcya_file.hrcya03,
       hrdpa04_name LIKE hrcyb_file.hrcyb05,
       hrdpa05      LIKE hrdpa_file.hrdpa05,
       hrdp07       LIKE hrdp_file.hrdp07,
       hrdp05       LIKE hrdp_file.hrdp05,
       hrdp09       LIKE hrdp_file.hrdp09,
       hrdp08       LIKE hrdp_file.hrdp08
          
                END RECORD
DEFINE g_rec_b      LIKE type_file.num5         
DEFINE g_cnt        LIKE type_file.num10 
DEFINE g_sql        STRING 
DEFINE g_bdate      LIKE type_file.dat
DEFINE g_edate      LIKE type_file.dat
DEFINE g_wc         STRING 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("GHR")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146

    OPEN WINDOW q083_w AT 3,2
         WITH FORM "ghr/42f/ghrq083"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL q083_cs()
    CALL q083_menu()
    CLOSE WINDOW q083_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION q083_cs()
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01

   CLEAR FORM
   CALL cl_set_head_visible("","YES")  

   CONSTRUCT g_wc ON hrdp04,hrat03,hrat04,hrdpa06,hrdpa07
        FROM s_cch[1].hrdp04,s_cch[1].hrat03,s_cch[1].hrat04,s_cch[1].hrdpa06,s_cch[1].hrdpa07

      BEFORE CONSTRUCT 
          DISPLAY '' TO s_cch[1].hrdpa06
          DISPLAY '' TO s_cch[1].hrdpa07

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrdp04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrdp04
               NEXT FIELD hrdp04
            WHEN INFIELD(hrat03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat03
               NEXT FIELD hrat03
            WHEN INFIELD(hrat04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat04
               NEXT FIELD hrat04
            OTHERWISE EXIT CASE
         END CASE
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION about
         CALL cl_about()

   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   IF INT_FLAG THEN 
      RETURN 
   END IF
   
   CALL q083_b_fill()
END FUNCTION
 
FUNCTION q083_menu()
 
   WHILE TRUE
      CALL q083_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q083_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cch),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q083_q()
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q083_cs()
END FUNCTION

FUNCTION q083_b_fill( )    
DEFINE l_hrde04  LIKE hrde_file.hrde04

    LET g_cnt = 1
    LET g_rec_b = 0
    CALL g_cch.clear()
    LET  g_wc = cl_replace_str(g_wc,"hrdp04","hrat01")
    LET g_sql=" SELECT hrat01,hrat02,hraa12,hrao02,hrdpa06,hrdpa07,hrcy02,hrcya03,hrcyb05,hrdpa05,hrdp07,hrdp05,hrdp09,hrdp08 ",
              "   FROM hrdp_file,hrat_file,hraa_file,hrao_file,",
              "        hrdpa_file,hrcy_file,hrcya_file,hrcyb_file",
              "  WHERE hrdp04=hratid AND hraa01(+)=hrat03 AND hrao01(+)=hrat04",
              "    AND hrdpa01=hrdp01 AND hrcy01(+)=hrdpa02 AND hrcya01(+)=hrdpa02",
              "    AND hrcya02(+)=hrdpa03 AND hrcyb01(+)=hrdpa02",
              "    AND hrcyb02(+)=hrdpa03 AND hrcyb03(+)=hrdpa04",
              "    AND hrdp09 = '003' ",
              "    AND ",g_wc,
              " ORDER BY hrdp04"
    PREPARE q083_p1 FROM g_sql
    DECLARE q083_c1 CURSOR FOR q083_p1
    FOREACH q083_c1 INTO g_cch[g_cnt].*
       IF sqlca.sqlcode THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF 
       	
       SELECT hrag07 INTO g_cch[g_cnt].hrdp09 FROM hrag_file 
       WHERE hrag01='103'
         AND hrag06=g_cch[g_cnt].hrdp09
         
       LET g_cnt = g_cnt + 1
    END FOREACH
    LET g_wc=cl_replace_str(g_wc,"hrdpa06","hrdpb04")
    LET g_wc=cl_replace_str(g_wc,"hrdpa07","hrdpb05")
    LET g_sql=" SELECT hrat01,hrat02,hraa12,hrao02,hrdpb04,hrdpb05,hrdh06,'','',hrdpb03,hrdp07,hrdp05,hrdp09,hrdp08",
              "   FROM hrdp_file,hrat_file,hraa_file,hrao_file,hrdpb_file,hrdh_file",
              "  WHERE hrdp04=hratid AND hraa01(+)=hrat03 AND hrao01(+)=hrat04",
              "    AND hrdpb01=hrdp01 AND hrdh01(+)=hrdpb02",
              "    AND hrdp09 = '003' ",
              "    AND ",g_wc,
              " ORDER BY hrdp04"
    PREPARE q083_p2 FROM g_sql
    DECLARE q083_c2 CURSOR FOR q083_p2
    FOREACH q083_c2 INTO g_cch[g_cnt].*
       IF sqlca.sqlcode THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       	
       	SELECT hrag07 INTO g_cch[g_cnt].hrdp09 FROM hrag_file 
       WHERE hrag01='103'
         AND hrag06=g_cch[g_cnt].hrdp09
         
       LET g_cnt = g_cnt + 1
    END FOREACH
    LET g_wc=cl_replace_str(g_wc,"hrdpb04","hrdpc06")
    LET g_wc=cl_replace_str(g_wc,"hrdpb05","hrdpc07")
    LET g_sql=" SELECT hrat01,hrat02,hraa12,hrao02,hrdpc06,hrdpc07,hrdpc02,hrdpc03,hrdpc04,hrdpc05,hrdp07,hrdp05,hrdp09,hrdp08",
              "   FROM hrdp_file,hrat_file,hraa_file,hrao_file,hrdpc_file",
              "  WHERE hrdp04=hratid AND hraa01(+)=hrat03 AND hrao01(+)=hrat04 AND hrdpc01=hrdp01",
              "    AND hrdp09 = '003' ",
              "    AND ",g_wc,
              " ORDER BY hrdp04"
    PREPARE q083_p3 FROM g_sql
    DECLARE q083_c3 CURSOR FOR q083_p3
    FOREACH q083_c3 INTO g_cch[g_cnt].*
       IF sqlca.sqlcode THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF 
       SELECT DISTINCT hrde02,hrde04 
         INTO g_cch[g_cnt].hrdpa02_name,l_hrde04 
         FROM hrde_file WHERE hrde01=g_cch[g_cnt].hrdpa02_name
       CASE l_hrde04
         WHEN '0'
           SELECT hrar04 INTO g_cch[g_cnt].hrdpa03_name FROM hrar_file
            WHERE hrar03=g_cch[g_cnt].hrdpa03_name
         WHEN '1'
           SELECT hras04 INTO g_cch[g_cnt].hrdpa03_name FROM hras_file
            WHERE hras01=g_cch[g_cnt].hrdpa03_name
         WHEN '2'
           SELECT hrag07 INTO g_cch[g_cnt].hrdpa03_name FROM hrag_file
            WHERE hrag01='649' AND hrad06=g_cch[g_cnt].hrdpa03_name
       END CASE
       
       SELECT hrag07 INTO g_cch[g_cnt].hrdpa04_name FROM hrag_file
        WHERE hrag01='648' AND hrag06=g_cch[g_cnt].hrdpa04_name
        
       SELECT hrag07 INTO g_cch[g_cnt].hrdp09 FROM hrag_file 
       WHERE hrag01='103'
       AND hrag06=g_cch[g_cnt].hrdp09
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_cch.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
 
FUNCTION q083_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680832 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cch TO s_cch.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(1,1)
 
      BEFORE ROW
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
         
      ON ACTION controls           
         CALL cl_set_head_visible("","AUTO")   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
