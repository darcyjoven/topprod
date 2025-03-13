# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_incchk.4gl
# Descriptions...: 
# Date & Author..: No.FUN-930109 09/03/17 By xiaofeizhu
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查
 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   
 
FUNCTION s_incchk(p_ware,p_loc,p_user)
 
DEFINE p_ware      LIKE inc_file.inc01,
       p_loc       LIKE inc_file.inc02,        
       p_user      LIKE inc_file.inc03,
       l_imd17     LIKE imd_file.imd17,
       l_ime17     LIKE ime_file.ime17,
       l_n         LIKE type_file.num5,
       l_flag      LIKE type_file.chr10
       
   LET l_flag = TRUE
   
   IF p_ware IS NULL OR cl_null(p_ware) THEN
      LET l_flag = TRUE      
   ELSE     
    SELECT imd17 INTO l_imd17 FROM imd_file WHERE imd01 = p_ware
      IF SQLCA.sqlcode THEN
        LET l_flag = FALSE
        CALL cl_err(p_ware,SQLCA.sqlcode,0)
      ELSE
     	  IF l_imd17 = 'Y' THEN
     	     IF p_loc IS NULL OR cl_null(p_loc) THEN LET p_loc = ' ' END IF 
           SELECT ime17 INTO l_ime17 FROM ime_file WHERE ime01 = p_ware AND ime02 = p_loc
                    AND imeacti = 'Y'  #FUN-D40103
             IF SQLCA.sqlcode THEN
                LET l_flag = FALSE
                CALL cl_err(p_loc,SQLCA.sqlcode,0)
             ELSE
               IF l_ime17='Y' THEN
          	      SELECT COUNT(*) INTO l_n FROM inc_file 
          	       WHERE inc01 = p_ware  AND inc02 = p_loc AND inc03 = p_user
          	      IF l_n>0 THEN
          	         LET l_flag = TRUE
          	      ELSE
          	 	 LET l_flag = FALSE   
          	      END IF
          	   ELSE
          	      SELECT COUNT(*) INTO l_n FROM inc_file 
          	       WHERE inc01 = p_ware AND inc02 = ' ' AND inc03 = p_user
          	      IF l_n>0 THEN
          	         LET l_flag = TRUE
          	      ELSE
          	         LET l_flag = FALSE   
          	      END IF          	   	   
               END IF                  
             END IF
        ELSE
           LET l_flag = TRUE     
        END IF   	        
      END IF
     END IF
     
   IF l_flag = TRUE THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
      	            
END FUNCTION
#FUN-930109
