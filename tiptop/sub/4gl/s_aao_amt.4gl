# Prog. Version..: '5.30.07-13.05.20(00004)'     #
#
# Pattern name...: s_aao_amt.4gl
# Descriptions...: 根据agli116中金额来源 maj06的不同设置，取得相应的部门金额
# Date & Author..: 13/08/28 By fengmy   #No.FUN-D70095
# Usage..........: CALL s_aao_amt(p_aao00, p_aao01_1, p_aao01_2, p_dept, p_aao03,  p_aao04_1,p_aao04_2, p_maj06,p_plant)                           
# Input Parameter: p_aao00         帳別
#                  p_aao01_1       FROM 科目編號1
#                  p_aao01_2       FROM 科目編號2
#                  p_dept          FROM 部門群組字串
#                  p_aao03         會計年度
#                  p_aao04_1       FROM 期別1
#                  p_aao04_2       FROM 期別2
#                  p_maj06         报表结构中金额来源
#                  p_plant         所属营运中心
# Return code....: l_amt           金額

DATABASE ds

GLOBALS "../../config/top.global"    #No.FUN-D70095


FUNCTION s_aao_amt(p_aao00,p_aao01_1,p_aao01_2,p_dept,p_aao03,p_aao04_1,p_aao04_2,p_maj06,p_plant)
   DEFINE p_aao00     LIKE aao_file.aao00
   DEFINE p_aao01_1   LIKE aao_file.aao01
   DEFINE p_aao01_2   LIKE aao_file.aao01
   DEFINE p_dept      STRING
   DEFINE p_aao03     LIKE aao_file.aao03
   DEFINE p_aao04_1   LIKE aao_file.aao04
   DEFINE p_aao04_2   LIKE aao_file.aao04
   DEFINE p_maj06     LIKE maj_file.maj06
   DEFINE p_plant     LIKE type_file.chr21    
   DEFINE l_amt       LIKE type_file.num20_6   
   DEFINE l_sql          STRING
          
   WHENEVER ERROR CALL cl_err_msg_log
   
   #帐别/科目/年/月/金额来源
   IF cl_null(p_aao00) OR cl_null(p_aao01_1) OR cl_null(p_aao03) OR cl_null(p_aao04_1) OR cl_null(p_maj06) THEN
      RETURN 0
   END IF

   #截止科目
   IF cl_null(p_aao01_2) THEN LET p_aao01_2 = p_aao01_1 END IF

   #截止期别
   IF cl_null(p_aao04_2) THEN LET p_aao04_2 = p_aao04_1 END IF
   
   LET l_amt = 0   
   
   CASE p_maj06
        WHEN 1
          LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"' ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",   
                      "   AND aao04 < '",p_aao04_1,"' ",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                       
          
        WHEN 2
          LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"' ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",    
                      "   AND aao04 BETWEEN '",p_aao04_1,"' AND '",p_aao04_2,"'",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                        
          
        WHEN 3
          LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"'  ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",   
                      "   AND aao04 <= '",p_aao04_2,"' ",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                       
          
        WHEN 4
          LET l_sql = "SELECT SUM(aao05) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"' ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",    
                      "   AND aao04 BETWEEN '",p_aao04_1,"' AND '",p_aao04_2,"'",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                       
          
        WHEN 5
          LET l_sql = "SELECT SUM(aao06) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"'  ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",    
                      "   AND aao04 BETWEEN '",p_aao04_1,"' AND '",p_aao04_2,"'",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                        
         
        WHEN 6
          LET l_sql = "SELECT SUM(aao05) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"'  ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",    
                      "   AND aao04 < '",p_aao04_1,"' ",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                       
         
        WHEN 7
          LET l_sql = "SELECT SUM(aao06) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"'  ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",   
                      "   AND aao04 < '",p_aao04_1,"' ",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                       
          
        WHEN 8
          LET l_sql = "SELECT SUM(aao05) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"'  ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",    
                      "   AND aao04 <= '",p_aao04_2,"' ",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                       
          
        WHEN 9
          LET l_sql = "SELECT SUM(aao06) FROM aao_file,aag_file",
                      " WHERE aao00= '",p_aao00,"'  ",
                      "   AND aao01 BETWEEN '",p_aao01_1,"' AND '",p_aao01_2,"'",
                      "   AND aao03 = '",p_aao03,"'",
                      "   AND aag00 = '",p_aao00,"' ",    
                      "   AND aao04 <= '",p_aao04_2,"' ",
                      "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                      "   AND aao02 IN (",p_dept CLIPPED,")"                       
         
   END CASE
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    
   PREPARE aao_sum FROM l_sql
   EXECUTE aao_sum INTO l_amt 
   IF SQLCA.sqlcode <> 0 AND SQLCA.sqlcode <> 100 THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','select aao fail',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3('sel','aao_file',p_aao00,p_aao01_1,SQLCA.sqlcode,'','select aao amount',1)
      END IF
      LET g_success = 'N'
      RETURN 0
   END IF      
   
   IF cl_null(l_amt) THEN LET l_amt = 0 END IF
   
   RETURN l_amt
