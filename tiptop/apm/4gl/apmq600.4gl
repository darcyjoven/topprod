# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmq600.4gl
# Descriptions...: 采购价格波动表
# Date & Author..: 12/11/14 NO.FUN-C90076 By xianghui

DATABASE ds
 
GLOBALS "../../config/top.global" 
DEFINE tm  RECORD
           wc      STRING,
           bdate   LIKE type_file.dat,          
           edate   LIKE type_file.dat,          
           yy      LIKE type_file.chr10,  
           mm      LIKE type_file.chr10,        
           a       LIKE type_file.chr1,       
           b       LIKE type_file.chr1,      
           c       LIKE type_file.chr1,     
           d       LIKE type_file.chr1,
           e       LIKE type_file.chr1
 		   END RECORD
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_sql     STRING
DEFINE g_rec_b   LIKE type_file.num10
DEFINE g_cnt     LIKE type_file.num10
DEFINE g_count   LIKE type_file.num5
DEFINE g_pmn     DYNAMIC ARRAY OF RECORD
            pmm09    LIKE pmm_file.pmm09,
            pmc03    LIKE pmc_file.pmc03,
            pmn04    LIKE pmn_file.pmn04,
            pmn041   LIKE pmn_file.pmn041,
            ima021   LIKE ima_file.ima021,
            pmm22    LIKE pmm_file.pmm22,
            pmn86    LIKE pmn_file.pmn86,
            pmn31    LIKE pmn_file.pmn31,
            pmn31t   LIKE pmn_file.pmn31t,
            pmn87    LIKE pmn_file.pmn87,
            pmn88    LIKE pmn_file.pmn88,
            pmn88t   LIKE pmn_file.pmn88t,
            stb10    LIKE stb_file.stb10,
            pmn88b   LIKE pmn_file.pmn88,
            ccc23    LIKE ccc_file.ccc23,
            pmn88c   LIKE pmn_file.pmn88,
            pmm04    LIKE pmm_file.pmm04,
            pmn31a   LIKE pmn_file.pmn31,
            pmn88_b  LIKE pmn_file.pmn88,
            pmn88_p  LIKE type_file.num15_3,
            amt01a   LIKE pmn_file.pmn31,
            amt01b   LIKE pmn_file.pmn31t,
            amt01c   LIKE pmn_file.pmn87,
            amt01d   LIKE pmn_file.pmn88,
            amt01e   LIKE pmn_file.pmn88t,
            amt02a   LIKE pmn_file.pmn31,
            amt02b   LIKE pmn_file.pmn31t,
            amt02c   LIKE pmn_file.pmn87,
            amt02d   LIKE pmn_file.pmn88,
            amt02e   LIKE pmn_file.pmn88t,
            amt03a   LIKE pmn_file.pmn31,
            amt03b   LIKE pmn_file.pmn31t,
            amt03c   LIKE pmn_file.pmn87,
            amt03d   LIKE pmn_file.pmn88,
            amt03e   LIKE pmn_file.pmn88t,
            amt04a   LIKE pmn_file.pmn31,
            amt04b   LIKE pmn_file.pmn31t,
            amt04c   LIKE pmn_file.pmn87,
            amt04d   LIKE pmn_file.pmn88,
            amt04e   LIKE pmn_file.pmn88t,
            amt05a   LIKE pmn_file.pmn31,
            amt05b   LIKE pmn_file.pmn31t,
            amt05c   LIKE pmn_file.pmn87,
            amt05d   LIKE pmn_file.pmn88,
            amt05e   LIKE pmn_file.pmn88t,
            amt06a   LIKE pmn_file.pmn31,
            amt06b   LIKE pmn_file.pmn31t,
            amt06c   LIKE pmn_file.pmn87,
            amt06d   LIKE pmn_file.pmn88,
            amt06e   LIKE pmn_file.pmn88t,
            amt07a   LIKE pmn_file.pmn31,
            amt07b   LIKE pmn_file.pmn31t,
            amt07c   LIKE pmn_file.pmn87,
            amt07d   LIKE pmn_file.pmn88,
            amt07e   LIKE pmn_file.pmn88t,
            amt08a   LIKE pmn_file.pmn31,
            amt08b   LIKE pmn_file.pmn31t,
            amt08c   LIKE pmn_file.pmn87,
            amt08d   LIKE pmn_file.pmn88,
            amt08e   LIKE pmn_file.pmn88t,
            amt09a   LIKE pmn_file.pmn31,
            amt09b   LIKE pmn_file.pmn31t,
            amt09c   LIKE pmn_file.pmn87,
            amt09d   LIKE pmn_file.pmn88,
            amt09e   LIKE pmn_file.pmn88t,
            amt10a   LIKE pmn_file.pmn31,
            amt10b   LIKE pmn_file.pmn31t,
            amt10c   LIKE pmn_file.pmn87,
            amt10d   LIKE pmn_file.pmn88,
            amt10e   LIKE pmn_file.pmn88t,
            amt11a   LIKE pmn_file.pmn31,
            amt11b   LIKE pmn_file.pmn31t,
            amt11c   LIKE pmn_file.pmn87,
            amt11d   LIKE pmn_file.pmn88,
            amt11e   LIKE pmn_file.pmn88t,
            amt12a   LIKE pmn_file.pmn31,
            amt12b   LIKE pmn_file.pmn31t,
            amt12c   LIKE pmn_file.pmn87,
            amt12d   LIKE pmn_file.pmn88,
            amt12e   LIKE pmn_file.pmn88t,
            amt13a   LIKE pmn_file.pmn31,
            amt13b   LIKE pmn_file.pmn31t,
            amt13c   LIKE pmn_file.pmn87,
            amt13d   LIKE pmn_file.pmn88,
            amt13e   LIKE pmn_file.pmn88t,
            amt14a   LIKE pmn_file.pmn31,
            amt14b   LIKE pmn_file.pmn31t,
            amt14c   LIKE pmn_file.pmn87,
            amt14d   LIKE pmn_file.pmn88,
            amt14e   LIKE pmn_file.pmn88t,
            amt15a   LIKE pmn_file.pmn31,
            amt15b   LIKE pmn_file.pmn31t,
            amt15c   LIKE pmn_file.pmn87,
            amt15d   LIKE pmn_file.pmn88,
            amt15e   LIKE pmn_file.pmn88t,
            amt16a   LIKE pmn_file.pmn31,
            amt16b   LIKE pmn_file.pmn31t,
            amt16c   LIKE pmn_file.pmn87,
            amt16d   LIKE pmn_file.pmn88,
            amt16e   LIKE pmn_file.pmn88t,
            amt17a   LIKE pmn_file.pmn31,
            amt17b   LIKE pmn_file.pmn31t,
            amt17c   LIKE pmn_file.pmn87,
            amt17d   LIKE pmn_file.pmn88,
            amt17e   LIKE pmn_file.pmn88t,
            amt18a   LIKE pmn_file.pmn31,
            amt18b   LIKE pmn_file.pmn31t,
            amt18c   LIKE pmn_file.pmn87,
            amt18d   LIKE pmn_file.pmn88,
            amt18e   LIKE pmn_file.pmn88t,
            amt19a   LIKE pmn_file.pmn31,
            amt19b   LIKE pmn_file.pmn31t,
            amt19c   LIKE pmn_file.pmn87,
            amt19d   LIKE pmn_file.pmn88,
            amt19e   LIKE pmn_file.pmn88t,
            amt20a   LIKE pmn_file.pmn31,
            amt20b   LIKE pmn_file.pmn31t,
            amt20c   LIKE pmn_file.pmn87,
            amt20d   LIKE pmn_file.pmn88,
            amt20e   LIKE pmn_file.pmn88t,
            amt21a   LIKE pmn_file.pmn31,
            amt21b   LIKE pmn_file.pmn31t,
            amt21c   LIKE pmn_file.pmn87,
            amt21d   LIKE pmn_file.pmn88,
            amt21e   LIKE pmn_file.pmn88t,
            amt22a   LIKE pmn_file.pmn31,
            amt22b   LIKE pmn_file.pmn31t,
            amt22c   LIKE pmn_file.pmn87,
            amt22d   LIKE pmn_file.pmn88,
            amt22e   LIKE pmn_file.pmn88t,
            amt23a   LIKE pmn_file.pmn31,
            amt23b   LIKE pmn_file.pmn31t,
            amt23c   LIKE pmn_file.pmn87,
            amt23d   LIKE pmn_file.pmn88,
            amt23e   LIKE pmn_file.pmn88t,
            amt24a   LIKE pmn_file.pmn31,
            amt24b   LIKE pmn_file.pmn31t,
            amt24c   LIKE pmn_file.pmn87,
            amt24d   LIKE pmn_file.pmn88,
            amt24e   LIKE pmn_file.pmn88t,
            amt25a   LIKE pmn_file.pmn31,
            amt25b   LIKE pmn_file.pmn31t,
            amt25c   LIKE pmn_file.pmn87,
            amt25d   LIKE pmn_file.pmn88,
            amt25e   LIKE pmn_file.pmn88t,
            amt26a   LIKE pmn_file.pmn31,
            amt26b   LIKE pmn_file.pmn31t,
            amt26c   LIKE pmn_file.pmn87,
            amt26d   LIKE pmn_file.pmn88,
            amt26e   LIKE pmn_file.pmn88t,
            amt27a   LIKE pmn_file.pmn31,
            amt27b   LIKE pmn_file.pmn31t,
            amt27c   LIKE pmn_file.pmn87,
            amt27d   LIKE pmn_file.pmn88,
            amt27e   LIKE pmn_file.pmn88t,
            amt28a   LIKE pmn_file.pmn31,
            amt28b   LIKE pmn_file.pmn31t,
            amt28c   LIKE pmn_file.pmn87,
            amt28d   LIKE pmn_file.pmn88,
            amt28e   LIKE pmn_file.pmn88t,
            amt29a   LIKE pmn_file.pmn31,
            amt29b   LIKE pmn_file.pmn31t,
            amt29c   LIKE pmn_file.pmn87,
            amt29d   LIKE pmn_file.pmn88,
            amt29e   LIKE pmn_file.pmn88t,
            amt30a   LIKE pmn_file.pmn31,
            amt30b   LIKE pmn_file.pmn31t,
            amt30c   LIKE pmn_file.pmn87,
            amt30d   LIKE pmn_file.pmn88,
            amt30e   LIKE pmn_file.pmn88t,
            amt31a   LIKE pmn_file.pmn31,
            amt31b   LIKE pmn_file.pmn31t,
            amt31c   LIKE pmn_file.pmn87,
            amt31d   LIKE pmn_file.pmn88,
            amt31e   LIKE pmn_file.pmn88t
                 END RECORD
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE l_ac           LIKE type_file.num5
DEFINE g_flag         LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q600_w AT 5,10 
        WITH FORM "apm/42f/apmq600" ATTRIBUTE(STYLE = g_win_style) 
   CALL cl_ui_init() 
   LET g_action_choice = ""
   
   CALL q600_menu()
   DROP TABLE q600_tmp;
   CLOSE WINDOW q600_w      
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q600_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q600_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               CALL cl_doc()
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   DISPLAY BY NAME  tm.*
   DISPLAY g_cnt TO FORMONLY.cn
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_rec_b != 0 AND l_ac != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q600_q()
   CALL q600_cs()
   CALL q600()
