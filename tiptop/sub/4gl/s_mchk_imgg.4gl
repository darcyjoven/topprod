# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_mchk_imgg.4gl
# Descriptions...: 查詢imgg_file中是否存在雙單位資料
# Date & Author..: 05/07/25 By Carrier
# Usage..........: CALL s_mchk_imgg(p_item,p_ware,p_loc,p_lot,p_unit,p_azp03)
# Input Parameter: p_item  料件
#                  p_ware  倉庫
#                  p_loc   儲位
#                  p_lot   批號
#                  p_unit  單位
#                  p_azp03
# Return code....: '1'
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980094 09/09/16 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/10/05 By huangtao 修改return值
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUNCTION s_mchk_imgg(p_item,p_ware,p_loc,p_lot,p_unit,p_azp03) #FUN-980094 mark
FUNCTION s_mchk_imgg(p_item,p_ware,p_loc,p_lot,p_unit,p_azp01) #FUN-980094 add
DEFINE
    p_item     LIKE imgg_file.imgg01,
    p_ware     LIKE imgg_file.imgg02,
    p_loc      LIKE imgg_file.imgg03,
    p_lot      LIKE imgg_file.imgg04,
    p_unit     LIKE imgg_file.imgg07,
    p_azp03    LIKE azp_file.azp03,
    p_azp03_tra LIKE azp_file.azp03, #FUN-980094 add
    p_azp01    LIKE azp_file.azp01, #FUN-980094 add
    l_imgg     RECORD LIKE imgg_file.*,
    l_sql      LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(600)
    l_flag     LIKE type_file.chr1           #No.FUN-680147 VARCHAR(1)
 
    WHENEVER ERROR CALL cl_err_msg_log
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_item ,p_azp01) OR NOT s_internal_item( p_item,p_azp01 ) THEN
  #      RETURN                            #FUN-AB0011 mark
         RETURN 0                          #FUN-AB0011
    END IF
#FUN-A90049 --------------end-------------------------------------
   #FUN-980094 ----------------------------------------(S)
   #LET g_plant_new = p_azp01 CLIPPED   #FUN-A50102
   #CALL s_getdbs()
   #LET p_azp03 = g_dbs_new
 
   #CALL s_gettrandbs()
   #LET p_azp03_tra = g_dbs_tra
   #FUN-980094 ----------------------------------------(E)
    
    LET l_flag = 0
   #LET l_sql=" SELECT * FROM ",p_azp03 CLIPPED,".imgg_file", #FUN-980094 mark
    #LET l_sql=" SELECT * FROM ",p_azp03_tra CLIPPED,"imgg_file", #FUN-980094 add
    LET l_sql=" SELECT * FROM ",cl_get_target_table(p_azp01,'imgg_file'), #FUN-A50102
              "  WHERE imgg01='",p_item ,"'",
              "    AND imgg02='",p_ware ,"'",
              "    AND imgg03='",p_loc  ,"'",
              "    AND imgg04='",p_lot  ,"'",
              "    AND imgg09='",p_unit ,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102          
    CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-980094
    PREPARE s_pre FROM l_sql
    DECLARE s_cur  CURSOR FOR s_pre
    OPEN s_cur 
    FETCH s_cur INTO l_imgg.*
    IF SQLCA.sqlcode=100 THEN
       LET l_flag = 1
    END IF
    RETURN l_flag
 
END FUNCTION
