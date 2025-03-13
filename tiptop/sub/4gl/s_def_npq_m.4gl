# Prog. Version..: '5.30.06-13.03.15(00010)'     #
#
# Program name...: s_def_npq_m.4gl
# Descriptions...: 依彈性設定預設異動碼值(跨庫)
# Date & Author..: 
# Modify.........: No.CHI-760003 07/08/14 By wujie 
#                  摘要抓取順序:
#                  1.若此單據已有輸入摘要,則以此摘要為主.
#                  2.若單據沒帶出摘要,則抓取分錄底稿預設摘要
#                  3.若前2項都沒有,則帶出參數設定(目前只有AAP才有參數設定)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690105 06/09/29 By Sarah s_def_npq2()段,當第一次用所有key去抓不到資料時,只用p_key1當key再抓一次
# Modify.........: No.MOD-720015 07/02/05 By Smapmin 若摘要為日期欄位,將顯示格式改為YY/MM/DD
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-960085 09/07/30 By hongmei select ahh_file 時加入ahh00
# Modify.........: No.FUN-980059 09/09/07 By arman  將傳入的DB變數改成plant變數
# Modify.........: NO.MOD-980188 09/10/30 BY yiting  在程式傳入帳別參數抓取ahh_file資料時沒有接到g_bookno的值
# Modify.........: No.TQC-9C0099 09/12/15 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A50016 10/05/06 by rainy cl_get_column_info傳入參數修改
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-B20136 11/02/23 By lilingyu l_file長度定義過短
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:TQC-B80135 11/08/18 By Dido 多檔案時需重組 l_file 
# Modify.........: No:MOD-C20001 12/02/03 By Polly 增加判斷，當p_key2/p_key3不為null時，才串入條件中
# Modify.........: No:MOD-C70253 12/08/07 By Vampire CALL cl_get_target_table時,第二個參數值請增加定義一個變數型態gat01去接傳值
# Modify.........: No:TQC-C80154 12/08/30 By SunLM 添加'LEFT'字符串截位
# Modify.........: No:FUN-C90061 12/09/13 By wuxj  當為大陸版時，該科目做核算項一管理且做客商管理時，則核算項一為npq2
# Modify.........: No:MOD-D40161 13/04/23 By Vampire 添加'LEFT'字符串截位
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_def_npq_m(p_ahf01,p_ahf02,p_npq,p_key1,p_key2,p_key3,p_bookno,p_dbs)  #No.FUN-730020
FUNCTION s_def_npq_m(p_ahf01,p_ahf02,p_npq,p_key1,p_key2,p_key3,p_bookno,p_plant)  #No.FUN-730020  #NO.FUN-980059
DEFINE p_ahf01    LIKE ahf_file.ahf01      # 科目  
DEFINE p_ahf02    LIKE ahf_file.ahf02      # 程式代號  傳 g_prog
DEFINE p_npq      RECORD LIKE npq_file.*   # 
DEFINE p_key1     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 單號 exe g_apa.apa01
DEFINE p_key2     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 預留
DEFINE p_key3     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 預留
DEFINE p_dbs      LIKE type_file.chr21
DEFINE p_plant    LIKE type_file.chr21     #No.FUN-980059
DEFINE p_bookno   LIKE aag_file.aag00      #No.FUN-730020
DEFINE l_aag      RECORD LIKE aag_file.*   # 
DEFINE l_ahf      RECORD LIKE ahf_file.*   # 
DEFINE l_sql      STRING   #No.FUN-680147 VARCHAR(2000)   #TQC-B80135 mod chr1000 -> STRING
DEFINE l_cnt      LIKE type_file.num5      #No.FUN-680147 SMALLINT
DEFINE l_seq      LIKE type_file.num5      #No.FUN-680147 SMALLINT
DEFINE l_aaz88    LIKE type_file.num5      #No.CHI-760003 SMALLINT
DEFINE l_aaz125   LIKE type_file.num5      #No.FUN-B50105 Add
DEFINE p_ahf00    LIKE ahf_file.ahf00      # 帳別 #CHI-960085 add
DEFINE l_i        LIKE type_file.num5      #No.FUN-C90061 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   ##NO.FUN-980059 GP5.2 add begin
   #IF cl_null(p_plant) THEN   #FUN-A50102
   #  LET p_dbs = NULL
   #ELSE
     LET g_plant_new = p_plant
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #END IF
   ##NO.FUN-980059 GP5.2 add end
   IF cl_null(p_npq.npq04) THEN   #FUN-640117 add
      LET p_ahf00 = p_bookno   #MOD-980188
      #抓取分錄底稿預設摘要
     #CALL s_def_npq3_m(p_ahf00,p_ahf01,p_ahf02,p_key1,p_key2,p_key3,p_dbs)  #摘要 #CHI-960085 add p_ahf00 #TQC-9C0099
      CALL s_def_npq3_m(p_ahf00,p_ahf01,p_ahf02,p_key1,p_key2,p_key3,p_plant)  #摘要 #CHI-960085 add p_ahf00#TQC-9C0099
      RETURNING p_npq.npq04
   END IF                         #FUN-640117 add
 
   #將上一科目的預設值清空
   LET p_npq.npq11=''
   LET p_npq.npq12=''
   LET p_npq.npq13=''
   LET p_npq.npq14=''
   LET p_npq.npq31=''
   LET p_npq.npq32=''
   LET p_npq.npq33=''
   LET p_npq.npq34=''
   LET p_npq.npq35=''
   LET p_npq.npq36=''
   LET p_npq.npq37=''
