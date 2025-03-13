# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_azmm.4gl
# Descriptions...: 根據會計年度、營運中心、期間得到其起始、截止的日期
# Date & Author..: 06/08/09 BY Ray
# Usage..........: CALL s_azmm(p_year,p_mon,l_ooz02p,l_ooz02b_c)
#                       RETURNING l_flag,l_bdate,l_edate
# Input PARAMETER: p_year  會計年度
#                  p_mon   日期
# RETURN Code....: l_flag  成功否
#                     1   YES
#                     0   NO
#                  l_bdate  起始日期
#                  l_edate  截止日期
# Modify.........: No.FUN-680147 06/09/10 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_azmm(p_year,p_mon,l_ooz02p,l_ooz02b_c)
   DEFINE  p_mon      LIKE type_file.num5,         #No.FUN-680147 SMALLINT
           p_year     LIKE type_file.num5,         #No.FUN-680147 SMALLINT
           l_ooz02p   LIKE ooz_file.ooz02p,
           l_ooz02b_c LIKE ooz_file.ooz02b,
           l_dbs      STRING,
           l_sql      STRING,
           l_flag     LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01)
           b_date     LIKE type_file.dat,          #No.FUN-680147 DATE
           e_date     LIKE type_file.dat,          #No.FUN-680147 DATE
           l_azmm     RECORD LIKE azmm_file.*
 
  LET l_flag  = '0'
  LET g_plant_new=l_ooz02p 
  #CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
  #LET l_sql = " SELECT * FROM ",l_dbs,"azmm_file",
  LET l_sql = " SELECT * FROM ",cl_get_target_table(l_ooz02p,'azmm_file'), #FUN-A50102  
              "  WHERE azmm01 = '",p_year,"' ",
              "    AND azmm00 = '",l_ooz02b_c,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_ooz02p) RETURNING l_sql #FUN-A50102
  PREPARE azmm_pre FROM l_sql                                                
  DECLARE azmm_cs CURSOR FOR azmm_pre                                         
  OPEN azmm_cs                                                               
  FETCH azmm_cs INTO l_azmm.*          
 
  WHENEVER ERROR CALL cl_err_msg_log
      CASE p_mon
        WHEN  1 LET b_date=l_azmm.azmm011 LET e_date=l_azmm.azmm012
        WHEN  2 LET b_date=l_azmm.azmm021 LET e_date=l_azmm.azmm022
        WHEN  3 LET b_date=l_azmm.azmm031 LET e_date=l_azmm.azmm032
        WHEN  4 LET b_date=l_azmm.azmm041 LET e_date=l_azmm.azmm042
        WHEN  5 LET b_date=l_azmm.azmm051 LET e_date=l_azmm.azmm052
        WHEN  6 LET b_date=l_azmm.azmm061 LET e_date=l_azmm.azmm062
        WHEN  7 LET b_date=l_azmm.azmm071 LET e_date=l_azmm.azmm072
        WHEN  8 LET b_date=l_azmm.azmm081 LET e_date=l_azmm.azmm082
        WHEN  9 LET b_date=l_azmm.azmm091 LET e_date=l_azmm.azmm092
        WHEN 10 LET b_date=l_azmm.azmm101 LET e_date=l_azmm.azmm102
        WHEN 11 LET b_date=l_azmm.azmm111 LET e_date=l_azmm.azmm112
        WHEN 12 LET b_date=l_azmm.azmm121 LET e_date=l_azmm.azmm122
        WHEN 13 LET b_date=l_azmm.azmm131 LET e_date=l_azmm.azmm132
      END CASE
     IF SQLCA.sqlcode != 0 OR b_date IS NULL OR b_date = ' ' 
			  OR e_date IS NULL OR e_date = ' ' 
        THEN 
			LET l_flag = '1' 
     END IF
     RETURN l_flag,b_date,e_date
END FUNCTION
