# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axcq771.4gl
# Descriptions...: 
# Date & Author..: 10/05/24 By xiaofeizhu #No.FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
#No.FUN-AA0025
GLOBALS "../../config/top.global"
 
DEFINE
   g_tlf62        LIKE tlf_file.tlf62, 
   g_tlf DYNAMIC ARRAY OF RECORD          
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlfccost   LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222                       
             END RECORD,
   g_tlf_t       RECORD                  
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlfccost   LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222 
             END RECORD,
   g_argv1       LIKE tlf_file.tlf62,
   g_wc,g_sql    STRING,     
   g_rec_b       LIKE type_file.num5,        
   l_ac          LIKE type_file.num5        
DEFINE   g_forupd_sql    STRING                       
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_msg           LIKE ze_file.ze03           
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10        
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#  CALL cl_used('axcq771',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   LET g_argv1   = ARG_VAL(1)         
   LET g_tlf62   = NULL                  
   LET g_tlf62   = g_argv1
   
   OPEN WINDOW q771_w WITH FORM "axc/42f/axcq771"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
      CALL q771_q()
   END IF
   CALL q771_menu()
   CLOSE WINDOW q771_w                

#  CALL cl_used('axcq771',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION q771_curs()
   CLEAR FORM                            
   CALL g_tlf.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")          
   INITIALIZE g_tlf62 TO NULL 
           
     CONSTRUCT BY NAME g_wc ON tlf021,tlf06,tlf026,tlf62,tlf01

     BEFORE CONSTRUCT
       CALL cl_qbe_init()

     ON ACTION controlp                                                      
        IF INFIELD(tlf01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO tlf01                             
           NEXT FIELD tlf01                                                 
        END IF 
 
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
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " tlf62 = '",g_argv1,"'"
   END IF

END FUNCTION
 
FUNCTION q771_menu()
   WHILE TRUE
      CALL q771_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q771_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlf),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q771_q()

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q771_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
      INITIALIZE g_tlf62 TO NULL
      RETURN
   END IF
 
   CALL q771_show()               

END FUNCTION
 
FUNCTION q771_show()          
   CALL q771_b_fill(g_wc)                
 
END FUNCTION
 
FUNCTION q771_b_fill(p_wc)               
DEFINE   p_wc        STRING,
         l_sql       STRING      
         
DEFINE    sr               RECORD code   LIKE type_file.chr1,     
                                  ima12  LIKE ima_file.ima12,
                                  ima01  LIKE ima_file.ima01,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,  
                                  tlfccost LIKE tlfc_file.tlfccost, 
                                  tlf02  LIKE tlf_file.tlf02,
                                  tlf021 LIKE tlf_file.tlf021,
                                  tlf03  LIKE tlf_file.tlf03,
                                  tlf031 LIKE tlf_file.tlf031,
                                  tlf06  LIKE tlf_file.tlf06,
                                  tlf026 LIKE tlf_file.tlf026,
                                  tlf027 LIKE tlf_file.tlf027,
                                  tlf036 LIKE tlf_file.tlf036,
                                  tlf037 LIKE tlf_file.tlf037,
                                  tlf01  LIKE tlf_file.tlf01,
                                  tlf10  LIKE tlf_file.tlf10,
                                  tlfc21  LIKE tlfc_file.tlfc21,  
                                  tlf13  LIKE tlf_file.tlf13,
                                  tlf62  LIKE tlf_file.tlf62,
                                  tlf907 LIKE tlf_file.tlf907,
                                  amt01  LIKE tlfc_file.tlfc221,   
                                  amt02  LIKE tlfc_file.tlfc222,         
                                  amt03  LIKE tlfc_file.tlfc2231,    
                                  amt04  LIKE tlfc_file.tlfc2232,   
                                  amt05  LIKE tlfc_file.tlfc224,  
                                  amt07  LIKE tlfc_file.tlfc2241, 
                                  amt08  LIKE tlfc_file.tlfc2241,
                                  amt09  LIKE tlfc_file.tlfc2241,
                                  amt06  LIKE ccc_file.ccc23     
                        END RECORD 
