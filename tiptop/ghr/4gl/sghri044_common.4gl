# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: sghri044_common.4gl
# Descriptions...: 请假作业公用函数
# Date & Author..: 13/07/25 By yangjian
# Modify ........: No.130912 13/09/12 by wangxh 部门，职位，状态显示名称
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_sql  STRING

FUNCTION sghri044__split(p_hrcd,p_day,p_no)
  DEFINE p_hrcd   RECORD  LIKE hrcd_file.*
  DEFINE p_day    LIKE  type_file.dat          
  DEFINE p_no   DYNAMIC ARRAY OF RECORD  
                no   LIKE  hrcdb_file.hrcdb03,
                day  LIKE  hrcdb_file.hrcdb04,
                unit LIKE  hrcdb_file.hrcdb05,
                ytype LIKE hrcdb_file.hrcdb06
                  END RECORD
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*     
  DEFINE l_hrcdb  RECORD  LIKE hrcdb_file.*
  DEFINE i        LIKE  type_file.num5
  
    WHENEVER ERROR CONTINUE
  
    INITIALIZE l_hrcda.* TO NULL
    LET l_hrcda.hrcda02 = p_hrcd.hrcd10
    LET l_hrcda.hrcda03 = p_hrcd.hrcd01
    LET l_hrcda.hrcda04 = p_hrcd.hrcd09 
    IF p_hrcd.hrcd08 = 'Y' THEN 	 
       LET l_hrcda.hrcda09 = p_hrcd.hrcd06
       LET l_hrcda.hrcda10 = p_hrcd.hrcd07
       #add by zhuzw 20141031 start
       LET l_hrcda.hrcda06 = p_hrcd.hrcd03
       LET l_hrcda.hrcda08 = p_hrcd.hrcd05
       #add by zhuzw 20141031 end 
    ELSE
    	 IF p_hrcd.hrcd02 = p_hrcd.hrcd04 THEN 
          LET l_hrcda.hrcda09 = p_hrcd.hrcd06
          LET l_hrcda.hrcda10 = p_hrcd.hrcd07
          #add by zhuzw 20141031 start
          LET l_hrcda.hrcda06 = p_hrcd.hrcd03
          LET l_hrcda.hrcda08 = p_hrcd.hrcd05
    	 ELSE 
          LET l_hrcda.hrcda09 = NULL
          LET l_hrcda.hrcda10 = NULL
          #add by zhuzw 20141031 start
          LET l_hrcda.hrcda06 = '00:00'
          LET l_hrcda.hrcda08 = '00:00'
          #add by zhuzw 20141031 end 
       END IF 
    END IF 
    LET l_hrcda.hrcda15 = p_hrcd.hrcd12
    LET l_hrcda.hrcda16 = 'N'
    LET l_hrcda.hrcda17 = p_hrcd.hrcd11
