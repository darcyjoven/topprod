# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: almt7204.4gl
# Descriptions...: 特殊攤位設置維護作業
# Date & Author..: NO.FUN-870010 08/09/02 By lilingyu
# Modify.........: No.FUN-960134 09/07/20 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A20034 10/02/08 By shiwuying 生效範圍檔更改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60049 10/06/17 By houlia 特殊攤位開窗維護調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lqk      RECORD  LIKE lqk_file.*, 
       g_lqk_t    RECORD  LIKE lqk_file.*,
       g_lqk01_t          LIKE lqk_file.lqk01,
       g_lqk02_t          LIKE lqk_file.lqk02, 
       g_lqk03_t          LIKE lqk_file.lqk03,
       g_lql      RECORD  LIKE lql_file.*,
       g_lql_t    RECORD  LIKE lql_file.*,
       
       gg_head       DYNAMIC ARRAY OF RECORD
           lqk02          LIKE lqk_file.lqk02
                      END RECORD,
       gg_lqk         DYNAMIC ARRAY OF RECORD    
          lqk03           LIKE lqk_file.lqk03,
          lqk04           LIKE lqk_file.lqk04,
          lqk05           LIKE lqk_file.lqk05                   
                     END RECORD,
       gg_lqk_t       RECORD      
          lqk03           LIKE lqk_file.lqk03,
          lqk04           LIKE lqk_file.lqk04,
          lqk05           LIKE lqk_file.lqk05        
                     END RECORD,              
        gg_lql        DYNAMIC ARRAY OF RECORD         
          lql03           LIKE lql_file.lql03,
          lql04           LIKE lql_file.lql04,
          lql05           LIKE lql_file.lql05,
          lql06           LIKE lql_file.lql06         
                     END RECORD,  
       gg_lql_t       RECORD
          lql03           LIKE lql_file.lql03,
          lql04           LIKE lql_file.lql04,
          lql05           LIKE lql_file.lql05,
          lql06           LIKE lql_file.lql06    
                     END RECORD,                    
       g_sql              STRING,    
       gg_sql             STRING,
       g_wc               STRING,                       
       g_wc2              STRING,  
       g_wc3              STRING,                   
       g_rec_b             LIKE type_file.num5, 
       g_rec_b_1           LIKE type_file.num5,       
       l_ac                LIKE type_file.num5           
DEFINE g_forupd_sql        STRING             
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10   
DEFINE g_no_ask           LIKE type_file.num5  
DEFINE g_argv1             LIKE lqk_file.lqk01
DEFINE g_argv2             LIKE lqk_file.lqk06
 
