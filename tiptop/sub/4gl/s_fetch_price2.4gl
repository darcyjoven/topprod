# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name...: s_fetch_price2.4gl
# Descriptions...: 取定價檔單價
# Date & Author..: 2006/02/13 By elva
# Input Parameter: p_cust     客戶編號   
#                  p_item     產品編號   
#                  p_unit     單位       
#                  p_date     日期       
#                  p_type     類型       
#                  p_dbs      數據庫     
#                  p_curr     幣別       
# Return Code....: l_no       定價編號
#                  l_price    單價
#                  l_success  執行成功否
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.TQC-7B0118 07/11/21 By wujie   atmi227的狀態碼取消“申請”狀態，相應作調整 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980059 09/09/08 By arman  GP5.2架構,修改相關傳入參數
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#根據客戶+產品編號+單位+日期+定價類型取定價編號及單價
#FUNCTION s_fetch_price2(p_cust,p_item,p_unit,p_date,p_type,p_dbs,p_curr)  #No.FUN-980059
FUNCTION s_fetch_price2(p_cust,p_item,p_unit,p_date,p_type,p_plant,p_curr)   #No.FUN-980059
   DEFINE p_cust       LIKE tqo_file.tqo01,         #No.FUN-680147 VARCHAR(10)
          p_item       LIKE tqn_file.tqn03,         #No.FUN-680147 VARCHAR(40)
          p_unit       LIKE tqn_file.tqn04,         #No.FUN-680147 VARCHAR(4)
          p_date       LIKE type_file.dat,          #No.FUN-680147 DATE
          p_type       LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
          p_dbs        LIKE type_file.chr21,        #No.FUN-680147 VARCHAR(21)
          p_plant      LIKE type_file.chr21,        #No.FUN-980059 VARCHAR(21)
          p_curr       LIKE tqm_file.tqm05,
          l_price      LIKE tqn_file.tqn05,
          l_no         LIKE tqm_file.tqm01,
          l_ta_occ017  LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
          l_success    LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
          l_sql        LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(600)
   
   #FUN-A50102--mark--str--
   ##NO.FUN-980059 GP5.2 add begin
   #IF cl_null(p_plant) THEN
   #  LET p_dbs = NULL
   #ELSE
   #  LET g_plant_new = p_plant
   #  CALL s_getdbs()
    # LET p_dbs = g_dbs_new
   #END IF
   ##NO.FUN-980059 GP5.2 add end
   #FUN-A50102--mark--end--
   LET l_success = 'Y'
   LET l_sql="SELECT tqn01,tqn05",
             #"  FROM ",p_dbs CLIPPED,"tqn_file,",
             #          p_dbs CLIPPED,"tqo_file,",
             #          p_dbs CLIPPED,"tqm_file",
             "  FROM ",cl_get_target_table(p_plant,'tqn_file'),",", #FUN-A50102
                       cl_get_target_table(p_plant,'tqo_file'),",", #FUN-A50102
                       cl_get_target_table(p_plant,'tqm_file'),     #FUN-A50102
             " WHERE tqo01 = '",p_cust CLIPPED,"'",
             "       AND tqo02 = tqn01",
             "       AND tqm01 = tqn01",
             "       AND tqn03 = '",p_item CLIPPED,"'",
             "       AND tqn04 = '",p_unit CLIPPED,"'",
             "       AND tqn06<= '",p_date,"'",
             "       AND (tqn07 is null OR tqn07>='",p_date,"')",
             "       AND tqoacti = 'Y'",
#            "       AND tqm04 ='2' ",
             "       AND tqm04 ='1' ",     #No.TQC-7B0118
             "       AND tqm05 ='",p_curr,"'",   #modify by elva
             "       AND tqm06 = '",p_type CLIPPED,"'" ,
             "       ORDER BY tqo03 "  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE tqn_p FROM l_sql
   DECLARE tqn_cur CURSOR FOR tqn_p
   OPEN tqn_cur
   FETCH tqn_cur INTO l_no,l_price
   IF SQLCA.sqlcode THEN
      LET l_success='N'
   END IF
   CLOSE tqn_cur
        
   IF cl_null(l_no) THEN 
      LET l_success='N'
   END IF
   IF cl_null(l_price) THEN LET l_price=0  END IF
 
   RETURN l_no,l_price,l_success
 
END FUNCTION
