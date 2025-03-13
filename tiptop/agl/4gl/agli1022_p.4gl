# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: agli1022_p.4gl
# Descriptions...: 異動碼(固定)類型維護作業
# Input parameter:
# Date & Author..: No:FUN-9B0017 10/09/09 By chenmoyan
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE  g_aag_u DYNAMIC ARRAY OF RECORD 　      　      　      　      　      　      　      　      　      　                  
                     sel     LIKE type_file.chr1,       　      　      　      　      　      　      　      　      　      　  
                     aag00   LIKE aag_file.aag00,       　      　      　      　      　      　      　      　      　      　  
                     aag01   LIKE aag_file.aag01,       　      　      　      　      　      　      　      　      　      　  
                     aag02   LIKE aag_file.aag02,       　      　      　      　      　      　      　      　      　      　  
                     aag31   LIKE aag_file.aag31,       　      　      　      　      　      　      　      　      　      　  
                     ahe02_1 LIKE ahe_file.ahe02,       　      　      　      　      　      　      　      　      　      　  
                     aag311  LIKE aag_file.aag311,      　      　      　      　      　      　      　      　      　      　  
                     aag32   LIKE aag_file.aag32,       　      　      　      　      　      　      　      　      　      　  
                     ahe02_2 LIKE ahe_file.ahe02,       　      　      　      　      　      　      　      　      　      　  
                     aag321  LIKE aag_file.aag321,      　      　      　      　      　      　      　      　      　      　  
                     aag33   LIKE aag_file.aag33,       　      　      　      　      　      　      　      　      　      　  
                     ahe02_3 LIKE ahe_file.ahe02,       　      　      　      　      　      　      　      　      　      　  
                     aag331  LIKE aag_file.aag331,      　      　      　      　      　      　      　      　      　      　  
                     aag34   LIKE aag_file.aag34,       　      　      　      　      　      　      　      　      　      　  
                     ahe02_4 LIKE ahe_file.ahe02,       　      　      　      　      　      　      　      　      　      　  
                     aag341  LIKE aag_file.aag341       　      　      　      　      　      　      　      　      　      　  
                     END RECORD 　       
DEFINE g_rec_b       LIKE type_file.num5
DEFINE l_ac          LIKE type_file.num5   
DEFINE g_sql         STRING 
DEFINE i             LIKE type_file.num5
DEFINE g_no LIKE type_file.chr1
DEFINE g_aag00 LIKE aag_file.aag00
DEFINE l_wc STRING
DEFINE g_cnt LIKE type_file.num5
MAIN
DEFINE p_row,p_col LIKE type_file.num5
   OPTIONS                                #改變一些系統預設值                                                                      
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理    
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_user()) THEN                                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF   
   IF (NOT cl_setup("AGL")) THEN                                                                                                    
      EXIT PROGRAM                                                                                                                  
   END IF     
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   LET p_row = 4 LET p_col = 12   
   OPEN WINDOW i1022_u_w AT p_row,p_col
        WITH FORM "agl/42f/agli1022_p"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   LET g_aag00 =ARG_VAL(1)
   LET g_no=ARG_VAL(2)
   IF NOT cl_null(g_aag00) AND NOT cl_null(g_no) THEN      
      LET l_wc=" 1=1 " 
      CALL i1022_d_fill('1',l_wc)      
      CALL i1022_u_b() 
      CALL i1022_u_menu()
   END IF
   CLOSE WINDOW i1022_u_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN 

FUNCTION i1022_u_menu()
   WHILE TRUE
      CALL i1022_u_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i1022_u_b()
            ELSE
               LET g_action_choice=NULL
            END IF 
         WHEN "query"
            IF cl_chk_act_auth() THEN  
               CALL i1022_u_askkey()
            ELSE                                                                                                                    
               LET g_action_choice=NULL                                                                                             
            END IF
         WHEN "update_data"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i1022_u_update() 
            ELSE                                                                                                                    
               LET g_action_choice=NULL                                                                                             
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aag_u),'','')                                                    
            END IF                                                                                                                  
      END CASE                                                                                                                      
   END WHILE                                                                                                                        
END FUNCTION                   

