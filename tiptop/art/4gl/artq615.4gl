# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artq615.4gl
# Descriptions...: 退款单查询
# Date & Author..: No:FUN-C60062 12/06/20 By Yangxf 

DATABASE ds                  

GLOBALS "../../config/top.global"

DEFINE g_azw01    LIKE azw_file.azw01
DEFINE g_lucplant STRING
DEFINE g_luc DYNAMIC ARRAY OF RECORD
               lucplant LIKE luc_file.lucplant,
               azp02    LIKE azp_file.azp02,
               luc03    LIKE luc_file.luc03,
               occ02    LIKE occ_file.occ02,
               luc05    LIKE luc_file.luc05,
               lmf13_1  LIKE lmf_file.lmf13,
               luc04    LIKE luc_file.luc04,
               luc10    LIKE luc_file.luc10,
               luc11    LIKE luc_file.luc11,
               luc01    LIKE luc_file.luc01,
               lud02    LIKE lud_file.lud02,
               lud05    LIKE lud_file.lud05,
               oaj02    LIKE oaj_file.oaj02,
               luc21    LIKE luc_file.luc21,
               luc25    LIKE luc_file.luc25,
               lud07t   LIKE lud_file.lud07t,
               luc08    LIKE luc_file.luc08
            END RECORD
DEFINE  g_sql           STRING,
        g_wc            STRING,      
        g_wc1           STRING,
        g_rec_b         LIKE type_file.num5, 
        l_ac            LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_chk_auth      STRING

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT 
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 4 LET p_col = 10
   OPEN WINDOW q615_w AT p_row,p_col WITH FORM "art/42f/artq615"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()   
   CALL cl_set_comp_visible("lud02",FALSE)
   CALL q615_q()
   CALL q615_menu()
   CLOSE WINDOW q615_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
  
FUNCTION q615_menu()
 
   WHILE TRUE
      CALL q615_bp("G")
      CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q615_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q615_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_luc),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
    
FUNCTION q615_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN          
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_luc TO s_luc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION output
        LET g_action_choice="output"
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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

      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION
 