END FUNCTION
#-----------------------------------------------------------------------------
# Pattern name...: s_ce_abb07.4gl
# Descriptions...: 根据agli116中金额来源 maj06的不同设置，取得相应的CE凭证金额
# Date & Author..: 13/08/28 By fengmy   #No.FUN-D70095
# Usage..........: CALL s_ce_abb07(p_abb00, p_abb03_1, p_abb03_2, p_dept, p_aba03,  p_aba04_1,p_aba04_2, p_maj06,p_plant)                           
# Input Parameter: p_abb00         帳別
#                  p_abb03_1       FROM 科目編號1
#                  p_abb03_2       FROM 科目編號2
#                  p_dept          FROM 部門群組字串
#                  p_aba03         會計年度
#                  p_aba04_1       FROM 期別1
#                  p_aba04_2       FROM 期別2
#                  p_maj06         报表结构中金额来源
#                  p_plant         所属营运中心
# Return code....: l_CE            金額

FUNCTION s_ce_abb07(p_abb00,p_abb03_1,p_abb03_2,p_dept,p_aba03,p_aba04_1,p_aba04_2,p_maj06,p_plant)
   DEFINE p_abb00     LIKE abb_file.abb00
   DEFINE p_abb03_1   LIKE abb_file.abb03
   DEFINE p_abb03_2   LIKE abb_file.abb03
   DEFINE p_dept      STRING
   DEFINE p_aba03     LIKE aba_file.aba03
   DEFINE p_aba04_1   LIKE aba_file.aba04
   DEFINE p_aba04_2   LIKE aba_file.aba04
   DEFINE p_maj06     LIKE maj_file.maj06
   DEFINE p_plant     LIKE type_file.chr21 
   DEFINE l_CE_sum1   LIKE abb_file.abb07         
   DEFINE l_CE_sum2   LIKE abb_file.abb07         
   DEFINE l_CE        LIKE abb_file.abb07 
   DEFINE l_sql1         STRING 
          
   WHENEVER ERROR CALL cl_err_msg_log
   
   #帐别/科目/年/月/金额来源
   IF cl_null(p_abb00) OR cl_null(p_abb03_1) OR cl_null(p_aba03) OR cl_null(p_aba04_1) OR cl_null(p_maj06) THEN
      RETURN 0
   END IF

   #截止科目
   IF cl_null(p_abb03_2) THEN LET p_abb03_2 = p_abb03_1 END IF

   #截止期别
   IF cl_null(p_aba04_2) THEN LET p_aba04_2 = p_aba04_1 END IF
   
   LET l_CE_sum1 = 0
   LET l_CE_sum2 = 0
   LET l_CE = 0
   
   CASE p_maj06
        WHEN 1          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = ? AND aba03 = '",p_aba03,"'",
                      "   AND aba04 < '",p_aba04_1,"' ",
                      "   AND abapost = 'Y'"    
        WHEN 2          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = ? AND aba03 = '",p_aba03,"'",
                      "   AND aba04 BETWEEN '",p_aba04_1,"' AND '",p_aba04_2,"'",
                      "   AND abapost = 'Y'"    
        WHEN 3          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = ? AND aba03 = '",p_aba03,"'",
                      "   AND aba04 <= '",p_aba04_2,"' ",
                      "   AND abapost = 'Y'"    
        WHEN 4          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = '",p_aba03,"'",
                      "   AND aba04 BETWEEN '",p_aba04_1,"' AND '",p_aba04_2,"'",
                      "   AND abapost = 'Y'" 
        WHEN 5          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = '",p_aba03,"'",
                      "   AND aba04 BETWEEN '",p_aba04_1,"' AND '",p_aba04_2,"'",
                      "   AND abapost = 'Y'"
        WHEN 6          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = '",p_aba03,"'",
                      "   AND aba04 < '",p_aba04_1,"' ",
                      "   AND abapost = 'Y'" 
        WHEN 7                               
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = '",p_aba03,"'",
                      "   AND aba04 < '",p_aba04_1,"' ",
                      "   AND abapost = 'Y'" 
        WHEN 8          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = '",p_aba03,"'",
                      "   AND aba04 <= '",p_aba04_2,"' ",
                      "   AND abapost = 'Y'"
        WHEN 9          
          LET l_sql1 = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = '",p_abb00,"'",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 BETWEEN '",p_abb03_1,"' AND '",p_abb03_2,"'",
                      "   AND abb05 IN (",p_dept CLIPPED,")",
                      "   AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = '",p_aba03,"'",
                      "   AND aba04 <= '",p_aba04_2,"' ",
                      "   AND abapost = 'Y'"
   END CASE   
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
   CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
   PREPARE abb_cesum FROM l_sql1
   DECLARE abb_cesumc CURSOR FOR abb_cesum 
   
   IF p_maj06 < '4' THEN
      OPEN abb_cesumc USING '1'
      FETCH abb_cesumc INTO l_CE_sum1   
      IF SQLCA.sqlcode <> 0 AND SQLCA.sqlcode <> 100 THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','select abb fail',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3('sel','abb_file',p_abb00,p_abb03_1,SQLCA.sqlcode,'','select abb CE',1)
         END IF
         LET g_success = 'N'
         RETURN 0
      END IF 
      IF l_CE_sum1 IS NULL THEN LET l_CE_sum1 = 0 END IF
      
      OPEN abb_cesumc USING '2'
      FETCH abb_cesumc INTO l_CE_sum2   
      IF SQLCA.sqlcode <> 0 AND SQLCA.sqlcode <> 100 THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','select abb fail',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3('sel','abb_file',p_abb00,p_abb03_1,SQLCA.sqlcode,'','select abb CE',1)
         END IF
         LET g_success = 'N'
         RETURN 0
      END IF 
      IF l_CE_sum2 IS NULL THEN LET l_CE_sum2 = 0 END IF
      LET l_CE = l_CE_sum1 - l_CE_sum2
   ELSE
      OPEN abb_cesumc 
      FETCH abb_cesumc INTO l_CE
      IF SQLCA.sqlcode <> 0 AND SQLCA.sqlcode <> 100 THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','select abb fail',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3('sel','abb_file',p_abb00,p_abb03_1,SQLCA.sqlcode,'','select abb CE',1)
         END IF
         LET g_success = 'N'
         RETURN 0
      END IF 
      IF l_CE IS NULL THEN LET l_CE = 0 END IF     
   END IF   
   CLOSE abb_cesumc   
   IF cl_null(l_CE) THEN LET l_CE = 0 END IF
   
   RETURN l_CE
