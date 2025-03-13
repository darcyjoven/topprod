# Prog. Version..: '5.30.03-13.04.08(00010)'     #
#
# Pattern name...: sghri006_logic_chk.4gl
# Descriptions...: 人员信息维护作业
# Date & Author..: 13/04/08 By yougs

DATABASE ds

GLOBALS "../../config/top.global" 
DEFINE g_hrat                 RECORD LIKE hrat_file.*
DEFINE g_hrag                 RECORD LIKE hrag_file.*
DEFINE g_hrat01_t             LIKE hrat_file.hrat01
DEFINE g_des                  LIKE type_file.chr100
DEFINE g_sql                  STRING
DEFINE l_hrap06    LIKE hrap_file.hrap06 
 DEFINE l_hrag07      LIKE hrag_file.hrag07

FUNCTION i006_logic_chk_hrat01(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*
 DEFINE l_n    LIKE  type_file.num5
  
   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   SELECT count(*) INTO l_n FROM hrat_file WHERE hrat01 = g_hrat.hrat01
   IF l_n > 0 THEN 
   	 LET g_errno = '-239'
   END IF 
   
   RETURN g_hrat.*
END FUNCTION	

FUNCTION i006_logic_chk_hrat25(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*
 
   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
#   LET g_hrat.hrat66 = g_hrat.hrat25 
   RETURN g_hrat.*   	
END FUNCTION

FUNCTION i006_logic_chk_hrat08(p_hrat,p_hrat01_t)
 DEFINE p_hrat RECORD LIKE hrat_file.*
 DEFINE p_hrat01_t    LIKE hrat_file.hrat01
 DEFINE l_count LIKE type_file.num5

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   LET g_hrat01_t = p_hrat01_t
   IF NOT cl_null(g_hrat.hrat08) THEN
   	 LET l_count = 0                             #重复性
   	 IF g_hrat01_t IS NULL THEN
   	    SELECT COUNT(*) INTO l_count FROM hrat_file
   	     WHERE hrat01 <> g_hrat.hrat01
   	       AND hrat08 = g_hrat.hrat08
   	 ELSE
   	    SELECT COUNT(*) INTO l_count FROM hrat_file
   	     WHERE hrat01 <> g_hrat.hrat01	    
   	       AND hrat01 <> g_hrat01_t
   	       AND hrat08 = g_hrat.hrat08
   	 END IF      
   	 IF l_count > 0 THEN 
   	 	  LET g_errno = 'ghr-030'
   	 END IF	 
   END IF 	
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat15(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*
 DEFINE l_hrat16  LIKE hrat_file.hrat16

   WHENEVER ERROR CONTINUE  
   LET g_errno  = ''
   LET g_hrat.* = p_hrat.*
   LET l_hrat16 = ''
   SELECT YEAR(g_today)-YEAR(g_hrat.hrat15) INTO l_hrat16 FROM DUAL 
   LET g_hrat.hrat16 = l_hrat16   	
   RETURN g_hrat.*
END FUNCTION 

FUNCTION i006_logic_chk_hrat13(p_hrat,p_hrat01_t) 
 DEFINE p_hrat RECORD LIKE hrat_file.*  
 DEFINE p_hrat01_t    LIKE hrat_file.hrat01
# DEFINE l_hrag07      LIKE hrag_file.hrag07
 DEFINE l_count   LIKE  type_file.num5
 DEFINE l_year    LIKE  type_file.num5
 DEFINE l_month   LIKE  type_file.num5 
 DEFINE l_day     LIKE  type_file.num5
 DEFINE l_mod     LIKE  type_file.num5
 DEFINE l_hrat13_18   LIKE type_file.chr1
 DEFINE l_length      LIKE type_file.num5 
 DEFINE l_hrat16      LIKE type_file.num5
 DEFINE l_hrat13_1    LIKE type_file.num5
 DEFINE l_hrat13_2    LIKE type_file.num5
 DEFINE l_hrat13_3    LIKE type_file.num5
 DEFINE l_hrat13_4    LIKE type_file.num5
 DEFINE l_hrat13_5    LIKE type_file.num5
 DEFINE l_hrat13_6    LIKE type_file.num5
 DEFINE l_hrat13_7    LIKE type_file.num5
 DEFINE l_hrat13_8    LIKE type_file.num5
 DEFINE l_hrat13_9    LIKE type_file.num5
 DEFINE l_hrat13_10   LIKE type_file.num5
 DEFINE l_hrat13_11   LIKE type_file.num5
 DEFINE l_hrat13_12   LIKE type_file.num5
 DEFINE l_hrat13_13   LIKE type_file.num5
 DEFINE l_hrat13_14   LIKE type_file.num5
 DEFINE l_hrat13_15   LIKE type_file.num5
 DEFINE l_hrat13_16   LIKE type_file.num5
 DEFINE l_hrat13_17   LIKE type_file.num5 
 DEFINE l_na          LIKE hrat_file.hrat13
 
   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   LET g_hrat01_t = p_hrat01_t
   IF NOT cl_null(g_hrat.hrat13) THEN
   	 IF NOT cl_null(g_hrat.hrat12) THEN  
   	 	  LET l_hrag07 = ''
   	 	  SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag01 = '314' AND hragacti = 'Y' AND hrag06 = g_hrat.hrat12
   	 	  IF l_hrag07 = '大陆身份证' OR l_hrag07 = '大陸身份證' THEN 
   	 	  	 LET l_count = 0                             #重复性

   	 	  	 IF g_hrat01_t IS NULL THEN
   	 	  	    SELECT COUNT(*) INTO l_count FROM hrat_file
   	 	  	     WHERE hrat01 <> g_hrat.hrat01
   	 	  	       AND hrat13 = g_hrat.hrat13
   	 	  	       #AND hrat19 NOT LIKE '3%'
   	 	  	 ELSE
   	 	  	    SELECT COUNT(*) INTO l_count FROM hrat_file
   	 	  	     WHERE hrat01 <> g_hrat.hrat01	    
   	 	  	       AND hrat01 <> g_hrat01_t
   	 	  	       AND hrat13 = g_hrat.hrat13
   	 	  	       #AND hrat19 NOT LIKE '3%'
   	 	  	 END IF      
   	 	  	 IF l_count > 0 THEN 
   	 	  	 	  LET g_errno = 'axm-433'
   	 	  	 	  RETURN g_hrat.*,l_hrag07    #mod by zhangbo130924
   	 	  	 END IF	  
   	 	  	 SELECT LENGTH(g_hrat.hrat13) INTO l_length FROM DUAL    #长度18位
   	 	  	 IF l_length <> 18 OR cl_null(l_length) THEN
   	 	  	 	  LET g_errno = 'ghr-024'
   	 	  	 	  RETURN g_hrat.*,l_hrag07       #mod by zhangbo130924
   	 	  	 END IF
   	 	  	 LET l_count = 0 
#   	 	  	 SELECT COUNT(*) INTO l_count FROM hraj_file
#   	 	  	  WHERE hraj01 = substr(g_hrat.hrat13,1,6)
#   	 	  	 IF l_count = 0 OR cl_null(l_count) THEN
#   	 	  	 	  LET g_errno = 'ghr-028'
#   	 	  	 	  RETURN g_hrat.*,l_hrag07       #mod by zhangbo130924
#   	 	  	 END IF	  
   	 	  	 LET l_year = ''
   	 	  	 LET l_year = g_hrat.hrat13[7,10]
   	 	  	 IF l_year > YEAR(g_today) OR l_year <1 OR cl_null(l_year) THEN
   	 	  	 	  LET g_errno = 'ghr-025'
   	 	  	 	  RETURN g_hrat.*,l_hrag07       #mod by zhangbo130924
   	 	  	 END IF
   	 	  	 LET l_month = ''
   	 	  	 LET l_month = g_hrat.hrat13[11,12]
   	 	  	 IF l_month > 12 OR l_month < 1 OR cl_null(l_month) THEN
   	 	  	 	  LET g_errno = 'ghr-026'          
   	 	  	 	  RETURN g_hrat.*,l_hrag07       #mod by zhangbo130924
   	 	  	 END IF
   	 	  	 LET l_day = ''
   	 	  	 LET l_day = g_hrat.hrat13[13,14]
   	 	  	 IF l_month = '01' OR l_month = '03' OR l_month = '05' OR l_month = '07' OR l_month = '08' OR l_month = '10' OR l_month = '12' THEN
   	 	  	    IF l_day > 31 OR l_day < 1 THEN
   	 	  	    	  LET g_errno = 'ghr-027'
   	 	  	    	  RETURN g_hrat.*,l_hrag07       #mod by zhangbo130924
   	 	  	    END IF
   	 	  	 END IF                                                   #小月
   	 	  	 IF l_month = '04' OR l_month = '05' OR l_month = '09' OR l_month = '11' THEN
   	 	  	    IF l_day > 30 OR l_day < 1 THEN
   	 	  	    	  LET g_errno = 'ghr-027'
   	 	  	    	  RETURN g_hrat.*,l_hrag07       #mod by zhangbo130924
   	 	  	    END IF
   	 	  	 END IF  
   	 	  	 IF l_month = '02' THEN                                   #2月
   	 	  	    IF l_year mod 4 <> 0 OR (l_year mod 4 = 0 AND l_year mod 100 = 0) THEN    #2月非闰年
   	 	  	    	 IF l_day > 28 OR l_day < 1 THEN
   	 	  	    	    LET g_errno = 'ghr-027'
   	 	  	    	    RETURN g_hrat.*,l_hrag07     #mod by zhangbo130924
   	 	  	       END IF
   	 	  	    ELSE
   	 	  	    	 IF l_day > 29 OR l_day < 1 THEN                                         #2月闰年
   	 	  	    	    LET g_errno = 'ghr-027'
   	 	  	    	    RETURN g_hrat.*,l_hrag07     #mod by zhangbo130924
   	 	  	       END IF
   	 	  	    END IF   	   	
   	 	  	 END IF  		  
   	 	  	 
   	 	  	 LET l_na = g_hrat.hrat13[1,4],'00'
   	 	  	 #CALL cl_replace_str(l_na,' ','') RETURNING l_na
   	 	  	 #add by nihuan
   	 	  	 LET l_hrat13_1  = g_hrat.hrat13[1,1]
   	 	  	 LET l_hrat13_2  = g_hrat.hrat13[2,2]
   	 	  	 LET l_hrat13_3  = g_hrat.hrat13[3,3]
   	 	  	 LET l_hrat13_4  = g_hrat.hrat13[4,4]
   	 	  	 LET l_hrat13_5  = g_hrat.hrat13[5,5]
   	 	  	 LET l_hrat13_6  = g_hrat.hrat13[6,6]
   	 	  	 LET l_hrat13_7  = g_hrat.hrat13[7,7]
   	 	  	 LET l_hrat13_8  = g_hrat.hrat13[8,8]
   	 	  	 LET l_hrat13_9  = g_hrat.hrat13[9,9]
   	 	  	 LET l_hrat13_10 = g_hrat.hrat13[10,10]
   	 	  	 LET l_hrat13_11 = g_hrat.hrat13[11,11]
   	 	  	 LET l_hrat13_12 = g_hrat.hrat13[12,12]
   	 	  	 LET l_hrat13_13 = g_hrat.hrat13[13,13]
   	 	  	 LET l_hrat13_14 = g_hrat.hrat13[14,14]
   	 	  	 LET l_hrat13_15 = g_hrat.hrat13[15,15]
   	 	  	 LET l_hrat13_16 = g_hrat.hrat13[16,16]
   	 	  	 LET l_hrat13_17 = g_hrat.hrat13[17,17] 
   	 	  	 SELECT mod((l_hrat13_1*7+l_hrat13_2*9+l_hrat13_3*10+l_hrat13_4*5+l_hrat13_5*8+l_hrat13_6*4
   	 	  	 +l_hrat13_7*2+l_hrat13_8*1+l_hrat13_9*6+l_hrat13_10*3+l_hrat13_11*7+l_hrat13_12*9
   	 	  	 +l_hrat13_13*10+l_hrat13_14*5+l_hrat13_15*8+l_hrat13_16*4+l_hrat13_17*2),11) INTO l_mod FROM DUAL
   	 	  	 IF l_mod = 0 THEN
   	 	  	 	  LET l_hrat13_18 = '1'
   	 	  	 END IF		 
   	 	  	 IF l_mod = 1 THEN
   	 	  	 	  LET l_hrat13_18 = '0'
   	 	  	 END IF
   	 	  	 IF l_mod = 2 THEN
   	 	  	 	  LET l_hrat13_18 = 'X'
   	 	  	 END IF	
   	 	  	 IF l_mod > 2 THEN		 
   	 	  	 	  LET l_hrat13_18 = 12-l_mod
   	 	  	 END IF
   	 	  	 IF l_hrat13_18 <> g_hrat.hrat13[18,18] THEN      
   	 	   	 	  LET g_errno = 'ghr-029'
   	 	   	 	  RETURN g_hrat.*,l_hrag07
   	 	  	 END IF 
   	 	     CALL cl_set_comp_entry("hrat15,hrat17,hrat18",FALSE)
   	 	     SELECT to_date(substr(g_hrat.hrat13,7,4)||'/'||substr(g_hrat.hrat13,11,2)||'/'||substr(g_hrat.hrat13,13,2),'yy/mm/dd') INTO g_hrat.hrat15 FROM DUAL
   	 	     LET l_hrat16 = ''
   	 	     SELECT YEAR(g_today)-l_year INTO l_hrat16 FROM DUAL
   	 	     LET g_hrat.hrat16 = l_hrat16 
   	 	     LET l_hrag07 = ''
   	 	     IF l_hrat13_17 MOD 2 =1 THEN
   	 	     	  LET l_hrag07 = '男'
                          LET g_hrat.hrat17='001'
   	 	     ELSE
   	 	     	  LET l_hrag07 = '女'
                          LET g_hrat.hrat17='002'
   	 	     END IF
#   	 	     SELECT hrag06 INTO g_hrat.hrat17 FROM hrag_file WHERE hragacti = 'Y' AND hrag07 = '男' AND hrag01 = '333'
#mark by hourf  2013/07/04
   	 	     #SELECT hraj02 INTO g_hrat.hrat18 FROM hraj_file WHERE hraj01 = substr(g_hrat.hrat13,1,6) AND hrajacti = 'Y'
   	 	     SELECT COUNT(*) INTO l_count FROM hraj_file
   	 	  	  WHERE hraj01 = substr(g_hrat.hrat13,1,6)
   	 	  	 IF l_count = 0 OR cl_null(l_count) THEN
   	 	  	 	SELECT COUNT(*) INTO l_count FROM hraj_file
   	 	  	  WHERE hraj01 = l_na
   	 	  	  IF l_count = 0 OR cl_null(l_count) THEN
   	 	  	 	  LET g_errno = 'ghr-028'
   	 	  	 	  RETURN g_hrat.*,l_hrag07       #mod by zhangbo130924
   	 	  	 	END IF 
   	 	  	 END IF	   	 	     
   	 	     SELECT hraj02 INTO g_hrat.hrat18 FROM hraj_file WHERE hraj01 = l_na AND hrajacti = 'Y'
   	 	     IF cl_null(g_hrat.hrat18) THEN
   	 	     	SELECT hraj02 INTO g_hrat.hrat18 FROM hraj_file WHERE hraj01 = substr(g_hrat.hrat13,1,6) AND hrajacti = 'Y' 
   	 	     END IF 
   	 	     RETURN g_hrat.*,l_hrag07
                  ELSE                                                        #add by zhangbo130924
                     CALL cl_set_comp_entry("hrat15,hrat17,hrat18",TRUE)      #add by zhangbo130924
   	 	  END IF
   	 END IF
   END IF 	
   
   RETURN g_hrat.*,l_hrag07      #mod by zhangbo130924 	
END FUNCTION
          
          
FUNCTION i006_logic_chk_hrat03(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*
 
   WHENEVER ERROR CONTINUE   
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat03) THEN
      CALL i006_hrat03(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN  
      	 RETURN g_hrat.*
      END IF
      IF NOT cl_null(g_hrat.hrat04) THEN
         CALL i006_hrat04(g_hrat.*) RETURNING g_des
         IF NOT cl_null(g_errno) THEN
         	   RETURN g_hrat.*
         END IF	
      END IF   	
   END IF 
   
   RETURN g_hrat.*
END FUNCTION  

FUNCTION i006_logic_chk_hrat94(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*
 
   WHENEVER ERROR CONTINUE   
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat94) THEN
      CALL i006_hrat94(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN  
      	 RETURN g_hrat.*
      END IF
#      IF NOT cl_null(g_hrat.hrat04) THEN
#         CALL i006_hrat04(g_hrat.*) RETURNING g_des
#         IF NOT cl_null(g_errno) THEN
#         	   RETURN g_hrat.*
#         END IF	
#      END IF   	
   END IF 
   
   RETURN g_hrat.*
END FUNCTION        
          

FUNCTION i006_logic_chk_hrat04(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat04) THEN
      CALL i006_hrat04(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      IF NOT cl_null(g_hrat.hrat05) THEN
         CALL i006_hrat05(g_hrat.*) RETURNING g_des
         IF NOT cl_null(g_errno) THEN
         	  RETURN g_hrat.*
         END IF	
      END IF
   END IF  
   RETURN g_hrat.*
END FUNCTION          
          
FUNCTION i006_logic_chk_hrat05(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE       
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat05) THEN
      CALL i006_hrat05(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
   END IF 

   RETURN g_hrat.*
END FUNCTION  

FUNCTION i006_logic_chk_hrat06(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat06) THEN
      CALL i006_hrat06(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
   END IF
   RETURN g_hrat.*           
END FUNCTION          

FUNCTION i006_logic_chk_hrat19(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat19) THEN
      CALL i006_hrat19(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
   END IF
   RETURN g_hrat.*           
END FUNCTION           

FUNCTION i006_logic_chk_hrat40(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat40) THEN
      CALL i006_hrat40(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
   END IF
   RETURN g_hrat.*           
END FUNCTION  

FUNCTION i006_logic_chk_hrat42(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat42) THEN
      CALL i006_hrat42(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
   END IF
   RETURN g_hrat.*           
END FUNCTION  

FUNCTION i006_logic_chk_hrat52(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat52) THEN
      CALL i006_hrat52(g_hrat.*) RETURNING g_des
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
   END IF
   RETURN g_hrat.*           
END FUNCTION  

FUNCTION i006_logic_chk_hrat64(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE 
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat64) THEN
      CALL i006_hrat64(g_hrat.*)
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
   END IF
   RETURN g_hrat.*           
END FUNCTION  

FUNCTION i006_logic_chk_hrat12(p_hrat)  
 DEFINE p_hrat RECORD LIKE hrat_file.*  
 
   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat12) THEN
   	  CALL s_code('314',g_hrat.hrat12) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat12_name
      IF g_hrag.hrag07 = '大陆身份证' OR g_hrag.hrag07 = '大陸身份證' THEN
      	  CALL cl_set_comp_required('hrat13',TRUE)
      ELSE
      	  CALL cl_set_comp_required('hrat13',FALSE)
      END IF	  
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat17(p_hrat)    
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat17) THEN
   	  CALL s_code('333',g_hrat.hrat17) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat17_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat20(p_hrat)  
 DEFINE p_hrat RECORD LIKE hrat_file.*  

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat20) THEN
   	  CALL s_code('313',g_hrat.hrat20) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat20_name
   END IF 
   RETURN g_hrat.*
END FUNCTION
#FUN-151124 wangjya
FUNCTION i006_logic_chk_hrat91(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat91) THEN
   	  CALL s_code('345',g_hrat.hrat91) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat91_name
   END IF
   RETURN g_hrat.*
END FUNCTION
#FUN-151124 wangjya

#FUN-151201 wangjya
FUNCTION i006_logic_chk_hrat93(p_hrat)
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat93) THEN
   	  CALL s_code('346',g_hrat.hrat93) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat93_name
   END IF
   RETURN g_hrat.*
END FUNCTION
#FUN-151201 wangjya

FUNCTION i006_logic_chk_hrat21(p_hrat)  
 DEFINE p_hrat RECORD LIKE hrat_file.*  

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat21) THEN
   	  CALL s_code('337',g_hrat.hrat21) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat21_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat22(p_hrat)    
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat22) THEN
   	  CALL s_code('317',g_hrat.hrat22) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat22_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat24(p_hrat)    
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat24) THEN
   	  CALL s_code('334',g_hrat.hrat24) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat24_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat28(p_hrat)  
 DEFINE p_hrat RECORD LIKE hrat_file.*  

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat28) THEN
   	  CALL s_code('302',g_hrat.hrat28) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat28_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat29(p_hrat)   
 DEFINE p_hrat RECORD LIKE hrat_file.* 

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat29) THEN
   	  CALL s_code('301',g_hrat.hrat29) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat29_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat30(p_hrat)   
 DEFINE p_hrat RECORD LIKE hrat_file.* 

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat30) THEN
   	  CALL s_code('321',g_hrat.hrat30) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat30_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat34(p_hrat)   
 DEFINE p_hrat RECORD LIKE hrat_file.* 

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat34) THEN
   	  CALL s_code('320',g_hrat.hrat34) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat34_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat41(p_hrat)    
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat41) THEN
   	  CALL s_code('325',g_hrat.hrat41) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat41_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat68(p_hrat)    
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat68) THEN
   	  CALL s_code('340',g_hrat.hrat68) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat68_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat66(p_hrat)    
 DEFINE p_hrat RECORD LIKE hrat_file.*

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat66) THEN
   	  CALL s_code('326',g_hrat.hrat66) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat66_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat43(p_hrat)   
 DEFINE p_hrat RECORD LIKE hrat_file.* 

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat43) THEN
   	  CALL s_code('319',g_hrat.hrat43) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat43_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_logic_chk_hrat73(p_hrat)   
 DEFINE p_hrat RECORD LIKE hrat_file.* 

   WHENEVER ERROR CONTINUE  
   LET g_errno = ''
   LET g_hrat.* = p_hrat.*
   IF NOT cl_null(g_hrat.hrat73) THEN
   	  CALL s_code('341',g_hrat.hrat73) RETURNING g_hrag.*
      IF NOT cl_null(g_errno) THEN
      	 RETURN g_hrat.*
      END IF
      DISPLAY g_hrag.hrag07 TO hrat73_name
   END IF 
   RETURN g_hrat.*
