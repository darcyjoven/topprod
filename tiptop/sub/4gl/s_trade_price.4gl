# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_trade_price.4gl
# Descriptions...: 跨機構取得內部供應商或內部客戶之商品的價格
# Date & Author..: NO.FUN-960130 09/07/23 By sunyanchun 
# Input Parameter: 
# Return code....: TRUE or FALSE;價格 
# Modify.........: No.FUN-TQC-9A0109 09/10/23 By sunyanchun  post to area 32
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   
 
#############################################
#說明:
#采購部分：  
#判斷供應商對應機構有值(則為內部供應商）
#采購取價時：組織機構為   供應商對應的機構
#            交易機構為   當前機構
# arti150單身對應價格為   取交易機構對應的價格
#
#銷售部分：
#判斷客戶對應機構有值(則為內部客戶)
#銷售取價：  組織機構為   當前機構
#            交易機構為   客戶對應的機構
# arti150單身對應價格為   取交易機構對應的價格
############################################
 
FUNCTION s_trade_price(p_plant1,p_plant2,p_plant3,p_part,p_unit)
DEFINE p_plant1    LIKE tqb_file.tqb01       #組織機構(單頭)機構 
DEFINE p_plant2    LIKE tqb_file.tqb01       #交易機構
DEFINE p_plant3    LIKE tqb_file.tqb01       #計價基准機構 
DEFINE p_part      LIKE ima_file.ima01       #料件編號
DEFINE p_unit      LIKE gfe_file.gfe01       #單位 
DEFINE l_ima131    LIKE ima_file.ima131
DEFINE l_n         LIKE type_file.num5
DEFINE l_rtl04     LIKE rtl_file.rtl04
DEFINE l_rtl05     LIKE rtl_file.rtl05
DEFINE l_rtl06     LIKE rtl_file.rtl06
DEFINE l_sql       STRING
DEFINE l_rth04     LIKE rth_file.rth04
DEFINE l_price     LIKE rth_file.rth04
DEFINE l_tqn05     LIKE tqn_file.tqn05
DEFINE l_dbs       LIKE azp_file.azp03
DEFINE l_fac       LIKE type_file.num20_6
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_unit      LIKE gef_file.gef01
DEFINE l_max_fac   LIKE type_file.num20_6
DEFINE l_success   LIKE type_file.chr1
DEFINE l_rtg05     LIKE rtg_file.rtg05
DEFINE l_rtg08     LIKE rtg_file.rtg08
DEFINE l_rtz05     LIKE rtz_file.rtz05
 
     LET l_success = 'Y'    #NO.TQC-9A0109
 
   #抓產品分類
     SELECT ima131 
       INTO l_ima131 FROM ima_file
      WHERE ima01= p_part 
        AND imaacti='Y'
     IF SQLCA.sqlcode THEN    #NO.FUN-9B0016
        LET l_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg('ima01',p_part,'foreach',SQLCA.sqlcode,1)   
        ELSE
           CALL cl_err3("sel","ima_file",p_part,"",SQLCA.sqlcode,"","",1)
           RETURN FALSE,0
        END IF
     END IF  
 
  #抓交易價類型(l_rtl04)、交易訂價代碼(l_rtl05)、調價比例(l_rtl06)
     LET l_n = 0
     CALL s_trade_price_sel_rtl(p_plant1,p_plant2,l_ima131)
          RETURNING l_n,l_rtl04,l_rtl05,l_rtl06
     IF l_n = 0 THEN
        CALL s_trade_price_sel_rtl(p_plant1,'*',l_ima131)
             RETURNING l_n,l_rtl04,l_rtl05,l_rtl06
     END IF
     IF l_n = 0 THEN
        CALL s_trade_price_sel_rtl(p_plant1,p_plant2,'*')
             RETURNING l_n,l_rtl04,l_rtl05,l_rtl06
     END IF
     IF l_n = 0 THEN
        CALL s_trade_price_sel_rtl(p_plant1,'*','*')
             RETURNING l_n,l_rtl04,l_rtl05,l_rtl06
     END IF
     IF l_n = 0 THEN
        LET l_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg('rtl04',p_plant1,'foreach','sub-207',1)   
        ELSE
           CALL cl_err('','sub-207',0)
           RETURN FALSE,0
        END IF
     END IF
  #根據計價基准機構 及交易類型 抓基准售價          
     SELECT azp03 INTO l_dbs
       FROM azp_file 
      WHERE azp01 = p_plant3
     IF SQLCA.sqlcode THEN
        LET l_success = 'N'
        IF g_bgerr THEN   
           CALL s_errmsg('azp03',p_plant3,'foreach',SQLCA.sqlcode,1)   
        ELSE
           CALL cl_err3("sel","azp_file",p_plant3,"",SQLCA.sqlcode,"","",1)
           RETURN FALSE,0
        END IF
     END IF  
     LET l_sql = NULL
     LET l_dbs = s_dbstring(l_dbs CLIPPED)
     IF l_rtl04 = '2' THEN
        SELECT rtz05 INTO l_rtz05 FROM rtz_file WHERE rtz01 = p_plant3
        #價格信息表取值(原單位匹配）
        LET l_sql = " SELECT rtg05,rtg08 ",
                    #"  FROM ",l_dbs,"rtg_file",
                    "  FROM ",cl_get_target_table(p_plant3,'rtg_file'), #FUN-A50102
                    " WHERE rtg01 = ?", 
                    "   AND rtg03 = ?",
                    "   AND rtg04 = ?",
                    "   AND rtg09 = 'Y'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
	     CALL cl_parse_qry_sql(l_sql,p_plant3) RETURNING l_sql #FUN-A50102           
         PREPARE s_rth_pb FROM l_sql
         DECLARE s_rth_cs CURSOR FOR s_rth_pb
         OPEN s_rth_cs USING l_rtz05,p_part,p_unit
         FETCH s_rth_cs INTO l_rtg05,l_rtg08
         #價格策略中沒有
         IF SQLCA.sqlcode = 100 THEN
            LET l_success = 'N'
            IF g_bgerr THEN 
               CALL s_errmsg('sel rtg_file',p_part,'p_unit',SQLCA.sqlcode,1)   
            ELSE 
               CALL cl_err3("sel","rtg_file",l_unit,p_part,SQLCA.sqlcode,"","",1)
               RETURN FALSE,0 
            END IF
            LET l_price = 0
         ELSE
            IF l_rtg08 = 'Y' THEN
               #LET l_sql = "SELECT rth04 FROM ",l_dbs,"rth_file ",
               LET l_sql = "SELECT rth04 FROM ",cl_get_target_table(p_plant3,'rth_file'), #FUN-A50102
                           "   WHERE rth01 = '",p_part,"' AND rth02 = '",p_unit,"' ",
                           "     AND rthplant = '",p_plant3,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
	           CALL cl_parse_qry_sql(l_sql,p_plant3) RETURNING l_sql #FUN-A50102               
               PREPARE pre_sel_rth FROM l_sql
               EXECUTE pre_sel_rth INTO l_rth04
               LET l_price = l_rth04
               IF cl_null(l_price) THEN  # bnlent 091016 add
                  LET l_price = l_rtg05
               END IF
            ELSE
               LET l_price = l_rtg05
            END IF
         END IF
         CLOSE s_rth_cs
     END IF
     IF l_rtl04 = '3' THEN
        #產品價格表 (注意：此處未根據幣別轉化)
        LET l_sql = " SELECT tqn05",
                    #"   FROM ",l_dbs CLIPPED,"tqm_file,",
                    #           l_dbs CLIPPED,"tqn_file",
                    "   FROM ",cl_get_target_table(p_plant3,'tqm_file'),",", #FUN-A50102
                               cl_get_target_table(p_plant3,'tqn_file'),     #FUN-A50102
                    "  WHERE tqm01 = tqn01",
                    "    AND tqn01 = ? ",
                    "    AND tqn03 = ? ",
                    "    AND tqn04 = ? ",
                    "    AND tqm04 = '1'",
                    "    AND tqm06 = '4'",
                    "    AND tqn06 <= '",g_today,"' ",
                    "    AND (tqn07 IS NULL OR tqn07 >='",g_today,"')"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
	     CALL cl_parse_qry_sql(l_sql,p_plant3) RETURNING l_sql #FUN-A50102              
         PREPARE s_tqn_pb FROM l_sql
         DECLARE s_tqn_cs CURSOR FOR s_tqn_pb
         OPEN s_tqn_cs USING l_rtl05,p_part,p_unit
         FETCH s_tqn_cs INTO l_tqn05
         IF SQLCA.sqlcode = 100 THEN   
            LET l_sql = " SELECT tqn04,tqn05 ",
                        #"   FROM ",l_dbs CLIPPED,"tqm_file,",
                        #           l_dbs CLIPPED,"tqn_file",
                        "   FROM ",cl_get_target_table(p_plant3,'tqm_file'),",", #FUN-A50102
                                   cl_get_target_table(p_plant3,'tqn_file'),     #FUN-A50102
                        "  WHERE tqm01 = tqn01", 
                        "    AND tqn01 = ? ",  
                        "    AND tqn03 = ? ", 
                        "    AND tqm04 = '1'", 
                        "    AND tqm06 = '4'",
                        "    AND tqn06 <= '",g_today,"' ",  
                        "    AND (tqn07 IS NULL OR tqn07 >='",g_today,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
	        CALL cl_parse_qry_sql(l_sql,p_plant3) RETURNING l_sql #FUN-A50102              
            PREPARE s_tqn_pbk FROM l_sql
            DECLARE s_tqn_csk CURSOR FOR s_tqn_pbk
            LET l_max_fac = 0
            FOREACH s_tqn_csk USING l_rtl05,p_part INTO l_unit,l_tqn05 
               IF SQLCA.SQLCODE THEN
                  LET l_success = 'N'
                  IF g_bgerr  THEN
                     CALL s_errmsg('tqm01',l_rtl05,'foreach',SQLCA.sqlcode,1)   
                  ELSE
                     CALL cl_err3("sel","tqm_file,tqn_file",l_rtl05,p_part,SQLCA.sqlcode,"","",1)
                     RETURN FALSE,0
                  END IF
               END IF
 
               CALL s_umfchk(p_part,p_unit,l_unit) RETURNING l_flag,l_fac
               IF l_max_fac < l_fac THEN
                  LET l_max_fac = l_fac
               END IF
            END FOREACH
            LET l_price = l_tqn05*l_max_fac
         ELSE
            LET l_price = l_tqn05
         END IF
         CLOSE s_tqn_cs
         CLOSE s_tqn_csk
     END IF
     IF NOT cl_null(l_price) THEN
        LET l_price = l_price * l_rtl06/100
     ELSE
        LET l_price = 0
     END IF
     
     IF l_success = 'Y' THEN
        RETURN TRUE,l_price
     ELSE
        RETURN FALSE,0
     END IF     
 
END FUNCTION
 
#根據組織機構 和交易機構 及產品分類 
#抓交易價類型(l_rtl04)、交易訂價代碼(l_rtl05)、調價比例(l_rtl06)
FUNCTION s_trade_price_sel_rtl(p_plant1,p_plant2,p_ima131)
DEFINE p_plant1    LIKE tqb_file.tqb01              #組織機構(單頭)機構 
DEFINE p_plant2    LIKE tqb_file.tqb01              #交易機構
DEFINE p_ima131    LIKE ima_file.ima131
DEFINE l_rtl04     LIKE rtl_file.rtl04
DEFINE l_rtl05     LIKE rtl_file.rtl05
DEFINE l_rtl06     LIKE rtl_file.rtl06
 
       SELECT rtl04,rtl05,rtl06 
         INTO l_rtl04,l_rtl05,l_rtl06
         FROM rtl_file
        WHERE rtl01 = p_plant1
          AND rtl03 = p_plant2
          AND rtl07 = p_ima131
          AND rtlacti = 'Y' 
       IF SQLCA.sqlcode THEN
          RETURN 0,'','',''
       END IF
 
       RETURN 1,l_rtl04,l_rtl05,l_rtl06
 
END FUNCTION
#FUN-960130
