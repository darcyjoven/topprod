# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_madd_imgg.4gl
# Descriptions...: 新增imgg_file資料
# Date & Author..: 05/07/25 By Carrier 
# Usage..........: CALL s_madd_imgg(p_item,p_ware,p_loc,p_lot,p_unit,
#                                   p_fac,p_no,p_line,p_fac1,p_azp03)
# Input Parameter: p_item    料件
#                  p_ware    倉庫
#                  p_loc     儲位
#                  p_lot     批號
#                  p_unit    單位
#                  p_fac     轉換率   imgg對img09的轉換率
#                  p_no      單號
#                  p_line    項次
#                  p_fac1    轉換率   imgg對ima25的轉換率
#                  p_azp03
# Return code....: '1'   no ok
#                  '0'   ok
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980094 09/09/09 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷 
# Modify.........: No.FUN-AB0011 10/10/05 By huangtao 修改return值

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_madd_imgg(p_item,p_ware,p_loc,p_lot,p_unit,
                    #p_fac,p_no,p_line,p_fac1,p_azp03) #FUN-980094 
                     p_fac,p_no,p_line,p_fac1,p_azp01) #FUN-980094 
DEFINE
    p_item     LIKE imgg_file.imgg01,
    p_ware     LIKE imgg_file.imgg02,
    p_loc      LIKE imgg_file.imgg03,
    p_lot      LIKE imgg_file.imgg04,
    p_unit     LIKE imgg_file.imgg07,
    p_fac1     LIKE imgg_file.imgg21,
    p_fac      LIKE imgg_file.imgg211,
    p_azp03    LIKE azp_file.azp03,
    l_azp03    LIKE azp_file.azp03,
    l_ima25    LIKE ima_file.ima25,
    l_imgg21   LIKE imgg_file.imgg21,
    l_sw       LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    p_no       LIKE inb_file.inb01,  
    p_line     LIKE inb_file.inb03,   
    l_imgg     RECORD LIKE imgg_file.*,
    l_ima906   LIKE ima_file.ima906,
    l_ima907   LIKE ima_file.ima907,
    l_msg      LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(200)(200)
    l_sql      LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(600)
    l_flag     LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_img09    LIKE img_file.img09,         #No.TQC-660122                                                                              
    l_imgg211  LIKE imgg_file.imgg211   #No.TQC-660122 
 
DEFINE p_azp01     LIKE azp_file.azp01, #FUN-980094 
       p_azp03_tra LIKE azp_file.azp03  #FUN-980094 
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_item ,p_azp01) OR NOT s_internal_item( p_item,p_azp01 ) THEN
  #      RETURN                              #FUN-AB0011  mark
         RETURN 0                            #FUN-AB0011
    END IF
#FUN-A90049 --------------end-------------------------------------
 
    WHENEVER ERROR CALL cl_err_msg_log
 
   #FUN-980094 ------------------------------(S)
    LET g_plant_new = p_azp01
 
    CALL s_getdbs()
    LET p_azp03 = g_dbs_new
 
    CALL s_gettrandbs()
    LET p_azp03_tra = g_dbs_tra
   #FUN-980094 ------------------------------(E)
 
    LET l_flag = 0
   #LET l_sql="SELECT ima906,ima907 FROM ",p_azp03 CLIPPED,".ima_file",     #TQC-950050 MARK                                        
    #LET l_sql="SELECT ima906,ima907 FROM ",s_dbstring(p_azp03),"ima_file",  #TQC-950050 ADD
    LET l_sql="SELECT ima906,ima907 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102 
              " WHERE ima01='",p_item,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
    PREPARE s_ima_pre FROM l_sql
    DECLARE s_ima_cur  CURSOR FOR s_ima_pre
    OPEN s_ima_cur 
    FETCH s_ima_cur INTO l_ima906,l_ima907
    IF SQLCA.sqlcode OR cl_null(l_ima906) THEN
       CALL cl_err('s_madd_imgg(#chk1)',SQLCA.sqlcode,1)
       LET l_flag = 1
       RETURN 1
    END IF
    INITIALIZE l_imgg.* TO NULL
#   IF cl_null(p_fac)  THEN LET p_fac = 1 END IF  #No.TQC-660122 mark
#   IF p_fac1 = 0 THEN  #No.TQC-660122  mark
      #LET l_sql="SELECT ima25 FROM ",p_azp03 CLIPPED,".ima_file",    #TQC-950050 MARK                                              
       #LET l_sql="SELECT ima25 FROM ",s_dbstring(p_azp03),"ima_file", #TQC-950050 ADD
       LET l_sql="SELECT ima25 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102 
                 " WHERE ima01='",p_item,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102   
       PREPARE s_ima_pre1 FROM l_sql
       DECLARE s_ima_cur1  CURSOR FOR s_ima_pre1
       OPEN s_ima_cur1 
       FETCH s_ima_cur1 INTO l_ima25
       IF SQLCA.sqlcode OR cl_null(l_ima25) THEN 
          CALL cl_err('sel ima',SQLCA.sqlcode,1)
          RETURN 1
       END IF
      #FUN-980094 ------------------------------(S)
      #LET l_azp03 = s_madd_img_catstr(p_azp03)
      #CALL s_umfchk1(p_item,p_unit,l_ima25,l_azp03)
      #     RETURNING l_sw,l_imgg21
      #--------------------------------------------
       CALL s_umfchk1(p_item,p_unit,l_ima25,p_azp01)
            RETURNING l_sw,l_imgg21
      #FUN-980094 ------------------------------(E)
       IF l_sw  = 1 AND NOT (l_ima906='3' AND p_unit = l_ima907) THEN
          CALL cl_err('imgg09/ima25','mfg3075',1)
          RETURN 1
       END IF
       LET p_fac1 = l_imgg21
