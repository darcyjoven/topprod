# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: saxmt400_sub.4gl
# Description....: 提供saxmt400.4gl使用的sub routine/sapcp200_oea.4gl
# Date & Author..: 07/03/05 by kim (FUN-730002)
# Modify.........: No.FUN-A30116 10/04/17 By Cockroach  SQL 改成跨DB
# Modify.........: No.FUN-A50102 10/07/14 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70048 10/07/27 By Cockroach 測試BUG處理
# Modify.........: No.FUN-A60044 10/08/02 By Cockroach PASS NO.
# Modify.........: No.FUN-AB0061 10/11/18 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-AC0006 10/12/02 By wangxin 訂單審核邏輯變更
# Modify.........: No.FUN-AC0002 10/12/02 By wangxin 訂單審核邏輯變更
# Modify.........: No:TQC-B20181 11/03/08 By wangxin 將上傳不成功的資料匯入log查詢檔
# Modify.........: No:FUN-B40088 11/04/27 By wangxin BUG調整
# Modify.........: No:FUN-B50002 11/05/03 By wangxin BUG調整
# Modify.........: No:MOD-B80035 11/08/08 By huangtao 上傳調整
# Modify.........: No:FUN-BB0086 11/11/16 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-910088 11/11/25 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0108 12/01/11 By pauline 利用單據資料上的日期取編號
# Modify.........: No.FUN-BB0120 12/01/11 By pauline g_errno=SQLCA.sqlcode 調整
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapcp200.global"          #TQC-B20181 add
 
DEFINE g_pml RECORD LIKE pml_file.*       #No.TQC-740351
DEFINE g_pmn RECORD LIKE pmn_file.*       #MOD-920385
DEFINE g_oeb03      LIKE oeb_file.oeb03   #MOD-910210
DEFINE g_fno        LIKE oga_file.oga16   #FUN-AC0002   

DEFINE l_sql        STRING 		  #MOD-970228
DEFINE p_plant      LIKE azw_file.azw01   #FUN-A30116 ADD
DEFINE p_legal      LIKE azw_file.azw02   #FUN-A70048 ADD

#p_plant :營運中心 門店機構  #Using for multi-DB by cockroach
#-----------------------------------------------------------------
#作用:訂單確認前的檢查
#p_oea01:本筆訂單的單號
#l_flag:最大折扣率判斷
#p_plant:營運中心、機構門店
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,
#IF g_success='Y' THEN 檢查成功 ; IF g_success='N' THEN 檢查有錯誤
#start FUN-580155 #FUN-740034
#----------------------------------------------------------------
#FUNCTION t400sub_y_chk(p_flag,p_oea01)
FUNCTION t400sub_y_chk(p_flag,p_oea01,l_plant,p_fno)     #FUN-A30116 ADD 添加參數營運中心,將SQL改成跨DB形式
  DEFINE p_oea01    LIKE oea_file.oea01
  DEFINE p_fno      LIKE oga_file.oga16
  DEFINE l_plant    LIKE azw_file.azw01            #FUN-A30116 ADD
  DEFINE l_cnt      LIKE type_file.num5
  DEFINE p_flag     LIKE type_file.chr1
  DEFINE l_oea      RECORD LIKE oea_file.*
  DEFINE o_oea      RECORD LIKE oea_file.*
  DEFINE l_oeb      RECORD LIKE oeb_file.*,
         l_gift_amt LIKE oeb_file.oeb13,
         l_amt_sum  LIKE oea_file.oea1006,
         l_occ1028  LIKE occ_file.occ1028,
         l_rate     LIKE oea_file.oea1006,
         l_oeb1007  LIKE oeb_file.oeb1007,
         l_oeb1010  LIKE oeb_file.oeb1010,
         l_oeb14t   LIKE oeb_file.oeb14t,
         l_oeb14    LIKE oeb_file.oeb14,
         l_tqw07    LIKE tqw_file.tqw07,  
         l_tqw08    LIKE tqw_file.tqw08,  
         l_max      LIKE tqw_file.tqw07,  
         l_n        LIKE type_file.num5
  DEFINE l_oea61    LIKE oea_file.oea61   #FUN-740016
  DEFINE l_oea14    LIKE oea_file.oea14   #FUN-740016
  DEFINE l_ocn04    LIKE ocn_file.ocn04   #FUN-740016
  DEFINE l_oeb14t_1 LIKE oeb_file.oeb14t  #FUN-870007
  DEFINE l_occ72    LIKE occ_file.occ72   #FUN-870007
  DEFINE l_price    LIKE oeb_file.oeb14t  #FUN-870007
  DEFINE l_rxx04    LIKE rxx_file.rxx04   #FUN-870007
# DEFINE l_oeb47    LIKE oeb_file.oeb47   #FUN-870007  #FUN-AB0061 mark 
  DEFINE l_x1,l_x2  LIKE type_file.chr1   #MOD-970228                
  DEFINE l_oeb910   LIKE oeb_file.oeb910  #MOD-970228                
  DEFINE l_oeb912   LIKE oeb_file.oeb912  #MOD-970228                
  DEFINE l_msg,l_msg1,l_msg2  STRING	    #MOD-970228    
 
  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012
      
  #FUN-A30116 ADD--------------------- 
   LET g_fno = p_fno  #FUN-AC0002   
   LET p_plant =l_plant
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
  #CALL s_getlegal(l_azw01) RETURNING l_legal
   CALL s_getlegal(l_plant) RETURNING p_legal  #FUN-A70048
  #FUN-A30116 END--------------------
  LET g_success = 'Y'
  IF cl_null(p_oea01) THEN
     CALL cl_err('',-400,0)
     LET g_success = 'N'
     RETURN
  END IF
 #FUN-A30116 ADD-----------------------------------------
 #SELECT * INTO l_oea.* FROM oea_file WHERE oea01 = p_oea01     #MARK
  #LET l_sql="SELECT * FROM ",g_dbs,"oea_file WHERE oea01 ='", p_oea01,"'"
  LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
            " WHERE oea01 ='", p_oea01,"'"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
  PREPARE sel_oea_pre FROM l_sql
  EXECUTE sel_oea_pre INTO l_oea.*
 #FUN-A30116 END-----------------------------------------

 #IF l_oea.oeaconf = 'Y' THEN
 #   CALL cl_err('',9023,0)
 #   LET g_success = 'N'   #FUN-580155
 #   RETURN
 #END IF
 #IF l_oea.oeaconf = 'X' THEN
 #   CALL cl_err('',9024,0)
 #   LET g_success = 'N'   #FUN-580155
 #   RETURN
 # END IF
  IF l_oea.oea00 != "2" AND cl_null(l_oea.oea32)  THEN
     CALL cl_err ('Receive Term Is Null','axm-317',0)
     LET g_success = 'N'   #FUN-580155
     RETURN
  END IF
 
  IF g_azw.azw04='2' THEN
    #FUN-A30116 ADD--------------------------------------
    #SELECT SUM(oeb14t) INTO l_oeb14t_1 FROM oeb_file 
    # WHERE oeb01=l_oea.oea01 AND oeb70='N'  
     #LET l_sql="SELECT SUM(oeb14t) FROM ",g_dbs,"oeb_file ",
    LET l_sql="SELECT SUM(oeb14t) FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
               " WHERE oeb01='",l_oea.oea01,"' AND oeb70='N'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
     PREPARE sel_oeb14t_pre FROM l_sql
     EXECUTE sel_oeb14t_pre INTO l_oeb14t_1  
    #FUN-A30116 END--------------------------------------
     IF SQLCA.sqlcode=100 THEN LET l_oeb14t_1=NULL END IF
     IF cl_null(l_oeb14t_1) THEN LET l_oeb14t_1=0 END IF

#FUN-AB0061-------------------mark start----------------------------
#   #FUN-A30116 ADD--------------------------------------
#   #FUN-A70048-----
#   #SELECT SUM(oeb47) INTO l_oeb47 FROM oeb_file
#   # WHERE oeb01=l_oea.oea01 AND oeb70='N' 
#    #LET l_sql="SELECT SUM(oeb47) FROM ",g_dbs,"oeb_file",
#    LET l_sql="SELECT SUM(oeb47) FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
#              " WHERE oeb01='",l_oea.oea01,"' AND oeb70='N'"
#    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
#    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
#    PREPARE sel_oeb47_pre FROM l_sql
#    EXECUTE sel_oeb47_pre INTO l_oeb47
#   #FUN-A30116 END-------------------------------------- 
#    IF cl_null(l_oeb47) THEN 
#       LET l_oeb47=0 
#    END IF
#FUN-AB0061 -----------------mark end------------------------------
    #FUN-A30116 ADD--------------------------------------
    #SELECT azi04 INTO t_azi04 FROM azi_file 
    # WHERE azi01=l_oea.oea23 
     LET l_sql="SELECT azi04 FROM ",g_dbs,"azi_file", 
               " WHERE azi01='",l_oea.oea23,"'"
     PREPARE sel_azi04_pre FROM l_sql
     EXECUTE sel_azi04_pre INTO t_azi04
    #FUN-A30116 END-------------------------------------- 
#FUN-AB0061 ----------------mark start-----------------------------
#    IF l_oea.oea213 ='N' THEN
#       LET l_oeb47=l_oeb47*(1+l_oea.oea211/100)
#       CALL cl_digcut(l_oeb47,t_azi04) RETURNING l_oeb47
#    END IF  
#    LET l_price=(l_oeb14t_1-l_oeb47)*l_oea.oea161/100
#FUN-AB0061 ----------------mark end------------------------------
     LET l_price = (l_oeb14t_1)*l_oea.oea161/100                    #FUN-AB0061 
     CALL cl_digcut(l_price,t_azi04) RETURNING l_price

    #FUN-A30116 ADD--------------------------------------
    #SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file
    # WHERE rxx00='01' AND rxx01=l_oea.oea01 
    #   AND rxx03='1' AND rxxplant=l_oea.oeaplant
     #LET l_sql="SELECT SUM(rxx04) FROM ",g_dbs,"rxx_file",
     LET l_sql="SELECT SUM(rxx04) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
               " WHERE rxx00='01' AND rxx01='",l_oea.oea01,"'", 
               "   AND rxx03='1' AND rxxplant='",l_oea.oeaplant,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
     PREPARE sel_rxx04_pre FROM l_sql
     EXECUTE sel_rxx04_pre INTO l_rxx04
    #FUN-A30116 END--------------------------------------

     IF SQLCA.sqlcode THEN 
        CALL cl_err('sel sum(rxx04)',status,0)
        LET l_rxx04=NULL 
     END IF
     IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF         
     IF l_rxx04<l_price THEN 
        CALL cl_err('','art-265',0)
        LET g_success='N'
        RETURN
     END IF 
  END IF
    
