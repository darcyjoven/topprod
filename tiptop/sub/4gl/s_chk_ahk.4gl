# Prog. Version..: '5.30.07-13.05.31(00001)'     #
#     
# Library name...: s_chk_ahk
# Descriptions...: 检查科目核算是否设置当前作业
# Date & Author..: 2013/05/20 By lujh     FUN-D40118
   
DATABASE ds 
      
GLOBALS "../../config/top.global" 
                          
         
FUNCTION s_chk_ahk(p_aag01,p_bookno)
   DEFINE   p_aag01  LIKE aag_file.aag01   #FUN-D40118
   DEFINE   p_bookno LIKE aag_file.aag00
   DEFINE   l_cnt    LIKE type_file.num5
   DEFINE   l_flag   LIKE type_file.chr1
			
	SELECT COUNT(*) INTO l_cnt FROM ahk_file		
	 WHERE ahk00 = p_bookno		
           AND ahk01 = p_aag01			
           AND ahk02 = g_prog
	IF l_cnt>=1 THEN		
	    LET l_flag = 'Y'		
	ELSE		
	   LET l_flag ='N'		
	END IF 		
	RETURN l_flag		
END FUNCTION			



