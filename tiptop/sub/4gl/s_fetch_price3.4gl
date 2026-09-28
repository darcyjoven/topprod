# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_fetch_price3.4gl
# Descriptions...: 流通零售系統取价
# Date & Author..: FUN-870007 2008/09/19 By Zhangyajun
# Input Parameter: p_no       多角貿易流程代碼
#                  p_org      當前機構   
#                  p_item     產品編號   
#                  p_unit     單位       
#                  p_type     0:採購 1:訂單   
#                  p_num      多角貿易站別 
# Return Code....: l_success  執行成功否
#                  l_price    單價
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AC0040 10/12/21 By lixia 修改還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_fetch_price3(p_no,p_org,p_item,p_unit,p_type,p_num)
DEFINE p_no    LIKE poz_file.poz01
DEFINE p_org   LIKE tsk_file.tskplant
DEFINE p_type  LIKE type_file.chr1
DEFINE l_cust  LIKE tsk_file.tskplant
DEFINE p_item LIKE tsl_file.tsl03
DEFINE p_unit LIKE tsl_file.tsl04
DEFINE p_num   LIKE type_file.num5
DEFINE l_success LIKE type_file.chr1
DEFINE l_price LIKE tqn_file.tqn05
DEFINE l_pox03 LIKE pox_file.pox03
DEFINE l_pox05 LIKE pox_file.pox05
DEFINE l_pox06 LIKE pox_file.pox06
DEFINE l_sql   STRING
DEFINE l_pmc930 LIKE pmc_file.pmc930
DEFINE l_poy03 LIKE poy_file.poy03
DEFINE l_plant1 LIKE pmc_file.pmc930
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_max   LIKE poy_file.poy02
DEFINE l_min   LIKE poy_file.poy02
DEFINE l_cnt   LIKE type_file.num5
 
       CALL s_pox(p_no,p_num,g_today) RETURNING l_pox03,l_pox05,l_pox06,l_cnt
       IF l_cnt = 0 THEN
          LET g_success = 'N'
          LET l_price = 0
          IF g_bgerr THEN
             CALL s_errmsg('pox01',p_no,'','art-484',1) 
          ELSE
             CALL cl_err(p_no,'art-484',1)
             RETURN g_success,l_price
          END IF
       END IF
       SELECT MAX(poy02) INTO l_max FROM poy_file
        WHERE poy01 = p_no 
       SELECT MIN(poy02) INTO l_min FROM poy_file
        WHERE poy01 = p_no
          CASE l_pox03
            WHEN '1' SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_min
            WHEN '2' IF p_num = l_min THEN
                        SELECT poy04 INTO l_cust
                          FROM poy_file
                         WHERE poy01 = p_no
                           AND poy02 = l_min
                     ELSE
                       SELECT poy04 INTO l_cust
                         FROM poy_file
                        WHERE poy01 = p_no
                          AND poy02 = (p_num-1) 
                     END IF
                     
            WHEN '3' SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_max
            WHEN '4' IF p_num = l_max THEN
                        SELECT poy04 INTO l_cust
                          FROM poy_file
                         WHERE poy01 = l_no
                           AND poy02 = l_max
                     ELSE
                        SELECT poy04 INTO l_cust
                          FROM poy_file
                         WHERE poy01 = l_no
                           AND poy02 = (p_num + 1)
                     END IF
          END CASE
       IF p_type='0' THEN
          IF p_num = l_max THEN
             SELECT DISTINCT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
             AND poy02 = l_max
          ELSE
             SELECT DISTINCT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
                AND poy02 = p_num + 1 
          END IF
       ELSE
          IF p_num = l_min THEN
             SELECT DISTINCT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
             AND poy02 = l_min
          ELSE
             SELECT DISTINCT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
                AND poy02 = p_num -1
          END IF
       END IF
       SELECT DISTINCT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_poy03   #FUN-AC0040
       IF cl_null(l_dbs) THEN
          LET g_success = 'N'
          IF g_bgerr THEN
             CALL s_errmsg('tqb01',l_poy03,'','art-002',1)
          ELSE
             CALL cl_err(l_poy03,'art-002',1)
             RETURN g_success,0
          END IF
       END IF
       #LET l_sql = "SELECT DISTINCT pmc930 FROM ",l_dbs,".pmc_file",
       LET l_sql = "SELECT DISTINCT pmc930 FROM ",cl_get_target_table(l_poy03,'pmc_file'), #FUN-A50102
                   " WHERE pmc01 = ? AND pmcacti = 'Y' AND pmc05 = '1'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,l_poy03) RETURNING l_sql #FUN-A50102            
       PREPARE pmc_sel FROM l_sql
       EXECUTE pmc_sel USING l_poy03 INTO l_plant1
       IF cl_null(l_plant1) THEN
          LET g_success = 'N'
          IF g_bgerr THEN
             CALL s_errmsg('pmc930',l_poy03,'','art-479',1)
          ELSE
             CALL cl_err(l_poy03,'art-479',1)
             RETURN g_success,0
          END IF
       END IF
       
       SELECT DISTINCT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_cust
       IF cl_null(l_dbs) THEN
          LET g_success = 'N'
          IF g_bgerr THEN
             CALL s_errmsg('tqb01',l_cust,'','art-002',1)
          ELSE
             CALL cl_err(l_cust,'art-002',1)
             RETURN g_success,0
          END IF
       END IF
       #LET l_sql = "SELECT DISTINCT pmc930 FROM ",l_dbs,".pmc_file",
       LET l_sql = "SELECT DISTINCT pmc930 FROM ",cl_get_target_table(l_cust,'pmc_file'), #FUN-A50102
                   " WHERE pmc01 = ? AND pmcacti = 'Y' AND pmc05 = '1'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(l_sql,l_cust) RETURNING l_sql #FUN-A50102                
       PREPARE pmc_sel1 FROM l_sql
       EXECUTE pmc_sel1 USING l_cust INTO l_pmc930
       IF cl_null(l_pmc930) THEN
          LET g_success = 'N'
          IF g_bgerr THEN
             CALL s_errmsg('pmc930',l_cust,'','art-479',1)
          ELSE
             CALL cl_err(l_cust,'art-479',1)
             RETURN g_success,0
          END IF
       END IF
       IF p_type='0' THEN
          CALL s_trade_price(l_plant1,p_org,l_pmc930,p_item,p_unit)
            RETURNING l_success,l_price
       ELSE
          CALL s_trade_price(p_org,l_plant1,l_pmc930,p_item,p_unit)
            RETURNING l_success,l_price
       END IF
       IF NOT l_success THEN
          LET g_success = 'N'        
       END IF
       IF cl_null(l_price) THEN LET l_price = 0 END IF
       RETURN g_success,l_price
         
END FUNCTION
#No.FUN-870007