#無單身資料不可確認
  LET l_cnt=0
 #FUN-A30116 ADD--------------------------------------
 #SELECT COUNT(*) INTO l_cnt FROM oeb_file
 # WHERE oeb01=l_oea.oea01
  #LET l_sql="SELECT COUNT(*) FROM ",g_dbs,"oeb_file",
  LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
            " WHERE oeb01='",l_oea.oea01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE sel_cnt_pre FROM l_sql
     EXECUTE sel_cnt_pre INTO l_cnt
 #FUN-A30116 END--------------------------------------
  IF l_cnt=0 OR l_cnt IS NULL THEN
     CALL cl_err(l_oea.oea01,'mfg-009',0)  #TQC-730022
     LET g_success = 'N'   #FUN-580155
     RETURN
  END IF

  IF (l_oea.oea08='1' AND l_cnt > g_oaz.oaz681) OR
     (l_oea.oea08 MATCHES '[23]' AND l_cnt > g_oaz.oaz682) THEN
     CALL cl_err('','axm-158',0)
     LET g_success = 'N'   
     RETURN
  END IF
  #FUN-AC0006 mark --------------------------begin--------------------------------
  # IF l_oea.oea00 = '8' OR l_oea.oea00 = '9' THEN  #MOD-840197
  #FUN-A30116 ADD--------------------------------------
  #SELECT oea61*oea24,oea14 INTO l_oea61,l_oea14 FROM oea_file
  # WHERE oea01=l_oea.oea01
  #LET l_sql="SELECT oea61*oea24,oea14 FROM ",g_dbs,"oea_file",
  #LET l_sql="SELECT oea61*oea24,oea14 FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
  #          " WHERE oea01='",l_oea.oea01,"'"
  #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
  #  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
  #PREPARE sel_oea14_pre FROM l_sql
  #EXECUTE sel_oea14_pre INTO l_oea61,l_oea14  

  #SELECT ocn04 INTO l_ocn04 FROM ocn_file
  # WHERE ocn01 = l_oea14
  #LET l_sql="SELECT ocn04 FROM ",g_dbs,"ocn_file",
  #LET l_sql="SELECT ocn04 FROM ",cl_get_target_table(g_plant_new,'ocn_file'), #FUN-A50102
  #          " WHERE ocn01 = '",l_oea14,"'"
  #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
  #  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
  #PREPARE sel_ocn04_pre FROM l_sql
  #EXECUTE sel_ocn04_pre INTO l_ocn04
  #FUN-A30116 END--------------------------------------

  #IF l_oea61 > l_ocn04 THEN
  #   CALL cl_err(l_oea14,'axm-112',1)
  #   LET g_success = "N"
  #   RETURN
  #END IF
  #END IF   #MOD-840197 add
  #FUN-AC0006 mark ---------------------------end---------------------------------
 
  IF g_aza.aza50 = 'Y' THEN
    #FUN-A30116 ADD--------------------------------------
    #DECLARE l_oeb1007_conf CURSOR FOR
    # SELECT oeb1007,oeb14,oeb14t,oeb1010     
    #   FROM oeb_file
    #  WHERE oeb01=l_oea.oea01
    #    AND oeb1003='2'
    LET l_sql="SELECT oeb1007,oeb14,oeb14t,oeb1010 ",      
              #"  FROM ",g_dbs,"oeb_file ",
              "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
              " WHERE oeb01='",l_oea.oea01,"'",
              "   AND oeb1003='2' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
    PREPARE l_oeb1007_pre FROM l_sql  
    DECLARE l_oeb1007_conf CURSOR FOR l_oeb1007_pre
   #FUN-A30116 END--------------------------------------
      FOREACH l_oeb1007_conf INTO l_oeb1007,l_oeb14,l_oeb14t,l_oeb1010
        #FUN-A30116 ADD--------------------------------------
        #SELECT COUNT(*) INTO l_n
        #  FROM tqw_file
        # WHERE tqw01 = l_oeb1007
        #   AND tqw10 = '3'
        #   AND (abs(tqw07)-abs(tqw08)>=0)
        #   AND tqw17 = l_oea.oea23
        #   AND tqw05 = l_oea.oea03  

         #LET l_sql="SELECT COUNT(*) FROM ",g_dbs,"tqw_file", 
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'tqw_file'), #FUN-A50102
                   " WHERE tqw01 = '",l_oeb1007,"'",
                   "   AND tqw10 = '3'",
                   "   AND (abs(tqw07)-abs(tqw08)>=0)",
                   "   AND tqw17 = '",l_oea.oea23,"'",
                   "   AND tqw05 = '",l_oea.oea03,"'"  
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
         PREPARE sel_ln_pre FROM l_sql
         EXECUTE sel_ln_pre INTO l_n
        #FUN-A30116 END--------------------------------------
         IF l_n = 0 THEN
            CALL cl_err('','atm-028',0)
            LET g_success = 'N'  
            RETURN
         END IF
        #FUN-A30116 ADD--------------------------------------
        #SELECT tqw07,tqw08 INTO l_tqw07,l_tqw08 FROM tqw_file
        # WHERE tqw01 =l_oeb1007
         #LET l_sql="SELECT tqw07,tqw08 FROM ",g_dbs,"tqw_file", 
        LET l_sql="SELECT tqw07,tqw08 FROM ",cl_get_target_table(g_plant_new,'tqw_file'), #FUN-A50102
                   " WHERE tqw01 ='",l_oeb1007,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
         PREPARE sel_tqw07_pre FROM l_sql
         EXECUTE sel_tqw07_pre INTO l_tqw07,l_tqw08 
        #FUN-A30116 END--------------------------------------
         LET l_max =l_tqw07 -l_tqw08
   
         IF l_oeb1010 ='Y' THEN
            IF l_max >= 0 THEN
               IF l_oeb14t >l_max OR l_oeb14t <= 0 THEN
                  CALL cl_err(l_oeb14t,'atm-031',1)
                  RETURN
               END IF
            ELSE
               IF l_oeb14t <l_max OR l_oeb14t <= 0 THEN
                  CALL cl_err(l_oeb14t,'atm-032',1)
                  RETURN
               END IF
            END IF
         ELSE
            IF l_max >= 0 THEN
               IF l_oeb14 >l_max OR l_oeb14 <= 0 THEN
                  CALL cl_err(l_oeb14,'atm-031',1)
                  RETURN
               END IF
            ELSE
               IF l_oeb14 <l_max OR l_oeb14 <= 0 THEN
                  CALL cl_err(l_oeb14,'atm-032',1)
                  RETURN
               END IF
            END IF
         END IF
      END FOREACH
     ##--最大折扣率判斷
     IF p_flag = '1' THEN
        LET l_gift_amt = 0
        #FUN-A30116 ADD-------------------------------------- 
        #DECLARE b_amt_conf CURSOR FOR
        # SELECT * FROM oeb_file
        #  WHERE oeb01 = l_oea.oea01
        #    AND oeb1012 = 'Y'
        #    AND oeb1003!='2'
        #OPEN b_amt_conf
         #LET l_sql="SELECT * FROM ",g_dbs,"oeb_file",
         LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                   " WHERE oeb01 = '",l_oea.oea01,"'",
                   "   AND oeb1012 = 'Y'",
                   "   AND oeb1003!='2'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
         PREPARE sel_oeb1_pre FROM l_sql
         DECLARE b_amt_conf CURSOR FOR sel_oeb1_pre
        #FUN-A30116 END--------------------------------------
         FOREACH b_amt_conf INTO l_oeb.*
            IF STATUS THEN
               CALL cl_err('foreach oeb',STATUS,0)   
               RETURN 
            END IF 
            IF l_oea.oea213='Y' THEN
                LET l_oeb.oeb13=l_oeb.oeb13*(1-l_oea.oea211/100)
            END IF
            IF g_sma.sma116 MATCHES '[23]' THEN   
               LET l_oeb.oeb12=l_oeb.oeb917
            END IF
            LET l_gift_amt = l_gift_amt+l_oeb.oeb13*l_oeb.oeb12
         END FOREACH
         LET l_amt_sum = l_gift_amt + l_oea.oea1006
         IF l_oea.oea61 = 0 THEN
            CALL cl_err('','atm-035',0)
            LET g_success = 'N'  
            RETURN
         END IF
         LET l_rate= l_amt_sum / l_oea.oea61*100
        #FUN-A30116 ADD--------------------------------------
        #SELECT occ1028 INTO l_occ1028 FROM occ_file
        # WHERE occ01 = l_oea.oea03  
        #LET l_sql="SELECT occ1028 FROM ",g_dbs,"occ_file",
         LET l_sql="SELECT occ1028 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                   " WHERE occ01 = '",l_oea.oea03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
         PREPARE sel_occ1028_pre FROM l_sql  
         EXECUTE sel_occ1028_pre INTO l_occ1028 
        #FUN-A30116 END--------------------------------------
         IF NOT cl_null(l_occ1028) THEN
            IF l_rate>l_occ1028 THEN
               CALL cl_err('','atm-033',0)
               LET g_success = 'N'  
               RETURN
            END IF
         END IF
      END IF
  END IF
  IF g_sma.sma115= 'Y' THEN                                       
     LET l_x1 = "Y"                                                             
     LET l_x2 = "Y"                                                             
    #LET l_sql="SELECT oeb910,oeb912 FROM oeb_file ",         #FUN-A30116 MARK    
     #LET l_sql="SELECT oeb910,oeb912 FROM ",g_dbs,"oeb_file ",  
     LET l_sql="SELECT oeb910,oeb912 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102     
               " WHERE oeb01='",l_oea.oea01,"'",
               "   AND oeb1003='1' "  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
     PREPARE pre_oeb FROM l_sql
     DECLARE oeb_curs CURSOR FOR pre_oeb                                       
     FOREACH oeb_curs INTO l_oeb910,l_oeb912                   
        IF cl_null(l_oeb910) THEN LET l_x1 = "N" END IF                         
        IF cl_null(l_oeb912) THEN LET l_x2 = "N" END IF                         
     END FOREACH                                                                
     IF l_x1 = "N" THEN                                                   
        #出貨單位欄位不可空白
        CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1                       
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2                       
        LET l_msg = l_msg1 CLIPPED,l_msg2                                       
     END IF                                                                     
     IF l_x2 = "N" THEN                                                         
        #出貨數量欄位不可空白
        CALL cl_getmsg('asm-307',g_lang) RETURNING l_msg1                       
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2                       
        LET l_msg = l_msg CLIPPED,l_msg1 CLIPPED,l_msg2                         
     END IF                                                                     
     IF NOT cl_null(l_msg) THEN                                                 
        CALL cl_msgany(10,20,l_msg)                                             
        LET g_success = 'N'                                                     
        RETURN                                                                  
     END IF                                                                     
  END IF       
END FUNCTION
 
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t400sub_lock_cl()
   DEFINE l_forupd_sql STRING

  #FUN-A30116 ADD-------------------------------------------------------  
  #LET l_forupd_sql = "SELECT * FROM oea_file WHERE oea01 = ? FOR UPDATE"
  #LET l_forupd_sql = "SELECT * FROM ",g_dbs,"oea_file WHERE oea01 = ? FOR UPDATE"
   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                      " WHERE oea01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_forupd_sql,g_plant_new) RETURNING l_forupd_sql #FUN-A50102
   DECLARE t400sub_cl CURSOR FROM l_forupd_sql

  #FUN-A70048 ---
  #LET l_forupd_sql = "SELECT * FROM occ_file WHERE occ01 = ? FOR UPDATE"
   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'occ_file'),
                      " WHERE occ01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_forupd_sql,g_plant_new) RETURNING l_forupd_sql #FUN-A50102
   DECLARE t400sub_cl2 CURSOR FROM l_forupd_sql
  #FUN-A70048 ---
