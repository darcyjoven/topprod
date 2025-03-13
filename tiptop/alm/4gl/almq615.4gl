# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almq615.4gl
# Descriptions...: 積分兌換設定查詢作業
# Date & Author..: FUN-D10010 2013/01/04 By sakura

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rec_b         LIKE type_file.num5
DEFINE g_rec_b1        LIKE type_file.num5
DEFINE tm  RECORD
           wc      STRING,
           wc1     STRING
           END RECORD
DEFINE g_lpq           DYNAMIC ARRAY OF RECORD
           lpqplant    LIKE lpq_file.lpqplant,
           lpq01       LIKE lpq_file.lpq01,
           lpq14       LIKE lpq_file.lpq14,
           lpq03       LIKE lpq_file.lpq03,
           lph02       LIKE lph_file.lph02,
           lpq04       LIKE lpq_file.lpq04,
           lpq05       LIKE lpq_file.lpq05,
           lpr02       LIKE lpr_file.lpr02,
           lpr03       LIKE lpr_file.lpr03,
           ima02       LIKE ima_file.ima02,
           ima021      LIKE ima_file.ima021,
           lpr04       LIKE lpr_file.lpr04,
           gfe02       LIKE gfe_file.gfe02,
           lpr05       LIKE lpr_file.lpr05,
           lpq15       LIKE lpq_file.lpq15,
           lpqacti       LIKE lpq_file.lpqacti
                       END RECORD                    