#No.FUN-C90061  ---begin---
   IF g_aza.aza26 = '2' THEN
      LET l_sql = " SELECT COUNT(*)  FROM ",cl_get_target_table(p_plant,'aag_file'),
                  "  WHERE aag00 = '",p_bookno,"'",
                  "    AND aag01 = '",p_ahf01,"'",
                  "    AND aag43 = 'Y' AND aag151 IS NOT NULL"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
      PREPARE aag_pre1 FROM l_sql
      EXECUTE aag_pre1 INTO l_i
   END IF
#No.FUN-C90061  ---end--- 
#No.CHI-760003 --start--                                                                                                            
#  SELECT COUNT(*) INTO l_cnt   FROM ahf_file                                                                                       
#   WHERE ahf01=p_ahf01                                                                                                             
#     AND ahf02=p_ahf02                                                                                                             
#     AND ahf00=p_bookno  #No.FUN-730020
   #LET l_sql = "SELECT COUNT(*) FROM ",p_dbs,"ahf_file",
  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102  
               " WHERE ahf01 = '",p_ahf01,"'",                                                                                      
               "   AND ahf02 = '",p_ahf02,"'",
               "   AND ahf00 = '",p_bookno,"'"                                                                                       
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE ahf_p1 FROM l_sql                                                                                                        
   DECLARE ahf_c1 CURSOR FOR ahf_p1                                                                                                 
   OPEN ahf_c1                                                                                                                      
   FETCH ahf_c1 INTO l_cnt                                                                                                          
#No.CHI-760003 --end--  
   IF l_cnt = 0 THEN 
#No.FUN-C90061  ---begin---
      IF g_aza.aza26 = '2' AND l_i > 0  THEN
         LET p_npq.npq11 = p_npq.npq21
      END IF
#No.FUN-C90061  ---end--
      RETURN p_npq.*
   END IF
 
#No.CHI-760003 --start--                                                                                                            
   #LET l_sql = "SELECT aaz88 FROM ",p_dbs,"aaz_file"
   LET l_sql = "SELECT aaz88 FROM ",cl_get_target_table(p_plant,'aaz_file') #FUN-A50102  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE aaz_p1 FROM l_sql                                                                                                        
   DECLARE aaz_c1 CURSOR FOR aaz_p1                                                                                                 
   OPEN aaz_c1                                                                                                                      
   FETCH aaz_c1 INTO l_aaz88                                                                                                        
   FOR l_seq = 1 TO l_aaz88                                                                                                         