END FUNCTION
 
#{
#作用:訂單確認
#p_oea01:本筆訂單的單號
#p_action_choice:執行本函數時的Action Name(沒有的話傳NULL),不可直接使用全域變數g_action_chioce來做處理
#l_plant :營運中心 門店機構  #Using for multi-DB by cockroach
#l_oea:單頭
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 執行成功 ; IF g_success='N' THEN 執行不成功
#     做完確認,要自行重新讀取oea_file(CALL t400sub_refresh()),本FUN不做refresh oea_file的動作
#}
#FUNCTION t400sub_y_upd(p_oea01,p_action_choice)  #FUN-A30116  mark
FUNCTION t400sub_y_upd(p_oea01,p_action_choice,l_plant,p_fno)
  DEFINE p_oea01 LIKE oea_file.oea01
  DEFINE l_plant LIKE azw_file.azw01   #FUN-A30116
  DEFINE l_oea RECORD LIKE oea_file.*
  DEFINE p_action_choice STRING
  DEFINE l_cnt  LIKE type_file.num5
  DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
  DEFINE l_wc   LIKE type_file.chr1000 #No.FUN-650108  #No.FUN-680137 VARCHAR(200)
  DEFINE l_msg  LIKE type_file.chr1000
  DEFINE l_oeamksg LIKE oea_file.oeamksg
  DEFINE l_oea49   LIKE oea_file.oea49
  DEFINE l_oea61   LIKE oea_file.oea61   #No.FUN-740016
  DEFINE l_oea14   LIKE oea_file.oea14   #No.FUN-740016
  DEFINE l_ocn03   LIKE ocn_file.ocn03   #No.FUN-740016
  DEFINE l_ocn04   LIKE ocn_file.ocn04   #No.FUN-740016
  DEFINE l_oayslip LIKE oay_file.oayslip
  DEFINE l_oayprnt LIKE oay_file.oayprnt
  DEFINE l_count   LIKE type_file.num5  
  DEFINE p_fno     LIKE oga_file.oga16

  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012
 
  #FUN-A30116 ADD---------------------
   LET g_fno = p_fno   
   LET p_plant =l_plant
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
  #CALL s_getlegal(l_azw01) RETURNING l_legal
   CALL s_getlegal(l_plant) RETURNING p_legal  #FUN-A70048
  #FUN-A30116 END--------------------

  LET g_success = 'Y'
  IF p_action_choice CLIPPED = "confirm" OR   #按「確認」時
     p_action_choice CLIPPED = "insert"  OR              #No.TQC-720023
     p_action_choice CLIPPED = "discount_allowed"        #FUN-610055
  THEN
    #FUN-A30116 ADD---------------------
    #SELECT oeamksg,oea49 
    #  INTO l_oeamksg,l_oea49
    #  FROM oea_file
    # WHERE oea01=p_oea01
#    LET l_sql="SELECT oeamksg,oea49", 
#              "  FROM ",g_dbs,"oea_file",
#              " WHERE oea01='",p_oea01,"'"
#    PREPARE sel_oeamksg_pre FROM l_sql
#    EXECUTE sel_oeamksg_pre INTO l_oeamksg,l_oea49
#   #FUN-A30116 END--------------------   
#    IF l_oeamksg='Y'   THEN #MOD-4A0299
#       IF l_oea49 != '1' THEN
#          CALL cl_err('','aws-078',1)
#          LET g_success = 'N'
#          RETURN
#       END IF
#    END IF
#    IF NOT cl_confirm('axm-108') THEN 
#       LET g_success = 'N'    #TQC-740245
#       RETURN 
#    END IF
  END IF
 
#FUN-A30116 MARK---------------------------
# IF g_aza.aza41 = '1' THEN                                                                                                
#    LET l_count = '3'                                                                                                     
# ELSE                                                                                                                     
#    IF g_aza.aza41 = '2' THEN                                                                                         
#       LET l_count = '4'                                                                                              
#    ELSE                                                                                                              
#       LET l_count = '5'                                                                                          
#    END IF                                                                                                            
# END IF        
# LET  l_oayslip= p_oea01[1,l_count]                      #FUN-9B0039 mod
# SELECT oayprnt INTO l_oayprnt FROM oay_file
#  WHERE oayslip = l_oayslip    
#FUN-A30116 END---------------------------
 
 #BEGIN WORK  #FUN-A30116 mark
  CALL t400sub_lock_cl()
  OPEN t400sub_cl USING p_oea01
  IF STATUS THEN
     CALL cl_err("OPEN t400sub_cl:", STATUS, 1)
     CLOSE t400sub_cl
    #ROLLBACK WORK #FUN-A30116 mark
     LET g_success='N'  #FUN-A30116 add
     RETURN
  END IF
 
  FETCH t400sub_cl INTO l_oea.*          # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(l_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
    #CLOSE t400sub_cl ROLLBACK WORK RETURN
     LET g_success='N'  #FUN-A30116 add
     RETURN             #FUN-A30116 add

  END IF
  
  LET g_success = 'Y'
  CALL t400sub_y1(l_oea.*)
  
  IF g_success = 'Y' THEN
  #FUN-A30116 MARK--------------------------------------------
  #  IF g_aza.aza50 = 'Y' AND g_prog != 'axmt410' THEN #No.FUN-820033 by hellen
  #     CALL t400sub_tqw08_update(1,l_oea.*)   #FUN-610055
  #  END IF  #No.FUN-650108
  #  IF l_oea.oeamksg = 'Y' THEN #簽核模式
  #     CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
  #        WHEN 0  #呼叫 EasyFlow 簽核失敗
  #           LET l_oea.oeaconf="N"
  #           LET g_success = "N"
  #           ROLLBACK WORK
  #           RETURN
  #        WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
  #           LET l_oea.oeaconf="N"
  #           ROLLBACK WORK
  #           RETURN
  #     END CASE
  #  END IF
 
  #  SELECT COUNT(*) INTO l_cnt FROM oeb_file
  #   WHERE oeb01 = l_oea.oea01
  #  IF l_cnt = 0 AND l_oea.oeamksg = 'Y' THEN
  #     CALL cl_err(' ','aws-065',0)
  #     LET g_success = 'N'
 
  #  END IF
  #FUN-A30116 MARK--------------------------------------------

     IF g_success = 'Y' THEN
     # #FUN-A30116 ADD--------------------------------
     # #SELECT oea61*oea24,oea14 INTO l_oea61,l_oea14 FROM oea_file
     # # WHERE oea01=l_oea.oea01
     #  LET l_sql = "SELECT oea61*oea24,oea14 FROM ",g_dbs,"oea_file",
     #              " WHERE oea01='",l_oea.oea01,"'"
     #  PREPARE sel_oea61_pre FROM l_sql
     #  EXECUTE sel_oea61_pre INTO l_oea61,l_oea14 
     #  
     # #SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
     # # WHERE ocn01 = l_oea14
     #  LET l_sql="SELECT ocn03,ocn04 FROM ",g_dbs,"ocn_file",
     #            " WHERE ocn01 = '",l_oea14,"'"
     #  PREPARE sel_ocn03_pre FROM l_sql
     #  EXECUTE sel_ocn03_pre INTO l_ocn03,l_ocn04
     # #FUN-A30116 END--------------------------------
 
     #  LET l_ocn03 = l_ocn03+l_oea61
     #  LET l_ocn04 = l_ocn04-l_oea61
 
     #  IF l_ocn04 < 0 THEN
     #     CALL cl_err(l_oea14,'axm-112',1)   #No:MOD-9C0377 modify
     #     LET g_success="N"
     #  END IF
     # #FUN-A30116 ADD-------------------------------- 
     # #UPDATE ocn_file SET ocn03 = l_ocn03,
     # #                    ocn04 = l_ocn04
     # # WHERE ocn01 = l_oea14
     #  LET l_sql="UPDATE ",g_dbs,"ocn_file SET ocn03 = '",l_ocn03,"',",
     #                      " ocn04 = '",l_ocn04,"'",
     #            " WHERE ocn01 = '",l_oea14,"'"
     #  PREPARE upd_ocn03_pre FROM l_sql
     #  EXECUTE upd_ocn03_pre
     # #FUN-A30116 END--------------------------------
     #  LET l_oea.oea49='1'             #執行成功, 狀態值顯示為 '1' 已核准  #FUN
     # #FUN-A30116 ADD--------------------------------
     # #UPDATE oea_file SET oea49 = l_oea.oea49 WHERE oea01=l_oea.oea01
     #  LET l_sql ="UPDATE ",g_dbs,"oea_file SET oea49 = '",l_oea.oea49,"'",
     #             " WHERE oea01='",l_oea.oea01,"'"
     # #FUN-A30116 END--------------------------------
     #  IF SQLCA.sqlerrd[3]=0 THEN
     #     LET g_success='N'
     #  END IF
     #  LET l_oea.oeaconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
      # DISPLAY BY NAME l_oea.oeaconf   #FUN-580155   FUN-A30116 MARK
      # DISPLAY BY NAME l_oea.oea49     #FUN-580155
      # IF g_azw.azw04='2' THEN
      #    LET l_oea.oeaconu=g_user
      #    DISPLAY BY NAME l_oea.oeaconu
      # END IF
      # COMMIT WORK
      # CALL cl_flow_notify(l_oea.oea01,'Y')
      # DISPLAY BY NAME l_oea.oeaconf
    #ELSE
    #   LET l_oea.oeaconf = 'N'
    #   ROLLBACK WORK
     END IF
  ELSE
    #LET l_oea.oeaconf='N' ROLLBACK WORK
    RETURN  #FUN-A30116 ADD
  END IF
 ##因有可能尚未確認則先印表(印表即會先拋轉)
 #IF l_oea.oea901 = 'Y' AND g_success = 'Y' THEN
 # #判斷參數是否於確認時自動拋轉，是才拋，不是就不拋
 #     IF g_oax.oax07 = 'Y' THEN
 #         #拋轉至各廠
 #         LET l_cmd="axmp800 '",l_oea.oea01,"' '",l_oea.oea905,"' "
 #         CALL cl_cmdrun_wait(l_cmd)
 #         LET l_oea.oea905='Y'    
 
 #         #若是背景執行，則不產生報表(Ex: EasyFlow簽核，自動跑確認段)
 #         IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #No.FUN-640248
 #            #列印三角貿易S/O
 #                 LET l_wc='oea01="',l_oea.oea01,'"'                                                                                           
 #                 LET l_msg = "axmr830",                                                                                                       
 #                     " '",g_today CLIPPED,"' ''",                                                                                             
 #                     " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                      
 #                     " '",l_wc CLIPPED,"' "
 #             IF l_oayprnt = 'Y' THEN                 #TQC-960011                  
 #                CALL cl_cmdrun_wait(l_msg)
 #             END IF                                  #TQC-960011   
 #             #列印三角貿易P/O
 #                 LET l_wc='oea01="',l_oea.oea01,'"'                                                                                           
 #                 LET l_msg = "axmr820",                                                                                                       
 #                     " '",g_today CLIPPED,"' ''",                                                                                             
 #                     " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                      
 #                     " '",l_wc CLIPPED,"' " 
 #             IF l_oayprnt = 'Y' THEN                 #TQC-960011                  
 #                CALL cl_cmdrun_wait(l_msg)
 #             END IF                                  #TQC-960011   
 #             END IF  #No.FUN-640248
 #     END IF   #NO.TQC-740111
 #END IF
