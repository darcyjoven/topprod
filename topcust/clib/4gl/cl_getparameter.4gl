# Prog. Version..: '5.10.07-09.04.27(00009)'     #
#
# Program name...: cl_getscmparameter.4gl
# Descriptions...: 获取参数设置  是否开启SCM对接
# Date & Author..: By shawn 18010101 
# Modify.........: 

DATABASE ds

#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"

FUNCTION cl_getscmparameter()
DEFINE  l_y   LIKE type_file.chr1 
DEFINE l_cnt   LIKE type_file.num5 

LET l_y = 'N' 

SELECT tc_zsa02 INTO l_y FROM tc_zsa_file WHERE tc_zsa01='0' 
#PREPARE p_pre FOR l_sql 
#EXECUTE p_pre INTO l_y
DISPLAY "-----------tc_zsa02-------------begin--------"
DISPLAY "tc_zsa02:",l_y
DISPLAY "-----------tc_zsa02--------------end-------"
IF status THEN
   return false 
ELSE
   IF l_y = 'Y' AND (g_prog[1,3] = 'apm' OR g_prog[1,3] = 'aqc') THEN 
   #IF l_y = 'Y' THEN 
   	RETURN TRUE
   END IF 
END IF  
{IF l_y= 'Y' THEN 
   SELECT count(*) INTO l_cnt  FROM tc_zsb_file WHERE tc_zsb01=g_plant AND tc_zsb02 = g_prog AND tc_zsb03='N'
   IF cl_null(l_cnt) THEN LET l_cnt = 0  END IF 
   IF l_cnt > 0 THEN
        RETURN FALSE  
   END IF 
   RETURN TRUE 
END IF }
RETURN FALSE 
END FUNCTION 

FUNCTION cl_checkpostdate(p_date)
DEFINE  l_date,p_date   LIKE type_file.dat
DEFINE l_cnt   LIKE type_file.num5 

SELECT tc_zsa03 INTO l_date FROM tc_zsa_file WHERE tc_zsa01='0' 
IF cl_null(l_date) THEN 
   return false 
END IF 
DISPLAY "-----------tc_zsa03-------------begin--------"
DISPLAY "tc_zsa03:",l_date
DISPLAY "-----------tc_zsa03--------------end-------"
IF status THEN
   return false 
ELSE
   IF p_date > l_date THEN 
   	RETURN TRUE
   END IF 
END IF  
RETURN FALSE 
END FUNCTION 
