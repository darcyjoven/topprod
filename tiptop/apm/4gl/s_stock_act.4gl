# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
##□ s_stock_act
##SYNTAX          LET l_actno=s_stock_act(p_item,p_ware,p_loc,p_dbs)
##DESCRIPTION     三角貿易取得STOCK 會計科目
##PARAMETERS      p_item          料號  
##                p_ware          倉庫
##                p_loc           儲位
##                p_dbs           三角貿易欲拋轉的資料庫
##RETURNING       l_actno         會計科目 
# Date & Author..:03/06/03 By Kammy
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: NO.TQC-760181 07/06/26 BY yiting 重新過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-A50102 10/07/19 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-D40103 13/05/08 By fengrui 抓ime_file資料添加imeacti='Y'條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUNCTION s_stock_act(p_item,p_ware,p_loc,p_dbs)   #No.FUN-980025 mark
FUNCTION s_stock_act(p_item,p_ware,p_loc,p_plant)  #No.FUN-980025 
DEFINE p_item   LIKE ima_file.ima01     #no.TQC-760181
DEFINE p_ware   LIKE ime_file.ime01
DEFINE p_loc    LIKE ime_file.ime02
DEFINE p_dbs    LIKE type_file.chr21  	#No.FUN-680136 VARCHAR(21)
DEFINE p_plant  LIKE type_file.chr10  	#No.FUN-980025
DEFINE g_ccz07  LIKE ccz_file.ccz07 
DEFINE l_actno  LIKE ima_file.ima01 
DEFINE l_msg    LIKE type_file.chr1000	#No.FUN-680136 VARCHAR(50)
DEFINE l_sql    LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500)
 
   ##NO.FUN-980025 GP5.2 add begin                                                                                                  
   IF cl_null(p_plant) THEN                                                                                                         
     LET p_dbs = NULL                                                                                                               
   ELSE                                                                                                                             
     LET g_plant_new = p_plant                                                                                                      
     CALL s_getdbs()                                                                                                                
     LET p_dbs = g_dbs_new                                                                                                          
   END IF                                                                                                                           
   ##NO.FUN-980025 GP5.2 add end  
  #LET l_sql="SELECT ccz07 FROM ",p_dbs CLIPPED,"ccz_file",                      #FUN-A50102 mark
   LET l_sql="SELECT ccz07 FROM ",cl_get_target_table(p_plant,'ccz_file'),   #FUN-A50102  
             " WHERE ccz00='0'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102     
   PREPARE ccz_p1 FROM l_sql 
   DECLARE ccz_c1 CURSOR FOR ccz_p1
   OPEN ccz_c1 
   FETCH ccz_c1 INTO g_ccz07
   IF STATUS THEN
      CALL cl_err('sel AXC ccz:','aoo-000',1)
      LET g_success='N' CLOSE ccz_c1 RETURN
   END IF  
   LET l_msg = p_dbs clipped,'stock act:'
   CASE WHEN g_ccz07='1'
           # LET l_sql = " SELECT ima39 FROM ",p_dbs CLIPPED,"ima_file",                    #FUN-A50102 mark
             LET l_sql = " SELECT ima39 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                         "  WHERE ima01 ='",p_item,"'"
     	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102
             PREPARE ima_p FROM l_sql
             DECLARE ima_c CURSOR FOR ima_p
             OPEN ima_c
             FETCH ima_c INTO l_actno
             CLOSE ima_c
            #IF STATUS THEN
            #   CALL cl_err(l_msg,'mfg0002',1) LET g_success='N'
            #END IF
        WHEN g_ccz07='2'
            #LET l_sql = " SELECT imz39 FROM ",p_dbs CLIPPED," ima_file,",                       #FUN-A50102 mark
            #                                  p_dbs CLIPPED," imz_file ",                       #FUN-A50102 mark
             LET l_sql = " SELECT imz39 FROM ",cl_get_target_table(p_plant,'ima_file'),",",  #FUN-A50102
                                               cl_get_target_table(p_plant,'imz_file'),      #FUN-A50102 
                         "  WHERE ima01='",p_item,"' AND ima06=imz01 "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                   #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql       #FUN-A50102
             PREPARE imz_p FROM l_sql
             DECLARE imz_c CURSOR FOR imz_p
             OPEN imz_c
             FETCH imz_c INTO l_actno
             CLOSE imz_c
            #IF STATUS THEN
            #   CALL cl_err('l_msg,'mfg0002',1) LET g_success='N'
            #END IF
        WHEN g_ccz07='3' 
            #LET l_sql = " SELECT imd08 FROM ",p_dbs CLIPPED," imd_file ",                  #FUN-A50102 mark
             LET l_sql = " SELECT imd08 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102 
                         "  WHERE imd01='",p_ware,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102 
             PREPARE imd_p FROM l_sql
             DECLARE imd_c CURSOR FOR imd_p
             OPEN imd_c
             FETCH imd_c INTO l_actno
             CLOSE imd_c
        WHEN g_ccz07='4' 
            #LET l_sql = " SELECT ime09 FROM ",p_dbs CLIPPED," ime_file ",                  #FUN-A50102 mark
             LET l_sql = " SELECT ime09 FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102 
                         "  WHERE ime01='",p_ware,"' AND ime02='",p_loc,"'",
                         "    AND imeacti='Y' "  #FUN-D40103 add
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102
             PREPARE ime_p FROM l_sql
             DECLARE ime_c CURSOR FOR ime_p
             OPEN ime_c
             FETCH ime_c INTO l_actno
             CLOSE ime_c
         OTHERWISE       LET l_actno='STOCK'
   END CASE
   RETURN l_actno
END FUNCTION