END FUNCTION
 
#{
#作用:訂單確認
#l_oea:本筆訂單的data
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 執行成功 ; IF g_success='N' THEN 執行不成功
#}
FUNCTION t400sub_y1(l_oea)
 DEFINE l_oea   RECORD LIKE oea_file.*
 DEFINE l_oeb17 LIKE oeb_file.oeb17
 DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
 DEFINE l_oeb   RECORD LIKE oeb_file.*
 
   LET l_oea.oea72=TODAY 
   IF l_oea.oeamksg = 'N' AND
      l_oea.oeaconf = 'N' AND l_oea.oea49 = '0'  THEN
      LET l_oea.oea49 = '1'     #已核淮
   END IF
   LET l_oea.oeaconu = g_user  #No.FUN-870007
   LET l_oea.oeacont = TIME    #No.FUN-870007
  #FUN-A30116 ADD-------------------------------------------- 
  #UPDATE oea_file SET oeaconf='Y',
  #                    oeaconu=l_oea.oeaconu,   #No.FUN-870007
  #                    oeacont=l_oea.oeacont,   #No.FUN-870007
  #                    oea72=l_oea.oea72,
  #                    oea49=l_oea.oea49
  # WHERE oea01 = l_oea.oea01
   #LET l_sql="UPDATE ",g_dbs,"oea_file SET oeaconf='Y',",
   LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
             "   SET oeaconf='Y',",
             " oeaconu='",l_oea.oeaconu,"',",
             " oeacont='",l_oea.oeacont,"',",
             " oea72='",l_oea.oea72,"',",
             " oea49='",l_oea.oea49,"'",
             " WHERE oea01 = '",l_oea.oea01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
   PREPARE upd_oeaconf_pre FROM l_sql
   EXECUTE upd_oeaconf_pre
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oea_file",l_oea.oea01,"",SQLCA.sqlcode,"","upd oeaconf",1)  #No.FUN-650108
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL t400sub_hu2(l_oea.*) IF g_success = 'N' THEN RETURN END IF  #最近交易更新
 
  #FUN-A30116 ADD----------------------------------------------------
  #DECLARE t400sub_y1_c CURSOR FOR
  #   SELECT * FROM oeb_file WHERE oeb01 = l_oea.oea01 ORDER BY oeb03
   #LET l_sql = "SELECT * FROM ",g_dbs,"oeb_file WHERE oeb01 = '",l_oea.oea01,"'  ORDER BY oeb03"
   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
               " WHERE oeb01 = '",l_oea.oea01,"'  ORDER BY oeb03"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102  
   PREPARE sel_oeb2_pre FROM l_sql
   DECLARE t400sub_y1_c CURSOR FOR sel_oeb2_pre
  #FUN-A30116 END----------------------------------------------------
   FOREACH t400sub_y1_c INTO l_oeb.*
      IF STATUS THEN
         CALL cl_err('y1 foreach',STATUS,1)  
         LET g_success='N'
         RETURN
      END IF
      # 檢查訂單單價是否低於取出單價(合約訂單不卡)
      #IF l_oea.oea00 != '0' THEN          #FUN-AC0006 mark
       IF l_oea.oea00 MATCHES "[12]" THEN  #FUN-AC0006 add
         LET l_oeb17 = l_oeb.oeb17 * (100-g_oaz.oaz185) / 100
         LET l_oeb17 = cl_digcut(l_oeb17,t_azi03)      #No.CHI-6A0004
         IF l_oeb.oeb13 < l_oeb17 THEN
            LET l_msg = 'Seq.:',l_oeb.oeb03 USING '&&&',' Item:',l_oeb.oeb04
            CASE g_oaz.oaz184
               WHEN 'R'
                  CALL cl_err(l_msg CLIPPED,'axm-802',1)
                  LET g_success ='N'
                  EXIT FOREACH
               WHEN 'W'
                  LET l_msg = cl_getmsg('axm-802',g_lang)
                  LET l_msg=l_msg CLIPPED,'Seq.:',l_oeb.oeb03 USING '&&&',' Item:',l_oeb.oeb04
                  CALL cl_msgany(10,20,l_msg)
               WHEN 'N'
                  EXIT CASE
            END CASE
         END IF
      END IF
     #CALL t400sub_bu1(l_oea.*,l_oeb.*) IF g_success = 'N' THEN RETURN END IF #更新合約已轉訂單量 #FUN-A30116 MARK
     #CALL t400sub_bu2() IF g_success = 'N' THEN RETURN END IF #更新? #FUN-A30116 MARK
      CALL t400sub_bu3(l_oea.*,l_oeb.*) IF g_success = 'N' THEN RETURN END IF #更新產品客戶
     #CALL t400sub_bu4() IF g_success = 'N' THEN RETURN END IF #更新產品價格 #FUN-A30116 MARK
   END FOREACH
END FUNCTION
 
FUNCTION t400sub_hu1(l_oea)		#客戶信用查核
   DEFINE l_oea RECORD LIKE oea_file.*
   DEFINE l_msg LIKE type_file.chr1000    #MOD-780014 add
   CALL cl_msg("hu1!")          #No.FUN-640248
   #IF l_oea.oea00='0' OR l_oea.oea00="A" THEN RETURN END IF   #No.FUN-610053  #FUN-AC0006 mark
   IF g_oaz.oaz122 MATCHES "[12]" THEN
      IF l_oea.oeamksg = 'Y' THEN
         CALL s_ccc_logerr()  
      END IF
        CALL s_ccc(l_oea.oea03,'2',l_oea.oea01)    # Customer Credit Check 客戶信用查核                                                    
      IF g_errno = 'N' THEN
         IF g_oaz.oaz122 = '1'
            THEN # CALL cl_err('ccc','axm-104',1)           #MOD-780014 mark 
                   LET l_msg = cl_getmsg('axm-104',g_lang)  #MOD-780014 add
                   CALL cl_msgany(10,20,l_msg)              #MOD-780014 add
                 LET l_oea.oeahold=g_oaz.oaz11
                 DISPLAY BY NAME l_oea.oeahold
                #FUN-A30116 ADD-----------------------------
                #UPDATE oea_file SET oeahold=l_oea.oeahold
                #       WHERE oea01=l_oea.oea01
                 #LET l_sql="UPDATE ",g_dbs,"oea_file SET oeahold='",l_oea.oeahold,"'",
                 LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                           " SET oeahold='",l_oea.oeahold,"'",
                           " WHERE oea01='",l_oea.oea01,"'"
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
                 PREPARE upd_oeahold_pre FROM l_sql
                 EXECUTE upd_oeahold_pre
                #FUN-A30116 END-----------------------------
            ELSE CALL cl_err('ccc','axm-106',0)
                 LET g_success = 'N' RETURN
         END IF
      END IF
   END IF
   CALL cl_msg("")              #No.FUN-640248 
END FUNCTION
 
FUNCTION t400sub_hu2(l_oea)		#最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*
   DEFINE l_oea RECORD LIKE oea_file.*
   CALL cl_msg("hu2!")          #No.FUN-640248 
   OPEN t400sub_cl2 USING l_oea.oea03 
   IF STATUS THEN
      CALL cl_err("OPEN t400sub_cl2:", STATUS, 1)
      CLOSE t400sub_cl2
      LET g_success = 'N'
      RETURN
   END IF
   FETCH t400sub_cl2 INTO l_occ.*      
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_occ.occ01,SQLCA.sqlcode,0)    
      CLOSE t400sub_cl2 
      LET g_success = 'N'
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=l_oea.oea02 END IF
   IF l_occ.occ172 IS NULL OR l_occ.occ172 < l_oea.oea02 THEN
      LET l_occ.occ172=l_oea.oea02
   END IF
  #FUN-A30116 ADD-----------------------------------------------------------
  #UPDATE occ_file SET * = l_occ.* WHERE occ01=l_oea.oea03     #FUN-610055
  #LET l_sql = "UPDATE ",g_dbs,"occ_file SET * = ",l_occ.*," WHERE occ01='",l_oea.oea03,"'"
  #LET l_sql = "UPDATE ",g_dbs,"occ_file SET occ16 = '",l_occ.occ16,"', occ172='",l_occ.occ172,"'",
   LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
               "   SET occ16 = '",l_occ.occ16,"', occ172='",l_occ.occ172,"'",
               " WHERE occ01='",l_oea.oea03,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
   PREPARE upd_occ_pre FROM l_sql
   EXECUTE upd_occ_pre
  #FUN-A30116 END-----------------------------------------------------------
   IF STATUS THEN
      CALL cl_err3("upd","occ_file",l_oea.oea03,"",STATUS,"","u occ",1)  #No.FUN-650108
      CLOSE t400sub_cl2   #MOD-950006
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL cl_msg("")              #No.FUN-640248 
 
END FUNCTION
 
