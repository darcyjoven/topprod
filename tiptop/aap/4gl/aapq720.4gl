# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aapq720.4gl
# Descriptions...: 發票開立折讓查詢 
# Date & Author..: #No.FUN-8A0108 08/10/29 By xiaofeizhu
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B50096 11/05/12 By Dido 查詢發票日期應多串 apk_file 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_apb DYNAMIC ARRAY OF RECORD
          apb01    LIKE apb_file.apb01,
          apk05    LIKE apk_file.apk05,
          apb11    LIKE apb_file.apb11,
          apk08    LIKE apk_file.apk08,
          apk07    LIKE apk_file.apk07,
          apk06    LIKE apk_file.apk06,
          apb10    LIKE apb_file.apb10,
          sum      LIKE apb_file.apb10 
        END RECORD,             
     g_wc,g_sql    STRING,                      
     l_ac          LIKE type_file.num5       
 
DEFINE   g_cnt     LIKE type_file.num10
DEFINE   l_cmd     LIKE type_file.chr100
            
MAIN       
   DEFINE p_row,p_col    LIKE type_file.num5         
   OPTIONS                               
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   LET p_row = 4 LET p_col = 2
   OPEN WINDOW q720_w AT p_row,p_col
       WITH FORM "aap/42f/aapq720" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   CALL q720_menu()
   CLOSE WINDOW q720_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION q720_cs()
   DEFINE   l_cnt LIKE type_file.num5          
 
   CLEAR FORM 
   CALL g_apb.clear()
   CALL cl_opmsg('q')
   CONSTRUCT g_wc ON apb01,apk05,apb11,apk08,apk07,apk06,apb10
       FROM  s_apb[1].apb01,s_apb[1].apk05,s_apb[1].apb11,s_apb[1].apk08,
             s_apb[1].apk07,s_apb[1].apk06,s_apb[1].apb10 
             
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
         CALL cl_qbe_select()
          
      ON ACTION qbe_save
		     CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   MESSAGE ' WAIT ' 
  #LET g_sql=" SELECT DISTINCT apb01,'',apb11,'','','','','' FROM apb_file,apa_file ", #MOD-B50096 mark
   LET g_sql=" SELECT DISTINCT apb01,apk05,apb11,'','','','','' ",   #MOD-B50096
             "   FROM apb_file,apa_file,apk_file ",                  #MOD-B50096
             " WHERE ",g_wc CLIPPED,
             "   AND apb01 = apa01 ",
             "   AND (apb11 <>'' OR apb11 IS NOT NULL) ",
             "   AND apa00 = '21' ",
             "    AND apk03 = apb11 ",    #MOD-B50096
             " ORDER BY apb01 " 
   PREPARE q720_prepare FROM g_sql
   DECLARE q720_cs                        
        SCROLL CURSOR WITH HOLD FOR q720_prepare
 
END FUNCTION
 
 
FUNCTION q720_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000      
 
   WHILE TRUE
      CALL q720_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q720_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q720_q()
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q720_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    END IF
	MESSAGE ''
    CALL q720_b_fill()
END FUNCTION
 
FUNCTION q720_b_fill()             
   DEFINE 
          #l_sql     LIKE type_file.chr1000
          l_sql       STRING      #NO.FUN-910082
   DEFINE l_apa16   LIKE apa_file.apa16       
 
    FOR g_cnt = 1 TO g_apb.getLength()          
       INITIALIZE g_apb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q720_cs INTO g_apb[g_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      IF cl_null(g_apb[g_cnt].apb11) THEN CONTINUE FOREACH END IF
     #SELECT DISTINCT apk05 INTO g_apb[g_cnt].apk05 FROM apk_file   #MOD-B50096 mark
     # WHERE apk03 = g_apb[g_cnt].apb11                             #MOD-B50096 mark
      SELECT SUM(apk08),SUM(apk07),SUM(apk06) INTO g_apb[g_cnt].apk08,g_apb[g_cnt].apk07,g_apb[g_cnt].apk06
       FROM apk_file
       WHERE apk01 = g_apb[g_cnt].apb01
         AND apk03 = g_apb[g_cnt].apb11       
      SELECT SUM(apb10) INTO g_apb[g_cnt].apb10 FROM apb_file                                  
       WHERE apb01 = g_apb[g_cnt].apb01
         AND apb11 = g_apb[g_cnt].apb11      
      IF cl_null(g_apb[g_cnt].apb10) THEN
         LET g_apb[g_cnt].apb10 = 0
      END IF
      SELECT apa16 INTO l_apa16 FROM apa_file
       WHERE apa01 = g_apb[g_cnt].apb01
         AND apa00 = '21'
      LET g_apb[g_cnt].sum = g_apb[g_cnt].apb10*l_apa16/100   
      LET g_apb[g_cnt].sum = cl_digcut(g_apb[g_cnt].sum,g_azi04) 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_apb.deleteElement(g_cnt)                                                                                                 
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cnt  
END FUNCTION
 
FUNCTION q720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
   
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apb TO s_apb.*
 
      BEFORE ROW
        LET l_ac = ARR_CURR()
        CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()     
 
   
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
                                               
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"                                             
         EXIT DISPLAY
         
      ON ACTION allowancedetail                                                          
         LET l_cmd = "aapt210 '",g_apb[l_ac].apb01 CLIPPED,"' aapq720"                                             
         CALL cl_cmdrun(l_cmd)                                                                                                                     
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-8A0108