DEFINE     l_slip     LIKE smy_file.smyslip   
DEFINE     l_smydmy1  LIKE smy_file.smydmy1
                        
     LET l_sql = "SELECT cch05,ima12,ima01,ima02,ima021,tlfccost, ",
                 "       tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,",
                 "       tlf036,tlf037,tlf01,tlf10*tlf60,tlf21,tlf13,tlf62,tlf907,",
                 "       tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0",  
                 "  FROM tlf_file LEFT OUTER JOIN (SELECT * FROM cch_file,tlfc_file WHERE cch06 = tlfctype AND cch07 =tlfccost) ON ",
                 "       cch01 = tlf62 ",
                 "       AND cch02 = YEAR(tlf06) ",
                 "       AND cch03 = MONTH(tlf06) ",
                 "       AND cch04 = tlf01 ",
                 "       AND tlfc01 = tlf01  AND tlfc06 = tlf06",     
                 "       AND tlfc02 = tlf02  AND tlfc03 = tlf03 ",    
                 "       AND tlfc13 = tlf13 ",                                  
                 "       AND tlfc902= tlf902 AND tlfc903= tlf903 ",   
                 "       AND tlfc904= tlf904 AND tlfc907= tlf907 ",   
                 "       AND tlfc905= tlf905 AND tlfc906= tlf906",   
                 "       ,ima_file,sfb_file",     
                 " WHERE ima_file.ima01 = tlf01 AND tlf62 = sfb_file.sfb01 ",
                 "   AND ((tlf13 LIKE 'asfi5%') OR (tlf13 LIKE 'asft6%' AND sfb02='11'))",                 
                 "   AND ",p_wc CLIPPED,
                 "   AND tlf902 NOT IN(SELECT jce02 FROM jce_file) "  
 
     PREPARE axcq771_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE axcq771_curs1 CURSOR FOR axcq771_prepare1

     CALL g_tlf.clear()
     LET g_cnt = 1

     FOREACH axcq771_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

       IF sr.tlf907>0 THEN
          LET l_slip = s_get_doc_no(sr.tlf036)
       ELSE
          LET l_slip = s_get_doc_no(sr.tlf026)
       END IF
       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
        WHERE smyslip = l_slip
       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
          CONTINUE FOREACH
       END IF

       IF cl_null(sr.code) THEN LET sr.code = ' ' END IF
       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
       IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
       IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
       IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
       IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF  
       IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF   
       IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF   
       IF  cl_null(sr.amt09)  THEN LET sr.amt09=0 END IF
       
       IF sr.tlf907 = 1 THEN 
          LET sr.tlf02  = sr.tlf03
          LET sr.tlf021 = sr.tlf031     
          LET sr.tlf026 = sr.tlf036
       ELSE 
          LET sr.tlf10= sr.tlf10 * -1
          LET sr.amt01= sr.amt01 * -1
          LET sr.amt02= sr.amt02 * -1
          LET sr.amt03= sr.amt03 * -1
          LET sr.amt04= sr.amt04 * -1
          LET sr.amt05= sr.amt05 * -1
          LET sr.amt07= sr.amt07 * -1                                                                                              
          LET sr.amt08= sr.amt08 * -1                                                                                              
          LET sr.amt09= sr.amt09 * -1          
       END IF

       LET sr.amt06 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt04 + sr.amt05 + sr.amt07 + sr.amt08 + sr.amt09 
       IF cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF

       LET g_tlf[g_cnt].tlf021 = sr.tlf021
       LET g_tlf[g_cnt].tlf06 = sr.tlf06
       LET g_tlf[g_cnt].tlf026 = sr.tlf026
       LET g_tlf[g_cnt].tlf62 = sr.tlf62       
       LET g_tlf[g_cnt].tlf01 = sr.tlf01
       LET g_tlf[g_cnt].ima02 = sr.ima02
       LET g_tlf[g_cnt].ima021 = sr.ima021
       LET g_tlf[g_cnt].tlfccost = sr.tlfccost
       LET g_tlf[g_cnt].tlf10 = sr.tlf10
       LET g_tlf[g_cnt].amt01 = sr.amt01
       LET g_tlf[g_cnt].amt02 = sr.amt02
       LET g_tlf[g_cnt].amt03 = sr.amt03
       LET g_tlf[g_cnt].amt04 = sr.amt04
       LET g_tlf[g_cnt].amt05 = sr.amt05
       LET g_tlf[g_cnt].amt06 = sr.amt06
       LET g_tlf[g_cnt].amt07 = sr.amt07
       LET g_tlf[g_cnt].amt08 = sr.amt08
       LET g_tlf[g_cnt].amt09 = sr.amt09

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	        EXIT FOREACH
       END IF       
     END FOREACH
     
   CALL g_tlf.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q771_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tlf TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
