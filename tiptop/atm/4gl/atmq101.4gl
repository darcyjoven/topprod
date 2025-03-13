# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmq101.4gl
# Descriptions...: 出貨單已派車狀況查詢
# Date & Author..: 06/05/17 By Tracy 
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm     RECORD
               wc  	LIKE type_file.chr1000          #No.FUN-680120 VARCHAR(500)
           END RECORD,
    g_ogb  RECORD
               ogb01    LIKE ogb_file.ogb01,
               ogb03    LIKE ogb_file.ogb03,
               oga02	LIKE oga_file.oga02,
               oga04 	LIKE oga_file.oga04,
               occ02    LIKE occ_file.occ02,
               oga044	LIKE oga_file.oga044,
               ogb04    LIKE ogb_file.ogb04,
               ogb06    LIKE ogb_file.ogb06,
               ogb05    LIKE ogb_file.ogb05,
               ogb12    LIKE ogb_file.ogb12,
               ogb910   LIKE ogb_file.ogb910,
               ogb912   LIKE ogb_file.ogb912,
               ogb913   LIKE ogb_file.ogb913,
               ogb915   LIKE ogb_file.ogb915
           END RECORD,
    g_adl  DYNAMIC ARRAY OF RECORD
               r        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
               adl01    LIKE adl_file.adl01,
               adl02    LIKE adl_file.adl02,
               adk08    LIKE adk_file.adk08,
               adk04    LIKE adk_file.adk04,
               adk05    LIKE adk_file.adk05,
               adl07    LIKE adl_file.adl07,
               adl08    LIKE adl_file.adl08,
               adl20    LIKE adl_file.adl20,
               adl05    LIKE adl_file.adl05,
               adl15    LIKE adl_file.adl15,
               adl17    LIKE adl_file.adl17,
               adl12    LIKE adl_file.adl12,
               adl14    LIKE adl_file.adl14
           END RECORD,
    g_sql            string, 
    g_wc2            string,  
    g_rec_b          LIKE type_file.num5          #No.FUN-680120 SMALLINT
#   g_adl05_t        LIKE adl_file.adl05   
 
DEFINE  g_cnt        LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE  g_msg        LIKE type_file.chr1000,      #No.FUN-680120 VARCHAR(72)
        l_ac         LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE  g_row_count  LIKE type_file.num10         #No.FUN-680120 INTEGER
 
