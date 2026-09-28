# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#                                                                                                                                   
# Program name...: s_chk_demo.4gl                                                                                                   
# Descriptions...: 檢查當前使用者是否有使用營運中心的權限                                                                           
# Date & Author..: 09/04/20 by dxfwo                                                                                                
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
#No.FUN-940102 --begin--                                                                                                                                    
DATABASE ds                                                                                                                         
GLOBALS "../../config/top.global"                                                                                                   
DEFINE   g_zxy          RECORD LIKE zxy_file.*                                                                                      
DEFINE   g_forupd_sql   STRING                                                                                                      
                                                                                                                                    
                                                                                                                                    
# Descriptions...: 營運中心檢查                                                                                                     
# Input Parameter: ps_user        使用者                                                                                            
#                  ps_plant       營運中心編號                                                                                      
# Return Code....: li_result      結果(TRUE/FALSE)                                                                                  
# Usage..........: CALL s_chk_demo(g_user,g_plant) RETURNING li_result                                                              
                                                                                                                                    
FUNCTION s_chk_demo(ps_user,ps_plant)                                                                                               
   DEFINE   ps_user         STRING                                                                                                  
   DEFINE   ps_plant        STRING                                                                                                  
   DEFINE   li_cnt          LIKE type_file.num10                                                                                    
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   l_user          LIKE zxy_file.zxy01                                                                                     
   DEFINE   l_plant         LIKE type_file.chr10                                                                                    
   DEFINE   l_dbs           LIKE type_file.chr21                                                                                    
   DEFINE   l_sql           STRING                                                                                                  
   WHENEVER ERROR CALL cl_err_msg_log                                                                                               
                                                                                                                                    
   LET li_result = TRUE                                                                                                             
                                                                                                                                    
   IF cl_null(ps_user) THEN                                                                                                         
      RETURN FALSE                                                                                                                  
   END IF                                                                                                                           
                                                                                                                                    
   LET g_errno = ""                                                                                                                 
                                                                                                                                    
   LET l_user = ps_user CLIPPED                                                                                                     
   LET l_plant = ps_plant CLIPPED                                                                                                   
                                                                                                                                    
   #抓取營運中心的DB                                                                                                                
   LET g_plant_new = l_plant                                                                                                        
   CALL s_getdbs()                                                                                                                  
   LET l_dbs = g_dbs_new
   #檢查當前使用者有沒有使用營運中心的權限                                                                                          
   #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs,"zxy_file ",
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'zxy_file'), #FUN-A50102   
               " WHERE zxy01 = '",l_user,"'" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
   PREPARE chk_demo_p1 FROM l_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("pre sel_zxy",STATUS,1)                                                                                           
   END IF                                                                                                                           
   DECLARE chk_demo_c1 CURSOR FOR chk_demo_p1                                                                                       
                                                                                                                                    
   IF STATUS THEN                                                                                                                   
      CALL cl_err("dec sel_zxy",STATUS,1)                                                                                           
   END IF                                                                                                                           
   OPEN chk_demo_c1                                                                                                                 
   FETCH chk_demo_c1 INTO li_cnt                                                                                                    
   IF li_cnt > 0 THEN               #USER權限存有資料,并g_user判斷是否該使用者的                                                    
      #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs,"zxy_file ",
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'zxy_file'), #FUN-A50102        
                  " WHERE zxy01 = '",l_user,"' AND zxy03 = '",l_plant,"'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102                   
      PREPARE chk_demo_p2 FROM l_sql                                                                                                
      IF STATUS THEN                                                                                                                
         CALL cl_err("pre2 sel_zxy",STATUS,1)                                                                                       
      END IF
      DECLARE chk_demo_c2 CURSOR FOR chk_demo_p2                                                                                    
      IF STATUS THEN                                                                                                                
         CALL cl_err("dec2 sel_zxy",STATUS,1)                                                                                       
      END IF                                                                                                                        
      OPEN chk_demo_c2                                                                                                              
      FETCH chk_demo_c2 INTO li_cnt                                                                                                 
      IF li_cnt = 0 THEN                                                                                                            
         LET g_errno = "sub-188"                                                                                                    
      END IF                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF NOT cl_null(g_errno) THEN                                                                                                     
      CALL cl_err(l_user CLIPPED,g_errno,1)                                                                                         
      RETURN FALSE                                                                                                                  
   ELSE                                                                                                                             
      RETURN TRUE                                                                                                                   
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION
#No.FUN-940102 --end--