#  FOR l_seq = 1 TO g_aaz.aaz88                                                                                                     
#No.CHI-760003 --end-- 
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
#No.CHI-760003 --start--                                                                                                            
#    SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_npq.npq03                                                                    
#                                          AND aag00=p_bookno  #No.FUN-730020
     #LET l_sql = "SELECT * FROM ",p_dbs,"aag_file",
     LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102       
                 " WHERE aag01 = '",p_npq.npq03,"'",                                                                                
                 "   AND aag00 = '",p_bookno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE aag_p1 FROM l_sql                                                                                                      
     DECLARE aag_c1 CURSOR FOR aag_p1                                                                                               
     OPEN aag_c1                                                                                                                    
     FETCH aag_c1 INTO l_aag.*                                                                                                      
#No.CHI-760003 --end-- 
     CASE l_seq
#No.CHI-760003 --start--                                                                                                            
#       WHEN 1  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='1'                                                                
#                  AND ahf00=p_bookno  #No.FUN-730020
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 1  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file", 
        WHEN 1  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102       
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '1' ",
                            "   AND ahf00 = '",p_bookno,"'"                                                                                 
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p01 FROM l_sql                                                                                          
                DECLARE ahf_c01 CURSOR FOR ahf_p01                                                                                  
                OPEN ahf_c01                                                                                                        
                FETCH ahf_c01 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)   #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant) #TQC-9C0099
#No.CHI-760003 --end--  
                RETURNING p_npq.npq11
                
#No.CHI-760003 --start--                                                                                                            
#       WHEN 2  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='2'                                                                
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 2  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file",
        WHEN 2  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102   
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '2' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p02 FROM l_sql                                                                                          
                DECLARE ahf_c02 CURSOR FOR ahf_p02                                                                                  
                OPEN ahf_c02                                                                                                        
                FETCH ahf_c02 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)   #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant) #TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq12
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 3  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='3'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 3  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file",
        WHEN 3  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102           
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '3' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p03 FROM l_sql                                                                                          
                DECLARE ahf_c03 CURSOR FOR ahf_p03                                                                                  
                OPEN ahf_c03                                                                                                        
                FETCH ahf_c03 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)  #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant)#TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq13
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 4  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='4'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 4  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file", 
        WHEN 4  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102     
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '4' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p04 FROM l_sql                                                                                          
                DECLARE ahf_c04 CURSOR FOR ahf_p04                                                                                  
                OPEN ahf_c04                                                                                                        
                FETCH ahf_c04 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)  #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant)#TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq14

#FUN-B50105   ---start   Add
     END CASE
   END FOR
   LET l_sql = "SELECT aaz125 FROM ",cl_get_target_table(p_plant,'aaz_file')
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE aaz_p2 FROM l_sql
   DECLARE aaz_c2 CURSOR FOR aaz_p2
   OPEN aaz_c2
   FETCH aaz_c2 INTO l_aaz125
   FOR l_seq = 1 TO l_aaz125
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
     LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'aag_file'),
                 " WHERE aag01 = '",p_npq.npq03,"'",
                 "   AND aag00 = '",p_bookno,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
     PREPARE aag_p2 FROM l_sql
     DECLARE aag_c2 CURSOR FOR aag_p2
     OPEN aag_c2
     FETCH aag_c2 INTO l_aag.*
     CASE l_seq