MAIN
   DEFINE l_n              LIKE type_file.num5
   DEFINE  l_lqg07         LIKE lqg_file.lqg07
   DEFINE  l_lqgacti       LIKE lqg_file.lqgacti
 
   OPTIONS                               
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT            
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF 
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM lqk_file ",
                      " WHERE lqk01 = ? AND lqk02 = ? AND lqk03 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t7204_cl CURSOR FROM g_forupd_sql 
     
   OPEN WINDOW t7204_w WITH FORM "alm/42f/almt7204"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()  
   
   IF NOT cl_null(g_argv1) THEN  
       SELECT COUNT(*) INTO l_n FROM lqk_file
        WHERE lqk01 = g_argv1
          AND lqk06 = g_argv2
          AND lqk02 IS NOT NULL
          AND lqk03 IS NOT NULL 
        IF l_n < 1 THEN          
           SELECT lqg07,lqgacti INTO l_lqg07,l_lqgacti 
             FROM lqg_file
            WHERE lqg01 =  g_argv1
            IF l_lqg07 = 'Y' OR l_lqg07 = 'S' OR l_lqg07 = 'X' 
               OR l_lqgacti = 'N' THEN 
                CALL cl_err('','alm-441',1)
            ELSE              
               CALL t7204_a()
            END IF  
        ELSE    
           CALL t7204_q()
        END IF    
   END IF 
   
   CALL t7204_menu()
   CLOSE WINDOW t7204_w 
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t7204_curs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM    
      
    IF NOT cl_null(g_argv1) THEN 
      LET g_wc = " lqk01 = '",g_argv1,"'  and lqk06 = '",g_argv2,"'"
      DISPLAY BY NAME g_lqk.lqk01,g_lqk.lqk06
    ELSE
      CALL cl_set_head_visible("","YES")   
         DISPLAY BY NAME g_lqk.lqk01,g_lqk.lqk06
       CONSTRUCT BY NAME g_wc ON lqk02 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()     
 
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)      
      END CONSTRUCT
        
      IF INT_FLAG THEN
         RETURN
      END IF    
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                         
   #   LET g_wc = g_wc clipped," AND lmguser = '",g_user,"'"
   #       LET g_wc = g_wc CLIPPED
   #   END IF
 
   #   IF g_priv3='4' THEN                 
     # LET g_wc = g_wc clipped," AND lmggrup MATCHES '",g_grup CLIPPED,"*'"
   #      LET g_wc = g_wc CLIPPED
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    
    #  LET g_wc = g_wc clipped," AND lmggrup IN ",cl_chk_tgrup_list()
   #       LET g_wc = g_wc CLIPPED
   #   END IF
   LET g_wc =  g_wc CLIPPED,cl_get_extra_cond('user', 'grup')
   #End:FUN-980030
 
  
      CONSTRUCT g_wc2 ON lqk03,lqk04,lqk05
              FROM s_lqk[1].lqk03,s_lqk[1].lqk04,s_lqk[1].lqk05
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         ON ACTION CONTROLP
            CASE              
             WHEN INFIELD(lqk03) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqk3"      
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqk03
               NEXT FIELD lqk03
          
             OTHERWISE EXIT CASE  
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
    
        
         ON ACTION qbe_save
            CALL cl_qbe_save()         
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
         LET g_rec_b = 0
      END IF 
   
  CONSTRUCT g_wc3 ON lql03,lql04,lql05,lql06
              FROM s_lql[1].lql03,s_lql[1].lql04,s_lql[1].lql05,s_lql[1].lql06                
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)         
               
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about        
            CALL cl_about()      
    
         ON ACTION help          
            CALL cl_show_help() 
    
         ON ACTION controlg      
            CALL cl_cmdask()    
    
        
         ON ACTION qbe_save
            CALL cl_qbe_save()
         
      END CONSTRUCT
 END IF 
   
      IF INT_FLAG THEN
         RETURN
         LET g_rec_b_1 = 0
      END IF 
 
   IF NOT cl_null(g_argv1) THEN 
       LET g_wc2 = " 1=1"
       LET g_wc3 = " 1=1"
   ELSE      
      LET g_wc2 = g_wc2 CLIPPED
      LET g_wc3 = g_wc3 CLIPPED 
   END IF 
   
   IF g_wc2 = " 1=1"  AND g_wc3 = " 1=1" THEN
      LET g_sql = "SELECT lqk01,lqk02,lqk03 FROM lqk_file ",      
                  " WHERE ", g_wc CLIPPED, 
                  " and lqk01 = '",g_argv1,"'",
                  " and lqk06 = '",g_argv2,"'",      
                  " ORDER BY lqk02"
   ELSE     	
   	  IF cl_null(g_wc2) THEN 
   	     LET g_wc2 = " 1=1"
   	  END IF    
   	  IF g_wc3 = " 1=1" THEN     	     
   	      LET g_sql = "SELECT UNIQUE lqk01,lqk02,lqk03 ",
                      "  FROM lqk_file, lql_file ",
                      " WHERE lqk01 = lql01",
                      "   AND lqk02 = lql02",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED, 
                      "   AND lqk01 = '",g_argv1,"'",
                      "   AND lqk06 = '",g_argv2,"'",  
                      " ORDER BY lqk03"
   	  ELSE
   	      LET g_sql = "SELECT UNIQUE lqk01,lqk02,lqk03 ",
                      "  FROM lqk_file, lql_file ",
                      " WHERE lqk01 = lql01",
                      "   AND lqk02 = lql02",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED, 
                      "   AND ", g_wc2 CLIPPED,
                      "   AND lqk01 = '",g_argv1,"'",
                      "   AND lqk06 = '",g_argv2,"'",  
                      " ORDER BY lqk03"
   	 END IF    	   
   END IF
 
   PREPARE t7204_prepare FROM g_sql
   DECLARE t7204_cs SCROLL CURSOR WITH HOLD FOR t7204_prepare  #SCROLL CURSOR       
 
   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1"  THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lqk_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND lqk01 = '",g_argv1,"' and lqk06 = '",g_argv2,"' "      
   ELSE
   	  IF cl_null(g_wc2) THEN 
   	     LET g_wc2 = " 1=1"
   	  END IF    
   	  IF g_wc3 = " 1=1" THEN 
        LET g_sql="SELECT COUNT(DISTINCT lqk01) FROM lqk_file,lql_file WHERE ",
                  " lqk01=lql01 AND lqk02 = lql02 and ",g_wc CLIPPED,
                  " and ",g_wc2 CLIPPED,
                  " and lqk01 = '",g_argv1,"' and lqk06 = '",g_argv2,"' "  
      ELSE
        LET g_sql="SELECT COUNT(DISTINCT lqk01) FROM lqk_file,lql_file WHERE ",
                  " lqk01=lql01 AND lqk02 = lql02 and ",g_wc CLIPPED,
                  " and ",g_wc2 CLIPPED," and ",g_wc3 CLIPPED,
                  " and lqk01 = '",g_argv1,"' and lqk06 = '",g_argv2,"' "  
      END IF               
   END IF 
   PREPARE t7204_precount FROM g_sql
   DECLARE t7204_count CURSOR FOR t7204_precount   
END FUNCTION
 