FUNCTION  i1022_u_bp(p_ud)
   DEFINE p_ud LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                                                                                
      RETURN                                                                                                                        
   END IF       

   LET g_action_choice = " "   
   CALL cl_set_act_visible("accept,cancel", FALSE)                                                                                  
   DISPLAY ARRAY g_aag_u TO s_aag_u.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                                                         
                                                                                                                                    
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         EXIT DISPLAY                                                                                                               

      ON ACTION query
         LET g_action_choice="query"                                                                                               
         LET l_ac = 1                                                                                                               
         EXIT DISPLAY  
                                  
      ON ACTION update_data
         LET g_action_choice="update_data"                                                                                                
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
                                                                                                                                    
   END DISPLAY                                                                                                                      
   CALL cl_set_act_visible("accept,cancel", TRUE)                                                                                   
END FUNCTION                     

FUNCTION i1022_sel_all_1(p_value)                                                                                                    
   DEFINE p_value   LIKE type_file.chr1                                                                                             
   DEFINE l_i       LIKE type_file.num10                                                                                            
                                                                                                                                    
   FOR l_i = 1 TO g_aag_u.getLength()                                                                                              
       LET g_aag_u[l_i].sel = p_value                                                                                              
   END FOR                                                                                                                          
                                                                                                                                    
END FUNCTION       
 
FUNCTION i1022_d_fill(p_cmd,p_wc)
DEFINE p_cmd LIKE type_file.chr1
DEFINE p_wc  STRING
   IF p_cmd='1' THEN
      LET g_sql = "SELECT '',aag00,aag01,aag02,aag31,'',aag311,aag32,'',aag321,aag33,'',aag331,aag34,'',aag341 ",	　	　	　
                  "   FROM aag_file WHERE aag00 ='",g_aag00,"' AND aag07 !='1' AND aagacti='Y' "	　	　	　	　	　	　	　	　
      CASE	　	　	　	　	　	　	　	　	　	　	　	　	　	　
         WHEN g_no = '1'	　	　	　	　	　	　	　	　	　	　	　	　
            LET g_sql = g_sql CLIPPED, 	　	　	　	　	　	　	　	　	　	　
                "   AND aag31 IS NOT NULL "	　	　	　	　	　	　	　	　	　	　
         WHEN g_no = '2'	　	　	　	　	　	　	　	　	　	　	　	　
            LET g_sql = g_sql CLIPPED, 	　	　	　	　	　	　	　	　	　	　
                "   AND aag32 IS NOT NULL "	　	　	　	　	　	　	　	　	　	　
         WHEN g_no = '3'	　	　	　	　	　	　	　	　	　	　	　	　
            LET g_sql = g_sql CLIPPED, 	　	　	　	　	　	　	　	　	　	　
                "   AND aag33 IS NOT NULL "	　	　	　	　	　	　	　	　	　	　
         WHEN g_no = '4'　	　	　	　	　	　	　	　	　	　	　	　
            LET g_sql = g_sql CLIPPED, 	　	　	　	　	　	　	　	　	　	　
                "   AND aag34 IS NOT NULL "	　	　	　	　	　	　	　	　	　	　
      END CASE
   END IF
   IF p_cmd='2' THEN
      LET g_sql = "SELECT '',aag00,aag01,aag02,aag31,'',aag311,aag32,'',aag321,aag33,'',aag331,aag34,'',aag341 ",       　      　  
                  "   FROM aag_file WHERE aag07 !='1' AND aagacti='Y' AND ",p_wc CLIPPED 　
   END IF 
   PREPARE d_fill_pre FROM g_sql
   DECLARE d_fill_cs CURSOR FOR d_fill_pre　	　	　	　	　	　	　	　	　	　	　	　	　
   LET i = 1	　	　	　	　	　	　	　	　	　	　	　	　	　
   CALL g_aag_u.clear()	　	　	　	　	　	　	　	　	　	　	　	　
   FOREACH d_fill_cs INTO g_aag_u[i].* 
      LET g_aag_u[i].sel = 'N'   	　	　	　	　	　	　	　	　	　	　	　
     #取得異動碼名稱	　	　	　	　	　	　	　	　	　	　	　	　
      CALL i1022_u_ahe02(g_aag_u[i].aag31)	　	　	　	　	　	　	　	　	　	　
           RETURNING g_aag_u[i].ahe02_1	　	　	　	　	　	　	　	　	　	　
      CALL i1022_u_ahe02(g_aag_u[i].aag32)	　	　	　	　	　	　	　	　	　	　
           RETURNING g_aag_u[i].ahe02_2	　	　	　	　	　	　	　	　	　	　
      CALL i1022_u_ahe02(g_aag_u[i].aag33)	　	　	　	　	　	　	　	　	　	　
           RETURNING g_aag_u[i].ahe02_3	　	　	　	　	　	　	　	　	　	　
      CALL i1022_u_ahe02(g_aag_u[i].aag34)	　	　	　	　	　	　	　	　	　	　
           RETURNING g_aag_u[i].ahe02_4	　	　	　	　	　	　	　	　	　	　
      LET i = i + 1	　	　	　	　	　	　	　	　	　	　	　	　
   END FOREACH	　	　	　	　	　	　	　	　	　	　	　	　	　
   CALL g_aag_u.deleteElement(i)
   LET g_cnt=i-1	　	　	　	　	　	　	　	　	　	　	　
   DISPLAY g_cnt TO FORMONLY.cnt	　	　	　	　	　	　	　	　	　	　	　	　	　