#FUN-B50105   ---end     Add
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 5  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='5'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 5  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file",
        WHEN 5  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102        
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '5' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p05 FROM l_sql                                                                                          
                DECLARE ahf_c05 CURSOR FOR ahf_p05                                                                                  
                OPEN ahf_c05                                                                                                        
                FETCH ahf_c05 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)  #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant)#TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq31
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 6  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='6'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 6  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file",
        WHEN 6  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102       
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '6' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p06 FROM l_sql                                                                                          
                DECLARE ahf_c06 CURSOR FOR ahf_p06                                                                                  
                OPEN ahf_c06                                                                                                        
                FETCH ahf_c06 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)   #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant) #TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq32
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 7  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='7'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 7  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file", 
        WHEN 7  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102 
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '7' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p07 FROM l_sql                                                                                          
                DECLARE ahf_c07 CURSOR FOR ahf_p07                                                                                  
                OPEN ahf_c07                                                                                                        
                FETCH ahf_c07 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)  #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant)#TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq33
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 8  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='8'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 8  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file",
        WHEN 8  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102     
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '8' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p08 FROM l_sql                                                                                          
                DECLARE ahf_c08 CURSOR FOR ahf_p08                                                                                  
                OPEN ahf_c08                                                                                                        
                FETCH ahf_c08 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)  #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant)#TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq34
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 9  SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='9'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 9  LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file",
        WHEN 9  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102          
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '9' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p09 FROM l_sql                                                                                          
                DECLARE ahf_c09 CURSOR FOR ahf_p09                                                                                  
                OPEN ahf_c09                                                                                                        
                FETCH ahf_c09 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)   #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant) #TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq35
 
#No.CHI-760003 --start--                                                                                                            
#       WHEN 10 SELECT * INTO l_ahf.* FROM ahf_file                                                                                 
#                WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='10'
#                  AND ahf00=p_bookno  #No.FUN-730020                                                                               
#               CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                           
        #WHEN 10 LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file", 
        WHEN 10 LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102       
                            " WHERE ahf01 = '",p_ahf01,"'",                                                                         
                            "   AND ahf02 = '",p_ahf02,"'",                                                                         
                            "   AND ahf03 = '10' ",                                                                                  
                            "   AND ahf00 = '",p_bookno,"'"                                                                         
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ahf_p10 FROM l_sql                                                                                          
                DECLARE ahf_c10 CURSOR FOR ahf_p10                                                                                  
                OPEN ahf_c10                                                                                                        
                FETCH ahf_c10 INTO l_ahf.*                                                                                          
               #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)  #TQC-9C0099
                CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant)#TQC-9C0099
#No.CHI-760003 --end-- 
                RETURNING p_npq.npq36
     END CASE
   END FOR
   #for 關係人
   INITIALIZE l_ahf.* TO NULL
#No.CHI-760003 --start--                                                                                                            
#  SELECT * INTO l_ahf.* FROM ahf_file                                                                                              
#   WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='99'                                                                            
#     AND ahf00=p_bookno  #No.FUN-730020
#  CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)                                                                        
   #LET l_sql = "SELECT * FROM ",p_dbs,"ahf_file",
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahf_file'), #FUN-A50102 
               " WHERE ahf01 = '",p_ahf01,"'",                                                                                      
               "   AND ahf02 = '",p_ahf02,"'",                                                                                      
               "   AND ahf03 = '99' ", 
               "   AND ahf00 = '",p_bookno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE ahf_p99 FROM l_sql                                                                                                       
   DECLARE ahf_c99 CURSOR FOR ahf_p99                                                                                               
   OPEN ahf_c99                                                                                                                     
   FETCH ahf_c99 INTO l_ahf.*                                                                                                       
  #CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_dbs)  #TQC-9C0099                                                               
   CALL s_def_npq2_m(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3,p_plant)#TQC-9C0099                                                                
#No.CHI-760003 --end--  
   RETURNING p_npq.npq37
#No.FUN-C90061  ---begin---
   IF g_aza.aza26 = '2' AND l_i > 0  THEN
      LET p_npq.npq11 = p_npq.npq21
   END IF
#No.FUN-C90061  ---end---
   RETURN p_npq.*
END FUNCTION
 