#    LET l_hrcda.hrcda18 = p_no
    
    SELECT MAX(hrcda01)+1 INTO l_hrcda.hrcda01 FROM hrcda_file
     WHERE hrcda02 = l_hrcda.hrcda02
    IF cl_null(l_hrcda.hrcda01) THEN LET l_hrcda.hrcda01 = 1 END IF 
    IF p_hrcd.hrcd02 = p_day THEN 
    	 LET l_hrcda.hrcda05 = p_hrcd.hrcd02
    	 LET l_hrcda.hrcda06 = p_hrcd.hrcd03
       IF p_hrcd.hrcd08 = 'Y' THEN 	   	  	
       	 LET l_hrcda.hrcda07 = p_hrcd.hrcd02
       	 LET l_hrcda.hrcda08 = p_hrcd.hrcd05      	      	 	
    	 END IF     	 
    END IF 
    IF p_hrcd.hrcd04 = p_day THEN
    	  IF p_hrcd.hrcd02 = p_day THEN 
    	  	 LET l_hrcda.hrcda05 = p_hrcd.hrcd02
    	  	 LET l_hrcda.hrcda06 = p_hrcd.hrcd03
       	   LET l_hrcda.hrcda07 = p_hrcd.hrcd04
       	   LET l_hrcda.hrcda08 = p_hrcd.hrcd05       	  	 
    	  ELSE
          IF p_hrcd.hrcd08 = 'Y' THEN 	   	  	
    	  	   LET l_hrcda.hrcda05 = p_day
    	  	   LET l_hrcda.hrcda06 = p_hrcd.hrcd03
    	       LET l_hrcda.hrcda07 = p_day
    	       LET l_hrcda.hrcda08 = p_hrcd.hrcd05
    	  	ELSE   
    	  	   LET l_hrcda.hrcda05 = p_day
    	  	   LET l_hrcda.hrcda06 = '00:00'   	  	
    	       LET l_hrcda.hrcda07 = p_day 
    	       LET l_hrcda.hrcda08 = p_hrcd.hrcd05
    	  	END IF   
    	  END IF 
    END IF 
    IF p_day > p_hrcd.hrcd02 AND p_day < p_hrcd.hrcd04 THEN 
       	LET l_hrcda.hrcda05 = p_day
       IF p_hrcd.hrcd08 = 'Y' THEN
          LET l_hrcda.hrcda05 = p_day
          LET l_hrcda.hrcda07 = p_day   
          LET l_hrcda.hrcda06 = p_hrcd.hrcd03
          LET l_hrcda.hrcda08 = p_hrcd.hrcd05
       ELSE 
          LET l_hrcda.hrcda05 = p_day
          LET l_hrcda.hrcda07 = p_day +1 
       	 LET l_hrcda.hrcda06 = '00:00'
       	 LET l_hrcda.hrcda08 = '00:00'
       END IF       	
     #  	LET l_hrcda.hrcda07 = p_day    	
       	LET l_hrcda.hrcda13 = 1 
    END IF    
    #add by zhuzw 20141030 start
    IF cl_null(l_hrcda.hrcda05) AND NOT cl_null(l_hrcda.hrcda07) THEN  
       LET l_hrcda.hrcda05 = l_hrcda.hrcda07
       LET l_hrcda.hrcda06 = '00:00' 
    END IF 
    IF NOT cl_null(l_hrcda.hrcda05) AND  cl_null(l_hrcda.hrcda07) THEN  
       LET l_hrcda.hrcda07 = l_hrcda.hrcda05 +1
       LET l_hrcda.hrcda08 = '00:00' 
    END IF 
    #add by zhuzw 20141030 end 
    IF p_hrcd.hrcdud06='Y' THEN LET l_hrcda.hrcda01 = l_hrcda.hrcda01 -1 ELSE  #冲抵年假时不再添加请假明细
      INSERT INTO hrcda_file VALUES (l_hrcda.*) 
    END IF   
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL s_errmsg('','',"ins hrcda_file err",SQLCA.sqlcode,1)
    END IF  	
    FOR i= 1  TO p_no.getLength()   
       IF p_no[i].no IS NOT NULL THEN  
          INITIALIZE l_hrcdb.* TO NULL
          LET l_hrcdb.hrcdb01 = l_hrcda.hrcda02
          LET l_hrcdb.hrcdb02 = l_hrcda.hrcda01
          LET l_hrcdb.hrcdb03 = p_no[i].no  
          LET l_hrcdb.hrcdb04 = p_no[i].day
          LET l_hrcdb.hrcdb05 = p_no[i].unit  
          LET l_hrcdb.hrcdb06 = p_no[i].ytype  
          INSERT INTO hrcdb_file VALUES (l_hrcdb.*)
          IF SQLCA.sqlcode THEN
          	  LET g_success = 'N'
          	  CALL s_errmsg('','',"ins hrcdb_file err",SQLCA.sqlcode,1)       
          END IF  
       END IF 
    END FOR 
  
END FUNCTION