FUNCTION t7204_menu()
DEFINE  l_lqg07    LIKE lqg_file.lqg07
DEFINE  l_lqgacti  LIKE lqg_file.lqgacti
 
 SELECT lqg07,lqgacti INTO l_lqg07,l_lqgacti 
   FROM lqg_file
  WHERE lqg01 =  g_argv1
 
   WHILE TRUE
      CALL t7204_bp("G")     
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
              IF cl_null(g_argv1) THEN 
                 CALL cl_err('','alm-445',1)
               ELSE   
                IF l_lqg07 = 'Y' OR l_lqg07 = 'S' OR l_lqg07 = 'X' 
                   OR l_lqgacti = 'N' THEN 
                   CALL cl_err('','alm-441',1)
                 ELSE
                 	 CALL t7204_a()
                 END IF 	 
               END IF   
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t7204_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN 
                 CALL cl_err('','alm-445',1) 
               ELSE                
                 IF l_lqg07 = 'Y' OR l_lqg07 = 'S' OR l_lqg07 = 'X' 
                    OR l_lqgacti = 'N' THEN 
                    CALL cl_err('','alm-441',1)
                  ELSE 
                    CALL t7204_r()
                 END IF   
              END IF  
            END IF
 
             
         WHEN "detail"
            IF cl_null(g_argv1) THEN 
               CALL cl_err('','alm-445',1) 
               LET g_action_choice = NULL 
             ELSE   
                IF cl_chk_act_auth() THEN          
                   IF l_lqg07 = 'Y' OR l_lqg07 = 'S' OR l_lqg07 = 'X' 
                      OR l_lqgacti = 'N' THEN 
                      CALL cl_err('','alm-441',1)
                      LET g_action_choice = NULL 
                    ELSE
                       CALL t7204_b('d')
                    END IF    
               ELSE
                    LET g_action_choice = NULL               
               END IF      
            END IF   
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"            
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(gg_lqk),'','')
            END IF 
           
         
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_lqk.lqk01 IS NOT NULL THEN
                 LET g_doc.column1 = "lqk01"
                 LET g_doc.value1 = g_lqk.lqk01
                 CALL cl_doc()
               END IF
         END IF      
        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t7204_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY gg_lqk TO s_lqk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) 
   
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL t7204_bp_1()
         IF g_action_choice = "query"  OR g_action_choice = "insert"
            OR g_action_choice = "delete" OR g_action_choice = "detail_1"
            OR g_action_choice = "detail" 
            OR g_action_choice = "exit" OR g_action_choice = "first"
            OR g_action_choice = "jump" OR g_action_choice = "last"
            OR g_action_choice = "next" OR g_action_choice = "previous"
         THEN
             EXIT DISPLAY             
         END IF    
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()    
         CALL cl_show_fld_cont()                  
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY 
 
    #  ON ACTION first
    #     CALL t7204_fetch('F')
    #     CALL cl_navigator_setting(g_curs_index, g_row_count)
    #     CALL fgl_set_arr_curr(1)
    #     ACCEPT DISPLAY  
    #
    #  ON ACTION previous
    #     CALL t7204_fetch('P')
    #     CALL cl_navigator_setting(g_curs_index, g_row_count)
    #     CALL fgl_set_arr_curr(1)
    #     ACCEPT DISPLAY 
    #
    #  ON ACTION jump
    #     CALL t7204_fetch('/')
    #     CALL cl_navigator_setting(g_curs_index, g_row_count)
    #     CALL fgl_set_arr_curr(1)
    #     ACCEPT DISPLAY   
    #
    #  ON ACTION next
    #     CALL t7204_fetch('N')
    #     CALL cl_navigator_setting(g_curs_index, g_row_count)
    #     CALL fgl_set_arr_curr(1)
    #     ACCEPT DISPLAY   
    #
    #  ON ACTION last
    #     CALL t7204_fetch('L')
    #     CALL cl_navigator_setting(g_curs_index, g_row_count)
    #     CALL fgl_set_arr_curr(1)
    #     ACCEPT DISPLAY  
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
     
      AFTER DISPLAY
         CONTINUE DISPLAY    
 
      ON ACTION related_document              
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
   END DISPLAY  
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF g_action_choice = "detail_1" THEN 
     CALL t7204_b_1('d')
   END IF   
END FUNCTION
 
FUNCTION t7204_bp_1()
 DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY gg_lql TO s_lql.* ATTRIBUTE(COUNT=g_rec_b_1,UNBUFFERED)
   
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )        
         DISPLAY ARRAY gg_lqk TO s_lqk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
            BEFORE DISPLAY
               CALL t7204_b_fill(" 1=1" ) 
               EXIT DISPLAY
            END DISPLAY         
                  
      BEFORE ROW
         LET l_ac = ARR_CURR()    
         CALL cl_show_fld_cont()                  
          DISPLAY ARRAY gg_lqk TO s_lqk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
          BEFORE DISPLAY
             EXIT DISPLAY
          END DISPLAY   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
     ON ACTION first
         CALL t7204_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION previous
         CALL t7204_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t7204_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t7204_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t7204_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY     
 
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()          
       
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail_1"
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
     
      AFTER DISPLAY
         CONTINUE DISPLAY    
 
      ON ACTION related_document              
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
   END DISPLAY  
   CALL cl_set_act_visible("accept,cancel", TRUE) 
END FUNCTION
 
FUNCTION t7204_bp_refresh()
  DISPLAY ARRAY gg_lqk TO s_lqk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
  DISPLAY ARRAY gg_lql TO s_lql.* ATTRIBUTE(COUNT=g_rec_b_1,UNBUFFERED )
    BEFORE DISPLAY
       EXIT DISPLAY
   ON Idle g_idle_seconds
       CALL cl_on_idle()
       CONTINUE DISPLAY
    END DISPLAY       
END FUNCTION
 
FUNCTION t7204_a()
   
   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'
   
   CALL gg_lqk.clear()
   CALL gg_lql.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lqk.* LIKE lqk_file.*         
   LET g_lqk01_t = NULL
   LET g_lqk02_t = NULL 
   LET g_lqk_t.* = g_lqk.*
   CALL cl_opmsg('a')
   
   WHILE TRUE  
      LET g_lqk.lqk01 = g_argv1
      LET g_lqk.lqk06 = g_argv2   
       
      CALL t7204_i("a")                 
      
      IF INT_FLAG THEN                  
         INITIALIZE g_lqk.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lqk.lqk01) THEN    
         CONTINUE WHILE
      END IF
      IF cl_null(g_lqk.lqk02) THEN
         CONTINUE WHILE
      END IF     
 
       CALL gg_lqk.clear()
       CALL gg_lql.clear()
       LET g_rec_b = 0  
       LET g_rec_b_1 = 0 
       
       CALL t7204_b('a')                 
       EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t7204_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1    
