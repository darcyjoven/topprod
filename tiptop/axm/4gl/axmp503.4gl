# Prog. Version..: '5.30.06-13.03.12(00005)'     #
# Pattern name...: axmp503.4gl
# Descriptions...:  訂單分配拋轉還原作業 
# Date & Author..: No:FUN-A40074 10/04/28 By lilingyu
# Modify.........: No:TQC-A50038 10/05/13 By lilingyu 過單 
# Modify.........: No:TQC-A50061 10/05/18 By lilingyu 多角拋轉還原時的相關邏輯處理
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管 
# Modify.........: No:TQC-BB0086 11/11/08 By lilingyu 若多角流程單據相同，則整單還原

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../axm/4gl/axmp503.global"           #TQC-A50061 

DEFINE g_oea   DYNAMIC ARRAY OF RECORD
                  oea03     LIKE oea_file.oea03,
                  occ02     LIKE occ_file.occ02,
                  oea01     LIKE oea_file.oea01,
                  oea02     LIKE oea_file.oea02,
                  oeb03     LIKE oeb_file.oeb03,
                  oeb04     LIKE oeb_file.oeb04,
                  oeb06     LIKE oeb_file.oeb06,
                  oeb913    LIKE oeb_file.oeb913,
                  oeb915    LIKE oeb_file.oeb915,
                  oeb910    LIKE oeb_file.oeb910,
                  oeb912    LIKE oeb_file.oeb912,
                  oeb12     LIKE oeb_file.oeb12,
                  oeb13     LIKE oeb_file.oeb13,
                  oeb15     LIKE oeb_file.oeb15,
                  oeb920    LIKE oeb_file.oeb920
               END RECORD,
       g_oea_t RECORD
                  oea03     LIKE oea_file.oea03,
                  occ02     LIKE occ_file.occ02,
                  oea01     LIKE oea_file.oea01,
                  oea02     LIKE oea_file.oea02,
                  oeb03     LIKE oeb_file.oeb03,
                  oeb04     LIKE oeb_file.oeb04,
                  oeb06     LIKE oeb_file.oeb06,
                  oeb913    LIKE oeb_file.oeb913,
                  oeb915    LIKE oeb_file.oeb915,
                  oeb910    LIKE oeb_file.oeb910,
                  oeb912    LIKE oeb_file.oeb912,
                  oeb12     LIKE oeb_file.oeb12,
                  oeb13     LIKE oeb_file.oeb13,
                  oeb15     LIKE oeb_file.oeb15,
                  oeb920    LIKE oeb_file.oeb920
               END RECORD,
       g_oee   DYNAMIC ARRAY OF RECORD
                  sel       LIKE type_file.chr1,
                  oee03     LIKE oee_file.oee03,
                  oee04     LIKE oee_file.oee04,
                  azp02     LIKE azp_file.azp02,
                  oee05     LIKE oee_file.oee05,
                  oee071    LIKE oee_file.oee071,
                  oee072    LIKE oee_file.oee072,
                  oee073    LIKE oee_file.oee073,
                  oee061    LIKE oee_file.oee061,
                  oee062    LIKE oee_file.oee062,
                  oee063    LIKE oee_file.oee063,
                  oee081    LIKE oee_file.oee081,
                  oee082    LIKE oee_file.oee082,
                  oee083    LIKE oee_file.oee083,
                  oee09     LIKE oee_file.oee09,
                  oee10     LIKE oee_file.oee10,
                  oee11     LIKE oee_file.oee11 
               END RECORD,
       g_oee_t RECORD
                  sel       LIKE type_file.chr1,
                  oee03     LIKE oee_file.oee03,
                  oee04     LIKE oee_file.oee04,
                  azp02     LIKE azp_file.azp02,
                  oee05     LIKE oee_file.oee05,
                  oee071    LIKE oee_file.oee071,
                  oee072    LIKE oee_file.oee072,
                  oee073    LIKE oee_file.oee073,
                  oee061    LIKE oee_file.oee061,
                  oee062    LIKE oee_file.oee062,
                  oee063    LIKE oee_file.oee063,
                  oee081    LIKE oee_file.oee081,
                  oee082    LIKE oee_file.oee082,
                  oee083    LIKE oee_file.oee083,
                  oee09     LIKE oee_file.oee09,
                  oee10     LIKE oee_file.oee10,
                  oee11     LIKE oee_file.oee11 
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,       
       g_rec_b1       LIKE type_file.num5,        
       l_ac1          LIKE type_file.num5,        
       l_ac1_t        LIKE type_file.num5,        
       l_ac           LIKE type_file.num5         