FUNCTION sghri044__splitWithExpand(p_no)
 DEFINE p_no       LIKE  hrcd_file.hrcd10
 DEFINE l_n,i,j    LIKE  type_file.num5
 DEFINE l_hrcd    RECORD  LIKE hrcd_file.*
 DEFINE l_hrcda   RECORD  LIKE hrcda_file.*

    WHENEVER ERROR CONTINUE
    LET g_success = 'Y'
    DELETE FROM hrcda_file WHERE hrcda02 = p_no
    
    INITIALIZE l_hrcda.* TO NULL
    SELECT * INTO l_hrcd.* FROM hrcd_file WHERE hrcd10 = p_no
    LET l_hrcda.hrcda02 = l_hrcd.hrcd10
    LET l_hrcda.hrcda03 = l_hrcd.hrcd01
    LET l_hrcda.hrcda04 = l_hrcd.hrcd09 
    LET l_hrcda.hrcda09 = l_hrcd.hrcd06
    LET l_hrcda.hrcda10 = l_hrcd.hrcd07
    LET l_hrcda.hrcda15 = l_hrcd.hrcd12
    LET l_hrcda.hrcda16 = 'N'
    LET l_hrcda.hrcda17 = l_hrcd.hrcd11
    IF l_hrcd.hrcd05 <= l_hrcd.hrcd03 THEN 
      LET j = 1   #标记请假跨天 
    END IF 
    
    IF cl_null(l_hrcd.hrcd04) THEN 
       LET l_n = 0
    ELSE   
      LET l_n = l_hrcd.hrcd04 - l_hrcd.hrcd02
      IF l_hrcd.hrcd08 = 'Y' AND j = 1 THEN 
        LET l_n = l_n - 1
      END IF 
    END IF 
    FOR i = 0 TO l_n
      IF i = 0 THEN 
        LET l_hrcda.hrcda05 = l_hrcd.hrcd02
       	LET l_hrcda.hrcda06 = l_hrcd.hrcd03
        LET l_hrcda.hrcda07 = l_hrcd.hrcd02+1 
       	LET l_hrcda.hrcda08 = '00:00'
       	IF l_hrcd.hrcd08 = 'Y' THEN
       	  LET l_hrcda.hrcda08 = l_hrcd.hrcd05
       	  IF j != 1 THEN 
       	    LET l_hrcda.hrcda07 = l_hrcd.hrcd02
       	  END IF 
       	END IF 
      END IF
      IF i > 0 THEN 
        IF l_hrcd.hrcd08 = 'Y' THEN
          LET l_hrcda.hrcda05 = l_hrcd.hrcd02+i
         	LET l_hrcda.hrcda06 = l_hrcd.hrcd03
         	IF j = 1 THEN 
            LET l_hrcda.hrcda07 = l_hrcd.hrcd02+i+1
         	ELSE 
            LET l_hrcda.hrcda07 = l_hrcd.hrcd02+i
          END IF 
          LET l_hrcda.hrcda08 = l_hrcd.hrcd05
        ELSE 
          LET l_hrcda.hrcda05 = l_hrcd.hrcd02+i
         	LET l_hrcda.hrcda06 = '00:00'
          LET l_hrcda.hrcda07 = l_hrcd.hrcd02+i+1
         	LET l_hrcda.hrcda08 = '00:00'
        END IF 
      END IF 
      IF i = l_n THEN 
        LET l_hrcda.hrcda07 = l_hrcd.hrcd04
       	LET l_hrcda.hrcda08 = l_hrcd.hrcd05
      END IF
      LET l_hrcda.hrcda01 = i + 1
      INSERT INTO hrcda_file VALUES(l_hrcda.*)
      IF SQLCA.sqlcode THEN
        ROLLBACK WORK  
        LET g_success = 'N'
        CALL cl_err3("ins","hrcda_file",l_hrcda.hrcda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        EXIT FOR
      ELSE
        MESSAGE 'INSERT O.K'
      END IF  
    END FOR
    
    
    
#    IF l_hrcd.hrcd08 = 'Y' THEN 	 
#       LET l_hrcda.hrcda09 = l_hrcd.hrcd06
#       LET l_hrcda.hrcda10 = l_hrcd.hrcd07
#       #add by zhuzw 20141031 start
#       LET l_hrcda.hrcda06 = l_hrcd.hrcd03
#       LET l_hrcda.hrcda08 = l_hrcd.hrcd05
#       #add by zhuzw 20141031 end 
#    ELSE
#       LET l_hrcda.hrcda09 = NULL
#       LET l_hrcda.hrcda10 = NULL
#       #add by zhuzw 20141031 start
#       LET l_hrcda.hrcda06 = NULL
#       LET l_hrcda.hrcda08 = NULL
#       #add by zhuzw 20141031 end 
#    END IF 
#    LET l_hrcda.hrcda15 = l_hrcd.hrcd12
#    LET l_hrcda.hrcda16 = 'N'
#    LET l_hrcda.hrcda17 = l_hrcd.hrcd11
#    IF cl_null(l_hrcd.hrcd04) THEN 
#       LET l_n = 0
#    ELSE   
#       LET l_n = l_hrcd.hrcd04 - l_hrcd.hrcd02
#    END IF 
#    LET j =1 
#    FOR i = 0 TO l_n 
#       LET l_hrcda.hrcda01 = j
#       #Start
#       IF i = 0 THEN 
#       	  LET l_hrcda.hrcda05 = l_hrcd.hrcd02
#       	  LET l_hrcda.hrcda06 = l_hrcd.hrcd03
#       END IF 
#       #End
#       IF i = l_n THEN 
#       	  IF i = 0 THEN 
#       	  	 LET l_hrcda.hrcda05 = l_hrcd.hrcd02
#       	     LET l_hrcda.hrcda06 = l_hrcd.hrcd03
#       	  ELSE 
#       	     LET l_hrcda.hrcda05 = NULL
#       	     LET l_hrcda.hrcda06 = NULL
#       	  END IF 
#          LET l_hrcda.hrcda07 = l_hrcd.hrcd04
#          LET l_hrcda.hrcda08 = l_hrcd.hrcd05
#       END IF 
#       IF i >0 AND i<l_n THEN 
#       	  LET l_hrcda.hrcda05 = l_hrcd.hrcd02+i
#       	  LET l_hrcda.hrcda06 = NULL
#       	  LET l_hrcda.hrcda07 = l_hrcd.hrcd02+i
#       	  LET l_hrcda.hrcda08 = NULL
#       	  LET l_hrcda.hrcda13 = 1 
#       END IF 
#    #add by zhuzw 20141030 start
#    IF cl_null(l_hrcda.hrcda05) AND NOT cl_null(l_hrcda.hrcda07) THEN  
#       LET l_hrcda.hrcda05 = l_hrcda.hrcda07
#       LET l_hrcda.hrcda06 = '00:00' 
#    END IF 
#    IF NOT cl_null(l_hrcda.hrcda05) AND  cl_null(l_hrcda.hrcda07) THEN  
#       LET l_hrcda.hrcda07 = l_hrcda.hrcda05 +1
#       LET l_hrcda.hrcda06 = '00:00' 
#    END IF 
#    #add by zhuzw 20141030 end 
#       INSERT INTO hrcda_file VALUES(l_hrcda.*)
#       IF SQLCA.sqlcode THEN
#            ROLLBACK WORK  
#            LET g_success = 'N'
#            CALL cl_err3("ins","hrcda_file",l_hrcda.hrcda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
#            EXIT FOR
#       ELSE
#            MESSAGE 'INSERT O.K'
#       END IF 
#       LET j = j+1      
#    END FOR 
END FUNCTION

FUNCTION sghri044__hrat012hratid(p_hrat01)
   DEFINE p_hrat01  LIKE  hrat_file.hrat01
   DEFINE l_hratid  LIKE  hrat_file.hratid
   
   WHENEVER ERROR CONTINUE
   SELECT hratid INTO l_hratid FROM hrat_file
    WHERE hrat01  = p_hrat01
   IF SQLCA.sqlcode THEN 
   	  LET l_hratid = NULL
   END IF 
   RETURN l_hratid
END FUNCTION 

FUNCTION sghri044__hratinfo(p_hrat01)
  DEFINE p_hrat01  LIKE  hrat_file.hrat01
  DEFINE l_hrat02  LIKE  hrat_file.hrat02
  DEFINE l_hrat04  LIKE  hrat_file.hrat04
  DEFINE l_hrat05  LIKE  hrat_file.hrat05
  DEFINE l_hrat25  LIKE  hrat_file.hrat25
  DEFINE l_hrat19  LIKE  hrat_file.hrat19
  
  WHENEVER ERROR CONTINUE

   SELECT hrat02,hrat04,hrat05,hrat25,hrat19
     INTO l_hrat02,l_hrat04,l_hrat05,l_hrat25,l_hrat19
     FROM hrat_file
    WHERE hrat01 = p_hrat01
    #130912 add by wangxh --str--
      IF NOT cl_null(l_hrat04) THEN
         SELECT hrao02 INTO l_hrat04 FROM hrao_file WHERE hrao01=l_hrat04
      END IF
      IF NOT cl_null(l_hrat05) THEN
         SELECT hras04 INTO l_hrat05 FROM hras_file WHERE hras01=l_hrat05
      END IF
      IF NOT cl_null(l_hrat19) THEN
         SELECT hrad03 INTO l_hrat19 FROM hrad_file WHERE hrad02=l_hrat19
      END IF
    #130912 add by wangxh --end--

   RETURN l_hrat02,l_hrat04,l_hrat05,l_hrat25,l_hrat19
END FUNCTION

FUNCTION sghri044_p2_insertday_chk(p_hrcc02,p_hrcc07,l_day,p_qty,p_unit,p_hrcc01)
  DEFINE  p_hrcc02  LIKE  hrcc_file.hrcc02
  DEFINE  p_hrcc07  LIKE  hrcc_file.hrcc07
  DEFINE  p_hrcc01  LIKE  hrcc_file.hrcc01
  DEFINE  p_qty     LIKE  hrcd_file.hrcd06
  DEFINE  p_unit    LIKE  hrcd_file.hrcd07
  DEFINE  l_day     LIKE  type_file.dat
#  DEFINE  l_hrcc    RECORD  LIKE  hrcc_file.*
  DEFINE  l_hrcc    DYNAMIC ARRAY OF RECORD 
             hrcc01  LIKE hrcc_file.hrcc01,
             hrcc02  LIKE hrcc_file.hrcc02,
             hrcc03  LIKE hrcc_file.hrcc03,
             hrcc04  LIKE hrcc_file.hrcc04,
             hrcc05  LIKE hrcc_file.hrcc05,
             hrcc06  LIKE hrcc_file.hrcc06,
             hrcc07  LIKE hrcc_file.hrcc07,
             hrcc08  LIKE hrcc_file.hrcc08,
             hrcc09  LIKE hrcc_file.hrcc09,
             hrcc10  LIKE hrcc_file.hrcc10,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
          END RECORD   
  DEFINE  l_cnt     LIKE  type_file.num5
  DEFINE  l_qty_avl,l_qty_umf LIKE  hrcd_file.hrcd06

   WHENEVER ERROR CONTINUE
   
   LET l_cnt = 1
   LET g_sql = "SELECT hrcc01,hrcc02,hrcc03,hrcc04,hrcc05,hrcc06,hrcc07,hrcc08,hrcc09,hrcc10,0 FROM hrcc_file ",
               " WHERE hrcc02 = '",p_hrcc02,"' ",
               "   AND hrcc07 = '",p_hrcc07,"' ",
               "   AND ? BETWEEN hrcc04 AND hrcc05 ",
               "   AND hrcc09 > 0 "
   IF NOT cl_null(p_hrcc01) THEN
   	  LET g_sql = g_sql||" AND hrcc01 = '",p_hrcc01,"' "
   END IF 
   LET g_sql = g_sql||" ORDER BY hrcc04 "
   PREPARE sghri044_p2_insert_chk_prep FROM g_sql
   DECLARE sghri044_p2_insert_chk_cs CURSOR FOR sghri044_p2_insert_chk_prep
#   EXECUTE sghri044_p2_insert_chk_prep USING l_day INTO l_hrcc.*
#   IF l_hrcc.hrcc02 IS NULL OR l_hrcc.hrcc07 IS NULL OR l_hrcc.hrcc04 IS NULL THEN 
#   	   RETURN FALSE ,l_hrcc
#   ELSE 
#       RETURN TRUE,l_hrcc.*
#   END IF 
   LET l_qty_avl = p_qty
   FOREACH sghri044_p2_insert_chk_cs USING l_day INTO l_hrcc[l_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
      CALL sghri044__umf(l_hrcc[l_cnt].hrcc09,l_hrcc[l_cnt].hrcc10,p_unit) RETURNING l_qty_umf
      IF l_qty_umf >= l_qty_avl THEN 
      	 LET l_hrcc[l_cnt].l_day_umf = l_qty_avl
      	 LET l_hrcc[l_cnt].l_day_unit = p_unit    
      	 LET l_qty_avl = 0
      	 EXIT FOREACH
      ELSE 
         LET l_hrcc[l_cnt].l_day_umf = l_qty_umf
         LET l_hrcc[l_cnt].l_day_unit = p_unit
         LET l_qty_avl = l_qty_avl - l_qty_umf
      END IF 
      LET l_cnt = l_cnt + 1 
   END FOREACH 
#   CALL l_hrcc.deleteElement(l_cnt)
   IF l_qty_avl > 0 THEN 
   	  RETURN FALSE,l_hrcc
   ELSE 
      RETURN TRUE, l_hrcc
   END IF 

END FUNCTION

FUNCTION sghri044_p3_insertday_chk(p_hrch03,l_day,p_qty,p_unit,p_hrch19)
  DEFINE p_hrch03  LIKE hrch_file.hrch03
  DEFINE p_qty  LIKE hrcd_file.hrcd06
  DEFINE p_unit  LIKE hrcd_file.hrcd07
  DEFINE p_hrch19  LIKE hrch_file.hrch19
  DEFINE l_day     LIKE type_file.dat
  DEFINE l_hrcf    RECORD LIKE hrcf_file.*
  DEFINE l_type    LIKE type_file.chr1
  DEFINE l_n,l_cnt       LIKE type_file.num5
  DEFINE  l_hrch    DYNAMIC ARRAY OF RECORD    
             ptype   LIKE type_file.chr1,
             hrch01  LIKE hrch_file.hrch01,
             hrch02  LIKE hrch_file.hrch02,
             hrch03  LIKE hrch_file.hrch03, 
             hrch06  LIKE hrch_file.hrch06,
             hrch17  LIKE hrch_file.hrch17,
             hrch19  LIKE hrch_file.hrch19,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
        END RECORD  
  DEFINE  l_qty_avl,l_qty_umf LIKE  hrcd_file.hrcd06         
   
   WHENEVER ERROR CONTINUE
   
   LET l_cnt = 1 
   SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
    WHERE hrcf01 = hrat03
#      AND hrcf02 = hrat04
      AND hratid = p_hrch03
   IF SQLCA.sqlcode = 100 THEN
      SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
       WHERE hrcf01 = hrat03
         AND hrcf02 = ' '
         AND hratid = p_hrch03
   END IF  
   IF cl_null(l_hrcf.hrcf26) THEN LET l_hrcf.hrcf26 = 'N' END IF
   IF l_hrcf.hrcf26 = 'Y' THEN 
   	  IF p_hrch19 IS NULL THEN 
   	     SELECT COUNT(*) INTO l_n FROM hrch_file WHERE hrch03 = p_hrch03
   	        AND l_day BETWEEN hrch13 AND hrch14
   	        AND hrch15 = hrch17
   	  ELSE 
   	     SELECT COUNT(*) INTO l_n FROM hrch_file WHERE hrch03 = p_hrch03
   	        AND l_day BETWEEN hrch13 AND hrch14
   	        AND hrch15 = hrch17
   	        AND hrch19 = p_hrch19
   	  END IF 
   	  IF l_n = 0 THEN 
   	  	 RETURN FALSE ,NULL,NULL,NULL,NULL,NULL
   	  END IF 
   END IF  
#   LET g_sql = "SELECT '1' type,hrch01,hrch02,hrch03,hrch06/",l_hrcf.hrcf19,",hrch17/",l_hrcf.hrcf19,",hrch19 ",
   LET g_sql = "SELECT '1' ptype,hrch01,hrch02,hrch03,hrch06,hrch17,hrch19 ",
               "  FROM hrch_file ",
               " WHERE hrch03 = '",p_hrch03,"' ", 
               "   AND ? BETWEEN hrch13 AND hrch07 ",
               "   AND hrch06 > 0 "
   IF p_hrch19 IS NOT NULL THEN 
   	  LET g_sql = g_sql||" AND hrch19='",p_hrch19,"' "
   END IF 
   LET g_sql = g_sql,
               " UNION ALL ",
               "SELECT '2' ptype,hrch01,hrch02,hrch03,hrch06,hrch17,hrch19 ",
               "  FROM hrch_file ",
               " WHERE hrch03 = '",p_hrch03,"' ", 
               "   AND ? BETWEEN hrch13 AND hrch14 ",
               "   AND hrch17 > 0 "
   IF p_hrch19 IS NOT NULL THEN 
   	  LET g_sql = g_sql ||" AND hrch19='",p_hrch19,"' "
   END IF
   LET g_sql = g_sql ||" ORDER BY ptype,hrch01"
   PREPARE sghri044_p3_insert_chk_prep FROM g_sql
#   EXECUTE sghri044_p3_insert_chk_prep USING l_day,l_day INTO l_type,l_hrch.hrch01,l_hrch.hrch02,l_hrch.hrch03,l_hrch.hrch19
#   IF l_hrch.hrch01 IS NULL OR l_hrch.hrch02 IS NULL OR l_hrch.hrch03 IS NULL THEN
#   	  RETURN FALSE ,l_type,l_hrch.hrch01,l_hrch.hrch02,l_hrch.hrch03,l_hrch.hrch19
#   ELSE 
#      RETURN TRUE  ,l_type,l_hrch.hrch01,l_hrch.hrch02,l_hrch.hrch03,l_hrch.hrch19
#   END IF 
   DECLARE sghri044_p3_insert_chk_cs CURSOR FOR sghri044_p3_insert_chk_prep
   LET l_qty_avl = p_qty
   FOREACH sghri044_p3_insert_chk_cs USING l_day,l_day INTO l_hrch[l_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      CASE l_hrch[l_cnt].ptype 
         WHEN '1'
            CALL sghri044__umf(l_hrch[l_cnt].hrch06,'001',p_unit) RETURNING l_qty_umf
         WHEN '2'
            CALL sghri044__umf(l_hrch[l_cnt].hrch17,'001',p_unit) RETURNING l_qty_umf
      END CASE 
      IF l_qty_umf >= l_qty_avl THEN 
      	 LET l_hrch[l_cnt].l_day_umf = l_qty_avl
      	 LET l_hrch[l_cnt].l_day_unit = p_unit
      	 LET l_qty_avl = 0
      	 EXIT FOREACH
      ELSE 
         LET l_hrch[l_cnt].l_day_umf = l_qty_umf
         LET l_hrch[l_cnt].l_day_unit = p_unit
         LET l_qty_avl = l_qty_avl - l_qty_umf
      END IF 
      LET l_cnt = l_cnt + 1       
   END FOREACH
#   CALL l_hrch.deleteElement(l_cnt)
   IF l_qty_avl > 0 THEN 
   	  RETURN FALSE,l_hrch
   ELSE 
      RETURN TRUE, l_hrch
   END IF 
END FUNCTION

FUNCTION sghri044_p4_insertday_chk(p_hrci02,l_day,p_qty,p_unit,p_hrci01)
  DEFINE p_hrci02  LIKE  hrci_file.hrci02
  DEFINE p_hrci01  LIKE  hrci_file.hrci01
  DEFINE l_day     LIKE  type_file.dat
  DEFINE p_qty  LIKE hrcd_file.hrcd06
  DEFINE p_unit  LIKE hrcd_file.hrcd07
  DEFINE  l_hrci    DYNAMIC ARRAY OF RECORD    
             hrci01  LIKE hrci_file.hrci01,
             hrci02  LIKE hrci_file.hrci02,
             hrci03  LIKE hrci_file.hrci03,
             hrci04  LIKE hrci_file.hrci04,
             hrci05  LIKE hrci_file.hrci05,
             hrci06  LIKE hrci_file.hrci06,
             hrci07  LIKE hrci_file.hrci07,
             hrci08  LIKE hrci_file.hrci08,
             hrci09  LIKE hrci_file.hrci09,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
        END RECORD  
  DEFINE  l_qty_avl,l_qty_umf LIKE  hrcd_file.hrcd06
  DEFINE  l_cnt      LIKE type_file.num5   
  
  WHENEVER ERROR CONTINUE
  
   LET l_cnt = 1 
   LET g_sql = "SELECT hrci01,hrci02,hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09 FROM hrci_file ",
               " WHERE hrci02 = '",p_hrci02,"' ",
               "   AND ? BETWEEN hrci03 AND hrci10 ",
               "   AND hrci09 > 0 ",
               " ORDER BY hrci03,hrci01 "
   PREPARE sghri044_p4_insert_chk_prep FROM g_sql
#   EXECUTE sghri044_p4_insert_chk_prep USING l_day INTO l_hrci.*
   DECLARE sghri044_p4_insert_chk_cs CURSOR FOR sghri044_p4_insert_chk_prep
   LET l_qty_avl = p_qty
   FOREACH sghri044_p4_insert_chk_cs USING l_day INTO l_hrci[l_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      CALL sghri044__umf(l_hrci[l_cnt].hrci09,'003',p_unit) RETURNING l_qty_umf
      IF l_qty_umf >= l_qty_avl THEN 
      	 LET l_hrci[l_cnt].l_day_umf = l_qty_avl
      	 LET l_hrci[l_cnt].l_day_unit = p_unit
      	 LET l_qty_avl = 0
      	 EXIT FOREACH
      ELSE 
         LET l_hrci[l_cnt].l_day_umf = l_qty_umf
         LET l_hrci[l_cnt].l_day_unit = p_unit
         LET l_qty_avl = l_qty_avl - l_qty_umf
      END IF 
      LET l_cnt = l_cnt + 1 
   END FOREACH 
#   CALL l_hrci.deleteElement(l_cnt)
   IF l_qty_avl > 0 THEN 
   	  RETURN FALSE,l_hrci
   ELSE 
      RETURN TRUE, l_hrci
   END IF 
    
END FUNCTION

#p_hrcc09 --> 源数值
#p_hrcc10 --> 源单位
#p_unit   --> 目标转换单位
#l_day    --> 目标转换后数值
FUNCTION sghri044__umf(p_hrcc09,p_hrcc10,p_unit) 
  DEFINE p_hrcc09,l_day  LIKE  hrcc_file.hrcc09
  DEFINE p_hrcc10,p_unit LIKE  hrcc_file.hrcc10
  
   LET l_day = p_hrcc09
   CASE p_unit
      WHEN "001" #天
         CASE p_hrcc10
            WHEN "001"  LET l_day = p_hrcc09
            WHEN "002"  LET l_day = p_hrcc09 / 2
            WHEN "003"  LET l_day = p_hrcc09 / 8
            WHEN "004"  LET l_day = p_hrcc09 /480
         END CASE 
      WHEN "002"#半天
         CASE p_hrcc10
            WHEN "001"  LET l_day = p_hrcc09 * 2
            WHEN "002"  LET l_day = p_hrcc09 
            WHEN "003"  LET l_day = p_hrcc09 / 4
            WHEN "004"  LET l_day = p_hrcc09 /240
         END CASE 
      WHEN "003"#小时
         CASE p_hrcc10
            WHEN "001"  LET l_day = p_hrcc09 * 8
            WHEN "002"  LET l_day = p_hrcc09 * 4
            WHEN "003"  LET l_day = p_hrcc09 
            WHEN "004"  LET l_day = p_hrcc09 /60
         END CASE 
      WHEN "004"#分钟
         CASE p_hrcc10
            WHEN "001"  LET l_day = p_hrcc09 * 480
            WHEN "002"  LET l_day = p_hrcc09 * 240
            WHEN "003"  LET l_day = p_hrcc09 * 60
            WHEN "004"  LET l_day = p_hrcc09
         END CASE 
   END CASE 
   
#   IF p_unit = '001' THEN 
#   	  IF p_hrcc10 = '001' THEN 
#   	  	 LET l_day = p_hrcc09
#   	  ELSE 
#   	     LET l_day = p_hrcc09 / 2 
#   	  END IF 
#   ELSE 
#      IF p_unit = '002' THEN
#      	 IF p_hrcc10 = '001' THEN 
#      	 	  LET l_day = p_hrcc09 * 2
#      	 ELSE 
#      	    LET l_day = p_hrcc09
#      	 END IF 
#      END IF 
#   END IF  
#   IF p_unit = '003' THEN 
#   	  IF p_hrcc10 = '003' THEN 
#   	  	 LET l_day = p_hrcc09
#   	  ELSE 
#   	     LET l_day = p_hrcc09 / 60 
#   	  END IF 
#   ELSE 
#      IF p_unit = '004' THEN
#      	 IF p_hrcc10 = '003' THEN 
#      	 	  LET l_day = p_hrcc09 * 60
#      	 ELSE 
#      	    LET l_day = p_hrcc09
#      	 END IF 
#      END IF 
#   END IF      
   RETURN l_day

END FUNCTION