END FUNCTION
 
FUNCTION q600_cs()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
DEFINE l_len          LIKE type_file.num5
DEFINE l_str          STRING
   CALL cl_opmsg('p')
   CLEAR FORM
   INITIALIZE tm.* TO NULL 
   LET tm.bdate= ''
   LET tm.edate= ''
   LET tm.yy = ''
   LET tm.mm = ''
   LET tm.a  ='1'
   LET tm.b  ='1'
   LET tm.c  ='1'
   LET tm.d  ='N'
   LET tm.e  ='N'
   CALL q600_set_amt_visible()

   DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.e
   DIALOG ATTRIBUTE(UNBUFFERED) 
      INPUT BY NAME tm.bdate,tm.edate,tm.yy,tm.mm,        
                    tm.a,tm.b,tm.c,tm.d,tm.e 
               ATTRIBUTE(WITHOUT DEFAULTS)      
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            CALL q600_set_visible()
         
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF


         AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF

         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]' THEN
               NEXT FIELD a
            END IF 
            
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN
               NEXT FIELD b
            END IF 
         
         AFTER FIELD c
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN
               NEXT FIELD c
            END IF    
           
         AFTER FIELD d
            IF NOT cl_null(tm.d)  THEN
               IF tm.d NOT MATCHES "[YN]" THEN
                  NEXT FIELD d       
               END IF
            END IF
         
         AFTER FIELD e
            IF NOT cl_null(tm.e)  THEN
               IF tm.d NOT MATCHES "[YN]" THEN
                  NEXT FIELD e       
               END IF
            END IF  
         AFTER FIELD yy
             IF NOT cl_null(tm.yy) THEN 
                LET l_str=tm.yy
                LET l_len= l_str.getLength()
                IF l_len <> 4 THEN 
                   CALL cl_err(tm.yy,'apm-819',0)
                   NEXT FIELD yy
                END IF
             END IF 
            
         ON CHANGE b,d,e
            CALL q600_set_visible()
      END INPUT
      CONSTRUCT tm.wc ON pmm09,pmn04
                     FROM s_pmn[1].pmm09,s_pmn[1].pmn04

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
      END CONSTRUCT   
      ON ACTION controlp
         CASE
            WHEN INFIELD(pmm09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmm091"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmm09
               NEXT FIELD pmm09
            WHEN INFIELD(pmn04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmn041"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
         END CASE
      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG 
         CALL cl_cmdask()    
         
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG    
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about     
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help()
 
      ON ACTION ACCEPT
         ACCEPT DIALOG 

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
         
      ON ACTION qbe_save
         CALL cl_qbe_save()

      AFTER DIALOG 
         IF NOT q600_check() THEN 
            #CALL cl_err('','apm-818',0)
            CALL cl_err('','apm1086',0)
            CONTINUE DIALOG
         END IF
         
   END DIALOG
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      RETURN
   END IF

END FUNCTION

FUNCTION q600_table()
     DROP TABLE q600_tmp;
     CREATE TEMP TABLE q600_tmp(
            pmm09    LIKE pmm_file.pmm09,
            pmc03    LIKE pmc_file.pmc03,
            pmn04    LIKE pmn_file.pmn04,
            pmn041   LIKE pmn_file.pmn041,
            ima021   LIKE ima_file.ima021,
            pmm22    LIKE pmm_file.pmm22,
            pmn86    LIKE pmn_file.pmn86,
            pmn31    LIKE pmn_file.pmn31,
            pmn31t   LIKE pmn_file.pmn31t,
            pmn87    LIKE pmn_file.pmn87,
            pmn88    LIKE pmn_file.pmn88,
            pmn88t   LIKE pmn_file.pmn88t,
            stb10    LIKE stb_file.stb10,
            pmn88b   LIKE pmn_file.pmn88,
            ccc23    LIKE ccc_file.ccc23,
            pmn88c   LIKE pmn_file.pmn88,
            pmm04    LIKE pmm_file.pmm04,
            pmn31a   LIKE pmn_file.pmn31,
            pmn88_b  LIKE pmn_file.pmn88,
            pmn88_p  LIKE type_file.num15_3,
            amt01a   LIKE pmn_file.pmn31,
            amt01b   LIKE pmn_file.pmn31t,
            amt01c   LIKE pmn_file.pmn87,
            amt01d   LIKE pmn_file.pmn88,
            amt01e   LIKE pmn_file.pmn88t,
            amt02a   LIKE pmn_file.pmn31,
            amt02b   LIKE pmn_file.pmn31t,
            amt02c   LIKE pmn_file.pmn87,
            amt02d   LIKE pmn_file.pmn88,
            amt02e   LIKE pmn_file.pmn88t,
            amt03a   LIKE pmn_file.pmn31,
            amt03b   LIKE pmn_file.pmn31t,
            amt03c   LIKE pmn_file.pmn87,
            amt03d   LIKE pmn_file.pmn88,
            amt03e   LIKE pmn_file.pmn88t,
            amt04a   LIKE pmn_file.pmn31,
            amt04b   LIKE pmn_file.pmn31t,
            amt04c   LIKE pmn_file.pmn87,
            amt04d   LIKE pmn_file.pmn88,
            amt04e   LIKE pmn_file.pmn88t,
            amt05a   LIKE pmn_file.pmn31,
            amt05b   LIKE pmn_file.pmn31t,
            amt05c   LIKE pmn_file.pmn87,
            amt05d   LIKE pmn_file.pmn88,
            amt05e   LIKE pmn_file.pmn88t,
            amt06a   LIKE pmn_file.pmn31,
            amt06b   LIKE pmn_file.pmn31t,
            amt06c   LIKE pmn_file.pmn87,
            amt06d   LIKE pmn_file.pmn88,
            amt06e   LIKE pmn_file.pmn88t,
            amt07a   LIKE pmn_file.pmn31,
            amt07b   LIKE pmn_file.pmn31t,
            amt07c   LIKE pmn_file.pmn87,
            amt07d   LIKE pmn_file.pmn88,
            amt07e   LIKE pmn_file.pmn88t,
            amt08a   LIKE pmn_file.pmn31,
            amt08b   LIKE pmn_file.pmn31t,
            amt08c   LIKE pmn_file.pmn87,
            amt08d   LIKE pmn_file.pmn88,
            amt08e   LIKE pmn_file.pmn88t,
            amt09a   LIKE pmn_file.pmn31,
            amt09b   LIKE pmn_file.pmn31t,
            amt09c   LIKE pmn_file.pmn87,
            amt09d   LIKE pmn_file.pmn88,
            amt09e   LIKE pmn_file.pmn88t,
            amt10a   LIKE pmn_file.pmn31,
            amt10b   LIKE pmn_file.pmn31t,
            amt10c   LIKE pmn_file.pmn87,
            amt10d   LIKE pmn_file.pmn88,
            amt10e   LIKE pmn_file.pmn88t,
            amt11a   LIKE pmn_file.pmn31,
            amt11b   LIKE pmn_file.pmn31t,
            amt11c   LIKE pmn_file.pmn87,
            amt11d   LIKE pmn_file.pmn88,
            amt11e   LIKE pmn_file.pmn88t,
            amt12a   LIKE pmn_file.pmn31,
            amt12b   LIKE pmn_file.pmn31t,
            amt12c   LIKE pmn_file.pmn87,
            amt12d   LIKE pmn_file.pmn88,
            amt12e   LIKE pmn_file.pmn88t,
            amt13a   LIKE pmn_file.pmn31,
            amt13b   LIKE pmn_file.pmn31t,
            amt13c   LIKE pmn_file.pmn87,
            amt13d   LIKE pmn_file.pmn88,
            amt13e   LIKE pmn_file.pmn88t,
            amt14a   LIKE pmn_file.pmn31,
            amt14b   LIKE pmn_file.pmn31t,
            amt14c   LIKE pmn_file.pmn87,
            amt14d   LIKE pmn_file.pmn88,
            amt14e   LIKE pmn_file.pmn88t,
            amt15a   LIKE pmn_file.pmn31,
            amt15b   LIKE pmn_file.pmn31t,
            amt15c   LIKE pmn_file.pmn87,
            amt15d   LIKE pmn_file.pmn88,
            amt15e   LIKE pmn_file.pmn88t,
            amt16a   LIKE pmn_file.pmn31,
            amt16b   LIKE pmn_file.pmn31t,
            amt16c   LIKE pmn_file.pmn87,
            amt16d   LIKE pmn_file.pmn88,
            amt16e   LIKE pmn_file.pmn88t,
            amt17a   LIKE pmn_file.pmn31,
            amt17b   LIKE pmn_file.pmn31t,
            amt17c   LIKE pmn_file.pmn87,
            amt17d   LIKE pmn_file.pmn88,
            amt17e   LIKE pmn_file.pmn88t,
            amt18a   LIKE pmn_file.pmn31,
            amt18b   LIKE pmn_file.pmn31t,
            amt18c   LIKE pmn_file.pmn87,
            amt18d   LIKE pmn_file.pmn88,
            amt18e   LIKE pmn_file.pmn88t,
            amt19a   LIKE pmn_file.pmn31,
            amt19b   LIKE pmn_file.pmn31t,
            amt19c   LIKE pmn_file.pmn87,
            amt19d   LIKE pmn_file.pmn88,
            amt19e   LIKE pmn_file.pmn88t,
            amt20a   LIKE pmn_file.pmn31,
            amt20b   LIKE pmn_file.pmn31t,
            amt20c   LIKE pmn_file.pmn87,
            amt20d   LIKE pmn_file.pmn88,
            amt20e   LIKE pmn_file.pmn88t,
            amt21a   LIKE pmn_file.pmn31,
            amt21b   LIKE pmn_file.pmn31t,
            amt21c   LIKE pmn_file.pmn87,
            amt21d   LIKE pmn_file.pmn88,
            amt21e   LIKE pmn_file.pmn88t,
            amt22a   LIKE pmn_file.pmn31,
            amt22b   LIKE pmn_file.pmn31t,
            amt22c   LIKE pmn_file.pmn87,
            amt22d   LIKE pmn_file.pmn88,
            amt22e   LIKE pmn_file.pmn88t,
            amt23a   LIKE pmn_file.pmn31,
            amt23b   LIKE pmn_file.pmn31t,
            amt23c   LIKE pmn_file.pmn87,
            amt23d   LIKE pmn_file.pmn88,
            amt23e   LIKE pmn_file.pmn88t,
            amt24a   LIKE pmn_file.pmn31,
            amt24b   LIKE pmn_file.pmn31t,
            amt24c   LIKE pmn_file.pmn87,
            amt24d   LIKE pmn_file.pmn88,
            amt24e   LIKE pmn_file.pmn88t,
            amt25a   LIKE pmn_file.pmn31,
            amt25b   LIKE pmn_file.pmn31t,
            amt25c   LIKE pmn_file.pmn87,
            amt25d   LIKE pmn_file.pmn88,
            amt25e   LIKE pmn_file.pmn88t,
            amt26a   LIKE pmn_file.pmn31,
            amt26b   LIKE pmn_file.pmn31t,
            amt26c   LIKE pmn_file.pmn87,
            amt26d   LIKE pmn_file.pmn88,
            amt26e   LIKE pmn_file.pmn88t,
            amt27a   LIKE pmn_file.pmn31,
            amt27b   LIKE pmn_file.pmn31t,
            amt27c   LIKE pmn_file.pmn87,
            amt27d   LIKE pmn_file.pmn88,
            amt27e   LIKE pmn_file.pmn88t,
            amt28a   LIKE pmn_file.pmn31,
            amt28b   LIKE pmn_file.pmn31t,
            amt28c   LIKE pmn_file.pmn87,
            amt28d   LIKE pmn_file.pmn88,
            amt28e   LIKE pmn_file.pmn88t,
            amt29a   LIKE pmn_file.pmn31,
            amt29b   LIKE pmn_file.pmn31t,
            amt29c   LIKE pmn_file.pmn87,
            amt29d   LIKE pmn_file.pmn88,
            amt29e   LIKE pmn_file.pmn88t,
            amt30a   LIKE pmn_file.pmn31,
            amt30b   LIKE pmn_file.pmn31t,
            amt30c   LIKE pmn_file.pmn87,
            amt30d   LIKE pmn_file.pmn88,
            amt30e   LIKE pmn_file.pmn88t,
            amt31a   LIKE pmn_file.pmn31,
            amt31b   LIKE pmn_file.pmn31t,
            amt31c   LIKE pmn_file.pmn87,
            amt31d   LIKE pmn_file.pmn88,
            amt31e   LIKE pmn_file.pmn88t);    
END FUNCTION

FUNCTION q600()
DEFINE l_sql  STRING
DEFINE l_str  STRING
DEFINE l_str1 STRING

   CALL q600_table()    

   LET g_sql = "INSERT INTO q600_tmp SELECT DISTINCT pmm09,'',pmn04,'','',pmm22,pmn86" 

   IF cl_null(tm.yy) THEN LET tm.yy=0 END IF
   IF cl_null(tm.mm) THEN LET tm.mm=0 END IF
   IF tm.c = '1' THEN
      IF tm.d ='Y' THEN 
         LET g_sql = g_sql CLIPPED,",AVG(pmn31* NVL(pmm42,1)),AVG(pmn31t* NVL(pmm42,1)),SUM(pmn87),",
                     "  SUM(pmn88* NVL(pmm42,1)),SUM(pmn88t* NVL(pmm42,1)),",
                     "  NVL(AVG(NVL(stb10*NVL(pmm42,1),0)),0),'',NVL(AVG(NVL(ccc23*NVL(pmm42,1),0)),0),'','','','','',  ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','' ",
                     " FROM pmm_file,pmn_file ",
                     "  LEFT OUTER JOIN stb_file ON stb01 = pmn04 AND stb02 =",tm.yy," AND stb03 = ",tm.mm,
                     "  LEFT OUTER JOIN ccc_file ON ccc01 = pmn04 AND ccc02 =",tm.yy," AND ccc03 = ",tm.mm,
                     " WHERE pmm01 = pmn01",
                     "   AND ",tm.wc,
                     "   AND (pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                     " GROUP BY pmm09,pmn04,pmm22,pmn86",
                     " ORDER BY pmn04 "
      ELSE
         LET g_sql = g_sql CLIPPED,",AVG(pmn31),AVG(pmn31t),SUM(pmn87),",
                     "  SUM(pmn88),SUM(pmn88t),",
                     "  AVG(NVL(stb10,0)),'',AVG(NVL(ccc23,0)),'','','','','',  ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','' ",
                     " FROM pmm_file,pmn_file ",
                     "  LEFT OUTER JOIN stb_file ON stb01 = pmn04 AND stb02 =",tm.yy," AND stb03 = ",tm.mm,
                     "  LEFT OUTER JOIN ccc_file ON ccc01 = pmn04 AND ccc02 =",tm.yy," AND ccc03 = ",tm.mm,
                     " WHERE pmm01 = pmn01",
                     "   AND ",tm.wc,
                     "   AND (pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                     " GROUP BY pmm09,pmn04,pmm22,pmn86",
                     " ORDER BY pmn04 "
      END IF  
   ELSE
      IF tm.d='Y' THEN 
         LET g_sql = g_sql CLIPPED,",AVG(rvv38* NVL(pmm42,1)),AVG(rvv38t*NVL(pmm42,1)),SUM(pmn87),",
                     "  SUM(rvv39*NVL(pmm42,1)),SUM(rvv39t*NVL(pmm42,1)),",
                     "  AVG(NVL(stb10*NVL(pmm42,1),0)),'',AVG(NVL(ccc23*NVL(pmm42,1),0)),'','','','','',  ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','' ",
                     " FROM pmm_file,pmn_file ",
                     "  LEFT OUTER JOIN rvv_file ON pmn01 = rvv36 AND pmn02 = rvv37 ",
                     "  LEFT OUTER JOIN stb_file ON stb01 = pmn04 AND stb02 =",tm.yy," AND stb03 = ",tm.mm,
                     "  LEFT OUTER JOIN ccc_file ON ccc01 = pmn04 AND ccc02 =",tm.yy," AND ccc03 = ",tm.mm,
                     " WHERE pmm01 = pmn01",
                     "   AND ",tm.wc,
                     "   AND (pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                     " GROUP BY pmm09,pmn04,pmm22,pmn86",
                     " ORDER BY pmn04 "
      ELSE
         LET g_sql = g_sql CLIPPED,",AVG(rvv38),AVG(rvv38t),SUM(pmn87),",
                     "  SUM(rvv39),SUM(rvv39t),",
                     "  AVG(NVL(stb10,0)),'',AVG(NVL(ccc23,0)),'','','','','',  ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','',  '','','','','', ",
                     "  '','','','','',   '','','','','',  '','','','','' ",
                     " FROM pmm_file,pmn_file ",
                     "  LEFT OUTER JOIN rvv_file ON pmn01 = rvv36 AND pmn02 = rvv37 ",
                     "  LEFT OUTER JOIN stb_file ON stb01 = pmn04 AND stb02 =",tm.yy," AND stb03 = ",tm.mm,
                     "  LEFT OUTER JOIN ccc_file ON ccc01 = pmn04 AND ccc02 =",tm.yy," AND ccc03 = ",tm.mm,
                     " WHERE pmm01 = pmn01",
                     "   AND ",tm.wc,
                     "   AND (pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                     " GROUP BY pmm09,pmn04,pmm22,pmn86",
                     " ORDER BY pmn04 "
      END IF       
   END IF
   PREPARE q600_pb FROM g_sql
   EXECUTE q600_pb 
   FREE q600_pb

   LET l_sql = " UPDATE q600_tmp c ",
               "    SET c.pmm04 = ",
               "   (SELECT MAX(a.pmm04) FROM pmm_file a,pmn_file b",
               "   WHERE a.pmm01= b.pmn01 ",
               "     AND b.pmn04 = c.pmn04 ",
               "     AND a.pmm09 = c.pmm09 ",
               "     AND a.pmm22 = c.pmm22 ",
               "     AND b.pmn86 = c.pmn86) ",
               "WHERE EXISTS (SELECT * FROM pmm_file a,pmn_file b ",
               "               WHERE a.pmm01= b.pmn01 ",
               "                 AND b.pmn04 = c.pmn04 ",
               "   AND a.pmm09 = c.pmm09 ",
               "   AND a.pmm22 = c.pmm22 ",
               "   AND b.pmn86 = c.pmn86 )"
   PREPARE q600_pmm04 FROM l_sql
   EXECUTE q600_pmm04
   FREE q600_pmm04

   LET l_sql = " UPDATE q600_tmp c ",
               "    SET c.stb10 = ",
               "   (SELECT NVL(stb10,0) FROM q600_tmp a",
               "   WHERE a.pmn04= c.pmn04 ",
               "     AND a.pmm09 = c.pmm09 ",
               "     AND a.pmm22 = c.pmm22 ",
               "     AND a.pmn86 = c.pmn86) ",
               "WHERE EXISTS (SELECT * FROM q600_tmp a ",
               "               WHERE a.pmn04= c.pmn04 ",
               "                 AND a.pmm09 = c.pmm09 ",
               "                 AND a.pmm22 = c.pmm22 ",
               "                 AND a.pmn86 = c.pmn86 )"
   PREPARE q600_stb10 FROM l_sql
   EXECUTE q600_stb10
   FREE q600_stb10 
   
   LET l_sql = " UPDATE q600_tmp c ",
               "    SET c.ccc23 = ",
               "   (SELECT NVL(ccc23,0) FROM q600_tmp a",
               "   WHERE a.pmn04= c.pmn04 ",
               "     AND a.pmm09 = c.pmm09 ",
               "     AND a.pmm22 = c.pmm22 ",
               "     AND a.pmn86 = c.pmn86) ",
               "WHERE EXISTS (SELECT * FROM q600_tmp a ",
               "               WHERE a.pmn04= c.pmn04 ",
               "                 AND a.pmm09 = c.pmm09 ",
               "                 AND a.pmm22 = c.pmm22 ",
               "                 AND a.pmn86 = c.pmn86 )"
   PREPARE q600_ccc23 FROM l_sql
   EXECUTE q600_ccc23
   FREE q600_ccc23 
   
   IF tm.c = '1' THEN
      IF tm.d = 'Y' THEN
      LET g_sql = "UPDATE q600_tmp c ",
                  " SET (amt99a,amt99b,amt99c,amt99d,amt99e)",
                  "   = (SELECT AVG(b.pmn31* NVL(pmm42,1)),AVG(b.pmn31t* NVL(pmm42,1)),SUM(b.pmn87),",
                  "             SUM(b.pmn88* NVL(pmm42,1)),SUM(b.pmn88t* NVL(pmm42,1)) ",
                  "  FROM pmm_file a,pmn_file b ",
                  " WHERE a.pmm01= b.pmn01 ",
                  "   AND b.pmn04 = c.pmn04 ",
                  "   AND a.pmm09 = c.pmm09 ",
                  "   AND a.pmm22 = c.pmm22 ",
                  "   AND b.pmn86 = c.pmn86 ",
                  "   AND a.pmm04 >=?  AND a.pmm04 < ? )",
                  " WHERE EXISTS (SELECT * FROM pmm_file a,pmn_file b ",
                  "               WHERE a.pmm01= b.pmn01 ",
                  "                 AND b.pmn04 = c.pmn04 ", 
                  "   AND a.pmm09 = c.pmm09 ", 
                  "   AND a.pmm22 = c.pmm22 ",
                  "   AND b.pmn86 = c.pmn86 ",
                  "   AND a.pmm04 >=?  AND a.pmm04 < ? )"  
      ELSE
         LET g_sql = "UPDATE q600_tmp c ",
                     " SET (amt99a,amt99b,amt99c,amt99d,amt99e)",
                     "   = (SELECT AVG(b.pmn31),AVG(b.pmn31t),SUM(b.pmn87),SUM(b.pmn88),SUM(b.pmn88t) ",
                     "  FROM pmm_file a,pmn_file b ",
                     " WHERE a.pmm01= b.pmn01 ",
                     "   AND b.pmn04 = c.pmn04 ",
                     "   AND a.pmm09 = c.pmm09 ",
                     "   AND a.pmm22 = c.pmm22 ",
                     "   AND b.pmn86 = c.pmn86 ",
                     "   AND a.pmm04 >=?  AND a.pmm04 < ? )",
                     " WHERE EXISTS (SELECT * FROM pmm_file a,pmn_file b ",
                     "               WHERE a.pmm01= b.pmn01 ",
                     "                 AND b.pmn04 = c.pmn04 ", 
                     "   AND a.pmm09 = c.pmm09 ", 
                     "   AND a.pmm22 = c.pmm22 ",
                     "   AND b.pmn86 = c.pmn86 ",
                     "   AND a.pmm04 >=?  AND a.pmm04 < ? )"  
      END IF            
   ELSE
      IF tm.d='Y' THEN 
         LET g_sql = "UPDATE q600_tmp c ",
                     " SET (amt99a,amt99b,amt99c,amt99d,amt99e)",
                     "   = (SELECT AVG(d.rvv38* NVL(pmm42,1)),AVG(d.rvv38t* NVL(pmm42,1)),SUM(b.pmn87),",
                     "             SUM(d.rvv39* NVL(pmm42,1)),SUM(d.rvv39t* NVL(pmm42,1)) ",
                     "  FROM pmm_file a,pmn_file b ",
                     "  LEFT OUTER JOIN rvv_file d ON b.pmn01 = d.rvv36 AND b.pmn02 = d.rvv37 ",
                     " WHERE a.pmm01= b.pmn01 ",
                     "   AND b.pmn04 = c.pmn04 ",
                     "   AND a.pmm09 = c.pmm09 ",
                     "   AND a.pmm22 = c.pmm22 ",
                     "   AND b.pmn86 = c.pmn86 ",
                     "   AND a.pmm04 >=?  AND a.pmm04 < ? )",                  
                     " WHERE EXISTS (SELECT * FROM pmm_file a,pmn_file b ",
                     "                 LEFT OUTER JOIN rvv_file d ON b.pmn01 = d.rvv36 AND b.pmn02 = d.rvv37 ",
                     "               WHERE a.pmm01= b.pmn01 ",
                     "                 AND b.pmn04 = c.pmn04 ",
                     "   AND a.pmm09 = c.pmm09 ", 
                     "   AND a.pmm22 = c.pmm22 ",
                     "   AND b.pmn86 = c.pmn86 ",
                     "   AND a.pmm04 >=?  AND a.pmm04 < ? )"   
      ELSE
         LET g_sql = "UPDATE q600_tmp c ",
                     " SET (amt99a,amt99b,amt99c,amt99d,amt99e)",
                     "   = (SELECT AVG(d.rvv38),AVG(d.rvv38t),SUM(b.pmn87),SUM(d.rvv39),SUM(d.rvv39t) ",
                     "  FROM pmm_file a,pmn_file b ",
                     "  LEFT OUTER JOIN rvv_file d ON b.pmn01 = d.rvv36 AND b.pmn02 = d.rvv37 ",
                     " WHERE a.pmm01= b.pmn01 ",
                     "   AND b.pmn04 = c.pmn04 ",
                     "   AND a.pmm09 = c.pmm09 ",
                     "   AND a.pmm22 = c.pmm22 ",
                     "   AND b.pmn86 = c.pmn86 ",
                     "   AND a.pmm04 >=?  AND a.pmm04 < ? )",                  
                     " WHERE EXISTS (SELECT * FROM pmm_file a,pmn_file b ",
                     "                 LEFT OUTER JOIN rvv_file d ON b.pmn01 = d.rvv36 AND b.pmn02 = d.rvv37 ",
                     "               WHERE a.pmm01= b.pmn01 ",
                     "                 AND b.pmn04 = c.pmn04 ",
                     "   AND a.pmm09 = c.pmm09 ", 
                     "   AND a.pmm22 = c.pmm22 ",
                     "   AND b.pmn86 = c.pmn86 ",
                     "   AND a.pmm04 >=?  AND a.pmm04 < ? )"  
      END IF
   END IF   
   
   CASE tm.a
      WHEN '1'  CALL q600_week()
      WHEN '2'  CALL q600_tendays()
      WHEN '3'  CALL q600_month()
      WHEN '4'  CALL q600_year()
   END CASE
 
   CALL q600_show()

END FUNCTION

FUNCTION q600_b_fill()
DEFINE l_sql   STRING
DEFINE l_str   STRING
DEFINE l_str1  STRING
DEFINE l_str2  STRING
DEFINE l_sql1  STRING
DEFINE l_sql2  STRING
DEFINE lc_index  STRING
DEFINE l_ima44 LIKE ima_file.ima44,
       l_i       LIKE type_file.num5,
       l_i1      LIKE type_file.num5,  
       l_fac     LIKE type_file.num26_10,
       l_pmm42   LIKE pmm_file.pmm42

   CALL g_pmn.clear()
   
   IF tm.e = 'Y' THEN
      LET l_sql = " UPDATE q600_tmp ",
                  "    SET pmn31  = ?,",
                  "        pmn31t = ?,",
                  "        pmn87  = ?,",
                  "        stb10  = ?,",
                  "        ccc23  = ?,",
                  "        pmn88b = ?,",
                  "        pmn88c = ?,",
                  "        pmn88_b= ?,",
                  "        pmn88_p= ?,",
                  "        amt01a = ?,",
                  "        amt01b = ?,",
                  "        amt01c = ?,",
                  "        amt02a = ?,",
                  "        amt02b = ?,",
                  "        amt02c = ?,",
                  "        amt03a = ?,",
                  "        amt03b = ?,",
                  "        amt03c = ?,",
                  "        amt04a = ?,",
                  "        amt04b = ?,",
                  "        amt04c = ?,",
                  "        amt05a = ?,",
                  "        amt05b = ?,",
                  "        amt05c = ?,",
                  "        amt06a = ?,",
                  "        amt06b = ?,",
                  "        amt06c = ?,",
                  "        amt07a = ?,",
                  "        amt07b = ?,",
                  "        amt07c = ?,",
                  "        amt08a = ?,",
                  "        amt08b = ?,",
                  "        amt08c = ?,",
                  "        amt09a = ?,",
                  "        amt09b = ?,",
                  "        amt09c = ?,",
                  "        amt10a = ?,",
                  "        amt10b = ?,",
                  "        amt10c = ?,",
                  "        amt11a = ?,",
                  "        amt11b = ?,",
                  "        amt11c = ?,",
                  "        amt12a = ?,",
                  "        amt12b = ?,",
                  "        amt12c = ?,",
                  "        amt13a = ?,",
                  "        amt13b = ?,",
                  "        amt13c = ?,",
                  "        amt14a = ?,",
                  "        amt14b = ?,",
                  "        amt14c = ?,",
                  "        amt15a = ?,",
                  "        amt15b = ?,",
                  "        amt15c = ?,",
                  "        amt16a = ?,",
                  "        amt16b = ?,",
                  "        amt16c = ?,",
                  "        amt17a = ?,",
                  "        amt17b = ?,",
                  "        amt17c = ?,",
                  "        amt18a = ?,",
                  "        amt18b = ?,",
                  "        amt18c = ?,",
                  "        amt19a = ?,",
                  "        amt19b = ?,",
                  "        amt19c = ?,",
                  "        amt20a = ?,",
                  "        amt20b = ?,",
                  "        amt20c = ?,",
                  "        amt21a = ?,",
                  "        amt21b = ?,",
                  "        amt21c = ?,",
                  "        amt22a = ?,",
                  "        amt22b = ?,",
                  "        amt22c = ?,",
                  "        amt23a = ?,",
                  "        amt23b = ?,",
                  "        amt23c = ?,",
                  "        amt24a = ?,",
                  "        amt24b = ?,",
                  "        amt24c = ?,",
                  "        amt25a = ?,",
                  "        amt25b = ?,",
                  "        amt25c = ?,",
                  "        amt26a = ?,",
                  "        amt26b = ?,",
                  "        amt26c = ?,",
                  "        amt27a = ?,",
                  "        amt27b = ?,",
                  "        amt27c = ?,",
                  "        amt28a = ?,",
                  "        amt28b = ?,",
                  "        amt28c = ?,",
                  "        amt29a = ?,",   
                  "        amt29b = ?,",
                  "        amt29c = ?,",
                  "        amt30a = ?,",
                  "        amt30b = ?,",
                  "        amt30c = ?,",
                  "        amt31a = ?,",
                  "        amt31b = ?,",
                  "        amt31c = ? ",
                  " WHERE pmm09  = ? ",
                  "   AND pmn04  = ? ",
                  "   AND pmm22  = ? ",
                  "   AND pmn86  = ? "
      PREPARE upd_tmp FROM l_sql           
      LET g_cnt =1
      LET l_sql = "SELECT a.* FROM q600_tmp a "
      PREPARE q600_pr FROM l_sql
      DECLARE q600_cs CURSOR FOR q600_pr
      FOREACH q600_cs INTO g_pmn[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         SELECT ima44 INTO l_ima44 FROM ima_file
          WHERE ima01 = g_pmn[g_cnt].pmn04       
         CALL s_umfchk(g_pmn[g_cnt].pmn04 ,g_pmn[g_cnt].pmn86,l_ima44) RETURNING l_i,l_fac
         LET g_pmn[g_cnt].pmn31  = g_pmn[g_cnt].pmn31  * l_fac
         LET g_pmn[g_cnt].pmn31t = g_pmn[g_cnt].pmn31t * l_fac
         LET g_pmn[g_cnt].pmn87  = g_pmn[g_cnt].pmn87  * l_fac
         LET g_pmn[g_cnt].stb10  = g_pmn[g_cnt].stb10  * l_fac
         LET g_pmn[g_cnt].ccc23  = g_pmn[g_cnt].ccc23  * l_fac 
         
         LET g_pmn[g_cnt].amt01a = g_pmn[g_cnt].amt01a * l_fac
         LET g_pmn[g_cnt].amt01b = g_pmn[g_cnt].amt01b * l_fac
         LET g_pmn[g_cnt].amt01c = g_pmn[g_cnt].amt01c * l_fac
         LET g_pmn[g_cnt].amt02a = g_pmn[g_cnt].amt02a * l_fac
         LET g_pmn[g_cnt].amt02b = g_pmn[g_cnt].amt02b * l_fac
         LET g_pmn[g_cnt].amt02c = g_pmn[g_cnt].amt02c * l_fac
         LET g_pmn[g_cnt].amt03a = g_pmn[g_cnt].amt03a * l_fac
         LET g_pmn[g_cnt].amt03b = g_pmn[g_cnt].amt03b * l_fac
         LET g_pmn[g_cnt].amt03c = g_pmn[g_cnt].amt03c * l_fac
         LET g_pmn[g_cnt].amt04a = g_pmn[g_cnt].amt04a * l_fac
         LET g_pmn[g_cnt].amt04b = g_pmn[g_cnt].amt04b * l_fac
         LET g_pmn[g_cnt].amt04c = g_pmn[g_cnt].amt04c * l_fac
         LET g_pmn[g_cnt].amt05a = g_pmn[g_cnt].amt05a * l_fac
         LET g_pmn[g_cnt].amt05b = g_pmn[g_cnt].amt05b * l_fac
         LET g_pmn[g_cnt].amt05c = g_pmn[g_cnt].amt05c * l_fac
         
         LET g_pmn[g_cnt].amt06a = g_pmn[g_cnt].amt06a * l_fac
         LET g_pmn[g_cnt].amt06b = g_pmn[g_cnt].amt06b * l_fac
         LET g_pmn[g_cnt].amt06c = g_pmn[g_cnt].amt06c * l_fac
         LET g_pmn[g_cnt].amt07a = g_pmn[g_cnt].amt07a * l_fac
         LET g_pmn[g_cnt].amt07b = g_pmn[g_cnt].amt07b * l_fac
         LET g_pmn[g_cnt].amt07c = g_pmn[g_cnt].amt07c * l_fac
         LET g_pmn[g_cnt].amt08a = g_pmn[g_cnt].amt08a * l_fac
         LET g_pmn[g_cnt].amt08b = g_pmn[g_cnt].amt08b * l_fac
         LET g_pmn[g_cnt].amt08c = g_pmn[g_cnt].amt08c * l_fac
         LET g_pmn[g_cnt].amt09a = g_pmn[g_cnt].amt09a * l_fac
         LET g_pmn[g_cnt].amt09b = g_pmn[g_cnt].amt09b * l_fac
         LET g_pmn[g_cnt].amt09c = g_pmn[g_cnt].amt09c * l_fac
         LET g_pmn[g_cnt].amt10a = g_pmn[g_cnt].amt10a * l_fac
         LET g_pmn[g_cnt].amt10b = g_pmn[g_cnt].amt10b * l_fac
         LET g_pmn[g_cnt].amt10c = g_pmn[g_cnt].amt10c * l_fac
         
         LET g_pmn[g_cnt].amt11a = g_pmn[g_cnt].amt11a * l_fac
         LET g_pmn[g_cnt].amt11b = g_pmn[g_cnt].amt11b * l_fac
         LET g_pmn[g_cnt].amt11c = g_pmn[g_cnt].amt11c * l_fac
         LET g_pmn[g_cnt].amt12a = g_pmn[g_cnt].amt12a * l_fac
         LET g_pmn[g_cnt].amt12b = g_pmn[g_cnt].amt12b * l_fac
         LET g_pmn[g_cnt].amt12c = g_pmn[g_cnt].amt12c * l_fac
         LET g_pmn[g_cnt].amt13a = g_pmn[g_cnt].amt13a * l_fac
         LET g_pmn[g_cnt].amt13b = g_pmn[g_cnt].amt13b * l_fac
         LET g_pmn[g_cnt].amt13c = g_pmn[g_cnt].amt13c * l_fac
         LET g_pmn[g_cnt].amt14a = g_pmn[g_cnt].amt14a * l_fac
         LET g_pmn[g_cnt].amt14b = g_pmn[g_cnt].amt14b * l_fac
         LET g_pmn[g_cnt].amt14c = g_pmn[g_cnt].amt14c * l_fac
         LET g_pmn[g_cnt].amt15a = g_pmn[g_cnt].amt15a * l_fac
         LET g_pmn[g_cnt].amt15b = g_pmn[g_cnt].amt15b * l_fac
         LET g_pmn[g_cnt].amt15c = g_pmn[g_cnt].amt15c * l_fac
         
         LET g_pmn[g_cnt].amt16a = g_pmn[g_cnt].amt16a * l_fac
         LET g_pmn[g_cnt].amt16b = g_pmn[g_cnt].amt16b * l_fac
         LET g_pmn[g_cnt].amt16c = g_pmn[g_cnt].amt16c * l_fac
         LET g_pmn[g_cnt].amt17a = g_pmn[g_cnt].amt17a * l_fac
         LET g_pmn[g_cnt].amt17b = g_pmn[g_cnt].amt17b * l_fac
         LET g_pmn[g_cnt].amt17c = g_pmn[g_cnt].amt17c * l_fac
         LET g_pmn[g_cnt].amt18a = g_pmn[g_cnt].amt18a * l_fac
         LET g_pmn[g_cnt].amt18b = g_pmn[g_cnt].amt18b * l_fac
         LET g_pmn[g_cnt].amt18c = g_pmn[g_cnt].amt18c * l_fac
         LET g_pmn[g_cnt].amt19a = g_pmn[g_cnt].amt19a * l_fac
         LET g_pmn[g_cnt].amt19b = g_pmn[g_cnt].amt19b * l_fac
         LET g_pmn[g_cnt].amt19c = g_pmn[g_cnt].amt19c * l_fac
         LET g_pmn[g_cnt].amt20a = g_pmn[g_cnt].amt20a * l_fac
         LET g_pmn[g_cnt].amt20b = g_pmn[g_cnt].amt20b * l_fac
         LET g_pmn[g_cnt].amt20c = g_pmn[g_cnt].amt20c * l_fac 
         
         LET g_pmn[g_cnt].amt21a = g_pmn[g_cnt].amt21a * l_fac
         LET g_pmn[g_cnt].amt21b = g_pmn[g_cnt].amt21b * l_fac
         LET g_pmn[g_cnt].amt21c = g_pmn[g_cnt].amt22c * l_fac
         LET g_pmn[g_cnt].amt22a = g_pmn[g_cnt].amt22a * l_fac
         LET g_pmn[g_cnt].amt22b = g_pmn[g_cnt].amt22b * l_fac
         LET g_pmn[g_cnt].amt22c = g_pmn[g_cnt].amt22c * l_fac
         LET g_pmn[g_cnt].amt23a = g_pmn[g_cnt].amt23a * l_fac
         LET g_pmn[g_cnt].amt23b = g_pmn[g_cnt].amt23b * l_fac
         LET g_pmn[g_cnt].amt23c = g_pmn[g_cnt].amt23c * l_fac
         LET g_pmn[g_cnt].amt24a = g_pmn[g_cnt].amt24a * l_fac
         LET g_pmn[g_cnt].amt24b = g_pmn[g_cnt].amt24b * l_fac
         LET g_pmn[g_cnt].amt24c = g_pmn[g_cnt].amt24c * l_fac
         LET g_pmn[g_cnt].amt25a = g_pmn[g_cnt].amt25a * l_fac
         LET g_pmn[g_cnt].amt25b = g_pmn[g_cnt].amt25b * l_fac
         LET g_pmn[g_cnt].amt25c = g_pmn[g_cnt].amt25c * l_fac
         
         LET g_pmn[g_cnt].amt26a = g_pmn[g_cnt].amt26a * l_fac
         LET g_pmn[g_cnt].amt26b = g_pmn[g_cnt].amt26b * l_fac
         LET g_pmn[g_cnt].amt26c = g_pmn[g_cnt].amt26c * l_fac
         LET g_pmn[g_cnt].amt27a = g_pmn[g_cnt].amt27a * l_fac
         LET g_pmn[g_cnt].amt27b = g_pmn[g_cnt].amt27b * l_fac
         LET g_pmn[g_cnt].amt27c = g_pmn[g_cnt].amt27c * l_fac
         LET g_pmn[g_cnt].amt28a = g_pmn[g_cnt].amt28a * l_fac
         LET g_pmn[g_cnt].amt28b = g_pmn[g_cnt].amt28b * l_fac
         LET g_pmn[g_cnt].amt28c = g_pmn[g_cnt].amt28c * l_fac
         LET g_pmn[g_cnt].amt29a = g_pmn[g_cnt].amt29a * l_fac
         LET g_pmn[g_cnt].amt29b = g_pmn[g_cnt].amt29b * l_fac
         LET g_pmn[g_cnt].amt29c = g_pmn[g_cnt].amt29c * l_fac
         LET g_pmn[g_cnt].amt30a = g_pmn[g_cnt].amt30a * l_fac
         LET g_pmn[g_cnt].amt30b = g_pmn[g_cnt].amt30b * l_fac
         LET g_pmn[g_cnt].amt30c = g_pmn[g_cnt].amt30c * l_fac 
         LET g_pmn[g_cnt].amt31a = g_pmn[g_cnt].amt31a * l_fac
         LET g_pmn[g_cnt].amt31b = g_pmn[g_cnt].amt31b * l_fac
         LET g_pmn[g_cnt].amt31c = g_pmn[g_cnt].amt31c * l_fac           

         EXECUTE upd_tmp 
           USING g_pmn[g_cnt].pmn31,g_pmn[g_cnt].pmn31t,g_pmn[g_cnt].pmn87,
                 g_pmn[g_cnt].stb10,g_pmn[g_cnt].ccc23,g_pmn[g_cnt].pmn88b,
                 g_pmn[g_cnt].pmn88c,g_pmn[g_cnt].pmn88_b,g_pmn[g_cnt].pmn88_p,
                 g_pmn[g_cnt].amt01a,g_pmn[g_cnt].amt01b, g_pmn[g_cnt].amt01c,
                 g_pmn[g_cnt].amt02a,g_pmn[g_cnt].amt02b, g_pmn[g_cnt].amt02c, 
                 g_pmn[g_cnt].amt03a,g_pmn[g_cnt].amt03b, g_pmn[g_cnt].amt03c,
                 g_pmn[g_cnt].amt04a,g_pmn[g_cnt].amt04b, g_pmn[g_cnt].amt04c,
                 g_pmn[g_cnt].amt05a,g_pmn[g_cnt].amt05b, g_pmn[g_cnt].amt05c,  
                 g_pmn[g_cnt].amt06a,g_pmn[g_cnt].amt06b, g_pmn[g_cnt].amt06c,
                 g_pmn[g_cnt].amt07a,g_pmn[g_cnt].amt07b, g_pmn[g_cnt].amt07c,
                 g_pmn[g_cnt].amt08a,g_pmn[g_cnt].amt08b, g_pmn[g_cnt].amt08c,
                 g_pmn[g_cnt].amt09a,g_pmn[g_cnt].amt09b, g_pmn[g_cnt].amt09c,
                 g_pmn[g_cnt].amt10a,g_pmn[g_cnt].amt10b, g_pmn[g_cnt].amt10c,
                 g_pmn[g_cnt].amt11a,g_pmn[g_cnt].amt11b, g_pmn[g_cnt].amt11c,
                 g_pmn[g_cnt].amt12a,g_pmn[g_cnt].amt12b, g_pmn[g_cnt].amt12c,
                 g_pmn[g_cnt].amt13a,g_pmn[g_cnt].amt13b, g_pmn[g_cnt].amt13c,
                 g_pmn[g_cnt].amt14a,g_pmn[g_cnt].amt14b, g_pmn[g_cnt].amt14c,
                 g_pmn[g_cnt].amt15a,g_pmn[g_cnt].amt15b, g_pmn[g_cnt].amt15c,
                 g_pmn[g_cnt].amt16a,g_pmn[g_cnt].amt16b, g_pmn[g_cnt].amt16c,
                 g_pmn[g_cnt].amt17a,g_pmn[g_cnt].amt17b, g_pmn[g_cnt].amt17c,
                 g_pmn[g_cnt].amt18a,g_pmn[g_cnt].amt18b, g_pmn[g_cnt].amt18c,
                 g_pmn[g_cnt].amt19a,g_pmn[g_cnt].amt19b, g_pmn[g_cnt].amt19c,
                 g_pmn[g_cnt].amt20a,g_pmn[g_cnt].amt20b, g_pmn[g_cnt].amt20c,
                 g_pmn[g_cnt].amt21a,g_pmn[g_cnt].amt21b, g_pmn[g_cnt].amt21c,
                 g_pmn[g_cnt].amt22a,g_pmn[g_cnt].amt22b, g_pmn[g_cnt].amt22c,
                 g_pmn[g_cnt].amt23a,g_pmn[g_cnt].amt23b, g_pmn[g_cnt].amt23c,
                 g_pmn[g_cnt].amt24a,g_pmn[g_cnt].amt24b, g_pmn[g_cnt].amt24c,
                 g_pmn[g_cnt].amt25a,g_pmn[g_cnt].amt25b, g_pmn[g_cnt].amt25c,
                 g_pmn[g_cnt].amt26a,g_pmn[g_cnt].amt26b, g_pmn[g_cnt].amt26c,
                 g_pmn[g_cnt].amt27a,g_pmn[g_cnt].amt27b, g_pmn[g_cnt].amt27c,
                 g_pmn[g_cnt].amt28a,g_pmn[g_cnt].amt28b, g_pmn[g_cnt].amt28c,
                 g_pmn[g_cnt].amt29a,g_pmn[g_cnt].amt29b, g_pmn[g_cnt].amt29c,
                 g_pmn[g_cnt].amt30a,g_pmn[g_cnt].amt30b, g_pmn[g_cnt].amt30c,
                 g_pmn[g_cnt].amt31a,g_pmn[g_cnt].amt31b, g_pmn[g_cnt].amt31c,
                 g_pmn[g_cnt].pmm09,g_pmn[g_cnt].pmn04,g_pmn[g_cnt].pmm22,g_pmn[g_cnt].pmn86    
         LET g_cnt = g_cnt + 1
      END FOREACH
   END IF   
      
   CALL g_pmn.clear()
   LET g_cnt =1

   LET l_sql2 = " MERGE INTO q600_tmp o ",
                "      USING (SELECT pmn04,pmm09,pmm22,pmn86,pmn31 FROM q600_tmp ) x ",
                "    ON(o.pmn04 = x.pmn04 " 
                
   LET l_sql = "SELECT DISTINCT pmm09,c.pmc03,pmn04,ima02,b.ima021,pmm22,pmn86" 
   IF tm.b = '2' THEN 
      LET l_sql = cl_replace_str(l_sql,"pmm09","''")
      LET l_sql = cl_replace_str(l_sql,"c.pmc03","''")
      LET l_str = "GROUP BY pmn04,ima02,b.ima021"
   ELSE   
      LET l_str = "GROUP BY pmm09,c.pmc03,pmn04,ima02,b.ima021 "
      LET l_str2= l_str2," AND o.pmm09 = x.pmm09 "
      LET l_sql2= l_sql2," AND o.pmm09 = x.pmm09 "
   END IF 
   IF tm.d = 'Y' THEN 
      LET l_sql = cl_replace_str(l_sql,"pmm22","''")
   ELSE
      LET l_str=l_str CLIPPED,",pmm22 "
      LET l_str2= l_str2," AND o.pmm22=x.pmm22 "
      LET l_sql2=l_sql2," AND o.pmm22=x.pmm22 "    
   END IF 
   IF tm.e = 'Y' THEN 
      LET l_sql = cl_replace_str(l_sql,"pmn86","''")
   ELSE
      LET l_str=l_str CLIPPED,",pmn86 "
      LET l_str2= l_str2," AND o.pmn86=x.pmn86 "
      LET l_sql2= l_sql2," AND o.pmn86=x.pmn86 "
   END IF 

   LET l_sql2 = l_sql2,") WHEN MATCHED THEN UPDATE ",
                " SET pmn31a = (SELECT pmn31 FROM q600_tmp a WHERE rownum = 1 AND o.pmn04 = a.pmn04 ",l_str2,")"
   PREPARE pmn31a_pre FROM l_sql2   
   EXECUTE pmn31a_pre 
   FREE pmn31a_pre


   LET l_sql = l_sql,",AVG(pmn31),AVG(pmn31t),SUM(pmn87),SUM(pmn88),SUM(pmn88t),",
                     " AVG(stb10),SUM(pmn88b),AVG(ccc23),SUM(pmn88c),MAX(pmm04),AVG(pmn31a), ",
                     " SUM(pmn88_b),SUM(pmn88_p)"
   FOR l_i1= 1 TO 31
      LET lc_index = l_i1 USING '&&' 
      LET l_sql = l_sql,",AVG(amt"||lc_index||"a),AVG(amt"||lc_index||"b),AVG(amt"||lc_index||"c),AVG(amt"||lc_index||"d),AVG(amt"||lc_index||"e)"     
   END FOR 
   LET l_sql = l_sql," FROM q600_tmp a LEFT OUTER JOIN ima_file b ON b.ima01 = a.pmn04",
                     "     LEFT OUTER JOIN pmc_file c ON c.pmc01 = a.pmm09 ",l_str," ORDER BY pmn04"              
   PREPARE q600_pre1 FROM l_sql
   DECLARE q600_curs CURSOR FOR q600_pre1
   FOREACH q600_curs INTO g_pmn[g_cnt].*  
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF  
      LET g_pmn[g_cnt].pmn88b  = g_pmn[g_cnt].pmn87 * g_pmn[g_cnt].stb10
      LET g_pmn[g_cnt].pmn88c  = g_pmn[g_cnt].pmn87 * g_pmn[g_cnt].ccc23 
      LET g_pmn[g_cnt].pmn88_b = g_pmn[g_cnt].pmn88 - g_pmn[g_cnt].pmn88b
      LET g_pmn[g_cnt].pmn88_p = g_pmn[g_cnt].pmn88_b/g_pmn[g_cnt].pmn88b
      
      LET g_cnt = g_cnt + 1      
   END FOREACH 
   CALL g_pmn.deleteElement(g_cnt)
   CALL cl_show_fld_cont()
   LET g_cnt=g_cnt-1   
END FUNCTION

FUNCTION q600_show()
   DISPLAY tm.bdate,tm.edate,tm.yy,tm.mm,
           tm.a,tm.b,tm.c,tm.d,tm.e
        TO bdate,edate,yy,mm,a,b,c,d,e
       
   CALL q600_b_fill()  
   CALL cl_show_fld_cont()
END FUNCTION



FUNCTION q600_week()
DEFINE l_bdate LIKE type_file.dat
DEFINE l_edate LIKE type_file.dat
DEFINE l_i     LIKE type_file.num5
DEFINE l_ww    LIKE type_file.num5

   LET l_bdate = tm.bdate
   LET l_edate = tm.bdate
   LET l_ww = WEEKDAY(tm.bdate)
   LET l_edate = l_bdate + (7 - l_ww) + 1
   FOR l_i=1 TO g_count
      IF l_i = 1 THEN 
         LET l_bdate = tm.bdate 
      END IF
      IF l_i = g_count THEN 
         LET l_edate = tm.edate + 1
      END IF 
      CALL q600_amtt(l_i,l_bdate,l_edate)
      LET l_bdate = l_edate
      LET l_edate =cl_cal(l_edate,0,7) 
   END FOR
END FUNCTION
FUNCTION q600_tendays()
DEFINE l_day1   LIKE type_file.num5
DEFINE l_day2   LIKE type_file.num5
DEFINE l_bdate LIKE type_file.dat
DEFINE l_edate LIKE type_file.dat
DEFINE l_i     LIKE type_file.num5

   LET l_day1= DAY(tm.bdate)    
   IF l_day1 >= 1 AND l_day1<=10 THEN 
      LET l_edate = MDY(MONTH(tm.bdate),11,YEAR(tm.bdate))
   ELSE
      IF l_day1 > 10 AND l_day1<=20 THEN 
         LET l_edate = MDY(MONTH(tm.bdate),21,YEAR(tm.bdate))
      ELSE
         LET l_edate = MDY(MONTH(tm.bdate)+1,1,YEAR(tm.bdate)) 
      END IF
   END IF   
   
   FOR l_i=1 TO g_count
      IF l_i = 1 THEN 
         LET l_bdate = tm.bdate 
      END IF
      IF l_i = g_count THEN 
         LET l_edate = tm.edate + 1
      END IF 
      CALL q600_amtt(l_i,l_bdate,l_edate)
      LET l_bdate = l_edate
      LET l_day2= DAY(l_edate)
      IF l_day2 >= 1 AND l_day2<=10 THEN 
         LET l_edate = MDY(MONTH(tm.bdate),11,YEAR(tm.bdate))
      ELSE
         IF l_day2 > 10 AND l_day2<=20 THEN 
            LET l_edate = MDY(MONTH(tm.bdate),21,YEAR(tm.bdate))
         ELSE
            IF MONTH(tm.bdate) = 12 THEN
               LET l_edate = MDY(1,1,YEAR(tm.bdate)+1) 
            ELSE
               LET l_edate = MDY(MONTH(tm.bdate)+1,1,YEAR(tm.bdate))
            END IF   
         END IF
      END IF 
   END FOR
END FUNCTION
FUNCTION q600_month()
DEFINE l_byy   LIKE type_file.num5
DEFINE l_bmm   LIKE type_file.num5
DEFINE l_bdate LIKE type_file.dat
DEFINE l_edate LIKE type_file.dat
DEFINE l_i     LIKE type_file.num5
DEFINE l_days  LIKE type_file.num5
DEFINE l_edd   LIKE type_file.num5

   LET l_edate = tm.bdate
   LET l_byy = YEAR(tm.bdate)
   LET l_edd = DAY(tm.bdate)
   LET l_bmm = MONTH(tm.bdate)
     
   LET l_days= cl_days(l_byy,l_bmm)
   LET l_edate = l_edate +(l_days - l_edd + 1)
   FOR l_i=1 TO g_count
      IF l_i = 1 THEN 
         LET l_bdate = tm.bdate 
      END IF
      IF l_i = g_count THEN 
         LET l_edate = tm.edate + 1
      END IF   
      CALL q600_amtt(l_i,l_bdate,l_edate)
      LET l_bdate =l_edate
      LET l_edate =cl_cal(l_edate,1,0) 
   END FOR
END FUNCTION
FUNCTION q600_year()
DEFINE l_byy   LIKE type_file.num5
DEFINE l_eyy   LIKE type_file.num5
DEFINE l_bdate LIKE type_file.dat
DEFINE l_edate LIKE type_file.dat
DEFINE l_i     LIKE type_file.num5


   LET l_byy = YEAR(tm.bdate)
   LET l_eyy = YEAR(tm.edate)

   LET l_eyy = l_byy + 1
   LET l_edate = MDY(1,1,l_eyy)
   FOR l_i=1 TO g_count
      IF l_i = 1 THEN 
         LET l_bdate = tm.bdate 
      END IF
      IF l_i = g_count THEN 
         LET l_edate = tm.edate + 1
      END IF
      CALL q600_amtt(l_i,l_bdate,l_edate)
      LET l_bdate = l_edate
      LET l_eyy = l_eyy + 1 
      LET l_edate = MDY(1,1,l_eyy)   
   END FOR
END FUNCTION

FUNCTION q600_amtt(l_i,l_bdate,l_edate)
DEFINE l_i  LIKE type_file.num5
DEFINE l_bdate LIKE type_file.dat
DEFINE l_edate LIKE type_file.dat
DEFINE l_amta   LIKE pmn_file.pmn31,
       l_amtb   LIKE pmn_file.pmn31t,
       l_amtc   LIKE pmn_file.pmn87,
       l_amtd   LIKE pmn_file.pmn88,
       l_amte   LIKE pmn_file.pmn88t
DEFINE lc_index  STRING
DEFINE ls_sql    STRING
DEFINE ls_show   STRING  
DEFINE l_sql     STRING     

   LET l_sql = g_sql             
   CASE l_i
      WHEN 1 
         LET l_sql = cl_replace_str(l_sql,"99","01")
      WHEN 2 
         LET l_sql = cl_replace_str(l_sql,"99","02")
      WHEN 3 
         LET l_sql = cl_replace_str(l_sql,"99","03")
      WHEN 4 
         LET l_sql = cl_replace_str(l_sql,"99","04")
      WHEN 5 
         LET l_sql = cl_replace_str(l_sql,"99","05")
      WHEN 6 
         LET l_sql = cl_replace_str(l_sql,"99","06")
      WHEN 7 
         LET l_sql = cl_replace_str(l_sql,"99","07")
      WHEN 8 
         LET l_sql = cl_replace_str(l_sql,"99","08")
      WHEN 9 
         LET l_sql = cl_replace_str(l_sql,"99","09")  
      WHEN 10 
         LET l_sql = cl_replace_str(l_sql,"99","10")        
      WHEN 11 
         LET l_sql = cl_replace_str(l_sql,"99","11")
      WHEN 12 
         LET l_sql = cl_replace_str(l_sql,"99","12")
      WHEN 13 
         LET l_sql = cl_replace_str(l_sql,"99","13")
      WHEN 14 
         LET l_sql = cl_replace_str(l_sql,"99","14")
      WHEN 15 
         LET l_sql = cl_replace_str(l_sql,"99","15")
      WHEN 16 
         LET l_sql = cl_replace_str(l_sql,"99","16")
      WHEN 17 
         LET l_sql = cl_replace_str(l_sql,"99","17")
      WHEN 18 
         LET l_sql = cl_replace_str(l_sql,"99","18")
      WHEN 19 
         LET l_sql = cl_replace_str(l_sql,"99","19")
      WHEN 20 
         LET l_sql = cl_replace_str(l_sql,"99","20")        
      WHEN 21 
         LET l_sql = cl_replace_str(l_sql,"99","21") 
      WHEN 22 
         LET l_sql = cl_replace_str(l_sql,"99","22") 
      WHEN 23 
         LET l_sql = cl_replace_str(l_sql,"99","23") 
      WHEN 24 
         LET l_sql = cl_replace_str(l_sql,"99","24") 
      WHEN 25 
         LET l_sql = cl_replace_str(l_sql,"99","25") 
      WHEN 26 
         LET l_sql = cl_replace_str(l_sql,"99","26") 
      WHEN 27 
         LET l_sql = cl_replace_str(l_sql,"99","27") 
      WHEN 28 
         LET l_sql = cl_replace_str(l_sql,"99","28") 
      WHEN 29 
         LET l_sql = cl_replace_str(l_sql,"99","29")   
      WHEN 30 
         LET l_sql = cl_replace_str(l_sql,"99","30") 
      WHEN 31 
         LET l_sql = cl_replace_str(l_sql,"99","31")       
   END CASE
   PREPARE q600_pre FROM l_sql 
   EXECUTE q600_pre USING l_bdate,l_edate,l_bdate,l_edate  
 
   LET lc_index = l_i USING '&&'
   LET ls_show = "amt" || lc_index ||"a,amt" || lc_index ||"b,amt" || lc_index ||"c,amt" || lc_index ||"d,amt" || lc_index ||"e"
   CALL cl_set_comp_visible(ls_show,TRUE)
END FUNCTION

FUNCTION q600_check()
DEFINE l_days   LIKE type_file.num5
DEFINE l_mms    LIKE type_file.num5
DEFINE l_yys    LIKE type_file.num5
DEFINE l_n1     LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_day1   LIKE type_file.num5
DEFINE l_day2   LIKE type_file.num5
DEFINE l_mm     LIKE type_file.num5
DEFINE l_ww1    LIKE type_file.num5
DEFINE l_ww2    LIKE type_file.num5
DEFINE l_bdate  LIKE type_file.dat
DEFINE l_edate  LIKE type_file.dat

   LET l_day1= DAY(tm.bdate)
   LET l_day2= DAY(tm.edate)
   LET l_ww1 = WEEKDAY(tm.bdate)
   LET l_ww2 = WEEKDAY(tm.edate)  
   LET l_bdate = tm.bdate + (7-l_ww1+1)
   LET l_edate = tm.edate - l_ww2 +1
   LET l_days = l_edate - l_bdate

   
   IF l_day1 >= 1 AND l_day1<=10 THEN 
      LET l_n1 = 3
   ELSE
      IF l_day1 > 10 AND l_day1<=20 THEN 
         LET l_n1 = 2 
      ELSE
         LET l_n1 = 1 
      END IF
   END IF   
   IF l_day2 >= 1 AND l_day2<=10 THEN 
      LET l_n2 = 1
   ELSE
      IF l_day2 > 10 AND l_day2<=20 THEN 
         LET l_n2 = 2 
      ELSE
         LET l_n2 = 3 
      END IF
   END IF    
   LET l_mm = (YEAR(tm.edate)*12 + MONTH(tm.edate)) - (YEAR(tm.bdate)*12 + MONTH(tm.bdate)) - 1

   LET l_mms  = (YEAR(tm.edate)*12 + MONTH(tm.edate)) - (YEAR(tm.bdate)*12 +MONTH(tm.bdate)) + 1
   LET l_yys  = YEAR(tm.edate) - YEAR(tm.bdate) + 1
   CASE tm.a
      WHEN '1'
         LET g_count = l_days / 7 + 2
      WHEN '2'
         IF l_mm = -1 THEN 
            IF l_day1 > 20 THEN 
               LET g_count = 1
            ELSE
               IF l_day1 >10 AND l_day1 <= 20 THEN
                  IF l_day2 > 20 THEN LET g_count = 1 ELSE LET g_count = 2 END IF
               ELSE
                  IF l_day2 <=10 THEN
                     LET g_count = 1 
                  ELSE
                     IF l_day2 >20 THEN LET g_count = 3 ELSE LET g_count=2 END IF
                  END IF   
               END IF    
            END IF    
         ELSE
            LET g_count = l_mm * 3 + l_n1 +l_n2
         END IF
      WHEN '3'
         LET g_count = l_mms
      WHEN '4' 
         LET g_count = l_yys     
   END CASE
   IF g_count < 32 THEN  RETURN 1 END IF
   RETURN 0
END FUNCTION
FUNCTION q600_set_visible()
   IF tm.b = '1' THEN 
      CALL cl_set_comp_visible("pmm09,pmc03",TRUE)
   ELSE
      CALL cl_set_comp_visible("pmm09,pmc03",FALSE)
   END IF
   IF tm.d = 'N' THEN 
      CALL cl_set_comp_visible("pmm22",TRUE)
   ELSE
      CALL cl_set_comp_visible("pmm22",FALSE)   
   END IF
   IF tm.e = 'N' THEN 
      CALL cl_set_comp_visible("pmn86",TRUE)
   ELSE
      CALL cl_set_comp_visible("pmn86",FALSE)   
   END IF   
END FUNCTION
FUNCTION q600_set_amt_visible()
   CALL cl_set_comp_visible("amt01a,amt01b,amt01c,amt01d,amt01e,
                             amt02a,amt02b,amt02c,amt02d,amt02e,
                             amt03a,amt03b,amt03c,amt03d,amt03e,
                             amt04a,amt04b,amt04c,amt04d,amt04e,
                             amt05a,amt05b,amt05c,amt05d,amt05e,
                             amt06a,amt06b,amt06c,amt06d,amt06e,
                             amt07a,amt07b,amt07c,amt07d,amt07e,
                             amt08a,amt08b,amt08c,amt08d,amt08e,
                             amt09a,amt09b,amt09c,amt09d,amt09e,
                             amt10a,amt10b,amt10c,amt10d,amt10e,
                             amt11a,amt11b,amt11c,amt11d,amt11e,
                             amt12a,amt12b,amt12c,amt12d,amt12e,
                             amt13a,amt13b,amt13c,amt13d,amt13e,
                             amt14a,amt14b,amt14c,amt14d,amt14e,
                             amt15a,amt15b,amt15c,amt15d,amt15e,
                             amt16a,amt16b,amt16c,amt16d,amt16e,
                             amt17a,amt17b,amt17c,amt17d,amt17e,
                             amt18a,amt18b,amt18c,amt18d,amt18e,
                             amt19a,amt19b,amt19c,amt19d,amt19e,
                             amt20a,amt20b,amt20c,amt20d,amt20e,
                             amt21a,amt21b,amt21c,amt21d,amt21e,
                             amt22a,amt22b,amt22c,amt22d,amt22e,
                             amt23a,amt23b,amt23c,amt23d,amt23e,
                             amt24a,amt24b,amt24c,amt24d,amt24e,
                             amt25a,amt25b,amt25c,amt25d,amt25e,
                             amt26a,amt26b,amt26c,amt26d,amt26e,
                             amt27a,amt27b,amt27c,amt27d,amt27e,
                             amt28a,amt28b,amt28c,amt28d,amt28e,
                             amt29a,amt29b,amt29c,amt29d,amt29e,
                             amt30a,amt30b,amt30c,amt30d,amt30e,
                             amt31a,amt31b,amt31c,amt31d,amt31e",FALSE)
END FUNCTION
#FUN-C90076