FUNCTION t400sub_bu1(l_oea,l_oeb) 				#合約已轉訂單量更新
   DEFINE l_oea RECORD LIKE oea_file.*
   DEFINE l_oeb RECORD LIKE oeb_file.*
   DEFINE l_tot LIKE oeb_file.oeb14   
   DEFINE l_oeb05_1 LIKE oeb_file.oeb05  
   DEFINE l_oeb04 LIKE oeb_file.oeb04    
   DEFINE l_oeb05 LIKE oeb_file.oeb05    
   DEFINE l_oeb12 LIKE oeb_file.oeb12    
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_factor LIKE ima_file.ima31_fac 
 
   CALL cl_msg("bu1!")          #No.FUN-640248 
 
   IF l_oea.oea11 = '3' THEN #MOD-6A0171 mark OR l_oea.oea11="A" THEN   #No.FUN-610053
      DECLARE oeb12_cs CURSOR FOR
        SELECT oeb04,oeb05,oeb12 FROM oea_file,oeb_file
        #WHERE oea12 = l_oea.oea12 AND oea00 IN ('1','3','4','6','7')  #FUN-AC0006 mark
         WHERE oea12 = l_oea.oea12 AND oea00 = '1'                     #FUN-AC0006 add 
           AND oeaconf = 'Y'
           AND oea01 = oeb01
           AND oeb71 = l_oeb.oeb71
      LET l_oeb05_1 = ''
      SELECT oeb05 INTO l_oeb05_1 FROM oeb_file
        WHERE oeb01 = l_oea.oea12
          AND oeb03 = l_oeb.oeb71
      LET l_tot = 0 
      FOREACH oeb12_cs INTO l_oeb04,l_oeb05,l_oeb12
        CALL s_umfchk(l_oeb04,l_oeb05,l_oeb05_1) RETURNING l_cnt,l_factor 
        IF l_cnt = 1 THEN LET l_factor = 1 END IF
        LET l_tot = l_tot + (l_oeb12 * l_factor)
      END FOREACH
      IF cl_null(l_tot) THEN
         LET l_tot = 0
      END IF

      LET l_tot = s_digqty(l_tot,l_oeb05_1)     #No:FUN-BB0086   add
 
      UPDATE oeb_file SET oeb24 = l_tot
       WHERE oeb01 = l_oea.oea12
         AND oeb03 = l_oeb.oeb71
 
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_errno = SQLCA.sqlcode   #FUN-BB0120 add 
         LET g_showmsg=g_plant_new,"/",g_fno,"/",l_oea.oea12,"/",l_oeb.oeb71                 #No.FUN-710046  
         CALL s_errmsg("shop,fno,oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)  #No.FUN-710046
         #TQC-B20181 add begin-----------  
        #LET g_errno=SQLCA.sqlcode     #FUN-BB0120 mark                      
	 LET g_msg1='posdh'||'UPD oeb_file'||g_plant_new||g_fno  
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','POSDH',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
         LET g_success = 'N'
         RETURN
      END IF
   END IF
 
   CALL cl_msg("")                    #No.FUN-640248 
 
END FUNCTION
 
FUNCTION t400sub_bu2()
 
   CALL cl_msg("bu2!")                #No.FUN-640248 
   CALL cl_msg("")                    #No.FUN-640248
 
END FUNCTION
 
FUNCTION t400sub_bu3(l_oea,l_oeb) 				#更新產品客戶
   DEFINE l_oea     RECORD LIKE oea_file.*
   DEFINE l_oeb     RECORD LIKE oeb_file.*
   DEFINE l_fac     LIKE ima_file.ima31_fac       #單位換算率 #MOD-540201 add                                                      
   DEFINE l_ima31   LIKE ima_file.ima31           #銷售單位   #MOD-540201 add                                                      
   DEFINE l_rate    LIKE oea_file.oea24           #匯率       #MOD-540201 add                                                      
   DEFINE l_ima33   LIKE ima_file.ima33           #最近售價   #MOD-540201 add                                                      
   DEFINE l_check   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)  #MOD-540201 add
   DEFINE l_obk11   LIKE obk_file.obk11           #TQC-6A0045 add                                                      
   DEFINE l_obk12   LIKE obk_file.obk12           #TQC-6A0045 add                                                      
   DEFINE l_obk13   LIKE obk_file.obk13           #TQC-6A0045 add                                                      
   DEFINE l_obk14   LIKE obk_file.obk14           #TQC-6A0045 add                                                      
   DEFINE l_obkacti LIKE obk_file.obkacti         #No.MOD-740385 add
   DEFINE l_exT     LIKE type_file.chr1
   CALL cl_msg("bu3!")                #No.FUN-640248 
      #MOD-540201----------------------add                                                                                          
      #更新料件主檔的最近售價ima33                                                                                                  
      #==>單位轉換                                                                                                                  
     #FUN-A30116 ADD---------------------------- 
     #SELECT ima31 INTO l_ima31 FROM ima_file                                                                                       
     # WHERE ima01= l_oeb.oeb04                                                                                                     
      #LET l_sql="SELECT ima31 FROM ",g_dbs,"ima_file ", 
      LET l_sql="SELECT ima31 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102     
                " WHERE ima01= '",l_oeb.oeb04 ,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
      PREPARE sel_ima31_pre FROM l_sql
      EXECUTE sel_ima31_pre INTO l_ima31
     #FUN-A30116 END----------------------------                                                                                                    
      IF l_oeb.oeb05 =l_ima31 THEN                                                                                                  
          LET l_fac = 1                                                                                                             
      ELSE                                                                                                                          
         #CALL s_umfchk(l_oeb.oeb04,l_oeb.oeb05,l_ima31)     #FUN-A30116 ADD                                                                       
          CALL s_umfchkm(l_oeb.oeb04,l_oeb.oeb05,l_ima31,p_plant)                                                                            
               RETURNING l_check,l_fac                                                                                              
      END IF                                                                                                                        
      #==>幣別匯率轉換                                                                                                              
      IF l_oea.oea23 =g_aza.aza17 THEN                                                                                              
          LET l_rate =1                                                                                                             
      ELSE                                                                                                                          
          IF l_oea.oea08='1' THEN                                                                                                   
             LET l_exT=g_oaz.oaz52                                                                                                    
          ELSE                                                                                                                      
             LET l_exT=g_oaz.oaz70                                                                                                    
          END IF                                                                                                                    
         #CALL s_curr3(l_oea.oea23,l_oea.oea02,l_exT)
          CALL s_currm(l_oea.oea23,l_oea.oea02,l_exT,p_plant)
                      RETURNING l_rate                                                                                              
      END IF                                                                                                                        
      #==>更新料件主檔的最近售價                                                                                                    
      LET l_ima33 = (l_oeb.oeb13/l_fac) * l_rate                                                                                    
      CALL cl_digcut(l_ima33,t_azi03)RETURNING l_ima33     #No.CHI-6A0004
     #FUN-A30116 ADD-------------------------------
     #UPDATE ima_file                                                                                                               
     #   SET ima33 = l_ima33                                                                                                        
     # WHERE ima01 = l_oeb.oeb04                                                                                                    
      #LET l_sql="UPDATE ",g_dbs,"ima_file ",  
      LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102     
                "   SET ima33 = '",l_ima33,"'",                                                                                                        
                " WHERE ima01 = '",l_oeb.oeb04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE upd_ima33_pre FROM l_sql
      EXECUTE upd_ima33_pre                                                                                                    
     #FUN-A30116 END------------------------------
       #MOD-540201----------------------(end)
 
      IF g_oaz.oaz44 = 'Y' THEN
         LET l_obk11= 'N'
         LET l_obkacti = 'Y'      #No.MOD-740385 add
     #FUN-A30116 add--------------------------------
     #   UPDATE obk_file SET obk03=l_oeb.oeb11,
     #                       obk04=l_oea.oea02,
     #                       obk05=l_oea.oea23,
     #                       obk06=l_oea.oea21,
     #                       obk07=l_oeb.oeb05,
     #                       obk08=l_oeb.oeb13,
     #                       obk09=l_oeb.oeb12 
     #   WHERE obk01 = l_oeb.oeb04
     #     AND obk02 = l_oea.oea03    #FUN-610055
     #     AND obk05 = l_oea.oea23      #No.FUN-670099
         #LET l_sql="UPDATE ",g_dbs,"obk_file ",
         LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'obk_file'), #FUN-A50102  
                   "   SET obk03='",l_oeb.oeb11,"',",
                   "       obk04='",l_oea.oea02,"'",
                   "       obk05='",l_oea.oea23,"'",
                   "       obk06='",l_oea.oea21,"'",
                   "       obk07='",l_oeb.oeb05,"'",
                   "       obk08='",l_oeb.oeb13,"'",
                   "       obk09='",l_oeb.oeb12,"'",
                   " WHERE obk01 = '",l_oeb.oeb04,"'",
                   "   AND obk02 = '",l_oea.oea04,"'",
                   "   AND obk05 = '",l_oea.oea24,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
         PREPARE upd_obk03_pre FROM l_sql
         EXECUTE upd_obk03_pre
         IF SQLCA.SQLERRD[3] = 0 THEN
          #FUN-A30116 ADD---------------------------------------
          #INSERT INTO obk_file (obk01,obk02,
          #                      obk03,obk04,obk05,obk06,obk07,obk08,obk09,
          #                      obk11,obkacti)  #CHI-9C0060
          #VALUES (l_oeb.oeb04,l_oea.oea03,   #FUN-610055
          #        l_oeb.oeb11,l_oea.oea02,l_oea.oea23,l_oea.oea21,
          #        l_oeb.oeb05, l_oeb.oeb13, l_oeb.oeb12,
          #        l_obk11,l_obkacti)        #TQC-6A0045 add     #No.MOD-740385 add   #CHI-9C0060
           #LET l_sql="INSERT INTO ",g_dbs,"obk_file (obk01,obk02,",
           LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'obk_file'), #FUN-A50102
                     " (obk01,obk02,",
                                "obk03,obk04,obk05,obk06,obk07,obk08,obk09,",
                                "obk11,obkacti)",
                     "     VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
           CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
           PREPARE ins_obk01_pre FROM l_sql
           EXECUTE ins_obk01_pre USING l_oeb.oeb04,l_oea.oea03,   
                   l_oeb.oeb11,l_oea.oea02,l_oea.oea23,l_oea.oea21,
                   l_oeb.oeb05, l_oeb.oeb13, l_oeb.oeb12,
                   l_obk11,l_obkacti
         END IF
      END IF
 
END FUNCTION
 
#FUNCTION t400sub_bu4() 				#更新產品價格
#   CALL cl_msg("bu4!")                #No.FUN-640248                                                                     
#   CALL cl_msg("")                    #No.FUN-640248
# 
#END FUNCTION
 
FUNCTION t400sub_tqw08_update(p_code,l_oea)
DEFINE  t_oeb      RECORD LIKE oeb_file.*,
        p_code     LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE  l_oea      RECORD LIKE oea_file.*
   DECLARE oeb_conf CURSOR FOR
    SELECT * FROM oeb_file
     WHERE oeb01 = l_oea.oea01
       AND oeb1003='2'
    OPEN oeb_conf
    FOREACH oeb_conf INTO t_oeb.*
      IF STATUS THEN
         CALL cl_err('foreach oeb',STATUS,0)
         LET g_success = 'N'   #FUN-890128
         RETURN 
      END IF  
      IF p_code=1 THEN                                                                                                              
         IF t_oeb.oeb1010='N' THEN                                                                                                  
            UPDATE tqw_file SET tqw08=tqw08+t_oeb.oeb14                                                                             
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         ELSE                                                                                                                       
            UPDATE tqw_file SET tqw08=tqw08+t_oeb.oeb14t                                                                            
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         END IF                                                                                                                     
      ELSE                                                                                                                          
         IF t_oeb.oeb1010='N' THEN                                                                                                  
            UPDATE tqw_file SET tqw08=tqw08-t_oeb.oeb14                                                                             
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         ELSE                                                                                                                       
            UPDATE tqw_file SET tqw08=tqw08-t_oeb.oeb14t                                                                            
             WHERE tqw01=t_oeb.oeb1007                                                                                              
         END IF                                                                                                                     
      END IF  
    END FOREACH
END FUNCTION
 
FUNCTION t400sub_refresh(p_oea01)
  DEFINE p_oea01 LIKE oea_file.oea01
  DEFINE l_oea RECORD LIKE oea_file.*
 
  SELECT * INTO l_oea.* FROM oea_file WHERE oea01 = p_oea01
  RETURN l_oea.*