#FUNCTION s_def_npq2_m(p_ahf02,p_ahf04,p_key1,p_key2,p_key3,p_dbs)  #No.CHI-76000 #TQC-9C0099
FUNCTION s_def_npq2_m(p_ahf02,p_ahf04,p_key1,p_key2,p_key3,p_plant)  #No.CHI-76000#TQC-9C0099
DEFINE p_ahf02    LIKE ahf_file.ahf02      # 程式代號
DEFINE p_ahf04    LIKE ahf_file.ahf04      # 欄位
DEFINE p_key1     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)     # 單號 exe g_apa.apa01
DEFINE p_key2     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)
DEFINE p_key3     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)
DEFINE p_dbs      LIKE type_file.chr21     #No.CHI-760003 
DEFINE p_plant    LIKE type_file.chr21     #No.TQC-9C0099 
#DEFINE l_file    LIKE ahf_file.ahf04      #No.FUN-680147 VARCHAR(15)     # 檔案編號            #MOD-B20136
 DEFINE l_file    LIKE type_file.chr1000                                                        #MOD-B20136
DEFINE l_key1     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)     # key值欄位1 ex:apa01
DEFINE l_key2     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)     # key值欄位2
DEFINE l_key3     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)      # key值欄位3
DEFINE p_npq11    LIKE npq_file.npq11      
DEFINE l_sql      STRING   #No.FUN-680147 VARCHAR(1000)   #TQC-B80135 mod chr1000 -> STRING
DEFINE l_str      STRING                   #TQC-B80135
DEFINE l_str2     STRING                   #TQC-B80135
DEFINE l_leng     LIKE type_file.num5      #TQC-B80135
DEFINE l_pos      LIKE type_file.num5      #TQC-B80135
DEFINE l_fillin      STRING                #TQC-B80135
DEFINE l_filestr  LIKE gat_file.gat01      #MOD-C70253 add
DEFINE l_filestr2 LIKE gat_file.gat01      #MOD-C70253 add
DEFINE l_pos1     LIKE type_file.num5      #TQC-C80154 add
DEFINE l_pos2     LIKE type_file.num5      #TQC-C80154 add
DEFINE l_leng2     LIKE type_file.num5     #TQC-C80154
 
   IF cl_null(p_ahf02) THEN RETURN '' END IF
   IF cl_null(p_ahf04) THEN RETURN '' END IF
   #TQC-9C0099--begin--add--
   #IF cl_null(p_plant) THEN #FUN-A50102
   #  LET p_dbs = NULL
   #ELSE
     LET g_plant_new = p_plant
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #END IF
   #TQC-9C0099--end--add--
   LET l_file=''
   LET l_key1=''
   LET l_key2=''
   LET l_key3=''
   CALL s_prg_tab(p_ahf02)
   RETURNING l_file,l_key1,l_key2,l_key3
  #-TQC-B80135-add-
   LET l_str = l_file 
   LET l_fillin = '' 
   WHILE TRUE
      LET l_leng = l_str.getlength() 
      #LET l_pos = l_str.getindexof(',',1) #TQC-C80154 mark
      #TQC-C80154 add beg---------
      LET l_pos1 = l_str.getindexof(',',1)    #對","取位
      LET l_pos2 = l_str.getindexof('LEFT',1) #對左外連接取位
      IF l_pos1 > 0 THEN 
         IF l_pos1 > l_pos2 THEN
            LET l_pos = l_pos2
         ELSE
            LET l_pos = l_pos1
         END IF
      ELSE 
         LET l_pos = l_pos2
      END IF 
      #TQC-C80154 add end---------  
      IF l_pos = 0 THEN
         LET l_filestr = l_str #MOD-C70253 add
         LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_filestr)  #MOD-C70253 add
         #LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_str) #MOD-C70253 mark 
         EXIT WHILE
      ELSE
         LET l_filestr2 = l_str.substring(1,l_pos-1)                         #MOD-C70253 add
         LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_filestr2),',' #MOD-C70253 add
         #LET l_str2 = l_str.substring(1,l_pos-1)                            #MOD-C70253 mark
         #LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_str2),','    #MOD-C70253 mark 
      END IF
      LET l_str = l_str.substring(l_pos+1,l_leng)
      #TQC-C80154
      #如果只存在left join外連接,那麼退出while
      IF l_pos1 = 0 AND l_pos2 >0 THEN 
      	 LET l_leng2 = l_fillin.getindexof(',',1)-1
      	 LET l_fillin = l_fillin.substring(1,l_leng2)
      	 EXIT WHILE 
      END IF 	    
      #TQC-C80154      
   END WHILE
   LET l_file = l_fillin 
  #-TQC-B80135-end-
   #LET l_sql = " SELECT ",p_ahf04," FROM ",p_dbs,l_file CLIPPED,   #No.CHI-760003
  #LET l_sql = " SELECT ",p_ahf04," FROM ",cl_get_target_table(p_plant,l_file), #FUN-A50102 #TQC-B80135 mark
   LET l_sql = " SELECT ",p_ahf04," FROM ",l_file,                              #TQC-B80135 
               "  WHERE ",l_key1 CLIPPED,"= '",p_key1,"'"
   IF NOT cl_null(l_key2) THEN
       LET l_sql = l_sql CLIPPED,
                   "  AND ",l_key2 CLIPPED,"= '",p_key2,"'"
   END IF
   IF NOT cl_null(l_key3) THEN
       LET l_sql = l_sql CLIPPED,
                   "  AND ",l_key3 CLIPPED,"= '",p_key3,"'"
   END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE get_apa_pre FROM l_sql
   DECLARE get_apa_cs CURSOR FOR get_apa_pre
   OPEN get_apa_cs
   FETCH get_apa_cs INTO p_npq11
  #start FUN-690105 add
   #當抓不到資料時,只用p_key1當key再去抓一次
   IF cl_null(p_npq11) THEN
      LET l_sql = ''
     # LET l_sql = " SELECT ",p_ahf04," FROM ",p_dbs,l_file CLIPPED, #No.CHI-760003 
    #LET l_sql = " SELECT ",p_ahf04," FROM ",cl_get_target_table(p_plant,l_file), #FUN-A50102 #TQC-B80135 mark
     LET l_sql = " SELECT ",p_ahf04," FROM ",l_file,                              #TQC-B80135 
                  "  WHERE ",l_key1 CLIPPED,"= '",p_key1,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE get_apa_pre1 FROM l_sql
      DECLARE get_apa_cs1 CURSOR FOR get_apa_pre1
      OPEN get_apa_cs1
      FETCH get_apa_cs1 INTO p_npq11
   END IF
  #end FUN-690105 add
   RETURN p_npq11