DEFINE p_row,p_col    LIKE type_file.num5         
DEFINE g_cnt          LIKE type_file.num10        
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_ima906       LIKE ima_file.ima906
DEFINE g_msg          LIKE type_file.chr1000      
DEFINE g_edit         LIKE type_file.chr1         

MAIN

   OPTIONS                               
      INPUT NO WRAP                     
   DEFER INTERRUPT                       

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  

   LET p_row = 2 LET p_col = 3

   OPEN WINDOW p503_w AT p_row,p_col WITH FORM "axm/42f/axmp503"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL p503_def_form()   
      
   CALL p503_menu()

   CLOSE WINDOW p503_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  

END MAIN

FUNCTION p503_menu()
DEFINE l_cnt       LIKE type_file.num5 
DEFINE i           LIKE type_file.num5 
DEFINE l_pmn50     LIKE pmn_file.pmn50 
DEFINE l_pmm905    LIKE pmm_file.pmm905 
DEFINE l_msg       STRING
DEFINE l_pmm22     LIKE pmm_file.pmm22
DEFINE l_pmn88     LIKE pmn_file.pmn88
DEFINE l_pmn88t    LIKE pmn_file.pmn88t
#TQC-BB0086 --begin--
DEFINE l_sql       STRING
DEFINE l_oee02     LIKE oee_file.oee02
DEFINE l_oee083    LIKE oee_file.oee083
#TQC-BB0086 --end--

   LET g_code = NULL  #TQC-A50061

#TQC-BB0086 --begin--
   LET l_sql ="SELECT oee02,oee083 FROM oee_file",
              " WHERE oee01 = ? AND oee03 = ?",
              "   AND oee05 = ? AND oee10 = ?"
   PREPARE p503_pre FROM l_sql
   DECLARE p503_cus CURSOR FOR p503_pre
#TQC-BB0086 --end--
   
   WHILE TRUE
      CALL p503_bp("G")    
      
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p503_q()
            END IF
         WHEN "choose"
            IF cl_chk_act_auth() THEN               
               IF g_oee.getLength() =0 THEN 
                  CALL cl_err('','axm-173',0) 
                  LET g_action_choice = NULL
               ELSE
               	  CALL p503_b()                    
               END IF 
            ELSE
               LET g_action_choice = NULL
            END IF
           
         WHEN "undo_carry"
            IF cl_chk_act_auth() THEN
               IF g_oee.getLength() =0 THEN 
                  CALL cl_err('','axm-173',0)   
                  LET g_action_choice = NULL
               ELSE
                  LET l_cnt = 0 
                  SELECT COUNT(sel) INTO l_cnt FROM p503_table
                   WHERE sel = 'Y'               
                  IF l_cnt = 0  THEN 
                    CALL cl_err('','axm-207',0)
                    LET g_action_choice = NULL
                  ELSE
            #TQC-A50061 --begin--                 	     
                    LET g_code = g_prog   
                  	LET g_total_1   = 1                                   	                    	         
            #TQC-A50061 --end---                    	
                  	 FOR i= 1 TO g_oee.getLength()
                  	     IF g_oee[i].sel = 'N' THEN 
                  	        CONTINUE FOR 
                  	     END IF 
                  	     
                  	     SELECT pmn50 INTO l_pmn50 FROM pmn_file
                  	      WHERE pmn01 = g_oee[i].oee10
                  	        AND pmn03 = g_oee[i].oee11
                  	     IF l_pmn50 > 0 THEN 
                            CALL cl_err('','axm-243',0)
                            CONTINUE FOR            	     
                  	     END IF     
                  	     
                  	     SELECT pmm905 INTO l_pmm905 FROM pmm_file
                  	      WHERE pmm01 = g_oee[i].oee10 
                  	     IF l_pmm905 = 'Y' THEN
            #TQC-A50061 --begin--
                            IF g_total_1 = 1 THEN                  	                                      	     
                       	       LET g_total_sum = 0
                      	       SELECT COUNT(*) INTO g_total_sum FROM pmn_file
                      	        WHERE pmn01 = g_oee[i].oee10                   	         
                      	    END IF     
            #TQC-A50061 --end---                   	     
                            LET l_msg = " pmm01 ='",g_oee[i].oee10 CLIPPED,"'"