DEFINE  g_curs_index LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE  g_jump       LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE  mi_no_ask    LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6B0014
DEFINE         p_row,p_col	LIKE type_file.num5          #No.FUN-680120 SMALLINT #No.FUN-6B0014
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW atmq101_w AT p_row,p_col
        WITH FORM "atm/42f/atmq101"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL q101_def_form()         
 
   CALL q101_menu()   
 
   CLOSE WINDOW atmq101_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION q101_cs()
    DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01 
    DEFINE  l_cnt           LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    CALL g_adl.clear()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL
    CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   INITIALIZE g_ogb.* TO NULL    #No.FUN-750051
    CONSTRUCT  BY NAME tm.wc ON ogb01,ogb03,oga02,oga04,oga044,ogb04,ogb06,
                                ogb05,ogb12,ogb910,ogb912,ogb913,ogb915
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()                   
 
      ON ACTION CONTROLP                                                                                                              
         CASE                                                                                                                         
         WHEN INFIELD(ogb01)                                                                                                          
              CALL cl_init_qry_var()                                                                                                  
              LET g_qryparam.form  ="q_oga"                                                                                         
              LET g_qryparam.state ="c"                                                                                               
              CALL cl_create_qry()                                                                                                    
              RETURNING g_qryparam.multiret                                                                                           
              DISPLAY g_qryparam.multiret TO ogb01                                                                                    
              NEXT FIELD ogb01                                        
 
         WHEN INFIELD(oga04)                                                                                                   
              CALL cl_init_qry_var()                                                                                              
              LET g_qryparam.form = "q_occ"                                                                                       
              LET g_qryparam.state = 'c'                                                                                          
              CALL cl_create_qry() 
              RETURNING g_qryparam.multiret                                                                  
              DISPLAY g_qryparam.multiret TO oga04                                                                                
              NEXT FIELD oga04                                                                                                    
 
         WHEN INFIELD(oga044)                                                                                                 
              CALL cl_init_qry_var()                                                                                          
              LET g_qryparam.form ="q_ocd"                                                                                    
              LET g_qryparam.state = 'c'                                                                                          
              CALL cl_create_qry() 
              RETURNING g_qryparam.multiret                                                                  
              DISPLAY g_qryparam.multiret TO oga044                                                                               
              NEXT FIELD oga044  
                                            
         WHEN INFIELD(ogb04)                                                                                                   
              CALL cl_init_qry_var()                                                                                              
              LET g_qryparam.form = "q_ima"                                                                                       
              LET g_qryparam.state = 'c'                                                                                          
              CALL cl_create_qry() 
              RETURNING g_qryparam.multiret                                                                  
              DISPLAY g_qryparam.multiret TO ogb04                                                                                
              NEXT FIELD ogb04                       
 
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
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #       LET tm.wc = tm.wc CLIPPED," AND ogauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #       LET tm.wc = tm.wc CLIPPED," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    
    #       LET tm.wc = tm.wc CLIPPED," AND ogbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
    #End:FUN-980030
 
    CONSTRUCT g_wc2 ON adl01,adk08,adk04,adk05,adl07,adl08,adl20,adl15,adl17,
                       adl12,adl14
         FROM s_sr[1].adl01,s_sr[1].adk08,s_sr[1].adk04,
              s_sr[1].adk05,s_sr[1].adl07,s_sr[1].adl08,
              s_sr[1].adl20,s_sr[1].adl15,s_sr[1].adl17,
              s_sr[1].adl12,s_sr[1].adl14
 
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
      ON ACTION CONTROLP                                                                                                              
         CASE                                                                                                                         
         WHEN INFIELD(adl01)                                                                                                 
              CALL cl_init_qry_var()                                                                                          
              LET g_qryparam.form ="q_adk01"                                                                                  
              LET g_qryparam.state = "c"                                                                                      
              CALL cl_create_qry() 
              RETURNING g_qryparam.multiret                                                              
              DISPLAY g_qryparam.multiret TO adl01                                                                            
              NEXT FIELD adl01                 
 
         WHEN INFIELD(adk08)
              CALL q_obw(FALSE,TRUE,'','','',
                         '','') 
              RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO adk08
              NEXT FIELD adk08
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
 
    MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
 
    IF g_wc2 = ' 1=1' THEN                                                                                                          
       LET g_sql = " SELECT UNIQUE ogb01,ogb03 ",
                   "   FROM ogb_file,oga_file",
                   "  WHERE ",tm.wc CLIPPED,
                   "    AND oga01 = ogb01 ",                                                                                        
                   "  ORDER BY ogb01,ogb03 "
    ELSE                                                                                                                            
       LET g_sql = " SELECT UNIQUE ogb01,ogb03 ",
                   "   FROM ogb_file,oga_file,adl_file,adk_file",
                   "  WHERE ",tm.wc CLIPPED,
                   "    AND ",g_wc2 CLIPPED,       
                   "    AND oga01 = ogb01 ",                                                                                        
                   "    AND adl01 = adk01 ",                                                                                        
                   "    AND ogb01 = adl03 ",          
                   "    AND ogb03 = adl04 ",          
                   "    AND adkconf = 'Y'",        
                   "  ORDER BY ogb01,ogb03 "
    END IF                                                                                                                          
    PREPARE q101_prepare FROM g_sql                                                                                                 
    DECLARE q101_cs                                                                                                                 
       SCROLL CURSOR FOR q101_prepare                                                                                              
                                                                                                                                    
    IF g_wc2 = ' 1=1' THEN                                                                                                          
       LET g_sql = " SELECT COUNT(*) FROM ogb_file,oga_file",                                                                           
                   "  WHERE ",tm.wc CLIPPED,                                                                                             
                   "    AND oga01 = ogb01 "                                                                                        
    ELSE                                                                                                                            
       LET g_sql = " SELECT COUNT(*) ",
                   "   FROM ogb_file,oga_file,adl_file,adk_file",
                   "  WHERE ",tm.wc CLIPPED,
                   "    AND ",g_wc2 CLIPPED,       
                   "    AND oga01 = ogb01 ",                                                                                        
                   "    AND adl01 = adk01 ",                                                                                        
                   "    AND ogb01 = adl03 ",          
                   "    AND ogb03 = adl04 ",          
                   "    AND adkconf = 'Y'",        
                   "  ORDER BY ogb01,ogb03 "
    END IF                                        
{
    DROP  TABLE x      
    PREPARE q101_precount_x FROM g_sql                                                                                              
    EXECUTE q101_precount_x                                                                                                         
    LET g_sql = "SELECT COUNT(*) FROM x"                                                                                         
}
    PREPARE q101_pp  FROM g_sql                                                                                                     
    DECLARE q101_cnt  CURSOR FOR q101_pp                                                                                            
    OPEN q101_cnt                                                                                                                    
    FETCH q101_cnt INTO g_row_count                                                                                                  
    CLOSE q101_cnt                       
 
END FUNCTION
 