END FUNCTION
 
 
 
 
#FUNCTION t400sub_exp(p_oea01,p_tag,p_buf)   #TQC-730022
FUNCTION t400sub_exp(p_oea01,p_buf,l_plant,p_fno)   #TQC-730022
  DEFINE p_oea01  LIKE oea_file.oea01,   #TQC-730022
         p_tag    LIKE type_file.chr1,   #TQC-730022
         l_buf    LIKE oay_file.oayslip, #TQC-730022
         p_buf    LIKE oay_file.oayslip  #TQC-730022
  DEFINE l_pmk RECORD LIKE pmk_file.*    #TQC-730022
  
  DEFINE l_plant  LIKE azw_file.azw01   #FUN-A30116 ADD
  DEFINE l_pmk01  LIKE pmk_file.pmk01,
         l_oea40  LIKE oea_file.oea40
  DEFINE l_oeb12  LIKE oeb_file.oeb12
  DEFINE l_oeb28  LIKE oeb_file.oeb28
  DEFINE l_oeb24  LIKE oeb_file.oeb24
  DEFINE l_oeb48  LIKE oeb_file.oeb48
  DEFINE l_oeb03  LIKE oeb_file.oeb03  #TQC-730022
 #DEFINE l_sql    STRING 
  DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cnt1   LIKE type_file.num5    #No.CHI-840016
  DEFINE tm RECORD
         wc       STRING,                 #MOD-960117
         oeb01    LIKE oeb_file.oeb01,
         oeb03    LIKE oeb_file.oeb03,
         slip     LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
         END RECORD 
  DEFINE l_slip  LIKE oay_file.oayslip #FUN-730018
  DEFINE l_prog_t STRING
  DEFINE l_oea   RECORD LIKE oea_file.*
  DEFINE l_gfa   RECORD LIKE gfa_file.*
  DEFINE p_row,p_col LIKE type_file.num5
  DEFINE li_cnt   LIKE type_file.num5     #No.FUN-870033
  DEFINE li_success   STRING              #No.FUN-870033  
  DEFINE p_fno    LIKE oga_file.oga16
 
  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730018
 
  #FUN-A30116 ADD--------------------- 
   LET g_fno = p_fno  
   LET p_plant =l_plant
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
  #CALL s_getlegal(l_azw01) RETURNING l_legal
   CALL s_getlegal(l_plant) RETURNING p_legal  #FUN-A70048
  #FUN-A30116 END--------------------

   #重新讀取資料
  #FUN-A30116 ADD---------------------
  #SELECT * INTO l_oea.* FROM oea_file
  # WHERE oea01=p_oea01
   #LET l_sql="SELECT * FROM ",g_dbs,"oea_file",
   LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
             " WHERE oea01='",p_oea01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
   PREPARE sel_oea_new FROM l_sql
   EXECUTE sel_oea_new INTO l_oea.*
  #FUN-A30116 END--------------------
  #IF p_tag = 'A' THEN  #由自動拋轉CALL 的
  #  #截取單據別
  #  LET l_buf = s_get_doc_no(l_oea.oea01)
  #  #取自動化設定值
  #  SELECT * INTO l_gfa.*  FROM gfa_file
  #    WHERE gfa01 = '1'   #1:axmt410
  #      AND gfa02 = l_buf
  #      AND gfa03 = 'apmt420'
  #      AND gfaacti = 'Y'
  #  IF cl_null(l_gfa.gfa05) THEN RETURN END IF  #如果無設定單據自動化的資料就不再往下執行
  #END IF
 
  #IF cl_null(l_oea.oea01) THEN RETURN END IF
  #IF l_oea.oea00 = '0' AND l_oea.oea00="A" THEN RETURN END IF  #No.FUN-610053
  #FUN-A30116 mark END--------------------
#  IF l_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
#  IF l_oea.oeaconf = 'N' THEN
#     CALL cl_err('','axm-184',0)
#     RETURN
#  END IF
 
 
 
  #此訂單已拋採購單,就不可以再次拋轉
  # 單據自動化要產生的且為自動產生的
     #此訂單已拋請購單,就不可以再次拋轉                                         
   LET tm.slip = p_buf      #FUN-A30116 ADD
   LET tm.wc = "oeb01 = '",l_oea.oea01 CLIPPED,"'"  #ADD

   LET l_oeb12 = 0
   LET l_oeb28 = 0
   LET l_oeb24 = 0
 
   LET l_sql = "SELECT DISTINCT oeb03,oeb12,oeb28,oeb24,oeb48 ",  #TQC-730022 add oeb03
              #"  FROM oeb_file ",
               #"  FROM ",g_dbs,"oeb_file ",
               "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
               " WHERE ",tm.wc 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE t400sub_exp_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_pre',STATUS,1) END IF
   DECLARE t400sub_exp_c CURSOR FOR t400sub_exp_pre
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_c',STATUS,1) END IF
   LET g_oeb03 = 0    #MOD-910210 #FUN-BB0108 mark
   LET l_cnt = 1      #FUN-AC0006 add
   FOREACH t400sub_exp_c INTO l_oeb03,l_oeb12,l_oeb28,l_oeb24,l_oeb48  #訂單數量/己轉請購量/己交量   #TQC-730022 add oeb03
   IF g_success = "N" THEN                                                                                                        
      LET g_totsuccess = "N"                                                                                                      
      LET g_success = "Y"                                                                                                         
   END IF                                                                                                                         
     IF l_oeb12 - l_oeb28 <= 0 THEN
         CONTINUE FOREACH
     ELSE
        #FUN-AC0006 add --------------------------begin--------------------------------
        #CALL t400sub_ins_pmk(tm.slip,l_oea.oea84) RETURNING l_pmk01 #FUN-870007       #FUN-AC0006 mark 
        #CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)  #TQC-730022加項次避免重覆  #FUN-AC0006 mark
        IF l_cnt = 1 THEN   #改成标准写法,同一张订单产生同一张请购单
          #CALL t400sub_ins_pmk(tm.slip,l_oea.oea84) RETURNING l_pmk01   #mark
           CALL t400sub_ins_pmk(tm.slip,l_oea.oea84,l_oea.oea72) RETURNING l_pmk01   #FUN-BB0108 add
           CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)  #加項次避免重覆 
        ELSE
           CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)  #加項次避免重覆
        END IF
        LET l_cnt = l_cnt + 1
        #FUN-AC0006 add ---------------------------end---------------------------------
     END IF
     #FUN-A30116 ADD-------------
     IF l_oeb48='1' THEN
        IF g_success ='Y' THEN
          #CALL t420sub_y_upd(l_pmk01,'',p_plant) #FUN-B50002 mark
           CALL t420sub_y_upd(l_pmk01,'',p_plant,g_oeb03) #FUN-B50002 add
        END IF
     END IF 
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                       
      LET g_success="N"                                                                                                           
   END IF                                                                                                                         
   CALL t400sub_upd_oea(l_pmk01,l_oea.oea01)
   IF g_success = 'Y' THEN
       LET l_prog_t = g_prog
       LET g_prog = 'apmt420'
       LET g_prog = l_prog_t
       #MESSAGE "已轉請購單號:",l_pmk01 #FUN-730018
   ELSE
      RETURN
      LET l_oea.oea40 = ''
   END IF
END FUNCTION
 
FUNCTION t400sub_upd_oea(p_pmk01,l_oea01)
 DEFINE p_pmk01 LIKE pmk_file.pmk01
 DEFINE l_oea40 LIKE oea_file.oea40
 DEFINE l_oea01 LIKE oea_file.oea01
 
   LET l_oea40 = p_pmk01
   #LET l_sql="UPDATE ",g_dbs,"oea_file SET oea40 = '",l_oea40,"'",
   LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
             "   SET oea40 = '",l_oea40,"'",
             " WHERE oea01 = '",l_oea01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
   PREPARE upd_oea40_pre FROM l_sql
   EXECUTE upd_oea40_pre  
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_errno = SQLCA.sqlcode   #FUN-BB0120 add
      LET g_showmsg=g_plant_new,"/",g_fno,"/",l_oea01
      CALL s_errmsg("shop,fno,oea01",g_showmsg,"UPD oea_file",SQLCA.sqlcode,1)           #No.FUN-710046
      #TQC-B20181 add begin-----------  
     #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark                     
      LET g_msg1='posdg'||'UPD oea_file'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','POSDG',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      #TQC-B20181 add end-------------
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
#FUNCTION t400sub_ins_pmk(l_slip,p_oea84)  #FUN-BB0108 mark
FUNCTION t400sub_ins_pmk(l_slip,p_oea84,p_oea72)    #FUN-BB0108 add
 DEFINE l_pmk    RECORD LIKE pmk_file.*
 DEFINE li_result LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_slip   LIKE type_file.chr5
 DEFINE p_oea84 LIKE oea_file.oea84  #No.FUN-870007
 DEFINE p_oea72 LIKE oea_file.oea72  #FUN-BB0108 add
 
   INITIALIZE l_pmk.* TO NULL
        
       #CALL s_auto_assign_no("apm",l_slip,g_today,"","pmk_file","pmk01","","","")             #No.FUN-560132
       #CALL s_auto_assign_no("apm",l_slip,g_today,"","pmk_file","pmk01",p_plant,"","")             #No.FUN-560132  #FUN-BB0108 mark
        CALL s_auto_assign_no("apm",l_slip,p_oea72,"","pmk_file","pmk01",p_plant,"","")       #FUN-BB0108 add
        RETURNING li_result,l_pmk.pmk01
   LET l_pmk.pmk02 = 'REG'       #單號性質
   LET l_pmk.pmk03 = '0'
   LET l_pmk.pmk04 = g_today     #請購日期
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk18 = 'N'
   LET l_pmk.pmk25 = '0'         #開立
   LET l_pmk.pmk27 = g_today
   LET l_pmk.pmk30 = 'Y'
   LET l_pmk.pmk40 = 0           #總金額
   LET l_pmk.pmk401= 0           #總金額
   LET l_pmk.pmk42 = 1           #匯率
   LET l_pmk.pmk43 = 0           #稅率
   LET l_pmk.pmk45 = 'Y'         #可用
  #SELECT smyapr,smysign INTO l_pmk.pmkmksg,l_pmk.pmksign   #NO:5012
  #  FROM smy_file
  # WHERE smyslip = l_slip
   #LET l_sql="SELECT smyapr,smysign FROM ",g_dbs,"smy_file",
   LET l_sql="SELECT smyapr,smysign FROM ",cl_get_target_table(g_plant_new,'smy_file'), #FUN-A50102
             " WHERE smyslip = '",l_slip,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
   PREPARE sel_smyapr_pre FROM l_sql
   EXECUTE sel_smyapr_pre INTO l_pmk.pmkmksg,l_pmk.pmksign

   IF SQLCA.sqlcode OR cl_null(l_pmk.pmkmksg) THEN
      LET l_pmk.pmkmksg = 'N'
      LET l_pmk.pmksign= NULL
   END IF
   LET l_pmk.pmkdays = 0         #簽核天數
   LET l_pmk.pmksseq = 0         #應簽順序
   LET l_pmk.pmkprno = 0         #列印次數
   CALL signm_count(l_pmk.pmksign) RETURNING l_pmk.pmksmax
   LET l_pmk.pmkacti ='Y'        #有效的資料
   LET l_pmk.pmkuser = g_user    #使用者
   LET l_pmk.pmkgrup = g_grup    #使用者所屬群
   LET l_pmk.pmkdate = g_today
   IF g_azw.azw04='2' THEN
      LET l_pmk.pmk46='3'
      LET l_pmk.pmk47=p_oea84
   ELSE
      LET l_pmk.pmk46='1'
      LET l_pmk.pmk47=''
   END IF
   #LET l_pmk.pmk49= ''  #FUN-A70048
   LET l_pmk.pmkcond= ''             #審核日期
   LET l_pmk.pmkconu= ''             #審核時間
   LET l_pmk.pmkcrat= g_today        #資料創建日
  #LET l_pmk.pmkplant = g_plant        #機構別  #FUN-A70048 mark
  #LET l_pmk.pmklegal = g_legal        #FUN-980010 add
   LET l_pmk.pmkplant = p_plant        #機構別
   LET l_pmk.pmklegal = p_legal        #FUN-A70048 ADD
   LET l_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04

  #INSERT INTO pmk_file VALUES(l_pmk.*)     #DISK WRITE
   DELETE FROM pmk_temp
   INSERT INTO pmk_temp VALUES(l_pmk.*)
   #LET l_sql=" INSERT INTO ",g_dbs,"pmk_file SELECT * FROM pmk_temp"
   LET l_sql=" INSERT INTO ",cl_get_target_table(g_plant_new,'pmk_file'), #FUN-A50102
             " SELECT * FROM pmk_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102 
   PREPARE ins_pmk_pre FROM l_sql
   EXECUTE ins_pmk_pre
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_errno = SQLCA.sqlcode   #FUN-BB0120 add
      LET g_showmsg=g_plant_new,"/",g_fno,"/",l_pmk.pmk01
      CALL s_errmsg("shop,fno,pmk01",g_showmsg,"ins pmk",SQLCA.sqlcode,1)        #No.FUN-710046
      #TQC-B20181 add begin-----------  
     #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark                     
      LET g_msg1='pmk_file'||'ins pmk'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','POSFAB',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      #TQC-B20181 add end-------------
      LET g_success = 'N'
      LET l_pmk.pmk01 =NULL  #ADD
   END IF           #NO.FUN-670007  add
   RETURN l_pmk.pmk01
 