#TQC-BB0086--begin--
                            IF i=1 THEN
                               CALL cl_err('','axm-391',1)
                            END IF
#TQC-BB0086--end--
                  	    CALL p811(l_msg,"A") RETURNING g_success 
            #TQC-A50061 --begin--                 	     
                          IF g_success = 'Y' THEN  
 #                           IF g_total_1 = g_total_sum THEN   #TQC-BB0086
                               DELETE FROM pmm_file WHERE pmm01 = g_oee[i].oee10
                               DELETE FROM pmn_file WHERE pmn01 = g_oee[i].oee10
#TQC-BB0086--begin--                                  
#                               UPDATE oeb_file SET oeb920 = oeb920 - g_oee[i].oee083
#                                WHERE oeb01 = g_oea_t.oea01
#                                  AND oeb03 = g_oea_t.oeb03  
                               FOREACH p503_cus USING g_oea_t.oea01, g_oee[i].oee03,
                                                      g_oee[i].oee05,g_oee[i].oee10
                                                INTO l_oee02,l_oee083
                                  IF STATUS THEN 
                                     CALL cl_err('',STATUS,1)
                                     CONTINUE FOR  
                                  END IF 
                                  
                                  UPDATE oeb_file SET oeb920 = oeb920 - l_oee083
                                   WHERE oeb01 = g_oea_t.oea01
                                     AND oeb03 = l_oee02
                                  IF STATUS THEN 
                                     CALL cl_err('',STATUS,1)
                                     CONTINUE FOR  
                                  END IF                                      
                               END FOREACH                        
#TQC-BB0086--end--                                                        
                               UPDATE oee_file SET oee10 = NULL,oee11 = NULL 
                                WHERE oee01 = g_oea_t.oea01
#                                 AND oee02 = g_oea_t.oeb03     #TQC-BB0086
                                  AND oee03 = g_oee[i].oee03
                                  AND oee05 = g_oee[i].oee05
#                                 AND oee09 = g_oee[i].oee09    #TQC-BB0086
                                  AND oee10 = g_oee[i].oee10    #TQC-BB0086      
                               DELETE FROM p503_table    
