# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_tlfidle.4gl
# Descriptions...: 將呆滯日期寫回異動記錄檔中
# Date & Author..: 96/08/31 By Claire
# Usage..........: CALL s_tlfidle(p_dbs_new,p_tlf)
# Input Parameter: p_dbs_new      
#                  p_tlf    
# Return Code....: None
# Modify.........: No.MOD-780264 07/08/31 by Claire
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: NO.FUN-980094 09/09/15 By TSD.hoho 跨DB的VIEW語法修改
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/10/05 By huangtao 修改return值 

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#MOD-780264 
#FUNCTION s_tlfidle(p_dbs_new,p_tlf)
FUNCTION s_tlfidle(p_plant,p_tlf)   #FUN-980094
DEFINE  p_dbs_new       LIKE type_file.chr21,
        p_dbs_tra       LIKE type_file.chr21,   #FUN-980094
        p_tlf           RECORD LIKE tlf_file.*,
        l_slip          LIKE smy_file.smyslip, 
        l_oay12         LIKE oay_file.oay12,
        l_smy56         LIKE smy_file.smy56,
        l_img37         LIKE img_file.img37,
        l_ima902        LIKE ima_file.ima902,
        #l_sql           LIKE type_file.chr1000 
        l_sql          STRING      #NO.FUN-910082       
DEFINE  p_plant        LIKE type_file.chr20  #FUN-980094
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   #LET g_plant_new = p_plant CLIPPED   #FUN-A50102
   #CALL s_getdbs()
   #LET p_dbs_new = g_dbs_new 
 
   #CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   #LET p_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_tlf.tlf01 ,p_plant) OR NOT s_internal_item( p_tlf.tlf01,p_plant ) THEN
  #     RETURN                                         #FUN-AB0011  mark
        RETURN 1                                       #FUN-AB0011
    END IF