END FUNCTION

# Pattern name...: s_afc_amt.4gl
# Descriptions...: 根据agli116中金额来源 maj06的不同设置，取得相应預算金额
# Date & Author..: 13/08/28 By fengmy   #No.FUN-D70095
# Usage..........: CALL s_afc_amt(p_afc00, p_afc02_1, p_afc02_2, p_dept, p_afc03,  p_afc05_1,p_afc05_2, p_maj06,p_plant)                           
# Input Parameter: p_afc00         帳別
#                  p_afc02_1       FROM 科目編號1
#                  p_afc02_2       FROM 科目編號2
#                  p_dept          FROM 部門群組字串
#                  p_afc03         會計年度
#                  p_afc05_1       FROM 期別1
#                  p_afc05_2       FROM 期別2
#                  p_afc01         預算項目
#                  p_maj06         报表结构中金额来源
#                  p_plant         所属营运中心
# Return code....: l_amt1          金額

FUNCTION s_afc_amt(p_afc00,p_afc02_1,p_afc02_2,p_dept,p_afc03,p_afc05_1,p_afc05_2,p_afc01,p_maj06,p_plant)
   DEFINE p_afc00     LIKE afc_file.afc00
   DEFINE p_afc02_1   LIKE afc_file.afc02
   DEFINE p_afc02_2   LIKE afc_file.afc02
   DEFINE p_dept      STRING
   DEFINE p_afc03     LIKE afc_file.afc03
   DEFINE p_afc05_1   LIKE afc_file.afc05
   DEFINE p_afc05_2   LIKE afc_file.afc05
   DEFINE p_afc01     LIKE afc_file.afc01
   DEFINE p_maj06     LIKE maj_file.maj06
   DEFINE p_plant     LIKE type_file.chr21    
   DEFINE l_amt1      LIKE abb_file.abb07 
   DEFINE l_sql1      STRING 
          
   WHENEVER ERROR CALL cl_err_msg_log
   
   #帐别/科目/年/月/金额来源
   IF cl_null(p_afc00) OR cl_null(p_afc02_1) OR cl_null(p_afc03) OR cl_null(p_afc05_1) OR cl_null(p_maj06) THEN
      RETURN 0
   END IF

   #截止科目
   IF cl_null(p_afc02_2) THEN LET p_afc02_2 = p_afc02_1 END IF

   #截止期别
   IF cl_null(p_afc05_2) THEN LET p_afc05_2 = p_afc05_1 END IF   
   LET l_amt1 = 0
   
   CASE p_maj06
        WHEN 1         
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",                
                       "   AND afc00='",p_afc00,"' ",                               
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                   
                       "   AND afc05 < '",p_afc05_1,"' ",
                       "   AND afbacti = 'Y' "    
         WHEN 2                                                         
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",               
                       "   AND afc00='",p_afc00,"' ",                              
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                  
                       "   AND afc05 BETWEEN '",p_afc05_1,"' AND '",p_afc05_2,"'",
                       "   AND afbacti = 'Y' "    
         WHEN 3                                                          
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))", 
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",             
                       "   AND afc00='",p_afc00,"' ",                            
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                
                       "   AND afc05 <= '",p_afc05_2,"' ",
                       "   AND afbacti = 'Y' "    
         WHEN 4                                                        
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))", 
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",             
                       "   AND afc00='",p_afc00,"' ",                            
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                
                       "   AND afc05 BETWEEN '",p_afc05_1,"' AND '",p_afc05_2,"'",
                       "   AND afbacti = 'Y' "    
         WHEN 5                                                         
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",               
                       "   AND afc00='",p_afc00,"' ",                              
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                  
                       "   AND afc05 BETWEEN '",p_afc05_1,"' AND '",p_afc05_2,"'",
                       "   AND afbacti = 'Y' "    
         WHEN 6                                                     
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))", 
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",               
                       "   AND afc00='",p_afc00,"' ",                              
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                  
                       "   AND afc05 < '",p_afc05_1,"' ",
                       "   AND afbacti = 'Y' "    
         WHEN 7                                                        
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))", 
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",               
                       "   AND afc00='",p_afc00,"' ",                              
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                  
                       "   AND afc05 < '",p_afc05_1,"' ",
                       "   AND afbacti = 'Y' "    
         WHEN 8                                                     
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))", 
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",               
                       "   AND afc00='",p_afc00,"' ",                              
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                  
                       "   AND afc05 <= '",p_afc05_2,"' ",
                       "   AND afbacti = 'Y' "    
         WHEN 9                                                        
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))", 
                       "  FROM afc_file,afb_file",
                       " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "   AND afc03=afb03 AND afc04=afb04 ",
                       "   AND afc041=afb041 AND afc042=afb042 ",               
                       "   AND afc00='",p_afc00,"' ",                              
                       "   AND afc02 BETWEEN '",p_afc02_1,"' AND '",p_afc02_2,"'",
                       "   AND afc03='",p_afc03,"'",
                       "   AND afb041 IN (",p_dept CLIPPED,")",                  
                       "   AND afc05 <= '",p_afc05_2,"' ",
                       "   AND afbacti = 'Y' "    
   END CASE
   IF NOT cl_null(p_afc01) THEN
      LET l_sql1 = l_sql1," AND afc01 = '",p_afc01,"'"
   END IF        
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
   CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
   PREPARE r198_sum1 FROM l_sql1
   EXECUTE r198_sum1 INTO l_amt1
   
   IF SQLCA.sqlcode <> 0 AND SQLCA.sqlcode <> 100 THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','select afc fail',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3('sel','aao_file',p_afc00,p_afc02_1,SQLCA.sqlcode,'','select afc amount',1)
      END IF
      LET g_success = 'N'
      RETURN 0
   END IF      
   
   IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
   
   RETURN l_amt1
END FUNCTION
