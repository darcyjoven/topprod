# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_actimg1.4gl
# Descriptions...: 檢查該批號是否為有效(有效日期>=MFG DAY)
# Date & Author..: 92/06/24 By  Pin
# Usage..........: IF NOT s_actimg1(p_item,p_ware,p_loc,p_lot,p_dbs)
# Input Parameter: p_item  料件編號
#                  p_ware  倉庫號碼
#                  p_loc   儲位號碼
#                  p_lot   批次
#                  p_dbs   資料庫代號
# Return Code....: 0   該批號已過期
#                  1   該批號未過期
# Modify.........: 92/11/20 By Jones 新增加 p_dbs 這個參數,並將所有對資料庫的動作都改成透過 prepare 的方式
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950048 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980094 09/09/01 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/10/05 By huangtao 修改return值

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUN-980094 ----------------------------------------(S)
#FUNCTION s_actimg1(p_item,p_ware,p_loc,p_lot,p_dbs)
FUNCTION s_actimg1(p_item,p_ware,p_loc,p_lot,p_plant)
#FUN-980094 ----------------------------------------(E)
DEFINE
    p_item       like img_file.img01,          #No.MOD-490217
    p_ware       LIKE img_file.img02,          #No.FUN-680147 VARCHAR(10)
    p_loc        LIKE img_file.img03, 	       #No.FUN-680147 VARCHAR(10)
    p_lot        LIKE img_file.img04,          #No.FUN-680147 VARCHAR(24)
    p_dbs        LIKE type_file.chr21,         #No.FUN-680147 VARCHAR(21)
    p_dbs_tra    LIKE type_file.chr21, #FUN-980094
    p_plant      LIKE type_file.chr21,         #FUN-980094 
    l_sql        LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
    l_img18      LIKE img_file.img18
 
   #FUN-980094 ----------------------------------------(S)
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_item ,p_plant) OR NOT s_internal_item( p_item,p_plant ) THEN
    #    RETURN         #FUN-AB0011 mark
         RETURN 1       #FUN-AB0011
    END IF
#FUN-A90049 --------------end-------------------------------------
   
   LET g_plant_new = p_plant CLIPPED
   CALL s_getdbs()
   LET p_dbs = g_dbs_new
 
   CALL s_gettrandbs()
   LET p_dbs_tra = g_dbs_tra
   #FUN-980094 ----------------------------------------(E)
 
    IF p_loc IS NULL THEN LET p_loc=' ' END IF
    IF p_lot IS NULL THEN LET p_lot=' ' END IF
  # LET l_sql =" SELECT img18 FROM ",p_dbs CLIPPED,".img_file",     #TQC-950048 MARK                                                
   #FUN-980094 ----------------------------------------(S)
   #LET l_sql =" SELECT img18 FROM ",s_dbstring(p_dbs),"img_file",  #TQC-950048 ADD
    #LET l_sql =" SELECT img18 FROM ",p_dbs_tra,"img_file",
    LET l_sql =" SELECT img18 FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
   #FUN-980094 ----------------------------------------(E)
               " WHERE img01='",p_item,"'",
               " AND  img02='",p_ware,"'",
               " AND  img03='",p_loc,"'",
               " AND  img04='",p_lot,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
    PREPARE img_scur FROM l_sql
    DECLARE img_cur1 CURSOR FOR img_scur      
    OPEN img_cur1
    FETCH img_cur1 INTO l_img18 
    IF SQLCA.sqlcode THEN RETURN 0 END IF
    IF l_img18 IS NULL OR l_img18=' ' THEN LET l_img18=g_lastdat  END IF
    IF l_img18 < g_today   #有效日小於今天
       THEN RETURN 0
       ELSE RETURN 1
    END IF
  
END FUNCTION
