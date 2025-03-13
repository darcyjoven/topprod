# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artt701.4gl
# Descriptions...: 代收款單維護作業 
# Date & Author..: NO.FUN-CC0057 12/12/06 By xumeimei
# Modify.........: No.FUN-CC0082 12/12/28 By baogc 過單
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_rxf        RECORD  LIKE rxf_file.*
DEFINE g_rxf_t      RECORD  LIKE rxf_file.* 
DEFINE g_ogb        DYNAMIC ARRAY OF RECORD
                    ogb03      LIKE ogb_file.ogb03,
                    ogb04      LIKE ogb_file.ogb04,
                    ima02      LIKE ima_file.ima02,
                    ogb05      LIKE ogb_file.ogb05,
                    gfe02      LIKE gfe_file.gfe02,
                    ogb12      LIKE ogb_file.ogb12,
                    ogb13      LIKE ogb_file.ogb13,
                    ogb14      LIKE ogb_file.ogb14,
                    ogb14t     LIKE ogb_file.ogb14t
                    END RECORD 
DEFINE g_ogb_t      DYNAMIC ARRAY OF RECORD
                    ogb03      LIKE ogb_file.ogb03,
                    ogb04      LIKE ogb_file.ogb04,
                    ima02      LIKE ima_file.ima02,
                    ogb05      LIKE ogb_file.ogb05,
                    gfe02      LIKE gfe_file.gfe02,
                    ogb12      LIKE ogb_file.ogb12,
                    ogb13      LIKE ogb_file.ogb13,
                    ogb14      LIKE ogb_file.ogb14,
                    ogb14t     LIKE ogb_file.ogb14t
                    END RECORD
