DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hram   RECORD LIKE  hram_file.*
DEFINE g_ret    LIKE   type_file.chr100
DEFINE g_flag   LIKE   type_file.chr1

#FUNCTION hr_gen_no('hras_file','hras01','002','0000','')
#                   表名         字段名   编码ID  公司编号 上层公司编号
FUNCTION hr_gen_no(p_file,p_colunm,p_hram01,p_hraa01,p_hraa10)
DEFINE p_file     LIKE   type_file.chr100
DEFINE p_colunm   LIKE   type_file.chr100
DEFINE p_hram01   LIKE   hram_file.hram01
DEFINE p_hraa01   LIKE   hraa_file.hraa01
DEFINE p_hraa10   LIKE   hraa_file.hraa10


       LET g_ret=''   
       LET g_flag='Y'
          
       CALL hr_gen_pre(p_hraa01,p_hraa10,p_hram01)
       
       IF NOT cl_null(g_hram.hram01) AND g_hram.hram12='Y' THEN
       	  CALL hr_gen(g_hram.*,p_file,p_colunm) 
       END IF
       	  
       RETURN g_ret,g_flag   #员工编号,是否可以手动修改
       
END FUNCTION 
	
FUNCTION hr_gen_pre(p_hraa01,p_hraa10,p_hram01)
DEFINE p_hraa01     LIKE    hraa_file.hraa01
DEFINE p_hraa10     LIKE    hraa_file.hraa10
DEFINE p_hram01     LIKE    hram_file.hram01
DEFINE l_hraa10   LIKE   hraa_file.hraa10
       
       
       INITIALIZE g_hram.* TO NULL

       IF cl_null(p_hraa01) THEN RETURN END IF        
       
       SELECT * INTO g_hram.* FROM hram_file WHERE hram02=p_hraa01 AND hram12='Y'
                                               AND hram01=p_hram01
       IF NOT cl_null(g_hram.hram01) AND g_hram.hram12='Y' THEN
       	  RETURN
       ELSE
       	  IF NOT cl_null(p_hraa10) THEN
       	     SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=p_hraa10 AND hraaacti='Y'
       	     CALL hr_gen_pre(p_hraa10,l_hraa10,p_hram01)
       	  END IF   
       END IF
       	
END FUNCTION      
	
FUNCTION hr_gen(p_hram,p_file,p_colunm)	       	   
DEFINE  p_hram      RECORD LIKE   hram_file.*
DEFINE  p_file      LIKE    type_file.chr100
DEFINE  p_colunm    LIKE    type_file.chr100
DEFINE  l_check     LIKE    type_file.chr1000
DEFINE  l_check1    LIKE    type_file.chr1000
DEFINE  l_check2    LIKE    type_file.chr1000
DEFINE  l_str       STRING
DEFINE  l_str2      STRING
DEFINE  l_str3      STRING
DEFINE  l_length    LIKE    type_file.num5
DEFINE  l_format    STRING
DEFINE  l_sql       STRING
DEFINE  l_i         LIKE   type_file.num5
DEFINE  l_ret       LIKE   type_file.chr100
DEFINE  l_year      LIKE   type_file.chr10
DEFINE  l_month     LIKE   type_file.chr10
DEFINE  l_day       LIKE   type_file.chr10	 		   	  		
	      
	   LET g_ret=''
    
     LET l_str=''
     
	   CASE p_hram.hram09
	     WHEN 'N'    LET l_str2=''
             WHEN 'Y'    IF p_hram.hram10='1' THEN LET l_str2=' ' END IF
                         IF p_hram.hram10='2' THEN LET l_str2='_' END IF 		
	   END CASE
	   	
	   IF NOT cl_null(p_hram.hram03) THEN
	   	  LET l_str=l_str.trim()
	   	  LET l_str=l_str CLIPPED,p_hram.hram03
	   END IF
	   	
	   IF p_hram.hram05='Y' THEN
                LET l_year=YEAR(g_today)
                IF p_hram.hram06='YY' THEN
                   LET l_year=l_year[3,4]
                END IF
	   	  LET l_str=l_str.trim()
	   	  IF cl_null(l_str) THEN	     	  
	   	     LET l_str=l_str CLIPPED,l_year
	   	  ELSE
	   	     LET l_str=l_str CLIPPED,l_str2,l_year
	   	  END IF	     
	   END IF
	   	
	   IF p_hram.hram07='Y' THEN
                LET l_month=MONTH(g_today) USING "&&"
	   	  LET l_str=l_str.trim()
	   	  IF cl_null(l_str) THEN	     	  
	   	     LET l_str=l_str CLIPPED,l_month
	   	  ELSE
	   	  	 LET l_str=l_str CLIPPED,l_str2,l_month
	   	  END IF	     
	   END IF
	   	
	   IF p_hram.hram08='Y' THEN
                LET l_day=DAY(g_today) USING "&&"
	   	  LET l_str=l_str.trim()
	   	  IF cl_null(l_str) THEN	     	  
	   	     LET l_str=l_str CLIPPED,l_day
	   	  ELSE
	   	  	 LET l_str=l_str CLIPPED,l_str2,l_day
	   	  END IF	     
	   END IF
	   	
	   LET l_str=l_str.trim()
	   LET l_check=l_str CLIPPED,l_str2,"%"
	   IF l_str2 IS NULL THEN
	   	  LET l_check1=l_str CLIPPED," %"
	   	  LET l_check2=l_str CLIPPED,"_%"
	      LET l_length=l_str.getLength()+p_hram.hram04
	   ELSE
	   	  LET l_length=l_str.getLength()+p_hram.hram04+1
	   END IF	     
       
       IF l_str2 IS NOT NULL THEN
          LET l_sql=" SELECT MAX(",p_colunm,") FROM ",p_file,
                    " WHERE ",p_colunm," LIKE '",l_check,"'",
                    "    AND length(",p_colunm,")=",l_length
       ELSE
       	  LET l_sql=" SELECT MAX(",p_colunm,") FROM ",p_file,
       	            "  WHERE ",p_colunm," LIKE '",l_check,"'",
       	            "    AND ",p_colunm," NOT LIKE '",l_check1,"'",
       	            "    AND instr(",p_colunm,",'_')=0 ", 
                    "    AND length(",p_colunm,")=",l_length
       END IF             
       	                	        
       PREPARE hr_gen_pre FROM l_sql
       EXECUTE hr_gen_pre INTO l_ret
       
       IF NOT cl_null(l_ret) THEN
       	  LET l_ret=l_ret[l_length-p_hram.hram04+1,l_length]
          LET l_ret=l_ret+1
          
       	  LET l_format=''
       	  FOR l_i = 1 TO p_hram.hram04
       	      LET l_format=l_format,"&"
       	  END FOR           	  
       	  LET l_ret=l_ret USING l_format 
          LET l_ret=l_str CLIPPED,l_str2,l_ret
          IF cl_null(l_ret) THEN
             LET l_ret=l_str CLIPPED,l_str2,p_hram.hram15
          END IF
       ELSE
       	  LET l_ret=l_str CLIPPED,l_str2,p_hram.hram15
       END IF
       	
       LET l_sql=" SELECT substr('",l_ret,"',1,",l_length,") FROM DUAL"
       
       PREPARE hr_gen FROM l_sql
       EXECUTE hr_gen INTO l_ret
       
       IF p_hram.hram11='Y' THEN
          LET g_flag='Y'
       ELSE
       	  LET g_flag='N'
       END IF	  	   
       
       LET g_ret=l_ret
END FUNCTION	 	  	    
	      
	
	
	         
       	
       		  
	
	
	
