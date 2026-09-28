# Prog. Version..: '5.30.04-08.10.22(00000)'     #
#
# Pattern name...: cghrp001.4gl
# Descriptions...: 
# Date & Author..: 20141011 zhuzw


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_wc      STRING
DEFINE  g_sql     STRING
DEFINE g_cnt                LIKE type_file.num5
DEFINE g_argv1              LIKE hrao_file.hrao01
DEFINE g_hrao01             LIKE hrao_file.hrao01
DEFINE g_flag               LIKE type_file.chr1
MAIN

    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   LET g_flag = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
   WHENEVER ERROR CALL cl_err_msg_log
   IF g_bgjob = 'N' OR cl_null(g_bgjob) THEN
      EXIT PROGRAM 
   END IF 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   CALL p001()    
END MAIN
FUNCTION p001()
DEFINE l_sql   STRING
DEFINE l_n     LIKE type_file.num5
DEFINE l_hrbh RECORD LIKE hrbh_file.*
DEFINE l_hraz RECORD LIKE hraz_file.*
DEFINE l_hrbe01  LIKE hrbe_file.hrbe01
DEFINE l_hrat04  LIKE hrat_file.hrat04
DEFINE l_hrat05  LIKE hrat_file.hrat05
DEFINE l_hrat09  LIKE hrat_file.hrat09
      IF g_flag = '1' THEN #更新离退信息
         SELECT COUNT(*) INTO l_n FROM hrbh_file 
#20141229 add by yinbq for 调整数据查询条件
 #         WHERE hrbh11 = to_date('",g_today,"','yyyy/mm/dd')  
          WHERE hrbh11 = g_today  
#20141229 add by yinbq for 调整数据查询条件
         IF l_n >0 THEN  #更新离退信息
            LET l_sql = " SELECT * from hrbh_file where hrbh11 = to_date('",g_today,"','yyyy-mm-dd')"
            PREPARE p001_q1 FROM l_sql
            DECLARE p_001_s1 CURSOR FOR p001_q1
            FOREACH p_001_s1 INTO l_hrbh.*
               UPDATE hrat_file SET hrat07='N',hrat19=l_hrbh.hrbh06,hrat77 = l_hrbh.hrbh11 WHERE hratid=l_hrbh.hrbh01
               SELECT hrbe01 INTO l_hrbe01 FROM hrbe_file WHERE hrbe03='001'
               UPDATE hrbf_file SET hrbf09=l_hrbh.hrbh04 WHERE hrbf02=l_hrbh.hrbh01 AND hrbf04=l_hrbe01 AND l_hrbh.hrbh04>hrbf08 AND l_hrbh.hrbh04<hrbf09
            END FOREACH  
         END IF 
      END IF 
      IF g_flag = '2' THEN  #更新调职信息
         SELECT COUNT(*) INTO l_n FROM hraz_file 
#20141229 add by yinbq for 调整数据查询条件
  #        WHERE hraz05 = to_date('",g_today,"','yyyy/mm/dd') 
          WHERE hraz05 = g_today 
#20141229 add by yinbq for 调整数据查询条件
         IF l_n >0 THEN #更新调职信息
            LET l_sql = " SELECT * from hraz_file where hraz05 = to_date('",g_today,"','yyyy-mm-dd')"
            PREPARE p001_q2 FROM l_sql
            DECLARE p_001_s2 CURSOR FOR p001_q2
            FOREACH p_001_s2 INTO l_hraz.*
               SELECT hrat04,hrat05,hrat09 INTO l_hrat04,l_hrat05,l_hrat09 FROM hrat_file
                WHERE hratid=l_hraz.hraz03         
                UPDATE hrat_file SET hrat01=l_hraz.hraz32,
                           hrat03=l_hraz.hraz31,
                           hrat04=l_hraz.hraz08,
                           hrat05=l_hraz.hraz10,
                           hrat64=l_hraz.hraz41,
                           hrat06=l_hraz.hraz34,
                           hrat40=l_hraz.hraz14,
                           hrat41=l_hraz.hraz16,
                        #   hrat42=l_hraz.hraz12, #add by zhuzw 20150430
                           hrat09=l_hraz.hraz44,
                           hrat21=l_hraz.hraz39
                     WHERE hratid=l_hraz.hraz03
         	    IF l_hraz.hraz44 = 'Y' THEN 
         	       UPDATE hrap_file 
                     SET hrap11 = hrap11 -1 ,
                         hrap12 = hrap12 -1 
                  WHERE hrap01 = l_hraz.hraz07
                    AND hrap05 = l_hraz.hraz09
                  UPDATE hrap_file 
                     SET 
                         hrap14 = hrap14 -1 ,
                         hrap15 = hrap15 -1
                  WHERE hrap01 = l_hraz.hraz07
               ELSE 
                  UPDATE hrap_file 
                     SET hrap12 = hrap12 -1        	             
                  WHERE hrap01 = l_hraz.hraz07
                    AND hrap05 = l_hraz.hraz09                	    	          
                  UPDATE hrap_file 
                     SET 
                         hrap15 = hrap15 -1
                  WHERE hrap01 = l_hraz.hraz07	 
               END IF 
               IF l_hrat09 = 'Y' THEN 
                  UPDATE hrap_file 
                     SET hrap11 = hrap11 +1 ,
                         hrap12 = hrap12 +1 
                  WHERE hrap01 = l_hrat04
                    AND hrap05 = l_hrat05   
                  UPDATE hrap_file 
                     SET 
                         hrap14 = hrap14 +1 ,
                         hrap15 = hrap15 +1
                  WHERE hrap01 = l_hrat04
               ELSE 
                  UPDATE hrap_file 
                     SET hrap12 = hrap12 +1        	             
                  WHERE hrap01 = l_hrat04
                    AND hrap05 = l_hrat05               	    	          
                  UPDATE hrap_file 
                     SET 
                         hrap15 = hrap15 +1
                  WHERE hrap01 = l_hrat04             	    	          
               END IF                     
            END FOREACH  
         END IF 
      END IF 
END FUNCTION 

