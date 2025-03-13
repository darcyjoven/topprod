# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: artq610.4gl
# Descriptions...: 费用欠款查询作業
# Date & Author..: No:FUN-C60062 12/06/19 By Yangxf 

DATABASE ds                  

GLOBALS "../../config/top.global"

DEFINE g_azw01     LIKE azw_file.azw01
DEFINE g_luaplant  STRING
DEFINE g_lua DYNAMIC ARRAY OF RECORD
               luaplant LIKE lua_file.luaplant,
               rtz13    LIKE rtz_file.rtz13,
               lua06    LIKE lua_file.lua06,
               lua061   LIKE lua_file.lua061,
               lua07    LIKE lua_file.lua07,
               lmf13_1  LIKE lmf_file.lmf13,
               lua01    LIKE lua_file.lua01,
               lub02    LIKE lub_file.lub02, 
               lub03    LIKE lub_file.lub03,
               oaj02    LIKE oaj_file.oaj02,
               lub04t   LIKE lub_file.lub04t,
               lub11    LIKE lub_file.lub11,
               amt_2    LIKE lub_file.lub11,
               lub12    LIKE lub_file.lub12
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
   OPEN WINDOW q610_w AT p_row,p_col WITH FORM "art/42f/artq610"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()   
   CALL cl_set_comp_visible("lub02",FALSE)
   CALL q610_q()
   CALL q610_menu()
   CLOSE WINDOW q610_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
  
FUNCTION q610_menu()
 
   WHILE TRUE
      CALL q610_bp("G")
      CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q610_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q610_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lua),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
    
FUNCTION q610_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN          
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_lua TO s_lua.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
 
FUNCTION q610_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CLEAR FORM
    CALL g_lua.clear()
    DIALOG ATTRIBUTE(unbuffered)
    CONSTRUCT BY NAME g_luaplant ON luaplant
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(luaplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azw01"
                 LET g_qryparam.where = " azw01 IN ",g_auth," "
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO luaplant
                 NEXT FIELD luaplant
            END CASE
    END CONSTRUCT
    CONSTRUCT BY NAME g_wc ON lmf03,lmf04,lie04,lua06,lua07,lmf13,lub03,lua34,lua39,lua38,lub10
             
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
              WHEN INFIELD(lua06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua06
                 NEXT FIELD lua06
              WHEN INFIELD(lua07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmf01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua07
                 NEXT FIELD lua07
              WHEN INFIELD(lub03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oaj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lub03
                 NEXT FIELD lub03
              WHEN INFIELD(lua39)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua39
                 NEXT FIELD lua39
              WHEN INFIELD(lua38)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua38
                 NEXT FIELD lua38   
                 
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
 
FUNCTION q610_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_lua.clear()
    MESSAGE ""
    CALL q610_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_lua.clear()
        RETURN
    END IF
    CALL q610_show()
END FUNCTION
 
FUNCTION q610_show()
   CALL q610_b_fill(g_wc)   
   CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION q610_b_fill(p_wc)              
DEFINE p_wc       STRING  
DEFINE l_table    STRING
DEFINE l_where    STRING      
DEFINE l_lmf13    LIKE lmf_file.lmf13
DEFINE l_oaj02    LIKE oaj_file.oaj02
DEFINE l_n        LIKE type_file.num10
DEFINE l_string   STRING
DEFINE l_luaplant STRING
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE tok        base.StringTokenizer
DEFINE l_sql      STRING

    CALL g_lua.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    LET l_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file,lua_file ",
                "  WHERE azw01 = rtz01 AND rtz01 IN ",g_auth,
                "    AND luaplant = azw01",
                "    AND ", g_luaplant,
                "    AND azwacti = 'Y'",
                "  ORDER BY azw01 "
    PREPARE sel_luaplant_pre FROM l_sql
    DECLARE sel_luaplant_cs CURSOR FOR sel_luaplant_pre
    FOREACH sel_luaplant_cs INTO g_azw01
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_sql = "SELECT DISTINCT luaplant,'',lua06,lua061,lua07,lmf13,lua01,",
                   "       lub02,lub03,'',lub04t,lub11,'',lub12 ",
                   "  FROM ",cl_get_target_table(g_azw01,'lua_file'),
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'lmf_file'),
                   "          ON lua07 = lmf01",
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'lie_file'),
                   "          ON lua07 = lie01",
                   " ,",cl_get_target_table(g_azw01,'lub_file'),
                   " WHERE luaplant = '",g_azw01,"' AND lua01 =lub01",
                   "  AND (lub04t-lub11-lub12 > 0) AND lua15 = 'Y'",
                   " AND ",p_wc CLIPPED," ORDER BY luaplant,lua06,lua07 "
       PREPARE q610_pb FROM g_sql
       DECLARE lua_cs CURSOR FOR q610_pb
       FOREACH lua_cs INTO g_lua[g_cnt].*  
           IF STATUS THEN 
              CALL cl_err('foreach:',STATUS,1) 
              EXIT FOREACH
           END IF
           LET g_sql = " SELECT rtz13 ",
                       "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),
                       "  WHERE rtz01 = '",g_lua[g_cnt].luaplant,"'"
           PREPARE rtz_cs FROM g_sql
           EXECUTE rtz_cs INTO l_rtz13
           LET g_sql = " SELECT oaj02 ",
                       "   FROM ",cl_get_target_table(g_azw01,'oaj_file'),
                       "  WHERE oaj01 = '",g_lua[g_cnt].lub03,"'"
           PREPARE oaj_cs FROM g_sql
           EXECUTE oaj_cs INTO l_oaj02
           IF cl_null(g_lua[g_cnt].lub11) THEN
              LET g_lua[g_cnt].lub11 = 0
           END IF 
           IF cl_null(g_lua[g_cnt].lub12) THEN
              LET g_lua[g_cnt].lub12 = 0
           END IF
           LET g_lua[g_cnt].amt_2 = g_lua[g_cnt].lub04t - g_lua[g_cnt].lub11 - g_lua[g_cnt].lub12
           CALL cl_digcut(g_lua[g_cnt].lub04t,g_azi04) RETURNING g_lua[g_cnt].lub04t
           CALL cl_digcut(g_lua[g_cnt].lub11,g_azi04) RETURNING g_lua[g_cnt].lub11
           CALL cl_digcut(g_lua[g_cnt].lub12,g_azi04) RETURNING g_lua[g_cnt].lub12
           CALL cl_digcut(g_lua[g_cnt].amt_2,g_azi04) RETURNING g_lua[g_cnt].amt_2
           LET g_lua[g_cnt].rtz13 = l_rtz13
           LET g_lua[g_cnt].oaj02 = l_oaj02
           DISPLAY BY NAME g_lua[g_cnt].rtz13,g_lua[g_cnt].lmf13_1,g_lua[g_cnt].oaj02,g_lua[g_cnt].amt_2 
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
    CALL g_lua.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
    
FUNCTION q610_out()
   DEFINE l_cmd   STRING
   IF g_rec_b > 0  THEN
      CALL cl_wait()
      LET g_chk_auth = cl_replace_str(g_luaplant,"'","\"")
      LET g_wc1 = cl_replace_str(g_wc,"'","\"")
      LET l_cmd= "artg610 '",g_chk_auth CLIPPED,"' '",g_wc1 CLIPPED,"' '",g_lang CLIPPED,"' '",g_today,"' 'Y' '1' '1' '156' 'NNN' 'NNN' 'artq610'"
      CALL cl_cmdrun(l_cmd) 
      ERROR ''
   END IF 
END FUNCTION

#FUN-C60062     