END FUNCTION
 
#FUNCTION s_def_npq3_m(p_ahh00,p_ahh01,p_ahh02,p_key1,p_key2,p_key3,p_dbs) #摘要預設    #No.CHI-760003 #CHI-960085 add p_ahh00 #TQC-9C0099
FUNCTION s_def_npq3_m(p_ahh00,p_ahh01,p_ahh02,p_key1,p_key2,p_key3,p_plant) #摘要預設    #No.CHI-760003 #CHI-960085 add p_ahh00#TQC-9C0099
DEFINE p_ahh00    LIKE ahh_file.ahh00      #帳別  #CHI-960085 add
DEFINE p_ahh01    LIKE ahh_file.ahh01      # 科目
DEFINE p_ahh02    LIKE ahh_file.ahh02      # 程式
DEFINE p_key1     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                # 單號 exe g_apa.apa01
DEFINE p_key2     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                #
DEFINE p_key3     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                #
DEFINE p_dbs      LIKE type_file.chr21     #No.CHI-760003 
DEFINE p_plant    LIKE type_file.chr21     #No.TQC-9C0099 
#DEFINE l_file    LIKE ahf_file.ahf04      #No.FUN-680147 VARCHAR(15)               # 檔案編號        #MOD-B20136
 DEFINE l_file    LIKE type_file.chr1000                                                              #MOD-B20136
