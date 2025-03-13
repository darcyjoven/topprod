# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_imfchk11.4gl
# Descriptions...: 檢查料件儲位的使用
# Date & Author..: 92/05/29 By Pin
# Usage..........: IF s_imfchk11(p_item,p_stock,p_locat,p_dbs)
# Input Parameter: p_stock   欲檢查之倉庫	 
#                  p_preat   欲檢查之儲位
#                  p_item    欲檢查之料件
#                  p_dbs     資料庫名稱
# Return code....: 1  Yes
#                  0  No
# Modify.........: 92/11/20 By Jones
#                   新增 p_dbs 這個參數並將所有對資料庫的動作都透過 prepare 的方式來作
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980059 09/09/10 By arman  將傳入的DB變數改成plant變數
# Modify.........: No.FUN-A50102 10/06/28 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUNCTION s_imfchk11(p_item,p_stock,p_locat,p_dbs)    #No.FUN-980059
FUNCTION s_imfchk11(p_item,p_stock,p_locat,p_plant)   #No.FUN-980059
DEFINE
    p_item    LIKE imf_file.imf01, #料件
    p_stock   LIKE imf_file.imf02, #倉庫別
    p_locat   LIKE imf_file.imf03, #儲位別
    p_plant   LIKE type_file.chr21,     #No.FUN-980059
    p_dbs     LIKE type_file.chr21,      #No.FUN-680147 VARCHAR(21)
    l_sql     LIKE type_file.chr1000,    #No.FUN-680147 VARCHAR(1000)
    l_status  LIKE imf_file.imf06,       #No.FUN-680147 SMALLINT
    l_sn      LIKE imf_file.imf06,       #No.FUN-680147 SMALLINT
    l_imf04   LIKE imf_file.imf04, #最高限量
    l_imf05   LIKE imf_file.imf05  #庫存單位

#FUN-A50102--mark--str--    
#-----> 92/11/20 Add by Jones
   ##NO.FUN-980059 GP5.2 add begin
   #IF cl_null(p_plant) THEN
   #  LET p_dbs = NULL
   #ELSE
   #  LET g_plant_new = p_plant
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #END IF
   ##NO.FUN-980059 GP5.2 add end
#FUN-A50102--mark--str--   
   #LET l_sql = "SELECT * FROM ",p_dbs CLIPPED,".sma_file",      #TQC-950050 MARK                                                   
    #LET l_sql = "SELECT * FROM ",s_dbstring(p_dbs),"sma_file",   #TQC-950050 ADD
    LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'sma_file'), #FUN-A50102  
                " WHERE sma00 = '0'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE sma_cur FROM l_sql
    DECLARE sma_curs CURSOR FOR sma_cur       
    OPEN sma_curs
    FETCH sma_curs INTO g_sma.*
#--------------------------------------------------------------------
 
#-------------------------------------------------#
#*****表該料件可存放任何倉庫/儲位*****************#
#-------------------------------------------------#
 
    IF p_locat IS NULL THEN LET p_locat=' ' END IF
    IF g_sma.sma42 ='3' OR g_sma.sma42 IS NULL 
       THEN RETURN 1
    END IF
 
#-------------------------------------------------#
#*****表該料設定存放在某個倉庫********************#
#-------------------------------------------------#
    IF g_sma.sma42='1' THEN 
      #LET l_sql=" SELECT count(*) FROM ",p_dbs CLIPPED,".imf_file",     #TQC-950050 MARK                                           
       #LET l_sql=" SELECT count(*) FROM ",s_dbstring(p_dbs),"imf_file",  #TQC-950050 ADD
       LET l_sql=" SELECT count(*) FROM ",cl_get_target_table(p_plant,'imf_file'), #FUN-A50102    
                 "  WHERE imf01='",p_item,"'"," AND imf02='",p_stock,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE imf_c1  FROM l_sql
       DECLARE imf_cur1 CURSOR FOR imf_c1        
       OPEN imf_cur1 
       FETCH imf_cur1 INTO l_sn
       IF l_sn=0 THEN 
          LET l_status=100 RETURN 0 ELSE 
          LET l_status=SQLCA.sqlcode 
       END IF
    ELSE
#-------------------------------------------------#
#*****表該料設定存放在某個倉庫/儲位中*************#
#-------------------------------------------------#
      #LET l_sql = " SELECT imf04,imf05 FROM ",p_dbs CLIPPED,".imf_file",    #TQC-950050 MARK                                       
       #LET l_sql = " SELECT imf04,imf05 FROM ",s_dbstring(p_dbs),"imf_file", #TQC-950050 ADD
      LET l_sql = " SELECT imf04,imf05 FROM ",cl_get_target_table(p_plant,'imf_file'), #FUN-A50102       
                   " WHERE imf01='",p_item,"'",
                   " AND imf02='",p_stock,"'",
                   " AND imf03='",p_locat,"'"  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE imf_c2  FROM l_sql
       DECLARE imf_cur2 CURSOR FOR imf_c2        
       OPEN imf_cur2
       FETCH imf_cur2 INTO l_imf04,l_imf05
       LET l_status=SQLCA.sqlcode
    END IF
    IF l_status THEN
        RETURN 0
    END IF
 
    RETURN 1
END FUNCTION