#TQC-BB0086 --begin--                                                              
#                            ELSE
#                              UPDATE oee_file SET oee10 = NULL,oee11 = NULL 
#                                WHERE oee01 = g_oea_t.oea01
#                                  AND oee02 = g_oea_t.oeb03
#                                  AND oee03 = g_oee[i].oee03
#                                  AND oee05 = g_oee[i].oee05
#                                  AND oee09 = g_oee[i].oee09
#                               UPDATE oeb_file SET oeb920 = oeb920 - g_oee[i].oee083
#                                WHERE oeb01 = g_oea_t.oea01
#                                  AND oeb03 = g_oea_t.oeb03 
#                               DELETE FROM pmn_file 
#                                WHERE pmn01 = g_oee[i].oee10
#                                  AND pmn02 = g_oee[i].oee11
#                                                          
#                              SELECT SUM(pmn88),SUM(pmn88t) INTO l_pmn88,l_pmn88t
#                                FROM pmn_file
#                               WHERE pmn01 = g_oee[i].oee10
#                              IF cl_null(l_pmn88)  THEN LET l_pmn88  = 0 END IF 
#                              IF cl_null(l_pmn88t) THEN LET l_pmn88t = 0 END IF                                  
#                              
#                              SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01 = g_oee[i].oee10
#                              SELECT azi04 INTO t_azi04 FROM azi_file 
#                               WHERE azi01=l_pmm22 
#                                 AND aziacti ='Y'
#                              CALL cl_digcut(l_pmn88,t_azi04) RETURNING l_pmn88  
#                              CALL cl_digcut(l_pmn88t,t_azi04) RETURNING l_pmn88t 
#                              UPDATE pmm_file 
#                                 SET pmm40 = l_pmn88,
#                                     pmm40t =l_pmn88t 
#                               WHERE pmm01 = g_oee[i].oee10      
#                               
#                               LET g_total_1 = g_total_1 + 1 
#                               IF g_total_1 > g_total_sum THEN 
#                                  CALL cl_err('','9035',0)
#                                  EXIT FOR 
#                               END IF                                	                                      
#                            END IF  
#TQC-BB0086 --end--                               
                           END IF                                                    	         
            #TQC-A50061 --end---                    	        
                  	     ELSE
                            LET l_cnt = 0                                               
         	                  SELECT COUNT(*) INTO l_cnt FROM p503_table
         	                   WHERE oee10 = g_oee[i].oee10 
                            IF l_cnt <= 1 THEN                                  ###delete all
                               DELETE FROM pmm_file WHERE pmm01 = g_oee[i].oee10
                               DELETE FROM pmn_file WHERE pmn01 = g_oee[i].oee10
                               UPDATE oee_file SET oee10 = NULL,oee11 = NULL 
                                WHERE oee01 = g_oea_t.oea01
                                  AND oee02 = g_oea_t.oeb03
                                  AND oee03 = g_oee[i].oee03
                                  AND oee05 = g_oee[i].oee05
                                  AND oee09 = g_oee[i].oee09
                               UPDATE oeb_file SET oeb920 = oeb920 - g_oee[i].oee083
                                WHERE oeb01 = g_oea_t.oea01
                                  AND oeb03 = g_oea_t.oeb03   
                               DELETE FROM p503_table                                    
                               IF STATUS THEN 
                                  CALL cl_err('',STATUS,1)
                               ELSE
                               	  CALL cl_err('','axm-334',1)
                               END IF 	     
                            ELSE                            	
                              UPDATE oee_file SET oee10 = NULL,oee11 = NULL 
                                WHERE oee01 = g_oea_t.oea01
                                  AND oee02 = g_oea_t.oeb03
                                  AND oee03 = g_oee[i].oee03
                                  AND oee05 = g_oee[i].oee05
                                  AND oee09 = g_oee[i].oee09
                               UPDATE oeb_file SET oeb920 = oeb920 - g_oee[i].oee083
                                WHERE oeb01 = g_oea_t.oea01
                                  AND oeb03 = g_oea_t.oeb03 
                               DELETE FROM pmn_file 
                                WHERE pmn01 = g_oee[i].oee10
                                  AND pmn03 = g_oee[i].oee11
                                                          
                              SELECT SUM(pmn88),SUM(pmn88t) INTO l_pmn88,l_pmn88t
                                FROM pmn_file
                               WHERE pmn01 = g_oee[i].oee10
                              IF cl_null(l_pmn88)  THEN LET l_pmn88  = 0 END IF 
                              IF cl_null(l_pmn88t) THEN LET l_pmn88t = 0 END IF                                  
                              
                              SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01 = g_oee[i].oee10
                              SELECT azi04 INTO t_azi04 FROM azi_file 
                               WHERE azi01=l_pmm22 
                                 AND aziacti ='Y'
                              CALL cl_digcut(l_pmn88,t_azi04) RETURNING l_pmn88  
                              CALL cl_digcut(l_pmn88t,t_azi04) RETURNING l_pmn88t 
                              UPDATE pmm_file 
                                 SET pmm40 = l_pmn88,
                                     pmm40t =l_pmn88t 
                               WHERE pmm01 = g_oee[i].oee10                                                                                                                   	    
                               
                               IF STATUS THEN 
                                  CALL cl_err('',STATUS,1)
                               ELSE
                               	  CALL cl_err('','axm-334',1)
                               END IF   
                                                            
                            END IF                	    
                  	     END IF                      	     
                   	 END FOR                     
                   	 
                   	 CALL p503_b_fill()
                  END IF                 	 
               END IF                
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

FUNCTION p503_q()

   CALL p503_b_askkey()

END FUNCTION