END FUNCTION        #NO.FUN-670007  add
 
FUNCTION t400sub_ins_pml_exp(l_pmk01,p_oea01,p_oeb03)
 DEFINE l_pmk01  LIKE pmk_file.pmk01   
 DEFINE l_oeo    RECORD LIKE oeo_file.*
 DEFINE l_oeb03  LIKE oeb_file.oeb03  #No.+186 add
 DEFINE p_oeb03  LIKE oeb_file.oeb03  #TQC-730022 add
 DEFINE l_qty    LIKE oeb_file.oeb12
 DEFINE l_oeb01  LIKE oeb_file.oeb01  #NO.FUN-670007
 DEFINE l_oeb    RECORD LIKE oeb_file.*
 DEFINE p_oea01  LIKE oea_file.oea01
 
      #LET l_sql=" SELECT * FROM ",g_dbs,"oeb_file",
      LET l_sql=" SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                " WHERE oeb01 ='",p_oea01,"'",
                "   AND oeb03 ='",p_oeb03,"'",     #TQC-730022 add
                "   AND oeb1003!='2'"  #TQC-640085
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
      PREPARE t400sub_oeb_pre1 FROM l_sql
      DECLARE t400sub_oeb_curs1 CURSOR FOR t400sub_oeb_pre1
      FOREACH t400sub_oeb_curs1 INTO l_oeb.*
         IF SQLCA.sqlcode THEN
            LET g_errno = SQLCA.sqlcode   #FUN-BB0120 add
            CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)  #No.FUN-710046
            #TQC-B20181 add begin-----------  
           #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark                     
	    LET g_msg1='oeb_file'||'foreach'||g_plant_new||g_fno   
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','POSDH',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET g_oeb03 = g_oeb03+1   #MOD-910210
          CALL t400sub_ins_pml(l_pmk01,l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb04,    #NO.FUN-670007
                            l_oeb.oeb05_fac,l_oeb.oeb12,l_oeb.oeb15,
                            l_oeb.oeb05,l_oeb.oeb06,
                            l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
                            l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
                            l_oeb.oeb916,l_oeb.oeb917,
                            l_oeb.oeb41,l_oeb.oeb42,l_oeb.oeb43,l_oeb.oeb1001,   #FUN-810045
                            g_oeb03,l_oeb.oeb44   #MOD-910210 #No.FUN-870007-add oeb44
                            ) #BugNo:6097
       # DECLARE oeo_cus CURSOR FOR
       #     SELECT *
       #       FROM oeo_file
       #      WHERE oeo01 = p_oea01
       #        AND oeo03 = l_oeb.oeb03
       # FOREACH oeo_cus INTO l_oeo.*
       #      IF SQLCA.SQLCODE THEN
       #         CALL s_errmsg('','',"sel oeo:",SQLCA.sqlcode,0)   #No.FUN-710046
       #      END IF
       #      LET g_oeb03 = g_oeb03+1   #MOD-910210
       #      LET l_qty = l_oeb.oeb12 * l_oeo.oeo06
       #       #CALL t400sub_ins_pml(l_pmk01,l_oeb01,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-910210   #MOD-A20119
       #       CALL t400sub_ins_pml(l_pmk01,l_oeb.oeb01,l_oeb.oeb03,l_oeo.oeo04,    #NO.FUN-670007    #MOD-910210   #MOD-A20119
       #                         l_oeb.oeb05_fac,l_qty,l_oeb.oeb15,
       #                         l_oeo.oeo05,l_oeo.oeo04,
       #                         l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
       #                         l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
       #                         l_oeb.oeb916,l_oeb.oeb917,
       #                         l_oeb.oeb41,l_oeb.oeb42,l_oeb.oeb43,l_oeb.oeb1001,   #FUN-810045
       #                         g_oeb03,l_oeb.oeb44   #MOD-910210 #No.FUN-870007-add oeb44
       #                         ) #BugNo:6097
       # END FOREACH
      END FOREACH
 
END FUNCTION
 
FUNCTION t400sub_pml_ini(p_pmk01)
  DEFINE p_pmk01 LIKE pmk_file.pmk01,
         l_pmk02 LIKE pmk_file.pmk02,
         l_pmk25 LIKE pmk_file.pmk25,
         l_pmk13 LIKE pmk_file.pmk13
  DEFINE l_pml   RECORD LIKE pml_file.*
 
   INITIALIZE l_pml.* TO NULL     #MOD-720009
   #LET l_sql = "SELECT pmk02,pmk25,pmk13 FROM ",g_dbs,"pmk_file WHERE pmk01 = '",p_pmk01,"'" 
   LET l_sql = "SELECT pmk02,pmk25,pmk13 FROM ",cl_get_target_table(g_plant_new,'pmk_file'), #FUN-A50102
               " WHERE pmk01 = '",p_pmk01,"'" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE sel_pmk02_pre FROM l_sql
   EXECUTE sel_pmk02_pre INTO l_pmk02,l_pmk25,l_pmk13
   LET l_pml.pml01 = p_pmk01               LET l_pml.pml011 = l_pmk02
   LET l_pml.pml16 = l_pmk25
   LET l_pml.pml14 = g_sma.sma886[1,1]     LET l_pml.pml15  =g_sma.sma886[2,2]
   LET l_pml.pml23 = 'Y'                   LET l_pml.pml38  ='Y'
   LET l_pml.pml43 = 0                     LET l_pml.pml431 = 0
   LET l_pml.pml11 = 'N'                   LET l_pml.pml13  = 0
   LET l_pml.pml21  = 0
   LET l_pml.pml30 = 0                     LET l_pml.pml32 = 0
   LET l_pml.pml930=s_costcenter(l_pmk13) #FUN-730018
  #LET l_pml.pmlplant=g_plant  #No.FUN-870007
  #LET l_pml.pmllegal=g_legal  #No.FUN-870007
   LET l_pml.pmlplant=p_plant  #No.FUN-A70048 ADD
   LET l_pml.pmllegal=p_legal  #No.FUN-A70048
   RETURN l_pml.*
END FUNCTION
 