#   END IF  #No.TQC-660122  mark
    #No.TQC-660122 --start--
  # LET l_sql="SELECT img09 FROM ",p_azp03 CLIPPED,".dbo.img_file",      #TQC-950050 MARK                                               
   #FUN-980094 ------------------------------(S)
   #LET l_sql="SELECT img09 FROM ",s_dbstring(p_azp03),"img_file",   #TQC-950050 ADD     
    #LET l_sql="SELECT img09 FROM ",s_dbstring(p_azp03_tra),"img_file",   #TQC-950050 ADD
   LET l_sql="SELECT img09 FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102    
   #FUN-980094 ------------------------------(E)
              " WHERE img01='",p_item,"'",
              "   AND img02='",p_ware,"'",
              "   AND img03='",p_loc,"'",
              "   AND img04='",p_lot,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-980094
   
    PREPARE s_img_pre1 FROM l_sql
    DECLARE s_img_cur1  CURSOR FOR s_img_pre1
    OPEN s_img_cur1 
    FETCH s_img_cur1 INTO l_img09
    IF SQLCA.sqlcode OR cl_null(l_img09) THEN 
       CALL cl_err('sel img',SQLCA.sqlcode,1)
       RETURN 1
    END IF
   #FUN-980094 ------------------------------(S)
   #LET l_azp03 = s_madd_img_catstr(p_azp03)
   #CALL s_umfchk1(p_item,p_unit,l_img09,l_azp03)
   #     RETURNING l_sw,l_imgg211
   #-------------------------------------------
    CALL s_umfchk1(p_item,p_unit,l_img09,p_azp01)
         RETURNING l_sw,l_imgg211
   #FUN-980094 ------------------------------(E)
    IF l_sw  = 1 AND NOT (l_ima906='3' AND p_unit = l_ima907) THEN
       CALL cl_err('imgg09/img09','mfg3075',1)
       RETURN 1
    END IF
    LET p_fac = l_imgg211
    IF cl_null(p_fac) THEN LET p_fac = 1 END IF
    #No.TQC-660122 --end--
    IF cl_null(p_fac1) THEN LET p_fac1 = 1 END IF
    IF l_ima906 = '2' THEN LET l_imgg.imgg00='1' END IF
    IF l_ima906 = '3' THEN LET l_imgg.imgg00='2' END IF
    LET l_imgg.imgg01=p_item
    LET l_imgg.imgg02=p_ware
    LET l_imgg.imgg03=p_loc
    LET l_imgg.imgg04=p_lot
    LET l_imgg.imgg05=p_no
    LET l_imgg.imgg06=p_line
    LET l_imgg.imgg09=p_unit
    LET l_imgg.imgg10=0
    LET l_imgg.imgg20=1
    LET l_imgg.imgg21=p_fac1
    LET l_imgg.imgg211=p_fac
 
    LET l_imgg.imggplant=p_azp01 #FUN-980012 add
    CALL s_getlegal(p_azp01) RETURNING l_imgg.imgglegal #FUN-980012 add
   
  # LET l_sql=" INSERT INTO ",p_azp03 CLIPPED,".imgg_file VALUES",     #TQC-950050 MARK                                             
   #FUN-980094 ------------------------------(S)
   #LET l_sql=" INSERT INTO ",s_dbstring(p_azp03),"imgg_file VALUES",  #TQC-950050 ADD  
    #LET l_sql=" INSERT INTO ",s_dbstring(p_azp03_tra),"imgg_file VALUES",  #TQC-950050 ADD
   LET l_sql=" INSERT INTO ",cl_get_target_table(g_plant_new,'imgg_file'),"  VALUES ", #FUN-A50102     
   #FUN-980094 ------------------------------(E)
              "(?,?,?,?,?,?,?,?,?,?,",
              " ?,?,?,?,?,?,?,?,?,?,",
              " ?,?,?,?,?,?,?,?,?,?,",
              " ?,?,?,?,?,?,?,?,  ?,?)"     #FUN-980012 add
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102     
    PREPARE s_ins_imgg_pre   FROM l_sql
    EXECUTE s_ins_imgg_pre   USING l_imgg.*
    IF SQLCA.sqlcode THEN
       CALL cl_getmsg('asm-300',g_lang) RETURNING l_msg
       CALL cl_err('s_madd_imgg'||l_msg CLIPPED,SQLCA.sqlcode,1)
       LET l_flag = 1
    END IF
    RETURN l_flag
 
END FUNCTION