FUNCTION p503_b()
   DEFINE l_ac_t          LIKE type_file.num5,          
          l_n             LIKE type_file.num5,          
          l_lock_sw       LIKE type_file.chr1,          
          p_cmd           LIKE type_file.chr1,          
          l_allow_insert  LIKE type_file.num5,          
          l_allow_delete  LIKE type_file.num5           
   DEFINE l_oee09         LIKE oee_file.oee09
   DEFINE l_sumoee083     LIKE oee_file.oee083
   DEFINE l_poy03         LIKE poy_file.poy03           
   DEFINE l_count         LIKE type_file.num5 
   
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg("b")

   IF cl_null(g_oea_t.oea01) THEN
      RETURN
   END IF

   LET g_forupd_sql = "SELECT 'N',oee03,oee04,'',oee05,oee071,oee072,",
                      "       oee073,oee061,oee062,oee063,oee081,",
                      "       oee082,oee083,oee09,oee10,oee11",
                      "  FROM oee_file",
                      " WHERE oee01=? AND oee02=?",
                      "   AND oee03=? AND oee05=?",
                      "   AND oee09=? FOR UPDATE"

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p503_bcl CURSOR FROM g_forupd_sql

#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE 
    

    
   INPUT ARRAY g_oee WITHOUT DEFAULTS FROM s_oee.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         
      BEFORE ROW
         LET p_cmd = ""
         LET l_ac = ARR_CURR()
         LET l_lock_sw = "N"
         LET l_n  = ARR_COUNT()
         BEGIN WORK     
         IF g_rec_b >= l_ac THEN
            LET g_oee_t.* = g_oee[l_ac].*
            LET p_cmd = "u"
            OPEN p503_bcl USING g_oea_t.oea01,g_oea_t.oeb03, 
                                g_oee_t.oee03,g_oee_t.oee05,g_oee_t.oee09
            IF STATUS THEN
               CALL cl_err("OPEN p503_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p503_bcl INTO g_oee[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT sel INTO g_oee[l_ac].sel FROM p503_table
                   WHERE oee01 = g_oea_t.oea01
                     AND oee02 = g_oea_t.oeb03
                     AND oee03 = g_oee_t.oee03
                     AND oee05 = g_oee_t.oee05
                     AND oee09 = g_oee_t.oee09
                        	
                  SELECT azp02 INTO g_oee[l_ac].azp02 FROM azp_file
                   WHERE azp01 = g_oee[l_ac].oee04
               END IF
            END IF
          END IF   

      AFTER ROW
        IF cl_null(g_oee[l_ac].sel) THEN 
           NEXT FIELD sel
        END IF 
                 
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            IF p_cmd = "u" THEN
               LET g_oee[l_ac].* = g_oee_t.*
            END IF
            CLOSE p503_bcl
            ROLLBACK WORK  
            EXIT INPUT
         ELSE
         	  SELECT COUNT(*) INTO l_count FROM  p503_table
         	   WHERE oee01 = g_oea_t.oea01
         	     AND oee02 = g_oea_t.oeb03
         	     AND oee03 = g_oee[l_ac].oee03
         	     AND oee05 = g_oee[l_ac].oee05
         	     AND oee09 = g_oee[l_ac].oee09
         	   IF l_count = 0 THEN   
         	      INSERT INTO p503_table VALUES(g_oee[l_ac].sel,g_oea_t.oea01,g_oea_t.oeb03,
         	        g_oee[l_ac].oee03,g_oee[l_ac].oee04,g_oee[l_ac].oee05,g_oee[l_ac].oee061,
         	        g_oee[l_ac].oee062,g_oee[l_ac].oee063,g_oee[l_ac].oee071,g_oee[l_ac].oee072,
         	        g_oee[l_ac].oee073,g_oee[l_ac].oee081,g_oee[l_ac].oee082,g_oee[l_ac].oee083,
         	        g_oee[l_ac].oee09,g_oee[l_ac].oee10,g_oee[l_ac].oee11)   
         	   ELSE
         	   	   UPDATE p503_table SET sel = g_oee[l_ac].sel
         	        WHERE oee01 = g_oea_t.oea01
             	     AND oee02 = g_oea_t.oeb03
            	     AND oee03 = g_oee[l_ac].oee03
            	     AND oee05 = g_oee[l_ac].oee05
            	     AND oee09 = g_oee[l_ac].oee09
         	   END IF 	   
         END IF
         CLOSE p503_bcl
         COMMIT WORK  

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

         ON ACTION qbe_save
            CALL cl_qbe_save()
   END INPUT

   CLOSE p503_bcl
   COMMIT WORK  

END FUNCTION

FUNCTION p503_b_askkey()

   CLEAR FORM
   CALL g_oea.clear()

   CONSTRUCT g_wc2 ON oea03,oea01,oea02,oeb03,oeb04,oeb06,oeb15
                 FROM s_oea[1].oea03,s_oea[1].oea01,s_oea[1].oea02,
                      s_oea[1].oeb03,s_oea[1].oeb04,s_oea[1].oeb06,
                      s_oea[1].oeb15

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea03
                    NEXT FIELD oea03
               WHEN INFIELD(oea01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oea17"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
                    NEXT FIELD oea01
               WHEN INFIELD(oeb04)
#FUN-AA0059---------mod------------str-----------------               
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state = "c"
#                    LET g_qryparam.form ="q_ima"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO oeb04
                    NEXT FIELD oeb04
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

   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   CALL p503_b1_fill(g_wc2)

   LET l_ac1 = 1
   LET g_oea_t.* = g_oea[l_ac1].*
   SELECT ima906 INTO g_ima906 
     FROM ima_file
    WHERE ima01 = g_oea_t.oeb04

   CALL p503_b_fill()

END FUNCTION

FUNCTION p503_b1_fill(p_wc2)
   DEFINE p_wc2     STRING

   LET g_sql = "SELECT oea03,'',oea01,oea02,oeb03,oeb04,oeb06,",
               "       oeb913,oeb915,oeb910,oeb912,oeb12,oeb13,oeb15,oeb920", 
               "  FROM oea_file,oeb_file,occ_file",
               " WHERE ",p_wc2 CLIPPED,
               "   AND oea01 = oeb01",
               "   AND oea00 = '1'",
               "   AND oea37 = 'Y'",
               "   AND oea03 = occ01",
               "   AND oeb920 >0",
               "   AND oeb24 = 0",
               "   AND oeaconf = 'Y'",
               " ORDER BY oea03,oea01"

   PREPARE p503_pb1 FROM g_sql
   DECLARE oea_curs CURSOR FOR p503_pb1
  
   CALL g_oea.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH oea_curs INTO g_oea[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF

      SELECT occ02 INTO g_oea[g_cnt].occ02
        FROM occ_file
       WHERE occ01 = g_oea[g_cnt].oea03

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_oea.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION p503_b_fill()


IF cl_null(g_oea_t.oeb03) THEN 
   LET g_sql = "SELECT 'N',oee03,oee04,'',oee05,oee071,oee072,oee073,",
               "       oee061,oee062,oee063,oee081,oee082,oee083,",
               "       oee09,oee10,oee11",
               "  FROM oee_file",
               " WHERE oee01 = '",g_oea_t.oea01,"'",
               "   AND oee10 IS NOT NULL",
               "   AND (oee063>0 OR oee073>0 OR oee083>0)" ,
               " ORDER BY oee03"
ELSE	
   LET g_sql = "SELECT 'N',oee03,oee04,'',oee05,oee071,oee072,oee073,",
               "       oee061,oee062,oee063,oee081,oee082,oee083,",
               "       oee09,oee10,oee11",
               "  FROM oee_file",
               " WHERE oee01 = '",g_oea_t.oea01,"'",
               "   AND oee02 = ",g_oea_t.oeb03,
               "   AND oee10 IS NOT NULL",
               "   AND (oee063>0 OR oee073>0 OR oee083>0)" ,
               " ORDER BY oee03"
END IF                
 
   PREPARE p503_pb FROM g_sql
   DECLARE oee_curs CURSOR FOR p503_pb
  
   CALL g_oee.clear()
  
   LET g_cnt = 1

   FOREACH oee_curs INTO g_oee[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF

      SELECT sel INTO g_oee[g_cnt].sel FROM p503_table
       WHERE oee01 = g_oea_t.oea01
         AND oee02 = g_oea_t.oeb03
         AND oee03 = g_oee[g_cnt].oee03
         AND oee05 = g_oee[g_cnt].oee05
         AND oee09 = g_oee[g_cnt].oee09
         
      SELECT azp02 INTO g_oee[g_cnt].azp02 FROM azp_file
       WHERE azp01 = g_oee[g_cnt].oee04
       
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_oee.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION

FUNCTION p503_bp2()

   DISPLAY ARRAY g_oee TO s_oee.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help    
         CALL cl_show_help()

      ON ACTION controlg 
         CALL cl_cmdask()

   END DISPLAY

END FUNCTION

FUNCTION p503_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1      

   IF p_ud <> "G" OR g_action_choice = "choose" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW)

      BEFORE DISPLAY 
         CALL fgl_set_arr_curr(l_ac1)
  
      BEFORE ROW
         IF l_ac1_t = 0 THEN
            LET l_ac1 = ARR_CURR()       
            IF l_ac1=0 THEN               
               LET l_ac1=1                
            END IF                       
            CALL FGL_SET_ARR_CURR(l_ac1)   
         ELSE                           
            LET l_ac1 = l_ac1_t            
            CALL FGL_SET_ARR_CURR(l_ac1)  
         END IF
         CALL cl_show_fld_cont()
         LET l_ac1_t = 0                   
         LET g_oea_t.* = g_oea[l_ac1].*
         
         SELECT ima906 INTO g_ima906 
           FROM ima_file
          WHERE ima01 = g_oea_t.oeb04                                                                                               
        
         CALL p503_b_fill()                                                                                                         
         CALL p503_bp2()   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION choose
         LET g_action_choice="choose"
         LET l_ac1_t = l_ac1              
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION undo_carry
         LET g_action_choice="undo_carry"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL p503_def_form()   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

     #ON ACTION accept
     #   LET g_action_choice="distributed_detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
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

FUNCTION p503_def_form()   

    DROP TABLE p503_table
    
    CREATE TEMP TABLE p503_table(
          sel     LIKE type_file.chr1,
          oee01   LIKE oee_file.oee01,   
          oee02   LIKE oee_file.oee02,  
          oee03   LIKE oee_file.oee03,  
          oee04   LIKE oee_file.oee04,  
          oee05   LIKE oee_file.oee05,  
          oee061  LIKE oee_file.oee061,  
          oee062  LIKE oee_file.oee062,  
          oee063  LIKE oee_file.oee063,  
          oee071  LIKE oee_file.oee071,  
          oee072  LIKE oee_file.oee072,  
          oee073  LIKE oee_file.oee073,  
          oee081  LIKE oee_file.oee081,  
          oee082  LIKE oee_file.oee082,  
          oee083  LIKE oee_file.oee083,  
          oee09   LIKE oee_file.oee09,  
          oee10   LIKE oee_file.oee10,  
          oee11   LIKE oee_file.oee11) 

         DELETE FROM p503_table                     #FUN-A40074
                   
    IF g_sma.sma115 = "N" THEN
       CALL cl_set_comp_visible("oeb910,oeb912",FALSE)
       CALL cl_set_comp_visible("oeb913,oeb915",FALSE)
       CALL cl_set_comp_visible("oee061,oee062,oee063",FALSE)
       CALL cl_set_comp_visible("oee071,oee072,oee073",FALSE)
       CALL cl_set_comp_visible("oee081,oee082",FALSE)
       CALL cl_set_comp_entry("oee063,oee073",FALSE)
    ELSE
       CALL cl_set_comp_entry("oee083",FALSE)
       CALL cl_set_comp_visible("oee062,oee072,oee082",FALSE)
    END IF

    IF g_sma.sma122 ='1' THEN 
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       #--end

       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee071",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee073",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee061",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee063",g_msg CLIPPED)
       #--end

    END IF

    IF g_sma.sma122 ='2' THEN 
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       #--end

       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee071",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee073",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee061",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg 
       CALL cl_set_comp_att_text("oee063",g_msg CLIPPED)
       #--end     #TQC-A50038
    END IF
END FUNCTION