FUNCTION q615_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CLEAR FORM
    CALL g_luc.clear()
    DIALOG ATTRIBUTE(unbuffered)
    CONSTRUCT BY NAME g_lucplant ON lucplant
       BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(lucplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azw01"
                 LET g_qryparam.where = " azw01 IN ",g_auth," "
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lucplant
                 NEXT FIELD lucplant
           END CASE 
    END CONSTRUCT
    CONSTRUCT BY NAME g_wc ON lmf03,lmf04,lie04,luc03,luc05,lmf13,lud05,luc27,luc26,luc21 
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init() 
           
        ON ACTION controlp
           CASE
              WHEN INFIELD(lmf03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmb02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmf03
                 NEXT FIELD lmf03
              WHEN INFIELD(lmf04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmc03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmf04
                 NEXT FIELD lmf04
              WHEN INFIELD(lie04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmy03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lie04
                 NEXT FIELD lie04   
              WHEN INFIELD(luc03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO luc03
                 NEXT FIELD luc03
              WHEN INFIELD(luc05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmf01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO luc05
                 NEXT FIELD luc05
              WHEN INFIELD(lud05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oaj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lud05
                 NEXT FIELD lud05
              WHEN INFIELD(luc27)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO luc27
                 NEXT FIELD luc27
              WHEN INFIELD(luc26)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO luc26
                 NEXT FIELD luc26   
                 
              OTHERWISE
                 EXIT CASE
           END CASE
    END CONSTRUCT
 
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
 
        ON ACTION about         
          CALL cl_about()      
 
        ON ACTION help         
          CALL cl_show_help()
 
        ON ACTION controlg   
          CALL cl_cmdask() 
 
        ON ACTION qbe_select                         	  
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)          
		
        ON ACTION close
           LET INT_FLAG=1
           EXIT DIALOG

        ON ACTION ACCEPT
           ACCEPT DIALOG
                  
        ON ACTION cancel
           LET INT_FLAG = 1
           EXIT DIALOG
    END DIALOG     
    IF INT_FLAG THEN
       RETURN
    END IF	      
    IF cl_null(g_wc) THEN
      LET g_wc=" 1=1"
    END IF
END FUNCTION
 
FUNCTION q615_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_luc.clear()
    MESSAGE ""
    CALL q615_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_luc.clear()
        RETURN
    END IF
    CALL q615_show()
END FUNCTION
 
FUNCTION q615_show()
   CALL q615_b_fill(g_wc)   
   CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION q615_b_fill(p_wc)              
DEFINE p_wc       STRING  
DEFINE l_table    STRING
DEFINE l_where    STRING      
DEFINE l_lmf13    LIKE lmf_file.lmf13
DEFINE l_oaj02    LIKE oaj_file.oaj02
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_occ02    LIKE occ_file.occ02
DEFINE l_n        LIKE type_file.num10
DEFINE l_string   STRING
DEFINE l_lucplant STRING
DEFINE tok        base.StringTokenizer
DEFINE l_sql      STRING
    CALL g_luc.clear()
    LET g_cnt = 1
    LET l_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file,luc_file ",
                "  WHERE azw01 = rtz01 AND rtz01 IN ",g_auth,
                "    AND lucplant = azw01",
                "    AND ", g_lucplant,
                "    AND azwacti = 'Y'",
                "  ORDER BY azw01 "
    PREPARE q615_pb_1 FROM l_sql
    DECLARE q615_bcl CURSOR FOR q615_pb_1
    FOREACH q615_bcl INTO g_azw01
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_sql = "SELECT DISTINCT lucplant,'',luc03,'',luc05,'',luc04,",
                   "       luc10,luc11,luc01,lud02,lud05,'',luc21,luc25,lud07t,luc08 "
       LET l_table = "  FROM ",cl_get_target_table(g_azw01,'luc_file'),",",
                               cl_get_target_table(g_azw01,'lud_file')
       LET l_where = " WHERE lud01 = luc01 AND luc14 = 'Y' AND lucplant = '",g_azw01,"'"
       IF p_wc.getIndexOf("lmf",1) THEN
          LET l_table = l_table,",",cl_get_target_table(g_azw01,'lmf_file')
          LET l_where = l_where," AND luc05 = lmf01 "
       END IF
       IF p_wc.getIndexOf("lie",1) THEN
          LET l_table = l_table,",",cl_get_target_table(g_azw01,'lie_file')
          LET l_where = l_where," AND lie01 = luc05 "
       END IF
       LET g_sql = g_sql,l_table,l_where," AND ",p_wc CLIPPED
       PREPARE q615_pb FROM g_sql
       DECLARE luc_cs CURSOR FOR q615_pb
       FOREACH luc_cs INTO g_luc[g_cnt].*  
           IF STATUS THEN 
              CALL cl_err('foreach:',STATUS,1) 
              EXIT FOREACH
           END IF
           LET g_sql = " SELECT rtz13 ",
                       "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),
                       "  WHERE rtz01 = '",g_luc[g_cnt].lucplant,"'"
           PREPARE azp_cs FROM g_sql
           EXECUTE azp_cs INTO l_rtz13
           LET g_sql = " SELECT occ02 ",
                       "   FROM ",cl_get_target_table(g_azw01,'occ_file'),
                       "  WHERE occ01 = '",g_luc[g_cnt].luc03,"'"
           PREPARE occ_cs FROM g_sql
           EXECUTE occ_cs INTO l_occ02
           LET g_sql = " SELECT lmf13 ",
                       "   FROM ",cl_get_target_table(g_azw01,'lmf_file'),
                       "  WHERE lmf01 = '",g_luc[g_cnt].luc05,"'"
           PREPARE lmf_cs FROM g_sql
           EXECUTE lmf_cs INTO l_lmf13
           LET g_sql = " SELECT oaj02 ",
                       "   FROM ",cl_get_target_table(g_azw01,'oaj_file'),
                       "  WHERE oaj01 = '",g_luc[g_cnt].lud05,"'"
           PREPARE oaj_cs FROM g_sql
           EXECUTE oaj_cs INTO l_oaj02
           LET g_luc[g_cnt].azp02 = l_rtz13
           LET g_luc[g_cnt].occ02 = l_occ02
           LET g_luc[g_cnt].lmf13_1 = l_lmf13
           LET g_luc[g_cnt].oaj02 = l_oaj02
           CALL cl_digcut(g_luc[g_cnt].lud07t,g_azi04) RETURNING g_luc[g_cnt].lud07t
           DISPLAY BY NAME g_luc[g_cnt].azp02,g_luc[g_cnt].occ02,
                           g_luc[g_cnt].lmf13_1,g_luc[g_cnt].oaj02
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
             EXIT FOREACH
           END IF 
       END FOREACH
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_luc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
    
FUNCTION q615_out()
   DEFINE l_cmd STRING 
   IF g_rec_b > 0 THEN
      CALL cl_wait()
      LET g_chk_auth =  cl_replace_str(g_lucplant,"'","\"")
      LET g_wc1 =  cl_replace_str(g_wc,"'","\"")
      LET l_cmd="artg615 '",g_chk_auth CLIPPED,"' '",g_wc1 CLIPPED,"' '",g_lang CLIPPED,"' '",g_today,"' '",g_prog,"'"
      CALL cl_cmdrun(l_cmd)
      ERROR ''
   END IF
END FUNCTION

#FUN-C60062     
      
    
