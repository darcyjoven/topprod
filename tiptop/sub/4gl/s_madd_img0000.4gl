# Prog. Version..: '5.30.07-13.06.07(00002)'     #
#
# Pattern name...: s_madd_img.4gl
# Descriptions...: 新增倉庫庫存明細檔(img_file)
# Date & Author..: No.FUN-BC0048 12/12/26  By nanbing
# Usage..........: CALL s_madd_img0000(p_img01,p_img02,p_img03,p_img04,p_img05,
#                                  p_img06,p_date,p_plant) 
# Input Parameter: p_img01   料號 
#                  p_img02   倉庫 
#                  p_img03   儲位 
#                  p_img04   批號 
#                  p_img05   參考號碼 
#                  p_img06   序號
#                  p_date    單據日期
#                  p_plant   機構別
# Return code....: 
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"   
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose      #No.FUN-680147 SMALLINT
FUNCTION s_madd_img0000(p_img01,p_img02,p_img03,p_img04,p_img05,p_img06,
                    p_date,p_plant)  
   DEFINE p_img01      LIKE img_file.img01
   DEFINE p_img02      LIKE img_file.img02
   DEFINE p_img03      LIKE img_file.img03
   DEFINE p_img04      LIKE img_file.img04
   DEFINE p_img05      LIKE img_file.img05
   DEFINE p_img06      LIKE img_file.img06
   DEFINE p_date       LIKE type_file.dat             
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ima71      LIKE ima_file.ima71
   DEFINE p_azp03      LIKE azp_file.azp03
   DEFINE p_azp01      LIKE azp_file.azp01    
   DEFINE l_azp03      LIKE azp_file.azp03
   DEFINE l_dbs        LIKE azp_file.azp03     
   DEFINE l_azp01      LIKE azp_file.azp01    
   DEFINE l_gfe02      LIKE gfe_file.gfe02
   DEFINE l_pja02      LIKE pja_file.pja02
   DEFINE l_row,l_col  LIKE type_file.num5            
   DEFINE l_sql        LIKE type_file.chr1000          
   DEFINE p_plant      LIKE type_file.chr20           
   DEFINE l_cnt        LIKE type_file.num5             
  
    IF s_joint_venture( p_img01,p_plant) OR NOT s_internal_item( p_img01,p_plant ) THEN
        RETURN
    END IF

   INITIALIZE l_img.* TO NULL             
   LET l_img.img01=p_img01                     #料號
   LET l_img.img02=p_img02                     #倉庫
   LET l_img.img03=p_img03                     #儲位
   LET l_img.img04=p_img04                     #批號
   LET l_img.img05=p_img05                     #參號單號
   LET l_img.img06=p_img06                     
 
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET p_azp03 = g_dbs_new
   LET l_dbs = g_dbs_tra
   LET p_azp01 = p_plant 

 
   # 檢查是否有相對應的倉庫/儲位資料存在,若無則自動新增一筆資料
   CALL s_locchk1(p_img01,p_img02,p_img03,p_plant)    
        RETURNING g_i,l_img.img26
   IF g_i = 0 THEN LET g_errno='N' RETURN END IF
 
   LET l_sql="SELECT ima25,ima71 FROM ",cl_get_target_table(p_plant,'ima_file'), 
             " WHERE ima01='",l_img.img01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              							

   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql         
   PREPARE s_ima_pre  FROM l_sql
   DECLARE s_ima_cur  CURSOR FOR s_ima_pre
   OPEN s_ima_cur
   FETCH s_ima_cur INTO l_img09,l_ima71 
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
   LET l_img.img09 =l_img09                     #庫存單位
   LET l_img.img10 =0                           #庫存數量
   LET l_img.img17 =p_date
   LET l_img.img13 =null                        
   IF l_ima71 =0  THEN
      LET l_img.img18=g_lastdat               #有效日期
   ELSE
      LET l_img.img13=p_date                 
      LET l_img.img18=p_date  + l_ima71
   END IF
   LET l_sql="SELECT ime04,ime05,ime06,ime07,ime09",
             " FROM ",cl_get_target_table(p_plant,'ime_file'),   
             " WHERE ime01='",p_img02,"'",
             "   AND ime02='",p_img03,"'",
             "   AND imeacti = 'Y' "   #FUN-D40103
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              						

   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  
   PREPARE s_ime_pre FROM l_sql
   DECLARE s_ime_cur  CURSOR FOR s_ime_pre 
   OPEN s_ime_cur 
   FETCH s_ime_cur  INTO l_img.img22, l_img.img23, l_img.img24, 
                         l_img.img25, l_img.img26
   
   IF SQLCA.sqlcode  THEN
      LET l_sql = "SELECT imd10,imd11,imd12,imd13,imd08 ",
                  " FROM ",cl_get_target_table(p_plant,'imd_file'),   
                  " WHERE imd01='",p_img02,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              						

      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
      PREPARE s_imd_pre FROM l_sql
      DECLARE s_imd_cur  CURSOR FOR s_imd_pre 
      OPEN s_imd_cur 
      FETCH s_imd_cur  INTO l_img.img22, l_img.img23, l_img.img24, 
                            l_img.img25, l_img.img26
      IF SQLCA.SQLCODE THEN
         LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
         LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
      END IF
   END IF
   LET l_img.img20=1          LET l_img.img21=1  
   LET l_img.img30=0          LET l_img.img31=0
   LET l_img.img32=0          LET l_img.img33=0
   LET l_img.img34=1          LET l_img.img37=p_date 
   LET g_errno=' '
   
   IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
   IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
   IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
   IF l_ima71 = 0 THEN LET l_img.img18=g_lastdat END IF  
   LET l_img.imgplant = p_plant  
   SELECT azw02 INTO l_img.imglegal FROM azw_file WHERE azw01=g_plant_new  


   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'img_file'),
               " WHERE img01 = '",l_img.img01,"'",
               "   AND img02 = '",l_img.img02,"'",
               "   AND img03 = '",l_img.img03,"'",
               "   AND img04 = '",l_img.img04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                    
   CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql     
   PREPARE img_pre_1 FROM l_sql
   EXECUTE img_pre_1 INTO l_cnt                      
   IF l_cnt = 0 THEN  
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'img_file'),"(",  
                "img01,img02,img03,img04,img05,img06,img07,img08,img09,img10,",
                "img11,img12,img13,img14,img15,img16,img17,img18,img19,img20,",
                "img21,img22,img23,img24,img25,img26,img27,img28,img30,img31,",
                "img32,img33,img34,img35,img36,img37,img38,imgplant,imglegal) VALUES", 
       " (?,?,?,?,?,?,?,?,?,?,
          ?,?,?,?,?,?,?,?,?,?,
          ?,?,?,?,?,?,?,?,?,?,
          ?,?,?,?,?,?,?,?,?)"    

      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             					

      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
      PREPARE s_ins_img_pre   FROM l_sql
      EXECUTE s_ins_img_pre   USING l_img.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('ins img: ',SQLCA.SQLCODE,1)
         LET g_errno='N' 
      END IF
   END IF     
END FUNCTION
#FUN-BC0048