DEFINE l_key1     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                # key值欄位1 ex:apa01
DEFINE l_key2     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                # key值欄位2
DEFINE l_key3     LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                # key值欄位3
DEFINE l_ahh      RECORD LIKE ahh_file.*
DEFINE l_sql      STRING   #No.FUN-680147 VARCHAR(1000)   #TQC-B80135 mod chr1000 -> STRING
DEFINE ls_str     STRING                   
DEFINE lc_str     LIKE type_file.chr1000   #No.FUN-680147 VARCHAR(200)
DEFINE lt_str     base.StringTokenizer
DEFINE l_npq04    LIKE npq_file.npq04
DEFINE l_datatype,l_length   STRING   #MOD-720015
DEFINE l_date     LIKE type_file.dat       #MOD-720015
DEFINE l_azw05    LIKE  azw_file.azw05   #FUN-A50016
DEFINE l_str      STRING                   #TQC-B80135
DEFINE l_str2     STRING                   #TQC-B80135
DEFINE l_leng     LIKE type_file.num5      #TQC-B80135
DEFINE l_pos      LIKE type_file.num5      #TQC-B80135
DEFINE l_fillin      STRING                #TQC-B80135
DEFINE l_filestr  LIKE gat_file.gat01      #MOD-C70253 add
DEFINE l_filestr2 LIKE gat_file.gat01      #MOD-C70253 add
DEFINE l_pos1     LIKE type_file.num5      #MOD-D40161 add
DEFINE l_pos2     LIKE type_file.num5      #MOD-D40161 add
DEFINE l_leng2    LIKE type_file.num5      #MOD-D40161 add
  
  IF cl_null(p_ahh00) THEN RETURN '' END IF   #CHI-960085
  IF cl_null(p_ahh01) THEN RETURN '' END IF
  IF cl_null(p_ahh02) THEN RETURN '' END IF
  #TQC-9C0099--begin--add--
   #IF cl_null(p_plant) THEN  #FUN-A50102
   #  LET p_dbs = NULL
   #ELSE
     LET g_plant_new = p_plant
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #END IF
   #TQC-9C0099--end--add--
  INITIALIZE l_ahh.* TO NULL
#No.CHI-760003 --start--                                                                                                            
# SELECT * INTO  l_ahh.* FROM ahh_file                                                                                              
#  WHERE ahh01=p_ahh01                                                                                                              
#    AND ahh02=p_ahh02                                                                                                              
  #LET l_sql = "SELECT * FROM ",p_dbs,"ahh_file",
  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahh_file'), #FUN-A50102 
              " WHERE ahh00 = '",p_ahh00,"'",    #CHI-960085 add 
              "   AND ahh01 = '",p_ahh01,"'",                                                                                       
              "   AND ahh02 = '",p_ahh02,"'"                                                                                        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE ahh_p1 FROM l_sql                                                                                                         
  DECLARE ahh_c1 CURSOR FOR ahh_p1                                                                                                  
  OPEN ahh_c1                                                                                                                       
  FETCH ahh_c1 INTO l_ahh.*                                                                                                         
