# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_wknxt.4gl
# Descriptions...: 推算所需的工作日
# Date & Author..: 90/10/23 By  Wu
# Usage..........: CALL s_wknxt(p_date,p_days) RETURNING l_flag,l_date
# Input Parameter: p_date  日期
#                  p_days  相隔工作天數(可為正負值)
# Return Code....: l_flag  0.OK 1.FAIL
#                  l_date  最近的working date
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.MOD-710184 07/02/08 By pengu k_curs1 SCROLL CURSOR加排序，確定日期為排序欄位
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_wknxt(p_date,p_days)
   DEFINE  p_date     LIKE type_file.dat,     	#No.FUN-680147 DATE
           p_days     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
           l_flag     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
           l_date     LIKE type_file.dat    	#No.FUN-680147 DATE
 
     LET l_flag  = 0
      CASE
            WHEN p_days >0
           DECLARE wk_curs1 SCROLL CURSOR FOR SELECT sme01  FROM  sme_file 
                         WHERE sme01 > p_date  
                           AND sme02 IN ('Y','y')
                         ORDER BY sme01     #No.MOD-710184 add
           OPEN  wk_curs1
           FETCH ABSOLUTE p_days wk_curs1  INTO l_date
           IF SQLCA.sqlcode != 0 THEN 
              #CALL cl_err('cannot fetch',SQLCA.sqlcode,0)  #FUN-670091
               CALL cl_err3("sel","sme_file","","",STATUS,"","cannot fetch",0)  #FUN-670091
              LET l_flag = 1
           END IF
           CLOSE wk_curs1          
 
          WHEN p_days < 0
           DECLARE wk_curs2 SCROLL CURSOR FOR SELECT sme01  FROM  sme_file 
 
                            WHERE sme01 < p_date  
                              AND sme02 IN ('Y','y')
                            ORDER BY 1 DESC  
           LET p_days=p_days*-1
           OPEN  wk_curs2
           FETCH ABSOLUTE p_days wk_curs2  INTO l_date
           IF SQLCA.sqlcode != 0 THEN 
              #CALL cl_err('cannot fetch',SQLCA.sqlcode,0)  #FUN-670091
              CALL cl_err3("sel","sme_file","","",STATUS,"","cannot fetch",0) #FUN-670091
               LET l_flag = 1
           END IF
           CLOSE wk_curs2          
 
           OTHERWISE LET l_flag=1 
                     LET l_date=p_date
     END CASE
     RETURN l_flag,l_date
END FUNCTION