END FUNCTION	　	　	　	　	　	　	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
FUNCTION i1022_u_ahe02(p_aag)	　	　	　	　	　	　	　	　	　	　	　
 DEFINE  p_aag     LIKE aag_file.aag15,	　	　	　	　	　	　	　	　	　	　
         l_ahe02   LIKE ahe_file.ahe02	　	　	　	　	　	　	　	　	　	　
 SELECT ahe02 INTO l_ahe02 FROM ahe_file	　	　	　	　	　	　	　	　	　	　
  WHERE ahe01 = p_aag	　	　	　	　	　	　	　	　	　	　	　	　
 RETURN l_ahe02	　	　	　	　	　	　	　	　	　	　	　	　	　
END FUNCTION	　	　	　	　	　	　	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
FUNCTION i1022_u_b()	
   CALL cl_set_comp_entry("aag00,aag01,aag02,aag31,ahe02_1,aag311",FALSE)　	　
   CALL cl_set_comp_entry("aag32,ahe02_2,aag321,aag33,ahe02_3,aag331,aag34,ahe02_4,aag341",FALSE)	　	　	　	　	　	　	　	　	　	　
   INPUT ARRAY g_aag_u WITHOUT DEFAULTS FROM s_aag_u.*	　	　	　	　	　	　	　	　
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,	　	　	　	　	　	　	　
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
      BEFORE INPUT	　	　	　	　	　	　	　	　	　	　	　	　
         IF g_rec_b!=0 THEN	　	　	　	　	　	　	　	　	　	　	　
            CALL fgl_set_arr_curr(l_ac)	　	　	　	　	　	　	　	　	　	　
         END IF	　	　	　	　	　	　	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
      BEFORE ROW	　	　	　	　	　	　	　	　	　	　	　	　	　
         LET l_ac = ARR_CURR()	　	　	　	　	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　
      AFTER INPUT	　	　	　	　	　	　	　	　	　	　	　	　	　
         EXIT INPUT	　	　	　	　	　	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
      ON ACTION select_all
         CALL i1022_sel_all_1("Y")
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
      ON ACTION select_non
         CALL i1022_sel_all_1("N")
         	　	　	　	　	　	　	　	　	　	　	　	　	　
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
END FUNCTION	　	　	　	　	　	　	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
#--異動碼數據更新----#	　	　	　	　	　	　	　	　	　	　	　	　
FUNCTION i1022_u_update()
DEFINE l_flag LIKE type_file.chr1
DEFINE l_i LIKE type_file.num10
DEFINE l_aag31 LIKE aag_file.aag31
DEFINE l_aag311 LIKE aag_file.aag311 
DEFINE l_aag01 LIKE aag_file.aag01
DEFINE l_aag02 LIKE aag_file.aag02

 #--單身有勾選時才能進行異動---#	　	　	　	　	　	　	　	　	　	　	　
  LET l_flag = 'N'	　	　	　	　	　	　	　	　	　	　	　	　
  FOR l_i = 1 TO g_aag_u.getLength()	　	　	　	　	　	　	　	　	　	　
      IF g_aag_u[l_i].sel = 'Y' THEN	　	　	　	　	　	　	　	　	　	　
         LET l_flag = 'Y'	　	　	　	　	　	　	　	　	　	　	　	　
      END IF	　	　	　	　	　	　	　	　	　	　	　	　	　
  END FOR	　	　	　	　	　	　	　	　	　	　	　	　	　
  IF l_flag = 'N' THEN	　	　	　	　	　	　	　	　	　	　	　	　
     CALL cl_err('','agl-161',0)	　	　	　	　	　	　	　	　	　
     RETURN	　	　	　	　	　	　	　	　	　	　	　	　	　
  END IF	　
  LET g_success='Y' 
  BEGIN WORK
  CALL s_showmsg_init()	　	　	　	　	　	　	　	　	　	　	　	　	　
  SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00='0'
  FOR l_i = 1 TO g_aag_u.getLength()	　	　	　	　	　	　	　	　	　	　
      CASE 	　	　	　	　	　	　	　	　	　	　	　	　	　
         WHEN g_no = '1' #(異動碼5)	　	　
            IF g_aag_u[l_i].sel='Y' THEN  	　	　	　	　	　	　	　	　	　
               UPDATE aag_file SET aag31 = g_aaz.aaz121,aag311 = g_aaz.aaz1211	　	　	　	　	　	　
                WHERE aag00 = g_aag_u[l_i].aag00	　	　	　	　	　	　	　	　	　
                  AND aag01 = g_aag_u[l_i].aag01	　
            END IF 	　	　	　	　	　	　	　	　	　
         WHEN g_no = '2' #(異動碼6)	　	　	　	　	　	　	　	　	　	　	　
            IF g_aag_u[l_i].sel='Y' THEN   
               UPDATE aag_file SET aag32 = g_aaz.aaz122,aag321 = g_aaz.aaz1221	　	　	　	　	　	　
                WHERE aag00 = g_aag_u[l_i].aag00	　	　	　	　	　	　	　	　	　
                  AND aag01 = g_aag_u[l_i].aag01	　	
            END IF 　	　	　	　	　	　	　	　	　
         WHEN g_no = '3' #(異動碼7)	　
            IF g_aag_u[l_i].sel='Y' THEN  	　	　	　	　	　	　	　	　	　	　
               UPDATE aag_file SET aag33 = g_aaz.aaz123,aag331 = g_aaz.aaz1231	　	　	　	　	　	　
                WHERE aag00 = g_aag_u[l_i].aag00	　	　	　	　	　	　	　	　	　
                  AND aag01 = g_aag_u[l_i].aag01	
            END IF 　	　	　	　	　	　	　	　	　	　
         WHEN g_no = '4' #(異動碼8)	
            IF g_aag_u[l_i].sel='Y' THEN  　	　	　	　	　	　	　	　	　	　	　
               UPDATE aag_file SET aag34 = g_aaz.aaz124,aag341 = g_aaz.aaz1241	　	　	　	　	　	　
                WHERE aag00 = g_aag_u[l_i].aag00	　	　	　	　	　	　	　	　	　
                  AND aag01 = g_aag_u[l_i].aag01         	　	　	
            END IF 　	　	　	　	　	　	　
      END CASE	　	　	　	　	　	　	　	　	　	　	　	　	　
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN	　	　	　	　	　	　	　	　	　
        #記錄在錯誤訊息文件中，更新失敗	　	
         LET g_showmsg=g_aag_u[l_i].aag00,"/",g_aag_u[l_i].aag01　
         CALL s_errmsg('aag00,aag01',g_showmsg,'UPD aag_file:','','1')  	　	　	　	　	　	　	　	　
         LET g_success = 'N'	　
	 EXIT FOR　 	　	　	　	　	　	　	　	　	　
      END IF	　	　	　	　	　	　	　	　	　	　	　	　	　
   END FOR	　	