#No.CHI-760003 --end--  
  IF STATUS THEN RETURN '' END IF
  IF cl_null(l_ahh.ahh03) THEN RETURN '' END IF
  LET l_npq04=''
  LET lt_str=base.StringTokenizer.create(l_ahh.ahh03 CLIPPED, ",")
  WHILE lt_str.hasMoreTokens()
     LET ls_str =''
     LET lc_str =''
     LET ls_str=lt_str.nextToken()
     IF cl_null(ls_str) THEN
        CONTINUE WHILE
     END IF
     LET ls_str=ls_str.trim()
     LET ls_str=ls_str.trimRight()
     IF ls_str.getIndexOf("@",1)  THEN
       LET ls_str=ls_str.subString(2,ls_str.getLength())
       LET l_file=''
       LET l_key1=''
       LET l_key2=''
       LET l_key3=''
       CALL s_prg_tab(p_ahh02)
       RETURNING l_file,l_key1,l_key2,l_key3
      #-TQC-B80135-add-
       LET l_str = l_file 
       LET l_fillin = '' 
       WHILE TRUE
          LET l_leng = l_str.getlength() 
          #LET l_pos = l_str.getindexof(',',1)  #MOD-D40161 mark
         #MOD-D40161 add start -----
          LET l_pos1 = l_str.getindexof(',',1)    #對","取位
          LET l_pos2 = l_str.getindexof('LEFT',1) #對左外連接取位
          IF l_pos1 > 0 THEN
             IF l_pos1 > l_pos2 THEN
                LET l_pos = l_pos2
             ELSE
                LET l_pos = l_pos1
             END IF
          ELSE
             LET l_pos = l_pos2
          END IF
         #MOD-D40161 add end  -----          
          IF l_pos = 0 THEN
             LET l_filestr = l_str #MOD-C70253 add
             LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_filestr) #MOD-C70253 add
             #LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_str)    #MOD-C70253 mark 
             EXIT WHILE
          ELSE
             LET l_filestr2 = l_str.substring(1,l_pos-1)                         #MOD-C70253 add
             LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_filestr2),',' #MOD-C70253 add
             #LET l_str2 = l_str.substring(1,l_pos-1)                            #MOD-C70253 mark
             #LET l_fillin = l_fillin,cl_get_target_table(p_plant,l_str2),','    #MOD-C70253 mark
          END IF
          LET l_str = l_str.substring(l_pos+1,l_leng)
         #MOD-D40161 add start -----
         #如果只存在left join外連接,那麼退出while
          IF l_pos1 = 0 AND l_pos2 >0 THEN
             LET l_leng2 = l_fillin.getindexof(',',1)-1
             LET l_fillin = l_fillin.substring(1,l_leng2)
             EXIT WHILE
          END IF
         #MOD-D40161 add end   -----          
       END WHILE
       LET l_file = l_fillin 
      #-TQC-B80135-end-
       #LET l_sql = " SELECT ",ls_str CLIPPED," FROM ",p_dbs,l_file CLIPPED,  #No.CHI-760003
      #LET l_sql = " SELECT ",ls_str CLIPPED," FROM ",cl_get_target_table(p_plant,l_file), #FUN-A50102 #TQC-B80135 mark
       LET l_sql = " SELECT ",ls_str CLIPPED," FROM ",l_file,                              #TQC-B80135  
                   "  WHERE ",l_key1 CLIPPED,"= '",p_key1,"'"
      #IF NOT cl_null(l_key2) THEN                                    #MOD-C20001 mark
       IF NOT cl_null(l_key2) AND NOT cl_null(p_key2) THEN            #MOD-C20001 add
           LET l_sql = l_sql CLIPPED,
                       "  AND ",l_key2 CLIPPED,"= '",p_key2,"'"
       END IF
      #IF NOT cl_null(l_key3) THEN                                     #MOD-C20001 mark
       IF NOT cl_null(l_key3) AND NOT cl_null(p_key3) THEN             #MOD-C20001 add
           LET l_sql = l_sql CLIPPED,
                       "  AND ",l_key3 CLIPPED,"= '",p_key3,"'"
       END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE get_apa_pre2 FROM l_sql
       DECLARE get_apa_cs2 CURSOR FOR get_apa_pre2
       OPEN get_apa_cs2
       FETCH get_apa_cs2 INTO lc_str
       #-----MOD-720015---------
#FUN-A50016 begin
       CALL s_get_azw05(g_plant) RETURNING l_azw05
       #CALL cl_get_column_info(g_dbs,l_file,ls_str) RETURNING l_datatype,l_length
       CALL cl_get_column_info(l_azw05,l_file,ls_str) RETURNING l_datatype,l_length
#FUN-A50016 end
       IF l_datatype = 'date' THEN
          LET l_date = ''
          LET l_date = lc_str 
          LET l_date = l_date USING 'YY/MM/DD'
          LET lc_str = l_date
       END IF 
       #-----END MOD-720015----- 
       LET l_npq04=l_npq04,' ',lc_str CLIPPED
     ELSE
       LET l_npq04=l_npq04,' ',ls_str CLIPPED
       CONTINUE WHILE
     END IF
  END WHILE
  LET ls_str=l_npq04
  LET ls_str=ls_str.trimLeft()
  LET l_npq04=ls_str CLIPPED
  RETURN l_npq04
END FUNCTION