DEFINE    l_count     LIKE type_file.num5 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lqk.lqk01,g_lqk.lqk06   
  
     INPUT BY NAME g_lqk.lqk02 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t7204_set_entry(p_cmd)
         CALL t7204_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE       
 
      AFTER FIELD lqk02
       IF NOT cl_null(g_lqk.lqk02) THEN                                   
           IF g_lqk.lqk02 <= 0 THEN 
             CALL cl_err('','alm-444',1)
             NEXT FIELD lqk02 
          ELSE
          	 SELECT COUNT(*) INTO l_count FROM lqk_file
          	  WHERE lqk01 = g_argv1
          	    AND lqk02 = g_lqk.lqk02 
          	  IF l_count > 0 THEN 
          	     CALL cl_err('','alm-449',1)
          	     NEXT FIELD lqk02 
          	  END IF       
          END IF                                                                                                        
        ELSE                                                               
           CALL cl_err('','alm-062',1)                                                                                 
           NEXT FIELD lqk02                                   
        END IF                                                                            
                
 
   AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT  
        END IF  
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 
FUNCTION t7204_q()
 
   LET g_row_count  = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL gg_lqk.clear()
   CALL gg_lql.clear()
   LET g_lqk.lqk01 = g_argv1
   LET g_lqk.lqk06 = g_argv2
   
   DISPLAY ' ' TO FORMONLY.idx 
   DISPLAY ' ' TO FORMONLY.cnt 
   DISPLAY ' ' TO FORMONLY.cn2
   
   CALL t7204_curs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lqk.* TO NULL
      INITIALIZE g_lql.* TO NULL
      RETURN
   END IF
 
   OPEN t7204_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lqk.* TO NULL
      INITIALIZE g_lql.* TO NULL
   ELSE
      OPEN t7204_count
      FETCH t7204_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.idx      
 
      CALL t7204_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t7204_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t7204_cs INTO g_lqk.lqk01,g_lqk.lqk02,g_lqk.lqk03
      WHEN 'P' FETCH PREVIOUS t7204_cs INTO g_lqk.lqk01,g_lqk.lqk02,g_lqk.lqk03
      WHEN 'F' FETCH FIRST    t7204_cs INTO g_lqk.lqk01,g_lqk.lqk02,g_lqk.lqk03
      WHEN 'L' FETCH LAST     t7204_cs INTO g_lqk.lqk01,g_lqk.lqk02,g_lqk.lqk03
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
            FETCH ABSOLUTE g_jump t7204_cs INTO g_lqk.lqk01,
                                                g_lqk.lqk02,g_lqk.lqk03
            LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqk.lqk01,SQLCA.sqlcode,0)
      INITIALIZE g_lqk.* TO NULL              
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      #DISPLAY g_curs_index TO FORMONLY.idx 
  END IF
 
   SELECT * INTO g_lqk.* FROM lqk_file
    WHERE lqk01 = g_lqk.lqk01
      AND lqk02 = g_lqk.lqk02
      AND lqk03 = g_lqk.lqk03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lqk_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lqk.* TO NULL
      RETURN
   END IF
   
   CALL t7204_show()
 
END FUNCTION
 
FUNCTION t7204_show()
 
   LET g_lqk_t.* = g_lqk.*                             
   DISPLAY BY NAME g_lqk.lqk06,g_lqk.lqk01,g_lqk.lqk02
    
   CALL t7204_b_fill(g_wc2)                
   CALL t7204_b_fill_1(g_wc3)
   CALL cl_show_fld_cont()    
END FUNCTION
 
FUNCTION t7204_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF g_lqk.lqk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lqk.lqk02 IS NULL THEN 
      CALL cl_err("",-400,0)
      RETURN 
   END IF    
 
   SELECT * INTO g_lqk.* FROM lqk_file
    WHERE lqk01 = g_lqk.lqk01
      AND lqk02 = g_lqk.lqk02
    BEGIN WORK
 
   OPEN t7204_cl USING g_lqk.lqk01,g_lqk.lqk02,g_lqk.lqk03
   IF STATUS THEN
      CALL cl_err("OPEN t7204_cl:", STATUS, 1)
      CLOSE t7204_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t7204_cl INTO g_lqk.*              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqk.lqk01,SQLCA.sqlcode,0)    
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t7204_show()
 
   IF cl_delh(0,0) THEN                  
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lqk01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lqk.lqk01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                           #No.FUN-9B0098 10/02/24
      DELETE FROM lqk_file WHERE lqk01 = g_lqk.lqk01
                             AND lqk02 = g_lqk.lqk02                       
      DELETE FROM lql_file WHERE lql01 = g_lqk.lqk01
                             AND lql02 =g_lqk.lqk02                           
                          
      CLEAR FORM
      CALL gg_lqk.clear()
      CALL gg_lql.clear()
      OPEN t7204_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t7204_cs
         CLOSE t7204_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t7204_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t7204_cs
         CLOSE t7204_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.idx
      OPEN t7204_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t7204_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL t7204_fetch('/')
      END IF
   END IF
 
   CLOSE t7204_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqk.lqk01,'D')