　 IF g_success='Y' THEN
      COMMIT WORK
      FOR l_i = 1 TO g_aag_u.getLength() 
         CASE 
            WHEN g_no='1' 
               IF g_aag_u[l_i].sel='Y' THEN    
                  LET g_aag_u[l_i].aag31=g_aaz.aaz121
                  LET g_aag_u[l_i].aag311=g_aaz.aaz1211
                  CALL i1022_u_ahe02(g_aag_u[l_i].aag31)	　	　	　	　	　	　	　	　	　	　
                       RETURNING g_aag_u[l_i].ahe02_1	　	　	　	　	　	　	　	　	　	　
               END IF 
            WHEN g_no='2' 
               IF g_aag_u[l_i].sel='Y' THEN                                                                                         
                  LET g_aag_u[l_i].aag32=g_aaz.aaz122                                                                               
                  LET g_aag_u[l_i].aag321=g_aaz.aaz1221                                                                             
                  CALL i1022_u_ahe02(g_aag_u[l_i].aag32)	　	　	　	　	　	　	　	　	　	　
                       RETURNING g_aag_u[l_i].ahe02_2	　	　	　	　	　	　	　	　	　	　
               END IF       
            WHEN g_no='3'                                                                                                           
               IF g_aag_u[l_i].sel='Y' THEN                                                                                         
                  LET g_aag_u[l_i].aag33=g_aaz.aaz123                                                                               
                  LET g_aag_u[l_i].aag331=g_aaz.aaz1231                                                                             
                  CALL i1022_u_ahe02(g_aag_u[l_i].aag33)	　	　	　	　	　	　	　	　	　	　
                       RETURNING g_aag_u[l_i].ahe02_3	　	　	　	　	　	　	　	　	　	　
               END IF                                                                                                               
            WHEN g_no='4'                                                                                                           
               IF g_aag_u[l_i].sel='Y' THEN                                                                                         
                  LET g_aag_u[l_i].aag34=g_aaz.aaz124                                                                               
                  LET g_aag_u[l_i].aag341=g_aaz.aaz1241                                                                             
                  CALL i1022_u_ahe02(g_aag_u[l_i].aag34)	　	　	　	　	　	　	　	　	　	　
                       RETURNING g_aag_u[l_i].ahe02_4	　	　	　	　	　	　	　	　	　	　
               END IF      
         END CASE
      END FOR        
   ELSE
      ROLLBACK WORK	　
   END IF 	
  #資料庫更新后，檢查此次勾選的異動碼不為空，卻與agls103參數設定不相同值者，記錄在錯誤訊息中顯示
   CASE 
      WHEN g_no='1'
         LET g_sql= " SELECT aag01,aag02,aag31,aag311 FROM aag_file WHERE aag00='",g_aag00,"' AND aag31 IS NOT NULL ",
                    " AND aag07 !='1' AND aagacti='Y' "
      WHEN g_no='2'
         LET g_sql= " SELECT aag01,aag02,aag32,aag321 FROM aag_file WHERE aag00='",g_aag00,"' AND aag32 IS NOT NULL ",
                    " AND aag07 !='1' AND aagacti='Y' "
      WHEN g_no='3'
         LET g_sql= " SELECT aag01,aag02,aag33,aag331 FROM aag_file WHERE aag00='",g_aag00,"' AND aag33 IS NOT NULL ",
                    " AND aag07 !='1' AND aagacti='Y' "
      WHEN g_no='4'
         LET g_sql= " SELECT aag01,aag02,aag34,aag341 FROM aag_file WHERE aag00='",g_aag00,"' AND aag34 IS NOT NULL ",
                    " AND aag07 !='1' AND aagacti='Y' "
   END CASE  　	　	　	　	　	　	　	　	　	　
   PREPARE chk_pre FROM g_sql
   DECLARE chk_cs CURSOR FOR chk_pre
   FOREACH chk_cs INTO l_aag01,l_aag02,l_aag31,l_aag311
      CASE
         WHEN g_no='1'
              IF l_aag31<>g_aaz.aaz121 OR l_aag311 <>g_aaz.aaz1211 THEN
                 LET g_showmsg=l_aag01,"/",l_aag02,"/",l_aag31,"/",l_aag311 
                 CALL s_errmsg('aag01,aag02,aag31,aag311',g_showmsg,'','agl-503','1')
              END IF
         WHEN g_no='2'
              IF l_aag31<>g_aaz.aaz122 OR l_aag311 <>g_aaz.aaz1221 THEN
                 LET g_showmsg=l_aag01,"/",l_aag02,"/",l_aag31,"/",l_aag311
                 CALL s_errmsg('aag01,aag02,aag32,aag321',g_showmsg,'','agl-503','1')     
              END IF  
         WHEN g_no='3' 
              IF l_aag31<>g_aaz.aaz123 OR l_aag311<>g_aaz.aaz1231 THEN
                 LET g_showmsg=l_aag01,"/",l_aag02,"/",l_aag31,"/",l_aag311 
                 CALL s_errmsg('aag01,aag02,aag33,aag331',g_showmsg,'','agl-503','1')
              END IF 
         WHEN g_no='4'
              IF l_aag31<>g_aaz.aaz124 OR l_aag311 <>g_aaz.aaz1241 THEN
                 LET g_showmsg=l_aag01,"/",l_aag02,"/",l_aag31,"/",l_aag311
                 CALL s_errmsg('aag01,aag02,aag34,aag341',g_showmsg,'','agl-503','1')
              END IF 
      END CASE 
   END FOREACH
   CALL s_showmsg()
