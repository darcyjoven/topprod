# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: almp760.4gl
# Descriptions...: 促銷終止作業  
# Date & Author..: 08/08/25 By lilingyu
# Modify.........: No.FUN-960134 09/07/22 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在SQL后加上SQLCA.sqlcode判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lqg   DYNAMIC ARRAY OF RECORD      
                  sel      LIKE type_file.chr1,
                  lqg01    LIKE lqg_file.lqg01,
                  lqg02    LIKE lqg_file.lqg02,
                  lqg03    LIKE lqg_file.lqg03,
                  lqf02    LIKE lqf_file.lqf02,
                  lqf03    LIKE lqf_file.lqf03,
                  lqg08    LIKE lqg_file.lqg08,
                  lqg09    LIKE lqg_file.lqg09
                 END RECORD      
DEFINE g_rec_b    LIKE type_file.num5                                             
DEFINE g_sql      LIKE type_file.chr1000
DEFINE g_cnt      LIKE type_file.num5
DEFINE g_i        LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE l_count    LIKE type_file.num10
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
DEFINE g_wc2      LIKE type_file.chr1000
 
MAIN
   OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT                
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW p760_w WITH FORM "alm/42f/almp760"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   
   LET g_wc2 = ' 1 = 1'
   
   CALL p760_b_fill(g_wc2)
   CALL p760_menu()
 
   CLOSE WINDOW p760_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p760_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000  
 
   WHILE TRUE
      CALL p760_bp("G")
      CASE g_action_choice      
        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p760_q()
            END IF
 
        WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p760_b() 
            END IF   
             
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_lqg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p760_q()
 
     CLEAR FORM
     CALL g_lqg.clear()   
                                                                                                  
     CONSTRUCT g_wc2 ON lqg01,lqg02,lqg03,lqg08,lqg09                                                          
                    FROM s_lqg[1].lqg01,s_lqg[1].lqg02,s_lqg[1].lqg03,                                                                
                         s_lqg[1].lqg08,s_lqg[1].lqg09                                                    
 
     BEFORE CONSTRUCT                                                                                                     
           CALL cl_qbe_init()                                                                                                
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(lqg01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_lqg"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqg01
               
            WHEN INFIELD(lqg03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_lqg3"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqg03          
             
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
 
     ON ACTION qbe_select                                                                                                 
        CALL cl_qbe_select()                                                                                              
 
     ON ACTION qbe_save                                                                                                   
        CALL cl_qbe_save()                                                                                                
 
    END CONSTRUCT                                                                                                           
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('lqguser', 'lqggrup') #FUN-980030
    IF INT_FLAG THEN 
        LET INT_FLAG = 0
        LET g_wc2 = NULL 
        RETURN 
    END IF 
 
    CALL p760_b_fill(g_wc2)
    CALL p760_b()
END FUNCTION
 
FUNCTION p760_b_fill(p_wc2)
  DEFINE  p_wc2       LIKE type_file.chr1000
  DEFINE  l_lqf02     LIKE lqf_file.lqf02
  DEFINE  l_lqf03     LIKE lqf_file.lqf03 
   
     LET g_sql ="SELECT '',lqg01,lqg02,lqg03,'','',lqg08,lqg09",   
               " FROM lqg_file ",
               " WHERE ",p_wc2 CLIPPED,
               "   AND lqg07 = 'Y' ",
               " ORDER BY lqg01"
    PREPARE p760_pb FROM g_sql
    DECLARE lqg_curs CURSOR FOR p760_pb
 
    CALL g_lqg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
   
    FOREACH lqg_curs INTO g_lqg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        ###########################################
        LET g_lqg[g_cnt].sel = 'N'
 
        SELECT lqf02,lqf03 INTO l_lqf02,l_lqf03 FROM lqf_file 
         WHERE lqf01 = g_lqg[g_cnt].lqg03
         LET g_lqg[g_cnt].lqf02 = l_lqf02
         LET g_lqg[g_cnt].lqf03 = l_lqf03
         DISPLAY BY NAME g_lqg[g_cnt].lqf02,g_lqg[g_cnt].lqf03  
        #########################################
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lqg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p760_b()
DEFINE l_i   LIKE type_file.num5 
DEFINE l_count LIKE type_file.num5
 
   IF g_lqg.getLength()=0 THEN
      LET g_action_choice=''
      RETURN
   END IF  
 
    INPUT ARRAY g_lqg WITHOUT DEFAULTS FROM s_lqg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
       
      BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
       
       AFTER ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT
 
       ON ACTION select_all
          CALL p760_sel_all_1("Y")
 
       ON ACTION select_non
          CALL p760_sel_all_1("N")
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg
          CALL cl_cmdask() 
 
    END INPUT
 
    LET g_action_choice=''
    IF INT_FLAG THEN
       LET INT_FLAG=0
       RETURN
    END IF
 
  LET l_count = 0 
  FOR l_i = 1 TO g_lqg.getLength()
      IF g_lqg[l_i].sel == 'Y' THEN
         LET l_count = l_count + 1
       END IF 
  END FOR    
  IF l_count > 0 THEN 
    CALL p760_update()
  ELSE
    CALL cl_err('','alm-428',1) 	
 END IF   
END FUNCTION
 
FUNCTION p760_update()
    DEFINE  l_i     LIKE type_file.num5 
    
       
    IF NOT cl_confirm("alm-250") THEN 
       RETURN
    ELSE
    	FOR l_i =1 TO g_lqg.getLength()
          IF cl_null(g_lqg[l_i].lqg01) THEN 
             CONTINUE FOR 
          END IF 
          IF g_lqg[l_i].sel = 'Y' THEN 
             UPDATE lqg_file
                SET lqg10 = g_user,
                    lqg11 = g_today,
                    lqg07 = 'S'
              WHERE lqg01 = g_lqg[l_i].lqg01
             IF SQLCA.sqlcode THEN
                CALL cl_err('',SQLCA.sqlcode,1) #No.TQC-A30075 Add
             ELSE
           	    MESSAGE 'UPDATE O.K' 
             END IF      
          END IF 
       END FOR              
    END IF    
END FUNCTION
 
FUNCTION p760_sel_all_1(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num5
 
   FOR l_i = 1 TO g_lqg.getLength()
       LET g_lqg[l_i].sel = p_value
   END FOR
END FUNCTION
 
FUNCTION p760_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice="detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lqg TO s_lqg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query 
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac =1
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
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
#No.FUN-960134 
