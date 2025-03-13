# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_hqty1.4gl
# Descriptions...: 得最高存量與庫存單位
# Date & Author..: 92/05/29 By Pin
# Usage..........: CALL s_hqty(p_item,p_stock,p_locat,p_dbs)
#                             RETURNING l_stat,l_imf04,l_imf05
# Input Parameter: p_stock   欲檢查之倉庫	 
#                  p_locat   欲檢查之儲位
#                  p_item    欲檢查之料件
#                  p_dbs     資料庫編號
# Return code....: l_stat    1:Yes 0:No
#                  imf04     該儲位之最高限量
#                  imf05     該儲位之庫存單位
# Modify.........: 92/11/20 By Jones
#                  新增 p_dbs 這個參數並將所有對資料的動作都透過 prepare 的動作來作
# Modify.........: No.FUN-680147 06/09/01 By Czl 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.FUN-980020 09/09/23 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/28 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
 
DATABASE ds   #FUN-7C0053
GLOBALS "../../config/top.global"    #FUN-980020
 
#FUNCTION s_hqty1(p_item,p_stock,p_locat,p_dbs)   #FUN-980020 mark
FUNCTION s_hqty1(p_item,p_stock,p_locat,p_plant)  #FUN-980020
DEFINE
    p_item  LIKE imf_file.imf01, #料件
    p_stock LIKE imf_file.imf02, #倉庫別
    p_locat LIKE imf_file.imf03, #儲位別
    p_dbs        LIKE type_file.chr21,        #No.FUN-680147 VARCHAR(21)
    l_sql        LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(1000)
    l_status LIKE type_file.num5,             #No.FUN-680147 SMALLINT
    l_sn     LIKE type_file.num5,             #No.FUN-680147 SMALLINT
    l_imf04 LIKE imf_file.imf04, #最高限量
    l_imf05 LIKE imf_file.imf05  #庫存單位
DEFINE  p_plant  LIKE type_file.chr10         #FUN-980020
 
#FUN-A50102--mark--str--
 #FUN-980020--begin
    #IF cl_null(p_plant) THEN
    #   LET p_dbs = NULL
    #ELSE
    #   LET g_plant_new = p_plant
    #   CALL s_getdbs()
    #   LET p_dbs = g_dbs_new
    #END IF
#FUN-980020--end
#FUN-A50102--mark--end--
 
     IF p_locat IS NULL THEN LET p_locat=' ' END IF
      #LET l_sql = " SELECT imf04,imf05 FROM ",p_dbs CLIPPED,".imf_file",    #TQC-950050 MARK                                       
       #LET l_sql = " SELECT imf04,imf05 FROM ",s_dbstring(p_dbs),"imf_file", #TQC-950050 ADD
     LET l_sql = " SELECT imf04,imf05 FROM ",cl_get_target_table(p_plant,'imf_file'), #FUN-A50102
         " WHERE imf01='",p_item,"' AND imf02='",p_stock,"' AND ",
                 " imf03='", p_locat,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE imf_cur FROM l_sql
    DECLARE imf_curs CURSOR FOR imf_cur       
    OPEN imf_curs
    FETCH imf_curs INTO l_imf04,l_imf05
        LET l_status=SQLCA.sqlcode
    IF l_status THEN
        RETURN 0,'',' '
    END IF
    RETURN 1,l_imf04,l_imf05
END FUNCTION