END FUNCTION	　	　	　	　	　	　	　	　	　	　	　	　	　
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
#重新查詢	　	　	　	　	　	　	　	　	　	　	　	　	　
FUNCTION i1022_u_askkey()	　	　	　	　	　	　	　	　	　	　	　	　
DEFINE	　	　	　	　	　	　	　	　	　	　	　	　	　	　
   l_wc            LIKE type_file.chr1000 	　	　	　	　	　	　	　	　	　	　
   CLEAR FORM 
   CALL g_aag_u.clear()　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
   CONSTRUCT l_wc ON aag00,aag01,aag02,aag31,aag32,aag33,aag34	　	　	　	　	　	　	　	　
      FROM s_aag_u[1].aag00,s_aag_u[1].aag01,s_aag_u[1].aag02,	　	　	　	　	　	　	　	　
           s_aag_u[1].aag31,s_aag_u[1].aag32,s_aag_u[1].aag33,	　	　	　	　	　	　	　	　
           s_aag_u[1].aag34	　	
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
                                                                                                                                    
      ON ACTION CONTROLP                                                                                                           
         CASE                                                                                                                      
            WHEN INFIELD(aag00)       #帳別                                                                                     
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_aaa"                                                                                  
               LET g_qryparam.state= "c"                                                                                      
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
               DISPLAY g_qryparam.multiret TO aag00           　	　	　	　	　	　	　	　	　	　
               NEXT FIELD aag00                                                                                               
            WHEN INFIELD(aag01)       #科目編號                                                                                 
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_aag02"                                                                                
               LET g_qryparam.state= "c"                                                                                      
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
               DISPLAY g_qryparam.multiret TO aag01                                                                           
               NEXT FIELD aag01                                                                                               
            WHEN INFIELD(aag31)       #異動代碼5                                                                                
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_ahe"                                                                                  
               LET g_qryparam.state= "c"                                                                                      
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
               DISPLAY g_qryparam.multiret TO aag31                                                                           
               NEXT FIELD aag31                                                                                               
            WHEN INFIELD(aag32)       #異動代碼6                                                                                
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_ahe"                                                                                  
               LET g_qryparam.state= "c"        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
               DISPLAY g_qryparam.multiret TO aag32                                                                           
               NEXT FIELD aag32                                                                                               
            WHEN INFIELD(aag33)       #異動代碼7                                                                                
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_ahe"                                                                                  
               LET g_qryparam.state= "c"                                                                                      
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
               DISPLAY g_qryparam.multiret TO aag33                                                                           
               NEXT FIELD aag33                                                                                               
            WHEN INFIELD(aag34)       #異動代碼8                                                                                
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_ahe"                                                                                  
               LET g_qryparam.state= "c"                                                                                      
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
               DISPLAY g_qryparam.multiret TO aag34                                                                           
               NEXT FIELD aag34                                                                                               
      END CASE                                                                                                                  
                                                                                                                                    
      ON ACTION qbe_select                                                                                               
         CALL cl_qbe_select()                                                                                             
      ON ACTION qbe_save                                                                                                 
         CALL cl_qbe_save()                                                                                               
   END CONSTRUCT                   
   IF INT_FLAG THEN                                                                                                                 
      LET INT_FLAG = 0                                                                                                              
      LET l_wc = NULL                                                                                                               
      LET g_rec_b = 0                                                                                                               
      RETURN                                                                                                                        
   END IF          
   IF cl_null(l_wc) THEN LET l_wc=" 1=1 " END IF                                                                                                                  
   CALL i1022_d_fill('2',l_wc)  

END FUNCTION	　	　	　	　	　	　	　	　	　	　	　	　	　
#FUN-9B0017　	　	　	　	　	　	　	　	　	　	　	　	　	　	　