END FUNCTION
 
FUNCTION t7204_b(p_cmd)
DEFINE   l_ac_t          LIKE type_file.num5              
DEFINE   l_n             LIKE type_file.num5                     
DEFINE   l_cnt           LIKE type_file.num5            
DEFINE   l_lock_sw       LIKE type_file.chr1             
DEFINE   p_cmd           LIKE type_file.chr1            
DEFINE   l_allow_insert  LIKE type_file.num5               
DEFINE   l_allow_delete  LIKE type_file.num5          
DEFINE   l_h             LIKE type_file.num5         #TQC-A60049   add 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF (g_lqk.lqk01 IS NULL) OR (g_lqk.lqk02 IS NULL) THEN
       RETURN
    END IF  
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT lqk03,lqk04,lqk05 from lqk_file", 
                       " WHERE lqk01 = '",g_argv1,"' ",
                       "   and lqk02 = '",g_lqk.lqk02,"' ",
                       "   and lqk03 = ?",
                       "   FOR UPDATE "
                       
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t7204_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_h = g_argv2 +3        #TQC-A60049   -add
 
    INPUT ARRAY gg_lqk WITHOUT DEFAULTS FROM s_lqk.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t7204_set_entry_b(p_cmd)
           CALL t7204_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t7204_bcl USING gg_lqk_t.lqk03 
           IF STATUS THEN
              CALL cl_err("OPEN t7204_bcl:", STATUS, 1)
              CLOSE t7204_bcl
              ROLLBACK WORK
              RETURN
           END IF
 
          #FETCH t7204_cl INTO g_lqk.*            # 鎖住將被更改或取消的資料
          #FETCH t7204_bcl INTO g_lqk.*          
          # IF SQLCA.sqlcode THEN
          #    CALL cl_err(g_lqk.lqk01,SQLCA.sqlcode,0)      # 資料被他人LOCK
          #    CLOSE t7204_cl
          #    ROLLBACK WORK
          #    RETURN
          # END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd = 'u'
              LET gg_lqk_t.* = gg_lqk[l_ac].*  #BACKUP
              OPEN t7204_bcl USING gg_lqk_t.lqk03 
              IF STATUS THEN
                 CALL cl_err("OPEN t7204_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t7204_bcl INTO gg_lqk[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(gg_lqk_t.lqk03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF   
              END IF
              CALL cl_show_fld_cont()    
              CALL t7204_set_entry_b(p_cmd)    
              CALL t7204_set_no_entry_b(p_cmd) 
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd = 'a'
           INITIALIZE gg_lqk[l_ac].* TO NULL      
           LET gg_lqk_t.* = gg_lqk[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()        
           
           LET g_before_input_done = FALSE
           CALL t7204_set_entry_b(p_cmd)   
           CALL t7204_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           NEXT FIELD lqk03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF          
           IF cl_null(gg_lqk[l_ac].lqk03) THEN
              CALL cl_err(gg_lqk[l_ac].lqk03,'alm-062',1)
              NEXT FIELD lqk03 
           END IF    
          
           INSERT INTO lqk_file(lqk06,lqk01,lqk02,lqk03,lqk04,lqk05)
                VALUES(g_argv2,g_argv1,g_lqk.lqk02,gg_lqk[l_ac].lqk03,
                       gg_lqk[l_ac].lqk04,gg_lqk[l_ac].lqk05)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lqk_file",g_argv1,gg_lqk[l_ac].lqk03,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
           	 MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b = g_rec_b + 1        
              DISPLAY g_rec_b TO FORMONLY.idx
           END IF      
   
        AFTER FIELD lqk03         
           IF NOT cl_null(gg_lqk[l_ac].lqk03) THEN   
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND gg_lqk[l_ac].lqk03 != gg_lqk_t.lqk03) THEN              
                 LET l_n = 0 
                #No.FUN-A20034 -BEGIN-----
                #SELECT COUNT(*) INTO l_n FROM lni_file
                # WHERE lni08 = gg_lqk[l_ac].lqk03
                #   AND lni01 = g_argv1
                #   AND lni02 = g_argv2
                #   AND lni13 = 'Y'
                #  #AND lni03 IN(SELECT MAX(lni03) FROM lni_file
                #  #              WHERE lni01 = g_argv1
                #  #                AND lni02 = g_argv2
                #  #                AND lni08 = gg_lqk[l_ac].lqk03)
                 SELECT COUNT(*) INTO l_n FROM lnk_file
                  WHERE lnk04 = gg_lqk[l_ac].lqk03
                    AND lnk01 = g_argv1
              #     ND lnk02 = g_argv2    #TQC-A60049 - mark
                    AND lnk02 = l_h  #TQC-A60049  -modify
                    AND lnk05 = 'Y'
                #No.FUN-A20034 -END-------
                 IF l_n < 1 THEN 
                    CALL cl_err('','alm-411',1)
                    NEXT FIELD lqk03
                 ELSE 
               	    LET l_n = 0 
               	    SELECT COUNT(*) INTO l_n FROM lqk_file
               	     WHERE lqk01 = g_argv1               	
               	       AND lqk03 = gg_lqk[l_ac].lqk03   
               	     IF l_n > 0 THEN   
               	        CALL cl_err('','alm-412',1)
               	        NEXT FIELD lqk03
               	     END IF 
                  END IF 
               END IF   
            END IF 
       
        BEFORE DELETE             
           DISPLAY "BEFORE DELETE"
           IF gg_lqk_t.lqk03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lqk_file
               WHERE lqk01 = g_argv1
                 AND lqk03 = gg_lqk_t.lqk03
                 AND lqk02 = g_lqk.lqk02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lqk_file",g_argv1,gg_lqk_t.lqk03,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b = g_rec_b - 1
              DISPLAY g_rec_b TO FORMONLY.idx
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET gg_lqk[l_ac].* = gg_lqk_t.*
              CLOSE t7204_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(gg_lqk[l_ac].lqk03,-263,1)
              LET gg_lqk[l_ac].* = gg_lqk_t.*
           ELSE             
              UPDATE lqk_file SET lqk04 = gg_lqk[l_ac].lqk04,
                                  lqk05 = gg_lqk[l_ac].lqk05                                    
               WHERE lqk01 = g_argv1
                 AND lqk03 = gg_lqk_t.lqk03
                 AND lqk02 = g_lqk.lqk02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lqk_file",g_argv1,gg_lqk_t.lqk03,SQLCA.sqlcode,"","",1)  
                 LET gg_lqk[l_ac].* = gg_lqk_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"    
           
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac       #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET gg_lqk[l_ac].* = gg_lqk_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL gg_lqk.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end-- 
              END IF
              CLOSE t7204_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
       
           LET l_ac_t = l_ac       #FUN-D30033 Add
           CLOSE t7204_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(lqk03) AND l_ac > 1 THEN
              LET gg_lqk[l_ac].* = gg_lqk[l_ac-1].*
              LET gg_lqk[l_ac].lqk03 = g_rec_b + 1
              NEXT FIELD lqk03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()       
 
        ON ACTION controlp
           CASE          
             WHEN INFIELD(lqk03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lqk03" 
               LET g_qryparam.default1 = gg_lqk[l_ac].lqk03
               LET g_qryparam.arg1 = g_argv1
        #      LET g_qryparam.arg2 = g_argv2       #TQC-A60049   -mark      
               LET g_qryparam.arg2 = l_h      #TQC-A60049   modify              
               CALL cl_create_qry() RETURNING gg_lqk[l_ac].lqk03
               DISPLAY BY NAME gg_lqk[l_ac].lqk03
               NEXT FIELD lqk03            
            
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                              
         CALL cl_set_head_visible("","AUTO")      
    END INPUT
 
  
    CLOSE t7204_bcl
    COMMIT WORK
    CALL t7204_delall()
END FUNCTION
 
FUNCTION t7204_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM lqk_file
    WHERE lqk01 = g_argv1 
      AND lqk02 = g_lqk.lqk02
      AND lqk03 IS NOT NULL 
      
   IF g_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lqk_file 
            WHERE lqk01 = g_argv1
              AND lqk02 = g_lqk.lqk02
      DELETE FROM lql_file
            WHERE lql01 = g_argv1
              AND lql02 = g_lqk.lqk02         
      MESSAGE "CANCEL ACTION"        
   ELSE
   	  CALL t7204_b_1('a')                   
   END IF
END FUNCTION 
 
FUNCTION t7204_delall_1()
   
   LET g_cnt = 0 
   
   SELECT COUNT(*) INTO g_cnt FROM lql_file
    WHERE lql01 = g_argv1
      AND lql02 = g_lqk.lqk02
      AND lql03 IS NOT NULL
   
   IF g_cnt = 0 THEN 
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lql_file
            WHERE lql01 = g_argv1
              AND lql02 = g_lqk.lqk02
      DELETE FROM lqk_file
            WHERE lqk01 = g_argv1
              AND lqk02 = g_lqk.lqk02 
      MESSAGE "CANCEL ACTION"                
   END IF   
END FUNCTION
 
FUNCTION t7204_b_1(p_cmd)
DEFINE   l_ac_t          LIKE type_file.num5                #未取消的ARRAY CNT  
DEFINE   l_n             LIKE type_file.num5                #檢查重複用             
DEFINE   l_cnt           LIKE type_file.num5                #檢查重複用 
DEFINE   l_lock_sw       LIKE type_file.chr1                #單身鎖住否  
DEFINE   p_cmd           LIKE type_file.chr1                #處理狀態                  
DEFINE   l_allow_insert  LIKE type_file.num5               
DEFINE   l_allow_delete  LIKE type_file.num5            
DEFINE   l_lql03         LIKE type_file.num10
  
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT lql03,lql04,lql05,lql06 from lql_file", 
                       "  WHERE lql01 = '",g_argv1,"' ",
                       "    and lql02 = '",g_lqk.lqk02,"' ",
                       "    and lql03 = ?",
                       "    FOR UPDATE "
                       
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t7204_1_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY gg_lql WITHOUT DEFAULTS FROM s_lql.*
          ATTRIBUTE(COUNT=g_rec_b_1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t7204_set_entry_b_1(p_cmd)
           CALL t7204_set_no_entry_b_1(p_cmd)
           LET g_before_input_done = TRUE
           
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b_1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW          
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t7204_1_bcl USING gg_lql_t.lql03
           IF STATUS THEN
              CALL cl_err("OPEN t7204_1_bcl:", STATUS, 1)
              CLOSE t7204_1_bcl
              ROLLBACK WORK
              RETURN
           END IF
 
         #  FETCH t7204_1_bcl INTO gg_lql[l_ac].*            # 鎖住將被更改或取消的資料
         #  IF SQLCA.sqlcode THEN
         #     CALL cl_err(g_lqk.lqk01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         #     CLOSE t7204_1_bcl
         #     ROLLBACK WORK
         #     RETURN
         #  END IF
 
           IF g_rec_b_1 >= l_ac THEN
              LET p_cmd='u'           
              LET gg_lql_t.* = gg_lql[l_ac].*  #BACKUP
              OPEN t7204_1_bcl USING gg_lql_t.lql03 
              IF STATUS THEN
                 CALL cl_err("OPEN t7204_1_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t7204_1_bcl INTO gg_lql[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(gg_lql_t.lql03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF   
              END IF
              CALL cl_show_fld_cont()    
              CALL t7204_set_entry_b_1(p_cmd)    
              CALL t7204_set_no_entry_b_1(p_cmd) 
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE gg_lql[l_ac].* TO NULL      
           LET gg_lql_t.* = gg_lql[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()   
           
           LET g_before_input_done = FALSE     
           CALL t7204_set_entry_b_1(p_cmd)   
           CALL t7204_set_no_entry_b_1(p_cmd)
           LET g_before_input_done = TRUE
           NEXT FIELD lql03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF          
           IF cl_null(gg_lql[l_ac].lql03) THEN
              CALL cl_err(gg_lql[l_ac].lql03,'alm-062',1)
              NEXT FIELD lql03 
           END IF   
       
           INSERT INTO lql_file(lql00,lql01,lql02,lql03,lql04,lql05,lql06)
                VALUES(g_argv2,g_argv1,g_lqk.lqk02,gg_lql[l_ac].lql03,
                       gg_lql[l_ac].lql04,gg_lql[l_ac].lql05,gg_lql[l_ac].lql06)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lql_file",g_argv1,gg_lql[l_ac].lql03,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b_1 = g_rec_b_1 + 1
             DISPLAY g_rec_b_1 TO FORMONLY.cn2              
           END IF   
 
      BEFORE FIELD lql03 
        IF cl_null(gg_lql[l_ac].lql03) OR cl_null(gg_lql_t.lql03) THEN    
            SELECT max(lql03)+1 INTO gg_lql[l_ac].lql03 FROM lql_file      
             WHERE lql01 = g_argv1
               AND lql02 =g_lqk.lqk02             
           IF cl_null(gg_lql[l_ac].lql03) OR gg_lql[l_ac].lql03 <= 0 THEN 
              LET gg_lql[l_ac].lql03 = 1 
           END IF      
        END IF   
        
        AFTER FIELD lql03         
           IF NOT cl_null(gg_lql[l_ac].lql03) THEN
              IF p_cmd = 'a' OR 
                 (p_cmd = 'u' AND gg_lql[l_ac].lql03 != gg_lql_t.lql03) THEN
                 LET l_n = 0  
                 SELECT COUNT(*) INTO l_n FROM lql_file
                    WHERE lql03 = gg_lql[l_ac].lql03 
                      AND lql01 = g_argv1
                      AND lql02 = g_lqk.lqk02                        
                  IF l_n>0 THEN 
                     CALL cl_err('','-239',1)
                     LET gg_lql[l_ac].lql03 = gg_lql_t.lql03
                     NEXT FIELD lql03
                  END IF 
               END IF   
            END IF                  
           
        AFTER FIELD lql04
           IF NOT cl_null(gg_lql[l_ac].lql04) THEN
             IF gg_lql[l_ac].lql04 < 0 THEN 
                CALL cl_err('','alm-258',1)
                NEXT FIELD lql04 
             END IF 
             IF gg_lql[l_ac].lql04 > gg_lql[l_ac].lql05 THEN 
                CALL cl_err('','alm-259',1)
                NEXT FIELD lql04 
             END IF 
          END IF   
          IF p_cmd = 'a' OR 
            (p_cmd = 'u' AND gg_lql[l_ac].lql04 != gg_lql_t.lql04) THEN 
            LET l_n = 0 
            SELECT COUNT(*) INTO l_n FROM lql_file
            WHERE lql01 = g_argv1
              AND lql02 = g_lqk.lqk02 
              AND lql03 != gg_lql[l_ac].lql03
              AND ((gg_lql[l_ac].lql04 >= lql04 AND gg_lql[l_ac].lql04 <= lql05)
                   OR (gg_lql[l_ac].lql04 <= lql04 AND gg_lql[l_ac].lql05 >= lql05)
                   OR (gg_lql[l_ac].lql04 <= lql04 AND gg_lql[l_ac].lql05 >= lql04))           
             IF l_n > 0 THEN
                CALL cl_err('','alm-401',1)
                NEXT FIELD lql04 
             END IF   
          END IF   
          
        AFTER FIELD lql05
           IF NOT cl_null(gg_lql[l_ac].lql05) THEN
             IF gg_lql[l_ac].lql05 < 0 THEN 
                CALL cl_err('','alm-258',1)
                NEXT FIELD lql05 
             END IF 
             IF gg_lql[l_ac].lql05 < gg_lql[l_ac].lql04 THEN 
                CALL cl_err('','alm-400',1)
                NEXT FIELD lql05 
             END IF 
          END IF       
           IF p_cmd = 'a' OR 
             (p_cmd = 'u' AND gg_lql[l_ac].lql05 != gg_lql_t.lql05) THEN
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lql_file
              WHERE lql01 = g_argv1
                AND lql02 = g_lqk.lqk02
                AND lql03 != gg_lql[l_ac].lql03
                AND ((gg_lql[l_ac].lql05 >= lql04 AND gg_lql[l_ac].lql05 <= lql05)
                     OR (gg_lql[l_ac].lql04 <= lql04 AND gg_lql[l_ac].lql05 >= lql05)
                     OR (gg_lql[l_ac].lql04 <= lql04 AND gg_lql[l_ac].lql05 >= lql04))                 
            IF l_n > 0 THEN
               CALL cl_err('','alm-401',1)
               NEXT FIELD lql05 
            END IF   
          END IF   
          
        AFTER FIELD lql06 
           IF NOT cl_null(gg_lql[l_ac].lql06) THEN 
              IF gg_lql[l_ac].lql06 <0 THEN 
                 CALL cl_err('','alm-257',1)
                 NEXT FIELD lql06
              END IF 
              IF gg_lql[l_ac].lql06 > 100 THEN 
                 CALL cl_err('','alm-257',1)
                 NEXT FIELD lql06
              END IF        
          END IF    
       
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF gg_lql_t.lql03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lql_file
               WHERE lql01 = g_argv1
                 AND lql03 = gg_lql_t.lql03
                 AND lql02 = g_lqk.lqk02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lql_file",g_argv1,gg_lql_t.lql03,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b_1 = g_rec_b_1 - 1
              DISPLAY g_rec_b_1 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET gg_lql[l_ac].* = gg_lql_t.*
              CLOSE t7204_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(gg_lql[l_ac].lql03,-263,1)
              LET gg_lql[l_ac].* = gg_lql_t.*
           ELSE             
              UPDATE lql_file SET lql04 = gg_lql[l_ac].lql04,
                                  lql05 = gg_lql[l_ac].lql05,
                                  lql06 = gg_lql[l_ac].lql06                                    
               WHERE lql01 = g_argv1
                 AND lql03 = gg_lql_t.lql03
                 AND lql02 = g_lqk.lqk02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lql_file",g_argv1,gg_lql_t.lql03,SQLCA.sqlcode,"","",1)  
                 LET gg_lql[l_ac].* = gg_lql_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"     
           
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET gg_lql[l_ac].* = gg_lql_t.*
              END IF
              CLOSE t7204_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
       
           CLOSE t7204_1_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(lql03) AND l_ac > 1 THEN
              LET gg_lql[l_ac].* = gg_lql[l_ac-1].*
              LET gg_lql[l_ac].lql03 = g_rec_b_1 + 1
              NEXT FIELD lql03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()     
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                              
         CALL cl_set_head_visible("","AUTO")      
    END INPUT
 
  
    CLOSE t7204_1_bcl
    COMMIT WORK
    CALL t7204_delall_1()
END FUNCTION
 
FUNCTION t7204_b_fill(p_wc2)
DEFINE  p_wc2   STRING
DEFINE  i        LIKE type_file.num5
 
    LET g_sql = "SELECT lqk03,lqk04,lqk05 from lqk_file",
                " WHERE lqk01 ='",g_argv1,"' ",          
                "   and lqk06 = '",g_argv2,"'" ,
                "   and lqk02 = '",g_lqk.lqk02,"'"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED ," ORDER BY lqk03 "
  
   DISPLAY g_sql
 
   PREPARE t7204_pb FROM g_sql
   DECLARE lqk_cs CURSOR FOR t7204_pb
 
   CALL gg_lqk.clear()
   LET g_cnt = 1
 
   FOREACH lqk_cs INTO gg_lqk[g_cnt].*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF     
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
  
   CALL gg_lqk.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt 
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t7204_b_fill_1(p_wc3)
DEFINE  p_wc3   STRING
DEFINE  i       LIKE type_file.num5
 
    LET g_sql = "SELECT lql03,lql04,lql05,lql06 from lql_file",
                "  WHERE lql01 ='",g_argv1,"' ",
                "    AND lql00 = '",g_argv2,"'",
                "    and lql02 = '",g_lqk.lqk02,"'"
 
   IF NOT cl_null(p_wc3) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY lql03 "
  
   DISPLAY g_sql
 
   PREPARE t7204_pb_1 FROM g_sql
   DECLARE lql_cs CURSOR FOR t7204_pb_1
 
   CALL gg_lql.clear()
   LET g_cnt = 1
 
   FOREACH lql_cs INTO gg_lql[g_cnt].*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL gg_lql.deleteElement(g_cnt)
 
   LET g_rec_b_1 = g_cnt - 1
   DISPLAY g_rec_b_1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t7204_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lqk06,lqk01",FALSE)
      CALL cl_set_comp_entry("lqk02",TRUE)
    END IF
END FUNCTION
 
FUNCTION t7204_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lqk06,lqk01,lqk02",FALSE)
    END IF
END FUNCTION
 
FUNCTION t7204_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                                    
        CALL cl_set_comp_entry("lqk03",TRUE)                                              
     END IF 
END FUNCTION
 
FUNCTION t7204_set_entry_b_1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                              
        CALL cl_set_comp_entry("lql03",TRUE)                                                
     END IF
END FUNCTION
 
FUNCTION t7204_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN                 
       CALL cl_set_comp_entry("lqk03",FALSE)                                                
    END IF  
END FUNCTION
 
FUNCTION t7204_set_no_entry_b_1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN                        
       CALL cl_set_comp_entry("lql03",FALSE)                                             
    END IF  
END FUNCTION
#No.FUN-960134                                                                                 
 