END FUNCTION

FUNCTION i006_hrat03(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hraa12    LIKE hraa_file.hraa12 
   DEFINE l_hraaacti  LIKE hraa_file.hraaacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hraa12,hraaacti FROM hraa_file ",
               " WHERE hraa01= ? "
   PREPARE hrat03_prep FROM g_sql
   EXECUTE hrat03_prep USING g_hrat.hrat03 INTO l_hraa12,l_hraaacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                LET l_hraa12=NULL
  
       WHEN l_hraaacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hraa12 TO hrat03_name 
   END IF 
   RETURN l_hraa12
END FUNCTION

FUNCTION i006_hrat87_1(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrao02    LIKE hrao_file.hrao02 
   DEFINE l_hraoacti  LIKE hrao_file.hraoacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrao02,hraoacti FROM hrao_file ",
               " WHERE hrao01= ? "
   PREPARE hrat87_prep FROM g_sql
   EXECUTE hrat87_prep USING g_hrat.hrat87 INTO l_hrao02,l_hraoacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                LET l_hrao02=NULL
  
       WHEN l_hraoacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrao02 TO hrat87_name 
   END IF 
   RETURN l_hrao02
END FUNCTION

FUNCTION i006_hrat88_1(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrao02    LIKE hrao_file.hrao02 
   DEFINE l_hraoacti  LIKE hrao_file.hraoacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrao02,hraoacti FROM hrao_file ",
               " WHERE hrao01= ? "
   PREPARE hrat88_prep FROM g_sql
   EXECUTE hrat88_prep USING g_hrat.hrat88 INTO l_hrao02,l_hraoacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                LET l_hrao02=NULL
  
       WHEN l_hraoacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrao02 TO hrat88_name 
   END IF 
   RETURN l_hrao02
END FUNCTION

FUNCTION i006_hrat94(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrao02    LIKE hrao_file.hrao02 
   DEFINE l_hraoacti  LIKE hrao_file.hraoacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrao02,hraoacti FROM hrao_file ",
               " WHERE hrao01= ? "
   PREPARE hrat94_prep FROM g_sql
   EXECUTE hrat94_prep USING g_hrat.hrat94 INTO l_hrao02,l_hraoacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                LET l_hrao02=NULL
  
       WHEN l_hraoacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrao02 TO hrat94_name 
   END IF 
   RETURN l_hrao02
END FUNCTION
	
FUNCTION i006_hrat04(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrao02    LIKE hrao_file.hrao02 
   DEFINE l_hraoacti  LIKE hrao_file.hraoacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrao02,hraoacti FROM hrao_file ",
               " WHERE hrao01=? AND hrao00 = ? "
   PREPARE hrat04_prep FROM g_sql
   EXECUTE hrat04_prep USING g_hrat.hrat04,g_hrat.hrat03 INTO l_hrao02,l_hraoacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-060'
                                LET l_hrao02=NULL
  
       WHEN l_hraoacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrao02 TO hrat04_name 
   END IF 
   RETURN l_hrao02
END FUNCTION
		
FUNCTION i006_hrat05(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrap06    LIKE hrap_file.hrap06 
   DEFINE l_hrapacti  LIKE hrap_file.hrapacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrap06,hrapacti  FROM hrap_file ",
               " WHERE hrap05=? AND hrap01 =? "
   PREPARE hrat05_prep FROM g_sql
   IF NOT cl_null(g_hrat.hrat88) THEN 
      EXECUTE hrat05_prep USING g_hrat.hrat05,g_hrat.hrat88 INTO l_hrap06,l_hrapacti
   ELSE 
       IF NOT cl_null(g_hrat.hrat87) THEN 
          EXECUTE hrat05_prep USING g_hrat.hrat05,g_hrat.hrat87 INTO l_hrap06,l_hrapacti
       ELSE 
          IF NOT cl_null(g_hrat.hrat04) THEN 
             EXECUTE hrat05_prep USING g_hrat.hrat05,g_hrat.hrat04 INTO l_hrap06,l_hrapacti
          ELSE        
          END IF
       END IF
   END IF 
   
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-010'
                                LET l_hrap06=NULL
  
       WHEN l_hrapacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrap06 TO hrat05_name 
   END IF 
   RETURN l_hrap06
END FUNCTION
	
FUNCTION i006_hrat06(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrat02    LIKE hrat_file.hrat02 
   DEFINE l_hratacti  LIKE hrat_file.hratacti 
 
   WHENEVER ERROR CONTINUE 
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrat02,hratacti FROM hrat_file ",
               " WHERE hrat01=?  "
   PREPARE hrat06_prep FROM g_sql
   EXECUTE hrat06_prep USING g_hrat.hrat06 INTO l_hrat02,l_hratacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-031'
                                LET l_hrat02=NULL
  
       WHEN l_hratacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrat02 TO hrat06_name
   END IF  
   RETURN l_hrat02
END FUNCTION

FUNCTION i006_hrat19(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrad03    LIKE hrad_file.hrad03 
   DEFINE l_hradacti  LIKE hrad_file.hradacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrad03,hradacti  FROM hrad_file ",
               " WHERE hrad02=? AND rownum = 1 "
   PREPARE hrat19_prep FROM g_sql
   EXECUTE hrat19_prep USING g_hrat.hrat19 INTO l_hrad03,l_hradacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-032'
                                LET l_hrad03=NULL
  
       WHEN l_hradacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrad03 TO hrat19_name 
   END IF 
   RETURN l_hrad03
END FUNCTION
	
FUNCTION i006_hrat40(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hraf02    LIKE hraf_file.hraf02  

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hraf02  FROM hraf_file ",
               " WHERE hraf01= ? "
   PREPARE hrat40_prep FROM g_sql
   EXECUTE hrat40_prep USING g_hrat.hrat40 INTO l_hraf02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-255'
                                LET l_hraf02=NULL 
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hraf02 TO hrat40_name 
   END IF 
   RETURN l_hraf02
END FUNCTION
			
FUNCTION i006_hrat42(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrai04    LIKE hrai_file.hrai04

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrai04 FROM hrai_file  ",
               " WHERE hrai03=? AND hraiacti='Y' "
   PREPARE hrat42_prep FROM g_sql
   EXECUTE hrat42_prep USING g_hrat.hrat42 INTO l_hrai04
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-006'
                                LET l_hrai04=NULL 
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrai04 TO hrat42_name 
   END IF 
   RETURN l_hrai04
END FUNCTION
	
FUNCTION i006_hrat52(p_hrat) 
 DEFINE p_hrat RECORD LIKE hrat_file.*
   DEFINE l_hrat02    LIKE hrat_file.hrat02 
   DEFINE l_hratacti  LIKE hrat_file.hratacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrat02,hratacti FROM hrat_file ",
               " WHERE hrat01=? "
   PREPARE hrat52_prep FROM g_sql
   EXECUTE hrat52_prep USING g_hrat.hrat52 INTO l_hrat02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-031'
                                LET l_hrat02=NULL
  
       WHEN l_hratacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrat02 TO hrat52_name 
   END IF 
   RETURN l_hrat02
END FUNCTION	
	
FUNCTION i006_hrat64(p_hrat)  
 DEFINE p_hrat RECORD LIKE hrat_file.*
 DEFINE l_hrasacti    LIKE hras_file.hrasacti
 DEFINE l_hraracti    LIKE hrar_file.hraracti 

   WHENEVER ERROR CONTINUE 
   LET g_errno=''
   LET g_hrat.* = p_hrat.*
   LET g_sql = "SELECT hrasacti,hraracti FROM hras_file,hrar_file ",
               " WHERE hras01 = ? ",
               "   AND hrar03 = hras03 ",
               "   AND hrar06 = ? "
   PREPARE hrat64_prep FROM g_sql
   EXECUTE hrat64_prep USING g_hrat.hrat05,g_hrat.hrat64 INTO l_hrasacti,l_hraracti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-015' 
       WHEN l_hrasacti = 'N'    LET g_errno='9028'  
       WHEN l_hraracti = 'N'    LET g_errno='9028'                                              
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE 
END FUNCTION	

FUNCTION i006_logic_default(p_cmd,p_hrat)
  DEFINE p_cmd      LIKE  type_file.chr1
  DEFINE p_hrat     RECORD LIKE hrat_file.*
  DEFINE l_hrat08   LIKE type_file.num10 
  DEFINE l_hratid   LIKE hrat_file.hratid 
  
    LET g_hrat.* = p_hrat.*
    CASE p_cmd 
       WHEN 'A'
          LET g_hrat.hratuser = g_user 
          LET g_hrat.hratgrup = g_grup               #使用者所屬群        
          LET g_hrat.hratoriu = g_user 
          LET g_hrat.hratorig = g_grup 
          LET g_hrat.hratdate = g_today
          LET g_hrat.hratacti = 'Y' 
          LET g_hrat.hratconf = 'N'
          LET g_hrat.hrat07 = 'N' 
          LET g_hrat.hrat09 = 'N'
          LET g_hrat.hrat11 = 'N'
          LET g_hrat.hrat33 = 'N'
          LET g_hrat.hrat53 = 'N'
          LET g_hrat.hrat54 = 'N'
          LET g_hrat.hrat58 = '1'
          LET g_hrat.hrat37 = 0
          LET g_hrat.hrat39 = 0
          LET g_hrat.hrat25 = g_today
#          LET g_hrat.hrat66 = g_hrat.hrat25
          LET g_hrat.hrat31 = '88888888'
          LET g_hrat.hrat28 = 'CN'
          LET g_hrat.hrat29 = '000'
          SELECT MAX(to_number(hrat08)+1) INTO l_hrat08 FROM hrat_file 
          IF cl_null(l_hrat08) THEN
             LET l_hrat08 = 1
          END IF	
          SELECT to_char(l_hrat08) INTO l_hrat08 FROM DUAL	
          LET g_hrat.hrat08 = l_hrat08
       WHEN 'B'
          LET l_hratid = ''
          SELECT MAX(to_number(hratid)+1) INTO l_hratid FROM hrat_file 
          IF cl_null(l_hratid) THEN
             LET l_hratid = 1
          END IF
          SELECT to_char(l_hratid,'fm0000000000') INTO l_hratid FROM DUAL	
          LET g_hrat.hratid = l_hratid  
       OTHERWISE 
    END CASE 
    RETURN g_hrat.*
END FUNCTION