DEFINE g_lst           DYNAMIC ARRAY OF RECORD
           lstplant    LIKE lst_file.lstplant, 
           lst01       LIKE lst_file.lst01,
           lst15       LIKE lst_file.lst15,
           lst03       LIKE lst_file.lst03,
           lph02_1     LIKE lph_file.lph02,           
           lst04       LIKE lst_file.lst04,
           lst05       LIKE lst_file.lst05,
           lss02       LIKE lss_file.lss02,
           lss04       LIKE lss_file.lss04,
           lss05       LIKE lss_file.lss05,
           lst16       LIKE lst_file.lst16,
           lstacti     LIKE lst_file.lstacti           
                       END RECORD                     
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_sql           STRING 
DEFINE l_ac            LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_cnt1          LIKE type_file.num10
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q615_w WITH FORM "alm/42f/almq615"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL q615_menu()
   CLOSE WINDOW q615_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q615_cs()
   CLEAR FORM
   CALL g_lpq.clear()
   CALL g_lst.clear()
   INITIALIZE tm.* TO NULL
     CONSTRUCT BY NAME tm.wc ON azw01
 
        ON ACTION controlp
           CASE
                 WHEN INFIELD(azw01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_azw"
                    LET g_qryparam.where = " azw01 IN ",g_auth
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO azw01
                    NEXT FIELD azw01
           END CASE
        
           ON ACTION locale
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()
        
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT 
        
           ON ACTION controlg
              CALL cl_cmdask()
        
           ON ACTION about
              CALL cl_about()
        
           ON ACTION exit
              EXIT CONSTRUCT 
        
           ON ACTION help
              CALL cl_show_help()
 
     END CONSTRUCT
     
     IF INT_FLAG THEN
        RETURN
     END IF
   
     CONSTRUCT BY NAME tm.wc1 ON lsl02,lph01,date_sta,date_end,Issued,Data_Valid_Code
 
        ON ACTION controlp
           CASE
                WHEN INFIELD(lsl02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form ="q_lsl02_1"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lsl02
                    NEXT FIELD lsl02
               WHEN INFIELD(lph01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lph01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lph01
                  NEXT FIELD lph01
              OTHERWISE EXIT CASE
           END CASE
        
           ON ACTION locale
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()
        
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT 
        
           ON ACTION controlg
              CALL cl_cmdask()
        
           ON ACTION about
             CALL cl_about()
        
          ON ACTION exit
             EXIT CONSTRUCT 
        
          ON ACTION help
             CALL cl_show_help()
 
     END CONSTRUCT 
     IF INT_FLAG THEN
        RETURN
     END IF
END FUNCTION
 
FUNCTION q615_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lpq.clear()
   DISPLAY ' ' TO FORMONLY.cn2
   CALL g_lst.clear()
   DISPLAY ' ' TO FORMONLY.cn3
   CALL q615_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FROM
      CALL g_lpq.clear()
      RETURN
   ELSE
      CALL q615_b_fill()
   END IF
END FUNCTION
 
FUNCTION q615_menu()
 DEFINE l_msg    LIKE type_file.chr1000
 DEFINE l_oma00  LIKE oma_file.oma00
 DEFINE l_oma01  LIKE oma_file.oma01
   WHILE TRUE 
      LET g_action_choice=''
      CALL q615_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q615_q()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpq),base.TypeInfo.create(g_lst),'')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q615_bp()
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
     DISPLAY ARRAY g_lpq TO s_lpq.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
           CALL cl_navigator_setting( g_curs_index, g_row_count )
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()
     END DISPLAY
     DISPLAY ARRAY g_lst TO s_lst.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
     END DISPLAY
    
        ON ACTION query
           LET g_action_choice="query"
           EXIT DIALOG 
     
        ON ACTION help
           LET g_action_choice="help"
           EXIT DIALOG 
     
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
     
        ON ACTION exit
           LET g_action_choice="exit"
           EXIT DIALOG 
     
        ON ACTION controlg
           LET g_action_choice="controlg"
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
       
        ON ACTION controls                                     
           CALL cl_set_head_visible("","AUTO")      
     
        ON ACTION related_document                
           LET g_action_choice="related_document"          
           EXIT DIALOG 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q615_b_fill()
DEFINE l_sql     STRING
DEFINE l_plant   LIKE  azp_file.azp01

   CALL g_lpq.clear()
   CALL g_lst.clear()
   LET l_sql = "SELECT DISTINCT azw01,azw08 FROM azw_file,rtz_file ",
              " WHERE azw01 = rtz01  ",
              " AND ", tm.wc,
              " AND azw01 IN ",g_auth,
              " ORDER BY azw01 "
   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
   LET g_cnt = 1
   LET g_cnt1 = 1
   FOREACH sel_azp01_cs INTO l_plant
      IF STATUS THEN
        CALL cl_err('PLANT:',SQLCA.sqlcode,1)
        RETURN
      END IF

      LET tm.wc1 = cl_replace_str(tm.wc1,"lsl02","lpq01")
      LET tm.wc1 = cl_replace_str(tm.wc1,"date_sta","lpq04")
      LET tm.wc1 = cl_replace_str(tm.wc1,"date_end","lpq05")
      LET tm.wc1 = cl_replace_str(tm.wc1,"issued","lpq15")
      LET tm.wc1 = cl_replace_str(tm.wc1,"data_valid_code","lpqacti")
      LET g_sql = " SELECT lpqplant,lpq01,lpq14,lpq03,lph02,lpq04,lpq05,lpr02,lpr03, ",
                  "        ima02,ima021,lpr04,gfe02,lpr05,lpq15,lpqacti ",
                  "   FROM ",cl_get_target_table(l_plant,'lpq_file'),
                  "     LEFT OUTER JOIN ",cl_get_target_table(l_plant,'lpr_file')," ON lpq00 = lpr00 AND lpq01 = lpr01 AND lpq03 = lpr09",
                  "     AND lpq13 = lpr08 AND lpqplant = lprplant",
                  "     LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ima_file')," ON lpr03 = ima01",
                  "     LEFT OUTER JOIN ",cl_get_target_table(l_plant,'lph_file')," ON lpq03 = lph01",
                  "     LEFT OUTER JOIN ",cl_get_target_table(l_plant,'gfe_file')," ON lpr04 = gfe01",
                  "  WHERE lpq00 = 0",
                  "    AND ", tm.wc1 CLIPPED
      LET g_sql = g_sql CLIPPED," ORDER BY lpqplant,lpq01,lpq14,lpq03,lpq04,lpr02,lpr03,lpr04,lpr05 "
      
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE q615_bp FROM g_sql
      DECLARE q615_cur CURSOR FOR q615_bp
      
      FOREACH q615_cur INTO g_lpq[g_cnt].*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
      
      LET tm.wc1 = cl_replace_str(tm.wc1,"lpq01","lst01")
      LET tm.wc1 = cl_replace_str(tm.wc1,"lpq04","lst04")
      LET tm.wc1 = cl_replace_str(tm.wc1,"lpq05","lst05")
      LET tm.wc1 = cl_replace_str(tm.wc1,"lpq15","lst16")
      LET tm.wc1 = cl_replace_str(tm.wc1,"lpqacti","lstacti")      
      LET g_sql = " SELECT lstplant,lst01,lst15,lst03,lph02,lst04,lst05,lss02,lss04,lss05,lst16,lstacti ",
                  "   FROM ",cl_get_target_table(l_plant,'lst_file'),
                  "   LEFT OUTER JOIN ",cl_get_target_table(l_plant,'lss_file')," ON lst00 = lss00 AND lst01 = lss01 AND lst03 = lss08 ",
                  "   AND lst14 = lss07 AND lstplant = lssplant",
                  "   LEFT OUTER JOIN ",cl_get_target_table(l_plant,'lph_file')," ON lst03 = lph01 ",
                  "  WHERE lst00 = 0 ",
                  "    AND ", tm.wc1 CLIPPED
      LET g_sql = g_sql CLIPPED," ORDER BY lstplant,lst01,lst15,lst03,lst04,lss02,lss04,lss05 "

      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE q615_bp1 FROM g_sql
      DECLARE q615_cur1 CURSOR FOR q615_bp1

      FOREACH q615_cur1 INTO g_lst[g_cnt1].*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_cnt1 = g_cnt1 + 1
         IF g_cnt1 > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH

   END FOREACH
      CALL g_lpq.deleteElement(g_cnt)
      IF g_cnt= 1 THEN CALL cl_err('','mfg3442',0) END IF
      LET g_rec_b = g_cnt - 1
      DISPLAY g_rec_b TO FORMONLY.cn2
      CALL g_lst.deleteElement(g_cnt1)
      IF g_cnt1= 1 THEN CALL cl_err('','mfg3442',0) END IF
      LET g_rec_b1 = g_cnt1 - 1
      DISPLAY g_rec_b1 TO FORMONLY.cn3
END FUNCTION
#FUN-D10010