FUNCTION t400sub_ins_pml(p_pmk01,p_oeb01,p_oeb03,p_oeb04,p_oeb05_fac,p_oeb12,  #NO.FUN-670007
                         p_oeb15,p_oeb05,p_oeb06,   #NO.FUN-670007
                         p_oeb910,p_oeb911,p_oeb912,p_oeb913,p_oeb914,
                         p_oeb915,p_oeb916,p_oeb917,p_oeb41,p_oeb42,p_oeb43,p_oeb1001,p_oeb03_2,p_oeb44)  #FUN-810045 add oeb41-43/1001   #MOD-910210 增加p_oeb03_2 #No.FUN-870007-add oeb44
  DEFINE p_pmk01     LIKE pmk_file.pmk01,
         p_oeb01     LIKE oeb_file.oeb01,    #NO.FUN-670007
         p_oeb03     LIKE oeb_file.oeb03,
         p_oeb04     LIKE oeb_file.oeb04,
         p_oeb05_fac LIKE oeb_file.oeb05_fac,
         p_oeb05     LIKE oeb_file.oeb05,
         p_oeb06     LIKE oeb_file.oeb06,
         p_oeb12     LIKE oeb_file.oeb12,
         p_oeb15     LIKE oeb_file.oeb15,
         p_oeb28     LIKE oeb_file.oeb28,    #NO.FUN-670007
         p_oeb24     LIKE oeb_file.oeb24,    #NO.FUN-670007 
         p_oeb910    LIKE oeb_file.oeb910,
         p_oeb911    LIKE oeb_file.oeb911,
         p_oeb912    LIKE oeb_file.oeb912,
         p_oeb913    LIKE oeb_file.oeb913,
         p_oeb914    LIKE oeb_file.oeb914,
         p_oeb915    LIKE oeb_file.oeb915,
         p_oeb916    LIKE oeb_file.oeb916,
         p_oeb917    LIKE oeb_file.oeb917,
         p_oeb41     LIKE oeb_file.oeb41,
         p_oeb42     LIKE oeb_file.oeb42,
         p_oeb43     LIKE oeb_file.oeb43,
         p_oeb1001   LIKE oeb_file.oeb1001,
         p_oeb03_2   LIKE oeb_file.oeb03,   #MOD-910210
         p_oeb44     LIKE oeb_file.oeb44,   #No.FUN-870007
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
#         l_ima262    LIKE ima_file.ima262, #FUN-A20044
         l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima913    LIKE ima_file.ima913,   #CHI-6A0016
         l_ima914    LIKE ima_file.ima914,   #CHI-6A0016
         l_pan       LIKE type_file.num10,   #No.FUN-680137 INTEGER
         l_flag      LIKE type_file.chr1,    #No.TQC-740351
         l_double    LIKE type_file.num10    #No.FUN-680137 INTEGER
   DEFINE l_pml      RECORD LIKE pml_file.*  #FUN-730018
   DEFINE l_oeb      RECORD LIKE oeb_file.*  #FUN-730018
   DEFINE l_pmli     RECORD LIKE pmli_file.* #No.FUN-830132 add
   DEFINE l_rty03 LIKE rty_file.rty03        #No.FUN-870007                                                               
   DEFINE l_rty06 LIKE rty_file.rty06        #No.FUN-870007
 
   CALL t400sub_pml_ini(p_pmk01) RETURNING l_pml.* #FUN-730018
 
   LET l_ima913 = 'N'   #MOD-770033 add
   IF p_oeb04[1,4] <> "MISC" THEN
       LET l_sql="SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac,", #FUN-A20044
                 "       ima45,ima46,ima49,ima491,",
                 "       ima913,ima914 ",         #CHI-6A0016
                 #"  FROM ",g_dbs,"ima_file",
                 "  FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                 " WHERE ima01 = '",p_oeb04,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
       PREPARE sel_ima01_pre FROM l_sql
       EXECUTE sel_ima01_pre INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914 
      #CALL s_getstock(p_oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 #FUN-A30116 MARK
       IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.sqlcode   #FUN-BB0120 add
           LET g_showmsg=g_plant_new,"/",g_fno,"/",p_oeb04
           CALL s_errmsg("shop,fno,ima01",g_showmsg,"sel ima:",SQLCA.sqlcode,1)     #No.FUN-710046
           #TQC-B20181 add begin-----------  
          #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark                     
	   LET g_msg1='ima_file'||'sel ima'||g_plant_new||g_fno   
	   CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	   LET g_msg=g_msg[1,255]
	   CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','POSDG',g_errno,g_msg,'0','N',g_msg1)
	   LET g_errno=''
	   LET g_msg=''
	   LET g_msg1=''
           #TQC-B20181 add end-------------
           LET g_success = 'N'
           RETURN
       END IF
       LET l_pml.pml02 = p_oeb03_2   #MOD-910210
       LET l_pml.pml49 = p_oeb44    #No.FUN-870007
       LET l_pml.pml04 = l_ima01
       LET l_pml.pml041= l_ima02
       LET l_pml.pml05 = NULL      #no.4649(APS單據編號)
       LET l_pml.pml07 = l_ima44      #No.TQC-740351
       LET l_pml.pml08 = l_ima25
      #CALL s_umfchk(l_pml.pml04,l_pml.pml07,                                                                                     
      #     l_pml.pml08) RETURNING l_flag,l_pml.pml09                                                                             
       CALL s_umfchkm(l_pml.pml04,l_pml.pml07,                                                                                     
            l_pml.pml08,p_plant) RETURNING l_flag,l_pml.pml09                                                                             
            IF cl_null(l_pml.pml09) THEN LET l_pml.pml09=1 END IF
      #先將訂單數量轉換成請購單位數量                                                                                               
       LET p_oeb12 = p_oeb12 * p_oeb05_fac / l_pml.pml09
       LET p_oeb28=0
       LET p_oeb24=0
       #LET l_sql="SELECT oeb28,oeb24 FROM ",g_dbs,"oeb_file ",
       LET l_sql="SELECT oeb28,oeb24 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                 " WHERE oeb01='",p_oeb01,"'",
                 "   AND oeb03='",p_oeb03,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
       PREPARE sel_oeb28_pre FROM l_sql
       EXECUTE sel_oeb28_pre INTO p_oeb28,p_oeb24 
       IF cl_null(p_oeb28) THEN LET p_oeb28 = 0 END IF
       IF cl_null(p_oeb24) THEN LET p_oeb24 = 0 END IF
       LET p_oeb12 = (p_oeb12-p_oeb28-p_oeb24) 
       LET l_pml.pml42 = '0'
       LET l_pml.pml20 = p_oeb12
       LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)  #FUN-910088--add--
       LET l_pml.pml35 = p_oeb15                 #到庫日期
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34 #No.TQC-640132
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33  #No.TQC-640132
   END IF
   LET l_pml.pml80 = p_oeb910
   LET l_pml.pml81 = p_oeb911
   LET l_pml.pml82 = p_oeb912
   LET l_pml.pml83 = p_oeb913
   LET l_pml.pml84 = p_oeb914
   LET l_pml.pml85 = p_oeb915
   LET l_pml.pml86 = p_oeb916
   LET l_pml.pml12 = p_oeb41
   LET l_pml.pml121 = p_oeb42
   LET l_pml.pml122 = p_oeb43
   LET l_pml.pml90 = p_oeb1001
   IF g_sma.sma116 MATCHES'[13]' THEN
      LET l_pml.pml86 = p_oeb916
   ELSE
      LET l_pml.pml86 = l_pml.pml07
   END IF
   LET g_pml.* = l_pml.*      #No.TQC-740351
   CALL t400_set_pml87()      #No.TQC-740351
   LET l_pml.pml87=g_pml.pml87      #No.TQC-740351
   LET l_pml.pml87 = s_digqty(l_pml.pml87,l_pml.pml86)    #FUN-910088--add--
   LET l_pml.pml190 = l_ima913    #統購否
   LET l_pml.pml191 = l_ima914    #採購成本中心
   LET l_pml.pml192 = 'N'         #拋轉否
 
   LET l_pml.pml24 = p_oeb01
   LET l_pml.pml25 = p_oeb03
   IF g_azw.azw04='2' THEN
      LET l_pml.pml47 = ''
      SELECT rty03,rty06 INTO l_rty03,l_rty06 FROM rty_file                                                                     
       WHERE rty01=p_plant AND rty02=p_oeb04                                                                            
      IF SQLCA.sqlcode=100 THEN         
#MOD-B80035 -----------------STA                                                                                  
#        LET l_rty03=NULL                                                                                                   
#        LET l_rty06=NULL       
         LET l_rty03= ' '
         LET l_rty06= '1'
#MOD-B80035 -----------------END                                                                                            
      END IF                                                                                                              
      LET l_pml.pml49=l_rty06                                                                                                 
      LET l_pml.pml50=l_rty03                                                                                                 
      IF l_pml.pml50='2' THEN                                                                                                 
         LET l_pml.pml51=p_plant                                                                                         
         LET l_pml.pml52=p_pmk01                                                                                          
         LET l_pml.pml53=l_pml.pml02                                                                                    
      ELSE                                                                                                                          
         LET l_pml.pml51=''                                                                                                   
         LET l_pml.pml52=''                                                                                                   
         LET l_pml.pml53=''                                                                                                   
      END IF           
      LET l_sql="SELECT rty05 FROM rty_file",
                #" WHERE rty01= (SELECT oea84 FROM ",g_dbs,"oea_file WHERE oea01='",p_oeb01,"')",
                " WHERE rty01= (SELECT oea84 FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea01='",p_oeb01,"')",
                "   AND rtyacti='Y' AND rty02='",p_oeb04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
      PREPARE sel_rty05_pre FROM l_sql
      EXECUTE sel_rty05_pre INTO l_pml.pml48
      IF SQLCA.sqlcode=100 THEN
         SELECT rty05 INTO l_pml.pml48 FROM rty_file                                                                 
          WHERE rty01=p_plant AND rtyacti='Y' AND rty02=p_oeb04                                                  
         IF SQLCA.sqlcode=100 THEN                                                                                              
            LET l_pml.pml48=null                                                                                          
         END IF  
      END IF                                                                                                                
      LET l_pml.pml54='2'
   ELSE
      LET l_pml.pml47=''
      LET l_pml.pml48=''
      LET l_pml.pml49='1'
      LET l_pml.pml50='1'
      LET l_pml.pml51=''
      LET l_pml.pml52=''
      LET l_pml.pml53=''
      LET l_pml.pml54=' '
   END IF                                                                                       
   LET l_pml.pml56 = '1'  #bnl
   LET l_pml.pml91 = ' '  #FUN-980010 add 給初始值
   LET l_pml.pml92 = 'N' #FUN-9B0023 
  #INSERT INTO pml_file VALUES(l_pml.*)
   
   DELETE FROM pml_temp
   INSERT INTO pml_temp VALUES(l_pml.*)
   #LET l_sql=" INSERT INTO ",g_dbs,"pml_file SELECT * FROM pml_temp"
   LET l_sql=" INSERT INTO ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
             " SELECT * FROM pml_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102    
   PREPARE ins_pml_pre FROM l_sql
   EXECUTE ins_pml_pre
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode   #FUN-BB0120 add
      LET g_showmsg=g_plant_new,"/",g_fno,"/",l_pml.pml01
      CALL s_errmsg("shop,fno,pml01",g_showmsg,"INS pml_file",SQLCA.sqlcode,1)          #No.FUN-710046
      #TQC-B20181 add begin-----------  
     #LET g_errno=SQLCA.sqlcode     #FUN-BB0120 mark                      
      LET g_msg1='pml_file'||'INS pml_file'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','POSDG',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      #TQC-B20181 add end-------------
      LET g_success = 'N'
   END IF
  #LET l_sql=" SELECT SUM(pml20)",  #FUN-B40088 mark
   LET l_sql=" SELECT COALESCE(SUM(pml20),0)",  #FUN-B40088 add
             #"   FROM ",g_dbs,"pml_file,",g_dbs,"pmk_file",
             "   FROM ",cl_get_target_table(g_plant_new,'pml_file'),",",  #FUN-A50102
                        cl_get_target_table(g_plant_new,'pmk_file'),      #FUN-A50102
             "  WHERE pml24 = '",l_pml.pml24,"'",
             "    AND pml25 = '",l_pml.pml25,"'",
             "    AND pml01 = pmk01",
             "    AND pmk18 <> 'X'",
             "    AND pml16 <> '9'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
   PREPARE sel_pml20_pre FROM l_sql
   EXECUTE sel_pml20_pre INTO l_pml.pml20 
   
#要回寫每張訂單的己拋量和請購單號
   #LET l_sql="UPDATE ",g_dbs,"oeb_file SET oeb27 = '",p_pmk01,"',",
   LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
             "   SET oeb27 = '",p_pmk01,"',",
             "       oeb28 = '",l_pml.pml20,"'", 
             " WHERE oeb01 = '",p_oeb01,"'",
             "   AND oeb03 = '",p_oeb03,"'"    
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102                                      #TQC-960155
   PREPARE upd_oeb27_pre FROM l_sql
   EXECUTE upd_oeb27_pre
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode   #FUN-BB0120 add
      LET g_showmsg=g_plant_new,"/",g_fno,"/",p_oeb01,"/",p_oeb03                       #No.FUN-710046
      CALL s_errmsg("shop,fno,oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)    #No.FUN-710046
      #TQC-B20181 add begin-----------  
     #LET g_errno=SQLCA.sqlcode    #FUN-BB0120 mark                       
      LET g_msg1='oeb_file'||'UPD oeb_file'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','POSDH',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      #TQC-B20181 add end-------------
      LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION t400_set_pml87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            g_cnt    LIKE type_file.num5,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE type_file.num20_6
 
    LET l_sql="SELECT ima25,ima44,ima906",
              #"  FROM ",g_dbs,"ima_file",
              "  FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
              " WHERE ima01='",g_pml.pml04,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
    PREPARE sel_ima25_pre FROM l_sql
    EXECUTE sel_ima25_pre INTO l_ima25,l_ima44,l_ima906
    
    IF SQLCA.sqlcode =100 THEN
       IF g_pml.pml04 MATCHES 'MISC*' THEN
          LET l_sql="SELECT ima25,ima44,ima906",
                    #"  FROM ",g_dbs,"ima_file WHERE ima01='MISC'"
                    "  FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                    " WHERE ima01='MISC'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
          CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
          PREPARE sel_misc_pre FROM l_sql
          EXECUTE sel_misc_pre INTO l_ima25,l_ima44,l_ima906
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac2=g_pml.pml84
    LET l_qty2=g_pml.pml85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_pml.pml81
       LET l_qty1=g_pml.pml82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pml.pml20
       CALL s_umfchkm(g_pml.pml04,g_pml.pml07,l_ima44,p_plant)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchkm(g_pml.pml04,l_ima44,g_pml.pml86,p_plant)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_pml.pml87 = l_tot
END FUNCTION
#No.FUN-A30116 
#No.FUN-A60044