DEFINE g_wc                  STRING
DEFINE g_wc2                 STRING
DEFINE g_wc3                 STRING
DEFINE g_sql                 STRING                 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE l_ac                  LIKE type_file.num10
DEFINE g_rec_b               LIKE type_file.num10
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10 
DEFINE g_jump                LIKE type_file.num10             
DEFINE g_no_ask              LIKE type_file.num5 
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_argv1               LIKE type_file.chr1
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT          
   LET g_argv1 = ARG_VAL(1)
   IF cl_null(g_argv1) THEN
      LET g_argv1 = '0'
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_argv1 = '0' THEN
      LET g_prog = "artt701"
   END IF
   IF g_argv1 = '1' THEN
      LET g_prog = "artt702"
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_forupd_sql = "SELECT * FROM rxf_file WHERE rxf01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t701_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t701_w WITH FORM "art/42f/artt701"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
   IF g_argv1 = '0' THEN
      CALL cl_set_comp_visible("page2",FALSE) 
   END IF
   IF g_argv1 = '1' THEN
      CALL cl_set_comp_visible("page1",FALSE) 
   END IF
   IF g_argv1 = '0' THEN
      CALL cl_getmsg('art1085',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf01",g_msg CLIPPED)
      CALL cl_getmsg('art1087',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf04",g_msg CLIPPED)
      CALL cl_getmsg('art1089',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf07",g_msg CLIPPED)
      CALL cl_getmsg('art1093',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf08",g_msg CLIPPED)
      CALL cl_getmsg('art1091',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("amt",g_msg CLIPPED)
   END IF
   IF g_argv1 = '1' THEN
      CALL cl_getmsg('art1086',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf01",g_msg CLIPPED)
      CALL cl_getmsg('art1088',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf04",g_msg CLIPPED)
      CALL cl_getmsg('art1090',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf07",g_msg CLIPPED)
      CALL cl_getmsg('art1094',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rxf08",g_msg CLIPPED)
      CALL cl_getmsg('art1092',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("amt",g_msg CLIPPED)
   END IF
   LET g_action_choice = ""
   CALL t701_menu()
 
   CLOSE WINDOW t701_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t701_curs()
 
   CLEAR FORM    
   CALL g_ogb.clear()
   DIALOG ATTRIBUTES(UNBUFFERED) 
      CONSTRUCT BY NAME g_wc ON
                rxf01,rxf02,rxf03,rxf04,rxf05,rxf06,rxf07,rxf08,rxf09,
                rxf10,rxf11,rxf12,rxfconf,rxfconu,rxfcond,rxfplant,rxf13,
                rxfuser,rxfgrup,rxforiu,rxforig,rxfmodu,rxfdate,rxfacti,rxfcrat
                         
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
         ON ACTION controlp
             CASE
                WHEN INFIELD(rxf01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxf01"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxf01
                   NEXT FIELD rxf01    
                   
                WHEN INFIELD(rxf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxf03"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxf03
                   NEXT FIELD rxf03  
                  
                WHEN INFIELD(rxf04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxf04"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxf04
                   NEXT FIELD rxf04

                WHEN INFIELD(rxf09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxf09"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxf09
                   NEXT FIELD rxf09

                WHEN INFIELD(rxf10)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxf10"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxf10
                   NEXT FIELD rxf10
 
                WHEN INFIELD(rxf11)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxf11"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxf11
                   NEXT FIELD rxf11                     

                WHEN INFIELD(rxf12)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxf12"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxf12
                   NEXT FIELD rxf12

                WHEN INFIELD(rxfconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxfconu"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxfconu
                   NEXT FIELD rxfconu     
                   
                WHEN INFIELD(rxfplant)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxfplant"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxfplant
                   NEXT FIELD rxfplant
                   
                OTHERWISE
                   EXIT CASE
             END CASE
      END CONSTRUCT
   
      CONSTRUCT g_wc2 ON ogb03,ogb04,ogb05,ogb12,ogb13,ogb14,ogb14t
                    FROM s_ogb[1].ogb03,s_ogb[1].ogb04,s_ogb[1].ogb05,s_ogb[1].ogb12,
                         s_ogb[1].ogb13,s_ogb[1].ogb14,s_ogb[1].ogb14t
                          
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
            ON ACTION controlp
                CASE
                   WHEN INFIELD(ogb04)
                      CALL cl_init_qry_var()
                      IF g_argv1 = '0' THEN
                         LET g_qryparam.form = "q_ogb04q"
                      END IF
                      IF g_argv1 = '1' THEN
                         LET g_qryparam.form = "q_ohb04q"
                      END IF
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ogb04
                      NEXT FIELD ogb04
             
                   WHEN INFIELD(ogb05)
                      CALL cl_init_qry_var()
                      IF g_argv1 = '0' THEN
                         LET g_qryparam.form = "q_ogb05q"
                      END IF
                      IF g_argv1 = '1' THEN
                         LET g_qryparam.form = "q_ohb05q"
                      END IF
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ogb05
                      NEXT FIELD ogb05
                   OTHERWISE
                      EXIT CASE
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

       ON ACTION qbe_select
          CALL cl_qbe_select()

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION CLOSE
          LET INT_FLAG=1
          EXIT DIALOG

       ON ACTION ACCEPT
          ACCEPT DIALOG

       ON ACTION CANCEL
          LET INT_FLAG = 1
          EXIT DIALOG
   END DIALOG   
   IF INT_FLAG THEN
      RETURN
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rxfuser', 'rxfgrup')
   IF cl_null(g_wc2) THEN
      LET g_wc2=" 1=1"
   END IF
   IF g_argv1 = '0' THEN
      IF g_wc2 = " 1=1" THEN
         LET g_sql = "SELECT rxf01 FROM rxf_file ",
                     " WHERE rxf00 = '1'",
                     "   AND ", g_wc CLIPPED,
                     " ORDER BY rxf01"
      ELSE 
         LET g_sql = "SELECT UNIQUE rxf01 ",
                     "  FROM rxf_file,ogb_file",
                     " WHERE rxf04 = ogb01",
                     "   AND rxf00 = '1'",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY rxf01"
      END IF
   END IF
   IF g_argv1 = '1' THEN
      IF g_wc2 = " 1=1" THEN
         LET g_sql = "SELECT rxf01 FROM rxf_file ",
                     " WHERE rxf00 = '2'",
                     "   AND ", g_wc CLIPPED,
                     " ORDER BY rxf01"
      ELSE 
         LET g_wc3 = cl_replace_str(g_wc2,"ogb","ohb")
         LET g_sql = "SELECT UNIQUE rxf01 ",
                     "  FROM rxf_file,ohb_file",
                     " WHERE rxf04 = ohb01",
                     "   AND rxf00 = '2'",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY rxf01"
      END IF
   END IF
 
   PREPARE t701_prepare FROM g_sql
   DECLARE t701_cs SCROLL CURSOR WITH HOLD FOR t701_prepare

   IF g_argv1 = '0' THEN
      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT COUNT(*) FROM rxf_file WHERE rxf00 = '1' AND ",g_wc CLIPPED
      ELSE 
         LET g_sql="SELECT COUNT(DISTINCT rxf01) FROM rxf_file,ogb_file ",
                   " WHERE rxf04 = ogb01",
                   "   AND rxf00 = '1'",
                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
   END IF
   IF g_argv1 = '1' THEN
      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT COUNT(*) FROM rxf_file WHERE rxf00 = '2' AND ",g_wc CLIPPED
      ELSE 
         LET g_wc3 = cl_replace_str(g_wc2,"ogb","ohb")
         LET g_sql="SELECT COUNT(DISTINCT rxf01) FROM rxf_file,ohb_file ",
                   " WHERE rxf04 = ohb01",
                   "   AND rxf00 = '2'",
                   "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
      END IF
   END IF
   PREPARE t701_precount FROM g_sql
   DECLARE t701_count CURSOR FOR t701_precount
END FUNCTION
 
FUNCTION t701_menu()
   
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      CALL t701_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t701_q()
            END IF
 
         WHEN "help"
            CALL cl_show_help()

         WHEN "exporttoexcel"                                                   
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogb),'','')
            END IF
         WHEN "money_detail"
            IF cl_chk_act_auth() THEN
               IF g_argv1 = '0' THEN         
                  CALL s_pay_detail('12',g_rxf.rxf01,g_rxf.rxfplant,g_rxf.rxfconf)
               END IF
               IF g_argv1 = '1' THEN          
                  CALL s_pay_detail('13',g_rxf.rxf01,g_rxf.rxfplant,g_rxf.rxfconf)
               END IF
            END IF
         WHEN "related_document"
             IF cl_chk_act_auth() THEN
                IF NOT cl_null(g_rxf.rxf01) THEN
                   LET g_doc.column1 = "rxf01"
                   LET g_doc.value1 = g_rxf.rxf01
                   CALL cl_doc()
                END IF
             END IF
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

      END CASE
   END WHILE
END FUNCTION

 
FUNCTION t701_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
           CALL cl_set_act_visible("accept,cancel",FALSE )  
           CALL cl_navigator_setting( g_curs_index, g_row_count )
        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
      END DISPLAY
  
      BEFORE DIALOG   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION money_detail
         LET g_action_choice = "money_detail"
         EXIT DIALOG
         
      ON ACTION first
         CALL t701_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL t701_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL t701_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL t701_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL t701_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG


      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       
        IF g_argv1 = '0' THEN
           CALL cl_getmsg('art1085',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf01",g_msg CLIPPED)
           CALL cl_getmsg('art1087',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf04",g_msg CLIPPED)
           CALL cl_getmsg('art1089',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf07",g_msg CLIPPED)
           CALL cl_getmsg('art1093',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf08",g_msg CLIPPED)
           CALL cl_getmsg('art1091',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("amt",g_msg CLIPPED)
        END IF
        IF g_argv1 = '1' THEN
           CALL cl_getmsg('art1086',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf01",g_msg CLIPPED)
           CALL cl_getmsg('art1088',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf04",g_msg CLIPPED)
           CALL cl_getmsg('art1090',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf07",g_msg CLIPPED)
           CALL cl_getmsg('art1094',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("rxf08",g_msg CLIPPED)
           CALL cl_getmsg('art1092',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("amt",g_msg CLIPPED)
        END IF

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE 
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

      ON ACTION related_document
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_rxf.rxf01) THEN
               LET g_doc.column1 = "rxf01"
               LET g_doc.value1 = g_rxf.rxf01
               CALL cl_doc()
            END IF
         END IF
 
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION t701_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_rxf.* TO NULL
    INITIALIZE g_rxf_t.* TO NULL
    LET g_wc = NULL
    LET g_wc2 = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ogb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t701_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_rxf.* TO NULL
       LET g_wc = NULL
       LET g_wc2 = NULL
       RETURN
    END IF
    
    OPEN t701_count
    FETCH t701_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t701_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxf.rxf01,SQLCA.sqlcode,0)
       INITIALIZE g_rxf.* TO NULL
       LET g_wc = NULL
       LET g_wc2 = NULL
    ELSE
       CALL t701_fetch('F')
    END IF

END FUNCTION
 
FUNCTION t701_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     t701_cs INTO g_rxf.rxf01
        WHEN 'P' FETCH PREVIOUS t701_cs INTO g_rxf.rxf01
        WHEN 'F' FETCH FIRST    t701_cs INTO g_rxf.rxf01
        WHEN 'L' FETCH LAST     t701_cs INTO g_rxf.rxf01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t701_cs INTO g_rxf.rxf01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxf.rxf01,SQLCA.sqlcode,0)
       INITIALIZE g_rxf.* TO NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_rxf.* FROM rxf_file  
     WHERE rxf01 = g_rxf.rxf01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxf.rxf01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_rxf.rxfuser 
       LET g_data_group = g_rxf.rxfgrup
       CALL t701_show() 
    END IF
END FUNCTION
 
FUNCTION t701_show()
 
    LET g_rxf_t.* = g_rxf.*
    DISPLAY BY NAME g_rxf.rxf01,g_rxf.rxf02,g_rxf.rxf03,g_rxf.rxf04,g_rxf.rxf05,g_rxf.rxf06,
                    g_rxf.rxf07,g_rxf.rxf08,g_rxf.rxf09,g_rxf.rxf10,g_rxf.rxf11,g_rxf.rxf12,
                    g_rxf.rxfconf,g_rxf.rxfconu,g_rxf.rxfcond,g_rxf.rxfcont,g_rxf.rxfplant,  
                    g_rxf.rxf13,g_rxf.rxfuser,g_rxf.rxfgrup,g_rxf.rxforiu,g_rxf.rxforig,
                    g_rxf.rxfmodu,g_rxf.rxfdate,g_rxf.rxfacti,g_rxf.rxfcrat
    CALL t701_pic()       
    CALL cl_show_fld_cont()    
    CALL t701_desc()        
    CALL t701_b_fill(g_wc2)
END FUNCTION

FUNCTION t701_desc()
DEFINE l_oea01      LIKE oea_file.oea01
DEFINE l_oga03      LIKE oga_file.oga03
DEFINE l_oga87      LIKE oga_file.oga87
DEFINE l_oga88      LIKE oga_file.oga88
DEFINE l_oga89      LIKE oga_file.oga89
DEFINE l_rtz13      LIKE rtz_file.rtz13
DEFINE l_rtz131     LIKE rtz_file.rtz13
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE l_gen021     LIKE gen_file.gen02
DEFINE l_gem02      LIKE gem_file.gem02
DEFINE l_occ02      LIKE occ_file.occ02
DEFINE l_amt        LIKE rxf_file.rxf07
DEFINE l_sql        STRING
DEFINE l_sql1       STRING
DEFINE l_oha16      LIKE oha_file.oha16

   DISPLAY '' TO FORMONLY.oea01
   DISPLAY '' TO FORMONLY.oga03
   DISPLAY '' TO FORMONLY.oga87
   DISPLAY '' TO FORMONLY.oga88
   DISPLAY '' TO FORMONLY.oga89
   DISPLAY '' TO FORMONLY.rtz13
   DISPLAY '' TO FORMONLY.rtz131
   DISPLAY '' TO FORMONLY.gen02
   DISPLAY '' TO FORMONLY.gen021
   DISPLAY '' TO FORMONLY.gem02
   DISPLAY '' TO FORMONLY.occ02

   IF g_argv1 = '0' THEN
      LET l_sql = "SELECT oga16,oga03,oga87,oga88,oga89", 
                  "  FROM ",cl_get_target_table(g_rxf.rxf03,"oga_file"),
                  " WHERE oga01 = '",g_rxf.rxf04,"' "
      PREPARE t701_sel_oga_pb FROM l_sql
      DECLARE t701_sel_oga_cs CURSOR FOR t701_sel_oga_pb
      FOREACH t701_sel_oga_cs INTO l_oea01,l_oga03,l_oga87,l_oga88,l_oga89
      END FOREACH
   END IF
   IF g_argv1 = '1' THEN
      LET l_sql ="SELECT oha16,oha03,oha87,oha88,oha89",
                 "  FROM ",cl_get_target_table(g_rxf.rxf03,"oha_file"),
                 " WHERE oha01 = '",g_rxf.rxf04,"' "
      PREPARE t701_sel_oha_pb FROM l_sql
      DECLARE t701_sel_oha_cs CURSOR FOR t701_sel_oha_pb
      FOREACH t701_sel_oha_cs INTO l_oha16,l_oga03,l_oga87,l_oga88,l_oga89
         LET l_sql1 = "SELECT oga16 FROM ",cl_get_target_table(g_rxf.rxf03,"oga_file"),
                      " WHERE oga01 = '",l_oha16,"'"
         PREPARE t701_sel_oea_pb FROM l_sql1
         DECLARE t701_sel_oea_cs CURSOR FOR t701_sel_oea_pb
         FOREACH t701_sel_oea_cs INTO l_oea01
         END FOREACH
      END FOREACH
   END IF 
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_rxf.rxf03
   SELECT rtz13 INTO l_rtz131 FROM rtz_file WHERE rtz01 = g_rxf.rxfplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rxf.rxf09
   SELECT gen02 INTO l_gen021 FROM gen_file WHERE gen01 = g_rxf.rxfconu
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_rxf.rxf10
   IF NOT cl_null(l_oga03) THEN
      SELECT occ02 INTO l_occ02
        FROM occ_file
       WHERE occ01 = l_oga03
   END IF
   LET l_amt = g_rxf.rxf07 - g_rxf.rxf08
   DISPLAY l_oea01 TO FORMONLY.oea01
   DISPLAY l_oga03 TO FORMONLY.oga03
   DISPLAY l_oga87 TO FORMONLY.oga87
   DISPLAY l_oga88 TO FORMONLY.oga88
   DISPLAY l_oga89 TO FORMONLY.oga89
   DISPLAY l_rtz13 TO FORMONLY.rtz13
   DISPLAY l_rtz131 TO FORMONLY.rtz131
   DISPLAY l_gen02 TO FORMONLY.gen02
   DISPLAY l_gen021 TO FORMONLY.gen021
   DISPLAY l_gem02 TO FORMONLY.gem02
   DISPLAY l_occ02 TO FORMONLY.occ02
   DISPLAY l_amt TO FORMONLY.amt
END FUNCTION

FUNCTION t701_b_fill(p_wc2)
    DEFINE p_wc2       STRING
    IF g_argv1 = '0' THEN
       LET g_sql = "SELECT ogb03,ogb04,'',ogb05,'',ogb12,ogb13,ogb14,ogb14t",
                   "  FROM ",cl_get_target_table(g_rxf.rxf03,"ogb_file"),
                   " WHERE ogb01 ='",g_rxf.rxf04,"' "
       IF NOT cl_null(p_wc2) THEN                                                   
          LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED                             
       END IF                                                                       
       LET g_sql=g_sql CLIPPED," ORDER BY ogb03"            
    END IF
    IF g_argv1 = '1' THEN
       LET g_sql = "SELECT ohb03,ohb04,'',ohb05,'',ohb12,ohb13,ohb14,ohb14t",
                   "  FROM ",cl_get_target_table(g_rxf.rxf03,"ohb_file"),   
                   " WHERE ohb01 ='",g_rxf.rxf04,"' "
       IF NOT cl_null(p_wc2) THEN                                                   
          LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED                             
       END IF                                                                       
       LET g_sql=g_sql CLIPPED," ORDER BY ohb03"            
    END IF
    DISPLAY g_sql             
 
    PREPARE t701_pb FROM g_sql
    DECLARE ogb_cs CURSOR FOR t701_pb
 
    CALL g_ogb.clear()
    LET g_rec_b=0    
    LET g_cnt = 1
 
    FOREACH ogb_cs INTO g_ogb[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT ima02 INTO g_ogb[g_cnt].ima02 FROM ima_file WHERE ima01 = g_ogb[g_cnt].ogb04
      SELECT gfe02 INTO g_ogb[g_cnt].gfe02 FROM gfe_file WHERE gfe01 = g_ogb[g_cnt].ogb05
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ogb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    LET g_cnt = 1
    CALL t701_bp_refresh()
END FUNCTION

FUNCTION t701_bp_refresh()
  DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION t701_pic()
   CASE g_rxf.rxfconf
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = 'X'
                LET g_void    = ''
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_rxf.rxfacti)
END FUNCTION

#FUN-CC0082
#FUN-CC0057