#中文的MENU
FUNCTION q101_menu()
   WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q101_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION q101_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q101_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN q101_cnt
    FETCH q101_cnt INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN q101_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q101_fetch('F')
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10         #No.FUN-680120 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q101_cs INTO g_ogb.ogb01,g_ogb.ogb03
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_ogb.ogb01,g_ogb.ogb03
        WHEN 'F' FETCH FIRST    q101_cs INTO g_ogb.ogb01,g_ogb.ogb03
        WHEN 'L' FETCH LAST     q101_cs INTO g_ogb.ogb01,g_ogb.ogb03
        WHEN '/'
            IF (NOT mi_no_ask) THEN    #No.FUN-6A0072
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about        
                  CALL cl_about()    
 
               ON ACTION help       
                  CALL cl_show_help() 
 
               ON ACTION controlg    
                  CALL cl_cmdask()  
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
 
            FETCH ABSOLUTE g_jump q101_cs INTO 
                                               g_ogb.ogb01,g_ogb.ogb03
            LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ogb.ogb01,SQLCA.sqlcode,0)
        INITIALIZE g_ogb.* TO NULL  #TQC-6B0105
        RETURN
    END IF
    SELECT ogb01,ogb03,oga02,oga04,oga044,ogb04,ogb06,ogb05,ogb12,ogb910,
           ogb912,ogb913,ogb915
      INTO g_ogb.ogb01,g_ogb.ogb03,g_ogb.oga02,g_ogb.oga04,g_ogb.oga044,
           g_ogb.ogb04,g_ogb.ogb06,g_ogb.ogb05,g_ogb.ogb12,g_ogb.ogb910,
           g_ogb.ogb912,g_ogb.ogb913,g_ogb.ogb915 
      FROM ogb_file,oga_file
        WHERE ogb01 = oga01
	  AND ogb01 = g_ogb.ogb01 AND ogb03 = g_ogb.ogb03
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ogb.ogb01,SQLCA.sqlcode,0)  #No.FUN-660104 MARK
       CALL cl_err3("sel","oga_file,ogb_file",g_ogb.ogb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660104
       RETURN
    END IF
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL q101_show()
END FUNCTION
 
FUNCTION q101_show()
    SELECT occ02 INTO g_ogb.occ02 FROM occ_file WHERE occ01=g_ogb.oga04  
    DISPLAY BY NAME g_ogb.*
    CALL q101_b_fill()
    CALL cl_show_fld_cont()             
END FUNCTION
 
FUNCTION q101_b_fill()
    DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
    LET l_sql = " SELECT '',adl01,adl02,adk08,adk04,adk05,adl07,adl08,adl20,",
                "           adl05,adl15,adl17,adl12,adl14 ",
                "   FROM adl_file,adk_file",
                "  WHERE adl03 = '",g_ogb.ogb01,"'",
                "    AND adl04 = '",g_ogb.ogb03,"'",
                "    AND adl01 = adk01 ",
                "    AND adkconf = 'Y'",
                "    AND ",g_wc2 CLIPPED,
                " ORDER BY adl01,adl02 "
    PREPARE q101_pb FROM l_sql
    DECLARE q101_bcs  CURSOR FOR q101_pb   
 
    LET g_cnt = 1
#   LET g_adl05_t = 0
    FOREACH q101_bcs INTO g_adl[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#       LET g_adl05_t = g_adl05_t+g_adl[g_cnt].adl05
        LET g_adl[g_cnt].r = g_cnt
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_adl.deleteElement(g_cnt)
    CALL SET_COUNT(g_cnt-1)
END FUNCTION
 
FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adl TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
   BEFORE DISPLAY
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL cl_show_fld_cont()     
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY      
 
      ON ACTION previous
         CALL q101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
 
 
      ON ACTION jump
         CALL q101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION next
         CALL q101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
 	 ACCEPT DISPLAY             
 
 
      ON ACTION last
         CALL q101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY                  
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
         CALL q101_def_form()  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()     
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q101_def_form()                                                                                                            
    IF g_sma.sma115 ='N' THEN                                                                                                       
       CALL cl_set_comp_visible("adl15,adl17,adl12,adl14",FALSE)  
       CALL cl_set_comp_visible("group03",FALSE)                                                                                    
    END IF         
    IF g_sma.sma115 ='Y' THEN                                                                                                       
       CALL cl_set_comp_visible("ogb05,ogb12,adl20,adl05",FALSE)             
    END IF                                                                                                                        
    IF g_sma.sma122 ='1' THEN                                                                                                       
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl15", g_msg CLIPPED)                                                                            
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl17", g_msg CLIPPED)                                                                            
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl12", g_msg CLIPPED)                                                                            
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl14", g_msg CLIPPED)                                                                            
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)                 
    END IF                                                                                                                          
    IF g_sma.sma122 ='2' THEN                                                                                                       
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl15", g_msg CLIPPED)                                                                            
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl17", g_msg CLIPPED)                                                                            
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl12", g_msg CLIPPED)                                                                            
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("adl14", g_msg CLIPPED)      
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)                                                                                                                                                     
    END IF                                                                                                                          
END FUNCTION                                  