#FUN-A90049 --------------end-------------------------------------
 
   LET l_oay12=' '
   LET l_smy56=' '
   LET l_slip =p_tlf.tlf905[1,g_doc_len] 
   
   IF p_tlf.tlf02=50 OR p_tlf.tlf03=50 THEN
       
     #LET l_sql="SELECT img37  FROM ",p_dbs_new CLIPPED," img_file",
      #LET l_sql="SELECT img37  FROM ",p_dbs_tra CLIPPED," img_file", #FUN-980094
      LET l_sql="SELECT img37  FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                " WHERE img01='",p_tlf.tlf01,"'",
                "   AND img02='",p_tlf.tlf902,"'",
                "   AND img03='",p_tlf.tlf903,"'",
                "   AND img04='",p_tlf.tlf904,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
      PREPARE img_pre FROM l_sql
      DECLARE img_cs CURSOR FOR img_pre          
      OPEN img_cs
      FETCH img_cs INTO l_img37
      IF STATUS THEN LET l_img37='' END IF
 
      #LET l_sql="SELECT ima902  FROM ",p_dbs_new CLIPPED," ima_file",
      LET l_sql="SELECT ima902  FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                " WHERE ima01='",p_tlf.tlf01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE ima_pre FROM l_sql
      DECLARE ima_cs CURSOR FOR ima_pre          
      OPEN ima_cs
      FETCH ima_cs INTO l_ima902
      IF STATUS THEN LET l_ima902='' END IF
 
      IF p_tlf.tlf13 MATCHES 'axmt*' THEN
         LET l_sql="" 
         #LET l_sql="SELECT oay12 FROM ",p_dbs_new CLIPPED,"oay_file",
        LET l_sql="SELECT oay12 FROM ",cl_get_target_table(p_plant,'oay_file'), #FUN-A50102
                   " WHERE oayslip='",l_slip,"'"   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         PREPARE oay_pre FROM l_sql
         DECLARE oay_cs CURSOR FOR oay_pre          
         OPEN oay_cs
         FETCH oay_cs INTO l_oay12
         IF STATUS THEN LET l_oay12='' END IF          
         IF l_oay12='Y' THEN
            IF p_tlf.tlf06>l_ima902 OR l_ima902 IS NULL THEN
               LET l_sql=""
               #LET l_sql="UPDATE ",p_dbs_new CLIPPED,"ima_file",
               LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                         "   SET ima902 = ? WHERE ima01= ? "
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE upd_ima1 FROM l_sql
               EXECUTE upd_ima1 USING p_tlf.tlf06,p_tlf.tlf01 
               IF SQLCA.sqlcode<>0 THEN 
                  LET g_success = 'N' 
                  CALL cl_err3("upd","ima_file",p_tlf.tlf01,"",STATUS,"","",1) RETURN 0  
               END IF
            END IF
            IF p_tlf.tlf06>l_img37 OR l_img37 IS NULL THEN
               LET l_sql=""
              #LET l_sql="UPDATE ",p_dbs_new CLIPPED,"img_file",
               #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"img_file",  #FUN-980094
               LET l_sql="UPDATE ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                         "   SET img37 = ? ",
                         " WHERE img01=? AND img02 = ? ",
                         "   AND img03=? AND img04 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
               PREPARE upd_img1 FROM l_sql
               EXECUTE upd_img1 USING p_tlf.tlf06,p_tlf.tlf01,
                                      p_tlf.tlf902,p_tlf.tlf903,p_tlf.tlf904 
               IF SQLCA.sqlcode<>0 THEN 
                  LET g_success = 'N' 
                  CALL cl_err3("upd","img_file",p_tlf.tlf01,"",STATUS,"","",1) RETURN 0  
               END IF   
            END IF
         END IF
      ELSE
         LET l_sql="" 
         #LET l_sql="SELECT smy56 FROM ",p_dbs_new CLIPPED,"smy_file",
        LET l_sql="SELECT smy56 FROM ",cl_get_target_table(p_plant,'smy_file'), #FUN-A50102
                   " WHERE smyslip='",l_slip,"'"   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         PREPARE smy_pre FROM l_sql
         DECLARE smy_cs CURSOR FOR smy_pre          
         OPEN smy_cs
         FETCH smy_cs INTO l_smy56
         IF STATUS THEN LET l_smy56='' END IF   
         IF l_smy56='Y' THEN         
            IF p_tlf.tlf06>l_ima902 OR l_ima902 IS NULL THEN
               LET l_sql=""
               #LET l_sql="UPDATE ",p_dbs_new CLIPPED,"ima_file",
               LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                         "   SET ima902 = ? WHERE ima01= ? "
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE upd_ima2 FROM l_sql
               EXECUTE upd_ima2 USING p_tlf.tlf06,p_tlf.tlf01 
               IF SQLCA.sqlcode<>0 THEN 
                  LET g_success = 'N' 
                  CALL cl_err3("upd","ima_file",p_tlf.tlf01,"",STATUS,"","",1) RETURN 0  
               END IF 
            END IF          
            IF p_tlf.tlf06>l_img37 OR l_img37 IS NULL THEN
               LET l_sql=""
              #LET l_sql="UPDATE ",p_dbs_new CLIPPED,"img_file",
               #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"img_file",
               LET l_sql="UPDATE ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                         "   SET img37 = ? ",
                         " WHERE img01=? AND img02 = ? ",
                         "   AND img03=? AND img04 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
               PREPARE upd_img2 FROM l_sql
               EXECUTE upd_img2 USING p_tlf.tlf06,p_tlf.tlf01,
                                      p_tlf.tlf902,p_tlf.tlf903,p_tlf.tlf904 
               IF SQLCA.sqlcode<>0 THEN 
                  LET g_success = 'N' 
                  CALL cl_err3("upd","img_file",p_tlf.tlf01,"",STATUS,"","",1) RETURN 0  
               END IF 
            END IF
         END IF
      END IF
   END IF
   RETURN 1	# TRUE -> OK
END FUNCTION
 
